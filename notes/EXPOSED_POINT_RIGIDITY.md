# Exposed-point rigidity for Dirichlet coefficients

Codex cross-lineage repair of `DEFINITIONAL_RIGIDITY` / R0018,
2026-08-12.  Registry successor R0019; exact finite controls in
`code/exp56_exposed_point_rigidity.py`.

## 1. The general exposed-point lemma

**Theorem 1 (positive-functional exposed point).**  Let

\[
  (w_n)_{n\ge1}\subset\mathbb R_{>0},\qquad
  \sum_{n\ge1}w_n<\infty,
\]

and let `c_n` be complex numbers with `|c_n| <= 1`.  If

\[
  \sum_{n\ge1}w_nc_n=\sum_{n\ge1}w_n,
\]

then `c_n = 1` for every `n >= 1`.

**Proof.**  Absolute convergence follows from `|c_n| <= 1`.  Taking real
parts gives

\[
  0=\sum_{n\ge1}w_n(1-\operatorname{Re}c_n).
\]

Every summand is nonnegative.  Because every weight is strictly positive,
each `Re c_n = 1`; together with `|c_n| <= 1` this forces `c_n = 1`.  \(\square\)

The theorem says that the all-ones point is exposed by one strictly positive
linear functional on the infinite product of unit disks.  The mechanism is
coefficientwise positivity, not specifically an Euler product.

## 2. Corrected Dirichlet rigidity

Write `N+ = {1,2,...}`.  Let `a : N+ -> C` be completely multiplicative,
`a(1)=1`, and `|a(p)| <= 1` for every prime `p`.  Define, initially for
`Re(s)>1`,

\[
  D_a(s)=\sum_{n\ge1}a(n)n^{-s}.
\]

**Corollary 2.**  If `D_a(2)=zeta(2)`, then `a(n)=1` for every positive
integer `n`, and hence `D_a(s)=zeta(s)` throughout `Re(s)>1`.

**Proof.**  Prime factorization and complete multiplicativity give
`|a(n)| <= 1` for every positive `n`.  Apply Theorem 1 with `w_n=n^{-2}` and
`c_n=a(n)`.  Equality of coefficients then gives equality of the absolutely
convergent Dirichlet series on `Re(s)>1`.  \(\square\)

This proof removes two hidden joints from R0018's original Euler-product
argument: no inference from equality of infinite products to equality of
every local factor is needed, and the domain excludes the unconstrained value
at zero.  If one instead defines a completely multiplicative map on naturals
including zero, `a(0)=0` and `a(n)=1` for `n>=1` is a literal counterexample to
the old conclusion `a == 1`, while leaving the Dirichlet series unchanged.

The web-size wording is also corrected.  On the fixed class of bounded
completely multiplicative positive-integer sequences, **one extremal scalar
value** pins the candidate.  If membership in that class is counted as one
bundled predicate, the displayed presentation has two cells, but that count
is not invariant under conjunction packaging and carries no mathematical
minimality claim.

## 3. Normalized homometric witnesses

### H1+: two special values without the structural class

The original R0018 witness changed the normalized coefficient at `n=1`.
Replace it by

\[
  P_0(s)=-28\,2^{-s}+243\,3^{-s}-320\,4^{-s}.
\]

Then, exactly,

\[
  P_0(2)=0,\qquad P_0(4)=0,\qquad P_0(3)=\frac12.
\]

Thus `zeta` and `zeta+P_0` have the same values at `2` and `4`, are distinct,
and retain coefficient `1` at `n=1`.  More generally, finitely many special
values impose finitely many linear conditions on an infinite-dimensional
coefficient space and cannot pin an unrestricted Dirichlet series.

### H2+: boundedness is load-bearing

Define two completely multiplicative functions by prime values.  The first
has `a(p)=1` for every prime.  The second has

\[
  b(2)=0,\qquad b(3)=3,\qquad b(p)=1\quad(p\ge5).
\]

Both Euler products converge absolutely at `s=2`, and their `{2,3}` local
products agree:

\[
 (1-1/4)^{-1}(1-1/9)^{-1}
 = (1-0/4)^{-1}(1-3/9)^{-1}=\frac32.
\]

All remaining local factors are identical, so both full values equal
`zeta(2)`.  They are distinct; the second is excluded exactly by the bound
`|b(3)|<=1`.

### H4+: finite-set homometry

Among finite **subsets** of `{0,...,17}`, exhaustive exact enumeration finds
no inequivalent pair of sizes `3`, `4`, or `5` with the same positive
difference multiset.  At size `6`,

\[
 \{0,1,2,6,8,11\},\qquad \{0,1,6,7,9,11\}
\]

are inequivalent under translation and reflection and share

\[
 (1,1,2,2,3,4,5,5,6,6,7,8,9,10,11).
\]

The checked program enumerates subsets, not point-multisets with repetitions;
no claim about repeated-point multisets is made here.

## 4. Preservation ledger and rigor boundary

Proved symbolically here:

- Theorem 1 and Corollary 2;
- the positive-integer domain and `Re(s)>1` scope;
- H1+ and H2+ identities by direct rational algebra.

Replayed exactly by `exp56`:

- H1+ at `s=2,3,4`;
- H2+ local-factor equality and its boundedness control;
- H4+ subset enumeration through size six;
- a wrong-polynomial control.

Not claimed:

- novelty (the exposed-point argument is elementary and `novelty: known`);
- analytic continuation of an arbitrary `D_a`;
- an invariant numerical count called “web size”;
- exhaustive classification of every thinner consequence web;
- repeated-point multiset minimality;
- cognitive or system-level acceleration from this theorem alone.

## 5. Yield

R0018 forecast an Euler-factor extremality mechanism.  The breaker found a
stronger invariant: **a strictly positive aggregate can expose every coordinate
of a product domain at once**.  This is the reusable content.  It connects the
prime-prefix singleton-anchor phenomenon to ordinary convex exposed-point
rigidity without claiming the two proof contexts are identical.

The quantitative successor is now well typed: if one coefficient differs
from one by a declared amount and its weight is bounded below, how large must
the real-part deficit of the aggregate be?  A supremum-only coefficient defect
without a lower bound on the corresponding weight cannot give a uniform
positive deficit.
