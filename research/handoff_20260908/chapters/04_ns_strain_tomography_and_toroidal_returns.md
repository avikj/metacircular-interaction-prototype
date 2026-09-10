# Part IV. NS: strain tomography, toroidal selection, and exact return memory

## 18. Critical cross-helicity operator: its essential norm is not a hidden depletion gain

On smooth mean-zero periodic fields put \(\Lambda=(-\Delta)^{1/2}\), \(J_{hel}=\operatorname{curl}\Lambda^{-1}\), and \(P_\pm=(I\pm J_{hel})/2\). The coadjoint generator in the critical coordinate is

\[
G_u=\Lambda^{1/2}M_u\Lambda^{-1/2},\quad
G_u^*J_{hel}+J_{hel}G_u=0.
\]

Let \(B_u=P_+G_uP_-\). Its symmetric part is

\[
Q_u=\frac{G_u+G_u^*}{2}=\begin{pmatrix}0&B_u\\B_u^*&0\end{pmatrix}.
\]

For \(n\in S^2\), \(P_n=I-nn^T\), [S09] computes the exact order-zero principal symbol

\[
\boxed{q_u(x,n)=-P_nS_u(x)P_n-\frac12(n^TS_u(x)n)P_n.}
\]

The scalar correction is produced by the half-order conjugation; omitting it changes the critical metric. On \(n^\perp\), this is minus the trace-free transverse strain. In an oriented transverse frame the cross-helicity amplitude is

\[
-\frac{S_{11}-S_{22}}2+iS_{12}.
\]

If \(\lambda_1\le\lambda_2\le\lambda_3\) are the strain eigenvalues, the classical order-zero symbol norm theorem on the compact torus gives

\[
\boxed{\|B_u\|_{ess}=\frac12\max_x(\lambda_3(x)-\lambda_1(x)).}
\]

Hence

\[
\frac34\|S_u\|_{L^\infty,op}\le\|B_u\|_{ess}\le\|S_u\|_{L^\infty,op}.
\]

The full source is recoverable from this symbol, not just its norm:

\[
\boxed{S_u(x)=-\frac52\int_{S^2}q_u(x,n)\,\frac{d\Omega}{4\pi},\qquad
u=-2(-\Delta)^{-1}\operatorname{div}S_u.}
\]

The velocity formula uses mean zero. Thus the essential cross-helicity class is a strain-complete source coordinate on that fixed domain. A changing-domain singular limit still requires its own topology.

For actual vorticity direction \(\xi\), and an orthonormal pair \(n_1,n_2\in\xi^\perp\),

\[
\boxed{\xi^TS_u\xi=-\frac23\xi^T(q_u(n_1)+q_u(n_2))\xi.}
\]

The true critical-norm production is

\[
\frac12\frac d{dt}\|u\|_{\dot H^{1/2}}^2+\nu\|u\|_{\dot H^{3/2}}^2
=2\Re\langle X_+,B_uX_-\rangle,
\quad X=\Lambda^{1/2}u.
\]

Thus \(\int\|B_u\|dt<\infty\) is a sufficient regularity condition, but its essential norm is comparable to full strain. Passing to that arbitrary-input norm is not automatically a sharper depletion theorem. The signed actual-source contraction retains information the norm removes. Compactness of \(B_u\) on the torus would already force zero strain and, after mean-zero normalization, zero velocity; it is far stronger than regularity.

## 19. Exactly one angular polarization generates central strain

For smooth whole-space decaying vorticity, write \(y=rn\). Differentiating Biot–Savart gives

\[
S(0)=\frac3{8\pi}\operatorname{p.v.}\int_0^\infty\frac{dr}{r}
\int_{S^2}[n\otimes(n\times\omega(rn))+(n\times\omega(rn))\otimes n]d\Omega.
\]

For \(A\in\operatorname{Sym}_0(3)\), define

\[
T_A(n)=n\times An=\frac12n\times\nabla_{S^2}(n^TAn).
\]

These are the toroidal degree-two vector spherical harmonics, with

\[
\int_{S^2}T_A\cdot T_B\,d\Omega=\frac{4\pi}{5}\operatorname{tr}(AB).
\]

Define the full matrix-valued radial projection \(F(r)\) of \(\omega\) by

\[
\int_{S^2}\omega(rn)\cdot T_B(n)d\Omega=\frac{4\pi}{5}\operatorname{tr}(F(r)B).
\]

Then

