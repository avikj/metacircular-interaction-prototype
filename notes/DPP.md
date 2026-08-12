# Theorem D″ resolved: proved where it was conditional, and a no-go where it was hoped

Adversarial prover, working from `APPENDIX_D.md` and `BLOCKS.md` §3 under the
proof-only protocol. Under RH throughout; $W(\gamma,\gamma')=\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$,
$s=\gamma+\gamma'$; $\nu=\sum W\delta_s$, $\widetilde m(f)=\nu(\{f\})$,
$A=\hat\nu$, $D$ = the trivial diagonal.

## 1. The weight law becomes an exact identity

**Lemma 1.** $\displaystyle |W(a,b)|^2=\frac{\pi\sinh(\pi s)}{s\,\cosh(\pi a)\cosh(\pi b)\,(4+s^2)(1+s^2)}$ — exact,
elementary, no Stirling and no error term. (From $|\Gamma(\tfrac12+ia)|^2=\pi/\cosh\pi a$ and
$|\Gamma(1+is)|^2=\pi s/\sinh\pi s$.)

**Theorem 1 (D‴ sharpened to a one-sided inequality).** For same-sign pairs,
$$|W|\le\sqrt{2\pi}\,s^{-5/2}\ \textbf{ for every pair, unconditionally},\qquad
|W|^2=2\pi s^{-5}(1+\theta),\ -0.0063\le\theta\le0 .$$
The relative error is $-\tfrac52s^{-2}$, **one-sided**, not $O(1/\min\gamma)$.

*This derives another measured constant.* At the bottom atom $s=2\gamma_1$ the
predicted deficit is $\tfrac52/799.16=0.313\%$ — exactly exp12's headline
"max deviation 0.31%". The experiment was measuring $\tfrac52s^{-2}$.

## 2. The limit exists — §D.3–D.4 are replaced, and D.4 was wrong

**Theorem 2.** For every $u_0$ and $L$,
$|V(T,L)-V_\infty|\le\inf_\eta[G(\eta)+4C_0^2/(L\eta)^2]\to0$, where
$V_\infty=\sum_f|\widetilde m(f)|^2$. So $\lim_{L\to\infty}V(T,L)=V_\infty$
**uniformly in $u_0$**, with no separation hypothesis and no $u_0$-averaging.

**Erratum for `APPENDIX_D.md` §D.4.** The $u_0$-averaging step is *invalid as
written*: averaging $e^{i\delta u_0}$ over a unit window multiplies by
$\operatorname{sinc}(\delta/2)$, which damps $|\delta|\ge1$ only by $O(1/\delta)$
— it does not "kill all $|\delta|\ge1$ contributions up to $O(1/L)$". The
conclusion survives because the $\operatorname{sinc}^2(L\delta/2)$ already
present does the work, for each $u_0$ separately.

## 3. The Ω-result is unconditional (it was published as conditional)

**Theorem 3.** Under RH, $V_\infty\ge2(|W(\gamma_1,\gamma_1)|^2+4|W(\gamma_1,\gamma_2)|^2)-10^{-18}
\ge1.62\times10^{-6}$, hence $\limsup_u|A(u)|\ge1.27\times10^{-3}$ and
$\limsup_x|\Delta(x)|/x^2\ge1.27\times10^{-3}$ **under RH alone**.

The mechanism is an *order* argument, not a numerical one: $a+b=2\gamma_1$ with
$a,b\ge\gamma_1$ forces $a=b=\gamma_1$; and no ordinate lies strictly between
$\gamma_1$ and $\gamma_2$, so $a+b=\gamma_1+\gamma_2$ forces $\{a,b\}=\{\gamma_1,\gamma_2\}$.
Those two atoms cannot cancel, and opposite-sign pairs contribute $<10^{-18}$.
`APPENDIX_D.md` §D.5 previously routed this through the unproved
near-diagonal hypothesis; it does not need it.

## 4. $V_\infty\asymp D$ is a theorem; only the constant is open

**Theorem 8.** Under RH, $cD\le V_\infty\le CD$ with explicit absolute
constants. **Theorem 6:** $|V_\infty-D|\le E^\circ(0)$, a sum over *exact*
coincidences, $\le E^\circ_{\le Y}(0)+O(Y^{-2}\log^4 2Y)$. **Theorem 7:** under
RH + **SSH** (distinct unordered pairs of positive ordinates have distinct
sums — implied by LI, far weaker than LI, and *much* weaker than any
pair-correlation input), $V_\infty=D$ exactly, with rate $L^{-2/A}$ under a
quantitative separation QSSH$(A)$.

So the corpus's target splits cleanly: **"$V\asymp$ diagonal" is proved; the
sharp constant 1 is equivalent to simplicity of the sum spectrum.**

## 5. The no-go: asymptotic zero statistics cannot close it

**Proposition 9 (proved, and it is the theorem the corpus wanted).** For
$\eta\ge4/\log T$, the near-diagonal additive energy of critical-line
ordinates satisfies $N_T(\eta)\ll\eta\,T^3\log^4T$ — best possible up to the
constant. Proof: Fejér majorant $\operatorname{sinc}^2$, then the explicit
formula for $F(x)=\sum_\gamma w(\gamma)e^{i\gamma x}$, whose prime-side spikes
are $\gg T^{-1}$ apart in the relevant range, so $\int|F|^4$ integrates
spike-by-spike.

**Theorem 10 (no-go).** Proposition 9 applies only for $T\ge e^{4L}$, whose
total contribution to $E_W(1/L)$ is already $\le Ke^{-8L}(4L)^4$. More
generally, **any** near-diagonal bound valid only for $T\ge T_1$ improves
$E_W(1/L)$ by at most $O(T_1^{-2}\log^4T_1)$, while what must be beaten is
$D\approx6\times10^{-6}$, carried by $T\in[28,300]$. Therefore **no asymptotic
zero-statistics input — zero density, Tao–Trudgian–Yang additive energy,
Montgomery pair correlation, GUE $n$-level correlations — can decide whether
$V_\infty=D$.** All are $T\to\infty$ statements; the quantity is a fixed
convergent sum dominated by the first $\sim10^2$ zeros.

**The irony, recorded.** The corpus expected the exact weight $2\pi s^{-5}$
(D‴) to *unlock* this machinery. It does the opposite: the steep,
exactly-known weight is precisely what concentrates the problem at the bottom
of the spectrum where asymptotics say nothing. A *flatter* weight ($s^{-1}$)
would have made Proposition 9 decisive.

**Two citation corrections.** The TTY reference is a category error twice
over: their additive energy is attached to zeros with $\operatorname{Re}\rho\ge\sigma>\tfrac12$,
a set that is **empty under RH**, and its $\sigma\to\tfrac12^+$ degeneration is
the trivial bound. Strike "the TTY $N^*$ input with weight $2\pi s^{-5}$" from
`METHOD.md` §3 item 5 and `BLOCKS.md` §4 item 2. *(Flagged: rests on
abstract-level reading; arXiv was egress-blocked. Theorem 10 does not depend
on it.)*

**Wiener form of the obstruction.** $E_W(0)=\lim\frac1{2K}\int_{-K}^K|\hat\mu|^2$
with $\hat\mu$ built from $Z(w)=\sum_{\gamma>0}e^{-\gamma w}$ — so the
near-diagonal energy is *equivalent* to knowing Landau-type sums
$\sum_\gamma x^{i\gamma}$ at $x=e^K$, $K\to\infty$: exponentially beyond any
known uniformity. An equivalence, not a lossy bound — which is why the no-go
is structural rather than an artifact of method.

## 6. The rewritten open item

> **D″ residual.** Under RH, $V(T,L)\to V_\infty=\sum_f|\widetilde m(f)|^2$ and
> $V_\infty\asymp D$ unconditionally; $V_\infty=D$ **iff the sum spectrum is
> simple**. Close it by (a) certified interval arithmetic verifying pairwise
> distinctness of pair sums below $Y\approx5\times10^5$ (giving $\varepsilon\approx7\%$;
> $Y\approx10^6$ gives $1\%$) — a finite exhaustive verification, which this
> protocol licenses as proof; or (b) a quantitative separation exponent
> QSSH$(A)$, upgrading convergence to rate $L^{-2/A}$. Asymptotic
> zero-statistics machinery is *provably irrelevant* (Theorem 10).

Honest caveats on route (a): the required precision is set by the minimum gap
among those sums, $\sim10^{-19}$ on Poisson heuristics and **not bounded below
by anything provable**; and the computation is large, though comparable to
published zero-verification efforts. Route (a) is not guaranteed to terminate
if a genuine coincidence exists.
