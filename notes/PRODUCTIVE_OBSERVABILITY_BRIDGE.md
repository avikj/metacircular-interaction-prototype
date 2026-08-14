# Productive bisimulation is future rooted observation

**Status:** Cubical equivalence checked for the repository's linear productive
Net; greatest-safe composition checked separately; no transfer to the
indexed, branching Indra Net claimed.

**Source encounter:** the no-redraw sample
`notes/ORACLE_BITS_ARE_NOT_THE_MIN_CUT.md` at `origin/main`
`23949d4d613fdc67787487afd1ab011a52bbfe67`. The declared 894-path frame
had SHA-256
`2f77b1deff3ab706a8ad84a90cea7ec9ba3b4adae5c9dfdaeeb2616e8ba59f18`;
native `/dev/urandom` uint32 `3055102615` selected zero-based index `655`.

## The exact common object

`NaturalMachine.ProductiveIndraNet.Net Root Jewel` is a linear coinductive
stream whose current observation is a total rooted view:

```text
Net.view : Net Root Jewel → TotalView Root Jewel
Net.next : Net Root Jewel → Net Root Jewel
```

`NaturalMachine.ObservabilityQuotient.ForeverEq T p` relates two states when
`p` agrees after every finite iterate of `T`. Specializing
`T = Net.next` and `p = Net.view` makes its successive equalities precisely
the fields demanded by `ProductiveIndraNet.Bisim`.

The checked module
`formal/cubical/NaturalMachine/ProductiveObservabilityBridge.agda` first
constructs both maps:

```text
bisim→forever :
  Bisim left right → ForeverEq Net.next Net.view left right

forever→bisim :
  ForeverEq Net.next Net.view left right → Bisim left right
```

The first is recursion on the requested depth. The second is guarded
corecursion: its `now` field is depth zero, while its `later` field shifts the
future equality family by one.

It then proves both inverse laws. The future-observation round trip is by
function extensionality and induction on depth. The Bisim round trip is a
guarded path through the coinductive fields:

```text
forever-round : bisim→forever (forever→bisim equal) = equal
bisim-round   : forever→bisim (bisim→forever related) = related
```

Thus the final checked theorem is a genuine Cubical equivalence:

```text
bisim≃forever :
  Bisim left right ≃ ForeverEq Net.next Net.view left right
```

The present `ProductiveIndraNet` fixes `Root` and `Jewel` in `Type₀`, so the
bridge has the same universe restriction. `ObservabilityQuotient` itself is
more universe-polymorphic; this result does not silently generalize the Net.

## Greatest-safe consequence, checked but not imported

`ExtremalDescription.greatest-safe` says that every relation which refines
current observation equality and is invariant under the step is contained in
`ForeverEq`. Specializing it to `Net.next` and `Net.view`, then composing with
`forever→bisim`, gives:

```text
bisim-greatest-safe :
    ED.Sound≈ Net.next Net.view _≈_
  → ED.Inv≈ Net.next Net.view _≈_
  → left ≈ right
  → Bisim left right
```

This composition passed an isolated safe Agda check. In this consequence,
`greatest-safe` supplies the forward containment into future observational
equality, while guarded corecursion supplies the return into productive
bisimulation.

The formal bridge deliberately does not import the top-level
`ExtremalDescription` module. It contributes the reusable equivalence; the
greatest-safe consequence remains an explicit composition for clients that
already use the extremal-description theorem.

## Hostile replay: definitional failure, propositional repair

The smallest direct hostile control attempted the Bisim-side inverse law by
reflexivity:

```agda
naive-bisim-round-trip : (related : PIN.Bisim left right)
  → forever→bisim (bisim→forever related) ≡ related
naive-bisim-round-trip related = refl
```

Agda rejected `refl`: the coinductive record has no definitional eta law.
That failure blocks an equivalence package whose inverse certificate is
merely asserted by reduction. It does **not** block an equivalence proved by
a path. The checked `bisim-round` supplies exactly that missing guarded path,
field by field.

A second replay sharpened the observation-side proof. The tempting one-line
`funExt (λ depth → refl)` did not reduce at arbitrary depth for the explicit
recursive map. Induction on `depth` closes it without sethood or proof
irrelevance. The final `_≃_` therefore rests on two explicit inverse paths,
not on an overreading of mutual implication.

## Delta 25 scope and non-reduction fence

UP-D0025 section 23 lists several different disciplined reconstruction
theorems and explicitly says not to collapse them into one holographic
principle. This bridge realizes only its final-coalgebra/future-observation
shape for `NaturalMachine.ProductiveIndraNet`, whose `next` field is one
linear continuation.

It is not T25.B's synchronic rooted total space `Σ x , View x`, not T25.A's
Yoneda profile, and not a theorem about the indexed, branching
`IndraNet.Coinductive.Net`, whose images range over all jewels. No equivalence
is transferred between these distinct Net types. Keeping those domains
separate also preserves Delta 25's diachronic Braid/synchronic Net boundary.

Huayan/Indra's Net is not reduced to bisimulation, observability theory, or
category theory. These terms are exact mathematical analogues inside one
declared formal candidate, not a formalization or proof of Huayan thought.

## Verification

The equivalence module passed Agda 2.8.0 with
`--cubical --guardedness --safe --no-import-sorts`, with no postulates, holes,
or warnings. The positive and hostile checks were run from isolated temporary
project trees so no Agda interface was written into the repository.
