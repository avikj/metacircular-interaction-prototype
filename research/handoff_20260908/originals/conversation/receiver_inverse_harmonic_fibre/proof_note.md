# Explicit receiver inversion and the harmonic fibre of renormalized NS sources

Repository snapshot: `avikj/metacircular-interaction-prototype`, `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope

This note proves an explicit differential-delay inverse for the previously specified Weil packet, with a two-term exact truncation residual and convergence in a positive spectral majorant that does not assume RH. It also constructs smooth compactly supported divergence-free velocity fields whose Poisson source operators converge in operator norm, whose vorticity stays normalized and nonzero, but whose actual local NS vorticity derivatives remain separated by an arbitrary prescribed trace-free symmetric strain. The missing local source fibre is characterized and an exact boundary observer is given.

These are mathematical derivations using the classical Weil form and elementary differential/vector calculus. No proof of RH or global three-dimensional NS regularity, originality-priority claim, or proof-assistant compilation is made. The accompanying executable checks finite and symbolic identities, not PDE evolution or the analytic limit theorems.

## I. The fixed Weil receiver has an explicit inverse

Set

\[
\ell=\tfrac14,\qquad r=e^{-1},\qquad
q(x)=4\mathbf1_{[0,\ell]}(x),\qquad
k(x)=e^{-4x}q(x),\qquad h=k*k.
\]

Thus

\[
h(x)=e^{-4x}(q*q)(x),\qquad
H(z)=\int h(x)e^{-zx}\,dx
=16\frac{(1-e^{-(z+4)/4})^2}{(z+4)^2}.
\]

Write \(T_bv(x)=v(x-b)\), \(D=\partial_x\), and \(L=rT_\ell\). Distributionally,

\[
(D+4)k=4(\delta_0-r\delta_\ell),
\]

so

\[
\boxed{(D+4)^2h=16(\delta_0-2r\delta_\ell+r^2\delta_{2\ell}).}
\tag{1}
\]

Consequently convolution with \(h\), denoted \(C_h\), obeys

\[
(D+4)^2C_h=16(I-L)^2.
\tag{2}
\]

This is an identity of the actual fixed packet, not a generic nonvanishing-multiplier assertion.

### Finite-history inverse with an exact two-term boundary residual

For \(v\in C_c^\infty(\mathbb R)\), define

\[
f_N=\frac1{16}(D+4)^2\sum_{j=0}^N(j+1)L^jv,
\qquad v_N=h*f_N.
\]

The polynomial identity

\[
(1-X)^2\sum_{j=0}^N(j+1)X^j
=1-(N+2)X^{N+1}+(N+1)X^{N+2}
\tag{3}
\]

gives

\[
\boxed{
v_N=v-(N+2)e^{-(N+1)}T_{(N+1)/4}v
+(N+1)e^{-(N+2)}T_{(N+2)/4}v.
}
\tag{4}
\]

Equation (3) follows by induction: the difference of its right-hand sides at \(N+1\) and \(N\) is \((N+2)X^{N+1}(1-X)^2\). Thus the residual is exactly two known translates of the retained source. No unspecified remainder is introduced.

There is also an actual infinite inverse. Define

\[
\mathcal Rv=\frac1{16}(D+4)^2
\sum_{j\ge0}(j+1)e^{-j}T_{j/4}v.
\tag{5}
\]

For compactly supported \(v\), the sum is locally finite. It is smooth, has a lower-bounded support, and has an exponentially decreasing right tail, with at most a linear polynomial prefactor. Equation (4) proves

\[
\boxed{h*\mathcal Rv=v.}
\tag{6}
\]

This is a right inverse on the declared smooth compact-source class. It does not claim that the inverse source remains compactly supported. On exponentially weighted source spaces with weight exponent less than 4, the same series is convergent and provides the corresponding two-sided inverse whenever the derivatives belong to the declared spaces. In particular \(\|L\|\le e^{-1+\sigma/4}<1\) under a translation bound \(\|T_b\|\le e^{\sigma |b|}\), \(\sigma<4\).

### Convergence strong enough for the actual Weil form

Let \(z_\rho=\rho-1/2\), with distinct nontrivial zeta zeros indexed with multiplicities \(m_\rho\). For compact smooth \(v\), set

\[
V_v(z)=\int v(x)e^{-zx}\,dx,
\qquad \|v\|_{\mathcal Z}^2=\sum_\rho m_\rho|V_v(z_\rho)|^2.
\tag{7}
\]

This is a positive majorant seminorm. It does not presume positivity of the Weil form. Its finiteness follows from rapid vertical decay on the fixed strip and the classical zero-count estimate. The zero symmetries give

\[
Q_W(v,w)
=\sum_\rho m_\rho V_v(z_\rho)
\overline{V_w(-\overline{z_\rho})},
\]

hence

\[
|Q_W(v,w)|\le\|v\|_{\mathcal Z}\|w\|_{\mathcal Z}.
\tag{8}
\]

Only the unconditional strip \(|\Re z_\rho|\le1/2\) is needed for

\[
\|T_bv\|_{\mathcal Z}\le e^{|b|/2}\|v\|_{\mathcal Z}.
\tag{9}
\]

Combining (4) and (9),

\[
\boxed{
\|v_N-v\|_{\mathcal Z}\le\epsilon_N\|v\|_{\mathcal Z},
\qquad
\epsilon_N=(N+2)e^{-7(N+1)/8}+(N+1)e^{-7(N+2)/8}.
}
\tag{10}
\]

Therefore

\[
\boxed{
|Q_W(v_N,v_N)-Q_W(v,v)|
\le(2\epsilon_N+\epsilon_N^2)\|v\|_{\mathcal Z}^2.
}
\tag{11}
\]

No cancellation among the zeta modes is needed for this estimate, and no critical-line location is assumed.

### Any negative compact test can be compiled into a finite packet Gram test

Suppose \(Q_W(v,v)=-\delta<0\), \(v\in C_c^\infty\). Select a finite \(N\) satisfying

\[
(2\epsilon_N+\epsilon_N^2)\|v\|_{\mathcal Z}^2<\delta/2.
\]

Then \(Q_W(h*f_N,h*f_N)<-\delta/2\). Since

\[
h*f_N=\int f_N(t)T_th\,dt,
\]

it can be approximated in \(\|\cdot\|_{\mathcal Z}\) by finite sums

\[
p=\sum_{j=1}^m c_jT_{t_j}h.
\]

To justify the approximation, \(h\) itself has finite majorant norm because its transform has quadratic vertical decay. The map \(t\mapsto T_th\) is continuous in that norm by dominated convergence, uniformly bounded on compact \(t\)-intervals. Riemann sums for the compactly supported \(f_N\) therefore converge. For a sufficiently accurate sum, \(Q_W(p,p)<0\).

The nodes can be chosen in \(\mathbb Z\log2+\mathbb Z\log3\), since this set is dense, and coefficients can be approximated in \(\mathbb Q+i\mathbb Q\). Thus the map is a constructive source-to-finite-packet reduction, with its first truncation residual known exactly.

The corresponding Gram entries are the existing fixed receiver:

\[
Q_W(T_sh,T_th)=\mathcal Z(t-s),
\qquad
\mathcal Z(t)=\sum_\rho m_\rho H(z_\rho)H(-z_\rho)e^{z_\rho t}.
\]

Its explicit arithmetic formula, retained archimedean terms, CRT \(\Lambda\)-reconstruction, and quantitative Goldbach reconstruction remain unchanged. This does not prove the entries form positive Gram matrices. The prior two-packet criterion is not replaced by a stronger obligation; (4)--(11) supply an explicit inverse/continuity adapter for arbitrary test sources.

## II. The Poisson-source inverse can lose a harmonic strain even under operator-norm convergence

Let \(\mathbb P\) be the whole-space Leray projection on \(L^2_\sigma(\mathbb R^3)\). For a smooth compactly supported divergence-free velocity \(u\), let

\[
\Pi_ua=\mathbb P(a\times\operatorname{curl}u).
\]

The elementary bound

\[
\|\Pi_u-\Pi_v\|\le\|\operatorname{curl}(u-v)\|_\infty
\tag{12}
\]

is sufficient for the construction below. It is consistent with the previously obtained equality. Injectivity on the finite-energy source class does not assert continuity of its inverse into local velocity or strain.

### A compact remote source for any prescribed affine strain

Choose a nonzero real trace-free symmetric matrix \(A\). Let \(\chi\in C_c^\infty(\mathbb R^3)\) equal 1 on \(B_1\) and 0 outside \(B_2\). Put

\[
\Psi_A(x)=-\tfrac13x\times Ax,
\qquad
W_R^A=\operatorname{curl}[\chi(x/R)\Psi_A(x)].
\tag{13}
\]

The vector identity

\[
\operatorname{curl}\Psi_A=Ax
\]

uses \(\operatorname{tr}A=0\). Since \(A\) is symmetric, \(\operatorname{curl}(Ax)=0\). It follows that

\[
\begin{aligned}
\nabla\cdot W_R^A&=0,\
W_R^A(x)&=Ax\quad (|x|<R),\
W_R^A(x)&=0\quad (|x|>2R),\
\operatorname{supp}\operatorname{curl}W_R^A&\subset\{R\le|x|\le2R\}.
\end{aligned}
\tag{14}
\]

Homogeneity gives

\[
W_R^A(x)=R W_1^A(x/R),
\quad
\|\operatorname{curl}W_R^A\|_\infty=C_A,
\quad
\|W_R^A\|_2^2=R^5\|W_1^A\|_2^2.
\tag{15}
\]

### Many disjoint weak tails leave a finite strain in the core

Set \(R_{n,j}=4^{n+j}\), \(1\le j\le n\), and

\[
H_n=\frac1n\sum_{j=1}^nW_{R_{n,j}}^A.
\tag{16}
\]

The vorticity annuli in this sum are disjoint, so

\[
\boxed{
\|\operatorname{curl}H_n\|_\infty\le C_A/n\longrightarrow0.
}
\tag{17}
\]

But on \(B_{R_{n,1}}\), every summand equals \(Ax\), so

\[
\boxed{H_n(x)=Ax\quad\text{on }B_{R_{n,1}}.}
\tag{18}
\]

Thus \(H_n\to Ax\) smoothly on every compact subset, while \(\Pi_{H_n}\to0\) in operator norm. Each \(H_n\) remains a genuine smooth compactly supported finite-energy source. The local limit \(Ax\) is not a finite-energy source; that admissibility failure is the point.

### Keep the vorticity normalization and a nonzero core

Fix a unit vector \(\Omega\). A smooth compactly supported divergence-free \(v\) can be chosen with

\[
v(x)=\tfrac12\Omega\times x\quad (|x|\le1),
\qquad
\|\operatorname{curl}v\|_\infty=1.
\tag{19}
\]

For an explicit construction, choose a smooth nonincreasing \(\eta\) equal to 1 for \(s\le0\), equal to 0 for \(s\ge L\), and with \(-1\le\eta'\le0\). Take \(f(r)=\eta(\log r)/2\), with its constant smooth extension near zero, and \(v=f(|x|)\Omega\times x\). The vorticity components parallel/perpendicular to \(n=x/|x|\) are multiplied by \(2f\) and \(2f+rf'\), respectively. Their absolute values are at most 1.

Let \(U_n=v+H_n\). For large \(n\), the tail-vorticity supports are disjoint from the core support and \(C_A/n\le1\). Consequently

\[
\boxed{
\begin{aligned}
U_n(0)&=0,\\
\|\operatorname{curl}U_n\|_\infty&=1,\\
\operatorname{curl}U_n(0)&=\Omega,\\
\|\Pi_{U_n}-\Pi_v\|&\le C_A/n\to0,\\
U_n&\to v+Ax\quad\text{smoothly locally}.
\end{aligned}
}
\tag{20}
\]

This is neither loss of nonvanishing nor an unremoved constant-velocity/Galilean mode. The surviving missing part is an arbitrary trace-free symmetric strain.

### Actual NS first continuations remain separated

Let each field be initial data for its own classical NS solution, with fixed viscosity \(\nu>0\). At time zero,

\[
\partial_t\omega
=-(u\cdot\nabla)\omega+(\omega\cdot\nabla)u+\nu\Delta\omega.
\]

On \(B_1\), both sources have constant vorticity \(\Omega\). At the origin their velocity is zero. The core rotation contributes zero stretching because \(\Omega\times\Omega=0\). Hence

\[
\boxed{
\left.\partial_t\omega_{U_n}(0,t)\right|_{t=0}
-\left.\partial_t\omega_v(0,t)\right|_{t=0}
=A\Omega.
}
\tag{21}
\]

Choose \(A\Omega\ne0\). The difference is independent of \(n\). Thus convergence of the Poisson state in operator norm does not make this true local NS generator reading converge. This is a topological extension obstruction for the autonomous source-coordinate equation, not a contradiction of its exactness at each admissible source.

No convergence or common existence interval for these different NS solutions is needed for (21), and none is asserted.

### The construction can respect the inherited finite-energy scaling

Let \(R_n=R_{n,n}\). On the annulus \(R_n/2<|x|<R_n\), all smaller cutoff fields vanish and \(H_n=Ax/n\), while \(v=0\). This gives a lower bound of order \(R_n^5/n^2\) for \(\|U_n\|_2^2\). The geometric sum of the norms in (15) gives the matching upper bound. Thus

\[
\|U_n\|_2^2\asymp_A R_n^5/n^2.
\tag{22}
\]

Choose

\[
r_n=(1+\|U_n\|_2^2)^{-1}\to0,
\qquad u_n(x)=r_n^{-1}U_n(x/r_n).
\]

Then

\[
\boxed{
\|u_n\|_2^2=r_n\|U_n\|_2^2\le1,
\qquad
\|\operatorname{curl}u_n\|_\infty=r_n^{-2}.
}
\tag{23}
\]

Vorticity-peak renormalization by \(r_n\) returns exactly \(U_n\). The physical supports shrink, since \(r_nR_n\asymp n^2/R_n^4\to0\); the compact fields can also be periodized on one fixed torus for sufficiently large \(n\).

These are different smooth initial data, not one blow-up trajectory. Equations (20)--(23) establish only that nonzero peak normalization, Galilean centering, and the inherited global energy upper bound do not by themselves eliminate the harmonic tail. The common-initial-source and dynamical ancestry requirements remain additional requirements.

## III. Exact repair: vorticity and the normal boundary trace are jointly faithful

On a ball, two smooth divergence-free velocities with the same vorticity differ by

\[
u_1-u_2=\nabla\phi,\qquad\Delta\phi=0.
\tag{24}
\]

The potential is unique up to an additive constant. Thus the local fibre of the curl reading consists of harmonic gradients, not merely constant vectors. Fixing velocity at the center removes the degree-one potential part, but leaves the five-dimensional space \(\phi(x)=x^TAx/2\), \(A=A^T\), \(\operatorname{tr}A=0\), along with higher harmonic degrees.

If the normal velocity is also retained on the boundary, then \(\partial_n\phi=0\). Green's identity yields

\[
\int|\nabla\phi|^2=\int_{\partial B}\phi\partial_n\phi-\int\phi\Delta\phi=0.
\]

Therefore, on the realized data image,

\[
\boxed{
u\longmapsto(\operatorname{curl}u,\ u\cdot n|_{\partial B})
\quad\text{is injective on divergence-free fields}.
}
\tag{25}
\]

This is a reconstruction statement, not a claim that every independently specified pair of boundary/vorticity data is realizable.

For the quadratic harmonic component, an explicit observer suffices. If \(h=\nabla\phi\) is smooth and harmonic on \(B_R\), then

\[
\boxed{
\nabla^2\phi(0)
=\frac{15}{8\pi R}
\int_{\mathbb S^2}(h(Rn)\cdot n)
\left(nn^T-\frac13I\right)d\Omega(n).
}
\tag{26}
\]

The degree-two harmonic component is the only one that contributes, by spherical harmonic orthogonality. For \(h=Ax\), the formula follows from

\[
\int_{\mathbb S^2}n_in_jn_kn_l\,d\Omega
=\frac{4\pi}{15}(\delta_{ij}\delta_{kl}+\delta_{ik}\delta_{jl}+\delta_{il}\delta_{jk}).
\]

This observer is insensitive to a constant velocity and returns exactly the strain responsible for (21).

### Compatibility with the localized Betchov current

For \(\mathcal J_u=(\operatorname{cof}\nabla u)^Tu\), the established local identity is

\[
\omega^TS\omega=-4\det S+\frac43\nabla\cdot\mathcal J_u.
\tag{27}
\]

For a pure harmonic affine velocity \(u=Ax\), \(\omega=0\), but \(\det S=\det A\) need not vanish. Here

\[
\mathcal J_u=(\operatorname{cof}A)^TAx=(\det A)x,
\]

so \((4/3)\nabla\cdot\mathcal J_u=4\det A\) cancels the cubic term exactly. Omitting the boundary current would assign spurious enstrophy production to a zero-vorticity source.

## Dependency and verification ledger

Read at the pinned repository snapshot:

- `formal/cubical/theorems/automata/ActionResidual.agda`: an exact finite residual and its realized composition law.
- `formal/cubical/theorems/automata/FutureBehavior.agda`: observation agreement and action preservation are separate requirements; joint readings intersect future-equivalence relations.
- `formal/cubical/theorems/unplaced/ReceiverExponentFaithful.agda`: boundedness preservation/reflection in the abstract log-amplitude model; this is not the explicit differential-delay inverse proved in I.

The fixed packet, the previously established two-packet Weil criterion, and the earlier local cofactor-current identity are retained as inputs. Classical explicit-formula and Weil-form theory can be found in Masatoshi Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096v2. No numerical claims from that paper are used.

`checks.py` executes 31 exact symbolic/algebraic controls. The universal proofs of inverse convergence, the remote-tail construction, the energy scaling, and the joint boundary reconstruction are the arguments above. The finite checks are not substitutes for them.

The arithmetic adapter has a controlled vanishing residual on the full unconditional spectral strip. The NS source-coordinate completion, in contrast, has a harmonic fibre that remains dynamically visible even when the vorticity-operator difference tends to zero in norm. Neither statement supplies a final RH positivity proof or an NS blow-up exclusion.
