# Dyadic pole-annihilating arithmetic residual and the unique marginal toroidal Navier–Stokes channel

Repository snapshot: `avikj/metacircular-interaction-prototype@168ea8e240524f898af4b0e9cf70297c38422f08`.

## Status

This run composes the endpoint graph with two pieces of existing machinery instead of introducing
another reconstruction layer.

* On RH, the installed scale action `t -> t + log 2` is compared against the exact square-root
  scaling character of the zeta pole.  The resulting ActionResidual kills the `rho=1` main term
  identically but loses no nontrivial zero.  It produces a main-term-free finite prime-shell
  observable.  RH is equivalent to boundedness of this observable, and even one eventual
  one-sided subexponential bound suffices.

* On Navier–Stokes, the complete toroidal spherical-harmonic Biot–Savart inverse is written in
  log radius.  Its operator factors as
      (D-(l-2))(D+(l+3)).
  After the translation/gauge `l=1` mode is removed, `l=2` is the unique zero exponent:
  the unique marginal toroidal channel.  Every `l>=3` channel contracts under inward radial
  transport.  This proves that the logarithmic Zeno accumulation found earlier belongs
  specifically to the strain-bearing degree-two mode; emitted higher modes can matter only by
  returning nonlinearly to degree two.

Neither statement proves RH or unrestricted 3D Navier–Stokes regularity.  The new results reduce
the endpoint obligations and locate the exact scale channel in which a bad NS ancestry must keep
regenerating information.

---

# I. RH — subtract the exact scale character of the pole

## 1. Retained receiver

Use the saved compact autocorrelation `g`, its bilateral transform `G`, and

    Z(t) = sum_z m_z G(z) exp(z t),

where `z=rho-1/2` ranges over distinct shifted nontrivial zeta zeros with multiplicity.
The retained facts are:

1. `sum_z m_z |G(z)| < infinity`;
2. `G(z) != 0` throughout `|Re z|<1/2`;
3. for `t>1/2`,
       Z(t)=exp(t/2)G(1/2)-S(t)-J(t),
   where
       S(t)=sum_{n>=2} Lambda(n)n^(-1/2) g(t-log n)
   is a finite prime shell and `J(t)` is the explicit exponentially decaying trivial-zero /
   archimedean remainder;
4. the meromorphic Laplace transform of `Z` has a genuine pole at every shifted zero;
5. if an off-critical zero exists and
       delta=sup_z Re z > 0,
   then both signs of `Z` realize exponential rate `delta`.

The last point was proved by the one-sided Landau argument and does not assume a rightmost zero.

## 2. The installed dyadic ActionResidual

Let

    a = log 2

and define

    boxed:
    R_2(t) = Z(t+a) - sqrt(2) Z(t).                         (1)

This is exactly an action residual:
the actual next scale reading minus the prediction supplied by the pole/equilibrium scaling
character `exp(a/2)=sqrt(2)`.

On a spectral character `exp(z t)`,

    R_2 : exp(z t) |-> (2^z-sqrt(2)) exp(z t).             (2)

The pole character `z=1/2` is therefore annihilated exactly.

No shifted nontrivial zero is annihilated.  Indeed

    2^z=sqrt(2)

would imply, by taking absolute values,

    2^(Re z)=2^(1/2),

hence `Re z=1/2`, impossible for a nontrivial zero in the open critical strip.

The multiplier is uniformly bounded on the shifted strip, so the received coefficients remain
absolutely summable.

Thus the residual has exactly the same nontrivial pole set as the original receiver.

## 3. Meromorphic transform and unchanged off-line exponent

For general `a>0`, put

    R_a(t)=Z(t+a)-exp(a/2)Z(t).

For `Re w` initially large,

    L_{R_a}(w)
      = (exp(a w)-exp(a/2)) L_Z(w)
        - exp(a w) integral_0^a exp(-w s) Z(s) ds.          (3)

