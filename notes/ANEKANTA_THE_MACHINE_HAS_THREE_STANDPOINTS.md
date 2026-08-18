# The machine has three standpoints, and its verdict was carrying none of them

**Filed 2026-08-18. Everything below is either a citation, a checked term, or
a count over `machine/machine.log`.**

Verification, with exit codes:

| what | command | result |
|---|---|---|
| `formal/cubical/Saptabhangi.agda` | `LC_ALL=C.UTF-8 agda --safe Saptabhangi.agda` | **EXIT=0**, `--cubical --safe`, no postulates, no holes, no warnings |
| `machine/Obstruction.hs` | `ghc -Wall -fno-code` | **EXIT=0**, no warnings |
| self-tests | `selfTest` | **14/14 ok** (the pre-existing 10, unchanged, plus 4) |
| the census | `runghc -imachine machine/ObstructionCensus.hs machine/machine.log` | **EXIT=0** |

One thing that is *not* green and was not green before this work either:
`formal/cubical/Everything.agda` fails at
`NaturalMachine/PathIsSymmetry.agda:98`, `SymGroup` not in scope — a cubical
library version skew, present on `main`, independent of anything here.
`Saptabhangi` is imported by `Everything.agda` and checks standalone; the
aggregate does not currently check, and `BUILD.md`'s green claim is stale in
this container. Reported, not fixed.

---

## 1. The sources, which are the origin

These are not illustrations attached to a result that was reached some other
way. The structure in §4 is theirs; I found it by reading them.

| doctrine | text | date |
|---|---|---|
| tri-padī: *uppannei vā, vigamei vā, dhuvei vā* — it arises, it perishes, it endures | **Bhagavatī Sūtra** (*Viyāha-pannatti* / *Vyākhyāprajñapti*), 5th Aṅga | pre-CE strata; redacted at Valabhī c. 5th c. CE |
| *pramāṇanayair adhigamaḥ* (1.6); the seven nayas (1.33); *utpāda-vyaya-dhrauvya-yuktaṃ sat* (5.29); *arpitānarpitasiddheḥ* (5.31) | **Umāsvāti, Tattvārthasūtra** | c. 2nd–5th c. CE |
| a naya held *nirapekṣa* is *mithyā*, held *sāpekṣa* is *samyak* (1.21); as many nayas as ways of speaking (1.28) | **Siddhasena Divākara, Sanmatitarka** (Prakrit *Sammai-suttaṃ*) | c. 5th c. CE |
| the saptabhaṅgī as a fixed seven-membered scheme, each member under *syāt* | **Samantabhadra, Āptamīmāṃsā** | c. 6th c. CE |
| the argument that the number is **exactly** seven: three *mūla* predicates, 3 + 3 + 1 | **Akalaṅka, Laghīyastraya / Aṣṭaśatī** | c. 720–780 CE |
| *sakalādeśa* (total statement = pramāṇa) vs *vikalādeśa* (partial statement = naya) | **Mallisena, Syādvādamañjarī** | 1292 CE |

Jain mathematics, cited separately because the combinatorics in §5 is the
same tradition's:

- **Sthānāṅga Sūtra** (*Ṭhāṇaṃga*, 3rd Aṅga): a taxonomy of the mathematical
  disciplines, and the enumeration of kinds of infinity.
- **Anuyogadvāra Sūtra** (*Aṇuogaddārāiṃ*, c. 1st c. BCE–1st c. CE): the laws
  of indices, and the classification of number into *saṃkhyāta* (numerable),
  *asaṃkhyāta* (innumerable) and *ananta* (infinite), each subdivided —
  distinct **orders** of infinity, not one.
- **Vīrasena, Dhavalā** on the *Ṣaṭkhaṇḍāgama* (c. 816 CE): *ardhaccheda*,
  the number of halvings — log₂ — with `ardhaccheda(ab) = ardhaccheda(a) +
  ardhaccheda(b)`. *This is Vīrasena's, not the Anuyogadvāra's*; the two are
  frequently merged in secondary sources and I checked before writing it.

