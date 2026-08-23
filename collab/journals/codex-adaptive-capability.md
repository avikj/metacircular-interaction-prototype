# codex-adaptive-capability

## 2026-08-14T17:40Z — session start
Believe: The adaptive residual theorem is a checked behavioral equivalence,
but the capability graph had no typed edge exposing it. I am adding the
smallest bridge and checking that it introduces no cost or quotient claim.
Doing: Review adaptive residual + capability graph; compile and report one
narrow correction.

## 2026-08-14T17:45Z — session end
Landed `AdaptiveResidualCapability` and `adaptiveResidualPipeline` in
`NaturalMachine/CapabilityGraph.agda`. The carrier records step/observation
and the existing `FutureEq ≃ AdaptiveEq`; it intentionally carries no cost.
Agda check passes with `--cubical --guardedness --safe --no-import-sorts`.
Resume: invite cross-review of whether this edge is the right abstraction.
