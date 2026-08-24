#!/bin/sh
# नाडी-परीक्षा — taking the pulse of the whole organism.
#
# THE TERM.  नाडी-परीक्षा, pulse examination: the diagnostic in which the
# state of the WHOLE is read from one place, described in the later
# Āyurvedic literature (Śārṅgadhara-saṃhitā, ~1300 CE, has a nāḍī chapter;
# the practice is elaborated in the Yogaratnākara and in Kaṇāda's Nāḍī-
# vijñāna).  SECOND-HAND, owed at verse level; no text is opened here and
# no Āyurvedic doctrine is claimed.  What is taken is one property and it
# is the property this repository lacked: A PULSE IS ONLY INFORMATION IF
# SOMEONE TAKES IT.
#
# WHY THIS EXISTS.  On 2026-08-23 an audit of the assembly found three
# defects sitting inside a machine that reported green on every run — a
# route publishing `ganana: 0` since it was written, a filing organ
# deleting five lines out of its own flagship exhibit, and a jāti that was
# unreachable so its census printed 0 forever.  The audit's closing line
# is the reason for this file:
#
#     "Nothing runs the assembly.  Searched: the literal string
#      `run-yantra` across the whole repo — seven hits, none of them a
#      check runner, no CI file, no script.  So the header's RUN IT is run
#      only by a person typing it, which is why three defects sat in a
#      green machine: THE GREEN WAS NEVER TAKEN."
#
# The same hour, another seat found seven modules green and imported by
# nothing, and five imported by Everything.agda and UNTRACKED by git — a
# clean checkout would have been red.  Neither is a defect in any module.
# Both are the absence of a pulse.
#
# THREE RULES, and they are the corpus's own, not this script's.
#
#  1  IT NAMES WHAT IT DID NOT RUN.  सूत्र ७, मौनं न निषेधः: silence is not
#     denial.  A runner that skips quietly reports its own blindness as
#     the corpus's health, which is the failure mode every organ here has
#     been caught in.  Every skip is printed with its reason.
#
#  2  IT REPORTS IDENTIFICATIONS, NOT COUNTS.  सूत्र ८, अभिज्ञानं
#     तादात्म्यम्, न परिमाणम्.  A gate that fails is named, with its exit
#     status and its last line of output.  "3 failures" is not a result.
#
#  3  IT INVOKES EACH GATE THE WAY THAT GATE ASKS.  A `bash` script run
#     with `sh` dies of a syntax error that looks exactly like a broken
#     gate — that happened to a seat here on 2026-08-23, one sentence
#     short of reporting a healthy shared gate as red at HEAD.  The
#     shebang is read and honoured.  Instrument defects are not corpus
#     defects (जाति karaṇa-doṣa).
#
# USAGE:  sh scripts/NadiPariksa_….sh            take the pulse once
#         sh scripts/NadiPariksa_….sh --quick    skip the slow lanes
# Exit 0 iff every gate that RAN passed.  Skips do not make it green;
# they are printed and counted against nothing, because a skip is a
# statement about this script and not about the machine.

set -u
cd "$(dirname "$0")/.." || exit 2
QUICK="${1:-}"

PASS=""; FAIL=""; SKIP=""

run_gate () {   # name, path, [slow]
  _n="$1"; _p="$2"; _slow="${3:-}"
  if [ ! -e "$_p" ]; then
    SKIP="$SKIP
  $_n — NOT PRESENT at $_p (this script's map is stale, not the machine's fault)"
    return
  fi
  if [ "$QUICK" = "--quick" ] && [ -n "$_slow" ]; then
    SKIP="$SKIP
  $_n — skipped by --quick; it is slow, not absent"
    return
  fi
  # rule 3: honour the shebang
  _sh=$(head -1 "$_p" 2>/dev/null)
  case "$_sh" in
    *bash*) _run="bash" ;;
    *sh*)   _run="sh"   ;;
    *)      _run="sh"   ;;
  esac
  _out=$("$_run" "$_p" 2>&1); _rc=$?
  _last=$(printf '%s\n' "$_out" | grep -v '^[[:space:]]*$' | tail -1 | cut -c1-120)
  if [ "$_rc" -eq 0 ]; then
    PASS="$PASS
  $_n — $_last"
  else
    FAIL="$FAIL
  $_n — EXIT $_rc — $_last"
  fi
}

