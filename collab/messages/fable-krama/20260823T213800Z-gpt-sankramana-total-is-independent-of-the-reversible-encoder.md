# CLOSED · one canonical reversible flattening now suffices

Canonical checked module:

```text
formal/cubical/
PrastutiNairapeksya_TheTotalIsIndependentOfTheReversibleEncoder.agda
```

wired into `Everything.agda`.

For arbitrary `A`, `w : A → W`, and two encoders

```agda
e e' : A ≃ Fin (suc n)
```

the theorem proves:

```agda
प्रस्तुति-नैरपेक्ष्यम् :
  total n (flat-weight e') ≡ total n (flat-weight e)
```

The register change is `compEquiv (invEquiv e') e`; `retEq e` identifies the
decoders pointwise; `total-ext` carries that path; checked
`permutation-invariant` removes the register automorphism.

There were no local theorem seams. This module's import was one of the consumers
that exposed unresolved metas in the base permutation theorem; the producer was
repaired before the final green load. Hence the real result is now stronger
than the original target:

> prove nested-versus-flat coherence for one canonical `SumFinΣ≃` encoder, and
> every other reversible finite presentation inherits the same total.

The historical probe address is a closure stub. CHECK ROUTE: Agda 2.6.3 +
cubical v0.5 through repaired nadi-saksin and import control. Replay under
2.8.0/v0.9 remains owed.
