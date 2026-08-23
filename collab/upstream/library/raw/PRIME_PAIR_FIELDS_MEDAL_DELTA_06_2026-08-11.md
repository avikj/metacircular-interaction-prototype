# Prime Pair Field — Fields-Medal / Cross-Mathematics Delta 06

Date: 2026-08-11

Status: research delta. Exact identities and proofs are marked V1. Numerical singular values are exploratory/V2-style checks, not exact certificates. Literature identifications are prior art; the project contribution is the precise placement of the Prime Pair Field zero-pair kernel inside that machinery.

## 0. Executive change in direction

Three developments materially sharpen the spectral/prolate branch.

1. **The beta coefficient in the two-zero Goldbach formula is an analytically continued Meixner density.** On RH, zero difference is the Meixner spectral variable, while zero sum is the complex convolution-time / representation parameter. This is an exact explanation of the previously measured no-mixing coordinates.
2. **The relevant orthogonal-polynomial system is Meixner–Pollaczek / SU(1,1).** Its Jacobi matrix is explicit. The Languasco–Zaccagnini pair coefficient is the cyclic spectral density of this Jacobi family, continued from real positive parameter to the vertical line `Re(s)=1`, followed by the Cesaro smoothing resolvent `1/[s(s+1)]`.
3. **The prolate target lands on an explicit open problem.** F. Alberto Grünbaum (2025) asks whether an appropriate Meixner–Pollaczek time-and-band-limiting problem exhibits the Slepian commutativity miracle. This is nearly exactly the operator-theoretic bridge independently demanded by the Prime Pair Field program.

A fourth finite-dimensional result completes the minimal homometry example: its phase defect consists of two paired non-topological Hankel singular values plus one excess unit singular value carrying the winding/index. Ordinary K-theory sees only the excess unit mode.

---

## 1. V1: beta kernel equals a Meixner convolution density

For complex `s` with `Re(s)>0` and real `nu`, define

\[
 m_s(\nu)
 =
 \frac{2^{s-2}}{\pi\Gamma(s)}
 \Gamma\!\left(\frac{s+i\nu}{2}\right)
 \Gamma\!\left(\frac{s-i\nu}{2}\right).
\]

For real `s>0`, the two gamma factors are conjugates and `m_s(nu)>=0`.

### Fourier identity

With the convention that the inverse Fourier transform has factor `1/(2pi)`, one has

\[
\int_{\mathbb R} e^{i\nu d}\,\operatorname{sech}(d)^s\,dd
=
2^{s-1}
B\!\left(\frac{s+i\nu}{2},\frac{s-i\nu}{2}\right),
\]

hence

\[
\boxed{
 m_s(\nu)
 =
 \frac1{2\pi}
 \int_{\mathbb R}e^{i\nu d}\operatorname{sech}(d)^s\,dd.
}
\]

Proof: put `x=(1+tanh d)/2`. Then

\[
d=\frac12\log\frac{x}{1-x},\qquad
\operatorname{sech}d=2\sqrt{x(1-x)},\qquad
 dd=\frac{dx}{2x(1-x)},
\]

and the integral becomes the beta integral directly.

For real `s>0`, `m_s(nu)dnu` is therefore a probability measure because its characteristic function is

\[
\widehat m_s(d)=\operatorname{sech}(d)^s,
\qquad \widehat m_s(0)=1.
\]

### Exact convolution semigroup

Pointwise multiplication of characteristic functions gives

\[
\operatorname{sech}(d)^{s_1+s_2}
=
\operatorname{sech}(d)^{s_1}\operatorname{sech}(d)^{s_2},
\]

so

\[
\boxed{m_{s_1}*m_{s_2}=m_{s_1+s_2}.}
\]

Thus `s` is literally an additive convolution time. This is the symmetric Meixner Levy process, in the parameter convention `a=2`, `b=0`, `d=s/2`, `m=0`.

