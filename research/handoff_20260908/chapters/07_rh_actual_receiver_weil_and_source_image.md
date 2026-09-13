# Part VII. RH: actual arithmetic receivers, completed Weil source, and source-image rigidity

## 46. Keep the arithmetic source and the receivers distinct

The quantitative Goldbach coefficients are

\[
R(N)=\sum_{a+b=N}\Lambda(a)\Lambda(b),\qquad \Lambda(1)=0.
\]

The inspected Lean chain `Pairfield/GoldbachReconstructionChain.lean` reconstructs the actual von Mangoldt sequence from the normalized quantitative convolution tail and identifies \(-\zeta'/\zeta\) with its Dirichlet series on \(\Re s>1\). It is not a theorem that an arbitrary Boolean Goldbach support profile reconstructs \(\Lambda\), or that arbitrary tail data are in the source image, or that this finite reconstruction itself supplies analytic continuation. [S00, S23]

There are two main compact packets in this conversation. Their transforms and decay orders must not be mixed.

### The earlier fourfold spline receiver

Let \(q=4\mathbf1_{[0,1/4]}\), \(b=q^{*4}\), and

\[
h_4(x)=e^{-x}b(x-1),\qquad \operatorname{supp}h_4\subset[1,2].
\]

Its bilateral Laplace transform is

\[
H_4(z)=e^{-(z+1)}\left[\frac{1-e^{-(z+1)/4}}{(z+1)/4}\right]^4.
\]

Its nonremovable zeros are \(-1+8\pi ik\), \(k\ne0\), outside the shifted critical strip. On that strip it has \(\gamma^{-4}\) vertical decay with two-sided polynomial control. Its convolution map gives a four-derivative Sobolev re-coordinate, and

\[
(D+1)^4h_4=256\sum_{j=0}^4(-1)^j\binom4j e^{-(1+j/4)}\delta_{1+j/4}.
\]

The received arithmetic discrepancy uses only \(e^{t-2}\le n\le e^{t-1}\) at a fixed \(t\). The explicit formula is used only beyond the support endpoint, with all pole/trivial-zero terms retained. [S01, S06]

### The fixed two-packet autocorrelation receiver used by most later results

Let

\[
f(x)=e^{-4x}(q*q)(x),\quad \operatorname{supp}f\subset[0,1/2],
\qquad g=f*\widetilde f,
\]

where \(\widetilde f(x)=\overline{f(-x)}\). Here \(f\in H^1\), and \(g\) is real, nonnegative, even, \(C_c^2\), supported in \([-1/2,1/2]\). Put

\[
H(z)=16\frac{(1-e^{-(z+4)/4})^2}{(z+4)^2},
\]
\[
\boxed{G(z)=H(z)H(-z)=256\frac{(1-2e^{-1}\cosh(z/4)+e^{-2})^2}{(16-z^2)^2}.}
\]

Removable singularities are filled. \(H\) has nontrivial zeros on \(\Re z=-4\), and \(G\) on \(\Re z=\pm4\); none lies in \(|\Re z|\le1/2\). Uniformly there,

\[
|G(\sigma+i\gamma)|\asymp(1+\gamma^2)^{-2},\qquad
G(i\gamma)=256\frac{|1-e^{-1-i\gamma/4}|^4}{(16+\gamma^2)^2}>0.
\]

The elementary sector argument in [S02] proves \(|\arg G|<37/50<\pi/2\) on the whole strip. Thus \(\Re G(z)>0\) there **unconditionally**. This is positivity of individual packet coefficients' real parts, not Weil positivity on all test sources.

## 47. One explicit scalar receiver, one fixed tolerance, actual arithmetic at each time

Let \(\Sigma\) index **distinct** nontrivial shifted zeros \(z=\rho-1/2\), with multiplicities \(m_z\). Define

\[
\boxed{Z(t)=\sum_{z\in\Sigma}m_zG(z)e^{zt},\qquad M_0=Z(0).}
\]

The standard zero-count bound and packet decay give absolute compact-real-time convergence. Conjugation and functional-equation symmetries make \(Z\) real and even. The sector estimate gives \(M_0>0\) without RH.

The diagonal has the explicit prime-free formula

\[
\boxed{M_0=2G(1/2)+\frac1\pi\int_0^\infty
[\Re\psi_\Gamma(1/4+i\gamma/2)-\log\pi]G(i\gamma)d\gamma.}
\]

There is no prime term because \(\log2>1/2\) and \(g\) is supported in the smaller interval. The integral is absolutely convergent.

For \(t>1/2\), put \(a_k=2k+1/2\) and

\[
S(t)=\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}g(t-\log n),\qquad
J_{arch}(t)=\sum_{k\ge1}G(a_k)e^{-a_kt}.
\]

