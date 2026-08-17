# Prime-Pair / Additive–Multiplicative Arithmetic Research State

Last updated: 2026-08-11

## How future math threads should use this file
Treat this as the canonical cross-thread research checkpoint. Before extending the program:
1. Read this file.
2. Pressure-test any claim you plan to use.
3. Distinguish **EXACT/PROVED**, **KNOWN PRIOR ART**, **NOVELTY CANDIDATE**, **CONJECTURAL**, and **DEAD/OVERSOLD**.
4. Update/replace this file with genuine deltas rather than re-summarizing the whole program.
5. Prefer the connected GitHub repo `avikj/math` / the active research PR when available, but the Library file is the cross-thread fallback.

## Original structural motivation
Goldbach is best viewed as a pairwise midpoint claim:

\[
p+q=2w,\qquad p=w-d,\qquad q=w+d.
\]

Thus every natural number is conjecturally the midpoint of a prime pair. The multiplicatively defined atoms of arithmetic have pairwise additive geometry covering the integer line.

The same pair satisfies

\[
pq=w^2-d^2.
\]

This motivated a two-body / center-difference viewpoint, but much of the Lorentzian language turned out to be scaffolding rather than the deepest machinery.

## Exact pair-field identities
For a sequence \(a_n\), define

\[
K(w,d)=a_{w-d}a_{w+d}.
\]

With number operators on two copies,

\[
S=N_1+N_2,\quad D=N_2-N_1,\quad Q=N_1N_2,
\]

we have the exact operator identity

\[
S^2-D^2=4Q.
\]

For

\[
P(t)=\sum_n a_ne^{-nt},
\]

\[
Z(t,\theta)=\sum_{m,n}a_ma_ne^{-t(m+n)}e^{i\theta(n-m)}
=P(t+i\theta)P(t-i\theta).
\]

Goldbach/sum information is the \(S\) projection; gap information is the \(D\) projection.

### Important correction: full heat-resolved gap data is informationally complete
The earlier phase-retrieval claim was overstated. If

\[
C_h(t)=\sum_n a_na_{n+h}e^{-t(2n+h)},
\]

then

\[
C_0(t)=\sum_n a_n^2e^{-2nt}
\]

recovers every \(a_n^2\), hence every nonnegative \(a_n\). Even off-diagonal fully heat-resolved products are generically reconstructive. Genuine phase loss only appears after compressing/projecting away the radial/heat coordinate.

For compressed representation functions

\[
R(s)=\sum_{m+n=s}a_ma_n,\qquad C(h)=\sum_na_na_{n+h},
\]

we do have

\[
\widehat R(\theta)=A(\theta)^2,\qquad \widehat C(\theta)=|A(\theta)|^2,
\]

so \(\widehat C=|\widehat R|\). That is the legitimate phase-retrieval setting.

## Prime indicator vs von Mangoldt
Keep \(1_{\mathbb P}\) and \(\Lambda\) separate. \(\Lambda\)-convolution includes prime powers, so positivity of a weighted Goldbach convolution is not literally Goldbach.

## Laplace–Mellin bridge
For \(a_n=\Lambda(n)\),

\[
P(t)=\sum_n\Lambda(n)e^{-nt},
\]

and

