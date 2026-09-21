# Part III. NS: actual source operators, variations, and missing affine coordinates

## 13. Conventions and the direct endpoint

Write \(\mathbb P\) for Leray projection, never for the toroidal selection projection. On divergence-free velocities,

\[
N(u)=-\mathbb P((u\cdot\nabla)u)=\mathbb P(u\times\omega),
\quad \omega=\operatorname{curl}u,
\quad S_u=\tfrac12(\nabla u+\nabla u^T).
\]

On a maximal smooth whole-space solution \([0,T_*)\), let \(M(t)=\|\omega(t)\|_\infty\). At a nonzero maximum define the positive directional stretch, and take the supremum over all maximizers:

\[
b_u(t)=\sup_{x:\,|\omega(x,t)|=M(t)}[\xi(x,t)^TS_u(x,t)\xi(x,t)]_+,
\qquad \xi=\omega/|\omega|.
\]

For smooth decaying fields maxima are attained. The zero-vorticity case is separate. The magnitude equation gives

\[
D^+M\le b_uM,\qquad M(t)\le M(0)\exp\!\int_0^t b_u(s)\,ds.
\]

Therefore the following is a sufficient actual-source closing assertion:

\[
\mathsf B_{NS}:\quad T_*<\infty\Longrightarrow\int_0^{T_*}b_u(t)\,dt<\infty.
\]

It would give bounded vorticity and the standard viscous continuation argument, contradicting maximality. [S23] contains this endpoint graph. No construction of \(\mathsf B_{NS}\) for arbitrary data is supplied by the generic `NSReducesToDepletion` record; its actual exclusion arguments must be instantiated. No blanket claim that every possible definition of Type I is already ruled out should be inherited from a wrapper's name or prose.

## 14. Finite observations can miss actual futures

[S01] constructs realizable positive unresolved stresses with the same scalar readings but different coarse futures. [S02] gives a stronger all-orders family of actual globally smooth NS solutions on the \(2\pi\)-torus:

\[
u^\pm=(0,a,\pm v),\qquad a=Ae^{-\nu N^2t}\cos(Nx_1),\qquad p=0,
\]
\[
v_t+a\partial_2v=\nu(\partial_1^2+\partial_2^2)v,
\quad v(0)=C\cos(x_2-mNx_1).
\]

Writing \(v=\Re[e^{ix_2}\sum_kc_k(t)e^{ikNx_1}]\),

\[
\dot c_k=-\nu(1+N^2k^2)c_k-\frac{iAe^{-\nu N^2t}}2(c_{k-1}+c_{k+1}),
\quad c_k(0)=C\delta_{k,-m}.
\]

Projection onto the low \(k=0\) component has

\[
c_0^{(j)}(0)=0\ (j<m),\qquad c_0^{(m)}(0)=C(-iA/2)^m.
\]

Thus any prescribed finite initial velocity/stress jet depth can be matched by two genuine solutions with different later resolved velocity. Their scalar energy, dissipation, trace stress, resolved energy flux, zero pressure, and usual \(Q_{inv},R_{inv}\) velocity-gradient invariants can agree for their whole futures. The gradient is triangular/nilpotent. This refutes specified finite-observer closures, not every possible finite encoding.

Let \(\beta(t)=A(1-e^{-\nu N^2t})/(\nu N^2)\). Exact path counting and skew coupling give

\[
|c_0(t)|\le Ce^{-\nu t}I_m(\beta(t)),\qquad |c_0(t)|\le Ce^{-\nu t},
\]
\[
I_m(b)=\sum_{r\ge0}\frac{(b/2)^{m+2r}}{r!(m+r)!}.
\]

Long hidden jet depth can therefore have factorially small later influence. Deep observational delay is not itself large physical memory.

Splitting this exactly solvable linear nonautonomous coefficient system into coarse \(x\) and fine \(y\) gives

\[
\dot x=-\nu x+B(t)y,\qquad \dot y=C(t)x+L_Q(t)y,\qquad C=-B^*.
\]

The fine propagator obeys \(\|V_Q(t,s)\|\le e^{-\nu(1+N^2)(t-s)}\), and the exact coarse equation contains both initial-history noise \(\eta(t)=B(t)V_Q(t,0)y_0\) and memory \(K(t,s)=B(t)V_Q(t,s)C(s)\). Its integrated induced work is

\[
\int_0^T\Re\bigl(\bar x(t)\int_0^tK(t,s)x(s)ds\bigr)dt
=-\frac12\|y_x(T)\|^2-\nu\int_0^T\langle Dy_x,y_x\rangle dt\le0
\]

when the induced fine response starts at zero. Initial fine energy is separate. For two arbitrary NS solutions, the secant instead has

\[
\frac12\frac d{dt}\|u_1-u_2\|_2^2+\nu\|\nabla(u_1-u_2)\|_2^2
=-\int(u_1-u_2)^TS_{(u_1+u_2)/2}(u_1-u_2),
\]

