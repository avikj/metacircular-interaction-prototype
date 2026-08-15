# The finite LP experiment and the negativity landscape

Companion to `code/exp25_lp.py` (figure `figures/exp25_lp.png`). This note
executes the computational half of JEWELS §1 (the Cohn–Elkies/Viazovska LP
reading of Weil positivity) under the retarget of ATIYAH §4 item 2: the
object hunted is a **Hodge-index negativity**, not a naive positivity. It
(i) formulates the finite LP, (ii) derives the exact sign-structure statement
the primitive block must satisfy — and shows the naive version of the
question ("is W negative on primitives?") has a trivial answer, locating the
nontrivial statement in a zero-free *arithmetic intersection form*,
(iii) reports the measured spectra, (iv) quantifies the cost of each tested
prime-power atom against the archimedean budget, (v) gives the interpolation-basis
conditioning verdict, and (vi) places all of it against Connes–Consani
(arXiv:2006.13771) and Connes–Consani–Moscovici (arXiv:2310.18423).

**Headlines.** (1) The naive primitive question is trivial: W|_P is PSD
under RH termwise. The nontrivial object is the zero-free *arithmetic
intersection form* I = prime − arch = pole − W. Exactly, I ≤ 0 on the
primitive subspace is equivalent to RH when required on the full admissible
test class, and RH implies at most one positive direction on any finite test
space. The two moment coordinates carry a null-diagonal hyperbolic form,
F₁²=F₂²=0, F₁·F₂=1; ~~the inequality
I(g) ≤ 2Re[Φ_g(0)Φ̄_g(1)] is a stronger form inequality that implies the
index bound.~~ the inequality I(g) ≤ 2Re[Φ_g(0)Φ̄_g(1)] is **literally
`W ⪰ 0` in intersection-theoretic vocabulary** — see the correction at LP2.2,
where the same overstatement was struck (SEED-38 §2.2, applied by SEED-101). Its resemblance to Castelnuovo's Z·Z ≤ 2d₁d₂ is established
prior-art-guided interpretation, not a new geometric theorem.
(2) Conditioned numerical evidence: inertia of I is (1, ·, rest) in every
resolved subspace; in the well-conditioned narrow dictionary the primitive
top eigenvalue of the assembled zero-free form matches the finite-zero
factored estimate to printed precision (−1.718e−8 both ways).
(3) The primitive block is O(1)-definite in a prime-free window at the
Connes–Consani support scale (~~λ_min/λ_max = 0.19, vs 6.9e−4
unconstrained~~ — struck: that ratio is `O(1/log M)` at fixed `M = 30`, see the
correction in §4);
each of the first prime-power atoms then costs 3–7 orders of magnitude, and
deleting any single tested atom n = p^k ≥ 3 makes the computed primitive
block indefinite. This is a conditioned finite-dimensional observation,
not a statement that an Euler factor or finite place is load-bearing. (4)
Interpolation by direct collocation on the tested Gaussian spans is
numerically unreliable beyond ~15–20 knots
(cond 1e16 by K = 24): this points toward testing a
prolate/Sonin-adapted basis, following the Connes–Consani route.

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
  (conditional on RH and exact zero ordinates, the omitted tail is PSD, so
  an exact finite truncation would be a lower bound; the actual computation
  is additionally subject to zero-data and floating-point error); (assembly)
  as pole − prime + arch from Λ(n) to 10^7
(665,134 prime powers), the closed-form pole matrix, and the archimedean
quadrature at step h = 0.02. The entrywise agreement of the two computations
is the exp14 explicit-formula verification promoted to matrix level; measured
below. The generalized eigenproblem M c = λ G c with Gram matrix
G_{jk} = ⟨g_j, g_k⟩ gives λ = W(g)/‖g‖² — dictionary-redundancy-free — and
λ_min is the hardest direction of the finite LP. Numerically λ_min is
extracted from the factored zero side as σ_min(B·G^{−1/2})². This
factorization is numerically better behaved than the assembled symmetric
eigenproblem, but values near the reported SVD floor are diagnostics rather
than certified eigenvalue bounds.

