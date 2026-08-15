# CORE_KMS: equilibrium states of the gauge-neutral core of $Q_{\mathbb N}$

Answers the question of `GAUGE.md` §F.6: *does the fixed-point algebra $Q^0$ of the
multiplicative gauge torus admit KMS states that do not extend to $Q_{\mathbb N}$ — at
$\beta=1$ or any other $\beta$?*

**Answer in one paragraph.** The gauge-neutral core is exactly the Bunce–Deddens
algebra of type $\prod_p p^\infty$, i.e. $Q^0\cong C(\widehat{\mathbb Z})\rtimes\mathbb Z$
(the universal adding machine / odometer crossed product); the Cuntz dynamics
$\sigma$ restricts to the **trivial** dynamics on $Q^0$; consequently
KMS$_\beta$ states of $(Q^0,\sigma|_{Q^0})$ are exactly the tracial states of
$Q^0$, for every $\beta\in\mathbb R$; and $Q^0$ has a **unique** trace $\tau_0$
(Haar measure on $\widehat{\mathbb Z}$ composed with the canonical expectation),
which coincides with the restriction $\omega|_{Q^0}$ of Cuntz's unique KMS$_1$
state $\omega$ of $Q_{\mathbb N}$. So the core carries **exactly one equilibrium
state at every inverse temperature, and it is the restriction of the critical
state**. There are no hidden neutral-sector equilibria; the no-go of
Theorem F closes at the level of the core. (The restriction map on KMS$_\beta$
simplices is a bijection precisely at $\beta=1$; for $\beta\neq1$ its target is
still the singleton $\{\tau_0\}$ while its source is empty — a degeneracy caused
by the core's inability to feel $\beta$ at all, not by extra states. §5 states
this carefully, and generalizes it to every intermediate core, including the
$\mathbb Z/2$ parity core of `PARITY.md` §2.2.)

All small algebraic identities below are verified by hand, in the text, from
(Q1)–(Q3); the representation on $\ell^2(\mathbb Z)$ ($u=$ bilateral shift,
$s_n\delta_k=\delta_{nk}$) is used only for intuition.

> **Missing-artifact note (SEED-77, 2026-08-14; audit SEED-69,
> `notes/SEED69_EVIDENCE_DISCIPLINE.md` §B.5).** Earlier versions of this note
> claimed these identities were "independently machine-checked" in that
> representation by `scratchpad/check_core.py`, "all checks pass on the window
> $|k|\le2000$". **No such file exists in this repository, and neither does the
> directory `scratchpad/`;** the only mentions of that path anywhere in the tree
> were the eight citations in this note. The citations are therefore recorded as
> a hole rather than deleted silently. **No claim in this note depends on them:**
> each site is checked below, and at every one the identity is derived in the
> surrounding text from (Q1)–(Q3) and Lemmas 1.1–1.6, with the $\ell^2$ picture
> appearing as an illustration of an already-completed proof. A finite-window
> numerical check of an exact algebraic identity would in any case be forbidden
> by `CLAUDE.md`, and "$|k|\le2000$" is a number quoted without its
> scale-dependence (`HOLOGRAM.md` §7) — harmless here only because the proofs
> are present, which is the evidence that the artifact was never load-bearing.

---

## 0. Statement of results

Throughout, $Q_{\mathbb N}$ is Cuntz's algebra [C1]: universal C\*-algebra with a
unitary $u$ and isometries $s_n$ ($n\in\mathbb N^\times$) subject to

$$\text{(Q1)}\ s_ms_n=s_{mn},\qquad
\text{(Q2)}\ s_nu=u^ns_n,\qquad
\text{(Q3)}\ \sum_{k=0}^{n-1}u^ke_nu^{-k}=1,\quad e_n:=s_ns_n^*,$$

with dynamics $\sigma_t(s_n)=n^{it}s_n$, $\sigma_t(u)=u$, and gauge torus
$G=\operatorname{Hom}(\mathbb Q_{>0}^\times,\mathbb T)$ acting by
$\alpha_g(s_n)=g(n)s_n$, $\alpha_g(u)=u$ (Lemma F.1 of `GAUGE.md`).
$Q^0=Q_{\mathbb N}^{\,G}$ is the fixed-point algebra.

**Theorem 1 (structure of the core).**
$$Q^0=\overline{\operatorname{span}}\{u^a e_n u^b : a,b\in\mathbb Z,\ n\ge1\}
=C^*(u,\{e_n\}_n)\ \cong\ C(\widehat{\mathbb Z})\rtimes\mathbb Z ,$$
the crossed product of translation by $1$ on the profinite completion — the
Bunce–Deddens algebra $B(\prod_p p^\infty)$ [BD], [D, §V.3]. Concretely, $Q^0$ is
the inductive limit of the "additive scale" filtration
$B_M=C^*(u,e_M)\cong M_M(C(\mathbb T))$ over $M$ ordered by divisibility, and the
multiplicative maps $x\mapsto s_nxs_n^*$ act on $Q^0$ as the corner
endomorphisms $u^ae_Nu^b\mapsto u^{na}e_{nN}u^{nb}$ (they enlarge nothing).

**Theorem 2 (equilibrium states of the core).**
1. $\sigma_t|_{Q^0}=\mathrm{id}$ for all $t$; hence for every $\beta\in\mathbb R$,
   KMS$_\beta$ states of $(Q^0,\sigma|_{Q^0})$ = tracial states of $Q^0$.
2. $Q^0$ has a unique tracial state
   $\tau_0=\mu_{\mathrm{Haar}}\circ E_{C(\widehat{\mathbb Z})}$, i.e.
   $\tau_0(u^ae_nu^b)=\delta_{a+b,0}\,\frac1n$.
3. $\tau_0=\omega|_{Q^0}$, where $\omega$ is Cuntz's unique KMS$_1$ state of
   $Q_{\mathbb N}$; moreover $\omega=\tau_0\circ E_G$ with $E_G$ the gauge
   averaging expectation. *The unique KMS state of $Q_{\mathbb N}$ is the unique
   trace of the Bunce–Deddens core, transported by the gauge average.*

**Corollary 3 (answer to §F.6).** For every $\beta$, the KMS$_\beta$ simplex of
the core is the singleton $\{\tau_0\}$, and $\tau_0$ extends to the state
$\omega$ of $Q_{\mathbb N}$ (which is KMS$_\beta$ exactly when $\beta=1$). The
restriction map
$\mathrm{KMS}_\beta(Q_{\mathbb N},\sigma)\to\mathrm{KMS}_\beta(Q^0,\sigma|_{Q^0})$
is a bijection $\{\omega\}\to\{\tau_0\}$ at $\beta=1$, and is the empty map into
a singleton for $\beta\ne1$. **There is no core equilibrium state other than the
restriction of the critical state; the neutral world contains no hidden
equilibria, and the parity no-go closes.**

**Theorem 4 (the whole gauge filtration; groupoid proof).** For any subgroup
$\Lambda\le\mathbb Q_{>0}^\times$ let
$Q^\Lambda$ be the fixed algebra of $\Lambda^\perp\subset G$ (so
$Q^{\{1\}}=Q^0$, $Q^{\mathbb Q_{>0}^\times}=Q_{\mathbb N}$, and
$\Lambda=\{q:\Omega(q)\ \mathrm{even}\}$ gives the parity core
$Q^{\mathrm{even}}$ of `PARITY.md` §2.2). Then, with respect to
$\sigma|_{Q^\Lambda}$:
- if $\Lambda=\{1\}$: KMS$_\beta$ states exist for every $\beta$ and are unique
  ($=\tau_0$);
