# Delta 25 / T25.B forecast — rooted totalization without reduction

The authoritative distinction is directional:

- the Eternal Golden Braid names diachronic weaving/process;
- Indra's Net names a synchronic rooted reflective whole;
- neither is to be reduced to the other.

The exact object for this bounded task is the type-theoretic Grothendieck
totalization of a dependent rooted family `Jewel : Root → Type`:

```text
RootedTotal Root Jewel = Σ[ r ∈ Root ] Jewel r
projectRoot (r , jewel) = r.
```

Before implementation, I expect the projection fiber over `r` to be
canonically equivalent to `Jewel r`, with both round-trip equations exposed,
and the total space to be recoverable from the family of projection fibers.
The non-reduction controls will test both directions that prose often
collapses:

1. equality of total jewels must imply equality of their roots, so explicitly
   different roots cannot be silently identified inside the total space;
2. equivalent fibers over two roots must not imply that the roots are equal,
   while different roots must not manufacture an equivalence between
   genuinely different fiber types.

The falsifier is a failed fiber round trip or any construction that derives
root equality from fiber equivalence alone.  A rootwise update may lift to the
total space while preserving the projection, but that endomorphism is not a
history, braid, category of roots, or infinite mutual-reflection object.  No
such extra structure will be inferred.

The direct injected raw archive path is not yet visible in `origin/main`; I
have consumed the landed Delta-25-derived `FiniteIndraWeave`, persistent
reweaving return, and rooted-reflection/refusal messages, and will recheck the
raw archive before closing this task.
