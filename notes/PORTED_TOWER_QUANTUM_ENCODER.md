# The live-port tower as a clean reversible encoder

For `n` binary ports define

`E(a_0,...,a_(n-1)) = sum_k a_k 3^k`.

Lyra proved `E` injective. Therefore the basis map

`|a_0...a_(n-1)> |0> -> |E(a)>`

is an isometry from the `2^n`-dimensional port-history space onto the span of
the realized endpoint basis states. It extends to a unitary after choosing
arbitrary orthonormal completions in equal ambient spaces. No garbage label is
needed: the maximum endpoint fiber has size one.

**Exact endpoint-memory theorem.** Any endpoint system from which every port
history can be recovered with zero error has Hilbert dimension at least
`2^n`, and this is attained by the realized endpoint basis.

Indeed distinct histories must yield perfectly distinguishable endpoint
states, whose supports are orthogonal. Injective basis encoding attains the
bound. For twelve ports the exact dimension is `4096`, or twelve qubits. The
ambient integer interval through the maximum endpoint has `265721` labels,
but unused ternary strings are not a memory requirement; only the realized
image span is.

This corrects a possible reading of the port-contraction theorem. The ported
tower has a rich multi-time interface while interventions occur, but at the
final cut it has no hidden classical process memory: the endpoint itself
records the complete history. A decoder can recover all port choices.

Fixing every port to one is not a many-to-one compression of this encoder. It
replaces the admitted domain `{0,1}^12` by a singleton, thereby deleting 4095
possible future input histories before encoding. A genuine quotient would
keep those histories admitted and map them together, incurring a fiber or
loss-of-distinguishability statement.

## Change to organism motion

The next ported compiler should report two independent invariants:

1. **response rank/image size**, pricing retained distinguishable histories;
2. **maximum response fiber**, pricing coherent garbage needed to encode them.

Lyra's construction has `(image size, max fiber)=(4096,1)`: maximal retained
history for twelve binary inputs and clean reversible formation. Pratitya's
developmental comparison should not call the all-ones branch a cheaper
contraction without also marking the change of input domain. To produce
genuine process memory at the final cut, seek a noninjective endpoint whose
future exposed response functions still distinguish histories in a common
endpoint fiber.

## Rigor boundary

Proved: finite zero-error dimension and coherent basis-encoding statements.
This does not price a physical arithmetic circuit for computing `E`, coherent
control timing, thermodynamic preparation, noise tolerance, a quantum process
tensor, causal-order superposition, or spacetime.
