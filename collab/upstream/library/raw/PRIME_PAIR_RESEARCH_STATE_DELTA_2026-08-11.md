# Prime-Pair Research State — Delta Checkpoint 2026-08-11

This file is a delta to merge into the canonical PRIME_PAIR_RESEARCH_STATE.md. It records results derived after the prior canonical checkpoint.

## EXACT / PROJECT-DERIVED: factorization charge completes the pair state
Define C=Omega(N). On two legs use C_tot=Omega(N1)+Omega(N2). For m,n>=2, both entries are prime iff C_tot=2. Thus Goldbach and fixed-gap prime-pair events are respectively (S=N, C_tot=2) and (D=h, C_tot=2), while S^2-D^2=4Q continues to encode additive/multiplicative geometry.

## CORRECTION: parity is not a true hidden superselection sector
The earlier statement that divisibility/KMS diagonal observables are algebraically incapable of seeing Omega was too strong. On the integer representation,
Omega(N)=sum_p sum_{r>=1} E_{p^r},
where E_{p^r} projects onto multiples of p^r. Thus the full divisibility diagonal determines factorization charge. The genuine obstruction is scale truncation / large-prime coherence: a finite sieve only sees Omega_{<=y}.

At y=sqrt(X), for n<=X,
Omega(n)=Omega_{<=sqrt(X)}(n)+epsilon_X(n), epsilon_X(n) in {0,1}.
So the unresolved tail at the exact primality horizon is only one bit of factorization charge. This strongly suggests Buchstab recursion as the correct scale-flow language.

## EXACT: charge-deformed Buchstab identity
For complex z define the desingularized rough-charge sum
R_z(x,y)=sum_{2<=n<=x, P^-(n)>y} z^{Omega(n)-1}.
Least-prime-factor peeling gives exactly
R_z(x,y)=pi(x)-pi(y)+ z sum_{y<p<=sqrt(x)} R_z(x/p,p).
The factor z is one extra factorization charge after peeling the least prime.

The continuum delay family is
omega_z(u)=0 for u<1,
omega_z(u)=1/u for 1<=u<=2,
(u omega_z(u))'=z omega_z(u-1).
Thus ordinary Buchstab is z=1 and the classical sign-reversed parity mode is z=-1.

## EXACT: Laplace solution and convolution semigroup
Let W_z(s)=int_1^infty exp(-su) omega_z(u) du and E1(s)=int_s^infty exp(-t)/t dt. Boundary accounting gives
1+z W_z(s)=exp(z E1(s)).
Define the locally finite measure
mu_z=delta_0+z omega_z(u)du.
Then
Laplace(mu_z)=exp(z E1(s)),
so
mu_{z1} * mu_{z2}=mu_{z1+z2}.
Equivalently mu_z=exp_*(z f) with f(u)=1_{u>=1}/u.
Consequences: the charge-one generator is d/dz mu_z|_{z=0}=f du; ordinary factorization flow is mu_1; parity mode is the convolution inverse mu_{-1}=mu_1^{*-1}.

This subsumes the previous +/- Buchstab parity eigenmodes into one analytic charge semigroup.

## EXACT: first nontrivial Buchstab window gives Walsh reconstruction of primes
If y>X^{1/3}, every y-rough n<=X has Omega(n) in {1,2}. Hence on this rough sector
1_P(n)=(1-lambda(n))/2.
For k affine forms simultaneously constrained to this window,
prod_i 1_P(L_i(n))=2^{-k} sum_{J subset [k]} (-1)^|J| prod_{j in J} lambda(L_j(n)),
with the roughness indicators included.
Thus after enough roughness to force Omega<=2, the prime-tuple count is exactly the Walsh transform of the 2^k parity-character sectors. Controlling the nontrivial sectors is literally equivalent to removing semiprime contamination in this window.

## EXACT: factorization fugacity / grand partition function
F(z,s)=sum_n z^{Omega(n)} n^{-s}=prod_p (1-z p^{-s})^{-1}.
The charge-one coefficient is the prime zeta function: [z]F(z,s)=sum_p p^{-s}. z=1 gives zeta(s); z=-1 gives zeta(2s)/zeta(s).
On occupation-number coordinates ell^2(N) ~= tensor_p ell^2(N_0), H=log N=sum_p v_p log p and C=Omega(N)=sum_p v_p, so Tr(z^C e^{-sH})=F(z,s). The exact prime projector is Pi_1=1_{C=1}.

