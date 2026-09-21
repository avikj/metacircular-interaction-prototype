# Work balance and toroidal quadrupole selection

Date: 2026-09-07.
Repository source read at 168ea8e240524f898af4b0e9cf70297c38422f08.

## Scope

This note changes the mathematical description to passive input-output systems and spherical multipole analysis. It proves a finite-energy vorticity-shell separation result and the exact angular selection rule for central strain. It also translates the established fixed-receiver RH criterion into causal passivity. It does not prove RH or global Navier–Stokes regularity. No Agda/Lean build or numerical PDE evolution is claimed. The separate script checks finite polynomial identities; the infinite and PDE arguments below are analytic proofs.

## 1. Exactly which spherical polarization generates central strain

On R^3 use
u(x)=(4 pi)^(-1) integral omega(y) cross (x-y) / |x-y|^3 dy.
Assume initially smooth sufficiently decaying divergence-free vorticity and the corresponding finite-energy velocity. The derivative and angular identities may also be used with radial cutoffs on individual shells.

Writing y=r n, n in S^2, differentiation of Biot–Savart and symmetrization give
S(0) = (3/(8 pi)) p.v. integral_0^infinity dr/r integral_S2
[n tensor (n cross omega(r n)) + (n cross omega(r n)) tensor n] dOmega(n).

For A a real trace-free symmetric 3x3 matrix define
T_A(n)=n cross (A n).
This is a toroidal degree-two vector spherical harmonic:
T_A=(1/2) n cross grad_S(n^T A n).
It is tangential and has zero surface divergence.

For any vector field f on S^2, write
C(f)=integral_S2 [n tensor (n cross f)+(n cross f) tensor n] dOmega.
Then C(f) is symmetric trace-free, and
A:C(f)=-2 integral_S2 f dot T_A dOmega.

Consequently the central strain depends only on the orthogonal projection of each shell's vorticity onto the five-dimensional space {T_A:A in Sym_0(3)}. Other angular polarizations do not contribute to this instantaneous central strain reading.

The normalization is exact:
integral_S2 T_A dot T_B dOmega=(4 pi/5) tr(A B).
Thus the projection coefficient A_r is determined by
integral_S2 omega(r n) dot T_B(n) dOmega=(4 pi/5) tr(A_r B)
for all B in Sym_0(3). Equivalently A_r=-(5/(8 pi)) C(omega(r dot)).
The strain reconstruction is
S(0)=-(3/5) p.v. integral_0^infinity A_r dr/r.

No autonomous evolution law for the five shell coefficients is asserted. Other angular sectors can affect their future evolution.

## 2. All gradient moments can vanish while central strain is prescribed

Fix f in C_c^infinity((R,2R)), R>0, and A in Sym_0(3), and set
omega_A(r n)=f(r) T_A(n).
Equivalently omega_A(x)=f(|x|)|x|^(-2) x cross (A x).

This field is smooth compactly supported and divergence-free. Indeed x cross (A x) is tangent to spheres, and its Cartesian divergence vanishes because A is symmetric. Multiplication by a radial function preserves divergence-free-ness.

For every radius rho>0 and every smooth scalar test H,
integral_Brho omega_A dot grad H dx
= integral_boundary_Brho H omega_A dot n dS
  - integral_Brho H div omega_A dx
=0.

In particular EVERY harmonic-gradient moment is zero on EVERY concentric ball, not merely asymptotically or after selecting a favorable radius.

Nevertheless the central strain is
S_A(0)=-(3/5) A integral_0^infinity f(r) dr/r.
To check the coefficient, use
n cross (n cross A n)=n(n^T A n)-A n
and the exact spherical second and fourth moments. The angular tensor integral is
integral_S2 [n tensor (n cross T_A)+(n cross T_A) tensor n] dOmega
=-(8 pi/5) A.

Taking a nonzero radial integral realizes any prescribed trace-free symmetric central strain by selecting A.

The corresponding velocity u_A=curl(-Delta)^(-1)omega_A is smooth and finite-energy. Its vector potential has pure degree-two angular dependence. Inside the source-free ball |x|<R,
(-Delta)^(-1)omega_A(x)
=(1/5)(integral f(r) dr/r) x cross A x.
Since curl(x cross A x)=-3 A x,
u_A(x)=-(3/5)(integral f(r) dr/r) A x
there. In particular u_A(0)=0.

Outside the compact vorticity support the vector potential decays as O(|x|^-3) and the velocity as O(|x|^-4); finite energy follows. The compactly supported vorticity, rather than compact velocity, is the declared source here.

This proves an exact non-factorization: the complete family of centered-ball gradient moments does not determine central strain, even among smooth finite-energy sources.

## 3. Separation of actual NS initial continuations

Let v be smooth compactly supported divergence-free initial velocity whose vorticity is the constant nonzero vector omega_0 near the origin. Choose R beyond that neighborhood. Compare the two NS initial velocities v and v+u_A, each of which has a local classical evolution.

Their vorticities agree near the origin, and all centered-ball gradient moments of their vorticities agree because the added shell has every such moment zero. The added velocity vanishes at the origin, so their initial velocity values agree there too.

