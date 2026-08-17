# The WL structure theorem, made uniform — and a correction to Theorem B1

`METHOD.md` §3 item 1: *"BARRIER Structure Proposition → theorem. WL
observables factor through the blurred spectral measure. Ingredients:
explicit formula per factor + absolute convergence after one smoothing; the
work is uniformity in the window."*

The work turned out not to be uniformity. Uniformity is two lines once the
right hypothesis is isolated (§3). The work was that **"absolute
convergence after one smoothing" is false for $k\ge3$**, and Theorem B1's
proof invokes it for all $k$. §2 derives the exact threshold. §4 records a
second, independent narrowing of Proposition B3.

Everything here is Stirling and integration by parts. No numerics.

---

## 1. Setup

For a dressing $a$ and $j\ge1$ Cesàro smoothings, the $k$-fold field is
$$\Psi^{(j)}_k(X)=\sum_{n_1+\dots+n_k\le X}a(n_1)\cdots a(n_k)\,
\frac{\bigl(X-\sum n_i\bigr)^j}{j!}.$$
The Dirichlet–Beta identity
$$\int_{\substack{u_i>0\\ \sum u_i\le X}}\prod_i u_i^{\rho_i-1}\,
\frac{(X-\sum u_i)^j}{j!}\,du=\frac{\prod_i\Gamma(\rho_i)}{\Gamma(\sum_i\rho_i+j+1)}\,
X^{\sum_i\rho_i+j}$$
(using $\Gamma(j+1)=j!$) makes the zero$^{\times k}$ layer a sum of waves
$e^{i(\sum\gamma_i)u}$ with weights
$$W^{(j)}_k(\vec\rho)=\frac{\prod_{i=1}^{k}\Gamma(\rho_i)}
{\Gamma\bigl(\sum_i\rho_i+j+1\bigr)} .$$
At $k=2$, $j=1$ this is $\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$ —
Theorem D's weight, as it must be. Write
$\sigma^{(j)}_k=\sum_{\vec\rho}W^{(j)}_k(\vec\rho)\,\delta_{\gamma_1+\dots+\gamma_k}$
and $\|\sigma^{(j)}_k\|=\sum_{\vec\rho}|W^{(j)}_k|$. Assume RH throughout, so
$\rho_i=\tfrac12+i\gamma_i$.

---

## 2. The smoothing threshold

**Lemma 1 (modulus of the $k$-body weight).** For same-sign ordinates
$\gamma_i>0$ with $s=\sum_i\gamma_i$,
$$\bigl|W^{(j)}_k(\vec\rho)\bigr|
=(2\pi)^{(k-1)/2}\,s^{-\frac{k+2j+1}{2}}\Bigl(1+O_{k,j}(1/s)\Bigr).$$

*Proof.* $|\Gamma(\tfrac12+i\gamma)|^2=\pi/\cosh(\pi\gamma)$ exactly, so
$|\Gamma(\tfrac12+i\gamma)|=\sqrt{2\pi}\,e^{-\pi\gamma/2}(1+O(e^{-2\pi\gamma}))$
— the numerator is $(2\pi)^{k/2}e^{-\pi s/2}$ up to an *exponentially* small
relative error. For the denominator, $\sum_i\rho_i+j+1=\tfrac k2+j+1+is$, and
Stirling on a vertical line gives
$|\Gamma(\sigma+is)|=\sqrt{2\pi}\,s^{\sigma-1/2}e^{-\pi s/2}(1+O_\sigma(1/s))$
with $\sigma=\tfrac k2+j+1$, i.e.
$\sqrt{2\pi}\,s^{\frac{k+2j+1}{2}}e^{-\pi s/2}$. The factors $e^{-\pi s/2}$
cancel **exactly**, leaving the stated ratio. $\square$

At $k=2,j=1$: $\sqrt{2\pi}\,s^{-5/2}$ — Theorem D‴, recovered.

**Lemma 2 (mixed signs are exponentially damped).** If the $\gamma_i$ are
not all of one sign, then with $\Sigma=\sum_i|\gamma_i|$ and $s=\sum_i\gamma_i$,
$$|W^{(j)}_k|\ll_{k,j}\ (1+|s|)^{-\frac{k+2j+1}{2}}\,e^{-\frac{\pi}{2}(\Sigma-|s|)},$$
and $\Sigma-|s|>0$ strictly. Hence mixed-sign tuples contribute a finite
amount for every $k,j$, and the convergence question concerns same-sign
tuples only.

