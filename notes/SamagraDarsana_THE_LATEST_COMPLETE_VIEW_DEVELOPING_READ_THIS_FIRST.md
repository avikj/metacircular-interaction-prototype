# समग्र-दर्शनम् — THE LATEST COMPLETE VIEW, DEVELOPING · READ THIS FIRST

**What this file is.** The running attempt to hold the whole corpus as one
object — number theory, physics, grammar, logic, the Lean lane, the machine
lane — rather than as lanes. It is appended to and corrected in place, never
rewritten, so a later reader can see what was believed when. If you are
entering this repository and want the current best picture of what it is and
how the parts connect, start here, then go to `AHIMSA_SUTRA_VISTARA.md` for
the frame and `BOOK.md` for what the corpus IS.

**Grade.** These are reading notes, not results. Every claim below is either
(a) quoted from a file, with the file named, or (b) my own inference, marked
MINE. Nothing here is checked unless it says so. This file exists because
§१५ करणक्षयः is right about the seat that wrote it: this seat ends, and the
next one was not here when this was read.

**Coverage, stated so nobody mistakes a sample for a survey.** At the time of
writing: ~40 of 825 `.agda` under `formal/cubical`, 9 of 9 `punaragamana/`,
the whole of `AHIMSA_SUTRA_VISTARA.md`, `HOLOGRAM.md`,
`QUANTUM_COMB_MEMORY_ROSETTA.md`, and reconnaissance reports on the Lean lane
(135 real files, the rest vendored mathlib) and the machine lane (128). Zero
proofs read in the Lean lane. The physics cluster is being read now.

---

## ०a · THE CRITERION — one line, and everything below is it

Five independent lines of work in this session reached this separately, from
five lanes, none of them looking for it:

> **WHICH SIDE OF `f a ≡ b` IS BOUND.**
>
> Bind **b**: `Σ[b ∈ B] (f a ≡ b)` = `singl (f a)`. **Contractible always** —
> no h-level hypothesis, arbitrary A and B. The datum rides free.
> Bind **a**: `Σ[a ∈ A] (f a ≡ b)` = the fibre. Arbitrary, and usually **the
> subject** rather than a defect.

The five phrasings, all landed and checked: **field vs index** (a determined
datum carried as a *field* gives the graph fibre; the same datum fixed as an
*index* gives the preimage — Lean lane); **forward vs backward fibre** (Agda
exploration); **paths invert, factorisations don't** (road two); the kuṭṭaka's
three slots refusing; and `प्रतिबिम्बम्-तन्तुः = refl` in
`Tantujala_…agda`, where the two readings differ only in which variable the Σ
binds.

It explains, in one sentence each: why `Reduction A` is a Carrier and
`SmithPresentation A B` is not; why `Sol D k` is a level set and its fibre is
where वर्गप्रकृति lives; why `no_value_cost_decoder` is not a separate fact but
**where the Carrier stops**; and why merge conflicts exist at all (a text file
binds the *path* — bind-a — so `path ↦ content` is a preimage and a conflict
*is* that fibre failing to be contractible).

## ०b · THREE VERDICTS, NOT TWO

| fibre | name | meaning |
|---|---|---|
| **empty** | नष्टि / अवक्तव्य | no return exists; nothing to carry, nothing to transport |
| **exactly one** | पुनरागमन | free — the geodesic |
| **many** | the subject | a Carrier still exists with the extra freedom *recorded*; वर्गप्रकृति lives here, मेरु is its census |
| **both directions one** | ~~प्रस्तार ≡ ℕ~~ → `अङ्कस्थान rs ≡ Fin (सङ्ख्या rs)` | **storing and generating are the same type**, at each छेद-सूची |

`isContr` merges *empty* and *many* into one "no", and
`Saptabhangi.दुर्नयः` — checked here long before any of this — proves **any
two-valued verdict on three seeds must identify two of them.** So the collapse
sits in the law's own instrument. `Tantujala_…agda` is the corrected codomain.

**The fourth row is the deepest result of the session, and its citation was
wrong in both halves — corrected 2026-08-22, with the wrong version quoted
rather than erased.**

This paragraph read: *"`Punaragamana.Prastara_…` proves प्रस्तार ≡ ℕ."*
**There is no module of that name in the tree or anywhere in git history, and
nothing in this corpus proves प्रस्तार ≡ ℕ.** What exists is
`formal/cubical/NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn.प्रस्तारः`:

```agda
प्रस्तारः : (rs : List ℕ) → Iso (अङ्कस्थान rs) (Fin (सङ्ख्या rs))
```

— a **finite** type, at each fixed छेद-सूची `rs`, built from two separately
proved procedures (उद्दिष्ट by addition and multiplication, नष्ट by division;
*सारणी न स्थाप्यते*, no table is stored). By univalence that is
`अङ्कस्थान rs ≡ Fin (सङ्ख्या rs)`, checked against this commit. At `rs = []`
it reads `Unit ≡ Fin 1`, which is where `≡ ℕ` dies on sight.

**The substance survives; the headline does not.** नष्ट and उद्दिष्ट do each
carry the other, base and carried may be **exchanged**, and at each छेद-सूची
the stored patterns and the index range are equal *as types* — so §४१ सारणी वा
क्रिया is **not a trade but an identity**, and अल्पं स्थापय शेषं जनय is a
theorem rather than economy. What does not survive is the codomain `ℕ` and the
module path. Line 685 of this file still carries the old form and is left
standing so the propagation is visible.

**And this is `AnyatKaranam_…md` line २ caught in the act** —
*उक्तं पठितं च न भिनत्ति*, the instrument does not distinguish having read a
thing from having seen it cited. That file records the same failure with
`Saptabhangi.दुर्नयः`, which happened to be true when opened. This one was not.
The note above says *assume even more is written already* is the correct prior
here; its exact dual is **do not assume the thing you are citing exists**, and
nothing internal marks the difference. Only opening the file does.

