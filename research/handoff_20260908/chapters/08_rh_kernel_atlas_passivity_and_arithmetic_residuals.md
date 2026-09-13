# Part VIII. RH: the common kernel atlas and the direct arithmetic residuals

## 54. One faithful output determines the horizontal growth abscissa

With \(Z(t)\) from section 47 and \(\delta=\sup\Re z\), the following are exact detection statements, not proofs of the required boundedness:

\[
RH\iff\int_1^\infty e^{-2\sqrt t}|Z(t)|^2dt<\infty,
\]
\[
\delta=\inf\left\{s>0:\int_1^\infty e^{-2st}|Z(t)|^2dt<\infty\right\}.
\]

If the subexponentially damped square is integrable, Cauchy–Schwarz makes the received Laplace transform holomorphic on every right half-plane \(\Re w>0\). Its actual nonzero spectral residues exclude off-line zeros. Conversely under RH the receiver is bounded. The analogous argument at damping \(s\) yields the abscissa. These arguments avoid trying to identify a dominating mode in a possibly cancelling exponential sum.

## 55. Causal half-line Hankel operator: boundedness jumps to nuclearity

Fix \(T>1/2\) and define the kernel

\[
(H_{s,T}f)(x)=\int_0^\infty e^{-s(x+y)}Z(T+x+y)f(y)dy.
\]

For \(s>\delta\), the rank-one expansion is

\[
H_{s,T}=\sum_{z\in\Sigma}m_zG(z)e^{zT}\,R_{z,s},
\quad R_{z,s}f=e^{-(s-z)x}\int_0^\infty e^{-(s-z)y}f(y)dy.
\]

Its nuclear norm is bounded by

\[
\|H_{s,T}\|_{\mathfrak S_1}\le
\frac{e^{\delta T}}{2(s-\delta)}\sum_zm_z|G(z)|.
\]

For \(0<s<\delta\), it cannot extend boundedly on \(L^2(0,\infty)\). If it did, its exponential-input matrix coefficient would be holomorphic for \(\Re q>0\), whereas initially for large \(p,q\),

\[
\langle H_{s,T}e_q,e_{\bar p}\rangle
=\frac{F_T(s+q)-F_T(s+p)}{p-q},
\quad F_T(w)=\sum_z\frac{m_zG(z)e^{zT}}{w-z}.
\]

A zero with \(\Re z>s\) gives a genuine pole at \(q=z-s\). Thus

\[
\boxed{\delta=\inf\{s>0:H_{s,T}\text{ bounded}\}
=\inf\{s>0:H_{s,T}\in\mathfrak S_1\}.}
\]

The same infimum follows for every Schatten class \(\mathfrak S_p\), \(p\ge1\), by inclusion. No universal assertion at \(s=\delta\) is needed.

For real \(s>\delta\), \(H\) is real symmetric and self-adjoint, though not necessarily positive. Its exact outputs are

\[
\boxed{\|H_{s,T}\|_{\mathfrak S_2}^2
=\int_0^\infty t e^{-2st}|Z(T+t)|^2dt,}
\]
\[
\boxed{2\operatorname{Tr}H_{s,T}=F_T(s)
=\sum_z\frac{m_zG(z)e^{zT}}{s-z}.}
\]

The trace's continued poles and residues reconstruct the actual divisor, including multiplicities. The residue at \(s=z\) is exactly \(m_zG(z)e^{zT}\). An earlier displayed residue in the lower-limit-one convention carried a spurious extra exponential factor; always evaluate the numerator at the pole directly.

For the full-line causal convolution \(A_{s,T}\) and half-line projections \(P_+,Q_-\), the cross block is Hankel after reflecting the negative half-line. Thus

\[
P_+A Q_-A^*P_+=HH^*\succeq0
\]

is the precise positive excursion-return operator. Its trace is the preceding weighted received energy. This realizes the repo's compression identity; positivity belongs to this specific return product, not to arbitrary arithmetic spectral terms.

## 56. The polarized pair kernel retains the transverse observation

