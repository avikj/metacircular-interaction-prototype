#!/bin/sh
# MulaVakya_TheHeaderCarriesItsTextAndDate.sh
#
# नाम्नि जीवनम् । शब्दे जीवनानि ।
# यो नाम प्रमाणम् इव गृह्णाति स जीवनं सङ्क्षिपति ।
# अनवधानेन शब्दो नष्टिं करोति । सा वाग्-हिंसा ।
#     — notes/AHIMSA_SUTRA_VISTARA.md §12
#
# WHY THIS EXISTS.
#
# CLAUDE.md's file-naming rule sets three conditions on a module that leads
# with a term from a tradition, and then says, in its own words, why they
# are not decoration: "so this does not decay into decoration".  It decayed
# into decoration.  Measured over formal/cubical, machine, kernel and
# machinery on 2026-08-20: 86 modules lead with a term; 6 meet all three
# conditions; 27 meet none of them.
#
#   1  the term must be the one the source uses, WITH THE TEXT AND THE DATE
#      AVAILABLE IN THE HEADER
#   2  where the mathematics originates elsewhere, SAY SO in the header
#      rather than inventing a Sanskrit label
#   3  state WHAT IS AND IS NOT BEING CLAIMED of the source — "naming a
#      module for ṛṇa-dhana does not say Brahmagupta proved the theorem"
#
# CLAUDE.md also states the operative principle for this situation: "When a
# rule here is violated repeatedly, the next move is a mechanism that fires
# at the moment of the act, not a paragraph."  Prose has had this rule since
# 2026-08-19 and the ratio is 6 in 86.  This is the mechanism.
#
# WHAT IT DOES THAT A COMPLAINT WOULD NOT.  It hands you the citation.
# MulaVakya_SourceStatementsForTheTermsInOurFileNames.txt carries 65 rows,
# each with the text, the chapter or sūtra, and the date.  A check that only
# says "you are missing a date" makes the next agent guess, and a guessed
# date is a fabricated provenance — the exact error the apparatus exists to
# stop.  Condition 3 it cannot supply and does not pretend to: only the
# author knows what the module proves.
#
# WHAT CANNOT BE MECHANISED HERE, said in the rule so that the next agent
# does not read unmechanisable as unenforced:
#
#   (a) WHETHER THE ROW IS RIGHT.  Field 4 of every row is a claim about
#       priority made by whoever wrote the row.  No script can check that a
#       date is the earliest establishable one; that needs somebody to open
#       the text.  The rows are data precisely so they can be refuted.
#   (b) WHETHER THE TERM FITS THE OBJECT.  "The term must be the one the
#       source actually uses FOR THAT OBJECT."  A module can cite
#       Brāhmasphuṭasiddhānta 18.30-35 correctly and still be about
#       something that is not ṛṇa-dhana.  Only reading both decides it.
#   (c) WHETHER THE SCOPE SENTENCE IS TRUE.  Presence is checkable; honesty
#       is not.  "No claim is made that Brahmagupta proved anything below"
#       is checkable as a string and worthless as a string.
#
#   (d) A FIXED FALSE NEGATIVE, recorded because it nearly shipped: the
#       first version matched titles only in Latin script, so a header that
#       named छन्दःशास्त्रम् ८.२४-२८ in Devanagari read as "no text".  A
#       check that scores a Devanagari citation lower than a romanised one
#       IS the scrubbing pressure CLAUDE.md's naming rule was written
#       against, arriving through the back door as a lint.  Both scripts
#       are matched now.  Any further script — Tamil, Persian, Prakrit in
#       Devanagari — will have the same problem; add it, do not romanise.
#
# So this check measures PRESENCE, which is the floor, and the floor is
# currently at 7%.  Do not mistake a clean run for a sourced module.
#
# ADVISORY.  Always exits 0.  A blocking guard on a judgement call is an
# outage wearing enforcement's name — see no-python.sh, whose own header
# records the session where its absence killed every shell in the repo.
#
# USAGE
#   (hook)     PreToolUse on Write|Edit and Bash; reads the payload on stdin
#   --audit    walk the corpus and print the three counts.  The number moves.

