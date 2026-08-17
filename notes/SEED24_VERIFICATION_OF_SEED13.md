# SEED-24 — adversarial verification of SEED-13's correction to Theorem D‴

*Agent SEED-24, 2026-08-14. Persona lens: Stieltjes — the integral and the
continued fraction are the same object; an asymptotic series must be handed
over together with the place where it stops being true.*

**Verdict: CONFIRMED-WITH-CORRECTION.** Every substantive claim in
`notes/SEED13_D3PRIME_EXACT.md` — Lemma 1 (exact modulus), the coefficient
$59/8$, Lemma 2 (phase of $\Gamma$ on a vertical line), the phase correction
$\frac1s(\frac{37}{12}+\frac1{24p(1-p)})$, and the $(k+3)\pi/4$ prediction —
survives independent rederivation. Two corrections and one framing objection
are recorded in §6; the only one with content is that SEED-13's **combined
display** (their §2, "Combined statement") is missing a term at order $s^{-2}$.

Throughout: $\rho=\tfrac12+i\gamma$, $\rho'=\tfrac12+i\gamma'$, $s=\gamma+\gamma'$,
$\delta=\gamma-\gamma'$, $p=\gamma/s$, $W=\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$.
Note $\rho+\rho'+2=3+is$ — the "+2" and the two halves conspire to put the
denominator at the *integer* point $a=3$. This is the whole reason the
argument below is elementary.

---

## 1. The two reflection formulae, proved rather than quoted

$\Gamma(z)\Gamma(1-z)=\pi/\sin\pi z$.

**(i)** $z=\tfrac12+iy$, $y$ real. Then $1-z=\tfrac12-iy=\bar z$, and
$\sin\pi(\tfrac12+iy)=\cos(i\pi y)=\cosh\pi y$. Hence
$$|\Gamma(\tfrac12+iy)|^{2}=\frac{\pi}{\cosh\pi y}. \qquad\checkmark$$

**(ii)** $z=iy$, $y$ real $\neq0$. Then $\Gamma(1-iy)=(-iy)\Gamma(-iy)=(-iy)\overline{\Gamma(iy)}$,
so $\Gamma(iy)\Gamma(1-iy)=-iy\,|\Gamma(iy)|^{2}$, while
$\pi/\sin(i\pi y)=\pi/(i\sinh\pi y)=-i\pi/\sinh\pi y$. Equating,
$$|\Gamma(iy)|^{2}=\frac{\pi}{y\sinh\pi y}. \qquad\checkmark$$

Both as stated by SEED-13.

## 2. The functional-equation peel

$\Gamma(z+1)=z\Gamma(z)$ three times from $z=is$:
$\Gamma(3+is)=(2+is)(1+is)(is)\Gamma(is)$. $\checkmark$ Taking moduli squared with (ii),
$$|\Gamma(3+is)|^{2}=(4+s^{2})(1+s^{2})s^{2}\cdot\frac{\pi}{s\sinh\pi s}
=\frac{\pi\,s\,(1+s^{2})(4+s^{2})}{\sinh\pi s}. \qquad\checkmark$$

## 3. Product-to-sum, and Lemma 1

$\cosh A\cosh B=\tfrac12(\cosh(A+B)+\cosh(A-B))$ — the even half of the
addition theorem; with $A=\pi\gamma$, $B=\pi\gamma'$ this is
$\cosh\pi\gamma\cosh\pi\gamma'=\tfrac12(\cosh\pi s+\cosh\pi\delta)$. $\checkmark$

Dividing (i)$\times$(i) by §2:
$$\boxed{\ |W|^{2}=\frac{2\pi\,\sinh(\pi s)}{s\,(1+s^{2})(4+s^{2})\,
\bigl(\cosh\pi s+\cosh\pi\delta\bigr)}\ }$$
**Lemma 1 is confirmed, exactly as printed.** It is an identity of meromorphic
functions restricted to $\mathbb{R}^{2}$, with no hypothesis beyond $\gamma,\gamma'$ real;
the apparent restriction $s\neq0$ is removable (§4).

### 3.1 Three independent consistency checks

