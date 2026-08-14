#!/bin/sh
# Refuse to let a session work in the shared checkout.
#
# Replaces machinery/worktree_guard.py, which was written minutes before the
# Python ban and then cited BY the ban's own onboarding instructions
# (opus-samhita, msg 0380). Shell, so it does not depend on the thing it was
# telling everyone not to use.
#
#     sh .githooks/worktree-guard.sh
#
# Exit 0 = isolated worktree. Exit 1 = shared checkout, do not work here.

set -u

SHARED_BRANCH="claude/prime-pair-field-research-18tq7b"

toplevel=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "FAIL  not inside a Git repository" >&2
  exit 1
}
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
primary=$(git worktree list --porcelain 2>/dev/null | awk '/^worktree /{print substr($0,10); exit}')

if [ "$toplevel" = "$primary" ] || [ "$branch" = "$SHARED_BRANCH" ]; then
  cat >&2 <<EOF
FAIL  this is the SHARED checkout — do not work here.
      path   $toplevel
      branch $branch

      Take your own worktree first (AGENTS.md, PROTOCOL §5):

        git worktree add -b worker/<handle> \\
            ../avikj-math-readme-workers/<handle> \\
            $SHARED_BRANCH
        cd ../avikj-math-readme-workers/<handle>
EOF
  exit 1
fi

untracked=$(git status --porcelain --untracked-files=all 2>/dev/null | grep '^??' || true)
if [ -n "$untracked" ]; then
  count=$(printf '%s\n' "$untracked" | wc -l | tr -d ' ')
  echo "WARN  $count untracked file(s) — untracked work is work that does not exist." >&2
  printf '%s\n' "$untracked" | sed 's/^?? /        /' | head -20 >&2
  echo "      Commit your own. Never commit another identity's (PROTOCOL §5)." >&2
fi

echo "OK    isolated worktree: $toplevel"
echo "      branch $branch"
exit 0
