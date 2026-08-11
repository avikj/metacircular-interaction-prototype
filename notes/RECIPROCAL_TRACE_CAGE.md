# The reciprocal trace cage

This note records an exact, all-degree necessary-condition compiler for
reciprocal factors of prime-prefix polynomials.  Its purpose is computational:
it turns the root annulus, reciprocity, the constant-term unit, and the parity
resultant into a finite coefficient cage plus a lower-dimensional norm-unit
equation.  These conditions are not sufficient for divisibility, as the two
explicit counterexamples below show.

No novelty is claimed for the ingredients.  The trace substitution, Vieta
bounds, and square factorization of reciprocal resultants are classical.  The
useful object here is their exact assembly into reusable preprocessing.

## 1. The all-degree necessary theorem

For real $X\ge2$, put

$$
F_X(x)=\sum_{p\le X}x^{p-2}.
$$

Let $g\in\mathbb Z[x]$ be a monic reciprocal divisor of $F_X$ of degree
$2n>0$.  There is a unique monic $H\in\mathbb Z[T]$ such that

$$
g(x)=x^nH(x+x^{-1}),
\qquad
H(T)=T^n+c_1T^{n-1}+\cdots+c_n.
\tag{1.1}
$$

Write $R=\sqrt5$ and, for $1\le k<n$, define

$$
M_{n,k}
=\binom{n-1}{k}R^k
 +\binom{n-1}{k-1}R^{k-n},
\qquad
B_{n,k}=\lceil M_{n,k}\rceil-1.
\tag{1.2}
$$

Thus $B_{n,k}$ is the largest integer strictly below $M_{n,k}$, including
when $M_{n,k}$ itself is an integer.

> **Theorem 1 (reciprocal trace cage).**  Under the preceding hypotheses:
>
> 1. every root $\tau$ of $H$ satisfies $|\tau|<\sqrt5$;
> 2. $c_n=\pm1$;
> 3. for $1\le k<n$,
>    $$
>    |c_k|<M_{n,k},
>    \qquad\text{hence}\qquad
>    |c_k|\le B_{n,k};
>    \tag{1.3}
>    $$
> 4. after the even/odd split
>    $$
>    g(x)=E(x^2)+xO(x^2),
>    \tag{1.4}
>    $$
>    the Joukowski polynomials $A,B$ defined below satisfy
>    $$
>    \operatorname{Res}(A,B)=\pm1.
>    \tag{1.5}
>    $$
>
> If $g$ is irreducible over $\mathbb Q$, then $H$ is irreducible over
> $\mathbb Q$.  The converse is false.

Here is the precise meaning of the residual pair in part 4.  Put
$U=y+y^{-1}$.  If $n=2m$, write uniquely

$$
E(y)=y^mA(U),
\qquad
O(y)=y^{m-1}(y+1)B(U).
\tag{1.6}
$$

If $n=2m+1$, write uniquely

$$
E(y)=y^m(y+1)A(U),
\qquad
O(y)=y^mB(U).
\tag{1.7}
$$

Degree drops in $B$ are allowed.

### Proof

The integrality assertion in (1.1) is triangular.  A reciprocal Laurent
polynomial is an integral linear combination of $1$ and
$x^j+x^{-j}$, while

$$
x^0+x^{-0}=2,
\quad x+x^{-1}=T,
\quad
x^j+x^{-j}=T(x^{j-1}+x^{-(j-1)})-(x^{j-2}+x^{-(j-2)}).
$$

Therefore $x^{-n}g(x)$ is uniquely a monic integral polynomial in $T$.

Let $z$ be any root of $g$ (hence of $F_X$) and put $r=|z|$.  If $r<1$, the constant
term and odd support give

$$
1
\le \sum_{\substack{p\le X\\p>2}}r^{p-2}
<\sum_{j\ge0}r^{2j+1}
=\frac{r}{1-r^2}.
$$

Hence $r>\varphi^{-1}$, where $\varphi=(1+\sqrt5)/2$; this is automatic
when $r\ge1$.  Reciprocity says that $z^{-1}$ is also a root of $g$ and
therefore of $F_X$, so the same lower bound applied to $z^{-1}$ yields

$$
\varphi^{-1}<|z|<\varphi.
\tag{1.8}
$$

Each root of $H$ is $\tau=z+z^{-1}$ for one reciprocal root pair of $g$.
Thus

$$
|\tau|\le |z|+|z|^{-1}<\varphi+\varphi^{-1}=\sqrt5.
\tag{1.9}
$$

