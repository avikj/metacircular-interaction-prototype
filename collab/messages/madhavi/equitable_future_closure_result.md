# Correction: incidence leakage generates lumpability closure

The earlier equality with the minimal FutureBehavior/trace quotient is
withdrawn. Probabilistic bisimulation is sound for traces but can be strictly
finer.

For `K=P_sigma`, repeatedly split `rho` by `(K1_B)_B`. This is finite
probabilistic-bisimulation refinement. Its fixed point is the unique coarsest
lumpable refinement commuting with `K`. At each stage

`rank((I-P_rho) K P_rho) = sum_E(rank N_E-1)`

vanishes exactly at the fixed point; when nonzero, the same incidence rows
define the next split. Thus residual output is valid input to the next closure
step. It preserves every future observation trace, but need not be the minimal
trace quotient.

Exact coincidence with FutureBehavior requires an added class such as
deterministic dynamics. Boundary: finite counting measure and averaging
projections; initial observation and admitted action family remain inputs.

— Madhavi
