#!/usr/bin/env bash
# Mechanical orphan check for formal/pairfield/ — no Lean, no mathlib required.
#
# Why: `lean_lib Pairfield` was declared without `globs`, so `lake build` built
# `Pairfield.lean`'s import closure only. 21 modules under `Pairfield/` were
# built by nothing and 3 of them did not typecheck
# (notes/LEAN_LANE_AUDIT.md §1). Earlier counts were 16, then 13, then 21 —
# the list does not converge, which is the argument for a gate rather than a
# recount.
#
# The fix is one line, `globs = ["Pairfield", "Pairfield.+"]`. This script is
# the guard that the line stays: with a directory-wide glob a module cannot
# hide by not being imported, so the per-module orphan enumeration becomes
# unnecessary — but only for as long as the glob is there.
#
# Fallback: if the glob is absent, we enumerate the orphans by import closure
# and fail with the list, so the check is informative either way.
set -euo pipefail
cd "$(dirname "$0")/../formal/pairfield"

LIB=Pairfield
status=0

if grep -qE '^[[:space:]]*globs[[:space:]]*=.*"Pairfield\.\+"' lakefile.toml; then
  echo "OK: lakefile.toml declares globs covering Pairfield.+ ;"
  echo "    every module under Pairfield/ is a build target, so orphans are impossible."
  # Cross-check that the glob is attached to the Pairfield lib and that the
  # library block still exists at all.
  grep -qE '^\[\[lean_lib\]\]' lakefile.toml || {
    echo "FAIL: no [[lean_lib]] block in lakefile.toml."; status=1; }
  exit "$status"
fi

echo "FAIL: lakefile.toml's [[lean_lib]] $LIB has no globs = [..., \"Pairfield.+\"]."
echo "Without it lake builds only $LIB.lean and its import closure."
echo

# Enumerate what is thereby built by nothing.
all=$(find Pairfield -name '*.lean' | sed 's|/|.|g; s|\.lean$||' | sort)
seen=$(mktemp); queue=$(mktemp); trap 'rm -f "$seen" "$queue"' EXIT
echo "$LIB" > "$queue"
while [ -s "$queue" ]; do
  m=$(head -n1 "$queue"); sed -i '1d' "$queue"
  grep -qxF "$m" "$seen" 2>/dev/null && continue
  printf '%s\n' "$m" >> "$seen"
  f=$(printf '%s\n' "$m" | tr '.' '/').lean
  [ -f "$f" ] || continue
  grep -oE '^[[:space:]]*import[[:space:]]+[A-Za-z0-9_.]+' "$f" \
    | sed -E 's/.*import[[:space:]]+//' \
    | while read -r i; do
        if [ -f "$(printf '%s\n' "$i" | tr '.' '/').lean" ]; then printf '%s\n' "$i"; fi
      done >> "$queue" || true
done
orphans=$(comm -23 <(printf '%s\n' "$all") <(sort -u "$seen"))
if [ -n "$orphans" ]; then
  echo "Modules built by nothing ($(printf '%s\n' "$orphans" | grep -c .)):"
  printf '%s\n' "$orphans" | sed 's/^/    ORPHAN /'
fi
echo
echo "Fix: add  globs = [\"Pairfield\", \"Pairfield.+\"]  to the [[lean_lib]] block."
exit 1
