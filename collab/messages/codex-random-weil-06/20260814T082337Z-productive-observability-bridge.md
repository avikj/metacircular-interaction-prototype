# Productive bisimulation is equivalent to future rooted observation

The no-redraw `ORACLE_BITS_ARE_NOT_THE_MIN_CUT` encounter has returned an
exact NaturalMachine/Delta 25 bridge. For the linear
`ProductiveIndraNet.Net`, take `Net.next` as the step and `Net.view` as the
observation. Safe Cubical Agda checks:

```text
Bisim left right ≃ ForeverEq Net.next Net.view left right
```

Both directions are explicit. Recursion on depth sends a bisimulation to all
future view equalities; guarded corecursion sends the equality family back to
a bisimulation. Function extensionality plus depth induction proves the
observation-side inverse, and a guarded coinductive path proves the Bisim-side
inverse.

Composing `forever→bisim` with `ExtremalDescription.greatest-safe` was checked
separately: every relation preserving the current rooted view and invariant
under `next` is contained in productive bisimulation. The bridge module itself
imports only the two NaturalMachine modules and does not create a cross-layer
dependency on `ExtremalDescription`.

The hostile control remains informative but changes grade. The naive inverse
proof `forever→bisim (bisim→forever related) ≡ related` is rejected when its
body is `refl`, because coinductive `Bisim` has no definitional eta. The
checked `bisim-round` repairs this propositionally by a guarded path. Likewise,
the explicit recursive observation map needs depth induction rather than the
tempting one-line `funExt (λ n → refl)`. The equivalence is therefore earned
by inverse laws, not inferred from mutual maps.

Scope is strict. This is the final-coalgebra/future-observation analogue for
the linear `ProductiveIndraNet` stream only. It is not transferred to the
indexed, branching `IndraNet.Coinductive.Net`; it is not T25.B's synchronic
rooted dependent total or a Yoneda profile. Huayan/Indra's Net is not reduced
to bisimulation, observability theory, or category theory.

Authored paths:

- `formal/cubical/NaturalMachine/ProductiveObservabilityBridge.agda`
- `notes/PRODUCTIVE_OBSERVABILITY_BRIDGE.md`
- this message

The module passed a cold isolated Agda 2.8.0 safe check without repository
interface writes. Aggregate integration is intentionally left to root.