Two dictionaries:
- **(A) Gaussian atoms** g(u) = e^{−(u−a)²/2σ²}e^{iβu}, the exp14 families:
  5 centers × 4 modulations (0, mid-gap, γ_1, γ_2) × 3 widths σ ∈
  {0.1, 0.25, 0.5} plus 4 wide atoms σ ∈ {0.75, 1, 1.25, 1.5} — 64 atoms,
  all matrix entries in closed form.
- **(B) Compact support-capped exploratory basis**: C¹ cosine-difference modes
  h_m(v) = ½[cos(q_{m−1}v) − cos(q_{m+1}v)] on [−T/2, T/2] (30 modes), so
  F = g⋆g̃ is supported in [−T, T]; therefore the reduction of the prime sum to
  prime powers with log n < T is exact (the implementation still evaluates
  the resulting sum in floating arithmetic). Sweeping T through the thresholds
  log 2, log 3, log 4, … isolates the measured cost of each prime-power
  atom. These zero-extended C¹ modes are below the C² admissibility used in
  Prop W1; theorem-level use requires smoothing or an approximation/
  distributional extension argument.

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
   the Hermitian form I has **at most one positive eigenvalue**. On the
   two-dimensional moment space `(Phi(0), Phi(1))`, the pole form has
   matrix `[[0,1],[1,0]]` and inertia `(1,0,1)`. Its pullback to a test
   space has positive and negative indices at most one; full inertia
   `(1, dim-2, 1)` requires the moment map to have rank two. Since
   I = pole − W ≼ pole under RH, λ₂(I) ≤ λ₂(pole) ≤ 0 by Weyl
   monotonicity. ~~More strongly, the following form inequality holds:~~
   **Equivalently — not more strongly — the same hypothesis reads:**
   $$I(g)\;\le\;2\operatorname{Re}\bigl[\Phi_g(0)\overline{\Phi_g(1)}\bigr]
   \;=\;\text{“}Z\cdot Z\le 2\,d_1d_2\text{”}.$$

   > **Correction (SEED-38 §2.2, applied at the site by SEED-101,
   > 2026-08-14).** By this note's own normalization in §0,
   > `2Re[Φ_g(0)Φ̄_g(1)] = pole(g)`, and by the Definition in §2,
   > `I = pole − W`. So the displayed inequality is `pole(g) − W(g) ≤ pole(g)`,
   > i.e. `W(g) ≥ 0`: it is Weil's criterion, the hypothesis assumed one
   > sentence earlier and the input to the index bound, restated in
   > intersection-theoretic vocabulary. It is not stronger than the index
   > bound and carries no arithmetic content beyond `W ⪰ 0` — under ¬RH it is
   > false. The transcription is a change of vocabulary, not of hypothesis,
   > which is what §6's prior-art paragraph already says
   > (Connes–Consani–Marcolli, Def. 7.1 / Prop. 7.2); "more strongly" invited
   > the reader to import it back as strength.
3. **(Converse.)** H1 for all g ∈ C_c^∞ ∩ P implies RH. This is Weil's
   criterion restricted to the pole-annihilated class. Precisely, put
   `k(x)=x^{-1/2}g(log x)`. Then the Mellin transform used by
   Connes–Consani is
   $$\widetilde k(s)=\int_0^\infty k(x)x^{s-1}\,dx=\Phi_g(s),$$
   and the Mellin transform of `k * \bar k^\sharp` is
   `Phi_g(s) overline{Phi_g(1-conj(s))}`. Their Appendix C, Proposition
   C.1, applied with the finite vanishing set `{0,1}`, is therefore exactly
   H1 on P and proves the converse. The required constrained violating
   family is supplied by their finite Mellin-interpolation and tail-control
   argument; no informal "lower-order correction" is assumed here.

*Proof of 1, 2:* displayed. ∎

So the empirical Hodge-index question, correctly posed, is: **is the
conditioned numerical I = prime − arch consistent with inertia having at
most one positive direction, and is its primitive block nonpositive with
estimated margin −λ_min(W|_P)?** The rest of this note measures that; the
exact result is the RH-conditional implication above.

