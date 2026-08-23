# PRIME-PAIR RESEARCH FANOUT DELTA — 2026-08-11 09:xx PT

Authoritative inputs: PRIME_PAIR_RESEARCH_STATE.md + PRIME_PAIR_RESEARCH_STATE_DELTA_2026-08-11.md (delta precedence). This file records only new durable consequences / branch triage from deliberate conceptual fan-out.

## EXACT — p-adic/tropical dendrogram completely determines each local charge factor
For a fixed prime p and labeled shifts H={h_i}, define
\[
d_{ij}=v_p(h_i-h_j).
\]
The relations h_i≡h_j mod p^r are equivalent to d_{ij}>=r. Hence the matrix (d_{ij}) determines the entire nested sequence of residue partitions modulo p,p^2,...; conversely that nested partition tree determines all d_{ij}. The local collision-tree recursion for
\[
E_p(H;\mathbf z)=\int_{\mathbb Z_p}\prod_i z_i^{v_p(x+h_i)}dx
\]
uses only these nested partitions. Therefore E_p factors through the finite ultrametric dendrogram of H at p. For two legs this reduces to the single edge length v_p(h).

Interpretation: the exact local geometry is naturally tropical/ultrametric. No p-adic unit cross-ratio beyond collision depths enters for one-dimensional translates x+h_i.

## EXACT — generic equal-fugacity local zero geometry
If k shifts are distinct mod p, the unnormalized equal-fugacity local moment simplifies to
\[
I_{p,k}(z)=\frac{p-k+(k-1)z}{p-z}.
\]
Thus its nontrivial finite zero is
\[
\boxed{z_p=\frac{k-p}{k-1}}.
\]
At z=-1 this occurs exactly when p=2k-1, recovering the finite-place parity annihilation phenomenon. As p grows, z_p moves to -infinity linearly. After the standard normalization, additional zeros occur at z=p (far on the positive real axis).

CONSEQUENCE: on any fixed compact neighborhood of the radial segment [0,1], all sufficiently large generic primes are locally zero-free. Therefore there is no accumulation of finite-adic Lee-Yang zeros at the prime boundary z=0. Any analytic obstruction to continuing shifted-charge asymptotics from bulk toward z=0 must be GLOBAL / nonuniform in X / diagonal-sampling in origin, not a local Euler-factor phase transition.

## EXACT — fixed determinant is complete good-prime collision invariant
For residual forms L1=Bm+t, L2=Am+s with h=Bs-At and p not dividing AB,
\[
\alpha=-t/B,\quad\beta=-s/A,\quad \alpha-\beta=h/(AB),
\]
so v_p(alpha-beta)=v_p(h). Thus determinant valuation gives the complete local p-adic collision depth at good primes.

## EXACT — generic fixed-determinant dynamics abelianizes after translation quotient
When gcd(A,B)=1, all solutions of Bs-At=h differ by t->t+Bk, s->s+Ak. Modulo simultaneous integer translation there is one intercept class per ordered coprime pair (A,B). For p not dividing h, a peeled prime can enter only one leg, so the quotient dynamics simply multiplies A or B by p. Genuine coupled/noncoprime branching is supported only at primes p|h, exactly the singular-series collision primes.

CONSEQUENCE / BRANCH TRIAGE: the Farey/Hecke representation is exact and useful, but ordinary bi-invariant Hecke spectral theory is unlikely by itself to contain the hard prime-pair remainder. After local collision factors are removed, the generic finite-place dynamics is essentially a two-color prime-assignment process. The hard connected interaction must come from scale ordering, positive-cone stopping, coherent additive sampling, or global L-spectral effects.

## COMBINATORIAL LENS — divisor lattice rank
The divisor lattice of n=prod p^{a_p} is a product of chains graded by Omega(d). Thus Omega(n) is its maximal rank; primes are rank-1 factorization lattices. The fugacity z^{Omega} is a rank-generating weight, and Buchstab peeling removes one cover/atom step. This exactly explains why each peel carries eigenvalue z. Useful conceptual compression; no new analytic estimate yet.

