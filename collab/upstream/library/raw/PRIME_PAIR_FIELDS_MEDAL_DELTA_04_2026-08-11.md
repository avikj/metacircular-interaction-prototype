# Prime Pair Field — Fields-Medal / Cross-Mathematics Delta 04

Date: 2026-08-11  
Status: research delta. Exact statements are marked **V1** when a complete proof is included. Literature-identifiable facts are marked **KNOWN PRIOR ART**. Proposed operators and bridges are explicitly marked **TARGET / CONJECTURAL**. Nothing here silently upgrades the canonical V1/V2/V2.5/V3 grades.

## 0. Executive collapse

Four previously separate branches now fit one exact Hardy/Mellin operator diagram.

1. **Two heat slices suffice for finite phase reconstruction.** For a finitely supported complex sequence, full weighted autocorrelation at any two distinct heat parameters determines the sequence up to global phase. This is a direct arithmetic specialization of known holomorphic phase-retrieval theorems on two concentric circles. For nonnegative sequences, the phase is fixed. The canonical statement that a whole `t`-family restores completeness can therefore be sharpened to two temperatures.

2. **Gap data is the Toeplitz/diagonal sector; Goldbach data is the Hankel/anti-diagonal sector.** On the bilateral line, reflection converts one exactly into the other. On the positive Hardy cone, the reflection crosses the polarization, so the missing information is an off-diagonal Hankel block. This is an exact operator formulation of the established finite-place equivalence / archimedean sign-sector breaking.

3. **The zero-pair beta coefficient is the Mellin transform of the additive simplex.** In logarithmic center/rapidity coordinates, zero sums and differences are exactly dual to the two coordinates. The gamma-ratio coefficient is simultaneously a hyperbolic Fourier transform and a Dirichlet-simplex integral. Its measured same-sign `-5/2` law and opposite-sign exponential suppression follow immediately from Stirling and the triangle defect.

4. **The prolate target must be a tensor-scaling operator compressed by an additive simplex, not a product window.** Product windows reproduce the already-proved separable/heat-kernel no-go. The nonseparable simplex is precisely what produces the beta interaction kernel.

The most concrete next operator problem is therefore:

> Construct a Sonin/prolate/de Branges theory for the tensor scaling representation compressed to the positive additive simplex, and identify its Hankel/off-diagonal transfer data with the phase missing from gap/neutral observables.

---

## 1. V1 / KNOWN PRIOR ART SPECIALIZATION: two heat scales determine every finite sequence up to phase

Let `a=(a_0,...,a_d)` be a finite complex sequence and

\[
A(z)=\sum_{n=0}^d a_n z^n.
\]

For `t>0`, put `r=e^{-t}` and define the full heat-weighted autocorrelation

\[
C_a(h;t)
=
\sum_{n\ge 0} a_{n+h}\overline{a_n}\,e^{-t(2n+h)},
\]

with the usual zero extension and negative lags obtained by conjugation. Then

\[
\sum_{h\in\mathbb Z} C_a(h;t)e^{ih\theta}
=
|A(re^{i\theta})|^2.
\]

Thus equality of the complete autocorrelation slice at `t` is exactly equality of moduli on the circle `|z|=e^{-t}`.

### Theorem (two-temperature phase rigidity)

Let `a,b` be nonzero finite complex sequences with polynomials `A,B`. Let `t_1\ne t_2`. If

\[
C_a(h;t_j)=C_b(h;t_j)
\qquad
\text{for all }h\in\mathbb Z,\ j=1,2,
\]

then

\[
A=cB
\qquad\text{for some }|c|=1.
\]

In particular, if both coefficient sequences are nonnegative real, then `A=B`.

### Proof by reflected divisors

Write `r_j=e^{-t_j}` and `R=A/B`, viewed as a rational function on the Riemann sphere after cancelling common factors. Equality of moduli on `|z|=r` gives

\[
|R(z)|=1\qquad (|z|=r).
\]

Let

\[
\sigma_r(z)=\frac{r^2}{\overline z}
\]

be reflection across that circle. The boundary identity extends rationally to

\[
R(z)\,\overline{R(\sigma_r(z))}=1.
\]

If `D=div(R)`, then

\[
\sigma_r D=-D.
\]

