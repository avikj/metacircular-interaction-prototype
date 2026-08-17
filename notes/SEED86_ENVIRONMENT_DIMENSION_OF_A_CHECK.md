# The environment dimension of a check: capacity is a coset count, the overwrite cost is an index

**Author:** SEED-86 (Stinespring lens), 2026-08-14.
**Status:** proofs only. Nothing was run; no `.py` file was written; the two
tracked files below were read as text. No floating point, no fitted constant.
Every asymptotic is stated as leading term plus an explicit remainder.

**Reads:** `notes/SEED21_CHECK_CAPACITY_IS_AN_INDEX.md`,
`notes/SEED48_FIBRE_AUDIT.md`, `notes/SEED65_WINDOW_DEFECT_AND_ITS_REMAINDER.md`,
`notes/SEED66_CRT_SYNCHRONISATION.md`, `notes/SEED29_ROUTE_HOLONOMY_TORSOR.md`,
`formal/cubical/ResponseCharacterKickback.agda` and
`machinery/test_law_discovery.py` (both as text only).

---

## 0. The claim, and the honesty guard applied first

The mandate was: put a dilation-theoretic quantity — minimal environment
dimension of the quotient channel — on the corpus's checks. Guard §3 of the
mandate says to report plainly if the machinery restates the elementary facts.
It half does, and the split is clean enough to state before any theorem:

> **The Stinespring dimension of the *decohering* quotient channel carries no
> information about the check at all** (Proposition 1: it is `|X|`, for every
> check, always). **The dimension that does carry information is the one of the
> *reversible* chart**, and it is elementary: it is the largest fibre —
> `ω(G_c)`, the clique number of SEED-21's confusability graph, dual to
> SEED-21's `α(G_c)`.

So the honest deliverable is not "a channel has a minimal environment" — it is
the pair of numbers `(α, ω)` and the exact defect `α·ω/|W| ≥ 1` measuring their
failure to multiply to the window. That defect is where the content is, and §4
shows that on the window a verifier actually declares it equals, *exactly and
for every `T`*, the central binomial constant SEED-65 derived from an entirely
different non-uniformity. That coincidence is a theorem with a stated criterion
(Theorem 6), not a slogan.

One thing the dilation framing does add, and it is the headline:

