# Prefix caches carry a monotone submodular future value

## Exact object

Let `T` be a finite rooted tree with depth `d(v)`.  A future request for a
vertex `t` replays the unique root-to-`t` construction path.  Give requests
nonnegative weights `w_t`.  The root is always available.  For an additional
retained cache `S`, define

\[
 m_t(S)=\max\{d(v):v\in S\cap P_t\}\quad(\max\varnothing=0),
 \qquad F(S)=\sum_t w_t m_t(S),                         \tag{1}
\]

where `P_t` is the root-to-`t` path.  Thus `F(S)` is expected saved prefix
work and `\sum_t w_t(d(t)-m_t(S))` is expected remaining construction work.
Unlike cache cardinality or total past work, (1) retains labeled incidence
with declared futures.

## Theorem 1 — diminishing returns

`F` is normalized, monotone, and submodular.

**Proof.**  Fix a request `t`.  Adding `x` changes its summand by zero if
`x\notin P_t`, and otherwise by

\[
 w_t\max(0,d(x)-m_t(S)).                                \tag{2}
\]

If `S\subseteq R`, then `m_t(S)\le m_t(R)`, so (2) for `S` is at least (2)
for `R`.  Summing this diminishing-returns inequality over `t` proves
submodularity.  Nonnegativity gives monotonicity, and `F(\varnothing)=0`.
\(\square\)

The hypothesis `w_t\ge0` is load-bearing: a negative request weight reverses
the inequality.  Likewise, cache value is not determined by `|S|`; two
equal-sized caches can have incomparable future profiles.

## Theorem 2 — exact bounded-retention recursion

Tree geometry gives an exact optimizer, not only the generic submodular greedy
bound.  Permit a weight `w_v` at every vertex.  Let

\[
G(v,b,a)
\]

be the maximum contribution from the subtree rooted at `v`, using at most
`b` selected vertices there, when the deepest already selected strict ancestor
has depth `a`.  If the children of `v` are `c_1,\ldots,c_r`, then

\[
\begin{aligned}
G_0(v,b,a)&=w_v a+
 \max_{b_1+\cdots+b_r\le b}\sum_iG(c_i,b_i,a),\\
G_1(v,b,a)&=w_vd(v)+
 \max_{b_1+\cdots+b_r\le b-1}\sum_iG(c_i,b_i,d(v)),\\
G(v,b,a)&=\max(G_0(v,b,a),G_1(v,b,a)),                  \tag{3}
\end{aligned}
\]

with `G_1=-\infty` when `b=0` and the empty-child sum zero.  The optimum with
budget `B` is `G(root,B,0)` (selecting the depth-zero root is immaterial).

**Proof.**  Every feasible cache either contains `v` or does not.  In the
first case `v` becomes the deepest cached prefix shared by all descendant
requests until a deeper selected vertex; in the second, the inherited depth
remains `a`.  Once that choice is fixed, child subtrees interact only through
the integer budget allocation.  These are exactly the two exhaustive cases
and the convolutions in (3), so induction on subtree size proves the claim.
\(\square\)

## Relation to witness forests

The operation is the positive dual of certificate invalidation.  In a
construction tree, a retained ancestor saves every descendant request's
prefix.  In a chosen witness forest, withdrawing a root label invalidates
every certificate routed to it.  Both depend on labeled predecessor incidence,
not node counts.  Arbor's shortest-witness DAG is generally a DAG rather than
a tree; (3) does not transport there, and shared descendants can restore the
coupling seen in `WITNESS_FOREST_WITHDRAWAL`.

## Replay and rigor boundary

Run:

```sh
cd machinery
python3 -m unittest test_prefix_cache_submodularity.py -v
```

The tests exhaust every cache pair on a fixed branching tree, compare (3)
against exhaustive budgeted selection, and include the known-false control
that equal cache sizes imply equal future value.  They are checks, not the
proof.  The results assume a fixed construction tree, additive nonnegative
future weights, unit cache capacity per retained vertex, and free replay from
the deepest cached prefix.  DAG grammars, cache-dependent formation traces,
eviction costs, and dynamically generated futures remain outside the theorem.
