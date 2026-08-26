#!/bin/sh
# The simultaneous regime, from the repository root:
#
#   sh interactive/run-asiddhavat.sh
#
# 6.4.22 असिद्धवदत्राभात् -- inside the block a rule's effect counts as not
# having taken place for every OTHER rule of the block, so the rules apply at
# once and no rule is LATER than any other.  1.4.2 विप्रतिषेधे परं कार्यम्
# picks the later operation and therefore has nothing to read here.
#
# Three columns over one corpus: the engine's own asiddhavat pass (which
# settles overlapping offers by sūtra number, unnamed, with apavāda never
# consulted), the same offers under the general scheduler with all five
# paribhāṣās named, and the same offers with para withdrawn as 6.4.22
# requires -- where the last two differ, a form was depending on succession
# inside the regime that denies it, and where nothing decides, the site is
# अवक्तव्यम् and the defect is written with its śeṣa.
set -eu

build_dir=$(mktemp -d "${TMPDIR:-/tmp}/asiddhavat.XXXXXX")
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM

ghc -O0 -iinteractive -outputdir "$build_dir/obj" \
  -o "$build_dir/asiddhavat" interactive/AsiddhavatRun.hs > "$build_dir/log" 2>&1 \
  || { cat "$build_dir/log"; exit 1; }

"$build_dir/asiddhavat"
