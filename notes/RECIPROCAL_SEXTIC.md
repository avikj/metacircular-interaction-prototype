# Reciprocal sextic factors of the prime-prefix polynomials

Let

$$
F_X(x)=\sum_{p\le X}x^{p-2}
=1+x+x^3+x^5+x^9+\cdots .
$$

This note gives an exact computer-assisted proof that no irreducible
reciprocal sextic divides any $F_X$.  It uses the parity unit resultant,
two residue-class obstructions, and a rational tail certificate.  The
complete certificate is `code/exp32_reciprocal_sextic.py`.

## 1. The coefficient unit equation

Write a monic reciprocal sextic of constant one as

$$
g(x)=x^6+ax^5+bx^4+cx^3+bx^2+ax+1.
$$

Its even and odd parts are

$$
E(y)=y^3+by^2+by+1
=(y+1)(y^2+(b-1)y+1),
$$

$$
O(y)=ay^2+cy+a.
$$

The parity-resultant theorem gives $\operatorname{Res}(E,O)=\pm1$.
Multiplicativity and the quadratic resultant formula give

$$
\operatorname{Res}(E,O)
=(2a-c)\bigl(c-a(b-1)\bigr)^2.
$$

Consequently

$$
\boxed{2a-c=\pm1,\qquad c-a(b-1)=\pm1.}
\tag{1.1}
$$

In particular,

$$
a(3-b)\in\{-2,0,2\}.
\tag{1.2}
$$

Thus either $a=0$, or $b=3$, or $a\in\{\pm1,\pm2\}$.  Together with
the root bounds below, this already makes the reciprocal search very small.

## 2. Exact root geometry

Put $T=x+x^{-1}$.  Then

$$
x^{-3}g(x)=f(T),
\qquad
f(T)=T^3+aT^2+(b-3)T+c-2a.
\tag{2.1}
$$

A real $x$ gives $T\in(-\infty,-2]\cup[2,\infty)$.  Since $F_X$ has
only one real root and an even irreducible factor has an even number of
real roots, a sextic factor has no real roots.  Hence every real root of
$f$ must lie strictly in $(-2,2)$.  This is checked exactly by Sturm chains.

The Joukowski image of the circle $|x|=R>1$ is the ellipse

$$
\frac{(\Re T)^2}{(R+R^{-1})^2}
+\frac{(\Im T)^2}{(R-R^{-1})^2}=1.
\tag{2.2}
$$

For $R=\varphi$, the squared semiaxes are $5$ and $1$.  Thus the golden
annulus condition is an exact rational ellipse test.  If $f$ has one real
root $s$ and a conjugate pair $u\pm iv$, Vieta gives

$$
u=-\frac{a+s}{2},
\qquad
u^2+v^2=\frac{2a-c}{s}.
\tag{2.3}
$$

The script isolates $s$ by rational bisection and evaluates (2.2) by
rational interval arithmetic.  There is no floating-point root decision.

Writing the six roots as three conjugate pairs with radii $r_1,r_2,r_3$,
the golden annulus and constant term give

$$
\varphi^{-1}<r_i<\varphi,
\qquad r_1r_2r_3=1.
$$

Convexity in the logarithms gives

$$
\sum r_i<2\varphi,\qquad
\sum r_i^2<4,\qquad
\sum_{i<j}r_ir_j=\sum_i r_i^{-1}<2\varphi.
$$

The resulting Vieta bounds include

$$
|a|\le6,\qquad |b|\le16,\qquad |c|\le22.
\tag{2.4}
$$

For the central coefficient, the useful identity is

$$
\sum_i r_i(r_j^2+r_k^2)
=\sum_{i\ne j}\frac{r_i}{r_j}<1+4\varphi;
$$

hence $|c|<8+2(1+4\varphi)<23$.

An exact factor search is complete in this annulus.  A quadratic factor
has trace of modulus less than $2\varphi<4$.  A cubic factor has constant
$\pm1$, and both its roots and inverse roots lie in the annulus, so both
nonconstant elementary symmetric coefficients have modulus less than
$3\varphi<5$.

