# Weighted formation curvature is unlock minus redundancy

## Exact system observable

Let `q_v(S)` be the Boolean replayability of fact `v` from retained rule set
`S`, computed from its minimal derivation supports, and give facts
nonnegative weights `w_v`.  Define

`F(S)=sum_v w_v q_v(S)`.

For two caches `A,B`, distinguish two exact populations:

- `J(A,B)`: facts replayable from `A union B` but from neither `A` nor `B`
  separately — **joint unlocks**;
- `R(A,B)`: facts replayable from both `A` and `B` but not from
  `A intersection B` — **redundant routes**.

Write `w(J)` and `w(R)` for their total weights.

## Theorem (curvature balance)

For every cache pair,

`F(A)+F(B)-F(A union B)-F(A intersection B) = w(R(A,B))-w(J(A,B))`.

Consequently `F` is submodular if and only if

`w(R(A,B)) >= w(J(A,B))`

for every `A,B`.

### Proof

Fix one fact and abbreviate its four Boolean verdicts by
`q(A),q(B),q(A union B),q(A intersection B)`.  Monotonicity leaves only two
ways its second difference can be nonzero.  If it is true on both sides but
false on the intersection, the contribution is `+1`; this is exactly
membership in `R`.  If it is false on both sides but true on the union, the
contribution is `-1`; this is exactly membership in `J`.  Every other monotone
Boolean pattern contributes zero.  Multiply by `w_v`, sum over facts, and use
the defining submodular inequality. ∎

This theorem is elementary, but it changes what must be retained: total value
alone can hide joint formation.  The signed curvature profile over cache pairs
records where actions are substitutes (`R`) and where they are complements
(`J`).

## Sharp two-action cancellation

Let the action set be `{a,b}` and consider two requested observables:

```text
either: minimal supports {a}, {b}, weight beta
both:   minimal support  {a,b},     weight alpha.
```

The only nontrivial cache pair is `{a},{b}`.  Here redundancy has weight
`beta`, joint unlocking has weight `alpha`, and the slack is `beta-alpha`.
Therefore the total system objective is submodular exactly when
`beta >= alpha`.

At equality the scalar values are

`F(empty)=0, F({a})=alpha, F({b})=alpha, F({a,b})=2alpha`.

The total is modular even though the `both` observable remains strictly
complementary.  Aggregation has canceled its curvature, not removed its
formation event.  This is the smallest counterexample to the inference
“submodular total implies every constituent observable has diminishing
returns.”

Replay:

```sh
cd machinery
python3 weighted_formation_curvature.py
python3 -m unittest test_weighted_formation_curvature \
  test_proof_support_complementarity -v
```

The exhaustive checker verifies the identity on finite examples; the Boolean
case analysis is the proof.

## Relation to new swarm returns

`VISIBILITY` and `CONSTANCY_NOT_TRANSITIVITY` correct limitor cardinality to
verdict variation.  The present formula is that correction applied to formed
capability: it counts facts whose verdict changes under union/intersection,
not rules, supports, or instantiated cache sizes.  It also limits temporal
acceleration claims: nested actions contribute genuine synergy exactly through
`J`; an aggregate speedup can be canceled by substitute routes in `R`.

## Scope limits

Finite positive-premise systems, exact Boolean replayability, fixed
nonnegative fact weights, and rule-set caches.  The condition is exact but may
require exponentially many cache pairs and exponentially large minimal-support
descriptions.  It is a characterization, not an efficient recognition
algorithm.  Negative weights, probabilities, acquisition costs, and dynamic
rule creation are excluded.
