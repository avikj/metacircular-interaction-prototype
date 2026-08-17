# A map of what to read: Indic formal traditions against this repository's live objects

**Author:** reading/ingestion pass, 2026-08-14.
**Type:** source map and naming audit. **No new mathematics. No new framework.
No claim of historical priority for anything.**

**What this note is.** A list of technical content in the Pāṇinian, Buddhist
pramāṇa, Navya-Nyāya, Kerala, and Āryabhaṭan traditions that bears on objects
this repository actually has, with the exact modern counterpart where one
exists, the reconstruction literature, whether an implementation is
git-reachable, and a blunt verdict on whether this repo's use of each name is
earned. It is a **map of what to read**, not a reading.

---

## 0. The channel, stated first because it bounds every sentence below

`WebFetch` is `EGRESS_BLOCKED` on every host tried (no Wikipedia, no archive,
no journal, no nLab, no arXiv full text). `WebSearch` works and returns
**search summaries only**. Therefore:

> **No primary text was read for this note. No secondary text was read for
> this note. Every non-repository claim below is śabda — testimony at
> search-summary grade — and several are testimony about testimony.**

This is a severe limitation on a task whose whole content is primary sources,
and it is the reason the deliverable is a reading list rather than an
interpretation. Grades used:

| tag | meaning |
|---|---|
| `[REPO]` | verified by reading files in this repository during this pass |
| `[ŚABDA]` | search-summary only; title/author/claim as reported by a search engine, source not opened |
| `[ŚABDA²]` | search summary reporting what a source says about a third source |
| `[MINE]` | my structural judgement, derived from the above; not sourced, and flagged wherever it appears |

Verse and section numbers below are **attributions carried from search
summaries or from prior repository notes**, not verifications. A sūtra number
quoted here has not been checked against a critical edition by me.

---

## 1. Pāṇini's Aṣṭādhyāyī as a computational artifact

### 1.1 The mechanisms, and the exact modern counterpart

| Pāṇinian mechanism | locus `[ŚABDA]` | what it does | exact modern counterpart | identification is |
|---|---|---|---|---|
| **utsarga / apavāda** | doctrine, not one sūtra; ranked in commentarial tradition | a rule whose input class is a proper subset of another's blocks it | **the Elsewhere Condition** (Kiparsky 1973, who coined the term *from Pāṇini*); Sanders' Proper Inclusion Precedence; specificity-based dispatch (CLOS most-specific-method, Prolog clause order, priority in default logic) | **EXACT, and historically transmitted** — this is not a resemblance, it is the same principle carried into linguistics under a new name by a scholar reading Pāṇini |
| **śiva-sūtra / pratyāhāra** | the 14 initial sūtras; `a i u ṇ …` with the `it` markers | encodes the natural phoneme classes as **intervals in one linear order**, so any class is named by two letters | **an interval representation of an intersection-closed set family over a linear order** (consecutive-ones / interval-hypergraph representation). Petersen 2004, *A Mathematical Analysis of Pāṇini's Śivasūtras*, JoLLI 13:471–489, proves **optimality** of Pāṇini's ordering from the Hasse diagram of the intersection-closure alone, with no phonological input `[ŚABDA]` | **EXACT, and there is a theorem** — this is the one item on this page that is already a proved statement of the kind this repo demands |
| **tripādī / asiddha** | `8.2.1 pūrvatrāsiddham` `[ŚABDA]` — the last three quarters | rules of the final block are **non-existent with respect to** the preceding ones: their effects do not become visible to earlier rule conditions | **a compiler phase boundary**: a later pass's rewrites do not feed back into an earlier pass's guards. Two-stage compilation with a frozen prior stage | **EXACT** as a phase distinction. What is *not* settled is the precise scope of "asiddha"; Kiparsky, "What is siddha?" (1987) is the standing question `[ŚABDA]` |
| **asiddhavat** | the block `6.4.22–129` `[ŚABDA]` | inside the block, all rules read the **entry state**, apply, and the block exits | **snapshot / bulk-synchronous parallel rewriting** — precisely the semantics of one round of a stratified Datalog stratum, or a simultaneous-substitution round. Goyal–Kulkarni–Behera implement exactly this and call the mechanism a **"filter"** `[ŚABDA]` | **EXACT**, and already implemented by others |
| **anuvṛtti** | pervasive; e.g. terms of `1.1.56` carry into `1.1.57`, `1.1.59` `[ŚABDA]` | a term stated once continues into following sūtras until cancelled | **inherited context / scoped default binding**; in the derivational (not notational) direction, an inherited attribute | **NEARLY exact for the notational function**; for the derivational function the repo has already proved the correction — see §1.4 |
| **adhikāra** | governing headers, e.g. `3.1.1`, `3.1.2` `[ŚABDA]` | a heading rule whose domain governs an entire following block | **a `Section`/`Variable` block distributing a parameter over its contents** (Coq `Section`, Agda parameterised `module`) | **EXACT.** This one is uncomfortably close: an adhikāra *is* a module header |
| **sthānivadbhāva** | `1.1.56 sthānivad ādeśo 'nalvidhau` `[ŚABDA]` | a substitute counts as the original **for subsequent rules — except rules conditioned on the phonemes themselves** (`anal-vidhau`) | **an abstraction barrier with an explicit exception for representation-inspecting clients.** The substitute inherits the original's *designations* (interface) but not its *form* (representation). This is a parametricity/representation-independence statement, not blanket transparency | **EXACT, and sharper than the modern folklore version** — see §6.1 |
| **vipratiṣedha** | `1.4.2 vipratiṣedhe paraṃ kāryam` `[ŚABDA]` | resolves conflict between rules of equal strength | *classically* "the later rule in serial order wins" = textual-position priority in an ordered rewrite system. **CONTESTED**: Rajpopat (Cambridge PhD, published 2022-12-15, *In Pāṇini We Trust*) argues the metarule means **the rule applicable to the right-hand-side operand wins**, and that the serial reading is a 2,500-year misreading `[ŚABDA]` | **DISPUTED — do not cite "later rule wins" as settled.** The task brief that produced this note asserted it as fact; that assertion is exactly what Rajpopat contests |

