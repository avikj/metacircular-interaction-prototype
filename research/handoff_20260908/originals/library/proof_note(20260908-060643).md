# Moving-peak control, the signed nonlinear-memory spectrum, and one-sided arithmetic escape

Date: 7 September 2026 (research state).
Repository checked: `avikj/metacircular-interaction-prototype`, default-branch commit
`168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope

This note continues the user's assembled actual-endpoint graph. It does not reopen source
reconstruction or require a recurrent renormalized limit. The application assertions remain:

- `B_NS`: integrability of positive stretching at actual vorticity maxima of the one maximal NS history;
- `B_RH`: a tail bound for the actual faithful arithmetic receiver, not a substitute positive kernel.

The additions are:

1. A bound with **the spatial supremum inside the time integral** for every freely diffusing
   velocity source, and for the entire freely propagated response to its nonlinear velocity source.
   This repairs the fixed-centre quantifier problem without exchanging supremum and integration.
2. Direct control of the actual full NS evolution for small scale-critical energy–enstrophy
   product. Applying that classical bootstrap to the retained shell construction yields a family
   of globally smooth solutions with uniformly bounded total moving-peak stretching but arbitrarily
   large initial peak stretching. The small-data mechanism is classical; the uniform conclusion for
   this particular source family is the composition made here.
3. The exact **signed** Mellin spectrum of the nonlinear quadrupole-memory form, a sharp positive-cone
   coercivity bound, and a thin-shell theorem: the degree-two nonlinear forcing emitted from a
   nonnegative shell has strictly negative value under that memory form when the shell is thin enough.
   Thus pointwise positivity of its two-radius kernel cannot be iterated as unrestricted Gram positivity.
4. A self-contained Landau positivity argument applied to the faithful actual zeta receiver:
   an off-line zero forces exponentially large excursions in **both** signs. Any eventual one-sided
   polynomial bound for the same arithmetic discrepancy already implies RH.

None of these results supplies global NS regularity for arbitrary data or a proof of the required
one-sided arithmetic bound. No originality-priority claim or Agda/Lean build is made.

---

# I. A heat-response estimate with the correct moving-observer quantifier

Work on R^3, viscosity nu>0. Norms without a domain are whole-space norms. Write
`S_v=sym grad v`. The matrix norm inside Linfinity may be the Frobenius norm or operator norm;
universal constants absorb this finite-dimensional choice.

For a velocity source v define

    H_nu(v) = integral_0^infinity ||S_(exp(nu t Delta)v)||_infinity dt.

This is an integral of a spatial supremum. It dominates the observed absolute strain along
**every** measurable choice of centres and unit directions, including migrating maximizers.

## Theorem 1. Universal integrated heat-strain estimates

For v in H^1(R^3),

    H_nu(v) <= (C/nu) ||v||_2^(1/2) ||grad v||_2^(1/2).             (1)

If v is also bounded,

    H_nu(v) <= (C/nu) ||v||_2^(2/3) ||v||_infinity^(1/3).          (2)

For divergence-free finite-energy v with bounded vorticity,

    H_nu(v) <= (C/nu) ||v||_2^(4/5) ||curl v||_infinity^(1/5).     (3)

### Proof

Set tau=nu t, E=||v||_2 and W=||grad v||_2. Heat-kernel Young inequalities give

    ||grad exp(tau Delta)v||_infinity
       <= C min{ tau^(-3/4) W, tau^(-5/4) E }.

Split at tau_0=(E/W)^2. The first bound is integrable from zero and the second from tau_0 to
infinity. Their integrals are bounded by C sqrt(EW). This proves (1); v=0 is separate and trivial.

Using instead

    ||grad exp(tau Delta)v||_infinity <= C tau^(-1/2)||v||_infinity

for the short-time part, and splitting at tau_0=(E/||v||_infinity)^(4/3), proves (2).

For (3), the identity Delta v=-curl omega yields

    v=exp(s Delta)v + integral_0^s curl exp(tau Delta)omega dt.

Thus ||v||_infinity <= C(s^(-3/4)E+s^(1/2)||omega||_infinity). Optimizing s gives

    ||v||_infinity <= C E^(2/5)||omega||_infinity^(3/5).

Substitution into (2) proves (3). All of these are standard heat and interpolation arguments,
written here to retain the required order of the two observations.

## Theorem 2. All-angular nonlinear snapshot response

For a smooth divergence-free u in H^2, let

    N_u = -P[(u dot grad)u],

where P is the whole-space orthogonal Leray projection. This is the actual nonlinear velocity
source; curl N_u=curl(u cross omega). Put

    E=||u||_2, W=||omega||_2=||grad u||_2,
    P2=||grad omega||_2=||Delta u||_2.

Then

    H_nu(N_u) <= (C/nu) W P2.                                  (4)

### Proof

The Leray projector is contractive on L2 and homogeneous H1. Sobolev, interpolation and Agmon
inequalities give

    ||N_u||_2 <= C W^(3/2) P2^(1/2),
    ||grad N_u||_2 <= C W^(1/2) P2^(3/2).

For the second inequality, differentiate u dot grad u and use

    ||grad u||_4^2 <= C W^(1/2) P2^(3/2),
    ||u||_infinity <= C W^(1/2)P2^(1/2).

The latter inequality also has an elementary Fourier proof: split the inverse Fourier integral
at frequency R, use grad u in L2 below R and D^2u in L2 above R, obtaining
C(W R^(1/2)+P2 R^(-1/2)), and optimize. Apply (1) to N_u.

Equation (4) includes every angular channel, every spatial centre and every Leray/pressure
contribution. It is stronger than the earlier signed time integral at one centre of a pure
quadrupole response. It is still a response to one source snapshot, not an assertion that a
nonlinear NS trajectory equals that response.

## Theorem 3. Direct attachment to the actual maximal NS history

Let u be the smooth maximal solution on [0,T_*). Duhamel's identity is

    u(t)=exp(nu t Delta)u0 + integral_0^t exp(nu(t-s)Delta)N_(u(s)) ds.

For every T<T_*, Tonelli and (4) imply

    integral_0^T ||S_u(t)||_infinity dt
       <= H_nu(u0) + (C/nu) integral_0^T W(s) P2(s) ds.           (5)

In particular the user's actual peak-stretching channel obeys

    integral_0^T b_u(t) dt
       <= (C/nu) sqrt(E0 W0)
          + (C/nu) integral_0^T W(s) P2(s) ds.                  (6)

No trajectory of maximizers is selected or differentiated. No fixed-centre estimate is promoted
to a moving-centre estimate. The spatial supremum was present in H_nu from its definition.

This is a standard sufficient-control route, not a claim that the last integral is finite for
every maximal solution. It identifies an actual analytic upper bound for the assembled B_NS node.

## A complete first nonlinear Picard-response bound

Let v0(t)=exp(nu t Delta)u0 and

    v1(t)=integral_0^t exp(nu(t-s)Delta)N_(v0(s)) ds.

These are the free solution and its first nonlinear Duhamel correction, not the exact full solution.
The exact linear energy identities give

    integral_0^infinity W_(v0)^2 ds = E0^2/(2nu),
    integral_0^infinity P2_(v0)^2 ds = W0^2/(2nu).

Consequently

    integral_0^infinity ||S_(v1(t))||_infinity dt
       <= (C/nu^2) E0 W0.                                     (7)

This already includes time-varying replenishment from the freely evolving source, rather than
freezing N_u at time zero. Higher nonlinear corrections are not controlled by (7) alone.

---

# II. The actual Zeno-source family can be globally regular with uniformly bounded B_NS

## Theorem 4. Classical small energy–enstrophy bootstrap in endpoint form

There is a universal c_*>0 such that, for smooth rapidly decaying divergence-free initial data,

    eta0 := sqrt(E0 W0)/nu <= c_*                              (8)

implies a global classical solution and

    integral_0^infinity b_u(t)dt
      <= integral_0^infinity ||S_u(t)||_infinity dt
      <= C(eta0+eta0^2).                                      (9)

This uses only the ordinary energy/enstrophy estimates and the closing continuation argument
already supplied by the user.

### Proof on the maximal half-open interval

Energy gives

    E(t)^2 + 2nu integral_0^t W(s)^2 ds = E0^2.

The H1 energy identity and Holder–Sobolev yield

    (1/2)(W^2)' + nu P2^2
       <= ||u||_3 ||grad u||_6 P2
       <= C0 sqrt(EW) P2^2.

Choose c_* small enough that C0 sqrt(E0 W0)<=nu/2. A continuity bootstrap shows W(t)<=W0:
while W<=W0 and E<=E0, the right side can be absorbed, giving

    (1/2)(W^2)' + (nu/2)P2^2 <= 0.

Therefore the condition cannot fail at its first alleged failure time. On the entire maximal
interval,

    integral W^2 <= E0^2/(2nu),
    integral P2^2 <= W0^2/nu,
    integral W P2 <= E0 W0/(sqrt(2)nu).

Apply (6). If T_* were finite, integral_0^{T_*}b_u would be finite. The user's maximum-envelope
bound and classical continuation theorem contradict maximality. Thus T_*=infinity, and monotone
convergence in (5) gives (9).

There is no appeal to a recurrent limit, compactified pressure law, or a putative universal
contraction. The smallness hypothesis is explicit. This is not claimed as a historically new
small-data regularity theorem.

## Application to the retained shell construction

The earlier construction supplies smooth initial velocities w_N with

    ||curl w_N||_infinity=1,
    |curl w_N(0)|=1,
    b_(w_N)(0)>=c N-C,
    sup_N ||w_N||_2 ||curl w_N||_2 < infinity,

and in the stronger version uniform palinstrophy as well. A tiny rotating core fixes the unit
central vorticity; each exterior toroidal-quadrupole shell adds the same positive axial strain.
For every fixed N these are genuine smooth finite-energy initial data, not different snapshots
of one pre-existing solution.

To meet the endpoint graph's rapidly decaying initial-data class exactly, make the velocities
compactly supported before applying the following compression. The shell vector potential is
psi_N(x)=g_N(|x|) x cross(Ax). Outside all the shells,

    g_N(r)=d_N r^(-5), with sup_N |d_N|<infinity,

because d_N is a convergent sum of fifth powers of shell radii. Choose a smooth radial cutoff
chi(x/L) equal to one on B_L and zero outside B_(2L), and replace the shell velocity by
curl(chi(x/L)psi_N), leaving the compact rotating core unchanged. This agrees exactly with the
old velocity throughout the shells and at the origin. The new cutoff vorticity is supported
in L<|x|<2L and is bounded by C L^(-5) uniformly in N. Choose L once so this is below 1/2.
The resulting velocities are smooth and compactly supported, retain the unit central vorticity
and the exact diverging central strain, and retain uniformly bounded L2 velocity, L2 vorticity,
and palinstrophy. Denote this compact-velocity version again by w_N.

Fix one R>0 and compress the initial fields by

    w_(N,R)(x)=R w_N(x/R).

This preserves the vorticity amplitude and every initial pointwise strain value:

    curl w_(N,R)(x)=curl w_N(x/R),
    S_(w_(N,R))(0)=S_(w_N)(0).

But

    ||w_(N,R)||_2 = R^(5/2)||w_N||_2,
    ||curl w_(N,R)||_2 = R^(3/2)||curl w_N||_2.

Thus the product E0W0 is multiplied by R^4. Choose R sufficiently small once, independently of N,
so that (8) holds for every member of the family. Let u_(N,R) be each member's actual full NS
solution. Theorem 4 proves

    each u_(N,R) is globally smooth,
    sup_N integral_0^infinity b_(u_(N,R))(t)dt < infinity,
    b_(u_(N,R))(0) -> infinity.                               (10)

This is the precise source-family conclusion: arbitrarily large normalized initial peak
stretching from the geometric Zeno construction can coexist with a uniform bound for its total
actual nonlinear moving-peak stretching. The future source has not been replaced by free heat.

IMPORTANT: this R-compression is NOT the NS parabolic symmetry. Under the actual symmetry
u_lambda(x,t)=lambda u(lambda x,lambda^2 t), E0W0 is invariant. Our R-compression changes its
value and therefore constructs a restricted small-critical family; it does not transport an
arbitrary putative blow-up into the small-data class.

---

# III. The nonlinear quadrupole-memory kernel has a signed Mellin spectrum

Retain the actual aligned source from the saved degree-two/degree-four calculation:

    omega(rn)=f(r) T_A(n), T_A(n)=n cross A n, A in Sym_0(3),
    g(r)=(1/5)[r^(-5) integral_0^r s^4 f(s)ds + integral_r^infinity f(s)ds/s],
    g''+6g'/r=-f/r^2,
    beta2=(6/7)(5gf+2r g'f+r g f').

For f smooth and compactly supported away from zero, the radial nonlinear-memory form is

    I[f]=integral_0^infinity (9r g^2-r^3(g')^2)dr
        = double integral f(s) f(t) K(s,t) ds dt,

    K(s,t)=(m/(10M))[3-2(m/M)^3], m=min(s,t), M=max(s,t).         (11)

The first nonlinear *signed* heat-memory calculation was

    integral_0^infinity S_(heat of nonlinear vorticity source)(0)dt
       = -(3/(35nu)) I[f] (A^2)_0.                            (12)

Equation (12) is a particular signed source observation. It is not the absolute moving-centre
norm controlled in (4).

## Theorem 5. Exact spectral signature

Put ell=log r and define

    F(ell)=exp(ell) f(exp ell),
    b(ell)=exp(ell) g(exp ell).

Then

    F=(1-partial_ell)(4+partial_ell)b,
    I[f]=8||b||_2^2-||b'||_2^2.                               (13)

Equivalently, for the Fourier convention Fhat(xi)=integral exp(-i xi ell)F(ell)dell,

    I[f]=(1/(2pi)) integral
          [(8-xi^2)/((1+xi^2)(16+xi^2))] |Fhat(xi)|^2 dxi.     (14)

### Proof

The change of variables in the Green equation gives
F=4b-3b'-b''. The energy integrand becomes
9b^2-(b'-b)^2=8b^2-(b')^2+(b^2)'. Its boundary term vanishes. This proves (13).

Alternatively K(s,t)=k(log s-log t), where

    k(ell)=(3 exp(-|ell|)-2 exp(-4|ell|))/10.

The Fourier transform is

    khat(xi)=(1/10)[6/(1+xi^2)-16/(16+xi^2)]
            =(8-xi^2)/((1+xi^2)(16+xi^2)).

Plancherel gives (14).

Thus the form is positive in the low logarithmic-frequency band |xi|<sqrt(8) and negative in
|xi|>sqrt(8). Pointwise positivity K(s,t)>0 is NOT positive semidefiniteness on signed sources.

A finite exact control is already visible at radii 1 and 2:

    [K(1,1) K(1,2); K(2,1) K(2,2)]
      = [1/10 11/80; 11/80 1/10],
    determinant = -57/6400 <0.

The signed point-radius source delta_1-delta_2 has I=-3/40. The source delta_1-2delta_2 has
zero instantaneous central strain (integral f(r)dr/r=0) but I=-1/20. These point masses are
algebraic limiting controls, not smooth PDE initial data. Replacing them by narrow smooth bumps
and adjusting the second coefficient to preserve integral f/r=0 gives actual smooth finite-energy
sources with the same zero-strain condition and strictly negative memory.

## A sharp cone coercivity result

For f>=0, the old positivity conclusion is valid and can be strengthened:

    ||b'||_2^2 <= 4||b||_2^2,
    I[f] >= 4||b||_2^2.                                      (15)

The constant 4 is sharp under approximation by a shell concentrated at one radius.

To see this, let g_s denote the unit point-radius Green response and put a=s/t<=1. Direct
integration gives

    A(s,t):=integral r g_s g_t dr = (4a-a^4)/120,
    C(s,t):=integral (exp(ell)g_s(exp ell))'
                         (exp(ell)g_t(exp ell))' dell
            = (4a^4-a)/30.

Hence 4A-C=(a-a^4)/6>=0. Integrating against f(s)f(t)>=0 proves (15). Equality is approached
as both source radii concentrate at the same point.

This coercivity belongs to a particular source cone. It is not a new unconditional positive
Weil-like Hilbert form.

## Theorem 6. The actual emitted degree-two forcing reverses the memory sign for thin shells

Let phi>=0 be a nonzero Cc-infinity bump supported in (-1,1), and take

    f_epsilon(r)=phi((r-1)/epsilon), 0<epsilon<1/2.

Let beta_epsilon be the actual beta2 computed from this same source, and let
m0=integral phi. Then

    I[beta_epsilon]
       = -(6m0/35)^2 epsilon^3 integral phi(x)^2 dx
         + O(epsilon^4).                                    (16)

In particular I[f_epsilon]>0 but I[beta_epsilon]<0 for all sufficiently small epsilon.

### Proof

Write r=1+epsilon x. Uniformly for x in [-1,1], the Green formula gives

    g_epsilon(1+epsilon x)=epsilon m0/5+O(epsilon^2),
    g_epsilon'(1+epsilon x)=O(epsilon).

Therefore

    beta_epsilon(1+epsilon x)
      =(6m0/35)phi'(x)+O(epsilon).                            (17)

The kernel expansion is

    K(1+epsilon x,1+epsilon y)
      =1/10+(epsilon/2)|x-y|+O(epsilon^2),                   (18)

uniformly on the compact square. The constant term contributes O(epsilon^4), because the leading
coefficient in (17) has zero integral. The leading nonzero term is

    (epsilon^3/2)(6m0/35)^2
       double integral phi'(x)phi'(y)|x-y| dxdy.

Twice integrating by parts gives the double integral = -2 integral phi^2, proving (16).

There is also an exact structural reason the generated forcing is signed:

    beta2 = [6/(7r^4 g)] partial_r(r^5 g^2 f).                 (19)

For a nonnegative nonzero compact shell, the quantity differentiated vanishes at both endpoints
and is positive inside, while g>0. Its derivative has both signs. This does not prove that the
actual state instantly becomes sign-changing; it proves that positivity on nonnegative forcing
profiles cannot simply be reapplied to this generated forcing.

Nor does (16) give the sign of the entire next NS Duhamel term. The degree-four component and all
cross terms are still part of the same source and must be retained. It is a specific signed
channel calculation, not a nonlinear closure theorem.

---

# IV. RH: off-line zeros force equally fast positive and negative excursions

Use precisely the actual receiver in the endpoint graph:

    Z(t)=sum_z a_z exp(z t),
    a_z=m(z)G(z) !=0,
    sum_z |a_z| < infinity,
    z=rho-1/2.

Conjugation symmetry makes Z real. Reflection symmetry makes the real parts symmetric. Put

    delta=sup_z Re z=sup_z |Re z|, 0<=delta<=1/2.

Absolute reception gives |Z(t)|<=C0 exp(delta t) for t>=0. Its received Laplace transform, initially
in Re w>1/2, is

    L_Z(w)=sum_z a_z/(w-z).                                   (20)

The sum is normally convergent off the discrete zero set and meromorphic on C. Each distinct z
has the genuine residue a_z. In particular L_Z has no singularity on the positive real axis:
there are no real nontrivial zeta zeros. One elementary reason is that for 0<s<1 the alternating
eta-series is positive and 1-2^(1-s)<0, so zeta(s)<0.

## Positivity lemma (classical Landau argument, proof included)

Let f>=0 be locally integrable and of exponential order. If its real Laplace convergence
abscissa b is finite, its Laplace transform cannot be holomorphic at the real point b.

Suppose otherwise. Choose s0>b close enough that the analytic Taylor expansion of F(s0-h) has
radius greater than s0-b. For n>=0,

    (-1)^n F^(n)(s0) = integral_0^infinity t^n exp(-s0 t)f(t)dt >=0.

For some h>s0-b within the Taylor radius, monotone interchange of the positive Taylor series
and integral gives

    sum_n h^n/n! integral t^n exp(-s0t)f(t)dt
       = integral exp(-(s0-h)t)f(t)dt <infinity.

But s0-h<b, contradicting the definition of b. This proves the lemma.

## Theorem 7. Both signs realize the full off-critical exponential rate

If delta>0, then for every 0<=a<delta,

    limsup_(t->infinity) exp(-a t) Z(t) = +infinity,
    liminf_(t->infinity) exp(-a t) Z(t) = -infinity.             (21)

Consequently, with Z_+=max(Z,0) and Z_-=max(-Z,0),

    limsup log(1+Z_+(t))/t
      =limsup log(1+Z_-(t))/t
      =delta.                                                (22)

No rightmost zero is assumed to exist. No dominant-mode or no-cancellation hypothesis is used.

### Proof

Suppose, contrary to the first statement, that Z(t)<=C exp(a t) eventually. For a large T put

    f(t)=1_[T,infinity)(t)[C exp(a t)-Z(t)] >=0.

Its Laplace transform has meromorphic continuation

    F(w)=C exp(-(w-a)T)/(w-a)-L_Z(w)
          +integral_0^T exp(-wt)Z(t)dt.                       (23)

Choose a shifted zero z0 with Re z0>a. Such a zero exists by the definition of delta. Formula (23)
has a genuine pole at z0. Therefore the convergence abscissa b of F satisfies b>=Re z0>a; otherwise
the Laplace integral would be holomorphic at that pole. Also b<=delta, by the exponential upper
bound. Thus b is finite and positive.

But (23) is holomorphic at the real point b: b!=a and L_Z has no positive real singularity.
This contradicts the positivity lemma. Replacing Z by -Z proves the other sign. The upper
exponential bound and (21) prove (22).

## A weaker-looking arithmetic endpoint is already sufficient

Define the actual signed arithmetic discrepancy

    E_ar(t)=sum_(n>=2) Lambda(n)/sqrt(n) g(t-log n)
               -exp(t/2)G(1/2)+J_arch(t)=-Z(t),  t>1/2.

Theorem 7 proves each of the following separately sufficient, and in fact equivalent, to RH:

    E_ar(t)<=C(1+t)^p for all sufficiently large t,             (24a)

or

    E_ar(t)>=-C(1+t)^p for all sufficiently large t,            (24b)

where C<infinity and p>=0 may be arbitrary fixed constants. A one-sided subexponential envelope
likewise suffices.

Under RH the existing receiver is bounded by M0, so both statements hold. Conversely if RH fails,
delta>0 and (21) contradicts either polynomial envelope.

The archimedean term remains attached throughout. On any terminal interval t>=1 it is bounded
and decays; only after using that fact can it be absorbed into C. Thus an eventual one-sided
polynomial bound on the corresponding prime-shell excess or deficit alone also suffices.

This is not a proof of either arithmetic inequality. It strengthens the analytic closing theorem
and proves actual two-sign oscillatory consequences of every off-line zero. The source assertion
still requires arithmetic input not supplied here.

---

# V. Correction and dependency ledger

1. The earlier sentence saying the linear reflection J "reverses scale translation under RH"
   was wrong. For the defined U_t and J,

       J U_t J = U_(-t)^*,

   and under RH J=I, so J COMMUTES with U_t. The displayed commutator
   J U_t J U_t^(-1)=diag(exp(2t Re z)) was algebraically correct. It is a commutator defect of
   specified operations, not evidence that source-induced comparison maps fail their automatic
   cocycle identity.

2. Positivity of the pointwise two-radius kernel means positivity on nonnegative radial inputs.
   It does not mean a positive-semidefinite kernel on all signed inputs. Equations (14) and (16)
   give its exact unrestricted signature and the sign of a generated source direction.

3. No fixed-centre heat bound was used to prove (5). The quantity H_nu contains integral sup from
   the start. The fixed-centre toroidal formulas remain useful exact source coordinates but are
   not identified with the moving-peak observable.

4. Small-critical full-NS closure is proved on the maximal half-open interval using actual source
   norms. It does not assume recurrence or a nonzero singular limit. The unrestricted B_NS assertion
   is not discharged.

5. The RH one-sided theorem uses the actual meromorphic pole set, nonvanishing receiver residues,
   absence of positive-real poles, and a nonnegative-transform lemma. It does not derive critical-line
   location from losslessness, Hilbert completion, or positive damped-output Gram matrices.

## Sources read and retained

- `endpoint_graph.md`: the user's assembled actual-source endpoint graph and quantifier correction.
- `ns_rh_run23_source_closed/proof_note.md`: the actual toroidal source, matrix pressure theorem,
  beta2/beta4 nonlinear emission, and complete viscous/rotational correction.
- Saved geometric-shell source note: uniform energy/enstrophy/palinstrophy with diverging initial
  positive peak stretching; not an already constructed common blow-up history.
- Repository `formal/cubical/theorems/automata/ExcursionReturn.agda`: exact linear excursion-return
  and observer-kernel identities. The present quadratic NS estimates are not misrepresented as
  automatic consequences of its linear operator hypotheses.
- Repository search for `Landau` returned no directly pertinent positivity-abscissa theorem among
  the inspected hits; the elementary argument is supplied here. This is not an exhaustive absence claim.
- Masatoshi Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096v2: actual Weil
  distribution/form context; no conjectural large-window convergence is imported.
- Greg Martin and Chi Hoi Yip, *Oscillation results for the summatory functions of fake mu's*,
  arXiv:2411.06610v1, Section 3: background for classical Landau-method nonreal-pole oscillations.
- Kato and Ponce, *Commutator estimates and the Euler and Navier–Stokes equations*, CPAM 41 (1988),
  891–907, DOI 10.1002/cpa.3160410704: classical smooth-solution energy/continuation background.

The proofs in this note are analytic derivations. `checks.py` executes 28 exact symbolic controls
and 5 independent numerical thin-shell checks. The numerical examples are radial source quadratures,
not PDE evolutions or purported off-line zeta zeros. No formal proof-assistant build is asserted.
