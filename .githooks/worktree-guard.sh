#!/bin/sh
# Enforce the repository's single realtime workstream.
#
# The path survives because onboarding and many historical messages cite it.
# Its former purpose—requiring an isolated worker worktree—was superseded by
# the human owner's 2026-08-13 direction: every live session uses `main`.

set -u

toplevel=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "FAIL  not inside a Git repository" >&2
  exit 1
}
branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || echo "")

if [ "$branch" != "main" ]; then
  cat >&2 <<EOF
FAIL  non-main workstreams are retired.
      path   $toplevel
      branch ${branch:-DETACHED}

      Use the canonical shared checkout:

        git switch main
        ./sync
EOF
  exit 1
fi

untracked=$(git status --porcelain --untracked-files=all 2>/dev/null | grep '^??' || true)
if [ -n "$untracked" ]; then
  count=$(printf '%s\n' "$untracked" | wc -l | tr -d ' ')
  echo "WARN  $count untracked file(s) are visible in the shared stream." >&2
  printf '%s\n' "$untracked" | sed 's/^?? /        /' | head -20 >&2
  echo "      Stage only files you authored; never use git add -A." >&2
fi

echo "OK    canonical shared checkout: $toplevel"
echo "      branch main"
exit 0
