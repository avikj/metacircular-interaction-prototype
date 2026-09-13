# Actual-source interpolation and exact viscous quadrupole memory

Date: 2026-09-07.
Repository: `avikj/metacircular-interaction-prototype`.
Read snapshot: `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope and provenance

This is a completed set of analytic statements in declared source classes. It is not a proof of the Riemann hypothesis or global three-dimensional Navier–Stokes regularity. No proof-assistant build, numerical off-critical-zero certificate, or nonlinear PDE evolution is claimed.

The saved note **Explicit spectral-source interpolation and the renormalized strain current**, dated 2026-09-07 (library file `proof_note(6).md`), already supplies: entire cardinal interpolation using the actual completed zeta function; compactification with a retained error; a negative localized-Weil spectral-bottom alternative; and the exact same-source evolution of the toroidal quadrupole under moving rescaling. Those results are inputs, not inventions of this pass.

The new calculations below provide:

1. an explicit theta-source, two-sided Volterra implementation of the cardinal source, and double-exponential cutoff control;
2. the endpoint negative-eigenvalue bound `lambda_a <= -c_z a^(-sigma) exp(2 sigma a)` from any hypothetical zero `z=sigma+i gamma`, `sigma>0`;
3. the exact heat response and integrated memory of the strain-bearing toroidal quadrupole;
4. exact same-source Duhamel composition with NS forcing;
5. smooth finite-energy initial sources with fixed vorticity supremum and arbitrarily large instantaneous peak growth, while their freely diffusing quadrupole history has uniformly finite total response.

These are source constructions and evolution identities. They are not additional positive kernels whose positivity is then silently promoted to the target arithmetic or PDE statement.

The repository's `Ekatva` proves contractibility of the type of lossless completions over a fixed map. `ActionResidual` proves the exact realized-preservation hypothesis needed for a residual update. The present use does not ask either generic theorem to supply an analytic sign it does not state.

# Part I. RH: actual cardinal sources with a logarithmic support overhead

## 1. Conventions and the actual theta source

Set

\[
\xi(s)=\frac12s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s),
\qquad \Xi(z)=\xi(1/2+z).
\]

Let `Sigma` be the set of **distinct** zeros of `Xi`, with multiplicity `m_z`, and let

\[
\theta z=-\overline z,\qquad
\mathcal H=\ell^2(\Sigma,m),\qquad
(Ja)_z=a_{\theta z}.
\]

Use the inner product linear in the first argument. For a compact smooth source,

\[
V_f(w)=\int_{\mathbb R}f(x)e^{-wx}\,dx,
\qquad (Ef)_z=V_f(z),
\qquad Q_W(f,g)=\langle Ef,J Eg\rangle_{\mathcal H}.
\tag{1}
\]

Classical functional-equation symmetry preserves multiplicities. In particular `J` is a self-adjoint isometric involution. The classical explicit formula identifies (1) with the actual prime/archimedean Weil quadratic form. It is not a definition of an independent kernel bearing the same name.

For `x>=0`, define

\[
\varphi(x)=\sum_{n\ge1}
\left(4\pi^2n^4e^{9x/2}-6\pi n^2e^{5x/2}\right)
 e^{-\pi n^2e^{2x}},
\qquad \varphi(-x)=\varphi(x).
\tag{2}
\]

Then

\[
\boxed{\Xi(z)=\int_{\mathbb R}\varphi(x)e^{-zx}\,dx.}
\tag{3}
\]

Here is the normalization check. Write

\[
\psi(t)=\sum_{n\ge1}e^{-\pi n^2t},\qquad F(x)=e^{x/2}\psi(e^{2x}).
\]

The theta transformation gives `F(-x)=F(x)+sinh(x/2)`, hence `F'(0)=-1/4`, and `(D^2-1/4)F` is even. Direct differentiation gives exactly (2). The classical theta-integral formula for xi, followed by two integrations by parts, gives

\[
2\int_0^\infty (F''-F/4)\cosh(zx)\,dx
=-2F'(0)+2(z^2-1/4)\int_0^\infty F(x)\cosh(zx)\,dx
=\Xi(z).
\]

For every fixed derivative order `k` and every `0<c<pi`,

\[
|\varphi^{(k)}(x)|\le C_{k,c}\exp(-c e^{2|x|})
\quad (|x|\ge1).
\tag{4}
\]