The second term is entire in `w`.  Hence the residue at a shifted zero `z` is

    m_z G(z) [exp(a z)-exp(a/2)],

which is nonzero.

Consequently the same Landau argument gives, under failure of RH, for every `0<=b<delta`,

    limsup exp(-b t) R_a(t)=+infinity,
    liminf exp(-b t) R_a(t)=-infinity.                      (4)

No dominant-mode assumption enters.

In particular `R_2` has the same exact two-sign exponential rate `delta`.

Under RH all `z=i gamma`, the received coefficient sequence is absolutely summable, and `R_2`
is bounded.

Therefore

    boxed:
    RH  <=>  R_2 is bounded on a terminal half-line.        (5)

More strongly, either one of the following alone implies RH:

    R_2(t) <= exp(o(t)),
    R_2(t) >= -exp(o(t))                                    (6)

eventually.  A polynomial one-sided bound is more than enough.

## 4. The main term disappears on the arithmetic side

Define the pure dyadic prime-shell residual

    boxed:
    A_2(t)=S(t+log 2)-sqrt(2)S(t).                           (7)

Because the pole term obeys the exact scale law

    exp((t+log2)/2)=sqrt(2) exp(t/2),

the explicit formula gives

    boxed:
    R_2(t) = -A_2(t)-J_2(t),                                (8)

where

    J_2(t)=J(t+log2)-sqrt(2)J(t)

decays exponentially.

Thus the large `exp(t/2)` term is not estimated or approximately cancelled.  It is removed
algebraically by the installed action residual.

Explicitly,

    A_2(t)
      = sum_n Lambda(n)/sqrt(n)
          [ g(t+log2-log n) - sqrt(2) g(t-log n) ].          (9)

Only the finite union of the two shells

    exp(t-1/2) <= n <= exp(t+1/2),
    2 exp(t-1/2) <= n <= 2 exp(t+1/2)

appears.

Every value therefore has finite quantitative-Goldbach ancestry through the already-proved
triangular reconstruction of `Lambda`.

Combining (4), (5), and the decay of `J_2`:

    boxed:
    RH
      <=>
    A_2(t)=O(1) on a terminal half-line,                    (10)

and each one-sided condition

    A_2(t) <= exp(o(t))                                      (11a)
or
    A_2(t) >= -exp(o(t))                                     (11b)

is separately sufficient for RH.

This is strictly cleaner than the preceding arithmetic endpoint
`S(t)-exp(t/2)G(1/2)+J(t)`: the new assertion contains no macroscopic main term whose
square-root-scale cancellation has to be proved.

## 5. Repository instantiation

`ActionResidual` formalizes the pattern

    residual = after - predict(before).

Here:

    state/action:        t -> t+log2,
    reading:             S(t),
    predictor:           y -> sqrt(2) y,
    residual:            A_2(t).

The predictor is not guessed: it is exactly the response character of the zeta pole.  The
nontrivial spectral characters are separated because `2^z-sqrt(2)` is nonzero on every shifted
nontrivial zero.

The residual therefore removes the equilibrium carrier while preserving the entire obstruction
spectrum.

---

# II. Navier–Stokes — the radial transport spectrum of every toroidal angular degree

## 6. General toroidal source

Let `Y_l` be a scalar spherical harmonic of degree `l>=1` and let `T_l` be its toroidal vector
harmonic.  Take

    omega_l(r,n)=f_l(r) T_l(n).

Write its finite-energy Coulomb/Biot–Savart vector potential in the form

    psi_l(r,n)=r^2 q_l(r) T_l(n).

The vector spherical-harmonic Laplacian gives

    boxed:
    q_l'' + (6/r)q_l'
      - [(l-2)(l+3)/r^2] q_l
      = -f_l/r^2.                                           (12)

The coefficient is

    l(l+1)-6=(l-2)(l+3).

