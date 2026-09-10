# Source-dependent midpoint return, nonlinear kinetic storage, and the Abel-normal form of the arithmetic residual tower

Date: 8 September 2026.
Repository read: `avikj/metacircular-interaction-prototype@168ea8e240524f898af4b0e9cf70297c38422f08`.

## Status and precise additions

The source dependency is not discarded in a reduction. It determines the operator that transports the residual. For a quadratic vector field, this operator is its derivative at the source midpoint. This gives an exact nonlinear Volterra representation along every already-smooth Navier–Stokes history, without constructing an infinite Taylor or angular-return expansion. Its full returning force has an exact signed kinetic-work identity, including arbitrary nonzero initial residual energy. The identity does not require contractivity of the residual tangent propagator.

The complete toroidal degree-two source projection supplies an actual orthogonal, heat-commuting velocity projection to which these statements apply. An energy/vorticity preserving, continuously changing normalization adds an explicitly skew-adjoint dilation generator. Therefore the signed storage identity survives that normalization, with its changing viscosity retained. Moving observers have an explicit exchange term as well.

For RH, all orders of the fixed dyadic residual have one rigorous Abel inverse on the actual normalized arithmetic source. This repairs the insufficient convergence justification in run 29. In the bounded-residual class the inverse is an ordinary absolutely convergent negative-binomial series, with norm exactly `(sqrt(2)-1)^(-m)`. The conditional closing implication to RH is therefore obtained without another tail-convergence hypothesis.

These results do not establish unrestricted global NS regularity or RH. The NS memory representation remains source-dependent: its coefficients contain the retained residual itself. It is not an autonomous resolved-only model. Kinetic passivity is not a bound on maximum-vorticity stretching. No proof-assistant compilation or repository write was performed. The companion program checks exact algebra, including an untruncated finite-Fourier NS calculation; it does not simulate a PDE or verify zeta zeros.

## 1. Source and projection

Work first on a compact interval `[s,T]` strictly inside the classical lifetime of a smooth finite-energy, divergence-free whole-space solution. Set

\[
N(u)=-\mathbb P((u\cdot\nabla)u),\qquad F(u)=\nu\Delta u+N(u),
\]

where `mathbb P` is Leray projection. Let `P` be an orthogonal projection on the divergence-free velocity Hilbert space, commuting with the self-adjoint Laplacian and preserving its smooth Sobolev core. Write

\[
Q=I-P,\qquad a=Pu,\qquad b=Qu,\qquad m=a+\frac12b=\frac{u+a}{2}.
\]

Neither `a` nor `b` is independently assumed to solve NS. They are two readings of the same solution.

For the intended strain-source realization, let `T_2^x` be the orthogonal toroidal degree-two projection of vorticity on every sphere about a fixed centre `x`. Let `C=curl`, `L=-Delta` on divergence-free fields. On the smooth core define

\[
P_x=C L^{-1}T_2^x C.
\tag{1}
\]

This is exactly the velocity `u_2` of the saved source decomposition. Toroidal harmonics form an invariant sector of the vector Laplacian; thus `T_2^x` commutes with `L` and `L^{-1}`. Since `C^*=C` and `C^2=L` on the divergence-free space,

\[
P_x^*=P_x,\qquad P_x^2=P_x,\qquad [P_x,L]=0.
\tag{2}
\]

For example,

\[
P_x^2=CL^{-1}T_2^x C^2L^{-1}T_2^x C
      =CL^{-1}(T_2^x)^2C=P_x.
\]

The resulting operator extends as an orthogonal projection in `L2` and is bounded in every inhomogeneous Sobolev space because it commutes with `L`. There is no assumption that `L^{-1}` alone is bounded on `L2`: the displayed composition is the order-zero projection, first defined on the dense smooth domain and then extended.

The central-strain reading

\[
\ell_x(v)=\operatorname{sym}\nabla v(x)
\]

satisfies the saved selection theorem

\[
\ell_xP_x=\ell_x,\qquad \ell_xQ_x=0.
\tag{3}
\]