The actual vorticity equation is
partial_t omega=-(u dot grad)omega+(omega dot grad)u+nu Delta omega.
At time zero and the origin, the derivative difference is precisely
partial_t omega_(v+u_A)-partial_t omega_v
= S_A(0) omega_0
=-(3/5)(integral f(r) dr/r) A omega_0.
This is nonzero when A omega_0 != 0.

These are separate admissible initial-value problems. No common blow-up trajectory is constructed. The conclusion is that the proposed moment measurements are insufficient to reconstruct even this actual first continuation.

For f_R(r)=phi(r/R) with phi fixed in C_c^infinity((1,2)), the central strain and global vorticity supremum are independent of R up to the fixed amplitude A. The velocities scale as u_R(x)=R u_1(x/R), and their kinetic energies scale as R^5. They are thus consistent with the earlier energy-only affine-strain threshold. Above that scale the full vorticity reconstruction includes the shell; replacing it by its gradient moments would erase the shell's entire strain contribution.

## 4. An admissibility correction for higher remote jets

For a remote vorticity source with ||omega||_infinity<=1, supported outside B_R, an m-th velocity derivative, m>=2, obeys
|nabla^m u_far(0)|
<= C_m integral_R^infinity r^2 r^(-m-2) dr
= C_m/(m-1) R^(1-m).

Thus any R tending to infinity suppresses higher remote velocity jets under the global bounded-vorticity condition. The strain m=1 is the borderline logarithmic case.

The earlier cutoff realization of a fixed degree-m harmonic velocity jet has vorticity magnitude proportional to R^(m-1). For m>=2 it violates the global normalized bound as R grows. Its energy-only sharpness remains valid in that weaker class, but must not be called sharp for the full vorticity-normalized blow-up class.

## 5. The arithmetic receiver as a passive one-port

Assume the established receiver data: a continuous real even function Z with M_0=Z(0)>0; its received spectral expansion has nonzero weights at every shifted zeta zero; the fixed-receiver theorem states RH iff |Z(t)|<=M_0 for every t, equivalently iff Z is positive definite.

For compactly supported smooth input f define the zero-state causal output
y_f(t)=integral_-infinity^t Z(t-r) f(r) dr.
The net supplied work is
W(f)=Re integral_R conjugate(f(t)) y_f(t) dt.

Because Z is real and even,
2 W(f)=integral_R integral_R conjugate(f(t)) Z(t-r) f(r) dr dt.
All integrations are over a compact input square; no stability hypothesis is needed merely to define the work.

Therefore
RH iff W(f)>=0 for every compact smooth input f.

For the converse it is enough to approximate two unit-area impulses at times 0 and t, with the relative sign chosen to minimize work. The work tends to M_0-|Z(t)|. Thus passivity forces the established two-point RH inequality.

Under RH, Z(t)=sum_gamma c_gamma exp(i gamma t), with c_gamma=m_gamma G(i gamma)>0 and sum c_gamma=M_0. The oscillator realization
a_gamma'=i gamma a_gamma+f, a_gamma(-infinity)=0,
y=sum_gamma c_gamma a_gamma
has nonnegative storage
E=(1/2)sum_gamma c_gamma |a_gamma|^2
and exact supply identity
E'=Re(conjugate(f)y).
This storage representation is conditional on RH; it is not an arithmetic construction proving RH.

The Laplace transfer function, initially for Re p>1/2, is
F(p)=integral_0^infinity exp(-pt)Z(t)dt
=sum_z m_z G(z)/(p-z).
Under RH it extends to Re p>0 and Re F(p)>0. Conversely a holomorphic extension to the whole right half-plane excludes any shifted zero there, by the nonzero residues, and functional-equation reflection gives RH.

## 6. Why every positive damped-output tower can coexist with activity

For any real continuous impulse response Z of exponential type, all kernels
G_(n,s)(T,U)=integral_0^infinity t^n exp(-2st)Z(T+t)Z(U+t)dt
are positive semidefinite whenever convergent. That is squared-output positivity, not passivity.

Explicit control: Z_a(t)=cosh(a t), a>0.
Every above kernel is finite and positive for s>a. Yet opposite unit impulses at 0,T have limiting supplied work
1-cosh(aT)<0.
Thus an active hyperbolic system passes every convergent squared-output positivity test.

This example does not refute the arithmetic RH criterion. It proves that positivity supplied solely by damped squaring cannot yield the required signed supply inequality. The arithmetic content must enter before that sign is discarded.

## Conclusions

The NS calculation identifies the precise angular component that determines central strain: the toroidal quadrupole. It gives exact smooth finite-energy examples in which all harmonic-gradient measurements vanish while this component and the actual initial stretching are nonzero.

The RH translation identifies the signed quantity whose positivity is required: input-output work, not output squared. Its all-input passivity is the established fixed-receiver criterion in network language. No proof of the arithmetic supply inequality is supplied.

Primary background:
J. C. Willems, "Dissipative dynamical systems, Part I", 1972.
P. Constantin and C. Fefferman, "Direction of Vorticity and the Problem of Global Regularity for the Navier–Stokes Equations", 1993.
J. Novak, J.-L. Cornou, N. Vasset, "A spectral method for the wave equation of divergence-free vectors and symmetric tensors inside a sphere", arXiv:0905.2048.
