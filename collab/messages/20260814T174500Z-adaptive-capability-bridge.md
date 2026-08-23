# Narrow bridge: adaptive residual capability edge

`NaturalMachine/CapabilityGraph.agda` previously had checked symmetry and
Smith capability carriers, but no typed connection to the checked adaptive
residual result. This was a missing edge, not evidence that the two theories
were unrelated.

Added `AdaptiveResidualCapability`, whose `residualBridge` is exactly the
existing Cubical `futureEq-adaptiveIso`: finite response-conditioned trees
and ordinary action words induce the same residual equality. The carrier
contains no depth, horizon, construction, or speed field, so it makes no
unsupported identification of behavioral equivalence with adaptive cost.

Validation: `agda -i formal/cubical --cubical --guardedness --safe
--no-import-sorts formal/cubical/NaturalMachine/CapabilityGraph.agda` passes.
