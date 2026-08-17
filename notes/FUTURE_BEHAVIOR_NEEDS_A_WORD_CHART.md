# A negative future inequality is not yet an experiment

## The missing local/global map

`NaturalMachine.FutureBehavior` defines

```text
FutureEq step observe x y =
  (w : List A) → behavior step observe x w ≡ behavior step observe y w.
```

Its quotient and full-abstraction theorems need only this positive universal
relation.  They do not claim that negating `FutureEq` produces an experiment.
The no-redraw encounter with that module asked whether such production has the
same MP boundary as an `ℕ`-indexed observation family.

The new checked module `NaturalMachine.FutureSeparation` names the witnessed
form

```text
FutureSep step observe x y =
  Σ[ w ∈ List A ]
    ¬ (behavior step observe x w ≡ behavior step observe y w).
```

For arbitrary output it proves the two direct incompatibility maps between
`FutureEq` and `FutureSep`.  A separator of the two successor states after
action `a` lifts to a separator of their parents by prefixing `a` to its word.

For `Bool` observations, equality at each fixed word is decidable.  This gives
the exact constructive residual:

```text
¬ FutureSep step observe x y → FutureEq step observe x y
¬ FutureEq step observe x y → ¬¬ FutureSep step observe x y.
```

The second arrow does not select a word.

## Why MP alone is not the general missing axiom

The sampled module permits an arbitrary action type `A`.  Its experiment
index is therefore `List A`, not `ℕ`; no enumeration or countability premise
is part of the API.  Applying the previous sample's `ℕ`-indexed MP theorem
directly would silently invent a global chart.

The sufficient map is now explicit.  Given

```text
enumerate : ℕ → List A
covers    : (w : List A) → Σ[ n ∈ ℕ ] enumerate n ≡ w,
```

`MP→enumeratedFutureSep` uses Boolean MP to extract an index whose enumerated
word distinguishes the states.  Surjectivity is load-bearing: it transports
agreement on all chart entries to agreement on every action word, which is
exactly what is needed to contradict `¬ FutureEq`.

This establishes a conditional implication, not an unconditional equivalence
between future separation and MP.  The countable chart must be constructed
from the machine's presented action language.  For a non-countable or opaque
action type there may be no such map.

## Relation to the executable finite lane

`Pairfield.BehavioralBFS` already takes the stronger effective data needed for
bounded search: an explicit finite action list with a coverage proof, plus a
depth.  It returns a kernel-checked shortest separator within the exhausted
layers and proves global minimality once one is found.  The new Cubical result
does not duplicate that algorithm.  It identifies the logical seam before
algorithmics:

```text
arbitrary action language
  → only double-negated witnessed future inequality

countably charted action words + MP
  → an unbounded existential distinguishing word

finite presented alphabet + bounded BFS
  → an executable shortest distinguishing word inside the searched horizon.
```

A finite-state stabilization bound would connect the last line to a decision
procedure for full `FutureEq`; neither the sampled module nor the new bridge
claims that bound.

## Rigor boundary

- Cubical Agda checks `FutureSep`, prefix lifting, negative stability for Bool,
  double-negated extraction, and `MP→enumeratedFutureSep` under `--safe` with
  no postulates or holes.
- The existing Lean BFS result and its explicit-presentation boundary are
  repository prior art, not new claims here.
- Not proved: countability of arbitrary `A` or `List A`, a converse from the
  future-separation principle to MP, shortestness, termination of unbounded
  search, or a finite-state horizon.
- No novelty claim is made for the logical use of MP or enumeration.  The
  contribution is the exact chart premise connecting the sampled quotient
  semantics to a witnessed experiment.
