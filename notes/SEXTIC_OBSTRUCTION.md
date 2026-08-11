# Exact obstruction to sextic factors

Let

$$
F_X(x)=\sum_{p\le X}x^{p-2}
      =1+x+x^3+\sum_{7\le p\le X}x^{p-2}.
$$

This note proves, with the exact certificate
`code/exp32_sextic_certificate.py`, that no $F_X$ has an irreducible factor
of degree six over $\mathbb Q$.

## 1. Structural reduction

Write a putative monic irreducible sextic factor as

$$
g(x)=x^6+a x^5+b x^4+c x^3+d x^2+e x+1.
$$

The constant is $+1$.  Indeed, $F_X$ has exactly one real zero: it is
positive on $[0,\infty)$, while $F_X(-t)$ decreases strictly from $1$ to
$-\infty$ for $t>0$.  An irreducible real sextic cannot contain that single
real zero, so its roots occur in three nonreal conjugate pairs.  Their
product, hence the constant coefficient, is positive.

Split parity as

$$
g(x)=E(x^2)+xO(x^2),\qquad
E(y)=y^3+b y^2+d y+1,\quad O(y)=a y^2+c y+e.
$$

Since $F_X(x)+F_X(-x)=2$, a divisor $g\mid F_X$ satisfies

$$
\operatorname{Res}_x(g(x),F_X(-x))=2^6.
$$

Also $g(-x)\mid F_X(-x)$, and

$$
\operatorname{Res}_x(g(x),g(-x))
 =2^6\operatorname{Res}_y(E,O)^2.
$$

Multiplicativity of the resultant therefore forces

$$
\boxed{\operatorname{Res}_y(E,O)=\pm1.}
$$

Explicitly, this resultant is

$$
\begin{aligned}
D={}&a^3-2a^2be-a^2cd+a^2d^2e+ab^2e^2+abc^2-abcde\\
&+3ace-2ade^2-bce^2-c^3+c^2de+e^3.
\end{aligned}
$$

## 2. A finite coefficient box

The odd support gives the lower root bound directly.  If
$|z|<\varphi^{-1}$, then

$$
\sum_{j\ge1,\ j\text{ odd}}|z|^j
\le \frac{|z|}{1-|z|^2}<1,
\qquad \varphi=\frac{1+\sqrt5}{2},
$$

so the constant term cannot be cancelled.  The standard leading-term
argument for a monic $0,1$ polynomial gives $|z|<2$.  Hence every root obeys

$$
\varphi^{-1}<|z|<2.
$$

Group the roots of $g$ into conjugate pairs of radii $r_1,r_2,r_3$.  Then
$r_1r_2r_3=1$.  An elementary boundary/equal-variable calculation on this
constrained box, and on its reciprocal box for the reversed coefficients,
gives

$$
s_1:=\sum r_i<\frac{3\varphi+2}{2},\qquad
s_2:=\sum_{i<j}r_ir_j=\sum_i\frac1{r_i}<3\varphi-\frac32.
$$

For completeness, after fixing one radius the product of the other two is
fixed, and their sum is a convex function of either one; hence a maximum is
at an endpoint.  Checking the endpoint and equal-variable cases gives, up
to permutation, $(\varphi^{-1},\varphi/2,2)$.  Now

$$
\sum r_i^2+4\sum_{i<j}r_ir_j=s_1^2+2s_2
<\frac{1+45\varphi}{4}<19,
$$

and

$$
8+2\sum_{i\ne j}r_i^2r_j
=2+2s_1s_2<8+\frac{21\varphi}{2}<25.
$$

For reciprocal radii, the corresponding quadratic expression is at most
$53/4+3\varphi<19$.
Bounding elementary symmetric functions pair by pair therefore gives

$$
|a|,|e|\le6,\qquad |b|,|d|\le18,\qquad |c|\le24.
$$

Thus $D=\pm1$ is a finite Diophantine search.  The exact counts are

$$
18506\ \xrightarrow{\text{no real roots}}\ 4894
\xrightarrow{617/1000<|z|<20001/10000}\ 392
\xrightarrow{\text{irreducible}}\ 362.
$$

The rational annulus is deliberately weaker than
$\varphi^{-1}<|z|<2$.  Its root counts are exact.  For rational $u>0$, set

