# Dissipative Continuation Memory and a Complete Two-Packet Weil Test

**Date:** 6 September 2026.

## Scope

This note develops two extensions of the preceding prime-receiver and Navier–Stokes observer calculations. The first is an exact arbitrary-depth continuation-separation theorem inside a globally smooth, unforced Navier–Stokes class, together with quantitative bounds and a passive memory realization. The second is a fixed two-packet specialization of the Weil positivity criterion, with a nonvanishing multiplier and an unconditionally positive, prime-free diagonal.

The arguments are mathematical derivations. They are not newly compiled Agda/Lean modules, and no originality-priority assertion is made. The accompanying executable verifies finite algebraic identities. Neither general three-dimensional Navier–Stokes regularity nor the Riemann hypothesis is established.

Repository reads are pinned to `64effa62411bad3c12d513b2df5a1e5e55946afb`. The relevant verified-source constructions are `MergingASeparatedPairBreaksAtTheSeparatingContinuation.agda` and `FutureSeparation.agda`. The former takes a separating continuation as input and rules out a decoder on a compression that merges its two source states. The latter distinguishes a witnessed finite separator from merely negated future equivalence. The present PDE construction supplies actual separating witnesses, not an inference from abstract non-equivalence alone.

## 1. An exact globally smooth class

Work on the normalized torus \((\mathbb R/2\pi\mathbb Z)^3\). Let \(\nu>0\), \(N\ge2\) and \(m\ge1\) be integers, and let \(A,C>0\). Define

\[
a(x_1,t)=A e^{-\nu N^2t}\cos(Nx_1).
\]

Let \(v\) solve

\[
v_t+a(x_1,t)v_{x_2}=\nu(v_{x_1x_1}+v_{x_2x_2}),
\qquad v(x_1,x_2,0)=C\cos(x_2-mNx_1).
\]

Then, for \(\sigma\in\{+1,-1\}\),

\[
u^\sigma=(0,a,\sigma v),\qquad p^\sigma=0
\]

solves unforced three-dimensional incompressible Navier–Stokes. Indeed, the divergence is zero; the second component solves the heat equation; the only nonzero convective term is \(\sigma a v_{x_2}\) in the third component; and that component has no \(x_3\) dependence, so its divergence is zero and pressure may be identically zero.

These solutions are smooth for all finite times. The coefficient \(a\) is smooth and bounded with all derivatives on each finite time interval. Differentiating the linear scalar equation, integrating by parts, and inducting in Sobolev order gives finite bounds at every order. This is a direct global existence argument for this triangular class, not an appeal to general 3D regularity.

## 2. Arbitrarily deep matching jets and a specified first separation

Let \(P=P_{\le1}\) be Fourier projection onto integer wavevectors of Euclidean length at most one, and set \(U^\sigma=Pu^\sigma\). Write

\[
v(x_1,x_2,t)=\Re\left[e^{ix_2}\sum_{k\in\mathbb Z}c_k(t)e^{ikNx_1}\right],
\qquad c_k(0)=C\delta_{k,-m}.
\]

The exact coefficient equations are

\[
\dot c_k=-\nu(1+N^2k^2)c_k-
\frac{iA e^{-\nu N^2t}}2(c_{k-1}+c_{k+1}).
\tag{2.1}
\]

The resolved velocity is

\[
U^\sigma(x,t)=\sigma e_3\Re[c_0(t)e^{ix_2}].
\]

### Theorem 2.1: arbitrary-depth jet separation

For every \(m\ge1\),

\[
c_0^{(j)}(0)=0\quad(0\le j<m),
\qquad c_0^{(m)}(0)=C\left(-\frac{iA}{2}\right)^m.
\tag{2.2}
\]

Consequently,

\[
\partial_t^jU^+(0)=\partial_t^jU^-(0)=0\quad(j<m),
\]

but

\[
\partial_t^mU^\sigma(x,0)=
\sigma C\left(\frac A2\right)^m e_3
\cos\left(x_2-\frac{m\pi}{2}\right).
\tag{2.3}
\]

