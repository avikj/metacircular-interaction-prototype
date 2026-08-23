# Prime Pair Field — Fields-Medal / Cross-Mathematics Delta 08

Date: 2026-08-11

Status: research delta. The finite Hahn-diagonal identities below are **V1** with complete derivations. Standard Hahn spectral facts are known prior art. The proposed certificate and two-boundary programs are open.

## 0. Executive result: every Goldbach diagonal carries an exact finite Hodge/wave geometry

Fix `N` and view the one-body arithmetic signal on the finite interval

\[
a_N(m)=\Lambda(m),\qquad 0\le m\le N,
\]

with `Lambda(0)=0`. The sum involution is reflection

\[
(R_Nf)(m)=f(N-m).
\]

Then the Goldbach coefficient is exactly

\[
r(N)=\langle a_N,R_Na_N\rangle.
\]

There is a canonical self-adjoint second-order difference operator along the diagonal `m+(N-m)=N`:

\[
(L_Nf)(m)
=(m+1)(N-m)[f(m+1)-f(m)]
+m(N-m+1)[f(m-1)-f(m)],
\]

with missing boundary terms omitted. Its eigenfunctions are the symmetric Hahn polynomials and its eigenvalues are

\[
-j(j+1),\qquad j=0,1,\ldots,N.
\]

Reflection acts on the `j`th mode by `(-1)^j`. Therefore Goldbach is an alternating spectral-energy sum:

\[
\boxed{
r(N)=\sum_{j=0}^N(-1)^j|\widehat a_N(j)|^2.
}
\]

Equivalently, it is an antipodal wave-propagator matrix coefficient for the finite angular Casimir. This turns the original “diagonal” intuition into a literal finite spectral geometry.

---

## 1. KNOWN / VERIFIED: the symmetric Hahn operator

Define

\[
Q_j(m;N)
={}_3F_2\!\left(
\begin{matrix}-j,\ j+1,\ -m\\1,\ -N\end{matrix};1
\right),
\qquad 0\le j,m\le N.
\]

These are the Hahn polynomials with parameters `alpha=beta=0`. Their orthogonality weight on `{0,...,N}` is uniform.

They satisfy

\[
L_NQ_j=-j(j+1)Q_j.
\]

The operator is reversible for counting measure because the edge conductance between `m` and `m+1` is

\[
c_m=(m+1)(N-m),
\]

which appears as the upward rate from `m` and the downward rate from `m+1`.

The Hahn reflection symmetry gives

\[
\boxed{
Q_j(N-m;N)=(-1)^jQ_j(m;N).
}
\]

Since the spectrum is simple, the same identity also follows from the facts that `L_N` commutes with reflection and that the degree-`j` leading term changes by `(-1)^j`.

Standard prior art: the Hahn birth–death process is the finite quadratic-rate lattice approximation of the Jacobi diffusion, with eigenvalues `-j(j+alpha+beta+1)`.

---

## 2. V1: exact Dirichlet form and finite primitive negativity

For the counting-measure inner product,

\[
\langle f,g\rangle=\sum_{m=0}^N f(m)\overline{g(m)},
\]

a summation-by-parts calculation gives

\[
\boxed{
-\langle f,L_Nf\rangle
=
\sum_{m=0}^{N-1}
(m+1)(N-m)|f(m+1)-f(m)|^2
\ge0.
}
\]

Constants are the `j=0` kernel. On the full mean-zero subspace,

\[
-\langle f,L_Nf\rangle\ge2\|f\|_2^2,
\]

because the first nonzero eigenvalue is `1*2=2`.

On the reflection-even mean-zero subspace, only even `j` occur, so the first allowed mode is `j=2` and

\[
\boxed{
-\langle f,L_Nf\rangle\ge6\|f\|_2^2
\quad
(f(N-m)=f(m),\ \sum_mf(m)=0).
}
\]

This is the exact finite-diagonal analogue of Hodge-index negativity on primitive symmetric classes. It is a theorem about the ambient diagonal geometry, not yet an arithmetic bound on the prime field.

The extremal `j=2` mode can be normalized as

\[
\boxed{
Q_{2,N}(m)
=
1-\frac{6m(N-m)}{N(N-1)}
\qquad(N\ge2).
}
\]

It has zero mean, reflection symmetry, and eigenvalue `-6`. As `N` grows it tends to

\[
P_2\!\left(\frac{N-2m}{N}\right)
=1-\frac{6m(N-m)}{N^2}.
\]

Thus the continuous Jacobi primitive operator of Delta 07 is the scaling limit of an exact operator on each arithmetic diagonal.

---

## 3. V1: reflection is a function of the angular Casimir

Let

\[
A_N=-L_N\ge0
\]

and define the angular number operator by spectral calculus:

