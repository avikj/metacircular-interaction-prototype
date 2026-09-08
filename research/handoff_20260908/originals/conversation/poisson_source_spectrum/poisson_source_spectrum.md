# Exact Poisson-source spectrum and normalization of the common-noise lift

6 September 2026

## Scope

This note proves an operator-norm and essential-spectrum statement for the canonical incompressible-fluid Poisson tensor, computes the identity defect of the common-noise tangent lift, and constructs its exact unital normalization. The stochastic statements hold on a closed interval on which the underlying periodic Navier–Stokes solution is smooth. They do not establish general global regularity or the Riemann hypothesis. No originality-priority claim or proof-assistant compilation is made.

## 1. The canonical source representation is isometric in maximum vorticity

Let H be the complexification of the mean-zero divergence-free L2 vector fields on the flat three-torus. Let P be the orthogonal Leray projection onto H. For a real smooth periodic divergence-free velocity u, define

    omega = curl u,
    Pi_u a = P(a cross omega),
    M = ||omega||_infinity.

The operator Pi_u is bounded and skew-adjoint. In fact,

    ||Pi_u||_(H -> H) = M,
    spectrum_essential(i Pi_u) = [-M,M].

Consequently

    ||Pi_u - Pi_v|| = ||curl(u-v)||_infinity.

The restriction to mean-zero velocities makes this representation injective.

### Proof

The pointwise cross-product inequality and contractivity of P give

    ||Pi_u a||_2 <= M ||a||_2.

For a unit direction n, write P_n = I - n n^T. The transverse principal symbol is

    a |-> P_n(a cross omega(x)),       a perpendicular to n.

Decompose omega into its parallel and perpendicular components relative to n. The cross product of the perpendicular component with a is parallel to n and is removed by P_n. Therefore

    P_n(a cross omega(x)) = (omega(x) dot n) (a cross n).

On the complexified transverse plane, multiplication of this operator by i has eigenvalues +omega(x) dot n and -omega(x) dot n.

Here is an explicit localization argument for the essential-spectrum assertion. Choose x0 where |omega(x0)|=M. For any lambda in [-M,M], choose a direction n and a transverse complex polarization b so that

    i P_n(b cross omega(x0)) = lambda b.

If necessary approximate n by rational directions and adjust lambda by a quantity tending to zero. Choose a smooth unit-L2 bump chi_l supported in a shrinking ball about x0. Modulate chi_l b by a periodic plane wave in the chosen rational direction, and project with P. For each fixed bump, let the modulation frequency tend to infinity before taking the next bump. The Fourier multiplier of P at a translated Fourier frequency converges to P_n. Dominated convergence of the Fourier coefficient square sum proves that both projections occurring in Pi_u are asymptotic to their transverse symbols. Shrinking the bump replaces omega(x) by omega(x0), with error at most its modulus of continuity on the bump.

The resulting normalized fields a_l satisfy

    a_l weakly -> 0,
    ||(i Pi_u - lambda I)a_l||_2 -> 0.

Weak convergence follows from shrinking support for the unprojected packets and their vanishing L2 projection error. These are singular Weyl sequences. Thus every lambda in [-M,M] belongs to the essential spectrum. The upper norm bound excludes spectrum outside this interval, proving both assertions. Linearity in u proves the distance identity.

The argument detects the exact maximum-vorticity quantity. It does not supply a bound for its evolution.

## 2. Common-noise lift on a smooth interval

Fix a smooth unforced NS solution u on [s,T], with viscosity nu>0. Put

    N(u) = -P((u dot grad)u),
    J_u = DN(u),
    L_u = J_u + nu Delta,
    D_j = partial_j.

The source-dependent Poisson naturality and translation identities are

    Pi_(N(u)) = J_u Pi_u + Pi_u J_u*,
    [D_j,Pi_u] = Pi_(D_j u).

They imply, on the smooth core,

    partial_t Pi_u = G_u(Pi_u),
    G_u(Q) = L_u Q + Q L_u* + 2 nu sum_j D_j Q D_j*.

Here D_j*=-D_j. Define R(t,s) by

    dR = L_u R dt + sqrt(2 nu) sum_j D_j R dW_j,
    R(s,s)=I.

Equivalently its Stratonovich drift is J_u. One concrete construction is

    R = T_b Y,
    b_t = sqrt(2 nu)(W_t-W_s),
    partial_t Y = T_(-b) J_u T_b Y,

where T_b is spatial translation. This is a pathwise linear transport equation with smooth spatial coefficients and time-continuous translations. Its L2 energy estimates give deterministic bounds for R and R inverse on [s,T]. Higher Sobolev bounds justify differentiation and stochastic pairings on smooth test fields.

The completely positive map

    E_(t,s)(Q) = expectation[R(t,s) Q R(t,s)*]

is well-defined weakly for every bounded Q on H. Its generator is G_u, interpreted on the smooth core. Moreover,

    expectation[R(t,s)] = V(t,s),
    E_(t,s)(Pi_(u(s))) = Pi_(u(t)),

where V is the actual NS tangent propagator. The second equality follows by matching the weak generator and initial data; equivalently, test against finite-rank smooth terminal operators propagated backward by the dual random evolution. This avoids invoking a bounded inverse of the parabolic propagator V.

