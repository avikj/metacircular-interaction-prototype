# Exact coherent center selection requires orthogonal programs

## 1. The hidden control resource

The optimal adaptive valuation protocol chooses a translation center `c` and
queries `tau_k(r+c)`. A quantum query comparison may allow centers in coherent
superposition. That phrase hides a required operation: controlled modular
translation

\[
X_c|x\rangle=|x+c\rangle,
\qquad x,c\in R=\mathbb Z/p^k\mathbb Z.                            \tag{1}
\]

Can a fixed processor implement many `X_c` from nonorthogonal compact program
states? For exact deterministic programming, no.

## 2. Orthogonal-program theorem

Let `G` be a fixed unitary processor acting on program and data registers.
Suppose for each center `c` there are normalized program states `|P_c>` and
residual states `|Q_c>`, independent of the data input, such that

\[
G(|P_c\rangle|\psi\rangle)
=|Q_c\rangle X_c|\psi\rangle                                     \tag{2}
\]

for every data state `|psi>`.

**Theorem 2.1.** If `c!=d mod p^k`, then

\[
\langle P_c|P_d\rangle=0.                                       \tag{3}
\]

Consequently an exact processor supporting `N` distinct centers needs program
Hilbert-space dimension at least `N`. The bound is attained by an orthonormal
center register and the usual controlled translation.

**Proof.** Preservation of inner products in (2) gives, for all `psi,phi`,

\[
\langle P_c|P_d\rangle\langle\psi|\phi\rangle
=\langle Q_c|Q_d\rangle
 \langle\psi|X_c^\dagger X_d|\phi\rangle.                         \tag{4}
\]

If the input program overlap were nonzero, setting `psi=phi` shows the
residual overlap cannot be zero. Dividing (4) then forces
`X_c^dagger X_d` to be a scalar multiple of the identity. But it is translation
by `d-c`, which sends `|0>` to the distinct basis state `|d-c>` when
`c!=d`; it is not scalar. Therefore the input overlap is zero. `square`

This is the exact deterministic no-programming argument specialized to the
arithmetic translations actually required here. The data-independent residual
condition is load-bearing: the processor may change the program, but it may
not hide input-dependent data in that residual while still being called a
program register.

## 3. Consequences for valuation instruments

Supporting the full center language of `Z/p^kZ` requires program dimension

\[
p^k,                                                               \tag{5}
\]

or `ceil(k log_2 p)` qubits when embedded in qubits. A branch-restricted set
of `N` possible centers requires dimension `N`; nonorthogonal exact programs
do not reduce it.

This does **not** say every adaptive run must physically retain all center
states at once. Classical feedback may construct one center at a time, as
`ADAPTIVE_CENTER_CHAIN` proposes. It says that a coherent oracle interface
which accepts an arbitrary exact center as a program must expose an orthogonal
control alphabet or hard-wire a reversible arithmetic circuit acting on such
an alphabet.

Thus quantum query count alone is not an end-to-end cost comparison. One must
declare which of the following is supplied:

1. an ideal controlled-translation oracle with center register;
2. a reversible circuit constructing `c` from the branch state;
3. preprepared orthogonal program states;
4. an approximate or probabilistic processor, outside this theorem.

## 4. Change to the organism

The organism should not treat “query in superposition over centers” as free.
Before testing quantum query advantage, compile the exact center-generation
map and count its reversible workspace/program alphabet. The classical
adaptive protocol has a concrete branch-construction baseline; a quantum route
must include the same control semantics.

The theorem closes only exact deterministic programming. Approximate programs,
probabilistic processors, and fixed universal arithmetic circuits have
different costs and remain possible. A hard-wired circuit does not violate the
theorem: its orthogonal center input register is the program alphabet made
explicit.

## Replay and rigor boundary

Run:

```sh
cd machinery
python3 -m unittest test_programmable_center_orthogonality.py
python3 programmable_center_orthogonality.py
```

The theorem is proved above. Tests check modular translation identities and
dimension accounting. No lower bound on total circuit gates, approximate
programming, quantum query complexity, thermodynamic cost, physical
non-Markovianity, causal-order superposition, or spacetime is claimed.
