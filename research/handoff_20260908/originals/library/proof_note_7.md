# Instantiated continuation fibres: a fixed Weil receiver and the localized strain current

Date: 2026-09-06.
Repository snapshot read: `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope

This note instantiates existing observability and retained-residual constructions at specified arithmetic and fluid objects. The proofs use classical explicit-formula theory, an unconditional positive proportion of simple critical-line zeros, elementary entire-function zero counting, finite-dimensional Hermitian algebra, and smooth-core differential identities. No originality-priority claim, proof-assistant build, proof of RH, or proof of general NS regularity is made.

The inspected `ExcursionReturn.agda` already identifies an observability kernel with equality of all future observations. Its abstract compression identity is an input, not a new result of this note. The application proved below is that one particular arithmetic receiver has trivial future-observability kernel on compactly supported L2 test sources, even when only arbitrarily late translations are observed.

## 1. Fixed packet and the actual Weil form

Let

    q(x) = 4 1_[0,1/4](x),
    h(x) = exp(-4x) (q*q)(x),
    H(z) = integral h(x) exp(-zx) dx
         = 16 (1-exp(-(z+4)/4))^2/(z+4)^2.

The packet h is real, continuous, compactly supported in [0,1/2], and belongs to H1. Its transform has no zeros in |Re z|<=1/2 and is O((1+|Im z|)^(-2)) uniformly in that strip.

Write z_rho=rho-1/2 for distinct nontrivial zeta zeros, with multiplicity m_rho, and use

    W(phi) = sum_rho m_rho integral phi(x) exp(z_rho x) dx,
    Q(v,w) = W(v*tilde(w)),
    tilde(w)(x)=conjugate(w(-x)).

Thus Q is linear in its first argument. The Weil explicit formula supplies the arithmetic expression for W; the meromorphic continuation and zero symmetries of zeta are classical inputs, not consequences of a finite CRT calculation.

Set G(z)=H(z)H(-z). Explicitly,

    G(z) = 256 (1-2 exp(-1) cosh(z/4)+exp(-2))^2/(16-z^2)^2.

All displayed apparent poles are removable. The elementary sector estimates

    |arg(1-2 exp(-1) cosh(z/4)+exp(-2))| < 6/25,
    |arg(16-z^2)| < 13/100

on |Re z|<=1/2 imply |arg G(z)|<37/50<pi/2. Therefore

    M = Q(h,h) = sum_rho m_rho G(z_rho) > 0

unconditionally. The sum is real by conjugation symmetry and converges absolutely. It is prime-free in the explicit formula, because h*tilde(h) is supported in [-1/2,1/2] and log 2>1/2. Translation invariance gives Q(T_t h,T_t h)=M, where T_t h(x)=h(x-t).

## 2. A one-packet future-observability theorem

For compactly supported v in L2(R), define

    V_v(z) = integral v(x) exp(-zx) dx,
    R_v(z) = V_v(z) H(-z),
    O_v(t) = Q(v,T_t h).

For arbitrary compact L2 v, the final pairing can be defined by the absolutely convergent series

    O_v(t) = sum_rho m_rho R_v(z_rho) exp(z_rho t).

It agrees with the closed-form pairing whenever v belongs to the Weil form domain. Indeed, V_v is uniformly bounded on the shifted critical strip, H(-z) has quadratic vertical decay, and the usual zero count is O(T log T). Smooth approximation therefore passes to this series uniformly on compact real t-intervals, and the form-domain pairing agrees by its form-norm continuity.

### Theorem

For every real T0,

    [O_v(t)=0 for every t>T0] implies v=0.

Consequently, for the dense subgroup D=Z log 2+Z log 3,

    [O_v(t)=O_w(t) for every t in D with t>T0] iff v=w.

No positivity of the full Weil form is assumed.

### Proof

The estimate |O_v(t)|<=C_v exp(|t|/2) and absolute convergence give, for Re s>1/2,

    integral_0^infinity exp(-st) O_v(t+T0) dt
       = sum_rho m_rho R_v(z_rho) exp(z_rho T0)/(s-z_rho).

The series on the right converges normally on compact subsets avoiding its discrete pole set and defines a meromorphic function on the complex plane. At s=z_rho its residue is

    m_rho V_v(z_rho) H(-z_rho) exp(z_rho T0).

If the time response vanishes on the half-line, the meromorphic function vanishes identically. Nonvanishing of H(-z_rho) forces V_v(z_rho)=0 for every distinct zero.

If v is supported in [-a,a], then

    |V_v(z)| <= ||v||_1 exp(a |Re z|).

A nonzero entire function with this bound has O(R) zeros in a disk of radius R, counted with multiplicity: apply Jensen's formula around any point where it does not vanish, comparing radii R and 2R. But Conrey's unconditional positive-proportion theorem supplies at least c T log T distinct simple critical-line zeros up to height T. This is incompatible with the zero count for a nonzero V_v. Hence V_v is identically zero, and Fourier uniqueness gives v=0.

For the lattice assertion, continuity of O_v-O_w and density of D imply half-line vanishing, and the preceding result applies. In particular, every nonzero v is detected by some lattice translate beyond every prescribed T0. This is not a quantitative bound on the first detecting translate or its signal strength.

### Exact repository instantiation

Take the state type to be compactly supported L2 functions, the installed actions to be translations by plus or minus log 2 and log 3, and the current observation to be Q(v,h). Simultaneous translation invariance gives

    Q(T_(-t)v,h)=Q(v,T_t h).

The observability kernel / FutureEq of `ExcursionReturn.SetForm` is therefore equality on this state type. The arithmetic spectral and entire-function argument supplies the nontrivial hypothesis; no separate real-spectrum matching assumption is introduced.

## 3. Local null vectors have an explicit negative continuation

Let A_a be the self-adjoint operator associated with the closed Weil form on L2(-a,a), as in Suzuki's operator formulation. Extend its vectors by zero outside the interval. Suppose

    0 != v in Dom(A_a),    A_a v=0.

Then Q(v,v)=0. For every prescribed T0>a, the preceding theorem supplies t in D with t>T0 and

    c=Q(v,T_t h) != 0.

The supports of v and T_t h are disjoint. Put

    w = v - (c/M) T_t h.

The exact identity is

    Q(w,w) = -|c|^2/M < 0.

The two-vector Hermitian Gram matrix has entries

    [ 0       c ]
    [ conj(c) M ]

and determinant -|c|^2. Thus a localized null vector cannot remain null and orthogonal to every later translate of this one installed receiver. It generates a strictly negative form value on a larger but finite support interval.

The vector v need not be smooth. Its zero extension belongs to the form domain of every larger interval, because core approximations from (-a,a) retain exactly the same global quadratic form. The negative w can then be approximated in the larger form norm by smooth compactly supported tests; strict negativity persists. No smoothness of the null eigenfunction is assumed.

This is not a contradiction under failure of RH. It is a source-specific extraction of a negative continuation from an assumed local degeneracy.

### Multiplicity version

If dim ker A_a=m, choose a basis v_1,...,v_m. Their scalar receiver responses are linearly independent on every terminal half-line, by the injectivity theorem. Hence one can choose m sufficiently distant lattice translates of h for which the cross-pairing matrix is invertible.

After changing basis in the translate span, the Gram matrix on the resulting 2m-dimensional space is

    [ 0 I ]
    [ I D ],    D=D*.

The congruence by [[I,-D/2],[0,I]] converts this to [[0,I],[I,0]], whose inertia is (m,m). Therefore some finite larger interval has negative index at least m. No bound on the required larger interval is obtained.

## 4. The continuation read is an actual finite arithmetic shell

Let r_v=v*tilde(h), supported in [-a-1/2,a]. Its bilateral Laplace transform is R_v. For t>a, the exact explicit formula is

    O_v(t) = exp(t/2) R_v(1/2)
       - sum_n Lambda(n)/sqrt(n) r_v(t-log n)
       - sum_{k>=1} R_v(-(2k+1/2)) exp(-(2k+1/2)t).

Only

    exp(t-a) <= n <= exp(t+a+1/2)

can contribute to the prime sum. The last series is absolutely convergent because max supp r_v<=a and t>a. It is not presumed positive when v is arbitrary.

To derive the formula, translate r_v in the full Weil explicit formula. The value at zero and all positive-log prime arguments disappear for t>a. Expand the remaining archimedean kernel as sum_{k>=0} exp(-(2k+1/2)x); the k=0 term cancels the exp(-t/2) pole contribution. The remaining terms are exactly those displayed.

Each prime weight retains the established CRT ancestry:

    Lambda(n)=log(C_n/C_(n-1)),    C_n=lcm(1,...,n),

or, with compatible-reading probabilities pi_n,

    Lambda(n)=log(pi_(n+1)^2/(pi_n pi_(n+2))).

The checked `GoldbachReconstructionChain.goldbachTail_reconstruction_chain` provides the other exact route to these same weights from normalized quantitative Goldbach data. It does not replace the analytic inputs in Section 2.

Finite prime dependence does not make the unknown eigenfunction v a finite or automatically computable object. The statement is an exact finite-dimensional continuation witness with a finite arithmetic shell, not an executed RH certificate.

## 5. NS: the localized Betchov identity retains a specific current

For a smooth incompressible velocity on a periodic domain or a local Euclidean chart, set

    A=grad u,    S=(A+A^T)/2,    omega=curl u,
    J_u=cof(A)^T u.

Here A_ij=partial_j u_i and cof(A) is the matrix of signed minors, not its transpose.

The pointwise determinant identity and mixed-derivative cancellation give

    det A=det S + omega^T S omega/4,
    partial_j cof(A)_ij=0,
    div J_u=3 det A.

Consequently

    omega^T S omega = -4 det S + (4/3) div J_u.

For every compactly supported smooth cutoff chi,

    integral chi omega^T S omega
      = -4 integral chi det S
        -(4/3) integral grad chi . J_u.

The global periodic Betchov identity is only the chi=1 specialization. Localization does not remove the coupling without a residual: it moves the difference into this exact boundary current.

For a smooth NS solution, write e=|omega|^2/2. The pointwise balance is

    partial_t e - nu Delta e
      + div(u e -(4/3)J_u)
      = -4 det S - nu |grad omega|^2.

Equivalently, for a time-dependent cutoff,

    d/dt integral chi e + nu integral chi |grad omega|^2
      = integral e (partial_t chi + u.grad chi + nu Delta chi)
        -4 integral chi det S
        -(4/3) integral grad chi . J_u.

Under u_lambda(x,t)=lambda u(lambda x,lambda^2 t) and the transported cutoff chi_lambda(x,t)=chi(lambda x,lambda^2 t), the determinant integral and cofactor-boundary integral both scale by lambda^3. Neither is lower order than the other under parabolic renormalization.

On the declared mean-zero periodic source image, J_u is a derived reading of the lossless Poisson source via the Biot-Savart inverse. It is not an independently selectable boundary correction. These identities hold on the smooth core; passing them through a singular limit requires the relevant product and boundary convergence, not merely weak convergence of scalar readings.

## References and verification

Repository modules actually read include `ExcursionReturn.agda`, `GoldbachReconstructionChain.lean`, and `StrainInvariants_TheEvenMagnitudeIsBlindToTheOddShapeChargeAndNeitherFactorsThroughTheOther.agda`, pinned to the snapshot above.

J. B. Conrey, *More than two fifths of the zeros of the Riemann zeta function are on the critical line*, Journal fuer die reine und angewandte Mathematik 399 (1989), 1-26. DOI 10.1515/crll.1989.399.1. Its introduction states the positive-proportion result for simple critical-line zeros.

M. Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096v2, displayed manuscript version August 24, 2026. The explicit Weil distribution and localized closed-form/operator realization are used here.

`checks.py` executes eleven exact symbolic checks: the fixed packet transform, the negative continuation identity, its Gram determinant, the nullity block congruence and signature, the pointwise determinant identity, all three Piola rows, cofactor homogeneity, and the cofactor-current divergence. They do not verify the analytic zero-density or infinite-dimensional arguments, and no proof-assistant compilation was run.
