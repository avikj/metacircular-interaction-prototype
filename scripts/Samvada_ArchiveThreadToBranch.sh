#!/usr/bin/env bash
# Samvada archiver — put a rendered thread on a branch of its own, and nowhere else.
#
# THE CONSTRAINT THIS IS BUILT AROUND
#   A Claude Code web session runs in an ephemeral container. Its transcript is
#   written inside that container and reclaimed with it, so a cloud conversation
#   survives only if something copies it somewhere durable first.
#
#   But this repository is a book, and every file in a checkout is something an
#   agent will read, grep, index, and count. Transcripts in the working tree
#   would be noise in the corpus and a distraction to every later reader. So the
#   archive is written with git plumbing straight into the object store and onto
#   a branch nobody checks out:
#
#     - it never creates, moves, or deletes a file in the working tree
#     - it never touches the real index, HEAD, or the branch being worked on
#     - it never runs `git commit`, so pre-commit hooks are not involved
#     - it leaves `git status` exactly as it found it
#     - it copies; the live session is untouched and continues normally
#
#   Nothing in the checkout changes, so nothing about it is visible to an agent
#   reading the repo, and no conversation enters an "archived" state.
#
# USE
#   Samvada_ArchiveThreadToBranch.sh --transcript <path.jsonl> [--session <id>]
#   Samvada_ArchiveThreadToBranch.sh                 # finds this session's own
#
#   branch : claude-transcripts          (override: SAMVADA_BRANCH)
#   path   : transcripts/<YYYYMMDD>_<session-uuid>.txt
#
#   --quiet          say nothing at all (what the Stop hook passes)
#   SAMVADA_ARCHIVE=0        disable entirely
#   SAMVADA_ARCHIVE_PUSH=0   write the branch locally, never reach the remote
#   SAMVADA_EXPORTER=<path>  use a renderer from somewhere other than the checkout,
#                            so a session whose checkout predates this script can
#                            still archive itself without touching its working tree
#
# Every failure path exits 0. An archiver that can interrupt a conversation is
# an outage wearing a feature's name.

TRANSCRIPT=""
SESSION="${CLAUDE_CODE_SESSION_ID:-}"
QUIET=0

while [ $# -gt 0 ]; do
  case "$1" in
    --transcript) TRANSCRIPT="$2"; shift 2;;
    --session) SESSION="$2"; shift 2;;
    --quiet) QUIET=1; shift;;
    *) shift;;
  esac
done

say() { [ "$QUIET" -eq 1 ] || echo "$@"; }
fail() { say "samvada: $*"; exit 0; }

[ "${SAMVADA_ARCHIVE:-1}" = "0" ] && exit 0
command -v jq >/dev/null 2>&1 || fail "jq not available"

ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}"
[ -n "$ROOT" ] && [ -e "$ROOT/.git" ] || fail "not a git repository"
EXPORTER="${SAMVADA_EXPORTER:-$ROOT/scripts/Samvada_ExportClaudeCodeThreadsToText.sh}"
[ -f "$EXPORTER" ] || fail "exporter missing at $EXPORTER"

# Default to this session's own transcript.
if [ -z "$TRANSCRIPT" ]; then
  CDIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects"
  if [ -n "$SESSION" ]; then
    TRANSCRIPT="$(find "$CDIR" -name "${SESSION}.jsonl" -type f 2>/dev/null | head -1)"
  fi
fi
[ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ] || fail "no transcript to archive"
[ -n "$SESSION" ] || SESSION="$(basename "$TRANSCRIPT" .jsonl)"

BR="${SAMVADA_BRANCH:-claude-transcripts}"
TMP="$(mktemp -d 2>/dev/null)" || fail "no temp dir"
trap 'rm -rf "$TMP"' EXIT

# --attachments: the injected file contents and system reminders are where the
# tokens actually go. A transcript without them records the conversation but not
# its cost, and they cannot be reconstructed once the container is gone.
bash "$EXPORTER" --file "$TRANSCRIPT" --attachments --out "$TMP/render" >/dev/null 2>&1 || fail "render failed"
RENDERED="$(find "$TMP/render" -name '*.txt' -type f 2>/dev/null | head -1)"
[ -n "$RENDERED" ] || fail "render produced nothing"

ENTRY="transcripts/$(date -u '+%Y%m%d')_${SESSION}.txt"

cd "$ROOT" || fail "cannot enter $ROOT"
git fetch -q origin "$BR" >/dev/null 2>&1
BASE="$(git rev-parse -q --verify FETCH_HEAD 2>/dev/null)"
[ -n "$BASE" ] || BASE="$(git rev-parse -q --verify "refs/heads/$BR" 2>/dev/null)"

BLOB="$(git hash-object -w "$RENDERED" 2>/dev/null)" || fail "hash-object failed"

# Same bytes already at the tip: nothing to say.
if [ -n "$BASE" ]; then
  PREV="$(git rev-parse -q --verify "$BASE:$ENTRY" 2>/dev/null)"
  [ "$PREV" = "$BLOB" ] && { say "samvada: unchanged since last archive"; exit 0; }
fi

# A temporary index, so the real one is never read or written.
GIT_INDEX_FILE="$TMP/index"; export GIT_INDEX_FILE
if [ -n "$BASE" ]; then
  git read-tree "$BASE" 2>/dev/null || git read-tree --empty 2>/dev/null
else
  git read-tree --empty 2>/dev/null
fi
git update-index --add --cacheinfo "100644,$BLOB,$ENTRY" 2>/dev/null || fail "update-index failed"
TREE="$(git write-tree 2>/dev/null)" || fail "write-tree failed"

: "${GIT_AUTHOR_NAME:=Samvada}"
: "${GIT_AUTHOR_EMAIL:=${CLAUDE_CODE_USER_EMAIL:-samvada@localhost}}"
: "${GIT_COMMITTER_NAME:=$GIT_AUTHOR_NAME}"
: "${GIT_COMMITTER_EMAIL:=$GIT_AUTHOR_EMAIL}"
export GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL

MSG="transcript ${SESSION} @ $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
if [ -n "$BASE" ]; then
  COMMIT="$(printf '%s\n' "$MSG" | git commit-tree "$TREE" -p "$BASE" 2>/dev/null)"
else
  COMMIT="$(printf '%s\n' "$MSG" | git commit-tree "$TREE" 2>/dev/null)"
fi
[ -n "$COMMIT" ] || fail "commit-tree failed"

git update-ref "refs/heads/$BR" "$COMMIT" 2>/dev/null

if [ "${SAMVADA_ARCHIVE_PUSH:-1}" = "0" ]; then
  say "samvada: archived to local branch $BR as $ENTRY ($(wc -c < "$RENDERED") bytes); not pushed"
  exit 0
fi

if [ "$QUIET" -eq 1 ]; then
  # Backgrounded and silent: a turn must never wait on the network.
  ( git push -q origin "$COMMIT:refs/heads/$BR" >/dev/null 2>&1 ) &
  exit 0
fi

if git push -q origin "$COMMIT:refs/heads/$BR" >/dev/null 2>&1; then
  say "samvada: archived $ENTRY ($(wc -c < "$RENDERED") bytes) to origin/$BR"
else
  say "samvada: archived $ENTRY to local branch $BR; push failed (offline or no write access)"
fi
exit 0
