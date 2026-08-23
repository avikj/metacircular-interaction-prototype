# D0026 comparison maps: Q1a–Q1e executed as typed maps with round-trip defects

**Author:** build worker (D0026 queue, Q1 lane), 2026-08-16.
**Status:** five candidate identifications from `notes/D0026_BUILD_QUEUE.md` Q1
(rows Q1d/Q1e added by orchestrator update mid-task), each executed per the
constitutions' shared law (D0026 §1.4; our no-premature-Rosetta rule): typed
map + preserved invariant + round trip + defect + epistemic status. **No
equivalence is claimed beyond what is exhibited.** Every verdict names its
retained residue. Where a verdict would need a proof not done here, it is a
forecast with a probability.

**Standing honesty.** This container has no Agda/Lean toolchain. Every
"checked" below means: the source file asserts the check, the file was read in
full here, and nothing in it was re-verified by a kernel in this session. All
Agda quoted is quoted as source text read, not as machine verdicts. No
computation was run; every derivation below is displayed hand algebra. No
Python.

**Verdict alphabet.** `IDENTICAL-ON-SHARED-FRAGMENT` — the two statements are
one statement on an exhibited common fragment, with the residue being what
each side holds outside it. `RESTRICTS-TO` — one side's claim, restricted
along the exhibited map, becomes (a weakening of) the other's theorem.
`INCOMPARABLE` — no map exhibited preserves the load-bearing structure.

**Ranking, stated up front and honestly** (the A–C region reader found the
projection-curvature match weaker than the Gter/apoha rows; confirmed here):
Q1d and Q1e are the strongest rows — literal dictionary identity of the
operative object. Q1b is next — identical relational content with a proof
flowing upstream. Q1a is *weaker than the queue's phrasing suggests*: the
one-cut algebra is the same ring element, but neither of our two checked
modules covers D0026 §4.3's exact hypothesis set (see the corner in §1.4).
Q1c is a genuine restriction, not an identity.

---

## 1. Q1a — D0026 §4.3 projection curvature vs `ExcursionReturn` / `CompressionDefect`

### 1.1 Both sides, with native hypotheses

**Their side (D0026 §4.3).** Ambient: an associative unital algebra (implicitly
`End(U)` for a single space `U`). Hypotheses: `P` an idempotent, `Q = 1 − P`,
`U, V` *arbitrary* composable operators — no grading, no semigroup. Statement:

> `(PUP)(PVP) − PUVP = −PUQVP`.

Plus two extensions: (a) the *n*-step word `PU_n⋯U_1P` expands, by inserting
`1 = P + Q` at every intermediate cut, into a sum over all visible/hidden
histories, of which the compressed product retains only the all-`P` path;
(b) a "cocycle-like" constraint on two-step defects,
`K_{h+k,ℓ} + K_{h,k}T_ℓ = K_{h,k+ℓ} + T_h K_{k,ℓ}`.

**Our side (kernel-checked, landed twice independently).**

- `formal/cubical/NaturalMachine/ExcursionReturn.agda` (`--cubical --safe`,
  header asserts no postulates/holes): a `Compression` is a ring `R'`, a type
  `Time` with `⊕` (no associativity demanded), `T : Time → R'` with
  `T t · T s ≡ T (t ⊕ s)`, and elements `incl`, `proj` with
  `proj · incl ≡ 1r` (a *split* retraction pair). `K t = (proj · T t) · incl`,
  `Q = 1r − incl·proj`. Checked: `excursion-return` (T18.4,
  `K t · K s ≡ K (t⊕s) − defect t s`, `defect t s = ((proj·T t)·(Q·T s))·incl`),
  **and both directions of T18.5** (`defect-zero→semigroup`,
  `semigroup→defect-zero`), plus the set form `obsKernel ≡ FutureEq` (funExt
  both ways).
- `formal/cubical/NaturalMachine/CompressionDefect.agda` (same flags): a
  *bare* idempotent `e` with complement `q`, `e + q ≡ 1r` — **no retraction
  pair** — but the evolution is `T : ℕ → A` with `T t · T s ≡ T (t +ℕ s)`, a
  one-generator semigroup. Checked: `compression-defect` (T18.4 in the
  `e T_t e` form) and `defect0→semigroup` (forward direction only; the file's
  header says so).

### 1.2 The comparison map

Ambient category for the shared fragment: associative unital rings; both sides'
statements are equations between named elements of one ring.