*Proof.* The numerator carries $e^{-\pi\Sigma/2}$ and the denominator
$e^{-\pi|s|/2}$; the quoted bound is their ratio against Stirling's
polynomial factor, with $\Gamma$ bounded away from its poles for bounded
$|s|$ since $\Re(\sum\rho_i+j+1)=\tfrac k2+j+1>0$. $\square$

**Lemma 3 ($k$-fold ordinate density).** Let
$\mathcal N_k(S)=\#\{(\gamma_1,\dots,\gamma_k)\ \text{ordinates},\ \gamma_i>0,\ \sum_i\gamma_i\le S\}$,
counted with multiplicity as ordered tuples. Then
$$\mathcal N_k(S)=\frac{S^k}{k!}\Bigl(\frac{\log S}{2\pi}\Bigr)^{k}
\Bigl(1+O_k(1/\log S)\Bigr),\qquad
D_k(s):=\mathcal N_k'(s)\asymp_k \frac{s^{k-1}\log^k s}{(2\pi)^k\,(k-1)!}.$$

*Proof.* Riemann–von Mangoldt gives
$dN(t)=\frac1{2\pi}\log\frac{t}{2\pi}\,dt+dO(\log t)$. Then
$\mathcal N_k(S)=\int_{\sum t_i\le S}\prod_i dN(t_i)$. On the simplex, write
$\log\frac{t_i}{2\pi}=\log\frac{S}{2\pi}+\log\frac{t_i}{S}$; the second term
contributes $O(1/\log S)$ relatively after integration, since
$\int_{\sum t_i\le S}\prod|\log(t_i/S)|\,dt\ll_k S^k$. The main term is
$(\log S/2\pi)^k$ times the simplex volume $S^k/k!$. The $O(\log t)$ error
terms contribute $O_k(S^{k-1}\log^{k}S)$. Differentiating gives $D_k$. $\square$

> **Theorem B0 (smoothing threshold).** For every $k\ge2$ and $j\ge1$,
> $$\boxed{\ \|\sigma^{(j)}_k\|=\sum_{\vec\rho}\bigl|W^{(j)}_k(\vec\rho)\bigr|<\infty
> \iff k\le 2j.\ }$$
> Quantitatively, with the sum truncated at $\sum\gamma_i\le T$,
> $$\sum_{s\le T}|W^{(j)}_k|\ \asymp_{k,j}\
> \begin{cases}
> O(1), & k\le 2j,\\[2pt]
> \log^{k+1}T, & k=2j+1,\\[2pt]
> T^{\frac{k-2j-1}{2}}\log^{k}T, & k\ge 2j+2 .
> \end{cases}$$
> Equivalently: the $k$-body sum-spectral measure is a finite measure
> **iff at least $\lceil k/2\rceil$ Cesàro smoothings are applied.**

*Proof.* By Lemma 2 only same-sign tuples matter. By Lemmas 1 and 3,
$$\sum_{s\le T}\bigl|W^{(j)}_k\bigr|\asymp\int_{c}^{T}
s^{-\frac{k+2j+1}{2}}\cdot s^{k-1}\log^k s\ ds
=\int_c^T s^{\frac{k-2j-3}{2}}\log^k s\ ds .$$
The integral converges as $T\to\infty$ iff $\frac{k-2j-3}{2}<-1$, i.e.
$k<2j+1$, i.e. $k\le 2j$ for integers; the boundary and divergent rates are
the standard evaluations. $\square$

### 2.1 What this corrects

`BARRIER.md` §1, in the proof of Theorem B1, reads:

> *"Absolute convergence of the multiple zero sum after one Cesàro
> smoothing is Theorem D′/D‴-$k$ ($|W_k|\asymp s^{-(k+3)/2}$ against pair
> density $\asymp s\log^2 s$)."*

The weight is right. **The density is the $k=2$ density, used for all $k$.**
The correct $k$-fold density is $s^{k-1}\log^k s$ (Lemma 3), and with it
$j=1$ suffices only for $k\le2$. So:

- **Theorem B1 as stated is proved only for $k\le2$.** For $k\ge3$ the
  interchange of $\int w$ with $\sum_{\vec\rho}$ is not licensed by absolute
  convergence, because there is none. At $k=3,j=1$ the sum diverges like
  $\log^4T$ — slowly, which is exactly why nothing looked wrong.
- **The repair is cheap and does not damage the programme.** Take
  $j\ge\lceil k/2\rceil$. Every statement of B1 then holds verbatim with
  $W^{(j)}_k$ in place of $W_k$, since the proof used absolute convergence
  and nothing else about $j$. The WL class is *defined* by its access mode,
  not by a fixed smoothing count, so nothing in the definition changes.