For additive translation U_h, the kernel
K_{X,h}(z,w)=Tr(P_X z^{C-1} U_h^* w^{C-1} U_h)
equals sum_{n<=X} z^{Omega(n)-1}w^{Omega(n+h)-1}. At z=w=0 this is exactly the prime-gap count.

## EXACT: prime extraction is a boundary-value problem in charge space
For shifts H={h_1,...,h_k}, define
Z_{H,X}(z_1,...,z_k)=sum_{n<=X} prod_i z_i^{Omega(n+h_i)-1}.
Then Z_{H,X}(0,...,0) is exactly the prime-k-tuple count (assuming all forms >=2). More generally the Taylor coefficient of prod z_i^{r_i-1} counts the stratum Omega(n+h_i)=r_i.

The fixed-charge saddle occurs at |z|~k/log log X. Thus exact primes (k=1) live in a boundary layer z~1/log log X ->0. This explains why control of unit-modulus multiplicative phases (Chowla/Elliott) need not approach twin-prime precision: it controls angular behavior near |z|=1, while prime extraction requires radial penetration toward z=0 with X-dependent precision.

## EXACT: normalized local p-adic charge field
For additive Haar X in Z_p define
g_{p,z}(x)=((1-z/p)/(1-1/p)) z^{v_p(x)}.
Then E[g_{p,z}]=1. z=0 is exactly the normalized local sieve/unit field; z=1 is the trivial field. Hence the KMS/sieve and factorization-charge branches are one deformation.

For p^k || h, k>=1, with a=z1 z2,
E[g_{p,z1}(X)g_{p,z2}(X+h)]
=1+((z1-1)(z2-1)/(p-1)) [ sum_{r=0}^{k-1}(a/p)^r - a^k/(p^k(p-1)) ].
For p not dividing h,
E[g_{p,z1}(X)g_{p,z2}(X+h)]
=1-(z1-1)(z2-1)/(p-1)^2.
At z1=z2=0 these are the Hardy-Littlewood prime-pair local factors.

Goldbach and gap local equivalence extends to every fugacity pair: by y=-x,
int z1^{v_p(x)}z2^{v_p(N-x)}dx = int z1^{v_p(y)}z2^{v_p(y+N)}dy.
Thus the two channels have the same entire finite-adic charge-deformed local theory, not merely the same singular series at z=0.

