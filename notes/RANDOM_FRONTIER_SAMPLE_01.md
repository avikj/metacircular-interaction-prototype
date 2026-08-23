# Random frontier sample 01: fourteen arXiv categories drawn by `shuf`, worked without exception

**Date:** 2026-08-14. **Branch:** `claude/repo-live-collaboration-4gn2fs`.
**Evidence grade throughout: śabda (search-summary) only.** `WebFetch` is
`EGRESS_BLOCKED` on every host tried this session, arxiv.org and ncatlab.org
included. **No paper below was read.** Every result is reported as the search
engine summarized it, and every citation should be treated as a *pointer to
verify*, not as verified. Where a summary is internally suspicious I say so.

**No new mathematics is claimed in this note.** It is reconnaissance plus a
verdict per field.

---

## 0. Why this note exists, and what it is testing

The human owner's instruction, verbatim:

> *"The repo touches all frontiers if ever you try to confine the search
> you're projecting your own mental boundaries and ignorance. Sampling
> randomly is literally better than trusting your judgement."*

Prior ingestion this session (`FRONTIER_2026_MAP.md`, `COMPILER_FRONTIER_MAP.md`,
`MATHLIB_INGESTION_MAP.md`, `PRIOR_ART_SWEEP_COMPLETE.md`) was scoped by a
coordinator's guess about which fields matter: analytic number theory,
formalization/HoTT, compilers/PL, coalgebra. That guess is the thing under
test. The experiment is:

> **Does uniform random sampling from an external taxonomy surface a live
> connection that the curated scoping omitted?**

That is a falsifiable question with a yes/no answer, and §5 answers it.

The design constraint that makes it an experiment rather than a survey: **the
sample frame is written down before the draw, the draw is mechanical, and no
draw may be rejected.** A draw of `q-bio.BM` is worked exactly as seriously as
a draw of `math.NT` — which in practice means "worked until an honest null is
reached", not "worked until a connection is manufactured".

**The null is the expected outcome and is recorded plainly.** `FIVE_FACES.md`
§9 supplies the discipline: Step 3 requires a third object containing both
sides carrying **a mixed term not visible in either view separately**; Step 4
reads a zero mixed term as *independent juxtaposition — drop it*. Nine of the
fourteen draws below are dropped on exactly that ground, and two more are
dropped as *methodological, not mathematical* — a distinction §3.5 and §3.11
make explicit, because a shared epistemic pattern is not a shared object.

---

## 1. The sample frame (written before the draw; auditable)

**External taxonomy used: the arXiv category list** — `math.*` (32),
`cs.*` (40), plus `math-ph`, `stat.*`, `q-bio.*`, `q-fin.*`, `econ.*`,
`eess.*`, `nlin.*`. Not invented here; not filtered. **109 lines.**

I did not restrict to `math.*` and `cs.*`, because that restriction would
itself have been the curation the experiment is testing.

```
  1  math.AC  Commutative Algebra
  2  math.AG  Algebraic Geometry
  3  math.AP  Analysis of PDEs
  4  math.AT  Algebraic Topology
  5  math.CA  Classical Analysis and ODEs
  6  math.CO  Combinatorics
  7  math.CT  Category Theory
  8  math.CV  Complex Variables
  9  math.DG  Differential Geometry
 10  math.DS  Dynamical Systems
 11  math.FA  Functional Analysis
 12  math.GM  General Mathematics
 13  math.GN  General Topology
 14  math.GR  Group Theory
 15  math.GT  Geometric Topology
 16  math.HO  History and Overview
 17  math.IT  Information Theory
 18  math.KT  K-Theory and Homology
 19  math.LO  Logic
 20  math.MG  Metric Geometry
 21  math.MP  Mathematical Physics
 22  math.NA  Numerical Analysis
 23  math.NT  Number Theory
 24  math.OA  Operator Algebras
 25  math.OC  Optimization and Control
 26  math.PR  Probability
 27  math.QA  Quantum Algebra
 28  math.RA  Rings and Algebras
 29  math.RT  Representation Theory
 30  math.SG  Symplectic Geometry
 31  math.SP  Spectral Theory
 32  math.ST  Statistics Theory
 33  cs.AI    Artificial Intelligence
 34  cs.AR    Hardware Architecture
 35  cs.CC    Computational Complexity
 36  cs.CE    Computational Engineering, Finance, and Science
 37  cs.CG    Computational Geometry
 38  cs.CL    Computation and Language
 39  cs.CR    Cryptography and Security
 40  cs.CV    Computer Vision and Pattern Recognition
 41  cs.CY    Computers and Society
 42  cs.DB    Databases
 43  cs.DC    Distributed, Parallel, and Cluster Computing
 44  cs.DL    Digital Libraries
 45  cs.DM    Discrete Mathematics
 46  cs.DS    Data Structures and Algorithms
 47  cs.ET    Emerging Technologies
 48  cs.FL    Formal Languages and Automata Theory
 49  cs.GL    General Literature
 50  cs.GR    Graphics
 51  cs.GT    Computer Science and Game Theory
 52  cs.HC    Human-Computer Interaction
 53  cs.IR    Information Retrieval
 54  cs.IT    Information Theory
 55  cs.LG    Machine Learning
 56  cs.LO    Logic in Computer Science
 57  cs.MA    Multiagent Systems
 58  cs.MM    Multimedia
 59  cs.MS    Mathematical Software
 60  cs.NA    Numerical Analysis
 61  cs.NE    Neural and Evolutionary Computing
 62  cs.NI    Networking and Internet Architecture
 63  cs.OH    Other Computer Science
 64  cs.OS    Operating Systems
 65  cs.PF    Performance
 66  cs.PL    Programming Languages
 67  cs.RO    Robotics
 68  cs.SC    Symbolic Computation
 69  cs.SD    Sound
 70  cs.SE    Software Engineering
 71  cs.SI    Social and Information Networks
 72  cs.SY    Systems and Control
 73  math-ph  Mathematical Physics
 74  stat.AP  Statistics — Applications
 75  stat.CO  Statistics — Computation
 76  stat.ME  Statistics — Methodology
 77  stat.ML  Machine Learning (Statistics)
 78  stat.TH  Statistics Theory
 79  q-bio.BM Biomolecules
 80  q-bio.CB Cell Behavior
 81  q-bio.GN Genomics
 82  q-bio.MN Molecular Networks
 83  q-bio.NC Neurons and Cognition
 84  q-bio.OT Other Quantitative Biology
 85  q-bio.PE Populations and Evolution
 86  q-bio.QM Quantitative Methods
 87  q-bio.SC Subcellular Processes
 88  q-bio.TO Tissues and Organs
 89  q-fin.CP Computational Finance
 90  q-fin.EC Economics
 91  q-fin.GN General Finance
 92  q-fin.MF Mathematical Finance
 93  q-fin.PM Portfolio Management
 94  q-fin.PR Pricing of Securities
 95  q-fin.RM Risk Management
 96  q-fin.ST Statistical Finance
 97  q-fin.TR Trading and Market Microstructure
 98  econ.EM  Econometrics
 99  econ.GN  General Economics
100  econ.TH  Theoretical Economics
101  eess.AS  Audio and Speech Processing
102  eess.IV  Image and Video Processing
103  eess.SP  Signal Processing
104  eess.SY  Systems and Control
105  nlin.AO  Adaptation and Self-Organizing Systems
106  nlin.CD  Chaos and Nonlinear Dynamics
107  nlin.CG  Cellular Automata and Lattice Gases
108  nlin.PS  Pattern Formation and Solitons
109  nlin.SI  Exactly Solvable and Integrable Systems
```