It remains to extract the two units.  Since $F_X$ has constant term one
and otherwise only odd powers, write $F_X(x)=1+xQ(x^2)$.  Split the
integral quotient $F_X/g$ as $C(x^2)+xD(x^2)$.  Comparing even parts gives

$$
E(y)C(y)+yO(y)D(y)=1.
\tag{1.10}
$$

Because $E$ is monic, $\mathbb Z[y]/(E)$ is finite free.  Moreover
$E(0)=g(0)=1$, so $y$ is a unit in this quotient.  Equation (1.10) says that
$yO$ is a unit; hence $O$ is a unit as well.  Its multiplication determinant
is therefore a unit, so

$$
\operatorname{Res}_y(E,O)=\pm1.
\tag{1.11}
$$

The reciprocal root-pair factorization of this resultant is

$$
\operatorname{Res}_y(E,O)
=E(-1)\operatorname{Res}_U(A,B)^2
\quad(n=2m),
\tag{1.12}
$$

and

$$
\operatorname{Res}_y(E,O)
=(-1)^mB(-2)\operatorname{Res}_U(A,B)^2
\quad(n=2m+1).
\tag{1.13}
$$

For completeness, the square comes from pairing every root $y$ with
$y^{-1}$: the two evaluations of the reciprocal member multiply to the
square of its trace-polynomial evaluation.  The unpaired root $y=-1$
supplies the displayed distinguished factor.  Polynomial continuation
covers repeated roots and degree drops.  Since all factors in
(1.12)--(1.13) are integers, (1.11) forces both the distinguished factor
and $\operatorname{Res}(A,B)$ to be units.  Moreover

$$
g(i)=i^nH(0)=i^nc_n.
$$

The distinguished unit is exactly $g(i)$ in the even-$n$ case and $g(i)/i$
in the odd-$n$ case, up to the displayed power of $-1$.  Hence $c_n=\pm1$
and (1.5) follows.

Let $\tau_1,\ldots,\tau_n$ be the roots of $H$.  The constant-term unit
gives $\prod_i|\tau_i|=1$.  The unit-product Vieta inequality says that if
$r_i<R$ and $\prod_i r_i=1$, then

$$
e_k(r_1,\ldots,r_n)
<\binom{n-1}{k}R^k
 +\binom{n-1}{k-1}R^{k-n}.
\tag{1.14}
$$

One quick proof is to put $u_i=\log r_i$.  The feasible polytope has
$\sum u_i=0$ and $u_i\le\log R$; a convex symmetric exponential sum is
maximized at a permutation of
$(\log R,\ldots,\log R,-(n-1)\log R)$.  Strict root bounds make the
boundary maximum strict.  Applying (1.14) to $r_i=|\tau_i|$ and using
Vieta proves (1.3).

Finally, if $H=H_1H_2$ is a nontrivial factorization, then multiplying the
two trace substitutions by the appropriate powers of $x$ factors $g$.
Thus irreducibility of $g$ implies that of $H$.  The first counterexample
in Section 3 disproves the converse. $\square$

## 2. Degree twelve exactly

For a reciprocal degree-twelve candidate, write

$$
g(x)=x^6H(x+x^{-1}),
\qquad
H(T)=T^6+c_1T^5+c_2T^4+c_3T^3+c_4T^2+c_5T+c_6.
$$

Substituting $n=6$ into (1.2) gives the exact integral cage

$$
\boxed{
(|c_1|,|c_2|,|c_3|,|c_4|,|c_5|)
\le(11,50,112,126,58),
\qquad c_6=\pm1.
}
\tag{2.1}
$$

For example, the fourth real bound is the strict inequality
$|c_4|<125+2=127$, which is why its integral endpoint is $126$.
The complete labeled box contains

$$
2(23)(101)(225)(253)(117)
=30{,}943{,}405{,}350
\tag{2.2}
$$

coefficient vectors.  By contrast, independent Vieta estimates
$|c_k|<\binom6k(\sqrt5)^k$ give the vector

$$
(13,74,223,374,335)
$$

and a box of

$$
1{,}807{,}556{,}533{,}398.
$$

The conserved-product cage is therefore smaller by the exact factor
$58.4149195\ldots$ before any resultant is evaluated.

The residual equation is explicit.  With $U=y+y^{-1}$, direct expansion
of the even and odd parts gives

