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

# Refuse, never miscompile: a well-typed cell the emitter cannot yet lower
# exactly (unary `not` needs its operand's type) yields no program at all.
if "$BEND" "$HERE/emit_refuses_unary_not.bend" --to-hvm4-full > "$TMP/refuse.hvm4" 2>/dev/null; then
  echo "unary not was emitted" >&2
  exit 1
fi
[ ! -s "$TMP/refuse.hvm4" ] || { echo "refused emission left partial output" >&2; exit 1; }
echo "REFUSE-NOT-MISCOMPILE OK"

# Dimension names: each δ-unfolding instantiates a definition's bound labels
# freshly, so two or three instances of one definition never capture.
run "$HERE/probes/label_capture/same_definition_twice.bend" '#Pair{#Nat{},#Suc{#Suc{#Suc{#Suc{#Zer{}}}}}}'
run "$HERE/probes/label_capture/same_definition_thrice.bend" '#Pair{#Nat{},#Suc{#Suc{#Suc{#Suc{#Suc{#Suc{#Suc{#Suc{#Suc{#Suc{#Suc{#Suc{#Suc{#Suc{#Suc{#Suc{#Zer{}}}}}}}}}}}}}}}}}}'
echo "FRESH-DIMENSIONS OK"

# A type that mentions a recursive call on a bound variable is a finite
# normal form: a neutral call stays folded (stock normalisation diverges).
(cd "$HERE" && "$BEND" neutral_type_smoke.bend --to-hvm4-full) > "$TMP/nt.hvm4" 2>/dev/null
timeout 60 "$HVM" "$TMP/nt.hvm4" -s > "$TMP/nt.out"
grep -Fq '#Suc{#Suc{@Ddouble(c)}}' "$TMP/nt.out"
grep -Fq ',#Pair{#Suc{#Suc{#Zer{}}},#PLm{' "$TMP/nt.out"
echo "NEUTRAL-TYPE OK"

# The machine that asks: the runtime keeps its heap and typed point; asking
# `double` then `recover` gives (recover p, (p, refl)) with recover p = 3,
# the source read off the retained coordinate of p = (6, (3, refl)).
printf 'double\n:type\nrecover\n' | (cd "$HERE" && HVM="$HVM" timeout 120 "$BEND" interact_smoke.bend --interact) > "$TMP/ask.out" 2>/dev/null
python3 - "$TMP/ask.out" <<'PY'
import sys
blocks = open(sys.argv[1]).read().split('- End\n')
def split(n):
    assert n.startswith('#Pair{'), n[:40]
    b, d = n[6:], 0
    for i, c in enumerate(b):
        if c in '{(': d += 1
        elif c in '})': d -= 1
        elif c == ',' and d == 0: return b[:i], b[i+1:-1]
root = lambda blk: blk.splitlines()[0].split(';!')[0]
three = '#Suc{#Suc{#Suc{#Zer{}}}}'
six = '#Suc{#Suc{#Suc{#Suc{#Suc{#Suc{#Zer{}}}}}}}'
assert root(blocks[0]) == '#Pair{#Nat{},' + three + '}', blocks[0]
_, v1 = split(root(blocks[1]))
b1, w1 = split(v1); a1, _ = split(w1)
assert (b1, a1) == (six, three), v1
assert blocks[2].splitlines()[0] == 'Σb:Nat. Σx:Nat. PathP(λ_. Nat,double(x),b)', blocks[2]
_, v2 = split(root(blocks[3]))
b2, w2 = split(v2); p, _ = split(w2)
assert b2 == three, v2
assert p.startswith('#Pair{' + six + ',#Pair{' + three + ','), p
PY
echo "ASK OK"
