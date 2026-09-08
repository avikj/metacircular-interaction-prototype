#!/bin/sh
# प्रत्यय — that on which a thing rests; here, what an import rests on.
#
# ─────────────────────────────────────────────────────────────────────────
# WHY THIS EXISTS, and it is not the gate it replaces.
#
# scripts/check-agda-closure.sh asked: is every module REACHED from an
# aggregate root?  That gate is deleted along with the roots it needed.
# It never asked the cheaper and more basic question:
#
#     does every import NAME A FILE THAT EXISTS?
#
# Reachability trusts the file it reads.  Resolution does not.  On
# 2026-09-07 the corpus carried two dangling module names that reachability
# could not see and this check finds in under a second:
#
#   NaturalMachine.TransportDiv   — the module was moved into Mula/ and the
#     repointing pass matched `^import`, but TransportDiv is PARAMETERISED
#     so its uses are INDENTED `open import … k` inside where-blocks.  Three
#     survived, and they were what made NaturalMachine.agda exit 42.
#
#   Setubandha_ThePrastarasNextRow… — imported by Mula/Sthana_ for one name
#     and NEVER PRESENT IN ANY COMMIT ON ANY BRANCH (`git rev-list --all
#     --objects` finds no blob).  Someone wrote the import for a file they
#     meant to write and did not.  Mula/Sthana_ was red at scope-check the
#     whole time: [FileNotFound].
#
# The second one had been REPORTED, by the generated aggregate root, as one
# of seven names it could not resolve.  The root was then deleted — partly
# on the argument that those seven made it stale — and the report went with
# it while the defect stayed.  That is the failure this file is insurance
# against: an instrument removed is not a defect closed.
#
# WHAT IT IS NOT.  This is text analysis and says NOTHING about whether any
# module typechecks.  A green here means no import names a missing file; it
# does not mean the corpus builds.  For that, run agda at the pin
# (scripts/Dhruva_…sh) and quote the exit code for what you actually ran.
#
# AND IT CHECKS THE MODULE, NOT THE NAMES.  `import M using (x)` where M
# exists but does not export `x` passes this gate and is a real defect one
# level down.  Agda reports it as a WARNING, not an error —
#
#     warning: -W[no]ModuleDoesntExport
#     The module … doesn't export the following: …
#
# — so the name is silently not brought into scope and the build continues.
# Found live on 2026-09-08 in NaturalMachine/SymmetryCardinality.agda:19,
# which imported `factorial` from Cubical.Data.Fin.LehmerCode while the
# comment on the very next line already said cubical 2.8 had moved it to
# Cubical.Data.Nat.  The correction was written as prose beneath the line it
# corrected and never applied; nothing failed, so nothing noticed.
#
# Checking 4440 `using` lists against real export sets needs a parser that
# handles re-exports and `open … public`, and a parser I cannot validate is
# worse than none.  Agda already knows.  Make it fatal instead:
#
#     agda -W error --library-file="$HOME/.agda-pin/libraries" -i . <M>.agda
#
# Verified on that exact defect: fixed -> EXIT 0; import restored -> EXIT 42.
# Use -W error whenever you check a module at the pin, and this whole class
# is closed at the point where it can actually be seen.
#
# TERM.  प्रत्यय in its ordinary sense — ground, basis, that on which
# something depends.  No text is claimed and no author is credited.
# ─────────────────────────────────────────────────────────────────────────
#   run:   sh scripts/Pratyaya_…sh
#   exit:  0 = every local import resolves · 1 = at least one does not
# ─────────────────────────────────────────────────────────────────────────

cd "$(dirname "$0")/.." || exit 2

TREES="formal/cubical punaragamana/src"

stale=0
for tree in $TREES; do
  [ -d "$tree" ] || continue
  # Every import target mentioned anywhere in the tree, in any form.
  grep -rhoE '^[[:space:]]*(open[[:space:]]+)?import[[:space:]]+[A-Za-z0-9_.]+' \
       --include='*.agda' "$tree" 2>/dev/null \
  | sed -E 's/.*import[[:space:]]+//' | sort -u \
  | while read -r m; do
      # Library modules are the library's problem, not the corpus's.
      case "$m" in Cubical.*|Agda.*|'') continue ;; esac
      p="$tree/$(printf '%s' "$m" | tr '.' '/')"
      if [ ! -f "$p.agda" ] && [ ! -f "$p.lagda" ]; then
        # Name every site, because मौनं न निषेधः: a count without the
        # location is the memory this repository exists to refuse.
        printf 'DANGLING  %s\n' "$m"
        grep -rn "import[[:space:]]\+$m\([[:space:]]\|$\)" \
             --include='*.agda' "$tree" 2>/dev/null | sed 's/^/          /'
      fi
    done
done > /tmp/pratyaya.$$ 2>/dev/null

if [ -s /tmp/pratyaya.$$ ]; then
  echo
  echo "FAIL: an import names a module that is not on disk."
  echo "Nothing can typecheck through it; the importing module is red at"
  echo "scope-check with [FileNotFound].  Either the module MOVED (repoint"
  echo "the import -- and check for INDENTED \`open import\` too, which an"
  echo "anchored grep misses) or it was NEVER WRITTEN (prove the lemma"
  echo "where it belongs; do not create the phantom filename)."
  echo
  cat /tmp/pratyaya.$$
  rm -f /tmp/pratyaya.$$
  exit 1
fi

rm -f /tmp/pratyaya.$$
echo "प्रत्यय: every local import resolves to a file on disk."
echo "  (This is resolution, not typechecking.  It says nothing about green.)"
exit 0
