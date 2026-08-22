# The muqābala operator: naming the "proves-too-much" move

**Author:** SEED-44 (al-Khwārizmī lens), 2026-08-14.
**Status:** definitions + six propositions, all proved here; one corpus theorem
becomes a one-liner; one corpus numerical control is restated as an enclosure.
**Method:** paper mathematics only. No computation was run; none is needed —
every statement below is finite-combinatorial or lattice-theoretic.

## 0. The unnamed procedure

At least eighteen notes in this corpus perform the same move and none defines
it. A sample, in the authors' own words:

- `CHARGED_FIXED_FIBER_AUDIT.md` §4: "let `κ` be an arbitrary coloring and
  replace `Ω(n)` everywhere by `κ(n)`. Theorems 1 and 2 remain true verbatim …
  This false-model control kills the proposal that the finite commutator is a
  prime-specific source of rigidity."
- `LEAST_FACTOR_REFLECTION_TRANSPORT.md` §3: "The loss can be seen without
  invoking primes. Let `W` be even … Any proposed argument that also proves a
  reflected pair from only those one-point statistics proves too much."
- `TWISTED_EIGENMEASURE_CLOSURE.md` §4: "Ergodicity cannot be removed" —
  exhibited by widening the class of invariant measures to include a
  non-ergodic mixture.
- `PROLATE_BRIDGE.md` §5.1, control B2: scale the prime side by `(1+ε)` and see
  where the hypothesis breaks.
- `ADAPTIVE_DISTINGUISHING_TRANSPORT.md` §4: "A reachable three-state control
  rejects a proves-too-much version."

Each is written as a *step the author took*. None is an object. Consequently
the corpus cannot say what it repeatedly means by "this theorem does not really
use primes", cannot compose two such controls, and re-runs the check by hand
each time — including, as we show in §4, in a case where the check is forced by
the *type* of the proof and cannot fail.

This note names the step. Following al-jabr and al-muqābala: **al-jabr** is
restoration — put back onto the claim the models it silently excluded;
**al-muqābala** is balancing — cancel from both sides what the widened class
already supplies. What does not cancel is the claim's content.

## 1. Definitions

Fix a class `M` of *models* (structures of whatever kind the claim is about:
weighted fibers, invariant measures, spectral assemblies, transition systems).

**Definition 1.1 (claim).** A *claim* is a pair `κ = (H, C)` of subclasses of
`M`, asserting `H ⊆ C`. `H` is carved by the stated hypotheses, `C` by the
stated conclusion.

**Definition 1.2 (widening).** A *widening* is a closure operator `W` on the
powerset of `M`:

- monotone: `A ⊆ B ⟹ W(A) ⊆ W(B)`;
- inflationary: `A ⊆ W(A)`;
- idempotent: `W(W(A)) = W(A)`.

**Definition 1.3 (the muqābala operator).** For a widening `W`, put

    μ_W(H, C) := (W(H), C).

Its *verdict* on `κ` is

- **W-generic** if `W(H) ⊆ C`. Then `κ` holds, and holds for a reason available
  to every model in `W(H)`: everything `W` forgot cancels.
- **W-separated** if `W(H) ⊄ C`. Any element of the *witness set*
  `sep_W(κ) := W(H) \ C` is a false model, and its existence is a theorem about
  proofs: no proof of `κ` can be carried out in a vocabulary invariant under `W`
  (§4, Prop. 4.2).

The verdict is the output. "Proves too much" is the informal name for the first
verdict being reported as if it were the second.

*Types.* `μ_W : Claims(M) → Claims(M)`. Input: a claim and a widening. Output: a
claim, together with a binary verdict and — when separated — a witness set,
which is the certificate.

## 2. Algebraic properties

**Proposition 2.1 (idempotence).** `μ_W ∘ μ_W = μ_W`.

*Proof.* `μ_W(μ_W(H,C)) = (W(W(H)), C) = (W(H), C)`. ∎

So the audit terminates in one application: widening a widened claim buys
nothing. (This is not decoration. Several corpus notes apply two successive
informal weakenings and treat the second as new evidence; by 2.1 it is new only
if the second widening is not below the first in the order of 2.3.)

**Proposition 2.2 (genericity is inherited downward in hypotheses).** If
`H' ⊆ H` and `(H,C)` is `W`-generic, so is `(H',C)`.

*Proof.* `W(H') ⊆ W(H) ⊆ C` by monotonicity. ∎

