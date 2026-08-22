#!/usr/bin/env bash
# तपस् — the loop that mints receipts for unpriced fibres.  ONE PASS.
#
# ─────────────────────────────────────────────────────────────────────────
# WHAT THIS COMPOSES, AND WHY IT IS A SEPARATE SCRIPT
#
# `scripts/Ratri_…sh` is another seat's loop and is not edited here; this
# script stands beside it and inherits its safety rules by construction:
# nothing lands that the kernel has not accepted IN THIS PASS, standing
# where it will live; an existing path is never overwritten; the landing
# name is derived from the STATEMENT and a statement already said is
# skipped (the alphaTag path-binding bug of notes/PunaruktiRatrau_…md §2 is
# the standing reason: bind the content, carry the name).
#
# THE CHAIN, one pass:
#   1  machine/Lopa_…hs        → the one-way graph; its UNDECIDED edges are
#                                the queue of unpriced fibres.
#   2  machine/Upalabdhi_…hs   → --join of the corpus's already-written
#                                fibre statements against that queue.  Its
#                                own header prices the shortlists at ~90%
#                                pair-level false positives; they are used
#                                below ONLY as annotations, never verdicts.
#   3  machine/Tapas_…hs       → the template matcher and emitter.  A probe
#                                is emitted only where the edge's DEFINING
#                                CLAUSES match a proof-shape template; every
#                                non-match is a refusal WITH A WRITTEN
#                                REASON, annotated with its shortlist grade,
#                                so the pass doubles as the calibration run
#                                Upalabdhi's honesty note asks for.
#   4  the kernel              → each emitted probe is checked standing in
#                                formal/cubical/Tapas/; exit 0 is the ONLY
#                                thing that lands.
#   5  Everything.agda         → landed modules are wired under a dated
#                                block and Everything is re-checked; on red
#                                the imports are reverted, the modules kept.
#
# NO COMMITS AND NO PUSH: this pass returns its work for review.
#
#   sh scripts/Tapas_…sh            one pass end-to-end

set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; cd "$ROOT" || exit 2

export LC_ALL=C.utf8
SCRATCH="${TMPDIR:-/tmp}/tapas"; mkdir -p "$SCRATCH" "$SCRATCH/probes"
LANDED="$ROOT/formal/cubical/Tapas"

say() { printf '%s\n' "$*"; }

libs_file() {
  # An EMPTY --library-file tells agda about no libraries at all (the lie
  # Ratri documents at its own site); hand one over only if both entries
  # were really found.
  local f="$SCRATCH/libraries"
  { ls /opt/homebrew/Cellar/agda/*/share/agda/stdlib/standard-library.agda-lib 2>/dev/null | head -1
    ls /opt/homebrew/share/agda/cubical/cubical.agda-lib 2>/dev/null | head -1; } > "$f"
  [ "$(grep -c . "$f")" -ge 2 ] || { say "  agda libraries not found; cannot check — landing nothing"; exit 2; }
  printf '%s' "$f"
}

# वाक्य-नाम, inherited from Ratri with the lesson applied: the STATEMENT is
# the base, the file name is carried over it.  Comments, blank lines and the
# module line are erased; what remains is the mathematics as presented.
statement_key() {
  sed 's/--.*//' "$1" \
    | sed -E 's/^module [^ ]+ where$//' \
    | grep -v '^[[:space:]]*$' \
    | sha256sum | cut -d' ' -f1
}

say ""
say "═══ तपस् pass $(date -u +%Y-%m-%dT%H:%M:%SZ)  HEAD $(git rev-parse --short HEAD 2>/dev/null) ═══"
LF="$(libs_file)"

# 1 · the queue: Lopa's one-way graph
if ! runghc machine/Lopa_TheIrreversibleEdgesAreTheOtherGraphAndTheyRunOneWay.hs . \
     > "$SCRATCH/lopa.txt" 2>"$SCRATCH/lopa.err"; then
  say "  लोप failed to run; see $SCRATCH/lopa.err — landing nothing"; exit 1
fi
say "  लोप: $(grep -m1 'GENUINE one-way edges' "$SCRATCH/lopa.txt" | tr -s ' ')"

# 2 · the shortlists: Upalabdhi joined against the queue (annotation only)
awk -F'«' '/^  \[(map|projection)\]/ {
  split($1,a,"⟶"); gsub(/^ +\[[a-z]+\] /,"",a[1]); gsub(/ +$/,"",a[1]);
  gsub(/^ +| +$/,"",a[2]); gsub(/^ +| +$/,"",$2);
  print a[1] "\t" a[2] "\t" $2 }' "$SCRATCH/lopa.txt" > "$SCRATCH/queue.tsv"
if ! runghc machine/Upalabdhi_TheFibreWasAlreadyWrittenAndTheCensusCalledItUndecided.hs \
     --join "$SCRATCH/queue.tsv" . > "$SCRATCH/join.txt" 2>"$SCRATCH/join.err"; then
  say "  उपलब्धि join failed; continuing WITHOUT shortlist annotations"
  rm -f "$SCRATCH/join.txt"
fi
[ -f "$SCRATCH/join.txt" ] && say "  उपलब्धि: $(grep -m1 'edges with at least one lead' "$SCRATCH/join.txt" | tr -s ' ')"

