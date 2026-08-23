# PRIME-PAIR RESEARCH DELTA — 2026-08-11

This delta is intended to be merged into the canonical Arithmetic Research Ledger / PRIME_PAIR_RESEARCH_STATE. It records only durable additions and corrections from the latest derivation run.

## VERIFIED EXACT — charge-deformed Buchstab identity
For
\[
R_z(x,y)=\sum_{\substack{2\le n\le x\\P^-(n)>y}} z^{\Omega(n)-1},
\]
least-prime-factor peeling gives
\[
R_z(x,y)=\pi(x)-\pi(y)+z\sum_{y<p\le\sqrt x}R_z(x/p,p).
\]
The corresponding scale function satisfies
\[
(u\omega_z(u))'=z\omega_z(u-1),\qquad \omega_z(u)=1/u\ (1\le u\le2).
\]
Thus ordinary Buchstab is z=1 and the classical parity eigenmode is z=-1.

## VERIFIED EXACT — convolution semigroup
Let
\[
\mu_z=\delta_0+z\omega_z(u)\,du.
\]
With \(E_1(s)=\int_s^\infty e^{-t}dt/t\),
\[
\widehat\mu_z(s)=\exp(zE_1(s)),
\]
so
\[
\mu_{z_1}*\mu_{z_2}=\mu_{z_1+z_2}.
\]
Equivalently \(\mu_z=\exp_*(zf)\) for \(f(u)=1_{u\ge1}/u\). Parity z=-1 is the convolution inverse of ordinary factorization flow z=1.

## VERIFIED EXACT — parity sectors become exact prime projectors in first Buchstab window
If \(y>X^{1/3}\), every y-rough \(n\le X\) has \(\Omega(n)\in\{1,2\}\), hence
\[
1_{\mathbb P}(n)=(1-\lambda(n))/2
\]
on that rough sector. For k simultaneously rough affine forms,
\[
\prod_i1_{\mathbb P}(L_i(n))
=2^{-k}\sum_{J\subseteq[k]}(-1)^{|J|}\prod_{j\in J}\lambda(L_j(n)).
\]
Thus prime tuples are exactly the Walsh transform of the 2^k parity-character sectors once the Buchstab flow has reduced every leg to charge 1 or 2.

## CORRECTION — gauge blindness was overstated
The full divisibility diagonal does determine factorization charge:
\[
\Omega(N)=\sum_p\sum_{r\ge1}1_{p^r\mid N}.
\]
So the parity barrier is NOT a literal superselection rule. The obstruction is finite-scale truncation / large-prime cross-scale coherence. Gauge language remains useful for diagonalizing parity modes but should not be stated as algebraic incapacity of the full sieve algebra.

## VERIFIED EXACT — factorization fugacity / prime projector
\[
F(z,s)=\sum_n z^{\Omega(n)}n^{-s}=\prod_p(1-zp^{-s})^{-1}.
\]
The charge-one coefficient is the prime zeta function. On occupation-number space, \(C=\Omega(N)=\sum_pv_p\) and \(1_{\{C=1\}}\) is exactly the prime projector.
For shifted pairs,
\[
K_{X,h}(z,w)=\sum_{n\le X}z^{\Omega(n)-1}w^{\Omega(n+h)-1}
\]
is the generating kernel whose value at (0,0) is the exact prime-pair count.

## VERIFIED EXACT — generic p-adic charge cluster factor
For distinct residues \(h_i\bmod p\), set \(a_i=1-z_i\). The normalized local factor is
\[
A_{p,H}(\mathbf z)=1-\sum_{r=2}^k\frac{(r-1)e_r(a_1,\ldots,a_k)}{(p-1)^r}.
\]
The entire O(1/p) interaction cancels exactly; generic local interaction begins at p^{-2}. Shift-specific deeper structure is confined to collision primes / higher p-adic collision trees.

