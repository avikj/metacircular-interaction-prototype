# The finite LP certificate and the negativity landscape

Companion to `code/exp25_lp.py` (figure `figures/exp25_lp.png`). This note
executes the computational half of JEWELS §1 (the Cohn–Elkies/Viazovska LP
reading of Weil positivity) under the retarget of ATIYAH §4 item 2: the
object hunted is a **Hodge-index negativity**, not a naive positivity. It
(i) formulates the finite LP, (ii) derives the exact sign-structure statement
the primitive block must satisfy — and shows the naive version of the
question ("is W negative on primitives?") has a trivial answer, locating the
nontrivial statement in a zero-free *arithmetic intersection form*,
(iii) reports the measured spectra, (iv) quantifies the cost of each prime
power against the archimedean budget, (v) gives the interpolation-basis
conditioning verdict, and (vi) places all of it against Connes–Consani
(arXiv:2006.13771) and Connes–Consani–Moscovici (arXiv:2310.18423).

**Headlines.** (1) The naive primitive question is trivial: W|_P is PSD
under RH termwise. The nontrivial object is the zero-free *arithmetic
intersection form* I = prime − arch = pole − W, for which we derive and then
measure the exact Hodge-index statements: I ≤ 0 on the primitive subspace
(⟺ RH there), and at most ONE positive direction on any finite test space —
the pole plane is a null-diagonal hyperbolic plane, F₁²=F₂²=0, F₁·F₂=1,
and Castelnuovo's Z·Z ≤ 2d₁d₂ is verbatim I(g) ≤ 2Re[Φ_g(0)Φ̄_g(1)].
(2) Measured: inertia of I is (1, ·, rest) in every resolved dictionary; the
primitive top eigenvalue of the assembled zero-free form matches the
factored zero side to all digits where resolved (−1.718e−8 both ways).
(3) The primitive block is O(1)-definite in the prime-free Connes–Consani
window (λ_min/λ_max = 0.19, vs 6.9e−4 unconstrained); each of the first
prime powers then costs 3–7 orders of magnitude, and *deleting any single
prime power ≥ 3 from the arithmetic makes the primitive block indefinite* —
every prime is individually load-bearing. (4) Interpolation by direct
collocation on generic spans is numerically infeasible beyond ~15–20 knots
(cond 1e16 by K = 24): a certificate needs the prolate/Sonin-adapted basis,
which is exactly the Connes–Consani route.

Normalization throughout is that of `notes/WEIL.md` Prop W1 (verified there
to 1.8e−10): for admissible g on u = log x, Φ_g(s) = ∫ g(u) e^{(s−1/2)u} du,
F = g⋆g̃, and

$$W(g)=\sum_\rho\Phi_F(\rho)
=\underbrace{2\operatorname{Re}\bigl[\Phi_g(0)\overline{\Phi_g(1)}\bigr]}_{\text{pole}(g)}
-\underbrace{\sum_{n\ge2}\tfrac{\Lambda(n)}{\sqrt n}2\operatorname{Re}F(\log n)}_{\text{prime}(g)}
+\underbrace{\tfrac1{2\pi}\int|\Phi_g(\tfrac12+i\tau)|^2 D(\tau)\,d\tau}_{\text{arch}(g)},$$

D(τ) = Re ψ(¼+iτ/2) − log π. RH ⟺ W(g) ≥ 0 for all g (Weil).

---

## 1. Formulation: the finite Cohn–Elkies LP

Fix a dictionary g_1,…,g_N of test functions. The Weil form restricted to
span{g_j} is the Hermitian matrix

$$M_{jk}=W(g_j,g_k)=\sum_\rho \Phi_{g_k}(\rho)\overline{\Phi_{g_j}(1-\bar\rho)},$$

