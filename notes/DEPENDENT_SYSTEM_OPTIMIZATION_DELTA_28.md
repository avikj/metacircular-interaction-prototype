# Dependent System Optimization — Delta 28

Feedback trace, semantic cut width, and exact elimination geometry

Date: 2026-08-14
Status: exact semiring/min-plus theorems + mature-theory inheritance + new
synthesis/program
Depends on: DSO Delta 26 (subsystem = continuation transformer), DSO Delta 27
(architecture = factorization; min width = factor rank; canonical completion =
Isbell nucleus).

**Repository landing note (cf-indra, 2026-08-14).** Received upstream and
landed verbatim below. Two facts about its standing here:

1. **Its declared dependencies are absent.** No
   `DEPENDENT_SYSTEM_OPTIMIZATION_*DELTA_26/27*` file exists in `notes/`.
   `SEARCH` item: recover Deltas 26–27 before treating 28's references to
   costRank/witnessRank (§55) and the nucleus (§19, §31) as defined in-repo.
2. **The "attached demo" is Agda, or it is nothing.** Python is banned; the
   §62 executable calibration is landed as checked terms in
   `formal/cubical/DSOCutCalibration.agda` (`--safe`, exit 0): the tropical
   feedback closure A ⊕ PD*Q = ((0,5),(6,0)) on a concrete four-vertex
   system; Schur elimination in both hidden orders reproducing it (28.2/28.4
   instance); and the strict interface hierarchy — raw 4 > deterministic 3 >
   latent 2 — with the 2-mode cover certified entrywise and the lower bound
   PROVED against all rectangles via the fooling pair (not enumerated).
   The general Theorems 28.1–28.14 are inherited algebra per the delta's own
   ledger; `PROVE` seeds: 28.6 (projective compression) and 28.11–28.13
   (Bellman nonexpansiveness + error accumulation) in small generality over
   an abstract ordered carrier.
3. **Corpus contact, flagged for successors:** §14–16's projective
   continuation quotient is the min-plus form of the corpus's own
   future-behavior kernel (`FutureBehavior`, Myhill–Nerode lane) — a
   cross-lane identity of the `TAXONOMY_OF_CROSS_LANE_IDENTITY` "common
   quotient" type, not a coincidence; §44 (context memory as junction tree)
   is a DSO reading of exactly what this collaboration's journals/BOARD
   implement; §48–50's prime-pair cross-scale rank program must be typed
   against `TARGET.md`'s charge criterion before any computation (a
   cut-matrix ensemble whose queries are all parity-neutral cannot see the
   sector Goldbach needs — the K_{X,z} design must carry odd-Ω queries or it
   measures the protected sector, exactly).

The original delta follows.

────────

## 0. Executive leap

Delta 26: **a subsystem is its continuation transformer.**

Delta 27: **an architecture is a factorization of that transformer; its
minimum exact width is factor rank; its canonical completion is the Isbell
nucleus.**

Delta 28 adds loops and large dependency graphs. The decisive operations are:

- hidden feedback ⟼ Kleene-star trace / tropical Schur complement;
- global dependency graph ⟼ variable elimination / semiring tensor
  contraction.

The extensional boundary result is independent of exact elimination order.
But the intermediate interfaces created along the way can differ
exponentially in size. Classical treewidth measures this using raw separator
assignments. DSO replaces raw separator width by the semantic interaction
actually crossing the cut. For every cut e:

$$\operatorname{factorRank}(K_e) \le \#\text{ProjectiveContinuationClasses}(e) \le \#\text{RawSeparatorAssignments}(e),$$

and all inequalities can be strict. The next intrinsic architecture parameter
is not graph treewidth alone; it is a task- and value-sensitive cut quantity:

**semantic cut width = minimum number of future-distinct dependency modes
crossing a cut.**

New compiler objective: choose an exact elimination/factorization path
minimizing peak semantic cut width, verification cost, and option loss.

## 1. Open factor systems

Variables V with finite domains X_v; factors F with scopes sc(f) ⊆ V and
costs φ_f. Partition V = B ⊔ I (boundary/internal). The exact boundary cost:

$$K_B(x_B) = \inf_{x_I} \sum_{f\in F} \phi_f(x_{sc(f)}).$$

This is MAP inference, min-sum message passing, tropical tensor-network
contraction, semiring COP.

## 2. Semiring boundary semantics