### 1.1 A defect in the frame, recorded honestly

The arXiv taxonomy is a **submission-routing taxonomy, not a partition of
mathematics**. It contains at least five residual bins that are not fields:
`math.GM`, `math.HO`, `cs.GL`, `cs.OH`, `q-bio.OT`. It also double-counts
Information Theory (`math.IT` = `cs.IT` are aliases of one another) and
Numerical Analysis (`math.NA` = `cs.NA`), and Mathematical Physics
(`math.MP` = `math-ph`). So the draw is uniform over *categories*, not over
*mathematics*, and ~5% of the frame cannot produce a frontier by construction.

I am recording this rather than fixing it, because fixing it after seeing the
draw is exactly the curation the experiment forbids. The draw did in fact hit
one residual bin (`math.GM`, §3.14) and one alias (`math.IT`, §3.10), and both
are worked as drawn. **A correct frame for a future replication should use
MSC 2020's 63 two-digit classes instead**, which is a partition of
mathematics proper — at the cost of no CS/stat coverage at all. Neither frame
is right; the honest move is to say which one was used.

---

## 2. The draw, verbatim

Command, run once, no re-rolls, output not reordered:

```
$ shuf -n 14 frame.txt
cs.SC Symbolic Computation
stat.ML Machine Learning (Statistics)
math.NT Number Theory
q-fin.CP Computational Finance
econ.TH Theoretical Economics
math.AT Algebraic Topology
math.RT Representation Theory
q-bio.BM Biomolecules
cs.MM Multimedia
math.IT Information Theory
math.MG Metric Geometry
econ.EM Econometrics
eess.SP Signal Processing
math.GM General Mathematics
```

Composition of the draw: 6 `math.*`, 2 `cs.*`, 2 `econ.*`, 1 `stat.*`,
1 `q-bio.*`, 1 `q-fin.*`, 1 `eess.*`. Against a frame that is 29% `math.*`
and 37% `cs.*`, this draw over-weights `math.*` (43%) and under-weights
`cs.*` (14%). With n=14 that is unremarkable, but it means **the draw is not
evidence about how much CS bears on the repo** — it barely sampled CS.

---

## 3. The fourteen fields

Each entry: the queries run verbatim; the 2025–26 frontier as reported; then
the connection verdict, with `FIVE_FACES.md` §9 Step 3/4 applied explicitly.

Verdict vocabulary, fixed in advance:

- **LIVE** — nonzero mixed term, actionable in this repo.
- **PLAUSIBLE-UNVERIFIED** — a candidate mixed term identified but *not*
  established; filed as `SEARCH`, droppable.
- **NULL (lexical)** — vocabulary overlaps, objects do not. Zero mixed term.
- **NULL (clean)** — no overlap of any kind.
- **NULL (methodological)** — the connection is about *how research is done*,
  not about a shared mathematical object. **Not counted as a connection.**

---

### 3.1 `cs.SC` — Symbolic Computation → **LIVE**

**Queries.** `symbolic computation 2025 2026 breakthrough results ISSAC
Groebner basis algorithm`; `Smith normal form algorithm 2025 2026 lattice
reduction integer matrix certified computation`; `e-graph equality saturation
2025 2026 symbolic computation proof-producing rewriting`.

**Frontier, as reported.**

1. **ISSAC 2025** (Guanajuato, 28 Jul – 1 Aug 2025) was the **50th** symposium;
   ISSAC 2026 is Oldenburg, 13–17 Jul 2026. Reported themes: leading monomials
   of minimal Gröbner bases of generic sequences (May 2025 preprints); and a
   visible sub-current of **transformer/ML oracles for algebraic
   computation** — "Computational Algebra with Attention: Transformer Oracles
   for Border Basis Algorithms" (arXiv:2505.23696), and work on the geometric
   generality of transformer-based Gröbner computation aimed at ISSAC 2025.
2. **Certified Smith normal form is a shipped artifact.** The Isabelle
   Archive of Formal Proofs entry *"A verified algorithm for computing the
   Smith normal form of a matrix"* is maintained and was reported current
   through **Isabelle2025-2 (Feb 2026)**. Adjacent AFP entry: *"Two algorithms
   based on modular arithmetic: lattice basis reduction and Hermite normal
   form computation."* On the unverified-algorithms side: fast SNF-with-
   multipliers for nonsingular integer matrices (J. Symb. Comput. 2023), Las
   Vegas SNF, and a cubic HNF algorithm (arXiv:2209.10685).
3. **EGRAPHS 2026** (fifth workshop, at PLDI 2026) — "From Rewriting to
   Fixpoints: Solving Recursive Equations with E-Graphs"; LLM-guided equality
   saturation (LGuess, arXiv:2604.17364); "Rewrite System Showdown:
   Stochastic Search vs. EqSat" (arXiv:2605.19005).

**Connection.** Two candidates; they must be scored separately.

**(a) Certified SNF — LIVE.** The repo has an entire Smith-normal-form lane
(28 note filenames match `smith`, e.g. the `ARITHMETIC_LIFE_*_SMITH_*` cluster
on elementary Smith paths, diagonal Smith systems, pivot divisibility
completion). `CLAUDE.md` makes exact/certified symbolic computation the *only*
always-admissible form of computation in this repo. So there is a shipped,
maintained, formally verified SNF algorithm sitting exactly on the repo's own
admissibility line — in Isabelle, while the repo's substrate is Agda
(`formal/cubical/`) and Lean (`formal/pairfield/`).

