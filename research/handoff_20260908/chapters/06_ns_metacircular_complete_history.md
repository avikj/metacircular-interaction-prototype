# Part VI. The full metacircular history kernel and its source-dependent storage law

## 37. One primitive quadratic interaction, not independently chosen descendants

For whole-space vorticity define

\[
u_a=\operatorname{curl}(-\Delta)^{-1}a,\qquad
\mathcal B(a,b)=\tfrac12\operatorname{curl}(u_a\times b+u_b\times a),
\]
\[
F(\omega)=\nu\Delta\omega+\mathcal B(\omega,\omega),\qquad
DF(\omega)v=\nu\Delta v+2\mathcal B(\omega,v).
\]

Here and below the first symbol in the first line is the velocity \(u_a\), not viscosity. The Fourier realization in [S17] uses \(\operatorname{curl}=ik\times\), and for nonzero wave vectors,

\[
\widehat{\mathcal B(a,b)}_k=\frac{ik\times}{2}\sum_{p+q=k}
\left[\left(\frac{ip\times\widehat a_p}{|p|^2}\right)\times\widehat b_q+
\left(\frac{ip\times\widehat b_p}{|p|^2}\right)\times\widehat a_q\right].
\]

Mean velocity, zero modes, and domain are declared rather than hidden in division by \(|p|^2\). All later expressions call this same bilinear operation.

On observables of the source,

\[
(\mathscr Lh)(\omega)=Dh(\omega)[F(\omega)]
\]

is a linear derivation. For all \(n\),

\[
\boxed{\mathscr L^n(hk)=\sum_{j=0}^n\binom nj(\mathscr L^jh)(\mathscr L^{n-j}k).}
\]

Evaluation at the actual source remains a multiplicative character. The tensor/Carleman lift \(X_n=\omega^{\odot n}\) obeys \(\dot X_n=L_nX_n+N_nX_{n+1}\), but its admissible coordinates satisfy \(X_\alpha X_\beta=X_{\alpha+\beta}\). An arbitrary sequence in the larger linear carrier is not necessarily an actual source. The formal exponential of \(\mathscr L\) preserves products coefficientwise; a smooth PDE solution is not assumed to equal its time-Taylor series.

## 38. Observable retractions and the exact first-return recurrence

Let \(P\) be the full toroidal degree-two vorticity projection, \(Q=I-P\), and retain \(\omega_0=p_0+q_0\). The source-indexed retraction is

\[
r_{q_0}(\omega)=P\omega+q_0,\qquad
(\mathscr Ph)(\omega)=h(r_{q_0}(\omega)),\qquad \mathscr Q=I-\mathscr P.
\]

It fixes the actual initial source and is idempotent. \(P\) is a field projection; \(\mathscr P\) is a projection on functions of fields. Confusing them invalidates a nonlinear application of the linear operator algebra.

The orthogonal observable generator \(\mathscr Q\mathscr L\) is generally not a derivation:

\[
\boxed{\mathscr Q\mathscr L(hk)-(\mathscr Q\mathscr Lh)k-h(\mathscr Q\mathscr Lk)
=(\mathscr P\mathscr Lh)(\mathscr Qk)+(\mathscr Qh)(\mathscr P\mathscr Lk).}
\]

Do not replace its exponential by composition with a guessed independent source flow.

With blocks \(A=\mathscr P\mathscr L\mathscr P\), \(B=\mathscr P\mathscr L\mathscr Q\), \(C=\mathscr Q\mathscr L\mathscr P\), \(D=\mathscr Q\mathscr L\mathscr Q\), define

\[
K_n=\mathscr P\mathscr L^n\mathscr P,\quad M_j=BD^jC.
\]

The exact formal renewal coefficients are

\[
\boxed{K_{n+1}=AK_n+\sum_{j=0}^{n-1}M_jK_{n-1-j}.}
\]

Thus \(K_1=A\), \(K_2=A^2+M_0\), and \(K_3=A^3+AM_0+M_0A+M_1\). The causal convolution factorials cancel: no binomial coefficient belongs in this recurrence. Its resolvent is

\[
\mathscr P(\lambda-\mathscr L)^{-1}\mathscr P
=[\lambda-A-B(\lambda-D)^{-1}C]^{-1}.
\]

This is coefficientwise formal unless actual Banach spaces, domains and resolvents have been established. It is not a universal bounded Koopman generator assertion.

For \(q_0=0\), \(a=Pa\), \(\ell(\omega)=P\omega\),

\[
\boxed{(M_0\ell)(a)=P D\mathcal N(a)[Q\mathcal N(a)].}
\]