**Proof.** A coupling in (2.1) moves the Fourier index by exactly one. Diffusion does not move it. Explicit time differentiation of the coupling coefficient also does not add an extra index move. Reaching index zero from \(-m\) therefore requires at least \(m\) coupling operations. At derivative order exactly \(m\), every operation must be a coupling and every move must be to the right. This unique word has coefficient \((-iA/2)^m\). An equivalent formal induction uses the Leibniz recursion

\[
c_k^{(r+1)}(0)=-\nu(1+N^2k^2)c_k^{(r)}(0)
-\frac{iA}{2}\sum_{\ell=0}^r\binom r\ell(-\nu N^2)^\ell
\bigl(c_{k-1}^{(r-\ell)}(0)+c_{k+1}^{(r-\ell)}(0)\bigr).
\]

This proves (2.2). Since the solutions are smooth through time zero, the nonzero leading derivative also proves that their resolved futures differ for all sufficiently small positive times. ∎

### Resolved stress jets also agree to arbitrary prescribed order

Define the exact stress

\[
R^\sigma=P(u^\sigma\otimes u^\sigma)-U^\sigma\otimes U^\sigma.
\]

The only sign-sensitive entries are the \((2,3)\) and \((3,2)\) entries, coming from \(P(av)\). Their low mode requires \(v\) to reach Fourier index \(\pm1\), which takes at least \(m-1\) couplings. Thus

\[
\partial_t^jR^+(0)=\partial_t^jR^-(0)
\qquad(0\le j\le m-2).
\tag{2.4}
\]

For any fixed jet depth \(J\), taking \(m=J+2\) therefore gives two globally smooth solutions with the same initial resolved-velocity and resolved-stress jets through order \(J\), and different resolved futures.

This refutes a universal closure based only on those specified finite initial jets. It does not refute every possible finite-dimensional encoding, does not assert equality of all possible observables, and does not assert equality of observation histories on a nontrivial time interval.

### Scalar readings can agree for the entire future

The sign change \(v\mapsto-v\) preserves the full pointwise fields \(|u|^2\) and \(|\nabla u|^2\). It also preserves \(|U|^2\), \(\operatorname{tr}R\), and the scalar resolved energy flux \(-R:\nabla U\). Pressure is zero for both solutions at all times.

The velocity gradient is

\[
\nabla u^\sigma=
\begin{pmatrix}
0&0&0\\
a_{x_1}&0&0\\
\sigma v_{x_1}&\sigma v_{x_2}&0
\end{pmatrix}.
\]

It is nilpotent. Consequently, with the usual velocity-gradient invariants,

\[
Q_{\rm inv}=-\tfrac12\operatorname{tr}((\nabla u)^2)=0,
\qquad R_{\rm inv}=-\det(\nabla u)=0
\]

for both solutions, at every space–time point. These equalities do not prevent the explicit continuation separation in (2.3).

## 3. Quantitative suppression of the hidden continuation

Let

\[
\beta(t)=\int_0^t A e^{-\nu N^2s}\,ds
=\frac{A}{\nu N^2}(1-e^{-\nu N^2t}).
\]

For integer \(m\ge0\), define

\[
I_m(b)=\sum_{r=0}^\infty
\frac{(b/2)^{m+2r}}{r!(m+r)!}.
\]

This is the modified Bessel function, but the displayed convergent series is the only fact about it needed below.

### Theorem 3.1: uniform viscous continuation bound

\[
|c_0(t)|\le C e^{-\nu t}I_m(\beta(t))
\tag{3.1}
\]

and independently

\[
|c_0(t)|\le C e^{-\nu t}.
\tag{3.2}
\]

In particular,

\[
|c_0(t)|\le C e^{-\nu t}
\min\left\{1,
\frac{(\beta(t)/2)^m}{m!}
\exp\left(\frac{\beta(t)^2}{4(m+1)}\right)\right\}.
\tag{3.3}
\]

**Proof of (3.1).** Expand the evolution of (2.1) by time-ordered Duhamel iteration, using the diagonal heat operator as the free evolution. A path of length \(n\) contributes at most

\[
C e^{-\nu t}\frac{\beta(t)^n}{2^n n!}.
\]

All heat factors combine to at most \(e^{-\nu t}\), since every diagonal decay rate is at least \(\nu\). The time-ordered product of the nonnegative amplitudes integrates to \(\beta(t)^n/n!\).

