#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
BEND=${BEND:-$ROOT/research/biology_exact/build/toolchain/Bend2-f026483/dist-newstyle/build/aarch64-osx/ghc-9.14.1/bend-0.1.0.0/x/bend/build/bend/bend}
HVM=${HVM:-$ROOT/research/biology_exact/build/toolchain/hvm4}
STAGE=$(mktemp -d "${TMPDIR:-/tmp}/rubiks-family.XXXXXX")
trap 'rm -rf "$STAGE"' EXIT

# The historical port files contain non-UTF8 prose bytes in comments.  Strip
# those comment bytes in the isolated staging copy only; the Bend source and
# runtime are otherwise unchanged.
for name in FibreElement FibreCoalgebra Prelude MyhillNerodeMinimalMachine Effective HProp SetQuotient; do
  LC_ALL=C sed 's/[^[:print:]\t]//g' "$ROOT/collab/bend2-cubical/port/$name.bend" \
    > "$STAGE/$name.bend"
done
cp "$ROOT/research/rubiks_cube/RubiksFamily.bend" "$STAGE/RubiksFamily.bend"

# Keep the compiler report alongside the emitted term; the source is the exact
# object sent to the native evaluator.
# The full emitter performs the same source/type validation and writes the
# native term in one pass.  Keeping one compiler invocation matters here: a
# second standalone report pass needlessly re-normalizes the large family
# object before the evaluator sees it.
"$BEND" "$STAGE/RubiksFamily.bend" --to-hvm4-full \
  > "$ROOT/research/rubiks_cube/RubiksFamily.hvm4" \
  2> "$ROOT/research/rubiks_cube/bend-check.log"
# Suppress the fully expanded facelet term while retaining native statistics.
# The complete object remains the evaluated root; only terminal pretty-printing
# is suppressed to avoid duplicating the large exact state in the log.
"$HVM" "$ROOT/research/rubiks_cube/RubiksFamily.hvm4" -S -s -C \
  > "$ROOT/research/rubiks_cube/hvm-runtime.log"
