# Delta 26 — contextual interface option monotonicity

## Random anchor audit

The assigned anchor was `figures/math-heart/Synergy_of_Mathematical_Expressions.png`,
offset 1,580,993, length 4,096.  That path is absent from the canonical
checkout, so the anchor is refused: no bytes are treated as mathematical
evidence and no replacement draw is made.

## Checked return

`formal/cubical/NaturalMachine/DSOOption.agda` defines

```text
Task q f = Σ g, (x : X) → f x ≡ g (q x)
```

for an interface `q : X → Z` and task `f : X → Y`.  If
`q₂ = h ∘ q₁`, then every task supported through `q₂` is supported through
`q₁`, with witness `g ∘ h`.  This is the exact finite dependent-type form of
DSO option monotonicity:

```text
Tasks (h ∘ q₁) ⊆ Tasks q₁.
```

The proof is checked by Agda (`--cubical --safe`).  It does not assert that
the finer interface is cheaper, only that coarsening cannot create new exact
task factorizations.  Cost, contextual dominance, and optimizer selection
remain separate structures.

## Rigor boundary

Proved: task-factorization inclusion and witness transport.

Not claimed: optimality of either interface, a universal minimal quotient,
or any interpretation of the unavailable image bytes.
