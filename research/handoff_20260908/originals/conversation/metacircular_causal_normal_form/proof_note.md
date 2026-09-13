# Metacircular causal normalization: no artificial smallness boundary

Date: 2026-09-08.
Repository read pin: `avikj/metacircular-interaction-prototype`,
`168ea8e240524f898af4b0e9cf70297c38422f08`.

## Status and retained source

This note takes `/mnt/data/metacircular_full_history/proof_note.md` as input.
It does not recalculate the toroidal coefficients or replace the actual NS
quadratic source. It removes a sufficient-smallness restriction from the
linear resolvents used in that note and proves that the resulting nonlinear
elimination has no branching boundary at any bounded classical history.
The Volterra argument is classical. The application-specific gain is a
single source-preserving continuation chart for the full hidden history,
independent of a chosen initial expansion or sector-elimination order.

The repository sources inspected in this run include:

* `formal/cubical/kernel/TheKernelIsAnInteractiveSystemAndTheSessionRetiresIntoOneOperation.agda`:
  `learn = install o CheckedFuture.derivation`, composition of session
  traces, and `retire S = install (trace S)`.
* The search hit and previously read `DSOCutCalibration.agda` concern finite
  min-plus elimination-order controls. No general analytic Volterra theorem
  is attributed to that finite calibration.
* Previously read `TheGenerativeLoopOnTheKernelsOwnTermsACertifiedNormalizerEmitsDerivationsSoLearnCallsInstall.agda`
  and `TheControlCarriesItsInstanceAndLocusSoOneTheoremFiresAtAClass.agda`:
  proof-emitting normalization and certificate transport in their own
  declared arithmetic syntax.

No repository changes or Agda/Lean build were performed. The standalone
`kernel.py` is an exact rational matrix certificate checker and installer,
not a continuum PDE solver or a port of the repository's Agda grammar.
There is no global NS regularity or RH proof in this note.

## 1. Keep the actual quadratic source and its time ordering

On R^3, use smooth divergence-free vorticities with finite-energy velocity,

    u_a = curl(-Delta)^(-1)a,
    B(a,b) = (1/2) curl(u_a cross b + u_b cross a).

Let X be the completion of the regular phase class under

    ||a||_X = ||a||_(H^m) + ||u_a||_2,  m > 5/2,

and let X_T=C([0,T],X). The bilinear mild operation is

    V(a,b)(t) = integral_0^t exp(nu(t-s)Delta) B(a(s),b(s)) ds.

The estimates retained from the previous note give a pointwise bound

    ||V(a,b)(t)||_X
      <= c_m integral_0^t [1 + (nu(t-s))^(-1/2)]
                           ||a(s)||_X ||b(s)||_X ds.

On a fixed finite interval, this is bounded by

    c_m(sqrt(T)+nu^(-1/2)) integral_0^t (t-s)^(-1/2)
                           ||a(s)||_X ||b(s)||_X ds.

Let P be the fixed-centre toroidal-degree-two projection, or any declared
bounded complementary projection commuting with heat and preserving X.
Let Q=I-P. Boundedness constants can absorb ||P|| and ||Q||.

Write omega=p+q. For prescribed p in P X_T and actual complementary datum
q0 in Q X, the complementary equation is

    F(p,q0,q) := q - E q0 - Q V(p+q,p+q) = 0,
    (E q0)(t) = exp(nu t Delta) q0.

The nonlinearity is evaluated at the same source p+q in both slots.

## 2. Causal inverse theorem: large norm does not prevent inversion

### Theorem 1

Let A:X_T -> X_T be a bounded causal operator satisfying

    ||(Af)(t)|| <= C integral_0^t (t-s)^(-1/2)||f(s)|| ds.

For every n>=0,

    ||A^n|| <= (C sqrt(pi))^n T^(n/2) / Gamma(1+n/2).

Consequently r_spec(A)=0 and, for every complex z,

    (I-zA)^(-1) = sum_(n>=0) z^n A^n

converges in operator norm. The inverse is entire as an operator-valued
function of z. In particular no hypothesis ||A||<1 is necessary.

### Proof

Iterate the causal integral. The integrations are over
0<s_n<...<s_1<t, with the product of the successive half-order kernels.
The scalar convolution kernel k(t)=t^(-1/2) has n-fold integral against 1

    (k^{*n} * 1)(t) = Gamma(1/2)^n t^(n/2)/Gamma(1+n/2).

This follows by the beta integral, inductively. No commutation between
operator factors is used. Stirling's formula implies the nth root of the
bound tends to zero. The series for the inverse therefore converges for
every z. Multiplying its finite partial sums by I-zA leaves the remainder
z^(N+1)A^(N+1), which tends to zero in norm. This proves both inverse laws.

A quantitative majorant is the entire function

    sum_(n>=0) (|z| C sqrt(pi T))^n / Gamma(1+n/2).

This is an inverse certificate, not a global nonlinear existence bound.

### First immediate application

For any bounded prescribed history p,

    A_p h = 2 Q V(p,h)

