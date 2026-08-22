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
# ─────────────────────────────────────────────────────────────────────────
# THE JOIN, AND WHY IT WAS SHARPENED (2026-08-22).
#
# The first version keyed on SOURCE TYPE ALONE and printed 28 leads.  Two
# defects, both found by reading its own intermediate files:
#
#   (a) the map name inside the Σ body was never extracted at all — the sed
#       captured three fields and the awk read a fourth that did not exist,
#       so the map column was EMPTY in all 49 rows and the join could not
#       have used it;
#   (b) `sort -u -k1,1` on the queue collapsed 1046 edges to 249 — ONE
#       SURVIVOR PER SOURCE TYPE — which is why every ℕ-sourced lead named
#       `IntegerHullMultiplicity.hull`.  That map was not a candidate; it
#       was the alphabetically first row of a bucket the rest of which had
#       been thrown away.  The instrument was reporting its own `sort`.
#
# Both are repaired.  The key is now (source type, MAP NAME), where the map
# name is the head of the application immediately left of the `≡` inside the
# Σ body: `Fib n = Σ[ w ∈ Word ] (value w ≡ n)` yields source `Word`, map
# `value`, and the queue carries `Word ⟶ ℕ « Swarm.S03CarryFiber.value`.
# Both halves match.  Names are compared on their LAST segment, so a map
# reached under a different module qualification still joins — and so two
# unrelated `charge`s in two modules also join, which is precisely why the
# kernel and not the join issues the verdict.
#
# A source-only match is still printed, as a WEAK lead, because that is what
# it is.  The first lead ever checked FAILED — `MatraVarnaGuru.लघु-सङ्ख्या`
# counts laghus while `matraOf` sums morae, same types, different maps — and
# a stage that reported leads as hits would be the दुर्नय this whole
# apparatus exists against.
#
# NO ALPHABET IS NAMED IN ANY MATCHER HERE.  Two closure gates in this repo
# matched module names with `[A-Za-z0-9_'.-]` and reported 17
# Devanagari-named modules as orphans — the gate cried orphan at exactly the
# files whose names were not English.  A token is what is not whitespace.
# (This is also why the extraction is `perl -CSDA -Mutf8` and not `awk`: the
# BSD awk on this machine dies with `towc: multibyte conversion failure` on
# a Devanagari identifier, and `LC_ALL=C` would have made every ≡ and ∈ a
# byte string — working, but by accident.)
#
# `timeout` DOES NOT EXIST ON THIS MACHINE.  `command -v timeout` finds
# nothing and the shell returns 127, which is a MISSING BINARY and not a
# verdict; 39 false refutations were published here from that confusion and
# had to be retracted.  agda is therefore invoked directly, and its exit
# code is reported as it stands.
#
#   run:  sh scripts/Abhijnana_…sh [--check] [--all]
#         --check  puts each strong lead to the kernel and reports greens.
#         --all    also puts the weak (source-type-only) leads to it.
# ─────────────────────────────────────────────────────────────────────────

cd "$(dirname "$0")/.." || exit 1
CHECK=0; ALL=0
for a in "$@"; do
  [ "$a" = "--check" ] && CHECK=1
  [ "$a" = "--all" ] && ALL=1
done
W="${ABHIJNANA_SCRATCH:-.abhijnana}"; mkdir -p "$W"
TAB=$(printf '\t')

# ── १ · the queue: every one-way edge the census could not decide ──────
runghc machine/Lopa_TheIrreversibleEdgesAreTheOtherGraphAndTheyRunOneWay.hs . --queue \
  2>/dev/null | sed -n '/THE UNDECIDED QUEUE/,$p' | sed -n '2,$p' \
  | grep "$TAB" > "$W/queue.tsv"

