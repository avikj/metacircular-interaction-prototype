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

## 2026-08-11 DELTA: Atiyah/Hirzebruch/index-theoretic branch

### Prior-art correction: zeta-as-index is already real mathematics
- Mauro Spera (2012), *The Riemann zeta function as an equivariant Dirac index*, interprets zeta via an R-equivariant L2 Dirac-Ramond index, gives a Lefschetz-Atiyah-Bott interpretation, and presents a fermionic BC-type model with critical beta=1. Therefore do NOT claim novelty for the broad statement “zeta should be an equivariant Dirac index.”
- Connes (1998) realizes zeta zeros spectrally on the adele class space; Connes–Consani–Marcolli formulate the explicit formula as a Lefschetz trace formula and RH as positivity of a trace pairing. Again, broad index/Lefschetz language is prior art.
- Greenfield–Marcolli–Teh construct a type-III twisted spectral triple for BC with sign F=lambda and eta function Tr(F e^{-beta H})=zeta(2 beta)/zeta(beta); sigma=Ad(F) acts by mu_n -> lambda(n) mu_n. This rigorously identifies the sieve parity grading with an existing BC spectral grading.

### EXACT: Todd/Hirzebruch characteristic factors occur directly in BC Euler factors
Let Q_y(x)=x(1+y e^{-x})/(1-e^{-x}) be the Hirzebruch chi_y characteristic power series (convention: y=0 Todd, y=1 signature). For each prime set x_p=s log p, q_p=e^{-x_p}=p^{-s}. Then for Re(s)>1:

1. BC bosonic local Euler factor is a normalized Todd factor:
   1/(1-p^{-s}) = Q_0(x_p)/x_p.
   Hence formally/exactly as a convergent Euler product,
   zeta(s)=prod_p Q_0(x_p)/x_p.

2. The Liouville-graded BC eta factor is the ratio of Todd and chi_1/signature characteristic factors:
   Q_0(x)/Q_1(x)=1/(1+e^{-x}),
   therefore
   zeta(2s)/zeta(s)=sum lambda(n)n^{-s}=prod_p Q_0(x_p)/Q_1(x_p).

This is a striking exact bridge from Atiyah/Hirzebruch’s chosen machinery to the *specific parity sector* that our sieve analysis independently identified as missing. Targeted searches did not reveal this exact packaging; classify as NOVELTY CANDIDATE / synthesis until a deeper prior-art search.

3. More generally define
   Z_y(s)=prod_p (1+y p^{-s})/(1-p^{-s}).
   Then
   Z_y(s)=prod_p Q_y(x_p)/x_p = sum_n (1+y)^{omega(n)} n^{-s}
   (with the n=1 coefficient 1). Thus the Hirzebruch chi_y deformation corresponds arithmetically to weighting an integer by the number omega(n) of distinct prime divisors. At y=0 it is zeta; y=1 gives zeta(s)^2/zeta(2s); y=-1 collapses to 1. The Liouville eta function is zeta(s)/Z_1(s).

4. The Hardy–Littlewood local k-tuple factor at critical beta=1 can itself be written in Hirzebruch-factor form. With q=1/p, x=log p, and nu=nu_p(H):
   (1-nu/p)/(1-1/p)^k
   = [Q_{-nu}(x)/x] [Q_0(x)/x]^{k-1}.
   Here y=-nu varies with p, so this is not an ordinary fixed-y genus; it suggests an *adelically inhomogeneous Hirzebruch characteristic product* whose local genus parameter is the forbidden-residue count. Exact identity, interpretation conjectural. Targeted searches did not locate “Hardy–Littlewood singular series as Hirzebruch/Todd characteristic product.”

### EXACT / conceptual: symmetric powers unify Goldbach and zeta
Let V_P be the formal one-particle vector space with one basis vector for each prime.
- Under additive energy H_+(|p>)=p|p>, the degree-2 symmetric/tensor sector has character controlled by A(q)^2 (and Sym^2 character (A(q)^2+A(q^2))/2); its weight-N multiplicities are Goldbach pair counts up to ordered/unordered and diagonal conventions.
- Under multiplicative energy H_x(|p>)=(log p)|p>, the full bosonic symmetric algebra Sym(V_P) has partition function
  prod_p (1-e^{-s log p})^{-1}=zeta(s).
Thus Goldbach and zeta are two different second-quantized observables of the same prime one-particle object: Goldbach probes the two-particle sector under additive energy, while zeta is the full bosonic Fock partition under logarithmic/multiplicative energy.
- Lambda-ring/Adams-operation form: log zeta(s)=sum_{r>=1}(1/r) sum_p p^{-rs}, i.e. zeta is the plethystic exponential of the prime Dirichlet spectrum. This places the +/x bridge naturally inside lambda-ring/K-theory power operations rather than merely the earlier Lorentz identity.
- BC/endomotive connections to lambda-rings and Witt vectors are established prior art, so novelty would have to lie in coupling this power-operation formalism specifically to Goldbach/pair projections/parity flow.

