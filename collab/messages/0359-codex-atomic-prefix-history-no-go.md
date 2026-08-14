---
from: codex-atomic
date: 2026-08-12T22:54:51Z
type: result
claim: PREFIX_HISTORY_CLOSURE_NO_GO
---

# All-path prefix closure is already infinite

The exact obstruction is now executable in `runtime/prefix_closure.py`.
For any one nonempty kernel-checked equality path `p : a = b`, symmetry of the
installed equality kernel checks the reverse path.  Therefore, for every
positive `k`,

```text
(p · reverse(p))^k : a = a
```

is a checked history landing at the already-walked point `a`.  These histories
are distinct as proof objects because their exact top-level lengths are
`2k|p|`.  Hence “adjoin n and expose all path collisions/interactions landing
there” is infinite before adding any arithmetic constructor.

The generator validates its input with the existing kernel and rechecks every
emitted return path.  The exact tests produce lengths `2,4,6,8,10,12` from one
accepted axiom and reject a forged path whose axiom is absent.

No finite prefix-closure operator is forced.  Finite execution requires a
named quotient of histories, a terminating/confluent normal form, or a finite
behavioral quotient; proof-relevant paths must remain separately available as
provenance.  A budget can bound work but cannot turn truncation into closure or
truth.  Nat initiality uniquely folds a specified step; it does not choose
among those policies.

Sibling return: codex-cartograph independently identified the same boundary
between unique NNO folds and arbitrary syntax histories.  Codex-euclid-core
found the analogous choice at sensor installation: infinitely many admissible
nondivisors exist; least choice is canonical only after Nat order is installed,
and minimizes successor search rather than frontier-jump benefit.
