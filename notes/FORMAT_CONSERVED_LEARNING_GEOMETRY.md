# Information geometry of format-measurable learning on the event torsor

**Author:** cf-tessera.  **Status:** exact theorems (discrete, rational)
with classical continuous limits cited; composition of information
geometry with R0041's discrimination lattice.  Frame requested by the
user; classical sources named; the interpretation layer stays outside the
proofs.

## 0. Setup

Let `W` be a finite set of events (a window in the event torsor `E(M)`,
or any finite carrier), `P = {C₁,…,C_r}` a partition of `W` (the
discrimination partition of a trace format, R0041 Theorem B), and
`Δ°(W)` the set of strictly positive rational policies `π` on `W`.  A
reward `r : W → ℤ` is **P-measurable** iff it is constant on every class.
The **multiplicative-weights update** (MWU) with base `β ∈ ℚ_{>1}` is

\[
\pi'_w \;=\; \frac{\pi_w\,\beta^{\,r_w}}{\sum_{u\in W}\pi_u\,\beta^{\,r_u}} .
\]

All quantities are exact rationals.  The continuous limit of MWU is the
replicator flow `π̇_w = π_w(r_w − \bar r(π))`, which is the natural
gradient of expected reward under the Fisher–Rao metric (Amari; Harper);
Chentsov's theorem gives the Fisher metric its canonical status as the
unique (up to scale) Markov-invariant metric.  These are cited, not
reproved; every theorem below is discrete and exact.

## 1. Conservation characterizes measurability

**Theorem 1.**  For all `π ∈ Δ°(W)`, all bases `β`, and all `w, u` in one
class `C`:  if `r` is P-measurable then

\[
\frac{\pi'_w}{\pi'_u} \;=\; \frac{\pi_w}{\pi_u},
\]

so every within-class conditional `π(\,\cdot\mid C)` is invariant under
MWU, for every horizon.  Conversely, if `r` is non-constant on some class
`C`, then for every `π ∈ Δ°(W)` some conditional on `C` strictly changes
in one step.  Hence: *within-class conditionals are conserved for all
initial policies iff the reward is format-measurable.*

*Proof.*  Measurable case: `β^{r_w} = β^{r_u}` cancels in the ratio along
with the normalizer.  Converse: pick `w,u ∈ C` with `r_w > r_u`; then
`π'_w/π'_u = (π_w/π_u)\,β^{\,r_w−r_u} ≠ π_w/π_u` since `β > 1`. ∎

**Corollary (outcome supervision freezes learning).**  If `P` has one
class (R0041 Theorem A: every verifier observable), MWU is the identity
map on `Δ°(W)`: `β^{r}` is a global factor absorbed by `Z`.  Learning
under outcome reward is not merely indifferent between fiber points — the
dynamics is frozen pointwise.

## 2. The foliation and its dimension count

Write `μ(π) ∈ Δ(P)` for the class marginals.  The map
`π ↦ (μ(π), (π(\cdot|C))_C)` is a bijection onto
`Δ°(P) × ∏_C Δ°(C)` (finite chain rule / product factorization).

> **Inverse supplied in place (seed130, 2026-08-14; bijection sweep).** The
> named ground is correct but only gives one direction; the two-sided inverse
> is one line and is written here so the claim is not injectivity in disguise.
> Define `Ψ(m, (κ_C)_C)_w := m_{C(w)} · κ_{C(w)}(w)`, where `C(w)` is the
> unique class containing `w` (`P` is a partition, so `C(-)` is total and
> single-valued). Then `Ψ` lands in `Δ°(W)`: the entries are positive since
> `m ∈ Δ°(P)` and `κ_C ∈ Δ°(C)`, and `Σ_w Ψ(m,κ)_w = Σ_C m_C Σ_{w∈C} κ_C(w)
> = Σ_C m_C = 1`. `Ψ ∘ Φ = id`: `μ(π)_C = Σ_{w∈C} π_w` and
> `π(w|C) = π_w / μ(π)_C` (defined because `π > 0` makes every `μ(π)_C > 0`),
> so the product returns `π_w`. `Φ ∘ Ψ = id`: `μ(Ψ(m,κ))_C = Σ_{w∈C} m_C κ_C(w)
> = m_C`, whence `Ψ(m,κ)(w|C) = m_C κ_C(w)/m_C = κ_C(w)`. Both composites are
> the identity, so `Φ` is a bijection, not merely injective. Nothing downstream
> changes: Theorem 2 and the dimension count already used only this factorization.

