# Global classification of cyclotomic factors of the prime polynomial

This note closes the machine-only open lemma in `RIGIDITY_FRONTIER.md` §3.3.
The proof is shorter and stronger than the lattice computation: a relative
trace isolates the one ramified prime whose square divides the modulus.

Let

$$F_X(x)=\sum_{q\le X\atop q\ {\rm prime}}x^{q-2},$$

and let $\zeta_m$ be a primitive $m$th root of unity.

## 1. The trace obstruction

> **Theorem 1.** If $m$ is non-squarefree, then
> $$\Phi_m\nmid F_X$$
> for every real $X\ge2$.

*Proof.* Choose a prime $p$ with $p^2\mid m$, put $f=m/p$, and write

$$K=\mathbb Q(\zeta_m),\qquad K_0=\mathbb Q(\zeta_f).$$

Since $p^2\mid m$,

$$[K:K_0]=\frac{\varphi(m)}{\varphi(m/p)}=p.$$

The relative Galois group consists of

$$\sigma_j(\zeta_m)=\zeta_m^{1+jf},\qquad 0\le j<p.$$

Every $1+jf$ is a unit modulo $m$: it is $1$ modulo every prime dividing
$f$, including $p$. Therefore, for every integer $a$,

$$
\operatorname{Tr}_{K/K_0}(\zeta_m^a)
=\zeta_m^a\sum_{j=0}^{p-1}(\zeta_m^f)^{aj}
=\begin{cases}
0,&p\nmid a,\\
p\zeta_m^a,&p\mid a.
\end{cases}\tag{1.1}
$$

Suppose first that $p\le X$ and $\Phi_m\mid F_X$. Evaluation at $\zeta_m$
and multiplication by $\zeta_m^2$ give

$$\sum_{q\le X\atop q\ {\rm prime}}\zeta_m^q=0.\tag{1.2}$$

Among prime exponents $q$, exactly one is divisible by $p$, namely $q=p$.
Applying (1.1) to (1.2) yields

$$p\zeta_m^p=0,$$

impossible.

If $p>X$, then

$$\deg\Phi_m=\varphi(m)\ge p(p-1)>X-2\ge\deg F_X,$$

so divisibility is again impossible. $\square$

This includes the earlier $4\mid m$ parity theorem by taking $p=2$, and it
removes every exact-lattice computation from the non-squarefree case.  The
argument is a character projector in its simplest form: relative trace kills
all prime exponents except the ramified prime $p$.

## 2. Exact form of every squarefree tie

The remaining cyclotomic problem is therefore purely squarefree.  In that
case the primitive roots form a rational basis, and the ramified terms can be
expanded explicitly in it.

> **Proposition 2.** Let $m$ be squarefree and $r\mid m$ prime. Then
> $$\zeta_m^r=-\sum_{\substack{c\in(\mathbb Z/m\mathbb Z)^\times\\
> c\equiv r\pmod{m/r}}}\zeta_m^c.\tag{2.1}$$

*Proof.* The geometric sum

$$\sum_{j=0}^{r-1}\zeta_m^{r+j(m/r)}=0$$

has initial term $\zeta_m^r$.  For $j\ne0$, squarefreeness implies that
$r+j(m/r)$ is coprime to $r$ and to every other prime dividing $m$; these are
exactly the unit classes congruent to $r$ modulo $m/r$. $\square$

Let $p_k\le X$ be the last prime cutoff and, for a unit class $c\bmod m$, let
$n_c(X)$ count primes $q\le X$, $q\nmid m$, with $q\equiv c\pmod m$.

> **Corollary 3 (forced class vector).** Let $m>1$ be squarefree. Then
> $\Phi_m\mid F_X$ if and only if every prime divisor of $m$ is at most $X$
> and
> $$n_c(X)=\#\{r\mid m:r\text{ prime and }c\equiv r\pmod{m/r}\}.
> \tag{2.2}$$
> Consequently
> $$\boxed{\ \pi(X)=\sum_{r\mid m\atop r\ {\rm prime}}r.\ }\tag{2.3}$$