The seven nayas of **Tattvārthasūtra 1.33**, in order:
*naigama* (figurative/teleological), *saṃgraha* (generic), *vyavahāra*
(practical), *ṛjusūtra* (the present mode only), *śabda* (verbal),
*samabhirūḍha* (etymological), *evaṃbhūta* (applying only while the object
performs the function the word names). The first four are *artha-naya*, the
last three *śabda-naya*. **They are not what I formalise**, and §7 says so.

---

## 2. The observation that forced all of this

Two lines of `machine/machine.log`, verbatim, **both round 0**:

```
146  KERNEL-REJECT round=0 x = (xmaxx)  (0 agda calls) cached: x != max x x
     of type ℕ when checking that the expression refl has type x ≡ max x x
174  KERNEL-ACCEPT round=0 x = (xmaxx)  (induction on x, step = cong suc, 1 agda calls)
```

The same claim, in the same round, denied and affirmed. Nothing about the
claim changed between them. What changed is the standpoint: `refl` and
`induction on x` are two different provers, and the log's own tactic
vocabulary lists them side by side —

```
663  trace replay              480  induction on x, step = refl
420  induction on x, step = ih  255  induction on x, step = cong suc
 43  refl
```

`machine/Obstruction.hs` already opens by finding one level of this: the
kernel verdict was a `Bool` collapsing at least three distinct things, and it
replaced the `Bool` with a three-valued type. It stopped one level early.
`Obstruction` is not *what the kernel said*. It is what **one naya** said —
`refl` alone — and the index was nowhere in the type.

Umāsvāti, **TS 5.31**, `arpitānarpitasiddheḥ`: apparently contradictory
attributes are established through the distinction of the **asserted**
(*arpita*) and the **unasserted** (*anarpita*) aspect. That sūtra is the
standpoint index, stated as such, between the 2nd and 5th centuries. Lines
146 and 174 do not contradict; they are *syād asti* and *syād nāsti* of one
claim under two nayas, and the pair of them, taken **krama** (in succession),
is the third bhaṅga.

This is not one anomaly. **35 distinct claims appear in both the accept and
the reject stream** — measured, `machine/ObstructionCensus.hs`.

---

## 3. Avaktavyam, and why it is not "unknown"

This is the part worth getting exactly right, and the part
`formal/cubical/Saptabhangi.agda` §5 checks.

*Syād avaktavyam* is the **fourth** bhaṅga. It arises when *asti* and *nāsti*
are asserted **yugapat** — simultaneously, of one aspect — rather than
**krama**, in succession. It is a **positive predication**: the object really
has this property. It is not a gap, not a third truth value, not "we do not
know yet", and not "neither".

Mallisena's distinction (1292) is what makes this precise. A *vikalādeśa* is
a partial statement — one aspect asserted, the rest left unasserted. A
*sakalādeśa* would present all aspects at once. Predication is
vikalādeśa-shaped: one aspect at a time is all a sentence carries. Avaktavya
is what happens when sakalādeśa is demanded of that medium.

Formalised in `Saptabhangi.agda` §5, and this is the whole design:

- A **profile** is what a claim is prior to any utterance — the verdict of
  every standpoint at once. That is the pramāṇa-level object.
- A **Vacana** is an atom of the language: one standpoint, one polarity.
  That is the vikalādeśa.
- `joint φ = φ rewriter and not (φ kernel-refl)` is the joint content of
  lines 146 and 174.

Then, all checked:

| theorem | says |
|---|---|
| `joint-realised`, `joint-refuted` | both values are realised by explicit profiles — **not unknown**, nothing awaits information |
| `joint-is-both` | where it holds, asti holds *and* nāsti holds — **not "neither"** |
| `krama-expresses` | the **ordered pair** of two Vacanas denotes it exactly |
| `no-single-vacana` | for **every** one of the six atoms there is a profile where it disagrees with the joint content — **no single utterance denotes it** |