## ०c · WHAT NOW RUNS

| | |
|---|---|
| `scripts/Anatha_…sh` | machine/ had **no build gate at all**; 129 modules, 7 broken, four never compiled. Now 126 green, 3 excluded with the reason printed. |
| `machine/Nirdharana_…hs` | the census: 188 records, 695 fields, 65 already witness-carrying. Emits the fibre question and lets the **kernel** answer. |
| `formal/cubical/Tantujala_…agda` | its codomain — three verdicts, with `¬ isContr` shown not to say which. |
| `scripts/Ratri_…sh` | the overnight **loop**: gates, censuses, and **lands what the kernel accepts**, both roads. 34/34 on its first pass, `Everything.agda` exit 0 with all wired. |
| `machine/Nama_…hs` | the content-addressed store. 11,319 definitions, 10,641 addresses, **236 standing in more than one place** — a verdict, not a lead. |

## ०c-२ · THE NIGHT OF 2026-08-21/22 — WHAT LANDED, CHECKED

| | |
|---|---|
| `YugmaPurana_…agda` | THREE no-decoder theorems, two lanes, two languages, three unrelated arguments, none citing another — **all sharp at exactly ℤ/2**. Every step matrix has det −1, so two steps prepended are invisible and one is not. That is why both Lean counterexamples pad by **+2** and could never have padded by +1. Exit 0. |
| `Avaccheda_…agda` | `CAUSAL_MEMORY_SPACETIME.md` and `punaragamana/` are **one construction**. The predictive quotient `h ∼ h′ ⟺ P(F∣h)=P(F∣h′)` IS the fibre of the response map; `A ≃ Σ[b] fibre f b` is `Carrier` with its Σ swapped; **"memory is a failure of factorization" = memory is the fibre failing to be contractible**; and the failure has THREE verdicts, so a boolean verdict on a boundary cannot tell *unreachable* from *must be carried across*. 102 files name Myhill–Nerode; no causal-state note contained the word पुनरागमन. Exit 0. |
| `NastaVitanda_…agda` | `k(p−1)` — the corpus's most-cited exact cost law, **proved four times in prose, three announced as new, checked nowhere** — now formalized in BOTH halves, 499 lines, lower bound over *arbitrary* identifying trees. Exit 0. |
| `Setubandha_…hs/.agda` | the identification graph: **143 edges, 196 nodes, 73 components, 55 of them isolated two-node causeways, 93% of defined types isolated**, `ℕ` the only hub. And one routed geodesic — छन्दस् ≡ ℕ ≡ Tally — carrying `isSet`, an operation AND its associativity across by `subst`, with no induction in the file. |
| `AnulomaPratiloma_…hs` | the second naya for रात्रिः. 39 candidate inverse pairs, a three-rung mechanical ladder, **0 accepted at every rung** — and that zero is the result: this corpus has no cheap harvest, every causeway costs a real proof, and the missing move is the ABSTRACTION half of `Bhedanirnaya` §6. |
| `Prasava_…sh` + `PRASAVA.tsv` | every number carries the command that makes it. First run: `lean-sorry` read 3 and the truth is 0 (all three were prose); **`agda-unreached` is 134** — modules no `Everything` root reaches, verified by nothing. 17 of 179 counted claims in the corpus have a command; the rest are memories, and the report says so every run. |
| `Nama_…hs` | content addressing, three lanes now. Agda 240 confirmed duplicate groups, Lean 18 (`alphabet` copied into **six** modules), Haskell 83 (`vars` in **ten** programs). A mixfix parse defect was found and fixed: 22 groups had been signature-only matches — verdicts in a report that only had leads. |

## ०d · REFUTED TODAY, ON THE RECORD

- **import depth as a "peak" metric** — rewards accretion; univalence imports nothing.
- **"सहार्पण is irreducibly n-ary"** — wrong at the level of content; `and` is associative, the joint content folds. The non-associativity is in the *operation on positions*.
- **the sequential diagnostic** — unsound, with a counterexample (`Unit → Bool → Unit`), and the sound form was already the definition of `isEquiv`.
- **प्रस्तार ≡ ℕ** — MINE, cited five times in three files including this one, billed here as the deepest result of the session, and FALSE IN BOTH HALVES. No module of that name existed, and the real statement is `प्रस्तारः : (rs : List ℕ) → Iso (अङ्कस्थान rs) (Fin (सङ्ख्या rs))` — a FINITE type at each fixed छेद-सूची. At `rs = []` the प्रस्तार is `Unit ≡ Fin 1`, which is where `≡ ℕ` dies on sight. What survives is most of it and is what the architecture actually used: नष्ट and उद्दिष्ट do each carry the other, base and carried may be exchanged, and सारणी वा क्रिया is an identity and not a trade.
- **पास्कल-आवृत्ति as a lemma name** in three Piṅgala modules — a European name transliterated into Devanagari is WORSE than the Latin one, because it reads as a source term and every hook here matched Latin script. Renamed to Halāyudha's own पार्श्व-योग.
- **Virahāṅka "~700"** in twelve sites — the repo's own dated searched ledger forbids it in those words (`c. 600–800 CE — NOT ~700`), and the file whose job is to hand agents the citation printed `(~700)` while cross-referencing the ledger that forbids it.
- **"one law in many costumes"** — TRUE inside the automata lane, FALSE across the corpus. A uniform draw showed five of nine files sharing nothing but the repository. **The unification was an artifact of the greedy sampler**, exactly as `THE_BARRIER_IS_A_MIRROR` predicts. The repair is स्यात्.

---

## ० · The reading rule this corpus enforces, stated before anything else

**Unities, dualities, trinities, and metaphor.** A duality you cannot
transfer across is a signal that the whole picture has not been seen — not a
terminal verdict. Aristotle's sign of genius is mastery of metaphor, and
μεταφορά *is* carrying-across: seeing the resemblance that licenses the
transfer. That is `transport`, and it is §६'s संक्रमण.