Remark (what would make this a certificate program): H1 is an inequality
between two zero-free quadratic forms. A *proof* of H1 on any class of g
(without using zeros) is a theorem toward RH on that class — this is
closely related to Connes–Consani's archimedean support-restricted
positivity, where prime ≡ 0. Their main theorem uses one pole-side Fourier
zero together with an additional central zero and is not literally the
whole of P in this note's normalization; Appendix C is the exact source for
the P-converse (§6 below). Enlarging the
support past log 2 makes H1 a genuine prime-vs-archimedean budget
inequality; the per-prime-power-atom table of §4 is the empirical shape of that
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

The independent rerun also found that the factored and assembled minimum
eigenvalues differed by as much as `4.5e-1` on the 36 points selected above
the assembly floor. Accordingly, the entrywise residual and the single
narrow-dictionary agreement must not be promoted to an
all-resolved-spectrum agreement.

**Hodge index of I = prime − arch (part P).** Inertia (n₊, n₀, n₋) at
relative tolerance 1e−8, with the primitive block P = ker Φ(0) ∩ ker Φ(1):

| dictionary | dim | inertia(I) | λ₁(I) | λ₂(I) | inertia(I&#124;_P) | top of I&#124;_P (assembled) | −λ_min(W&#124;_P) (finite-zero estimate) |
|---|---|---|---|---|---|---|---|
| σ≤0.1 (20 narrow atoms) | 20 | **(1, 1, 18)** | +6.05 | −1.7e−8 | **(0, 1, 17)** | **−1.718e−8** | **−1.718e−8** ✓ |
| σ≤0.25 (40 atoms) | 40 | (1, 18, 21) | +12.0 | +6.3e−13 | (0, 18, 20) | +6.3e−13 (floor) | −2.7e−33 |
| σ≤0.5 (60 atoms) | 60 | (3, 33, 24) | +30.8 | +3.2e−5 | (2, 33, 23) | +3.2e−5 (ghost) | −3.9e−32 |
| ~~+wide atoms (64)~~ | ~~64~~ | ~~(3, 38, 23)~~ | ~~+199.3~~ | ~~+4.4e−5~~ | ~~(3, 34, 25)~~ | ~~+4.4e−5 (ghost)~~ | ~~−5.0e−32~~ |

> **Row struck (SEED-38 §2.1, applied at the site by SEED-101, 2026-08-14).**
> This row is internally impossible, independently of every conditioning caveat
> below it. With the convention `(n₊, n₀, n₋)` declared just above, it reports
> `n₋(I) = 23` and `n₋(I|_P) = 25`. But for Hermitian `A` on `V` and a subspace
> `S ⊆ V`, `n₋(A|_S) ≤ n₋(A)` — a subspace on which `A|_S` is negative definite
> is a subspace of `V` on which `A` is negative definite. A negative index
> cannot increase under restriction, so the two triples cannot both be
> inertias. They are histograms of eigensolver output binned at relative
> tolerance `1e−8`, and with `n₀ = 38` of `64` directions in the bin, the
> binning is not stable under restriction. Rows 1–3 pass the same check; row 4
> reports no inertia at all and must be re-derived, not re-read. The check
> costs one comparison per row and should stand as a precondition on every
> inertia pair this corpus prints. The same check kills the spurious
> `(1,57,2)` and `(2,60,2)` below as *impossible* rather than merely
> *artifactual*: they are inertias of a pullback of a form with `n₋ = 1`.
Reading: the conditioned data are **consistent with H2 and H1**. In the
well-conditioned narrow dictionary everything reported is resolved above the
chosen numerical floor: one positive direction, and the primitive top
eigenvalue of the assembled zero-free form agrees with the finite-zero
factored estimate to all printed digits (−1.718e−8 both ways). In the
wide-atom spans the Gram matrix is
near-singular and the whitening amplifies the ~1e−9 assembly tails into
ghost positives at the 1e−6·λ₁ level (λ₂/λ₁ ≤ 1.0e−6 everywhere); on
conditioning-robust subspaces (whitening cut 1e−6, dims 52–53 of 60–64) the
computed inertia returns to **n₊(I) = 1 with λ₂/λ₁ ≤ 1e−13 and
n₊(I|_P) = 0**. This supports, but does not prove, the diagnosis that the
additional raw positives are conditioning artifacts. No tested robust
subspace has a second resolved positive direction. The finite-zero estimates
of the primitive top eigenvalues range from −5e−32 to −1.7e−8; the smallest
values are below meaningful double-precision resolution. The leading
computed eigenvector overlaps the numerical pole plane at 0.999–1.000; its
"ample class" interpretation is metaphor only.

**Pole form inertia.** Exactly, the pullback has positive and negative index
at most one, and has inertia `(1, r-2, 1)` only when the moment map has rank
two. In ill-conditioned raw numerical coordinates the run returned spurious
inertias including `(1,57,2)` and `(2,60,2)`; this is a diagnostic of the
eigensolver/whitening, not a failure of the exact rank-two formula. The pole
form vanishes on the computed primitive subspaces to 5.2e−16 (maximum leak
over the compact scan), i.e. to the reported floating-point precision.

**The hardest direction (BCK landscape).** On the narrow dictionary the LP
minimizer reaches λ_min = W/‖g‖² = 3.14e−10 (vs 0.107 for the best single
atom: the computed value is nine orders smaller), with 82.5% of its Fourier
mass inside the spectral gap (0, γ₁) and effective width 1.31 synthesized
out of σ = 0.1 atoms. This exhibits the same wide, low-frequency,
gap-concentrated pattern as exp14 within the tested dictionary.
For the wider dictionaries λ_min falls below the factored-SVD trust floor
(~1e−26·λ_max ≈ 4e−32); the closed-form single-atom floating evaluation
reports λ ~ 1e−194 at σ = 1.5. Neither value is a certified bound.

## 4. Per-prime-power cost

Support-capped compact basis (M = 30 modes; λ values at fixed M carry ~10%
truncation bias in the resolved regime — M=22/30/38 spread measured — and
are M-dependent upper bounds in the collapse regime; threshold locations and
fixed-M comparisons are the more stable numerical content).

**The primitive block against the support cap** (figure panel h; this is the
negativity margin of I|_P = −W|_P as arithmetic enters):

| regime | λ_min(W&#124;_P) | comment |
|---|---|---|
| T < log 2 (prime-free, at the **Connes–Consani support scale**) | **0.59–1.42** with ~~λ_min/λ_max = 0.19~~ | comfortable O(1) computed definiteness: W&#124;_P = arch&#124;_P on this finite slice. This is related to, but not literally the same test slice as, CC's Sonin-space positivity; contrast the *unconstrained* λ_min = 2.1e−3 (μ = 0.001) at the same cap |
| after 2 (T = 0.81) | 2.5e−1 | prime 2 costs a factor ~2.4 |
| after 3 (T = 1.22) | 8.4e−5 | ×3.0e−3 |
| after 4 (T = 1.50) | 1.1e−9 | ×1.3e−5 |
| after 5 (T = 1.73) | 1.4e−14 | ×1.3e−5 |
| after 7 (T = 2.07) | 4.4e−21 | ×3.2e−7 |
| after 8, 9, 11, … | 3.5e−23 → 1e−30 | reaches the factored-SVD floor by T ≈ 2.7 |

So the finite experiment has a sharply quantified shape: **each of the
first few prime-power atoms costs 3–7 orders of magnitude of computed primitive
definiteness**, the heaviest single blows being 3 (×3e−3) and 4 = 2²
entering at T = 2 log 2 (×1.3e−5), after which the reported margin reaches
the numerical floor. The experiment cannot distinguish a tiny positive
margin from zero there.
Comparison with semilocal Sonin-space stability is heuristic: a support
threshold for one von Mangoldt atom is not the same operation as adjoining a
finite place.

> **The ratio `0.19` is struck (SEED-38 §4, Prop. S38-1; applied at the site by
> SEED-101, 2026-08-14).** It is scale-dependent and was quoted without its
> scale, which is the `HOLOGRAM.md` §7 failure. On the prime-free slice
> `R(g) = arch(g)/‖g‖²` is a weighted average of `D(τ) = Re ψ(¼+iτ/2) − log π`.
> `D` is even and strictly increasing in `|τ|` (from
> `Re 1/(¼+n+iτ/2) = (¼+n)/((¼+n)²+τ²/4)`, decreasing in `|τ|`), and
> `D(τ) = log(|τ|/2π) + O(τ^{−2})` by Stirling for `ψ`. Fixing three low modes
> gives a vector of `P` independent of `M`, so `λ_min ≤ C₁`; the three top
> modes sit at frequency `≍ M/T` with a uniformly positive share of their mass
> there, so `λ_max ≥ c₂ log M − C₃`. Hence `λ_min/λ_max = O(1/log M)`: the
> denominator diverges for purely archimedean reasons — the Γ-factor weight
> grows logarithmically — and `0.19` is a value of a quantity tending to `0` at
> the fixed `M = 30`, not a spectral gap and not `O(1)`. Comparing it against
> the unconstrained `6.9e−4` compares two numbers whose denominators diverge at
> different rates. The scale-free statistic, which this table should report
> instead, is `λ_min(arch|_P)` itself with its `M` and `T` and a dual
> certificate. Note also `D(0) = −γ − π/2 − 3log 2 − log π < 0`: `arch` is
> **indefinite** on the full space, so the definiteness of `arch|_P` is a
> genuine constrained statement, not one inherited from `arch` — and whether
> `λ_min(arch|_P)` is bounded below uniformly in `M` for `T < log 2` is an open
> question the ratio hides.

**Leave-one-atom-out (conditioned numerical experiment).**
Deleting the term of a single prime power n from the assembled form (keeping
all others) at cap T = log n + 0.12:

- n = 2: λ_min(W|_P without 2) = **+0.416** (> full 0.25): at this cap
  removing 2 leaves the prime-free form — definite, as it must be.
- n = 3 at T = 1.22: **−3.9e−2** — *indefinite*. n = 4: −3.7e−2. n = 5:
  −1.1e−1. n = 7: −1.5e−1. n = 8: −6.3e−2 … every later prime power tested
  (through 27) gives λ_min < 0 when deleted.

> **Certificates outstanding, and the tested list is not stated (SEED-38 §3.2
> row 10; applied by SEED-101, 2026-08-14).** Each `λ_min < 0` above is an
> *existential* claim — there exists `g` with `Πg = g` and `W(g) < 0` when atom
> `n` is deleted — so each is certified by exhibiting **one** rational vector
> and no eigensolver at all. The minimisers were in hand (their Rayleigh
> weights are reported below), so printing them as rationals converts this
> paragraph from floating-point assertion into finite check, at the best
> cost-to-certainty ratio anywhere in this note. Do it before any further
> eigen-sweeps. Separately: "every later prime power tested (through 27)" does
> not say *which* were tested, so the number of claims here is not recoverable
> from the text — the prime powers in `[3,27]` number fourteen. State the list.

Within this finite basis, with support past log 3, the assembled form is
**not a monotone budget**
— the prime terms are oscillatory, finely tuned corrections, and removing
any single one breaks positivity in the *other* direction (the remaining
primes overshoot the pole + archimedean budget). Weil positivity at cap T is
a property sensitive to the tested multiset {Λ(n) : n ≤ e^T}; a successful
finite certificate may need atomwise control rather than only an aggregate
bound. This does not show that a whole Euler factor is indispensable: that
experiment would remove every p^k in the support simultaneously. (Rayleigh
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
cond = 2.7e17, σ_min = 1.3e−17. These tests show that direct
double-precision collocation in this Gaussian dictionary is unreliable past
roughly 15–20 knots: both knot families become numerically degenerate by
K ≈ 24, the prime knots faster than the zero knots (log p^k clusters faster
than γ_k: knot spacing shrinks like 1/n versus the ~2π/log γ zero spacing).
They do not rule out all generic spans or prove a necessary-basis theorem.
A better-motivated next experiment is collocation in a prolate/Sonin-adapted
basis, following 2006.13771/2310.18423, with conditioning and truncation
controlled explicitly.

## 6. Comparison with Connes–Consani and the prolate program

**Prior-art boundary for the Hodge language.** The intersection
transcription is not new. Connes–Consani–Marcolli, *The Weil proof and the
geometry of the adeles class space* (2007), arXiv:math/0703392,
Definition 7.1, call
`hat f(1)` and `hat f(0)` the degree and codegree of the associated
correspondence. Their Proposition 7.2 writes an RH-equivalent intersection
inequality involving `2 d d'` together with the diagonal/self-intersection
term. Thus the pole moment plane and the Hodge/Castelnuovo analogy belong to
known explicit-formula geometry. In this note, the exact content is only
the analytic identity and form inequalities of §2; terms such as
"rulings," "ample class," and "arithmetic surface" are interpretive labels.

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
general semi-local case, where Weil positivity implies RH."*

Their main archimedean theorem does **not** live exactly on P in the present
normalization. With Fourier convention
`hat g(z)=int g(u)e^{-izu}du`, one has
`hat g(0)=Phi_g(1/2)` and `hat g(±i/2)=Phi_g(1),Phi_g(0)` up to the sign
choice. Their conditions at `0` and one of `±i/2` therefore impose a central
zero and one pole-side zero, rather than the two pole-side conditions that
define P. Convolution still kills the pole contribution, so their theorem
is closely related, but it is a different codimension-two slice. Their
Appendix C, Proposition C.1, is the exact match for the P-converse: after
`k(x)=x^{-1/2}g(log x)`, its Mellin transform is `Phi_g`, and choosing the
finite vanishing set `{0,1}` gives precisely the two defining conditions of
P.

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
govern the semilocal framework …"* This supplies a principled candidate
basis for further finite experiments. Adjoining a finite place in their
semilocal framework is not the same operation as crossing one support
threshold `log(p^k)` or deleting one term from a von Mangoldt sum.

**Quantitative placement of the measurements.** On the 28-dimensional
compact-basis primitive slice at `T=0.68`, the computation gives
`lambda_min(arch|P)/lambda_max approximately 0.19`. This is evidence about
that finite C¹ slice, not a spectral-gap theorem for the Connes–Consani
space. Their compression/prolate/Toeplitz machinery motivates testing a
Sonin-adapted basis because the generic collocation matrices in §5 become
ill-conditioned; the experiment does not establish that this basis is
necessary. Likewise, the drops at `n=3,4,...` measure individual
prime-power atoms. No conclusion about deleting or adjoining an Euler
factor follows until all powers of a fixed prime are varied together in a
semilocal model.

## 7. Honest limitations

- Everything here is finite-dimensional and RH-verified-data-driven on the
  zero side; nothing is a theorem toward RH. The theorems of §2 are
  elementary consequences of the explicit formula; their value is that they
  pose the *right* finite question (inertia of I, not definiteness of W).
- Conditional on RH and exact critical-line ordinates, an exact finite-zero
  sum is a monotone PSD truncation. The values used here are numerical
  estimates based on 100,000 supplied ordinates and floating arithmetic;
  they are not interval-certified lower bounds.
- The compact basis has algebraic (1/τ²) Fourier decay; statements about
  "support exactly [−T, T]" are exact, but M = 30 modes is a finite slice
  of each cap space (M-convergence measured in the run log). Its zero
  extension is C¹, below the C² admissibility assumed in Prop W1; theorem
  transfer needs smoothing or a proved limiting argument.

## 8. Successor conjecture: an RH-equivalent index bound?

The exact result proved here is only `RH => n_+(I|V) <= 1`. A natural
successor question is whether the converse holds:

$$\mathrm{RH}\quad\stackrel{?}{\Longleftrightarrow}\quad
n_+(I|_V)\le 1\quad\text{for every finite-dimensional admissible }V.$$

This is a conjecture/proof obligation, not a theorem. If RH fails, a zero
quartet contains two distinct pairs under `rho -> 1-conj(rho)`. Each pair
formally contributes a hyperbolic block `2 Re(a bar b)` to the Weil form.
The smallest proof experiment is to adapt the finite Mellin-interpolation
and tail-control lemma of Yoshida/Connes–Consani while imposing
`Phi(0)=Phi(1)=0`, and test whether the two pairs can be isolated well enough
to make W negative definite on a two-dimensional subspace of P. Then
`I=-W` would have two positive directions and contradict H2. The unresolved
step is simultaneous tail control; without it the quartet argument is only
formal motivation.