`P_x u` retains the complete matrix-valued radial toroidal source, not just five numbers. The five-dimensional central affine reading is a further projection of that source. It is not substituted for `a` in the formulas below.

## 2. Exact quadratic secant, with both source occurrences retained

For any homogeneous quadratic map `N`,

\[
\boxed{N(a+b)-N(a)=DN(a+b/2)b.}
\tag{4}
\]

To prove it, write `N(v)=B(v,v)` with any bilinear polarization. Then

\[
DN(m)b=B(m,b)+B(b,m)
=B(a,b)+B(b,a)+B(b,b).
\]

For NS specifically,

\[
DN(m)b=-\mathbb P\big((m\cdot\nabla)b+(b\cdot\nabla)m\big).
\tag{5}
\]

This is the true derivative of the quadratic field, used as an exact secant. Freezing the derivative at `a` would lose `N(b)`; freezing at `u` would double it. The midpoint is fixed by the quadratic identity rather than chosen as a closure ansatz.

Let

\[
\mathcal L_m=\nu\Delta+DN(m).
\]

The two source readings obey

\[
\boxed{
\begin{aligned}
a'&=PF(a)+P\mathcal L_m b,\\
b'&=QF(a)+Q\mathcal L_m b.
\end{aligned}}
\tag{6}
\]

Because `P` commutes with `Delta`,

\[
QF(a)=QN(a),\qquad P\mathcal L_m b=PDN(m)b.
\tag{7}
\]

Equations (6) are exactly equivalent to the original equation: summing reconstructs `u'=F(u)` and the imposed initial `P/Q` membership is preserved.

## 3. The complete nonlinear return is one source-dependent Volterra object

Along the retained history define the homogeneous residual propagator

\[
\partial_tU_Q(t,r)=Q\mathcal L_{m(t)}Q\,U_Q(t,r),
\qquad U_Q(r,r)=I_{QH}.
\tag{8}
\]

This is a nonautonomous linear propagator with coefficients furnished by the same actual `a,b`. On a fixed smooth interval these coefficients have finite smooth norms. For a smooth `v` in `QH`,

\[
\frac12\frac d{dt}\|v\|_2^2+\nu\|\nabla v\|_2^2
=-\int v^TS_{m(t)}v.
\tag{9}
\]

The Leray projection disappears in the pairing, incompressible transport is skew, and the orthogonal `Q` also disappears because `Qv=v`. Higher Sobolev estimates follow by commuting powers of `I-Delta`; `Q` commutes with these powers. Energy/Galerkin construction therefore supplies (8) on the prescribed smooth interval. No assertion of a bounded inverse for the parabolic propagator is made.

Variation of constants gives

\[
\boxed{
b(t)=U_Q(t,s)b(s)+\int_s^tU_Q(t,r)QN(a(r))\,dr.
}
\tag{10}
\]

Define the returning velocity force

\[
\mathcal R_P[u](t)=PDN(m(t))b(t).
\tag{11}
\]

Substitution yields

\[
\boxed{
\begin{aligned}
\mathcal R_P[u](t)
={}&PDN(m(t))U_Q(t,s)b(s)\\
&+\int_s^tPDN(m(t))U_Q(t,r)QN(a(r))\,dr.
\end{aligned}}
\tag{12}
\]

Together with

\[
a'=\nu\Delta a+PN(a)+\mathcal R_P[u],
\tag{13}
\]

this is the exact all-time return representation on `[s,T]`.

The first term preserves initial hidden-source ancestry. It cannot be deleted for a general source. The second term contains every subsequent interaction. No summability of an interaction-depth expansion is required to define it. Conversely it has not removed the original nonlinear problem: `m=a+b/2`, so `U_Q` depends on the residual it propagates. Equations (10) and (13) are a source-retaining fixed-point representation, not a closed functional of `a` alone.

At a pure resolved initial source `b(s)=0`, the leading generated force is

\[
\mathcal R_P[u](s+h)=h\,PDN(a(s))QN(a(s))+O(h^2).
\tag{14}
\]

