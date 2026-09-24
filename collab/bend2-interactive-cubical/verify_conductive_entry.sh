#!/usr/bin/env bash
# End-to-end check of the full-runtime seam: one checker, one emitter, one net.
#   - only a checked book is emitted, and ill-typed input yields no program;
#   - the root is the checked entry as a typed point (A, a) of Σ(A : Set). A;
#   - types are emitted cells like any other (Eql, Enum, ua with coherences);
#   - the fibre law and its coinductive continuation are ordinary Bend
#     (port/FibreCoalgebra.bend) running through the same emitter.
set -euo pipefail
export LC_ALL=C.UTF-8 LANG=C.UTF-8
BEND="${1:-bend}"
HVM="${2:-hvm}"
HERE="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# run FILE EXPECTED: compile (from FILE's directory, so imports resolve), then
# require the exact normal form of the root.
run() {
  local src="$1" want="$2" out
  (cd "$(dirname "$src")" && "$BEND" "$(basename "$src")" --to-hvm4-full) > "$TMP/p.hvm4" 2> "$TMP/check.log"
  grep -Fqx '@main = #Pair{@Tmain, @Dmain}' "$TMP/p.hvm4"
  out="$("$HVM" "$TMP/p.hvm4" -s 2>&1)"
  printf '%s\n' "$out"
  [ "$(printf '%s\n' "$out" | head -1)" = "$want" ] || {
    echo "$src: expected root $want" >&2
    exit 1
  }
}

run "$HERE/conductive_entry_smoke.bend" '#Pair{#Nat{},#Suc{#Suc{#Zer{}}}}'
grep -Eqx '@Tid = #Pi\{#Nat, λ&b[0-9]+u[0-9]+\. #Nat\}' "$TMP/p.hvm4"
echo "TYPED-POINT OK"

run "$HERE/port/FibreCoalgebra.bend" '#Pair{#Nat{},#Suc{#Suc{#Zer{}}}}'
run "$HERE/port/ConductiveRuntime.bend" '#Pair{#Nat{},#Suc{#Suc{#Zer{}}}}'
echo "FIBRE-LAW-AND-CONTINUATION OK"

run "$HERE/complex_cells_smoke.bend" '#Pair{#Bool{},0}'
grep -Fqx '@DnegPath = #UaU{#Bool, #Bool, @Dneg, @Dneg, @DnegLnv, @DnegLnv}' "$TMP/p.hvm4"
grep -Fqx '@DColour = #Enum{#Con{#red, #Con{#green, #Nil}}}' "$TMP/p.hvm4"
grep -Eq '^@Trefl = .*#Eql\{(b[0-9]+u[0-9]+), (b[0-9]+u[0-9]+), \2\}' "$TMP/p.hvm4"
echo "CELLS OK"

if "$BEND" "$HERE/gate_mustfail.bend" --to-hvm4-full > "$TMP/gate.hvm4" 2>/dev/null; then
  echo "ill-typed input was emitted" >&2
  exit 1
fi
[ ! -s "$TMP/gate.hvm4" ] || { echo "ill-typed input produced output" >&2; exit 1; }
echo "CHECK-GATE OK"
