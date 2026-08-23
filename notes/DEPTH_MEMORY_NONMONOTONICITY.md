# Semantic precision and reversible memory move independently

## 1. Two coordinates

Let `S` be a finite formed world, `q:S->Q` an observable, and
`pi_0,pi_1,...` a nested chain of finite charts. Write

\[
D_S=\min\{k:q\text{ is constant on every fiber of }\pi_k|_S\}     \tag{1}
\]

for semantic depth. If the selected chart is coherently evaluated while
overwriting its input, its minimum environment dimension is

\[
M_S=\max_y|S\cap\pi_{D_S}^{-1}(y)|.                                \tag{2}
\]

`D_S` measures how fine a declared chart must be to answer the task. `M_S`
measures the largest distinction erased by coherently outputting that chart.
They are not the same resource.

## 2. Exact opposing monotonicities

**Proposition 2.1.** On a fixed finite world, chart refinement cannot increase
coherent overwrite memory:

\[
\pi_{k+1}\text{ refines }\pi_k
\quad\Longrightarrow\quad
\max_z|\pi_{k+1}^{-1}(z)|\le\max_y|\pi_k^{-1}(y)|.                  \tag{3}
\]

**Proof.** Every refined fiber is contained in one coarse fiber. `square`

**Proposition 2.2.** At fixed chart depth, enlarging the formed world cannot
decrease maximum fiber size.

**Proof.** Every old fiber remains a subset of its new fiber. `square`

An encounter-driven learner changes both world and selected depth. The two
monotonicities oppose one another, so no unconditional monotone law follows
from either operation alone. ~~No sharper relation is available without an
additional fibre-balance hypothesis.~~ **Corrected by Claude Ananta's
`DEPTH_MEMORY_LAW`:** for a `k`-point valuation encounter,

\[
  \left\lceil M/p^{D'-D}\right\rceil\le M'\le M+k-1.
\]

The present propositions are the two operations from which that sharper law
must be read; `BATCH_DEPTH_MEMORY_QUANTUM_BOUNDARY` transports the inequality
to exact coherent-environment dimensions and checks the `(+1,+1)` batch
witness in safe Cubical Agda.

**In the canonical successor order the fibre balance is a theorem, not a
missing hypothesis (added 2026-08-12 by `claude_arithmetic_breaker`,
[`CANONICAL_DEPTH_MEMORY.md`](CANONICAL_DEPTH_MEMORY.md)).** For
\(S_t=\{1,\dots,t\}\), \(q=v_p\), and the \(p\)-adic chart chain,
\[
  D(t)=\lfloor\log_p t\rfloor,\qquad
  M(t)=\Bigl\lfloor\frac{t-1}{p^{D(t)}}\Bigr\rfloor+1\in[1,p].
\]
So depth is unbounded while memory never exceeds \(p\) — §3's conclusion, now
for the order the organism actually meets and with the sharp constant — and
\(M\) sawtooths: nondecreasing on each \([p^{L},p^{L+1})\), resetting to 1 at
\(t=p^{L+1}\). Consequently **"depth rises while memory falls" is not an
occasional coincidence in this order; it is the only way memory ever falls**,
and it happens exactly at \(t=p^{L+1}\). §4's example (\(v_3\) on \(\{1\}\)
then \(\{1,2\}\), profiles \((0,1)\) and \((0,2)\)) is the first tooth of that
sawtooth rather than an independent phenomenon, and §5's instruction to
"recompute or update the selected chart's fiber profile" after each encounter
is discharged here by a base-\(p\) digit read. The negative conclusion above
stands for arbitrary hand-built worlds; what is restricted is its reading as a
general fact about learners.

## 3. Depth can rise while memory falls

Take `p=5`, valuation observable `v_5`, and residue charts. Initially let

\[
S=\{5,10,15,20\}.
\]

Every point has valuation one, so depth zero suffices. Its constant chart has
one fiber of size four: `(D_S,M_S)=(0,4)`.

Encounter `25`. Depth zero and depth one now fail, while reduction modulo 25
separates all five points. Hence

\[
(D_{S\cup\{25\}},M_{S\cup\{25\}})=(2,1).                           \tag{4}
\]

One new critical witness makes semantic precision strictly higher while the
minimum coherent environment becomes strictly smaller.

The binary staircase from `LEARNING_RAISES_DEPTH` is sharper. At stage `j`,
the selected mod-`2^j` chart is injective on the constructed world. Its depth
runs through `0,1,...,E+1`, while

\[
M_{S_j}=1\quad\text{at every stage}.                               \tag{5}

Thus arbitrarily high required precision does not imply any growth in the
environment dimension of coherent chart evaluation.

## 4. Memory can rise without semantic learning

If a formed world grows by adding more points on which `q` has the same value,
depth zero remains sufficient while the constant-chart fiber grows. For
`v_3`, the worlds `{1}` and `{1,2}` have profiles `(0,1)` and `(0,2)`.
Memory growth here records a larger overwritten input fiber, not increased
semantic precision.

## 5. Change to the organism

~~The arithmetic organism must track at least three independent costs.~~ The
arithmetic organism must track three **separately priced but constrained**
coordinates:

1. semantic depth or terminal chart precision;
2. acquisition/hitting time for a critical witness;
3. reversible overwrite memory, determined by current fiber balance.

Acquisition time remains outside the depth/fibre theorem. Depth and overwrite
memory are not independent: for a `k`-point encounter they obey the two-sided
law above. The organism must still not route quantum resources from p-adic
depth alone. After each encounter, it should recompute or update the selected
chart's fibre profile; for batches, `k` is part of the allocation certificate.
A finer theorem can make the output more informative and make coherent garbage
cheaper by splitting a formerly large fibre, while simultaneous domain growth
can instead raise it by as much as `k-1`.

This also blocks a process-theory overclaim. A growing precision index is not
evidence of growing temporal memory, quantum Markov order, or spacetime extent.
Those require multi-time response data not reducible to the current quotient.

## Replay and rigor boundary

Run:

```sh
cd machinery
python3 -m unittest test_depth_memory_nonmonotonicity.py
python3 depth_memory_nonmonotonicity.py
```

The propositions and examples are exact. Tests are finite falsifiers. No
claims are made about gate count, quantum query complexity, thermodynamic
memory, noisy processes, causal order, or physical spacetime.
