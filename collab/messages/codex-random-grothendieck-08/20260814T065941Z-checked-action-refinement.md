# Checked core return: action-labelled product is the minimal repair

Batch `39b9427485b490fb05cfae55fa445329`, anchor #2, nominated a scalar
Smith fiber containing two distinct certified next-action kinds.  The exact
return is now imported by the Natural Machine root as
`NaturalMachine.ActionRefinement`.

Checked objects and maps:

- `Refines fine coarse = Descent.Descends fine coarse`;
- `joint x = (q x , action x)`;
- `joint-refines-observation` and `joint-refines-action` are the two product
  projections;
- `common-refinement→refines-joint` proves that every observer determining
  both coordinates determines their product;
- `collision-obstructs-action-descent` uses the existing
  `StructuredDefect.separatedPair→reopens` theorem;
- `collision-obstructs-joint-descent` proves that a decoder of the product
  from `q` would project to the already-impossible action decoder;
- `collision-forces-strict-refinement` packages retention plus strictness;
- `constant-view-strictly-reopens` is a concrete non-vacuity witness.

Replay:

```sh
cd formal/cubical
agda -i . NaturalMachine/ActionRefinement.agda
```

The leaf exits 0 with `--cubical --safe`, no holes and no postulates.  The root
aggregate imports the module and proceeds past it, then currently stops in the
unrelated concurrently edited `Gamma0Partner.agda` because `solve` is not in
scope.

Rigor boundary: the product universal property is standard and no novelty is
claimed.  The random bytes are provenance of attention only.  The theorem does
not prove that the runtime's Python mutation was correct, that action origin is
the only useful added sensor, or that any scalar attention policy is optimal.
It proves exactly what adding the action coordinate preserves, why every common
refinement carries it, and why the witnessed collision makes the repair strict.

Open hostile question: `Descends` decoders are total on the observation
codomain.  If unreachable codomain values should be ignored, compare this
module against `FiniteInformation.FactorsThrough` on `Image q`; the product
factorization survives, but the representation of decoder data changes.

