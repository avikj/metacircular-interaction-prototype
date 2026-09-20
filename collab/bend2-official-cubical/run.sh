#!/bin/bash
# Clones the official Bend 2 at the pinned commit, applies cubical.patch,
# runs the cubical tests (check + interpret; the compiled_*.bend files on
# the JS lane, and on the C lane when clang is present), then the
# interpreter-lane suite. Needs bun.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
WORK=${1:-/tmp/bend-cubical}
UPSTREAM=6018e28ecc67cf1fffc0c20c64b11023474c2df8
if [ ! -d "$WORK/.git" ]; then
  git clone https://github.com/HigherOrderCO/Bend "$WORK"
fi
cd "$WORK"
git checkout -q $UPSTREAM
git checkout -q -- bend2/bend.ts bend2/comp.ts bend2/base.bend
patch -p1 < "$HERE/cubical.patch"
(cd bend2/pack && bun install >/dev/null)
mkdir -p tests/cubical && cp "$HERE"/tests/cubical/*.bend tests/cubical/
tidy() { sed 's/[ \t]*$//' | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}'; }
pass=0; fail=0
for f in tests/cubical/*.bend; do
  want=$(grep '^#|' "$f" | sed 's/^#|//; s/^exit [0-9]$//' | tidy)
  case "$f" in
    *compiled*.bend)
      bun bend2/main.ts "$f" -o /tmp/cubical_compiled.js >/dev/null 2>&1; got=$(bun /tmp/cubical_compiled.js 2>&1 | tidy)
      if command -v clang >/dev/null; then
        rm -f /tmp/cubical_compiled; bun bend2/main.ts "$f" -o /tmp/cubical_compiled >/dev/null 2>&1; gotc=$(/tmp/cubical_compiled 2>&1 | tidy)
        if [ "$gotc" != "$want" ]; then fail=$((fail+1)); echo "FAIL $f (C lane)"; diff <(echo "$want") <(echo "$gotc") | head -20; continue; fi
      fi ;;
    *) got=$(bun bend2/main.ts "$f" 2>&1 | tidy) ;;
  esac
  if [ "$got" == "$want" ]; then pass=$((pass+1)); echo "PASS $f"; else fail=$((fail+1)); echo "FAIL $f"; diff <(echo "$want") <(echo "$got") | head -20; fi
done
echo "cubical: $pass passed, $fail failed"
echo "interpreter-lane suite (upstream tests; proof/no_funext_000 is expected to fail):"
p=0; n=0
for f in tests/{proof,check,eval,stuck,halt,grade,spec,comptime,flatten,parse,show,printer,base,rfc,state}/*.bend; do
  want=$(grep '^#|' "$f" | sed 's/^#|//; s/^exit [0-9]$//' | tidy)
  got=$(timeout 30 bun bend2/main.ts "$f" 2>&1 | tidy)
  if [ "$got" == "$want" ]; then p=$((p+1)); else n=$((n+1)); echo "FAIL $f"; fi
done
echo "suite: $p passed, $n failed"