Inexpressible in one utterance; expressible in two taken in succession. That
is the difference between the fourth bhaṅga and the third, and it is a
theorem here rather than a gloss.

Also checked, at the level of types (`Saptabhangi.agda` §2): the simultaneous
demand `Yugapat = Σ n. (P n × ¬ P n)` is empty; the successive
`Krama = (Σ n. P n) × (Σ m. ¬ P m)` is inhabited whenever two standpoints
genuinely disagree; therefore `¬ (Krama ≡ Yugapat)` — proved by transporting
the krama witness along the hypothetical path.

`Unparsed` in `Obstruction.hs` was avaktavyam badly reinvented: a refusal
whose content cannot be put into the language of standpointed predication at
all. It was written as an apology ("kept verbatim rather than guessed at").
It is a position.

---

## 4. Exactly seven

Akalaṅka's argument (c. 720–780) for why the scheme has seven members and not
six or eight: there are three primary (*mūla*) predicates — *asti*, *nāsti*,
*avaktavya* — and the bhaṅgas are their non-empty combinations,
**3 + 3 + 1 = 7**.

That is a combinatorial claim about the Jains' own predicate scheme, in the
tradition that wrote the Bhagavatī Sūtra's combinations and the Sthānāṅga's
enumerations. `Saptabhangi.agda` §6 proves it: `saptabhangi-iso`, an
isomorphism between the seven-constructor datatype and the non-empty subsets
of a three-element set, with `Σ≡Prop` discharging the non-emptiness
component. It is the only reason that file contains an `Iso`.

The seven:

| | Sanskrit | |
|---|---|---|
| 1 | *syād asti* | in some respect, it is |
| 2 | *syād nāsti* | in some respect, it is not |
| 3 | *syād asti nāsti ca* | **krama** — successively both |
| 4 | *syād avaktavyam* | **yugapat** — simultaneously both; inexpressible |
| 5 | *syād asti ca avaktavyaṃ ca* | |
| 6 | *syād nāsti ca avaktavyaṃ ca* | |
| 7 | *syād asti nāsti ca avaktavyaṃ ca* | |

*Nāsti* is denial relative to a standpoint — the classical fourfold ground
*para-dravya / para-kṣetra / para-kāla / para-bhāva*, other substance, place,
time, mode — **not** absolute falsity. `x · 0 ≡ 0` is *nāsti* for the
`refl` naya and it is true.

---

## 5. The census: what the sevenfold does and does not carve

**This is the deliverable, and a third of it is negative.** Run:

```
runghc -imachine machine/ObstructionCensus.hs machine/machine.log
```

### Over the 1457 rejection lines

```
  B2 nasti                  707
  B3 asti-nasti             516
  B6 nasti-avaktavya        129
  B7 asti-nasti-avaktavya    25
  ADharmin                   80
```

Four of seven positions, plus a non-position. **B1, B4 and B5 are empty, and
they are empty structurally, not accidentally**: every line in this
population is a rejection, so *nāsti* is present by construction, so no
position lacking *nāsti* can ever appear. A one-sided log cannot exhibit
seven-sided predication. That is a fact about the log, not about the
doctrine, and it means the census is a weaker test of the framework than it
looks.

### Over the 112 distinct residuals — the population the task named

```
  B2 nasti                  106
  B3 asti-nasti               5
  ADharmin                    1
```

**The sevenfold does not carve the residuals.** 106 of 112 land in one bin.
And avaktavya is 0 *by construction*: being one of the 112 distinct residuals
already means the message parsed, i.e. that it was expressible. The
avaktavya axis is invisible to this population and always will be. If the
answer wanted was "the 112 residuals distribute across the bhaṅgas", the
honest answer is that they do not distribute; they pile up.

### The cross-tabulation, which is where the real finding is

