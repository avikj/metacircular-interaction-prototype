# Quintic factors of the prime-prefix polynomial

> *Pointer (genius-12, 2026-08-14, no other edit made):*
> `notes/REFLECTION_NORM.md` §6 audits §2 below and reports one unstated
> load-bearing step in the $|c|$ bound (the substitution $q=t^{-1/2}$, needed
> for $4tq<10/3$; margin $17/4800$), plus the fact that (1.4)/(1.6) are
> `notes/PARITY_RESULTANT.md` Theorem 1b. Equation (1.5) is machine-checked
> in `formal/cubical/ParityNormEliminant.agda` (`syl-quintic-closed`,
> `res-quintic-roots`).

For real $X\ge2$, put

$$F_X(x)=\sum_{\substack{p\le X\\p\ \mathrm{prime}}}x^{p-2}.$$

This note proves the exact degree-five analogue of `CUBIC_OBSTRUCTION.md` and
the quartic certificate:

> **Theorem.** The polynomial $F_X$ has an irreducible quintic factor if and
> only if
> $$7\le X<11.$$
> On this interval
> $$F_X(x)=x^5+x^3+x+1$$
> is itself irreducible.

The proof has two ingredients.  Reflection $x\mapsto-x$ forces a quadratic
resultant to be a unit.  Odd degree then supplies a unique negative real root,
turning the remaining finite problem into a monotone one-variable
certificate.  The finite part is reproduced exactly by
`code/exp31_quintic_certificate.py`; it uses only integer and rational
arithmetic.

## 1. Reflection forces a unit resultant

Every prime-prefix polynomial has the form

$$P(x)=1+xA(x^2),$$

and therefore

$$P(-x)=2-P(x).\tag{1.1}$$

Suppose that an irreducible quintic $g$ divides $P$.  Since $P$ is monic and
has constant coefficient one, Gauss's lemma lets us write

$$g(x)=x^5+ax^4+bx^3+cx^2+dx+\epsilon,$$

where $a,b,c,d\in\mathbb Z$ and $\epsilon=\pm1$.

The polynomial $P$ is positive on $[0,\infty)$, while

$$P(-t)=1-\sum_{p\le X\atop p\ge3}t^{p-2}$$

is strictly decreasing from $1$ to $-\infty$.  Hence $P$ has exactly one real
root, and it is negative.  A quintic factor must contain this root and no
other real root.  Its remaining roots are two conjugate pairs, so its root
product is negative.  Since the root product of a monic quintic is
$-\epsilon$, this forces $\epsilon=1$.

Split $g$ into its even and odd parts:

$$
g(x)=E(x^2)+xO(x^2),
\qquad
E(y)=ay^2+cy+1,
\qquad
O(y)=y^2+by+d.
$$

At every root $\alpha$ of $g$, (1.1) gives $P(-\alpha)=2$.  Thus

$$\operatorname{Res}_x(g,P(-x))=2^5=32.\tag{1.2}$$

On the other hand, $g(-x)$ divides $P(-x)$ and

$$
\begin{aligned}
\operatorname{Res}_x(g,g(-x))
 &=\operatorname{Res}_x(g,-2xO(x^2))\\
 &=32\operatorname{Res}_y(O,E)^2.
\end{aligned}\tag{1.3}
$$

For completeness, the square in (1.3) comes from pairing the two roots
$\pm\sqrt y$ above each root $y$ of $O$: modulo $O(x^2)$ one has
$g(x)=E(x^2)$, and the two evaluations contribute $E(y)^2$.  The remaining
signs cancel because $\deg g$ is odd and $g(0)=1$.

By multiplicativity of the resultant, (1.3) divides (1.2).  Consequently

$$\boxed{\ \operatorname{Res}_y(O,E)=\pm1.\ }\tag{1.4}$$

For the two quadratics here, (1.4) is the explicit Diophantine equation

$$
\boxed{
D(a,b,c,d):=(1-ad)^2-(c-ab)(b-cd)=\pm1.
}\tag{1.5}
$$

Equivalently, with $A=c-ab$ and $B=1-ad$,

$$D=B^2-bAB+dA^2.$$

Equation (1.4) also says that $E$ and $O$ are a unimodular pair in
$\mathbb Z[y]$: there exist $U,V\in\mathbb Z[y]$ with $EU+OV=1$.

