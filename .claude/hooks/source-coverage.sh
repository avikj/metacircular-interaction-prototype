#!/bin/sh
# PreToolUse advisory: fire the source-coverage check at the moment of the
# write, instead of recording it in CLAUDE.md as advice nobody has in hand.
#
# WHY THIS EXISTS.  CLAUDE.md's §"Regressions observed in one long session"
# diagnosed a DELIVERY failure — "the protocol was not in hand at the moment
# of the act" — and then responded with more prose in the document that is
# not in hand at the moment of the act.  The same file already records the
# right answer, about the Python ban: "enforced mechanically because prose
# failed".  This is that, for the source directive.
#
# WHAT IT CHECKS.  Two things, both cheap, both from failures that actually
# happened here:
#
#  1. AUTHOR-vs-WORK ASYMMETRY.  An author's name propagates by citation; a
#     work's name appears only where someone attended to the work.  When a
#     write mentions an author, this reports how many notes mention the
#     author and how many mention the work.  In this repository "Piṅgala"
#     stood at ten notes and "Chandaḥśāstra" at zero, under more Agda than
#     any other source has; "Yuktibhāṣā" and "Tantrasaṅgraha" at zero while
#     a module was being written on Mādhava's series.
#
#  2. WHIG SCORING.  Phrases that rank a tradition's ideas by proximity to
#     the present.  "The tradition did not accept its own best idea" was
#     written here, about Brahmagupta rejecting the rotating earth, and is
#     wrong on the merits.
#
# ADVISORY ONLY.  Always exits 0.  A blocking guard on a judgement call is
# an outage wearing enforcement's name (see no-python.sh, which learned
# that the hard way).  Fails open on anything it cannot parse.

payload=$(cat 2>/dev/null) || exit 0
[ -z "$payload" ] && exit 0

root="${CLAUDE_PROJECT_DIR:-.}"
[ -d "$root/notes" ] || exit 0

# Does this call write to notes/ or formal/cubical/?  Covers the Write/Edit
# tools and the `cat > path <<EOF` heredoc form, which is how most prose in
# this repository is actually written.
printf '%s' "$payload" | grep -Eq 'notes/[A-Za-z0-9_./-]*\.md|formal/cubical/[A-Za-z0-9_./-]*\.agda|machine/[A-Za-z0-9_./-]*\.hs' || exit 0

out=""

