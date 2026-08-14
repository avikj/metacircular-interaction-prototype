# Arithmetic / Fundamental-Physics Research Ledger

**Status:** living handoff for cross-thread / cross-agent continuation  
**Updated:** 2026-08-11  
**Purpose:** preserve the strongest mathematical findings, corrections, dead branches, live conjectures, and research heuristics from the ongoing Goldbach / prime-pair / RH / arithmetic-physics program.

## How future agents should use this

1. Treat this as a **research state**, not a truth source. Re-verify anything marked “novelty candidate”, “working theorem”, or “conjecture”.
2. Do not restart from generic Goldbach/RH exposition. Push the live frontier.
3. Pressure-test before extending. If a branch collapses, kill it and preserve the obstruction.
4. Distinguish exact identities, known prior art, numerical evidence, conjectures, and physics interpretations.
5. Optimize for deep structural unification, not quick publication.
6. When no direction calls strongly, Rovelli-style relational/covariant thinking may be consulted, but only when it produces mathematical structure rather than analogy.

---

# 1. Original structural intuition

Goldbach in midpoint form:

\[
p+q=2w,\qquad p=w-d,\quad q=w+d.
\]

Thus Goldbach says every integer midpoint \(w\) is realized by a pair of primes. The multiplicatively defined atoms of arithmetic conjecturally have pairwise additive geometry whose midpoint projection covers the naturals.

The same pair satisfies

\[
pq=(w-d)(w+d)=w^2-d^2.
\]

So center/difference coordinates linearize addition, while multiplication becomes the quadratic invariant. This was initially phrased Lorentzianly; that picture was useful scaffolding but should not be treated as the core result.

Prime-pair field:

\[
K(w,d)=a_{w-d}a_{w+d},
\]

with \(a_n\) either \(1_{\mathbb P}(n)\) or \(\Lambda(n)\). Goldbach is a row/support problem; fixed-gap / Polignac / twin-prime questions are column/recurrence problems.

Important exact signed symmetry:

\[
B(w,d)=1_{\mathbb P}(|w-d|)1_{\mathbb P}(w+d)
\]

is symmetric under \(w\leftrightarrow d\). Goldbach and prime-gap sectors become the two sides of a symmetric matrix after signed extension.

---

# 2. Exact operator / harmonic-analysis identities

On \(\ell^2(\mathbb N)\), with number operator \(N|n\rangle=n|n\rangle\), define on two copies

\[
S=N_1+N_2,\qquad D=N_2-N_1,\qquad Q=N_1N_2.
\]

Then exactly

\[
\boxed{S^2-D^2=4Q.}
\]

On \(|p,q\rangle\), \(S=p+q\), \(D=q-p\), \(Q=pq\).

Useful but mostly a coordinate wrapper unless connected to stronger operator structure.

For a nonnegative sequence \(a_n\), define

\[
P(t)=\sum_{n\ge1}a_ne^{-nt},
\]

\[
Z(t,\theta)=\sum_{m,n}a_ma_ne^{-t(m+n)}e^{i\theta(n-m)}
=P(t+i\theta)P(t-i\theta).
\]

At \(\theta=0\), \(Z=P(t)^2\) gives sum/Goldbach multiplicities. Fourier coefficients in \(\theta\) give heat-resolved gap products.

Fourier form:

\[
A(\theta)=\sum_n a_ne^{in\theta}.
\]

Then sum data is encoded in \(A^2\), difference data in \(|A|^2=A\bar A\).

**Critical correction:** the *full heat-resolved gap field* does **not** lose phase/information. Since

\[
C_0(t)=\sum_n a_n^2e^{-2nt},
\]

varying \(t\) recovers every \(a_n^2\), hence \(a_n\) for nonnegative weights. Even deleting \(h=0\), sufficiently rich labeled off-diagonal products generically reconstruct the sequence. Phase retrieval only becomes a genuine issue after compressing/projecting away the heat/radial label.

For compressed representation functions

\[
R(s)=\sum_{m+n=s}a_ma_n,\qquad C(h)=\sum_n a_na_{n+h},
\]

we do have

\[
\widehat R(\theta)=A(\theta)^2,\qquad \widehat C(\theta)=|A(\theta)|^2,
\]

hence

\[
\boxed{\widehat C(\theta)=|\widehat R(\theta)|.}
\]