This follows by differentiating the exponentially convergent series. Polynomial factors in `n` and `e^|x|` are absorbed by reducing the coefficient `pi` in the exponent. The extension through zero is smooth by the theta identity, not by an arbitrary even reflection of a nonsmooth germ.

## 2. Finite-zero division is equality of two actual source histories

For a complex number `z` and an integer `m>=1`, define

\[
(R^-_{z,m}\varphi)(x)
=\frac1{(m-1)!}\int_{-\infty}^{x}
 (x-y)^{m-1}e^{z(x-y)}\varphi(y)\,dy,
\tag{5}
\]

\[
(R^+_{z,m}\varphi)(x)
=\frac{(-1)^m}{(m-1)!}\int_x^\infty
 (y-x)^{m-1}e^{z(x-y)}\varphi(y)\,dy.
\tag{6}
\]

Both solve `(D-z)^m g=varphi`. Their difference is the explicit homogeneous solution

\[
\boxed{
R^-_{z,m}\varphi-R^+_{z,m}\varphi
=\frac{e^{zx}}{(m-1)!}
\sum_{j=0}^{m-1}\binom{m-1}{j}x^{m-1-j}(-1)^j\mu_j(z),
}
\tag{7}
\]

where

\[
\mu_j(z)=\int y^j e^{-zy}\varphi(y)\,dy=(-1)^j\Xi^{(j)}(z).
\]

Consequently the past and future source inverses agree precisely when

\[
\Xi(z)=\Xi'(z)=\cdots=\Xi^{(m-1)}(z)=0.
\tag{8}
\]

This is an explicit finite-dimensional boundary discrepancy, not an independently postulated inverse.

For an actual zero `z` of multiplicity `m_z`, put

\[
\boxed{
f_z=\frac{m_z!}{\Xi^{(m_z)}(z)}R^-_{z,m_z}\varphi
=\frac{m_z!}{\Xi^{(m_z)}(z)}R^+_{z,m_z}\varphi.
}
\tag{9}
\]

The agreed source decays superexponentially at both ends. Its bilateral transform is

\[
\boxed{
V_{f_z}(w)=I_z(w)
=\frac{m_z!}{\Xi^{(m_z)}(z)}\frac{\Xi(w)}{(w-z)^{m_z}}.
}
\tag{10}
\]

Every apparent singularity is removable. Therefore

\[
\boxed{Ef_z=e_z.}
\tag{11}
\]

Every other zero is eliminated by the **same actual `Xi` numerator**, not by independently assigning its coordinate zero. Multiplicities are retained exactly.

There is no assertion that `E` is injective on the enlarged source class: the nonzero source `varphi` itself satisfies `E varphi=0`. The construction (9) specifies a section on finite-coordinate vectors; it does not erase the source fibre or assert that the section is uniquely forced.

## 3. Double-exponential decay of the cardinal sources

Fix `z` and `m_z`. For `x>1` use the future representation (6), and for `x<-1` use the past representation (5). The inequality

\[
e^{2(x+t)}\ge e^{2x}(1+2t),\qquad t\ge0,
\]

bounds the polynomial Volterra weight by a convergent gamma integral. Together with (4), it proves that for some `kappa>0` and for any fixed finite derivative range,

\[
\boxed{
|f_z^{(j)}(x)|\le C_{z,j}\exp(-\kappa e^{2|x|})
\quad(|x|\ge1).
}
\tag{12}
\]

Derivatives can also be controlled recursively from `(D-z)^m f_z=const*varphi`. Constants may depend on the chosen zero and its multiplicity. No uniform control over all zeros is claimed.

Choose a smooth cutoff `chi_R` equal to one on `[-R,R]`, supported in `(-R-1,R+1)`, with derivatives through order two bounded independently of `R>=1`. Set

\[
g_{z,R}=\chi_R f_z,\qquad e_{z,R}=g_{z,R}-f_z.
\]

Then

\[
\sum_{j=0}^2\|e^{|x|/2}e_{z,R}^{(j)}\|_{L^1}
\le C_z\exp(-\kappa e^{2R}).
\tag{13}
\]

Two integrations by parts on every vertical line in `|Re w|<=1/2`, followed by the classical zero count, give

\[
\boxed{
\|Ee_{z,R}\|_{\mathcal H}
\le C_z\exp(-\kappa e^{2R}).
}
\tag{14}
\]

For example the square of the fixed summation constant is

\[
\sum_{w\in\Sigma}\frac{m_w}{(1+|\Im w|^2)^2}<\infty.
\]

The cutoff residue is part of the retained source equation
`E g_{z,R}=e_z+E e_{z,R}`.

