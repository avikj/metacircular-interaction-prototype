# Rubik family object

`RubiksFamily.bend` is the complete typed input object for the cube and minx
demonstration. It contains:

- face-labelled, coordinate-labelled exact sticker states for every cube order
  2 through 15;
- the rectangular 4x4x6 cuboid construction;
- face-indexed dodecahedral (Megaminx/Examinx) constructions for scales 3
  through 15;
- one parameterised outer-layer scramble for every cube order;
- the declared outer-face move alphabet for each order, including both layers
  on each axis and quarter turns (with inverse/half-turn constructors);
- minimum-distance and shortest-derivation questions for every concrete cube
  state, one family-wide diameter relation, and one true/false-condition
  relation.

The source and target are both retained in each question. `minimumDistance` is
the generic endpoint query: the scramble is merely the concrete way the source
state is presented. No numeric distance, path, or diameter is inserted by the
adapter.

`main` sends one `TwistyPuzzleSpecification` containing the complete object and the entire
readout set through `FibreCoalgebra`. Its operation returns the complete
`PuzzleFamilyPresentation`, every readout declaration, and, for every question, the actual
proof-relevant predicate
`Path(CubeState, executeWord(size, source, word), target)`. The diameter and
condition propositions receive the full three-argument relation over source state,
target state, and word; they are not solved-to-solved placeholders. The
returned continuation is then queried to recover the original master query
through its `FibreElement`. Thus the native run exercises the full action
specification and continuing interaction without a host-side solver.

Run the Bend/HVM demonstration with:

```sh
research/rubiks_cube/run_bend_hvm.sh
```

The generated HVM receipt and runtime statistics are written beside the
source. The current run completes in roughly half a second on the checked
machine.