## MATROID LENS — downgraded to hierarchical partition polynomial
At a fixed p, first-layer local information is a partition of legs by coincident roots; higher layers refine this partition into an ultrametric tree. This is more naturally a rooted hierarchical partition/dendrogram polynomial than an ordinary matroid. Arithmetic-matroid/Tutte language should not be forced unless a genuine deletion-contraction invariant is found.

## ADDITIVE-COMBINATORICS / ERGODIC LENS
For finite cyclic models, f_z(n)=z^{Omega(n)-1} has two-point shifted correlation whose Fourier transform is |fhat_z|^2. Thus the two-leg charge problem is fundamentally U^2/Fourier-level. Host-Kra/nilsystems are not currently forced for fixed two-point gaps. For k>=3 fixed parallel shifts, higher correlations exist but standard multi-parameter nilsystem machinery is not obviously the right geometry; revisit only if Buchstab recursion creates extra averaging parameters.

## GRAPH/IHARA LENS — low priority
The ax+b inverse branches define a directed graph/semigroup action on Q/Z and hence admit dynamical/Ruelle zeta constructions. But Buchstab flow is scale-ordered and essentially acyclic in least-prime scale; ordinary Ihara cycle spectra arise only after forgetting ordering, which likely discards the hard boundary information. No theorem-level connection to prime pairs found; downgrade.

## STATISTICAL-MECHANICS / PROBABILITY LENS — exact semigroup interpretation
The charge-deformed Buchstab measure mu_z has Laplace transform exp(z E1(s)). It is a locally finite convolution exponential with generator 1_{u>=1}du/u. After exponential tilting at s0>0 and normalization it becomes an infinitely divisible probability law with Levy density proportional to z e^{-s0 u}du/u. Thus the scalar Buchstab flow has a mathematically exact infinitely-divisible/renormalization interpretation. Target: determine whether the many-leg positive-cone transfer operator is a coupled lift of this scalar Levy semigroup.

## PHYSICS / ROVELLI LENS — exact core, no added theorem yet
On factorization occupation space H=log N and C=Omega(N) commute; additive translation U_h does not commute with them. Prime-gap counts are matrix elements/traces of U_h between C=1 sectors. This is naturally relational ('given additive displacement h, correlate charge-one events') and the fugacity z is conjugate to C. BC affine equilibrium fixes the logarithmic energy and zero charge chemical potential, while primes are an extreme low-charge boundary condition. This is legitimate statistical-mechanical/constrained-observable language, but RQM/LQG/spinfoams currently add no mathematical machinery; do not force them.

## METAMATHEMATICS / PROOF COMPRESSION — conceptual only
The charge representation compresses primality to the boundary value z=0 of z^{Omega-1}, and all fixed almost-prime strata become Taylor coefficients of one analytic family. This is representation-dependent proof-language compression. There is currently no incompleteness/proof-complexity theorem. A serious metamathematical result would require actual upper/lower bounds on proof/certificate size in competing representations; none established.

## STRONGEST RECONNECTED FRONTIER
The local side is now unusually rigid:
- full p-adic tuple geometry = ultrametric collision dendrograms;
- two-leg good-prime geometry = determinant valuation;
- generic good primes are leg-disjoint after singular-series normalization;
- local charge Euler factors are holomorphic/zero-free near the radial path to z=0 for all sufficiently large p.

Therefore the remaining prime-pair obstruction is increasingly localized to the GLOBAL BOUNDARY OPERATOR: scale-ordered Buchstab stopping + positive-cone diagonal sampling + coherent rational-frequency/L-function modes.

Highest-value next derivation: write the charge-deformed two-leg positive-cone transfer operator after exact division by the p-adic dendrogram factors and one-body Buchstab semigroup. Identify its connected kernel Gamma_h explicitly. Then test whether its Fourier decomposition on Q/Z gives the previously derived additive prime-translation eigenvalues and Dirichlet L'/L character transforms. If yes, the local sieve, Buchstab boundary flow, and L-spectrum finally become successive factors of one operator rather than parallel descriptions.
