# The admissible weight span is the universal carrier

## Exact setting

Let `X` be any declared set of states carrying verdict vectors
`q(x) in Q^n`.  Let `W subset Q^n` be a family of admissible future task
weights.  A task `w` observes

`O_w(x)=w dot q(x)`.

Let `L=span_Q(W)`, choose any basis `b_1,...,b_r` of `L`, and define

`C_W(x)=(b_1 dot q(x),...,b_r dot q(x))`.

## Theorem (weight-span universal property)

For states `x,y`, the following are equivalent:

1. every admissible weighting gives the same answer on `x,y`;
2. `C_W(x)=C_W(y)`;
3. `q(x)-q(y)` lies in the annihilator `L^perp`.

Moreover `C_W` is the coarsest sufficient carrier on the actual state locus:
if a map `T:X->Y` determines every `O_w`, then `T(x)=T(y)` implies
`C_W(x)=C_W(y)`, so there is a unique map from `T(X)` to `C_W(X)` factoring
`C_W` through `T`.  Different bases give carriers related by an invertible
linear change of coordinates and hence the same behavioral quotient.

### Proof

Equality under all `w in W` is equivalent, by linearity, to equality under
every `l in L`, which is equivalent to vanishing against a basis of `L`; this
proves the three-way equivalence.  If `T` determines every admissible
observable, equal `T`-values force equal basis evaluations, so
`T(x) |-> C_W(x)` is well-defined and is plainly the unique factorization on
the image. ∎

This statement is on `q(X)`, not on all of `Q^n`; a Boolean or otherwise
restricted state locus can make the carrier image small, but cannot merge two
states separated by an admissible weighting.

## One-shot formation event

On the Boolean locus `{0,1}^2`, suppose the only admitted task is total value
`w=(1,1)`.  Its quotient has three fibers:

```text
{(0,0)}, {(1,0),(0,1)}, {(1,1)}.
```

Adjoin one independent task `e_1=(1,0)`.  The middle fiber splits immediately;
the carrier `(x_1+x_2,x_1)` reconstructs both coordinates, so all four states
become distinct.  The new action does not append a decorative label: it changes
the behavioral quotient from three classes to four and compiles the formerly
hidden identity of the active fact.

If all singleton weights `e_i` are admissible, `L=Q^n`, `L^perp=0`, and the
full verdict vector is forced.  No nontrivial verdict compression preserves
all future singleton reweightings.

Replay:

```sh
cd machinery
python3 weight_span_carrier.py
python3 -m unittest test_weight_span_carrier -v
```

Rational row reduction is exact.  The finite Boolean tests check the
implementation and formation event; the factorization proof establishes the
universal property.

## Relation to swarm returns

`DEVELOPMENTAL_PORT_COMPLEMENTARITY` exhibits equal numerical projections—an
endpoint span and an open response capacity—that are different currencies.
The theorem here states exactly when projections may lawfully be identified:
only when the declared future weight span fails to separate them.

Likewise, `VISIBILITY` replaces index cardinality by verdict variation.  Here
an added independent weight makes a previously constant fiber vary, and its
rank increment is the exact number of new linear observable coordinates
formed.  A dependent added task changes no fiber and forms no new carrier
coordinate.

## Scope limits

Finite-dimensional rational verdict vectors and linear scalar tasks.  The
state locus may be arbitrary.  Nonlinear queries, probabilities, costs,
causal availability, and dynamic creation of new verdict coordinates are not
captured.  Curvature of a set function is preserved when its relevant verdict
vector is included among `q`; the theorem does not assert that every future
operation is linear in a pre-existing vector.