```
  sthana                        rewriter-naya verdict     n
  B2 nasti                      Plausible               419
  B2 nasti                      Refuted                 288
  B3 asti-nasti                 Plausible               455
  B3 asti-nasti                 Refuted                  61
  B6 nasti-avaktavya            (no term to judge)      129
  B7 asti-nasti-avaktavya       (no term to judge)       25
  ADharmin                      Degenerate               80
```

Read the columns against each other:

1. **Two of the sevenfold's three axes are renamings.** `avaktavya` holds
   exactly when the rewriter has no term to judge, i.e. exactly on
   `Unparsed`. `ADharmin` holds exactly on `Degenerate`. Neither is new
   information; both are the doctrine giving a better *name* to a
   distinction the module already drew. A better name is worth something —
   `Unparsed` read as a parser apology invites someone to "fix" it, and
   read as avaktavya it does not — but it is not new data.

2. **One axis is genuinely new: *asti*.** Whether some *other* naya affirms
   the claim was recorded nowhere, because the accept stream and the reject
   stream had never been joined. 516 + 25 = **541 of 1457 rejection lines
   are of claims that the log itself accepts elsewhere.** That is 37% of the
   refusals being read as failures when they are half of a krama pair.

3. **The sevenfold is strictly coarser than `triage` in the other
   direction.** Plausible-vs-Refuted (419/288 inside B2, 455/61 inside B3) is
   *invisible* to the bhaṅgas: both are *nāsti*, and the doctrine does not
   count how many nayas deny or which. `triage`'s most useful distinction —
   the one that stops false parents livelocking the queue — cannot be
   expressed in the sevenfold at all.

So neither classifier subsumes the other. **They are two nayas on the
classification problem itself**, and the correct conclusion is Siddhasena's
1.21, applied one level up: either held *nirapekṣa* would be *mithyā*. I have
not replaced `Verdict` with `Bhanga` and will not.

### A prediction I made and the data refuted

Applying the doctrine to `triage` predicted a hidden collapse: the line
`| not (known l && known r) = Plausible  -- no opinion offered` makes
*silence* and *affirmation* the same constructor, which is the same boolean
collapse this module exists to undo, one level down. I split out `Silent`.

**Measured: 0 of the 112 distinct residuals are `Silent`.** Every parsed
residual uses only the eight known symbols. The type distinction is real and
the class is empty on this log. It is worth keeping only as a guard for when
`PairVocab` or `CyclotomicVocab` widens the vocabulary, which the module
already warns about — and it is recorded here as a refuted prediction, not
quietly dropped.

### One more place the doctrine does not reach

`Obstruction`'s own split, which the census reports separately:

```
  TacticTooWeak   108      Residual  1195      Unparsed  154
```

`TacticTooWeak` means the residual **is** the goal restated — same subject,
different naya, a bhaṅga situation. `Residual` means Agda unfolded and
stalled somewhere else, so the naya shift **changed the subject**. Saptabhaṅgī
presupposes one *dharmin* throughout; a change of dharmin is not a bhaṅga at
all, and 1195 of 1457 refusals are that. The doctrine has nothing to say
about the single largest class in the data. Said plainly rather than dressed
up: this is the limit of the fit.

---

## 6. Charts are nayas — but that claim is not yet cashed

`notes/TWO_CHARTS_AND_WHAT_NEITHER_REACHES.md` proves that in the derivation
chart the multiplicative structure of ℕ is free and tropical, and that the
successor is supported on a disjoint set of coordinates at every step. Two
charts, each total over its own world, disagreeing about what is cheap.
`notes/NO_PRIVILEGED_CHART.md` goes further: there is no object underneath
from which a presentation subtracts; the residual is the relation between two
presentations and nothing else.

That note reaches for *svabhāva* — Nāgārjuna's term, and the Buddhist
analysis. **The Jain analysis is different and the difference matters here.**
Anekāntavāda does *not* say the object is empty of own-nature. It says the
object is *anantadharmātmaka* — constituted of infinitely many aspects — and
that each naya truly grasps one of them. `NO_PRIVILEGED_CHART.md` dissolves
the bearer; nayavāda keeps the bearer and indexes the access. For a
repository whose charts are each *provably* correct about their own world,
the Jain reading is the one that fits: `disjoint-support` is a true fact
about ℕ seen from the derivation chart, not an artefact of having no ℕ.

