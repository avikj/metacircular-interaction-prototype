# Exact-rational (Agda-checkable) Weil positivity certificate, N = 64

**Result.** `weil_cert_agda.json` (format `{"n":64,"A":[[p/q]],"L":[[p/q]],"D":[p/q]}`, A = L·D·Lᵀ exactly, all D_j ≥ 0) certifies

> **Theorem.** For every g ∈ L²(ℝ) supported in an interval of length ≤ L* = 213/1000 = 0.213,
> Q_W(g) = Q_∞(g) ≥ c_agda ‖g‖², c_agda = 276015970560/57880077835267 = 4.76876·10⁻³.

Parameters: N = 64 cells, n0 = N (L* < log 2, so no prime term), δ = L*/N = 213/64000, ε_1 = 1/2, ε_d = 1/(2d²), η = 1/4, θ_i = ν_i²/b_i (b_i the κ-budget), shift s = 646912431/40760618193850 ≈ 1.5871·10⁻⁵ (float λ_min(M_rat) ≈ 1.603·10⁻⁵), min_i κ_i ≥ 0.05. Reproduce: `python3 weil_cert_agda.py --N 64 --L 213/1000` (about 20 s); `--search` finds L* on a 10⁻³ grid (0.214 fails: λ_min < 0).

## The monotone-rounding argument

Notation as in `ORACLE_WEIL_certified.md` §2 (Theorem 2.1). For L ≤ log 2, Q_W = Q_∞ and Theorem 2.1 gives, for all g in the form domain and any ε_d ∈ (0,1], η > 0, θ_i > 0,

  Q_∞(g) ≥ Σ_{i<j}(1−ε_{|i−j|})Ω_{|i−j|}|u_i−u_j|² + Σ_i (C_L δ + I_i − θ_i)|u_i|² + 2(1−η)|Σ C_i u_i|² − 2(1+η)|Σ S_i u_i|² + Σ_i κ_i f_i.   (∗)

Two further one-line inequalities, both losing only positive quantities, remove the rank-two terms:
(a) 2(1−η)|Σ C_i u_i|² ≥ 0 (dropped);
(b) −2(1+η)|Σ S_i u_i|² ≥ −2(1+η)(Σ_i S_i²)(Σ_i |u_i|²) (Cauchy–Schwarz).
Hence Q_∞(g) ≥ u*M_true u + Σ κ_i f_i with the real symmetric matrix
  u*M_true u = Σ_{i<j} W_{|i−j|}|u_i−u_j|² + Σ_i D_i |u_i|²,  W_d = (1−ε_d)Ω_d ≥ 0,  D_i = C_L δ + I_i − θ_i − 2(1+η)Σ_j S_j².

**Lemma (monotonicity).** Let 0 ≤ w_d ≤ W_d and d_i ≤ D_i be rationals and let M_rat be the matrix of Σ_{i<j} w_{|i−j|}|u_i−u_j|² + Σ d_i|u_i|². Then M_true − M_rat ⪰ 0.
*Proof.* M_true − M_rat is the matrix of Σ_{i<j}(W−w)_{|i−j|}|u_i−u_j|² + Σ_i (D_i−d_i)|u_i|², a sum of non-negative quadratic forms. ∎

The script forms exactly such w_d, d_i: every Arb ball x is replaced by ⌊x^{lo}·2⁴⁸⌋/2⁴⁸ ≤ x (function `arb_to_frac_lower`, which re-verifies q ≤ x in ball arithmetic); the ε_d, η are exact rationals; θ_i is a rational ≥ ν_i²/b_i (rounded *up*, admissible since any θ_i > 0 is); the row sums Σ_{j≠i} w_{|i−j|} on the diagonal are exact rational sums of the rounded w_d, so the stored diagonal is exactly Σ_{j≠i} w + d_i, i.e. M_rat is *exactly* the Laplacian-plus-diagonal matrix of the Lemma. The κ_i are evaluated in Arb with the same rational parameters and rounded down (κ_i^{lo}).

**Certificate.** A := M_rat − s·I with s rational. If A = L D Lᵀ exactly with unit lower-triangular L and D_j ≥ 0 (this is what the Agda checker verifies), then A ⪰ 0, so λ_min(M_rat) ≥ s, so for all u: u*M_true u ≥ u*M_rat u ≥ s Σ|u_i|² = (s/δ)·Σ δ|u_i|². With ‖g‖² = Σ(δ|u_i|² + f_i):

  Q_W(g) ≥ (s/δ) Σ δ|u_i|² + (min_i κ_i^{lo}) Σ f_i ≥ min(s/δ, min_i κ_i^{lo}) ‖g‖² = c_agda ‖g‖².

All quantities s, δ = 213/64000, κ_i^{lo} are exact rationals, so c_agda = min(s/δ, min κ^{lo}) = s/δ = 276015970560/57880077835267 is exact. Translation invariance and monotonicity of c_W extend the statement from supp g ⊂ [−L*/2, L*/2] to any interval of length ≤ L*.