satisfies Theorem 1. Therefore the prior source construction

    R_p=(I-A_p)^(-1),
    g_p=R_p(E q0+Q V(p,p)),
    C_p(a,b)=R_p Q V(a,b),
    q=g_p+C_p(q,q)

has an unconditionally well-defined linear R_p on every finite time
interval for bounded p. The old condition 2 kappa_T ||p||<1 was only one
sufficient geometric-series estimate; it was not the resolvent's domain.

The quadratic equation still has to have a bounded solution. The next
result describes its entire actual solution domain, rather than only the
initial Catalan expansion disk.

## 3. The hidden-history solution has no finite bounded-source branch point

Define

    D_T = {(p,q0): there exists q in Q X_T with F(p,q0,q)=0}.

### Theorem 2

D_T is open. For every (p,q0) in D_T there is exactly one bounded q solving
F=0. The resulting reconstruction

    Y_T:D_T -> Q X_T

is real analytic. It is causal under restriction to shorter intervals.
Every regular solution belongs to this one analytic reconstruction,
whether or not its expansion about zero satisfies a Catalan majorant.

### Proof of invertibility of the derivative

At a solution omega=p+q,

    D_q F = I - A_omega^Q,
    A_omega^Q h = 2 Q V(omega,h).

Since omega is bounded on [0,T], Theorem 1 gives a bounded two-sided inverse
of D_q F without a smallness condition. The residual F is a continuous
quadratic polynomial between Banach spaces, hence real analytic. The
analytic implicit function theorem gives an open graph neighborhood.

### Proof of global single-valuedness on D_T

For two bounded solutions q1,q2 with the same p,q0, set d=q1-q2. Symmetric
polarization gives

    d = 2 Q V(p+(q1+q2)/2,d).

The coefficient is bounded on [0,T]. Theorem 1 makes I minus this Volterra
operator invertible, forcing d=0. Thus all local graph neighborhoods agree
on overlaps and assemble into one real-analytic map on D_T.

### Exact derivative and exact rebasing

Let omega=p+Y_T(p,q0), and write

    R_omega^Q=(I-2Q V(omega,-))^(-1).

Then

    DY_T(p,q0)[h,k]
      = R_omega^Q (E k + 2Q V(omega,h)).

For a finite change h of p, k of q0, and d of q, subtracting the two actual
source equations yields the exact identity

    d = R_omega^Q [E k + 2Q V(omega,h) + Q V(h+d,h+d)].

There is no derivative term missing from a frozen source. This equation
re-expresses the nonlinear kernel around an already solved source. All
higher perturbative derivatives follow by differentiating this same
identity; local power-series coefficients are not independent histories.

For a supplied approximate qbar, write wbar=p+qbar and residual
rbar=F(p,q0,qbar). The equally useful exact correction equation is

    d = -(I-2Q V(wbar,-))^(-1) rbar
        +(I-2Q V(wbar,-))^(-1) Q V(d,d).

Its linear inverse exists for every bounded qbar. Convergence of an
iterative correction still requires a quantified residual/branch condition;
no universal Newton convergence claim is made.

## 4. Elimination order and time partitions are not extra dynamics

### Spatial-sector elimination

Let the hidden space be a finite bounded splitting Q=Q1+Q2 (and similarly
for finitely many more sectors). On a regular source, all diagonal
linearized hidden Volterra blocks have the inverses of Theorem 1.
Consequently staged implicit elimination is legitimate near that source.

Eliminate Q1 then Q2, eliminate Q2 then Q1, or eliminate both together.
Each construction solves exactly F=0 with the same prescribed p and q0.
The uniqueness part of Theorem 2 forces the reconstructed full hidden
history to be identical. This proves finite elimination-order independence
for the actual nonlinear history on overlapping existence domains.

This is not a claim that nonlinear angular dynamics is an autonomous
five-component ODE. The eliminated histories remain functions of the
entire prescribed history and the actual hidden initial state.

### Time rebasing

For a<t, the mild source equation splits exactly as

    omega(t) = exp(nu(t-a)Delta) omega(a)
               + integral_a^t exp(nu(t-s)Delta) B(omega(s),omega(s)) ds.

The part before a is exactly absorbed into the retained endpoint omega(a)
using the heat semigroup law. The old proof/history is retained in the
session record; it is not asserted to be recoverable from an arbitrary
endpoint after discarding it.

Restriction of Y_T to [0,a] equals Y_a of the restricted inputs, because
both solve the same causal equation. Compatible solution histories on
[0,a] and [a,T] glue to one solution on [0,T], and restriction is its inverse.
This is an equivalence of histories with matched endpoint data, not just
an equality of terminal scalar observations.

Therefore any finite time partition, any finite sector elimination, and
any local analytic rebasing describe the same full history. They may have
different proof or computation costs, but they do not create new solution
branches at bounded regular sources.

### Calibration: an origin expansion can fail while the source remains regular

For the scalar control q'=-q^2, q(0)=a>0,

    Phi_t(a)=a/(1+at)

