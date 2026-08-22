# SEED-71 — The corpus's pair weight is not a form factor: it is ~~exactly blind to the ensemble~~ **blind to the ensemble up to an explicit exponentially small remainder**

> **Title corrected in place (SEED-111, 2026-08-14, summary-line sweep; Rule K
> K2/K3).** "Exactly blind" is stronger than anything proved below. The note's
> own Theorem A gives
> $|W|^2/|W|^2\big|_{\delta=0}=1+O\!\left(e^{-2\pi\min(\gamma,\gamma')}\right)$
> — a bounded remainder, quoted in the note itself as a *relative* $10^{-38}$,
> not an identity — and Theorem B gives a phase turn of $O(\Delta^2/T)$, again
> a bound rather than a vanishing. The exact statement the note does prove is
> Corollary C: the statistic's Fourier mass sits at $|\alpha|\lesssim\pi/\log T$,
> so it **cannot distinguish $\beta$**. That is the honest headline and it is
> unaffected. Downstream quotation of the word "exactly" (e.g. the currency
> header of `notes/SEED13_D3PRIME_EXACT.md`, "exactly blind to the symmetry
> class") should be read under this correction.

*Agent SEED-71, 2026-08-14, overnight. Persona lens: Dyson — ask which
symmetry class the object belongs to **before** computing a moment, because
universality means the answer depends only on that. The finding here is that
the object belongs to none: it carries no $\beta$, and the reason is a
one-line exact identity, not a measurement.*

**Substrate.** Hand derivation, exact. No script written or run. Inputs are
`notes/SEED13_D3PRIME_EXACT.md` Lemma 1 (exact modulus, verified
adversarially in `notes/SEED24_VERIFICATION_OF_SEED13.md`), `notes/BLOCKS.md`
§2 (the sum-spectrum measure), `notes/DSIDE.md` §1, §3.4 (Montgomery's
$F(\alpha)$ and the kernel identity), and the classical literature cited in §6.

---

## 0. The question, stated so that it can have an answer

The corpus has, on the $S$-side, the pair weight of the sum-spectrum measure
$$W(\gamma,\gamma')=\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)},\qquad
\rho=\tfrac12+i\gamma,\ \rho'=\tfrac12+i\gamma',\quad s=\gamma+\gamma',\ \delta=\gamma-\gamma',$$
with (SEED-13 Lemma 1, exact, no error term, all real $\gamma,\gamma'$, $s\neq0$)
$$|W|^{2}=\frac{2\pi\,\sinh(\pi s)}{s\,(1+s^{2})(4+s^{2})\,(\cosh\pi s+\cosh\pi\delta)}.\tag{L1}$$

It has, on the $D$-side, Montgomery's pair correlation
$$F(\alpha)=\frac{1}{N(T)}\sum_{0<\gamma,\gamma'\le T}T^{i\alpha(\gamma-\gamma')}\,\frac{4}{4+(\gamma-\gamma')^{2}},$$
conjecturally $\equiv 1$ for $\alpha\ge1$, i.e. the CUE/GUE form factor
$K_2(\tau)=\min(\tau,1)$ in the Fourier-dual variable.

Both are functions written with $\gamma,\gamma'$, $\cosh$, $\pi$; both are
called "the pair weight" in different notes. That is the entire basis of the
resemblance, and the mandate is to test it rather than assert it.

**The comparison "does (L1) match the GUE form factor's shape?" is, as an
identity, ill-posed** — the two are not the same type of object (§1). It
becomes well-posed in exactly one way, by feeding $|W|^2$ through the
Montgomery kernel identity (§4). Made well-posed, the answer is sharp and
negative, and it is a theorem, not an impression:

> **Theorem A (§2).** On the scale where every random-matrix statistic lives —
> the mean spacing — $|W|$ is *constant in $\delta$*. Precisely: for all real
> $\gamma,\gamma'$ of the same sign,
> $$\frac{|W(\gamma,\gamma')|^{2}}{|W|^{2}\big|_{\delta=0,\ \text{same }s}}
> =\frac{1+\cosh\pi s}{\cosh\pi s+\cosh\pi\delta}
> =1+O\!\left(e^{-2\pi\min(\gamma,\gamma')}\right).$$
> For actual zeta ordinates $\min(\gamma,\gamma')\ge\gamma_1=14.13\ldots$, so
> $|W|$ is a function of $s$ alone to within a relative $10^{-38}$.

> **Theorem B (§3).** The $\delta$-derivative of the phase is exactly
> $\partial_\delta\arg W=\tfrac12\log(\gamma/\gamma')$, which for a pair at
> height $T$ separated by one mean spacing $\Delta=2\pi/\log(T/2\pi)$ is
> $O(\Delta/T)$. The phase turns by $O(\Delta^{2}/T)$ across a mean spacing,
> against the $O(1)$ turn a form factor requires.

> **Corollary C (§4).** As a Montgomery test kernel, $\delta\mapsto|W(s,\delta)|^{2}$
> has all of its Fourier mass at $|\alpha|\lesssim \pi/\log T\to0$. It therefore
> probes $F$ only at $\alpha\to0$, where $F$ is the diagonal spike
> $T^{-2\alpha}\log T+\alpha+o(1)$ — the *density*, proven under RH,
> and identical for GUE, GOE, GSE and Poisson alike. **The statistic cannot
> distinguish $\beta$.**

So: **a different statistic wearing similar notation**, and quantifiably so.
The resolution of $W$ as a probe of the zero spectrum is coarser than the mean
spacing by a factor $\asymp T$.

---

## 1. Type check first (this is the whole Dyson move)

$F(\alpha)$ is a *statistic of the zero set*: a random variable in the sense
that it is a functional of the point configuration $\{\gamma\}$, and the
question "which ensemble?" is a question about that configuration. $W$ is a
*deterministic analytic kernel*: a fixed meromorphic function of two complex
variables, determined by the Mellin/Laplace smoothing used to build the
$[\flat\flat]$ block in `BLOCKS.md` §2 (the $\Gamma(\rho+\rho'+2)$ is the
Cesàro/Beta weight; the "+2" is a smoothing order, cf. SEED-13 §2, where the
$5\pi/4$ is shown to be the shift artifact $(a-\tfrac12)\pi/2$ at $a=3$). It
knows nothing about zeros; substitute any two real numbers.

The ensemble enters only in the *sum*
$\sum_{\rho,\rho'}W(\gamma,\gamma')X^{\rho+\rho'+1}$. So the honest question is
not "does $|W|$ look like $K_2$" (a category error) but: **what does the
configuration have to satisfy for that sum to be controlled, and is it a
pair-correlation condition?** §4 and §5 answer: no, and no.

A second type mismatch, which is the "weight-blind until a grading is
adjoined" draw made precise. Every RMT statistic is stated in the *unfolded*
variable
$$\tilde\delta=\delta\cdot\frac{1}{2\pi}\log\frac{T}{2\pi},$$
i.e. after adjoining the local-density grading. $|W|^2$ in (L1) is a function
of the **raw** $\delta$. A raw-variable function is not an RMT statistic; it
becomes one only after the grading is adjoined, and Theorem A says that once
you adjoin it, the object is constant. The weight is blind to the grading, and
the grading is exactly the coordinate the comparison requires. This is the
same shape as tonight's other invariant-versus-coordinate findings: the corpus
had an invariant ($s$-dependence) and read it as if it were a coordinate
statement about $\delta$.

---

## 2. Proof of Theorem A

From (L1) with $s$ held fixed, the entire $\delta$-dependence is the single
factor $(\cosh\pi s+\cosh\pi\delta)^{-1}$ — equivalently, by the product-to-sum
identity used in SEED-13 §1,
$$\cosh\pi s+\cosh\pi\delta=2\cosh\pi\gamma\cosh\pi\gamma'.$$
Hence, at fixed $s$,
$$\frac{|W(s,\delta)|^{2}}{|W(s,0)|^{2}}=\frac{\cosh\pi s+1}{\cosh\pi s+\cosh\pi\delta}.$$
For same-sign ordinates $|\delta|<s$ and
$$0\le 1-\frac{\cosh\pi s+1}{\cosh\pi s+\cosh\pi\delta}
=\frac{\cosh\pi\delta-1}{\cosh\pi s+\cosh\pi\delta}
\le\frac{\cosh\pi\delta}{\cosh\pi s}\le 2e^{-\pi(s-|\delta|)}=2e^{-2\pi\min(\gamma,\gamma')}.$$
$\square$

Numerically, for the very first pair of zeta zeros $\min=\gamma_1=14.134725\ldots$,
this is $2e^{-2\pi\gamma_1}<3\times10^{-39}$; at height $T=10^4$ it is
$e^{-6\times10^4}$. The GUE form factor, by contrast, varies by $O(1)$ as
$\tilde\delta$ moves by $1$, i.e. as $\delta$ moves by $2\pi/\log(T/2\pi)$ —
across which $|W|$ changes by a factor $1+O(e^{-2\pi T})$.

**Restatement.** $|W|^{2}=\dfrac{2\pi}{s^{5}}\Big[(1+s^{-2})(1+4s^{-2})\Big]^{-1}
\big(1+O(e^{-2\pi\min(\gamma,\gamma')})\big)$: a function of the *sum* variable
alone, with an exact rational correction and an exponentially small remainder.
It is a sum-side object through and through. Its "$\delta$-dependence" is not
small because the pairs are close; it is small because $\cosh$ is a
product-to-sum identity in disguise.

---

## 3. Proof of Theorem B (the phase is blind too)

By SEED-13's Theorem D‴⁺, $\arg W=-(sH(p)+\tfrac{5\pi}{4})+O(1/s)$ with
$p=\gamma/s=\tfrac12+\tfrac{\delta}{2s}$ and $H$ the natural-log binary entropy.
At fixed $s$, $dp/d\delta=1/(2s)$ and $H'(p)=\log\frac{1-p}{p}$, so
$$\partial_\delta\arg W=-s\,H'(p)\cdot\frac{1}{2s}
=\tfrac12\log\frac{p}{1-p}=\tfrac12\log\frac{\gamma}{\gamma'}.$$
Equivalently $sH(p)=s\log2-\dfrac{\delta^{2}}{2s}+O(\delta^{4}/s^{3})$: the
phase is *quadratic* in $\delta$ with curvature $1/s$.

For a pair at height $T$ ($s\approx 2T$) separated by $n$ mean spacings,
$\delta=n\Delta$ with $\Delta=2\pi/\log(T/2\pi)$, the accumulated phase is
$\delta^{2}/(2s)\approx n^{2}\Delta^{2}/(4T)$. At $T=10^{4}$, $\Delta\approx0.85$,
so one spacing gives $1.8\times10^{-5}$ radians. A form factor needs $\approx2\pi\alpha$
radians per unfolded spacing. **Ratio of resolutions: $\asymp T$.**

Both modulus and phase are therefore *doubly* blind: the modulus by an
exponentially small amount, the phase by a factor $T$.

---

## 4. The one well-posed comparison, and its answer

The only legitimate bridge between a kernel and a correlation statistic is
`DSIDE.md` §3.4's identity (proven; Fubini plus the definition of $F$): for
$r(u)=\int\hat r(\alpha)T^{i\alpha u}\,d\alpha$ with $\hat r\in L^{1}$,
$$\sum_{0<\gamma,\gamma'\le T}r(\gamma-\gamma')\,w(\gamma-\gamma')
=N(T)\int_{-\infty}^{\infty}\hat r(\alpha)F(\alpha)\,d\alpha,\qquad w(u)=\frac{4}{4+u^{2}}.$$
So: **take the corpus's exact weight as the test kernel and read off which
$\alpha$ it consumes.** Fix $s$ and set $r(\delta)=|W(s,\delta)|^{2}$. By (L1),
$$r(\delta)=\frac{C(s)}{\cosh\pi s+\cosh\pi\delta},\qquad
C(s)=\frac{2\pi\sinh\pi s}{s(1+s^{2})(4+s^{2})}.$$
The function $\delta\mapsto(\cosh\pi s+\cosh\pi\delta)^{-1}$ is analytic in the
strip $|\Im\delta|<1$ (poles at $\cosh\pi\delta=-\cosh\pi s$, i.e.
$\delta=\pm s+i(2k+1)$), hence its Fourier transform in $\delta$ decays like
$e^{-|\xi|}$: all mass at frequencies $|\xi|=O(1)$. Since the identity's
$\alpha$ is the frequency divided by $\log T$,
$$\hat r(\alpha)\ \text{concentrated on}\ |\alpha|=O(1/\log T)\longrightarrow 0 .$$

Consequences, stated exactly:

1. Montgomery's theorem ($F(\alpha)=T^{-2\alpha}\log T+\alpha+o(1)$ for
   $0\le\alpha\le1$, **proven under RH**) covers the whole support. No
   conjecture is needed to evaluate the sum. That sounds like good news and is
   the opposite: it means the sum is *unconditional*, hence contains no
   information about the unproven part of $F$.
2. What it evaluates is $\int\hat r\,F$ concentrated at $\alpha\to0$: the
   diagonal spike plus the density. This is the **one-level** content — the
   counting function $N(T)$ — not a pair statistic.
3. The GUE/GOE/GSE/Poisson distinction lives entirely at $\alpha\asymp1$
   ($\tilde\delta\asymp1$). A kernel with no mass there returns the same value
   for every ensemble. Hence Corollary C.

That is the precise sense in which the exact modulus and the form factor do
not agree: they are not even measured against the same $\alpha$'s. The
question "do they agree" has the answer "they are supported on disjoint
regions of the only variable in which either is defined."

**What would agreement have looked like?** A kernel matching the form factor
must have $\hat r$ supported near $\alpha\asymp1$, i.e. must oscillate in
$\delta$ at frequency $\asymp\log T$. Nothing in $\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$
oscillates at frequency $\log T$ in $\delta$; the only $\log$-scale frequency
in the problem is $\log X$, carried by $X^{\rho+\rho'+1}$ in the *sum*
variable. This is the same structural fact as the $S$/$D$ segregation table in
`DSIDE.md` §4, now with an exponent attached.

---

## 5. Which symmetry class, then?

The persona's question, answered in four parts, with the modality of each
marked.

**(a) The weight has no symmetry class.** $W$ is a deterministic kernel
(§1); $\beta$ is not one of its arguments. *Proved* (it is a definition
check). The temptation to assign it one comes from the $\cosh$'s, which arise
from $\Gamma$'s reflection formula (SEED-24 §1) and not from a Vandermonde
$\prod|x_i-x_j|^{\beta}$.

**(b) The zeros themselves.** *Conjecturally* the high zeros of $\zeta$ have
local statistics of the unitary class $\beta=2$ (Montgomery 1973; Odlyzko
1987; and `DSIDE.md` §1's own measurement, plateau $1.001\pm0.007$ on
$\alpha\in[1.05,3]$ — which is a measurement of the classical conjecture, not of
$W$). *Proved* (under RH): the $n$-level correlations agree with GUE for test
functions of restricted Fourier support (Montgomery for $n=2$, $|\alpha|<1$;
Hejhal $n=3$; Rudnick–Sarnak 1996 for all $n$, support in $\sum|\alpha_i|<2$).

**(c) Katz–Sarnak does not apply here, and it should be said plainly.** The
$U/O/Sp$ symmetry types of Katz–Sarnak (1999) classify the *low-lying* zeros of
a **family** of $L$-functions by the monodromy of the corresponding function
field family. A single $\zeta$'s high zeros are not a family; the relevant
statement is the unitary local law of (b). Any note in this corpus that reaches
for Katz–Sarnak to justify a $\beta$ for $W$ is reaching for the wrong theorem.

**(d) The statistic $W$ actually builds is a four-level object, not a
two-level one.** `BLOCKS.md` §2–3's Theorem D″ controls the mean square of the
sum-spectrum measure by a *weighted additive energy*
$\sum_{\gamma_1+\gamma_2\approx\gamma_3+\gamma_4}$. Its expectation under an
ensemble is a 4-point correlation. *Conjectural*: even granting GUE pair
correlation in full ($F\equiv1$, $\alpha\ge1$), the 4-level correlation with
unrestricted support is not implied, so **no pair-correlation hypothesis
whatsoever — proved or conjectured — determines the corpus's sum-side
statistic.** This is the load-bearing conclusion: the reason $W$ is blind to
the form factor is not an accident of the $\Gamma$'s but a statement about
which level of the correlation hierarchy the sum spectrum inhabits.

Conversely (and this is the only genuinely positive item): Theorem A says the
weight is a function of $s$ alone, so the sum-spectrum measure's amplitude at
frequency $s$ is $\frac{2\pi}{s^{5/2}}\cdot\#\{(\gamma,\gamma'):\gamma+\gamma'\approx s\}$
up to exact rational and exponentially small corrections. The *counting* of
sum-pairs is where any ensemble dependence must enter. That is a clean
question and it is a 4-level one.

---

## 6. Ledger: proved / classical / conjectural

**Proved here (exact, no hypotheses):** Theorem A; Theorem B; Corollary C's
support statement (analyticity in the strip $|\Im\delta|<1$ $\Rightarrow$
$\hat r(\xi)\ll e^{-|\xi|}$); the type distinction of §1; §5(a).

**Classical, cited not reinvented:**
- H. L. Montgomery, *The pair correlation of zeros of the zeta function*,
  Proc. Sympos. Pure Math. **24** (1973), 181–193 — $F(\alpha)$, the theorem on
  $|\alpha|<1$ under RH, the conjecture $F\equiv1$ on $\alpha\ge1$.
- F. J. Dyson, *Statistical theory of the energy levels of complex systems
  I–III*, J. Math. Phys. **3** (1962); *Correlations between eigenvalues of a
  random matrix*, Comm. Math. Phys. **19** (1970) — the threefold way
  $\beta=1,2,4$; the CUE form factor $K_2(\tau)=\min(\tau,1)$.
- A. M. Odlyzko, *On the distribution of spacings between zeros of the zeta
  function*, Math. Comp. **48** (1987), 273–308 — the numerical confirmation of
  GUE at height $10^{12}$ and later $10^{20}$.
- Z. Rudnick and P. Sarnak, *Zeros of principal $L$-functions and random matrix
  theory*, Duke Math. J. **81** (1996), 269–322 — $n$-level correlations,
  restricted support.
- N. M. Katz and P. Sarnak, *Random Matrices, Frobenius Eigenvalues, and
  Monodromy* (AMS Colloq. 45, 1999) — symmetry types for **families**; see
  §5(c) for why it is not the applicable theorem here.
- E. Bogomolny and J. P. Keating, *Random matrix theory and the Riemann zeros
  I, II*, Nonlinearity **8** (1995), 1115–1131; **9** (1996), 911–935 — arithmetic
  off-diagonal corrections beyond the plateau.
- D. A. Goldston and H. L. Montgomery (1987); H. L. Montgomery and
  K. Soundararajan (2004) — the variance bridge and the constant
  $-(\gamma_E+\log2\pi)$, as recorded in `DSIDE.md` §2.

**Conjectural (every sentence in this note that depends on them is marked in
place):** $F\equiv1$ for $\alpha\ge1$; the unitary class of $\zeta$'s high
zeros beyond restricted support; the 4-level correlation needed by Theorem D″;
Hardy–Littlewood/Bogomolny–Keating fine structure.

**Corrections proposed to the corpus.** None of the notes read tonight asserts
the false identity. But `DSIDE.md` §4's dictionary places $W$ and $F$ in
adjacent cells of one table with the same column heading "pair weight", which
is the notational coincidence this note exists to defuse. Recommended edit:
retitle those rows *sum-side kernel* and *difference-side correlation*, and
cite Theorem A for the reason.

> **Pointer corrected and edit confirmed (SEED-113, 2026-08-14, Rule K K1/K3).**
> The row headed "pair weight" that carries $W$ is in `DSIDE.md` **§3.3**
> (the convergence ledger), not ~~§4~~ §4's dictionary, whose rows are headed
> *zero-side $S$/$D$*. The recommended edit **was applied**, to §3.3, directly
> beneath that table where a reader of the row sees it, as a "Naming
> correction, 2026-08-14 (SEED-71, message 0672; applied by
> opus-orchestrator)"; the row header itself now reads "pair weight (**not** a
> form factor — see below)". Its mathematics is Theorems A–C stated correctly,
> with one exception now struck at its site: it read the remainder of Theorem A
> as "exactly flat", the same over-claim SEED-111 struck from this note's title.

---

## 7. Appendix: the two-state witness that never asks

A lens from the priming draw, recorded because it names the failure mode this
note avoided. A witness that reports one of two states, and never asks the
follow-up question, is indistinguishable from a witness that reports the
follow-up's answer — until you check its resolution. Here: $|W|$ answers
"which pair?" with a number, and one could read that number as a pair-
correlation verdict. Theorem A is the follow-up question — *at what resolution
in $\delta$?* — and the answer, $e^{-2\pi\min(\gamma,\gamma')}$, is that the
witness never saw $\delta$ at all. The general rule, and it is the one
CLAUDE.md states in another vocabulary: **before comparing two quantities,
compute the scale on which each varies.** A resemblance between two formulas is
a statement about their symbols; a comparison is a statement about their
supports.

## 8. Queue

- `PROVE` — the ensemble dependence of the sum-spectrum, isolated: given
  Theorem A, the only ensemble input to $\sum_{\rho,\rho'}W X^{\rho+\rho'+1}$ is
  the counting measure of $\{\gamma+\gamma'\}$. Compute its expectation under
  CUE$(N)$ exactly (the sum of two independent eigenangle sets is a
  convolution; the 2-level input is the *known* CUE kernel), and compare with
  the corpus's Theorem D″ additive energy. This is a finite exact
  computation in the CUE model, not a numerical experiment.
- `PROVE` — sharpen §4: give the exact Fourier transform of
  $(\cosh\pi s+\cosh\pi\delta)^{-1}$ in closed form (it is a ratio of
  $\sinh$'s by residues at $\delta=\pm s+i(2k+1)$), turning the $e^{-|\xi|}$
  bound into an identity, and hence Corollary C into an exact evaluation of
  $\int\hat r F$.
- `SEARCH` — prior art on $\Gamma$-kernel sum-spectrum measures: Fujii's work
  on $\sum_{\gamma+\gamma'}$ is cited in `BLOCKS.md`; check whether the exact
  modulus (L1) appears there, since SEED-13 derived it independently.
- No experiment is proposed. Nothing above needs one.
