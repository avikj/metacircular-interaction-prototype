# Five-dimensional strain completion and the exact signature of the Weil form

Repository snapshot inspected: `avikj/metacircular-interaction-prototype`, commit `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope and inputs

This note proves two application-specific completion results. For whole-space incompressible velocity fields with bounded vorticity and globally bounded mean oscillation of the velocity gradient, the kernel of the vorticity reading consists exactly of affine harmonic velocities. After fixing translations, the unresolved source fibre has dimension five and has a canonical linear section given by mean strain. The bounded-mean-oscillation condition is inherited, with a scale-independent seminorm bound, from the smooth finite-energy sources used in vorticity normalization. The note also proves that all spectral coordinates of the Weil form are generated densely by translations of the previously fixed packet, identifies the full completed form as a reflection form on a weighted sequence Hilbert space, and computes its negative index exactly.

The endpoint singular-integral estimate, the John–Nirenberg theorem, classical zeta continuation and zero counting, and the Weil explicit formula are classical inputs. The proofs below spell out their application. No originality-priority claim, proof of global Navier–Stokes regularity, proof of RH, numerical zeta certificate, or Agda/Lean compilation is asserted. The attached script verifies algebraic identities and finite signature controls; it does not verify the analytical density and compactness arguments.

The inspected repository modules `Pairfield/LinearObservabilityKernel.lean` and `Pairfield/InvariantCorrectiveClosure.lean` provide the abstract observability-kernel transport and least corrective-channel closure. The results below supply concrete analytical kernels, sections, and dense realizations. The generic module statements do not themselves prove these application hypotheses.

# Part I. The whole-space NS source fibre is finite-dimensional in the inherited endpoint class

## 1. The inherited endpoint estimate

For a locally integrable matrix field F, let

\[
[F]_{\mathrm{BMO}}=\sup_B\fint_B|F-F_B|,
\qquad F_B=\fint_B F,
\]

where the supremum is over all Euclidean balls and any fixed finite-dimensional matrix norm may be used.

For a smooth divergence-free finite-energy velocity u on R3 with bounded vorticity \(\omega=\operatorname{curl}u\),

\[
\boxed{[\nabla u]_{\mathrm{BMO}}\le C\|\omega\|_\infty.}
\tag{1}
\]

The gradient is an order-zero Calderón–Zygmund transform of the vorticity:

\[
\partial_j u_i=\epsilon_{i\ell k}\partial_j\partial_\ell(-\Delta)^{-1}\omega_k.
\tag{2}
\]

A direct explanation of (1) is useful. For a ball B of radius R, split the source into its part on 2B and its complement. The local part is controlled in L2 by the bounded Fourier multiplier, so its mean oscillation on B is at most \(C\|\omega\|_\infty\). For the remote part, subtract its value at the centre. The derivative of the order-zero kernel is \(O(|y|^{-4})\), and therefore the change across B is bounded by

\[
C\|\omega\|_\infty\int_{|y|>2R}R|y|^{-4}\,dy
\le C\|\omega\|_\infty.
\]

Local delta terms in the multiplier are themselves L-infinity bounded. This proves the mean-oscillation estimate. On bounded sources without decay, the same kernel-subtraction construction defines the transform modulo an additive constant matrix.

The estimate is scale independent. For \(u_r(x)=r u(x_0+rx)\),

\[
[\nabla u_r]_{\mathrm{BMO}}=r^2[\nabla u]_{\mathrm{BMO}},
\qquad \|\operatorname{curl}u_r\|_\infty=r^2\|\omega\|_\infty.
\]

Thus a global vorticity normalization to at most one also gives a uniform BMO seminorm bound on the velocity gradient. For periodic sources on expanding tori, the periodic Calderón–Zygmund estimate has the same dilation-independent constant. On balls larger than a period, the zero-mean gradient and its cell L2 bound control the mean oscillation; on smaller balls the periodic singular-integral argument applies. Every local whole-space limit therefore inherits the global BMO bound, provided the local gradient limit exists. This is not a bound on the mean strain.

## 2. Harmonic BMO functions are constant

If f is entire harmonic and belongs to BMO(R3), the interior harmonic estimate gives, at every x and every R,

\[
|\nabla f(x)|\le\frac C R\fint_{B_R(x)}|f-f_{B_R(x)}|
\le\frac C R[f]_{\mathrm{BMO}}.
\]

Letting R tend to infinity proves that f is constant. The same conclusion applies to harmonic distributions, which are smooth by Weyl's lemma.

## 3. Complete kernel classification

Let

\[
\mathcal X=\{u\in W^{1,1}_{\mathrm{loc}}(\mathbb R^3;\mathbb R^3):
\operatorname{div}u=0,\ \operatorname{curl}u\in L^\infty,
\ [\nabla u]_{\mathrm{BMO}}<\infty\}.
\]

All gradients in this class belong locally to every finite Lp space by John–Nirenberg. Let \(S_u=(\nabla u+\nabla u^T)/2\).

### Theorem 1

\[
\boxed{
\ker(\operatorname{curl}:\mathcal X\to L^\infty)
=\{x\mapsto Ax+b:A=A^T,\ \operatorname{tr}A=0,\ b\in\mathbb R^3\}.
}
\tag{3}
\]

Proof. If h has zero divergence and curl, then \(\Delta h=0\). Every entry of \(\nabla h\) is entire harmonic and BMO, and is therefore constant. Hence \(h=Ax+b\). Zero curl makes A symmetric; zero divergence makes it trace-free. Conversely all these affine fields have zero curl and divergence, and constant gradient has zero BMO seminorm. This proves both inclusion directions.

The full kernel has dimension eight. Fixing translation leaves precisely \(\operatorname{Sym}_0(3)\), of dimension five. Higher harmonic multipoles, possible on a single ball, do not survive the global BMO gradient requirement.

## 4. A canonical split completion, with the exact source image retained

Let B be the unit ball centred at zero. Define

\[
b(u)=\fint_Bu,
\qquad A(u)=\fint_B S_u,
\qquad \mathcal N u=u-b(u)-A(u)x.
\tag{4}
\]

Then \(\mathcal N u\) is divergence free, has the same vorticity as u, and has zero mean velocity and zero mean strain on B. Further,

\[
\mathcal N^2=\mathcal N.
\]

If u and v have the same curl, Theorem 1 implies \(u-v=Ax+b\), and (4) subtracts exactly that difference. Thus \(\mathcal N u\) depends only on the vorticity.

Let \(\mathcal V=\operatorname{curl}(\mathcal X)\), the declared realized image. For \(\omega\in\mathcal V\), let \(\mathcal B_0\omega\) be the unique velocity with that curl and both normalized means zero. Then

\[
\boxed{
\mathcal X\simeq\mathcal V\times\operatorname{Sym}_0(3)\times\mathbb R^3,
\quad u\mapsto(\operatorname{curl}u,A(u),b(u)),
}
\tag{5}
\]

with inverse

\[
(\omega,A,b)\mapsto\mathcal B_0\omega+Ax+b.
\tag{6}
\]

This is an equivalence over the vorticity map. No surjectivity assertion about arbitrary independently prescribed fields has been substituted for membership in \(\mathcal V\). Every fibre is a torsor for the displayed eight-dimensional kernel; the normalized mean conditions select its unique representative.

Five additional real linear strain readings are minimal after translation is fixed: any linear observer with fewer than five scalar outputs has a nontrivial kernel on \(\operatorname{Sym}_0(3)\), whereas A(u) achieves injectivity on that fibre. This is a minimality statement for linear observers, not arbitrary set-theoretic encodings.

## 5. Stability of the completed inverse

The estimate (1) also holds for every u in \(\mathcal X\). To see this, form the Calderón–Zygmund gradient transform of its bounded vorticity modulo constants. The difference from \(\nabla u\) is a harmonic BMO matrix, hence constant. Thus their BMO seminorms coincide up to the universal transform estimate.

John–Nirenberg controls every finite Lp mean oscillation. The mean of the skew part of \(\nabla u\) is fixed by the mean vorticity, while the symmetric part is A(u). Comparing means over nested balls gives at most logarithmic growth in the radius ratio. Poincaré, with the mean velocity fixed on B, then yields, for every finite R and \(1<p<\infty\),

\[
\boxed{
\|u-v\|_{W^{1,p}(B_R)}
\le C_{p,R}\bigl(
\|\operatorname{curl}u-\operatorname{curl}v\|_\infty
+|A(u)-A(v)|+|b(u)-b(v)|\bigr).
}
\tag{7}
\]

Consequently strong vorticity convergence plus convergence of the eight finite coordinates implies local W1p convergence. This repairs the topology used in the remote-tail example: the vorticity can tend uniformly to zero while A remains a prescribed nonzero matrix, and the completed coordinate records exactly that matrix.

### Compactness version

Suppose \(u_n\in\mathcal X\), \(\sup_n\|\operatorname{curl}u_n\|_\infty<\infty\), and the coordinates A(u_n), b(u_n) are bounded. The preceding estimates give uniform W1p bounds on every ball. After a subsequence,

\[
u_n\to u\quad\text{in }C^\alpha_{\mathrm{loc}}\text{ for every }\alpha<1,
\]

and weakly in every finite local W1p space. The vorticity converges weak-star along a further subsequence; u has that vorticity and remains in \(\mathcal X\). If the vorticity weak-star limit and the limits of A and b are specified, uniqueness from (5) identifies every subsequential velocity limit, so the entire sequence converges locally in C-alpha.

This is a spatial compactness statement. It neither guarantees a nonzero weak vorticity limit, nor time compactness, nor convergence of every nonlinear derivative observable, nor boundedness of the finite coordinates along an actual singular trajectory.

## 6. Exact scale residual of the finite coordinates

Write \(A_R(u)=\fint_{B_R}S_u\), and similarly \(b_R(u)=\fint_{B_R}u\). Under \(u_r(x)=r u(rx)\),

\[
A_1(u_r)=r^2A_r(u),\qquad b_1(u_r)=r b_r(u).
\tag{8}
\]

The change of anchor is the exact cocycle

\[
A_R-A_s=(A_R-A_r)+(A_r-A_s).
\tag{9}
\]

It is this residual, not an asserted invariance of the unit-ball mean, that accompanies consecutive scale changes. BMO bounds its size by a constant times \(1+|\log(R/r)|\), multiplied by the vorticity bound; no sign is supplied.

## 7. Affine subtraction is not an NS symmetry: retain its metric and pressure

For a differentiable source history write

\[
u(x,t)=v(x,t)+A(t)x+b(t),\qquad A=A^T,\quad\operatorname{tr}A=0.
\]

The vorticity equation is exactly

\[
\partial_t\omega+(v+Ax+b)\cdot\nabla\omega
=(\nabla v+A)\omega+\nu\Delta\omega.
\tag{10}
\]

Thus deleting A removes actual stretching. The pressure also records the affine history. In particular, for arbitrary smooth A(t) symmetric trace-free and b(t),

\[
u=Ax+b,
\quad p=-\tfrac12x^T(A'+A^2)x-(b'+Ab)\cdot x
\tag{11}
\]

is an exact NS solution with zero vorticity. Unless trivial, it lies outside the finite-energy whole-space class. The compactified local equations alone do not recover the original global pressure selection.

There is an exact representation change instead of deletion. Let

\[
F'=AF,\quad F(s)=I,\qquad c'=Ac+b.
\]

Then det F=1. In coordinates \(x=F(t)y+c(t)\), put

\[
\widetilde v=F^{-1}v(Fy+c,t),
\quad\widetilde\omega=F^{-1}\omega(Fy+c,t).
\]

The transformed vorticity equation is

\[
\boxed{
\partial_t\widetilde\omega+
\widetilde v\cdot\nabla_y\widetilde\omega
=(\widetilde\omega\cdot\nabla_y)\widetilde v
+\nu(F^{-1}F^{-T}):\nabla_y^2\widetilde\omega.
}
\tag{12}
\]

The affine stretching cancels against differentiation of F-inverse. It reappears in the positive spatial metric \(g=F^TF\) and its inverse diffusion tensor. The vorticity reconstruction uses curl and Hodge operations for this transported metric; it is not legitimate to retain Euclidean curl in y coordinates. Both g and its inverse have determinant one, but their condition numbers need not remain bounded. This is lossless transport, not a dissipative estimate or a regularity conclusion.

# Part II. The completed Weil source space and its exact negative index

## 8. Definitions without RH

Let \(\Sigma\) be the set of distinct shifted nontrivial zeta zeros \(z=\rho-1/2\), with multiplicity m(z). It is a discrete subset of \(|\Re z|<1/2\), with polynomial-logarithmic counting growth. Define

\[
\theta z=-\overline z,
\quad\mathcal H=\ell^2(\Sigma,m),
\quad\langle a,b\rangle=\sum_zm(z)a_z\overline{b_z}.
\]

The scalar product is linear in its first entry. Let

\[
(Ja)_z=a_{\theta z}.
\tag{13}
\]

The functional equation gives \(m(\theta z)=m(z)\), so

\[
J^*=J,\qquad J^2=I.
\tag{14}
\]

For a compact smooth source v set

\[
(Ev)_z=V_v(z)=\int v(x)e^{-zx}\,dx.
\]

The actual centered Weil form is

\[
\boxed{Q_W(v,w)=\langle Ev,J Ew\rangle.}
\tag{15}
\]

The positive majorant is \(\|v\|_{\mathcal Z}=\|Ev\|_{\mathcal H}\). It is not an arithmetic positivity assumption. It dominates the absolute value of the form.

For completeness E is injective on compact smooth sources. Their transforms are entire of exponential type and a nonzero such transform has only O(R) zeros in disks of radius R by Jensen's formula. Unconditionally, a positive proportion of zeta zeros are simple and on the critical line; in particular there are at least c R log R distinct sample points. Vanishing of Ev forces V_v identically zero and then v=0 by Fourier uniqueness. This use of simple zeros does not assume RH.

## 9. The fixed packet is cyclic on every terminal half-line

Use

\[
h(x)=e^{-4x}(q*q)(x),\quad q=4\mathbf1_{[0,1/4]},
\quad H(z)=16\frac{(1-e^{-(z+4)/4})^2}{(z+4)^2}.
\tag{16}
\]

Its apparent pole at -4 is removable. Its zeros have real part -4, so H is nonzero on the shifted zeta strip. It decays quadratically in the imaginary coordinate there; consequently Eh is in \(\mathcal H\).

### Theorem 2

For every real T,

\[
\boxed{
\overline{\operatorname{span}\{E(T_t h):t>T\}}^{\mathcal H}
=\mathcal H.
}
\tag{17}
\]

The same assertion holds with t restricted to \(D=\mathbb Z\log2+\mathbb Z\log3\).

Proof. Suppose c is orthogonal to that orbit. For t>T,

\[
0=\sum_zm(z)H(z)\overline{c_z}\,e^{-zt}.
\tag{18}
\]

The coefficients are absolutely summable, because

\[
\sum_zm(z)|H(z)c_z|
\le\|Eh\|_{\mathcal H}\|c\|_{\mathcal H}.
\]

For Re s>1/2, taking a one-sided Laplace transform after T gives

\[
0=\sum_z\frac{m(z)H(z)\overline{c_z}e^{-zT}}{s+z}.
\tag{19}
\]

This series is normally convergent on every compact set away from the discrete pole set. It defines a meromorphic function. The residue at -z equals \(m(z)H(z)\overline{c_z}e^{-zT}\). Identity continuation and nonvanishing of H force every c_z to vanish. Therefore the orthogonal complement of the orbit span is zero.

The orbit is norm-continuous in t by dominated convergence on compact t-intervals. Restricting to the dense subgroup D leaves the same closed span.

Each translated packet is itself in the closure of E(Cc-infinity): convolve h with compact smooth approximate identities. Their transforms multiply H by factors tending pointwise to one and uniformly bounded on the shifted strip. Quadratic decay supplies a square-summable dominating sequence. Hence the majorant completion of Cc-infinity is exactly \(\mathcal H\). This proves the complete realization rather than simply defining a larger sequence space around the source image.

## 10. The complete source form is the reflection form

The preceding theorem proves

\[
\boxed{
\widehat{(C_c^\infty,\|\cdot\|_{\mathcal Z})}\simeq\mathcal H,
\qquad Q_W=\langle\,\cdot,J\cdot\,\rangle.
}
\tag{20}
\]

Every continuum of scale translations is represented by

\[
(U_ta)_z=e^{-zt}a_z,
\qquad\|U_t\|\le e^{|t|/2}.
\]

Their exact conservation law is

\[
U_t^*JU_t=J.
\tag{21}
\]

Under RH, every z is fixed by theta, so J=I and U is unitary in the positive majorant. If there is an off-critical pair, J has a negative eigendirection. The theorem does not replace J by I or supply positivity by defining a different scalar product.

## 11. Exact negative index

Define \(\operatorname{ind}_{-}(Q_W)\) as the supremum of dimensions of finite subspaces of Cc-infinity on which the form is negative definite. Then

\[
\boxed{
\operatorname{ind}_{-}(Q_W)
=\#\{\{z,\theta z\}:z\ne\theta z\}
=\#\{\rho:\zeta(\rho)=0,\ \Re\rho>1/2\}_{\mathrm{distinct}}.
}
\tag{22}
\]

Proof. A theta-fixed coordinate is positive. On each nonfixed pair, J is the two-by-two exchange matrix, with one positive and one negative eigendirection. A negative subspace injects into the negative spectral subspace via its orthogonal projection, proving the upper bound.

Conversely, choose any finite number of negative orthonormal eigenvectors of J. By (17), approximate each by the evaluation of a finite sum of translated packets. The resulting finite Gram matrix is arbitrarily close to minus the identity, hence remains negative definite. Smoothing the packet sources preserves this strict property. This supplies actual compact smooth source subspaces of every dimension up to the negative spectral dimension and proves equality.

The equality also holds if the test family is restricted to finite sums of the same packet at lattice shifts beyond any fixed T. Gaussian-rational coefficients can be used by another finite perturbation preserving strict negativity.

Multiplicity weights rescale coordinates but do not create new evaluation coordinates: the Weil form uses values, not a full jet at each multiple zero. Thus the count in (22) is of distinct reflection pairs. Nontrivial zeros have nonzero imaginary part, and conjugation pairs right-of-line zeros. When finite, the negative index is consequently even. Each distinct off-critical quartet contributes two negative directions; infinitely many such pairs give infinite negative index.

A spectral negative eigenvector need not itself be the transform of a compact source. Density, not a false surjectivity assertion on Cc-infinity, transports strict negativity to finite source witnesses.

## 12. Localized operator exhaustion

Let \(A_a\) be the self-adjoint operator of the localized closed Weil form on L2(-a,a), whose compactly supported smooth functions form a core. Its discrete spectrum has a finite number \(n_-(A_a)\) of negative eigenvalues. Form-domain inclusion makes this number nondecreasing with a. Every finite collection of compact test sources is contained in some finite interval, and every finite negative spectral subspace of a localized operator can be approximated in form norm by core functions. Therefore

\[
\boxed{
\lim_{a\to\infty}n_-(A_a)
=\operatorname{ind}_{-}(Q_W)
=\#\{\rho:\Re\rho>1/2\}_{\mathrm{distinct}}.
}
\tag{23}
\]

This is a signature/exhaustion theorem, not a proof that either side is zero. It identifies precisely which negative sectors cannot be dismissed as artifacts of an enlarged spectral carrier: each has actual finite, compact-source, fixed-packet witnesses. The explicit finite inverse of the packet, with its two retained boundary translates, remains a quantitative way of passing a given compact test to packet form.

# Joint status

On NS, the source completion supplies the complete harmonic kernel and a minimal five-scalar repair after translation, inside the BMO-gradient class inherited by globally vorticity-normalized sources. It does not bound the repaired coordinates, control their time evolution, eliminate vorticity loss in weak limits, or recover the global finite-energy pressure law from local data alone.

On RH, the receiver orbit densely generates the full majorant space, and the completed Weil form has exactly the reflection signature stated above. This does not prove the reflection is pointwise fixed. It eliminates an additional source-realizability ambiguity and computes the full negative index if off-line zeros exist.

No conclusion that either global target is nearly solved follows just from these completion theorems.

## References and exact repository loci

F. John and L. Nirenberg, On functions of bounded mean oscillation, Communications on Pure and Applied Mathematics 14 (1961), 415–426, DOI 10.1002/cpa.3160140317.

C. Fefferman and E. M. Stein, H^p spaces of several variables, Acta Mathematica 129 (1972), 137–193, DOI 10.1007/BF02392215. Classical singular-integral endpoint theory; the relevant near/far argument is included above.

J. B. Conrey, More than two fifths of the zeros of the Riemann zeta function are on the critical line, Journal für die reine und angewandte Mathematik 399 (1989), 1–26, DOI 10.1515/crll.1989.399.1. Used only for an unconditional positive proportion of distinct simple critical-line zeros.

M. Suzuki, Weil's quadratic form via the screw function, arXiv:2606.09096v2 (2026). Used for the localized closed Weil form, its core and self-adjoint discrete-spectrum realization. No conjectural large-support operator convergence is used.

Repository files read at the displayed snapshot:

`formal/lean/Pairfield/LinearObservabilityKernel.lean`

`formal/lean/Pairfield/InvariantCorrectiveClosure.lean`

The executable `checks.py` runs 32 exact algebraic checks. Its formal quartet labels are not claimed zeros of zeta. It verifies no infinite-dimensional estimate or PDE evolution.
