# The least factor degree of the prime-prefix polynomial diverges

For a real number $X\ge2$, set

$$
F_X(x)=\sum_{p\le X}x^{p-2},
$$

where the sum is over primes.  Define

$$
\delta(F_X)=\min\{\deg g:g\in\mathbb Q[x]
\text{ is nonconstant and irreducible, }g\mid F_X\},
$$

and let $\delta_{\rm nr}(F_X)$ denote the corresponding minimum restricted
to nonreciprocal irreducible factors, with value $+\infty$ if none exist.
Here an irreducible polynomial is nonreciprocal when its reciprocal
$x^{\deg g}g(1/x)$ is not an associate of $g$; equivalently, for a root
$\alpha$, the inverse $\alpha^{-1}$ is not a conjugate of $\alpha$.  Then

$$
\boxed{\delta(F_X)\longrightarrow\infty\qquad(X\to\infty).}
$$

More quantitatively, with $\log_j$ denoting the $j$-fold iterated
logarithm,

$$
\boxed{
\delta(F_X)\gg
\frac{\log_2X\,(\log_4X)^4}{(\log_3X)^4}
}
$$

and

$$
\boxed{
\delta_{\rm nr}(F_X)\gg
\frac{\log_2X\,\log_4X}{\log_3X}
}
$$

for all sufficiently large $X$.  The implied constant is effective.

The proof is short, but it joins two results that normally live in
different literatures: Lenstra's gap theorem for bounded-degree factors of
lacunary polynomials and Ford--Maynard--Tao's theorem on chains of large
prime gaps.  The repo's global cyclotomic classification removes exactly
the root-of-unity exception in Lenstra's theorem.

## 1. Lenstra's algebraic gap theorem

For $n\ge2$, define

$$
c(n)=\frac{2}{n(\log(3n))^3},
$$