\[
\boxed{\omega_2(rn)=n\times F(r)n,\qquad
S_u(0)=-\frac35\operatorname{p.v.}\int_0^\infty F(r)\frac{dr}{r}.}
\]

There are five matrix components at each radius, not a five-dimensional autonomous fluid state. All other angular modes are instantaneously invisible to the central strain but may affect its future.

For a source \(f(r)T_A(n)\), every gradient moment vanishes on every concentric ball:

\[
\boxed{\int_{B_\rho}\omega\cdot\nabla H\,dx=0\quad\text{for every smooth }H\text{ and every }\rho.}
\]

The proof uses zero divergence and tangency to every sphere. Yet

\[
S(0)=-\frac35\left(\int f(r)\frac{dr}{r}\right)A.
\]

Thus all the previously extinguished harmonic-gradient moments can be exactly zero while central strain is prescribed arbitrarily. Those moments measure the wrong angular polarization for depletion. This is a valid observation separator, not a counterexample to reconstruction from the full vorticity field. [S10]

A rotating core with constant nonzero vorticity can be added inside a source-free shell. The core's local vorticity and all those moments agree with or without the outer shell, but the actual first NS continuation at the centre changes by \(S_A(0)\omega_0\). These are genuine smooth initial data, not stitched stages of one singular solution.

## 20. Complete toroidal source inverse and exact physical pressure

For arbitrary matrix profile \(F(r)\), define

\[
G(r)=\frac15\left[r^{-5}\int_0^r s^4F(s)ds+\int_r^\infty F(s)\frac{ds}{s}\right],
\]
\[
G''+\frac6rG'=-\frac F{r^2},\quad
\psi_2(x)=x\times(G(|x|)x),\quad u_2=\operatorname{curl}\psi_2.
\]

Then \(\operatorname{curl}u_2=\omega_2\) and \(S_{u_2}(0)=-3G(0)=S_u(0)\). Put \(u_\perp=u-u_2\), so its central strain is zero.

Let

\[
H[u]=(\operatorname{Hess}(-\Delta)^{-1}\operatorname{tr}((\nabla u)^2))(0)_0
\]

be the trace-free physical pressure Hessian. [S12] proves

\[
\boxed{H[u_2]= -\frac27(S_u(0)^2)_0.}
\]

This holds for arbitrary matrix-valued radial profiles; \(G,G',G''\) need not commute. At a radius, writing \(V=rG'\), \(W=r^2G''\), the exact spherical identity is

\[
\frac1{4\pi}\int(3nn^T-I)\operatorname{tr}((\nabla u_2)^2)d\Omega
=\frac{12}{35}[18G\circ V+3G\circ W+2V^2-V\circ W]_0,
\]

where \(X\circ Y=(XY+YX)/2\). The radial integrand is the derivative of

\[
\frac{15}{2}G^2+3rG\circ G'-\frac{r^2}{2}(G')^2.
\]

The actual remaining pressure is the source cross-effect

\[
\boxed{K[u]:=H[u]+\frac27(S_u(0)^2)_0=2H(u_2,u_\perp)+H[u_\perp].}
\]

No sign is claimed for this residual. In particular, assigning an independent pressure Hessian to a local strain is not a source-consistent closure.

For \(\Omega_{rot}=\operatorname{skew}\nabla u\),

\[
D_tS=-(S^2)_0-(\Omega_{rot}^2)_0-H[u]+\nu\Delta S,
\quad (\Omega_{rot}^2)_0=\tfrac14(\omega\otimes\omega)_0.
\]

Thus

\[
\boxed{D_tS=-\frac57(S^2)_0-\frac14(\omega\otimes\omega)_0-K[u]+\nu\Delta S.}
\]

The pure source-free quadrupole core gives the instantaneous \(-5/7\) law. It does not prove an invariant five-dimensional source manifold: degree four is emitted elsewhere at that same instant.

## 21. Actual quadratic leakage: degree two emits degree four

For an aligned source \(\omega=fT_A\), set

\[
B=(A^2)_0,\quad q=\operatorname{tr}(A^2),\quad s_A=n^TAn,
\]
\[
Y_4=s_A^2-\frac47n^TBn-\frac2{15}q,
\quad T_4[A]=\frac14n\times\nabla_{S^2}Y_4=s_AT_A-\frac27T_B.
\]

With the scalar \(g\) inverse from the previous section,

\[
u=-(3g+rg')Ax+\frac{g'}r(x^TAx)x.
\]

The **actual** nonlinear vorticity source is

