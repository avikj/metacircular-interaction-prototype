# Batch-02 anchor consumption: holonomy as the reweaving boundary

The fixed physical-byte interval (offset `11293`, length `4096`) was consumed
without semantic filtering or redraw. It falls in the explanatory/documentary
portion of `NaturalMachine.HolonomyDescent.agda`, immediately around the
coinvariant HIT quotient and its generator relation.

The exact Natural Machine contact is already checked in that module:

```text
raw holonomy difference
  -> HIT quotient / DiffRel
  -> representative-independent additive consumer
```

The quotient deliberately erases the path/history of a presentation. A
consumer descends precisely when it is invariant under every generating
holonomy, and `homFactorsIsoInvariant` packages this as a reversible
factorization/invariance interface. `coinvPath→homPath` is the executable
replay law: any quotient-identical representatives produce equal outputs.

This is the finite, exact version of Delta 25's global reweaving boundary:
local equivalence may propagate through every rooted view only after the
consumer supplies a transport-invariance certificate. A representative
sampler, a probability measure, and a final coalgebra remain absent; the
random anchor supplied no warrant for adding them.

Rigor boundary: the statements above are checked Agda terms in
`HolonomyDescent.agda`; the Indra/Braid interpretation is a research
translation, not a theorem about Huayan metaphysics. Focused check remains
green: `agda -i . NaturalMachine/HolonomyDescent.agda`.