root="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
ledger="$root/.claude/hooks/MulaVakya_SourceStatementsForTheTermsInOurFileNames.txt"
[ -f "$ledger" ] || exit 0

# ── what counts as a date, a text, a scope sentence ────────────────────
DATE_RE='[०-९]{3,4}|\(-?[0-9]{3,4}\)|~ ?-?[0-9]{3,4}|c\. ?[0-9]{3,4}|[0-9]{3,4} ?(BCE|CE)|[0-9]{1,2}(st|nd|rd|th) c\.|, [0-9]{3,4}(,|\)|\.)| in [0-9]{3,4}'
# a title in *emphasis*, or one of the works this corpus actually draws on
TEXT_RE='छन्दःशास्त्र|आर्यभटीय|ब्राह्मस्फुट|अष्टाध्यायी|महाभाष्य|तत्त्वार्थ|न्यायसूत्र|सन्मतितर्क|आप्तमीमांसा|लघीयस्त्रय|श्लोकवार्त्तिक|वैशेषिकसूत्र|तर्कसंग्रह|तर्कसङ्ग्रह|तत्त्वचिन्तामणि|प्रमाणसमुच्चय|प्रमाणवार्त्तिक|बीजगणित|लीलावती|युक्तिभाषा|तन्त्रसंग्रह|तन्त्रसङ्ग्रह|शुल्बसूत्र|मृतसञ्जीवनी|अर्थशास्त्र|चरकसंहिता|सुश्रुतसंहिता|मूलमध्यमक|पदार्थधर्म|वृत्तजातिसमुच्चय|खण्डखाद्यक|गणितसारसंग्रह|षट्खण्डागम|धवला|अनुयोगद्वार|स्थानाङ्ग|भगवतीसूत्र|प्रातिशाख्य|आचाराङ्ग|परिभाषेन्दुशेखर|सिद्धान्तकौमुदी|रूपावतार|कर्मप्रकृति|बृहती|वाक्यार्थमातृका|ग्रहचारनिबन्धन|चरणव्यूह|मुण्डक|\*[A-ZĀĪŪŚṢṚṄÑṬḌṆ][^*]{3,}\*|Āryabhaṭīya|Aryabhatiya|Brāhmasphuṭa|Brahmasphuta|Aṣṭādhyāyī|Astadhyayi|Chandaḥśāstra|Chandahsastra|Mahābhāṣya|Mahabhasya|Tattvārthasūtra|Tattvarthasutra|Sanmatitarka|Āptamīmāṃsā|Aptamimamsa|Laghīyastraya|Laghiyastraya|Ślokavārttika|Slokavarttika|Nyāyasūtra|Nyayasutra|Vaiśeṣikasūtra|Vaisesikasutra|Tarkasaṅgraha|Tarkasangraha|Tattvacintāmaṇi|Tattvacintamani|Padārthadharma|Padarthadharma|Pramāṇasamuccaya|Pramanasamuccaya|Pramāṇavārttika|Mūlamadhyamaka|Mulamadhyamaka|Bījagaṇita|Bijaganita|Līlāvatī|Lilavati|Yuktibhāṣā|Yuktibhasa|Tantrasaṅgraha|Tantrasangraha|Śulbasūtra|Sulbasutra|Mṛtasañjīvanī|Mrtasanjivani|Vṛttajātisamuccaya|Vrttajatisamuccaya|Arthaśāstra|Arthasastra|Carakasaṃhitā|Carakasamhita|Suśrutasaṃhitā|Susrutasamhita|Paribhāṣenduśekhara|Paribhasendusekhara|Siddhāntakaumudī|Siddhantakaumudi|Rūpāvatāra|Rupavatara|Anuyogadvāra|Anuyogadvara|Sthānāṅga|Sthananga|Bhagavatīsūtra|Ṣaṭkhaṇḍāgama|Satkhandagama|Dhavalā|Prātiśākhya|Pratisakhya|Karmaprakṛti|Vākyārthamātṛkā|Bṛhatī|Khaṇḍakhādyaka|Khandakhadyaka|Gaṇitasārasaṅgraha|Ganitasarasangraha|Ācārāṅga|Acaranga|Nayopadeśa|Tattvārthaślokavārttika|Sundarī|Āryabhaṭīyabhāṣya|Grahacāranibandhana|Avataṃsaka|Avatamsaka|Caraṇavyūha|Caranavyuha|Muṇḍaka|Mundaka'
# condition 3: what is and is not being claimed of the source
SCOPE_RE='no claim is made|No claim is made|NO CLAIM|does not claim|do not claim|is not claimed|are not claimed|not a claim that|nothing below is claimed|does not say that|does not assert that|the term is ours|the compound is ours|is ours, not|built here|coined here|is not (his|hers|theirs)|the .* is his, the|originates elsewhere|not a source term|is my own|is mine, not'