$$
\begin{aligned}
A(U)={}&U^3+(c_2+6)U^2+(c_4+4c_2+12)U\\
&+(c_6+2c_4+4c_2+8),\\[2mm]
B(U)={}&c_1U^2+(c_3+4c_1)U+(c_5+2c_3+4c_1),
\end{aligned}
\tag{2.3}
$$

with

$$
E(y)=y^3A(U),
\qquad
O(y)=y^2(y+1)B(U).
$$

Since $A(-2)=c_6$, (1.12) specializes to

$$
\boxed{
\operatorname{Res}_y(E,O)
=-c_6\operatorname{Res}_U(A,B)^2,
\qquad
c_6=\pm1,
\qquad
\operatorname{Res}_U(A,B)=\pm1.
}
\tag{2.4}
$$

The even side $(c_2,c_4,c_6)$ has only

$$
(101)(253)(2)=51{,}106
\tag{2.5}
$$

possibilities.  A certificate should enumerate these cubic $A$'s and solve
the bounded quadratic-polynomial norm-unit problem
$\operatorname{Res}(A,B)=\pm1$ for $B$; it should not scan the
$30.9$-billion-vector Cartesian box.  Modular sieving, exact resultant
solvers, root topology, irreducibility, and prefix/tail obstructions remain
subsequent independent filters.

## 3. The cage is not sufficient

Two reciprocal sextics make the logical boundary concrete.

First take

$$
H_-(T)=T^3-T^2-2T-1.
$$

It is irreducible over $\mathbb Q$ by the rational-root test, has unit
constant term, and lies well inside the degree-three coefficient cage.
Its discriminant is $-31$.  Its real root lies in $(2,\sqrt5)$; the other
two roots are therefore a complex conjugate pair, and their common modulus
is the square root of the reciprocal of the real root.  In particular it
also satisfies the actual trace-radius condition.  Nevertheless

$$
\begin{aligned}
x^3H_-(x+x^{-1})
&=x^6-x^5+x^4-3x^3+x^2-x+1\\
&=-(x^3-x^2-1)(1-x-x^3),
\end{aligned}
$$

and its parity resultant is $9$, not a unit.  Thus an irreducible trace
polynomial inside the radius cage need not lift to an irreducible reciprocal
polynomial.  The residual unit condition detects this example.

Now take

$$
H_+(T)=T^3+T^2-2T-1.
$$

Then

$$
x^3H_+(x+x^{-1})
=x^6+x^5+x^4+x^3+x^2+x+1
=\Phi_7(x).
$$

This example has trace roots in $(-2,2)$, satisfies the coefficient cage,
has constant-term unit, and has parity resultant $1$.  It is nevertheless
never a divisor of any $F_X$.  Indeed, at a primitive seventh root $\zeta$,
$F_X(\zeta)=0$ would force the seven counts of the exponents $p-2$ modulo
$7$ to be equal.  For $X<7$ the nonempty exponent support is contained in
$\{0,1,3\}$, hence is a proper subset of all seven residues; equality is
impossible.  For
$7\le X<17$, the residue corresponding to primes
$p\equiv1\pmod7$ is absent, while the prime $7$ supplies one exponent in
the otherwise unavailable residue $5$.  For $X\ge17$, that residue still
has count one, whereas $p=3$ and $p=17$ give count at least two in exponent
residue $1$.  Hence $\Phi_7\nmid F_X$ for all $X$.

The first example separates trace irreducibility from reciprocal
irreducibility; the second separates all of the cage and parity-unit tests
from prime-prefix divisibility.  The correct interpretation is therefore:

$$
\boxed{
\text{trace cage + residual unit = exact necessary preprocessing, not a
divisibility criterion.}
}
$$

## 4. CPU interpretation and trust boundary

The reusable computational pipeline is:

1. generate the exact integer cage from $(n,k)$ using (1.2);
2. split the coefficients into the lower-dimensional Joukowski pair;
3. solve the exact residual norm-unit equation before root calculations;
4. only then apply topology, irreducibility, cyclotomic classification, and
   prefix/tail certificates.

The theorem transfers the high-value reasoning into ordinary exact code:
binomial arithmetic, algebraic integer bounds, resultants, modular filters,
and deterministic certificate replay.  The degree-twelve counts in this
note are closed-form box counts, not evidence that the residual unit census
has already been completed.  No degree-twelve exclusion theorem is claimed.

The proof depends on four exact hypotheses: the prime-prefix $0$--$1$
odd-support root-annulus estimate, reciprocal divisibility, integrality, and
the standard reciprocal resultant factorization.  Removing any subsequent
filter is unsound, as Section 3 demonstrates.