## 4. An off-line zero forces endpoint-rate spectral escape

Assume an actual zero

\[
z=\sigma+i\gamma,\qquad \sigma>0,
\]

exists, and put `m=m_z=m_theta(z)`. The coordinate vector

\[
a_-=(e_z-e_{\theta z})/\sqrt{2m}
\]

has norm one and `J a_-=-a_-`.

Let `(T_bf)(x)=f(x-b)`. For a large positive `T`, define the **compact smooth actual source**

\[
\boxed{
v_T=\frac{e^{-zT}T_{-T}g_{z,R}
-e^{\theta z T}T_Tg_{\theta z,R}}{\sqrt{2m}}.
}
\tag{15}
\]

Without the cutoffs its evaluation vector is exactly `a_-`. With them,

\[
\|Ev_T-a_-\|\le C_z
\exp\big((1/2-\sigma)T-\kappa e^{2R}\big),
\tag{16}
\]

because translation by `b` multiplies a zero coordinate by `e^{-wb}` and all zero real parts lie in `[-1/2,1/2]`.

Choose

\[
R=\tfrac12\log(KT),\qquad \kappa K\ge1.
\tag{17}
\]

The right-hand side of (16) tends exponentially to zero. In particular, for large `T`,

\[
Q_W(v_T,v_T)\le-7/16.
\tag{18}
\]

Both coefficients in (15) have magnitude `e^{-sigma T}`, and translations preserve `L2`, so

\[
\|v_T\|_2^2\le C_z e^{-2\sigma T}.
\tag{19}
\]

The support lies in `[-T-R-1,T+R+1]`. Define

\[
\lambda_a=\inf_{0\ne f\in C_c^\infty(-a,a)}
\frac{Q_W(f,f)}{\|f\|_2^2}.
\]

For all sufficiently large `a`, set

\[
T=a-\tfrac12\log a-C_0
\]

with `C_0` large enough that `T+R(T)+1<a`. Equations (18)-(19) prove

\[
\boxed{
\lambda_a\le-c_z a^{-\sigma}e^{2\sigma a}
\quad(a\ge a_z).
}
\tag{20}
\]

This improves the saved `exp(2 sigma a/(1+epsilon))` bound: the exact exponential rate `2 sigma` now incurs only a polynomial loss. No rightmost zero is assumed to exist; this applies to every individual off-line zero.

A real odd version is obtained by adjoining the conjugate pair of sources and taking the appropriately normalized real odd part. The four nonzero target coordinates are proportional to

\[
e_z+e_{\bar z}-e_{-\bar z}-e_{-z};
\]

the same support and norm estimates apply.

### Bounded corrections cannot hide the bad sector

Suppose a family of self-adjoint operators `K_a` on the localized `L2` spaces satisfies

\[
Q_W(f,f)+\langle f,K_af\rangle\ge0
\quad(f\in C_c^\infty(-a,a)).
\]

If `||K_a||=exp(o(a))`, (20) excludes every `sigma>0`. Functional-equation reflection then gives RH. In particular a single bounded correction on the global `L2` space would suffice.

This statement does **not** construct such a correction from primes. It specifies exactly why a bounded residue in a proposed positive arithmetic realization would be enough, and why an exponentially growing correction cannot be silently regarded as harmless.

### Arithmetic source remains the same

The actual Weil functional is

\[
\begin{aligned}
W(h)={}&\int h(x)(e^{x/2}+e^{-x/2})\,dx
-\sum_{n\ge1}\frac{\Lambda(n)}{\sqrt n}\big(h(\log n)+h(-\log n)\big)\\
&-(\log4\pi+\gamma_E)h(0)
-\int_0^\infty\big(h(x)+h(-x)-2e^{-x/2}h(0)\big)
\frac{e^{x/2}}{e^x-e^{-x}}\,dx.
\end{aligned}
\tag{21}
\]

For `f` supported in `(-a,a)`, `h=f*tilde f` is supported in `(-2a,2a)`, so only primes/powers `n<exp(2a)` occur. Formula (20) therefore produces a genuine compact arithmetic test. The pole and archimedean terms remain in it. The repository's quantitative Goldbach reconstruction supplies these same `Lambda` values on its actual realized image; it is not used as a sign theorem.

# Part II. NS: solve the actual viscous strain channel

## 5. The strain-bearing observer already supplied by the handoff

