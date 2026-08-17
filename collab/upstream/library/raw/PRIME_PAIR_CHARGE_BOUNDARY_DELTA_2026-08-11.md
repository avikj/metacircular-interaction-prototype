# PRIME-PAIR RESEARCH DELTA — exact charge-divisor transform and charge-deformed CRT boundary operator

## VERIFIED EXACT — divisor kernel for factorization fugacity
Define a_z multiplicatively by
\[
a_z(1)=1,\qquad a_z(p^r)=(z-1)z^{r-1}\quad(r\ge1).
\]
Then for every n,
\[
\boxed{z^{\Omega(n)}=\sum_{d|n}a_z(d).}
\]
Equivalently a_z=(z^{\Omega})*\mu under Dirichlet convolution. Its Dirichlet series is
\[
\boxed{A_z(s)=\sum_da_z(d)d^{-s}=\frac{F(z,s)}{\zeta(s)}=\prod_p\frac{1-p^{-s}}{1-zp^{-s}}.}
\]
Endpoints:
- z=1: a_1=delta_1, so the divisor correction disappears (bulk/trivial field);
- z=0: a_0(p)=-1, a_0(p^r)=0 for r>=2, so a_0=mu. Thus coherent Möbius inclusion-exclusion is exactly the prime-boundary z=0 member of the charge-divisor family.

## VERIFIED EXACT — charge-deformed pair count has the same CRT boundary operator
For finite X and fixed h, define
\[
S_{z,w}(X;h)=\sum_{n\le X}z^{\Omega(n)}w^{\Omega(n+h)}.
\]
Expanding both divisor kernels and interchanging finite sums gives
\[
\boxed{S_{z,w}(X;h)=\sum_{d,e}a_z(d)a_w(e)N_X(d,e;h),}
\]
where d,e are automatically bounded by the values occurring and N_X(d,e;h) is the same simultaneous-divisibility CRT count as in the sieve endpoint.

For g=(d,e), N_X=0 unless g|h. In the compatible case, with L=[d,e] and CRT residue a(d,e;h),
\[
N_X=X/L+B_X(a,L).
\]
Therefore exactly
\[
S_{z,w}=X\sum_{(d,e)|h}\frac{a_z(d)a_w(e)}{[d,e]}
+\Delta_{z,w}(X;h),
\]
with
\[
\boxed{\Delta_{z,w}=\sum_{(d,e)|h}a_z(d)a_w(e)B_X(a(d,e;h),[d,e]).}
\]
(Use finite-X truncations on d,e; passage to infinite Euler products is a separate asymptotic/renormalization step.)

This is the exact LOCAL-EQUILIBRIUM + POSITIVE-CONE-BOUNDARY decomposition for the full factorization-charge family.

## VERIFIED EXACT — automorphic inverse phases persist for every charge
For (d,e)=1, a/L=-h d^{-1}/e mod 1. Fourier expansion of B_X therefore yields phases
\[
e(-k h d^{-1}/e).
\]
The weights are now a_z(d)a_w(e) instead of mu(d)mu(e). Hence the Kloosterman/inverse-residue boundary geometry survives throughout charge space. At z=w=0 it specializes to Möbius-weighted prime/sieve boundary phases; at z=w=1 all nontrivial divisor weights vanish.

## MAJOR SYNTHESIS
We now have two independent diagonalizations of the same charge-boundary object:
1. factorization depth: z,w enter through multiplicative divisor kernels a_z,a_w, with Dirichlet transform F(z,s)/zeta(s);
2. positive-cone CRT boundary geometry: Fourier expansion produces modular inverse/Kloosterman phases.

This strongly suggests a two-parameter spectral program:
- Selberg-Delange / charge analysis in z,w;
- Kuznetsov/automorphic spectral analysis in the inverse-residue boundary variables.

The Hardy-Littlewood prime-pair endpoint is z=w=0, where A_0=1/zeta and the boundary weights become coherent Möbius amplitudes. This reconnects the earlier amplitude/intensity split directly to the positive-cone boundary operator.

## LIVE FRONTIER
Analyze Delta_{z,w}(X;h) in the mesoscopic boundary layer z,w~1/log log X. Determine whether existing dispersion/Kuznetsov estimates give uniform control for any radial range z=(loglog X)^(-alpha). Even alpha<1 would constitute genuine progress toward the charge boundary. Search prior art on shifted convolution of z^{Omega}, Selberg-Delange with shifts, Linnik dispersion, Kloosterman refinements, and spectral large sieve before novelty claims.
