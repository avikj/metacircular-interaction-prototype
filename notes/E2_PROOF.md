# Theorem E2 proved, and Proposition M1 corrected

Discharges items 3 and 4 of the `notes/METHOD.md` §3 proof queue. Both were
listed there as "currently justified by a correlation of 1.0000" and "the
$O(1)$ in M1"; both are now proofs, and the second turned up **two errors in
M1** and a re-diagnosis of its flagged gap.

No numerics are load-bearing. The two tables of exact-rational values are
checks on derivations, licensed by `CLAUDE.md`; every asymptotic statement
is proved or explicitly ledgered as unproved.

---

# Part 1 — Theorem E2

## 1.0 Setup

$$\Lambda^\sharp_Q=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q,\qquad
\Lambda^\flat_Q=\Lambda-\Lambda^\sharp_Q,\qquad P_Q:=\prod_{p\le Q}p,$$

$$A(s)=-\frac{\zeta'}{\zeta}(s),\quad A^\sharp(s)=\sum_n\frac{\Lambda^\sharp_Q(n)}{n^s},\quad A^\flat=A-A^\sharp,$$

initially for $\Re s>1$ ($\Lambda^\sharp_Q$ is bounded for fixed $Q$).
$\rho=\beta+i\gamma$ runs over nontrivial zeros with multiplicity $m_\rho$.

$$G_1(X)=\sum_{m,n\ge1}\Lambda(m)\Lambda(n)(X-m-n)_+
=[\sharp\sharp]+\bigl([\sharp\flat]+[\flat\sharp]\bigr)+[\flat\flat],$$

a term-by-term identity of finite sums, needing no justification.

**What "frequency" means.** For a block $B$ put
$\Phi_B(w)=\int_0^\infty B(X)X^{-w-1}dX$. A term $cX^{w_0}$ is a pole of
$\Phi_B$ at $w_0$ with residue $c$; in $X=e^u$ it is a wave of frequency
$\Im w_0$ at scale $X^{\Re w_0}$. So *"which frequencies does a block
carry"* is literally *"where are the poles of $\Phi_B$"*. This is the
formulation in which E2 is a theorem rather than a correlation.

## 1.1 The mechanism: two lemmas about poles

**Lemma 1 (the sharp block owns the pole at $s=1$ and nothing else).**
$A^\sharp$ continues meromorphically to $\mathbb C$ with exactly one pole:
a simple pole at $s=1$ of residue exactly $1$, for every $Q\ge1$.

*Proof (two ways; both are short and it is worth having both).*

(i) *Periodicity.* Each $c_q$ with $\mu(q)\ne0$, $q\le Q$, is $q$-periodic
with $q\mid P_Q$, so $\Lambda^\sharp_Q$ is $P_Q$-periodic and
$A^\sharp(s)=P_Q^{-s}\sum_{a=1}^{P_Q}\Lambda^\sharp_Q(a)\zeta(s,a/P_Q)$.
Each Hurwitz $\zeta(s,x)$ has a single simple pole at $s=1$ of residue $1$
and **no other singularity** — in particular no zeta zero enters. The
residue is the mean value
$$\frac1{P_Q}\sum_{a=1}^{P_Q}\Lambda^\sharp_Q(a)
=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}\cdot\frac1q\sum_{a\bmod q}c_q(a)
=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}\mathbf 1_{q=1}=1,$$
using $\sum_{a\bmod q}c_q(a)=q\sum_{d\mid q}\mu(q/d)=q\mathbf 1_{q=1}$.

(ii) *Euler-factor form.* From $\sum_n c_q(n)n^{-s}=\zeta(s)\sum_{d\mid q}\mu(q/d)d^{1-s}$,
$$A^\sharp(s)=\zeta(s)\,g_Q(s),\qquad
g_Q(s)=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}\prod_{p\mid q}\bigl(p^{1-s}-1\bigr),$$
a **finite** Dirichlet polynomial, hence entire; at $s=1$ every factor
$p^0-1$ vanishes so only $q=1$ survives, $g_Q(1)=1$. $\square$

> The point that does all the work is the **absence of zeta zeros from the
> polar divisor of $A^\sharp$**. Form (ii) makes it vivid: $A^\sharp=\zeta\cdot g_Q$,
> so the nontrivial zeros are **zeros** of $A^\sharp$, never poles. A pole
> is what produces an $X^\rho$ term after contour shifting; a zero produces
> nothing. That is the entire content of "the BC block is spectrally dead",
> and it is *exact at every $Q$*, not asymptotic.

