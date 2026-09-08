# Source-preserving transport beneath the Navier–Stokes tangent lift

Date: 2026-09-06 (America/Los_Angeles).
Repository snapshot read: `avikj/metacircular-interaction-prototype`, commit `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope

The results concern smooth mean-zero divergence-free fields on a flat three-torus. Stochastic constructions are restricted to a closed interval inside the classical lifetime of a prescribed deterministic Navier–Stokes solution. The linear Lie–Poisson/coadjoint structure and the stochastic Weber representation are classical. This note composes those structures with the previously established exact Poisson-source essential norm to obtain an operator-source/compact-residual decomposition. No originality-priority claim, proof-assistant compilation, global regularity theorem, or RH proof is asserted.

## 1. Definitions and the essential-norm input

Let H be the complexified mean-zero divergence-free L2 space and let P be its orthogonal Leray projection. For a real smooth source w, define

    Pi_w a = P(a cross curl w).

This is a bounded skew-adjoint operator. The previously established wave-packet calculation gives

    ||Pi_w|| = ||Pi_w||_essential = ||curl w||_infinity,
    spectrum_essential(i Pi_w) = [-||curl w||_infinity, ||curl w||_infinity].

For completeness, the transverse symbol at frequency direction n is

    P_n(a cross omega) = (omega dot n)(a cross n),    a perpendicular to n.

The eigenvalues of i times this symbol are +/- omega dot n. Localized high-frequency divergence-free wave packets at a maximum-vorticity point give singular Weyl sequences at every value of the displayed interval. The pointwise cross-product bound supplies the matching upper bound. This proves the essential-norm identity, not merely an estimate modulo compact operators.

Write K(H) for the compact operators and q:B(H)->B(H)/K(H) for the quotient. Consequently

    ||q(Pi_w-Pi_v)|| = ||curl(w-v)||_infinity.

In particular, the source image intersects K(H) only at zero. The mean-zero and divergence-free conditions make curl injective on the declared sources.

## 2. Every pair of source operators commutes modulo compact operators

**Theorem.** For smooth real u,w,

    [Pi_u,Pi_w] is compact.

**Proof without a pseudodifferential-calculus assumption.** First take trigonometric-polynomial vorticities. Pi is a finite sum of Fourier shifts. Write C_eta(a)=a cross eta, and P_k for the transverse projection at nonzero integer frequency k. For a pair of source frequencies p,q, the coefficient in the commutator at shift p+q is

    P_(k+p+q) C_(omega_u(p)) P_(k+q) C_(omega_w(q)) P_k
      - P_(k+p+q) C_(omega_w(q)) P_(k+p) C_(omega_u(p)) P_k.

For fixed p,q, as |k| tends to infinity the projections at shifted frequencies differ from P_k by O(1/|k|). The leading coefficient vanishes: on a transverse two-plane, both source symbols are scalar multiples of the same ninety-degree rotation. Thus every matrix coefficient of this finite-shift operator tends to zero at high frequency. Truncating its input frequencies approximates it in operator norm by finite-rank operators, proving compactness.

Approximate each smooth vorticity uniformly by its finite Fourier sums. The inequality ||Pi_u-Pi_v||<=||curl(u-v)||_infinity and norm-continuity of the commutator pass the conclusion to the limit. Zero-frequency conventions change only finitely many coefficients. QED.

Therefore the quotient source family commutes even though q remains isometric and injective on the source family. Static source faithfulness does not imply faithfulness of all operator interactions.

## 3. A named nonzero compact commutator

Use coordinates (x,y,z) of period 2pi and set

    u = sin(y) e_1,
    w = sin(z) e_2,
    a_N = cos(Nx) e_3,     N>=1.

Then Pi_u a_N=0 and Pi_w a_N=-cos(Nx)cos(z)e_2. Hence

    [Pi_u,Pi_w] a_N = P[cos(Nx)cos(y)cos(z)e_1]

and exact Fourier projection gives

    ( 2 cos(Nx)cos(y)cos(z)/(N^2+2),
      N sin(Nx)sin(y)cos(z)/(N^2+2),
      N sin(Nx)cos(y)sin(z)/(N^2+2) ).

For normalized torus integration,

    ||[Pi_u,Pi_w] a_N||_2^2 / ||a_N||_2^2 = 1/[2(N^2+2)].

Thus the commutator is nonzero. By Section 1 it is Pi_z for no declared source z. Also M_u w=Pi_w u=0 for this pair.

More generally, any nonzero compact K lies at positive operator-norm distance from the source image:

    inf_w ||K-Pi_w|| >= ||K||/2.

Indeed, ||Pi_w||=||q(Pi_w-K)||<=||Pi_w-K||, and the triangle inequality gives the conclusion. For the displayed commutator the lower bound is at least 1/(2 sqrt(6)). This is an operator-source exclusion, not an exclusion of a Navier–Stokes singularity.

## 4. The actual derivative and the coadjoint generator

Let [a,b]=(a dot grad)b-(b dot grad)a. Define

    M_u w = Pi_w u,
    N(u) = Pi_u u,
    J_u = DN(u) = M_u + Pi_u.

The pairing identity

    <a,Pi_w b> = -<w,[a,b]>

implies M_u*=ad_u, where ad_u(a)=[u,a]. Jacobi then gives, for every source w,

    M_u Pi_w + Pi_w M_u* = Pi_(M_u w).

Explicitly, pairing the left side with a,b gives

    -<w,[[u,a],b]+[a,[u,b]]>
      = -<w,[u,[a,b]]>
      = <a,Pi_(M_u w)b>.

Because Pi_u*=-Pi_u,

    J_u Pi_w + Pi_w J_u*
      = Pi_(M_u w) + [Pi_u,Pi_w].

This is the exact all-source residual formula. At w=u the residual is zero and it recovers actual source-sensitive Hamiltonian naturality. On arbitrary w the residual can be nonzero, compact, and outside the entire source image. M_u is the generator that intertwines the source representation for every source; J_u is the genuine derivative of the nonlinear velocity equation. Their roles are distinct.

## 5. A pathwise source-preserving lift

Fix a deterministic smooth NS solution u on [s,T] with viscosity nu>0. Drive both propagators below with the same three-dimensional Brownian path. In Stratonovich form, define

    dS = M_u S dt + sqrt(2nu) sum_j D_j S o dW_j,
    dR = J_u R dt + sqrt(2nu) sum_j D_j R o dW_j,
    S(s,s)=R(s,s)=I,

where D_j=partial_j. Their Ito drifts are M_u+nu Delta and J_u+nu Delta, respectively.

The translation noise can be removed by the common translation T_(sqrt(2nu)(W_t-W_s)). The remaining equations are pathwise deterministic linear transport systems with spatially smooth time-continuous coefficients. Forward/backward Sobolev estimates give bounded invertible propagators on the prescribed interval and uniform bounds sufficient for the weak identities and expectations used here.

The generator M_u is the projected one-form transport operator

    M_u w = -P[(u dot grad)w + (grad u)^T w].

Thus S is the coadjoint/Weber transport associated with a volume-preserving stochastic flow. With the sign convention above, its spatial flow can be taken to satisfy dX=u(X,t)dt-sqrt(2nu)dW; flipping Brownian sign recovers the usual convention.

Coadjoint naturality and [D_j,Pi_w]=Pi_(D_j w), followed by the Stratonovich product rule, prove the pathwise identity

    S(t,s) Pi_w S(t,s)* = Pi_(S(t,s)w)

for every initial source w. Both sides solve the same transported operator equation with the same initial value. In contrast to R, S preserves the physical source image separately for every noise realization.

For w_s=u(s), let w_t=S(t,s)u(s). Its mean solves

    partial_t E w_t = M_u E w_t + nu Delta E w_t.

The actual NS solution solves this same linear equation with the same initial data because M_u u=N(u). Hence

    E[S(t,s)u(s)] = u(t).

The mean of R solves the true linearized NS equation:

    E R(t,s) = V(t,s) = D Phi_NS(t,s)(u(s)).

The stochastic Weber mean representation is classical. The source-operator identity here records its full Poisson-tensor counterpart.

## 6. The tangent lift is the source-preserving lift plus a compact residual

For an arbitrary initial source w, write w_r=S(r,s)w and define

    K_(t,s)(w) = R(t,s)Pi_w R(t,s)* - Pi_(w_t).

The exact residual evolution is

    dK = (J_u K + K J_u* + [Pi_u,Pi_(w_t)])dt
           + sqrt(2nu) sum_j [D_j,K] o dW_j,
    K_s=0.

Variation of constants with the same noise gives

    K_(t,s)(w)
      = integral_s^t R(t,r)[Pi_(u(r)),Pi_(w_r)]R(t,r)* dr.

Every integrand is compact by Section 2. Bounded conjugation preserves compactness, and the smooth-interval bounds justify the operator-norm integral. Therefore K_(t,s)(w) is compact.

The resulting decomposition is

    R(t,s)Pi_w R(t,s)* = Pi_(S(t,s)w) + K_(t,s)(w),
    K_(t,s)(w) in K(H).

It is unique: equality Pi_a+K=Pi_b+L implies Pi_(a-b) compact, hence a=b and K=L. Source extraction is contractive in the maximum-vorticity norm, since

    ||curl a||_infinity = ||q(Pi_a+K)|| <= ||Pi_a+K||.

In particular,

    q(R Pi_w R*) = q(Pi_(S w)).

For the physical initial source w=u(s), the earlier covariance evolution gives E[R Pi_(u(s))R*]=Pi_(u(t)). Alternatively, taking expectations of the K equation gives a homogeneous equation because

    E[Pi_u,Pi_(w_t)] = [Pi_u,Pi_(E w_t)] = [Pi_u,Pi_u] = 0.

Its zero initial condition therefore gives

    E K_(t,s)(u(s)) = 0.

Thus the compact operator residual is exactly centered on the actual NS source. This cancellation is not obtained by bounding R R* or by declaring each random conjugate to be a source tensor.

## 7. Differentiating the source-preserving representation recovers the actual variation

For a differentiable family u_epsilon of classical NS solutions on a common interval, the representation reads

    u_epsilon(t)=E[S[u_epsilon](t,s)u_epsilon(s)].

Let v=partial_epsilon u_epsilon at zero and h=v(s). Both the input and the drift of S must be differentiated. If w_t=S[u](t,s)u(s), the derivative of the random transported source satisfies

    d(delta w) = (M_u delta w + M_v w_t)dt
                   + sqrt(2nu) sum_j D_j(delta w) o dW_j,
    delta w_s=h.

Taking expectations and using E w_t=u(t) yields

    v_t=(M_u+nu Delta)v + M_v u
       =(M_u+Pi_u+nu Delta)v
       =(J_u+nu Delta)v.

No source derivative has been dropped. S is not relabeled as the NS tangent; its source-dependent derivative produces that tangent.

## 8. A retained coadjoint constraint: helicity

Let H(w)=<w,curl w>/2. For w_t=S(t,s)w_s, the Casimir identity Pi_w curl w=0 and translation invariance give

    H(w_t)=H(w_s)

pathwise. For the physical source, write xi_t=w_t-u(t), so E xi_t=0. Quadratic polarization then gives

    H(u(t)) + E H(xi_t) = H(u(s)).

This retains helicity in the stochastic ancestry without asserting that H(xi_t) is nonnegative. It does not turn helicity into a coercive norm.

## 9. Finite parabolic rescaling and the limit boundary

For a torus of side L and r>0, use the rescaled torus of side L/r and define

    w_r(x)=r w(x0+rx),
    U_r f(x)=r^(3/2) f(x0+rx).

U_r is unitary and

    Pi_(w_r)=r^2 U_r Pi_w U_r^-1.

Combined with Brownian scaling and time rescaling, both propagators transform by U_r conjugation. The compact residual transforms as

    K_r = r^2 U_r K U_r^-1.

Thus source extraction, compactness, the residual identity, and the centered physical-source residual transport exactly at each finite renormalization step.

This does not justify erasing compact terms before taking a singular limit. Compactness is not closed in the strong operator topology: finite-rank projections can converge strongly to the identity. A coherent limiting witness must therefore retain the source, residual, and expectation/limit compatibility data. No singular-limit continuation theorem is derived from the finite-scale decomposition alone.

## 10. Verification and dependencies

The accompanying script executes 38 exact SymPy checks. It verifies the universal transverse symbol and its commutation, an explicit nonzero commutator, the coadjoint and tangent residual identities on finite Fourier fields, the common-noise Laplacian identity, and the exact high-frequency witness formula. Every generated Fourier mode is retained; there is no Galerkin cutoff. These checks support finite algebraic identities, not stochastic existence or compactness, whose arguments are above.

Repository source read at the stated snapshot:

- `formal/cubical/theorems/automata/ActionResidual.agda`: exact reconstruction of behavior from a declared predictor and its residual, with explicit composition hypotheses.
- `formal/cubical/theorems/residue/CurvatureCannotLiveOnTheImageOfAnExactCompression.agda`: intertwining and commuting source actions imply commutation on the realizable image. The present source-commutator theorem is an independent concrete operator result, not a claim that this generic theorem proves it automatically.

Classical ancestry:

- J. E. Marsden and A. Weinstein, *Coadjoint orbits, vortices, and Clebsch variables for incompressible fluids*, Physica D 7 (1983), 305–323.
- P. Constantin and G. Iyer, *A stochastic Lagrangian representation of the three-dimensional incompressible Navier–Stokes equations*, Communications on Pure and Applied Mathematics 61 (2008), 330–345; arXiv:math/0511067, especially Theorem 2.2 and Propositions 2.7 and 2.9.

The RH theorem graph is unchanged by these NS constructions: positivity of the actual continuous arithmetic moment kernel supplies its unique real spectral source and the receiver bound. A positive covariance map for NS is not a proof of that arithmetic positivity.
