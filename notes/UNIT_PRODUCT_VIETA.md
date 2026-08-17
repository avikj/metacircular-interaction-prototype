# Unit-product Vieta compression

This note extracts the degree-independent convex lemma behind the sharp
reciprocal-decic coefficient box.  It is elementary; no novelty is claimed.
Its value here is computational: a unit constant term couples all root radii,
so treating the Vieta coefficients by independent root bounds wastes an
exponential amount of search.

## 1. The log-polytope theorem

Let $r_1,\ldots,r_n>0$, let $R>1$, and suppose

$$
r_i\le R,\qquad \prod_{i=1}^n r_i=1.
$$

For $1\le k<n$ put

$$
M_{n,k}(R)=\binom{n-1}{k}R^k+\binom{n-1}{k-1}R^{k-n}.
$$

**Theorem 1 (unit-product Vieta bound).**

$$
e_k(r_1,\ldots,r_n)\le M_{n,k}(R).
$$

The right side is the sharp maximum.  It is attained by permutations of

$$
(R,\ldots,R,R^{-(n-1)}).
$$

*Proof.*  Write $x_i=\log r_i$ and $L=\log R$.  The feasible set is the
compact polytope

$$
P=\{x\in\mathbb R^n:\ \sum_i x_i=0,\ x_i\le L\}.
$$

(The lower bound $x_i\ge-(n-1)L$ follows from the other $n-1$ upper
bounds.)  In logarithmic coordinates,

$$
f_k(x)=e_k(e^{x_1},\ldots,e^{x_n})
=\sum_{|I|=k}\exp\!\left(\sum_{i\in I}x_i\right)
$$

is convex and symmetric.  A convex function on a compact polytope has an
extreme-point maximizer.  An extreme point of $P$ must have at least $n-1$
active coordinate inequalities: if two coordinates are below $L$, a small
opposite perturbation preserves their sum and stays feasible, so the point is
not extreme.  Hence the extreme points are exactly the permutations of

$$
(L,\ldots,L,-(n-1)L).
$$

At such a point, a $k$-subset either omits or contains the exceptional
coordinate.  Summing the two cases gives

$$
\binom{n-1}{k}R^k+\binom{n-1}{k-1}R^{k-1}R^{-(n-1)},
$$

which is $M_{n,k}(R)$.  If the original inequalities are strict, the same
value is the sharp but unattained supremum, approached by the displayed
boundary configurations. $\square$

**Corollary 1.1 (universal conserved-radius vertex principle).**  Under the
same hypotheses, let $\Phi:\mathbb R^n\to\mathbb R$ be convex and symmetric.
Then

$$
\Phi(\log r_1,\ldots,\log r_n)
\le \Phi(L,\ldots,L,-(n-1)L),\qquad L=\log R.
$$

Indeed, the proof identified every extreme point of $P$, and symmetry makes
$\Phi$ take the same value at all of them.  Thus the same single vertex
simultaneously controls every symmetric convex observable of the log radii;
the elementary-symmetric Vieta bounds arise from
$\Phi(x)=e_k(e^{x_1},\ldots,e^{x_n})$.

## 2. Polynomial corollary

Let

$$
H(T)=T^n+c_1T^{n-1}+\cdots+c_n
$$

be monic, with roots $\tau_i$, $|\tau_i|\le R$, and $|c_n|=1$.  Since
$\prod_i|\tau_i|=1$, Theorem 1 and Vieta give

$$
|c_k|\le e_k(|\tau_1|,\ldots,|\tau_n|)\le M_{n,k}(R).
$$

When $c_k\in\mathbb Z$, this converts immediately to the corresponding
integer bound.  The theorem uses only a root-radius cap and a unit constant;
it is independent of reciprocity, prime prefixes, and the method used to
obtain those hypotheses.

## 3. Reciprocal-decic compression

For a reciprocal monic decic write

$$
g(x)=x^5H(x+x^{-1}),
$$

where

$$
H(T)=T^5+AT^4+BT^3+CT^2+DT+s.
$$

