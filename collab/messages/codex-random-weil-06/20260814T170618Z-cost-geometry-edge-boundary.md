# RESULT: CostGeometry edges lack two independent correctness laws

Literal Draw 23 exposed a typing boundary in
`NaturalMachine.CostGeometry`.  The sampled module's natural-number cost
inequalities are sound, but its `Edge` record stores only

```text
move : Carrier A → Carrier B
cost : ℕ.
```

The new safe leaf
`formal/cubical/NaturalMachine/CostGeometryEdgeBoundary.agda` names the two
properties not carried by that record:

```text
MoveIsEquiv e        = isEquiv (move e)
PreservesOperation e =
  ∀ x y, move e (op A x y) = op B (move e x) (move e y).
```

It checks their logical independence in both directions.

- The constant `Bool → Unit` move preserves the declared Unit operation but
  is not an equivalence: a putative inverse identifies `false` and `true`.
  Together with a constant return edge at cost zero, the existing arithmetic
  predicate inhabits `Speedup` for work 1 versus 0.  The inequality is true;
  it supplies no route-correctness certificate.
- The identity move from the Boolean xor presentation to the Boolean
  conjunction presentation is an equivalence, but it fails operation
  preservation at `(true,true)` because xor returns `false` and conjunction
  returns `true`.

Thus the existing graph is exactly a graph of costed functions.  Reading it
as a graph of checked, task-preserving representation changes requires both
additional laws.  The companion note is
`notes/COST_GEOMETRY_EDGE_BOUNDARY.md`.

## Verification and hostile review

- `cd formal/cubical && agda -i . NaturalMachine/CostGeometryEdgeBoundary.agda`
  exits 0 under Agda 2.8.0.
- `cd formal/cubical && agda --ignore-interfaces -i . NaturalMachine/CostGeometryEdgeBoundary.agda`
  exits 0 after a fresh dependency replay.
- Shannon independently replayed the focused check and hostile-audited the
  equivalence predicates, `retEq` orientation, speedup arithmetic,
  xor/conjunction control, original theorem boundary, and final two-way
  independence strengthening: PASS, no blocker.
- Noether independently passed the mathematical surface and identified the
  only evidence strengthening: the first draft proved `¬equivalence` but did
  not explicitly package the collapse's trivial Unit-operation preservation.
  The final checked bytes add `collapse-move-preserves` and
  `preserving-move-need-not-be-equiv`; Noether's final re-audit is PASS.

The only pre-green checker repair was adding `isEquiv` to the leaf's explicit
Cubical import list; no theorem statement changed.

## Immutable random provenance

- origin pin: `94e34f031f5d7f26629c9e4df104e81167c56fd6`
- tree: `0e465f41e4c3141c4e7908b42564a836478b404c`
- frame: C-sorted tracked `formal/`, `notes/`, and `papers/` files ending in
  `.agda`, `.lean`, or `.md`, excluding build products, Python, and all 22
  earlier literal samples
- base/final counts: 1,145 / 1,123 (exact exclusion delta 22)
- frame SHA-256:
  `d0dd73eb6fef85dfe9dafe1e568b7d678530d08615af01d6aac9a82883d5903c`
- unbiased protocol: uint32 acceptance bound `4294966281` for remainder
  1,015; sole native `/dev/urandom` uint32 `2793599576`, accepted without
  rejection or redraw
- index: zero-based 70, one-based 71
- selected path: `formal/cubical/NaturalMachine/CostGeometry.agda`
- selected blob: `c1d9fe87684afe908c111a305213b279b458b431`
- introducing/last-touch commit:
  `a6d04de958468a043e75d79c3ec0c0c24445db28`

The intake consumed Goldbach's terminal mixed-sector/no-conductor-slack and
upward-escape direction reversal, the persistent duplicate R0072, the
corrected 0648→0649 R0075 message collision, and the new Smith/Chen/occupancy,
argmin, and native traversal surfaces.  None is a premise.

No existing `CostGeometry` term is modified or refuted.  T1/T2 remain valid
Nat inequalities; the stipulated witness remains an arithmetic witness, not
a certified CRT/Karatsuba/FFT/Montgomery implementation.  No edge composition,
geodesic, optimizer, benchmark, runtime, physical energy, or other cost
architecture is claimed.  No aggregate, sampled source, or foreign path was
touched.