*Proof.* If some prime $r\mid m$ exceeds $X$, then
$\varphi(m)\ge r-1>\deg F_X$, so no divisibility is possible.  Otherwise
multiply the tie by $\zeta_m^2$, expand every ramified $\zeta_m^r$ using
(2.1), and compare coefficients in the primitive-root basis. This gives
(2.2); reversing the expansion proves the converse.  Each $r$ contributes
to exactly $r-1$ unit classes. Thus the number
of unramified primes is $\sum_{r\mid m}(r-1)$; adding the $\omega(m)$ ramified
primes yields (2.3). $\square$

Equation (2.2), not random-walk recurrence, is the exact remaining problem.
For each fixed squarefree $m$ it specifies one finite vector of prime counts,
so ties can occur on at most one cutoff interval.  Equation (2.3) is a cheap
scalar filter before the class-by-class test.

If the cutoff is the $k$th prime $p_k$, (2.3) becomes the finite partition
condition

$$k=\sum_{r\mid m\atop r\ {\rm prime}}r,
\qquad
\prod_{r\mid m}(r-1)=\varphi(m)\le p_k-2.\tag{2.4}$$

Thus at each $k$ the remaining candidates are indexed by distinct-prime
partitions of $k$, followed by the necessary-and-sufficient class test (2.2).
This replaces an unbounded search over $(m,X)$ by an explicit finite family.

## 3. The primitive-root span

The relative trace also proves the rank formula that was previously only
machine-verified. Let

$$U_m=\operatorname{span}_{\mathbb Q}
\{\zeta_m^a:(a,m)=1\}\subseteq\mathbb Q(\zeta_m).$$

> **Proposition 4.** For $e\ge2$,
> $$U_{p^e}=\ker\left(
> \operatorname{Tr}_{\mathbb Q(\zeta_{p^e})/
> \mathbb Q(\zeta_{p^{e-1}})}\right),$$
> and therefore
> $$\dim U_{p^e}=\varphi(p^e)-\varphi(p^{e-1}).$$
> For $e=1$, $U_p=\mathbb Q(\zeta_p)$ has dimension $p-1$.

*Proof.* The trace calculation (1.1) puts every primitive $p^e$th root in the
kernel. Conversely, with $K_{e-1}=\mathbb Q(\zeta_{p^{e-1}})$,

$$\mathbb Q(\zeta_{p^e})=
\bigoplus_{j=0}^{p-1}\zeta_{p^e}^{j}K_{e-1}.$$

For $1\le j<p$, every vector in
$\zeta_{p^e}^{j}K_{e-1}$ is spanned by powers whose exponent is not divisible
by $p$, hence by primitive roots. These $p-1$ summands have exactly the
dimension of the trace kernel. The $e=1$ statement is the usual power basis.
$\square$

CRT and the linear disjointness of the prime-power cyclotomic factors give

$$U_m\cong\bigotimes_{p^e\parallel m}U_{p^e},$$

so the effective dimension is now proved:

$$\boxed{\ \dim U_m=
\prod_{p^e\parallel m}
\begin{cases}
p-1,&e=1,\\
\varphi(p^e)-\varphi(p^{e-1}),&e\ge2.
\end{cases}\ }\tag{3.1}$$

## 4. The squarefree covering reduction

We now close the squarefree half.  Let the cutoff be $p_k$, let $P$ be the
largest prime divisor of $m$, and put $M=m/P$.

The forced vector (2.2) has the following covering consequence: for every
prime $q\le p_k$ with $q\nmid m$, there is a prime $r\mid m$ such that

$$q\equiv r\pmod{m/r}.\tag{4.1}$$

If $q<P$ and $q\nmid m$, (4.1) cannot use $r\ne P$, because $m/r$ is
divisible by $P$ while $0<|q-r|<P$.  Hence it must use $r=P$, so

$$M\mid P-q.\tag{4.2}$$

### 4.1 Reduction to $m=P$ or $m=2P$

Suppose first that $P\le M$.  Then (4.2) shows that every prime below $P$
divides $m$, so $m=P\#$, the primorial through $P$.  The cases $P=2,3$ give
$m=2,6$.  For $P=5$, the next prime $7$ satisfies none of the congruences
(4.1) for $m=30$.  For $P\ge7$, Bertrand's postulate gives a next prime
$P<Q<2P$.  But

$$m/r\ge m/P=(P-1)\#>2P>|Q-r|$$

