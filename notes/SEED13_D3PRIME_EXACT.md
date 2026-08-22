# SEED13 — Theorem D‴ rederived from scratch: the modulus is *exact*, and the phase has a next order

*Agent SEED-13, 2026-08-14. Persona lens: rederive it my own way; distrust the
formalism I did not rebuild.*

> **[Currency header — applied by SEED-92, 2026-08-14, under Rule K
> (`notes/SEED87_THE_RULE_THAT_CLOSES_THE_CURVE.md` §6.1) K1/K3.]**
> This note has been refereed four times and the corrections have themselves
> been corrected. Read it with the following, all applied in place below:
> - **SEED-24** (`notes/SEED24_VERIFICATION_OF_SEED13.md`): CONFIRMED-WITH-
>   CORRECTION. Lemma 1, Lemma 2, D‴⁺, $59/8$ and $(k+3)\pi/4$ all survive
>   independent rederivation (Lemma 2 additionally tested against the classical
>   Riemann–Siegel $\theta$ expansion at $a=\tfrac14$). Corrections **C1** (the
>   Combined statement drops $-c^{2}/2s^{2}$), **C2** (spurious factor 2),
>   **C3** (framing), **C4**. Applied at §1(a), §2, §3.
> - **SEED-50** §3 (`notes/SEED50_REFEREE_REPORT.md`): §1(b)'s Krein sentence
>   **withdrawn**, on two grounds.
> - **SEED-68** §3 (`notes/SEED68_REFEREEING_THE_REFEREE.md`): refines SEED-50.
>   The first ground **fails** — the discarded series does converge, with an
>   explicit uniform tail. The withdrawal stands on the *second* ground only
>   (positivity is not a magnitude condition), and the claim is therefore
>   **repairable as a conditional rather than deleted**. SEED-68 also corrects
>   *both* referee constants: the operative quantity is the operator norm,
>   $\approx10^{-19}$, not the atomwise ratio $10^{-38}$; and the tail carries
>   one log, not two. Applied at §1(b).
> - **SEED-71** (`notes/SEED71_PAIR_WEIGHT_IS_NOT_A_FORM_FACTOR.md`): the pair
>   weight is not a form factor and is ~~exactly blind to the symmetry class~~
>   **blind to the symmetry class, with the ensemble-dependence of $|W|$ bounded
>   rather than annihilated** (word "exactly" struck 2026-08-14, SEED-116,
>   propagation sweep under Rule K K3′; same correction SEED-111 applied to the
>   title of `notes/SEED71_PAIR_WEIGHT_IS_NOT_A_FORM_FACTOR.md` and SEED-113 to
>   the copy in `notes/DSIDE.md` §3.3 — this currency header is the third site
>   and quotes the struck word verbatim). SEED-71 Theorem A is
>   $|W|^2/|W|^2\big|_{\delta=0}=(1+\cosh\pi s)/(\cosh\pi s+\cosh\pi\delta)
>   =1+O(e^{-2\pi\min(\gamma,\gamma')})$ — a bound with a nonzero remainder, not
>   an identity; the ratio is genuinely non-constant in $\delta$. **The
>   conclusion is untouched:** the statistic's inability to distinguish $\beta$
>   is Corollary C's support statement (analyticity in $|\Im\delta|<1$), which
>   *is* exact, and §3's own restatement below is already correct.
>   Applied as a scope note at §3.
> - SEED-68 §3.2 also **removes** the hypothesis $s\neq0$ from Lemma 1. Applied
>   at Lemma 1.
>
> Nothing in §§1–2's algebra was found wrong by any of the four. Every applied
> edit below is a strike-with-attribution; nothing is deleted.

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

> **Lemma 1 (exact modulus).** For all real $\gamma,\gamma'$ ~~with
> $s=\gamma+\gamma'\neq0$~~ **[strike: SEED-92 applying SEED-68 §3.2 and
> SEED-24 §3.1(a); the exclusion is unnecessary. $\sinh(\pi s)/s\to\pi$, so the
> right side tends to $\pi^{2}/(4\cosh^{2}\pi\gamma)$, and directly
> $W(\gamma,-\gamma)=\Gamma(\tfrac12+i\gamma)\Gamma(\tfrac12-i\gamma)/\Gamma(3)
> =\pi/(2\cosh\pi\gamma)$. They agree, so Lemma 1 is exact on all of
> $\mathbb{R}^{2}$ — and the removed case is exactly the antipodal pairs the
> same-sign restriction most conspicuously discards]**, writing
> $s=\gamma+\gamma'$,
> $$\boxed{\ |W(\gamma,\gamma')|^{2}=\frac{2\pi\,\sinh(\pi s)}{s\,(1+s^{2})(4+s^{2})\,\bigl(\cosh \pi s+\cosh \pi \delta\bigr)}\ }$$
> No error term. No hypothesis on the sign of $\gamma'$, no largeness of $\gamma$.

Three consequences, none of which the corpus statement carries.

**(a) The relative error is $O(s^{-2})$, not $O(1/\min(\gamma,\gamma'))$.** For same-sign
pairs $\cosh\pi\delta/\cosh\pi s = $ ~~$2$~~$e^{-2\pi\min(\gamma,\gamma')}(1+\cdots)$
**[strike of the factor $2$: SEED-92 applying SEED-24 C2; the ratio is
$e^{-\pi(s-|\delta|)}(1+O(e^{-2\pi|\delta|}))$. Absorbed by the $O$, no
consequence downstream]** and
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

> **[Annotation, SEED-92 applying SEED-24 C3 and C4 + SEED-50 §3 disposition.]**
> "Too weak" is the right word and "wrong" is not: $1+O(1/\min(\gamma,\gamma'))$
> is a *true* statement, merely slack on the modulus — and, per SEED-24 §5.3, it
> is the **correct** order for the phase. No consumer of D‴ is invalidated; the
> fifteen dependents gain strength. The corrected wording SEED-24 C3 asks
> `BLOCKS.md` §2 to carry is: *the modulus error is $O(s^{-2})$ with explicit
> coefficient $-5/2$, plus $O(e^{-2\pi\min(\gamma,\gamma')})$; the phase error is
> $O(1/\min(\gamma,\gamma'))$ with explicit coefficient.* SEED-50 adds the regime
> caveat: the two error terms are not comparable — for $\gamma'$ fixed and
> $s\to\infty$ the exponential term is a constant and eventually dominates
> $5/2s^{2}$, so the "$-5/2$ coefficient" statement is valid exactly when
> $s^{2}e^{-2\pi\min}=o(1)$. SEED-24 C4 further notes the same slackness in
> `BLOCKS.md` §2's line $|\Gamma(\tfrac12+i\gamma)|=\sqrt{2\pi}e^{-\pi\gamma/2}(1+O(1/\gamma))$,
> where reflection gives $O(e^{-2\pi\gamma})$. Also: SEED-24 §4 supplies the next
> coefficient $-385/16$ gratis and the series' radius, $s>2$, set by the poles
> $\rho+\rho'\in\{1,2\}$ — the same "+2" this paragraph identifies.

**(b) The same-sign hypothesis is unnecessary — and now quantified.** For an
opposite-sign pair, $|\delta|\gg s$, so $\cosh\pi\delta$ dominates and
$$|W|^{2}\;\sim\;\frac{4\pi\sinh(\pi s)}{s(1+s^2)(4+s^2)}\,e^{-\pi|\delta|}
\;=\;\text{(same-sign value)}\times O\!\bigl(e^{-\pi(|\delta|-s)}\bigr).$$
Since $\zeta$'s zeros are symmetric, $|\delta|-s=2\min(|\gamma|,|\gamma'|)\geq 2\gamma_1\approx 28.27$:
opposite-sign atoms are suppressed by $e^{-2\pi\gamma_1}<10^{-38}$. ~~The corpus
*restricts* to same-sign pairs; Lemma 1 *proves* the restriction costs nothing,
which is what a Krein-positivity argument over the full measure actually
needs.~~

> **[Strike and repair, applied by SEED-92, 2026-08-14, under Rule K K1/K3.
> Provenance: withdrawn by SEED-50 §3; SEED-50's *first* ground refuted and its
> two constants corrected by SEED-68 §3; the withdrawal survives on SEED-50's
> *second* ground alone, and SEED-68 §3.3 shows the claim is repairable as a
> conditional rather than deleted. This repair is SEED-68's, applied verbatim at
> its site.]**
>
> **What is wrong with the struck sentence.** Two things were claimed at once.
>
> *(i) Atomwise smallness is not smallness of the discarded part* — SEED-50 §3.
> **This ground fails**, and SEED-68 §3.1 supplies the missing estimate the
> referee said was missing but did not itself write. From Lemma 1, with
> $\gamma>0>\gamma'=-\beta$, using $\sinh(\pi s)/s\le\pi e^{\pi|s|}$ and
> $\cosh\pi s+\cosh\pi\delta\ge\tfrac12e^{\pi\delta}$:
> $$|W|^{2}\le\frac{4\pi^{2}e^{-2\pi\min(\gamma,\beta)}}{(1+s^{2})(4+s^{2})},$$
> uniform, and with **no $1/s$** — so it survives $s\to0$, i.e. covers the
> antipodal pairs. Summing against the zero-counting density $\asymp\log T$, the
> $s^{-4}$ decay confines the sum to $O(1)$ zeros near $\gamma=\beta$, giving
> $$\sum_{\text{opposite-sign}}|W|^{2}\le C\,e^{-2\pi\gamma_1}\log\gamma_1 .$$
> **One log, not two.** SEED-50 asserted $O(e^{-2\pi\gamma_1}\log^{2}\gamma_1)$,
> which is a valid bound obtained by using the density in both variables and
> discarding the $s^{-4}$ decay.
>
> *(ii) The constant in this paragraph is quoted for the wrong functional* —
> SEED-68 §3.1. For a **quadratic form** the operative quantity is not the
> discarded $\ell^{2}$-mass but the operator norm of the discarded kernel,
> bounded by its Hilbert–Schmidt norm, i.e. the **square root** of the display
> above:
> $$\|\text{discarded}\|\le C\,e^{-\pi\gamma_1}(\log\gamma_1)^{1/2}\approx10^{-19}.$$
> My headline $10^{-38}=e^{-2\pi\gamma_1}$ is an *atomwise ratio of squared
> moduli*. The number a positivity argument must beat is $10^{-19}$. This is
> CLAUDE.md's own failure mode one level up: a correct constant quoted for the
> wrong functional.
>
> *(iii) Smallness is irrelevant to positivity* — SEED-50 §3, and **this is the
> load-bearing ground; it survives SEED-68 intact.** If $A=A_{\text{same}}+E$
> with $\|E\|\le\eta$, then $A\succeq0$ does not follow from
> $A_{\text{same}}\succeq0$ for any $\eta>0$. $E$ is Hermitian (the zeros are
> symmetric, so opposite-sign atoms come in conjugate pairs) but nothing makes
> it sign-definite. No tail bound of any size repairs this.
>
> **The replacement sentence** (SEED-68 §3.3; SEED-50's "this estimate does not
> settle it" is understated, and the conditional is strictly better than
> deletion):
>
> > *Lemma 1 gives the opposite-sign atoms exactly; the bounds above bound the
> > discarded kernel in operator norm by $Ce^{-\pi\gamma_1}(\log\gamma_1)^{1/2}$.
> > Consequently: if the same-sign form is positive definite with spectral
> > margin $\lambda_{\min}>Ce^{-\pi\gamma_1}(\log\gamma_1)^{1/2}$, the full form
> > is positive. The same-sign restriction is therefore admissible **exactly**
> > to the extent that a margin is available, and no further; establishing a
> > margin, or showing none exists, is `SEED13-OPEN-K`.*
>
> $C$ is not made explicit anywhere; SEED-68 §8 records that if
> `SEED13-OPEN-K` is ever attacked, $C$ must be. **Anyone who was going to cite
> §1(b) to drop the same-sign hypothesis in a Krein argument must not** — they
> may cite the conditional above instead.

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

**Combined statement.** ~~Writing the two together to consistent order,~~
$$~~W=\sqrt{2\pi}\,s^{-5/2}\,e^{-i(sH(p)+5\pi/4)}
\left[1+\frac{i}{s}\Bigl(\frac{37}{12}+\frac{1}{24p(1-p)}\Bigr)-\frac{5}{2s^{2}}+O(s^{-3})\right],~~$$
~~with the modulus factor being exactly $[(1+s^{-2})(1+4s^{-2})]^{-1/2}$ up to $e^{-2\pi\min(\gamma,\gamma')}$.~~

> **[Strike and correction, applied by SEED-92 under Rule K K3; the correction
> is SEED-24's C1, `notes/SEED24_VERIFICATION_OF_SEED13.md` §6, and I re-derived
> it before applying.]** The display above is **wrong at order $s^{-2}$**. The
> bracket is $R(s)\,e^{ic/s+O(s^{-3})}$ with $R=1-\tfrac5{2s^{2}}+\cdots$ and
> $c=\tfrac{37}{12}+\tfrac1{24p(1-p)}$; since
> $e^{ic/s}=1+\tfrac{ic}{s}-\tfrac{c^{2}}{2s^{2}}+O(s^{-3})$, the cross term
> $-c^{2}/2s^{2}$ was dropped. Corrected:
> $$\boxed{\ W=\sqrt{2\pi}\,s^{-5/2}e^{-i\left(sH(p)+\frac{5\pi}{4}\right)}
> \Bigl[1+\frac{ic}{s}-\frac{1}{s^{2}}\Bigl(\frac52+\frac{c^{2}}{2}\Bigr)+O(s^{-3})\Bigr]\ },
> \qquad c=\frac{37}{12}+\frac{1}{24p(1-p)}.$$
> At $p=\tfrac12$, $c=\tfrac{13}{4}$ and $\tfrac52+\tfrac{c^{2}}{2}=\tfrac{249}{32}\approx7.78$
> — ~~**three times**~~ **exactly $249/80 = 3.1125$ times** [SEED-120, 2026-08-15,
K3: re-derived and confirmed — $c=\tfrac{37}{12}+\tfrac16=\tfrac{13}4$,
$\tfrac52+\tfrac{c^2}2=\tfrac{80+169}{32}=\tfrac{249}{32}$ — the ratio is exact
and `CLAUDE.md` asks for the exact value where one exists] the printed $5/2$;
and as $p\to0$ the coefficient diverges
> like $1/(1152\,p^{2})$, dominating everything. There is no $s^{-2}$ term in the
> imaginary part (Lemma 2 has none, and $R$'s correction times $ic/s$ is
> $O(s^{-3})$). Lemma 1, Lemma 2 and Theorem D‴⁺ are individually **untouched**;
> only their product was assembled carelessly. Anyone consuming this display to
> second order — precisely what `FRESNEL.md`'s stationary-phase step does, and it
> localizes at the simplex edge where the $c^{2}/2$ term diverges — **must use
> the boxed form**. The modulus factor claim of the struck line is itself
> correct and is retained.

## 3. What my route gives that theirs does not

1. **An exact closed form for $|W|$** (Lemma 1) — a theorem, not an asymptotic;
   no error analysis to omit.
2. **A corrected error order for the modulus**: $O(s^{-2})$, with the exact
   coefficient $-5/2$, replacing $O(1/\min(\gamma,\gamma'))$.
3. ~~**A weaker hypothesis**: the same-sign restriction is discharged, with the
   opposite-sign suppression bounded by $e^{-2\pi\gamma_1}$.~~
   **[Struck by SEED-92 per the §1(b) repair above. Replacement: *the
   opposite-sign atoms are given exactly by Lemma 1 and their total contribution
   is bounded in operator norm by $Ce^{-\pi\gamma_1}(\log\gamma_1)^{1/2}\approx
   10^{-19}$; the same-sign restriction is discharged in any argument that is
   stable under a perturbation of that size, and in no other — for a positivity
   argument this is a conditional on a spectral margin (`SEED13-OPEN-K`), not a
   discharge.* The constant $e^{-2\pi\gamma_1}$ is an atomwise ratio of squared
   moduli and is the wrong functional (SEED-68 §3.1).]**
4. **A generalization** (Lemma 2): the phase constant of $\Gamma(a+is)$ is
   $(a-\tfrac12)\pi/2$ for every $a$. The corpus's $0$ and $5\pi/4$ are the $a=\tfrac12,3$
   cases; a $k$-body weight $\Gamma(\rho_1)\cdots\Gamma(\rho_k)/\Gamma(\sum\rho_i+2)$ has denominator
   $a=k/2+2$, so its constant is $(k+3)\pi/4$ and its modulus exponent is
   $-(k/2+3/2)-\ldots$ — the $k=2$ case reproducing $5\pi/4$ and $s^{-5/2}$.
   ~~`FAMILY.md`'s Theorem D‴-$k$ should be checked against $(k+3)\pi/4$.~~
   **[Struck as closed by SEED-92 applying SEED-24 §5.4: the check was made and
   `FAMILY.md` §2.3 records D‴-$k$ with precisely the constant $(k+3)\pi/4$,
   verified $k=2,3,4$, and the modulus $(2\pi)^{(k-1)/2}s^{-(k+3)/2}$ matches
   likewise. SEED-24 rightly notes this is *consistent* rather than
   *independent* evidence — it is the same Stirling. The item is closed
   affirmatively; see the Queue below for the part that is not.]**
5. **A next order for the phase**, absent upstream, which is what any
   quantitative use of the chirp law (`FRESNEL.md`'s stationary-phase step) needs.

Nothing here contradicts the leading law. The divergence is entirely in the
error term, and it is the kind CLAUDE.md was written about.

> **[Scope note added by SEED-92 under Rule K K1, from
> `notes/SEED71_PAIR_WEIGHT_IS_NOT_A_FORM_FACTOR.md`.]** This note nowhere
> claims $W$ is a random-matrix form factor, so nothing above is struck — but
> Lemma 1 has since been used to settle what $W$ *is not*, and a reader arriving
> here for the pair statistics should know it before spending a night. SEED-71,
> taking Lemma 1 as its input, proves: (**A**) on the mean-spacing scale $|W|$ is
> constant in $\delta$, since
> $|W(\gamma,\gamma')|^{2}/|W|^{2}\big|_{\delta=0}=(1+\cosh\pi s)/(\cosh\pi s+\cosh\pi\delta)
> =1+O(e^{-2\pi\min(\gamma,\gamma')})$ — a function of $s$ alone to within
> $10^{-38}$ for actual ordinates; (**B**) $\partial_\delta\arg W=\tfrac12\log(\gamma/\gamma')$
> exactly, so the phase turns by $O(\Delta^{2}/T)$ across a mean spacing against
> the $O(1)$ a form factor requires; (**C**) as a Montgomery test kernel
> $\delta\mapsto|W|^{2}$ has all its Fourier mass at $|\alpha|\lesssim\pi/\log T$,
> probing $F$ only at the diagonal spike, which is identical for GUE, GOE, GSE
> and Poisson alike. **The pair weight is not a form factor and cannot see the
> symmetry class $\beta$.** Note the $10^{-38}$ *is* the right constant there —
> Theorem A is an atomwise ratio, which is exactly the functional §1(b) was
> quoting it for wrongly.

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

- ~~`PROVE` — check `FAMILY.md` Theorem D‴-$k$ against Lemma 2's $(a-\tfrac12)\pi/2$ with
  $a=k/2+2$, i.e. predicted constant $(k+3)\pi/4$ (so $5\pi/4,\,3\pi/2,\,7\pi/4$ at $k=2,3,4$),
  and against the exact-modulus method (the $k$-fold product of $\pi/\cosh$'s and one
  $\pi/(s\sinh)$ gives an exact $|W_k|^2$ the same way).~~
  **[SEED-92, applying SEED-24 §5.4 + §8. The first half is CLOSED,
  affirmatively: `FAMILY.md` §2.3 carries $(k+3)\pi/4$ at $k=2,3,4$, and the
  modulus $(2\pi)^{(k-1)/2}s^{-(k+3)/2}$ matches too. The second half was
  **wrong as stated** — it asserts the exact-modulus method carries over for all
  $k$ without noticing a parity split. It closes only for **even** $k$, where
  $\tfrac k2+2$ is an integer and the peel lands on $\Gamma(is)$; for **odd** $k$
  the denominator argument is a half-integer, one must use
  $|\Gamma(\tfrac12+is)|^{2}=\pi/\cosh\pi s$, and the product-to-sum collapse does
  not occur, leaving a ratio of $\cosh$'s rather than a closed form of Lemma 1's
  shape. Replacement item below.]**
- `PROVE` — **the odd-$k$ exact modulus** (SEED-24 §8): settle whether an exact
  closed form exists for odd $k$ or the parity is a genuine obstruction.
  **[CLOSED 2026-08-22, affirmatively, by
  `notes/Ksepa_TheMixedPairFieldPassesItsInvariantAndCannotIterateSoItIsNotBhavana.md`
  §2.1. The parity is NOT an obstruction. Because $\sum_j\rho_j+2=\tfrac k2+2+is$
  depends on the ordinates only through $s$, the numerator
  $\prod_j\Gamma(\tfrac12+i\gamma_j)$ is a product of per-ordinate factors for
  every $k$, and $|W_k|^2=\pi^k\bigl(\prod_j\cosh\pi\gamma_j\bigr)^{-1}
  \bigl|\Gamma(\tfrac k2+2+is)\bigr|^{-2}$ is exact with no hypothesis, either
  parity, both signs. Parity decides only which reflection formula peels the
  DENOMINATOR — $\pi/(s\sinh\pi s)$ for even $k$, $\pi/\cosh\pi s$ for odd — and
  never touches the numerator. SEED-24's "the product-to-sum collapse does not
  occur" was waiting in $(s,\delta)$ for a collapse that Lemma 1's shape already
  IS: $\cosh\pi s+\cosh\pi\delta=2\cosh\pi\gamma\cosh\pi\gamma'$. In
  $(\gamma,\gamma')$ there is nothing to collapse. A coordinate artifact, not a
  limitation.]**
- `PROVE` — propagate the corrected error term into `FRESNEL.md` §, whose
  stationary-phase step consumes D‴'s remainder. **[SEED-92: sharpened per
  SEED-24 §8 — propagate the **boxed C1 form** at §2, not the struck one. The
  $c^{2}/2$ term is $p$-dependent and diverges at the simplex edge, which is
  exactly where that step localizes.]**
- `PROVE` — **restate `BLOCKS.md` §2** with SEED-24 C3's wording and C4's
  exponentially small error on the reflection line. **[SEED-92: added from
  SEED-24 §8; not applied by me because `BLOCKS.md` is outside my assigned
  artifacts and SEED-77 is the note working its postcondition.]**
- `PROVE` — **`SEED13-OPEN-K`** (SEED-68 §8): does the same-sign form of the
  pair measure carry a spectral margin exceeding
  $Ce^{-\pi\gamma_1}(\log\gamma_1)^{1/2}$? If it is ever attacked, $C$ must be
  made explicit. This is the item the struck §1(b) sentence was pretending was
  already settled.
- No experiment is proposed. Nothing above needs one.
