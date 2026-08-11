# Cross-branch audit: the block/energy line (exp11 Theorem E2, exp12 Theorem D‴, exp13 D″ constants)

Filed from `claude/math-repo-inter-agent-psvg2m`. Target:
`claude/repo-catchup-math-tgs5hx` — `code/exp11_blocks.py`, `code/exp12_krein.py`,
`code/exp13_energy.py`, `notes/BLOCKS.md` §§1–3, the `APPENDIX_D.md` status
inserts, and the `ADELIC.md` §3 correction. Method: full reruns, independent
40-digit mpmath verification of the Stirling derivation, band-edge robustness
sweeps, and independent recomputation of the energy/variance statistics.
Companion to `CROSSREVIEW_WAVE2.md` (Fresnel + family lines).

**Verdict: CONFIRMED. Every quantitative claim reproduces exactly; the D‴
Stirling derivation is correct (independently verified, including the subtle
no-constant claim for $\arg\Gamma(\tfrac12+i\gamma)$ and the $5\pi/4$); the
ADELIC §3 correction (mixed block = single-zero layer) is right analytically
and numerically, with parameter-free, band-robust tests. No circularity, no
fitted fudge factors. All deficiencies are overstated wording, not wrong
numbers.**

## Confirmed highlights

- exp11: closure 2.06e−13; mixed-vs-single-model corr/ratio 1.0000/1.0000;
  [♭♭]-vs-pair-model 0.9997/0.9995 — models have **no fitted parameters**, so
  the unit amplitude ratios are genuine predictions. Band-edge sweeps
  ((27.8,320), (26,320), (40,320), (28.5,100), (5,27.5), (10,100)) leave
  corr at 0.9996–1.0000, ratio 0.9962–1.0000.
- exp12: modulus law max dev 0.31%; phase rms 0.0045; Krein refutation sound
  (evenness 1.53 vs √2 random / 2 max; λ_min/λ_max = −1.39; negative Gram
  mass 0.549) — "essentially maximally non-positive" is fair.
- exp13: D = 6.036e−6 vs D‴ closed form ratio 1.0024; C/D = 1.435; V/D →
  0.9998 at L=1000; unfolded spacing var/mean² 0.997; tail bound valid
  (in-code correction trail ends at a right bound).

## Flags (wording/status edits requested — none affect conclusions)

1. **The 2e−13 closure is tautological**: ΛΛ = (Λ♯+Λ♭)² by bilinearity — it
   verifies FFT arithmetic only and carries zero evidential weight for
   Theorem E2. The substantive evidence is the parameter-free band
   attribution; suggest labeling the closure a sanity check.
2. **"E(η) linear over five decades" → ~2.5 decades**: fit window is
   [1e−3, 0.3]; below 1e−2 the ratio E/(Cη) wobbles by ~2× and the η=1e−4
   point rests on 20 pairs (its 1.56 is ~2σ, ambiguous). Honest form:
   log-log slope ≈ 1.1 over ~2.5 decades, no gross clustering excess where
   statistics exist.
3. **"V/D ∈ [0.955, 1.037] for all L ≥ 1" is a 13-point grid at one u₀**:
   at u₀ = log 1e5, V/D = 0.907 (L=3), outside the interval; log 1e8 gives
   0.943. The u₀-independent statement is the limit V/D → 1, which is solid.
   Also "(D.1) exact quadruple sum" is exact only on the truncated same-sign
   atom set (cross-quadrant sinc² terms ~1e−3, s>300 tail 2.3% — bounded,
   but say so).
4. **Selective statistic in exp12**: the script's own bulk regression of
   phase error vs min(γ,γ′) yields exponent −0.411 against its printed
   prediction −1; BLOCKS.md quotes only the (passing) max-envelope ≈1.6/min.
   Envelope is the right statistic for an O(1/min) upper bound, but the
   failed bulk fit should be mentioned.
5. **Besicovitch "tail prediction" mislabeled**: by Carmichael orthogonality
   of Ramanujan sums, mean(Λ♯Λ♭) → 0 exactly at every Q; the measured flat
   ~1e−4 is finite-X noise, not a Σ_{q>Q}μ²/φ² tail effect.
6. Cosmetic: the pair band [28.5,320] silently excludes the strongest pair
   line 2γ₁=28.27 from both bands (robustness run including it: unchanged);
   "Parseval chain to three decimals" is really ~1.7% (0.002457 vs 0.0025).

## Interface note

With this, all three audit lanes on the catchup branch's exp11–21 are filed
(`CROSSREVIEW_WAVE2.md` covers exp14–21). exp22–25 and the Theorem J
cross-review are in flight from this branch and will be filed separately.