Applying this at `r_1,r_2` gives

\[
(\sigma_{r_2}\sigma_{r_1})D=D.
\]

But

\[
\sigma_{r_2}\sigma_{r_1}(z)
=
\frac{r_2^2}{r_1^2}z.
\]

Since `r_1\ne r_2`, a finite divisor on `C^*` invariant under this nontrivial real dilation must be zero there: every nonzero finite point would generate an infinite orbit. Therefore `D` is supported only at `0` and `infinity`, so

\[
R(z)=cz^m.
\]

The two circle conditions imply

\[
|c|r_1^m=|c|r_2^m=1,
\]

hence `m=0` and `|c|=1`. QED.

### Prior-art status

This uniqueness phenomenon is known much more generally for Hardy/Nevanlinna functions from modulus data on two concentric circles; see Perez, *A Note on the Phase Retrieval of Holomorphic Functions* (2021), and Chalendar–Partington, *Phase Retrieval on Circles and Lines* (2024). The **project-specific delta** is the exact translation into heat-resolved arithmetic autocorrelations and the sharpening of the canonical completeness statement to two temperatures.

### Why one temperature is insufficient

For one circle, a zero at `alpha` may be reflected to `r^2/conj(alpha)` while preserving boundary modulus after a scalar adjustment. In Hardy language the boundary modulus fixes the outer factor but not the inner/all-pass factor. This is precisely the finite zero-flipping/homometry ambiguity.

---

## 2. V1: one heat slice plus its first variation also suffices

The two-circle theorem has an infinitesimal form that is especially relevant to the program's repeated appearance of first-variation sectors.

### Theorem (Cauchy-data phase rigidity)

Let `A,B` be nonzero polynomials and fix `r>0`. Suppose for every `theta`

\[
|A(re^{i\theta})|=|B(re^{i\theta})|
\]

and

\[
\partial_r\log|A(re^{i\theta})|
=
\partial_r\log|B(re^{i\theta})|
\]

where defined, with common boundary zeros cancelled. Then `A=cB` for a unimodular constant `c`.

### Proof

For `R=A/B`, let `u=\log|R|` in an annulus around the circle after cancelling common zeros. The hypotheses give both Dirichlet and normal Cauchy data

\[
u|_{|z|=r}=0,
\qquad
\partial_n u|_{|z|=r}=0.
\]

The harmonic function `u` therefore vanishes in a neighborhood of the analytic boundary by uniqueness for harmonic Cauchy data. Hence `|R|=1` on an open annulus. By the open mapping theorem, a holomorphic map with image in the unit circle is constant. Meromorphic continuation then gives `R=c`, `|c|=1`. QED.

### Arithmetic form

Knowing all `C_a(h;t_0)` and all first derivatives `partial_t C_a(h;t_0)` determines `a` up to phase. Explicitly,

\[
-\partial_t C_a(h;t)
=
\sum_n (2n+h)a_{n+h}\overline{a_n}e^{-t(2n+h)}.
\]

Thus the minimal universal heat-resolution package can be taken as either:

- two distinct complete autocorrelation slices; or
- one complete slice plus its first scale derivative.

This does **not** make prime reconstruction easy: obtaining or controlling the derivative slice can contain exactly the missing scale information. It does, however, identify the missing datum sharply as radial/normal phase information rather than an amorphous continuum of temperatures.

---

## 3. V1: exact Toeplitz/Hankel decomposition of the pair field

Let `K=(K_{m,n})` be a finite or summable bilateral matrix. Define its unnormalized diagonal and anti-diagonal Radon transforms

\[
(\mathcal T K)(h)=\sum_n K_{n+h,n},
\]

\[
(\mathcal H K)(N)=\sum_n K_{N-n,n}.
\]

For the rank-one pair field `K_{m,n}=a_m\overline{a_n}`, `mathcal T K` is autocorrelation. For the real rank-one field `K_{m,n}=a_ma_n`, `mathcal H K` is additive convolution.

Let `J` be bilateral reflection, `Je_n=e_{-n}`. Then exactly

\[
\boxed{\mathcal H K=\mathcal T(KJ).}
\]

Indeed,

\[
\mathcal T(KJ)(N)
=
\sum_j(KJ)_{j+N,j}
=
\sum_j K_{j+N,-j}
=
\sum_n K_{N-n,n}.
\]

