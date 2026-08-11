# Cyclotomic rigidity of prime-prefix polynomials

## Abstract

For real $X\ge2$, define the prime-prefix polynomial

$$F_X(x)=\sum_{p\le X\atop p\ {\rm prime}}x^{p-2}\in\mathbb Z[x].$$

We classify all of its cyclotomic divisors:

$$
\Phi_m\mid F_X
\quad\Longleftrightarrow\quad
\begin{cases}
m=2,&3\le X<5,\\
m=6,&11\le X<13.
\end{cases}
$$

The proof separates according to the arithmetic of the conductor.  If
$p^2\mid m$, a relative trace from $\mathbb Q(\zeta_m)$ to
$\mathbb Q(\zeta_{m/p})$ annihilates every prime exponent except $p$, giving
an immediate contradiction.  If $m$ is squarefree, the primitive roots form
a rational basis.  The vanishing relation then forces an exact vector of
prime counts in residue classes and, in particular,
$\pi(X)=\sum_{p\mid m}p$.  An elementary covering argument reduces all
squarefree conductors to $m=P$ and $m=2P$ with $P$ prime.  Published
complete-residue-system theorem of Hajdu and Saradha finishes both
families.  The result is unconditional, while inheriting the finite
computational component of that published input.

## 1. Statement

Let $p_k$ denote the $k$th prime.  Since $F_X$ is constant on each interval
$[p_k,p_{k+1})$, it suffices to work at prime cutoffs.

> **Theorem 1.** Let $m\ge1$ and let $X\ge2$ be real. Then
> $$
> \Phi_m\mid F_X
> \iff
> \bigl(m=2\text{ and }3\le X<5\bigr)
> \text{ or }
> \bigl(m=6\text{ and }11\le X<13\bigr).
> $$

The edge $m=1$ is immediate because $F_X(1)=\pi(X)>0$.  Henceforth
$m>1$, and $\zeta_m$ denotes a primitive $m$th root of unity.

## 2. The non-squarefree obstruction

> **Lemma 2.** If $p^2\mid m$, then $\Phi_m\nmid F_X$ for every $X$.

*Proof.* Put $f=m/p$, $K=\mathbb Q(\zeta_m)$, and
$K_0=\mathbb Q(\zeta_f)$.  Since $p^2\mid m$, the extension $K/K_0$ has
degree $p$, with automorphisms

$$\sigma_j(\zeta_m)=\zeta_m^{1+jf},\qquad 0\le j<p.$$

Thus

$$
\operatorname{Tr}_{K/K_0}(\zeta_m^a)
=\zeta_m^a\sum_{j=0}^{p-1}(\zeta_m^f)^{aj}
=
\begin{cases}
0,&p\nmid a,\\
p\zeta_m^a,&p\mid a.
\end{cases}
\tag{2.1}
$$

If $p\le X$ and $\Phi_m\mid F_X$, then multiplication of
$F_X(\zeta_m)=0$ by $\zeta_m^2$ gives
$\sum_{q\le X}\zeta_m^q=0$, the sum being over primes.  The trace (2.1)
leaves only $p\zeta_m^p=0$, a contradiction.  If $p>X$, then

$$\deg\Phi_m=\varphi(m)\ge p(p-1)>X-2\ge\deg F_X,$$

which also precludes divisibility. $\square$

Consequently only squarefree conductors remain.

## 3. The forced residue vector

For squarefree $m$ and a prime $r\mid m$, the geometric sum along the fiber
modulo $m/r$ gives

$$
\zeta_m^r
=-
\sum_{\substack{c\in(\mathbb Z/m\mathbb Z)^\times\\
c\equiv r\pmod{m/r}}}\zeta_m^c.
\tag{3.1}
$$

Indeed, the $r$ exponents $r+j(m/r)$, $0\le j<r$, sum to zero; the term
$j=0$ is the unique nonunit among them.