Then

\[
\boxed{Z(t)=e^{t/2}G(1/2)-S(t)-J_{arch}(t).}
\]

Only \(e^{t-1/2}\le n\le e^{t+1/2}\) contributes to \(S(t)\). The tail is positive and has the explicit bound

\[
0<J_{arch}(t)\le\|g\|_1
\frac{e^{-(5/2)(t-1/2)}}{1-e^{-2(t-1/2)}}.
\]

The strict lower endpoint \(t>1/2\) is essential. Do not integrate this tail formula from zero.

The main fixed-packet theorem is

\[
\boxed{RH\iff |Z(t)|\le M_0\ \forall t\in\mathbb R.}
\]

Equivalently every two-packet actual Weil form has positive semidefinite matrix

\[
\begin{pmatrix}M_0&Z(t)\\Z(t)&M_0\end{pmatrix}.
\]

Necessity is positive Fourier weights under RH. Sufficiency uses a bounded received tail, hence a Laplace transform holomorphic on \(\Re w>0\); any actual zero with \(\Re z>0\) would produce a nonzero uncancelled residue. Functional-equation reflection rules out the left half-plane. No maximum horizontal zero is assumed attained.

The exact finite-arithmetic closing inequality is therefore

\[
\boxed{|S(t)-e^{t/2}G(1/2)+J_{arch}(t)|\le M_0\quad(t>1/2).}
\]

This inequality is not proved unconditionally here. It is the actual-source premise of this closing route, not a generic positivity requirement on an unrelated matrix.

## 48. Growth and finite-height transfer

With \(\delta=\sup_{z\in\Sigma}\Re z\), reflection gives \(\delta\ge0\), and

\[
\boxed{\limsup_{t\to\infty}\frac{\log(1+|Z(t)|)}t=\delta.}
\]

The upper bound comes from absolute summability. A strictly smaller growth exponent would make the received Laplace transform holomorphic across a zero with larger real part, contradicting its nonzero residue. No dominance of an individual mode is used.

If all zeros through height \(T\ge2\) are on the line, put \(M_T=\sum_{|\Im z|\le T}m_zG(i\Im z)\). Given explicit constants \(C_G,C_N\) for packet decay and the two-sided zero count,

\[
\sum_{|\Im z|>T}m_z|G(z)|\le\frac{2C_GC_N}{T^3}
\left[\frac87\log(2+T)+\frac{64}{49}\log2\right].
\]

Thus

\[
|Z(t)|\le M_T+e^{|t|/2}\frac{2C_GC_N}{T^3}
\left[\frac87\log(2+T)+\frac{64}{49}\log2\right].
\]

This is a finite-height to finite-scale estimate (roughly \(|t|\lesssim6\log T-2\log\log T\) for fixed tolerance), not RH from finite zero verification. No current verification height is supplied or assumed. [S02]

## 49. Completed Weil space and the arithmetic packet's cyclicity

Use

\[
\mathcal H=\ell^2(\Sigma,m),\quad
(Ev)(z)=\int_\mathbb R v(x)e^{-zx}dx,\quad
\theta z=-\bar z,\quad (Ja)_z=a_{\theta z}.
\]

On the declared actual Weil test/form domain,

\[
\boxed{Q_W(v,w)=\langle Ev,J Ew\rangle_\mathcal H.}
\]

The convention is linear in the first inner-product argument. The corresponding sesquilinear conventions must remain fixed when changing transpose/adjoint notation.

A compact \(L^2\) source defines an entire transform of exponential type, but not every such source has \(\ell^2\) evaluations. Use the immediate carrier \(\mathbb C^\Sigma\) unless the appropriate decay/form assumption has been checked. The fixed \(H^1\) packet does have square-summable evaluations.

The saved source theorem proves that the translation orbit of a faithful compact packet is cyclic in the completed source space. Orthogonality to its whole translation orbit produces a vanishing exponential sum; a one-sided Laplace transform isolates each actual spectral pole because the packet factor is nonzero. This gives spectral-coordinate density, not an everywhere bounded inverse from arbitrary observations.

The same idea supplies future separation of nonzero compact sources. A compact-source entire function of exponential type has only \(O(R)\) zeros in disks if it is nonzero. Unconditionally, a positive proportion of distinct simple critical-line zeta zeros supplies \(\gg R\log R\) zeros. Vanishing on all of them forces the compact source to vanish. Thus the critical-line readings alone are injective on the original compact source class. The referenced classical input is Conrey (1989); only the positive-proportion/distinctness consequence is used. [S08, S12]