A path from \(-m\) to zero has length \(m+2r\), with \(r\) left moves and \(m+r\) right moves. There are \(\binom{m+2r}{r}\) such paths. Summing their absolute upper bounds yields exactly (3.1). The argument is uniform on finite Fourier truncations and passes to the bounded-perturbation evolution on \(\ell^2(\mathbb Z)\).

**Proof of (3.2).** The off-diagonal part of (2.1) is skew-adjoint. Therefore

\[
\frac12\frac d{dt}\sum_k|c_k|^2
=-\nu\sum_k(1+N^2k^2)|c_k|^2
\le-\nu\sum_k|c_k|^2.
\]

The initial norm is \(C\), proving (3.2).

Finally, \((m+r)!\ge m!(m+1)^r\) in the series for \(I_m\), giving (3.3). ∎

The asymptotic at zero is

\[
c_0(t)=\frac{C(-iA/2)^m}{m!}t^m+o(t^m),
\]

so the order of the path bound agrees with the exact first visible derivative.

**Consequence.** Arbitrarily many invisible derivatives do not imply an arbitrarily long physical memory. In this class, the relevant interaction amplitude is bounded by \(A/(\nu N^2)\), and distant hidden modes have factorially small influence on the fixed resolved mode. This is an actual stability estimate, not merely a statement that an inverse is unavailable.

For an arbitrary initial coefficient vector supported on \(|k|\ge m\), the same entrywise path bounds and Cauchy–Schwarz give the further estimate

\[
|c_0(t)|\le e^{-\nu t}\|c(0)\|_{\ell^2}
\left(2\sum_{k=m}^\infty I_k(\beta(t))^2\right)^{1/2}.
\tag{3.4}
\]

## 4. Exact non-Markovian closure and retained energy

Let \(x=c_0\), \(y=Qc\), where \(Q\) removes index zero. Let \(D\) be diagonal with entries \(1+N^2k^2\), and \(T\) the nearest-neighbor adjacency operator. Set

\[
L(t)=-\nu D-\frac{i\alpha(t)}2T,
\qquad \alpha(t)=Ae^{-\nu N^2t}.
\]

In resolved/fine blocks,

\[
\dot x=-\nu x+B(t)y,
\qquad \dot y=C(t)x+L_Q(t)y,
\qquad C(t)=-B(t)^*.
\tag{4.1}
\]

Here \(\|B(t)\|=\|C(t)\|=|\alpha(t)|/\sqrt2\).

Let \(V_Q(t,s)\) denote the homogeneous propagator generated by \(L_Q(t)=QL(t)Q\). Since every fine index satisfies \(|k|\ge1\),

\[
\|V_Q(t,s)\|\le e^{-\nu(1+N^2)(t-s)}.
\tag{4.2}
\]

Variation of constants gives the exact resolved equation

\[
\dot x(t)=-\nu x(t)+\eta(t)
+\int_0^t K(t,s)x(s)\,ds,
\tag{4.3}
\]

where

\[
\eta(t)=B(t)V_Q(t,0)y(0),
\qquad K(t,s)=B(t)V_Q(t,s)C(s).
\tag{4.4}
\]

The first term retains the original fine-state information. Deleting it would identify the initial sign-pair constructed in Section 2 and destroy exact continuation reconstruction.

### Quantitative memory bounds

\[
|K(t,s)|\le
\frac{|\alpha(t)\alpha(s)|}{2}
 e^{-\nu(1+N^2)(t-s)}
=rac{\alpha(s)^2}{2}
 e^{-\nu(1+2N^2)(t-s)}.
\tag{4.5}
\]

Consequently,

\[
\int_s^\infty |K(t,s)|\,dt
\le\frac{\alpha(s)^2}{2\nu(1+2N^2)}.
\tag{4.6}
\]

Also,

\[
|\eta(t)|\le
\frac{A}{\sqrt2}e^{-\nu(1+2N^2)t}\|y(0)\|.
\tag{4.7}
\]

Thus a valid exponential memory timescale is

\[
\tau_N=\frac1{\nu(1+2N^2)}.
\]

