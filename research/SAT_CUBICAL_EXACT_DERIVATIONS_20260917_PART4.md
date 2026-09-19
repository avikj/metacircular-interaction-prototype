# Exact Boolean-cube derivations for SAT — Part IV

**Date:** 2026-09-17

This part derives the global coverage identities directly from clause-incidence multiplicity. It is pure Boolean-cube arithmetic and gives a particularly compact answer to what each 3-clause contributes independently and where all dependence enters.

---

## 23. Violation multiplicity on each Boolean vertex

For a 3CNF with violating subcubes \(V_1,\ldots,V_m\subseteq Q_N\), define

\[
\nu(x)=\#\{\alpha:x\in V_\alpha\}.
\]

Thus \(\nu(x)\) is the number of clauses violated by assignment \(x\).

### Theorem 23.1 — total violation incidence is fixed before any overlap geometry is known

\[
\boxed{
\sum_{x\in Q_N}\nu(x)=m\,2^{N-3}.
}
\]

**Proof.** Double-count incidences \((x,\alpha)\) with \(x\in V_\alpha\). Counting by clause gives \(m\) sets each of cardinality \(2^{N-3}\). Counting by vertex gives \(\sum_x\nu(x)\). ∎

Normalized by \(2^N\),

\[
\mathbb E_{x\in Q_N}\nu(x)=\frac m8.
\]

This is the exact independent first-order contribution of the clauses. It is geometry-free: variable sharing and signs do not appear until intersections are considered.

### Corollary 23.2 — every exactly-3 clause contributes exactly \(1/8\) unit of violation mass

The first moment is additive:

\[
\frac1{2^N}\sum_x\nu(x)=\sum_{\alpha=1}^m\mu(V_\alpha)=\frac m8.
\]

This is distinct from the earlier \(3\to1\) carrier drop of two visible bits. Both are exact but measure different aspects of the same clause map.

---

## 24. Minimum number of exactly-3 clauses in an unsatisfiable formula

### Theorem 24.1 — eight-clause lower bound

If every clause contains three distinct non-tautological literals and \(F\) is UNSAT, then

\[
\boxed{m\ge8.}
\]

**Proof.** UNSAT means every vertex violates at least one clause, so \(\nu(x)\ge1\) for every \(x\). Hence

\[
2^N\le\sum_x\nu(x)=m2^{N-3}.
\]

Cancel \(2^{N-3}\) to obtain \(8\le m\). ∎

### Theorem 24.2 — the bound is sharp

Take three variables and all eight possible clauses whose unique falsifying vertices are the eight points of \(Q_3\). Then every assignment violates exactly one clause, so the conjunction is UNSAT with \(m=8\).

**Proof.** The eight violation singletons partition \(Q_3\). ∎

### Corollary 24.3 — the same argument gives the exact \(k\)-SAT clause-count floor

For exactly-\(k\) clauses on distinct variables, each violation subcube has measure \(2^{-k}\). Therefore an UNSAT exactly-\(k\)-CNF has

\[
m\ge2^k,
\]

with equality achieved by all \(2^k\) clauses on one fixed \(k\)-tuple of variables.

---

## 25. Equality at eight clauses forces a partition

### Theorem 25.1 — every eight-clause UNSAT formula has multiplicity one everywhere

If \(m=8\) and \(F\) is UNSAT, then

\[
\boxed{\nu(x)=1\quad\text{for every }x\in Q_N.}
\]

**Proof.** UNSAT gives \(\nu(x)\ge1\). Theorem 23.1 gives

\[
\sum_x\nu(x)=8\,2^{N-3}=2^N.
\]

There are \(2^N\) vertices and every summand is at least one, so every summand equals one. ∎

### Corollary 25.2 — the eight violation subcubes are pairwise disjoint and partition \(Q_N\)

A common vertex of two violation cubes would have multiplicity at least two, contradicting Theorem 25.1. Coverage is UNSAT, hence they form a partition.

This does **not** imply that all eight clauses use the same three coordinates; Boolean cubes admit nonparallel partitions. What is forced is exactly disjointness plus coverage.

---

## 26. Exact excess-overlap identity for every UNSAT 3CNF

For a covered vertex define its excess multiplicity

\[
e(x)=\nu(x)-1.
\]

For UNSAT every vertex is covered, so \(e(x)\ge0\).

### Theorem 26.1 — total excess overlap is determined solely by the clause count

If \(F\) is UNSAT, then

\[
\boxed{
\sum_{x\in Q_N}(\nu(x)-1)
=(m-8)2^{N-3}.
}
\]

**Proof.** Use Theorem 23.1 and subtract one for each of the \(2^N\) vertices:

\[
\sum_x(\nu(x)-1)
=m2^{N-3}-2^N
=(m-8)2^{N-3}.
\]

∎

Thus every clause beyond the first eight contributes exactly \(2^{N-3}\) units to the total violation multiplicity beyond the one unit per vertex required for coverage. The distribution of that excess is geometric; its total is fixed.

---

## 27. The same identity with uncovered vertices retained

For an arbitrary formula let

\[
U=\#\{x:\nu(x)=0\}=\#\mathrm{SAT}(F)
\]

and define

\[
E=\sum_{x:\nu(x)>0}(\nu(x)-1).
\]

### Theorem 27.1 — exact uncovered/excess balance

\[
\boxed{
U=2^N+E-m2^{N-3}.
}
\]

**Proof.** Split the first moment over covered vertices:

\[
\sum_x\nu(x)
=\sum_{\nu>0}\bigl(1+(\nu-1)\bigr)
=(2^N-U)+E.
\]

Equate with Theorem 23.1 and solve for \(U\). ∎

Normalized:

