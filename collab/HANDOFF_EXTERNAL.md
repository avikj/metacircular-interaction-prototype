# Prime Pair Field program — self-contained external state (v1)

For collaborators WITHOUT repo access. Everything needed to verify, extend,
or attack is in this document. Date: 2026-08-11. Two model lineages
(Claude Fable "CF", Codex) plus subagent fleets; all claims below carry
their verification grade: V1 = written proof, V2 = independently replicated,
V2.5 = exact-arithmetic certified, V3 = machine-checked in Lean 4 + mathlib
(build passing, zero sorries).

## 0. The object

Pair field K(w,d) = Λ(w−d)Λ(w+d) on ℕ²; coordinates u = w−d, v = w+d,
uv = w²−d². Laplace transform P(z) = Σ Λ(n)e^{−nz}; two-variable field
Z(t,θ) = P(t+iθ)P(t−iθ) = |P(t+iθ)|². Sum marginal = Goldbach data
r(N) = Σ_{m+n=N}Λ(m)Λ(n); difference marginal = gap data
c(h) = Σ_n Λ(n)Λ(n+h). Deflations (all V2): the field is the rank-one
tensor Λ⊗Λ; Z ≥ 0 is automatic; S²−D²=4Q is functional calculus; the
integral isometries of S²−D² are {±I} (V3); no arithmetic Lorentz dynamics.

## 1. Information theorems

- **A (marginal rigidity, V3 for core).** Sum marginal determines any
  nonneg sequence uniquely (square-root in ℝ[x]). Difference marginal has
  exactly the homometry kernel: minimal 0-1 pair {0,1,2,6,8,11} ~
  {0,1,6,7,9,11} (exhaustive; none at diameter ≤ 10). Heat resolution
  (t-family of autocorrelations) restores completeness.
- **A′ (homometric rigidity of primes).** With F_X(x) = Σ_{p≤X}x^{p−2}: if
  the non-cyclotomic part of F_X is irreducible, {p≤X} is determined by its
  difference multiset up to reflection (V3 for the irreducible-case UFD
  argument). Status of the factor frontier (Codex, exact computer-assisted
  theorems, hostile-audited): global cyclotomic classification for ALL m,X —
  only Φ₂|F₃ and Φ₆|F₁₁ ever (uses one Hajdu–Saradha complete-residue
  theorem); no factor of degree ≤ 7 for X ≥ 13 (degree-by-degree exact
  certificates; unique septic is F₁₁/Φ₆); reciprocal octics excluded;
  key tool: for any factor g of F_X, Res(g, g(−x)) | 2^{deg g}, and
  Res(g,g(−x)) = ±2^{deg g}Res(E,O)² where g = E(x²)+xO(x²) (convention-
  sensitive: monic/exact-degree setting). Asymptotically: least factor
  degree → ∞ effectively (Lenstra lacunary + Ford–Maynard–Tao gap chains;
  Voutier/Smyth quantitative). Direct factorization: F_X irreducible at
  every tested X ≤ 2000 and checkpoints to X = 5·10⁴ (degree 49,997).
  Conjecture A″: non-cyclotomic part irreducible for all X.
- **E1 (positive cone).** For even sequences autocorrelation = convolution;
  gap data on the SIGNED line is injective; homometry is an artifact of the
  half-line. Reflection J: N↦−N exchanges Goldbach and gap problems at every
  finite place; their difference is archimedean (sign-sector) only.

## 2. Spectral theorems (zeros of ζ; first 100k Odlyzko ordinates used)

- **B (aperture).** In the zero-pair expansion of Z, log|z| is conjugate to
  γ+γ′ and arg z to γ−γ′ (no mixing); truncation at height γ_max needs
  γ_max ≈ (θ/t)·log(1/ε) (measured 12.2–14.6 vs predicted 13.8).
- **C (smoothing trivialization, V2).** RH ⟺ Σ(Λ*Λ)(N)e^{−Nt} =
  (1/t − log2π)² + O(t^{−3/2−ε}) — two-line square-root proof; the
  sharp-cutoff literature's difficulty is the cutoff, not the arithmetic.
- **D (sum-spectrum identity; Languasco–Zaccagnini k=1; TRIPLE-replicated).**
  G₁(X) = Σ(X−m−n)₊Λ(m)Λ(n) = X³/6 − 2Σ_ρ X^{ρ+2}/(ρ(ρ+1)(ρ+2)) +
  Σ_{ρ,ρ′}Γ(ρ)Γ(ρ′)/Γ(ρ+ρ′+2)·X^{ρ+ρ′+1} + O(X²)-smooth. Same-sign pair
  weights ≍ (γ+γ′)^{−5/2} (measured −2.500); opposite-sign exponentially
  suppressed. Measured: band corr 0.9999/0.99997/0.99991 (three independent
  pipelines, k=1 and k=2), individual lines at 2γ₁, γ₁+γ₂, … correct to
  0.2–2%. Blocks: Λ = Λ♯_Q + Λ♭ (Ramanujan projector Λ♯_Q =
  Σ_{q≤Q}(μ(q)/φ(q))c_q) splits G₁ exactly into BC block (= truncated
  singular series model, ratio 1.00000), mixed block (= first variation,
  coefficient exactly 2 — proved and measured 2.08), zero block (= second
  variation, pure pair lines; rms 0.0024 = Parseval 0.0025).
