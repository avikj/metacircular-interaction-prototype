# The cubic layer closes for every prime-prefix polynomial

Let

$$F_X(x)=\sum_{p\le X,\ p\text{ prime}}x^{p-2}.$$

For $X\ge5$, its support begins with $\{0,1,3\}$ and every later exponent
is odd.  This elementary shape alone rules out every cubic factor after the
initial polynomial.

> **Theorem 1 (odd-support cubic obstruction).** Let
> $$
> P(x)=1+x+x^3+
> \sum_{\substack{j\ge5\\j\text{ odd}}}\epsilon_jx^j,
> \qquad \epsilon_j\in\{0,1\},
> \tag{1.1}
> $$
> have finite support and leading coefficient $1$.  Then $P$ has an
> irreducible cubic factor over $\mathbb Q$ if and only if every
> $\epsilon_j=0$.  In that case $P=x^3+x+1$ is itself irreducible.

> **Corollary 2.** The prime-prefix polynomial $F_X$ has an irreducible
> cubic factor if and only if $5\le X<7$.  Therefore $F_X$ has no cubic
> factor for every $X\ge7$.

Here the last phrase also excludes reducible degree-$3$ divisors.  Such a
divisor would have a rational linear factor, but the rational-root theorem
leaves only $\pm1$, while $P(1)>0$ and
$P(-1)=1-(2+\sum_{j\ge5}\epsilon_j)<0$.

## 1. Root geometry

Suppose a monic irreducible cubic

$$g(x)=x^3+ax^2+bx+c\in\mathbb Z[x]$$

divides $P$.  Since $c\mid P(0)=1$, we have $c=\pm1$.  The polynomial
$P(y)>0$ for every $y\ge0$, so every real root of $g$ is negative.

If $c=-1$, the product of the roots is $-c=1$.  With one real root and a
nonreal conjugate pair, that product is a negative number times $|z|^2$;
with three real roots it is the product of three negative numbers.  Both are
negative, a contradiction.  Hence $c=1$ and the root product is $-1$.

Write a real root as $-t$, $t>0$.  From (1.1),

$$P(-t)=1-t-t^3-sum_{j\ge5,\ j\text{ odd}}\epsilon_jt^j<0
\qquad(t\ge1),$$

so every real root has $t<1$.  Three real roots would all have modulus below
$1$, contradicting that their product has modulus $1$.  Thus $g$ has exactly
one real root $-t$ and a nonreal pair $z,\overline z$.

The standard root-annulus argument for a monic $0$--$1$ polynomial with
constant term $1$, applied also to its reciprocal, gives

$$\frac12<|w|<2$$

for every root $w$ of $P$.  In particular $1/2<t<1$.  From
$(-t)|z|^2=-1$ we get $|z|=t^{-1/2}$.  If $z=|z|e^{i\theta}$, Vieta gives

$$a=t-2t^{-1/2}\cos\theta.$$

The bounds $1/2<t<1$ imply

$$a\in\{-2,-1,0,1,2,3\}.\tag{1.2}$$

## 2. Six integer candidates

Put

$$h(s)=g(-s)=1-bs+as^2-s^3.$$

This polynomial has the unique real root $t\in(1/2,1)$.  Since $h(0)=1$
and its leading coefficient is negative, $h(s)>0$ before $t$ and $h(s)<0$
after $t$.  Therefore

$$
h(1/2)=\frac{7+2a-4b}{8}>0,
\qquad
h(1)=a-b<0.
$$

Equivalently,

$$b>a,qquad4b<7+2a.\tag{2.1}$$

Enumerating the integer solutions of (1.2)--(2.1) gives exactly

$$
(a,b)\in
\{(-2,-1),(-2,0),(-1,0),(-1,1),(0,1),(1,2)\}.
\tag{2.2}
$$

The first two are impossible.  For $(-2,-1)$, $g(0)=1$ and $g(1)=-1$,
so $g$ has a positive real root; for $(-2,0)$, $g(1)=0$.  Both contradict
divisibility by $P$ (and the latter also contradicts irreducibility).

It remains to eliminate four cases.

1. If $(a,b)=(-1,0)$, then $h(t)=0$ says $1=t^2+t^3$.  But
   $t+t^3=1+t-t^2>1$, so the mandatory $x$ and $x^3$ terms already make
   $P(-t)<0$.
2. If $(a,b)=(-1,1)$, then $h(3/5)=-22/125<0$, hence $t<3/5$.  Even the
   sum of all positive odd powers is
   $$\frac{t}{1-t^2}<\frac{3/5}{1-9/25}=\frac{15}{16}<1,$$
   so $P(-t)>0$.
3. If $(a,b)=(0,1)$, then $h(t)=0$ says $1=t+t^3$.  Consequently
   $$P(-t)=-\sum_{j\ge5,\ j\text{ odd}}\epsilon_jt^j,$$
   which vanishes exactly when every higher coefficient vanishes.  The
   remaining polynomial $x^3+x+1$ is irreducible by the rational-root test.
4. If $(a,b)=(1,2)$, then $h(3/5)=-7/125<0$, so the same geometric-series
   estimate gives $P(-t)>0$.

This proves Theorem 1 and Corollary 2. $\square$

## 3. Consequence for rigidity

Together with `RIGIDITY_FRONTIER.md` Theorems F1 and F2, this gives:

> **Corollary 3.** For every $X\ge13$, every irreducible factor of $F_X$
> is non-cyclotomic and has degree at least $4$.

The result uses no prime-distribution input: any finite Newman polynomial
with the forced odd support (1.1) obeys it.

## 4. Prior-art boundary

General root geometry and low-degree divisor algorithms for Newman
polynomials are established.  Relevant sources include:

- A. Odlyzko, B. Poonen, *Zeros of polynomials with 0,1 coefficients*,
  L'Enseignement Mathématique **39** (1993), 317--348;
- K. Hare, M. Mossinghoff, *Negative Pisot and Salem numbers as roots of
  Newman polynomials*, Rocky Mountain Journal of Mathematics **44** (2014),
  113--138, <https://doi.org/10.1216/RMJ-2014-44-1-113>;
- P. Drungilas, J. Jankauskas, J. Šiurys, *On Newman and Littlewood
  multiples of Borwein polynomials*, Mathematics of Computation **87**
  (2018), 1523--1541, <https://doi.org/10.1090/mcom/3258>.

A targeted search found no prior statement of Theorem 1 or its prime-prefix
corollary.  Its novelty is plausible but should remain qualified pending
expert review.
