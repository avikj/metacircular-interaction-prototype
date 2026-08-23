# Prime Pair Field — Fields-Medal / Cross-Mathematics Delta 07

Date: 2026-08-11

Status: research delta. Exact identities and complete derivations are marked **V1**. Representation-theoretic identifications with standard theorems are marked **KNOWN / VERIFIED AGAINST SOURCE**. Proposed arithmetic consequences remain conjectural unless explicitly proved.

## 0. Executive result

The archimedean two-leg pair field has a canonical and already-developed harmonic analysis:

\[
SU(1,1)\cong SL_2(\mathbb R)
\]

Clebsch–Gordan theory for positive discrete series separates the positive quadrant into

\[
S=x_1+x_2,
\qquad
\xi=\frac{x_2-x_1}{x_1+x_2}\in(-1,1).
\]

The radial coordinate `S` is governed by Laguerre / Meixner–Pollaczek analysis; the relative coordinate `xi` is governed by Jacobi / continuous Hahn analysis. These are exactly the pair-field sum and normalized difference coordinates.

The ordinary beta coefficient in the zero-pair Goldbach formula is the `j=0` relative channel. All higher relative channels are obtained by inserting Jacobi polynomials in `xi`; their double Mellin transforms are explicit continuous Hahn polynomials. This produces a canonical nonradial kernel family that evades the previously proved radial-kernel separability no-go.

A second exact distinction emerges:

- Goldbach / zero sums correspond to positive-positive tensor products `D^+ tensor D^+`, with a discrete ladder of Clebsch–Gordan channels;
- gap / zero differences correspond to positive-negative tensor products `D^+ tensor D^-`, whose generic decomposition is a principal-series scattering continuum.

This is the precise representation-theoretic form of the earlier `V tensor V` versus `V tensor V^vee` dictionary.

---

## 1. PRIOR-ART CORRECTION: one-body Xi / Meixner–Pollaczek theory is established

The use of Meixner–Pollaczek polynomials for the completed zeta function is not new:

- Romik expands `Xi` in a symmetric Meixner–Pollaczek basis, with the distinguished one-body parameter `lambda=3/4`, and obtains imaginary-shift difference equations.
- Inoue develops Meixner–Pollaczek expansions for completed zeta and L-functions and relates the MP difference operator to a Laguerre differential operator through Mellin transform.
- Extended MP systems naturally live in strip / imaginary-shift settings rather than only hard real intervals.

Therefore novelty cannot be claimed for “zeta has a Meixner–Pollaczek expansion.”

The project-specific object is different: the **two-zero beta kernel** produces the analytic family with parameter

\[
\lambda=\frac{s}{2},
\qquad s=\rho+\rho',
\]

and the relative variable is the zero difference. This is a pair-representation kernel, not the known one-body `lambda=3/4` expansion.

---

## 2. KNOWN / VERIFIED: the positive-positive SU(1,1) tensor product is the pair-field decomposition

For positive discrete series representations,

\[
\pi^+_{k_1}\otimes\pi^+_{k_2}
\cong
\bigoplus_{j\ge 0}\pi^+_{k_1+k_2+j}.
\]

In the hyperbolic basis:

- Meixner–Pollaczek polynomials implement the one-leg spectral transform;
- continuous Hahn polynomials are the Clebsch–Gordan coefficients;
- the total hyperbolic eigenvalue is `x_1+x_2`;
- after the Mellin/Laguerre realization, the relative coordinate is

\[
\frac{x_2-x_1}{x_1+x_2}.
\]

A standard Laguerre–Jacobi Clebsch–Gordan identity has the schematic exact form

\[
\sum_l C_{j,l}\,
L_l^{(a)}(x_1)L_{n+j-l}^{(b)}(x_2)
=
C'_{n,j}
L_n^{(a+b+1+2j)}(x_1+x_2)
(x_1+x_2)^j
P_j^{(a,b)}\!\left(\frac{x_2-x_1}{x_1+x_2}\right).
\]

Thus the pair-field coordinates are not merely convenient:

\[
\boxed{
S=x_1+x_2\ \text{is the SU(1,1) radial coordinate},
\qquad
D/S=(x_2-x_1)/(x_1+x_2)\ \text{is the relative angular coordinate}.
}
\]

