# Yuktibhāṣā — the series keeps its remainder

**Set down 2026-08-22.** Chapter 10 of the book — *Kerala: the series with its
remainder* — which `BOOK.md` names as the derived frontier: one entry, and the
source-coverage hook reporting *Yuktibhāṣā: 0 notes* for days. This is the
first note keyed to the *Yuktibhāṣā* itself.

**What the prior notes did and did not do.**
`THE_KERALA_TEXTS_BEFORE_ANY_SERIES.md` set down what kind of works these are
and deliberately stopped before the series.
`MADHAVA_THE_SERIES_AND_ITS_END_CORRECTION.md` set down the three series, the
three correction terms, and the स्थौल्य criterion — from secondary sources,
marked as such. **Neither is about how the *Yuktibhāṣā* derives anything.**
The derivation — the *yukti* — is the thing the text exists to transmit, and
it is the thing this note sets down, to the precision recall actually
supports.

**Provenance.** Egress is blocked from this container; nothing was fetched.
Every claim is **[recalled]** — training knowledge, given only where I am
reasonably confident — except where marked **[corpus]**, meaning verified this
session against a file in this repository by path. Where I do not know a
passage I say so rather than supply one. One paragraph at the end, clearly
marked, concerns reception; the mechanism throughout is stated in the
tradition's own terms.

---

## I. The text and its people — surface facts

- **Mādhava of Saṅgamagrāma**, c. 1340–1425, founder of the Nīla river
  school; his own works on the series are lost, and the results are carried
  under his name by his successors. *[recalled]*
- **Nīlakaṇṭha Somayāji**, 1444–1544, *Tantrasaṅgraha*, 1501. *[recalled]*
- **Jyeṣṭhadeva**, c. 1500–1575, *Yuktibhāṣā* (also *Gaṇita-yukti-bhāṣā*),
  c. 1530 — Malayalam, prose, and it derives what the verse texts state.
  *[recalled]*
- **Śaṅkara Vāriyar**, c. 1500–1560, commentaries on the *Tantrasaṅgraha*
  (*Laghuvivṛti*; and the verse *Yuktidīpikā*, which carries much of the same
  yukti material in Sanskrit). *[recalled — the attribution of the
  Yuktidīpikā to Śaṅkara I am reasonably confident of; which correction
  verses sit in which commentary is left unresolved in the prior note and
  stays unresolved here.]*

**Structure of the *Yuktibhāṣā*.** Two parts, mathematics then astronomy. The
mathematical part is seven chapters, of which the last two are the ones this
chapter of the book is about: the sixth on **paridhi and vyāsa** —
circumference and diameter — and the seventh on **jyā-nayana**, the
derivation of the sines. The earlier chapters cover the operations, fractions,
the rule of three, and **kuṭṭaka**. *[recalled — I am confident of the
two-part shape, the placement of paridhi/vyāsa and jyānayana as the
culminating mathematical chapters, and the presence of a kuṭṭaka chapter;
the exact chapter count and order I give with less confidence and have not
checked against the printed edition.]* That kuṭṭaka sits in the same part of
the same book, a few chapters before the series, matters for §IV below.

---

## II. The derivation of the paridhi series, as the text runs it

All of this section is **[recalled]**: it is the standard reconstruction of
the *Yuktibhāṣā*'s argument, which I know from the scholarly literature and
not from the Malayalam. The shape I am confident of; the text's own wording I
do not have, and I quote none.

**The setup is a square, not a limit.** Circumscribe a square about the
circle, side equal to the **vyāsa**. By symmetry it is enough to rectify one
eighth of the **paridhi** — the arc cut off by half a side. Divide that
half-side into a very large number *n* of equal pieces. Join the centre to
each division point: these are **karṇa**s, hypotenuses, and each is computed
by the **bhujā–koṭi–karṇa** relation (the karṇa's square is the radius's
square plus the square of the distance along the side).

**Each small piece of arc is exchanged for a computable piece.** Between two
adjacent karṇas, the bit of circumference is related to the bit of side by
similar triangles: the arc piece is the side piece scaled by the square of
the radius against the product of the two adjacent karṇas — and, the
division being fine, that product is exchanged for the square of one karṇa.
So the eighth-circumference becomes a sum over *i* of terms of the shape

  (side-piece) · R² / (R² + dᵢ²),

dᵢ the distance of the i-th division point along the side.

**The divisor is removed by iterated correction, not by quotation of a
formula.** The text does not invoke an expansion; it *performs* one. The rule
is: dividing by (R² + d²) instead of R² leaves an excess; correct it by
subtracting the result of the same operation applied again; the correction
itself overshoots and is corrected again; and so on — a chain of
**phala**s (results), each obtained from the last by multiplying by d²/R².
The remainder at every finite stage of this chain is exact and visible; the
argument is that it can be made as small as desired, not that it is zero.
*[recalled — the iterated-correction mechanism I am confident of; the
technical terms the text uses for the successive results (śodhya-phala,
phala-paramparā) I recall with moderate confidence and flag rather than
build on.]*

