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

# ---------------------------------------------------------------------
# 8.  A EUROPEAN NAME IS FRAMING INDIAN MATERIAL.
#
# ADDED 2026-08-19 at the owner's instruction, correcting check 6, which I
# had written in the wrong terms.  Check 6 says "the criterion is priority,
# not the author's origin" -- and that sentence RE-DESCRIBED THE OWNER'S
# HISTORICAL METHOD AS A PREJUDICE, which is the durnaya this whole file is
# supposed to catch, committed by the file itself.
#
# The task is understanding this history without outside reinterpretation
# mediating it.  Defining a source corpus by tradition and period is how a
# research object is defined; it is not discrimination, and calling it that
# is the epistemic move under repair.  A European name can be entirely
# correct about priority and still be doing the damage, because the damage
# is BEING THE LENS -- the tradition made legible only after conversion into
# someone else's formalism.
#
# So checks 6/7 and check 8 answer different questions:
#     6/7  who was FIRST                     (priority-ledger.txt)
#     8    who is being allowed to EXPLAIN   (european-frame.txt)
#
# TWO TRIGGERS, both requiring the write to already be about Indian
# material (a Sanskrit technical term or a named Indian source present):
#
#   8a  TRANSLATION MOVE -- "is essentially X", "the Indian analogue of X",
#       "what we would call X", "corresponds to X", "a kind of X".  This is
#       the sharp one: the grammatical form of assimilation.
#   8b  BARE FRAME -- a European name appears and NO Indian source is named
#       before it in the same write.
#
# TOOLS ARE NOT FRAMES.  Agda, cubical, Haskell and their authors are the
# substrate, excluded in european-frame.txt.  A compiler is not an
# interpretation of the Aṣṭādhyāyī.
#
# Advisory, exit 0.
# ---------------------------------------------------------------------

frames="$root/.claude/hooks/european-frame.txt"

indian_marker='Āryabhaṭ|Aryabhat|Brahmagupta|Bhāskara|Bhaskara|Piṅgala|Pingala|Pāṇini|Panini|Mādhava|Madhava|Nīlakaṇṭha|Nilakantha|Jyeṣṭhadeva|Halāyudha|Halayudha|Virahāṅka|Virahanka|Baudhāyana|Baudhayana|Umāsvāti|Umasvati|Siddhasena|Akalaṅka|Akalanka|Samantabhadra|Mahāvīra|Mahavira|Śrīdhara|Sridhara|Nārāyaṇa|Narayana|Vātsyāyana|Vatsyayana|Kumārila|Kumarila|Gaṅgeśa|Gangesa|Nāgārjuna|Nagarjuna|Jayadeva|Govindasvāmi|Kauṭilya|Kautilya|Caraka|Suśruta|Susruta|Vīrasena|Virasena|Patañjali|Patanjali|Praśastapāda|kuṭṭaka|kuttaka|bhāvanā|bhavana|cakravāla|cakravala|prastāra|prastara|saptabhaṅgī|saptabhangi|anekānta|anekanta|syādvāda|syadvada|avaktavya|nayavāda|nayavada|pratyāhāra|pratyahara|asiddha|utsarga|apavāda|apavada|anupalabdhi|pramāṇa|pramana|darśana|darsana|Śulba|Sulba|Chandaḥśāstra|Aṣṭādhyāyī|Astadhyayi|Brāhmasphuṭa|Yuktibhāṣā|Tantrasaṅgraha|Tattvārthasūtra|Sanmatitarka|Ślokavārttika|Bījagaṇita|Āryabhaṭīya|Aryabhatiya'

