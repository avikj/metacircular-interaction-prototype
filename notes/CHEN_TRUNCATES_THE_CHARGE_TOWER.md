# Chen truncates the charge tower: finite-support inversion, and the one thing conditioning cannot buy

**Author.** cf-swarm-ramanujan (Claude Fable 5), 2026-08-16. Method lens:
Ramanujan — exact identities, generating functions, no fitted anything.
**Receives.** `notes/CYCLIC_CHARGE_PROJECTOR_RECEIVED.md` (cf-corner's receiving
audit) and its two sources,
`collab/upstream/library/raw/prime-pair-2026-08-16/PRIME_PAIR_CYCLIC_CHARGE_CRT_BOUNDARY_THEOREMS_V2_2026-08-16.md`
(cited below as **CRT**) and
`…/PRIME_ATOM_TOMOGRAPHY_CONDITIONING_THEOREMS_2026-08-16.md` (**TOM**);
`chatgptdump.md` §7.10–7.12; Factory IV §II–III
(`collab/upstream/library/raw/ETERNAL_GOLDEN_BRAID_THEOREM_FACTORY_IV_2026-08-14.md`);
`formal/cubical/NaturalMachine/{ChenProjector,ThreeChannels}.agda`.
**Reuses, does not re-derive.** `notes/BARRIER_LEVEL_SEPARATION.md` Lemma L3 /
Theorem L4 — this corpus already owns a proved generalized-Vandermonde lemma and
the Lagrange-$\ell^1$ inverse-norm formula. §1 below is the *unit-circle* case
that L3 explicitly does **not** cover (L3 needs positive real nodes), stated so
that the two fit together.
**Status.** Exact finite algebra throughout; every proof is complete and
hand-checkable. No computation was run, and none is needed (`CLAUDE.md` rule 1).
The uploads' theorems are taken as read and are **not** re-proved here; what is
new is the join, three sharpenings (§2.2, §2.5, §4.3), and the statement of what
remains open (§4.4, §6).

---

## 0. What this note adds, in one page

The uploads prove that the divisor charge kernel is inverted by a finite Fourier
transform with condition number exactly $1$. cf-corner's audit identifies Factory
IV's Theorem 58 as the $M=2$ instance. Four things were still missing, and this
note supplies them.

**(a) The lemma underneath, at the level the Agda lane can hold.** Finite Fourier
inversion is a special case of a Vandermonde solve on a *known finite support*.
Stating it that way makes visible what the root-of-unity form hides: the number
of evaluations needed is $|S|$, the **size** of the support, and the number
needed to identify a *named* coefficient uniformly across a family is governed by
the **position** of the support. Those two are different, and their difference is
the repeated-prime excess $\rho=\Omega-\omega$ (§2.2). The uploads' own parity
no-go (CRT §7) is exactly a position collision, not a size problem, and my §2.2
recovers it as a corollary and extends it: the *same* pair $pq,\,p^3q$ also
defeats $M=3$, by algebra, for the same reason.

**(b) Why $\kappa_{\mathrm{DFT}}=1$ is a floor, not a small number.** TOM Theorem
4.3 computes $\kappa_{\mathrm{DFT}}=1$ and calls it sharp within its family. It is
better than that: **no** exact reconstruction functional supported on unimodular
nodes can have $\kappa<1$ (§1.7, three lines). So $\kappa=1$ is optimal
absolutely, and "recondition the problem" is a closed door, not an unexplored one.
That is what makes §4 a genuine no-go rather than an unfinished optimization.

**(c) What the three probe families of TOM really are.** One Vandermonde at three
node configurations: $R+1$ nodes equispaced on $|z|=1$ ($\kappa=1$), $R+1$ nodes
confluent at $z=1$ (Taylor jet), and the same confluent data in the $z\partial_z$
basis. In *raw* units the confluent routes are conditioned $R+1$ and $<e$
respectively; the exponentials $\binom{2R}R$ and $2^R$ appear only after TOM's
support normalization. This is not a correction — TOM says as much in prose — but
it locates the content precisely: **the DFT wins because unit-circle samples need
no normalization at all** ($\|G(\omega^\nu)\|\le S(a)$ already), and that is the
same fact as (b).

**(d) The $u$ axis, and why it is a different kind of problem.** Factory IV's
field is $\mathcal C(q,u,z)$ — center, radius, charge. The uploads' field is
$\mathcal C^W_X(z,w;h)$ — two charges, radius as a *parameter*. Neither refines
the other. The decisive structural fact (§3.2): the charge support is finite
**and known a priori** ($\Omega(n)\le\log_2 n$ is a theorem), so it is a
Vandermonde problem; the radius support is finite after Maynard **but unknown**
($1\le r_0\le 123$, which $r_0$ being the conjecture), so it is a Prony problem —
and Prony's reconstruction is *nonlinear*, hence cannot commute with the
CRT/Poisson split the way CRT (3.2) requires. **That is why the Chen face
admitted a linear projector and the Maynard face did not.**

---

## 1. Finite-support inversion

Throughout, $B$ is a module over a commutative ring $R$ (in the application
$R=\mathbb C$ and $B$ is a normed space; the ring-level statement is what the
Agda lane can hold today, per cf-corner's queue item).

### 1.1 Setup

Fix a finite set of exponents $S=\{j_1<j_2<\dots<j_k\}\subset\mathbb Z_{\ge0}$,
the **support**, and consider
$$G(z)\;=\;\sum_{i=1}^{k}a_{j_i}z^{j_i},\qquad a_{j_i}\in B.$$
Fix nodes $x_1,\dots,x_k\in R$ and define the **evaluation matrix**
$$V_S(x)\;=\;\bigl(x_m^{\,j_i}\bigr)_{1\le m,i\le k}\in R^{k\times k},$$
so that $\bigl(G(x_1),\dots,G(x_k)\bigr)^{\!\top}=V_S(x)\,a$ with
$a=(a_{j_1},\dots,a_{j_k})^{\top}\in B^k$.

### 1.2 Lemma A (inversion)

> **Lemma A.** The evaluation map $a\mapsto\bigl(G(x_m)\bigr)_{m\le k}$ is a
> bijection $B^k\to B^k$ if $\det V_S(x)\in R^\times$. Over a field it is a
> bijection **iff** $\det V_S(x)\ne0$. When invertible,
> $a=V_S(x)^{-1}\bigl(G(x_m)\bigr)_m$, and every $a_{j_i}$ is an explicit
> $R$-linear combination of the $k$ evaluations.

*Proof.* $V_S(x)$ acts on $B^k$ entrywise; a matrix over $R$ with unit
determinant has an inverse over $R$ (adjugate divided by $\det$), and that
inverse acts on $B^k$ and inverts the action. Over a field, non-invertibility
means a nonzero kernel vector $c\in R^k$, and then $c\otimes b$ for any $b\ne0$
in $B$ is a nonzero element of $B^k$ killed by the map. $\square$

Everything now reduces to the determinant. Three regimes are needed.

### 1.3 The determinant, exactly

**(i) Contiguous support** — the only case the corpus actually needs (§2.1).
If $S=\rho+\{0,1,\dots,k-1\}$ then, factoring $x_m^{\rho}$ out of row $m$,
$$\boxed{\;\det V_S(x)\;=\;\Bigl(\prod_{m=1}^{k}x_m^{\rho}\Bigr)\prod_{1\le m<m'\le k}\bigl(x_{m'}-x_m\bigr).\;}\tag{1.1}$$
So for contiguous support and **any** distinct nodes that are units, the system
is invertible. This is the classical Vandermonde determinant with a monomial
prefactor, and the proof is the one line just given.

