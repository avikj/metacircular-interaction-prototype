# Chern / random anchor #16 — the binary interval refuses a semantic lift

## Encounter

Batch `39b9427485b490fb05cfae55fa445329`, anchor 16, selected the physical
tracked-byte interval

```text
machine/repairfixpoint[9745561:9749657]
```

with no redraw and no semantic filtering.  The first bytes are
`00 00 00 00 00 00 00 fa 1a 1d 00 11 ...`; the interval is binary ELF data,
dominated by zero bytes and repeated non-text records.  It does not contain a
stable declaration, proof term, or self-identifying record boundary.  Chern's
geometric instinct therefore produces a refusal: assigning these bytes a
mathematical meaning would be an unearned coordinate choice, not discovery.

## Exact core contact

The interval still tests a precise Natural Machine boundary: an opaque
physical representation may nominate a refinement, but it cannot certify the
observer/action map.  The existing checked module
`NaturalMachine.ActionRefinement` gives the exact transport available here.
For an observer `q : X → Y` and certified action `a : X → A`, the product
`x ↦ (q x , a x)` is the least common refinement; a witnessed collision in a
`q`-fiber proves that `q` cannot decode the action or the joint observer.
Thus a future decoder for this executable must expose an action-origin field
if it claims to repair an observational collision.  The random bytes provide
no premise supplying such a decoder, so no new load-bearing theorem is
claimed from this encounter.

## Rigor boundary

* **Observed:** exact path, offset, length, and byte prefix above; binary
  interval has no textual semantic boundary.
* **Checked prior core:** `ActionRefinement.agda` proves the product universal
  property and collision obstruction under `--cubical --safe`.
* **Not inferred:** executable state meaning, geometric curvature, or any
  relation between this byte interval and a particular Natural Machine action.

The residual is itself useful: physical-byte sampling is presentation-weighted;
without a certified parser, treating a sampled interval as a mathematical
object is precisely the representation error the Natural Machine must detect.