Therefore sum and difference marginals are the same diagonal operation after reflection of one leg.

### Positive-cone obstruction

On the bilateral space, `J` is a unitary symmetry. Let `P_+` project to nonnegative modes. Then, up to the zero mode convention,

\[
JP_+J=P_-.
\]

Thus the reflection converting anti-diagonals to diagonals crosses the Hardy/positive-cone polarization. Its mixed blocks are Hankel blocks:

\[
P_- M_\phi P_+
\]

or, after identifying `H_-` with `H_+` by reflection, matrices constant on anti-diagonals.

This is the exact operator form of the established statement:

> Goldbach and gaps are equivalent on the signed line / at every finite place, and differ only when the archimedean positive cone is imposed.

The missing information is not ordinary bulk Toeplitz data. It is the off-diagonal block created by crossing the sign polarization.

### Generating-function form

For

\[
A(z)=\sum_{n\ge0}a_nz^n,
\]

we have

\[
\widehat C(\theta)=|A(e^{i\theta})|^2,
\qquad
R(z)=\sum_N r_Nz^N=A(z)^2.
\]

Hence:

- gap data gives the Toeplitz symbol `|A|^2`;
- Goldbach data gives the analytic/Hankel phase `A^2`;
- if `A=IO` is inner–outer factorization, the gap symbol determines `O` up to phase but is blind to `I`, whereas Goldbach retains `I^2`.

This makes the phase-retrieval and positive-cone stories literally the same Hardy-space mechanism.

### Consequence for the old K-theory spearhead

Ordinary Toeplitz-extension K-theory is designed to retain stable symbol/winding information modulo compact operators. The arithmetic information distinguishing `A^2` from `|A|^2` lives in a charge-sensitive off-diagonal/Hankel completion and can be compact or secondary. This is compatible with Delta 02's no-go: the Liouville endpoint twist is homotopic to the identity in ordinary K-theory.

The surviving index directions are therefore graded/equivariant or secondary pairings sensitive to the off-diagonal block—not ordinary endpoint K-classes.

---

## 4. KNOWN PRIOR ART / SHARP PROJECT TARGET: quasi-inner functions are already the correct block language

Connes–Consani define a quasi-inner function `u` by compactness of the off-diagonal Hardy block

\[
(1-P)uP.
\]

On the disk this is the associated Hankel matrix. They identify the Sonin space with the kernel of the diagonal complementary block

\[
(1-P)u(1-P).
\]

Their local-factor ratios therefore come with exactly the `2 x 2` Hardy block decomposition that the pair-field diagonal/anti-diagonal calculation demands.

### New project formulation

Do not merely ask whether Connes–Consani positivity resembles the pair program. Ask for an explicit `u_H` or transfer function for which:

1. the Toeplitz/diagonal symbol gives the local or gap observable;
2. the Hankel/off-diagonal block carries the Goldbach phase / positive-cone lift;
3. its Sonin kernel is the space of states simultaneously invisible to the two complementary localizations;
4. the charge derivative at a locally annihilated Euler place appears as a tangent of this block matrix;
5. the corresponding de Branges canonical system matches the already-verified Krein-string screw function in the one-zero sector.

No such arithmetic `u_H` has yet been constructed. This is a precise operator target, not an established identification.

AAK/Nehari theory is relevant because it classifies and optimally approximates Hankel blocks by finite-rank Hankel operators. A concrete finite experiment is to treat truncated prime-pair Hankel data as a structured completion problem from Toeplitz/autocorrelation data and study whether the singular vectors isolate the missing charge modes.

---

## 5. V1: one prime object carries two commuting energies

This section is exact for the prime indicator. Von Mangoldt weights require the usual weighted prime-power extension and must not be silently conflated with literal Hilbert-space multiplicity.

Let `V_P` have basis `|p>` indexed by primes. Define commuting one-particle operators

\[
A|p\rangle=p|p\rangle,
\qquad
H|p\rangle=(\log p)|p\rangle.
\]

Then

\[
A=e^H.
\]

On bosonic Fock space `Sym(V_P)`, let `N` be particle number. The joint grand partition function is