## 3. The exact identity defect

Define the strain S_u=(grad u+grad u^T)/2. For divergence-free test fields,

    J_u a = -P((u dot grad)a + (a dot grad)u),
    J_u* a = P((u dot grad)a - (grad u)^T a).

Hence

    J_u+J_u* = -2 P S_u P.

At Q=I, the diffusion and common-noise quadratic variation cancel:

    G_u(I)
      = J_u+J_u* + 2 nu Delta + 2 nu sum_j D_j D_j*
      = -2 P S_u P.

Thus the positive map is not generally unital. If it is unital for every subinterval [s,t], differentiating at t=s gives P S_(u(s)) P=0 for every s. Localized transverse wave packets then give a^T S_(u(s))(x) a=0 for every real vector a: choose a frequency direction perpendicular to a. Therefore S_u=0. Periodicity and incompressibility imply

    integral |grad u|^2 = 2 integral |S_u|^2 = 0,

so u is spatially constant. Conversely a spatially constant unforced flow gives a translation propagator and the map is unital.

Therefore the whole two-parameter tangent channel is unital exactly for spatially constant flows. This assertion is about unitality on every subinterval, not an isolated endpoint equality.

## 4. Exact normalization and positive block transport

Let

    Q_(t,s) = E_(t,s)(I) = expectation[R R*].

The pathwise inverse bound implies Q_(t,s)>=c I for some c>0 on the fixed smooth interval. Define

    Psi_(t,s)(A) = Q_(-1/2) E_(t,s)(A) Q_(-1/2).

This map is completely positive and unital. Since i Pi_(u(s)) is self-adjoint with norm M_s,

    -M_s I <= i Pi_(u(s)) <= M_s I.

Transporting and normalizing proves

    ||Q_(-1/2) Pi_(u(t)) Q_(-1/2)|| <= M_s.

Equivalently, the positive initial block

    [ M_s I       i Pi_(u(s)) ]
    [ i Pi_(u(s)) M_s I       ]

is transported to

    [ M_s Q       i Pi_(u(t)) ]
    [ i Pi_(u(t)) M_s Q       ].

The source reconstruction remains exact:

    Pi_(u(t)) = Q_(1/2) Psi_(t,s)(Pi_(u(s))) Q_(1/2).

The normalized source is controlled in the transported order unit. This does not justify deleting Q or declaring a physical-norm contraction. In particular, a bound for Q may be substantially stronger than what is needed to control the contracted source expectation.

## 5. An exact globally smooth shear separates auxiliary amplification from source decay

Use normalized integration on the torus of side 2 pi. For A>0,

    u(t,x,y,z) = A exp(-nu t) sin(y) e1,
    p=0

is an exact globally smooth unforced NS solution. Its maximum vorticity and Poisson norm are

    ||curl u(t)||_infinity = ||Pi_(u(t))|| = A exp(-nu t).

Choose the mean-zero divergence-free test field

    v = (-sin(x+y), sin(x)+sin(x+y), 0).

Direct integration gives

    ||v||_2^2 = 3/2,
    ||grad v||_2^2 = 5/2,
    integral v^T S_(u(t)) v = -A exp(-nu t)/4.

Therefore

    d/dt <v,Q_(t,0)v>|_(t=0) = A/2 > 0.

The auxiliary positive order unit increases in this direction although the physical Poisson norm decreases exactly. The actual deterministic tangent also has

    d/dt ||V(t,0)v||_2^2|_(t=0) = A/2 - 5 nu,

which is positive for A>10 nu despite global smoothness of the base flow.

Thus replacing expectation[R Pi_initial R*] by a generic amplification estimate for expectation[R R*] can discard relevant cancellation even on an exactly solvable NS solution.

## 6. Algebraic stabilizer of the source identity

For any bounded self-adjoint H, B=Pi_u H satisfies

    B Pi_u + Pi_u B* = 0.

Accordingly, the Poisson-source covariance equation alone is insensitive to additions of this form to its linear generator. The actual tangent is fixed independently by differentiating N(u). The common-source identity and the specification of the true tangent must both be retained.

## Verification and ancestry

`check_identities.py` executes nine exact symbolic controls and computes exact rational finite-Fourier norm witnesses for the shear source. The displayed decimal norm ratios are square roots of rational values. These checks are not substitutes for the localization argument, stochastic domain argument, or a global continuation proof.

Classical ancestry: Peter Constantin and Gautam Iyer, *A stochastic Lagrangian representation of the three-dimensional incompressible Navier–Stokes equations*, Communications on Pure and Applied Mathematics 61 (2008), 330–345, DOI 10.1002/cpa.20192. The common-noise lift here uses the full Euler derivative; it is not identified with the stochastic Weber propagator without an additional argument.

The standard maximum-vorticity continuation framework originates with Beale, Kato and Majda, *Remarks on the breakdown of smooth solutions for the 3-D Euler equations*, Communications in Mathematical Physics 94 (1984), 61–66, DOI 10.1007/BF01212349; viscous Sobolev well-posedness and continuation use the corresponding energy and commutator estimates. The spectral norm theorem preserves the exact vorticity quantity appearing in that framework; it does not establish its integrability.
