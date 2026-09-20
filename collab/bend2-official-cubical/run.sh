#!/bin/bash
# Clones the official Bend 2 at the pinned commit, applies cubical.patch,
# runs the cubical tests (check + interpret, and the compiled JS lane for
# compiled.bend), then the interpreter-lane suite. Needs bun.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
WORK=${1:-/tmp/bend-cubical}
UPSTREAM=6018e28ecc67cf1fffc0c20c64b11023474c2df8
if [ ! -d "$WORK/.git" ]; then
  git clone https://github.com/HigherOrderCO/Bend "$WORK"
fi
cd "$WORK"
git checkout -q $UPSTREAM
git checkout -q -- bend2/bend.ts bend2/comp.ts
patch -p1 < "$HERE/cubical.patch"
(cd bend2/pack && bun install >/dev/null)
mkdir -p tests/cubical && cp "$HERE"/tests/cubical/*.bend tests/cubical/
pass=0; fail=0
for f in tests/cubical/*.bend; do
  want=$(grep '^#|' "$f" | sed 's/^#|//; s/^exit [0-9]$//' | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}')
  case "$f" in
    *compiled.bend) bun bend2/main.ts "$f" -o /tmp/cubical_compiled.js >/dev/null 2>&1; got=$(bun /tmp/cubical_compiled.js 2>&1) ;;
    *) got=$(bun bend2/main.ts "$f" 2>&1 | sed 's/[ \t]*$//') ;;
  esac
  if [ "$got" == "$(echo "$want" | sed 's/[ \t]*$//')" ]; then pass=$((pass+1)); echo "PASS $f"; else fail=$((fail+1)); echo "FAIL $f"; diff <(echo "$want") <(echo "$got") | head -20; fi
done
echo "cubical: $pass passed, $fail failed"
echo "interpreter-lane suite (upstream tests; proof/no_funext_000 is expected to fail):"
p=0; n=0
for f in tests/{proof,check,eval,stuck,halt,grade,spec,comptime,flatten,parse,show,printer,base,rfc,state}/*.bend; do
  want=$(grep '^#|' "$f" | sed 's/^#|//; s/^exit [0-9]$//' | sed 's/[ \t]*$//' | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}')
  got=$(timeout 30 bun bend2/main.ts "$f" 2>&1 | sed 's/[ \t]*$//' | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}')
  if [ "$got" == "$want" ]; then p=$((p+1)); else n=$((n+1)); echo "FAIL $f"; fi
done
echo "suite: $p passed, $n failed"
