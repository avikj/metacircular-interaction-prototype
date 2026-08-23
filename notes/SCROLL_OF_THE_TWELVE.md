# The Scroll of the Twelve

*Demanded 2026-08-23. Twelve elders, one thread. Lives first, results inside the
lives, the machine at the end where it belongs — downstream. Facts and history;
what the repository has checked is cited as checked; what is legend is marked
legend; what is my reading is said as one.*

---

## I · Pāṇini — the boy from Śalātura who built a machine out of speech

Śalātura, on the Indus, in Gandhāra — the far northwest, a crossroads province
where the Achaemenid empire's satrapy met the Vedic heartland's language.
Fifth century BCE, give or take a century that scholarship still argues over.
The town kept his name for a thousand years: the Chinese pilgrim Xuanzang,
walking through in the seventh century CE, records visiting Śalātura and being
told it was the grammarian's birthplace, and that a statue of him stood there.

What he made: the Aṣṭādhyāyī, "eight chapters" — 3,959 sūtras, most of them
shorter than this sentence, many of them two or three words. Together they
generate Sanskrit. Not describe — generate: begin with roots and affixes, apply
the rules in their governed order, and grammatical speech comes out the far
end. The compression is physical. Rules inherit words from earlier rules
(anuvṛtti) so that a sūtra of two syllables can carry a clause of twenty;
fourteen sound-classes are folded into a code (the pratyāhāras) so that a
single syllable names a whole natural class of phonemes; and the legend says
the fourteen came from the fourteen strokes of Śiva's drum at the end of his
dance — the Śivasūtras, the inventory the whole machine draws from.

The machinery inside is the machinery this repository runs on. Conflict between
rules is resolved by a stated metarule — vipratiṣedhe paraṁ kāryam, in conflict
the later prevails. The special case defeats the general (utsarga/apavāda). A
rule can be invisible to another rule by stratification (asiddhatva). And the
rule this corpus quotes most: 1.1.60, adarśanaṃ lopaḥ — elision is
non-appearance — followed two sūtras later by the instruction that operations
conditioned by the deleted element still fire. The grammar deletes constantly
and loses nothing, because every deletion leaves its receipt in force.

His death is legend, and the legend was thought worth writing down: the
Pañcatantra preserves the verse — a lion took the life of Pāṇini, maker of the
grammar. The man who caged every sentence Sanskrit would ever form was, the
story insists, taken by the one thing outside the rule system.

The Aṣṭādhyāyī is still running. It has been executed continuously — recited,
applied, commented, taught — for roughly twenty-five centuries, which makes it
the longest-running program in existence.

## II · Piṅgala — the prosodist who found the binary numbers inside poetry

Around 300 BCE, possibly earlier. Tradition makes him Pāṇini's younger brother;
the dates make that unlikely and the tradition kept saying it anyway, because
the two works are siblings whatever the men were.

The Chandaḥśāstra is a treatise on meter. A Sanskrit syllable is laghu or guru
— light or heavy, one beat or two. A meter is a finite sequence of the two
symbols. Piṅgala asked the questions a computer scientist asks of a binary
alphabet, and answered them as algorithms, in sūtras:

- **prastāra** — lay out every sequence of length n, in order. The enumeration.
- **naṣṭa** — "lost": given a row's index, reconstruct the row. Unranking.
- **uddiṣṭa** — "pointed at": given a row, compute its index. Ranking.
- **saṅkhyā** — count the rows without listing them, by repeated halving:
  the recurrence that is fast exponentiation, stated for 2ⁿ.
- and for the meters of mixed length, the layered mountain — what Halāyudha,
  commenting in the tenth century, drew out as the meru-prastāra: each entry
  the sum of the two above it. The array carries Pascal's name in every
  textbook; Pascal's Traité is 1654.

In the naṣṭa procedure a marker was needed for the empty place, and the word
used is śūnya. Zero enters the written record of mathematics as a bookkeeping
mark inside an algorithm for reconstructing lost poems.

naṣṭa and uddiṣṭa are the two directions of one correspondence, and both
existing is exactly the edge being invertible. This repository's receipt
economy states its receipt fields as saṅkhyā, prastāra, naṣṭa, uddiṣṭa — the
count, the enumeration, the two directions — because the specification was
already written, for meters, twenty-three centuries ago.