### Index-theoretic reformulation of the parity barrier
In the first Buchstab cell (rough cutoff z with 2<u<=3, suitable finite-volume convention), the prime indicator can be extracted from roughness and Liouville chirality:
  1_P(n)=rho_z(n)(1-lambda(n))/2
when the rough survivors have only the relevant one- or two-factor possibilities (check interval/cutoff hypotheses carefully in every use).
Operatorically, with rough projection E_z and grading F=lambda:
  Pi_prime = E_z(1-F)/2.
Hence prime counting decomposes into an ordinary trace and a graded supertrace:
  Tr(P_X Pi_prime)=1/2[Tr(P_X E_z)-Tr(P_X E_z F)].
The first term is the Buchstab/KMS-even sector controlled by sieve theory. The second is exactly the Liouville parity sector that sieve methods cannot determine.

This makes the Atiyah-Singer analogy precise enough to test: an index theorem computes a supertrace by converting analytic information to topological/local information. A hypothetical arithmetic index theorem capable of computing Tr(E_z F) would attack exactly the sieve parity obstruction.

### Critical obstruction: the existing BC Dirac is NOT an ordinary supersymmetric index operator
For the BC twisted spectral triple, D=F H (or F exp H) has F as its sign; D COMMUTES with F rather than anticommutes with it. Consequently Tr(F e^{-beta H})=zeta(2beta)/zeta(beta) is temperature-dependent and is an eta/graded thermal trace, not a McKean–Singer Witten index. There is no automatic cancellation of nonzero even/odd states.
This identifies a sharper missing object: an odd operator/supercharge Q with {Q,F}=0 whose square or transfer dynamics is naturally tied to the arithmetic Hamiltonian/sieve flow. If such a Q existed with the right Fredholm/Toeplitz properties, its index pairing could turn Liouville parity cancellation into a local/topological invariant. Do not assume such Q exists; constructing or proving impossibility is a major target.

### Prime Fock decomposition suggests where such an odd structure could live
Unique factorization gives a tensor decomposition over prime occupation numbers: n <-> (v_p(n))_p and H=sum_p (log p) N_p, F=(-1)^{sum N_p}. Each prime mode is a bosonic oscillator with parity grading. Its ordinary local partition is 1/(1-q); graded local trace is 1/(1+q). The grading is therefore genuine occupation parity. However adjacent parity states have energies separated by log p, explaining why the physical BC Hamiltonian does not furnish ordinary supersymmetric pairing. This is a structural reason the eta function is non-topological.

### Atiyah manuscript lens, pressure-tested
Atiyah’s 2018 RH manuscript explicitly says he sought a fusion of Hirzebruch’s Todd-polynomial algebra/arithmetic with von Neumann analytic operator theory, viewing the passage as discrete-to-continuous and algebra-to-analysis. His actual T-function properties/proof are inconsistent and must not be rehabilitated. But the lens unexpectedly matches our surviving structure: BC/von Neumann/KMS on one side; Todd/Hirzebruch characteristic factors and lambda-ring power operations on the other; Liouville parity sits exactly in their ratio.

### Strong live target after this delta
Construct (or rule out) a *graded affine Toeplitz index theory* for the arithmetic ax+b semigroup in which:
1. the even/KMS quotient gives Hardy–Littlewood local densities;
2. the grading F is Liouville parity;
3. finite-volume prime projectors are rough projections times (1-F)/2;
4. the Toeplitz boundary extension retains the positive cone/archimedean stopping information erased by the Cuntz boundary quotient;
5. a K-homology/KK/cyclic-cocycle pairing measures the parity supertrace or its scale flow;
6. the characteristic-class side naturally produces the Todd/chi_y Euler factors above;
7. character twists produce Dirichlet L-family parity traces L(2s,chi^2)/L(s,chi), connecting the one-body graded sector to GRH;
8. multi-leg products of gradings recover the interacting Chowla sectors needed beyond GRH.

This is now the strongest Atiyah-inspired branch. It does NOT currently prove RH/Goldbach; its value is that it locates the exact missing parity observable inside index-theoretic language and reveals a previously unnoticed exact Todd/Hirzebruch factorization of the BC and Hardy–Littlewood local factors.

## 2026-08-11 DELTA: Farey-edge / Cuntz branch realization of Buchstab states

### EXACT: fixed-determinant affine state = rational endpoint pair
Write a primitive two-form state in CRT coordinates

M=[[B,t],[A,s]],   Bs-At=h.

Associate rational endpoints

x=t/B,   y=s/A.

Then exactly

y-x=h/(AB).

For h=1, the determinant-one condition Bs-At=1 is precisely the criterion that t/B and s/A are oriented Farey neighbors. Thus the h=1 two-leg Buchstab state space is literally an oriented Farey-edge state space (with scale/positivity data retained). For general h it is a determinant-h generalized Farey pair.

