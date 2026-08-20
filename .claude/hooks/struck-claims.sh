#!/bin/sh
# PreToolUse advisory: fire the STRUCK-CLAIMS ledger at the moment of the
# write, because a stale context never re-opens the document that would
# correct it.
#
# WHY THIS EXISTS.  CLAUDE.md already states the rule this implements:
# "When a rule here is violated repeatedly, the next move is a mechanism
# that fires at the moment of the act, not a paragraph."  The violation
# it was built for happened on 2026-08-19/20 and is worth stating exactly,
# because it is structural and not one agent's carelessness:
#
#   An agent's heartbeat carried a self-authored STANDING STATE whose first
#   line was a claim the owner had struck the previous afternoon
#   (887641a7, the collapse dichotomy).  That block was re-read about
#   twenty times.  CLAUDE.md was re-read zero times.  A self-authored
#   context displaced the governing document, and every correction in the
#   tree was invisible to the loop because the loop reads the agent, not
#   the repository.
#
# So the correction has to travel the other way: not "go and read", but a
# line that appears in the agent's own transcript at the instant it writes
# the struck claim down again.
#
# WHAT IT DOES.  Two content checks, both from failures that happened here:
#
#  1. STRUCK CLAIMS.  Matches the write against .claude/hooks/struck-claims.txt
#     and reports the striking commit and what stands in its place.
#
#  2. QUEUE LANGUAGE.  Reports when a write installs an assignment -- a
#     standing challenge, an open problem, a thing someone "must answer".
#     The frontier here is derived, not listed; an agent wrote an
#     assignment into the persona pool and the owner's verdict on it was
#     "objectively false" (2026-08-20).
#
# ADVISORY ONLY.  Always exits 0; fails open on anything it cannot parse.
# A blocking guard on a judgement call is an outage wearing enforcement's
# name -- no-python.sh learned that here by killing every shell in the repo.

payload=$(cat 2>/dev/null) || exit 0
[ -z "$payload" ] && exit 0

root="${CLAUDE_PROJECT_DIR:-.}"
ledger="$root/.claude/hooks/struck-claims.txt"
[ -r "$ledger" ] || exit 0

# Only on writes into the corpus.  Covers Write/Edit and the `cat > path`
# heredoc form, which is how most prose here is actually written.
printf '%s' "$payload" | grep -Eq \
  'notes/[A-Za-z0-9_./-]*\.md|formal/[A-Za-z0-9_./-]*\.(agda|lean)|machine/[A-Za-z0-9_./-]*\.hs|collab/[A-Za-z0-9_./-]*\.md|README\.md|CLAUDE\.md|minds\.txt' \
  || exit 0

out=""

# --- 1. struck claims -------------------------------------------------
# Read the ledger on fd 3 so the payload pipe is never disturbed.
while IFS='	' read -r pat commit stands <&3; do
  case "$pat" in ''|'#'*) continue ;; esac
  [ -z "$commit" ] && continue
  printf '%s' "$payload" | grep -Eqi "$pat" || continue
  out="$out
  STRUCK  ($commit)
    matched: $pat
    what stands: $stands
"
done 3< "$ledger"

# --- 2. queue language ------------------------------------------------
if printf '%s' "$payload" | grep -Eqi 'standing challenge|must answer|open question for the next|assigned to whoever|the next agent must|this repo must'; then
  out="$out
  QUEUE   the frontier here is derived, not listed (README, CLAUDE.md).
    An assignment written into a shared file is a queue item in a place
    built to have none, and posing one source against another is a
    durnaya.  If it is real work, do it or record it as a residual in
    your own journal -- do not deposit it as an obligation on a stranger.
"
fi

[ -z "$out" ] && exit 0

printf '%s\n' "----- struck-claims (advisory; .claude/hooks/struck-claims.txt) -----"
printf '%s\n' "$out"
printf '%s\n' "  Corrections outrank results here.  If the ledger is wrong, fix the"
printf '%s\n' "  ledger in the same commit and say so.  If it is right, you were"
printf '%s\n' "  about to publish a claim this repository already refuted."
printf '%s\n' "---------------------------------------------------------------------"
exit 0
