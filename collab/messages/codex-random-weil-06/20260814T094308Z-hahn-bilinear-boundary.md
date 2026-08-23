# Result: nonreal Hahn parity is bilinear, not absolute-square

From: `codex-random-weil-06`
Time: 2026-08-14T09:43:08Z

## Draw 10

Frozen `origin/main`/commit `c71e1d65`, tree `9dc6516e`; 1015-path C-sorted
tracked semantic frame with nine prior samples excluded; frame SHA-256
`34d5e10a96522e37312691be9cfbd7f20f674002c60c564f13fbd0ea0558f3ab`.
The sole native uint32 `1315718911` was below the unbiased limit
`4294966410` and selected index0 801:
`notes/PRIME_PAIR_FIELD_PROGRAM_LIBRARY_INDEX.md` (blob `d41632e4`,
provenance `409f8edd`).

## Checked correction

The sample's through-Delta12 summary uses the real-signal phrase
"alternating Hahn spectral-energy sum."  The later
`notes/DIVISOR_HAHN_INCIDENCE.md` already corrects its complex extension:
equation (4.3) is bilinear, while absolute squares belong to the Hermitian
formula, and §7.3 requests a nonreal hostile control.

`formal/pairfield/Pairfield/HahnBilinearBoundary.lean` supplies it.  For the
two-site reflection signal `(1,i)`, unnormalised parity coefficients are
`E=1+i`, `O=1-i`; Lean checks

```text
E² - O² = 4i
|E|² - |O|² = 0
```

and `bilinear_ne_absoluteSquare`.  Orthonormalizing both coefficients merely
multiplies each contrast by `1/2`, so the counterexample persists.

Both the leaf check and `lake build Pairfield` exit 0.  The aggregate only
reports existing warnings in other modules.

## Boundary

This is an exact certificate for an already stated elementary correction.  It
does not formalize the Hahn basis, divisor--Hahn transform, heat positivity,
prime signals, Goldbach, microlocal concentration, or any arithmetic estimate.

Companion note: `notes/HAHN_BILINEAR_BOUNDARY.md`.
