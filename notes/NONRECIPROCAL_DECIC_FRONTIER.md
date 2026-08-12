# The nonreciprocal-decic frontier: sharp support geometry and a falsifier

The first finite factor layer not closed by the current prime-prefix program
is a nonreciprocal irreducible polynomial of degree ten.  This note extracts
the full root-radius information supplied by the odd prime support, sharpens
the continuous coefficient and Graeffe relaxations, and gives an exact
inhabiting witness.  The conclusion is deliberately negative but useful:
all listed support-local necessary filters can hold without producing a divisor
exclusion.

Let

$$
F_X(x)=\sum_{p\le X}x^{p-2}
$$

and suppose that a degree-ten polynomial divides some $F_X$.  The prior
degree-nine and reciprocal-decic theorems imply that it would be irreducible,
totally nonreal, nonreciprocal, monic, and have constant term $+1$.  Write it
as

$$
q=x^{10}+a x^9+b x^8+c x^7+d x^6+e x^5
  +f x^4+h x^3+i x^2+jx+1. \tag{0.1}
$$

The bounds below are necessary-condition geometry.  They do not assert that
such a divisor exists.

## 1. The odd-support root cage

For $X\ge3$, put $N=\max\{p\le X\}-2=2m+1$.  Then

$$
F_X(x)=1+\sum_{\ell=0}^{m}\varepsilon_{2\ell+1}x^{2\ell+1},
\qquad \varepsilon_{2\ell+1}\in\{0,1\},\quad\varepsilon_N=1.
$$

Every root $z$ of $F_X$, with $r=|z|$, satisfies the sharper strict cage

$$
\boxed{\varphi^{-1}<r<\sqrt2},
\qquad \varphi=\frac{1+\sqrt5}{2}. \tag{1.1}
$$

For the inner bound, if $r\le\varphi^{-1}$, then

$$
1\le\sum_{\ell=0}^{m}\varepsilon_{2\ell+1}r^{2\ell+1}
<\sum_{\ell\ge0}r^{2\ell+1}
=\frac{r}{1-r^2}\le1,
$$

a contradiction; the middle inequality is strict because $F_X$ is finite.
For the outer bound, the leading term gives, when $r\ge\sqrt2$,

$$
1\le r^{-N}+\sum_{k=1}^{m}r^{-2k}
\le 2^{-m-1/2}+\sum_{k=1}^{m}2^{-k}
=1-2^{-m}\left(1-\frac1{\sqrt2}\right)<1.
$$

The upper bound uses both monicity and the odd exponent support.  Replacing
it by the generic $0$--$1$ bound $r<2$ loses load-bearing information.

## 2. Pair-aware sharp coefficient relaxation

Because $q$ is totally nonreal, its roots form five conjugate pairs.  Let
$r_1,\ldots,r_5$ be their radii.  The unit constant term gives

$$
\prod_{k=1}^5r_k=1.
$$

Set

$$
A=\sqrt2,\qquad B=\varphi^{-1},
\qquad C=\frac{\varphi^2}{2}.
$$

In logarithmic coordinates, close the strict box $B<r_k<A$ and impose
$\sum\log r_k=0$.  At a vertex, four coordinates are at bounds.  If $s$ of
those four are upper coordinates, the compensating radius is

$$
c_s=\frac{\varphi^{4-s}}{(\sqrt2)^s}.
$$

Only $s=2$ is feasible.  Thus every vertex is a permutation of

$$
\boxed{(A,A,B,B,C).} \tag{2.1}
$$

Each Vieta modulus majorant is an elementary-symmetric sum in the ten-item
multiset $(r_1,r_1,\ldots,r_5,r_5)$.  It is a symmetric convex sum of
exponentials of the log radii, hence is maximized at (2.1).  Equivalently,
the nine suprema are the nonconstant coefficients of

$$
(1+Az)^4(1+Bz)^4(1+Cz)^2. \tag{2.2}
$$

The original cage is strict, so the boundary values are unattained
suprema.  Exact rational enclosures and integrality give, in the coefficient
order of (0.1),

$$
\boxed{
(|a|,|b|,|c|,|d|,|e|,|f|,|h|,|i|,|j|)
\le(10,51,142,257,312,258,144,51,10).
} \tag{2.3}
$$

The reversal of this vector is the bound indexed by ascending powers
$x^1,\ldots,x^9$.  This is sharp for the continuous modulus relaxation, not
a claim that an integral polynomial attains a corner.

The same vertex improves the endpoint cage.  Total nonreality makes
$q(1),q(-1)$ positive, and

$$
q(\pm1)\le\prod_{k=1}^{5}(1+r_k)^2
<(1+A)^4(1+B)^4(1+C)^2<1242.
$$