This is a bound on the specified class and specified resolved/fine split, not a universal turbulence-memory theorem.

### Theorem 4.1: integrated passivity of the memory

For any prescribed continuous resolved path \(x\), let \(y_x\) solve

\[
\dot y_x=L_Q(t)y_x+C(t)x(t),\qquad y_x(0)=0.
\]

Then

\[
\boxed{
\int_0^T\Re\left[
\overline{x(t)}\int_0^t K(t,s)x(s)\,ds\right]dt
=-\frac12\|y_x(T)\|^2
-\nu\int_0^T\langle Dy_x(t),y_x(t)\rangle dt\le0.
}
\tag{4.8}
\]

**Proof.** The fine energy identity is

\[
\tfrac12\frac d{dt}\|y_x\|^2
=-\nu\langle Dy_x,y_x\rangle+
\Re\langle y_x,Cx\rangle.
\]

Since \(C=-B^*\), the last term equals \(-\Re(\bar x By_x)\). Substitute the variation-of-constants expression for \(y_x\) and integrate. ∎

The memory can produce instantaneous backscatter. Formula (4.8) does not assert a pointwise sign of \(K(t,s)\). It proves the required sign for the accumulated quadratic work when the induced fine response starts from zero. Nonzero initial fine energy appears separately in \(\eta\).

This is the exact linear nonautonomous memory-elimination construction used in Mori–Zwanzig and generalized Langevin methods. The present additional information is the explicit PDE realization, the delay hierarchy, the path bound, and the quantified fine propagator for this class.

## 5. The precise term obstructing transfer to general NS secants

For two smooth NS solutions with the same viscosity and forcing, set

\[
z=u_1-u_2,\qquad \bar u=\frac{u_1+u_2}{2}.
\]

Their difference obeys

\[
z_t+\bar u\cdot\nabla z+z\cdot\nabla\bar u+\nabla\pi=\nu\Delta z,
\qquad \nabla\cdot z=0.
\]

Therefore

\[
\boxed{
\frac12\frac d{dt}\|z\|_2^2
+\nu\|\nabla z\|_2^2
=-\int z^\mathsf T S(\bar u)z\,dx,
\qquad S(\bar u)=\tfrac12(\nabla\bar u+\nabla\bar u^\mathsf T).
}
\tag{5.1}
\]

In the sign-pair of Section 1, \(z\) points in the third coordinate and \(S_{33}(\bar u)=0\). The strain pairing in (5.1) vanishes identically. That is why the skew-adjoint transfer and diffusion argument is valid there.

For the general problem this pairing is indefinite. In particular, the same Hilbert norm does not automatically make the fine propagator contractive.

For a fixed high-frequency orthogonal projection whose range has spatial frequencies of magnitude at least \(K\), the homogeneous projected linearized evolution does satisfy the explicit upper bound

\[
\|V_Q(t,s)\|
\le\exp\left[-\nu K^2(t-s)
+\int_s^t\|S(\bar u(\tau))^-\|_{L^\infty,\mathrm{op}}\,d\tau\right],
\tag{5.2}
\]

where \(S^-\) is the positive semidefinite negative part of the symmetric matrix. This follows directly from (5.1), Poincaré on the high-frequency range, and Grönwall. It is an estimate for a specified projected secant equation along already smooth trajectories, not an a priori bound on the strain integral.

Thus lifting the passive-memory proof to arbitrary NS requires controlling the signed strain interaction, or a stronger structure that implies such control. Neither equality of \(Q_{\rm inv},R_{\rm inv}\) nor positive energy readings supplies that estimate.

## 6. An elementary autocorrelation receiver for the Weil form

Use additive convolution. Let

\[
q(s)=4\mathbf1_{[0,1/4]}(s),
\qquad f(s)=e^{-4s}(q*q)(s),
\qquad g=f*\widetilde f,\quad \widetilde f(s)=f(-s).
\tag{6.1}
\]

Then \(f\) is real, nonnegative, continuous and piecewise smooth, supported on \([0,1/2]\), and belongs to \(H^1\). The autocorrelation \(g\) is real, nonnegative, even, \(C_c^2\), and supported in \([-1/2,1/2]\).