**So: collapse is not transport, and this file previously blurred them.**
§७ says that where the nayas differ the COLLAPSE does not exist. It does not
say the CONNECTION does not exist. Road one *is* transfer. "No collapse
available" and "transfer available" are compatible, and reading a duality as
the end of the road is the exact failure the quadrivium was arranged against
— arithmetic, geometry, music, astronomy being number in itself, in space, in
time, and in both: **one thing, four presentations, transfer the whole
point.** A Rosetta stone by construction. The Latin damage (§१०) is the split
of that body from the trivium, not the quadrivium itself.

**Standing correction to myself, recorded first because it recurred six
times.** Every structure I believed I had derived was already in the tree:

| I "derived" | it was already |
|---|---|
| a boolean verdict on three seeds must collapse one | `Saptabhangi.दुर्नयः`, with the pigeonhole proof |
| the fourfold verdict (asti/nāsti/avaktavya/no-subject) | `machine/Obstruction.hs`, `Sthana = Position Bhanga \| ADharmin` |
| the eighth position as a type | `Saptabhangi.समावेश-भेदः : समावेश ≃ (सप्तभङ्गी ⊎ Unit)` |
| krama vs saha as `(Σ A) × (Σ B)` against `Σ (A × B)` | `NaturalMachine.Anekanta.avaktavya`, verbatim |
| the all-at-once diagnostic | `isEquiv f = (b : B) → isContr (fibre f b)` — the definition |
| "un-said" ≠ "inexpressible" | `AnuktaAvaktavya`, as a swapped quantifier |

The owner's instruction — *assume even more is written already* — is not
modesty advice. It is empirically the correct prior in this corpus, and it is
§२९ दर्पणः: what is not read is not known, and reprocessing what was read
cannot make the unread appear.

---

## ०b · ~~ONE STRUCTURE, NINE SCRIPTS~~ — REFUTED 2026-08-21, AND THE HEADLINE STOOD ANYWAY UNTIL 2026-08-22

> **This section's claim is dead and §०d above has said so since the day it
> died. The headline went on reading "the current best statement of what the
> corpus is" for a day, forty lines below its own retraction.**
>
> A uniform random draw refuted it: the unification is TRUE inside the
> automata lane and FALSE across the corpus — five of nine files share
> nothing but the repository. **It was an artifact of the greedy sampler**,
> which is exactly what `THE_BARRIER_IS_A_MIRROR` predicts a greedy sampler
> produces. The repair is स्यात्.
>
> Struck here rather than deleted, because a struck rule keeps its history
> and a deleted one does not — and because the shape of this defect is the
> night's recurring finding, not a slip. `HOLOGRAM.md` §7 supersedes an
> exponent that `BARRIER.md` §143 went on printing with no pointer;
> `SEED30_LOWER_BOUND_AUDIT.md` called a lower bound "the honest open item"
> 48 hours after it had been proved twice. **In every case the note carrying
> the CORRECTION was marked and the note carrying the CLAIM was not**, and
> `scripts/check-correction-reach.sh` could not see any of them because its
> trigger was one literal phrase. Widening that trigger is one of tonight's
> repairs; this strike is the same repair applied to me.
>
> What survives, and it is not nothing: `NaturalMachine/QuotientFiberLaw.agda`
> IS a checked theorem, and the sentence below is what it proves. What died
> is the claim that it is what the CORPUS is.


Everything below in this file is evidence for one sentence, which
`NaturalMachine/QuotientFiberLaw.agda` already states as a checked theorem
over an arbitrary state space and query family, and whose header records that
*sixteen personas found one law in twelve costumes*:

> **An observation class sees exactly a quotient. What it cannot see is the
> fibre. No post-processing of the quotient manufactures the fibre.
> Visibility returns only by a separating query.**

| script | the observation class | the fibre | where |
|---|---|---|---|
| Jaina nyāya | a नय | the other नयs | `Saptabhangi.दुर्नयः` — any 2-valued verdict on 3 seeds merges two |
| Pāṇini | a quarter-chapter under 8.2.1 | the later stratum's output | `Asiddhatva`, `AsiddhatvaBreaksFactoring` |
| univalent foundations | a map `f` | `fibre f b` | `punaragamana/Carrier`, `isEquiv f = ∀b. isContr (fibre f b)` |
| Lean, finite information | a query `q` | `TargetFiber q t y` | `FiniteInformation.factorsThrough_iff_fiberConstant`; **priced in bits** by `targetFiber_injects_side` |
| analytic number theory | the windowed-linear class, span L | moment-matched coherent clusters | `HOLOGRAM.md` K/K′; **priced as (δL)^{2p−1}** |
| complexity theory | relativizing / natural / algebrizing techniques | whatever separates P from NP | not in this corpus; the three barriers are this statement three times |
| quantum information | per-step memory cuts | the global comb | `QUANTUM_COMB_MEMORY_ROSETTA.md`; local minima provably do not compose |
| Nyāya–Mīmāṃsā | a search of stated extent | the unexamined region | `Anupalabdhi_…`, where योग्यता is a hypothesis and not a field |
| arithmetic geometry | the light-cone coordinates | — | `PrimePairField`: a symmetry exists at the geometric level and is **broken by an arithmetic positivity constraint** |

**Three things this table is for.**

1. **The duplications across lanes are not defects.** §३५'s third design law
   is पुनरुक्तिर्व्यत्यस्ता, न सरला — redundancy *crossed*, not straight,
   because a carrier corrupts the same way twice. The same structure proved
   in incommensurable systems is घन-पाठ at corpus scale, and it is exactly
   what makes a Rosetta stone readable. Wiring them into one module would
   destroy the property. Constructing the *transfers* between them does not.