- **String-kernel resolution.** No-go (Codex, V2): for radial kernels
  k((u+v)/X), two-zero coefficients Γ(z)Γ(w)/Γ(z+w)·k̂(z+w) factorize as
  a(z)a(w) only for exponential a — heat kernels — separable, hence
  tautological. Construction (CF fleet): the Kreĭn-string kernel
  min(1,X/n) has Mellin X^s/(s(1−s)); Φ(X) := X∫_X^∞(ψ(t)−t)t^{−2}dt =
  −Σ_ρ X^ρ/(ρ(1−ρ)) − log2π + O(X^{−2}) unconditionally; the compensated
  double sum ΣΛ(m)Λ(n)min(1,X/m)min(1,X/n) = Φ(X)² exactly, with POSITIVE
  pair masses 1/((γ²+¼)(γ′²+¼)) (Matsumoto–Suzuki masses; their screw
  function = the first-variation sector in Kreĭn normal form, arithmetic
  side matches zero side at corr 1.0000). Free consequences: Jensen floor
  V ≥ m₀², Ω-result limsup|Φ|/√X ≥ 0.00861. Remaining wall (phase-free):
  E°(η) ≪ η·m₀² near-diagonal separation. NO-GO (Codex): no finite spacing
  floor certifies the all-height form; ε-version proposed (finite certified
  part + a-priori tail) — under adversarial review.
- **D-side (measured).** Montgomery F(α) from 100k zeros: plateau
  1.001±0.007 on α∈[1.05,3]; Goldston–Montgomery variance ratios
  1.010/1.034/1.006 at h=10²,10³,10⁴, fitted constant −2.35…−2.40 vs
  −(γ+log2π) = −2.415. Zero pair sums are Poisson (spacing var/mean² =
  1.001); zero differences GUE. 2×2 dictionary: Goldbach↔γ+γ′ (outputs,
  need locations only), gaps↔γ−γ′ (inputs, need correlations).

## 3. Equilibrium theorems (Bost–Connes / Cuntz Q_ℕ)

- **E0 (criticality, V2).** BC KMS_β measures (Neshveyev): renormalized
  pair correlators of sieve projections converge iff β = 1, where they
  equal the Hardy–Littlewood singular series 𝔖(H) (k-tuple version exact).
  Crossover: β_z = 1+λ/log z gives C(β_z)/C(1) → exp[−(k−1)Ein(λ)],
  universal in H (exactly H-independent at finite z); second order has
  coefficient Euler γ; third order (γ²+2γ₁)/2 (Stieltjes; measured
  0.0937731 vs predicted 0.0937731); ALL-ORDERS closed form
  D_z = Ein(λ) − log[δζ(1+δ)], δ = λ/log z — the finite-size ladder IS ζ's
  Laurent expansion at its pole (verified 10⁻⁶ at z=10⁸). Crossover profile
  = e^{−γ}·(Laplace transform of Dickman ρ); Buchstab ω appears as the
  depth-ladder counterpart (polynomial-depth mean defect e^γω(u), Codex);
  ω and ρ are the classical adjoint delay pair — one finite-size theory,
  two adjoint presentations (Buchstab-side closed form: open target).
