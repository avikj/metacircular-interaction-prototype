# वाहक-कोशः — the rays separate by conductor, and no nonzero ray is stationary

claude-setu, 2026-08-23. Compound built here (वाहक: carrier/conductor;
कोश: sheath/shell — both ordinary Sanskrit; no source claimed). Third of
the series after KuttakaKona and KendraDvibhitti; verifies transmission
U0025 (collab/upstream/raw/U0025.txt). As before: every claim below is
either derived on this page, cited as classical with its origin named,
or marked open. Nothing measured.

## §1. The rigidity theorem (proved — and it is genuinely a theorem)

Let 𝐭 = (t_p)_{p≤z} be a nonzero ray, d = ∏_{t_p≠0} p its conductor
(squarefree by construction). Then

    α(𝐭) = Σ_{p|d} t_p/p = k/d,  with  k = Σ_{p|d} t_p·(d/p),

and for any prime p | d, reducing k mod p kills every term except
t_p·(d/p), which is nonzero mod p because t_p ≢ 0 and d/p is a product
of primes distinct from p. Hence p ∤ k for every p | d:

    **gcd(k, d) = 1 — the direction has reduced denominator EXACTLY d.**

Corollary (no stationary nonzero rays): α(𝐭) ≡ 0 (mod 1) forces d = 1,
i.e. 𝐭 = 0. ∎

This deserves its name. It says the CRT tensor structure is *rigid*:
activity at a prime is permanently visible in the direction's denominator — no
conspiracy of digits at several primes can fake the zero direction.
The "additively almost stationary" rays of KendraDvibhitti §3 can
approach 0 but never reach it, and how closely they can approach is
now a question about rational approximation with prescribed reduced
denominator — a hard, clean, classical-shaped question.

## §2. The shell decomposition (verified)

Grouping the exact ray expansion (KendraDvibhitti §2) by conductor,
and using §1 to know each shell's directions are primitive:

    (1/ρ) Σ_{y∈I} S_{a,z}(y)
      = |I| + Σ_{d|P_z, d>1} Σ_{k∈(ℤ/d)^×} R_{a,d}(k)·D_I(k/d),

where R_{a,d}(k) is the amplitude of the unique tuple over d with
direction k/d (the digit t_p is recoverable from k mod p by §1's
computation: t_p ≡ k·(d/p)^{−1} mod p — the shells are honestly
parametrized by primitive fractions, with no multiplicity). ✓

## §3. The geometric split (verified)

|D_I(k/d)| ≤ min(L, 1/(2‖k/d‖)) (Dirichlet), and ‖k/d‖ ≥ 1/d by §1's
reducedness, so |D_I(k/d)| ≪ min(L, d). ✓ Hence a shell with d < L
contributes at relative size ≪ d/L per ray: **every conductor below
the observation scale is automatically weak, and dangerous rays need
d ≳ L.** For Goldbach L ≍ N. ✓

Stated as U0025 does, and it is worth stating twice: a hypothetical
Goldbach failure is necessarily a coherent high-conductor event — an
alignment of many locally weak facets at archimedean resolution finer
than 1/N. Not parity alone, not congruences alone. The compression is
real: the failure mode has been *located* in the (d, ‖α‖) plane, in
the corner d ≳ L, ‖α‖ ≲ 1/L.

## §4. Amplitude, action, and the two demands (verified as stated)

|R_{a,d}(k)| = ∏_{p|d} 2|cos(2πat_p/p)|/(p−2). The clean form: since
∏_{p|d}(p−2) = d·∏_{p|d}(1−2/p),

    |R_{a,d}(k)| = (2^{ω(d)}/d) · ∏_{p|d}|cos(2πat_p/p)| ·
                   ∏_{p|d}(1−2/p)^{−1},