which is indefinite. The triangular passivity proof cannot be transferred by dropping this strain term. Later source-splitting passivity [S19] concerns a different diagram and remains compatible with this secant fact.

## 15. The Poisson-source representation is isometric in maximum vorticity

[S04] works on the complexification of mean-zero divergence-free \(L^2\) fields on the flat torus. Define

\[
\Pi_u a=\mathbb P(a\times\omega_u).
\]

It is bounded skew-adjoint. The exact result is

\[
\boxed{\|\Pi_u\|=\|\Pi_u\|_{ess}=\|\omega_u\|_\infty,\qquad
\operatorname{spec}_{ess}(i\Pi_u)=[-M,M].}
\]

At \((x,n)\), \(|n|=1\), the transverse principal symbol is

\[
\sigma(\Pi_u)(x,n)a=(\omega_u(x)\cdot n)(a\times n),\qquad a\perp n.
\]

Its two complex eigenvalues after multiplication by \(i\) are \(\pm\omega_u(x)\cdot n\). Localized high-frequency transverse wave packets at a vorticity maximum supply singular Weyl sequences for every value in the interval. The pointwise cross-product estimate supplies the upper bound.

Consequently,

\[
\|\Pi_u-\Pi_v\|=\|\operatorname{curl}(u-v)\|_\infty.
\]

Mean zero makes the source representation injective. On another domain, specify the harmonic/mean fibre; do not silently import the torus result.

The quotient source family commutes in the Calkin algebra:

\[
[\Pi_u,\Pi_w]\in\mathcal K(H).
\]

Its principal symbols are scalar multiples of the same transverse rotation. This is also proved by approximation from finite Fourier sources. Yet the commutator need not vanish. For

\[
u=\sin y\,e_1,\quad w=\sin z\,e_2,\quad a_N=\cos(Nx)e_3,
\]

[S05] computes

\[
[\Pi_u,\Pi_w]a_N=\frac1{N^2+2}
(2\cos Nx\cos y\cos z,\ N\sin Nx\sin y\cos z,\ N\sin Nx\cos y\sin z),
\]

and normalized squared norm ratio \(1/[2(N^2+2)]\). Since no nonzero source operator is compact, this is outside the source image. For a nonzero compact \(K\),

\[
\inf_w\|K-\Pi_w\|\ge\|K\|/2.
\]

Faithful static encoding of the source is not faithful encoding of every operator interaction after quotienting.

## 16. The actual tangent and source-preserving transport are distinct

Define

\[
M_uw=\Pi_wu=-\mathbb P[(u\cdot\nabla)w+(\nabla u)^Tw],
\qquad J_u=DN(u)=M_u+\Pi_u.
\]

The coadjoint pairing and Jacobi identity give

\[
M_u\Pi_w+\Pi_wM_u^*=\Pi_{M_uw},
\]
\[
\boxed{J_u\Pi_w+\Pi_wJ_u^*=\Pi_{M_uw}+[\Pi_u,\Pi_w].}
\]

For \(w=u\), the extra commutator vanishes. For arbitrary \(w\), it is a genuine compact source-image residual.

On a fixed interval where the base NS source is smooth, use one Brownian translation noise for two Stratonovich propagators:

\[
dS=M_uS\,dt+\sqrt{2\nu}\sum_jD_jS\circ dW_j,
\]
\[
dR=J_uR\,dt+\sqrt{2\nu}\sum_jD_jR\circ dW_j.
\]

Their Itô drifts add \(\nu\Delta\). Noise removal by a common spatial translation reduces the pathwise construction to smooth-coefficient transport equations. In the stated periodic smooth interval, forward and reverse transport give bounded invertible propagators; this is not inversion of the deterministic heat semigroup.

The exact source-preserving identities are

\[
S(t,s)\Pi_wS(t,s)^*=\Pi_{S(t,s)w},\qquad
\mathbb E[S(t,s)u(s)]=u(t),
\]

while \(\mathbb E R\) is the actual deterministic NS tangent propagator. They must not be identified.

The complete tangent discrepancy is

\[
\boxed{
R(t,s)\Pi_wR(t,s)^*=\Pi_{S(t,s)w}+K_{t,s}(w),
}
\]
\[
K_{t,s}(w)=\int_s^tR(t,r)[\Pi_{u(r)},\Pi_{S(r,s)w}]R(t,r)^*dr\in\mathcal K(H).
\]

The source-plus-compact decomposition is unique. On the actual physical source,

\[
\mathbb E K_{t,s}(u(s))=0.
\]

Differentiating \(\mathbb E[S[u]u(s)]\) differentiates both the initial source and the coefficient \(S[u]\). The term \(M_vu=\Pi_uv\) restores the omitted half and gives the true tangent equation. That calculation is a central regression test for every future claimed “self-generated propagator.”

### 16.1 Complete positivity does not give physical contraction

For the tangent lift,

\[
\mathcal E_{t,s}(A)=\mathbb E[RAR^*]
\]

is completely positive, but its identity derivative is

\[
\mathcal G_u(I)=-2\mathbb P S_u\mathbb P.
\]