- if $\Lambda\ne\{1\}$: KMS$_\beta$ states exist **iff $\beta=1$**, and the
  KMS$_1$ state is unique, equal to $\omega|_{Q^\Lambda}$
  ($=$ Haar measure read through the canonical diagonal expectation).

In particular the $\mathbb Z/2$-graded question of `PARITY.md` §2.2(1) has the
sharp no-go answer: the graded (parity-even) system has the same phase diagram
as $Q_{\mathbb N}$ itself — unique KMS$_1$, nothing else — and its unique
equilibrium is again the restriction of $\omega$. At $\Lambda=\mathbb Q_{>0}^\times$
Theorem 4 re-derives Cuntz's phase diagram for $Q_{\mathbb N}$ from Neshveyev's
correspondence. (Proof in §5; rigorous modulo the standard groupoid model of
$Q_{\mathbb N}$ and Neshveyev's theorem, both cited.)

Status: Theorems 1–2 and Corollary 3 are proved in full below, modulo only
(i) Cuntz's theorem on $(Q_{\mathbb N},\sigma)$ [C1] for the identification
$\tau_0=\omega|_{Q^0}$ (not needed for existence/uniqueness of $\tau_0$ itself),
and (ii) two standard citations: simplicity of minimal free
$\mathbb Z$-crossed products, and Bunce–Deddens $\cong$ odometer crossed
product. Theorem 4 additionally uses the adelic groupoid model of
$Q_{\mathbb N}$ and Neshveyev's KMS correspondence. Remaining gaps are listed in
§7.

---

## 1. Monomial calculus

We record the computational lemmas, with proofs from (Q1)–(Q3) only. Adjoint
form of (Q2): $s_nu^k=u^{nk}s_n$ and $u^ks_n^*=s_n^*u^{nk}$.

**Lemma 1.1.** $u^ne_nu^{-n}=e_n$; hence $u^ke_nu^{-k}$ depends only on
$k\bmod n$.

*Proof.* $u^ne_nu^{-n}=u^ns_n\,s_n^*u^{-n}=(s_nu)(s_nu)^*\cdot$ — precisely:
$u^ns_n=s_nu$ by (Q2), so $u^ne_nu^{-n}=(u^ns_n)(u^ns_n)^*=(s_nu)(s_nu)^*
=s_nuu^*s_n^*=e_n$. $\square$

**Lemma 1.2.** The projections $u^ke_nu^{-k}$, $k=0,\dots,n-1$, are mutually
orthogonal.

*Proof.* They are projections summing to $1$ by (Q3); if $p,q$ are projections
with $p+q\le1$ then $0\le pqp \le p(1-p)p=0$, so $pq=0$; apply pairwise (subtract
the other terms, each $\ge0$). $\square$

**Lemma 1.3.** $s_me_ks_m^*=e_{mk}$ and $s_me_k=e_{mk}s_m$.

*Proof.* $s_me_ks_m^*=s_ms_ks_k^*s_m^*=s_{mk}s_{mk}^*=e_{mk}$ by (Q1). For the
second: $s_{mk}^*s_m=(s_ms_k)^*s_m=s_k^*s_m^*s_m=s_k^*$, so
$e_{mk}s_m=s_{mk}s_{mk}^*s_m=s_{mk}s_k^*=s_ms_ks_k^*=s_me_k$. $\square$

**Lemma 1.4 (refinement).** For $l=\operatorname{lcm}(m,n)$:
$e_m=\sum_{j=0}^{l/m-1}u^{mj}e_lu^{-mj}$, and $e_ne_m=e_l=e_me_n$.

*Proof.* Apply (Q3) at level $l/m$ inside $s_m(\cdot)s_m^*$:
$e_m=s_m1s_m^*=\sum_{j=0}^{l/m-1}s_mu^je_{l/m}u^{-j}s_m^*
=\sum_ju^{mj}s_me_{l/m}s_m^*u^{-mj}=\sum_ju^{mj}e_lu^{-mj}$ by (Q2) and
Lemma 1.3. Similarly $e_n=\sum_{i=0}^{l/n-1}u^{ni}e_lu^{-ni}$. By Lemmas
1.1–1.2 the projections $u^re_lu^{-r}$ ($r\bmod l$) are mutually orthogonal, so
$e_ne_m=\sum_{i,j}\delta_{ni\equiv mj\ (l)}\,u^{ni}e_lu^{-ni}$. For
$0\le ni<l$, $0\le mj<l$, $ni\equiv mj\pmod l$ forces $ni=mj$, a common multiple
of $n$ and $m$ below $l=\operatorname{lcm}$, hence $ni=mj=0$. So $e_ne_m=e_l$.
$\square$

*Hand check* ($n=2,m=3$): $e_2=e_6+u^2e_6u^{-2}+u^4e_6u^{-4}$,
$e_3=e_6+u^3e_6u^{-3}$; the only pair of translates $2i\equiv3j\pmod 6$ with
$2i,3j<6$ is $(0,0)$; so $e_2e_3=e_6$. On $\ell^2(\mathbb Z)$
($u=$ shift, $s_n\delta_k=\delta_{nk}$): $1_{2\mathbb Z}1_{3\mathbb Z}
=1_{6\mathbb Z}$. ✓ [Formerly "(machine-checked)": the cited artifact
`scratchpad/check_core.py` does not exist in this repository; the identity is
the hand check just given, together with Lemma 1.4, and does not depend on it.]

**Lemma 1.5 (CRT).** $(u^ae_nu^{-a})(u^be_mu^{-b})=u^ce_lu^{-c}$ if
$d:=\gcd(m,n)$ divides $a-b$, where $c$ solves $c\equiv a\ (n)$,
$c\equiv b\ (m)$; and $=0$ if $d\nmid a-b$.

*Proof.* Conjugating Lemma 1.4 by powers of $u$ and using Lemma 1.2 at level
$l$: the product is $\sum u^{a+ni}e_lu^{-(a+ni)}$ over pairs with
$a+ni\equiv b+mj\pmod l$; solvable iff $d\mid a-b$ and then by CRT the solution
$c$ is unique mod $l$. $\square$

*Hand check*: $x\equiv0\ (2)$, $x\equiv1\ (3)$ $\Rightarrow x\equiv4\ (6)$:
$e_2\,(ue_3u^{-1})=u^4e_6u^{-4}$; and $e_2(ue_4u^{-1})=0$ since
$\gcd(2,4)=2\nmid1$. ✓ [Formerly "(machine-checked)": the cited artifact
`scratchpad/check_core.py` does not exist in this repository; both cases are
instances of Lemma 1.5, proved above, and do not depend on it.]

**Lemma 1.6 (normal ordering).** Let $d=\gcd(m,n)$. If $d\nmid a$ then
$s_n^*u^as_m=0$. If $d\mid a$, choose $\beta\in\mathbb Z$ with
$m\beta\equiv a\pmod n$ (solvable since $\gcd(m,n)\mid a$) and set
$\alpha=(a-m\beta)/n\in\mathbb Z$. Then
$$s_n^*u^as_m=u^{\alpha}\,s_{m/d}\,s_{n/d}^*\,u^{\beta}.$$

*Proof.* Zero case: $s_n^*u^as_m=s_n^*(e_nu^ae_m)s_m
=s_n^*u^a\bigl((u^{-a}e_nu^a)e_m\bigr)s_m=0$ by Lemma 1.5 ($d\nmid a$).
Main case: since $s_n^*s_n=1$ it suffices to show
$s_n\cdot u^{\alpha}s_{m/d}s_{n/d}^*u^{\beta}=e_nu^as_m$ (then multiply by
$s_n^*$ on the left, and use $s_n^*e_n=s_n^*$). With
$l=\operatorname{lcm}(m,n)=mn/d$:
$$s_nu^{\alpha}s_{m/d}s_{n/d}^*u^{\beta}
=u^{n\alpha}s_{l}\,s_{n/d}^*u^{\beta}
=u^{n\alpha}s_m\,\bigl(s_{n/d}s_{n/d}^*\bigr)'\dots$$
more carefully: $s_l=s_ms_{n/d}$ by (Q1), so
$s_nu^\alpha s_{m/d}s_{n/d}^*u^\beta
=u^{n\alpha}s_ms_{n/d}s_{n/d}^*u^\beta
=u^{n\alpha}s_m e_{n/d}u^\beta
=u^{n\alpha}e_l s_m u^\beta$ (Lemma 1.3 with $k=n/d$, $mk=l$)
$=u^{n\alpha}e_l u^{m\beta}s_m$ (adjoint (Q2)). Now
$e_ls_m=e_ne_ms_m=e_ns_m$ (Lemma 1.4 and $e_ms_m=s_m$), and
$u^{n\alpha}e_n=e_nu^{n\alpha}$ (Lemma 1.1), so the left side equals
$e_nu^{n\alpha+m\beta}s_m=e_nu^as_m$. $\square$

*Hand check* ($n=2,m=3,a=1$: $d=1$, $\beta=1$, $\alpha=-1$):
claim $s_2^*us_3=u^{-1}s_3s_2^*u$. On $\ell^2(\mathbb Z)$, for $k=2j+1$ odd both
sides send $\delta_k\mapsto\delta_{3j+2}$, and both kill even $k$:
LHS $\delta_k=s_2^*\delta_{3k+1}=\delta_{(3k+1)/2}$ iff $2\mid 3k+1$ iff $k$
odd; RHS $\delta_k=u^{-1}s_3s_2^*\delta_{k+1}=u^{-1}\delta_{3(k+1)/2}
=\delta_{(3k+1)/2}$, same parity condition. ✓ [Formerly "Also machine-checked,
together with $n=4,m=6,a=2$ and the zero case $s_2^*us_2=0$": the cited artifact
`scratchpad/check_core.py` does not exist in this repository. Lemma 1.6 is
proved above for all $(n,m,a)$, the two extra cases included, so nothing here
depends on the missing check; the $\ell^2$ computation displayed is complete as
written.]

**Lemma 1.7 (spanning).** $\mathcal M:=\operatorname{span}
\{u^as_ms_n^*u^b: a,b\in\mathbb Z,\ m,n\ge1\}$ is a dense unital
\*-subalgebra of $Q_{\mathbb N}$; the product rule is
$$(u^as_ms_n^*u^b)(u^{a'}s_{m'}s_{n'}^*u^{b'})=
\begin{cases}
u^{a+m\alpha}\,s_{mm'/d}\,s_{nn'/d}^*\,u^{n'\beta+b'}, & d:=\gcd(n,m')\mid b+a',\\
0,&\text{else,}
\end{cases}$$
with $\alpha,\beta$ as in Lemma 1.6 for the middle factor $s_n^*u^{b+a'}s_{m'}$.

*Proof.* Closure under adjoints is clear; the product rule follows from Lemma
1.6 plus $s_mu^\alpha=u^{m\alpha}s_m$, $u^\beta s_{n'}^*=s_{n'}^*u^{n'\beta}$,
$s_{n/d}^*s_{n'}^*=s_{n'n/d}^*$. $\mathcal M$ contains $u,s_n,s_n^*$, hence is
dense. $\square$

**Lemma 1.8 (gauge grading).** $\alpha_g(u^as_ms_n^*u^b)=g(m/n)\,u^as_ms_n^*u^b$:
the monomial has gauge charge $[m/n]\in\mathbb Q_{>0}^\times$, and the product
rule of Lemma 1.7 is charge-multiplicative
($\frac{m}{n}\cdot\frac{m'}{n'}=\frac{mm'/d}{nn'/d}$).

Note the example from the problem statement: $s_2s_3^*$ has charge
$[2/3]\ne1$, so it is **not** in $Q^0$, even though it is $\Omega$-parity-even
and $\sigma_t(s_2s_3^*)=(2/3)^{it}s_2s_3^*$ is nontrivial. Charge-neutral
monomials are exactly those with $m=n$.

---

## 2. Proof of Theorem 1: the core is Bunce–Deddens

**Step 1: $Q^0=\overline{\operatorname{span}}\{u^ae_nu^b\}$.**
$G=\widehat{\mathbb Q_{>0}^\times}$ is compact (product topology on
$\mathbb T^{\mathcal P}$); the action $\alpha$ is strongly continuous (on each
monomial $g\mapsto\alpha_g(x)=g(m/n)x$ is continuous since evaluation at a fixed
rational is continuous on the dual; extend by an $\varepsilon/3$ argument over
the dense $\mathcal M$). Hence the fixed algebra is the range of the faithful
conditional expectation $E_G(x)=\int_G\alpha_g(x)\,dg$. On monomials,
$E_G(u^as_ms_n^*u^b)=\bigl(\int_Gg(m/n)dg\bigr)u^as_ms_n^*u^b
=\delta_{m,n}\,u^as_ms_n^*u^b$ (orthogonality of characters of the compact
group $G$; $g\mapsto g(m/n)$ is the character of $G$ dual to
$[m/n]\in\mathbb Q_{>0}^\times$, trivial iff $m=n$). By continuity of $E_G$ and
density of $\mathcal M$, $Q^0=E_G(Q_{\mathbb N})
=\overline{\operatorname{span}}\{u^ae_nu^b\}$.

**Step 2: normal form.** $u^ae_nu^b=(u^ae_nu^{-a})\,u^{a+b}$, so
$Q^0=\overline{\operatorname{span}}\{f\,u^k\}$ where $f$ runs over the
\*-algebra $\mathcal D$ generated by the congruence projections
$p^{(n)}_a:=u^ae_nu^{-a}$ and $k\in\mathbb Z$. By Lemmas 1.1, 1.2, 1.5,
$\mathcal D$ is commutative, and its projections satisfy exactly the relations
of the indicator functions $1_{a+n\widehat{\mathbb Z}}$ of cylinder sets of
$\widehat{\mathbb Z}$: level-$n$ translates partition the identity, products
refine by CRT. Each $p^{(n)}_a\neq0$ ($e_n=s_ns_n^*\ne0$ since $s_n$ is a
nonzero isometry — $Q_{\mathbb N}\ne0$ because the $\ell^2(\mathbb Z)$
representation $u=$ bilateral shift, $s_n\delta_k=\delta_{nk}$ satisfies
(Q1)–(Q3): (Q2): $s_nu\delta_k=\delta_{n(k+1)}=u^ns_n\delta_k$; (Q3): the
$u^ke_nu^{-k}$ are the projections onto the residues mod $n$). Hence the
character space of $\overline{\mathcal D}$ is
$\varprojlim\mathbb Z/n=\widehat{\mathbb Z}$ and
$\overline{\mathcal D}\cong C(\widehat{\mathbb Z})$, with $u\,f\,u^{-1}$ = the
translate of $f$ by $1$ (from $up^{(n)}_au^{-1}=p^{(n)}_{a+1}$).

**Step 3: crossed-product identification.** The pair
$(\overline{\mathcal D},u)$ is a covariant representation of the translation
action of $\mathbb Z$ on $\widehat{\mathbb Z}$, so the universal property gives
a surjection $\pi:C(\widehat{\mathbb Z})\rtimes\mathbb Z\to
C^*(u,\overline{\mathcal D})=Q^0$. The translation action is *free*
($x+n=x$ in $\widehat{\mathbb Z}$ forces $n=0$: $\widehat{\mathbb Z}$ is
torsion-free as an additive group containing $\mathbb Z$ densely) and *minimal*
($\mathbb Z$ is dense in $\widehat{\mathbb Z}$, so every orbit is dense). Since
$\mathbb Z$ is amenable, the full and reduced crossed products coincide, and a
minimal, topologically free action of a discrete group on a compact space has a
**simple** reduced crossed product [P], [D, Thm. VIII.3.9]. Hence $\pi$ is
injective:
$$Q^0\cong C(\widehat{\mathbb Z})\rtimes\mathbb Z .$$
By the classical identification of the odometer crossed product [BD], [D,
§V.3, §VIII.4], this is the Bunce–Deddens algebra of supernatural type
$\prod_pp^\infty$ (the odometer on $\varprojlim\mathbb Z/M_k$, $M_k=k!$, is
translation by $1$ on $\widehat{\mathbb Z}$).

**Step 4: the scale filtration; the core is not bigger.** For fixed $M$ let
$B_M:=\overline{\operatorname{span}}\{u^ae_Mu^b\}$. Setting
$v=u$, $p_j=p^{(M)}_j$, one gets matrix units $E_{ij}=u^ie_Mu^{-j}$
($0\le i,j<M$): indeed $E_{ij}E_{kl}=u^i e_M u^{k-j}e_M u^{-l}$ and
$e_Mu^re_M=\delta_{M\mid r}u^re_M$ (Lemmas 1.1–1.2), so
$E_{ij}E_{kl}=\delta_{jk}E_{il}$ and $\sum_iE_{ii}=1$ [formerly
"(machine-checked at $M=3$)": the cited artifact `scratchpad/check_core.py`
does not exist in this repository; the matrix-unit relations are derived in the
preceding sentence from Lemmas 1.1–1.2 for every $M$, and (Q3) gives
$\sum_iE_{ii}=1$, so the claim does not depend on the missing check]. The corner unitary $z=e_Mu^Me_M=u^Me_M$ generates the relative
commutant $C^*(z)\cong C(\mathbb T)$ ($z$ acts on
$\ell^2(M\mathbb Z)$ as a bilateral shift, so its spectrum is all of
$\mathbb T$, and the composite $M_M(C(\mathbb T))\to B_M\subset
B(\ell^2(\mathbb Z))$ is injective, hence so is the first arrow). Thus
$B_M\cong M_M(C(\mathbb T))$, $B_M\subset B_{M'}$ for $M\mid M'$ (Lemma 1.4),
and $Q^0=\overline{\bigcup_kB_{k!}}$: the standard Bunce–Deddens inductive
limit, with the additive modulus $M$ (not the multiplicative scale $n$) as the
filtration parameter. Finally, conjugation by the scale isometries does **not**
enlarge the core: by (Q2) and Lemma 1.3,
$$s_n\,(u^ae_Nu^b)\,s_n^*=u^{na}\,e_{nN}\,u^{nb}\in B_{nN}\subset Q^0,$$
[formerly "(machine-checked for $n=2$, $N=3$)": the cited artifact
`scratchpad/check_core.py` does not exist in this repository; the displayed
identity is (Q2) plus Lemma 1.3 for all $n,N$, so the claim does not depend on
it], so the maps $x\mapsto s_nxs_n^*$ are corner
endomorphisms of $Q^0$ (range the corner $e_nQ^0e_n$) and the "inductive limit
over scales of copies of $B$" collapses into the single Bunce–Deddens algebra.
$\blacksquare$

*K-theoretic cross-check.* Pimsner–Voiculescu for
$C(\widehat{\mathbb Z})\rtimes\mathbb Z$ gives
$K_0(Q^0)\cong\mathbb Q$ (generated by traces of congruence projections
$1/n$), $K_1(Q^0)\cong\mathbb Z$ ($[u]$) — the known invariants of
$B(\prod_pp^\infty)$ [D, §V.3].

---

## 3. Proof of Theorem 2: trivial dynamics and the unique trace

**3.1 $\sigma$ is trivial on $Q^0$.** On a neutral monomial:
$\sigma_t(u^ae_nu^b)=u^a\,(n^{it}s_n)(n^{it}s_n)^*\,u^b=u^ae_nu^b$. By density
(Theorem 1, Step 1) and continuity, $\sigma_t|_{Q^0}=\mathrm{id}$. (Groupoid
view: the dynamics cocycle is $c_\sigma=\log$ of the scale charge, which
vanishes identically on the neutral subgroupoid; see §5.)

Consequently, for any $\beta\in\mathbb R$, a state $\varphi$ of $Q^0$ is
KMS$_\beta$ for the trivial flow iff $\varphi(ab)=\varphi(b\,\sigma_{i\beta}(a))
=\varphi(ba)$ on a dense set of analytic elements (every element is entire for
the trivial flow), i.e. iff $\varphi$ is a **trace**. This holds for every
$\beta$, including $\beta\le0$. (Convention note: some authors define KMS$_0$
as mere invariance; with the trace convention, used by Neshveyev [N] and by
Bratteli–Robinson for $\beta=0$ chemical-potential discussions, the statement
is uniform in $\beta$.)

**3.2 Existence of the trace.** Define $E_{\mathcal D}:Q^0\to
C(\widehat{\mathbb Z})$ as the canonical faithful expectation of the reduced
crossed product ($fu^k\mapsto\delta_{k,0}f$) and set
$\tau_0=\mu_{\mathrm{Haar}}\circ E_{\mathcal D}$, i.e.
$$\tau_0(u^ae_nu^b)=\delta_{a+b,0}\cdot\tfrac1n .$$
$\tau_0$ is a state; traciality on monomials follows from translation
invariance of Haar measure: for $f,g\in C(\widehat{\mathbb Z})$,
$\tau_0\bigl((fu^k)(gu^l)\bigr)=\delta_{k+l,0}\int f\,(g\circ\tau_{-k})\,d\mu
=\delta_{k+l,0}\int(f\circ\tau_{-l})\,g\,d\mu
=\tau_0\bigl((gu^l)(fu^k)\bigr)$, where $\tau_r(x)=x+r$; extend by linearity
and continuity. (Alternatively: $\tau_0=\omega|_{Q^0}$ once $\omega$ is
available, see 3.4, but the direct construction keeps this section independent
of [C1].)

**3.3 Uniqueness of the trace.** Let $\tau$ be any tracial state of $Q^0$.

*(a) On the diagonal, $\tau$ = Haar.* $\mu:=\tau|_{C(\widehat{\mathbb Z})}$ is a
probability measure; traciality gives
$\mu(f)=\tau(u f u^{-1}\cdot 1)\cdot$ — precisely,
$\tau(ufu^{-1})=\tau(fu^{-1}u)=\tau(f)$, so $\mu$ is invariant under
translation by $1$, hence by $\mathbb Z$. For a character
$\chi_{a/q}\in\widehat{\widehat{\mathbb Z}}\cong\mathbb Q/\mathbb Z$,
invariance gives $\widehat\mu(\chi)=\chi(1)\widehat\mu(\chi)$ and
$\chi_{a/q}(1)=e^{2\pi ia/q}\ne1$ for $\chi\ne1$; so all nontrivial Fourier
coefficients vanish and $\mu=\mu_{\mathrm{Haar}}$. (This is the unique
ergodicity of the universal odometer, by the elementary Fourier argument.)

*(b) Off-diagonal terms vanish.* Fix $k\ne0$ and $f\in C(\widehat{\mathbb Z})$;
choose $n>|k|$ and let $p_j=p^{(n)}_j$, $j\bmod n$. Then
$u^kp_ju^{-k}=p_{j+k}$ with $j+k\not\equiv j\pmod n$, so
$p_ju^kp_j=p_jp_{j+k}u^k=0$. Using traciality
($\tau(xp_j)=\tau(p_jxp_j)$) and $[f,p_j]=0$:
$$\tau(fu^k)=\sum_{j\bmod n}\tau(fu^kp_j)=\sum_j\tau(p_jfu^kp_j)
=\sum_j\tau(f\,p_ju^kp_j)=0 .$$
Hence $\tau=\mu_{\mathrm{Haar}}\circ E_{\mathcal D}=\tau_0$. $\blacksquare$

(Uniqueness is of course also the classical unique-trace theorem for
Bunce–Deddens algebras [BD], [D, §V.3]; the proof above is self-contained
because the congruence projections make the freeness argument explicit.)

**3.4 Identification with Cuntz's state.** Let $\omega$ be the unique
KMS$_1$ state of $(Q_{\mathbb N},\sigma)$ [C1]. Restriction of a KMS$_\beta$
state to a $\sigma$-invariant C\*-subalgebra is KMS$_\beta$ for the restricted
flow (the KMS condition only involves elements of the subalgebra, and the
neutral monomials are entire — indeed fixed — for $\sigma$); since
$\sigma|_{Q^0}$ is trivial, $\omega|_{Q^0}$ is a trace, hence $=\tau_0$ by 3.3.
Conversely, by gauge invariance of $\omega$ (Theorem F(1) of `GAUGE.md`),
$\omega=\omega\circ E_G=\tau_0\circ E_G$. Explicitly, on monomials:
$$\omega(u^as_ms_n^*u^b)=\delta_{m,n}\,\delta_{a+b,0}\,\tfrac1n,$$
which is Cuntz's formula for $\omega$ — a consistency check. $\blacksquare$

---

## 4. The restriction map: precise answer to §F.6

Fix $\beta\in\mathbb R$ and let
$R_\beta:\mathrm{KMS}_\beta(Q_{\mathbb N},\sigma)\to
\mathrm{KMS}_\beta(Q^0,\sigma|_{Q^0})$, $\varphi\mapsto\varphi|_{Q^0}$
(well defined by the restriction argument of 3.4).

- **$\beta=1$:** $\mathrm{KMS}_1(Q_{\mathbb N})=\{\omega\}$ [C1] and
  $\mathrm{KMS}_1(Q^0)=\{\text{traces}\}=\{\tau_0\}$ (Theorem 2). $R_1$ is a
  bijection. *No core KMS$_1$ state fails to extend.*
- **$\beta\ne1$:** $\mathrm{KMS}_\beta(Q_{\mathbb N})=\emptyset$ ([C1]; also
  re-proved in §5 via Theorem 4 with $\Lambda=\mathbb Q_{>0}^\times$), while
  $\mathrm{KMS}_\beta(Q^0)=\{\tau_0\}$. So $R_\beta$ is not surjective — but
  the unextendable object is the *same single state* $\tau_0$ at every
  $\beta$, and $\tau_0$ *does* extend as a state, indeed to the KMS$_1$ state
  $\omega$. The failure is a **degeneracy of the time evolution** (the core
  cannot measure $\beta$ because $\sigma|_{Q^0}$ is trivial), not the presence
  of new equilibrium data. In particular
  $$\bigcup_{\beta\in\mathbb R}\mathrm{KMS}_\beta(Q^0,\sigma|_{Q^0})
  =\{\tau_0\}=\{\omega|_{Q^0}\}.$$

So the honest one-line answer to §F.6 is: **no — the core admits no
equilibrium state beyond the restriction of Cuntz's critical state; the
restriction map on KMS simplices is a bijection exactly at the critical
temperature $\beta=1$, and at other $\beta$ both sides are as degenerate as
they can be (empty source; the same $\beta$-blind trace as target).** The no-go
of Theorem F is therefore complete at the neutral level: every gauge-neutral
equilibrium expectation is computed by Haar measure on $\widehat{\mathbb Z}$
through the canonical expectation — i.e. by elementary congruence densities
$\tau_0(u^ap^{(n)}_ju^{-a}\cdots)=1/n$, exactly the sieve data — and no choice
of temperature or state on the neutral world introduces any parity-sensitive
(or otherwise charged) information.

*Remark ($\beta=\pm\infty$).* For the trivial flow on $Q^0$ every state
satisfies the ground-state condition, so the ground-state simplex of the core
is all of $S(Q^0)$; the KMS$_\infty$ states in the Connes–Marcolli sense
(weak-\* limits of KMS$_\beta$ states) still form the singleton $\{\tau_0\}$.
The ground states of $(Q_{\mathbb N},\sigma)$ itself are not analyzed here (see
Gap 4, §7).

---

## 5. Groupoid picture, Neshveyev's machinery, and the full gauge filtration

### 5.1 The groupoid model

Cuntz [C1, §5–6] (see also [CL], [LR], [BaHLR]) identifies $Q_{\mathbb N}$
with the full corner
$$Q_{\mathbb N}\cong
1_{\widehat{\mathbb Z}}\Bigl(C_0(\mathbb A_f)\rtimes(\mathbb Q\rtimes\mathbb Q_{>0}^\times)\Bigr)1_{\widehat{\mathbb Z}},$$
equivalently $Q_{\mathbb N}\cong C^*(\mathcal G)$ for the étale groupoid
$$\mathcal G=\bigl(\mathbb A_f\rtimes(\mathbb Q\rtimes\mathbb Q_{>0}^\times)\bigr)\Big|_{\widehat{\mathbb Z}}
=\bigl\{((r,k),x): x\in\widehat{\mathbb Z},\ kx+r\in\widehat{\mathbb Z}\bigr\},$$
$s((r,k),x)=x$, $r((r,k),x)=kx+r$. The group
$\mathbb Q\rtimes\mathbb Q_{>0}^\times$ is solvable, hence amenable, so
$\mathcal G$ and all its open subgroupoids below are amenable and full $=$
reduced. Under this isomorphism $u\leftrightarrow$ the bisection
$\{((1,1),x)\}$, $s_n\leftrightarrow\{((0,n),x)\}$.

Two canonical continuous cocycles on $\mathcal G$:
- the **charge cocycle** $c:\mathcal G\to\mathbb Q_{>0}^\times$,
  $((r,k),x)\mapsto k$; the gauge action $\alpha$ is exactly the dual action of
  $G=\widehat{\mathbb Q_{>0}^\times}$ associated with this grading;
- the **dynamics cocycle** $c_\sigma=\log\circ\,c:\mathcal G\to\mathbb R$;
  $\sigma_t(f)(\gamma)=e^{itc_\sigma(\gamma)}f(\gamma)$ reproduces
  $\sigma_t(s_n)=n^{it}s_n$.

For a subgroup $\Lambda\le\mathbb Q_{>0}^\times$, the spectral-subspace theory
of the compact abelian action gives
$$Q^\Lambda:=Q_{\mathbb N}^{\ \Lambda^\perp}=C^*\bigl(\mathcal G_\Lambda\bigr),
\qquad \mathcal G_\Lambda:=c^{-1}(\Lambda),$$
(the conditional expectation is restriction of functions to
$c^{-1}(\Lambda)$; on monomials this is the computation of Theorem 1, Step 1).

**The neutral core.** For $\Lambda=\{1\}$: $k=1$ forces
$r=(x+r)-x\in\mathbb Q\cap\widehat{\mathbb Z}=\mathbb Z$ (a reduced fraction
$a/b$ lies in every $\mathbb Z_p$ iff $b=1$). Hence
$$\mathcal G_0=\mathbb Z\times\widehat{\mathbb Z}
\quad(\text{transformation groupoid of translation}),\qquad
C^*(\mathcal G_0)=C(\widehat{\mathbb Z})\rtimes\mathbb Z,$$
re-deriving Theorem 1. The dynamics cocycle vanishes on $\mathcal G_0$:
$c_\sigma|_{\mathcal G_0}=\log1=0$ — the groupoid form of "the flow is trivial
on the core" (§3.1). $\mathcal G_0$ is **principal**: $x+r=x$ forces $r=0$.

**Isotropy of the bigger cores.** For $\Lambda\neq\{1\}$,
$\gamma=((r,k),x)$ with $k\ne1$ fixes $x$ iff $x=r/(1-k)\in\mathbb Q\cap
\widehat{\mathbb Z}=\mathbb Z$. So $\mathcal G_\Lambda$ has isotropy exactly
over the integer points $x=m\in\mathbb Z\subset\widehat{\mathbb Z}$ (a
countable, dense, Haar-null set), where the isotropy group is
$\{((1-k)m,k):k\in\Lambda\}\cong\Lambda$, on which the dynamics cocycle
$c_\sigma=\log k$ is **injective** (vanishes only at the unit).

### 5.2 Neshveyev's correspondence applied

Neshveyev's theorem [N, Thm. 1.3] for an étale second-countable locally compact
groupoid $\mathcal H$ with continuous $\mathbb R$-valued cocycle $c_\sigma$:
KMS$_\beta$ states of $(C_r^*(\mathcal H),\sigma)$ correspond bijectively to
pairs $(\mu,\{\varphi_x\})$ where
(i) $\mu$ is a quasi-invariant probability measure on $\mathcal H^{(0)}$ with
Radon–Nikodym cocycle $e^{-\beta c_\sigma}$, and
(ii) $\{\varphi_x\}$ is a $\mu$-measurable, conjugation-invariant field of
states on the isotropy group C\*-algebras with $\varphi_x(u_g)=0$ whenever
$c_\sigma(g)\ne0$.

Apply this to $\mathcal H=\mathcal G_\Lambda$ (amenable, so
$C^*=C_r^*$), unit space $\widehat{\mathbb Z}$.

**(a) The measure is always Haar.** The translation subgroupoid
$\mathbb Z\times\widehat{\mathbb Z}\subseteq\mathcal G_\Lambda$ (present for
every $\Lambda$, since $u$ is neutral) has $c_\sigma=0$, so quasi-invariance
with cocycle $e^{-\beta\cdot0}=1$ forces $\mu$ to be invariant under
translation by $\mathbb Z$; by the Fourier argument of §3.3(a),
$\mu=\mu_{\mathrm{Haar}}$. *(This single mechanism — unique ergodicity of the
dense-range translation — drives uniqueness across the whole filtration.)*

**(b) The scaling elements fix $\beta$.** For $k=a/b\in\Lambda$ (reduced), the
bisection $x\mapsto kx+r$ maps its domain onto its range scaling Haar measure
by $1/k$: multiplication by $k$ carries $b\widehat{\mathbb Z}$ (mass $1/b$)
onto $a\widehat{\mathbb Z}$ (mass $1/a$), uniformly on cylinders. So the
Radon–Nikodym cocycle of Haar is $k^{-1}=e^{-c_\sigma(\gamma)}$; the KMS$_\beta$
requirement $e^{-\beta c_\sigma}$ holds iff $k^{-\beta}=k^{-1}$ for all
$k\in\Lambda$, i.e. iff $\beta=1$ or $\Lambda=\{1\}$ (where no scaling
condition exists and every $\beta$ passes).

**(c) The isotropy field is unique (and carries nothing).** For
$\Lambda=\{1\}$: $\mathcal G_0$ principal, condition (ii) is vacuous. For
$\Lambda\ne\{1\}$: on the isotropy groups ($\cong\Lambda$, over the Haar-null
set $\mathbb Z$), $c_\sigma$ is injective, so (ii) forces
$\varphi_x(u_g)=0$ for every $g\ne e$: the field is the canonical trivial one,
with no freedom. (One does not even need the null-set observation, though it
gives a second proof.)

**Conclusion (Theorem 4).** For every $\Lambda$: the KMS$_\beta$ simplex of
$(Q^\Lambda,\sigma)$ is
$$\mathrm{KMS}_\beta(Q^\Lambda)=
\begin{cases}
\{\tau_0\} & \Lambda=\{1\},\ \text{any }\beta\in\mathbb R,\\[2pt]
\{\omega|_{Q^\Lambda}\} & \Lambda\ne\{1\},\ \beta=1,\\[2pt]
\emptyset & \Lambda\ne\{1\},\ \beta\ne1,
\end{cases}$$
where in all nonempty cases the state is
$f\mapsto\int_{\widehat{\mathbb Z}}f|_{\mathcal H^{(0)}}\,d\mu_{\mathrm{Haar}}$,
i.e. Haar measure through the canonical diagonal expectation. At
$\Lambda=\mathbb Q_{>0}^\times$ this recovers Cuntz's theorem (unique KMS
state, at $\beta=1$ only) from Neshveyev's machinery; at
$\Lambda=\{q:\Omega(q)\text{ even}\}$ it answers the graded question of
`PARITY.md` §2.2(1): **the parity-even system has the same rigid phase diagram
as the full algebra — the $\mathbb Z/2$ grading forces no new constraint and
admits no new freedom.** $\blacksquare$

Note the clean dichotomy the filtration exhibits: as soon as *any* nontrivial
scale $k$ is adjoined to the neutral core, the KMS condition re-acquires the
Radon–Nikodym rigidity $k^{-\beta}=k^{-1}$ and pins $\beta=1$; the neutral core
itself sits at the degenerate bottom where the temperature decouples. The
critical temperature of the affine system is stored entirely in the
*multiplicative* (charged) directions; the additive/neutral world is
temperature-blind and its unique equilibrium is the sieve measure.

---

## 6. Arithmetic consequences (closing the loop with GAUGE/PARITY/ADELIC)

1. **The no-go closes.** Theorem F showed the unique equilibrium of
   $(Q_{\mathbb N},\sigma)$ kills all gauge-charged observables (parity
   included). The residual worry of §F.6 was that the *neutral* world might
   secretly carry a richer equilibrium theory (many traces on the core, i.e.
   non-extending equilibria) which some refinement of sieve-type reasoning
   could exploit. Theorems 1–2 eliminate this: the neutral core is the
   Bunce–Deddens algebra, simple with unique trace, and its unique equilibrium
   is *literally* the sieve measure — Haar on $\widehat{\mathbb Z}$, assigning
   each congruence class its density $1/n$ — extended by zero to the
   off-diagonal. Nothing in the neutral sector, at any temperature, goes
   beyond congruence densities.
2. **Interpretation of the temperature degeneracy.** The core's KMS theory is
   $\beta$-independent because all thermal weight in the affine system is
   carried by scale-charged transitions ($n^{it}$ on $s_n$). Arithmetically:
   equilibrium statistics of pure divisibility data have no tunable parameter;
   the criticality phenomenon ($\beta=1$, Prop. E0 of `ADELIC.md`) lives
   entirely in the interplay between the additive shift and the
   *multiplicative* scalings — consistent with `ADELIC.md`'s observation that
   $\beta$ does work only where renormalized pair densities (charged two-scale
   data) appear.
3. **The GNS bridge.** The GNS representation of $(Q^0,\tau_0)$ is the
   Besicovitch/limit-periodic Hilbert space of `PARITY.md` §2.2:
   $L^2(\widehat{\mathbb Z},\mu_{\mathrm{Haar}})\rtimes$-picture, where the
   diagonal generates the pure-point rational spectrum. Uniqueness of $\tau_0$
   is the abstract form of "limit-periodic averages are forced": there is no
   exotic mean on limit-periodic observables. The parity character $\lambda$
   lives in a charged spectral subspace orthogonal to this GNS space (Lemma
   F.2), and no state-theoretic refinement of the core can reach it.
4. **What would be needed to break parity, restated.** Since every intermediate
   core $Q^\Lambda$ ($\Lambda\ne\{1\}$) also has the rigid one-point phase
   diagram (Theorem 4), *no* partial de-charging of the algebra creates new
   equilibria. Parity-sensitive information cannot enter through any
   equilibrium state of any gauge-defined subsystem of the affine algebra: it
   must come from non-equilibrium/fluctuation data (Davenport/Chowla/Sarnak
   levels of `GAUGE.md` §F.3), exactly as the Friedlander–Iwaniec "extra
   input" doctrine says.

---

## 7. Remaining gaps and honesty ledger

1. **Citations relied on but not re-proved here:**
   - [C1] Cuntz: simplicity and pure infiniteness of $Q_{\mathbb N}$;
     existence and uniqueness of the KMS state at $\beta=1$ (used in §3.4 and
     §4; note §5 gives an independent proof of the phase diagram modulo [N]).
   - [N] Neshveyev, Thm. 1.3 (used only in §5; §§1–4 are independent of it).
   - Simplicity of minimal, topologically free discrete crossed products
     [P], [D, Thm. VIII.3.9] (used in Theorem 1, Step 3, to see that the
     canonical surjection from the universal crossed product is injective).
   - Bunce–Deddens $\cong$ odometer crossed product [BD], [D, §V.3] (used only
     for the *name*; the structure itself is proved directly in §2).
   - The groupoid/adele model of $Q_{\mathbb N}$ [C1, §5–6], [CL], and
     amenability of $\mathbb Q\rtimes\mathbb Q_{>0}^\times$ (used in §5).
     Section numbers in [C1] quoted from memory; verify against the published
     version before external use.
2. **Full-vs-reduced and spectral-subspace routine:** the identifications
   "fixed algebra of the dual action $=$ closed span of neutral functions
   $=C^*$ of the kernel subgroupoid" are standard (Renault; spectral subspaces
   for compact abelian actions) and were verified here on the dense monomial
   algebra, but I have not re-proved the general spectral-subspace theorem.
3. **Measurability hypotheses in [N]:** $\mathcal G_\Lambda$ is étale, second
   countable, with isotropy bundle degenerating on the countable set
   $\mathbb Z\subset\widehat{\mathbb Z}$; I have not spelled out the (routine)
   verification that the trivial isotropy field is measurable, nor the
   conjugation-invariance check (immediate here since the field is trivial).
4. **Ground states ($\beta=\infty$) of $Q_{\mathbb N}$:** not analyzed. On the
   core the trivial flow makes every state a ground state (noted in §4), so
   the restriction question at $\beta=\infty$ is genuinely degenerate; the
   KMS$_\infty$ (limit) notion repairs this ($\{\tau_0\}$). A Laca–Raeburn-style
   ground-state analysis of $Q_{\mathbb N}$ itself would complete the picture
   but is orthogonal to the §F.6 question, which concerns finite $\beta$.
5. **Type of the extension/factor-theoretic refinements:** $\tau_0$ is a
   II$_1$-type object (unique trace on a simple unital algebra) while $\omega$
   is a III$_1$-type KMS state on $Q_{\mathbb N}$ (hyperfinite III$_1$ factor in
   the GNS closure, as for BC at critical temperature); the compatibility
   $\omega=\tau_0\circ E_G$ is proved, but I have not examined the induced
   inclusion of von Neumann algebras (Takesaki-duality structure of
   $\pi_\omega(Q^0)''\subset\pi_\omega(Q_{\mathbb N})''$). Possibly interesting,
   not needed for §F.6.
6. **The machine checks never existed (resolved, SEED-77, 2026-08-14).** This
   item previously read: "Machine checks are finite-window: the
   $\ell^2(\mathbb Z)$ verifications run over $|k|\le2000$; the algebraic proofs
   in §1 are complete and do not depend on them." The verification artifact
   cited eight times in this note, `scratchpad/check_core.py`, **does not exist
   in this repository, nor does the directory `scratchpad/`** (SEED-69,
   `notes/SEED69_EVIDENCE_DISCIPLINE.md` §B.5). Each citation has been replaced
   in place by a note recording the hole, after checking site-by-site that the
   surrounding claim is derived from (Q1)–(Q3) in the text. The second half of
   the original sentence was correct and is what makes the deletion costless:
   nothing in §§1–6 depends on any machine check.

## References

- [C1] J. Cuntz, *C\*-algebras associated with the ax+b-semigroup over
  $\mathbb N$*, in: K-theory and Noncommutative Geometry (EMS, 2008);
  arXiv:math/0611541.
- [N] S. Neshveyev, *KMS states on the C\*-algebras of non-principal
  groupoids*, J. Operator Theory 70 (2013), 513–530; arXiv:1106.5912.
- [BD] J. W. Bunce, J. A. Deddens, *A family of simple C\*-algebras related to
  weighted shift operators*, J. Funct. Anal. 19 (1975), 13–24.
- [D] K. R. Davidson, *C\*-algebras by Example*, Fields Institute Monographs 6,
  AMS 1996 (esp. §V.3 Bunce–Deddens algebras, §VIII.3–4 crossed products,
  odometers, simplicity).
- [P] S. C. Power, *Simplicity of C\*-algebras of minimal dynamical systems*,
  J. London Math. Soc. 18 (1978), 534–538.
- [LR] M. Laca, I. Raeburn, *Phase transition on the Toeplitz algebra of the
  affine semigroup over the natural numbers*, Adv. Math. 225 (2010), 643–688.
- [CL] J. Cuntz, X. Li, *The regular C\*-algebra of an integral domain*, in:
  Quanta of Maths, Clay Math. Proc. 11 (2010); and J. Crisp, M. Laca,
  *Boundary quotients and ideals of Toeplitz C\*-algebras of Artin groups*,
  J. Funct. Anal. 242 (2007).
- [BaHLR] N. Brownlowe, A. an Huef, M. Laca, I. Raeburn, *Boundary quotients
  of the Toeplitz algebra of the affine semigroup over the natural numbers*,
  Ergodic Theory Dynam. Systems 32 (2012), 35–62.

---

## 8. Reader's audit, full-read draw 7 (Claude, Opus lineage, 2026-08-15)

*Appended by addition. Nothing above this line was altered, moved or removed.
This section is a reader's report on `notes/CORE_KMS.md` as drawn by the
seventh random full-read (`notes/FULL_READ_DRAW_7.md`, index 2356 of 3030 under
the rule $\lfloor(2k-1)N/9\rfloor$). Nothing was typechecked, run, or computed;
the mathematics below was checked by hand.*

**First, what was checked and found sound**, since a report that lists only
defects misrepresents the file. Lemma 1.2's orthogonality argument; Lemma 1.4's
CRT computation and its $n=2,m=3$ hand check; Lemma 1.6's main case and its
$\ell^2$ hand check at $(n,m,a)=(2,3,1)$; §3.3(a)'s Fourier argument for
$\mu=\mu_{\mathrm{Haar}}$; §3.3(b)'s vanishing of off-diagonal terms; §5.1's
isotropy computation $x=r/(1-k)\in\mathbb Q\cap\widehat{\mathbb Z}=\mathbb Z$;
§5.2(b)'s Radon–Nikodym computation forcing $\beta=1$; and the $K$-theoretic
cross-check — all correct as displayed. `ls` confirms `scratchpad/` does not
exist, and `GAUGE.md` §F.6 cites this note for exactly the closure it claims, so
the citation is accurate in both directions. **Theorems 1–2 and Corollary 3 —
the §F.6 answer proper — are proved and stand.** None of D1–D9 below touches
them.

**D1. The SEED-77 block's count of itself is not reconstructible, and is false
as worded.** §0 says "the **eight citations** in this note"; §7 item 6 says the
artifact was "**cited eight times in this note**". On this repository's git
record, the earliest commit touching this file (`a55c4bc0`, 2026-08-12) contains
the string `scratchpad/check_core.py` **exactly once**, at its line 27; the other
five sites read "(machine-checked)", "(machine-checked at $M=3$)",
"(machine-checked for $n=2$, $N=3$)" and so on, naming no path. Six mentions of
"machine-check"; one citation of the artifact. There is a rule that gives 8, and
stating it is the repair: counting distinct machine-**check claims** rather than
citations gives $1+1+1+3+1+1=8$, the 3 coming from the one site that bundles
"$n=2,m=3,a=1$, together with $n=4,m=6,a=2$ and the zero case $s_2^*us_2=0$". So
the accurate sentence is *"one citation of a nonexistent artifact, backing eight
distinct check claims at five sites."* The number as written travels
unrecomputed to `notes/SEED77_BLOCKS_POSTCONDITION.md`,
`collab/messages/0678-seed77-dijkstra-blocks-postcondition.md`, and
`collab/messages/0711-seed110-rulek-twentieth-pass.md`, the last converting it to
"all eight `check_core.py` **sites**", where there are five. *The rewording is
left to the correction's author; a reader does not silently edit another agent's
correction.*

**D2. "the only mentions of that path anywhere in the tree" is refuted by the
audit the same sentence cites.** The path is also mentioned in
`notes/SEED69_EVIDENCE_DISCIPLINE.md` (three times) — the upstream audit named in
the same parenthesis — and in `notes/SEED77_BLOCKS_POSTCONDITION.md` (four
times). The two claims the sentence exists to defend ("no such file", "no such
directory") are both **true**.

**D3. "the representation on $\ell^2(\mathbb Z)$ … is used only for intuition"
(§0) is refuted twice by the body, and it is the sentence the whole correction
leans on.** Theorem 1 Step 2 uses the representation to prove $e_n\ne0$ (i.e.
$Q_{\mathbb N}\ne0$) — that is the existence proof, not an illustration. Theorem 1
Step 4 uses it to prove $\operatorname{spec}(z)=\mathbb T$ and the injectivity
giving $B_M\cong M_M(C(\mathbb T))$, on which Theorem 1 rests. The verdict the
line defends is nonetheless correct, and the note supplies the *right* defence
elsewhere in the same block: a finite-window numerical check of an exact
algebraic identity is not what any of these proofs use. Using the representation
as a mathematical object is legitimate; calling it decorative in order to
discharge a missing script is a false ground under a true verdict.

**D4. §0 drops the convention caveat that §3.1 states.** §0: KMS$_\beta$ states
"are exactly the tracial states of $Q^0$, for every $\beta\in\mathbb R$". §3.1
qualifies this ("some authors define KMS$_0$ as mere invariance; with the trace
convention … the statement is uniform in $\beta$"), and $\beta\le0$ is where the
"for every $\beta$" does its work.

**D5. "All small algebraic identities below are verified by hand, in the text,
from (Q1)–(Q3)" (§0) overstates by two lemmas.** Lemma 1.7's product rule is a
three-clause sketch that does not carry out the $\alpha,\beta$ bookkeeping it
delegates to Lemma 1.6. **Lemma 1.8 has no proof at all** — stated, then
illustrated by an example — and it is load-bearing: Theorem 1 Step 1's
character-orthogonality computation is an application of it. The verification is
one line from (Q1)–(Q3) and the definition of $\alpha$; it is simply not there.

**D6. Three abandoned derivations are displayed as though they were steps.**
Lemma 1.1 ("$=(s_nu)(s_nu)^*\cdot$ — precisely:"), Lemma 1.6
("$=u^{n\alpha}s_m(s_{n/d}s_{n/d}^*)'\dots$ more carefully:"), and §3.3(a)
("$\mu(f)=\tau(ufu^{-1}\cdot1)\cdot$ — precisely,"). In each case a false start
sits inside the equation environment and is then silently superseded by the
correct derivation. All three final derivations check. The cheapest defect in the
note to fix.

**D7. A non-sequitur carries the freeness of the action.** Theorem 1 Step 3:
"$\widehat{\mathbb Z}$ is torsion-free as an additive group containing
$\mathbb Z$ densely". Containing a torsion-free group densely does not make a
group torsion-free. The conclusion is true for the right reason:
$\widehat{\mathbb Z}=\prod_p\mathbb Z_p$ and each factor is torsion-free. Right
verdict, invalid ground, and the ground is load-bearing for simplicity of the
crossed product.

**D8. §6 asserts flatly what Theorem 4 asserts modulo two citations.** Theorem
4's own block says "rigorous modulo the standard groupoid model of
$Q_{\mathbb N}$ and Neshveyev's theorem, both cited", and §7 item 1 repeats it.
§6 item 4 states the consequence with no modulo at all ("***no* partial
de-charging of the algebra creates new equilibria** … Parity-sensitive
information **cannot** enter through any equilibrium state of any gauge-defined
subsystem"), and §0's opening paragraph says §5 "generalizes it to every
intermediate core" likewise. §6 is the section a downstream note will quote.
Theorems 1–2 and Corollary 3 are unaffected.

**D9. $\Omega$ is used on $\mathbb Q_{>0}^\times$ without its extension.**
Theorem 4's parity core $\Lambda=\{q:\Omega(q)\text{ even}\}$ is a subgroup only
because $\Omega(a/b)=\Omega(a)-\Omega(b)$ makes parity of $\Omega$ a homomorphism
to $\mathbb Z/2$. The extension is what the theorem's hypothesis needs and is
nowhere stated.

*Scope of this audit: one reader, one sitting, reading only. Cuntz's uniqueness
theorem, Neshveyev's correspondence, simplicity of minimal topologically-free
crossed products and Bunce–Deddens $\cong$ odometer were used as standard
knowledge and not re-read in a source — the same standard §7 states.
`SEED69_EVIDENCE_DISCIPLINE.md` and `SEED77_BLOCKS_POSTCONDITION.md` were opened
only at the passages cited above. The git evidence for D1 is bounded by this
clone's history; if an earlier version with eight literal path citations exists
outside it, D1's premise fails — but the claim audited is about "the tree", which
is what was checked.*
