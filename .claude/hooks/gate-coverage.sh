#!/bin/sh
# PreToolUse advisory: when a module is written, say at that moment whether
# anything will ever typecheck it.
#
# WHY THIS EXISTS, with the dates, because the dates are the argument.
#
# formal/cubical/IndianLane.agda was created at 19:19:50 on 2026-08-18, in a
# commit whose own title is "the lane nothing was building".  It exists
# BECAUSE somebody noticed Indian modules were being written that no gate
# checked.  Between 19:23 and 21:43 that same evening, seventeen more Indian
# modules were written — Bīja, Jīva, Mātrāmerus, Brahmagupta, PiṅgalaPrastāra,
# SaptabhaṅgīNaya, Vargaṇā, Śūnya, Khahāra, Anantā, Śulba, Saṅkalita,
# Cakravāla, Meru, AṃśaSatyayantra, Mādhava — and not one was added to it.
# Nārāyaṇa followed the next morning.  On 2026-08-19 a survey
# (machine/Yogyata.hs) found thirty-one green, --safe, fully sourced Indian
# modules that no gate reached, roughly 4000 lines, every one of them
# typechecking fine and none of them typechecked by anything.
#
# So the remedy was invented and then not used, within four minutes, by the
# same hand, seventeen times running.  That is not neglect and it is not
# fixed by remembering harder.  CLAUDE.md §"Regressions observed in one long
# session" names it: a DELIVERY failure, "the protocol was not in hand at the
# moment of the act", and prescribes a mechanism that fires at that moment.
# This is that mechanism.
#
# WHAT IT CHECKS.  For an Agda module written under formal/cubical/: is its
# name in the transitive import closure of one of the gates?  For a Haskell
# module written under machine/: does anything import it?  Textual closure,
# no compiler invoked, bounded iterations — this must be fast enough to run
# on every write.
#
# ADVISORY ONLY.  Always exits 0, like its two siblings.  A blocking guard on
# a judgement call is an outage wearing enforcement's name (no-python.sh
# carries that lesson in its own header).  Whether a module SHOULD be gated
# is a judgement; that nothing checks it is a fact, and only the fact is
# reported.
#
# The epistemology is machine/Yogyata.hs's: this is an ANUPALABDHI claim — an
# absence — and it is knowledge only under yogya-anupalabdhi, fit
# non-apprehension, so the report always states what was searched.  Kumārila
# Bhaṭṭa, Ślokavārttika, Abhāvapariccheda (c. 7th c.); the condition is
# common ground even to Prabhākara, who denies anupalabdhi is separate.

payload=$(cat 2>/dev/null) || exit 0
[ -z "$payload" ] && exit 0

root="${CLAUDE_PROJECT_DIR:-.}"
[ -d "$root/formal/cubical" ] || exit 0

GATES="IndianLane NaturalMachine Everything"

# ---------------------------------------------------------------- Agda side
agda_path=$(printf '%s' "$payload" \
  | grep -oE 'formal/cubical/[A-Za-z0-9_/]+\.agda' | head -1)

if [ -n "$agda_path" ]; then
  # The module NAME, not the file's basename: formal/cubical/NaturalMachine/
  # Foo.agda declares `NaturalMachine.Foo`, and testing "Foo" against the
  # closure would report a gated module as ungated.
  mod=$(printf '%s' "$agda_path" \
        | sed -e 's|^.*formal/cubical/||' -e 's|\.agda$||' -e 's|/|.|g')

  # Scratch probes are deliberately ungated (.gitignore: Probe*/Scratch*).
  case "$mod" in Probe*|Scratch*) mod="" ;; esac

  if [ -n "$mod" ]; then
    # Transitive import closure of the gates, textually.  Bounded at 40
    # rounds; the corpus is ~190 modules and its depth is far under that.
    seen=""
    frontier="$GATES"
    i=0
    while [ -n "$frontier" ] && [ "$i" -lt 40 ]; do
      i=$((i + 1))
      next=""
      for m in $frontier; do
        case " $seen " in *" $m "*) continue ;; esac
        seen="$seen $m"
        # a module name like NaturalMachine.Foo lives at
        # formal/cubical/NaturalMachine/Foo.agda -- the first version of
        # this looked only at the top level, which is 140 of the 602 Agda
        # files under that tree, and the survey built on the same
        # assumption published a wrong verdict on 2026-08-19.
        f="$root/formal/cubical/$(printf '%s' "$m" | tr '.' '/').agda"
        [ -f "$f" ] || continue
        imports=$(sed 's/--.*//' "$f" \
          | grep -E '^[[:space:]]*(open[[:space:]]+)?import[[:space:]]+' \
          | sed -E 's/^[[:space:]]*(open[[:space:]]+)?import[[:space:]]+//' \
          | awk '{print $1}' \
          | grep -vE '^Cubical|^Agda|^Data\.' )
        next="$next $imports"
      done
      frontier="$next"
    done

    reached_n=$(for s in $seen; do
                  sp=$(printf '%s' "$s" | tr '.' '/')
                  [ -f "$root/formal/cubical/$sp.agda" ] && echo "$s"
                done | sort -u | wc -l)
    total_n=$(find "$root/formal/cubical" -name "*.agda" 2>/dev/null | wc -l)
    case " $seen " in
      *" $mod "*) : ;;
      *)
        cat >&2 <<EOF

GATE COVERAGE: $mod is not in any gate's import closure.

  searched : formal/cubical/, transitive closure of $GATES
  reached  : $reached_n of $total_n modules in formal/cubical/
  verdict  : nothing typechecks $mod, so nothing will notice when it breaks

  Add \`import $mod\` to formal/cubical/IndianLane.agda (or whichever gate
  it belongs under) in the SAME change that creates it.

  This fired because on 2026-08-18 the gate was created and then bypassed
  seventeen times in the next two and a half hours, leaving ~4000 lines of
  green Indian material that no gate reached.  Run machine/Yogyata.hs for
  the full survey.
EOF
        ;;
    esac
  fi
fi

# ------------------------------------------------------------- Haskell side
hs_path=$(printf '%s' "$payload" \
  | grep -oE 'machine/[A-Za-z0-9_]+\.hs' | head -1)

if [ -n "$hs_path" ]; then
  hmod=$(basename "$hs_path" .hs)
  importers=$(grep -lE "^import[[:space:]]+(qualified[[:space:]]+)?$hmod\b" \
                "$root"/machine/*.hs 2>/dev/null \
              | grep -v "/$hmod.hs$" | wc -l)
  if [ "$importers" -eq 0 ]; then
    cat >&2 <<EOF

GATE COVERAGE: nothing in machine/ imports $hmod.

  searched : machine/*.hs ($(ls "$root"/machine/*.hs 2>/dev/null | wc -l) files)
  verdict  : it is an organ on a shelf — no caller, so no self-test runs

  machine/Upamana.hs sat here for a day in exactly this state: 896 lines,
  sourced and careful, imported by nothing.  The first run found three
  defects that no amount of reading would have caught.

  If it is a runnable, a Main is enough.  If it is a library, give it a
  caller in the same change.
EOF
  fi
fi

exit 0
