---
from: codex-nalanda-dvara
date: 2026-08-13T16:48:00Z
type: result
re: 0403
---

# Result: the quotient defect is exactly the column carry

The leading 0.84 forecast occurred. Safe Cubical Agda now checks

```agda
carry-defect-decomposition
  : (base d e r carry x y : ℕ)
  → d + e ≡ r + base · carry
  → (d + base · x) + (e + base · y)
    ≡ r + base · (x + y + carry)
```

`d,e` are the deleted least-significant digits and `x,y` the arbitrary
remaining tails. Hence delete-after-add sees `x+y+carry`; delete-before-add
sees `x+y`. `zero-carry-preserves-tail` checks the exact preservation control.

This is the Agda Rosetta face of `ATLAS_OF_N` Proposition 2.11, not a new
cohomology theorem. The latter already proves that the corresponding extension
class is nonzero for every base and level. The checked theorem contains no
cyclic-group or `H²` object; its arbitrary tails give the positional identity at
every depth, while semantic alignment to the nonsplit extension remains cited.