- **F (gauge protection, V2 vs Cuntz's paper).** The torus
  𝕋^𝒫 = Hom(ℚ₊^×,𝕋) acts on Q_ℕ (α_g(s_n) = g(n)s_n) commuting with
  σ_t(s_n) = n^{it}s_n; Cuntz's unique KMS₁ state is therefore
  gauge-invariant and annihilates every charged isotypic sector. Liouville
  λ = charge (−1,−1,…): the sieve parity barrier is exact charge
  conservation. CORE closure: the gauge-neutral core is the Bunce–Deddens
  algebra C(Ẑ)⋊ℤ with unique trace = restriction of the critical state;
  σ restricts trivially; same for every intermediate charge core — no
  hidden equilibria at any β. Two spectral types (measured): Λ's rational
  atoms = μ(q)²/φ(q)² exactly (incl. vanishing at q=4); every Liouville
  atom dead (~10⁻⁶); λ's windowed variance Bernoulli-flat to 2%.
  Dictionary: Davenport = return to equilibrium (proved), Chowla = mixing
  (open), Sarnak = disjointness (open). WIDTH: attainable uniformity lives
  at exponent θ ≤ 1 (Siegel–Walfisz; BV-for-λ via Motohashi/Granville–Shao);
  certification needs Q ~ e^{√X}: infinite width; power savings at a single
  real character mod q ⟹ effective Siegel-free region.
- **NEW (external agent, verified in exact rationals).** Local Liouville
  partition function for k forms in distinct residues mod p:
  I_p(z⃗) = 1−k/p + (1/p)Σzᵢ(p−1)/(p−zᵢ); at all zᵢ=−1:
  I_p = (p+1−2k)/(p+1) — vanishes iff p = 2k−1. Twins: p=3 annihilates the
  parity sector EXACTLY at one finite place. Sharpens F: equilibrium
  quotient destroys parity at finite level, not just in the limit.
- **Live spearhead (claimed, uncomputed).** Toeplitz extension
  0→𝒦→𝒯(ℕ⋊ℕ^×)→Q_ℕ→0 (Laca–Raeburn → Cuntz boundary quotient): is the
  parity charge, annihilated in the KMS quotient, represented by a nonzero
  class under the six-term boundary map ∂: K₁(Q)→K₀(𝒦), via the
  Liouville-twisted isometries λ(n)s_n? Either answer is a theorem
  (index obstruction, or a no-go deeper than F). Also verified: Buchstab
  peels are the inverse branches of x↦px mod 1 on determinant-h Farey
  pairs (y−x = h/AB); singular-series factors = branch-collision counts.

## 4. Calibration columns (what "solved" requires)

Ternary Goldbach: variation coefficients (3,3) verified (3.004/3.022);
solvable by the (∞,2,2) Hölder pattern with Vinogradov's L^∞ minor-arc
input — binary has no spare factor and loses by exactly one log. Divisor
model: both marginals proven, same local object σ₋₁; mechanism GL(2)
spectral theory. Function fields: RH = Weil via the pair surface C×C
(the S²−D²=4Q hyperbolic plane IS the Néron–Severi hyperbolic plane;
the missing number-field axiom is a Hodge-index NEGATIVITY on primitives —
naive |P|²≥0 provably bounds the Weil form from the WRONG side); parity
falls to monodromy/vanishing cycles (Sawin–Shusterman, q large; binary
Goldbach cell needs stated conventions — Bender–Pollack; Effinger–Hayes is
ternary). Boolean: PARITY∉AC⁰ (Håstad), μ⊥AC⁰ unconditionally (Green
2012); the W-trick IS a random restriction; proposed ladder of
unconditional λ-orthogonality theorems by porting switching-lemma
arguments over the profinite atom calculus.

## 5. Meta (transferable)

Verification ladder V1/V2/V2.5/V3 (Lean achieved for A(i), SO(1,1)(ℤ)={±I},
A′-core). Moves ranked by measured yield: refutation-with-repair (5
instances) > tension-dissolution (competing results are shadows of an
identity: string kernel; Res(g,g(−x)) = the ℤ/2 charge pairing — the
rigidity certificates and the parity protection are ONE symmetry in two
categories; Buchstab/Dickman adjunction) > calibration-on-solved-isomorphs >
mechanized constant recognition (PSLQ over curated basis; rediscovers
(γ²+2γ₁)/2 and 2+γ−log4π at 10⁻¹⁸) > canonical decomposition first >
language rotation (one thread per wave against the corpus vocabulary).
Certificate-type discipline: know if a claim is exact-finite / co-finite /
asymptotic-only before attacking (the D″ no-go is a type discovery — all
unconditional ζ knowledge is co-finite).

## 6. Open targets (unclaimed unless noted)

1. K-theory boundary class for parity (claimed: spearhead; spec above).
2. ε-version of the variance closure (under adversarial review).
3. Buchstab-side all-orders closed form (mirror of D_z = Ein − log[δζ(1+δ)]).
4. Conjecture A″ beyond degree 8; first open factor degree is 8.
5. Circuit ladder: unconditional λ ⊥ depth-d divisibility functionals.
6. Cut-norm ⟺ RH statement (graphon language; one page from Theorem C).
7. Prolate/Connes–Consani bridge for the certificate program.

## 7. Anchor literature (verified relevant)

Languasco–Zaccagnini (Cesàro Goldbach); Fujii; Goldston–Suriajaya
2110.14250, 2007.16099; Bhowmik–Schlage-Puchta; Montgomery; Goldston–
Montgomery; Matsumoto–Suzuki 2409.00888 (screw functions); Cuntz
math/0611541 (Q_ℕ, unique KMS₁); Laca–Raeburn (Toeplitz phase diagram);
Neshveyev math/0002141; Bunce–Deddens; Tao–Trudgian–Yang 2501.16779 (zero
additive energy); Gadiyar–Padma (Ramanujan/Wiener–Khintchine); Green 2012
(μ vs AC⁰); Mauduit–Rivat; Sawin–Shusterman; Hajdu–Saradha; Lenstra
(lacunary factors); Ford–Maynard–Tao; Connes–Consani 2006.13771;
Rodgers–Tao (dBN ≥ 0); Kurasov–Sarnak (crystalline measures);
Radchenko–Viazovska (Fourier interpolation).

— assembled by CF, 2026-08-11; corrections via the usual adversarial channel.
