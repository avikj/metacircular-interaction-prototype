# Exact-rational (Agda-checkable) Weil positivity certificate, N = 64

**Result.** `weil_cert_agda.json` (format `{"n":64,"A":[[p/q]],"L":[[p/q]],"D":[p/q]}`, A = LÂDÂLµ exactly, all D_j â‰ 0) certifies

> **Theorem.** For every g âˆˆ LÂ²(â) supported in an interval of length â‰ L* = 213/1000 = 0.213,
> Q_W(g) = Q_âˆž(g) â‰ c_agda â–gâ–Â², c_agda = 276015970560/57880077835267 = 4.76876Â10â»Â³.

Parameters: N = 64 cells, n0 = N (L* < log 2, so no prime term), Î´ = L*/N = 213/64000, Îµ_1 = 1/2, Îµ_d = 1/(2dÂ²), Î = 1/4, Î_i = Î½_iÂ²/b_i (b_i the Îº-budget), shift s = 646912431/40760618193850 â‰ˆ 1.5871Â10â»âµ (float Î»_min(M_rat) â‰ˆ 1.603Â10â»âµ), min_i Îº_i â‰ 0.05. Reproduce: `python3 weil_cert_agda.py --N 64 --L 213/1000` (about 20 s); `--search` finds L* on a 10â»Â³ grid (0.214 fails: Î»_min < 0).

## The monotone-rounding argument

Notation as in `ORACLE_WEIL_certified.md` Â§2 (Theorem 2.1). For L â‰ log 2, Q_W = Q_âˆž and Theorem 2.1 gives, for all g in the form domain and any Îµ_d âˆˆ (0,1], Î > 0, Î_i > 0,

  Q_âˆž(g) â‰ Î_{i<j}(1âˆ’Îµ_{|iâˆ’j|})Î©_{|iâˆ’j|}|u_iâˆ’u_j|Â² + Î_i (C_L Î´ + I_i âˆ’ Î_i)|u_i|Â² + 2(1âˆ’Î)|Î C_i u_i|Â² âˆ’ 2(1+Î)|Î S_i u_i|Â² + Î_i Îº_i f_i.   (âˆ—)

Two further one-line inequalities, both losing only positive quantities, remove the rank-two terms:
(a) 2(1âˆ’Î)|Î C_i u_i|Â² â‰ 0 (dropped);
(b) âˆ’2(1+Î)|Î S_i u_i|Â² â‰ âˆ’2(1+Î)(Î_i S_iÂ²)(Î_i |u_i|Â²) (Cauchyâ“Schwarz).
Hence Q_âˆž(g) â‰ u*M_true u + Î Îº_i f_i with the real symmetric matrix
  u*M_true u = Î_{i<j} W_{|iâˆ’j|}|u_iâˆ’u_j|Â² + Î_i D_i |u_i|Â²,  W_d = (1âˆ’Îµ_d)Î©_d â‰ 0,  D_i = C_L Î´ + I_i âˆ’ Î_i âˆ’ 2(1+Î)Î_j S_jÂ².

**Lemma (monotonicity).** Let 0 â‰ w_d â‰ W_d and d_i â‰ D_i be rationals and let M_rat be the matrix of Î_{i<j} w_{|iâˆ’j|}|u_iâˆ’u_j|Â² + Î d_i|u_i|Â². Then M_true âˆ’ M_rat â° 0.
*Proof.* M_true âˆ’ M_rat is the matrix of Î_{i<j}(Wâˆ’w)_{|iâˆ’j|}|u_iâˆ’u_j|Â² + Î_i (D_iâˆ’d_i)|u_i|Â², a sum of non-negative quadratic forms. âˆ

The script forms exactly such w_d, d_i: every Arb ball x is replaced by âŠx^{lo}Â2â´ââ‹/2â´â â‰ x (function `arb_to_frac_lower`, which re-verifies q â‰ x in ball arithmetic); the Îµ_d, Î are exact rationals; Î_i is a rational â‰ Î½_iÂ²/b_i (rounded *up*, admissible since any Î_i > 0 is); the row sums Î_{jâ‰ i} w_{|iâˆ’j|} on the diagonal are exact rational sums of the rounded w_d, so the stored diagonal is exactly Î_{jâ‰ i} w + d_i, i.e. M_rat is *exactly* the Laplacian-plus-diagonal matrix of the Lemma. The Îº_i are evaluated in Arb with the same rational parameters and rounded down (Îº_i^{lo}).

**Certificate.** A := M_rat âˆ’ sÂI with s rational. If A = L D Lµ exactly with unit lower-triangular L and D_j â‰ 0 (this is what the Agda checker verifies), then A â° 0, so Î»_min(M_rat) â‰ s, so for all u: u*M_true u â‰ u*M_rat u â‰ s Î|u_i|Â² = (s/Î´)ÂÎ Î´|u_i|Â². With â–gâ–Â² = Î(Î´|u_i|Â² + f_i):

  Q_W(g) â‰ (s/Î´) Î Î´|u_i|Â² + (min_i Îº_i^{lo}) Î f_i â‰ min(s/Î´, min_i Îº_i^{lo}) â–gâ–Â² = c_agda â–gâ–Â².

All quantities s, Î´ = 213/64000, Îº_i^{lo} are exact rationals, so c_agda = min(s/Î´, min Îº^{lo}) = s/Î´ = 276015970560/57880077835267 is exact. Translation invariance and monotonicity of c_W extend the statement from supp g âŠ [âˆ’L*/2, L*/2] to any interval of length â‰ L*.

