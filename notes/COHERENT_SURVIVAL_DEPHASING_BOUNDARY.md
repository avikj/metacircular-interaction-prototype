# Coherent survival dephasing: the Bellman state is classical exactly at the diagonal cut

**Status:** proved; finite two-sector algebra machine-checked in safe Cubical
Agda.  This is a correspondence and an interface no-go, not a quantum
speedup or a claim that coherent algorithms are classical.

## 1. The question actually asked

`SURVIVAL_PATH_DP` fixes a child schedule
`sigma=(sigma_1,...,sigma_p)`, infers the final child, and proves

\[
  \mathbb E Q=\sum_{t<p}W_t,
  \qquad
  \mathbb E S=\sum_{t\le p}W_t
    |\sigma_t-\sigma_{t-1}|,                         \tag{1}
\]

where `W_t` is the unresolved probability mass reaching stage `t`.  Its open
question was whether a coherent implementation must replace this mass by an
amplitude-bearing Bellman state.

There are two different questions hiding there:

1. What is the expected value of the same query/motion cost when the branch
   computation is implemented coherently?
2. What can a processor learn or optimize after it is allowed to recombine
   different history sectors?

The first answer is exactly classical.  The second is not.  The cut between
them is the algebra of admitted observables, not the adjective “coherent.”

## 2. Exact correspondence

Let `H` be the finite set of complete stopping histories of one declared
schedule, represented by orthogonal vectors `|h>`.  Let `rho` be any density
operator on their span.  For each stage `t`, define the survival projector

\[
  P_t=\sum_{h:\,h\text{ reaches }t}|h\rangle\langle h|.       \tag{2}
\]

Thus

\[
  W_t=\operatorname{Tr}(P_t\rho)
     =\sum_{h:\,h\text{ reaches }t}\rho_{hh}.                \tag{3}
\]

The query and signed-motion cost observables are

\[
  C_Q=\sum_{t<p}P_t,
  \qquad
  C_S=\sum_{t\le p}|\sigma_t-\sigma_{t-1}|P_t.              \tag{4}
\]

Both are diagonal in the stopping-history basis.

Let

\[
  \Delta(\rho)=\sum_h |h\rangle\langle h|\rho
                         |h\rangle\langle h|                \tag{5}
\]

be complete dephasing in that basis.

**Theorem 2.1 (coherent survival correspondence).**  If stopping histories
remain in orthogonal sectors until the cost is accumulated, then

\[
  \operatorname{Tr}(C_Q\rho)
    =\operatorname{Tr}(C_Q\Delta(\rho))=\sum_{t<p}W_t,
\]

and

\[
  \operatorname{Tr}(C_S\rho)
    =\operatorname{Tr}(C_S\Delta(\rho))
    =\sum_{t\le p}W_t|\sigma_t-\sigma_{t-1}|.                \tag{6}
\]

**Proof.**  For every diagonal operator
`C=sum_h c_h |h><h|`,

\[
  \operatorname{Tr}(C\rho)=\sum_h c_h\rho_{hh}
  =\operatorname{Tr}(C\Delta(\rho)).                         \tag{7}
\]

Substitute (4), interchange the two finite sums, and use (3).  This gives
(6), which is exactly the indicator proof of `SURVIVAL_PATH_DP`, now written
as a Born expectation.  No off-diagonal entry occurs.  ∎

**Corollary 2.2.**  For this objective, Ananta's Bellman state
`(tested subset,current center)` and its unresolved mass `W(A)` remain exact.
Replacing probabilities by amplitudes adds no scheduling information.  A
larger quantum state would be representational overhead unless some caller
admits a non-diagonal operation.

The hypothesis is operational.  The output digit or prefix may itself retain
the orthogonal branch record, as in `MINIMAL_BRANCH_STATE`; a separate response
transcript is unnecessary.  But branches must not be coherently recombined
before their costs have been charged.

## 3. Decisive no-go against the stronger reading

Consider the normalized pure states

\[
  |+\rangle=(|0\rangle+|1\rangle)/\sqrt2,
  \qquad
  |-\rangle=(|0\rangle-|1\rangle)/\sqrt2.                   \tag{8}
\]

Their density matrices are

