# The near-diagonal energy constant is $\langle\rho\rangle_{|W|^2}$ — exact ratio, exact tail law, and why $2.8$ was $c(s_{\max}{=}300)$

Rank-2 item of `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` §1, discharged
(partially — see §9). The claim under audit is `ENERGY.md:124`, echoed at
`:140`, `:207`, `:223` and in `papers/pairfield_monograph.md:224,382,433`:

> $$\frac{E_W^\circ(\delta)}{2\sum|W|^2}\;\approx\;2.8\,\delta,\qquad
> \text{“the sampled value } c\approx2.8 \text{ is evidence only.”}$$

The triage proposed that $c$ is a closed-form ratio of two absolutely
convergent zero sums. **It is — and the derivation changes the number.**
Three findings, in increasing order of consequence:

1. $c$ is the $|W|^2$-weighted **mean pair-sum density** $\langle\rho\rangle$.
   It is therefore *dimensional* (units: reciprocal ordinate), the exact
   condition `SWEEP.md` §2 uses to disqualify $C/D=1.44$ as a universal
   constant. It is finite here only because $w^2\rho$ is integrable.
2. Its truncation error is **relative $O(s_{\max}^{-2}\log^4 s_{\max})$, not
   $o(1)$**: at $s_{\max}=300$ the truncated value is $41\%$ below the limit.
   $2.8$ is $c(300)$, not $c$. Corrected: $c=4.2$–$4.4$, and in the
   normalisation actually printed in the displayed formula the same data give
   $2.54$, not $2.8$. This is `HOLOGRAM.md` §7 exactly: a constant measured at
   one cutoff, hiding its cutoff scaling.
3. The constant that `ENERGY.md` §5 / `APPENDIX_D` D.6(1) / monograph P4
   actually need — a bound $E_W^\circ(\delta)\le c\,\delta\sum|W|^2$ valid for
   **all** small $\delta$ — is a *different functional of the spectrum*, is not
   equal to $c$, and does not exist as a finite number without a separation
   hypothesis (§7). No Poisson computation at any cutoff can supply it.

Nothing here was computed. The only numerics quoted are `ENERGY.md`'s own
published tables, used to test the derivation (licensed).

## 1. Objects, and the exact weight

$\rho=\tfrac12+i\gamma$ over the nontrivial zeros; positive ordinates
$\gamma_1=14.134725\ldots<\gamma_2<\cdots$;
$W(a,b)=\Gamma(\rho_a)\Gamma(\rho_b)/\Gamma(\rho_a+\rho_b+2)$, $s=a+b$;
$D:=\sum_{i,j\ge1}|W(\gamma_i,\gamma_j)|^2$ (**ordered** pairs, $i=j$
included);
$E_W^\circ(\delta):=\sum^{\circ}_{|\gamma_i+\gamma_j-\gamma_k-\gamma_l|\le\delta}|W_{ij}||W_{kl}|$
over ordered quadruples with the diagonal $\{k,l\}=\{i,j\}$ removed.

**Lemma W (exact weight).** For same-sign pairs,
$$|W(a,b)|^2=w(s)^2\cdot\frac{2\sinh\pi s}{\cosh\pi s+\cosh\pi(a-b)}\cdot\frac12\cdot 2
= w(s)^2\bigl(1+O(e^{-2\pi\gamma_1})\bigr),\qquad
\boxed{\,w(s)^2:=\frac{2\pi}{s\,(1+s^2)(4+s^2)}\,}$$
$$=2\pi s^{-5}\bigl(1-5s^{-2}+O(s^{-4})\bigr).$$

*Proof.* `DPP.md` Lemma 1 (exact, elementary):
$|W|^2=\pi\sinh(\pi s)\big/\bigl[s\cosh(\pi a)\cosh(\pi b)(4+s^2)(1+s^2)\bigr]$.
Use $2\cosh\pi a\cosh\pi b=\cosh\pi s+\cosh\pi(a-b)$. Since $a,b\ge\gamma_1$
we have $|a-b|\le s-2\gamma_1$, so
$\cosh\pi(a-b)/\cosh\pi s\le e^{-2\pi\gamma_1}(1+e^{-2\pi(s-2\gamma_1)})$, and
$\tanh\pi s=1+O(e^{-2\pi s})$; with $e^{-2\pi\gamma_1}=e^{-88.8}<3\cdot10^{-39}$
the stated form follows. $\square$

