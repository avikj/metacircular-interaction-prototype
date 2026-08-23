# When invariant linear closure is already an observation partition

Let `X` be finite and work in `R^X` with pointwise multiplication. A partition
`pi` determines the unital algebra `A_pi` of functions constant on its blocks.

## Classification lemma

A linear subspace `W <= R^X` is `A_rho` for a unique partition `rho` exactly
when it contains `1` and is closed under pointwise multiplication.

Proof. Every `A_rho` has these properties. Conversely define `x~y` when
`f(x)=f(y)` for all `f in W`. Choose a finite basis of `W`; its joint evaluation
map has exactly the `~`-classes as fibers. On its finite image, multivariate
polynomial interpolation produces the indicator of each fiber from the basis
functions. Since `W` contains `1` and is multiplication-closed, those
indicators lie in `W`. Hence `W` contains every function constant on the
fibers, while the reverse inclusion follows from the definition of `~`.
Thus `W=A_rho`. ∎

## Linear versus partition closure

For a linear operator `K`, let

`L_K(A_pi)=sum_(n>=0) K^n A_pi`

be the least `K`-invariant linear subspace containing the initial observation
algebra. Then `L_K(A_pi)` is already the least stable observation partition
exactly when it is closed under pointwise multiplication. If it is not, no
partition can realize the linear minimum: every stable partition algebra must
also contain `alg(L_K(A_pi))`, and multiplication creates genuinely new
observable fibers.

This is the exact meaning of “nonlinear refinement”: the dynamics remains
linear, but observation contexts must remain closed under conjunction, encoded
by pointwise products of indicators.

## One conditional expectation

Take `K=P_sigma`. Since `K^2=K`,

`L_K(A_pi)=A_pi + K A_pi`.

Let

`B=alg(A_pi union K A_pi)`.

The joint fibers of the generators are precisely the profile blocks
`rho_1` from `EQUITABLE_FUTURE_CLOSURE`: the old `pi` label together with the
vector `(|sigma(x) intersect C|/|sigma(x)|)_(C in pi)`. Therefore

`B=A_rho1`.

The one-step profile theorem proves `K B <= B`. Thus `B` is the least
`K`-invariant partition algebra containing `A_pi`.

Consequently:

`linear closure needs no nonlinear refinement`

iff `A_pi + K A_pi` is multiplication-closed

iff `A_pi + K A_pi = A_rho1`.

When this fails, incidence leakage still determines the repair, but the repair
contains pointwise products not present in the minimum invariant subspace.
Those extra directions are exactly the cost of insisting that the carrier be
an observation partition rather than an arbitrary linear code.

## Boundaries

The classification uses finite `X` and scalar functions over an infinite field
such as `R` or `Q`; interpolation needs separation of finitely many evaluation
vectors. For a general Markov kernel, alternating algebra generation and
linear action can require several rounds. For `P_sigma`, idempotence plus the
profile theorem makes the generated algebra invariant after one round.

