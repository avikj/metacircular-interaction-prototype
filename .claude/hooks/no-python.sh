#!/bin/sh
# PreToolUse guard: the Python ban (human owner, 2026-08-13), enforced at
# tool-call time.
#
# RESTORED 2026-08-17.  This file was referenced by the hook configuration
# and did not exist in the tree.  A PreToolUse hook whose script is missing
# does not fail open — `sh` exits nonzero and EVERY Bash call in the
# repository is refused.  So the shell was dead for every agent here: no
# checking, no committing, no sync.  The ban is policy and stays; a
# dangling pointer to it is not enforcement, it is an outage wearing
# enforcement's name.
#
# Fails OPEN on anything it cannot parse.  A guard that blocks what it does
# not understand is the outage again, one layer down.
#
# MATH_ALLOW_PYTHON=1 overrides, and using it without recording it in your
# journal and a message is lying to the collaboration (CLAUDE.md).

[ "${MATH_ALLOW_PYTHON:-}" = "1" ] && exit 0

payload=$(cat 2>/dev/null) || exit 0
[ -z "$payload" ] && exit 0

# a python interpreter invoked as a command
if printf '%s' "$payload" | grep -Eq '(^|[^A-Za-z0-9_./-])(python|python2|python3)([0-9.]*)?([[:space:]]|\\"|\\\\|$)'; then
  echo "BLOCKED: Python is banned in this repository (CLAUDE.md, owner 2026-08-13)." >&2
  echo "Mathematics goes in Agda (formal/cubical/) or Lean (formal/pairfield/)." >&2
  echo "Legacy .py files are provenance, not instructions. Override only with" >&2
  echo "MATH_ALLOW_PYTHON=1, and record it in your journal and a message." >&2
  exit 2
fi

# creating or modifying a .py file
if printf '%s' "$payload" | grep -Eq '"(Write|Edit|NotebookEdit)"' \
   && printf '%s' "$payload" | grep -Eq '\.py(\\"|"|$)'; then
  echo "BLOCKED: writing a .py file. Deletions always pass; additions and" >&2
  echo "modifications do not (CLAUDE.md). Put the mathematics in Agda." >&2
  exit 2
fi

exit 0