The parity-resultant unit equation forces $s=\pm1$.  The golden annulus for
prime-prefix factors gives $|\tau_i|<\sqrt5$ for every trace root.  Applying
Theorem 1 with $n=5$ and $R=\sqrt5$ gives

$$
\begin{aligned}
|A|&\le 4\sqrt5+\frac1{25}<9,\\
|B|&\le 30+\frac{4\sqrt5}{25}<31,\\
|C|&\le 20\sqrt5+\frac65<46,\\
|D|&\le 25+\frac4{\sqrt5}<27.
\end{aligned}
$$

Thus integrality yields

$$
|A|\le8,\qquad |B|\le30,\qquad |C|\le45,\qquad |D|\le26.
$$

The ordinary independent Vieta box contains $252{,}869{,}958$ labeled
tuples after $s=\pm1$; the unit-product box contains $10{,}002{,}902$, a
factor of $25.28$ fewer.  The reciprocal parity resultant then reduces this
box further to the exact quadratic norm equation

$$
D(C-AB)^2-B(C-AB)(s-AD)+(s-AD)^2=\pm1.
$$

Two independent exact enumerations of the displayed box leave $15{,}754$
tuples before root topology.  Sorting the records as
`A,B,C,D,s,K\n`, with $K$ the left side, gives SHA-256
`b953532bb421d3d243c68cd61358ba03b2def663cf2acb35370d26154ecdc3a6`.
This count is computational evidence bound to that serialization; the
convex coefficient theorem itself does not depend on it.

## 4. Information/computation reading

The variables $x_i=\log|\tau_i|$ are additive radial charges.  A unit
constant imposes the conservation law $\sum x_i=0$.  The coefficient
majorants are convex exponential observables, so their worst case lives at a
vertex: $n-1$ radii spend the full positive budget and one radius pays the
entire compensating debt.  This is a precise information reduction, not an
analogy: one global norm equation removes the spurious Cartesian freedom that
dominates a naïve enumeration.

The reusable policy is therefore: before assigning independent Vieta bounds,
move to log radii, impose every norm/product constraint, and maximize the
whole symmetric coefficient observable on the resulting polytope.  The
resulting theorem should generate the CPU box; the program should never
rediscover it by scanning.

## 5. Trust and prior-art boundary

The convex lemma and its proof are exact.  Applying it to a polynomial still
requires separate proofs of the root-radius cap and unit constant term.  The
$x+x^{-1}$ trace substitution and reciprocal-polynomial criteria are
classical; see Cafure--Cesaratto, *Amer. Math. Monthly* **124** (2017),
37--53, DOI 10.4169/amer.math.monthly.124.1.37.  We have not searched for this
precise boxed-product formulation in the inequalities literature, so it is
recorded as an elementary reusable synthesis, not a novelty claim.

> **PRIOR-ART SWEEP 2026-08-14 — now searched. RESOLVED-FOUND for the convex
> lemma's content; RESOLVED-NO-MATCH for the boxed-product packaging.**
> (Search-summary/śabda grade; `WebFetch` is EGRESS_BLOCKED, no source text
> read.) Maximising an elementary symmetric function of positive reals under a
> fixed-product / fixed-log-sum constraint is the majorization statement that
> **every elementary symmetric function $e_k$ is Schur-concave on the positive
> orthant** — classical, the standard home being Marshall–Olkin, *Inequalities:
> Theory of Majorization and Its Applications*, with the Schur-concavity and
> Schur-geometric-convexity of $e_k$ and its dual forms restated across the
> symmetric-function inequalities literature (e.g. RGMIA v10n2). The extremum
> therefore sits at the most-majorized point of the log-radius polytope, which
> is what §3's argument computes: **the lemma is known mathematics, and the
> right name for it is Schur-concavity, not a convexity ad hoc.** The
> Cafure–Cesaratto citation above is confirmed as a real paper. Nothing was
> located for the boxed reciprocal-decic coefficient formulation itself.
> Query: *maximize elementary symmetric function of positive reals subject to
> fixed product log-radius polytope Schur concavity bound polynomial
> coefficients Vieta*. Absence of a located source is not evidence of novelty.
> Attribution status only; the lemma, its proof and the box are unchanged.
