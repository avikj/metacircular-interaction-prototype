# Equitable refinement is finite future-behavior closure

Let `X` be finite, `pi` a partition, and `sigma` a second partition. Write
`K=P_sigma` for uniform averaging on `sigma`-blocks. Define partitions
`rho_0=pi` and `rho_(n+1)=F_sigma(rho_n)` by retaining the `rho_n` label and
splitting points according to the vector

`( K 1_B(x) )_(B in rho_n)`.

Equivalently, `x,y` remain equivalent at stage `n+1` exactly when they are
equivalent at stage `n` and, for every current block `B`, the one-step
probabilities from `x,y` into `B` agree.

## Theorem

For every `n`, `rho_n` is equality of all observation-cylinder probabilities
of length at most `n`: two points lie in one `rho_n` block iff they assign the
same probability to every sequence of future `pi`-observations under repeated
transition by `K`. Algebraically these are the functions obtained from the
original block indicators by iterating Boolean combination of already
distinguished fibers and application of `K`.

Consequently the stable partition `rho_*` is the finite FutureBehavior
quotient for the observed process: equality in `rho_*` is equality of all
finite future observation-cylinder probabilities. It is also the
unique coarsest refinement of `pi` whose averaging projection commutes with
`P_sigma`.

Proof. Induct on `n`. The case `0` is the definition of `pi`. At the successor,
the refinement signature records `K1_B` for every `rho_n`-block. By induction,
every `rho_n`-block is a fiber of the joint map of cylinder probabilities
already generated, so its indicator is a Boolean function of that finite joint
map. Applying `K` to every such fiber records probabilities of every next
observable event conditional on each resolved history. Equality of the new
signatures is exactly equality of cylinders one step longer. Conversely the
recorded old label retains all shorter cylinders. This proves the induction.
Finite refinement terminates. At its fixed point, the span of block indicators
is `K`-invariant; since `K` is self-adjoint, its orthogonal projection commutes
with `K`. Minimality follows by the same induction: every `K`-stable refinement
of `pi` refines every `rho_n`. Therefore it refines `rho_*`. ∎

Idempotence makes bare powers `K^j` collapse after one step. That is why bare
marginals are the wrong FutureBehavior object. Nontrivial behavior comes from
observation masks/Boolean fibers interleaved with transitions: `K` acts on a
growing observable algebra, and stability of that algebra is the closure.

## Residual-driven form

At stage `n`, put `P_n=P_(rho_n)`. The exact residual cost is

`r_n = rank((I-P_n) K P_n)`

`= sum_E (rank N_E(rho_n,sigma)-1)`.

The incidence-rank theorem gives

`r_n=0  iff  P_n K=K P_n  iff  rho_(n+1)=rho_n`.

Thus a nonzero residual is not merely a diagnostic: its incidence rows are the
signatures defining the admissible next partition. The output `rho_(n+1)` is
again a finite observation partition, so it is valid input to the same closure
operation. The strict-refinement measure `|X|-|rho_n|` decreases until the
future quotient is reached.

This is an exact task-generated closure loop:

`current observation -> leakage incidence -> next observation -> repeat`.

After closure for `sigma`, the resulting `rho_*` may be fed with a further
action partition `tau`; no representation conversion is required. Closing
successively over a finite family terminates because every nontrivial step
strictly refines a finite partition. The terminal partition is the coarsest
refinement of `pi` stable under every admitted averaging action, independent
of fair scheduling: it is the least common fixed point of the monotone,
inflationary refinement operators.

## Boundary

This theorem is for finite sets, counting measure, partition observations, and
averaging projections. It does not cover the non-idempotent centered sieve
multiplier or arbitrary actions. The family of admitted actions and the initial
observation remain inputs. What is generated internally is every subsequent
failure witness and least closure step; no cost scalarization is used.
