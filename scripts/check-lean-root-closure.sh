#!/usr/bin/env bash
# Root-reachability check for the Lean lane.  No toolchain required.
#
# ---------------------------------------------------------------------------
# WHAT THIS IS NOT, said first so nobody retires the thing that works.
#
# `scripts/check-lean-globs.sh` guards the BUILD gate: `globs = ["Pairfield",
# "Pairfield.+"]` in `lakefile.toml` makes every module under `Pairfield/` a
# build target whether or not anything imports it.  That check is the one that
# matters for soundness and this one does not replace it.
#
# This checks a DIFFERENT thing, and the difference is the whole reason it
# exists.  On 2026-08-20 the lane was measured by running the closure:
#
#     133 modules under Pairfield/
#     114 reachable from Pairfield.lean
#      19 not
#     lake build: 8840 jobs, exit 0 -- all 133 BUILT
#
# So nothing was unchecked.  What was wrong is that `import Pairfield` handed
# back 114 of 133 and said nothing about the other 19, fourteen of which are
# cited by module path in notes/.  A root that silently returns a subset is not
# a wrong answer, it is an undeclared standpoint -- and per
# `notes/AHIMSA_SUTRA_VISTARA.md` §2 a concealed naya is worse than a false one,
# because there is nothing to contradict.
#
#     यो नयं न वदति स नयं गोपयति ।  गुप्तो नयो दुर्नयो भवति ।
#
# NOT CLAIMED: that the Jaina logicians wrote about import graphs.  Theirs is
# the principle that a partial view presented without its partiality is a
# distinct fault from an error.
#
# ---------------------------------------------------------------------------
# THE EXCLUSION MECHANISM, and why it is a list rather than a judgement.
#
# A module may be legitimately out of the root -- an experiment mid-flight, a
# module whose import cost is genuinely prohibitive.  So exclusions are
# allowed, but only NAMED, in `formal/lean/root-exclusions.txt`, with a
# reason.  The last time an exclusion carried a reason in this lane, the reason
# was "that module imports all of Mathlib", and six modules ALREADY in the root
# carried a bare `import Mathlib` -- `SumRigidity` was line 2.  The ground did
# not discriminate.  Hence: the reason goes in a file a reader can check
# against the tree, not in a comment beside one import.
#
# EXIT 0 = every module under Pairfield/ is either reachable from Pairfield.lean
# or named in the exclusions file.  Stale exclusions are REPORTED, not fatal
# (they are self-pruning under anyone who reads the output).
set -euo pipefail
cd "$(dirname "$0")/../formal/lean"

ROOT=Pairfield
EXCLUSIONS=root-exclusions.txt
status=0

[ -f "$ROOT.lean" ] || { echo "check-lean-root-closure: no $ROOT.lean" >&2; exit 2; }

# --- transitive import closure of the root, restricted to in-tree modules ----
seen=$(mktemp); queue=$(mktemp); trap 'rm -f "$seen" "$queue"' EXIT
printf '%s\n' "$ROOT" > "$queue"
while [ -s "$queue" ]; do
  m=$(head -n1 "$queue"); tail -n +2 "$queue" > "$queue.t"; mv "$queue.t" "$queue"
  grep -qxF "$m" "$seen" 2>/dev/null && continue
  printf '%s\n' "$m" >> "$seen"
  f=$(printf '%s' "$m" | tr '.' '/').lean
  [ -f "$f" ] || continue
  grep -oE '^[[:space:]]*import[[:space:]]+[A-Za-z0-9_.]+' "$f" \
    | sed -E 's/.*import[[:space:]]+//' \
    | while read -r i; do
        [ -f "$(printf '%s' "$i" | tr '.' '/').lean" ] && printf '%s\n' "$i"
      done >> "$queue" || true
done

all=$(find "$ROOT" -name '*.lean' | sed 's|/|.|g; s|\.lean$||' | sort)
reach=$(sort -u "$seen")
unreached=$(comm -23 <(printf '%s\n' "$all") <(printf '%s\n' "$reach"))

n_all=$(printf '%s\n' "$all" | grep -c .)
n_reach=$(printf '%s\n' "$reach" | grep -c '^Pairfield\.' || true)
echo "modules under $ROOT/: $n_all ; reachable from $ROOT.lean: $n_reach"

# --- exclusions --------------------------------------------------------------
declared=""
if [ -f "$EXCLUSIONS" ]; then
  declared=$(grep -vE '^[[:space:]]*(#|$)' "$EXCLUSIONS" | sed 's/[[:space:]]*$//' | sort -u)
fi

undeclared=$(comm -23 <(printf '%s\n' "$unreached" | grep . | sort) \
                      <(printf '%s\n' "$declared"  | grep . | sort) || true)
stale=$(comm -13 <(printf '%s\n' "$unreached" | grep . | sort) \
                 <(printf '%s\n' "$declared"  | grep . | sort) || true)

if [ -n "$(printf '%s' "$undeclared")" ]; then
  echo "FAIL: unreachable from $ROOT.lean and not named in $EXCLUSIONS:"
  printf '%s\n' "$undeclared" | sed 's/^/    /'
  echo
  echo "Fix: add 'import <module>' to $ROOT.lean, or name it in $EXCLUSIONS"
  echo "with a reason that DISCRIMINATES -- one that is false of the modules"
  echo "already in the root is not a reason.  See this script's header."
  status=1
fi

if [ -n "$(printf '%s' "$stale")" ]; then
  echo "note: exclusions that are now reachable (or gone) -- prune them:"
  printf '%s\n' "$stale" | sed 's/^/    /'
fi

[ "$status" -eq 0 ] && echo "OK: every module under $ROOT/ is reachable or declared out."
exit "$status"