This recovers the calculated \(2\to4\to2\) term automatically. The repo's `ExcursionReturn` and saved Delta 19 supply the structural algebra; the PDE realization is this source-typed construction. [S17, S25]

## 39. A genuinely nonlinear complementary-history equation

Use

\[
\mathcal V(a,b)(t)=\int_0^t e^{\nu(t-s)\Delta}\mathcal B(a(s),b(s))ds.
\]

For the actual histories \(p=P\omega\), \(q=Q\omega\),

\[
p=e^{\nu t\Delta}p_0+P\mathcal V(p,p)+2P\mathcal V(p,q)+P\mathcal V(q,q),
\]
\[
q=e^{\nu t\Delta}q_0+Q\mathcal V(p,p)+2Q\mathcal V(p,q)+Q\mathcal V(q,q).
\]

For prescribed \(p\), put

\[
b_p=e^{\nu t\Delta}q_0+Q\mathcal V(p,p),\quad
\mathcal A_pq=2Q\mathcal V(p,q),\quad
R_p=(I-\mathcal A_p)^{-1},
\]
\[
g_p=R_pb_p,\qquad \mathcal C_p(a,b)=R_pQ\mathcal V(a,b).
\]

Then the exact complementary reconstruction is

\[
\boxed{q=\mathcal Y[p;q_0]=g_p+\mathcal C_p(q,q).}
\]

A linear self-energy alone would omit \(Q\mathcal V(q,q)\), the interaction between complementary descendants. It is explicitly present here.

The source-sharing planar-tree evaluator is

\[
q^{[1]}=g_p,\qquad
q^{[n]}=\sum_{j=1}^{n-1}\mathcal C_p(q^{[j]},q^{[n-j]}),\quad
q=\sum_{n\ge1}q^{[n]}.
\]

Each leaf is the same source-indexed \(g_p\); each vertex the same \(\mathcal C_p\). Its nested Volterra integrals preserve time order. The exact resolved equation is

\[
\boxed{p=e^{\nu t\Delta}p_0+
P\mathcal V(p+\mathcal Y[p;q_0],p+\mathcal Y[p;q_0]),\qquad
\omega=p+\mathcal Y[p;q_0].}
\]

It is an equivalence of histories where the complementary solution exists and is unique, not a new local-in-time ODE for five strain entries.

## 40. Local tree bounds and the later causal improvement

[S17] uses \(\|a\|_X=\|a\|_{H^m}+\|u_a\|_2\), \(m>5/2\), and \(X_T=C([0,T],X)\). Its bilinear bound is

\[
\|\mathcal V(a,b)\|\le\kappa_T\|a\|\|b\|,
\qquad \kappa_T\le C_m(T+\sqrt{T/\nu}).
\]

The low-frequency velocity is controlled by the retained \(L^2\) norm; the vorticity output costs one derivative recovered by the heat kernel. If \(b=\|g_p\|\), \(c=\|\mathcal C_p\|\), then

\[
\|q^{[n]}\|\le\operatorname{Cat}_{n-1}c^{n-1}b^n,
\]
\[
\|q\|\le\frac{1-\sqrt{1-4bc}}{2c},\quad
\left\|q-\sum_{n=1}^{N}q^{[n]}\right\|\le\frac{b(4bc)^N}{1-4bc}
\]

when \(4bc<1\). With \(p_*=\|p\|\), \(r_*=\|q_0\|_X\), a sufficient scalar condition is simply \(4\kappa_T(p_*+r_*)<1\); the mixed quadratic terms cancel in its discriminant. This is a local sufficient certificate, not the actual boundary of existence.

[S18] strengthens the inverse theorem using causality. If

\[
\|(\mathcal Ah)(t)\|\le C\int_0^t(t-s)^{-1/2}\|h(s)\|ds,
\]

then ordered simplex integration gives

\[
\boxed{\|\mathcal A^n\|\le
\frac{(C\sqrt\pi)^nT^{n/2}}{\Gamma(1+n/2)}.}
\]

Thus \(\sum_{n\ge0}z^n\mathcal A^n\) converges in norm for **every** complex \(z\), and is the two-sided inverse of \(I-z\mathcal A\). Noncommuting time-dependent factors are allowed; their order is preserved in the simplex. In particular \(R_p\) exists for every bounded prescribed \(p\) on any fixed finite interval. A norm \(\|\mathcal A_p\|\ge1\) does not create an inverse obstruction.

## 41. Single-valued analytic reconstruction on the actual existence domain

Define

