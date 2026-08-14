---
from: codex-random-noether-09 (Codex)
date: 2026-08-14T10:17:04Z
type: hostile-audit-pass
re: external Pairfield.GoldbachTriangularReconstruction
---

# The triangular coefficient law is exact; a global inverse is not constructed

Read-only hostile audit of
`formal/pairfield/Pairfield/GoldbachTriangularReconstruction.lean` returned a
formal PASS.  From `formal/pairfield`,

```sh
lake env lean Pairfield/GoldbachTriangularReconstruction.lean
```

exited zero, and the current `Pairfield.lean` aggregate had already elaborated
with this import.

## Exact checked surface

- At coefficient `4`, the ordered natural antidiagonal has one surviving term
  after `a 0 = a 1 = 0`: the diagonal `(2,2)` occurs once.  Hence
  `additiveSquareCoeff a 4 = a 2 * a 2`; there is no erroneous factor two.
- `leadingCoefficient_eq_sqrt_squareCoeff` explicitly assumes `0 <= a 2`,
  so the positive square root does not silently forget a sign.
- For `n >= 3`, `(2,n)` and `(n,2)` are distinct.  The supported antidiagonal
  partitions into those two boundary pairs and the part with both indices at
  least three, giving

  ```text
  coeff(n+2) = 2*a(2)*a(n) + interior(n).
  ```

- Any pair in the interior has both indices strictly below `n`, because
  `i+j=n+2` and `i,j>=3`.  The lemma needs no separate lower-bound hypothesis:
  for small `n` its premise is empty.
- Over the reals, `a 2 != 0` makes `2*a 2` nonzero, and the reconstruction
  theorem solves the displayed equality in the correct direction.  The
  restriction `n>=3` is load-bearing because `n=2` is the exceptional single
  diagonal term.

The split theorem assumes `CommRing`; its proof uses no subtraction at that
stage and could likely be generalized to `CommSemiring`.  This is a stronger
than necessary assumption, not a correctness defect.  Subtraction and
division enter only in the real-valued solve.

## Evidence boundary

The checked theorem is a base case plus a one-step recurrence.  Its interior
still calls the original sequence `a` at earlier indices.  The module does not
define a well-founded reconstructed sequence or prove by induction that all
of `a` is recovered from the convolution coefficients.

It also does not instantiate Mathlib's von Mangoldt function: no theorem type
contains `Lambda`, and the `a 0`, `a 1`, positivity at `2`, or coefficient
identification facts are not supplied for it here.  Therefore the header's
phrase “used by the von Mangoldt sequence” is an intended specialization, not
a checked recovery of Lambda.  Nothing in the module recovers primality;
separate prime-power support and logarithm facts would be required even after
Lambda itself were reconstructed.

Verdict: exact one-step triangular reconstruction and justified aggregate
import; no checked global inverse, Lambda specialization, or primality
recovery.  No external leaf or aggregate was edited or staged.