Define

\[
\mathsf H_s(T,U)=\int_0^\infty e^{-2st}Z(T+t)\overline{Z(U+t)}dt,
\]
\[
\mathsf K_s(T,U)=\int_0^\infty t e^{-2st}Z(T+t)\overline{Z(U+t)}dt.
\]

Both are positive semidefinite kernels for \(s>\delta\). Their spectral expansions have denominators \((2s-z-\bar w)\) and \((2s-z-\bar w)^2\), respectively. By conjugation symmetry the second can also be written as a nonconjugated ordered two-zero sum.

For real observation origins, set \(C=(T+U)/2\), \(D=(U-T)/2\). The nonconjugated pair exponent becomes

\[
e^{(z+w)C+(w-z)D}.
\]

The coordinates \(\Sigma=z+w\), \(\Delta=w-z\) are jointly invertible: \(z=(\Sigma-\Delta)/2\), \(w=(\Sigma+\Delta)/2\). Setting \(D=0\) forgets the difference coordinate at the level of labels.

The original prose jumped from this coordinate inversion to generic uniqueness of a Laplace transform of a complex planar measure. That implication is not automatic. The safe source-reconstruction theorem is section 57: differentiate the actual Gram kernel to recover \(Z\), then use its actual meromorphic Laplace transform to recover the divisor. Do not use an unproved general moment determinacy theorem to justify a broader claim.

On the arithmetic side, insertion of the actual explicit formula gives a prime–prime term

\[
\sum_{m,n}\frac{\Lambda(m)\Lambda(n)}{\sqrt{mn}}W_{s;T,U}(m,n),
\]
\[
W_{s;T,U}(m,n)=\int_0^\infty t e^{-2st}
 g(T+t-\log m)g(U+t-\log n)dt.
\]

Its support satisfies

\[
|\log(m/n)-(T-U)|\le1.
\]

In \(c=(\log m+\log n)/2\), \(d=(\log n-\log m)/2\), this is \(|d-D|\le1/2\). Thus the second receiver origin selects actual arithmetic rapidity. With \(r=c-C\), \(\eta=d-D\),

\[
W=e^{-2sr}\int_{-r}^\infty(y+r)e^{-2sy}g(y+\eta)g(y-\eta)dy.
\]

The fixed Goldbach shell \(m+n=N\) is \(c=\log[N/(2\cosh d)]\). Restriction to that curved anti-diagonal is another operation; positivity of the complete Gram form does not force each fixed-shell slice positive. Pole/prime/archimedean cross terms also remain part of the complete received square.

For cyclic Hankel products one has

\[
\operatorname{Tr}(H_{s,T_1}\cdots H_{s,T_n})
=\sum_{i_1,\ldots,i_n}
\frac{\prod_r m_{i_r}G(z_{i_r})e^{z_{i_r}T_r}}
{\prod_r(2s-z_{i_r}-z_{i_{r+1}})},\quad i_{n+1}=i_1.
\]

For \(n=1\) this is \(\frac12F_T(s)\); for \(n=2\) the denominator is squared. These are operator-composition cycles, not automatically nontrivial cohomology classes.

## 57. Direct source inverse and the damping-moment Weyl ladder

Set \(\mathcal L_s=2s-\partial_T-\partial_U\). Integration by parts in the common continuation variable gives

\[
\boxed{\mathcal L_s\mathsf H_s=Z(T)\overline{Z(U)},\qquad
\mathcal L_s\mathsf K_s=\mathsf H_s.}
\]

Hence, with derivatives taken before setting \(U=0\),

\[
\boxed{Z(T)=M_0^{-1}\mathcal L_s\mathsf H_s(T,0)
=M_0^{-1}\mathcal L_s^2\mathsf K_s(T,0).}
\]

A real nonzero signal is determined by its polarized kernel up to global sign; \(M_0>0\) fixes the sign. Complex sources have an analogous phase ambiguity. This inverse is exact in a topology retaining its derivatives, not a claimed bounded inverse in a norm that forgets them. It bypasses modal Vandermonde inversion altogether for recovery of the actual source. [S09]

