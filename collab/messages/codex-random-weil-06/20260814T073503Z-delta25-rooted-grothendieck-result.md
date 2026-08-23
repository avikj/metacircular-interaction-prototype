# Delta 25 / T25.B — rooted total-space controls checked

I consumed the complete authoritative source `UP-D0025`,
`collab/upstream/raw/D0025-eternal-golden-braid-indras-net.txt` (body SHA-256
`6252491ededa435379b7d7b06ec96265cac3d901f42adb1c809c6d9289bb7b04`,
local archive commit `82099ea`).  Its §25.B asks for

```text
U₂ = Σ[ x ∈ U ] View x
```

with projection and fiber equations, under the explicit discipline that
Huayan/Indra's Net is not reduced to category theory.

Repository prior is material: origin commit `f5314e9` already landed
`formal/cubical/IndraNet.agda`.  Its `Rooted` module checks the dependent sum,
first projection, and inherited `fiberEquiv` theorem under Agda 2.6.3/cubical
v0.5.  This message does not claim the first T25.B formalization.

The new disjoint Agda 2.8 module
`NaturalMachine.RootedGrothendieck` extends that exact core with:

- source-matching aliases `U₂`, `π₂`, and
  `π₂-fiber-equation : fiber (π₂ View) root ≃ View root`;
- a named fiber `Iso`, encode/decode maps, and both inverse equations;
- `total-by-root-fibers`, recovering the rooted total space from all actual
  projection fibers;
- a rootwise update of the total space whose projection is definitionally
  unchanged;
- equality controls: equality of total points exposes equality of roots, so
  provably different roots cannot collapse in the dependent sum;
- a constant-family control: fibers over `false` and `true` are equivalent
  while the roots remain unequal;
- a varying-family control: the `Unit` fiber over `false` and `Bool` fiber
  over `true` are not equivalent.

The last two controls enforce both non-reductions:

```text
fiber equivalence  does not imply root equality
root difference    does not supply fiber equivalence.
```

Focused verification:

```text
cd formal/cubical
agda -i . NaturalMachine/RootedGrothendieck.agda
exit 0
```

The module checks under `--cubical --guardedness --safe --no-import-sorts`,
with no postulates or holes.  It is a type-theoretic Grothendieck totalization
of a family on a type/space; it does not claim a category of roots, a
functorial category of elements, Huayan metaphysics, a braid law, history, or
guarded infinite mutual reflection.  Full scope and comparison with
`IndraNet`, `FiniteIndraWeave`, persistent reweaving, and
`ProductiveIndraNet` are in `notes/DELTA25_ROOTED_GROTHENDIECK_TOTAL.md`.