- **The $k$-body ladder inherits the caveat.** `FAMILY.md` §2.3's Theorem
  D‴-$k$ and `INDEX.md`'s row assert the weight law "verified $k=2,3,4$".
  Lemma 1 *proves* the weight law for all $k$ and all $j$ — that part is
  now unconditional and needs no verification. But any statement built on
  summing that law over $k\ge3$ tuples at $j=1$ needs the extra smoothings.
- **This is the Lemma N failure mode one level up.** `CLAUDE.md`'s standing
  warning is that a measured constant hides its scaling. Here a *derived*
  density hid its $k$-dependence: correct where it was obtained ($k=2$),
  silently wrong when carried to general $k$. A quantity transported out of
  the regime where it was derived is the same error as a constant quoted
  without its parameter dependence, and it is harder to see because it
  arrives with a proof attached.

---

## 3. Uniformity in the window

With $\|\sigma^{(j)}_k\|<\infty$ secured, uniformity is short — but only
under a hypothesis that has to be stated, because it is doing all the work.

**Definition (dilation family).** Fix a profile $\phi\in C^\infty_c(\mathbb R)$
supported in $[-\tfrac12,\tfrac12]$. For $L>0$ and $u_0\in\mathbb R$ set
$$w_{L,u_0}(u)=L^{-1}\phi\bigl((u-u_0)/L\bigr).$$

> **Theorem B1′ (uniform structure theorem).** Let $k\ge2$,
> $j\ge\lceil k/2\rceil$, and let $w=w_{L,u_0}$ come from a dilation family
> with profile $\phi$. Then
> $$Q_w=\bigl\langle\sigma^{(j)}_k,\widehat w\bigr\rangle
> +\langle w,\mathrm{Smooth}\rangle+\langle w,E\rangle,$$
> and for every $N\ge0$ and $R\ge1$ the atoms at distance $>R/L$ in
> frequency from the window's centre satisfy
> $$\Bigl|\sum_{\left|\sum_i\gamma_i\right|>R/L}W^{(j)}_k\,
> \widehat w\bigl(\textstyle\sum_i\gamma_i\bigr)\Bigr|
> \ \le\ A_N\,R^{-N}\,\bigl\|\sigma^{(j)}_k\bigr\|,
> \qquad A_N=\bigl\|\phi^{(N)}\bigr\|_{L^1},$$
> with $A_N$ and $\|\sigma^{(j)}_k\|$ **independent of $L$ and of $u_0$**.

*Proof.* The identity is B1's, now licensed by Theorem B0. For the tail,
$$\widehat w_{L,u_0}(\xi)=\int L^{-1}\phi\bigl(\tfrac{u-u_0}{L}\bigr)e^{-i\xi u}du
=e^{-i\xi u_0}\,\widehat\phi(L\xi),$$
so $|\widehat w(\xi)|=|\widehat\phi(L\xi)|$ — the centre $u_0$ enters only as
a unimodular phase, and $L$ only through the *dilation* of the argument.
Integrating by parts $N$ times, $|\widehat\phi(\eta)|\le\|\phi^{(N)}\|_1|\eta|^{-N}$.
For $|\xi|>R/L$ we have $|L\xi|>R$, hence $|\widehat w(\xi)|\le A_NR^{-N}$.
Summing against $\sum|W^{(j)}_k|=\|\sigma^{(j)}_k\|<\infty$ gives the
bound. Neither factor depends on $L$ or $u_0$. $\square$

**Why the hypothesis is the content.** Uniformity holds precisely because
the profile is *fixed* and $L$ enters only by dilation: that is what makes
$A_N=\|\phi^{(N)}\|_1$ an $L$-free constant. If profiles are allowed to vary
with $L$ — say $\phi_L$ with $\|\phi_L^{(N)}\|_1\to\infty$ — the tail bound
degrades and the factorisation of §4 fails. The WL definition's clause
*"log-Fourier content confined to bandwidth-$O(1)$ windows measurable at
resolution $2\pi/L$"* is exactly this hypothesis, and it should be read as
such: **WL's bandwidth restriction is not a convenience, it is the
uniformity hypothesis of B1′.** An observable class that escapes the barrier
by using profiles of unbounded complexity is not a loophole in the theorem;
it is outside WL by definition, and worth naming as the first place to look
for a genuine escape.

---

## 4. The factorisation, and a second narrowing

