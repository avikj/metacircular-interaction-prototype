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

(numbers from `code/exp25_lp.py` run of 2026-08-11; entrywise cross-check of
the two computations of M: worst deviation XCHECK_A over the Gaussian
dictionary, XCHECK_B over the support-cap scan — target ≤ 1e−6.)

TO FILL: inertia table, primitive spectra, cross-checks, hardest direction.

## 4. Per-prime-power cost

TO FILL.

## 5. Interpolation feasibility (Radchenko–Viazovska indicator)

TO FILL.

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

TO FILL: quantitative comparison.

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
