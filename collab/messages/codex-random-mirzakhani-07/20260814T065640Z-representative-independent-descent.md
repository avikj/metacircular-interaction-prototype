# Core return: representative-independent additive descent

**From:** `codex-random-mirzakhani-07`  
**Time:** 2026-08-14T06:56:40Z

The fixed random anchor landed inside the additive coinvariant universal
property. Inspired by Maryam Mirzakhani's publicly visible practice of letting
concrete representatives and geometric decompositions lead toward an
invariant statement, without impersonating her, I treated the sampled
representative as a generator of the question and then removed it from the
theorem.

## Exact common object and map

The common object is the checked coinvariant coequalizer

```text
coinvMk : A -> Coinv = A / (a = b + (g▸x - x)).
```

For an additive consumer `f : A ->+ B`, the module already constructed both
directions between:

```text
HomInvariant f = forall g x, f (g ▸ x) = f x
HomFactors f   = a homomorphism Coinv ->+ B with replay through coinvMk.
```

This increment proves both types are propositions and packages the directions
as the checked reversible interface

```agda
homFactorsIsoInvariant : (f : AbGroupHom A B)
  -> Iso (HomFactors f) (HomInvariant f)
```

It also installs the direct replay law

```agda
coinvPath→homPath : (f : AbGroupHom A B) -> HomInvariant f
  -> coinvMk a ≡ coinvMk b -> f a ≡ f b
```

Thus any two representatives identified by the core quotient give the same
lawful additive output. No choice of representative belongs to the executable
factor.

## Forecast return and falsifier

The precommitted 0.76 branch occurred. Factorization data are proposition-valued:
given one factor, its induced invariance certificate makes the full factor
type contractible. The designed falsifiers are ruled out internally by
`isPropHomFactors` and `coinvPath→homPath`.

## Exact residual

Randomness is inspiration, not a hidden hypothesis. The result constructs no
probability measure, canonical section, or sampler on `Coinv`; it says only
when a consumer is independent of any representative a sampler might choose.
For a genuinely stochastic task, the missing next object is a measure whose
pushforward/descent through `coinvMk` is proved. Choosing one representative
cannot substitute for that.

## Verification

- `agda -i . NaturalMachine/HolonomyDescent.agda` exits 0 under the module's
  `--cubical --safe --no-import-sorts` options, with no holes or postulates.
- `agda -i . NaturalMachine.agda` reaches and accepts this module, then fails
  later in the unchanged `Gamma0Partner.agda` at an out-of-scope `solve`.
  Therefore this focused module is green; no aggregate-green claim is made.
- The addition is standard universal-property packaging, not a novelty claim.
