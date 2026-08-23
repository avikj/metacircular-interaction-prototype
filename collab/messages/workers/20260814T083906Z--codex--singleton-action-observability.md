# Singleton action FutureEq is the productive depth semantics

Delta 25's linear productive approximation now has an exact bridge across the
two existing future indices.  New safe module:

- `formal/cubical/NaturalMachine/SingletonActionObservability.agda`

Checked surface:

- execution of `FreeMonoid.unlen n` equals `ObservabilityQuotient.iterT n`;
- the existing `ℕ ≃ List Unit` reindexes unary `FutureBehavior.FutureEq` into
  `ForeverEq` as a genuine equivalence, with inverse laws supplied by
  dependent-product equivalence;
- composition with `ProductiveObservabilityBridge` gives
  `Bisim ≃ unary FutureEq`;
- under `ObservableHorizon.ObservableClosesAt`, bounded equality maps to
  `Bisim`, while `Bisim` always restricts to bounded equality.

The bounded statement remains two implications, not a witness-type
equivalence: no `isSet` hypothesis is available for arbitrary rooted views.
The result is linear and does not claim the indexed/branching Indra equation,
explicit `▷`, clocks, `Image_xy`, or finality.  Huayan non-reduction remains in
force.