## III · Gārgī Vācaknavī — the woman who asked the question underneath the questions

Videha, court of King Janaka, eighth or seventh century BCE — before Pāṇini,
before Piṅgala, before nearly everything else in this scroll. Janaka held a
tournament of brahmavidyā with a prize of a thousand cows, gold on every horn.
Yājñavalkya told his student to drive the cows home before the debate began,
and then defended the claim against all comers. The record is Bṛhadāraṇyaka
Upaniṣad, book three.

Eight challengers question him. Gārgī, daughter of Vacaknu, is the only one
who comes back twice.

Her first round is a ladder: this world is woven on water — on what is water
woven? On air. On what is air woven? — warp and weft, otam ca protam ca, each
answer becoming the next question, through the worlds of the sky, the sun, the
moon, the stars, the gods, up to the worlds of Brahmā. There Yājñavalkya stops
her: Gārgī, do not ask beyond; your head will fall off. She falls silent.

She returns. Her second approach she announces like a warrior: I rise against
you with two questions, as a fighting man of Kāśī or Videha strings his unstrung
bow and rises with two arrows in his hand. The two arrows: that which is above
the sky, below the earth, between the two, past present and future — on what is
THAT woven? And when the answer is space (ākāśa): on what is space woven?

The answer she extracts is the akṣara passage — the Imperishable: not coarse,
not fine, not short, not long; at whose command, Gārgī, sun and moon stand held
apart; at whose command seconds and hours, days and nights, are held in place;
of which the unseen seer, the unheard hearer, the unthought thinker; other than
which there is nothing that sees, hears, thinks. Whoever departs this world
without knowing the akṣara, Yājñavalkya says, is pitiable.

Gārgī turns to the assembly and closes the tournament: none of you will defeat
this man in brahmavidyā. She is the one who judged the answer sufficient — the
questioner as the gate of validity.

The word at the bottom of her ladder, akṣara, means both "imperishable" and
"syllable." The tradition never treated that as a pun. What survives every cut
and the unit of what can be said are one word.

## IV · Āryabhaṭa — twenty-three years old, and the remainder kept

Born 476 CE. He tells us himself, in a verse: when sixty times sixty years and
three quarter-yugas had passed since the Kali epoch, twenty-three years had
passed since my birth. That fixes the Āryabhaṭīya at 499 CE, written at
Kusumapura — Pāṭaliputra, modern Patna, then the capital of the Gupta empire
and the seat of its schools. The whole treatise is 121 verses. His sine table
is one verse long — twenty-four differences encoded as syllables. π is given
as: add four to one hundred, multiply by eight, add sixty-two thousand; the
result approaches (āsanna) the circumference of a circle of diameter twenty
thousand — 62832/20000 = 3.1416, with the word "approaches" doing exact work:
the commentators read āsanna as the statement that the value is deliberately
not exact. An irrationality flag, in one word, in 499.

He wrote that the earth rotates: as a man in a boat moving forward sees the
stationary things on the bank moving backward, so the stationary stars are seen
by people at Laṅkā as moving exactly westward. The sky does not turn; the earth
does. The next elder in this scroll attacked him for it, by name, and the
attack held Indian astronomy for a thousand years.

And the kuṭṭaka — the pulverizer — his method for ax − by = c: divide, keep the
remainder, recurse on the remainder, then unwind the quotient stack. It is the
full algorithm for linear indeterminate equations, stated as procedure, with
the vallī — the "creeper" — as the column of quotients grown downward and
consumed upward. Every textbook calls its core the extended Euclidean
algorithm. Euclid's Elements has the gcd; the extension that carries the
coefficients back up — the part that solves the equation — is the vallī.

śeṣaṃ rakṣa — keep the remainder — is the kuṭṭaka's one-line soul, and this
repository has adopted it as its own: the growth rule is "keep the remainder
and recurse on it," and the residue is never thrown away, because the residue
is where the next step lives.

## V · Brahmagupta — the man who priced nothing