The same argument works in every odd degree.  If
$g=E(x^2)+xO(x^2)$ is monic of degree $2m+1$ and has constant coefficient
one, then

$$
\operatorname{Res}_x(g,g(-x))
=2^{2m+1}\operatorname{Res}_y(O,E)^2.
\tag{1.6}
$$

Thus reflection converts any odd-degree factor of an odd-support Newman
polynomial into an integral unit-resultant problem.

## 2. A finite coefficient box

Write the roots of $g$ as

$$-t,\qquad re^{\pm i\theta},\qquad se^{\pm i\phi}.$$

Because $P(-t)=0$ and $X\ge7$ for a quintic factor,

$$1=t+t^3+t^5+\cdots.$$

Let $\lambda=(\sqrt5-1)/2$.  Bounding a finite odd sum by the full odd
geometric series gives

$$1<\frac{t}{1-t^2},$$

while $t+t^3+t^5>1$ at $t=2/3$.  Hence

$$\lambda<t<\frac23.\tag{2.1}$$

The same geometric argument shows that every root of $P$ inside the unit
circle has modulus greater than $\lambda$.  The elementary leading-term
triangle inequality gives modulus less than $2$ for every root.  Finally,
the product of the five root moduli gives

$$t r^2s^2=1,
\qquad
q:=rs=t^{-1/2},
\qquad
\sqrt{3/2}<q<\sqrt\varphi,
\tag{2.2}$$

where $\varphi=1/\lambda$.

Assume $r\ge s$.  Maximizing $r+q/r$ subject to
$\lambda<s\le r<2$ gives

$$r+s<2+\frac{\sqrt\varphi}{2}<\frac{211}{80}.\tag{2.3}$$

Similarly,

$$r^2+s^2<4+\frac\varphi4<\frac{141}{32},
\qquad
q<\frac{51}{40}.\tag{2.4}$$

Vieta's formulas now give a small integral box.  For the $x^4$ coefficient,

$$|a|<t+2(r+s)<6,$$

so $|a|\le5$.  Applying the same estimate to the inverse roots gives

$$
|d|
<\frac1t+2\frac{r+s}{q}
<\frac{13}{8}+2\frac{211}{80}\frac56
<7,
$$

so $|d|\le6$.

For the pair products,

$$
|b|
< (r^2+s^2)+4q+2t(r+s)
<\frac{141}{32}+\frac{51}{10}+\frac{211}{60}
<14,
$$

so $|b|\le13$.  Split the triple products according to whether they contain
the real root.  Those containing it contribute at most

$$
t(r^2+s^2)+4tq
<\frac{47}{16}+\frac{10}{3}
=\frac{301}{48},
$$

while the four all-complex triple products contribute at most

$$2q(r+s)<\frac{10761}{1600}.$$

The sum is strictly less than $13$, so $|c|\le12$.  We have proved

$$
\boxed{
|a|\le5,\quad |b|\le13,\quad |c|\le12,\quad |d|\le6.
}\tag{2.5}
$$

## 3. Exact finite reduction

Inside (2.5), equation (1.5) has exactly $1{,}591$ integer solutions.  Exact
Sturm root counts retain those having one real root.  If

$$h(t)=g(-t)=1-dt+ct^2-bt^3+at^4-t^5,$$

then (2.1) is checked without approximation by

$$h(\lambda)>0,\qquad h(2/3)<0.$$

The first sign lies in $\mathbb Q(\sqrt5)$ and is compared exactly using
$\lambda^2=1-\lambda$.

A surviving reducible quintic would have either a rational root $\pm1$ or a
monic quadratic factor $x^2+ux+\epsilon$, where $\epsilon=\pm1$.  Because
the factor's roots have modulus below $2$, $|u|<4$.  Testing the fourteen
pairs $(u,\epsilon)$ by exact polynomial division completes the
irreducibility filter.

Exactly eighteen candidates remain:

$$
\begin{gathered}
(-5,6,5,1),\ (-4,5,4,1),\ (-3,4,3,1),\ (-2,3,2,1),\\
(-1,1,-1,0),\ (-1,2,1,1),\ (0,1,0,1),\ (0,3,0,0),\\
(0,6,0,-1),\ (0,8,0,-2),\ (0,9,0,-2),\ (0,10,0,-3),\\
(0,11,0,-3),\ (0,12,0,-4),\ (0,13,0,-4),\\
(1,0,-1,1),\ (1,4,3,2),\ (2,0,-3,0).
\end{gathered}\tag{3.1}
$$

