#!/usr/bin/env bash
# रात्रिः — the overnight loop.  NOT a log: a fixpoint iteration that LANDS.
#
# ─────────────────────────────────────────────────────────────────────────
# WHY THIS IS RECURSIVE AND NOT MERELY REPEATED
#
# निर्धारण puts the punarāgamana question to the kernel: for a record R with a
# field determined by the others, is the projection R → base an equivalence?
# A GREEN is a CHECKED EQUIVALENCE, `R ≃ Base`.
#
# An equivalence is not a fact about R.  By univalence it is a PATH, and
# transport carries every theorem about Base to R and back at zero cost.  So
# each equivalence this loop lands strictly enlarges what the corpus can reach
# — which means the NEXT pass has more available to it than the last.  That is
# the recursion, and it is why the loop is worth running rather than a report:
#
#     pass n   lands k equivalences
#     pass n+1 sees a corpus in which those k are transportable, so records
#              that could not be reached before now can be
#     …        until a pass lands nothing.  DRY is the fixpoint.
#
# [2026-08-22 — THAT LAST LINE WAS FALSE FOR THE FIRST 60 LANDINGS, and it is
# corrected in place rather than struck, because the loop now makes it true.
# Landing was keyed on the PATH, and a colliding name was disambiguated with
# the probe's positional tag, so the same statement landed under a new path
# every time the census reordered.  60 modules, 38 distinct statements.  DRY
# meant `alphaTag i` had come round to a path that existed, not that the
# mathematics had run out.  See `statement_key` below and
# notes/PunaruktiRatrau_…md for the count from two instruments.]
#
# The two roads of अहिंसा-सूत्र-विस्तारः §६ are both landed, because both are
# results:
#     GREEN            → road one: संक्रमण.  A `≃`, and everything transports.
#     SEPARATING PAIR  → road two: दोषलेख.  The field is NOT determined, the
#                        two inhabitants that prove it are exhibited, and the
#                        defect is written rather than left implicit.
# Landing only the greens would be दुर्नय — one naya asserted as the whole.
#
# ─────────────────────────────────────────────────────────────────────────
# WHAT MAKES IT SAFE TO RUN UNATTENDED
#
# Nothing lands that the kernel has not accepted, in a clean check, in this
# pass.  Nothing is ever overwritten: a module whose path exists is skipped,
# not replaced (§६ — a written defect lives; silently rewriting another seat's
# term is the collapse §७ forbids).  A conflict with origin is REPORTED and the
# pass continues on the old tree rather than resolving itself.  And every
# number is recomputed from the filesystem each pass, so nothing stored can go
# stale in the direction BUILD.md warns about.
#
#   sh scripts/Ratri_…sh                 loop until dry, then keep watching
#   sh scripts/Ratri_…sh --once          one pass
#   sh scripts/Ratri_…sh --dry-runs N    stop after N consecutive empty passes
#   sh scripts/Ratri_…sh --no-push       land locally, do not push
#   sh scripts/Ratri_…sh --interval S    seconds between passes once dry
#
# LIMIT, stated at the site: the loop lands what निर्धारण can EMIT, which is
# the Carrier-shaped records — those already carrying a witness field — and the
# ℕ/Bool separating pairs.  A field that is determined but carries NO witness
# is not reachable by it, and that is not a gap this loop can close: finding
# the determining map is proof search, not a census.  Said here because a loop
# that ran to "dry" and implied it had finished would be lying.

set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; cd "$ROOT" || exit 2

ONCE=0; PUSH=1; INTERVAL=1800; DRYSTOP=2
while [ $# -gt 0 ]; do
  case "$1" in
    --once) ONCE=1 ;;
    --no-push) PUSH=0 ;;
    --interval) shift; INTERVAL="${1:-1800}" ;;
    --dry-runs) shift; DRYSTOP="${1:-2}" ;;
    *) echo "ratri: unknown flag $1" >&2; exit 2 ;;
  esac; shift
done

