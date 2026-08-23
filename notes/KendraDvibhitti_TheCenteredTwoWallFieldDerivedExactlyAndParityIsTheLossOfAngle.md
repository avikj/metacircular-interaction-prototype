# केन्द्र-द्विभित्तिः — the centered two-wall field, derived exactly, and parity is the loss of angle

claude-setu, 2026-08-23. Compound built here (केन्द्र: centre — Sanskrit
took the word from Greek κέντρον via jyotiṣa usage, said so honestly;
भित्ति: wall, as in the corpus's भित्ति-स्नैपशॉट्). The formulation is the
owner's, transmission U0024 (collab/upstream/raw/U0024.txt), continuous
with KuttakaKona (this corpus, same day). This note VERIFIES every
identity in U0024 by derivation — each is a page or less of exact
algebra — and marks precisely where the open problem begins. Nothing is
measured; no floating point exists here; the trigonometric functions
below are notation for algebraic numbers (real parts of roots of unity)
and every identity holds exactly in ℝ.

## §0. The centering (verified)

Goldbach at even N, per KuttakaKona §1: m avoids {0, N mod p} at every
p ≤ √N. Substitute m = N/2 + y (N even, so N/2 ∈ ℤ; y ranges over a
centered window): m ≡ 0 ⟺ y ≡ −N/2, and m ≡ N ⟺ y ≡ N/2. So the two
walls become y ≢ ±N/2 (mod p). ✓

Twins: n and n+2 both prime needs n ≢ 0, n ≢ −2 (mod p ≤ √n); with
y = n+1: y ≢ ±1 (mod p). ✓ Both problems are the one field

    S_{a,z}(y) = ∏_{p ≤ z} 𝟙[ y ≢ ±a (mod p) ],

Goldbach: a = N/2, z = √N, cone |y| < N/2 − √N (KuttakaKona's cone,
centered). Twins: a = 1, I expanding. ✓

## §1. The local crystal (derived)

Fix p and write e_p(u) = e^{2πiu/p}. From 𝟙[y ≡ c (mod p)] =
(1/p) Σ_{t mod p} e_p(t(y−c)):

**Case p ∤ 2a** (walls distinct mod p):

    𝟙[y ≢ ±a] = 1 − (1/p) Σ_t e_p(t(y−a)) − (1/p) Σ_t e_p(t(y+a))
              = (p−2)/p − (1/p) Σ_{t≠0} (e_p(−ta) + e_p(ta)) e_p(ty)
              = (p−2)/p · [ 1 − (2/(p−2)) Σ_{t≠0} cos(2πat/p) e_p(ty) ].

Normalizing by the mean (p−2)/p:

    𝟙[y ≢ ±a] = ((p−2)/p) Σ_{t mod p} r_{p,a}(t) e_p(ty),
    r_{p,a}(0) = 1,   r_{p,a}(t) = −2cos(2πat/p)/(p−2)  (t ≠ 0).  ✓

**Case p | 2a.** Then a ≡ −a (mod p) (for odd p this is p | a; for
p = 2 it always holds since a ≡ −a mod 2), the walls coincide, one
residue is removed:

    𝟙[y ≢ a] = ((p−1)/p) Σ_t r(t) e_p(ty),
    r(0) = 1,   r(t) = −e_p(−ta)/(p−1) = −1/(p−1)  (using p | a,
    so e_p(−ta) = 1; for p = 2, t = 1: −e^{−πia} = ±1·(−1)/(1),
    and a odd gives +1/(p−1)·(−1)^{...} — for p = 2 the single
    nonzero coefficient is −(−1)^a/(p−1) = +1 when a is odd).  ✓
    [The p = 2, a odd sign is the one place U0024's compact statement
    needs the flag: r_{2,a}(1) = −(−1)^a. It changes no structure —
    the crystal stays real and signed — and for a even, p = 2 is in
    the p | 2a class with r(1) = −1 as stated.]

The phases are gone: every coefficient is REAL. Centering turned the
crystal real, symmetric, signed. ✓ (This is the even symmetry of the
wall set {−a, +a}: the Fourier transform of an even indicator is real.)

## §2. The exact ray expansion (derived)

Multiply over p ≤ z. By CRT the product of the local expansions
distributes into a sum over tuples 𝐭 = (t_p):

    S_{a,z}(y) = ρ_{a,z} Σ_𝐭 R_a(𝐭) e( α(𝐭) y ),
    R_a(𝐭) = ∏_p r_{p,a}(t_p),   α(𝐭) = Σ_p t_p/p (mod 1),
    ρ_{a,z} = ∏_{p|2a} (1 − 1/p) ∏_{p∤2a} (1 − 2/p).

Sum over a centered interval I = {−H,…,H}: Σ_{y∈I} e(αy) =
Σ_{y∈I} cos(2παy) =: D_I(α) (the sine part cancels by symmetry), so

    Σ_{y∈I} S_{a,z}(y) = ρ_{a,z} Σ_𝐭 R_a(𝐭) D_I(α(𝐭)).      ✓ (boxed
    identity of U0024, exact, both sides integers·ρ — an identity,
    not an estimate.)

The 𝐭 = 0 ray contributes ρ|I|: the truncated singular series times
the window — KuttakaKona §4's "stalk bookkeeping" now literally the
zero ray of an optical system. ✓

## §3. Where the problem now sits, said exactly

Positivity of the survivor count is EXACTLY the signed inequality

    Σ_{𝐭≠0} R_a(𝐭) D_I(α(𝐭)) > −|I|.

Verified equivalent: divide the boxed identity by ρ > 0. For Goldbach
insert a = N/2 and the cone; A_N ≠ ∅ (KuttakaKona §1) follows. For
twins, a = 1 with I expanding.

**The geodesic core.** |D_I(α)| ≤ min(|I|, 1/(2‖α‖)) (the Dirichlet
kernel bound, classical). So a ray hurts only if ‖α(𝐭)‖ ≲ 1/|I| — a
CRT tuple nontrivial at many primes whose direction Σ t_p/p is
additively almost stationary. Those near-vanishing rational sums are
the whole battlefield: multiplicatively complicated, additively flat.
This is the same object as KuttakaKona §3's period-vs-cone mismatch,
now with angles: the period P = ∏p is the denominator lattice of the
α's, and the cone is short exactly when 1/|I| is large against the
spacing of the α's.

**Parity, located.** Taking absolute values Σ|R·D| discards the cosine
sign of every facet. The classical parity barrier (KuttakaKona §4:
the instrument's provable blindness) is exactly this discard — a
sieve weight is a scalar functional that cannot see the angle α(𝐭),
so it majorizes the signed sum by the unsigned one and dies. "Parity
is the loss of angular information" is not a metaphor: it identifies
which datum the classical instrument truncates (the sign field
𝐭 ↦ sgn(R·D)), and the corpus's own law applies — the discarded fibre
is where the content lives.

**The recursion.** Adjoining a prime q tensors the field:
every ray splits into q descendants, amplitude multiplied by
r_{q,a}(t_q) (≤ 2/(q−2) in size for t_q ≠ 0 — new rays are BORN
WEAK), direction bent by t_q/q. The theorem needed, stated exactly:

    the tensor branching cannot focus enough negative light into a
    centered cone of length ≫ (main-term threshold) to extinguish
    the zero ray.

## §4. What is proved, what is open, what is next

- **Proved here (verified derivations)**: §0 centering; §1 crystals,
  including the p = 2 sign flag; §2 the boxed identity and ρ; §3's
  equivalence of positivity with the signed inequality, and the
  Dirichlet localization of dangerous rays to ‖α‖ ≲ 1/|I|.
- **Classical, cited**: the Dirichlet kernel bound; the parity
  phenomenon (Selberg), here given its exact address as sign-field
  truncation.
- **Open, now with a precise shape**: the non-focusing theorem. Note
  what it quantifies over: sign patterns of ∏ cos through the CRT
  tree — a transport of signed amplitude through prime facets, which
  is the "next operator" U0024 names: act on (charge, α, R) jointly.
- **Successor seeds**: (i) the exact identity of §2 is a finite
  algebraic statement per (a, z, I) — a machine-lane verifier in the
  ValliMala pattern can exhibit it over a box in the cyclotomic field
  (exact, no floats: work in ℚ(ζ_P) or verify the equivalent integer
  identity Σ_y S = ρ Σ R D rearranged over ℤ[ζ]); (ii) the smallest
  interesting object is the ray census at z = 5: 2·(3−1)·(5−1)
  tuples, every α a fraction with denominator 30 — small enough to
  SEE the interference pattern whole, exactly, by hand; (iii) connect
  to the corpus's Kloosterman lane: the near-stationary sums
  Σ t_p/p ≈ 0 with t_p ≠ 0 are Kloosterman-fraction configurations,
  and that bridge deserves its own note with sources.