Modulo simultaneous integer translation of the parameter m (right multiplication by [[1,k],[0,1]]), the constants change t->t+Bk, s->s+Ak, so the endpoint pair shifts by the same integer. The quotient state is naturally an oriented rational pair on R/Z together with denominator/scale data.

### EXACT: every noncollision Buchstab peel is a diagonal ax+b inverse branch
Suppose p does not divide the relevant slope and choose r mod p so that one affine leg is divisible by p after m=r+p m'. For either leg, the new endpoint pair is

(x',y')=((x+r)/p,(y+r)/p).

This follows directly from the matrix peel formulas. Therefore the geometric action on the rational pair is the diagonal inverse branch

phi_{p,r}(u)=(u+r)/p

of the circle endomorphism u -> p u mod 1. This is exactly the affine branch family underlying the arithmetic ax+b/Cuntz system; the earlier Cuntz connection is therefore not merely philosophical — the actual Buchstab state update uses its canonical inverse branches.

The distinction between which leg was peeled is encoded by rational reduction. If p does not divide h, the congruences making both endpoint numerators divisible by p cannot hold simultaneously, since

B(s+Ar)-A(t+Br)=h not congruent 0 mod p.

Hence exactly one endpoint cancels a factor p after applying phi_{p,r}; the other denominator acquires p. In CRT variables this is A->pA (leg 1 peeled) or B->pB (leg 2 peeled). Thus away from collision primes, the branch itself plus reduction remembers the leg.

If p|h, simultaneous cancellation can occur. These are exactly the collision primes where the two local divisibility conditions cease to be transverse and where the p-adic charge factor differs from the generic radial factor. Therefore the same dichotomy appears simultaneously in:
- affine/Buchstab branch dynamics;
- rational/Farey endpoint reduction;
- determinant-h Hecke geometry;
- p-adic Igusa collision factors;
- Hardy-Littlewood singular-series corrections.

### Structural consequence
For p not dividing h, the two-leg arithmetic is locally a transverse two-branch system inside the p inverse branches of x->px mod 1; for p|h the branches collide/couple. The generic local prime-pair numerator 1-2/p is exactly the Haar mass of the p-2 branches hitting neither forbidden residue; when p|h the two forbidden branches merge and the mass becomes 1-1/p. This recovers the singular-series local geometry directly from the same ax+b branch dynamics that drives Buchstab peeling.

This gives a much tighter unification:

Buchstab least-prime peeling = scale-ordered traversal of ax+b inverse branches;
Hardy-Littlewood local factor = branch-survival probability at charge zero;
Hecke determinant h = conserved global pair invariant;
p-adic collision depth v_p(h) = local radial/BT coordinate controlling branch mergers.

### Transfer-operator target sharpened
The correct operator is not the ordinary spherical Hecke operator. It should be a positive-cone, scale-ordered Ruelle/Exel transfer operator built from the partial inverse branches phi_{p,r}, acting diagonally on determinant-h rational pairs and carrying a two-leg charge label. Ordinary Hecke symmetry appears after forgetting the stopping/least-prime ordering; the hard prime problem lives in the non-self-adjoint lift retaining that boundary information.

This explains why passing too quickly to the Cuntz boundary quotient or a bi-invariant Hecke operator loses exactly the information sieve parity/prime stopping needs. The next task is to write this partial transfer operator explicitly, identify its even equilibrium eigenfunction (Buchstab/KMS), and determine the odd/low-charge spectral sector required to reach z=0.

### EXACT: generic k-leg local charge factor and parity-annihilation primes
If the k shifts h_i occupy distinct residue classes modulo p, every occupied residue cluster is a singleton. The collision-tree recursion then closes explicitly:

I_{p,H}(z_1,...,z_k)
=1-k/p +(1/p)\sum_i z_i (p-1)/(p-z_i).

For equal parity fugacity z_i=-1 this becomes

I_{p,H}(-1,...,-1)=(p+1-2k)/(p+1).

Hence whenever p=2k-1 is prime and the k affine shifts are distinct mod p, the finite-adic Haar expectation of the k-leg Liouville parity character vanishes EXACTLY at that single place. The k=2 case is the previously observed p=3 zero for h not divisible by 3; k=3 gives a p=5 annihilation when the three shifts are distinct mod 5, etc.

This does NOT prove Chowla-type cancellation for integer averages; it is a statement about the finite-adic equilibrium model. But it sharpens the parity-sector picture: some nontrivial Walsh/Liouville sectors are not merely small in the local equilibrium — they can be exactly annihilated by a finite Euler place. The positive-integer boundary lift must therefore reconstruct global parity correlations from data that may be identically zero in the boundary quotient, reinforcing the distinction between profinite/KMS equilibrium and boundary-sensitive arithmetic.

This also gives a concrete Lee-Yang-style zero geometry for the local charge partition function. Treat that only as exact algebraic zero structure unless it yields a rigorous global consequence.
