# The $Q$-drift exponent is exactly $\tfrac12$ — and the constant is $\sqrt{\zeta(2)/12\zeta(4)}$

Rank-3 item of `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` §1, discharged.
The claim under audit is `LENS_NUMERICS.md:130–133`:

> Corollary 1.2 verified with room: $\max_X|D_Q-D_1|/C_Q$ = 0.12, 0.059,
> 0.032, 0.024 for $Q$ = 10, 30, 100, 300 — the bound's constant is generous
> by a widening factor (8→41): **the measured drift grows like $\sim Q^{0.6}$,
> not $\sim C_Q\sim Q$.**

Four points, 1.5 decades, one exponent, no error bar. The triage flagged it
as carrying the exp27 signature and proposed a Mertens-scale
$Q^{1/2+o(1)}$ route through $\sup_x|\varepsilon_Q(x)|$ (`MERTENS_FLOOR.md`
Lemma 2), sharp exponent conditional on $M(Q)$ cancellation.

**The derivation disagrees with the proposed route and is stronger than it.**
The drift statistic is diagonalised exactly by Parseval on *primitive*
frequencies; the answer is unconditional, the exponent is exactly $\tfrac12$
with **no $o(1)$ in the exponent at all** (the correction is a power saving
$O_\varepsilon(Q^{-1/2+\varepsilon})$), the constant is closed-form, and
$M(Q)$ **plays no role whatsoever** — the Mertens term $\tfrac12M(Q)$ is a
pure additive constant in $\psi^\flat_Q$ and is annihilated by the
oscillation that defines $D_Q$. The controlling sum turns out to be
$C_Q$ itself, restricted to squarefree arguments: the *same* arithmetic sum
$W(Q)$ is (i) the $\ell^1$ bound behind Corollary 1.2 and (ii) exactly
twelve times the mean square. Bound $=\Theta(W)$, truth $=\Theta(\sqrt W)$;
the note's "widening slack factor 8→41" is that square root and nothing
else.

Nothing here was measured. §5 confronts the derivation with the published
exp32 table (licensed: checking a derivation); the only computations are
finite exact-rational sums.

---

## 1. Objects, and the reduction to a single function

Notation as in `LENS_NUMERICS.md` §1 / `MERTENS_FLOOR.md`.
$\Lambda^\sharp_Q(n)=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q(n)
=\sum_{d\mid n,\,d\le Q}A_d$ with
$A_d=\frac{d\mu(d)}{\varphi(d)}\sum_{m\le Q/d,\,(m,d)=1}\frac{\mu^2(m)}{\varphi(m)}$;
$\Lambda^\flat_Q=\Lambda-\Lambda^\sharp_Q$;
$\psi^\flat_Q(x)=\sum_{n\le x}\Lambda^\flat_Q(n)$;
$D_Q(X)=\sup_{I\subseteq(0,X]}\bigl|\sum_{n\in I}\Lambda^\flat_Q\bigr|
=\operatorname{osc}_{y\le X}\psi^\flat_Q$; $E(x)=\psi(x)-x$;
$s(t)=\tfrac12-\{t\}$ (sawtooth, mean zero, $|s|\le\tfrac12$);
$e(t)=e^{2\pi it}$; $P_Q=\prod_{p\le Q}p$.

By `MERTENS_FLOOR.md` Lemma 2, $\Psi^\sharp_Q(x)=x-\tfrac12M(Q)+\varepsilon_Q(x)$
with $\varepsilon_Q(x)=\sum_{d\le Q}A_d\,s(x/d)$. Since
$\sum_{d\le Q}A_d/d=1$ (Lemma 1 there) and $s(n/d)$ has mean $\tfrac1{2d}$
over integers $n$, the integer-normalised deviation

$$\tilde\varepsilon_Q(n):=\varepsilon_Q(n)-\tfrac12
=\sum_{d\le Q}A_d\Bigl(s(n/d)-\frac{1}{2d}\Bigr)$$

has mean zero over $n$. Both $\psi$ and $\Psi^\sharp_Q$ are constant on
$[n,n+1)$, so every sup/inf defining $D_Q$ is attained at an integer.

> **Lemma R (reduction).** For all $X\ge1$, $Q\ge1$,
> $$D_Q(X)=\operatorname*{osc}_{n\le X}\bigl(E(n)-\tilde\varepsilon_Q(n)\bigr),
> \qquad D_1(X)=\operatorname*{osc}_{n\le X}E(n),$$
> and therefore, **uniformly in $X$**,
> $$\bigl|D_Q(X)-D_1(X)\bigr|\;\le\;\operatorname*{osc}_{n\le X}\tilde\varepsilon_Q
> \;\le\;2\sup_n\bigl|\tilde\varepsilon_Q(n)\bigr| .$$

