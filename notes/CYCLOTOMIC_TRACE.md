# Relative trace eliminates every non-squarefree cyclotomic factor

This note closes the machine-only open lemma in `RIGIDITY_FRONTIER.md` §3.3.
The proof is shorter and stronger than the lattice computation: a relative
trace isolates the one ramified prime whose square divides the modulus.

Let

$$F_X(x)=\sum_{q\le X\atop q\ {m prime}}x^{q-2},$$

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

$$\sigma_j(\zeta_m)=\zeta_m^{,1+jf},\qquad 0\le j<p.$$

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

$$\sum_{q\le X\atop q\ {m prime}}\zeta_m^q=0.\tag{1.2}$$

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

$$\sum_{j=0}^{r-1}\zeta_m^{,r+j(m/r)}=0$$

has initial term $\zeta_m^r$.  For $j\ne0$, squarefreeness implies that
$r+j(m/r)$ is coprime to $r$ and to every other prime dividing $m$; these are
exactly the unit classes congruent to $r$ modulo $m/r$. $\square$

Let $P\le X$ be the last prime cutoff and, for a unit class $c\bmod m$, let
$n_c(X)$ count primes $q\le X$, $q\nmid m$, with $q\equiv c\pmod m$.

> **Corollary 3 (forced class vector).** If $m$ is squarefree and
> $\Phi_m\mid F_X$, then every prime divisor of $m$ is at most $X$, and
> $$n_c(X)=\#\{r\mid m:r\text{ prime and }c\equiv r\pmod{m/r}\}.
> \tag{2.2}$$
> Consequently
> $$\boxed{\ \pi(X)=\sum_{r\mid m\atop r\ {m prime}}r.\ }\tag{2.3}$$

*Proof.* If some prime $r\mid m$ exceeds $X$, then
$\varphi(m)\ge r-1>\deg F_X$, so no divisibility is possible.  Otherwise
multiply the tie by $\zeta_m^2$, expand every ramified $\zeta_m^r$ using
(2.1), and compare coefficients in the primitive-root basis. This gives
(2.2).  Each $r$ contributes to exactly $r-1$ unit classes. Thus the number
of unramified primes is $\sum_{r\mid m}(r-1)$; adding the $\omega(m)$ ramified
primes yields (2.3). $\square$

Equation (2.2), not random-walk recurrence, is the exact remaining problem.
For each fixed squarefree $m$ it specifies one finite vector of prime counts,
so ties can occur on at most one cutoff interval.  Equation (2.3) is a cheap
scalar filter before the class-by-class test.

If the cutoff is the $k$th prime $p_k$, (2.3) becomes the finite partition
condition

$$k=\sum_{r\mid m\atop r\ {m prime}}r,
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
\bigoplus_{j=0}^{p-1}\zeta_{p^e}^{,j}K_{e-1}.$$

For $1\le j<p$, every vector in
$\zeta_{p^e}^{,j}K_{e-1}$ is spanned by powers whose exponent is not divisible
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

## 4. New frontier

The global cyclotomic conjecture is now:

> Apart from $F_3=\Phi_2$ and $\Phi_6\mid F_{11}$, no squarefree modulus $m$
> satisfies the forced class vector (2.2) at a prime cutoff.

The non-squarefree half is a theorem with no computation.  A future attack on
the squarefree half should combine the scalar partition
$\pi(X)=\sum_{r\mid m}r$, the degree condition $\varphi(m)\le\deg F_X$, and
the requirement that the first few primes realize every prescribed residue
class in (2.2).
