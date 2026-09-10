# Source-image rigidity for one Weil packet, and exact nonlinear leakage of the Navier–Stokes strain source

Date: 7 September 2026.
Repository inspected: `avikj/metacircular-interaction-prototype`, commit `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope and status

This note proves two source-level results, rather than identifying another abstract realization record with a physical or arithmetic theorem.

For RH, the linear zero-coordinate reflection of one explicit compact packet has a compactly supported source if and only if RH holds. The reconstruction fibre is exactly a singleton or empty. The proof uses the previously fixed packet, an unconditional positive proportion of distinct critical-line zeros, and elementary entire-function uniqueness. Every finite subset of the reflected interpolation constraints nevertheless has a smooth compact-source solution. On a fixed support interval, the exact minimum reconstruction cost diverges if an off-line zero is present.

For NS, the pressure coefficient -2/7 extends from a scalar radial profile times one fixed strain matrix to the complete toroidal degree-two source projection, with arbitrary noncommuting matrix-valued radial profiles. Thus the pressure residual is an explicit bilinear expression in the retained source and its complementary angular part. The actual NS nonlinearity emits a specified degree-four toroidal component from a nontrivial aligned quadrupole shell. The pure quadrupole source is therefore not an invariant state space, even though it has an exact instantaneous pressure formula.

A scope correction is necessary: the pressure-only five-dimensional ODE in earlier messages is conditional. At a finite smooth NS scale, the strain equation also contains the vorticity-square and viscous terms. These are kept explicitly below. No singular-limit affine ODE is asserted from spatial BMO convergence alone.

No proof of RH or of global three-dimensional NS regularity, originality-priority claim, or Agda/Lean build is made. The companion executable performs 147 exact finite/symbolic checks, including all polarized coefficients of the matrix-valued pressure identity.

# I. RH: one explicit source has a singleton-or-empty reflection fibre

## 1. Actual source and spectral maps

Let Sigma be the set of distinct shifted nontrivial zeta zeros z=rho-1/2, with multiplicity m(z), and let theta(z)=-conjugate(z). Put

    (Ef)(z) = integral_R f(x) exp(-z x) dx,
    (Ja)(z) = a(theta(z)).

For the source class C=L2_c(R), use the full sequence space C^Sigma as the immediate codomain. An arbitrary compact L2 source need not have square-summable evaluations. The previously fixed packet does, and on the completed Weil space H=l2(Sigma,m) the same J is a bounded self-adjoint involution.

The retained Weil identity is

    Q_W(f,g) = <Ef, J Eg>,

on its declared test/form domain. The original compact source image and its Hilbert completion must remain distinct.

Let Sigma_0={i gamma in Sigma} be the critical-line subset. The restricted evaluation

    E_0:C -> C^(Sigma_0)

is injective unconditionally. Indeed, the bilateral Laplace transform of a compact L2 source is entire of exponential type. If nonzero, Jensen's formula bounds its number of zeros in disks of radius R by O(R). An unconditional positive proportion of distinct simple critical-line zeta zeros supplies at least c R log R points in Sigma_0. Vanishing at all these points is therefore impossible unless the entire transform, and then the source, is zero.

Only a positive proportion is used; no assertion about the remaining zeros is imported. The primary input is Conrey (1989), whose introduction explicitly states simplicity and critical-line location for a positive proportion.

## 2. General source-image rigidity lemma

For any f,g in C,

    Eg = J Ef  ==>  E_0 g = E_0 f  ==>  g=f.

Consequently

    {g in C : Eg=J Ef}
      = {f} if J Ef=Ef,
      = empty otherwise.

Equivalently, writing X=E(C),

    X intersect JX = {a in X : Ja=a}.

Thus a linear reflection lift that preserves compact source realizability can only act as the identity on those sources. This is an image-side obstruction, not the separated-pair quotient obstruction. It is the diagram shape explicitly distinguished in Section 3 of `DescentObstructionUnified.agda`.

This J is NOT the usual conjugate-linear test involution. For f*(x)=conjugate(f(-x)),

    E(f*)(z) = conjugate((J Ef)(z)).

Forgetting the coefficient conjugation would incorrectly create a compact-source lift of J.

## 3. A single installed packet detects every nonfixed reflection pair

Use the existing packet

    h(x)=exp(-4x)(q*q)(x),    q=4 1_[0,1/4],
    H(z)=16 (1-exp(-(z+4)/4))^2/(z+4)^2.

It is real, supported on [0,1/2], and its transform is nonzero in |Re z|<=1/2. Translate by the already installed action a=log 2:

    p=T_a h,
    F(z)=Ep(z)=exp(-a z) H(z).

For z=sigma+i gamma in the shifted critical strip, put w=exp(-(z+4)/4). Then

    d/dsigma log|F(sigma+i gamma)|
      = -log 2 + Re[ w/(2(1-w)) - 2/(z+4) ].

Since Re(z+4)>0, the last reciprocal term has nonpositive contribution. Also

    |w|<=exp(-7/8)<1/2.

Therefore

    d/dsigma log|F(sigma+i gamma)|
      < -log 2 + 1/2 = -kappa <0,
    kappa=log 2-1/2.

The elementary strict inequalities can be checked without decimal arithmetic: the first three terms of exp(7/8) already exceed 2, and integral_1^2 dx/x>1/2.

For sigma>0 this yields

    |F(sigma+i gamma)| / |F(-sigma+i gamma)|
      <= exp(-2 kappa sigma)<1.

In particular F(z) differs from F(theta z) at EVERY off-line shifted zero, with a definite modulus gap. No dominance or cancellation assumption on a sum over zeros is used.

## 4. Single-packet reconstruction theorem

Define the actual coherent reconstruction fibre

    F_p = {g in L2_c(R) : Eg=J Ep}.

Then

    F_p = {p} under RH,
    F_p = empty under failure of RH.

Proof: under RH, theta fixes every z, so p is the source and E_0 gives uniqueness. Conversely any source g must equal p by the rigidity lemma. Hence F(z)=F(theta z) at every zero. The strict modulus separation just proved excludes every off-line pair.

Thus

    RH <=> J Ep belongs to the compact source image E(L2_c(R)).

The spectral datum J Ep exists unconditionally in the completed Weil space. The theorem asks whether it belongs to the ORIGINAL compact source image. Its existence in the completion is not the desired reconstruction theorem.

This does not replace the quantitative-Goldbach, CRT, receiver, Gram, or inertia maps. It uses their same arithmetic spectral source and the same fixed packet, but gives a different exact reading of the remaining obstruction.

## 5. All finite interpolation fibres remain inhabited

Let z_1,...,z_N be distinct spectral points, let y_1,...,y_N be arbitrary complex values, and fix any nonempty bounded open interval I. Choose psi in Cc-infinity(I), nonnegative and positive on a smaller open interval. Define

    G_ij = integral psi(x) exp(-z_i x) exp(-conjugate(z_j)x) dx.

Distinct exponential functions are linearly independent on an interval, so this Hermitian Gram matrix is positive definite. Solve Gc=y and put

    g(x)=psi(x) sum_j c_j exp(-conjugate(z_j)x).

Then g is smooth, compactly supported in I, and Eg(z_i)=y_i for every i.

In particular EVERY finite subset of the reflected constraints in F_p is solvable, even if F_p itself is empty. This is not a contradiction with finite negative Weil certificates: the diagrams are different. Arbitrary finite interpolation has no uniform source-norm constraint; a negative quadratic-form test has a different feasibility requirement.

## 6. Exact reconstruction cost at one offending zero

Fix a bounded interval I containing supp p, and suppose z_* is off the critical line. Put

    delta = F(theta z_*)-F(z_*) !=0.

Enumerate the distinct critical-line zeros as i gamma_1,i gamma_2,.... In L2(I), with scalar product linear in the first argument, define

    k_z(x)=exp(-conjugate(z)x),
    V_N=span{k_(i gamma_j):1<=j<=N},
    r_N=(I-P_(V_N))k_(z_*).

The critical-line uniqueness theorem implies closure(union V_N)=L2(I), hence ||r_N||_2 ->0. Distinct exponential independence gives r_N!=0 for every finite N.

The minimum-norm correction d satisfying

    Ed(i gamma_j)=0, j<=N,
    Ed(z_*)=delta

is exactly

    d_N = delta r_N / ||r_N||_2^2,
    min ||d||_2 = |delta|/||r_N||_2 -> infinity.

Proof: every feasible d lies in V_N-perp and <d,r_N>=delta. Cauchy-Schwarz gives the bound, with equality at d_N.

Thus, with fixed support, source norms MUST escape to infinity when finite reflected data are made coherent with more of the critical-line source readings. This is the precise compactness obstruction to turning the finite fibres into a global compact source.

# II. NS: the complete toroidal strain source and its pressure

## 7. Declared smooth source class

Work on R3 with smooth divergence-free velocities whose vorticity is compactly supported, or with decay and differentiability sufficient for the displayed Biot-Savart, pressure, and radial boundary operations. Fix an observation center, written as zero. These are finite smooth-source identities. Periodic global kernels require their own retained outer correction and are not silently substituted here.

For A in Sym_0(3), put T_A(n)=n cross (A n). Let F(r) in Sym_0(3) be the exact toroidal degree-two projection coefficient of omega(rn):

    integral_S2 omega(rn) dot T_A(n) dOmega
      = (4pi/5) tr(F(r)A).

Then

    omega_2(rn)=n cross(F(r)n),
    S_u(0)=-(3/5) integral_0^infinity F(r) dr/r.

The projected field is divergence-free. For a smooth source, F(r)=O(r^2) near zero. Define

    G(r)=(1/5)[r^(-5) integral_0^r s^4 F(s) ds
                         + integral_r^infinity F(s) ds/s].

Entrywise,

    G''+(6/r)G'=-F/r^2.

Set

    psi_2(x)=x cross(G(|x|)x),
    u_2=curl psi_2.

Then curl u_2=omega_2 and u_2 is the finite-energy Biot-Savart velocity of the projected vorticity. Moreover

    S_(u_2)(0)=-3G(0)=S_u(0).

For u_perp=u-u_2, the central strain is zero. Thus this is a linear source decomposition, not a decomposition of independently chosen strain and pressure values.

## 8. Full matrix pressure theorem

For any source v write

    H[v] = (Hess (-Delta)^(-1) tr((grad v)^2))(0)_0.

The subscript 0 means trace-free. This is the deviatoric physical pressure Hessian because -Delta p=tr((grad v)^2).

The following identity holds with ARBITRARY matrix-valued radial profiles G(r) in Sym_0(3):

    H[u_2] = -(2/7)(S_u(0)^2)_0.

In particular G(r), G'(r), and G''(r) need not commute; radial changes of eigenframe are fully retained.

### Explicit calculation

At a radius r put V=rG', W=r^2G'', and let n be a unit vector. Direct differentiation gives

    L=grad u_2(rn)
      = -3G-V -(4V+W)n n^T
        +(n^T V n)I +(n^T(W-V)n)n n^T +2n(Vn)^T.

For X circ Y=(XY+YX)/2, exact spherical moments give

    (1/4pi) integral_S2 (3nn^T-I) tr(L^2) dOmega
      = (12/35)[18G circ V +3G circ W+2V^2-V circ W]_0.

This is a quadratic identity in the 15 independent entries of G,V,W. The script verifies every diagonal and mixed polarized coefficient, not a random sample of matrices.

The pressure representation is the integral of this expression against dr/r. Its integrand is an exact derivative:

    18G circ G' +3rG circ G''+2r(G')^2-r^2G' circ G''
      = d/dr[(15/2)G^2+3rG circ G'-(r^2/2)(G')^2].

The outer boundary vanishes under the declared decay, and regularity removes all inner derivative terms. Hence

    H[u_2]=-(18/7)(G(0)^2)_0=-(2/7)(S_u(0)^2)_0.

This extends the earlier fixed-A radial calculation to the whole linear toroidal degree-two projection.

## 9. The actual pressure residual is a source cross-effect

Polarize H by

    H(v,w)=1/2[H[v+w]-H[v]-H[w]].

It is the Hessian reading of the bilinear pressure source tr((grad v)(grad w)). Therefore

    K[u]:=H[u]+(2/7)(S_u(0)^2)_0
          = 2H(u_2,u_perp)+H[u_perp].

This is the exact residual source map. Neither the radial orientation of the degree-two source nor any of its radial amplitudes has been lost. The remaining pressure is supplied only by its complementary source and the cross-interaction with that source.

No sign is claimed for this bilinear residual.

# III. The actual nonlinear action forces degree four

## 10. Aligned radial quadrupole and its emitted component

Let A be a nonzero real symmetric trace-free matrix. Let f be a nonzero, nonnegative smooth radial bump supported in an annulus, and take

    omega(rn)=f(r)T_A(n),
    u=curl[g(r) x cross(Ax)],
    g''+6g'/r=-f/r^2.

The finite-energy inverse has

    g(r)=(1/5)[r^(-5) integral_0^r s^4 f(s) ds
                       + integral_r^infinity f(s) ds/s]>0.

Write

    B=(A^2)_0,  s_A(n)=n^T A n,  q=tr(A^2),
    Y_4(n)=s_A(n)^2-(4/7)n^T B n-(2/15)q,
    T_4[A](n)=(1/4)n cross grad_S Y_4(n)
              =s_A(n)T_A(n)-(2/7)T_B(n).

The polynomial producing Y_4 is a homogeneous harmonic of degree four. T_4[A] is orthogonal to every toroidal degree-two field, and

    (1/4pi) integral_S2 |T_4[A]|^2 dOmega
      = (4/245)(tr A^2)^2>0.

The exact nonlinear vorticity source is

    curl(u cross omega)
       = beta_2(r) T_B(n) + beta_4(r) T_4[A](n),

where

    beta_2=(6/7)(5gf+2r g'f+r g f'),
    beta_4=3r g f'-6gf-r g'f.

One direct derivation writes

    u=-(3g+rg')Ax +(g'/r)(x^T A x)x,

then computes (omega dot grad)u-(u dot grad)omega. Before angular decomposition it is

    (6gf+2r g'f)T_B
      +(3r g f'-6gf-r g'f)s_A T_A.

The identity s_A T_A=(2/7)T_B+T_4[A] gives the displayed decomposition.

Viscosity preserves the degree-two angular sector:

    Delta(f(r)T_A(n))=(f''+2f'/r-6f/r^2)T_A(n).

Thus on the actual local classical NS continuation of this initial datum,

    P_(4,tor) partial_t omega |_(t=0) = beta_4 T_4[A].

## 11. Strict source-space non-invariance

The coefficient beta_4 cannot vanish identically for the declared nonnegative nonzero compact shell. On a connected interval where f>0, its vanishing would imply

    f'/f = 2/r + g'/(3g),
    f(r)=C r^2 g(r)^(1/3).

But g is strictly positive at every finite radius. At a finite boundary of that f-component, continuity and compact support force f to zero, whereas the displayed expression has a nonzero limit if C!=0. Contradiction.

Consequently

    ||P_(4,tor) partial_t omega(0)||_2^2
      = (16pi/245)(tr A^2)^2 integral_0^infinity r^2 beta_4(r)^2 dr
      >0.

A nontrivial aligned toroidal-quadrupole shell immediately leaves the pure degree-two source space under the true NS generator. This is an exact tangent-image obstruction, not a claim that an arbitrary pressure matrix can be selected.

The conclusion on the annulus is unchanged after adding a smooth compactly supported rotating velocity core entirely inside the inner radius: both that added velocity and its vorticity vanish on the annulus, so the annular nonlinear calculation is identical. Such a core can retain a nonzero normalized central vorticity value. This still describes genuine smooth initial data and their actual first continuations; it does not assemble them into a single blow-up trajectory.

The linear invariant-closure theorem in the repo is not being misapplied to a quadratic vector field. Here strict enlargement is proved directly by the nonzero projected derivative. A linear/Krylov realization would need its own declared lift.

## 12. Consistency with the instantaneous 5/7 strain drift

For the source-free core, S=-3g_0 A, omega=0, and Delta S=0. Integrating the degree-two nonlinear coefficient gives

    S'(0)=-(3/5) integral beta_2 dr/r B
         =-(45/7)g_0^2 B
         =-(5/7)(S^2)_0.

This agrees with the pressure theorem. But degree four is simultaneously emitted elsewhere. Thus the instantaneous 5/7 law does NOT prove that the source remains on a five-dimensional invariant manifold.

# IV. The correct residual for actual NS strain dynamics

## 13. Retain rotation and viscosity

Let S=sym grad u, Omega=skew grad u, and omega=curl u. Along the actual material derivative,

    D_t S=-(S^2)_0-(Omega^2)_0-H[u]+nu Delta S,
    (Omega^2)_0=(1/4)(omega tensor omega)_0.

Substituting the exact toroidal pressure split gives

    D_t S=-(5/7)(S^2)_0-K[u]
                 -(1/4)(omega tensor omega)_0+nu Delta S.

Define the full source-derived correction

    K_eff = K[u]+(1/4)(omega tensor omega)_0-nu Delta S.

Then the exact finite-scale law is

    D_t S=-(5/7)(S^2)_0-K_eff.

For q=tr S^2 and r=tr S^3,

    D_t r=-(5/14)q^2-3tr(S^2 K_eff).

The prior two spectral/three orientation decomposition on q^3-6r^2>0 can be applied to K_eff. Applied to pressure K alone, it omits actual NS terms unless the particular limiting procedure separately proves they vanish or moves them into another retained coordinate.

Therefore a nonzero periodic strain history with zero commuting/spectral part of K_eff is impossible. Recurrence forces a compensating component of the COMPLETE correction, not pressure alone. The pressure-only recurrence inference in the previous prose must remain conditional.

## 14. Finite renormalization and the unclaimed singular step

At a fixed center, parabolic rescaling

    u_rho(x,t)=rho u(rho x,rho^2 t)

carries S and omega with weight rho^2, H, K, K_eff with weight rho^4, and curl(u cross omega) with weight rho^4. The toroidal projection, bilinear pressure split, and emitted degree-four component commute with this finite coordinate change.

A time-dependent scale or center requires its exact extra transport terms; they may not be dropped. Passing to a singular witness additionally requires convergence of pressure, source products, and the chosen time history. Spatial BMO compactness alone does not supply the needed temporal convergence or justify differentiating the limiting affine coordinate.

The results above therefore add exact common-ancestry constraints at every finite stage, without claiming an ancient or recurrent limit has already been constructed.

# V. Verification and theorem-graph ledger

Repository sources read at the pinned commit:

- `formal/cubical/theorems/physics/QRClosure_TheRestrictedEulerQuotientClosesByRingIdentityAndThePressureHessianCouplingDoesNotDescendThroughIt.agda`. Algebraic pressure/viscous correction, not a PDE continuation theorem.
- `formal/cubical/theorems/physics/DescentObstructionUnified.agda`. Separated-pair descent and missed-image obstruction are distinct diagrams.
- `formal/lean/Pairfield/InvariantCorrectiveClosure.lean`. Linear corrective closure with explicit invariance hypotheses.

Saved source inputs retained:

- Comprehensive conversation handoff, 6 September 2026.
- `proof_note(1).md`, fixed compact Weil packet, actual evaluation map, and critical-line uniqueness argument.
- `proof_note(3).md`, completed reflection form, compact-source density, and affine source completion.
- `source_preserving_spectral_escape/proof_note.md`, exact arithmetic source interpolation and finite-scale logarithmic strain currents.

Primary background:

- J. B. Conrey, More than two fifths of the zeros of the Riemann zeta function are on the critical line, J. reine angew. Math. 399 (1989), 1–26, DOI 10.1515/crll.1989.399.1. Only the unconditional positive proportion of distinct simple critical-line zeros is needed.
- M. Suzuki, Weil's quadratic form via the screw function, arXiv:2606.09096. The actual Weil reflection/explicit-formula background is retained; no conjectural limit is used.
- M. Wilczek and C. Meneveau, Pressure Hessian and viscous contributions to velocity gradient statistics based on Gaussian random fields, arXiv:1401.3351. Relevant background for the familiar statistical -2/7 coefficient; not used as a proof of the deterministic source-projection identity derived here.

`checks.py` is an actual rerunnable file, not a placeholder. Its 147 controls include all 120 polarized pressure coefficients; the matrix boundary telescope; the full nonlinear l2/l4 split on arbitrary eigenvalues; orthogonality to every l2 coordinate; exact universal harmonic norms; the true rotation/viscous strain correction; and the packet logarithmic derivative. No purported off-critical zeta zeros are evaluated.

The unresolved conclusions are stated precisely: no compact source for the reflected packet has been constructed without RH, and no incompatibility has been proved for every full NS blow-up ancestry carrying the emitted complementary modes. These source-level statements identify concrete image and invariance constraints; they do not by themselves settle either global theorem.