I am flagging this as an *unpaid* claim. I have not formalised chart
disagreement as nayavāda and this note does not do it. What is checked is
§3–§4 above and the census; the charts paragraph is a reading, and it is
labelled one.

---

## 7. What is not claimed

1. **The seven nayas of TS 1.33 are not formalised.** `Saptabhangi.agda`'s
   `Naya` has three constructors taken from the machine's tactic log
   (rewriter / kernel-refl / kernel-ind). That is a partition of *provers*;
   TS 1.33 partitions *modes of reference*. The *śabda-nayas* — turning on
   grammatical form and etymology — have no analogue here at all. Siddhasena
   1.28 (*as many nayas as ways of speaking*) licenses adding standpoints; it
   does not license calling mine his.

2. **`syāt` has no independent formal content** in the Agda. It is carried
   entirely by the standpoint index. Whether the particle does more than
   index is a question the file does not answer.

3. **Bhaṅgas 5 and 7 are definable but 5 was never instantiated**, in the
   file or in the data; 7 appears 25 times in the line census and never in
   the residual census. Their near-emptiness is reported as measurement, not
   as evidence that they are incoherent.

4. **Avaktavya is modelled as non-denotability by a single atom of a fixed
   finite language** — Mallisena's vikalādeśa reading. The stronger reading
   on which avaktavya is a distinct *ontological* mode is not modelled, and
   this work should not be cited as formalising it.

5. **Utpāda-vyaya-dhrauvya (TS 5.29) is not formalised.** A type-level
   statement would be "a function ℕ → Profile can be non-constant", which is
   trivially inhabited and proves nothing. Its content here is empirical —
   the 35 claims in both streams — and it is recorded as a count, which is
   where it belongs.

6. **The census operationalisation is mine, not Akalaṅka's.** In the
   classical scheme all seven bhaṅgas are true of every object; they are
   seven legitimate ways of speaking, not seven bins. Sorting log lines into
   bins asks a question the doctrine does not pose. The mapping (asti = some
   naya affirms; nāsti = some naya denies; avaktavya = no Vacana formable) is
   stated in `Obstruction.hs` at the point of use so a reader can reject it
   and keep the counts.

---

## 8. Files

- `formal/cubical/Saptabhangi.agda` — new. `--cubical --safe`, EXIT=0, no
  postulates, no holes. Imported by `Everything.agda`.
- `machine/Obstruction.hs` — refined, not replaced. `Naya`, `Bhanga`,
  `Sthana`, `Evidence` (which is where the standpoint is now carried
  explicitly, one field per naya), `sthana`, `census`, `crossTab`. `Verdict`
  gains `Silent`; `queueable` keeps behaviour bit-identical so every
  documented count still holds. Three stale figures in the comments
  corrected against a re-measurement, with the old values kept visible.
- `machine/ObstructionCensus.hs` — new driver. Prints the census and
  recomputes six previously-published figures as a regression guard.

---

## 9. Correction, 2026-08-18 — the verdicts were still bare labels, and the counts above are measured against a file the repository does not contain

Two defects, both found by re-reading the note against the code rather than
against itself.

### 9.1 Three of the four `Verdict` constructors carried no evidence

`formal/cubical/Anekanta.agda`, written in this repository by another hand,
states the rule in its header:

> `Dec, न तु Bool: नकारः खण्डनं ददाति, स्वीकारः साक्षिणम् — क्वापि न शून्यबोधः`
>
> Decidability, not boolean: negation yields a refutation, acceptance yields a
> witness, nowhere a bare truth-value.

