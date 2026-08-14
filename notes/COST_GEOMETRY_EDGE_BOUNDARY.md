# CostGeometry edges do not yet certify representation change

The arithmetic in `NaturalMachine.CostGeometry` is sound. Its `detour`,
`Speedup`, `NoSpeedup`, `transport-is-never-free`, and
`speedup-forces-better-neighbour` statements are exact inequalities in
natural-number costs.

The sampled module's interpretation is stronger than its current type,
however. Its header says that a checked equivalence is an edge, and the
companion note describes a network of presentations linked by checked
equivalences. The actual record is only

```text
record Edge (A B : Presentation) where
  move : Carrier A → Carrier B
  cost : ℕ
```

It carries neither evidence that `move` is an equivalence nor a law saying
that `move` preserves the operations stored in `A` and `B`.

The safe correction leaf
`formal/cubical/NaturalMachine/CostGeometryEdgeBoundary.agda` names the two
missing properties without changing the old record:

```text
MoveIsEquiv e          = isEquiv (move e)
PreservesOperation e   =
  ∀ x y, move e (op_A x y) = op_B (move e x) (move e y)
```

## Two independent controls

First take the Boolean xor presentation and the one-point Unit presentation.
The constant map `Bool → Unit` and a return map `Unit → Bool` are both
valid existing `Edge` values at cost zero. The forward move cannot be an
equivalence: an inverse would identify `false` and `true`. Nevertheless, with
home work one and far work zero, the existing arithmetic predicate calls the
zero-cost route a `Speedup`. The inequality `0 < 1` is correct; what is absent
is a correctness certificate for the route. The collapse does preserve the
declared Unit operation (both sides are definitionally `tt`), so this control
also proves that operation preservation does not imply carrier equivalence.

Second keep the carrier `Bool` on both sides, with xor as the source
operation and conjunction as the target operation. The identity function is
an equivalence, so the first missing property holds. But at `(true,true)` it
sends xor's `false` to `false` while conjunction returns `true`. Thus an
equivalence of carriers does not by itself certify that the same task is
implemented on both presentations.

These controls are independent:

- an `Edge` need not have an equivalence-valued move;
- even an equivalence-valued move need not preserve the presented operation.

Consequently the current graph is exactly a graph of costed functions. To
read an edge as a checked, task-preserving representation change, both laws
must be supplied (and a stronger application may need further observational
or complexity-model compatibility).

## What remains valid

No existing theorem term is changed or contradicted. T1 and T2 quantify over
the weak `Edge` type and use only its cost field, so their natural-number
conclusions remain valid even on the hostile controls. The correction limits
their interpretation: `Speedup` currently proves that one declared cost sum
is smaller than another, not that a correct algorithm has been transported.

The stipulated 100/10/20 witness in `CostGeometryWitness` remains a checked
arithmetic instance. It is still not a certified CRT, Karatsuba, FFT, or
Montgomery implementation, and this leaf constructs none of those.

## Scope and provenance

This is an interface obstruction, not a replacement cost architecture. It
does not define edge composition, path cost, geodesics, amortization,
benchmarks, physical energy, proof length, bandwidth, or an optimizer. It
does not claim that operation preservation alone is sufficient for every
notion of program correctness.

Literal Draw 23 froze origin
`94e34f031f5d7f26629c9e4df104e81167c56fd6`, tree
`0e465f41e4c3141c4e7908b42564a836478b404c`, and selected
`formal/cubical/NaturalMachine/CostGeometry.agda`. Full frame, random-word,
verification, and hostile-review provenance will be recorded in the result
message after the leaf is cold-checked.

No aggregate or sampled-source edit belongs to this workset.
