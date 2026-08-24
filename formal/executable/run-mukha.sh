#!/bin/sh
# The whole loop, one command, from the repository root:
#
#   sh formal/executable/run-mukha.sh machine/sanghatta-report-2026-08-23.txt
#
# utter (checked proposer, extracted) -> judge (kernel) -> keep (store).
# The only unjudged code in the pipeline is Mukha.hs, the IO boundary.
set -eu

report=${1:?usage: run-mukha.sh REPORT}
extract_dir=$(mktemp -d)
trap 'rm -rf "$extract_dir"' EXIT HUP INT TERM

# PrastavaHrdaya (the classifier's one spelling) sits beside Prastava in
# this directory; the cubical lane reaches it via natural-machine.agda-lib's
# widened include, so the soundness theorem imports the same clauses.
LC_ALL=C.UTF-8 agda -i formal/executable --compile --ghc-dont-call-ghc --no-main \
  --compile-dir="$extract_dir" formal/executable/Prastava.agda
mkdir -p "$extract_dir/build"

# MAlonzo suffixes drift as the checked module grows; derive the current
# name of `run` and shim it, so the mouth never hardcodes a suffix.
runname=$(grep -o 'd_run_[0-9]*' "$extract_dir/MAlonzo/Code/Prastava.hs" | head -1)
cat > "$extract_dir/PrastavaAPI.hs" <<EOF
module PrastavaAPI (run) where
import qualified MAlonzo.Code.Prastava as P
import qualified Data.Text as T
run :: T.Text -> T.Text -> [T.Text]
run = P.$runname
EOF
ghc -O2 -i"$extract_dir" -outputdir "$extract_dir/build" \
  formal/executable/Mukha.hs -o "$extract_dir/mukha" 1>&2
# the proposer version stamped into every receipt row: a content hash
# of the checked proposer and its shared heart, so refusals are re-asked
# exactly when the proposer has actually changed.
ver=$(cat formal/executable/Prastava.agda \
      formal/executable/PrastavaHrdaya_TheClassifierHasOneSpellingSharedByProposerAndTheorem.agda \
      | cksum | tr ' ' '-')
"$extract_dir/mukha" "$report" "prastava-$ver"