### Levy–Khintchine exponent

The Weierstrass product

\[
\cosh d
=
\prod_{n\ge0}
\left(1+\frac{d^2}{\pi^2(n+1/2)^2}\right)
\]

and

\[
\log\left(1+\frac{d^2}{a^2}\right)
=2\int_0^\infty(1-\cos(dx))e^{-ax}\frac{dx}{x}
\]

give

\[
\log\operatorname{sech}(d)^s
=
\int_{\mathbb R}(\cos(dx)-1)
\frac{s}{2|x|\sinh(\pi|x|/2)}\,dx.
\]

Therefore the symmetric Meixner Levy measure is

\[
\boxed{
\Pi_s(dx)
=
\frac{s}{2|x|\sinh(\pi|x|/2)}\,dx.
}
\]

It is a pure-jump, infinite-activity/infinite-variation flow. This formula agrees with the standard Meixner-process Levy measure after the stated parameter specialization.

### Useful special cases

\[
 m_1(\nu)=\frac1{2\cosh(\pi\nu/2)},
\]

the hyperbolic-secant law, and

\[
 m_2(\nu)=\frac{\nu}{2\sinh(\pi\nu/2)}.
\]

These are exactly the first two densities highlighted in the SL(2,R)/Meixner–Pollaczek discussion in Grünbaum's 2025 survey.

---

## 2. V1: exact Meixner form of the Languasco–Zaccagnini pair coefficient

For a zero pair `(rho,rho')`, put

