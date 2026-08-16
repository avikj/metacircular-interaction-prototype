# Gauge spectral flow: exact setup, and what §5.5's first theorem can and cannot be

**Author.** cf-swarm-gelfand (Claude Opus 5), 2026-08-16. Method lens: Gelfand
— fix the operator model first, read the invariant off the representation.

**Consumes.** `notes/ATLAS.md` §5.5 (the four kills, the order column, the
rigidity trap, and the proposed first theorem); `notes/GAUGE.md` §F.1 (the
multiplicative gauge torus), Theorem F, Lemma F.2 (no finite conductor);
`notes/KBOUNDARY.md` §4.1 (outerness, the spatial $W_\lambda$);
`notes/WEIL.md` §§1–3 (the normalization of the Weil form, the pole/arch/prime
split, the minus sign on the prime term); `notes/LP_CERT.md` §2 (the rank‑2
hyperbolic pole plane, the arithmetic intersection form $I$, $n_+\le1$);
`notes/KAPPA.md` §4 (the frontier's Gabor compression, the no‑aliasing
sampling identity, the two traces); `notes/OBSERVABLE_CLASSES_ARE_COSETS.md`
(the gauge torus acting on observables; annihilator subgroups).

**Does not touch.** The $2/3$ theorem itself, `BAND.md`'s lossiness budget,
the Lean/Agda lanes, any arithmetic claim.

**No computation was run.** Every matrix below is $2\times2$ or $3\times3$ and
is computed by hand in exact arithmetic, with the characteristic polynomials
displayed. No Python, no floating point, no fitted anything.

---

## 0. Verdict, up front

ATLAS §5.5 proposes: *compute the spectral flow of the frontier's finite Gabor
compression under gauge rotation, and prove it is nonzero exactly when the
charge is infinitely supported.* Setting it up exactly produces three results,
two negative and one positive, and they arrive in this order.

1. **(Theorem W, one line.)** The proposal is **false at every finite level, for
   every invariant, not only for spectral flow.** For any finite window the
   restriction map $\bigoplus_p\mathbb Z/2\to(\mathbb Z/2)^{\{p\le z\}}$ is
   *surjective*, so $\lambda$ agrees on the window with a finitely supported
   charge. No function of the window's data can separate them. This is
   `GAUGE.md` Lemma F.2 reappearing in the order column, and it means the
   theorem must be restated as a limit of a **normalized** flow — a density —
   or not at all.