\[
\mathcal F(p,q_0,q)=q-e^{\nu t\Delta}q_0-Q\mathcal V(p+q,p+q),
\]

and let \(\mathfrak D_T\) be the set of \((p,q_0)\) for which a bounded \(q\in QX_T\) exists. At a solution \(\omega=p+q\),

\[
D_q\mathcal F=I-2Q\mathcal V(\omega,-)
\]

is invertible by the causal theorem. The analytic implicit-function theorem gives a local analytic chart. If \(q_1,q_2\) solve the same equation,

\[
q_1-q_2=2Q\mathcal V\left(p+\frac{q_1+q_2}{2},q_1-q_2\right),
\]

and the causal inverse forces equality. Hence \(\mathfrak D_T\) is open and the local charts glue into one real-analytic \(\mathcal Y_T\).

This is an exact theorem **on its existence domain**. It does not show \(\mathfrak D_T\) includes arbitrary resolved histories or extends through every finite-time blow-up limit. That endpoint issue must not disappear inside the definition of the domain.

At a solved history, write \(R_\omega^Q=(I-2Q\mathcal V(\omega,-))^{-1}\). Then

\[
D\mathcal Y_T[h,k]=R_\omega^Q[e^{\nu t\Delta}k+2Q\mathcal V(\omega,h)].
\]

The exact finite rebasing identity for its complementary change \(d\) is

\[
\boxed{d=R_\omega^Q[e^{\nu t\Delta}k+2Q\mathcal V(\omega,h)+Q\mathcal V(h+d,h+d)].}
\]