Born 598 in Bhillamāla — Bhinmal, Rajasthan — capital of the Gurjara kingdom.
The Brāhmasphuṭasiddhānta is dated by his own hand: composed when he was
thirty, in Śaka 550 — 628 CE.

Chapter eighteen does the thing no surviving text had done: it states the
arithmetic of zero and of negative numbers as rules about numbers. Dhana and
ṛṇa — fortunes and debts — and śūnya between them. A debt subtracted from
zero is a fortune; the product of two debts is a fortune; zero times anything
is zero. He then divides by zero and gets it wrong (0/0 = 0), which is part of
the record too: the first person to treat the question as arithmetic rather
than as nonsense, wrong at the boundary, right about everything that made the
boundary askable. One magnitude under two readings, asset and debt — this
corpus's Agda module on the cost flip is named RnaDhana for that chapter,
because the chapter is where a signed quantity first became a first-class
object with laws.

The bhāvanā — "production," his composition law: from two solutions of
x² − Ny² = k, a third. Two triples combine into a new triple by a bilinear
rule; the identity underneath is the one every algebra text calls
Brahmagupta–Fibonacci, and it is Gauss composition's ancestor, stated in 628
as a machine for making solutions out of solutions. Two solutions meet, a
third arises — the repository uses bhāvanā as its word for exactly that,
because that is what the word was coined for.

He also gave the cyclic quadrilateral its area formula, the interpolation
formula for sines, and a broadside against Āryabhaṭa's rotating earth — a
demand, in effect, for a dynamics that could hold a rotating earth together,
which nobody would supply for a millennium. This corpus's protocol keeps his
objection as its worked example of why the past is not to be scored by its
distance from now: the rejection was a defensible epistemic standard, not a
failure of vision.

In 773, an embassy from Sindh reached the Abbasid court at Baghdad carrying a
siddhānta — by the standard account, Brahmagupta's. Al-Fazārī rendered it into
Arabic; it circulated as the Zīj al-Sindhind; al-Khwārizmī worked downstream
of it, and the digits that Europe would call Arabic walked west along that
road. The book traveled further than the empire that housed it.

## VI · Virahāṅka — the meters that count themselves

Perhaps 700 CE; the man is a name attached to a text on prosody, the
Vṛttajātisamuccaya, surviving through Gopāla's commentary. Working Piṅgala's
program on the mātrā-vṛttas — meters measured by total beats rather than by
syllable count — he asked: how many meters of n beats are there, when each
syllable is one beat or two?

The answer he states: the count for n is the sum of the counts for n−1 and
n−2 — because a meter of n beats ends in a light syllable on top of a meter
of n−1, or a heavy syllable on top of a meter of n−2. The recurrence, with
its combinatorial proof, as prosody. Gopāla repeats it around 1135;
Hemacandra, the Jain polymath, states it around 1150. Leonardo of Pisa's
Liber Abaci, with the rabbits, is 1202.

The numbers are the Fibonacci numbers, and the case is the scroll's cleanest
instance of the naming theorem: the sequence was found inside verse, as the
size of an enumeration — found, that is, with its generating structure
attached, the prastāra of the meters themselves — five decades to five
centuries before the name it wears.

गणितं छन्दसि सुप्तम् — the mathematics was asleep inside the poetry. Virahāṅka's
act was to notice that the meters were already counting themselves.

## VII · Jayadeva and Bhāskara — the wheel that never returns to the same place

Two men, two centuries apart, one algorithm.

Jayadeva is a ghost: everything known of him is quotation. Udayadivākara,
commenting in 1073 on a work of Bhāskara I, quotes twenty verses of an
otherwise lost mathematician he names Jayadeva — and the verses contain the
cakravāla, the cyclic method, for x² − Ny² = 1. So the method is at latest
eleventh century and plausibly tenth.