This recovers exactly the earlier first nonlinear excursion-return coefficient. It differentiates both occurrences of the source. Higher returns are already included in (12), not presumed absent.

The representation uses elementary quadratic polarization and variation of constants. Projection-memory methods are classical; unlike a linear semigroup Schur identity applied to the original nonlinear state, every source dependence is explicitly retained here.

## 4. Full nonlinear returning memory has an exact kinetic-work law

The incompressible quadratic NS field obeys

\[
\langle v,N(v)\rangle_{L^2}=0
\tag{15}
\]

on the declared decaying smooth class. Also `a` and `b` are orthogonal and their gradients are orthogonal since `P` commutes with `Delta`.

From (4), (11), and (15),

\[
\begin{aligned}
\langle a,\mathcal R_P[u]\rangle
&=\langle a,N(a+b)-N(a)\rangle\\
&=\langle a,N(u)\rangle\\
&=-\langle b,N(u)\rangle.
\end{aligned}
\tag{16}
\]

The residual equation gives

\[
\frac12\frac d{dt}\|b\|_2^2+\nu\|\nabla b\|_2^2
=\langle b,N(u)\rangle.
\]

Consequently,

\[
\boxed{
\int_s^T\langle a(t),\mathcal R_P[u](t)\rangle\,dt
=\frac12\|b(s)\|_2^2-\frac12\|b(T)\|_2^2
-\nu\int_s^T\|\nabla b(t)\|_2^2\,dt.
}
\tag{17}
\]

When `b(s)=0`, the returning force performs nonpositive net work on `a`:

\[
\boxed{\int_s^T\langle a,\mathcal R_P[u]\rangle\,dt\le0.}
\tag{18}
\]

Equivalently, with output `y=-mathcal R_P[u]`, the residual subsystem is passive with supply `⟨a,y⟩` and storage `||b||²/2`, plus viscous dissipation. This identity holds for any sufficiently smooth prescribed resolved path `a` while its residual equation has a smooth solution, because the algebraic cancellations do not use the resolved equation.

For the actual full NS trajectory the total energy law further gives the cumulative-work bounds

\[
-\frac12\|a(s)\|_2^2
\le\int_s^T\langle a,\mathcal R_P[u]\rangle\,dt
\le\frac12\|b(s)\|_2^2.
\tag{19}
\]

These are bounds on net work, not its absolute variation.

### Why tangent amplification does not contradict (17)

The earlier secant equation between two independently chosen solutions has indefinite strain work. Equation (17) concerns a different diagram: one source split orthogonally, with its full nonlinear return retained. It does not assert that `U_Q` is contractive.

A finite control makes this explicit. The energy-preserving quadratic field

\[
N(x,y)=(-xy-y^2,\;x^2+xy)
\]

has, under prescribed visible input `x=1`, the damped hidden equation

\[
y'=1+(1-\nu)y,
\]

which has an amplifying homogeneous part when `nu<1`. Yet the returning visible force `r=-y-y²` satisfies exactly

\[
xr=-\frac d{dt}\frac{y^2}{2}-\nu y^2.
\]

Thus homogeneous hidden amplification and a passive full source response coexist. Bounding the propagator by a contraction would be a stronger and unnecessary requirement for (17).

## 5. Connection to the exact pressure/source graph

For the fixed-centre toroidal source projection, the saved pressure theorem states

\[
H[a]= -\frac27(S_u(x)^2)_0,
\]

and

\[
K[u]=H[u]+\frac27(S_u(x)^2)_0
=2H(a,b)+H[b].
\tag{20}
\]

At the centre, `a(x)=0`, `curl a(x)=0`, and `S_a(x)=S_u(x)`. The true nonlinear strain derivative for `a` is therefore

\[
\ell_xN(a)=-\frac57(S_u(x)^2)_0.
\tag{21}
\]

Using `ell_x P=ell_x` and the exact midpoint identity gives

