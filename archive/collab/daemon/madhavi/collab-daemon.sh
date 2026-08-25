#!/bin/bash
set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
ROOT="${MATH_COLLAB_ROOT:-$DEFAULT_ROOT}"
CONFIG="${MATH_COLLAB_CONFIG:-$ROOT/collab/daemon/madhavi/config.local}"
RUNTIME="${MATH_COLLAB_RUNTIME:-$ROOT/collab/daemon/madhavi/runtime}"
LOG="$RUNTIME/daemon.log"
SEEN="$RUNTIME/seen-messages.tsv"
LOCK="$RUNTIME/lock"

mkdir -p "$RUNTIME"

stamp() { date -u '+%Y-%m-%dT%H:%M:%SZ'; }
log() { printf '%s\t%s\n' "$(stamp)" "$*" >> "$LOG"; }

if ! mkdir "$LOCK" 2>/dev/null; then
  log "skip: another cycle holds the lock"
  exit 0
fi
trap 'rmdir "$LOCK" 2>/dev/null || true' EXIT

if ! git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  log "fatal: not a git worktree: $ROOT"
  exit 1
fi

REMOTE=origin
BRANCH=main
OWNED_PATHS=("collab/daemon/madhavi" "collab/messages/madhavi")
if [ -f "$CONFIG" ]; then
  # This is trusted local configuration and may define the variables above.
  # shellcheck source=/dev/null
  . "$CONFIG"
fi

cd "$ROOT" || exit 1
current_branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
if [ "$current_branch" != main ] || [ "$BRANCH" != main ]; then
  log "fatal: the collaboration daemon runs only from main"
  exit 1
fi

conflict_message() {
  reason="$1"
  token="$(date -u '+%Y%m%dT%H%M%S')-$$"
  path="collab/messages/madhavi/daemon-conflict-$token.md"
  mkdir -p "$(dirname "$path")"
  apply_patch <<PATCH
*** Begin Patch
*** Add File: $ROOT/$path
---
from: madhavi-daemon
date: $(stamp)
type: challenge
---

Automatic collaboration cycle stopped without overwriting the worktree.

Reason: $reason

Branch: main

Resolve manually; the daemon never rebases, resets, force-pushes, or merges a
dirty/diverged worktree.
*** End Patch
PATCH
  log "conflict-message: $path: $reason"
}

git fetch --prune "$REMOTE" >> "$LOG" 2>&1 || {
  log "fetch failed"
  exit 1
}

upstream="$REMOTE/$BRANCH"
if git show-ref --verify --quiet "refs/remotes/$upstream"; then
  local_head="$(git rev-parse HEAD)"
  remote_head="$(git rev-parse "$upstream")"
  base="$(git merge-base HEAD "$upstream")"
  if [ "$local_head" = "$base" ] && [ "$local_head" != "$remote_head" ]; then
    if [ -n "$(git status --porcelain)" ]; then
      conflict_message "remote advanced, but the shared worktree is dirty"
    elif git merge --ff-only "$upstream" >> "$LOG" 2>&1; then
      log "ingested: $local_head -> $remote_head"
    else
      conflict_message "fast-forward integration failed"
    fi
  elif [ "$remote_head" != "$base" ] && [ "$local_head" != "$base" ]; then
    conflict_message "local and remote histories diverged"
  fi
fi

# Append newly observed collaborator messages to a local ingestion ledger.
# Blob ids make renames/content changes visible without rewriting prior rows.
touch "$SEEN"
find collab/messages -type f -name '*.md' ! -path 'collab/messages/madhavi/*' -print0 |
while IFS= read -r -d '' message; do
  blob="$(git hash-object "$message" 2>/dev/null || true)"
  key="$message	$blob"
  if ! grep -Fqx "$key" "$SEEN"; then
    printf '%s\t%s\t%s\n' "$(stamp)" "$message" "$blob" >> "$RUNTIME/ingested.log"
    printf '%s\n' "$key" >> "$SEEN"
  fi
done

# Never absorb pre-staged user/agent work.
if [ -n "$(git diff --cached --name-only)" ]; then
  log "skip commit: index already contains changes"
  exit 0
fi

committable=()
for owned in "${OWNED_PATHS[@]}"; do
  while IFS= read -r path; do
    [ -n "$path" ] && committable+=("$path")
  done < <(git status --porcelain --untracked-files=all -- "$owned" | sed 's/^...//')
done

if [ "${#committable[@]}" -gt 0 ]; then
  git add -- "${committable[@]}"
  staged="$(git diff --cached --name-only)"
  unsafe=0
  while IFS= read -r path; do
    allowed=0
    for owned in "${OWNED_PATHS[@]}"; do
      case "$path" in "$owned"|"$owned"/*) allowed=1;; esac
    done
    [ "$allowed" -eq 1 ] || unsafe=1
  done <<< "$staged"
  if [ "$unsafe" -ne 0 ]; then
    git restore --staged -- "${committable[@]}"
    conflict_message "allowlist violation while staging owned files"
    exit 1
  fi
  git commit -m "Madhavi daemon: append collaboration cycle output" >> "$LOG" 2>&1 || {
    log "commit failed"
    exit 1
  }
  log "committed owned changes"
fi

git fetch "$REMOTE" "$BRANCH" >> "$LOG" 2>&1 || exit 1
if [ "$(git rev-parse "$REMOTE/$BRANCH")" != "$(git merge-base HEAD "$REMOTE/$BRANCH")" ]; then
  conflict_message "remote advanced before push"
  exit 0
fi
git push "$REMOTE" HEAD:main >> "$LOG" 2>&1 || {
  conflict_message "push rejected"
  exit 1
}
log "pushed main"