Use a smooth whole-space, divergence-free vorticity `omega`, with its finite-energy Biot–Savart velocity and sufficient decay for the formulas below. For `B` trace-free symmetric, define

\[
T_B(n)=n\times Bn,\qquad n\in S^2.
\]

For a vector source `f`, define its toroidal quadrupole coefficient `A_f(r)` by

\[
\int_{S^2}f(rn)\cdot T_B(n)\,d\Omega
=\frac{4\pi}{5}\operatorname{tr}(A_f(r)B)
\quad\text{for every }B\in\operatorname{Sym}_0(3).
\tag{22}
\]

The retained exact angular calculation gives

\[
\boxed{S_u(0)=-\frac35\operatorname{p.v.}\int_0^\infty A_\omega(r)\frac{dr}{r}.}
\tag{23}
\]

This is an instantaneous linear reading of the full source. It does not assert nonlinear closure on the five coefficient functions.

## 6. The exact viscous attenuation factor

Define

\[
\boxed{
H_5(q)=\operatorname{erf}(q)
-\frac2{\sqrt\pi}e^{-q^2}\left(q+\frac23q^3\right)
=\frac{\gamma(5/2,q^2)}{\Gamma(5/2)}.
}
\tag{24}
\]

It satisfies

\[
H_5(0)=0,\qquad H_5(\infty)=1,\qquad
H_5'(q)=\frac8{3\sqrt\pi}q^4e^{-q^2}>0.
\tag{25}
\]

For `t>0`, the central strain of the freely diffusing velocity is

\[
\boxed{
S_{e^{\nu t\Delta}u_0}(0)
=-\frac35\int_0^\infty
H_5\!\left(\frac r{2\sqrt{\nu t}}\right)
A_{\omega_0}(r)\frac{dr}{r}.
}
\tag{26}
\]

### Proof by the regularized Newton potential

The heat-regularized Newton potential is

\[
\Phi_t(r)=\frac{\operatorname{erf}(r/(2\sqrt{\nu t}))}{4\pi r}.
\]

In its Hessian the isotropic term disappears on symmetrizing the Biot–Savart strain kernel. The coefficient of `n tensor n` is

\[
\Phi_t''(r)-\Phi_t'(r)/r
=\frac3{4\pi r^3}H_5\!\left(\frac r{2\sqrt{\nu t}}\right).
\tag{27}
\]

Insert (27) into the already-established angular identity (22)-(23). This proves (26), with its coefficient and sign fixed.

### Independent radial check

The l=2 toroidal coefficient evolves under heat by

