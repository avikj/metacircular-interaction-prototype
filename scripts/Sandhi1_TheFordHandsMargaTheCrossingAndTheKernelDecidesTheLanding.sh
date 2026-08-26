#!/usr/bin/env bash
# सन्धि-१ — the ford hands मार्ग the crossing, and the kernel decides the landing.
#
# THE TERM.  सन्धि, ordinary Sanskrit for junction (the compound declared
# जोड़ १).  No text is claimed.
#
# WHAT THIS IS.  तीर्थ's header names the assembly's defect: "मार्ग routes on
# demand, so a checked A ≃ B can land and NOTHING HAPPENS — it has a clock
# where it needs an event."  And तीर्थ already prints the repair as data: its
# सङ्क्रमणाय block emits literal `marga  S  T` lines and says they are
# "exactly the argument list मार्ग wants".  Until this script, nothing
# consumed them.  This is the pipe:
#
#   १ · run तीर्थ (which diffs the admitted edge list against its snapshot
#       and rolls the snapshot forward — its own designed side effect);
#   २ · take every `marga  S  T` line it printed;
#   ३ · hand each pair to मार्ग, which prints THE ROUTE — every edge with
#       its proving declaration, the toll as edge count, inversions marked;
#   ४ · where a theorem to carry and a kernel are both present, मार्ग can
#       emit the transporting module (--pred/--proof/--prelude) and the
#       kernel decides the landing.  THIS SCRIPT DOES NOT CHOOSE THE
#       THEOREM: a ford says a crossing is possible and says nothing about
#       whether the far bank is wanted, and the same restraint holds here.
#       Routes are exhibited; carrying is a mind's or a later stage's act.
#
# THE THREE REDS, at the site.  If `agda` is absent this host cannot land
# anything, and that is a fact about the CONTAINER (host red), not about
# the mathematics and not about the route.  The script says which.
#
# WORTH-FILTER, per the सन्धि note's own caveat: at most SANDHI1_MAX pairs
# are routed per run (default 8), so a landing that merges two large
# components does not fan out into hundreds of speculative routes.  What is
# skipped is COUNTED AND NAMED, never silently dropped.
#
#   run:  sh scripts/Sandhi1_….sh              तीर्थ-driven (the event path)
#         sh scripts/Sandhi1_….sh S T [S T …]  route the given pairs instead
#
set -u
cd "$(dirname "$0")/.." || exit 2
export LC_ALL=C.utf8
W="${SANDHI1_SCRATCH:-${TMPDIR:-/tmp}/sandhi1}"; mkdir -p "$W"
MAX="${SANDHI1_MAX:-8}"

marga() { runghc -iinteractive interactive/Marga_TheRouterTransportsATheoremAlongLandedEdges.hs . "$@"; }

echo "═══ सन्धि-१ · the landing becomes an event that routes ═══"

if [ $# -gt 0 ]; then
  # explicit pairs: the test path, and the path another organ can call
  set -- "$@"
  : > "$W/pairs.tsv"
  while [ $# -ge 2 ]; do printf '%s\t%s\n' "$1" "$2" >> "$W/pairs.tsv"; shift 2; done
else
  runghc -iinteractive interactive/Tirtha_TheLandedEdgeIsAFordAndTheReportIsWhoCanNowCross.hs . \
    | tee "$W/tirtha.txt"
  # तीर्थ's marga lines are "marga  S  T" behind leading whitespace, with
  # two-space separators; node names may contain single spaces, so split on
  # the double space only.  The indent is NOT pinned: the ford was rewritten
  # under this script within minutes of its first commit (27ee0101 moved one
  # emission site to an eight-space indent), and a guard pinned to the old
  # indent would have silently dropped every pair from the new site — the
  # exact defect class dosa.lekha exists for.  Fields, not margins.
  awk -F'  +' '$2 == "marga" && NF >= 4 { printf "%s\t%s\n", $3, $4 }' \
    "$W/tirtha.txt" | sort -u > "$W/pairs.tsv"
fi

N=$(wc -l < "$W/pairs.tsv" | tr -d ' ')
if [ "$N" -eq 0 ]; then
  echo ""
  echo "  no newly-crossable pairs this run.  मौनं न निषेधः: this is silence"
  echo "  about component MERGES only — a ford that joined a previously"
  echo "  unjoined bank has no pair list, and road two is invisible here."
  exit 0
fi

echo ""
echo "  $N newly-crossable pair(s); routing the first $MAX, skipping $(( N > MAX ? N - MAX : 0 )) (named in $W/pairs.tsv)."
head -n "$MAX" "$W/pairs.tsv" | while IFS="$(printf '\t')" read -r S T; do
  echo ""
  echo "── मार्ग  $S  →  $T ──"
  marga "$S" "$T" 2>&1 | grep -vE '^marga: Setubandha printed'
done

echo ""
if command -v agda >/dev/null 2>&1; then
  echo "  kernel present.  To carry a theorem across a route above, give मार्ग"
  echo "  --out/--module/--prelude/--pred/--proof and land only on exit 0."
else
  echo "  KERNEL ABSENT ON THIS HOST (karana-dosa, host red — a fact about"
  echo "  the container, not the mathematics).  Routes are exhibited above;"
  echo "  nothing is emitted and nothing is landed.  A seat with the pinned"
  echo "  Agda 2.8.0 + cubical v0.9 completes stage ४."
fi