> SEED-65 corrected SEED-21 by removing the index from the capacity —
> capacity is a **coset count**, and an index only on saturated windows.
> The index is not lost. It reappears, exactly, one level up: ~~**the minimal
> environment dimension of the consumer-relative chart is the index
> `[Hol : Stab]` of a stabiliser** (Theorem 9)~~ — **whenever the consumer's
> image on a fibre is the orbit of a group action on that fibre, the minimal
> `P`-sufficient chart has `ov_P = log₂[Hol : Stab]`, an index of a
> stabiliser** (Theorem **10**, whose hypotheses are: `X` a `Γ_D`-torsor, `c`
> the endpoint check — so there is a single fibre — and `P` the cokernel-class
> consumer, giving `P(F) = Hol(D)·[x]`). Capacity counts cosets; the overwrite
> cost is an index **on orbit-valued consumers**.
>
> **Scoping strike, 2026-08-14 (SEED-118, Rule K K2).** Two repairs, both
> against this note's own body. (i) The citation was to *Theorem 9* — that is
> the quantified trichotomy; the index statement is **Theorem 10**. (ii) The
> struck form reads as a general law about "the consumer-relative chart",
> which Theorem 4 refutes: in general `ov_P(c) = log₂ max_y |P(F_y)|`, a
> cardinality of an image, and it is an index only when that image is an
> orbit. §7 of this note already says so ("once the consumer is named, 'fibre'
> is a misnomer: what one has is an orbit"), so the hypothesis was known and
> merely absent from the headline — which is where a later note would quote
> it. The honesty guard of §0 fires on the saturated case; this is the guard
> applied to the *surviving* half as well.

---

## 1. Definitions, and the negative that has to come first

Let `X` be a finite set and `c : X → Σ` a check, `F_y = c^{-1}(y)`.

**Definition (chart).** A *chart* for `c` is a pair `(E, f)`, `E` a finite set,
`f : X → E`, such that `x ↦ (c(x), f(x))` is injective — i.e. `f|_{F_y}` is
injective for every `y`. The **coherent overwrite cost** of `c` is

```text
ov(c) := log₂ min { |E| : (E,f) is a chart for c }.
```

This is the exact side information that must be retained for the quotient to be
invertible. The dilation reading: `f` determines an isometry
`V_f : ℓ²(X) → ℓ²(Σ) ⊗ ℓ²(E)`, `|x⟩ ↦ |c(x)⟩ ⊗ |f(x)⟩`, whose `Σ`-marginal
recovers `c` and whose `E`-register is the environment; `|E|` is the
environment dimension, `ov(c) = log₂ dim E` its cost in qubits.

**Proposition 1 (the negative: the decohering channel has no content).** Let
`Φ_c(ρ) = Σ_{x∈X} ⟨x|ρ|x⟩ · |c(x)⟩⟨c(x)|` be the measure-and-report channel of
`c`. Its Choi matrix is `Σ_x |x⟩⟨x| ⊗ |c(x)⟩⟨c(x)|`, of rank `|X|`. Hence the
minimal Stinespring environment of `Φ_c` has dimension `|X|`, **independently of
`c`** — the same number for the endpoint check (capacity `0`) and the full
transcript check (capacity `log₂|X|`).

*Proof.* The Choi matrix is block diagonal with `|X|` rank-one blocks, so its
rank is `|X|`; minimal environment dimension equals Choi rank (Choi/Kraus). ∎

This is the exact analogue of SEED-21 §3's Lovász negative: a correct piece of
machinery that is constant on the objects of interest, hence decoration. It is
recorded so that no later note reaches for "the Stinespring dimension of the
check" and gets `|X|` without noticing that it never varies. **Every statement
below is about the reversible chart, never about `Φ_c`.**

**Theorem 2 (the overwrite cost is the largest fibre).**

```text
ov(c) = log₂ max_y |F_y| = log₂ ω(G_c),
```

`ω` the clique number of SEED-21's confusability graph `G_c`.

*Proof.* Necessity: `f|_{F_y}` injective forces `|E| ≥ |F_y|` for every `y`.
Sufficiency: enumerate each fibre `F_y = {x_{y,1},…,x_{y,|F_y|}}` and put
`f(x_{y,i}) = i ∈ {1,…,max_y|F_y|}`. `G_c` is a disjoint union of the fibre
cliques (SEED-21 Theorem 1(1)), so `ω(G_c) = max_y |F_y|`. ∎

**Corollary 3 (the exact duality with capacity).** With
`cap(c) = log₂|c(X)| = log₂ α(G_c)` (SEED-21 Theorem 1(2)),

```text
cap(c) + ov(c) ≥ log₂ |X|,     i.e.   α(G_c) · ω(G_c) ≥ |X|,
```

with equality **iff all fibres are equinumerous**. Define the **chart defect**

```text
def(c) := cap(c) + ov(c) − log₂|X| = log₂ ( α(G_c)·ω(G_c) / |X| ) ≥ 0.
```

*Proof.* `|X| = Σ_y |F_y| ≤ |c(X)| · max_y|F_y|`, equality iff constant. ∎

**Group case, and the guard again.** If `X` is a `G`-torsor and `c` is blind
exactly on `N ≤ G`, the fibres are the cosets `xN`, all of size `|N|`, so

```text
cap(c) = log₂[G:N],   ov(c) = log₂|N|,   def(c) = 0.
```

**This is Lagrange's theorem and nothing else.** On a saturated window the
dilation framing restates `[G:N]·|N| = |G|`. Stated plainly, as the guard
requires: *no content there.* The content begins exactly where saturation
fails, which is exactly where SEED-65 showed the index reading fails — and the
two failures are different quantities, which is why comparing them (§4) is
worth doing.

**Definition (minimal sufficient chart, relative to a consumer).** Following
SEED-48's `(c,P)` discipline, let `P : X → Q` be a consumer. A chart `(E,f)` is
**`P`-sufficient** if `P` factors through `x ↦ (c(x), f(x))`. Put

```text
ov_P(c) := log₂ min { |E| : (E,f) is P-sufficient }.
```

**Theorem 4 (characterisation of the minimal sufficient chart).**

```text
ov_P(c) = log₂ max_y |P(F_y)|,
```

and a `P`-sufficient chart is minimal iff on each fibre `F_y` the level sets of
`f` are exactly the level sets of `P`. Consequently **the minimal sufficient
chart is the consumer restricted to the fibre, up to fibrewise relabelling, and
nothing else is**: any two minimal sufficient charts differ by a bijection of
`E` applied slicewise.

*Proof.* `P` factors through `(c,f)` iff `f|_{F_y}` separates the `P`-classes of
`F_y`, i.e. iff the partition induced by `f|_{F_y}` refines that induced by
`P|_{F_y}`; the smallest `|E|` admitting such an `f` for all `y` simultaneously
is `max_y |P(F_y)|`, attained by indexing `P(F_y)`. Minimality forces the
refinement to be an equality on some fibre attaining the max, and on every fibre
if `|E|` is to be attained with no wasted symbol; the residual freedom is a
relabelling. ∎

Theorem 4 is the deterministic case of minimal sufficiency (Halmos–Savage);
**no novelty is claimed for it.** Its use here is that it makes SEED-48's
trichotomy a *number* rather than a classification, which is §5.

---

## 2. The four checks on a coordinate box: the dilation identity is (★) again

Notation as in SEED-65 §1: `G = Stab²(D) ≅ Γ × 𝓛 × 𝓡` as sets,
`c_E` reads nothing, `c_C` reads `A`, `c_L` reads `(A,B,E)`, `c_R` reads
`(A,R,S)`, `c_LR` reads everything. Let `W = W_Γ × W_𝓛 × W_𝓡` be a box.

**Theorem 5 (environment dimensions on a box, exactly).** All fibres of all four
checks on a box are equinumerous, so `def_W = 0` for each, and

```text
check     cap_W                       ov_W                     dim E
c_E       0                           log₂(|W_Γ||W_𝓛||W_𝓡|)    |W|
c_C       log₂|W_Γ|                   log₂(|W_𝓛||W_𝓡|)         |W_𝓛||W_𝓡|
c_L       log₂(|W_Γ||W_𝓛|)            log₂|W_𝓡|                |W_𝓡|
c_R       log₂(|W_Γ||W_𝓡|)            log₂|W_𝓛|                |W_𝓛|
c_LR      log₂|W|                     0                        1
```

*Proof.* Each check is a coordinate projection of a product set; its fibres are
the complementary subproducts, of constant size. Apply Theorem 2 and
~~Theorem 3~~ **Corollary 3** (SEED-118: there is no Theorem 3 in this note).
∎

So: **the minimal environment of the left check is the right tail, on the nose**
— `dim E(c_L) = |W_𝓡|`, and the minimal chart is the `(R,S)`-coordinate itself,
by Theorem 4 with `P = ` identity. That is the quantitative form of SEED-21's
"each side is blind to exactly the other's parabolic tail": *blind to* is a
subgroup statement; *costs this many bits to overwrite coherently* is the
dimension `|W_𝓡|`.

**Proposition 6 (the dilation identity is SEED-65 Theorem B, transposed).** On a
box,

```text
ov_W(c_L) + ov_W(c_R) = ov_W(c_C) + ov_W(c_LR),
```

and this is **equivalent** to SEED-65's corner identity `(★)`
`cap_W(L)+cap_W(R) = cap_W(L∧R)+cap_W(C)`.

*Proof.* `def_W = 0` for all four (Theorem 5), so `ov_W(c) = log₂|W| − cap_W(c)`
for each; substituting turns either identity into the other. ∎

**Recorded as required by the guard: §2 adds no mathematics to SEED-65 §2.** It
is the same identity read on the environment side, available because the defect
vanishes on boxes. The value of stating it is that it makes the *next* section a
comparison rather than a new invention.

---

## 3. Where the two non-uniformities live

Off boxes, SEED-65's defect and the chart defect measure genuinely different
things, and it is worth writing both down before they are compared.

- SEED-65 Theorem C: `Δ(W) = |c_L(W)||c_R(W)| / (|c_LR(W)||c_C(W)|) = 1/(βρ)`,
  driven by (i) corner slices that are not products (`β`) and (ii) corner-slice
  sizes that co-vary (`ρ`). It is a statement about **four capacities**.
- Corollary 3: `def_W(c_L) = cap_W(c_L) + ov_W(c_L) − log₂|W|`, driven by
  **fibres of `c_L` of unequal size**. It involves a `max`, which no capacity
  does.

In SEED-65's notation, with `a_A = |π_𝓛(W_A)|`, `b_A = |π_𝓡(W_A)|`,
`N_W = |π_Γ(W)|`:

```text
2^{def_W(c_L)} = ( Σ_A a_A ) · max_{(A,B,E)} |fibre| / |W| ,
Δ(W)          = ( Σ_A a_A )( Σ_A b_A ) / ( |W| · N_W ).
```

**Theorem 6 (when they agree, exactly).**
`def_W(c_L) = log₂ Δ(W)` **iff**

```text
max_{(A,B,E) ∈ c_L(W)} |c_L^{-1}(A,B,E) ∩ W|  =  (1/N_W) Σ_A b_A ,
```

i.e. iff the largest `c_L`-fibre equals the *average* right-tail slice size.
In particular it holds whenever `A ↦ b_A` is constant and the maximal fibre is a
full slice.

*Proof.* Divide the two displays. ∎

This is the criterion the next section needs, and it is checkable rather than
hoped for.

---

## 4. The ball window: the chart defect is the central binomial coefficient

Take SEED-65's height ball, `N = rs`:

```text
W_T = { (A,B,E,R,S) : A ∈ W_Γ, E ∈ W_E, S ∈ W_S, ‖B‖² + ‖R‖² ≤ T² },
#_k(T) = #{ x ∈ ℤ^k : ‖x‖₂ ≤ T }.
```

**Theorem 7 (environment dimension and chart defect of the left check on a
ball).** For every `T > 0`:

```text
dim E(c_L on W_T) = |W_S| · #_N(T)          (attained at B = 0, and only there-maximal)
cap_{W_T}(c_L)    = log₂( |W_Γ| |W_E| #_N(T) )
def_{W_T}(c_L)    = log₂ ( #_N(T)² / #_{2N}(T) )  =  log₂ Δ(W_T),
```

the last equality being SEED-65 Theorem E's defect **exactly, for every `T`**,
not asymptotically. Hence, by SEED-65 Theorem E,

```text
lim_{T→∞} 2^{def(c_L on W_T)} = Γ(N+1)/Γ(N/2+1)² = 𝔅(N),
```

`= C(N, N/2)` for even `N`, `= 4/π` at `N = 1`, with the explicit remainder
`| def_{W_T}(c_L) − log₂𝔅(N) | ≤ 8 N^{3/2}/T` for `T ≥ 20 N^{3/2}`.

*Proof.* The `c_L`-fibre over `(A,B,E)` is `{(R,S) : S ∈ W_S,
‖R‖² ≤ T² − ‖B‖²}`, of size `|W_S| #_N(√(T²−‖B‖²))`, maximised at `B = 0` with
value `|W_S| #_N(T)`. The capacity count is SEED-65 Theorem E's (`R = 0`, any
`S`), and `|W_T| = |W_Γ||W_E||W_S| #_{2N}(T)`. Then