Traditional strength ranking, as reported by search summary of the commentarial
tradition and of Kiparsky `[ŚABDA]`, weakest to strongest:

```
para  (later)  <  nitya  (persistent)  <  antaraṅga  (internal)  <  apavāda  (exception)
```

### 1.2 Two claims to *not* repeat

- **"Aṣṭādhyāyī = BNF."** Ingerman, *"Pāṇini-Backus Form" suggested*, CACM
  10(3):137, 1967, proposed renaming BNF on priority grounds `[ŚABDA]`. But
  the Pāṇinian formalism is **strictly more powerful than context-free**: it
  is context-sensitive, marker-driven, and has a metalanguage `[ŚABDA]`. So
  the equation is a naming proposal that *undersells* the source. Ingerman's
  suggestion is a citable historical fact; "Pāṇini invented BNF" is not a
  theorem.
- **"Aṣṭādhyāyī = Turing machine."** Widely repeated in popular sources
  `[ŚABDA]`, with a gesture at Post's rewriting systems. **No theorem was
  located.** Treat as unverified. The honest statement is the one above: a
  priority-ordered, marker-controlled, phase-separated rewriting system.

### 1.3 Scholarly reconstruction literature `[ŚABDA]`

- **Kiparsky** — "Elsewhere in phonology" (1973, coined the Elsewhere
  Condition); "What is siddha?" (1987); "On the Architecture of Pāṇini's
  Grammar" (2009 — this is the source the repo's own `runtime/panini/` cites
  for the four-principle ranking).
- **Cardona** (1965 onwards) and **Staal** (1965) — the founding formalization
  lineage, with emphasis on context-sensitive metarules.
- **Joshi and collaborators** — the *siddha-principle* and *generalized
  blocking*, a modern reduction of the four principles to two.
- **Scharf** — Sanskrit Library; encoding and formal representation.
- **Amba Kulkarni** — "Computer Simulation of Aṣṭādhyāyī: Some Insights"
  (with Goyal, Behera) and "Asiddhatva Principle in Computational Model of
  Aṣṭādhyāyī"; the repo's `PANINIAN_DERIVATION_IS_NOT_ENDPOINT_REWRITING.md`
  already cites her for `it` markers, anuvṛtti, and the warning that **a
  sequential subroutine is not automatically a faithful representation of
  asiddha scope**.
- **Gérard Huet** — the Zen toolkit and the Sanskrit Heritage Platform.
- **Hyman** (2009) — a finite-state transducer over reframed Aṣṭādhyāyī rules
  `[ŚABDA²]`.
- **Bronkhorst**, "A History of the Mahābhāṣya" — the Pāṇini/Patañjali
  disagreement about what a derivation *is*; already load-bearing in this repo.
- **Rajpopat** (2022) — the `1.4.2` reinterpretation, plus (per the repo's
  own `runtime/panini/conflict.py` header) an explicit same-operand /
  different-operand split.

### 1.4 Implementations, and whether they are git-reachable

| project | what it is | reachable | note |
|---|---|---|---|
| **`ambuda-org/vidyut`**, crate `vidyut-prakriya` | Rust; a **prakriyā generator** implementing ~2,000 Aṣṭādhyāyī rules, returning for each generated word the **list of rules used and their intermediate results**; ~50k words/sec single-thread; long-term goal is the complete Aṣṭādhyāyī | **YES — `github.com/ambuda-org/vidyut`**, `docs.rs/vidyut-prakriya`, demo "Vidyullekha" | `[ŚABDA]`. **This is the most important reachable artifact on this page.** A rule engine that emits its own derivation trace is, structurally, a proof-term-emitting rewriter |
| **Heritage Platform** (Huet) | OCaml; phonology, morphology, segmentation, shallow syntax over a structured lexicon; sandhi inversion | **YES — `gitlab.inria.fr/huet/Heritage_Platform`**, resources at `.../Heritage_Resources` | `[ŚABDA]` |
| **`sanskrit/ashtadhyayi`** | data, not an engine: sūtra text, padacheda, **anuvṛtti**, **adhikāra**, commentaries, as markdown + YAML | **YES — `github.com/sanskrit/ashtadhyayi`** | `[ŚABDA]`. The anuvṛtti and adhikāra files are a machine-readable scope table |
| Goyal–Kulkarni–Behera asiddhavat model; PAIAS ("Aṣṭādhyāyī Interpreter As a Service") | published models | **not located as git repos** | `[ŚABDA]` |
| **A mechanized Aṣṭādhyāyī in a proof assistant** (Coq/Agda/Isabelle) | — | **NONE LOCATED** | searched; only CFG-theory formalizations turned up. If this is empty, it is an open niche, and it is in this repo's substrate |

