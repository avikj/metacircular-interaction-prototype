# Theorem-compiled symmetry is coherent on the realized quotient

**Status:** checked safe Agda theorem with a finite countercontrol.

## The exact distinction

`TheoremCompiledObservation.Sufficient X Q O` contains a map
`quotient : X → Q`, but it does not require every `q : Q` to come from a
large state.  A `DescendingAction` therefore certifies its commuting square
at points `quotient x`; it does not constrain an independently chosen small
action at unrealized points of `Q`.

The checked module `formal/executable/TheoremCompiledSymmetry.agda` makes the
resulting algebra exact.

- `composeDescending` composes two descent squares in execution order.
- `identity-unique-on-image` forces every descended identity action to be the
  identity at `quotient x`.
- `composition-unique-on-image` forces every independently descended
  composite to agree there with the composite of the descended actions.
- `split-cover-globalizes` promotes any such image law to every point of `Q`
  from a declared section `s : Q → X` with `quotient (s q) ≡ q`.
  `identity-unique-global` and `composition-unique-global` are the two direct
  consequences.

Thus a covered quotient supports the expected symmetry/monoid laws globally.
A bare codomain guarantees them only on its realized image; particular chosen
maps may of course happen to agree elsewhere.

## Exact countercontrol

Let `X = ⊤`, `Q = Bool`, and let the quotient send the unique large state to
`false`.  Give the cyclic group of order two its usual Boolean multiplication
`xor`, checked in the module by identity, associativity, and self-inverse
laws.  Both large actions are the identity.  On `Q`, let the neutral element
act by identity and the generator act by the constant-`false` map.

Every element separately supplies a valid `DescendingAction`, because both
small actions fix the only realized point `false`.  The group composition law
also holds on that image.  It fails globally at the unrealized point `true`:
the generator squared sends `true` to `false`, whereas the neutral action
sends it to `true`.  `oneQuotient-not-split` proves that the missing
globalization hypothesis is not available.

This does not weaken `future-observation-sound`: that theorem starts from
`quotient x`, so its execution remains inside the certified square.  It does
sharpen the prose phrase "a state already carried as `Q`": generically this
means an aligned or realized quotient state, not an arbitrary inhabitant of
the ambient codomain.

## Relation to the existing surface

`NaturalMachine.StructuredDefect` already identifies kernel-pair respect as
the descent condition when a section is supplied.
`NaturalMachine.FiniteInformation` and
`NaturalMachine.ObservableHorizon.RealizedWindow` construct canonical actions
on realized images.  The present result does not rebuild those objects.  It
isolates the algebraic coherence forced among independently supplied
descendants and gives the finite ambient counterexample.

## Replay

```sh
cd formal/executable
agda -i . TheoremCompiledSymmetry.agda
```

The file uses `{-# OPTIONS --safe #-}` and contains no holes or postulates.

## Random provenance

This encounter was selected without content redraw from the tracked semantic
corpus at origin commit
`6a71e83fe2471bb092f67818128b58a9495f35ba`.  The C-sorted 1,038-path frame
had SHA-256
`45887dff0fc66c7c9d36647dac7eb9ad90a22556d763bf81e61701594ad21b40`.
Literal `/dev/urandom` uint32 `3072601366` was below rejection limit
`4294966854`, so zero words were rejected; zero-based index 958 selected
`notes/THEOREM_INDUCED_OPTIMIZATION.md` at blob
`1b4accb53b7dcf92e11b3851c3a020eb332c9409`.