$$
H_u(w)=(1+w)^6g\!\left(u\frac{1-w}{1+w}\right).
$$

The Cayley map satisfies $\Re w>0$ exactly when $|z|<u$, so the exact Routh
table for $H_u$ counts roots of $g$ in the disk.  No numerical root finder is
used.

The irreducibility test is complete.  A reducible monic sextic has a monic
integral factor of degree at most three and constant $\pm1$.  The strict
outer bound $2$ bounds a quadratic factor $x^2+ux+s$ by $|u|\le3$, and a
cubic factor $x^3+ux^2+vx+s$ by $|u|\le5$, $|v|\le11$.  The script tries
every possibility by exact division.

## 3. Resultant-tail certificate

For every surviving noncyclotomic $g$, exact disk counts produce rational
numbers

$$
r_1<u_1<1,\qquad r_2<u_2,\qquad r_3<u_3.
$$

Fix a prime cutoff $q$, let $e_q=p_{\rm next}-2$, and put

$$
B_q(u)=\sum_{p\le q}u^{p-2},\qquad
R_q=|\operatorname{Res}(g,F_q)|.
$$

If $g\mid F_X$ for some later $X$, evaluation at a root in the first
conjugate pair gives

$$
|F_q(\alpha_1)|
\le \frac{r_1^{e_q}}{1-r_1^2}
<\frac{u_1^{e_q}}{1-u_1^2}.
$$

For the other pairs, $|F_q(\alpha_i)|\le B_q(u_i)$.  Taking the norm over all
six conjugates yields the necessary inequality

$$
R_q(1-u_1^2)^2
\le u_1^{2e_q}B_q(u_2)^2B_q(u_3)^2.
$$

The certificate proves the strict reverse inequality, while also checking
that every earlier prime prefix has nonzero resultant.  The 358
noncyclotomic candidates close as follows:

| $q$ | 7 | 11 | 13 | 17 | 19 | 23 | 29 | 31 | 37 | 41 | 43 | 47 |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| certificates | 267 | 47 | 14 | 6 | 5 | 11 | 3 | 4 | 0 | 0 | 0 | 1 |

The minimum exact positive margin occurs for
$(a,b,c,d,e)=(0,2,-1,3,0)$ at $q=7$.  It is $N/D$, where

$$
\begin{aligned}
N={}&126093417908455432527833177369695353463806315218047803830800584130126114566863808230986547477042128790740054659086279701140410387633176483798872863303058441166006799499348612083107739466890815440257013078808281031073455185127881190871234087299587417214426898730816458403063184828878666038651519,\\
D={}&2094969989053530796808441405969663457418650909467561465269306475581525629698991715125292859088578660576567477841638445445899044189366651554130257657200640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.
\end{aligned}
$$

Numerically this is about $0.060188651182$, but the assertion uses the exact
fraction.

The four remaining candidates are $\Phi_7,\Phi_9,\Phi_{14},\Phi_{18}$.
They are excluded by the global cyclotomic classification for the
prime-prefix family (the finite-place parity/residue argument recorded in
the cyclotomic obstruction).  Hence

$$
\boxed{F_X\text{ has no irreducible sextic factor for any }X.}
$$

## 4. Prior-art boundary

The exact disk count is classical Routh--Hurwitz/Schur--Cohn machinery; see
Saux Picart, *The Schur--Cohn Algorithm Revisited* (1998), and
Brunie--Saux Picart, *A Fast Version of the Schur--Cohn Algorithm* (2000).
The surrounding restricted-coefficient literature includes
Odlyzko--Poonen, *Zeros of polynomials with 0,1 coefficients*,
*Enseign. Math.* 39 (1993), 317--348; and
Drungilas--Jankauskas--Siurys, *On Newman and Littlewood multiples of Borwein
polynomials*, *Math. Comp.* 87 (2018), 1523--1541.  Those works frame the
root geometry and fixed-divisor decision problems; none located in the
targeted search treats factors of this growing prime-prefix family.  The
parity-unit specialization and complete prime-prefix tail closure are the
literature-search-qualified novelty candidates.  The root-counting and
resultant machinery itself is classical, and any novelty claim remains
pending expert review.
