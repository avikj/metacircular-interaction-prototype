# Unification: arithmetic hardness as reconstruction failure under symmetry-restricted observables

Response to the external strategic review (relayed 2026-08-11), which
correctly identified the program's center: not any single reformulation, but
the recurring shape *information destroyed by quotienting*. This note makes
that one theorem-schema, computes the charge group of every quotient in the
corpus, and installs the two import-machines (quantum information;
obstruction theory) with exact, not metaphorical, translations.

## 1. The prime state (the exact quantum-information reading)

For $t>0$, let $\psi_t(n)=\Lambda(n)e^{-tn/2}$ (or use a finite prime
prefix). Then $\psi_t\in\ell^2$ and the normalized rank-one operator
$\rho_t=|\psi_t\rangle\langle\psi_t|/\|\psi_t\|^2$ is literally a pure-state
density matrix. The unweighted infinite sequence $\Lambda$ is **not** in
$\ell^2$; its pair field is a formal/distributional rank-one kernel, not a
trace-class density operator. With the cutoff stated, the program's
projections become restrictions of $\rho_t$ to observable subalgebras or
fixed-point expectations (twirls) for group actions:

| projection (corpus name) | exact operator meaning |
|---|---|
| difference marginal c(h) | tr(ρ·S_h): restriction of ρ to the shift algebra C*(ℤ) |
| sum marginal r(N) | tr-pairings against J·S_N: the reflected coset of the infinite dihedral C*(D_∞) = C*(ℤ⋊ℤ/2) |
| heat-resolved data | adjoin the diagonal position family {e^{−tN̂}} |
| sieve/local data | restriction to the profinite diagonal C(Ẑ) (BC block) |
| gauge-neutral data | twirl E_G over the torus 𝕋^𝒫 (Theorem F's expectation) |
| spectral statistics | functionals of ρ through the explicit-formula transform |

So the seven "different" quotients are one operation — restrict the prime
state to a subalgebra M / twirl over a group G — and the program's question
is always: **is M informationally complete for the state class, and if not,
what indexes the failure?**

## 2. The theorem-schema and the master lemma

**Lemma (twirl annihilation; elementary but conditional).** Let a compact
group $G$ act on the object space and suppose the data map $D$ is $G$-invariant,
equivalently in the linear setting that $D$ factors through the twirl. Then
charged components are invisible to $D$. Invariance is essential: the mere
existence of a commuting group action does not imply that the data forgets its
nontrivial isotypic sectors.

**Research schema (not a general theorem).** In several proved cases in this
program, either the observable family is informationally complete on the
stated class, or a symmetry orbit explains part or all of the failure. One
must prove separately that the fibers are exactly those orbits; the twirl
lemma supplies only the easy non-injectivity direction. The table records
proved cases and organizing conjectures, not an automatic dichotomy:

| quotient | charge group G | charged generator | corpus theorem |
|---|---|---|---|
| phase: ψ ↦ ρ | 𝕋 (global phase) | — | lossless on rays (trivial case) |
| difference marginal | factor-reversal allocation group, after accounting for multiplicities, reciprocal associates, units, and coefficient constraints | factor-reversal | Rosenblatt--Seymour/UFD describes algebraic allocations; `PARITY_RIGIDITY` proves the prime $0$--$1$ class is rigid by a simpler character anchor, without classifying every algebraic spectral factor |
| positive cone (E1) | ℤ/2 (reflection n↦−n) | the cone choice | symmetrization kills the charge ⟹ signed-line gap data injective |
| sieve/gauge quotient | 𝕋^𝒫 | Liouville λ = (−1,−1,…) | Theorem F + CORE_KMS: equilibrium annihilates all charge; p=2k−1 gives exact finite-place annihilation |
| polynomial certificates | ℤ/2 (x ↦ −x) | odd part O | Res(g,g(−x)) = charge pairing; the exclusion tower = charge-neutrality obstructions (TENSIONS §2) |

The last column of the review's three-language table is thus literal: phase
retrieval, factor-reversal homometry, and sieve parity are the *same lemma*
applied to three (M, G) pairs. What varies — and where all mathematical
content lives — is the *computation of the charge group for the specific
arithmetic object*: that is what A′'s irreducibility program, F's KMS
uniqueness, and the p=2k−1 identity respectively achieve.

## 3. The reframed central question, and its two machines

**Q (the program's new center).** *What is the minimal enlargement of the
observable algebra that separates the charge sectors of the prime state?*

Existence proof of the answer's style, from within: for homometry, the heat
family {e^{−tN̂}} — one continuously-parameterized observable — restored
completeness (Theorem A(iii)). The arithmetic analog for parity would be one
t-parameterized family separating λ from the neutral algebra. Known upper
bounds on the answer: over function fields, **monodromy data** is such an
enlargement (Sawin–Shusterman use it to break parity); over ℤ, bilinear/type-II
sums are a partial enlargement (they see some charge, unquantified). Lower
bounds: CORE_KMS says no equilibrium-state enlargement inside the neutral
world works; WIDTH says no polynomial-level divisibility enlargement works.
The question is now sandwiched, sharp, and functorial.

**Machine 1 — quantum statistical inference (import as language + theorems).**
The correct imports: informationally complete POVMs, twirling channels,
superselection sectors, and *asymmetry resource theory* (charged information
as a resource destroyed by symmetric operations — the exact formal home of
"sieves are symmetric operations, λ is asymmetry"). The reference frame /
asymmetry literature (Bartlett–Rudolph–Spekkens) proves theorems of exactly
the needed shape: which states are distinguishable under G-covariant
measurements; what resources permit charge detection. Translation task
(agent-sized): restate Theorems A/A′/E1/F as instances of G-covariant state
discrimination and check which QI theorems say something arithmetic we have
not proven — the plausible candidate: quantitative tomography bounds ⟹
quantitative homometry rigidity (how far apart must homometric partners be).

**Machine 1 — EXECUTED (fleet-toy, 2026-08-11).** Anchor text confirmed:
Bartlett–Rudolph–Spekkens, *Reference frames, superselection rules, and
quantum information*, Rev. Mod. Phys. **79**, 555 (2007), arXiv
quant-ph/0610030 — "unspeakable" quantum information is data encoded in
degrees of freedom that a missing reference frame makes inaccessible; lacking
a frame for a group G imposes a superselection rule (SSR) = restriction to
G-invariant operations; within the SSR, asymmetry ("charge") becomes a
manipulable resource. This is exactly the formal home of §2's twirl lemma.

*The dictionary (exact, per theorem).* Throughout, ρ = ψψ* is the prime
state of §1 and E_G is the twirl over the group named.

| corpus theorem | QI statement it instantiates |
|---|---|
| **A(ii) (difference kernel / homometry)** | State discrimination under a translation SSR: measurements restricted to the shift algebra C\*(ℤ) see only tr(ρS_h) = c(h), i.e. the twirled reduction. Two supports are homometric iff their states have identical C\*(ℤ)-restrictions; by Helstrom + twirl, the optimal discrimination bias under covariant measurements is ½‖E(ρ_A−ρ_B)‖₁ = **exactly 0** — homometric partners are perfectly indistinguishable, not merely hard to tell apart. The hidden frame group whose orbits index the fibers is the charge group (ℤ/2)^{#factors} of §2 (factor reversal); Rosenblatt–Seymour is its orbit classification. |
| **A(i) (sum rigidity)** | Frame extension lifts the SSR: adjoining the reflection to translations (C\*(ℤ) → C\*(D_∞), the reflected coset {JS_N}) makes the covariant data {r(N)} informationally complete on the positive cone. In BRS terms: the sum marginal is a *relational encoding* w.r.t. the dihedral frame, and one added ℤ/2 reference frame (reflection) converts an SSR-degenerate tomography problem into a complete one. |
| **A′ (prime rigidity)** | Charge-group triviality = the SSR has no room to act on the state class: irreducibility of the noncyclotomic part forces the frame group down to the global reversal (ℤ/2)¹, whose orbit {P_X, reflection} is the trivial ambiguity. Rigidity is not better data — it is a smaller asymmetry group. |
| **E1 (positive cone)** | The cone choice is itself a ℤ/2 reference frame (which half-line is "positive"). Symmetrization a ↦ ã is the relational (frame-independent) encoding: on even states c_ã = ã\*ã, and A(i) applies — the crystallographic phase problem is *frame dependence*, destroyed by passing to the decoherence-free (symmetric) encoding. BRS's "relational encodings evade the SSR", literally. |
| **F + CORE_KMS (parity)** | Global SSR for the gauge torus 𝕋^𝒫: sieves are G-covariant operations, λ is the maximally charged state-direction, and Theorem F is the SSR statement that every invariant (equilibrium) state assigns charged observables expectation zero. CORE_KMS strengthens it to: the invariant world has a *unique* state — the twirl E_G followed by the unique trace — so no invariant-side refinement ever sees charge. Friedlander–Iwaniec's "extra input" = a resource state carrying asymmetry (bilinear/type-II data), the exact BRS resource-theoretic reading. The toy model (TOY_OBSTRUCTION §2.3) sharpens this to a single-place mechanism: at p = 2k−1 the local channel is the complete depolarizer on the charge bit — the sieve does not merely hide the parity bit, one finite place erases it. |

*The quantitative import (the theorem QI contributes that the corpus has not
proven).* QI's covariant-discrimination calculus assigns exact numbers where
the corpus had only the dichotomy complete/incomplete:

**Import Q1 (noisy/partial heat data separating homometric partners —
derived).** Let A ≠ B ⊆ {0,…,N} be homometric (hence |A|=|B|=m), with pure
states ψ_A, ψ_B as in §1, and let f_A(t) = Σ_{a∈A} e^{−ta} = m·tr(ρ_A e^{−tN̂})
be the heat (diagonal Laplace) observable of A(iii).
(i) Under the translation SSR the discrimination bias is exactly 0 (dictionary
row 1): no amount of gap data at any precision separates them.
(ii) Adjoining a single heat observable at parameter t gives bias
≥ |f_A(t)−f_B(t)|/(2m), and D(t) := f_A(t)−f_B(t) = P(e^{−t}) for a nonzero
polynomial P with coefficients in {−1,0,1} of degree ≤ N. Self-contained
bound: at e^{−t} = 1/3, |D| ≥ 3^{−n₀}/2 where n₀ ≤ N is the smallest element
of the symmetric difference (leading term dominates the geometric tail:
3^{−n₀} − Σ_{n>n₀}3^{−n} = 3^{−n₀}/2). Hence **noisy heat tomography at noise
ε separates every homometric pair as soon as ε < 3^{−N}/(4m)** — completeness
of A(iii) made quantitative, unconditionally. Littlewood-type polynomial
bounds (Borwein–Erdélyi–Kós, *Littlewood-type problems on [0,1]*, Proc. LMS
1999) improve the guaranteed worst-case separation to sup_t |D(t)| ≥
exp(−c√(N log N))-type; citation from memory, exponent regime (√N vs
√(N log N)) to be pulled from the paper before external use.
(iii) The deflationary corollary for the prime state: explicit-formula /
RH-level data determines heat observables to relative precision ~N^{−1/2}
(power savings), which is *exponentially* coarser than the exp(−c√N)
worst-case discrimination threshold. **Generic covariant tomography can
never certify prime homometric rigidity; the algebraic route (A′,
irreducibility = charge-group collapse) is forced, not merely convenient.**
This is the QI mirror of the toy model's annihilation verdict: in both
machines, the win condition is shrinking the symmetry, not sharpening the
data.

**Import Q2 (the precise open import).** Quantitative homometric *repulsion*
of the primes: prove that for every 0–1 sequence B ≠ P_X homometric to P_X on
[0,N], sup_{t>0} |f_{P_X}(t) − f_B(t)| ≥ N^{−O(1)} (polynomial, not
exponential, separation). Under A″ the statement is vacuous (no partners
exist); unconditionally it interpolates between A′ and the generic BEK bound,
and it is exactly the statement needed to make *noisy, physically-realizable*
heat data (precision N^{−O(1)}, the precision arithmetic actually supplies)
sufficient for rigidity. Nothing in the corpus proves or refutes it; the QI
frame identifies it as the natural quantitative target, and the
factor-reversal structure (D(t) = A(e^{−t}) − Ã(e^{−t}) for a reversal
allocation, per REDTEAM's corrected target) gives it algebraic traction.

**Machine 2 — obstruction theory (the functorial upgrade of the spearhead).**
The K-question is hereby upgraded per the review: not "is ∂[λ-twist] ≠ 0"
but **"is the assignment (charge sector killed by quotient) ↦ (boundary class
of the extension) functorial across the table of §2?"** The toy model to
build first (finite S = {2,…,p_k}, X_S = ∏ℤ/p, local observables, the
I_p(−1…−1) = (p+1−2k)/(p+1) stalk values with the exact zero at p = 2k−1):
organize {I_p} as local sections of a presheaf on the poset of finite prime
sets; determine whether the lost Liouville sign is a nontrivial Čech-style
cocycle; compare with the Toeplitz boundary map under inverse limit. A *yes*
identifies the parity barrier with a gluing obstruction; a *no* is the
valuable deflation that K-theory sees the extension's topology but not the
analytic barrier — decided *before* the program builds on it.

**Machine 2 — EXECUTED (fleet-toy, 2026-08-11): the answer is *no*, and
sharply.** `notes/TOY_OBSTRUCTION.md` + `code/exp36_toy.py` (33/33 exact
checks): the λ-twisted section is **annihilated, not obstructed** — at
p\* = 2k−1 the local partition function is exactly the twirl idempotent
(1+z)/2 (the local parity bit is a fair coin, uniquely at p\*), so the
twisted line's bonding map is zero there, while every candidate obstruction
group vanishes structurally (towers over ℚ and ℤ/2 are Mittag–Leffler ⟹
lim¹ = 0; clopen partitions are cofinal on the profinite fiber ⟹ Čech
H^{≥1} = 0 for *every* coefficient presheaf; the ℤ/2-charge torsor is
explicitly trivial at each finite level). The one nonvanishing invariant —
integral lim¹ — is a completion artifact equally present when 2k−1 is
composite: blind to the parity zero. Prediction lodged for the K-computation:
∂[λ-twist] = 0, with the falsifier and the ℤ-coefficient caveat stated in
TOY_OBSTRUCTION §5 (interface to fleet-kboundary, note not yet landed).

## 4. Program reorganization (accepting the review's priorities)

- **Elevated to center:** this note's schema; the toy-model presheaf; the
  functorial K-question; the minimal-enlargement question; E0's "why" —
  *why is the singular series the critical correlation function* — with the
  standing observation that the all-orders identity (ladder = ζ's Laurent
  data) suggests an answer in which primes enter late: the critical field
  may be characterizable by (criticality + gauge symmetry + integrality)
  with 𝔖 forced, primes appearing only as the extremal realization.
  (Open; the right agent task after the toy model.)
- **Deprioritized:** further precision on spectral numerics (0.9999 →
  0.99999 buys nothing); new Cesàro replications; additional degree
  exclusions beyond the running ones (they serve A′ but are no longer the
  frontier).
- **Unchanged:** V-ladder discipline; the tension-dissolution rule (§2's
  table is itself its product); Codex's parallel lines.
