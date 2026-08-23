# The Atiyah lens: autopsy, index theory, and the pair surface where RH is a theorem

Adopting Atiyah's viewpoint means three things done honestly: an autopsy of
the 2018 attempt (mining, not mocking), the index-theoretic reading his life's
work actually licenses, and the discovery that this program has been
empirically studying the number-field shadow of an object — the *pair
surface* — on which RH was proven eighty years ago.

## 1. Autopsy of the 2018 claim

Atiyah's argument required a "Todd function" T: weakly analytic, equal to a
polynomial on every compact convex set, T(1)=1, composed against ζ to force a
contradiction at a hypothetical off-line zero. The failure is structural: a
function analytic on a domain and locally polynomial is globally a single
polynomial (identity theorem), and the claimed properties are jointly
inconsistent; the companion derivation of the fine-structure constant has no
salvageable mathematical content. What *is* worth salvaging is the shape of
the wish: an analytic gadget with polynomial-grade rigidity that transfers
operator-algebraic structure (he invoked von Neumann's hyperfinite II₁
factor) into the critical strip. In this corpus's language: he wanted a
**certificate object** — precisely the role Viazovska's magic functions play
in the sphere-packing LP (JEWELS §1) and the role a Kreĭn/screw certificate
plays in SCREW/PRODUCT. The wish was sound; the construction was not.

## 2. The index-theoretic reading (Atiyah–Singer / Atiyah–Bott, applied for real)

Atiyah's deepest reflex: analytic quantities are indices; traces localize on
fixed points. The explicit formula *is* of this shape — Weil framed it as a
Lefschetz fixed-point formula, with primes as periodic orbits and zeros as
eigenvalues of a missing operator; our Landau resolvent experiment (exp5a:
Σcos(γ log x) localizing at prime powers to 3 decimals) is the empirical
Atiyah–Bott localization of that missing trace formula. In the one setting
where the operator exists — function fields — this is not an analogy but the
proof, and it runs through a *pair object*:

**Weil's proof of RH for a curve C/F_q lives on the surface C×C.** The
mechanism, item by item, is our pair field in geometric clothing:

| C × C (Weil 1940s) | prime pair field (this repo) |
|---|---|
| the two rulings F₁, F₂ (fibers of the projections), with F₁²=F₂²=0, F₁·F₂=1 — a hyperbolic plane in Néron–Severi | the null coordinates u = w−d, v = w+d of S²−D²=4Q — the "Lorentzian" identity of REPORT §1 |
| the diagonal Δ | the zero-gap ray d = 0 |
| graph of Frobenius and its powers | the multiplicative dilation flow (BC dynamics) |
| correspondences (divisor classes on the square) | shift/convolution operators; the marginals' functionals |
| Lefschetz: Δ · Γ_{Frobⁿ} counts fixed points | explicit formula: prime counts from the spectrum |
| **Hodge index theorem: the intersection form is negative semi-definite on the primitive part (orthogonal complement of the hyperbolic plane)** (Castelnuovo's inequality) | **the missing positivity: exactly the certificate our Prop W3 shows the naive |P|² cannot supply** |
| conclusion: Frobenius eigenvalues have |α| = √q — RH for C | conclusion (unavailable): zeros on the line |

Two corollaries for this corpus:

- **Lemma 1.3's deflation was correct and is now completed by its own
  geometry.** We proved the integral Lorentz group of S²−D² is trivial and
  concluded the "Lorentzian" structure is inert.
  <!-- Correction by addition, 2026-08-15 (claude, Hoare lineage;
  notes/LEAN_STATEMENT_AUDIT.md): read "the *orientation-preserving* integral
  Lorentz group … is {±I}". The checked term
  Pairfield.so11_int_eq_pm_one carries the hypothesis `det M = 1`; without it
  the group is O(1,1)(ℤ) = {±I, ±diag(1,−1)}, of order four. "Trivial" is also
  loose for a group of order two — the intended and correct reading is
  "carries no boost dynamics". The corollary drawn here is unaffected. -->
 The function-field column
  explains *why it had to be*: the hyperbolic plane spanned by the rulings is
  the trivial part of the Néron–Severi lattice on any such surface. The
  arithmetic content of RH never lived in the hyperbolic plane — it lives in
  the **negativity of the primitive part orthogonal to it**. Translated: not
  in S²−D²=4Q, but in the sign structure of the fluctuation sectors
  orthogonal to the main terms — which is exactly where our block
  decomposition, W3 obstruction, and margin cartography have been operating.
  exp14's thin-margin map is, in this reading, *empirical Hodge theory of
  the arithmetic surface*: the near-null primitive directions.
- **The direction of the inequality finally makes sense.** W3 found that
  prime-side Hermitian positivity bounds the Weil form from *above* — the
  "wrong way" for RH. Castelnuovo's certificate is also an upper bound
  (a negativity on primitives forcing |eigenvalues| ≤ √q from above and
  below via the hyperbolic projection). The missing number-field axiom is a
  Hodge-index-type **negativity**, not a naive positivity — this is
  Grothendieck's standard-conjecture frame (RH-analog from the Hodge
  standard conjecture), and its modern number-field pursuit is exactly
  Connes–Consani's arithmetic site / "square of Spec Z" program. Our pair
  field N×N with its S/D marginals is the elementary shadow of that sought
  square — which is why the program kept working: we have been computing on
  the shadow of the right object.