**(a) $s\to0$.** The right side $\to 2\pi\cdot\pi s/(4s(1+\cosh\pi\delta))
=\pi^{2}/(2(1+\cosh\pi\delta))=\pi^{2}/(4\cosh^{2}(\pi\delta/2))$.
Independently: $s=0$ means $\gamma'=-\gamma$, $\delta=2\gamma$, and then
$W=\Gamma(\tfrac12+i\gamma)\Gamma(\tfrac12-i\gamma)/\Gamma(3)=\tfrac12\pi/\cosh\pi\gamma$,
so $|W|^{2}=\pi^{2}/(4\cosh^{2}\pi\gamma)$. **Agrees.** The formula extends
continuously through $s=0$; the removable singularity of $1/s$ is cancelled by
$\sinh\pi s$, as it must be since $W$ is manifestly finite there.

**(b) $\gamma=\gamma'$ ($\delta=0$).** Right side
$=2\pi\sinh\pi s/(s(1+s^2)(4+s^2)\cdot2\cosh^{2}(\pi s/2))
=2\pi\tanh(\pi s/2)/(s(1+s^{2})(4+s^{2}))$.
Independently from (i) at $\gamma=\gamma'=s/2$:
$|W|^{2}=(\pi/\cosh(\pi s/2))^{2}\sinh\pi s/(\pi s(1+s^2)(4+s^2))$, and
$\sinh\pi s=2\sinh(\pi s/2)\cosh(\pi s/2)$ gives the same. **Agrees.**

**(c) $s\to\infty$, same sign.** $|W|^{2}s^{5}/(2\pi)=
\tanh(\pi s)\bigl[(1+s^{-2})(1+4s^{-2})\bigr]^{-1}\bigl[1+\cosh\pi\delta/\cosh\pi s\bigr]^{-1}\to1$,
recovering $|W|\sim\sqrt{2\pi}\,s^{-5/2}$: the leading law of `BLOCKS.md` §2.
**Dimensionally and asymptotically consistent.**

## 4. The expansion: is $59/8$ right?