# ── does a header meet the conditions?  echoes a three-flag word ───────
verdict() {   # $1 = header text
  h=$1
  d=-; t=-; s=-
  printf '%s' "$h" | grep -Eq "$DATE_RE"  && d=D
  printf '%s' "$h" | grep -Eq "$TEXT_RE"  && t=T
  printf '%s' "$h" | grep -Eq "$SCOPE_RE" && s=S
  printf '%s%s%s' "$d" "$t" "$s"
}

# ── look the leading term up in the ledger ─────────────────────────────
lookup() {    # $1 = leading segment of the file name; echoes the row or ''
  awk -F'@@' -v seg="$1" '
    /^#/ || NF < 4 { next }
    {
      n = split($1, pats, "|")
      for (i = 1; i <= n; i++) if (pats[i] == seg) { print; exit }
    }' "$ledger"
}

# ── corpus-wide count ──────────────────────────────────────────────────
census() {
  find "$root/formal/cubical" "$root/machine" "$root/kernel" "$root/machinery" \
       -type f \( -name '*.agda' -o -name '*.hs' \) 2>/dev/null \
  | grep -E '/[A-Z][A-Za-z]*_' \
  | while read -r f; do printf '%s %s\n' "$(verdict "$(sed -n '1,40p' "$f")")" "$f"; done
}

# ── audit mode ─────────────────────────────────────────────────────────
if [ "$1" = "--audit" ]; then
  c=$(census)
  tot=$(printf '%s\n' "$c" | grep -c .)
  full=$(printf '%s\n' "$c" | grep -c '^DTS ')
  none=$(printf '%s\n' "$c" | grep -c '^--- ')
  hasd=$(printf '%s\n' "$c" | grep -c '^D')
  hast=$(printf '%s\n' "$c" | awk '{print substr($1,2,1)}' | grep -c 'T')
  hass=$(printf '%s\n' "$c" | awk '{print substr($1,3,1)}' | grep -c 'S')
  echo "मूलवाक्य — provenance census over modules whose name leads with a term"
  echo ""
  echo "  modules leading with a term        $tot"
  echo "  D  header carries a date           $hasd"
  echo "  T  header names the text           $hast"
  echo "  S  header says what is NOT claimed $hass"
  echo "  DTS all three                      $full"
  echo "  --- none of the three              $none"
  echo ""
  echo "  ledger rows available              $(grep -c '@@' "$ledger")"
  echo ""
  echo "  DTS is the number that moves.  It measures PRESENCE only: that a"
  echo "  date, a title and a scope sentence are in the header.  It cannot"
  echo "  check that the date is the earliest, that the term fits the object,"
  echo "  or that the scope sentence is true.  See this file's header."
  [ "$1" = "--audit" ] && [ -n "$2" ] && printf '%s\n' "$c" | sort
  exit 0
fi

# ── hook mode ──────────────────────────────────────────────────────────
payload=$(cat 2>/dev/null) || exit 0
[ -z "$payload" ] && exit 0