## 3. The solvability triptych (calibration, final form)

Three columns, one structure; each open problem's fate under each:

| statement | number field (ours) | divisor model (DIVISOR.md) | function field F_q[t] / curves |
|---|---|---|---|
| RH | open | THEOREM (spectral gap λ₁>1/4) | THEOREM (Weil, via pair surface) |
| Goldbach-type | open (blocks located) | theorem (Ingham) | model-dependent: Sawin–Shusterman Remark 1.2 (binary method); Bender–Pollack (binary, large $q$ relative to degree); Effinger–Hayes is ternary |
| twin primes / Chowla | open (charge layer) | theorem (shifted divisor) | **THEOREM (Sawin–Shusterman, q large): the parity barrier FALLS** |
| pair correlation | conjecture (Montgomery; our exp17 data) | theorem (Motohashi spectrum) | theorem (Katz–Sarnak equidistribution; Keating–Rudnick variance) |
| mechanism | ? | GL(2) trace formula | geometry: Frobenius, monodromy, vanishing cycles |

The third column is the decisive calibration, but the earlier version of this
table compressed several different assertions into "solved over function
fields."  `FF.md` separates them.  On the degree-$n$ shell of
$\mathbf F_q[T]$, the genus-zero zeta identity fixes only the trivial additive
Fourier mode.  The sum and gap marginals have exact holomorphic/Hermitian
spectra and equal fourth-moment fluctuation energy, and that energy is
strictly positive for every $n\ge2$ even though the base zeta has no numerator
zeros.  Sawin–Shusterman's theorem controls the nontrivial fixed-gap modes
with a power saving for sufficiently large fixed $q$.  It does so through
Möbius/character identities, level of distribution beyond $1/2$, and
vanishing-cycle control of auxiliary sheaf cohomology — not by reading zeros
off the zeta function of the affine line.

The place at infinity also cannot be suppressed.  Reflection identifies a
fixed gap exactly with a Goldbach sum whose two degree-$n$ primes have
opposite leading coefficients, so their leading terms cancel.  It does not
by itself identify the gap theorem with the conventional polynomial
Goldbach normalization using degree-$n$ and degree-$(n-1)$ monic summands.
Sawin–Shusterman explicitly say their method also establishes a Goldbach
analogue, but any use of that assertion must state the leading-coefficient,
degree, target-uniformity, and weighting conventions.  Effinger–Hayes is a
three-primes result, not evidence for the binary fixed-field cell.

The corrected lesson is stronger than "geometry solves everything."  The
parity wall is not a logical necessity, but Deligne's weight bound alone is
also not enough: in a family whose dimension grows, one still needs the hard
vanishing and Betti-number estimates that expose a power saving.  The
function-field model therefore locates the missing structure more precisely:
it belongs to auxiliary cohomology carrying the nontrivial pair modes, not to
the hyperbolic identity or the base one-body zeta spectrum.

→ completed: `FF.md` — the exact shell pair theorem, a quantitative
fourth-moment obstruction to "zero-free base implies no pair correction,"
the infinity-type reflection theorem, the Sawin–Shusterman fixed-gap
asymptotic placed inside it, and a strict boundary around binary Goldbach
normalizations.

## 4. What transfers tonight

1. exp14's margin map re-labeled as primitive-direction cartography (done
   here, conceptually; a numerical primitive-projection experiment is the
   natural exp27).
2. The LP/certificate program (fleet-lp) now has its geometric target
   named: it is hunting a Hodge-index negativity, not a Weil positivity —
   the objective's sign structure should be built accordingly.
3. The parity program (WIDTH, GAUGE) gains the Sawin–Shusterman datum: the
   charge layer is killable *in principle*, but by a composite mechanism — a
   derivative/Pellet conversion of Möbius signs to characters, analytic
   distribution beyond level $1/2$, and geometric vanishing/complexity
   bounds.  "By monodromy, not by sieves" was too coarse: both the analytic
   decomposition and the auxiliary cohomology are essential.
