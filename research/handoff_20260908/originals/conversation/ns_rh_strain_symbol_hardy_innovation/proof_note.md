# Essential strain reconstruction and exact Hardy source recovery

Date: 2026-09-07.
Repository snapshot read: `avikj/metacircular-interaction-prototype`, `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope

The results below are smooth periodic operator identities, principal-symbol and essential-norm theorems, and exact recovery/conditioning results for the specified arithmetic receiver. Classical pseudodifferential symbol theory, Hardy-space factorization, and an unconditional positive proportion of simple critical-line zeros are declared analytic inputs. The finite check script verifies algebraic identities, not these analytic inputs or global PDE continuation. No proof of RH or general Navier–Stokes regularity, originality-priority claim, or proof-assistant build is made.

The main NS result identifies the essential norm of the previously defined coadjoint cross-helicity block with one half of the pointwise strain spectral spread. Its full principal symbol reconstructs the strain, including the signed source-dependent stretching pairing. The RH result recovers the original received arithmetic signal directly from its positive two-time Hardy Gram kernel by a first-order differential operator; it does not first recover individual zeros. The finite-mode extraction problem has an exact Cauchy/Schur residual product, and its infinite system is individually minimal but not uniformly conditioned.

# I. Navier–Stokes: the essential cross-helicity operator is strain tomography

## 1. Declared generator and actual physical trajectory

On the flat three-torus let \(H\) be the complexification of mean-zero divergence-free \(L^2\) vector fields. Let \(\mathbb P\) be its orthogonal Leray projection, \(\Lambda=(-\Delta)^{1/2}\), and
\[
J=\operatorname{curl}\Lambda^{-1},\qquad P_\pm=\frac{I\pm J}{2}.
\]
All inverse multipliers act on nonzero Fourier modes.

For a real smooth divergence-free source velocity \(u\), write
\[
A=\nabla u,\qquad S=\frac{A+A^\top}{2},\qquad D_u=u\cdot\nabla.
\]
The coadjoint generator is
\[
M_uw=-\mathbb P\bigl(D_uw+A^\top w\bigr).
\]
This is not the full derivative of the autonomous Euler vector field. It is a specified source-dependent factorization satisfying
\[
M_uu=-\mathbb P((u\cdot\nabla)u)=N(u).
\]
Thus the actual NS trajectory in critical coordinates \(X=\Lambda^{1/2}u\) satisfies
\[
X_t=G_uX+\nu\Delta X,\qquad
G_u=\Lambda^{1/2}M_u\Lambda^{-1/2}.
\]
A parameter variation of the common source must still differentiate both source occurrences; nothing below freezes one occurrence and calls it the true variation.

Helicity conservation for prescribed coadjoint transport implies, on the smooth core,
\[
G_u^*J+JG_u=0.
\]
Set
\[
Q_u=\frac{G_u+G_u^*}{2},\qquad B_u=P_+G_uP_-.
\]
Then
\[
Q_u=\begin{pmatrix}0&B_u\\B_u^*&0\end{pmatrix}
\]
in the helical splitting. Although \(G_u\) is first order, \(Q_u\) and \(B_u\) are classical order-zero pseudodifferential operators.

## 2. Exact principal symbol

For a unit frequency direction \(n\), put \(P_n=I-nn^\top\). Regard the following matrix as acting on \(n^\perp\), or extend it by zero on \(\mathbb R n\):
\[
\boxed{
q_u(x,n)=-P_nS(x)P_n-\frac12(n^\top S(x)n)P_n.
}
\tag{1}
\]
This is the principal symbol of \(Q_u\).

To derive it, use \(D_u^*=-D_u\) and commutation of \(\Lambda\) with the Leray projector. The transport contribution to \(Q_u\) is
\[
\frac12\mathbb P\bigl(\Lambda^{-1/2}D_u\Lambda^{1/2}
-\Lambda^{1/2}D_u\Lambda^{-1/2}\bigr)\mathbb P.
\]
For a general weight exponent \(a\),
\[
\sigma_0([\Lambda^a,D_u]\Lambda^{-a})
=a\,n^\top S n.
\]
The displayed transport contribution therefore has symbol \(-\tfrac12(n^\top Sn)P_n\). The symmetric part of the matrix-multiplication terms has symbol \(-P_nSP_n\), proving (1).

There is an independent Fourier derivation. For a source mode \(u_p\), an input mode \(l\), and output \(k=l+p\), let \(r=(|k|/|l|)^{1/2}\). With \(p\cdot u_p=0\), the \(Q_u\) matrix coefficient is
\[
\frac i2P_k\left[
(r^{-1}-r)(u_p\cdot l)I-rpu_p^\top-r^{-1}u_pp^\top
\right]P_l.
\]
As \(l=Nn\),
\[
r^{-1}-r=-\frac{n\cdot p}{N}+O(N^{-2}),
\]
and the coefficient tends to the corresponding Fourier coefficient of (1).

Since \(\operatorname{tr}S=0\),
\[
\operatorname{tr}_{n^\perp}(P_nSP_n)=-n^\top Sn.
\]
Therefore (1) is minus the trace-free part of the strain restricted to the transverse plane. In an orthonormal transverse basis \((e_1,e_2)\),
\[
q_u|_{n^\perp}=
-\begin{pmatrix}
(S_{11}-S_{22})/2&S_{12}\\
S_{12}&-(S_{11}-S_{22})/2
\end{pmatrix}.
\tag{2}
\]
Its eigenvalues are
\[
\pm\sqrt{\bigl((S_{11}-S_{22})/2\bigr)^2+S_{12}^2}.
\]
For circular polarizations \(h_\pm=(e_1\pm ie_2)/\sqrt2\), the cross-helicity scalar symbol, up to the chosen helicity convention, is
\[
\langle h_+,q_uh_-\rangle
=-\frac{S_{11}-S_{22}}2+iS_{12}.
\]
Its modulus is precisely the transverse strain anisotropy.

## 3. Essential norm theorem

Let \(\lambda_1(x)\le\lambda_2(x)\le\lambda_3(x)\) be the strain eigenvalues. Then
\[
\boxed{
\|B_u\|_{\rm ess}=\|Q_u\|_{\rm ess}
=\frac12\max_x(\lambda_3(x)-\lambda_1(x)).
}
\tag{3}
\]
Here the essential norm of \(B_u:H_-\to H_+\) is its distance to compact operators between those Hilbert spaces.

The classical principal-symbol exact sequence identifies the norm modulo compact operators of an order-zero classical operator with the supremum of its principal-symbol norm. Apply its matrix-valued version and then the Leray/helicity corners. For any transverse plane, the restricted strain's eigenvalue spread is at most \(\lambda_3-\lambda_1\), by the Rayleigh principle. Equality is attained by the plane spanned by the extreme eigenvectors, with normal an intermediate eigenvector. Formula (2) contributes one half of this spread. Finally the off-diagonal block representation of \(Q_u\) gives equality of its essential norm and that of \(B_u\).

For trace-free symmetric matrices,
\[
\boxed{
\frac34\|S\|_{L^\infty,\rm op}
\le\|B_u\|_{\rm ess}
\le\|S\|_{L^\infty,\rm op}.
}
\tag{4}
\]
Indeed the extreme eigenvalues have opposite signs, and the smaller extreme magnitude is at least one half of the larger.

Consequently, compactness of \(B_u\) forces \(S=0\). On the torus this makes \(u\) spatially constant; mean zero gives \(u=0\). Thus vanishing or compactness of the arbitrary-input cross-helicity block is not an admissible general regularity target: every nonzero smooth mean-zero flow already has a noncompact cross-helicity block.

Similarly, integrability of this essential norm is equivalent, up to fixed constants, to integrability of the full strain supremum. The essential-norm reformulation does not by itself introduce a weaker depletion condition. Finite strain-supremum integral bounds the maximum vorticity by its maximum principle and gives the usual smooth continuation implication.

## 4. Full source recovery from the essential symbol

Let \(d\mu(n)=d\Omega(n)/(4\pi)\). Exact spherical second and fourth moments give
\[
\int_{\mathbb S^2}P_nSP_n\,d\mu(n)=\frac7{15}S,
\quad
\int_{\mathbb S^2}(n^\top Sn)P_n\,d\mu(n)=-\frac2{15}S.
\]
Thus
\[
\boxed{
S(x)=-\frac52\int_{\mathbb S^2}q_u(x,n)\,d\mu(n).
}
\tag{5}
\]
The strain's odd as well as even information is retained in this matrix-valued symbol. Taking only (3) discards its sign and orientation.

There is a finite reconstruction too. Define
\[
r_1=q_u(x,e_3)_{11},\quad r_2=q_u(x,e_3)_{12},\quad
r_3=q_u(x,e_2)_{11},\quad r_4=q_u(x,e_2)_{13},\quad
r_5=q_u(x,e_1)_{23}.
\]
Then
\[
S_{11}=-\tfrac23(r_1+r_3),\quad
S_{22}=\tfrac43r_1-\tfrac23r_3,\quad
S_{33}=-\tfrac23r_1+\tfrac43r_3,
\]
\[
S_{12}=-r_2,\quad S_{13}=-r_4,\quad S_{23}=-r_5.
\tag{6}
\]
Five scalar symbol readings reconstruct the five independent strain entries.

On the mean-zero periodic divergence-free source image,
\[
\Delta u=2\operatorname{div}S,
\qquad
u_{\rm rec}:=-2(-\Delta)^{-1}\operatorname{div}S=u.
\tag{7}
\]
Thus the essential class of the cross-helicity block is itself a faithful source coordinate. In particular,
\[
\|B_u-B_v\|_{\rm ess}
=\tfrac12\|\lambda_{\max}(S_{u-v})-\lambda_{\min}(S_{u-v})\|_\infty.
\]

## 5. The actual stretching pairing is a finite symbol observation

At a point with \(\omega\ne0\), set \(\xi=\omega/|\omega|\). Choose any orthonormal pair \(n_1,n_2\in\xi^\perp\). From (1),
\[
\xi^\top q_u(n_j)\xi=-\xi^\top S\xi-\tfrac12n_j^\top Sn_j.
\]
Since \(\{\xi,n_1,n_2\}\) is orthonormal and \(\operatorname{tr}S=0\),
\[
\boxed{
\xi^\top S\xi
=-\frac23\xi^\top\bigl(q_u(n_1)+q_u(n_2)\bigr)\xi.
}
\tag{8}
\]
This is an exact adapter from the essential cross-helicity carrier together with the physical vorticity direction to the stretching reading appearing in the peak-growth equation.

For the actual critical source \(X=\Lambda^{1/2}u\),
\[
\frac12\frac d{dt}\|X\|_2^2+\nu\|\Lambda X\|_2^2
=2\operatorname{Re}\langle X_+,B_uX_-\rangle.
\tag{9}
\]
Equations (8) and (9) are different actual-source contractions. A norm of \(B_u\) bounds both but discards their signed coupling; it cannot replace that coupling in an empty-fibre proof.

Under finite parabolic rescaling \(u_r(x,t)=r u(x_0+rx,t_0+r^2t)\),
\[
q_{u_r}(x,n,t)=r^2q_u(x_0+rx,n,t_0+r^2t),
\]
so (3), (5), (6), and (8) transport at every finite ancestry scale. No convergence of singular limits follows merely from these finite-scale identities.

# II. RH: recover the arithmetic source before trying to invert its spectral coordinates

## 6. The fixed receiver and two positive kernels

Let \(\Sigma\) denote distinct shifted nontrivial zeros \(z=\rho-\tfrac12\), with multiplicity \(m_z\). Define
\[
G(z)=256\frac{(1-2e^{-1}\cosh(z/4)+e^{-2})^2}{(16-z^2)^2},
\quad
Z(T)=\sum_{z\in\Sigma}m_zG(z)e^{zT}.
\]
The apparent poles of \(G\) are removable. It has no zero in \(|\Re z|\le1/2\), is real-even, and satisfies uniform fourth-order vertical decay on this strip. The known packet sector bound gives
\[
M_0:=Z(0)>0
\]
without RH. Standard zero counting gives
\[
\sum_zm_z(1+|z|^2)|G(z)|<\infty.
\]
Thus \(Z\in C^2(\mathbb R)\), with derivatives of order at most two bounded by a constant times \(e^{|T|/2}\).

Fix any \(s>1/2\), for example \(s=1\); this choice is unconditional. For real \(T,U\), define
\[
\mathsf H_s(T,U)=\int_0^\infty e^{-2st}Z(T+t)Z(U+t)\,dt,
\]
\[
\mathsf K_s(T,U)=\int_0^\infty t e^{-2st}Z(T+t)Z(U+t)\,dt.
\]
These are positive Gram kernels. The second is the polarized Hilbert–Schmidt Hankel pairing. The actual receiver is real, so the formulas coincide with the usual sesquilinear Gram convention on real observation times.

## 7. Exact source inverse by simultaneous time differentiation

Let
\[
\mathcal L_s=2s-\partial_T-\partial_U.
\]
Integration by parts, keeping the endpoint at zero and using exponential damping at infinity, gives
\[
\boxed{
\mathcal L_s\mathsf H_s(T,U)=Z(T)Z(U),
\qquad
\mathcal L_s\mathsf K_s(T,U)=\mathsf H_s(T,U).
}
\tag{10}
\]
Hence
\[
\boxed{
Z(T)=\frac{\mathcal L_s\mathsf H_s(T,0)}{M_0}
=\frac{\mathcal L_s^2\mathsf K_s(T,0)}{M_0}.
}
\tag{11}
\]
Derivatives in both variables are taken before setting \(U=0\).

No zero locations, Vandermonde inversion, or infinite modal conditioning estimate is needed for (11). The positive two-time arithmetic object reconstructs its original one-time source directly. This is an exact inverse in a differentiable-kernel topology, not a bounded inverse in an arbitrary weaker norm that ignores derivatives.

The primitive identity is the resolvent of simultaneous translation:
\[
\mathsf H_s=(2s-\mathcal D)^{-1}(Z\otimes Z),
\quad
\mathsf K_s=(2s-\mathcal D)^{-2}(Z\otimes Z),
\quad \mathcal D=\partial_T+\partial_U.
\]
The boundary forcing is rank one. For a nonzero real source the complete Gram kernel determines that source up to one global sign; \(M_0>0\) fixes it. For complex sources the analogous residual is one global phase.

On \(T>1/2\), the retained explicit formula reads
\[
Z(T)=e^{T/2}G(1/2)
-\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}g(T-\log n)-J_{\rm arch}(T),
\]
where \(g\) is the fixed compact autocorrelation and the last term retains the trivial-zero/archimedean contribution. Each prime sum is finite. Thus the inverse above is over the actual arithmetic source already reconstructed from quantitative Goldbach data; it does not replace that source by an arbitrary positive kernel.

# III. Individual spectral extraction has an exact residual, but no uniform conditioning

## 8. Finite normalized Hardy Gram determinants

For distinct \(z_1,\ldots,z_N\) in \(\Re z<s\), define
\[
h_{s,z}(t)=\sqrt{2(s-\Re z)}e^{-(s-z)t}.
\]
Their normalized Gram matrix is
\[
C_F(i,j)=\frac{2\sqrt{(s-\Re z_i)(s-\Re z_j)}}{2s-z_i-\overline{z_j}}.
\]
The Cauchy determinant formula gives
\[
\boxed{
\det C_F=\prod_{i<j}\frac{|z_i-z_j|^2}{|2s-z_i-\overline{z_j}|^2}.
}
\tag{12}
\]
Consequently, for a new distinct point \(z\),
\[
\boxed{
\operatorname{dist}\!\left(h_{s,z},\operatorname{span}\{h_{s,w}:w\in F\}\right)^2
=\frac{\det C_{F\cup\{z\}}}{\det C_F}
=\prod_{w\in F}\rho_s(z,w)^2,
}
\tag{13}
\]
where
\[
\rho_s(z,w)=\frac{|z-w|}{|2s-z-\overline w|}.
\]
This is the exact Hilbert-space residual after eliminating the old packet span. It is a Schur-complement identity, not an arbitrary numerical conditioning statistic.

For the functional-equation partner \(\theta z=-\bar z\),
\[
\rho_s(z,\theta z)^2=\frac{(\Re z)^2}{s^2}.
\]
Thus the previous two-point RH rank defect is the first member of the complete elimination-product law. It cannot be promoted to positivity failure: all distinct-mode Gram matrices here are strictly positive whether or not RH holds.

## 9. Infinite minimality

Fix a shifted zero \(z\) and let \(F\) exhaust all other distinct shifted zeros. Since \(s>1/2\), every depth \(s-\Re w\) stays in a fixed positive compact interval. Moreover
\[
1-\rho_s(z,w)^2
=\frac{4(s-\Re z)(s-\Re w)}{|2s-z-\overline w|^2}.
\]
The standard zero count implies
\[
\sum_{w\ne z}(1-\rho_s(z,w)^2)<\infty.
\]
No factor vanishes, so
\[
\boxed{
\operatorname{dist}\!\left(h_{s,z},
\overline{\operatorname{span}\{h_{s,w}:w\ne z\}}\right)^2
=\prod_{w\ne z}\rho_s(z,w)^2>0.
}
\tag{14}
\]
Each distinct mode has a nonzero orthogonal innovation and can individually be extracted by a bounded functional. Multiplicity remains a weight in the receiver; it does not create repeated independent exponential columns.

Under the Laplace realization, the closed span of these kernels is the Hardy model space \(K_{b_s}=H^2\ominus b_sH^2\), where \(b_s\) is the reduced Blaschke product with zeros \(s-\overline z\), each distinct zero used once. The Blaschke condition follows from the same summability. The complementary ambient causal space \(b_sH^2\) is not a source direction generated by these modes; it must not be identified with the coefficient-space observability kernel.

## 10. Uniform invertibility fails unconditionally

Conrey's positive-proportion theorem gives \(\gg T\log T\) distinct simple critical-line zeros through height \(T\). It follows that there are arbitrarily high pairs
\[
z=i\gamma,\qquad w=i\gamma',\qquad |\gamma-\gamma'|\to0.
\]
For such a pair,
\[
|\langle h_{s,z},h_{s,w}\rangle|
=\frac{2s}{\sqrt{4s^2+(\gamma-\gamma')^2}}.
\]
Its least Gram eigenvalue obeys
\[
\boxed{
\lambda_{\min}
=1-\frac{2s}{\sqrt{4s^2+(\gamma-\gamma')^2}}
\le\frac{(\gamma-\gamma')^2}{8s^2}\to0.
}
\tag{15}
\]
Thus there is no uniform lower Riesz bound for the full normalized zero-mode family. This ill-conditioning already occurs among zeros known to be on the critical line and cannot be treated as evidence of off-criticality.

The same counting theorem gives unit-height intervals containing arbitrarily many distinct critical-line zeros. Within any such interval,
\[
\operatorname{Re}C_F(i,j)\ge\frac{4s^2}{4s^2+1}.
\]
The all-ones Rayleigh quotient yields
\[
\lambda_{\max}(C_F)\ge\frac{4s^2}{4s^2+1}|F|\to\infty.
\]
So the unweighted normalized family has no uniform upper Bessel bound either.

The faithful receiver weights make the corresponding synthesis operator Hilbert–Schmidt, but an injective infinite-rank compact operator has no bounded inverse onto its range equipped with the ambient norm. Exact source recovery in (11) and exact mode-by-mode recovery in (14) must therefore be kept separate from uniform stable spectral reconstruction.

# IV. Consequences for the theorem graph

The source-dependent coadjoint cross-helicity block has not supplied a smaller norm obstruction than strain: its essential norm is exactly half the strain spectral spread. Its full symbol does, however, retain the signed information and gives the explicit stretching reconstruction (8). This supplies a precise infinitesimal bridge between the critical-helicity and vorticity-source descriptions without confusing arbitrary-input response with an actual source variation.

The positive Hardy and Bergman two-time kernels do not require an unknown infinite modal inversion to recover their original arithmetic receiver: (11) is an exact boundary-resolvent inverse. Extracting individual modes has the explicit product residual (13)-(14), while uniform conditioning fails even on critical-line data.

The remaining global implications are not asserted here. In NS one must control the physical source contractions while preserving the matched renormalized histories, rather than demand vanishing of an operator nonzero for every nontrivial flow. In RH the exact source and Gram reconstructions do not force the reflected-orbit Gram rank to collapse. Positivity of the well-damped Gram object remains compatible with off-critical zeros.

## Primary analytic references

S. T. Melo, *Norm closure of classical pseudodifferential operators does not contain Hörmander's class*, arXiv:math/0312261, especially Theorem 2 and Corollary 2. Matrix amplification and orthogonal pseudodifferential corners give the symbol-norm statement used here.

N. Nikolski, *Distance formulae and invariant subspaces, with an application to localization of zeros of the Riemann zeta-function*, Annales de l'Institut Fourier 45 (1995), 143–159, DOI 10.5802/aif.1451. The Hardy distance and invariant-subspace framework is classical.

J. B. Conrey, *More than two fifths of the zeros of the Riemann zeta function are on the critical line*, Journal für die reine und angewandte Mathematik 399 (1989), 1–26, DOI 10.1515/crll.1989.399.1. Only the unconditional positive proportion of distinct simple critical-line zeros is used, not any assertion about the remaining zeros.

## Verification

`checks.py` executes 20 exact symbolic controls. These include the critical-weight Fourier correction, the transverse symbol, its helical block and five-reading inverse, spherical tomography, two-direction stretching reconstruction, Hardy/Bergman source inverses, Cauchy determinants, and the finite innovation law. They are finite algebra checks, not an Agda/Lean build or a validation of the infinite analytic theorems.
