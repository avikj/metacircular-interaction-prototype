# Reciprocal octic factors of the prime-prefix polynomials

Let

$$
F_X(x)=\sum_{p\le X}x^{p-2}
=1+x+x^3+x^5+x^9+\cdots .
$$

This note gives an exact computer-assisted proof that no irreducible
reciprocal octic divides any $F_X$.  It closes only the reciprocal half of
the degree-eight layer; nonreciprocal octic factors remain open.  The exact
certificate is `code/exp34_reciprocal_octic.py`.

## 1. A factored unit equation

Write a monic reciprocal octic of constant one as

$$
g(x)=x^8+ax^7+bx^6+cx^5+dx^4+cx^3+bx^2+ax+1.
$$

Its even and odd parts are

$$
E(y)=y^4+by^3+dy^2+by+1,
$$

$$
O(y)=ay^3+cy^2+cy+a
=(y+1)\bigl(ay^2+(c-a)y+a\bigr).
$$

The parity-resultant theorem gives $\operatorname{Res}(E,O)=\pm1$.
The linear factor of $O$ contributes

$$
E(-1)=d-2b+2.
$$

For a root $y$ of the reciprocal quadratic in $O$, put
$T=y+y^{-1}=(a-c)/a$.  Since

$$
y^{-2}E(y)=T^2+bT+d-2,
$$

the other resultant factor is a perfect square.  Polynomial continuation
covers $a=0$ and gives the exact identity

$$
\boxed{
\operatorname{Res}(E,O)
=(d-2b+2)
\left((a-c)^2+ab(a-c)+a^2(d-2)\right)^2.
}
\tag{1.1}
$$

Therefore

$$
\boxed{d-2b+2=\pm1,}
\tag{1.2}
$$

$$
\boxed{(a-c)^2+ab(a-c)+a^2(d-2)=\pm1.}
\tag{1.3}
$$

This perfect-square collapse is the main reason the reciprocal octic case
is much smaller than a general octic norm-one search.

## 2. Exact root geometry and finite enumeration

Put $T=x+x^{-1}$.  Then

$$
x^{-4}g(x)=H(T),
$$

$$
H(T)=T^4+aT^3+(b-4)T^2+(c-3a)T+(d-2b+2).
\tag{2.1}
$$

Every root of an odd-support Newman polynomial lies outside
$|x|=\varphi^{-1}$, where $\varphi=(1+\sqrt5)/2$.  Reciprocity is essential
here: if $x$ is a root of $g$, so is $x^{-1}$, and hence every root of $g$
satisfies

$$
\varphi^{-1}<|x|<\varphi.
\tag{2.2}
$$

No such upper golden bound is asserted for a nonreciprocal octic.

The Joukowski image of the two boundary circles is the ellipse

$$
\frac{(\Re T)^2}{5}+(\Im T)^2=1.
$$

In particular $|T|<\sqrt5$.  Vieta's formulas for the four roots of $H$
give

$$
|a|\le8,
\qquad
-25\le b\le33,
\qquad
|c-3a|\le44.
\tag{2.3}
$$

If $u=a-c$, then $|u|\le60$.  Equations (1.2)--(1.3) and (2.3) therefore
give a finite enumeration.  The exact reductions are

$$
928\ \longrightarrow\ 424\ \longrightarrow\ 58\ \longrightarrow\ 38,
\tag{2.4}
$$

where the stages are:

1. the two unit equations;
2. exact Sturm exclusion of candidates with real roots;
3. the conservative rational annulus
   $617/1000<|x|<81/50$, checked by an exact Cayley transform and Routh
   tables;
4. exact irreducibility/reducibility certificates.

The factor search is finite because every proper factor may be chosen of
degree at most four and has constant term $\pm1$.  Bound (2.2), applied
also to inverse roots, bounds its remaining coefficients by

