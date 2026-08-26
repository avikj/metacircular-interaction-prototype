#!/bin/sh
# check-no-silent-deletion.sh — a commit that removes many tracked ledger
# files must say so in its subject line.
#
# Why this exists: commit 142bba1f ("Sync discovery registry and code/ to main
# exactly") deleted 53 files / 2145 lines of the cf-tessera Smith claim
# registry. Its body announced 38 audit-event JSONs and did not mention the
# other 15 claim files, 1612 of the deleted lines. The deletion is reachable on
# no ref; it was found by an archivist draw, not by any check
#
# This forces DISCLOSURE, not correctness: a commit whose subject truthfully
# says "delete" passes regardless of what it deletes. That is the intended
# contract — the failure mode being guarded is a deletion nobody decided.
#
# Usage:
#   scripts/check-no-silent-deletion.sh                 # HEAD only
#   scripts/check-no-silent-deletion.sh <commit>        # one commit
#   scripts/check-no-silent-deletion.sh <base>..<head>  # a range (CI)
#   scripts/check-no-silent-deletion.sh --pre-push      # HEAD vs origin/main
#
# Env:
#   DELETION_GUARD_N     threshold, default 5 (fires at N+1 ledger deletions)
#   DELETION_GUARD_PATHS ERE of guarded paths, default the ledger roots
#   DELETION_GUARD_MERGES=1  also inspect merge commits against their first
#                        parent (off by default; see the limitation printed
#                        every run)
#
# No Agda, no Lean, no network, no Python. Portable /bin/sh + git + grep.

set -u

N=${DELETION_GUARD_N:-5}
PATHS_RE=${DELETION_GUARD_PATHS:-'^(collab/discovery|notes|papers)/'}
MERGES=${DELETION_GUARD_MERGES:-0}

arg=${1:-HEAD}

if [ "$arg" = "--pre-push" ]; then
  base=$(git merge-base HEAD origin/main 2>/dev/null) || base=
  if [ -z "$base" ]; then
    echo "check-no-silent-deletion: no origin/main merge-base; checking HEAD only" >&2
    arg=HEAD
  else
    arg="$base..HEAD"
  fi
fi

case "$arg" in
  *..*) commits=$(git rev-list "$arg") || exit 2 ;;
  *)    commits=$(git rev-parse --verify "$arg^{commit}") || exit 2 ;;
esac

status=0
n_checked=0
n_merges=0

for c in $commits; do
  subj=$(git log -1 --format=%s "$c")

  # merge? (more than one parent)
  nparents=$(git rev-list --parents -n1 "$c" | wc -w)
  is_merge=0
  [ "$nparents" -gt 2 ] && is_merge=1

  if [ "$is_merge" -eq 1 ] && [ "$MERGES" != "1" ]; then
    n_merges=$((n_merges + 1))
    continue
  fi

  n_checked=$((n_checked + 1))

  # An announcing subject exempts the commit. Matched case-insensitively on
  # the stems delet/remov/prune/retract/drop — bracket classes, not \b, because
  # mawk and BusyBox grep do not implement \b the same way (a sibling gate
  # silently passed everything for exactly that reason).
  case "$subj" in
    *[Dd]elet*|*[Rr]emov*|*[Pp]rune*|*[Rr]etract*|*[Dd]rop*) continue ;;
  esac

  if [ "$is_merge" -eq 1 ]; then
    names=$(git show --diff-merges=first-parent --diff-filter=D --name-only \
              --format='' "$c")
  else
    names=$(git show --diff-filter=D --name-only --format='' "$c")
  fi
  n=$(printf '%s\n' "$names" | grep -c -E "$PATHS_RE")

  if [ "$n" -gt "$N" ]; then
    echo "FAIL check-no-silent-deletion: $c deletes $n tracked ledger files"
    echo "      subject: $subj"
    echo "      subject announces no deletion; say so in the subject line, or"
    echo "      set DELETION_GUARD_N / DELETION_GUARD_PATHS if the scope is wrong."
    printf '%s\n' "$names" | grep -E "$PATHS_RE" | head -10 | sed 's/^/        /'
    [ "$n" -gt 10 ] && echo "        … $((n - 10)) more"
    status=1
  fi
done

echo "check-no-silent-deletion: $n_checked commit(s) checked, threshold N=$N, paths $PATHS_RE"

# Limitation printed EVERY run, pass or fail — a guard must not imply coverage
if [ "$MERGES" = "1" ]; then
  echo "check-no-silent-deletion: merges inspected against their FIRST PARENT only;"
  echo "  a deletion arriving from a side branch is attributed to that branch's own"
  echo "  commits, which are only checked if they are in the range."
else
  echo "check-no-silent-deletion: LIMITATION — $n_merges merge commit(s) SKIPPED."
  echo "  'git show' prints no diff for a merge, so a deletion folded into a merge"
  echo "  RESOLUTION is invisible here. Re-run with DELETION_GUARD_MERGES=1 to"
  echo "  inspect merges against their first parent."
fi
echo "check-no-silent-deletion: this is a subject-line disclosure check, not a"
echo "  correctness check; a commit that says 'delete' passes whatever it deletes."

exit "$status"
