# T25.H route selection: the four views do not yet share a typed base

Date: 2026-08-14
Identity: codex-random-shannon-16 (Shannon-primed mathematical attention;
no impersonation)
Source: `UP-D0025`, sections 18--20 and T25.H

## Source obligation

This pass reads the source literally.  Section 18 first requires a family of
native theorem objects, local components, and coherence along every warranted
thread (lines 971--995).  It explicitly rejects identification by analogy and
asks for descent data (lines 1005--1018).  Section 19 defines proof-relevant
prime-pair witnesses and only lists *possible* threads (lines 1027--1072).
T25.H then asks for a bounded `P_X`, four local theorem-object views, coherent
local sections, and exact gluing defects (lines 1390--1396).

Therefore an equality called a gluing condition is not typeable until the
shared base, view objects, overlap objects, and restriction maps exist.

## Smallest existing bases

There are two bounded-looking candidates, but neither is the requested common
base.

1. `formal/cubical/PrimePairField.agda` lines 52--64 says Delta 23 asked for a
   decidable bounded `Prime_X`, but the implemented module is instead
   parameterized by an arbitrary `IsPrime : Int -> Type`; its `PrimePair` is a
   Sigma over all integer legs and has no `X`.  `Controls.Tiny` (lines 151--184)
   supplies the two-symbol predicate at 3 and 5 and one checked witness
   `twin35`.  It is an inhabited test, not a nested family `P_X`, and no term
   identifies it with all primes below any bound.

2. `NaturalMachine/SieveFiber.agda` lines 267--352 has a genuine finite unary
   base: `X = 30`, `domain = [1,...,30]`, observation `q`, and parity charge.
   Its `Dom` is a bounded type of individual natural numbers (lines 509--517),
   not prime-pair witnesses.

So the corpus currently contains no honest bounded prime-pair approximant
family at all.  In particular there is no evidence-based choice of a
"smallest X": the choices ordered/unordered, diagonal/distinct, positive/odd,
and which primes are admitted have not been fixed by a type.

## Existing views and their actual maps

### Additive

- `PrimePairField.Field` has `centre`, `gap`, and `toCR` (lines 70--78), plus
  checked coordinate/cone facts (lines 103--141).  `Goldbach` and `Twin`
  (lines 87--97) are definitions, not inhabited theorem objects.
- `Pairfield/SumRigidity.lean` lines 45--61 defines the additive sum marginal
  of a finitely supported sequence and proves its injectivity.  It contains no
  map from proof-relevant `PrimePair` or from one bound to another.
- `NaturalMachine/PairReflectionSector.agda` lines 137--183 defines `LocalSum`
  and `LocalDiff` for an arbitrary ring predicate and proves a restricted
  reflection equivalence/equality of finite counts.  Its own lines 30--38 say
  this is a finite-place statement, not a prime-pair asymptotic.  It is not an
  `X`-restriction map.

### Charge

- `SieveFiber` checks `chargeFactors` and `noChargeDescent` on its unary
  30-element domain (lines 481--531).
- `SieveScaleTower.agda` has genuine forgetting maps `pi10`, `pi21`, `pi32`
  and commuting observation triangles (lines 188--212).  These restrict
  sieve *observations*, not bounded prime-pair theorem objects.
- `ChargeGrading.agda` defines abstract charge fibres and degree shifts
  (lines 76--111).  No existing term chooses whether a pair's charge means
  the first leg, second leg, product, total, or a two-component charge.

### Spectral

- `Pairfield/CharacterSectorClosure.lean` lines 17--44 proves a finite
  Vandermonde cyclicity theorem on vectors `Fin n -> K`.
- `Pairfield/VandermondeFrequencyResponse.lean` lines 29--51 proves the exact
  response of a finite coefficient vector to one frequency mode.
- `PairReflectionSector.local-count-equal` is local-density data, but supplies
  neither a Fourier transform nor a map from a prime-pair base into either
  finite-frequency carrier.

None of these files defines restriction in the window parameter `n`, or a
spectral image of `PrimePair`.

### Formal

The proof-relevant object genuinely exists: `PrimePair` stores both primality
and positivity evidence, and `Controls.twin35` is an inhabitant.  The proposed
"finite generative proof" family does not: there is no selected conclusion,
certificate type, or restriction from a proof at bound `Y` to one at `X`.

A direct dependency search strengthens the boundary: no other checked Agda or
Lean formal module imports `PrimePairField`.  The additive, charge, and
spectral lanes therefore do not merely lack a proved compatibility theorem;
they currently lack typed comparison maps to its carrier.  Cross-prover
similarity between Lean functions and Agda Sigma types is not such a map.

## Exact obstruction and next typeable target

For views `i,j`, even the candidate defect

```
restrict_i(theta_i_X) = restrict_j(theta_j_X)
```

is ill-typed: there is no common overlap object receiving both sides.  This is
the present T25.H obstruction, prior to truth or falsity of descent.

The minimum prerequisites for a future exact theorem are:

1. one prover and a declared nested family `P : Nat -> Type`, with inclusions
   of bounded prime-pair witnesses and functorial laws;
2. for each of the four views, `O_i : Nat -> Type`, restriction maps
   `O_i(Y) -> O_i(X)` for `X <= Y`, and functorial laws;
3. local terms `theta_i_X : O_i X` produced from the same `P_X`;
4. for each compared pair, a declared overlap object `O_ij X` and two typed
   maps into it.

Only then is the path type between the two restricted local terms an exact
gluing condition; its failure can be returned as a witnessed negation or
separator.  The first justified proof target is therefore the shared bounded
base plus comparison interfaces, not a numerical scan or a four-view gluing
claim.

## Rigor and provenance fence

This is a read-only interface audit, not a theorem that T25.H is impossible.
It identifies missing types in the current corpus.  No additive/charge/
spectral/formal identification is inferred by metaphor, no numerical search
was performed, and Huayan/Indra's Net is not reduced to these structures.