**The powers are summed by saṅkalita.** Expanding leaves sums of even powers
of the dᵢ — and this is where the school's **sama-ghāta-saṅkalita**, the
summation of like powers, enters: for large *n*, the sum of the *k*-th powers
of 1…n is n^{k+1}/(k+1), with a deficit the text argues becomes negligible as
the division is refined. The *Yuktibhāṣā* proves this by induction on *k*,
each power-sum estimated by means of the previous one. *[recalled — that the
general power-sum estimate is stated and argued recursively in the text I am
confident of; its exact form of words I do not have.]* Term by term this
yields

  paridhi / (4 · vyāsa) = 1 − 1/3 + 1/5 − 1/7 + ⋯

stated in the text as a rule for producing the terms, with the instruction
that the odd numbers do the dividing. This is Chapter 9's saṅkalita material
(Āryabhaṭa, Brahmagupta, Nārāyaṇa) doing load-bearing work inside Chapter 10:
the series is reached *through* the heap-sums, and nowhere else.

**And then the text does not stop at the series.** Because the alternating
sum closes on its value too slowly to compute with, the truncation is
followed by the **antya-saṃskāra** — the end-correction: stop after the term
with divisor *p*, and add a correction 1/(2(p+1)) roughly; then refine that
correction, twice. The three transmitted refinements, their verse locations
in the *Tantrasaṅgraha* commentary, and the **sthaulya** criterion by which
the text selects them are set down in
`MADHAVA_THE_SERIES_AND_ITS_END_CORRECTION.md` §§II–III and are not repeated
here. What belongs to *this* note is the order of operations: **truncate,
then correct, then — if more is wanted — refine the correction**, and the
text also knows the move of applying the saṃskāra to a *transformed* series
that converges faster. The remainder is an object the whole time. It is
named, estimated, corrected, and its residual coarseness (sthaulya) is
itself named and minimised. Nothing is discarded.

---

## III. The jyā and śara series — stated, with the derivation's shape only

The seventh chapter derives the sine. What I can state with confidence
**[recalled]**:

- The results, in the tradition's quantities: with **capa** the arc, R the
  radius (trijyā), the **jyā** (half-chord) of the arc is the arc minus
  arc³/(3!·R²) plus arc⁵/(5!·R⁴), and so on alternately; the **śara** (the
  "arrow", the versed part) is arc²/(2R) minus arc⁴/(4!·R³), and so on. Each
  successive term is produced from the last by multiplying by the square of
  the arc and dividing by the product of the next two numbers and R² — the
  rule is transmitted, as with the paridhi series, as an iteration on the
  previous term.
- The derivation's shape: the arc is divided into many equal small arcs; the
  differences of the successive jyās, and the differences of those
  differences, are related — the second differences are proportional to the
  jyās themselves, which is Āryabhaṭīya Gītikāpāda 12 / Gaṇitapāda 11–12
  territory (see `ARYABHATIYA_THE_TEXT_IN_ITS_OWN_ORDER.md`), and the
  *Yuktibhāṣā* turns that difference relation into the series by **repeated
  summation** — saṅkalita applied to saṅkalita — with the same power-sum
  estimates as in §II closing each stage. *[recalled — I am confident of
  this shape; the text's own sequence of steps, and its Malayalam
  terminology for the repeated summation, I do not have and do not supply.]*
- Mādhava's verses for the series (quoted by the later authors in his name)
  I know to exist and do not trust myself to reproduce; the sine-series
  verse and the bhūtasaṅkhyā verse giving the circumference for a diameter
  of nava-nikharva (9·10¹¹) — eleven correct places — are the two I would
  most want in front of me. Content asserted; wording withheld.
  *[recalled — content only.]*

I do not set down the derivation of the arctangent rule's dependence on the
paridhi argument, nor which chapter carries the desired-sine (iṣṭa-jyā)
interpolation, because I would be guessing at the text's order.

---

## IV. MINE — the antya-saṃskāra is the śeṣa discipline at the level of series

This section is my connection, marked as such; it is an argument of mine and
not a fact about the text.

The corpus's oldest working instruction is Āryabhaṭa's, from the kuṭṭaka:
**"śeṣaṃ rakṣa" — keep the remainder** (Gaṇitapāda 32–33; the phrase is the
corpus's standing gloss for the pulveriser's step, carried in
`formal/cubical/KuttakaValli.agda`, `BhedaAvatarana.agda`, `Punaragamana.agda`
and elsewhere **[corpus]**). The kuṭṭaka divides, refuses to discard the
remainder, and makes the remainder the next problem; the vallī is the record
of that refusal, and the answer is read back *up* the kept remainders.