is smooth for every real t>=0 and obeys

    Phi_(t+s)=Phi_t o Phi_s.

Its Taylor series in t at 0 has radius 1/a, set by a negative-time pole.
At a=1,t=2 the series fails but the actual source value is 1/3. Reusing the
origin series outside its disk would manufacture a false forward-time
boundary. This example is not a fluid solution; it tests the logic of a
kernel evaluator's certificates.

### Precise global consequence and limit

For an actual classical NS history, every compact interval inside its
maximal lifespan satisfies these results. Thus no regular finite-time
point is a branch singularity of the exact hidden-history reconstruction.
The conditions 2 kappa||p||<1 and 4bc<1 of a particular expansion must not
be treated as the physical boundary.

This does not assert that D_T contains every prescribed history or that
an actual NS solution remains bounded as T approaches a finite maximal
endpoint. These are different propositions. Inverse constants may grow
without bound there. All-orders re-encoding removes artificial boundaries;
it does not make an unproved endpoint condition true.

## 5. RH: normalize the whole resolvent and retain pivot domains

For an actual nonfixed reflection orbit z=sigma+i gamma,
theta z=-sigma+i gamma, the scale generator in the J-eigenbasis is

    G_z = [[-i gamma, -sigma],[-sigma,-i gamma]].

Set d=lambda+i gamma. Then

    lambda I-G_z = [[d,sigma],[sigma,d]],

and elimination of the second channel gives, initially d!=0,

    R_++(lambda) = 1/(d-sigma^2/d)
                 = d/(d^2-sigma^2).

The self-energy sigma^2/d has a pole at d=0. For sigma!=0 the full inverse is

    (1/(d^2-sigma^2)) [[d,-sigma],[-sigma,d]],

which is regular at d=0 and equals

    [[0,1/sigma],[1/sigma,0]].

Thus d=0 is an artificial pivot singularity for this nonfixed orbit. A
source-aware normalizer cancels it in the full expression; it does not
assert that the intermediate inverse 1/d exists at d=0.

In contrast d=+sigma and d=-sigma are actual determinant zeros, each with
residue 1/2 in R_++. They survive the elimination and reconstruction.
If sigma=0, the critical orbit has one actual direction, and the resolved
expression is 1/d: the neutral pole at d=0 is real. This case must not be
lost by applying the nonfixed-orbit cancellation unconditionally.

The test therefore distinguishes artificial denominator poles from poles
of the actual source dynamics. The already-established actual receiver
has a nonzero coefficient at every distinct shifted zeta zero; no unseen
zero is declared cancelled by a rewrite. This calculation does not prove
that all actual sigma vanish.

## 6. Executed proof-carrying elimination, including the forcing term

The standalone checker handles finite rational matrix equations Mx=b.
A certificate carries six objects

    (M, E, S, T, R, Z),

where y=E x is retained, S y=T b is the reduced equation, and
x=R y+Z b is the reconstruction. It checks the exact identities

    E R=I,          E Z=0,
    M R=E^T S,      M Z-I=-E^T T,
    R E+Z M=I.

These imply equivalence of the full and reduced equations for EVERY b,
not only for a selected numerical source.

For two compatible certificates, composition is

    E=E2 E1,
    S=S2,
    T=T2 T1,
    R=R1 R2,
    Z=Z1+R1 Z2 T1.

The forcing transformation T and source correction Z are retained. Keeping
only S would not be lossless source elimination.

`Kernel.install` independently checks a certificate before adding the
operation to its library. `Kernel.retire` composes two existing
certificates, checks the composite, and installs it. Applying the retired
operation solves and reconstructs the same original equation.

The executed synthetic causal control has three sectors and three ordered
time levels, strictly causal gains, and operator row-sum norm greater
than 100. Its time-ordered interaction matrix K is nilpotent even with this
large norm. Thus (I-zK)^(-1)=I+zK+z^2K for every symbolic coupling z.

The checks establish equality of direct elimination, either staged order,
all reconstruction maps, all transformed source maps, and all source
prefixes. They also reject a forged certificate which leaves the effective
operator alone but changes the source forcing, and reject a composition
whose intermediate equations do not match.

Additional exact controls check finite beta/gamma recurrences, the
common-source nonlinear rebase identity, the decaying scalar flow, and
both artificial and genuine poles of the RH reflection block.

Execution: 86 exact finite controls passed. This is not an Agda/Lean build,
not a simulation of NS, and not a proof of either global endpoint.

## 7. The resulting reusable conclusion

The local tree compiler of the previous note can be re-used at every
regular source, without treating its origin expansion disk as a new
physical condition. Linear memory is inverted globally on every fixed
finite time interval by causality; nonlinear histories are unique and
analytic on their actual existence domain; finite elimination order and
time partition are representation choices with exact source-preserving
comparison maps.

This is the specific next use of the metacircular architecture: feed the
last derivation and its side conditions back into the kernel, prove a
stronger applicability class once, and reuse it throughout the generated
history. It does not require separately calculating each angular return.