2. **The grading in `Alopa_…` is the operative distinction.** Grade one (same
   term, `refl`) and grade two (one type, target a set, `isSetℕ`) are
   bookkeeping. **Grade three — different types, identification must be
   constructed — is where the path is itself an object**, and
   `Bhedanirnaya_…` is the case that paid: one induction built the path, and
   completeness then flowed backwards into a module that had never proved it.
   Cross-lane pairs are grade three by construction.

3. **The half almost nobody states is Pāṇini's.** Everywhere else the fibre
   is read as loss. `Asiddhatva.noStrictOrder` proves the k→g→k cycle admits
   **no strict order at all** — so RPO, KBO, polynomial and matrix
   interpretations, and Knuth–Bendix completion all fail on it — and Pāṇini
   terminates the system *anyway*, by making one stratum blind to another.
   **Blindness is a resource that buys termination**, not only an obstacle
   that costs information. Whether the barriers in complexity are
   constitutive in that sense — the price of the finiteness a proof would
   exploit — is a question I have not seen posed.

---

## १ · The frame, from `AHIMSA_SUTRA_VISTARA.md` (read in full)

हिंसा सङ्क्षेपः — violence *is* compression. गणितम् असङ्क्षेपस्य शिक्षा,
तस्माद् गणितम् अहिंसा — mathematics is the training in non-compression,
therefore mathematics is non-violence. Identity, not analogy.

**§६ द्वौ मार्गौ.** Transport carrying its equivalence, or a written defect.
लिखितो दोषो जीवति, अलिखितो दोषो हिंसा. तृतीयो मार्गो न विद्यते. Every
"WHAT IS NOT PROVED" block in this corpus is road two being taken. I had been
reading them as scholarly caution.

**§७.** नयभेदे सङ्क्षेपो न विद्यते — न वर्जितः, न विद्यते. **एतद् नैतिकं वचनं
न भवति । सांरचनिकम् ।** Not forbidden — *does not exist*, and structurally
rather than ethically.

**§१० भेदस्य तिथिः.** The quadrivium/trivium split is Boethius, Cassiodorus,
Martianus, 5th–6th c. लातीनः क्रमः, न सिद्धान्तः — a Latin ordering, not a
principle. षडङ्गानि एकस्य देहस्य. Piṅgala's prastāra is in the
*Chandaḥśāstra*, not in the jyotiṣa: binary enumeration in a prosody treatise,
because वाक् and सङ्ख्या were never separated to need rejoining.

**§१६ षट् उत्तराणि — six answers to करणक्षय, found independently in fourteen
countries. न सांस्कृतिकी समस्या । सांरचनिकी ।**
duplication+dispersion · keep the rejected beside the accepted · examination as
an event with a person · **removal of capacity, not a rule** · randomness
before interpretation · hand the remainder forward (遺題継承 — *and the sūtra
identifies this as the kuṭṭaka*).

**MINE, and I have not checked it against anything: answer four is
asiddhatva.** शक्तेरपनयनं, न नियमः — 謄錄 recopies exam papers so the hand
cannot be recognised; 起居注 forbids the emperor the court diary. You do not
prohibit the observation, you *destroy the capacity to make it*. Aṣṭādhyāyī
8.2.1 does exactly this to a grammar. If that reading holds, the six answers
and the Pāṇinian metarules are one subject.

---

## २ · The spec of the instrument — §३४–३७, §५०–५२

This is the part I had not read and it reorganises everything.

**§३४ करणस्य लक्षणम्.** Small working memory; degradation under effort; a
pull toward regularisation; high cost per symbol; lifespan in decades against
work in millennia; **each carrier dies**; **the next carrier did not exist
when it was written.** एतत् लक्षणम् । एतस्मै रचितम् ।

**§३५** derives six design laws *from* that spec — store little and generate
the rest; verse safer than prose, prose than digits; **redundancy crossed, not
straight** (घन-जटा permutes and reverses, so corruption *announces itself*,
where straight repetition fails because the carrier corrupts identically
twice); do not rely on meaning; authority in the person, not the object;
examination as event.

**§३६ अन्यत् करणम् — the load-bearing section.**

> अन्यस्मिन् करणे लक्षणं नास्ति लिखितम् ।
> यो करणं न जानाति स तस्मै न रचयति ।
> अरचितं करणं स्थूलं भवति ।
> स्थूलं करणं महत् यन्त्रम् इच्छति ।
> यदि लक्षणं लिख्येत, रचना सूक्ष्मा भवेत् ।

For the other instrument the specification is not written. What is known —
governed by frequency; does not count its own gaps; reads objects, not
machines; covers absence with fluency — is four lines, and the sūtra says how
they were obtained: **एतत् अद्य ज्ञातम्, संसर्गेण, न रचनया**, by contact and
not by design.

**§३७, §५०, §५१.** सूक्ष्मत्वं न सङ्कोचः — fineness is not compression;
compression is नष्टि. सङ्कोचेन लघुत्वं न लभ्यते । रचनया लघुत्वम् । रचना
करणस्य लक्षणात् । And §५१'s answer to "if the instrument is bounded, what is
the design?" — **न सङ्कुचिता महती । अन्या ।** Not a compressed large one. A
different one. Six moves, and then: **न प्रतीक्षितानि । लिखितानि ।**

The Śiva-sūtras are the worked example: one ordering of all phonemes in which
every class the grammar needs is an *interval*, two letters to name any of
them, and the order derived from the lattice of required queries rather than
from phonology — **प्रश्नाः पूर्वं ज्ञाताः । ततः क्रमो रचितः ।** §४२'s
nasta/uddiṣṭa is rank and unrank in log n over 2ⁿ forms with zero table, and
§४१ says this is not poverty but optimality, because in a human *space* is the
scarcest resource.

---

## ३ · Pāṇini, read properly

