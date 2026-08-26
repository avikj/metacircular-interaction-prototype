#!/bin/sh
# run-yantra.sh — THE ONE COMMAND.  Build the machine, turn it, show what it did.
#
#   sh interactive/run-yantra.sh              the scripted session, contract checked
#   sh interactive/run-yantra.sh --wire       JSON lines on stdin/stdout, for an LLM
#
# यन्त्रम् is judged by being turned.  Green here means, and means only:
#
#   * every answer in the session was a saṃkramaṇa or a doṣa-lekha — there is
#     no third road and none was taken (§6);
#   * every answer carried its own position (nirṇaya) and the route by which
#     it is a pramāṇa (prāmāṇya) with that route's witness; no transport
#     arrived by the unaccepted route `ayogya`;
#   * every transport carried an object, an exhibited identification, and a
#     stated vyaya; every defect named its losses one by one;
#   * cakravāla D = 61 → (1766319049, 226153980), Bhāskara II's own value,
#     Bījagaṇita 1150, computed through the reactor with the composition law
#     as a VALUE rather than baked in;
#   * aṆ → a i u;
#   * Saptabhangi.Sthana ≃ Obstruction.Sthana, BOTH round trips, all sixteen
#     cases, run this session — the transport the machine relies on;
#   * SaptabhangiGarbha → Saptabhangi has NO section, with the two colliding
#     objects constructed and compared in the run — the defect the machine
#     writes rather than resolving;
#   * replay ∘ journal = id on the store as the session actually left it;
#   * every defect the machine wrote was filed into the doṣa-lekha over that
#     organ's own `write`-on-stdin interface, and the chain verifies from
#     inside the session (`dosa.pramanya`).
#
# THE SESSION LOG IS SESSION-SCOPED, ON PURPOSE.  $DOSA_LEKHA points at
# interactive/yantra-session.lekha and NOT at interactive/dosa.lekha.  Four lanes are
# appending to the shared log today (doṣa 0013, 0014); a demonstration that
# writes twenty records into it would be this file's own first defect.  The
# organ, the format, the validator and the chain are the same; only the file
# differs, and `dosa.pramanya` verifies whichever one it is pointed at.
#
# THE SEAM, stated rather than discovered.  This machine imports
# interactive/RewriteEngine.hs (120 KB) and interactive/RefusalAnalysis.hs, which other
# lanes edit.  A grammar file mid-surgery does not typecheck, and failing the
# whole check then would report `the machine is broken` when the true
# statement is `another lane is mid-edit`.  Those are two facts and a single
# red merges them, so the build failure below says which side it is on.
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
OUT="${YANTRA_OUT:-${TMPDIR:-/tmp}/yantra-$(id -u)}"
mkdir -p "$OUT"

# organ 2: the doṣa-lekha, built first, because the machine files into it.
DOSA_SRC="$ROOT/interactive/DefectRecord.hs"
DOSA_BIN="$OUT/dosalekha"
if [ ! -x "$DOSA_BIN" ] || [ "$DOSA_SRC" -nt "$DOSA_BIN" ]; then
  ghc -O0 -main-is DefectRecord.main \
      -outputdir "$OUT/dosa-build" -o "$DOSA_BIN" "$DOSA_SRC" >"$OUT/dosa-build.log" 2>&1 || {
    echo "run-yantra: the doṣa-lekha did not build.  first errors:" >&2
    grep -E "error" -A6 "$OUT/dosa-build.log" | head -20 >&2
    exit 2; }
fi

mine="Server.hs Main.hs"
BIN="$OUT/yantra"
SRCTREE="the working tree"

if ghc -O0 -i"$ROOT/interactive" -outputdir "$OUT/build" -o "$BIN" \
       "$ROOT/interactive/Main.hs" >"$OUT/build.log" 2>&1; then
  echo "built from the working tree."