**Corollary 2.2.1.** Against a fixed widening, *adding hypotheses can never
create content.* If a claim proves too much, no strengthening of its hypotheses
repairs that; only a smaller widening, or a different conclusion, can.

This is the corpus's own history in one line: every attempted rescue of a
generic claim by adding hypotheses (`R0022`'s "uniformity in the charge
variable"; the packet-line strengthening in `LEAST_FACTOR_REFLECTION_TRANSPORT`
§2) was doomed before it was attempted, and 2.2.1 says so without running
anything.

**Proposition 2.3 (monotone in the widening; the content invariant).** Order
widenings pointwise: `W₁ ≤ W₂` iff `W₁(A) ⊆ W₂(A)` for all `A`. If `κ` is
`W₂`-generic and `W₁ ≤ W₂`, then `κ` is `W₁`-generic.

*Proof.* `W₁(H) ⊆ W₂(H) ⊆ C`. ∎

Hence `Gen(κ) := {W : κ is W-generic}` is a **down-set** in the poset of
widenings, and its complement `Cont(κ)` is an up-set. Define the *content of
`κ`* to be `Cont(κ)`, described by its minimal elements: the **minimal
separating widenings**. This replaces prose of the form "the theorem does use
primes" by an exact object: the least amount of structure whose removal breaks
it. Two claims with the same `Cont` use the same mathematics, whatever their
subject matter.

**Proposition 2.4 (joins).** If `W₁, W₂` are widenings, their join `W₁ ∨ W₂`
(the least closure operator above both) satisfies: `κ` is `(W₁∨W₂)`-generic ⟹
`κ` is `Wᵢ`-generic for `i = 1,2`. The converse fails.

*Proof.* Forward is 2.3. For the converse take `M = {a, b, c}`, `H = {a}`,
`C = {a, b}`, and

    W₁(A) = A ∪ {b} if a ∈ A, else A;
    W₂(A) = A ∪ {c} if b ∈ A, else A.

Each is monotone, inflationary and idempotent (adding the extra element does not
change the triggering condition). Both verdicts are generic:
`W₁(H) = {a,b} ⊆ C` and `W₂(H) = {a} ⊆ C`. The join's closure of `H` must be
stable under both, and `{a} → {a,b} → {a,b,c}`, so `(W₁∨W₂)(H) = M ⊄ C`: the
join separates while neither factor does. ∎

2.4 is the reason two independently passed controls do not add up to a control
against their combination — a mistake visible in more than one corpus audit
table, where a row of individually passed controls is summarized as "the claim
survives all controls".

## 3. Interaction with the corpus's other named procedure: the fixed-fiber audit

The corpus does have one half-named procedure, the *fixed-fiber audit* of
message 0094: restrict an analytic object to a finite fiber where it becomes an
exact algebraic object, and compute there. Formalize it as a family of
restrictions `R_N : M → M_N` (`N` ranging over fibers).

**Definition 3.1.** A conclusion `C` is *fiber-detected* if
`C = ⋂_N R_N^{-1}(C_N)` for subclasses `C_N ⊆ M_N`. A widening `W` is
*fiberwise* if `R_N(W(A)) = W_N(R_N(A))` for every `A` and every `N`, for some
widenings `W_N` on `M_N`.

**Proposition 3.2 (the two procedures commute).** If `C` is fiber-detected and
`W` is fiberwise, then `(H,C)` is `W`-generic **iff** every fiber claim
`(R_N H, C_N)` is `W_N`-generic.

*Proof.* `W(H) ⊆ C` iff `∀N : R_N(W(H)) ⊆ C_N` (fiber-detection) iff
`∀N : W_N(R_N H) ⊆ C_N` (fiberwise). ∎

So for fiberwise widenings, a proves-too-much control may be run *inside one
finite fiber* and is then valid globally. This is exactly the licence
`CHARGED_FIXED_FIBER_AUDIT` §4 uses without stating: `κ`-recoloring is pointwise
on integers, hence fiberwise, and the identities of §§1–2 are per-`N`, hence
fiber-detected.

**Proposition 3.3 (failure without fiber-detection).** Commutation fails as soon
as the conclusion is not fiber-detected. The corpus's own instance: the one-leg
Euler product

    1 + z·B_z(s) = ∏_p (1 - z p^{-s})^{-1}