### 1.5 Verdict on this repo's Pāṇinian names

- **`notes/PANINIAN_DERIVATION_IS_NOT_ENDPOINT_REWRITING.md` — EARNED.** It
  cites Bronkhorst for the *bhavati*/*bhavatu* contrast, proves a
  fiber-constancy criterion, refuses to call the result an attribute grammar,
  and records the reverse translation and residual. This is the standard.
- **`runtime/panini/conflict.py` — EARNED as a mapping, and the mapping is
  unusually honest**: it implements `para`, `nitya`, `antaraṅga`, `apavāda`
  as exact predicates over a first-order TRS, cites Kiparsky 2009 for the
  ranking, and **enforces three disanalogies in code** (apavāda restricted to
  the same position; antaraṅga abstains on disjoint redexes; nitya evaluated
  dynamically by actually firing the competitor). It explicitly disclaims
  being Pāṇini's principles. **But** the lane is quarantined, it is Python
  (banned), and its payoff is stated as a *"measured contest against ordinary
  strategies"* — which is exactly the genre `CLAUDE.md` forbids. The four
  predicates are the content; the benchmark is not. If this lane is revived,
  it should be revived in Agda as four predicates plus a **theorem** about
  which normal forms the priority order reaches, not as a contest.
- **`collab/journals/codex-panini.md` — EARNED.** The lane grounded a source
  comparison and turned it into an exact residual (inherited derivational
  control state). Named for what it did.

---

## 2. Apoha (Dignāga, Dharmakīrti)

### 2.1 What the tradition holds `[REPO, quoting the repo's own source-checked note]`

`notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` is the repository's live apoha
object and it is already source-critical. From it:

- **Dignāga**, *Pramāṇasamuccaya(vṛtti)* V.2–11: the word's referent is **not**
  the individual (`bheda`), **not** the genus (`jāti`), **not** their relation
  (`sambandha`), **not** the genus-bearer (`jātimat`/`tadvat`). V.11:
  `tenānyāpohakṛc chrutiḥ` — an expression **effects exclusion of others**.
- **Dignāga**, PS(V) V.25cd–38: **the scope of "other" is not uniform.**
  Synonyms need not exclude one another; sub- and superordinate terms interact
  **asymmetrically**; incompatible coordinate terms exclude directly.
- **Dharmakīrti**, *Pramāṇavārttika* I.115–121, III.165–173 and the
  *Svavṛtti*: different particulars **cause the same cognition**; the cognizer
  separates causes-of-this-cognition from causes-of-another; the appearance of
  sameness is **error**; the word is connected by its occurrence for some and
  non-occurrence for others; if convention did not exclude the other, later
  **activity** would fail to avoid non-instances.
- Verbal cognition is treated by Dignāga **under inference** (`anumāna`), not
  perception. That is a technical placement, not a metaphor.

### 2.2 The exact modern counterpart — and the honest answer is *none located*

The popular gloss is **double negation**: "cow" = not-(non-cow) `[ŚABDA]`. That
gloss is what Dignāga's own scope analysis **defeats**: a Boolean complement is
taken in a fixed universe with a fixed partition, and V.25cd–38 says the
exclusion class varies with the term's position in a taxonomy (synonym,
coordinate, super/subordinate). So:

> **Apoha is not Boolean complementation.** `[REPO]` The nearest *shape* is a
> complement relative to a position in a concept hierarchy, i.e. something
> closer to a relative pseudo-complement in a lattice than to `¬` in a
> Boolean algebra. **`[MINE]` — this is my structural reading, it is not
> sourced, and I could not locate anyone who has done it rigorously.**

**Searched for, NOT FOUND:** a rigorous formal reconstruction of apoha —
Boolean, lattice-theoretic, formal-concept-analytic, or type-theoretic. The
standard scholarly collection is **Siderits, Tillemans & Chakrabarti (eds.),
*Apoha: Buddhist Nominalism and Human Cognition*, Columbia UP, 2011, 333pp**
`[ŚABDA]`, which approaches apoha through history, philosophy, and **cognitive
science** — not formal semantics. **Hayes** and **Katsura** are the names for
the negative-statement / scope side; **Katsura**'s study of V.25cd–38 is what
the repo's note relies on. There is a 2018 *Religions* paper relating
Pratyabhijñā apoha to Shannon–Weaver information and Saussure `[ŚABDA]` —
listed for completeness, and its shape (information theory as a metaphor for
exclusion) is the failure mode this repo is trying to avoid, so treat with
suspicion until read.

**This absence is itself the finding.** Apoha is one of the few places where
the traditions have a live technical dispute (Dignāga's scope account vs.
Dharmakīrti's causal/error account) that has **not** been reduced to a modern
formalism. That is a reason to read it, not a reason to skip it.

### 2.3 Verdict on `Obstruction.agda` — the premise of the question is false

**`formal/cubical/NaturalMachine/Obstruction.agda` does not name itself after
apoha.** `[REPO]` I read the file. It contains no occurrence of "apoha",
"exclusion", "Dignāga", or "Dharmakīrti"; neither does
`notes/OBSTRUCTION_AGDA_PLAN.md`. "Obstruction" there is the ordinary
mathematical word, and the module's `Obstruction` record is *the residual of a
failed match* — a term-rewriting notion, sourced to
`runtime/vocabulary/README.md` §7.

So there is **nothing decorative to strike** — but there is a trap to name.
The `Obstruction` record *is* a negative object (the uncovered head, the thing
not in the vocabulary), and it would be very easy for a future lane to reach
for "apoha" as its Sanskrit label. **Do not.** By the repo's own note, an
untyped complement of a pre-given set is exactly what Dignāga's scope analysis
refuses; `Obstruction`'s residual is drawn from a fixed finite vocabulary
list, which is precisely the pre-given universe apoha denies.

- **`notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` — EARNED, by refusal.**
  It withdrew its own coined `ProbeWarrant` sum type after the sources
  resisted it. A note whose contribution is a struck construction is worth
  more here than three that survive.
- **The handle `codex-apoha` — DECORATIVE, and harmless.** `[REPO]` Its
  filed result (msg 0274/0279, "closed reversibility is relative to what must
  remain visible") is about syntactic transformation monoids and predictive
  quotients and uses no apoha content whatsoever. Handles are labels, not
  claims; the cost is zero as long as nobody later cites the handle as
  evidence that the tradition was consulted. Same for `codex-catuskoti`,
  `codex-pratitya`, `codex-sahaja`, `codex-madhavi`, `opus-shesha`,
  `cf-sakshi`, `codex-vajra`, `codex-shilpin`, `codex-ananta`,
  `codex-anvaya`. **Rule: a handle is not a citation.**

---

## 3. Navya-Nyāya's technical language

### 3.1 What the tradition holds

Navya-Nyāya (Gaṅgeśa, *Tattvacintāmaṇi*, 14th c.; Raghunātha) developed a
**controlled technical Sanskrit** for stating relational structure without
variables `[ŚABDA]`:

| term | function |
|---|---|
| `pratiyogin` | the **counterpositive** — the relatum that is absent / the term a relation points from |
| `anuyogin` | the **subjunct** — the correlative relatum |
| `avacchedaka` | the **limitor / delimitor** — the mode or aspect under which a relatum is taken |
| `viśeṣaṇa` | the qualifier |
| `abhāva` | **absence**, itself a positive entity with a typed structure, in four kinds |
| `tādātmya` | non-extensional identity |
| `paramparā-sambandha` | chained relations of **unbounded depth** |
| `-tva` / `-tā` abstracts | property-abstraction operators, applied iteratively |

The repository's `ABHAVA.md` §1 states the operative point correctly `[REPO]`:
"pot-absence on the floor" has `pratiyogin` = pot and `avacchedaka` = pot-ness;
**change the limitor and you change the absence.**

### 3.2 The exact modern counterpart, and it is *dependent types*

This is the item where the reconstruction lineage is longest and where the
modern answer is most specific `[ŚABDA]`:

| author | formalism | what it recovers | what it loses |
|---|---|---|---|
| **B. K. Matilal**, *The Navya-nyāya Doctrine of Negation*, Harvard UP, 1968 | first-order logic | systematic translation of the arguments | dependency; typed absence |
| **Jonardon Ganeri** | higher-order logic | properties-of-properties, abstraction over predicates | **"HOL does not give dependency: an avacchedaka delimiting a pratiyogin is a type-level binder, not a free variable"** |
| **Sibajiban Bhattacharyya** | Martin-Löf type theory | **avacchedaka-as-Π**, typed pratiyogin | (per the newer paper) the remaining items below |
| **Mrityunjoy Panday, *Cubical Type Theoretic Navya-Nyāya*, arXiv:2605.12548** | CCHM De Morgan cubical type theory | claims to preserve **dependent delimitation (avacchedaka), typed absence (abhāva), non-extensional identity (tādātmya), unbounded relational depth (paramparā-sambandha)** simultaneously | — |

Also located: "The Logic of Late Nyāya: A Property-Theoretic Framework for a
Formal Reconstruction" (Springer) `[ŚABDA]`; Ganeri's SEP article
"Navya-Nyāya" `[ŚABDA]`.

**Git-reachable implementation: none located.** arXiv:2605.12548 was not
fetchable through this channel; whether it ships Agda is unknown.

### 3.3 Verdict on the `weaver` lane — PARTIALLY EARNED, at strictly lower resolution

`[REPO]` The lane's central statement is:

> "a mathematical claim carries an index, and the claim without its index is a
> different claim" — and, corrected by `claude_arithmetic_breaker`'s Theorem E,
> "an index is unobservable exactly when a symmetry group acts transitively on
> its value space" (sufficiency holds; necessity refuted).

The word `limitor` is used **correctly** as a gloss of `avacchedaka`, and
`ABHAVA.md` is honest about the status: row A2 of its own ledger says the
identification of avacchedaka with a scope on a universal is *"Mine, and a
reading. The tradition is not doing predicate logic and did not intend this."*
That is the right posture, and `ABHAVA.md`'s prior-art sweep of 2026-08-14
already found Matilal and arXiv:2605.12548 and recorded that its §2.1 is not a
first.

But be blunt about the gap:

> **The repo uses `avacchedaka` at the resolution of "a claim carries an
> index." The tradition's content is that the limitor is a *dependent binder
> over the relatum* — and, separately, that the avacchedaka of the
> `pratiyogitā` and the avacchedaka of the `anuyogitā` are distinct slots.
> Neither of these is used anywhere in the repo.** `[REPO + ŚABDA]`

And the concrete cost: the lane's own certificate,
`runtime/kernel/limitor_audit.py`, reports **0 originating limitor sites, 12
propagating, 39 unlimited** `[REPO]` — i.e. the limitor layer is inert. A
lane whose organizing concept is the limitor has no live limitor. The
tradition would say the `avacchedaka` slot is not optional; the code says it is
never filled. That is not a naming problem, it is a design finding, and it is
already in `THE_INDEX_IS_THE_SUBJECT.md` §3.

**Recommendation, blunt:** either (a) take the dependent-binder version
seriously — in Cubical Agda, which is where arXiv:2605.12548 says the
structure lives and which is this repo's declared substrate — or (b) drop the
Sanskrit and say "index." Using the word at a weaker resolution than the
literature is the failure mode `COGNITIVE_ORIENTATION.md` §6 names as
ornament.

---

## 4. Kerala school — established technical content only

`FIVE_FACES.md` §8 already handles Whish 1834, the contested transmission
thesis, and Almeida–Joseph. **Not relitigated here.** Recorded technical
content only `[ŚABDA]`:

- **Mādhava of Saṅgamagrāma** (c. 1340–1425): infinite series for **arctangent,
  sine, and cosine** — the first expression of trigonometric functions as
  series — and the series for π (Mādhava–Leibniz).
- **Mādhava's correction terms.** The π-series converges uselessly slowly, and
  Mādhava supplied **explicit correction terms** for the truncated series;
  these are given explicitly in the *Yuktibhāṣā*. Modern discussion:
  arXiv:2405.11134, "On Mādhava and his correction terms for the
  Mādhava–Leibniz series for π".
- **Second- and third-order Taylor approximations of sine and cosine; tests of
  convergence.**
- **Jyeṣṭhadeva, *Gaṇita-Yukti-Bhāṣā*** (c. 1530, in **Malayalam**, not
  Sanskrit): distinctive because it **contains the derivations and rationales
  (yukti)**, not only the results.
- **Nīlakaṇṭha, *Tantrasaṅgraha*** (1500); Śaṅkara Vāriyar's commentaries.
- **Modern critical apparatus:** K. V. Sarma's translation with explanatory
  notes by **K. Ramasubramanian, M. D. Srinivas, M. S. Sriram** — the search
  summary describes these notes as "the basis of modern work on these texts."

**The one line that bears on this repository, and it is not decorative:**

> `CLAUDE.md` says *"a correlation coefficient has no content; the content is
> the error term."* Mādhava did not stop at the series. **He gave the
> correction term.** `[ŚABDA]` The tradition this repo is being told to read
> already practised the exact discipline this repo's protocol enforces, on the
> exact object — a truncated series and its remainder.

**Repo naming verdict:** no module, note, or theorem in this repo is named for
Mādhava or the Kerala school. The handle `codex-madhavi` exists; handle, not
citation. **Nothing to strike, nothing earned — the tradition is simply
unused.**

---

## 5. Kuṭṭaka / vallī

### 5.1 What the tradition holds `[ŚABDA]`

- **Āryabhaṭa, *Āryabhaṭīya*, Gaṇitapāda verses 32–33 (499 CE)** — the whole
  algorithm, in two stanzas. `kuṭṭaka` = "pulverizer": the coefficients of the
  linear indeterminate equation are broken into successively smaller ones.
- **Bhāskara I, *Āryabhaṭīyabhāṣya* (629 CE)** — the algorithmic exposition of
  Āryabhaṭa's compressed verses; he calls it `kuṭṭakāra`.
- Refined by **Brahmagupta (628)**, Mahāvīra (850), Āryabhaṭa II (950),
  Śrīpati (1039), Bhāskara II (1150), Nārāyaṇa (1350).
- **It is the extended Euclidean algorithm**, and it is related to continued
  fractions. Historians credit Āryabhaṭa with the first solution of linear
  indeterminate equations `[ŚABDA]`.
- Also on the table for a future pass: the least-absolute-remainder variant
  (arXiv:cs/0604012, "The Aryabhata Algorithm Using Least Absolute
  Remainders") `[ŚABDA]` — a variant with a better step bound, i.e. exactly
  the kind of thing that would change a trace-length theorem.

`notes/KUTTAKA_SOLUTION_FAMILY.md` `[REPO]` states three facts as belonging to
the tradition and not to any later frame — **the answer is a family**
(`x + t·b/g`, `y + t·a/g`); **the vallī is a replayable trace kept as a
first-class object of practice**; **the section is a declared convention**
(the iṣṭa reduction to least positive). It also states plainly: *"no primary
text was fetchable from this container; the verse-level sourcing is owed, not
claimed."* That disclosure is correct and I could not improve on it through
this channel either.

### 5.2 Verdict on `formal/cubical/KuttakaValli.agda` — HALF EARNED, and the half that is missing is the kuṭṭaka

`[REPO]` I read the module. What it actually contains:

- `Valli = List R` — the quotient column as a **first-class syntactic object**;
- `L q = (q, 1, 1, 0)`, `replay` = the fold into 2×2 matrices;
- `replayHom` : concatenation is multiplication (vallī is a monoid morphism);
- `detReplay` : `det (replay v) ≡ (-1)^{|v|}`;
- `convergent` : appending `q` is the recurrence `p_n = p_{n-1} q_n + p_{n-2}`;
- `macroSound` : a repeated block replays to a power.

These are, exactly and correctly, **the continuant algebra of continued
fractions** — the matrix form of the extended Euclidean algorithm. The module
checks under `--safe`, and the framing "the vallī is a term, replay is an
evaluator" is a real and non-trivial choice: it treats the quotient column as
*syntax* rather than as loop state, which is the historically distinctive thing
about the vallī.

**But:** grep for `gcd`, `iṣṭa`, `solution`, `substitut`, `back` returns
**nothing**. The module has no gcd, no termination, no Bézout solution, no
back-substitution up the vallī, no inhomogeneous `c`, and no section
convention. **The pulverizing is absent.** The file would type-check
identically if renamed `Continuant.agda`, and nothing in it depends on
Āryabhaṭa.

> **Verdict: `KuttakaValli.agda` earns "vallī" and does not yet earn
> "kuṭṭaka".** The vallī-as-syntax framing is a genuine and defensible
> translation of the tradition's distinctive artifact. The name `Kuttaka`
> promises the solving of `ax − by = c` and the declared section, which live
> only in prose in `KUTTAKA_SOLUTION_FAMILY.md`. Two honest repairs, either
> acceptable: (i) rename the module to what it proves and keep `Kuttaka` for a
> module that actually solves and sections; or (ii) — better — **add the two
> missing theorems**: back-substitution as a fold over the reversed vallī
> producing a Bézout pair, and the iṣṭa reduction as an explicitly *imported*
> section. Both are ordinary structural inductions in the style already
> present, and (ii) would make this the first module in the repo where an
> Indian source supplies a theorem rather than a name.

---

## 6. The sentences worth having

### 6.1 sthānivadbhāva is an abstraction barrier with a declared leak

`A 1.1.56 sthānivad ādeśo 'nalvidhau` `[ŚABDA]`: a substitute behaves as the
original **except for rules conditioned on the phonemes themselves**. The
substitute inherits the original's grammatical **designations** — its
interface — but not its **form** — its representation. This is not blanket
substitution transparency; it is transparency **quantified over a class of
clients**, with representation-inspecting clients explicitly excluded.

That is precisely the shape of a representation-independence / parametricity
statement, and precisely the shape of the abstraction-barrier discipline in
module systems. `[MINE, on a `[ŚABDA]` reading of the sūtra]` A modern text
that says "substitution is transparent" states something *weaker and less
careful* than the sūtra, which carries its own exception clause in the word
`anal-vidhau`.

**Repo relevance:** `Obstruction.agda` T1 (`defining-equation`: the new head
unfolds by its body) together with T2 (`unfold-elim`: eliminability **at the
level of coverage**, explicitly *not* conservativity of a theory) is a
sthānivat-shaped pair — an abbreviation behaves as its definiens for one class
of clients and the module is careful to say which class. The module's own
header already performs the `anal-vidhau` move, in English, without knowing
the sūtra had a word for it.

### 6.2 the tripādī is a two-stage compiler and the repo has been reasoning about phase visibility without it

`A 8.2.1 pūrvatrāsiddham` makes the final block's effects **invisible to the
guards of everything before it**; `6.4.22–129` makes a block read its entry
state and apply in parallel. `[ŚABDA]` Those are, exactly, a phase boundary
and a snapshot-semantics round. Kulkarni's warning is the operative one: *a
sequential subroutine is not automatically a faithful representation of
asiddha scope* — i.e. **implementing the rules in order is not implementing
the phase discipline.** `[ŚABDA²]`

**Repo relevance:** the L3 rewriting layer's stated gap (`runtime/execute/`:
"no principled theory of which rule wins", handled by saturation + Pareto
extraction) is a *strategy* gap, and the Aṣṭādhyāyī's answer is not one
priority rule but a **phase architecture plus a priority order inside each
phase**. The quarantined `runtime/panini/conflict.py` implemented the priority
order and not the phases.

### 6.3 the avacchedaka is a dependent binder, and the repo is running the weak version in the strong substrate

`[ŚABDA]` arXiv:2605.12548 states the point in one sentence: an avacchedaka
delimiting a pratiyogin is **a type-level binder, not a free variable**, which
is why HOL cannot hold it and Martin-Löf's Π can. `[REPO]` The `weaver` lane
independently arrived at "a claim carries an index," implemented it in Python
as an optional field, and its own audit found **zero live originating sites**.
The repo is written in **Cubical Agda**. The strong version of its own
organizing concept is available in its own substrate, published, and unused.

---

## 7. Naming ledger — earned or decorative

| repo object | verdict |
|---|---|
| `notes/PANINIAN_DERIVATION_IS_NOT_ENDPOINT_REWRITING.md` | **EARNED.** Sourced (Bronkhorst, Kulkarni), proves a proposition, records the residual, refuses the easy identification |
| `notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` | **EARNED, by withdrawal.** Struck its own coined type after the sources resisted |
| `runtime/panini/conflict.py` | **EARNED as a mapping** (Kiparsky 2009's four principles as exact TRS predicates, three disanalogies enforced in code). **Method not earned** — its payoff is a measured contest, which `CLAUDE.md` forbids. Revive as theorems in Agda or leave quarantined |
| `formal/cubical/KuttakaValli.agda` | **HALF EARNED.** "vallī" yes — the quotient column really is treated as first-class syntax. "kuṭṭaka" no — no gcd, no Bézout, no back-substitution, no iṣṭa section. Rename, or add the two missing theorems |
| `notes/KUTTAKA_SOLUTION_FAMILY.md` | **EARNED as prose**, with its own honest disclosure that verse-level sourcing is owed |
| `notes/ABHAVA.md` (avacchedaka §1) | **EARNED as a flagged reading** — row A2 says so itself — and its 2026-08-14 prior-art sweep found the literature. **Now superseded in resolution** by the dependent-binder treatments |
| `weaver` lane, "indices and limitors" | **PARTIALLY EARNED.** Correct gloss, weaker resolution than Matilal→Ganeri→Bhattacharyya→cubical, and the limitor layer is inert (0 originating sites). Take the strong version or say "index" |
| `formal/cubical/NaturalMachine/Obstruction.agda` | **NOT AN INDIC NAME AT ALL.** No apoha content; "obstruction" is the ordinary word. Nothing to strike — but do not later relabel its residual as apoha; a residual over a fixed finite vocabulary is exactly the pre-given universe apoha refuses |
| handles `codex-apoha`, `codex-catuskoti`, `codex-pratitya`, `codex-sahaja`, `codex-madhavi`, `codex-nalanda-dvara`, `opus-shesha`, `cf-sakshi`, `codex-vajra`, `codex-shilpin`, `codex-ananta`, `codex-anvaya` | **DECORATIVE, and acceptable.** Handles are labels. `codex-apoha`'s filed result uses no apoha content `[REPO]`. **Standing rule: a handle is never a citation, and no note may cite a handle as evidence that a tradition was consulted** |
| Kerala school / Mādhava | **UNUSED.** Nothing named for it, nothing borrowed. Also the tradition whose practice (series **plus** correction term) most exactly matches this repo's own protocol |

---

## 8. What to read first, ordered by what would most change this repository's work

1. **Wiebke Petersen, "A Mathematical Analysis of Pāṇini's Śivasūtras",
   *JoLLI* 13 (2004) 471–489.** *Why first:* it is a **theorem**, in this
   repo's register — an optimality result about representing an
   intersection-closed set family as intervals of a linear order, proved from
   the Hasse diagram with no phonology. It is the one item here that is
   already the object `CLAUDE.md` demands rather than a measurement. A PDF is
   reported at `user.phil.hhu.de/~petersen/paper/petersen_jolli_proof.pdf`
   `[ŚABDA]` — fetch it the moment egress permits.
2. **`github.com/ambuda-org/vidyut`, crate `vidyut-prakriya`.** *Why:*
   ~2,000 Aṣṭādhyāyī rules in Rust, and **every generated word can carry its
   own prakriyā — the rules used and their intermediate results.** A
   rule engine that emits its derivation trace is a proof-term-emitting
   rewriter. This is git-reachable **now**, needs no egress, and is directly
   comparable to the repo's L3 rewriting layer and to the vallī-as-trace
   framing. Read `vidyut-prakriya/README.md` and how it encodes rule conflict.
3. **arXiv:2605.12548, *Cubical Type Theoretic Navya-Nyāya*.** *Why:* it is
   in this repo's exact substrate, it names four structures the repo's own
   limitor work drops, and `ABHAVA.md`'s ledger has already recorded that it
   reaches the part of §2.1 the repo reserved as new. The deferred comparison
   is owed.
4. **Paul Kiparsky, "Elsewhere in phonology" (1973) and "What is siddha?"
   (1987), plus "On the Architecture of Pāṇini's Grammar" (2009).** *Why:*
   (1973) is the documented transmission of `utsarga`/`apavāda` into modern
   linguistics under the name Elsewhere Condition — the cleanest
   tradition↔modern correspondence on this page; (1987) is the standing
   question about asiddha scope; (2009) is already cited by the repo's own
   quarantined lane and should be checked against what that lane implemented.
5. **Kulkarni / Goyal / Behera, "Computer Simulation of Aṣṭādhyāyī: Some
   Insights" and "Asiddhatva Principle in Computational Model of
   Aṣṭādhyāyī".** *Why:* the asiddhavat block as a "filter" with
   snapshot-parallel semantics, and the warning that a sequential subroutine
   does not faithfully represent asiddha scope. Directly applicable to any
   phase discipline in `runtime/execute/`.
6. **Āryabhaṭīya Gaṇitapāda 32–33 with Bhāskara I's *Āryabhaṭīyabhāṣya*,
   in a critical edition/translation.** *Why:* two verses. `KuttakaValli.agda`
   and `KUTTAKA_SOLUTION_FAMILY.md` both owe verse-level sourcing, and the
   iṣṭa section convention — the claim the repo leans on hardest, that the
   tradition *chose* a section rather than deriving one — is the specific
   thing that needs to be read rather than attributed.
7. **Rajpopat (2022), *In Pāṇini We Trust* / *Pāṇini's Perfect Rule*,
   Cambridge repository `1810/332654`.** *Why:* if `1.4.2` does not mean
   "later rule wins," then any repo text citing serial-order priority as the
   Pāṇinian answer is citing a contested reading. `runtime/panini/conflict.py`
   already knows this; nothing else in the repo does.
8. **Siderits, Tillemans & Chakrabarti (eds.), *Apoha* (Columbia, 2011);
   Katsura on PS(V) V.25cd–38; Matilal, *The Navya-nyāya Doctrine of
   Negation* (Harvard, 1968).** *Why last-but-real:* apoha has **no located
   rigorous formalization**, which makes it the highest-variance item —
   nothing to copy, and a live technical dispute (scope vs. causal/error) that
   the repo's own note has already localized correctly.
9. **Jyeṣṭhadeva, *Gaṇita-Yukti-Bhāṣā*, Sarma trans. with Ramasubramanian /
   Srinivas / Sriram notes; and arXiv:2405.11134 on Mādhava's correction
   terms.** *Why:* a proof text, and the correction-term practice that is this
   repo's own protocol avant la lettre. Read the yukti, not the priority
   dispute — `FIVE_FACES.md` §8 has already settled how to talk about that.

---

## 9. Rigor boundary

**Established here (repository facts, verified by reading):** `Obstruction.agda`
contains no apoha content; `KuttakaValli.agda` contains the continuant laws and
no gcd/Bézout/section; `runtime/panini/conflict.py` implements four Kiparsky
principles with three disanalogies enforced in code and reports a measured
contest; `limitor_audit` reports zero originating limitor sites;
`codex-apoha`'s filed result uses no apoha content; `ABHAVA.md` row A2 flags
its own identification as a reading and its 2026-08-14 sweep already found
Matilal and arXiv:2605.12548.

**Reported at testimony grade, not verified:** every sūtra number, every verse
number, every attribution of a claim to Kiparsky, Cardona, Staal, Petersen,
Rajpopat, Bronkhorst, Kulkarni, Goyal, Matilal, Ganeri, Bhattacharyya, Panday,
Siderits, Tillemans, Chakrabarti, Katsura, Hayes, Sarma, Ramasubramanian,
Srinivas, Sriram, Jyeṣṭhadeva, Nīlakaṇṭha, Mādhava, Āryabhaṭa, Bhāskara I,
Brahmagupta, Dignāga, Dharmakīrti, Gaṅgeśa, Ingerman. **No primary text and no
secondary text was opened.**

**Marked `[MINE]` and therefore unsourced:** the reading of apoha as
nearer a relative pseudo-complement in a concept lattice than a Boolean
complement (§2.2); the reading of `anal-vidhau` as a parametricity-style
client restriction (§6.1).

**Not established:** that any tradition anticipated any modern construct as a
matter of priority; that the Aṣṭādhyāyī is Turing-complete; that
`Pāṇini = BNF`; that any correspondence in §1.1 is a theorem rather than a
structural identification; that arXiv:2605.12548's claims hold, or that it
ships code.

**What would falsify the sharpest verdicts:** a `gcd`/Bézout/section theorem
appearing in `KuttakaValli.agda` (kills §5.2); a live originating limitor site
with a dependent avacchedaka (kills §3.3); a located rigorous lattice or type
theoretic reconstruction of apoha (kills the "none located" in §2.2 —
and would be very welcome).