else
  echo "the working tree did not build.  first errors:" >&2
  grep -E "error:" -A6 "$OUT/build.log" | head -20 >&2
  echo >&2
  if grep -E "error:" "$OUT/build.log" | grep -qE "$(echo $mine | tr ' ' '|')"; then
    echo "the errors name this machine's OWN modules.  that is this lane's fault," >&2
    echo "and falling back would hide it." >&2
    exit 1
  fi

  # The errors name another lane's file.  Build against the last COMMITTED
  # version of everything that is not mine, and say — in the open, in the
  # doṣa-lekha's own vocabulary — exactly which working-tree files the green
  # below does NOT cover.  A single red here would merge `the machine is
  # broken` with `another lane is mid-edit`, and those are two facts.
  ISO="$OUT/iso"
  rm -rf "$ISO"; mkdir -p "$ISO"
  ( cd "$ROOT" && git ls-tree --name-only HEAD interactive/ ) \
    | grep '\.hs$' | sed 's|^interactive/||' > "$OUT/head-files"
  while read -r f; do
    ( cd "$ROOT" && git show "HEAD:interactive/$f" ) > "$ISO/$f" 2>/dev/null
  done < "$OUT/head-files"
  for f in $mine; do cp "$ROOT/interactive/$f" "$ISO/$f"; done

  if ! ghc -O0 -i"$ISO" -outputdir "$ISO/out" -o "$BIN" "$ISO/Main.hs" \
          >"$ISO/build.log" 2>&1; then
    if grep -E "error:" "$ISO/build.log" | grep -qE "$(echo $mine | tr ' ' '|')"; then
      echo "the fallback build fails IN THIS LANE'S OWN FILE, and that is a third" >&2
      echo "fact, not the second: this machine is written against a sibling's" >&2
      echo "WORKING-TREE api, and HEAD's is different.  Neither tree is broken;" >&2
      echo "they have skewed, and there is no version of this file that compiles" >&2
      echo "against both.  Naming it as this lane's fault would be false and" >&2
      echo "naming it as the sibling's would be false too." >&2
      echo >&2
    else
      echo "the committed engine does not build either:" >&2
    fi
    grep -E "error:" -A6 "$ISO/build.log" | head -20 >&2
    exit 1
  fi
  SRCTREE="HEAD for every module except this lane's own"

  cat <<'NOTE'

DOṢA-LEKHA (run-yantra, jāti: karaṇa-doṣa)
  hetu: a module this machine imports does not typecheck in the working
        tree; another lane is mid-edit.  Built against HEAD for everything
        except this lane's own two files, which ARE the working-tree ones.
  naṣṭa (what the green below does NOT cover):
NOTE
  ( cd "$ROOT" && git diff --name-only -- interactive/ ) | grep '\.hs$' | while read -r f; do
    echo "    − $f as it stands in the working tree, uncompiled and unrun here"
  done
  cat <<'NOTE'
  śeṣa:
    → rerun once that lane commits; the fallback disappears by itself
    → this is the same seam interactive/check-sabha.sh records, and the same
      repair.  Two lanes reaching it independently is evidence the repair is
      right and stronger evidence that the missing thing is a mechanism.
NOTE
  echo
fi

# A fresh session log each run: the chain starts at genesis and the whole of
# it is the session, so `dosa.pramanya` is verifying THIS run and not a
# history it did not produce.
LEKHA="${DOSA_LEKHA:-$ROOT/interactive/yantra-session.lekha}"
rm -f "$LEKHA"
TRANSCRIPT="${YANTRA_LEKHA:-$OUT/yantra.jsonl}"
rm -f "$TRANSCRIPT"

cd "$ROOT" || exit 2
DOSA_LEKHA="$LEKHA" DOSA_BIN="$DOSA_BIN" \
YANTRA_LEKHA="$TRANSCRIPT" MATH_ROOT="$ROOT" \
YANTRA_KALA="$(date +%Y-%m-%d)" \
  "$BIN" "$@"
status=$?

if [ "${1:-}" != "--wire" ]; then
  echo
  echo "──────────────────────────────── the filed defects, on disk"
  DOSA_LEKHA="$LEKHA" "$DOSA_BIN" count 2>/dev/null || echo "  (none filed)"
  echo
  echo "  built from         : $SRCTREE"
  echo "  session doṣa-lekha : $LEKHA"
  echo "  wire transcript    : $TRANSCRIPT"
  echo "  the transcript is the corpus this machine is meant to be post-trained"
  echo "  against; it is append-only, one line per turn, request and answer."
fi
exit $status