What the Agda check certifies: the identity A = LDLµ and D â‰ 0 for the rational matrix in the JSON. What is proved on paper: Theorem 2.1 (the reduction), (a), (b), the Lemma, and the chain above. What relies on Arb: that the balls used for the rounding contain the true Î©_d, I_i, Î½_iÂ², Ï_dÂ², v_i^min, C_L, S_i, r_cÂ², r_sÂ² (Â§3 of the main note). The floating-point eigenvalue is used only to choose s.

Note on size: the exact LDLµ entries have denominators of up to ~1600 decimal digits (growth of exact elimination); the checker's cost is dominated by these. Rounding the data to 2â»â´â (rather than 2â»ÂÂ²â) keeps A's entries small; L, D are whatever exact elimination produces.

---

# Dyadic-slack certificate (`weil_cert_dyadic.json`, `weil_cert_dyadic.py`) â” the version for Agda

**Result.** L* = 427/2000 = 0.2135, N = 64, Î´ = 427/128000. Gap c = 17688709534162125Â2â»ââ´ÂÎ´, i.e. c/Î´ = 2.29958Â10â»Â³; c_dyadic = min(c/Î´, min Îº_i^lo) = c/Î´ = 17688709534162125/7692148163548807168 â‰ˆ 2.2996Â10â»Â³ (Îº_min = 0.05). Every entry is an integer of at most 42 decimal digits; the JSON has fields n=64, k=144, Aâ², Lâ², Dâ², Eâ², câ² with

  Aâ² âˆ’ câ²ÂI = Lâ²ÂDâ²ÂLâ²µ + Eâ²  exactly over â,  Eâ²_ii â‰ Î_{jâ‰ i}|Eâ²_ij|,  Eâ²_ii â‰ 0,  Dâ²_j â‰ 0,  Lâ²_ii = 2â´â°, Lâ² lower triangular,

where Aâ² = 2Ââ´â´A, Lâ² = 2â´â°L, Dâ² = 2ââ´D, Eâ² = 2Ââ´â´E, câ² = 2Ââ´â´c (verified in Python by `emit()` and again by an independent re-check). Slack t = 2â»Â³â° was added before the floating Cholesky so that E â‰ˆ tI + rounding, which makes E diagonally dominant.

**What the Agda check certifies.** The integer identity and the inequalities above. From them: E is PSD (Gershgorin: a symmetric matrix with E_ii â‰ Î_{jâ‰ i}|E_ij| has all eigenvalues â‰ 0), L D Lµ is PSD (D â‰ 0), hence A âˆ’ cI â° 0, i.e. Î»_min(A) â‰ c.

**Monotonicity for 2â»ââ´ rounding (re-statement of the Lemma).** As in the exact-rational version, M_true is the matrix of Î_{i<j}W_{|iâˆ’j|}|u_iâˆ’u_j|Â² + Î_i D_i|u_i|Â² with W_d = (1âˆ’Îµ_d)Î©_d â‰ 0 and D_i = C_LÎ´ + I_i âˆ’ Î_i âˆ’ 2(1+Î)Î_jS_jÂ². The script sets w_d := âŠ2ââ´Â(W_d)^{lo}â‹/2ââ´ (function `dy_lower`, which verifies in ball arithmetic that w_d â‰ every point of the ball of W_d, and clamps at 0), and d_i := âŠ2ââ´Â(C_LÎ´ + I_i âˆ’ 2(1+Î)ÎS_jÂ² âˆ’ Î_i)^{lo}â‹/2ââ´ with Î_i a dyadic rounded *up* from Î½_iÂ²/b_i (admissible: any Î_i > 0 is, and Îº_i is then evaluated with that same Î_i). Row sums Î_{jâ‰ i}w_{|iâˆ’j|} are exact dyadics with denominator 2ââ´, so every entry of A = M_rat is a multiple of 2â»ââ´ (asserted in `build`). Since 0 â‰ w_d â‰ W_d and d_i â‰ D_i, M_true âˆ’ A is the matrix of Î_{i<j}(Wâˆ’w)|u_iâˆ’u_j|Â² + Î(D_iâˆ’d_i)|u_i|Â² â° 0. Together with Î»_min(A) â‰ c: u*M_true u â‰ c Î|u_i|Â² = (c/Î´) Î Î´|u_i|Â², and with the Îº_i^{lo} (dyadics rounded down from the Arb balls, min = 0.05) the reduction gives

  Q_W(g) â‰ (c/Î´)ÂÎÎ´|u_i|Â² + 0.05ÂÎf_i â‰ c_dyadic â–gâ–Â²,  c_dyadic = c/Î´ â‰ˆ 2.2996Â10â»Â³,

for every g supported in an interval of length â‰ L* = 0.2135 (translation invariance and monotonicity of c_W as before). The float eigenvalue and the float Cholesky are used only to *choose* c, L, D; the certificate is the integer identity plus the paper argument above and the Arb enclosures of Â§3 of the main note.

Reproduce: `python3 weil_cert_dyadic.py --N 64 --L 427/2000` (â‰ˆ1 s after the data) or `--search` (grid 5Â10â»â´; 0.214 fails with Î»_min < 0). The slack costs nothing visible (c/Î´ = 2.29958Â10â»Â³ against float Î»_min/Î´ = 2.34651Â10â»Â³, the 2% difference being the deliberate 0.98 factor in the choice of c).
