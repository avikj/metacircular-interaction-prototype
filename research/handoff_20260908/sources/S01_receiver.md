# A Faithful Prime-Boundary Receiver and a Navier–Stokes Continuation Obstruction

## Status and dependency boundary

Date: 6 September 2026.

Repository source reads are pinned to commit `64effa62411bad3c12d513b2df5a1e5e55946afb` of `avikj/metacircular-interaction-prototype`. These are mathematical derivations, not newly compiled Agda or Lean modules. The accompanying SymPy scripts verify finite algebraic identities only. Neither the Riemann hypothesis nor global Navier–Stokes regularity is proved here. No novelty-priority claim is made.

The repository inputs inspected are `formal/lean/Pairfield/VonMangoldtTriangularReconstruction.lean`, `GoldbachReconstructionChain.lean`, and `VandermondeFrequencyResponse.lean`; `formal/cubical/theorems/automata/ObservableInterface.agda`; `formal/cubical/theorems/physics/DefectCalculus.agda`; and `formal/cubical/kernel/SankramanaShreni_TheLocalizationSequenceAsOneObjectMeaningDescendsAndCostDoesNot.agda`.

The arithmetic reconstruction theorem supplies the von Mangoldt sequence and its logarithmic-derivative Dirichlet series only in the Euler half-plane. Analytic continuation, the functional equation, the classical explicit formula, and the standard zero-counting bound are separate classical inputs. An authoritative statement of the explicit formula used below is E. Bombieri, *Problems of the Millennium: the Riemann Hypothesis*, §V, Clay Mathematics Institute.

The observer interface preserves observations under a declared relation; state reconstruction is a separate property. In particular, `DefectCalculus.noEquiv→badFibre` has the constructive type “non-equivalence implies that universal fibre contractibility is impossible.” It does not, by itself, select a particular noncontractible fibre. Section 5 below supplies explicit distinct elements in a concrete observation fibre.

## 1. An elementary receiver with a quantified nonvanishing response

Use additive convolution on the real line. Define

\[
q(s)=4\mathbf 1_{[0,1/4]}(s),\qquad b=q*q*q*q,\qquad h(s)=e^{-s}b(s-1).
\]

Then \(b\) is a nonnegative, mass-one, compactly supported cubic B-spline, with support \([0,1]\) and regularity \(C^2\). Thus \(h\) is nonnegative, \(C_c^2(\mathbb R)\), and supported in \([1,2]\). It is piecewise smooth, which is sufficient for the explicit formula and the absolute zero-sum convergence used here. No \(C^\infty\) assumption is needed.

An entirely finite expression is

\[
b(s)=\frac{256}{6}\sum_{j=0}^{4}(-1)^j\binom4j(s-j/4)_+^3.
\]

Let

\[
H(z)=\int_{\mathbb R}h(s)e^{-zs}\,ds.
\]

Taking the Laplace transform of the four convolutions gives the entire function

\[
\boxed{
H(z)=e^{-(z+1)}
\left(\frac{1-e^{-(z+1)/4}}{(z+1)/4}\right)^4.
}
\]

The apparent singularity at \(z=-1\) is removable, with \(H(-1)=1\). Every zero is of the form

\[
z=-1+8\pi i k,\qquad k\in\mathbb Z\setminus\{0\}.
\]

Consequently \(H(z)\ne0\) whenever \(\Re z>-1\), in particular at every shifted nontrivial zeta zero \(\rho-1/2\).

### Proposition 1: quantitative response bounds

There are positive absolute constants \(c,C\) such that

\[
\frac{c}{(1+\gamma^2)^2}
\le |H(\sigma+i\gamma)|
\le \frac{C}{(1+\gamma^2)^2}
\qquad(-1/2\le\sigma\le1/2).
\]

Indeed, write \(a=1+\sigma\in[1/2,3/2]\). Then

\[
1-e^{-1/8}\le |1-e^{-a/4}e^{-i\gamma/4}|\le1+e^{-1/8}.
\]

More explicitly,

\[
\frac{256e^{-3/2}(1-e^{-1/8})^4}{(\gamma^2+9/4)^2}
\le |H(\sigma+i\gamma)|
\le
\frac{256e^{-1/2}(1+e^{-1/8})^4}{(\gamma^2+1/4)^2}.
\]

