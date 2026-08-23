# PRIME-PAIR RESEARCH DELTA — charge/character spectral interpolation

## VERIFIED EXACT — multiplicative-character diagonalization of CRT inverse phases
Let q>=1 and work on G=(Z/qZ)^×. For a unit a mod q and r in G,
\[
e_q(a\bar r)
=
\frac1{\phi(q)}
\sum_{\chi\bmod q}
\overline{\chi(a)}\,\tau(\chi)\,\chi(r),
\]
where
\[
\tau(\chi)=\sum_{v\bmod q}^{*}\chi(v)e_q(v).
\]
More generally, if (a,q)>1, replace \(\overline{\chi(a)}\tau(\chi)\) by the generalized Gauss coefficient
\[
\tau_a(\chi)=\sum_{v\bmod q}^{*}\chi(v)e_q(av).
\]
This is just Fourier inversion on the finite unit group after the substitution v=\bar r.

Therefore the modular-inverse/Kloosterman phase in the exact CRT positive-cone boundary operator diagonalizes into Dirichlet-character sectors.

## VERIFIED EXACT — charge divisor kernel has twisted symbol F_chi/L
Recall the exact divisor kernel
\[
a_z(1)=1,\qquad a_z(p^r)=(z-1)z^{r-1},
\]
so \(z^{\Omega(n)}=\sum_{d|n}a_z(d)\).

For any Dirichlet character \(\chi\),
\[
\boxed{
\mathcal A_\chi(z,s)
:=
\sum_{n\ge1}\frac{a_z(n)\chi(n)}{n^s}
=
\prod_p\frac{1-\chi(p)p^{-s}}{1-z\chi(p)p^{-s}}
=
\frac{F_\chi(z,s)}{L(s,\chi)},
}
\]
where
\[
F_\chi(z,s)=\prod_p(1-z\chi(p)p^{-s})^{-1}
=\sum_n z^{\Omega(n)}\chi(n)n^{-s}.
\]

Endpoints:
\[
\boxed{\mathcal A_\chi(1,s)=1,}
\qquad
\boxed{\mathcal A_\chi(0,s)=1/L(s,\chi).}
\]

Thus additive bulk charge \(z=1\) has no nontrivial character spectrum, while the prime/sieve boundary \(z=0\) turns on the reciprocal Dirichlet-L spectrum exactly.

## VERIFIED EXACT — fractional inverse-L spectral flow
In any simply connected zero-free domain for \(L(s,\chi)\), choose a branch of \(L^z\). Then
\[
F_\chi(z,s)=L(s,\chi)^z\,G_\chi(z,s),
\]
with
\[
G_\chi(z,s)
=
\prod_p
\frac{(1-\chi(p)p^{-s})^z}{1-z\chi(p)p^{-s}}.
\]
The logarithm of the local correction is
\[
\log G_\chi(z,s)
=
\sum_p\sum_{m\ge2}\frac{z^m-z}{m}\chi(p)^m p^{-ms},
\]
since the m=1 term cancels. Hence \(G_\chi\) is analytic/nonzero in the standard Selberg-Delange region (at least locally for Re(s)>1/2 and z in compact neighborhoods of [0,1], away from finitely many local poles).

Therefore
\[
\boxed{
\mathcal A_\chi(z,s)
=
L(s,\chi)^{z-1}G_\chi(z,s).
}
\]

If \(\rho\) is an L-zero of multiplicity m, the character-sector charge symbol has local singular exponent
\[
\boxed{m(z-1).}
\]
So:
- z=1: zero singularity cancels completely;
- z=0: pole of order m;
- 0<z<1: fractional inverse-L branch singularity;
- z=-1: inverse-square-type singularity, up to the analytic local factor.

This is an exact charge-controlled spectral interpolation from equilibrium to inverse-L amplification.

## MAJOR SYNTHESIS — exact spectral factorization of the positive-cone boundary
The charge-deformed pair boundary operator has:
1. CRT Fourier modes \(e(a\bar d/q)\);
2. finite-unit multiplicative Fourier transform in d, yielding Dirichlet characters;
3. Mellin transform in divisor scale, yielding the symbol \(\mathcal A_\chi(z,s)=L(s,\chi)^{z-1}G_\chi(z,s)\).

Thus the same exact boundary operator is diagonalized by:
- charge z: factorization-depth direction;
- characters \(\chi\): rational/cyclotomic direction;
- Mellin s: multiplicative scale direction.

At the prime boundary z=0 its eigen-symbol is \(1/L(s,\chi)\). This is the cleanest exact mechanism currently found by which the full abelian L-zero spectrum enters prime-pair boundary sampling.

## INTERPRETATION / OBSTRUCTION
GRH controls the location of the singular set of \(\mathcal A_\chi(0,s)\), but not the magnitude/cancellation of the full bilinear boundary operator. Any proof route through this factorization needs uniform reciprocal-L control across growing moduli together with cancellation among Gauss/Kloosterman sectors. This explains structurally why GRH alone is unlikely to imply twin primes: it locates poles but does not provide the required multi-modulus inverse-L large-sieve estimate.

## LIVE FRONTIER
Formulate a smoothed exact spectral expansion of the charge boundary discrepancy:
\[
\Delta_{z,w}(X;h)
\rightsquigarrow
\sum_q\frac1{\phi(q)}
\sum_{\chi\bmod q}
\tau_{a}(\chi)\,
\mathcal A_\chi(z,\cdot)\,
(\text{second-leg transform in }w)\,
(\text{archimedean kernel}).
\]
Then identify the precise norm estimate which, uniformly for z,w~1/loglog X, would imply Hardy-Littlewood. Compare with:
- multiplicative large sieve / reciprocal-L moments;
- Linnik dispersion;
- Bettin-Chandee/DFI Kloosterman-fraction bounds;
- Kuznetsov spectral decomposition.
Do not claim novelty until this composition is searched carefully; every component is classical, but the charge-boundary factorization may be new as an integrated framework.
