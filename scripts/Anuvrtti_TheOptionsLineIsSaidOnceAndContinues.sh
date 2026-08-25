#!/usr/bin/env bash
# अनुवृत्ति — a word said once continues, and is not said again.
#
# ---------------------------------------------------------------------------
# THE PRINCIPLE, AND WHOSE IT IS
#
# Pāṇini, *Aṣṭādhyāyī* (c. 500 BCE), is built on *anuvṛtti*: a term stated in
# one sūtra CONTINUES into the following sūtras and is not restated, until
# something cancels it.  `notes/AHIMSA_SUTRA_VISTARA.md` §45 states the rule
# and, more to the point, states its reason —
#
#     पदम् एकवारम् उक्तम् अग्रिमेषु सूत्रेषु अनुवर्तते । यावत् न निवर्त्यते ।
#     पुनरुक्तिर्न क्रियते । यतः स्थानं महार्घम् ।
#     सूत्रं स्वयं न पूर्णम् — पूर्वेण सह पूर्णम् ।
#
#   "A word said once continues into the following sūtras, until it is
#    cancelled.  Repetition is not performed, because storage is expensive.
#    A sūtra is not complete in itself — it is complete with what precedes it."
#
# The grammarians' own measure of the saving is अर्धमात्रालाघव (§33): half a
# mora saved is treated as the birth of a son.  What that register is really
# recording is not aesthetics — it is that a second copy of anything is a
# second thing that can drift.
#
# NOT CLAIMED: that Pāṇini wrote about compiler flags.  What is his is the
# device — say it once, let it continue, cancel it explicitly — and the reason
# he gives for it.
#
# ---------------------------------------------------------------------------
# WHAT DRIFTED, MEASURED, 2026-08-20
#
# Two Haskell programs emit Agda modules for the kernel to check:
# `machine/Certificate.hs` (the shape search and the two controls) and
# `machine/TraceReplay.hs` (the trace transcriber).  Each carried its own copy
# of the module's OPTIONS pragma.  The copies drifted by one flag:
#
#   Certificate.preambleCore : --cubical --guardedness --safe --no-import-sorts
#   TraceReplay.moduleHeader : --cubical              --safe --no-import-sorts
#   Certificate.canaryModule : --cubical              --safe --no-import-sorts
#
# Agda's `[InfectiveImport]` rule makes `--guardedness` propagate: under a
# cubical library compiled with it, a module that opens
# `Cubical.Foundations.Prelude` WITHOUT it fails at scope-checking, before any
# proof term is looked at.  The measured consequences on Agda 2.8.0:
#
#   * `TraceReplay` emitted modules that could not compile.  Replay reach 0/13.
#   * `Certificate`'s POSITIVE control could not compile, so the process never
#     confirmed its kernel was checking, so `vetSuccess` downgraded every
#     acceptance to an environment fault.  Certificate reach 0/28.
#
# Two files' worth of certification, lost to one flag in one of three copies,
# and neither number was wrong about anything mathematical.  Both were
# recovered by making the copies agree (0/28 -> 15/28, 0/13 -> 8/13).
#
# Haskell gives no way to have `TraceReplay` share the constant without
# importing `Certificate`, and that file's author chose independence
# deliberately (its STATUS block: "so it can build real traces ... without
# importing, and without being broken by, the files other agents are editing
# concurrently").  That choice is defensible and it has this cost.  So the
# repetition stays and a check stands in for the anuvṛtti.
#
# ---------------------------------------------------------------------------
# WHAT THIS CHECKS
#
# Every `{-# OPTIONS ... #-}` string literal emitted by any `.hs` file under
# machine/ must be character-for-character the pragma `Certificate.hs` names
# in `kOptionsPragma`.  That constant is the single statement; everything else
# is an anuvṛtti of it that the language will not perform.
#
# WHAT IT DOES NOT CHECK.  Nothing about whether the flags are the RIGHT ones
# for the container the emitter will run against — that is a property of the
# installed cubical library and only `machine/run-kernel-probe.sh` and an
# actual agda call can answer it.  This check makes the emitters agree; it
# does not make them correct.  Agreement is what was lost, and agreement is
# what a text pass can keep.
#
# Exit 0 = one OPTIONS line, everywhere.
set -euo pipefail

cd "$(dirname "$0")/.."

SOURCE_FILE="machine/Certificate.hs"
SOURCE_NAME="kOptionsPragma"

[ -f "$SOURCE_FILE" ] || { echo "Anuvrtti: $SOURCE_FILE not found" >&2; exit 2; }

# The one statement.  Read from the definition, not restated here — a check
# that carries its own copy of the constant is the defect it is checking for.
canonical=$(grep -E "^${SOURCE_NAME}[[:space:]]*=" "$SOURCE_FILE" \
            | head -1 | sed -E 's/^[^"]*"//; s/"[[:space:]]*$//')

