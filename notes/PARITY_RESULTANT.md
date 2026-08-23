# Parity resultants: a finite quartic reduction

> *Pointer (genius-12, 2026-08-14, no other edit made):*
> `notes/REFLECTION_NORM.md` shows that $H$ of (5.2) is multiplicative
> (Brahmagupta composition), that $g\mapsto H_g$ is a degree-preserving
> bijection on irreducible factors, and that (5.2) can be restated with the
> candidate eliminated from the right-hand side: $g\mid F_X\iff H_g\mid N_X$
> with $N_X(y)=1-yA_X(y)^2$ depending on the cutoff alone. Corollary 1c plus
> a root bound then gives uniform finiteness in every odd degree.
> Equation (2.3) is machine-checked in
> `formal/cubical/ParityNormEliminant.agda` (`syl-quartic-closed`,
> `res-quartic-root`).

Every prime-prefix polynomial after the prime $3$ has constant even part:

$$
F_X(x)+F_X(-x)=2.
\tag{1.1}
$$

This elementary identity imposes an unexpectedly rigid arithmetic condition
on every factor.

> **Theorem 1 (parity resultant).** Let $P\in\mathbb Z[x]$ satisfy
> $P(x)+P(-x)=2$, and let $g\in\mathbb Z[x]$ be a monic divisor of $P$ of
> degree $d$. Then
> $$
> 0\ne\operatorname{Res}(g(x),g(-x))\mid 2^d.
> \tag{1.2}
> $$
> In particular, $g$ and $g(-x)$ remain coprime modulo every odd prime.

*Proof.* Write $P=gq$.  If $\alpha_1,\ldots,\alpha_d$ are the roots of $g$,
then $P(\alpha_i)=0$ and (1.1) gives $P(-\alpha_i)=2$.  Since $g$ is monic,

$$
\operatorname{Res}(g(x),P(-x))
=\prod_{i=1}^dP(-\alpha_i)=2^d.
$$

But $P(-x)=g(-x)q(-x)$, so multiplicativity of the resultant gives

$$
2^d=\operatorname{Res}(g,g(-x))\operatorname{Res}(g,q(-x)).
$$

Both factors are integers.  The first cannot vanish because the left side
does not. $\square$

An even nonconstant polynomial can therefore never divide $P$: it would be
a common divisor of $P(x)$ and $P(-x)$ and hence divide $2$.

The divisibility has a uniform Bézout form in every degree.

> **Theorem 1b (even--odd unit resultant).** Let $g$ be as in Theorem 1.
> Then $g(0)=1$.  Write
> $$
> g(x)=E(x^2)+xO(x^2),\qquad E,O\in\mathbb Z[y].
> $$
> Then
> $$
> \boxed{
> \operatorname{Res}_x(g(x),g(-x))
> =2^d\operatorname{Res}_y(E,O)^2,
> \qquad
> \operatorname{Res}_y(E,O)=\pm1.
> }
> \tag{1.3}
> $$

*Proof.* Every real root of $P$ is negative.  The real roots of $g$ have
the same parity as its degree, while its nonreal roots occur in conjugate
pairs.  Its root product therefore has sign $(-1)^d$, so its
constant term, which is $\pm1$, is $+1$.

Suppose first that $d=2k$.  Then $E$ is monic of degree $k$ and $E(0)=1$.
At a root $\alpha$ of $g$, $g(-\alpha)=2E(\alpha^2)$, whence

$$
\operatorname{Res}_x(g,g(-x))
=2^d\operatorname{Res}_x(g,E(x^2)).
$$

If $\beta$ runs through the roots of $E$ and $s^2=\beta$, then

$$g(s)g(-s)=E(\beta)^2-\beta O(\beta)^2=-\beta O(\beta)^2.$$

Multiplying over $\beta$ gives
$\operatorname{Res}_x(g,E(x^2))=\operatorname{Res}_y(E,O)^2$, because
$E$ is monic with constant term $1$.

If $d=2k+1$, then $O$ is monic of degree $k$.  At a root $\alpha$,
$g(-\alpha)=-2\alpha O(\alpha^2)$, and
$\prod_{g(\alpha)=0}\alpha=-1$.  Hence