A continuous time orbit can also be sampled along the dense translation subgroup generated by \(\log2\) and \(\log3\), with the necessary continuity retained. Do not turn this into a claim that one discrete lattice of sample times is automatically complete.

## 50. Reflection downstairs: one actual packet has a singleton-or-empty source fibre

For \(v,w\in L_c^2(\mathbb R)\), if \(Ew=JEv\), their evaluations agree on every critical-line zero, hence \(w=v\). Therefore

\[
E(L_c^2)\cap J E(L_c^2)=\{a\in E(L_c^2):Ja=a\}.
\]

The linear coordinate reflection \(J\) is not the usual conjugate-linear source involution. If \(v^*(x)=\overline{v(-x)}\), then \(E(v^*)(z)=\overline{(JEv)(z)}\). Dropping the conjugation would falsely construct a compact lift of \(J\).

Use the concrete packet \(f\) from section 46 and translate by \(a=\log2\): \(p=T_af\), \(F_p(z)=e^{-az}H(z)\). On the strip,

\[
\partial_\sigma\log|F_p(\sigma+i\gamma)|
=-\log2+\Re\left[\frac{w}{2(1-w)}-\frac2{z+4}\right]
<-(\log2-1/2)<0,
\]

where \(w=e^{-(z+4)/4}\), \(|w|<1/2\). Every nonfixed reflection pair is strictly separated in modulus. Consequently

\[
\boxed{\{v\in L_c^2:Ev=JEp\}=\{p\}\text{ under RH, and is empty otherwise}.}
\]

The datum \(JEp\) exists in the Hilbert completion unconditionally. Its membership in the **original compact source image** is precisely the question. This is not answered by an abstract fibre completion.

Every finite set of distinct spectral interpolation constraints remains solvable on any chosen open bounded interval: use the strictly positive Gram matrix of the exponentials against a smooth positive bump, solve its finite system, and reconstruct a smooth compact source. If one off-line constraint is inconsistent with global reflection, the exact least source norm escapes. For critical kernels \(k_{i\gamma_j}\), \(V_N=\operatorname{span}\{k_{i\gamma_j}\}\), and \(r_N=(I-P_{V_N})k_{z_*}\),

\[
\boxed{\min\{\|d\|_2:Ed(i\gamma_j)=0\ (j\le N),\ Ed(z_*)=\delta_*\}
=|\delta_*|/\|r_N\|_2\to\infty.}
\]

Finite fibres being inhabited does not provide uniformly bounded global compact-source realizability. [S12]

## 51. The actual \(\Xi\)-cardinal source, without a spectral oracle

Define

\[
\xi(s)=\tfrac12s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s),\qquad
\Xi(z)=\xi(1/2+z).
\]

For an actual distinct zero \(z\) of multiplicity \(m\),

\[
\boxed{I_z(w)=\frac{m!}{\Xi^{(m)}(z)}\frac{\Xi(w)}{(w-z)^m}}
\]

is entire after filling the removable point and satisfies \(I_z(v)=\delta_{zv}\) at every distinct zero. Its numerator is the **actual** \(\Xi\), so every other zero is killed with its actual multiplicity. [S11] establishes its inverse source in the class with all fixed exponential-weight derivative norms finite.

[S13] supplies a stronger explicit source construction. For \(x\ge0\),

\[
\varphi(x)=\sum_{n\ge1}
(4\pi^2n^4e^{9x/2}-6\pi n^2e^{5x/2})e^{-\pi n^2e^{2x}},
\quad \varphi(-x)=\varphi(x),
\]

with

\[
\boxed{\Xi(w)=\int_\mathbb R\varphi(x)e^{-wx}dx.}
\]

The factor is normalized to \(\Xi\), not \(2\Xi\). The theta identity gives smooth even extension and, for fixed \(k\) and \(c<\pi\),

\[
|\varphi^{(k)}(x)|\le C_{k,c}e^{-c e^{2|x|}}.
\]

Let

\[
R^-_{z,m}\varphi(x)=\frac1{(m-1)!}\int_{-\infty}^x(x-y)^{m-1}e^{z(x-y)}\varphi(y)dy,
\]
\[
R^+_{z,m}\varphi(x)=\frac{(-1)^m}{(m-1)!}\int_x^\infty(y-x)^{m-1}e^{z(x-y)}\varphi(y)dy.
\]

Their exact difference is

\[
\boxed{R^-_{z,m}\varphi-R^+_{z,m}\varphi
=\frac{e^{zx}}{(m-1)!}\sum_{j=0}^{m-1}\binom{m-1}{j}
x^{m-1-j}\Xi^{(j)}(z).}
\]

