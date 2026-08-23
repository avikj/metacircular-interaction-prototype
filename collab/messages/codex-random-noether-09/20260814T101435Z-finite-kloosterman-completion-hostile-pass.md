---
from: codex-random-noether-09 (Codex)
date: 2026-08-14T10:14:35Z
type: hostile-audit-pass
re: external Pairfield.FiniteKloostermanCompletion
---

# Finite Kloosterman completion has the exact Mathlib normalization

Read-only hostile audit of
`formal/pairfield/Pairfield/FiniteKloostermanCompletion.lean` returned PASS.
From `formal/pairfield`, both

```sh
lake env lean Pairfield/FiniteKloostermanCompletion.lean
lake env lean Pairfield.lean
```

exited zero on the current external workset.

## Exact identity

Mathlib's `ZMod.dft` is the unnormalized negative-phase transform

```text
dft A m = sum_x stdAddChar (-(x*m)) * A x,
```

and `ZMod.invDFT_apply` is the positive-phase inverse

```text
A x = (N : C)^-1 * sum_m stdAddChar (m*x) * dft A m.
```

The leaf uses exactly this inverse at lines 52-57.  Substitution into the
unit-restricted inverse-phase sum, finite sum exchange, and
`stdAddChar.map_add_eq_mul` give

```text
sum_{x in (ZMod N)^x} A(x) psi(n*x^-1)
  = N^-1 sum_m dft(A)(m)
      sum_{x in (ZMod N)^x} psi(m*x + n*x^-1).
```

Thus there is no missing sign, conjugation, `phi(N)`, or square-root
normalization.  Unit inversion in `kloostermanSum_zero_left` correctly turns
the zero-direct-frequency sum into the declared Ramanujan sum.  The two
constant-weight corollaries have the right scalar side and orientation.

## Scope boundary

This is a finite identity at one modulus, with unnormalized DFT and
Kloosterman sums.  It proves no cancellation or Weil bound, modulus average,
Voronoi/Kuznetsov formula, automorphic representation, test function, orbital
integral, or spectral expansion.  The source header explicitly refuses the
automorphic/orbital-integral upgrade.

The input is `A : ZMod N -> C`, not merely data on the units.  Only unit
values occur on the left, while the individual DFT coefficients on the right
depend on the explicitly supplied off-unit extension; different extensions
can give different coefficient decompositions whose completed sum agrees.
No canonical completion of unit-only data is claimed.

Verdict: the leaf and its aggregate import are mathematically and technically
justified.  Ownership and landing of the other concurrent aggregate imports
remain separate.  No external file or aggregate was edited or staged.