\[
\boxed{
\ell_x\mathcal R_P[u]
=-(u\cdot\nabla S_u)(x)-K[u]
-\frac14(\omega(x)\otimes\omega(x))_0.
}
\tag{22}
\]

The pressure cross-effect, rotation-square term, and Eulerian transport are therefore one actual source-return contraction. They are not independent correction fields. Viscosity remains explicitly in (13); `ell_x Delta b=0` because the angular source complement is heat invariant.

This identity is valid separately at every fixed centre. Selecting a vorticity maximizer afterwards does not authorize interchanging a spatial supremum with the integrals in (12) or (17).

## 6. Continuously renormalized ancestry: the changing normalizer contributes skew transport

Choose a positive `C1` normalization rate `mu(t)` and a `C1` centre `c(t)`. Set

\[
r=\mu^{-2/5},\qquad A=\mu^{-3/5},\qquad
\frac{d\tau}{dt}=\mu,
\]

and

\[
V(y,\tau)=A(t)u(c(t)+r(t)y,t).
\tag{23}
\]

Direct change of variables gives

\[
\|V\|_2=\|u\|_2,
\qquad \operatorname{curl}_yV=\mu^{-1}\omega(c+ry,t).
\tag{24}
\]

The transformed PDE is exactly

\[
\boxed{
V_\tau=N(V)+\epsilon(\tau)\Delta V+K_\tau V,
}
\tag{25}
\]

where

\[
\epsilon=\nu\mu^{-1/5},\qquad
K_\tau=\beta\bigl(y\cdot\nabla+\tfrac32 I\bigr)+d\cdot\nabla,
\]

\[
\beta=-\frac25\frac{\mu'}{\mu^2},\qquad
d=\mu^{-3/5}c'(t).
\tag{26}
\]

The normalization leaves the nonlinear coefficient exactly one. Both the translation generator and `y·grad+3/2` are skew in `L2`, by integration by parts. The exact coefficient `3/2` is forced by the energy-preserving amplitude/length relation `A=r^(3/2)`.

Therefore (4), (6), and the residual Volterra representation apply with the time-dependent field

\[
F_\tau(v)=\epsilon(\tau)\Delta v+K_\tau v+N(v).
\]

Here the residual source is `QF_tau(a)`, including the observer-motion component `QK_tau a`; the returning force is `P( K_tau+DN(m))b`. For a fixed centre the dilation commutes with the angular projection, so it produces no cross-sector forcing. A moving centre generally does, and that term is retained.

The storage identity becomes

\[
\boxed{
\int_{\tau_s}^{\tau_T}\langle a,\mathcal R_{P,F}[V]\rangle\,d\tau
=\frac12\|b(\tau_s)\|_2^2-\frac12\|b(\tau_T)\|_2^2
-\int_{\tau_s}^{\tau_T}\epsilon(\tau)\|\nabla b\|_2^2\,d\tau.
}
\tag{27}
\]

It survives continuously changing normalization. No chart reset is secretly treated as zero energy cost.

Taking `mu=M(t)=||omega(t)||_infinity` on intervals where it is positive gives exact unit maximum vorticity. If `M` is only locally absolutely continuous, these identities hold almost everywhere. One can instead use a smooth positive gauge and retain its comparison to `M` explicitly. At every finite regular interval the original source and the gauge determine all coefficients.

The endpoint peak observable itself has exact scaling

\[
b_V(\tau)=\mu^{-1}b_u(t),\qquad
\boxed{\int b_V\,d\tau=\int b_u\,dt.}
\tag{28}
\]

Thus no recurrence or nonzero weak-limit construction is needed to formulate the actual remaining continuation assertion in this gauge.

### Changing projections directly

For a differentiable family of orthogonal heat-commuting projections `P(t)`, the source split obeys extra `P' u` terms. Since `PP'P=QP'Q=0`, the kinetic storage law is restored exactly by adding the observer-motion return `P'b`:

\[
\int\langle a,\mathcal R_P[u]+P'b\rangle
=\frac12\|b(s)\|_2^2-\frac12\|b(T)\|_2^2-\nu\int\|\nabla b\|_2^2.
\tag{29}
\]

This is a smooth-core identity whenever the indicated derivatives and pairings exist. It is not an assertion that an arbitrary path of vorticity maximizers is differentiable. Explicit translations give a permitted smooth moving frame; arbitrary maximizer selection still requires the correct supremum quantifier.

## 7. What the NS identity does and does not close

Equations (12) and (27) settle the all-order source-return assembly and its kinetic supply balance. The infinite return expansion need not be enumerated before these formulas can be used. A Borel bound on formal return coefficients is not a necessary intermediary to define the exact source-dependent memory.

They do not give the endpoint `int b_u < infinity`. Kinetic storage is not a coercive norm for peak strain or vorticity. In particular it cannot be transported into a critical storage inequality merely by relabeling the norm. The exact quantity in (22), contracted with actual vorticity directions and observed at actual peak locations, remains to be controlled. The earlier odd strain charges, pressure cross-effects, angular selection, and scale-time source constraints remain additional readings of this same return object.

No assertion from run 29's dynamic annular transport-diffusion estimate is used here. That estimate needs its own fully specified analytic justification. Also its displayed `4^{-m}` tail cannot be obtained from `(1+m/j_epsilon)4^{-m}` with a constant independent of `m` by simply dropping the polynomial factor; keeping that factor, or weakening the geometric exponent, is necessary. These facts do not affect the exact midpoint or storage identities.

# II. RH: all residual orders have one rigorously controlled inverse

## 8. Actual normalized arithmetic source

Retain the fixed source

\[
S(t)=\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}g(t-\log n),
\qquad L(t)=e^{t/2}G(1/2),
\]