**Lemma 2 (the flat block owns the zeros and not the pole).**
$A^\flat=-\zeta'/\zeta-\zeta g_Q$ is meromorphic on $\mathbb C$ with **no
pole at $s=1$** (the two simple poles cancel exactly:
$\operatorname{Res}_{s=1}(-\zeta'/\zeta)=+1$ and
$\operatorname{Res}_{s=1}\zeta g_Q=g_Q(1)=1$); a simple pole at each
nontrivial zero $\rho$ of residue $-m_\rho$; a simple pole at each trivial
zero $-2k$ of residue $-1$; and no others. $\square$

Together: **the pole at $s=1$ and the zeros have been separated into
different blocks, exactly, at every finite $Q$, with no approximation, no
$Q\to\infty$ limit, and no RH.**

## 1.2 The Mellin–Barnes representation

**Lemma 3 (Dirichlet/Beta kernel).** For $\Re s_1,\Re s_2>0$,
$$\iint_{u,v>0,\,u+v\le X}u^{s_1-1}v^{s_2-1}(X-u-v)\,du\,dv
=\frac{\Gamma(s_1)\Gamma(s_2)}{\Gamma(s_1+s_2+2)}X^{s_1+s_2+1}.$$

**Lemma 4 (the kernel is absolutely integrable).** With
$K(s_1,s_2)=\Gamma(s_1)\Gamma(s_2)/\Gamma(s_1+s_2+2)$ and $s_j=c_j+it_j$,
$\iint_{\mathbb R^2}|K|\,dt_1dt_2<\infty$ for any fixed $c_1,c_2>0$.

*Proof.* Stirling: $|\Gamma(c+it)|\sim\sqrt{2\pi}|t|^{c-1/2}e^{-\pi|t|/2}$.
In same-sign quadrants the exponentials cancel exactly and
$|K|\asymp|t_1|^{c_1-1/2}|t_2|^{c_2-1/2}(|t_1|+|t_2|)^{-c_1-c_2-3/2}\asymp r^{-5/2}$
in polar coordinates, independently of $c_1,c_2$, and
$\int^\infty r^{-5/2}\,r\,dr<\infty$. Corners ($|t_2|=O(1)$):
$|K|\ll|t_1|^{-c_2-2}$. Opposite-sign quadrants:
$|K|\ll e^{-\pi\min(|t_1|,|t_2|)}$. $\square$

This is Theorem D‴'s $s^{-5/2}$ law appearing as a *convergence* statement;
it is the analytic reason one Cesàro smoothing suffices.

**Proposition 5.** For $c_1,c_2>1$ and any $A_1,A_2\in\{A^\sharp,A^\flat,A\}$,
$$B_{12}(X)=\frac1{(2\pi i)^2}\iint A_1(s_1)A_2(s_2)K(s_1,s_2)X^{s_1+s_2+1}ds_1ds_2,$$
by Lemma 3 and Fubini (licensed by absolute convergence of the Dirichlet
series for $c_j>1$ and Lemma 4).

**Proposition 6 (the form in which the poles are visible).** For $c>1$ and
$\Re w>c+2$,
$$\Phi_{12}(w)=\frac1{2\pi i}\int_{(c)}\frac{\Gamma(s)\Gamma(w-1-s)}{\Gamma(w+1)}A_1(s)A_2(w-1-s)\,ds.$$

*Proof.* $\int_0^\infty(X-N)_+X^{-w-1}dX=N^{1-w}/(w(w-1))$ for $\Re w>1$, so
$\Phi_{12}(w)=\frac1{w(w-1)}\sum_{m,n}\Lambda_1(m)\Lambda_2(n)(m+n)^{1-w}$,
absolutely convergent for $\Re w>3$ since $(\Lambda*\Lambda)(N)\ll N\log^2N$.
Apply Mellin–Barnes $(1+x)^{-a}=\frac1{2\pi i}\int_{(c)}\frac{\Gamma(s)\Gamma(a-s)}{\Gamma(a)}x^{-s}ds$
with $a=w-1$, $x=m/n$, and $w(w-1)\Gamma(w-1)=\Gamma(w+1)$. Fubini holds by
$e^{-\pi|t|}$ decay of $\Gamma(s)\Gamma(w-1-s)$ against absolute
convergence on the two lines. $\square$

## 1.3 Pole extraction

Continue leftwards in $w$, keeping the $s$-contour left of the *moving*
poles. Using $A_2(w-1-s)\sim-r_2/(s-(w-2))$ near $s=w-2$ (from a pole of
$A_2$ at argument $1$ with residue $r_2$) and
$A_2(w-1-s)\sim+m_\rho/(s-(w-1-\rho))$ near $s=w-1-\rho$:

| source | requires | pole at | residue |
|---|---|---|---|
| $r_2\Gamma(w-2)A_1(w-2)/\Gamma(w+1)$ | $A_2$ pole at 1 **and** $A_1$ pole at 1 | $w=3$ | $r_1r_2\Gamma(1)^2/\Gamma(4)=r_1r_2/6$ |
| same | $A_2$ pole at 1, $A_1$ pole at $\rho$ | $w=\rho+2$ | $-r_2m_\rho/(\rho(\rho+1)(\rho+2))$ |
| $\rho$-sum | $A_2$ pole at $\rho$, $A_1$ pole at 1 | $w=\rho+2$ | $-r_1m_\rho/(\rho(\rho+1)(\rho+2))$ |
| $\rho$-sum | $A_2$ pole at $\rho$, $A_1$ pole at $\rho'$ | $w=\rho+\rho'+1$ | $m_\rho m_{\rho'}\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$ |
| $\Gamma(s)$ pole at $s=-j$ × $A_2$ pole at 1 | — | $w=2-j$ (real) | — |
| $\Gamma(s)$ pole at $s=-j$ × $A_2$ pole at $\rho$ | — | $w=\rho+1-j$ | — |

Everything follows by feeding in Lemmas 1–2: $r_\sharp=1$, $r_\flat=0$;
$A^\sharp$ has no $\rho$-poles, $A^\flat$ has all of them.

## 1.4 Theorem E2

> **Theorem E2a (block spectral support; UNCONDITIONAL).** Fix $Q\ge1$. In
> $\Re w>3/2$:
>
> 1. $\Phi_{\sharp\sharp}$ has poles only at **real** $w$; the rightmost is
>    simple at $w=3$ with residue $\tfrac16$. No pole at any $\rho+2$ or
>    $\rho+\rho'+1$: the $[\sharp\sharp]$ block carries no zeta-zero
>    frequency at any scale.
> 2. $\Phi_{\sharp\flat}+\Phi_{\flat\sharp}$ has **no** pole at $w=3$, and
>    its non-real poles are **exactly** $w=\rho+2$, residue
>    $-2m_\rho/(\rho(\rho+1)(\rho+2))$.
> 3. $\Phi_{\flat\flat}$ has **no** pole at $w=3$ and **none** at any
>    $\rho+2$; its poles are **exactly** $w=\rho+\rho'+1$, residue
>    $m_\rho m_{\rho'}\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$.
>
> (Coincident points: residues add.)

*Proof.* (1) $A_1=A_2=A^\sharp$: row 1 gives $w=3$, residue $1/6$; rows
2–4 need a $\rho$-pole and are void; row 5 gives real $w\le2$; row 6 void.
Every surviving pole comes from $\Gamma$-poles at non-positive integers
together with $s=1$, hence lies in $\{3,2,1,0,\dots\}\subset\mathbb R$.

(2) $A_1=A^\sharp,A_2=A^\flat$ and transpose: rows 1–2 need $r_\flat\ne0$,
void. Row 3 gives $w=\rho+2$, residue $-m_\rho/(\rho(\rho+1)(\rho+2))$; the
transposed block gives the same via row 2 with $r_2=r_\sharp=1$ — hence the
factor $2$. Row 4 needs $\rho$-poles in both factors, void. Row 6 sits at
$\Re w\le3/2$.

(3) $A_1=A_2=A^\flat$: rows 1–3 all need a pole at $s=1$, void by Lemma 2.
Row 4 gives the pair layer. Row 6 sits at $\Re w\le3/2$. $\square$

> **Theorem E2b (scales and frequencies; RH used here and only here).**
> Under RH, in $\Re w>3/2$:
>
> | block | poles | scale | frequencies |
> |---|---|---|---|
> | $[\sharp\sharp]$ | $w=3$, real $w\le2$ | $X^3$ | $\{0\}$ |
> | $[\sharp\flat]+[\flat\sharp]$ | $w=\rho+2$ | $X^{5/2}$ | $\{\gamma\}$ |
> | $[\flat\flat]$ | $w=\rho+\rho'+1$ | $X^2$ | $\{\gamma+\gamma'\}$ |
>
> $$[\sharp\sharp]=\tfrac{X^3}{6}+O(X^{2+\varepsilon}),\qquad
> [\sharp\flat]+[\flat\sharp]=-2\sum_\rho\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}+O(X^{2+\varepsilon}),$$
> $$[\flat\flat]=\sum_{\rho,\rho'}\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}+O(X^{3/2+\varepsilon}),$$
> the residue sums absolutely convergent by $\sum_\gamma\gamma^{-3}<\infty$
> and $\int^\infty T\log^2T\cdot T^{-5/2}dT<\infty$ (D′/D‴).

RH enters **only** through $\Re\rho=\tfrac12$, to turn E2a's pole locations
into the numbers $5/2$ and $2$. **The block-attribution statement itself is
unconditional.** Adding the three lines reproduces Theorem D exactly, which
is the consistency check.

*Proof from E2a.* Shift $w$ leftwards and apply Mellin inversion,
collecting the listed residues; horizontal segments at heights $T_j$ with
$|\zeta'/\zeta(\sigma+iT_j)|\ll\log^2T_j$ (Titchmarsh §9.6, Davenport §17)
against the kernel's $r^{-5/2}$ decay, plus truncation in the zero sums.
This is verbatim the Languasco–Zaccagnini argument for the unsplit $G_1$;
each block's integrand differs only by replacing $-\zeta'/\zeta$ with
$\zeta g_Q$ or $-\zeta'/\zeta-\zeta g_Q$, both of the same polynomial
growth class with $g_Q$ bounded on vertical lines in $\Re s\ge0$. **Not
reproduced here — ledger G3.** $\square$

## 1.5 What this forces on `BLOCKS.md` Part I §1

1. **The correction to `ADELIC.md` §3 is confirmed and is now a theorem.**
   The single-zero layer needs a pole at $s=1$ in one factor; $A^\flat$ has
   none, so $[\flat\flat]$ *cannot* contain it. "Pole × zero" is literally
   $\operatorname{Res}_{s=1}\times\operatorname{Res}_{s=\rho}$.
2. **A refinement the table misses.** $[\flat\flat]$ *does* carry
   single-$\gamma$ lines, at $w=\rho+1-j$, scale $X^{3/2}$ — from
   $\Gamma(s)$'s pole at $s=0$ against $A^\flat$'s pole at $\rho$.
   Suppressed by $X^{-1/2}$ against its own pair layer and $X^{-1}$ against
   the mixed block. This *derives* what exp11 reported as "single-$\gamma$
   lines $\sim4000\times$ smaller"; the factor 4000 is not reproduced
   (ledger G5). **The BLOCKS table is correct only in $\Re w>3/2$.**
3. **"Spectrally dead, six orders down" is not an approximation.** By
   Lemma 1 the BC block is *exactly* dead; the measured $10^{-6}$ is
   finite-$X$ noise, not a small nonzero coefficient.
4. **exp11 is demoted to illustration**, as `METHOD.md` §3 item 3 asked.

## 1.6 Honesty ledger — Part 1

| # | gap | status |
|---|---|---|
| G1 | Lemmas 1–4, Props 5–6, **Theorem E2a** | **Proved, unconditional, no unverified imports.** |
| G2 | RH | Used **only** in E2b, to place $\Re(\rho+2)=5/2$ and $\Re(\rho+\rho'+1)=2$. |
| G3 | Contour-shift/growth estimates converting E2a's pole data into E2b's asymptotics with the stated errors | **Not reproduced.** Cited as Languasco–Zaccagnini applied blockwise; the transfer is *believed but not checked in detail*. The one genuine piece of unwritten work here. |
| G4 | Coincident poles | If $\rho+2=\rho'+\rho''+1$ or $\rho+\rho'=\sigma+\sigma'$, residues add. Does not affect E2a (a support statement); E2b's termwise reading assumes non-coincidence or is read as "sum of residues". At $w=\rho+1-j$ a $\Gamma$-pole can meet a trivial-zero pole giving $X^\sigma\log X$; excluded from the half-plane rather than analysed. |
| G5 | The measured $4000\times$ and corr 1.0000 | Not derived. §1.5(2) derives the *exponent* ($X^{3/2}$ vs $X^{5/2}$); the ratio depends on exp11's normalisation. |
| G6 | Multiplicities | Handled: $-\zeta'/\zeta$ has a simple pole at $\rho$ with residue $-m_\rho$ regardless of multiplicity, so $m_\rho$ is linear in the mixed layer, $m_\rho m_{\rho'}$ in the pair layer. |
| G7 | $Q$-uniformity | Everything is for **fixed $Q$**, and none is needed: E2 is a statement at each resolution. |

---

# Part 2 — the $O(1)$ in M1, and two errors in M1

## 2.1 The exact structure of $\Lambda^\sharp_Q(m)$

Write $n_Q=\gcd(n,P_Q)$ and $\Sigma_n(Y)=\sum_{m\le Y,(m,n)=1}\mu^2(m)/\varphi(m)$.

**Lemma U1 (exact divisor decomposition — no error term).**
$$\boxed{\ \Lambda^\sharp_Q(n)=\sum_{d\mid n_Q,\ d\le Q}\mu(d)\,\Sigma_{n_Q}(Q/d).\ }$$

*Proof.* Only squarefree $q$ contribute; Hölder gives
$c_q(n)=\mu(q/(q,n))\varphi(q)/\varphi(q/(q,n))$, so with $d=(q,n)$,
$q=dm$, $\mu(q)=\mu(d)\mu(m)$,
$$\frac{\mu(q)}{\varphi(q)}c_q(n)=\mu(q)\frac{\mu(m)}{\varphi(m)}=\mu(d)\frac{\mu^2(m)}{\varphi(m)}.$$
Constraints: $d\mid n$, $(m,n)=1$, $dm\le Q$; only primes $\le Q$ occur, so
$d\mid n_Q$ and $(m,n)=1\iff(m,n_Q)=1$. $\square$

**Corollary.** $\Lambda^\sharp_Q(n)$ depends on $n$ only through $n_Q$ —
periodic mod $P_Q$, sharper than mod $\operatorname{lcm}(q\le Q)$ — and
$\Lambda^\sharp_Q(1)=\Sigma_1(Q)=A(Q)$.

## 2.2 The pointwise limit — and the first correction to M1

**Lemma U2 (coprime Mertens; imported).** $\Sigma_n(Y)=\frac{\varphi(n)}{n}(\log Y+C_n)+E_n(Y)$
with $E_n(Y)\to0$ for fixed $n$, $C=\gamma+\sum_p\frac{\log p}{p(p-1)}$
(Montgomery–Vaughan 1973; Halberstam–Richert Lemma 3.5). The value of
$C_n$ is irrelevant below.

**Proposition U3.** For every fixed $n\ge2$,
$$\lim_{Q\to\infty}\Lambda^\sharp_Q(n)=\sum_{q=1}^\infty\frac{\mu(q)}{\varphi(q)}c_q(n)=\frac{\varphi(n)}{n}\Lambda(n).$$

*Proof.* Take $Q>n$, so $n_Q=\operatorname{rad}(n)$ and every $d\mid n_Q$
is $\le Q$. By U1 and U2,
$$\Lambda^\sharp_Q(n)=\frac{\varphi(n)}{n}\sum_{d\mid\operatorname{rad}(n)}\mu(d)\bigl(\log Q-\log d+C_{\operatorname{rad}(n)}\bigr)+\text{(errors)}.$$
Since $n\ge2$, $\sum_{d\mid\operatorname{rad}(n)}\mu(d)=0$: **the entire
$\log Q+C_n$ term cancels**, which is why $C_n$ never needs to be known.
There remains
$-\frac{\varphi(n)}{n}\sum_{d\mid\operatorname{rad}(n)}\mu(d)\log d
=\frac{\varphi(n)}{n}\Lambda(\operatorname{rad}(n))=\frac{\varphi(n)}{n}\Lambda(n)$,
by $\sum_{d\mid N}\mu(d)\log d=-\Lambda(N)$ for $N>1$ and
$\Lambda(\operatorname{rad}(n))=\Lambda(n)$ for $n\ge2$. Errors vanish
termwise. $\square$

(The coefficient $\varphi(n)/n$ is right: the Euler product
$\sum_m\frac{\mu^2(m)}{\varphi(m)}m^{-s}=\prod_p(1+\frac{p^{-s}}{p-1})$
divided by its $p\mid n$ factors contributes
$\prod_{p\mid n}(1+\frac1{p-1})^{-1}=\varphi(n)/n$ at $s=0$.)

*Exact-rational check (licensed: checking a derivation).*

| $n$ | $\Lambda^\sharp_{200}$ | $\Lambda^\sharp_{1000}$ | $\Lambda^\sharp_{4000}$ | $\Lambda(n)$ | $\frac{\varphi(n)}{n}\Lambda(n)$ |
|---|---|---|---|---|---|
| 2,4,8 | 0.34418 | 0.34097 | 0.34741 | 0.69315 | **0.34657** |
| 3,9 | 0.76405 | 0.73170 | 0.73330 | 1.09861 | **0.73241** |
| 6,12 | −0.01426 | 0.00138 | −0.00325 | 0 | **0** |
| 10 | −0.05242 | 0.00989 | −0.00823 | 0 | **0** |

> ### Correction 1 to Proposition M1
> `METHOD.md` §1 wrote $S(Q)\to\sum_{m\ge2}\Lambda(m)/(1+m)^2$. **The
> factor $\varphi(m)/m$ is missing.** Correctly,
> $$S_\infty=\sum_{m\ge2}\frac{\varphi(m)}{m}\frac{\Lambda(m)}{(1+m)^2}
> =\sum_p\Bigl(1-\tfrac1p\Bigr)\log p\sum_{a\ge1}\frac1{(1+p^a)^2}=\mathbf{0.257780}\ldots$$
> against M1's $0.361329$. So the boxed linear coefficient is wrong:
> $\tfrac C2+2S_\infty$ is $\mathbf{1.181852}$, not $1.388949$
> ($C=1.332582$). **The leading $\tfrac14$ is unaffected** — it comes from
> the single term $n=2$ where $A(Q)^2/4$ is exact.
>
> **M1's own numerics already contained the refutation.** Exact computation
> gives $S(Q)=0.2513,\,0.2560,\,0.2663,\,0.2587$ at $Q=10,30,60,120$ —
> converging to $0.2578$, not $0.3613$. The check used the finite-$Q$
> quantity $S(Q)$ and therefore passed; only the *identification of the
> limit* was wrong. An untracked obligation of exactly the kind
> `notes/OBLIGATION.md` §8 catalogues: a limit asserted, never derived.

## 2.3 The correct uniform bound: the Mertens obstruction

**Proposition U4 (exact identification of the extremal value).** For every $Q\ge2$,
$$\boxed{\ \Lambda^\sharp_Q(P_Q)=M(Q):=\sum_{d\le Q}\mu(d).\ }$$

*Proof.* $n=P_Q$ gives $n_Q=P_Q$; then $(m,P_Q)=1$ with $m\le Q$ forces
$m=1$, so $\Sigma_{P_Q}(Y)=1$ for all $1\le Y\le Q$. By U1,
$\Lambda^\sharp_Q(P_Q)=\sum_{d\mid P_Q,d\le Q}\mu(d)$; every squarefree
$d\le Q$ is $Q$-smooth hence divides $P_Q$, and $\mu(d)=0$ otherwise. $\square$

**Corollary U5.** $\sup_n|\Lambda^\sharp_Q(n)|\ge\max(A(Q),|M(Q)|)$, and
since $\limsup M(x)/\sqrt x>1$, $\liminf M(x)/\sqrt x<-1$
**unconditionally** (Odlyzko–te Riele 1985; Kotnik–te Riele 2006),
$\sup_n|\Lambda^\sharp_Q(n)|\gg Q^{1/2}$ for infinitely many $Q$. If all
zeros are simple and $\mathbb Q$-linearly independent then
$\limsup|M(x)|/\sqrt x=\infty$ (Ingham), and so is the corresponding sup.

> This is the precise content of the folklore "Ramanujan partial sums
> converge pointwise but not uniformly". **The obstruction is not diffuse:
> it is the Mertens function, attained exactly at $n\equiv0\bmod P_Q$.** The
> mechanism is visible in U1 — the cancellation
> $\sum_{d\mid n_Q}\mu(d)=0$ that produced the clean limit in U3 is
> *destroyed by the truncation $d\le Q$* as soon as $n_Q>Q$, and the
> surviving partial Möbius sum is $M(Q)$.

**Lemma U6 (crude upper bound).** $|\Lambda^\sharp_Q(n)|\le\min(d(n),Q)A(Q)\ll d(n)\log Q$,
from $\Sigma_{n_Q}(Y)\le A(Q)$ and $\#\{d\mid n_Q:d\le Q\}\le\min(d(n),Q)$.
The gap between U6 and U4 is wide; the true order is open (ledger H4).

## 2.4 The weight beats the non-uniformity

**Proposition U7.** $S(Q)=S_\infty+O(\log^2Q/Q)+\sum_{2\le m\le Q}(1+m)^{-2}\sum_{d\mid\operatorname{rad}(m)}\mu(d)E_{\operatorname{rad}(m)}(Q/d)$.

*Proof.* Split at $m=Q$. For $m>Q$, U6 gives
$\ll\log Q\sum_{m>Q}d(m)m^{-2}\ll\log^2Q/Q$, and the matching tail of
$S_\infty$ is $\ll\log Q/Q$. For $2\le m\le Q$ the U3 computation applies
verbatim. $\square$

**Corollary U8.** If $E_n(Y)\ll d(n)Y^{-1/2}$ uniformly — the standard
shape — then $S(Q)=S_\infty+O(Q^{-1/2})$, hence
$2A(Q)S(Q)=2S_\infty\log Q+2CS_\infty+o(1)$.

So the non-uniformity of §2.3 **does not obstruct M1's $A(Q)S(Q)$ term**:
the bad $n$ all satisfy $n\ge P_Q$, which $n^{-2}$ annihilates.

## 2.5 The $O(1)$: what is explicit, and what is not

**Lemma U9 (the bulk is the truncated singular series).**
$$\sum_{a+b=n}\Lambda^\sharp_Q(a)\Lambda^\sharp_Q(b)=(n-1)\mathfrak S_Q(n)+\mathcal O(n),\qquad
\mathfrak S_Q(n)=\sum_{q\le Q}\frac{\mu^2(q)}{\varphi(q)^2}c_q(n),$$
with $|\mathcal O(n)|\ll Q^2\log Q$ uniformly in $n$.

*Proof.* Diagonal ($\alpha=\beta$): $\sum_\alpha\hat f(\alpha)^2e(\alpha n)=\mathfrak S_Q(n)$
by Carmichael orthogonality — precisely the truncated Hardy–Littlewood
singular series. Off-diagonal: $|\sum_{a<n}e(a\theta)|\le\min(n,\frac1{2\|\theta\|})$;
for $\theta=h/q-h'/q'$ the values lie in $\frac1{[q,q']}\mathbb Z$, each hit
$\ll(q,q')$ times, so the inner double sum is $\ll qq'\log(2qq')$, and
$\sum_{q,q'\le Q}\frac{qq'\log Q}{\varphi(q)\varphi(q')}\ll Q^2\log Q$. $\square$

**Lemma U10 (the explicit constant carried by $\mathfrak S_Q$).**
$$\sum_{n\le X}\frac{\mathfrak S_Q(n)}{n}=\log X+\gamma-\sum_{p\le Q}\frac{\log p}{(p-1)^2}+o(1).$$

*Proof.* $q=1$ gives $\log X+\gamma+o(1)$. For $q\ge2$,
$\sum_{n\le X}\frac{c_q(n)}{n}=\sum_{d\mid q}d\mu(q/d)\frac1d(\log(X/d)+\gamma+o(1))
=-\sum_{d\mid q}\mu(q/d)\log d=-\Lambda(q)$, using $\sum_{d\mid q}\mu(q/d)=0$
and $\log=\Lambda*1$. So the $q\ge2$ part is
$-\sum_{p\le Q}\frac{\log p}{(p-1)^2}$. $\square$

With $B:=\sum_p\frac{\log p}{(p-1)^2}=\mathbf{1.226969}\ldots$ (so
$\gamma-B=-0.649753$; truncation at $Q$ costs $O(\log Q/Q)$):

> **Proposition M1′.**
> $$\kappa(Q)=\underbrace{\tfrac{A(Q)^2}{4}}_{\asymp\frac14\log^2Q}
> +\underbrace{2A(Q)S(Q)}_{\to2S_\infty\log Q+2CS_\infty}
> +\underbrace{\Bigl(\gamma-\sum_{p\le Q}\tfrac{\log p}{(p-1)^2}\Bigr)}_{\to-0.649753\ldots}
> +\ \mathcal E(Q),$$
> with $\mathcal E(Q)\ll\log^2Q$ unconditionally, hence
> $$\kappa(Q)=\tfrac14\log^2Q+1.181852\ldots\log Q+0.430870\ldots+\mathcal E(Q)+o(1).$$
> **Every constant is explicit except $\mathcal E(Q)$.**

*Proof of $\mathcal E(Q)\ll\log^2Q$.* $|\mathcal O(n)|\ll\min(nA(Q),Q^2\log Q)$
— the first from $|\sum_{a<n}f(a)f(n-a)|\le\sum_{a<n}f(a)^2$ with
$\overline{f^2}=A(Q)$ over a period, the second from U9. Split at
$n_0=Q^2\log Q/A(Q)$: $\sum_{n\le n_0}n^{-1}A(Q)\ll\log^2Q$ and
$\sum_{n>n_0}n^{-2}Q^2\log Q\ll\log Q$. $\square$

### The honest verdict

$\mathcal E(Q)\ll\log^2Q$ is **the same order as the leading term**. So:

> **M1's claim that the remaining block is $O(1)$ is not merely
> unevaluated — it is, at present, unproved.** The crude off-diagonal bound
> is too weak by two logarithms to reconfirm even the coefficient $\tfrac14$
> by this route. ($\tfrac14$ is nevertheless safe by the $n=2$ argument.)

> **Hypothesis U (incomplete bilinear Ramanujan bound).** For some
> $\delta>0$, uniformly in $n,Q$,
> $$\sum_{a+b=n}\Lambda^\sharp_Q(a)\Lambda^\sharp_Q(b)=n\,\mathfrak S_Q(n)+O\bigl(n^{1-\delta}Q^{O(1)}+\log^{O(1)}Q\bigr).$$

Hypothesis U $\Rightarrow\mathcal E(Q)=O(1)\Rightarrow$ the constant term is
$0.430870\ldots+\lim\mathcal E(Q)$.

> **Re-diagnosis: `METHOD.md` §1 named the wrong lemma.** The obstruction is
> *not* pointwise uniformity of $\Lambda^\sharp_Q(m)$ — that is **false**
> (U4), and irrelevant anyway because $n^{-2}$ kills the bad $n$ (U7). It is
> incomplete-interval cancellation in the **off-diagonal bilinear Fourier
> form**. Hypothesis U is not implied by any pointwise bound.

*Exact-rational consistency check.*

| $Q$ | $A(Q)$ | $\log Q+C$ | $S(Q)$ | $\frac{A^2}4+2AS$ | published $[\sharp\sharp]$ | residual |
|---|---|---|---|---|---|---|
| 10 | 3.6667 | 3.6352 | 0.2513 | 5.2043 | 1.711 | −3.493 |
| 30 | 4.7326 | 4.7338 | 0.2560 | 8.0224 | 5.141 | −2.881 |
| 120 | 6.1350 | 6.1201 | 0.2587 | 12.5833 | 9.517 | −3.066 |

The residual is flat at $\approx-3.1$, consistent with
$\gamma-B+\mathcal E(Q)$ with $\mathcal E(Q)\approx-2.4$ — i.e.
$\mathcal E(Q)=O(1)$ empirically, as Hypothesis U predicts.

> ### Correction 2 to Proposition M1
> M1 reports this residual as "flat at $\approx9.0$". Recomputing from M1's
> own printed formula against `BLOCKS.md` Part I §5.1's published
> $[\sharp\sharp]$ values gives $\approx-3.1$. The *flatness* — the
> substantive claim — is confirmed; the *value* is not. Either exp27
> normalises $T(X)$ differently from the formula M1 prints, or the number is
> wrong. Flagged, not resolved (ledger H5).

## 2.6 Honesty ledger — Part 2

| # | gap | status |
|---|---|---|
| H1 | U1, U3, U4, U5, U6, U9, U10, $\mathcal E(Q)\ll\log^2Q$ | **Proved, unconditional.** U4 is exact, not asymptotic. |
| H2 | Lemma U2 (coprime Mertens) | **Imported.** Main term re-derived by Euler products; the literature's error term **not** verified. U3 needs only $E_n(Y)\to0$ for fixed $n$ (safe). U8's rate needs the uniform shape $E_n(Y)\ll d(n)Y^{-1/2}$, **not verified** — without it $S(Q)\to S_\infty$ still holds but with unquantified rate, which suffices for the corrected linear coefficient but not for a rate. |
| H3 | **Hypothesis U** | **Unproved. The live gap** between M1 and an explicit constant term. |
| H4 | True order of $\sup_n|\Lambda^\sharp_Q(n)|$ | **Open.** $\ge\max(A(Q),|M(Q)|)\gg Q^{1/2}$ i.o. unconditionally; upper bound only U6's $d(n)\log Q$, useless at $n=P_Q$. Expected $Q^{1/2+o(1)}$ under RH; no proof. |
| H5 | M1's residual $9.0$ vs recomputed $-3.1$ | **Unresolved discrepancy.** exp27 not re-run (floating point, and `CLAUDE.md` forbids it as a substitute for algebra). Someone must reconcile exp27's normalisation of $T(X)$. |
| H6 | Attribution | M1 credits Hardy for $\Lambda(m)=\sum_q\frac{\mu(q)}{\varphi(q)}c_q(m)$; U3 shows the limit is $\frac{\varphi(m)}{m}\Lambda(m)$. **Primary source not located** (arXiv egress blocked). The identity is almost certainly classical — it is the Ramanujan expansion of $\frac{\varphi}{\mathrm{id}}\Lambda$, whose coefficients are $\mu(q)/\varphi(q)$ — and U4 may be known too. **Do not publish either as new without a literature check.** Open obligation, prior-art type. — **PRIOR-ART SWEEP 2026-08-14: split, search-summary (śabda) grade, `WebFetch` still EGRESS_BLOCKED so no PDF read. (a) The identity — RESOLVED-FOUND, and the credit to Hardy is exactly right:** G. H. Hardy, *Note on Ramanujan's trigonometrical function $c_q(n)$ and certain series of arithmetical functions*, Proc. Camb. Phil. Soc. **20** (1921) 263–271, proves both $\Lambda_1(n)=\sum_{q\ge1}\frac{\mu(q)}{\varphi(q)}c_q(n)$ **and** the Ramanujan–Fourier expansion of $\frac{\varphi(n)}{n}\Lambda(n)$ — i.e. U3's limit is Hardy's own statement, not a corpus observation; secondary confirmations: M. R. Murty, *Ramanujan series for arithmetical functions*, Hardy–Ramanujan J. **36** (2013) 21–33, and arXiv:1705.07193 (finite Ramanujan expansions of $\Lambda$). **U3 is known mathematics.** **(b) U4 ($\Lambda^\sharp_Q(P_Q)=M(Q)$) — RESOLVED-NO-MATCH.** Queries: *truncated Ramanujan expansion von Mangoldt Mertens function M(Q) extremal value primorial*; *sum_{d≤Q} mu(d) d/phi(d) partial Ramanujan sum equals Mertens function truncation Q-smooth*; *truncated singular series partial sum Möbius Mertens artifact*. Nearest located home, not a match but the right neighbourhood for the next block to extend into: the *smooth-summation* literature on Ramanujan expansions (arXiv:2012.11231, arXiv:2407.19759), which truncates over $P$-smooth $q$ — structurally the same collapse U4 exploits at $n=P_Q$. Absence of a located source is not evidence of novelty. Attribution status only; no claim altered. |
| H7 | Numerical constants | $S_\infty,B,C$ summed over $p<4\times10^6$; tails $O(1/P)\approx2.5\times10^{-7}$, so **six decimals** reliable, no more. $S(Q)$ truncated at $m<4000$ (tail $\ll2\times10^{-3}$). $A(Q)$, $\Lambda^\sharp_Q(n)$ exact rational. |
| H8 | Interaction with Part 1 | None. Lemma 1's residue-1 computation (mean of $\Lambda^\sharp_Q$ over a period is exactly 1, every $Q$) is consistent with U3: the discrepancy $\Lambda(n)-\frac{\varphi(n)}{n}\Lambda(n)=\Lambda(n)/p$ has mean 0. |

---

## Summary of what changed in the record

1. **Theorem E2 is proved** — E2a unconditional, E2b under RH — with the
   mechanism exactly as conjectured: $A^\sharp=\zeta g_Q$ with $g_Q$ entire
   and $g_Q(1)=1$, so the sharp block owns the pole at $s=1$ with residue
   exactly 1 and owns **no** zeta zeros (they are zeros, not poles), while
   $A^\flat$ owns every $\rho$ and, by the same $g_Q(1)=1$, **no** pole at
   $s=1$. Theorem D's three layers fall out of one Mellin–Barnes contour as
   pole×pole, pole×zero, zero×zero, with residues $\tfrac16$,
   $-2/(\rho(\rho+1)(\rho+2))$, $\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$
   reproduced exactly, signs and factor 2 included.
2. **A refinement:** $[\flat\flat]$ does carry single-$\gamma$ lines at
   scale $X^{3/2}$; the BLOCKS table holds only in $\Re w>3/2$.
3. **Two errors in M1:** the Ramanujan limit is $\frac{\varphi(m)}{m}\Lambda(m)$,
   so the linear coefficient is $1.181852$ not $1.388949$; and the reported
   residual $9.0$ recomputes to $-3.1$.
4. **The $O(1)$ is half-explicit:** $\gamma-B=-0.649753$ plus
   $\mathcal E(Q)\ll\log^2Q$, conjecturally $O(1)$. The missing lemma is
   **not** pointwise uniformity — that is false, exactly, by
   $\Lambda^\sharp_Q(P_Q)=M(Q)$ — but an incomplete-interval bilinear bound.
