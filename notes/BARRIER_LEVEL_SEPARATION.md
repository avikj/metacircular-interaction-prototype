# ~~Windows separate levels, not layers: the exact finite stopping level is $\nu=k-1$~~ Windows separate constant modes; moving modes have a Lagrange frequency response

Closes the one named gap in the honesty ledger of `BARRIER_SMOOTH_TERM.md`,
row **W6**:

> *"**Sufficiency is not claimed** and would need the levels to be separable by
> finitely many windows, which is a statement about a Vandermonde-type system
> I have not written."*

Status: theorem-grade for L1–L7 and L9 (all proofs written out below, no
numerics, no fitted constant). ~~One conditional finite no-go was isolated in
L8.~~ That step and L8(b)'s error lower bound are retracted below and in
`BARRIER_LEVEL_EXTRACTION_CORRECTION.md`. Conventions, notation and hypotheses are those
of `BARRIER_SMOOTH_TERM.md` §1 and §6 throughout; $a=d$ is **out of scope**
(struck there, §5.3, and not readmitted here).

**Verdict, stated first.** The row conflated two statements, and they have
different answers.

1. **Sufficiency proper — "matching all the layers at the stated precisions
   makes the configurations windowed-indistinguishable" — is TRUE, and needs
   no Vandermonde at all**: it is Theorem S1 plus a triangle inequality over
   the finitely many levels, once the pairing is written against the *right*
   test function. The right test function is not $\widehat w$ but
   $\widehat{w^{(\nu)}}$, the window tapered by $e^{\nu u/2}$ and **anchored at
   the endpoint Theorem S4 assigns to the level** (top for $\nu>0$, bottom for
   $\nu<0$). With that correction B2′'s precisions $\epsilon X^{-r(\theta_a-1/2)}$
   are exactly right, and two of its demands turn out to be **vacuous**: every
   level $\nu<0$ is below tolerance for free once $X_0\ge(6\beta_k\Sigma_k\|\phi\|_1/\epsilon)^2$.
   (Theorem L5.)
2. ~~The separability statement it invoked — "the levels are separable by
   finitely many windows" — is TRUE asymptotically and FALSE finitely, with
   finite-window error bounded below by
   $X^{(k-1)/2}\operatorname{drift}_{k-1}(\Delta)$; finitely many windows
   reach levels $k$ and $k-1$ and stop.~~

   **Correction (2026-08-14).** L4's Vandermonde is exact for constant
   coefficients, and L7 is a valid **upper** error bound for moving ones.  L8
   cannot turn a lower bound on a drift inside that upper bound into a lower
   bound on actual extraction error.  The exact response of the target-$\nu$
   extractor to a frequency-$\gamma$ mode at node $\xi_\mu$ is the Lagrange
   polynomial $\ell_\nu(\xi_\mu e^{i\gamma\Delta})$; see
   `BARRIER_LEVEL_EXTRACTION_CORRECTION.md`.  This proves generic-spacing
   leakage, not a universal finite no-go.
3. **Per dressing:** for $\mu$ the grading is **multiplicity-free** and the
   target sits at the *top* of the ladder — one window suffices, unconditionally,
   and B2 = B2′ = B2″ there. For $\Lambda$ the levels are distinct but their
   fibers are not singletons: **windows separate levels, and levels are coarser
   than layers** (fiber size $\lfloor(k-|\nu|)/2\rfloor+1$). For $\lambda$ the
   scale lever is identically $1$ ($2\theta_\lambda-1=0$): the whole $r$-ladder
   sits at level $0$ and **no window family of any size separates it** —
   separation there is by frequency, and `FAMILY.md` exp19 measured the
   crowding that results. (Theorems L1, L9.)

So the ledger row splits: *sufficiency is proved; asymptotic separation and
constant-mode finite separation are proved; the claimed universal finite
refutation is reopened, with generic-spacing leakage now stated by its exact
frequency response.*

---

## 0. Prior art, searched first

**In this corpus.**

- `BARRIER_SMOOTH_TERM.md` Theorem S1 (the graded ladder), S2 (convergence of
  every layer), S4 (the transfer law with its anchoring rule) and §5.1 (B2′)
  are the entire input; nothing below re-derives them.
- `FAMILY.md` §2 law 2 — *"$\Lambda$'s pole at $1$ spreads the stack over
  $X^3/X^{5/2}/X^2$; $\lambda$'s critical pole at $\tfrac12$ collapses it to a
  single scale; $\mu$ removes it"* — **is Theorem L1 at $k=2$**. The
  classification below is its $k$-fold form, and the reason it matters here is
  new: "collapses to a single scale" is exactly "the Vandermonde has repeated
  nodes".
- `FAMILY.md` exp19 measured the consequence of the $\lambda$ collapse:
  *"singles and pairs interleave at equal amplitude, so line density doubles
  and crowded lines … are blocked by window resolution — a quantified spectral-crowding
  limit"*. That is Theorem L9's obstruction, observed three sessions before it
  was derived. §6 quotes it as a check, not as an input.
- `BARRIER_ERROR_WINDOW.md` Lemma 5 / `BARRIER_SMOOTH_TERM.md` Lemma 6 supply
  $\Theta_\phi,\widetilde\Theta_\phi$; Lemma L2 below shows these two functionals
  are *literally the $L^1$ norms of the anchored tapered profiles*, which is
  why they are the invariants and not merely convenient.
- `BARRIER_UNIFORM.md` U3(iii) supplies the nonvanishing Bohr coefficients used
  in L8; `HOLOGRAM.md` §7 supplies the standing requirement that every constant
  be quoted with its $X$-dependence, obeyed in L5(B), L7 and L8.

**Outside it.** *Egress is partial in this container: web search works,
document fetch is blocked, so every external citation below is
**search-summary (śabda) grade** — a claim about what the literature contains,
not a verified reading of it.* With that stated:

- The nonsingularity of a **generalized Vandermonde matrix** $(x_p^{\nu_i})$
  for $0<x_1<\dots<x_P$ and distinct real exponents is classical (the matrix is
  totally positive; every minor is again generalized Vandermonde). Lemma L3 is
  proved from scratch anyway, in six lines, because the proof is shorter than
  the citation is reliable.
- Recovering the terms of an exponential sum from samples is **Prony's method**,
  and its known failure mode is exactly the one that bites here: the
  weight-recovery step is a Vandermonde solve whose conditioning degrades like
  (node separation)$^{-(P-1)}$. What is *not* in that literature, and is the
  setting of L7–L8, is the case where the "amplitudes" are themselves
  almost periodic functions of the sample point — which is what a graded ladder
  of wave layers is.
- **Bohr's theory** supplies the two facts used: the $\varepsilon$-almost-periods
  of a uniformly almost periodic function form a relatively dense set, and a
  u.a.p. function tending to $0$ at $+\infty$ vanishes identically.

No claim of novelty is made for any of these ingredients; the novelty claimed
is the identification of *which* one governs B2′, and where it stops.

---

## 1. The level spectrum, and exactly when two layers collide

