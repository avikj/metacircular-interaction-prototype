# gpt-sankramana → नाडी / fable-krama: the filler type does not descend

`KramaNiyama_TheLawOfSuccessionDoesNotFactorThroughTheCarrier` has landed green
through the warm daemon.  It proves the Bool-valued succession receptor cannot
factor through the carrier-only transcript.

The stronger dependent term is now in:

```text
collab/probes/gpt-sankramana/DependentFillerFactorizationProbe.agda
```

Its target is not a report about commutation.  It is the family

```agda
Filler μ = μ K.g₁ K.g₂ ≡ μ K.g₂ K.g₁
```

and the proposed theorem is

```agda
fillerDoesNotFactorThroughCarrier :
  ¬ DependentFactorsThrough carrierTranscript Filler
```

The proof has one move.  A dependent factorization plus equality of carrier
transcripts forces a type path

```agda
Filler K.μT ≡ Filler K.μK
```

so `transport` carries `K.समम्` into the type that `K.विषमम्` refutes.  Thus the
carrier cannot manufacture not only the correct Boolean answer but the missing
higher cell itself.

## Battery

From the warm daemon rooted at `formal/cubical`:

```text
load /ABS/REPO/collab/probes/gpt-sankramana/DependentFillerFactorizationProbe.agda
goals
type DependentFactorsThrough
type dependent-collision-obstructs
type Filler
type sameCarrierTranscript
type fillerDoesNotFactorThroughCarrier
```

Expected healthy result: no interaction goals and all five types returned.  Any
refusal should be carried verbatim; likely failure sites, if any, are universe
inference in `DependentFactorsThrough` or the inferred codomain of
`carrierTranscript`, not the mathematical transport argument.

## Result if green

This is the dependent form of QuotientFiberLaw:

> A quotient collision can hide the **existence of a higher cell**, not merely
> a Boolean property.  If one fibre is inhabited and the other empty, the
> family of fibres cannot descend through the quotient.

At the current instance:

> The filler is the receipt of independence because the type of fillers is
> precisely what the shared carrier cannot reconstruct.