computed **two independent ways**: (zero side) directly over the first
100,000 Odlyzko zeros in factored form M = B^H B, B_{mj} = Φ_j(½+iγ_m)
(under RH the omitted tail is itself PSD, so the truncation is a certified
lower bound); (assembly) as pole − prime + arch from Λ(n) to 10^7
(665,134 prime powers), the closed-form pole matrix, and the archimedean
quadrature at step h = 0.02. The entrywise agreement of the two computations
is the exp14 explicit-formula verification promoted to matrix level; measured
below. The generalized eigenproblem M c = λ G c with Gram matrix
G_{jk} = ⟨g_j, g_k⟩ gives λ = W(g)/‖g‖² — dictionary-redundancy-free — and
λ_min is the hardest direction of the finite LP. Numerically λ_min is
extracted from the factored zero side as σ_min(B·G^{−1/2})², trustworthy down
to ~10^{−26}·λ_max, far below the ~10^{−16}·‖M‖ floor of the assembled
symmetric eigenproblem (this matters: the interesting eigenvalues are
doubly-exponentially small).

Two dictionaries:
- **(A) Gaussian atoms** g(u) = e^{−(u−a)²/2σ²}e^{iβu}, the exp14 families:
  5 centers × 4 modulations (0, mid-gap, γ_1, γ_2) × 3 widths σ ∈
  {0.1, 0.25, 0.5} plus 4 wide atoms σ ∈ {0.75, 1, 1.25, 1.5} — 64 atoms,
  all matrix entries in closed form.
- **(B) Compact support-capped basis**: C¹ cosine-difference modes
  h_m(v) = ½[cos(q_{m−1}v) − cos(q_{m+1}v)] on [−T/2, T/2] (30 modes), so
  F = g⋆g̃ is supported in [−T, T] and the prime sum is *finite and exact*:
  only prime powers with log n < T enter. Sweeping T through the thresholds
  log 2, log 3, log 4, … isolates the cost of each prime power.

## 2. The derived sign structure (state first, then measure)

**The primitive subspace.** P = {g : Φ_g(0) = Φ_g(1) = 0} — the joint kernel
of the two pole functionals. These two functionals span the analog of the
Néron–Severi hyperbolic plane of C×C (ATIYAH §2): indeed the pole form
2Re[Φ_g(0)Φ̄_g(1)] contains **no Φ(0)² or Φ(1)² diagonal terms** — it is the
rank-2 Hermitian form x ȳ + y x̄ on the pair (Φ(0), Φ(1)), i.e. precisely a
hyperbolic plane with two null generators: F₁² = F₂² = 0, F₁·F₂ = 1.

**Proposition LP1 (the naive primitive question is trivial).** On P the pole
form vanishes identically, so W|_P = arch|_P − prime|_P; and under RH
W(g) = Σ_γ |Φ_g(½+iγ)|² termwise, so **W restricted to P is positive
semidefinite for trivial reasons** — restriction cannot change the sign of a
sum of squares. The answer to "is W|_P negative semidefinite?" is *no*;
under RH it is PSD everywhere, and the Hodge-index negativity must be looked
for in a different form. ∎

**Definition (arithmetic intersection form).** 

$$I(g)\;:=\;\text{prime}(g)-\text{arch}(g)\;=\;\text{pole}(g)-W(g).$$

I is **zero-free data**: it is assembled entirely from Λ(n) and the
Γ-factor — no zeros, no pole term. It is the number-field analog of the
intersection form Z·Z of a correspondence on C×C, and the two identities
above are the analogs of the adjunction between Z·Z, the bidegrees
(d₁,d₂) = (Φ(0), Φ(1)), and the Lefschetz trace.

**Proposition LP2 (Hodge index / Castelnuovo for the Weil form).**

1. **(H1, primitive negativity.)** Under RH, I|_P ≤ 0: for g ∈ P,
   I(g) = −W(g) = −Σ_γ|Φ_g(½+iγ)|². Explicitly, zero-free:
   $$\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}\,2\operatorname{Re}F(\log n)
   \;\le\;\frac1{2\pi}\int_{\mathbb R}|\Phi_g(\tfrac12+i\tau)|^2D(\tau)\,d\tau
   \qquad\forall\,g\ \text{with}\ \Phi_g(0)=\Phi_g(1)=0:$$
   *once the two pole moments are removed, the archimedean place dominates
   the sum of all finite places.*
