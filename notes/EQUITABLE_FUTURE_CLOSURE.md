# Equitable refinement is finite lumpability closure

**Correction.** The first version of this note identified equitable closure
with equality of all observation traces. That is false for general finite
Markov kernels: probabilistic bisimulation implies trace equivalence, but the
converse can fail. The theorem that survives is the stable/lumpable closure.

Let `X` be finite, `pi` a partition, and `sigma` a second partition. Write
`K=P_sigma` for uniform averaging on `sigma`-blocks. Define `rho_0=pi` and
define `rho_(n+1)` by retaining the `rho_n` label and splitting points according
to the vector

`(K 1_B(x))_(B in rho_n)`.

## Theorem

The sequence is the standard finite probabilistic-bisimulation refinement.
It terminates at the unique coarsest refinement `rho_*` of `pi` whose block
subspace is `K`-invariant. Because `K` is self-adjoint, this is equivalently the
unique coarsest refinement whose averaging projection commutes with `K`.

Proof. Termination follows because every strict step splits a finite partition.
At a fixed point, every `K1_B` is constant on stable blocks, hence the span of
their indicators is `K`-invariant. Self-adjointness makes its orthogonal
complement invariant too, so its projection commutes with `K`. For minimality,
if `tau` refines `pi` and its block subspace is `K`-invariant, induction shows
`tau` refines every `rho_n`: each current block indicator is `tau`-measurable,
so its `K`-image is too and is constant on `tau`-blocks. Thus `tau` refines the
fixed point. ∎

Stable equivalence implies equality of every finite future observation-trace
probability, by induction on trace length and summing over stable successor
classes. The converse is not asserted. The invalid converse would require a
stable-class indicator to be recoverable from trace events; that need not hold.
Bare powers `K^j` cannot help because this `K` is idempotent.

## Residual-driven form

At stage `n`, let `P_n=P_(rho_n)`. The incidence-rank theorem gives

`rank((I-P_n) K P_n) = sum_E (rank N_E(rho_n,sigma)-1)`.

Moreover

`rank((I-P_n) K P_n)=0  iff  P_n K=K P_n  iff  rho_(n+1)=rho_n`.

When the residual is nonzero, the incidence rows themselves give the next
splitting signatures. Hence the output is a valid input to the same closure
step. The measure `|X|-|rho_n|` strictly decreases until lumpability closure.

For a finite family of averaging actions, fair iteration terminates at the
least common stable refinement: the refinement operators are monotone and
inflationary on a finite partition lattice. This is an exact generated loop,
but it computes bisimulation/lumpability closure, not necessarily the minimal
trace quotient.

## Boundary

Finite sets, counting measure, and averaging projections only. The initial
observation and admitted action family remain inputs. No equivalence with the
minimal FutureBehavior quotient is claimed without an additional hypothesis,
such as deterministic dynamics, under which bisimulation and future-language
equivalence coincide.