Define

\[
F(z)=\int f(s)e^{-zs}\,ds
=16\frac{(1-e^{-(z+4)/4})^2}{(z+4)^2},
\]

and

\[
\boxed{
G(z)=\int g(s)e^{-zs}\,ds=F(z)F(-z)
=256\frac{(1-2e^{-1}\cosh(z/4)+e^{-2})^2}{(16-z^2)^2}.
}
\tag{6.2}
\]

Apparent singularities are removable. The zeros lie on \(\Re z=\pm4\) at nonzero integer multiples of \(8\pi\) in the imaginary coordinate. Hence

\[
G(z)\ne0\qquad(|\Re z|\le1/2).
\tag{6.3}
\]

For real \(\gamma\),

\[
\boxed{
G(i\gamma)=256
\frac{|1-e^{-1-i\gamma/4}|^4}{(16+\gamma^2)^2}>0.
}
\tag{6.4}
\]

Uniformly for \(|\sigma|\le1/2\),

\[
|G(\sigma+i\gamma)|\asymp(1+\gamma^2)^{-2}.
\tag{6.5}
\]

Thus the receiver preserves every potential off-critical zero mode, has a four-derivative inverse loss in Sobolev norms, and has strictly positive real-frequency weights.

### Lemma 6.1: unconditional sector positivity

\[
\Re G(\sigma+i\gamma)>0
\qquad(|\sigma|\le1/2,\ \gamma\in\mathbb R).
\tag{6.6}
\]

**Proof.** Put \(r=e^{-1}\), \(z=\sigma+i\gamma\), and

\[
D(z)=1-2r\cosh(z/4)+r^2.
\]

The elementary estimates

\[
r<37/100,\qquad
\cosh(1/8)-1<1/125,\qquad
\sinh(1/8)<63/500
\]

give

\[
\Re D(z)\ge19549/50000,
\qquad |\Im D(z)|\le4662/50000.
\]

Hence \(|\arg D(z)|<6/25\). Also,

\[
\Re(16-z^2)\ge63/4+\gamma^2,
\qquad |\Im(16-z^2)|\le|\gamma|,
\]

so

\[
|\arg(16-z^2)|<13/100.
\]

Therefore

\[
|\arg G(z)|<2(6/25+13/100)=37/50<\pi/2.
\]

The series bounds used above are elementary: \(\sum_{j=0}^4 1/j!>100/37\); the tail-ratio bounds for the hyperbolic series give \(\cosh(1/8)-1<(1/128)/(1-1/768)<1/125\) and \(\sinh(1/8)<(1/8)/(1-1/384)<63/500\). ∎

## 7. The complete two-packet criterion

Let \(z_\rho=\rho-1/2\), with \(\rho\) ranging over distinct nontrivial zeta zeros and \(m_\rho\) their multiplicities. Set

\[
\mathcal Z(t)=\sum_\rho m_\rho G(z_\rho)e^{z_\rho t},
\qquad M=\mathcal Z(0).
\tag{7.1}
\]

The zero-location theorem, functional-equation symmetries and the standard \(O(T\log T)\) zero count imply that the sum converges absolutely on compact real \(t\)-intervals and that \(\mathcal Z\) is real and even. Lemma 6.1 gives

\[
M>0
\]

without RH, since the real parts of all summands at zero are strictly positive.

### A prime-free expression for the diagonal