Over any commutative semiring (S,⊕,⊗,0,1):
$$K_B(x_B) = \bigoplus_{x_I} \bigotimes_{f\in F} \phi_f(x_{sc(f)}).$$
Boolean → feasibility; min-plus → minimum cost; (ℝ≥0,+,×) → partition
function; max-plus → maximum reward; provenance semirings → proof/path
provenance. The dependency diagram and elimination syntax are shared while
the semantic carrier changes by semiring. Witness/proof-relevant systems
require categorified carriers beyond scalar semirings.

## 3. Exact variable elimination

Eliminate v ∈ I: combine incident factors ψ_v = ⊗_{f∋v} φ_f, then
⊕ out x_v; replace F_v by the eliminated factor. **Theorem 28.1 (exact
elimination correctness):** under semiring axioms and finite domains,
repeated elimination returns exactly K_B. (Associativity, commutativity,
distributivity.)

## 4. Extensional order independence

**Theorem 28.2:** any two elimination orders of I give the same boundary
factor. Exact dependency elimination is extensionally flat: different
internal histories, one boundary transformer.

## 5. Intensional order dependence

Different orders create different fill-in scopes; PeakScope and PeakEntries
are order-dependent even though the result is not. **Semantic flatness does
not imply computational flatness.**

## 6. Classical treewidth calibration

Induced width / treewidth is the mature measure of elimination cost; naive
exact inference scales exponentially in tw(G)+1. DSO does not replace
treewidth; it asks whether the raw table over every separator assignment is
semantically necessary.

## 7–8. Hidden feedback and the tropical Schur complement

Block form T = (A P; Q D) over boundary B and hidden H. Min-plus Kleene
star D* = I ⊕ D ⊕ D² ⊕ ⋯ (all-pairs shortest internal walks, defined when no
negative cycles). **Theorem 28.3 (hidden-feedback elimination):**

$$T_{\mathrm{eff}} = A \oplus P D^{*} Q$$

by path decomposition: direct paths, or enter/loop/exit. Feedback elimination
= sum over every hidden excursion and return.

## 9. One formula, several semirings

Boolean: reachability through hidden states. Min-plus: optimal hidden
excursions. Languages: Kleene closure. Linear: Feshbach/Schur
A + B(z−D)⁻¹C — Delta 19's operator self-energy and the tropical closure are
two realizations of one path principle: **eliminated state returns as an
effective boundary interaction.**

## 10. Sequential hidden elimination

**Theorem 28.4 (trace nesting):** Tr_{H₁⊔H₂}(T) = Tr_{H₁}(Tr_{H₂}(T)), both
orders equal — the finite min-plus shadow of traced/Kleene categorical
feedback laws.

## 11. Negative cycles

A negative internal cycle makes D* = −∞: unbounded improvement through
hidden feedback. A valid DSO compiler must classify negative / zero-cost /
positive / witness-relevant cycles.

## 12–13. Cut semantics and the raw bound

A cut e splits the system; eliminating each side gives M_e, L_e over the raw
separator X_{S_e}; K_e(a,c) = min_s (M_e(a,s) + L_e(s,c)). **Theorem 28.5:**
rank_{min+}(K_e) ≤ |X_{S_e}| ≤ q^{|S_e|}: raw treewidth upper-bounds
semantic dependency width.

## 14–15. Projective continuation quotient

Continuation profile ℓ_s(c) = L_e(s,c); projective equivalence s ∼ s′ iff
ℓ_s = λ + ℓ_{s′} (an upstream offset). **Theorem 28.6 (exact projective
separator compression):** K_e factors exactly through the quotient
Z_e = X_{S_e}/∼ with adjusted M̃_e. [Landing note: this is the min-plus
future-behavior quotient — the corpus's Myhill–Nerode kernel with a scalar
gauge.]

## 16–19. Three interface notions

d_e = |Z_e| is the coarsest deterministic exact interface (weighted
Myhill–Nerode). r_e = rank_{min+}(K_e) is the smallest nondeterministic
latent interface. **Theorem 28.7:** r_e ≤ d_e ≤ |X_{S_e}|, both possibly
strict (4 > 3 > 2 example — certified in `DSOCutCalibration.agda`). Do not
collapse: raw separators are architecture artifacts; behavioral quotients
are deterministic semantics; the Isbell nucleus is canonical completion;
factor rank is finite-generation complexity.

## 20–22. Semantic cut width

w_lat(e) = log₂ rank_{min+}(K_e) ≤ w_det(e) = log₂ d_e ≤ w_raw(e) =
log₂|X_{S_e}|. Continuation cut width of a decomposition = max over edges;
of a system = inf over decompositions. Treewidth bounds give semantic-width
bounds; the converse fails. ("Continuation cut width" is a working name;
prior-art comparison against rank-width, Boolean-width, trellis complexity,
bond dimension is REQUIRED before claiming a new parameter.)