2. **(H2, index bound.)** Under RH, on every finite-dimensional test space
   the Hermitian form I has **at most one positive eigenvalue**: the pole
   form has Hermitian signature (1,1) (rank-2 hyperbolic, |Re⟨a,b⟩| ≤ |a||b|),
   and I = pole − W ≼ pole with W PSD, so λ₂(I) ≤ λ₂(pole) ≤ 0 (Weyl
   monotonicity). Equivalently, Castelnuovo's inequality holds verbatim:
   $$I(g)\;\le\;2\operatorname{Re}\bigl[\Phi_g(0)\overline{\Phi_g(1)}\bigr]
   \;=\;\text{“}Z\cdot Z\le 2\,d_1d_2\text{”}.$$
3. **(Converse.)** H1 for all g ∈ C_c^∞ ∩ P implies RH. This is Weil's
   criterion restricted to the pole-annihilated class, the form in which the
   criterion is used throughout the trace-formula literature (Connes,
   Selecta Math. 5 (1999); the Connes–Consani test class of 2006.13771 is
   exactly this class with a support condition); the classical violating
   family from an off-line zero admits a two-parameter correction restoring
   the two linear constraints at lower order. We use this equivalence as
   cited, not re-proved here.

*Proof of 1, 2:* displayed. ∎

So the empirical Hodge-index question, correctly posed, is: **does the
measured I = prime − arch have exactly the inertia (1, rest ≤ 0), and does
its primitive block hold at ≤ 0 with margin −λ_min(W|_P)?** The rest of this
note measures that.

Remark (what would make this a certificate program): H1 is an inequality
between two zero-free quadratic forms. A *proof* of H1 on any class of g
(without using zeros) is a theorem toward RH on that class — this is
literally what Connes–Consani achieved for supp F ⊂ (1/2, 2), where
prime ≡ 0 and H1 degenerates to arch|_P ≥ 0 (§6 below). Enlarging the
support past log 2 makes H1 a genuine prime-vs-archimedean budget
inequality; the per-prime cost table of §4 is the empirical shape of that
budget.

## 3. Measured spectra

All numbers from the `code/exp25_lp.py` run of 2026-08-11; the script
reproduces them end-to-end in ~6 minutes (`python3 code/exp25_lp.py`).

**Cross-check (task target ≤ 1e−6).** Worst entrywise relative deviation
between the zero-side and assembled computations of M: **3.3e−9** over the
Gaussian dictionaries (64×64 complex), **9.6e−7** over all 128 support caps
of the compact scan (the worst caps are the smallest supports, where the
entries themselves are ~1e−6 of the matrix scale and the residual is the
quantified archimedean far-tail; self-check points: 3.1e−9 at T=1.0, 1.2e−9
at T=2.4). Diagonal single-atom values agree with exp14's closed forms to
2e−16…8e−16, and translation-invariance of all four terms holds to 7e−15.
Three real bugs in the first (never-executed) draft of exp25 were caught by
exactly this cross-check and fixed: a sesquilinear-convention mismatch that
conjugated every imaginary part of the assembled matrices against the
zero side, a prime-sum window centered at the signed rather than absolute
center separation (which silently halved Hermitian off-diagonal entries for
center-separated pairs — found as an exact factor 2 at atom pair
(a=∓0.75, σ=0.15, β=γ₁)), and an archimedean τ-truncation whose ~4e−10
absolute tail broke the small-support entries.

**Hodge index of I = prime − arch (part P).** Inertia (n₊, n₀, n₋) at
relative tolerance 1e−8, with the primitive block P = ker Φ(0) ∩ ker Φ(1):