Let \(\psi_\Gamma=\Gamma'/\Gamma\) denote the digamma function. The Weil explicit formula gives

\[
\boxed{
M=2G(1/2)+\frac1\pi\int_0^\infty
\left[\Re\psi_\Gamma(1/4+i\gamma/2)-\log\pi\right]
G(i\gamma)\,d\gamma.
}
\tag{7.2}
\]

There is no prime sum: \(g(\pm\log n)=0\) for every \(n\ge2\), because \(1/2<\log2\). The integral converges absolutely by (6.4) and logarithmic growth of the digamma function. Thus the diagonal is fixed independently of any large prime prefix.

### Theorem 7.1: two fixed packet shapes suffice

The following are equivalent:

\[
\mathrm{RH};
\tag{7.3a}
\]

\[
\begin{pmatrix}M&\mathcal Z(t)\\\mathcal Z(t)&M\end{pmatrix}\succeq0
\quad\text{for every }t\in\mathbb R;
\tag{7.3b}
\]

\[
|\mathcal Z(t)|\le M\quad\text{for every }t\in\mathbb R;
\tag{7.3c}
\]

\[
W\bigl((f+cT_tf)*\widetilde{(f+cT_tf)}\bigr)\ge0
\quad\text{for every }t\in\mathbb R,\ c\in\mathbb C,
\tag{7.3d}
\]

where \(T_tf(s)=f(s-t)\), tilde includes complex conjugation for complex inputs, and \(W\) is the centered Weil distribution with convention

\[
W(\phi)=\sum_\rho m_\rho\int\phi(s)e^{z_\rho s}\,ds.
\]

The admissible \(H^1\) piecewise smooth packets can equivalently be obtained by approximation from smooth compactly supported packets; the zero sums are absolutely convergent here.

**Proof of necessity.** Under RH, \(z_\rho=i\gamma\), so (6.4) and absolute convergence give

\[
|\mathcal Z(t)|\le\sum_\rho m_\rho G(i\gamma)=M.
\]

**Proof of sufficiency.** Define

\[
S(t)=\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}g(t-\log n).
\]

For \(t>1/2\), the explicit formula with its trivial terms retained is

\[
\mathcal Z(t)=e^{t/2}G(1/2)-S(t)-J(t),
\quad
J(t)=\sum_{k\ge1}G(2k+1/2)e^{-(2k+1/2)t}.
\tag{7.4}
\]

The positive remainder satisfies

\[
0<J(t)\le\|g\|_1
\frac{e^{-(5/2)(t-1/2)}}{1-e^{-2(t-1/2)}}.
\tag{7.5}
\]

For \(\Re w>1/2\),

