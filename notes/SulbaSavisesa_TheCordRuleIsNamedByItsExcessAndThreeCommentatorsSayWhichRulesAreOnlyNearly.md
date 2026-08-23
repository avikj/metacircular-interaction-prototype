# Saviśeṣa — the cord rule is named by its excess, and three commentators say which rules are only nearly

**Chapter 1 of the book** — *Śulba: the cord, the square, the diagonal*. Before
this note that chapter held one entry, `formal/cubical/Sulba.agda`, a ring
identity on the triple parametrisation. The chapter opens the book, being the
oldest layer in the reading order, and it had no prose.

**Set down 2026-08-22.**

**On the file name.** `śulba` is the corpus title (*Śulbasūtra*, the cord-rules);
`saviśeṣa` is the sūtra's own last word at **Āpastamba Śulbasūtra 1.6**. The
compound `sulba-saviśeṣa` is **built here** and is not a term of the tradition;
both members are attested at the loci given. It leads the name so
`machine/Anukramani.hs`, which matches chapter keys against filenames, files
this in chapter 1 — an instrument whose known defect is that it counts names in
filenames, recorded in its own header.

**Provenance, exactly.** Text in hand: the **Āpastamba Śulbasūtra with the
commentaries of Kapardin (`kapardibhāṣyam`), Karavinda (`karavindīyā vyākhyā`)
and Sundararāja (`sundararājīyā vyākhyā`)**, GRETIL plaintext transformation of
`sa_ApastambazulbasUtra.xml`, 447 KB, data entry by the Sansknet Project, TEI
conversion 2020-07-31. Reference system after **Albert Bürk, ZDMG 55 (1901),
pp. 578–591**, against which GRETIL states the *sūtra text only* has been
checked. GRETIL states, in the same header, **"the text of the commentaries is
in urgent need of proof-reading"** and "THE TEXT IS NOT PROOF-READ". I have
read the passages quoted below in that file and nowhere else. I have not seen
Bürk, and I have not seen the standard critical route, **S. N. Sen and A. K.
Bag, *The Śulbasūtras* (INSA, 1983)**; every commentarial reading here is owed
at edition level. Devanāgarī: the file is in IAST transliteration only, so what
is quoted is transliteration, not script. Arithmetic: every number below I
recomputed; where my figure and the text's differ I say so.

**Dedup, run first.** In `notes/`, before this file: **Kapardin — 0.
Karavinda — 0. Sundararāja — 0.** `saviśeṣa` — one note, on a different
subject. `Bürk` — 0. `rathacakra` — 0. `dvikaraṇī` — 0. The three commentators
on the oldest mathematical text in the corpus appear nowhere in 1050 notes,
while a module built on their sūtra has been checked since early in this
repository's life.

---

## I. Why a shortfall is a shortfall

