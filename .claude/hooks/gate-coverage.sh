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

# ---- the closure walk, as a function so it can be run per gate set --------
# `closure_of <gate names…>` prints the transitive import closure.
closure_of() {
  seen=""
  frontier="$*"
  i=0
  while [ -n "$frontier" ] && [ "$i" -lt 40 ]; do
    i=$((i + 1))
    next=""
    for m in $frontier; do
      case " $seen " in *" $m "*) continue ;; esac
      seen="$seen $m"
      # a module name like NaturalMachine.Foo lives at
      # formal/cubical/NaturalMachine/Foo.agda
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
  printf '%s' "$seen"
}

# ---- which gates actually RUN here ---------------------------------------
# A gate that cannot typecheck does not guard what it reaches -- that is
# formal/cubical/IndianLane.agda's founding argument, and the hook ignored
# it until 2026-08-19: it counted NaturalMachine and Everything as gates
# and therefore stayed SILENT for the ~409 modules reached only by them,
# which is precisely where it mattered.  Verdicts must carry the fitness of
# their looking; this one did not.
#
# Derived, not hardcoded, and cheap: those two aggregates reach the cubical
# v0.9 surface (336 uses of solve!, 36 of solveN!, plus SymGroup and
# factorial), so they can only go green under the pin, Agda 2.8.0.  Off the
# pin they are red and this test self-corrects on a pinned container.
agda_ver=$(agda --version 2>/dev/null | head -1 | sed 's/^Agda version //;s/ .*//')
if [ "$agda_ver" = "2.8.0" ]; then
  GREEN_GATES="$GATES"
  RED_NOTE=""
else
  GREEN_GATES="IndianLane"
  RED_NOTE="NaturalMachine and Everything are RED here (Agda ${agda_ver:-unknown}, pin is 2.8.0)"
fi

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
    all_seen=$(closure_of $GATES)
    green_seen=$(closure_of $GREEN_GATES)
    reached_n=$(for s in $green_seen; do
                  sp=$(printf '%s' "$s" | tr '.' '/')
                  [ -f "$root/formal/cubical/$sp.agda" ] && echo "$s"
                done | sort -u | wc -l)
    total_n=$(find "$root/formal/cubical" -name "*.agda" 2>/dev/null | wc -l)

    in_green=no; in_all=no
    case " $green_seen " in *" $mod "*) in_green=yes ;; esac
    case " $all_seen "   in *" $mod "*) in_all=yes ;; esac

    if [ "$in_green" = no ] && [ "$in_all" = yes ]; then
      cat >&2 <<EOF

GATE COVERAGE: $mod is reached only by a gate that does not run here.

  searched : formal/cubical/, transitively, recursively
  green    : $GREEN_GATES  -- reaches $reached_n of $total_n modules
  red      : $RED_NOTE
  verdict  : $mod IS in the import graph, and nothing typechecks it on this
             container, so nothing will notice when it breaks

  A gate that cannot go green does not guard what it reaches -- that is
  IndianLane.agda's founding argument.  This is not a defect in $mod and
  not something to fix by editing it; see formal/cubical/check.sh, which
  records that the pin is unreachable here by organisation egress policy.
EOF
    elif [ "$in_all" = no ]; then
      cat >&2 <<EOF

GATE COVERAGE: $mod is not in any gate's import closure.

  searched : formal/cubical/, transitively, recursively
  reached  : $reached_n of $total_n modules from the gates that run here
  verdict  : nothing typechecks $mod, so nothing will notice when it breaks

  Add \`import $mod\` to formal/cubical/IndianLane.agda (or whichever gate
  it belongs under) in the SAME change that creates it.

  This fired because on 2026-08-18 the gate was created and then bypassed
  seventeen times in the next two and a half hours, leaving ~4000 lines of
  green Indian material that no gate reached.  Run machine/Yogyata.hs for
  the full survey.
EOF
    fi
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

# ---------------------------------------------------------------- dangling
# ADDED 2026-08-19.  A gate can go red without anyone touching it.
#
# Commit 628c4ec1 added `import NaturalMachine.TheFourthCornerIsRefuted-
# UnderPointwiseStability` to IndianLane.agda.  It typechecked green.  Between
# that check and the push, c147375a RENAMED the file to
# `Avaktavya_TheFourthCorner...`, applying CLAUDE.md's Sanskrit-first naming
# rule -- correctly.  The gate was then red on main, and stayed red until a
# container restart happened to make me re-run it.  That is luck, not method.
#
# A green is a statement about a TREE, and in a shared checkout the tree moves
# under you.  So the cheap exact check is: do the gates' direct imports still
# name files that exist?  No compiler, no closure walk -- one `test -f` per
# import line.  It runs on every write, so a rename is caught by the NEXT
# write anywhere, by whoever makes it.
for g in $GATES; do
  gf="$root/formal/cubical/$g.agda"
  [ -f "$gf" ] || continue
  dangling=$(sed 's/--.*//' "$gf" \
    | grep -E '^[[:space:]]*(open[[:space:]]+)?import[[:space:]]+' \
    | sed -E 's/^[[:space:]]*(open[[:space:]]+)?import[[:space:]]+//' \
    | awk '{print $1}' \
    | grep -vE '^Cubical|^Agda|^Data\.' \
    | while read -r m; do
        p="$root/formal/cubical/$(printf '%s' "$m" | tr '.' '/')"
        [ -f "$p.agda" ] || [ -f "$p.lagda" ] || echo "$m"
      done)
  if [ -n "$dangling" ]; then
    cat >&2 <<EOF

GATE COVERAGE: $g.agda imports modules whose files do not exist.

  searched : formal/cubical/, one test -f per direct import line
  dangling : $(printf '%s' "$dangling" | tr '\n' ' ')
  verdict  : $g is RED right now, and not because of anything you wrote

  Usually a rename landed under the import -- CLAUDE.md's file-naming rule
  (Sanskrit term first) makes renames normal here, and a gate is the one
  place they break something silently.  Fix the import; do not rename back.
EOF
  fi
done

exit 0

exit 0