\[
\mathcal N_N
=
\frac{\sqrt{1+4A_N}-1}{2}.
\]

On the `j`th Hahn mode,

\[
\mathcal N_NQ_j=jQ_j.
\]

Therefore

\[
\boxed{
R_N=(-1)^{\mathcal N_N}
=
\cos\!\left[
\frac\pi2\left(\sqrt{1+4A_N}-1\right)
\right].
}
\]

So reflection across the Goldbach diagonal is antipodal propagation at angle `pi` for the finite angular momentum operator.

For any vector `a` with normalized Hahn coefficients `a_hat(j)`, this yields

\[
\boxed{
\langle a,R_Na\rangle
=
\sum_{j=0}^N(-1)^j|\widehat a(j)|^2.
}
\]

Taking `a=a_N=Lambda|_[0,N]` gives the exact Goldbach identity in the executive summary. Taking `a=1_P` gives the literal unweighted prime-pair count.

This must not be confused with Liouville parity. The sign `(-1)^j` is **angular/reflection parity**, while `lambda(n)=(-1)^{Omega(n)}` is **internal factorization parity**.

---

## 4. V1: Goldbach as the zero-time boundary of a strictly positive heat correlation

For `tau>=0`, define

\[
r_\tau(N)
=
\langle a_N,e^{-\tau A_N}R_Na_N\rangle
=
\sum_{j=0}^N
(-1)^je^{-\tau j(j+1)}|\widehat a_N(j)|^2.
\]

Because `e^{-tau A_N}=e^{tau L_N}` is the transition semigroup of an irreducible birth–death process and `R_N` is a permutation,

\[
e^{-\tau A_N}R_N
\]

has strictly positive matrix entries for every `tau>0`.

Hence, for any nonzero nonnegative arithmetic signal `a_N`,

\[
\boxed{
r_\tau(N)>0\qquad(\tau>0).
}
\]

At the sharp boundary,

\[
\lim_{\tau\downarrow0}r_\tau(N)=r(N).
\]

Thus every positive-time angular smoothing makes the Goldbach correlation positive for a trivial positivity-preserving reason. The arithmetic difficulty is entirely the singular boundary trace `tau=0`.

This is a finite-dimensional diagonal counterpart of the program's smoothing-trivialization theorem: smoothing is not the arithmetic victory; uniform control while removing the smoothing is.

### Exact error certificate

Since `1-e^{-tau lambda}<=tau lambda`,

\[
|r_\tau(N)-r(N)|
\le
\tau\langle a_N,A_Na_N\rangle.
\]

Therefore

\[
\boxed{
r(N)
\ge
r_\tau(N)
-
\tau\sum_{m=0}^{N-1}
(m+1)(N-m)|\Lambda(m+1)-\Lambda(m)|^2.
}
\]

A sufficient Goldbach certificate is

\[
r_\tau(N)>
\tau\langle a_N,A_Na_N\rangle.
\]

For the raw von Mangoldt signal the Dirichlet energy is likely far too large, so this is presently a calibration theorem, not a proof method. It precisely identifies the quantity a successful angular smoothing argument must improve.

---

## 5. V1: Poisson continuation and the angular spectral polynomial

For `|q|<=1`, define

\[
\mathcal G_N(q)
=
\langle a_N,q^{\mathcal N_N}a_N\rangle
=
\sum_{j=0}^N q^j|\widehat a_N(j)|^2.
\]

The coefficients are nonnegative. For `0<q<1`, write `q=e^{-u}`. Since

\[
\lambda\mapsto\frac{\sqrt{1+4\lambda}-1}{2}
\]

is a Bernstein function, `q^{mathcal N_N}` is a subordinated positive Markov semigroup. Hence `mathcal G_N(q)>0` for nonzero `a_N>=0`.

At the opposite boundary point,

\[
\boxed{
\mathcal G_N(-1)=r(N).
}
\]

Therefore

\[
\boxed{
\text{Goldbach failure at }N
\iff
(1+q)\text{ divides the angular energy polynomial }\mathcal G_N(q).
}
\]

This is another exact `Phi_2` boundary zero in the program. It is not automatically the same invariant as:

- the local charge factor `1+z` at `p=2k-1`;
- the polynomial involution/resultant `x -> -x`;
- Liouville parity.

It does, however, show that the sharp sum-diagonal obstruction is itself a cyclotomic boundary-evaluation problem for a polynomial with nonnegative spectral coefficients.

---

## 6. V1: two independent gradings — internal factorization charge and external angular momentum

The program now has two exact integer gradings.

### Internal grading

\[
r=\Omega(n),
\qquad
(-1)^r=\lambda(n).
\]

Its scale evolution is the charge-deformed Buchstab semigroup.

### External grading

\[
j=\text{Hahn/Jacobi relative degree on the fixed-sum diagonal},
\qquad
(-1)^j=R_N.
\]