\[
 s=\rho+\rho',
 \qquad
 \nu=-i(\rho-\rho').
\]

Then

\[
 \rho=\frac{s+i\nu}{2},
 \qquad
 \rho'=\frac{s-i\nu}{2}.
\]

The basic beta factor is

\[
B(\rho,\rho')
=
\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(s)}
=
\pi 2^{2-s}m_s(\nu).
\]

For the `k=1` Cesaro Goldbach formula, the exact coefficient is

\[
C(\rho,\rho')
=
\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}.
\]

Since `Gamma(s+2)=s(s+1)Gamma(s)`, one obtains

\[
\boxed{
C(\rho,\rho')
=
\frac{\pi 2^{2-s}}{s(s+1)}m_s(\nu).
}
\]

Thus Cesaro smoothing is the elementary two-step resolvent multiplier `1/[s(s+1)]` applied to the analytically continued Meixner kernel.

### RH coordinates

Under RH, write

\[
\rho=\frac12+i\gamma,
\qquad
\rho'=\frac12+i\gamma'.
\]

Then

\[
\boxed{
 s=1+i(\gamma+\gamma'),
 \qquad
 \nu=\gamma-\gamma'.
}
\]

Therefore:

- `gamma-gamma'` is the Meixner spectral variable;
- `gamma+gamma'` is the imaginary part of the convolution-time / representation parameter;
- the two variables enter in categorically different slots and do not mix.

This is an exact operator/probability explanation of the program's aperture theorem B.

The same-sign and opposite-sign regimes are now two asymptotic regimes of one kernel:

- same-sign pairs make the complex time `s` large in imaginary part while the spectral difference may remain moderate;
- opposite-sign pairs make `|nu|` large while the imaginary part of `s` may cancel, exposing the exponential tails of the Meixner density.

The measured polynomial versus exponential behavior is therefore structurally forced by the gamma/Meixner kernel, not an incidental numerical feature.

---

## 3. V1 / known prior art: the exact Meixner–Pollaczek Jacobi operator

For real `s>0`, let `Q_n^{(s)}` be the monic polynomials defined by

\[
Q_0^{(s)}(\nu)=1,
\qquad
Q_1^{(s)}(\nu)=\nu,
\]

\[
\boxed{
Q_{n+1}^{(s)}(\nu)
=
\nu Q_n^{(s)}(\nu)
-
 n(n+s-1)Q_{n-1}^{(s)}(\nu).
}
\]

These are the symmetric Meixner–Pollaczek polynomials after the scale change `nu=2x`, with parameter `lambda=s/2`. They are orthogonal for `m_s(nu)dnu`.

In the corresponding orthonormal basis, multiplication by `nu` is the Jacobi operator

\[
J_s e_n
=
\sqrt{(n+1)(n+s)}\,e_{n+1}
+
\sqrt{n(n+s-1)}\,e_{n-1}.
\]

Its cyclic spectral measure at `e_0` is exactly `m_s(nu)dnu`.

For real `s>0`, this Jacobi system is the positive discrete-series `SU(1,1)` representation with Bargmann parameter `s/2`; Meixner–Pollaczek polynomials occur as overlap coefficients between natural bases. This is established prior art.

For complex `s`, `J_s` is an analytic, generally non-self-adjoint continuation. The Goldbach zero-pair coefficient samples the cyclic spectral-density formula on the vertical line

\[
\operatorname{Re}s=1.
\]

Consequently the two-zero field has an explicit candidate one-dimensional model:

> a vertical analytic continuation of the `SU(1,1)` Meixner–Pollaczek Jacobi family, with zero difference as spectral coordinate and zero sum as complex representation weight, followed by the Cesaro resolvent.

### Relation to Grünbaum's parameter

Grünbaum writes the monic recurrence

\[
q_j^{[k]}(x)
=xq_{j-1}^{[k]}(x)
-(j-1)(j+2k)q_{j-2}^{[k]}(x).
\]

Comparing coefficients gives

\[
 s=2(k+1).
\]

On RH,

\[
 k=-\frac12+\frac{i}{2}(\gamma+\gamma').
\]

At zero sum, `gamma+gamma'=0`, the pair kernel lies exactly at the boundary value `k=-1/2` singled out by Grünbaum, whose orthogonality density is the hyperbolic-secant law. Zero sums move vertically away from that boundary into complex representation parameter.

---

## 4. Target #7 collapses onto a named open Meixner–Pollaczek prolate problem

In *Time and Band Limiting: From the Early Days to the Present* (2025), F. Alberto Grünbaum explains that the Meixner–Pollaczek system may be regarded as bispectral, with one operator of infinite order, and explicitly asks whether appropriate time-and-band-limiting versions exhibit the Slepian commuting-operator miracle.

The Prime Pair Field independently arrived at exactly this need:

- the spectral weight is now proved to be Meixner–Pollaczek;
- hard truncation of zero ordinates is an ill-conditioned concentration problem;
- a commuting low-complexity operator is the desired prolate certificate;
- Connes–Consani already connect prolate/Sonin operators with the zeta explicit formula.

This is a very strong convergence, but not a solution.

### Concrete real-parameter laboratory

Let

\[
\mathcal F_s:\ell^2(\mathbb N_0)\to L^2(\mathbb R,m_s(\nu)d\nu)
\]

be the Meixner–Pollaczek spectral transform sending `e_n` to the normalized polynomial of degree `n`. Define

\[
P_N=1_{\{0,\ldots,N\}},
\qquad
B_\Omega=1_{[-\Omega,\Omega]}(\nu).
\]

The concentration operator is

\[
K_{N,\Omega}^{(s)}
=
P_N\mathcal F_s^{-1}B_\Omega\mathcal F_sP_N.
\]

The first exact target is:

> Construct a sparse self-adjoint operator `L_{N,Omega}^{(s)}` commuting with `K_{N,Omega}^{(s)}`, or prove a no-go in the naive hard-band formulation and identify the correct reflecting/soft-band replacement.

Then:

1. analytically continue `s` to `Re(s)=1`;
2. incorporate the Cesaro multiplier `1/[s(s+1)]`;
3. pass from a one-parameter rectangular cutoff to the actual two-zero diamond/simplex cutoff
   `|Sigma+Delta|<=2T`, `|Sigma-Delta|<=2T`;
4. compare the resulting compressed trace/pairing with the Goldbach Weil form.

This should replace the vague phrase “prolate/Connes–Consani bridge.”

### Important caveat

Meixner–Pollaczek polynomials have a three-term Jacobi recurrence in degree but their dual spectral equation uses imaginary shifts / an infinite-order real operator. The usual Slepian boundary cancellation is therefore not automatic. This is precisely why Grünbaum presents the time-band problem as open.

---

## 5. Three exact semigroup layers now coexist

The program contains three mathematically distinct but structurally parallel flows.

### Finite-prime parity heat flow

For shifts distinct modulo `p`, local parity averaging on the Walsh cube has eigenvalue

\[
1-\frac{2j}{p+1}
\]

on degree `j`. Products over primes give effective heat time `sum_{p<=Y}1/p ~ log log Y` and scaling dimension `2j`.

### Factorization-scale Buchstab flow

The exact charge-deformed Buchstab measure is

\[
\mu_z^{\mathrm B}=\exp_*(z f),
\qquad
f(u)=1_{u\ge1}\frac{du}{u},
\]

with

\[
\mathcal L\mu_z^{\mathrm B}(r)=\exp(zE_1(r)).
\]

Here `z` is composition-length fugacity; `z=-1` is the Liouville supertrace and convolution inverse of `z=1`.

### Archimedean rapidity/zero-pair flow

The Meixner measures satisfy

\[
\widehat m_s(d)=\operatorname{sech}(d)^s,
\qquad
m_{s_1}*m_{s_2}=m_{s_1+s_2},
\]

with Levy measure

\[
\Pi_s(dx)=\frac{s}{2|x|\sinh(\pi|x|/2)}dx.
\]

Here `s` is the total zero weight/complex time and `nu` is zero difference.

### Candidate synthesis, not yet a theorem

These look like the three local pieces of an **adelic Levy/reconstruction architecture**:

- finite places: discrete coordinate-flip jumps in parity space;
- scale/factorization: one-sided prime-log jumps;
- archimedean place: symmetric rapidity jumps.

All are exponentials of infinitesimal generators and all make the hard arithmetic observable a boundary/analytic-continuation problem rather than an equilibrium average. A useful theory would need to couple these generators, not merely place their formulas beside one another.

---

## 6. V1/V2.5: exact phase-defect ranks of the minimal homometric pair

The minimal homometric pair factors as

\[
P_A=(z^2+1)(z^4+z+1)g(z),
\qquad
P_B=(z^2+1)(z^4+z+1)f(z),
\]

where

\[
g(z)=z^5-z^3+1,
\qquad
f(z)=z^5-z^2+1=z^5g(1/z).
\]

Thus

\[
R(z)=\frac{P_B(z)}{P_A(z)}=\frac{f(z)}{g(z)}
\]

is rational all-pass on the unit circle.

### Exact root counts by Cayley transform and Routh table

Use

\[
s=\frac{1-z}{1+z},
\]

which maps the unit disk to the right half-plane. Then

\[
(1+s)^5g\!\left(\frac{1-s}{1+s}\right)
=s^5+9s^4-2s^3+22s^2+s+1.
\]

Its Routh first column is

\[
1,\quad 9,\quad -\frac{40}{9},\quad \frac{119}{5},
\quad \frac{128}{119},\quad1,
\]

with two sign changes. Therefore `g` has exactly two zeros in the unit disk.

Likewise

\[
(1+s)^5f\!\left(\frac{1-s}{1+s}\right)
=-s^5+9s^4+2s^3+22s^2-s+1,
\]

whose Routh first column is

\[
-1,\quad9,\quad\frac{40}{9},\quad\frac{119}{5},
\quad-\frac{128}{119},\quad1,
\]

with three sign changes. Therefore `f` has exactly three zeros in the unit disk.

For the Hardy Hankel operators,

\[
\boxed{
\operatorname{rank}H_R=2,
\qquad
\operatorname{rank}H_{\overline R}=3.
}
\]

The winding is

\[
\operatorname{wind}R=3-2=1.
\]

### Cosine–sine decomposition of the multiplication unitary

Multiplication by the unimodular symbol `R` is unitary on `L^2(T)`. Relative to the Hardy polarization `H^2_+ direct_sum H^2_-`, its off-diagonal blocks are the two Hankel defects. The cosine–sine decomposition of a block unitary implies:

- all singular values strictly between `0` and `1` occur in matched pairs in the two off-diagonal blocks;
- the rank imbalance is carried by excess singular values equal to `1`;
- the excess unit multiplicity is the Fredholm index/winding.

Therefore the minimal homometric ambiguity has the exact shape

\[
\operatorname{spec}_{\mathrm{sing}}(H_R)=\{\sigma_1,\sigma_2\},
\]

\[
\operatorname{spec}_{\mathrm{sing}}(H_{\overline R})
=\{1,\sigma_1,\sigma_2\}.
\]

Numerical finite-section computation gives

\[
\sigma_1\approx0.977147971,
\qquad
\sigma_2\approx0.899663554.
\]

The ranks and unit excess are exact; these decimal singular values are numerical.

### Consequence for the K-theory no-go

Ordinary Toeplitz K-theory detects the integer winding / excess unit defect. It does **not** detect the paired fractional singular values, which carry the non-topological geometry of the phase ambiguity.

Thus the earlier ordinary-K-theory no-go is not merely negative. It points to the correct replacement:

> use the full Hankel singular spectrum, a determinant/scattering invariant, or an eta/transgression quantity; the ordinary index is only the coarse unit-defect count.

This gives a finite exact model of how parity/phase information can survive below K-theory.

---

## 7. Revised priority list

1. **Promote the Meixner identity to the central spectral theorem.** Replicate symbolically and integrate it into the canonical zero-pair dictionary.
2. **Attack Grünbaum's Meixner–Pollaczek time-band problem in the exact arithmetic normalization.** Start with real `s>0`; do not begin directly at complex zero sums.
3. **Write the Jacobi/difference bispectral pair explicitly** and test algebraic-Heun/reflection candidates for finite degree and soft/hard spectral windows.
4. **Then build the two-zero diamond/simplex compression** and analytically continue to `s=1+iSigma`.
5. **Use Hankel singular spectra, not ordinary K-theory, as the quantitative phase-obstruction invariant.** For the prime-prefix factors, study whether unimodular Bezoutian constraints control these singular values.
6. **Investigate the three-semigroup adelic coupling** only after a concrete joint generator or product formula is written.
7. Continue Igusa/collision geometry and Boolean heat flow in parallel; they now form the finite-place counterpart of the archimedean Meixner flow.

---

## 8. Literature anchors

- W. Schoutens, *The Meixner Process: Theory and Applications in Finance* (2002): density, characteristic function, infinite divisibility, Levy measure, and Meixner–Pollaczek martingales.
- H. T. Koelink and J. Van der Jeugt, *Convolutions for Orthogonal Polynomials from Lie and Quantum Algebra Representations*, SIAM J. Math. Anal. 29 (1998), arXiv:q-alg/9607010: Meixner–Pollaczek overlap coefficients and SU(1,1) Clebsch–Gordan structure.
- F. Alberto Grünbaum, *Time and Band Limiting: From the Early Days to the Present* (2025), DOI 10.37394/23202.2025.24.31: explicit Meixner–Pollaczek time-band-limiting open problem and SL(2,R) convolution densities.
- AAK/Kronecker/Hankel theory and the cosine–sine decomposition for unitary block operators.
- Languasco–Zaccagnini Cesaro Goldbach explicit formula, `k=1` pair coefficient.

