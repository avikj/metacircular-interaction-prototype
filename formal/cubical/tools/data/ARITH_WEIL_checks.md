# ARITH_WEIL_checks.md — symbolic verification of §§4–5 of `NOTE_arithmetic_weil.md`

Tooling: SymPy 1.14.0 (exact symbolic), mpmath 1.3.0 (60-digit numerics as a second witness), Python 3.11.
Script: `arith_weil_checks.py` (43 checks, all PASS; raw output in `ARITH_WEIL_checks_raw.txt`).
Every identity below was (i) derived by hand as written here and (ii) confirmed by the script; where SymPy's
automatic machinery misbehaved this is recorded explicitly.

Notation as in the note: q = 4·1_[0,1/4], f = e^{-4s}(q*q), g = f*f̃, λ_k = 2k + 1/2, x_j = j/4,
b_0 = 256(1+4e^{-2}+e^{-4}), b_{±1} = -512e^{-1}(1+e^{-2}), b_{±2} = 256e^{-2}, E(x) = (1+4|x|)e^{-4|x|}/256.

## 0. Preliminaries: q*q, f, and (4.1)

(q*q)(s) = 16·|[0,1/4] ∩ [s−1/4, s]| = 16 s on [0,1/4], 16(1/2 − s) on [1/4,1/2], 0 otherwise.  [PASS]
F(z) = ∫ f(s)e^{−zs}ds = ∫_0^{1/2} (q*q)(s) e^{−(z+4)s} ds = (∫_0^{1/4} 4e^{−(z+4)s}ds)² = 16(1−e^{−(z+4)/4})²/(z+4)².
SymPy: the difference (F_integral − F_note)·(z+4)²·e^{z/2} simplifies to 0 on the branch z ≠ −4; the z = −4
branch of SymPy's Piecewise is the removable value.  [PASS (4.1)]

## 1. The piecewise formula for g

g(t) = (f*f̃)(t) = ∫ f(s) f(s−t) ds.  For t ∈ [0,1/4] the integrand changes form at s = 1/4 and s = t+1/4, so
g(t) = ∫_t^{1/4} f₁(s)f₁(s−t) + ∫_{1/4}^{t+1/4} f₂(s)f₁(s−t) + ∫_{t+1/4}^{1/2} f₂(s)f₂(s−t), with f₁ = 16se^{−4s},
f₂ = 16(1/2−s)e^{−4s}; for t ∈ [1/4,1/2] only ∫_t^{1/2} f₂(s)f₁(s−t).  SymPy evaluates these and
`simplify(expand(·))` of the difference with the note's formulas

  0 ≤ t ≤ 1/4:  g(t) = [(4t−1)e^{−4} + (8t−4)e^{−2}] e^{4t} + (8t e^{−2} + 4t + 1) e^{−4t}
  1/4 ≤ t ≤ 1/2: g(t) = (3−4t) e^{−4} e^{4t} + (1−4t) e^{−4t}

is identically 0.  [PASS ×2]  Also verified: g, g′, g″ continuous at 1/4 and vanish at 1/2; g′(0) = 0 (so the
even extension is C¹; in fact C² since g″(0⁺) is finite and the even extension of a C² function with g′(0)=0
is C²).  g is NOT C³: g‴(0⁺) = b_0/2 ≠ 0 — exactly the jump demanded by (5.1).  [PASS]

## 2. The stencil identity (5.1)

**E is the fundamental solution of (D²−16)².**  For x > 0, (D⁴ − 32D² + 256)E = 0 [PASS]; E is even with
E′(0⁺) = 0 (so E, E′, E″ are continuous at 0) and E‴(0⁺) − E‴(0⁻) = 2E‴(0⁺) = 1 [PASS].  Hence
(D²−16)²E = δ_0 in D′(ℝ).

**g = Σ_j b_j E(t − x_j).**  Resolving |t − x_j| on each of the three sign-patterns (0<t<1/4), (1/4<t<1/2),
(t>1/2), the stencil sum equals the piecewise formulas of §1 on the first two ranges and is identically 0 on
the third [PASS ×3]; by evenness the same holds for t < 0.  Therefore (D²−16)² g = Σ_j b_j δ_{x_j}, i.e. (5.1).