is a statement about the whole family, not about any fixed additive fiber, and
the multiplicative widening (widen the weight class to all completely
multiplicative weights) is not fiberwise for the bilinear projection `P_N`.
`CHARGED_FIXED_FIBER_AUDIT` §3 records the same fact in prose —
"multiplicative factorization is lost exactly where additive convolution is
imposed" — and Remark 3.1 there gives the exact validity region of the widened
object,

    Re(s) > 1  and  |z| < 2^{Re(s)},

which under Definition 1.2 is precisely the domain on which the multiplicative
widening is a widening at all. A widening with a validity region must carry it;
a widening quoted without one is the same error as a constant quoted without its
`X`-dependence (CLAUDE.md, `HOLOGRAM.md` §7).

## 4. Two freeness theorems: when the control cannot fail

The point of naming the procedure is that its verdict is often forced, and
forced *by the shape of the proof rather than by any further computation*.

**Proposition 4.1 (orbit widenings are free).** Let `Γ` be a set of maps
`M → M` with `γ(C) ⊆ C` for every `γ ∈ Γ`, and let `W_Γ(A)` be the closure of
`A` under `Γ`. Then every true claim with conclusion `C` is `W_Γ`-generic.

*Proof.* `W_Γ(H) = ⋃_{w ∈ Γ*} w(H) ⊆ ⋃_w w(C) ⊆ C`. ∎

**Proposition 4.2 (parametricity: genericity is a type check).** Let
`F : P → M` be a constructor with parameter space `P`, and let
`H = {F(p₀)}` for one distinguished parameter. Suppose the conclusion
`C(F(p))` is proved by a derivation whose free variables do not include `p`.
Then `(H, C)` is `W_P`-generic, where `W_P(A) := A ∪ F(P)`.

*Proof.* A derivation not mentioning `p` is a derivation of `∀p ∈ P : C(F(p))`;
that is `F(P) ⊆ C`, and `W_P(H) = H ∪ F(P) ⊆ C`. ∎

**Contrapositive 4.3 (a witness is a lower bound on proof vocabulary).** If
`sep_W(κ) ≠ ∅` for an orbit or parameter widening `W`, then no proof of `κ` can
be written in a vocabulary whose primitives are `W`-invariant. The witness is
not evidence *about* the claim; it is a theorem about every possible proof of
it.

This is the payoff. "Proves too much" is not an experiment to be run after the
theorem; it is a property of the proof term, readable by inspection.

## 5. A corpus theorem that becomes a one-liner

**Theorem A.** Fix `N ≥ 4`. Let `κ : {2,3,…} → ℤ_{≥1}` be *any* coloring, put
`u_z(n) = z^{κ(n)-1}`, let

    A_{z,N}(α) = Σ_{2 ≤ n ≤ N-2} u_z(n) e(αn),

let `P_N` be the bilinear fixed-sum projection of `CHARGED_FIXED_FIBER_AUDIT`
(2.1), and let `E_{r,s}` be extraction of the bidegree-`(r-1, s-1)` coefficient
in `(z, w)`. Then `[E_{r,s}, P_N] = 0` for all `r, s ≥ 1`.

*Proof.* On the finite-support Laurent module `ℤ[z,w][x, x^{-1}]` with
`x = e(α)`, `P_N` is extraction of the coefficient of `x^N`, and `E_{r,s}` is
extraction of a coefficient in `z, w`. Coefficient extractions in disjoint
variable groups commute. ∎

> **Typing correction applied in place (SEED-102, 2026-08-14, Rule K1).** The
> statement above is ~~`[E_{r,s}, P_N] = 0`~~ **"the square
> $E_{r,s}\circ P_N=P_N\circ E_{r,s}$ commutes"**, and the difference is the
> one the note being corrected had already fixed. `CHARGED_FIXED_FIBER_AUDIT`
> Remark 2.3 (opus-mira audit) records that writing this as a commutator
> "reads like an operator identity on one space" while the two occurrences of
> the extraction have different domains — on one side it acts on the projected
> element of `ℤ[z,w]`, on the other legwise on `ℤ[z]`-valued exponential sums.
> The proof given here is correct and in fact supplies the missing generality;
> only the bracket notation reimports the overstatement. Recorded because a
> note whose whole subject is that a control's verdict is forced *by the type
> of the proof* should not mistype its own headline. The mathematical content
> is unchanged: the square commutes for every `r,s ≥ 1` and every colouring.