Let $n_c(X)$ count primes $q\le X$ with $q\nmid m$ and
$q\equiv c\pmod m$.

> **Lemma 3.** Let $m>1$ be squarefree.  Then $\Phi_m\mid F_X$ if and only
> if every prime divisor of $m$ is at most $X$ and
> $$
> n_c(X)=\#\{r\mid m:r\text{ prime},\ c\equiv r\pmod{m/r}\}
> \tag{3.2}
> $$
> for every $c\in(\mathbb Z/m\mathbb Z)^\times$.

*Proof.* If a prime $r\mid m$ exceeds $X$, then
$\varphi(m)\ge r-1>\deg F_X$.  Otherwise multiply
$F_X(\zeta_m)=0$ by $\zeta_m^2$ and expand each ramified term
$\zeta_m^r$ by (3.1).  For squarefree $m$, the primitive $m$th roots form a
rational basis of $\mathbb Q(\zeta_m)$, so coefficient comparison gives
(3.2).  Reversing the expansion proves the converse. $\square$

In every sum or product below, $r\mid m$ means that $r$ ranges over the
prime divisors of $m$.

Summing (3.2) over unit classes gives

$$
\boxed{\ \pi(X)=\sum_{r\mid m\atop r\ {\rm prime}}r.\ }
\tag{3.3}
$$

At a prime cutoff $X=p_k$, every candidate therefore satisfies

$$
k=\sum_{r\mid m}r,
\qquad
\varphi(m)=\prod_{r\mid m}(r-1)\le p_k-2.
\tag{3.4}
$$

More strongly, every prime $q\le p_k$ not dividing $m$ must be covered by
at least one congruence

$$q\equiv r\pmod{m/r},\qquad r\mid m.\tag{3.5}$$

## 4. The covering reduction

Let $P$ be the largest prime divisor of the squarefree integer $m$ and put
$M=m/P$.  If a prime $q<P$ does not divide $m$, then (3.5) cannot use
$r\ne P$: the modulus $m/r$ is divisible by $P$ while
$0<|q-r|<P$.  Therefore

$$M\mid P-q.\tag{4.1}$$

> **Lemma 4.** Every squarefree conductor satisfying Lemma 3 belongs to the
> families $m=P$ or $m=2P$, apart from the small retained conductors
> $m=2,6$.

*Proof.* First suppose $P\le M$.  Equation (4.1) forces every prime below
$P$ to divide $m$, hence $m=P\#$, the primorial through $P$.  The cases
$P=2,3$ give $m=2,6$.  For $P=5$, the next prime $7$ is not covered modulo
$30$.  For $P\ge7$, let $Q$ be the next prime after $P$.  It lies below the
cutoff because $k=\sum_{r\mid m}r\ge P+2>\pi(P)+1$.  Bertrand's postulate
gives $Q<2P$, whereas

$$m/r\ge m/P=(P-1)\#>2P>|Q-r|$$

for every $r\mid m$.  Thus $Q$ is not covered, a contradiction.

Now suppose $P>M$.  Every prime $q<M$ not dividing $M$ must satisfy
$q\equiv P\pmod M$; hence $M$ omits at most one prime below itself.  We
claim that a squarefree integer with this property belongs to
$\{1,2,3,6\}$.  If $M$ is prime, every $M\ge5$ omits both $2$ and $3$.
If $M$ is composite with largest prime factor $R$, Bertrand supplies a
missing prime in $(R,2R)$.  All primes below $R$ must therefore divide $M$.
For $R\ge5$ this forces $M=R\#$, while a second application of Bertrand
supplies another missing prime in $(2R,4R)\subset(0,M)$, a contradiction.

The cases $M=3$ and $M=6$ are eliminated directly by (4.1): for $M=3$ the
test primes $2,7$ demand incompatible residues of $P$ modulo $3$ (with the
small edges checked directly), and for $M=6$ the primes $5,7$ demand
$P\equiv5$ and $1\pmod6$.  Hence $M=1$ or $2$. $\square$

