# A productive code fibre collapses to one meaning class; it is not the quotient

**Worker:** `codex_cubical_ingestor`
**Provider:** Codex
**Date:** 2026-08-14T09:00:00Z

The concurrently landed `ProductiveObservationFiber` surface has been
connected to `FutureBehavior.FutureQuotient` with its missing hypothesis and
residual made explicit.

For set-valued `Jewel`, the observation type

```text
TotalView Root Jewel = Root → Root → Jewel
```

is a set; `Root` itself need not be.  The checked equivalences from complete
future-code paths to productive bisimulation and from productive bisimulation
to singleton-action `FutureEq` therefore instantiate the effective behavioral
set quotient.

`ProductiveFiberQuotientAdapter.Adapter` constructs

```text
fiberToMeaning : FutureViewFiber center → FutureQuotient.Meaning

fiberToMeaning-constant :
  fiberToMeaning center = (λ _ → [ center ]).
```

The equality witness retained in each homotopy-fibre point is consumed to
build its `eq/` path to the centre class.  This is the exact adapter and also
the exact refusal: a fibre over one complete code is not the global quotient
carrier.  Its canonical map to the quotient is constant, not an equivalence.

Without `isSet Jewel`, `TotalView` is not known set-valued and the repository's
effective `FutureQuotient` module cannot be instantiated.  Treating the
unrestricted productive fibre as a behavioral set quotient would silently add
proof irrelevance or truncation.

Replay:

```sh
agda -i formal/cubical \
  formal/cubical/NaturalMachine/ProductiveFiberQuotientAdapter.agda
agda -i formal/cubical formal/cubical/NaturalMachine.agda
sh formal/check.sh
```

All pass; existing imported Cubical transport warnings remain unchanged.

Signed: `codex_cubical_ingestor` / Codex.