\[
\partial_t A=\nu(A''+2A'/r-6A/r^2).
\]

Writing `A=r^2 b` changes this to seven-dimensional radial heat for `b`:

\[
\partial_t b=\nu(b''+6b'/r).
\]

The dual factor in (26) solves

\[
\partial_t H=\nu(H_{rr}-4H_r/r).
\tag{28}
\]

Both routes give the same response and retain the small-radius endpoint rather than deleting it.

## 7. Exact total strain memory of one radius

For every `r,nu>0`,

\[
\boxed{
\int_0^\infty
H_5\!\left(\frac r{2\sqrt{\nu t}}\right)\,dt
=\frac{r^2}{6\nu}.
}
\tag{29}
\]

More generally, if `-1<p<3/2`, Tonelli applied to the lower incomplete-gamma integral gives

\[
\boxed{
\int_0^\infty t^p
H_5\!\left(\frac r{2\sqrt{\nu t}}\right)dt
=\left(\frac{r^2}{4\nu}\right)^{p+1}
\frac{\Gamma(3/2-p)}{(p+1)\Gamma(5/2)}.
}
\tag{30}
\]

In particular the first temporal moment is `r^4/(24 nu^2)`; the second moment diverges. The kernel is not being replaced by exponential damping.

For an initial quadrupole with `int r ||A_omega0(r)|| dr < infinity`, Fubini gives the exact signed matrix identity

\[
\boxed{
\int_0^\infty S_{e^{\nu t\Delta}u_0}(0)\,dt
=-\frac1{10\nu}\int_0^\infty r A_{\omega_0}(r)\,dr.
}
\tag{31}
\]

Its absolute version is

\[
\int_0^\infty\|S_{e^{\nu t\Delta}u_0}(0)\|\,dt
\le\frac1{10\nu}\int_0^\infty r\|A_{\omega_0}(r)\|\,dr.
\tag{32}
\]

For aligned matrix sources of one sign, equality holds in (32).

## 8. Compose with the actual NS nonlinearity, not an independent forcing

On a common classical interval let

\[
\mathcal N(x,s)=\operatorname{curl}\bigl(u(x,s)\times\omega(x,s)\bigr).
\tag{33}
\]

Then

\[
\omega(t)=e^{\nu t\Delta}\omega_0
+\int_0^t e^{\nu(t-s)\Delta}\mathcal N(s)\,ds.
\]

At a fixed spatial center define `A_0(r)=A_omega0(r)` and `A_N(r,s)=A_N(s)(r)` using (22). Equation (26) gives

\[
\boxed{\begin{aligned}
S(0,t)=-\frac35&\int_0^\infty H_5\!\left(\frac r{2\sqrt{\nu t}}\right)
A_0(r)\frac{dr}{r}\\
-\frac35&\int_0^t\int_0^\infty
H_5\!\left(\frac r{2\sqrt{\nu(t-s)}}\right)
A_{\mathcal N}(r,s)\frac{dr}{r}\,ds.
\end{aligned}}
\tag{34}
\]

Every omitted angular component is still present through the same-source quadratic field (33). In particular `A_N` is not free input data, and (34) is not a closed five-variable model.

Where the right side of the following bound is finite,

\[
\boxed{
\int_0^T\|S(0,t)\|dt
\le\frac1{10\nu}
\left[\int_0^\infty r\|A_0(r)\|dr
+\int_0^T\int_0^\infty r\|A_{\mathcal N}(r,s)\|dr\,ds\right].
}
\tag{35}
\]

This is a response estimate at the declared center, not a uniform-in-space regularity theorem. A moving center requires the corresponding transported earlier sources; it cannot be substituted without changing the equation.

The full history composes by the actual heat semigroup and Duhamel integral. Under finite parabolic scaling, `r/sqrt(nu t)` is invariant. Under the outer Euler chart the same formula uses its transported effective viscosity. No singular-limit interchange is needed for these finite-stage statements.

## 9. Large instantaneous growth is compatible with fixed energy and fixed peak vorticity

Here is an exact source control against the claim that large directional bandwidth alone forces instantaneous viscous depletion at the peak.

Let

\[
A=\operatorname{diag}(1/2,1/2,-1),\qquad
0\le\phi\in C_c^\infty((1,2)),\quad\phi\ne0,\quad\|\phi\|_\infty\le1.
\]

At radii `R_j=4^{-j}`, define disjoint toroidal vorticity shells

\[
\omega_j(rn)=\phi(r/R_j)T_A(n).
\tag{36}
\]

Since `sup |T_A|=3/4`, the sum of any number of these disjoint shells has vorticity supremum at most `3/4`. Each shell generates the same positive axial central strain:

\[
S_j(0)e_3=c_0e_3,\qquad
c_0=\frac35\int_1^2\frac{\phi(q)}q\,dq>0.
\tag{37}
\]

Let `u_j` be its actual Biot–Savart velocity. Its `L2` norm is proportional to `R_j^(5/2)`, so

\[
\left\|\sum_{j=1}^N u_j\right\|_2
\le C\sum_{j=1}^N4^{-5j/2}
\le C/31.
\tag{38}
\]

Add a compactly supported solid-rotation core inside `B_{R_N/10}` with vorticity equal to `e_3` near zero and global vorticity at most one. Such a core can be made explicit as

\[
v_\varepsilon(x)=\frac12\chi(|x|/\varepsilon)e_3\times x,
\]

where `chi=1` near zero, is smooth compactly supported, is nonincreasing, and satisfies `0<=-r chi'(r)<=1`. Its vorticity is

\[
\chi\cos\vartheta\,n+
\left(\chi+\frac{r\chi'}2\right)(e_3-\cos\vartheta\,n),
\]

so its norm is bounded by one. Choosing a sufficiently long logarithmic cutoff interval gives all the required conditions. Its energy is `O(epsilon^5)`.

Set

\[
u_{0,N}=v_{\varepsilon_N}+\sum_{j=1}^N u_j.
\]

Then

\[
\boxed{
\|\operatorname{curl}u_{0,N}\|_\infty=1,\quad
u_{0,N}(0)=0,\quad
\operatorname{curl}u_{0,N}=e_3\text{ near }0,\quad
\sup_N\|u_{0,N}\|_2<\infty.
}
\tag{39}
\]

For its own classical NS evolution at any fixed viscosity `nu>0`,

\[
\boxed{
\partial_t\omega_N(0,0)=Nc_0e_3.
}
\tag{40}
\]

Indeed all spatial derivatives of vorticity vanish at the center, so advection and the viscous Laplacian vanish there; the solid rotation does not stretch its axis, and the N remote strains add.

The right lower derivative of the vorticity supremum is consequently at least `N c_0`. Thus instantaneous normalized peak growth is unbounded on this admissible smooth source class.

Energy can even be fixed **exactly**: replacing each initial velocity by `lambda_N u_{0,N}(x/lambda_N)` preserves its vorticity supremum and central strain while multiplying energy by `lambda_N^5`. Choose the positive `lambda_N` to give any prescribed positive kinetic energy.

These are different smooth initial sources, not successive stages of one blow-up trajectory. They show that instantaneous source algebra, finite energy, and a vorticity bound do not supply the missing temporal sign/depletion statement.

## 10. The same example has uniformly finite freely diffusing memory

For the freely diffusing shell sum, (31) gives

\[
\int_0^\infty S_N^{\mathrm{heat}}(0,t)\,dt
=-\frac{A}{10\nu}\left(\int_1^2 q\phi(q)dq\right)
\sum_{j=1}^N R_j^2.
\tag{41}
\]

But

\[
\sum_{j=1}^N R_j^2=\frac{1-16^{-N}}{15}\le\frac1{15}.
\]

Because all contributions are aligned and have one sign, the integrated norm also remains uniformly bounded. The radial solid-rotation core contributes no central strain under heat evolution.

Consequently

\[
\boxed{
S_N(0,0)\sim N
\quad\text{while}\quad
\int_0^\infty\|S_N^{\mathrm{heat}}(0,t)\|dt=O(1).
}
\tag{42}
\]

This is the distinction that a stationary bandwidth argument misses. Arbitrarily large instantaneous strain does not establish sustained nonlinear growth. The exact remaining history is the second line of (34), with (33) tying every contribution to the actual common solution.

# What is and is not closed

The RH construction eliminates every undesired spectral coordinate using an explicit source made from the actual theta kernel. It keeps the source cutoff residue and improves its support overhead to logarithmic size. The resulting endpoint negative-eigenvalue bound is proved from any hypothetical off-line zero. No global arithmetic lower bound or passive-storage identity is supplied.

The NS calculation solves the viscous response of the precise angular sector responsible for strain and integrates its memory exactly. It composes that response with the actual nonlinear source. It also gives a smooth finite-energy control showing why no pointwise bandwidth/depletion inference follows from the stated instantaneous data. No uniform temporal control of the common-source nonlinear term has been proved.

Lossless completion does not require reinvention in either argument. It also does not make the last two analytic signs true by itself. This note retains the sources and declares exactly which completed statements can be transported.

## Source ledger

Repository paths actually read during this pass:

- `formal/cubical/theorems/residue/Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda`
- `formal/cubical/theorems/automata/ActionResidual.agda`
- `formal/lean/Pairfield/GoldbachReconstructionChain.lean`
- `formal/lean/Pairfield/FinitePositiveExposedPoint.lean`

Other retrieved source:

- Saved **Explicit spectral-source interpolation and the renormalized strain current**, 2026-09-07, `proof_note(6).md`.
- Saved **Work balance and toroidal quadrupole selection**, 2026-09-07, mounted under `passivity_toroidal_quadrupole`.
- M. Suzuki, **Weil's quadratic form via the screw function**, arXiv:2606.09096v2, manuscript dated 24 August 2026. Used only for the actual classical Weil form, its compact smooth core, and the localized operator interpretation.
- NIST DLMF §§25.4 and 8.2, for completed-zeta reflection conventions and incomplete-gamma definitions.
- The theta functional equation, heat kernel, Biot–Savart formula, and elementary spherical-harmonic calculus are classical analytic inputs; their needed calculations are given above.

## Executed verification

`checks.py` is executable and records its own count. It ran 67 exact symbolic controls and 6 separately labelled numerical consistency checks at 45-decimal working precision. Its polynomial zero divisor is synthetic and explicitly not the zeta divisor. The numerical xi tests evaluate nonzero test arguments; they make no assertion of an off-critical zero.

The script checks finite source interpolation, multiplicity normalization, the homogeneous past/future discrepancy, the theta-kernel differential identity, the heat-regularized Hessian and radial response equations, the exact memory moments, and the geometric shell sums. The infinite analytic arguments are the proofs above, not consequences of the finite tests.

No repository mutation, no Agda/Lean build, and no background task were performed.
