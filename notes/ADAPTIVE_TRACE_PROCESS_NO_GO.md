# Adaptive residue history is not yet intrinsic process memory

## 1. The apparent temporal object

For nonzero `s=a+b` with `v=v_p(s)`, the adaptive valuation routine queries
the nested residue charts

\[
(a,b)\bmod p,\ (a,b)\bmod p^2,\ldots,
(a,b)\bmod p^{v+1},                                      \tag{1}
\]

stopping when the sum residue first becomes nonzero. This is an acquisition
history with real query cost. It is tempting to call (1) temporal memory.

That inference is false for this deterministic nested policy.

## 2. Terminal-record theorem

Let the terminal record be

\[
R(a,b)=\bigl(v+1, a\bmod p^{v+1},\ b\bmod p^{v+1}\bigr). \tag{2}
\]

**Theorem 2.1.** On the nonzero branch, the complete trace (1) and the terminal
record (2) determine one another exactly.

**Proof.** The trace determines its last entry. Conversely, if the last entry
has depth `d`, its reduction modulo `p^k` is the unique earlier entry for every
`1<=k<=d`. Moreover the stopping rule is recoverable: the reduced sum is zero
at every `k<d` and nonzero at `d`. `square`

The exact-zero branch has no finite terminal chart in the current routine. It
is represented by one explicit `zero` flag backed by the external equality
certificate `a=-b`. The flag reconstructs the empty trace, but does not replace
that equality proof.

## 3. Quantum dilation consequence

On any declared finite input chart `C` of integer pairs, let `T:C->H` output
the full trace and `R:C->E` output the terminal record (including the zero
flag). Theorem 2.1 gives mutually inverse maps between `im T` and `im R` with

\[
T=\operatorname{expand}\circ R,
\qquad R=\operatorname{last}\circ T.                    \tag{3}
\]

Therefore `T` and `R` induce exactly the same partition of `C`. In particular,
their coherent-overwrite dilation costs agree:

\[
\boxed{\max_h|T^{-1}(h)|=\max_e|R^{-1}(e)|.}            \tag{4}
\]

A reversible implementation may compute the terminal record, regenerate or
stream the earlier display when wanted, and uncompute it without retaining a
separate history register. Deferred coherent evaluation therefore removes the
apparent process memory without changing the quotient semantics.

This is a decisive no-go, not a claim that adaptive acquisition is free. The
number of sensor queries is still `v+1`; latency and online stopping remain.
What vanishes is only the claim that this nested deterministic trace contains
information beyond its terminal sufficient statistic.

## 4. Answer-only output is a different quotient

The valuation answer `v` determines the stopping depth but not the terminal
residue pair. For example `(1,2)` and `(2,1)` at `p=3` both have valuation one
and the same stopping depth, but distinct terminal records. Erasing the
terminal residues is a further quotient. Its cheaper reversible dilation, if
used, forgets information needed to replay which sensor responses occurred.

Thus three costs must remain distinct:

1. acquisition/query cost of reaching the terminal chart;
2. reversible boundary memory of the terminal record/full trace;
3. reversible boundary memory of the answer-only quotient.

## 5. What would create genuine process memory

A trace becomes load-bearing if later state or admissible interventions depend
on earlier outcomes in a way not reconstructible from the terminal record—for
example, branch-dependent transformations between queries, noisy instruments,
early actions that disturb later statistics, or an external controller whose
choice is not a function of the final sufficient statistic. Then the object is
not one deterministic quotient map; multi-time instruments and a process
tensor or classical controlled process may be appropriate.

The new scaled-jet tower has not yet crossed this boundary. If every displayed
jet is a deterministic function of one final residue record, it compresses by
the same theorem. To earn process memory, jet discovery must change the state
or future admissible operations, not merely reveal successive reductions of a
fixed input.

## Replay and rigor boundary

The load-bearing semantic adapter is now checked in
`formal/cubical/NaturalMachine/TerminalTraceCompression.agda` (`--cubical
--safe`, no holes or postulates).  For arbitrary set-valued maps `history` and
`terminal`, mutual `FiniteInformation.FactorsThrough` data construct an `Iso`
of their realized Cubical images, an `Iso` of every equality kernel, and an
`Iso` between the corresponding input fibres over each realized state.  This
checks the exact input from Theorem 2.1 used by the finite fibre-cardinality
argument.  More strongly, every set-valued downstream target factors through
the history exactly when it factors through the terminal record; the checked
adapter gives an `Iso` between those two factorization-witness types.  Thus the
two presentations have the same extensional question language even though
they can have different online acquisition costs.  It does **not** formalize
the residue-reduction arithmetic of
Theorem 2.1, finite cardinality maxima, a quantum circuit, or query latency.

A checked hostile control keeps the process boundary sharp: the identity Bool
history does not factor through a constant Unit terminal record.  Thus
one-directional erasure of branch-changing information cannot enter the mutual
compression theorem.

Under the current repository policy, the load-bearing replay is
`sh formal/check.sh`.  The Python commands below are retained as historical
provenance and must not be run or treated as current evidence.

Run:

```sh
cd machinery
python3 -m unittest test_adaptive_trace_process.py
python3 adaptive_trace_process.py
```

Theorem 2.1 and (4) are proved above. Finite tests check reconstruction and
fiber equality as falsifiers. No statement is made about optimal quantum query
complexity, noisy instruments, thermodynamic cost, quantum Markov order,
indefinite causal order, or physical spacetime.

---

*Appended 2026-08-19.* §5's boundary condition is now the **only** remaining
open case for adaptive observers, which is a promotion of this section, not a
correction to it. `formal/cubical/NaturalMachine/AdaptiveProbeCollapse.agda`
proves (pin-checked, `--safe`) that in the bare-probe-pool register every
finite adaptive strategy — next probe chosen from last outcome, randomisation
included — has kernel exactly the static full-pool kernel, so it annihilates
the charged sector. That closes every case except the ones §5 names: probes
that disturb the state, branch-dependent transformations between queries, and
noisy instruments. Write-up, which also refutes
`SIXTEEN_MINDS_ONE_THEOREM.md` §2's claim that this file fails to state its own
boundary: `notes/ADAPTIVE_OBSERVERS_ARE_ALREADY_FENCED.md`.