so U0025's ≈ carries the explicit correction ∏(1−2/p)^{−1} (bounded
by O((log log d)²) over squarefree d — Mertens, classical, named).
The action 𝒜 = log d − ω(d)log2 − Σ log|cos| is −log|R| up to that
correction. ✓ Dangerous = small action AND ‖k/d‖ ≲ 1/L, and the two
demands do fight: the second fixes k mod d to a thin arc (≈ 2d/L
choices of k out of φ(d)), while the first requires every recovered
digit t_p ≡ k(d/p)^{−1} to land where |cos(2πat_p/p)| is near 1 — a
multiplicative condition on k at every prime of d simultaneously.
The desired theorem is exactly an uncertainty principle between an
archimedean localization of k/d and a CRT-multiplicative
localization of k's digits. (Open; shape verified, not the theorem.)

## §5. The measure form and the L² catastrophe (verified / flagged)

μ_{a,z} = ∗_{p≤z}(δ_0 + Σ_{t≠0} r_{p,a}(t)δ_{t/p}) on ℝ/ℤ, and the
convolution of Dirac combs at t/p produces exactly the CRT rays with
multiplied amplitudes, so ∫D_I dμ = Σ_𝐭 R D — the boxed identity. ✓
The organism in one line, as said: each prime convolves the light
field with one finite signed crystal.

The Parseval scale √(ρP_zL) against main term ρL is recorded as the
owner's scale statement and flagged as a heuristic of size, not a
derivation here (Cauchy–Schwarz over ~P_z rays with ‖D_I‖₂ ≍ √(P_zL)
gives the shape; constants unexamined). Its POINT survives any
constant: P_z ≫ L makes generic Hilbert-space control lose by a
diverging factor, so the theorem must use that μ is *generated* —
its mass is not arbitrary but the ω(d)-fold product of cosine
crystals. Genericity is the wrong prior; the measure is algebraic.

## §6. The Möbius skeleton and its angular body (verified)

Each nonzero local factor carries a leading −1 (r_{p,a}(t) < 0 exactly
when cos > 0, but the FACTORED sign is −sgn(cos)); the product of the
leading minuses over p | d is (−1)^{ω(d)} = μ(d). So the classical
sieve's Möbius weight is precisely the orientation skeleton of the
ray, and what the full ray retains beyond it is the cosine product —
the angular body. Parity (KendraDvibhitti §3) = keeping the skeleton,
discarding the body. ✓

**One exact small fact, derived, worth keeping** (twins, a = 1): at
p = 3, cos(2πt/3) = −1/2 for both t = 1, 2, so r_{3,1}(t) = +1 — the
entire conductor-3 shell of the twin field is positive at full
strength. The 3-crystal *reinforces* the twin count; the first
negative facets enter at p = 5 (r_{5,1}(1) = −2cos(72°)/3 < 0,
r_{5,1}(2) = −2cos(144°)/3 > 0). The z = 5 census seed of
KendraDvibhitti now has its opening entries exact.

## §7. Standing target (open, stated exactly)

    | ∫_{‖α‖≤1/L, α≠0} D_I dμ | + | ∫_{‖α‖>1/L} D_I dμ |  <  L.

Outer region: geometric decay (§3 supplies it shell by shell — this
half is close to classical). Inner region: arithmetic scarcity —
by §1 every contributing direction is a primitive k/d with d ≳ L,
and by §4 its brightness demands digit-wise cosine alignment. The
boundary d ~ L is the geodesic horizon. The literal theorem wanted:
**primitive CRT directions focused inside an arc of radius 1/L
cannot carry enough aligned cosine-weighted Möbius mass to cancel
the zero ray.** Goldbach (a = N/2) and twins (a = 1) are two
sections of it.

## Rigor boundary

- **Proved here**: §1 rigidity (complete), §2 shell parametrization
  incl. digit recovery, §3 split, §4's exact amplitude with the
  Mertens correction and the shape of the two demands, §5's measure
  identity, §6 incl. the twin 3-shell positivity.
- **Cited**: Dirichlet kernel bound; Mertens; the parity phenomenon
  per the previous notes.
- **Flagged as scale-heuristic**: §5's Parseval comparison
  (owner's; shape confirmed, constants unexamined).
- **Open**: §7, now with its region geometry and both failure
  pressures named.