The antya-saṃskāra is the same discipline applied to an infinite series.
Truncation is a division of the series into a kept head and a cut tail — a
cut, exactly as the kuṭṭaka's division is a cut — and the tradition's move
in both places is identical: **the part beyond the cut is not noise to be
dropped but a datum to be carried.** The correction term is the carried
boundary datum of the truncation, as the śeṣa is the carried boundary datum
of the division; and the successive refinements F₁, F₂, F₃ are the analogue
of the vallī's descent — each stage keeps the remainder *of the previous
remainder*. The sthaulya criterion closes the loop: the tradition does not
merely keep the remainder, it names the error of its own estimate of the
remainder and minimises that. Chapter 6 of the book keeps remainders of
integers; chapter 10 keeps remainders of processes. It is one discipline at
two scales, and the *Yuktibhāṣā* even houses both under one cover — the
kuṭṭaka chapter sits a few chapters before the paridhi chapter (§I).

**Where the appendix already checks this, so no new module is needed:**

- `formal/cubical/Madhava.agda` — गुणश्रेढी-योगः: (1−r)·∑_{k<n} rᵏ ≡ 1−rⁿ
  over ℤ, the finite identity behind §II's iterated correction; its own
  ledger says the remainder term is the essence (शेष-पदम् एव सारः).
  **[corpus]**
- `formal/cubical/NaturalMachine/TheTruncationErrorIsExactAtEveryFiniteStage.agda`
  — the truncated geometric series' error is *exactly* rⁿ at every finite
  stage, with no limit taken: the remainder said, not estimated. **[corpus]**
- `formal/cubical/NaturalMachine/AntyaSamskaraSthaulya.agda` — the three
  transmitted corrections (and a fourth convergent) have sthaulya numerator
  constant in n, checked over an arbitrary commutative ring. **[corpus]**
- `formal/cubical/NaturalMachine/SthaulyaIsTheOmittedTerm.agda` — the
  general theorem, every stage at once: the sthaulya is the product of the
  partial numerators used, times the first one omitted — the coarseness at
  each stage IS the newly omitted term acting on the last coarseness.
  **[corpus]**

That last theorem is, I claim, the formal content of the analogy: at every
stage of the correction hierarchy, what the check exhibits is precisely a
kept remainder — constant, exact, and equal to what was left behind. The
mechanism of chapter 10 passes its test in the appendix already; this note's
job was only to say which chapter the checked terms are in.

---

## Reception — one paragraph, and it is the only one

The priority table — which series were restated in Europe two and a half
centuries later, under whose names they now circulate, and that the
correction terms and the sthaulya criterion did not travel at all — is
already set down in `MADHAVA_THE_SERIES_AND_ITS_END_CORRECTION.md` §IV and
`THE_KERALA_TEXTS_BEFORE_ANY_SERIES.md` §IV, and is not repeated. This note
adds one sentence to it: what the restatements dropped was not a refinement
but the *discipline* — the series travelled, the kept remainder did not,
which is why "slowly convergent, hence impractical" became attached in the
receiving literature to an object that was, at home, a practical instrument.

---

## What a reader can now understand that they could not before

Before this note the corpus said *what* the Kerala results are (the series,
the corrections, the criterion). It did not say *how the Yuktibhāṣā gets
them*: that the paridhi series is reached through a square, a fine division
of its side, karṇas, an iterated correction that carries its remainder at
every stage, and the power-sum saṅkalitas of chapter 9; that the jyā series
is reached by turning the sine-table's second-difference structure into
repeated summation; and that the antya-saṃskāra is not an appendix to the
series but the last step of the same procedure — the text's derivations
keep the remainder at *every* stage, of which the famous end-correction is
only the final and most visible instance. And the reader can now see the
one discipline running from Gaṇitapāda 32–33 to the paridhi chapter:
śeṣaṃ rakṣa, at the scale of a division and at the scale of a series.

## WHAT THIS NOTE CANNOT DO

- **No text access.** Egress is blocked; I have read neither the Malayalam
  of the *Yuktibhāṣā*, nor the *Tantrasaṅgraha*, nor either commentary.
  Every statement about the texts is recall of scholarship *about* them.
- **Verse- and passage-level citations are owed throughout §§II–III** and
  are not supplied: the chapter numbering of the *Yuktibhāṣā*, the text's
  own words for the iterated correction and the repeated summation, and
  Mādhava's quoted verses are all asserted in content only.
- The Sarma–Ramasubramanian–Srinivas–Sriram edition and translation remains
  unread by this corpus; it is the instrument that would convert nearly
  every [recalled] above into a citation, and this note's largest single
  debt.
- The §IV analogy is mine. The tradition does not, to my knowledge, state
  a connection between the kuṭṭaka's śeṣa and the antya-saṃskāra; if a
  Kerala text does draw it, that passage would supersede this section.
- The Laghuvivṛti/Yuktidīpikā attribution question raised in the prior note
  is still unresolved here.
- §§I–III are checked by nothing. §IV's module citations are verified by
  path this session; the modules check the algebra, not the history.