Its smoothing evolution is the Hahn heat/Poisson semigroup.

These gradings answer different questions:

- `Omega` asks how many multiplicative atoms occupy a leg;
- `j` asks how rapidly the one-body signal varies in the relative position along an additive diagonal.

The prime-pair problem couples them. The hard boundary is not one parity but a corner where both kinds of information become sharp.

---

## 7. V1: a finite two-charge / angular partition function

Let `rho_y(n)` be a finite roughness indicator and define the two-leg charge-deformed vectors

\[
v_{y,z}(m)=\rho_y(m)z^{\Omega(m)}.
\]

For independent fugacities `z_1,z_2` and angular parameter `q`, define

\[
\boxed{
\mathcal Z_{N,y}(z_1,z_2;q)
=
\langle v_{y,z_1},q^{\mathcal N_N}v_{y,z_2}\rangle.
}
\]

At the angular boundary `q=-1`,

\[
\mathcal Z_{N,y}(z_1,z_2;-1)
=
\sum_{m=0}^N
\rho_y(m)\rho_y(N-m)
 z_1^{\Omega(m)}z_2^{\Omega(N-m)}.
\]

Thus it is exactly the rough two-leg factorization-charge generating function on the Goldbach diagonal.

In a Buchstab cell where

\[
1_{\mathbb P}(n)=\rho_y(n)\frac{1-\lambda(n)}2,
\]

the prime-pair count is the Walsh extraction

\[
\boxed{
G_N
=
\frac14\Big[
\mathcal Z(1,1;-1)
-\mathcal Z(-1,1;-1)
-\mathcal Z(1,-1;-1)
+\mathcal Z(-1,-1;-1)
\Big],
}
\]

with the interval/cell hypotheses required for the one-leg projector.

This is the exact finite model of the two-boundary architecture:

- finite/internal charged variables `z_i`;
- archimedean/external angular variable `q`;
- positive/smoothed interior;
- prime pairs at the charged antipodal corner.

At a finite place, the local equilibrium factors `I_{p,H}(z_1,z_2)` control the internal fugacities. At the real place, the Hahn/Jacobi semigroup controls `q`. The global problem requires a compatible boundary lift in both directions.

---

## 8. V1: pair-field Hodge decomposition on the diagonal

Restrict the pair field itself:

\[
f_N(m)=\Lambda(m)\Lambda(N-m).
\]

It is reflection-even. Decompose

\[
f_N=\overline f_N+f_N^\circ,
\qquad
\overline f_N=\frac{r(N)}{N+1}.
\]

Then `f_N^circ` lies entirely in even modes `j=2,4,...` and satisfies

\[
\boxed{
-\langle f_N^\circ,L_Nf_N^\circ\rangle
\ge6\|f_N^\circ\|_2^2.
}
\]

The first primitive coefficient is

\[
R_2(N)
=
\sum_{m=0}^N
\Lambda(m)\Lambda(N-m)
\left[1-\frac{6m(N-m)}{N(N-1)}\right].
\]

This observable annihilates the uniform bulk on the diagonal. In a continuous explicit formula its archimedean multiplier is the `j=2` continuous-Hahn factor from Delta 07.

For RH zeros, with

\[
s=1+i\Sigma,
\qquad
\Delta=\gamma-\gamma',
\]

the `j=2` beta multiplier simplifies to

\[
\boxed{
\frac{I_2}{B}
=
\frac{1+\Sigma^2-3\Delta^2}
{2(1+i\Sigma)(2+i\Sigma)}.
}
\]

Thus the first symmetric primitive channel gives an explicit indefinite quadratic separation of zero sums and zero differences.

No sign theorem for the arithmetic `R_2(N)` is currently known.

---

## 9. Viazovska / Delsarte reformulation: a finite magic-polynomial hierarchy

Because

\[
R_N=F_N(A_N)
\]

with spectral values `F_N(j(j+1))=(-1)^j`, any polynomial or rational function `q(lambda)` satisfying

\[
q(j(j+1))\le(-1)^j
\qquad(0\le j\le N)
\]

gives the operator inequality

\[
q(A_N)\le R_N.
\]

Therefore

\[
r(N)\ge\langle a_N,q(A_N)a_N\rangle.
\]

The simplest universal minorant is

\[
q(\lambda)=1-\lambda,
\]

since it equals `1,-1` at `j=0,1` and lies below the alternating target thereafter. It reproduces the crude certificate

\[
r(N)\ge\|a_N\|_2^2-\langle a_N,A_Na_N\rangle.
\]

The serious target is a degree-`d` extremal minorant supplemented by a controlled high-Hahn-mode tail. This is a finite Delsarte/linear-programming analogue of a Viazovska magic-function construction:

1. interpolate the antipodal sign on the low spectrum;
2. enforce a global spectral minorant;
3. express `q(A_N)` through finitely many local difference moments;
4. prove its arithmetic quadratic form positive.

Degree `N` interpolation is tautological. Value requires `d << N` plus a nontrivial tail theorem.

---

## 10. Multileg finite-diagonal geometry

For `k` legs with fixed sum `n_1+...+n_k=N`, the state space is the integer simplex. The continuum limit is the Dirichlet/Jacobi diffusion on `Delta_{k-1}` from Delta 07.

The degree-`j` angular eigenspace has multiplicity

\[
\boxed{
\binom{j+k-2}{k-2},
}
\]

matching both:

- the dimension of total-degree-`j` multivariate Jacobi polynomials on a `(k-1)`-simplex;
- the multiplicity obtained by iterating
  `D^+_{a} tensor D^+_{b}=direct_sum_j D^+_{a+b+j}`.

For binary Goldbach the relative channel at each `j` is multiplicity-free. For ternary Goldbach the multiplicity is `j+1`; there is a genuine family of independent angular channels. This is an exact structural sense in which the ternary problem has “spare directions,” although it is not yet a derivation of the analytic spare Hölder factor.

Different binary coupling trees are related by `SU(1,1)` Racah / `6j` coefficients. The elementary scalar shadow is beta associativity:

\[
B(a,b)B(a+b,c)
=
\frac{\Gamma(a)\Gamma(b)\Gamma(c)}{\Gamma(a+b+c)}
=
B(b,c)B(a,b+c).
\]

This gives a canonical recoupling language for higher zero sectors and higher-order Goldbach variations.

---

## 11. What this changes

The diagonal program now has four exact layers:

1. **Continuous positive cone:** Jacobi / continuous Hahn angular channels.
2. **Finite arithmetic diagonal:** Hahn difference operator and antipodal reflection.
3. **Internal multiplicative charge:** `Omega` and z-Buchstab flow.
4. **Boundary problem:** simultaneous continuation to factorization parity and angular antipode.

This suggests a more precise master formulation:

> Construct a stable two-parameter reconstruction/certificate theory for the internal composition-length grading and the external Hahn angular grading. Finite local equilibrium controls the first; positive semigroup smoothing controls the second. Prime pairs occupy their joint charged boundary.

The ordinary K-theory boundary class was too coarse because it saw neither grading dynamically. The relevant object may instead be a bigraded transfer/scattering determinant or a multivariable stable polynomial.

---

## 12. Revised priorities after Delta 08

1. Compute exact arithmetic and zero-side formulas for the finite/continuous `j=2` primitive channel.
2. Test whether the Ramanujan `BC / mixed / zero` decomposition is approximately diagonal in low Hahn channels.
3. Formulate and solve the finite Delsarte minorant problem numerically, then identify any exact extremizers.
4. Study zero-free/stability properties of the bivariate charged-angular partition function near the polydisk and its corner `(-1,-1,-1)`.
5. Derive the multivariate Hahn/Jacobi operator on the ternary integer simplex and match its multiplicities to the `(3,3)` variation structure.
6. Compare the Hahn Poisson kernel with the proposed simplex-prolate/Heun operator.
7. Keep angular parity `(-1)^j` and Liouville parity `(-1)^Omega` rigorously distinct while studying their coupling.

---

## 13. Verification boundaries

**V1:**

- the finite Hahn generator, Dirichlet form, reflection parity and functional calculus;
- Goldbach as alternating Hahn spectral energy;
- positive-time heat regularization and error bound;
- angular spectral polynomial and `Phi_2` equivalence;
- two-charge/angular finite partition function;
- symmetric primitive gap `6` and explicit `Q_2`;
- RH simplification of the `j=2` multiplier;
- multileg channel multiplicity.

**Known prior art:**

- Hahn polynomials as eigenfunctions of the quadratic birth–death/Jacobi lattice process;
- Hahn/Jacobi and `SU(1,1)` coupling theory;
- Delsarte linear-programming philosophy.

**Open:**

- any useful low-degree magic minorant;
- stable control of the zero-time boundary;
- a sign theorem in the `j=2` primitive channel;
- an arithmetic theorem coupling internal and angular gradings;
- direct consequences for binary Goldbach.

## 14. Literature anchors

- Standard Hahn polynomial difference equations and orthogonality, as in the Askey scheme.
- Ascione, Leonenko, and Pirozzi, *Non-local solvable birth–death processes*, for the Hahn birth–death/Jacobi approximation and eigenvalues.
- Koelink–Van der Jeugt and Groenevelt–Koelink–Rosengren for the `SU(1,1)` coupling framework.
- Delsarte / Cohn–Elkies / Viazovska for spectral linear-programming certificates.