The tuple records $(a,b,c,d)$.

## 4. The negative-root certificate

For a candidate with negative root $-t$, define

$$S_q(t)=\sum_{\substack{3\le p\le q\\p\ \mathrm{prime}}}t^{p-2}.$$

Divisibility at cutoff $q$ requires $S_q(t)=1$.  For fixed $t>0$, the
sequence $S_q(t)$ is strictly increasing as primes are added.  Thus each
candidate has at most one possible cutoff.

Exact rational bisection isolates $t$ between two rational numbers.  Since
$1-S_q(t)$ is strictly decreasing, endpoint evaluation determines its sign.
The eighteen cases split as follows:

- eight have crossed $1$ by $q=7$;
- three first cross by $q=11$;
- one first crosses by $q=13$;
- five remain below forever;
- one has exact equality at $q=7$.

For the five forever-below cases,

$$
(-5,6,5,1),\ (-4,5,4,1),\ (-3,4,3,1),
\ (0,9,0,-2),\ (1,4,3,2),
$$

the exact certificate is

$$
S_{13}(t)+\frac{t^{15}}{1-t^2}<1.\tag{4.1}
$$

The tail in (4.1) contains every possible future odd exponent, so it
dominates the actual prime tail.  After clearing the positive denominator,
the script verifies

$$
(1-t^2)(1-S_{13}(t))-t^{15}>0
$$

on a rational isolating interval.  The minimum certified rational margin is
approximately $0.0023189$; the exact fraction is printed by the script.

The sole equality is

$$
(a,b,c,d)=(0,1,0,1),
$$

for which

$$g(x)=x^5+x^3+x+1=F_7(x).$$

It remains only to see directly that this polynomial is irreducible.  It has
no rational root.  If it split as a monic quadratic times a monic cubic, its
constant terms would both be $s\in\{1,-1\}$.  Comparing coefficients in

$$
(x^2+ux+s)(x^3-ux^2+wx+s)
$$

gives

$$w=1-s+u^2,\qquad s(u+w)=1,$$

and hence

$$u^2+u+1-2s=0,$$

which has no integral solution for either $s=1$ or $s=-1$.  This proves the
theorem.

## 5. Prior-art boundary

The surrounding Newman-polynomial literature supplies general root geometry
and decision algorithms, but no directly applicable quintic classification
for this prime-prefix language was found:

- A. M. Odlyzko and B. Poonen, *Zeros of polynomials with 0,1
  coefficients*, Enseign. Math. **39** (1993), 317--348;
- K. G. Hare and M. J. Mossinghoff, *Negative Pisot and Salem numbers as
  roots of Newman polynomials*, Rocky Mountain J. Math. **44** (2014),
  113--138, <https://doi.org/10.1216/RMJ-2014-44-1-113>;
- P. Drungilas, J. Jankauskas, and G. \v{S}iurys, *On Newman and Littlewood
  multiples of Borwein polynomials*, Math. Comp. **87** (2018), 1523--1541,
  <https://doi.org/10.1090/mcom/3258>.
- M. J. Mossinghoff, *Polynomials with restricted coefficients and
  prescribed noncyclotomic factors*, LMS J. Comput. Math. **6** (2003),
  314--325, <https://doi.org/10.1112/S1461157000000474>;
- A. Schinzel, *Polynomials with Special Regard to Reducibility*, Cambridge
  University Press, 2000, and M. Filaseta--A. Schinzel, *On testing the
  divisibility of lacunary polynomials by cyclotomic polynomials*, Math.
  Comp. **73** (2004), 957--965;
- S. Idris and C. Sac-\'Ep\'ee, *Algorithmic aspects of Newman polynomials
  and their divisors*, <https://arxiv.org/abs/2601.11486> (2026).

Those works supply root geometry, lacunary/cyclotomic theory, and general
reachable-state or finite-remainder algorithms.  None of the located results
classifies arbitrary quartic or quintic factors in the growing prime-prefix
language, and the certificate here is not an implementation of their
automata.  The general even--odd resultant identity is elementary and may be
folklore.  The literature-search-qualified novelty candidate is its
prime-prefix specialization together with the exact complete quartic and
quintic tail certificates: apparently the first factor classification
through degree five for this family, pending expert review.