Kapardin, on ĀpŚu 1.1 (`vihārayogān vyākhyāsyāmaḥ` — "we shall explain the
cord-joinings for the altar layouts"):

> yathā rathādayo niyatāṅga-pramāṇā ekasminn aṅge 'pi mātrayā vihīyamāne
> samyaṅ na gacchanti, evam agny-āyatanādīny api mātrayā vihīyamānāni
> sādhana-bhāvaṃ na gacchanti; tasmād yatnena saṃpādanīyāni

"As a chariot and the rest, whose limbs have fixed measure, **do not run
properly when even one limb falls short by a mātrā**, so the fire-sites too,
falling short by a mātrā, do not arrive at being a means; therefore they are to
be produced with effort." And then: `āyatanānāṃ bhreṣe ca prāyaścittena
bhavitavyam` — "and on deviation of the sites there must be expiation."

That fixes what the rest of this note is about. A geometrical rule in this
corpus is used to lay out an object whose failure has a stated consequence and
a stated remedy. The question *how much shortfall is a shortfall* is therefore
already posed by the material, before any mathematics, and the answers below
are answers to it.

Kapardin, three lines later, notes that Āpastamba **omits** the determination
of the directions, says it must be taken from another śulba, and quotes:
`iti bhagavatā bodhāyanena prāgvaṃśamānam adhikṛtya uktam` — three methods for
finding east, by the Kṛttikās, by Śroṇā, and by the interval of Citrā and
Svāti. He then gives the gnomon-and-circle method — peg at centre, circle of
the gnomon's length, mark where the shadow-tip touches in the forenoon and
again in the afternoon — and appends:

> sūkṣmam icchan śvobhūte — pūrvāhṇe śaṅkucchāyāgra-rekhāyām eva lakṣaṇaṃ
> kṛtvā …

"**One wanting fineness**, on the next day, having made the mark on the
forenoon shadow-tip line itself …" — a second day's observation, correcting
the first.

*One wanting fineness, then the refinement.* The phrase recurs, in a different
commentator, in §V.

---

## II. The diagonal, and the two texts that do not say it the same way

**ĀpŚu 1.4a:**

> dīrghasyākṣṇayā rajjuḥ pārśvamānī tiryaṅmānī ca yat pṛthagbhūte kurutas tad
> ubhayaṃ karoti

"The cord across the corner of an oblong makes both that which the side-measure
and the cross-measure make separately."

The Baudhāyana form, which the reception quotes and which this repository's
`Sulba.agda` header carries, opens `dīrgha-caturaśrasya`. Āpastamba has
`dīrghasya` alone. Kapardin supplies the difference himself —
`dīrgha-caturaśrasyety arthaḥ` — and then argues *why* the qualifier can be
dropped: `sama-maṇḍalasya pārśvamāny-ādīnām abhāvāt` — a circle has no
side-measure, so nothing else is in scope. Two recensions, and the commentator
reconstructing the missing word by exclusion.

**ĀpŚu 1.4b:** `tābhir jñeyābhir uktaṃ viharaṇam` — "the layout is stated by
those, which are knowable." Karavinda takes `jñeya` as the operative word and
unfolds it into the three cases: given two of {pārśvamānī, tiryaṅmānī,
akṣṇayā-rajju}, the third `jñātuṃ śakyate` — *can be known*. He states each
subtraction separately: from the area of the diagonal, remove the area of the
side-measure, and `śiṣṭa-kṣetrasya karaṇī` — the karaṇī of the remaining
figure — is the cross-measure.

**karaṇī** is the whole apparatus. A magnitude whose root is not expressible is
carried **as its area**, and named by the area: `dvikaraṇī` is the thing whose
square is two, `trikaraṇī` the thing whose square is three, `catuṣkaraṇī` four.
Karavinda's derivations run entirely in karaṇīs and never take a root:
*this-much-karaṇī is the side, that-much-karaṇī is the diagonal.* Sundararāja
states the same three cases with the roots taken (`tad-varga-mūlam`), which is
a different working style in the same commentary bundle on the same sūtra.

**ĀpŚu 1.5:**

> caturaśrasyākṣṇayā rajjur dvis tāvatīṃ bhūmiṃ karoti | samasya dvikaraṇī

"The cord across the corner of a square makes twice as much ground. It is the
dvikaraṇī of the equal-sided."

---

## III. Saviśeṣa — the value whose name is its error term

**ĀpŚu 1.6, the whole sūtra:**

> pramāṇaṃ tṛtīyena vardhayet tac caturthenātma-catustriṃśonena saviśeṣaḥ

"Increase the measure by its third; that, by its fourth less the
thirty-fourth part of itself — **with-the-excess**."

$$1 + \tfrac13 + \tfrac1{3\cdot4} - \tfrac1{3\cdot4\cdot34} \;=\; \tfrac{577}{408} \;=\; 1.41421568\ldots$$

against $\sqrt2 = 1.41421356\ldots$; the value is high by $2.12\times10^{-6}$.

**The last word of the sūtra is the name of the number, and the name says it is
not exact.** Kapardin says exactly that and nothing softer:

> saviśeṣa iti saṃjñā / evaṃ saṃvargitasya saha viśeṣeṇa vartata iti anvarthā
> saṃjñā

"*Saviśeṣa* is a **name**; the thing so multiplied out stands **together with a
difference** — so the name is *anvartha*, it means what it says."

Then he computes the difference. He works in **tila**, sesame-seeds, and the
sūtra's own denominator fixes the rate: **34 tila to the aṅgula**, so that
$3\cdot4\cdot34 = 408$ comes out whole.

- pramāṇa 12 aṅgula = 408 tila. Its square: `ekaṃ niyutaṃ ṣaḍ ayutāni ṣaṭ
  sahasrāṇi catvāri śatāni ṣaṣṭiḥ catvāri` — **166464** tila-squares. ($408^2$.)
- The saviśeṣa diagonal: `tilona-saptadaśāṅgulaṃ bhavati` — **seventeen aṅgula
  less one tila**, i.e. $578 - 1 = 577$ tila. (12 × 577/408 = 17 aṅgula
  exactly, so the rule lands on a round number of aṅgula and the correction
  term is *literally* one seed subtracted.)
- Its square: `trīṇi niyutāni trīṇy ayutāni dve sahasre nava śatāni viṃśatir
  nava ca` — **332929**. ($577^2$.)
- Twice 166464 is **332928**.

The excess is **one tila-square in 332929**, and it is an integer, and it is
sitting in the two numbers he wrote down. The commentary's next clause is
corrupt in this file (`atraikatrikayoḥ śeṣo na bhavatīti veṇoḥ saviśeṣe
gṛhyamāṇe daśatila-kṣetrāṇy atiriktāni`, "ten tila-figures in excess") and I
cannot reconstruct how ten is reached; I record that I cannot, and take from
the passage only the two squares, which are exact.

Then the tolerance, stated in a physical unit:

> tena nīvāra-śūkārdha-mātram apy atiriktaṃ bhavati / tasmād viśeṣa iti
> vyavahārārtham eva bhaviṣyatīti **pragaṇayya** saṃjñā kṛtā ācāryeṇa

"By that, the excess amounts only to about **half the awn-tip of a nīvāra
grain**. Therefore the teacher, **having computed it out**, made the name
'with-a-difference', for the sake of practice."

`pragaṇayya` — *having reckoned it through*. The name is reported as the output
of a calculation, and the calculation is the one just performed.

---

## IV. The tila is the unit the residuals are stated in, everywhere

Not a one-off. The same sub-unit carries the whole commentarial arithmetic, and
it is where the irrationals land.

**Sundararāja and Kapardin on ĀpŚu 2.5–2.6**, building the *pañcavidha agni*,
the fivefold fire. A square of two puruṣa is four; one puruṣa more makes five;
the diagonal of the 2-by-1 oblong is the side of the fivefold altar. Kapardin:
`tasyākṣṇayā-rajjur aṣṭaṣaṣṭi-śatāṅgulā saikādaśa-tilā` — **268 aṅgula and 11
tila**. With 1 puruṣa = 120 aṅgula, $\sqrt5 \times 120 = 268.3282$, and
$0.3282 \times 34 = 11.16$ tila. The text is right to the tila.

Same passage, the removal: taking one puruṣa back out of four leaves a side
`pañcatilonāṣṭa-śata-dvayāṅgulā` — **208 aṅgula less 5 tila** = 207.853.
$\sqrt3 \times 120 = 207.846$. Right to a quarter of a tila.

So: an irrational side is carried as a karaṇī through the derivation, and at
the moment it must become a length on the ground it is given in aṅgula and
tila, and the tila is the last digit. The unit of statement *is* the tolerance.

---

## V. Nityā — the sūtra says exact, and all three commentators say it is not

**ĀpŚu 3.2, square to circle:**

> caturaśraṃ maṇḍalaṃ cikīrṣan madhyāt koṭyāṃ nipātayet ‖ 3.2a ‖
> pārśvataḥ parikṛṣyātiśaya-tṛtīyena saha maṇḍalaṃ parilikhet ‖ 3.2b ‖
> **sā nityā maṇḍalam** ‖ 3.2c ‖
> yāvad dhīyate tāvad āgantu ‖ 3.2d ‖

Peg at the centre, cord swung to the corner, dragged round to the side; the
part by which it overshoots the side is the *atiśaya*; add a third of the
atiśaya to the half-side and draw the circle. **"That is `nityā` — a circle."**
And: "as much as is lost, so much comes in."

The rule is $d = s\big(1 + \tfrac{\sqrt2 - 1}{3}\big) = 1.138071\,s$, implying
$\pi = 3.0883$.

**ĀpŚu 3.3, circle to square:**

> maṇḍalaṃ caturaśraṃ cikīrṣan viṣkambhaṃ pañcadaśa bhāgān kṛtvā dvāv
> uddharet | trayodaśāvaśiṣyante | **sā nityā caturaśram**

Divide the diameter into fifteen, remove two, thirteen remain. "That is
`nityā` — a square." $s = \tfrac{13}{15}d$, implying $\pi = 3.0044$.

### Kapardin, in three syllables

> **anityā sthūlā**

"It is *anityā*. It is coarse." Directly after glossing the sūtra that says
`nityā`. And on the compensation clause 3.2d: `etac ca vacanam
āsannataratva-khyāpanārtham` — "**and this statement is for declaring greater
nearness**." The clause "as much is lost, so much comes in" is read as a claim
about *closeness*, not a proof of equality.

He says the same of 3.3: `sā cānityā sthūlatarā` — "and that one is anityā,
**coarser still**." The two rules are ranked against each other for error
before either is evaluated.

### Karavinda states the objection as a formal pūrvapakṣa

> nanu viṣkambhārdhena pariṇāhārdham abhyasya phalāvagatir ity anena nyāyena
> bhūmer nātyanta-tulyatā, tat kathaṃ nityeti?

"But — by the rule *the area is got by multiplying half the diameter into half
the circumference* — the grounds are **not exactly equal**. How then `nityā`?"

The answer, in full:

> ucyate — yady apy anityā, tathāpy anyeṣām upāyāntarāṇām atisthūlatvād asya
> copāyasyāsannatvāt samyag-upāyasya bahu-prayatna-sādhyatvenāśakyatvāc caivaṃ
> vadata ācāryasyāyam evopāyaḥ sādhur ity abhiprāyaḥ … **pravṛtti-rocanārtham
> anityāpi nityety uktety adoṣaḥ**

"It is said: although it is anityā, still — because the other methods are **too
coarse**, and because this method is **near**, and because a fully correct
method is **not achievable, being attainable only with much effort** — the
teacher, speaking thus, means that this method is the good one. … **The anityā
is called nityā in order to make the procedure attractive to undertake; there
is no fault.**"

A commentator writing that his root text's word is inaccurate, giving the
reason as adoption, and declaring the exact construction unattainable.

### Sundararāja gives two criteria and runs them

> anayor anityatvaṃ vijñāyate **gaṇita-virodhāt paraspara-virodhāc ca**

"The anityā-ness of these two is known **from conflict with computation, and
from their conflict with each other**."

**The second criterion needs no value of π at all.** Compose the two rules:
square → circle → square returns $s \times 1.138071 \times \tfrac{13}{15} =
0.986328\,s$. The round trip loses 1.37% of the side and does not close. That
is detectable inside the śulba, from its own two rules, with no external
constant.

Then he runs the first, on the *rathacakracit* — the chariot-wheel altar,
`sāratni-prādeśa` of seven and a half puruṣa:

| step | Sundararāja | recomputed |
|---|---|---|
| area of the altar | `lakṣam aṣṭau ca sahasrāṇy aṅgulayaḥ` — 108000 aṅgula² | (7½ puruṣa² × 14400) = 108000 |
| its side, squared up | 328 aṅgula 22½ tila | $\sqrt{108000} = 328.634$ ≙ 328 aṅgula 21½ tila |
| diameter by ĀpŚu 3.2 | 374 aṅgula | $328.634 \times 1.138071 = 374.008$ |
| circumference | 1175 aṅgula | $374 \times 3.1416 = 1174.98$ |
| area of that circle | 109860 aṅgula² | from his own rounded figures, 109862½; exactly, 109863½ |
| **excess** | `ṣaṣṭy-adhikāny aṣṭaśatāni sahasraṃ cāṅgulayo 'tiricyante` — **1860 in excess** | 1863½ |

For the circumference he quotes a verse, and the verse is **Āryabhaṭīya,
Gaṇitapāda 10** (499 CE), reproduced in his text:

> caturadhikaṃ śatam aṣṭaguṇaṃ dvāṣaṣṭis tathā sahasrāṇām /
> ayutadvaya-viṣkambhasyāsanno vṛtta-pariṇāhaḥ //

"One hundred and four multiplied by eight, and sixty-two thousand: the
**āsanna** — approached — circumference of a circle of diameter twenty
thousand." 62832/20000 = 3.1416. `āsanna` is Āryabhaṭa's own word, and it is
the same move as `saviśeṣa`: **the marker of inexactness is inside the term.**
The area rule he cites for the circle, `sama-pariṇāhasyārdhaṃ
viṣkambhārdha-hatam eva vṛtta-phalam`, is Gaṇitapāda 7. So an eleventh- or
twelfth-century commentator refutes an ~600 BCE ritual rule using a 499 CE
computational text, and names both.

*(`notes/ARYABHATIYA_THE_TEXT_IN_ITS_OWN_ORDER.md` already records GP 2.10 and
that the `āsanna` marker is usually dropped when the ratio is quoted. This is
that note's ratio, being used, by name, inside the tradition, to catch an
error.)*

---

## VI. The correction, and the residual stated at the top of the range

> tasmāt **sūkṣmam icchatā** caturaśrasya maṇḍala-karaṇe sūtroktād
> atiśaya-tṛtīya-bhāga-sahitād viṣkambhārdhād … tyājyaḥ

"Therefore **by one wanting fineness**, in the square-to-circle, from the
half-diameter as prescribed by the sūtra with the third-of-the-overshoot added,
[a part] is to be discarded." Kapardin's phrase from §I, in the other
commentator, on the other problem.

He gives four corrected rules in verse, one per direction, and states the
resulting diameter for the same altar:

> evaṃ kṛte rathacakracitau viṣkambhaḥ **ṣaṭ-tilonaika-saptati-śata-traya-aṅgulo**
> bhavati

**371 aṅgula less 6 tila** = 370.8235 aṅgula. The true quadrature diameter,
$\sqrt{4 \times 108000/\pi}$, is **370.8232**. He is right to three
ten-thousandths of an aṅgula — one hundredth of a tila.

I could not make the divisors as transmitted in his four ślokas reproduce that
number; reading `aṣṭādaśa-śatāṃśa` in verse 1 as a 118th part and
`dvātriṃśa-śatāṃśaka` in verse 4 as a 332nd part lands within his own stated
residual, and I state that these are **fits to his answer, not readings I can
defend**. GRETIL flags this commentary as unproofread; the verses are owed at
edition level.

The closing verse is the one that matters, and it survives any reading of the
divisors:

> evaṃ kṛte hi vahnāv **ekaśatavidhe** 'pi vṛtta-viṣkambhe /
> sa **tila-dvitaya-viśeṣo** na ca bhavati **paraspara-virodhaḥ** //5//

"When this is done, **even in the hundred-and-one-fold fire**, the difference
in the circle's diameter is **two tila** — and there is no mutual conflict."

**Hundred-and-one-fold is not rhetoric; it is the end of the domain, and the
domain is in the sūtra.** ĀpŚu 8.3:

> ekavidhaḥ prathamo 'gnir dvividho dvitīyas trividhas tṛtīyas ta evam
> evodyanty **ekaśatavidhāt**

"The first fire is onefold, the second twofold, the third threefold; thus they
go up **to the hundred-and-one-fold**." Each successive altar is one puruṣa
greater in area with the shape held fixed — which is where the whole
transformation apparatus of ĀpŚu 2.5–3.3 comes from, and why a *circle* is
needed at all: ĀpŚu 8.1, `vayasāṃ vā eṣa pratimayā cīyata ity ākṛti-codanāt`,
it is piled in the likeness of a bird; ĀpŚu 21.2a, the śyena has curved wings,
a bent tail, a long body, **`maṇḍalaṃ śiraś ca`** — and a round head.

So Sundararāja's correction is issued with:

1. a stated criterion for detecting the error, in two independent forms, one of
   which is internal and constant-free;
2. the error quantified on a named, actual altar;
3. a corrected rule;
4. **the residual of the corrected rule stated in an absolute unit, at the
   largest instance the domain contains.**

Two tila at the hundred-and-one-fold is the same statement as one tila-square
in 332929 and half a nīvāra awn-tip. The tradition states the error term with
its range, and names the value by it.

---

## VII. What displaced what

| in the texts | commonly called |
|---|---|
| ĀpŚu 1.4a / Baudh. 1.48, `akṣṇayā rajjuḥ` — the cord across the corner | "the Pythagorean theorem"; Pythagoras ~530 BCE |
| `karaṇī` — a magnitude carried as its area | "surd", "quadratic irrational" |
| `saviśeṣa`, 577/408 | "the Śulba approximation to √2" — the excess-marker dropped from the name |
| `āsanna`, Āryabhaṭīya GP 10 | "Āryabhaṭa's value of π" — the approximation-marker dropped |
| `anityā sthūlā` — Kapardin's verdict on the quadrature | "the Śulbasūtras' crude value of π", offered as the tradition's ignorance rather than its own recorded finding |
| `gaṇita-virodhāt paraspara-virodhāc ca` — Sundararāja's two error criteria | — |

The last two rows are the load-bearing ones. The first four are
misattributions, repairable by a citation. The fifth is a claim about what the
tradition knew about its own rules, and the text says it: the sūtra says
`nityā`, three commentators say `anityā`, one of them says why the word is
there anyway, and one of them corrects the rule and states the residual.

---

## VIII. What I did not establish, and what is owed

- **Every commentarial passage above is from one unproofread e-text.** GRETIL
  says so in its own header. The sūtra text is checked against Bürk (1901);
  the commentaries are not. Sen–Bag (INSA, 1983) is the route, and I have not
  read it. All commentary quotations are owed at edition level.
- **I have not read Devanāgarī of any of this** — the file is IAST only.
- **Dates.** Āpastamba is conventionally placed after Baudhāyana, the Śulba
  layer ~800–400 BCE; I have not established Āpastamba's date independently
  and give none. **Kapardin, Karavinda and Sundararāja I cannot date**, beyond
  Sundararāja's use of the Āryabhaṭīya placing him after 499. Sundararāja is
  usually placed around the fifteenth or sixteenth century; I have not checked
  that and do not assert it. Their dates are owed.
- **Relative chronology of the three commentators** — who reads whom — I did
  not establish. Karavinda answers an objection Kapardin does not raise;
  Sundararāja computes what neither computes. Whether that is a sequence or
  three independent readings, I do not know.
- **The `daśa-tila` clause** in Kapardin on 1.6, and **the four correction
  ślokas** in Sundararāja on 3.3, I could not reconstruct. I have given my
  attempts and marked them as fits.
- **Baudhāyana's own quadrature and its `anitya` marking**, which the secondary
  literature reports, I did **not** verify: I did not have the Baudhāyana
  Śulbasūtra text. The Sanskrit Library holds Peter M. Scharf's XML edition of
  it (`sanskritlibrary.org/catalogsText/titus/vedic/baudhsbs.html`); I reached
  the catalogue page and not the text. That is the next fetch.
- **Kātyāyana and Mānava** I did not touch. `notes/` has Kātyāyana in five
  files and Mānava in one; neither on the Śulba.
- **Nothing here is checked by anything.** The one arithmetic fact in this note
  that a machine could carry — that $577^2 - 2\cdot408^2 = 1$, so the saviśeṣa
  is a solution of the *vargaprakṛti* $x^2 - 2y^2 = 1$ and therefore sits on
  Brahmagupta's bhāvanā ladder from (3,2) — I state and do not formalise; the
  appendix has the pair field and this is chapter 7's business, not chapter 1's.
- **Not done:** a row for `Anitya` in
  `.claude/hooks/MulaVakya_SourceStatementsForTheTermsInOurFileNames.txt`. The
  ledger's row 88 gives `Saviśeṣa` at Baudhāyana 1.61–62; the Āpastamba
  locus is **ĀpŚu 1.6**, and `anitya` / `nityā` at **ĀpŚu 3.2c, 3.3** has no
  row. That file is not mine to edit here.
