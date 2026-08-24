#!/bin/sh
# स्फटिक rounds — completion, running: prove → install → sense, repeated.
# Each round: the crystal proves the current frontier (installing its
# landings back into machine/library.terms at fixpoint — the return
# edge), then Sanghatta re-derives the frontier from the enlarged rule
# set.  The loop halts itself only when a round adds no lemma AND the
# report is unchanged — completion's own fixpoint — or when ROUNDS is
# exhausted.  Idempotent, single-writer (the crystal lock), resumable.
#
#   sh machine/sphatika-rounds.sh [ROUNDS]        default 24
set -u
cd "$(dirname "$0")/.."
ROUNDS=${1:-24}
BIN=${SPHATIKA_BIN:-/tmp/sphatika-bin}
LOG=collab/orchestration/sphatika.log

[ -x "$BIN" ] || LC_ALL=C.UTF-8 ghc -O0 -imachine -outputdir "${BIN}.build" \
    machine/Sphatika_TheCrystalGrowsByItsOwnStallsAndEveryTheoremStrengthensTheNext.hs \
    -o "$BIN" >>"$LOG" 2>&1 || exit 1

n=0
while [ "$n" -lt "$ROUNDS" ]; do
    n=$((n+1))
    before_crystal=$(wc -l < machine/sphatika.crystal 2>/dev/null || echo 0)
    before_report=$(cksum machine/sanghatta-report-current.txt 2>/dev/null)
    echo "== round $n: prove ==" >>"$LOG"
    # reap a lock whose owner is gone (a driver killed mid-run), the same
    # doctrine as the loop's gate mutex: a dead owner's lock must not
    # wedge every future round
    if [ -d machine/sphatika.crystal.lock ] \
       && ! ps aux | grep -v grep | grep -q "sphatika.*sanghatta-report"; then
        rm -rf machine/sphatika.crystal.lock
    fi
    "$BIN" machine/sanghatta-report-current.txt >>"$LOG" 2>&1
    rm -rf machine/sphatika.crystal.lock
    echo "== round $n: sense ==" >>"$LOG"
    LC_ALL=C.UTF-8 runghc -imachine \
        machine/Sanghatta_TheCriticalPairsOfTheInstalledRulesNameTheLibrarysIncompleteness.hs \
        > machine/sanghatta-report-current.txt.new 2>>"$LOG" \
      && [ -s machine/sanghatta-report-current.txt.new ] \
      && mv machine/sanghatta-report-current.txt.new machine/sanghatta-report-current.txt \
      || rm -f machine/sanghatta-report-current.txt.new
    after_crystal=$(wc -l < machine/sphatika.crystal 2>/dev/null || echo 0)
    after_report=$(cksum machine/sanghatta-report-current.txt 2>/dev/null)
    echo "== round $n done: crystal $before_crystal -> $after_crystal ==" >>"$LOG"
    # the machine keeps its own landings: crystal, rendering, library, report
    if command -v git >/dev/null 2>&1 && [ "$after_crystal" != "$before_crystal" ]; then
        git add machine/sphatika.crystal formal/cubical/Sphatika.agda \
                machine/library.terms machine/sanghatta-report-current.txt 2>>"$LOG"
        git commit -o machine/sphatika.crystal -o formal/cubical/Sphatika.agda \
                   -o machine/library.terms -o machine/sanghatta-report-current.txt \
            -m "the crystal keeps round $n: $before_crystal -> $after_crystal lemmas, rules installed, frontier re-sensed" \
            >>"$LOG" 2>&1
        git push -u origin "$(git symbolic-ref --quiet --short HEAD)" >>"$LOG" 2>&1
    fi
    if [ "$after_crystal" = "$before_crystal" ] && [ "$after_report" = "$before_report" ]; then
        echo "== completion fixpoint at round $n ==" >>"$LOG"
        break
    fi
done
echo "== rounds finished ($n) ==" >>"$LOG"