for every $r\mid m$, so $Q$ is uncovered, a contradiction.
Here $Q\le p_k$: indeed $k=\sum_{r\mid m}r\ge P+2>\pi(P)+1$, so the next
prime after $P$ occurs before the cutoff.

Now suppose $P>M$.  Every prime $q<M$ not dividing $M$ obeys
$q\equiv P\pmod M$.  Since $0<q<M$, at most one such prime exists.

> **Lemma 5.** If a squarefree integer $M$ omits at most one prime below $M$,
> then $M\in\{1,2,3,6\}$.

*Proof.* If $M$ is prime, $M\ge5$ omits both $2$ and $3$.  If $M$ is
composite with largest prime factor $R$, Bertrand gives a missing prime
$R<a<2R\le M$.  Hence every prime below $R$ divides $M$.  If $R\ge5$, this
forces $M=R\#$; applying Bertrand between $2R$ and $4R<R\#$ produces a second
missing prime. Thus $R\le3$, leaving $M=6$ (plus $1,2,3$). $\square$

For $M=3$, the missing prime $2$ forces $P\equiv2\pmod3$, while the prime
$7$ forces $P\equiv1\pmod3$ when $P>7$; the edges $P=5,7$ fail directly.
For $M=6$, $q=5$ forces $P\equiv5\pmod6$ and $q=7$ forces
$P\equiv1\pmod6$ (with $P=7$ already failing the first).  Therefore only

$$m=P\qquad\text{or}\qquad m=2P\tag{4.3}$$

remain, besides the already retained $m=2,6$.

All fixed test primes used here lie below $p_k$: in these cases
$k=\sum_{r\mid m}r$ is respectively $P+3$ or $P+5$.

## 5. One complete-residue theorem finishes the classification

We use the following direct corollary of Hajdu--Saradha's 2016 Theorem 2.3.
If $P\ge5$ is prime and some $P$ primes no larger than $p_{P+2}$ form a
complete residue system modulo $P$, then $P\in\{7,11\}$.  Indeed,

$$p_{P+2}\le p_{P+\pi(P)-1}$$

for $P\ge5$, so their theorem first restricts $P$ to $\{2,3,7,11\}$.

### 5.1 The prime family

If $m=P$, then $k=P$ by (2.3), and (2.2) says that the first $P$ primes form
a complete residue system modulo $P$.  They lie below $p_{P+2}$, so the
corollary above reduces $P\ge5$ to $7,11$; both fail directly (the first $P$
primes omit residue $1$ modulo $7$, respectively residue $10$ modulo $11$).
The small case $P=3$ also fails, while $P=2$ gives $F_3=\Phi_2$.

### 5.2 The semiprime family

If $m=2P$ with $P$ odd, then $k=P+2$.  The target multiset in (2.2) is

$$\{\text{every unit class modulo }2P\text{ once}\}
\uplus\{P+2\text{ once more}\}.\tag{5.1}$$

Choose one realizing prime from each unit class and adjoin the prime $P$.
Reduction modulo $P$ gives $P$ primes forming a complete residue system, all
at most $p_{P+2}$.  The same corollary reduces $P\ge5$ to $7,11$.  The case
$P=2$ makes $m=4$ non-squarefree.  Direct forced-multiset checks give:

- $P=3$: modulo $6$, the unramified residues through $p_5=11$ are
  $\{5,1,5\}$, exactly (5.1), so $\Phi_6\mid F_{11}$;
- $P=7$: modulo $14$, the residues are
  $\{3,5,11,13,3,5,9\}$, whereas the target is
  $\{1,3,5,9,11,13,9\}$;
- $P=11$: modulo $22$, the residues are
  $\{3,5,7,13,17,19,1,7,9,15,19\}$, whereas the target is
  $\{1,3,5,7,9,13,15,17,19,21,13\}$.

Thus only $P=3$ survives.

> **Theorem 6 (global cyclotomic classification).** For every $m\ge1$ and
> every prime cutoff $X\ge2$,
> $$\boxed{\ \Phi_m\mid F_X
> \iff (X,m)=(3,2)\text{ or }(11,6).\ }$$

The omitted edge $m=1$ is immediate: $\Phi_1=x-1$ cannot divide $F_X$
because $F_X(1)=\pi(X)>0$.