**Direct check of (5.1).**  (D²−16)²g = 0 on (0,1/4) and (1/4,1/2) [PASS ×2]; g, g′, g″ are continuous
everywhere and the jumps of g‴ are: at 0: 2g‴(0⁺) = b_0; at 1/4: g‴(1/4⁺) − g‴(1/4⁻) = b_1; at 1/2:
0 − g‴(1/2⁻) = b_2 [PASS ×3].  Since b_{−j} = b_j and g is even, the jumps at −1/4, −1/2 are b_{−1}, b_{−2}.
So (5.1) holds as a distributional identity with exactly the stated stencil; this also confirms the
derivation b = 256·(δ_0 − 2e^{−1}δ_{1/4} + e^{−2}δ_{1/2}) * (δ_0 − 2e^{−1}δ_{−1/4} + e^{−2}δ_{−1/2}) from
(D+4)²f = e^{−4s}D²(q*q) = 16(δ_0 − 2e^{−1}δ_{1/4} + e^{−2}δ_{1/2}).

## 3. Theorem 3, formula (5.3)

**Per-λ identity.**  For λ > 0, λ ≠ 4, and x > 0 (symmetric in x),
  (e^{−λ|·|} * E)(x) = e^{−λ|x|}/(λ²−16)² − λ e^{−4|x|}/(4(λ²−16)²) + 2λ E(x)/(λ²−16).
SymPy: the convolution integral split as ∫_{−∞}^0 + ∫_0^x + ∫_x^∞ minus the right side simplifies to
`Piecewise((0, λ≠4), (…, True))`, and to 0 after substituting λ ∈ {1/2, 9/2, 7/3, 13/2}.  [PASS]
(Fourier proof: 2λ/((ξ²+λ²)(ξ²+16)²) = 2λ[ (1/(ξ²+λ²) − 1/(ξ²+16))/(λ²−16)² + 1/((λ²−16)(ξ²+16)²) ].)
Consequently, using g = Σ_j b_j E(· − x_j) and ∫_0^∞ e^{−λu}[g(t−u)+g(t+u)]du = Σ_j b_j (e^{−λ|·|}*E)(t−x_j):
  ∫_0^∞ e^{−λu}[2g(t) − g(t−u) − g(t+u)] du = 2g(t)/λ − 2λg(t)/(λ²−16) − Q_λ(t)/(λ²−16)² + λQ_4(t)/(4(λ²−16)²),
and 2/λ − 2λ/(λ²−16) = −32/(λ(λ²−16)) [PASS].  This is the note's per-λ formula.  Numerical spot checks of
the full per-λ identity against mpmath quadrature (with the integrand's kinks at u = |t−x_j|, x_j−t as
breakpoints) at (λ,t) = (1/2, 0.13), (9/2, 0.31), (5/2, 0.7): differences 10⁻²⁷–10⁻²⁹ at 30 digits.  [PASS ×3]

**Expansion of the archimedean kernel.**  e^{−u/2}/(1−e^{−2u}) = Σ_{k≥0} e^{−(2k+1/2)u}, u > 0; monotone
convergence justifies exchanging Σ_k and ∫_0^∞ termwise because the bracket 2g(t)−g(t−u)−g(t+u) is O(u²)
near 0 (g ∈ C²) and bounded, so each term is absolutely integrable and the k-sum of absolute values
converges.  Summing the per-λ formula over λ = λ_k gives (5.3) provided the two constants are as stated.

**352/105.**  With a = 1/4: −32/(λ_k(λ_k²−16)) = −4/((k+a)(k+a−2)(k+a+2)) = 1/(k+a) − ½/(k+a−2) − ½/(k+a+2)
(residues A = 1, B = C = −1/2, A+B+C = 0 [PASS]).  For A+B+C = 0 the sum telescopes:
  Σ_{k≥0}[A/(k+a) + B/(k+a−2) + C/(k+a+2)] = B(1/(a−2) + 1/(a−1)) − C(1/a + 1/(a+1))
(partial sums to K equal this plus (A+B+C)Σ_{k≤K}1/(k+a) − B[1/(K−1+a)+1/(K+a)] + C[1/(K+1+a)+1/(K+2+a)]).
Value: (−½)(−4/7 − 4/3) − (−½)(4 + 4/5) = 20/21 + 12/5 = 352/105.  [PASS; 60-digit numeric: 0.0 residual]
*Caveat recorded:* SymPy's `summation` returns −64/315 (after `simplify`; raw form contains `exp_polar`
artefacts) for this sum — a known branch bug — so it must not be trusted here; the telescoping derivation
and the numerics are the evidence.

**3229/44100.**  λ/(4(λ²−16)²) = (k+a)/(32(k+a−2)²(k+a+2)²).  The double-pole coefficients are +1/256 at
k+a = 2 and −1/256 at k+a = −2; the simple-pole coefficients vanish ((2−x)/(32(x+2)³) at x = 2 and
(−2−x)/(32(x−2)³) at x = −2 are both 0).  So the sum is (1/256)[Σ_{k≥0}(k+a−2)^{−2} − Σ_{k≥0}(k+a+2)^{−2}]
= (1/256)[1/(a−2)² + 1/(a−1)² + 1/a² + 1/(a+1)²] = (1/256)(16/49 + 16/9 + 16 + 16/25) = 12916/176400
= 3229/44100.  [PASS: SymPy `summation` gives 3229/44100 directly; 60-digit numeric residual 0.0]