Equations (1.1), the Sturm and ellipse tests, and this exact irreducibility
test leave precisely twelve triples:

$$
\begin{aligned}
&(-2,4,-5),\ (-1,1,-1),\ (-1,3,-3),\ (-1,3,-1),\\
&(0,0,-1),\ (0,0,1),\ (0,2,-1),\ (0,2,1),\\
&(1,1,1),\ (1,3,1),\ (1,3,3),\ (2,4,5).
\end{aligned}
\tag{2.5}
$$

## 3. The residue-class obstructions

Decompose exponents modulo $3$, writing $y=x^3$.  The residue-$1$
component of $F_X$ is exactly $x$.  For the reciprocal sextic, the three
components are

$$
1+cy+y^2,\qquad a+by,\qquad b+ay.
$$

The quotient identity therefore makes these three polynomials generate
the unit ideal in $\mathbb Z[y]$.  Their pairwise resultants imply

$$
\boxed{\gcd(a^2+b^2-abc,b^2-a^2)=1.}
\tag{3.1}
$$

Similarly, modulo $5$ the residue-$3$ component of $F_X$ is exactly
$x^3$.  The corresponding unit-ideal condition gives

$$
\boxed{\gcd(b,c,a^2-1)=1.}
\tag{3.2}
$$

These conditions remove eight triples from (2.5).  The four survivors are

$$
(-1,1,-1),\quad(-1,3,-1),\quad(1,1,1),\quad(1,3,1).
\tag{3.3}
$$

The first and third are respectively

$$
x^6-x^5+x^4-x^3+x^2-x+1=\Phi_{14}(x),
$$

$$
x^6+x^5+x^4+x^3+x^2+x+1=\Phi_7(x),
$$

and are excluded by the cyclotomic-factor theorem for $F_X$.

## 4. Exact infinite-tail certificate

It remains to exclude

$$
g_-(x)=x^6-x^5+3x^4-x^3+3x^2-x+1,
$$

$$
g_+(x)=x^6+x^5+3x^4+x^3+3x^2+x+1.
$$

For both, the roots are conjugate pairs of moduli $r,1,r^{-1}$.  Applying
the rational ellipse test (2.2) at $R=10/7$ and $R=3/2$ proves

$$
\frac{10}{7}<r^{-1}<\frac32,
\qquad r<\frac7{10}.
\tag{4.1}
$$

Let

$$
B(s)=1+s+s^3+s^5+s^9.
$$

The exact resultants with $F_{11}$ are

$$
|\operatorname{Res}(g_-,F_{11})|=2615,
\qquad
|\operatorname{Res}(g_+,F_{11})|=2381.
\tag{4.2}
$$

If $\alpha$ is an inner root of modulus $r$, the resultant product and
(4.1) give

$$
|F_{11}(\alpha)|^2
\ge
\frac{R}{B(1)^2B(3/2)^2}.
\tag{4.3}
$$

Every term added after $F_{11}$ has odd exponent at least $11$, so

$$
|F_X(\alpha)-F_{11}(\alpha)|
\le\frac{r^{11}}{1-r^2}
<\frac{(7/10)^{11}}{1-(7/10)^2}.
\tag{4.4}
$$

After squaring, (4.3) is strictly larger than (4.4) precisely when

$$
R(1-u^2)^2
>u^{22}B(1)^2B(v)^2,
\qquad u=\frac7{10},\quad v=\frac32.
\tag{4.5}
$$

The exact margins for $R=2615$ and $R=2381$ are respectively

$$
\frac{68558035849109015465200173191}
{104857600000000000000000000}>0,
$$

$$
\frac{62176045797269015465200173191}
{104857600000000000000000000}>0.
$$

Thus neither remaining sextic can divide $F_{11}$ or any later prefix.
A sextic cannot divide $F_7$, whose degree is five.

> **Theorem.** No irreducible reciprocal sextic polynomial divides any
> prime-prefix polynomial $F_X$.