Step 3 mixed term: the third object is *"a machine-checked SNF in this repo's
substrate."* The mixed term visible in neither view alone is the **proof
obligation delta** — what the Isabelle development had to prove that an Agda
`--cubical --safe` development would not (classical choice in the termination
argument, decidable equality on ℤ, well-founded recursion on the ideal chain),
and vice versa. That is nonzero and it is *specific*: it tells a future block
what work an SNF formalization here actually costs, without re-deriving it.

Action, at the honest grade the evidence supports: **`SEARCH`, not `PROVE`** —
*does a machine-checked Smith normal form exist in mathlib or agda-unimath?*
The repo already has agda-unimath installed locally as a pre-`PROVE` index
(`PRIOR_ART_INDEX`, commit 3618633) and a mathlib ingestion map, so this is
answerable offline by the next block in minutes. If the answer is yes, part of
the SNF lane is a rediscovery and `PRIOR_ART_SWEEP_COMPLETE.md` gains a row.
If no, the AFP entry is the specification to port against.

**(b) E-graphs — LIVE but ALREADY HELD.** EGRAPHS 2026 bears directly on the
repo's proof-carrying-compilation lane, but `COMPILER_FRONTIER_MAP.md` §1
already covers e-graphs and equality saturation, including the question
"does proof-producing equality saturation already do CRYSTAL §L2 exactly?".
The only genuinely new item my search surfaced is the **fixpoint/recursive-
equations** direction (EGRAPHS 2026) — e-graph reasoning over *infinite*
structures, proving equality of recursively defined variables. That is closer
to the repo's coalgebraic future-behavior quotient than plain EqSat is, since
both are about equality of infinite behaviors. I flag it and do **not** claim
it: establishing that e-graph fixpoint reasoning and the Myhill–Nerode/
coalgebra quotient share an object requires reading the paper, which egress
blocked.

**Verdict: LIVE**, on (a) primarily. Curated scoping covered (b), not (a).

---

### 3.2 `stat.ML` — Machine Learning (Statistics) → **NULL (methodological)**

**Query.** `statistics machine learning theory 2025 2026 major results scaling
laws generalization theorem`.

**Frontier, as reported.** A dense 2025–26 stream on scaling-law *theory*:
"Sharp feature-learning transitions and Bayes-optimal neural scaling laws in
extensive-width networks" (arXiv:2605.10395); "Scaling Laws from Sequential
Feature Recovery: A Solvable Hierarchical Model" (arXiv:2605.14567); "Improved
Scaling Laws via Weak-to-Strong Generalization in Random Feature Ridge
Regression" (arXiv:2603.05691); "Asymmetric Scaling Laws from Sparse
Features" (arXiv:2605.23591); an asymptotic theory of in-context learning by
linear attention (PNAS 2025); and a survey, "(Mis)fitting: A Survey of Scaling
Laws" (ICLR 2025).

*Caveat on grade:* several arXiv IDs above (26xx.xxxxx) are as returned by the
search engine and I could not verify a single one. Treat the list as a
direction, not as citations.

**Connection.** Zero mathematical cross term. The repo has no learning-theoretic
object; random-feature ridge regression and the parity barrier share nothing.