# ── २ · the shelf: every fibre already written out, anywhere ───────────
#
# A fibre written out is a Σ whose body ends in an equation into the index.
# Emitted per Σ binder, so a nested `Σ[ x ∈ A ] Σ[ y ∈ B ] (… ≡ …)` offers
# both A and B as source candidates rather than silently picking one.
#
# columns: srcBase  mapBase  srcRaw  mapRaw  def  nParams  idxRHS  file  line
# The detector is `machine/Upalabdhi_…hs`, NOT the one-line grep this script
# shipped with.  That grep matched a single shape at column zero and found 47.
# Upalabdhi reads seven shapes -- sigma-eq, fiber-alias, record-eq, sigma-neq
# (the fibre of a SEPARATION, counted apart), data-eq, subtype-eq,
# sigma-bare-eq -- across all three lanes, and finds 475.  It also found
# `NaturalMachine/PairsSummingTo.agda`, which holds ADDITION'S OWN FIBRE and
# which the grep missed.
#
# Its columns: source ⟶ index ⟶ module.name ⟶ shape ⟶ map ⟶ file:line.
#
# ONE THING UPALABDHI DOES NOT GIVE, and it is the thing the join turns on:
# **its `map` column is `?` in 336 of its 475 rows**, including
# `Swarm.S03CarryFiber.Fib` and `PingalaPrastara.Metre` — the two rows that
# started this whole stage.  Keying on (source, map) against that column
# would have joined on a question mark 71% of the time.  So the map is
# recovered HERE, by reading back the very line Upalabdhi cites and taking
# the head of the application immediately left of the `≡`:
#
#     Fib n = Σ[ w ∈ Word ] (value w ≡ n)   ⟶  src Word, map value, np 1
#
# and the queue carries `Word ⟶ ℕ « Swarm.S03CarryFiber.value`.  Both
# halves match.  Breadth is Upalabdhi's; the map name is this script's; and
# neither of them issues a verdict — §५ does, with the kernel.
#
# columns: srcBase mapBase srcRaw mapRaw def nParams idxRHS file line shape
runghc machine/Upalabdhi_TheFibreWasAlreadyWrittenAndTheCensusCalledItUndecided.hs \
  2>/dev/null \
 | perl -CSDA -Mutf8 -F'\t' -lane '
  next unless @F>=6;
  for (@F){ s/^\s+|\s+$//g }
  my ($src,$uidx,$qual,$shape,$umap,$loc)=@F[0,1,2,3,4,5];
  next if $src eq "" or $src eq "?";
  my ($file,$ln) = $loc =~ /^(.*):(\d+)$/ ? ($1,$2) : ($loc,0);
  my $def=$qual; $def =~ s/^.*\.//;
  # read back the cited line; it is the only place the map name is written
  my $srcline="";
  if (open(my $H,"<:utf8",$file)) { my $i=0;
     while(my $l=<$H>){ $i++; if($i==$ln){ chomp $l; $srcline=$l; last } } close $H; }
  my ($map,$np,$idx) = ("?",-1,$uidx);
  if ($srcline ne ""){
    if ($srcline =~ /^(\S+)((?:\s+\S+)*?)\s*=\s*(.*)$/){
      my ($params,$rhs)=($2,$3);
      $params =~ s/^\s+|\s+$//g;
      $np = ($params eq "") ? 0 : scalar(my @p = split /\s+/, $params);
      if ($rhs =~ /\bfiber\s+(\S+)/){ $map=$1 }
      elsif ($rhs =~ /≡/){
        my ($lhs,$rr)=($rhs,$rhs);
        $lhs =~ s/≡.*$//s;
        $rr  =~ s/^.*?≡//s; $rr =~ s/^\s+|\s+$//g; $rr =~ s/\)\s*$//;
        $rr  =~ s/^\s+|\s+$//g; $idx=$rr if $rr ne "";
        $lhs =~ s/Σ\[[^\]]*\]/ /g;
        my @ch=split //,$lhs; my @cuts=(-1);
        for my $i (0..$#ch){ my $c=$ch[$i];
           push @cuts,$i if ($c eq "(" or $c eq ")" or $c eq "→" or $c eq "×" or $c eq "]") }
        for my $k (reverse 0..$#cuts){
           my $cut=$cuts[$k];
           my $t = ($cut>=$#ch) ? "" : join("",@ch[$cut+1..$#ch]);
           $t =~ s/[()\[\]]/ /g; $t =~ s/^\s+|\s+$//g;
           my @w = grep {length} split /\s+/, $t;
           next unless @w; next if $w[0] =~ /^[→×∈≡]$/;
           $map=$w[0]; last;
        }
      }
    }
  }
  $map=$umap if ($map eq "?" and $umap ne "?" and $umap ne "");
  my $sb=$src; $sb=~s/^.*\.//; my $mb=$map; $mb=~s/^.*\.//;
  print join("\t",$sb,$mb,$src,$map,$def,$np,$idx,$file,$ln,$shape);
 ' | sort -u > "$W/shelf.tsv"

# ── ३ · the queue key.  Every edge, not one per bucket. ────────────────
# columns: srcBase  mapBase  srcRaw  tgtRaw  site
perl -CSDA -Mutf8 -F'\t' -lane '
  next unless @F>=3; my ($src,$tgt,$site)=@F[0,1,2];
  for ($src,$tgt,$site){ s/^\s+|\s+$//g }
  my $sb=$src; $sb=~s/^.*\.//; my $mb=$site; $mb=~s/^.*\.//;
  print join("\t",$sb,$mb,$src,$tgt,$site);' "$W/queue.tsv" | sort -u > "$W/qkey.tsv"

# ── ४ · the join.  A MATCH IS A LEAD, NOT A VERDICT. ──────────────────
perl -CSDA -Mutf8 -e '
 my ($sf,$qf)=@ARGV; my (%bykey,%bysrc);
 open(my $S,"<:utf8",$sf) or die;
 while(<$S>){chomp; my @f=split/\t/;
   push @{$bykey{$f[0]."\t".$f[1]}}, \@f; push @{$bysrc{$f[0]}}, \@f; }
 open(my $Q,"<:utf8",$qf) or die;
 while(<$Q>){chomp; my @q=split/\t/;
   my $k=$q[0]."\t".$q[1];
   next if $q[1] eq "?";
   if($bykey{$k}){ for my $s (@{$bykey{$k}}){ print join("\t","STRONG",@q,@$s),"\n" } }
   elsif($bysrc{$q[0]}){ for my $s (@{$bysrc{$q[0]}}){ print join("\t","WEAK",@q,@$s),"\n" } }
 }' "$W/shelf.tsv" "$W/qkey.tsv" | sort -u > "$W/leads.tsv"

grep '^STRONG' "$W/leads.tsv" > "$W/strong.tsv"
grep '^WEAK'   "$W/leads.tsv" > "$W/weak.tsv"

NQ=$(wc -l < "$W/queue.tsv" | tr -d ' ')
NS=$(wc -l < "$W/shelf.tsv" | tr -d ' ')
NST=$(wc -l < "$W/strong.tsv" | tr -d ' ')
NWK=$(wc -l < "$W/weak.tsv" | tr -d ' ')

printf '\n  अभिज्ञान — does this fibre already have a name here?\n'
printf '  ──────────────────────────────────────────────────────────\n'
printf '  undecided edges on road two   : %s\n' "$NQ"
printf '  fibre rows already written out: %s\n' "$NS"
printf '  STRONG leads (source AND map) : %s\n' "$NST"
printf '  WEAK   leads (source only)    : %s\n\n' "$NWK"

if [ "$NST" -eq 0 ] && [ "$NWK" -eq 0 ]; then
  printf '  No leads.  If that is a zero from a fresh edit, CHECK THE\n'
  printf '  INSTRUMENT before believing it: this join returned 0 on its\n'
  printf '  first run and the zero was a trailing space inside a field.\n\n'
  exit 0
fi

# columns of a lead row:
#  1 kind  2 srcBase 3 mapBase 4 srcRaw 5 tgtRaw 6 site
#  7 sSrcBase 8 sMapBase 9 sSrcRaw 10 sMapRaw 11 def 12 nParams 13 idx
#  14 file 15 line
cut -f1,6,11,14 "$W/strong.tsv" | sed 's/^/  LEAD  /'
printf '\n'

if [ "$CHECK" -eq 0 ]; then
  printf '  Each is a LEAD.  Only the kernel says whether the map whose fibre\n'
  printf '  was written is the map in the queue.  Run with --check.\n\n'
  exit 0
fi

# ── ५ · the probe.  `fiber f b` unfolds to `Σ[ a ] (f a ≡ b)`; if the
#        written fibre IS that Σ for the queued map, `refl` typechecks.
#        Anything else is a death, and the kernel says which.
PDIR=formal/cubical/AbhijnanaProbes
rm -rf "$PDIR"; mkdir -p "$PDIR"
: > "$W/verdicts.tsv"

if [ "$ALL" -eq 1 ]; then cat "$W/strong.tsv" "$W/weak.tsv" > "$W/tocheck.tsv"
else cp "$W/strong.tsv" "$W/tocheck.tsv"; fi

N=0
while IFS="$TAB" read -r kind sb mb sraw traw site ssb smb ssraw smraw def np idx file line shape; do
  N=$((N+1))
  PN=$(printf 'P%03d' "$N")
  # the fibre's host module, read from the file itself — never guessed
  FMOD=$(grep -m1 '^module ' "$file" | sed -e 's/^module *//' -e 's/ .*$//')
  MMOD=$(printf '%s' "$site" | sed 's/\.[^.]*$//')
  MNAME=$(printf '%s' "$site" | sed 's/^.*\.//')
  case "$file" in
    punaragamana/*)
      printf '%s\t%s\t%s\t%s\t%s\n' "$kind" "$site" "$def" "SKIP" \
        "fibre lives in the punaragamana library, probe lives in natural-machine; cross-library probe not attempted" \
        >> "$W/verdicts.tsv"; continue;;
  esac
  case "$MMOD" in
    ''|*'⟨lib⟩'*)
      printf '%s\t%s\t%s\t%s\t%s\n' "$kind" "$site" "$def" "SKIP" \
        "the queued map has no host module in the census record" >> "$W/verdicts.tsv"
      continue;;
  esac
  if [ "$np" = "1" ]; then
    STMT="_ : (b : _) → fiber M.$MNAME b ≡ F.$def b
_ = λ b → refl"
  elif [ "$np" = "0" ]; then
    STMT="_ : fiber M.$MNAME ($idx) ≡ F.$def
_ = refl"
  else
    printf '%s\t%s\t%s\t%s\t%s\n' "$kind" "$site" "$def" "SKIP" \
      "the written fibre takes $np indices; a joint fibre is not `fiber f b` without Σ-reassociation (see छन्दोमुद्रा §३)" \
      >> "$W/verdicts.tsv"
    continue
  fi
  cat > "$PDIR/$PN.agda" <<EOF
{-# OPTIONS --cubical --safe --no-import-sorts #-}
module AbhijnanaProbes.$PN where
open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
-- the index of a 0-parameter fibre is a LITERAL lifted out of the source
-- line (`… ≡ true`, `… ≡ pos 0`), so the constructors have to be in scope
-- or the probe dies [NotInScope] and the death is the instrument's, not
-- the corpus's.  Two of the first thirteen died exactly that way.
open import Cubical.Data.Bool
open import Cubical.Data.Nat
open import Cubical.Data.Int
import $MMOD as M
import $FMOD as F

$STMT
EOF
  ERR=$( (cd formal/cubical && agda -i . "AbhijnanaProbes/$PN.agda") 2>&1 )
  RC=$?
  if [ "$RC" -eq 0 ]; then
    printf '%s\t%s\t%s\t%s\t%s\n' "$kind" "$site" "$def" "GREEN" "rc=0" >> "$W/verdicts.tsv"
  else
    MSG=$(printf '%s' "$ERR" | grep -v '^ *$' | head -3 | tr '\n' ' ' | cut -c1-220)
    printf '%s\t%s\t%s\t%s\t%s\n' "$kind" "$site" "$def" "DEATH" "rc=$RC :: $MSG" >> "$W/verdicts.tsv"
  fi
done < "$W/tocheck.tsv"

NG=$(grep -c "${TAB}GREEN${TAB}" "$W/verdicts.tsv" 2>/dev/null | tr -d ' ')
ND=$(grep -c "${TAB}DEATH${TAB}" "$W/verdicts.tsv" 2>/dev/null | tr -d ' ')
NK=$(grep -c "${TAB}SKIP${TAB}"  "$W/verdicts.tsv" 2>/dev/null | tr -d ' ')
NC=$(wc -l < "$W/verdicts.tsv" | tr -d ' ')

printf '  ── kernel verdicts ────────────────────────────────────────\n'
sed 's/^/  /' "$W/verdicts.tsv"
printf '\n  probed %s · GREEN %s · DEATH %s · SKIP %s\n' "$NC" "$NG" "$ND" "$NK"
if [ "$NC" -gt "$NK" ]; then
  printf '  false-positive rate among probed leads: %s of %s\n' "$ND" "$((NC-NK))"
fi
printf '\n  A GREEN is a definitional identity the corpus already carried.\n'
printf '  A DEATH is a lead the join could not tell apart from a hit, and\n'
printf '  that number is the one that decides whether this runs on all 249\n'
printf '  source types.  Probes are left in %s for reading.\n\n' "$PDIR"
exit 0
