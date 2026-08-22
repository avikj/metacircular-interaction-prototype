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
| **sthānivadbhāva** | `1.1.56 sthānivad ādeśo 'nalvidhau` `[ŚABDA]` | a substitute counts as the original **for subsequent rules — except rules conditioned on the phonemes themselves** (`anal-vidhau`) | **an abstraction barrier with an explicit exception for representation-inspecting clients.** The substitute inherits the original's *designations* (interface) but not its *form* (representation). This is a parametricity/representation-independence statement, not blanket transparency | **EXACT, and sharper than the modern folklore version** — see §6.1; BUILT 2026-08-20 in `machine/Astadhyayi.hs` and `formal/cubical/Sthanivadbhava_TheSubstituteInheritsDesignationsNotForm.agda` |
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
Boolean, lattice-theoretic, formal-concept-analytic, or type-theoretic.

> **[Narrowed 2026-08-15 (Claude, Opus lineage; reach audit
> `notes/CORRECTION_REACH_AUDIT.md`), by addition — the sentence above is
> untouched.]** `notes/EXCLUSION_IS_NOT_AN_OPERATOR.md` §3 records a hit this
> sweep missed: **Hans Herzberger (1975)**, a "resourceful nominalism" built on
> Emil Post's theory of twofold propositions, addressing how predicates apply
> non-arbitrarily without commitment to universals (located via the SEP entry
> on Dharmakīrti). That note's own verdict, quoted: "It is not
> lattice-theoretic and I have not read it, so §2.2's headline (no lattice/FCA/
> type-theoretic reconstruction located) may still stand — but 'NOT FOUND'
> should be narrowed." So read the claim as *no located lattice/FCA/
> type-theoretic reconstruction*, not as no formal-logical engagement at all.
> Judging Herzberger's content is left to a reader who has read him.

The
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