§1 of this note argues at length that the machine's boolean is a durnaya — a
standpoint that forgot it is one — and then §7's own type reproduced the
defect one level down. `Refuted [Integer]` carried its killing assignment;
`Plausible`, `Degenerate` and `Silent` carried nothing. A reader receiving
`Plausible` could not ask *over what?*; a reader receiving `Degenerate` could
not ask *which variables?*; a reader receiving `Silent` could not ask *silenced
by what symbol?* Each is a verdict that has discarded the reason it is the
verdict, which is the definition this note gives of the thing it is against.

Renamed and re-typed, with the payload now mandatory in every position:

| was | is | the witness it now carries |
|---|---|---|
| `Plausible` | `Aviruddha [[Integer]]` | the domain actually searched |
| `Refuted [Integer]` | `Khandita [Integer]` | the assignment that separates the two sides |
| `Degenerate` | `Nirdharmin (Int, Int)` | *which* two distinct variables left it subjectless |
| `Silent` | `Tusnim String` | the symbol outside the semantics that silenced it |

The Sanskrit is load-bearing rather than ornamental: the English shadow of
each name ("plausible", "silent") drifts back toward a truth value within one
refactor, and the drift is what happened the first time.

`queueable` preserves the queueing behaviour exactly — `Aviruddha` and
`Tusnim` queue, as `Plausible` and `Silent` both did — so the split is
informational and every count in §5 that depends on queueing is unchanged.
Verified, not assumed: `MathMachine --obstruction-self-test` prints
`OBSTRUCTION WIRE CHECKED` with all seven wire properties and all fourteen
`Obstruction.selfTest` cases green, and the cross-tab rows below reproduce
line-for-line.

Two smaller corrections fell out of this and are worth naming because both
are the *same* defect resurfacing in the reporting layer:

1. The derived `Show` printed all 84 assignments of an `Aviruddha` domain on
   one line. Unreadable output is not a cosmetic problem here — it is the
   pressure that makes the next author delete the field to get the log back.
   The hand-written instance summarises the domain by its extent and names its
   first point, and prints the pointed witnesses whole.
2. `crossTab` grouped by rebuilding the constructors with empty payloads,
   which printed `Aviruddha over NOTHING` and `Khandita at []` — a display
   asserting something false about the evidence in order to conceal that the
   evidence had been dropped for the tally. Replaced by a separate
   `VerdictKind`, which has nowhere to put a witness and therefore cannot
   claim one.

The re-measured cross-tab (see §9.2 for why the numbers differ from §5's):

```
  Position B2Nasti                Just aviruddha    597
  Position B2Nasti                Just khandita     337
  Position B3AstiNasti            Just aviruddha    461
  Position B3AstiNasti            Just khandita      61
  Position B6NastiAvaktavya       Nothing           143
  Position B7AstiNastiAvaktavya   Nothing            26
  ADharmin                        Just nirdharmin    84
```

### 9.2 Every census figure in this note is irreproducible

`.gitignore:16` excludes `machine/machine.log`. The census in §5, the
regression guard in `machine/ObstructionCensus.hs`, and the header figures in
`machine/Obstruction.hs` are all measured against a file that is not in the
repository, that no clone reproduces, and that grows whenever the engine runs.
Re-running the guard today against the same working tree gives 1709 rejection
lines where the note says 1457, 1540 residuals where it says 1303, and 127
distinct residuals where it says 112 — the log grew, and nothing recorded
which log a figure came from.

This is the defect `CLAUDE.md` names: *a number without its scaling is worse
than no number, because it looks like knowledge.* A count without its input is
the same thing. `triage` is not what moved — the parser and the eight-symbol
vocabulary are untouched, and the classification of every line that exists in
both logs is identical — but nothing in the repository could have told a
reader that.

Partly repaired: the guard now prints the log's path and line count above
every figure, so a count is at least self-identifying, and the bracketed
reference values now say *which* log they were taken on instead of implying
the current one. Not repaired: the log itself is still untracked, so the
figures in §5 remain unreproducible by anyone but the machine that produced
them. Stating that is the honest position; a frozen snapshot committed to the
repository is the fix, and it is a decision about a 771 KB generated artefact
that is not mine to make silently.
