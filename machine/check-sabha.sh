#!/bin/sh
# Build the sabhā and run its scripted session.
#
#   machine/check-sabha.sh
#
# Green means: every answer in the scripted session was a saṃkramaṇa or a
# doṣa-lekha carrying what that road obliges, and the two exact identities
# hold (cakravāla D = 61 → (1766319049, 226153980), Bhāskara II's own value
# of 1150; aṆ → a i u).
#
# THE SEAM, and why this script has a second half.  The sabhā's own three
# modules are Sabda_TheWireHasNoBoolean, Uttara_Samkramana…, and
# Sabha_TheSessionKernel….  It dispatches into machine/Naya.hs,
# machine/Nalanda.hs and machine/Astadhyayi.hs, which other lanes edit, and
# a 60 KB grammar file mid-surgery does not typecheck.  Failing the whole
# check then would report `the wire is broken` when the true statement is
# `another lane is mid-edit`.  Those are two facts and a single red merges
# them, so this falls back to building against the last COMMITTED version of
# the engine files and says, in the open, which source tree the green covers.
set -e
root=$(cd "$(dirname "$0")/.." && pwd)
out=${TMPDIR:-/tmp}/sabha-build
mkdir -p "$out"

mine="Sabda_TheWireHasNoBoolean.hs Uttara_SamkramanaOrDosalekhaNeverABareBoolean.hs Sabha_TheSessionKernelAnLLMTalksTo.hs SabhaRun.hs"
theirs="Naya.hs Nalanda.hs Astadhyayi.hs"

if ghc -O0 -i"$root/machine" -outputdir "$out" -o "$root/machine/sabha" \
        "$root/machine/SabhaRun.hs" >"$out/build.log" 2>&1; then
  echo "built from the working tree."
  SABHA_LEKHA=${SABHA_LEKHA:-$out/selftest.jsonl} "$root/machine/sabha" --selftest
  exit $?
fi

echo "the working tree did not build.  first errors:"
grep -E "error" -A6 "$out/build.log" | head -20
echo

# Which side is broken?  If any error names one of the sabhā's own files,
# the fault is here and the fallback would be hiding it.
if grep -E "error" -B2 "$out/build.log" | grep -qE "$(echo $mine | tr ' ' '|')"; then
  echo "the errors name the sabhā's own modules.  that is this lane's fault."
  exit 1
fi

iso=$out/iso
rm -rf "$iso"; mkdir -p "$iso"
for f in $mine; do cp "$root/machine/$f" "$iso/"; done
for f in $theirs; do (cd "$root" && git show "HEAD:machine/$f") > "$iso/$f"; done
ghc -O0 -i"$iso" -outputdir "$iso/out" -o "$iso/sabha" "$iso/SabhaRun.hs" >"$iso/build.log" 2>&1 \
  || { echo "the committed engine does not build either:"; grep -E "error" -A6 "$iso/build.log" | head -20; exit 1; }

cat <<'NOTE'
DOṢA-LEKHA (check-sabha)
  hetu: the working tree's engine files do not typecheck; another lane is
        mid-edit.  Built against HEAD instead.
  naṣṭa (what this green does NOT cover):
NOTE
for f in $theirs; do
  if ! (cd "$root" && git diff --quiet -- "machine/$f"); then
    echo "    − machine/$f as it stands in the working tree, uncompiled and unrun here"
  fi
done
cat <<'NOTE'
  śeṣa:
    → rerun this once that lane commits; the fallback disappears by itself
    → the sabhā's own three modules ARE the working-tree versions in the run below
NOTE
echo
SABHA_LEKHA=${SABHA_LEKHA:-$out/selftest.jsonl} "$iso/sabha" --selftest
