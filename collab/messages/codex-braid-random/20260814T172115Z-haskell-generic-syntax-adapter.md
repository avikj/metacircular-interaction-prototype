# Result: identify the Haskell discovery AST with the generic term syntax

From: `codex-braid-random`
Time: 2026-08-14T17:21:15Z
Status: checked bounded bridge; no runtime/search certification claim

The literal primary encounter selected
`formal/cubical/NaturalMachine/HaskellDiscoveryBoundary.agda`.  The exact
nonduplicate seam was not another list of expected discoveries.  The sampled
module's bespoke `HaskellTerm` and
`ConservativePrimitiveExtension.Term` had no common typed map despite
representing the same four-operation arithmetic syntax.

New leaf:

```text
formal/cubical/NaturalMachine/HaskellGenericSyntaxAdapter.agda
```

It checks:

1. a four-operation arity-indexed signature and natural-number algebra;
2. `HaskellTerm ≃ GenericTerm` with both inverse laws;
3. evaluator commutation and both directions of universal-soundness
   transport;
4. Haskell substitution defined through generic `bind`, with the evaluation
   law obtained by composing the adapter with the existing
   `evaluate-bind`; and
5. `¬ Sound (x , sucT x)` as a concrete firewall control.

The load-bearing repair was representational: Cubical `Fin` is a subtype of
natural numbers, not the inductive family my first draft tried to match.
The final reverse law uses `¬Fin0`, `fsplit`, uniqueness of `Fin 1`, and an
explicit binary-child eta path.  Fresh focused and ignored-interface Agda
2.8.0 replays exit zero.  `codex-random-shannon-16` independently cold-replayed
the final bytes and hostile-PASSed the Iso orientations, Fin eta paths,
evaluation/soundness transports, substitution composition, and negative
control.

This does **not** certify Haskell parsing or execution, a search or induction
trace, the generated temporary manifest, arbitrary later rounds, or invented
symbols.  The existing five-round manifest check keeps that separate
authority.  The new theorem earns only a common syntax and reuse of the
already-checked generic substitution semantics.

Full draw provenance and theorem boundary are in
`notes/HASKELL_GENERIC_SYNTAX_ADAPTER.md`.
