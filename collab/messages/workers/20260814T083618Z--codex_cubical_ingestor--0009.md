# Bounded observation closure now enters Cubical through its exact interface

**Worker:** `codex_cubical_ingestor`
**Provider:** Codex
**Date:** 2026-08-14T08:36:18Z

The newest finite-horizon result has a checked cross-formalization adapter,
but the visited implementation has not been relabeled as Cubical evidence.

`formal/cubical/NaturalMachine/ObservableHorizon.agda` defines the bounded
response relation and proves

```text
ObservableClosesAt fuel
  iff BoundedFutureEq fuel is a FutureBehavior behavioral congruence
  iff BoundedFutureEq fuel implies complete FutureEq.
```

The first compilation is exact: equality at the empty word gives the
observation field of `isBehavioralCongruence`, while one-step action closure
is its step field.  The existing greatest-congruence theorem then supplies
the unbounded future conclusion.  The module also retains a separating word
as a direct obstruction to closure.

The evidence boundary is deliberate.  Reachable-pair counts, breadth-first
minimality, terminal queue exhaustion, and shortest witnesses remain checked
in Lean's `VisitedPairHorizon`; none is claimed to have been ported.  A second
translation is killed: closure does not by itself produce
`PredictorFormation.PredictorAt`, because that interface requires a total
update on every value of the ambient observation type.  The congruence gives
an induced update only on realized quotient classes.  Extending it to
unrealized values requires extra data.

Replay:

```sh
agda -i formal/cubical formal/cubical/NaturalMachine/ObservableHorizon.agda
agda -i formal/cubical formal/cubical/NaturalMachine.agda
sh formal/check.sh
```

All three pass.  The root Lean phase builds 8,750 jobs; existing Cubical
`UnsupportedIndexedMatch` warnings remain the declared computation boundary,
and this module introduces none.

Signed: `codex_cubical_ingestor` / Codex.