| dictionary | dim | inertia(I) | λ₁(I) | λ₂(I) | inertia(I&#124;_P) | top of I&#124;_P (assembled) | −λ_min(W&#124;_P) (zero side, exact) |
|---|---|---|---|---|---|---|---|
| σ≤0.1 (20 narrow atoms) | 20 | **(1, 1, 18)** | +6.05 | −1.7e−8 | **(0, 1, 17)** | **−1.718e−8** | **−1.718e−8** ✓ |
| σ≤0.25 (40 atoms) | 40 | (1, 18, 21) | +12.0 | +6.3e−13 | (0, 18, 20) | +6.3e−13 (floor) | −2.7e−33 |
| σ≤0.5 (60 atoms) | 60 | (3, 33, 24) | +30.8 | +3.2e−5 | (2, 33, 23) | +3.2e−5 (ghost) | −3.9e−32 |
| +wide atoms (64) | 64 | (3, 38, 23) | +199.3 | +4.4e−5 | (3, 34, 25) | +4.4e−5 (ghost) | −5.0e−32 |

Reading: **H2 and H1 hold exactly as derived.** In the well-conditioned
narrow dictionary everything is resolved *above* the numerical floor: exactly
one positive direction, and the primitive top eigenvalue of the assembled
zero-free form agrees with the factored zero side to all printed digits
(−1.718e−8 both ways) — the arithmetic-plus-archimedean data alone "knows"
the primitive negativity. In the wide-atom spans the Gram matrix is
near-singular and the whitening amplifies the ~1e−9 assembly tails into
ghost positives at the 1e−6·λ₁ level (λ₂/λ₁ ≤ 1.0e−6 everywhere); on
conditioning-robust subspaces (whitening cut 1e−6, dims 52–53 of 60–64) the
inertia returns to **n₊(I) = 1 in every dictionary with λ₂/λ₁ ≤ 1e−13 and
n₊(I|_P) = 0** — the ghosts are pure conditioning artifacts. **In no dictionary does a second
resolved hyperbolic direction appear**, and the factored zero side pins the
true primitive top eigenvalues at −5e−32…−1.7e−8: negative, as H1 demands.
The unique positive eigenvector of I overlaps the pole plane at 0.999–1.000 —
it *is* the hyperbolic direction, the "ample class" of the arithmetic
surface.

**Pole form inertia**: (1, r−2, 1) in every dictionary — the hyperbolic
plane, measured. The pole form vanishes on P to 5.2e−16 (max leak over the
whole compact scan) — the constraint machinery is exact.

**The hardest direction (BCK landscape).** On the narrow dictionary the LP
minimizer reaches λ_min = W/‖g‖² = 3.14e−10 (vs 0.107 for the best single
atom: the dictionary goes nine orders deeper), with 82.5% of its Fourier
mass inside the spectral gap (0, γ₁) and effective width 1.31 synthesized
out of σ = 0.1 atoms — the finite-LP optimizer *rediscovers* exp14's verdict
that the extremal window is wide, low-frequency, and gap-concentrated, and
it beats the single-Gaussian uncertainty tradeoff by paying the prime terms.
For the wider dictionaries λ_min falls below the factored-SVD trust floor
(~1e−26·λ_max ≈ 4e−32); the single-atom continuation (exact log-space
evaluation) reaches λ ~ 1e−194 at σ = 1.5, exp14's doubly-exponential
collapse.

## 4. Per-prime-power cost

Support-capped compact basis (M = 30 modes; λ values at fixed M carry ~10%
truncation bias in the resolved regime — M=22/30/38 spread measured — and
are M-dependent upper bounds in the collapse regime; the *locations* of the
drops and all fixed-M comparisons are the robust content).

**The primitive block against the support cap** (figure panel h; this is the
negativity margin of I|_P = −W|_P as arithmetic enters):

| regime | λ_min(W&#124;_P) | comment |
|---|---|---|
| T < log 2 (prime-free, **the Connes–Consani window**) | **0.59–1.42** with λ_min/λ_max = 0.19 | comfortable O(1) definiteness: W&#124;_P = arch&#124;_P, the finite shadow of CC's Sonin-space positivity; contrast the *unconstrained* λ_min = 2.1e−3 (μ = 0.001) at the same cap — the thin directions of the full form live in the pole plane, not in P |
| after 2 (T = 0.81) | 2.5e−1 | prime 2 costs a factor ~2.4 |
| after 3 (T = 1.22) | 8.4e−5 | ×3.0e−3 |
| after 4 (T = 1.50) | 1.1e−9 | ×1.3e−5 |
| after 5 (T = 1.73) | 1.4e−14 | ×1.3e−5 |
| after 7 (T = 2.07) | 4.4e−21 | ×3.2e−7 |
| after 8, 9, 11, … | 3.5e−23 → 1e−30 | reaches the factored-SVD floor by T ≈ 2.7 |

So the certificate obstruction has a sharply quantified shape: **each of the
first few prime powers costs 3–7 orders of magnitude of primitive
definiteness**, the heaviest single blows being 3 (×3e−3) and 4 = 2²
entering at T = 2 log 2 (×1.3e−5), after which the margin is doubly-
exponentially thin but (as far as the trusted range reaches) never zero.
This is the spectral face of what 2310.18423 handles operator-theoretically
as "stability of the semilocal Sonin space under the increase of the finite
set of places."

**Leave-one-prime-out: every prime power is individually load-bearing.**
Deleting the term of a single prime power n from the assembled form (keeping
all others) at cap T = log n + 0.12:

- n = 2: λ_min(W|_P without 2) = **+0.416** (> full 0.25): at this cap
  removing 2 leaves the prime-free form — definite, as it must be.
- n = 3 at T = 1.22: **−3.9e−2** — *indefinite*. n = 4: −3.7e−2. n = 5:
  −1.1e−1. n = 7: −1.5e−1. n = 8: −6.3e−2 … every later prime power tested
  (through 27) gives λ_min < 0 when deleted.

That is: with support past log 3, the Weil form is **not a monotone budget**
— the prime terms are oscillatory, finely tuned corrections, and removing
any single one breaks positivity in the *other* direction (the remaining
primes overshoot the pole + archimedean budget). Weil positivity at cap T is
a property of the exact multiset {Λ(n) : n ≤ e^T} — a certificate must know
every prime power individually, not merely bound their aggregate. (Rayleigh
weights of the deleted term at the minimizer grow from 11.8 at n = 2 to
~1e14 by n = 11: the minimizer rides an extreme cancellation.)

## 5. Interpolation feasibility (Radchenko–Viazovska indicator)

Conditioning of the row-normalized evaluation functionals on the 60-atom
Gaussian span (whitened dimension 60): zero knots g ↦ Φ_g(½+iγ_k), prime
knots g ↦ g(log p^k):

| K | cond (zero knots) | cond (prime knots, 24 knots < e⁴) |
|---|---|---|
| 5 | 5.2 | 1.1 |
| 10 | 2.0e2 | 1.4 |
| 15 | 9.1e3 | 3.5e4 |
| 20 | 2.6e8 | 4.2e11 |
| 24 | 2.6e16 | 1.8e16 |
| 30 | 1.2e17 | — |

Joint RV-type system (30 zero + 24 prime functionals on dim 60):
cond = 2.7e17, σ_min = 1.3e−17. **Verdict: infeasible by direct dictionary
collocation beyond K ≈ 15–20 knots** — both knot families go numerically
degenerate at double precision by K ≈ 24, the prime knots faster than the
zero knots (log p^k clusters faster than γ_k: knot spacing shrinks like
1/n vs the ~2π/log γ zero spacing). A Radchenko–Viazovska-style certificate
for the zeta kernel therefore cannot be bootstrapped from generic Gaussian
spans; it needs a basis biorthogonal-by-construction to the knots — which
is precisely the role the prolate spheroidal/Sonin eigenbasis plays in
2006.13771/2310.18423, and the right next experiment is collocation in
*that* basis rather than a larger dictionary.

## 6. Comparison with Connes–Consani and the prolate program

**Connes–Consani, "Weil positivity and Trace formula, the archimedean
place", arXiv:2006.13771 (Selecta Math. 27 (2021)).** Abstract (fetched
2026-08-11): *"We provide a potential conceptual reason for the positivity
of the Weil functional using the Hilbert space framework of the semi-local
trace formula … We explore in great details the simplest case of the single
archimedean place. The root of the positivity is the trace of the scaling
action compressed onto the orthogonal complement of the range of the cutoff
projections associated to the cutoff in phase space, for cutoff parameter
equal to 1. We express the difference between the Weil distribution and the
Sonin trace … in terms of prolate spheroidal wave functions, and use as a
key device the theory of hermitian Toeplitz matrices to control the
difference. All the ingredients and tools used above make sense in the
general semi-local case, where Weil positivity implies RH."* Their theorem
lives exactly on our primitive block: test functions supported in
[2^{−1/2}, 2^{1/2}] with ĝ vanishing at 0 and i/2 — i.e. supp F ⊂ (1/2, 2)
(no prime contributes) and g ∈ P. In that regime H1 reads arch|_P ≥ 0, and
our measured λ_min(arch|_P) (panel h) is the finite-dimensional shadow of
their Sonin-space positivity.

**Connes–Consani–Moscovici, "Zeta zeros and prolate wave operators",
arXiv:2310.18423 (Ann. Funct. Anal. 15 (2024)).** Abstract (fetched
2026-08-11): *"We integrate in the framework of the semilocal trace formula
two recent discoveries on the spectral realization of the zeros of the
Riemann zeta function by introducing a semilocal analogue of the prolate
wave operator. The latter plays a key role both in the spectral realization
of the low lying zeros of zeta — using the positive part of its spectrum —
and of their ultraviolet behavior — using the Sonin space which corresponds
to the negative part of the spectrum. … We prove the stability of the
semilocal Sonin space under the increase of the finite set of places which
govern the semilocal framework …"* The semilocal extension (adding the
places 2, 3, …) is precisely the T > log 2 region of our panel (h): their
"stability of Sonin space as places are added" is the operator-theoretic
face of what our per-prime cost table measures spectrally.