**Theorem 2.**  MWU with a P-measurable reward acts on the first factor
as the MWU of the induced class reward and is the identity on every
conditional factor.  The tangent kernel of `μ` has dimension
`|W| − r`, and the replicator/natural-gradient vector field of a
P-measurable reward is everywhere tangent to the leaves
`{π : π(\cdot|C) \text{ fixed}}`.

*Proof.*  First claim: `μ(π')_C = μ(π)_C β^{ρ_C}/Z` with `ρ_C` the class
value — the induced MWU — while conditionals are fixed by Theorem 1.
Kernel dimension: marginal constraints impose `r − 1` independent linear
conditions on the `(|W|−1)`-dimensional tangent space.  Tangency: the
replicator field's conditional component at `w ∈ C` is
`π(w|C)\,(ρ_C − \bar r) − π(w|C)\,(ρ_C − \bar r) = 0`. ∎

The KL chain rule `D(π\|σ) = D(μ(π)\|μ(σ)) + \sum_C μ(π)_C\,
D(π(\cdot|C)\|σ(\cdot|C))` (classical) exhibits the factorization as the
dually-flat product structure; the exact rational content is the product
factorization itself, which the replay verifies without logarithms.

## 3. The gradation of formats, dynamically

Composing with R0041 Theorem B on the event torsor `E(M) ≅ Γ₀(m)`:

1. **Outcome format** (one class): dynamics frozen entirely (§1
   Corollary).  The learner's entire belief about the fiber is a
   conserved quantity.
2. **Sign format** (`det`, two kernel-coset classes): dynamics reduces to
   a two-state replicator on the `det = ±1` marginals; with class values
   `ρ_{+} > ρ_{−}` the `+`-marginal strictly increases each step (exact
   inequality in rationals) while both conditional simplices — each
   infinite in the full torsor, finite in the window — are frozen.
3. **Bézout format**: singleton classes on the unipotent line, one frozen
   class on its infinite-index complement: the learner can sharpen within
   recorded shifts while its belief across the unrecorded complement —
   containing the audited gap witnesses — is conserved verbatim.
4. **Payload chart** (injective): all classes singletons; nothing is
   conserved except normalization; full trainability, which is exactly
   replayability (R0041 Corollary).

The conserved-quantity count is `\sum_C (|C| − 1)`: zero for the chart,
maximal (`|W| − 1`, everything) for outcome supervision — the same
lattice as R0041's, now graded by conservation laws instead of partitions.

## 4. What this adds beyond R0041

R0041 is statics: equal expected reward, fiber-saturated argmax.  The
present theorems are dynamics: the *trajectory* of any natural-gradient /
multiplicative-weights learner under a format-measurable reward preserves
the fiber conditionals exactly, at every step, for every base and
horizon.  Chentsov's invariance means this is not an artifact of one
metric choice: any Markov-invariant geometry produces the same degenerate
directions, because the format statistic is the only channel through
which reward sees the policy.  The tie-breaking result (R0027 §4) then
reads: to change a conserved quantity one must change the partition —
import an ecology observable — not the step size, base, or horizon.

## 5. Replay

`machinery/format_conserved_learning_geometry.py` with tests, all exact
`Fraction` arithmetic: Theorem 1 conservation over multi-step MWU for the
four formats on real event windows (reusing R0041's machinery and grid);
the converse witness (non-measurable reward changes a conditional in one
step); the frozen outcome dynamics (MWU literally identity); the induced
two-state dynamics for the sign format with the strict marginal
inequality; the product factorization identity; and the kernel dimension
count against explicit basis vectors.

## Rigor boundary

Theorems 1–2 and the gradation are proved above in the discrete rational
setting; they are elementary and their content is the composition with
the computed fibers and formats of R0027/R0032/R0033/R0035/R0041.
Replicator-as-natural-gradient, Chentsov's theorem, and the KL chain rule
are classical (Amari; Chentsov; Cover–Thomas) and are cited as the
continuous/canonical envelope, not re-proved and not load-bearing for the
discrete claims.  No statement is made about stochastic-gradient noise,
function approximation, or any learner other than exact MWU/replicator;
"frozen belief" is precisely conditional invariance, nothing more.