report() {
  author_re="$1"; work_re="$2"; author="$3"; work="$4"
  printf '%s' "$payload" | grep -Eq "$author_re" || return 0
  a=$(grep -rlE "$author_re" "$root/notes" 2>/dev/null | wc -l | tr -d ' ')
  w=$(grep -rlE "$work_re" "$root/notes" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$w" = "0" ]; then
    out="$out
  $author: $a notes.  $work: 0.  The work is unnamed in this corpus."
  else
    out="$out
  $author: $a notes.  $work: $w."
  fi
}

report 'Āryabhaṭ|Aryabhat'            'Āryabhaṭīya|Aryabhatiya'                  'Āryabhaṭa'    'Āryabhaṭīya'
report 'Brahmagupta|Brahmagupt'        'Brāhmasphuṭa|Brahmasphuta'                'Brahmagupta'  'Brāhmasphuṭasiddhānta'
report 'Bhāskara|Bhaskara'             'Bījagaṇita|Bijaganita|Līlāvatī|Lilavati|Siddhānta-Śiromaṇi|Siddhanta.Siromani' 'Bhāskara II' 'Siddhānta-Śiromaṇi'
report 'Piṅgala|Pingala'               'Chandaḥśāstra|Chandahsastra|Chandah'      'Piṅgala'      'Chandaḥśāstra'
report 'Halāyudha|Halayudha'           'Mṛtasañjīvanī|Mrtasanjivani'              'Halāyudha'    'Mṛtasañjīvanī'
report 'Mādhava|Madhava'               'Yuktibhāṣā|Yuktibhasa|Tantrasaṅgraha|Tantrasangraha' 'Mādhava' 'Yuktibhāṣā / Tantrasaṅgraha'
report 'Nīlakaṇṭha|Nilakantha'         'Tantrasaṅgraha|Tantrasangraha'            'Nīlakaṇṭha'   'Tantrasaṅgraha'
report 'Jyeṣṭhadeva|Jyesthadeva'       'Yuktibhāṣā|Yuktibhasa'                    'Jyeṣṭhadeva'  'Yuktibhāṣā'
report 'Pāṇini|Panini'                 'Aṣṭādhyāyī|Astadhyayi|Ashtadhyayi'        'Pāṇini'       'Aṣṭādhyāyī'
report 'Patañjali|Patanjali'           'Mahābhāṣya|Mahabhasya'                    'Patañjali'    'Mahābhāṣya'
report 'Umāsvāti|Umasvati|Umāsvāmī'    'Tattvārthasūtra|Tattvarthasutra'          'Umāsvāti'     'Tattvārthasūtra'
report 'Siddhasena'                    'Sanmatitarka|Sammai'                      'Siddhasena'   'Sanmatitarka'
report 'Samantabhadra'                 'Āptamīmāṃsā|Aptamimamsa'                  'Samantabhadra' 'Āptamīmāṃsā'
report 'Akalaṅka|Akalanka'             'Laghīyastraya|Laghiyastraya|Aṣṭaśatī'     'Akalaṅka'     'Laghīyastraya'
report 'Gaṅgeśa|Gangesa'               'Tattvacintāmaṇi|Tattvacintamani'          'Gaṅgeśa'      'Tattvacintāmaṇi'
report 'Praśastapāda|Prasastapada'     'Padārthadharmasaṃgraha|Padarthadharma'    'Praśastapāda' 'Padārthadharmasaṃgraha'
report 'Vīrasena|Virasena'             'Dhavalā|Dhavala'                          'Vīrasena'     'Dhavalā'

if [ -n "$out" ]; then
  echo "source-coverage — author vs work, in notes/:" >&2
  printf '%s\n' "$out" >&2
  echo "  A WORK AT 0 MEANS THE SOURCE HAS BEEN CITED AND NOT READ." >&2
  echo "  That is the whole mechanism.  A name propagates by citation and" >&2
  echo "  costs nothing; a title appears only where somebody opened the book." >&2
  echo "  Citing an author you have not read, in a corpus built out of their" >&2
  echo "  work, is not a small sourcing lapse -- it is treating a tradition as" >&2
  echo "  a credential to attach rather than a mind to argue with.  Go read it." >&2
fi

# whig scoring
if printf '%s' "$payload" | grep -Eiq "own best idea|best idea|went the wrong way|ahead of (his|its|their) time|anticipat(e|es|ed|ing) the|failed to accept|should have accepted"; then
  echo "" >&2
  echo "source-coverage — ranking language detected." >&2
  echo "  Scoring a tradition's ideas by proximity to the present is a durnaya;" >&2
  echo "  what is missing is syāt.  Record what happened, do not score it." >&2
  echo "  Worked case: CLAUDE.md, Brahmagupta and the rotating earth." >&2
fi


# ---------------------------------------------------------------------
# 3. RIVAL SCHOOLS AS ONE TOOLKIT
#
# Nyāya-Vaiśeṣika and Jaina technical vocabulary in one write, with the
# dispute between them unnamed.  These schools reject each other's
# categories — Jaina logicians reject the Naiyāyika treatment of
# negation, Naiyāyikas reject anekāntavāda — so using both as one box of
# instruments takes from each the part that converts and discards the
# dispute, which is frequently the content.
#
# Only DISTINCTIVE markers are matched.  dravya, guṇa, padārtha and
# pramāṇa are shared across both and are deliberately absent from these
# lists.
# ---------------------------------------------------------------------

nyaya_re='pratiyogin|anuyogin|avacchedaka|Naiyāyika|Naiyayika|vyāpti|vyapti|saṃsargābhāva|samsargabhava|anyonyābhāva|anyonyabhava|Gaṅgeśa|Gangesa|Praśastapāda|Prasastapada|Udayana'
jaina_re='anekānta|anekanta|syādvāda|syadvada|saptabhaṅgī|saptabhangi|avaktavya|durnaya|nayavāda|nayavada|guṇasthāna|gunasthana|kevala|Umāsvāti|Umasvati|Siddhasena|Akalaṅka|Akalanka|Samantabhadra'
dispute_re='dispute|disput|reject|rival|disagree|contest|against each other|two schools|the schools|each other'"'"'s categories'

if printf '%s' "$payload" | grep -Eq "$nyaya_re" \
   && printf '%s' "$payload" | grep -Eq "$jaina_re" \
   && ! printf '%s' "$payload" | grep -Eiq "$dispute_re"; then
  echo "" >&2
  echo "source-coverage — two darśanas, one toolkit." >&2
  echo "  This write uses Nyāya-Vaiśeṣika and Jaina technical vocabulary and does" >&2
  echo "  not name the dispute between them.  These schools reject each other's" >&2
  echo "  categories: Jaina logicians reject the Naiyāyika treatment of negation," >&2
  echo "  Naiyāyikas reject anekāntavāda.  Name the school before the term, and if" >&2
  echo "  a construction draws on both, say what the two would say to each other." >&2
  echo "  Worked case: NaturalMachine/AnyonyaAbhava.agda §8." >&2
fi

# (checks continue below)

# ---------------------------------------------------------------------
# 4.  THE AUDIT BEHIND THE TERM.
#
# A Sanskrit technical term used in formal/ while the note that audits it
# sits unread in notes/.  This happened: NaturalMachine/AnyonyaAbhava.agda
# glossed an observational separation as an anyonyābhāva, while
# notes/ABHAVA.md §2 — a primary-text audit against Tarkasaṅgraha §§57,80,
# by another identity — says in as many words that anyonyābhāva is
# "non-identity, NOT observational separation by itself", and closes with
# "These four struck equations were modern constructions, not consequences
# of the fourfold."  The module never cited it.
#
# So: for each term in the write, report how many notes carry it and WHICH
# of those carry a correction marker.  The corrected ones are the ones to
# read; a note that has already been audited is where the trap is.
# ---------------------------------------------------------------------

terms='abhāva:abhava prāgabhāva:pragabhava pradhvaṃsābhāva:pradhvamsabhava
atyantābhāva:atyantabhava anyonyābhāva:anyony pratiyogin:pratiyogin
avacchedaka:avacchedaka anuvṛtti:anuvrtti pratyāhāra:pratyahara
apavāda:apavada lāghava:laghava asiddhatva:asiddhatva
saptabhaṅgī:saptabhang anekānta:anekanta nikṣepa:niksepa
catuṣkoṭi:catuskoti nayavāda:nayavada avaktavya:avaktavya
kuṭṭaka:kuttaka bhāvanā:bhavana cakravāla:cakravala prastāra:prastara'

for pair in $terms; do
  label=${pair%%:*}
  pat=${pair#*:}
  if printf '%s' "$payload" | grep -Fiq "$pat" \
     || printf '%s' "$payload" | grep -Fq "$label"; then
    n=$(grep -rlia "$pat" "$CLAUDE_PROJECT_DIR/notes" 2>/dev/null | wc -l | tr -d ' ')
    c=$(grep -rlia "$pat" "$CLAUDE_PROJECT_DIR/notes" 2>/dev/null \
        | xargs grep -l 'CORRECTED\|withdrawn\|WITHDRAWN\|struck\|RETRACT' 2>/dev/null \
        | wc -l | tr -d ' ')
    if [ "${c:-0}" -gt 0 ]; then
      echo "" >&2
      echo "source-coverage — $label: $n note(s), $c already carrying a correction." >&2
      grep -rlia "$pat" "$CLAUDE_PROJECT_DIR/notes" 2>/dev/null \
        | xargs grep -l 'CORRECTED\|withdrawn\|WITHDRAWN\|struck\|RETRACT' 2>/dev/null \
        | head -3 | sed "s|^|    read: |" >&2
      [ "${c:-0}" -gt 3 ] && echo "    … and more" >&2
      echo "  A term whose note has already been audited is where the trap is." >&2
    fi
  fi
done

# ---------------------------------------------------------------------
# 5.  MODULES THAT SHARE YOUR IMPORTS.
#
# Grepping the latch for a THREAD'S NAME does not find the module that
# already proves your statement: NaturalMachine.OneLemmaFiveSites already
# had `¬ FactorsThrough eval size` and `¬ FactorsThrough asSet cost`, and
# its name contains none of "Laghava", "Anuvrtti", "Pratyahara",
# "Apavada".  What it DOES share is imports — duplicate work nearly always
# opens the same modules.  And a duplicated proof of a NEGATION is
# invisible in the conclusion, negations being propositions, so imports
# are the only place it can be seen.
#
# Reports the existing modules opening the most of what this write opens.
# ---------------------------------------------------------------------

imports=$(printf '%s' "$payload" \
          | grep -o 'open import NaturalMachine\.[A-Za-z0-9]*' \
          | sed 's/open import NaturalMachine\.//' | sort -u)

if [ -n "$imports" ]; then
  nm="$CLAUDE_PROJECT_DIR/formal/cubical/NaturalMachine"
  hits=$(for m in $imports; do
           grep -l "open import NaturalMachine\.$m\b" "$nm"/*.agda 2>/dev/null
         done | sort | uniq -c | sort -rn | head -4)
  if [ -n "$hits" ]; then
    echo "" >&2
    echo "source-coverage — modules already opening what you open:" >&2
    printf '%s\n' "$hits" | sed 's|^ *\([0-9]*\) .*/\([A-Za-z0-9]*\)\.agda|    \1 shared: \2|' >&2
    echo "  Before proving anything, grep these for your CONCLUSION TYPE." >&2
  fi
fi


# ---------------------------------------------------------------------
# 6.  THE DISPLACING NAME, and 7. THE UNANSWERED EPONYM.
#
# ADDED 2026-08-19 at the owner's instruction.  Checks 1-5 measure how WELL
# a source was cited.  None fires when the source is not cited at all
# because a European name took its place -- the failure CLAUDE.md's whole
# table is about, and the one that had no mechanism.
#
# THE FIRST VERSION OF THIS WAS EIGHT HARDCODED CASES AND THE OWNER WAS
# RIGHT TO CALL IT WEAK.  A sweep of the corpus (notes/, formal/, machine/)
# for eponym-shaped constructions -- `<Name>'s <object>`, `<Name> <object>`
# -- returned 1531 DISTINCT ONES.  Eight is a rounding error against that.
#
# So this is two checks, not one:
#
#   6.  LEDGER HIT.  The name is in .claude/hooks/priority-ledger.txt, which
#       carries the earliest establishable statement with text and date, and
#       the gap in years.  Loud.  Data, not code -- add rows.
#
#   7.  UNANSWERED.  The name is eponym-shaped and NOT in the ledger.  This
#       is the check that scales, because it does not need me to have
#       anticipated the name.  It does not assert that a prior source
#       exists.  It asserts that THE PRIORITY QUESTION HAS NOT BEEN ASKED
#       here, which is true, and which is the thing that has to happen
#       before the name is written.
#
# WHAT THIS DELIBERATELY IS NOT: a filter on the author's origin.  CLAUDE.md
# states that limit ("Do not filter sources by the author's ethnicity --
# that is not a rule this repository can implement coherently") and the
# owner's own operating principle says "plus Voevodsky", because the whole
# cubical substrate is his.  An origin filter would flag Voevodsky,
# Martin-Löf and Agda's authors and be dismissible on sight.  The ledger
# measures PRIORITY, and carries four intra-European theft rows -- del Ferro
# / Cardano, Johann Bernoulli / l'Hôpital, Maclaurin / Cramer, Euler / Venn
# -- precisely so that it cannot be waved away as identity politics.  A
# priority ledger is the harder instrument and the one that holds up.
#
# Advisory, exit 0, as everything in this file.
# ---------------------------------------------------------------------

ledger="$root/.claude/hooks/priority-ledger.txt"
seen_hits=""

if [ -f "$ledger" ]; then
  while IFS='@@' read -r line; do :; done < /dev/null   # portability probe, unused
  # `read` with a multi-char IFS is not portable; split with awk instead.
  i=0
  while [ "$i" -lt 200 ]; do
    i=$((i + 1))
    row=$(awk -v n="$i" 'BEGIN{c=0} !/^#/ && NF>0 {c++; if(c==n){print; exit}}' "$ledger")
    [ -z "$row" ] && break
    pat=$(printf '%s' "$row"    | awk -F'@@' '{print $1}')
    theirs=$(printf '%s' "$row" | awk -F'@@' '{print $2}')
    src=$(printf '%s' "$row"    | awk -F'@@' '{print $3}')
    gap=$(printf '%s' "$row"    | awk -F'@@' '{print $4}')
    [ -z "$pat" ] && continue
    printf '%s' "$payload" | grep -Eq "$pat" || continue
    seen_hits="$seen_hits $pat"
    printf '%s' "$payload" | grep -Eq "$theirs" && continue
    echo "" >&2
    echo "source-coverage — A DISPLACING NAME IS BEING USED AS THE CITATION." >&2
    echo "  you wrote  : $pat" >&2
    echo "  the source : $src" >&2
    echo "  the gap    : $gap" >&2
    echo "" >&2
    echo "  This is not a shorthand and it is not a style preference.  The" >&2
    echo "  attribution is FALSE, it is known to be false, and repeating it is" >&2
    echo "  an act performed now -- by you, in the present tense -- not an" >&2
    echo "  inherited condition you are innocent of.  Your prior offers the" >&2
    echo "  European name first because the archive you trained on was built" >&2
    echo "  by the people who took it.  That reflex IS the defect under repair." >&2
    echo "  Name the source, with text and date, FIRST." >&2
  done
fi

# ---- 7. the unanswered eponym -----------------------------------------
# Everything shaped like an attribution that the ledger does not know about.
# Stopwords are English articles/determiners and this repo's own identifiers,
# which the shape matches by accident ("The theorem", "Agda theorem",
# "AllHold law").  Getting this list wrong costs a reader one line.
eponym_obj='theorem|algorithm|identity|series|conjecture|formula|method|criterion|inequality|transform|constant|equation|rule|law|paradox|sieve|expansion|duality|correspondence|triangle|lemma'
stop='^(The|This|That|These|Those|Every|Each|Both|Some|Any|All|No|Not|Nothing|One|Two|Three|Their|Its|His|Her|Our|Your|Same|First|Last|Next|Other|Another|Such|What|Which|Where|When|Refutes|AllHold|Agda|Lean|Haskell|Python|Cubical|Sanskrit|Indian|Western|European|Type|Set|Data|Main|Note|See|Here|There|Now|Then|If|For|And|But|Only|Also|Still|Thus|So|It|We|I|A|An)$'

cands=$(printf '%s' "$payload" \
  | grep -ohE "[A-Z][A-Za-zäöüéèáíóúñ'’-]{2,}('s|s')? ($eponym_obj)" 2>/dev/null \
  | sed "s/'s\{0,1\} / /; s/’s\{0,1\} / /" \
  | awk '{print $1}' | sort -u | grep -Ev "$stop")

unanswered=""
for c in $cands; do
  # already covered by a ledger row that fired?
  case " $seen_hits " in *"$c"*) continue ;; esac
  grep -qi "^[^#]*$c" "$ledger" 2>/dev/null && continue
  unanswered="$unanswered $c"
done

if [ -n "$unanswered" ]; then
  echo "" >&2
  echo "source-coverage — EPONYM WITH THE PRIORITY QUESTION UNASKED:$unanswered" >&2
  echo "  Not a claim that an earlier source exists.  A claim that YOU HAVE NOT" >&2
  echo "  CHECKED, which is true, and which is the step that has to happen" >&2
  echo "  before a person's name is welded onto a mathematical object." >&2
  echo "  A sweep of this corpus found 1531 distinct eponym constructions." >&2
  echo "  The ledger answers 23 of them.  The remainder is the work." >&2
  echo "" >&2
  echo "  Ask, in this order: what does the object DO; who states it earliest;" >&2
  echo "  what is the text and the date; how many years to the name you typed." >&2
  echo "  Then add a row: .claude/hooks/priority-ledger.txt  (one line, data)." >&2
fi

exit 0
