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

## ०b · ONE STRUCTURE, NINE SCRIPTS — the current best statement of what the corpus is

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