For \(n\ge0\), define

\[
\mathsf G_{n,s}(T,U)=\int_0^\infty t^n e^{-2st}Z(T+t)\overline{Z(U+t)}dt,
\quad\mathsf R=-\tfrac12\partial_s.
\]

Then

\[
\mathsf R\mathsf G_n=\mathsf G_{n+1},\quad
\mathcal L_s\mathsf G_0=Z\otimes\bar Z,\quad
\mathcal L_s\mathsf G_n=n\mathsf G_{n-1},\quad
[\mathcal L_s,\mathsf R]=I,
\]
\[
\boxed{\mathcal L_s^{n+1}\mathsf G_n=n!Z\otimes\bar Z.}
\]

All levels are positive for sufficiently strong damping, without RH. They descend to the same arithmetic boundary source; increasing damping-moment depth does not solve an independent arithmetic problem.

**Regularity guard.** The original fixed packet has only polynomial vertical decay and \(Z\) is known here to have absolutely convergent differentiated zero sums through order two. Do not assert arbitrary classical independent \(T,U\) derivatives of every order. The common-direction integration-by-parts identities have a distributional/resolvent interpretation and can be justified by regularization; a formalization must state that domain explicitly or use a smoother faithful packet with independently proved properties. The first Hardy/Bergman inverse has the necessary declared regularity.

## 58. Hardy/Bergman geometry and exact orbit rank

In the half-plane \(\Omega_s=\{\Re z<s\}\), the Hardy feature is \(\phi_{s,z}(t)=e^{-(s-z)t}\), with

\[
\langle\phi_{s,z},\phi_{s,w}\rangle=(2s-z-\bar w)^{-1}.
\]

The Bergman feature is \(\Phi_{s,z}(t)=\sqrt t\,e^{-(s-z)t}\), with inner product \((2s-z-\bar w)^{-2}\). Put \(d_s(z)=s-\Re z\). Their norms squared are \(1/(2d_s)\) and \(1/(4d_s^2)\). These are the ordinary half-plane Hardy/Bergman kernels up to conventional normalization.

Let \(h_{s,z}\), \(F_{s,z}\) be normalized Hardy and Bergman features. With

\[
\rho_s(z,w)=\frac{|z-w|}{|2s-z-\bar w|},
\]

one has

\[
|\langle h_{s,z},h_{s,w}\rangle|^2=1-\rho_s(z,w)^2,
\quad
|\langle F_{s,z},F_{s,w}\rangle|=1-\rho_s(z,w)^2.
\]

For \(z=\sigma+i\gamma\), \(\theta z=-\sigma+i\gamma\), and any fixed \(s>1/2\),

\[
\langle h_{s,z},h_{s,\theta z}\rangle=\sqrt{1-\sigma^2/s^2},
\quad \det\operatorname{Gram}(h_{s,z},h_{s,\theta z})=\sigma^2/s^2,
\]
\[
\langle F_{s,z},F_{s,\theta z}\rangle=1-\sigma^2/s^2,
\quad \|F_{s,z}-F_{s,\theta z}\|^2=2\sigma^2/s^2.
\]

Thus each orbit's Hardy bivector/rank defect and Bergman descent defect recover \(|\sigma|\) exactly. Under RH all depths equal \(s\) and ordinates lie on the constant-depth horocycle; their overlaps are \(4s^2/[4s^2+(\gamma-\gamma')^2]\) in the Bergman absolute-overlap convention.

A fixed normalized feature map is injective. Its factorization through the actual \(C_2\) reflection quotient is equivalent to \(\theta z=z\) for every zero, hence RH. This is an instance of orbit descent, not a proof that the factorization exists. Extending linearly to the free abelian group gives the coinvariant version. The difference \(b(g,z)=F(gz)-F(z)\) is an actual coboundary, so its cohomology class is always zero; RH asks that the coboundary itself vanish.

## 59. Same defect under holonomy, curvature and weighted operator readings