$$
\begin{array}{c|c}
\text{degree}&\text{coefficient bounds}\\ \hline
2&|A|\le3,\\
3&|A|,|B|\le4,\\
4&|A|,|C|\le6,\ |B|\le15.
\end{array}
$$

The script records and exactly divides by a proper factor for each of the
$20$ reducible candidates.  For each of the $36$ noncyclotomic irreducible
candidates, Rabin's finite-field criterion certifies that the reduction is
irreducible modulo one of $2,3,7$.  The two remaining candidates are the
known irreducible cyclotomic polynomials below.  Thus the last step of
(2.4) does not depend on floating-point factorization or a probabilistic
irreducibility routine.

The two cyclotomic candidates among the $38$ are

$$
(a,b,c,d)=(-1,0,1,-1)\longleftrightarrow\Phi_{15},
$$

$$
(a,b,c,d)=(1,0,-1,-1)\longleftrightarrow\Phi_{30}.
$$

Both are removed by the global cyclotomic-factor theorem.

## 3. Exact infinite-tail certificate

For each of the remaining $36$ candidates, exact Cayley--Routh bisection
gives rational upper bounds

$$
u_1\le u_2\le u_3\le u_4
$$

for the four conjugate-pair moduli, with $u_1<1$.  Let

$$
B_q(u)=\sum_{p\le q}u^{p-2},
\qquad
R_q=|\operatorname{Res}(g,F_q)|.
$$

All resultants at tested earlier prefixes are nonzero.  Bounding the other
three conjugate pairs in the resultant product yields

$$
|F_q(\alpha)|^2
\ge
\frac{R_q}{B_q(u_2)^2B_q(u_3)^2B_q(u_4)^2}
\tag{3.1}
$$

at an inner root $|\alpha|\le u_1$.  If $p^+$ is the next prime after
$q$, every later added exponent is odd and at least $p^+-2$, so

$$
|F_X(\alpha)-F_q(\alpha)|
\le
\frac{u_1^{p^+-2}}{1-u_1^2}.
\tag{3.2}
$$

Consequently the exact positive inequality

$$
R_q(1-u_1^2)^2
>
u_1^{2(p^+-2)}
B_q(u_2)^2B_q(u_3)^2B_q(u_4)^2
\tag{3.3}
$$

excludes divisibility at $q$ and every later prefix.

The $36$ certificates close at the following cutoffs:

$$
\begin{array}{c|rrrrrrrr}
q&11&13&17&19&23&29&31&37\\ \hline
\text{candidates}&22&2&3&0&3&4&0&2.
\end{array}
$$

The smallest exact margin occurs for $(a,b,c,d)=(0,1,-1,-1)$ at
$q=11$, where $R_{11}=4208$; its decimal rendering is
$55.165019844\ldots>0$.

> **Theorem.** No irreducible reciprocal octic polynomial divides any
> prime-prefix polynomial $F_X$.

## 4. The first residual prefix is irreducible

The degree-seven classification and the even-degree obstructions reduce a
proper factorization of the degree-$17$ polynomial $F_{19}$ to the single
degree pattern $8+9$.  Independently of the reciprocal-octic theorem, the
certificate applies Rabin's exact finite-field criterion and verifies

$$
\gcd(F_{19},x^{71}-x)=1,
\qquad
x^{71^{17}}\equiv x\pmod{F_{19},71}.
$$

Since $17$ is prime, these are precisely the required Rabin conditions.
Thus $F_{19}$ is irreducible modulo $71$, and consequently irreducible over
$\mathbb Q$.

## 5. Prior-art boundary

The Joukowski reduction and Routh/Schur root-counting machinery are
classical, and the broad literature on reciprocal and Newman polynomials
contains many related factorization and root-location results.  No source
located in the present search states this prime-prefix reciprocal-octic
classification.  The safe claim is therefore an exact low-degree
specialization for this family, apparently new pending expert review; the
general tools and the bare resultant manipulations are not novelty claims.
