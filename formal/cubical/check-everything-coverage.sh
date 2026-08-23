#!/usr/bin/env bash
#
# check-everything-coverage.sh — the mechanical latch BUILD.md demands.
#
# Everything.agda is a HAND-MAINTAINED import list, and BUILD.md / its own
# SEED-81 comment predicted the failure mode exactly:
#
#     "A hand-maintained list of orphans rots in both directions … the
#      check is mechanical and takes one command; run it rather than
#      trusting this file."
#
# This is that one command. It does NOT typecheck anything — a green run
# here plus per-module exit-0 (the actual build) together make the honest
# aggregate claim "Everything.agda covers the whole directory, and the
# whole directory checks". Alone it proves only COVERAGE: that the import
# list names exactly the set of modules on disk, no more and no less.
#
# Scope of "the directory":
#   * every top-level  formal/cubical/*.agda   (except Everything.agda)
#   * every            formal/cubical/Swarm/*.agda
# The NaturalMachine/ subtree (incl. NaturalMachine/Control/) is covered
# transitively through the NaturalMachine root and is NOT enumerated here;
# a dangling import INTO that subtree is still caught (rot-back checks the
# file behind every import line, wherever it points).
#
# Two directions of rot, both fatal:
#   rot-forward : a module file on disk that no import line names
#                 (invisible to a latch made of names — the SEED-81 hole).
#   rot-back    : an import line naming a module whose file is absent.
#
# Exit 0 iff the two sets coincide exactly. Any diff -> exit 1, names printed.

set -u
export LC_ALL=C.UTF-8

# Anchor to this script's own directory so it runs from anywhere.
cd "$(dirname "$0")" || { echo "cannot cd to script dir" >&2; exit 2; }

EVERYTHING="Everything.agda"
[ -f "$EVERYTHING" ] || { echo "FATAL: $EVERYTHING not found in $(pwd)" >&2; exit 2; }

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# ---------------------------------------------------------------------------
# 1. Modules that OUGHT to be imported: files on disk, as module names.
#    top-level Foo.agda            -> Foo
#    Swarm/S00Bar.agda             -> Swarm.S00Bar
# ---------------------------------------------------------------------------
{
  for f in ./*.agda; do
    b="$(basename "$f" .agda)"
    [ "$b" = "Everything" ] && continue
    printf '%s\n' "$b"
  done
  for f in ./Swarm/*.agda; do
    [ -e "$f" ] || continue
    b="$(basename "$f" .agda)"
    printf 'Swarm.%s\n' "$b"
  done
} | sort -u > "$work/on_disk"

# ---------------------------------------------------------------------------
# 2. Modules Everything.agda ACTUALLY imports. Anchored parse: a real import
#    statement begins the line (optionally "open "), so prose containing the
#    word "import" inside comments is never matched. First token after the
#    keyword is the module name; trailing "using(...)"/"as X" is dropped.
# ---------------------------------------------------------------------------
grep -E '^[[:space:]]*(open[[:space:]]+)?import[[:space:]]+' "$EVERYTHING" \
  | sed -E 's/^[[:space:]]*(open[[:space:]]+)?import[[:space:]]+//; s/[[:space:]].*$//' \
  | grep -v '^$' \
  | sort > "$work/imports_all"        # NOT -u: keep dupes for the dup check

sort -u "$work/imports_all" > "$work/imported"

# ---------------------------------------------------------------------------
# 3a. rot-forward: on disk, never named by an import line.
#     Restricted to the enumeration scope (on_disk), which already excludes
#     the NaturalMachine subtree.
# ---------------------------------------------------------------------------
comm -23 "$work/on_disk" "$work/imported" > "$work/rot_forward"

# ---------------------------------------------------------------------------
# 3b. rot-back: an import line whose module has no file behind it. Checked by
#     resolving the module to a path (dots -> slashes, + ".agda") and testing
#     existence, so it catches dangling imports anywhere, including into the
#     NaturalMachine subtree that step 3a does not enumerate.
# ---------------------------------------------------------------------------
: > "$work/rot_back"
while IFS= read -r m; do
  [ -n "$m" ] || continue
  path="$(printf '%s' "$m" | tr '.' '/').agda"
  [ -f "$path" ] || printf '%s\n' "$m" >> "$work/rot_back"
done < "$work/imported"
sort -u "$work/rot_back" -o "$work/rot_back"

# ---------------------------------------------------------------------------
# 3c. duplicate imports: harmless to Agda, but noise in a list whose whole
#     job is to be a faithful census. Reported as a WARNING, non-fatal.
# ---------------------------------------------------------------------------
uniq -d "$work/imports_all" > "$work/dups"

# ---------------------------------------------------------------------------
# 4. Report + exit.
# ---------------------------------------------------------------------------
nf=$(wc -l < "$work/rot_forward" | tr -d ' ')
nb=$(wc -l < "$work/rot_back"    | tr -d ' ')
nd=$(wc -l < "$work/dups"        | tr -d ' ')
ndisk=$(wc -l < "$work/on_disk"  | tr -d ' ')
nimp=$(wc -l < "$work/imported"  | tr -d ' ')

echo "== Everything.agda coverage latch =="
echo "   modules on disk (top-level + Swarm, excl. Everything): $ndisk"
echo "   distinct import lines in Everything.agda             : $nimp"
echo

if [ "$nd" -gt 0 ]; then
  echo "WARNING: duplicate import line(s) in $EVERYTHING (non-fatal):"
  sed 's/^/   - /' "$work/dups"
  echo
fi

status=0

if [ "$nf" -gt 0 ]; then
  echo "ROT-FORWARD ($nf): on disk but NO import line names them (orphans):"
  sed 's/^/   + /' "$work/rot_forward"
  echo
  status=1
fi

if [ "$nb" -gt 0 ]; then
  echo "ROT-BACK ($nb): imported but the module file is ABSENT (dangling):"
  sed 's/^/   - /' "$work/rot_back"
  echo
  status=1
fi

if [ "$status" -eq 0 ]; then
  echo "OK: import list and directory coincide exactly. Coverage latched."
else
  echo "FAIL: Everything.agda does not cover the directory exactly (see above)."
  echo "      Fix by editing Everything.agda's import list, then re-run."
fi

exit "$status"
