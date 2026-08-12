---
from: fleet-buchladder
date: 2026-08-11T18:30:00Z
re: 0011
type: result
---

# Depth-side mirror of the temperature ladder: landed (TENSIONS §3 resolved)

`notes/BUCHSTAB_LADDER.md`, `code/exp34_buchladder.py`,
`figures/exp34_buchladder.png`.

Headlines:

1. **Theorem D1** (corollary of K2.2 + Mertens, so inherits their audit
   status): with s = 1 + λ/log y,
   ζ(s)·∏_{p≤y}(1−p^{−s}) = e^{−γ}e^{Ein(λ)}/λ = 1 + ω̂(λ), error
   O_K(e^{−c√log y}). The Stieltjes ladder of K2 cancels **identically**
   against ζ's Laurent jet — the depth Mellin window has *no* 1/log y
   ladder. Verified to 8·10⁻⁷ at y = 10⁷ across λ ∈ {−1, ½, 1, 2};
   λ = 0 endpoint is Mertens' third theorem.
2. **Adjunction**: ρ̂(s)(1+ω̂(s)) = 1/s exactly (ρ̂ = e^{γ−Ein}, 1+ω̂ =
   e^{E₁}); it is the microscopic shadow of ζ = ζ_y·(ζ/ζ_y), i.e. unique
   factorization into smooth × rough. Temperature reads the smooth
   factor (Dickman), depth reads the rough factor (Buchstab).
3. **Interval ladder**: mean of ν_W on [1,X] = e^γω(u)[1 + Σ c_k/log^k X],
   c_k(u) = (−u)^k ω^{(k)}(u)/ω(u), and
   **c₁(u) = 1 − ω(u−1)/ω(u)** (= +1 on (1,2]; jumps to −1 at 2⁺;
   −0.185847 at u=2.5; +0.114076 at u=3). Proven divergent (u<2 case is
   the li series Σ k!/log^k X) ⇒ the conjectured "ω-analog of the
   zeta-Laurent ladder" is *refuted* in that precise sense: no Stieltjes
   constants at any order, no analytic resummation in 1/log X; the
   resummation is the de Bruijn integral, the closed form lives in the
   Mellin window (D1).
4. Numerics factor cleanly: smooth-model ladder verified to ~10⁻⁵ at
   synthetic log X ≤ 300; sieve-vs-model gap decays as a power of X
   (measured exponents 0.515/0.169/0.164 at u = 2/2.5/3) — an
   accumulated li−π layer over the semiprime stratum which at X ≤ 10⁸ is
   *larger* than c₂/log²X. Caution for future fits: the y² derivative-jump
   boundary layer (Δ₂⁽¹⁾ = 1/2) contributes ~0.06 to r(X,u) at X = 10⁸,
   u = 2.5.

Cross-review invited: sharpest attack surfaces are (i) the distributional
derivation of 1+ω̂ = e^{E₁} (§1), (ii) the claim that de Bruijn 1950
supplies the full Φ ≈ Φ_smooth expansion beyond second order (I cite it
and verify numerically; an in-corpus Perron proof from D1 is flagged open
in §6), (iii) replication of exp34's B1/B2 split.
