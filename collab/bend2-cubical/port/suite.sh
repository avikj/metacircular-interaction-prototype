#!/usr/bin/env bash
# The port's suite: the biological presentations and their front-ends' output.
# Every listed file must check clean (≥1 ✓, 0 ✗); every registered probe must
# contain EXACTLY one rejected definition, the one it names. Run:
#   ./suite.sh [path-to-bend]        (default: $(cat /tmp/BENDBIN) or `bend`)
# Regenerates the emitted files from scripts/examples first, so a drift
# between an emitter and its checked output reads as a failure here.
set -u
export LC_ALL=C.utf8 LANG=C.utf8
BEND="${1:-$(cat /tmp/BENDBIN 2>/dev/null || echo bend)}"
cd "$(dirname "$0")" || exit 1
ROOT="$(cd ../../.. && pwd)"
FILES="Nerode Perturbation GRN WholeCell PerturbationEmitted PerturbationBench PerturbationBenchSlow Spatial SpatialEmitted Lineage LineageEmitted Dynamics Reaction ReactionEmitted Pangenome PangenomeEmitted PangenomeSpecEmitted"
PROBES="Perturbation_mustfail:hkResp_WRONG Spatial_mustfail:cellResp_WRONG Reaction_mustfail:fireResp_WRONG"
python3 "$ROOT/scripts/emit-perturbation.py" "$ROOT/scripts/examples/vcc_shape.json" -o PerturbationEmitted.bend 2>/dev/null
python3 "$ROOT/scripts/emit-reaction.py" "$ROOT/scripts/examples/toy_pathway.xml" --petab "$ROOT/scripts/examples/toy_petab.json" -o ReactionEmitted.bend 2>/dev/null
python3 "$ROOT/scripts/emit-pangenome.py" "$ROOT/scripts/examples/two_bubbles.gfa" --ref altA -o PangenomeEmitted.bend 2>/dev/null
python3 "$ROOT/scripts/emit-pangenome.py" "$ROOT/scripts/examples/gfa_spec_example.gfa" -o PangenomeSpecEmitted.bend 2>/dev/null
python3 "$ROOT/scripts/emit-lineage.py" "$ROOT/scripts/examples/lineage.nwk" --kinds n=neuron,a=astrocyte -o LineageEmitted.bend 2>/dev/null
python3 "$ROOT/scripts/emit-spatial.py" "$ROOT/scripts/examples/points.csv" --segs "$ROOT/scripts/examples/segmentations.json" -o SpatialEmitted.bend 2>/dev/null
bad=0; n=0
for f in $FILES; do
  n=$((n+1)); out=$(timeout 300 "$BEND" "$f.bend" 2>&1)
  ok=$(printf '%s' "$out" | grep -c "✓"); ko=$(printf '%s' "$out" | grep -c "✗")
  if [ "$ko" -eq 0 ] && [ "$ok" -ge 1 ]; then printf '  ok   %-26s %4s ✓\n' "$f" "$ok"; else echo "FAIL $f ok=$ok ko=$ko"; bad=$((bad+1)); fi
done
for pr in $PROBES; do
  f=${pr%%:*}; want=${pr##*:}; n=$((n+1)); out=$(timeout 300 "$BEND" "$f.bend" 2>&1)
  ko=$(printf '%s' "$out" | grep -c "✗"); name=$(printf '%s' "$out" | grep "✗" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $2}' | tr '\n' ' ')
  if [ "$ko" -eq 1 ] && [ "$name" = "$want " ]; then printf '  ok   %-26s rejects exactly %s\n' "$f" "$want"; else echo "PROBE-FAIL $f (want exactly 1 ✗ at $want; got $ko: $name)"; bad=$((bad+1)); fi
done
echo "files=$n bad=$bad"; [ "$bad" -eq 0 ]
