# Rational fibers: the local singular series and the Dirichlet zero spectra

## Status and purpose

This note is an exact synthesis of classical character theory, explicit
formulas for Dirichlet $L$-functions, and the finite/profinite correlation
calculus of `ADELIC.md`.  No component is claimed as new.  Its purpose is to
correct a misleading mental product:

> The finite-place Hardy--Littlewood spectrum should not be tensored with one
> universal copy of the zeta-zero spectrum.  The archimedean spectrum is
> fibered over the rational characters $a/q\in\mathbb Q/\mathbb Z$, and the
> fiber at $a/q$ contains zeros of the Dirichlet $L$-functions modulo $q$.

The $q=1$ fiber is exactly the zeta product measure in `PRODUCT.md`.  The
other fibers are generally complex.  This is the smallest common language in
which the Bost--Connes diagonal, the Hardy--Littlewood baseline, Goldbach sum
spectra, and gap difference spectra all occur without identifying distinct
objects.

Write $e_q(x)=\exp(2\pi i x/q)$.  Dirichlet characters modulo $q$ are
extended by zero away from the units, and

\[
 \tau(\overline\chi)=\sum_{r\bmod q}\overline\chi(r)e_q(r).
\]

## 1. Exact rational-mode decomposition

Let $(a,q)=1$.  Character orthogonality gives, whenever $(n,q)=1$,

\[
 \boxed{
 e_q(an)=\frac1{\varphi(q)}
 \sum_{\chi\bmod q}\tau(\overline\chi)\chi(a)\chi(n).}
 \tag{1.1}
\]

Indeed, expanding the Gauss sum makes the right side

\[
 \frac1{\varphi(q)}\sum_{r\bmod q}e_q(r)
 \sum_{\chi\bmod q}\overline\chi(r)\chi(an)=e_q(an).
\]

After multiplication by the von Mangoldt function, the omitted nonunits are
exactly powers of primes dividing $q$.  Thus for every $n\geq1$,

\[
 \boxed{
 \Lambda(n)e_q(an)=\frac1{\varphi(q)}
 \sum_{\chi\bmod q}\tau(\overline\chi)\chi(a)\Lambda(n)\chi(n)
 +R_{a,q}(n),}
 \tag{1.2}
\]

where

\[
 R_{a,q}(n)=
 \sum_{p\mid q}\sum_{k\geq1}(\log p)e_q(ap^k)\,\mathbf1_{n=p^k}.
 \tag{1.3}
\]

Consequently, for $\Re s>1$,