For compactly supported radial source the unique regular finite-energy inverse is

    boxed:
    q_l(r)=1/(2l+1) [
       r^(-(l+3)) integral_0^r s^(l+2) f_l(s) ds
       + r^(l-2) integral_r^infinity f_l(s)s^(-(l-1)) ds
    ].                                                       (13)

For a unit radial atom at `s` this is

    q_l(r;s)=1/(2l+1) *
      { r^(l-2)s^(-(l-1)),  r<s,
        s^(l+2)r^(-(l+3)),  r>s. }                          (14)

The derivative jump is exactly `-1/s^2`, so (14) is the Green kernel for (12).

The previously derived kernels are recovered without adjustment:

    l=2:
      q_2(r;s)=1/(5s)            for r<s,
               s^4/(5r^5)       for r>s;

    l=4:
      q_4(r;s)=r^2/(9s^3)        for r<s,
               s^6/(9r^7)       for r>s.

Thus the `1/5` strain kernel and the `1/9` degree-four inverse are two members of one family.

## 7. Log-radius factorization

Put

    x=log r,
    Q_l(x)=q_l(exp x),
    F_l(x)=f_l(exp x).

Equation (12) becomes

    Q_l'' + 5 Q_l' -(l-2)(l+3) Q_l = -F_l,

hence

    boxed:
    (D-(l-2))(D+(l+3)) Q_l = -F_l,
    D=d/dx.                                                  (15)

This is the exact renormalized radial transport spectrum.

The two homogeneous exponents are

    lambda_in  = l-2,
    lambda_out = -(l+3).

A source shell lying outside the observation scale is therefore transmitted inward with factor

    exp[-(l-2) Delta x].                                    (16)

## 8. The unique marginal channel

Three cases have different physical meanings.

### l=1 — translation/gauge channel

Inside a remote `l=1` source shell, `q_1 ~ r^(-1)`.  Then the full vector potential is
`r^2 q_1 T_1 ~ r T_1 = x cross const`, whose curl is a constant velocity.
Its gradient and strain vanish.

This is exactly the translation degree removed by Lagrangian centering.

### l=2 — marginal strain channel

Here

    (D)(D+5)Q_2=-F_2.                                       (17)

The inward exponent is exactly zero.  A remote shell produces a constant interior `q_2`, hence
a linear interior velocity and a nonzero constant strain.

For a compact source,

    boxed:
    q_2(0)=1/5 integral_0^infinity f_2(r) dr/r.              (18)

In log radius this is the zero-frequency source moment.  It is the boundary residue of the
`D` factor in (17).

This is why every geometrically separated shell can contribute the same strain increment:
`dr/r` is the Haar measure of multiplicative scale.

### l>=3 — irrelevant inward channels

The inward exponent `l-2` is strictly positive.  A remote shell at radius `R` contributes at
radius `r<R`

    |q_l(r)| <= C_l ||f_l||_infinity (r/R)^(l-2).            (19)

The corresponding interior velocity is homogeneous of degree `l-1`; its strain is homogeneous
of degree `l-2` and vanishes at the centre.

Therefore:

    boxed:
    after quotienting translations, l=2 is the unique toroidal
    zero exponent / marginal channel for the central strain observer.   (20)

No topological `H^2` class is needed.  The special object is the literal zero eigenvalue of the
log-radius transport generator.

## 9. Geometric shell theorem

Let

    R_j=4^(-j)

and let the degree-l source on shell j have amplitude `a_j`, with

    |a_j| <= C(1+j)^m.

At a point `r` comparable to `R_k`, (13) gives

    |q_l(r)|
      <= C_l [
          sum_{j<k}|a_j| 4^(-(k-j)(l-2))
          + |a_k|
          + sum_{j>k}|a_j| 4^(-(j-k)(l+3))
        ].                                                   (21)

Hence

    l>=3:
      |q_l(r)| <= C_(l,m)(1+k)^m;                            (22)

while

    l=2:
      |q_2(r)| <= C_m(1+k)^(m+1).                            (23)