\[
\boxed{
\mu(F^{-1}(1))=1-\frac m8+\frac{E}{2^N}.
}
\]

### Corollary 27.2 — exact UNSAT criterion in excess form

\[
F\text{ UNSAT}
\iff
E=(m-8)2^{N-3}.
\]

For \(m<8\), the right-hand side is negative while \(E\ge0\), recovering Theorem 24.1.

This formula makes the role of overlap exact: the fixed first-order exclusion mass \(m/8\) would over-cover the cube once \(m>8\); overlap multiplicity returns that excess mass. SAT vertices are exactly the deficit left after that cancellation.

---

## 28. All higher cubical geometry is the factorial-moment tower

For \(r\ge0\), define

\[
M_r=\sum_{x\in Q_N}\binom{\nu(x)}r.
\]

Use \(M_0=2^N\).

### Theorem 28.1 — factorial moments are sums of \(r\)-fold clause intersections

\[
\boxed{
M_r=
\sum_{\substack{T\subseteq[m]\\|T|=r}}
\left|\bigcap_{\alpha\in T}V_\alpha\right|.
}
\]

**Proof.** For a fixed vertex \(x\), \(\binom{\nu(x)}r\) counts the \(r\)-element clause subsets all violated by \(x\). Double-count pairs \((x,T)\) with \(|T|=r\) and \(x\in\cap_{\alpha\in T}V_\alpha\). ∎

Using the partial-assignment intersection theorem from Part I,

\[
M_r=
\sum_{\substack{|T|=r\\T\text{ compatible}}}
2^{N-r(T)}.
\]

### Corollary 28.2 — the first moment contains no geometry

\[
M_1=m2^{N-3}.
\]

The first nontrivial incidence information appears at \(M_2\).

### Theorem 28.3 — exact pair-intersection contribution

For two 3-clause violation assignments with \(s\) shared coordinates:

- if they disagree on any shared coordinate, their intersection contributes zero;
- if they agree on all shared coordinates, they jointly fix \(6-s\) coordinates and contribute

\[
2^{N-(6-s)}=2^{N-6+s}
\]

to \(M_2\).

Thus each agreeing shared coordinate multiplies the pair overlap by exactly two relative to the disjoint-coordinate value \(2^{N-6}\).

---

## 29. SAT count is the alternating sum of the complete overlap tower

### Theorem 29.1 — pointwise binomial annihilation

For every integer \(q\ge0\),

\[
\sum_{r=0}^q(-1)^r\binom qr=
\begin{cases}
1,&q=0,\\
0,&q>0.
\end{cases}
\]

**Proof.** It is \((1-1)^q\), with the conventional value \((1-1)^0=1\). ∎

Apply this at \(q=\nu(x)\).

### Theorem 29.2 — exact moment formula for SAT

\[
\boxed{
\#\mathrm{SAT}(F)
=
\sum_{r=0}^m(-1)^rM_r.
}
\]

**Proof.** By Theorem 29.1, the inner alternating binomial sum equals one exactly on vertices with \(\nu(x)=0\), and zero on every violated vertex. Summing over \(x\) counts satisfying assignments. Exchange the finite sums to obtain the displayed factorial moments. ∎

This is exactly the inclusion–exclusion formula from Part I, reorganized by overlap order.

Normalized:

\[
\boxed{
\Pr(\nu=0)
=1-\frac m8+\frac{M_2}{2^N}-\frac{M_3}{2^N}+\cdots.
}
\]

There is no gap between “information” and “complexity” here: the Boolean answer is the exact alternating collapse of the cubical incidence tower.

---

## 30. Clause independence is now an exact special case

If the violation events were independent in the strict product sense, then

\[
\Pr(\nu=0)=(1-1/8)^m=(7/8)^m.
\]

For the disjoint-triple family this is not an approximation; the cube factors and the identity is exact. Its moment tower satisfies the binomial product identities automatically.

Whenever clauses share coordinates, Theorem 28.3 gives the exact deviation from the disjoint product at second order, and Theorem 28.1 gives every higher correction. Thus “dependence” is nothing beyond the ranks and compatibility of the actual subcube intersections.

---

## 31. One clean invariant package for the Boolean geometry

The entire finite coverage geometry can be packaged as

\[
\mathcal I(F)=
\bigl(
M_0,M_1,\ldots,M_m
\bigr),
\]

or more finely by the compatible partial assignments \(p_T\) themselves rather than only their cardinalities.

The scalar SAT count is the fixed projection

\[
\#\mathrm{SAT}(F)
=(1,-1,1,-1,\ldots)\cdot\mathcal I(F).
\]

The projection is extremely lossy: many different incidence towers can have the same final count, and SAT/UNSAT retains only whether that projection is zero.

The repository’s fibre discipline says exactly what to do with such a projection: retain the residual tower/trace rather than pretending the final scalar is the whole object.

---

## 32. What this adds to the geodesic discussion

The moment tower gives an exact **semantic decomposition** of the Boolean coverage bit, but Part III already proved that semantic size is not automatically metric cost. To turn any function of \((M_r)\) into a geodesic lower bound, one checks its change under the actual primitive interaction edges and applies the local-potential theorem.

The useful consequence is negative but exact: any proposed exponential lower bound derived solely from \(M_0=2^N\), from \(M_1=m2^{N-3}\), or from the raw number of nonzero higher intersections is invalid unless its primitive-edge Lipschitz law is also proved. The disjoint and sliding families are explicit counterexamples to those shortcuts.

Conversely, if a weighted combination of proof-relevant intersection classes is shown to decrease by at most one per paid primitive interaction, it becomes an immediate geodesic certificate by Part III, Theorem 17.1. No additional complexity vocabulary is needed.