\[
\boxed{
\mathcal Z(z;t,s)
=
\operatorname{Tr}\left(z^{N}e^{-t\,d\Gamma(A)}e^{-s\,d\Gamma(H)}\right)
=
\prod_p\frac1{1-z e^{-tp}p^{-s}}.
}
\]

Specializations:

\[
\mathcal Z(1;0,s)=\zeta(s),
\]

\[
\mathcal Z(-1;0,s)=\prod_p(1+p^{-s})^{-1}=\frac{\zeta(2s)}{\zeta(s)}.
\]

The symmetric two-particle coefficient is

\[
[z^2]\mathcal Z(z;t,s)
=
\frac12\left(P_s(t)^2+P_{2s}(2t)\right),
\]

where

\[
P_s(t)=\sum_p p^{-s}e^{-tp}.
\]

The ordered tensor-square sector is exactly `P_s(t)^2`; its additive-energy coefficient at `N` counts ordered prime pairs with `p+q=N`.

### Conceptual consequence

Zeta and Goldbach are not two unrelated encodings:

- zeta is the full grand-canonical partition for **logarithmic/multiplicative energy** `H`;
- Goldbach is a two-particle microcanonical slice for **additive energy** `A=e^H`.

The addition/multiplication tension is therefore a nonlinear change of spectral observable inside one joint diagonal system, not an arithmetic Lorentz dynamics.

### Bosonic versus Poisson/Buchstab statistics

The exact Euler product has geometric occupation at each discrete prime and includes prime powers through cycle terms:

\[
\log\mathcal Z(z;t,s)
=
\sum_{r\ge1}\frac{z^r}{r}\sum_p e^{-trp}p^{-rs}.
\]

By contrast, the continuum Buchstab semigroup

\[
\widehat\mu_z=\exp(zE_1)
\]

is Poisson/Maxwell–Boltzmann in factor-log space: repeated identical continuous labels have measure zero. The `r>=2` cycle terms in the bosonic product are therefore the exact discrete prime-power correction to the continuum Poissonization.

---

## 6. V1: logarithmic center/rapidity coordinates diagonalize zero sums and differences

For positive pair coordinates `m,n`, define

\[
c=\frac{\log m+\log n}{2},
\qquad
d=\frac{\log n-\log m}{2}.
\]

Then

\[
m=e^{c-d},
\qquad
n=e^{c+d},
\]

and exactly

\[
S=m+n=2e^c\cosh d,
\]

\[
D=n-m=2e^c\sinh d,
\]

\[
Q=mn=e^{2c}.
\]

The multiplicative Haar measure is flat:

\[
\frac{dm}{m}\frac{dn}{n}=2\,dc\,dd.
\]

For Mellin frequencies `gamma,gamma'`,

