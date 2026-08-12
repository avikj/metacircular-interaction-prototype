# Addition chains earn the first separating arithmetic history

## 1. Same terminal witness, different formed worlds

`WITNESS_CONSTRUCTION` forms a located critical witness through a replayable
addition chain. If every intermediate result remains available—as the
arithmetic organism's causal-possession language requires—then a construction
does not merely return an integer. It changes the formed-value cache.

Consider two lawful chains from the formed unit:

\[
\begin{aligned}
A:&\quad 1\to2\to3\to6,
&F_A=\{1,2,3,6\},\\
B:&\quad 1\to2\to4\to6,
&F_B=\{1,2,4,6\}.
\end{aligned}                                                       \tag{1}
\]

Both terminate at the same integer 6. The endpoint quotient identifies them.

## 2. Separating-continuation theorem

Let a persistent construction state be `(n,F)`, where `n` is the latest
endpoint and `F` is the set of formed values. Admit the future observation

\[
P_m(n,F)=\mathbf 1_{m\in F}.                                       \tag{2}
\]

**Theorem 2.1.** Endpoint equality is not predictively sufficient for
persistent addition-chain states. In (1), `P_3(A)=1` while `P_3(B)=0`, and
`P_4` separates them in the opposite direction.

**Proof.** Immediate from the displayed caches. `square`

More generally, two same-endpoint histories are separated by a one-step
availability probe exactly when their formed sets differ. Their symmetric
difference is the complete set of such shortest witnesses.

This is the exact process-memory criterion sought after
`ADAPTIVE_TRACE_PROCESS_NO_GO`: an earlier choice changes a later admitted
response even though the terminal arithmetic value agrees. Unlike nested
residue traces, the history cannot be regenerated from the endpoint.

## 3. Predictive quotient and minimal memory

Relative to a declared future probe family `G`, two construction histories are
predictively equivalent precisely when

\[
\bigl(\mathbf1_{m\in F}\bigr)_{m\in G}
=
\bigl(\mathbf1_{m\in F'}\bigr)_{m\in G}.                            \tag{3}
\]

For the two histories in (1) and probes `{3,4}`, the endpoint quotient has one
class while the predictive quotient has two. Hence one classical bit is
necessary and sufficient to label the predictive state among these histories.
If coherently overwriting a two-element history register by the common
endpoint, the environment dimension is two; retaining the predictive cache bit
is exactly where reversibility stores the distinction.

This is a finite deterministic classical process. It corresponds to the
operational core of process-tensor memory—past interventions are distinct when
a future instrument separates them—but it is not yet a quantum process tensor.
A quantum claim would require CP instruments, a multi-time Choi operator, and
causal normalization.

## 4. The persistence boundary

The result depends on cache persistence. If the declared state discards every
intermediate and retains only the endpoint, then both histories become
`(6,{6})`, no availability probe separates them, and the memory is deliberately
erased. This is not a refutation; it is a different process semantics.

The organism already distinguishes mathematical existence from causal
possession. A replayable addition-chain certificate lists formed
intermediates, and subsequent construction can reuse them. Under that existing
semantics, persistence is operational rather than decorative. If the runtime
chooses garbage collection, it must record the deletion as a state-changing
operation and accept the lost future capabilities.

## 5. Change to the organism

Witness construction must update a persistent formed-value cache, not merely
return the target witness. Route selection among equal-length or near-equal
chains should therefore compare their **future option sets**. The shortest
chain to the current target need not be best if another chain forms reusable
intermediates.

The immediate next arithmetic question changes from “how few additions form
`r`?” to:

> Which chain to `r` minimizes present cost subject to maximizing or pricing
> the predictive value of its retained intermediates for declared successor
> tasks?

This is earned by the separating continuation, not imposed as architecture.

## Replay and rigor boundary

Run:

```sh
cd machinery
python3 -m unittest test_addition_chain_process_memory.py
python3 addition_chain_process_memory.py
```

The theorem is exact and the tests replay both chains and the erasure control.
No optimal-chain theorem, quantum advantage, non-Markovian physical process,
indefinite causal order, thermodynamic claim, or spacetime interpretation is
made.