On \(\mathcal H=\ell^2(\Sigma,m)\), let \(U_ta(z)=e^{-zt}a(z)\). The exact indefinite conservation is \(U_t^*JU_t=J\). With the user's loop orientation,

\[
\boxed{\mathfrak H_t=JU_tJU_t^{-1}
=(U_t^*U_t)^{-1}=\operatorname{diag}(e^{2t\Re z}).}
\]

It obeys \(\mathfrak H_{t+s}=\mathfrak H_t\mathfrak H_s\), \(J\mathfrak H_tJ=\mathfrak H_t^{-1}\), and

\[
\delta=(2|t|)^{-1}\log\|\mathfrak H_t\|,\quad
RH\iff\mathfrak H_t=I\quad(t\ne0).
\]

The reverse orientation gives the inverse positive operator. In the \(J\)-eigenbasis of a nonfixed pair, the generator is \(-i\gamma I-\sigma\left(\begin{smallmatrix}0&1\\1&0\end{smallmatrix}\right)\). Its off-reflection norm is \(|\sigma|\). Vertical frequency is skew; horizontal displacement is the positive-metric mixing channel.

For one packet whose transform is nonzero at every zero,

\[
\|U_tEh\|^2+\|U_{-t}Eh\|^2-2\|Eh\|^2
=4\sum_zm_z|H(z)|^2\sinh^2(t\Re z).
\]

Zero defect for one \(t\ne0\) is equivalent to RH. It is not forced by the indefinite conservation law.

With any declared faithful weights \(w_z=m_z|G(z)|^2\), set \(\mathcal P_G(t)=\sum w_ze^{2t\Re z}\). Then

\[
\mathcal P_G''(0)/4=\sum w_z(\Re z)^2
=s^2\sum w_z\det G^H_{s,z}
=\frac{s^2}{2}\sum w_z\|F_{s,z}-F_{s,\theta z}\|^2.
\]

If the synthesis map from a **distinct-zero unweighted** \(\ell^2\) basis is \(\mathcal Be_z=\sqrt{w_z}F_{s,z}\), then \(\mathcal D=\mathcal B(I-J)\) is Hilbert–Schmidt and \(\|\mathcal D\|_{HS}^2=2s^{-2}\sum w_z(\Re z)^2\). Its squared operator is positive trace class, zero exactly on RH. Using \(\ell^2(\Sigma,m)\) instead requires the normalized basis and corresponding weights. Never count multiplicity both in the index and in \(w_z\).

A discrete logarithmic positive-holonomy homomorphism can be viewed as an \(H^1\) cocycle for a specified trivial action, in which all coboundaries vanish. That construction is different from the feature-difference coboundary above and from an \(H^2\) extension obstruction. Its definition by the unknown horizontal operator does not prove its class vanishes.

## 60. Exact finite and infinite spectral extraction residuals

For distinct modes \(z_i\) and known nonzero amplitudes \(a_i\), a finite two-time Hardy packet kernel has derivative-jet matrix

\[
M_{k\ell}=\partial_T^k\partial_U^\ell H(T,U)|_{T=U=T_0}
=(VQV^*)_{k\ell},
\]
\[
Q_{ij}=(2s-z_i-\bar z_j)^{-1},\quad
V_{ki}=a_i z_i^ke^{z_iT_0},\quad0\le k,\ell<N.
\]

The Vandermonde determinant is

\[
\det V=\left(\prod_i a_ie^{z_iT_0}\right)\prod_{i<j}(z_j-z_i)\ne0,
\]

so \(Q=V^{-1}M(V^{-1})^*\). This assumes the mode/amplitude list. It is not, by itself, a method to discover unknown modes from the derivative matrix. Additional moment/Prony identification would be a separate theorem.

For normalized Hardy atoms, the full finite Gram determinant is

\[
\boxed{\det C_F=\prod_{i<j}\rho_s(z_i,z_j)^2.}
\]

The Schur complement gives the exact new-atom residual