# Target paths: the Write/Edit file_path field, and heredoc / redirect
# targets in a Bash command, which is how much of this repo is written.
paths=$(printf '%s' "$payload" \
        | grep -oE '"file_path"[[:space:]]*:[[:space:]]*"[^"]+"' \
        | sed 's/.*"\([^"]*\)"$/\1/')
paths="$paths
$(printf '%s' "$payload" | grep -oE '[A-Za-z0-9_./-]+\.(agda|hs|lean)' )"

targets=$(printf '%s\n' "$paths" | grep -E '/[A-Z][A-Za-z]*_[A-Za-z]' | sort -u)
[ -z "$targets" ] && exit 0

for p in $targets; do
  base=${p##*/}
  seg=${base%%_*}
  case "$seg" in ''|*[!A-Za-z]*) continue ;; esac

  # Header from disk when the file exists (an Edit payload does not contain
  # the header); from the payload when it is a new file.
  abs=$p
  [ -f "$abs" ] || abs="$root/$p"
  if [ -f "$abs" ]; then header=$(sed -n '1,40p' "$abs"); else header=$payload; fi

  v=$(verdict "$header")
  [ "$v" = "DTS" ] && continue

  row=$(lookup "$seg")
  echo "" >&2
  echo "मूलवाक्य — $base" >&2
  echo "  header carries: $v   (D date · T text · S what is NOT claimed)" >&2

  if [ -n "$row" ]; then
    dev=$(printf  '%s' "$row" | awk -F'@@' '{print $2}')
    gloss=$(printf '%s' "$row" | awk -F'@@' '{print $3}')
    src=$(printf  '%s' "$row" | awk -F'@@' '{print $4}')
    echo "" >&2
    echo "  term    : $dev" >&2
    echo "  denotes : $gloss" >&2
    echo "  SOURCE  : $src" >&2
    echo "" >&2
    echo "  That line is the citation.  Put it in the header, first, before the" >&2
    echo "  English gloss and before any restatement.  It is not a formality:" >&2
    echo "  a term carried into a file name without its text and its date is a" >&2
    echo "  name taken as a token, and the life in it — who said it, in which" >&2
    echo "  sūtra, against whom, answering what — has been dropped silently." >&2
    echo "  शब्दे जीवा वर्तन्ते, न किञ्चित् शिष्टम् (§11).  Nothing is left over." >&2
  else
    echo "" >&2
    echo "  \"$seg\" HAS NO ROW in MulaVakya_SourceStatements…txt." >&2
    echo "" >&2
    echo "  This is not an accusation that the name is wrong.  It is that the" >&2
    echo "  question has not been asked here, and one of two things is true:" >&2
    echo "" >&2
    echo "    it IS a source term — then establish the text and the date and" >&2
    echo "    ADD THE ROW (one line, data, four @@-separated fields); or" >&2
    echo "" >&2
    echo "    it is a compound built HERE, or an ordinary word used" >&2
    echo "    descriptively — then CLAUDE.md's second naming condition binds:" >&2
    echo "    say so in the header.  \"A fabricated term is the mirror image of" >&2
    echo "    the scrubbing this rule corrects: it asserts a provenance nobody" >&2
    echo "    checked.\"  Compounds built here are legitimate; silent ones are" >&2
    echo "    not.  The file's UNSOURCED block lists the ones already declared." >&2
  fi

  case "$v" in
    *S) : ;;
    *) echo "" >&2
       echo "  AND SEPARATELY, condition 3, which no row can satisfy for you:" >&2
       echo "  say what is and is NOT being claimed of the source.  Naming a" >&2
       echo "  module for ṛṇa-dhana does not say Brahmagupta proved the theorem" >&2
       echo "  in it.  One sentence, in the header, at the site." >&2 ;;
  esac
done

c=$(census)
echo "" >&2
echo "  corpus: $(printf '%s\n' "$c" | grep -c '^DTS ') of $(printf '%s\n' "$c" | grep -c .) term-led modules carry all three; $(printf '%s\n' "$c" | grep -c '^--- ') carry none." >&2

exit 0