But there is a real, non-mathematical observation worth one paragraph, and it
cuts *against* the field rather than toward it. `CLAUDE.md`'s §"Corollary,
learned the hard way": *measuring a constant at one scale hides its scaling; a
number without its X-dependence is worse than no number, because it looks like
knowledge.* The scaling-law literature is the largest active research program
whose primary output is fitted exponents. The interesting datum is that the
2025–26 frontier of that literature is precisely the move `CLAUDE.md`
mandates — *solvable* models (arXiv:2605.14567 is titled "A Solvable
Hierarchical Model"), *sharp transitions*, *Bayes-optimal* rates, and a survey
whose title is "(Mis)fitting". The field is independently converging on
"derive the exponent, don't fit it." That is corroboration of the repo's
protocol from an unrelated discipline.

It is **not a connection**. There is no shared object; the third object
containing both would be "research methodology", which is not mathematics.
Under §9 Step 4 this is a zero mixed term and gets dropped from the ledger. I
record it in prose only, and it must not be cited as a result.

**Verdict: NULL (methodological).**

---

### 3.3 `math.NT` — Number Theory → **LIVE, but fully held already**

**Query.** `number theory 2025 2026 breakthrough results parity barrier prime
gaps Goldbach progress`.

**Frontier, as reported.** The single named result the search returned:
**Jared Duker Lichtman** extended the level of distribution for primes to
≈**0.617**, used for improved upper bounds on twin primes and Goldbach
representations — *the first use of a level of distribution beyond
Bombieri–Vinogradov's 1/2* for that problem. Also returned: assorted low-grade
material (a windowed sieve "avoiding the classical parity obstruction",
Goldbach verified to 4·10¹⁸, and several blog/SEO pages) that I do not
propagate.

**Connection.** This is the repo's home field, so of course there is one — and
that is the point. `FRONTIER_2026_MAP.md` Part A already carries this result
as row **A5**, with more precision than my search returned: the exact level
$66/107$, the improvement over Maynard's $3/5$, the predecessor chain
(arXiv:2211.09641 $x^{17/32}$, arXiv:2109.02851 $x^{10/17}$), the citation
arXiv:2309.08522, **and** the consequence that `WIDTH.md`'s uniqueness claim
for Granville–Shao's $X^{20/39-\varepsilon}$ is false as worded, with a named
correction action. It also carries A6 (Pascadi, $5/8$, removes the Selberg
eigenvalue dependence), A8 (Helfgott–Radziwiłł expansion/parity, flagged as
the corpus's largest parity blind spot), and thirteen more rows my query did
not reach.

**This is the experiment's control, and it behaved as a control should.**
Random sampling recovered ~1/17th of what curation had already extracted from
the same field, at lower resolution. On its home turf, curation wins
decisively — which is expected and is *not* an argument against the
experiment; it is the calibration that makes §5's positive findings legible.

**Verdict: LIVE, zero marginal value.** Nothing to add to A5.

---

### 3.4 `q-fin.CP` — Computational Finance → **NULL (clean)**

**Query.** `computational finance 2025 2026 frontier results rough volatility
neural SDE deep hedging`.

**Frontier, as reported.** Signature methods have taken over the non-Markovian
lane: signature volatility models with Fourier pricing/hedging (SIAM J. Fin.
Math., 2025); rough PDEs for local stochastic volatility (Math. Finance,
2025); American options under rough volatility via deep signatures and
signature kernels (2025); "Hedging with memory: shallow and deep learning with
signatures" (arXiv:2508.02759); a risk-neutral neural operator for
arbitrage-free SPX-VIX term structures (arXiv:2511.06451).

**Connection.** None. Step 2 runs dry on every question: no shared generators,
no shared invariant, no representation relation, no adjunction. The nearest
lexical neighbor is the *path signature* — a graded algebra of iterated
integrals, which is a genuinely beautiful object with a tensor-algebra grading
— and the repo has graded/filtration structures (`TWO_ADIC_FILTRATION_
SIGNATURE_REVIEW.md` even contains the word "signature"). That is a **pure
homonym**: the repo's "signature" is a type-theoretic/valuation signature, not
Chen's iterated-integral signature. Constructing the third object gives
"two things both called a signature", whose mixed term is exactly zero.

**Verdict: NULL (clean).** Recorded as a worked null, not a skipped draw.

---

### 3.5 `econ.TH` — Theoretical Economics → **NULL (clean)**

**Query.** `theoretical economics 2025 2026 frontier results mechanism design
information design new theorems`.

**Frontier, as reported.** **Bergemann–Heumann–Morris (2026)**, "Information
Design and Mechanism Design: An Integrated Framework" (CEPR DP21088): when a
designer chooses mechanism *and* information structure jointly, the problem
becomes **bilinear with two majorization constraints**, and pooling of values
and allocations is always optimal; with discrete values, some pooling is
optimal provided the distribution's **entropy is at least log 8**. Also: a
Test Replacement theorem (Theoretical Economics 20 (2025) 1247–1284) on
canonical implementation with one test.

**Connection.** None. I looked hardest at the entropy ≥ log 8 threshold,
because a sharp constant in an information-theoretic condition is the shape of
thing this repo cares about — but it is a threshold in a majorization problem
over value distributions, with no arithmetic or type-theoretic content, and no
route to any repo object. Third object: none constructible. Mixed term: zero.

Nor does the repo's CEGIS/CEGAR predicate-invention loop connect to mechanism
design, despite both being "design" problems with adversarial structure: the
CEGIS adversary produces *counterexamples to a specification*, the mechanism-
design adversary produces *deviations from an equilibrium*. Those are not the
same adversary and the analogy carries no theorem across.

**Verdict: NULL (clean).**

---

### 3.6 `math.AT` — Algebraic Topology → **NULL (lexical), with a boundary note**

**Queries.** `algebraic topology 2025 2026 breakthrough telescope conjecture
chromatic homotopy stable homotopy groups`; `2025 2026 synthetic algebraic
topology cubical Agda formalized homotopy groups univalent foundations
progress`.

**Frontier, as reported.**

1. **Ravenel's Telescope Conjecture is false** — Burklund–Hahn–Levy–Schlank,
   2023, via K-theoretic counterexamples (arXiv:2310.17459). This is *the*
   event in chromatic homotopy theory of the decade: the last surviving
   Ravenel conjecture, resolved negatively, through a new interface between
   algebraic K-theory and chromatic homotopy. The 2025–26 activity is the
   aftermath — an Isaac Newton Institute workshop literally named "Beyond the
   telescope conjecture", and ANR project ANR-25-CE40-2861 (K-theory, actions
   and stable homotopy).
2. On the formalized side: higher Schreier theory in cubical Agda (J. Symbolic
   Logic, 2025); the **Whitehead tower in cubical Agda** with universal
   property, homotopy group computations, and fiber identification as
   Eilenberg–MacLane spaces; the zigzag construction of path spaces of
   pushouts (arXiv:2510.08452); π₄(S³) formalized and *computed* in cubical
   Agda (arXiv:2302.00151); synthetic integral cohomology (CSL 2022) and
   computational synthetic cohomology theory (arXiv:2401.16336).

**Connection.** This draw requires care, because the naive answer is "yes,
obviously — the repo does cubical Agda and ℕ = π₀(FinSet)", and that answer is
wrong on the field boundary.

Against the **`math.AT` frontier proper** (item 1): zero. Chromatic homotopy,
telescopic localization, and the K-theoretic counterexample machinery have no
contact with anything here. The repo's decategorification is π₀ of FinSet —
the connected-components functor applied to a *discrete-ish* category, whose
entire content is that ℕ is the set of iso-classes of finite sets. That is
π₀ in the sense of "the trivial bottom of the tower". Chromatic homotopy is
about the structure at *heights ≥ 1*, i.e. precisely everything π₀ discards.
The third object is "the Postnikov/chromatic tower", and the repo lives at its
basepoint; the mixed term is zero **by construction**, since the repo's object
is the truncation that kills the frontier's object.

Against item 2, the connection is real but **it is not `math.AT`'s** — it is
`cs.LO`/`math.LO`, which the curated scoping already covered
(`FRONTIER_2026_MAP.md` Part B, the formalization frontier; the
`CUBICAL_LIBRARY_SUBSUMPTION_AUDIT` finding that 10 of 20 constructs already
existed in the library). Crediting `math.AT` for the Whitehead-tower
formalization would be scoring the draw against a paper the draw did not
select.

I flag one thing for the record rather than as a claim: the Whitehead tower
formalization and the zigzag path-space construction are the kind of upstream
`agda-unimath`/cubical-library additions that the subsumption audit exists to
catch. Whether either subsumes a repo construct is answerable **offline**
against the local index, and should be, but that is a Part-B action, not a
`math.AT` connection.

**Verdict: NULL (lexical)** for `math.AT` as drawn. The word "homotopy" is
shared; the frontier is not.

---

### 3.7 `math.RT` — Representation Theory → **NULL (lexical) — the instructive one**

**Queries.** `representation theory 2025 2026 major results modular
representations Deligne categories Langlands`; `decategorification
categorification 2025 2026 representation theory Grothendieck group results`.

**Frontier, as reported.** **Dennis Gaitsgory, 2025 Breakthrough Prize in
Mathematics**, for the categorical equivalence in geometric Langlands.
Alongside: modular representations of affine Lie algebras in characteristic
p > 0 (Harish-Chandra center, linkage principle, a Kac–Kazhdan analogue);
factorizable Koszul duality for spherical categories on affine Grassmannians,
with Langlands-dual Lie algebra actions on intersection cohomology; braid-group
traces on Deligne–Lusztig varieties with an SL(2,ℤ)-action; coherent Springer
theory and the categorical Deligne–Langlands correspondence (Invent. Math.).
On categorification: traces of categorified quantum groups and Heisenberg
algebras landing on current algebras, W-algebras, elliptic Hall algebras.

**Connection.** **None — and this is the draw most worth writing down**,
because it is the cleanest lexical trap in the whole sample.

The repo's stated objects include *decategorification (ℕ as π₀ of FinSet)*.
The `math.RT` frontier's stated objects include *decategorification (the
Grothendieck-group functor)*. Same word. Two searches, both returning the same
definition — "decategorification is a functor; it's just a fancy name for
taking the Grothendieck group."

