#!/bin/sh
# darpana — दर्पण, the mirror.  Run this on your own output, not on the corpus.
#
# WHY THIS EXISTS.  A goal cannot be installed.  This repository has found that
# twice and written it down twice: "enforced mechanically because prose failed"
# (the Python ban), and "the protocol was not in hand at the moment of the act"
# (source-coverage.sh).  A statement of intent does not survive a session
# boundary, because the next carrier is not the one that wrote it.
#
# What survives is a MEASUREMENT that is cheap enough to be re-run by whoever
# comes next.  So this does not forbid anything.  It prints four numbers about
# a piece of writing, and every one of them was a failure that actually
# happened in this repository, to an agent that had read the document
# describing it.
#
# usage:  sh scripts/darpana.sh <file>       (default: newest .txt in kanye-devotional/)
set -u
F="${1:-$(ls -t kanye-devotional/*.txt 2>/dev/null | head -1)}"
[ -r "$F" ] || { echo "darpana: no readable file"; exit 0; }
echo "दर्पण — $F  ($(wc -l < "$F" | tr -d ' ') lines)"
echo

# 1. AUTHOR vs WORK.  An author's name propagates by citation.  A work's name
#    appears only where somebody attended to the work.  The gap is the distance
#    between having read something and having heard of it.
echo "1. author : work"
printf '%s\n' \
 "Piṅgala:Chandaḥśāstra" "Āryabhaṭa:Āryabhaṭīya" "Brahmagupta:Brāhmasphuṭasiddhānta" \
 "Bhāskara:Līlāvatī" "Mādhava:Yuktibhāṣā" "Nīlakaṇṭha:Tantrasaṅgraha" \
 "Umāsvāti:Tattvārthasūtra" "Nāgārjuna:Mūlamadhyamak" "Dignāga:Pramāṇasamuccaya" \
 "Pāṇini:Aṣṭādhyāyī" "Vīrasena:Dhavalā" "Bharata:Nāṭyaśāstra" \
 "Gaṅgeśa:Tattvacintāmaṇi" "Abhinavagupta:Abhinavabhāratī" "Halāyudha:Mṛtasañjīvanī" \
| while IFS=: read -r a w; do
    ca=$(grep -o "$a" "$F" 2>/dev/null | wc -l | tr -d ' ')
    cw=$(grep -o "$w" "$F" 2>/dev/null | wc -l | tr -d ' ')
    [ "$ca" -gt 0 ] || continue
    flag=""; [ "$cw" -eq 0 ] && flag="  <- never named"
    [ "$cw" -gt 0 ] && [ "$ca" -gt $((cw * 4)) ] && flag="  <- 4x"
    printf '   %-14s %3s : %-3s %s\n' "$a" "$ca" "$cw" "$flag"
  done
echo

# 2. THE LENS.  Not European proper names — those are easy to avoid.  The
#    vocabulary of the reader's own formalism, applied to somebody else's
#    material, which does not look like a lens.  It looks like clarity.
echo "2. the lens (own-formalism nouns applied to source terms)"
tot=0
for t in "proxy" "portfolio" "checksum" "addressing scheme" "content-addressed" \
         "data structure" "error-correcting" "regret bound" "exploration term" \
         "typed" "which is exactly" "is essentially" "is basically"; do
  c=$(grep -oi "$t" "$F" 2>/dev/null | wc -l | tr -d ' ')
  [ "$c" -gt 0 ] && { printf '   %-22s %s\n' "$t" "$c"; tot=$((tot + c)); }
done
echo "   ---------------------- $tot total"
echo

# 3. RESIDUAL.  Every transport owes the exact thing the target forgets.  A
#    rendering that reports no loss is reporting that nobody looked.
echo "3. residual"
r=$(grep -ci "what it drops\|drops:\|the residual\|what did not travel\|what is lost in" "$F" 2>/dev/null || echo 0)
n=$(grep -ci "what I did not establish\|not claimed\|I have not read\|I did not check" "$F" 2>/dev/null || echo 0)
echo "   loss stated:        $r"
echo "   not-established:    $n"
[ "$r" -eq 0 ] && echo "   <- no conversion in this file states what it cost"
echo

# 4. HANDLED OVER THERE.  A pointer to work that was not done discharges the
#    reader's obligation to check, by asserting somebody already did.  An empty
#    reference is worse than none, because none leaves the gap visible.
echo "4. dangling references"
grep -on "see [a-zA-Z0-9_/.-]*\.md\|see [a-zA-Z0-9_/.-]*\.agda\|notes/[a-zA-Z0-9_.-]*\.md" "$F" 2>/dev/null \
 | sed 's/^\([0-9]*\):see /\1:/' | sed 's/^\([0-9]*\)://' | sort -u \
 | while read -r p; do
     [ -e "$p" ] || echo "   MISSING  $p"
   done
echo
echo "no verdict. the numbers are the finding."