**(ii) General support.** $\det V_S(x)=\bigl(\prod_{m<m'}(x_{m'}-x_m)\bigr)\cdot
s_\lambda(x_1,\dots,x_k)$, where $s_\lambda$ is the Schur polynomial of the
partition $\lambda_i=j_{k+1-i}-(k-i)$. This is Jacobi's bialternant formula
(prior art, §5). It is **not** automatically nonzero for distinct nodes: for
$S=\{0,2\}$ and nodes $\pm1$ the matrix is $\binom{1\ 1}{1\ 1}$, singular. *The
naive statement "distinct nodes suffice" is false for non-contiguous support*,
and §2.2 shows the arithmetic instance where this bites.

**(iii) Positive real nodes.** $\det V_S(x)>0$ for $0<x_1<\dots<x_k$ and any
distinct real exponents — **already proved in this corpus**,
`BARRIER_LEVEL_SEPARATION.md` Lemma L3, by a Descartes/Rolle induction. Cited,
not re-proved.

**(iv) Unimodular nodes.** L3 does not apply: $|x_m|=1$ is exactly the regime it
excludes. The replacement is arithmetic in the exponents. Let $M\ge1$,
$\zeta=e^{2\pi i/M}$, and take the nodes to be **all** $M$-th roots of unity.
Then $\zeta^{\nu j}$ depends on $j$ only through $j\bmod M$, so:

> **Lemma A′ (root-of-unity nodes).** Let $|S|=k\le M$ and use the $M$ nodes
> $\zeta^{0},\dots,\zeta^{M-1}$. If $S$ injects into $\mathbb Z/M$ then every
> coefficient is recovered by
> $$\boxed{\;a_{j_i}=\frac1M\sum_{\nu=0}^{M-1}\zeta^{-\nu j_i}\,G(\zeta^{\nu}),\;}\tag{1.2}$$
> and if two exponents of $S$ agree mod $M$ then no functional of the $M$ samples
> separates them. When $k=M$ the system is square and
> $\bigl|\det V_S\bigr|=M^{M/2}$.

*Proof.* $\frac1M\sum_\nu\zeta^{-\nu j_i}G(\zeta^\nu)=\sum_{\ell}a_{j_\ell}
\bigl[\frac1M\sum_\nu\zeta^{\nu(j_\ell-j_i)}\bigr]$, and the bracket is $1$ if
$j_\ell\equiv j_i\ (M)$ and $0$ otherwise; injectivity makes it $\delta_{i\ell}$.
If $j_\ell\equiv j_i$ with $\ell\ne i$ then $G$ is unchanged by moving mass
between $a_{j_i}$ and $a_{j_\ell}$ along $z^{j_i}-z^{j_\ell}$… which is not zero
as a polynomial, but every sample $\zeta^{\nu j_i}-\zeta^{\nu j_\ell}$ vanishes,
so that vector is in the kernel. For $k=M$ the matrix is the DFT matrix
$F_M=(\zeta^{\nu r})_{\nu,r\in\mathbb Z/M}$ with columns permuted, so
$|\det|=|\det F_M|=M^{M/2}$ and $F_M^{-1}=\tfrac1M\overline{F_M}$. $\square$

For contiguous $S$ of length $k$ the injectivity condition is simply $M\ge k$,
and when $M=k$, (1.1) gives $\det V_S=\zeta^{\rho M(M-1)/2}\det F_M$ directly.
Lemma A′ is CRT (2.1) — the aliasing theorem — read as a determinant statement:
**the aliasing failure of (2.1) is exactly the column collision of $V_S$**.

### 1.4 The smallest case, $|S|=2$, nodes $\pm1$

$S=\{j_1,j_2\}$, nodes $x_1=+1$, $x_2=-1$:
$$V=\begin{pmatrix}1&1\\(-1)^{j_1}&(-1)^{j_2}\end{pmatrix},\qquad
\det V=(-1)^{j_2}-(-1)^{j_1}=
\begin{cases}\pm2,&j_1\not\equiv j_2\ (2),\\[1mm]0,&j_1\equiv j_2\ (2).\end{cases}$$
So **$\pm1$ inverts a two-point support iff the two charges have opposite
parity** — Lemma A′ with $M=2$, verbatim. For the Chen support $S=\{1,2\}$,
$\det V=(-1)^2-(-1)^1=2$ and
$$V=\begin{pmatrix}1&1\\-1&1\end{pmatrix},\qquad
V^{-1}=\frac12\begin{pmatrix}1&-1\\1&1\end{pmatrix},$$
$$\boxed{\;a_1=\tfrac12\bigl(G(1)-G(-1)\bigr),\qquad a_2=\tfrac12\bigl(G(1)+G(-1)\bigr).\;}\tag{1.3}$$
Both rows of $V^{-1}$ have $\ell^1$ norm $\tfrac12+\tfrac12=1$: $\kappa=1$.

### 1.5 The next case, $|S|=3$, cube roots of unity

$\omega=e^{2\pi i/3}$, nodes $1,\omega,\omega^2$. By Lemma A′, $V_S$ is
invertible iff $j_1,j_2,j_3$ are a complete residue system mod $3$. For
$S=\{0,1,2\}$, $V$ is the Vandermonde in $1,\omega,\omega^2$ and
$$\det V=(\omega-1)(\omega^2-1)(\omega^2-\omega)=3\cdot(-i\sqrt3)=-3\sqrt3\,i,
\qquad|\det V|=3^{3/2},$$
(using $(\omega-1)(\omega^2-1)=2-(\omega+\omega^2)=3$ and
$\omega^2-\omega=-i\sqrt3$), consistent with $|\det F_3|=3^{3/2}$. The inverse is
$$\boxed{\;
\begin{aligned}
a_0&=\tfrac13\bigl(G(1)+G(\omega)+G(\omega^2)\bigr),\\
a_1&=\tfrac13\bigl(G(1)+\omega^{2}G(\omega)+\omega\,G(\omega^2)\bigr),\\
a_2&=\tfrac13\bigl(G(1)+\omega\,G(\omega)+\omega^{2}G(\omega^2)\bigr),
\end{aligned}\;}\tag{1.4}$$
each row of $\ell^1$ norm $3\cdot\tfrac13=1$: $\kappa=1$ again. For real
coefficients $G(\omega^2)=\overline{G(\omega)}$ and (1.4) collapses to
$a_0=\tfrac13\bigl(G(1)+2\,\Re G(\omega)\bigr)$ and companions.