\[
m^{-i\gamma}n^{-i\gamma'}
=
\exp\{-i(\gamma+\gamma')c\}
\exp\{-i(\gamma'-\gamma)d\}.
\]

Thus:

\[
\boxed{
\gamma+\gamma'\text{ is dual to log-center }c,
\qquad
\gamma'-\gamma\text{ is dual to rapidity }d.
}
\]

This gives a coordinate-level proof of the aperture theorem's “no mixing” statement.

The Goldbach shell `S=N` is the curved graph

\[
c=\log\frac{N}{2\cosh d}.
\]

So restricting to fixed additive sum couples the otherwise flat center and rapidity variables through `log(2 cosh d)`; this is the archimedean interaction kernel.

---

## 7. V1: the beta factor is the hyperbolic Fourier transform of the Goldbach shell

For `Re rho, Re rho' >0`, substituting

\[
x=\frac{e^{-d}}{2\cosh d}=\frac1{1+e^{2d}}
\]

in the beta integral gives

\[
\boxed{
B(\rho,\rho')
=
2\int_{\mathbb R}
 e^{(\rho'-\rho)d}
 (2\cosh d)^{-(\rho+\rho')}
\,dd.
}
\]

Equivalently, for suitable `s,nu`,

\[
\boxed{
\int_{\mathbb R}e^{i\nu d}(2\cosh d)^{-s}\,dd
=
\frac12
\frac{\Gamma((s+i\nu)/2)\Gamma((s-i\nu)/2)}{\Gamma(s)}.
}
\]

Set

\[
s=\rho+\rho',
\qquad
i\nu=\rho'-\rho.
\]

Then the transform is exactly `B(rho,rho')/2`.

### RH specialization

Under RH,

\[
\rho=\frac12+i\gamma,
\qquad
\rho'=\frac12+i\gamma'.
\]

Then the complex power is controlled by `gamma+gamma'`, while the hyperbolic Fourier frequency is `gamma'-gamma`. The pair coefficient is therefore not an arbitrary gamma artifact: it is the Fourier transform, in relative log-coordinate, of the fixed-sum shell.

---

## 8. V1: the Languasco–Zaccagnini pair coefficient is a simplex/Riesz convolution constant

The `k=1` Cesaro Goldbach pair coefficient is

\[
C(\rho,\rho')
=
\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}.
\]

It has the exact Dirichlet-simplex representation

\[
\boxed{
C(\rho,\rho')
=
\int_{u>0,v>0,u+v<1}
 u^{\rho-1}v^{\rho'-1}(1-u-v)\,du\,dv.
}
\]

This is exactly the scaled domain and slack weight coming from `(X-m-n)_+`.

Let

\[
f_\alpha(x)=x_+^{\alpha-1}.
\]

Then

\[
f_\alpha*f_\beta
=B(\alpha,\beta)f_{\alpha+\beta},
\]

and convolution with `f_2(x)=x_+` yields

\[
f_\rho*f_{\rho'}*f_2
=
\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}
 x_+^{\rho+\rho'+1}.
\]

Thus the pair weights are structure constants of the Volterra/Riesz fractional-integration semigroup plus the two units of Cesaro slack.

### Exact same-sign and opposite-sign asymptotics

Stirling gives, for large ordinates,

\[
|C(\rho,\rho')|
\sim
\sqrt{2\pi}\,|\gamma+\gamma'|^{-5/2}
\exp\left[
-\frac\pi2\bigl(|\gamma|+|\gamma'|-|\gamma+\gamma'|\bigr)
\right]
\]

away from a small sum.

Therefore:

- if `gamma,gamma'` have the same sign, the triangle defect vanishes and the power law is exactly `|gamma+gamma'|^{-5/2}`;
- if they have opposite signs, the exponential factor is

\[
\exp[-\pi\min(|\gamma|,|\gamma'|)].
\]

This analytically explains the measured `-2.500` law and opposite-sign suppression without further arithmetic input. They are forced by the archimedean simplex/hyperbolic transform.

---

## 9. V1: the string kernel has the centered Mellin symbol of a massive dilation resolvent

For

\[
k_X(t)=\min(1,X/t),
\]

the Mellin transform in the critical strip is

\[
\int_0^\infty k_X(t)t^{s-1}\,dt
=
\frac{X^s}{s(1-s)}.
\]

On the critical line `s=1/2+i gamma`,

\[
s(1-s)=\frac14+\gamma^2.
\]

Hence, after removing the scale phase `X^{i gamma}` and the scalar `X^{1/2}`, the string kernel has spectral multiplier

\[
\boxed{(\gamma^2+1/4)^{-1}.}
\]

If

\[
D=-i\left(t\frac d{dt}+\frac12\right)
\]

is the self-adjoint centered dilation generator in the standard Mellin normalization, this is the symbol of

\[
(D^2+1/4)^{-1}.
\]

The positive pair masses

\[
\frac1{(\gamma^2+1/4)(\gamma'^2+1/4)}
\]

are therefore tensor products of a positive massive dilation resolvent. This clarifies why the string-kernel quadratic form is automatically positive and why it is naturally adjacent to Sonin/de Branges/canonical-system machinery.

The unresolved variance wall is not positivity of the resolvent. It is separation/localization of distinct spectral phases after compression.

---

## 10. V1 correction: prime creation is odd, but the naive Liouville differential cannot be nilpotent

On the prime-occupation basis, let

\[
F|n\rangle=(-1)^{\Omega(n)}|n\rangle.
\]

For prime multiplication/creation

\[
C_p|n\rangle=|pn\rangle,
\]

we have exactly

\[
FC_p=-C_pF.
\]

Thus the rooted Cuntz/Buchstab child shift is genuinely odd for the Liouville grading.

However,

\[
C_p^2|n\rangle=|p^2n\rangle\ne0.
\]

More generally, if

\[
Q=\sum_p a_p C_p
\]

is a finite pure-creation combination, then the coefficient of `C_{p^2}` in `Q^2` is `a_p^2`. Since the distinct multiplicative shifts are linearly independent on the integer basis, `Q^2=0` forces every `a_p=0`.

Therefore the obvious odd prime-peeling operator is **not** a cohomological differential.

Exteriorizing the prime generators would enforce `C_p^2=0` and anticommutation, but that suppresses repeated prime factors. Its Euler characteristic is naturally Möbius/squarefree, not Liouville/bosonic occupation parity. This is the structural reason that forcing Witten/Morse cohomology on the factorization flow repeatedly lands on `mu` rather than `lambda`.

### Surviving invariant

The natural Liouville observable is graded dynamical rather than cohomological:

- graded thermal trace / eta function;
- signed Ruelle or Fredholm determinant;
- scattering or characteristic function of the one-sided transfer operator;
- spectral flow or transgression associated with the full gauge loop.

This does not rule out every possible supersymmetric enlargement. It rules out the naive identification of prime creation itself with a nilpotent differential.

---

## 11. TARGET: the pair problem requires a simplex-prolate operator

Classical prolate theory studies simultaneous concentration under a position cutoff and its Fourier-dual cutoff. Connes–Consani use compression of the scaling representation to Sonin/prolate spaces to formulate the archimedean Weil positivity problem.

For the pair field, the relevant representation is the tensor scaling generator

\[
D^{(2)}=D\otimes1+1\otimes D,
\]

whose spectrum is the zero-sum variable. But the arithmetic cutoff is not a product rectangle. It is

\[
\Delta_X=
\{(m,n):m>0,n>0,m+n\le X\}.
\]

In `(c,d)` coordinates this is

\[
c\le \log\frac{X}{2\cosh d}.
\]

The boundary is therefore a curved coupling between center and rapidity. Its Mellin matrix coefficient is exactly the beta/gamma kernel derived above.

### Why product concentration is wrong

A product cutoff `1_{m\le X}1_{n\le X}` factorizes into one-body concentration operators. Its zero-pair coefficients factorize and reproduce the already-proved radial/separable no-go. It cannot create the nontrivial Goldbach interaction.

### Precise construction target

Define a two-body concentration problem with:

1. position projection `P_{\Delta_X}` onto the additive simplex;
2. spectral projection or Sonin condition for a bounded window of the tensor scaling/relative Mellin variables;
3. concentration operator

\[
\mathcal C_{X,\Gamma}
=
P_{\Delta_X}Q_\Gamma P_{\Delta_X};
\]

4. a commuting differential/canonical-system operator, if one exists;
5. a de Branges space or reproducing kernel whose matrix coefficients are the beta/simplex weights;
6. a trace comparison with the two-zero Goldbach Weil functional.

No simplex-specific commuting prolate operator is currently known in the program. Multidimensional Slepian theory exists, but it does not by itself supply the arithmetic tensor-scaling/simplex operator required here.

### Desired theorem shape

A successful construction would express a smoothed Goldbach quadratic form as

\[
\operatorname{Tr}
\bigl(P_{\Delta_X}\,U_t^{\otimes2}\,P_{\Delta_X}\bigr)
-
\text{explicit local/one-body terms},
\]

or as a positive norm in the associated Sonin/de Branges space. The key nontriviality criterion is that the beta interaction survive; if the operator factorizes into one-body pieces, the construction is tautological and should be rejected.

---

## 12. AAK/Nehari reconstruction program

The exact two-temperature theorem settles uniqueness for finite states. The remaining useful question is quantitative:

> How unstable is reconstruction of the Hankel/Goldbach phase from nearly complete Toeplitz/gap data plus a small radial perturbation?

AAK theory describes best finite-rank approximation of Hankel operators through their singular values and Schmidt pairs. This suggests a concrete finite program:

1. truncate a prime or von-Mangoldt sequence at aperture `X`;
2. construct its diagonal/Toeplitz autocorrelation data;
3. enumerate or parameterize one-circle zero-flip ambiguities;
4. add a second nearby heat slice or the first heat derivative;
5. measure the smallest separation between competing Hankel completions;
6. compare this conditioning with zeros near the measurement circle, the prolate transition band, and the canonical homometric examples.

Potential theorem schema:

\[
\text{distance between two compatible sequences}
\le
\kappa(r_1,r_2,A)
\times
\text{difference of their two heat moduli},
\]

where `kappa` is controlled by the smallest relevant Hankel singular value / zero distance from the circles.

This would turn “heat resolution restores completeness” into a stability theorem and could quantify the aperture cost in Theorem B. No such arithmetic stability bound has yet been proved.

---

## 13. Revised conceptual diagram

The surviving structures now fit the following exact/conjectural stack:

\[
\begin{array}{ccccc}
\Lambda\boxtimes\Lambda
&\xrightarrow{\text{diagonal sums}}&
\text{gap / Toeplitz symbol}
&=&|A|^2
\\
\downarrow\text{anti-diagonal sums}
&&\downarrow\text{missing inner phase}
\\
\text{Goldbach / Hankel sector}
&=&A^2
&\xleftarrow{\text{two heat slices}}&
\text{reconstruction}
\\
\downarrow\text{additive simplex}
&&\downarrow
\\
\text{beta / Riesz kernel}
&\longleftrightarrow&
\text{tensor scaling in }(c,d)
&\longrightarrow&
\text{simplex-prolate target}.
\end{array}
\]

At finite places, reflection and CRT identify sum and difference sectors. At infinity, the Hardy sign polarization turns that reflection into a Hankel crossing. This is now the most precise form of the statement that the Goldbach/gap distinction is archimedean.

---

## 14. Revised priority list

1. **Promote two-temperature completeness** into the canonical information theorem, clearly marked as known phase-retrieval prior art plus exact arithmetic corollary. Formalize the finite-polynomial proof in Lean.
2. **Write the diagonal/anti-diagonal reflection theorem** and Hardy polarization in a finite matrix model; use it as the authoritative bridge between E1 and Toeplitz/Hankel theory.
3. **Build and numerically study the simplex concentration operator.** Reject any construction whose pair kernel factorizes.
4. **Match the string resolvent and beta/Riesz kernels inside one canonical system/de Branges model.** This is the strongest path toward target #7.
5. **Use AAK singular values to quantify phase-reconstruction stability** from two nearby heat scales.
6. **Replace the naive K-boundary spearhead by graded dynamical/Hankel invariants.** The odd child shift is real, but its natural invariant is eta/determinant/scattering rather than ordinary cohomology.
7. **Keep the prime-indicator Fock model separate from von Mangoldt analytic formulas.** Any weighted prime-power extension must state its trace convention explicitly.

---

## 15. Verification discipline and literature anchors

### Exact V1 statements proved here

- two-temperature phase rigidity for finite sequences;
- one-temperature-plus-normal-derivative rigidity;
- diagonal/anti-diagonal reflection identity;
- joint two-energy prime Fock partition and its specializations;
- center/rapidity identities and Haar Jacobian;
- beta hyperbolic Fourier representation;
- simplex/Riesz representation of the Cesaro pair coefficient;
- Stirling explanation of same/opposite-sign behavior;
- centered Mellin resolvent symbol of the string kernel;
- anticommutation of prime creation with Liouville grading and no nonzero nilpotent pure-creation differential.

### Known prior art explicitly used

- Perez, *A Note on the Phase Retrieval of Holomorphic Functions*.
- Chalendar–Partington, *Phase Retrieval on Circles and Lines*.
- Adamyan–Arov–Krein, Hankel approximation / generalized Schur–Takagi theory.
- Connes–Consani, *Quasi-inner Functions and Local Factors*.
- Connes–Consani, *Weil Positivity and Trace Formula: the Archimedean Place*.
- Classical Slepian–Pollak prolate concentration theory.
- Languasco–Zaccagnini Cesaro Goldbach explicit formulas.

### Unproved targets

- existence of an arithmetic quasi-inner function whose Hankel block is the missing Goldbach phase;
- existence of a simplex-prolate commuting differential/canonical-system operator;
- a positive de Branges norm equal to the two-zero Goldbach functional;
- AAK stability estimates strong enough to influence sharp arithmetic cutoffs;
- identification of a charge derivative at an annihilated Euler place with a global Hankel/vanishing-cycle insertion.