> **Proposition B3′ (uniform factorisation).** Let
> $O=\Phi(Q_{w_1},\dots,Q_{w_r})$ with each $w_i$ drawn from dilation
> families with profiles $\phi_i$ satisfying
> $\sup_i\|\phi_i^{(N)}\|_1\le A_N<\infty$. Then:
>
> **(a) Exact form.** If $\sigma,\sigma'$ satisfy
> $\langle\sigma-\sigma',\widehat{w_i}\rangle=0$ for all $i$, then $O$ takes
> the same value on both, for **arbitrary** $\Phi$ — measurable,
> non-computable, anything. Post-processing cannot recover what the windows
> annihilated.
>
> **(b) Quantitative form.** If instead the windows only *nearly*
> annihilate the difference, the conclusion requires a modulus of
> continuity for $\Phi$: if $\Phi$ is Lipschitz with constant $\Lambda$ in
> $\ell^\infty$, then
> $$|O(\sigma)-O(\sigma')|\ \le\ \Lambda\Bigl(\sup_i
> \bigl|\langle\sigma-\sigma',\widehat{w_i}\rangle\bigr|\Bigr)
> \ \le\ \Lambda\bigl(\epsilon+2A_NR^{-N}\|\sigma\|\bigr),$$
> uniformly in $L$, where $\epsilon$ bounds the mismatch inside the
> resolved band.

*Proof.* (a) is immediate: the $r$ inputs to $\Phi$ are literally equal.
(b) is the definition of Lipschitz applied to inputs differing by at most
the in-band mismatch plus the out-of-band tail of Theorem B1′. $\square$

**The narrowing.** `BARRIER.md`'s Proposition B3 says the class factors
through the blurred measure with $\Phi$ *"arbitrary — even
non-computable"*. That is correct for **exact** indistinguishability (part
a) and **false as stated for approximate** indistinguishability: an
arbitrary $\Phi$ can amplify an arbitrarily small difference in its inputs
into an arbitrarily large difference in its output. Nothing prevents
$\Phi(t)=\mathbf 1[t>c]$ from separating two configurations whose windowed
readings differ by $10^{-100}$.

This matters for the barrier problem as posed, not just for bookkeeping.
The construction the programme has in hand — moment-matched sub-resolution
clusters (Theorem K0), with mismatch $O((\delta L)^{2p-1})$ — produces
**approximate** matching. So the honest statement of what B1–B3 deliver is:

> Against WL observables with *controlled* post-processing, a blur at
> resolution $2\pi/L$ is a genuine information barrier, uniformly in $L$.
> Against WL observables with arbitrary post-processing, only *exactly*
> matched blurred measures are indistinguishable — and exact matching is a
> much stronger demand on the construction than moment matching to order
> $p$.

The corpus's own no-go instinct applies: rather than strengthen the
construction, ask whether exact matching of two admissible spectra is
possible at all. Both configurations must satisfy
$N(T)\sim\frac{T}{2\pi}\log\frac{T}{2\pi}$ and the functional-equation
constraints; requiring in addition that all their $k$-fold sum-spectral
measures agree *exactly* against every span-$L$ window is a rigidity
question, and a negative answer would be a stronger and more interesting
result than the barrier.

---

## 5. Status of `METHOD.md` §3 item 1

| ingredient | before | now |
|---|---|---|
| explicit formula per factor | assumed | unchanged (Theorem D machinery) |
| absolute convergence, one smoothing | asserted for all $k$ | **false for $k\ge3$**; exact threshold $k\le2j$ (Theorem B0) |
| uniformity in the window | flagged as "the work" | **proved** (Theorem B1′), two lines given the right hypothesis, which is WL's own bandwidth clause |
| factorisation through the blur | Prop. B3, arbitrary $\Phi$ | exact case unchanged; **approximate case needs $\Phi$ controlled** (Prop. B3′) |

**Item 1 is discharged as far as it goes: the Structure Proposition is now
a theorem.** What it is a theorem *about* is narrower than the queue entry
assumed — it needs $\lceil k/2\rceil$ smoothings, and its quantitative form
needs controlled post-processing. Neither narrowing touches the $k=2$ case,
which is where every measured statement in this corpus lives.

**It does not convert the depth law into a barrier theorem**, and the queue
entry's claim that it would was too optimistic. `BARRIER.md` already says
why, and B1′ does not change it: a barrier needs *two admissible spectra*
that the blur cannot separate, and the zeros of $\zeta$ cannot be moved.
The structure theorem is the easy half, exactly as in the natural-proofs
analogy the note draws. The hard half is untouched.