Thus convolution by \(h\), on the usual Sobolev spaces, is an isomorphism

\[
H^s(\mathbb R)\longrightarrow H^{s+4}(\mathbb R).
\]

This is a quantified inverse with a four-derivative loss. It is not a claim that an unbounded arithmetic input already belongs to a particular global Sobolev space.

### Exact finite response stencil

In distributions,

\[
(D+1)^4h
=256\sum_{j=0}^{4}(-1)^j\binom4j e^{-(1+j/4)}\delta_{1+j/4}.
\]

Equivalently,

\[
H(z)=256e^{-1}e^{-z}(z+1)^{-4}
\left(1-e^{-1/4}e^{-z/4}\right)^4.
\]

The finite response polynomial is exactly \((1-rw)^4\), with \(r=e^{-1/4}\) and \(w=e^{-z/4}\). This is an explicit instance of the repository's frequency-response construction: the phase and real scale factor are retained together. Its nonvanishing follows from \(|rw|<1\) throughout the shifted critical strip. The damping is in the receiver; it changes modal amplitudes, not the scale-growth exponent of a zeta mode.

## 2. The finite arithmetic scale trace

Let \(\Lambda\) be the von Mangoldt function and

\[
R(N)=\sum_{a+b=N}\Lambda(a)\Lambda(b).
\]

The repository supplies the triangular reconstruction

\[
\Lambda(2)=\sqrt{R(4)}=\log2,
\qquad
\Lambda(n)=\frac{R(n+2)-I_n(\Lambda)}{2\log2}\quad(n\ge3),
\]

where \(I_n\) involves only indices smaller than \(n\). Finite induction therefore reconstructs \(\Lambda(2),\ldots,\Lambda(M)\) from \(R(4),\ldots,R(M+2)\). This statement concerns exact quantitative data known to be in the convolution map's image, not arbitrary positive sequences or existence-only Goldbach data.

Define, for real \(t\),

\[
\boxed{
B(t)=\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}h(t-\log n)
-e^{t/2}H(1/2).
}
\]

Only integers in the shell

\[
e^{t-2}\le n\le e^{t-1}
\]

contribute. For \(M(t)=\max\{2,\lfloor e^{t-1}\rfloor\}\), the prefix through \(R(M(t)+2)\) suffices. The complete observation is the trajectory \(t\mapsto B(t)\), not one scalar measured at one time.

### Proposition 2: exact Laplace identity

For \(\Re w>1/2\),