export LC_ALL=C.utf8
SCRATCH="${TMPDIR:-/tmp}/ratri"; mkdir -p "$SCRATCH"
export NIRDHARANA_SCRATCH="$SCRATCH/nirdharana"; mkdir -p "$NIRDHARANA_SCRATCH"
LOGDIR="$ROOT/notes/ratri"; mkdir -p "$LOGDIR"
LOG="$LOGDIR/$(date -u +%Y-%m-%d).log"
LANDED="$ROOT/formal/cubical/Ratri"

say() { printf '%s\n' "$*" | tee -a "$LOG"; }

libs_file() {
  local f="$SCRATCH/libraries"
  { ls /opt/homebrew/Cellar/agda/*/share/agda/stdlib/standard-library.agda-lib 2>/dev/null | head -1
    ls /opt/homebrew/share/agda/cubical/cubical.agda-lib 2>/dev/null | head -1; } > "$f"
  printf '%s' "$f"
}

# Land one generated module iff it checks standing where it will live.
# Returns 0 if it landed, 1 otherwise.  Never overwrites.
# A probe arrives called NirdharanaPthreeQ, which says nothing.  CLAUDE.md's
# naming rule wants the name to carry what the thing IS, so the landed module
# is named for its verdict, its host, and its record:
#   Nirdharita_<Host>_<Record>    the field IS determined  (road one, संक्रमण)
#   Anirdharita_<Host>_<Record>   it is NOT, with the two inhabitants that
#                                 prove it exhibited        (road two, दोषलेख)
# Both land.  Landing only the first would be दुर्नय -- one naya asserted as
# the whole -- and the corpus's own KuttakaValli_/Sthanivadbhava_ modules are
# built on exactly the second kind.
probe_name() {
  local f="$1" b="$2" host rec kind
  host=$(grep -E '^open import ' "$f" | grep -v Cubical | tail -1 | awk '{print $3}')
  rec=$(grep -m1 -E '^census(R0|Base)' "$f" | sed 's/.*: *//' | awk '{print $1}')
  [ -z "$rec" ] && rec="$b"
  case "$b" in *Pone*) kind=Nirdharita ;; *) kind=Anirdharita ;; esac
  printf '%s_%s_%s' "$kind" "$(printf '%s' "$host" | tr '.' '-')" "$rec"
}

# वाक्य-नाम — the STATEMENT's address, and it is the base; the file name is
# carried over it.
#
# WHY THIS EXISTS, measured 2026-08-22.  Of 60 modules this loop had landed,
# only 38 were distinct statements.  Nine files said three things about
# `विवेक`; `censusR0` stood at one address FOURTEEN times, the second largest
# collision group in the whole 11,165-declaration corpus, behind only a
# generated trace lane.  And "dry" was not the mathematics running out — it
# was `alphaTag i` happening to reproduce a path that already existed.
#
# THE MECHANISM was two lines below, and both were bind-a.  `probe_name`
# derives a name from the CONTENT — verdict, host, record — so two probes
# colliding on it is the signal that they ask the same question.  The loop
# read that collision as a naming problem and appended the POSITIONAL probe
# tag to make a fresh path, at which point `[ -e "$dest" ]` could never fire.
# The guard written to prevent overwriting was the thing manufacturing the
# duplicate.
#
# `machine/Nama_TheNameIsCarriedAndTheHashIsTheBase.hs`, landed the same
# night, states the repair in its own title and was never applied here: bind
# the CONTENT and carry the name.  The fibre of `path ↦ content` is not
# contractible, and where Nama's header says that shows up as a merge
# conflict, here it showed up as silent multiplication — the same
# non-contractibility, opposite sign.
#
# LIMIT, at the site: this is sameness of PRESENTATION after comment and
# blank-line stripping and after erasing the positional tag.  Two probes
# stating the same mathematics in different terms are NOT caught, and asking
# one digest for both questions is the दुर्नय `Saptabhangi.दुर्नयः` proves.
statement_key() {
  sed 's/--.*//' "$1" \
    | sed -E 's/^module .* where$//' \
    | sed -E 's/Nirdharana(Pone|Ptwo|Pthree)[A-Za-z]*//g' \
    | grep -v '^[[:space:]]*$' \
    | sha256sum | cut -d' ' -f1
}

