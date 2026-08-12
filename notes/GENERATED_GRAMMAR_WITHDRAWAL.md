# Generated observation grammars and retained separation

## 1. Observation names are not construction dependencies

`WITNESS_FOREST_WITHDRAWAL.md` treats a terminal observation label as one
removable root color.  Once observations are generated, that is too coarse.
Two different observations may use the same constructor, and one observation
may have several derivations using different constructors.

Let `C` be a finite set of grammar constructors or rules.  A **production** is
a triple

\[
  \pi=(\operatorname{name}(\pi),\operatorname{obs}(\pi),
       \operatorname{supp}(\pi)),\qquad
  \operatorname{supp}(\pi)\subseteq C,                     \tag{1}
\]

where `obs(pi)` is the semantic observation computed by the derivation and
`supp(pi)` records every rule on which that derivation depends.  Distinct
productions may compute the same observation.  Equal observation names do not
identify their provenance.

Use the layered shortest-witness DAG `D=(V,E)` from
`INCREMENTAL_WITNESS_FOREST`, with weight `w(u)` on each pair-node.  At each
seed `z`, let `P(z)` be the productions whose observations immediately
distinguish that pair.

A **generated witness forest** chooses one `pi_z in P(z)` at every seed and
one depth-decreasing pointer at every nonseed.  Each nonseed inherits the exact
root production reached by its pointer.  If rule `c` is withdrawn, the
invalidated chosen-proof mass is

\[
 I_c(\pi)=\sum_{u:\ c\in\operatorname{supp}(\pi_u)}w(u).    \tag{2}
\]

Equivalently, retained chosen separation is

\[
 R_c(\pi)=\sum_{u\in V}w(u)-I_c(\pi).                      \tag{3}
\]

Thus maximizing worst-case retained separation is exactly

\[
 \boxed{\max_\pi\min_{c\in C}R_c(\pi)
       =W-\min_\pi\max_{c\in C}I_c(\pi).}                 \tag{GWR}
\]

This is a hypergraph load problem: one production charges every constructor
in its support.  Constructor loads overlap and need not sum to total weight.

The productions can be supplied directly by the constructor graph of
`CONSTRUCTOR_GRAMMAR_FORMATION`: a predecessor path to a separating program is
a derivation certificate, and its edge/rule labels give `supp(pi)`.  That
formation theorem minimizes the cost of making one observation.  `(GWR)` asks
a different question after several observations have been formed: how should
their certified derivations be selected so that one lost constructor erases
as little separation as possible?  A cheapest derivation may therefore be
dominated in robustness, and neither objective silently replaces the other.

## 2. Exact reduction

**Theorem 2.1 (production-coloring theorem).** Generated witness forests are
equivalent to assignments `u -> pi_u` satisfying

\[
\begin{aligned}
 \pi_z&\in P(z) &&\text{for every seed }z,\\
 \exists v\in E(u):\ \pi_v&=\pi_u
     &&\text{for every nonseed }u.                         \tag{4}
\end{aligned}
\]

Under this equivalence, rule-withdrawal loss is exactly `(2)`, so exhaustive
optimization of `(4)` solves `(GWR)`.

*Proof.* A forest assigns each node the production at its terminal root; its
chosen successor has the same production, giving `(4)`.  Conversely, select
for every nonseed a same-production successor guaranteed by `(4)`.  Depth
decreases by one, so the path terminates after exactly `d(u)` steps at a seed
whose production is valid there.  The resulting witness remains shortest.
Withdrawal of `c` invalidates precisely those chosen derivations whose support
contains `c`, which is `(2)`. ∎

If every production has singleton support equal to its observation label,
this reduces exactly to `WITNESS_FOREST_WITHDRAWAL`.  The earlier theorem is a
special case, not a competing objective.

## 3. The smallest strict example

Take two depth-zero pair-nodes `z2,z3`, both of unit weight.  Declare three
productions:

\[
\begin{array}{c|c|c}
\text{production}&\text{semantic observation}&\text{support}\\ \hline
\pi_2&q_2&\{Q,N_2\}\\
\pi_{3,Q}&q_3&\{Q,N_3\}\\
\pi_{3,D}&q_3&\{D_3\}.
\end{array}                                                \tag{5}
\]

Here `Q` is a generic additive-quotient constructor, `N_m` supplies its
modulus, and `D_3` is a direct divisibility-by-three constructor.  The table
declares two exact derivations of the same mod-3 semantics; it does not claim
one syntax is preferable before withdrawal is considered.

Require `z2` to use `pi_2`; allow `z3` either mod-3 production.

- Choosing `pi_{3,Q}` makes `I_Q=2`: withdrawing the shared quotient rule
  destroys both chosen separations.
- Choosing `pi_{3,D}` gives `I_Q=1` and `I_{D_3}=1`; every single rule
  withdrawal destroys at most one separation.

So the grammar-aware optimum improves worst retained separation from zero to
one.  Atomic observation labels miss the defect: they see one `q2` root and
one `q3` root and report maximum label load one in both cases.

Two nodes are minimal for a strict improvement under unit weights.  With one
node, every used rule has load one and no selection can make the worst
positive load smaller than one.  The two-node example is therefore the first
possible separation between semantic diversity and constructional diversity.

This is the precise finite sense in which a generated arithmetic lens has a
metabolism.  What matters under injury is not only what it sees, but how the
capacity to see was made.

## 4. Executable solver

`machinery/grammar_withdrawal.py` exhaustively enumerates the assignments in
`(4)`, reconstructs replay pointers, computes overlapping rule loads, and
returns the minimax production choice.  Tests verify:

1. the minimal two-seed strict improvement;
2. failure of atomic semantic labels to predict common-rule damage;
3. inheritance of exact derivation support along shared suffixes;
4. overlapping weighted rule loads;
5. fail-closed rejection of non-shortest edges.

Run:

```bash
cd machinery
python3 -m unittest test_grammar_withdrawal -v
```

## 5. Rigor boundary

Proved: the finite production-coloring equivalence, objective `(GWR)`, its
reduction to the earlier label-withdrawal theorem, and minimality of the
two-node example.  Checked: the exhaustive implementation on the declared
examples.

The model retains one derivation per chosen root.  If the organism stores
several alternative derivations and may recompile after withdrawal, the state
must include that derivation bank and repair policy; its robustness can be
strictly greater.  Multiple-rule withdrawal, storage/robustness tradeoffs for
derivation banks, and complexity on synchronous arithmetic pair graphs remain
open.  No claim is made that the sample grammar is canonical or that every
useful observation has such a finite support.