Since $F_X$ is constant between consecutive primes, the equivalent statement
for real $X\ge2$ has precisely the intervals $m=2$, $3\le X<5$, and $m=6$,
$11\le X<13$.

The proof has no unproved prime-distribution hypothesis.  It does inherit the
finite computational components of the cited Hajdu--Saradha theorems; our
earlier scan through $m\le1000$ is an additional independent verification,
not the theorem's range.

## 6. Exact computational corroboration

The classification proof does not depend on our cutoff scan.  For an independent check,
`code/exp28_squarefree_ties.py` enumerates the finite family (2.4) exactly.
Equality of the forced class vectors implies, for every $H\in\mathbb Z[x]$,

$$
\sum_{q\le p_k,\ q\nmid m}H(q)
\equiv
\sum_{r\mid m}\sum_{j=1}^{r-1}H\!\left(r+j\frac mr\right)
\pmod m.\tag{6.1}
$$

The script applies (6.1) for $H(x)=x$ and $x^2$ before the exact multiset
comparison.  Through $k=2{,}000{,}000$ ($p_k=32{,}452{,}843$), it checks
$2{,}417{,}270$ scalar/degree candidates.  Nine survive the first moment;
only $(k,m)=(2,2)$ and $(5,6)$ survive the second moment and exact forced
vector.  This is MACHINE-VERIFIED corroboration of Theorem 6, not part of its
proof.

## 7. Prior art used at the final step

- L. Rédei, *Natürliche Basen des Kreisteilungskörpers*, Abhandlungen aus
  dem Mathematischen Seminar der Universität Hamburg **23** (1959), 180--200,
  and W. Bosma, *Canonical Bases for Cyclotomic Fields*, AAECC **1** (1990),
  125--134, provide classical context for the primitive-root basis and its
  linear relations.
- L. De Carli, M. Laporta, *Divisibility criteria and coefficient formulas
  for cyclotomic polynomials*, Ramanujan Journal **70** (2026), Article 44,
  <https://doi.org/10.1007/s11139-026-01421-6>, gives a general
  necessary-and-sufficient coefficient criterion for cyclotomic divisibility.
  It does not specialize to or classify the prime-prefix polynomial here.
- G. Kiss, I. Łaba, M. Marshall, G. Somlai, *Lower bounds for mask
  polynomials with many cyclotomic divisors*, Advances in Mathematics **494**
  (2026), 110932, <https://doi.org/10.1016/j.aim.2026.110932>, places these
  questions in the de Bruijn--Rédei--Schoenberg fiber/mask-polynomial
  framework.  Again, it contains no prime-prefix classification.
- L. Hajdu, N. Saradha, *On a problem of Recaman and its generalization*,
  Journal of Number Theory **131** (2011), 18--24,
  <https://doi.org/10.1016/j.jnt.2010.07.002>, gives the original prime
  $P$-integer classification.  It is relevant context but is no longer
  needed as a separate proof input here.
- L. Hajdu, N. Saradha, *On generalizations of problems of Recaman and
  Pomerance*, Journal of Number Theory **162** (2016), 552--563,
  <https://doi.org/10.1016/j.jnt.2015.10.006>.  Theorem 2.3 restricts primes
  admitting a sufficiently low complete prime residue system to
  $\{2,3,7,11\}$; our bound $p_{P+2}\le p_{P+\pi(P)-1}$ lies inside its stated
  range.

No indexed source found in the accompanying prior-art search states the
prime-prefix classification of Theorem 6.  The claim of novelty should remain
qualified until expert review; the cyclotomic-basis and complete-residue
ingredients themselves are established prior art.

> **PRIOR-ART SWEEP 2026-08-14 — flag reviewed: this obligation was ALREADY
> SERVICED by the note itself and needs no reopening.** Unlike the other flags
> in today's corpus-wide sweep, this one records a search that *was* run, names
> the two nearest located sources with volume, page and DOI (J. Number Theory
> **131** (2011) 18–24; Hajdu–Saradha, J. Number Theory **162** (2016) 552–563,
> Thm 2.3), states which ingredient each supplies, and correctly keeps the
> novelty claim qualified on a null. No new query was added today, so the
> status is unchanged rather than extended, and the hedge above should be left
> exactly as it stands. Recorded only so the sweep's count is complete.
> Attribution status only.