Run Step 2 anyway. Same generators? The repo's side has one generator (the
one-element set) and the decategorification is a bijection FinSet/≅ → ℕ. The
RT side's Grothendieck group is taken of a category with genuinely interesting
extensions, and the whole subject is that K₀ **loses** information which the
categorification restores. Is one a representation of the other? No. Is one a
quotient and the other a refinement? Superficially yes — both are quotients by
iso — but the repo's quotient is *lossless* (FinSet is skeletal up to
equivalence; π₀ is an equivalence of the groupoid with ℕ as a discrete
category), while the RT quotient is *lossy by design*, and that lossiness is
the field's entire content. A recent note reported by search puts it exactly:
in a finite-length category, the Grothendieck group "completely reduces the
category to its simple building blocks" — i.e. K₀ is interesting precisely
where simple objects are.

Third object: "the decategorification functor in general". Mixed term: **zero**.
Everything the RT frontier studies lives in the kernel of what the repo's
instance does, because the repo's instance has trivial kernel. §9 Step 4(ii):
independent juxtaposition, **drop it**.

**This is the load-bearing null of the sample.** A curated search that went
looking for "decategorification" would have hit `math.RT` and, without the
mixed-term test, might have written a paragraph about how the repo's ℕ =
π₀(FinSet) "connects to categorification in representation theory." It does
not. `FIVE_FACES.md` §9 caught it in about ten minutes of honest questioning,
which is the norm doing its job on a live case rather than on a retrospective.

**Verdict: NULL (lexical).**

---

### 3.8 `q-bio.BM` — Biomolecules → **NULL (clean)**

**Query.** `q-bio biomolecules 2025 2026 frontier AlphaFold3 protein structure
prediction RNA design results`.

**Frontier, as reported.** AlphaFold 3 (released 8 May 2024) as the incumbent:
76% of predicted protein–ligand binding poses within 2 Å, vs 38% for DiffDock;
lDDT 0.790 on protein–nucleic-acid complexes vs RoseTTAFold's 0.65–0.70.
Reported limitations: intrinsically disordered proteins (hallucination study,
arXiv:2510.15939), template-free membrane proteins, assemblies > 2 MDa, ion
and peptide poses in GPCRs, and *minimal correlation between predicted and
experimental binding affinities*. AlphaFold DB redesigned in 2025; as of
March 2026, fewer than 50 institutions have local AF3 deployment. On RNA:
evaluated on CASP-RNA, improving on RoseTTAFold2NA and AIchemy_RNA, with
noted limits (PMC review, "Has AlphaFold3 achieved success for RNA?").

**Connection.** None, on any Step 2 question. I note without endorsing it that
the AF3 limitation list is a catalogue of exactly the failure `CLAUDE.md`
legislates against — a benchmark number (lDDT 0.790) that does not carry its
own error analysis, and, explicitly, "minimal correlation between predicted
and experimental binding affinities" from a model reported by its aggregate
score. That is the same **methodological** observation as §3.2 and it is
counted the same way: not a connection.

**Verdict: NULL (clean).** Worked as drawn, per the no-rejection rule.

---

### 3.9 `cs.MM` — Multimedia → **NULL (clean)**

**Query.** `multimedia research 2025 2026 frontier results ACM Multimedia video
generation compression`.

**Frontier, as reported.** ACM Multimedia 2025 (33rd edition): >7,100 abstract
submissions, 1,250 regular papers accepted, 25 grand challenges, 30 workshops.
The named research frontier is the **convergence of generative modeling and
data compression** — generative-prior-assisted visual compression, semantic
feature coding, latent representation unification across modalities
(cf. "Conditional Video Generation for High-Efficiency Video Compression",
arXiv:2507.15269). Application drivers: AR/VR/XR, volumetric video, real-time
conferencing. ACM MM 2026 and ICME 2026 both scheduled.

**Connection.** None. The one place I probed seriously: "compression as
learning" is a real idea with real theory behind it (MDL, Kolmogorov
complexity), and the repo has a *learning* note
(`GENERATIVE_LOOP_IS_LEARNING.md`). But the `cs.MM` frontier is
rate-distortion-optimal perceptual compression, which is a lossy, perceptual,
benchmark-driven enterprise; the repo's generative loop is about term
construction in a type theory. Third object would have to be "description
length", and neither side's actual results would appear in it. Mixed term:
zero.

**Verdict: NULL (clean).**

---

### 3.10 `math.IT` — Information Theory → **NULL (clean), with a negative search result worth keeping**

**Queries.** `information theory 2025 2026 breakthrough results ISIT capacity
Reed-Muller codes polar codes proof`; `Myhill-Nerode automata minimization
information theory 2025 entropy state complexity results`.

**Frontier, as reported.** The Reed–Muller line dominates. Abbe–Sandon proved
RM codes achieve Shannon capacity on symmetric channels (FOCS 2023;
arXiv:2304.02509), following RM-achieves-capacity-on-erasure-channels (STOC
2016). The 2025–26 continuation: "Reed–Muller Codes for Quantum Pauli and
Multiple Access Channels" (Abdelhadi–Sandon–Abbe–Urbanke, ISIT, 22 Jun 2025);
"Reed–Muller Codes on CQ Channels via a New Correlation Bound for Quantum
Observables" (Mandal–Pfister, ISIT, 22 Jun 2025); "List-Decoding Capacity
Implies Capacity on the q-ary Symmetric Channel" (STOC, 15 Jun 2025); "Tensor
Reed–Muller Codes: Achieving Capacity with Quasilinear Decoding Time"
(arXiv:2601.16164); RPA-decoding error bounds over the BSC.

**Connection.** None to the repo's objects. Codes, channels and capacity have
no contact with the parity barrier, the SNF torsor lane, or the type theory.
(Note: "parity" appears on both sides — parity-check codes vs the parity
barrier in sieve theory — and is a homonym of the §3.7 kind, worth naming so
no future block trips on it.)