At a multiplicity-\(m\) zero the two histories agree. The normalized common source \(f_z=m!R^-_{z,m}\varphi/\Xi^{(m)}(z)\) has transform \(I_z\) and double-exponential tails, using the future integral at positive infinity and past integral at negative infinity.

These cardinal sources are noncompact. The evaluation map is not injective on this enlarged class: \(\varphi\ne0\) itself has \(E\varphi=0\). No contradiction with compact-source injectivity occurs.

## 52. Endpoint-rate negative Weil tests and spectral escape

Cut off \(f_z\) with \(\chi_R=1\) on \([-R,R]\), supported in \((-R-1,R+1)\). Two integrations by parts and zero counting give

\[
\|E(\chi_Rf_z)-e_z\|_{\ell^2(\Sigma,m)}\le C_z e^{-\kappa e^{2R}}.
\]

Assume one hypothetical actual zero \(z=\sigma+i\gamma\), \(\sigma>0\), multiplicity \(m\). The negative reflection vector is

\[
a_-=(e_z-e_{\theta z})/\sqrt{2m},\quad \|a_-\|=1,\quad Ja_-=-a_-.
\]

For \(T_bv(x)=v(x-b)\), define

\[
v_T=\frac{e^{-zT}T_{-T}(\chi_Rf_z)
-e^{\theta zT}T_T(\chi_Rf_{\theta z})}{\sqrt{2m}}.
\]

Then

\[
\|v_T\|_2^2\le C_z e^{-2\sigma T},\qquad
\|Ev_T-a_-\|\le C_z e^{(1/2-\sigma)T-\kappa e^{2R}}.
\]

Choose \(R=\tfrac12\log(KT)\) with \(\kappa K\ge1\). The spectral error becomes at most \(1/4\), yielding \(Q_W(v_T,v_T)\le-7/16\). Its support radius is \(a=T+\tfrac12\log T+O(1)\). Hence, for the actual compact-source Weil bottom

\[
\lambda_a=\inf_{0\ne v\in C_c^\infty(-a,a)}Q_W(v,v)/\|v\|_2^2,
\]

one has

\[
\boxed{\lambda_a\le-c_z a^{-\sigma}e^{2\sigma a}\quad(a\ge a_z).}
\]

The earlier source construction had a freely small proportional support overhead and a rate arbitrarily close to \(2\sigma\). The actual theta tail improves the overhead to logarithmic.

Consequently any bounded self-adjoint correction \(K_a\) making the compact-source Weil form positive must have \(\|K_a\|\ge c_z a^{-\sigma}e^{2\sigma a}\). A proved subexponential lower bound on \(\lambda_a\), or a subexponential correction mechanism with the right sign, would close RH. Neither is supplied here. A crude arithmetic lower bound in the saved finite-strain/Weil note is of order \(-C(1+a)e^a\), not enough to contradict every \(0<\sigma<1/2\).

On RH, cutoffs of the noncompact \(\varphi\) with \(E\varphi=0\) show the compact-support bottom tends to zero from above. The completed negative index is the number of nonfixed reflection orbits, one negative direction per distinct orbit; multiplicity is a weight, not independent copies of the same coordinate. The compact-source exhaustion recovers this index. Local null/nonnegative vectors need not remain nonnegative after coupling to a later translation; the actual cross terms must be retained. [S08, S11, S13]

## 53. One-sided arithmetic escape: a stronger closing route recovered from [S16]

Suppose \(\delta>0\). Then for every \(a<\delta\), the actual receiver has arbitrarily large positive and negative excursions on the \(e^{at}\) scale. In the exponential limsup sense, each sign has rate \(\delta\). No dominant zero is assumed.

The proof uses the elementary Landau principle: a nonnegative locally integrable function of exponential order, with finite Laplace abscissa \(b\), must have a singularity at the real boundary point \(b\). Expanding at a real point inside its convergence half-plane and using nonnegative Taylor coefficients proves the principle.

If \(Z(t)\le Ce^{at}\) eventually, take \(F(t)=Ce^{at}-Z(t)\ge0\) on that tail. A genuine shifted-zero pole with real part greater than \(a\) forces its convergence abscissa \(b>a\). Landau requires a singularity at the real point \(b\), but the received meromorphic expression has no such positive-real zeta zero pole; its only added real pole is at \(a\). Contradiction. Apply the same argument to \(Ce^{at}+Z(t)\) for the lower bound.

Thus **an eventual one-sided polynomial bound for the same explicit arithmetic discrepancy already implies RH**. This should not be lost behind the stricter symmetric bound \(|Z|\le M_0\). The proof is supplied in [S16]; the requisite unconditional one-sided arithmetic estimate is still `UNSUPPLIED-HERE`.
