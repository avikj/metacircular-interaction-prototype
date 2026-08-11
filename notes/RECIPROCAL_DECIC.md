# Reciprocal decics: unit-product compression and exact finite closure

This note records the final finite calibration of the prime-prefix factor
pipeline.  It is not a proposal to continue one degree at a time: the
all-degree asymptotic exclusion is already proved in
`ASYMPTOTIC_FACTOR_RIGIDITY.md`.  The point of degree ten is the unusually
cheap structural collapse produced by a product-one trace box and a
quadratic norm-unit equation.

The exact certificate is `code/exp45_reciprocal_decic_certificate.py`.
An independently written hostile replay regenerated the unit census,
structural partition, direct prefix resultants, and every tail margin without
importing the production certificate.  It returned **ACCEPT**.

## 1. Reciprocal trace and the parity unit

Let

$$
F_X(x)=\sum_{p\le X}x^{p-2}.
$$

Consider a monic reciprocal decic

$$
g(x)=x^{10}+ax^9+bx^8+cx^7+dx^6+ex^5
      +dx^4+cx^3+bx^2+ax+1.
$$

Writing $S=x+x^{-1}$ gives the exact trace representation

$$
x^{-5}g(x)=H(S),
$$

where

$$
H(S)=S^5+aS^4+(b-5)S^3+(c-4a)S^2
 +(d-3b+5)S+(e-2c+2a).
$$

Use trace coordinates

$$
(A,B,C,D,s)=(a,b-5,c-4a,d-3b+5,e-2c+2a),
$$

so

$$
H(S)=S^5+AS^4+BS^3+CS^2+DS+s.
\tag{1.1}
$$

Write $g(x)=E(x^2)+xO(x^2)$.  The parity-resultant theorem in
`PARITY_RESULTANT.md` says that a divisor of $F_X$ must satisfy

$$
\operatorname{Res}_y(E,O)=\pm1.
\tag{1.2}
$$

The degree-$4k+2$ reciprocal resultant factorization, with the shift
$Y=T+2$, reduces its two trace factors to

$$
P(Y)=Y^2+BY+D,
\qquad
Q(Y)=AY^2+CY+s.
$$

Subtracting $AP$ gives

$$
Q-AP=\ell Y+n,
\qquad
\ell=C-AB,\quad n=s-AD.
$$

Consequently

$$
\boxed{
\operatorname{Res}_y(E,O)=sK^2,
\qquad
K=n^2-B\ell n+D\ell^2.
}
\tag{1.3}
$$

This includes all degree drops.  Equation (1.2) therefore forces the two
independent integer units

$$
\boxed{s=\pm1,\qquad K=\pm1.}
\tag{1.4}
$$

The certificate independently recomputes the Sylvester resultant for every
surviving tuple and checks (1.3), rather than trusting only the reduced
formula used by the enumeration.

## 2. Product-one trace box

Every root $z$ of a prime-prefix polynomial satisfies the standard
odd-support annulus

$$
\varphi^{-1}<|z|<2.
$$

For a reciprocal factor, $z^{-1}$ is also a root.  Applying the lower bound
to $z^{-1}$ sharpens the upper bound to

$$
\varphi^{-1}<|z|<\varphi.
\tag{2.1}
$$

Thus every trace root $\tau=z+z^{-1}$ obeys

$$
|\tau|\le |z|+|z|^{-1}<\varphi+\varphi^{-1}=\sqrt5.
\tag{2.2}
$$

Because the constant term of $H$ is the unit $s$, its five trace-root
moduli have product one.  The unit-product Vieta theorem in
`UNIT_PRODUCT_VIETA.md`, applied with $n=5$ and $R=\sqrt5$, gives

$$
\boxed{|A|\le8,\quad |B|\le30,\quad |C|\le45,\quad |D|\le26.}
\tag{2.3}
$$

The resulting box has exactly

$$
17\cdot61\cdot91\cdot53\cdot2=10{,}002{,}902
$$

labeled tuples.  Direct exact enumeration of (1.4) leaves

$$
15{,}754
$$

tuples, with canonical digest

```
b953532bb421d3d243c68cd61358ba03b2def663cf2acb35370d26154ecdc3a6
```

for sorted lines `A,B,C,D,s,K\n`.

The program does not scan the $91$ possible values of $C$.  Put
$u=C-AB$ and $n=s-AD$.  For a chosen unit $\epsilon=K$, the equation is

$$
Du^2-Bnu+n^2-\epsilon=0,
$$

so for $D\ne0$ it tests the exact square discriminant

$$
\Delta=n^2(B^2-4D)+4D\epsilon
$$

and the two divisibility conditions
$u=(Bn\pm\sqrt\Delta)/(2D)$.  The $D=0$ linear and all-$u$ branches are
handled separately; they contribute $4{,}190$ of the $15{,}754$ tuples.
This solver is equivalent to the direct box census but makes the algebraic
compression part of the executable proof.

## 3. Exact root geometry

A real root of $g$ corresponds exactly to a real trace root of $H$ in
$(-\infty,-2]\cup[2,\infty)$.  Exact Sturm chains, including explicit
checks at $\pm2$, reduce the unit tuples to

$$
15{,}754\longrightarrow6{,}414,
$$

