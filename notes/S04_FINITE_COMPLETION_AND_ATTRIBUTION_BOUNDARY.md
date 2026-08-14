# Finite support at the observation horizon

## Result

`formal/cubical/Swarm/S04Apoha.agda` ends by saying that a certificate
complex can be exact at every finite stage while failing to recover a
distinction at the horizon, and that completeness of the resulting
completion is exactly Markov's Principle (MP).  The new checked module
`formal/cubical/Swarm/S04ApohaFiniteCompletion.agda` makes the finite-to-global
map in that sentence explicit.

For a Boolean observation family

```text
O : ℕ → X → Bool
```

and states `x,y`, let `Ind< k` mean agreement at indices `0,...,k-1`, and let
`Sep< k` carry a separating observation in that prefix.  The horizon types
are

```text
HorizonInd O x y = (n : ℕ) → O n x ≡ O n y
HorizonSep O x y = Σ[ n ∈ ℕ ] ¬ (O n x ≡ O n y).
```

The checked maps are:

```text
sepStep                  : Sep< k → Sep< (suc k)
stageSep→horizonSep       : Sep< k → HorizonSep O x y
horizonSep→stageSep       : HorizonSep O x y → Σ[ k ∈ ℕ ] Sep< k
horizonInd→prefixInd      : HorizonInd O x y → (k : ℕ) → Ind< k
allPrefixInd→horizonInd   : ((k : ℕ) → Ind< k) → HorizonInd O x y
¬horizonInd→¬¬stageSep    : ¬ HorizonInd O x y
                          → ¬¬ Σ[ k ∈ ℕ ] Sep< k.
```

Thus a witnessed global separation always has finite support, and a finite
separator persists into every later stage and determines a horizon witness.
The horizon witness is a retract of the disjoint union of stages.  It is not
called an isomorphism: the stage union remembers many redundant upper bounds
for the same separating index.

The only missing constructive arrow is extraction from bare nonagreement:

```text
FiniteStageWitnessed =
  (X : Type) (O : ℕ → X → Bool) (x y : X)
  → ¬ HorizonInd O x y
  → Σ[ k ∈ ℕ ] Sep< k.
```

Both implications are checked:

```text
MP → FiniteStageWitnessed
FiniteStageWitnessed → MP.
```

This is the exact local/global content.  No compatibility law between a
family of independently chosen local witnesses is needed: one witnessed
index already has finite support.  What MP supplies is the choice of such an
index from a negative statement about the whole countable family.

## Attribution correction

This mathematics should be named pointwise indistinguishability, witnessed
Boolean separation, finite support, and the MP boundary.  It is not by itself
a formalization of Dignāga's or Dharmakīrti's apoha theories.

The sampled module's comments call `Σ i, ¬(O i x ≡ O i y)` the “Dignaga form”
and describe the term as its exclusion.  That historical identification is
not earned by its formal interface.  The repository's source-critical
`notes/INDIC_FORMAL_TRADITIONS_MAP.md` records that no rigorous formal
reconstruction of apoha was located and, more sharply, that Dignāga's
scope-sensitive exclusion is not Boolean complementation in a fixed universe.
`notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` likewise refuses to install a
common modern carrier: it keeps Dignāga's scope account distinct from
Dharmakīrti's causal/error account and makes convention and activity part of
the untranslated residual.

The fixed family `O : I → X → Bool` in `S04Apoha.agda` supplies exactly the
pre-given observation universe that those notes warn us not to identify with
apoha.  The formal theorem remains valid and useful after withdrawing the
attribution.  A future correction should strike the “Dignaga form” and
“Serre form” labels unless independent historical sources establish those
specific correspondences; the neutral theorem names need no change.

## Rigor boundary

- Checked with Cubical Agda under `--safe`, without postulates or holes:
  the prefix transition, localization maps, retract law, double-negation
  residual, and both directions between MP and finite-stage extraction.
- Repository-source fact: the two provenance notes above explicitly reject a
  fixed Boolean complement or a common supplied formal carrier as an apoha
  reconstruction.
- Not claimed: a countermodel to MP inside the repository, an account of
  Buddhist cognition, a formal treatment of concept-hierarchy-sensitive
  exclusion, or any historical priority claim.
- No novelty claim is made for the elementary finite-support maps or the
  standard Boolean form of MP.  The contribution is to make the sampled
  module's completion claim executable and to keep its cultural attribution
  outside the proof boundary.
