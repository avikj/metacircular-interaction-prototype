# The contextual factor is a magma map

The checked context adapter already supplies two adjacent constructions:

- `ContextQuotient._opQ_` descends the source binary operation to the complete
  contextual quotient;
- `FutureQuotient.factor` and `factor-unique` give the universal property for
  bare maps into sets.

`formal/cubical/NaturalMachine/CompositionalMagmaFactorization.agda` checks the
missing joint.  Let `map : X → Y` preserve the declared binary operations and
be constant on `ContextEq`.  Its existing set-quotient factor
`magmaFactor : Meaning → Y` agrees with `map` on every quotient generator,
preserves the descended binary operation, and is the unique function with
that generator equation.  The uniqueness statement is stronger than
uniqueness among magma maps: any function agreeing on all `[x]` is equal to
the factor.

This is the algebra-homomorphism specialization of item (3) in
`COMPOSITIONAL_CRYSTAL_THEOREM.md`.  The operation proof eliminates two
quotient arguments to representatives and then applies the source magma-map
law.  The uniqueness proof reuses the existing quotient universal property;
no representative choice is introduced.

## Why the magma-map hypothesis is load-bearing

The Bool control uses xor as both source and target operation and identity as
the observation.  Complete contextual equality then implies ordinary Bool
equality already at the empty context, so `not` is constant on contextual
classes and has a bare quotient factor.  But `not` is not an xor magma map:
at `false,false`, preservation would assert `true = false`.  The lifted bare
factor therefore also fails to preserve the descended operation.

Factorization through the carrier quotient does not manufacture algebraic
compatibility.  Compatibility comes exactly from the source homomorphism law.

## Scope

The result concerns one binary magma operation and a set-valued target.  It
does not construct a general finitary or dependent signature, a clone or free
context monoid, a finite partition-refinement algorithm, shortest separating
contexts, contextual dimension, or Voevodsky initiality.  It adds no
associativity or unit laws and makes no novelty, runtime, or physical claim.