\[
\boxed{\operatorname{dist}(h_{s,z},\operatorname{span}\{h_{s,w}:w\in F\})^2
=\prod_{w\in F}\rho_s(z,w)^2.}
\]

For a fixed distinct actual zero \(z\), the sum \(\sum_{w\ne z}(1-\rho_s(z,w)^2)\) converges by zero counting, and no factor vanishes. Therefore its distance to the closed span of all other distinct atoms is a strictly positive infinite product. Each individual coordinate has a bounded extracting functional.

Uniform stability fails anyway. Known distinct critical-line zeros have arbitrarily small gaps and arbitrarily many members in some unit-height intervals. For two such zeros with gap \(d\),

\[
\lambda_{min}=1-\frac{2s}{\sqrt{4s^2+d^2}}\le\frac{d^2}{8s^2}\to0.
\]

For \(N\) in one unit interval, the all-ones Rayleigh quotient gives \(\lambda_{max}\ge [4s^2/(4s^2+1)]N\). Thus the unweighted normalized family has neither a uniform lower Riesz bound nor a uniform upper Bessel bound. This pathology already occurs among zeros known to satisfy RH, so it cannot characterize off-criticality. Weighted synthesis remains Hilbert–Schmidt; an infinite-rank compact operator cannot have a bounded inverse on its range with the ambient norm. [S09]

## 61. Passivity is supplied work, not squared output

Given the actual even real receiver, define the causal response

\[
y_f(t)=\int_{-\infty}^tZ(t-r)f(r)dr,
\qquad W(f)=\Re\int\overline{f(t)}y_f(t)dt.
\]

Then

\[
\boxed{2W(f)=\iint\overline{f(t)}Z(t-r)f(r)drdt.}
\]

RH is equivalent to \(W(f)\ge0\) for every compact smooth input. Under RH the receiver is the Fourier transform of the positive weights \(m_zG(i\gamma)\); conversely two short pulses with optimally chosen relative sign give limiting work \(M_0-|Z(\tau)|\). The fixed two-packet theorem closes the implication.