and put $c(1)=\log2$.  Proposition 2.3 of Lenstra's
[Finding small degree factors of lacunary polynomials](https://pub.math.leidenuniv.nl/~lenstrahw/PUBLICATIONS/1999a/art.pdf)
says the following.

Let $f\in\mathbb Q[x]$ have at most $k+1$ nonzero terms and write
$f=g+h$, where every term of $g$ has degree at most $\ell$ and every term
of $h$ has degree at least $u$.  If

$$
u-\ell>\frac{\log(kH(f))}{c(n)},
$$

then every zero of $f$ of degree at most $n$ that is not a root of unity
is a common zero of $g$ and $h$.  Here $H(f)$ is the projective coefficient
height.

For $F_X$, the number of terms is $N=\pi(X)$ and

$$
H(F_X)=1.
$$

Thus, for $n\ge2$, a support gap larger than

$$
T_n(X)=\frac{\log(N-1)}{c(n)}
=\frac n2(\log(3n))^3\log(N-1)
$$

splits every noncyclotomic irreducible factor of degree at most $n$ across
the two sides of the gap.  For $n=1$ the same statement uses the smaller
threshold $\log(N-1)/\log2$; this harmless exceptional formula will be
absorbed below.

## 2. The two-gap exclusion principle

Lenstra's proposition has a useful consequence that does not appear to
require any arithmetic structure in the support.

> **Two-gap lemma.**  Let
> $$
> f(x)=\sum_{i=0}^{r}a_i x^{e_i}\in\mathbb Q[x],
> \qquad
> a_i\ne0,\qquad e_0<e_1<\cdots<e_r,\qquad f(0)\ne0.
> $$
> If, for some $1\le j<r$,
> $$
> \min(e_j-e_{j-1},e_{j+1}-e_j)
> >\frac{\log(rH(f))}{c(n)},
> $$
> then every irreducible factor of $f$ of degree at most $n$ is
> cyclotomic.

Indeed, let $q$ be a noncyclotomic irreducible factor and $\alpha$ one of
its zeros.  Apply Lenstra at the first gap: $\alpha$ is a zero of
$\sum_{i<j}a_ix^{e_i}$.  Apply it at the second gap: $\alpha$ is a zero of
$\sum_{i\le j}a_ix^{e_i}$.  Subtraction gives
$a_j\alpha^{e_j}=0$, impossible because $a_j\ne0$ and $f(0)\ne0$ implies
$\alpha\ne0$.

Thus one large support gap is a persistence mechanism: a low-degree factor
must occur in both chunks.  Two adjacent large gaps are an annihilation
mechanism: persistence isolates a single monomial, which cannot carry the
factor.

### Application to two consecutive prime gaps

Let $p_j<p_{j+1}<p_{j+2}\le X$ be consecutive primes.  Suppose that both

$$
p_{j+1}-p_j>T_n(X),
\qquad
p_{j+2}-p_{j+1}>T_n(X).
$$

Assume that a noncyclotomic irreducible $q\in\mathbb Q[x]$ of degree at
most $n$ divides $F_X$.  Choose a zero $\alpha$ of $q$.  It is not a root
of unity, since otherwise the irreducible polynomial $q$ would be
cyclotomic.

Apply Lenstra's proposition at the first gap.  It says that $\alpha$ is a
zero of the left prefix $F_{p_j}$, hence

$$
q\mid F_{p_j}.
$$

Apply it again at the second gap.  This gives

$$
q\mid F_{p_{j+1}}.
$$

Subtracting,

$$
q\mid F_{p_{j+1}}-F_{p_j}=x^{p_{j+1}-2}.
$$

This is impossible: $q$ is nonconstant and
$q(0)\mid F_X(0)=1$, whereas the only irreducible factor of a monomial is
$x$.

This is exactly the two-gap lemma with the isolated exponent
$e_j=p_{j+1}-2$.  The expanded divisibility argument also makes clear why
one large gap alone would only make the factor recur in a smaller prefix,
whereas two consecutive large gaps turn recurrence into a contradiction.

## 3. Prime-gap input and the quantitative bound

For fixed $r\ge1$, Ford, Maynard, and Tao define

$$
G_r(X)=
\max_{p_{m+r}\le X}
\min_{1\le i\le r}(p_{m+i}-p_{m+i-1}).
$$

Their theorem in
[Chains of large gaps between primes](https://arxiv.org/abs/1511.04468)
gives, for every fixed $r$ and all sufficiently large $X$,

$$
G_r(X)\gg\frac1{r^2}
\frac{\log X\,\log_2X\,\log_4X}{\log_3X},
$$

with an effective implied constant independent of $r$.  Take $r=2$.
Because $\log(\pi(X)-1)\le\log X$, the two gaps supplied by this theorem
eventually exceed $T_n(X)$ for every fixed $n$.  The argument of the
previous section therefore excludes every fixed noncyclotomic factor
degree for all sufficiently large $X$.

Lenstra's displayed $c(n)$ already gives the effective, but weaker, rate
$\delta(F_X)\gg\log_2X\log_4X/(\log_3X)^4$.  His proof, however, only uses
a lower bound for the height of a non-root-of-unity algebraic number.
Voutier's main theorem in
[An effective lower bound for the height of algebraic numbers](https://arxiv.org/abs/1211.3110)
proves that an algebraic number $\alpha$ of degree $m\ge2$ that is not a
root of unity satisfies

$$
m h(\alpha)>
\frac14\left(\frac{\log\log m}{\log m}\right)^3.
$$

The function
$m^{-1}(\log\log m/\log m)^3$ is decreasing for $m>e^e$.
Combining Voutier's theorem for $16\le m\le n$ with Lenstra's explicit
$c(m)$ for the finitely many smaller degrees gives, uniformly for
all non-root-of-unity numbers of degree at most $n$ and all sufficiently
large $n$,

$$
h(\alpha)\ge
\frac1{4n}\left(\frac{\log\log n}{\log n}\right)^3.
$$

Replacing $c(n)$ by this stronger height bound in Lenstra's proof makes
the required support gap at most

$$
4n\left(\frac{\log n}{\log\log n}\right)^3
\log(\pi(X)-1).
$$

Now put

$$
D(X)=\left\lfloor
\eta\frac{\log_2X\,(\log_4X)^4}{(\log_3X)^4}
\right\rfloor
$$

for a sufficiently small effective absolute constant $\eta>0$.  Uniformly
for $1\le n\le D(X)$,

$$
4n\left(\frac{\log n}{\log\log n}\right)^3
\log(\pi(X)-1)
\le
\left(4\eta+o(1)\right)
\frac{\log X\,\log_2X\,\log_4X}{\log_3X}.
$$

Choosing $\eta$ below one quarter of the effective constant in the $G_2$ theorem
makes both consecutive gaps Lenstra-admissible.  Hence $F_X$ has no
noncyclotomic irreducible factor of degree at most $D(X)$.

### The stronger nonreciprocal tier

Smyth proved in
[On the Product of the Conjugates outside the unit circle of an Algebraic Integer](https://doi.org/10.1112/blms/3.2.169)
that every nonreciprocal algebraic integer satisfies

$$
M(\alpha)\ge\theta_0=1.324717957\ldots,
$$

where $\theta_0$ is the real root of $x^3-x-1$.  If a nonreciprocal
irreducible factor has degree $m\le D$, any one of its roots therefore has

$$
h(\alpha)=\frac{\log M(\alpha)}m
\ge\frac{\log\theta_0}{D}.
$$

Lenstra's proof now requires only a support gap larger than

$$
\frac{D\log(\pi(X)-1)}{\log\theta_0}.
$$

Taking

$$
D=\left\lfloor
\eta\frac{\log_2X\,\log_4X}{\log_3X}
\right\rfloor
$$

with a sufficiently small effective $\eta>0$, the Ford--Maynard--Tao
chain supplies two larger consecutive gaps.  The two-gap lemma then
excludes every nonreciprocal factor through degree $D$, proving the second
boxed estimate.  This is the more relevant tier for homometric rigidity:
at the algebraic spectral-factorization level, only nonreciprocal factors
can create reversal choices.  This does not say that every algebraic
choice preserves the required $0$--$1$ coefficients.

There is always a nonreciprocal factor here.  For $X\ge3$, the degree
$p_{\max}-2$ of $F_X$ is odd.  Moreover, the unique-real-root argument in
`QUINTIC_OBSTRUCTION.md` shows that $F_X$ has exactly one odd-degree
irreducible factor, with multiplicity one.  An odd-degree reciprocal or
anti-reciprocal irreducible polynomial has $-1$ or $+1$ as a root; neither
can divide $F_X$ once $X\ge13$.  Hence the unique odd carrier is
nonreciprocal and obeys the stronger estimate

$$
\deg G_X\gg\frac{\log_2X\,\log_4X}{\log_3X}.
$$

Finally, the global cyclotomic classification in `CYCLOTOMIC_TRACE.md`
proves

$$
\Phi_m\mid F_X
\quad\Longleftrightarrow\quad
(m=2,\ 3\le X<5)
\ \text{or}\
(m=6,\ 11\le X<13).
$$

There are therefore no cyclotomic exceptions once $X\ge13$, completing
the factor-degree claims.

## 4. Subexponential homometric ambiguity

The nonreciprocal bound has a direct consequence for the difference-data
problem.  For a polynomial $P$ with nonzero constant term, write

$$
P^*(x)=x^{\deg P}P(1/x).
$$

Normalize a finite $0$--$1$ support polynomial to have constant term one.
Its labeled difference multiset is encoded by $PP^*$ up to the forced
monomial shift.  Let $\mathcal H_X$ be the set of normalized $0$--$1$
polynomials $A$ satisfying

$$
AA^*=F_XF_X^*.
$$

Factor $F_X$ over $\mathbb Q[x]$.  For a monic irreducible factor $q$ put
$q^\dagger=q(0)^{-1}q^*$, its monic reciprocal, and group the
nonreciprocal factors into pairs $\{q_j,q_j^\dagger\}$.  If the total multiplicity
of this pair in $F_X$ is $m_j$, then a spectral factor $A$ can allocate
$0,1,\ldots,m_j$ copies to $q_j$ and the remainder to $q_j^\dagger$: at most
$m_j+1$ choices.  Reciprocal irreducible factors have no allocation
choice.  Therefore

$$
|\mathcal H_X|
\le\prod_j(m_j+1)
\le2^{\sum_jm_j}.
$$

At least one member of each pair divides $F_X$; the two members have equal
degree, and $m_j\deg q_j$ is exactly that pair's degree contribution to
$F_X$.  Hence $\deg q_j\ge\delta_{\rm nr}(F_X)$ and

$$
\sum_jm_j\le
\frac{\deg F_X}{\delta_{\rm nr}(F_X)}
\le
\frac{X}{\delta_{\rm nr}(F_X)}.
$$

The Smyth-tier estimate now gives

$$
\boxed{
\log|\mathcal H_X|
\ll
\frac{X\log_3X}{\log_2X\,\log_4X}
=o(X).
}
$$

Thus the number of normalized prime-prefix homometric candidates is
subexponential in the ambient degree.  Equivalently, its ambiguity entropy
per coefficient tends to zero, since Bertrand's theorem gives
$\deg F_X\asymp X$.  Constant and leading coefficient one remove scalar
and translation units; reflection is counted twice, which is harmless for
an upper bound.  This is weaker than uniqueness: most
algebraic factor allocations need not preserve $0$--$1$ coefficients, but
the estimate deliberately counts all of them and is therefore an
unconditional upper bound for the genuine combinatorial partners.

## 5. Meaning and limitation

This is an asymptotic rigidity theorem, not an effective closure of the
octic case at accessible cutoffs.  The available effective threshold from
the prime-gap machinery is enormous.  The exact degree-$3$ through
degree-$7$ classifications and the reciprocal degree-$8$ exclusion remain
valuable because they operate at every finite cutoff with small exact
certificates.

Targeted searches found the separate theorems of Lenstra, Voutier, Smyth,
and Ford--Maynard--Tao, but no prior statement of their above prime-prefix
consequence.  The safest novelty description is therefore: an apparently
unrecorded corollary/synthesis, pending a broader expert search; none of
the height or prime-gap inputs is new.
