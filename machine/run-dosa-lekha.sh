#!/bin/sh
# run-dosa-lekha.sh — build and run the doṣa-lekha, the machine's second organ.
#
#   sh machine/run-dosa-lekha.sh schema
#   sh machine/run-dosa-lekha.sh count
#   sh machine/run-dosa-lekha.sh verify
#   sh machine/run-dosa-lekha.sh query --jati avaktavya
#   sh machine/run-dosa-lekha.sh replay 3 --run
#   sh machine/run-dosa-lekha.sh write < entry.txt
#
# AHIMSA_SUTRA_VISTARA §6: where transport is not possible the defect is
# written; a written defect lives, an unwritten defect is hiṃsā, and there
# is no third path.  The first organ is transport, checked in Agda.  This
# is the second, and it is the one the machine did not have.
#
# Run from the repository root.  Needs ghc and nothing else — no network,
# no Agda, no Lean, no Python.  The binary is rebuilt only when the source
# is newer, so `count` is cheap enough to be in anyone's loop.
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
SRC="$ROOT/machine/DosaLekha_TheWrittenDefectRecord.hs"
OUT="${DOSA_BIN:-/tmp/dosalekha-$(id -u)}"
if [ ! -x "$OUT" ] || [ "$SRC" -nt "$OUT" ]; then
  ghc -O0 -Wall -main-is DosaLekha_TheWrittenDefectRecord.main \
      -outputdir "$(dirname "$OUT")/dosalekha-build-$(id -u)" \
      -o "$OUT" "$SRC" >/dev/null || {
    echo "run-dosa-lekha: ghc failed on $SRC" >&2; exit 2; }
fi
cd "$ROOT" || exit 2
exec "$OUT" "$@"