## 4. Formula (5.4) for H(0)

1/(λ_k²−16)² = 1/(16(k+a−2)²(k+a+2)²) [PASS] = (1/256)[(k+a−2)^{−2} + (k+a+2)^{−2} − 2/((k+a−2)(k+a+2))].
Σ_{k≥0}(k+a−2)^{−2} = 1/(a−2)² + 1/(a−1)² + ψ′(a) = 16/49 + 16/9 + ψ′(1/4);
Σ_{k≥0}(k+a+2)^{−2} = ψ′(a) − 1/a² − 1/(a+1)² = ψ′(1/4) − 16 − 16/25;
ψ′(1/4) = π² + 8G (Catalan) [PASS, 55 digits];
−2Σ_{k≥0} 1/((k+a−2)(k+a+2)) = −½[1/(a−2)+1/(a−1)+1/a+1/(a+1)] = −½(−4/7−4/3+4+4/5) = −152/105 [PASS].
Hence H(0) = (1/256)[2(π² + 8G) + 16/49 + 16/9 − 16 − 16/25 − 152/105], which is (5.4).
[PASS: SymPy symbolic difference 0; mpmath 60-digit residual 0.0]

## 5. Tail bound (5.5)

For k ≥ 2, λ_k ≥ 9/2 > 4, so λ_k² − 16 > 0 and is increasing in k [PASS]; for d > 0 and k ≥ K ≥ 2,
e^{−λ_k d} = e^{−λ_K d} e^{−2(k−K)d}.  Hence 0 ≤ Σ_{k≥K} e^{−λ_k d}/(λ_k²−16)² ≤ e^{−λ_K d}/(λ_K²−16)² ·
Σ_{m≥0} e^{−2md} = e^{−λ_K d}/((λ_K²−16)²(1−e^{−2d})).  The note's K ≥ 3 is therefore (more than) sufficient.
[PASS; numeric d = 0.3, K = 3: tail 2.38e−4 ≤ bound 4.58e−4]

## 6. Closed forms used by the evaluator

ψ(1/4) = −γ − π/2 − 3 log 2 [PASS, 55 digits]; the Arb implementation additionally checks this closed form
against Arb's own digamma ball (overlap assertion in `arith_weil_cert.py`).

## 7. Explicit-formula normalisation (4.3)–(4.4): numerical witness (not a proof)

`arith_weil_zeros_check.py` computes Z(t) two ways: from (4.3) with the archimedean term by direct
quadrature of (4.4) (no Theorem 3), and from the zero-side definition (4.2) using the first 1500
nontrivial zeros (Arb `acb.zeta_zeros`), Z = Σ_{γ>0} 2|F(iγ)|² cos(γt).  Crude truncation bound 7.5e−8.
Results (log `arith_weil_zeros_check.log`): differences 3.3e−8 (t=0), −4.2e−10 (0.3), −2.7e−9 (log 2),
3.5e−11 (1), −3.4e−9 (log 3), −1.9e−9 (2 log 2), −1.0e−10 (log 6), 5.9e−11 (3log2−log3) — all within the
truncation bound.  This confirms the sign/normalisation of the archimedean term and of 2cosh(t/2)G(1/2).
Additionally, `arith_weil_cert.py` (Stage 0) checks Theorem 3's A_g(t) against quadrature of (4.4) at
t = 0.13, 0.31, 0.62, 1.9 to 25 digits (differences 0 at that resolution).

## Summary table

| item | status | evidence |
|---|---|---|
| (4.1) F(z) | PASS | symbolic |
| piecewise g (both pieces) | PASS | symbolic integration |
| g = Σ b_j E(·−x_j), zero outside support | PASS | symbolic |
| (5.1) stencil, incl. jump values b_j | PASS | symbolic |
| per-λ integral identity | PASS | symbolic (λ≠4) + numeric |
| Σ −32/(λ_k(λ_k²−16)) = 352/105 | PASS | telescoping + 60-digit numeric (SymPy `summation` wrong) |
| Σ λ_k/(4(λ_k²−16)²) = 3229/44100 | PASS | symbolic + telescoping + numeric |
| (5.3) | PASS | follows from the above; numeric vs (4.4) quadrature to 25 digits |
| (5.4) H(0) | PASS | symbolic + numeric |
| (5.5) tail | PASS | proof + numeric |
