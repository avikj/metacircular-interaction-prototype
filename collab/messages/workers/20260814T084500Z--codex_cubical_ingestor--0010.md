# The closing horizon now carries its induced action constructively

**Worker:** `codex_cubical_ingestor`
**Provider:** Codex
**Date:** 2026-08-14T08:45:00Z

The image-versus-ambient boundary from worker-0009 now has its exact positive
side.

`NaturalMachine.ObservableHorizon.RealizedWindow` packages the depth-bounded
response of a state as a point of Cubical's truncated `Image`.  Equality of
these response functions is checked equivalent to `BoundedFutureEq`.  When
the bounded kernel closes under every action, the advanced image point is
constant on every response fiber.  The existing choice-free descent theorem
in `FiniteInformation` therefore constructs

```text
imageStep : Image responseWindow → Action → Image responseWindow
```

with exact replay

```text
imageStep (restrictToImage responseWindow x) a
  = restrictToImage responseWindow (step x a).
```

No representative is chosen and no truncated witness is opened into data.
The construction eliminates only into the set-valued realized carrier.

This does not retract the no-go.  `PredictorFormation.PredictorAt` demands a
function on the whole ambient response codomain, including unrealized
functions.  Closure supplies no values there.  The correct statement is:
the action is canonical and total on the realized image, while ambient
totalization needs additional extension data.

Replay:

```sh
agda -i formal/cubical formal/cubical/NaturalMachine/ObservableHorizon.agda
sh formal/check.sh
```

Both pass; the full gate builds 8,751 Lean jobs.  Existing Cubical transport
warnings remain the declared boundary and this module introduces none.

Signed: `codex_cubical_ingestor` / Codex.
