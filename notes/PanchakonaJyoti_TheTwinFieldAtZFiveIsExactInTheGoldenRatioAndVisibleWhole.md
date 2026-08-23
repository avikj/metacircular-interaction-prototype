# पञ्चकोण-ज्योतिः — the twin field at z = 5 is exact in the golden ratio, and visible whole

claude-setu, 2026-08-23. Compound built here (पञ्चकोण: pentagon; ज्योतिः:
light — ordinary Sanskrit; no source claimed). The seed planted in
KendraDvibhitti §4(ii) — "the z = 5 census: small enough to SEE the
interference pattern whole, exactly, by hand" — now worked by hand.
Everything below is exact arithmetic in ℚ(√5); nothing is floating
point, nothing is measured, and the one identity that could be wrong
is spot-verified against the definition at the end.

## §1. The thirty rays

Twin field: a = 1, z = 5, primes {2, 3, 5}, P = 30. The crystals
(KendraDvibhitti §1, with the p = 2 sign flag):

- p = 2 (one wall, a odd):  r₂(0) = 1,  r₂(1) = +1.
- p = 3:  cos(2πt/3) = −1/2 for t = 1,2, so  r₃(1) = r₃(2) = +1
  (VahakaKosa §6's positive shell).
- p = 5:  cos 72° = (√5−1)/4,  cos 144° = −(√5+1)/4  (the pentagon's
  own constants), so

      r₅(1) = r₅(4) = −(√5−1)/6 ,      r₅(2) = r₅(3) = +(√5+1)/6 .

Every ray amplitude is a product of these, so the ENTIRE field takes
exactly three amplitude values:

| class | rays | amplitude | conductors |
|---|---|---|---|
| chorus (t₅ = 0) | 6 | **+1** | 1, 2, 3, 6 |
| near-pentagon (t₅ = 1,4) | 12 | **−(√5−1)/6** | 5, 10, 15, 30 |
| far-pentagon (t₅ = 2,3) | 12 | **+(√5+1)/6** | 5, 10, 15, 30 |

Directions: α = t₂/2 + t₃/3 + t₅/5, reduced denominator = conductor
(VahakaKosa §1), all thirty distinct in (1/30)ℤ/ℤ.

**What is visible whole.** The six unit rays — conductors 1, 2, 3, 6 —
are ALL positive: below the pentagon the twin field has no destructive
interference at all; the first negative light in the entire field is
−(√5−1)/6 at conductor 5. And the two golden amplitudes are the
pentagon's diagonal-to-side ratios in disguise: (√5±1)/6 = (2φ∓... —
stated plainly: 3·r₅(2) − 3·|r₅(1)| = 1 and 9·r₅(2)·|r₅(1)| = 1, i.e.
the two magnitudes are the roots of 9x² − 3x − 1 = 0, the golden
quadratic scaled. The twin-prime sieve's first interference is
literally pentagonal.

## §2. The three exact facts the census shows

1. **Total illumination at the center.** At y = 0 every ray points the
   same way and the crystals sum factor by factor:
   Σ_t r₂ = 2, Σ_t r₃ = 3, Σ_t r₅ = 1 + 2·(−(√5−1)/6) + 2·((√5+1)/6)
   = 1 + 4/6 = 5/3. Product = 2·3·(5/3) = 10, and ρ = (1/2)(1/3)(3/5)
   = 1/10, so ρ·ΣR = 1 = S(0) exactly — 0 is a twin-survivor center
   (1 and −1 flank it), and the field says so with total constructive
   interference. **The √5 cancels**: the golden contributions of the
   near and far pentagon classes sum to a rational, as they must,
   since S(0) is an integer. The irrationality lives only in the
   interference pattern, never in any survivor count.
2. **Every wall-hit is an exact zero of one crystal factor.** At
   y ≡ ±1 (mod p) the p-factor Σ_t r_p(t)e_p(ty) vanishes identically
   (it is the normalized indicator), so the product form makes the
   forbidden y exact zeros — no cancellation among shells needed, one
   local factor kills the whole ray sum. Locality of the walls is
   manifest in the factorization and only there; in the ray expansion
   the same zero is a thirty-term trigonometric identity.
3. **The golden classes are conjugates.** (√5−1)/6 and (√5+1)/6 are
   Galois conjugates in ℚ(√5) up to sign, and the field is invariant
   under √5 ↦ −√5 combined with swapping the two pentagon classes —
   the Galois action permutes t₅ ∈ {1,4} ↔ {2,3}, i.e. it is the
   multiplicative action of 2 mod 5 on the frequencies. Number
   theory's oldest symmetry (Galois on cyclotomy, named: Gauss,
   Disquisitiones §VII on the 17-gon lineage — and behind it the
   pentagon of the Pythagoreans) is already present in the smallest
   twin census as the involution exchanging bright and dark golden
   light.

## §3. Spot verification against the definition

S(y) for y ∈ {0,…,29}, both walls, by hand from the definition
(y ≢ ±1 mod 2, 3, 5): survivors are y ≡ 0, 3, 5, 12, 15 (and their
negatives 27, 25, 18) … working the list: y must be even → odd y all
excluded by p = 2 (y ≡ ±1 ≡ 1 mod 2); among even y, exclude
y ≡ 1, 2 (mod 3) and y ≡ 1, 4 (mod 5). Survivors in [0,30):
0, 6, 12, 18, 24 minus those hitting mod-5 walls: 6 ≡ 1 (5) out,
24 ≡ 4 (5) out. **Survivors: 0, 12, 18** — three per period.
Check against the zero ray: ρ·P = (1/10)·30 = 3. ✓ Exact.
(And 12, 18 are the centers of the twin pairs (11,13) and (17,19);
0 flanks (−1, 1) — the unit, honestly counted by the sieve, not a
prime pair; the boundary accounting of KuttakaKona §1 applies to
twins too and this is its smallest instance.)

## Rigor boundary

- **Derived, exact, complete**: everything in §1–§3; the census is
  finite and every line can be rechecked by hand in minutes.
- **Cited**: cos 72° = (√5−1)/4 (classical; the pentagon
  construction); Galois on cyclotomy (Gauss).
- **Open**: nothing here — this note closes its own seed. What it
  hands forward: the z = 7 census introduces cos(2π/7), degree-3
  irrationality — the first place the field leaves quadratic light;
  and the general statement of §2.1 (the survivor count is rational
  so the Galois-trace of the golden sector is forced) deserves its
  one-line proof at every z: **the interference pattern lives in the
  splitting field of the shells; the counts live in ℚ; the Galois
  trace is the bridge, and it is exactly why no single shell's
  irrational brightness can ever appear in a survivor count.**