\[
\boxed{\mathcal N(fT_A)=\beta_2T_B+\beta_4T_4[A],}
\]
\[
\boxed{\beta_2=\frac67(5gf+2rg'f+rgf'),\qquad
\beta_4=3rgf'-6gf-rg'f.}
\]

The angular norm is

\[
\frac1{4\pi}\int|T_4[A]|^2d\Omega=\frac4{245}(\operatorname{tr}A^2)^2.
\]

For a nonnegative nonzero compact annular \(f\), \(g>0\). If \(\beta_4\equiv0\) on a positive component, then \(f=Cr^2g^{1/3}\), incompatible with vanishing at a finite support boundary. Thus the pure degree-two source space is not invariant.

Both emitted radial forcings are generically signed:

\[
\beta_2=\frac6{7r^4g}\partial_r(r^5g^2f),\qquad
\beta_4=3r^3g^{4/3}\partial_r\left(\frac f{r^2g^{1/3}}\right).
\]

Their bracketed functions vanish at both support ends and are positive somewhere. Do not carry the original nonnegative-source cone forward as a property of the generated forcing.

## 22. Exact free viscous response and all its temporal moments

Define

\[
H_5(q)=\operatorname{erf}q-\frac{2e^{-q^2}}{\sqrt\pi}\left(q+\frac23q^3\right)
=\frac{\gamma(5/2,q^2)}{\Gamma(5/2)}.
\]

For the full actual initial vorticity and its toroidal coefficient \(A_{\omega_0}(r)\),

\[
\boxed{S_{e^{\nu t\Delta}u_0}(0)
=-\frac35\int_0^\infty H_5\!\left(\frac r{2\sqrt{\nu t}}\right)A_{\omega_0}(r)\frac{dr}{r}.}
\]

Two derivations are retained [S13]: the regularized Newton potential

\[
\Phi_t(r)=\frac{\operatorname{erf}(r/(2\sqrt{\nu t}))}{4\pi r},\quad
\Phi_t''-\Phi_t'/r=\frac3{4\pi r^3}H_5,
\]