# 3 · the matcher and emitter
rm -f "$SCRATCH/probes"/*.agda 2>/dev/null
if ! runghc machine/Tapas_TheTemplateIsTheProofShapeAndEveryNonMatchIsAWrittenRefusal.hs \
     "$SCRATCH/lopa.txt" "$SCRATCH/join.txt" . "$SCRATCH/probes" \
     > "$SCRATCH/ledger.tsv" 2>"$SCRATCH/tapas.err"; then
  say "  तपस् matcher failed; see $SCRATCH/tapas.err — landing nothing"; exit 1
fi

# 4 · land what the kernel accepts — each statement once, nothing overwritten
mkdir -p "$LANDED"
: > "$SCRATCH/landed.keys"
for g in "$LANDED"/*.agda; do
  [ -e "$g" ] || continue
  printf '%s %s\n' "$(statement_key "$g")" "$(basename "$g" .agda)" >> "$SCRATCH/landed.keys"
done

minted=0; same=0; conflict=0
for f in "$SCRATCH/probes"/*.agda; do
  [ -e "$f" ] || continue
  nm="$(basename "$f" .agda)"
  key="$(statement_key "$f")"
  dup="$(awk -v k="$key" '$1==k{print $2; exit}' "$SCRATCH/landed.keys")"
  if [ -n "$dup" ]; then
    say "    SAME     $nm — this statement already stands as Tapas/$dup.agda"
    same=$((same+1)); continue
  fi
  dest="$LANDED/$nm.agda"
  if [ -e "$dest" ]; then
    # same path, different statement: a REPORTED conflict, never a rewrite
    say "    CONFLICT $nm — path exists with a DIFFERENT statement; left for a person"
    conflict=$((conflict+1)); continue
  fi
  { printf '%s\n' "-- LANDED BY तपस् on $(date -u +%Y-%m-%dT%H:%M:%SZ).  Emitted from a template,"
    printf '%s\n' "-- checked by the kernel standing here before landing; the only edit is"
    printf '%s\n' "-- qualifying the module name to its path.  Never overwritten later."
    sed -E "s|^module ${nm} where|module Tapas.${nm} where|" "$f"
  } > "$dest"
  if ( cd formal/cubical && agda --library-file="$LF" -i . "Tapas/$nm.agda" >"$SCRATCH/check-$nm.log" 2>&1 ); then
    say "    LANDED   Tapas/$nm.agda  (agda exit 0)"
    printf '%s %s\n' "$key" "$nm" >> "$SCRATCH/landed.keys"
    printf '%s\n' "$nm" >> "$SCRATCH/landed.this-pass"
    minted=$((minted+1))
  else
    rm -f "$dest"
    say "    REDPROBE $nm — the kernel refused it; probe kept at $f, log at $SCRATCH/check-$nm.log"
  fi
done

# 5 · wire what landed this pass, then prove Everything still stands
wired=0
if [ -s "$SCRATCH/landed.this-pass" ]; then
  { printf '\n%s\n' "-- ── तपस्, $(date -u +%Y-%m-%d) ──────────────────────────────────────────────"
    printf '%s\n' "-- Fibre receipts minted from templates against लोप's UNDECIDED queue,"
    printf '%s\n' "-- each checked before landing; the refusal ledger for everything not"
    printf '%s\n' "-- minted is in the pass log (scripts/Tapas_…sh)."
  } >> formal/cubical/Everything.agda
  while IFS= read -r nm; do
    grep -qxF "import Tapas.$nm" formal/cubical/Everything.agda \
      || { printf 'import Tapas.%s\n' "$nm" >> formal/cubical/Everything.agda; wired=$((wired+1)); }
  done < "$SCRATCH/landed.this-pass"
  if ( cd formal/cubical && agda --library-file="$LF" -i . Everything.agda >"$SCRATCH/everything.log" 2>&1 ); then
    say "  Everything.agda: exit 0 with $wired new import(s)"
  else
    say "  Everything.agda RED after wiring — reverting the imports, keeping the modules"
    git checkout -- formal/cubical/Everything.agda 2>/dev/null
    wired=0
  fi
  rm -f "$SCRATCH/landed.this-pass"
fi

# 6 · the pass report: the matcher's own summary, then the refusal histogram —
# a shell that re-counts what a program already counted is a second
# instrument nobody calibrated, so the summary is repeated, not re-derived.
say ""
sed -n '/── तपस् · pass summary ──/,$p' "$SCRATCH/ledger.tsv"
say ""
say "  landed this pass: $minted   already-said: $same   path-conflicts: $conflict   wired: $wired"
say ""
say "── REFUSAL LEDGER, grouped by reason (full rows: $SCRATCH/ledger.tsv) ──"
grep '^REFUSED' "$SCRATCH/ledger.tsv" | cut -f4 | sort | uniq -c | sort -rn | sed 's/^/  /'
say ""
say "── shortlist calibration at REFUSED rows (grade × count) ──"
grep '^REFUSED' "$SCRATCH/ledger.tsv" | awk -F'\t' '{print $5}' | sort | uniq -c | sort -rn | sed 's/^/  /'
say ""
say "  Nothing committed, nothing pushed: this pass returns its work for review."