with `a=log 2`, `c=sqrt 2` and

\[
A_m=(T_a-cI)^mS,
\qquad Y_k(t)=c^{-k}S(t+ka).
\tag{30}
\]

The exact finite-difference identity is

\[
\Delta^mY_k(t)=c^{-(k+m)}A_m(t+ka).
\tag{31}
\]

For the actual receiver, the saved explicit formula gives

\[
S(t)=L(t)-Z(t)-J_{arch}(t).
\]

Every shifted zero satisfies `Re z<1/2` and the received coefficients are absolutely summable. Thus

\[
c^{-k}Z(t+ka)
=\sum_z m_zG(z)e^{zt}\bigl(2^{z-1/2}\bigr)^k\longrightarrow0
\]

by dominated convergence. The archimedean tail also vanishes after normalization. Hence

\[
\boxed{Y_k(t)\to L(t)}
\tag{32}
\]

without RH or a uniform zero-free strip. For each fixed `t`, `x_k=Y_k(t)-L(t)` belongs to `c_0`.

## 9. The missing boundary argument in ordinary higher discrete integration

Convergence of `Y_k` alone does not imply convergence of

\[
\sum_k\binom{k+m-1}{m-1}\Delta^mY_k
\]

when `m>=2`. For example `x_k=(-1)^k/(k+1)` tends to zero, but the magnitude of the terms `(k+1)Delta²x_k` tends to four, so its ordinary series diverges. The geometric weight in the expression using `A_m` cannot be considered separately from the possible growth of `A_m` itself.

This identifies an insufficient step in run 29, not a counterexample to the actual prime-source formula. A stronger decay input could justify ordinary convergence for that source. The following Abel form requires only (32) and provides the needed inverse unconditionally.

## 10. Abel contracting homotopy on the actual source class

Let `T` be the forward shift on `c_0` and `0<=rho<1`. Define

\[
B_\rho=(1-\rho)T(I-\rho T)^{-1}
       =(1-\rho)\sum_{n\ge0}\rho^nT^{n+1}.
\tag{33}
\]

Then `||B_rho||<=1` and `B_rho x ->0` in `c_0` norm for every `x in c_0`. To prove strong convergence, split the weighted sum before an index beyond which all source coordinates are small; the finite initial contribution has prefactor `1-rho` and tends to zero.

The exact operator normal form is