\[
 \boxed{
 D_{a,q}(s):=\sum_{n\geq1}\frac{\Lambda(n)e_q(an)}{n^s}
 =\frac1{\varphi(q)}\sum_{\chi\bmod q}
 \tau(\overline\chi)\chi(a)\left(-\frac{L'}L(s,\chi)\right)
 +P_{a,q}(s),}
 \tag{1.4}
\]

with the explicit local correction

\[
 P_{a,q}(s)=\sum_{p\mid q}\sum_{k\geq1}
 (\log p)e_q(ap^k)p^{-ks}.
 \tag{1.5}
\]

If $\chi$ is induced by the primitive character $\chi^*$ of conductor
$f\mid q$, then

\[
 -\frac{L'}L(s,\chi)=
 -\frac{L'}L(s,\chi^*)-
 \sum_{\substack{p\mid q\\p\nmid f}}
 \frac{\chi^*(p)(\log p)p^{-s}}{1-\chi^*(p)p^{-s}}.
 \tag{1.6}
\]

This separates the primitive $L$-zero spectrum from all imprimitive Euler
corrections.  The latter have their extra zeros on $\Re s=0$, not in the
critical strip.

## 2. The pole is the Hardy--Littlewood amplitude

For the principal character $\chi_0\bmod q$,

\[
 \tau(\chi_0)=c_q(1)=\mu(q),
 \qquad
 -\frac{L'}L(s,\chi_0)\sim\frac1{s-1}.
\]

Therefore the residue of $D_{a,q}$ at $s=1$, equivalently the prime mean
of the reduced additive mode $a/q$, is

\[
 \boxed{\kappa_q=\frac{\mu(q)}{\varphi(q)}.} \tag{2.1}
\]

It is independent of reduced $a$, and it vanishes for nonsquarefree $q$.
This is the amplitude whose square occurs in the singular series.

More precisely, let $W$ be squarefree and let

\[
 f_W(x)=\frac{\mathbf1_{(x,W)=1}}{\varphi(W)/W}
 \qquad (x\in\mathbb Z/W\mathbb Z).
\]

At every reduced frequency $a/q$ with $q\mid W$, the normalized Fourier
coefficient of $f_W$ is $\kappa_q$.  Finite Fourier inversion therefore
gives the exact Bost--Connes/profinite correlation identity

\[
 \boxed{
 C_W(h):=\mathbb E_{x\bmod W}f_W(x)f_W(x+h)
 =\sum_{q\mid W}\kappa_q^2c_q(h).}
 \tag{2.2}
\]

As $W$ exhausts the squarefree primorials, for every fixed $h\ne0$,

\[
 C_W(h)\longrightarrow
 \sum_{q\geq1}\frac{\mu(q)^2}{\varphi(q)^2}c_q(h)
 =\mathfrak S(h). \tag{2.3}
\]

The convergence is absolute.  Its absolute Euler product has factors
$1+(p-1)^{-2}$ for $p\nmid h$, and only the finitely many factors
$1+(p-1)^{-1}$ for $p\mid h$.  At $h=0$, by contrast, (2.2) tends to
infinity.  The critical local correlator has a genuine collision singularity
on the diagonal.

Thus the Hardy--Littlewood baseline is exactly the **pole--pole layer** of the
rational fibers, not a finite-energy one-body mean.

## 3. Twisted compensated explicit formula

For $X\geq2$, put

\[
 \Psi_{a,q}(x)=\sum_{n\leq x}\Lambda(n)e_q(an),
 \qquad
 \Phi_{a,q}(X)=X\int_X^\infty
 \bigl(\Psi_{a,q}(t)-\kappa_qt\bigr)\frac{dt}{t^2}.
 \tag{3.1}
\]

For every fixed $q$, the integral converges unconditionally by the classical
zero-free-region error term in the prime number theorem for arithmetic
progressions (with any exceptional real-zero term treated separately; its
exponent is still $<1$). Define also

\[
 \psi_0(t,\chi)=\frac12\!\sum_{n<t}\Lambda(n)\chi(n)
                 +\frac12\!\sum_{n\leq t}\Lambda(n)\chi(n),
 \qquad
 \Phi_\chi(X)=X\int_X^\infty
 \bigl(\psi_0(t,\chi)-\mathbf1_{\chi=\chi_0}t\bigr)\frac{dt}{t^2}.
\]

The half-weight convention fixes the pointwise explicit formula; it does not
change the integral.  Suppose first that $\chi$ is primitive and
nonprincipal, of conductor $f$, and put

\[
 \epsilon=\frac{1-\chi(-1)}2\in\{0,1\},\qquad
 c_\chi=
 \begin{cases}
  L'(0,\chi)/L(0,\chi),&\epsilon=1,\\[2mm]
  L''(0,\chi)/(2L'(0,\chi)),&\epsilon=0.
 \end{cases}                                           \tag{3.2a}
\]

In the even case this is the finite part at the simple trivial zero at
$s=0$.  The functional equation for

\[
 \Lambda(s,\chi)=
 \left(\frac f\pi\right)^{(s+\epsilon)/2}
 \Gamma\!\left(\frac{s+\epsilon}{2}\right)L(s,\chi)
\]

gives the parity-independent identity

\[
 \boxed{c_\chi=\gamma+\log\frac{2\pi}{f}
 -\frac{L'}L(1,\overline\chi).}                         \tag{3.2b}
\]

With nontrivial zeros counted with multiplicity, the Davenport explicit
formula is

\[
 \psi_0(x,\chi)=-\sum_{0<\Re\rho<1}\frac{x^\rho}{\rho}
 -c_\chi-\frac12\log(x-1)-\frac{\chi(-1)}2\log(x+1),
 \qquad x>1.                                            \tag{3.2c}
\]

Integrating (1.2) gives the exact identity

\[
 \boxed{
 \Phi_{a,q}(X)=\frac1{\varphi(q)}\sum_{\chi\bmod q}
 \tau(\overline\chi)\chi(a)\Phi_\chi(X)
 +\sum_{p\mid q}\sum_{k\geq1}(\log p)e_q(ap^k)
 \min\!\left(1,\frac X{p^k}\right).}
 \tag{3.2}
\]

The nontrivial-zero part of each character term is

\[
 \boxed{
 \Phi_\chi(X)=
 -\sum_{\rho_\chi}
 \frac{m(\rho_\chi)X^{\rho_\chi}}
 {\rho_\chi(1-\rho_\chi)}
 +A_\chi(X),}
 \tag{3.3}
\]

where $\rho_\chi$ runs over distinct nontrivial zeros of the primitive
$L$-function inducing $\chi$ and $m(\rho_\chi)$ is the multiplicity.  For a
primitive nonprincipal character, the previously unspecified term is exactly

\[
 \boxed{A_\chi(X)=-c_\chi+J_\epsilon(X),}               \tag{3.3a}
\]

where

\[
 \begin{aligned}
 J_0(X)&=-\log X-1+\delta_0(X),\\
 \delta_0(X)&=\sum_{k\geq1}\frac{X^{-2k}}{2k(2k+1)}
 =1-X\operatorname{artanh}(X^{-1})
   -\frac12\log(1-X^{-2}),\\
 J_1(X)&=\delta_1(X),\\
 \delta_1(X)&=\sum_{k\geq0}
 \frac{X^{-(2k+1)}}{(2k+1)(2k+2)}
 =\operatorname{artanh}(X^{-1})
   +\frac X2\log(1-X^{-2}).                            \tag{3.3b}
 \end{aligned}
\]

The $-\log X$ in $J_0$ is the double Perron residue produced by the
simultaneous factors $1/s$ and the even character's trivial zero at $s=0$.
For the primitive principal character (the zeta function), the pole at one
instead gives

\[
 \boxed{A_\zeta(X)=-\log(2\pi)+\delta_0(X).}            \tag{3.3c}
\]

Finally, if $\chi\pmod q$ is induced by a primitive $\chi^*$ of conductor
$f$, the complete imprimitive correction, including its sign, is

\[
 \boxed{
 \Phi_\chi(X)=\Phi_{\chi^*}(X)
 -\sum_{\substack{p\mid q\\p\nmid f}}(\log p)
   \sum_{k\geq1}\chi^*(p)^k
   \min\!\left(1,\frac X{p^k}\right).}                 \tag{3.3d}
\]

For the principal character modulo $q$, read $\chi^*=1$ and
$\Phi_{\chi^*}=\Phi_\zeta$, so the correction runs over every $p\mid q$.
Equations (3.3a)--(3.3d) therefore include all conductor, gamma, trivial-zero,
and deleted-Euler-factor terms.  The zero series in
(3.3) is absolutely convergent: for fixed $X\geq2,q$,
$X^{\Re\rho}\leq X$ and
$N_\chi(T)=O_q(T\log(qT))$, while the denominator is quadratic in $T$.
For $q=1$, (3.3) is precisely `PRODUCT.md` Theorem P1, with
$\delta=\delta_0$.

Under GRH for the Dirichlet $L$-functions modulo $q$, define the complex
spectral measure

\[
 \nu_{a,q}=\sum_{\chi\bmod q}
 \frac{\tau(\overline\chi)\chi(a)}{\varphi(q)}
 \sum_{\rho_{\chi^*}=1/2+i\gamma}
 \frac{m(\rho_{\chi^*})}{\gamma^2+1/4}\,\delta_\gamma .
 \tag{3.4}
\]

Up to the explicitly decaying normalized form of $A_\chi$ and (1.5), the
zero part of $X^{-1/2}\Phi_{a,q}(X)$, with $X=e^t$, is
$-\widehat\nu_{a,q}(t)$.

## 4. One fiber, two pair projections

The exact theorem lives in the graded signal, not in a scalar square. With

\[
A_{a,q}(z)=\sum_{n\geq1}\Lambda(n)e_q(an)z^n,
\]

formal coefficient extraction and Abel-smoothed angular extraction give

\[
\begin{aligned}
\sum_{m+n=N}\Lambda(m)\Lambda(n)
 &=e_q(-aN)[z^N]A_{a,q}(z)^2,\\
\sum_{n\geq1}\Lambda(n+h)\Lambda(n)r^{2n+h}
 &=e_q(-ah)[e^{ih\theta}]|A_{a,q}(re^{i\theta})|^2 .
                                                               \tag{4.1}
\end{aligned}
\]

The first identity holds in the formal power-series ring, with no convergence
hypothesis; the second is absolutely convergent for \(0<r<1\). The sharp
finite-\(X\) version is a finite Laurent-polynomial identity. A finite
Fourier projector modulo \(q\) selects \(m+n\equiv N\pmod q\) or
\(m-n\equiv h\pmod q\), not equality over the integers, unless an explicit
no-wrap support hypothesis is imposed. These boundaries are made precise in
RATIONAL_PAIR_CHANNEL.md.

The character block must also retain all cross terms. With

\[
\alpha_\chi(a)=\frac{\tau(\overline\chi)\chi(a)}{\varphi(q)},\qquad
A_{a,q}=\sum_{\chi\bmod q}\alpha_\chi(a)B_{\chi;q}+P_{a,q},
                                                               \tag{4.2}
\]

where \(B_{\chi;q}=A_{\chi^*}-E_{\chi;q}\) removes the Euler factors deleted
on induction from conductor \(f\) to modulus \(q\), and \(P_{a,q}\) restores
the prime powers with \(p\mid q\), the holomorphic block is

\[
\sum_{\chi,\psi\bmod q}\alpha_\chi(a)\alpha_\psi(a)
B_{\chi;q}B_{\psi;q}
+2P_{a,q}\sum_\chi\alpha_\chi(a)B_{\chi;q}+P_{a,q}^2.           \tag{4.3}
\]

The Hermitian block is

\[
\begin{aligned}
&\sum_{\chi,\psi\bmod q}
\alpha_\chi(a)\overline{\alpha_\psi(a)}
B_{\chi;q}\overline{B_{\psi;q}}\\
&\quad+\left(\sum_\chi\alpha_\chi(a)B_{\chi;q}\right)
      \overline{P_{a,q}}
+P_{a,q}\overline{\left(\sum_\psi\alpha_\psi(a)B_{\psi;q}\right)}
+|P_{a,q}|^2.                                                  \tag{4.4}
\end{aligned}
\]

In particular, replacing \(\overline{\alpha_\psi(a)}\) by a coefficient
indexed by \(\overline\psi\) introduces the factor \(\psi(-1)\), since
\(\overline{\alpha_\psi(a)}=\psi(-1)\alpha_{\overline\psi}(a)\).

After an explicit formula is substituted into these two graded blocks, the
zero--zero layers have the spectral descriptions

\[
\begin{array}{c|c|c}
\text{graded pair operation}&\text{zero-measure layer}&\text{frequencies}\\
\hline
\text{holomorphic coefficient}&
\nu_{a,q}*\nu_{a,q}&\gamma+\gamma'\\
\text{Hermitian angular coefficient}&
\nu_{a,q}*\widetilde{\overline{\nu}_{a,q}}&\gamma-\gamma'.
\end{array}                                                    \tag{4.5}
\]

Here \(\widetilde{\overline\nu}(E)=\overline{\nu(-E)}\). This table records
different algebraic constructions, but the underlying unlabeled measures
need not be different. In particular, for \(q=1\) under RH the
Matsumoto--Suzuki measure is positive and symmetric, so

\[
\widetilde{\overline{\nu}_{0,1}}=\nu_{0,1},\qquad
\nu_{0,1}*\widetilde{\overline{\nu}_{0,1}}
=\nu_{0,1}*\nu_{0,1}.                                         \tag{4.6}
\]

Thus the bare \(q=1\) product measure does **not** remember whether it came
from the Goldbach or gap construction. Their distinction survives in the
holomorphic versus Hermitian grading/projector (or in a labeled/chiral
two-zero space), not in the unlabelled positive measure. For general
rational fibers the Gauss-sum coefficients make \(\nu_{a,q}\) complex, and
the two convolutions can genuinely differ; positivity from \(q=1\) must not
be imported.

Expanding the uncentered signal in each fiber now gives one common ladder:

\[
 \boxed{
 \text{pole}\times\text{pole}=\mathfrak S,\qquad
 \text{pole}\times\text{zero}=\text{first variation},\qquad
 \text{zero}\times\text{zero}=\text{sum/difference spectrum}.}
 \tag{4.7}
\]

This is a language rotation, not a solution of the minor-arc problem.
The pole--pole line is the classical major-arc/Ramanujan layer. The
zero--zero measures in (4.5), including the absolutely summable min-kernel
measure from (3.4), are legitimate rank-one spectral transforms, but without
the coefficient or angular grade they are not pointwise Goldbach or fixed-gap
observables. Passing from the exact finite projectors to arithmetic
asymptotics still requires the classical uniform tail and minor-arc
estimates.

## 5. Prior-art boundary

The ingredients and much of their interaction are classical.

- Hardy--Littlewood's circle method already organizes primes near rational
  frequencies and produces the Ramanujan expansion (2.3).
- The pointwise normalization (3.2c) is the standard Davenport explicit
  formula; see also A. Granville,
  [*The prime number theorem for arithmetic progressions*, Chapter 11,
  equation (11.8.3)](https://dms.umontreal.ca/~andrew/Courses/Chapter11.pdf).
  Equations (3.3a)--(3.3d) are its elementary integration and the standard
  removal of imprimitive Euler factors, not a new explicit formula.
- Gadiyar and Padma, *Physica A* **269** (1999), 503--510,
  [DOI 10.1016/S0378-4371(99)00171-5](https://doi.org/10.1016/S0378-4371(99)00171-5),
  explicitly use Ramanujan--Fourier/Wiener--Khintchine language for prime
  pairs.
- Helfgott, *Major arcs for Goldbach's problem*,
  [arXiv:1305.2897](https://arxiv.org/abs/1305.2897), develops general
  Dirichlet-character explicit formulas at Goldbach major arcs.
- Bhowmik--Halupczok--Matsumoto--Y. Suzuki, *Mathematika* **65** (2019),
  57--97, [arXiv:1704.06103](https://arxiv.org/abs/1704.06103), directly
  relates averaged Goldbach representations in arithmetic progressions to
  zeros of Dirichlet $L$-functions.
- Rubinstein--Sarnak, *Experimental Mathematics* **3** (1994), 173--197,
  [DOI 10.1080/10586458.1994.10504289](https://doi.org/10.1080/10586458.1994.10504289),
  is prior art for organizing prime-race fluctuations by Dirichlet-zero
  spectra and their linear-independence questions.
- Connes--Consani, *Weil positivity and Trace formula, the archimedean
  place*, [arXiv:2006.13771](https://arxiv.org/abs/2006.13771), Appendix C,
  Proposition C.1, proves that Weil positivity remains equivalent to RH after
  imposing any finite Mellin-vanishing set containing $\{0,1\}$ and disjoint
  from the zeta zeros. Thus finite primitive/restricted test spaces are also
  prior art as RH detectors.

The potentially useful contribution here is narrower: the exact
`PRODUCT.md` min-kernel is installed at every rational Bost--Connes mode, and
the pole, first-variation, Goldbach-sum, and gap-difference layers are put in
one sharded computational schema.  Novelty is **not established**.

## 6. Proof and computation frontier

Equations (3.2a)--(3.3d) close the finite $A_\chi$ normalization obligation.
The next paper-grade obligation is different: choose a stated truncation
scheme for the nontrivial zeros, import certified zero enclosures through a
height $T$, and prove a rigorous tail bound uniform in a stated finite range
of conductors.  Until that is done, experiments involving truncated
Dirichlet-zero spectra remain discovery computations, even though all finite
constants in the formula can be certified.

`code/exp39_rational_fiber_normalization.py` performs the first falsifier:

1. a 200-bit complex-character check of (1.1) for $q=5$, followed by a
   separate von Mangoldt-weighted check of (1.2)--(1.3) through $n=200$ that
   distinguishes the $5^k$ local correction from composite non-prime-powers;
2. exact rational verification of (2.2) for every shift modulo $6$, and
   selected shifts modulo $30030$.

The test detects a missing $1/\varphi(q)$, a missing square in (2.2), the
wrong Gauss-sum conjugation, and omission of the prime-power correction.
Run it in the discovery environment, which supplies `mpmath`:

```bash
/tmp/avikj-math-venv/bin/python code/exp39_rational_fiber_normalization.py
```

The script code/exp40_dirichlet_Achi_normalization.py is the second
falsifier.  With python-flint/Arb it produces certified numerical enclosures at
256-bit precision; this is interval-arithmetic evidence, not a formal proof:

1. the odd $\chi_4$ and even quadratic $\chi_5$ definitions of $c_\chi$,
   their stable constants, and the common functional-equation expression;
2. the closed and positive-series forms of both $J_0$ and $J_1$, with
   explicit geometric tail majorants; and
3. the minus sign in (3.3d), using the character modulo $10$ induced by
   $\chi_5$ and its deleted $p=2$ Euler factor.

Run it with
/tmp/avikj-math-venv/bin/python code/exp40_dirichlet_Achi_normalization.py.
The mpmath fallback labels itself discovery-only, and the Arb script does not
claim a certified nontrivial-zero tail.

The scripts refuse optimized `python -O` execution so their checks cannot be
silently disabled. The dependency is recorded in `requirements-discovery.txt`.
