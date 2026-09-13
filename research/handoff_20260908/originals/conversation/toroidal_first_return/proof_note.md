# The actual toroidal 2 -> 4 -> 2 return: its radial operator, memory kernel, and sign

Date: 2026-09-07.
Repository read pin: `avikj/metacircular-interaction-prototype`, commit `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope and provenance

This note continues the user-supplied reflection-scale holonomy / nonlinear quadrupole memory calculation. The actual l=2/l=4 outgoing coefficients, toroidal strain selection, and free heat response are retained inputs. The new calculations are the full polarized l=4-to-l=2 return, its exact integrated free-response kernel, opposite-sign smooth-source examples, and a uniform geometric-stack bound for this next returned source.

No global NS regularity or RH proof is asserted. No Agda or Lean build and no nonlinear PDE simulation was executed. The calculation concerns smooth whole-space finite-energy sources. Compactly supported radial profiles in annuli are the principal class; a rapidly decaying smooth source is also used as a sign control, and its compact annular approximation is described below. These are actual initial data and actual initial variations, not a constructed singular solution.

Sources read:

* Repository `formal/cubical/theorems/automata/ExcursionReturn.agda`: checked ring/semigroup compression identity and observability equivalence. This is supplied machinery, not an analytic Navier-Stokes theorem.
* Saved `proof_note(7).md`, **Source-image rigidity and the exact nonlinear leakage...**, sections 7--14: toroidal degree-two source reconstruction, the full matrix pressure identity, actual outgoing coefficients beta2/beta4, and the distinction between a frozen factorization and the derivative of the common source.
* Saved `source_resolved_closure/proof_note.md`: actual Xi-cardinal sources; exact quadrupole heat response and integrated memory.
* The user's present note supplies the quadratic radial kernel K and signed strain-potential coboundary identity. Both are retained with their actual source hypotheses.

Classical context: the Mori--Zwanzig / excursion-return representation is an exact organizational identity, not an automatic sign or finite-memory theorem. See Gouasmi, Parish, Duraisamy, Proc. R. Soc. A 473 (2017), 20170385, doi:10.1098/rspa.2017.0385. None of the calculations below require an approximate orthogonal-dynamics model.

## 1. Retained angular conventions

Let A be a nonzero real symmetric trace-free 3x3 matrix. Write

    q = tr(A^2),  B = (A^2)_0,
    Y2(n) = n^T A n,
    T_A(n) = n cross (A n) = (1/2)n cross grad_S Y2,
    Y4(n) = Y2(n)^2 - (4/7)n^T B n - (2/15)q,
    T4[A](n) = (1/4)n cross grad_S Y4
              = Y2(n) T_A(n) - (2/7)T_B(n).

Y4 has scalar spherical degree four, and T4[A] has toroidal vector degree four. The fixed-centre projection P is onto the full toroidal degree-two vorticity space (arbitrary matrix-valued radial coefficients), not merely onto multiples of this one A. Put Q=I-P.

For a real radial f, set

    a(rn)=f(r)T_A(n).

Its actual finite-energy velocity is

    u_a = curl[g(r) x cross(Ax)],
    g''+6g'/r = -f/r^2,
    g(r)=(1/5)[r^(-5) integral_0^r s^4 f(s)ds
                         + integral_r^infinity f(s)ds/s].

The actual vorticity nonlinearity is

    N(omega) = curl(u_omega cross omega),
    u_omega = curl(-Delta)^(-1)omega.

The saved outgoing calculation is

    N(a)= beta2 T_B + beta4 T4[A],
    beta2=(6/7)(5gf+2rg'f+rgf'),
    beta4=3rgf'-6gf-rg'f.

Heat preserves the angular splitting. In particular Q N(a)=beta4 T4[A].

## 2. Positivity of the preceding radial kernel: exact domain and exact sign spectrum

The user-supplied first nonlinear-memory form is

    I[f]=integral integral f(s)f(t)K(s,t)dsdt,
    K(s,t)= min(s,t)/(10 max(s,t))
            *[3-2(min(s,t)/max(s,t))^3].

The kernel is strictly positive pointwise. Therefore I[f]>0 for nonzero f>=0. This does not assert positive semidefiniteness on signed sources.

Indeed, at radii 1 and 2 its Gram matrix is

    [[1/10, 11/80], [11/80, 1/10]],

whose eigenvalues are 19/80 and -3/80. Two opposite unit radial atoms have quadratic value -3/40. Replacing the atoms by sufficiently narrow smooth disjoint bumps preserves this strict negative value.

There is an exact Mellin-frequency classification. Set

    x=log r,  F(x)=e^x f(e^x).

Then

    I[f]=integral integral F(x)F(y) k(x-y)dxdy,
    k(x)=(1/10)(3 exp(-|x|)-2 exp(-4|x|)).

With Fourier convention Fhat(xi)=integral exp(-i xi x)F(x)dx,

    khat(xi)=(8-xi^2)/[(1+xi^2)(16+xi^2)],

and hence

    I[f]=(1/(2pi)) integral
         (8-xi^2)/[(1+xi^2)(16+xi^2)] * |Fhat(xi)|^2 dxi.

The form has positive log-radius frequencies |xi|<sqrt(8) and negative frequencies |xi|>sqrt(8).

The nonlinear source is not confined to nonnegative scalar injections even when the initial f is nonnegative. In the compact annular class g>0 and

    beta2=(6/7) r^(-4)g^(-1) d/dr[r^5 g^2 f],
    beta4=3r^3 g^(4/3) d/dr[f/(r^2 g^(1/3))].

For nonzero f>=0 both bracketed functions are positive somewhere and vanish at the endpoints of their support. Their derivatives, and thus beta2 and beta4, take both signs. This is a statement about the source-injection map, not by itself a claim that a scalar positivity cone for an evolution is noninvariant.

## 3. The exact first return must differentiate both source occurrences

For a smooth source a, the actual derivative is

    DN(a)[b] = curl(u_a cross b + u_b cross a).

Keeping only one summand is a frozen-input response and is not the required derivative.

Let F(omega)=nu Delta omega+N(omega), and let omega(t) solve the actual NS vorticity equation with omega(0)=a=Pa. Let p(t) solve the projected equation

    p'=nu Delta p+P N(p),  p(0)=a.

The two are compared only on a common classical interval. Since P commutes with Delta,

    (P omega)''(0)-p''(0) = P DN(a)[Q N(a)].

Consequently

    P omega(t)-p(t)=(t^2/2) P DN(a)[Q N(a)]+o(t^2).

Thus

    R24(a):=P DN(a)[Q N(a)]

is the actual first outward-and-return contribution. The equality does not assume that the degree-two sector is invariant or that an arbitrary linear operator describes the nonlinear flow.

## 4. Explicit radial/angular return operator

First take a general degree-four perturbation in the direction actually emitted by a:

    b(rn)=h(r)T4[A](n).

Write its vector potential as r^2 p(r)T4[A](n). Then

    p''+6p'/r-14p/r^2 = -h/r^2,
    p(r)=(1/9)[r^(-7) integral_0^r s^6 h(s)ds
                          + r^2 integral_r^infinity h(s)ds/s^3].

This is the regular finite-energy inverse; no independent harmonic solution is added.

### The return formula

    P DN(f T_A)[h T4[A]]
      = (4q/49) C[f,h](r) T_A(n),

where

    C[f,h] = 15gh+6rg'h+3rgh' + pf-rp'f-4rpf'.

For the actual first return, substitute h=beta4[f] and its corresponding p. The coefficient is cubic in the actual initial source.

### Derivation

A toroidal mode omega_l=f_l(r) n cross grad_S Y_l/l with vector potential p_l(r) n cross grad_S Y_l/l has velocity

    u_l= a_l Y_l n + b_l grad_S Y_l,
    a_l=-(l+1)p_l/r,
    b_l=-(p_l'+p_l/r)/l.

Here p_2=r^2g and p_4=r^2p, so

    a2=-3rg, b2=-(3rg+r^2g')/2,
    a4=-5rp, b4=-(3rp+r^2p')/4.

The only scalar angular coefficient needed is

    projection_l2(Y2 Y4)=(24/245)q Y2.

This follows from exact sphere moments; equivalently, for every trace-free symmetric C,

    integral Y2(A)Y4(A)Y2(C)
       = (24/245)q integral Y2(A)Y2(C).

For an angular product projected to degree L, integration by parts gives

    projection_L(grad_S Y_l dot grad_S Y_k)
      = [l(l+1)+k(k+1)-L(L+1)]/2 * projection_L(Y_lY_k),

and the gradient projection of Y_l grad_S Y_k has coefficient

    [L(L+1)+k(k+1)-l(l+1)]/[2L(L+1)].

For L=2 and (l,k)=(2,4), the relevant numbers are 10 and 5/3; with (l,k)=(4,2), they are 10 and -2/3.

Writing the poloidal l2 part of u_a cross b+u_b cross a as

    alpha(r)Y2 n + beta(r)grad_S Y2,

one obtains, with c=24/245,

    alpha=10 c q (b2 h/4+b4 f/2),
    beta=c q (-5 a2 h/12+a4 f/3).

Its curl is 2[(r beta)'-alpha]T_A/r. Substitution gives the displayed return formula.

## 5. Exact integrated viscous memory of the returned source

Let Bstr denote the Biot-Savart strain map acting on vorticity. For every toroidal degree-two source F(r)T_A,

    integral_0^infinity Bstr exp(nu t Delta)[F T_A](0)dt
       = -(1/(10nu)) integral_0^infinity rF(r)dr * A,

when the absolute radial moment is finite.

Apply this to the returned source. Define

    J24[f,h]=integral integral f(s)h(t)L24(s,t) dsdt.

Then

    integral_0^infinity Bstr exp(nu t Delta)
      P DN(f T_A)[h T4[A]](0) dt
       = -(6q/(245nu)) J24[f,h] A,

where the exact directional two-radius kernel is

    L24(s,t) =
      (3/5)(t/s)-(4/9)(t/s)^6,       0<t<=s,
      (5/9)(s/t)^3-(2/5)(s/t)^4,     0<s<=t.

Both formulas agree at s=t with value 7/45. Both are strictly positive for positive radii. The kernel is directional: s labels a degree-two source radius; t labels a degree-four source radius. It is not symmetrized by exchanging those roles.

### Radial computation

The exact integration-by-parts identity is

    r C[f,h]
      = 3[(3rg+r^2g')h+(3rp+r^2p')f]
        + d/dr[3r^2gh-4r^2pf].

The boundary term vanishes in the declared source class. The Green functions for unit radial atoms are

    g_s(r)=(1/5)[s^(-1), r<s; s^4 r^(-5), r>s],
    p_t(r)=(1/9)[r^2 t^(-3), r<t; t^6 r^(-7), r>t].

Thus

    L24(s,t)=3t g_s(t)+t^2g_s'(t)+3s p_t(s)+s^2p_t'(s),

which gives the two cases above directly. The matching value on the diagonal is unambiguous by continuity.

## 6. Opposite-sign controls using the same nonlinear ancestry

For the actual return, h=beta4[f]. Even though L24 is pointwise positive, beta4 need not be positive. The resulting memory is not always damping and not always amplifying.

### A. A positive smooth source with opposing returned memory

Take

    g(r)=(1+r^2)^(-2),
    f(r)=4r^2(r^2+7)/(1+r^2)^4 >0,
    h(r)=beta4[f](r)=-8r^4(7r^2+67)/(1+r^2)^7 <0.

These are smooth whole-space finite-energy data; f T_A is smooth at zero, and all displayed moments converge at infinity.

Pointwise positivity of L24 gives

    J24[f,beta4[f]]<0.

The initial central strain is S(0)=-3A, whereas the integrated free response of the returned source is a strictly positive multiple of A. Thus this particular returned contribution opposes the initial strain.

This example can be moved into the compact annular class: multiply f by smooth cutoffs which remove r<epsilon and r>R, with epsilon ->0 and R ->infinity. Recompute g from the actual Green inverse and h=beta4[f]. The small-r behavior f=O(r^2) and large-r behavior f=O(r^-4), together with the explicit Green and L24 kernels, give convergence of J24. Its strictly negative sign therefore persists for sufficiently wide compact annular cutoffs. No singular initial data are required.

### B. A thin nonnegative smooth shell with reinforcing returned memory

Let phi be nonnegative, smooth, compactly supported in (-1,1), and have integral one. Put

    f_epsilon(r)=epsilon^(-1) phi((r-1)/epsilon).

Every epsilon in (0,1/2) gives a smooth compact annular source. Let g_epsilon be its actual radial inverse and h_epsilon=beta4[f_epsilon]. Then

    J24[f_epsilon,h_epsilon] -> 151/225 >0.

Here is a derivation which avoids singular distribution products. Define

    W_f(t)=integral f(s)L24(s,t)ds.

Integration by parts gives

    J24[f,beta4[f]]
       = -integral f(t)[(9g+4tg')W_f+3tg W_f']dt.

On the support of the thin shell, set F_epsilon(t)=integral_0^t f_epsilon(s)ds. Uniformly there,

    g_epsilon=1/5+O(epsilon),
    t g_epsilon'=-F_epsilon+O(epsilon),
    W_f=7/45+O(epsilon),
    W_f'=-31/15+2F_epsilon+O(epsilon).

The two slopes of L24 in its second variable at the diagonal are -31/15 and -1/15. Substitution yields

    J24 = integral f_epsilon[24/25-(26/45)F_epsilon]dt+O(epsilon)
        = 24/25-13/45+O(epsilon)
        = 151/225+O(epsilon).

The initial strain tends to -(3/5)A, and the returned integrated memory is a negative multiple of A. It therefore reinforces the initial strain.

The peak vorticity of the unit-mass thin shell grows as epsilon shrinks. To compare sources with fixed vorticity supremum, multiply each source by a positive normalizing scalar. Both the initial strain and the cubic returned contribution retain their signs; the latter scales cubically. Thus the two signs are not an artifact of allowing only one amplitude normalization.

These statements concern the actual first-return source and its subsequent free heat response. They are not statements that the full nonlinear solution has monotonically increasing or decreasing strain.

## 7. The geometric stack remains bounded at this next returned-memory level

Take R_j=4^(-j) and

    f_N(r)=sum_{j=1}^N phi(r/R_j),
    phi>=0, phi smooth and compactly supported in (1,2).

Set h_N=beta4[f_N] using the full g_N of the entire stack, not isolated-shell approximations.

On shell j,

    |f_N|+|r f_N'| <= C_phi,
    |r g_N'| <= C_phi,
    |g_N| <= C_phi j,

and hence

    |h_N|<=C_phi j.

For s on shell i and t on shell j, the exact kernel obeys

    L24(s,t)<= (3/5)t/s       if i<j,
    L24(s,t)<= (5/9)(s/t)^3   if i>j,

with a bounded diagonal term. Integrating the shell lengths gives

    |J24[f_N,h_N]|
       <= C_phi sum_{j=1}^N j^2 R_j^2
       <= C_phi * 272/3375.

The final constant is

    sum_{j>=1}j^2 16^(-j)=272/3375.

Therefore

    sup_N || integral_0^infinity Bstr exp(nu t Delta) R24(a_N)(0)dt || < infinity

for fixed A and nu>0. All cross-shell interactions in this first returned source are included.

This can be strengthened from a signed integrated value to total variation of the free response. On shell j, the same formulae also give

    |r h_N'| <= C_phi j,
    |p_N|+|r p_N'| <= C_phi j.

For the first inequality use the radial g equation and the scale-uniform bounds on r f_N' and r^2 f_N''. For the second, insert |h_N|<=C_phi k on each shell into

    p_N=(1/9)[r^(-7) integral_0^r s^6h_N ds
                         +r^2 integral_r^infinity h_N ds/s^3],
    r p_N'=(1/9)[-7r^(-7) integral_0^r s^6h_N ds
                         +2r^2 integral_r^infinity h_N ds/s^3].

Both sums are geometric; unlike g_N, the l4 inverse attenuates both remote directions. Consequently

    |C[f_N,h_N](r)| <= C_phi j^2  on shell j,
    integral_0^infinity r |C[f_N,h_N](r)|dr
       <= C_phi sum_{j>=1}j^2 R_j^2 < infinity.

The nonnegative H5 heat kernel and its exact integrated lifetime therefore give the stronger result

    integral_0^infinity ||Bstr exp(nu t Delta) R24(a_N)(0)||dt
       <= (2q ||A||/(245nu)) integral_0^infinity r|C[f_N,h_N](r)|dr
       <= C(A,phi)/nu * 272/3375,

uniformly in N. This bound is on the integral of the norm; it does not depend on cancellation between different response times.

This extends the supplied bounded-memory calculation by one actual angular return, including total variation of its freely propagated response. It does not establish a uniform bound after arbitrarily many nonlinear returns or under nonlinear regeneration throughout time.

## 8. The actual time-ordered return coefficient

The snapshot calculation has an exact placement in the source-coherent history expansion. Let omega_epsilon solve NS from epsilon a on a common classical interval. Let E_l(t) be the radial heat semigroup

    exp[nu t(d_r^2+(2/r)d_r-l(l+1)/r^2)].

The first amplitude coefficient is

    w1(t)=E_2(t)f * T_A.

Its emitted degree-four coefficient is

    h4(t)=integral_0^t E_4(t-s) beta4[f_s] ds,
    f_s=E_2(s)f.

The cubic contribution which leaves degree two, propagates in degree four, and returns to degree two is exactly

    R3(t)=integral_0^t exp(nu(t-s)Delta)
                    P DN(w1(s))[h4(s)T4[A]] ds.

Equivalently, its radial coefficient is

    R3(t,r,n)=(4q/49) integral_0^t
          E_2(t-s) C[f_s,h4(s)](r) ds * T_A(n).

Every g_s and p_s in C is the specified finite-energy inverse of f_s and h4(s). The two velocity variations are both present. This is the actual cubic amplitude coefficient in the full NS expansion, not a guessed reduced memory law. Other cubic histories (those remaining in P) are separate terms and are not erased.

The expression can be derived directly by differentiating the mild equation with respect to epsilon. It claims the finite-order coefficient on a common classical interval, not convergence of an infinite series beyond that interval.

## 9. Strain-potential circulation versus actual stretching work

The user's field identity is valid with the smoothing strain potential Pcal=Bstr(-Delta)^(-1), on a class where the inverse is fixed:

    nu S=-D_t Pcal[omega]
          +[u dot grad,Pcal]omega
          +Pcal[(omega dot grad)u].

Set Rcal to the last two terms. If X follows a fluid path and xi=omega/|omega| is defined there, its actual stretching alpha=xi^T S xi satisfies

    nu integral alpha dt
      = [xi^T Pcal[omega] xi]_(initial)
        -[xi^T Pcal[omega] xi]_(final)
        +integral [xi^T Rcal xi+2 (D_t xi)^T Pcal[omega] xi]dt.

The last term is forced by differentiating the common direction as well as the source potential. A signed field circulation cannot be silently identified with the scalar work seen by a rotating vorticity direction, or with a time integral of a norm. Bounded endpoint potential does not remove this source-dependent term.

## 10. RH state retained without another equivalent reformulation

On the distinct shifted nontrivial zero carrier, with multiplicity weights and

    (U_t a)_z=exp(-zt)a_z,  (Ja)_z=a_(-conj z),

normal diagonal multiplication gives

    J U_t J U_t^(-1)=(U_t^*U_t)^(-1)
                    =diag(exp(2t Re z)).

This is the reciprocal orientation of the positive loop J U_t^(-1)J U_t=U_t^*U_t. The supplied holonomy norm and one-packet sinh-square formulas therefore remain correct. They characterize RH but do not establish identity of the loop; the compact-source lifting hypothesis remains a separate actual-source statement.

No new RH conclusion is inferred from positivity of the NS radial kernels. In particular, pointwise kernel positivity, positive semidefiniteness, signed input-output work, and a conserved indefinite form are kept as distinct assertions.

## 11. Result

The l=4 sector is not merely a place where information leaves the l=2 strain observer. It returns under the actual derivative of the common NS source. That first return has an explicit radial differential operator and a closed two-radius heat-memory kernel. For smooth nonnegative starting profiles, its integrated returned contribution can reinforce or oppose the initial strain. The geometric stack has uniformly bounded total free-response variation even at this first-return stage, but the actual causal coefficient retains both ordered time integrals.

This supplies an application-specific term for the requested excursion-return program. It does not replace the full nonlinear history with an invariant five-dimensional model and does not establish a global return bound.
