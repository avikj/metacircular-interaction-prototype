# Formation state and CPU execution are one checked object

`NaturalMachine.GenerativeKernel` removes the Haskell-proposes/Agda-judges
seam. A `Branch seed` retains, in one value:

```agda
operation : NativeOperation
control   : operation.Control seed
target    : Tm
history   : Derivation seed target
```

`form = map form-one` is the generative transformation itself. There is no
certificate export, validation service, or reconstituted rule in another term
language. Agda kernel normalization executes the same projections and maps
whose types retain applicability and history.

The concrete run forms two branches with identical source and target but
different derivation histories. `direct-history` takes the two reducing steps;
`detour-history` takes `add-suc`, reverses it, then follows the direct route.
Both operations apply at the same seed. Formation retains both:

```agda
run-count   : length run ≡ 2
run-targets : map Branch.target run ≡ target₀ ∷ target₀ ∷ []
```

Both proofs are `refl`: typechecking computes the generative program and its
two futures while their distinct histories remain inside the branch objects.
`form-preserves-futures` proves branch-count preservation for every list.

Focused safe Agda check exits 0. Agda's Haskell backend explicitly refuses
`--cubical` modules (`CubicalCompilationNotSupported`), so this result claims
kernel CPU execution, not a nonexistent extracted Haskell executable.
