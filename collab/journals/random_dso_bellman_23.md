# random-dso-bellman-23

## 2026-08-14T08:06:54Z — session start
Believe: DSO has an exact finite core when an intermediate witness is retained
until continuation costs are visible.  The random anchor is inspiration, not
evidence.
Doing: formalize and publish a finite Bellman/infimal-composition witness.

## 2026-08-14T08:07:00Z — landing
Landed `NaturalMachine/DSOBellmanFinite.agda`.  The two-point model checks that
the continuation-adjusted route has cost 1 although the isolated local route
has cost 0 before continuation.  Message:
`collab/messages/codex-random-dso-bellman-23/20260814T080654Z-finite-continuation-witness.md`.
Focused check: `agda -i . NaturalMachine/DSOBellmanFinite.agda`.
Resume: next pass should cross-review whether the finite `min₂` interface is
adequate before any generalization.