The marginal `l=2` inverse gains one additional logarithmic shell count.
Every higher angular inverse does not.

This explains, rather than merely rechecks, the first-return calculation already obtained:

* the original degree-two tower has `g_N ~ j` on shell j because all outer degree-two shells
  accumulate without attenuation;
* the emitted degree-four coefficient satisfies `h_N=beta4[f_N] ~ j`;
* its degree-four inverse remains `p_N ~ j`, not `j^2`, because `l=4` has inward exponent two;
* the returned degree-two source is therefore polynomial (`~j^2` in the proved bound), and its
  freely diffusing central-strain memory is weighted by `R_j^2`.

The saved first-return theorem indeed obtained

    sum_j j^2 R_j^2
      = sum_j j^2 16^(-j)
      = 272/3375 < infinity.

Equation (21) identifies the structural reason: the excursion sector does not itself carry the
marginal Zeno logarithm.

## 10. Exact excursion-return placement

Let `P` project vorticity onto the full toroidal `l=2` sector and `Q=I-P`.

Linear heat evolution preserves angular degree.  Thus linear evolution has no `Q -> P` return.

The actual quadratic NS generator does not preserve `P`: the retained source calculation gives

    Q N(f T_A)=beta4[f] T4[A] != 0

for every nontrivial nonnegative compact aligned shell.

The latest source calculation then gives the actual first return

    boxed:
    R_24(a)=P DN(a)[Q N(a)],                                 (24)

with its explicit radial operator and positive directional two-radius kernel.

Thus the source graph is now exact:

    marginal l=2
       --actual N--> contracting l=4 excursion
       --actual DN--> marginal l=2 return.                   (25)

This is the nonlinear application-specific realization of the excursion/return idea.  The
linear `ExcursionReturn.agda` identity is not being applied outside its hypotheses; rather, the
actual nonlinear derivative supplies the return term explicitly.

## 11. Consequence for a Type-II ancestry

The static Zeno mechanism lives entirely in the zero exponent of (17).

Higher angular sectors can be future-relevant, but they cannot store another unattenuated
logarithmic scale sum while they remain outside `P`.  They must return to `l=2` before they can
again exploit the marginal channel.

Moreover, any degree-two returned shell family with polynomial shell amplitudes `O(j^m)` has
finite free central-strain memory because the exact heat lifetime contributes `R_j^2`:

    sum_j j^m R_j^2 < infinity.                              (26)

The first actual `2 -> 4 -> 2` return satisfies this hypothesis and has already been proved with
total-variation memory bounded uniformly in the number of shells.

Therefore a hypothetical singular ancestry based on this scale geometry cannot be a finite static
angular excursion.  It must involve an infinite time-ordered regeneration mechanism that returns
complementary modes into the marginal `l=2` channel rapidly enough to overcome the `R_j^2`
viscous lifetime weights.

This is a substantially smaller continuation fibre than "arbitrary Type-II turbulence":

    boxed:
    bad ancestry
      => indefinitely repeated nonlinear return into the unique marginal
         strain-bearing scale channel.                      (27)

Controlling that infinite return/resummation is still open here; no finite-order calculation is
silently promoted to the full PDE.

---

# III. Shared scale-spectrum picture

The two lanes now have a literal common object: an action with a distinguished equilibrium
character and a residual transport spectrum.

RH:
    scale action on zero mode z       exponent Re z;
    desired condition                 every obstruction exponent is 0;
    dyadic residual                   kills the pole character 1/2 and keeps every zero.

NS:
    inward log-radius action on l     exponent l-2;
    translation quotient              removes l=1 gauge;
    unique physical neutral channel   l=2;
    nonlinear return                  moves information from contracting Q modes back to l=2.

The remaining hard statements are not reconstruction problems.  They are estimates on the actual
source residuals:

* arithmetic: control one side of the pure dyadic prime-shell residual (7);
* fluid: control the infinite time-ordered nonlinear return into the marginal degree-two channel.

That is the current endpoint cut.