\[
\int_0^\infty e^{-wt}[S(t)-e^{t/2}G(1/2)]dt
=G(w)\left[-\frac{\zeta'}{\zeta}(1/2+w)\right]
-\frac{G(1/2)}{w-1/2}.
\tag{7.6}
\]

All translates \(g(t-\log n)\) are supported in positive \(t\), so no endpoint truncation appears. If \(\mathcal Z\) is bounded, (7.4)–(7.5) make the left integrand in (7.6) bounded on the positive half-line. Its Laplace transform is therefore holomorphic for \(\Re w>0\). A zero with \(\Re\rho>1/2\) would give a pole at \(w=z_\rho\) with nonzero residue \(-m_\rho G(z_\rho)\), contradicting (6.3). Functional-equation symmetry excludes left-of-line zeros as well.

The matrix equivalence is elementary. Expanding (7.3d) gives

\[
M(1+|c|^2)+2\Re(c)\mathcal Z(t),
\]

which is nonnegative for every \(c\) exactly when \(|\mathcal Z(t)|\le M\). ∎

In particular, if RH fails, some test of the form \(f+T_tf\) or \(f-T_tf\) has negative Weil value. This is a completeness statement for one packet shape and its translates, not a proof that those values are nonnegative.

### Exact finite-arithmetic inequality

Combining (7.3c) and (7.4), RH implies and is implied by

\[
\boxed{
\left|
\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}g(t-\log n)
-e^{t/2}G(1/2)+J(t)
\right|\le M
\quad(t>1/2).
}
\tag{7.7}
\]

For the reverse implication only boundedness on this half-line is needed; compact-time continuity supplies the rest. Only the finite shell

\[
e^{t-1/2}\le n\le e^{t+1/2}
\]

contributes. The constant \(M\) is given by (7.2), and \(J\) is the explicit positive, rapidly convergent archimedean/trivial-zero remainder. The previous unspecified uniform bound is replaced by one fixed tolerance and one fixed two-packet Gram matrix.

The exact growth statement also persists:

\[
\limsup_{t\to\infty}\frac{\log(1+|\mathcal Z(t)|)}{t}
=\sup_\rho\Re\rho-\tfrac12.
\tag{7.8}
\]

The proof is the same absolute-summability upper bound and uncancelled-Laplace-pole lower bound as in the preceding receiver note. No zero is assumed to attain the supremum.

## 8. A finite-height stability estimate

Suppose all nontrivial zeros with \(|\Im\rho|\le T\), where \(T\ge2\), are on the critical line. Let

\[
M_T=\sum_{|\Im\rho|\le T}m_\rho G(i\Im\rho).
\]

Unconditional sector positivity implies \(0\le M_T\le M\). If

\[
|G(\sigma+i\gamma)|\le C_G(1+\gamma^2)^{-2},
\qquad N_*(Y)\le C_NY\log(2+Y),
\]

where \(N_*\) counts both signs and multiplicities, then dyadic summation gives

\[
\sum_{|\Im\rho|>T}m_\rho|G(z_\rho)|
\le\frac{2C_GC_N}{T^3}
\left[\frac87\log(2+T)+\frac{64}{49}\log2\right].
\tag{8.1}
\]

Consequently,

\[
\boxed{
|\mathcal Z(t)|\le M_T+
\frac{2C_GC_Ne^{|t|/2}}{T^3}
\left[\frac87\log(2+T)+\frac{64}{49}\log2\right].
}
\tag{8.2}
\]

For example, an error allowance \(\varepsilon\) is guaranteed whenever the explicit tail term in (8.2) is at most \(\varepsilon\). Suppressing constants, the corresponding range is \(|t|\lesssim6\log T-2\log\log T\). This is a finite-height-to-finite-scale theorem. It neither removes the residual tail nor infers RH from a finite verification.

One may take \(C_G=256(1+e^{-7/8})^4\); the chosen explicit zero-count bound supplies \(C_N\). No present numerical verification height is assumed in this note.

## 9. Established framework and exact boundary of transfer

The Weil positivity criterion and its continuous screw-function realization are existing results. Suzuki's 2023 paper proves that its explicit function \(\Psi\) is bounded if and only if RH holds, and also that pointwise nonnegativity of \(\Psi\) is equivalent to RH. Its significance here is not a newly discovered positivity criterion in general. The new work in this calculation is the specified autocorrelation receiver, sector estimate, fixed two-translate test, prime-free diagonal, and finite-height tail transfer.

Suzuki's 2026 operator framework proves positivity and simplicity of the bottom eigenvalue for sufficiently small support intervals and continuity of that eigenvalue in the interval parameter. Those are local/support-dependent results. They do not establish that the two-packet Gram matrix above remains positive at every separation.

For the NS class, passivity was derived from an already positive Hilbert energy and the exact cross-block identity \(C=-B^*\). For the Weil problem, the corresponding positive Hermitian form is precisely what must be established globally. Importing the NS energy argument without supplying that positivity would assume the desired arithmetic conclusion.

The substantial asymmetry is therefore explicit: a dissipative memory estimate has been proved on the NS class; the RH side has a sharpened and fully specified arithmetic target, not a proved all-scale estimate.

## References and verification

E. Bombieri, *Problems of the Millennium: the Riemann Hypothesis*, especially the explicit-formula and Weil-positivity discussion, Clay Mathematics Institute.

M. Suzuki, *Aspects of the screw function corresponding to the Riemann zeta-function*, Journal of the London Mathematical Society (2023), DOI 10.1112/jlms.12785; arXiv:2206.03682, Theorems 1.3, 1.6, and 1.7.

M. Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096v2, Theorems 1.3 and 1.4.

A. Gouasmi, E. J. Parish, and K. Duraisamy, *A priori estimation of memory effects in reduced-order models of nonlinear systems using the Mori–Zwanzig formalism*, Proceedings of the Royal Society A (2017), DOI 10.1098/rspa.2017.0385; arXiv:1611.06277.

E. J. Parish and K. Duraisamy, *Non-Markovian Closure Models for Large Eddy Simulations using the Mori–Zwanzig Formalism*, arXiv:1611.03311.

The script `check_algebra.py` verifies exact leading jets and matching stress jets for m=1,...,8, the path-count/Bessel coefficient identity, the nilpotent gradient invariants, finite Fourier cross-block adjoint and dissipativity identities, the response factorization, and the rational sector bounds. These finite checks support but do not replace the all-order analytic proofs above.
