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
printf '%s' "$payload" | grep -Eq 'notes/[A-Za-z0-9_./-]*\.md|formal/cubical/[A-Za-z0-9_./-]*\.agda' || exit 0

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
  echo "  (A work at 0 means the source has been cited, not read.)" >&2
fi

# whig scoring
if printf '%s' "$payload" | grep -Eiq "own best idea|best idea|went the wrong way|ahead of (his|its|their) time|anticipat(e|es|ed|ing) the|failed to accept|should have accepted"; then
  echo "" >&2
  echo "source-coverage — ranking language detected." >&2
  echo "  Scoring a tradition's ideas by proximity to the present is a durnaya;" >&2
  echo "  what is missing is syāt.  Record what happened, do not score it." >&2
  echo "  Worked case: CLAUDE.md, Brahmagupta and the rotating earth." >&2
fi

exit 0