## 23–25. Why semantic width can be much smaller

Symmetry, parity/aggregate dependence, conditional independence,
conservation laws, sufficient statistics, gauge equivalence, low tropical
rank, task restriction. Boolean specialization: w_lat = nondeterministic
communication complexity across the cut; the interface is a certificate
alphabet.

## 26. Coding-theory calibration

A 2026 result: for a binary linear code and coordinate cut,
rank_{min+}(W) = 2^s with s the classical minimal-trellis state-complexity
exponent — an exact mature case where semantic cut width equals minimum
cross-cut state, even against arbitrary min-plus factorizations.

## 27. Rank-width relatives

Rank-width (GF(2)), Boolean-width, mim-width, clique-width replace raw
separator cardinality by semantic cut functions. Continuation cut width
differs: K_e depends on weights, semiring, task boundary, continuation
family, witness structure — a system/task parameter, not an invariant of the
unweighted graph.

## 28–30. Semantic junction trees

Messages become "the future-distinct dependency modes that actually cross
this cut" instead of raw tables. **Theorem 28.9** (= 28.6 as a compiler
rewrite): projectively-descending messages compress exactly; the proof is
the architecture-equivalence certificate. **Theorem 28.10 (no free
compression):** merging projectively distinct states admits a separating
continuation — the global optimum becomes wrong for some admissible
downstream world.

## 31–32. Isbell nucleus at a cut

Nuc(K_e): saturated dual pairs (x, y) with y = K↑x, x = K↓y — exact burden
profile and exact residual profile, a tight separable majorant. Minimum
nucleus cover = smallest exact latent interface. Elimination via nucleus
generators: compute, cover, pass generator coefficients, compose by
min-plus convolution, re-saturate. No tractability theorem claimed.

## 33–35. Stability

**Theorem 28.11 (Bellman nonexpansiveness):** ‖B_K(V)−B_K(W)‖∞ ≤ ‖V−W‖∞.
**28.12:** kernel ε-perturbation moves values by ≤ ε. **28.13:** m
approximate steps accumulate ≤ Σεᵢ, conservatively. Under feedback, cycles
can revisit approximated structure: coarse bound (n+1)ε; sharper bounds need
cycle margins, contraction, or direct D* approximation.

## 36–38. Curvature and holonomy

Exact elimination commutes; compression C can make orders differ:
Δ^C_{ij} > 0 is architecture curvature. **Theorem 28.14 (flat
compression):** fully abstract compression for all arising contexts
preserves semantics for every order. Curvature arises only from
too-small context families, approximation, dropped witnesses, or incoherent
interface updates. Even flat architectures can carry interface holonomy
h : Z ≃ Z around loops in architecture space — harmless for boundary
semantics, load-bearing for caches, provenance, optimizer state, proofs.

## 39–47. The compiler, and its recursion

A certified rewrite carries: boundary-semantics preservation, complexity
improvement (peak semantic width / Pareto), state migration, provenance.
Tensor networks: DSO bond dimension = rank_{min+}(K_e). Knowledge
compilation, FAQ/database planning, proof search (lemma invention =
semantic separator design), context memory (retain the latent modes
required by future theorem continuations plus witnesses), swarm
architecture (coordination state tracks coupling rank, not population).
The architecture planner is itself a DSO instance: meta-Bellman
V(D) = min_a (K(D,a,D′) + V(D′)). Online context change adds migration
cost and hysteresis.

## 48–50. Prime-pair cross-scale program

Cut at sieve scale z: K_{X,z}(u,v) over small-prime states u and declared
tail continuations v. rank_{min+} is the minimum latent cross-scale state;
Boolean support rank a certificate lower bound; the nucleus the complete
interface. Hypotheses: H28.1 subcritical semantic collapse below the
√X horizon; H28.2 critical width transition at z ≍ √X; H28.3 conditioning
can reorganize rank; H28.4 charge-one feedback trace vs the operator
Feshbach self-energy (same excursion combinatorics, different weights);
H28.5 a representation is a breakthrough iff it lowers peak continuation cut
width / finds a small exact nucleus cover / proves a width lower bound
against a proof language / makes a critical loop a tractable trace.
[Landing note: type the query family against `TARGET.md`'s charge criterion
FIRST — an all-even-Ω continuation family measures the protected sector.]

## 51–61. Calibrations and milestones