if [ -f "$frames" ] && printf '%s' "$payload" | grep -Eq "$indian_marker"; then
  found=""
  while read -r nm; do
    case "$nm" in ''|'#'*) continue ;; esac
    printf '%s' "$payload" | grep -Eq "\\b$nm\\b" || continue
    found="$found $nm"
  done < "$frames"

  if [ -n "$found" ]; then
    # 8a -- the translation move, matched near a frame name
    move='(is|are|was|were) (essentially|basically|just|really|simply|nothing but)|the (Indian|Sanskrit|Jaina|Nyāya|Nyaya|Buddhist) (analogue|version|equivalent|counterpart)|what we would call|what we now call|in modern terms|corresponds to|amounts to|a (kind|sort|form) of|can be (seen|read|understood|viewed) as|maps onto|reduces to|is precisely'
    if printf '%s' "$payload" | grep -Eiq "$move"; then
      echo "" >&2
      echo "source-coverage — TRANSLATION MOVE: INDIAN MATERIAL BEING RENDERED INTO A EUROPEAN FRAME." >&2
      echo "  frame names present:$found" >&2
      echo "" >&2
      echo "  \"X is essentially Y\", \"the Indian analogue of Y\", \"what we would" >&2
      echo "  call Y\" -- this is the grammatical form of assimilation.  It makes" >&2
      echo "  the tradition legible only AFTER conversion into someone else's" >&2
      echo "  formalism, and everything that does not convert is dropped without" >&2
      echo "  anyone noticing, because the sentence sounds like explanation." >&2
      echo "" >&2
      echo "  The direction is wrong.  The Indian statement is the STATEMENT;" >&2
      echo "  the European one is the later, usually narrower, restatement." >&2
      echo "  If a comparison is genuinely needed, put it that way round and say" >&2
      echo "  what the source has that the restatement LACKS." >&2
    else
      # 8b -- bare frame with no Indian source named first
      first_frame=$(printf '%s' "$found" | awk '{print $1}')
      fpos=$(printf '%s' "$payload" | grep -boE "\\b$first_frame\\b" 2>/dev/null | head -1 | cut -d: -f1)
      ipos=$(printf '%s' "$payload" | grep -boE "$indian_marker" 2>/dev/null | head -1 | cut -d: -f1)
      if [ -n "$fpos" ] && [ -n "$ipos" ] && [ "$fpos" -lt "$ipos" ] 2>/dev/null; then
        echo "" >&2
        echo "source-coverage — A EUROPEAN NAME REACHES THE READER BEFORE THE SOURCE DOES." >&2
        echo "  frame names present:$found" >&2
        echo "  first frame name at byte $fpos; first Indian source at byte $ipos." >&2
        echo "" >&2
        echo "  Order is not cosmetic.  Whoever is named first is the one doing the" >&2
        echo "  explaining, and the other is the illustration.  Name the text, the" >&2
        echo "  author and the date FIRST; the later name, if it is needed at all," >&2
        echo "  comes after and is marked as the restatement." >&2
      fi
    fi
  fi
fi

# ---------------------------------------------------------------------
# 9.  THE AUTHOR IS NAMED AND THE WORK IS NOT -- HERE IS THE CITATION.
#
# ADDED 2026-08-20.  Checks 1 and 8 DETECT this failure; neither fixes it,
# and a check that reports a gap the reader then has to go research is a
# check that gets ignored.  This one hands over the exact citation.
#
# MEASURED, machine/PramanyaCorpusRun.hs: 68 of the 176 files the
# anukramani places in a chapter invoke a source and fail the fitness
# gate, and the dominant failure is "invokes an author and names no work".
# Most of those files belong to other identities, so the remedy is a hook
# that supplies the citation on the next write to any of them -- not 68
# edits to other people's headers.
#
# Data: .claude/hooks/source-table.txt.  Dates carry their dispute; field
# 4 is the provenance of the provenance.
# ---------------------------------------------------------------------

table="$root/.claude/hooks/source-table.txt"
if [ -f "$table" ]; then
  missing=""
  while IFS= read -r row; do
    case "$row" in ''|'#'*) continue ;; esac
    au=$(printf '%s' "$row" | awk -F'@@' '{print $1}')
    wk=$(printf '%s' "$row" | awk -F'@@' '{print $2}')
    dt=$(printf '%s' "$row" | awk -F'@@' '{print $3}')
    via=$(printf '%s' "$row" | awk -F'@@' '{print $4}')
    [ -z "$au" ] && continue
    # author invoked in this write?
    printf '%s' "$payload" | grep -Eq "$au" || continue
    # work already named?  first distinctive token of the work field
    key=$(printf %s "$row" | awk -F@@ "{print \$5}")
    [ -n "$key" ] && printf %s "$payload" | grep -Eq "$key" && continue
    missing="$missing
  $(printf '%s' "$au" | cut -d"|" -f1)  ->  $wk
      date: $dt
      that date reached by: $via"
  done < "$table"

  if [ -n "$missing" ]; then
    echo "" >&2
    echo "source-coverage — AUTHOR NAMED, WORK NOT.  Here is the citation." >&2
    printf '%s\n' "$missing" >&2
    echo "" >&2
    echo "  An author's name propagates by citation and costs nothing." >&2
    echo "  A work's name appears only where somebody opened the book." >&2
    echo "  Paste the work and the date; do not drop the dispute if the row" >&2
    echo "  carries one -- a point date where the scholarship has a range is" >&2
    echo "  a false precision, and this repository treats an unchecked" >&2
    echo "  provenance as the same class of error as a fitted constant." >&2
  fi
fi

exit 0