The channel index `j` measures relative/angular excitation. The radial sector used so far is only `j=0`.

Primary source: Koelink–Van der Jeugt, *Convolutions for orthogonal polynomials from Lie and quantum algebra representations*, arXiv:q-alg/9607010.

---

## 3. V1: exact beta–Jacobi–continuous-Hahn transform

Let `alpha,beta>-1`, let `rho,rho'` have positive real parts, and define

\[
s=\rho+\rho',
\qquad
x=\frac{\rho-\rho'}{2i}.
\]

For `j>=0`, define the angular Mellin integral

\[
I_j^{(\alpha,\beta)}(\rho,\rho')
=
\int_0^1
 t^{\rho-1}(1-t)^{\rho'-1}
 P_j^{(\alpha,\beta)}(1-2t)\,dt.
\]

### Hypergeometric evaluation

Using

\[
P_j^{(\alpha,\beta)}(1-2t)
=
\frac{(\alpha+1)_j}{j!}
{}_2F_1\!\left(
\begin{matrix}-j,\ j+\alpha+\beta+1\\ \alpha+1\end{matrix};t
\right),
\]

termwise beta integration gives

\[
\boxed{
I_j^{(\alpha,\beta)}(\rho,\rho')
=
\frac{(\alpha+1)_j}{j!}
B(\rho,\rho')
{}_3F_2\!\left(
\begin{matrix}
-j,\ j+\alpha+\beta+1,\ \rho\\
\alpha+1,\ s
\end{matrix};1
\right).
}
\]

### Continuous Hahn identification

Use the convention

\[
p_j(x;a,b,c,d)
=
i^j\frac{(a+c)_j(a+d)_j}{j!}
{}_3F_2\!\left(
\begin{matrix}
-j,\ j+a+b+c+d-1,\ a+ix\\
a+c,\ a+d
\end{matrix};1
\right).
\]

Set

\[
a=\frac{s}{2},
\qquad
b=\beta+1-\frac{s}{2},
\qquad
c=\alpha+1-\frac{s}{2},
\qquad
d=\frac{s}{2}.
\]

Then

\[
a+ix=\rho,
\quad
a+c=\alpha+1,
\quad
a+d=s,
\quad
a+b+c+d-1=\alpha+\beta+1.
\]

Therefore

\[
\boxed{
I_j^{(\alpha,\beta)}(\rho,\rho')
=
\frac{(-i)^j B(\rho,\rho')}{(s)_j}
 p_j\!\left(
 \frac{\rho-\rho'}{2i};
 \frac{s}{2},
 \beta+1-\frac{s}{2},
 \alpha+1-\frac{s}{2},
 \frac{s}{2}
 \right).
}
\]

This is an exact diagonalization of every Jacobi angular mode of the positive quadrant.

---

## 4. V1: explicit first channels

For `alpha=beta=0`, write `I_j=I_j^{(0,0)}` and `B=B(rho,rho')`.

The ground channel is

\[
I_0=B(\rho,\rho').
\]

The first relative channel is

\[
\boxed{
\frac{I_1}{B}
=
\frac{\rho'-\rho}{\rho+\rho'}.
}
\]

The second relative channel is

\[
\boxed{
\frac{I_2}{B}
=
\frac{3(\rho'-\rho)^2-s^2+2s}{2s(s+1)},
\qquad s=\rho+\rho'.
}
\]

Under interchange `rho <-> rho'`, the parity is `(-1)^j`. Therefore symmetric two-leg kernels use only the even channels `j=0,2,4,...`; odd channels encode orientation/antisymmetry.

---

## 5. V1: a canonical nonradial kernel family that defeats the radial no-go

Let `kappa(S)` be a radial kernel and define

\[
K_j^{(\alpha,\beta)}(m,n)
=
\kappa(m+n)
P_j^{(\alpha,\beta)}\!\left(\frac{m-n}{m+n}\right),
\qquad m,n>0.
\]

Use `S=m+n` and `t=m/S`. Then `dm dn=S\,dS\,dt`, and

\[
m^{\rho-1}n^{\rho'-1}
=
S^{s-2}t^{\rho-1}(1-t)^{\rho'-1}.
\]

Consequently the double Mellin transform factors as

\[
\boxed{
\iint_{\mathbb R_+^2}
K_j(m,n)m^{\rho-1}n^{\rho'-1}\,dm\,dn
=
\widehat\kappa(s)
I_j^{(\alpha,\beta)}(\rho,\rho'),
}
\]

with the convention

\[
\widehat\kappa(s)=\int_0^\infty \kappa(S)S^{s-1}\,dS.
\]

Hence the complete two-zero multiplier is

\[
\widehat\kappa(\rho+\rho')
B(\rho,\rho')
\times
\text{an explicit continuous-Hahn polynomial in }(\rho-\rho').
\]

The earlier radial no-go applies only to `j=0`: a purely radial kernel depends on `rho+rho'` apart from the unavoidable beta factor and cannot create an independently tunable relative mode. Jacobi insertions supply the canonical nonradial modes.

This is not a random enlargement of the kernel class; it is the irreducible `SU(1,1)` Clebsch–Gordan basis.

---

## 6. V1: fixed-zero-sum continuous-Hahn measure

Assume RH and write

\[
\rho=\frac12+i\gamma,
\qquad
\rho'=\frac12+i\gamma'.
\]

Set

\[
\Sigma=\gamma+\gamma',
\qquad
r=\frac{\gamma-\gamma'}{2},
\qquad
A=\frac12+\frac{i\Sigma}{2}.
\]

Then

\[
\rho=A+ir,
\qquad
\rho'=A-ir.
\]

The squared numerator of the beta coefficient is

\[
|\Gamma(\rho)\Gamma(\rho')|^2.
\]

But

\[
|\Gamma(\rho)\Gamma(\rho')|^2
=
\Gamma(A+ir)
\Gamma(\overline A+ir)
\Gamma(\overline A-ir)
\Gamma(A-ir),
\]

which is exactly a continuous-Hahn orthogonality weight in `r` with parameter quadruple

\[
(A,\overline A,\overline A,A).
\]

For a fixed zero sum `Sigma`, the Cesàro denominator such as

\[
|\Gamma(3+i\Sigma)|^2
\]

is constant in `r`. Therefore:

\[
\boxed{
\text{At fixed zero sum, the relative zero-difference mass admits a complete continuous-Hahn mode decomposition.}
}
\]

Interpretation:

- the Meixner density from Delta 06 is the holomorphic beta amplitude;
- the continuous-Hahn weight is the phase-free relative mass;
- `j=0` is the radial Goldbach channel already measured;
- `j>=1` are exact primitive/nonradial pair channels.

No claim is made that the actual discrete set of zeta-zero pairs is distributed according to this continuous measure; the theorem concerns the analytic gamma/beta weight multiplying each pair.

---

## 7. KNOWN / STRUCTURAL: Goldbach and gaps occupy different SU(1,1) tensor categories

### Goldbach / sum sector

The positive-positive tensor product has discrete Clebsch–Gordan decomposition:

\[
D^+_{k_1}\otimes D^+_{k_2}
=
\bigoplus_{j\ge0}D^+_{k_1+k_2+j}.
\]

Its relative coefficients are continuous Hahn **polynomials**. This is the natural home of sum variables and output multiplicities.

### Gap / difference sector

The positive-negative tensor product

\[
D^+_{k_1}\otimes D^-_{k_2}
\]

has, generically, a direct-integral decomposition over principal unitary series, with possible complementary/discrete additions depending on the parameters. Its hyperbolic Clebsch–Gordan coefficients are continuous Hahn **functions**.

Primary source: Groenevelt–Koelink–Rosengren, *Continuous Hahn functions as Clebsch–Gordan coefficients*, arXiv:math/0302251.

Thus the earlier dictionary becomes exact:

\[
\boxed{
\begin{array}{c|c}
\text{Goldbach / sums} & D^+\otimes D^+,\ \text{discrete channel ladder},\ \text{Hahn polynomials}\\
\text{gaps / differences} & D^+\otimes D^-,\ \text{principal-series scattering},\ \text{Hahn functions}
\end{array}}
\]

This does not by itself prove Poisson statistics for zero sums or GUE statistics for zero differences. It does identify the exact representation categories in which those two statistics live.

---

## 8. V1: canonical primitive operator and an analytic Hodge-sign analogue

On the relative coordinate `t=m/(m+n)`, define the Jacobi operator

\[
\mathcal J_{\alpha,\beta}
=
t(1-t)\frac{d^2}{dt^2}
+
[\alpha+1-(\alpha+\beta+2)t]\frac{d}{dt}.
\]

It satisfies

\[
\mathcal J_{\alpha,\beta}
P_j^{(\alpha,\beta)}(1-2t)
=
-j(j+\alpha+\beta+1)
P_j^{(\alpha,\beta)}(1-2t).
\]

With Jacobi weight

\[
w_{\alpha,\beta}(t)=t^\alpha(1-t)^\beta,
\]

integration by parts gives

\[
\boxed{
\langle f,\mathcal J_{\alpha,\beta}f\rangle_w
=
-
\int_0^1
 t^{\alpha+1}(1-t)^{\beta+1}|f'(t)|^2\,dt
\le0.
}
\]

The kernel consists of constants, i.e. the radial `j=0` sector. Every mean-zero relative mode has strictly negative quadratic form.

For `alpha=beta=0` and `xi=(n-m)/(m+n)`, this is the Legendre operator

\[
\frac{d}{d\xi}\left((1-\xi^2)\frac{d}{d\xi}\right),
\]

with eigenvalues `-j(j+1)`.

This is a precise archimedean analogue of “Hodge-index negativity on primitive directions”:

- radial constants are the distinguished nonnegative direction;
- relative/primitive channels are negative.

It is not yet the missing number-field Hodge theorem because the arithmetic prime-pair distribution has not been shown to pair with this Dirichlet form in the required way.

---

## 9. Refined prolate / Connes–Consani target

The naïve target “solve a hard real-interval Meixner–Pollaczek time-band problem” is probably underspecified.

Two exact facts alter the formulation:

1. MP spectral operators shift the variable in the imaginary direction; completed-zeta MP expansions naturally converge in strips.
2. The two-leg positive cone already separates into Jacobi angular channels and MP/Hahn radial spectral variables through `SU(1,1)` Clebsch–Gordan theory.

Two concrete operator problems should be distinguished.

### A. Jacobi/Hahn simplex concentration

On the additive simplex

\[
m>0,\quad n>0,\quad m+n\le X,
\]

separate variables into `S=m+n` and `xi=(n-m)/S`. Compress the tensor scaling representation in `S` while retaining finitely many Jacobi channels in `xi`.

Seek an algebraic-Heun operator, built from the bispectral Jacobi/Hahn pair, commuting with the corresponding time-and-band-limiting operator. The general algebraic-Heun ansatz is

\[
M=\tau_1LZ+\tau_2ZL+\tau_3L+\tau_4Z+\tau_0.
\]

This is the most concrete finite-channel prolate target.

### B. Hardy-strip / imaginary-shift concentration

Because the MP dual equation uses shifts `x -> x +/- i`, formulate the continuous problem on a Hardy/Sonin strip with two boundary components rather than assuming a hard real spectral interval is fundamental.

This may connect more naturally to:

- Connes–Consani quasi-inner/Sonin spaces;
- Burnol scattering/causality;
- the two-temperature reconstruction theorem;
- the Toeplitz/Hankel boundary decomposition.

No commuting operator has yet been constructed for either version.

---

## 10. Adelic convergence: a concrete GL(2) architecture

The local pieces now align as follows.

### Finite places

- determinant-`h` affine/Farey pair states;
- Bruhat–Tits / branch-tree geometry;
- p-adic cluster trees of shifts;
- multivariate Igusa integrals `I_{p,H}`;
- local singular-series survival factors.

### Archimedean place

- `SU(1,1) congruent SL_2(R)` positive-cone representation;
- Laguerre / Meixner–Pollaczek radial transform;
- Jacobi / continuous-Hahn relative transform;
- beta factors as archimedean local zeta integrals.

The exact common language is not yet a global automorphic representation, but it is already the language of local `GL_2` harmonic analysis and local zeta integrals.

A sharpened global target is:

> Construct one adelic correspondence or relative trace object whose finite local orbital/fiber factors are the Igusa collision integrals and whose archimedean relative character is the beta–Jacobi–Hahn transform.

This would turn the current collection of local coincidences into one product formula. No such global object has yet been constructed.

---

## 11. Multileg extension suggested by the same machinery

For `k` positive variables, write

\[
S=x_1+\cdots+x_k,
\qquad
t_i=x_i/S,
\qquad
(t_1,\ldots,t_k)\in\Delta_{k-1}.
\]

The Mellin measure separates as

\[
\prod_i x_i^{\rho_i-1}\,dx_1\cdots dx_k
=
S^{\sum_i\rho_i-1}\,dS
\times
\prod_i t_i^{\rho_i-1}\,dt_1\cdots dt_{k-1}.
\]

The angular factor is the Dirichlet integral

\[
\int_{\Delta_{k-1}}\prod_i t_i^{\rho_i-1}\,dt
=
\frac{\prod_i\Gamma(\rho_i)}{\Gamma(\sum_i\rho_i)}.
\]

Thus the beta coefficient already generalizes to the `k`-leg Dirichlet density. Multivariate Jacobi/Koornwinder polynomials on the simplex should supply the relative channels, and iterated `SU(1,1)` Clebsch–Gordan recoupling should introduce Racah / `6j` coefficients.

This is particularly relevant to the ternary Goldbach calibration:

- binary has one relative coordinate and no spare averaging leg;
- ternary has a two-dimensional angular simplex and multiple coupling channels;
- the known `(3,3)` first-variation coefficients may be interpretable as channel multiplicities / first derivatives of the three-leg relative transform.

This is a concrete next computation, not yet a theorem.

---

## 12. Revised priorities after Delta 07

1. **Promote the SU(1,1) Clebsch–Gordan decomposition to the canonical archimedean pair-field language.** It subsumes the isolated beta/Meixner observations and makes `S,D/S,j` intrinsic.
2. **Compute arithmetic observables in the first nontrivial even channel `j=2`.** Test whether the resulting signed coefficient is the analytic primitive/Hodge sector sought in the function-field comparison.
3. **Construct the Jacobi/Hahn algebraic-Heun concentration operator** for finite angular cutoff and additive-simplex radial cutoff.
4. **Formulate the strip version** of the MP/Sonin problem and compare it with the two-temperature phase-reconstruction theorem.
5. **Build the multileg Dirichlet/Jacobi transform** and match ternary variation coefficients before attempting a general `k`-tuple theory.
6. **Search for an adelic relative-trace formulation** joining finite Igusa collision factors to the archimedean beta–Hahn character.
7. Continue to treat the one-body `Xi`/MP expansion as prior art; the live novelty candidate is the pair/tensor and relative-channel construction.

---

## 13. Verification boundaries

**V1 in this delta:**

- beta–Jacobi hypergeometric integral;
- continuous-Hahn identification under the stated convention;
- first two channel formulas;
- double Mellin factorization of Jacobi angular kernels;
- fixed-sum gamma weight as a continuous-Hahn weight;
- Jacobi primitive Dirichlet-form negativity;
- multileg radial/Dirichlet separation.

**Known representation theory:**

- positive-positive `SU(1,1)` discrete-series Clebsch–Gordan decomposition;
- MP and continuous Hahn overlap coefficients;
- positive-negative principal-series decomposition and continuous Hahn functions;
- algebraic-Heun framework for bispectral time-band problems.

**Open / conjectural:**

- that `j=2` gives the needed arithmetic Hodge-index form;
- a commuting simplex-prolate or strip-prolate operator for the project;
- an adelic product object unifying all local factors;
- direct consequences for RH, Goldbach, or parity cancellation.

## 14. Literature anchors

- Koelink and Van der Jeugt, *Convolutions for orthogonal polynomials from Lie and quantum algebra representations*, arXiv:q-alg/9607010.
- Groenevelt, Koelink, and Rosengren, *Continuous Hahn functions as Clebsch–Gordan coefficients*, arXiv:math/0302251.
- Romik, *The Taylor coefficients of the Riemann xi function*, 2019.
- Inoue, *Expansion of the Riemann Xi function in Meixner–Pollaczek polynomials*, 2014.
- Grünbaum, Vinet, and Zhedanov, work on algebraic Heun operators and time-band limiting.
- Standard Jacobi and continuous Hahn formulas as in the Askey scheme / Koekoek–Lesky–Swarttouw conventions.
