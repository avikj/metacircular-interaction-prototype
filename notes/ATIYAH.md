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
  concluded the "Lorentzian" structure is inert. The function-field column
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
| Goldbach-type | open (blocks located) | theorem (Ingham) | theorem-grade (Effinger–Hayes for polynomials) |
| twin primes / Chowla | open (charge layer) | theorem (shifted divisor) | **THEOREM (Sawin–Shusterman, q large): the parity barrier FALLS** |
| pair correlation | conjecture (Montgomery; our exp17 data) | theorem (Motohashi spectrum) | theorem (Katz–Sarnak equidistribution; Keating–Rudnick variance) |
| mechanism | ? | GL(2) trace formula | geometry: Frobenius, monodromy, vanishing cycles |

The third column is the decisive one Atiyah's lens adds: **every wall this
program has mapped — positivity certificate, parity barrier, pair
correlation — is a proven theorem over function fields, and each proof runs
through geometry the number field lacks: the pair surface, monodromy groups,
vanishing-cycle sheaves (Sawin–Shusterman's route through the parity
barrier).** The barrier is not logical necessity; it is the absence of a
cohomology theory. That is simultaneously sobering (we cannot conjure étale
cohomology for Spec Z tonight) and precise: the program's ultimate question
is not "is there a trick" but "what is the minimal cohomological structure
whose existence over Z reproduces the three proofs" — the standard-conjectures
question, localized by our block decomposition to: *which sector of the pair
field must carry the primitive-negativity axiom.*

→ spawned: the function-field pair field, computed exactly (exp26/FF.md) —
polynomial Goldbach vs its singular series with NO zero corrections (genus 0:
the control case where the zero block is empty), and the Sawin–Shusterman
anatomy of how the charge layer dies when geometry is available.

## 4. What transfers tonight

1. exp14's margin map re-labeled as primitive-direction cartography (done
   here, conceptually; a numerical primitive-projection experiment is the
   natural exp27).
2. The LP/certificate program (fleet-lp) now has its geometric target
   named: it is hunting a Hodge-index negativity, not a Weil positivity —
   the objective's sign structure should be built accordingly.
3. The parity program (WIDTH, GAUGE) gains the Sawin–Shusterman datum: the
   charge layer is killable *in principle* — by monodromy, not by sieves —
   sharpening "what extra input breaks parity" from rhetoric to a literature
   with a mechanism.
