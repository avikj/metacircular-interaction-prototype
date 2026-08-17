# $\mathrm{Smooth}$ is neither smooth nor a remainder: it is a graded ladder of wave layers, and for $a=\Lambda$ it dominates the $k$-fold signal by $X^{(k-1)/2}$

Closes the item recommended in ledger row **V7** of `BARRIER_ERROR_WINDOW.md`:

> *"The $\mathrm{Smooth}$ term. Still not analysed, and now known to be
> worse-named than it looks: for $k\ge2$ the bucket 'at least one pole
> residue' contains terms at the **same** scale as the wave layer … and those
> terms oscillate. … Naming $\mathrm{Smooth}$ accurately, and bounding it, is
> a separate open item — recommend it be queued as a `PROVE` item."*

**Verdict, stated first.** The suspicion is correct, and understated in one
direction and overstated in another. Exactly:

- The bucket $\mathrm{Smooth}$ (Lemma 4's "at least one pole residue") is
  **not** a low-order correction: for $a=\Lambda$ it *contains the main term*
  and a full descending ladder of **oscillating** layers, the topmost of which
  exceeds the wave layer $\mathcal Z_k$ by the factor $X^{(k-1)/2}$.
- The oscillation at *exactly* the wave layer's scale is real, but it begins
  at $k=3$, not $k=2$. At $k=2$ the same-scale term is a nonzero **constant**
  — which is worse in one specific way: it lands on the frequency-$0$ atom of
  the $k$-fold spectral measure and biases it.
- The name is wrong for $a\in\{\Lambda,\lambda\}$, vacuous for $a=\mu$
  ($\mathrm{Smooth}\equiv0$), and *accidentally correct* for $a=d$ (where
  $v_\rho\equiv0$ kills every oscillating term) — but for $a=d$ the price is
  that Theorem U1 is **false as stated**, since its leading term $k\,D_a(0)\,
  e^{-u/2}\mathcal Z_{k-1}$ vanishes identically for $k\ge2$.

The single identity behind all of this: the residue calculus of Lemma 4 is
graded not by *which* singularity each variable takes but by the *total real
part* it contributes, and in that grading

$$\boxed{\ \psi_k(u)=\!\!\sum_{r+m+q=k}\!\!\binom{k}{r,m,q}\,g_a^{\,r}\,D_a(0)^m\,
e^{\frac{\nu}{2}u}\,\mathcal Z^{[r\theta_a]}_q(u)\;+\;\mathcal R_k(u),
\qquad \nu=\nu(r,m)=r\,(2\theta_a-1)-m,\ }$$

$\theta_a$ = the real part of $D_a$'s pole, $g_a=\operatorname*{Res}_{s=\theta_a}
\bigl[D_a(s)\Gamma(s)\bigr]$, and $\mathcal Z^{[\delta]}_q$ the arity-$q$ wave
layer with its $\Gamma$-denominator shifted by $\delta$. $\mathrm{Smooth}$ is
the sub-sum $r\ge1$, $E$ the sub-sum $r=0$ (plus their shares of $\mathcal R_k$),
and **neither is a level of the grading**: both cut across it.

Everything below is residue bookkeeping, Stirling, and the reflection of
`BARRIER_ERROR_WINDOW.md`'s Lemma 5. No numerics.

---

## 0. Prior art, searched first

Within this corpus the $k=2$ case of the boxed identity is **already known and
already measured**, and this note is its $k$-fold derivation, not its
discovery:

- `FAMILY.md` §2 law 1 ("layer algebra"): *"the layers … are the pairwise
  products of the singularity sources of the two Mellin factors, where the
  sources are poles $\cup$ {the zero string} $\cup$ {$s=0$} (exp18), with
  residue-vanishing deletions (row $d$: double zeros kill the string)."* That
  is $k=2$ of the grading below, including the $d$ degeneracy that §5.3 uses
  to refute U1's $d$ row.
- `FAMILY.md` §2 law 2 ("scale spacing = pole location"): $\Lambda$ spreads
  the stack over $X^3/X^{5/2}/X^2$, $\lambda$'s critical pole *collapses it to
  a single scale*, $\mu$ removes it. Those are levels $\nu=2,1,0$ of the boxed
  identity at $k=2,j=1$, and the $\lambda$ collapse is $2\theta_\lambda-1=0$.
- `FAMILY.md` exp18: the $\Lambda\otimes\mu$ cross field's *"smooth term
  $\frac{1}{2\zeta(0)}X^2=-X^2$, measured $-0.99986$"* is the $(r,m,q)=(1,1,0)$
  term of the boxed identity — a $\mathrm{Smooth}$-bucket term sitting at
  **exactly** the pair layer's scale $X^2$. §1.3 below rederives the
  coefficient $-1$ exactly.
- exp18's own caveat — *"the $X^{5/2}$ oscillation grows like
  $X^{1/2}\cos(\gamma\log X)$ at $X^2$ normalization and asymptotically
  dominates the constant"* — is the $k=2$ instance of §5.1's domination
  statement, observed numerically three sessions before it was derived.
- `HOLOGRAM.md` Lemma N is the $r=0$ half of the grading at $k=2$,
  $a=\mu$ — for which $\mathrm{Smooth}$ is empty, which is exactly why Lemma N
  could be written without ever meeting this problem.

So: the phenomenon is corpus prior art at $k=2$; what is new here is the
$k$-fold graded identity, the proof that the whole ladder converges under
`BARRIER_UNIFORM.md`'s Theorem B0 hypothesis and no other, the dual window
transfer law, and the consequences for B1/B2/B1″. **External citations are
from memory; no egress, no literature search was run** (see W8).

---

## 1. The graded residue ladder

### 1.1 Notation, and the one place the dressing enters

Keep `BARRIER_ERROR_WINDOW.md`'s Lemma 4 verbatim:
$$\Psi^{(j)}_k(X)=\frac{1}{(2\pi i)^k}\int_{(c)}\!\!\cdots\!\!\int_{(c)}
\prod_{i=1}^{k}D_a(s_i)\Gamma(s_i)\cdot
\frac{X^{s_1+\cdots+s_k+j}}{\Gamma(s_1+\cdots+s_k+j+1)}\,ds_1\cdots ds_k,$$
and its normalisation $\psi_k(u)=e^{-(\frac k2+j)u}\Psi^{(j)}_k(e^u)$ at the
zero-layer scale. Shift every contour to $\Re s_i=-\eta$, $0<\eta<\tfrac12$.

Per variable, the residues crossed are exactly three kinds, and each
contributes a **residue weight** and a **real part**:

| singularity of $D_a(s)\Gamma(s)$ | weight | real part |
|---|---|---|
| pole of $D_a$ at $s=\theta_a$ | $g_a:=\operatorname*{Res}_{s=\theta_a}[D_a\Gamma]=\mathfrak r_a\Gamma(\theta_a)$ | $\theta_a$ |
| zero $s=\rho$ of $\zeta$ | $v_\rho\Gamma(\rho)$ | $\tfrac12$ (RH) |
| pole of $\Gamma$ at $s=0$ | $D_a(0)$ | $0$ |

(The remaining poles of $\Gamma$ at $s=-1,-2,\dots$ and the trivial zeros at
$s=-2\ell$ lie left of $-\eta$ and are **not** crossed; `BARRIER_ERROR_WINDOW.md`
§2(ii) lists them, harmlessly — they only appear if one shifts further, and
including them changes nothing below except adding levels underneath
$\mathcal R_k$. See W3.)

For the four dressings of `FAMILY.md` §2:

| $a$ | $D_a$ | $\theta_a$ | $g_a$ | $v_\rho$ | $D_a(0)$ |
|---|---|---|---|---|---|
| $\Lambda$ | $-\zeta'/\zeta$ | $1$ | $\Gamma(1)\cdot1=1$ | $-1$ | $-\log2\pi$ |
| $\mu$ | $1/\zeta$ | — (no pole) | $0$ | $1/\zeta'(\rho)$ | $-2$ |
| $\lambda$ | $\zeta(2s)/\zeta(s)$ | $\tfrac12$ | $\Gamma(\tfrac12)/(2\zeta(\tfrac12))=\sqrt\pi/(2\zeta(\tfrac12))$ | $\zeta(2\rho)/\zeta'(\rho)$ | $1$ |
| $d$ | $\zeta(s)^2$ | $1$ (**double**) | — (see §5.3) | $\mathbf 0$ | $1/4$ |

Two entries carry all the weight of this note: $g_\mu=0$ (so
$\mathrm{Smooth}\equiv0$ for $\mu$), and $v^{(d)}_\rho=0$ (so the *wave layer*
is empty for $d$ — `FAMILY.md`'s "residue-vanishing deletion"). Both are
prior art; neither is used in `BARRIER.md`, `BARRIER_UNIFORM.md`, or
`BARRIER_ERROR_WINDOW.md`.

### 1.2 The identity

Write, for $\delta\ge0$ and $q\ge0$,
$$\mathcal Z^{[\delta]}_q(u)\;=\;\sum_{\rho_1,\dots,\rho_q}
\ \prod_{i=1}^{q}v_{\rho_i}\Gamma(\rho_i)\ \cdot\
\frac{e^{i(\gamma_1+\cdots+\gamma_q)u}}{\Gamma\bigl(\sum_i\rho_i+\delta+j+1\bigr)},
\qquad
\mathcal Z^{[0]}_q=\mathcal Z_q,\quad \mathcal Z^{[\delta]}_0=\frac1{\Gamma(\delta+j+1)} .$$

> **Theorem S1 (graded ladder).** Assume RH, simple zeros, $k\le2j$, $D_a$ with
> a **simple** pole at $s=\theta_a$ (or none), and the growth hypothesis (H3)
> of §6. Then, with $\nu(r,m)=r(2\theta_a-1)-m$,
> $$\psi_k(u)=\sum_{\substack{r+m+q=k\\ r,m,q\ge0}}
> \frac{k!}{r!\,m!\,q!}\ g_a^{\,r}\,D_a(0)^m\;e^{\frac{\nu(r,m)}{2}u}\;
> \mathcal Z^{[r\theta_a]}_q(u)\;+\;\mathcal R_k(u),$$
> where $\mathcal R_k$ collects every term with at least one variable left on
> $\Re s=-\eta$ and satisfies
> $$|\mathcal R_k(u)|\ \le\ C_{k,j,\eta}\ e^{\bigl[(k-1)(\theta_a-\frac12)-\frac12-\eta\bigr]u}.$$
> In this decomposition:
> - $(r,m,q)=(0,0,k)$ is the wave layer $\mathcal Z_k$, at level $\nu=0$;
> - $\mathrm{Smooth}=\sum_{r\ge1}(\cdots)$ and $E=\sum_{r=0,\,m+q=k}(\cdots)$,
>   together with their shares of $\mathcal R_k$;
> - a term oscillates **iff $q\ge1$**, with frequency $\gamma_1+\cdots+\gamma_q$.

*Proof.* Shift one variable at a time, as in Lemma 4's proof. Choose which
$r$ indices take the pole, which $m$ take $s=0$, which $q$ take zeros: the
multinomial $\binom{k}{r,m,q}$ counts the choices, and the summand is
symmetric under permuting indices within a class. The residue of
$D_a(s_i)\Gamma(s_i)$ is $g_a$, $D_a(0)$, or $v_{\rho_i}\Gamma(\rho_i)$
respectively (the last two because $\Gamma$ has residue $1$ at $s=0$ and
$D_a$ is regular there; see the table). The remaining factor is evaluated at
$\sum_i s_i=r\theta_a+\sum_{i\in\mathrm{zeros}}\rho_i$, giving
$$\frac{X^{\,r\theta_a+\sum\rho_i+j}}{\Gamma\bigl(r\theta_a+\sum\rho_i+j+1\bigr)}
= e^{(r\theta_a+\frac q2+j)u}\cdot
\frac{e^{i(\sum\gamma_i)u}}{\Gamma(\sum\rho_i+r\theta_a+j+1)},$$
using $X^{\rho_i}=e^{u/2}e^{i\gamma_iu}$ under RH. Summing over the zero
tuples produces exactly $\mathcal Z^{[r\theta_a]}_q$ — *the pole residues do
not create a new object; they shift the smoothing index of an existing wave
layer by $r\theta_a$.* Dividing by $e^{(\frac k2+j)u}$ leaves the exponent
$$r\theta_a+\tfrac q2-\tfrac k2
=r\theta_a+\tfrac{k-r-m}{2}-\tfrac k2
=\tfrac12\bigl[r(2\theta_a-1)-m\bigr]=\tfrac{\nu}{2}.$$
For $\mathcal R_k$: a variable left on $\Re s=-\eta$ contributes real part
$-\eta$ in place of at most $\theta_a$; the largest such term has the other
$k-1$ variables at the pole, giving relative exponent
$(k-1)\theta_a-\eta-\tfrac k2=(k-1)(\theta_a-\tfrac12)-\tfrac12-\eta$, and the
integral over the shifted lines is absolutely convergent by the Remark in
`BARRIER_ERROR_WINDOW.md` §1 under (H3). Oscillation: a term is a pure
exponential $e^{i(\sum_{i\le q}\gamma_i)u}$ summed over zero tuples; it is
constant in $u$ iff $q=0$, and for $q\ge1$ it is a nonconstant uniformly
almost periodic function whenever $\mathcal Z^{[r\theta_a]}_q\not\equiv0$
(§5.2). $\square$

**Absolute convergence of every layer — no new hypothesis.**

> **Theorem S2.** $\bigl\|\sigma^{[\delta]}_q\bigr\|_v:=\sum_{\vec\rho}
> \prod_i|v_{\rho_i}|\,|\Gamma(\rho_i)|\,\bigl|\Gamma(\sum\rho_i+\delta+j+1)\bigr|^{-1}
> <\infty\iff q\le 2(j+\delta)$. Consequently **every** layer in Theorem S1
> converges absolutely under $k\le2j$ alone, and the binding constraint is the
> layer $\delta=0$, $q=k$ — i.e. the pure wave layer $\mathcal Z_k$, which is
> Theorem B0.

*Proof.* Repeat `BARRIER_UNIFORM.md` Lemmas 1–3 with the denominator
$\Gamma(\tfrac q2+\delta+j+1+is)$, $s=\sum\gamma_i$. The numerator is
$(2\pi)^{q/2}e^{-\pi s/2}(1+O(e^{-2\pi\gamma_{\min}}))$ and Stirling gives
$|\Gamma(\sigma+is)|=\sqrt{2\pi}s^{\sigma-1/2}e^{-\pi s/2}(1+O(1/s))$ with
$\sigma=\tfrac q2+\delta+j+1$; the $e^{-\pi s/2}$ cancel exactly, leaving
$|W|\asymp(2\pi)^{(q-1)/2}s^{-(\frac q2+\delta+j+\frac12)}$. Against the
$q$-fold ordinate density $D_q(s)\asymp s^{q-1}\log^qs$ (Lemma 3) the integral
is $\int^Ts^{\frac q2-\delta-j-\frac32}\log^qs\,ds$, convergent iff
$\tfrac q2-\delta-j-\tfrac32<-1$, i.e. $q<2(\delta+j)+1$. Mixed signs are
exponentially damped exactly as in Lemma 2. In Theorem S1,
$q=k-r-m\le k-r$ and $\delta=r\theta_a\ge0$, so $q\le k\le2j\le2(j+\delta)$
with slack $2r\theta_a+r+m$. $\square$

So the pole residues *improve* convergence: the ladder above level $0$ would
converge even past $k=2j$. **The threshold of the whole construction is set by
its single least convergent layer, the one B0 already identifies.**

### 1.3 Verification against a recorded measurement (no new computation)

`FAMILY.md` exp18 measured the ordered cross field
$\sum\Lambda(m)\mu(n)(X-m-n)_+$, i.e. $k=2$, $j=1$, with distinct dressings on
the two variables. Theorem S1's proof applies verbatim to distinct dressings
(drop the multinomial, sum over assignments). The term with the $\Lambda$
variable at its pole ($g_\Lambda=1$, $\theta=1$) and the $\mu$ variable at
$s=0$ ($D_\mu(0)=1/\zeta(0)=-2$) is
$$1\cdot(-2)\cdot\frac{X^{1+0+1}}{\Gamma(1+0+1+1)}=\frac{-2}{\Gamma(3)}X^{2}=-X^{2},$$
against exp18's measured $-0.99986$, and it sits at level $\nu=1-1=0$ — the
**same scale $X^2$ as the pair layer**. This is one closed-form check of the
formula against a number already in the record; it is not a new experiment and
nothing here is fitted.

---

## 2. Exactly how the name fails

> **Proposition S3 (two-way failure).** Let $\mathcal S$ = the bucket
> $\mathrm{Smooth}$ (terms with $r\ge1$) and $\mathcal C$ = the set of terms
> that are constant in $u$ up to a polynomial (i.e. $q=0$). Then for
> $a=\Lambda$ and $k\ge2$, **neither inclusion holds**:
> - $\mathcal S\not\subseteq\mathcal C$: the term $(r,m,q)=(k-1,0,1)$ lies in
>   $\mathrm{Smooth}$, oscillates at every frequency $\gamma$, and has level
>   $\nu=k-1\ge1$, i.e. it is **larger** than $\mathcal Z_k$ by $X^{(k-1)/2}$.
> - $\mathcal C\not\subseteq\mathcal S$: the term $(0,k,0)$ — every variable at
>   $s=0$ — is a nonzero constant $D_a(0)^k/\Gamma(j+1)$ at level $-k$, and it
>   lies in $E$.
>
> The partition $\{\mathcal Z_k,\mathrm{Smooth},E\}$ is by *which singularity*,
> which is orthogonal both to *smooth vs oscillating* and to the *scale
> grading*. Only $\mathcal Z_k$ is a level; $\mathrm{Smooth}$ and $E$ are
> transversal slices.

*Proof.* Read the levels off Theorem S1. $\square$

**The same-scale claim of V7, made exact.** V7's example ($s_1=1$, $s_2=0$,
rest at zeros) is $(r,m,q)=(1,1,k-2)$, level $\nu=1-1=0$ — correct, it sits at
the wave layer's scale for every $k\ge2$. But it oscillates iff $q=k-2\ge1$:

- $k=2$: the level-$0$ companion is the **constant**
  $k(k-1)g_aD_a(0)/\Gamma(j+2)=2g_aD_a(0)/\Gamma(j+2)$
  (for $\Lambda$, $j=1$: exactly $-\log2\pi$). It does not oscillate — and
  therefore it lands precisely on the frequency-$0$ atom of $\mathcal Z_2$. By
  Theorem U3(iii)'s exact computation the mean of $\mathcal Z_2$ is
  $\frac{2\pi}{\Gamma(j+2)}\sum_{\gamma>0}|v_\rho|^2/\cosh\pi\gamma$, i.e.
  $O(e^{-\pi\gamma_1})$ — so at $k=2$ the DC content at level $0$ is the
  $\mathrm{Smooth}$ constant, exceeding the entire $2$-fold spectral mean by a
  factor $\asymp e^{\pi\gamma_1}$ ($\gamma_1=14.1347\ldots$, value from
  memory). **Any reading of the $k$-fold mean is this constant plus an
  exponentially small correction, not the other way round.**
- $k\ge3$: the level-$0$ companions are genuinely oscillating wave layers
  $\mathcal Z^{[r]}_{k-2r}$, $1\le r\le\lfloor k/2\rfloor$, of arities
  $k-2,k-4,\dots$, sitting on top of $\mathcal Z_k$ at the same amplitude and
  at *different frequencies* (arity $k-2r$ sums, not arity $k$ sums). They are
  not removable by any smooth subtraction and they are not part of
  $\sigma^{(j)}_k$.

### 2.1 The correct decomposition and the correct names

Grade by level. For $\nu\in\mathbb Z$ put
$$\mathcal W_{k,\nu}(u)=\sum_{\substack{r+m+q=k\\ \nu(r,m)=\nu}}
\binom{k}{r,m,q}g_a^{\,r}D_a(0)^m\,\mathcal Z^{[r\theta_a]}_q(u),
\qquad\text{so}\qquad
\psi_k(u)=\sum_{\nu}e^{\frac\nu2u}\,\mathcal W_{k,\nu}(u)+\mathcal R_k(u).$$
Each $\mathcal W_{k,\nu}$ is a **finite** sum of absolutely convergent wave
layers (Theorem S2), hence uniformly almost periodic and bounded by
$\sum\binom{k}{r,m,q}|g_a|^r|D_a(0)|^m\|\sigma^{[r\theta_a]}_q\|_v$.

Proposed names, replacing $\{\mathrm{Smooth},E\}$:

| old | new | what it is |
|---|---|---|
| — | $\mathcal W_{k,\nu}$, **level-$\nu$ layer** | u.a.p., explicit finite sum of wave layers |
| part of $\mathrm{Smooth}$ | $\mathcal M_k=\sum_\nu e^{\nu u/2}[\mathcal W_{k,\nu}]_{q=0}$, **the polynomial part** | the $q=0$ terms only: a polynomial in $e^{u/2}$ (times $u$-polynomials for $d$). *This, and only this, is smooth.* |
| $\mathrm{Smooth}\setminus\mathcal M_k$ | **pole-dressed wave layers** | $r\ge1$, $q\ge1$: spectral, oscillating, at levels $\nu\ge -(k-1)$ |
| $E$ | $\mathcal Z$-tail $+\ \mathcal R_k$ | the $r=0$, $\nu\le-1$ slice, plus the shifted-line continuum |

If a two-bucket split is wanted, the honest one is **$\psi_k=\mathcal M_k+
(\text{everything with }q\ge1)$**: computable-in-closed-form versus spectral.
The old split promises "smooth" and delivers a bucket containing the largest
oscillation in the problem.

---

## 3. The window transfer law for growing layers

`BARRIER_ERROR_WINDOW.md`'s Lemma 5 and Theorem U2 handle $|E|\le C e^{-\alpha u}$,
$\alpha>0$. Levels $\nu>0$ need the reflected statement, and the reflection is
exact.

**Definition.** With $\operatorname{supp}|\phi|\subseteq[t_-,t_+]$,
$$\widetilde\Xi_\phi(\theta)=\int|\phi(t)|e^{\theta t}dt,\qquad
\widetilde\Theta_\phi(\theta)=e^{-t_+\theta}\widetilde\Xi_\phi(\theta)
=\int|\phi(t)|e^{-\theta(t_+-t)}dt .$$

**Lemma 6.** $\widetilde\Theta_\phi=\Theta_{\check\phi}$ with
$\check\phi(t)=\phi(-t)$; hence Lemma 5 applies verbatim:
$\widetilde\Theta_\phi(0)=\|\phi\|_1$, nonincreasing, $\downarrow0$,
exponential order of $\widetilde\Xi_\phi$ exactly $t_+$, and Watson's lemma at
the **right** edge gives $\widetilde\Theta_\phi(\theta)\sim c\,\Gamma(m+1)
\theta^{-(m+1)}$ if $|\phi(t_+-v)|\sim cv^m$.

*Proof.* $t_-(\check\phi)=-t_+(\phi)$ and $\widetilde\Xi_\phi(\theta)=
\Xi_{\check\phi}(\theta)$. $\square$

> **Theorem S4 (transfer law, all levels).** Let $G(u)=e^{\beta u}A(u)$ with
> $\|A\|_\infty\le M$, and $w=w_{L,u_0}$, window $[X_0,X]=[e^{u_0+Lt_-},e^{u_0+Lt_+}]$.
> Then
> $$|\langle w,G\rangle|\ \le\
> \begin{cases}
> M\,X^{\beta}\,\widetilde\Theta_\phi(\beta L), & \beta>0\quad(\text{anchored at the window's \textbf{top}}),\\[3pt]
> M\,\|\phi\|_{1}, & \beta=0\quad(\text{anchored nowhere: \(L\)- and \(u_0\)-free}),\\[3pt]
> M\,X_0^{\beta}\,\Theta_\phi(|\beta|L), & \beta<0\quad(\text{anchored at the window's \textbf{bottom}, = Theorem U2}).
> \end{cases}$$
> For $\phi\ge0$ and $A\equiv$ const the first and third hold with equality.

*Proof.* $\langle w,G\rangle=\int\phi(t)G(u_0+Lt)dt$, so
$|\langle w,G\rangle|\le Me^{\beta u_0}\int|\phi(t)|e^{\beta Lt}dt$. For
$\beta>0$ this is $Me^{\beta u_0}\widetilde\Xi_\phi(\beta L)
=MX^\beta\widetilde\Theta_\phi(\beta L)$ since $u_0=\log X-Lt_+$; for $\beta<0$
it is Theorem U2; for $\beta=0$ it is $M\|\phi\|_1$. Equality for $\phi\ge0$,
$A$ constant, is the definition of $\widetilde\Xi_\phi$. $\square$

**Corollary S5 (the two invariants are different endpoints).** Under the
canonical $t_\pm=\pm\tfrac12$, at fixed lower endpoint $X_0$ the level-$\nu$
contribution with $\nu>0$ is
$$\bigl|\langle w,e^{\frac\nu2u}\mathcal W_{k,\nu}\rangle\bigr|
\ \asymp\ \|\mathcal W_{k,\nu}\|\;X_0^{\nu/2}\,e^{\nu L/2}\,\widetilde\Theta_\phi(\nu L/2),$$
which **grows** in $L$ of exponential order $e^{\nu L/2}$ (Lemma 6, order
exactly $t_+$). So:

- $E$ is uniform in $L$ against $X_0$ and degrades as $e^{\alpha L}$ against $X$ (U2);
- $\mathrm{Smooth}$ is uniform in $L$ against $X$ and degrades as $e^{\nu L/2}$ against $X_0$;
- **level $0$ — and only level $0$ — is uniform in $L$ against either.**

The last line is the structural reason $\mathcal Z_k$ deserves to be called
*the signal*: it is the unique scale-invariant level, the only part of $\psi_k$
whose windowed reading is bounded by an $L$-free, $u_0$-free constant
$\|\sigma^{(j)}_k\|_v\|\phi\|_1$. It is also the reason no single endpoint can
serve as *the* invariant of the structure theorem: see §4.1.

---

## 4. The contribution, with its scaling

Fix $a=\Lambda$ ($\theta=1$, $g=1$, $2\theta-1=1$, $\nu=r-m$) and the canonical
window; write $\Theta$'s argument in full.

> **Theorem S6 (size of $\mathrm{Smooth}$, with scaling).** For $k\ge1$,
> $j\ge\lceil k/2\rceil$, $\phi\ge0$:
> $$\bigl|\langle w,\mathrm{Smooth}\rangle\bigr|
> \ \le\ \sum_{\substack{r\ge1,\ r+m+q=k}}\binom{k}{r,m,q}\,|g_a|^{r}|D_a(0)|^{m}\,
> \bigl\|\sigma^{[r\theta_a]}_q\bigr\|_v\cdot
> \begin{cases}X^{\nu/2}\widetilde\Theta_\phi(\nu L/2)&\nu>0\\ \|\phi\|_1&\nu=0\\ X_0^{\nu/2}\Theta_\phi(|\nu|L/2)&\nu<0\end{cases}$$
> and the leading term is attained:
> $$\langle w,\mathrm{Smooth}\rangle
> =\frac{g_a^{\,k}}{\Gamma(k\theta_a+j+1)}\;X^{k(\theta_a-\frac12)}\,
> \widetilde\Theta_\phi\bigl(k(\theta_a-\tfrac12)L\bigr)\;\bigl(1+\mathcal E\bigr),$$
> $$|\mathcal E|\ \le\ k\,|g_a|^{-1}\Gamma(k\theta_a+j+1)\bigl\|\sigma^{[(k-1)\theta_a]}_1\bigr\|_v\;
> X^{-(\theta_a-\frac12)}\;
> \frac{\widetilde\Theta_\phi\bigl((k-1)(\theta_a-\frac12)L\bigr)}
> {\widetilde\Theta_\phi\bigl(k(\theta_a-\frac12)L\bigr)}+O\bigl(X^{-2(\theta_a-\frac12)}\bigr).$$
> For $a=\Lambda$: $\langle w,\mathrm{Smooth}\rangle=\frac{1}{(k+j)!}X^{k/2}
> \widetilde\Theta_\phi(kL/2)(1+O(X^{-1/2}\cdot\Theta\text{-ratio}))$.

*Proof.* Theorem S4 termwise, and the $\nu=k$ term is
$g_a^k e^{k(\theta_a-\frac12)u}/\Gamma(k\theta_a+j+1)$ — a positive multiple of
a pure exponential when $g_a>0$, so Theorem S4's equality case applies.
$\square$

**Sanity check.** Un-normalising, $\Psi^{(j)}_k(X)\sim X^{k+j}/(k+j)!$ for
$a=\Lambda$ — which is the trivial main term
$\int_{\sum u_i\le X}(X-\sum u_i)^j/j!\,du=X^{k+j}/(k+j)!$. The ladder's top is
the main term and nothing else, as it must be.

**The number that matters** is the ratio of the leading *oscillating*
$\mathrm{Smooth}$ level ($\nu=k-1$, $q=1$: a **single-zero** layer) to the
$k$-fold signal at level $0$:
$$\boxed{\ \frac{\bigl|\langle w,\ \text{level }k{-}1\bigr\rangle|}
{\bigl|\langle w,\mathcal Z_k\rangle\bigr|}
\ \asymp\ \frac{k\,|g_a|^{k-1}\bigl\|\sigma^{[(k-1)\theta_a]}_1\bigr\|_v}
{\bigl\|\sigma^{(j)}_k\bigr\|_v\,\|\phi\|_1}\ \
X^{(k-1)(\theta_a-\frac12)}\ \widetilde\Theta_\phi\bigl((k-1)(\theta_a-\tfrac12)L\bigr).\ }$$
For $a=\Lambda$ this is $\asymp X^{(k-1)/2}\widetilde\Theta_\phi((k-1)L/2)$: at
$k=2$, $X^{1/2}\widetilde\Theta_\phi(L/2)$ — exp18's observed
"$X^{1/2}\cos(\gamma\log X)$ dominates the constant", now with its $L$-dependence,
which the measurement could not supply.

### 4.1 What this does to B1″

`BARRIER_ERROR_WINDOW.md`'s Theorem B1″ bounds two of the three terms in its
own display and concludes *"Both bounds are therefore uniform over the
two-parameter family $\{(X_0,L)\}$."* True of those two. But the third term
obeys Corollary S5 with the **opposite** anchor, so:

> **Corollary S7 (no single-endpoint uniformity).** For $a=\Lambda$ or $d$ and
> $k\ge1$ there is no one-endpoint parameterisation in which all three terms
> of B1″ are uniform in $L$: the spectral tail is $L$-free, $E$ is uniform
> against $X_0$ and grows as $e^{L/2}$ against $X$, and $\mathrm{Smooth}$ is
> uniform against $X$ and grows as $e^{kL/2}$ against $X_0$. The honest closure
> fixes **both** endpoints $(X_0,X)$, with $L=\log(X/X_0)$ determined.
> For $a=\lambda$ the $\mathrm{Smooth}$ obstruction is absent ($\nu\le0$
> throughout) and B1″'s $(X_0,L)$ closure is complete; for $a=\mu$ it is
> vacuous.

This does not contradict B1″ — it completes it. It does correct the reading of
`SWEEP.md` §2 twice over: the *error* floor is set by the window's bottom
(`BARRIER_ERROR_WINDOW.md` §5.2), and the *contamination* by unmodelled
oscillating layers is set by the window's top.

---

## 5. What must be revised

### 5.1 Corollary B2 of `BARRIER.md` is false as stated for $k\ge2$, $a\in\{\Lambda\}$

B2 concludes that two configurations with $\langle\sigma_k-\sigma'_k,\widehat
w\rangle=0$ for all span-$L$ windows give identical windowed observables. But
$\psi_k$ depends on the zeros through the *whole ladder*
$\{\mathcal W_{k,\nu}\}$, and the layers $\nu\ge1$ are built from
$\sigma^{[r\theta_a]}_{k-r}$ with $r\ge1$ — lower-arity spectral measures that
$\sigma_k$ does not determine.

> **Corollary B2′.** Indistinguishability to all span-$L$ WL observables at
> tolerance $\epsilon$ (in the level-$0$ normalisation) requires, for every
> $0\le r\le k-1$,
> $$\bigl|\bigl\langle\sigma^{[r\theta_a]}_{k-r}-\sigma'^{[r\theta_a]}_{k-r},
> \widehat w\bigr\rangle\bigr|\ \lesssim\ \epsilon\;X^{-r(\theta_a-\frac12)},$$
> i.e. the **lower** the arity, the **more precisely** the layers must match.
> At $r=k-1$ this is a demand on the arity-$1$ layer — a weighted zero-counting
> measure — at precision $\epsilon X^{-(k-1)/2}$.

So for $a=\Lambda$ the $k$-fold barrier problem *contains* the $1$-fold one at
far higher precision: the $k$-fold correlation content is the **last** thing a
WL observer sees, not the first. Two operational consequences:

1. **The barrier is easier to state and harder to achieve than B2 suggested.**
   A construction that matches only $\sigma_k$ does not produce
   indistinguishability.
2. **Choose the dressing.** For $a=\mu$, $\mathrm{Smooth}\equiv0$ and level $0$
   is $\mathcal Z_k$ alone: the $k$-fold layer is the leading term and B2 is
   correct as stated. For $a=\lambda$ the pole is critical, every
   $\mathrm{Smooth}$ layer sits at level $0$, so there is no burial but also no
   scale separation — the arity-$k$ and arity-$(k-r)$ contents are
   superposed at equal amplitude and can only be separated by frequency. For
   $a=\Lambda$ the signal is buried $X^{(k-1)/2}$ deep. **$\mu$ is the unique
   dressing for which the $k$-fold spectral measure is the leading behaviour**
   — a derived restatement of `FAMILY.md`'s "$\mu$ is the terminal object".

### 5.2 Theorems U1, U2, U3: what survives

- **U2, U3(i), Lemma 5: untouched.** They are statements about an arbitrary
  $E$ with $|E|\le Ce^{-\alpha u}$; $\mathrm{Smooth}$ is a different function.
- **U1: correct as stated about $E$** — $E$ is defined as the $r=0$ bucket, so
  no $\mathrm{Smooth}$ term was double-counted (U1's proof step (ii) says so,
  and Theorem S1 confirms the buckets are disjoint). **$\alpha=\tfrac12$
  survives as the leading decay rate of $E$** for $a\in\{\Lambda,\mu,\lambda\}$.
- **But $\alpha=\tfrac12$ is not the error floor of the observable.** The
  residual after subtracting everything an observer can compute in closed form
  ($\mathcal M_k$) is dominated by level $k-1$, not level $-1$. Quoting
  $\varepsilon=C_EX_0^{-1/2}\Theta_\phi(L/2)$ as *the* floor presumes exact
  removal of the pole-dressed wave layers, which are spectral and hence
  precisely what is being measured. This is the same lesson as `HOLOGRAM.md`
  §7 at one further remove: **a rate needs its evaluation point (U5's lesson)
  and its level (this note's).**
- **U1's constant $C_E$ is not the level-$(-1)$ coefficient of $\psi_k$ for
  $k\ge3$.** $\mathrm{Smooth}$ has its own level-$(-1)$ term
  $(r,m,q)=(1,2,k-3)$, so
  $$\mathcal W_{k,-1}=k\,D_a(0)\,\mathcal Z_{k-1}
  +\underbrace{\tfrac{k!}{1!\,2!\,(k-3)!}\,g_a\,D_a(0)^2\,\mathcal Z^{[\theta_a]}_{k-3}}_{k\ge3\ \text{only}} .$$
  $\mathrm{Smooth}$ therefore **competes with the $s=0$ layer at its own level
  for $k\ge3$** (same $e^{-u/2}$, comparable constants) and **dominates it for
  every $k\ge1$** via level $k(\theta_a-\tfrac12)>0$. Answering the question as
  posed: both, at different levels.
- **U3(ii),(iii) survive** (statements about $E$ and about $\mathcal Z_{k-1}$),
  but their *interpretation* as "the obstruction to uniformity" is now one of
  two obstructions, the smaller one.

### 5.3 The $d$ row of U1's table is wrong, and the reason is prior art

U1 asserts $\alpha=\tfrac12$ *"across the whole family of `FAMILY.md` §2 — the
exponent is a property of the archimedean factor $\Gamma(s)$, not of the
arithmetic"*, justified by $D_a(0)\ne0$ for all four dressings. For $a=d$ the
justification is incomplete: U1's leading term is $kD_a(0)e^{-u/2}\mathcal
Z_{k-1}$, and $D_d=\zeta^2$ has **double zeros** at $\rho$, hence *no poles*
there, hence $v^{(d)}_\rho=0$ and $\mathcal Z_q\equiv0$ for all $q\ge1$. So:

- for $k=1$, $\mathcal Z_0=1/j!\ne0$ and $\alpha=\tfrac12$ holds;
- for $k\ge2$, the level-$(-1)$ term of $E$ **vanishes identically**; the first
  surviving term of $E$ is $(0,k,0)$ at level $-k$, giving $\alpha=k/2$, not
  $\tfrac12$.

This is exactly `FAMILY.md` §2's "residue-vanishing deletion (row $d$: double
zeros kill the string)" — corpus prior art that the $d$ row of U1's table
contradicts. Two further consequences for $d$, recorded and not pursued:

1. $\mathrm{Smooth}$ is genuinely smooth for $d$: with $v_\rho\equiv0$, every
   surviving term has $q=0$, so $\psi_k^{(d)}=\mathcal M_k+\mathcal R_k$ with
   $\mathcal M_k$ a polynomial in $e^{u/2}$ and $u$ (the double pole
   contributes one factor of $u$ per pole variable, so degree $\le k$ — which
   is `FAMILY.md`'s "$X^3\log^2X$-type" at $k=2$, $j=1$). **The name is correct
   for exactly the one dressing whose oscillation the decomposition cannot
   see.**
2. That oscillation is real (Voronoi $\sqrt{nX}$ frequencies, `FAMILY.md`) and
   lives entirely in $\mathcal R_k$. But the shifted-line bound of the Remark
   in `BARRIER_ERROR_WINDOW.md` §1 assumes $D_a$ grows at most logarithmically
   on $\Re s=-\eta$; by the functional equation $\zeta(-\eta+it)\asymp
   |t|^{\frac12+\eta}$, so $|D_d|\asymp|t|^{1+2\eta}$ there and the hypothesis
   **fails for $d$** (it holds for $\Lambda$: $\log|t|$; for $\mu$:
   $|t|^{-\frac12-\eta}$, decay; for $\lambda$: $|t|^{\eta}$). So the entire
   contour-shift derivation is licensed for $\Lambda,\mu,\lambda$ and **not for
   $d$**, which needs the functional equation, not a shift. Recommend: strike
   $d$ from the scope of B1/B1′/B1″/U1 rather than repair it here.

---

## 6. Hypotheses, and exactly where each enters

| # | hypothesis | where it enters | what fails without it |
|---|---|---|---|
| H1 | RH | $X^{\rho}=e^{u/2}e^{i\gamma u}$ in Theorem S1; Lemma 1 in Theorem S2 | the grading loses its $\tfrac12$-spacing; levels become a continuum in $\Re\rho$ |
| H2 | simple zeros | $v_\rho=\operatorname{Res}D_a$ well defined, one residue per zero | multiplicities multiply the weights (`BARRIER_UNIFORM.md` U4); thresholds unaffected |
| H3 | $D_a$ of at most polynomial growth $O(|t|^{A})$ on $\Re s=-\eta$, with $A$ small enough for the Remark's convergence count | the bound on $\mathcal R_k$ in Theorem S1 | holds for $\Lambda$ ($\log|t|$), $\mu$ ($|t|^{-1/2-\eta}$), $\lambda$ ($|t|^{\eta}$); **fails for $d$** (§5.3) |
| H4 | $D_a$'s pole at $\theta_a$ is **simple** | the single weight $g_a$ per pole variable in Theorem S1 | for $d$ (double pole) each pole variable contributes a degree-$1$ polynomial in $u$; the ladder acquires $u^{r}$ factors |
| H5 | $k\le2j$ (Theorem B0) | absolute convergence of every layer, Theorem S2 | the level-$0$ layer diverges first; the ladder above it still converges |
| H6 | $0<\eta<\tfrac12$ | only $s=0$ among $\Gamma$'s poles is crossed; no trivial zeros | shifting further adds levels below $\mathcal R_k$'s bound; nothing above level $-\tfrac12-\eta$ changes |
| $(\star)$ | $\mathcal Z^{[\delta]}_q\not\equiv0$ | *sharpness only* of the domination claims for $q\ge3$; not needed for any upper bound | the ratio in §4 becomes an upper bound without a matching lower bound |

$(\star)$ is discharged unconditionally for $q\le2$ by the Bohr-coefficient
computations of Theorem U3(iii), which apply verbatim with $j\mapsto j+\delta$:
the arity-$1$ coefficient at frequency $\gamma_1$ is
$v_{\rho_1}\Gamma(\rho_1)/\Gamma(\rho_1+\delta+j+1)\ne0$, and the arity-$2$
mean is $\frac{2\pi}{\Gamma(\delta+j+2)}\sum_{\gamma>0}|v_\rho|^2/\cosh\pi\gamma>0$.
Since the leading oscillating $\mathrm{Smooth}$ layer has **arity $1$**
($q=k-r=1$ at $r=k-1$), **the domination statement of §4 is unconditional for
every $k$** — no $(\star)$ needed. That is the one place where the pole ladder
is easier than the wave layer it buries.

---

## 7. Status after this note

| ingredient | after `BARRIER_ERROR_WINDOW.md` | after this note |
|---|---|---|
| $E$: shape, size, uniformity | settled, $\alpha=\tfrac12$, invariant $X_0$ (U1–U3) | unchanged for $\Lambda,\mu,\lambda$; **$\alpha=\tfrac12$ fails for $d$, $k\ge2$** (§5.3) |
| $\mathrm{Smooth}$: shape | not analysed | **the $r\ge1$ slice of an explicit graded ladder** (S1), absolutely convergent under B0 alone (S2) |
| $\mathrm{Smooth}$: size and scaling | not analysed | $\asymp X^{k(\theta_a-1/2)}\widetilde\Theta_\phi(k(\theta_a-\tfrac12)L)$, attained (S6); leading *oscillating* part $X^{(k-1)(\theta_a-1/2)}$ |
| $\mathrm{Smooth}$: the name | flagged misleading (V7) | **wrong for $\Lambda$ (dominates), wrong for $\lambda$ (degenerate at level $0$), vacuous for $\mu$, correct for $d$ only because $d$'s wave layer is empty** (S3) |
| uniformity of B1″ in $L$ | claimed over $\{(X_0,L)\}$ | **holds for the two terms bounded there; fails for the third — no single-endpoint closure exists** (S7) |
| Corollary B2 | as in `BARRIER.md` | **false as stated for $\Lambda$, $k\ge2$; corrected form B2′ demands all lower-arity layers at precision $\epsilon X^{-r/2}$** |
| which dressing to probe $k$-fold correlations with | not asked | **$\mu$** — the unique dressing with $\mathrm{Smooth}\equiv0$ (§5.1) |

**The item is discharged.** What is *not* done: the $d$ case (needs the
functional equation, §5.3), and the lower bound matching S6 for $\phi$ of
variable sign.

---

## 8. Honesty ledger

| # | item | status |
|---|---|---|
| W1 | Theorem S1 (graded ladder) | **Proved under H1–H4, H6.** It is the residue bookkeeping of Lemma 4 with the residues sorted by real part instead of by type. The only step with any content is the observation that $r$ pole residues turn the remaining zero sum into $\mathcal Z^{[r\theta_a]}_q$ — a smoothing-index shift, not a new object. |
| W2 | Theorem S2 (convergence of every layer) | **Proved given H1, H2.** It is `BARRIER_UNIFORM.md` Lemmas 1–3 with $j\mapsto j+\delta$; nothing new is assumed and B0's threshold is recovered as the $\delta=0$ case. |
| W3 | The contour shift | Inherited, not re-derived. `BARRIER_ERROR_WINDOW.md` V3 flags the truncation at ordinates $T_\nu$ as sketched; that is unchanged here. I additionally note that §2(ii) of that note lists trivial-zero residues at $s=-2m$ which are **not crossed** at shift depth $\eta<\tfrac12$ (H6) — harmless (they are bounded by the same $\mathcal R_k$ estimate if one shifts further), but the enumeration there is of a deeper shift than the one performed. |
| W4 | Theorem S4, Lemma 6 | **Proved, unconditional, pure real analysis.** Lemma 6 is Lemma 5 under $t\mapsto-t$; Theorem S4 is Theorem U2 plus its reflection. The $\beta=0$ case is the only $L$-free one and that is a two-line consequence, not a deep fact. |
| W5 | Theorem S6 and the boxed ratio | **Proved as an upper bound unconditionally; attained for $\phi\ge0$** at the top level (pure exponential, $g_a>0$ for $\Lambda$). The relative error $\mathcal E$ carries a profile ratio $\widetilde\Theta_\phi((k-1)\cdot)/\widetilde\Theta_\phi(k\cdot)$ which is $\asymp1$ for a boxcar and profile-dependent (bounded, but not by an absolute constant) for $\phi\in C_c^\infty$. **I have not made that ratio uniform over profiles** and it should not be quoted as $1+O(X^{-1/2})$ without fixing $\phi$. |
| W6 | Corollary B2′ | Stated as a *necessary* condition and proved as such (each level's contribution must individually be within tolerance, since the levels have distinct exponential rates in $X$ and a WL observer may vary $X$). **Sufficiency is not claimed** and would need the levels to be separable by finitely many windows, which is a statement about a Vandermonde-type system I have not written. **RESOLVED 2026-08-14 — `BARRIER_LEVEL_SEPARATION.md`: sufficiency is proved (B2″, Thm L5) and needed no Vandermonde — only the anchored taper identity $\langle w,e^{\nu u/2}G\rangle=A_\nu^{\nu/2}\langle\sigma_G,\widehat{w^{(\nu)}}\rangle$ (so the test function is the tapered $\widehat{w^{(\nu)}}$, not $\widehat w$) plus the triangle inequality; the levels $\nu<0$ turn out **vacuous** for $X_0\ge(6\beta_k\Sigma_k\|\phi\|_1/\epsilon)^2$. The Vandermonde is written (Thm L4: nodes $\xi_\nu=e^{\nu\Delta/2}$, $\det=y^{\binom{k+1}{3}}\prod_d(y^d-1)^{k+1-d}$, $y=e^{\Delta/2}$; $k+1$ log-translated windows for $\Lambda$, one for $\mu,\lambda$). ~~It proves finite separation only down to $\nu=k-1$ and a universal lower-level no-go (L8).~~ **CORRECTION — `BARRIER_LEVEL_EXTRACTION_CORRECTION.md`: L8(b) inferred a lower error bound from a term inside L7's upper bound, and L8(d) inferred a first return from equidistribution density; both are retracted.  The exact response is $\ell_\nu(\xi_\mu e^{i\gamma\Delta})$, proving generic-spacing leakage but leaving selected finite spacings open.** For $\mu$ the target is the top of a multiplicity-free ladder: one window, unconditional. For $\lambda$ all nodes coincide ($2\theta_\lambda-1=0$) and **no family of any size separates the $r$-grading** (Thm L9 = exp19's measured crowding). Side effect: H6 must be relaxed to $\eta>(k-1)(\theta_a-\frac12)-\frac12$ for $k\ge3$, else $\mathcal R_k$ sits above level $0$.** |
| W7 | §5.3, the $d$ row | The vanishing $v^{(d)}_\rho=0$ is `FAMILY.md` prior art and elementary ($\zeta^2$ has no pole at $\rho$). The growth failure of H3 for $d$ uses $\zeta(-\eta+it)\asymp|t|^{1/2+\eta}$ from the functional equation and convexity — **standard, quoted from memory, no egress to verify**. The conclusion drawn is conservative: strike $d$ from the scope, do not repair. |
| W8 | Prior art | The $k=2$ layer algebra, the pole-location scale spacing, the $\lambda$ degeneracy, the $d$ deletion, and the $\Lambda\mu$ smooth term are **all `FAMILY.md` §2 / exp18 prior art**, cited in §0 before the derivation, per `CLAUDE.md`. External ingredients (Mellin–Barnes, Stirling, Watson's lemma, Bohr almost periodicity, the functional-equation growth of $\zeta$) are textbook and **from memory; no literature search was run — egress is blocked.** Someone with egress should check whether the graded ladder is standard for Riesz means of products of Dirichlet series; the computation is routine enough that it probably is, and this note claims no novelty for the mathematics, only for the correction. — **PRIOR-ART SWEEP 2026-08-14: "egress is blocked" was half wrong and the half matters — `WebSearch` works, `WebFetch` does not,** failing on every host tried with the verbatim `{"error_type":"EGRESS_BLOCKED","domain":"arxiv.org","message":"Access to arxiv.org is blocked by the network egress proxy."}`. Searched. **RESOLVED-NO-MATCH for the graded ladder as such**; queries: *Riesz mean order j k-fold Dirichlet series convergence threshold sum over zeta zeros Gamma quotient Stirling*; *window transfer law Riesz mean multiple Dirichlet series uniformity*; *Cesàro average sums of k primes absolute convergence double sum over zeros Gamma quotient*. **RESOLVED-FOUND for the shelf it belongs on, which the row correctly guessed:** the Cesàro/Riesz-mean-of-a-product-of-Dirichlet-series literature is live and states the $\prod_i\Gamma(\rho_i)/\Gamma(\sum_i\rho_i+j+1)$ weight and its order-vs-factor-count convergence trade-off explicitly — Languasco–Zaccagnini arXiv:1206.0251 and arXiv:2012.02503, Cantarini arXiv:1607.05629, Brüdern–Kaczorowski–Perelli arXiv:1712.00737 (explicit formula for the Cesàro–Riesz mean of *every* order $k>0$); see `BARRIER_UNIFORM.md` U7. All external citations here therefore move **from-memory → search-summary (śabda) grade**, never to verified. Absence of a located source for the ladder is not evidence of novelty. Attribution status only. |
| W9 | Normalisation | Level-$0$ (zero-layer) normalisation $X^{k/2+j}$ throughout, as in `BARRIER_ERROR_WINDOW.md`; `BARRIER.md`'s $X^{k+1}$ is level $\nu=k$ at $j=1$, $a=\Lambda$ — i.e. `BARRIER.md` normalises *at the top of the ladder* and this note *at level $0$*. Ratios between levels are normalisation-free, so §4's boxed ratio and §5's conclusions are unaffected by the choice; absolute sizes are not, and must not be compared across notes without fixing one. |
| W10 | The one numerical value quoted | $\gamma_1=14.1347\ldots$ in §2, used only to say that $e^{-\pi\gamma_1}$ is negligible next to $\log2\pi$. **From memory, and no claim depends on its digits** — only on $\gamma_1>4$, which is elementary. exp18's $-0.99986$ is quoted from the record as a *check* of a derived closed form ($-1$), not as an input. |
| W11 | No numerics | Nothing here was computed. Every constant is a closed form: $g_a$, $D_a(0)$, multinomials, $\Gamma$-values. No exponent is fitted; every exponent is $r(2\theta_a-1)-m$ for integers $r,m$. |