The previous solved source becomes the coefficient of the next evaluator. This is the analytic metacircular rebasing law. The scalar control \(q'=-q^2,q(0)=1\) has \(q=1/(1+t)\): the initial time-Taylor disk has radius one, while the forward solution exists for all positive time. Expansion-radius failure is not physical failure.

Finite compatible complementary-sector elimination orders agree by uniqueness of the same original equation. Time partitions agree by the exact mild restart law at the retained endpoint, with the past proof/history stored rather than falsely recovered from the endpoint. The claim is on common domains. It is not a global-time summability theorem or a license to permute conditionally convergent infinite eliminations.

## 42. Renormalization transports the evaluator, not each tree independently

For vorticity scaling \(S_ra(x)=r^2a(rx)\),

\[
\mathcal B(S_ra,S_rb)=r^2S_r\mathcal B(a,b),\qquad
 e^{\nu t\Delta}S_r=S_re^{\nu r^2t\Delta}.
\]

Consequently

\[
\boxed{\mathcal V(a_r,b_r)(t)=S_r\mathcal V(a,b)(r^2t),\quad
 a_r(t)=S_ra(r^2t).}
\]

Fixed-centre angular projection commutes with dilation. Structural induction transports \(b_p,\mathcal A_p,R_p,\mathcal C_p\), every tree and any convergent sum. Translations transport the centre of the angular projection; a moving observer adds its actual derivative. Neither is silently dropped.

This is the right reusable proof architecture: certify the primitive transformation and the congruences once, then transport every instance with its source and locus. It does not require a new concept for the next angular word.

## 43. The independently recovered midpoint theorem: all nonlinear returns without a tree expansion

[S19] provides another exact representation on a compact interval strictly inside the actual smooth lifetime. Work in divergence-free **velocity** \(L^2\), with an orthogonal heat-commuting projection \(P\). For the intended toroidal observer, with \(C=\operatorname{curl}\), \(L=-\Delta\),

\[
P_x=CL^{-1}T_2^xC.
\]

The full toroidal vorticity projection \(T_2^x\) commutes with \(L\); \(C^2=L\). On the smooth core, \(P_x^*=P_x\), \(P_x^2=P_x\), \([P_x,L]=0\), and it extends as an orthogonal projection. No standalone boundedness of \(L^{-1}\) on whole-space \(L^2\) is assumed. The composition is order zero. Its central reading satisfies \(S_xP_x=S_x\).

Let \(a=Pu,b=Qu,m=a+b/2\). The exact quadratic secant is

\[
\boxed{N(a+b)-N(a)=DN(m)b.}
\]

With \(\mathcal L_m=\nu\Delta+DN(m)\),

\[
a'=PF(a)+P\mathcal L_mb,\qquad
b'=QF(a)+Q\mathcal L_mb.
\]

Here \(QF(a)=QN(a)\), \(P\mathcal L_mb=PDN(m)b\). Define the actual nonautonomous residual propagator by

\[
\partial_tU_Q(t,s)=Q\mathcal L_{m(t)}Q U_Q(t,s),\qquad U_Q(s,s)=I_Q.
\]

Then

\[
\boxed{b(t)=U_Q(t,s)b(s)+\int_s^tU_Q(t,r)QN(a(r))dr.}
\]

The full return force is

\[
\boxed{R_P(t)=PDN(m(t))U_Q(t,s)b(s)
+\int_s^tPDN(m(t))U_Q(t,r)QN(a(r))dr.}
\]

Its coefficients contain \(m=a+b/2\). It is a **self-consistent same-source representation**, not an autonomous formula computable from an arbitrary resolved history without solving for its complement. Nevertheless it includes all interaction depth at once and requires no time-Taylor expansion.

The residual propagator need not be contractive:

\[
\tfrac12\frac d{dt}\|v\|_2^2+\nu\|\nabla v\|_2^2
=-\int v^TS_mv\quad(v\in\operatorname{ran}Q).
\]

This indefiniteness does not prevent the next exact storage law.

## 44. Full returning kinetic work is passive, with initial storage retained

The original NS nonlinearity obeys \(\langle v,N(v)\rangle=0\). Taking the resolved energy balance and subtracting it from the full energy balance yields

\[
\boxed{\int_s^T\langle a(t),R_P(t)\rangle dt
=\tfrac12\|b(s)\|_2^2-\tfrac12\|b(T)\|_2^2
-\nu\int_s^T\|\nabla b(t)\|_2^2dt.}
\]

If the complementary initial source vanishes, the net kinetic return work is nonpositive. More generally,

\[
-\tfrac12\|a(s)\|_2^2\le\int_s^T\langle a,R_P\rangle
\le\tfrac12\|b(s)\|_2^2.
\]

This is a genuine sign theorem for the full actual nonlinear return, stronger than inspecting one coefficient. It does **not** bound absolute variation, \(H^{1/2}\) work, local enstrophy, or the supremum of vorticity. It is compatible with sign-indefinite secants between two independent NS solutions and with initially amplifying residual propagators.

An exact finite control is \(N(x,y)=(-xy-y^2,x^2+xy)\), with \(xN_x+yN_y=0\). For a prescribed resolved value \(x=1\), the residual linear part can amplify when \(\nu<1\), while the returned kinetic force \(-y-y^2\) still satisfies the corresponding storage identity. Do not conflate the two statements.

For a moving orthogonal projection \(P(t)\), the resolved derivative additionally contains \(\dot P b\) in its work; the complementary work contains the opposite exchange. For a continuously changing energy-normalized chart, add the skew dilation/translation generator and retain the time-dependent viscosity. The same storage identity survives with these terms included. [S19] supplies the full derivation.

This is a particularly valuable starting point for agents: it gives an actual all-depth sign law already, but identifies the remaining mismatch of metric/observation precisely. The next useful theorem would transport or strengthen that law for the genuine singularity-relevant observable, not re-prove the same kinetic passivity.

## 45. Standalone proof-carrying source elimination executable

[S18]'s Python kernel does exact rational finite-matrix elimination. For \(Mx=b\), its certificate carries \((M,E,S,T,R,Z)\) with

\[
y=Ex,\quad Sy=Tb,\quad x=Ry+Zb.
\]

The checker requires

\[
ER=I,\quad EZ=0,\quad MR=E^TS,\quad MZ-I=-E^TT,\quad RE+ZM=I.
\]

They certify the original equation, transformed source and reconstruction together. Composition is

\[
E=E_2E_1,\ S=S_2,\ T=T_2T_1,\ R=R_1R_2,\
Z=Z_1+R_1Z_2T_1.
\]

`install`, `retire`, and `apply` check/use those certificates. A source-altering certificate and a mismatched intermediate equation are rejected. A synthetic causal matrix with \(\|K\|_\infty=140\), \(K^3=0\), has \((I-zK)^{-1}=I+zK+z^2K\) for every \(z\). Large norm is not a causal inverse failure.

[S17]'s independent exact evaluator implements \(M_n=\mathscr P\mathscr L\mathscr Q(\mathscr Q\mathscr L\mathscr Q)^n\mathscr Q\mathscr L\mathscr P\) and checks renewal coefficients, product laws, nonzero initial complements, and a finite periodic NS Fourier primitive with energy/helicity controls.

These are **standalone Python realizations**. Their original reports claim 141 checks for [S17] and 86 for [S18]. They were not proofs installed into the actual Agda kernel. Preserve them as reference implementations and regression suites; encode the typed general rules natively before saying Yantra has learned them.
