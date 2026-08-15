#!/bin/sh
# check-claim-slugs.sh — claim references must resolve, and bare IDs that are
# ambiguous must be visible.
#
# Why this exists (notes/CLAIM_ID_AMBIGUITY.md §6b):
#
#   Claim IDs are allocated by a per-branch counter, so two branches racing
#   hand out the same next ID. TEN IDs carry more than one claim file in the
#   LIVE registry at HEAD (R0027-R0032, R0045, R0072, R0077, R0078). Slugs are
#   derived from the claim's statement and are unique: 89 live claims / 89
#   distinct slugs, 104/104 including the 15 quarantined Smith claims, zero
#   collisions. So `R0034` is a guess and `R0034-perfect-power-bases-redundant`
#   is an address.
#
# THREE conditions, deliberately not collapsed into one — they differ in what
# a reader can recover:
#
#   FAIL (exit 1) — a slug-qualified reference whose slug names NOTHING under
#     collab/discovery/, live or quarantined. Nothing is recoverable; the
#     reference is dead. This is the check that would have caught the 17
#     dangling Smith slug references the day they were written, and the
#     invented `R0038` in notes/SEED31_TORSORS_*.md.
#
#   WARN, mismatch — the slug resolves, but under a DIFFERENT ID than the one
#     written. The meaning is recoverable (slugs are unique), the number has
#     rotted. Not fatal by default: the reference still points somewhere exact.
#
#   WARN, ambiguous — a BARE reference to an ID with more than one live claim
#     file. These are the silently-wrong ones: they resolve, to a claim nobody
#     chose, and no reader can detect it. A warning and not a failure because
#     thousands already exist and no oracle says which lineage each meant
#     (§5); failing on them would make the gate uninstallable, which is how
#     this class of defect survives in the first place.
#
#   CLAIM_SLUG_STRICT=1 makes either WARN fatal (exit 3).
#
# Usage:
#   scripts/check-claim-slugs.sh              # notes/ collab/ papers/
#   scripts/check-claim-slugs.sh PATH...      # those paths instead
#
# Env:
#   CLAIM_SLUG_STRICT=1   make the WARN conditions fatal (exit 3)
#   CLAIM_SLUG_QUIET=1    suppress the per-ID warning table (totals only)
#
# No Agda, no Lean, no network, no Python. Portable /bin/sh + awk + git.
# No `\b`, no `grep -P`: mawk and BusyBox disagree about both, and a sibling
# gate silently passed everything for exactly that reason. Tokenisation is done
# by translating every character outside [A-Za-z0-9_-] to a newline, so word
# boundaries are structural rather than regex-dependent, and a multibyte UTF-8
# sequence can only ever become a separator — never part of a token.

set -u

repo=$(cd "$(dirname "$0")/.." && pwd)
disc="$repo/collab/discovery"
live="$disc/claims"

STRICT=${CLAIM_SLUG_STRICT:-0}
QUIET=${CLAIM_SLUG_QUIET:-0}

