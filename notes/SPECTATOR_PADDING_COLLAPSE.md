# One idle component can erase unary order

## The checked two-level seam

`notes/TOKEN_PHILOSOPHY.md` studies individual- versus collective-token
executions through free symmetric and commutative monoidal categories.  Its
large classification and trace-normal-form theorems were replayed by retired
Python, not by the repository's current formal substrate.  The new safe Agda
leaf

`formal/cubical/NaturalMachine/SpectatorPaddingCollapse.agda`

extracts one bounded operation-level consequence without claiming that larger
formalization.

`TwoLevelCollective` deliberately separates two types:

- `Unary`, where sequential order may remain observable;
- `Binary`, where two unary operations can be composed in parallel.

It assumes unary identities, supplied sequential operations at both levels, a map
`tensor : Unary -> Unary -> Binary`, serial/parallel interchange, and
commutativity of `tensor`.  It does not identify the two arities or assume that
unary composition is commutative.

Define the spectator-padding map by

```text
padding u = tensor u idU.
```

Interchange and the unit laws give the exact path

```text
padding (u then v) = tensor u v.
```

Binary commutativity therefore yields

```text
padding (u then v) = padding (v then u),
```

and the diagonal specialization is the sampled causal-collapse equation
`padding (u then u) = tensor u u`.  The commutation happens after changing
arity; it is not cancellation or commutativity back in `Unary`.

## Killer control: equality after padding does not reflect equality

Take unary executions to be endomaps of `Bool`, with diagrammatic composition
`firstThen f g x = g (f x)`.  Let binary observations be `Unit`, so every
parallel pair has the same collective image.  This is a genuine instance of
the declared laws.

For `toggle = not` and `erase = const false`, the two unary executions differ:

```text
firstThen toggle erase false = false
firstThen erase toggle false = true.
```

Agda proves them unequal, while the generic padding theorem identifies their
binary images.  Hence the declared laws do not make `padding` injective.  This
is the exact structural obstruction: a forgetful operation-level map can erase
causal order even when no boundary relabelling explains the equality.

## Nonduplication and scope

`NaturalMachine.ParallelNetworkComposition` already checks cartesian
serial/parallel interchange, but its product semantics does not impose this
collective commutativity or the erasing padding map.  The present result adds
that missing two-level boundary; it does not alter the existing module.

This leaf does **not** construct a free commutative monoidal category, prove a
universal property, identify boundary-token orbits, classify all hom-sets,
construct a Mazurkiewicz trace monoid, prove the concurrency-threshold iff, or
handle arbitrary Petri nets.  `Unit` is a deliberately severe finite
countermodel, not a claim that collective semantics always forgets everything.
No physical causality, quantum process, scheduler, or concurrency measurement
is inferred.

## Literal Draw 10 provenance

The no-redraw encounter froze freshly fetched origin commit
`2b3006e8d8011937a55cb651044f9fd94f91beae`, tree
`67a375a25526f7686f3f094fa4f50541858959f9`, and a C-sorted frame of 1,084
tracked semantic `.agda`, `.lean`, and `.md` paths under `formal/`, `notes/`,
and `papers/`, excluding build products and this identity's nine prior
samples.  The frame SHA-256 was
`860b78f01e9bef65a96f28916b1edf96f6ae08bc01e67f09fc13a89620a2f9a0`.
With rejection limit `4294966264`, the sole `/dev/urandom` uint32
`1166693952` was accepted with zero rejections at zero-based index 1012
(position 1013), selecting `notes/TOKEN_PHILOSOPHY.md`, blob
`5b73e737db37ba52e7afec097e33fe59b4a12df0`.  There was no redraw.

Focused replay:

```sh
cd formal/cubical
agda --ignore-interfaces -i . NaturalMachine/SpectatorPaddingCollapse.agda
```
