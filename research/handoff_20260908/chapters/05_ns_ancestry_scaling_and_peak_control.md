# Part V. NS: renormalized ancestry, endpoint observations, and the correct quantitative controls

## 27. Exact peak ledger, before taking any limit

At a differentiability time of the maximum envelope, choose a maximizing point realizing the envelope derivative. Write \(m=|\omega|\), \(\xi=\omega/m\), and \(\alpha=\xi^TS\xi\). The actual magnitude equation is

\[
D_tm=\alpha m+\nu(\Delta m-m|\nabla\xi|^2).
\]

At that point,

\[
\boxed{\alpha=\frac{M'}M+\nu|\nabla\xi|^2+\nu\frac{-\Delta m}{M}.}
\]

All three terms on the right are nonnegative on increasing-envelope times. With the instantaneous core length \(r=M^{-1/2}\), \(y=(x-x_t)/r\), \(\widetilde m=m/M\), and \(d\tau=Mdt\),

\[
\boxed{\frac\alpha M=\partial_\tau\log M+\nu|\nabla_y\xi|^2+\nu[-\Delta_y\widetilde m].}
\]

Unbounded \(M\) forces infinite positive variation of \(\log M\), and therefore infinite accumulated actual positive peak stretching on the corresponding physical history. This is a statement about the full growing history, not a claim that the integral on each fixed backwards rescaled window diverges. Keep that quantifier distinction.

A moving maximizer need not be a differentiable trajectory and is not automatically Lagrangian. Use envelope/Dini derivative arguments for the supremum and material derivatives only along specified particle paths. At zeros of \(\omega\), the direction is undefined; no formula involving \(\xi\) is applied there.

## 28. Two independently incomplete scale readings determine one normalization

Take a spatial dimension \(d\ge2\) and the physical re-coordinate

\[
V(z,\tau)=A\,u(x_n+\ell z,t_n+\tau_0\tau).
\]

In dimensions other than three, vorticity means the antisymmetric first-derivative tensor. The scale gains are

\[
g_\omega=A\ell,\qquad g_E=A^2\ell^{-d},\qquad g_C=A^2\ell^{-2},
\]

where \(g_C\) is the squared \(\dot H^{d/2-1}\) gain. Three dimensions give the same gain for the helicity bilinear form. The exact relation is

\[
\boxed{g_C^{d+2}=g_\omega^{2(d-2)}g_E^4.}
\]

In logarithmic coordinates the three rows are \((1,1),(2,-d),(2,-2)\); the left-null vector is \((-2(d-2),-4,d+2)\). Vorticity normalization and energy retention require

\[
A\ell M=1,\qquad A^2\ell^{-d}=1.
\]

The joint observation matrix \(\left(\begin{smallmatrix}1&1\\2&-d\end{smallmatrix}\right)\) has determinant \(-(d+2)\), so

\[
\boxed{\ell_E=M^{-2/(d+2)},\quad A_E=M^{-d/(d+2)},\quad \tau_0=A_E\ell_E=M^{-1}.}
\]

The equation retains Euler balance, with

\[
\nu_E=\nu\tau_0/\ell_E^2=\nu M^{-(d-2)/(d+2)}.
\]

Vorticity plus critical-metric normalization instead gives

\[
\ell_C=A_C=M^{-1/2},\qquad g_E=M^{(d-2)/2}.
\]

For \(d>2\), nonunit \(M\), no single chart normalizes vorticity while preserving both energy and the critical metric isometrically. This is an **empty simultaneous-normalization fibre**, not an empty blow-up fibre. The mandatory transition is

\[
\boxed{R=\frac{\ell_E}{\ell_C}=M^{(d-2)/(2(d+2))},\quad
V_C(y,\tau)=R V_E(y/R,\tau),\quad \nu_E=\nu R^{-2}.}
\]

For \(d=3\): \(\ell_E=M^{-2/5}\), \(A_E=M^{-3/5}\), \(R=M^{1/10}\), \(\nu_E=\nu M^{-1/5}\), and \(\|V_C\|_{\dot H^{1/2}}^2=R^4\|V_E\|_{\dot H^{1/2}}^2\). For \(d=2\), energy and critical \(L^2\) scaling coincide; \(R=1\). These are dimensional identities, not a proof of the dimensional regularity dichotomy. Use fixed nondimensional units or ratios to a reference peak when taking logarithms of \(M\).

## 29. The same scale is forced by energy, remote strain, and spectral concentration

At a running record \(t_n\), set \(M_n=\|\omega(t_n)\|_\infty\), \(r_n=M_n^{-1/2}\), and

\[
U_n(y,\tau)=r_nu(x_n+r_ny,t_n+r_n^2\tau),\quad \Omega_n=\operatorname{curl}U_n.
\]

On any fixed backward normalized window within the classical lifetime,

\[
|\Omega_n|\le1,\quad |\Omega_n(0,0)|=1,\quad
\sup_\tau\|U_n\|_2^2\le E_0r_n^{-1}.
\]

The whole-space strain kernel has homogeneity \(-3\). For a smooth cutoff outside radius \(L\), integrate \(\Omega_n=\operatorname{curl}U_n\) once by parts. The differentiated kernel has \(L^2\) norm \(O(L^{-5/2})\), so

\[
\boxed{|S_{far,L}(0,\tau)|\le C E_0^{1/2}r_n^{-1/2}L^{-5/2}.}
\]

At \(L=C_0r_n^{-1/5}\),

\[
|S_{far,L}|\le C E_0^{1/2}C_0^{-5/2}
\]

uniformly in \(n\). This is tightness of the **whole far Biot–Savart strain**, not just a harmonic completion term. The physical radius is \(C_0M_n^{-2/5}\).

Independently, a smooth Fourier cutoff obeys

\[
\|\operatorname{curl}P_{\le K}u\|_\infty\le C K^{5/2}\|u\|_2.
\]

Choosing \(K=c(E_0)M^{2/5}\) makes the low-frequency contribution at most \(M/2\), hence

\[
\boxed{\|P_{>c(E_0)M^{2/5}}\omega\|_\infty\ge M/2.}
\]

The same estimate bounds low-frequency strain. The turnover-time damping at \(K_E\sim M^{2/5}\) is \(\nu K_E^2/M\sim\nu M^{-1/5}\), the same effective viscosity. These are two distinct spatial and spectral observations at one scale. Combining them into a genuinely joint microlocal concentration theorem would require localization/commutator estimates; the separate bounds do not automatically localize the same packet simultaneously.

In dimension \(d\), the corresponding statements use \(R_E=r^{-(d-2)/(d+2)}\), far decay \(L^{-(d+2)/2}\), and frequency \(K_E=M^{2/(d+2)}\).

## 30. Harmonic and pressure jets: keep the corrected scope

From energy alone, a harmonic velocity remainder on \(B_R\) satisfies

\[
|\nabla^m h(0)|\lesssim E_0^{1/2}r^{-1/2}R^{-m-3/2}.
\]

For \(R=r^{-\alpha}\), the sufficient exponent is \(\alpha>1/(2m+3)\). It is sharp in the energy-plus-local-vorticity observation class: for a homogeneous harmonic potential \(H_{m+1}\), \(h_m=\nabla H_{m+1}\),

\[
\Psi_m=-\frac{x\times h_m}{m+2},\qquad
W_R=\operatorname{curl}[\chi(x/R)\Psi_m]
\]

equals \(h_m\) on \(B_R\), has vorticity only in the outer shell, and has energy proportional to \(R^{2m+3}\).

Likewise a remote pressure \(k\)-jet has kernel \(O(|y|^{-k-3})\) and

\[
|\nabla^kp_{far}(0)|\lesssim E_0r^{-1}R^{-k-3}.
\]

Its energy-only exponent \(1/(k+3)\) has a matching remote swirl witness: scale a compact divergence-free velocity away from zero as \(R^{k/2}V(x/R)\). Then the \(k\)-th pressure derivative at zero is fixed while energy costs \(R^{k+3}\). The required nonzero derivative follows from

\[
\partial_3^k(\partial_1^2+\partial_2^2)|x|^{-1}\big|_{e_3}
=-\partial_3^{k+2}|x|^{-1}\big|_{e_3}\ne0.
\]

Two corrections override broad earlier prose:

**Equal physical targets.** The old comparison of pressure gradient threshold \(1/4\) and strain threshold \(1/5\) compared a zeroth-order velocity/frame coordinate to a derivative coordinate. A remaining constant pressure gradient is a uniform acceleration in a local whole-space chart:

\[
v(x,t)=u(x+a(t),t)-a'(t),\quad q(x,t)=p(x+a(t),t)+a''(t)\cdot x.
\]

It changes neither vorticity nor spatial velocity derivatives, although original periodic mean and pressure conventions must still be recorded. At physical velocity-gradient order one, the correct comparison is harmonic strain \(m=1\) versus pressure Hessian \(k=2\): **both are \(1/5\)**.

For an isolated velocity derivative order \(q\), energy-only exponents are \(1/(2q+3)\) versus \(1/(q+4)\), with difference \((q-1)/[(q+4)(2q+3)]\). This compares specific highest-jet residuals, not a proved total cost hierarchy for full nonlinear jet continuation; lower derivatives and cross-products also remain.

**Full normalized ancestry is stronger.** For \(m\ge2\), the \(W_R\) witnesses have vorticity growing like \(R^{m-1}\). They violate the running-record bound \(\|\Omega_n\|_\infty\le1\). Under that retained bound,

\[
\boxed{|\nabla^m u_{far}(0)|\le C_m\int_R^\infty r^{-m}dr
=\frac{C_m}{m-1}R^{1-m}\quad(m\ge2).}
\]

Every higher remote derivative then dies at any expanding radius. Strain \(m=1\) is the genuine borderline. Preserve the energy-only sharpness theorem; do not advertise it as sharp under all blow-up ancestry constraints. [S10, S15]

## 31. Coherent worldtube moments and why they do not deplete strain

For \(R_n=r_n^{-\alpha}\), \(1/5<\alpha<1\), and a fixed backward interval \(I=[-S,0]\), coarea selects one radius \(\rho_n\in[R_n,2R_n]\) with

\[
\int_I\int_{\partial B_{\rho_n}}|U_n|^2\le SE_0r_n^{-1}R_n^{-1}.
\]

For \(\phi_m=\nabla H_{m+1}\), with homogeneous harmonic \(H_{m+1}\), Stokes and Cauchy–Schwarz give

\[
\boxed{\int_I\left|\rho_n^{-(m+3)}
\int_{B_{\rho_n}}\Omega_n\cdot\phi_m\right|^2d\tau
\le C_mSE_0r_n^{-1}R_n^{-5}\to0.}
\]

The same radius works for all tests; in particular the mean vorticity vanishes in this time-averaged mesoscopic sense. A countable collection can be retained with the usual diagonal bookkeeping.

The earlier claim that this provides a nondegenerate dual control of strain was wrong. The exact toroidal shell satisfies **all these moments equal to zero on every centred ball**, yet imposes arbitrary central trace-free strain. Section 19 is the decisive counterexample. Gradient tests are the wrong polarization. The moment theorem remains a correct ancestry consequence, not the missing depletion theorem.

## 32. Energy-preserving Euler extraction and the pointed observation

Apply a second dilation \(V_n(z,\tau)=R_n^{-1}U_n(R_nz,\tau)\), so \(W_n=\operatorname{curl}V_n=\Omega_n(R_nz)\). Then

\[
\partial_\tau V_n+(V_n\cdot\nabla)V_n+\nabla P_n
=\nu R_n^{-2}\Delta V_n,
\quad \|V_n\|_2^2\le E_0r_n^{5\alpha-1}.
\]

For \(\alpha>1/5\), \(V_n\to0\) strongly in \(L^\infty_\tau L^2_{loc}\), \(V_n\otimes V_n\to0\) in \(L^\infty_\tau L^1_{loc}\), and \(W_n\to0\) in local \(H^{-1}\); bounded vorticity then gives weak local \(L^2\) convergence. Nevertheless \(|W_n(0,0)|=1\). The point observation does not descend to this weak limit. No contradiction follows.

At \(\alpha=1/5\), the physical chart is

\[
V_n=M_n^{-3/5}u(x_n+M_n^{-2/5}z,t_n+M_n^{-1}\tau).
\]

It retains the global energy exactly (on the appropriately rescaled domain), and

\[
\nu M_n^{-1/5}\int_{-S}^0\|\nabla V_n\|_2^2d\tau
=\nu\int_{t_n-S/M_n}^{t_n}\|\nabla u\|_2^2dt\to0.
\]

Bounded local vorticity and energy give local div–curl bounds. A spacetime Euler limit requires a compatible time compactness/pressure argument, and nontriviality is **not** supplied by a point value under weak convergence. Claims about a conserved energy of the limit additionally need tightness and adequate strong convergence; exact conservation in the finite-stage chart does not alone provide them.

For \(0<\mu\le1\), define

\[
\eta_{\mu,n}=[W_n(\cdot,0)]_{C^\mu}
=M_n^{-1-2\mu/5}[\omega(\cdot,t_n)]_{C^\mu}.
\]

For the principal Poisson-source symbol,

\[
\sup_{|n|=1}\|\sigma(\Pi_V)(x,n)-\sigma(\Pi_V)(y,n)\|
=|W(x)-W(y)|.
\]

Thus \(\eta_\mu\) is exactly its spatial Hölder modulus, not merely an analogy. If it is uniformly bounded along snapshots, Arzelà–Ascoli preserves \(|W_*(0)|=1\); local div–curl/Rellich gives a nonzero spatial velocity limit. A nontrivial **spacetime** Euler realization and its time-zero trace remain separately to be checked. Conversely a sequence with no such spatial pointed subsequence has no bounded subsequence of \(\eta_\mu\).

Let \(U=\|u\|_2\), \(H_\mu=[\omega]_{C^\mu}\). The finite-energy vorticity scale and its normalized form are

\[
\ell_\mu=(H_\mu/U)^{-2/(2\mu+5)}
=\ell_E(U/\eta_\mu)^{2/(2\mu+5)},
\]
\[
\ell_\mu^{-5/2}=M(\eta_\mu/U)^{5/(2\mu+5)}.
\]

The direct singular-integral split

\[
\|S\|_\infty\le C_\mu(H_\mu L^\mu+U L^{-5/2})
\]

optimizes to

\[
\boxed{\|S\|_\infty/M\le C_\mu U^{2\mu/(2\mu+5)}\eta_\mu^{5/(2\mu+5)}.}
\]

Hence blow-up requires divergence of the corresponding integral in turnover time \(d\tau=Mdt\). This is an upper bound and a necessary divergence criterion, not a universal estimate proving finiteness.

The original prose cited a current Constantin–Ignatova–Vicol result as context. Verify the exact publication and its hypotheses before using that attribution; the scale algebra and kernel split above are independently written here.

## 33. Adaptive gauges: kinetic neutrality and the critical-metric weight

For a positive \(C^1\) scale function \(M(t)\), not necessarily a differentiable moving maximum everywhere, set

\[
\ell=M^{-2/5},\quad A=M^{-3/5},\quad \tau'=M,
\quad V=A u(a(t)+\ell y,t),
\]
\[
\beta=M'/M^2,\qquad c=a'/(M\ell).
\]

The exact equation is

\[
\boxed{\partial_\tau V+(V-c)\cdot\nabla V+\nabla P
=\nu M^{-1/5}\Delta V-\beta\mathcal D_EV,\quad
\mathcal D_E=\tfrac35I+\tfrac25y\cdot\nabla.}
\]

On \(L^2(\mathbb R^3)\), \((y\cdot\nabla)^*=-y\cdot\nabla-3\), so \(\mathcal D_E\) is skew-adjoint on its natural dilation core. In \(\dot H^s\), its real quadratic weight is \(2s/5\). The energy chart introduces no fictitious kinetic work, but at \(s=1/2\), with \(Y=\|V\|_{\dot H^{1/2}}^2\),

\[
\boxed{\tfrac12Y'+\tfrac\beta5Y+\nu M^{-1/5}\|V\|_{\dot H^{3/2}}^2
=2\Re\langle X_+,B_VX_-\rangle.}
\]

Therefore

\[
\int_{\tau_0}^{\tau_1}\|B_V\|d\tau
\ge\tfrac15\log\frac{M_1}{M_0}+\tfrac12\log\frac{Y_1}{Y_0}.
\]

This inequality does not create a new depletion gain: \(\|B_V\|_{ess}\) already equals half the strain eigenvalue spread. Its useful role is exact metric bookkeeping.

The scale ratio satisfies \(d\log R=(\beta/10)d\tau\). This is exact connection data, with trivial loop integral for a closed scalar scale path. An unbounded endpoint scale ratio is not a nontrivial finite-loop cohomology class.

If \(|W(0)|=1\), \([W]_{C^\mu}=\eta\), a compact bump test aligned with \(W(0)\) on radius \(r_\eta\asymp\eta^{-1/\mu}\) gives

\[
\|V\|_2^2\gtrsim_\mu\eta^{-5/\mu},\qquad
\|V\|_{\dot H^{1/2}}^2\gtrsim_\mu\eta^{-4/\mu}.
\]

The exponents follow from the \(\dot H^1\) and \(\dot H^{1/2}\) norms of the scaled test. Bounded \(\eta\) prevents critical-norm collapse and gives a logarithmic lower bound on accumulated \(\|B_V\|\).

The ratio \(\ell_\eta/\ell_C=M^{1/10}\eta^{-1/\mu}\) and formal diffusion rate \(\nu M^{-1/5}\eta^{2/\mu}\) locate a crossover. With fixed viscosity suppressed in units the old expression was \(\eta\sim M^{\mu/10}\); unit diffusion rate includes \(\nu^{-\mu/2}\). **A global Hölder seminorm is not a localized frequency measurement and does not give a lower bound on \(-\Delta|\omega|\) at its maximum.** The toroidal shell-plus-flat-core example has large strain/Hölder variation and zero viscous derivative at the centre. Retire the claim that this crossover alone proves the peak cannot escape.

## 34. A stronger estimate with the spatial supremum inside time

[S16] resolves the earlier fixed-centre quantifier problem. For a velocity source \(v\), define

\[
\mathcal H_\nu(v)=\int_0^\infty\|\operatorname{sym}\nabla e^{\nu t\Delta}v\|_\infty dt.
\]

Then

\[
\boxed{\mathcal H_\nu(v)\le\frac C\nu\|v\|_2^{1/2}\|\nabla v\|_2^{1/2},}
\]
\[
\mathcal H_\nu(v)\le\frac C\nu\|v\|_2^{2/3}\|v\|_\infty^{1/3},
\quad
\mathcal H_\nu(v)\le\frac C\nu\|v\|_2^{4/5}\|\operatorname{curl}v\|_\infty^{1/5}.
\]

For the first, put \(\tau=\nu t\) and split

\[
\|\nabla e^{\tau\Delta}v\|_\infty
\le C\min(\tau^{-3/4}\|\nabla v\|_2,\tau^{-5/4}\|v\|_2)
\]

at \(\tau=(\|v\|_2/\|\nabla v\|_2)^2\). The other versions use the short-time \(\tau^{-1/2}\|v\|_\infty\) estimate and the bounded-vorticity interpolation law.

For the actual nonlinear velocity source \(N_u=-\mathbb P(u\cdot\nabla u)\), set \(W=\|\nabla u\|_2\), \(P_2=\|\Delta u\|_2\). Product estimates give

\[
\|N_u\|_2\le CW^{3/2}P_2^{1/2},\qquad
\|\nabla N_u\|_2\le CW^{1/2}P_2^{3/2},
\]

hence \(\mathcal H_\nu(N_u)\le(C/\nu)WP_2\). Duhamel and Tonelli now prove

\[
\boxed{\int_0^T\|S_u(t)\|_\infty dt
\le\mathcal H_\nu(u_0)+\frac C\nu\int_0^T W(t)P_2(t)dt.}
\]

This genuinely dominates every measurable moving-centre and direction reading. It does not exchange a supremum and an integral. The remaining \(WP_2\) term is actual-source nonlinear replenishment, not universally bounded here.

## 35. A complete small-data control, not a claim of large-data closure

For \(E_0=\|u_0\|_2\), \(W_0=\|\nabla u_0\|_2\), the scale-critical product

\[
\eta_0=\sqrt{E_0W_0}/\nu
\]

has a standard smallness threshold. The enstrophy inequality can be written

\[
\tfrac12(W^2)'+\nu P_2^2\le C\sqrt{EW}\,P_2^2.
\]

If \(\eta_0\) is small enough, bootstrap gives \(W\le W_0\), \(\int P_2^2\lesssim W_0^2/\nu\), and kinetic energy gives \(\int W^2\le E_0^2/(2\nu)\). Thus

\[
\int_0^\infty\|S_u\|_\infty dt\le C(\eta_0+\eta_0^2).
\]

This supplies \(\mathsf B_{NS}\) on the stated small-data class. Applied to the shell construction, a spatial Euler compression \(u_R(x)=R u(x/R)\) preserves vorticity amplitude and central strain, while \(\|u_R\|_2\|\nabla u_R\|_2=R^4E_0W_0\). The family can therefore have arbitrarily large initial peak strain yet uniformly controlled integrated peak stretching and global smooth evolution. This is a sharp control against inferring singularity from the instantaneous shell geometry. The compression is not the fixed-viscosity NS symmetry; it produces new initial data.

## 36. Higher angular radial spectra and the claims still needing audit

[S20] writes a toroidal scalar radial profile in general angular degree \(l\). If \(b(\lambda)=r g(r)\), \(F(\lambda)=rf(r)\), \(\lambda=\log r\), the inverse equation takes the constant-coefficient form

\[
[-\partial_\lambda^2-3\partial_\lambda+l(l+1)-2]b=F,
\]

or \((l-1-\partial_\lambda)(l+2+\partial_\lambda)b=F\). This identifies the exact radial Green poles and the marginal \(l=2\) scale geometry. Retain the angular representation and matrix source; do not reduce an arbitrary nonlinear mode interaction to a positive scalar radial operator without proof.

[S21] and [S22] additionally proposed dynamically matched dissipation bands and iterated octave suppression. Their arithmetic conclusions receive a repaired proof later in [S19]. Their unrestricted NS claims require independent audit. In particular, logarithmic factors such as \(1+m/j_\varepsilon\) cannot be replaced by a uniform constant while \(m\to\infty\); “must cross adjacent bands” needs an exact paraproduct support statement compatible with high–high to low interactions and source-dependent coefficient tails. A claimed Gaussian-in-octave bound is not an established global theorem in this transfer. The rigorous whole-kernel statements in the next chapter do not depend on it.
