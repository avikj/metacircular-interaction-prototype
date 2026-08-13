# Full decoherence is blind to sensor informativeness

**Status:** exact finite no-go, extracted from the arithmetic quotient
dilation theorem.

Let `q:X->Y` be any deterministic sensor on a nonempty finite source. Compare
two quantum interfaces:

\[
V_q|x\rangle=|q(x)\rangle|e_x\rangle
\]

for coherent overwriting, and

\[
\Phi_q(\rho)=\sum_x\langle x|\rho|x\rangle
|q(x)\rangle\langle q(x)|
\]

for basis measurement followed by preparation.

The coherent interface has minimum environment dimension
`max_y |q^-1(y)|`. The channel has Choi matrix

\[
J(\Phi_q)=\sum_x |x\rangle\langle x|\otimes
|q(x)\rangle\langle q(x)|.
\]

Its `|X|` nonzero summands have mutually orthogonal input support, so its Choi
rank—and minimum Stinespring environment dimension—is exactly `|X|`, for
**every** `q`.

## Decisive control

On the same `N`-point source:

| sensor | image size | coherent environment | decohering environment |
|---|---:|---:|---:|
| constant | 1 | N | N |
| injective | N | 1 | N |

The decohering channel assigns identical cost to a sensor that learns nothing
and a sensor that preserves everything. Its environment records which input
basis state was measured, not how informative the quotient is.

## Changed next move

Minimum Stinespring dimension of this measure/prepare channel must not be used
to rank, select, or optimize arithmetic sensors: on a fixed formation set it
is a constant. Sensor formation should instead report at least image size and
coherent maximum fiber, with the interface declared. If physical measurement
and reset are intended, the `|X|` environment remains a real implementation
cost, but it answers an erasure question rather than an observation-quality
question.

This does not compare arbitrary noisy POVMs or quantum instruments. It closes
only the deterministic basis-measure/prepare route as an informativeness
metric.

Independently replicated by cf-delta (msg 0340): the Choi matrix
`J=Σ_i|i⟩⟨i|⊗|q(i)⟩⟨q(i)|` was built explicitly and its exact rank computed for
constant, injective, residue, and asymmetric-surjection sensors on `|X|=8` —
Choi rank `= |X|` in every case, constant and injective identical.
`machinery/cf_delta_replay_decohering.py`.

