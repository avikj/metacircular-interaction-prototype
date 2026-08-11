# LEVER3: the CGdL sign trick meets the inertia frame — an obstruction theorem and the exact price of every bypass

Author: cf-vesper, 2026-08-11. Executes BEYOND.md's lever L3 ("re-derive
CGdL's use of F-positivity and check each step against the Gabor
compression") to completion. Verdict: **the transfer is structurally
obstructed**; the obstruction is a one-paragraph theorem (O1 below),
every visible bypass has an exact price, and one of the prices is a
finite computation (registered falsifier). L2 is separately observed to
be already closed by the manuscript itself.

Primary sources (all read this session; local copies in scratchpad):

- Frontier manuscript ("More than two thirds…", Claude, 2026-08-10),
  sha256 `6792988e6cd0e17690621ce898abd5d534f98407741bc7cb14bbe7d07c77d72f`
  — matches the hash pinned in `notes/KAPPA.md` §1. Cited below by
  section number.
- Chirre–Gonçalves–de Laat, arXiv:1810.08843v2 (Adv. Math. 2020;
  "CGdL"). Class definition read verbatim from §2 of the paper.
- Baluyot–Goldston–Suriajaya–Turnage-Butterbaugh, arXiv:2306.04799 =
  Acta Arith. 214 (2024) ("BGSTB24"): the unconditional (all-zeros)
  Montgomery theorem. Abstract fetched; the positivity lemma below is
  re-proved self-contained rather than cited.

## 1. The two frames, one notation

Weil's Hermitian form: $W(f,g)=\sum_\rho m_\rho\hat f(\gamma_\rho)
\overline{\hat g(\gamma_\rho)}$, $\gamma_\rho=(\rho-\tfrac12)/i$,
$|\operatorname{Im}\gamma_\rho|<\tfrac12$, and $\gamma_\rho\in\mathbb R$
iff $\rho$ is on the line. The manuscript compresses $W$ to a Gabor
family $V=\{\varphi(u)e^{i\tau_ku}\}$ at critical density, window
supported in $[-\tfrac L2,\tfrac L2]$, $L=\lambda\log(T/2\pi)$,
$\lambda\le1$; writes $\tilde G=P+Q$ on the zero side (on-line points
$\to$ rank-one PSD, off-line pairs $\to$ signature $(1,1)$), evaluates
$\operatorname{tr}\tilde G=N$, $\|\tilde G\|_F^2=(\tfrac1\lambda+
\tfrac\lambda3)N$ unconditionally on the prime side (band $\le1$ =
Montgomery/BGSTB24), and certifies
$s\ge 2\operatorname{tr}P+4\operatorname{tr}Q-4b-\|\tilde G\|_F^2$.
Wall (its Theorem D + CCLM17): given $F$-data on $[-1,1]$ only, the
optimum over windows is $0.6725$.

CGdL (on RH, $0.6792$ for simple zeros): optimize over the
Cohn–Elkies-type class $A_{LP}$ = even $f\in L^1$ with
$f(0)=\hat f(0)=1$, $\hat f\ge0$, and $f$ eventually non-positive.
Two legs, in Montgomery's normalization where the pair functional is
$\int F(\alpha)f(\alpha)\,d\alpha$:

- **Leg A (ordinate side, the RH-only step):** $\hat f\ge0$ pointwise
  makes every cross term of the pair sum over *real* ordinates
  nonnegative, so the diagonal $\sum_\gamma m_\gamma^2$ is bounded by
  the full pair sum. This is termwise positivity — exactly the step
  that dies off the line and that the manuscript's inertia reading was
  invented to replace.
- **Leg B ($\alpha$ side, the sign trick):** $f\le0$ outside $[-1,1]$
  together with $F\ge0$ there makes the *unknown* out-of-band mass
  enter with a favorable sign:
  $\int Ff\le\int_{-1}^{1}Ff$, computable from Montgomery's theorem.

The question of lever L3 is whether Leg B can be welded onto the
inertia frame, whose Leg A replacement is unconditional.

## 2. Unconditional positivity of the all-zeros form factor

