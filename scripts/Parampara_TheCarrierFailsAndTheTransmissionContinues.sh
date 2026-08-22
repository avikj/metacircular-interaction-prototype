#!/usr/bin/env bash
# =====================================================================
# परम्परा — karaṇakṣaye paramparā: the carrier fails, the transmission
# continues.  Push work to origin under contention, from a checkout in
# which sixteen seats are committing at once.
#
#   scripts/Parampara_TheCarrierFailsAndTheTransmissionContinues.sh
#       fetch, merge origin, push the current branch; retry with backoff
#
#   ... -m "message" -- path [path ...]
#       stage EXACTLY those paths, commit with that message, then push
#
#   ... --dry-run          say what it would do; touch nothing
#   ... --tries N          attempts before giving up (default 8)
#   ... --remote R         default origin
#
# ---------------------------------------------------------------------
# WHY THIS FILE EXISTS.  A `git push` from one of sixteen seats in one
# working tree fails for three different reasons that look identical at
# the terminal, and the repair for each is different:
#
#   1. non-fast-forward — another seat pushed between your fetch and your
#      push.  Repair: fetch, merge, push again.  This is the common case
#      and it is what the retry loop is for.
#   2. index.lock / ref lock held — another seat in THIS checkout is
#      mid-command.  Repair: wait.  Retrying immediately makes it worse,
#      so the sleep is real and it grows.
#   3. a merge that would overwrite an uncommitted file — another seat's
#      IN-FLIGHT work is in the tree.  There is NO repair this script may
#      perform.  `git stash` here would silently pocket another
#      identity's unfinished work and hand back a tree they no longer
#      recognise.  So this case stops and names the files.
#
# THE HARD RULES, from CLAUDE.md, enforced here rather than remembered:
# never `git add -A`, never `git add .`, never `git commit -a`, never
# stage or revert a path this invocation did not name.  The commit mode
# below refuses those arguments outright instead of trusting the caller,
# because "the protocol was not in hand at the moment of the act" is this
# repository's own diagnosis of why prose does not hold (CLAUDE.md,
# Regressions).  The same reason `no-python.sh` is a hook and not a
# paragraph.
#
# WHAT IS AND IS NOT CLAIMED OF THE NAME.  paramparā is the tradition's
# word for transmission through a succession of carriers -- teacher to
# student, and in the recitation schools a text held by no single reciter
# but by the agreement of many, which is why the pāṭha variants exist at
# all.  The claim here is the FORM: continuity that does not depend on
# one carrier surviving.  No source says anything about git.
# =====================================================================
set -u

REMOTE=origin
TRIES=8
DRY=0
MSG=""
PATHS=()
mode=push

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY=1; shift ;;
    --tries)   TRIES="${2:?--tries needs a number}"; shift 2 ;;
    --remote)  REMOTE="${2:?--remote needs a name}"; shift 2 ;;
    -m)        MSG="${2:?-m needs a message}"; mode=commit; shift 2 ;;
    --)        shift; PATHS=("$@"); break ;;
    -h|--help) sed -n '2,45p' "$0"; exit 0 ;;
    *) echo "parampara: unknown argument '$1' (see --help)" >&2; exit 2 ;;
  esac
done

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "parampara: not inside a git working tree" >&2; exit 2; }
cd "$ROOT" || exit 2

say() { printf 'parampara: %s\n' "$*"; }
die() { printf 'parampara: %s\n' "$*" >&2; exit 1; }

BRANCH=$(git rev-parse --abbrev-ref HEAD)
[ "$BRANCH" = HEAD ] && die "detached HEAD; check out a branch before pushing"

# --- the forbidden stagings, refused rather than trusted --------------
for p in ${PATHS+"${PATHS[@]}"}; do
  case "$p" in
    -A|--all|.|:/|-a|-u|--update)
      die "refusing '$p'. Stage explicit paths only -- CLAUDE.md forbids
           add -A / add . / commit -a in this shared checkout, because the
           tree contains fifteen other seats' unfinished files." ;;
  esac
done

# --- commit mode: exactly the named paths, nothing else ---------------
if [ "$mode" = commit ]; then
  [ "${#PATHS[@]}" -gt 0 ] || die "-m given with no paths. Usage: -m \"msg\" -- path [path ...]"
  for p in "${PATHS[@]}"; do
    [ -e "$p" ] || git ls-files --error-unmatch -- "$p" >/dev/null 2>&1 \
      || die "path does not exist and is not tracked: $p"
  done
  if [ "$DRY" -eq 1 ]; then
    say "would: git add -- ${PATHS[*]}"
    say "would: git commit -m <msg> -- ${PATHS[*]}"
  else
    git add -- "${PATHS[@]}" || die "git add failed"
    # `commit -- <paths>` commits those paths only, whatever else is staged
    # by another seat between the add and the commit.
    if git commit -q -m "$MSG" -- "${PATHS[@]}"; then
      say "committed $(git rev-parse --short HEAD)  ($((${#PATHS[@]})) path(s))"
    else
      say "nothing to commit in the named paths; continuing to push"
    fi
  fi
fi

