# SEED13 — Theorem D‴ rederived from scratch: the modulus is *exact*, and the phase has a next order

*Agent SEED-13, 2026-08-14. Persona lens: rederive it my own way; distrust the
formalism I did not rebuild.*

Object: the pair weight of the sum-spectrum measure,
$$W(\gamma,\gamma')=\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)},\qquad
\rho=\tfrac12+i\gamma,\ \rho'=\tfrac12+i\gamma',\ s=\gamma+\gamma',\ \delta=\gamma-\gamma',\ p=\gamma/s .$$

`BLOCKS.md` §2 states
$W=\sqrt{2\pi}\,s^{-5/2}e^{-i(sH(p)+5\pi/4)}\bigl(1+O(1/\min(\gamma,\gamma'))\bigr)$
for same-sign ordinates, $H$ the natural-log binary entropy.

**Verdict: the leading law is right — $\sqrt{2\pi}$, $s^{-5/2}$, $-sH(p)$, $-5\pi/4$, all
confirmed independently below. The error term is not.** The modulus is not an
asymptotic statement at all; it has a closed form valid for every real pair,
both signs, with no error term whatsoever. And the phase error is not merely
$O(1/\min(\gamma,\gamma'))$: its leading coefficient is explicit and depends on the
splitting $p$.

---

## 1. The modulus: an exact identity, no Stirling

Two reflection identities, not asymptotics:
$$|\Gamma(\tfrac12+it)|^2=\frac{\pi}{\cosh \pi t},\qquad |\Gamma(it)|^2=\frac{\pi}{t\sinh \pi t}.$$
Peel the denominator by the functional equation, exactly:
$$\Gamma(3+is)=(2+is)(1+is)(is)\,\Gamma(is)
\ \Longrightarrow\ |\Gamma(3+is)|^2=\frac{\pi\,s\,(1+s^2)(4+s^2)}{\sinh \pi s}.$$
Divide, and use $\cosh\pi\gamma\cosh\pi\gamma'=\tfrac12(\cosh\pi s+\cosh\pi\delta)$:

> **Lemma 1 (exact modulus).** For all real $\gamma,\gamma'$ with $s=\gamma+\gamma'\neq0$,
> $$\boxed{\ |W(\gamma,\gamma')|^{2}=\frac{2\pi\,\sinh(\pi s)}{s\,(1+s^{2})(4+s^{2})\,\bigl(\cosh \pi s+\cosh \pi \delta\bigr)}\ }$$
> No error term. No hypothesis on the sign of $\gamma'$, no largeness of $\gamma$.

Three consequences, none of which the corpus statement carries.

**(a) The relative error is $O(s^{-2})$, not $O(1/\min(\gamma,\gamma'))$.** For same-sign
pairs $\cosh\pi\delta/\cosh\pi s = 2e^{-2\pi\min(\gamma,\gamma')}(1+\cdots)$ and
$\tanh\pi s=1-2e^{-2\pi s}+\cdots$, so
$$\frac{|W|}{\sqrt{2\pi}\,s^{-5/2}}
=\Bigl[(1+s^{-2})(1+4s^{-2})\Bigr]^{-1/2}\Bigl(1+O(e^{-2\pi\min(\gamma,\gamma')})\Bigr)
=1-\frac{5}{2s^{2}}+\frac{59}{8s^{4}}+O(s^{-6}).$$
The stated $O(1/\min(\gamma,\gamma'))$ is off by a factor $\asymp s^{2}/\min(\gamma,\gamma')$ —
at the first zero pair ($s\approx28$) it predicts an error near $7\%$ where the
truth is $0.32\%$, and the algebraic part of the deviation is *entirely* the
polynomial $(1+s^{-2})(1+4s^{-2})$, i.e. the two poles $\rho+\rho'\in\{1,2\}$ hiding
in the "+2" of $\Gamma(\rho+\rho'+2)$. Everything else is exponentially small.
This is precisely the CLAUDE.md failure mode: a stated error term without its
$s$-dependence looked like knowledge and was two orders too weak.

**(b) The same-sign hypothesis is unnecessary — and now quantified.** For an
opposite-sign pair, $|\delta|\gg s$, so $\cosh\pi\delta$ dominates and
$$|W|^{2}\;\sim\;\frac{4\pi\sinh(\pi s)}{s(1+s^2)(4+s^2)}\,e^{-\pi|\delta|}
\;=\;\text{(same-sign value)}\times O\!\bigl(e^{-\pi(|\delta|-s)}\bigr).$$
Since $\zeta$'s zeros are symmetric, $|\delta|-s=2\min(|\gamma|,|\gamma'|)\geq 2\gamma_1\approx 28.27$:
opposite-sign atoms are suppressed by $e^{-2\pi\gamma_1}<10^{-38}$. The corpus
*restricts* to same-sign pairs; Lemma 1 *proves* the restriction costs nothing,
which is what a Krein-positivity argument over the full measure actually needs.

**(c) It is elementary.** No Stirling, no saddle point. The exponential
cancellation the corpus calls "exact" is the identity $\cosh\pi\gamma\cosh\pi\gamma'
\cdot 2/(\cosh\pi s+\cosh\pi\delta)=1$, i.e. a product-to-sum formula. The
$\sqrt{2\pi}$ that looks like a Gaussian constant is $\sqrt{2\pi}=\sqrt{2\cdot\pi}$
from $\tfrac12(\cdots)$ and the reflection $\pi$. It was never a saddle.

## 2. The phase: Stirling, done once, in general

I did not want three separate Stirling computations, so I did one. For $z=a+is$,
$a$ fixed, $s\to+\infty$: $\log z=\log|z|+i\arg z$ with $\log|z|=\log s+\frac{a^{2}}{2s^{2}}+O(s^{-4})$
and $\arg z=\frac{\pi}{2}-\frac{a}{s}+\frac{a^{3}}{3s^{3}}+O(s^{-5})$. Take the imaginary part of
$\log\Gamma(z)=(z-\tfrac12)\log z-z+\tfrac12\log2\pi+\tfrac1{12z}+O(z^{-3})$:

> **Lemma 2 (phase of $\Gamma$ on a vertical line).**
> $$\arg\Gamma(a+is)=s\log s-s+\Bigl(a-\tfrac12\Bigr)\frac{\pi}{2}
> +\frac{1}{s}\Bigl(-\frac{a^{2}}{2}+\frac{a}{2}-\frac{1}{12}\Bigr)+O(s^{-3}).$$
> There is no $s^{-2}$ term: every contribution is odd in $1/s$.

This unifies the corpus's two separate assertions into one line and explains
both constants at once: the phase constant is $(a-\tfrac12)\pi/2$.
- $a=\tfrac12$: constant $=0$. That is the corpus's "$\rho-\tfrac12=i\gamma$ exactly, so no
  $\pi/4$-type constant survives" — correct, and now seen to be the *only* value
  of $a$ for which it happens.
- $a=3$: constant $=\tfrac{5\pi}{4}$. The $5\pi/4$ is $\tfrac52\cdot\tfrac\pi2$, and the $\tfrac52$ is
  $(\rho+\rho'+2)-\tfrac12$. It is a shift artifact of the "+2", nothing more.

Now assemble. $\arg W=\arg\Gamma(\tfrac12+i\gamma)+\arg\Gamma(\tfrac12+i\gamma')-\arg\Gamma(3+is)$.
Lemma 2 at $a=\tfrac12$ gives coefficient $-\tfrac18+\tfrac14-\tfrac1{12}=+\tfrac1{24}$;
at $a=3$ it gives $-\tfrac92+\tfrac32-\tfrac1{12}=-\tfrac{37}{12}$. The leading terms:
$$\gamma\log\gamma+\gamma'\log\gamma'-s\log s = s\bigl[p\log p+(1-p)\log(1-p)\bigr]=-sH(p),$$
and $-\gamma-\gamma'+s=0$. Hence

> **Theorem D‴⁺ (sharpened phase).** For same-sign ordinates, with $p=\gamma/s$,
> $$\boxed{\ \arg W=-\Bigl(sH(p)+\frac{5\pi}{4}\Bigr)+\frac{1}{s}\Bigl(\frac{37}{12}+\frac{1}{24\,p(1-p)}\Bigr)+O(s^{-3})\ }$$
> using $\frac1\gamma+\frac1{\gamma'}=\frac{1}{s\,p(1-p)}$. At the balanced splitting $p=\tfrac12$ the
> correction is exactly $\dfrac{13}{4s}$.

The corpus's $O(1/\min(\gamma,\gamma'))$ is the right *order* here (it blows up as
$p\to0$, which $1/(24p(1-p)s)=1/(24\gamma(1-p))$ reproduces), but the shape is now
explicit: the phase correction is itself a function of the splitting, a second,
subleading "entropy-like" term $\frac{1}{24}\bigl(\frac1p+\frac1{1-p}\bigr)$ sitting on top of $H(p)$.

**Combined statement.** Writing the two together to consistent order,
$$W=\sqrt{2\pi}\,s^{-5/2}\,e^{-i(sH(p)+5\pi/4)}
\left[1+\frac{i}{s}\Bigl(\frac{37}{12}+\frac{1}{24p(1-p)}\Bigr)-\frac{5}{2s^{2}}+O(s^{-3})\right],$$
with the modulus factor being exactly $[(1+s^{-2})(1+4s^{-2})]^{-1/2}$ up to $e^{-2\pi\min(\gamma,\gamma')}$.

## 3. What my route gives that theirs does not

1. **An exact closed form for $|W|$** (Lemma 1) — a theorem, not an asymptotic;
   no error analysis to omit.
2. **A corrected error order for the modulus**: $O(s^{-2})$, with the exact
   coefficient $-5/2$, replacing $O(1/\min(\gamma,\gamma'))$.
3. **A weaker hypothesis**: the same-sign restriction is discharged, with the
   opposite-sign suppression bounded by $e^{-2\pi\gamma_1}$.
4. **A generalization** (Lemma 2): the phase constant of $\Gamma(a+is)$ is
   $(a-\tfrac12)\pi/2$ for every $a$. The corpus's $0$ and $5\pi/4$ are the $a=\tfrac12,3$
   cases; a $k$-body weight $\Gamma(\rho_1)\cdots\Gamma(\rho_k)/\Gamma(\sum\rho_i+2)$ has denominator
   $a=k/2+2$, so its constant is $(k+3)\pi/4$ and its modulus exponent is
   $-(k/2+3/2)-\ldots$ — the $k=2$ case reproducing $5\pi/4$ and $s^{-5/2}$.
   `FAMILY.md`'s Theorem D‴-$k$ should be checked against $(k+3)\pi/4$.
5. **A next order for the phase**, absent upstream, which is what any
   quantitative use of the chirp law (`FRESNEL.md`'s stationary-phase step) needs.

Nothing here contradicts the leading law. The divergence is entirely in the
error term, and it is the kind CLAUDE.md was written about.

## 4. Brahmagupta and Bhāskara II, stated precisely (the corpus never has)

Asked for, and honestly only obliquely relevant — I state them because they are
nowhere in the corpus and because §1 is an instance of their discipline.

**Brahmagupta's composition law (samāsa-bhāvanā, *Brāhmasphuṭasiddhānta* XVIII, 628 CE).**
The form $x^{2}-Ny^{2}$ is multiplicative on its values:
$$(x_1^{2}-Ny_1^{2})(x_2^{2}-Ny_2^{2})=(x_1x_2+Ny_1y_2)^{2}-N(x_1y_2+x_2y_1)^{2},$$
with the conjugate (antara-bhāvanā) variant $(x_1x_2-Ny_1y_2)^2-N(x_1y_2-x_2y_1)^2$.
So triples $(x,y;k)$ with $x^{2}-Ny^{2}=k$ compose: $(x_1,y_1;k_1)\ast(x_2,y_2;k_2)=(x_1x_2+Ny_1y_2,\;x_1y_2+x_2y_1;\;k_1k_2)$.
It is exactly the norm form of $\mathbb{Z}[\sqrt N]$ being multiplicative; Brahmagupta
had it as an identity nine centuries before the ring.

**Bhāskara II's chakravala, cycling the defect (*Bījagaṇita*, 1150 CE).**
Given a triple $(x,y;k)$, $\gcd(x,y)=1$, choose an integer $m$ with
$$x+my\equiv 0 \pmod{|k|}$$
and, among those, $|m^{2}-N|$ minimal. Compose with the trivial triple $(m,1;m^{2}-N)$
and divide through by $|k|$:
$$x'=\frac{xm+Ny}{|k|},\qquad y'=\frac{x+ym}{|k|},\qquad k'=\frac{m^{2}-N}{k}.$$
All three are integers, and $x'^{2}-Ny'^{2}=k'$. Iterating, $|k|$ strictly decreases
into the reachable set $\{\pm1,\pm2,\pm4\}$, from which one further composition of
the triple with itself yields $k=1$ — the Pell solution, in $O(\log N)$-ish steps
rather than the full continued-fraction period.

**The relevance, stated honestly.** No, $W$ is not a Pell form and I will not
pretend otherwise. What transfers is method, and it is exactly what §1 did:
the corpus carried a *defect* — the unanalysed $O(1/\min(\gamma,\gamma'))$ — through
fifteen notes. Chakravala's move is not to bound the defect but to compose the
approximate object with an exactly-known one ($(m,1;m^{2}-N)$) so the defect
divides out. Lemma 1 is the same move: compose $\Gamma(3+is)$ with the exactly-known
$(2+is)(1+is)(is)$ so the transcendental part cancels against the reflection
formula, and the defect becomes the *rational* factor $(1+s^{-2})(1+4s^{-2})$ —
finite, exact, and gone. Bhāvanā is what makes it work in both cases: an exact
multiplicative identity applied to an inexact input.

(And Bhartṛhari, one line, since it was in the draw: the exact $|W|^{2}$ is the
sphoṭa — the meaning-bearing unit, indivisible. The asymptotic series
$1-\tfrac5{2s^2}+\tfrac{59}{8s^4}-\cdots$ is the sequence of phonemes: it points at the
unit, is not the unit, and can be truncated wrongly. The corpus truncated it wrongly.)

## 5. Queue

- `PROVE` — check `FAMILY.md` Theorem D‴-$k$ against Lemma 2's $(a-\tfrac12)\pi/2$ with
  $a=k/2+2$, i.e. predicted constant $(k+3)\pi/4$ (so $5\pi/4,\,3\pi/2,\,7\pi/4$ at $k=2,3,4$),
  and against the exact-modulus method (the $k$-fold product of $\pi/\cosh$'s and one
  $\pi/(s\sinh)$ gives an exact $|W_k|^2$ the same way).
- `PROVE` — propagate the corrected error term into `FRESNEL.md` §, whose
  stationary-phase step consumes D‴'s remainder.
- No experiment is proposed. Nothing above needs one.