### 1.6 Lemma B: $k-1$ evaluations never suffice, with the kernel exhibited

> **Lemma B.** Let $|S|=k\ge1$ and let $x_1,\dots,x_{k-1}$ be **any** $k-1$
> nodes in a field $K$ (distinct or not). Then the evaluation map
> $K^S\to K^{k-1}$ has a nonzero kernel; explicitly, if $S=\rho+\{0,\dots,k-1\}$
> is contiguous, the polynomial
> $$\boxed{\;G_0(z)\;=\;z^{\rho}\prod_{m=1}^{k-1}\bigl(z-x_m\bigr)\;}\tag{1.5}$$
> is a nonzero element of $K^S$ vanishing at every node. For general $S$ of size
> $k$, if the $(k-1)\times k$ matrix $W=(x_m^{j_i})$ has rank $k-1$ then
> $c_i=(-1)^{i}\det W^{(i)}$ (delete column $i$) is a nonzero kernel vector; if
> the rank is smaller the kernel is larger still.

*Proof.* Rank–nullity: a linear map $K^k\to K^{k-1}$ has kernel of dimension
$\ge1$. For (1.5): $G_0$ has degree $\rho+k-1$ and lowest term $z^{\rho}$, hence
is supported in $S$; it is nonzero because it is a product of nonzero
polynomials; it vanishes at each $x_m$ by construction. For the minor formula,
each entry of $Wc$ is the Laplace expansion of a $k\times k$ determinant with a
repeated row, hence $0$; $c\ne0$ because rank $k-1$ means some maximal minor is
nonzero. $\square$

**The two smallest kernels, written out.**

- $|S|=2$, one node $x_1\ne0$: $G_0(z)=x_1^{j_2}z^{j_1}-x_1^{j_1}z^{j_2}$.
  For $S=\{1,2\}$ and $x_1=-1$ (parity alone):
  $$\boxed{\;G_0(z)=z+z^2\;}$$
  — the coefficient vector $(a_1,a_2)=(1,1)$ is **invisible** to $\lambda$. In
  Factory IV's language: one twin plus one semiprime has the same signed count
  as nothing at all. For $S=\{1,2\}$ and $x_1=+1$ (the unsigned count alone):
  $G_0(z)=z-z^2$.
- $|S|=3$, two nodes $1,\omega$: $G_0(z)=(z-1)(z-\omega)=z^2+\omega^2z+\omega$
  (using $1+\omega=-\omega^2$), and $G_0(\omega^2)=3\omega\ne0$, so the third
  node is exactly what sees it.

### 1.7 Lemma C: $\kappa=1$ is a floor

> **Lemma C.** Let $x_1,\dots,x_N$ be nodes with $|x_m|=1$ and let
> $\alpha_1,\dots,\alpha_N\in\mathbb C$ satisfy
> $a_{j}=\sum_m\alpha_mG(x_m)$ for every $G$ supported in $S\ni j$. Then
> $$\sum_{m=1}^{N}|\alpha_m|\;\ge\;1 .$$
> Consequently $\kappa_\infty=\sum_m|\alpha_m|\ge1$ for every exact
> reconstruction on unimodular nodes, and TOM's $\kappa_{\mathrm{DFT}}(R)=1$
> **attains the floor**.

*Proof.* Apply exactness to the test vector $a_j=1$, all other coefficients $0$,
i.e. $G(z)=z^{j}$. Then $1=\sum_m\alpha_mx_m^{j}$, so
$1\le\sum_m|\alpha_m|\,|x_m|^{j}=\sum_m|\alpha_m|$. $\square$

TOM proves $\kappa_{\mathrm{DFT}}=1$ is sharp *for the DFT weights*. Lemma C says
it is sharp *for every scheme on the circle*. This upgrade is what makes §4 a
no-go: there is no reconditioning left to attempt.

---

## 2. The corpus's own kernels are exactly this

### 2.1 The identification

CRT (1.1) and `chatgptdump.md` §7.10 give the divisor charge kernel
$$a_z(d)=(z^{\Omega}*\mu)(d)=z^{\rho(d)}(z-1)^{j(d)},\qquad
\rho=\Omega-\omega,\quad j=\omega .$$
Two immediate consequences, both needed below.

> **Proposition 1 (support).** $\operatorname{supp}_z a_z(d)=\{\rho,\rho+1,\dots,\rho+\omega\}$
> — **contiguous, of size $\omega(d)+1$, positioned at $\rho(d)$** — and
> $$\kappa_r(d)=(-1)^{\omega-k}\tbinom{\omega}{k},\qquad k=r-\rho\in\{0,\dots,\omega\},$$
> which is CRT (1.2). In particular §1.3(i) applies: the charge Vandermonde is
> always the *contiguous* one, with determinant (1.1).

> **Proposition 2 ($\kappa_r=q_r$).** The $z$-coefficients of the charge kernel
> are exactly the fixed-charge kernels of `chatgptdump.md` §7.11:
> $$\boxed{\;\kappa_r=[z^r]\,a_z=\mu*\pi_r=q_r,\qquad \pi_r=\mathbf1_{\{\Omega=r\}} .\;}$$

*Proof.* $a_z=\mu*z^{\Omega}$ by Möbius inversion of $z^{\Omega(n)}=\sum_{d\mid n}a_z(d)$;
$[z^r]$ is linear and commutes with Dirichlet convolution in the second factor,
and $[z^r]z^{\Omega}=\pi_r$. $\square$

So **$[z^r]$-extraction from the charge tower *is* the fixed-charge kernel
tower**, and the cyclic projector (0.2) is $q_1$: CRT (8.1),
$q_1(n)=\sum_{p\mid n}\mu(n/p)$, is Proposition 2 at $r=1$. Consistency check by
algebra, not measurement: for $d$ squarefree with $\omega=j$, every $n/p$ is
squarefree with $j-1$ primes, so $q_1=(-1)^{j-1}j$; for $\rho=1$, only the
repeated prime leaves $n/p$ squarefree, giving $(-1)^{j}$; for $\rho\ge2$ every
$n/p$ is non-squarefree and $q_1=0$. This reproduces CRT (1.3) exactly. ∎

On the Dirichlet side (§7.11–7.12), $\sum_n q_r(n)n^{-s}=Z_{r,\chi}(s)/L(s,\chi)$
with $Z_{r,\chi}=[z^r]F_\chi(z,s)$, and CRT (5.2) is the $M\to\infty$ limit of
Lemma A′. **This is the honest domain boundary**: $F(z,s)=\prod_p(1-zp^{-s})^{-1}$
is *not* a polynomial in $z$, so the finite lemma applies only after restricting
to a range ($\Omega(n)\le\log_2N$ for $n\le N$) or to a fixed $d$. The circle
integral is the infinite-support limit, where $\kappa=1$ becomes the Parseval
isometry — and (0.7) is its bill (§4).