What the Agda check certifies: the identity A = LDLᵀ and D ≥ 0 for the rational matrix in the JSON. What is proved on paper: Theorem 2.1 (the reduction), (a), (b), the Lemma, and the chain above. What relies on Arb: that the balls used for the rounding contain the true Ω_d, I_i, ν_i², σ_d², v_i^min, C_L, S_i, r_c², r_s² (§3 of the main note). The floating-point eigenvalue is used only to choose s.

Note on size: the exact LDLᵀ entries have denominators of up to ~1600 decimal digits (growth of exact elimination); the checker's cost is dominated by these. Rounding the data to 2⁻⁴⁸ (rather than 2⁻¹²⁸) keeps A's entries small; L, D are whatever exact elimination produces.

---

# Dyadic-slack certificate (`weil_cert_dyadic.json`, `weil_cert_dyadic.py`) — the version for Agda

**Result.** L* = 427/2000 = 0.2135, N = 64, δ = 427/128000. Gap c = 17688709534162125·2⁻⁶⁴·δ, i.e. c/δ = 2.29958·10⁻³; c_dyadic = min(c/δ, min κ_i^lo) = c/δ = 17688709534162125/7692148163548807168 ≈ 2.2996·10⁻³ (κ_min = 0.05). Every entry is an integer of at most 42 decimal digits; the JSON has fields n=64, k=144, A′, L′, D′, E′, c′ with

  A′ − c′·I = L′·D′·L′ᵀ + E′  exactly over ℤ,  E′_ii ≥ Σ_{j≠i}|E′_ij|,  E′_ii ≥ 0,  D′_j ≥ 0,  L′_ii = 2⁴⁰, L′ lower triangular,

where A′ = 2¹⁴⁴A, L′ = 2⁴⁰L, D′ = 2⁶⁴D, E′ = 2¹⁴⁴E, c′ = 2¹⁴⁴c (verified in Python by `emit()` and again by an independent re-check). Slack t = 2⁻³⁰ was added before the floating Cholesky so that E ≈ tI + rounding, which makes E diagonally dominant.

**What the Agda check certifies.** The integer identity and the inequalities above. From them: E is PSD (Gershgorin: a symmetric matrix with E_ii ≥ Σ_{j≠i}|E_ij| has all eigenvalues ≥ 0), L D Lᵀ is PSD (D ≥ 0), hence A − cI ⪰ 0, i.e. λ_min(A) ≥ c.

**Monotonicity for 2⁻⁶⁴ rounding (re-statement of the Lemma).** As in the exact-rational version, M_true is the matrix of Σ_{i<j}W_{|i−j|}|u_i−u_j|² + Σ_i D_i|u_i|² with W_d = (1−ε_d)Ω_d ≥ 0 and D_i = C_Lδ + I_i − θ_i − 2(1+η)Σ_jS_j². The script sets w_d := ⌊2⁶⁴·(W_d)^{lo}⌋/2⁶⁴ (function `dy_lower`, which verifies in ball arithmetic that w_d ≤ every point of the ball of W_d, and clamps at 0), and d_i := ⌊2⁶⁴·(C_Lδ + I_i − 2(1+η)ΣS_j² − θ_i)^{lo}⌋/2⁶⁴ with θ_i a dyadic rounded *up* from ν_i²/b_i (admissible: any θ_i > 0 is, and κ_i is then evaluated with that same θ_i). Row sums Σ_{j≠i}w_{|i−j|} are exact dyadics with denominator 2⁶⁴, so every entry of A = M_rat is a multiple of 2⁻⁶⁴ (asserted in `build`). Since 0 ≤ w_d ≤ W_d and d_i ≤ D_i, M_true − A is the matrix of Σ_{i<j}(W−w)|u_i−u_j|² + Σ(D_i−d_i)|u_i|² ⪰ 0. Together with λ_min(A) ≥ c: u*M_true u ≥ c Σ|u_i|² = (c/δ) Σ δ|u_i|², and with the κ_i^{lo} (dyadics rounded down from the Arb balls, min = 0.05) the reduction gives

  Q_W(g) ≥ (c/δ)·Σδ|u_i|² + 0.05·Σf_i ≥ c_dyadic ‖g‖²,  c_dyadic = c/δ ≈ 2.2996·10⁻³,

for every g supported in an interval of length ≤ L* = 0.2135 (translation invariance and monotonicity of c_W as before). The float eigenvalue and the float Cholesky are used only to *choose* c, L, D; the certificate is the integer identity plus the paper argument above and the Arb enclosures of §3 of the main note.

Reproduce: `python3 weil_cert_dyadic.py --N 64 --L 427/2000` (≈1 s after the data) or `--search` (grid 5·10⁻⁴; 0.214 fails with λ_min < 0). The slack costs nothing visible (c/δ = 2.29958·10⁻³ against float λ_min/δ = 2.34651·10⁻³, the 2% difference being the deliberate 0.98 factor in the choice of c).
