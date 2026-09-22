# Rubik family construction worklog

## 2026-09-19

- Scope: encode concrete cube/minx/cuboid constructions and declarative target
  questions in Bend/HVM; pass complete objects to the existing coinductive
  fibre process.
- Constraint: do not implement a solver, search routine, symmetry quotient,
  diameter algorithm, or hand-written factorization. Those are demands on the
  supplied mathematical object.
- Required outputs: target-reaching derivations, proof lengths, conditions for
  propositions and their negations, and family-wide diameter readouts.
- Families requested: 3x3 and higher NxNxN cubes through 15x15, rectangular
  cuboids including 4x4x6, Megaminx/dodecahedral scales including Examinx,
  and further supplied variants.
- Current phase: inspect existing Bend coinductive/fibre ports and choose the
  smallest faithful state/action encoding that remains declarative.
- Existing execution seam confirmed: `WholeProcess.bend` accepts an arbitrary
  typed source plus an arbitrary typed operation and returns the carried value,
  reconstruction receipt, and continuation. `HLevelOfInteraction.bend` and
  `Prashna.bend` expose the richer indexed coinductive response shape.
- The cube file must therefore define the actual puzzle source and declarative
  target/diameter readings, then query the existing process; it must not add a
  bespoke search loop.
- `RubiksFamily.bend` now contains exact labelled facelets for NxN cubes,
  rectangular cuboid facelets (including 4x4x6), and dodecahedral/megaminx
  face-indexed stickers for every requested scale. The complete object carries
  all instances and all demands together. The concrete questions include the
  minimum-distance query (the same source/target semantics as a scramble), a
  family-wide diameter query, and the true/false-condition query.
- `passCompleteObject` sends that one complete typed object through
  `WholeProcess.interact`, retaining the returned `Carrier`, reconstruction
  path, and continuation. No host-side search or solver is added.
- `MasterQuery` now packages every requested readout—minimum distances,
  shortest derivations, diameters, true/false conditions, family symmetries,
  proof lengths, exact reconstruction, and continuation—alongside that one
  complete object. `runMaster` sends this package through the coinductive
  process in one query and performs the continuation recovery interaction.
- Every concrete order 2 through 15 now contributes both a minimum-distance
  and shortest-derivation question. Diameter and truth/false conditions carry
  the complete relation over arbitrary source state, target state, and move
  word, so they no longer reuse a solved-to-solved endpoint as a stand-in.
- `rubikOperation` now returns a `RubikEvaluation` containing the complete
  `FamilyObject`, every generated proof-relevant specification, and the full
  readout declaration. The operation no longer projects away the construction
  list while producing the specifications.
- Naming pass: the Rubik source now uses `FibreCoalgebra`, `FibreObservation`,
  `FibreElement`, `TwistyPuzzleSpecification`, `PuzzleFamilyPresentation`,
  `PropositionForm`, `RequestedObservation`, `ReachabilityProposition`, and
  map/query names such as `executeWord`, `reachesTarget`, and
  `evaluateSpecification`. These are the precise mathematical terms; the
  older names remain only in compatibility ports used by unrelated snapshots.
- Bend compilation and HVM emission succeed. `main` now performs two native
  interactions: it passes the complete object through `WholeProcess`, then
  uses the retained continuation and `Carrier` ascent to recover the source.
  The current HVM run completes in 0.265 seconds with 21,458,722 interactions
  and 55,021,381 heap nodes (`hvm-runtime.log`). The first interaction carries
  the actual `Path`-valued Rubik reachability predicates for every packaged
  question; the second interaction recovers the original `MasterQuery`.
- The family dimensions stay parametric in the source object, while concrete
  every cube size 2 through 15 is materialised in the minimum-distance
  question list. The `Construction` list simultaneously carries all cube
  scales, the 4x4x6 cuboid, and every requested minx/Examinx scale as typed
  parametric constructions. HVM completes the expanded object and both
  interactions in the current native run. The outer-layer scramble is parameterized by N, so the 2x2 case
  is a real move word rather than an out-of-range no-op.
- The Bend emitter's ordinary validation and HVM execution succeed. Bend's
  stricter `--total` report still labels the finite U64 cursor builders
  `faceRow` and `cuboidRow` as unchecked; this is recorded rather than
  presented as a totality proof. The native evaluator nevertheless reduces
  the supplied finite orders completely, with the receipt above.
- Existing repository math already supplies a useful concrete action pattern:
  the braid files define word actions, factor each crossing into swap plus
  twist, compute the transported twist word, and prove equality from the
  permutation action plus twist residues. This should be reused as supplied
  mathematics where the cube/minx constructions instantiate the same
  symmetry/action data; no new symmetry theory should be invented here.
- The Bend port `MyhillNerodeMinimalMachine.bend` exposes the intended
  machine input directly: `Machine` carries `State`, `Action`, `Obs`,
  `step`, and `observe`; `crystal` constructs the behavioural quotient while
  preserving the action and observations. This is the correct existing
  calculus entry for a puzzle family, rather than a hand-written solver.
- `CorpusCalculus.bend` gives the generic typed question/target/receipt
  coalgebra, while `WholeProcess.bend` gives the carried source/fibre
  continuation. The cube family should instantiate these with actual puzzle
  state/action functions and pass the complete family plus declarative
  diameter/target readings in one query.
