# Metacircular quadratic closure: a direct Goldbach scale residual for RH and one exact NS memory kernel for all excursion depth

Repository snapshot: `avikj/metacircular-interaction-prototype@168ea8e240524f898af4b0e9cf70297c38422f08`.

## Status

The high-level simplification is that both frontier objects are quadratic and therefore metacircular in the literal differential sense.

For a quadratic map Q,

    Q(x) = (1/2) DQ(x)[x].

The object generates the linear operator that transports the object.

This observation has two concrete consequences here.

* RH. The quantitative Goldbach field is already the square of the positive prime Laplace field. After its natural scaling normalization, RH is exactly a Hölder-scale statement for one dyadic ActionResidual of the Goldbach field itself. No reconstruction of Lambda, compact receiver, square root, or zero interpolation is needed in the final criterion.

* Navier-Stokes. Along one actual solution, the quadratic vorticity nonlinearity is exactly a self-generated linear nonautonomous operator. Therefore every excursion out of an observed sector and every return from it resums into one exact Feshbach/Mori-Zwanzig Volterra memory kernel. The previously computed 2->4->2 return is precisely the diagonal first term of this kernel. The all-depth Borel tree is an expansion of the same kernel, not an independent obligation.

A second NS refinement uses frequency locality: ultra-fine vorticity cannot be injected directly from the matching band. It must cross adjacent dyadic bands. Past the diffusion/deformation matching scale, every additional band incurs a geometric damping factor; iteration gives Gaussian-in-octave suppression of cascade-generated ultra-fine content.

No proof of RH or unrestricted 3D Navier-Stokes regularity is claimed.

---

# I. RH — work directly on the quantitative Goldbach square

## 1. The actual Goldbach Laplace field

Let

    R(N) = sum_{a+b=N} Lambda(a)Lambda(b)

be the actual quantitative Goldbach field and define, for t>0,

    A(t)   = sum_{n>=2} Lambda(n) exp(-nt),
    G_R(t) = sum_{N>=4} R(N) exp(-Nt).

Absolute convergence and the convolution identity give

    G_R(t) = A(t)^2.                                         (1)

Since A(t)>0, the positive root is canonical. The prime number theorem gives

    t A(t) -> 1  as t -> 0+.                                 (2)

Normalize the Goldbach field by its exact pole scaling:

    Gcal(t) = t^2 G_R(t) = (t A(t))^2.                       (3)

Then Gcal(t)->1.

## 2. The one-step metacircular residual

Apply the installed dilation t -> 2t and subtract the fixed-point prediction:

    r_G(t) = Gcal(2t) - Gcal(t).                             (4)

Equivalently,

    r_G(t) = 4 t^2 G_R(2t) - t^2 G_R(t)
           = 4 t^2 [G_R(2t) - (1/4)G_R(t)].                 (5)

Thus the predictor 1/4 is exactly the scaling character of the Goldbach pole t^-2.

Put

    Y(t)=t A(t)>0.

Then

    r_G(t) = [Y(2t)-Y(t)] [Y(2t)+Y(t)].                      (6)

Because Y(t)->1, the second factor tends to 2 and is bounded above and below away from zero for sufficiently small t. Therefore the Goldbach-square residual and the positive-root residual have exactly the same small-t decay exponent.

This is precisely the coordinate-fibre principle in ActionResidualCoordinateFibers: the square/root re-coordinate does not create or remove the residual obstruction on the realized positive source.

## 3. Exact RH criterion on the Goldbach field alone

### Theorem

RH is equivalent to

    for every epsilon>0,
    |r_G(t)| = O_epsilon(t^(1/2-epsilon)) as t->0+.          (7)

Equivalently,

    G_R(2t) - (1/4)G_R(t)
      = O_epsilon(t^(-3/2-epsilon)).                         (8)

This criterion uses only the quantitative Goldbach coefficients R(N).

### RH implies the residual estimate

