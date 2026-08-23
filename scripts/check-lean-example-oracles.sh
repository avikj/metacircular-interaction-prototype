#!/usr/bin/env bash
# Anonymous-`example` oracle check for formal/pairfield/ — no toolchain required.
#
# WHY THIS EXISTS.  `lake exe yogyanupalabdhi`
# (formal/pairfield/YogyaAnupalabdhi_TheAxiomCheckStatesWhereItCouldHaveSeen.lean,
# notes/AXIOM_GATE.md) is the real soundness gate: it walks the built
# environment and runs `Lean.collectAxioms` over every named `Pairfield.*`
# declaration, so it sees oracle use *through imports*, which no grep can.
# But it can only see NAMED declarations.  An anonymous `example` emits no
# reachable constant, so whatever an `example` rests on is invisible to it —
# a limit its own author recorded (AXIOM_GATE.md §7) and the decide sweep
# then found to be live: 69 of the 195 decide-carrying declarations under
# `Pairfield/` are anonymous `example`s, and for a time the lane's single
# surviving `native_decide` sat inside one (`ChartQuotient.lean`:238).
# The gate would have certified the tree while structurally unable to look at
# its only remaining oracle use.
#
# So this script is the complement, not the replacement:
#   axiom gate  — sees dependencies, blind to anonymous declarations.
#   this script — sees anonymous declarations, blind to dependencies.
# Neither subsumes the other; the pair covers the lane.
#
# WHAT IT DOES, purely textually: for every `.lean` file under the Pairfield
# tree, take each column-0 `example` block (up to the next column-0
# declaration keyword), strip `--` line comments, and FAIL if it contains an
# oracle token: `native_decide`, `ofReduceBool`, `ofReduceNat`, `sorry`,
# `sorryAx`.  The remedy for a hit is never to delete this check: it is to
# NAME the declaration (`theorem`/`def`), which puts it permanently inside
# the axiom gate, and then either kernel-check it or record it in
# `formal/pairfield/axiom-allowlist.txt` with the observed reason.
#
# Exit 0 = no anonymous example in the lane rests on an oracle.
# This is text analysis, not a build.  It says nothing about whether any
# module typechecks, and nothing about taint reaching a NAMED declaration —
# that is the axiom gate's job and it must still be run.
set -euo pipefail

cd "$(dirname "$0")/.."
LANE="${LEAN_LANE_DIR:-formal/pairfield/Pairfield}"

if [ ! -d "$LANE" ]; then
  echo "check-lean-example-oracles: lane directory $LANE not found" >&2
  exit 2
fi

ORACLES='native_decide|ofReduceBool|ofReduceNat|sorryAx|\bsorry\b'

# awk, not grep -A: an example block has no fixed length.  Attribution is the
# nearest preceding column-0 declaration keyword, the same rule
# notes/DECIDE_STATEMENT_SWEEP.md §1 used, and it carries the same warning —
# it counts SITES, not dependencies.
hits=$(find "$LANE" -name '*.lean' -print0 \
  | xargs -0 awk -v oracles="$ORACLES" '
      function flush() {
        if (inex && found != "")
          printf "%s:%d: anonymous `example` uses oracle `%s`\n", FILENAME, start, found
      }
      FNR == 1 { inex = 0; found = ""; start = 0 }
      /^(theorem|lemma|example|def|instance|abbrev|structure|inductive|axiom|opaque)[ \t({\[]/ {
        flush()
        inex = ($1 == "example")
        found = ""
        start = FNR
      }
      {
        line = $0
        sub(/--.*$/, "", line)
        if (inex && found == "" && match(line, oracles))
          found = substr(line, RSTART, RLENGTH)
      }
      END { flush() }
    ' || true)

if [ -n "$hits" ]; then
  echo "$hits"
  echo
  echo "check-lean-example-oracles: FAIL — $(printf '%s\n' "$hits" | wc -l) anonymous example(s) rest on an oracle the axiom gate cannot see."
  echo "Fix: give the declaration a name (theorem/def) so \`lake exe yogyanupalabdhi\` reaches it,"
  echo "then kernel-check it or add it to formal/pairfield/axiom-allowlist.txt with the"
  echo "observed reason and the removal path, and mark its file \`-- TRUSTS-COMPILER:\`."
  exit 1
fi

echo "check-lean-example-oracles: OK — no anonymous example under $LANE rests on an oracle."
