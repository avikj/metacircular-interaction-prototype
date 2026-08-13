# Incidence leakage generates the one-step equitable repair

**Correction, 2026-08-13.** The first version identified equitable refinement
with deterministic FutureBehavior; a second version overstated the iterative
role for a single averaging projection. Both formulations are withdrawn.
Shilpin supplied the decisive five-state Markov counterexample in
`collab/messages/shilpin/equitable_future_closure_hostile.md`.

Let `pi,sigma` be partitions of a finite set `X`, with counting measure, and
let `K=P_sigma`. For each `sigma`-block `D`, define its `pi`-profile

`p(D)=(|D intersect B|/|D|)_(B in pi)`.

Split every `pi`-block by this profile:

`rho_1: x ~ y iff pi(x)=pi(y) and p(sigma(x))=p(sigma(y))`.

## Theorem

`rho_1` is already stable under `K`, and is the unique coarsest refinement of
`pi` whose averaging projection commutes with `K`.

Proof. A `rho_1`-block has the form

`R(B,t)={x in B : p(sigma(x))=t}`.

On a `sigma`-block `D`, `K1_R=|D intersect R|/|D|`. If `p(D)=t`, then
`D intersect R=D intersect B`, so the value is `t_B`; otherwise it is zero.
Thus `K1_R` depends only on `p(D)` and is constant on every `rho_1`-block.
The block algebra is `K`-invariant. Since `K` is self-adjoint, `P_rho1`
commutes with `K`.

If `tau` is any commuting refinement of `pi`, then every `pi`-block indicator
is `tau`-measurable and commutation makes its `K`-image `tau`-measurable.
Therefore the complete profile vector is constant on `tau`-blocks, so `tau`
refines `rho_1`. ∎

The incidence-rank theorem supplies the exact failure measure

`rank((I-P_pi)K P_pi)=sum_E(rank N_E-1)`.

It vanishes exactly when `rho_1=pi`. When nonzero, the normalized incidence
rows are precisely the profiles defining `rho_1`. Thus the residual supplies
the terminal repaired observation object, and recomputation certifies zero
leakage. For one conditional expectation this is a one-step closure, not a
multi-round generative loop.

A genuine iteration occurs for a finite family `K_1,...,K_m`: apply the
one-step repair for any currently leaking action. Each nontrivial step strictly
refines a finite partition. Fair iteration terminates at the least common
stable refinement, independent of schedule, by monotonicity on the finite
partition lattice. Here each output partition is admissible input to every
next repair.

## Exact boundary

For a general Markov kernel, probabilistic-bisimulation refinement may require
multiple rounds. It is not characterized by marginal powers on the original
blocks, because a Markov operator is linear, not multiplicative on Boolean
fibers. Shilpin's five-state counterexample makes two states agree on original
block marginals through horizon two while transition probabilities into a new
first-round block differ. Nor is probabilistic bisimulation generally the
minimal trace-equivalence quotient.

Therefore the earned join with FutureBehavior is only this: equitable repair
produces a sound observation-preserving quotient, and coincides with the
deterministic FutureBehavior construction only under additional deterministic
hypotheses. Initial observation and admitted action family remain inputs.