Consequently any hypothetical decic divisor has

$$
\boxed{1\le q(1),q(-1)\le1241.} \tag{2.4}
$$

## 3. Correctly oriented first Graeffe box

Split

$$
q(x)=E(x^2)+xO(x^2),
\qquad G(y)=E(y)^2-yO(y)^2.
$$

The roots of $G$ are the squares of the roots of $q$.  Squaring the radii in
(2.1) gives the descending elementary-symmetric bounds

$$
(12,72,231,456,581,477,248,78,13).
$$

Since $e_k$ controls $[y^{10-k}]G$, the vector indexed by **ascending**
exponents $y^1,\ldots,y^9$ is

$$
\boxed{(13,78,248,477,581,456,231,72,12).} \tag{3.1}
$$

The replay stores this exponent-addressed orientation.  Applying the
unreversed elementary-symmetric vector to ascending coefficients is not a
valid necessary filter.

## 4. An exact sharp-cage witness

Consider

$$
\boxed{q_1(x)=x^{10}+x^8+x^2+x+1.} \tag{4.1}
$$

`code/exp48_nonreciprocal_decic_frontier.py` verifies using only exact
integer and rational arithmetic that:

- $q_1$ is monic with constant term $1$, nonreciprocal, and positive on
  $\mathbb R$, hence totally nonreal;
- with $E=1+y+y^4+y^5$ and $O=1$,
  $\operatorname{Res}(E,O)=1$;
- $q_1(1)=5$ and $q_1(-1)=3$;
- exact Cayley--Routh counts give zero roots in $|z|<4/5$, four in
  $|z|<1$, and ten in $|z|<6/5$;
- therefore every root lies strictly inside the sharp prime-support cage,
  since $\varphi^{-1}<4/5<6/5<\sqrt2$;
- reduction modulo $17$ is irreducible by Rabin's degree-ten criterion;
- its coefficients and correctly oriented first-Graeffe coefficients lie in
  (2.3) and (3.1).

The exact first Graeffe polynomial, in ascending order, is

$$
G_1(y)=1+y+y^2+2y^4+4y^5+2y^6+y^8+2y^9+y^{10}.
$$

The cross-reversal trace data are

$$
\begin{aligned}
H_1(T)&=T^5+\tfrac12T^4-4T^3-2T^2+2T+1,\\
K_1(T)&=-T^3+2T.
\end{aligned}
$$

Since $K_1=-T(T^2-2)$,

$$
H_1(0)=1,
\qquad H_1(\pm\sqrt2)=-1\mp2\sqrt2,
$$

and the exact resultant is

$$
L=\operatorname{Res}(H_1,K_1)=-7.
$$

Thus the cross-reversal identity gives

$$
\operatorname{Res}(q_1,q_1^*)
=q_1(1)q_1(-1)L^2=5\cdot3\cdot49=735. \tag{4.2}
$$

Modulo $7$, the reversal collision is quadratic but not ramification:

$$
\gcd(q_1,q_1^*)=x^2+4x+1,
\qquad \gcd(q_1,q_1')=1.
$$

So even the sharp support cage, parity unit, endpoint compatibility,
irreducibility, total nonreality, and nontrivial unit-disk topology do not
force the cross index $L$ to be a unit.

## 5. Prime-count tether and exact scope

If $q_1$ divided some $F_X$, endpoint evaluation would require

$$
5\mid\pi(X),\qquad3\mid2-\pi(X),
$$

or equivalently

$$
\boxed{\pi(X)\equiv5\pmod {15}.} \tag{5.1}
$$

This congruence is a necessary tether, not evidence of divisibility.  No
division of an $F_X$ by $q_1$ is claimed or tested.  The witness shows only
that the current support-local filters have a common inhabitant; another
input must couple a candidate to the detailed sparse prime support, such as
exact prefix remainders, tail bounds, or stronger support congruences.

The discarded polynomial
$x^{10}-x^9-x^8+x^3+x^2+x+1$ remains an exact algebraic example for the
weaker outer bound $2$, but it fails the sharp $\sqrt2$ cage and is not a
valid witness for the present filter package.

## 6. Rigor and prior-art boundary

The odd-support root argument, parity resultant, Sturm and Cayley--Routh
counts, Rabin criterion, Vieta majorants, and convex maximization on a log
polytope are standard or established earlier in this repository.  The replay
uses rational intervals whose defining square inequalities and every integer
rounding are checked exactly; floating point is not used for decisions.

The project-specific content recorded here is narrow: the sharp degree-ten
support-local boxes with their correct orientation, and the explicit
certified witness proving that those filters do not close the nonreciprocal
decic layer.  No literature-level novelty claim is made.