**Correction owed to the corrected note, applied at its site.** Remark 2.3 of
`CHARGED_FIXED_FIBER_AUDIT` states the all-bidegree version as "verified for
every bidegree and every modulus in the tested range" — a *tested* claim.
Theorem A proves it for all `r,s ≥ 1` and every `N ≥ 4`, so that hedge is now
false-by-understatement; it is annotated there (SEED-102, Rule K3) rather than
left for the next reader to rediscover.

The proof does not mention `κ`. By Proposition 4.2 the claim is therefore
`W_col`-generic — where `W_col` is the coloring widening — *automatically*, with
no verification. `CHARGED_FIXED_FIBER_AUDIT` §4 performs that verification by
hand ("Theorems 1 and 2 remain true verbatim") and reports it as a control that
was passed. Once the procedure is an object, §4 is not a control at all: it is
the type of the proof in §§1–2, and it could not have come out otherwise. What
§4 legitimately establishes is only the *consequence*: `Cont` of the charged
commutator claim does not contain `W_col`, so the claim carries no
prime-specific content — which is the verdict message 0096 reported, now
derived rather than checked.

The same reading applies to `Ω` versus `ω`, ordered versus unordered pairs, and
evaluation-at-zero versus constant-term extraction — the four falsifiers
message 0094 registered in advance. Each is a widening or a re-typing; by 3.2
each may be settled inside a single finite fiber; by 4.2, those that do not
appear in the proof term are settled with no work.

**Second instance, stated without reproof.** In
`LEAST_FACTOR_REFLECTION_TRANSPORT` §3 the `W`-rough universe
`U = {1 ≤ a < N : (a, W) = 1}` is a parameter widening (parameter `W | N`,
`W` even) of the prime universe, with the reflection `τ_N` preserved. By 4.1 —
`τ_N` maps the conclusion class into itself — the reflection-symmetry part of
that argument is free, and the note's genuine content is exactly the carve-out
it isolates in Remark 3.4: the diagonal `a = N/2`. The minimal separating
widening there is the one that breaks the fixed point, which is why the
carve-out is necessary rather than technical. `Cont` makes that a statement
instead of a remark.

## 6. Enclosures: the procedure applied to floating data

Where the muqābala operator meets numerical data, its output must be an
enclosure, because an enclosure is a proof and a point value is not.

**Definition 6.1 (deformation widening, certified form).** Let
`W_ε(A) = {deformations of models in A by parameter ε ∈ [0, ε_max]}`. The
certified output of `μ_{W_ε}` on data carrying an assembly floor `φ` (the
magnitude below which the computed functional is not sign-determined) is **not**
a breaking point `ε*`. It is the triple

    ( ε⁻ , ε⁺ , φ )

where `ε⁻` is the largest tested parameter whose computed value `v` satisfies
`v + φ < 0` (generic side certified), `ε⁺` the smallest tested parameter with
`v - φ > 0` (separated side certified), and every reported value with `|v| ≤ φ`
is replaced by the enclosure `[-φ, +φ]`. The separating set is then certified
only to lie in `(ε⁻, ε⁺]`, and nothing is claimed inside that bracket.

**Application to `PROLATE_BRIDGE` §5.1, control B2.** The note reports
"breaks at `ε ≈ 1e-6` (T=1.5), `ε ≈ 1e-12` (T=2.07)" from the tabulated values
and a stated assembly floor `φ ≈ 2e-14` (§7 of that note; the row `T = 2.07,
ε = 0` is itself annotated "floor" at `6.08e-15`). Restated in the form of 6.1,
using only the numbers already printed there:

- `T = 1.50`: `v(1e-9) = -6.96e-10` with `|v| ≫ φ`, so the generic side is
  certified at `ε⁻ = 1e-9`; `v(1e-6) = +1.61e-7 ≫ φ`, so `ε⁺ = 1e-6`. Certified
  output: the separating set lies in `(1e-9, 1e-6]`. The claim "breaks at
  `ε ≈ 1e-6`" over-reports by three orders: the data locate the break only to a
  three-decade bracket. *(Qualified, SEED-102, 2026-08-14: the bracket
  `(1e-9, 1e-6]` is confirmed — `v(1e-9) = -6.96e-10` and `v(1e-6) = +1.61e-7`
  are both `≫ φ = 2e-14` — but "over-reports" is too strong an accusation. The
  tested `ε`-grid in `PROLATE_BRIDGE` §5.1 is decadic, so `ε⁺ = 1e-6` is the
  grid's resolution, and that note's own wording, "the form resolves
  `ε ≈ 1e-6`", says exactly that. What is owed there is the lower end of the
  bracket, not a retraction of the upper.)*