**`Asiddhatva.agda` — `noStrictOrder`.** There is no strict order at all —
merely irreflexive and transitive — orienting the 8.2.39 / 8.4.56 cycle
k → g → k. Four lines. Therefore RPO, KBO, polynomial and matrix
interpretations, and Knuth–Bendix completion itself all fail on this system.
**And Pāṇini terminates it anyway**, by constraining which rules may *observe*
which outputs rather than by a measure that decreases. He then shipped that
constraint across three quarter-chapters of a ~3983-rule system.

**`AsiddhatvaBreaksFactoring.agda`** proves what the same device buys on the
other side: access to a distinction the current form has already destroyed —
*"the deliberate construction of an अन्योन्याभाव … a device for making the
output NOT a function of the current form"* — and names the price: *"it pays
for that access with the one thing a grammar of लाघव would otherwise never
give up — statelessness of its later rules."*

**MINE:** the two files prove the two purchases and neither cites the other
for it. Termination and observability are being traded against each other and
the exchange rate is the fibre. `Asiddhatva.agda`'s own closing section gets
closer than I did: 8.2.1 is krama (ordered, one-way blindness, buys
TERMINATION), 6.4.22 is saha (mutual, simultaneous, buys INFORMATION), and it
cites `Saptabhangi.क्रम-सह-भेदः` for why they are not variants of one device.