\[
\boxed{
\int_0^\infty e^{-wt}B(t)\,dt
=H(w)\left[-\frac{\zeta'}{\zeta}(1/2+w)\right]
-\frac{H(1/2)}{w-1/2}.
}
\]

For each summand, substitute \(s=t-\log n\). Its integral is \(n^{-w}H(w)\). Absolute convergence in the indicated half-plane permits interchange with the von Mangoldt Dirichlet series. Integrating the subtracted exponential gives the last term. This derivation uses only the Euler half-plane identity. The pole at \(w=1/2\) cancels.

The complete trajectory also reconstructs the arithmetic Dirichlet series:

\[
-\frac{\zeta'}{\zeta}(s)
=
\frac{\mathcal L B(s-1/2)+H(1/2)/(s-1)}{H(s-1/2)}
\qquad(\Re s>1).
\]

Uniqueness of Dirichlet coefficients then recovers \(\Lambda\), hence \(R\). This is a lossless whole-trajectory statement, not a finite-data inversion of the infinite arithmetic sequence.

## 3. Exact off-critical growth and a single-receiver RH criterion

Let \(\rho\) range over distinct nontrivial zeros, with multiplicity \(m_\rho\). Define

\[
\Theta=\sup_\rho\Re\rho.
\]

The classical location and symmetry theorems give \(1/2\le\Theta\le1\).

### Proposition 3: smoothed explicit formula with all trivial terms retained

For \(t>2\),

\[
\boxed{
B(t)=
-\sum_\rho m_\rho H(\rho-1/2)e^{(\rho-1/2)t}
-\sum_{k=1}^\infty H(-2k-1/2)e^{(-2k-1/2)t}.
}
\]

Both series are absolutely convergent at each such \(t\).

To obtain this directly from Weil's formula, use

\[
f_t(x)=x^{-1/2}h(t-\log x).
\]

Its support is contained in \((1,\infty)\), and its Mellin transform is

\[
\widetilde f_t(s)=e^{(s-1/2)t}H(s-1/2).
\]

The terms \(f_t(1/n)\) and \(f_t(1)\) vanish. The archimedean integral becomes

\[
\int_1^\infty\frac{f_t(x)}{x-x^{-1}}\,dx
=\sum_{k=0}^\infty\widetilde f_t(-2k).
\]

Its \(k=0\) term cancels the \(\widetilde f_t(0)\) term on the other side of Weil's formula. The remaining terms give exactly the displayed identity. Thus no archimedean or trivial-zero contribution has been silently discarded.

The nontrivial-zero series converges absolutely because Proposition 1 gives a fourth-order vertical decay and the number of zeros through height \(T\) is \(O(T\log T)\). For the trivial zeros, support in \([1,2]\) gives

\[
\left|\sum_{k\ge1}H(-2k-1/2)e^{(-2k-1/2)t}\right|
\le
\|h\|_1\frac{e^{-(5/2)(t-2)}}{1-e^{-2(t-2)}}.
\]

In particular, this term is bounded for \(t\ge3\) and decays exponentially.

### Theorem 4: exact growth exponent

\[
\boxed{
\limsup_{t\to\infty}\frac{\log(1+|B(t)|)}{t}
=\Theta-\frac12.
}
\]

**Upper bound.** Proposition 3 and absolute summability give

\[
|B(t)|\le C_0e^{(\Theta-1/2)t}+C_1e^{-(5/2)(t-2)}
\quad(t\ge3).
\]

**Lower bound.** If the displayed limsup were smaller than \(\Theta-1/2\), choose a nonnegative number \(c\) strictly between them. Then \(B(t)=O(e^{ct})\), so its Laplace transform is holomorphic in \(\Re w>c\). Proposition 2 identifies this holomorphic function with a meromorphic function. By the definition of the supremum, some zero satisfies \(\Re\rho-1/2>c\). The meromorphic expression has there a pole at \(w=\rho-1/2\) with residue

\[
-m_\rho H(\rho-1/2)\ne0.
\]

This contradicts holomorphy. No rightmost zero is assumed to attain the supremum. When \(\Theta=1/2\), the nonnegative limsup and the upper bound already give equality.

### Corollary 5: equivalent forms of RH

\[
\boxed{
\mathrm{RH}
\iff B(t)=O(1)
\iff \forall\varepsilon>0,\ B(t)=O_\varepsilon(e^{\varepsilon t}).
}
\]

Subexponential growth forces \(\Theta=1/2\), and the functional equation excludes zeros to the left as well. Conversely, on RH the nontrivial-zero series in Proposition 3 is an absolutely and uniformly convergent sum of pure phases; hence it is bounded.

### Corollary 6: recovery of the zero multiset under RH

On RH,

\[
B(t)=-\sum_\gamma m_\gamma H(i\gamma)e^{i\gamma t}+o(1).
\]

The first term is uniformly almost periodic. For every real \(\omega\),

\[
\lim_{T\to\infty}\frac1T\int_0^T B(t)e^{-i\omega t}\,dt
=
\begin{cases}
-m_\omega H(i\omega),&\zeta(1/2+i\omega)=0,\\
0,&\text{otherwise}.
\end{cases}
\]

Uniform summability justifies exchanging the average and series; the trivial-zero remainder contributes zero to the limiting average. Since \(H(i\omega)\ne0\), all ordinates and multiplicities are recovered. The response attenuation is quantitatively fourth order, rather than an uncontrolled smoothing loss.

These are exact reconstruction and obstruction results. They do not establish the missing bound \(B(t)=O(1)\) from the arithmetic input.

## 4. The receiver is one fixed boundary profile of the finite prime operator

On \(L^2([0,t])\), extend functions by zero and let

\[
(S_af)(x)=\mathbf1_{[0,t]}(x-a)f(x-a),
\qquad
P_t=\sum_{\log n<t}\frac{\Lambda(n)}{\sqrt n}
(S_{\log n}+S_{\log n}^*).
\]

Define the real boundary profile

\[
f(s)=e^{-s}(q*q)(s-1/2).
\]

Its support is \([1/2,1]\), and \(h=f*f\). Place it at the two ends by

\[
(J_t^-f)(x)=f(x),\qquad(J_t^+f)(x)=f(t-x).
\]

For \(t>2\), the supports are separated. The reverse-shift contribution is zero, while direct substitution gives

\[
\langle J_t^+f,S_aJ_t^-f\rangle=h(t-a).
\]

Consequently

\[
\boxed{
B(t)=\langle J_t^+f,P_tJ_t^-f\rangle-e^{t/2}H(1/2).
}
\]

The same fixed profile is used at both boundaries, for every scale. The pole term is the rank-one boundary contribution because \(H(1/2)=F(1/2)^2\), where \(F\) is the Laplace transform of \(f\). The result identifies a specific matrix coefficient; it does not infer a global operator-norm bound or an unconditional self-adjoint realization of the zeta zeros from that coefficient.

## 5. Navier–Stokes: positive detection is not pairwise reconstruction

### Lemma 7: the secant criterion

For a linear map \(O:V\to W\) and subset \(C\subseteq V\),

\[
O|_C\text{ is injective}
\iff \ker O\cap(C-C)=\{0\}.
\]

This follows by writing \(O(c_1)=O(c_2)\) as \(c_1-c_2\in\ker O\). It is stronger than \(\ker O\cap C=\{0\}\). For the cone of positive semidefinite matrices, every symmetric matrix is a difference of two positive semidefinite matrices. A positive-cone kernel theorem therefore does not automatically prove full reconstruction on the cone.

### Theorem 8: explicit realizable positive stresses with identical scalar observations and different coarse futures

Work on the normalized torus \((\mathbb R/2\pi\mathbb Z)^3\), with viscosity \(\nu>0\), amplitude \(A>0\), integer \(N\ge2\), and \(\sigma\in\{+1,-1\}\). Take

\[
u^\sigma(x,0)=A e_2\cos(Nx_1)
+\sigma A e_3\cos(x_2-Nx_1).
\]

These divergence-free initial data generate explicit globally smooth triangular solutions. Set

\[
a(x_1,t)=Ae^{-\nu N^2t}\cos(Nx_1),
\]

and solve the linear advection–diffusion equation

\[
\partial_tv+a(x_1,t)\partial_2v
=\nu(\partial_1^2+\partial_2^2)v,
\qquad v(x_1,x_2,0)=A\cos(x_2-Nx_1).
\]

Then \(u^\sigma=(0,a,\sigma v)\), with constant pressure, solves unforced three-dimensional Navier–Stokes. The coefficient \(a\) is globally smooth and bounded, and the scalar linear equation has a global smooth periodic solution. Direct substitution verifies the reduction. This construction is not a singular solution and involves different fine initial data.

Let \(P=P_{\le1}\) be the exact Fourier projection and \(U^\sigma=Pu^\sigma\). At time zero,

\[
U^+=U^-=0.
\]

The resolved stresses are

\[
\boxed{
R^\sigma=P(u^\sigma\otimes u^\sigma)-U^\sigma\otimes U^\sigma
=\frac{A^2}{2}
\begin{pmatrix}
0&0&0\\
0&1&\sigma\cos x_2\\
0&\sigma\cos x_2&1
\end{pmatrix}.
}
\]

This formula follows from the two cosine-square identities and the cross-frequency relation \((N,0,0)+(-N,1,0)=(0,1,0)\). The eigenvalues are \(0\) and \((A^2/2)(1\pm\cos x_2)\); both stresses are pointwise positive semidefinite. A sharp Fourier projection does not produce positive covariance for every input; positivity is verified explicitly for this example.

At time zero both states have the same coarse velocity, pressure, active-pressure source, stress trace, and resolved energy flux:

\[
U^\sigma=0,\quad p^\sigma=0,\quad
\partial_i\partial_jR^\sigma_{ij}=0,\quad
\operatorname{tr}R^\sigma=A^2,\quad
-R^\sigma:\nabla U^\sigma=0.
\]

Nevertheless,

\[
\nabla\cdot R^\sigma=-\frac{\sigma A^2}{2}e_3\sin x_2
\]

is already solenoidal and resolved. The filtered momentum equation gives

\[
\boxed{
\partial_tU^\sigma(0)=\frac{\sigma A^2}{2}e_3\sin x_2.
}
\]

Thus the two positive stresses occupy the same scalar-observation fibre but determine opposite coarse accelerations. Their difference is an indefinite secant direction. There is no contradiction with a theorem detecting each nonzero positive stress relative to zero: the common energy reading is positive, not zero.

The fine scalar energy densities and dissipation densities of these two solutions agree even at later times, because their velocities differ only by the sign of the third component. No uniqueness failure for the same full initial datum is asserted.

### An explicit continuation receiver

Choose the divergence-free resolved test

\[
w(x)=e_3\sin x_2.
\]

Normalized integration gives

\[
\langle\partial_tU^\sigma(0),w\rangle=\frac{\sigma A^2}{4},
\qquad
\int(R^+-R^-):\nabla w\,dx=\frac{A^2}{2}\ne0.
\]

This is a concrete contextual separator. On the two-element domain of these solutions, the common scalar observation identifies both points, whereas the two-valued acceleration-sign reading separates them. That is a direct mathematical instance of the repository's descent/non-descent mechanism.

More generally, for the finite-dimensional space \(H_K\) of resolved divergence-free vector fields,

\[
\sup_{w\in H_K,\ \|w\|_2\le1}
\left|\int R:\nabla w\,dx\right|
=\|\mathbb P P_{\le K}\nabla\cdot R\|_2.
\]

The equality is integration by parts followed by Hilbert-space duality. The right side is the complete resolved solenoidal forcing, not the full stress. Adding these tests therefore reconstructs precisely the dynamically relevant instantaneous forcing quotient; it does not by itself control the time evolution of the unresolved stress.

## 6. Renormalized ancestry includes the scaling of the budget

Under parabolic blow-up rescaling around \((x_0,T_*)\),

\[
u_r(x,s)=r\,u(x_0+rx,T_*+r^2s),
\qquad p_r(x,s)=r^2p(x_0+rx,T_*+r^2s).
\]

Its gradient is \(r^2\nabla u\), and the space–time Jacobian is \(r^{-5}\). Consequently

\[
\boxed{
\int_{Q_1}|\nabla u_r|^2\,dx\,ds
=\frac1r\int_{Q_r}|\nabla u|^2\,dx\,dt.
}
\]

With compatible filtering, stresses, solenoidal forces, and fluxes scale respectively as \(r^2\), \(r^3\), and \(r^4\); integrated flux has the same \(r^{-1}\) prefactor as integrated dissipation.

A fixed positive normalized observation at scale \(r_j=2^{-j}\) therefore costs only order \(r_j\) in the physical dissipation budget. The sum \(\sum_jr_j\) is finite. Merely detecting a nonzero normalized event on every scale cannot contradict finite physical dissipation.

An explicit measure demonstrates the logical point. In \(Q_1=B_1\times(-1,0)\), let

\[
d\mu=(|x|^2+|t|)^{-2}\,dx\,dt.
\]

It is a finite positive measure with \(\mu(Q_1)=\pi^2\), and satisfies exactly

\[
\mu(Q_r)=r\mu(Q_1),\qquad0<r\le1.
\]

Hence every normalized reading \(r^{-1}\mu(Q_r)\) is the same positive number although the total measure is finite. This is not an NS-realizability claim. It refutes an inference from finite measure alone, and isolates the additional scale-critical depletion or rigidity input that a regularity argument needs.

## 7. Resulting theorem graph

The RH branch is

\[
\text{quantitative pairfield prefix}
\longrightarrow\Lambda\text{ prefix}
\longrightarrow\text{fixed boundary receiver trace }B
\longrightarrow\text{exact spectral growth exponent }\Theta-1/2.
\]

The receiver is explicitly nonvanishing and quantitatively invertible. The decisive remaining arithmetic estimate is \(B(t)=O(1)\), equivalently subexponential growth for every positive exponent. Its proof is not supplied by lossless reconstruction or by the receiver's multiplier bounds.

The NS branch is

\[
\text{fine solution}
\longrightarrow\text{positive stress and scalar observations}
\longrightarrow\text{realizable secant fibre}
\longrightarrow\text{solenoidal continuation response}.
\]

The explicit pair proves that scalar positive-defect detection is insufficient for continuation reconstruction. The adjoint tests repair the instantaneous forcing observation, but a singularity exclusion still requires a scale-compatible estimate controlling coherent nonlinear evolution and its correctly rescaled budgets. No emptiness theorem for the complete singular continuation fibre is established here.