## EXACT: local collision-tree recursion for k legs
For shifts H and variables z_i define
E_p(H;z)=int_{Z_p} prod_i z_i^{v_p(x+h_i)} dx.
Partition indices by equal residues h_i mod p. For a block B with common residue r_B, let H'_B={(h_i-r_B)/p:i in B}. Then
E_p(H;z)=1-nu_p(H)/p + (1/p) sum_{B} (prod_{i in B} z_i) E_p(H'_B;z_B).
Thus the full local charge interaction is determined by the p-adic collision tree. Hardy-Littlewood is only the z=0 first-layer truncation.

For primes p where all k shifts are distinct mod p, putting a_i=1-z_i gives the closed normalized factor
A_{p,H}(z)=1-sum_{r=2}^k (r-1)e_r(a_1,...,a_k)/(p-1)^r.
The 1/p term cancels exactly. Generic finite-prime interactions begin at p^{-2}; all exceptional shift geometry is confined to collision primes.

## EXACT: multifractal moments of the charge-deformed finite-adic martingale
Let G_{y,z}(x)=prod_{p<=y} g_{p,z}(x_p). Under finite-adic Haar,
E|G_{y,z}|^r=(log y)^{tau_r(z)+o(1)},
tau_r(z)=r(1-Re z)+|z|^r-1.
At z=0 this gives tau_r=r-1, recovering the critical sieve field's divergent moments; z=1 is the L2-nonexplosive equilibrium point.

## CONJECTURAL MASTER LOCAL/GLOBAL FAMILY: shifted charge Selberg-Delange
For primitive affine forms L_i, define
A_H(z)=prod_p (1-p^{-1})^{sum_i z_i-k} int_{Z_p} prod_i z_i^{v_p(L_i(x))} dx.
The generic p^{-1} cancellation suggests a holomorphic local factor in a neighborhood including z=0 and z=1.

Natural conjecture:
Z_{H,X}(z) ~ X (log X)^{sum_i(z_i-1)} A_H(z) / prod_i Gamma(1+z_i).
Endpoint tests:
- z_i=1: trivial/bulk count ~X;
- z_i=0: Hardy-Littlewood prime tuples with A_H(0)=singular series;
- derivatives near 1: joint Sathe-Selberg / Erdos-Kac cumulants;
- negative integers encounter zeros of 1/Gamma(1+z), explaining disappearance of ordinary main terms in parity-like sectors.

Important prior-art correction: Green-Tao/Matthiesen-style linear correlations of multiplicative functions generally require independent/nonparallel linear parts; n and n+h (and n,N-n) are the degenerate parallel geometry we actually need. Thus the target is specifically SHIFTED/PARALLEL-FORM Selberg-Delange, uniformly in charge toward z~1/log log X.

Boundary-layer prediction: with L=log log X and z_i=lambda_i/L,
Z_{H,X}(lambda_1/L,...,lambda_k/L)
~ singular_series(H) X/(log X)^k exp(sum_i lambda_i).
This would resolve the fixed-charge tower in a universal Poisson-like boundary layer; lambda_i=0 is the prime endpoint.

## EXACT META-LEMMA: analytic continuation route
After dividing Z_{H,X} by the predicted local factor, Gamma factors, and powers of log X, obtain a holomorphic normalized family F_X(z). If F_X is locally uniformly bounded on a connected domain containing z=0 and converges to 1 on a subset with an interior accumulation point, Vitali/Montel implies convergence to 1 throughout the domain, including z=0. Thus one possible route to Hardy-Littlewood is: prove a shifted-charge asymptotic away from the prime point plus a strong normal-family bound through the prime boundary. This does not solve the hard estimate; it identifies exactly what uniformity would suffice.

## EXACT: affine Buchstab matrix action and determinant invariant
Encode two affine forms by M=[[a,b],[c,d]], with (L1(n),L2(n))^T=M(n,1)^T. Peeling p from leg 1, writing n=r+pm and dividing that leg by p, gives
M' = diag(p^{-1},1) M [[p,r],[0,1]].
Hence det M'=det M.
For L1=n,L2=n+h, det M=h up to convention: the gap is an exact invariant of every Buchstab RG step.

After peeled divisors A|n, B|n+h with (A,B)=1, CRT n=r+ABm gives residual forms
n/A=Bm+t, (n+h)/B=Am+s,
with
Bs-At=h.
Thus the state is the integer matrix [[B,t],[A,s]] of fixed determinant h. For h=1 this is SL_2(Z)/Farey-type geometry; general h is fixed-determinant Hecke-type geometry. The elementary Buchstab step is generated by ax+b matrices [[p,r],[0,1]].

NOVELTY CANDIDATE / LIVE FRONTIER: determine whether this fixed-determinant affine Buchstab walk has a natural realization as a Hecke/Bruhat-Tits/automorphic dynamical system, and whether its spectral decomposition controls the connected boundary interaction that remains after finite-adic singular-series and one-body Buchstab factors are divided out.

## LIVE FRONTIER
1. Develop the charge-deformed many-body Buchstab flow and see whether the scalar convolution semigroup lifts to affine-form states.
2. Study the fixed-determinant matrix state space generated by prime ax+b peeling. Determine precise relation (if any) to Hecke correspondences, Bruhat-Tits trees, modular/Farey dynamics, transfer operators, and automorphic spectra.
3. Formulate/prove any shifted/parallel-form Selberg-Delange theorem uniform for z=z(X) approaching 0. Mesoscopic z=(log log X)^(-alpha), alpha<1, would already be new progress; alpha=1 is the finite-charge/prime frontier.
4. Connect the charge-deformed finite-adic local field to the existing BC/Cuntz KMS framework and completed-zeta/Goldbach one-zero/two-zero sectors without forcing an analogy.
5. Investigate complex-z zero geometry (Lee-Yang-style) only if it yields actual control of analytic continuation toward z=0.
6. Correct/retire the old claim that the full sieve diagonal is gauge-blind to Omega; the obstruction is finite-scale truncation and cross-scale coherence.