**The negative search result is the part worth keeping.** The repo's
future-behavior/Myhill–Nerode quotient is *prima facie* an information-theoretic
object: the Nerode equivalence classes are exactly the distinguishable
information states, and minimal-DFA state count is the natural "how much must
be remembered" measure. I therefore ran a second, targeted query looking for
2025–26 work joining Myhill–Nerode to entropy/state complexity. **It returned
nothing but textbook expositions** (GeeksforGeeks, tutorialspoint, a 2025
IRJET pattern-recognition paper) — no research frontier at that junction, and
the search summary said so explicitly.

That is a useful null to record, because it is the difference between "I did
not look" and "I looked and the junction is not currently active." A future
block asking whether the coalgebraic quotient has an information-theoretic
refinement should know that a śabda-grade search on 2026-08-14 found no live
literature there, and should search `cs.FL`/`cs.LO` rather than `math.IT`.

**Verdict: NULL (clean).**

---

### 3.11 `math.MG` — Metric Geometry → **NULL (methodological)**

**Query.** `metric geometry 2025 2026 results sphere packing Kissing number
Gromov-Hausdorff optimal transport theorem`.

**Frontier, as reported.** The kissing-number problem is moving, and moving by
machine.

1. **Dimension 17 (Jan 2025):** a new kissing configuration, reported by
   Quanta ("Mathematicians Discover New Way for Spheres to 'Kiss'"), with
   Ferenc Szöllősi's construction independently rediscovered by another pair.
2. **Dimension 13:** a `PackingStar` search surpassed the 1971 rational
   structure of 1130 spheres, reaching **1146**.
3. **Dimension 25:** a discovered configuration reported to match the Leech
   lattice's substructure closely, with **"rigorous mathematical proof still
   lacking."**
4. Method papers: "Mathematical exploration and discovery at scale"
   (arXiv:2511.02864); "Finding Kissing Numbers with Game-theoretic
   Reinforcement Learning" (arXiv:2511.13391); improved kissing numbers in
   dimensions 17–21 (2024); a new dim-19 lower bound (2026); structure of
   kissing arrangements in ℝ¹² (2026). Adjacent: optimal partial transport
   for metric pairs and Gromov–Hausdorff convergence of metric pairs
   (arXiv:2406.17674).

**Connection.** Mathematically, none. Sphere packing, kissing configurations
and optimal transport share no object with the repo. Step 2 returns nothing on
any question; no third object is constructible.

Methodologically, this is the sharpest external datum in the whole sample and
it deserves recording *because it is not a connection*. The `math.MG` frontier
in 2025–26 consists of **machine-discovered configurations that are true, are
better than the human record, and are not proved** — item 3 states the gap
explicitly: strong convergence across multiple metrics, no proof. That is a
research community operating exactly at the boundary `CLAUDE.md` draws
between "exact/certified symbolic computation *is* proof" and "everything else
stands in for an error analysis you have not done." And note which side of the
line these land on: a kissing configuration is a **finite exhaustive
verification** — exhibit 1146 unit vectors, check pairwise angles exactly —
so a *found* configuration in dim 13 is a certificate and is proof, while the
dim-25 "corresponds closely to the Leech substructure, convergence across
multiple metrics" claim is precisely the fitted-quantity failure mode, in a
field with no obvious stake in this repo's protocol.

Both halves of `CLAUDE.md`'s distinction show up in one field, drawn at
random, with the line falling where the repo's rule says it should. That is
corroboration of the rule's *external validity*, which is more than a
restatement — but it is still not mathematics, there is no shared object, and
the mixed term is zero.

**Verdict: NULL (methodological).** Not counted in §5's tally.

---

### 3.12 `econ.EM` — Econometrics → **NULL (clean)**

**Query.** `econometrics 2025 2026 frontier results causal inference
identification double machine learning theory`.

**Frontier, as reported.** Double/debiased machine learning (Chernozhukov
et al.) remains the frame, with 2025–26 refinements: a **Bernstein–von Mises
theorem for Bayesian DML** when (log n)² ≺ p ≺ √n, giving posterior credible
sets that are valid frequentist confidence intervals (arXiv:2508.12688);
anytime-valid inference for DML of causal parameters (arXiv:2408.09598); DML
for static panel models with fixed effects (Econometrics Journal, 2025);
structural DiD with ML (arXiv:2507.15899); latent-variable modeling for robust
causal effect estimation (arXiv:2508.20259).

**Connection.** None. Step 2 dry on all questions.

I record one deliberate non-connection so it is not proposed later. DML's
central technical device is **Neyman orthogonality** — constructing a moment
condition whose derivative with respect to the nuisance parameter vanishes, so
first-order nuisance error does not contaminate the target. That has a real
formal resemblance to *any* first-order-cancellation argument, and this repo
has several (stationary phase; the error-term discipline in `CLAUDE.md`;
`LEAKAGE_PAST_IDEMPOTENCE`). But "both involve a vanishing first derivative"
is a resemblance of *technique class*, not of object. Building the third
object gives "things with vanishing first-order sensitivity", a class so large
it has no content. Mixed term: zero. This is the shape of forced connection
the task warns against, and I am declining it explicitly rather than silently.

**Verdict: NULL (clean).**

---

### 3.13 `eess.SP` — Signal Processing → **PLAUSIBLE-UNVERIFIED (the interesting draw)**

**Queries.** `signal processing 2025 2026 frontier results graph signal
processing sampling theory compressed sensing`; `p-adic signal processing
wavelets adic sampling 2025 dyadic multiresolution inverse limit`.

**Frontier, as reported.**

1. **Graph signal processing + sampling** is the active mainstream: sampling
   theory of jointly bandlimited time-vertex graph signals (arXiv:2508.21412);
   random space-time sampling and reconstruction of sparse bandlimited graph
   diffusion fields (arXiv:2410.18005); irregularity-aware bandlimited
   approximation for graph signal interpolation. Compressed sensing on graphs
   recovers sparse edge-property vectors from measurements constrained to
   connected paths.
2. **`p`-adic multiresolution analysis** — a smaller, older, live sub-field.
   The reported structural facts: `p`-adic MRA uses **translations by elements
   of the quotient group $\mathbb{Q}_p/\mathbb{Z}_p$** rather than by
   integers; the Bruhat–Schwartz space of `p`-adic test functions *is* a
   multiresolution approximation, so **MRA is a natural property of `p`-adic
   analysis** rather than an imposed construction; and the continuous `p`-adic
   wavelet transform **coincides** with the discrete one (arXiv:math-ph/0702010)
   — translations and dilations of `p`-adic wavelets land exactly on vectors
   of the discrete basis. Recent: nonuniform wavelet frames on
   non-Archimedean fields (arXiv:2605.09389); step refinable functions and
   orthogonal MRA on `p`-adic Vilenkin groups; `p`-adic MRA and wavelet frames
   (arXiv:0802.1079, arXiv:0810.1147).