\[
 \rho_+=\tfrac12\begin{pmatrix}1&1\\1&1\end{pmatrix},
 \qquad
 \rho_-=\tfrac12\begin{pmatrix}1&-1\\-1&1\end{pmatrix}.   \tag{9}
\]

They have the same diagonal and the same dephasing `I/2`.  Hence every
diagonal stopping-history cost has exactly the same expectation on them.
Nevertheless the Pauli-`X` port has expectations `+1` and `-1`; equivalently,
a Hadamard followed by a computational-basis measurement distinguishes the
states perfectly.

**Theorem 3.1 (interface no-go).**  Unresolved masses are not a sufficient
state for an interface containing coherent recombination or any non-diagonal
effect.

This is also the designed annihilation of a stronger theorem.  The statement
“coherence never matters to scheduling” dies on (8).  What survives is the
typed statement: coherence is invisible to the diagonal history-cost algebra
and visible outside it.

## 4. What adaptivity does and does not change

Adaptive control changes which histories reach a stage and therefore changes
the diagonal projectors `P_t`.  It does not create an interference term while
the branch record remains orthogonal and the cost is controlled by that
record.  The third forecast branch—adaptivity alone defeating (7)—does not
occur.

If a processor erases the distinguishing record by reversible recombination,
then its later effects need not be diagonal in the old history basis.  That is
not a counterexample to Theorem 2.1; it is a new interface.  The cost of that
recombination and the new readout must be declared before a quantum scheduling
claim can be compared with the classical dynamic program.

This boundary is compatible with `CLEAN_REVERSIBLE_VALUATION_PROGRAM`:
query, copy the decision into the orthogonal output prefix, unquery, then
update.  Cleaning the response ancilla does not erase the mathematical output
that labels the branch.

## 5. Machine-checked finite core

`formal/cubical/NaturalMachine/CoherentSurvivalDephasing.agda` checks, with
`--cubical --safe` and no postulates or holes:

- over an arbitrary ring, every two-history diagonal cost is definitionally
  invariant under dephasing;
- matrices with the same diagonal agree under every such cost;
- the exact integer multiples
  `[[1,1],[1,1]]` and `[[1,-1],[-1,1]]` have the same diagonal and the same
  dephasing;
- their off-diagonal ports are `2` and `-2`, hence provably unequal.

The common scalar `1/2` from (9) is omitted in the checked carrier because it
cannot affect either equality or separation.  The Agda term certifies the
finite algebraic cut; the arbitrary-finite-history trace identity is the
finite-sum proof in §2, not a claim that this repository contains a Hilbert
space library.

Replay:

```sh
cd formal/cubical
agda NaturalMachine/CoherentSurvivalDephasing.agda
agda NaturalMachine.agda
```

## 6. Prior art and claim boundary

Dephasing, diagonal observables, the Born rule, and the deferred-measurement
principle are standard.  Gurevich and Blass give a formal treatment of
deferred measurement in *Quantum circuits with classical channels and the
principle of deferred measurements*
([arXiv:2107.08324](https://arxiv.org/abs/2107.08324)).  Variable-time quantum
search and amplitude amplification are also established subjects; see
Ambainis, *Quantum search with variable times*
([arXiv:quant-ph/0609168](https://arxiv.org/abs/quant-ph/0609168)) and
*Variable time amplitude amplification and quantum algorithms for linear
algebra problems*
([arXiv:1010.4458](https://arxiv.org/abs/1010.4458)).

No novelty is claimed for the operator identity.  The repository contribution
is the exact application boundary for `SURVIVAL_PATH_DP`: its unresolved-mass
recurrence is already the coherent expected-cost recurrence at the diagonal
history cut, while variable-time interference belongs to the explicitly
different non-diagonal branch.  Nothing here rules out speedups in that
branch, supplies one, or compares their query models.

## 7. Change to the organism

The next move is now forced by the caller:

- for expected query/motion cost with orthogonal branch output, keep the
  existing `O(p^2 2^p)` subset dynamic program unchanged;
- do not introduce amplitude vectors merely because the implementation is
  coherent;
- if a quantum route is proposed, require it to name a non-diagonal
  recombination/readout and price that operation.  Its least sufficient
  Bellman carrier is then a new question, not a silent modification of
  unresolved mass.

That prevents both errors: prematurely classicalizing a phase-sensitive
algorithm and prematurely quantumizing a diagonal expected-cost calculation.

