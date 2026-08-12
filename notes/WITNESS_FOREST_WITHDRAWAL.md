# Withdrawal-robust shortest witness forests

## 1. The exact object

Let `D=(V,E)` be the layered directed acyclic graph produced by reverse BFS
from immediate-disagreement seeds.  Its depth function satisfies

\[
  (u,v)\in E \quad\Longrightarrow\quad d(v)=d(u)-1.
\]

Every seed `z` of depth zero has a nonempty set `L(z)` of new observations
which distinguish its state-pair immediately.  Assign a nonnegative integer
weight `w(u)` to each pair-node.  Unit weight counts invalidated chosen proofs;
other weights can encode replay demand without changing the mathematics.

A **shortest witness forest** chooses

1. a root label `r(z) in L(z)` at every seed;
2. one pointer `p(u)` with `(u,p(u)) in E` at every nonseed.

The label of a nonseed is inherited along pointers:

\[
  r(u)=r(p(u)).                                             \tag{1}
\]

Because depth decreases exactly once per pointer, every chosen proof remains
shortest.  On withdrawal of observation `ell`, its invalidated chosen-proof
mass is

\[
  I_\ell(r)=\sum_{u:r(u)=\ell}w(u).                         \tag{2}
\]

The single-withdrawal minimax problem is therefore

\[
  \boxed{\min_{(p,r)}\ \max_\ell I_\ell(r)}.               \tag{WR}
\]

Nothing here says the underlying pair becomes indistinguishable after
withdrawal: `(WR)` measures invalidated *chosen certificates*.  A repair may
find another surviving proof.

## 2. Forests are constrained root-colorings

**Proposition 2.1.** Problem `(WR)` is exactly the following finite coloring
problem:

\[
\begin{aligned}
r(z)&\in L(z) &&\text{for every seed }z,\\
\exists v\in E(u):\ r(v)&=r(u) &&\text{for every nonseed }u,               \tag{3}
\end{aligned}
\]

with objective `(2)`.  From a coloring satisfying `(3)`, choosing any
same-colored successor reconstructs a shortest witness forest with that
coloring, and every shortest witness forest gives such a coloring.

*Proof.* Equation `(1)` proves the forward implication.  Conversely, `(3)`
supplies a pointer from every nonseed to a same-colored node one level nearer
a seed.  Iteration terminates at an allowed seed of the same color, and takes
exactly `d(u)` steps.  Thus the reconstructed pointer path is a shortest
witness with terminal observation `r(u)`.  The invalidation loads depend only
on `r`, so the objectives agree. ∎

This is the precise coupling omitted by assigning each node any observation
it can reach.  A canonical shared suffix has only one stored color; all proofs
using it inherit the same withdrawal fate.

## 3. Two smallest examples

Both phenomena first occur with four nodes (unit weights, two observations).

### Choice first changes robustness

Take three seeds `a0,a1,b` with fixed labels `A,A,B`, and a depth-one node
`u` with edges to `a0` and `b`.

- choosing `u -> a0` gives loads `(3,1)` and worst loss `3`;
- choosing `u -> b` gives loads `(2,2)` and worst loss `2`.

Thus shortest-parent choice can improve withdrawal robustness even though it
cannot change storage.  Fewer than four nodes cannot do this: two labels need
at least one available seed each; with at most one remaining unit node, the
two possible load vectors are `(2,1)` and `(1,2)`, with equal maximum.

### Independent reachability first becomes false

Take fixed seeds `a:A`, `b:B`, a depth-one node `c` pointing to either seed,
and a depth-two node `u` whose only successor is `c`.

An independent relaxation colors `c` and `u` differently and reports loads
`(2,2)`.  No forest realizes that coloring: `(3)` forces `r(u)=r(c)`.
Every actual forest has loads `(3,1)` or `(1,3)`, so its optimum is `3`.
Again three nodes cannot exhibit the gap: coupling needs two nonseeds while
two distinct removable labels need two roots.

This is not merely an integrality wrinkle.  Sharing a proof suffix is exact
compression, and exact compression creates a common failure domain.

## 4. Executable certificate

`machinery/witness_withdrawal.py` enumerates precisely the colorings in `(3)`,
reconstructs pointers, and minimizes `(WR)`.  It also computes the deliberately
false independent-reachability relaxation as a lower bound.  The tests contain
both four-node examples, a weighted instance, seed-label choice, and a
fail-closed rejection of non-shortest edges.

Run:

```bash
cd machinery
python3 -m unittest test_witness_withdrawal -v
```

The implementation is exponential in the worst case.  It is an exact solver
and counterexample generator for finite witness DAGs, not a tractability
claim.  Determining the complexity or exploiting the special synchronous-pair
graphs produced by arithmetic actions remains open.

## 5. What the objective reveals

Shortestness and robustness are two orders on the same proof graph:

- BFS depth controls how quickly a distinction can be replayed;
- root load controls how much executable distinction is entrusted to one
  observation.

The storage no-go remains intact: every canonical node still stores exactly
one pointer or one root label.  The new degree of freedom is not how much
memory exists but how dependence flows through it.  A compressed proof forest
is therefore also a fault domain.

## Rigor boundary

Proved here: the coloring equivalence, exact minimax objective, both minimal
four-node examples, and correctness of exhaustive enumeration relative to the
finite input contract.  Checked computation replays the examples but is not
used to prove their minimality.  Open: computational complexity, approximation,
multiple simultaneous withdrawals, and repair cost after withdrawal.
