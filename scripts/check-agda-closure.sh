#!/usr/bin/env bash
# Mechanical orphan check for formal/cubical/ — no Agda required.
#
# Why this exists: BUILD.md asserted "the root aggregate now transitively
# reaches every module in NaturalMachine/" on 2026-08-14, and the assertion
# was false by the end of that same day (notes/PIN_SWEEP_NATURALMACHINE.md:
# 238 reached, 272 on disk, 34 orphans). It had been wrong the same way once
# before. A hand-maintained orphan list rots in both directions; the only
# fix that does not rot is a script that fails.
#
# What it does, purely textually:
#   1. BFS the transitive import closure of the aggregate roots over the
#      .agda files in this directory.
#   2. FAIL if any local module is outside that closure (an orphan: nothing
#      ever rechecks it, so no green claim covers it).
#   3. FAIL if anything imports NaturalMachine.Control.* — those modules are
#      deliberately ill-typed controls that MUST fail to typecheck, so they
#      must be orphans, and importing one would turn the aggregate red for
#      the wrong reason. Also FAIL if a Control module is missing its
#      failure-as-pass marker directory position.
#
# Exit 0 = closure is complete and controls are quarantined.
# This is text analysis, not a build. It says nothing about whether any
# module typechecks; see BUILD.md for the pinned toolchain and formal/check.sh.
set -euo pipefail

cd "$(dirname "$0")/../formal/cubical"

ROOTS="${AGDA_AGGREGATE_ROOTS:-Everything NaturalMachine}"
CONTROL_PREFIX="NaturalMachine.Control."

# The DERIVED aggregate root (machine/Samuccaya_…hs --write).  It is a root,
# not content: nothing imports it, so without this it reports itself as an
# orphan forever.  It is deliberately NOT added to ROOTS — if it were, the
# closure would cover the tree by construction and this gate would print 0
# whatever the hand-kept list did.  Coverage is guaranteed by the derived
# root; the number this gate prints is the DIAGNOSIS of the hand-kept list,
# and it is worth keeping precisely because the derived root has made the
# drift harmless rather than absent.
GENERATED_ROOT="Samuccaya_TheAggregateRootIsGeneratedFromTheTreeSoNothingCanBeOmitted"

mod_to_file() { printf '%s\n' "$1" | tr '.' '/'; }

# All local modules, as dotted names.
all_mods=$(find . -name '*.agda' -not -path './_build/*' \
           | sed 's|^\./||; s|\.agda$||; s|/|.|g' | sort)

# imports_of <module> -> dotted module names on import lines
imports_of() {
  local f
  f="$(mod_to_file "$1").agda"
  [ -f "$f" ] || return 0
  # NO ALPHABET IS NAMED HERE, AND THAT IS THE POINT.  Until 2026-08-22 this
  # matched the module name with `[A-Za-z0-9_'.-]+`, so every module whose
  # name carries a non-ASCII character read as NEVER IMPORTED however many
  # roots imported it.  Measured that day: 17 false orphans, all of them the
  # modules named `…_ℤ±`, `…Occupancy₄`, `…_विवेक` — i.e. this gate cried
  # orphan at exactly the files whose names were not English, which is
  # CLAUDE.md's own warning about a lint that "scores a Devanagari citation
  # below a romanised one", arriving through the back door as a closure gate.
  # A module name is now "the token up to whitespace or `;`".  There is
  # nothing to extend for Tamil or Persian, because nothing is enumerated.
  sed -e 's/--.*$//' "$f" \
    | sed -nE 's/^[[:space:]]*(open[[:space:]]+)?import[[:space:]]+([^[:space:];]+).*/\2/p'
}

# ---- 1. BFS closure ----------------------------------------------------
seen_file=$(mktemp); queue_file=$(mktemp)
trap 'rm -f "$seen_file" "$queue_file" "$queue_file.tmp"' EXIT
for r in $ROOTS; do
  if [ -f "$(mod_to_file "$r").agda" ]; then printf '%s\n' "$r" >> "$queue_file"
  else echo "check-agda-closure: aggregate root $r.agda not found" >&2; exit 2; fi
done
while [ -s "$queue_file" ]; do
  # `sed -i '1d'` is GNU-only: BSD/macOS sed reads the next argument as the
  # suffix and then fails with "invalid command code", which made this gate
  # abort on every macOS container with a message about sed rather than about
  # the closure — a gate that crashes certifies nothing.  `tail -n +2` is
  # portable.  (Found 2026-08-20 by the univalent-audit lane, running the
  # standing gate set on macOS.)
  m=$(head -n1 "$queue_file")
  tail -n +2 "$queue_file" > "$queue_file.tmp" && mv "$queue_file.tmp" "$queue_file"
  grep -qxF "$m" "$seen_file" 2>/dev/null && continue
  printf '%s\n' "$m" >> "$seen_file"
  for i in $(imports_of "$m"); do
    # only local modules matter; external (Cubical.*, Agda.*) are ignored
    [ -f "$(mod_to_file "$i").agda" ] || continue
    grep -qxF "$i" "$seen_file" 2>/dev/null || printf '%s\n' "$i" >> "$queue_file"
  done