\[
\int_0^\infty P(t)t^{s-1}\,dt
=\Gamma(s)\left(-\frac{\zeta'(s)}{\zeta(s)}\right).
\]

This is the clean exact bridge between additive/heat analysis and multiplicative/Dirichlet analysis.

Goldbach Mellin-Barnes decompositions producing zero sums \(\rho_1+\rho_2\) are known prior art (Egami–Matsumoto / Bhowmik–Schlage-Puchta / Languasco–Zaccagnini etc.). Do not claim novelty for “tensoring the explicit formula produces zero pairs.”

## Centered Goldbach field / Matsumoto–Suzuki identification
Let

\[
\mu_\Lambda=\sum_{n\ge1}\Lambda(n)\delta_n,\quad
\lambda=1_{[1,\infty)}dx,\quad
\xi=\mu_\Lambda-\lambda.
\]

Then \(\Xi=\xi\otimes\xi\) gives a rigorous centered two-body distribution. The sum pushforward satisfies

\[
S_\#\Xi
=\sum_NR(N)\delta_N
-\bigl(2\psi(S-1)-(S-2)\bigr)1_{S\ge2}\,dS.
\]

A more canonical spectral centering uses the completed zeta logarithmic derivative:

\[
F(s)=M(s)-A_\infty(s)=-\xi_R'(s)/\xi_R(s),
\]

so the two-body product splits into main/archimedean, one-zero cross, and two-zero sectors.

Important structural placement: Matsumoto–Suzuki's \(H_1\) is exactly the normalized residue field of the **one-zero cross sector** in the Goldbach projection. Their screw kernel is RH-equivalent and under RH becomes a positive Gram kernel over zero ordinates. This is one of the strongest rigorous bridges found so far.

## Why one universal PNT-centered tensor square fails for gaps
For the heat-regularized difference pushforward of \(\xi\otimes\xi\), the discrete atoms at integer gaps remain the raw \(\Lambda\)-gap weights; Lebesgue reference terms are absolutely continuous. Thus PNT centering naturally centers Goldbach sums but does **not** subtract the Hardy–Littlewood gap baseline. This failure is structural.

## Critical BC / Cuntz finite-adic field
Let

\[
\widehat{\mathbb Z}=\prod_p\mathbb Z_p
\]

with additive Haar probability. For finite prime set \(F\),

\[
e_F(x)=\prod_{p\in F}1_{\mathbb Z_p^\times}(x_p).
\]

Define the normalized correlation

\[
C_F(h)=\frac{\mu(e_F\tau_he_F)}{\mu(e_F)^2}.
\]

Exact local calculation gives, as \(F\uparrow\mathbb P\),

\[
C_F(h)\to\mathfrak S(h)
\]

for admissible parity, with the usual Hardy–Littlewood prime-pair singular series. More generally for shifts \(H\),

\[
C_F(H)=\prod_{p\in F}\frac{1-\nu_p(H)/p}{(1-1/p)^{|H|}}
\to\mathfrak S(H).
\]

Interpretation: Hardy–Littlewood local arithmetic = normalized critical KMS/profinite k-point correlations. This exact operator/KMS packaging appears to be a plausible new synthesis; the underlying local-density formula is classical.

### Ramanujan spectrum
For squarefree primorial \(M\), normalized rough field

\[
g_M(x)=\frac{M}{\varphi(M)}1_{(x,M)=1}
\]

has Fourier amplitudes \(\mu(q)/\varphi(q)\) at primitive denominator \(q\mid M\), yielding

\[
\mathfrak S(h)=\sum_{q\ge1}\frac{\mu(q)^2}{\varphi(q)^2}c_q(h).
\]

The Ramanujan expansion itself is classical. Gadiyar–Padma 1999 and related work are important prior art for the spectral/Wiener–Khintchine side. The BC/KMS sieve-projection formulation is the candidate synthesis.

## Criticality result E0
For the BC KMS_\(\beta\) local measure, the normalized k-point sieve correlator has local factor asymptotically

\[
\log L_{\beta,p}(H)=(k-1)(p^{-\beta}-p^{-1})+O(p^{-2}+p^{-2\beta}).
\]

Hence for admissible \(H\), the normalized infinite correlation is finite and nonzero **iff \(\beta=1\)**:

\[
\beta<1:\infty,\qquad \beta=1:\mathfrak S(H),\qquad \beta>1:0.
\]

This makes the singular series a genuine critical phenomenon.

### Finite-size critical window — novelty candidate
Set

\[
\beta_z=1+\frac{\lambda}{\log z}.
\]

Then

\[
\frac{C_{\beta_z,z}(H)}{C_{1,z}(H)}
\to
\exp\left((k-1)\int_0^1\frac{e^{-\lambda u}-1}{u}\,du\right).
\]

This universal crossover depends on tuple geometry only through the critical amplitude \(\mathfrak S(H)\) and on \(k\). Prior-art search needed before novelty claim.

## Addition × multiplication forces beta=1 in the affine algebra
In Cuntz's arithmetic ax+b setting, residue partition relation

\[
\sum_{k=0}^{n-1}u^ke_nu^{-k}=1
\]

plus multiplicative KMS dynamics gives \(\omega(e_n)=n^{-\beta}\), while additive translation invariance forces \(n\omega(e_n)=1\). Therefore \(\beta=1\).

Interpretation: additive residue entropy and multiplicative dilation energy balance exactly at the BC critical point.

## Goldbach/gap finite-place equivalence and positive-cone breaking
At every finite prime \(p\), Goldbach local condition

\[
x\in\mathbb Z_p^\times,\quad N-x\in\mathbb Z_p^\times
\]

is mapped by \(y=-x\) to the gap condition

\[
y\in\mathbb Z_p^\times,\quad y+N\in\mathbb Z_p^\times.
\]

Thus Goldbach and gap local densities are identical at every finite place; their distinction is archimedean/sign-sector.

On signed integers, reflection of one particle exchanges sum and difference observables. For even/symmetrized sequences, additive convolution and autocorrelation become equivalent. Homometric ambiguity on the positive cone disappears under symmetrization. This is result E1: **the phase/homometry distinction is fundamentally a positive-cone effect**.

A useful identity from the other agent: for the symmetrized prime indicator, the representation count obeys

\[
r_{\rm sym}(N)=r_{\rm Goldbach}(N)+2c_{\rm gap}(N).
\]

Symmetrized positivity means “every even N is a sum or difference of two primes,” weaker than Goldbach.

## Cuntz / Toeplitz boundary quotient insight
The clean translation-invariant arithmetic algebra is a **boundary quotient** of the concrete ax+b Toeplitz/semigroup algebra. The concrete algebra on \(\ell^2(\mathbb N)\) remembers the positive boundary and finite intervals; quotienting by compacts produces exact translation invariance.

This suggests:
- Hardy–Littlewood local equilibrium belongs naturally to the boundary quotient.
- Prime conjectures are boundary-sensitive and should be studied in the lift / Toeplitz extension.

This is a major conceptual redirection.

## Exact sieve projection in the affine algebra
For affine shifts/forms, residue projections can be multiplied into a finite sieve projection \(E_{H,z}\). In finite volume \(P_X\),

\[
\operatorname{Tr}(P_XE_{H,z})
\]

is exactly the count of integers in the interval whose shifted forms have no prime factor \(\le z\). The critical quotient/KMS trace gives exactly

\[
\prod_{p\le z}(1-\nu_p(H)/p).
\]

Thus the ratio

\[
\mathcal B_H(X,z)=\frac{\operatorname{Tr}(P_XE_{H,z})}{X\tau(E_{H,z})}
\]

measures actual diagonal arithmetic divided by finite-adic equilibrium.

## Buchstab as boundary renormalization
For one integer, if \(z=X^{1/u}\), rough-number counting gives

\[
\Phi(X,z)\sim \frac{X\omega(u)}{\log z}.
\]

Critical KMS/Mertens predicts \(XV(z)\sim e^{-\gamma}X/\log z\). Hence

\[
\boxed{\mathcal B_{\{0\}}(u)=e^\gamma\omega(u).}
\]

As \(u\to\infty\), this tends to 1 (KMS equilibrium). At the prime stopping horizon \(u=2\), \(\omega(2)=1/2\), giving \(e^\gamma/2\).

Interpretation: ordinary Buchstab is the one-body boundary-renormalization flow from profinite equilibrium to the positive-integer prime horizon.

## Many-body boundary factorization — main conjectural target
For admissible affine/shift tuple \(H=\{h_1,\dots,h_k\}\), with possibly distinct roughness depths \(u_i\), define the actual rough-tuple count divided by its exact finite-adic local density, then divide further by each one-body Buchstab boundary factor.

The connected interaction \(\kappa_H\) / free energy \(\Gamma_H=\log\kappa_H\) is conjectured to tend to 1 / 0:

\[
\boxed{\kappa_H(\mathbf u)\to1}\qquad\text{or}\qquad\boxed{\Gamma_H(\mathbf u)\to0.}
\]

Equivalent free solution:

\[
B_H(\mathbf u)\stackrel{?}=e^{k\gamma}\prod_i\omega(u_i).
\]

At \(u_i=2\) this is equivalent to Hardy–Littlewood prime tuples after the singular series has been factored out.

Fresh numerical experiments in the thread found the connected ratio within roughly 0.2% of 1 for several gaps and asymmetric sieve depths at moderate X. Evidence only, not proof.

## Exact affine Buchstab / ax+b flow
Peeling a least/new prime factor \(p\) from one affine form and parametrizing the corresponding residue class by

\[
n=r+pm
\]

sends the system of affine forms to another affine system. For every \(q\ne p\), multiplication by \(p\) is invertible mod \(q\), so the local forbidden-residue count \(\nu_q\) is unchanged. Therefore **one Buchstab RG step modifies exactly one Euler place** while acting globally by an ax+b transformation.

This is an exact renormalization-locality property and strongly motivates the affine algebra as the correct state space.

## NEWEST FRONTIER: parity eigenmodes of the affine Buchstab flow
The sieve parity problem is not just a vague obstruction. In the classical linear sieve, upper/lower functions \(F,f\) diagonalize into

\[
B(s)=F(s)+f(s)=2e^\gamma\omega(s),
\]

\[
P(s)=F(s)-f(s),
\]

with exact delay equations

\[
(sB(s))'=B(s-1),\qquad (sP(s))'=-P(s-1).
\]

Thus Buchstab is the even/symmetric mode and the parity obstruction is a sign-reversed delay eigenmode. Extremizers are tied to \(1\mp\lambda(n)\), so this is genuinely Liouville parity.

Because Liouville \(\lambda\) is completely multiplicative, the affine arithmetic algebra admits a natural \(\mathbb Z_2\) gauge automorphism

\[
s_n\mapsto\lambda(n)s_n,\qquad u\mapsto u.
\]

The critical Haar/KMS diagonal sieve observables are gauge-even and therefore blind to the odd Liouville sector. **Candidate structural explanation of the sieve parity barrier:** local equilibrium projects out precisely the parity mode distinguishing primes from semiprimes.

### k-leg generalization
Track the parity vector

\[
(\lambda(L_1(n)),\dots,\lambda(L_k(n)))\in(\mathbb Z/2)^k.
\]

Fourier-transform over \((\mathbb Z/2)^k\). For each subset \(J\subseteq[k]\), define the parity character mode

\[
A_J=\sum_n \left[\prod_i1_{P^-(L_i(n))>z_i}\right]\prod_{j\in J}\lambda(L_j(n)).
\]

When a Buchstab step peels one prime from leg \(i\), complete multiplicativity contributes the eigenvalue

\[
(-1)^{1_{i\in J}}.
\]

Therefore the full many-body affine Buchstab hierarchy should diagonalize into **\(2^k\) parity-character sectors**. The ordinary Hardy–Littlewood/KMS field is only the trivial character \(J=\varnothing\); all nontrivial parity modes are invisible to the local sieve background.

This is the strongest live direction as of this checkpoint. Next task: derive the exact coupled/delay evolution for these \(2^k\) modes in the affine-form state space, identify what boundary/spectral data determines the odd sectors, and test whether Dirichlet L-zero information / Burnol causality naturally controls those modes.

## Dead / downgraded branches
- Raw Lorentz/Minkowski interpretation: useful coordinates, but not enough by itself.
- “Full gap field loses phase”: false once heat/radial variable is retained.
- “One PNT-centered tensor square universally centers Goldbach and gaps”: false structurally.
- “Two-zero Goldbach explicit formula is novel”: prior art.
- “Screw positivity automatically transfers to quadratic sector”: unsupported; no free complete-positivity theorem found.
- “BC singular-series identity itself proves prime correlations”: false; it captures local equilibrium only. Hard arithmetic is diagonal/positive-cone/boundary sampling and parity.

## Literature landmarks to remember
- Bost–Connes / Neshveyev KMS structure and critical \(\beta=1\).
- Cuntz arithmetic ax+b algebra / boundary quotient / Toeplitz extension.
- Gadiyar–Padma (1999) Ramanujan–Fourier + Wiener–Khintchine heuristics for Hardy–Littlewood.
- Murty surveys / Ramanujan expansions.
- Languasco–Zaccagnini, Brüdern–Kaczorowski–Perelli, Egami–Matsumoto, Bhowmik–Schlage-Puchta: Goldbach explicit formulas and zero-pair sums.
- Matsumoto–Suzuki (2024): Goldbach secondary term / screw function iff RH.
- Burnol: adelic scattering / causality / RH for abelian L-functions; use only when mathematically forced.
- Tao adelic sampling/major-arc framework.
- Grimmelt–Teräväinen rough/Cramér replacement work.
- Recent sieve work involving shifted primes and high-level tails (verify exact statements before citing).

## Research ethos
Do not optimize for quick publication. Pressure-test first. If a branch becomes tautological, abandon it. If a result works, push consequences. If literature blocks novelty, use it to sharpen the live target. Fundamental-physics interpretations are welcome only when they produce exact mathematical machinery or forced structural identifications.
