#!/bin/sh
# Build the sabhā and run its scripted session.  Exit 0 only if every
# answer was a saṃkramaṇa or a doṣa-lekha carrying what its road obliges,
# and the two exact identities hold (cakravāla D=61, aṆ).
#
#   machine/check-sabha.sh
#
# The build reaches into machine/Astadhyayi.hs, machine/Nalanda.hs and
# machine/Naya.hs, which other lanes edit.  If the build fails there and
# not in the sabhā's own three modules, that is their in-flight work and
# not a fault here; the message below says so rather than blaming the wire.
set -e
root=$(cd "$(dirname "$0")/.." && pwd)
out=${TMPDIR:-/tmp}/sabha-build
mkdir -p "$out"
if ! ghc -O0 -i"$root/machine" -outputdir "$out" -o "$root/machine/sabha" \
        "$root/machine/SabhaRun.hs" 2>"$out/build.log"; then
  echo "build failed; first errors:"
  grep -E "error" -A6 "$out/build.log" | head -30
  echo
  echo "if the errors are in Astadhyayi/Nalanda/Naya, another lane is mid-edit:"
  echo "  git stash list; git diff --stat machine/"
  exit 1
fi
SABHA_LEKHA=${SABHA_LEKHA:-$out/selftest.jsonl} "$root/machine/sabha" --selftest