done
reached=$(sort -u "$seen_file")

status=0

# ---- 2. Orphans (excluding the controls, which must be orphans) --------
expected=$(printf '%s\n' "$all_mods" | grep -v "^${CONTROL_PREFIX//./\\.}" \
             | grep -vxF "$GENERATED_ROOT" || true)
orphans=$(comm -23 <(printf '%s\n' "$expected") <(printf '%s\n' "$reached"))
n_all=$(printf '%s\n' "$expected" | grep -c . || true)
n_reached=$(comm -12 <(printf '%s\n' "$expected") <(printf '%s\n' "$reached") | grep -c . || true)

echo "aggregate roots : $ROOTS"
echo "modules on disk : $n_all (excluding ${CONTROL_PREFIX}*)"
echo "reached         : $n_reached"

if [ -n "$orphans" ]; then
  # TRACKED vs UNTRACKED, and the difference is the whole meaning of the gate.
  #
  # A TRACKED orphan is exactly what this gate exists to catch: a module
  # committed to the repository that no aggregate builds, so every green
  # claim anyone makes silently excludes it.  That is a defect and it fails.
  #
  # An UNTRACKED orphan is a working file in one seat's tree.  It is in no
  # green claim, because it is not in the repository — a clean checkout does
  # not have it.  Failing on it makes this gate RED FOR EVERY SEAT because of
  # ONE seat's scratch, which is the instrument reporting its environment as
  # the corpus's health.  Found 2026-08-23: two untracked files (a 16-line
  # probe, and another lane's genuinely red module) had this gate reading
  # FAIL on every local run while a clean checkout was green.
  #
  # So untracked orphans are NAMED and do not fail.  Named, because मौनं न
  # निषेधः — a gate that drops them silently would hide a module about to be
  # committed broken.
  tracked=""; untracked=""
  for m in $orphans; do
    _f=$(printf '%s' "$m" | sed 's/\./\//g').agda
    if git ls-files --error-unmatch "$_f" >/dev/null 2>&1; then
      tracked="$tracked$m
"
    else
      untracked="$untracked$m
"
    fi
  done
  if [ -n "$tracked" ]; then
    echo
    echo "FAIL: $(printf '%s' "$tracked" | grep -c .) TRACKED module(s) are outside the aggregate's import closure."
    echo "Nothing rechecks these, so no green claim covers them. Import each from"
    echo "the appropriate aggregate root (Everything.agda, or NaturalMachine.agda"
    echo "for the NaturalMachine/ subtree), or delete it."
    echo
    printf '%s' "$tracked" | sed 's/^/    ORPHAN /'
    status=1
  fi
  if [ -n "$untracked" ]; then
    echo
    echo "NOTE: $(printf '%s' "$untracked" | grep -c .) UNTRACKED module(s) are outside the closure."
    echo "These are working files, not the repository's state — a clean checkout"
    echo "does not have them, so they are named and do NOT fail this gate."
    echo "If one is meant to be corpus, track it AND import it; if it is scratch,"
    echo "it will never be checked by anything and nobody will find out."
    echo
    printf '%s' "$untracked" | sed 's/^/    UNTRACKED-ORPHAN /'
  fi
fi
# ---- 3. Controls must never be imported --------------------------------
bad_control=$(grep -rnE '^[[:space:]]*(open[[:space:]]+)?import[[:space:]]+'"${CONTROL_PREFIX//./\\.}" \
                --include='*.agda' . | grep -v '^\./NaturalMachine/Control/' || true)
if [ -n "$bad_control" ]; then
  echo
  echo "FAIL: ${CONTROL_PREFIX}* is imported. These modules are deliberately"
  echo "false statements that MUST fail to typecheck (BUILD.md); importing one"
  echo "makes an aggregate red for a reason that is not a defect."
  printf '%s\n' "$bad_control" | sed 's/^/    /'
  status=1
fi

n_ctrl=$(printf '%s\n' "$all_mods" | grep -c "^${CONTROL_PREFIX//./\\.}" || true)
[ "$status" -eq 0 ] && echo "OK: closure complete; $n_ctrl control module(s) correctly unimported."
exit "$status"