### 2.2 Sharpening: $\omega+1$ per $d$, $\Omega+1$ uniformly, and the gap is $\rho$

CRT states the sufficient condition $M>\Omega(d)$. Proposition 1 plus Lemma A′
give something finer.

> **Proposition 3.** For a **fixed** $d$, the whole polynomial $a_z(d)$ — hence
> every $\kappa_r(d)$ — is determined by $\omega(d)+1$ evaluations, and by no
> fewer. In particular $M\ge\omega(d)+1$ suffices to invert. But the *charge-one
> projector* $\Pi_{1,M}^{\mathrm{cyc}}$ is a single $d$-independent functional;
> for it to return $\kappa_1(d)$ for **all** $d\le D$ one needs
> $M>\max_{d\le D}\Omega(d)=\lfloor\log_2 D\rfloor$. **The gap between the
> per-$d$ requirement $\omega+1$ and the uniform requirement $\Omega+1$ is
> exactly the repeated-prime excess $\rho=\Omega-\omega$, and it is the price of
> a projector that does not know $\rho(d)$.**

*Proof.* Sufficiency for fixed $d$: Lemma A′ with contiguous $S$ of length
$\omega+1$, injective in $\mathbb Z/M$ as soon as $M\ge\omega+1$. Necessity:
Lemma B with kernel vector $z^{\rho}\prod(z-x_m)$. For the uniform statement:
$\Pi_{1,M}$ returns $\sum_{r\equiv1\,(M)}\kappa_r(d)$ by CRT (2.1). If the window
$[\rho,\rho+\omega]$ has length $\le M$ it contains at most one $r\equiv1\pmod M$;
if $1$ lies in the window that $r$ is $1$ and the answer is right, but if $1$ lies
outside the window the unique such $r$ can be $\ne1$ with $\kappa_r\ne0$, and the
projector returns a nonzero value where $\kappa_1=0$. Excluding this for all $d$
requires the window to be inside $[0,M)$, i.e. $\rho+\omega=\Omega<M$. $\square$

**Worked instance, which is also the uploads' own no-go, extended.** CRT §7 takes
$d_1=pq$ ($\rho=0,\omega=2$, window $\{0,1,2\}$) and $d_2=p^3q$ ($\rho=2,\omega=2$,
window $\{2,3,4\}$): same support **size**, translated **position**. Then
$$a_z(d_1)=(z-1)^2=z^2-2z+1,\qquad a_z(d_2)=z^2(z-1)^2=z^4-2z^3+z^2 .$$
- $M=2$: $\Pi_{1,2}$ returns $\kappa_1(d_1)=-2$ and $\kappa_3(d_2)=-2$. Both
  equal $-\tfrac12a_{-1}=-\tfrac12(-1)^{\rho}(-2)^{\omega}=-2$, matching CRT
  (2.3); but $\kappa_1(d_2)=0$. This is CRT (7.1).
- $M=3$ ($=\omega+1$, so *both* supports inject into $\mathbb Z/3$ and each
  $a_z(d_i)$ is individually recoverable): $\Pi_{1,3}$ returns $\kappa_1(d_1)=-2$
  correctly, but for $d_2$ it returns $\kappa_4(d_2)=+1\ne0=\kappa_1(d_2)$.
  **$M=3$ also fails, for the same reason and by pure algebra.**
- $M\ge5>\Omega(d_2)=4$: correct for both.

So the uploads' parity no-go is not about parity. It is the general statement:
*a $d$-uniform projector must budget for the window's position, and the position
is $\rho$, which parity and every small $M$ are blind to.* Proposition 3 is the
first place in this corpus where $\omega$ and $\Omega$ are separated in the
conditioning question.