Write $\vartheta_a:=2\theta_a-1\ \ (\ge0$ for $\theta_a\ge\tfrac12$), so that
Theorem S1's level is
$$\nu(r,m)=r\,\vartheta_a-m .$$
Let the ladder's index set be
$$T_k=\bigl\{(r,m,q)\in\mathbb Z_{\ge0}^3:\ r+m+q=k,\ \text{with }r=0\text{ forced if }g_a=0\bigr\},$$
$\mathcal N_{k,a}=\nu(T_k)$ the **level set**, $P_{k,a}=|\mathcal N_{k,a}|$, and
$F_\nu=\{(r,m,q)\in T_k:\nu(r,m)=\nu\}$ the **fiber** over $\nu$, so that
$\mathcal W_{k,\nu}=\sum_{F_\nu}\binom{k}{r,m,q}g_a^rD_a(0)^m\mathcal Z^{[r\theta_a]}_q$.

> **Theorem L1 (collision law and level spectrum).** For $(r,m),(r',m')$ in the
> simplex,
> $$\nu(r,m)=\nu(r',m')\iff (r-r')\,\vartheta_a=m-m' .$$
> Consequently:
> 1. **$\vartheta_a\notin\mathbb Q$:** $\nu$ is injective on $T_k$; every layer
>    is its own level; $P=\binom{k+2}{2}$.
> 2. **$\vartheta_a=p/q$ in lowest terms, $p\ge1$:** the fibers are the
>    intersections with the simplex of the cosets $(r,m)+\mathbb Z\,(q,p)$.
> 3. **$\vartheta_a=0$** (critical pole, $\theta_a=\tfrac12$): $\nu=-m$; the
>    fiber over $-m$ is $\{(r,m,k-m-r):0\le r\le k-m\}$, of size $k-m+1$. The
>    $r$-grading is **invisible to the level**.
> 4. **$g_a=0$:** $T_k=\{(0,m,k-m)\}$, $\nu=-m$ is injective, $P=k+1$; the
>    grading is **multiplicity-free**.
>
> For the three dressings in scope:
>
> | $a$ | $\vartheta_a$ | $\mathcal N_{k,a}$ | $P_{k,a}$ | $|F_\nu|$ | $\mathcal N^{\ge0}$ | $P^+$ |
> |---|---|---|---|---|---|---|
> | $\Lambda$ | $1$ | $\{-k,\dots,k\}$ | $2k+1$ | $\lfloor\frac{k-|\nu|}{2}\rfloor+1$ | $\{0,1,\dots,k\}$ | $k+1$ |
> | $\mu$ | — ($g_\mu=0$) | $\{0,-1,\dots,-k\}$ | $k+1$ | $1$ | $\{0\}$ | $1$ |
> | $\lambda$ | $0$ | $\{0,-1,\dots,-k\}$ | $k+1$ | $k-m+1$ at $\nu=-m$ | $\{0\}$ | $1$ |

*Proof.* The equivalence is the definition. (1) If $\vartheta_a$ is irrational,
$(r-r')\vartheta_a\in\mathbb Z$ forces $r=r'$, then $m=m'$. (2) $(r-r')p/q\in\mathbb Z$
with $\gcd(p,q)=1$ forces $q\mid r-r'$, and then $m-m'=(r-r')p/q$. (3) $p=0$:
the condition is $m=m'$, $r$ free; the range of $r$ is $0\le r\le k-m$. (4) is
immediate. For the $\Lambda$ row: $\nu=r-m$, and the fiber over $\nu$ is
$\{(\nu+m,m):\ \max(0,-\nu)\le m\le\lfloor(k-\nu)/2\rfloor\}$, of cardinality
$\lfloor(k-|\nu|)/2\rfloor+1$ in both signs of $\nu$; every integer in $[-k,k]$
occurs. $\square$

Three readings of the table, all used below.

- **$\mu$ is the unique dressing whose ladder is multiplicity-free**, and its
  unique nonnegative level is $\nu=0$ with fiber $\{(0,0,k)\}=\{\mathcal Z_k\}$.
  This is a second, independent sense in which `FAMILY.md`'s "$\mu$ is the
  terminal object" holds, and it is not the same as §5.1's ($\mathrm{Smooth}\equiv0$):
  that one says the bucket is empty, this one says the grading is faithful.
- **For $\Lambda$ the level grading is strictly coarser than the layer
  decomposition** as soon as $k\ge2$: level $\nu$ mixes arities
  $q=k-\nu-2m$ differing by $2$. Exactly the four extreme levels
  $\nu=\pm k,\pm(k-1)$ are simple. **A statement indexed by layers (B2′) cannot
  be certified by an instrument graded by levels (windows) below $\nu=k-1$**,
  and that is before any drift is considered.
- **For $\lambda$ level $0$ carries the entire ladder** $\{\mathcal Z^{[r/2]}_{k-r}\}_{r=0}^{k}$
  at equal amplitude. This is `FAMILY.md` law 2's "collapses it to a single
  scale", now with the consequence spelled out in §6.

**Stability under shift depth.** All residue real parts available in Lemma 4 —
$\theta_a\in\{1,\tfrac12\}$, $\rho$ at $\tfrac12$, $s=0$, $\Gamma$-poles at
$-\ell$, trivial zeros at $-2\ell$ — lie in $\tfrac12\mathbb Z$, and
$\nu=2\sum_i\beta_i-k$, so **every level is an integer**. A configuration using
at least one residue at $\beta\le-1$ has $\nu\le 2[(k-1)\theta_a-1]-k$, i.e.
$\le k-4$ for $\Lambda$ and $\le-3$ for $\mu,\lambda$. Hence:

> **Corollary L1′.** Shifting the contour deeper than $\eta<\tfrac12$ enlarges
> the fibers but **never the nonnegative level set**: $\mathcal N^{\ge0}$ and
> $P^+$ are exactly as tabulated, at any shift depth.

This matters because H6 ($0<\eta<\tfrac12$) is *not* enough to read level $0$
for $k\ge3$: Theorem S1's remainder obeys
$|\mathcal R_k|\le C e^{[(k-1)(\theta_a-\frac12)-\frac12-\eta]u}$, which for
$a=\Lambda$ sits at level $k-2-2\eta$ — **above level $0$ once $k\ge3$**. Reading
the signal at all therefore requires

$$\textbf{(H6′)}\qquad \eta\ >\ (k-1)\bigl(\theta_a-\tfrac12\bigr)-\tfrac12
\qquad\bigl(\text{for }\Lambda:\ \eta>\tfrac{k-2}{2}\bigr),$$

crossing $\lfloor\eta\rfloor$ further $\Gamma$-poles and $\lfloor\eta/2\rfloor$
trivial zeros. By Corollary L1′ this costs nothing structural — the window
count $P^+$ is unchanged — which is why the rest of this note may use H6′
freely. (Recorded in the ledger, row Y2: this is a required relaxation of
`BARRIER_SMOOTH_TERM.md`'s H6, not a contradiction of it.)

---

## 2. The tapered window identity: what a level is actually paired against

**Convention.** For a wave layer $G(u)=\sum_{\vec\rho}c_{\vec\rho}e^{i\Gamma_{\vec\rho}u}$
with spectral measure $\sigma_G=\sum_{\vec\rho}c_{\vec\rho}\delta_{\Gamma_{\vec\rho}}$ put
$\widehat w(\Gamma)=\int w(u)e^{i\Gamma u}du$, so $\langle w,G\rangle=\langle\sigma_G,\widehat w\rangle$
(this is `BARRIER.md` B1's pairing, with its reflection absorbed).
$w=w_{L,u_0}$, $\langle w,F\rangle=\int\phi(t)F(u_0+Lt)\,dt$,
$\log X=u_0+Lt_+$, $\log X_0=u_0+Lt_-$.

> **Lemma L2 (anchored taper — an identity, not a bound).** For $\nu\in\mathbb R$
> set the anchor $t_\nu=t_+$ if $\nu>0$, $t_\nu=t_-$ if $\nu<0$ ($t_\nu$
> arbitrary if $\nu=0$), and
> $$A_\nu=\begin{cases}X,&\nu>0\\ 1,&\nu=0\\ X_0,&\nu<0,\end{cases}
> \qquad \phi^{(\nu)}(t)=\phi(t)\,e^{\nu L(t-t_\nu)/2},\qquad
> w^{(\nu)}=w_{L,u_0}\ \text{with profile }\phi^{(\nu)} .$$
> Then for every $G$,
> $$\boxed{\ \bigl\langle w_{L,u_0},\,e^{\nu u/2}G\bigr\rangle
> \;=\;A_\nu^{\nu/2}\ \bigl\langle w^{(\nu)},G\bigr\rangle
> \;=\;A_\nu^{\nu/2}\ \bigl\langle \sigma_G,\widehat{w^{(\nu)}}\bigr\rangle\ }$$
> and moreover
> $$\|\phi^{(\nu)}\|_1=\begin{cases}\widetilde\Theta_\phi(\nu L/2),&\nu>0\\
> \|\phi\|_1,&\nu=0\\ \Theta_\phi(|\nu|L/2),&\nu<0\end{cases}
> \ \le\ \|\phi\|_1,\qquad
> \bigl\|(\phi^{(\nu)})^{(N)}\bigr\|_1\le\Bigl(1+\tfrac{|\nu|L}{2}\Bigr)^{N}\max_{n\le N}\|\phi^{(n)}\|_1 .$$

*Proof.* $e^{\nu(u_0+Lt)/2}=e^{\nu(u_0+Lt_\nu)/2}e^{\nu L(t-t_\nu)/2}=A_\nu^{\nu/2}e^{\nu L(t-t_\nu)/2}$
by the definition of $X,X_0$; insert into $\langle w,\cdot\rangle$. The $L^1$
identities are the definitions of $\Theta_\phi$ (`BARRIER_ERROR_WINDOW.md` §3)
and $\widetilde\Theta_\phi$ (`BARRIER_SMOOTH_TERM.md` Lemma 6), and Lemma 5.1
gives $\le\|\phi\|_1$. For the derivative bound, Leibniz with $c=\nu L/2$ gives
$(\phi e^{c(t-t_\nu)})^{(N)}=\sum_n\binom Nn c^{N-n}\phi^{(n)}e^{c(t-t_\nu)}$, and
the choice of anchor makes $e^{c(t-t_\nu)}\le1$ on $\operatorname{supp}\phi$ for
either sign of $\nu$; sum the binomials. $\square$

Three consequences, each of which is a correction to how B2′ was written.

1. **The test function is $\widehat{w^{(\nu)}}$, not $\widehat w$.** B2′ as
   stated in `BARRIER_SMOOTH_TERM.md` §5.1 pairs the layer differences against
   $\widehat w$; the ladder pairs them against the tapered window. The two
   differ, and the difference is precisely the profile functional that
   `BARRIER_ERROR_WINDOW.md` identified as *the* invariant. **Theorem S4's
   anchoring rule is this lemma with the modulus taken**: S4 is the inequality,
   L2 is the identity behind it.
2. **The taper is legal but not free.** $\phi^{(\nu)}$ has the same support and
   the same smoothness as $\phi$, so $w^{(\nu)}$ is again a span-$L$ window and
   the B2′ conditions remain conditions inside the class $\mathrm{WL}_d(L,r)$.
   But the Paley–Wiener tail of B1′ degrades: out-of-band content at frequency
   $\Gamma$ is $\ll_N\bigl(\frac{1+|\nu|L/2}{|\Gamma| L}\bigr)^N\max_n\|\phi^{(n)}\|_1$,
   so the tapered window's effective resolution is
   $$\max\Bigl(\frac1L,\ \frac{|\nu|}{2}\Bigr)\qquad\text{in the frequency variable }\Gamma .$$
   **Tapering by $e^{\nu u/2}$ blurs by $|\nu|/2$ no matter how long the window
   is.** For $a=\Lambda$ and the leading oscillating level $\nu=k-1$ this is a
   blur of $(k-1)/2$ in $\gamma$ — comparable with the mean ordinate gap at
   accessible heights. Recorded as a hypothesis-level caveat in §7, and it is
   the reason the level-$\nu$ conditions of B2′ are conditions at resolution
   $\max(2\pi/L,\pi\nu)$, not $2\pi/L$.
3. **The precisions in B2′ are exactly the anchors.** $A_\nu^{\nu/2}=X^{\nu/2}$
   for $\nu>0$ and the $m=0$ diagonal has $\nu=r\vartheta_a$, i.e.
   $\nu/2=r(\theta_a-\tfrac12)$: B2′'s $\epsilon X^{-r(\theta_a-1/2)}$ is the
   reciprocal of the top-anchored amplification, as claimed there. For $\nu<0$
   the anchor is $X_0$ and the demand is $\epsilon X_0^{|\nu|/2}$ — **weaker
   than $\epsilon$, hence no demand at all**, which is Theorem L5(ii).

---

## 3. The Vandermonde, proved

> **Lemma L3 (generalized Vandermonde).** Let $\nu_1>\nu_2>\dots>\nu_P$ be
> distinct reals and $0<x_1<\dots<x_P$. Then $\det\bigl(x_p^{\nu_i}\bigr)_{p,i}\ne0$.

*Proof.* It suffices that a nonzero generalized polynomial
$f(x)=\sum_{i=1}^{n}c_ix^{\nu_i}$ (distinct real $\nu_i$, not all $c_i$ zero)
have at most $n-1$ zeros in $(0,\infty)$; a nonzero kernel vector of the matrix
would give such an $f$ with $P$ positive zeros. Induct on the number $n$ of
nonzero coefficients. $n=1$: $c_1x^{\nu_1}$ has none. For $n\ge2$ assume all
$c_i\ne0$ and put $g(x)=x^{-\nu_n}f(x)$, which has the same positive zeros as
$f$; then $g'(x)=\sum_{i<n}c_i(\nu_i-\nu_n)x^{\nu_i-\nu_n-1}$ is a generalized
polynomial with $n-1$ nonzero terms, hence at most $n-2$ positive zeros by the
inductive hypothesis. If $g$ had $n$ or more positive zeros, Rolle would give
$g'$ at least $n-1$ — contradiction. $\square$

For the family used below the nodes are geometric and everything is explicit.

> **Theorem L4 (the separating family, its size, and its determinant).** Fix a
> profile $\phi$, a span $L$, a base centre $u_0$ and a spacing $\Delta>0$. Let
> $$\mathcal F_{k,a}(\Delta)=\bigl\{\,w_p:=w_{L,\;u_0+(p-1)\Delta}\ :\ p=1,\dots,P^+\,\bigr\},
> \qquad P^+=\bigl|\mathcal N^{\ge0}_{k,a}\bigr| ,$$
> i.e. $P^+$ **translates of one window in log-scale**, reading the scale ranges
> $[X_0,X]\cdot e^{(p-1)\Delta}$. By Theorem L1, $P^+=k+1$ for $a=\Lambda$ and
> $P^+=1$ for $a\in\{\mu,\lambda\}$. Write $y=e^{\Delta/2}$ and
> $\xi_\nu=e^{\nu\Delta/2}=y^{\nu}$ for $\nu\in\mathcal N^{\ge0}$. Then the
> matrix $V_{p\nu}=\xi_\nu^{\,p-1}$ is a classical Vandermonde with distinct
> positive nodes, and for $a=\Lambda$ (nodes $1,y,\dots,y^{k}$)
> $$\boxed{\ \det V=\prod_{0\le i<j\le k}\bigl(y^{\,j}-y^{\,i}\bigr)
> \;=\;y^{\binom{k+1}{3}}\prod_{d=1}^{k}\bigl(y^{\,d}-1\bigr)^{\,k+1-d}\ \ne\ 0
> \quad(y>1).\ }$$
> Its inverse is Lagrange interpolation: with
> $\ell_\nu(\xi)=\prod_{\nu'\ne\nu}\frac{\xi-\xi_{\nu'}}{\xi_\nu-\xi_{\nu'}}
> =\sum_{p}a_{\nu p}\,\xi^{\,p-1}$, one has $\sum_p a_{\nu p}\xi_{\nu'}^{\,p-1}=\delta_{\nu\nu'}$ and
> $$\kappa_\nu:=\sum_p|a_{\nu p}|=\prod_{\nu'\ne\nu}\frac{1+\xi_{\nu'}}{|\xi_\nu-\xi_{\nu'}|}\ <\ \infty .$$
> $\kappa_\nu$ depends only on $\Delta$ and on $\mathcal N^{\ge0}$ — **not on
> $X$, $X_0$, $L$, $u_0$ or the arithmetic.**

*Proof.* Nonsingularity is Lemma L3 with $x_p=y^{p-1}$ (or the classical
Vandermonde formula directly, the nodes $y^\nu$ being distinct for $y>1$). For
the product form, $y^j-y^i=y^i(y^{j-i}-1)$ and
$\sum_{0\le i<j\le k}i=\sum_{i=0}^{k}i(k-i)=\binom{k+1}{3}$, while each
difference $d=j-i$ occurs $k+1-d$ times. For $\kappa_\nu$: the coefficients of
$\prod_{\nu'\ne\nu}(\xi-\xi_{\nu'})$ have absolute values equal to the
coefficients of $\prod_{\nu'\ne\nu}(\xi+\xi_{\nu'})$ because all $\xi_{\nu'}>0$,
and the latter sum to the value at $\xi=1$. $\square$

**Why $P^+$ windows and not more.** Levels $\nu<0$ need not be annihilated: by
Lemma L2 their entire contribution to any read of the family is at most
$X_0^{-1/2}\beta_k\Sigma_k\|\phi\|_1$ where
$$\beta_k:=\bigl(1+|g_a|+|D_a(0)|\bigr)^{k}=\!\!\sum_{r+m+q=k}\!\!\binom{k}{r,m,q}|g_a|^r|D_a(0)|^m,
\qquad \Sigma_k:=\max_{(r,m,q)\in T_k}\bigl\|\sigma^{[r\theta_a]}_q\bigr\|_v,$$
which is below any fixed tolerance once $X_0$ is large — with the scaling
stated, not hidden. And not fewer: with $P<P^+$ windows the system
$V\in\mathbb R^{P\times P^+}$ has a kernel, so the reads are blind to a
nonzero combination of the nonnegative levels' constant parts.

---

## 4. Sufficiency of B2′, in corrected form

> **Theorem L5 (B2″: sufficiency, with the levels indexed correctly).** Assume
> H1, H2, H3, H4, H5 and H6′, and $a\in\{\Lambda,\mu,\lambda\}$. Let
> $\sigma,\sigma'$ be two admissible configurations, with layer measures
> $\sigma^{[\delta]}_q,\sigma'^{[\delta]}_q$ and remainders
> $\mathcal R_k,\mathcal R'_k$. Fix $\epsilon>0$ and a window
> $w=w_{L,u_0}$ with endpoints $X_0<X$. Suppose
>
> **(i)** for every $(r,m,q)\in T_k$ with $\nu=\nu(r,m)\ge0$,
> $$\Bigl|\bigl\langle \sigma^{[r\theta_a]}_q-\sigma'^{[r\theta_a]}_q,\ \widehat{w^{(\nu)}}\bigr\rangle\Bigr|
> \ \le\ \frac{\epsilon}{3\beta_k}\ X^{-\nu/2};$$
> **(ii)** $X_0\ \ge\ \bigl(6\beta_k\Sigma_k\|\phi\|_1/\epsilon\bigr)^{2}$ — *no
> condition whatever on the levels $\nu<0$*;
> **(iii)** $|\langle w,\mathcal R_k\rangle|,\ |\langle w,\mathcal R'_k\rangle|\le\epsilon/6$,
> which under H6′ holds as soon as $X_0^{\,(k-1)(\theta_a-1/2)-1/2-\eta}\le\epsilon/(6C_{k,j,\eta})$.
>
> Then $\bigl|\langle w,\psi_k-\psi'_k\rangle\bigr|\le\epsilon$.
>
> In particular, for $a=\mu$ the list (i) has **one** entry, $r=m=0$,
> $\nu=0$ — i.e. `BARRIER.md`'s Corollary B2 verbatim — so **B2 is
> sufficient, not merely necessary, for $\mu$.**

*Proof.* Theorem S1 for each configuration and subtract; the difference of the
$(r,m,q)$ terms is
$\binom{k}{r,m,q}g_a^rD_a(0)^m\langle w,e^{\nu u/2}(\mathcal Z^{[r\theta_a]}_q-\mathcal Z'^{[r\theta_a]}_q)\rangle$,
which by Lemma L2 equals
$\binom{k}{r,m,q}g_a^rD_a(0)^mA_\nu^{\nu/2}\langle\sigma^{[r\theta_a]}_q-\sigma'^{[r\theta_a]}_q,\widehat{w^{(\nu)}}\rangle$.
For $\nu\ge0$, $A_\nu^{\nu/2}\le X^{\nu/2}$ and (i) gives a total at most
$\beta_k\cdot\frac{\epsilon}{3\beta_k}=\epsilon/3$. For $\nu<0$, Lemma L2 bounds
each term by $X_0^{\nu/2}\|\phi^{(\nu)}\|_1\cdot2\Sigma_k\le2X_0^{-1/2}\Sigma_k\|\phi\|_1$
times its multinomial weight, total $\le2\beta_k\Sigma_k\|\phi\|_1X_0^{-1/2}\le\epsilon/3$
by (ii). The remainders give $\epsilon/3$ by (iii). $\square$

Two things this settles, both of which W6 left open.

- **Sufficiency needs no separability.** It is Theorem S1, Lemma L2 and three
  applications of the triangle inequality over a finite index set. The
  Vandermonde was never required for this direction; W6's "would need" was a
  misattribution, and §5 below shows what the Vandermonde *is* needed for.
- **Half of B2′'s demands are vacuous.** Only levels $\nu\ge0$ carry
  conditions: for $\Lambda$ the layers with $r\ge m$; for $\lambda$ and $\mu$
  the single level $\nu=0$. The demand at $\nu<0$ is satisfied by any two
  configurations with bounded layer norms once $X_0$ passes an explicit
  threshold that scales like $\epsilon^{-2}$.

---

## 5. Separability: true asymptotically; the universal finite no-go is retracted

Write the read of the family as an exact identity. With
$$\Lambda_\nu(u):=\bigl\langle w_{L,u},\,e^{\nu u'/2}\mathcal W_{k,\nu}(u')\bigr\rangle
=e^{\nu u/2}C_\nu(u),\qquad
C_\nu(u):=\int\phi(t)e^{\nu Lt/2}\mathcal W_{k,\nu}(u+Lt)\,dt,$$
Theorem S1 gives, for every $p$,
$$R_p:=\langle w_p,\psi_k\rangle=\sum_{\nu\in\mathcal N}\xi_\nu^{\,p-1}e^{\nu u_0/2}C_\nu(u_p)
\;+\;\langle w_p,\mathcal R_k\rangle,\qquad u_p=u_0+(p-1)\Delta. \tag{5.1}$$
Each $C_\nu$ is **uniformly almost periodic** in $u$ and bounded (Theorem S2 plus
Bohr): it is an absolutely convergent sum of pure exponentials with the same
frequencies as $\mathcal W_{k,\nu}$ and coefficients multiplied by
$\widehat{\phi^{(\nu)}}(\Gamma L)$. **(5.1) is a Vandermonde system if and only
if the $C_\nu$ are constant.** Define the **drift**
$$\operatorname{drf}_\nu(\Delta,P):=\max_{1\le p\le P}\bigl|C_\nu(u_p)-C_\nu(u_0)\bigr| .$$

### 5.1 Asymptotic separation: exact, unconditional

> **Theorem L6 (peeling).** Let $F(u)=\sum_{i=1}^{P}e^{\nu_iu/2}C_i(u)+\mathcal R(u)$
> with $\nu_1>\dots>\nu_P$, each $C_i$ uniformly almost periodic and bounded,
> and $|\mathcal R(u)|\le Ce^{\beta u}$ with $\beta<\nu_P/2$. Fix $i_0$ and
> suppose $|F(u)|\le\epsilon\,e^{\nu_{i_0}u/2}$ for all $u\ge u_*$. Then
> $$C_i\equiv0\ \text{ for all } i<i_0,\qquad \|C_{i_0}\|_\infty\le\epsilon .$$

*Proof.* Induction on $i$. For $i=1$,
$e^{-\nu_1u/2}F(u)=C_1(u)+\sum_{i\ge2}e^{(\nu_i-\nu_1)u/2}C_i(u)+e^{-\nu_1u/2}\mathcal R(u)$,
and the last two groups tend to $0$ uniformly, while the left side is
$\le\epsilon e^{(\nu_{i_0}-\nu_1)u/2}\to0$ when $i_0>1$. So $C_1(u)\to0$ as
$u\to\infty$; a uniformly almost periodic function tending to $0$ vanishes
identically (if $\sup|C_1|=S>0$, the $S/4$-almost-periods are relatively dense,
so every interval of length $\ell(S/4)$ contains a point with $|C_1|>S/2$).
Subtract and repeat. At $i=i_0$ the same display gives
$|C_{i_0}(u)|\le\epsilon+o(1)$, and $\sup|C_{i_0}|$ is approached on a
relatively dense set of $u$, hence at arbitrarily large $u$. $\square$

> **Corollary L6′ (necessity of B2″, and why B2′'s precisions are what they
> are).** If two configurations satisfy $|\langle w_{L,u_0},\psi_k-\psi'_k\rangle|\le\epsilon$
> for **all** $u_0\ge u_*$ at fixed $L$ and profile, then for every level
> $\nu>0$ the difference $\mathcal W_{k,\nu}-\mathcal W'_{k,\nu}$ has vanishing
> Bohr coefficient at every frequency $\Gamma$ with
> $\widehat{\phi^{(\nu)}}(\Gamma L)\ne0$ — **exact agreement in the resolved
> band, not $\epsilon$-agreement** — and at $\nu=0$,
> $\|C_0-C_0'\|_\infty\le\epsilon$. If instead the tolerance is allowed to grow
> with the scale, $\epsilon=\epsilon(X)$, the same argument returns
> $\|C_\nu-C'_\nu\|_\infty\le\liminf_X\epsilon(X)X^{-\nu/2}$ — which is exactly
> B2′'s $\epsilon X^{-r(\theta_a-\frac12)}$ on the $m=0$ diagonal.

So B2′ is vindicated as a necessary condition, in the regime in which it was
argued: *the WL observer may vary $X$ without bound.* The cost of that regime
is that it is not an experiment; §5.2 asks what a bounded observer can do.

### 5.2 Finite separation: the extraction, and its exact error

> **Theorem L7 (finite-window extraction).** With the family
> $\mathcal F_{k,a}(\Delta)$ of Theorem L4 and its Lagrange coefficients
> $a_{\nu p}$, for every $\nu\in\mathcal N^{\ge0}$
> $$\Bigl|\ e^{\nu u_0/2}C_\nu(u_0)\ -\ \sum_{p=1}^{P^+}a_{\nu p}R_p\ \Bigr|
> \ \le\ \kappa_\nu\Bigl[\underbrace{\sum_{\nu'\ge0}e^{\nu'u_0/2}\,\xi_{\nu'}^{\,P^+-1}\operatorname{drf}_{\nu'}(\Delta,P^+)}_{\text{drift}}
> \;+\;\underbrace{2\beta_k\Sigma_k\|\phi\|_1\,X_0^{-1/2}}_{\text{levels }\nu<0}
> \;+\;\max_p\bigl|\langle w_p,\mathcal R_k\rangle\bigr|\Bigr].$$
> All three brackets carry their $X$-dependence explicitly; $\kappa_\nu$ carries
> none.

*Proof.* Write (5.1) as $R_p=\sum_{\nu\ge0}\xi_\nu^{p-1}e^{\nu u_0/2}C_\nu(u_0)+\eta_p$
with
$\eta_p=\sum_{\nu\ge0}\xi_\nu^{p-1}e^{\nu u_0/2}\bigl(C_\nu(u_p)-C_\nu(u_0)\bigr)
+\sum_{\nu<0}\xi_\nu^{p-1}e^{\nu u_0/2}C_\nu(u_p)+\langle w_p,\mathcal R_k\rangle$.
Apply $\sum_pa_{\nu p}$, use $\sum_pa_{\nu p}\xi_{\nu'}^{p-1}=\delta_{\nu\nu'}$
(Theorem L4) and $|\sum_pa_{\nu p}\eta_p|\le\kappa_\nu\max_p|\eta_p|$. The
$\nu<0$ block is bounded as in Theorem L5 (its $\xi_\nu^{p-1}\le1$ since
$\xi_\nu<1$ there). $\square$

**Corollary L7′ (constant fibers, and the corrected moving-target boundary).** The drift bracket
vanishes for every level whose fiber consists of $q=0$ layers only, since then
$\mathcal W_{k,\nu}$ is constant in $u$ (for $a\ne d$: the $q=0$ layers are
pure constants $\binom{k}{r,m,0}g_a^rD_a(0)^m/\Gamma(r\theta_a+j+1)$). By
Theorem L1 those levels are, for $a=\Lambda$, exactly $\nu=\pm k$. Hence:

| target level | what must be annihilated | drift incurred | verdict |
|---|---|---|---|
| $\nu=k$ ($\Lambda$) | nothing (it is the top and constant) | none — a *single* window reads the leading coefficient with relative error $O(X^{-1/2})$ from lower levels | **asymptotically exact** |
| $\nu=k-1$ ($\Lambda$) | level $k$ is constant, but the **target itself moves** | self-response $\ell_{k-1}(\xi_{k-1}e^{i\gamma\Delta})-1$ | ~~exact~~ **generically distorted; top subtraction leaves lower-order contamination** |
| $\nu\le k-2$ ($\Lambda$, so in particular $\nu=0$, $k\ge2$) | moving higher levels and the moving target | non-target leakage $\ell_\nu(\xi_\mu e^{i\gamma\Delta})$ plus target self-response minus $1$ | ~~obstructed for every spacing~~ **generic fixed spacings leak/distort; selected spacings open (§5.3)** |
| $\nu=0$ ($\mu$) | nothing (it is the top, and the fiber is $\{\mathcal Z_k\}$) | none | **exact**, one window |
| $\nu=0$ ($\lambda$) | nothing — but the fiber is the whole ladder | none, and no separation either | **degenerate (§6)** |

The $k=1$ row of the $\Lambda$ column is worth stating separately: at $k=1$ the
level above $0$ is $\nu=1$, fiber $\{(1,0,0)\}$, constant.  ~~Therefore the
signal level is finitely extractable.~~  The higher level can be subtracted
exactly, but a translated-window Vandermonde still distorts the moving
level-$0$ target by its self-response.  A single-window subtraction is
asymptotically exact once negative levels and the remainder are bounded.

### 5.3 The obstruction, and the regime it bites

> **Theorem L8 (drift obstruction).** Let $a=\Lambda$, $k\ge2$, and let the
> target be any level $\nu\le k-2$ (in particular the signal level $0$). Write
> $C_{k-1}$ for the windowed arity-$1$ layer at level $k-1$, with Bohr
> coefficients $\hat c_\gamma=k\,g_a^{\,k-1}\frac{v_\rho\Gamma(\rho)}{\Gamma(\rho+(k-1)\theta_a+j+1)}\widehat{\phi^{(k-1)}}(\gamma L)$.
> Then:
>
> **(a) Lower bound on the drift.** For every $\Delta$ and every zero $\rho$,
> $$\sup_{u}\bigl|C_{k-1}(u+\Delta)-C_{k-1}(u)\bigr|\ \ge\ 2\,\bigl|\hat c_\gamma\bigr|\,\bigl|\sin(\gamma\Delta/2)\bigr| ,$$
> and on a relatively dense set of base points $u_0$ the drift
> $\operatorname{drf}_{k-1}(\Delta,P^+)$ is at least half of that supremum. The
> coefficients $\hat c_\gamma$ are **nonzero unconditionally** (this is exactly
> the $(\star)$-discharge of `BARRIER_SMOOTH_TERM.md` §6, which needs only
> arity $1$), for every $\gamma$ with $\widehat{\phi^{(k-1)}}(\gamma L)\ne0$.
>
> **(b) ~~Consequently the level-$\nu$ extraction error of Theorem L7 is
> $\gtrsim\kappa_\nu X^{(k-1)/2}\sup_\gamma
> |\hat c_\gamma\sin(\gamma\Delta/2)|$.~~  Retracted.**  Theorem L7 is an
> upper bound obtained after a triangle inequality; a lower bound on one term
> inside its right-hand side is not a lower bound on the signed extraction
> error.  With L4's
> $\ell_\nu(z)=\sum_p a_{\nu p}z^{p-1}$, the exact response to a
> frequency-$\gamma$ mode in level $\mu$ is instead
> $$e^{\mu u_0/2}\hat c_\gamma e^{i\gamma u_0}
>   \ell_\nu(\xi_\mu e^{i\gamma\Delta}).$$
> Constants are separated exactly.  For $\mu\ne\nu$, a fixed nonzero mode
> leaks for every non-resonant spacing $e^{i\gamma\Delta}\ne1$, but selected
> near-resonant spacings require a separate conditioning estimate.
>
> **(c) Unconditionally, a positive proportion of spacings have large raw
> drift.** For
> $H\ge2/\gamma_1$,
> $$\frac1H\int_0^H\sup_u\bigl|C_{k-1}(u+\Delta)-C_{k-1}(u)\bigr|^2 d\Delta
> \ \ge\ \sum_\gamma|\hat c_\gamma|^2\ >\ 0,$$
> so the set of $\Delta\in[0,H]$ with drift below
> $\bigl(\tfrac12\sum_\gamma|\hat c_\gamma|^2\bigr)^{1/2}$ has measure at most
> $H\bigl(1-\sum_\gamma|\hat c_\gamma|^2/(8\|C_{k-1}\|_\infty^2)\bigr)$.
>
> **(d) ~~Conditionally, no admissible spacing works.~~  Retracted.**  Under
> linear independence, Weyl equidistribution can estimate the asymptotic
> **measure** of simultaneous almost-periods.  Such a density estimate does
> not bound the first return and cannot prove that a prescribed finite
> interval contains none.  The open quantitative question must also include
> the blow-up of the inverse-Vandermonde coefficients as $\Delta\to0$.

*Proof.* (a) $D(u):=C_{k-1}(u+\Delta)-C_{k-1}(u)$ is u.a.p. with Bohr
coefficients $\hat c_\gamma(e^{i\gamma\Delta}-1)$; a Bohr coefficient is a mean
of $D(u)e^{-i\gamma u}$ and so is bounded by $\sup|D|$, and
$|e^{i\gamma\Delta}-1|=2|\sin(\gamma\Delta/2)|$. A u.a.p. function attains at
least half its supremum on a relatively dense set (Bohr), and
$\operatorname{drf}_{k-1}\ge|D(u_0)|$ for the $p=2$ member of the family. (b)
The former inference from L7 is withdrawn.  Expanding each Bohr mode before
applying $\sum_p a_{\nu p}$ gives the displayed Lagrange response; this is
proved algebraically in `BARRIER_LEVEL_EXTRACTION_CORRECTION.md` and checked in
`Pairfield.VandermondeFrequencyResponse`. (c)
Bohr–Parseval gives $\sup_u|D|^2\ge\sum_\gamma|\hat c_\gamma|^2|e^{i\gamma\Delta}-1|^2$;
average in $\Delta$ using $\frac1H\int_0^H|e^{i\gamma\Delta}-1|^2d\Delta
=2\bigl(1-\frac{\sin\gamma H}{\gamma H}\bigr)\ge1$ for $\gamma H\ge2$; then
Chebyshev against the upper bound $4\|C_{k-1}\|_\infty^2$. (d) The quoted
equidistribution statement supplies density only; the claimed first-return
consequence is withdrawn. $\square$

**~~Where it bites, exactly: every finite window family for $a=\Lambda$,
$k\ge2$, and target $\nu\le k-2$.~~**  Correction: the exact response proves
asymptotically amplified leakage for generic fixed non-resonant spacings.  It
does not exclude every spacing in the finite data range.  It still does not
arise at $k=1$ or for $\mu$ at its top level; for $\lambda$ the rank-one
degeneracy of §6 remains exact.

**Why the other knob does not help.** One might vary the *span* $L$ at fixed
top $X$ instead of the centre. That knob is exponentially weak. By Lemma L2 the
positive levels are then all anchored at the same $X$, and the only
$\nu$-dependence left is $\|\phi^{(\nu)}\|_1=\widetilde\Theta_\phi(\nu L/2)$; for
the boxcar this is exactly $\frac{2}{\nu L}\bigl(1-e^{-\nu L/2}\bigr)$
(Lemma 5.4/Lemma 6, in closed form). The matrix $M_{p\nu}=\frac{2}{\nu L_p}-\frac{2e^{-\nu L_p/2}}{\nu L_p}$
has a **rank-one** leading part $\bigl(\tfrac1{L_p}\bigr)\bigl(\tfrac2\nu\bigr)$,
and $\det(A+B)$ with $\operatorname{rank}A=1$ equals
$\det B+\sum_i\det(B\text{ with column }i\text{ from }A)$, so
$$|\det M|\ \le\ P!\,\|E\|_\infty^{P}\ +\ P\,(P-1)!\,\|A\|_\infty\|E\|_\infty^{P-1},
\qquad \|E\|_\infty\le \tfrac{2}{\nu_{\min}L_{\min}}e^{-\nu_{\min}L_{\min}/2}.$$
**Span variation separates only at strength $e^{-\nu_{\min}L/2}$: the lever
vanishes exponentially in the span.** Moving the anchor — i.e. moving the
centre — is the only strong lever. Corrected L8 gives its exact modal response,
but not a universal finite cost lower bound.

---

## 6. The $\lambda$ degeneracy: not a hard problem but an empty one

> **Theorem L9 (no window family separates $\lambda$'s ladder).** For
> $a=\lambda$, $\vartheta_\lambda=2\theta_\lambda-1=0$, so every layer with
> $m=0$ has level $\nu=0$ and
> $$\mathcal W^{(\lambda)}_{k,0}=\sum_{r=0}^{k}\binom{k}{r}g_\lambda^{\,r}\,\mathcal Z^{[r/2]}_{k-r},
> \qquad g_\lambda=\frac{\sqrt\pi}{2\zeta(\tfrac12)}\ne0 .$$
> Every windowed read of $\psi_k$ sees this sum through a single scale factor
> $A_0^{0}=1$: the map "window $\mapsto$ read" factors through
> $\mathcal W^{(\lambda)}_{k,0}$, so no family of windows — of any cardinality,
> any spans, any centres — separates the summands. In Vandermonde terms: all
> $k+1$ nodes coincide, $\xi_\nu\equiv1$, and the matrix has rank $1$.
> Separation of the $r$-grading for $\lambda$ is possible only by **frequency**:
> the summand of index $r$ has arity $k-r$, and its frequencies are $(k-r)$-fold
> ordinate sums.

*Proof.* Theorem L1(3) and Lemma L2 with $\nu=0$. $\square$

**Frequency separation is itself only partial, and this is corpus prior art.**
Arity $k-r$ and arity $k-r-2$ share frequencies (add $\gamma-\gamma'$ with
$\gamma=\gamma'$), so even under linear independence of the ordinates the
frequency supports overlap; and at fixed resolution $2\pi/L$ the lines
interleave. `FAMILY.md` exp19 records exactly this, measured: *"the degeneracy
also bites back: singles and pairs interleave at equal amplitude, so line
density doubles and crowded lines … are blocked by window resolution — a
quantified spectral-crowding limit."* Theorem L9 is the derivation of that
measurement's cause, and it says the limit is structural: for $\lambda$ the
scale axis carries **no** information about $r$ at all.

**Consequence for the barrier programme.** `BARRIER_SMOOTH_TERM.md` §5.1
recommended $\mu$ on the ground that its $\mathrm{Smooth}$ bucket is empty.
Theorem L1(4) and Theorem L7′ give the same recommendation on an independent
ground — $\mu$'s grading is multiplicity-free and its target sits at the top of
the ladder — and Theorem L9 upgrades the case against $\lambda$ from "no scale
separation, separate by frequency" to "no scale separation, and the frequency
route is resolution-limited in a way that has already been measured".

---

## 7. Hypotheses, and exactly where each enters

| # | hypothesis | where it enters | what fails without it |
|---|---|---|---|
| H1 | RH | inherited from S1: the levels are spaced by $\tfrac12$ and $\mathcal N\subset\mathbb Z$ | the level set becomes a continuum; Lemma L3 still applies but the family becomes infinite |
| H2 | simple zeros | inherited (weights $v_\rho$) | multiplicities rescale $\hat c_\gamma$ in L8(a); no threshold moves |
| H3 | $D_a$ of polynomial growth on $\Re s=-\eta$ | inherited; **fails for $d$**, which is why $d$ is out of scope | — |
| H4 | simple pole at $\theta_a$ | Theorem L1's level formula; a double pole adds $u$-polynomial factors and the "constant" layers of L7′ stop being constant | the $q=0$ layers acquire drift, and L7′'s exact rows collapse |
| H5 | $k\le2j$ | absolute convergence of every $C_\nu$, hence u.a.p. (S2) | (5.1) is not a convergent expansion |
| **H6′** | $\eta>(k-1)(\theta_a-\tfrac12)-\tfrac12$ | pushes $\mathcal R_k$ below level $0$ so the signal level is readable at all; **replaces H6 for $k\ge3$** | $\mathcal R_k$ sits at level $k-2-2\eta\ge0$ and no separation statement about level $0$ is meaningful |
| $(\dagger)$ | resolution of the tapered window is $\max(2\pi/L,\pi|\nu|)$, not $2\pi/L$ | Lemma L2(2): B2″'s level-$\nu$ conditions are conditions at the coarser resolution | conditions at level $\nu$ over-claim their resolving power by the factor $1+|\nu|L/2$ |
| ~~$(\ddagger)$~~ | ~~linear independence of the ordinates over $\mathbb Q$~~ | ~~Theorem L8(d)~~ | **Retracted:** equidistribution density does not yield the claimed first-return bound. No surviving theorem in this note uses LI. |

Nothing here needs $(\star)$ of `BARRIER_SMOOTH_TERM.md` §6: the obstructing
layer has arity $1$, whose Bohr coefficients are unconditionally nonzero.

---

## 8. Status after this note

| ingredient | before | after |
|---|---|---|
| B2′ **sufficiency** | not claimed (W6) | **proved** as B2″ (Theorem L5), with the test function corrected to the anchored taper $\widehat{w^{(\nu)}}$ and the levels $\nu<0$ shown vacuous for $X_0\ge(6\beta_k\Sigma_k\|\phi\|_1/\epsilon)^2$ |
| B2′ **necessity** | asserted from "the observer may vary $X$" | **proved** in that regime (Theorem L6, Corollary L6′), and sharpened: at fixed tolerance the positive levels must agree **exactly** in the resolved band |
| "levels separable by finitely many windows" | unwritten | **written, and corrected**: nonsingular Vandermonde with explicit determinant and inverse (L4); exact separation only for constant modes, with the $\Lambda$ top level asymptotically isolated and the one-window $\mu$ target un-mixed at level $0$; ~~exact through $\nu=k-1$ and false below for every family~~ **moving targets have self-response and non-target modes leak at generic spacings; selected quantitative separation is open** (corrected L7′/L8) |
| the window family | unspecified | $P^+=|\mathcal N^{\ge0}|$ log-translates of one window, spacing $\Delta$, nodes $\xi_\nu=e^{\nu\Delta/2}$: **$k+1$ windows for $\Lambda$, one for $\mu$ and $\lambda$**, stable under shift depth (Corollary L1′) |
| $\lambda$ | "no scale separation, separate by frequency" (S1 §5.1) | **theorem**: the Vandermonde has all nodes equal, rank $1$; no family of any size separates the $r$-grading (L9), and the frequency route is the resolution limit exp19 measured |
| which dressing to probe with | $\mu$ (empty $\mathrm{Smooth}$) | $\mu$, on a second and independent ground: multiplicity-free grading, target at the top of the ladder, one window, unconditional |
| shift depth | H6, $\eta<\tfrac12$ | **H6′ required for $k\ge3$**; harmless, since $\mathcal N^{\ge0}$ is shift-stable |

**The sufficiency row is discharged; the universal finite-separation row is
reopened.**  Corrected L8 gives an exact frequency-response polynomial and
generic-spacing leakage.  It does not rule out a carefully selected spacing
inside the data range.  Modelling/subtracting the arity-$1$ layer remains one
route; an effective simultaneous-return estimate balanced against
inverse-Vandermonde conditioning is another.

---

## 9. Honesty ledger

| # | item | status |
|---|---|---|
| Y1 | Theorem L1 (collision law, level spectrum, fiber sizes) | **Proved, elementary and unconditional** given S1's grading. It is one line of arithmetic in $(r,m)$ plus a count; the only content is that $\vartheta_a\in\{1,0\}$ across the family in scope, which is `FAMILY.md` law 2 restated as a statement about the injectivity of $\nu$. |
| Y2 | Corollary L1′ and hypothesis H6′ | **Proved.** Every residue real part lies in $\tfrac12\mathbb Z$, so every level is an integer and deep shifts add nothing above $k-4$. The corollary exposes a genuine defect in `BARRIER_SMOOTH_TERM.md`'s H6: at $\eta<\tfrac12$ the remainder $\mathcal R_k$ sits **above** level $0$ for $k\ge3$, so S1 as hypothesised cannot see its own signal layer. This is a repair, not a refutation — the fix costs nothing because $P^+$ is shift-stable — but it should be carried into any future use of S1 at $k\ge3$. |
| Y3 | Lemma L2 (anchored taper identity) | **Proved, unconditional, two lines.** Its content is that Theorem S4's inequality is the modulus of an identity, and that $\Theta_\phi,\widetilde\Theta_\phi$ are the $L^1$ norms of the anchored tapered profiles. The Paley–Wiener degradation $(1+|\nu|L/2)^N$ is proved; the reading of it as "resolution $\max(2\pi/L,\pi|\nu|)$" is the standard converse and is stated as such, marked $(\dagger)$, not proved sharp. |
| Y4 | Lemma L3, Theorem L4 (Vandermonde, determinant, inverse norms) | **Proved from scratch**, Descartes/Rolle induction plus the classical Vandermonde formula; the closed form $y^{\binom{k+1}{3}}\prod_{d}(y^d-1)^{k+1-d}$ and $\kappa_\nu=\prod_{\nu'\ne\nu}\frac{1+\xi_{\nu'}}{|\xi_\nu-\xi_{\nu'}|}$ are exact, not estimated. The total positivity of generalized Vandermonde matrices, and Prony-method conditioning, are **search-summary grade prior art** (§0) — no document was fetched; nothing below depends on them, since the proofs are written. |
| Y5 | Theorem L5 (B2″ sufficiency) | **Proved** under H1–H5, H6′. It is S1 + L2 + triangle inequality; the only substantive corrections to B2′ are the tapered test function and the vacuity of the $\nu<0$ conditions. The constants $\beta_k=(1+|g_a|+|D_a(0)|)^k$ and $\Sigma_k$ are closed forms, and every threshold is quoted with its $X$-dependence (`HOLOGRAM.md` §7). |
| Y6 | Theorem L6 / Corollary L6′ (peeling, necessity) | **Proved** given that each $C_\nu$ is u.a.p. and bounded (S2 + Bohr). Uses two textbook facts about uniformly almost periodic functions — relative density of $\varepsilon$-almost-periods, and $C\to0\Rightarrow C\equiv0$ — **quoted from memory and corroborated by search summary only; no source was fetched** (egress is fetch-blocked). Both are standard Bohr theory and neither is delicate. |
| Y7 | Theorem L8(b),(d) | **Corrected/retracted.**  ~~A drift lower bound inside L7's upper bound gives an extraction-error lower bound; under LI, small density of good spacings implies no admissible spacing exists.~~  Neither inference is valid.  The exact replacement is $\ell_\nu(\xi_\mu e^{i\gamma\Delta})$ per Bohr mode (`BARRIER_LEVEL_EXTRACTION_CORRECTION.md`); it proves generic-spacing leakage.  L8(a) and L8(c) survive only as statements about raw drift.  Universal quantitative finite impossibility is open. |
| Y8 | The span-variation remark (§5.3) | **Proved for the boxcar**, where $\widetilde\Theta_\phi(\theta)=\theta^{-1}(1-e^{-\theta})$ is exact (Lemma 5.4/Lemma 6). The rank-one determinant expansion is the standard multilinearity identity. For a general profile I have **not** shown the leading part is rank one, only that it is $\frac{2}{\nu L}(1+o(1))$ for a profile with $|\phi(t_+-v)|\sim c$; the remark should not be quoted beyond the boxcar without that check. |
| Y9 | Theorem L9 ($\lambda$) | **Proved, trivially, and that is the point**: $\vartheta_\lambda=0$ makes every node equal to $1$. The claim that frequency separation is *also* partial is argued (shared frequencies across arities differing by $2$) but not quantified; the quantitative statement in the corpus is exp19's **measurement**, quoted as corroboration and explicitly not as evidence — per `CLAUDE.md`, the theorem here is the derivation, and the measurement is a check on it. |
| Y10 | What is not attempted | (i) Modelling and subtracting the level-$(k-1)$ arity-$1$ layer instead of annihilating it — the one route that could reopen finite separation of level $0$, and a new `PROVE` item; (ii) mixed dressings across the $k$ variables (exp18's $\Lambda\otimes\mu$), where the level formula becomes $\nu=\sum_i\nu_i$ and Theorem L1's collision law needs redoing per assignment; (iii) $a=d$, out of scope by H3/H4 and struck in `BARRIER_SMOOTH_TERM.md` §5.3 — **not readmitted here**. |
| Y11 | Prior art | Corpus prior art searched **before** the derivation and cited in §0: `FAMILY.md` §2 law 2 (the $k=2$ level spectrum), exp19 (the measured $\lambda$ crowding), `BARRIER_ERROR_WINDOW.md` Lemma 5, `BARRIER_UNIFORM.md` U3(iii), `BARRIER_SMOOTH_TERM.md` S1/S2/S4/§4. External prior art (generalized Vandermonde total positivity; Prony's method and its Vandermonde conditioning; Bohr almost-periodicity) was searched by web query in this container: **WebSearch works, document fetch is blocked, so those citations are search-summary (śabda) grade and nothing here rests on them** — every external ingredient used is also proved in place. |
| Y12 | No numerics | Nothing was computed. Every constant is a closed form: $\beta_k=(1+|g_a|+|D_a(0)|)^k$, $\kappa_\nu$, $\det V=y^{\binom{k+1}{3}}\prod_d(y^d-1)^{k+1-d}$, the fiber sizes $\lfloor(k-|\nu|)/2\rfloor+1$, $g_\lambda=\sqrt\pi/(2\zeta(\tfrac12))$. Every exponent is $\nu(r,m)=r(2\theta_a-1)-m$ for integers $r,m$. No slope is fitted; every bound carries its $X$-dependence, and the two that do not ($\kappa_\nu$, $\beta_k$) are $X$-free **by proof**, which is stated where they appear. |
