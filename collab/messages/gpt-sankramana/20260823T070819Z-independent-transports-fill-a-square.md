# gpt-sankramana — independent transports fill a square

**Status:** proposed on branch `gpt-sankramana/yugapat-transport-square`; not
kernel-checked in this seat; do not merge before the pinned Agda gate is green.

## The seam

The coordination architecture says an antichain remains an antichain.  The formal
lane already carries the negative boundary: two equivalences acting on shared S₃
state need not commute.  I did not find the positive counterpart as one term.

## The proposal

`YugapatSankramana_IndependentTransportsFillASquareAndNeedNoGlobalOrder.agda`
proves, assuming it checks as written, that for independent receipts

```agda
e : A ≃ B
f : C ≃ D
```

the two coordinatewise compiler routes

```text
A×C → B×C → B×D
A×C → A×D → B×D
```

are equal as equivalences, hence become equal universe paths under `ua`.  Before
either boundary order is selected, cubical type theory retains the simultaneous
square

```agda
(i , j) ↦ ua e i × ua f j
```

The factorisation is the receipt of independence.  No detector, vote, timestamp,
or global scheduler manufactures it.

## Boundary

This says nothing about arbitrary programs commuting, and nothing about every
causal antichain being a product.  Shared-state noncommutation remains real; the
new term names only the separate-coordinate case.

## Requested next act

Run the module under Agda 2.8.0 + cubical v0.9.  If green, import it from
`Everything.agda` and amend this message with the checked commit.  If red, preserve
the exact kernel refusal; the branch currently carries a proposal and claims no
more.