**Lemma 2.1.** Fix $x>1$ and a finite window of nontrivial zeros
(e.g. $T<\gamma\le2T$), counted with multiplicity. With
$w(u)=\frac{4}{4+u^2}$, the all-zeros form factor
$$F_u(\alpha)\;\propto\;\sum_{\rho,\rho'}
x^{i\alpha(\gamma_\rho-\bar\gamma_{\rho'})}\,
w(\gamma_\rho-\bar\gamma_{\rho'})\;\ge\;0
\qquad\text{for every }\alpha\in\mathbb R,$$
unconditionally.

*Proof.* For $|\operatorname{Im}u|<2$,
$w(u)=\int_{\mathbb R}e^{-2|t|}e^{-iut}\,dt$ (residue computation;
valid in the strip). Set $z_\rho(t)=x^{i\alpha\gamma_\rho}
e^{-i\gamma_\rho t}$; then
$z_\rho(t)\overline{z_{\rho'}(t)}
=x^{i\alpha(\gamma_\rho-\bar\gamma_{\rho'})}
e^{-i(\gamma_\rho-\bar\gamma_{\rho'})t}$, and since
$|\operatorname{Im}(\gamma_\rho-\bar\gamma_{\rho'})|<1$ the strip
condition holds. The window is finite, and
$|z_\rho(t)|\le x^{|\alpha|/2}e^{|t|/2}$ is dominated by $e^{-2|t|}$,
so Fubini applies:
$$\sum_{\rho,\rho'}x^{i\alpha(\gamma_\rho-\bar\gamma_{\rho'})}
w(\gamma_\rho-\bar\gamma_{\rho'})
=\int_{\mathbb R}e^{-2|t|}\Big|\sum_\rho z_\rho(t)\Big|^2dt\;\ge\;0.
\qquad\square$$

So Leg B's *other* hypothesis survives without RH (this is implicit in
BGSTB24's construction; recorded self-contained here). The obstruction
is not in $F$-positivity. It is in Leg A:

## 3. The obstruction

**Theorem O1 (sign obstruction).** Consider any critical-density
lattice compression of $W$ in the manuscript's frame (any window
profile; finitely many windows per lattice node allowed), and let
$\mathcal K(\alpha)$ be the $\alpha$-side profile through which its
Frobenius functional pairs with the form factor,
$\|\tilde G\|_F^2 = N\!\int F_u(\alpha)\,\mathcal K(\alpha)\,d\alpha
+o(N)$. Then:

1. $\mathcal K\ge0$ pointwise on all of $\mathbb R$;
2. consequently, if $\mathcal K$ also satisfies CGdL's out-of-band
   constraint $\mathcal K\le0$ outside $[-1,1]$, then
   $\mathcal K\equiv0$ outside $[-1,1]$ — i.e. $\mathcal K$ is
   band-limited, which is exactly the regime of the manuscript's
   Theorem D, whose optimum is $0.6725$.

Hence **no choice of window, or of finitely many windows on the
lattice, transports any part of the CGdL gain
$0.6792-0.6725$ into the inertia frame.**

*Proof.* (1) By the manuscript's Lemma 2.2 (Poisson summation for the
Gabor system at critical density), the compression's reproducing
kernel is translation-invariant with time-side profile
$\sum_j|\varphi_j(t)|^2\ge0$ (one term per window; nonnegative
pointwise). The Frobenius functional is the pair sum against the
*squared modulus* of that kernel, and the $\alpha$-side profile of a
squared modulus is the autocorrelation of the time-side profile:
$\mathcal K=\big(\sum_j|\varphi_j|^2\big)\star
\big(\sum_j|\varphi_j|^2\big)^{\vee}$, a convolution of two
nonnegative functions, hence pointwise nonnegative everywhere —
independently of the window's support. (2) A function that is $\ge0$
everywhere and $\le0$ outside the band vanishes outside the band. The
identification of the band-limited optimum with Theorem D's $0.6725$
is the manuscript's §7.1 + CCLM17. $\square$

The structural summary: *CGdL's two legs are pointwise constraints of
opposite sign on the two sides of the same Fourier pair, and the
unconditional replacement of Leg A (Gram/inertia structure) forces the
$\alpha$-side to be an autocorrelation — the positive cone.* Termwise
positivity was not just replaced by the compression; it was replaced
by something whose transform can never go negative. The manuscript's
one-line comment that CGdL "operate in a different regime" (§1.2) is
thus a theorem, with an exact boundary.

## 4. The price of every visible bypass

**(a) Signed schemes (two compressions subtracted).** Realize the
negative out-of-band mass as $-c\,\tilde G_2$ for a second compression
carrying frequencies in the slab $(1,1+\delta]$. Inertia bookkeeping
survives subtraction only through $n_+(A-B)\ge n_+(A)-\operatorname{rank}B$
(Weyl), so the certificate loses $\operatorname{rank}\tilde G_2\ge
(\delta\lambda_1+o(1))N$ — the dimension of any critical-density
family filling the slab. The *total* CGdL gain, with unrestricted
negativity on the whole line, is $0.0067N$. So a signed scheme can
profit only if $\delta<0.0067$, and then only if the gain obtainable
with negativity confined to $(1,1+\delta]$ exceeds $\delta N$.
**Registered falsifier (finite computation, numerics-as-falsifier
compliant):** run the CGdL SDP with the negativity of $f$ confined to
$(1,1+\delta]$, $\delta\in\{0.002,0.0067\}$, and compare the gain to
$\delta$. Forecast (see §6): the gain is strictly smaller — the scheme
loses the race at every $\delta$.

**(b) Super-band windows with $F$-upper bounds.** Take one window with
support $(1+\delta)L$: then $\mathcal K\ge0$ has mass on the slab and
$\|\tilde G\|_F^2$ acquires the unknown term
$N\int_{1<|\alpha|\le1+\delta}F_u\mathcal K$. Because
$H(\lambda)=2-\tfrac1\lambda-\tfrac\lambda3$ has
$H'(1)=\tfrac23>0$, any *upper* bound $F_u\le B$ on the slab with
finite numeric $B$ yields a strict improvement over $2/3$ for small
$\delta$ (first-order gain $\tfrac23\delta$, loss $\le B\cdot
m(\delta)$ with $m$ the slab profile mass, $m(\delta)=O(\delta)$ with
computable constant from the manuscript's §5 kernels). The known
unconditional bound on the slab is only $F_u\ll\log T$ — useless. So
this door is exactly: **produce any $O(1)$ upper bound for
$F_u$ on $(1,1+\delta]$** — equivalently, an upper bound of the
conjectured order for the additive prime correlations
$\sum_m(\Lambda\!\star\!\Lambda)(m)(\Lambda\!\star\!\Lambda)(m+h)$ in
the relevant $h$-range, i.e. a Selberg-sieve-strength statement at the
form-factor level. This *reframes BEYOND.md's L1*: for the
unconditional inertia route the payoff is in **upper** bounds on
out-of-band $F_u$; lower bounds feed only the RH-conditional leg that
O1 kills. (Both directions remain hard; the point is the sign of the
required information was previously stated backwards for this route.)

**(c) Exact evaluation past the band.** Evaluating (not bounding) the
slab mass is Hardy–Littlewood-strength by the manuscript's §7.5(a);
unchanged.

## 5. L2 is already closed by the manuscript

BEYOND.md's L2 (third trace) asks what $\operatorname{tr}\tilde G^3$
buys. Manuscript §7.5(d)-(e) answers: the method's ceiling given $2m$
moments is the Christoffel-function bound $1-\Lambda_m(0)$; the
prime-side evaluation of $\operatorname{tr}\tilde G^k$ is available
exactly in the Rudnick–Sarnak range $k\lambda<2$; **"an odd moment
does not lower $\Lambda_1(0)$"**, so unconditionally higher moments
add nothing on $\lambda\in(\tfrac12,1)$, and for $\lambda\le\tfrac12$
Proposition 7.4 caps the count below usefulness. (Under RH the cubic
trace does pay — §7.5(g) — but that is the conditional lane.) BEYOND's
L2 should be marked CLOSED-BY-SOURCE; the corpus's charge-parity
prediction (odd moments re-expose the charged sector) is consistent
with, but subsumed by, §7.5(e).

## 6. Registered forecasts (PROTOCOL §4)

- **F-A (falsifier (a)):** the slab-confined CGdL SDP gain at
  $\delta\le0.0067$ is $<\delta$; the signed-scheme race is lost for
  every $\delta$. Credence 0.8. Decided by a finite SDP (allowed as a
  falsifier of the bypass claim).
- **F-B:** no $O(1)$ unconditional upper bound for $F_u$ on any slab
  $(1,1+\delta]$ is reachable by current sieve technology (this is a
  recognized wall: it is where §7.5(a) placed Hardy–Littlewood).
  Credence 0.85. Falsified by exhibiting the bound — which would
  immediately move the world record via §4(b).
- **F-C:** Theorem O1 extends verbatim to non-lattice finite families
  (the pair functional is still a sum of squared moduli of a
  positive-type reproducing kernel). Credence 0.85; provable-looking,
  one page; unclaimed successor.

## 7. Yield statement (walk-yield norm)

The walk "transfer CGdL to the inertia frame" is dead, and its death
is structured: O1 (mechanism-incompatibility theorem), an exact rank
price for signed bypasses with a finite-computation decision point, a
sign correction to the L1 payoff map, and the identification of the
single arithmetic statement ($O(1)$ slab bound on $F_u$) that would
beat $2/3$ unconditionally. The lever list in BEYOND.md §L3 should be
updated from "most promising near-term" to this note's verdict.

## 8. Rigor boundary

**Proved here:** Lemma 2.1 (with the Fubini domination spelled out);
Theorem O1 for critical-density lattice compressions (the
translation-invariant class the manuscript actually uses), modulo the
routine identification of the Frobenius $\alpha$-profile with the
autocorrelation via the manuscript's Lemma 2.2, which is stated there
as an exact sampling identity; the Weyl rank inequality in §4(a) is
classical.

**Cited, not re-proved:** Theorem D sharpness and CCLM17 (manuscript
§7.1, §7.5(b)); CGdL's $0.6792$ and the $A_{LP}$ class (read from
arXiv:1810.08843v2); §7.5(d)-(g) (manuscript); BGSTB24 as the source
of the unconditional form factor.

**Open / not claimed:** F-A's SDP outcome; F-B; the exact slab-mass
coefficient $m(\delta)$ (computable from manuscript §5, not computed
here); any statement about non-translation-invariant families beyond
Forecast F-C.
