# Reconstructed record: reflection-scale holonomy and nonlinear toroidal memory

Provenance: mathematical reconstruction of the long visible user-supplied synthesis, comparing `168ea8e240524f898af4b0e9cf70297c38422f08`. This is not a byte-exact original attachment. The canonical handoff incorporates subsequent corrections, especially signed radial spectra, actual directional work and first-return signs.

## RH loop, actual completed Weil source

On H=l2(Sigma,m), theta z=-conj z, J a(z)=a(theta z), QW(a,b)=<a,Jb>, and U_t a(z)=exp(-zt)a(z), retain

    U_t* J U_t=J.

The loop is

    H_t=J U_t J U_t^-1=diag(exp(2t Re z)).

On z=sigma+i gamma and theta z=-sigma+i gamma it is diag(exp(2sigma t),exp(-2sigma t)). Therefore RH iff H_t=I for one nonzero t; the group law and reflection give H_(t+s)=H_t H_s and J H_t J=H_t^-1.

With delta=sup|Re z|, for t>0,

    ||H_t||=exp(2t delta),
    delta=(1/(2t))log||H_t||.

Its derivative at zero is 2diag(Re z). A fixed faithful packet has H(z)!=0 at every actual zero, so H_t Eh=Eh iff RH. Its positive two-sided norm defect is

    ||U_t Eh||^2+||U_-t Eh||^2-2||Eh||^2
       =4 sum_z m(z)|H(z)|^2 sinh^2(t Re z).

This is positive and zero exactly on RH. The compact-source image theorem says the reflected specified packet has a compact lift iff RH. Completion-level reflection existence is not compact-source realizability. The opposite cycle orientation is the reciprocal positive operator.

## Strain potential coboundary

Let L=-Delta, B omega=S be Biot-Savart strain, and

    Pi_pot[omega]=B L^-1 omega=L^-1 S.

The actual vorticity equation omega_t=N-nu L omega, N=curl(u cross omega), gives

    partial_t Pi_pot[omega]=Pi_pot[N]-nu S.

Thus

    nu integral_(t0)^(t1) S(x,t)dt
       =Pi_pot[omega](x,t0)-Pi_pot[omega](x,t1)
        + integral Pi_pot[N](x,t)dt.

The toroidal coordinate is

    Pi_pot[omega](0)=-(1/10) integral_0^infinity r A_omega(r)dr.

Materially,

    nu S=-D_t Pi_pot[omega]+R,
    R=[u dot grad,Pi_pot]omega+Pi_pot[(omega dot grad)u].

Along a specified particle path, integrating keeps endpoint potential plus actual nonlinear residual. For directional stretching, later correction adds `2(D_t xi)^T Pi_pot xi` after contracting with xi; a closed potential alone is not a closed stretching-work loop.

Near/far Newton-kernel estimates give

    ||Pi_pot[omega]||infty
       <=C ||u||2^(4/5)||omega||infty^(1/5).

At the energy/vorticity chart the endpoint potential is uniformly bounded. This does not bound the nonlinear residual circulation.

## First nonlinear toroidal memory

For omega=f(r)T_A(n), A symmetric trace free,

    N=beta2 T_(A^2)_0+beta4 T4[A],
    beta2=(6/7)(5gf+2r g'f+r g f'),
    g''+6g'/r=-f/r^2.

Heat preserves angular degree. The future linear central-strain memory of this instantaneous nonlinear source sees beta2:

    integral_0^infinity B e^(nu t Delta)N(0)dt
      =-(1/(10nu)) integral r beta2(r)dr (A^2)_0.

Integrating by parts gives

    integral r beta2 dr=(6/7) I[f],
    I[f]=integral (9r g^2-r^3 g'^2)dr.

For a unit radial atom at s,

    g_s(r)=(1/5)s^-1 for r<s,
             (1/5)s^4 r^-5 for r>s.

The polarized radial form is

    I[f]=integral integral f(s)f(t)K(s,t)dsdt,
    K(s,t)=min(s,t)/(10 max(s,t))
       * [3-2(min(s,t)/max(s,t))^3].

K(s,t)>0, so nonzero nonnegative f implies I[f]>0 and the integrated source memory is

    -(3/(35nu)) I[f](A^2)_0.

Later exact signed-spectrum work proves that K is not a positive-semidefinite kernel on signed f. The original nonnegative-cone result remains valid, but emitted beta2/beta4 are signed and cannot be fed into it as positive inputs without an additional theorem.

## Geometric shell stack

For R_j=4^-j and nonnegative smooth phi supported in (1,2), let

    f_N(r)=sum_(j=1)^N phi(r/R_j),
    c_phi=integral_1^2 phi(q)dq/q.

Then S_N(0)=-(3/5)N c_phi A. Its instantaneous pure quadrupole feedback is

    S_N'(0)|pure=-(5/7)(S_N^2)_0
               =-(9/35)N^2 c_phi^2(A^2)_0.

Yet K(s,t)<=3min(s,t)/(10max(s,t)), so all self and cross-shell pairs satisfy

    I[f_N]<=C_phi sum_j j R_j^2
           <=C_phi (16/225).

Thus instantaneous strain grows like N, instantaneous quadratic feedback like N^2, but the complete future freely propagated memory of that snapshot nonlinear injection stays bounded independently of N. This is a genuine static-source calculation, not a conclusion about full future nonlinear regeneration.

The next actual first-return source is `P2 DN(a)[P4 N(a)]`. Its computed formula and all-time free response are in [S15]; the full source-coherent evaluator and midpoint storage identities are in [S17–S19].