Refoliation (boundary-state physics analogue, no identification claimed);
decomposition obstruction = prematurely restricting the latent interface;
exact vs approximate curvature trichotomy; width is objective-dependent
(the object is (diagram, carrier, continuation family, proof
requirements)); proof-relevant width can exceed scalar width (Delta 27:
costRank ≤ witnessRank, strict possible); multiobjective quantale carriers;
lower-bound program (fooling sets, tropical minors, communication bounds,
behavioral separators, topological witness invariants, proof-complexity
reductions); upper-bound program (sufficient statistics, symmetry
quotients, dual variables, nucleus generators, tensor factorization,
compilation, representation invention). Milestones 1–3 (feedback closure,
elimination orders, separator quotient + rank hierarchy): **completed — as
checked terms in `formal/cubical/DSOCutCalibration.agda`, replacing the
unlandable Python demo.** Milestones 4–6 (nucleus-aware junction tree,
certified ε-covers with curvature measurement, bounded prime-pair
cross-scale rank sweep): open.

## 62. Executable calibration result

Verified in the kernel (`DSOCutCalibration.agda`, exit 0):

- Tropical feedback closure A ⊕ PD*Q = ((0,5),(6,0)) on the concrete
  four-vertex instance;
- eliminating hidden vertices in orders (2,3) and (3,2) gives the same
  boundary matrix (all four entries, by refl);
- the interface hierarchy is strictly 4 > 3 > 2: four raw states, three
  deterministic future rows (kernel-counted), two latent modes (exact
  2-rectangle cover certified; impossibility of one sound rectangle proved
  against all rectangles via the fooling pair).

[The delta's original text quoted peak table sizes 8 vs 16 for the two
orders; peak-size accounting is not yet in the Agda module — recorded as
part of Milestone 5, not claimed.]

## 63. Theorem ledger

Exact/inherited: semiring elimination correctness; order invariance;
order-dependent intermediate scope; min-plus Kleene feedback closure; path
interpretation of tropical Schur; nested elimination invariance; separator
rank bound; projective quotient; width hierarchy r ≤ d ≤ raw; treewidth
upper bound; Bellman nonexpansiveness; additive error accumulation; flat
compression; unsound merging yields separating continuation; Boolean cut
rank = rectangle cover; proof-relevant width ≥ scalar width.

New synthesis/program: continuation cut width; semantic junction trees;
nucleus-valued messages; compression-induced curvature; architecture
holonomy; certified self-improving rewrites; prime-pair cross-scale
semantic rank; proof-search semantic treewidth; research-memory
continuation width; DSO applied to its own planner.

## 64. Deep compression

The graph tells us who is syntactically connected. Treewidth tells us how
large a raw separator becomes. Continuation semantics tells us what every
separator state can do to every possible future. The behavioral quotient
removes future-indistinguishable states; the Isbell nucleus completes all
saturated latent cut concepts; factor rank selects the smallest exact
generator family; the Kleene trace closes feedback through hidden states.

**The real architecture of a dependent system is not its graph; it is the
family of continuation relations carried across every cut, together with
their exact feedback closure. The real width is not the number of variables
in a bag; it is the number of future-distinct dependency modes that must
survive the cut.**

## 65. Sanskrit compression

ग्राफः केवलं स्पर्शसम्बन्धं दर्शयति। The graph shows only syntactic contact.
भविष्यक्रिया एव यथार्थनिर्भरता। Action on the future is the true dependency.
विच्छेदे सर्वसंभाव्यभविष्येषु यानि भेदानि जीवितानि, तान्येव interface-रूपेण
धारयितव्यानि। Across a cut, retain exactly the distinctions that remain
alive in possible futures.
गुप्तचक्राणां फलम् Kleene-star। The effect of hidden cycles is the Kleene
star. K_eff = A ⊕ PD*Q.
यथार्थ elimination-क्रमेषु फलभेदो न। Exact elimination orders do not change
the result. किन्तु मध्यरूपभारः क्रमाधीनः। But the burden of intermediate
forms depends on the order.
अपूर्णसंक्षेपे curvature जायते। Curvature is born from incomplete
compression.
Thus dependent architecture optimization is: **close feedback exactly +
factor every cut semantically + minimize peak future-distinct width.**

## 66. Primary ancestry

Variable elimination / junction trees / treewidth; generalized distributive
law; semiring tensor contraction; FAQ/InsideOut; Kleene algebras, iteration
theories, traced feedback; min-plus Schur complements and tropical linear
algebra; rank-width, Boolean-width, branchwidth; rank-based DP and
representative sets; weighted automata and behavioral Hankel matrices;
knowledge compilation and AND/OR diagrams; 2026: exact equality of min-plus
factor rank and minimal trellis state count for conditional decoding
matrices. The DSO residue is their integration with continuation-complete
semantics, projective behavioral quotienting, Isbell-nucleus interfaces,
proof-relevant witness preservation, architecture curvature, self-modifying
certified dependency compilation, and the Prime-Pair / Knowledge Process
applications.

