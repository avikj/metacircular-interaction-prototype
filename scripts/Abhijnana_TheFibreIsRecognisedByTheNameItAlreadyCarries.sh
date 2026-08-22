#!/bin/sh
# अभिज्ञान — recognition; the token by which a thing already known is known again.
#
# ─────────────────────────────────────────────────────────────────────────
# WHY THIS IS A STAGE OF THE LOOP AND NOT A REPORT.
#
# रात्रिः asks two questions.  नयः १ (निर्धारण): does this record field ride
# free?  नयः २ (अनुलोम-प्रतिलोम): does this round trip come back?  Both are
# CONSTRUCTIVE questions — they propose a thing and ask the kernel to build
# it — and across a whole night नयः २ closed ZERO new edges.
#
# On 2026-08-22 three edges were priced in ten minutes by asking a different
# question: **does this fibre already have a name in this corpus?**
# `PingalaPrastara.matraOf` sat in the UNDECIDED queue while
# `Metre n = Σ[ p ∈ Pattern ] (matraOf p ≡ n)` was defined FIFTEEN LINES
# BELOW IT in the same file, and the file's own comment at line 55 said in
# prose that Metre, Vak and Chosen are its fibres.  No term said it, so the
# census could not see it, so it reported the corpus barren at exactly the
# place the corpus had already answered.
#
# That is this repository's oldest failure mode — **an instrument that
# cannot see reports that nothing is there** — and it is the same act that
# let a European name stand over an Indian result for four centuries.  The
# repair is not a better prover.  It is to LOOK UP the answer before
# proposing to construct one.
#
# So: this stage is a RECOGNITION, not a construction.  `fiber f b` unfolds
# to `Σ[ a ] (f a ≡ b)`.  A definition of that exact shape IS a fibre.  The
# probe is `refl` or it is nothing.
#
# TERM.  अभिज्ञान — recognition, and specifically the TOKEN by which someone
# already known is known again; Kālidāsa's अभिज्ञानशाकुन्तलम् is named for the
# ring.  Nyāya uses प्रत्यभिज्ञा for recognitive perception (this is not that
# module: `NaturalMachine/Pratyabhijna_…` is the network law).  LIMIT: the
# term is used in its plain sense of recognising by a carried token; no text
# states anything below and no logician is credited with it.
#
#   run:  sh scripts/Abhijnana_…sh [--check]
#         --check puts each recognition to the kernel and reports greens.
# ─────────────────────────────────────────────────────────────────────────

cd "$(dirname "$0")/.." || exit 1
CHECK=0; for a in "$@"; do [ "$a" = "--check" ] && CHECK=1; done
W="${ABHIJNANA_SCRATCH:-.abhijnana}"; mkdir -p "$W"

# ── १ · the queue: every one-way edge the census could not decide ──────
runghc machine/Lopa_TheIrreversibleEdgesAreTheOtherGraphAndTheyRunOneWay.hs . --queue \
  2>/dev/null | sed -n '/THE UNDECIDED QUEUE/,$p' | sed -n '2,$p' \
  | grep "$(printf '\t')" > "$W/queue.tsv"

# ── २ · the shelf: every fibre already written out, anywhere ───────────
#
# A fibre written out is a Σ whose body ends in an equation into the index.
# NO ALPHABET IS NAMED here: two closure gates in this repo matched module
# names with [A-Za-z0-9_'.-] and reported 17 Devanagari-named modules as
# orphans — the gate cried orphan at exactly the files whose names were not
# English.  A token is what is not whitespace.
grep -rnE '^[^ #{/-][^ ]* [^ ]* *= *Σ\[' --include='*.agda' \
     formal/cubical punaragamana/src 2>/dev/null | grep '≡' \
 | sed -E 's|^([^:]*):[0-9]*:([^ ]*) .*Σ\[ *[^ ]* *∈ *([^]]*)\].*|\3\t\2\t\1|' \
 | awk -F'	' '{for(i=1;i<=NF;i++) gsub(/^[ 	]+|[ 	]+$/,"",$i);
                 body=$4; sub(/≡.*$/,"",body);
                 n=split(body,w,/[ ()]+/); m="";
                 for(j=n;j>=1;j--) if(w[j]!=""){ if(m=="") m=w[j]; }
                 for(j=1;j<=n;j++) if(w[j]!="" && w[j] !~ /^[a-z]$/) m=w[j];
                 print $1"	"m"	"$2"	"$3}' | sort -u > "$W/shelf.tsv"

# ── ३ · the join.  A MATCH IS A LEAD, NOT A VERDICT. ──────────────────
#
# The first lead ever checked FAILED: `MatraVarnaGuru.लघु-सङ्ख्या` counts
# laghus while `matraOf` sums morae — same types, different maps.  Only the
# kernel decides.  A stage that reported leads as hits would be the दुर्नय
# this whole apparatus exists against, and three instruments were retracted
# in one night for exactly that.
awk -F'\t' '{gsub(/^.*\./,"",$1); print $1"\t"$2"\t"$3}' "$W/queue.tsv" \
  | sort -u -k1,1 -t"$(printf '\t')" > "$W/qkey.tsv"
join -t"$(printf '\t')" -1 1 -2 1 "$W/qkey.tsv" "$W/shelf.tsv" 2>/dev/null \
  > "$W/leads.tsv"

NQ=$(wc -l < "$W/queue.tsv" | tr -d ' ')
NS=$(wc -l < "$W/shelf.tsv" | tr -d ' ')
NL=$(wc -l < "$W/leads.tsv" | tr -d ' ')

printf '\n  अभिज्ञान — does this fibre already have a name here?\n'
printf '  ──────────────────────────────────────────────────────────\n'
printf '  undecided edges on road two   : %s\n' "$NQ"
printf '  fibres already written out    : %s\n' "$NS"
printf '  LEADS (source type matches)   : %s\n\n' "$NL"

[ "$NL" -eq 0 ] && { printf '  No leads.  If that is a zero from a fresh edit, CHECK THE\n'
                     printf '  INSTRUMENT before believing it: this join returned 0 on its\n'
                     printf '  first run and the zero was a trailing space inside a field.\n\n'
                     exit 0; }

sed 's/^/  LEAD  /' "$W/leads.tsv"
printf '\n  Each is a LEAD.  Only the kernel says whether the map whose fibre\n'
printf '  was written is the map in the queue.  Run with --check.\n\n'
exit 0