The two-parameter channel is unital on every subinterval only for spatially constant flows. With \(Q_{t,s}=\mathbb E[RR^*]\),

\[
\Psi(A)=Q^{-1/2}\mathcal E(A)Q^{-1/2}
\]

is unital completely positive and controls the source in that transported order unit. The inverse reconstruction multiplies by \(Q^{1/2}\) on both sides. Discarding \(Q\) would change the norm being controlled.

An exact global shear \(u=Ae^{-\nu t}\sin y\,e_1\) has exponentially decaying physical \(\|\omega\|_\infty\) while the auxiliary order unit increases in a specified direction. Its tangent can initially amplify for \(A>10\nu\). These are globally regular sources; auxiliary amplification is not a blow-up certificate. [S04]

### 16.2 Helicity and finite scaling

Pathwise coadjoint transport preserves \(\mathcal H(w)=\tfrac12\langle w,\operatorname{curl}w\rangle\). For \(w_t=S u(s)\), writing \(\xi_t=w_t-u(t)\),

\[
\mathcal H(u(t))+\mathbb E\mathcal H(\xi_t)=\mathcal H(u(s)).
\]

The fluctuation helicity need not be positive.

For finite parabolic scaling on the correspondingly rescaled torus,

\[
w_r(x)=r w(x_0+rx),\quad (U_rf)(x)=r^{3/2}f(x_0+rx),
\]
\[
\Pi_{w_r}=r^2U_r\Pi_wU_r^{-1},\quad K_r=r^2U_rKU_r^{-1}.
\]

The propagators transform by unitary conjugation with time/Brownian scaling. Compactness and source extraction are exact at every finite stage. Strong limits of compact operators need not be compact: finite-rank projections can converge strongly to identity. This cannot be used to delete the residual in a singular limit.

## 17. BMO class: exactly five unresolved strain coordinates after translation

For smooth finite-energy whole-space sources,

\[
[\nabla u]_{BMO}\le C\|\omega\|_\infty.
\]

The local/far Calderón–Zygmund proof subtracts the remote kernel value at the ball centre. The estimate controls mean oscillation, **not mean strain**. It is invariant under the normalized scaling in the appropriate degree.

In the realized endpoint class

\[
\mathcal X=\{u\in W^{1,1}_{loc}:\operatorname{div}u=0,\ \operatorname{curl}u\in L^\infty,\ [\nabla u]_{BMO}<\infty\},
\]

[S08] proves

\[
\boxed{\ker\operatorname{curl}=\{Ax+b:A=A^T,\ \operatorname{tr}A=0\}.}
\]

Every gradient entry of a zero-curl/divergence field is harmonic and BMO. A harmonic BMO function is constant because the interior gradient bound is \(C[BMO]/R\), and \(R\to\infty\). Thus the full kernel has dimension eight: three translations and five symmetric trace-free affine strains.

Using mean velocity and mean strain on a fixed unit ball,

\[
b(u)=\fint_Bu,\qquad A(u)=\fint_BS_u,
\]

one gets a canonical realized-image completion

\[
\boxed{\mathcal X\simeq\operatorname{curl}(\mathcal X)\times\operatorname{Sym}_0(3)\times\mathbb R^3.}
\]

The inverse is the unique normalized Biot–Savart representative plus \(Ax+b\). It is over the actual vorticity image, not arbitrary independent data. After translation, five scalar linear readings are minimal on this fibre.

For finite \(p,R\),

\[
\|u-v\|_{W^{1,p}(B_R)}\le C_{p,R}
(\|\operatorname{curl}(u-v)\|_\infty+|A(u)-A(v)|+|b(u)-b(v)|).
\]

Bounded vorticity plus bounded affine coordinates gives spatial local compactness. It does not supply time compactness or preserve a pointwise peak under weak convergence.

### 17.1 A named topology defect and its repair

[S06] constructs compact remote vorticity sources that yield a prescribed affine strain in a source-free core. Many disjoint weak tails can satisfy \(\|\omega_n\|_\infty\to0\) while their cumulative central strain stays nonzero. Thus even norm convergence of the Poisson-source operators can fail to reconstruct local strain when the missing affine coordinate is omitted in a whole-space limit.

On a fixed ball, curl plus the normal velocity boundary trace is jointly faithful: their difference is a harmonic gradient with zero Neumann data, hence zero. In the global BMO class, mean strain and mean velocity are a finite coordinate replacement for that boundary information.

Affine subtraction is not an NS symmetry. If \(u=v+A(t)x+b(t)\), then

\[
\partial_t\omega+(v+Ax+b)\cdot\nabla\omega=(\nabla v+A)\omega+\nu\Delta\omega.
\]

Removing \(A\) deletes actual stretch. Under \(F'=AF\), \(x=Fy+c\), the affine term can be transported into the metric \(F^TF\) and diffusion tensor \(F^{-1}F^{-T}\). Their determinant is one but their condition numbers need not be bounded. Keep this metric data; do not keep Euclidean curl after a nonorthogonal affine change without its Hodge transformation.