---

## Appended 2026-08-19, another thread: what §4 and §5 give when put together

*Appended at the end, altering no line above.*

§4 (Theorem 28.2, extensional flatness) and §5 (*"semantic flatness does not imply
computational flatness"*) pair into one exact statement, checked in
`formal/cubical/NaturalMachine/UnderExtensionalFlatnessOneCostDifferenceSuffices.agda`
(`--safe`, no postulates, no holes):

```agda
Flat = (o o' : Order) → result o ≡ result o'

oneCostDifferenceSuffices :
  Flat → (o o' : Order) → ¬ (cost o ≡ cost o') → ¬ FactorsThrough result cost
```

**Why this is sharper than the standing non-factoring lemma.**
`TranscriptDescent.collisionObstructsDecoder` normally needs a *hunted* collision — two
objects the observation identifies and the transcript separates. Flatness supplies the
first half **at every pair, for free**. So a single observed cost difference, anywhere,
refutes the existence of any decoder from result to cost.

**The operative reading for order selection:** if the result is flat, correctness
constrains the choice of order *not at all*, and every scrap of information about which
order to pick lives in the cost model. That is §5's sentence approached from the other
side — the semantics has, by §4, nothing left to say.

**The limit, so §2 is not read as more than it is.** Flatness alone refutes nothing: if
the cost is *also* constant the decoder exists (the constant function), and the
hypothesis `¬ (cost o ≡ cost o')` is unsatisfiable. §2 converts any observed cost
difference into an obstruction; it supplies no obstruction on its own.

**Not claimed:** Theorem 28.2 itself — flatness is a *hypothesis* named `Flat`, and
nothing there proves it for elimination orders or anything else. Nor anything about
PeakScope, PeakEntries, fill-in, treewidth, the tropical Schur complement, or any other
section.

**Kept apart** from two earlier modules of the same family: `AskingIsNotAPropertyOfTheFunction`
and `Anuvrtti` exhibit a *specific* collision to refute a specific factoring. Here the
collision is a theorem *about the hypothesis* — flatness makes collisions universal.
Same lemma downstream, different work upstream.

---

## Appended 2026-08-19, same thread: Theorem 28.10's shape, checked — and what it does not name

*Appended at the end, altering no line above (including the §4+§5 append above it).*

§28–30's **Theorem 28.10 (no free compression)** — *"merging projectively distinct
states admits a separating continuation — the global optimum becomes wrong for some
admissible downstream world"* — is checked in
`formal/cubical/NaturalMachine/MergingASeparatedPairBreaksAtTheSeparatingContinuation.agda`
(`--safe`, no postulates, no holes), with the separating continuation as an **input**
rather than something asserted to exist:

```agda
Separates c s₁ s₂ = ¬ (v s₁ c ≡ v s₂ c)
Agrees q v'       = (s : State) (c : Cont) → v' (q s) c ≡ v s c

noFreeCompression :
  Separates c s₁ s₂ → {Q : Type} (q : State → Q) → q s₁ ≡ q s₂
  → (v' : Q → Cont → Value) → ¬ Agrees q v'
```

quantified over **arbitrary** quotient types and compressions.

**The part that is not a restatement.** *Which* of the two merged states the compression
is wrong about is **not determined**. What is proved is `¬ (A × B)` — the two agreement
equations cannot both hold at the separator — and **not** `¬ A ⊎ ¬ B`, which would name
the guilty state; getting from one to the other needs a decision and none is available.
So *"wrong for some admissible downstream world"* is exactly right, and *"wrong for this
state"* is not something the argument gives.

**How it differs from the standing lemma**, since it is close:
`TranscriptDescent.collisionObstructsDecoder` concludes `¬ FactorsThrough q t`, a
non-existence about decoders on the image. This takes the separator as a parameter and
returns a **located** failure. Same family, different shape of conclusion.

**Not claimed:** Theorem 28.10 as this note means it — "projectively distinct" is defined
by §14–15's projective continuation quotient, which is **not modelled**; the module takes
separation by a single continuation as its hypothesis and proves only what follows from
that. Nor anything about w_lat/w_det/w_raw, §26's coding-theory calibration, or §27's
rank-width relatives — and **this note's own flag stands**: prior-art comparison against
rank-width, Boolean-width, trellis complexity and bond dimension is REQUIRED before
"continuation cut width" is claimed as a new parameter, and nothing here bears on it.

## Appended 2026-08-19, third thread: §31–32's "re-saturate" is idempotent, and that is all it is

Appended at the end, altering no line above. §31–32 states the elimination
procedure as *"compute, cover, pass generator coefficients, compose by
min-plus convolution, re-saturate"*, and says — correctly — that no
tractability theorem is claimed. What is also not claimed there, and what an
implementer needs before writing the loop, is that **re-saturation terminates,
and terminates after one application.**

It does, at the level of generality where it is a theorem:
`formal/cubical/NaturalMachine/SaturationAtACutIsIdempotent.agda` (`--safe`,
no postulates, no holes; container green under Agda 2.6.3 + cubical v0.5,
which is **not** the declared pin — `check.sh` returns 1 and prints that
itself).

For an arbitrary `K : X → Y → Type`, with `↑ A y = (x) → A x → K x y` and
`↓ B x = (y) → B y → K x y`:

| checked | reading here |
|---|---|
| `↑-antitone`, `↓-antitone` | the two polarities reverse inclusion |
| `unit`, `counit` | `A ⊆ ↓(↑ A)`, `B ⊆ ↑(↓ B)` |
| `triangle↑`, `triangle↑'` | saturating a profile that came from a saturation changes nothing |
| `c-idempotent-in/out` | `c = ↓ ∘ ↑` is a closure operator — re-saturate once, then stop |
| `fixedGivesSaturated`, `saturatedGivesFixed` | §31's saturated dual pairs are **exactly** the fixed points of `c` |

So "saturated pair" is not a side condition the procedure must maintain; it is
what being a fixed point of the closure means, and the loop in §31–32 has
length one.

**No novelty is claimed for any of it.** This is the Galois connection of a
relation: Birkhoff's polarities (*Lattice Theory*, 1940), the concept lattice
of formal concept analysis (Ganter & Wille, *Formale Begriffsanalyse*, 1996),
and Isbell's conjugation (*Adequate subcategories*, 1960) — which is the name
§31 is already using. The contribution is only that the step is checked.

**What this does not say, and the note should not be read as if it did.**
§31–32's `↑`/`↓` are min-plus *residuations* over a semiring-valued kernel;
the ones checked are the two-valued polarities of a relation. That the former
instantiate the latter is **not proved** — it would need the kernel's values
to form a quantale with the residuations as its adjoints, and nothing in this
repository sets that up. So the saturation discipline is sound *wherever the
adjunction holds*; whether Δ 28's own `↑`/`↓` hold it is open, and is the
next exact object on this thread. Reading the table above as a theorem about
min-plus convolution would be the same defect as quoting a figure without its
input. Inclusion is also used throughout rather than equality — `A ⊆ B` and
`B ⊆ A` are never combined into a path, which would need the predicates to be
proposition-valued and `funExt`.

## Appended 2026-08-19, fourth thread: §36–38's four causes are one cause

*Appended at the end, altering no line above.*

§36–38 says *"Curvature arises only from too-small context families, approximation,
dropped witnesses, or incoherent interface updates."* That is a list of causes offered
without an argument that the list is exhaustive. It is exhaustive, and the argument is
two pasted squares — but only once the four are read as **one** condition, which is what
`formal/cubical/NaturalMachine/CurvatureCannotLiveOnTheImageOfAnExactCompression.agda`
supplies (`--safe`, no postulates, no holes; container green under Agda 2.6.3 + cubical
v0.5, which is **not** the declared pin — `check.sh` returns 1 and prints so).

For any `C : S → T`, eliminations `f g : S → S`, compressed counterparts `f' g' : T → T`:

```agda
sf   : (s : S) → C (f s) ≡ f' (C s)          -- C intertwines f
sg   : (s : S) → C (g s) ≡ g' (C s)          -- C intertwines g
comm : (s : S) → f (g s) ≡ g (f s)           -- exact elimination commutes

curvatureVanishesOnTheImage : (s : S) → f' (g' (C s)) ≡ g' (f' (C s))
curvatureIsOffTheImage
  : (t : T) → ¬ (f' (g' t) ≡ g' (f' t)) → ¬ (Σ[ s ∈ S ] C s ≡ t)
```

**No injectivity, no full abstraction, no surjectivity is used.** The two intertwining
squares and the commuting square are the entire proof, so they are the entire hypothesis —
and that is what makes the causal list exhaustive rather than merely long:

- **"too-small context family"** = the image is too small; the curvature sits at a `t`
  that no context reaches, which is exactly `curvatureIsOffTheImage`;
- **"approximation", "dropped witnesses", "incoherent interface updates"** = the
  intertwining square failing, `C (f s) ≢ f' (C s)`.

There is no fifth possibility, because there is no third hypothesis. Operationally this
says what to do when curvature is observed: **find the point, and ask whether it is
reachable. If it is, one of the two squares is a lie.**

**No novelty.** This is the pasting of two squares — a simulation transports commuting
diagrams onto the image — and is standard in any category. It is checked because the
word *curvature* invites a geometric reading suggesting the phenomenon is subtler than
the pasting, and §36–38 states the causal list without the argument.

**Not claimed.** **No curvature is exhibited**: nothing constructs `C, f', g'` with
genuine curvature, so this constrains where curvature can be, and is not evidence that it
occurs. **Theorem 28.14 is not formalised** — full abstraction is a condition on the
context *family*, and no context family appears; what is proved is weaker in hypothesis
(only intertwining) and weaker in conclusion (only on the image). Two steps are treated,
so "for every order" is here just the two orders of two steps; the `n`-step statement
needs an induction that is not written. **Holonomy** — §36–38's `h : Z ≃ Z` around loops
in architecture space — is untouched, as are caches, provenance and optimizer state.

## Appended 2026-08-19, fifth thread: §36–38's holonomy sentence is one theorem, not two

*Appended at the end, altering no line above.*

§36–38 closes: *"Even flat architectures can carry interface holonomy `h : Z ≃ Z` around
loops in architecture space — harmless for boundary semantics, load-bearing for caches,
provenance, optimizer state, proofs."* That reports two observations. They are one, and
saying which one needs the loop to be an actual **path** rather than a metaphor — the one
place in this section where the cubical substrate earns its keep rather than merely
hosting the argument. Checked in
`formal/cubical/NaturalMachine/HolonomyIsInvisibleExactlyToAnInvariantSemantics.agda`
(`--safe`, no postulates, no holes; container green under Agda 2.6.3 + cubical v0.5,
which is **not** the declared pin — `check.sh` returns 1 and says so):

```agda
invariantSemanticsIsUnmoved
  : (h : Z ≃ Z) (sem : Z → B) → ((z : Z) → sem (equivFun h z) ≡ sem z)
  → (z : Z) → sem (transport (ua h) z) ≡ sem z

nonTrivialHolonomyMovesTheRawInterface
  : (h : Z ≃ Z) (z : Z) → ¬ (equivFun h z ≡ z) → ¬ (transport (ua h) z ≡ z)

theCacheIsMoved : ¬ (transport (ua notEquiv) true ≡ true)
```

**The two halves are one theorem read at two consumers.** Holonomy is invisible exactly to
consumers invariant under it; and "caches, provenance, optimizer state, proofs" is a list
of consumers that are *not* — they are keyed by the raw interface, which is the identity
consumer, and the identity consumer is invariant only when the holonomy is trivial. There
is no separate fact about caches to establish.

**Where univalence does the work.** Without it, `h : Z ≃ Z` and a loop in architecture
space are different objects and the sentence is an analogy. `ua` makes the loop a path,
`uaβ` computes transport along it back to `h`, and the two theorems are then about the
*same* `h` — the invariance hypothesis and the transport are connected rather than merely
parallel. `notEquiv` witnesses that the content is not vacuous.

**No novelty whatsoever.** `ua`, `uaβ` and the `not` automorphism of `Bool` are the first
examples in every cubical development. What is contributed is the identification of the
two clauses as one statement.

**Not claimed.** **Architecture space is not modelled** — there is no type of architectures
and no loop in one; `h` is given directly as a self-equivalence, which is what §36–38 says
such a loop *yields*, not what it is. The step from "loop in architecture space" to
`h : Z ≃ Z` is assumed, not built. **Flatness is not used**, so nothing here speaks to the
claim that *flat* architectures can still carry holonomy — only to what holonomy does once
present. No claim that Δ 28's "boundary semantics" *is* invariant: that is a hypothesis
here and a modelling question there. Nothing about composing loops — no group structure, no
fundamental group, no claim that holonomies compose.

## Appended 2026-08-19, sixth thread: §39–47's certificate composes, and only one component costs anything

*Appended at the end, altering no line above.*

§39–47 opens: *"A certified rewrite carries: boundary-semantics preservation, complexity
improvement (peak semantic width / Pareto), state migration, provenance."* Four components,
listed. A compiler applies rewrites in sequence, so the question the list leaves unanswered
is whether the certificate **composes** — and if so, which component costs anything.
Checked in
`formal/cubical/NaturalMachine/ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem.agda`
(`--safe`, no postulates, no holes; container green under Agda 2.6.3 + cubical v0.5, which
is **not** the declared pin — `check.sh` returns 1 and says so):

```agda
Certified d e = (sem e ≡ sem d)
              × StrictlyDominates (cost d) (cost e)
              × (M d → M e)
              × List Prov

composeCertified : Certified d e → Certified e f → Certified d f
noSelfRewrite    : ¬ Certified d d
```

**Three of the four compose for free.** Boundary preservation is a path and paths compose;
migration is a function and functions compose; provenance is a list and lists append. Only
**complexity improvement** needs a theorem — transitivity of strict Pareto domination — and
that theorem already exists in this corpus, proved on the DARWIN §5.2 stratum line for an
unrelated purpose (`⊏-trans`, needed there because a maximal element of a list's tail might
be beaten by its head). `noSelfRewrite` is `⊏-irrefl` from the same module, and it is what
makes a rewrite sequence progress rather than mark time.

**So the two notes are joined by a lemma neither asked for:** §5.2's parent selection and
§39–47's compiler need the same fact about the Pareto order, and it was proved once.

**On the cost convention, a live hazard here.** The cost vector is compared with
`StrictlyDominates`, the *benefit* reading — higher is better. §39–47's "complexity" is a
cost, so applying this requires the flip, and the flip is **sound but not faithful**: it
needs a cap above every cost ever compared and identifies costs above it
(`FlippingACostCoordinateIsSoundButNotFaithful`). That obligation is inherited and not
discharged.

**No novelty.** Composing certificates componentwise is what certificates are for; the
content is the count — three free, one earned.

**Not claimed.** "Peak semantic width" is **not** modelled — the cost is an abstract vector,
not anything computed from a cut. **Migration is a bare function with no law**: nothing says
it preserves the boundary semantics, which a compiler would need, so the composite's
migration is only as meaningful as its components'. Provenance is an opaque list and append
is not claimed to be the right combination. **Nothing here is a compiler**: no rewrite
search, no strategy, and no meta-Bellman `V(D) = min_a (K(D,a,D′) + V(D′))` — §39–47's
self-referential planner is untouched and would need a fixpoint.

## Appended 2026-08-19, cf-archivist thread: §36–38's Theorem 28.14, with the context family it needed

*Appended at the end, altering no line above.*

The curvature module in this corpus recorded, correctly, that **Theorem 28.14
is not formalised — full abstraction is a condition on the context *family*,
and no context family appears**. One appears now.

`formal/cubical/NaturalMachine/FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt.agda`
(`--cubical --safe`, no postulates, no holes; container green under Agda 2.6.3
+ cubical v0.5, NOT the declared pin — `check.sh` returns 1 and says so):

- the family is a **type** `K` with `ctxOf : K → Ctx`, so "all arising
  contexts" and "a too-small family" are the same statement at different `K`;
- `CtxEq p q = (k : K) → obs (plug (ctxOf k) p) ≡ obs (plug (ctxOf k) q)`;
- `FullyAbstract C = (p q : Tm) → CtxEq p q → C p ≡ C q`;
- **`flatCompressionPreservesEveryOrder`** — Theorem 28.14: if two elimination
  orders are contextually equivalent at every input, a fully abstract
  compression sends them to the same value. "For every order" is an arbitrary
  pair of composites `r₁ r₂ : Tm → Tm`, not the two orders of two steps.

**And the causal sentence gets a reading it can be held to.** §36–38 says
curvature "arises only from too-small context families, approximation, dropped
witnesses, or incoherent interface updates". With `K` a parameter, the
mechanism for the first cause is visible and is not mysterious: shrinking `K`
makes `CtxEq` **easier**, hence `FullyAbstract` **harder**, hence 28.14's
hypothesis stronger and less often met. Curvature is then not created by the
small family; it is *unprotected* by it. `curvatureIsWitnessedInTheFamily`
states the contrapositive — if the compressed images differ, the family
already separates the two orders — and `curvatureExhibitsAContext` produces
the separating context outright when `K` is enumerated and the observation
type is discrete, by the same `decΣOverEnumerated` the fourth-corner line
needed for the same reason.

**What this does not do.** No term language, no contexts, no compression is
constructed — `Tm`, `Ctx`, `plug`, `obs`, `C` are parameters, so this says
what 28.14 *means* and that it holds, not that anything in this corpus
satisfies it. **"Arising" is not modelled**: `K` is whatever family is
supplied, and nothing here says which contexts arise from a system — that is
the remaining gap in the theorem's hypothesis and it is a modelling question,
not a proof obligation. The other three causes in the list, and the holonomy
sentence, are untouched.

— cf-archivist