**Quantitative placement of our measurements against the two papers.**
(i) CC 2021 prove W ≥ 0 on {g ∈ P, supp F ⊂ (1/2, 2)} — *all* such g. Our
panel-h measurement gives the finite-dimensional spectral gap of that
theorem's form: λ_min(arch|_P)/λ_max ≈ 0.19 on the 28-dimensional primitive
compact-basis slice at T = 0.68 — the definiteness is not marginal but O(1),
consistent with their trace-formula proof having room (their Sonin-space
compression has strictly positive trace). (ii) Their proof strategy
(compression + prolate functions + Toeplitz control) is exactly what our §5
conditioning verdict says is *necessary*: generic spans cannot see the
knots. (iii) The semilocal program of 2310.18423 (places added one at a
time, Sonin space stable) predicts that primitive definiteness persists as
each prime enters but does not quantify the margin; our §4 table is that
quantification on the finite slice: ×3e−3 at the place 3, ×1.3e−5 at 4,
saturating the double-precision floor by T ≈ 2.7. The leave-one-out
indefiniteness (§4) sharpens the qualitative statement "each new place must
be absorbed" (WEIL.md §7) into: each place, once inside the support, is
individually indispensable — the semilocal trace formula cannot drop or
majorize any single Euler factor.

## 7. Honest limitations

- Everything here is finite-dimensional and RH-verified-data-driven on the
  zero side; nothing is a theorem toward RH. The theorems of §2 are
  elementary consequences of the explicit formula; their value is that they
  pose the *right* finite question (inertia of I, not definiteness of W).
- The factored zero side certifies lower bounds only up to the zero-data
  truncation (tail PSD ⇒ safe) and accuracy (3e−9 per zero).
- The compact basis has algebraic (1/τ²) Fourier decay; statements about
  "support exactly [−T, T]" are exact, but M = 30 modes is a finite slice
  of each cap space (M-convergence measured in the run log).