**Ours → theirs (Φ).** Inside `ExcursionReturn`'s ring `R'`, set
`P̃ := incl · proj` (idempotent — this is the checked `iP-idem`), `Q̃ := 1 − P̃`
(this is the module's own `Q`), `U := T t`, `V := T s`. Their boxed identity at
`(P̃, U, V)` and our `excursion-return` are conjugate by the corner isomorphism

```
φ : x ↦ incl · x · proj ,   ψ : y ↦ proj · y · incl ,   ψ∘φ = id  (uses Pi = 1 twice),
```

which carries `K t ↦ P̃ T_t P̃`, `K (t⊕s) ↦ P̃ T_{t⊕s} P̃ = P̃ T_t T_s P̃`
(T-hom), and `defect t s ↦ P̃ T_t Q̃ T_s P̃`. So on this fragment the two
identities are one ring equation read in two charts. **Round-trip defect: 0.**

**Theirs → ours (Ψ).** Given their `(A, P)` with `P² = P` and arbitrary
`U, V`:

- `ExcursionReturn` accepts arbitrary letters — take `Time :=` the free monoid
  on `{u, v}`, `T :=` word evaluation (T-hom holds by construction; the record
  never demands `⊕` associative) — **but demands the split pair**
  `proj · incl = 1r`, which a bare idempotent does not supply. Obstruction is
  real, not notational: in `M₂(k)` with `P = E₁₁` there are no `a, b` with
  `ab = P` and `ba = 1` (rank). So Ψ through this module needs the extra
  hypothesis *`P` splits through the unit*.
- `CompressionDefect` accepts the bare idempotent — its `e, q, e+q ≡ 1r` are
  exactly their hypotheses — **but hardcodes `T : ℕ → A`**, the free monoid on
  *one* generator; two independent letters `U ≠ V` do not factor through it
  (except as powers of a common element).

### 1.3 Round-trip defect

Zero on the doubly-restricted fragment: (split idempotent × arbitrary word
grading) via `ExcursionReturn`, or (bare idempotent × one-letter grading) via
`CompressionDefect`. **Nonzero — as a hypothesis gap, not a mathematical one —
at the corner (bare idempotent × two independent letters), which is exactly
D0026 §4.3's stated generality.** The proof body of `compression-defect` uses
its semigroup hypothesis only once, to rename `T t · T s` as `T (t+s)`;
regrading it over an arbitrary magma-indexed evolution should compile with the
same term. That is a **forecast, p ≈ 0.95** (an afternoon; kernel pending —
this container cannot check it), not a claim.

### 1.4 Residue, both directions

**Ours retains, theirs lacks:**

1. **The iff.** T18.5 both directions is checked (`ExcursionReturn`):
   "`K` is a semigroup" and "no excursion returns" are *the same condition*.
   §4.3 states only the defect reading, as prose.
2. **The set form.** `obsKernel ≡ FutureEq` proves the observability kernel is
   the corpus's minimal-machine quotient — the tie into `FutureBehavior` that
   makes the defect a statement about *this* machine.
3. **Kernel status, twice.** Two independent landings, both `--safe`. Their
   `⊢` is a transmission assertion.
4. Note-level (not checked): SEED70's refinement — the defect is a
   first-return *series* `𝔯(z)`, `1 + 𝔎 = (E − 𝔯)⁻¹`, `ζ_T = ζ_{QTQ}·ζ_𝔯`, and
   T18.5 is "`𝔯` is a monomial of degree 1".

**Theirs retains, ours lacks:**

1. **The n-step history expansion.** Insert `1 = P+Q` at every cut: `2^{n−1}`
   histories. Both our module headers state explicitly that the checked
   material is the one-cut (`n = 2`) case only. §4.4's first-return kernels
   `F_m = PTQ(QTQ)^{m-2}QTP` and renewal `K_n = Σ F_m K_{n−m}` exist in this
   corpus only at note level (SEED70; `ObservabilityQuotient` header lists
   T19.3/T19.5 as genuine unchecked work).
2. **The cocycle constraint — derivable here in one reading, unverified in the
   other.** Write `Δ(h,k) := K_{h+k} − K_h K_k` (= `defect h k`, by checked
   T18.4). Ring associativity of `K_h K_k K_ℓ` gives, in two lines:

   ```
   (K_h K_k)K_ℓ = K_{h+k+ℓ} − Δ(h+k,ℓ) − Δ(h,k)·K_ℓ
   K_h(K_k K_ℓ) = K_{h+k+ℓ} − Δ(h,k+ℓ) − K_h·Δ(k,ℓ)
   ⟹  Δ(h+k,ℓ) + Δ(h,k)·K_ℓ = Δ(h,k+ℓ) + K_h·Δ(k,ℓ).
   ```

   This is their displayed equation **iff their `T_ℓ`, `T_h` denote the
   compressed evolution** (`K_ℓ`, `K_h`). As printed — bare ambient `T` — the
   two sides do not even share boundary projections
   (`PT_hQT_kPT_ℓ` vs `T_hPT_kQT_ℓP`), the derivation above does not produce
   it, and I do not verify it. The typing of that display is a defect of the
   transmission, flagged, not repaired. The compressed-reading derivation
   above is exact hand algebra from a checked identity; it is not itself
   kernel-checked.
3. **Bare idempotent × arbitrary letters** generality (the §1.3 corner).

### 1.5 Verdict

**IDENTICAL-ON-SHARED-FRAGMENT**, with the shared fragment exhibited in §1.2
and *smaller than the queue anticipated*: the two checked twins each generalize
exactly one axis of §4.3's hypotheses (letters vs splitting) and specialize the
other, and §4.3's own corner is reached by neither term as written. Retained
residues per §1.4. **This row is genuinely weaker than Q1d/Q1e**: the identity
matches, the hypothesis lattice does not yet.

**Consumer:** `STRUCTURED_DEFECT` / the machine's fiber discipline; D0026
§14.5 acceptance ("a tear maps to a specified object" — the specified object
is `defect t s`, a named ring element); the magma-regrading forecast is a
one-move `PROVE` for a toolchain-bearing session.

---

## 2. Q1b — D0026 §4.4 `N_obs` vs `ObservabilityQuotient` + `ExtremalDescription`

### 2.1 Both sides, with native hypotheses

**Their side (D0026 §4.4).** Ambient: linear. `U` a (vector) space, `T` a
discrete linear evolution, `P` the visible (linear) projection. Statement:

> The dynamically safe linear quotient is `U/N_obs`,
> `N_obs = ⋂_{n≥0} ker(P T^n)`. "Only distinctions invisible under every
> future observation can be discarded without inducing memory."

The definite article is a maximality assertion; §4.4 contains no proof of it.
Around it: the renewal equation `K_n = Σ_{m=1}^n F_m K_{n−m}` with
`F_1 = PTP`, `F_m = PTQ(QTQ)^{m−2}QTP`; the Feshbach self-energy
`Σ(λ) = B(λI−D)⁻¹C`; the continuous-time Zeno remark
`Pe^{−itH}P ≠ e^{−itPHP}P` when `QHP ≠ 0`.

**Our side.** `formal/cubical/NaturalMachine/ObservabilityQuotient.agda`
(`--cubical --safe`): arbitrary types `X, Y`, arbitrary `T : X → X`,
`p : X → Y` — **no linearity anywhere**. `ForeverEq x y = (n : ℕ) → obsAt n x ≡
obsAt n y` (T19.11 by definition), `forever-invariant` (T19.12/C19.36, the
congruence), `instant↛forever` (C19.13's strictness witness on a three-state
carrier). `formal/cubical/ExtremalDescription.agda` §2: **maximality proved** —
`greatest-safe` (every relation that is sound for `p` and invariant under `T`
is contained in `ForeverEq`; three lines, induction on `n`),
`safe-maximum-unique` (any two greatest safe relations mutually contain — the
invariance constant is 0), `instant-not-invariant` (it is the *invariance*
clause, not soundness, that `ker P` fails).

### 2.2 The comparison map

Near-identity, as the queue said, and here it is typed. Instantiate our
parameters at their linear data: `X := U`, `T := T`, `p := P`. Then

```
ForeverEq x y  ⟺  ∀n, P Tⁿ x = P Tⁿ y  ⟺(linearity of P, T)  x − y ∈ N_obs ,
```

so their `N_obs` is the `ForeverEq`-class of `0` and their quotient relation is
our relation on the nose. Ambient: theirs is the image of ours under the
forgetful passage from (sets, functions, arbitrary observation) to
(vector spaces, linear maps), plus the coset rewriting that linearity licenses.

**Scope fence, both hypotheses named** (they are silent in §4.4 and were made
explicit in `notes/DELTA19_IS_THE_KERNEL_AGAIN.md` §1, carried here):

1. **Singleton alphabet.** Automatic on this fragment — both sides iterate a
   single `T`. (The corpus's Lean kernel `FutureBehavior` is more general —
   words over an action alphabet — and for `|A| > 1` the kernel
   `⋂_{w} ker(P S_w)` is strictly smaller than any single-letter `N_obs`;
   witness in that note.)
2. **Linearity of `P`.** Without it the coset reading is false:
   `U = ℝ, T = id, observe(x) = x²` gives `FutureEq 1 (−1)` with
   `1−(−1) = 2 ∉ {0}` even though the class of 0 is a subspace. The
   *relational* statement needs nothing; the *subspace* statement needs linear
   `observe`.

### 2.3 Round-trip defect

On the fenced fragment: **0** — the relation transports identically, and
the maximality statement transports with it (`greatest-safe` instantiated at
linear data specializes to: every `T`-invariant subspace of `ker P` lies in
`N_obs`, which is their definite article, proved). Going ours → theirs loses
nothing on the fragment; going theirs → ours the coset/subspace *format* does
not survive (no linearity upstairs) — the relation is the invariant content,
the subspace is chart data.

What does **not** round-trip in either direction: the quotient *type*.
Neither side constructs it — our module says so ("`U/N_obs` as a
`SetQuotient` ... not built"), theirs writes `U/N_obs` without construction.
Equal debts are not residue; recorded, not counted.

### 2.4 Residue, both directions

**Ours retains, theirs lacks (this is the deliverable — a status upgrade
flowing upstream):**

1. `greatest-safe`: maximality **proved**, three lines. Their "the dynamically
   safe quotient **is** `U/N_obs`" is an assertion.
2. `safe-maximum-unique`: the extremum is attained and unique — the
   invariance constant is exactly 0 (the disanalogy with Kolmogorov's
   invariance theorem, named in the module header).
3. `instant↛forever` + `instant-not-invariant`: the strictness of
   `N_obs ⊊ ker P` is *witnessed* (three states), and the failure is located
   at the congruence clause specifically.
4. Generality: no linearity, arbitrary carriers; the multi-letter version
   exists in the Lean kernel.

**Theirs retains, ours lacks:**

1. **The quantitative failure theory.** What happens when you quotient
   *unsafely*: renewal equation, first-return kernels `F_m`, Feshbach
   `Σ(λ) = B(λI−D)⁻¹C` with coefficients `BD^mC` as explicit hidden
   excursions. In our corpus this exists only at note level (SEED70;
   `DELTA19_IS_THE_KERNEL_AGAIN` §2, including the fleet-breaker correction
   that "either channel vanishing" is not the sharp form — the sharp form is
   the subspace containment `B|_U = 0`, `U = Σ D^mC(ran P)`), and is
   explicitly listed as unchecked work in `ObservabilityQuotient`'s header.
2. The continuous-time / Zeno statement — no analogue here at all.

### 2.5 Verdict

**IDENTICAL-ON-SHARED-FRAGMENT** (fragment: single evolution map, relational
form; the subspace form additionally under the linearity fence, with the `x²`
counterexample marking the boundary). The typed deliverable flowing upstream:
their §4.4 maximality assertion is discharged by
`ExtremalDescription.greatest-safe` + `safe-maximum-unique`, with the scope
fence of §2.2. Residue per §2.4 — the sharpest single item theirs retains is
the renewal/self-energy apparatus, which remains this corpus's named unchecked
debt.

**Consumer:** D0026 §14.1 acceptance (this *is* a kernel-checked reproduction
of one of its named laws, under explicit constructive assumptions); our
Delta-19 lane; upstream status ledger.

---

## 3. Q1c — D0026 §8.4 consequence fiber vs `VERIFIER_BLIND_FIBER_REWARD`

### 3.1 Both sides, with native hypotheses

**Their side (D0026 §8.4).** Ambient: type theory (proof-relevant). A
compilation `C : Θ → P` from rich theorem-producing structure to a canonical
output `p₀`. Claims: (a) for decidable `P : ℕ → 𝟐`, mere existence yields the
least witness by bounded search, so a canonical output type can be
*contractible* (Goldbach has bounded witness search per center; twin recurrence
is unbounded liveness); (b) the mathematically live object is the consequence
fiber `fib_C(p₀)`, which "contains distinct proof routes, transfer graphs,
bounds, representations, provenance, comparison maps, computational costs, and
holonomy"; (c) "Same theorem output does not mean same mathematical artifact."
Richness is asserted; no fiber is computed.

**Our side (`notes/VERIFIER_BLIND_FIBER_REWARD.md`, cf-tessera; exact
classification over landed packets, with the seed122/seed127 correction
applied: the group is `Γ₀^±(m)`, not `Γ₀(m)`).** Ambient: sets and groups.
Fix nonsingular `M ∈ ℤ^{2×2}`, elementary divisors `(e₁,e₂)`, `m = e₂/e₁`,
event set `E(M) = {(U,V) ∈ GL₂(ℤ)² : UMV = diag(e₁,e₂)}` — a regular
`Γ₀^±(m)`-torsor. **Theorem A:** every verifier observable (anything factoring
through `M`, the endpoint, and the Smith invariants) is constant on `E(M)`;
hence every outcome reward is fiber-blind and the unrewarded choice space is
the full infinite group. **Theorem B:** the discrimination lattice of trace
formats — outcome (1 class) / `det` (exactly 2 classes, kernel cosets, pair
law `det U · det V = sign det M`) / Bézout (injective on the unipotent `ℤ`,
conflates off it) / injective (replays via `π⁻¹`). **Corollary:** reward
completion = section choice. **Plus an import theorem** (R0027 §4 as cited
there): fiber-separating reward cannot be derived from the task predicate; it
must be imported from an execution ecology.

**Provenance fence:** that note's own addendum records that the claim IDs it
cites (R0027, R0032–R0037) were deleted from the registry at `142bba1f` and
the IDs reassigned to an unrelated lineage. Citation here is by note path,
per its instruction; the mathematical content is in the note itself.

### 3.2 The comparison map

Instantiate their schema at the Smith task, in **Set** (their type-theoretic
fiber, taken over a point of a set of outputs, is the ordinary fiber — the
0-truncation is the map):

```
Θ  := E(M)   (normalization events = derivations),
P  := (endpoint, Smith invariants)-data,
C  := (U,V) ↦ (UMV, e₁, e₂, …),
p₀ := (diag(e₁,e₂), e₁, e₂, …).
```

Then `fib_C(p₀) = E(M)` **entire** (Smith uniqueness: `C` is constant on
`E(M)`), and:

- their (b) "the fiber is rich" restricts to: *the fiber is a regular
  `Γ₀^±(m)`-torsor, infinite* (contains the unipotent `ℤ`) — richness not
  asserted but computed, with the group named;
- their (c) "same output ≠ same artifact" restricts to Theorem A's exact form:
  the output determines *zero bits* of the artifact — every verifier
  observable is constant on the fiber;
- their contractibility remark (a) has the exact echo: the *output* side is a
  point, while the fiber carries the whole group.

### 3.3 Round-trip defect

**Theirs → ours:** their general claim, restricted along §3.2, is strictly
weaker than our theorem — it asserts the fiber is nontrivially structured;
ours computes the structure and classifies what each observation grade sees
(Theorem B's lattice). Nothing of their *restricted* claim is lost.

**Ours → theirs: does not round-trip.** Our theorem is one task family and
does not prove (b) for any other `C`; and two of their listed fiber contents —
"computational costs" and "holonomy" — are *not* verifier observables in our
typed sense (costs are exactly the port-imported, non-derivable data of the
import theorem; holonomy is proof-relevant structure the 0-truncated event set
does not carry). So their fiber is a genuinely larger object than our event
set even on this task, if `Θ` is taken proof-relevantly. Whether the
0-truncation `Θ ↦ E(M)` is faithful for the Smith task (i.e. whether a
proof-relevant `Θ` for Smith normalization adds anything beyond the event set)
is undecided here: **forecast, p ≈ 0.8 that it is faithful for endpoint
observables** (the task's outputs are decidable equalities in a set), with the
proof-route/cost strata genuinely richer regardless.

### 3.4 Residue, both directions

**Theirs retains:** full generality over `(Θ, C, p₀)`; the
contractible-output-type observation with its Goldbach/twin asymmetry
(bounded vs unbounded witness search) — no analogue in our note; the
proof-relevant reading of the fiber.

**Ours retains:** the exact group; regularity (free + transitive) of the
action; the discrimination lattice with its audited gap witnesses; the
`replay ⟺ section` corollary; and — sharpest — the **impossibility half**:
fiber-separating observables are *not derivable* from the task predicate and
must be imported (their §8.4 lists what the fiber contains, but has no theorem
that the compilation can never see it; ours does, for this task). D0026 §14.8
asks for external value; a quantitative instance with an impossibility
attached is exactly the currency that section names.

### 3.5 Verdict

**RESTRICTS-TO**: D0026 §8.4's consequence-fiber claim, restricted to the
Smith-normalization task along §3.2, becomes a weakening of Theorems A/B; our
theorems are the restriction, sharpened, with the impossibility added. Not
identical on a shared fragment: the general claim is not a theorem anywhere,
and our instance does not scale to their generality. Residue per §3.4.

**Consumer:** the process-supervision lane; D0026 §14.8's external-value test
(this row is the corpus's best current candidate for it); anyone extending
Theorem B to the rank-`r` payload group (the note's own seed).

---

## 4. Q1d — D0026 §7.1–7.2 Gter Galois connection vs `CHANGING_TESTS_VERSUS_SHRINKING` + `ACTIVE_OBSERVER_DESIGN`

*(Row added by orchestrator update, pre-adjudicated by the A–C region reader;
adjudication checked here against the sources, and confirmed.)*

### 4.1 Both sides, with native hypotheses

**Their side (D0026 §7.1–7.2).** State space `X`, probe universe `𝒪` of maps
`o : X → Y_o`. `E(P) = ⋂_{o∈P} kerpair(o)`; `A(R) = {o : R ⊆ kerpair(o)}`;
the antitone Galois connection `R ⊆ E(P) ⟺ P ⊆ A(R)` with closures
`ν_𝒪 = A∘E`, `ν_X = E∘A`. `gter(P) := E(P)` — hiddenness is generated by the
current probes; a revealer strictly shrinks `E(P)`. §7.2: minimum separating
cost `ρ_P(x,y) = inf{Σ_{r∈R} c(r) : (x,y) ∉ E(P∪R)}`; probe filtrations and
revelation time; restricted-Yoneda density as complete revelation. All stated,
none proved beyond the connection itself (classical).

**Our side.** `notes/CHANGING_TESTS_VERSUS_SHRINKING.md` (proved, finite
counterexamples exhaustively minimal; hand-checked, no kernel): on a Chu space
`(X, 𝒯, e)` with `∼_S` (their `E`), **Theorem A** (`δ` is a complete
join-homomorphism), **Theorem B** (the *monotone* adjunction `δ ⊣ δ*` with
redundancy closure `C_σ` — explicitly disentangled from the polarity, §0.4),
**Theorem C** (replacement criterion `δ(S') ⊆ δ(S) ⟺ S' ⊆ C(S)`),
**Theorem D** (exact meet failure), **Theorem E** (the resolving-power
preorder `S ⊑ S' ⟺ ∼_{S'} ⊆ ∼_S` is the **unique coarsest** relation under
which the defect is monotone uniformly in the holonomy; proved by
transpositions), **Theorem F** (**under unrestricted replacement no monotone
quantity exists at all** — realisability via orbit lemma), and **Prop. 6.3**:
`A(S) = {t : ∼_S ⊆ ∼_{{t}}}` is a closure operator, `S ⊑ S' ⟺ S ⊆ A(S')`,
and `A = ⋂_{𝔥∈Aut(X)} C_𝔥` — the antitone (FCA/Birkhoff) closure identified
as the holonomy-uniform intersection of the monotone redundancy closures.
`notes/ACTIVE_OBSERVER_DESIGN.md` §1: probes with costs,
`d_Q(x,x') = min{c_q : r_q(x) ≠ r_q(x')}`, the budget-`B` observational
quotient.

### 4.2 The comparison map

Dictionary (ambient: sets; posets of subsets):

| D0026 §7 | repo |
|---|---|
| probe `o : X → Y_o` | test `t ∈ 𝒯` via `e(−,t) : X → Q` (per-probe codomains vs one `Q` differ only through `kerpair`, which is all either side uses) |
| `E(P)` | `∼_P` (H2) |
| `ν_𝒪(P) = A(E(P))` | `A(P)`, Prop. 6.3 |
| `P ⊆ A(R)` for `R = E(P')` | `P ⊑ P' ⟺ P ⊆ A(P')` |
| `ρ_P(x,y)` | `d_Q(x,x')` over the probe pool `𝒪∖P` |
| probe filtration / revelation time `τ` | budget filtration / `d_Q > B` quotient |

Round-trip on the cost row, exhibited rather than asserted: a *set* `R`
separates `(x,y)` iff some single `r ∈ R` does (`E(P∪R) = E(P) ∩ E(R)` and
kernels intersect pointwise), and costs are nonnegative, so the infimum over
sets is attained on singletons: `ρ_P(x,y) = min{c(r) : r separates (x,y)}
= d_Q(x,y)` over the available pool. **Defect 0** on that row.

### 4.3 Round-trip defect and residue

**Defect on the connection itself: 0 with one asymmetry of data.** Their `A`
takes *arbitrary* relations `R ⊆ X×X` (the full two-sided connection, both
closures `ν_𝒪` and `ν_X`); our Prop. 6.3 works with the test-side closure and
relations of the form `∼_S`. The state-side closure `ν_X = E∘A` on arbitrary
`R` is exactly the "mirror half" that `APOHA_AND_POLARITY.md` §6 records the
corpus as never having used — **a real theirs-side residue**, already
independently flagged in this corpus. Their restricted-Yoneda density
criterion (complete revelation = probe density) likewise has no repo analogue.

**Repo-side surplus (what D0026 §7 does not state, anywhere):**

1. **Theorem E's uniqueness/coarseness**: `⊑` is not one order among many but
   the *unique coarsest* comparison making the defect monotone uniformly in
   the holonomy. D0026 §7 defines the closure; it has no theorem selecting it.
2. **Theorem F's no-go**: under unrestricted probe replacement *no* function
   of the defect is monotone — the exact reason a framework like §7's needs a
   comparison datum at all, proved rather than sensed.
3. **Prop. 6.3's decomposition** `A = ⋂_𝔥 C_𝔥`, tying the antitone closure to
   the holonomy-indexed monotone ones (D0026 has no holonomy index in §7).
4. The exact meet-failure (Thm D) with exhaustively minimal counterexamples.

### 4.4 Verdict

**RESTRICTS-TO** (per the pre-adjudication, confirmed): everything D0026
§7.1–7.2 states, restricted along the dictionary, is already held here —
identical machinery on the shared fragment — and the repo additionally holds
uniqueness (Thm E) and impossibility (Thm F) theorems the transmission does
not state. Residue theirs: the two-sided connection on arbitrary `R` (the
unused mirror half) and the Yoneda-density criterion. Residue ours: Thms E, F,
Prop. 6.3's decomposition — this is the surplus that flows upstream.

**Consumer:** D0026 §7 / Gter lane (upstream: §7's framework should import
Thm E as its comparison invariant and Thm F as the reason it must); the
instrument-comparison and active-observer lanes here.

---

## 5. Q1e — D0026 §10.3 apoha ≃? polarity vs `APOHA_AND_POLARITY` + `EXCLUSION_IS_NOT_AN_OPERATOR`

*(Row added by orchestrator update; the repo's state is strictly finer than
D0026's "open", and the verdict flows upstream.)*

### 5.1 Both sides, with native hypotheses

**Their side (D0026 §10.3).** In full: exclusion semantics suggests comparison
with polarities `A ↦ A^⊥ ↦ A^{⊥⊥}`; "**The comparison remains open.** The
question is whether native apoha supports the same semantic and inferential
operations or whether a mismatch yields a useful separator." §14.6's
acceptance: bidirectional operational transport, not aesthetic resonance.

**Our side.** Two results, one per horn of their disjunction:

1. `notes/APOHA_AND_POLARITY.md` (definitional unfolding, no new theorem
   claimed, recorded as *convergence*): D0020's apoha displays
   (`α ↦ α^{⊥⊥}`) are, under the exhibited dictionary
   (`χ⁺ = X×X`, `χ⁻ = 𝒯`, incidence = "does not separate"), **verbatim the
   FCA/Birkhoff polarity closure `A` of Prop. 6.3** — the same operator Q1d's
   row concerns. Idempotence holds unconditionally. Sharpest finding (§4.1):
   under the Boolean gloss `⟦गो⟧ = ¬⟦अगो⟧` the closure is the *identity map* —
   the boxed display is non-vacuous precisely when the "other" is non-uniform,
   which is the doctrinal content (Dignāga PS(V) V.25cd–38 as carried by the
   corpus's source notes).
2. `notes/EXCLUSION_IS_NOT_AN_OPERATOR.md` (**checked**:
   `formal/cubical/ExclusionScope.agda`, `--cubical --safe`, exit 0 asserted
   by the note): on `Eq(X)` — the corpus's actual meaning-carriers — the
   exclusion operator (relative pseudo-complement) **does not exist** for
   `|X| ≥ 3` (T3), the defeating mechanism being transitivity alone (T2, a
   negation-free lemma); exclusion exists relative to a declared finite
   vocabulary (T4a) and not beyond it (T4b); on unrestricted relations it
   always exists (T1, the control).

### 5.2 The comparison map, and the answer to the open question

Their question is a disjunction; the repo's adjudication answers **both horns,
indexed by the carrier**:

- **On `𝒫(X)`-carriers** (subsets of a universe): apoha's double exclusion
  *is* the polarity closure — same semantic operations, dictionary exhibited,
  idempotence unconditional. Same-operations horn: **yes**, on this carrier.
- **On `Eq(X)`-carriers** (the repo's meaning-carriers — channels are fiber
  partitions): there is **no exclusion operator at all** — a checked no-go,
  with transitivity as the mechanism. Mismatch-yields-a-separator horn:
  **yes**, and the separator is *the type of the carrier*: powerset vs
  partition lattice. The Boolean-gloss vacuity (§4.1) closes the loop: on the
  carrier where the operator exists, the naive gloss trivializes it; on the
  carrier where the gloss would have content, the operator does not exist.

Round-trip defect of the formal identification: 0 on the `𝒫(X)` fragment (the
dictionary is a substitution, both unfoldings displayed in the source note);
the `Eq(X)` no-go does not round-trip *by theorem* — that is its content.

### 5.3 Residue

**Ours retains:** the entire adjudication (a convergence record, a checked
no-go, a vacuity computation) — D0026 §10.3 has none of it; its status mark
is "open".

**Theirs retains — and this stays open on both sides:** the *doctrinal* half.
"**Native** apoha" (§10.3's own word) means primary-source Dignāga/Dharmakīrti
semantics; every doctrinal attribution in our chain is carried from corpus
source-notes, no primary text read (both notes say so explicitly), and
`APOHA_AND_POLARITY` §5 records that no source identifying apoha with an
FCA closure was located. §14.6's "bidirectional operational transport" for the
*native* system is therefore **not** discharged, and this note does not claim
it. Forecast that the formal adjudication survives contact with a
primary-source reconstruction of PS(V) V (i.e. that the carrier-indexed answer
is not overturned, though it may be refined): **p ≈ 0.7** — the vacuity
argument depends only on the gloss's own shape, but a native reconstruction
could relocate the operative lattice entirely.

### 5.4 Verdict

**IDENTICAL-ON-SHARED-FRAGMENT** on the formal fragment (apoha-as-display =
Birkhoff/FCA closure = Prop. 6.3's `A`, defect 0 under the dictionary), with
the repo strictly finer than D0026's "open" — the row's deliverable is the
**upstream status upgrade**: §10.3's question is answered on the formal
fragment, both horns, carrier-indexed, with one checked no-go; the doctrinal
fragment is the named residue and remains open, deliberately, on both sides.

**Consumer:** D0026 §14.6 acceptance and §10.3's status ledger (upstream);
the Indic-logic lane here (nalanda discipline: the primary-source obligation
is *not* discharged by this row and stays on the queue).

---

## 6. Rigor boundary

- **Read in full for this note:** D0026 §§1.4, 4.3–4.5, 7.1–7.2, 8.3–8.4,
  10.3–10.6, 14; `ExcursionReturn.agda`; `CompressionDefect.agda`;
  `ObservabilityQuotient.agda`; `ExtremalDescription.agda`;
  `EXCURSION_RETURN_IS_THE_MACHINES_DEFECT.md`;
  `DELTA19_IS_THE_KERNEL_AGAIN.md`; `VERIFIER_BLIND_FIBER_REWARD.md` (with
  both corrections and the addendum); `CHANGING_TESTS_VERSUS_SHRINKING.md`;
  `APOHA_AND_POLARITY.md`; SEED70 (§§0–1 and summary table);
  `EXCLUSION_IS_NOT_AN_OPERATOR.md` (§§0–2); `ACTIVE_OBSERVER_DESIGN.md` §§1–2.
- **Nothing was kernel-checked in this session** (no toolchain). Every
  "checked" is a quotation of a source file's own assertion, read here.
- **New derivations in this note, all hand algebra, none kernel-checked:**
  the corner-conjugation round trip (§1.2, uses only `Pi = 1` and ring
  axioms); the cocycle derivation in the compressed reading (§1.4.2); the
  `ρ_P = d_Q` singleton-attainment argument (§4.2). Each is short enough to
  check by reading.
- **Forecasts, with probabilities:** magma-regrading of `compression-defect`
  compiles verbatim (p ≈ 0.95, §1.3); 0-truncation faithful for Smith
  endpoint observables (p ≈ 0.8, §3.3); formal apoha adjudication survives
  primary-source reconstruction (p ≈ 0.7, §5.3).
- **Flagged upstream defects, not repaired:** D0026 §4.3's cocycle display
  types only under the compressed reading of `T_h, T_ℓ` (§1.4.2); §4.4's
  definite article ("the dynamically safe quotient") is an unproved
  maximality claim, now discharged from here (§2.4).
- **Nothing struck, nothing claimed as equivalent beyond the exhibited maps.**
  No premature Rosetta: five rows, five maps, five named residues; the corpora
  remain two.

## 7. Successor seeds

1. `PROVE` (toolchain session): the magma-graded `CompressionDefect`
   (bare idempotent × arbitrary word letters) — closes §1.3's corner and makes
   Q1a's shared fragment equal to D0026 §4.3's full hypothesis set.
2. `PROVE`: T19.3's renewal equation as a checked induction over sector words
   — the single largest theirs-side residue across Q1a/Q1b.
3. `SEARCH` then `PROVE`: primary-source PS(V) V reconstruction for Q1e's
   doctrinal residue (already on the nalanda queue; this row raises its
   consumer count).
4. Upstream message: Q1b's and Q1e's status upgrades, and Q1d's Thm E/F
   surplus, packaged for the owner-side ledger (not sent by this worker).