if [ -z "$canonical" ]; then
  echo "Anuvrtti: could not read \`$SOURCE_NAME\` from $SOURCE_FILE." >&2
  echo "It is the single source for the emitters' OPTIONS line; if it was" >&2
  echo "renamed, rename it here too rather than deleting this check." >&2
  exit 2
fi

echo "अनुवृत्ति — one OPTIONS line for every Agda emitter under machine/"
echo "stated once in : $SOURCE_FILE ($SOURCE_NAME)"
echo "the line       : $canonical"
echo

# ---------------------------------------------------------------------------
# CANCELLATION.  anuvṛtti runs until something cancels it (निवृत्ति), and a
# rule with no way to be cancelled is not the rule Pāṇini wrote — it is a
# rule that will one day be wrong and unarguable.  Some emitters are
# deliberately NOT emitting a cubical module and must not be dragged into
# agreement:
#
# Format: one "path:line<TAB>reason" per entry.  An entry without a reason is
# not an exception, it is a rubber stamp; delete it and let the check go red.
#
# The list is a FUNCTION, not `VAR=$(cat <<EOF)`.  bash 3.2 — which is what
# macOS ships, and what this repository's gates keep tripping over — rescans
# the body of a command substitution, so a heredoc inside one breaks on an
# apostrophe in prose.  A quoted heredoc inside a function body does not.
cancelled_list() {
  cat <<'EOF'
machine/KernelProbe.hs:40	the refl-capability probe: builtin modules only, checked with --no-libraries so that a broken cubical registration cannot fail the probe OF THE KERNEL ITSELF. It imports no Cubical module, so --cubical/--guardedness would be flags about nothing.
machine/KernelProbe.hs:52	the cubical-capability probe: its whole job is to answer whether THIS container checks a plain --cubical --safe module against the registered library. Pinning it to the flag set the emitters use would make it answer a different question than the one it reports.
EOF
}

cancelled() { # cancelled <path:line>
  cancelled_list | grep -q "^$1	"
}
reason_for() {
  cancelled_list | grep "^$1	" | head -1 | cut -f2-
}

status=0
n_lit=0
n_cancelled=0
n_skipped=0

# Every OPTIONS pragma appearing inside a Haskell string literal.  `grep -o`
# on the literal body: the emitters all write the pragma as one literal.
while IFS= read -r hit; do
  [ -n "$hit" ] || continue
  file=${hit%%:*}
  rest=${hit#*:}
  lineno=${rest%%:*}
  text=${rest#*:}
  # The pragma as it will be written to the .agda file.  A hit that is not a
  # COMPLETE pragma literal is not an emitter: `TraceLibrary.hs:267` matches
  # this grep with `not ("{-# OPTIONS" \`isPrefixOf\` l)`, which is a READER
  # skipping pragma lines, and demanding it equal the canonical string would
  # be the check misreading its own corpus.  So a partial match is skipped and
  # counted, not silently dropped — a skip nobody can see is the same
  # concealment this repository keeps finding.
  case "$text" in
    *'"{-# OPTIONS'*'#-}"'*)
      lit=$(printf '%s' "$text" | sed -E 's/.*("\{-# OPTIONS[^"]*#-\}").*/\1/; s/^"//; s/"$//') ;;
    *)
      n_skipped=$((n_skipped + 1)); continue ;;
  esac
  n_lit=$((n_lit + 1))
  if cancelled "$file:$lineno"; then
    n_cancelled=$((n_cancelled + 1))
    echo "    cancelled  $file:$lineno  $lit"
    echo "               because: $(reason_for "$file:$lineno")"
    continue
  fi
  if [ "$lit" != "$canonical" ]; then
    echo "    DRIFT  $file:$lineno"
    echo "           emits : $lit"
    echo "           should: $canonical"
    status=1
  fi
done <<< "$(grep -rn '"{-# OPTIONS' machine --include='*.hs' || true)"

echo
echo "complete OPTIONS literals : $n_lit"
echo "cancelled with a reason   : $n_cancelled"
echo "not a pragma literal      : $n_skipped (mentions of the token in reader code)"

if [ "$status" -ne 0 ]; then
  echo
  echo "FAIL: two emitters would hand agda two differently-compiled modules."
  echo "One of them is then not a control for the other, and a control that is"
  echo "not compiled the way the thing it controls is compiled is not a control."
  echo "Fix: make the literal equal \`$SOURCE_NAME\`, or — if the flags genuinely"
  echo "must change — change \`$SOURCE_NAME\` and let every emitter follow, which"
  echo "is what stating it once is for."
  exit 1
fi

echo "OK: every Agda emitter under machine/ writes the same OPTIONS line."
echo
echo "This says nothing about whether that line SUITS the installed cubical"
echo "library.  Run machine/run-kernel-probe.sh for that; a green here with a"
echo "wrong flag is agreement on a mistake, and agreement is all this checks."
