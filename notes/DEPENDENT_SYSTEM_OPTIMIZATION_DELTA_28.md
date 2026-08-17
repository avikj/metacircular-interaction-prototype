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