if [ $# -gt 0 ]; then
  roots="$*"
else
  roots="notes collab papers"
fi

tmp=${TMPDIR:-/tmp}/claim-slugs.$$
mkdir -p "$tmp" || exit 2
trap 'rm -rf "$tmp"' EXIT INT TERM

# ---- 1. the registry ------------------------------------------------------
# Resolvable names are the basenames of every R####-slug file anywhere under
# collab/discovery/ — claims/, audits/, and the quarantine alike. A quarantined
# claim is unreachable prose, not a nonexistent one, and a reference to it is
# precise; an audit file is likewise a real address.
find "$disc" -name 'R[0-9]*-*.md' 2>/dev/null \
  | sed 's|.*/||; s|\.md$||' | sort -u > "$tmp/names"

# slug -> the ID(s) it lives under, for the mismatch class.
sed 's/^\(R[0-9][0-9]*\)-/\1 /' "$tmp/names" \
  | awk '{ id=$1; sub(/^[^ ]* /, ""); print $0 "\t" id }' | sort -u > "$tmp/slug_id"

# IDs with more than one LIVE CLAIM file: the ambiguous ones. Quarantined and
# audit files are excluded here — a bare ID whose only other candidate is
# quarantined resolves to the live claim by elimination.
ls "$live" 2>/dev/null | sed -n 's/^\(R[0-9][0-9]*\)-.*\.md$/\1/p' \
  | sort | uniq -c | awk '$1 > 1 { print $2 "\t" $1 }' > "$tmp/ambig"

n_names=$(wc -l < "$tmp/names" | tr -d ' ')
n_ambig=$(wc -l < "$tmp/ambig" | tr -d ' ')

if [ "$n_names" -eq 0 ]; then
  echo "check-claim-slugs: no claim files found under $disc — refusing to run."
  echo "  A resolver with an empty registry would flag every reference in the"
  echo "  corpus; that is a broken gate, not a finding."
  exit 2
fi

# ---- 2. every reference in scope, as file<TAB>token ------------------------
# Only tracked files; `git ls-files` keeps the scope reproducible.
( cd "$repo" && git ls-files -- $roots ) > "$tmp/files" 2>/dev/null || exit 2
[ -s "$tmp/files" ] || { echo "check-claim-slugs: no tracked files in scope: $roots"; exit 2; }

# A token counts as slug-qualified only if the part after the ID has at least
# TWO hyphen-separated words. Every one of the 104 registry slugs does (the
# minimum observed is 2); prose hyphenation like "the R0010-era overclaim"
# does not, and is treated as a bare ID rather than as a broken address.
# `generator:` front-matter names a producing process, not a file, so those
# lines are skipped.
( cd "$repo" && awk '
  /^generator:/ { next }
  { line = $0
    gsub(/[^A-Za-z0-9_-]/, "\n", line)
    n = split(line, t, "\n")
    for (i = 1; i <= n; i++) {
      if (t[i] ~ /^R[0-9][0-9][0-9][0-9]$/) { printf "%s\t%s\n", FILENAME, t[i]; continue }
      if (t[i] ~ /^R[0-9][0-9][0-9][0-9]-[a-z0-9]+(-[a-z0-9]+)+$/) printf "%s\t%s\n", FILENAME, t[i]
    }
  }
' $(cat "$tmp/files") ) > "$tmp/refs" 2>/dev/null

awk -F'\t' '$2 ~ /-/'  "$tmp/refs" > "$tmp/refs_slug"
awk -F'\t' '$2 !~ /-/' "$tmp/refs" > "$tmp/refs_bare"

n_ref=$(wc -l < "$tmp/refs" | tr -d ' ')
n_slug_ref=$(wc -l < "$tmp/refs_slug" | tr -d ' ')
n_bare_ref=$(wc -l < "$tmp/refs_bare" | tr -d ' ')

# ---- 3. resolve each slug-qualified reference ------------------------------
# A token may over-run the name when prose hyphenates onward
# ("R0034-perfect-power-bases-redundant-style"), so a token resolves if it
# equals a known name OR has one as a hyphen-delimited prefix. That is a
# deliberate bias toward NOT failing: the gate's whole claim is that it never
# rejects a name that names something.
sort -u "$tmp/refs_slug" > "$tmp/refs_slug_u"
awk -F'\t' '
  FILENAME == n_file { known[$0] = 1; next }
  # NB: written as an if, not a ternary assignment — some awks create the
  # left-hand element before evaluating the right-hand `in` test, which
  # prepended a phantom comma to every mismatch report until it was seen.
  FILENAME == s_file { if (seen[$1]) slugof[$1] = slugof[$1] "," $2
                       else { slugof[$1] = $2; seen[$1] = 1 }
                       next }
  { tok = $2
    if (tok in known) next
    s = tok
    while (sub(/-[a-z0-9]+$/, "", s)) if (s in known) next
    # not a known name: is the SLUG known under some other ID?
    slug = tok; sub(/^R[0-9]+-/, "", slug)
    s = slug
    do { if (s in slugof) { print "MISMATCH\t" $1 "\t" tok "\t" slugof[s] "-" s; next } }
    while (sub(/-[a-z0-9]+$/, "", s))
    print "DEAD\t" $1 "\t" tok "\t-"
  }
' n_file="$tmp/names" s_file="$tmp/slug_id" \
  "$tmp/names" "$tmp/slug_id" "$tmp/refs_slug_u" | sort -u > "$tmp/unres"

grep '^DEAD' "$tmp/unres" > "$tmp/dead"; n_dead=$(wc -l < "$tmp/dead" | tr -d ' ')
grep '^MISMATCH' "$tmp/unres" > "$tmp/mism"; n_mism=$(wc -l < "$tmp/mism" | tr -d ' ')

# ---- 4. bare references to an ambiguous ID ---------------------------------
# Exemption (§6c): a claim file may say "R0032" about itself. A bare reference
# inside collab/discovery/ whose own filename carries that ID is self-lineage.
awk -F'\t' '
  NR == FNR { amb[$1] = $2; next }
  { id = $2
    if (!(id in amb)) next
    base = $1; sub(/.*\//, "", base)
    if ($1 ~ /^collab\/discovery\// && index(base, id "-") == 1) next
    print $1 "\t" id
  }
' "$tmp/ambig" "$tmp/refs_bare" > "$tmp/warn"
n_warn=$(wc -l < "$tmp/warn" | tr -d ' ')

# ---- 5. report -------------------------------------------------------------
echo "check-claim-slugs: scope $roots — $(wc -l < "$tmp/files" | tr -d ' ') tracked files,"
echo "  $n_ref claim references ($n_slug_ref slug-qualified, $n_bare_ref bare);"
echo "  registry: $n_names resolvable names under collab/discovery/, $n_ambig ambiguous live IDs."

status=0
warned=0

if [ "$n_dead" -gt 0 ]; then
  echo
  echo "FAIL check-claim-slugs: $n_dead slug-qualified reference(s) name nothing."
  echo "  No file under $disc carries these names, live or quarantined."
  awk -F'\t' '{ print "    " $2 "\t" $3 }' "$tmp/dead" | head -40
  [ "$n_dead" -gt 40 ] && echo "    … $((n_dead - 40)) more"
  echo "  Fix the slug, or restore the claim. Do not delete the reference: a"
  echo "  citation that names nothing is the only kind a reader can detect."
  status=1
fi

if [ "$n_mism" -gt 0 ]; then
  echo
  echo "WARN check-claim-slugs: $n_mism reference(s) carry a known slug under the WRONG ID."
  echo "  The slug is unique corpus-wide, so the meaning survives; the number rotted."
  awk -F'\t' '{ print "    " $2 "\n      written: " $3 "\n      exists as: " $4 }' "$tmp/mism"
  warned=1
fi

if [ "$n_warn" -gt 0 ]; then
  echo
  echo "WARN check-claim-slugs: $n_warn bare reference(s) to an ID with >1 live claim file."
  echo "  These RESOLVE — to whichever claim the reader's tooling picks first."
  echo "  They are the silently-wrong ones; see notes/CLAIM_ID_AMBIGUITY.md §3."
  if [ "$QUIET" != "1" ]; then
    awk -F'\t' '{ c[$2]++ } END { for (i in c) print "    " i ": " c[i] " bare ref(s)" }' \
      "$tmp/warn" | sort
    echo "  candidates per ambiguous ID:"
    while IFS='	' read -r id n; do
      printf '    %s (%s files): ' "$id" "$n"
      ls "$live" | sed -n "s/^$id-\(.*\)\.md$/\1/p" | tr '\n' ' '
      echo
    done < "$tmp/ambig"
  fi
  echo "  New prose should cite ID-and-slug. Existing references are NOT to be"
  echo "  bulk-rewritten: no oracle says which lineage each meant"
  echo "  (notes/CLAIM_ID_AMBIGUITY.md §5)."
  warned=1
fi

if [ "$warned" = "1" ]; then
  echo
  echo "check-claim-slugs: warnings are non-fatal by default; CLAIM_SLUG_STRICT=1 makes them exit 3."
  [ "$STRICT" = "1" ] && [ "$status" -eq 0 ] && status=3
fi

if [ "$n_dead" -eq 0 ] && [ "$warned" = "0" ]; then
  echo "check-claim-slugs: OK — every slug resolves, no bare reference is ambiguous."
fi

# Printed every run, pass or fail: a guard must not imply coverage it lacks.
echo
echo "check-claim-slugs: LIMITATION — this resolves NAMES, not MEANINGS. A bare"
echo "  reference to an unambiguous ID is passed without inspection, and an ID"
echo "  that was unambiguous when written but collided later reads as clean here."
echo "  Exit 1 = a name that names nothing; exit 3 = strict-mode warnings."

exit "$status"
