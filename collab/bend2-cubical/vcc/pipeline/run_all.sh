#!/usr/bin/env bash
# The vertical slice, end to end. Point DATA at a directory holding the real VCC files

set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"; cd "$here"
PY="${PY:-/tmp/vcc-venv/bin/python}"; CE="${CE:-/tmp/vcc-venv/bin/cell-eval}"
DATA="${DATA:-$here/data}"; THREADS="${THREADS:-4}"
"$PY" install_generators.py --train "$DATA/train.h5ad" --out "$DATA/generators.json"
"$PY" predict.py --controls "$DATA/valid_controls.h5ad" --generators "$DATA/generators.json" --counts "$DATA/pert_counts_Validation.csv" --out "$DATA/pred.h5ad"
# the submission artefact
"$CE" prep -i "$DATA/pred.h5ad" -g "$DATA/gene_names.csv" -o "$DATA/pred.prep.vcc" --expected-gene-dim -1
if [ -f "$DATA/valid_truth.h5ad" ]; then
  rm -rf "$DATA/eval-user" "$DATA/eval-base"
  "$CE" run -ap "$DATA/pred.h5ad" -ar "$DATA/valid_truth.h5ad" --profile vcc --num-threads "$THREADS" -o "$DATA/eval-user"
  "$CE" baseline -i "$DATA/valid_truth.h5ad" -p "$DATA/pert_counts_Validation.csv" -o "$DATA/baseline.h5ad" -O "$DATA/baseline_de.csv" --num-threads "$THREADS" 2>/dev/null \
    || "$CE" baseline --help | head -40
  "$CE" run -ap "$DATA/baseline.h5ad" -ar "$DATA/valid_truth.h5ad" --profile vcc --num-threads "$THREADS" -o "$DATA/eval-base"
  "$CE" score --user-input "$DATA/eval-user/agg_results.csv" --base-input "$DATA/eval-base/agg_results.csv" --output "$DATA/score.csv"
  cat "$DATA/score.csv"
fi
# the same slice on the HVM4 runtime, checked against numpy
"$PY" to_bend.py --controls "$DATA/valid_controls.h5ad" --truth "$DATA/valid_truth.h5ad" --generators "$DATA/generators.json" --out "$DATA/bend" ${BEND_ARGS:-}
