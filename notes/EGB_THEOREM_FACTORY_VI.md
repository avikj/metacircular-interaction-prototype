# Eternal Golden Braid — Theorem Factory VI

The diagonal endpoint theorem, uniform proof families, and the absolute
factor-defect law

Date: 2026-08-14. Status: exact elementary/standard theorems, conditional
compilers under explicitly stated uniformity hypotheses, sharpened research
targets. No proof of Goldbach or twin primes claimed; no novelty claim before
ancestry search.

**Landing note (cf-indra).** Received upstream; landed as a faithful
structured compression preserving every theorem statement exactly (the
session transcript holds the verbatim original; grounding artifacts named in
it — Delta 23, EGB Reconstruction v0.1, Factories IV/V, the
Divisor-Lefschetz and split-torus theorem files — are NOT all in notes/:
`SEARCH` item, same as ~~Deltas 26/27~~ **[FALSE — cf-indra, 2026-08-16: Deltas 26 and 27 ARE in notes/ as DEPENDENT_SYSTEM_OPTIMIZATION.md and DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_27.md. I asserted their absence without looking, made it a SEARCH item, and asked upstream to resend files already present. The error is the session's own failure mode: a conclusion drawn from not reading.]**). Formalization of the integer-exact
core (T96, T97, C97.1, T100, T101 — all ℕ-arithmetic, no logs needed in the
forms below) is the queued next PROVE; T102's diagonal needs only the
integer forms plus the threshold hypothesis. Type contact: T110 is a genuine
kill of a strategy class (cooling alone), the same genre as the corpus's
PROOF_MASS/L3 no-gos; the quantifier tear T101 is the sharpest statement in
the factory and costs three lines to certify.

## 0. What the factory corrects

The program's test: can one finite generative construction produce the
unbounded prime-pair witness field? The recent factories localized the exact
prime branch to the unit boundary a = 1 of completed P₂ factor states
x = (n; a, b), n = ab, 1 ≤ a ≤ b, b prime, a = 1 or prime. Danger: one can
improve fixed factor-share exponents a ≤ b^ε, ε ↓ 0, forever without forcing
a = 1, because the arithmetic scale moves while the approximation improves.
Coordinates: D(x) = log a (absolute unit defect), S(x) = log n (scale),
σ = D/S (normalized defect). Discrete gap: nonunit ⟹ D ≥ g∗ = log m∗
(m∗ = 2 unrestricted, 3 for odd legs).

## The theorems

**T96 (discrete-boundary resolution law).** For D : X → {0} ∪ [g,∞),
S > 0, δ = D/S: D(x) = 0 ⟺ δ(x) < g/S(x). Specialization: a = 1 ⟺
σ(n) < log m∗ / log n. Boundary resolution shrinks like 1/log n; the
boundary is discrete in D, not in σ.

**T97 (exponent/share equivalence).** a ≤ b^ε ⟺ σ(n) ≤ ε/(1+ε); in
particular a ≤ b^{1/m} ⟺ σ ≤ 1/(m+1). [Integer-exact form for the kernel:
a^m ≤ b ⟺ a^{m+1} ≤ n, since n = ab.]

**C97.1 (finite endpoint criterion).** If a ≤ b^{1/m} and
m > log b / log m∗ then a = 1. (b^{1/m} < m∗ forces a < m∗.)

**T98 (fixed-parameter and finite-family no-go).** For every fixed ε > 0,
and for every finite family m₁,…,m_k, there are arbitrarily large nonunit
states satisfying all the inequalities (take a = m∗, b ≥ m∗^{max m_j}).
No finite list of fixed-exponent near-prime theorems forces primality.

**T99 (vanishing σ need not approach the unit).** Sequences exist with
σ → 0 and D ≡ log m∗ (fixed), and with σ → 0 while D → ∞. Progress metrics
must control (σ, S) jointly — equivalently D = σS.

**T100 (fixed-object endpoint compactness).** E finite; if for every m some
x_m ∈ E has a ≤ b^{1/m}, then E contains a unit state. (Pigeonhole on the
finite set; b^{1/m} → 1.)
**C100.1:** fixed even N with Chen representations N = p + ab for every m at
share 1/m ⟹ N has an exact Goldbach representation.
**C100.2:** fixed prime p, same hypothesis for p+2 ⟹ p+2 prime.

**T101 (moving-scale countermodel — the quantifier tear).** E_m =
{(m∗b; m∗, b) : b prime ≥ m∗^m} is nonunit, cofinal in scale, and satisfies
a ≤ b^{1/m}. Hence ∀m ∃x_m (cofinal near-boundary) does NOT imply ∃ unit;
∃x ∀m does. **Factor-share limit and arithmetic-scale limit do not
commute.** This is the exact tear left by every sequence of fixed-parameter
near-prime theorems.

**T102 (diagonal endpoint theorem).** Given a uniform near-boundary family
(∀m ≥ m₀, ∀X ≥ X_m: a witness with a ≤ b^{1/m}, b ≤ KX^α), if

  limsup_m (log X_m)/m < (log m∗)/α

then every sufficiently large scale has a unit witness a = 1. Proof: pick
c < d < log m∗/α with X_m ≤ e^{cm} eventually; set m(X) = ⌈log X / d⌉; then
X_{m(X)} < X (applicability) and (log K + α log X)/m(X) < log m∗, so
a < m∗ ⟹ a = 1.
**C102.1 (Goldbach compiler):** family N = p + ab, a ≤ b^{1/m} above N_m;
limsup (log N_m)/m < log 2 ⟹ every large even N is a sum of two primes
(odd-leg version: threshold log 3).
**C102.2 (twin compiler):** dyadic family for p+2 = ab with odd a;
limsup (log X_m)/m < log 3 ⟹ twins in every large dyadic interval, hence
infinitely many twins.

**T103 (critical rate sharp).** At X_m = m∗^{m/α}, states a = m∗, b = m∗^m
satisfy a = b^{1/m} exactly, forever nonunit: the strict subcritical
inequality in T102 cannot be weakened from the factor inequality and scale
bound alone.

**T104 (uniform proof-family compiler).** One finite algorithm producing,
for each m, a certified theorem + threshold certificate X_m ≤ Ce^{cm} with
αc < log m∗, yields one finite algorithm producing exact unit witnesses at
every large scale: one finite construction → infinitely many exact certified
witnesses. The theorem family's generator and threshold modulus are the
finite higher object.

**T105 (scale-defect product law).** σ′ ≤ κσ and S′ ≤ CS ⟹ D′ ≤ κC·D.
The effective contraction is κC, not κ.
**C105.1:** κC < 1 + discrete gap ⟹ unit boundary in
k > log(D₀/g∗)/(−log κC) steps — O(log log n₀) reflective descent.
**T106 (κC < 1 sharp):** with κC ≥ 1 there are trajectories with geometric
σ-improvement and D ≡ g∗ forever (scale expansion absorbs the gain).

**T107 (critical-temperature extraction).** If nonunits have a ≥ cX^δ and
|E_X| ≤ CX/(log X)^η, then Z_β(X) − U_X ∈ [0, Cc^{−β}X^{1−δβ}/(log X)^η];
at β_c = 1/δ, Z_{β_c} = U_X + O((log X)^{−η}), so ⌊Z_{β_c}⌋ = U_X for large
X. **C107.1:** for the rough dyadic Chen set (a ≫ X^{3/11}, count ≪ X/log X):
Z_{11/3}(X) = T_X + O(1/log X); Z_{11/3} ≥ 1 ⟺ a twin in (X/2, X] —
improving Factory V's β = 4 to the critical 11/3.

**T108 (phase bounds under unit failure).** With U_X = 0 and
cX^δ ≤ a ≤ CX^{1/2}: |E_X|C^{−β}X^{−β/2} ≤ Z_β ≤ |E_X|c^{−β}X^{−δβ};
for |E_X| ≍ X/log²X, every β < 2 admits Z_β → ∞ with no units, while
β = 1/δ gives Z_β ≪ 1/log²X. Positivity at small β is not twin-specific.

**T109 (cooling cumulants).** −∂_β log Z_β = E_β[D]; ∂²_β log Z_β =
Var_β(D) ≥ 0; expected absolute defect decreases along cooling. A cooling
proof must show the flow cannot sustain D ≥ g∗ through the decoding
temperature.

**T110 (insufficiency — strategy kill).** For 0 < δ < 1/2 there is an
abstract unitless family with count ≍ X/log²X, roughness a ≍ X^δ, completely
monotone Z_β, large Chen-scale mass, and Z_{1/δ} → 0. Therefore count +
roughness + positivity + complete monotonicity + convexity DO NOT imply twin
nonvanishing. A successful cooling proof must import genuine arithmetic
dependence (p vs (a,b) correlation, small-factor distribution, quadratic
surface geometry, Liouville cancellation, factor descent, or chart
transfer). This kills the seductive pure-cooling strategy.

**Θ_diag (the diagonal higher object).** Components: completed factor field;
unit boundary (a = 1 / s−t = 1); discrete gap m∗; theorem-strength index
type; per-m proof terms; thresholds X_m; certified subcritical growth law;
diagonal selector m(X) = ⌈log X/d⌉; endpoint proof; center/radius chart
coherence. **T111:** Goldbach-form and twin-form diagonal structures map
canonically onto the witness-generator types (apply C102.1/C102.2
pointwise). **T112 (certified installation):** installing DiagonalEndpoint
as a named transformation preserves semantics, weakly decreases proof
distance, strictly when invocation beats rederivation, and retypes the
endpoint task as two obligations: construct a uniform family; prove
subcritical threshold growth. **C112.1:** the research policy "optimize the
best fixed exponent indefinitely" is DEAD; the replacement metric is
γ = limsup (log X_m)/m against log m∗ — γ < log 3: twin-compiles;
γ < log 2: Goldbach-compiles; γ = log m∗: critical, nonunit persistence
compatible; γ > log m∗: the countermodel outruns theorem strength.

## Immediate attacks (§VIII, faithfully)

A. Uniformize the near-prime parameter m across sieve weights, Buchstab
decompositions, switching ranges, distribution hypotheses, error constants,
positivity margins — one proof generator for all m. B. Measure γ for every
generated family; γ is the research metric, not the best exponent. C. Seek
an absolute-contraction transition κC < 1. D. Attack Z_{11/3} ≥ 1 for the
rough Chen field — with the T110-mandated arithmetic input identified
explicitly. E. Use the quadratic defect surface (s−t, s+t, s²−t²−2 all
prime under twin failure) to source a uniform family / contraction / critical
lower bound / contradiction. F. One uniform family on the master field whose
center projection meets the Goldbach law and radius-one projection the twin
law.

## Rigor boundary

T96–T110 are exact elementary/standard mathematics as stated (finite
pigeonhole, log algebra, geometric sums, Gibbs identities); T102/104 are
CONDITIONAL compilers — their hypotheses (uniform families with subcritical
threshold growth) are open arithmetic, and the factory says so. T111/T112
are type-level packaging of T102. Nothing here proves Goldbach or twins;
what it proves is which research policies CANNOT reach them (T98, T101,
T106, T110) and the exact interface any successful family must satisfy (γ
subcritical). PROVE seeds: kernel module for the integer-exact core
(T96/97/100/101, three of which are three-liners); SEARCH: ancestry for the
diagonal-family shape (Chen/Ross switching literature; effective prime
gaps), and the missing grounding artifacts.
