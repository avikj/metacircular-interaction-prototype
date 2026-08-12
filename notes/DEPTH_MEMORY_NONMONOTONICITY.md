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
monotonicities oppose one another, so no monotone law relates semantic depth
to reversible memory without additional fiber-balance hypotheses.

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

The arithmetic organism must track at least three independent costs:

1. semantic depth or terminal chart precision;
2. acquisition/hitting time for a critical witness;
3. reversible overwrite memory, determined by current fiber balance.

It must not route quantum resources from p-adic depth alone. After each
encounter, it should recompute or update the selected chart's fiber profile.
A finer theorem can make the output more informative and simultaneously make
coherent garbage cheaper because it splits a formerly large fiber.

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