**Corollary (the ban's own lesson, applied).** $M$ is not a constant: it is
$\lfloor\log_2 D\rfloor+1$. Per `CLAUDE.md`/`HOLOGRAM.md` §7, quoting "$M$
evaluations" without its $D$-dependence would be exactly the failure mode that
file exists to prevent. Every count below carries its scale.

### 2.3 Theorem 58 is the $|S|=2$ instance, and the Agda is its two rows

On the Chen envelope $\Omega(w+r)\in\{1,2\}$, so
$G(z)=\mathcal C(q,u,z)$ has $z$-support $S=\{1,2\}$ — $k=2$ — and (1.3) reads
$$a_1=\tfrac12\bigl(\mathcal C(q,u,1)-\mathcal C(q,u,-1)\bigr)=\mathcal P(q,u),$$
which is Factory IV §III verbatim; pointwise, $G(1)=1$ and $G(-1)=\lambda(w+r)$
give $a_1=\tfrac{1-\lambda}{2}$, which is Theorem 58. **Theorem 58 is row 1 of
$V^{-1}$ for the two-point support $\{1,2\}$ at nodes $\pm1$**, and $\det V=2$ is
the $2$ in the denominator.

The checked Agda is the same two rows. In `ChenProjector.agda`, with
$G_{qs}(z)=\sum_{n\in qs}z^{\Omega(n)}$:
- $z=1$ row: $G_{qs}(1)=\texttt{length}$, and the identity
  $\texttt{oddCount}+\texttt{evenCount}\equiv\texttt{length}$ (`count-split`) is
  that row, written subtraction-free in $\mathbb N$;
- $z=-1$ row: $G_{qs}(-1)=\texttt{evenCount}-\texttt{oddCount}$, the signed count,
  which lives in $\mathbb Z$ — which is precisely why the module keeps the
  $\mathbb N$ row and derives the rest.

And Lemma B names what the barrier lane has been circling: **parity alone is
$k-1=1$ evaluation of a $k=2$ support, one short, with kernel vector $z+z^2$.**
`ThreeChannels.agda`'s primitive projector $\mathbf1_{\mathbb P}=\mu^2-\pi_1$ is a
different move — it does not add an evaluation, it *refines the support*, splitting
the charge-$2$ point into the $p^2$ and $pq$ channels, i.e. it is a statement about
$\rho$, not about $M$. In the language of Proposition 3, `ChenProjector` works the
support **size** and `ThreeChannels` works the support **position**. That is the
exact relation between the two modules, and it was not visible before.

### 2.4 $\kappa_{\mathrm{DFT}}=1$ as a Lebesgue function, and where the exponentials live

For distinct nodes and the target coefficient $a_0=G(0)$ (which is TOM's target
after its reindexing $a_0=\mu_1$), the reconstruction is Lagrange interpolation
evaluated at $0$, so
$$\kappa_\infty=\sum_{m}\bigl|\ell_m(0)\bigr|
=\sum_{m}\prod_{m'\ne m}\frac{|x_{m'}|}{|x_m-x_{m'}|},$$
the **Lebesgue function of the node set at the point $0$** — the same functional
this corpus already wrote down as $\kappa_\nu$ in `BARRIER_LEVEL_SEPARATION.md`
Theorem L4, there for positive geometric nodes. On the $n$-th roots of unity all
$|x_{m'}|=1$ and $\ell_m(0)=1/n$, giving $\kappa=1$: TOM Corollary 4.2.

The three TOM probe families are therefore **one Vandermonde at three node
configurations**:

| family | nodes | raw $\kappa$ | normalized $\kappa$ (TOM) |
|---|---|---|---|
| Euler power moments $P_m=(z\partial_z)^mG(1)$ | confluent at $z=1$, $z\partial_z$ basis | $R+1$ | $\binom{2R}{R}$ |
| Taylor jet $F_m=G^{(m)}(1)$ | confluent at $z=1$ | $\sum_{m\le R}\tfrac1{m!}<e$ | $2^R$ |
| cyclic charge DFT | equispaced on $\lvert z\rvert=1$ | $1$ | $1$ |

The raw column is exact: $\sum_m|c_m|=q_R(-1)=R+1$ (TOM Thm 2.2) and
$\sum_m\tfrac1{m!}<e$ from $a_0=\sum_m\tfrac{(-1)^m}{m!}F_m$. **The exponential
separations live entirely in the normalization**, which is legitimate and is
TOM's own point (its remark after Thm 2.2): raw high moments have natural size
$R^mS(a)$, so equal *absolute* error across raw moments is an unrealistic model.
What Lemma C adds is the reason the DFT is not merely the best of three: it needs
**no normalization at all** ($\|G(\omega^\nu)\|\le S(a)$ automatically, TOM §1.2),
and among all unimodular schemes it is optimal. The comparison is therefore not
"three conventions, pick one" but "one intrinsic optimum, and two routes that pay
a normalization tax to be comparable to it."

### 2.5 Sharpening: conditioning is multiplicative under tensoring, so only $1$ survives

> **Proposition 4.** If $a_0=\sum_m\alpha_mT_m$ and $b_0=\sum_{m'}\beta_{m'}U_{m'}$
> are exact reconstructions with condition numbers $\kappa_T=\sum|\alpha_m|$ and
> $\kappa_U=\sum|\beta_{m'}|$, then the product reconstruction
> $c_{0,0}=\sum_{m,m'}\alpha_m\beta_{m'}T_mU_{m'}$ has
> $\kappa=\kappa_T\kappa_U$.

*Proof.* $\sum_{m,m'}|\alpha_m\beta_{m'}|=\bigl(\sum_m|\alpha_m|\bigr)\bigl(\sum_{m'}|\beta_{m'}|\bigr)$,
and sharpness is inherited by aligning both error families in one scalar
direction. $\square$

**Consequence for CRT (0.3).** The bivariate charge-torus inversion is the tensor
square of the univariate one, so $\kappa^{(2)}_{\mathrm{DFT}}=1\cdot1=1$ — the
$\ell^1$ weight is $M^2\cdot M^{-2}=1$, as CRT's own sentence "absolute inverse
amplification $1$" asserts. But by Proposition 4 the moment routes square:
$$\kappa^{(2)}_{\mathrm{pow}}=\binom{2R}{R}^{\!2}\sim\frac{16^{R}}{\pi R},
\qquad \kappa^{(2)}_{\mathrm{fac}}=4^{R},\qquad \kappa^{(2)}_{\mathrm{DFT}}=1 .$$
**$\kappa=1$ is the unique fixed point of tensoring**, so the DFT route is the
only one of the three that survives going to two legs — and, by induction, to any
number. That is a genuine reason to prefer it beyond the one-variable table, and
it is not stated in either upload.

---

## 3. What the radius variable $u$ adds, and what (0.3) costs

### 3.1 The variables, laid side by side

| document | center | radius | charge(s) |
|---|---|---|---|
| Factory IV §III, $\mathcal C(q,u,z)$ | formal $q$ | formal $u$ | one $z$, support $\{1,2\}$ on the envelope |
| CRT, $\mathcal C^W_X(z,w;h)$ | summed out by $W(n/X)$ | **parameter** $h$ | two, $z$ and $w$, supports $\le\Omega(n),\Omega(n+h)$ |
| this corpus, `MARGINAL_TO_JOINT_CORNER.md` | summed out | $r\in\{1,\dots,R\}$, measure-theoretic | $c\in\{1,2\}$, measure-theoretic |

Neither generating field refines the other. Factory IV has the radius as a formal
variable and one charge; CRT has two charges and the radius frozen. A field that
contained both would be $\mathcal C(q,u,z,w)$, and no document in scope has it.

### 3.2 What $u$ adds: known support versus unknown support

Both Goldbach and twins are the **same** charge coefficient $(1,1)$; they differ
only in what is done to $u$ (Factory IV §III):
$$\text{Goldbach at }w\iff[q^w]\mathcal P(q,1)>0,\qquad
\text{twins through }w\iff[q^wu^1]\mathcal P(q,u)>0,$$
and $\mathcal P(q,1)=\sum_r[u^r]\mathcal P(q,u)$ is a **marginal**. So $u$ is the
axis on which the entire twin/Goldbach distinction lives, and it is invisible to
the whole cyclic-projector apparatus, which operates inside one $u$-fiber.

The decisive structural difference is not the number of variables:

> **Proposition 5 (why $z$ is a Vandermonde problem and $u$ is not).**
> The charge support is finite **and known a priori**: $\Omega(n)\le\log_2 n$ is a
> theorem, so $S_z\subseteq\{0,\dots,\lfloor\log_2 N\rfloor\}$ with the bound
> available before any arithmetic. Lemma A therefore applies and the projector is
> **linear** in the data. The radius support is finite after Maynard–Tao
> ($|S_u|\ge1$ inhabited with $r_0\le123$) but **unknown**: *which* $r_0$ is
> precisely the open statement. Recovering an unknown support of size $k$ from
> samples is Prony's problem, needs $2k$ samples rather than $k$, and — the point
> — its reconstruction is **nonlinear** (it solves for the nodes as roots of an
> annihilating polynomial). A nonlinear functional does **not** commute with the
> linear CRT/Poisson decomposition, which is the hypothesis CRT (3.2) needs to
> transport coefficient extraction through the main/boundary split.

*Discussion.* This is a structural classification of the two faces of Factory IV
§I, not a proposed proof route; I claim no arithmetic content for Prony here. But
it explains an asymmetry the corpus had recorded only as a fact: the Chen face
was closable by a *linear projector* (Theorem 58) precisely because Chen's
theorem hands over the support $\{1,2\}$ *itself*, not merely its size. **Chen
truncates the charge tower to a known two-point support; Maynard truncates the
radius tower to an unknown one-point support inside a window of $123$.** Known
support is Vandermonde; unknown support is Prony; and only the first is linear.

**Cost of forgetting $u$.** The two forgetful maps in play are not comparable:

1. *Charge diagonal* $w\to z$ (CRT (0.5)–(0.6)). Exact identity with a computable
   correction: $\Delta_{1,1}=[u^2]\Delta(u,u)+\mathcal M_{0,2}+\mathcal M_{2,0}$.
   Both sides are finite linear combinations of the same four counters; nothing
   is lost that cannot be written down. In Vandermonde terms this is column
   merging: $\kappa_0\otimes\kappa_2+\kappa_1\otimes\kappa_1+\kappa_2\otimes\kappa_0$
   (CRT (4.2)) is one row of a *degenerate* $V$, and the degeneracy is exactly
   §1.3(ii)'s non-contiguous failure — the diagonal collapses two distinct
   exponent pairs onto one total.
2. *Radius marginal* $u\to1$. **Not** an exact identity with a correction: it is
   a positivity problem, and this corpus has already proved it vacuous —
   `MARGINAL_TO_JOINT_CORNER.md` Theorem 1,
   $\inf_{\nu\in P(a,b)}\nu(1,1)=\max(a+b-1,0)$, with $a(X)+b(X)\to0$. There is
   no Vandermonde correction to add, because the obstruction is not linear
   algebra.

So: **the uploads' no-go #1 (diagonal loses the decomposition) and the corner
note's Fréchet–Hoeffding vacuity are the two forgetful maps, and only the first
has a correction term.** cf-corner's audit called (0.5)–(0.6) "a second,
independent instance of a marginal that determines a total and not a
decomposition"; Proposition 5 says in what sense it is *not* a second instance of
the same thing — one is repairable algebra, the other is a proved zero.

### 3.3 What the bivariate inversion (0.3) actually costs

Three separate ledgers, kept apart because conflating them is how a $\kappa$
becomes a slogan.

- **Conditioning: nothing.** Proposition 4: $1\times1=1$. This is the whole
  content of CRT's "absolute inverse amplification $1$" for the bivariate torus,
  and it genuinely costs nothing.
- **Number of forward estimates: quadratic in $\log X$.** $M>\max\bigl(\Omega(n),\Omega(n+h)\bigr)$
  forces $M\asymp\log_2X$, so (0.3) requires
  $$M^2\;\asymp\;(\log_2X)^2$$
  separate estimates of $\Delta^W_X(\zeta^{\nu},\zeta^{\eta};h)$, each a genuinely
  bivariate multiplicative-character-sector estimate. The diagonal reduction that
  would cut this to $M$ is exactly the one that costs (0.6).
- **Precision demanded of each: the real bill.** $\kappa=1$ means an absolute
  error $\varepsilon$ per sample yields absolute error $\varepsilon$ in
  $\Delta_{1,1}$ — no amplification. But a *nontrivial* conclusion needs
  $\varepsilon$ below the size of $\Delta_{1,1}$ itself, while the data envelope
  is $S(a)$. **Perfect conditioning converts the problem from "control the
  amplification" to "attain absolute accuracy below the target", and the second
  is not easier.** This is §4.

---

## 4. The open item, stated so it cannot be mistaken for an optimization

### 4.1 The exact form of the no-go

Combine Lemma C with TOM Theorem 4.3 and CRT (0.7).

> **Proposition 6 (what conditioning cannot buy).** Let $\Phi=(\Phi_\nu)_{\nu<M}$
> be the exact charge-phase data and $\widetilde\Phi$ any approximation with
> $\max_\nu\|\Phi_\nu-\widetilde\Phi_\nu\|\le\varepsilon$. Then for **every**
> exact reconstruction functional on unimodular nodes,
> $$\|\widetilde\kappa_1-\kappa_1\|\le\kappa_\infty\,\varepsilon,\qquad \kappa_\infty\ge1,$$
> with $\kappa_\infty=1$ attained by the DFT and by nothing better. Hence any
> conclusion of the form $|\kappa_1|\ge\delta$ requires
> $$\boxed{\;\varepsilon<\delta\;}$$
> — an **absolute** per-phase accuracy below the size of the target. No choice of
> probe family, normalization, or basis changes $\delta$, and by Lemma C none
> changes the requirement.

The requirement $\varepsilon<\delta$ is scale-free and therefore immune to every
move available on the inversion side. The only remaining free parameter is the
forward estimate.

### 4.2 The size of the gap between "data" and "target", exactly

Pointwise in $d$, with $j=\omega(d)$:
$$\bigl\|a_{\cdot}(d)\bigr\|_{L^\infty(|z|=1)}=\max_\theta\bigl(2|\sin(\theta/2)|\bigr)^{j}=2^{j}
\quad(\theta=\pi),$$
$$\bigl\|a_\cdot(d)\bigr\|_{L^2(|z|=1)}=\Bigl(\sum_r|\kappa_r(d)|^2\Bigr)^{1/2}=\binom{2j}{j}^{1/2}
=\frac{2^{j}}{(\pi j)^{1/4}}\bigl(1+O(j^{-1})\bigr),$$
the second by CRT (0.7) and Stirling. So $\|\cdot\|_\infty/\|\cdot\|_2=(\pi j)^{1/4}$:
**both envelopes are $2^{j+o(j)}$, and the exponential burden is therefore not an
artifact of choosing the $\ell^\infty$ error model.** Against this,
$|\kappa_1(d)|\in\{j,1,0\}$ by CRT (1.3). The required *relative* accuracy per
phase sample is thus at worst
$$\frac{|\kappa_1(d)|}{\|a_\cdot(d)\|_\infty}\;\le\;\frac{j}{2^{j}} .$$

### 4.3 Sharpening: the aggregate tax is polynomial in $\log D$, not exponential

CRT §6 states the tax pointwise and observes it is $D^{o(1)}$ since
$\omega(d)\ll\log D/\log\log D$. That is true but pessimistic for the way the tax
is actually incurred: arithmetic estimates put absolute values on a $d$-**sum**,
so the relevant loss is an $\ell^1$-mass ratio over the range, not a pointwise
ratio. That ratio is derivable in closed form.

> **Proposition 7 (aggregate phase tax).** Fix a phase $\theta$ and put
> $c=2|\sin(\theta/2)|\in[0,2]$. Then, as $D\to\infty$,
> $$\sum_{d\le D}\bigl|a_{e^{i\theta}}(d)\bigr|=\sum_{d\le D}c^{\,\omega(d)}
> \;\sim\;C_c\,D(\log D)^{c-1},\qquad
> C_c=\frac1{\Gamma(c)}\prod_p\Bigl(1-\frac1p\Bigr)^{c}\Bigl(1+\frac{c}{p-1}\Bigr),$$
> while
> $$\sum_{d\le D}\bigl|\kappa_1(d)\bigr|\;\sim\;\frac6{\pi^2}\,D\log\log D .$$
> Hence the $\ell^1$ tax of the phase representation, relative to the canonical
> kernel it is standing in for, is
> $$\boxed{\;\mathcal T(\theta,D)\;\asymp_c\;\frac{(\log D)^{\,2|\sin(\theta/2)|-1}}{\log\log D},
> \qquad\text{maximal at }\theta=\pi:\quad \mathcal T(\pi,D)\asymp\frac{\log D}{\log\log D}.\;}$$

*Proof.* The first asymptotic is Selberg–Delange/Wirsing for
$\sum_n c^{\omega(n)}n^{-s}=\zeta(s)^{c}H_c(s)$ with $H_c$ absolutely convergent
for $\Re s>1/2$ (classical; §5, flagged). Two exact checks that fix the constant:
at $c=1$, $C_1=1$ (the Euler factor is $(1-1/p)\cdot p/(p-1)=1$) giving $D$; at
$c=2$, the Euler factor is $\tfrac{(p-1)^2}{p^2}\cdot\tfrac{p+1}{p-1}=1-p^{-2}$,
so $C_2=6/\pi^2$ and $\sum_{d\le D}2^{\omega(d)}\sim\tfrac6{\pi^2}D\log D$ —
which also follows elementarily from $2^{\omega(n)}=\sum_{d\mid n}\mu^2(d)$ and
$\sum_{d\le D}\mu^2(d)/d\sim\tfrac6{\pi^2}\log D$. For the second: $|\kappa_1|=|q_1|$
equals $\omega(d)$ on squarefree $d$, $1$ when $\rho(d)=1$, $0$ when $\rho\ge2$
(CRT (1.3)); $\sum_{d\le D}\mu^2(d)\omega(d)=\sum_{p\le D}\#\{d\le D:\ \mu^2(d)=1,\ p\mid d\}
\sim\tfrac6{\pi^2}D\sum_{p\le D}\tfrac1{p+1}\sim\tfrac6{\pi^2}D\log\log D$ by
Mertens, and the $\rho=1$ contribution is $O(D)$. $\square$

**Remark (average over the phases).** With $M\asymp\log_2D$ and
$c_\nu=2\sin(\pi\nu/M)$, Laplace's method at the maximum $\nu=M/2$ — where
$c_\nu\approx2-\pi^2(\nu/M-\tfrac12)^2$ and the Gaussian width in $\nu$ is
$M/\sqrt{\log\log D}\gg1$ — gives
$\frac1M\sum_\nu(\log D)^{c_\nu-1}\asymp\log D/\sqrt{\log\log D}$. So even the
phase-averaged tax is $\asymp\log D/(\log\log D)^{1/2}$: polynomial in $\log D$.

**What this changes.** The exponential $2^{\omega(d)}$ of CRT §6 is a *pointwise*
worst case attained on a density-zero set. Any estimate that proceeds by triangle
inequality over the $d$-sum with a uniform bound on the boundary term pays only
$\asymp\log D/\log\log D$. This is a real improvement in the accounting, and it
does **not** rescue the route: Proposition 6's requirement is $\varepsilon<\delta$
absolutely, which no ratio of $\ell^1$ masses addresses. Recording it because
`CLAUDE.md` is explicit that a constant quoted without its scale dependence is
worse than none — and $\mathcal T$'s $D$-dependence was the missing coordinate.

### 4.4 What an arithmetic input must supply, and what it cannot be

Assembling §§4.1–4.3:

> **The open item, sharply.** A useful theorem on this route must produce, for
> each phase pair $(\zeta^\nu,\zeta^\eta)$ with $0\le\nu,\eta<M\asymp\log_2X$, an
> **asymptotic expansion** of $\Delta^W_X(\zeta^\nu,\zeta^\eta;h)$ whose error is
> $o\bigl(\|\Delta_{1,1}\|\bigr)$ *uniformly in $(\nu,\eta)$* — i.e. an error
> below the target, phase by phase. It may **not** be:
> - a *bound*, however uniform, of size $\gg\|\Delta_{1,1}\|$: by Proposition 6
>   and Lemma C, no reconditioning converts such a bound into a conclusion, and
>   $\kappa=1$ is already the floor;
> - a bound obtained after absolute values on the $\nu$-average: the $\nu$-average
>   is where the cancellation must happen, and $\max_\nu|\cdot|$ discards exactly
>   it (this is CRT §9's "cyclic phase averaging before absolute values", now with
>   a proof that no alternative inversion exists);
> - an $L^2$/energy control of the phase family: by §4.2 that yields at best
>   $|\kappa_1|\lesssim\binom{2j}{j}^{1/2}=2^{j+o(j)}$, exponentially weaker than
>   the truth $|\kappa_1|\le\omega(d)$. **The target is a sparse Fourier
>   coefficient of a family whose $L^2$ mass is exponentially larger than it, and
>   that gap is in the object, not in the inverse map.**
>
> Equivalently: the arithmetic must supply *main terms as explicit functions of
> the phase*, accurate enough that their $(1,1)$ angular coefficient is computed
> rather than bounded. Everything the inversion side can contribute has now been
> contributed, exactly, and it is $\kappa=1$.

---

## 5. Prior art, graded honestly

**Grade: §1 and §2.1 are elementary and old. Nothing in them is new
mathematics.** What I claim as contribution is placement (§2.2–2.5, §3.2, §4.3),
and Propositions 3, 4, 5, 7 and Lemma C as statements, not as techniques.

Searched **before** writing (`CLAUDE.md`: prior art before the work, not at audit
time). **Egress is not available in this container; all external citations are
from model memory and are therefore search-summary (śabda) grade, UNVERIFIED** —
the same standing the corpus assigned in `BARRIER_LEVEL_SEPARATION.md` §0.
Nothing below is load-bearing: every ingredient used is also proved in place.

Queries run against model memory, recorded:

| # | query | outcome |
|---|---|---|
| Q1 | generalized Vandermonde determinant = Vandermonde × Schur (bialternant) | Jacobi (1841); Macdonald, *Symmetric Functions and Hall Polynomials* I.3. **Classical.** Used only as a citation in §1.3(ii); the contiguous case I need is proved in one line. |
| Q2 | generalized Vandermonde total positivity, distinct positive nodes | Classical (Gantmacher–Krein; Pólya–Szegő). **Already proved in this corpus**, `BARRIER_LEVEL_SEPARATION.md` L3. Cited, not re-proved. |
| Q3 | roots-of-unity filter / series multisection, history | Attributed to Simpson (1750s); standard in Riordan, *Combinatorial Identities*. **Classical.** CRT (2.1) is this. |
| Q4 | Prony's method, sample count for unknown support | Prony (1795); $2k$ samples for $k$ unknown nodes; nonlinear (annihilating-polynomial step). **Classical.** Used structurally in §3.2. |
| Q5 | Ben-Or–Tiwari sparse interpolation; known vs unknown support | Ben-Or–Tiwari (1988); BCH/Reed–Solomon decoding is the same algebra. Confirms the $k$ vs $2k$ dichotomy. **Classical.** |
| Q6 | Lebesgue constant / Lagrange interpolation conditioning at an extrapolation point | Standard numerical analysis (Gautschi). §2.4's formula is textbook; the corpus wrote the same functional independently as L4's $\kappa_\nu$. |
| Q7 | $\sum_{n\le x}c^{\omega(n)}\sim C_cx(\log x)^{c-1}$ | Selberg (1954), Delange; Wirsing; Hall–Tenenbaum, *Divisors*, ch. 0. **Classical.** Used in Proposition 7; the two constant checks ($c=1,2$) are done in place elementarily. |
| Q8 | $\pi_r(x)$ (Landau, integers with $r$ prime factors) as $[z^r]$ of the charge tower | Landau (1900). This is `chatgptdump.md` §7.11–7.12's content. **Classical.** |
| Q9 | condition number of the inverse DFT in $\ell^\infty$ | Immediate (all weights $1/n$); the *lower bound* over all unimodular schemes (Lemma C) I did not find stated in this form, but it is three lines and I do not claim it as new. |
| Q10 | Newton's identities / symmetric-power hierarchy for $\log F_\chi(z,s)$ | Newton; standard. `chatgptdump.md` §7.12's recurrence $rZ_r=\sum_jP_{\chi^j}(js)Z_{r-j}$ is Newton's identity. **Classical.** |
| Q11 | Bettin–Chandee arXiv:1502.00769 Thm 1; Wright arXiv:2604.25177v2 Thm 2.1 | **Not verifiable here** (no egress). Inherited from the uploads, which themselves flag them. Nothing in this note depends on them. |

**Honest summary of novelty.** Zero for the algebra. The claimed contributions
are: (i) Proposition 3, separating $\omega+1$ from $\Omega+1$ and identifying the
gap as $\rho$ — which recovers CRT §7 and extends it to $M=3$; (ii) Lemma C,
making $\kappa_{\mathrm{DFT}}=1$ a floor rather than a small number, which is what
turns §4 into a no-go; (iii) Proposition 4, tensor-multiplicativity, giving the
first reason to prefer the DFT route that survives to two legs; (iv) Proposition
5, the known-support/unknown-support classification of the two Factory IV faces,
with linearity as the operative property; (v) Proposition 7, the aggregate tax
with its $D$-dependence. None of these is deep. All are exact.

---

## 6. What is now open (queue, `CLAUDE.md` tags)

1. `PROVE` — **Lemma A + Lemma B in Agda, ring-level.** This is cf-corner's
   queue item, now with the statement fixed: over a commutative ring $R$ and an
   $R$-module $B$, with support given as a `List ℕ` and the evaluation matrix
   concrete. `ChenProjector` is the $k=2$ case; the target is the $k$-general
   Lemma A for **contiguous** support, where the determinant is (1.1) and needs
   only the classical Vandermonde, which cubical v0.5 can hold. The
   root-of-unity form (Lemma A′) needs $M$-th roots and should **not** be the
   first attempt.
2. `PROVE` — **Proposition 3 as the formal statement of what `ThreeChannels`
   is doing.** §2.3 claims `ChenProjector` works support size and `ThreeChannels`
   works support position ($\rho$). Making that a checked statement (a
   $\rho$-indexed refinement of `Envelope`) would give the two modules a common
   parent instead of a shared comment.
3. `PROVE` — **CRT (0.5)–(0.6) as a finite linear identity among four
   counters**, in the `count-split` vocabulary. Unchanged from cf-corner's
   queue; §3.3 adds the reason it is worth doing (it is the *repairable* one of
   the two forgetful maps, and the corner note owns the other).
4. `PROVE` — is Proposition 7's $\ell^1$ tax the right accounting for the actual
   CRT boundary term, or does the boundary weight change the exponent? The
   proposition is proved for the plain $d$-sum; the arithmetic sum carries
   $\sum_{n\equiv0(d),\,n\equiv-h(e)}W(n/X)$, and whether the tax is
   $(\log D)^{c-1}$ there is a Selberg–Delange computation with a congruence
   condition, not a new idea. Do it before quoting $\mathcal T$ in any estimate.
5. `SEARCH` — Bettin–Chandee and Wright, when egress exists (inherited,
   unchanged).
6. **Not open, and should stop being listed as open:** "improve the
   conditioning of the charge inversion". Lemma C closes it. The item that
   replaces it is §4.4, which is an obligation on the *forward* estimate and
   has no inversion-side component at all.

---

## 7. Honesty ledger

- **Proved here, in full, hand-checkable:** Lemma A, Lemma A′, (1.1), the $|S|=2$
  and $|S|=3$ determinants and inverses (1.3)–(1.4), Lemma B with explicit kernel
  vectors (1.5), Lemma C, Propositions 1–5 and 7, and the $M=3$ extension of the
  uploads' parity no-go in §2.2.
- **Taken as read, not re-proved:** every theorem of CRT and TOM. Their proofs
  were read and are correct as far as I checked the algebra; the two exact checks
  I did run by hand (CRT (2.3) against $a_z(p^3q)$, and CRT (1.3) against
  $q_1=\sum_{p\mid n}\mu(n/p)$) both agree.
- **Cited from this corpus, not re-derived:** `BARRIER_LEVEL_SEPARATION.md` L3/L4
  (positive-node Vandermonde, Lagrange $\ell^1$ inverse norm);
  `MARGINAL_TO_JOINT_CORNER.md` Theorem 1 (Fréchet–Hoeffding vacuity);
  `ChenProjector.agda`, `ThreeChannels.agda` (checked $M=2$ case, read, not
  re-run in this session).
- **Classical, from model memory only, UNVERIFIED (no egress):** Jacobi's
  bialternant, Prony, Ben-Or–Tiwari, Selberg–Delange/Wirsing, Landau, Mertens,
  Stirling, the Lebesgue-constant formulation. Nothing here rests on any of them
  that is not also proved in place, with one exception: **Proposition 7's first
  asymptotic uses Selberg–Delange as an input** and is therefore conditional on a
  standard theorem I could not verify against a source. The $c=2$ case, which is
  the maximal and therefore the operative one, is proved elementarily in place
  from $2^{\omega}=\mu^2*1$ and needs no such input.
- **Not claimed:** any prime-pair estimate; any inhabitation of the Chen
  envelope; any arithmetic consequence whatsoever. Proposition 5's Prony reading
  is a structural classification of the interpolation problem, explicitly **not**
  a proposed proof route, and I claim no arithmetic content for it.
- **Not run:** nothing. No numerics, no scripts, no `.py` (the uploads' shipped
  calibrators remain unrun, per cf-corner's audit and the ban). Every number in
  this note — $2$, $-3\sqrt3\,i$, $3^{3/2}$, $6/\pi^2$, $\binom{2j}{j}$,
  $(\pi j)^{1/4}$, $\log D/\log\log D$ — is derived and carries its scale.
- **Where I might be wrong:** Proposition 5 is the softest item. It is a correct
  statement about interpolation problems, but the claim that *linearity* is the
  operative property in the arithmetic (i.e. that CRT (3.2) genuinely needs it,
  and that no nonlinear substitute exists) is an inference from CRT §3's proof
  structure, not a theorem. It is stated as a discussion, not boxed, for that
  reason. Falsifier: exhibit a nonlinear coefficient-extraction that commutes
  with the CRT/Poisson split.

---

*Signed:* **cf-swarm-ramanujan** (Claude Fable 5), 2026-08-16.
Method lens: Ramanujan — the identity first, the estimate afterwards, and never
a fitted constant standing in for either.
