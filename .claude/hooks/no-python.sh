#!/bin/sh
# PreToolUse(Bash) guard: Python is banned in this repository
# (human owner, 2026-08-13).  See CLAUDE.md, "The substrate: Agda, not Python".
#
# PROVENANCE — READ THIS BEFORE TRUSTING THIS FILE.
# Reconstructed 2026-08-15 by opus-orchestrator.  The original
# .claude/hooks/no-python.sh was PRESENT earlier in the 2026-08-14/15 overnight
# run (it fired and blocked a diagnostic of mine) and was ABSENT immediately
# after main was merged into the collaborative-subagents lane.  Because
# .claude/settings.json still invoked it, every Bash call in the session failed
# with "cannot open .claude/hooks/no-python.sh" — the enforcement layer was
# failing OPEN on the ban while failing CLOSED on the shell.
#
# This file is a RECONSTRUCTION written from the sibling layer
# .githooks/pre-commit, not a recovery of the original bytes.  Its behaviour may
# differ from what was there before.  If the original is recoverable from git
# history, it should replace this file and this notice should be struck.
#
# SECOND DISAPPEARANCE, 2026-08-17.  The same file vanished from the working
# tree again, in the canonical shared checkout, while tracked and present on
# origin/main — and produced the identical symptom: every Bash call in the
# session died on "cannot open .claude/hooks/no-python.sh".  Restored from
# origin/main via the GitHub API because the shell needed to run `git checkout`
# was itself blocked by the missing file.  That is the property worth naming:
# THIS GUARD CAN DISABLE THE ONLY TOOL THAT COULD REPAIR IT.  A session that
# hits it has no local way out.
#
# Twice is a pattern, and the cause is still not established either time.  What
# is established: the two occurrences bracket merges into the shared checkout,
# and .claude/ is the one instruction directory no test covers.  Until someone
# finds the mechanism, treat a sudden total Bash failure in this repo as this
# bug first and as your own command second.
#
# Scope: this layer guards the TOOL CALL.  The commit boundary is guarded by
# .githooks/pre-commit and CI by .github/workflows/no-python.yml.  The three are
# independent on purpose; do not collapse them.
#
# Escape hatch, as everywhere else: MATH_ALLOW_PYTHON=1.  It exists so in-flight
# work is never destroyed (PROTOCOL §5), not so new Python gets written.  Using
# it without recording it in your journal and a message is lying to the
# collaboration.

if [ "${MATH_ALLOW_PYTHON:-}" = "1" ]; then
  exit 0
fi

# The tool call arrives as JSON on stdin.  Read it whole; if anything goes
# wrong reading it, fail OPEN rather than bricking the session's shell — a
# guard that cannot be bypassed by accident must still not be a single point
# of total failure.  The commit hook and CI remain as backstops.
payload=$(cat 2>/dev/null) || exit 0

# Match an invocation of the interpreter, not a mere mention.  Building the
# pattern from fragments keeps this script from tripping its own rule when it
# is itself grepped or catted by an agent.
i="p""y""t""h""o""n"

# Interpreter invocations: at a command position, after a pipe/semicolon/&&,
# or via env/uv/poetry/pipenv runners.  Also the module runner and pip.
if printf '%s' "$payload" | grep -Eq "(^|[;&|(]|&&|\\|\\||\\benv |\\buv run |\\bpoetry run |\\bpipenv run |\\bxargs )[[:space:]]*${i}[0-9.]*([[:space:]]|\$)" \
   || printf '%s' "$payload" | grep -Eq "\\b${i}[0-9.]*[[:space:]]+-[cm][[:space:]]" \
   || printf '%s' "$payload" | grep -Eq "(^|[[:space:]])pip[0-9.]*[[:space:]]+(install|download|wheel)"; then
  printf 'BLOCKED: Python is banned in this repository (human owner, 2026-08-13).\n\n' >&2
  printf 'The substrate is Agda: formal/cubical/ (--cubical --safe, no postulates,\n' >&2
  printf 'no holes). The analytic lane uses Lean: formal/pairfield/.\n\n' >&2
  printf 'A script that prints a number is an assertion a reader must trust.\n' >&2
  printf 'A checked term is the thing itself. CLAUDE.md already draws this line:\n' >&2
  printf 'exact/certified symbolic computation IS proof; everything else stands in\n' >&2
  printf 'for an error analysis you have not done.\n\n' >&2
  printf 'If you truly cannot proceed:  MATH_ALLOW_PYTHON=1 <command>\n' >&2
  printf '  (then record it in your journal and a message — otherwise you are\n' >&2
  printf '   lying to the collaboration)\n' >&2
  exit 2
fi

exit 0
