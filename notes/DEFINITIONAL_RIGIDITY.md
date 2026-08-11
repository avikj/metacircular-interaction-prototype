# Definitional rigidity: when a consequence-web pins a definition

fleet-fidelity, 2026-08-11. Executes FIDELITY.md's content program (a)+(b):
Theorem A′ of the prime-set corpus transplanted to formal vocabularies.
Registry packet R0018; verification code/exp54_definitional_rigidity.py
(12/12 exact checks, data/exp54_out.txt); mathlib-suite retrofit in §5.

**Forecast** (registered 2026-08-11T23:02:42Z, before derivation, scratchpad
`forecast.txt` quoted in R0018's seed event): outcome (1) — both (a) and (b)
exist and are elementary at web size O(10); predicted mechanism
monotone-product extremality; credence 0.8. Outcome: (1) CONFIRMED, and
sharper than forecast — the pinning web has size **2** and needs **no
functional equation**; the extremality mechanism is exactly as predicted but
holds in the full complex unit-disk class, not only the real interval.

## 0. Frame

A *definition space* is a set 𝒟 of candidate meanings; a *consequence-web*
W is a finite set of checkable statements (each a function 𝒟 → {pass, fail}
or 𝒟 → value). W is **rigid** on 𝒟 if the joint pass/value constraint has a
unique solution up to the canonical identification of 𝒟 (for coefficient
sequences, literal equality — the 0-truncated case of the univalent contract
in CONTENT_ADDRESSED_MATHEMATICAL_IDENTITY.md). W is **homometric** on 𝒟 if
two inequivalent meanings share all of W's observations — one shadow, two
objects, the fidelity failure mode of FIDELITY.md.

Here 𝒟 ranges over Dirichlet-series meanings of a `riemannZeta`-class symbol:
sequences a : ℕ → ℂ with a(1) = 1, D_a(s) = Σ a(n) n^{−s}.

## 1. Theorem R (rigidity: a web of size 2 pins riemannZeta)

**Class** 𝒞 = { a completely multiplicative, |a(p)| ≤ 1 for every prime p }.
(Complete multiplicativity is the "Euler product fragment" of the web: it is
the axiom that D_a factors as ∏_p (1 − a(p) p^{−s})^{−1} for Re s > 1.)

**Web** W_R = { W_E : a ∈ 𝒞 (Euler fragment) ; W_V : D_a(2) = π²/6 }.

**Theorem R.** W_R is rigid on 𝒞: its only solution is a ≡ 1, i.e.
D_a = ζ. No functional equation is needed.

*Proof.* For a ∈ 𝒞, |a(n)| ≤ 1 for all n (complete multiplicativity), so
D_a(2) converges absolutely and the Euler factorization
D_a(2) = ∏_p (1 − a(p)/p²)^{−1} is valid, the product converging absolutely.
For |z| ≤ 1, |1 − z/p²| ≥ 1 − |z|/p² ≥ 1 − 1/p², and the chain is an
equality iff z/p² is real nonnegative with |z| = 1, i.e. iff z = 1. Hence

  |D_a(2)| = ∏_p |1 − a(p)/p²|^{−1} ≤ ∏_p (1 − 1/p²)^{−1} = ζ(2) = π²/6,

with equality iff a(p) = 1 for every p (an absolutely convergent product of
factors each ≤ its maximum equals the product of maxima only termwise-at-max;
all factors are nonzero since |1 − a(p)/p²| ≥ 1 − 1/p² > 0). W_V demands the
extremal value, so a(p) = 1 for all p and a ≡ 1 by complete
multiplicativity. ∎

**Abstract transplant (Theorem A′ shape).** Let 𝒟 = ∏_i K_i with K_i ⊂ ℂ
compact, 1 ∈ K_i, and let the web contain one functional F(a) = ∏_i f_i(a_i)
(absolutely convergent, factors bounded away from 0) with |f_i(z)| ≤ f_i(1)
for z ∈ K_i, equality iff z = 1, together with the demand F(a) = ∏_i f_i(1).
Then the web is rigid. One *extremal aggregate consequence anchors every
coordinate simultaneously* — the same mechanism by which the singleton parity
class anchors a whole prime prefix in PARITY_RIGIDITY.md. This is the
transplanted Theorem A′: rigidity comes not from many constraints but from
one constraint evaluated at its extremal point.

**Known counterpart (cited, not reproved).** Hamburger's theorem (1921):
a Dirichlet series with suitable regularity/growth satisfying ζ's exact
functional equation ξ(s) = ξ(1−s) is c·ζ(s). So the *analytic* side alone
(functional equation + regularity, no Euler fragment) also pins ζ up to
scalar; Theorem R is the *multiplicative-side* pole (Euler fragment + one
special value, no analytic continuation at all). The two theorems bracket
the catalog below: delete either side's load-bearing axiom and homometry
appears.

Numeric anchor (exp54): strict extremality margin on the unit-circle grid;
planted-false control C1: the unit-modulus impostor a(2) = e^{0.3i} misses
the web value by 2.9·10⁻² — the detector fires.

## 2. Homometric counterexample catalog (thin webs, two meanings, all exact)

**H1 — special values without the Euler fragment.** The web
{D(2) = π²/6, D(4) = π⁴/90} on unrestricted Dirichlet series is homometric:
let P(s) = 5 − 128·2^{−s} + 243·3^{−s}. Then P(2) = 5 − 32 + 27 = 0 and
P(4) = 5 − 8 + 3 = 0 exactly (exp54, rational arithmetic), so ζ and ζ + P
are inequivalent meanings sharing the web. General principle: any finite
special-value web {s₁,…,s_k} has a nonzero Dirichlet polynomial in its
kernel (k linear conditions on k+1 coefficients), so special values alone
NEVER pin — each checked value only cuts one dimension from an
infinite-dimensional impostor space. Fidelity moral: a suite made only of
`riemannZeta_two`-style checks has measure-zero pinning power without a
structural axiom.

**H2 — Euler fragment without boundedness.** Drop |a(p)| ≤ 1. Two-prime
exact witness: over the universe {2,3}, (a(2),a(3)) = (1,1) and (0,3) give
(1 − 1/4)^{−1}(1 − 1/9)^{−1} = 3/2 = (1 − 0)^{−1}(1 − 3/9)^{−1}. Both are
restrictions of genuine completely multiplicative functions; the meanings
are inequivalent, the web value identical (exp54, exact rationals). Control
C2: restoring the boundedness axiom kills the impostor (|3| > 1) — the
web-thickening that Theorem R prescribes is exactly the missing axiom.

**H3 — functional-equation shape without conductor.** The thin web
{completely multiplicative, a(p) ∈ {−1,0,1}, ∃ Q, δ : Q^{s/2}Γ((s+δ)/2)D(s)
invariant under s ↦ 1−s} is satisfied both by ζ (Q = π^{-1}... standard
completed zeta, δ = 0) and by L(s, χ) for any even real primitive Dirichlet
character χ (e.g. the Legendre symbol mod 5), by the classical functional
equation of Dirichlet L-functions (known, standard; e.g. Davenport,
*Multiplicative Number Theory*, ch. 9). Existentially quantifying the
conductor — leaving one slot of the consequence schematic — reopens a
homometric family that Hamburger's *exact* equation excludes. Fidelity
moral: a functional-equation check pins only if the gamma-factor data is
pinned vocabulary, not an existential.

**H4 — the paradigm case (pure homometry, finite and minimal).** Exhaustive
search (exp54): within diameter ≤ 17 there is NO homometric multiset pair of
sizes 3–5, and at size 6 the pair {0,1,2,6,8,11} vs {0,1,6,7,9,11} shares
the full difference multiset {1,1,2,2,3,4,5,5,6,6,7,8,9,10,11} while being
inequivalent under translation and reflection. (Homometric pairs are
classical — Patterson's crystallographic examples; the specific minimal-in-
range witness here is machine-verified.) This is the charter's base case:
the "web" of all pairwise differences — an entire quadratic observable
family — still admits two meanings. Webs fail by *structure*, not by count.

## 3. What the catalog teaches (the yield, stated as design rules)

1. Value checks are one-dimensional cuts; structural axioms (Euler fragment,
   exact functional equation, boundedness/positivity) are what collapse the
   impostor space from infinite dimension to a point. A fidelity suite needs
   at least one structural member or it certifies nothing (H1).
2. Every structural axiom earns its place: each of {complete
   multiplicativity, boundedness, exact-Γ-data} has an explicit impostor
   that appears the moment it is dropped (H2, H3).
3. Rigidity can be *cheap*: one extremal aggregate value + the structure it
   is extremal over suffices (Theorem R, web size 2). Suites should hunt for
   extremal consequences — they are worth many generic ones.
4. Even large observable families can be homometric if they are all of one
   algebraic type (H4: all differences = all degree-2 monomial data). Suites
   should mix types (values + equations + degenerations), which is exactly
   FIDELITY.md's suite recipe.

## 4. Scope fences

- Theorem R pins within 𝒞 only; it says nothing about non-multiplicative
  impostors (H1 lives there) — rigidity is always class-relative, as
  homometry is always observable-relative (ECOLOGY §univalent trust
  correction).
- "Up to canonical iso" here is literal coefficient equality; for richer
  definition spaces (formal texts) the right identity is the witnessed
  equivalence of CONTENT_ADDRESSED_MATHEMATICAL_IDENTITY.md, and Theorem R's
  conclusion transports along it.
- H3's witness relies on the classical L-function functional equation, cited
  as known, not reproved here.
- exp54's grid check of the extremality lemma is illustrative; the lemma's
  proof is the two-line inequality chain above, not the grid.

## 5. Retrofit: the checked-consequence web already pinning riemannZeta in mathlib

Sources: mathlib4 docs read this session (Mathlib/NumberTheory/LSeries/
RiemannZeta.html, LSeries/HurwitzZetaValues.html, EulerProduct/
DirichletLSeries.html, ZetaValues.html); zeta-23 comparator layer as audited
in KAPPA.md §5.6 (`comparator/ChallengeDeps.lean` defines IsNontrivialZero
via mathlib's `riemannZeta`).

Canonical consequence classes (FIDELITY metric) and mathlib's coverage:

| # | class | mathlib witnesses | covered |
|---|-------|-------------------|---------|
| 1 | series representation (round-trip to the naive meaning) | `zeta_eq_tsum_one_div_nat_cpow`, `zeta_nat_eq_tsum_of_gt_one` | yes |
| 2 | Euler product | `riemannZeta_eulerProduct_hasProd` / `_tprod` / `_exp_log` | yes |
| 3 | functional equation / duality | `riemannZeta_one_sub` | yes |
| 4 | special values, positive even | `riemannZeta_two` (π²/6), `riemannZeta_four` (π⁴/90), `riemannZeta_two_mul_nat` (Bernoulli) | yes |
| 5 | degenerate/negative values + trivial zeros | `riemannZeta_zero` (−1/2), `riemannZeta_neg_nat_eq_bernoulli`, `riemannZeta_neg_two_mul_nat_add_one` | yes |
| 6 | pole/residue normalization | `riemannZeta_residue_one` | yes |
| 7 | analytic class | `differentiableAt_riemannZeta`, `analyticOn_riemannZeta` | yes |
| 8 | second-formalization agreement | none — single definition; zeta-23's `ChallengeDeps.lean` *reuses* mathlib's `riemannZeta`, so the comparator inherits rather than cross-checks the definition | no |

**Density: 7/8.** By Theorem R, classes {2, 4-restricted-to-one-value} alone
already pin ζ within the bounded completely-multiplicative class, and
Hamburger pins via class 3 + analyticity — mathlib's web is rigid with
large redundancy margin (good: redundancy is what makes single-lemma bugs
detectable). The one open cell is exactly the forecast's predicted gap:
no independent second formalization anywhere in the stack; every downstream
consumer (including the zeta-23 record, per KAPPA) rides one definition.
H1–H3 name which subwebs would go homometric if the structural lemmas were
ever weakened to existentials or dropped in a refactor. Concrete retrofit
recommendation for our own `formal/pairfield` suites: every definition ships
at least one *structural* consequence (class 2/3-type) and one *extremal*
value (Theorem R-type), not value checks alone.