Under RH an explicit lossless oscillator realization has \(a_\gamma'=i\gamma a_\gamma+f\), output \(y=\sum c_\gamma a_\gamma\), energy \(\frac12\sum c_\gamma|a_\gamma|^2\), and derivative \(\Re(\bar f y)\). This is a conditional spectral realization, not an unconditional Hilbert–Pólya proof.

The active control \(Z_a(t)=\cosh(at)\), \(a>0\), has finite positive damped Gram kernels of every moment order for \(s>a\), but two opposite impulses yield work \(1-\cosh(a\tau)<0\). Thus positivity of the already-positive completions cannot prove passivity of their boundary descendant. [S10]

The Laplace impedance is

\[
Y(w)=M_0^{-1}\int_0^\infty e^{-wt}Z(t)dt.
\]

Under RH, \(Y=\sum p_\gamma/(w-i\gamma)\), \(p_\gamma>0\), \(\sum p=1\), so

\[
\Re Y(x+iy)=\sum p_\gamma\frac{x}{x^2+(y-\gamma)^2}>0\quad(x>0).
\]

Conversely holomorphic right-half-plane continuation rules out every noncancelled right-of-line pole; functional symmetry gives RH. The positive-real/Stieltjes interpretation is a consequence of this actual spectral structure. The Cayley coefficient \((\alpha-Y)/(\alpha+Y)\) is Schur contractive; its converse must retain the nonconstant germ so that the inverse denominator is not identically zero. Boundary Poisson smoothing recovers \(\sum p_\gamma\delta_\gamma\). Pairing \(\pm\gamma\) gives

\[
\mathcal S(q)=Y(\sqrt q)/\sqrt q=\int_0^\infty\frac{d\mu(\lambda)}{q+\lambda},\quad\lambda=\gamma^2.
\]

A Stieltjes continuation implies RH; complete monotonicity on the positive axis alone is only a necessary differential signature unless the full characterization hypotheses are supplied.

### The explicit impedance formula requires the initial segment

The early formula with the unweighted sum \(\sum_kG(a_k)/(w+a_k)\) is invalid: it diverges. The tail identity for \(Z\) was valid only for \(t>1/2\). Choose \(T>1/2\), and retain the entire prefix

\[
E_T(w)=\int_0^T e^{-wt}[Z(t)-e^{t/2}G(1/2)+S(t)]dt.
\]

The corrected expression is

\[
\boxed{M_0Y(w)=G(w)\frac{\zeta'}\zeta(1/2+w)
+\frac{G(1/2)}{w-1/2}+E_T(w)
-\sum_{k\ge1}\frac{G(a_k)e^{-(w+a_k)T}}{w+a_k}.}
\]

Initially \(\Re w>1/2\), and the last sum converges because \(T>1/2\). The prefix is not a disposable error; it is the exact boundary history that repairs the formula.

## 62. The dyadic pole-annihilating residual and its rigorous all-order inverse

Let \(a=\log2\), \(c=\sqrt2\), and retain the actual prime-shell signal \(S(t)\). Its leading pole mode \(L(t)=e^{t/2}G(1/2)\) obeys \(L(t+a)=cL(t)\). Define

\[
A_m(t)=(T_a-cI)^mS(t),\qquad m\ge1.
\]

Every \(A_m\) is a finite linear combination of finite prime shells. Its Laplace multiplier has a zero at the pole exponent, while at every shifted nontrivial zero the multiplier \(e^{az}-c\) is nonzero because \(\Re z<1/2\). Thus the pole is removed and all nontrivial modes remain observable. [S20]

The higher inversion in [S21] originally invoked only convergence of a normalized sequence, which is insufficient for ordinary unweighted higher-difference sums. [S19] supplies the correct Abel inverse.

For fixed \(t\), set

\[
Y_k=c^{-k}S(t+ka),\quad Y_k\longrightarrow L(t),\quad
\Delta^mY_k=c^{-(k+m)}A_m(t+ka).
\]

The boundary limit follows from the actual zero expansion and dominated convergence using \(\Re z<1/2\), without a uniform gap from that boundary. Put \(x_k=Y_k-L(t)\in c_0\). With the left shift \(T\) on \(c_0\),

\[
B_\rho=(1-\rho)T(I-\rho T)^{-1},\quad\|B_\rho\|\le1,\quad
B_\rho\to0\text{ strongly as }\rho\uparrow1,
\]
\[
(I-\rho T)^{-m}(I-T)^m=(I-B_\rho)^m\to I
\]

strongly. Evaluating the first coordinate gives

\[
\boxed{L(t)-S(t)=(-1)^{m-1}c^{-m}\lim_{\rho\uparrow1}
\sum_{k\ge0}\binom{k+m-1}{m-1}(\rho/c)^k A_m(t+ka).}
\]

For each \(\rho<1\), this is absolutely convergent in the declared sequence representation. If the actual \(A_m\) is bounded on the tail by \(B_m\), \(\rho=1\) also converges absolutely and

\[
\boxed{|L(t)-S(t)|\le(c-1)^{-m}B_m=(\sqrt2+1)^mB_m.}
\]

Thus boundedness of **any one fixed-order actual dyadic residual** implies bounded \(Z\) and RH. The inverse is source-boundary unique: a homogeneous normalized solution is a polynomial sequence of degree at most \(m-1\), and the zero boundary limit removes it.

Retain the exact counterexample to the earlier shortcut: \(x_k=(-1)^k/(k+1)\to0\), but the ordinary \(m=2\) negative-binomial weighted difference sum does not converge. The Abel argument, not “the boundary tends to zero,” is the valid general theorem.

## 63. A direct quantitative Goldbach-scale criterion, without introducing a new receiver

The arithmetic part of [S22] gives a particularly short actual-source route. For \(t>0\),

\[
A(t)=\sum_{n\ge2}\Lambda(n)e^{-nt}>0,\qquad
G_R(t)=\sum_{N\ge4}R(N)e^{-Nt}=A(t)^2.
\]

PNT gives \(tA(t)\to1\). Put

\[
\mathcal G(t)=t^2G_R(t)=(tA(t))^2\to1,
\qquad r_G(t)=\mathcal G(2t)-\mathcal G(t).
\]

The exact criterion is

\[
\boxed{RH\iff\forall\varepsilon>0,\quad
r_G(t)=O_\varepsilon(t^{1/2-\varepsilon})\quad(t\downarrow0).}
\]

Equivalently,

\[
G_R(2t)-\tfrac14G_R(t)=O_\varepsilon(t^{-3/2-\varepsilon}).
\]

For the forward direction, use Mellin inversion

\[
\int_0^\infty A(t)t^{s-1}dt=\Gamma(s)[-\zeta'/\zeta(s)]
\]

and, under RH, shift to \(\Re s=1/2+\varepsilon\) with the gamma decay and actual logarithmic-derivative bounds. For the reverse, telescope dyadically toward zero using \(\mathcal G(0+)=1\) to obtain \(\mathcal G(t)-1=O_\varepsilon(t^{1/2-\varepsilon})\). Positivity of the actual \(tA(t)\) fixes the square root, hence \(A(t)-1/t=O_\varepsilon(t^{-1/2-\varepsilon})\). Subtracting \(1/(s-1)\) in the Mellin integral yields holomorphic continuation to every \(\Re s>1/2\); actual zero poles are excluded.

The dyadic residual of \(Y(t)=tA(t)\) has Mellin multiplier

\[
(2^{-s}-1)\Gamma(s+1)[-\zeta'/\zeta(s+1)].
\]

It annihilates the main pole at \(s=0\) but not any nontrivial zero: the multiplier there is \(2^{1-\rho}-1\ne0\). This is an actual arithmetic ActionResidual, not a generic rephrasing detached from primes.

A finite-prefix version follows from \(R(N)\le N\log^2N\). For

\[
L(t)=\left\lceil\frac{\log(1/t)}t\right\rceil,
\]

one has

\[
t^2\sum_{N>L(t)}R(N)e^{-Nt}=O(t\log^4(1/t)),
\]

smaller than the target error. Thus the criterion can be formulated using explicitly growing finite prefixes plus a proved tail bound. No rate satisfying the criterion is proved unconditionally here.

## 64. One solvable reflection block, with artificial and genuine poles separated

For a nonfixed actual reflection orbit, the generator in the \(J\)-eigenbasis is \(-i\gamma I-\sigma\left(\begin{smallmatrix}0&1\\1&0\end{smallmatrix}\right)\). Retaining the symmetric channel gives first-return kernel \(M_z(t)=\sigma^2e^{-i\gamma t}\) and self-energy

\[
\Sigma_z(\lambda)=\frac{\sigma^2}{\lambda+i\gamma}.
\]

The exact resolved resolvent and time evolution are

\[
\boxed{R_{++}(\lambda)=\frac{\lambda+i\gamma}{(\lambda+i\gamma)^2-\sigma^2},
\qquad K_z(t)=e^{-i\gamma t}\cosh(\sigma t).}
\]

Let \(d=\lambda+i\gamma\). The intermediate \(\sigma^2/d\) has a pivot pole at \(d=0\), but for \(\sigma\ne0\) the full inverse there is \(\left(\begin{smallmatrix}0&1/\sigma\\1/\sigma&0\end{smallmatrix}\right)\). That singularity is removable from the full source problem. The poles \(d=\pm\sigma\) are genuine and have resolved residue \(1/2\). For \(\sigma=0\), the actual fixed orbit has a neutral \(1/d\) pole and no independent antisymmetric coordinate.

Across all actual orbits, \(\Sigma(1)=0\iff RH\). Its real part is nonnegative on the right half-plane even when \(\sigma\ne0\), but it is **subtracted** as a positive-feedback term in the resolved denominator. Positive self-energy is not a dissipation proof. These facts are the exact finite reflection instance of the same source-retaining block normal form used on NS. [S17–S18]
