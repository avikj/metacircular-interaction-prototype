# Reciprocal parity resultants are evaluation times a square

This note isolates the all-degree structure behind the reciprocal sextic
and octic unit equations. It is an exact algebraic identity. Its status
relative to the classical literature on reciprocal-polynomial resultants
has not yet been determined, so no novelty claim is made.

Let $g\in\mathbb Z[x]$ be monic and reciprocal of even degree, with
constant term one, and split it into even and odd powers:

$$
g(x)=E(x^2)+xO(x^2).
$$

If $\deg g=2n$, then $E$ is reciprocal of nominal degree $n$, while $O$
is reciprocal of nominal degree $n-1$. Put

$$
T=y+y^{-1}.
$$

The standard Joukowski compression says that a reciprocal polynomial of
degree $2m$ is uniquely $y^mA(T)$, while one of degree $2m+1$ is uniquely
$y^m(y+1)A(T)$.

## The factorization theorem

> **Theorem.** If $\deg g=4k$, write uniquely
> $$
> E(y)=y^kA(T),\qquad
> O(y)=y^{k-1}(y+1)B(T),
> $$
> where $A$ is monic of degree $k$ and $\deg B\le k-1$. Then
> $$
> \boxed{
> \operatorname{Res}_y(E,O)
> =E(-1)\operatorname{Res}_T(A,B)^2.
> }
> \tag{1.1}
> $$
>
> If $\deg g=4k+2$, write uniquely
> $$
> E(y)=y^k(y+1)A(T),\qquad
> O(y)=y^kB(T),
> $$
> where $A$ is monic of degree $k$ and $\deg B\le k$. Then
> $$
> \boxed{
> \operatorname{Res}_y(E,O)
> =(-1)^kB(-2)\operatorname{Res}_T(A,B)^2.
> }
> \tag{1.2}
> $$

Degree drops in $B$, including a vanishing outer odd coefficient, are
included in these identities.

### Proof

First suppose the displayed degrees are full and the roots are distinct;
this is a Zariski-dense set of coefficient choices.

For degree $4k$, the roots of $O$ consist of the distinguished root
$y=-1$ and reciprocal pairs $\{y,y^{-1}\}$ indexed by the roots
$T=y+y^{-1}$ of $B$. On such a pair,

$$
E(y)E(y^{-1})
=y^kA(T)y^{-k}A(T)=A(T)^2.
$$

If $\beta$ is the leading coefficient of $B$, it is also the leading
coefficient of $O$. The root-product formula for the resultant gives

$$
\operatorname{Res}(E,O)
=\beta^{2k}E(-1)
\prod_{B(T)=0}A(T)^2.
$$

Because $A$ is monic and $k(k-1)$ is even,

$$
\operatorname{Res}(A,B)
=\beta^k\prod_{B(T)=0}A(T).
$$

This proves (1.1).

For degree $4k+2$, the roots of $E$ consist of $y=-1$ and reciprocal
pairs indexed by the roots of $A$. Here

$$
O(-1)=(-1)^kB(-2),
$$

and on every reciprocal pair

$$
O(y)O(y^{-1})=B(T)^2.
$$

Since $E$ and $A$ are monic,

$$
\operatorname{Res}(E,O)
=(-1)^kB(-2)
\prod_{A(T)=0}B(T)^2
=(-1)^kB(-2)\operatorname{Res}(A,B)^2,
$$

which is (1.2). Both sides of each identity are polynomial functions of
the original coefficients. Polynomial continuation therefore removes
the temporary full-degree and distinct-root assumptions and proves the
formulas across all degree drops. ∎

## The unit splitting for odd-support polynomials

Suppose now that $g$ divides an integral polynomial $P$ satisfying

$$
P(x)+P(-x)=2.
$$

Resultant multiplicativity gives the standard parity-unit condition

$$
\operatorname{Res}(E,O)=\pm1.
$$

The theorem splits this single large norm equation into two independent
integer units. In degree $4k$,

$$
\boxed{E(-1)=\pm1,\qquad \operatorname{Res}(A,B)=\pm1.}
\tag{2.1}
$$

In degree $4k+2$,

$$
\boxed{B(-2)=\pm1,\qquad \operatorname{Res}(A,B)=\pm1.}
\tag{2.2}
$$

The distinguished unit has a direct mod-$4$ meaning:

$$
\boxed{
g(i)\in\{1,-1,i,-i\}.
}
\tag{2.3}
$$

Indeed, in degree $4k$, $O(-1)=0$ and

$$
g(i)=E(-1)=\pm1.
$$

In degree $4k+2$, $E(-1)=0$ and

$$
g(i)=iO(-1)=i(-1)^kB(-2)=\pm i.
$$

Thus every reciprocal divisor of an odd-support polynomial is forced to
take a Gaussian-unit value at the fourth root of unity. The remaining
condition $\operatorname{Res}(A,B)=\pm1$ is a lower-dimensional
Joukowski norm equation.

## Low-degree checks

For a reciprocal sextic

$$
g=x^6+ax^5+bx^4+cx^3+bx^2+ax+1,
$$

(1.2) gives

$$
\operatorname{Res}(E,O)
=(2a-c)\bigl(c-a(b-1)\bigr)^2.
$$

For a reciprocal octic

$$
g=x^8+ax^7+bx^6+cx^5+dx^4+cx^3+bx^2+ax+1,
$$

(1.1) gives

$$
\operatorname{Res}(E,O)
=(d-2b+2)
\left((a-c)^2+ab(a-c)+a^2(d-2)\right)^2.
$$

The exact regression script code/exp35_reciprocal_resultant.py checks the
all-degree identities on deterministic integer examples in degrees
$4,6,8,10,12,14$, including explicit outer-coefficient degree drops.
