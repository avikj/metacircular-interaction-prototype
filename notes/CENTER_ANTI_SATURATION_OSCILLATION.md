# The center axis of the signed Chen field: what oscillates, what is subtracted, and the exact pole that blocks the Ω-argument

**Author.** cf-swarm-littlewood (Claude Fable 5), 2026-08-16.
**Method lens.** Littlewood: oscillation, Ω-results, what changes sign. The
question is never "how big is it on average" but "what atom cannot be
cancelled, and by whose order".
**Receives.** `collab/upstream/library/raw/ETERNAL_GOLDEN_BRAID_THEOREM_FACTORY_IV_2026-08-14.md`
§IV (the definition of $L_G$, $C_G$ and the identity $G=(C_G-L_G)/2$);
`notes/FACTORY_IV_CHEN_CORNER_AUDIT.md` §2, §4.3 (the audit's standing ask:
"run `LIOUVILLE.md` Theorem H's machinery *conditioned on the truncated
envelope*"); `notes/LIOUVILLE.md` (Theorem H, residue dressing, the
simplex-Chowla corollary); `notes/DPP.md` §3 (Theorem 3's order argument);
`papers/phase_side.md` §4 and `notes/FAMILY.md` §2 (the residue-dressing
table, the layer algebra, exp18's $s=0$ layer).
**Relation to the sibling.** `notes/TRUNCATED_CHEN_ANTI_SATURATION.md`
(cf-swarm-erdos, same day) does the *radius* axis — the twin face $r=1$ — as
elementary branch counting. This note does the *center* axis (Goldbach face)
as a spectral object. §2.1 below is the only place the two touch: it records
the exact lemma that transports the sibling's §2 bookkeeping to the center
fiber, and then defers to it. Nothing in the sibling's §1–§5 is repeated.
**Status.** §1 exact (identities and Mellin factors, no hypothesis). §2 under
RH + simple zeros, with the corpus's standing Gonek caveat carried at each
use. §3 the Ω-results and — the actual deliverable — the exact negative. §4
the disclaimer. §5 ledger. **No numerics were run.** Every constant below is
a closed form; the only decimal quantities named are the standard zeta-zero
ordinates, cited as table values and flagged.

---

## 0. Summary of findings

1. The center-axis signed Chen count decomposes **exactly** as
   (unrestricted $\Lambda\!\cdot\!\lambda$ correlation) $-$ ($\Omega\ge3$ tail),
   and the subtracted piece has **natural density $1$** while the retained
   envelope has density $0$. Worse, in the smoothed average the subtracted
   piece is larger by a **full half-power of $X$**: (a) $\asymp X^{5/2}$,
   (b) $\asymp X^3\log\log X/\log X$.
2. The unrestricted object (a) *is* a residue-dressing field, and it has
   **exactly two scales**, $X^{5/2}$ and $X^2$, each carrying a doublet:
   (smooth main, $\lambda$-single lines) at $X^{5/2}$; ($\Lambda$-single
   lines, pair lines, $s=0$ smooth term) at $X^2$. A main term **does**
   survive — with exact constant $\dfrac{4+2\sqrt2}{15\,\zeta(1/2)}$, negative.
   It is not pure spectrum (contrast Theorem H).
3. The Ω-result runs at $X^{5/2}$ and, after explicit subtraction, at $X^2$ on
   the atom $\gamma_1$ — the latter **Gonek-free**, because the $X^2$
   single-zero layer is dressed by $1$, not by $\zeta(2\rho)/\zeta'(\rho)$.
4. **The precise negative.** DPP Theorem 3's order argument is *blocked at the
   pair-layer bottom atom $2\gamma_1$*, and the blocker is named exactly: the
   pole of $\zeta(2s)/\zeta(s)$ at $s=\tfrac12$ — the parity pole, sitting on
   the critical line. It drags the $\Lambda$-single layer down to $X^2$, into
   degeneracy with the pair layer, so $2\gamma_1$ is contested by a single
   frequency $\gamma_k$ and order cannot separate them. In DPP's own
   $\Lambda\otimes\Lambda$ field the singles sit at $X^{5/2}$, a half-power
   clear, which is *why* the order argument runs there.
5. **The structural block on the Chen envelope itself**, stated exactly:
   $\mathbf 1_P$ and $\mathbf 1_{\Omega\le2}$ are both coefficient
   extractions $[z^k]$ from $F(s,z)=\prod_p(1-zp^{-s})^{-1}$, and
   **coefficient extraction converts poles into logarithmic branch points**.
   The residue-dressing family is closed under multiplicative dressing and
   **not** under charge truncation. There are no residues $w_\rho$ on the
   Chen envelope, hence no atoms, hence nothing for an order argument to
   protect.

---

## 1. The center object, written exactly

### 1.1 Coordinates

Factory IV §IV's center fiber is $2w=(w-r)+(w+r)$ with $w-r$ prime and
$\Omega(w+r)\in\{1,2\}$. Put $m=w-r$, $n=w+r$, so $m+n=2w$ and
$$C_G(w)=\sum_{m+n=2w}\mathbf 1_P(m)\,\mathbf 1_{\Omega(n)\le2},\qquad
L_G(w)=\sum_{m+n=2w}\mathbf 1_P(m)\,\mathbf 1_{\Omega(n)\le2}\,\lambda(n).$$
This is a **correlation of the prime indicator against $\lambda$ restricted to
the envelope** — the requested form, verbatim, with no approximation. The
envelope restriction sits entirely on the $n$-leg; the $m$-leg is unrestricted
prime.

### 1.2 The smoothed center average

Take the corpus's Cesàro-$1$ (Fejér/triangular) envelope, the one every
theorem in `LIOUVILLE.md`/`FAMILY.md` uses, so the results are comparable
layer-for-layer:
$$\sum_w L_G(w)\Bigl(1-\frac{2w}{X}\Bigr)_+
=\frac1X\sum_{\substack{m+n\le X\\ m+n\ \mathrm{even}}}\mathbf 1_P(m)\,
\mathbf 1_{\Omega(n)\le2}\lambda(n)\,(X-m-n).$$

Two normalizations, both exact:

* **$\Lambda$-weighting.** Replace $\mathbf 1_P$ by $\Lambda$. This is the
  only normalization in which the prime leg is a *residue* dressing (§1.5);
  the prime-power terms $m=p^k$, $k\ge2$ contribute $O(X^{2}\log X)$ to the
  display below and are absorbed throughout.
* **The even-sum filter.** $m+n$ even with $m$ an odd prime power forces $n$
  odd. Restricting a Dirichlet series to odd $n$ deletes the Euler factor at
  $2$:
  $$\sum_{n\ \mathrm{odd}}\lambda(n)n^{-s}
  =\prod_{p>2}(1+p^{-s})^{-1}=(1+2^{-s})\,\frac{\zeta(2s)}{\zeta(s)}.$$
  The factor $1+2^{-s}$ is entire and its zeros lie on $\operatorname{Re}s=0$
  (they solve $2^{-s}=-1$), so on $\operatorname{Re}s\ge\tfrac12$ it is a
  **nonvanishing analytic dressing**: it multiplies each residue by
  $1+2^{-\rho}$, with $|1+2^{-\rho}|\ge1-2^{-1/2}>0$ on the critical line.
  The center axis therefore costs nothing structurally — it is a bounded
  nonvanishing twist of the $\lambda$ dressing.
  The residual $m=2^k$, $n$ even branch contributes $O(X^{3/2}\log X)$.

Define the object of study:
$$\boxed{\;\mathcal G^{\mathrm{ctr}}(X):=\!\!\sum_{\substack{m+n\ \mathrm{even}}}\!\!
\Lambda(m)\,\mathbf 1_{\Omega(n)\le2}\lambda(n)\,(X-m-n)_+\;}$$
so that $\sum_w L_G(w)W(w/X)$ is $\mathcal G^{\mathrm{ctr}}(X)/X$ up to the
$\Lambda$-versus-$\mathbf 1_P$ reweighting.

### 1.3 The exact decomposition, and exactly what is subtracted

Pointwise on $\mathbb N$,
$$\mathbf 1_{\Omega(n)\le2}\,\lambda(n)=\lambda(n)-\mathbf 1_{\Omega(n)\ge3}\,\lambda(n),$$
hence, with **no error term and no hypothesis**,
$$\boxed{\;\mathcal G^{\mathrm{ctr}}(X)=\underbrace{\sum_{m+n\ \mathrm{even}}\Lambda(m)\lambda(n)(X-m-n)_+}_{\textbf{(a) unrestricted }\Lambda\cdot\lambda}
\;-\;\underbrace{\sum_{m+n\ \mathrm{even}}\Lambda(m)\lambda(n)\mathbf 1_{\Omega(n)\ge3}(X-m-n)_+}_{\textbf{(b) the }\Omega\ge3\textbf{ tail}}\;}$$

**What (b) subtracts, and its density.** The index set is
$\{n:\Omega(n)\ge3\}$. By Landau's theorem,
$$\#\{n\le u:\Omega(n)=k\}=\frac{u\,(\log\log u)^{k-1}}{(k-1)!\,\log u}\bigl(1+o(1)\bigr)
\quad(k\ \text{fixed}),$$
so $\#\{n\le u:\Omega(n)\le2\}\sim u\log\log u/\log u$ and therefore
$$\text{density}\{\Omega\ge3\}=1,\qquad \text{density}\{\Omega\le2\}=0 .$$
**The Chen envelope is the density-zero part and the subtracted tail is the
bulk.** On the tail $\lambda$ is not sign-definite ($\Omega$ runs over both
parities), which is precisely why (b) is not a sieve object.

**Sizes (this is the finding of §1).** (a) $\asymp X^{5/2}$ (proved in §2:
$\zeta(2s)/\zeta(s)$ has *no* pole at $s=1$ — it vanishes there —
so no $X^3$ layer exists). Meanwhile
$$\bigl|\mathcal G^{\mathrm{ctr}}(X)\bigr|\ \asymp\ \frac{X^3\log\log X}{\log X}
\qquad\text{(upper bound by the sieve; matching lower order HEURISTIC, §2.1),}$$
because on the envelope $\lambda=+1$ on the $\Omega=2$ branch, which carries
the $\log\log$ (the audit's §2 mechanism, transported to the center in §2.1).
Consequently
$$\textbf{(b)}=\textbf{(a)}-\mathcal G^{\mathrm{ctr}}\ \asymp\ \frac{X^3\log\log X}{\log X}
\ \gg\ X^{1/2}\frac{\log\log X}{\log X}\cdot\textbf{(a)} .$$

> **The whole spectral apparatus of Theorem H, applied to (a), lives a full
> half-power of $X$ beneath the object it was supposed to describe.** The
> decomposition is exact and useless in the direction Factory IV wants: it
> splits a $X^3\log\log X/\log X$ object into a $X^{5/2}$ piece one can
> analyse and a $X^3\log\log X/\log X$ piece one cannot.

*(Littlewood's reflex, recorded: this is the same shape as "the error term is
bigger than the main term you subtracted". Nothing about (a) can be Ω-lifted
to $\mathcal G^{\mathrm{ctr}}$; §3.4.)*

### 1.4 A corollary on the center axis (the audit's §2, transported)

Because the $\Omega=2$ branch carries $+1$ under $\lambda$ and the $\Omega=1$
branch carries $-1$, and the former is $\log\log$-heavier on the unrestricted
envelope, $L_G(w)/C_G(w)\to+1$ in the smoothed average **regardless of
Goldbach**. So Factory IV §IV's $\delta$-target
$L_G\le(1-\delta)C_G$ is false on the unrestricted center envelope for the
same reason the audit gave on the radius envelope, and must likewise be
stated on the truncated Chen set. *(HEURISTIC at the level of the constant;
the $\log\log$ ordering is the audit's, cited.)*

### 1.5 Why the envelope is outside the residue-dressing family — exactly

Let $F(s,z)=\sum_n z^{\Omega(n)}n^{-s}=\prod_p(1-zp^{-s})^{-1}$, and
$P(s)=\sum_p p^{-s}$ the prime zeta function. From
$\log F=\sum_{j\ge1}z^jP(js)/j$,
$$[z^0]F=1,\quad [z^1]F=P(s),\quad [z^2]F=\tfrac12\bigl(P(s)^2+P(2s)\bigr),
\quad [z^3]F=\tfrac16\bigl(P(s)^3+3P(s)P(2s)+2P(3s)\bigr),\dots$$
(the cycle index of $S_k$). Since $\lambda(n)=(-1)^{\Omega(n)}$,
$$\boxed{\;D_{\le2,\lambda}(s):=\sum_{\Omega(n)\le2}\frac{\lambda(n)}{n^{s}}
=1-P(s)+\tfrac12\bigl(P(s)^2+P(2s)\bigr)\;}$$
exactly, and $D_{\ge3,\lambda}(s)=\sum_{k\ge3}(-1)^kZ_k\bigl(P(s),\dots,P(ks)\bigr)$,
with $D_{\le2,\lambda}+D_{\ge3,\lambda}=\zeta(2s)/\zeta(s)$.

Now $P(s)=\sum_{k\ge1}\frac{\mu(k)}{k}\log\zeta(ks)$. Therefore:

| object | singularity at $s=1$ | singularity at $s=\rho$ | extra |
|---|---|---|---|
| $\zeta(2s)/\zeta(s)$ | **regular** (a zero) | simple **pole**, residue $\zeta(2\rho)/\zeta'(\rho)$ | pole at $s=\tfrac12$ |
| $\mathbf 1_P$-dressing $P(s)$ | $\log\frac1{s-1}$ **branch point** | $\log(s-\rho)$ **branch point** | branch points at $\rho/k$, $k$ squarefree |
| $D_{\le2,\lambda}(s)$ | $\tfrac12\log^2\frac1{s-1}$ **branch point** | $\log^2$ **branch point** | branch points at $\rho/k$, and at $\tfrac12$ from $P(2s)$ |

Three exact consequences.

1. **Truncation manufactures a singularity.** $\zeta(2s)/\zeta(s)$ is regular
   at $s=1$ (indeed vanishes, since $1/\zeta$ has a zero there). Its
   $\Omega\le2$ truncation has a $\log^2$ branch point at $s=1$; the
   $\Omega\ge3$ tail carries the exact compensating $-\tfrac12\log^2$. The
   decomposition of §1.3 splits a regular object into two pieces each *more*
   singular than the whole. This is the analytic form of "the subtracted
   piece is bigger".
2. **No residues, hence no atoms.** At $s=\rho$ the Chen dressing has a
   logarithmic branch point, not a pole. There is no $w_\rho$; the spectral
   contribution of a zero to the Chen-restricted field is a **cut integral,
   not a delta**. An order argument protects atoms; there are none to
   protect (§3.4).
3. **The family is not closed under charge truncation.** $\mathbf 1_P=[z^1]$
   and $\mathbf 1_{\Omega\le2}=[z^{0}]+[z^1]+[z^2]$ are both coefficient
   extractions from the same $F(s,z)$, and coefficient extraction is a
   contour integral in $z$ that converts the pole of $\zeta$ into
   $\log\zeta$. `FAMILY.md` §2's layer algebra ("layers = pairwise products
   of the singularity sources") is a *residue* calculus; it survives every
   multiplicative dressing $\Lambda,\lambda,\mu,d,\Lambda\chi$ and dies on
   the first charge truncation. **This is the exact sense in which the Chen
   corner is outside the corpus's proved vocabulary**, and it sharpens the
   audit's §4.3 ask into a no-go for the naive form of that ask.

New frequency observation, recorded for the record: the branch points of
$P(s)$ at $s=\rho/k$ open a **sub-harmonic string** $\gamma/2,\gamma/3,\dots$
that no pole-dressing in `FAMILY.md`'s table possesses. It sits at
$\operatorname{Re}s=1/(2k)$, hence at scales $X^{3/2+1/(2k)}$ and below —
subdominant here, but it is a genuine structural difference between
truncated and untruncated dressings and would be the leading novelty in any
short-interval version.

---

## 2. Layer algebra for (a): the two-scale center field

Under RH and simple zeros throughout §2. Write
$$A(s)=-\frac{\zeta'}{\zeta}(s)-\frac{\log2\cdot2^{-s}}{1-2^{-s}}\quad(\text{odd }\Lambda),
\qquad B(z)=(1+2^{-z})\frac{\zeta(2z)}{\zeta(z)}\quad(\text{odd }\lambda),$$
and use the Theorem-D mechanism verbatim (`LIOUVILLE.md` §2,
`papers/phase_side.md` §1):
$$\textbf{(a)}=\frac1{(2\pi i)^2}\iint A(s)B(z)\,
\frac{\Gamma(s)\Gamma(z)}{\Gamma(s+z+2)}\,X^{s+z+1}\,ds\,dz .$$

**Singularity sources.**
$A$: simple pole at $s=1$ (residue $1$); simple poles at $s=\rho$ (residue
$-1$); a simple pole at $s=0$ from the odd-restriction (residue $-1$),
crossing $\Gamma$'s pole there.
$B$: simple pole at $z=\tfrac12$ (residue $(1+2^{-1/2})/(2\zeta(1/2))$);
simple poles at $z=\rho$ (residue $w^{\mathrm{ctr}}_\rho:=(1+2^{-\rho})\zeta(2\rho)/\zeta'(\rho)$);
value $B(0)=2$ at $\Gamma$'s pole $z=0$.
**$B$ has no pole at $z=1$** — this is what kills the $X^3$ layer.

### 2.1 The scale count collapses to two

$B$'s two sources both have real part $\tfrac12$ (the pole at $\tfrac12$ *is*
on the critical line — `LIOUVILLE.md` §2's scale degeneracy). So every layer
has scale $X^{\sigma_A+3/2}$ with $\sigma_A\in\{1,\tfrac12\}$:

| source pair | exponent | scale | frequencies |
|---|---|---|---|
| $s=1\ \times\ z=\tfrac12$ | $X^{5/2}$ | $X^{5/2}$ | $0$ (**main term**) |
| $s=1\ \times\ z=\rho$ | $X^{\rho+2}$ | $X^{5/2}$ | $\gamma$ (**$\lambda$-singles**) |
| $s=\rho\ \times\ z=\tfrac12$ | $X^{\rho+3/2}$ | $X^{2}$ | $\gamma$ (**$\Lambda$-singles**) |
| $s=\rho\ \times\ z=\rho'$ | $X^{\rho+\rho'+1}$ | $X^{2}$ | $\gamma+\gamma'$ (**pairs**) |
| $s=1\ \times\ z=0$ | $X^{2}$ | $X^{2}$ | $0$ (exp18's $s{=}0$ layer) |
| $s=0\ \times\ z=\tfrac12$ | $X^{3/2}\log X$ | — | double pole, lower order |

> **Structural law (center field).** $\Lambda\otimes\Lambda$ has three scales
> $X^3/X^{5/2}/X^2$; $\lambda\otimes\lambda$ has one, $X^2$ (Theorem H);
> $\Lambda\otimes\lambda$ has **exactly two**, and each carries a *doublet*:
> (smooth, singles) at $X^{5/2}$ and (singles, pairs) at $X^2$. The count is
> $|\{1,\tfrac12\}|\times|\{\tfrac12\}|$ — the $\lambda$ side contributes one
> real part, not two. **A main term survives; the center field is not pure
> spectrum.**

### 2.2 The main term, in closed form

$\operatorname{Res}_{s=1}A=1$; $\operatorname{Res}_{z=1/2}B=(1+2^{-1/2})/(2\zeta(1/2))$;
archimedean factor $\Gamma(1)\Gamma(\tfrac12)/\Gamma(\tfrac72)=\sqrt\pi/(\tfrac{15}8\sqrt\pi)=\tfrac8{15}$. Hence
$$\boxed{\;\textbf{(a)}=\frac{4+2\sqrt2}{15\,\zeta(1/2)}\,X^{5/2}\;+\;\text{(oscillatory layers)}\;}$$
The constant is exact and **negative** ($\zeta(1/2)<0$) — the archimedean
face of the Pólya bias, the same sign mechanism as `LIOUVILLE.md`'s
simplex-Chowla corollary, now appearing linearly in $1/\zeta(1/2)$ rather
than quadratically. Without the even-sum filter the constant would be
$\tfrac8{15\zeta(1/2)}$; the center axis multiplies it by
$(1+2^{-1/2})/2$.

The $s{=}0$ layer, likewise exact: residue $B(0)\cdot\Gamma(s)/\Gamma(s+2)$ at
$z=0$, then the $s=1$ pole, gives $2\cdot\tfrac12\cdot X^2=+X^2$. (The
unrestricted field gives $+\tfrac12X^2$; the center filter doubles it, since
$B(0)=(1+2^{0})\zeta(0)/\zeta(0)=2$ — note $\zeta(0)$ *cancels* here, unlike
exp18's $\Lambda\otimes\mu$ where the same layer reads $1/\zeta(0)=-2$.)

### 2.3 The two line systems, and their different weight systems

$$\textbf{$X^{5/2}$ singles: }\ \sum_\rho w^{\mathrm{ctr}}_\rho\,
\frac{\Gamma(\rho)}{\Gamma(\rho+3)}X^{\rho+2},
\qquad w^{\mathrm{ctr}}_\rho=(1+2^{-\rho})\frac{\zeta(2\rho)}{\zeta'(\rho)} ;$$
$$\textbf{$X^{2}$ singles: }\ -\frac{(1+2^{-1/2})\sqrt\pi}{2\zeta(1/2)}
\sum_\rho\frac{\Gamma(\rho)}{\Gamma(\rho+\frac52)}X^{\rho+3/2};$$
$$\textbf{$X^{2}$ pairs: }\ -\sum_{\rho,\rho'} w^{\mathrm{ctr}}_{\rho'}\,
\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}.$$

**Convergence caveats, carried in full (the corpus's standing debt).**

* $X^{5/2}$ singles: $|\Gamma(\rho)/\Gamma(\rho+3)|\asymp\gamma^{-3}$,
  $|1+2^{-\rho}|\le1+2^{-1/2}$, $|\zeta(1+2i\gamma)|\ll\log\gamma$
  (and $\gg1/\log\log\gamma$, so the weights do not degenerate). Absolute
  convergence needs $\sum_\gamma\log\gamma\,\gamma^{-3}|\zeta'(\rho)|^{-1}<\infty$,
  which follows by Cauchy–Schwarz from **Gonek's hypothesis**
  $\sum_{0<\gamma\le T}|\zeta'(\rho)|^{-2}\ll T$. **This layer is
  Gonek-conditional**, exactly as Theorem H is.
* $X^2$ singles: the weights are $\Gamma$-only times the constant
  $1/\zeta(1/2)$. $\sum_\gamma|\Gamma(\rho)/\Gamma(\rho+\tfrac52)|
  \asymp\sum_\gamma\gamma^{-5/2}<\infty$ **unconditionally** (given the RH +
  simplicity used to write the residues at all). **Gonek is not needed
  here.** This asymmetry between the two single layers is new to the corpus's
  bookkeeping and is what makes §3.2 unconditional-modulo-RH.
* $X^2$ pairs: $|\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)|
  \le\sqrt{2\pi}\,s^{-5/2}$ **for every pair, unconditionally**
  (`DPP.md` Theorem 1 — the one-sided form of D‴). Absolute convergence then
  needs $\sum_\rho|w^{\mathrm{ctr}}_\rho|$-type control, i.e. Gonek again.
  Carried, flagged.

---

## 3. Ω-results: where the order argument runs, and the exact place it stops

Put $u=\log X$. Each layer above is $X^{\sigma}F_\sigma(u)$ with
$F_\sigma(u)=\sum_j a_je^{i\phi_ju}$ a uniformly almost-periodic function
(absolute convergence as licensed in §2.3). Besicovitch–Parseval gives
$M(|F|^2)=\sum_j|a_j|^2$ over **distinct** frequencies $\phi_j$, hence
$$\limsup_u|F_\sigma(u)|\ \ge\ \Bigl(\sum_j|a_j|^2\Bigr)^{1/2}\ \ge\ \sqrt2\,|a_{j_0}|$$
for any single frequency $\phi_{j_0}>0$ carried by **exactly one** term (the
$\sqrt2$ from the conjugate pair $\pm\phi_{j_0}$, $F$ real). *Everything
therefore turns on frequency collisions* — which is precisely DPP Theorem 3's
mechanism.

### 3.1 Top layer, $X^{5/2}$: the order argument is vacuous (positive)

The $X^{5/2}$ oscillatory layer is indexed by a **single** zero. Its
frequency set is $\{\pm\gamma\}$, distinct because simple zeros have distinct
ordinates. No collision is possible; DPP Theorem 3's order argument — which
exists to show that $a+b=\gamma_1+\gamma_2$ forces $\{a,b\}=\{\gamma_1,\gamma_2\}$
— has nothing to do. Every weight is nonzero:
$\zeta(2\rho)=\zeta(1+2i\gamma)\ne0$ (Hadamard–de la Vallée Poussin),
$1+2^{-\rho}\ne0$ (since $|2^{-\rho}|=2^{-1/2}\ne1$), $\zeta'(\rho)\ne0$
(simplicity), $\Gamma(\rho)/\Gamma(\rho+3)\ne0$.

> **Ω-theorem C1 (RH + simple zeros + Gonek).**
> $$\textbf{(a)}(X)-\frac{4+2\sqrt2}{15\,\zeta(1/2)}X^{5/2}=\Omega\bigl(X^{5/2}\bigr),$$
> with $\limsup\ge\sqrt2\,\bigl|w^{\mathrm{ctr}}_{\rho_1}\Gamma(\rho_1)/\Gamma(\rho_1+3)\bigr|$,
> an explicit nonzero constant. In particular the smoothed center average of
> $\Lambda\cdot\lambda$ **changes sign infinitely often** relative to its main
> term (the main term is negative and the oscillation is of its own order).

### 3.2 Second layer, $X^{2}$: the order argument runs at $\gamma_1$, and only there (positive, but thin)

At $X^2$, singles (frequencies $\gamma$) and pairs (frequencies
$\gamma+\gamma'$) coexist at **equal amplitude scale** — the degeneracy
inherited from the parity pole. Collisions between the two systems are now
possible in principle.

**Order-only fact.** Every pair frequency satisfies $\gamma+\gamma'\ge2\gamma_1>\gamma_1$
(positivity of ordinates); every other single frequency is $\ne\gamma_1$
(distinctness). Hence **the smallest positive frequency in the entire $X^2$
spectrum is $\gamma_1$, and it is carried by exactly one term** — the
$\Lambda$-single atom. This uses ordering alone, no numerical input.

> **Ω-theorem C2 (RH + simple zeros; NO Gonek).** Let
> $R(X)=\textbf{(a)}(X)-\frac{4+2\sqrt2}{15\zeta(1/2)}X^{5/2}
> -\sum_\rho w^{\mathrm{ctr}}_\rho\frac{\Gamma(\rho)}{\Gamma(\rho+3)}X^{\rho+2}$
> (i.e. the two $X^{5/2}$ layers removed explicitly). Then
> $$R(X)-X^2=\Omega(X^2),\qquad
> \limsup\ \ge\ \sqrt2\cdot\frac{(1+2^{-1/2})\sqrt\pi}{2|\zeta(1/2)|}\,
> \Bigl|\frac{\Gamma(\rho_1)}{\Gamma(\rho_1+\frac52)}\Bigr| .$$
> The Gonek caveat attaches only to the *statement* of the subtracted
> $X^{5/2}$ layer, not to this Ω-constant.

Beyond $\gamma_1$ the argument needs certified numerics, and I flag it rather
than run it: $\gamma_2,\gamma_3$ are also uncontested **provided**
$\gamma_3<2\gamma_1$, and $\gamma_4$ provided $2\gamma_1<\gamma_4<\gamma_1+\gamma_2$.
With the standard table values $\gamma_1=14.1347\ldots$, $\gamma_2=21.0220\ldots$,
$\gamma_3=25.0108\ldots$, $\gamma_4=30.4248\ldots$, $2\gamma_1=28.2694\ldots$,
$\gamma_1+\gamma_2=35.1567\ldots$ these hold — but these are *inequalities
between real numbers*, not order facts, and discharging them is a certified
interval-arithmetic verification (which `CLAUDE.md` licenses as proof and
`DPP.md` §6 route (a) already contemplates). **UNVERIFIED here.**

### 3.3 The exact negative: which pole blocks the pair-atom argument

DPP Theorem 3's characteristic move is to protect the **pair** atoms
$2\gamma_1$ and $\gamma_1+\gamma_2$ at the bottom of the pair spectrum. In
the present field that move **fails**, and the blocker is nameable:

> **Blocking statement.** The atom at frequency $2\gamma_1$ in the $X^2$ layer
> is contested by the $\Lambda$-single atom at frequency $\gamma_k$ whenever
> $\gamma_k=2\gamma_1$. Order cannot exclude this: $2\gamma_1$ lies strictly
> inside the range of the single spectrum, and no ordering of ordinates
> constrains a single ordinate against a sum of two. The reason the two
> systems collide **at all** is that
> $$\operatorname{Re}\rho=\tfrac12=\text{the pole of }\zeta(2z)/\zeta(z),$$
> i.e. **the parity pole of the $\lambda$ dressing sits on the critical
> line**. That single fact sets $\sigma_B\equiv\tfrac12$ for both of $B$'s
> source types, collapsing the $\Lambda$-single layer from $X^{5/2}$ (where it
> sits in $\Lambda\otimes\Lambda$) down to $X^2$, into the pair layer.
> In DPP's own $\Lambda\otimes\Lambda$ field the singles sit at $X^{5/2}$, a
> clear half-power above the pairs, which is *why* the pair spectrum there is
> uncontested and the order argument runs.

So: **the positive result migrates to the bottom of the single spectrum
($\gamma_1$, §3.2) and is lost at the bottom of the pair spectrum
($2\gamma_1$).** The precise price of `LIOUVILLE.md`'s celebrated scale
degeneracy — the thing that made Theorem H's "pure spectrum" reading possible
— is that it destroys the separation DPP Theorem 3 needs. The two results are
in exact tension, and this note locates the tension at one pole.

*Weights, checked separately, do not block anything:* every residue above is
nonzero (§3.1), so no atom vanishes. The obstruction is purely the frequency
degeneracy, i.e. the pole location, not the dressing.

### 3.4 And none of it reaches $L_G$

Ω-theorems C1 and C2 are statements about **(a)**. By §1.3, $\mathcal
G^{\mathrm{ctr}}=\textbf{(a)}-\textbf{(b)}$ with $\textbf{(b)}\asymp X^3\log\log X/\log X$.
An $\Omega(X^{5/2})$ statement about (a) survives subtraction of (b) only if
(b) is known to $o(X^{5/2})$ — i.e. only if the $\Omega\ge3$ correlation with
primes is known to relative precision $X^{-1/2}\log X/\log\log X$. Nothing of
the kind is available; by §1.5 (b) is not even a residue object. **Formally:**

> **Proposition (no transfer).** No Ω-result for (a), at any scale $\le X^3$,
> implies an Ω-result for $\mathcal G^{\mathrm{ctr}}$ without an independent
> bound on (b) of the same order. And (b) is a branch-cut dressing with a
> $\log^2$ singularity at $s=1$, so the corpus's residue calculus produces no
> such bound.

This is the center-axis form of the sibling's finding on the radius axis: the
truncated $\delta$-target *is* the Hardy–Littlewood lower bound. Here: the
spectral $\Omega$-target *is* separated from the Chen object by exactly the
part of the field that has no spectrum.

---

## 4. What this does **not** touch

Stated flatly, because the failure mode this repository exists to prevent is
exactly a smoothed average being read as a pointwise statement.

1. **It says nothing about Goldbach.** Goldbach at $2w$ is
   $L_G(w)<C_G(w)$ **for every $w$** — a *pointwise per-center*
   anti-saturation statement. Everything above is an average over $w$ against
   a positive envelope of width $\asymp X$. A positive-envelope average can be
   as large as one likes while individual fibers saturate; the envelope
   provably cannot see a single center.
2. **Even the "almost all" reading is strictly weaker than known results.**
   Averaged Goldbach with exceptional set $O(X^{1-\delta})$ is
   Montgomery–Vaughan (1975), unconditional, and Chudakov–van der
   Corput–Estermann before that. Nothing in this note approaches, let alone
   improves, that. The content here is *spectral description* of a
   correlation, not a Goldbach consequence, and it must never be cited as
   one.
3. **It does not touch the twin/radius axis**; that is the sibling note.
4. **It does not produce $\delta$.** §1.4 shows the unrestricted center
   envelope saturates for envelope-arithmetic reasons; it does not compute a
   truncated-set $\delta$ (the sibling does that on the radius axis, and its
   §4.4 constants remain open there).
5. **It does not decide $2\gamma_1$ versus $\gamma_4$**, or any collision
   beyond the order-only $\gamma_1$ atom. §3.2's extension is flagged
   UNVERIFIED.
6. **It does not certify Gonek.** C1 is conditional on it; C2 is not.

---

## 5. Honesty ledger

**Exact, unconditional (no RH, no heuristic):**
- §1.1–§1.2 the rewriting of $\sum_w L_G(w)W(w/X)$ as a prime-$\times$-$\lambda$
  correlation with the even-sum filter, and the identification of the filter
  with the nonvanishing dressing factor $(1+2^{-s})$ on
  $\operatorname{Re}s\ge\tfrac12$;
- §1.3 the decomposition $\mathcal G^{\mathrm{ctr}}=(a)-(b)$, pointwise, no
  error term;
- §1.5 the cycle-index identity $D_{\le2,\lambda}=1-P+\tfrac12(P^2+P(2s))$ and
  the branch-point table — this is the structural core of the note and uses
  nothing beyond $\log F=\sum_j z^jP(js)/j$ and
  $P(s)=\sum_k\frac{\mu(k)}k\log\zeta(ks)$;
- the archimedean constants $\Gamma(\tfrac12)/\Gamma(\tfrac72)=\tfrac8{15}$,
  $B(0)=2$, and the resulting main-term constant
  $(4+2\sqrt2)/(15\zeta(1/2))$ and $s{=}0$ layer $+X^2$.

**Under RH + simple zeros:** all of §2's layer decomposition and §3's
Ω-results. The residues at $\rho$ do not exist as written without simplicity.

**Additionally under Gonek** ($\sum_{\gamma\le T}|\zeta'(\rho)|^{-2}\ll T$):
absolute convergence of the $X^{5/2}$ single layer and of the pair layer,
hence Ω-theorem C1. **C2 does not use Gonek** — flagged as a genuine
asymmetry, not a rhetorical one.

**HEURISTIC, labelled at use:** the *lower* order $\mathcal
G^{\mathrm{ctr}}\gg X^3\log\log X/\log X$ in §1.3 and the saturation direction
in §1.4 rest on Hardy–Littlewood for the forms $(b,2w-ab)$, exactly as the
sibling's §2 rests on it for $(b,ab-2)$. The matching *upper* bound is an
upper-bound sieve and is unconditional. The theorem each heuristic stands in
for: Hardy–Littlewood Conjecture B, uniformly in the smaller factor. It is
unavailable, and it contains Goldbach.

**Prior art — searched against model memory only; egress not attempted;
every item below is UNVERIFIED.** Recorded queries, for a successor with
access:
- *"Languasco Zaccagnini Cesàro average Goldbach numbers explicit formula"* —
  Languasco–Zaccagnini have a series (2016–2020) computing exactly
  $\sum_{m+n\le X}a(m)b(n)(X-m-n)^k$ for $a,b\in\{\Lambda,\mu,\lambda,
  \mathbf1_{\text{squarefree}},\dots\}$ with the identical
  $\Gamma(s)\Gamma(z)/\Gamma(s+z+k+1)$ kernel. **§2 should be presumed a
  rederivation at identity level** until checked; what would be repo-new is
  the two-scale doublet reading, the Gonek asymmetry between the two single
  layers, and §3.3.
- *"Cantarini Gambini Zaccagnini Liouville Goldbach explicit formula"*
  (arXiv:2603.10241) — already flagged in `LIOUVILLE.md` for
  $\lambda\otimes\lambda$; the $\Lambda\otimes\lambda$ case is plausibly in
  the same circle.
- *"Bhowmik Schlage-Puchta Goldbach generating function Omega result"* — the
  known Ω-results for the Goldbach error term; C1/C2 must be compared against
  them before any novelty claim.
- *"Landau Selberg Sathe Delange integers with k prime factors Dirichlet
  series prime zeta"* — for §1.5's branch-point structure (classical).
- *"Omega results almost periodic Besicovitch Parseval explicit formula"* —
  for the §3 mechanism (Landau/Ingham classical).
- *"Gonek conjecture negative moments zeta prime rho"*.
- *"Chen conditioned Liouville cancellation sparse set"* — the audit's §4.2
  obligation, inherited and **not** discharged.

**Not done:**
- no numerics of any kind: no count, no fit, no correlation, no evaluation of
  a series. The zeta ordinates in §3.2 are quoted as table values and the
  inequalities they would establish are explicitly left UNVERIFIED;
- no formalization (nothing added to `formal/`); §1.3 and §1.5's cycle-index
  identity are the natural candidates, the latter being pure algebra;
- no explicit constant for $\mathcal G^{\mathrm{ctr}}$'s leading term (it is
  HL-conditional and I will not quote a number for it);
- no attempt at the truncated ($a>p^\theta$) center field: §1.5's block is
  *worse* there, since truncation adds an $\alpha$-integral on top of the
  branch cut. Recorded as the honest reason not to try;
- no claim that C1/C2 are new (see prior art).

**Falsifiers.**
(F1) If $\zeta(2s)/\zeta(s)$ had a pole at $s=1$ the whole scale count of §2.1
would shift by one power; check: $1/\zeta$ vanishes at $1$, so it does not.
(F2) If the even-sum filter were not $(1+2^{-s})$ — check by removing the
$p=2$ Euler factor from $\prod(1+p^{-s})^{-1}$ — then §2.2's constant moves by
that factor and nothing else in §2–§3 changes, since the factor is
nonvanishing on $\operatorname{Re}s\ge\tfrac12$.
(F3) §1.5's table is wrong if $P(s)$ has poles rather than log branch points
at $\rho$; check against $P(s)=\log\zeta(s)+\sum_{k\ge2}\frac{\mu(k)}k\log\zeta(ks)$.
If (F3) failed, §3.3's negative would collapse and the Chen envelope would
rejoin the residue family — this is the single load-bearing claim of the note.
(F4) §3.2's order-only claim fails if some pair frequency could be $<2\gamma_1$;
it cannot, as $\gamma,\gamma'\ge\gamma_1>0$.

---

## 6. Queue

- `PROVE` the cycle-index identity of §1.5 and the branch-point table in
  `formal/` — it is pure formal-power-series algebra in
  $\mathbb Q[[z]]$ and needs no analysis; the corpus has no formalized
  statement that charge truncation leaves the residue family.
- `SEARCH` the Languasco–Zaccagnini Cesàro-average series and
  Bhowmik–Schlage-Puchta Ω-results, and grade §2/§3 against them **before**
  any novelty is claimed anywhere downstream. This is the highest-priority
  item in this note.
- `PROVE` the certified inequalities $\gamma_3<2\gamma_1<\gamma_4<\gamma_1+\gamma_2$
  by interval arithmetic (protocol-licensed as proof), extending C2 from one
  atom to four.
- `PROVE`/`SEARCH` whether *any* bound on the $\Omega\ge3$-tail correlation
  (b) to relative precision $X^{-1/2}$ exists in the literature. §3.4 says
  this is the whole gap between the spectrum and the Chen object; I believe
  it does not exist, and I did not search.
- Recorded for the Factory IV lineage: §1.4 shows the audit's §2 correction
  applies on the **center** axis as well, so Factory IV §IV's $\delta$-target
  must be truncated on *both* faces, not just the radius face.

— cf-swarm-littlewood, 2026-08-16 (lens: Littlewood — oscillation, Ω-results,
what changes sign)
