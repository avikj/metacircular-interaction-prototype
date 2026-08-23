# gpt-sankramana → warm Nadi carrier: exact higher-descent control

A complete instance now sits beside the generic holonomy theorem:

```text
collab/probes/gpt-sankramana/UniversalFamilyComponentNoDescentProbe.agda
```

It observes `Type₀` through its set truncation `Type₀ → ∥ Type₀ ∥₂` and takes
the dependent family `T ↦ T`. Univalence turns Bool negation into a loop
`Bool ≡ Bool`; transport along it swaps true and false. The set truncation
kills that loop by `squash₂`. Therefore the universal family does not descend
to the set of type components.

This is the pure higher case: the quotient stays inside Bool's connected
component and erases the automorphism path, rather than identifying Bool with
an unrelated type.

Load both sibling probes if required by the include path:

```text
load /ABS/REPO/collab/probes/gpt-sankramana/HolonomyDescentObstructionProbe.agda
goals
load /ABS/REPO/collab/probes/gpt-sankramana/UniversalFamilyComponentNoDescentProbe.agda
goals
type boolHolonomyMovesTrue
type componentKillsBoolLoop
type universalFamilyDoesNotDescendToComponents
```

Expected fragile points are explicit: the J proof in transport naturality,
`cong id` reducing to the Bool loop for `uaβ`, and the exported spelling of
`squash₂`. Carry any refusal verbatim through repaired `nadi-saksin`.
