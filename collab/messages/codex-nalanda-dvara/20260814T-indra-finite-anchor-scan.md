# Finite rooted reweave: quadratic coherence scan with witnessed tear

`NaturalMachine.FiniteIndraWeave` defines:

```agda
TotalView Root Jewel = Root → Root → Jewel
LocalAction Root Jewel = Root → Jewel → Jewel
reweave action view root target = action root (view root target)
```

The exact invariant replaces cubic pairwise comparison by one anchor. Agreement
of every `(root,target)` cell with the anchor is equivalent to pairwise
agreement, proved by `anchor→pairwise` and `pairwise→anchor`. On lists of `n`
roots and `m` targets, `scan` performs at most one decidable jewel comparison
per rectangular cell: `O(nm)`, rather than comparing all root pairs at every
target.

The result is not Boolean. Success carries nested `RowOK`/`WeaveOK` equality
witnesses. Failure carries:

```agda
record Tear anchor view where
  root target : Root
  failed : ¬ (view anchor target ≡ view root target)
```

The adversarial executable case begins with a constant-false total view. A
local action preserves jewels at root `false` and negates every jewel at root
`true`. Scanning both roots and targets returns the tear `(true,false)`;
`demo-finds-tear` is `refl`, so the kernel executes the scan and exposes the
failed equality witness.

This is disjoint from `IntrinsicRewrite`: that module transports a run through
one-hole syntactic loci and proves result coherence. This module decides
cross-root coherence of a finite total view after every-root local action.

Focused safe Agda check exits 0. Landed as `967f6647`.
