# Clean rolling cost is a functional of the learned digits

Write the unknown residue in base `p` as

\[
r=\sum_{\ell=0}^{k-1}d_\ell p^\ell,
\qquad 0\le d_\ell<p.
\]

The early-stopping protocol tests digits `0,...,p-2` in order and infers
`p-1` if all tests fail. Put

\[
q(d)=\begin{cases}d+1,&d\le p-2,\\p-1,&d=p-1.\end{cases}       \tag{1}
\]

## Exact branchwise theorem

**Theorem.** The variable-length clean rolling protocol has realized costs

\[
Q(r)=\sum_{\ell=0}^{k-1}q(d_\ell),                               \tag{2}
\]

forward valuation queries,

\[
O(r)=2Q(r),                                                       \tag{3}
\]

clean oracle invocations, and

\[
S(r)=\sum_{\ell=0}^{k-1}(q(d_\ell)-1)
     +\#\{\ell<k-1:d_\ell=p-1\}                                 \tag{4}
\]

new center-forming subtractions.

*Proof.* Equation (2) is the stopping rule. Every response is computed and
uncomputed before center mutation, giving (3). Within a level, moving through
`q(d)` tested centers takes `q(d)-1` subtractions. At a nonterminal boundary,
a tested successful digit makes the last center equal the next level's zeroth
center, costing zero. An omitted digit `p-1` leaves the chain at candidate
`p-2`; one further subtraction of `p^ell` forms the next prefix center. There
is no boundary after the terminal digit, proving (4). ∎

For `r=p^k-1`, every digit is omitted, so

\[
Q=k(p-1),\quad O=2k(p-1),\quad S=k(p-1)-1,
\]

recovering all worst-case counts. At the other extreme `r=0`, every digit is
the first tested value: `Q=k`, `O=2k`, `S=0`; the same center `p^k` and its
clean response are reused across levels, though the threshold comparison
changes with the level.

## State transformation

Cost is not a static annotation on a semantic center. It factors through the
entire learned output because that output records which cache transitions
occurred. This is a special exact instance of `CACHE_RELATIVE_FORMATION_COST`:
the digit prefix is simultaneously semantic state, provenance of the branch,
and the key to reconstructing its marginal arithmetic work.

## Rigor boundary

The formulas are proved for the declared digit order, canonical positive
centers, clean per-query uncomputation, and persistent rolling center. Tests
replay every bounded residue. No average-case distribution, alternate child
order, reversible gate cost, or global Pareto optimality is claimed.

