# Exact predictive cache profiles have no quantum dimension compression

## 1. Predictive states from continuation cost

For a persistent addition cache `C` and target `t`, let `d_C(t)` be the least
number of legal additions needed to form `t`. For a declared target family
`T`, define the exact predictive profile

\[
p_T(C)=(d_C(t))_{t\in T}.                                         \tag{1}
\]

Two caches with the same profile are interchangeable for these exact future-
cost questions. `PREDICTIVE_CACHE_QUOTIENT` proposes this as the coarsest
classical quotient preserving the answers.

Could quantum memory encode its distinct classes in fewer Hilbert-space
dimensions by using nonorthogonal states? Under zero-error exact readout, no.

## 2. Orthogonal-profile theorem

Suppose each distinct profile `p` is encoded by a density operator `rho_p` on
a finite-dimensional Hilbert space. For every target `t`, require a measurement
whose outcome equals `d_C(t)` with probability one on every encoding.

**Theorem 2.1.** Density operators encoding distinct profiles have mutually
orthogonal supports. Hence, if `N_T` profiles occur,

\[
\boxed{\dim H\ge N_T.}                                             \tag{2}
\]

The bound is sharp: encode the profiles as an orthonormal basis. Thus the
minimum exact quantum memory dimension equals the number of classical
predictive classes.

**Proof.** Let profiles `p` and `q` differ at target `t`, with exact outcomes
`a!=b`. Let `E_a` be the POVM effect for outcome `a`. Zero-error readout gives

\[
\operatorname{Tr}(E_a\rho_p)=1,
\qquad \operatorname{Tr}(E_a\rho_q)=0.                              \tag{3}
\]

Since `0<=E_a<=I`, the support of `rho_p` lies in the eigenvalue-one subspace
of `E_a`, while the support of `rho_q` lies in its kernel. These subspaces are
orthogonal. Every distinct pair differs on some target, proving pairwise
orthogonality. Their nonzero supports therefore require at least one dimension
each. Orthonormal basis encoding attains the bound. `square`

The mixed-state support qualification is load-bearing but does not weaken the
dimension result.

## 3. Critical-witness capability bit

For the caches

\[
C_A=\{1,2,3,6\},\qquad C_B=\{1,2,4,6\},                            \tag{4}
\]

and the next critical witness `t=9`, exact continuation costs are

\[
d_{C_A}(9)=1,\qquad d_{C_B}(9)=2.                                  \tag{5}

There are two profiles, so exact predictive memory needs Hilbert dimension
two—one qubit if embedded in qubits. This exactly matches the classical
capability bit found in `CRITICAL_CHAIN_OPTION_VALUE`; quantum nonorthogonality
cannot compress it while preserving zero-error cost readout.

Restricting the target family can collapse the quotient. For target `{6}` both
caches have distance zero and dimension one suffices. Quantum memory cost is
therefore task-relative exactly as the classical predictive quotient is.

## 4. Infinite-family consequence

If a declared target family and cache family realize infinitely many distinct
profiles, no finite-dimensional quantum memory can answer every exact distance
query with zero error. This follows because every finite subset of `N`
profiles already needs dimension at least `N`.

This is a no-go for exact quantum **storage compression**, not for quantum
computation. It says nothing about whether a quantum algorithm can form a
target faster, query an oracle more efficiently, or approximately predict
costs using fewer qubits.

## 5. Change to the organism

The organism should compile exact cache histories directly to their classical
distance-profile quotient. Re-encoding those classes as nonorthogonal quantum
states cannot reduce exact memory dimension. A quantum route becomes eligible
only after naming at least one changed condition:

- bounded error or approximate costs;
- a probability distribution over targets and lossy rate-distortion goal;
- coherent target superpositions with an operation not reducible to exact
  classical coordinate readout;
- a quantum construction dynamics rather than classical cache storage.

Without such added structure, “quantum predictive memory” is the classical
minimal automaton placed in Hilbert space.

## Replay and rigor boundary

Run:

```sh
cd machinery
python3 -m unittest test_exact_predictive_quantum_memory.py
python3 exact_predictive_quantum_memory.py
```

The theorem is proved above. The executable independently checks the finite
critical-witness profiles and exact shortest addition distances. No quantum
speedup, approximate compression bound, thermodynamic statement, physical
non-Markovianity, causal-order claim, or spacetime interpretation is made.