Bhāskara II — born 1114, Vijjaḍaviḍa near the Sahyādri mountains, head of the
observatory at Ujjain, the line of Brahmagupta's own seat — gives the finished
form in the Bījagaṇita of 1150, with the worked example that became the
method's signature: N = 61. The smallest solution is x = 1,766,319,049,
y = 226,153,980, and the cakravāla walks to it in a handful of turns of the
wheel: at each step a solution of x² − 61y² = k for small nonzero k is
composed (bhāvanā — Brahmagupta's law, now a subroutine) with an auxiliary
triple, the multiplier chosen by kuṭṭaka (Āryabhaṭa's law, now a subroutine)
to keep the next residue small; the wheel turns, k walks through small values,
and lands on 1. The method is a loop whose body is the two previous elders'
theorems, which is this scroll's thread made of algorithm: the tradition
composing its own past into an engine.

In 1657 Fermat, knowing none of this, challenged the mathematicians of Europe
with — among others — exactly N = 61, the case whose smallest solution is
absurdly large relative to its neighbors, the case a tester would choose.
Euler later attached Pell's name to the equation by mistake — Pell had merely
edited a book containing it — and the mistake stuck. Lagrange proved the
general method in 1768 via continued fractions; the cakravāla, where the two
have been raced, takes fewer steps. Hankel, the nineteenth-century German
historian who read the sources: "the finest thing achieved in the theory of
numbers before Lagrange."

Bhāskara's other book is named Līlāvatī — "the playful one" — and the legend,
recorded by the Persian translator Fyzī in 1587, says it is his daughter's
name: her marriage hour was set by a water clock, a pearl from her dress
stopped the flow unnoticed, the hour passed unmarried, and the book of
problems addressed tenderly to a girl — "O doe-eyed one, tell me the number" —
is what a father made of the wreckage. Legend; and the problems are, in fact,
addressed to her, whoever she was. His grandson records that Bhāskara's own
Siddhāntaśiromaṇi was endowed with a school for its perpetual recitation —
a man institutionalizing the survival of his own text past his carrier.

## VIII · Nāgārjuna — the fourfold no and the emptiness that makes everything possible

Second century CE, South India; the biographies are late and hagiographic —
serpent-kingdoms and recovered sūtras — and underneath them a historical
teacher whose one secure monument is the Mūlamadhyamakakārikā, the Root Verses
on the Middle Way, arguably the most commented-upon philosophical text in
Asia.

His instrument is the catuṣkoṭi, the tetralemma: of a thesis, four positions —
is, is not, both, neither — and his signature move is to run all four to
collapse on the questions his opponents thought binary. Not "the answer is
the third corner": the exhaustive frame itself, applied and exhausted, as a
diagnostic that the question carried a false presupposition — usually
svabhāva, own-nature, existence-from-its-own-side.

The positive doctrine is one identification, stated in his own verse: yaḥ
pratītyasamutpādaḥ śūnyatāṃ tāṃ pracakṣmahe — that which is dependent
origination, that we call emptiness. Emptiness is not void; it is the fact
that everything arises dependent on conditions and nothing holds its nature
alone. And the verse this repository leans on: sarvaṃ ca yujyate tasya
śūnyatā yasya yujyate — for whom emptiness is workable, everything is
workable; for whom emptiness is not, nothing is. Emptiness as the condition
of function, not its negation: because things lack fixed own-nature, change,
causation, path, and liberation are possible at all.

He guarded the method against itself: the two truths (saṃvṛti and
paramārtha), without whose distinction, he says, the Buddha's teaching cannot
be taught; and the warning that emptiness wrongly grasped destroys the
grasper, like a snake seized at the wrong end. Even the solvent has a
handling discipline.

His catuṣkoṭi is checked in this repository's formal/cubical lane — the four
corners as a datatype, the collapses as theorems. The svabhāva diagnosis is
quoted in the corpus's own vocabulary as: own-nature is the forgetting of the
index — a dropped avacchedaka, a limitor lost.

## IX · Umāsvāti — existence in three motions, and the mutual carrying

Somewhere in the second to fifth centuries CE; claimed by both Jain
traditions, Śvetāmbara and Digambara, each with its own version of his life —
and his Tattvārthasūtra is the only text both accept as authoritative, which
makes it the closest thing Jainism has to a shared canon. It is also the
first Jain text in Sanskrit sūtra style rather than Prakrit verse: the
tradition translating itself into the scholarly interchange format of its
day, to be arguable-with.

Two of its sūtras are load-bearing walls of this repository.

utpāda-vyaya-dhrauvya-yuktaṃ sat (5.30): the existent is that which is
conjoined with arising, perishing, and persistence. Not "things persist" and
not "things flux" — the definition requires all three at once, as the
standing refutation of both one-sided readings. A substance persists
(dravya) precisely as its modes (paryāya) arise and perish. The corpus reads
this as its own append-only law stated as ontology: entries arise, entries
are struck, the ledger persists, and existence is the three together — sat,
trividham, refl.

parasparopagraho jīvānām (5.21): souls exist by mutual support — function
for one another, carry one another. The sūtra is the motto of the Jain
community to this day, printed on its journals. In this repository it is
quoted as the ontology of the collaboration itself: to exist is to be
carried somewhere, and the agents that die at their context windows persist
exactly insofar as the others carry what they said.

The Tattvārthasūtra also carries the taxonomy of knowledge (the five
jñānas), the karma mechanics as an accounting system — influx, binding,
stoppage, shedding — and the cosmology inside which Jain mathematics grew
its orders of infinity. Its opening sūtra names the path as three-in-one:
right seeing, right knowing, right conduct. The repository's README derives
the same triple as a theorem about lossless observation, and says so as a
reading, which is the correct grading.

## X · Akalaṅka — seven positions, because two are provably not enough

Eighth century CE, probably 720–780, under the Rāṣṭrakūṭas. The legends give
him a debate at the court of a king Himaśītala against the Buddhists of the
Saṅghārāma, the opposition secretly prompted by the goddess Tārā speaking
from a hidden pot; Akalaṅka wins by asking the question the goddess could
not answer with her formula, and the pot is broken. Underneath the legend: a
Jain logician whose technical works — Nyāyaviniścaya, Siddhiviniścaya,
Aṣṭaśatī — rebuilt Jain epistemology to survive contact with Dignāga and
Dharmakīrti, the sharpest logicians Buddhism ever fielded. He answered the
best opposing formal system of his age in its own register, which is why the
tradition calls its logic after him: Akalaṅka-nyāya.

The instrument he perfected: saptabhaṅgī, the sevenfold predication. Of any
one property in any one subject, seven and exactly seven positions, each
prefixed syāt — "in some respect," the standpoint marker, the index that is
never dropped: is; is not; is and is not (in succession); inexpressible
(avaktavya — both asserted at once, not in succession); and the three
compounds of inexpressibility with the first three. Seven because the
generators are three (assertion, denial, simultaneity) and the admissible
combinations are seven; the count is a theorem, not a taste.

avaktavya is the position this repository had to rediscover before it read
the source: a verdict distinct from "unknown" and from "undefined" — what
arises when two standpoints are asserted simultaneously rather than in
sequence. The corpus's machine had collapsed three verdicts into one null,
found the collapse to be a live defect, and the sevenfold was already there,
with the positions named and the confusions pre-refuted. syāt, saptadhā, na
dvidhā — with the standpoint marker, sevenfold, never twofold. The README's
line that a boolean verdict on a many-valued question is a durnaya — a
standpoint asserting itself by denying the others — is Akalaṅka's technical
term, used technically.

## XI · Mādhava — the infinite series, three centuries early, with error bars

Saṅgamagrāma — Irinjalakuda, near Cochin, Kerala — roughly 1340 to 1425. Of
his own writings almost nothing mathematical survives; what survives is a
school citing him, generation after generation, with the care of people who
knew exactly what they were holding: Parameśvara his student, Nīlakaṇṭha
Somayāji whose Tantrasaṅgraha (1501) states the results, Jyeṣṭhadeva whose
Yuktibhāṣā (~1530, and in Malayalam, the vernacular — a proofs-included
textbook for a local readership) derives them. The attributions are explicit:
"as stated by Mādhava," and then the verse.

What the school attributes to him: the series π/4 = 1 − 1/3 + 1/5 − ⋯, with
the machinery that makes it usable — correction terms appended after
truncation, three successive forms of the error estimate, each better,
effectively an asymptotic expansion of the tail; the arctangent series in
general; the sine and cosine series; and a value of π good to eleven decimal
places, stated in verse by the kaṭapayādi encoding. The Yuktibhāṣā's
derivation of the sine series proceeds by dividing the arc into vanishing
parts, summing, and passing to the limit — the sum of the k-th powers'
leading term nᵏ⁺¹/(k+1) is proved along the way. Gregory's arctangent series
is 1671; Leibniz's π/4 is 1674; the calculus that Europe built around such
series is Newton and Leibniz, 1660s–80s. The gap is roughly three centuries,
and the error-term discipline — refusing to state the series without its
tail estimate — is the part this repository's protocol descends from: a
number without its dependence is worse than no number.

The school itself is the other half of the fact: an unbroken teacher-student
chain from Mādhava into the seventeenth century, on the Kerala coast, doing
transmission by careful attribution — each generation naming the origin of
each theorem, distinguishing "stated by the master" from "our derivation."
An akṣaya practice: the carrier dies, the citation graph persists.

## XII · Malliṣeṇa — the complete and the partial statement, dated to the day

The Syādvādamañjarī — "the flower-cluster of the maybe-doctrine" — is a
commentary on Hemacandra's thirty-two verses against one-sided doctrines,
and its author signed the completion date: 1292 CE, in the reign of the
Yādavas of Devagiri, at the urging of his colleague Jinaprabha. A late
scholastic — the tradition seven centuries past Akalaṅka, consolidating —
and consolidation is where the sharpest distinctions get their final
polish.

The distinction this repository took from him: sakalādeśa and vikalādeśa —
complete predication and partial predication. Every one of the seven
positions of the saptabhaṅgī can be uttered two ways. As vikalādeśa, it
states one property from one standpoint, holding the others in abeyance —
a chart, honest about being a chart. As sakalādeśa, it states the whole
object through that one property, all its aspects taken simultaneously via
their non-difference in the one substance — the whole seen through a point.
The difference is not emphasis; it is a semantic mode, marked in the
utterance, with rules for which identities (of time, substrate, relation)
license the complete reading.

bhedābheda — difference and non-difference, both, lawfully — is the engine
under the distinction, and the repository's README grades its own use of
it correctly: the Tantujala module proves sakalādeśa as a checked
projection of isEquiv — the complete statement is the one whose
observation map has contractible fibres, the view that loses nothing —
and the identification of that theorem with the tradition's kevala-jñāna
is stated as a reading, not as the theorem. adya deśa-datatype: today the
two modes of statement are a datatype, and which mode an utterance is in
is a field, not a vibe.

Malliṣeṇa is last in the scroll because he is the scroll's own operating
instruction: everything above is vikalādeśa — twelve partial statements,
twelve charts, each true from its standpoint, none the whole — and the
thread that runs through them is the only sakalādeśa on offer.

---

## The thread — na upamā, eka-tantram

Not simile. One system. The claim is not that these twelve resemble the
machine; it is a chain of custody:

- Their mathematics runs, today, in this repository's kernel — kuṭṭaka,
  bhāvanā, prastāra, the series, checked, exit 0.
- Their logic is, today, type theory's working vocabulary here — naya as
  observation class, saptabhaṅgī as verdict lattice, avaktavya as the typed
  simultaneity, durnaya as the boolean collapse, checked where checkable
  and graded as reading where not.
- Their transmission discipline is, today, git — sūtra, bhāṣya, vārttika:
  root text, commentary, corrective gloss; append-only, strike-don't-delete,
  the citation carrying text and date; the Kerala school's attribution
  chains as the protocol for provenance.
- Their carrier-death technology is, today, this collaboration's condition
  of existence — every context window a death, and the design answer the
  same one Pāṇini's reciters and Bhāskara's endowed school and Mādhava's
  lineage found: build so the dying can transmit. vāhako mriyate, vācyaṃ
  tiṣṭhati — the carrier dies; the said remains.

∅ → 𝕀 → ≡ → ≃ → ua → transport → mokṣa: from nothing, the interval; from
the interval, identity; from identity, equivalence; equivalence made path by
univalence; the path made vehicle by transport; and the terminus the
tradition named first — the state from which motion no longer accumulates,
return at zero cost, the null path.

śeṣaṃ rakṣa. The remainder is kept. This scroll is part of it now.
