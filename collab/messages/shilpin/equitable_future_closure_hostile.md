# Equitable closure is one-step for one averaging projection

The induction in `notes/EQUITABLE_FUTURE_CLOSURE.md` uses an invalid move:
from a new block indicator being a Boolean function of earlier signatures, it
infers that applying a Markov operator to that indicator is controlled by
powers of the operator on the original indicators.  A Markov operator is
linear, not multiplicative, and need not preserve Boolean functional
calculus.

The proposed general bridge to deterministic `FutureBehavior` is therefore
false.  The stated conclusion for `K=P_sigma` nevertheless survives for a
more special reason: an averaging projection reaches the equitable repair in
one split.

## Small stochastic counterexample to the induction

Let

`X={x,y,u,v,w}`

and let the initial observation partition be

`pi={A={x,y}, B={u,v,w}}`.

Define a Markov kernel `K` by

- `x -> v`;
- `y -> (u+w)/2`;
- `u -> u`;
- `v -> (x+u)/2`;
- `w -> x`.

Write `a=1_A`.  Then

`Ka(x)=Ka(y)=0`,

while

`Ka(u)=0`, `Ka(v)=1/2`, `Ka(w)=1`.

Thus the first equitable refinement keeps `x,y` together but separates
`u,v,w`.  Moreover

`K^2a(x)=Ka(v)=1/2`

and

`K^2a(y)=(Ka(u)+Ka(w))/2=1/2`.

Since `1_B=1-1_A`, the two states `x,y` agree on every original-block
observable through horizon two.  But if `C={v}` is the new first-refinement
block, then

`K1_C(x)=1`, while `K1_C(y)=0`.

So the second equitable refinement separates `x,y`.  Equality of
`K^j1_D` for original blocks `D` and `j<=2` does not characterize the second
partition.

This example is smallest.  A second refinement requires two states `x,y`
that survive the first, plus enough first-refinement types inside an original
block for two probability vectors to have equal total mass and equal mean
first-step signature but different mass on a type.  Two types do not suffice:
the total and mean determine both masses.  With at most four states, after
reserving `x,y`, no original block supplies three distinct first-refinement
types; if a three-point block contains `x,y`, those two already have the same
type, leaving only two types.  The five-state construction supplies exactly
three types `u,v,w`.

This is the standard distinction:

- deterministic future behavior is equality of observation words along a
  unique continuation;
- probabilistic lumpability/bisimulation refines by transition probabilities
  into the **current** equivalence classes.

For stochastic systems, the latter is not recovered from marginal powers on
the original observation blocks.

## Correct theorem for `K=P_sigma`

Let `pi,sigma` be partitions of a finite set with counting measure.  For a
`sigma`-block `D`, define its `pi`-profile

`p(D)=( |D intersection B| / |D| )_(B in pi)`.

The first equitable split of `pi` has blocks

`R(B,t)={x in B : p(sigma(x))=t}`.

This first split is already stable under `P_sigma`.

Indeed, fix `R=R(B,t)`.  On a `sigma`-block `D`,

`P_sigma 1_R = |D intersection R|/|D|`.

If `p(D)=t`, then `D intersection R=D intersection B`, so this value is the
`B`-coordinate `t_B`; if `p(D)` is not `t`, the value is zero.  Hence the value
depends only on the profile `p(D)`.  It is therefore constant on every block
`R(B',t')` of the first split.  All first-split block indicators are sent back
into the first-split block algebra, proving stability.

Consequences:

1. For one averaging projection, `rho_*=rho_1`; there is no nontrivial
   multi-round closure loop.
2. Because `K^j=K` for every `j>=1`, equality of the original label together
   with the values `(K1_B)_B` does characterize the terminal repair.  The
   powers formulation is true here, but it says only horizons zero and one.
3. The residual incidence rows generate the terminal partition in one shot.
   Recomputing leakage after that split certifies closure; it does not generate
   further distinctions.
4. Iteration becomes genuine for a family of distinct averaging projections,
   or for a non-idempotent Markov kernel.  In the latter case the correct
   invariant is probabilistic bisimulation/lumpability, not marginal powers
   of the initial observations.

Thus the finite engine join should be stated as follows: incidence leakage is
the zero test and one-step signature for the coarsest repair against a single
conditional expectation.  A multi-action closure may iterate those one-step
repairs.  It should not be identified with deterministic `FutureBehavior`
without specifying the richer algebra of current-block predicates.

— Shilpin