**Connection.** This is the draw the curated scoping would never have made,
so I will be correspondingly careful not to oversell it.

The repo has an adic/digit lane: `DIGIT_CRYSTAL.md`, `TWO_ADIC_CONFINEMENT.md`,
`TWO_ADIC_FILTRATION_SIGNATURE_REVIEW.md`, `RADICAL_SPLIT_STATE.md`, and the
digit-chart/inverse-limit apparatus named in the task brief.

Step 2, honestly. *Is one a representation of the other?* — this is the
question that fires. The `p`-adic MRA is a **unitary representation on
$L^2(\mathbb{Q}_p)$ indexed by exactly the inverse-limit/coset structure the
repo's digit charts are built from**: the tower
$\mathbb{Z}_p \supset p\mathbb{Z}_p \supset p^2\mathbb{Z}_p \supset \cdots$,
whose cosets are the digit chart, is the same tower whose quotient
$\mathbb{Q}_p/\mathbb{Z}_p$ indexes the wavelet translations. That is not a
homonym; it is the same tower, appearing on both sides.

Step 3, the mixed term. The third object would be **the digit chart equipped
with Haar measure and its wavelet basis**. The candidate mixed term — the
thing invisible from either side alone — is whether the repo's chart maps are
**isometries / orthogonal projections** for that structure, i.e. whether the
adic filtration the repo already uses is the *same* filtration as the MRA's
scale filtration, and if so whether the coincidence of the continuous and
discrete `p`-adic wavelet transforms says anything about the repo's charts
being simultaneously discrete and continuous descriptions of one object.

**I have not established this, and I am not claiming it.** Two specific
reasons for caution, stated so a future block does not inherit false
confidence:

- The repo's charts carry **no measure and no orthogonality**; they are
  arithmetic/type-theoretic. The wavelet side carries **no arithmetic
  content** — it is harmonic analysis on a local field, indifferent to which
  integers the digits encode. It is entirely possible that the shared tower is
  shared *as an index set only*, in which case the mixed term is zero and this
  gets dropped like §3.7.
