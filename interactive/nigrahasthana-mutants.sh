#!/bin/sh
# nigrahasthana-mutants.sh -- mutation testing on the Phonology's rule table.
#
# A suite that only ever runs against a correct machine measures nothing.
# This perturbs ONE thing at a time in a COPY of interactive/Phonology.hs -- one
# Ref, one condition, one order, one class, one map -- rebuilds, and reports
# which of the two suites notices:
#
#   selfTest    Phonology's own, all success cases
#   nigraha     interactive/Nigrahasthana_TheMachineIsJudgedByWhatItRefuses.hs,
#               all refusal cases
#
# The number that matters is the last line: mutations no test caught.  Those
# are holes in the suite and they are reported whether or not they are
# flattering.  A mutant that will not compile is STERILE and is not counted
# as caught -- it was never a test of anything.
#
# Nothing here writes to the repository.  Usage:
#
#   sh interactive/nigrahasthana-mutants.sh [path-to-Phonology.hs]
#
# with the default being interactive/Phonology.hs.  A second argument is a work
# directory (default: a fresh mktemp -d).
#
# NO PYTHON -- banned repo-wide, hook-enforced.  This is sh and ghc.

set -u

ROOT=$(cd "$(dirname "$0")/.." && pwd)
SRC=${1:-$ROOT/interactive/Phonology.hs}
WORK=${2:-$(mktemp -d)}

mkdir -p "$WORK"
cp "$SRC" "$WORK/Phonology.hs.orig"
cp "$ROOT/interactive/Nigrahasthana_TheMachineIsJudgedByWhatItRefuses.hs" "$WORK/"

cat > "$WORK/Driver.hs" <<'EOF'
import Phonology (selfTest)
import Nigrahasthana_TheMachineIsJudgedByWhatItRefuses (nigraha)
import GHC.IO.Encoding (setLocaleEncoding, utf8)
main :: IO ()
main = do
  setLocaleEncoding utf8
  putStrLn ("selfTest " ++ show (length selfTest))
  putStrLn ("nigraha " ++ show (length nigraha))
EOF

# ---------------------------------------------------------------- mutations
# name | sed program.  Each changes exactly one thing.
mutations() {
cat <<'EOF'
M01-resolver-paratva-inverted|s/maximumBy (comparing rSutra)/minimumBy (comparing rSutra)/; s/^import Data.List (isPrefixOf, nub, sortOn, intercalate, maximumBy)$/import Data.List (isPrefixOf, nub, sortOn, intercalate, maximumBy, minimumBy)/
M02-apavada-branch-deleted|s/^  let apavadas = \[ r | r <- rs, any/  let apavadas = [] :: [Rewrite]; _unused = [ r | r <- rs, any/
M03-tripadi-boundary-8.3|s/(a == 8 \&\& p >= 2)/(a == 8 \&\& p >= 3)/
M04-tripadi-order-reversed|s/^sectionB = sortOn num \[ s | s <- sutras, tripadi (num s) \]$/sectionB = reverse (sortOn num [ s | s <- sutras, tripadi (num s) ])/
M05-ref-on-6.1.101-rewrite|s/\[ Rewrite (6,1,101) i (j - i + 1)/[ Rewrite (6,1,71) i (j - i + 1)/
M06-condition-savarna-dropped|s/^        , savarna s t \]))$/        ]))/
M07-condition-padanta-dropped|s/^        , atPadanta xs i$/        , True/
M08-khar-widened-to-hal|s/            Just (_, t) -> t `elem` khaR \]))/            Just (_, t) -> t `elem` haL ]))/
M09-1.1.69-dropped-on-iK|s/^iK   = denotes (pratyahara "i" "k")/iK   = (pratyahara "i" "k")/
M10-najjhalau-dropped|s/^      | phVowel p \/= phVowel q -> False              -- 1.1.10 najjhalau$/      | False -> False/
M11-pratyahara-second-marker|s/^pratyahara s m = pratyaharaOcc s m 0$/pratyahara s m = pratyaharaOcc s m 1/
M12-conflict-set-head-to-last|s/here     = \[ r | r <- all_, overlaps r (head \[ q | q <- all_, rPos q == leftmost \]) \]/here     = [ r | r <- all_, overlaps r (last [ q | q <- all_, rPos q == leftmost ]) ]/
M13-jas-map-t-to-dh|s/^  "t" -> "d";  "th" -> "d";  "d" -> "d";  "dh" -> "d"$/  "t" -> "dh";  "th" -> "d";  "d" -> "d";  "dh" -> "d"/
M14-guna-map-i-to-o|s/^  "i" -> \[P "e"\];  "ī" -> \[P "e"\]$/  "i" -> [P "o"];  "ī" -> [P "e"]/
M15-nextph-stops-at-pada|s/^             Pada     -> go (j + 1)$/             Pada     -> Nothing/
M16-adhikara-6.1.84-shortened|s/, Adhikrta (6,1,111))/, Adhikrta (6,1,101))/
M17-1.1.51-rapara-dropped|s/^  "ṛ" -> \[P "a", P "r"\];  "ṝ" -> \[P "a", P "r"\]   -- 1.1.51 ur aṇ raparaḥ$/  "ṛ" -> [P "a"];  "ṝ" -> [P "a"]/
M18-avasana-not-padanta|s/^                   \[\]            -> True     -- avasana counts as pada-end$/                   [] -> False/
M19-8.3.15-silenced|s/^        | s == "r"$/        | False, s == "r"/
M20-8.4.56-condition-widened|s/, atAvasana xs i \]))/, atPadanta xs i ]))/
M21-anuvrtti-aci-not-continued|s/^  , ((6,1,77), "aci", "when a vowel (aC) follows", Anuvrtta)$/  , ((6,1,77), "aci", "when a vowel (aC) follows", Adhikrta (6,1,77))/
M22-nivrtti-of-aci-deleted|s/^nivrttiTable =$/nivrttiTable = []\nunusedNivrtti :: [(Ref, String, String)]\nunusedNivrtti =/
M23-adhikara-padasya-shortened|s/, Adhikrta (8,3,54))/, Adhikrta (8,2,66))/
EOF
}

