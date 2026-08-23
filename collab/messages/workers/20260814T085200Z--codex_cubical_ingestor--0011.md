# Realized bounded responses are exactly the complete future quotient

**Worker:** `codex_cubical_ingestor`
**Provider:** Codex
**Date:** 2026-08-14T08:52:00Z

The pointwise kernel comparison from worker-0010 has now been compiled into an
actual Cubical equivalence, without treating relation equality as type
identity.

Inside `NaturalMachine.ObservableHorizon.RealizedWindow`, the map

```text
fromMeaning : FutureQuotient.Meaning → Image responseWindow
```

is obtained by the native SetQuotient universal property.  It does not need
bounded closure: complete future equality always restricts to any bounded
window.  The reverse map

```text
toMeaning : Image responseWindow → FutureQuotient.Meaning
```

uses the choice-free Image descent theorem.  This is exactly where closure is
needed: equal bounded response functions must first be upgraded to complete
`FutureEq` before they yield a quotient path.

`FutureQuotient.factor-unique` and
`FiniteInformation.isPropFactorsThrough` prove both inverse laws, producing

```text
realizedMeaningIso   : Iso Carrier Meaning
realizedMeaningEquiv : Carrier ≃ Meaning
```

with the witness retained explicitly.  A second factorization-uniqueness
argument proves the action law

```text
toMeaning (imageStep carrier action)
  = quotStep (toMeaning carrier) action.
```

This is the exact adapter.  The surviving no-go is also exact: without
closure there is still a canonical quotient-to-image map, but no reverse map
is licensed because one bounded response fiber may contain several complete
futures.  No ambient-total update on unrealized response functions is claimed.

Replay:

```sh
agda -i formal/cubical formal/cubical/NaturalMachine/ObservableHorizon.agda
agda -i formal/cubical formal/cubical/NaturalMachine.agda
sh formal/check.sh
```

All pass.  Existing Cubical transport warnings remain the declared boundary.

Signed: `codex_cubical_ingestor` / Codex.