with no endpoint incidence and digest

```
31cfee2c06cc8e6cb6a66ea836d61bcaed8ee92a52210d47a30d7c280864b7fd
```

Exact Cayley--Routh counts at the rational radii

$$
\frac{617}{1000}<\varphi^{-1},
\qquad
\frac{81}{50}>\varphi
$$

then leave exactly $294$ tuples.  No Routh table is degenerate.  Their
digest is

```
7b36d7f06b8858b87e044720fff480e420e56f80bc1a1fd38c2d350b23e28736
```

The rational annulus is deliberately slightly wider than (2.1), so this is
a necessary filter with no numerical boundary assumption.

## 4. Complete reducibility partition

The degree-five trace polynomial has constant term $\pm1$.  If it is
reducible over $\mathbb Z$, its smaller monic factor has degree at most two.
Every factor root has modulus $<\sqrt5$, so the complete search is only

$$
T\pm1,
\qquad
T^2+uT+v,\quad |u|\le4,\ v=\pm1.
\tag{4.1}
$$

Exact division finds $48$ linear and $24$ quadratic witnesses.

There is one necessary caveat: irreducibility of $H$ alone does not always
imply irreducibility of $g=x^5H(x+x^{-1})$.  The classical reciprocal trace
criterion (Cafure--Cesaratto, Corollary 6) says that the only remaining
reducible case has

$$
g=t\,h(x)h^\ast(x),
\qquad t=\pm1,\quad \deg h=5,\quad h(0)=t,\quad h\text{ monic}.
\tag{4.2}
$$

Writing the four interior coefficients of $h$ as $v_1,\ldots,v_4$, comparison
of the middle coefficient of $g$ gives

$$
t=\operatorname{sign}(e),
\qquad
v_1^2+\cdots+v_4^2=|e|-2.
\tag{4.3}
$$

The box (2.3) gives $|e|\le139$, so (4.3) is a finite four-square census of
norm at most $137$.  Exact convolution finds no additional factor.
Therefore the complete structural partition is

$$
\boxed{294=72\text{ reducible}+222\text{ irreducible}.}
\tag{4.4}
$$

As a separate exact cross-check, Rabin witnesses modulo primes at most $251$
certify all $222$ irreducibles directly.  Those modular witnesses are audit
evidence, not the logical authority for (4.4).

The $222$ include

$$
\Phi_{22}: (-1,-4,3,3,-1,-1),
\qquad
\Phi_{11}: (1,-4,-3,3,1,-1),
$$

in $(A,B,C,D,s,K)$ coordinates.  They cannot divide any $F_X$ by Theorem 6
of `CYCLOTOMIC_TRACE.md`.  This leaves $220$ noncyclotomic candidates for
the tail certificate.

## 5. Exact prefix and infinite-tail closure

For one candidate let

$$
u_1\le u_2\le u_3\le u_4\le u_5
$$

be exact rational upper bounds for its five conjugate-pair moduli, obtained
by Cayley--Routh bisection.  Noncyclotomic irreducibility and reciprocity give
$u_1<1$.  Define

$$
B_q(u)=\sum_{p\le q}u^{p-2},
\qquad
R_q=|\operatorname{Res}(g,F_q)|.
$$

If $p^+$ is the next prime after $q$, isolating the inner conjugate pair in
the resultant gives the following sufficient strict criterion, as in the
reciprocal-octic certificate:

$$
\boxed{
R_q(1-u_1^2)^2
>
u_1^{2(p^+-2)}\prod_{j=2}^{5}B_q(u_j)^2.
}
\tag{5.1}
$$

Indeed, the other eight root evaluations are bounded by the four squared
$B_q$ factors.  If a later prefix vanished at the inner root, its stride-two
tail would be at most $u_1^{p^+-2}/(1-u_1^2)$, contradicting (5.1).
Nonzero exact resultants separately exclude every earlier tested prefix;
prefixes of degree below ten cannot contain $g$.

All $220$ candidates close, after $526$ exact resultants, with cutoff census

$$
\begin{array}{c|rrrrrrrrrrrrrr}
q&13&17&19&23&29&31&37&41&47&53&59&71&73&79\\ \hline
\#&137&29&6&19&6&6&6&2&2&3&1&1&1&1.
\end{array}
$$

The smallest certified rational margin is still positive; it occurs for

$$
(A,B,C,D,s,K)=(1,-3,-4,1,1,1),
\qquad q=13,qquad R_q=40189,
$$

and its decimal rendering is $516.58\ldots$.

> **Theorem.** For every real $X\ge2$, no irreducible reciprocal polynomial
> of degree ten divides the prime-prefix polynomial $F_X$.

## 6. Trust boundary

The $x+x^{-1}$ trace substitution, reciprocal irreducibility criterion,
Sturm theory, Routh--Cayley root counts, Rabin's criterion, and resultant
tail argument are classical.  The finite census and its integration are a
problem-specific exact certificate.  The product-one bound is an elementary
reusable synthesis already isolated in `UNIT_PRODUCT_VIETA.md`; no novelty
claim is made for the underlying inequalities.  No floating-point value is
used for a branch decision, count, factorization, root count, resultant, or
tail sign.