The $O(s^{-2})$ term is the object `DPP.md` §1 identifies with exp12's
"max deviation $0.31\%$"; it is $<10^{-4}$ everywhere the tail integrals of §5
are used, and is retained exactly where it is not.

## 2. Absolute convergence of both sums (proved, not assumed)

**Proposition 1 ($D$).** $D<\infty$; more precisely
$\sum_{s\ge S}|W|^2\ll S^{-3}\log^2S$.

*Proof.* $\theta\le0$ in `DPP.md` Thm 1 gives $|W|^2\le2\pi s^{-5}$ for every
pair. Riemann–von Mangoldt: $N(T)\ll T\log T$. Dyadically, the ordered pairs
with $s\in[2^k\gamma_1,2^{k+1}\gamma_1)$ number $\le N(2^{k+1}\gamma_1)^2\ll
4^k k^2$, each of weight $\ll(2^k\gamma_1)^{-5}$, so the block contributes
$\ll 2^{-k}\!\cdot\!2^{-2k}k^2$; summing the geometric-times-polynomial series
gives both claims. Unconditional given RH (which is what puts the ordinates on
the line at all). $\square$

**Proposition 2 ($E_W$).** For every fixed $\delta>0$, $E_W(\delta)<\infty$,
and the contribution of pairs with $\min(s,s')\ge S$ is $\ll\delta S^{-2}\log^4S$.

*Proof.* $|W|\le\sqrt{2\pi}\,s^{-5/2}$ (`DPP.md` Thm 1, one-sided,
unconditional). If $|s-s'|\le\delta\le1$ and $s\asymp S\ge2$ then $s'\asymp S$.
By `DPP.md` Proposition 9 (**proved** there: Fejér majorant plus the explicit
formula), the number of quadruples of ordinates $\le S$ with
$|\delta_{ijkl}|\le\delta$ is $\ll\delta S^3\log^4S$, valid once
$\delta\ge4/\log S$, i.e. for $S\ge S_1(\delta):=e^{4/\delta}$. A dyadic block
at height $S$ therefore contributes
$\ll (S^{-5/2})^2\cdot\delta S^3\log^4S=\delta S^{-2}\log^4S$, summable. Below
$S_1(\delta)$ there are finitely many zeros and the sum is finite term by
term. $\square$

Note the shape agreement: the *proved* tail bound $\delta S^{-2}\log^4S$ of
Prop. 2 is exactly the size of the derived tail integral of §5 — the two
independent routes to the numerator's tail agree, which is the first sign that
the $41\%$ of §5 is structural and not an artefact of the density model.

## 3. The pair-sum intensity in closed form

Let $\rho(s)$ be the mean intensity of **ordered** pair sums $\gamma_i+\gamma_j$.

**Lemma $\rho$.** With $L=\log\frac{s}{2\pi}$ and $\zeta(2)=\pi^2/6$,
$$\boxed{\;\rho(s)=\frac{s}{4\pi^{2}}\Bigl[(L-1)^{2}+1-\zeta(2)\Bigr]
\;+\;\frac{\gamma_1\bigl(1-\log\frac{\gamma_1}{2\pi}\bigr)}{2\pi^{2}}\,L\;+\;O(\log s).}$$

*Proof.* The mean zero density is $d(t)=\frac1{2\pi}\log\frac t{2\pi}$
(Riemann–von Mangoldt, differentiated); the ordered pair-sum intensity is the
self-convolution $\int d(a)d(s-a)\,da$ (the corpus's exp13 route,
`BLOCKS.md:347`). With $a=sx$,
$$\int_0^s d(a)d(s-a)da=\frac{s}{4\pi^2}\Bigl[L^2+2L\!\int_0^1\!\log x\,dx+\int_0^1\!\log x\log(1-x)dx\Bigr],$$
$\int_0^1\log x\,dx=-1$ and, expanding $\log(1-x)=-\sum_{n\ge1}x^n/n$ and using
$\int_0^1x^n\log x\,dx=-(n+1)^{-2}$,
$$\int_0^1\log x\log(1-x)\,dx=\sum_{n\ge1}\frac1{n(n+1)^2}
=\sum_{n\ge1}\Bigl(\frac1n-\frac1{n+1}-\frac1{(n+1)^2}\Bigr)=2-\zeta(2).$$
That gives $L^2-2L+2-\zeta(2)=(L-1)^2+1-\zeta(2)$. The unrestricted
convolution integrates over $a<\gamma_1$, where no zeros exist and
$\log\frac a{2\pi}$ is negative; restoring the true support adds
$-\frac{2}{4\pi^2}\int_0^{\gamma_1}\log\frac a{2\pi}\log\frac{s-a}{2\pi}da
=\frac{L}{2\pi^2}\gamma_1(1-\log\frac{\gamma_1}{2\pi})+O(1)$, the second term
($=0.1356\,L$). $\square$

Two corrections *not* needed, with their sizes:

- **Zero pair correlation** (Montgomery/GUE) enters $\rho$ only through the
  self-avoidance of $\gamma_i,\gamma_j$ at *bounded difference*, whereas the
  sum constraint integrates over all differences: writing $a=(s+v)/2$ and
  using $\int(\frac{\sin\pi w}{\pi w})^2dw=1$ in local mean-spacing units, the
  correction is $-\tfrac12 d(s/2)=O(\log s)$, i.e. $-0.25$ against
  $\rho(300)=57.6$: **0.4%**. So pair correlation — the input one might expect
  to be decisive — is not used, and could not change the answer.
- The $\tfrac78$ of $N(T)$ and the equal-ordinate atoms $s=2\gamma_i$ are also
  $O(\log s)$, absorbed above.

**Validation (checking a derivation, licensed).** $\int_{2\gamma_1}^{300}\rho
\approx5.95\cdot10^3$ against `ENERGY.md`'s published count of $6164$ ordered
pairs with $s\le300$: **$-3.5\%$**, the expected sign and size for a mean
density evaluated down to the bottom of the spectrum. This pins the
normalisation $1/4\pi^2$ (ordered) of `SWEEP.md` §1.1 independently.

## 4. What the constant is

Let (P) be the near-diagonal density hypothesis: *for $\delta$ small compared
with the scale on which $\rho$ varies and large compared with the local
pair-sum spacing, the two-point function of the pair-sum process at separation
$\le\delta$ equals $\rho(s)\rho(s')$* — no additive structure among pair sums
beyond their density. This is `ENERGY.md`'s own Poisson reference, promoted to
a hypothesis. It is in the LI/SSH family, **not implied by RH**, and it is the
only conditional input to the value below.

**Theorem E.** Assume RH and (P). Then, in the smoothed-in-$\delta$ sense of
(P),
$$E_W^\circ(\delta)=2\delta N+o(\delta),\qquad N=\int_{2\gamma_1}^{\infty}w(s)^2\rho(s)^2\,ds,$$
and hence
$$\boxed{\;c\;=\;\frac{E_W^\circ(\delta)}{2\delta\sum_{i,j}|W_{ij}|^2}
\;=\;\frac{N}{D}\;=\;\frac{\displaystyle\int_{2\gamma_1}^\infty w^2\rho^2\,ds}
{\displaystyle\int_{2\gamma_1}^\infty w^2\,d\mu_{\rm pair}}\;=\;\bigl\langle\rho\bigr\rangle_{|W|^2},\;}$$
the $|W|^2$-weighted mean of the pair-sum density. Both integrals converge
absolutely (Props. 1–2).

*Proof.* Ordered pairs $(i,j)$, $(j,i)$ carry the same sum, so the pair-sum
point process is the unordered one with multiplicity $m_p\in\{1,2\}$ and
intensity $\rho/2$; the excluded diagonal is $\sum_pm_p^2|W_p|^2=2D-\sum_i|W_{ii}|^2$.
Then $E^\circ_W(\delta)=\sum_{p\ne q,|s_p-s_q|\le\delta}m_pm_q|W_p||W_q|
\to\iint_{|s-s'|\le\delta}(2w)(2w')\tfrac{\rho}{2}\tfrac{\rho'}{2}=2\delta\int w^2\rho^2$
under (P), the window having length $2\delta$. $\square$

**Corollary (why it can never be a universal constant).** $c=\langle\rho\rangle$
has the units of a density. It is the same disqualification `SWEEP.md` §2
applies to $C/D=1.44$ ("a dimensional ratio cannot be a universal constant"),
with one difference: there $\langle\rho_2\rangle$ diverges like $T\log^2T$,
here $w^2\rho\sim\frac1{2\pi}s^{-4}\log^2 s$ is integrable, so the average
exists — but it is an average dominated by the *bottom* of the spectrum, while
its numerator is dominated by the *top*. That mismatch is §5.

## 5. The exact tail laws and the cutoff scaling — the finding

Write $u=\log\frac{S}{2\pi}$, $c_\star=2-\zeta(2)=0.3550659\ldots$. Substituting
$s=2\pi e^u$ into Lemma W and Lemma $\rho$ and integrating
$\int_{u_0}^\infty e^{-ku}\,\mathrm{poly}(u)\,du$ term by term:

$$\boxed{\;\int_S^\infty w^2\rho\,ds=\frac{Q(u)}{2\pi S^{3}},\quad
Q(u)=\frac{u^{2}}{3}-\frac{4u}{9}-\frac{4}{27}+\frac{2-\zeta(2)}{3};}$$
$$\boxed{\;\int_S^\infty w^2\rho^{2}ds=\frac{R(u)}{8\pi^{3}S^{2}},\quad
R(u)=\frac{u^{4}}{2}-u^{3}+\Bigl(\tfrac52-\zeta(2)\Bigr)u^{2}
+\Bigl(\zeta(2)-\tfrac32\Bigr)u+\frac{(2-\zeta(2))(1-\zeta(2))}{2}+\frac14.}$$

Both are exact for the model density of Lemma $\rho$ (leading term); the floor
term of Lemma $\rho$ adds $<1\%$ to $Q$ and $<2\%$ to $R$ at $S\ge150$, and the
$-5s^{-2}$ of Lemma W adds $<10^{-4}$.

**Cutoff law.** With $D_\infty,N_\infty$ the limits and $c(S)=N(S)/D(S)$ the
value computed from pairs with $s\le S$,
$$\boxed{\;\frac{c(S)}{c_\infty}=1-\frac{R\bigl(\log\frac S{2\pi}\bigr)}{8\pi^{3}S^{2}N_\infty}
+O\!\Bigl(\frac{\log^{2}S}{S^{3}D_\infty}\Bigr)
=1-\Theta\!\Bigl(\frac{\log^{4}S}{S^{2}}\Bigr).}$$
The denominator's tail is one power of $S$ smaller than the numerator's: the
diagonal converges at $S^{-3}\log^2S$, the near-diagonal energy only at
$S^{-2}\log^4S$. **A cutoff at which the diagonal has converged to $1\%$ leaves
the energy $41\%$ short.**

Numerically, at $S=300$ ($u=3.865906$): $Q=3.2338$, $R=67.378$, so
$$\int_{300}^\infty w^2\rho\,ds=1.906\cdot10^{-8},\qquad
\int_{300}^\infty w^2\rho^2ds=3.018\cdot10^{-6};$$
at $S=150$ ($u=3.172700$): $Q=1.9155$, $R=27.931$, giving $9.033\cdot10^{-8}$
and $5.005\cdot10^{-6}$.

**Three independent validations against `ENERGY.md`'s published table**
(checking a derivation; no fitting):

| quantity | derived | published (`ENERGY.md` §3) | agreement |
|---|---|---|---|
| $\sum|W|^2$ increment $250\!\to\!300$ | $1.003\cdot10^{-8}$ | $1.02\cdot10^{-8}$ | $-1.7\%$ |
| $\sum|W|^2$ increment $150\!\to\!300$ | $7.13\cdot10^{-8}$ | $7.34\cdot10^{-8}$ | $-2.9\%$ |
| $c(300)/c(150)$ | ~~$1.82$~~ **$1.75$** | $1.90$ | ~~$-4\%$~~ **$-8\%$** |

> **Row 3 corrected in place (seed147, 2026-08-14; audit of summary apparatus
> against the note's own body).** The struck $1.82$ is the *leading term* of the
> boxed cutoff law, i.e. $\bigl(1-\tfrac{3.018}{7.41}\bigr)/\bigl(1-\tfrac{5.005}{7.41}\bigr)=1.83$,
> which discards precisely the $O(\log^2S/S^3D_\infty)$ term the box itself
> carries — and that term is **not** negligible here, since $D(150)$ sits $5.2\%$
> below $D_\infty$. Computed from this note's own numbers, exactly as the row's
> own definition $c(S)=N(S)/D(S)$ requires:
> $D(150)=1.746-0.0903=1.6555$, $N(150)=7.407-5.005=2.402$ (both $\cdot10^{-6}$),
> so $c(150)=1.4509$ against $c(300)=4.389/1.7268=2.5417$, giving
> $c(300)/c(150)=\mathbf{1.752}$ and agreement $-8.0\%$ against the published
> $0.2105/0.1113=1.891$. **The body is right and the row was wrong**, and §6
> proves it: the "$+9\%$ calibrated on $[150,300]$" that produces $c=4.40$ is
> recoverable *only* from the exact ratio — forcing $c(300)/c(150)=1.904$
> requires inflating the $S=300$ numerator tail from $3.018$ to $3.308\cdot10^{-6}$,
> which is $+9.6\%$ and gives $N_\infty/D_\infty=7.697/1.746=4.41$. Had the row's
> $1.82$ been right, that calibration would have been $+4\%$ and the upper end
> of §6 would not be $4.40$. **Nothing else moves:** rows 1–2 are pure $D$-tail
> checks and I reproduced both to three figures by hand ($1.0030\cdot10^{-8}$,
> $7.127\cdot10^{-8}$); $c=4.2$–$4.4$, the $41\%$ shortfall and the boxed laws
> $Q,R$ (re-derived at $u=3.86591$ and $u=3.17270$: $Q=3.2338$, $R=67.379$;
> $Q=1.9155$, $R=27.930$) are untouched. What is withdrawn is only the
> gloss below, for this row.

The tail law is therefore accurate ~~to a few percent~~ in the only region where
it is testable — to $1.7$–$2.9\%$ on
the two $D$-tail rows and $8\%$ on the $c$-ratio row — and **low** in every
row, consistent with the neglected floor term of Lemma $\rho$, whose sign is
positive.

**Where `ENERGY.md`'s own extrapolation went wrong.** `:57–61` models the
off-diagonal integrand as $s^{-3}\log^4s$. The exact density gives
$s^{-3}\Lambda(s)^2$ with $\Lambda=(\log\frac s{2\pi}-1)^2+1-\zeta(2)$: at
$s=300$ these differ by a factor $18$ in magnitude *and*, more importantly, by
a factor $2.7$ in local logarithmic growth rate, because subtracting
$\log2\pi+1=2.838$ from $\log s\approx5.7$ before taking the fourth power more
than doubles the relative growth at accessible heights. The $\log^4s$ model
therefore under-extrapolates: it gives a tail $1.44\cdot10^{-6}$ where the
exact density gives $3.02\cdot10^{-6}$. That is the whole of the disagreement
between the note's extrapolated $\approx0.30$ and the value below.

## 6. The number, and the verdict on $\approx2.8$

Take $D(300)=1.7268\cdot10^{-6}$ and $E^\circ_W(\delta_*)=6.354\cdot10^{-7}$ at
$\delta_*=1/\log10^6=0.072382$ from `ENERGY.md` §3 (double-precision finite
sums; the one non-derived input, see ledger EC7), so
$N(300)=E^\circ_W(\delta_*)/2\delta_*=4.389\cdot10^{-6}$. Then

$$D_\infty=1.7268+0.0191=1.746\cdot10^{-6},\qquad
N_\infty=4.389+3.018=7.41\cdot10^{-6},$$
$$\boxed{\;c=\frac{N_\infty}{D_\infty}=4.24\;}\qquad(\text{tail law as derived}),
\qquad 4.40\ \ (\text{tail law calibrated on }[150,300],\ +9\%).$$

So $c=4.2$–$4.4$; the honest interval, dominated by the $\pm10\%$ on the
finite $N(300)$ and the tail-law calibration, is $c\in[4.0,4.7]$.

**Was the measurement consistent?** The *data* were; the *constant* was not.

- **Normalisation.** The displayed formula divides by $2\sum|W|^2=2D=3.4536\cdot10^{-6}$,
  but the printed ratios divide by the diagonal $2D-\sum_i|W_{ii}|^2=3.0180\cdot10^{-6}$
  — the two differ by $12.6\%$ because the equal-ordinate pairs carry
  $\sum_i|W_{ii}|^2/D=25.2\%$ of the diagonal (and $(\gamma_1,\gamma_1)$ alone
  carries $20.0\%$: $|W_{11}|^2=3.458\cdot10^{-7}$, exactly Lemma W at
  $s=2\gamma_1$). Read in the normalisation it is printed under, the same
  cutoff-300 data give $2.54$, not $2.8$. A third normalisation is in play at
  `ENERGY.md:205,223` and monograph P4, where the target is
  $E^\circ_W\le c\,\delta\sum|W|^2$ — for that one the constant is $2c=8.5$.
- **Cutoff.** $2.8$ is $c(300)$. By the boxed cutoff law it is low by the
  factor $N_\infty/N(300)=1.688$ (against $D_\infty/D(300)=1.011$), i.e. by
  $1.67$.
- **Tolerance.** `ENERGY.md` declares no tolerance on $c$ — it is labelled
  "evidence only", and §3's own extrapolated row already implies $3.6$ in the
  written normalisation, i.e. the note contains two mutually inconsistent
  values of its own constant ($2.8$ and $3.6$) and quotes the smaller one three
  times downstream (`:207`, `:223`, monograph `:224`, `:382`). **The
  measurement was consistent with the derivation to $2$–$4\%$ everywhere it
  was a measurement; the number $2.8$ was not a measurement of $c$ but of
  $c(300)$ in the wrong normalisation, and it is low by $1.7\times$.**

## 7. The $\delta$-floor, and why P4's constant is a different object

Two further exact consequences, both fatal to reading $c$ as the constant of
the wanted bound.

**(a) A resolution floor.** (P) requires $\delta\gtrsim1/\rho(s)$ where the
mass of $N$ sits. The median of $\int w^2\rho^2$ is at $S\approx230$
(solve $R(u)/S^2=\tfrac12\cdot 8\pi^3N_\infty$), where $\rho=35.5$, so
$$\delta_0\approx1/\rho(230)\approx0.03 .$$
This is *derived*, and it explains the note's own anomaly: the slope read at
$\delta=0.01$ is $2.04$ against $2.91$ at $\delta_*$ and $2.87$ at $\delta=0.1$
(`:120–124`), and $\delta=0.01<\delta_0$ is below the spacing of the atoms
carrying the mass. The "cleanly linear for $\delta\le0.12$" claim holds only on
$[\delta_0,0.12]$ — one third of a decade, not two.

**(b) The uniform constant is not $c$.** D.6(1)/P4 need
$E^\circ_W(\delta)\le c\,\delta\sum|W|^2$ for *all* small $\delta$. But
$E^\circ_W$ is a pure jump function of $\delta$ with $E^\circ_W(0^+)=0$ under
SSH (`DPP.md` Thm 7), so $E^\circ_W(\delta)/\delta$ does not converge as
$\delta\to0$; it spikes at each pair-sum gap. The relevant quantity is
$$c^{\rm unif}=\sup_{p\ne q}\frac{m_pm_q|W_p||W_q|}{D\,|s_p-s_q|},$$
which is finite **iff** the pair-sum spectrum is simple, and whose block-wise
size at height $S$ scales, on Poisson gaps ($|s_p-s_q|_{\min}\asymp S/M^2$,
$M\asymp S^2\log^2S$), as $\asymp\log^4S/(S^2D)$ — decreasing, so
$c^{\rm unif}$ is carried by the lowest few hundred ordinates. This is
`DPP.md` Theorem 10's no-go seen from the constant's side: $c^{\rm unif}$ is a
finite low-spectrum computation conditional on SSH, it is *not* the Poisson
average $c$, and no sampling of $\delta\in\{0.01,\dots,1\}$ can bound it. **The
statement "any proven bound $E^\circ_W(\delta)\le c\delta\sum|W|^2$ (measured
$c\approx2.8$) … makes $V\sim2\sum|W|^2$ a theorem" (monograph `:224`, `:382`)
attaches a measured Poisson average to a supremum it does not bound.**

## 8. Downstream corrections forced

1. `ENERGY.md:124` — the displayed law is $E^\circ_W(\delta)/2\sum|W|^2=c\delta$
   with $c=4.2$–$4.4$ (not $2.8$), valid for $\delta\in[\delta_0,0.12]$,
   $\delta_0\approx0.03$; the printed ratios are diagonal-normalised.
2. `ENERGY.md:118` — the extrapolated row ($\approx0.30$ at $\delta_*$) is
   low: the exact density gives off/diag $\approx0.44$, tail
   $\int_{300}^\infty w^2\rho^2=3.02\cdot10^{-6}$ not $1.44\cdot10^{-6}$. The
   $\log^4s$ extrapolation model at `:57–61` should read
   $\bigl((\log\frac s{2\pi}-1)^2+1-\zeta(2)\bigr)^2$.
3. `ENERGY.md:139–142,207,223` and `papers/pairfield_monograph.md:224,382,433`
   — every occurrence of "$c\approx2.8$" carries the cutoff and normalisation
   caveats; P4's target constant is $2c\approx8.5$ *and* is the wrong object
   (§7b).
4. `BLOCKS.md:355` — "tail of $D$ beyond $s=300$ is $\le2.3\%$": the exact
   value is $1.09\%$ ($Q(u)/2\pi S^3$ above), and `ENERGY.md:59`'s "$<2\%$"
   likewise. Harmless (both are upper bounds), now exact.
5. `SWEEP.md` §3 queue item 3 ($C/D$ as $\langle\rho_2\rangle$) — the same
   dimensional diagnosis applies to $c$ and is discharged here for $c$
   (§4 Corollary); the $C/D$ item itself is untouched.

## 9. Prior art

Searched **in-corpus** before writing (`notes/`, `papers/`): the
self-convolution route to the pair-sum density is exp13's
(`BLOCKS.md:347–349`, "matches the measured atom counts to $\sim10\%$ using
only the main term of $N(T)$" — the closed form below improves that to
$3.5\%$); the leading $s\log^2s/8\pi^2$ (unordered) is `SWEEP.md` §1.1; the
exact weight is `DPP.md`. **No closed form for $\rho$, no tail law, and no
value of $c$ beyond the sample exists in the corpus.**

External: **not searched — egress may be blocked; the following are from
memory and flagged.** (i) $\int_0^1\log x\log(1-x)dx=2-\zeta(2)$ is classical
(re-proved above in two lines, so nothing rests on the memory). (ii) The
self-convolved zero density and its $(\log\frac s{2\pi}-1)^2$ shape is the kind
of object that appears in the Bogomolny–Keating and Fujii literature on sums
of zeros; a home there would not be surprising. **No novelty is claimed for
Lemma $\rho$ until searched.** The application — retiring $c\approx2.8$ and
closing triage rank 2 — is new in-corpus regardless.

## 10. Honesty ledger

| # | item | status |
|---|---|---|
| EC1 | Lemma W (exact $w^2$, error $O(e^{-2\pi\gamma_1})$) | **Proved, unconditional given RH**, from `DPP.md` Lemma 1 (exact, elementary). The $\cosh$ ratio is bounded here, not assumed. |
| EC2 | Prop. 1: $D<\infty$, tail $\ll S^{-3}\log^2S$ | **Proved** from RvM alone (plus RH for the ordinates to be real). |
| EC3 | Prop. 2: $E_W(\delta)<\infty$, tail $\ll\delta S^{-2}\log^4S$ | **Proved under RH**, using `DPP.md` Prop. 9 as quoted there (proved: Fejér + explicit formula), dyadically, with the finite part below $e^{4/\delta}$ handled separately. Convergence is *not* assumed anywhere. |
| EC4 | Lemma $\rho$ closed form, incl. the $\gamma_1$-floor term | **Proved** as a statement about the mean intensity (RvM main term self-convolved). That the *mean* intensity is the right object at the bottom of the spectrum is false pointwise — there $\rho$ is replaced by atoms — and this is used only for $s\ge150$ in §5. Pair correlation quantified at $0.4\%$ and discarded. |
| EC5 | Theorem E: $c=N/D=\langle\rho\rangle_{|W|^2}$ | **Conditional on (P)** (near-diagonal density hypothesis, LI/SSH family, *not* implied by RH). (P) is `ENERGY.md`'s own Poisson reference promoted to a hypothesis; the note's unweighted data support it at $1.000\pm0.009$, the weighted at $0.91$. The *form* of the answer is exact; only (P) is at risk. |
| EC6 | §5 tail laws $Q,R$ and the cutoff law $1-\Theta(S^{-2}\log^4S)$ | **Proved, exact closed forms** (elementary $\int e^{-ku}\mathrm{poly}$), for the Lemma-$\rho$ density; neglected corrections bounded ($<2\%$, sign positive). Validated against three published rows at $1.7$–$4\%$. **This is the load-bearing new content: it is the $X$-dependence the sampled $2.8$ was hiding.** |
| EC7 | The numerical value $c=4.2$–$4.4$ | **Exact formula, one finite non-certified input.** $D(300)$ and $E^\circ_W(\delta_*)$ are `ENERGY.md`'s double-precision sums, not V2.5 certificates; a certified interval-arithmetic evaluation over $s\le300$ would make $c$ exact to the stated tail law. Quoted interval $[4.0,4.7]$; **no constant was fitted**. The ratio $c(S)/c_\infty$, by contrast, is fully derived. — **[seed147, 2026-08-14: EC7 stands, and its ground is now checkable. The "$+9\%$ calibrated on $[150,300]$" of §6 is a one-parameter calibration of the numerator tail (from $3.018$ to $3.31\cdot10^{-6}$), which is not a fit of $c$ but is a fit of something; I verified it is consistent with the *exact* $c(300)/c(150)=1.75$ and not with the $1.82$ §5's table printed, and corrected that row rather than this one. "No constant was fitted" is true of $c$ and of $Q,R$; it is not true of the $4.40$ endpoint, which is calibrated. Interval unchanged.]** |
| EC8 | §7(a) resolution floor $\delta_0\approx0.03$ | **Derived** from Lemma $\rho$ (median of the numerator's mass at $S\approx230$). Explains the published $\delta=0.01$ slope of $2.04$; retires "cleanly linear for $\delta\le0.12$" in favour of $[\delta_0,0.12]$. |
| EC9 | §7(b): $c^{\rm unif}\ne c$, finite iff SSH | **Proved** (jump structure of $E^\circ_W$ + `DPP.md` Thm 7); the $\log^4S/(S^2D)$ block scaling is **heuristic** (Poisson minimum gaps), used only to locate $c^{\rm unif}$ at low $s$, which `DPP.md` Thm 10 establishes independently. The consequence — that P4/D.6(1) cannot be closed by any Poisson constant — is proved and does not depend on the heuristic. |
| EC10 | Prior art | **In-corpus: searched** (§9). **External: not searched**, two items flagged from memory; nothing rests on them. No novelty claimed for Lemma $\rho$. — **PRIOR-ART SWEEP 2026-08-14: external now searched.** §9's premise "egress may be blocked" is half wrong: **`WebSearch` works, `WebFetch` is EGRESS_BLOCKED**, so what follows is search-summary (śabda) grade and no PDF was read. **(i) $\int_0^1\log x\log(1-x)\,dx=2-\zeta(2)$ — classical, and moot: re-proved in two lines in §4, so nothing rests on the attribution either way.** **(ii) Lemma $\rho$ — RESOLVED-NO-MATCH for the closed form.** The memory-flagged home is real and correctly named: Bogomolny–Keating are confirmed as the origin of the lower-order terms of the 2-, 3- and 4-point correlations of the zeros and of the zero-*difference* repulsion statistics (see e.g. arXiv:math/0610495 on triple correlation, arXiv:2102.02280 on difference repulsion). But nothing was located giving the self-convolved mean intensity of *sums* $\gamma+\gamma'$ in the $(\log\frac{s}{2\pi}-1)^2$ closed form of Lemma $\rho$, nor its $\gamma_1$-floor term. Queries: *density of sums of two Riemann zeta zeros gamma + gamma' self-convolution Riemann–von Mangoldt (log(s/2π)−1)² Fujii Bogomolny Keating*. Fujii's papers on sums of zeros were named in the results index but no statement was surfaced; that is the one shelf a future block with `WebFetch` should read first. Absence of a located source is not evidence of novelty. Attribution status only; EC1–EC9 and EC11 are untouched. |
| EC11 | What remains open | The separation hypothesis (P), as `DPP.md`/`DCLOSE_NO_GO.md` already own it, and the certified evaluation of EC7. Rank-2 is discharged in the sense the triage demanded — the constant no longer hides behind the open hypothesis — but $c$ itself is conditional on (P) and is **not** the constant P4 needs. |