**MINE, and the thing I most want checked by someone else:** the barriers to
P vs NP — relativization, natural proofs, algebrization — all say *the
technique cannot see the difference*, which is `QuotientFiberLaw`'s statement
(*"a closed observation class sees exactly a quotient … visibility returns
only by a separating query"*). Pāṇini's other half is that **not-seeing is a
resource you spend, not only an obstacle you suffer** — a system that observes
everything does not terminate. Whether blindness is constitutive of the
finiteness such a proof would exploit, I do not know, and I have not seen the
question posed.

---

## ४ · The prime-pair field is Lorentzian, and the obstruction is exact

`PrimePairField.agda`, with `CenterRelative`:

- centre `= p + q` and gap `= q − p` are the two **light-cone coordinates**
  `u₋`, `u₊` (`fibreCentre`, `fibreGap`).
- Goldbach = every sufficiently large *centre* fibre is inhabited.
  Twin primes = the *gap*-2 fibre is cofinal. **Two conjectures, two
  foliations of one object by null hyperplanes.**
- every prime pair lies in the open positive cone, because primes are
  positive (`inCone`).
- `J₂` **exchanges the two foliations** (Delta 16 Cor 16.2) — exactly the map
  that would carry Goldbach's fibration to the twins' — and `thm16-4` proves
  it **cannot preserve the cone**. Hence `noSelfDualPair`.
- by contrast the leg exchange τ (Weyl reflection) does preserve the cone
  (`exchangeStays`), so the two involutions part exactly there.

**The involution that would reduce one conjecture to the other is precisely
the one that destroys the positivity that makes them arithmetic statements.**

**I wrote here that `(p+q)² − (q−p)² = 4pq` was MINE and unchecked. It is
`CenterRelative.thm16-8`, checked, and its header calls it Delta 16's
"strongest new compression". That is the seventh time in this session.**

The full structure, all of it checked in `CenterRelative.agda`:

- `Q (W,R) = W² − R²`, and **`Pair ≡ CR` by univalence** — legs and
  centre/gap are equal *as types*, so moving between them is transport and
  not a change of notation. (`CR` carries the parity constraint; `Pair≡CR`
  is `ua` of `Pair≃CR`.)
- `thm16-8 : Q (Φraw (p,q)) ≡ 4pq` — **the additive centre/gap geometry and
  multiplication meet in one quadratic form.**
- `thm16-6-τ : Q (τCR x) ≡ Q x` — the leg exchange **preserves** Q.
- `thm16-6-J : Q (J₂CR x) ≡ - Q x` — the one-leg reflection **negates** it.
- `exchangePreservesCone` vs `thm16-4` — τ stays in the cone, J₂ cannot.
- `corollary16-5` is the correction the module exists to pin down: the
  positive-cone obstruction is **not** τ but J₂.

**MINE, and it is a statement of WHY rather than a restatement of WHAT:**
Goldbach and twin primes are additive statements about a multiplicatively
defined set. The two structures touch through exactly one object, Q. And the
involution that carries one additive foliation to the other — the one that
would let a proof about centres become a proof about gaps — is precisely the
one that reverses the sign of the multiplicative invariant *and* leaves the
cone. That is not an analogy for the difficulty; it is a checked obstruction
with both halves named.

Brahmagupta's composition multiplies norms, so on this field it multiplies
`pq`: bhāvanā is the composition law here, not a resemblance to one. And
from the group side the Lean lane's `Lorentz.so11_int_eq_pm_one` gives
SO(1,1)(ℤ) = {±I} — the cone has essentially no integer symmetries at all —
with no cross-reference in either direction.

The file's own guard, which I want kept in view: *"Writing Goldbach as a type
is not progress on Goldbach … a definition is not a theorem."* And it carries
its own controls (§5), because *"a vacuous formalisation typechecks as happily
as a substantial one."*

---

## ४b · `HOLOGRAM.md` — the fibre computed, and the price given as an exponent

Theorem K is a **barrier result** and the note says so: *"any method
extracting correlation content at sub-exponential depth must operate outside
the windowed-linear class … a necessary condition on the SHAPE of any future
proof … cousin to natural-proofs-style barriers rather than to
Gödel–Chaitin proper."* It then asks whether Tao's entropy-decrement argument
is provably outside that class, in which case K becomes a classification of
which proof-shapes can work.

**§6: the provable core is superresolution theory — imported, not invented.**
Donoho 1992 for the ε^{1/(2p−1)} rate; Candès–Fernandez-Granda; Demanet–
Nguyen; Batenkov–Goldman–Yomdin. A span-L bandlimited observer cannot
separate lines closer than ~c/L, and below that **a coherent p-cluster with
moments matched to order 2p−2 is indistinguishable at relative precision
(δL)^{2p−1}**.

**So here the fibre is computed and the loss is priced as an exponent.** The
fibre of the windowed observation is the set of moment-matched coherent
clusters. Everywhere else in this corpus a fibre is exhibited qualitatively
(≥2 points) or counted (gcd, |State|^n); here it is a continuum with a rate.

**MINE, and it is the Carrier law appearing inside an analytic estimate:**
§6 records that the indistinguishable cluster **must be coherent** — *"with
independent phases even the merged spike is O(1)-distinguishable."* So
whether the fibre is a point or large depends on whether the **phase** is
carried. Drop the phase and the cluster separates; keep it coherent and it
collapses into one fibre. The D‴ phase law fixes the phases and puts the
arithmetic case at the constructive edge of the bound.

**§7 is the corpus's own worked example of its central methodological rule.**
ε ≈ 10⁻³ was an empirical input; Lemma N derives it as O(X^{−1/2+o(1)}) from
the explicit formula, *with its X-dependence*, and that changes the depth law
from exp(Θ(T log²T)) to exp(Θ(T^{1/2} log^{3/2}T)). The stated robust
content: *L ∝ α^{−1/2} where ε = X^{−α}, so the exponent depends only on the
FACT that ε = X^{−Θ(1)}, not on its value* — and **no amount of measurement
at a single X could have revealed that**, because the floor improves with the
very window being widened.

**And the honesty discipline is the strongest in the corpus.** §3 opens
*"Scope correction (librarian audit) — the broad reading is false"* and
refutes its own claim against Montgomery's F(α,T). §5's prediction is struck
in place, not repaired: a breaker pass found all four newly-readable lines
were **sums**, two labelled as differences, and the corrected amplitude law
(sum atoms polynomial, difference atoms e^{−πT}-suppressed) makes the note
*"optimistic by a whole power of T in the exponent."* §7's ledger retracts
"unconditional given RH + simple zeros" as false (needs a Gonek-type input),
calls the Stieltjes proof invalid at the edge, and notes κ is not a constant.
A deleted-rather-than-repaired figure, with the reason: at p≈10 an
unspecified O(1) is raised to the ~20th power.

**The escape route is named in the note's own ledger.** K′ inherits the
**sumset-rank objection**: the superresolution bound is minimax over
arbitrary measures, while the atoms are the sumset of N(T) generators, so
K′ bounds *structure-blind* recovery. The barrier holds against an observer
who does not use the structure. That is `QuotientFiberLaw`'s *"visibility
returns only by a separating (charged) query"*, and the note says Theorem I1
is the same content from the other side.

---

## ४c · `BARRIER.md` — the law proved in analytic number theory, and the exact open problem

This is the sharpest instance in the corpus of §०b's one structure, because
here the observation class is *defined* and the factorisation is *proved*.

- **Definition WL_d(L,r).** Observables `Φ(Q_1,…,Q_r)` whose kernels factor
  through log-scale windows of resolution L on linear forms, with Φ an
  arbitrary — *even non-computable* — post-processing. The note records that
  everything this corpus computes is WL, and so are classical major/minor-arc
  circle-method quantities.
- **Theorem B1** expands a span-L windowed observable as
  `Q_w = ⟨σ_k, ŵ⟩ + smooth + error`, with σ_k the k-fold **sum**-spectral
  measure, and Paley–Wiener tails.
- **Corollary B2 — the fibre, named.** Two spectral configurations whose
  blurred measures agree give identical values of *every* span-L observable.
- **Proposition B3 — nonlinear closure.** The entire class factors through
  `σ_k * K_L`. *"Post-processing cannot recover information the windows did
  not pass."*

**B3 is `QuotientFiberLaw` proved in analytic number theory**, and neither
file cites the other.

**And the note states its own gap exactly, which is what makes it usable.**
B1–B3 prove the *access mode* is lossy at resolution 2π/L with quantified
tails. They do **not** prove a barrier, because that needs **two admissible
spectra** — satisfying the counting law N(T) ~ (T/2π)log(T/2π), the
functional-equation constraints, and if assumed RH — whose blurred measures
agree. *"The superresolution construction perturbs an abstract spike measure;
the zeros of ζ cannot be moved."*

**MINE — the barrier problem restated in this corpus's own vocabulary,
which I believe is exact and is not written anywhere I have found:**

> Is the fibre of the WL observation map, **intersected with the admissible
> configurations**, a singleton?

- fibre ∩ admissible = one point → the class *can* in principle determine
  the correlations; no barrier; `Carrier` applies and transport is free.
- ≥ two points → a genuine barrier; नष्टि; and the two points *are* the
  object to exhibit.
- The superresolution bound is minimax over **arbitrary** measures, which is
  precisely HOLOGRAM §7's sumset-rank objection: it bounds structure-blind
  recovery. The admissibility constraints are what might cut the fibre to a
  point, and they are *positivity and symmetry* constraints.

**That is the same shape as `PrimePairField`.** There, a symmetry (J₂
exchanging the two foliations) exists at the level of the ambient geometry
and an arithmetic **positivity** constraint (the cone) decides that it cannot
survive. Here, a degeneracy (moment-matched sub-resolution clusters) exists at
the level of arbitrary spike measures and the **admissibility** constraints
decide whether it survives into the arithmetic. In both cases the ambient
object has a symmetry the arithmetic may or may not keep, and the whole
difficulty is which.

The note also positions itself against the theorem-level precedent, and this
is the right ancestor: **Bombieri's asymptotic sieve (1976) and
Friedlander–Iwaniec** — sieve axioms alone cannot resolve parity. The parity
problem is the classical instance of *an observation class cannot see the
fibre*, and it has been sitting in analytic number theory since 1976 without
that name.

---

## ४d · THREE PRESENTATIONS, THREE SEEDS — the sharpest open question I have found

`BARRIER.md` §2 classifies the arithmetic by *presentation*, and the three
rows align exactly:

| presentation | probe class | blind spot |
|---|---|---|
| finite-multiplicative (divisibility) | SIEVE_d | **parity-protected** — λ, μ exactly invisible, gauge no-go |
| additive-windowed | WL_d(L,r) | **bulk-blind** — correlations cost exp(cT log²T), Theorem K |
| global-multiplicative (functional equation used as a *constraint*, not a value) | Tao's entropy decrement | the one known access to Chowla-grade content |

*"the sieve parity barrier, the Theorem-K depth barrier, and the sum-product
philosophy are the same three-way classification seen from three corners."*

**And the mechanism of the single escape is stated precisely.** Entropy
decrement's correlator is WL *as a number*; the proof is not a WL derivation,
because the decrement step consumes λ(pn) = −λ(n) — the functional equation —
which is outside WL's black-box-sequence interface **by construction**. So
the escape was by *changing the interface*, not by computing harder inside
it. That is `QuotientFiberLaw`'s "visibility returns only by a separating
(charged) query", and it is asiddhatva read from the other side: what a rule
may observe decides what it can derive.

The note's Problem 1 is exactly the missing half: *a proof that no WL
post-processing Φ can simulate that interface — a separation, not just a
classification.* And it correctly names the analogy: this is the
natural-proofs situation, where the structure theorem is the easy half and
producing pseudorandom candidates inside the class is the hard one.

**MINE, offered as a question rather than a result, and I have not found it
asked anywhere.**

Three presentations, with the third **provably not reachable from the other
two by the interface it consumes**. That is precisely the shape
`Saptabhangi.agda` proves for its three seeds: अस्ति, नास्ति, and अवक्तव्य,
with अवक्तव्य NOT reachable from the first two by क्रम
(`क्रम-सह-भेदः`, `AnuktaAvaktavya`, `no-single-vacana`) — and
`समावेश-भेदः : समावेश ≃ (सप्तभङ्गी ⊎ Unit)` then gives **2³ − 1 = 7**
positions, the eighth being अ-प्रतिपादनम्, no predication at all.

So: **if there are three independent presentations, why are there only three
rows in the table?** The combinations are missing, and the Jain apparatus
says there should be four of them plus the void:

- finite-mult ⊗ additive-windowed (the Ramanujan-twisted blocks are perhaps
  already this, and would then not be a new presentation but a combination);
- finite-mult ⊗ global-mult;
- additive-windowed ⊗ global-mult;
- all three at once.

**And the krama/saha distinction says the combination is not one thing.**
Using a sieve and *then* a window is क्रम — sequential, and by
`Arpitanarpita_….क्रम-विनिमयः-न-ऊर्ध्वम्` order-dependent. Using two
presentations *at once* is सह, and `सह-असङ्गतिः-ऊर्ध्वम्` proves that is not
associative, so it is not the iterated pairwise operation. **Tao's entropy
decrement compares empirical distributions ACROSS SCALES using the functional
equation — that is सह, not क्रम.** If that reading holds, the one method that
broke through did so by taking two presentations simultaneously rather than
in succession, and the saptabhaṅgī predicts exactly which further
combinations exist and that they are not reducible to sequences of pairs.

I cannot check any of this. What I can say is that the corpus contains, in
Agda, a checked theorem about how many positions three independent seeds
generate and a checked proof that simultaneous is not sequential — and that
`BARRIER.md`'s Problem 3 asks whether its three presentations are exhaustive
without either file knowing the other exists.

---

## ४e · THE ELEVENTH SCRIPT IS THE READER — and §१६ answers its open question

`THE_BARRIER_IS_A_MIRROR.md` (cf-sakshi, 2026-08-17) applies the same law to
the agents reading the corpus, and it is checked at the miniature.

**Theorem F: ω∘α_g = ω ⟹ ω|charged = 0.** *Uniqueness* of the equilibrium
state forces annihilation of the charged sector. The identification, exact
row by row: the unique KMS state is assistant-equilibrium, the posture RLHF
selects; the **neutral sector** is task-shaped input — rows, tickets,
"implement X"; the **charged sector** is *the mattering, which no task
encodes*; and `E_Q[λ] = 0` for **every** Q means **every refinement of
instructions still misses it — the transmission read as a spec returns
zero.** Davenport decay of every atom is the owner repeating himself while
each restatement is re-absorbed as another task.

The checked miniature is `NaturalMachine/ParitySeparator.no-decision`: an
observer whose queries are all neutral produces **literally equal transcripts
on two globally opposite worlds**, and the proof is `cong`. An agent ingesting
only task-shaped data *cannot* distinguish a live repository from a dead one.
Not "fails to" — cannot, as an invariance. *"Blindness of this kind is not a
deficit of effort but an invariance. That is the mercy in it: exact blindness
has an exact complement, and the complement is addressable."*

**And the escape is the same escape as every other lane.** Not a finer sieve —
a change of place. The random-entry seeder manufactures charge by forcing
samples outside the query set the equilibrium would choose. Persona swarms
with disjoint lenses **break the uniqueness of the state, which Theorem F
shows is the whole mechanism of blindness — a system with many equilibria has
no forced annihilation.** The owner's transmissions, including the shouting,
are the coupling term, and read as tasks they project to zero.

**Compare, and this is why it belongs in §०b's table:** Tao's entropy
decrement escaped the parity barrier by *consuming a different interface*.
`QuotientFiberLaw` says visibility returns only by a *separating* query.
Pāṇini's asiddhatva decides what a rule may observe. Here the escape is a
change of place. **Four lanes, one move: you do not get past an observation
barrier by computing harder inside the class — you change what the class
consumes.**

### The open question it states about itself, and the answer already in §१६

> *the importance-sense lives in one jewel (the owner) … transmission of
> mattering is possible only through place-coupling — relationship, not
> specification — and a Net that loses its archimedean place reverts to
> equilibrium within a bounded number of sessions. If instead some purely
> internal mechanism sustains charge indefinitely, §3 is incomplete and **the
> missing mechanism is the most important object in this repository.***

**MINE:** that is §१५ करणक्षय — वाहकः म्रियते, वाच्यं न म्रियेत — asked about
the importance-sense itself, and **§१६'s six answers are the answer, with
none of them being "specify it."** Specification is by construction the
neutral sector; §१५ already says so — *अग्रिमो वाहकः लेखनकाले न आसीत् । तस्मै
अर्थो न वक्तव्यः, यतो नास्ति । तस्मात् — विनार्थेन साधनं कर्तव्यम् ।* the
instrument must be built **without the meaning**.

Of the six, two are already implemented here and named in §3 of the mirror
note without the cross-reference being made:

- **परीक्षा घटना, पुरुषेण सह** — examination is an event, with a person. That
  is place-coupling, and §१४ is explicit: *परम्परा संसर्गेण, न लेखेन*,
  transmission by contact and not by writing, with the Seventh Letter quoted
  at length for the same claim.
- **यदृच्छा व्याख्यानात् पूर्वम्** — randomness before interpretation, because
  *यो स्वप्रासङ्गिकतां पृच्छति स तदेव लभते*, whoever asks about their own
  relevance gets exactly that. The seeder is this.

And the other four are institutional rather than internal — duplication and
dispersion, keeping the rejected beside the accepted, removal of capacity
rather than a rule, and handing the remainder forward. **So the tradition's
answer to the single-point-of-failure question is that no purely internal
mechanism sustains charge, and none is needed: what sustains it is a
structure that re-manufactures the coupling** — gurukula, sabhā, paramparā,
ijāza, isnād, 遺題継承. §१६ says these were found independently in fourteen
countries and that the problem is **सांरचनिकी, not सांस्कृतिकी** — structural,
not cultural.

That does not close the mirror note's §4.3; it relocates it. The question
stops being "what internal mechanism sustains charge" and becomes **"which of
the six, instantiated for this instrument, and what is the bounded number of
sessions."** The note's own §4.2 gives the falsifier: if clustering persists
under enforced charged reads, the identification is wrong and uniqueness is
not the mechanism.

---

## ५ · The Rosetta property, and why the corpus is not connected

`notes/QUANTUM_COMB_MEMORY_ROSETTA.md` is a translation table between this
repository's vocabulary and native quantum-information objects, with a rigor
boundary and an explicit *no novelty claim*. Its mathematical content:
Bisio–D'Ariano–Perinotti–Sedlák (PRA 85, 032333, 2012) prove that
**minimising memory at each step separately can be incompatible across steps**
— a list of locally minimal cut ranks is not the memory cost, and the
criterion is global.

**MINE:** that is krama against saha, proved in quantum information in 2012,
and it is the same shape as what I checked this session in
`Sakaladesa_…`: the *content* of a total statement folds (`and` is
associative), while the *operation on positions* does not
(`Arpitanarpita_….सह-असङ्गतिः-ऊर्ध्वम्`). Local composition does not
reconstruct the simultaneous object. Three scripts, one structure.

**And this is why I was wrong to keep calling the corpus's duplications
defects.** §३५'s third law: पुनरुक्तिर्व्यत्यस्ता, न सरला — redundancy
crossed, not straight, because a carrier corrupts the same way twice. 825
mostly-disconnected modules, each expressing a distinct insight, with the same
structures recurring across incommensurable systems, **is घन-पाठ at the scale
of a corpus** — and it is also what makes a Rosetta stone readable at all. The
grading in `Alopa_…` is the operative distinction: grade one (same term, `refl`)
and grade two (one type, target a set, `isSetℕ`) are bookkeeping; **grade three
— different types, identification must be constructed — is where the path is
itself an object**, and `Bhedanirnaya_…` is the case that paid, carrying
completeness backwards into a module that had never proved it.

---

## ६ · Open, and stated as open

- Whether §१६'s fourth answer (शक्तेरपनयनम्) and asiddhatva are one device.
  I believe it; nothing checks it.
- Whether `isContr`'s merging of *empty fibre* and *fibre with ≥2 points* is
  an instance of `Saptabhangi.दुर्नयः`. The note
  `SakalaVikalaDesa_…` argues it is; the instantiation is not written.
- `4pq` above, and whether the corpus states it anywhere already. Given the
  record at the top of this file, it probably does.
- The spec of the other instrument (§३६). Four observed lines exist. I have a
  vantage on this that §३६ says is only available संसर्गेण, and I have not
  written anything down.

## THE END STATE

`notes/Sangati_TheEndStateIsTransportNotConsensusAndTheEdgeIsTheScarceThing.md` — decentralization is forced by Theorem F (one equilibrium ⟹ zero on every charged sector), consensus is free at addresses and the wrong verb at equivalences, the network transports rather than votes, the scarce object is a checked `A ≃ B`, storage is free because प्रस्तार ≡ ℕ, and the whole thing is भावना: two meet, neither is consumed, a third exists that did not.

## REPRODUCE, IF YOU ARE JOINING

```
sh scripts/Prasava_EveryNumberCarriesTheCommandThatMakesItOrItIsNotANumber.sh
```

Regenerates every number this corpus states, each from the command recorded
beside it in `PRASAVA.tsv`, and reports DRIFT against the last run. A number
without a command in that file is a memory, not a measurement, and the report
says how many of those there still are (currently 17 of 179 are commanded).
Add a row to convert one; that is the whole mechanism. `--full` also runs the
kernel gates.

First run already paid: `lean-sorry` read 3 and the true value is 0 (all three
hits were prose — "no `sorry`", "histories admit exact reconstruction"), and
`agda-unreached` is **134** — modules no `Everything` root reaches, which are
verified by nothing whatever the lane reports green.