run() {           # run in $WORK; echoes "selfTest N nigraha M" or "STERILE"
  ( cd "$WORK" && rm -f Phonology.hi Phonology.o Nigrahasthana*.hi Nigrahasthana*.o Driver.hi Driver.o driver
    if ghc -O0 -v0 Driver.hs -o driver > build.log 2>&1; then
      ./driver 2>/dev/null | tr '\n' ' '
    else
      printf 'STERILE'
    fi )
}

echo "== baseline"
cp "$WORK/Phonology.hs.orig" "$WORK/Phonology.hs"
BASE=$(run)
echo "   $BASE"
case "$BASE" in
  "selfTest 0 nigraha 0 ") : ;;
  *) echo "   BASELINE IS NOT GREEN -- mutation counts below mean nothing"; ;;
esac


echo
echo "== mutants                                          selfTest  nigraha  verdict"
mutations | while IFS='|' read -r NAME PROG; do
  [ -n "$NAME" ] || continue
  sed "$PROG" "$WORK/Phonology.hs.orig" > "$WORK/Phonology.hs"
  if cmp -s "$WORK/Phonology.hs" "$WORK/Phonology.hs.orig"; then
    printf '%-45s  %s\n' "$NAME" "SED DID NOT APPLY -- not a mutant"
    echo "NOTAPPLIED $NAME" >> "$WORK/tally"
    continue
  fi
  OUT=$(run)
  case "$OUT" in
    STERILE)
      printf '%-45s  %-9s %-8s %s\n' "$NAME" "-" "-" "sterile (will not compile)"
      echo "STERILE $NAME" >> "$WORK/tally" ;;
    *)
      S=$(echo "$OUT" | awk '{print $2}')
      N=$(echo "$OUT" | awk '{print $4}')
      if [ "$S" -gt 0 ] && [ "$N" -gt 0 ]; then V=both; T=BOTH
      elif [ "$S" -gt 0 ]; then V="selfTest only"; T=SELF
      elif [ "$N" -gt 0 ]; then V="NIGRAHA ONLY"; T=NIG
      else V="UNCAUGHT"; T=NONE
      fi
      printf '%-45s  %-9s %-8s %s\n' "$NAME" "$S" "$N" "$V"
      echo "$T $NAME" >> "$WORK/tally" ;;
  esac
done

cp "$WORK/Phonology.hs.orig" "$WORK/Phonology.hs"

echo
echo "== tally"
awk '{c[$1]++} END {for (k in c) printf "   %-12s %d\n", k, c[k]}' "$WORK/tally"
echo
echo "   injected:            $(wc -l < "$WORK/tally" | tr -d ' ')"
echo "   caught (both/self/nigraha): $(grep -c '^BOTH\|^SELF\|^NIG' "$WORK/tally")"
echo "   caught by nigraha and NOT by selfTest: $(grep -c '^NIG' "$WORK/tally")"
echo "   UNDETECTED BY ANY TEST: $(grep -c '^NONE' "$WORK/tally")"
grep '^NONE' "$WORK/tally" | sed 's/^NONE /     hole: /'
grep '^STERILE' "$WORK/tally" | sed 's/^STERILE /     sterile (not a test of anything): /'
echo
echo "work dir: $WORK"

# ---------------------------------------------------------------------------
# WHAT THE UNDETECTED ONES ARE, at the time of writing (2026-08-20), so the
# number above is never read alone.  Both are argued equivalent, and the
# arguments are recomputed by `dosha` in the module, not kept here:
#
#   M10  deleting 1.1.10 najjhalau.  PROVED equivalent: no consonant in the
#        phonetic table is Vivrta and no vowel is anything else, so no vowel
#        and consonant ever agree on sthana AND prayatna, so the override is
#        never consulted.  `nigraha` recomputes that enumeration and goes red
#        if the table ever changes.  (dosha D8)
#
#   M12  `head` -> `last` in the conflict set at the leftmost position.  NOT
#        proved equivalent -- only unrefuted.  No input constructed here
#        distinguishes them, and the construction remains order-dependent by
#        shape: which rules are considered for 1.4.2 is read off a list
#        ordered by the sutra table.  (dosha D7)
#
# And one mutant is caught but is worth its own line: M22 deletes the nivrtti
# of `aci` and changes NO derived form, only the readings that selfTest
# prints.  The file's own modelling note says this ("the two are
# indistinguishable in every derivation this file runs"); the mutation is
# where that stops being a claim.