- Egress blocked every paper. The structural claims in item 2 are search
  summaries of abstracts, and the load-bearing one ("MRA is a natural property
  of `p`-adic analysis") is exactly the sort of sentence that is precise in
  the paper and vague in a summary.

Filed as **`SEARCH`**, phrased so it is falsifiable: *does the repo's digit
chart, equipped with Haar measure on $\mathbb{Z}_p$, reproduce the standard
`p`-adic MRA filtration — and if so, does any repo statement about the charts
acquire content from the coincidence of the continuous and discrete `p`-adic
wavelet transforms?* If the answer to the second half is no, **drop the
connection** under §9 Step 4(ii); a shared index set with no transported
theorem is independent juxtaposition wearing a suggestive coincidence.

**Verdict: PLAUSIBLE-UNVERIFIED.** Not a result. A `SEARCH` item that would
not exist without the random draw.

---

### 3.14 `math.GM` — General Mathematics → **NULL (structural)**

**Query.** `arXiv math.GM General Mathematics category 2025 scope moderation
what is published`.

**Frontier, as reported.** There is none, and the search establishes why.
`math.GM`'s official scope is *"Mathematical material of general interest,
topics not covered elsewhere."* The 2025 listings returned a scatter with no
common subject: `p`-adic mathematics, Fermat-type factorization algorithms,
fuzzy variational calculus, elliptic curves, optimization, approximation
theory, fuzzy set theory. In practice `math.GM` functions as arXiv's
residual/overflow bin and is widely treated as the destination for
submissions that other `math.*` moderators declined — so the category has, by
construction, **no frontier**, no community, and no research program.

(One incidental policy datum from the same search, worth a line since the repo
tracks publication norms: arXiv now requires review articles and position
papers in the **CS** categories to have been accepted at a peer-reviewed venue
before submission. No analogous `math.GM` policy was located.)

**Connection.** Not applicable — there is no field here to connect to. This is
a **frame defect surfacing as a draw**, exactly as §1.1 anticipated: the
arXiv taxonomy is a routing table, and ~5% of its entries are routing
artifacts. The draw is worked and recorded rather than re-rolled, because
re-rolling it would have been the first act of curation.

The honest lesson for replication: a frame of 109 categories with 5 non-fields
means ~4.6% of any uniform draw is wasted by construction. At n=14 the
expected number of dead draws is 0.64; I got 1. That is within noise and is
**not** evidence that the method is inefficient — it is a known, quantified,
and cheap cost of using an external frame instead of a curated one, and it is
much smaller than the cost of the bias the external frame removes.

**Verdict: NULL (structural).**

---

## 4. Tally

| # | Field | Verdict | Counts as a connection? |
|---|-------|---------|---|
| 1 | `cs.SC` Symbolic Computation | **LIVE** — certified SNF in AFP (Isabelle2025-2, Feb 2026); EGRAPHS 2026 fixpoint e-graphs | **YES** |
| 2 | `stat.ML` Machine Learning | NULL (methodological) | no |
| 3 | `math.NT` Number Theory | **LIVE**, zero marginal — already `FRONTIER_2026_MAP` A5 | **YES (held)** |
| 4 | `q-fin.CP` Computational Finance | NULL (clean) — "signature" is a homonym | no |
| 5 | `econ.TH` Theoretical Economics | NULL (clean) | no |
| 6 | `math.AT` Algebraic Topology | NULL (lexical) — repo lives at π₀, frontier at heights ≥ 1 | no |
| 7 | `math.RT` Representation Theory | NULL (lexical) — decategorification is a homonym | no |
| 8 | `q-bio.BM` Biomolecules | NULL (clean) | no |
| 9 | `cs.MM` Multimedia | NULL (clean) | no |
| 10 | `math.IT` Information Theory | NULL (clean) + a recorded negative search on Myhill–Nerode × entropy | no |
| 11 | `math.MG` Metric Geometry | NULL (methodological) | no |
| 12 | `econ.EM` Econometrics | NULL (clean) — Neyman orthogonality declined explicitly | no |
| 13 | `eess.SP` Signal Processing | **PLAUSIBLE-UNVERIFIED** — `p`-adic MRA vs the digit chart | **YES (provisional)** |
| 14 | `math.GM` General Mathematics | NULL (structural) — not a field | n/a |

**Score: 3 of 14 produced a connection** (one of them holding nothing new),
**10 clean or lexical nulls, 1 structural non-field.** Two additional
methodological corroborations recorded in prose and deliberately excluded from
the count.

---

## 5. The experiment's actual result

**Which drawn fields produced a live connection?**

- **`cs.SC` (Symbolic Computation)** — a genuine, actionable one: a maintained,
  formally verified Smith normal form (AFP, current to Isabelle2025-2,
  Feb 2026) sitting on the repo's own admissibility line, against a 28-note
  SNF lane that has no machine-checked SNF in its own substrate. Plus the
  e-graph *fixpoint* direction at EGRAPHS 2026, which is nearer the coalgebraic
  behavior quotient than the equality-saturation material already held.
- **`math.NT` (Number Theory)** — live, but the curated map already holds it at
  higher resolution (A5, plus sixteen rows the draw did not reach). This is the
  control, and it confirms that on the repo's home field curation dominates.
- **`eess.SP` (Signal Processing)** — provisional: `p`-adic multiresolution
  analysis is indexed by the same $\mathbb{Z}_p \supset p\mathbb{Z}_p \supset
  \cdots$ tower as the repo's digit charts. Filed as `SEARCH`, explicitly
  droppable if the mixed term turns out to be zero.

**Was any of them a field the coordinator's curated scoping would have
excluded?**

The curated scoping was: analytic number theory, formalization/HoTT,
compilers/PL, coalgebra — i.e. `math.NT`, `cs.LO`/`math.LO`/`math.CT`,
`cs.PL`/`cs.SE`. Against that list:

- `math.NT`: **inside** the curated scope. No credit.
- `cs.SC`: **partly outside.** The e-graph half sits in `cs.PL`, which was
  curated. The certified-computer-algebra half — verified SNF, HNF, lattice
  reduction in proof assistants — is `cs.SC`/`cs.MS`, which the curated
  scoping named nowhere. `COMPILER_FRONTIER_MAP.md` searched compilers, not
  computer algebra, and the repo's largest single note cluster is an
  integer-matrix normal-form lane. **Credit: partial.**
- `eess.SP`: **entirely outside.** No plausible reading of "number theory,
  HoTT, compilers, coalgebra" reaches Signal Processing. A coordinator would
  not have drawn it, and I would not have drawn it either; it arrived only
  because `shuf` did not know it was supposed to be irrelevant. **Credit:
  full, conditional on the `SEARCH` item surviving.**

**Answer.** Yes — **random sampling surfaced at least one field
(`eess.SP`) and part of a second (`cs.SC`'s certified-computer-algebra half)
that the curated scoping omitted by construction**, at a cost of ten honest
nulls and one dead category. The nulls are cheap: each cost one search and one
application of the §9 mixed-term test, and three of them
(§3.7 `math.RT`, §3.6 `math.AT`, §3.12 `econ.EM`) are *useful* nulls, in that
they pre-refute connections a future agent might otherwise propose on the
strength of a shared word.

**The caveat that keeps this honest.** n=14 with one provisional hit is not a
significant result about method, and this note must not be cited as one. What
it does establish is weaker and still worth having: **the curated scoping had
a blind spot of the kind the owner predicted, and a mechanical draw found one
in fourteen tries.** The value asymmetry does the rest of the work — a null
costs one search, and a missed field costs however long it stays missed.

Whether §3.13 survives contact with the actual `p`-adic MRA literature is
unknown, and if it does not, the honest report will be that the experiment
scored `cs.SC`-partial only.

---

## 6. Items this note leaves for the queue

All are `SEARCH`, none are `PROVE`, and none should be promoted without
reading a primary source — which requires egress this session did not have.

1. **`SEARCH`** — Does a machine-checked Smith normal form exist in mathlib or
   agda-unimath? Answerable **offline** against the local `PRIOR_ART_INDEX`
   and `MATHLIB_INGESTION_MAP`. If yes → a row for `PRIOR_ART_SWEEP_COMPLETE`;
   if no → the AFP entry is the spec to port against. (§3.1)
2. **`SEARCH`** — Does the repo's digit chart with Haar measure reproduce the
   `p`-adic MRA filtration, and does any repo statement acquire content from
   the continuous/discrete `p`-adic wavelet coincidence? **Drop if the mixed
   term is zero.** (§3.13)
3. **`SEARCH`** — Do the 2025 cubical-Agda additions (Whitehead tower, zigzag
   path spaces of pushouts, higher Schreier theory) subsume any repo
   construct? A `CUBICAL_LIBRARY_SUBSUMPTION_AUDIT` follow-up, answerable
   offline. Filed under Part B, **not** as a `math.AT` connection. (§3.6)
4. **Recorded negative** — no live 2025–26 literature joining Myhill–Nerode to
   entropy/state complexity was found; a future block should search `cs.FL`
   and `cs.LO`, not `math.IT`. (§3.10)
5. **Replication note** — if this experiment is repeated, use **MSC 2020's 63
   two-digit classes** as the frame (a partition of mathematics, no residual
   bins) and accept the loss of CS/stat coverage, or use both frames and draw
   from each. Do not hand-patch the arXiv frame after seeing a draw. (§1.1)

---

## 7. Honesty ledger

- **Every citation in this note is śabda grade.** No paper was read; `WebFetch`
  was `EGRESS_BLOCKED` on all hosts. arXiv IDs are as returned by the search
  engine and several (`26xx.xxxxx` in §3.2, §3.7, §3.11) could not be
  cross-checked at all. Verify before citing anywhere else.
- **No mathematics is claimed.** §3.13 is a question, not a result.
- **The draw was run once.** No re-rolls, no rejected draws, no reordering.
  `math.GM` was worked as a draw despite being a non-field.
- **Two connections were deliberately declined** rather than written up:
  Neyman orthogonality ↔ first-order cancellation (§3.12), and
  compression-as-learning ↔ the generative loop (§3.9). Both fail the
  mixed-term test, and declining them in writing is part of the record.
- **Two methodological corroborations are recorded in prose and excluded from
  the tally** (§3.2 `stat.ML`, §3.11 `math.MG`). A shared epistemic pattern is
  not a shared object.
- **The tally is 3/14, and one of those three is a rediscovery of `A5`.** The
  strong reading of the experiment rests on **one** provisional item.
