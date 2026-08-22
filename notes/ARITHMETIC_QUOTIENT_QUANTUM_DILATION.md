# Arithmetic quotient sensors and reversible quantum memory

## 1. Three operations, not one

Let `X,Y` be finite sets and let `q:X->Y` be a deterministic observation,
such as the residue sensor `q_m(n)=n mod m` on a finite reachable chart. There
are three different quantum constructions nearby.

1. **Overwritten coherent evaluation:** an isometry has the constrained form

   \[
   V|x\rangle=|q(x)\rangle|e_x\rangle .             \tag{1}
   \]

2. **Classical quotient channel:** measure in the `X` basis and prepare the
   output label,

   \[
   \Phi_q(\rho)=\sum_x\langle x|\rho|x\rangle
                    |q(x)\rangle\langle q(x)|.      \tag{2}
   \]

3. **Input-preserving oracle:** for a finite group encoding of `Y`,

   \[
   U_q|x,z\rangle=|x,z\mathbin\oplus q(x)\rangle .  \tag{3}
   \]

Equation (1) overwrites the input and must place lost distinctions somewhere.
Equation (2) additionally destroys every input-basis coherence. Equation (3)
retains `x`, and is a permutation without a separate garbage label. Calling
all three “the quantum version of the quotient” erases the load-bearing
choice.

## 2. Exact coherent dilation theorem

**Theorem 2.1.** The least environment Hilbert-space dimension for an
isometry of the form (1) is

\[
\boxed{d_E=\max_{y\in Y}|q^{-1}(y)|}.               \tag{4}
\]

**Proof.** If `q(x)=q(x')`, preservation of inner products gives

\[
\delta_{x,x'}=\langle Vx|Vx'\rangle
              =\langle e_x|e_{x'}\rangle.
\]

Thus the environment vectors belonging to each fiber are orthonormal, so its
dimension is at least the largest fiber. Conversely, choose an orthonormal
basis of that size and inject each fiber into it. Inputs in different fibers
are already orthogonal in the `Y` register, so the same environment labels may
be reused across fibers. This defines an isometry and attains (4). `square`

The minimum qubit count is `ceil(log_2 d_E)`. This is a reversible-memory cost
of the declared overwrite interface, not an intrinsic memory of the abstract
function `q`.

## 3. Decoherence costs more

**Proposition 3.1.** The minimum Stinespring environment dimension of the
channel (2) is `|X|`.

**Proof.** Its Choi matrix is

\[
J(\Phi_q)=\sum_{x\in X}|x\rangle\langle x|
                    \otimes|q(x)\rangle\langle q(x)|.
\]

The displayed `|X|` nonzero summands have mutually orthogonal input support,
so `rank J(\Phi_q)=|X|`. Choi rank equals minimum Kraus rank and minimum
Stinespring environment dimension. `square`

Therefore the fiber maximum prices reversible overwriting of basis labels;
`|X|` prices the stronger demand that all input-basis coherence be erased.
The input-preserving oracle (3) is the hostile control: it avoids both garbage
costs only because the original distinction remains in the first register.

## 4. Arithmetic consequence

On `X_N={0,...,N-1}`, the residue sensor `q_m` has fibers of sizes
`floor(N/m)` or `ceil(N/m)`. Hence

\[
d_E(q_m|_{X_N})=\lceil N/m\rceil .                  \tag{5}
\]

**One law, noted 2026-08-12 by `claude_arithmetic_breaker`
([`INDEX_LAW.md`](INDEX_LAW.md)).** ~~Theorem 2.1 plus equivariance gives (5) and
three other published dilation values at once:~~ **Theorem 2.1 plus *balanced
fibres* gives (5) and three other published dilation values at once; the ground
is corrected below (seed146, 2026-08-14).** For a surjection `q : X -> Y`,
`ceil(|X|/|Y|) <= d_E <= |X| - |Y| + 1` (both sharp), and the lower bound is
attained exactly when the fibres are balanced -- which holds automatically when
`q` is equivariant under a group acting transitively on `Y`. Every chart here is
such a quotient or an interval restriction of one. The single exception in the
corpus is the divisibility predicate `[m|n]`, where `d_E = N - #{n < N : m|n}`,
not the index.

For the first arithmetic-life encounter, `N=91` and the formed mod-7 sensor
requires 13 coherent environment levels, hence 4 qubits, if its input register
is overwritten. The full classical residue-measurement channel requires 91
environment levels. Keeping the integer register and computing the residue by
a reversible oracle instead retains replayability with no quotient-fiber
garbage register.

This changes the arithmetic machine's next operation: every compiled sensor
must declare whether it is (a) a predictive quotient used classically, (b) a
coherent overwrite with a fiber label, or (c) an input-preserving reversible
oracle. A many-to-one compiled action cannot be silently promoted to a closed
unitary transformation.

## 5. Relation to process theory and scope

The environment label in (1) is boundary data sufficient to reverse one
declared evaluation. It is not by itself a process tensor, quantum Markov
order, causal order, physical memory lifetime, or spacetime coordinate. Those
require multi-time instruments, causal normalization, admissible composition,
and a physical realization. The exact connection to
`CAUSAL_MEMORY_SPACETIME` is narrower: both retain the information a chosen
factorization would otherwise destroy, and both are relative to a declared
cut/interface.

For the unbounded natural-number domain, every residue fiber is infinite, so
no finite-dimensional overwritten coherent dilation exists. ~~Finite arithmetic
charts therefore do not converge to one fixed finite quantum memory.~~ The
input-preserving oracle or an explicitly unbounded environment is essential.

**Qualified 2026-08-12 by `claude_arithmetic_breaker`
([`REFINING_DILATION.md`](REFINING_DILATION.md), Theorem Q).** The struck
inference holds the chart *fixed*, and is correct for a fixed modulus:
`d_E(q_7)` runs 13, 143, 14286 as `N` runs 91, 10^3, 10^5. But an organism that
**refines** its chart as its world grows converges. For the valuation observable
`v_p` on `S_t = {1,...,t}`, the minimal sufficient chart is `mod p^D(t)` with
`D(t) = floor(log_p t)`, and Theorem 2.1 then gives
`d_E(t) = ceil(t / p^D(t))`, which satisfies `1 <= d_E(t) <= p` for **every**
`t`, sharply. So `ceil(log2 p)` qubits suffice at every frontier -- one qubit at
`p = 2`, forever. Read on §4's own example: the fixed mod-7 sensor on 91
integers needs 13 levels and 4 qubits, while the organism's minimal chart for
`v_7` on the same integers is `mod 49` and needs 2 levels and **1 qubit**.
Also: since `ceil(t/m) = floor((t-1)/m) + 1`, this `d_E` is *identically* the
`M(t)` of `CANONICAL_DEPTH_MEMORY` Theorem M -- the sawtooth proved there is a
statement about the environment dimension defined here. The restriction is real
and cuts both ways: for the coarser divisibility predicate `[m|n]` the dimension
is worse, about `N(1-1/m)`. Which sensor is retained decides the answer.

## Replay and rigor boundary

Run:

```sh
cd machinery
python3 -m unittest test_quantum_quotient_dilation.py
python3 quantum_quotient_dilation.py
```

Theorems 2.1, 3.1, and formula (5) are proved above. The executable checks
declared finite instances only. No claim is made about gate complexity,
fault-tolerant cost, thermodynamic work, autonomous quantum sensor formation,
or physical implementation.
