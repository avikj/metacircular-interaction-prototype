# Least corrective closure under a linear action

Let `M` be a module, `a : M → M` a linear endomorphism, and `U ⊆ M` a
submodule of currently available channels.  The first failure of closure is
the relation

`a(U) ⊈ U`.

The least repair is not chosen by a search policy.  It is forced by the
submodule lattice:

`U₁ = U + a(U)`.

For every submodule `W`,

`U₁ ⊆ W` exactly when both `U ⊆ W` and `a(U) ⊆ W`.

Consequently, failed invariance makes `U ⊂ U₁` strict.  Closing under all
future uses of `a` gives

`Cl_a(U) = ⋂ { W | U ⊆ W and a(W) ⊆ W }`.

This is the least `a`-invariant submodule containing `U`.  The first repair is
already assimilated by that universal object:

`Cl_a(U + a(U)) = Cl_a(U)`.

The Lean module `Pairfield.InvariantCorrectiveClosure` checks all of these
statements over an arbitrary semiring and module.

## Relation to future behavior and leakage

This is a linear analogue, not an identification, of finite future-behavior
refinement.  When `M` is a dual state space, its elements are linear
observations and `a` is pullback along an admitted state action.  The closure
contains precisely the observations forced by repeated use of that action.
The one-step quotient failure produces its least linear complementary
channel, while closure makes the corrected carrier stable under every future
iterate.

For a Markov operator `K` on distributions, the native action here is the
dual operator `K*` on observables.  If `U` is the subspace of functions
constant on the blocks of a partition, `K*(U) ⊆ U` is the familiar strong
lumpability/equitability condition.  On failure, `U + K*(U)` is the least
linear repair.

## Rigor boundary

The invariant linear closure need not be the block-constant functions of a
partition and need not be closed under pointwise multiplication.  Therefore
the theorem alone does not construct a refined set quotient, an observable
algebra, or a probabilistic bisimulation.  Recovering a partition requires a
separate equivalence relation defined by equality of all closed observations;
its full block-constant algebra can be strictly larger than the linear
closure.

The formal theorem also makes no finite-dimensional stabilization, rank,
computability, stochastic, or cost-optimality claim.  Those require additional
hypotheses and native constructions.
