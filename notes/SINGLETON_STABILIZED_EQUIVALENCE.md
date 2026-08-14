# A stabilized singleton window is bisimulation under set-valued observation

## Result

`formal/cubical/NaturalMachine/SingletonStabilizedEquivalence.agda` closes the
conditional proof-relevance boundary stated in
`SINGLETON_ACTION_OBSERVABILITY.md`.

For a productive unary net, assume:

1. `ObservableClosesAt` for the chosen finite fuel; and
2. `isSet (TotalView Root Jewel)`.

Then the existing maps between bounded future equality and productive
bisimulation form a checked equivalence of witness types:

```text
productiveBounded≃bisim :
  BoundedFutureEq (...) fuel left right ≃ Bisim left right.
```

The proof does not guess the inverse laws. Equality in a set-valued
`TotalView` is a proposition, so `BoundedFutureEq` is a dependent product of
propositions. `ForeverEq` is likewise a dependent product of propositions,
and `ProductiveObservabilityBridge.bisim≃forever` transports this property
back to `Bisim`. The already checked maps can therefore be packaged by
`propBiimpl→Equiv`.

The direct hypothesis is set-valued observation. A corollary derives it from
`isSet Jewel`, since

```text
TotalView Root Jewel = Root → Root → Jewel.
```

No set hypothesis on `Root` is needed.

## Two load-bearing boundaries

Action closure is not administrative. The leaf proves that any **uniform**
map from bounded equality to bisimulation already implies
`ObservableClosesAt`. Consequently a bounded collision separated by any
later action word rules out such an upgrade, by the existing
`bounded-collision-obstructs-closure` theorem.

Set-valued observation has a different role: it makes both witness types
propositions, so maps both ways determine an equivalence. It is a sufficient
condition, not a claimed necessary one. Without it, the two maps from
`SingletonActionObservability` remain valid, but proof-relevant equality
families can carry higher data and no inverse laws follow merely from having
maps in both directions.

## Scope

This is still the linear one-action `ProductiveIndraNet`. It does not extend
to the index-changing, all-branch `IndraNet.Coinductive.Net`, construct a
later modality or clocks, prove a final-coalgebra universal property, or
discover closure from finite-state decidability. It is an exact conditional
upgrade of one checked analogue, not a reduction of Huayan/Indra's Net to a
transition system.

## Draw provenance

Literal no-redraw Draw 5 froze origin
`98d8b18c8d1f20a47bb311400049180180ac6086`, tree
`34723a9bbe2617b502d097eccfa4f4805c9671ac`. The 1,064-path C-sorted semantic
frame excluded build products and all four earlier samples; SHA-256 was
`fc175df030d186a65631232b80491dd9fbba505036096403008290d0e37f45d9`.
Rejection limit `4294966872`, accepted `/dev/urandom` uint32 `1530525574`,
zero rejections, index 942, selected `notes/SINGLETON_ACTION_OBSERVABILITY.md`
(blob `3cbeef3f605c17175753cbb25e698df39a3d34a4`). No redraw.