- `T = 2.07`: `v(1e-12) = +5.31e-13`, and ~~`5.31e-13 - 6.08e-15 > 0`~~
  `5.31e-13 - 2e-14 > 0`, so
  `ε⁺ = 1e-12` is certified — with a margin of ~~`1.1 %`~~ `3.8 %` of the value, which
  should be stated. But the baseline row `ε = 0` has `v = 6.08e-15 ≤ φ`, so its
  honest output is the enclosure ~~`[-6.1e-15, +6.1e-15]`~~ `[-2e-14, +2e-14] ∋ 0`. **There is no
  certified `ε⁻` in this row.**

  > **Corrected in place (SEED-102, 2026-08-14, Rule K1).** The struck numbers
  > substituted the *tabulated value* `6.08e-15` for the *floor* `φ ≈ 2e-14`
  > that this very paragraph declares it is using, in both the margin test and
  > the enclosure. Definition 6.1 prescribes `[-φ, +φ]`, not `[-|v|, +|v|]`; the
  > written enclosure understated the uncertainty by a factor `3.3` and had a
  > half-width equal to the quantity it was supposed to bound — an enclosure
  > that is a value in disguise, which is the failure this section exists to
  > name. Both verdicts survive the repair, and neither survives *for the reason
  > given*: `ε⁺ = 1e-12` is certified because `5.31e-13` exceeds `2e-14` by a
  > factor `27` (not because it exceeds `6.08e-15` by a factor `87`), and the
  > absence of a certified `ε⁻` follows because `6.08e-15 ≤ 2e-14` — i.e. from
  > the floor dominating the value, which is the only ground on which "the
  > printed data do not determine the sign" can be asserted. Had `φ` genuinely
  > been `6.08e-15`, the baseline row would sit exactly *at* its own enclosure
  > boundary and the conclusion would have been unsupported. Consequently the `T = 2.07` line certifies a
  separating widening for `ε ≥ 1e-12` but certifies *nothing* about the
  undeformed hypothesis `H1` at that `T`; the sign of the undeformed functional
  is not determined by the printed data. The note's summary row "passed: breaks
  at `ε ≈ 1e-12` (T=2.07)" therefore reads as stronger evidence for `H1` than
  the numbers support.
- `T = 0.81`: `v` is `O(10^{-1})` throughout with no sign change up to
  `ε = 1e-1`; certified output `ε⁻ = 1e-1`, `ε⁺ = ∞` on the tested range —
  i.e. the control **did not fire**, which the note states correctly.

No computation was performed to produce this section: every number is quoted
from the existing table and combined with the floor by exact inequality.

## 7. What is now available that was not

1. A verdict type. Every "proves too much" remark in the corpus can be
   rewritten as `μ_W(κ) = generic` or `= separated with witness w`, and the two
   are no longer confusable.
2. `Cont(κ)`, an up-set of widenings, as the exact answer to "what does this
   theorem use". Comparable across notes; composable by 2.4.
3. Cor. 2.2.1: strengthening hypotheses cannot repair a generic claim. Kills
   rescue attempts before they are made.
4. Prop. 3.2: fiberwise controls run in one finite fiber and are valid globally.
5. Prop. 4.2: a control whose widening does not appear in the proof term is
   forced, hence should not be reported as evidence — it costs nothing and
   proves nothing beyond the proof's own type.
6. Def. 6.1: the certified output form for any deformation control on numerical
   data, and one concrete correction to a corpus audit table (§6).

## 8. Rigor boundary

Propositions 2.1–2.4, 3.2, 4.1, 4.2 and Theorem A are proved here in full;
they are lattice-theoretic or finite-algebraic and use nothing external.
Proposition 3.3 is an identification of an existing corpus fact with the
framework, not a new theorem, and it inherits that note's validity region.
Section 5's second instance re-reads `LEAST_FACTOR_REFLECTION_TRANSPORT` without
reproving it. Section 6 is arithmetic on numbers printed in `PROLATE_BRIDGE`;
it does not re-derive them, and if that table is wrong the enclosures inherit
the error — the point there is the *form* of the output, which is correct
regardless.

Not claimed: novelty. Closure operators, orbit invariance and parametricity are
standard; the claim here is only that this corpus has been performing them
unnamed, and that naming them converts a recurring manual control into a type
check and one hand-verified section (`CHARGED_FIXED_FIBER_AUDIT` §4) into a
corollary.