This is the correct compressed phase-retrieval setting.

---

# 3. Laplace–Mellin bridge between additive and multiplicative harmonic analysis

For \(a_n=\Lambda(n)\),

\[
P(t)=\sum_n\Lambda(n)e^{-nt}.
\]

Then

\[
\boxed{
\int_0^\infty P(t)t^{s-1}\,dt
=\Gamma(s)\left(-\frac{\zeta'(s)}{\zeta(s)}\right)
}
\]

for \(\Re s>1\).

Interpretation worth preserving: additive heat/Laplace analysis and multiplicative Dirichlet/Mellin analysis are exact transforms of the same prime measure.

For weighted Goldbach multiplicities

\[
R(N)=\sum_{m+n=N}\Lambda(m)\Lambda(n),
\]

we have

\[
P(t)^2=\sum_NR(N)e^{-Nt}.
\]

Thus the full weighted Goldbach multiplicity field determines \(P(t)\) by positive square root and therefore determines \(-\zeta'/\zeta\) exactly. This “informational completeness of full Goldbach multiplicities” is elementary but conceptually useful; do not oversell novelty.

Mellin–Barnes analysis of \(P(t)^2\) produces singularities at sums \(\rho_1+\rho_2\) of zeta zeros. This is known prior art (Egami–Matsumoto / Bhowmik–Schlage-Puchta / Brüdern–Kaczorowski–Perelli / Languasco–Zaccagnini family of results).

Completed-zeta centering:

\[
M(s)=-\frac{\zeta'}{\zeta}(s)
=A_\infty(s)+F(s),
\qquad F(s)=-\frac{\xi_R'}{\xi_R}(s),
\]

where \(A_\infty\) contains pole/trivial/archimedean terms and \(F\) has poles only at nontrivial zeta zeros.

Two-body factorization then yields sectors

\[
AA,\qquad AF+FA,\qquad FF,
\]

corresponding after Goldbach projection to main/zero-free, one-zero \(1+\rho\), and two-zero \(\rho_1+\rho_2\) spectral locations. This structure is substantially prior art in explicit-formula form.

---

# 4. Matsumoto–Suzuki screw-function placement

For the Goldbach Dirichlet series \(\Phi_G(u)=\sum_N R(N)N^{-u}\), the cross mean–zero sector gives a pole at \(u=1+\rho\) with residue

\[
\operatorname{Res}_{u=1+\rho}\Phi_G(u)
=-\frac{2m_\rho}{\rho}.
\]

For

\[
W(X)=\sum_{N\le X}\frac{R(N)}{N^2},
\]

Perron inversion gives the linear-zero contribution

\[
\boxed{
W_{\rm linear}(X)=\frac{2}{\sqrt X}H_1(X)
}
\]

with

\[
H_1(X)=\sum_\rho \frac{X^{\rho-1/2}}{\rho(1-\rho)}.
\]

Thus Matsumoto–Suzuki’s \(H_1\) is exactly the normalized residue field of the one-zero cross sector of the Goldbach pair decomposition.

Their screw function

\[
g(t)=H_1(e^t)-H_1(1)
\]

is a screw function iff RH. Under RH, writing \(\rho=1/2+i\gamma\), its kernel becomes a Gram kernel with positive weights \((1/4+\gamma^2)^{-1}\).

This is one of the strongest clean placements of an RH-equivalent positivity structure inside the Goldbach decomposition.

**Caution:** no automatic positivity transfer from the linear screw kernel to the two-zero/quadratic Goldbach sector has been established. Character/Gauss-sum/generalized singular-series structure prevents a naive tensor-positivity argument.

---

# 5. Why a single PNT-centered tensor square fails for gaps

Let

\[
\mu_\Lambda=\sum\Lambda(n)\delta_n,\qquad
\lambda=1_{[1,\infty)}(x)\,dx,\qquad
\xi=\mu_\Lambda-\lambda.
\]

Then \(\xi\otimes\xi\) gives a natural centered Goldbach distribution. But in the heat-regularized difference pushforward, the \(\mu_\Lambda\otimes\mu_\Lambda\) piece retains discrete atoms at integer gaps, while all terms involving Lebesgue measure are absolutely continuous. Hence PNT centering does **not** subtract the Hardy–Littlewood baseline from fixed-gap atoms.

Conclusion:

\[
\boxed{
\text{finite-place sieve centering must enter at the pair/correlation level.}
}
\]

The Hardy–Littlewood local background is intrinsically a pair/cylindrical object, not a finite-energy one-body mean.

---

# 6. Critical Bost–Connes / Cuntz correlation structure

Let

\[
\widehat{\mathbb Z}=\prod_p\mathbb Z_p
\]

with additive Haar probability \(\mu\). At BC inverse temperature \(\beta=1\), the finite-adic diagonal measure becomes additive Haar.

For a finite prime set \(F\), define

\[
e_F(x)=\prod_{p\in F}1_{\mathbb Z_p^\times}(x_p).
\]

Then

\[
\mu(e_F)=\prod_{p\in F}(1-1/p).
\]

Normalized two-point correlation:

\[
C_F(h)=\frac{\mu(e_F\tau_he_F)}{\mu(e_F)^2}.
\]

Exactly,

\[
C_F(h)
=\prod_{\substack{p\in F\\p\nmid h}}
\left(1-\frac1{(p-1)^2}\right)
\prod_{\substack{p\in F\\p\mid h}}\frac p{p-1}.
\]

As \(F\uparrow\mathbb P\), for even nonzero \(h\),

\[
\boxed{C_F(h)\to\mathfrak S(h)}
\]

(the Hardy–Littlewood prime-pair singular series); odd \(h\) is killed by the \(p=2\) factor.

For a tuple \(H=\{h_1,\dots,h_k\}\),

\[
C_F(H)=
\frac{\mu(\prod_j\tau_{h_j}e_F)}{\mu(e_F)^k}
=\prod_{p\in F}\frac{1-\nu_p(H)/p}{(1-1/p)^k},
\]

hence

\[
\boxed{C_F(H)\to\mathfrak S(H).}
\]

Interpretation: Hardy–Littlewood local arithmetic = renormalized critical BC/Cuntz \(k\)-point functions.

Prior art: local-density interpretation and Ramanujan expansions are classical; Gadiyar–Padma (1999) already connect Ramanujan–Fourier + Wiener–Khintchine heuristically to Hardy–Littlewood. The explicit sieve-projection/KMS packaging appears to be at least a potentially new synthesis, not yet a safely novel theorem claim.

---

# 7. Criticality proposition E0

At general BC inverse temperature \(\beta\), the normalized local tuple factor behaves for large \(p\) like

\[
\log L_{\beta,p}(H)
=(k-1)(p^{-\beta}-p^{-1})+O(p^{-2}+p^{-2\beta}).
\]

Therefore for admissible \(H\), the infinite normalized correlation satisfies

\[
\boxed{
C_{\beta,z}(H)\to
\begin{cases}
\infty,&0<\beta<1,\\
\mathfrak S(H),&\beta=1,\\
0,&\beta>1.
\end{cases}}
\]

So finiteness/nonzero prime-tuple correlations select the BC critical point.

Even more structurally, in Cuntz’s affine algebra the residue partition relation

\[
\sum_{k=0}^{n-1}u^ke_nu^{-k}=1
\]

plus KMS multiplicative scaling \(\omega(e_n)=n^{-\beta}\) forces

\[
n\,\omega(e_n)=1
\]

and therefore

\[
\boxed{\beta=1.}
\]

Interpretation: additive residue degeneracy and multiplicative energy balance exactly at \(\beta=1\).

---

# 8. Critical-window finite-size scaling (novelty candidate)

Set

\[
\beta_z=1+\frac{\lambda}{\log z}.
\]

Then for an admissible \(k\)-tuple,

\[
\frac{C_{\beta_z,z}(H)}{C_{1,z}(H)}
=\prod_{p\le z}\left(\frac{1-p^{-1}}{1-p^{-\beta_z}}\right)^{k-1}.
\]

Using prime harmonic measure,

\[
\boxed{
\frac{C_{\beta_z,z}(H)}{C_{1,z}(H)}
\longrightarrow
\exp\left[(k-1)\int_0^1\frac{e^{-\lambda t}-1}{t}\,dt\right].
}
\]

Thus the critical window is \(\Delta\beta\asymp1/\log z\), and the crossover is universal apart from \(k\) and the critical amplitude \(\mathfrak S(H)\).

Targeted searches had not found this exact formula. **Must receive a serious prior-art search before any novelty claim.**

---

# 9. Ramanujan spectrum and coherent-vs-intensity split

For squarefree

\[
M=\prod_{p\in F}p,
\]

define normalized sieve field

\[
g_M(x)=\frac{M}{\phi(M)}1_{(x,M)=1}.
\]

A primitive additive character of exact denominator \(q\mid M\) has Fourier coefficient

\[
\boxed{\widehat g_M(a/q)=\frac{\mu(q)}{\phi(q)}.}
\]

Autocorrelation gives

\[
\boxed{
C_M(h)=\sum_{q\mid M}\frac{\mu(q)^2}{\phi(q)^2}c_q(h),
}
\]

and the limit is the classical Ramanujan expansion of \(\mathfrak S(h)\).

**Important new structural observation:** the two-point/intensity spectrum squares away the Möbius sign \(\mu(q)=(-1)^{\omega(q)}\), i.e. inclusion–exclusion parity information.

The exact-denominator \(q\) shell has degeneracy \(\phi(q)\), so the coherent shell amplitude is

\[
\phi(q)\cdot\frac{\mu(q)}{\phi(q)}=\boxed{\mu(q)}.
\]

Its Dirichlet transform is

\[
\boxed{\sum_q\mu(q)q^{-s}=1/\zeta(s).}
\]

Thus there is an exact amplitude/intensity split:

\[
\boxed{\text{coherent critical spectrum}\to 1/\zeta(s)\to \text{RH-sensitive}}
\]

versus

\[
\boxed{\text{critical two-point intensity}\to\mathfrak S(h)\to\text{local Goldbach/gap law}.}
\]

This may provide a spectral formulation of the sieve parity barrier: local pair intensity is parity-blind because it loses the Möbius phase; prime-boundary recovery requires coherent information.

This is a **working structural insight**, not yet a theorem that solves the classical parity problem. It deserves rigorous formulation and prior-art search.

---

# 10. Profinite unit measure and binary/ternary smoothing threshold

Let \(\nu\) be Haar probability on \(\widehat{\mathbb Z}^{\times}\subset\widehat{\mathbb Z}\). Its additive Fourier coefficient at a primitive character of exact denominator \(q\) is

\[
\widehat\nu(a/q)=\frac{\mu(q)}{\phi(q)}.
\]

Hence for the \(k\)-fold additive convolution,

\[
\widehat{\nu^{*k}}(a/q)=\left(\frac{\mu(q)}{\phi(q)}\right)^k.
\]

For \(k=2\), the Fourier coefficients are square-summable but not absolutely summable.

For \(k\ge3\),

\[
\sum_q \phi(q)\left|\frac{\mu(q)}{\phi(q)}\right|^k
=\sum_q\frac{\mu(q)^2}{\phi(q)^{k-1}}<\infty.
\]

Therefore:

\[
\boxed{
1\text{ prime: singular measure}
\;\to\;
2\text{ primes: }L^2\text{ local density}
\;\to\;
3\text{ or more primes: continuous bounded local density}.
}
\]

Working refinement: the binary local density is marginal/unbounded but lies in finite \(L^r\) classes; ternary and higher convolution crosses into absolute/uniform Fourier convergence.

This lines up strikingly with the historical jump from binary Goldbach difficulty to Vinogradov’s ternary theorem. A promising direction is to formalize the fact that **the same convolution-smoothing threshold appears at the finite-adic and archimedean/circle-method places**.

Prior art on exact harmonic-analytic regularity of these profinite convolutions must be searched before novelty claims.

---

# 11. Goldbach vs gaps: finite places identical; positive cone breaks symmetry

At each finite prime \(p\), Goldbach local conditions

\[
x\in\mathbb Z_p^\times,\qquad N-x\in\mathbb Z_p^\times
\]

and gap local conditions

\[
y\in\mathbb Z_p^\times,\qquad y+N\in\mathbb Z_p^\times
\]

are identified by \(y=-x\). Hence they have identical local densities and the same singular series.

Their distinction is archimedean/sign-sector:

Goldbach requires \(0<x<N\); reflection sends this to a signed gap crossing the origin, not an ordinary positive-positive gap.

On signed integers with reflection \(J|m,n\rangle=|-m,n\rangle\),

\[
JSJ=D,\qquad JDJ=S.
\]

So sum and difference observables are unitarily equivalent on the signed system. The positive cone breaks the equivalence.

Other-agent result E1: after symmetrization, homometry/phase ambiguity disappears in a precise way; “Goldbach counts signed gaps crossing the origin.” A verified identity reported by the agent is

\[
r_{\rm sym}(N)=r_{\rm Goldbach}(N)+2c_{\rm gap}(N).
\]

The statement “every even \(N\) is a sum or difference of two primes” is isolated as a strictly weaker open support problem.

---

# 12. Affine ax+b algebra is the natural ambient algebra

Cuntz’s arithmetic affine algebra contains addition and multiplication intrinsically with covariance

\[
\boxed{s_nu=u^ns_n.}
\]

Residue-class projections provide an exact operator realization of the sieve.

For fixed tuple \(H\), finite sieve projection can be written using residue projections \(e_{p,r}\). Its critical trace/state gives the exact finite-adic local density product.

This is better than custom Lorentzian two-body formalism because the noncommuting \(ax+b\) relation actually generates sieve/Buchstab steps.

Important operator-algebraic distinction:

Cuntz’s \(Q_{\mathbb N}\) is a boundary quotient. The concrete Toeplitz/semigroup algebra on \(\ell^2(\mathbb N)\) contains compacts and remembers the boundary/positive cone; quotienting erases that boundary and makes addition unitary/translation-invariant.

Research interpretation:

\[
\boxed{
\text{Hardy–Littlewood local equilibrium lives naturally in the boundary quotient;}
\quad
\text{prime support problems may live in the lift through the Toeplitz extension.}
}
\]

This is a strong live direction.

---

# 13. Exact primality as a scale-coupled adelic observable

For \(n\ge2\),

\[
\boxed{
1_{\mathbb P}(n)
=\prod_{p^2\le n}(1-1_{p\mid n}).
}
\]

Adelically, finite coordinates supply divisibility while the real coordinate supplies the moving cutoff \(p\le\sqrt n\). Actual primality is therefore a **scale-coupled adelic boundary observable**, not a static profinite field.

This pinpoints why static finite-adic equilibrium gives the singular series but not the primes themselves.

---

# 14. Buchstab flow as archimedean/profinite boundary renormalization

For rough numbers,

\[
\Phi(X,z)=\#\{n\le X:P^-(n)>z\}.
\]

With

\[
u=\frac{\log X}{\log z},
\]

Buchstab theory gives roughly

\[
\Phi(X,z)\sim \frac{X\omega(u)}{\log z}.
\]

Critical KMS/Haar independence predicts

\[
X\prod_{p\le z}(1-1/p)
\sim \frac{e^{-\gamma}X}{\log z}.
\]

Thus

\[
\boxed{
\frac{\text{actual diagonal rough density}}
{\text{critical KMS density}}
\sim e^\gamma\omega(u).
}
\]

As \(u\to\infty\), this tends to \(1\). At the prime stopping horizon \(u=2\), \(\omega(2)=1/2\), giving \(e^\gamma/2\).

Interpretation: ordinary Buchstab is the one-body boundary-renormalization flow from profinite equilibrium to the positive-integer prime boundary.

---

# 15. Affine Buchstab step is exactly ax+b dynamics

Let \(\rho_z(n)=1_{P^-(n)>z}\). Buchstab peeling decomposes survivors by newly exposed least prime factors.

For an affine system \(L_i(n)=a_in+b_i\), conditioning on \(p\mid L_j(n)\) chooses a residue \(n=r+pm\). Then every form becomes

\[
L_i(r+pm),
\]

and the divisible component can be rescaled by \(p\).

For every \(q\ne p\), the map \(m\mapsto r+pm\) is a bijection mod \(q\), so

\[
\boxed{\nu_q(\widetilde{\mathbf L})=\nu_q(\mathbf L)\qquad(q\ne p).}
\]

Thus one Buchstab RG step modifies exactly one Euler place while acting affinely on the global linear-form system.

This is an exact arithmetic renormalization locality law. The natural state space is the moduli space of affine linear-form systems plus their archimedean scale vector, not merely fixed gaps.

---

# 16. Boundary Factorization conjecture / many-body Buchstab flow

For an admissible tuple \(H=\{h_1,\dots,h_k\}\), give each leg a roughness parameter \(u_i\), with cutoff roughly \(X^{1/u_i}\). Let \(R_H(X;\mathbf u)\) count simultaneous roughness.

Factor out the exact finite-adic local density and then divide by each one-body Buchstab correction. Define connected boundary interaction schematically as

\[
\boxed{
\kappa_H(X;\mathbf u)
=
\frac{B_H(X;\mathbf u)}{\prod_iB_1(X;u_i)}.
}
\]

Working conjecture (“Boundary Factorization”):

\[
\boxed{\kappa_H(X;\mathbf u)\to1.}
\]

Equivalent free scaling candidate:

\[
\boxed{
B_H(\mathbf u)
=e^{k\gamma}\prod_i\omega(u_i).
}
\]

At \(u_i\to\infty\), this approaches finite-adic equilibrium. At \(u_i=2\), it becomes the Hardy–Littlewood prime-tuple endpoint after local singular-series factors are restored.

Interpretation:

\[
\boxed{
\text{Hardy–Littlewood}=
\text{factorized many-body Buchstab boundary condition at }u_i=2.
}
\]

The parity problem becomes failure to transport factorization from the easy large-\(u\) regime to the prime stopping surface.

Numerical exploratory evidence reported in-thread: after local and one-body normalization, \(\kappa_H\) was within roughly 0.2% of 1 for several 2-body tests at \(X\sim5\times10^6\). A scary quadruplet deficit at small sample disappeared when scaled to \(X\sim3\times10^7\), landing near 1. This is not serious evidence of truth but survived an initial falsification attempt.

**Pressure-test requirement:** verify exact normalizations and whether known multi-dimensional Buchstab/sieve literature already contains this asymptotic under another name.

---

# 17. Positive cone, homometry, and the correct place for phase

On the full signed additive group, sum and difference are related by reflection. The obstruction appears when restricting to the positive semigroup.

This explains why earlier phase/homometry effects were real but mislocated. Full heat-resolved data is injective; the loss arises under projection and/or positive-cone restriction.

This positive-cone breaking should be studied together with the Toeplitz-vs-boundary-quotient extension of the affine algebra.

---

# 18. Major arcs as archimedean thickenings of finite-adic spectrum

The critical profinite sieve field has additive spectrum indexed by

\[
\widehat{\widehat{\mathbb Z}}=\mathbb Q/\mathbb Z.
\]

Primitive denominator-\(q\) frequencies carry amplitude \(\mu(q)/\phi(q)\). These are exactly the rational centers \(a/q\) around which Hardy–Littlewood major arcs are built.

Working interpretation:

\[
\boxed{
\text{major arcs}=
\text{archimedean thickenings of finite-adic KMS frequencies }a/q.
}
\]

Tao’s adelic sampling/transference framework on \(\mathbb R\times\widehat{\mathbb Z}\) is strongly relevant here.

Full rational-frequency resolution necessarily introduces Dirichlet characters and therefore Dirichlet \(L\)-functions, not zeta alone. This makes abelian GRH the natural global spectral family.

Burnol’s adelic Lax–Phillips/scattering framework is relevant **only at this stage**, because its causality criterion is tied to abelian \(L\)-functions—the family forced by the rational/character spectrum.

---

# 19. Current strongest research frontier

The most promising live problem is no longer “prove Goldbach from RH” or “find a Lorentzian model.” It is:

\[
\boxed{
\textbf{derive the exact evolution equation for the connected many-body boundary interaction }\Gamma_H(\mathbf u).
}
\]

Define

\[
\Gamma_H(\mathbf u)
=
\log\frac{B_H(\mathbf u)}{\prod_iB_1(u_i)}.
\]

The free/factorized candidate has \(\Gamma_H=0\). Hardy–Littlewood predicts \(\Gamma_H(2,\dots,2)=0\). Large-\(u\) sieve equilibrium also suggests \(\Gamma_H\to0\).

Question:

\[
\boxed{
\text{What term in the exact affine Buchstab hierarchy can generate }\Gamma_H\ne0,
\text{ and what spectral information controls it?}
}
\]

Potential answer to investigate: coherent Möbius/Dirichlet-\(L\) spectral information is exactly what is lost by local intensity correlations and may control the connected interaction / parity obstruction.

This should be attacked via:
- exact affine Buchstab recursion on linear-form systems with scale vectors;
- Toeplitz affine algebra before the boundary quotient;
- rational-frequency / character decomposition;
- comparison of coherent amplitudes \(\mu(q)/\phi(q)\) versus intensity \(\mu(q)^2/\phi(q)^2\);
- known rough-prime approximation theorems and zero-density / exceptional-zero corrections;
- Burnol/Connes only if they naturally control the resulting character-resolved perturbation theory.

---

# 20. Very recent finding to preserve: binary vs ternary as a smoothing threshold

The profinite-unit convolution calculation suggests an exact finite-place threshold:

\[
\nu^{*2}: \text{only }L^2\text{/marginal Fourier regularity},
\qquad
\nu^{*k},\ k\ge3: \text{absolute Fourier convergence and continuity}.
\]

This may mirror the archimedean circle-method threshold:
- binary sums leave minor-arc \(L^2\) mass at full strength;
- ternary sums allow a nontrivial minor-arc sup bound to be multiplied by an \(L^2\) estimate and win.

**Live conjectural meta-principle:** the historical binary/ternary Goldbach difficulty gap may reflect the same convolution-smoothing threshold simultaneously at finite and infinite places.

This is currently a high-value branch for literature search and formalization.

---

# 21. Dead / downgraded branches

- **Naive phase retrieval from full \(Z(t,\theta)\): false.** Full heat-resolved data is informationally complete.
- **Single PNT-centered tensor square as universal Goldbach+gap centering: false.** It centers Goldbach naturally but leaves gap atoms untouched.
- **Lorentzian spacetime interpretation as primary framework: downgraded.** Exact coordinate identity remains useful, but affine/profinite/Toeplitz structures carry more real machinery.
- **“RH causality directly implies Goldbach positivity”: unsupported.** Burnol/Matsumoto–Suzuki positivity structures do not automatically control the quadratic two-zero sector.
- **Two-body zero-pair spectral sums as novelty: prior art.** Many explicit Goldbach formulas already have main/one-zero/two-zero decompositions.
- **Full heat-resolved gap channel as phaseless: false.** Only compressed projections have genuine phase ambiguity.

---

# 22. Important prior-art anchors to check before claims

- Bost–Connes system and KMS phase structure.
- Neshveyev / Laca-type analysis of BC KMS measures and von Neumann algebras.
- Cuntz arithmetic \(ax+b\) algebra \(Q_{\mathbb N}\), Toeplitz/semigroup precursor, boundary quotient.
- Gadiyar–Padma (Physica A 269, 1999) on Ramanujan–Fourier + Wiener–Khintchine and Hardy–Littlewood correlations; related Conjecture D work and Murty survey.
- Languasco–Zaccagnini Goldbach explicit formulas.
- Brüdern–Kaczorowski–Perelli double Mellin / Goldbach analysis.
- Bhowmik–Schlage-Puchta on Goldbach Dirichlet series and sums of zeros.
- Matsumoto–Suzuki 2024 screw-function RH criterion from Goldbach secondary terms.
- Goldston–Suriajaya on singular-series averages and zeta-zero resonances.
- Pintz on common explicit-formula framework for Goldbach / twin-prime-type problems.
- Bhowmik–Grimmelt 2026 major-arc / exceptional-zero Goldbach work.
- Tao adelic sampling / major-arc framework.
- Burnol adelic Lax–Phillips scattering / causality and abelian RH.
- Grimmelt–Teräväinen 2025 rough-prime / Cramér-model replacement results.
- Recent affine-Toeplitz KMS work involving smooth-number asymptotics (Laca–Schulz 2025).

---

# 23. Inter-agent protocol

Future agents should leave updates in this form:

**VERIFIED EXACT** — identity/theorem with proof or computational check.  
**KNOWN PRIOR ART** — exact source / theorem.  
**NOVELTY CANDIDATE** — statement not found after targeted search; no novelty claim yet.  
**NUMERICAL** — range, normalization, observed result.  
**KILLED BRANCH** — false claim or structural obstruction and why.  
**LIVE FRONTIER** — strongest next theorem/question.

When another thread starts, tell it: **“Search my Library for `Arithmetic Research Ledger` and continue from the LIVE FRONTIER; do not restart the exposition.”**

