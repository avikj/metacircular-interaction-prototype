# Productive future fibres do not become quotient carriers

**Status:** checked Cubical adapter and scoped translation refusal.  The leaf
module is
`formal/cubical/NaturalMachine/ProductiveFiberQuotientAdapter.agda`.

`ProductiveObservationFiber` retains the full homotopy fibre of the complete
future-view encoder over a chosen centre:

```text
FutureViewFiber center
  = Σ candidate , futureView candidate ≡ futureView center.
```

That object is proof-relevant data over one code.  It is not the carrier of
all observable meanings.  The latter is the set quotient of all productive
Nets by complete singleton-action future equality.

## Exact adapter

Assume only that `Jewel` is a set.  Since

```text
TotalView Root Jewel = Root → Root → Jewel,
```

function extensionality makes `TotalView` a set; no set hypothesis on `Root`
is required.  The checked equivalences

```text
Bisim ≃ (futureView left ≡ futureView right)
Bisim ≃ singleton-action FutureEq
```

then turn a path carried by the encoder fibre into the relation used by
`FutureQuotient`.  The adapter defines

```text
fiberToMeaning : FutureViewFiber center → FutureQuotient.Meaning
```

by sending a fibre point to the meaning class of its candidate, and proves

```text
fiberToMeaning-constant :
  fiberToMeaning center ≡ (λ _ → [ center ]).
```

Thus every candidate in the complete-code fibre maps to the single meaning
class of the centre.  The equality witness is used to construct that quotient
path; it is not silently erased before the proof.

## Translation killed

The future-view fibre and future quotient solve different problems:

- the fibre retains candidates and paths over one selected observation code;
- the quotient ranges over every code and identifies candidates sharing one;
- the checked map from a fixed fibre to the quotient is constant, not an
  equivalence with the quotient carrier.

Moreover, without `isSet Jewel`, `TotalView` is not known to be a set.  The
repository's `FutureBehavior.FutureQuotient` interface therefore cannot be
instantiated: its effectivity and universal property require the
future-equality relation to be proposition-valued.  Calling the unrestricted
productive fibre a behavioral set quotient would insert proof irrelevance or
truncation that no theorem supplies.

This does not weaken the fibre theorem.  It locates its extra information:
candidate-level and path-level structure survives in the homotopy fibre and is
collapsed only when an explicitly set-valued behavioral consumer is chosen.

## Replay

```sh
agda -i formal/cubical \
  formal/cubical/NaturalMachine/ProductiveFiberQuotientAdapter.agda
agda -i formal/cubical formal/cubical/NaturalMachine.agda
sh formal/check.sh
```