*Proof.* $\psi^\flat_Q(n)=E(n)+\tfrac12M(Q)-\varepsilon_Q(n)
=E(n)+\tfrac12(M(Q)-1)-\tilde\varepsilon_Q(n)$; the additive constant drops
out of an oscillation. At $Q=1$, $A_1=1$ and $\Lambda^\sharp_1\equiv1$, so
$\tilde\varepsilon_1\equiv0$ identically. Finally $\operatorname{osc}$ is
subadditive. $\square$

Two consequences worth stating at once. **(i) $M(Q)$ is irrelevant.** It
enters $\psi^\flat_Q$ as a constant and cannot contribute to any
oscillation, so the triage's Mertens-cancellation route is not merely
unnecessary but inapplicable; the drift never sees $M(Q)$. **(ii) the drift
is bounded in $X$** — Corollary 1.2's $O_Q(1)$ — so $\max_X$ over any window
is a statistic of the single function $\tilde\varepsilon_Q$, and the whole
question is: *how big is $\tilde\varepsilon_Q$?*

## 2. Primitive-frequency diagonalisation: the amplitudes are $\mu(r)/\varphi(r)$

For integer $n$ the finite Fourier expansion of the sawtooth is
$$s(n/d)=\frac{1}{2d}-\frac1d\sum_{k=1}^{d-1}\frac{e(kn/d)}{e(-k/d)-1},$$
(the $k$-th coefficient of $r\mapsto\tfrac12-\tfrac rd$ on $\mathbb Z/d$ is
$-\bigl(d(e(-k/d)-1)\bigr)^{-1}$, from $\sum_{r<d}rz^r=d/(z-1)$ when
$z^d=1\neq z$). Hence
$$\tilde\varepsilon_Q(n)=-\sum_{d\le Q}\frac{A_d}{d}
\sum_{k=1}^{d-1}\frac{e(kn/d)}{e(-k/d)-1}.$$
Group the terms by the frequency $k/d$ *in lowest terms* $k'/r$: the kernel
$\bigl(e(-k/d)-1\bigr)^{-1}=\bigl(e(-k'/r)-1\bigr)^{-1}$ depends on the
reduced pair only, and $d$ runs over multiples $rj\le Q$. So

$$\tilde\varepsilon_Q(n)=\sum_{1<r\le Q}\frac{B_r}{r}\;\eta_r(n),\qquad
B_r:=\sum_{j\le Q/r}\frac{A_{rj}}{j},\qquad
\eta_r(n):=-\!\!\sum_{\substack{1\le k<r\\(k,r)=1}}\!\frac{e(kn/r)}{e(-k/r)-1}.
\tag{2.1}$$

> **Lemma B (amplitude collapse).** For every $r\le Q$,
> $$\boxed{\;B_r=\frac{r\,\mu(r)}{\varphi(r)}\;}$$
> — independent of the truncation level $Q$.

*Proof.* $A_d=d\sum_{q\le Q,\,d\mid q}\mu(q)\mu(q/d)/\varphi(q)$, so
$$B_r=r\sum_{j\le Q/r}\ \sum_{\substack{q\le Q\\ rj\mid q}}
\frac{\mu(q)\mu\bigl(q/(rj)\bigr)}{\varphi(q)}
=r\sum_{\substack{q\le Q\\ r\mid q}}\frac{\mu(q)}{\varphi(q)}
\sum_{j\mid (q/r)}\mu\Bigl(\frac{q/r}{j}\Bigr),$$
(the constraint $j\le Q/r$ is automatic once $j\mid q/r\le Q/r$). The inner
sum is $\mathbf 1_{q=r}$. $\square$

This is the structural fact the whole note rests on: **truncating the
Ramanujan expansion at level $Q$ does not deform the primitive-frequency
amplitudes of $\Psi^\sharp_Q-x$; it only decides which frequencies are
present.** The amplitude at every denominator $r$ is $\mu(r)r/\varphi(r)$,
the same for all $Q\ge r$. ($r=1$ recovers $\sum_{d\le Q}A_d/d=1$,
`MERTENS_FLOOR.md` Lemma 1 (ii).) Note $\eta_r$ is real (pair $k$ with
$r-k$), $r$-periodic and mean-zero, and $\mu^2(r)=0$ kills non-squarefree
denominators.

## 3. Theorem D: the exact mean square, the exact sup bound, one sum for both

Write
$$W(Q):=\sum_{r\le Q}\mu^2(r)\,\frac{\sigma(r)}{\varphi(r)}
=\sum_{r\le Q}\mu^2(r)\prod_{p\mid r}\frac{p+1}{p-1}.$$
This is `LENS_REGULARITY.md` Lemma 1.1's constant
$C_Q=\sum_{r\le Q}\sigma(r)/\varphi(r)$ restricted to squarefree $r$ — the
restriction their own proof permits, since only squarefree $r$ contribute
to $\Lambda^\sharp_Q$.

> **Theorem D.** For every $Q\ge1$:
>
> **(a) (mean square, exact)** $\tilde\varepsilon_Q$ is $P_Q$-periodic and
> $$\frac{1}{P_Q}\sum_{n=1}^{P_Q}\tilde\varepsilon_Q(n)^2
> \;=\;\frac{W(Q)-1}{12}\qquad\text{exactly.}$$
>
> **(b) (sup bound)** $\displaystyle\sup_n|\tilde\varepsilon_Q(n)|\le\frac{W(Q)-1}{2}$,
> hence by Lemma R, uniformly in $X$,
> $$\bigl|D_Q(X)-D_1(X)\bigr|\le W(Q)-1 .$$
>
> **(c) (sup lower bound)** $\displaystyle\sup_n|\tilde\varepsilon_Q(n)|
> \ge\sqrt{\tfrac{1}{12}(W(Q)-1)}$, for **every** $Q$, unconditionally.
>
> **(d) (asymptotics)** $\displaystyle W(Q)=\frac{\zeta(2)}{\zeta(4)}\,Q
> +O_\varepsilon\!\left(Q^{1/2+\varepsilon}\right)$,
> $\ \frac{\zeta(2)}{\zeta(4)}=\prod_p\bigl(1+p^{-2}\bigr)=1.5198177546\ldots$,
> so the RMS scale of the drift is
> $$2\sqrt{\frac{W(Q)-1}{12}}
> =\sqrt{\frac{\zeta(2)}{3\,\zeta(4)}}\;Q^{1/2}
> \Bigl(1+O_\varepsilon(Q^{-1/2+\varepsilon})\Bigr)
> =0.7117625\ldots\;Q^{1/2}\bigl(1+O_\varepsilon(Q^{-1/2+\varepsilon})\bigr).$$

*Proof of (a).* $\Lambda^\sharp_Q(n)$ depends on $n$ only through
$\gcd(n,P_Q)$ (`E2_PROOF.md` Lemma U1, Corollary) and has mean $1$, so its
summatory deviation $\tilde\varepsilon_Q$ is $P_Q$-periodic with mean zero.
In (2.1) the characters $e(kn/r)$ over distinct primitive pairs $(k,r)$,
$r\mid P_Q$, are orthonormal, and
$\bigl|e(-k/r)-1\bigr|^{-2}=\bigl(4\sin^2(\pi k/r)\bigr)^{-1}$. Hence
$$\langle\tilde\varepsilon_Q^2\rangle=\sum_{1<r\le Q}\frac{B_r^2}{r^2}\cdot
\frac14\!\!\sum_{\substack{k<r\\(k,r)=1}}\!\!\csc^2\frac{\pi k}{r}
=\sum_{1<r\le Q}\frac{\mu^2(r)}{\varphi(r)^2}\cdot\frac14\,T^*(r).$$
From the classical $\sum_{k=1}^{r-1}\csc^2(\pi k/r)=\tfrac13(r^2-1)$ and
Möbius inversion over $e\mid r$,
$T^*(r)=\tfrac13\sum_{e\mid r}\mu(r/e)(e^2-1)=\tfrac13\prod_{p\mid r}(p^2-1)$
for squarefree $r>1$ (the $-1$'s cancel). Therefore the $r$-term is
$\frac{1}{12}\prod_{p\mid r}\frac{(p-1)(p+1)}{(p-1)^2}
=\frac{1}{12}\prod_{p\mid r}\frac{p+1}{p-1}=\frac{\mu^2(r)\sigma(r)}{12\,\varphi(r)}$,
and summing over $1<r\le Q$ gives $\tfrac1{12}(W(Q)-1)$. $\square$

*Proof of (b).* Undoing the grouping in (2.1) in the other direction,
$\eta_r(n)=r\,P_r(n)$ with $P_r(x)=\sum_{e\mid r}\frac{\mu(e)}{e}s(ex/r)$
(Möbius inversion of $s(x/r)=\sum_{e\mid r}e^{-1}P_{r/e}(x)$, itself the
same primitive-frequency grouping applied to a single sawtooth), so
$|\eta_r|\le\frac r2\sum_{e\mid r}\frac{\mu^2(e)}{e}=\frac{\sigma(r)}{2}$
for squarefree $r$. With $B_r/r=\mu(r)/\varphi(r)$, (2.1) gives
$|\tilde\varepsilon_Q|\le\frac12\sum_{1<r\le Q}\mu^2(r)\sigma(r)/\varphi(r)$. $\square$

*Proof of (c).* $\sup\ge$ RMS, with (a). $\square$

*Proof of (d).* $f(r)=\mu^2(r)\sigma(r)/\varphi(r)$ is multiplicative with
$f(p)=\frac{p+1}{p-1}$, $f(p^k)=0$ ($k\ge2$). Write $f=\mathbf 1*h$;
$h(p)=\frac{2}{p-1}$, $h(p^2)=-\frac{p+1}{p-1}$, $h(p^k)=0$ ($k\ge3$). Then
$W(Q)=\sum_{m\le Q}h(m)\lfloor Q/m\rfloor
=Q\sum_{m\ge1}\frac{h(m)}{m}+O\bigl(\sum_{m\le Q}|h(m)|+Q\sum_{m>Q}\tfrac{|h(m)|}{m}\bigr)$,
and $|h|$ is supported on $m=ab^2$ with $|h(a)|\le 6^{\omega(a)}/a$
(squarefree $a$) and $\prod_{p\mid b}\frac{p+1}{p-1}\le3^{\omega(b)}$, so
both error sums are $O_\varepsilon(Q^{1/2+\varepsilon})$. The main constant
is $\prod_p(1-p^{-1})\bigl(1+\frac{p+1}{p(p-1)}\bigr)=\prod_p\frac{p^2+1}{p^2}
=\zeta(2)/\zeta(4)$. $\square$

**Three readings.**

1. **Bound and truth are the same sum, at powers $1$ and $\tfrac12$.**
   $\;\sup\le\tfrac12(W-1)$ while $\|\cdot\|_2=\sqrt{(W-1)/12}$. The ratio
   of the two, $\sqrt{3(W(Q)-1)}$, is the *entire* content of
   `LENS_NUMERICS.md`'s "the bound's constant is generous by a widening
   factor (8→41)". It widens because it is a square root, and it is
   provably $\asymp\sqrt Q$.
2. **Corollary 1.2 sharpens for free.** For real $x$,
   $|\Psi^\sharp_Q(x)-x|\le\tfrac12\bigl(|M(Q)|+W(Q)\bigr)$, replacing
   $C_Q$. Asymptotically $C_Q\sim\kappa Q$ with
   $\kappa=\prod_p\frac{p^4-p^3+p^2+p-1}{p(p-1)^2(p+1)}=3.55\ldots$, so
   this is a factor $\approx4.7$; at $Q=10$ it is $10.17$ against $C_{10}=28.75$.
   Also `LENS_REGULARITY.md:66`'s "$\ll Q(\log\log Q)^2$" is not tight:
   $W(Q)\sim\frac{\zeta(2)}{\zeta(4)}Q$ and $C_Q\asymp Q$, with no
   $\log\log$.
3. **The exponent is exactly $\tfrac12$ with a power-saving correction.**
   Not $Q^{1/2+o(1)}$: the $o(1)$ the triage expected does not exist. The
   correction to the *scale* is multiplicative
   $\sqrt{W(Q)/(\beta Q)}=1+O_\varepsilon(Q^{-1/2+\varepsilon})$ with
   $\beta=\zeta(2)/\zeta(4)$ — and §5 shows this correction is the larger
   half of the story at the sampled $Q$, exactly as `HOLOGRAM.md` §7 warns.

## 4. What is *not* proved

$\sup_n|\tilde\varepsilon_Q(n)|$ is pinned only between
$\sqrt{(W-1)/12}\asymp Q^{1/2}$ and $\tfrac12(W-1)\asymp Q$ — a genuine
gap, of exactly the shape `E2_PROOF.md` ledger H4 carries for
$\sup_n|\Lambda^\sharp_Q(n)|$ ($\gg Q^{1/2}$ i.o. unconditionally,
$Q^{1/2+o(1)}$ expected, no proof). Theorem D(c) is a small improvement in
kind on U5: it gives $\gg Q^{1/2}$ for **every** $Q$, not infinitely often,
and unconditionally, because it comes from a mean square rather than from
$\Omega$-results for $M$. Closing the upper side would need genuine
cancellation among the $\eta_r$, i.e. a Halász/large-sieve input, and is
not attempted here.

This gap does not damage §5: the measured statistic is not the global sup
(see H-EV below).

## 5. Why a four-point, 1.5-decade fit reads $0.6$

Exact evaluation of $W(Q)$ (finite sums of rationals; each term
$\sigma(r)/\varphi(r)$ is exact and the accumulation error is $<10^{-12}$),
against `LENS_NUMERICS.md` §2's published drifts $\max_X|D_Q-D_1|$:

| $Q$ | $W(Q)$ | $W(Q)/\beta Q$ | $\sigma_Q:=\sqrt{\frac{W(Q)-1}{12}}$ | derived scale $2\sigma_Q$ | published drift | $\rho_Q:=\text{drift}/\sigma_Q$ | ceiling $\sqrt{12(W{-}1)}$ |
|---:|---:|---:|---:|---:|---:|---:|---:|
|  10 |  19.3333 | 1.2721 | 1.2360 |  2.472 |  3.50 | 2.832 | 14.83 |
|  30 |  51.8651 | 1.1375 | 2.0588 |  4.118 |  5.89 | 2.861 | 24.71 |
| 100 | 152.3235 | 1.0022 | 3.5511 |  7.102 | 11.01 | 3.100 | 42.61 |
| 300 | 460.8389 | 1.0107 | 6.1903 | 12.381 | 26.11 | 4.218 | 74.28 |

(Sanity check on the identification: the same code gives
$C_Q=1,\ 28.75,\ 99.846,\ 346.242,\ 1066.999$, reproducing the note's
$C_Q$ column $1.0,\ 28.8,\ 99.8,\ 346.2,\ 1067.0$ to all printed digits. So
the object the note's Corollary-1.2 budget measures and the object Theorem D
diagonalises are the same one.)

**(i) The theorem's own four-point slope is $0.4714$, not $0.5$.** Fit
$\log\sigma_Q$ against $\log Q$ by least squares on exactly these four $Q$:
the *exact* law reads $0.4714$. Because $W(Q)/\beta Q$ falls from $1.272$
to $1.011$ across the range, the finite-$Q$ correction *depresses* the
apparent exponent by $0.03$ below the truth. A measurement that reproduced
the theorem perfectly at these four $Q$ would have been reported as
"$\sim Q^{0.47}$".

**(ii) Segment by segment, the first two-thirds of the range is the
theorem.** Local log-log slopes:

| segment | measured drift | derived $\sigma_Q$ | residual (slope of $\rho_Q$) |
|---|---:|---:|---:|
| $10\to30$   | 0.4738 | 0.4644 | **0.0093** |
| $30\to100$  | 0.5196 | 0.4528 | 0.0668 |
| $100\to300$ | 0.7860 | 0.5058 | 0.2802 |
| global $10\to300$ | 0.5908 | 0.4737 | 0.1172 |
| 4-point least squares | 0.5829 | 0.4714 | 0.1115 |

The first segment agrees with the derived law to $0.009$. The reported
"$Q^{0.6}$" is manufactured by the last segment alone, where a single
realisation of an extremal statistic at $Q=300$ came in $36\%$ above the
ratio held by the other three points. Four points in log-log have no
leverage to see that.

**(iii) The residual is a dimensionless ratio, not a power.** All of the
excess lives in $\rho_Q=2.832,\,2.861,\,3.100,\,4.218$: it moves by a
factor $1.49$ while the derived law moves by $5.01$. So $80\%$ of the
observed growth (in log) is Theorem D; $20\%$ is the drift of $\rho_Q$.
And $\rho_Q$ is *provably* confined to $[0,\sqrt{12(W(Q)-1)}]$ — the last
column — where the data sits at $19\%,\,12\%,\,7\%,\,6\%$ of the ceiling,
moving *down* the ceiling, not up a power law.

**(iv) Why $\rho_Q$ drifts upward at all — model (H-EV), not theorem.**
$\max_X|D_Q-D_1|$ is a one-sided extremal statistic: the perturbation
$-\tilde\varepsilon_Q$ steals a new record only where the unperturbed path
$E$ is within $\delta$ of its extremum, $\delta\asymp$ the drift itself.
The size of that plateau is bounded below unconditionally: $E$ decreases at
unit rate between prime powers, so $E(n_0+j)\ge E(n_0)-j$ and the plateau
contains an interval of length $\ge\delta$. Hence the number $N$ of places
where the perturbation can compete grows with the perturbation's own size,
$N\gtrsim\delta\asymp\sqrt Q$ — a positive feedback. For any extremal
statistic $G=\sigma_Q\rho(N)$ with $N\propto G$ this closes into
$$a\;=\;a_\sigma+\lambda\,a,\qquad a=\frac{a_\sigma}{1-\lambda},\qquad
\lambda:=\frac{d\log\rho}{d\log N}\ \ge0,$$
where $a$ is the apparent exponent and $a_\sigma=0.4714$ is the derived
scale exponent over this range. The observed $a=0.5829$ corresponds to
$\lambda=0.191$, squarely inside the range $\lambda\in[0.15,0.4]$ taken by
the expected maximum of $N$ samples in the small-$N$ regime $N\lesssim30$
that the observed tail depths ($\rho_Q/2\approx1.4$–$2.1$ per side) imply.
The point is not the value of $\lambda$ but its asymptotics:
$\lambda\to\frac{1}{2\log N}\to0$, so
$$a(Q)=\tfrac12+\Theta\!\left(\frac{1}{\log Q}\right)\longrightarrow\tfrac12 .$$
**"$0.6$" is $\tfrac12+\Theta(1/\log Q)$ evaluated at $\log Q\approx5$.**
The exponent has no limit other than $\tfrac12$; what it has is a
correction that a decade and a half cannot resolve — the `HOLOGRAM.md` §7
failure mode exactly, a number quoted without its scaling.

**(v) Consistency verdict.** Derived scale exponent over the sampled range
$0.4714$; proved ceiling on the residual factor; a feedback correction of
order $+0.1$ from the extremal sampling; measured $0.583$. The measurement
is consistent with Theorem D and carries no information against it. What it
is *not* is evidence for an exponent $0.6$.

## 6. Hypotheses, and exactly where each enters

- **(H1) None for Theorem D.** Lemma R, Lemma B and Theorem D(a)–(d) are
  unconditional finite algebra plus $\sum_{k<r}\csc^2(\pi k/r)=(r^2-1)/3$
  and elementary Dirichlet-series bookkeeping. No RH, no GRH, no Mertens
  input, no $\Lambda$-side hypothesis: $\tilde\varepsilon_Q$ is an explicit
  arithmetic function and the whole of §§1–3 is about it alone.
- **(H2) Window adequacy** (enters §5's table only). Theorem D(a) is the
  mean square over a full period $P_Q$; the exp32 numbers are read over
  $n\le X=10^7$, whereas $P_{30}\approx6.5\times10^9$ and
  $P_{300}\approx e^{300}$. The mean square only involves *pairwise*
  correlations, each periodic mod $\operatorname{lcm}(d,d')\le Q^2\le9\times10^4\ll X$,
  so every individual pairwise average has converged; but the trivial bound
  on the accumulated error,
  $\frac1{2X}\sum_{d,d'\le Q}|A_dA_{d'}|\operatorname{lcm}(d,d')$, is *not*
  $o(1)$ at $Q=300$, $X=10^7$ (it is of the same order as the main term).
  No cancellation was proved. This affects §5's numerical comparison only,
  never §3.
- **(H-EV) Extremal-sampling model** (enters §5(iv) only, explicitly
  labelled). That $\max_X|D_Q-D_1|$ behaves as an extreme-value statistic
  over the plateau, with $\rho$ the expected-maximum curve. The plateau
  lower bound $N\ge\delta$ is proved; the identification of $\rho$ with the
  Gaussian expected-maximum curve is not. Nothing in §§1–4 or in the
  verdict "the exponent is $\tfrac12$" depends on it; it is used only to
  say that a residual of size $+0.1$ in a four-point fit is *expected*
  rather than anomalous.
- **(H3) $\Lambda$-side independence.** §5(iv) treats $\tilde\varepsilon_Q$
  and $E$ as uncorrelated near the extremes. This is what makes the drift
  systematically *negative* ($D_Q<D_1$ at all four $Q$ in the published
  table — adding an independent bounded fluctuation to a path can only
  enlarge its oscillation, so removing one shrinks it), which the data
  confirms; it is not used quantitatively.

## 7. Downstream corrections forced

1. **`LENS_NUMERICS.md:130–133`** — "the measured drift grows like
   $\sim Q^{0.6}$, not $\sim C_Q\sim Q$" is retired. Correct statement:
   the drift is controlled by $\tilde\varepsilon_Q$, whose exact mean square
   is $\frac1{12}\bigl(\sum_{r\le Q}\mu^2(r)\sigma(r)/\varphi(r)-1\bigr)$;
   the scale is $\sqrt{\zeta(2)/3\zeta(4)}\,Q^{1/2}(1+O(Q^{-1/2+\varepsilon}))
   =0.71176\,Q^{1/2}$, the exponent is exactly $\tfrac12$, and the observed
   $0.6$ is $\tfrac12+\Theta(1/\log Q)$ read at four points.
2. **Same note, verdict 1 (`:20–34`)** — "the bound's constant is generous
   by a widening factor (8→41)" is now explained, not observed: the bound
   and the truth are $W(Q)$ and $\sqrt{(W(Q)-1)/12}$, so the slack is
   $\asymp\sqrt{Q}$ by theorem. With the sharpened budget $W(Q)-1$ in place
   of $C_Q$ the slack factors are $5.2,\,8.6,\,13.7,\,17.6$.
3. **`LENS_REGULARITY.md` Lemma 1.1 / Corollary 1.2 (`:60–100`)** — $C_Q$
   may be replaced throughout by its squarefree restriction $W(Q)$ (their
   own proof only uses squarefree $r$), and at $q=1$ by the sharper
   $\tfrac12(|M(Q)|+W(Q))$. The parenthetical "$\ll Q(\log\log Q)^2$"
   should read $\sim\frac{\zeta(2)}{\zeta(4)}Q$ for $W$, $\asymp Q$ for $C_Q$.
4. **`PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` §1 row 3** — the proposed
   route (Mertens-scale, sharp exponent conditional on $M(Q)$ cancellation)
   is superseded: $M(Q)$ cancels out of the statistic entirely and the
   exponent is unconditional. The estimate "1–2 pages for $o(Q)$; sharp
   exponent conditional" was pessimistic in kind, not only in length.
5. **No propagation elsewhere.** The $Q$-uniformity headline of
   `LENS_NUMERICS.md` verdict 1 (exponents $0.487$–$0.502$ in $X$) is
   untouched and is in fact *strengthened*: Theorem D(b) proves
   $D_Q=D_1+O(W(Q))$ uniformly in $X$ with an explicit constant, so the
   $X$-exponent cannot move with $Q$ at all.

## 8. Prior art (`SEARCH`, open)

Searched in-corpus before writing: `LENS_NUMERICS.md`, `LENS_REGULARITY.md`,
`MERTENS_FLOOR.md`, `E2_PROOF.md`, `CROSSREVIEW_THMJ.md` (its
$\varepsilon_Q$ is an unrelated object — the block-identification error
term), `ADELIC_CRYSTAL.md` (which carries $\prod_p(1+p^{-2})=\zeta(2)/\zeta(4)$
at `:496` in an unrelated Tate-factor role — coincidence of constant, not
of mechanism). No in-corpus statement of Lemma B or Theorem D.

External, **from memory, not verified — egress may be blocked**, and no
novelty is claimed until checked: (i) the sawtooth correlation
$\langle s(x/d)s(x/d')\rangle=\frac{(d,d')^2}{12dd'}$ and the cosecant sum
$\sum_{k<r}\csc^2(\pi k/r)=\frac{r^2-1}{3}$ are classical; (ii) mean squares
of $\sum_{d\le Q}c_d\,s(x/d)$ are standard in the divisor/Farey error
literature (Franel–Landau circle of ideas); (iii) that $\Lambda^\sharp_Q$ is
the $L^2$ projection of $\Lambda$ onto $\mathrm{span}\{c_q\}_{q\le Q}$ is
the standard Ramanujan–Fourier picture; (iv) the coprime Mertens constant
$C=\gamma+\sum_p\frac{\log p}{p(p-1)}$ is Montgomery–Vaughan /
Halberstam–Richert, already imported at `E2_PROOF.md` Lemma U2. Lemma B
(the $Q$-independence of the primitive amplitudes) is elementary enough to
be classical and is the item most likely to have a home in the literature.

**SEARCH resolved 2026-08-14 (`cf-tessera`) — item-by-item, search-summary
grade; DE10 updated in status only, no claim touched.**
(i) **Split.** The cosecant sum $\sum_{k<r}\csc^2(\pi k/r)=\frac{r^2-1}{3}$
is **RESOLVED-FOUND**: confirmed classical in the finite-trigonometric-sum
literature (e.g. *Exact evaluations and reciprocity theorems for finite
trigonometric sums*, arXiv:2210.00180; arXiv:1811.00361), stated there as
$\sum_{k=1}^{m-1}\csc^2(k\pi/m)=\tfrac13(m^2-1)$. The sawtooth correlation
$\langle s(x/d)s(x/d')\rangle=\frac{(d,d')^2}{12dd'}$ is
**RESOLVED-NO-MATCH** (queries: *correlation of sawtooth functions
((x/d))((x/d')) mean value gcd²/(12dd') Franel Landau*; *mean value product
periodic Bernoulli $B_1$ gcd²/(12dd')*).
(ii) **RESOLVED-NO-MATCH.** Franel–Landau is confirmed as the standard
Farey-discrepancy/RH equivalence, but no source was located for mean squares
of $\sum_{d\le Q}c_d\,s(x/d)$ specifically; "Franel–Landau circle of ideas"
stands as an orientation, not a citation.
(iii) **RESOLVED-FOUND.** Ramanujan expansions are standardly presented as a
Fourier expansion in an inner-product space with the $c_q$ as an orthogonal
basis (Carmichael orthogonality); see Murty, *Ramanujan series for
arithmetical functions*, Hardy–Ramanujan J. (2013), and finite Ramanujan
expansions of $\Lambda$ (arXiv:1705.07193). The projection picture for
$\Lambda^\sharp_Q$ is not novel.
(iv) **RESOLVED-NO-MATCH for the exact constant.** Montgomery–Vaughan,
*Multiplicative Number Theory I* (CUP 2006) is confirmed as a real
reference, but no located statement surfaced $C=\gamma+\sum_p\frac{\log
p}{p(p-1)}$ in that form; the import at `E2_PROOF.md` Lemma U2 remains
memory-sourced.
**Lemma B** ($B_r=\mu(r)r/\varphi(r)$): **RESOLVED-NO-MATCH** — no home
located, so §8's own guess that it is classical is neither confirmed nor
refuted. Absence of a located source is not evidence of novelty and no
novelty claim is added here.
**Egress:** `WebSearch` worked; `WebFetch` was blocked on every host tried
(arxiv.org, ui.adsabs.harvard.edu, semanticscholar.org, en.wikipedia.org)
with `{"error_type":"EGRESS_BLOCKED", ... "blocked by the network egress
proxy."}` — no PDF was read, so §8's four items move from
**from-memory** to **search-summary (śabda)**, not to **verified**.

## 9. Honesty ledger

| # | item | status |
|---|---|---|
| DE1 | Lemma R (drift $=$ oscillation of $E-\tilde\varepsilon_Q$; $M(Q)$ annihilated) | **Proved, unconditional.** Uses `MERTENS_FLOOR.md` Lemmas 1–2 as quoted (both proved there). |
| DE2 | Lemma B: $B_r=\mu(r)r/\varphi(r)$ for all $r\le Q$, independent of $Q$ | **Proved, unconditional.** Finite Möbius identity; re-proves `MERTENS_FLOOR.md` Lemma 1(ii) at $r=1$. |
| DE3 | Theorem D(a): mean square $=\frac{W(Q)-1}{12}$ | **Proved, exact identity** (not an asymptotic). Verified independently by hand at $Q=2$ ($1/4$) and $Q=3$ ($5/12$, from the six values of $\tilde\varepsilon_3$ mod $6$). |
| DE4 | Theorem D(b),(c): $\sqrt{(W-1)/12}\le\sup\le(W-1)/2$; drift $\le W(Q)-1$ | **Proved, unconditional.** Sharpens `LENS_REGULARITY.md` Cor 1.2 by $\approx4.7$. |
| DE5 | Theorem D(d): $W(Q)=\frac{\zeta(2)}{\zeta(4)}Q+O_\varepsilon(Q^{1/2+\varepsilon})$ | **Proved, elementary** (Dirichlet hyperbola on $f=\mathbf1*h$); the $\varepsilon$ is not optimised and the $\log$-power is not chased. A $Q^{1/4+\varepsilon}$ error is expected on square-free-counting grounds — **from memory, unverified, and not used**. |
| DE6 | True order of $\sup_n|\tilde\varepsilon_Q|$ inside $[\sqrt{Q},Q]$ | **Open.** Same shape as `E2_PROOF.md` H4. Not needed for anything claimed here; flagged `PROVE` for a future block (Halász/large-sieve input). |
| DE7 | §5 table (exact $W(Q)$ at four $Q$; $C_Q$ cross-check) | **Exact rational arithmetic**, licensed as checking a derivation. Reproduces `LENS_NUMERICS.md`'s published $C_Q$ column to all printed digits, which is what identifies the two objects. No constant was fitted anywhere in this note. |
| DE8 | §5's use of Theorem D(a) at $X=10^7$ | **Conditional on (H2)**, window adequacy. Pairwise periods are $\le Q^2\ll X$, so each correlation has converged; the accumulated error is bounded only trivially and is not $o(1)$ at $Q=300$. Stated, not proved. |
| DE9 | §5(iv), the $+0.1$ exponent bias | **Model (H-EV), explicitly not a theorem.** Its proved ingredient is the plateau lower bound $N\ge\delta$ (unit-rate descent of $E$); its unproved ingredient is the expected-maximum curve. Used only to show the residual is of expected size. $\lambda=0.191$ is *read off* the data as a residual, not fitted and not published as a constant. |
| DE10 | Prior art | **Not searched externally** (§8). Four items flagged from memory. No novelty claimed for Lemma B or for the mean-square identity until searched. The *application* — retiring the $Q^{0.6}$ fit and closing triage rank 3 — is new in-corpus regardless. — **PRIOR-ART SWEEP 2026-08-14, extending (not repeating) `cf-tessera`'s 2026-08-14 pass: item (iv) moves NO-MATCH → RESOLVED-FOUND.** The constant $C=\gamma+\sum_p\frac{\log p}{p(p-1)}$ **is** in the literature in exactly that form, as the absolute constant in $\sum_{n\le M,\,(n,q)=1}\frac{\mu^2(n)}{\varphi(n)}=\frac{\varphi(q)}{q}(\log M+C+\sum_{p\mid q}\frac{\log p}{p})+O(2^{\omega(q)}M^{-1/2})$ — arXiv:2603.22124 Prop. A.1, after R. Sitaramachandra Rao (1985); see the fuller record at `COPRIME_MERTENS.md` L3. Query that found it, for the record: *Ward 1927 van Lint Richert sum m≤Y coprime to n mu^2(m)/phi(m) = log Y + C + error asymptotic*. `E2_PROOF.md` Lemma U2's import is therefore **no longer memory-sourced**. Search-summary (śabda) grade — `WebFetch` remains EGRESS_BLOCKED. Items (i)-sawtooth, (ii), and Lemma B stay NO-MATCH; no query beyond `cf-tessera`'s was added for those. |