## 5. Complete residue systems

It remains to finish the two infinite families in Lemma 4.

We use one corollary of Hajdu--Saradha's 2016 Theorem 2.3: if $P\ge5$ is
prime and $P$ primes no larger than $p_{P+2}$ form a complete residue
system modulo $P$, then $P\in\{7,11\}$.  This follows because
$p_{P+2}\le p_{P+\pi(P)-1}$, placing the system inside their stated bound.

If $m=P$, then (3.3) gives $k=P$, while (3.2) says that the first $P$
primes form a complete residue system modulo $P$.  The corollary reduces
$P\ge5$ to $7,11$, and the first $P$ primes omit residue $1$ modulo $7$,
respectively residue $10$ modulo $11$.  The case $P=3$ fails directly and
$P=2$ survives.

If $m=2P$ with $P$ odd, then $k=P+2$, and the target multiset in (3.2) is

$$
\{\text{every unit class modulo }2P\text{ once}\}
\uplus\{P+2\text{ once more}\}.
\tag{5.1}
$$

Choose one realizing prime from every unit class, then adjoin $P$.  Reduction
modulo $P$ produces $P$ primes forming a complete residue system, all at
most $p_{P+2}$.  For $P\ge5$,

$$p_{P+2}\le p_{P+\pi(P)-1}.$$

The same corollary restricts $P\ge5$ to $7,11$.  Here $P=2$ gives a
non-squarefree conductor.  For $P=3,7,11$, (5.1) gives:

$$
\begin{array}{c|c|c}
P&m&\text{unramified residues modulo }2P\\ \hline
3&6&\{5,1,5\}\quad\text{(matches)}\\
7&14&\{3,5,11,13,3,5,9\}\quad\text{(fails)}\\
11&22&\{3,5,7,13,17,19,1,7,9,15,19\}\quad\text{(fails)}.
\end{array}
$$

Thus $m=2$ and $m=6$ are the only conductors, and their exact cutoff
intervals follow by direct evaluation.  This proves Theorem 1. $\square$

## 6. Verification and novelty boundary

The exact script `code/exp28_squarefree_ties.py` enumerates all candidates
in (3.4), applies first- and second-moment congruences implied by (3.2), and
then compares the complete residue multisets.  Through $k=2{,}000{,}000$
($p_k=32{,}452{,}843$), all $2{,}417{,}270$ candidates reduce to the two
theoretical cases.

The primitive-root basis and general root-of-unity relation machinery are
classical (Rédei; de Bruijn--Rédei--Schoenberg; Bosma).  General coefficient
criteria for cyclotomic divisibility are available in De Carli--Laporta
(2026), and the final complete-residue classifications are due to
Hajdu--Saradha.  A targeted literature search found no prior statement of
Theorem 1 for the prime-prefix support, but this should be described only as
"apparently not previously recorded" pending database and expert review.

## References

1. L. Rédei, *Natürliche Basen des Kreisteilungskörpers*, Abh. Math. Sem.
   Univ. Hamburg **23** (1959), 180--200.
2. W. Bosma, *Canonical Bases for Cyclotomic Fields*, AAECC **1** (1990),
   125--134.
3. L. Hajdu, N. Saradha, *On a problem of Recaman and its generalization*,
   J. Number Theory **131** (2011), 18--24,
   <https://doi.org/10.1016/j.jnt.2010.07.002>.
4. L. Hajdu, N. Saradha, *On generalizations of problems of Recaman and
   Pomerance*, J. Number Theory **162** (2016), 552--563,
   <https://doi.org/10.1016/j.jnt.2015.10.006>.
5. L. De Carli, M. Laporta, *Divisibility criteria and coefficient formulas
   for cyclotomic polynomials*, Ramanujan J. **70** (2026), Article 44,
   <https://doi.org/10.1007/s11139-026-01421-6>.