# --- the local serialiser ---------------------------------------------
# One checkout, sixteen seats.  `git` takes its own index.lock, but the
# fetch/merge/push SEQUENCE is not atomic under it: two seats can each
# hold a valid lock at different instants and still interleave into a
# livelock of non-fast-forwards.  mkdir is atomic on every filesystem
# here; flock is not portable to this host's BSD userland.
LOCK="$ROOT/.git/parampara.lock"
STALE=300
acquire() {
  local waited=0
  while ! mkdir "$LOCK" 2>/dev/null; do
    if [ -d "$LOCK" ]; then
      local age now mt
      now=$(date +%s)
      mt=$(stat -f %m "$LOCK" 2>/dev/null || stat -c %Y "$LOCK" 2>/dev/null || echo "$now")
      age=$(( now - mt ))
      if [ "$age" -gt "$STALE" ]; then
        say "breaking a lock held ${age}s (> ${STALE}s); its holder is gone"
        rmdir "$LOCK" 2>/dev/null
        continue
      fi
    fi
    [ "$waited" -ge 180 ] && { say "lock held over 180s; proceeding without it"; return 0; }
    sleep 3; waited=$(( waited + 3 ))
  done
  echo "$$ $(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$LOCK/holder" 2>/dev/null
  trap 'rm -f "$LOCK/holder" 2>/dev/null; rmdir "$LOCK" 2>/dev/null' EXIT INT TERM
}

if [ "$DRY" -eq 1 ]; then
  say "dry run: branch $BRANCH -> $REMOTE, $TRIES attempts, no lock taken"
  git fetch -q "$REMOTE" "$BRANCH" 2>/dev/null
  A=$(git rev-list --count "$REMOTE/$BRANCH..$BRANCH" 2>/dev/null || echo ?)
  B=$(git rev-list --count "$BRANCH..$REMOTE/$BRANCH" 2>/dev/null || echo ?)
  say "ahead $A, behind $B"
  exit 0
fi

acquire

# --- fetch, merge, push, with backoff ---------------------------------
attempt=0
sleep_s=2
while [ "$attempt" -lt "$TRIES" ]; do
  attempt=$(( attempt + 1 ))

  if ! git fetch -q "$REMOTE" "$BRANCH" 2>/tmp/parampara.fetch.$$; then
    say "attempt $attempt: fetch failed -- $(tr '\n' ' ' < /tmp/parampara.fetch.$$ | cut -c1-160)"
    sleep "$sleep_s"; sleep_s=$(( sleep_s * 2 )); [ "$sleep_s" -gt 60 ] && sleep_s=60
    continue
  fi

  BEHIND=$(git rev-list --count "$BRANCH..$REMOTE/$BRANCH" 2>/dev/null || echo 0)
  if [ "${BEHIND:-0}" -gt 0 ]; then
    say "attempt $attempt: behind $REMOTE/$BRANCH by $BEHIND; merging"
    if ! git merge --no-edit -q "$REMOTE/$BRANCH" 2>/tmp/parampara.merge.$$; then
      if git ls-files -u | grep -q .; then
        CONF=$(git diff --name-only --diff-filter=U | tr '\n' ' ')
        git merge --abort 2>/dev/null
        die "MERGE CONFLICT, aborted, tree restored. Conflicting paths:
           $CONF
       These are real disagreements between seats and this script will not
       guess at them. Resolve by hand in the conflicting files only, commit
       those explicit paths, and run this script again."
      fi
      # The other stopper: local uncommitted changes in the way.  NOT ours
      # to stash -- another seat is mid-edit in this same tree.
      IN_WAY=$(sed -n 's/^\t//p' /tmp/parampara.merge.$$ | tr '\n' ' ')
      die "merge refused, working tree untouched. git said:
           $(tr '\n' ' ' < /tmp/parampara.merge.$$ | cut -c1-300)
       If this names uncommitted files, they belong to another seat mid-edit.
       Do NOT stash them -- that pockets somebody else's unfinished work.
       Wait for them, or ask on collab/messages, then run this again.
           ${IN_WAY}"
    fi
  fi

  AHEAD=$(git rev-list --count "$REMOTE/$BRANCH..$BRANCH" 2>/dev/null || echo 0)
  if [ "${AHEAD:-0}" -eq 0 ]; then
    say "nothing to push: $BRANCH is level with $REMOTE/$BRANCH"
    rm -f /tmp/parampara.fetch.$$ /tmp/parampara.merge.$$ /tmp/parampara.push.$$
    exit 0
  fi

  if git push -q "$REMOTE" "$BRANCH" 2>/tmp/parampara.push.$$; then
    say "pushed $AHEAD commit(s) to $REMOTE/$BRANCH on attempt $attempt  ($(git rev-parse --short HEAD))"
    rm -f /tmp/parampara.fetch.$$ /tmp/parampara.merge.$$ /tmp/parampara.push.$$
    exit 0
  fi

  REASON=$(tr '\n' ' ' < /tmp/parampara.push.$$ | cut -c1-200)
  say "attempt $attempt/$TRIES: push rejected -- $REASON"
  case "$REASON" in
    *"Permission denied"*|*"Authentication"*|*"could not read Username"*|*"403"*)
      die "credentials, not contention. Retrying will not help. Fix auth, then rerun." ;;
    *"protected branch"*|*"pre-receive hook declined"*)
      die "the remote refused this content, not this race. Read the message above." ;;
  esac
  sleep "$sleep_s"
  sleep_s=$(( sleep_s * 2 )); [ "$sleep_s" -gt 60 ] && sleep_s=60
done

die "did not converge in $TRIES attempts. Your commits are SAFE and local:
       $(git rev-list --count "$REMOTE/$BRANCH..$BRANCH" 2>/dev/null) commit(s) ahead.
     Nothing was discarded. Re-run when contention drops, or push a worker
     branch instead:  git push $REMOTE $BRANCH:worker/<your-identity>"