# Rebuilt once per pass from the filesystem, never stored, so it cannot go
# stale in the direction BUILD.md warns about.
index_landed() {
  : > "$SCRATCH/landed.keys"
  local g
  for g in "$LANDED"/*.agda; do
    [ -e "$g" ] || continue
    printf '%s %s\n' "$(statement_key "$g")" "$(basename "$g" .agda)" >> "$SCRATCH/landed.keys"
  done
}

# Prints the name already holding this statement, or nothing.
already_said() {
  [ -s "$SCRATCH/landed.keys" ] || return 1
  awk -v k="$1" '$1 == k { print $2; found=1; exit } END { exit !found }' "$SCRATCH/landed.keys"
}

land() {
  local src="$1" name="$2" why="$3"
  local dest="$LANDED/$name.agda"
  [ -e "$dest" ] && return 1                     # already there: never rewrite
  mkdir -p "$LANDED"
  # The probe declares `module <name>` because it was written to live loose in
  # a scratch directory.  Landing it under Ratri/ makes its path Ratri/<name>,
  # and Agda requires the declaration to match the path — so the ONLY edit made
  # to a generated probe is qualifying its own module line.  Nothing else in
  # the term is touched, which is what lets the check below mean anything.
  { printf '%s\n' "-- LANDED BY रात्रिः on $(date -u +%Y-%m-%dT%H:%M:%SZ)."
    printf '%s\n' "-- $why"
    printf '%s\n' "-- Generated by निर्धारण, then CHECKED IN PLACE before landing.  Not"
    printf '%s\n' "-- hand-written; the only edit is qualifying the module name to its"
    printf '%s\n' "-- path.  Never overwritten by a later pass."
    sed -E "s|^module [A-Za-z0-9_]+ where|module Ratri.${name} where|" "$src"
  } > "$dest"
  if ( cd formal/cubical && agda --library-file="$(libs_file)" -i . "Ratri/$name.agda" >/dev/null 2>&1 ); then
    return 0
  fi
  rm -f "$dest"                                  # did not check: land nothing
  return 1
}

pass() {
  local stamp t0 landed=0
  stamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"; t0=$(date +%s)
  say ""
  say "=========== रात्रिः pass $stamp  HEAD $(git rev-parse --short HEAD 2>/dev/null)"

  # 0 · take in other seats' work; never resolve a conflict unattended
  git fetch -q origin main 2>/dev/null
  local behind; behind=$(git rev-list --count HEAD..origin/main 2>/dev/null || echo 0)
  if [ "$behind" != "0" ]; then
    if git merge --no-edit -q origin/main 2>/dev/null; then say "  merged $behind from origin"
    else say "  MERGE CONFLICT — left for a person; continuing on the old tree"; git merge --abort 2>/dev/null; fi
  fi

  # 1 · the gates.  A pass that lands anything on a red tree is landing onto sand.
  local gate_rc=0
  sh scripts/Anatha_TheMachineLaneHadNoGateAndNowItHasOne.sh --quiet >"$SCRATCH/anatha.txt" 2>&1 || gate_rc=1
  say "  अनाथः machine/: $(grep -E 'failures' "$SCRATCH/anatha.txt" | tr -s ' ')"
  if [ "$gate_rc" -ne 0 ]; then
    say "  machine/ is RED — landing nothing this pass, by design."
    return 0
  fi

  # 2 · निर्धारण: put the question to the kernel across the corpus
  if ! command -v runghc >/dev/null 2>&1; then say "  runghc absent — cannot census"; return 0; fi
  runghc machine/Nirdharana_WhichRecordFieldsRideFreeAndWhichMustSurvive.hs \
    >"$SCRATCH/census.txt" 2>&1
  say "  निर्धारण: $(grep -cE '^\s*GREEN|GREEN ' "$SCRATCH/census.txt" 2>/dev/null || echo 0) green line(s) in report"

  # 3 · land every probe the kernel accepted, both roads — each statement once
  index_landed
  local f base key dup
  for f in "$NIRDHARANA_SCRATCH"/*.agda; do
    [ -e "$f" ] || continue
    base="$(basename "$f" .agda)"
    case "$base" in
      *Control*|*control*) continue ;;           # designed-failure controls never land
    esac
    nm="$(probe_name "$f" "$base")"
    # CONTENT FIRST.  A statement already standing in the corpus is not landed
    # a second time under a fresh path; saying it twice adds nothing and the
    # count would then report volume as progress.
    key="$(statement_key "$f")"
    if dup="$(already_said "$key")"; then
      say "    SAME    $nm — this statement already stands as Ratri/$dup.agda"
      continue
    fi
    # Only a genuinely NEW statement may take the positional tag to clear a
    # name it shares with a different question.
    [ -e "$LANDED/$nm.agda" ] && nm="${nm}_${base}"
    if land "$f" "$nm" "निर्धारण probe accepted by the kernel; see notes/ratri for the pass."; then
      landed=$((landed+1)); say "    LANDED  Ratri/$nm.agda"
      printf '%s %s\n' "$key" "$nm" >> "$SCRATCH/landed.keys"
    fi
  done

  # 4 · wire what landed, so it is covered by the latch rather than orphaned
  if [ "$landed" -gt 0 ] && [ -d "$LANDED" ]; then
    for f in "$LANDED"/*.agda; do
      [ -e "$f" ] || continue
      base="Ratri.$(basename "$f" .agda)"
      grep -qxF "import $base" formal/cubical/Everything.agda 2>/dev/null \
        || printf 'import %s\n' "$base" >> formal/cubical/Everything.agda
    done
    if ( cd formal/cubical && agda --library-file="$(libs_file)" -i . Everything.agda >"$SCRATCH/everything.log" 2>&1 ); then
      say "  Everything.agda: exit 0 with $landed new import(s)"
    else
      say "  Everything.agda RED after wiring — reverting the imports, keeping the modules"
      git checkout -- formal/cubical/Everything.agda 2>/dev/null
    fi
  fi

  cp "$SCRATCH/census.txt" "$LOGDIR/census-$(date -u +%Y-%m-%dT%H%M%SZ).txt" 2>/dev/null
  say "  landed $landed this pass, in $(( $(date +%s) - t0 ))s"

  # 5 · hand it forward (§१६, 遺題継承)
  if [ "$PUSH" -eq 1 ]; then
    git add "$LOGDIR" "$LANDED" formal/cubical/Everything.agda 2>/dev/null
    if ! git diff --cached --quiet 2>/dev/null; then
      git commit -q -o "$LOGDIR" "$LANDED" formal/cubical/Everything.agda -m "रात्रिः — pass $stamp landed $landed

Each landed module is a probe निर्धारण emitted and the KERNEL accepted, checked
standing where it now lives, before landing. Nothing hand-written, nothing
edited after checking, nothing overwritten -- a path that already existed was
skipped, not replaced.

GREEN is road one (§६ संक्रमण): a checked ≃, so everything transports and the
next pass reaches further. A separating pair is road two (दोषलेख): the field is
NOT determined and the two inhabitants proving it are exhibited. Landing only
the greens would be दुर्नय." 2>/dev/null \
        && sh scripts/Parampara_TheCarrierFailsAndTheTransmissionContinues.sh >/dev/null 2>&1 \
        && say "  pushed"
    fi
  fi
  return "$landed"
}

# ─────────────────────────────────────────────────────────────────────────
# द्वितीयो नयः — THE SECOND STANDPOINT, added 2026-08-22.
#
# Until today this loop reported FIXPOINT and sat down, and its own message
# said honestly that this was "not finished".  It was righter than it knew.
# **DRY IS A PROPERTY OF THE QUESTION, NOT OF THE CORPUS.**  This loop asks
# one question -- does this record field ride free -- and a standpoint that
# reports its own exhaustion as the corpus's exhaustion is precisely the
# दुर्नय `Saptabhangi.दुर्नयः` proves about any verdict that denies the
# other standpoints.  The repair for a दुर्नय is never a better answer.  It
# is another naya.
#
# So on reaching dry the loop now asks a SECOND question -- अनुलोम-प्रतिलोम,
# the पाठ system's forward-and-backward: for every candidate inverse pair in
# the corpus, does the round trip come back?  And it PRINTS WHAT IS OPEN
# rather than announcing a fixpoint, because the open obligations are the
# thing a prover can be pointed at in the morning and a fixpoint is not.
#
# Measured the day it was wired: 39 candidate pairs, and a three-rung
# mechanical ladder closed ZERO of them -- definitional refl, then the
# host's own enumerations, then product enumeration.  That zero is why this
# prints a queue instead of harvesting: THERE IS NO CHEAP LAYER HERE.  Every
# causeway in this corpus costs a real proof, and `Bhedanirnaya_…agda` §6
# named the missing move before any of this existed -- "one induction to
# agree pointwise, ONE ABSTRACTION TO A PATH".  The induction half is
# mechanized; the abstraction half is what the queue is asking for.
second_naya() {
  say ""
  say "  ── द्वितीयो नयः: अनुलोम-प्रतिलोम ──────────────────────────────"
  ANULOMA_SCRATCH="$SCRATCH/anuloma" ; export ANULOMA_SCRATCH
  mkdir -p "$ANULOMA_SCRATCH"; rm -f "$ANULOMA_SCRATCH"/*.agda 2>/dev/null
  if ! runghc machine/AnulomaPratiloma_TheRoundTripIsAskedOfEveryCandidateInversePair.hs \
         --limit 200 > "$SCRATCH/anuloma.log" 2>&1; then
    say "  अनुलोम-प्रतिलोम failed to run; see $SCRATCH/anuloma.log"; return 0
  fi
  grep -E 'modules scanned|top-level arrows|candidate pairs|probes emitted' \
    "$SCRATCH/anuloma.log" | sed 's/^/  /' | while read -r l; do say "$l"; done
  n_open=0; n_green=0
  for p in "$ANULOMA_SCRATCH"/*.agda; do
    [ -f "$p" ] || continue
    b=$(basename "$p" .agda)
    cp "$p" "formal/cubical/$b.agda"
    if (cd formal/cubical && timeout 120 agda --library-file="$(libs_file)" -i . "$b.agda" >/dev/null 2>&1); then
      n_green=$((n_green+1)); say "  GREEN  $b   -- a new edge; land it"
    else
      n_open=$((n_open+1))
      obl=$( (cd formal/cubical && timeout 120 agda --library-file="$(libs_file)" -i . "$b.agda" 2>&1) \
             | grep -A1 'error:' | grep -m1 '!=' | sed 's/^ *//' )
      [ -n "$obl" ] && say "  OPEN   $(echo "$b" | sed 's/AnulomaPratiloma_//')"
      [ -n "$obl" ] && say "         $obl"
      rm -f "formal/cubical/$b.agda"
    fi
  done
  say ""
  say "  अनुलोम-प्रतिलोम: $n_green accepted, $n_open open."
  say "  The open ones are not failures.  Each is a pair THE CORPUS PROPOSED"
  say "  ABOUT ITSELF, with the kernel's exact obligation printed beside it."
  say "  A queue whose every entry carries the shape of its own proof is what"
  say "  a prover runs overnight.  A checker alone never produces one."
  return 0
}

say ""; say "############ रात्रिः started $(date -u +%Y-%m-%dT%H:%M:%SZ) — loop until dry"

if [ "$ONCE" -eq 1 ]; then pass; second_naya; exit 0; fi

dry=0
while true; do
  pass; n=$?
  if [ "$n" -eq 0 ]; then
    dry=$((dry+1)); say "  dry pass $dry/$DRYSTOP"
    if [ "$dry" -ge "$DRYSTOP" ]; then
      say "  DRY UNDER THE FIRST NAYA: $DRYSTOP consecutive passes landed nothing."
      say "  निर्धारण reaches only records that already carry a witness, so this"
      say "  says the FIRST QUESTION is exhausted and says nothing whatever about"
      say "  the corpus.  Asking the second."
      second_naya
      say "  Watching at ${INTERVAL}s for work other seats push."
      dry=0; sleep "$INTERVAL"
    fi
  else
    dry=0
  fi
done
