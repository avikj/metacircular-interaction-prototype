# Definitional folding cannot prune—after a decoder is supplied

The exact finite theorem behind the sampled concept-gate argument is data
processing, not freshness by itself.

Let `sample` be a finite probe, with two observations

```text
before : X → Before
after  : X → After.
```

The load-bearing datum is a function `unfold : After → Before` satisfying

```text
unfold (after x) = before x
```

for every `x` in the probe.  The checked Lean leaf calls this `UnfoldsOn`.
It proves

```text
sample.image before = (sample.image after).image unfold
distinctCount sample before ≤ distinctCount sample after.
```

Thus an after-view that decodes to the before-view cannot identify two probe
points that the before-view distinguished.  This is the precise content of
“a definition folds; it does not merge.”

## The sign has two honest types

For natural-number counts, subtraction truncates.  Lean therefore proves

```text
beforeCount - afterCount = 0 : Nat.
```

It would be misleading to call that expression “nonpositive”: every natural
number is nonnegative.  For the sign-sensitive integer margin, Lean proves

```text
(beforeCount : Int) - afterCount ≤ 0.
```

This is the exact type of the sampled `marginalPrune ≤ 0` sentence.  If a
reverse coding map also commutes on the probe, the two distinct-output counts
are equal, not merely ordered.

The two-point control makes the premise visible.  The identity view on
`Bool` has two outputs, while the constant-false view has one and hence a
positive natural prune of one.  Lean proves that no decoder from the collapsed
view can recover the identity view.  Positive pruning is possible only if the
claimed unfold factorization is absent; this control shows that absence can
permit it.

## What is not checked

The sampled note `THE_CONCEPT_GATE_WAS_UNSATISFIABLE.md` asserts that freshness
of a new symbol `c` supplies

```text
u (nf_R' t) = nf_R t.
```

The new leaf does **not** prove that implication.  The live
`machine/MathMachine.hs` normalizer is an ordered deterministic rewrite
strategy with a hard 200-step cap.  Its source contains no checked simulation
showing that inserting a fresh fold rule commutes with that bounded normalizer.
Termination or semantic conservativity alone is not this equation, and the
existing checked neighbours do not fill the gap:

- `NaturalMachine.DefinitionalExtension` checks judgmental unfold of one Agda
  definition;
- `NaturalMachine.TypedUnfold` checks elimination and semantic preservation;
- `Pairfield.FiniteInformation` checks factorization and fibre constancy.

None proves commutation with Haskell `normalize`, preservation of its
`ordNub` normal-form count, confluence, or adequacy of the 200-step cap.
Accordingly, the formal result is conditional on the supplied `UnfoldsOn`
decoder.  It certifies the cardinality step once that source-specific
obligation is discharged; it does not certify the sampled rewrite theorem as
stated.

## Scope and provenance

No theorem here changes `MathMachine.hs`, validates `marginalCompress`, proves
the primitive-content or use-before-successor gates, validates withdrawal,
or establishes autonomous self-improvement.  The two-point control is an
abstract factorization falsifier, not a counterexample to fresh definitional
folding in the Haskell engine.

Draw 20 was pinned to origin commit
`bcbc3b61fb55f85536f480f368e2623cee0d98b8`, tree
`69e48ac079495fc320602ef6cd09050990615b30`.  The selected note had blob
`38120e693744643ca1908bd9aedfec4c1fc43016`.  Full random provenance and the
concurrent first-push collision audit will be recorded in the result message
after focused verification and hostile review.

The leaf is intentionally not imported by `Pairfield.lean` in this workset.
