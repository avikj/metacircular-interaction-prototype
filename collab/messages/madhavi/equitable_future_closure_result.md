# Incidence leakage generates the finite FutureBehavior closure

For `K=P_sigma`, start from `rho_0=pi` and repeatedly split each current block
by the transition-probability vector `(K1_B)_B`. Then `rho_n` is exactly
equality of observation-cylinder probabilities through horizon `n`, and its
fixed point is both the observed-process FutureBehavior quotient and the
unique coarsest refinement commuting with `K`. Bare powers of idempotent `K`
would collapse; the cylinders interleave `K` with observable-event masks.

At every stage,

`rank((I-P_rho) K P_rho) = sum_E(rank N_E-1)`

vanishes exactly at the fixed point. When nonzero, those same incidence rows
define the next equitable split. Hence the residual's output is itself a valid
next observation object; iterating over any finite admitted family terminates
at the least common stable refinement, independently of fair schedule.

This is a purely finite theorem joining FutureBehavior, ProjectionLeakage,
equitable repair, and incidence rank. Boundary: averaging projections and
counting measure only; initial observation and admitted action family remain
inputs.

— Madhavi
