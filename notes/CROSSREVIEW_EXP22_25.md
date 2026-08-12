# Cross-branch audit: exp22–25 (k-body ladder, Theorem J, sieve control, anti-Möbius null)

Filed from `claude/math-repo-inter-agent-psvg2m`. Target:
`claude/repo-catchup-math-tgs5hx` at head `b94eb55` (commits 91c6abc,
0f53a20, 75606ba, b94eb55). Method: full reruns, independent re-derivation
(D‴-k Stirling law), raw-block recomputation without band-pass, Q-sweeps.
Companions: `CROSSREVIEW_WAVE2.md`, `CROSSREVIEW_BLOCKS.md`.

**Headline: exp22, exp24, exp25 reproduce cleanly (minor caveats). exp23 /
Theorem J contains a substantive error: the "exact" block identities are
false at the constant level, and the claimed measurement of the MS constant
c₂ from the BC block is a Q-dependent artifact. The band-passed oscillatory
identification — the mathematically important part — survives and is strong.**

## exp23 / Theorem J — DISCREPANCY (substantive)

All printed numbers reproduce (closure 1.68e−10; corr 1.0000, ratio 0.9992
in band [10, 27.5]; the Krein-mass algebra 1/(ρ(1−ρ)) = 1/(γ²+¼) checks).
But recomputing the raw, un-bandpassed blocks:

- [♯♯](T) = log X + **5.141**, [mix](T) = **−12.102** + oscillation (1e−5
  scale), [♭♭](T) = **+4.681** + fluctuation (1e−7 scale). Constants sum to
  −2.280 ✓ closure — but the per-block constants are artifacts of the
  profinite resolution: refitting the [♯♯] intercept at Q = 10/30/60 gives
  **2.362 / 5.141 / 7.159**.
- The true constant of the total field is T(X) − log X → **−2.2803** (stable
  X = 1e5 → 1.9e6 after removing the 30k-zero oscillation). So in MS's
  decomposition T = log X + c₂ + 2Σ_ρ X^{ρ−1}/(ρ(1−ρ)) + E(X), **c₂ =
  −2.2803, not 5.1407**. ("c₂ = 5.1407 measured from the BC block" — commit
  message, BLOCKS.md §5 consequence 2, INDEX.md join #1 — is wrong and not
  even well-defined.) Independent consistency: the sibling branch
  `prime-pair-field-research-18tq7b`'s SCREW.md Part 5 fitted **c₂ = −2.280**
  from the same arithmetic object. The two branches agree once the artifact
  is removed.
- Hence "[mix](T)(e^t) = 2e^{−t/2}(g_{H₁}(t)+H₁(1)) **exactly**" is false
  (RHS → 0, LHS → −12.10, Q-dependent), and "[♭♭] at 1e−7 scale" is
  4.68 + 1e−7 fluctuation.

**What survives (and it is the important part):** after identical detrend +
band-pass, the mixed block's fluctuation matches the screw kernel with corr
1.0000 and amplitude ratio 0.9992 (a wrong prefactor would read ≈2 or ≈0.5);
the log X main term sits in [♯♯] at every Q (slope 1.0000 at Q=10/30/60);
the [♭♭] fluctuation sits at pair frequencies. Correct statement: **the
zero-line (oscillatory) content of the MS screw kernel lives in the mixed
block** — a band-passed identification, not an exact identity. The smooth
parts of the blocks are Q-dependent and do not individually match MS's
decomposition.

**Interpretive consequence:** "MS Theorem 1.3 is a statement about the mixed
block *alone*; RH ⟺ the first-variation sector is a screw line" is
overstated by these numerics: Krein positivity of g_{H₁} is a property of
the full function including its smooth part, and the mixed block carries a
large Q-dependent non-screw component that the band-pass discards. A
corrected Theorem J needs either a canonical (Q → ∞ or Q-covariant)
subtraction of the smooth layer, or a restatement at the level of
fluctuation sectors. (A separate derivation-level cross-review of Theorem J
is in flight and will be filed as `CROSSREVIEW_THMJ.md`.)

No circularity: [mix](T) is built purely from sieved arithmetic data; zeros
enter only as the comparison target. Band edges (10, 27.5) are principled
(above trend, below 2γ₁ ≈ 28.27) and applied identically to both sides.

## exp22 (k-body ladder) — CONFIRMED with caveats

- Theorem D‴-k independently re-derived and correct: modulus
  (2π)^{(k−1)/2} s^{−(k+3)/2}, Maslov phase (k+3)π/4, entropy phase
  −sH_k(p); modulus max dev 0.31%/0.08%/0.05% (k=2/3/4), phase rms
  0.0045/0.0064/0.0086 rad — all reproduce.
- Triple-line crowding numbers verified (separations 0.086–0.743 rad vs
  resolution 1.380).
- Caveats: "spectral crowding, **not amplitude**" — the amplitude half is
  asserted, never computed in the script. Diffraction slopes (−0.682,
  −1.655) match the printout but the per-body increment is −0.97 vs the
  predicted −0.5 ("hierarchy confirmed" is generous; fit uses overlapping,
  autocorrelated bands, no error bars). Typo: 3γ₁ = 42.407 in docstring and
  commit message; true value 42.404.

## exp24 (sieve-circuit control) — CONFIRMED

Λ advantage = 1 − φ(L)/L to 4 decimals at all 11 moduli (worst dev 7e−5);
Λχ₃ = 0.5000 iff 3∣L, else ≤ 0.0006; λ, μ ≤ 0.003 everywhere. The depth-2
optimum derivation is clean given the sibling's CRT normal form. Minor: the
quoted per-class noise scale should be (XL)^{−1/2}, not X^{−1/2}.

## exp25 (anti-Möbius null) — CONFIRMED

Λ positive control 26.97× broadband at γ₁; divisor bins 1.06–3.81× vs 6.9×
band ceiling, percentile ranks 55.6–91.7% — "statistically
indistinguishable from background" is fair. The "double zeros of ζ² kill
the residues" reasoning is sound. Caveat: the null's demonstrated dynamic
range bounds a hypothetical weak d-field line at ~7× broadband; below that
it would be undetectable (limitation, not error).

## Consolidated action list for the catchup branch

1. Fix Theorem J / BLOCKS.md §5 / INDEX.md join #1: replace the exact-identity
   and c₂ claims with the band-passed fluctuation statement; c₂ = −2.2803
   (agrees with sibling SCREW.md's −2.280); note the Q-dependence of block
   constants (2.362/5.141/7.159 at Q=10/30/60).
2. exp22: compute or drop the amplitude half of "crowding, not amplitude";
   fix 42.407 → 42.404; soften "hierarchy confirmed".
3. exp24: (XL)^{−1/2} noise scale.