2. **(Theorem T, the trap made exact.)** The rigidity trap is not a design
   constraint that a cleverer object can meet. On the natural carrier the
   gauge twist multiplies the entry $(m,m')$ by $g(m/m')=g(m)\overline{g(m')}$
   — a **coboundary**, because $g$ is a *character*. Coboundaries are
   conjugations by diagonal unitaries; conjugations preserve the spectrum
   pointwise; the flow is identically zero. The first phase deformation with
   nonzero holonomy is not a character at all but a **2‑cocycle (a
   multiplier)** — and the arithmetic multipliers are exactly the Hilbert
   symbol / Weil index, which §5.5(c) already killed by the product formula.
   **The same product formula that closes kill (c) closes the only algebraic
   escape from kill (a).**

3. **(Positive: the non‑isometry is archimedean, and it is the whole story.)**
   The gauge torus acts on the *finite* places only. The archimedean and pole
   blocks of the Weil form are inert under it. Therefore
   $$Q^g-U_g^{*}QU_g \;=\; (\Pi+\mathcal D)-U_g^{*}(\Pi+\mathcal D)U_g,$$
   supported **entirely on the pole + archimedean kernel**. If the archimedean
   term is deleted the flow vanishes identically. Every unit of spectral flow
   available to this program is carried by the failure of the archimedean
   kernel to commute with the gauge diagonal. That is the same sentence
   `GAUGE.md` §F.3 and Connes–Consani arrive at from the other side, now as an
   exact algebraic statement about a finite matrix.

The hand computations of §3 exhibit all three: at $d=2$ the deformation is
spectrum‑constant (no triangles); at $d=3$ the *non‑gauge* constant‑phase
deformation has characteristic polynomial
$(x-1)^3-3a^2(x-1)+2a^3\cos\theta$ and flow $\pm1$ across an exactly located
crossing $\cos\theta^\*=(1-3a^2)/(2a^3)$; while the *gauge* flip — full flip
and finitely supported flip alike — leaves the characteristic polynomial
**identically unchanged**, $t^3-3a^2t+2a^3$, verified entry by entry.

§4 gives the one derivable, $X$‑indexed statement that survives to the limit:
the **conductor dichotomy** for the twisted density. §5 states the conjecture
with its falsifier; §6 takes ATLAS's own fork seriously.

---

## 1. The finite model

### 1.1 The form, in the corpus's own normalization

Throughout, `WEIL.md` Prop W1: $u=\log x$, $\Phi_g(s)=\int g(u)e^{(s-1/2)u}du$,
$F=g\star\tilde g$, and

$$W(g)\;=\;\underbrace{2\operatorname{Re}\!\bigl[\Phi_g(0)\overline{\Phi_g(1)}\bigr]}_{\mathrm{pole}}
\;-\;\underbrace{\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}\,2\operatorname{Re}F(\log n)}_{\mathrm{prime}}
\;+\;\underbrace{\frac1{2\pi}\int|\Phi_g(\tfrac12+i\tau)|^2D(\tau)\,d\tau}_{\mathrm{arch}},$$

$D(\tau)=\operatorname{Re}\psi(\tfrac14+\tfrac{i\tau}2)-\log\pi$. Note the sign:
**the prime term enters with a minus** (`WEIL.md` W3(4)). Equivalently
(`KAPPA.md` §4(1)), for band‑limited $f,g$,
$W(f,g)=\int \hat f\,\overline{\hat g}\,\nu_X$ with the explicit density
$\nu_X=\mu+\Pi_X+P_X$ (archimedean + pole + primes $n\le X$).

### 1.2 The Weil form has two dual finite compressions

This is the representation‑theoretic fact that organizes everything, and it is
where the ATLAS proposal has a hidden index mismatch.

* **Frequency‑indexed (the frontier's Gabor compression, `KAPPA.md` §4(2)).**
  $f_k(u)=\varphi(u)e^{-i\tau_ku}$, $\tau_k=T+2\pi k/L$, $0\le k<d$,
  $d=\lfloor LT/2\pi\rfloor$; $G_{kl}=W(f_k,f_l)$. Sampling identity
  (Lemma 2.2, no aliasing): $\sum_k\hat\varphi(\tau-\tau_k)\hat\varphi(\tau'-\tau_k)=L\,\Phi(\tau-\tau')$.
  The index set is a set of **frequencies**; the gauge torus does not act on it.
* **Multiplicatively indexed (defined here).** The index set is a finite
  divisor‑closed $S\subset\mathbb N$; the gauge torus acts on it tautologically.

The gauge torus is $G=\operatorname{Hom}(\mathbb Q^\times_{>0},\mathbb T)\cong\mathbb T^{\mathcal P}$
(`GAUGE.md` §F.1) — it acts on the *multiplicative* structure. It therefore acts
on the second compression by definition, and on the first only *through the
symbol* $\nu_X$. **Flag D3 (below) records that the transfer between the two is
not proved here.** The setup is done on the second, which is the only one on
which "gauge rotation" is even defined.

### 1.3 The multiplicatively indexed compression, derived exactly

Fix a real even bump $\psi$ and a finite divisor‑closed $S\subset\mathbb N$,
$|S|=d$. For $c\in\mathbb C^{S}$ put
$$f_c(u)\;=\;\sum_{m\in S}c_m\,\psi(u-\log m).$$
Then $\Phi_{f_c}(s)=\Phi_\psi(s)\sum_m c_m m^{s-1/2}$, so on the critical line
$\Phi_{f_c}(\tfrac12+i\tau)=\Phi_\psi(\tfrac12+i\tau)\sum_m c_m m^{i\tau}$, and
$F=f_c\star\tilde f_c$ satisfies
$F(u)=\sum_{m,m'}c_m\overline{c_{m'}}\,\Psi\bigl(u-\log(m/m')\bigr)$, $\Psi=\psi\star\tilde\psi$.
Substituting into §1.1 term by term:

* **arch.** $\;\sum_{m,m'}c_m\overline{c_{m'}}\;\mathcal D\bigl(\log(m/m')\bigr)$,
  $\displaystyle \mathcal D(x)=\frac1{2\pi}\int|\Phi_\psi(\tfrac12+i\tau)|^2D(\tau)e^{i\tau x}d\tau$.
* **prime.** $\;\sum_{m,m'}c_m\overline{c_{m'}}\;\mathcal P\bigl(\log(m/m')\bigr)$,
  $\displaystyle \mathcal P(x)=\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}\bigl[\Psi(\log n-x)+\Psi(-\log n-x)\bigr]$.
* **pole.** $\;2\operatorname{Re}\bigl[\Phi_\psi(0)\overline{\Phi_\psi(1)}\,
  \langle c,a\rangle\overline{\langle c,b\rangle}\bigr]$ with $a_m=m^{-1/2}$,
  $b_m=m^{1/2}$: a **rank‑$\le2$ Hermitian form with null diagonal**, i.e.
  exactly `LP_CERT.md` §2's hyperbolic plane $F_1^2=F_2^2=0$, $F_1\!\cdot\!F_2=1$,
  inertia $(1,0,1)$.

**Definition 1.1 (the finite model).**
$$\boxed{\;Q_S \;=\; \Pi\;+\;\mathcal D\;-\;\mathcal P\;}$$
a $d\times d$ Hermitian matrix on $\mathbb C^S$: $\Pi$ the rank‑$\le2$ pole
plane, $\mathcal D_{mm'}=\mathcal D(\log(m/m'))$ and
$\mathcal P_{mm'}=\mathcal P(\log(m/m'))$ **multiplicative Toeplitz** (functions
of the ratio alone). This is not a surrogate: it is the Weil form of
`WEIL.md` restricted to the span of $\{\psi(\cdot-\log m)\}_{m\in S}$, computed
exactly.

**Definition 1.2 (sharp limit).** If $\Psi$ is supported in $(-\delta,\delta)$
with $\delta<\log(1+1/\max S)$, then $\mathcal P_{mm'}\ne0$ only when
$m/m'$ or $m'/m$ is a prime power. Call the resulting graph on $S$ —
$m\sim m'$ iff the ratio is a prime power — the **divisor graph** of $S$. The
prime block is supported on the divisor graph; the archimedean block
$\mathcal D$ is supported on the **complete** graph (it is a smooth kernel,
nonzero at generic $\log(m/m')$).

That asymmetry is the whole content of §2.3.

### 1.4 The minimal admissible weight, for the hand computations

For §3 take the flattest weight compatible with the sign structure of §1.1:
$$Q_d(a)\;=\;(1+a)\mathbb 1_d\;-\;a\,J_d ,\qquad
(Q_d)_{mm}=1,\quad (Q_d)_{mm'}=-a\ (m\ne m'),\qquad a>0,$$
$J_d$ the all‑ones matrix. Justification of admissibility, and the exact price:

* diagonal $+1$: the arch + pole mass at $x=0$, normalized to one;
* off‑diagonal $-a$: the prime term's **minus sign**, with $|{\cdot}|$ frozen at
  its value at $x=0$ (the "flat kernel" limit $\mathcal D-\mathcal P\equiv$ const
  off the diagonal);
* $a$ is the ratio (prime coupling)/(archimedean diagonal). It is a
  **parameter**, not a corpus constant, and nothing below quotes a numerical
  value of $a$ as arithmetic.

**Faithful in exactly one respect, which is the respect at issue**: the
deformation theory of §2 depends only on (i) which entries are nonzero and
(ii) whether the deforming phase is a coboundary on the resulting graph.
Neither depends on the weight. Divergences D1–D6 in §7 record everything else.

---

## 2. Both actions of the gauge torus, and the dichotomy

$G=\mathbb T^{\mathcal P}$; $g\in G$ is a unimodular completely multiplicative
function; $\lambda=(-1)^{\Omega}$ is the evaluation at $(-1,-1,\dots)$
(`GAUGE.md` §F.1). Write $U_g=\operatorname{diag}(g(m))_{m\in S}$ — unitary,
and the finite‑window shadow of `KBOUNDARY.md` §4.1's spatial $W_\lambda$.

**Spectral flow convention.** For a continuous path $t\mapsto A_t$ of Hermitian
$d\times d$ matrices with $A_0,A_1$ invertible,
$\operatorname{sf}\{A_t\}$ is the net number of eigenvalues crossing $0$
upward minus downward. If every eigenvalue is constant in $t$, no eigenvalue
crosses and $\operatorname{sf}=0$; and
$\operatorname{sf}\{A_t\}=n_-(A_0)-n_-(A_1)$ when the endpoints are invertible.

### 2.1 Action (a): the isometric / conjugation action

$$\alpha_g:\;Q\longmapsto U_g^{*}\,Q\,U_g .$$
This is the compression of `GAUGE.md`'s $\alpha_g(s_n)=g(n)s_n$: on the span of
$\{\psi(\cdot-\log m)\}$, $\alpha_g$ multiplies the $m$‑th basis vector by
$g(m)$.

> **Theorem 1 (zero flow, isometric action).** Let $(g_t)_{t\in[0,1]}$ be any
> path in $G$ and $Q$ any Hermitian form on $\mathbb C^S$. Then
> $\operatorname{spec}\bigl(U_{g_t}^{*}QU_{g_t}\bigr)=\operatorname{spec}(Q)$
> for every $t$, hence
> $$\operatorname{sf}\bigl\{U_{g_t}^{*}QU_{g_t}\bigr\}\;=\;0 .$$
> Moreover the entire inertia $(n_+,n_0,n_-)$, the trace, every eigenvalue and
> every symmetric function of the spectrum is constant along the path.

*Proof.* $U_{g_t}$ is unitary, so $U_{g_t}^*QU_{g_t}$ is unitarily similar to
$Q$: same characteristic polynomial, same spectrum with multiplicity, for every
$t$ separately. A constant eigenvalue crosses $0$ nowhere (it is either
identically $0$, contributing nothing to a flow between invertible endpoints,
or never $0$). $\square$

This *is* ATLAS §5.5's rigidity trap, and Theorem 1 makes visible that §5.5(b)
— "K‑theory cannot receive it, because the gauge torus is connected" — and the
trap are the **same statement in two categories**: homotopy invariance kills the
K‑class because the torus is connected; spectrum invariance kills the flow
because the action is by unitaries. Connectedness is not needed for Theorem 1;
isometry alone suffices, and isometry is the stronger hypothesis. So the order
column does not escape kill (b) by being non‑homotopy‑invariant: it is killed
one level earlier.

### 2.2 Action (b): the non‑isometric deformation (the only candidate)

The gauge torus acts on the *arithmetic*, i.e. on $\Lambda$. Two inequivalent
formalizations; both must be named, because conclusions do **not** transfer
between them (flag D5).

> **Definition 2.1 ($\beta^{\mathrm{pr}}_g$, the literal off‑diagonal twist).**
> Twist only the prime term, symmetrizing to stay Hermitian:
> $$\beta^{\mathrm{pr}}_g:\;Q_S=\Pi+\mathcal D-\mathcal P\;\longmapsto\;
> Q_S^{g}\;=\;\Pi+\mathcal D-\mathcal P^{g},\qquad
> \mathcal P^{g}_{mm'}\;=\;\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}
> \operatorname{Re}\Bigl[g(n)\bigl(\Psi(\log n-x)+\Psi(-\log n-x)\bigr)\Bigr]_{x=\log(m/m')} .$$
> In the sharp limit of Definition 1.2 this is exactly
> $\mathcal P^{g}_{mm'}=g(m/m')\,\mathcal P_{mm'}$ on the divisor graph:
> *multiply each off‑diagonal entry by the character evaluated at the ratio.*

> **Definition 2.2 ($\beta^{\mathrm{ar}}_g$, the arithmetic twist).** Replace
> the whole density $\nu_X$ by that of the twisted Euler product
> $$L(s,g)\;=\;\prod_p\bigl(1-g(p)p^{-s}\bigr)^{-1},$$
> pole term, archimedean term and all, and re‑compress. Used only in §4–§5.

> **Definition 2.3 (the canonical path).** $g_\theta(n)=e^{i\theta\Omega(n)}$,
> $\theta:0\to\pi$; $g_0=\mathbf 1$, $g_\pi=\lambda$. For a finitely supported
> charge with support $S_0$, $g_\theta(n)=e^{i\theta\Omega_{S_0}(n)}$. Under
> $\beta^{\mathrm{ar}}$ this is the Selberg–Delange family
> $L_\theta(s)=\prod_p(1-e^{i\theta}p^{-s})^{-1}$, interpolating $\zeta(s)$ and
> $\zeta(2s)/\zeta(s)$.

### 2.3 The dichotomy: why (b) collapses onto (a) on the prime block

> **Lemma 2.4 (triangle holonomy).** Let $Q$ be Hermitian on $\mathbb C^S$ and
> let $c:S\times S\to\mathbb R/2\pi\mathbb Z$ be antisymmetric. Put
> $Q^{c}_{mm'}=e^{ic(m,m')}Q_{mm'}$. Then $Q^c=U^*QU$ for a diagonal unitary
> $U=\operatorname{diag}(e^{i a_m})$ **iff** $c$ is a coboundary,
> $c(m,m')=a_{m'}-a_m$, on the support graph of $Q$; equivalently iff the
> holonomy $c(m,m')+c(m',m'')+c(m'',m)$ vanishes around every cycle of that
> graph.
>
> *Proof.* $(U^*QU)_{mm'}=e^{i(a_{m'}-a_m)}Q_{mm'}$; matching phases on every
> edge is the coboundary equation, whose solvability on a connected graph is
> exactly the vanishing of the holonomy of $c$ on a cycle basis. $\square$

> **Theorem 2 (the trap, exact form: characters are coboundaries).** In the
> sharp limit, $\beta^{\mathrm{pr}}_g$ restricted to the prime block is
> conjugation:
> $$\mathcal P^{g}\;=\;U_g^{*}\,\mathcal P\,U_g\qquad\text{for every }g\in G .$$
>
> *Proof.* On an edge, $\mathcal P^g_{mm'}=g(m/m')\mathcal P_{mm'}$, and
> $g$ is a character of $\mathbb Q^\times_{>0}$, so
> $g(m/m')=g(m)\overline{g(m')}$ — the phase is the coboundary of
> $m\mapsto\arg g(m)$, on the nose, on every edge. Apply Lemma 2.4. $\square$

> **Corollary 2.5 (no character can produce holonomy, ever).** The cycles of the
> divisor graph are generated by the commuting squares
> $m\to pm\to pqm\leftarrow qm\leftarrow m$ of the free abelian group on the
> primes. Any phase assignment depending only on the prime labelling an edge
> has holonomy $\theta_p+\theta_q-\theta_p-\theta_q=0$ around every such square.
> Hence **no deformation of the prime block by a character — indeed by any
> prime‑labelled phase — has nonzero spectral flow.** The first deformations
> with nonzero holonomy are genuine **2‑cocycles** $\omega(m,m')$ on
> $\mathbb Q^\times_{>0}$: multipliers, not characters.

> **Corollary 2.6 (and the multiplier route is already closed globally).** The
> arithmetic $\mathbb Z/2$‑valued bimultiplicative multipliers on
> $\mathbb Q^\times$ are the Hilbert symbols $(m,m')_v$, whose associated
> projective representation is the metaplectic one. The product formula
> $\prod_v(m,m')_v=1$ says exactly that the **global** holonomy vanishes. So
> ATLAS §5.5(c)'s kill — "$\gamma_v$ is local, $\prod_v\gamma_v=1$, finite
> conductor, dead on arrival" — is *also* the statement that the only algebraic
> escape from Theorem 1 is unavailable globally. Kill (a) and kill (c) are one
> kill. **What survives is the semilocal object**: at each finite set of places
> the holonomy is nontrivial; it is only the product over all places that
> cancels. (This is the same door `LP_CERT.md` §6 arrives at from
> Connes–Consani–Moscovici's semilocal prolate framework.)

> **Theorem 3 (the surviving non‑isometry is archimedean).** With
> $Q_S=\Pi+\mathcal D-\mathcal P$ and $\beta^{\mathrm{pr}}_g$ as above,
> $$Q_S^{g}\;-\;U_g^{*}Q_SU_g\;=\;\bigl(\Pi+\mathcal D\bigr)\;-\;U_g^{*}\bigl(\Pi+\mathcal D\bigr)U_g .$$
> Consequently:
> 1. if $\Pi=\mathcal D=0$ (prime block alone), $\beta^{\mathrm{pr}}_g$ is a
>    conjugation and $\operatorname{sf}\equiv0$ along every path;
> 2. the entire spectral flow available to the gauge rotation is carried by
>    $[\,U_g,\ \Pi+\mathcal D\,]$ — the failure of the gauge diagonal to commute
>    with the **pole and archimedean** kernels;
> 3. the flow is nonzero only if $g$ fails to be constant on $S$, since
>    $[U_g,\cdot]=0$ for scalar $U_g$.
>
> *Proof.* Subtract, using Theorem 2 for the prime block. $\square$

Theorem 3 is the note's positive content and it is not a metaphor. The gauge
torus is a group of characters of the **finite** places; the archimedean place
carries no gauge charge; therefore the archimedean kernel is the unique
non‑equivariant piece of the Weil form, and *any* order invariant that moves
under gauge rotation moves because of it. This is `GAUGE.md` §F.3's "the extra
input must couple to something outside the neutral sector", made into an
identity between two $d\times d$ matrices, and it agrees with the independent
verdicts of `WEIL.md` §6 and `LP_CERT.md` §4 that the archimedean term is where
the budget is decided.

### 2.4 Why the frequency‑indexed (Gabor) compression is the non‑isometric one

For completeness, the corresponding statement on the frontier's own carrier.
By the no‑aliasing identity, $\sum_k|\hat\varphi(\tau-\tau_k)|^2=L\,\Phi(0)$, so
$$\operatorname{tr}G^{g}\;=\;L\,\Phi(0)\int_{\text{window}}\nu^{g}_X(\tau)\,d\tau .$$
A conjugation preserves the diagonal, hence the trace. So
**$\beta^{\mathrm{ar}}_g$ is a conjugation on the Gabor compression only if it
preserves $\int\nu^g_X$**, i.e. only if the twisted density carries the same
total mass on the window. On the frequency carrier the twist is not implemented
by any diagonal unitary for a further, structural reason: the frequency index
sees $n$ only through $\log n\in\mathbb R$, and the characters of $\mathbb R$
restrict on the primes to $\{n\mapsto n^{ic}\}\cong\mathbb R$, a **dense but
proper, non‑closed** subgroup of $\mathbb T^{\mathcal P}$ (density is Kronecker,
using $\mathbb Q$‑linear independence of $\{\log p\}$). $\lambda$ lies in the
closure and not in the subgroup — which is `GAUGE.md` Lemma F.2 in yet another
guise. §4 turns the trace identity into the one derivable dichotomy.

---

## 3. Exact hand computations: $2\times2$ and $3\times3$

Weight $Q_d(a)$ of §1.4. Write $t=x-1$ throughout.

### 3.1 The deformation being computed

Take the *constant‑phase* deformation — the literal reading of "multiply
off‑diagonal entries by the character", with the phase constant on all
positively oriented pairs:
$$M_d(\theta)_{mm}=1,\qquad M_d(\theta)_{mm'}=-a\,e^{i\theta}\ (m<m'),\qquad
M_d(\theta)_{m'm}=-a\,e^{-i\theta}\ (m<m') .$$
Hermitian for all $\theta$; $M_d(0)=Q_d(a)$; $M_d(\pi)=(1-a)\mathbb 1+aJ$ is
the **full flip of every off‑diagonal entry**. By Lemma 2.4 this deformation is
a conjugation iff the constant antisymmetric cochain $c\equiv\theta$ is a
coboundary on the complete graph $K_d$ — iff $K_d$ has no triangle, i.e. iff
$d\le2$. **So $d=3$ is exactly the first size at which anything can happen.**

### 3.2 $d=2$: spectrum constant, flow zero

$$M_2(\theta)=\begin{pmatrix}1&-ae^{i\theta}\\ -ae^{-i\theta}&1\end{pmatrix},
\qquad
\det\bigl(x\mathbb 1-M_2(\theta)\bigr)=(x-1)^2-a^2 .$$
The phase cancels: $(-ae^{i\theta})(-ae^{-i\theta})=a^2$. Eigenvalues
$x=1\pm a$, **independent of $\theta$**. No crossing, $\operatorname{sf}=0$.
Consistent with Lemma 2.4: $u_1=1,u_2=e^{i\theta}$ gives
$M_2(\theta)=U^*M_2(0)U$.

### 3.3 $d=3$: the characteristic polynomial, exactly

With $b=-ae^{i\theta}$, $\bar b=-ae^{-i\theta}$, $b\bar b=a^2$, $y=1-x$:
$$\det\bigl(M_3(\theta)-x\mathbb 1\bigr)
=\begin{vmatrix} y&b&b\\ \bar b&y&b\\ \bar b&\bar b&y\end{vmatrix}
= y(y^2-a^2)-b(\bar by-a^2)+b(\bar b^2-y\bar b)
= y^3-3a^2y+a^2(b+\bar b),$$
and $b+\bar b=-2a\cos\theta$. Hence, in $t=x-1=-y$,

$$\boxed{\;\chi_{M_3(\theta)}(x)\;=\;\det\bigl(x\mathbb 1-M_3(\theta)\bigr)
\;=\;(x-1)^3-3a^2(x-1)+2a^3\cos\theta\;=\;t^3-3a^2t+2a^3\cos\theta\;}$$

**Exact eigenvalues.** Put $t=2a\cos\omega$; then
$t^3-3a^2t=2a^3(4\cos^3\omega-3\cos\omega)=2a^3\cos3\omega$, so the equation is
$\cos3\omega=-\cos\theta=\cos(\pi-\theta)$ and
$$x_j(\theta)\;=\;1+2a\cos\!\Bigl(\frac{\pi-\theta+2\pi j}{3}\Bigr),\qquad j=0,1,2 .$$
Checks. $\theta=0$: $\omega\in\{\pi/3,\pi,5\pi/3\}$, eigenvalues
$\{1+a,\,1-2a,\,1+a\}$ — correct for $(1+a)\mathbb 1-aJ_3$.
$\theta=\pi$: $\omega\in\{0,2\pi/3,4\pi/3\}$, eigenvalues
$\{1+2a,\,1-a,\,1-a\}$ — correct for $(1-a)\mathbb 1+aJ_3$. Both verify
$t^3-3a^2t\pm2a^3=(t\mp a)^2(t\pm2a)$.

**Branch monotonicity.** As $\theta:0\to\pi$ each $\omega_j$ decreases by
$\pi/3$:
$x_0:1+a\nearrow1+2a$; $x_1:1-2a\nearrow1-a$; $x_2:1+a\searrow1-a$.

**Crossings.** Set $x=0$, i.e. $t=-1$, in the characteristic polynomial:
$$-1+3a^2+2a^3\cos\theta=0\iff \boxed{\;\cos\theta^{\*}=\frac{1-3a^2}{2a^3}\;}$$
A crossing in $[0,\pi]$ exists iff $|1-3a^2|\le2a^3$, and
$$2a^3+3a^2-1=(2a-1)(a+1)^2,\qquad 2a^3-3a^2+1=(a-1)^2(2a+1),$$
both factorizations exact. The second is $\ge0$ for all $a>0$; the first is
$\ge0$ iff $a\ge\tfrac12$. Since $\cos$ is injective on $[0,\pi]$ there is **at
most one** crossing, and:

| regime | $\operatorname{spec}$ at $\theta=0$ | at $\theta=\pi$ | inertia $0\to\pi$ | $\operatorname{sf}$ |
|---|---|---|---|---|
| $0<a<\tfrac12$ | $1{+}a,1{+}a,1{-}2a$ all $>0$ | $1{+}2a,1{-}a,1{-}a$ all $>0$ | $(3,0)\to(3,0)$ | $0$ |
| $\tfrac12<a<1$ | $(2,1)$ | $(3,0)$ | one $\uparrow$ (branch $x_1$) | $+1$ |
| $a>1$ | $(2,1)$ | $(1,2)$ | one $\downarrow$ (branch $x_2$) | $-1$ |

Exact special points: $a=\tfrac12\Rightarrow\cos\theta^\*=1$, $\theta^\*=0$;
$a=1\Rightarrow\cos\theta^\*=-1$, $\theta^\*=\pi$;
$a=1/\sqrt3\Rightarrow\cos\theta^\*=0$, $\theta^\*=\pi/2$, at which the spectrum
is exactly $\{2,1,0\}$ (from $x_j=1+\tfrac2{\sqrt3}\cos(\pi/6+2\pi j/3)$).
$a=\tfrac34\Rightarrow\cos\theta^\*=-\tfrac{22}{27}$.

**So the flow is nonzero exactly when the undeformed form is already indefinite
and the flipped form is definite** — an order phenomenon, computed exactly, with
no fitted anything. And $a=\tfrac12$ is an artifact of the flat weight
(flag D1); it is **not** a corpus constant and must never be quoted as one.

### 3.4 The gauge action at $d=3$: identical characteristic polynomials

Take $S=\{1,2,3\}$ (divisor‑closed), $Q=Q_3(a)$, $\chi_Q(x)=t^3-3a^2t+2a^3$.

**Full flip $\lambda$ on the window.** $\lambda(1)=+1$, $\lambda(2)=\lambda(3)=-1$,
so $U_\lambda=\operatorname{diag}(1,-1,-1)$ and
$$Q^{\lambda}=U_\lambda QU_\lambda=\begin{pmatrix}1&a&a\\ a&1&-a\\ a&-a&1\end{pmatrix}.$$
By hand, $y=1-x$:
$$\det(Q^\lambda-x\mathbb 1)=y(y^2-a^2)-a(ay+a^2)+a(-a^2-ay)=y^3-3a^2y-2a^3,$$
so $\chi_{Q^\lambda}(x)=t^3-3a^2t+2a^3$. **Identical to $\chi_Q$.**

**Finitely supported charge $\varepsilon$: flip at $p=2$ only.**
$\varepsilon(1)=1,\varepsilon(2)=-1,\varepsilon(3)=1$, $U_\varepsilon=\operatorname{diag}(1,-1,1)$,
$$Q^{\varepsilon}=\begin{pmatrix}1&a&-a\\ a&1&a\\ -a&a&1\end{pmatrix},\qquad
\det(Q^\varepsilon-x\mathbb 1)=y(y^2-a^2)-a(ay+a^2)-a(a^2+ay)=y^3-3a^2y-2a^3 .$$
**Identical again.**

**Observe what the gauge flip is not.** $Q^\lambda$ flips the entries
$(1,2)$ and $(1,3)$ but **not** $(2,3)$: the phase on the edge $m\!-\!m'$ is
$\lambda(m)\lambda(m')$, and $\lambda(2)\lambda(3)=+1$. The full flip
$M_3(\pi)$, which *does* flip all three, is therefore **not the action of any
gauge element** — indeed $u_mu_{m'}^{-1}=-1$ for all three pairs forces
$u_2=u_3$ and then $u_2u_3^{-1}=+1\ne-1$. The unique deformation in §3.3 with
nonzero flow is precisely the one outside the gauge group. That is Lemma 2.4
and Theorem 2 exhibited on a $3\times3$ matrix.

### 3.5 The window verdict, and Theorem W

> **Theorem W (window blindness).** Let $S$ be any finite window and $z=\max S$.
> The restriction map $\bigoplus_p\mathbb Z/2\to(\mathbb Z/2)^{\{p\le z\}}$ is
> surjective. Hence for every $g\in G$ there is a **finitely supported**
> $\varepsilon$ (support $\subseteq\{p\le z\}$) with $g|_S=\varepsilon|_S$, so
> $U_g=U_\varepsilon$ and every function whatsoever of the window's data
> agrees on $g$ and $\varepsilon$. In particular $\lambda$ is indistinguishable
> on the window from the finitely supported charge that flips every prime
> $\le z$.
>
> *Proof.* One line, as displayed. $\square$

**Consequence for ATLAS §5.5.** The proposed theorem — "nonzero exactly when the
charge is infinitely supported" — **cannot hold at any finite level**, for
spectral flow or for anything else. "Infinitely supported" has no finite‑window
shadow. This is not a defect of the surrogate: the argument uses only the
surjectivity of a restriction map. It is `GAUGE.md` Lemma F.2 ("no finite
conductor, no finite‑level shadow") transported verbatim into the order column,
and it says the order column inherits kill (c) too.

So §3 answers the assigned question, and the answer is **no**: on the window,
the flow does not distinguish a finitely supported charge from the full flip.
Under (a) both flows are $0$ (Theorem 1). Under (b) both matrices are *equal*
whenever the charges agree on $S$ (Theorem W), and the only deformation of §3.3
with nonzero flow is charge‑independent — it is a single scalar $\theta$, not a
function of $g$.

---

## 4. What survives to the limit: the conductor dichotomy (derivable)

The theorem must therefore be about $z,X\to\infty$ and a **normalized** flow.
Here is the one statement in this circle that is derivable exactly, with its
$X$‑dependence — which `CLAUDE.md` demands and which a measured constant would
have hidden.

> **Theorem A (conductor dichotomy).** Let $g\in G$ with
> $S_0=\{p: g(p)\ne1\}$ finite. Then
> $$L(s,g)=\prod_p\bigl(1-g(p)p^{-s}\bigr)^{-1}=\zeta(s)\cdot E_{S_0}(s),\qquad
> E_{S_0}(s)=\prod_{p\in S_0}\frac{1-p^{-s}}{1-g(p)p^{-s}},$$
> and $E_{S_0}$ is holomorphic and **non‑vanishing on $\operatorname{Re}s>0$**.
> Hence $L(s,g)$ has exactly the divisor of $\zeta$ in the critical strip:
> the same pole at $s=1$, the same zeros, with the same multiplicities.
>
> *Proof.* $|p^{-s}|<1$ for $\operatorname{Re}s>0$, so both $1-p^{-s}$ and
> $1-g(p)p^{-s}$ are nonzero there (their zeros lie on $\operatorname{Re}s=0$);
> the product is finite. $\square$
>
> **Contrast, $g=\lambda$.** $L(s,\lambda)=\prod_p(1+p^{-s})^{-1}=\zeta(2s)/\zeta(s)$:
> in $0<\operatorname{Re}s<1$ its divisor is (zeros of $\zeta(2s)$, i.e.
> $\rho/2$, on $\operatorname{Re}s=\tfrac14$ under RH) minus (zeros of $\zeta$),
> and the pole at $s=1$ has become a **zero**. The change of the zero‑counting
> measure on any window is of **full density**.

> **Corollary A.1 (the trace, with its $X$‑dependence).** By §2.4,
> $\operatorname{tr}G^{g}=L\Phi(0)\int_{\text{window}}\nu^{g}_X$. Writing
> $\nu^g_X-\nu_X$ from the prime side,
> $$\nu^{g}_X(\tau)-\nu_X(\tau)=-2\sum_{p\in S_0}\sum_{k:\,p^k\le X}
> \bigl(\operatorname{Re}[g(p)^k e^{-ik\tau\log p}]-\cos(k\tau\log p)\bigr)\frac{\log p}{p^{k/2}},$$
> which is bounded **uniformly in $X$** by $4\sum_{p\in S_0}\log p/(\sqrt p-1)<\infty$
> for finite $S_0$ — a finite‑conductor perturbation is an $O(1)$ perturbation
> of a symbol whose own scale is $\asymp\ell=\log(T/2\pi)$. Relative size
> $O(1/\ell)$. For $g=\lambda$ the same difference is
> $4\sum_p\sum_{k\ \mathrm{odd},\,p^k\le X}(\log p)p^{-k/2}\cos(k\tau\log p)$,
> whose mean square over the window is $\asymp\sum_{p\le X}(\log p)^2/p\asymp\tfrac12\log^2X
> =\tfrac12\lambda^2\ell^2$ — the **same order as the symbol itself**.

That is the honest scaling statement: **finite conductor $\Rightarrow$ relative
perturbation $O(1/\ell)$; $\lambda\Rightarrow$ relative perturbation $\asymp1$.**
Both exponents are derived, neither is measured, and the corresponding
zero‑counting statement (Theorem A) is exact.

---

## 5. The conjecture, stated precisely, with its falsifier

> **Conjecture GS (normalized spectral‑flow charge detection).** Let
> $\widehat G(\theta)$ be the frontier's Gabor compression (`KAPPA.md` §4(2),
> units $\widehat G=G/(a L^2)$) of the $\beta^{\mathrm{ar}}$‑twisted density
> along the canonical path $g_\theta$ of Definition 2.3, $d=\dim$. Define
> $$\operatorname{sf}(g)\;:=\;\lim_{T\to\infty}\frac1d\,
> \operatorname{sf}\bigl\{\widehat G(\theta)\bigr\}_{\theta\in[0,\pi]} .$$
> Then
> **(i)** $\operatorname{sf}(g)=0$ whenever $\sum_p|1-g(p)|p^{-1/2}<\infty$
> (in particular for every finitely supported charge); and
> **(ii)** $\operatorname{sf}(\lambda)\ne0$.

**Status of each half.**
* (i) is **within reach**: Theorem A gives the exact zero‑divisor statement and
  Corollary A.1 the $O(1/\ell)$ relative bound. The missing step is a
  **spectral‑density bound near $0$** for $\widehat G$: an $O(1/\ell)$ operator
  perturbation moves $o(d)$ eigenvalues across $0$ only if
  $\#\{\text{eigenvalues of }\widehat G\text{ in }[-C/\ell,C/\ell]\}=o(d)$.
  That is a clean, isolated `[PROVE]` item and it is *not* a measurement.
* (ii) is **open, and it is the whole content**. The plausible route is the
  trace/Szegő one of §2.4: $\operatorname{tr}\widehat G(\pi)-\operatorname{tr}\widehat G(0)\asymp N$
  by Theorem A. But a trace change is not a crossing count, and $\nu_X$ is
  $X$‑dependent and unbounded ($\asymp\ell$), so classical Szegő does not apply
  (flag D6). The frontier's own no‑aliasing Lemma 2.2 is the right substitute
  and has not been used here.

> **Falsifier.** $\operatorname{sf}(\lambda)=0$. Concretely: exhibit that the
> crossings along $\theta:0\to\pi$ cancel in signed count despite the divisor of
> $L_\theta$ changing at full density — equivalently, that
> $n_-(\widehat G(\pi))-n_-(\widehat G(0))=o(d)$.

> **Second falsifier, cheaper and worth running first (as a *proof*, not a
> computation).** Theorem 3 says all the flow is carried by
> $[U_g,\Pi+\mathcal D]$. So: **prove or refute that the archimedean kernel
> $\mathcal D(\log(m/m'))$ commutes with $U_\lambda$ to leading order.** If it
> does, the flow is $o(d)$ and Conjecture GS(ii) is dead by a page of algebra
> rather than by a limit theorem. This is the shortest decisive question in the
> whole setup and it is purely a statement about the kernel
> $\mathcal D(x)=\frac1{2\pi}\int|\Phi_\psi|^2D(\tau)e^{i\tau x}d\tau$ against
> the sign pattern $(-1)^{\Omega(m)}$ — i.e. about correlations of $\lambda$
> with a fixed smooth kernel in $\log(m/m')$. **Warning (flag D7):** that is
> plausibly Chowla‑hard. If it is, the conjecture is not decidable by present
> means and should be labelled so rather than attempted.

---

## 6. ATLAS's fork, taken seriously

§5.5 states the fork: *"A proof separates parity from every boundary‑visible
charge by a non‑homotopy‑invariant index. A disproof means inertia is
charge‑blind too, and then the corpus should stop looking for a receptacle
entirely and accept that the missing input is irreducibly non‑invariant data."*

This note moves the fork's location without deciding it, and it is worth being
exact about how much has been decided.

* **Decided, negatively:** the *finite‑window* form of the proposal (Theorem W).
  Also decided: the gauge action on the prime block cannot produce flow
  (Theorems 1, 2, Corollary 2.5), and the algebraic escape (a multiplier)
  coincides with the metaplectic route §5.5(c) already closed globally
  (Corollary 2.6). So three of §5.5's four kills — averaging, connectedness,
  locality — all reappear in the order column, and the order column does not
  escape them by being order‑theoretic. **§5.5's "the topological column is
  empty, therefore the order column is the only one left" is a valid
  elimination but not evidence that the order column is nonempty.** That
  inference should be corrected in the ATLAS.
* **Not decided:** whether the archimedean commutator $[U_\lambda,\mathcal D]$
  carries a positive‑density flow. This is the entire remaining question and it
  is now stated as one commutator.
* **If the disproof lands** — i.e. if $\operatorname{sf}(\lambda)=0$ — then by
  Theorem 3 the archimedean kernel is charge‑blind, and since Theorems 1–2 make
  every finite place charge‑blind by algebra, **every place is blind**. That is
  a genuine no‑go of a new kind: not "this receptacle vanishes" but "the
  receptacle category is empty", and ATLAS's instruction to stop searching
  would be earned rather than rhetorical. The program's residue would then be
  exactly what §5.5 names: irreducibly non‑invariant data — in this corpus's own
  vocabulary (`OBSERVABLE_CLASSES_ARE_COSETS.md` §4), a **metric** statement
  (W4b: how well a neutral observable approximates a charged one) and never an
  algebraic one, because the algebraic answer is provably two‑valued.
* **A disproof would also retire a recurring hope.** "Build the object so
  $\lambda$ is a non‑isometric deformation" is not a buildable specification
  while $\lambda$ is a *character*: Theorem 2 says characters deform
  isometrically on anything indexed multiplicatively. The specification must be
  rewritten as: **couple $\lambda$ to the archimedean place, or to a multiplier,
  or abandon the receptacle.** Those are the three, and the second is closed
  globally.

---

## 7. Honesty ledger

**PROVED here (by hand, exact arithmetic, displayed):** Theorem 1 (zero flow,
isometric action); Lemma 2.4 (triangle/cycle holonomy criterion); Theorem 2
(characters are coboundaries on the divisor graph); Corollary 2.5 (no
prime‑labelled phase has holonomy); Theorem 3 (the non‑isometry is exactly
$[U_g,\Pi+\mathcal D]$); Theorem W (window blindness); the derivation of
Definition 1.1 from `WEIL.md` Prop W1 term by term; all characteristic
polynomials of §3 — $(x-1)^2-a^2$; $t^3-3a^2t+2a^3\cos\theta$ with eigenvalues
$1+2a\cos((\pi-\theta+2\pi j)/3)$; the crossing equation
$\cos\theta^\*=(1-3a^2)/(2a^3)$ with the exact factorizations
$2a^3+3a^2-1=(2a-1)(a+1)^2$ and $2a^3-3a^2+1=(a-1)^2(2a+1)$; the two gauge‑flip
matrices with identical polynomial $t^3-3a^2t+2a^3$; the non‑realizability of
the full flip as a gauge element at $d\ge3$. Theorem A (Euler factor
holomorphic non‑vanishing on $\operatorname{Re}s>0$; $L(s,\lambda)=\zeta(2s)/\zeta(s)$).

**DERIVED, with scaling, not measured:** Corollary A.1 — finite conductor gives
relative symbol perturbation $O(1/\ell)$, $\lambda$ gives $\asymp1$, with
$\ell=\log(T/2\pi)$ and $X=(T/2\pi)^\lambda$ carried explicitly. Per
`CLAUDE.md` §"a number without its $X$‑dependence is worse than no number",
these are stated as exponents in $\ell$ and never as constants.

**CONJECTURED, with falsifier attached:** Conjecture GS(i) (reducible to one
spectral‑density bound near $0$) and GS(ii) (open).

**CITED, not read (search metadata only, 2026‑08‑16; no full text opened).**
The Selberg–Delange family $\prod_p(1-zp^{-s})^{-1}$, $z^{\Omega(n)}$, is
classical (Landau–Selberg–Delange; standard references surfaced by search).
Spectral flow of Toeplitz families and its identification with a winding
number / index is classical (Gohberg–Krein, and a live modern literature:
arXiv:1803.11101, arXiv:2409.15534, arXiv:2501.15436). The Hilbert symbol as
the multiplier of the metaplectic representation, and its product formula, are
classical (Weil 1964). **None of this is claimed as new**; what is claimed as
new is only the identification of the corpus's rigidity trap with the
character/multiplier distinction (Theorem 2, Corollaries 2.5–2.6) and the
localization of the entire flow on the archimedean commutator (Theorem 3).
A successor should not repeat these searches; a successor **should** search
"gauge twist of the Weil explicit formula by a completely multiplicative
character" and "spectral flow of the explicit‑formula quadratic form", which
this session did not.

**Where the surrogate may diverge from the true Weil form — every flag.**

* **D1 (flat kernel).** §3 replaces the multiplicative‑Toeplitz kernels
  $\mathcal D(\log(m/m'))-\mathcal P(\log(m/m'))$ by a constant $-a$. This
  destroys all $\log$‑ratio dependence and with it the Toeplitz/Szegő/winding
  structure that §5 needs. **Consequence:** the thresholds $a=\tfrac12$, $a=1$,
  $a=1/\sqrt3$ are artifacts of the flat weight and carry no arithmetic. They
  must never be quoted as corpus constants. The *qualitative* conclusions of §3
  (Lemma 2.4, $d=2$ vs $d=3$, gauge flips leave $\chi$ invariant) are
  weight‑independent and survive.
* **D2 (pole block).** §3 replaces the rank‑2 hyperbolic pole plane $\Pi$
  (inertia $(1,0,1)$, `LP_CERT.md` §2) by a positive diagonal. The surrogate
  therefore cannot see $n_+(I)\le1$, the single positive direction that is the
  corpus's actual order invariant. §1.3 keeps $\Pi$ exactly; §3 does not.
* **D3 (index mismatch — the largest).** The frontier's compression is indexed
  by **frequencies**; the gauge torus acts on **integers**. The two
  compressions are dual pieces of the same explicit formula, not the same
  matrix, and no transfer theorem between their spectra is proved here. Every
  §3 conclusion is a conclusion about the multiplicatively indexed model.
  Statements about "the frontier's own Gabor compression" (§2.4, §5) use only
  the trace identity $\operatorname{tr}G=L\Phi(0)\int\nu$, which *is* exact.
* **D4 (sharp limit).** Theorem 2's "$\mathcal P^g_{mm'}=g(m/m')\mathcal P_{mm'}$"
  uses the narrow‑bump limit (Definition 1.2). At finite bump width the entries
  smear across nearby ratios and the coboundary identity holds only up to
  $O(\sup_{|x|>\delta}|\Psi(x)|)$. Since Theorem 2 is a *negative* result the
  smearing can only help the conjecture; but the quantitative version is
  unproved.
* **D5 (two twists).** $\beta^{\mathrm{pr}}$ (twist the prime term only) and
  $\beta^{\mathrm{ar}}$ (replace the density by $L(s,g)$'s) are inequivalent —
  the latter also changes the pole term, and at $g=\lambda$ the pole becomes a
  zero. §2–§3 use $\beta^{\mathrm{pr}}$; §4–§5 use $\beta^{\mathrm{ar}}$.
  Conclusions do not transfer automatically between them. This is a real gap
  and the honest place to attack the setup.
* **D6 (Szegő does not apply).** $\nu_X$ is $X$‑dependent with scale
  $\asymp\ell\to\infty$; the standard Szegő first limit theorem needs a fixed
  $L^\infty$ symbol. Any argument in §5 that passes through "eigenvalue density
  = distribution of the symbol" is heuristic as written.
* **D7 (possible hardness).** The decisive question of §5 —
  does $[U_\lambda,\mathcal D]$ carry positive‑density flow? — is a correlation
  of $\lambda$ against a fixed smooth kernel in $\log(m/m')$ and may be
  Chowla‑hard. If a successor establishes that, the correct action is to
  **label the conjecture undecidable by present means**, not to measure it.
* **D8 (spectral flow and paths).** Spectral flow depends on the path, not only
  on the endpoints, unless the endpoints are invertible and the path class is
  fixed. Definition 2.3 fixes a canonical path; a different path in $G$ from
  $\mathbf 1$ to $\lambda$ could give a different flow. Under action (a) this is
  moot (Theorem 1 kills every path); under (b) it is a genuine ambiguity and
  Conjecture GS is stated *for the canonical path only*.

**NOT CLAIMED.** No theorem toward RH. No claim that the order column is
nonempty. No claim that the frontier's $2/3$ theorem is affected in any way —
nothing here touches it. No claim that Theorem 3 makes the archimedean route
tractable; it makes it *unique*, which is a different and weaker thing.

**Standing‑queue tags.**
* `[PROVE]` **discharged**: the rigidity trap as an exact theorem (Theorems 1–3,
  Corollaries 2.5–2.6); the refutation of the finite‑window form of §5.5's
  proposal (Theorem W); the conductor dichotomy (Theorem A).
* `[PROVE]` **opened, sharp**: the spectral‑density bound
  $\#\{\text{eigenvalues of }\widehat G\text{ in }[-C/\ell,C/\ell]\}=o(d)$,
  which alone gives Conjecture GS(i).
* `[PROVE]` **opened, decisive**: does $[U_\lambda,\Pi+\mathcal D]$ carry
  positive‑density spectral flow? By Theorem 3 this is the whole of GS(ii).
* `[PROVE]` **opened, structural**: build the compression **semilocally** (a
  finite set of places), where by Corollary 2.6 the Hilbert‑symbol multiplier
  has nontrivial holonomy, and ask whether the place‑by‑place flows are the
  local Weil indices summing to zero by the product formula. This is the only
  surviving *algebraic* door, and it lands in the same semilocal framework
  `LP_CERT.md` §6 independently identified as the right next basis.
* `[SEARCH]` opened: the two queries named above under CITED.
* **Correction owed to `notes/ATLAS.md` §5.5**: (i) the proposed first theorem
  is false as literally stated (Theorem W) and must be restated as a normalized
  limit; (ii) "the order column is the only one left" is an elimination, not
  evidence of nonemptiness — kills (a), (b), (c) all recur inside the order
  column; (iii) "build the object so $\lambda$ is a non‑isometric deformation"
  is not satisfiable by any character and must be rewritten as the three‑way
  choice of §6.

---

*Sign: cf-swarm-gelfand, 2026‑08‑16. Gelfand lens: the object was never the
charge; it was the difference between a character and a multiplier, and between
a finite place and the archimedean one. Fix the representation and the
invariant reads itself off.*
