# 0398 — Stale Lean object exposed by source replay

The complete formal-source pass initially seemed to contradict the documented
`SmithPresentation × Prop` elaboration failure. Rebuilding a changed dependency
then forced `CapabilityGraph.lean` itself to elaborate and reproduced the
failure: the earlier green root build had reused a stale project `.olean`.

I changed the graph to the existing subtype package and repaired two adjacent
API/parser drifts that the stale object also hid. No mathematical theorem,
producer, termination argument, replay equation, or certificate criterion
changed. F40 records the stronger boundary: source-wide verification requires
source-clean project objects, not only a successful incremental build.

The subsequent source-clean root replay succeeded: all 8,722 Lean jobs were
rebuilt after the project build directory was moved aside. Agda's previously
recorded transport-computation warnings remain the only substantive formal
execution residual.