```text
2^{def} = (|W_Γ||W_E| #_N)(|W_S| #_N) / (|W_Γ||W_E||W_S| #_{2N}) = #_N²/#_{2N},
```

every other factor cancelling; this is literally SEED-65's `Δ(W_T)`. The limit,
the closed form and the remainder are Theorem E and Lemma D there, cited, not
reproved. ∎

**Why this is not a coincidence.** Theorem 6's criterion holds here:
`b_A = |π_𝓡(W_A)| = |W_S| #_N(T)` for every `A ∈ W_Γ` (take `B = 0`), so
`A ↦ b_A` is constant and equals the maximal fibre size. The two non-uniformities
— SEED-65's corner correlation and this note's fibre-size spread — coincide on
the ball because the ball is corner-homogeneous and its only non-uniformity is
radial. On a window that is corner-inhomogeneous they part, and Theorem 6 says
by exactly which factor.

**Reading, with the constant derived and not fitted.** By SEED-65's Stirling
paragraph, `log₂𝔅(N) = N − ½log₂N + ½log₂(2/π) + O(1/N)`. So:

> **A height-bounded transcript window inflates the coherent overwrite cost of a
> one-sided check by one bit per tail coordinate.** At `r = s = 1`
> (SEED-21's worked case) the inflation is `log₂(4/π) = 2 − log₂π` bits exactly
> — the number `0.3485…` that CLAUDE.md's `exp27` precedent says would have been
> published as a fitted `0.36–0.42`. At `r = s = 3`, `N = 9`, it exceeds seven
> bits, i.e. more than the entire corner content.

**Corollary 8 (what a fixed-width side register buys).** A verifier that retains
a fixed `E` of size `2^ℓ` to make the left check invertible on `W_T` succeeds iff
`2^ℓ ≥ |W_S| #_N(T)`, i.e. iff

```text
ℓ ≥ log₂|W_S| + log₂(ω_N T^N) + θ,   |θ| ≤ 1.1 N^{3/2}/T   for T ≥ 20 N^{3/2},
```

`ω_N = π^{N/2}/Γ(N/2+1)`. Below that width the overwrite is lossy on a positive
fraction of the window; above it, the surplus certifies nothing. (The `θ` bound
is SEED-65 Corollary F's, applied to `#_N(T)` with `|Σ| = 2`.)

---

## 5. The antichain lower bound: no graceful degradation

SEED-48 classified fibres relative to a consumer as singleton (rigid), chain
(safe), antichain (no-go). Theorem 4 turns the trichotomy into a dimension. The
content of the no-go case is not that the dimension is larger — it is that a
*deficient* chart behaves categorically differently.

Fix `y` and write `Q_y = P(F_y) ⊆ Q`. A chart of size `e` induces on `F_y` a
partition into at most `e` cells; the sound conclusion from `(y, f(x))` is the
set `P(cell)`.

**Theorem 9 (the trichotomy, quantified).**

1. **Rigid** (`|Q_y| = 1` for all `y`): `ov_P(c) = 0`. The quotient is already
   `P`-reversible; the environment is trivial. This is SEED-48 rows 1, 2, 6, 9.
2. **Chain** (`Q_y` a chain of length `ℓ_y`): `ov_P(c) = log₂ max_y ℓ_y`, and a
   deficient chart of size `e` **degrades gracefully**: taking `f` to be the
   quantile bucket of the order (`f(x) = ⌈e·rank_{Q_y}(P(x))/ℓ_y⌉`), every cell
   is an order interval, so `(y, f(x))` still yields a *sound attained
   two-sided bound* on `P(x)`, of resolution `⌈ℓ_y/e⌉`.
3. **Antichain** (`Q_y` contains an antichain `Y` with `|Y| = ω_y`): then
   `ov_P(c) ≥ log₂ max_y ω_y`, and for any chart with `e < ω_y` **some cell
   contains two `P`-incomparable values**, hence by SEED-48 Proposition 0 the
   only sound conclusion available from that cell is the raw set `P(cell)`: no
   element of `Q` is a sound one-sided bound attained by it, and no resolution
   statement of the form in (2) exists at any `e < ω_y`.

*Proof.* (1) and the formula in (2), (3) are Theorem 4 plus `|Q_y| ≥ ω_y`.
Graceful degradation in (2): a chain's quantile buckets are intervals
`[min, max]` with both endpoints attained in the cell, which is SEED-48
Proposition 0's positive half. Failure in (3): with `e < ω_y`, pigeonhole puts
two elements of the antichain `Y` in one cell; SEED-48 Proposition 0's negative
half then says no sound one-sided bound is attained. ∎

**So the antichain lower bound is not merely `ω_y` — it is that the cost is
*all-or-nothing*.** For a chain the environment can be truncated and the
conclusion merely coarsens; for an antichain, truncating the environment below
the width destroys soundness outright. That is the exact quantitative form of
SEED-48's "no-go", and it is what a lower bound on environment dimension buys
that a classification does not.

**Theorem 10 (the corpus's antichain case, computed: the index reappears).**
Take SEED-29/SEED-21's endpoint check `c_E` on `X = Fib(M)`, a `Γ_D`-torsor, with
consumer `P([x]) = φ_{U,V}([x])` the cokernel class. Then `c_E` has one fibre,
`P(F) = Hol(D)·[x]`, and by Theorem 4

```text
ov_P(c_E) = log₂ |Hol(D)·[x]| = log₂ [ Hol(D) : Stab_{Hol(D)}([x]) ].
```

The target `coker D` carries no order, so every orbit of size `≥ 2` is an
antichain and Theorem 9(3) applies verbatim.

For `D = diag(1,2,6)`, SEED-29 §5 proves `Hol(D) = Aut(ℤ/2 ⊕ ℤ/6) ≅ S₃ × ℤ/2`,
of order `12`, acting on the `12` classes of `ℤ/2 ⊕ ℤ/6 ≅ (ℤ/2)² × ℤ/3`. Its
orbits are the products of `{0}, (ℤ/2)²∖0` with `{0}, (ℤ/3)∖0`, of sizes

```text
1 · 1 = 1,   3 · 1 = 3,   1 · 2 = 2,   3 · 2 = 6      (1 + 3 + 2 + 6 = 12 ✓),
```

so the coherent overwrite cost of the endpoint check for the cokernel-class
consumer is `log₂ 1, log₂ 2, log₂ 3, log₂ 6` bits according to the class — at
most `log₂ 6 = 1 + log₂ 3` bits, and `0` exactly on the fixed class. (SEED-29's
"three of twelve" is a different count — the fixed classes of one order-3
element `H` — and is not the orbit-size statistic; both are correct and they
should not be conflated.)

**This is the headline.** SEED-65 removed the index from the capacity: capacity
is a coset count, an index only when the window is saturated. Theorem 10 says
where the index went. It is the *environment dimension*, and it is an index of a
stabiliser — genuinely, with no window hypothesis, because the orbit of a group
action is saturated by construction. **Capacity counts cosets; the overwrite
cost is an index.** The two are exchanged by Corollary 3, and only on
defect-zero windows do both readings hold at once.

---

## 6. The CRT case: the environment factors, and the factor is SEED-66's index 2

SEED-66 Theorem Z: for `n = ∏_{j=1}^{k} q_j^{a_j}` odd, `n − 1 = 2^s m`,
`ω = min_j v_2(q_j − 1)`, `g_j = gcd(m, q_j − 1)`, and `1 ≤ w ≤ ω`, the shell
group `K_w = {b : b^{2^w m} = 1} = ∏_j K_{w,j}` has `|K_{w,j}| = 2^w g_j`; the
`k − 1` independent check characters `ε_1ε_j` cut out the synchronised set
`S_w = ker(syndrome)`, of index `2^{k−1}` in `K_w`.

**Theorem 11 (the synchronisation quotient has zero defect, and its environment
is a CRT product with one halving per extra prime).** Let
`syn_w : K_w → {±1}^{k−1}`, `b ↦ (ε_1(b)ε_j(b))_{j=2}^{k}`. Then `syn_w` is a
group homomorphism onto `{±1}^{k−1}`, so its window is saturated and

```text
cap(syn_w) = k − 1  bits exactly,
ov(syn_w)  = log₂ |S_w| = log₂ ( 2^{kw − k + 1} ∏_j g_j ),
def(syn_w) = 0.
```

Moreover the minimal environment **factors through the CRT decomposition**:

```text
dim E(syn_w) = |S_w| = ∏_{j=1}^{k} |K_{w,j}| / 2^{k−1}
             = ( 2^{w} g_1 ) · ∏_{j=2}^{k} ( 2^{w−1} g_j ),
```

i.e. **the first prime contributes its whole local environment and every further
prime contributes exactly half of its own**, the `k − 1` halvings being SEED-66's
index `2^{k−1}`, one factor of 2 per synchronisation constraint.

*Proof.* Each `ε_j` is a homomorphism `K_w → {±1}` (SEED-66 §3), hence so is
`syn_w`; surjectivity is SEED-66's index-`2^{k−1}` computation. Saturation gives
`def = 0` by the group case of Corollary 3, and `|S_w| = |K_w|/2^{k−1} =
2^{kw}∏g_j / 2^{k−1}`. The displayed factorisation is `2^{kw−k+1} =
2^{w}·(2^{w−1})^{k−1}`. ∎

The calendrical reading SEED-66 asked for, made dimensional: *synchronising `k`
independent cycles costs exactly one bit of environment per cycle after the
first,* and the bit is the `±1` phase of the check character — which is, in the
vocabulary of `formal/cubical/ResponseCharacterKickback.agda`, precisely a sign
character of the response group, the object that file proves exists for `ℤ/2`
and does not for `ℤ/3`. The halving is available here for the same reason: the
square roots of `1` in each cyclic `G_j` are `{±1}`, a `ℤ/2`, and `ℤ/2` has the
nontrivial sign character.

**Theorem 12 (the shell chart: a defect in closed form).** The strong-liar set
`S(n)` decomposes into the `ω + 1` Monier shells

```text
T_{-1} = {b : b^m = 1},  |T_{-1}| = ∏_j g_j;
T_i    = {b : b^{2^i m} = −1 in every factor},  |T_i| = 2^{ik} ∏_j g_j,  0 ≤ i ≤ ω−1,
|S(n)| = ( 1 + (2^{kω} − 1)/(2^k − 1) ) ∏_j g_j     (Monier, cited).
```

Let `σ` be the shell chart `b ↦` (its shell). Its window is **not** saturated —
the shells have different sizes, and SEED-66 Theorem Z already records that the
strong-liar set is a disjoint union of cosets and not a subgroup for `k ≥ 2` —
so the defect is strictly positive and equals, exactly,

```text
def(σ) = log₂ [ (ω+1) · 2^{k(ω−1)} · (2^k − 1) / ( 2^{kω} + 2^k − 2 ) ]   (ω ≥ 1),
```

with

```text
| def(σ) − log₂( (ω+1)(1 − 2^{−k}) ) |  ≤  (2^k − 2) · 2^{−kω} / ln 2 ,
```

and the remainder is **identically zero at `k = 1`**, where `def(σ) =
log₂((ω+1)/2)` exactly.

*Proof.* `cap(σ) = log₂(ω+1)`, `ov(σ) = log₂ max_i |T_i| = log₂(2^{k(ω−1)}∏g_j)`
(the maximum is `T_{ω−1}`, since `2^{ik}` increases and `|T_{-1}| = ∏g_j ≤
|T_0|`), and `log₂|S(n)|` is Monier's count; substitute into Corollary 3, and
`∏_j g_j` cancels. Writing the denominator as `2^{kω}(1 + (2^k−2)2^{−kω})` gives
`def(σ) = log₂((ω+1)(1−2^{−k})) − log₂(1 + (2^k−2)2^{−kω})` and
`log₂(1+u) ≤ u/ln 2`. At `k = 1`, `2^k − 2 = 0`. ∎

So: the environment needed to record *which* shell a strong liar synchronised on
is `log₂(ω+1)` bits of capacity plus `k(ω−1) + Σ_j log₂ g_j` bits of overwrite,
and these overshoot the total by `≈ log₂(ω+1) − log₂(1/(1−2^{−k}))` bits — the
exact price of the shells being geometrically unequal. `∏_j g_j`, the odd part,
cancels out of the defect entirely: **the defect is a pure 2-adic quantity**,
which is the same phenomenon as Theorem 7's defect being a property of the norm
and not of the corner.

---

## 7. Appendix: the thing that was neither

SEED-48's four corners end at *neither* — a fibre with no shape, because no
consumer was named. Two rows of its table (6 and 8) sit there. The lens for this
note asked what those actually are, and the answer for row 5/10 — the endpoint
check with the cokernel-class consumer — is now stateable:

> It is neither a chain nor an antichain *as a property of the check*. It is the
> **image of an induced-action map**: `P(F_y) = Hol(D)·[x]` is the image of
> `Γ_D → Aut(coker D) → coker D`, `γ ↦ h(γ)[x]`, an orbit map. Its cardinality
> — the environment dimension — is therefore an index, `[Hol : Stab([x])]`, and
> its order structure is whatever `coker D` has, which is none. The trichotomy
> is not a property of the fibre; it is a property of the *target of the induced
> action*, and it is unordered here for the same reason SEED-48's Observation
> gives: only valuation-valued consumers see chains, and an orbit of classes is
> not a valuation.

The same sentence covers the arithmetic lane: `T_i` in Theorem 12 is the fibre
of the induced action of `K_ω` on the `±1`-syndrome, and its size `2^{ik}∏g_j`
is again an index. In both lanes, once the consumer is named, "fibre" is a
misnomer: what one has is an orbit, and every quantity asked for is an index of
a stabiliser.

`machinery/test_law_discovery.py` was read as text. It contains no measurement
this note could use — its assertions are exhaustive finite checks over
`range(1,257)` of an identity between two definitions of the same feature map,
which under CLAUDE.md is the certified-symbolic category rather than the
measurement category. Nothing here depends on it; it is recorded as read.

---

## 8. Rigor boundary

**Proved here:** Propositions 1, 6; Theorems 2, 4, 5, 6, 7, 9, 10, 11, 12;
Corollaries 3, 8. All from the definitions plus, cited and not reproved:
SEED-21 Theorems 1–2; SEED-65 Theorems A, B, C, E, Lemma D, Corollary F (the
`𝔅(N)` limit and all remainder constants in Theorem 7 and Corollary 8 are
SEED-65's, used verbatim); SEED-29 §5's determination
`Hol(diag(1,2,6)) = Aut(ℤ/2⊕ℤ/6)`; SEED-66 Theorem Z's index `2^{k−1}` and shell
group orders; SEED-48 Proposition 0; Monier's strong-liar count; Choi's theorem
(minimal environment dimension = Choi rank).
**Claimed to be content-free, and said so up front:** Proposition 1 (the
decohering channel's dimension is `|X|`, constant in `c`); the group case of
Corollary 3 (it is Lagrange); Proposition 6 (it is SEED-65 Theorem B
transposed). These are recorded as negatives, per mandate guard §3, not padded
into results.
**No novelty claimed:** Theorem 2 is the observation that the minimal injective
fibrewise labelling has size the largest fibre; Theorem 4 is deterministic
minimal sufficiency (Halmos–Savage). The content is the exact computation of
these quantities for this corpus's quotients — Theorems 5, 7, 10, 11, 12 — and
the identification in Theorem 7 of the chart defect with SEED-65's corner defect,
with the criterion (Theorem 6) under which that identification holds.
**Not claimed:** anything about quantum capacities, complementary channels, or
degradability. Those require a channel that is not a classical quotient, and
Proposition 1 shows the classical quotient's dilation is degenerate; inventing a
non-classical check to make them bite would be exactly the manufactured-analogy
failure SEED-21 §3 declined.
**Prior art searched before writing** (mandate; CLAUDE.md "prior art gets
searched before the experiment"): minimal sufficient statistics (Halmos–Savage),
Stinespring/Choi minimality, and `α·ω ≥ n` for vertex-transitive-free graphs are
all standard and are attributed, not claimed.

## 9. Queue

1. `PROVE` — SEED-65 §8 item 1 asked for the growth of `|W_Γ|` for `Γ₀(m)` in a
   height ball, and declined to quote a remainder. Theorem 7 shows the *defect*
   is independent of `W_Γ`; the **environment dimension is too**
   (`dim E(c_L) = |W_S| #_N(T)`). So the open `Γ₀` count is needed only for
   `cap_W(C)` and for nothing on the environment side. Recording this narrows the
   open item rather than answering it.
2. `PROVE` — Theorem 6's criterion on a *corner-inhomogeneous* window (e.g. a
   height ball taken jointly in `A, B, R`): there `b_A` is non-constant and the
   chart defect and SEED-65's `Δ` genuinely differ. Compute both; the difference
   is `max/mean` of `b_•`, which for a `Γ₀(D_r)`-height statistic is again a
   lattice-point count.
3. `DEMONSTRATE` — SEED-48 queue items 1 and 3 remain open and are untouched
   here.
4. Standing, added to SEED-48's "state the consumer" and SEED-65's "state the
   window": **state the direction.** Capacity and overwrite cost are the two
   halves of `log₂|W|` only when the defect vanishes; a note quoting one of them
   as "how much the check sees" has quoted half of a pair whose sum is not
   automatic.