$$
\operatorname{Res}_x(g,g(-x))
=2^d\operatorname{Res}_x(g,O(x^2)).
$$

For $O(\beta)=0$, the paired product is now
$g(s)g(-s)=E(\beta)^2$, so the last resultant is again
$\operatorname{Res}_y(E,O)^2$.  Equation (1.3) follows in both parities.
Theorem 1 says its left side divides $2^d$ and is nonzero; since the other
factor is an integer square, $\operatorname{Res}_y(E,O)=\pm1$. $\square$

### Theorem 1b is the $g(0)=1$ case of an unrestricted identity

> **Inserted in place by SEED-110 (2026-08-14), executing the standing
> `DEMONSTRATE` item `notes/SEED67_SAME_CLASS_OR_NOT.md` §7.3 ("restate Theorem 1b
> as a corollary of Theorem C, so the note's displayed identity is true for every
> monic input rather than only on its hypothesis locus"). No new mathematics; the
> proof is SEED-67 §2.1, which is not reproduced here.**
>
> **Theorem C (SEED-67).** Let $g$ be **any** monic polynomial of degree $d$ over
> a field, $g(x)=E(x^2)+xO(x^2)$, with $\operatorname{Res}_y(E,O)$ taken at the
> actual degrees of $E$ and $O$. Then
> $$\operatorname{Res}_x\bigl(g(x),g(-x)\bigr)=2^{d}\,g(0)\,\operatorname{Res}_y(E,O)^{2}.$$
>
> Theorem 1b is the specialisation at $g(0)=1$, which Theorem 1 forces for the
> divisors of $P$; equation (1.3) is then term-for-term Theorem C. **Why this
> matters for a reader of this note:** as displayed above, (1.3) is *false* for a
> general monic $g$, and a reader testing it will get an apparent refutation. Two
> monic witnesses (SEED-67 §2.2): $g=x^2-3x+2$ has lhs $72$ and (1.3)'s rhs $36$,
> ratio $g(0)=2$; $g=x^3-x-1$ has lhs $-8$ and rhs $8$, ratio $g(0)=-1$. Neither
> is non-monic and neither involves a degree drop, so the discrepancy earlier
> diagnosed in `notes/TENSIONS.md` §2 as gauge-fixing convention-sensitivity is a
> single evaluation of $g$ at $0$ — struck at its site by SEED-67. For non-monic
> $g$ with $\mathrm{lc}(g)=c$ no $c$-free form exists: $g\mapsto\lambda g$
> multiplies the left side by $\lambda^{2d}$.

Thus every factor has unimodularly coprime even and odd parts.  This is the
degree-independent arithmetic content of the parity identity; the quartic
equation below is its first nontrivial coefficient-level specialization.

There is also a useful global consequence that does not require a
coefficient search.

> **Corollary 1c (unique odd carrier).** Every finite polynomial
> $$
> P(x)=1+\sum_{j\text{ odd}}\epsilon_jx^j,
> \qquad \epsilon_j\in\{0,1\},
> $$
> of odd degree has exactly one odd-degree irreducible factor over
> $\mathbb Q$, and that factor occurs with multiplicity one.

*Proof.* The function $P(-t)=1-\sum_j\epsilon_jt^j$ is strictly decreasing
for $t>0$, so $P$ has exactly one real root and it is simple.  Since
$\deg P$ is odd, its factorization contains an odd-degree irreducible
factor.  Every such factor has a real root.  Two distinct odd-degree factors
would therefore supply two real roots of $P$; equivalently, if they shared
the sole root they would share its minimal polynomial.  A repeated odd
factor would make that root multiple.  Hence precisely one odd factor occurs,
with multiplicity one. $\square$

The cubic and quintic theorems therefore classify successive possible
degrees of one distinguished algebraic object: the minimal polynomial of
the unique negative root.  All other irreducible factors have even degree.

## 2. Exact quartic equation

Let an irreducible quartic factor be

$$g(x)=x^4+ax^3+bx^2+cx+1.$$

The constant term is necessarily $+1$.  Indeed, $P(y)>0$ for $y\ge0$, so
all real roots are negative; a real quartic has $0,2$, or $4$ real roots,
and hence positive root product.  Since the constant term divides $P(0)=1$,
it cannot be $-1$.

At a root $\alpha$ of $g$,

$$g(-\alpha)=-2\alpha(a\alpha^2+c).$$

Taking the product over all four roots gives

$$
\operatorname{Res}(g,g(-x))
=16\prod_{g(\alpha)=0}(a\alpha^2+c).
\tag{2.1}
$$

The remaining product is itself a resultant.  If $a\ne0$, evaluate $g$ at
the two roots $\pm s$ of $as^2+c=0$:

$$
g(s)=g(-s)=s^4+bs^2+1,
$$

and therefore

$$
\prod_{g(\alpha)=0}(a\alpha^2+c)
=(a^2-abc+c^2)^2.
$$

The same polynomial identity covers $a=0$.  Thus

$$
\boxed{
\operatorname{Res}(g,g(-x))
=16(a^2-abc+c^2)^2.
}
\tag{2.2}
$$

Combining (2.2) with Theorem 1 for $d=4$ yields the unit equation

$$
\boxed{a^2-abc+c^2=\pm1.}
\tag{2.3}
$$

## 3. Sharp finite candidate set

For $t>0$,

$$F_X(-t)=1-\sum_{3\le p\le X}t^{p-2}$$

is strictly decreasing from $1$ to $-\infty$.  Thus $F_X$ has exactly one
real root.  An irreducible quartic factor has an even number of real roots
and therefore has none.

Write its roots as

$$
re^{\pm i\theta},\qquad r^{-1}e^{\pm i\varphi},
\qquad 0<r\le1,
$$

using the constant term $1$.  At the inner root, odd support gives

$$
1
\le \sum_{\substack{j\ge1\\j\text{ odd}}}r^j
<\frac{r}{1-r^2}.
$$

Hence $r>\phi^{-1}$, where $\phi=(1+\sqrt5)/2$, and therefore
$r+r^{-1}<\sqrt5$.  Vieta now gives

$$
|a|,|c|<2\sqrt5,\qquad
b=r^2+r^{-2}+4\cos\theta\cos\varphi,
$$

so

$$
|a|,|c|\le4,\qquad -1\le b\le6.
\tag{3.1}
$$

Together with (2.3), these bounds leave exactly $62$ integer triples.  Exact
Sturm counts leave $46$ with no real roots.  They are automatically
irreducible: a no-real reducible monic quartic of constant $1$ would split
as two quadratics $x^2+ux+1$ with $u\in\{-1,0,1\}$, and none of those
products satisfies (2.3).

For a quartic $g$, define the cubic resolvent

$$
\mathcal R_g(T)
=T^3-bT^2+(ac-4)T+(4b-a^2-c^2).
\tag{3.2}
$$

Its three roots are the three pair-partition sums.  For the conjugate-pair
partition one root is $T=r^2+r^{-2}\ge2$.  The other two pairings have the
form $2\operatorname{Re}(zw)$ and $2\operatorname{Re}(z\overline w)$ for
unit-modulus $z,w$, so they lie in $[-2,2]$.  The sharp odd-support bound
$r>\phi^{-1}$ is equivalent to $T<3$.  Exact Sturm isolation in $(2,3)$
therefore selects the unique conjugate-pair root and leaves $26$ triples.
Two are

$$
(-1,1,-1)\leftrightarrow\Phi_{10},
\qquad
(1,1,1)\leftrightarrow\Phi_5,
$$

excluded by the global cyclotomic theorem.  The remaining $24$ are handled
in §6.

`code/exp29_quartic_resultant.py` reproduces the $62$-candidate count and a
bounded odd-support scan.  The proof certificate is
`code/exp30_quartic_certificate.py`.

## 4. The reciprocal quartic layer is empty

The prime-prefix support gives one more exact local constraint.  For
$t>0$,

$$F_X(-t)=1-\sum_{p\ge3,\ p\le X}t^{p-2}$$

is strictly decreasing from $1$ to $-\infty$.  Thus $F_X$ has exactly one
real root.  An irreducible quartic factor, whose number of real roots is
even, must have none.

> **Theorem 2.** No reciprocal quartic polynomial divides $F_X$.

*Proof.* A reciprocal quartic has $c=a$.  The unit equation (2.3) becomes

$$a^2(2-b)=\pm1,$$

so $a=\pm1$ and $b\in\{1,3\}$.  For $b=1$ the two polynomials are
$\Phi_5$ and $\Phi_{10}$, already excluded by the global cyclotomic
classification.

Suppose $b=3$.  Put $y=x^3$ and decompose

$$
g(x)=(1+ay)+x(a+y)+3x^2.
$$

Among the exponents $p-2$, only the exponent $1$ is congruent to $1$ modulo
$3$: every prime $p>3$ is $\pm1\pmod3$.  Hence the residue-$1$ component of
$F_X$ is exactly $x$.

Write a putative quotient as
$C_0(y)+xC_1(y)+x^2C_2(y)$.  Comparing the residue-$1$ component in
$F_X=gC$ gives

$$
(1+ay)C_1+(a+y)C_0+3yC_2=1.
\tag{4.1}
$$

Modulo $3$, if $a=1$ the left side is divisible by $1+y$; if $a=-1$ it is
divisible by $1-y$.  Neither nonconstant polynomial divides $1$ in
$\mathbb F_3[y]$, a contradiction. $\square$

Thus every remaining quartic candidate is nonreciprocal.  This is
particularly useful for phase rigidity: reciprocal factors are harmless
under reversal, while only nonreciprocal factors can participate in a
homometric split.

## 5. Structural form

Writing

$$
g(x)=E(x^2)+xO(x^2),
\qquad
E(y)=y^2+by+1,\qquad O(y)=ay+c,
$$

and a quotient as $q(x)=U(x^2)+xV(x^2)$, the constant-even-part condition
is exactly the Bézout identity

$$
E(y)U(y)+yO(y)V(y)=1.
\tag{5.1}
$$

Equation (2.3) is the statement that the resultant of $E$ and $yO$ is a
unit.  This is the useful conceptual residue: parity converts factorization
into a unit equation in the even/odd decomposition.

More precisely, put

$$H(y)=E(y)^2-yO(y)^2=g(x)g(-x).$$

For $P(x)=1+xA(x^2)$,

$$
g\mid P
\iff
H\mid EA-O.
\tag{5.2}
$$

Indeed, in the quotient by $g$ one has $xO=-E$; multiplying
$1+xA$ by $O$ gives $O-EA$.  The unit resultant makes $O$ invertible modulo
$H$, proving the converse.

## 6. Exact tail/resultant certificate

Let $\alpha,\overline\alpha$ be the inner roots of a surviving quartic,
$|\alpha|=r<1$, and let $\beta,\overline\beta$ be the outer roots of modulus
$r^{-1}$.  For $q\in\{7,11,13\}$, let $e_q$ be the exponent contributed by
the next prime:

$$e_7=9,\qquad e_{11}=11,\qquad e_{13}=15.$$

For every later cutoff $X>q$,

$$
|F_X(\alpha)-F_q(\alpha)|
\le\frac{r^{e_q}}{1-r^2}.
\tag{6.1}
$$

Put $R_q=|\operatorname{Res}(g,F_q)|$.  When $R_q\ne0$,

$$
R_q=|F_q(\alpha)|^2|F_q(\beta)|^2,
\qquad
|F_q(\beta)|
\le\sum_{p\le q}r^{-(p-2)}.
\tag{6.2}
$$

Writing

$$W_q(r)=\sum_{p\le q}r^{e_q-(p-2)},$$

(6.2) yields

$$
|F_q(\alpha)|
\ge \frac{\sqrt{R_q}\,r^{e_q}}{W_q(r)}.
\tag{6.3}
$$

If a later prefix vanished at $\alpha$, (6.1) would instead force
$|F_q(\alpha)|\le r^{e_q}/(1-r^2)$.  Thus it suffices that
$R_q(1-r^2)^2>W_q(r)^2$.  If a rational $u$ is certified to satisfy
$r<u<1$, then $1-r^2>1-u^2$ and $W_q(r)<W_q(u)$ because every exponent in
$W_q$ is positive.  Consequently the purely rational inequality

$$
R_q(1-u^2)^2
>
\left(\sum_{p\le q}u^{e_q-(p-2)}\right)^2
\tag{6.4}
$$

implies $|F_q(\alpha)|>r^{e_q}/(1-r^2)$ and rules out every later prefix.
The radius bound is itself exact: since $y+y^{-1}$ decreases on $(0,1)$,

$$
r<u
\iff
T>u^2+u^{-2},
$$

and the right side is checked by Sturm isolation of the resolvent root
$T\in(2,3)$.

The following table records a complete certificate for all $24$
noncyclotomic triples.  The displayed margin is the left side minus the
right side of (6.4); the script stores and checks it as an exact rational.

| $(a,b,c)$ | $q$ | $u$ | $R_q$ | margin |
|---|---:|---:|---:|---:|
| $(-2,2,-1)$ | 7 | .763 | 19 | 2.771334 |
| $(-2,3,-1)$ | 7 | .643 | 62 | 21.246726 |
| $(-1,-1,1)$ | 7 | .763 | 37 | 5.913823 |
| $(-1,2,-2)$ | 7 | .763 | 16 | 2.247586 |
| $(-1,2,0)$ | 7 | .714 | 16 | 3.586579 |
| $(-1,3,-2)$ | 7 | .643 | 82 | 28.127568 |
| $(-1,3,-1)$ | 7 | .650 | 73 | 24.252013 |
| $(0,1,1)$ | 7 | .802 | 8 | 0.041814 |
| $(0,2,-1)$ | 7 | .714 | 11 | 2.385079 |
| $(0,2,1)$ | 7 | .714 | 23 | 5.268679 |
| $(1,-1,-1)$ | 7 | .763 | 139 | 23.721263 |
| $(1,1,0)$ | 7 | .802 | 16 | 1.060241 |
| $(1,2,0)$ | 7 | .714 | 16 | 3.586579 |
| $(1,2,2)$ | 7 | .763 | 16 | 2.247586 |
| $(1,3,1)$ | 7 | .650 | 31 | 10.244751 |
| $(1,3,2)$ | 7 | .643 | 44 | 15.053969 |
| $(2,2,1)$ | 7 | .763 | 43 | 6.961320 |
| $(2,3,1)$ | 7 | .643 | 76 | 26.063315 |
| $(-1,1,0)$ | 11 | .802 | 47 | 4.347822 |
| $(0,0,-1)$ | 11 | .845 | 75 | 3.309852 |
| $(0,1,-1)$ | 11 | .802 | 107 | 11.986025 |
| $(-1,0,0)$ | 13 | .845 | 109 | 7.046726 |
| $(0,0,1)$ | 13 | .845 | 57 | 2.794077 |
| $(1,0,0)$ | 13 | .845 | 27 | 0.340626 |

All earlier prefix resultants are nonzero.  Thus the $q=7$ rows cover the
prefix at $7$ and every later prefix; the $q=11$ rows separately check $7$
and then cover $11$ onward; the $q=13$ rows separately check $7,11$ and then
cover $13$ onward.  Prefixes below $7$ have degree below $4$.

> **Theorem 3 (quartic exclusion; computer-assisted).** No irreducible
> quartic polynomial divides any prime-prefix polynomial $F_X$.

The entire finite certificate uses integer and rational arithmetic:
Sturm chains, Bareiss determinants of Sylvester matrices, and exact fraction
comparisons.  It runs in under a tenth of a second.  The minimum exact margin
is

$$
\frac{
159508095841042452857099974261116545823134461799
}{
3814697265625000000000000000000000000000000000000
}
>0.
$$

Together with the subsequent low-degree classifications through sextic in
`QUINTIC_OBSTRUCTION.md` and `SEXTIC_OBSTRUCTION.md`:

> **Corollary 4.** For every $X\ge13$, every irreducible factor of $F_X$ is
> non-cyclotomic and has degree at least $7$.