## VERIFIED EXACT — finite-adic Goldbach/gap equality holds for full charge deformation
For every finite p, N, and fugacities z1,z2,
\[
\int_{\mathbb Z_p}z_1^{v_p(x)}z_2^{v_p(N-x)}dx
=\int_{\mathbb Z_p}z_1^{v_p(y)}z_2^{v_p(y+N)}dy
\]
by y=-x. Thus Goldbach and gap channels have identical entire finite-adic charge-deformed local factors, not merely the same Hardy–Littlewood value at z1=z2=0. Their distinction is global/archimedean at every factorization depth.

## NOVELTY CANDIDATE / MASTER CONJECTURE — shifted adelic Selberg–Delange
For primitive affine forms \(L_i\), define
\[
\mathcal Z_{H,X}(\mathbf z)=\sum_{n\le X}\prod_i z_i^{\Omega(L_i(n))-1}
\]
and
\[
\mathfrak A_H(\mathbf z)=\prod_p(1-p^{-1})^{\sum_i z_i-k}\int_{\mathbb Z_p}\prod_i z_i^{v_p(L_i(x))}\,dx.
\]
Natural conjecture:
\[
\mathcal Z_{H,X}(\mathbf z)\sim X(\log X)^{\sum_i(z_i-1)}\frac{\mathfrak A_H(\mathbf z)}{\prod_i\Gamma(1+z_i)}.
\]
Endpoint checks: z=1 gives bulk/trivial normalization; z=0 gives Hardy–Littlewood prime tuples; negative integer z hits gamma zeros and parity-type secondary regimes. This is a conjectural organizing theorem, not a proved result.

## LIVE FRONTIER — low-charge boundary layer
Fixed factorization charge is extracted at saddle scale
\[
z\asymp1/\log\log X.
\]
Hence the true prime frontier is uniform shifted/parallel-form Selberg–Delange as z=z(X) enters the 1/loglog X boundary layer. Existing Green–Tao-type linear-form correlation machinery for multiplicative functions generally excludes the parallel forms n,n+h / n,N-n that are exactly relevant here. The target is therefore specifically SHIFTED/PARALLEL-FORM charge correlations, not generic independent linear forms.

## NOVELTY CANDIDATE — complex-analytic propagation strategy
After dividing by the predicted local and one-body factors, obtain holomorphic normalized functions F_X(z). If one can prove uniform local boundedness on a connected domain containing z=0 and convergence to 1 on a subset with an interior accumulation point, Vitali/Montel propagates convergence to z=0. Thus Hardy–Littlewood could be reframed as a normal-family/uniformity theorem toward the low-charge boundary. This is a meta-lemma/attack strategy, not a proof.

## VERIFIED EXACT — affine Buchstab fixed-determinant state space
Encode two affine forms by
\[
M=\begin{pmatrix}a&b\\c&d\end{pmatrix}.
\]
Peeling p from leg 1 with n=r+pm acts by
\[
M'=\begin{pmatrix}p^{-1}&0\\0&1\end{pmatrix}M\begin{pmatrix}p&r\\0&1\end{pmatrix},
\]
so det M is invariant. For the pair n,n+h, |det M|=h.
After peeled divisors A|n, B|n+h (coprime noncollision part), CRT yields residual forms
\[
Bm+t,\qquad Am+s,
\]
with
\[
Bs-At=h.
\]
Thus the two-leg Buchstab recursion naturally evolves on integer matrices of fixed determinant h. h=1 gives an SL_2(Z)/Farey-type state space; general h suggests fixed-determinant/Hecke geometry. Representation-theoretic exploitation is a LIVE FRONTIER; the identity itself is exact.

## LIVE FRONTIER — integration target
Unify three exact structures:
1. scale/Buchstab flow u;
2. factorization-charge semigroup z;
3. affine fixed-determinant state h / matrix M.
Seek an exact transfer operator on fixed-determinant affine states whose z-eigenmodes are the charge-deformed Buchstab modes, then decompose its rational/character spectrum to connect to Dirichlet L-functions and the existing KMS/explicit-formula architecture.