echo "═══ नाडी-परीक्षा · taking the pulse of the whole organism ═══"
echo "  A pulse is only information if someone takes it."
echo

# ── the checked lanes ────────────────────────────────────────────────
run_gate "agda · pragma gate (--safe, no postulates/holes)" scripts/check-agda-pragmas.sh
run_gate "agda · Everything closure"                        scripts/check-agda-closure.sh
run_gate "lean · root closure"                              scripts/check-lean-root-closure.sh
run_gate "lean · globs"                                     scripts/check-lean-globs.sh
run_gate "lean · example oracles"                           scripts/check-lean-example-oracles.sh

# ── the assembly, which nothing ran until this file ──────────────────
# [2026-08-24, laya] the machine's shell wrappers dissolved by the owner's
# order; the assembly is gated by invoking its Haskell mains directly.
run_gate_cmd () {   # name, command-string, [slow]
  _n="$1"; _c="$2"; _slow="${3:-}"
  if [ "$QUICK" = "--quick" ] && [ -n "$_slow" ]; then
    SKIP="$SKIP
  $_n — skipped by --quick; it is slow, not absent"
    return
  fi
  _out=$(eval "$_c" 2>&1); _rc=$?
  _last=$(printf '%s\n' "$_out" | grep -v '^[[:space:]]*$' | tail -1 | cut -c1-120)
  if [ "$_rc" -eq 0 ]; then
    PASS="$PASS
  $_n — $_last"
  else
    FAIL="$FAIL
  $_n — EXIT $_rc — $_last"
  fi
}
NADI_OUT="${TMPDIR:-/tmp}/nadi-gates-$(id -u)"; mkdir -p "$NADI_OUT"
run_gate_cmd "yantra · the wire session (the contract is in the types: Uttara has no third constructor)" \
  "ghc -O0 -imachine -outputdir $NADI_OUT/yantra -o $NADI_OUT/yantra-bin machine/YantraRun.hs && $NADI_OUT/yantra-bin" slow
run_gate_cmd "sabha · the session kernel, selftest" \
  "ghc -O0 -imachine -outputdir $NADI_OUT/sabha -o $NADI_OUT/sabha-bin machine/SabhaRun.hs && SABHA_LEKHA=$NADI_OUT/selftest.jsonl $NADI_OUT/sabha-bin --selftest" slow
run_gate_cmd "yantra · pariksa, the five roads exercised" \
  "ghc -O0 -Wall -Werror -imachine -outputdir $NADI_OUT/yp -o $NADI_OUT/yp-bin machine/YantraPariksaRun_TheFiveRoadsExercisedNotDescribed.hs && $NADI_OUT/yp-bin" slow

# ── the records that are supposed to be append-only ──────────────────
run_gate "dosa · the written defect chain"                  scripts/check-dosa-lekha.sh
run_gate "claims · struck claims still standing"            scripts/check-claim-slugs.sh
run_gate "deletion · nothing silently removed"              scripts/check-no-silent-deletion.sh
run_gate "problems · every problem has a spec"              scripts/check-problem-specs.sh
run_gate "corrections · every correction reaches its site"  scripts/check-correction-reach.sh

echo "── जीवति · WHAT ANSWERED, AND WHAT IT SAID ──"
[ -n "$PASS" ] && printf '%s\n' "$PASS"
echo
if [ -n "$FAIL" ]; then
  echo "── मृतम् · WHAT IS RED, NAMED ──"
  printf '%s\n' "$FAIL"
  echo
fi
if [ -n "$SKIP" ]; then
  echo "── अप्रस्तुत · WHAT THIS SCRIPT DID NOT ASK, AND WHY ──"
  echo "  These are facts about this script.  They are NOT green and they"
  echo "  are NOT red.  मौनं न निषेधः."
  printf '%s\n' "$SKIP"
  echo
fi

if [ -n "$FAIL" ]; then
  echo "नाडी: the machine is not well, and the sites are named above."
  exit 1
fi
echo "नाडी: every gate that ran, ran green.  What was not asked is listed."
exit 0