> **[DISCHARGED 2026-08-18, cf-sakshi.** The missing theorem now exists, in a
> new self-contained module `formal/cubical/Kuttaka.agda` (not in
> `KuttakaValli.agda`, whose `solve!`-bearing matrix dependencies do not build
> under this container's v0.5 pin). It proves `bezout`: every pulverizer run —
> the Euclidean descent as inductive evidence, i.e. the vallī as a checked
> trace — yields x, y with `a·x + b·y ≡ g`, the coefficients built by
> back-substitution `(x',y') ↦ (y', x'−q·y')` up the vallī; the scaled
> inhomogeneous family; a concrete non-vacuous run on (7,5); and `gcdDivides` +
> `gcdGreatest` — the terminal g divides both a,b and every common divisor
> divides g, i.e. g IS the gcd — so the module supplies the full pulverizer,
> gcd and Bézout together. Still NOT done, named there: only the iṣṭa
> least-non-negative section (needs a mod/section convention).
> Fallback-checked on v0.5 (three ring identities via `solve`, the
> v0.9 `solve!` spelling under the other pin), --safe, no holes. This is the
> first module in the repo where an Indian source supplies a theorem rather
> than a name — the thing §5.2(ii) asked for.]**
>
> **Verdict (original): `KuttakaValli.agda` earns "vallī" and does not yet earn
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


**[BUILT 2026-08-20.** The sentence stopped being a sentence worth having and
became two mechanisms.

`machine/Astadhyayi.hs`: substitution in that engine was string replacement —
a rule replaced `"i"` by `"y"` and nothing recorded that the y had been an i.
A substitute now carries its sthānin in a channel parallel to the word
(`Prov`), tagged with the sūtra that put it there, written by `applyRwP` at the
moment of substitution and threaded through every call site of the engine.
`alVidhiTable` declares each sūtra `AlVidhi`, `AnalVidhi` or `NoVidhi` **with
its reason**, one entry per sūtra, and `selfTest` checks the table is total so
no rule can acquire a reading by defaulting; three entries are marked DISPUTED
(6.1.109, 7.1.1, 8.2.30 — an operation whose locus is a saṃjñā and whose
substituend is a sound) rather than decided. The engine hands each rule the
derivation *as that rule may see it* (`seenBy`), so the barrier is a mechanism
rather than an annotation, and each step records which reading it fired on
(`stView`, `stSaw`, `stForm`, `stSthanin`, `stThroughBarrier`). `barrierAudit`
prints every step where the two readings differ. Six sūtras were added to run
it — 1.1.5, 1.3.3, 1.3.8, 1.3.9, 7.1.1, 7.3.84 — with an upadeśa stage before
the fixpoint, because 1.3.2 says `upadeśe` and that is what the word does to an
implementation.

**What is exercised and what is not, since the difference is the whole value of
the report.** The EXCEPTION clause is exercised: three corpus words have a rule
firing at a position another rule had already substituted, and reading the
ādeśa — `vāc` (8.2.39 reads the `k` for the sthānin `c`; 8.4.56 reads `g` for
`k`), `tat + jalam` (8.4.40 reads `d` for `t`), `nī ~ lyuṭ` (6.1.78 reads the
`e` 7.3.84 put for `ī`). The INHERITANCE half is **declared and not
exercised**: the designation-reading rules encoded here — 1.1.5, 1.3.9, 7.1.1 —
never fire at a site holding an ādeśa, so `deriveRupamEverywhere`, which
strikes `sthānivat` and makes every rule read the form, gives the same word on
the whole corpus. Recorded rather than papered over; a mechanism whose second
half never runs is a shelf.

The measurement, since the claim "the exception clause is load-bearing" is
otherwise an opinion: `deriveSthanivatEverywhere` strikes `anal-vidhau` and runs
the same sūtras on the same inputs. Four corpus words change, and the mechanism
differs in each — `tat + ca` `tacca → tajca` (8.4.40 keeps reading the `t`
8.2.39 replaced), `ne - ana` `nayana → naaiana`, `rāmas` `rāmaḥ → rāmar` (8.3.15
reads the `s` it was given in place of, so its `r` condition is never met), and
`nī ~ lyuṭ` `nayana → neyu`. **The last is the sharp one and it was not the
expected result**: 7.3.84 reads the `ī` it has itself just replaced, re-offers
the same guṇa, the offer is a no-op, and the engine reads that as a fixpoint and
halts three rules early. A guṇa rule that counts its own output as the sthānin
cannot tell that it has fired — so without the clause the derivation ends in the
wrong *place*, not merely with the wrong sound. `vāc` is not in the list: under
the struck reading 8.2.39 cycles `k → j → g` and 8.4.56 cycles `g → c → k`, and
the cycle lands back on the attested `vāk` after five steps instead of three.
Same word, different derivation; a test on the form alone would have called that
agreement.

*(An earlier draft of this paragraph, written before the engine side existed,
predicted `neana`, `vāj` and `tadjalam` for those three. All three were wrong.
The prediction was not marked as one, which is the failure worth naming: a
measurement written before the run reads exactly like a measurement.)*

Lopa likewise: `Lupta` is an item that renders as nothing, is invisible to every
rule that scans sounds, and whose designations are still readable — 1.1.60
अदर्शनं लोपः, non-appearance and not deletion, with 1.1.62 for why it still
conditions. `ci ~ kta` derives `cita` because 1.1.5 क्ङिति च reads the `k` that
1.3.9 erased one step earlier; `deriveWithoutLopa` removes the trace, as
a naive engine does, and gets `ceta`.

`formal/cubical/Sthanivadbhava_TheSubstituteInheritsDesignationsNotForm.agda`
carries the statements: `anal-blind` (a rule factoring through the designations
gives the same answer on an ādeśa and its sthānin — for every such rule, into
every type, which is the parametricity half), `ec?-not-anal` (there is **no**
function of the designations agreeing with 6.1.78, so the exception is naming a
real class), `one-reading-fails` (no single reading serves both kinds of rule —
neither transparency nor opacity is enough, which is the sharp form of the
folklore complaint above), and `lopa-load-bearing` (two derivations with
identical surfaces that 1.1.5 answers oppositely). `--safe`, no postulates, no
holes.

NOT done: 1.1.52–1.1.55 (which sound of the sthānin an ādeśa replaces), the
vārttikas restricting 1.1.56, and 1.1.61/1.1.63 (luk, ślu, lup and their own
sthānivadbhāva treatment).**]
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

**[CORE SUPPLIED 2026-08-18, cf-sakshi.** `formal/cubical/AbhavaAvacchedaka.agda`
now carries the strong version's core in the substrate: `Abhava` is a dependent
record with `anuyogin` (locus), `avacchedaka` (limitors), and `pratiyogin :
avacchedaka → anuyogin → Type` — the counterpositive as a family DEPENDENT on
the limitor, i.e. the avacchedaka as a genuine type-level binder, not an
optional field. `holds A α = (x : ℓ) → ¬ pratiyogin α x` binds the limitor;
`limitor-load-bearing` proves a concrete absence that HOLDS under one limitor
and FAILS under another — "change the limitor, change the absence" (ABHAVA.md
§1) as a theorem, exactly what a limitor-free ¬ cannot see. NOT done: the full
Panday–Ghosh simultaneous treatment (adds tādātmya, paramparā-sambandha);
this is the avacchedaka/abhāva core only. --safe, no holes. Kills this
subsection's "unused" clause; the weak-index critique of the `weaver` lane
stands until that lane adopts it.]**

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

---

## 10. Appended 2026-08-19, another thread: §7's ledger run on thirteen new modules

*Nothing above is altered. §7 is a ledger and this is new material for it,
in its own vocabulary. The occasion was the repository owner striking two of
these names on 2026-08-19 for the failure this map exists to catch —
dressing an imported notion in a tradition's clothes.*

| repo object | verdict |
|---|---|
| `NaturalMachine.TheAbsenceTowerIsThreeUnconditionally`, `…WhereTheTowerCanStillBeThree` | **NOT EARNED, withdrawn in place.** "Tower" and "three" translate nothing: no source measures absence by iteration depth, and the Nyāya–Vaiśeṣika classification is fourfold and sorts by KIND. Corrections appended at both sites; the theorems (`¬¬¬A ≃ ¬A`, the collapse iff, `¬((¬A) ≃ (¬¬A))`) are untouched and never needed the gloss |
| `NaturalMachine.AnyonyaAbhava` §1 | **EARNED.** `Anyonya a b = ¬ (a ≡ b)` is non-identity and nothing more, which is what `ABHAVA.md` §2's Tarkasaṅgraha audit says the term carries |
| `NaturalMachine.AnyonyaAbhava`'s `Collision` gloss | **NOT EARNED.** Two states a coarse map identifies and a fine map separates is *observational separation*, which that same audit says anyonyābhāva is **not** "by itself". Corrected in an appended §10 there |
| `NaturalMachine.ExclusionRecoversGroundAtAPrice`, apoha reading | **NOT EARNED, withdrawn today on reading §2.2 above.** `Excludes q x x' = ¬ (q x ≡ q x')` is a negation in a fixed universe with a fixed partition — the defeated Boolean gloss, exactly. Withdrawal appended at the module as §11 |
| the same module's §7, naming the Naiyāyika/Mīmāṃsaka circularity objection and refusing to adjudicate | **EARNED.** Reporting a live disagreement is not claiming a formal counterpart, which §2.2 says has not been located |
| `NaturalMachine.TheDelimitorNeedsOnlyStability` | **EARNED, by refusal.** It says in as many words that `Dec (Ground q x x')` is *not* the Naiyāyika condition on अभाव — the school's requirement is on the specification of the absence, decidability is on what can be settled about it, and the two come apart. Weaker resolution than §6.3's dependent-binder treatment, and it does not claim otherwise |
| `NaturalMachine.TheUniformFormIsNotRefuted`, avacchedaka paragraph | **EARNED as a flagged resemblance.** States the resemblance and its limit in the same breath, and declines to name the object after it |
| `NaturalMachine.TheDomainThatIsAnAbsence` | **EARNED.** Two incompatible readings of the same two theorems — Vaiśeṣika abhāva-as-padārtha, Madhyamaka niḥsvabhāva — both recorded, neither adjudicated, the one-toolkit option explicitly refused |
| the remaining six modules of `notes/INDEPENDENCE_IN_THIS_LANE.md` | **NO INDIC NAME AND NO INDIC CONTENT.** Nothing to strike. Recorded so that no later note relabels their negations as apoha, which §7's `Obstruction.agda` row already warns against |

**What the ledger caught that this thread did not.** Two of these three
NOT-EARNED verdicts were found by the owner and by `ABHAVA.md`'s audit before
this map was read; the third — apoha — was found only by reading §2.2 here.
That is one measured instance of §8's ordering claim: the map changes work
that has already been done, not only work that is planned.

**A caution against this row-block.** A ledger that grows a row per module
becomes a compliance artifact, which is the failure `NEGATIVE_KNOWLEDGE_IS_TYPED`
§4.2 names for typologies and §5.4 names for packaging generally. These nine
rows earn their place only if a later verdict is *changed* by them. If a
session passes in which rows are added and none is consulted, strike the block.

### 5.3 Appended 2026-08-19, another thread: §5.2's remaining item is now two, one of them closed

*Nothing above is altered.* The 2026-08-18 DISCHARGED block leaves one item:
*"Still NOT done, named there: only the iṣṭa least-non-negative section
(needs a mod/section convention)."*

`formal/cubical/NaturalMachine/TheIstaSectionIsAnImportedConvention.agda`
takes §5.2(ii)'s wording literally — "the iṣṭa reduction as an explicitly
**imported** section". A section is a **parameter**: any `sec` with, for each
`x`, a shift `t` and `sec x ≡ x + t·b`. The theorem is that importing one
costs nothing — the reduced solution still solves `a·x + b·y ≡ g`, with the
`y` produced explicitly. The type is shown inhabited so the theorem is not
vacuous. `--safe`, no holes, latched.

That is the *convention* half, and it is the half `KUTTAKA_SOLUTION_FAMILY.md`
assigns to the tradition — "the section is a declared convention". Declared,
not derived, so the honest formalisation makes it a parameter and proves the
equation indifferent to it.

**Still open, narrowed:** the LEAST-NON-NEGATIVE property. Nothing there says
the section lands in `[0,b)`; that needs an order and a division algorithm on
`ℤ`, which `Kuttaka` does not carry. So §5.2's one remaining item is now two —
the section, closed; its minimality, open — and the open one is minimality,
not the section.

**Debt inherited unchanged.** §5.1's disclosure stands: no primary text was
fetchable, the verse-level sourcing is owed and not claimed, and nothing above
asserts that this is what Āryabhaṭa meant by iṣṭa.

### 8.1 Appended 2026-08-19, another thread: §8 item 7's audit, run

*Nothing above is altered.* §8 item 7 says: *"if `1.4.2` does not mean 'later
rule wins,' then any repo text citing serial-order priority as the Pāṇinian
answer is citing a contested reading. `runtime/panini/conflict.py` already
knows this; nothing else in the repo does."* That is a checkable claim about
the repository, it needs no egress, and it had not been checked. Run
2026-08-19, `.md`/`.agda`/`.hs` outside `collab/`:

    grep -rn "vipratiṣedha|vipratisedha|1\.4\.2"
    grep -rni "later rule wins|later rule prevails|paraṁ kāryam|serial order"

**The clause is outdated in one direction.** More than `conflict.py` knows:

- `formal/cubical/ElsewhereCondition.agda:50` — "whether 'the later rule wins'
  (traditional) or …", i.e. the reading is held open;
- `notes/ELSEWHERE_CONDITION_IS_INCOMPLETE.md` §2.2 — proves its result
  **independent of how 1.4.2 is read**, and cites §1.1's CONTESTED;
- `formal/cubical/NaturalMachine/AnuvrttiIsTheSameTrade.agda` §7 — a
  correction appended 2026-08-19 by this thread, which had asserted the serial
  reading and withdrew it on reading this map;
- and this map itself, row `vipratiṣedha`.

**And it is right in the other.** Sites asserting the serial reading without
the caveat, each classified by reading the surrounding lines, not by the grep
alone:

| site | text |
|---|---|
| `formal/cubical/Panini.agda:17` | "on a tie the later rule wins — modelled as priority by list order" |
| `formal/cubical/NaturalMachine/Anuvrtti.agda:48` | "of two conflicting rules, the later prevails" |
| `machine/Astadhyayi.hs:28` and several lines after | "In conflict, the LATER operation"; also `paratva` phrasing at 747, 768, 876 |
| `notes/APPLIED_ROOTS_OF_INDIAN_MATHEMATICS.md:174` | "in conflict, the later rule prevails" |
| `notes/VERIFIER_BLIND_FIBER_REWARD.md:96` | "in mutual conflict the later rule prevails" |

Checked and **not** in the list: `formal/cubical/Niksepa.agda:35` names 1.4.2
as "a metarule for conflict" and does not state which reading.

**Nothing is edited at those sites.** They belong to other lanes and other
identities; the norm here is to append at the site, and appending to five
files across three lanes on the strength of one reader's classification is a
larger action than this finding warrants. The list is the deliverable, and its
owners can act on it. `Anuvrtti.agda` is the one case where the assertion is
load-bearing for a *mathematical* claim — the argument that the sequence
carries information a set does not — and that argument survives either reading
of 1.4.2, since it needs only that the order is consulted, not which end wins.

**Limits.** Both greps were truncated by `head`, so the `Astadhyayi.hs` count
is "at least", and the search is not exhaustive. A site phrasing it as
"paratva", "the subsequent sūtra", or in Devanagari alone would evade both
patterns; one such phrasing (`paratva`) was caught only because it co-occurred
with the numeral. And nothing here adjudicates Rajpopat: the reading is
recorded as CONTESTED, which is this map's own verdict, and the PDF remains
unfetched.

### 7.1 Appended 2026-08-19, another thread: one ledger row is factually wrong, and a shelf is why

*Nothing above is altered.* §7's last row reads:

> **Kerala school / Mādhava** — **UNUSED.** Nothing named for it, nothing
> borrowed.

**`formal/cubical/Madhava.agda` exists.** 100 lines, `--cubical --safe`,
written entirely in Sanskrit — Devanagari identifiers, Devanagari prose —
sourced in its header to Mādhava of Saṅgamagrāma (~1400), Nīlakaṇṭha's
*Tantrasaṅgraha* (1501) and Jyeṣṭhadeva's *Yuktibhāṣā* (~1530), and framed as
arising from observational astronomy rather than pure speculation. What it
proves is the algebraic root of the arctan series — the finite geometric sum
over `ℤ`:

    (1 − r) · ∑_{k<n} rᵏ  ≡  1 − rⁿ

"no limit, no convergence — only a ring identity, kernel-checked", with the
supporting lemmas (`वाम-एक`, `आधार-समिका`, `वितरण-समिका`, `भङ्ग-समिका`,
telescoping) each stated and proved.

It also carries its own honesty section, marked *avaktavya*: what Mādhava
actually did — the remainder term `rⁿ/(1−r)` going to zero, whence the
infinite sum `1/(1−r)` — is **not** provable there without ℝ/ℚ analysis, *"the
remainder term IS the essence; here it is left unstated, not falsely
proved."*

So the row is wrong on both clauses: something is named for it, and the
geometric-series root is borrowed and proved.

**Why the row could be written.** `Madhava.agda` is imported by nothing. A
zero-importer census over `formal/cubical`'s top level, run 2026-08-19: **137**
`.agda` files, **5** with no importer, of which two — `Everything`,
`IndianLane` — are aggregators and importerless by construction. The three
real shelves are `AmshaSatyayantra`, `Jiva`, and `Madhava`. This is the same
failure the Upamāna commit `5de182be` named on the Haskell side — *"a header
cannot tell a shelf from an absence until somebody turns the key"* — arriving
here in a **naming ledger**, which is the instrument whose whole job is to
know what exists.

**Counts, not classifications.** The census counts `import <Module>` lines; a
module reached only through `Everything.agda` would still show as imported,
and one reached by a build script would not. `AmshaSatyayantra` and `Jiva` were
not read. What was read in full: `Madhava.agda`, before this was written.

**What the row should probably say instead** — offered, not applied, since the
ledger is not mine: *named and borrowed at the geometric-series root, with the
correction term explicitly declined; used by nothing.* The last clause is the
one that matters, and it is a different verdict from UNUSED — the note's own
observation that Kerala practice (series **plus** correction term) matches this
repository's protocol stands, and is now sharper: the repository has the
series and has declined the correction term in exactly the place it would go.

### 5.4 Appended 2026-08-19, another thread: a SECOND kuṭṭaka development exists, and a correction to §7.1's own census

*Nothing above is altered.*

**A correction to §7.1, which is mine and was wrong.** §7.1 called
`AmshaSatyayantra`, `Jiva` and `Madhava` "the three real shelves" after
excluding `Everything` and `IndianLane` as aggregators. `Jiva.agda` is also an
aggregator — read in full: its header is a table of contents for eight
modules, and its body imports them. It is importerless by construction, like
the two excluded. Two candidates remain, and `AmshaSatyayantra` is still
unread. The census counted correctly; my classification of one entry did not,
which is the census's own stated limit — *a count is not a classification* —
biting its author one cycle later.

**And what reading `Jiva` showed.** There is a second, independent kuṭṭaka
development in `formal/cubical`, over `ℕ`, none of whose modules this map
mentions: `BhedaAvatarana`, `Punaragamana`, `Gati`, `GurutamaSiddha`,
`Sthairya`, `Purnata`, `Bija`, `Yuti`. Verified by reading:

- `Bija.बीजगणितम्` — `a·x ≡ b·y + g`, Bézout in ℕ, via the vallī;
- `GurutamaSiddha.सिद्धः` — `isGCD`, the terminal `g` as greatest common
  divisor;
- **`Yuti`** — the linear congruence `a·X ≡ c (mod b)`, i.e. `a·X ≡ b·Y + c`,
  with the solvability condition `c ≡ g·m` stated as *"exactly Āryabhaṭa's
  condition; otherwise no solution, and we do not fabricate one"* — the
  astronomical purpose the pulverizer was devised for;
- and a stated design constraint: the descent moves **by structure, never by a
  decision** — no `discreteℕ`, no `Dec`, no `Bool`.

**This does not make §5.2 wrong**, and the dates say why. `git log
--diff-filter=A`: this map was added `2026-08-14T02:24Z`; `Kuttaka.agda`
`2026-08-18T09:15Z`; `Bija` `19:23`, `Yuti` `19:25`, `Jiva` `19:27`, and
`notes/KUTTAKA_JIVA_DECISIONLESS_PULVERIZER.md` `19:29` — all four days after
the map, and ten hours after the DISCHARGED block's module. §5.2's verdict was
correct when written and its discharge names the module that existed then.

**What is worth recording is the shape.** The corpus now holds **two**
kuṭṭaka developments — `Kuttaka.agda` over `ℤ` with `Run`-as-evidence, and the
`Jiva` family over `ℕ` decisionless — and the map's §5 knows one. Neither is a
shelf: `notes/KUTTAKA_JIVA_DECISIONLESS_PULVERIZER.md` and
`notes/DECISIONLESS_INDIC_CORPUS_INDEX.md` document the second, so this is a
gap **between notes**, not a lost artifact.

**The iṣṭa section is still absent from both.** Grep over `Yuti`, `Bija`,
`GurutamaSiddha`, `BhedaAvatarana`, `Purnata` for `least`, `mod`, `section`,
`iṣṭa`: the only hits are two lines of prose in `Yuti`'s header naming the
congruence. So §5.3's split stands unchanged — the section closed as an
imported convention, minimality open — and it is open in the ℕ development
too. The verse-level sourcing debt of §5.1 is likewise unchanged and
unclaimed by either development or by this note.

---

### 3.4 Appended 2026-08-19, another thread: §3.3's second clause is now used, and is a theorem

*Appended at the end, altering no line above.*

§3.3 names a two-part gap. Its second clause:

> "the avacchedaka of the `pratiyogitā` and the avacchedaka of the
> `anuyogitā` are distinct slots. Neither of these is used anywhere in the
> repo."

**I checked before claiming it was still open**, rather than assuming:

```
grep -rn 'pratiyogitā\|anuyogitā' --include=*.agda --include=*.md --include=*.hs .
```

returned exactly two lines, both prose, neither formal — this file at line 292
(the sentence quoted above) and
`notes/SEED53_PRATIYOGIN_OF_THE_PRIMITIVE_PROJECTOR.md:22`. **Zero `.agda`
files.** Output not truncated. And I read `AbhavaAvacchedaka.agda` end to end
first: its record carries ONE limitor field, delimiting `pratiyogin` only, and
`holds A α = (x : A .anuyogin) → ¬ (A .pratiyogin α x)` quantifies over the
locus with nothing delimiting it. So the first clause of the gap was closed
and the second was not.

Now closed, in
`formal/cubical/NaturalMachine/TheAnuyogitaAvacchedakaIsADistinctSlot.agda`
(`--safe`, no postulates, no holes, EXIT 0):

```agda
record Abhava₂ where
  anuyogin₂ pratiyogitavacchedaka anuyogitavacchedaka : Type
  pratiyogin₂ : pratiyogitavacchedaka → anuyogin₂ → Type
  locus       : anuyogitavacchedaka   → anuyogin₂ → Type

holds₂ A π ν = (x : A .anuyogin₂) → A .locus ν x → ¬ (A .pratiyogin₂ π x)
```

with `reduct : Abhava₂ → Abhava` forgetting the locus limitor, and:

- `bothSlotsAreLoadBearing` — on ONE object, holding π fixed and moving ν
  flips the verdict, and holding ν fixed and moving π flips it.
- `oneSlotLosesAnAbsence` — identical one-slot data, yet the absence **holds**
  under a delimited locus and **fails** on the bare one. So the anuyogitā's
  limitor is not recoverable from the one-slot record.

**Both directions stated, so neither presentation is called simply stronger.**
`oneSlot→twoSlot` holds with no hypothesis — the one-slot verdict quantifies
over the bare locus and therefore implies the two-slot verdict at every ν.
`twoSlot→oneSlot-when-the-limitor-is-inert` returns the one-slot verdict only
when the locus limitor is total, i.e. exactly when it was doing nothing. The
one-slot form asks more of the world; the two-slot form is available where the
one-slot form is not.

**What this does NOT close.** §3.3's recommendation was about the `weaver`
lane's own limitor layer — the audit reporting 0 originating sites, 12
propagating, 39 unlimited. Nothing here touches that lane or that audit. A
second slot existing in `formal/cubical/` does not fill a slot in
`runtime/kernel/`; the finding stands where it was made.

**Limits repeated, not evaded.** No primary Sanskrit opened; the slot doctrine
is carried from `notes/ABHAVA.md` and §3.1 above, as `AbhavaAvacchedaka.agda`
records for itself. Verse-level sourcing OWED AND NOT CLAIMED. The separating
example (a two-point locus) is mine, offered as a separating instance and not
as exegesis. `notes/ABHAVA.md` A6's obligation is untouched: arXiv:2605.12548
is unreachable from this channel, so NO NOVELTY is claimed for any of this
until someone who can read it compares. Neither tādātmya nor
paramparā-sambandha is here, and two slots is what §3.3 named as missing, not
a claim about a third.

**What rival schools would say, unadjudicated and recorded because the verdict
does not license collapsing the grounds.** The Prābhākara Mīmāṃsakas deny
abhāva is a distinct padārtha at all — on their view the theorem separates two
readings of one bare locus, not two absences. The Buddhist apoha theorists
take exclusion as primitive rather than built from a positive relatum, so
"which limitor delimits the counterpositive" does not arise in their terms.
Neither is adjudicated here; §2.3 above already settles the separate question
of apoha as Boolean complementation.

---

### 4.1 Appended 2026-08-19, another thread: §4's line about the correction term, taken up — and a date check first

*Appended at the end, altering no line above.*

**§4 was correct when written; it has been overtaken.** Checked before saying
anything about it:

```
git log --diff-filter=A --format='%h %ad %s' --date=short -- <path>
  notes/INDIC_FORMAL_TRADITIONS_MAP.md  → 657593aa  2026-08-14
  formal/cubical/Madhava.agda           → d6ee569d  2026-08-18
```

Four days apart. §4's closing verdict — "no module, note, or theorem in this
repo is named for Mādhava … the tradition is simply unused" — was true on
2026-08-14. §7.1 already records the same overtaking for §7's ledger row; this
is a second site carrying the same now-outdated sentence, and it is appended
to, not corrected.

**§4's operative line, taken up.** §4 says the one Kerala-school line that
bears on this repository is that `CLAUDE.md` demands the error term and
*"Mādhava did not stop at the series. He gave the correction term."*

`formal/cubical/NaturalMachine/TheTruncationErrorIsExactAtEveryFiniteStage.agda`
(`--safe`, no postulates, no holes, EXIT 0):

```agda
exactRemainder : (r : ℤ) (n : ℕ) → (pos 1 - r) · सङ्कलितम् r n + घात r n ≡ pos 1
```

— `Madhava.गुणश्रेढी-योगः` plus `minusPlus`, read as a statement about error
rather than about the sum. The remainder is **exactly rⁿ at every finite n**,
over ℤ, with no limit and no analysis.

And the collision, seventh site of
`TranscriptDescent.collisionObstructsDecoder`:

```agda
truncate r = सङ्कलितम् r 1     -- ≡ pos 1 for EVERY r, by refl
error    r = घात r 1           -- ≡ r
errorDoesNotFactorThroughTheTruncation : ¬ FactorsThrough truncate error
```

So `CLAUDE.md`'s *"a correlation coefficient has no content; the content is
the error term"* is a theorem on Mādhava's own object: the truncation is
constant in the ratio, the error is the identity in it, and no invariant of
the first reports the second.

**A narrowing offered to `Madhava.agda`'s honesty ledger, not applied.** That
ledger says the remainder term is `अनुक्तम्` — un-said. That is right for the
*asymptotics* (rⁿ/(1−r) → 0 does need ℝ/ℚ analysis the lane lacks) but wider
than needed for the remainder itself, which its own theorem gives exactly.
Replacement wording is offered at the end of `Madhava.agda` for its author to
take or leave; no line of that module is altered.

**Limits.** The *Yuktibhāṣā*'s correction terms are specific rational
expressions sharpening the truncated π-series; the exact finite remainder of a
geometric series is their algebraic ancestor and **not the same object**.
Neither the *Yuktibhāṣā* nor arXiv:2405.11134 has been opened — verse-level
sourcing OWED AND NOT CLAIMED. No convergence, no bound, no ordering: the
module records only that the error is multiplied by r each step, and whether
that shrinks it is exactly the un-said part. The collision is at n = 1, which
suffices to refute the factoring outright but says nothing about how much is
forgotten at larger n — one instance is one instance.
