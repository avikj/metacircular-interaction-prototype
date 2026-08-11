# The least factor degree of the prime-prefix polynomial diverges

For a real number $X\ge2$, set

$$
F_X(x)=\sum_{p\le X}x^{p-2},
$$

where the sum is over primes.  If

$$
\delta(F_X)=\min\{\deg g:g\in\mathbb Q[x]
\text{ is nonconstant and irreducible, }g\mid F_X\},
$$

then

$$
\boxed{\delta(F_X)\longrightarrow\infty\qquad(X\to\infty).}
$$

More quantitatively, with $\log_j$ denoting the $j$-fold iterated
logarithm,

$$
\boxed{
\delta(F_X)\gg
\frac{\log_2X\,\log_4X}{(\log_3X)^4}
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

## 2. Two consecutive prime gaps isolate one monomial

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

The important point is that one large gap would only make the factor recur
in a smaller prefix.  Two consecutive large gaps isolate the prime between
them and turn recurrence into a contradiction.

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

The comparison can be inverted.  Put

$$
D(X)=\left\lfloor
\eta\frac{\log_2X\,\log_4X}{(\log_3X)^4}
\right\rfloor
$$

for a sufficiently small effective absolute constant $\eta>0$.  Uniformly
for $1\le n\le D(X)$,

$$
\frac n2(\log(3n))^3\log(\pi(X)-1)
\le
\left(\frac\eta2+o(1)\right)
\frac{\log X\,\log_2X\,\log_4X}{\log_3X}.
$$

Choosing $\eta$ below twice the effective constant in the $G_2$ theorem
makes both consecutive gaps Lenstra-admissible.  Hence $F_X$ has no
noncyclotomic irreducible factor of degree at most $D(X)$.

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
both boxed claims.

## 4. Meaning and limitation

This is an asymptotic rigidity theorem, not an effective closure of the
octic case at accessible cutoffs.  The available effective threshold from
the prime-gap machinery is enormous.  The exact degree-$3$ through
degree-$7$ classifications and the reciprocal degree-$8$ exclusion remain
valuable because they operate at every finite cutoff with small exact
certificates.

Targeted searches found Lenstra's bounded-degree factor theorem and the
Ford--Maynard--Tao chain theorem, but no prior statement of their above
prime-prefix consequence.  The safest novelty description is therefore:
an apparently unrecorded corollary/synthesis, pending a broader expert
search; neither input theorem is new.