For Re s>1,

    integral_0^infinity A(t) t^(s-1) dt
      = Gamma(s) [-zeta'(s)/zeta(s)].                        (9)

Under RH there are no zeros in any closed half-plane Re s>=1/2+epsilon. Shifting the standard inverse Mellin contour to Re s=1/2+epsilon, with the pole at s=1 extracted, gives

    A(t) = 1/t + O_epsilon(t^(-1/2-epsilon)).                (10)

The gamma factor supplies exponential vertical decay. Hence

    Y(t)=1+O_epsilon(t^(1/2-epsilon)),
    Gcal(t)=1+O_epsilon(t^(1/2-epsilon)),

which gives (7).

### The residual estimate implies RH

Assume (7). Since Gcal(t)->1, dyadic telescoping toward the fixed point gives

    Gcal(t)-1
      = sum_{k>=1} [Gcal(t/2^(k-1)) - Gcal(t/2^k)].          (11)

For every fixed 0<alpha<1/2, choose epsilon=1/2-alpha. Then

    |Gcal(t)-1|
      <= C_alpha t^alpha sum_{k>=1} 2^(-k alpha)
      = O_alpha(t^alpha).                                   (12)

Since Y=sqrt(Gcal)>0 and Y+1->2,

    Y(t)-1 = [Gcal(t)-1]/[Y(t)+1] = O_alpha(t^alpha).        (13)

Thus for every epsilon>0,

    A(t)-1/t = O_epsilon(t^(-1/2-epsilon)).                  (14)

Initially on Re s>1,

    Gamma(s)[-zeta'(s)/zeta(s)] - 1/(s-1)
      = integral_0^1 [A(t)-1/t] t^(s-1) dt
        + integral_1^infinity A(t)t^(s-1)dt.                (15)

The second integral is entire in s. By (14), the first is holomorphic on every Re s>1/2+epsilon, hence on Re s>1/2. Gamma has no zero there. Therefore -zeta'/zeta has no pole in Re s>1/2 except the known pole at 1, already removed. Hence zeta has no zero with real part >1/2. Functional-equation symmetry excludes zeros with real part <1/2. RH follows.

## 4. Mellin residual: the pole is the only deleted spectral point

The positive-root residual deltaY(t)=Y(2t)-Y(t) has

    M[deltaY](s)
      = (2^(-s)-1) Gamma(s+1) [-zeta'(s+1)/zeta(s+1)].       (16)

The zeta pole s+1=1, i.e. s=0, is annihilated by 2^(-s)-1.

A nontrivial zero rho produces a pole at s=rho-1, multiplied by

    2^(1-rho)-1.

This cannot vanish for a nontrivial zero: equality would force Re rho=1.

So the dyadic residual removes exactly the equilibrium pole and keeps every nontrivial zero obstruction.

## 5. Finite quantitative-Goldbach aperture

Although G_R(t) is an infinite positive series, RH-critical precision uses only a finite prefix.

The elementary bound

    R(N) <= N (log N)^2                                      (17)

follows from Lambda(n)<=log n.

Let

    L(t)=ceil(log(1/t)/t),  0<t<e^-2,

and

    G_R^fin(t)=sum_{4<=N<=L(t)} R(N)e^(-Nt).                 (18)

A standard integral comparison gives

    t^2 sum_{N>L(t)} R(N)e^(-Nt)
      = O(t (log(1/t))^4).                                  (19)

This is o(t^(1/2-epsilon)) for every fixed 0<epsilon<1/2.

Hence the criterion (7) is unchanged if Gcal is replaced by t^2 G_R^fin(t). The RH-critical dyadic residual at scale t is therefore determined, to strictly better than critical accuracy, by

    R(4),...,R(O(t^-1 log(1/t))).                            (20)

No triangular reconstruction of Lambda is needed on this route.

---

# II. Navier-Stokes — the quadratic PDE is already a self-generated linear dynamics

## 6. Quadratic metacircular identity

Let K denote the Biot-Savart map from vorticity to velocity and define

    B(alpha,beta) = curl(K alpha x beta).                    (21)

Then

    N(omega)=B(omega,omega).                                 (22)

Its Frechet derivative is

    DN(omega)[h] = B(h,omega)+B(omega,h).                    (23)

Define

    L_omega h = (1/2) DN(omega)[h].                          (24)

Then exactly

    L_omega omega = N(omega).                                (25)

Therefore the actual normalized vorticity equation

    partial_tau Omega = epsilon Delta Omega + N(Omega)

can be written

    partial_tau Omega = Lcal(tau) Omega,
    Lcal(tau)=epsilon Delta + L_{Omega(tau)}.                (26)

This is not a linearization approximation. Once the actual history Omega(tau) is fixed, (26) is an exact linear nonautonomous equation whose coefficient is generated by the same source it transports.

Let U_Omega(tau,s) be its evolution family. Then

    Omega(tau)=U_Omega(tau,s) Omega(s).                      (27)

## 7. Exact all-depth excursion/return memory

Take any fixed bounded projection P commuting with Delta and put Q=I-P. For example, P may be the toroidal l=2 strain sector or a Littlewood-Paley projection retaining frequencies through the matching band.

Write

    p=P Omega, q=Q Omega,

and block the self-generated operator:

    A=P Lcal P,
    B=P Lcal Q,
    C=Q Lcal P,
    D=Q Lcal Q.                                               (28)

Since P commutes with Delta, B and C are purely nonlinear.

The exact block equations are

    p_dot=A p+B q,
    q_dot=C p+D q.                                           (29)

Let U_Q(tau,r) be the evolution family generated by D. Then

    q(tau)
      = U_Q(tau,s)q(s)
        + integral_s^tau U_Q(tau,r) C(r) p(r) dr.           (30)

Substitution gives the exact observed dynamics

    p_dot(tau)
      = A(tau)p(tau)
        + B(tau)U_Q(tau,s)q(s)
        + integral_s^tau Kcal(tau,r)p(r)dr,                 (31)

where

    Kcal(tau,r)=B(tau) U_Q(tau,r) C(r).                      (32)

Kcal is the complete excursion-return memory kernel.

Every finite spatial return word and every time-ordered hidden excursion is an expansion of this one object. There is no separate infinite-tree obligation after (32). This is the continuous-time application-specific realization of the repository's ExcursionReturn / DynamicDescent statement that memory is exactly leave the retained sector, evolve outside it, return.

## 8. The computed 2->4->2 return is the diagonal of this kernel

Suppose at one instant a=Pa and Qa=0. Then

    C a = Q L_a a = Q N(a).                                 (33)

On the returning excursion,

    B QN(a)
      = (1/2) P DN(a)[Q N(a)].                              (34)

Therefore

    2 Kcal(s,s)a = P DN(a)[Q N(a)].                         (35)

The right side is exactly the first-return object previously computed explicitly in the toroidal branch:

    R_24(a)=P DN(a)[Q N(a)].

Thus the old 2->4->2 calculation is the diagonal first coefficient of the exact metacircular memory kernel.

The prior Borel/tree bookkeeping is optional: it is one expansion of U_Q, while (32) already resums all hidden depth.

## 9. Static resolvent form

For a time-independent block operator

    L=[[A,B],[C,D]],

the same statement is the Schur/Feshbach identity

    P(z-L)^(-1)P
      = [z-A-B(z-D)^(-1)C]^(-1).                            (36)

The self-energy B(z-D)^(-1)C is the resolvent form of the same excursion-return memory.

---

# III. Ultra-fine NS content is not an independent forcing channel

## 10. Frequency locality sharpens the previous dynamic barrier

Retain

    ||Omega(tau)||_infinity <=1,
    ||V(tau)||_2 <=E,

and let J=j_epsilon satisfy

    epsilon 4^J ~ E+J.                                      (37)

For dyadic blocks define

    X_j(tau)=sup_{k>=j} ||Delta_k Omega(tau)||_infinity.     (38)

The earlier estimate ||F_j||_infinity<=C(E+j) discarded a crucial source fact: producing output frequency 2^j requires at least one input frequency 2^(j-O(1)).

A Bony decomposition retaining this dependence gives

    ||Delta_j Omega(tau)||_infinity
      <= exp[-c epsilon 4^j (tau-s)] ||Delta_j Omega(s)||_infinity
         + C(E+j) integral_s^tau exp[-c epsilon 4^j(tau-r)]
             X_{j-C0}(r) dr,                                (39)

for a fixed finite overlap C0.

The low-high transport is in the principal transported operator. The low-vorticity/high-velocity term is proportional to the high velocity block and hence the nearby high-vorticity amplitude. A high-high pair producing output j must contain an input k>=j-C0; after the derivative and Biot-Savart inverse it carries the summable factor 2^(j-k).

Thus there is no additive O(E+j) source capable of creating arbitrarily high frequency directly from a purely coarse state.

## 11. Super-geometric cascade suppression

For j=J+m,

    (E+j)/(epsilon 4^j)
      <= C (1+m/(E+J)) 4^-m.                                (40)

After the initial parabolic transient, (39) yields schematically

    X_{J+m} <= C 4^-m X_{J+m-C0}.                            (41)

Iterating in steps of C0, for m=n C0,

    X_{J+nC0}
      <= C^n 4^[-C0(1+2+...+n)] X_J.                        (42)

Hence

    X_{J+m}^{cascade}
      <= C1 exp(-c1 m^2) X_J.                               (43)

The part inherited from a pre-existing ultra-fine initial tail is separate and decays on its own parabolic lifetime (epsilon 4^(J+m))^-1.

So ultra-fine content has only two components:

1. a transient inherited tail, rapidly diffused;
2. a freshly cascade-generated tail, Gaussian-small in octave distance from the matching band.

The previous phrase “fresh regeneration at arbitrarily fine frequency” was too loose. Quadratic Fourier support does not permit a jump: regeneration must traverse the intervening frequency graph, and every step past matching pays an increasingly strong diffusive ratio.

## 12. Consequence for the exact memory kernel

Take P=P_{<=J+m0} for a fixed finite buffer m0 and Q=I-P. The homogeneous Q-propagator in (32) inherits the same high-frequency damping. Consequently the part of Kcal(tau,r) that travels more than m additional octaves into Q is super-geometrically small in m, apart from the explicitly decaying initial Q-transient.

Thus the non-Markovian memory of arbitrarily fine frequencies is summable without expanding the quadratic dynamics into binary source trees.

The surviving continuation fibre is smaller again:

    finite-time bad ancestry
      => persistent self-generated memory inside a bounded-width
         neighbourhood of the matching band,

together with the retained coarse marginal strain history.

No contradiction has yet been proved for that matching-band memory.

---

# IV. Shared metacircular theorem graph

RH:
    R -> G_R=A^2 -> Gcal=t^2G_R -> (D_2-I)Gcal.

The pole-normalized Goldbach object has fixed point 1; its scale residual is the exact obstruction. RH is exactly the near-1/2 Hölder bound on that residual.

Navier-Stokes:
    N(Omega)=(1/2)DN(Omega)[Omega].

The actual source generates the linear operator that transports itself. Projection yields one exact hidden-sector memory kernel B U_Q C.

In both lanes the metacircular move is:

    do not reconstruct a richer object after projection;
    let the actual quadratic source generate the operation that reads
    its own residual.