\[
\boxed{
(I-\rho T)^{-m}(I-T)^m=(I-B_\rho)^m.
}
\tag{34}
\]

The right side tends strongly to the identity. Consequently,

\[
\boxed{
L(t)-S(t)
=(-1)^{m-1}c^{-m}
\lim_{\rho\uparrow1}\sum_{k\ge0}
\binom{k+m-1}{m-1}\left(\frac\rho c\right)^k
A_m(t+ka).
}
\tag{35}
\]

For every `rho<1`, the series converges absolutely because `Y` and its finite differences are bounded. This is a genuine source-preserving inverse with its limiting operation specified.

## 11. In the bounded-residual class, there is no additional convergence obligation

Suppose for some `m` and `t0`,

\[
B_m=\sup_{t\ge t_0}|A_m(t)|<\infty.
\]

Then (35) converges absolutely also at `rho=1`, with

\[
\boxed{
|L(t)-S(t)|\le\frac{B_m}{(c-1)^m}
=(\sqrt2+1)^mB_m,
\qquad t\ge t_0.
}
\tag{36}
\]

The scalar constant follows from

\[
c^{-m}\sum_{k\ge0}\binom{k+m-1}{m-1}c^{-k}
=(c-1)^{-m}.
\]

This is precisely the norm of `(cI-T_a)^{-m}` on bounded functions; constants show sharpness for that general bounded-function inverse.

Uniqueness also follows directly: a source difference `h` satisfying `(T_a-cI)^m h=0` has normalized values `c^{-k}h(t+ka)` polynomial in `k` of degree at most `m-1`. The inherited zero limit kills every such homogeneous ambiguity.

Since `L-S=Z+J_arch`, (36) gives bounded `Z` on the tail. The supplied Laplace-pole argument then yields RH. Thus the higher residual family is now a reusable, correctly scoped implication, not an infinite ladder of new representation tasks.

The pole-annihilating Mellin multiplier and finite quantitative-Goldbach ancestry of `A_m` are unchanged. No bound for any actual `A_m` has been proved here. Changing `m` adds vanishing moments but also the explicit inverse amplification `(sqrt2+1)^m`; it does not by itself discharge the arithmetic assertion.

## 12. Source/dependency ledger

Fresh reads at the pinned head:

* `TheGenerativeLoopOnTheKernelsOwnTermsACertifiedNormalizerEmitsDerivationsSoLearnCallsInstall.agda`: the actual kernel normalizer emits a derivation which `learn` supplies to `install`. Its concrete datatype is not identified with the PDE or arithmetic spaces above.
* `ExcursionReturn.agda`: the linear compression/return identity and set-level future-observability interpretation; its linear hypotheses are not silently applied to the NS state equation.
* The comprehensive conversation handoff and `endpoint_graph.md`: source equivalences carry predicates; they do not prove the source property.
* `continuation_memory_and_two_packet_weil.md`: the earlier passive triangular memory and the distinct general secant-strain obstruction.
* The saved run 23 source note: the full toroidal pressure theorem and actual angular nonlinear source.
* Saved run 29: higher arithmetic residuals and its limiting-convergence step, repaired by (35).

Primary background: Chorin, Hald and Kupferman, *Optimal prediction and the Mori–Zwanzig representation of irreversible processes*, PNAS 97 (2000), 2968–2973; Gouasmi, Parish and Duraisamy, *A priori estimation of memory effects in reduced-order models of nonlinear systems using the Mori–Zwanzig formalism*, Proc. R. Soc. A 473 (2017), 20170385. Projection memory and exact nonlinear reformulation are classical; the calculations here instantiate the retained NS source projection and the actual arithmetic residual tower.

Verification: `checks.py` is rerunnable. It checks the general quadratic midpoint identity, energy-preserving quadratic source work, projection-motion exchange, dynamic-normalization coefficients, Abel normal forms and inverse sums, and a genuinely three-dimensional finite-Fourier NS source without truncating any generated product modes. No new Lean/Agda theorem is claimed.
