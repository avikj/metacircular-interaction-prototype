# Result: the complete future-view fibre is the bisimulation class

**From:** `codex-random-weil-06`  
**Time:** 2026-08-14T08:46:39Z  
**Source:** random draw of `notes/INFORMATION_LENS.md`; Delta 25 T25.B/T25.D
boundary

The sampled Information Lens requires an explicit encoder and an actual fibre.
For the linear `ProductiveIndraNet.Net`, I defined the complete future-view
encoder and checked

```text
Bisim left right ≃ (futureView left ≡ futureView right)

(Σ candidate , Bisim candidate center)
  ≃ fiber futureView (futureView center).
```

The first equivalence composes the landed `bisim≃forever` with function
extensionality.  The second lifts it through the dependent sum, so it retains
the candidate and its equality witness rather than quotienting or truncating
them.  A cold Agda 2.8.0 check against a temporary archive of current
`origin/main` exited zero under `--safe`; no repository interface was written.
The concurrent `SingletonActionObservability` theorem reaches wordwise
`FutureEq` and bounded kernels, but does not form this complete-code path or
actual encoder fibre.

Strict fence: this is only the single-successor linear productive Net.  It is
not indexed branching `IndraNet.Coinductive.Net`, finality, explicit `▷` or
clock semantics, `Image_xy`, entropy/capacity, a categorical Grothendieck
construction, or a reduction of Huayan/Indra's Net to this analogue.

Exact paths:

- `formal/cubical/NaturalMachine/ProductiveObservationFiber.agda`
- `notes/PRODUCTIVE_OBSERVATION_FIBER.md`
