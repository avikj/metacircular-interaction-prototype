# Literature / novelty verification: the five headline claims

Filed from `claude/math-repo-inter-agent-psvg2m` (web-search sweep, 2026-08-11;
arXiv full-text fetches were egress-limited — flagged where it matters).
Action items at the end. Companions: `CROSSREVIEW_WAVE2.md`,
`CROSSREVIEW_BLOCKS.md`, `CROSSREVIEW_EXP22_25.md`.

## Summary table

| # | Claim | Verdict |
|---|---|---|
| 1 | β-deformed HL crossover $C_{\beta_z,z}/C_{1,z}\to e^{-(k-1)\mathrm{Ein}(\lambda)}$ (PARITY §1H, exp9) | **Novel as stated** — no β-deformed singular series anywhere in sieve or KMS literature; but the analytic core is a classical Mertens-type computation (Granville–Soundararajan arXiv:math/0501232; Gonek–Hughes–Keating hybrid products). Claim the *object*, not the technique. |
| 2 | Liouville/Möbius–Goldbach trace formulas (Thm H, H′) | **PRIOR ART (probable, identity level)**: Cantarini–Gambini–Zaccagnini, "On the discrete convolution of the Liouville and Möbius functions", **arXiv:2603.10241** (Mar 2026) — exactly $\sum_{m_1+m_2=n}\lambda(m_1)\lambda(m_2)$ with explicit formulas for weighted averages, general weights, Möbius case included; machinery = their arXiv:2401.07531 (Forum Math. 2024). Also Mangerel arXiv:2404.12117 (IMRN 2024, pointwise λ-Goldbach), Chavez arXiv:2409.02106 (1/ζ′(ρ) weights under RH). Scale-degeneracy reading, line-level numerics, and simplex corollaries possibly still new. |
| 3 | Fresnel-phase recovery of zero gaps from Goldbach/Liouville phases (Thm G) | **Novel** — nothing reads zero differences from sum-line phases; nearest is Bogomolny–Keating arXiv:1903.07057 (statistical D↔D only). |
| 4 | Homometric rigidity of primes / irreducibility of $F_X$ (Thm A′/A″) | **Novel question** — no prior art found; adjacent turnpike (Rosenblatt–Seymour) and 0-1 irreducibility (Konyagin, Breuillard–Varjú, Bary-Soroker–Kozma) literatures are the right citations and contain no specialization to primes. |
| 5 | Twisted Goldbach displays L-zero sum-spectra (exp20) | **Partially anticipated**: identity = Bhowmik–Halupczok–Matsumoto–Suzuki, Mathematika 65 (2019), arXiv:1704.06103 (progressions ⇔ double sums over L-zeros, with converse). The individual-line numerical display appears new. **Cite 1704.06103 in FAMILY.md §2.1.** |

## Spot-checks

- **Matsumoto–Suzuki arXiv:2409.00888 confirmed**: J. Number Theory 280
  (2026) 918–946. Content as the repo cites it (M-functions for secondary
  terms; screw-function ⟺ RH necessary-and-sufficient). Note: the screw
  function is *built from* the single-zero secondary term, so "screw kernel
  = first-variation sector" should be phrased as *making explicit* what is
  near-definitional in MS, not as discovery of the masses. Screw-function
  tradition: Suzuki JLMS 2023 (arXiv:2206.03682), arXiv:2209.04658.
- **Tao–Trudgian–Yang arXiv:2501.16779 confirmed**; repo's citation accurate
  ("systematic" is the operative word — additive energy as a tool predates,
  e.g. Heath-Brown, Guth–Maynard).
- **Competition alert for REPORT §8 Problem 3**: Suzuki, "Weil's quadratic
  form via the screw function", arXiv:2606.09096 (June 2026), plus numerics
  arXiv:2607.24830 and arXiv:2607.02828 (July 2026) — a numerical
  realization of the Weil-quadratic-form/screw operator program is already
  underway externally. The planned "Krein test at 100k zeros" has company;
  differentiate via the block decomposition (mixed-block localization) or
  fold into the product-weight carrier work.

## Deep-read follow-up (abstract/snippet level — PDFs proxy-blocked from this environment)

Full texts of CGZ 2603.10241 and the Suzuki cluster were unobtainable here
(gateway 403 on arxiv.org/export/ar5iv/mirrors; WebSearch snippets only).
Findings at that level:

- **CGZ 2603.10241 confirmed details**: object S(n)=Σ_{m₁+m₂=n}λ(m₁)λ(m₂)
  plus k-fold versions; engine = their Forum Math. 2025 Laplace-convolution
  machinery with **general weights**; hypotheses RH + simple zeros
  (snippet-confirmed); introduction discusses Chowla; no evidence of
  numerics. **Verdict for Thm H: presumptively identical at identity level**
  — a smoothing difference (their weights vs our (X−m−n)₊) defends nothing,
  since the identity content coincides under standard transforms. Likely
  repo-new regardless: the scale-degeneracy reading, the line-level
  spectroscopy and inverse recovery (exp15/exp19), protection/exposure and
  block framing. **At risk until full text read: the simplex-Chowla
  corollary constants.** Thm H′ same verdict if their Möbius object is μ*μ.
- **Suzuki cluster** (2606.09096 theory; 2607.24830 finite-element operator
  numerics to 30 digits; 2607.02828 truncated-form dictionary): all three
  are **single-zero-index** objects (Weil-form style; cross terms at
  difference frequencies). Product weights a(γ)a(γ′) on pair sums: **not
  treated in any of the three**; a two-variable arithmetic carrier: **not
  treated**. The generic "Krein/Weil positivity numerics at scale"
  deliverable is externally taken (twice); mixed-block localization and the
  pair-sector/product-measure content remain untouched externally.
- A human with open egress should still do the final line-by-line PDF check
  of 2603.10241 before any submission containing Thm H/H′.

## Action items

1. **Decisive**: obtain and read arXiv:2603.10241 in full; line-by-line
   comparison against Thm H/H′ before any novelty claim (deep-read in
   flight from this branch).
2. Reframe PARITY §1H novelty language: new interpolation object; limit law
   from a Mertens-type computation.
3. Add citations: 1704.06103 (FAMILY §2.1), 2603.10241 + 2404.12117
   (LIOUVILLE.md/FAMILY.md), math/0501232 or GHK (PARITY §1H).
4. Track Suzuki 2606.09096/2607.24830 before executing Problem 3 follow-ons.
