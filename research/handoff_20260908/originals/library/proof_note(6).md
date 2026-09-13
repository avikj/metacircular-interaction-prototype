# Explicit spectral-source interpolation and the renormalized strain current

Date: 2026-09-07.
Repository snapshot inspected: `avikj/metacircular-interaction-prototype`, `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Status

This note derives two additions to the existing theorem graph. The arithmetic addition is an explicit source realizing any finitely supported zero-coordinate vector, together with a global alternative for the localized Weil spectral bottom. The fluid addition is the exact evolution/current law of the already-identified toroidal quadrupole observer under time-dependent parabolic renormalization.

The arguments below use classical facts about the completed zeta function, the explicit formula, Fourier inversion, and smooth incompressible Navier–Stokes. They are mathematical proofs in the stated classes, not a proof-assistant build. No originality-priority claim, actual off-critical zeta zero, proof of RH, or exclusion of general NS blow-up is asserted. The executable companion checks finite algebra and differential identities only.

# I. Arithmetic: interpolate the actual source, not an independent spectrum

## 1. Retained objects

Use

\[
\xi(s)=\tfrac12s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s),
\qquad \Xi(z)=\xi(\tfrac12+z).
\]

Thus \(\Xi\) is even and entire, real on the real axis. Its zeros are exactly the shifted nontrivial zeros of zeta. Let \(\Sigma\) be the set of distinct zeros, \(m_z\) their multiplicities, and

\[
\theta z=-\overline z,
\qquad
\mathcal H=\ell^2(\Sigma,m),
\qquad (Ja)_z=a_{\theta z}.
\]

The Hilbert inner product is linear in the first argument. For compact smooth sources,

\[
V_f(z)=\int_{\mathbb R}f(x)e^{-zx}\,dx,
\qquad (Ef)_z=V_f(z),
\qquad
Q_W(f,g)=\langle Ef,J Eg\rangle_{\mathcal H}.
\tag{1}
\]

This is the actual Weil form, not a new definition of an unrelated RH slot. The prior work already supplies (1), the majorant norm, the fixed packet inverse, and the arithmetic/CRT/quantitative-Goldbach ancestry of its prime weights. The new construction below gives explicit preimages of the individual coordinate vectors in a larger, precisely specified source class, then returns to compact sources with the residual retained.

## 2. A source class stable under division by a finite zero divisor

Let \(\mathscr S_{\exp}\) consist of smooth functions for which

\[
\int_{\mathbb R}e^{A|x|}|f^{(k)}(x)|\,dx<\infty
\quad\text{for every }A>0\text{ and every integer }k\ge0.
\tag{2}
\]

On every fixed vertical strip, Stirling's formula for the gamma factor and the usual polynomial vertical-strip bounds for zeta give

\[
|\Xi(a+it)|\le C_{A}(1+|t|)^{N_A}e^{-\pi|t|/4},
\qquad |a|\le A,
\tag{3}
\]

for suitable constants. Removing finitely many zero factors and multiplying by a polynomial preserves a bound of this form. Apparent singularities at the removed zeros are filled by their analytic values.

If an entire \(F\) has (3) on every fixed vertical strip, set

\[
f(x)=\frac1{2\pi}\int_{\mathbb R}F(it)e^{itx}\,dt.
\tag{4}
\]

Contour shifting proves

\[
f^{(k)}(x)=\frac1{2\pi}\int_{\mathbb R}(a+it)^kF(a+it)e^{(a+it)x}\,dt.
\]

For positive \(x\), choose \(a\) negative; for negative \(x\), choose it positive. The horizontal sides vanish by (3). Choosing the shift larger than any prescribed exponential weight proves (2). Fourier uniqueness and analytic continuation then give \(V_f=F\).

No compact support is asserted for these inverse sources.

## 3. Explicit cardinal sources, with multiplicities retained

For each \(z\in\Sigma\), define

\[
\boxed{
I_z(w)=\frac{m_z!}{\Xi^{(m_z)}(z)}\,
       \frac{\Xi(w)}{(w-z)^{m_z}}.
}
\tag{5}
\]

The denominator in front is nonzero by the definition of multiplicity. The apparent singularity at \(w=z\) is removable. Consequently

\[
\boxed{I_z(v)=\mathbf1_{v=z}\quad(v\in\Sigma).}
\tag{6}
\]

Let \(f_z\in\mathscr S_{\exp}\) be the inverse Fourier source constructed in (4). Then

\[
\boxed{Ef_z=e_z.}
\tag{7}
\]

Thus a finitely supported coordinate vector \(a\) has the explicit source

\[
f_a=\sum_{z\in\operatorname{supp}a}a_zf_z,
\qquad Ef_a=a.
\tag{8}
\]

This construction does not assume that zeta zeros are simple, a maximal real part is attained, or other zeros can be discarded. All the other coordinates vanish because the same entire \(\Xi\) remains in the numerator.

For an off-line zero \(z=\alpha+i\gamma\), \(\alpha>0\), let \(m=m_z=m_{\theta z}\). Then

\[
a=\frac{e_z-e_{\theta z}}{\sqrt{2m}}
\quad\Longrightarrow\quad
\|a\|_{\mathcal H}=1,
\quad Ja=-a.
\tag{9}
\]

Its source is exactly

\[
f_a=\frac{f_z-f_{\theta z}}{\sqrt{2m}},
\qquad \langle Ef_a,J Ef_a\rangle=-1.
\tag{10}
\]

The pairing in (10) is first understood spectrally on the larger source class. The following cutoff construction returns it to the original compact smooth domain of the classical explicit formula.

## 4. The compactification error is a retained source coordinate

Choose \(\chi\in C_c^\infty(-1,1)\), \(0\le\chi\le1\), equal to one on \([-1/2,1/2]\). Write

\[
f_R=\chi(x/R)f,
\qquad r_R=f_R-f.
\]

For \(w=a+it\), \(|a|\le1/2\), two integrations by parts give

\[
|V_{r_R}(a+it)|
\le\frac{\epsilon_R}{1+t^2},
\quad
\epsilon_R=
\sum_{j=0}^{2}\|e^{|x|/2}r_R^{(j)}\|_{L^1}.
\tag{11}
\]

Indeed, applying \(1-\partial_x^2\) to \(e^{-ax}r_R\) gives
\(e^{-ax}[(1-a^2)r_R+2ar_R'-r_R'']\), whose \(L^1\) norm is bounded by \(\epsilon_R\).

The classical zero-count estimate makes

\[
C_\Sigma^2=\sum_{w\in\Sigma}\frac{m_w}{(1+|\Im w|^2)^2}<\infty.
\]

Hence the exact residual and its bound are

\[
Ef_R=Ef+Er_R,
\qquad
\|Er_R\|_{\mathcal H}\le C_\Sigma\epsilon_R.
\tag{12}
\]

For \(f\in\mathscr S_{\exp}\), for every \(L>0\) there is \(C_{f,L}\) such that

\[
\|Er_R\|_{\mathcal H}\le C_{f,L}e^{-LR}
\quad(R\ge1).
\tag{13}
\]

Cutoff derivatives only contribute polynomial factors in \(R^{-1}\); (2), with a larger exponential weight, absorbs them.

If \(Ef=a\) is the vector (9) and \(\delta=Er_R\), then

\[
Q_W(f_R,f_R)
=-1+2\Re\langle a,J\delta\rangle+\langle\delta,J\delta\rangle.
\tag{14}
\]

In particular \(\|\delta\|\le1/4\) gives

\[
\boxed{Q_W(f_R,f_R)\le-7/16.}
\tag{15}
\]

Thus an assumed off-line zero yields a compact smooth negative test without an unspecified density argument. The cutoff error is not removed from the source description.

The existing fixed-packet inverse then transports this compact negative test into finite combinations of translates of the already specified packet. Its prime weights remain the reconstructed \(\Lambda(n)\), including the archimedean and pole terms in the explicit formula. This is an existence/construction theorem from a hypothetical zero, not an executed numerical certificate.

## 5. Exponential spectral escape on expanding support intervals

Define the actual localized variational bottom

\[
\lambda_a=
\inf_{0\ne f\in C_c^\infty(-a,a)}
\frac{Q_W(f,f)}{\|f\|_2^2}.
\tag{16}
\]

The classical localized form theory identifies this with the lowest eigenvalue of its self-adjoint realization. For the argument below it is enough that \(\lambda_a\) is finite for each \(a\) and is nonincreasing as \(a\) increases.

Fix an off-line zero \(z=\alpha+i\gamma\), \(\alpha>0\), and \(0<\varepsilon<1\). Put

\[
g_{z,R}=\chi(x/R)f_z,
\qquad R=\varepsilon T,
\qquad (T_bf)(x)=f(x-b).
\]

Construct the compact source

\[
\boxed{
v_T=
\frac{e^{-zT}T_{-T}g_{z,R}
      -e^{\theta z\,T}T_Tg_{\theta z,R}}{\sqrt{2m}}.
}
\tag{17}
\]

Its support lies in \((-(1+\varepsilon)T,(1+\varepsilon)T)\). The source amplitudes have magnitude \(e^{-\alpha T}\), so

\[
\|v_T\|_2^2\le C_z e^{-2\alpha T}.
\tag{18}
\]

Without the cutoffs its evaluation vector would be exactly (9), because

\[
E(T_bf)(w)=e^{-wb}Ef(w).
\]

The unconditional critical strip gives
\(\|E(T_bf)\|\le e^{|b|/2}\|Ef\|\). Thus (13) implies

\[
\|Ev_T-a\|_{\mathcal H}
\le C_{z,L}e^{(1/2-\alpha)T-L\varepsilon T}.
\tag{19}
\]

Choose any \(L\) with \(L\varepsilon>1/2-\alpha\). Then \(Ev_T\to a\), so \(Q_W(v_T,v_T)\to-1\). Equations (18)–(19) prove, for all sufficiently large support parameters,

\[
\boxed{
\lambda_a\le-c_{z,\varepsilon}
\exp\!\left(\frac{2\alpha}{1+\varepsilon}a\right).
}
\tag{20}
\]

No dominant-zero assumption or cancellation estimate for the full exponential zero sum is used: the other coordinates were eliminated by the actual source (5), before translation and cutoff.

Let

\[
\delta=\sup\{\Re z:z\in\Sigma\}.
\]

Under failure of RH, \(\delta>0\), and (20) gives

\[
\boxed{
\liminf_{a\to\infty}\frac{\log(-\lambda_a)}a\ge2\delta.
}
\tag{21}
\]

This assertion is only made after \(\lambda_a\) has become negative.

## 6. The other branch: a concrete vanishing sequence

Let \(\varphi\in\mathscr S_{\exp}\) be the inverse source of \(\Xi\) itself. It is nonzero, but

\[
\boxed{E\varphi=0.}
\tag{22}
\]

The compact cutoffs \(\varphi_R=\chi(x/R)\varphi\) satisfy

\[
\|E\varphi_R\|\to0,
\qquad
\|\varphi_R\|_2\to\|\varphi\|_2>0.
\tag{23}
\]

Under RH, \(J=I\), so the localized forms are nonnegative. Their Rayleigh quotients on (23) tend to zero. Therefore

\[
\boxed{
\begin{array}{ll}
\mathrm{RH}:&\lambda_a\downarrow0,\\[2mm]
\neg\mathrm{RH}:&\lambda_a\downarrow-\infty,
\quad\text{with the exponential lower growth bound (21).}
\end{array}
}
\tag{24}
\]

In particular,

\[
\boxed{
\mathrm{RH}
\iff
\exists C\ge0\;\forall f\in C_c^\infty(\mathbb R),
\quad Q_W(f,f)\ge-C\|f\|_2^2.
}
\tag{25}
\]

Any global lower bound suffices; its constant need not be zero. More generally, a subexponential bound on the negative part of \(\lambda_a\) suffices by (21).

Equation (22) is an important domain distinction. Evaluation is faithful on the earlier compact-source class, but not on \(\mathscr S_{\exp}\). The larger source class has genuine invisible sources. The construction does not silently extend compact-source faithfulness, and (25) does not assert the existence of a closed global form on the original unweighted \(L^2(\mathbb R)\) carrier.

### Elementary arithmetic upper control on the escape exponent

For completeness, the full explicit formula yields a uniform finite-window lower bound of the form

\[
\lambda_a\ge-C(1+a)e^a.
\tag{26}
\]

Here is a direct proof. For \(h=f*\widetilde f\), \(h(0)=\|f\|_2^2\), \(|h(t)|\le h(0)\), and \(h\) is supported in \([-2a,2a]\). The two pole terms are bounded in absolute value by \(4\sinh(a)\|f\|_2^2\), by Cauchy–Schwarz for \(V_f(\pm1/2)\). The prime terms are bounded below by

\[
-2\|f\|_2^2\sum_{n\le e^{2a}}\frac{\Lambda(n)}{\sqrt n}
\ge-C(1+a)e^a\|f\|_2^2,
\]

using only \(\Lambda(n)\le\log n\). The archimedean integral has a global constant lower bound because its kernel

\[
k(t)=\frac{e^{t/2}}{e^t-e^{-t}}
\]

is positive and

\[
h(t)+h(-t)-2e^{-t/2}h(0)
\le2(1-e^{-t/2})h(0),
\]

with \(\int_0^\infty(1-e^{-t/2})k(t)dt<\infty\). Include the constant term at zero to obtain (26).

Together, under failure of RH,

\[
2\delta\le\liminf_{a\to\infty}\frac{\log(-\lambda_a)}a
\le\limsup_{a\to\infty}\frac{\log(-\lambda_a)}a\le1.
\tag{27}
\]

No assertion that the lower and upper exponents coincide is made.

# II. Navier–Stokes: evolve the strain-bearing observer through renormalization

## 7. The retained five-component source observer

For \(A\in\operatorname{Sym}_0(3)\), define

\[
T_A(n)=n\times An,\qquad n\in\mathbb S^2.
\]

The previous toroidal-selection calculation gives

\[
\int_{\mathbb S^2}T_A\cdot T_B\,d\Omega
=\frac{4\pi}{5}\operatorname{tr}(AB).
\tag{28}
\]

For a vorticity field \(\Omega\), let \(C_r\in\operatorname{Sym}_0(3)\) be determined by

\[
\int_{\mathbb S^2}\Omega(rn)\cdot T_A(n)\,d\Omega
=\frac{4\pi}{5}\operatorname{tr}(C_rA).
\tag{29}
\]

For the decaying whole-space Biot–Savart source, the central strain is

\[
S(0)=-\frac35\operatorname{p.v.}\int_0^\infty C_r\frac{dr}{r}.
\tag{30}
\]

On finite annuli, (29) defines the exact contribution whether or not an infinite integral has been justified. A separately retained harmonic/affine source component is not silently removed from the velocity or from its dynamics.

## 8. A time-dependent parabolic zoom of one actual solution

Let \(u(x,t)\) be a smooth NS solution, with viscosity \(\nu>0\), on the time interval considered. Choose a positive differentiable scale \(\rho(t)\) and a sufficiently differentiable center \(c(t)\). Set

\[
\frac{d\tau}{dt}=\rho(t)^{-2},
\quad
U(y,\tau)=\rho(t)[u(c(t)+\rho(t)y,t)-\dot c(t)],
\quad
\Omega(y,\tau)=\rho(t)^2\omega(c(t)+\rho(t)y,t),
\]

and

\[
\eta(\tau)=\frac{d\log\rho}{d\tau}=\rho\dot\rho.
\]

A direct chain rule in the actual vorticity equation gives

\[
\boxed{
\partial_\tau\Omega
=\operatorname{curl}(U\times\Omega)
+\nu\Delta\Omega
+\eta(y\cdot\nabla\Omega+2\Omega).
}
\tag{31}
\]

Equivalently, the first and last terms are
\(\operatorname{curl}((U-\eta y)\times\Omega)\). Constant frame acceleration contributes only a pressure gradient and does not enter (31).

The full \(U\) is retained. In particular, a harmonic strain present in a local limit is not omitted from \(\operatorname{curl}(U\times\Omega)\).

## 9. Projection commutes with angular diffusion, not with nonlinear evolution

The homogeneous polynomial \(x\times Ax\) is harmonic of degree two. Consequently each Cartesian component of \(T_A\) obeys

\[
\Delta_{\mathbb S^2}T_A=-6T_A.
\]

Applying (29) to (31) therefore gives the exact equation

\[
\partial_\tau C_r
=\nu\left(\partial_r^2C_r+\frac2r\partial_rC_r-\frac6{r^2}C_r\right)
+N_r+\eta(r\partial_rC_r+2C_r),
\tag{32}
\]

where the nonlinear source is specified, not free:

\[
N_r=\Pi_{2,\mathrm{tor}}
\big[\operatorname{curl}(U\times\Omega)(r\,\cdot,\tau)\big].
\tag{33}
\]

All omitted angular sectors can influence (33). Thus (32) is an exact projected law with a same-source forcing, not a closed five-variable model of NS.

## 10. The renormalized current in logarithmic radius

Put

\[
\ell=\log r,\qquad B(\ell,\tau)=C_{e^\ell}(\tau),
\qquad \mathcal N(\ell,\tau)=N_{e^\ell}(\tau).
\]

The radial diffusion term becomes

\[
e^{-2\ell}(B_{\ell\ell}+B_\ell-6B)
=\partial_\ell\left[e^{-2\ell}(B_\ell+3B)\right].
\]

Define the current

\[
\boxed{
\mathcal F(\ell,\tau)
=\nu e^{-2\ell}(B_\ell+3B)+\eta B.
}
\tag{34}
\]

Then (32) becomes the exact five-component balance

\[
\boxed{
(\partial_\tau-2\eta)B-\partial_\ell\mathcal F=\mathcal N.
}
\tag{35}
\]

This is the temporal ancestry law of the already constructed strain-bearing observer. The viscous contribution to its logarithmic primitive is a boundary current, with all coefficients fixed by the angular degree.

For a finite logarithmic interval \([L_-,L_+]\), set

\[
\mathcal S_{[L_-,L_+]}=-\frac35\int_{L_-}^{L_+}B\,d\ell.
\]

Integrating (35) gives

\[
\boxed{
(\partial_\tau-2\eta)\mathcal S_{[L_-,L_+]}
=-\frac35\int_{L_-}^{L_+}\mathcal N\,d\ell
-\frac35\,[\mathcal F]_{L_-}^{L_+}.
}
\tag{36}
\]

An intermediate boundary cancels exactly when adjacent annuli are joined. No boundary term is called lower order, no projected source is allowed to choose its own nonlinear forcing, and no independence of radii is assumed.

The integrating factor makes the time-history composition explicit. With

\[
\mu(\tau)=\exp\left(-2\int_{\tau_0}^{\tau}\eta(s)ds\right)
=\frac{\rho(\tau_0)^2}{\rho(\tau)^2},
\]

one has

\[
\mu(\tau_1)\mathcal S(\tau_1)-\mathcal S(\tau_0)
=-\frac35\int_{\tau_0}^{\tau_1}\mu(\tau)
\left(\int_{L_-}^{L_+}\mathcal N\,d\ell
+[\mathcal F]_{L_-}^{L_+}\right)d\tau.
\tag{37}
\]

Time subdivision also telescopes. Equations (36)–(37) are the explicit additive residual maps for this observer. They instantiate the repository's retained-residual/commutation pattern with a concrete smooth PDE calculation; the generic residual theorem alone is not being presented as that calculation.

## 11. The small-radius endpoint is local viscous strain, not zero

For a smooth velocity, angular parity and Taylor expansion give

\[
C_r=r^2C_2+O(r^4),
\qquad C_2=\frac13\Delta S(0).
\tag{38}
\]

One way to verify the coefficient is to apply (29) to the quadratic Taylor part of \(\operatorname{curl}U\), using the fourth spherical moments and \(\Delta U=-\operatorname{curl}\Omega\). Equivalently it is a universal identity on divergence-free cubic velocity jets.

Thus

\[
\lim_{\ell\to-\infty}\mathcal F(\ell,\tau)
=5\nu C_2
=\frac{5\nu}{3}\Delta S(0).
\tag{39}
\]

When the outer endpoint vanishes and all infinite integrals are justified, its contribution in (36) is therefore \(+\nu\Delta S(0)\), as required by the true strain equation. Simply deleting both endpoint currents would lose the local viscous term.

The companion script checks (38) on the full monomial basis of homogeneous quartic vector potentials. Their curls span divergence-free homogeneous cubic velocities: for a homogeneous divergence-free vector field of degree three, the elementary homotopy formula supplies a degree-four vector potential. The general proof is the linear Taylor/moment argument, not a numerical test of a few fluid evolutions.

## 12. Relation to the existing operator and continuation graph

Use the local algebraic symbol formula from the earlier essential cross-helicity calculation, \(q_U(x,n)=-P_nS_UP_n-\tfrac12(n^\top S_Un)P_n\), with \(P_n=I-nn^\top\). This does not assert a new whole-space operator-domain theorem. Its spherical average reconstructs the same strain via

\[
S_U(x)=-\frac52\int_{\mathbb S^2}q_U(x,n)\,d\mu(n),
\]

where \(d\mu\) is normalized spherical measure. Together with (30), at a decaying whole-space source,

\[
\int_{\mathbb S^2}q_U(0,n)\,d\mu(n)
=\frac6{25}\int_{\mathbb R}B(\ell)\,d\ell.
\tag{40}
\]

Thus the essential operator reading, the local strain, and the logarithmic vorticity-shell primitive are readings of one source. Equation (35) evolves the last of these without replacing the actual nonlinear generator by an arbitrary five-component action.

At every finite smooth renormalization, the candidate ancestry must include (31), (33), and (35)–(37) simultaneously, along with the already retained pressure/boundary data, source-dependent Poisson tensor, true derivative, and stochastic-source residual where that representation is used. A proposed limiting continuation is not authorized to erase the endpoint current or to replace \(\mathcal N\) by an independent field.

These identities do not establish tightness of the logarithmic-scale history, convergence of all nonlinear products through a singular limit, or an incompatibility that excludes every actual blow-up ancestry. Those conclusions are not assumed.

# Verification and source ledger

The repository source read in this run includes `formal/lean/Pairfield/LinearObservabilityKernel.lean` and `formal/cubical/theorems/automata/ActionResidual.agda`, at the pinned commit. The comprehensive conversation handoff and the subsequent notes on the fixed receiver, the Weil reflection signature, explicit receiver inversion, Poisson source transport, essential strain reconstruction, and toroidal quadrupole selection were also read. Their proved input maps are retained rather than replaced by the weaker abstract realization records.

The new compositions developed here are (5)–(25) and (31)–(40). Cardinal interpolation, Fourier contour shifting, residual telescoping, and spherical harmonic calculus are classical techniques; no claim of historical priority is made for their application here.

Classical references:

* NIST Digital Library of Mathematical Functions, Sections 25.4 and 5.11: completed-zeta reflection formulas and gamma asymptotics.
* Masatoshi Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096v2, manuscript version August 24, 2026: actual explicit formula, localized closed forms, self-adjoint realization, compact smooth form core, and localized spectral bottom.
* The prior collaboration's note *Five-dimensional strain completion and the exact signature of the Weil form*: the source evaluation/reflection representation retained in (1).
* The prior collaboration's note *Work balance and toroidal quadrupole selection*: the exact angular normalization and central-strain reconstruction retained in (28)–(30).

`checks.py` executes 115 exact finite/symbolic controls. Its zero divisor is an explicitly labeled synthetic polynomial, not zeta. It checks multiplicity normalization, all cardinal evaluations on that divisor, reflection and negative-coordinate identities, translation amplitudes, toroidal angular normalization, the radial/logarithmic current identities, and the complete cubic-jet control for the inner diffusive flux. It does not execute the analytic limit arguments, evaluate a purported off-critical zeta zero, integrate NS, or compile Agda/Lean.