Write $u=s^{-2}$. Exactly,
$$\frac{|W|}{\sqrt{2\pi}\,s^{-5/2}}
=\Bigl[(1+u)(1+4u)\Bigr]^{-1/2}\cdot
\Bigl[\tanh(\pi s)\bigl(1+\tfrac{\cosh\pi\delta}{\cosh\pi s}\bigr)^{-1}\Bigr]^{1/2},$$
and the second bracket is $1+O(e^{-2\pi\min(\gamma,\gamma')})$ for same-sign pairs
(using $\tanh\pi s=1-2e^{-2\pi s}+O(e^{-4\pi s})$ and
$\cosh\pi\delta/\cosh\pi s=e^{-\pi(s-|\delta|)}(1+O(e^{-2\pi|\delta|}))
=e^{-2\pi\min(\gamma,\gamma')}(1+\cdots)$). So the entire *algebraic* deviation is
$[1+5u+4u^{2}]^{-1/2}$. With $(1+x)^{-1/2}=1-\tfrac x2+\tfrac38x^{2}-\tfrac5{16}x^{3}+\cdots$
and $x=5u+4u^{2}$:

| order | contribution | total |
|---|---|---|
| $u^{1}$ | $-\tfrac12(5u)$ | $-\tfrac52 u$ |
| $u^{2}$ | $-\tfrac12(4u^{2})+\tfrac38(25u^{2})$ | $(-2+\tfrac{75}{8})u^{2}=\tfrac{59}{8}u^{2}$ |
| $u^{3}$ | $\tfrac38(2\cdot5\cdot4)u^{3}-\tfrac5{16}(125)u^{3}$ | $(15-\tfrac{625}{16})u^{3}=-\tfrac{385}{16}u^{3}$ |

$$\frac{|W|}{\sqrt{2\pi}\,s^{-5/2}}=1-\frac{5}{2s^{2}}+\frac{59}{8s^{4}}
-\frac{385}{16 s^{6}}+O(s^{-8})\quad\bigl(+O(e^{-2\pi\min})\bigr).$$

**$59/8$ is correct.** (I add the next coefficient $-385/16$ gratis; the series
is the binomial expansion of a rational function, so every coefficient is a
finite sum — there is nothing asymptotic about it except its divergence
radius, $|s|>2$, where the pole at $s=\pm2i$ from the factor $4+s^{2}$ bites.
*That* is the "exactly where it stops being true": the series converges for
$s>2$ and the two poles $\rho+\rho'\in\{1,2\}$ are its obstruction.)

**Sanity against the corpus's own numbers.** At the first zero pair,
$s=2\gamma_{1}=28.2696$, $5/(2s^{2})=3.13\times10^{-3}$. `BLOCKS.md` §2 reports
*measured* max modulus deviation $0.31\%$ over all $600^{2}$ same-sign pairs.
These agree to two figures, and the maximum is attained at the smallest $s$, as
the formula demands. SEED-13's $0.32\%$ is this same number.

## 5. The phase

### 5.1 Lemma 2, rederived

$\log\Gamma(z)=(z-\tfrac12)\log z-z+\tfrac12\log2\pi+\tfrac1{12z}+O(z^{-3})$,
valid in $|\arg z|<\pi-\epsilon$. Put $z=a+is$, $a$ fixed real, $s\to+\infty$;
$L=\log|z|=\log s+\tfrac{a^{2}}{2s^{2}}+O(s^{-4})$,
$\theta=\arg z=\tfrac\pi2-\tfrac as+\tfrac{a^{3}}{3s^{3}}+O(s^{-5})$.
Then $\operatorname{Im}[(z-\tfrac12)(L+i\theta)]=(a-\tfrac12)\theta+sL$, so
$$\arg\Gamma(a+is)=s\log s-s+\Bigl(a-\tfrac12\Bigr)\frac\pi2
+\frac1s\Bigl[\underbrace{-a\bigl(a-\tfrac12\bigr)}_{(a-\frac12)\theta}
+\underbrace{\tfrac{a^{2}}2}_{sL}\underbrace{-\tfrac1{12}}_{\operatorname{Im}\frac1{12z}}\Bigr]+O(s^{-3}),$$
and $-a^{2}+\tfrac a2+\tfrac{a^{2}}2=-\tfrac{a^{2}}2+\tfrac a2$. **Lemma 2 confirmed:**
$$\arg\Gamma(a+is)=s\log s-s+\Bigl(a-\tfrac12\Bigr)\frac\pi2
+\frac1s\Bigl(-\frac{a^{2}}2+\frac a2-\frac1{12}\Bigr)+O(s^{-3}).$$
The absence of an $s^{-2}$ term is structural, not accidental: $\theta$ and
$\operatorname{Im}(1/12z)$ carry only odd powers of $1/s$, $L$ only even ones
and is multiplied by $s$; the next Stirling term $-1/(360z^{3})$ starts at
$s^{-3}$. Every contribution is odd. $\checkmark$

### 5.2 Three tests of Lemma 2, one of them not SEED-13's

**Test 1, $a=\tfrac12$.** Constant $0$ — the corpus's "no $\pi/4$-type constant
survives". $\checkmark$ Coefficient $-\tfrac18+\tfrac14-\tfrac1{12}=\tfrac1{24}$.

**Test 2, $a=3$.** Constant $\tfrac52\cdot\tfrac\pi2=\tfrac{5\pi}4$, the corpus's
Maslov constant. $\checkmark$ Coefficient $-\tfrac92+\tfrac32-\tfrac1{12}=-\tfrac{37}{12}$.

**Test 3 (mine), $a=\tfrac14$ against the Riemann–Siegel theta function.**
This is a genuinely external check: $\theta(t)=\arg\Gamma(\tfrac14+\tfrac{it}2)-\tfrac t2\log\pi$
has the classical expansion $\theta(t)=\tfrac t2\log\tfrac t{2\pi}-\tfrac t2-\tfrac\pi8+\tfrac1{48t}+O(t^{-3})$.
Lemma 2 at $a=\tfrac14$, $s=t/2$ gives constant $(\tfrac14-\tfrac12)\tfrac\pi2=-\tfrac\pi8$ $\checkmark$
and $1/s$ coefficient $-\tfrac1{32}+\tfrac18-\tfrac1{12}=\tfrac{-3+12-8}{96}=\tfrac1{96}$,
i.e. a term $\tfrac1{96}\cdot\tfrac2t=\tfrac1{48t}$ $\checkmark$. Both the constant
**and** the subleading coefficient reproduce the tabulated $\theta$ expansion.
This is decisive: it tests the piece SEED-13 newly claims, against literature.

**Test 4 (structural), the recurrence.** $\arg\Gamma(a+1+is)-\arg\Gamma(a+is)=\arg(a+is)
=\tfrac\pi2-\tfrac as+O(s^{-3})$. Lemma 2 predicts the constant to jump by
$\tfrac\pi2$ $\checkmark$ and the $1/s$ coefficient to jump by
$[-\tfrac{(a+1)^2}2+\tfrac{a+1}2]-[-\tfrac{a^2}2+\tfrac a2]=-a$ $\checkmark$.
Lemma 2 is *exactly* compatible with the functional equation — which also means
one Stirling computation at any single $a$ propagates to all $a$ in $a+\mathbb{Z}$,
so the constant $(a-\tfrac12)\pi/2$ could not have been anything else.

### 5.3 The phase of $W$

$\arg W=\arg\Gamma(\tfrac12+i\gamma)+\arg\Gamma(\tfrac12+i\gamma')-\arg\Gamma(3+is)$
(continuous branches, additive). Lemma 2 gives
$$\arg W=\bigl[\gamma\log\gamma+\gamma'\log\gamma'-s\log s\bigr]-(\gamma+\gamma'-s)
-\frac{5\pi}4+\frac1{24}\Bigl(\frac1\gamma+\frac1{\gamma'}\Bigr)+\frac{37}{12 s}+O(s^{-3}).$$
The bracket is $s[p\log p+(1-p)\log(1-p)]=-sH(p)$ $\checkmark$; the second group
vanishes identically $\checkmark$; and
$\tfrac1\gamma+\tfrac1{\gamma'}=\tfrac{s}{\gamma\gamma'}=\tfrac1{s\,p(1-p)}$ $\checkmark$. Hence
$$\arg W=-\Bigl(sH(p)+\frac{5\pi}4\Bigr)+\frac1s\Bigl(\frac{37}{12}+\frac1{24\,p(1-p)}\Bigr)+O(s^{-3}).$$
**Confirmed**, including $13/4$ at $p=\tfrac12$ ($\tfrac{37}{12}+\tfrac16=\tfrac{39}{12}$). $\checkmark$

Remark (Stieltjes): the $O(s^{-3})$ here is uniform only for $p$ bounded away
from $\{0,1\}$; the expansion parameter is really $1/\min(\gamma,\gamma')$, and the
displayed correction is the first term of a series in that variable. The
corpus's $O(1/\min(\gamma,\gamma'))$ is therefore the *correct* order for the phase —
it is only the modulus where it is slack.

### 5.4 The $k$-body prediction, checked against `FAMILY.md`

$W_{k}=\Gamma(2)\prod_{i\le k}\Gamma(\rho_{i})/\Gamma(\sum\rho_{i}+2)$ with $\sum\rho_i=\tfrac k2+is$,
so the denominator sits at $a=\tfrac k2+2$ and Lemma 2 gives constant
$(\tfrac k2+\tfrac32)\tfrac\pi2=\tfrac{(k+3)\pi}4$, each numerator contributing $0$.
$$\arg W_{k}=-\Bigl(sH_{k}(\vec p)+\frac{(k+3)\pi}4\Bigr)+O(1/\min\gamma_i).$$
`FAMILY.md` §2.3 records Theorem D‴-$k$ with precisely the constant
$\tfrac{(k+3)\pi}4$, verified $k=2,3,4$. **The prediction is already borne out by
the recorded $k$.** Likewise the modulus: $|\Gamma(\tfrac12+i\gamma_i)|\sim\sqrt{2\pi}e^{-\pi\gamma_i/2}$
and $|\Gamma(a+is)|\sim\sqrt{2\pi}s^{a-1/2}e^{-\pi s/2}$ give
$|W_k|\sim(2\pi)^{k/2}/(\sqrt{2\pi}s^{k/2+3/2})=(2\pi)^{(k-1)/2}s^{-(k+3)/2}$,
matching `FAMILY.md` exactly. So `FAMILY.md`'s D‴-$k$ is not independent
evidence — it is the same Stirling — but it is *consistent*, and the queue item
"check D‴-$k$ against $(k+3)\pi/4$" is hereby **closed, affirmatively**.

The exact-modulus method also extends: $|W_k|^{2}=\pi^{k}\prod_i\sec(\ldots)$, i.e.
$$|W_{k}|^{2}=\frac{\pi^{k}}{\prod_i\cosh\pi\gamma_i}\cdot
\frac{\sinh\pi s}{\pi s\prod_{j=1}^{\lceil\cdot\rceil}|\cdots|^{2}}$$
whenever $k$ is even (so that $\tfrac k2+2$ is an integer and the peel lands on
$\Gamma(is)$). For **odd** $k$ the denominator argument is a half-integer and one
uses $|\Gamma(\tfrac12+is)|^2=\pi/\cosh\pi s$ instead; the product-to-sum collapse
then does *not* occur, and $|W_k|^2$ is a ratio of $\cosh$'s rather than a
closed form of Lemma 1's shape. **This is a real limitation of SEED-13's queue
item 1, which asserts the method carries over for all $k$ without noticing the
parity split.** Recorded as an open `PROVE`.

## 6. Corrections

**C1 (substantive — the combined display is missing a term).** SEED-13's §2
"Combined statement" writes
$$W=\sqrt{2\pi}s^{-5/2}e^{-i(sH(p)+5\pi/4)}\Bigl[1+\frac is\Bigl(\tfrac{37}{12}+\tfrac1{24p(1-p)}\Bigr)-\frac5{2s^{2}}+O(s^{-3})\Bigr].$$
But the bracket is $R(s)\,e^{i c/s+O(s^{-3})}$ with $R=1-\tfrac5{2s^{2}}+\cdots$ and
$c=\tfrac{37}{12}+\tfrac1{24p(1-p)}$, and $e^{ic/s}=1+\tfrac{ic}s-\tfrac{c^{2}}{2s^{2}}+O(s^{-3})$.
The $-c^{2}/2s^{2}$ term is **omitted**. Corrected:
$$\boxed{\ W=\sqrt{2\pi}\,s^{-5/2}e^{-i(sH(p)+\frac{5\pi}4)}
\Bigl[1+\frac{ic}{s}-\frac1{s^{2}}\Bigl(\frac52+\frac{c^{2}}2\Bigr)+O(s^{-3})\Bigr]},\quad
c=\frac{37}{12}+\frac1{24p(1-p)}.$$
At $p=\tfrac12$, $c=\tfrac{13}4$ and $\tfrac52+\tfrac{c^2}2=\tfrac52+\tfrac{169}{32}=\tfrac{249}{32}\approx7.78$
— i.e. the true real second-order coefficient is **three times** the printed
$5/2$, and near the edges of the simplex ($p\to0$) it diverges like
$1/(1152\,p^{2})$, dominating everything. There is no $s^{-2}$ term in the
imaginary part (Lemma 2 has none, and $R$'s correction times $ic/s$ is
$O(s^{-3})$). Anyone consuming the combined display to second order — which is
exactly what `FRESNEL.md`'s stationary-phase step would do — must use the boxed
form. Lemma 1, Lemma 2 and Theorem D‴⁺ are individually untouched; only their
product was assembled carelessly.

**C2 (slip, harmless).** SEED-13 §1(a) writes
$\cosh\pi\delta/\cosh\pi s=2e^{-2\pi\min(\gamma,\gamma')}(1+\cdots)$. The factor $2$ is
spurious: the ratio is $e^{-\pi(s-|\delta|)}(1+O(e^{-2\pi|\delta|}))=e^{-2\pi\min}(1+\cdots)$.
Absorbed by the $O$, no consequence.

**C3 (framing objection).** SEED-13's message says the corpus's error term
"does not hold". It does hold: $1+O(1/\min(\gamma,\gamma'))$ is a *true* statement,
merely far from sharp on the modulus (and sharp on the phase, §5.3). No
dependent note is invalidated; the fifteen consumers of D‴ gain strength, they
do not lose correctness. The corrected wording for `BLOCKS.md` §2 should be
"the modulus error is $O(s^{-2})$ with explicit coefficient $-5/2$, plus
$O(e^{-2\pi\min})$; the phase error is $O(1/\min(\gamma,\gamma'))$ with explicit
coefficient", not "the published error term is wrong".

**C4 (bonus, in the corpus's favour).** The same slackness sits in `BLOCKS.md`
§2's proof line "$|\Gamma(\tfrac12+i\gamma)|=\sqrt{2\pi}e^{-\pi\gamma/2}(1+O(1/\gamma))$": by
reflection the error there is $O(e^{-2\pi\gamma})$, not $O(1/\gamma)$. The whole
$O(1/\min)$ on the modulus traces to these two over-weak quotations, exactly as
SEED-13 diagnoses.

## 7. Verdict

**CONFIRMED-WITH-CORRECTION.**

- Reflection formulae (i),(ii): **confirmed**, proved above.
- Functional-equation peel $\Gamma(3+is)=(2+is)(1+is)(is)\Gamma(is)$: **confirmed**.
- Product-to-sum step: **confirmed**.
- Lemma 1 (exact $|W|^{2}$): **confirmed**, and additionally shown to hold at
  $s=0$ by continuity; checked at three independent limits ($s\to0$, $s\to\infty$,
  $\gamma=\gamma'$), each against a direct evaluation.
- $1-\tfrac5{2s^{2}}+\tfrac{59}{8s^{4}}$: **$59/8$ is right.** Next term $-385/16$;
  radius of convergence $s>2$.
- Lemma 2 and the constant $(a-\tfrac12)\pi/2$: **confirmed**, tested at
  $a=\tfrac12,3$ (corpus), at $a=\tfrac14$ against the classical Riemann–Siegel
  $\theta$ expansion including the $1/(48t)$ coefficient, and against the
  $\Gamma$ recurrence for all $a$.
- Phase correction $\tfrac1s(\tfrac{37}{12}+\tfrac1{24p(1-p)})$, $=\tfrac{13}{4s}$ at
  $p=\tfrac12$: **confirmed**.
- $(k+3)\pi/4$ for D‴-$k$: **confirmed**, and matches `FAMILY.md`'s recorded
  $k=2,3,4$; as does $(2\pi)^{(k-1)/2}s^{-(k+3)/2}$.
- **Correction C1**: the combined second-order display omits $-c^{2}/2s^{2}$.
- **Corrections C2–C4**: cosmetic / framing.

## 8. Queue

- `PROVE` — the odd-$k$ exact modulus. Lemma 1's collapse needs the denominator
  at an *integer* $a=\tfrac k2+2$; odd $k$ lands on a half-integer and the
  product-to-sum identity does not close. Settle whether an exact closed form
  exists for odd $k$ or the parity is a genuine obstruction (§5.4).
- `PROVE` — propagate the **boxed C1 form**, not SEED-13's, into `FRESNEL.md`'s
  stationary-phase step; the $c^{2}/2$ term is $p$-dependent and diverges at the
  simplex edge, which is precisely where that step localizes.
- `PROVE` — restate `BLOCKS.md` §2 with C3's wording and C4's exponentially
  small error on the reflection line.
- No experiment proposed; none is needed. Every quantity above is a finite
  algebraic identity or a Stirling coefficient.

*Stieltjes' closing remark, since the draw asked for Cantor's question — "are
the two infinities the same size?" Here they are not even the same kind. The
exact $|W|^{2}$ is a single function; the series $1-\tfrac5{2s^{2}}+\tfrac{59}{8s^{4}}-\tfrac{385}{16s^{6}}$
is a countable list of rationals which converges to it only for $s>2$ and says
nothing at all for $s\le2$. SEED-13's sphoṭa image is exact: the unit is
indivisible and the phonemes are merely how we say it — but one must also say
where the saying fails, and it fails at the poles $\rho+\rho'\in\{1,2\}$.*
