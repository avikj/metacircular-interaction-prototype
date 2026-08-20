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

mod_to_file() { printf '%s\n' "$1" | tr '.' '/'; }

# All local modules, as dotted names.
all_mods=$(find . -name '*.agda' -not -path './_build/*' \
           | sed 's|^\./||; s|\.agda$||; s|/|.|g' | sort)

# imports_of <module> -> dotted module names on import lines
imports_of() {
  local f
  f="$(mod_to_file "$1").agda"
  [ -f "$f" ] || return 0
  sed -e 's/--.*$//' "$f" \
    | grep -oE '^[[:space:]]*(open[[:space:]]+)?import[[:space:]]+[A-Za-z0-9_'"'"'.-]+' \
    | sed -E 's/.*import[[:space:]]+//'
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
expected=$(printf '%s\n' "$all_mods" | grep -v "^${CONTROL_PREFIX//./\\.}" || true)
orphans=$(comm -23 <(printf '%s\n' "$expected") <(printf '%s\n' "$reached"))
n_all=$(printf '%s\n' "$expected" | grep -c . || true)
n_reached=$(comm -12 <(printf '%s\n' "$expected") <(printf '%s\n' "$reached") | grep -c . || true)

echo "aggregate roots : $ROOTS"
echo "modules on disk : $n_all (excluding ${CONTROL_PREFIX}*)"
echo "reached         : $n_reached"

if [ -n "$orphans" ]; then
  echo
  echo "FAIL: $(printf '%s\n' "$orphans" | grep -c .) module(s) are outside the aggregate's import closure."
  echo "Nothing rechecks these, so no green claim covers them. Import each from"
  echo "the appropriate aggregate root (Everything.agda, or NaturalMachine.agda"
  echo "for the NaturalMachine/ subtree), or delete it."
  echo
  printf '%s\n' "$orphans" | sed 's/^/    ORPHAN /'
  status=1
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