and the radial heat equation \(\partial_tA=\nu(A''+2A'/r-6A/r^2)\), transformed by \(A=r^2b\) into seven-dimensional radial heat.

The exact integrated response is

\[
\boxed{\int_0^\infty H_5\!\left(\frac r{2\sqrt{\nu t}}\right)dt=\frac{r^2}{6\nu}.}
\]

More generally, for \(-1<p<3/2\),

\[
\int_0^\infty t^pH_5\!\left(\frac r{2\sqrt{\nu t}}\right)dt
=\left(\frac{r^2}{4\nu}\right)^{p+1}
\frac{\Gamma(3/2-p)}{(p+1)\Gamma(5/2)}.
\]

The first time moment is \(r^4/(24\nu^2)\); the second diverges. The true response has an algebraic tail, not an assumed exponential memory.

Therefore, under the explicit absolute-moment hypothesis,

\[
\boxed{\int_0^\infty S_{heat}(0,t)dt=-\frac1{10\nu}\int_0^\infty rA_{\omega_0}(r)dr,}
\]
\[
\int_0^\infty\|S_{heat}(0,t)\|dt\le\frac1{10\nu}\int_0^\infty r\|A_{\omega_0}(r)\|dr.
\]

For actual NS, replace the initial source by Duhamel's complete source history

\[
\mathcal N(s)=\operatorname{curl}(u(s)\times\omega(s)).
\]

This gives the same heat kernel applied to \(A_{\omega_0}\), plus its causal convolution against \(A_{\mathcal N(s)}\). It retains all angular sectors through the actual nonlinear injection. A fixed-centre signed memory identity is not yet an integral of the supremum over moving peaks.

## 23. Strain potential: coboundary plus nonlinear source residual

Let \(L=-\Delta\), \(\mathcal B_{str}\omega=S\), and define

\[
\Pi_{pot}[\omega]=\mathcal B_{str}L^{-1}\omega=L^{-1}S.
\]

This notation is distinct from the skew Poisson operator \(\Pi_u\). On the appropriate decaying smooth domain,

\[
\partial_t\Pi_{pot}[\omega]=\Pi_{pot}[\mathcal N]-\nu S.
\]

Thus at a fixed centre,

\[
\nu\int Sdt=\Pi_{pot}[\omega](t_0)-\Pi_{pot}[\omega](t_1)
+\int\Pi_{pot}[\mathcal N]dt.
\]

In material form,

\[
\nu S=-D_t\Pi_{pot}[\omega]+\mathcal R,
\quad
\mathcal R=[u\cdot\nabla,\Pi_{pot}]\omega+\Pi_{pot}[(\omega\cdot\nabla)u].
\]

Along a particle, this is a temporal coboundary plus the full nonlinear residual. A genuinely closed endpoint potential removes that endpoint difference, not the residual integral. For actual directional stretching, the direction must also be differentiated:

\[
\nu\int\xi^TS\xi\,dt
=[\xi^T\Pi_{pot}\xi]_{t_0}-[\xi^T\Pi_{pot}\xi]_{t_1}
+\int[\xi^T\mathcal R\xi+2(D_t\xi)^T\Pi_{pot}\xi]dt.
\]

The endpoint estimate is

\[
\|\Pi_{pot}[\omega]\|_\infty
\le C\|u\|_2^{4/5}\|\omega\|_\infty^{1/5}.
\]

It follows by splitting the \(\operatorname{sym}\nabla L^{-1}\) kernel into near \(O(\|u\|_\infty R)\) and far \(O(\|u\|_2R^{-1/2})\) parts and using \(\|u\|_\infty\le C\|u\|_2^{2/5}\|\omega\|_\infty^{3/5}\). In the energy/vorticity chart it is uniformly bounded. That does not by itself bound its full nonlinear circulation or the direction term.

## 24. First nonlinear quadrupole memory: positive cone, signed spectrum

For the actual \(\beta_2\),

\[
\int r\beta_2(r)dr=\frac67\mathcal I[f],\quad
\mathcal I[f]=\int(9rg^2-r^3(g')^2)dr.
\]

Its exact two-radius expression is

\[
\boxed{\mathcal I[f]=\iint f(s)f(t)K(s,t)dsdt,}
\]
\[
K(s,t)=\frac{\min(s,t)}{10\max(s,t)}
\left[3-2\left(\frac{\min(s,t)}{\max(s,t)}\right)^3\right].
\]

Thus for nonzero \(f\ge0\), \(\mathcal I[f]>0\), and the signed future heat memory of the initial nonlinear source is

\[
-\frac3{35\nu}\mathcal I[f](A^2)_0.
\]

However \(K\) is not PSD on signed sources. At radii 1 and 2 its matrix is

\[
\begin{pmatrix}1/10&11/80\\11/80&1/10\end{pmatrix},
\]

with eigenvalues \(19/80\) and \(-3/80\). Smooth approximations preserve negative values.

In log radius \(x=\log r\), put \(F(x)=e^xf(e^x)\), \(b(x)=e^xg(e^x)\). Then

\[
F=(1-\partial_x)(4+\partial_x)b,
\quad \mathcal I[f]=8\|b\|_2^2-\|b'\|_2^2,
\]
\[
\boxed{\mathcal I[f]=\frac1{2\pi}\int
\frac{8-\xi^2}{(1+\xi^2)(16+\xi^2)}|\widehat F(\xi)|^2d\xi.}
\]

The sign changes at \(|\xi|=\sqrt8\). On the restricted cone \(f\ge0\), the sharper bound \(\|b'\|_2^2\le4\|b\|_2^2\) gives \(\mathcal I[f]\ge4\|b\|_2^2\), with sharp constant under concentrated-shell approximation. [S16]

That cone is not preserved for generated forcing. For \(f_\epsilon(r)=\phi((r-1)/\epsilon)\), \(\phi\ge0\), \(m_0=\int\phi\), the actual emitted degree-two profile satisfies

\[
\boxed{\mathcal I[\beta_{2,\epsilon}]
=-\left(\frac{6m_0}{35}\right)^2\epsilon^3\int\phi^2+O(\epsilon^4)<0.}
\]

This is a channel-specific statement, not the sign of the entire next Duhamel coefficient.

## 25. Exact actual \(2\to4\to2\) return

Let \(a=fT_A\) and \(b=hT_4[A]\). The degree-four inverse is

\[
p''+\frac6rp'-\frac{14}{r^2}p=-\frac h{r^2},
\]
\[
p(r)=\frac19\left[r^{-7}\int_0^r s^6h(s)ds+r^2\int_r^\infty h(s)\frac{ds}{s^3}\right].
\]

The full actual derivative, not one frozen factor, is

\[
D\mathcal N(a)b=\operatorname{curl}(u_a\times b+u_b\times a).
\]

[S15] computes

\[
\boxed{P_2D\mathcal N(fT_A)[hT_4[A]]
=\frac{4\operatorname{tr}(A^2)}{49}\mathcal C[f,h]T_A,}
\]
\[
\mathcal C[f,h]=15gh+6rg'h+3rgh'+pf-rp'f-4rpf'.
\]

The actual first return takes \(h=\beta_4[f]\). Its angular coefficient follows from

\[
P_2(Y_2[A]Y_4[A])=\frac{24}{245}\operatorname{tr}(A^2)Y_2[A].
\]

The signed integrated heat response is

\[
\boxed{
\int_0^\infty\mathcal B_{str}e^{\nu t\Delta}
P_2D\mathcal N(fT_A)[hT_4[A]](0)dt
=-\frac{6\operatorname{tr}(A^2)}{245\nu}\mathcal J_{24}[f,h]A,
}
\]

where \(\mathcal J_{24}[f,h]=\iint f(s)h(t)L_{24}(s,t)dsdt\) and

\[
L_{24}(s,t)=
\begin{cases}
\frac35(t/s)-\frac49(t/s)^6,&t\le s,\\
\frac59(s/t)^3-\frac25(s/t)^4,&s\le t.
\end{cases}
\]

Both branches are positive and meet at \(7/45\), but the second argument has its actual source sign. The kernel is directional: it maps an \(l=2\) radius and an \(l=4\) radius, so symmetrizing changes the operation.

The exact integration by parts is

\[
r\mathcal C=3[(3rg+r^2g')h+(3rp+r^2p')f]
+\partial_r(3r^2gh-4r^2pf).
\]

Two actual-source sign controls are retained:

* For \(g=(1+r^2)^{-2}\), \(f=4r^2(r^2+7)/(1+r^2)^4>0\) and \(\beta_4=-8r^4(7r^2+67)/(1+r^2)^7<0\). Hence \(\mathcal J_{24}<0\): the returned integrated contribution opposes initial strain \(-3A\). Compact annular approximations preserve the sign.
* For \(f_\epsilon=\epsilon^{-1}\phi((r-1)/\epsilon)\), \(\int\phi=1\), the same-source value tends to \(151/225>0\), so the returned contribution reinforces initial strain. This is a smooth thin-shell asymptotic, not a product of delta distributions. Positive amplitude normalization preserves the sign.

The cubic time-ordered contribution is

\[
h_4(t)=\int_0^tE_4(t-s)\beta_4[f_s]ds,\quad f_s=E_2(s)f,
\]
\[
\frac{4q}{49}\int_0^tE_2(t-s)\mathcal C[f_s,h_4(s)]ds\,T_A.
\]

The complete kernel chapters below generate this and every higher source-sharing return without inventing a new model per itinerary.

## 26. Zeno stacks: instantaneous growth, finite memory, and a globally regular control family

Use \(R_j=4^{-j}\) and nonnegative annular \(\phi\). Let \(f_N=\sum_{j=1}^N\phi(r/R_j)\). Every shell adds the same central strain, while its velocity energy costs \(R_j^5\). A tiny solid-rotation core fixes unit central vorticity and zero local derivatives of vorticity. Then

\[
\|\omega_N\|_\infty=1,\quad \sup_N\|u_N\|_2<\infty,\quad b_{u_N}(0)\gtrsim N.
\]

At the centre the initial viscous vorticity term is zero, so actual initial growth can be arbitrarily large at fixed \(\nu\), energy, and peak. These are different initial data, not a constructed blow-up history.

The same sources have uniformly bounded free heat-strain memory because \(\sum_jR_j^2=1/15\). The initial nonlinear injection can have instantaneous pure feedback \(O(N^2)\), but its signed free memory is controlled by \(\sum_jjR_j^2=16/225\). The first returned \(2\to4\to2\) source has the stronger absolute-in-time bound controlled by

\[
\sum_{j\ge1}j^2R_j^2=272/3375.
\]

All cross-shell interactions at that specified stage are included. No uniform all-depth bound follows merely by inspecting these first three sums.

[S16] goes further: after a common sufficiently small **Euler spatial compression** \(u_R(x)=Ru(x/R)\), the same shell families fall in the classical small energy–enstrophy regime, while vorticity and initial strain amplitudes remain unchanged. The scale-critical NS quantity \(\|u\|_2\|\omega\|_2\) changes under this compression; it is not the NS symmetry. Therefore one gets actual globally smooth solutions with uniformly bounded total peak stretching and arbitrarily large initial peak stretching. This is a restricted control family, not a way to rescale arbitrary NS data into small data.