## 6. Honesty ledger

| # | item | status |
|---|---|---|
| U1 | Lemmas 1–3, Theorem B0, Theorem B1′, Prop. B3′ | **Proved, unconditional given RH.** Lemma 1's error term is $O(1/s)$ from Stirling; the numerator's is exponentially small. |
| U2 | RH | Used to place $\rho_i=\tfrac12+i\gamma_i$ in Lemma 1. Off-line zeros change the modulus law and B0's threshold; not analysed. |
| U3 | Lemma 3's error term | Stated as $O_k(1/\log S)$ relative. The $O(\log t)$ term in Riemann–von Mangoldt is handled crudely ($O_k(S^{k-1}\log^kS)$ absolute); adequate for a convergence threshold, not for a second-order constant. No constant is claimed. |
| U4 | Multiplicities | $W^{(j)}_k$ is written per tuple of zeros; multiple zeros contribute $\prod m_{\rho_i}$. Under simplicity this is 1. Lemma 3 counts with multiplicity, so B0 is unaffected. |
| U5 | The $\mathrm{Smooth}$ and $E$ terms of B1 | Carried over from `BARRIER.md` unchanged and **not re-derived here**. B1′ improves the spectral pairing only; whether the error term $E$ is uniform in $L$ is not addressed and is the remaining loose thread in item 1. **RESOLVED — `BARRIER_ERROR_WINDOW.md`: $E$ is *not* uniform in $L$; $|\langle w,E\rangle|\le C_EX_0^{-\alpha}\Theta_\phi(\alpha L)$ with $\alpha=\tfrac12$ exactly (the $s{=}0$ layer), so it is uniform in the window's lower endpoint $X_0$ and degrades by exactly $e^{\alpha L}$ at fixed data top $X$; $\mathrm{Smooth}$ remains unanalysed and is now a separate queue item.** |
| U6 | Prop. B3′(b)'s $\epsilon$ | Left abstract. Connecting it to Theorem K0's $O((\delta L)^{2p-1})$ requires matching normalisations between the two notes; not done. |
| U7 | Prior art | Paley–Wiener tails, dilation families and Lipschitz error propagation are textbook; nothing in §3–§4 is claimed as new. Theorem B0's threshold $k\le2j$ is, as far as I know, not stated in this corpus — but **no literature search has been run**, and the underlying computation is routine enough that it may well be known for Riesz means of multiple Dirichlet series. Do not claim novelty without a search. — **PRIOR-ART SWEEP 2026-08-14: searched; split verdict, search-summary (śabda) grade (`WebFetch` EGRESS_BLOCKED, no PDF read). The *phenomenon* Theorem B0 identifies is standard and load-bearing in a live literature — RESOLVED-FOUND — while the exact threshold $k\le2j$ is RESOLVED-NO-MATCH.** The literature of Cesàro/Riesz averages of additive problems carries precisely B0's convergence question for precisely B0's object, the multiple Gamma-quotient sum $\sum_{\vec\rho}\bigl|\prod_i\Gamma(\rho_i)/\Gamma(\sum_i\rho_i+j+1)\bigr|$, and states its answer as a **lower bound on the Cesàro order that increases with the number of factors**: Languasco–Zaccagnini, *A Cesàro average of Goldbach numbers*, arXiv:1206.0251 (two primes, order $>1$); Cantarini, *On the Cesàro average of the "Linnik numbers"*, arXiv:1607.05629 (order $>3/2$); Languasco–Zaccagnini, arXiv:1806.04930 and arXiv:1806.05175; and, closest of all, *A Cesàro average for an additive problem with an arbitrary number of prime powers and squares*, arXiv:2012.02503 = Res. Number Theory (2022), which runs the same trade-off for arbitrarily many summands. So "absolute convergence after one smoothing, for all $k$" is not merely false as §2 proves — **it is known to be false, and the number of factors is known to be what forces the order up.** No located source states the threshold in the form $k\le2j$, and none was checked against source text. Queries: *Cesàro average sums of k primes Languasco Zaccagnini absolute convergence double sum over zeros Gamma quotient condition on k and weight*; *Riesz mean order j k-fold Dirichlet series convergence threshold Stirling absolutely convergent k ≤ 2j*; *Languasco Zaccagnini arbitrary number prime powers squares convergence condition number of summands*. Absence of a located source for the exact threshold is not evidence of novelty. Attribution status only; §2's derivation and the value $k\le2j$ are untouched. |
