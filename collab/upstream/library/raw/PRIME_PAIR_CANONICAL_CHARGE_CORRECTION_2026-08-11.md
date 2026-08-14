# CRITICAL CORRECTION AND UPGRADE — exact canonical-charge divisor kernels

## CORRECTION
For the grand-canonical family \(f_z(n)=z^{\Omega(n)}\), the endpoint \(z=0\) is the vacuum function \(\delta_1(n)\), not the prime indicator. Its divisor kernel \(a_0=\mu\) describes exact cancellation / local roughness, not exact primality.

Exact primes are the CHARGE-ONE CANONICAL SECTOR:
\[
1_{\mathbb P}(n)=1_{\{\Omega(n)=1\}}=[z]\,z^{\Omega(n)}
=\left.\partial_z z^{\Omega(n)}\right|_{z=0}.
\]
Equivalently use the desingularized family \(z^{\Omega(n)-1}\) for \(n\ge2\).

Any earlier statement saying “the exact prime boundary has divisor weights \(\mu\)” must be replaced by the theorem below.

## VERIFIED EXACT — fixed-charge Möbius kernels
For every \(r\ge0\), define
\[
q_r(n)=1_{\{\Omega(n)=r\}},
\qquad
\kappa_r=q_r*\mu
\]
(Dirichlet convolution). Then
\[
\boxed{q_r=1*\kappa_r.}
\]
Thus fixed factorization charge \(r\) has an exact divisor expansion
\[
1_{\{\Omega(n)=r\}}=\sum_{d\mid n}\kappa_r(d).
\]

For primes \(r=1\),
\[
\boxed{\kappa_1(d)=\sum_{p\mid d}\mu(d/p).}
\]
In particular:
- if \(d\) is squarefree with \(\omega(d)=j\), then \(\kappa_1(d)=j(-1)^{j-1}=-j\mu(d)\);
- if \(d=p^2m\) with \(m\) squarefree and \(p\nmid m\), then \(\kappa_1(d)=\mu(pm)\);
- if \(d\) has a cube factor or two distinct squared-prime factors, \(\kappa_1(d)=0\).

So the exact prime divisor kernel is sparse and Möbius-coherent, but it is NOT multiplicative.

## VERIFIED EXACT — canonical charge symbols
For a Dirichlet character \(\chi\), let
\[
F_\chi(z,s)
=\sum_n z^{\Omega(n)}\chi(n)n^{-s}
=\prod_p(1-z\chi(p)p^{-s})^{-1}
=\sum_{r\ge0}Z_{r,\chi}(s)z^r,
\]
where
\[
Z_{r,\chi}(s)=\sum_{\Omega(n)=r}\chi(n)n^{-s}.
\]
The twisted Dirichlet series of \(\kappa_r\) is
\[
\boxed{
K_{r,\chi}(s)
=
\sum_n\kappa_r(n)\chi(n)n^{-s}
=
\frac{Z_{r,\chi}(s)}{L(s,\chi)}.
}
\]

For primes:
\[
\boxed{
K_{1,\chi}(s)
=
\frac{P_\chi(s)}{L(s,\chi)},
\qquad
P_\chi(s)=\sum_p\chi(p)p^{-s}.
}
\]

Thus the true prime boundary sector contains BOTH:
- a canonical one-particle/prime-zeta numerator \(P_\chi\);
- the reciprocal Dirichlet-\(L\) denominator \(1/L(s,\chi)\).

This is the corrected character symbol that must replace the oversimplified \(1/L\) claim for exact primes.

## VERIFIED EXACT — symmetric-power / Bell-polynomial numerators
Since
\[
\log F_\chi(z,s)
=
\sum_{j\ge1}\frac{z^j}{j}P_{\chi^j}(js),
\]
the fixed-charge numerator is the complete symmetric-function cycle index
\[
\boxed{
Z_{r,\chi}(s)
=
\sum_{\lambda\vdash r}
\prod_{j\ge1}
\frac{P_{\chi^j}(js)^{m_j}}{j^{m_j}m_j!},
}
\]
where \(\lambda\) has \(m_j\) parts of size \(j\).

Examples:
\[
Z_{1,\chi}=P_\chi(s),
\]
\[
Z_{2,\chi}=\frac12\left(P_\chi(s)^2+P_{\chi^2}(2s)\right).
\]

Newton recurrence:
\[
\boxed{
rZ_{r,\chi}(s)
=
\sum_{j=1}^r
P_{\chi^j}(js)Z_{r-j,\chi}(s).
}
\]

This makes the fixed-charge tower an exact symmetric-power hierarchy over the one-prime spectrum.

## VERIFIED EXACT — exact fixed-charge shifted CRT boundary theorem
For charges \(r,t\) and shift \(h\),
\[
C_{r,t}(X;h)
=
\sum_{n\le X}
1_{\Omega(n)=r}1_{\Omega(n+h)=t}
\]
has the exact divisor/CRT expansion
\[
\boxed{
C_{r,t}(X;h)
=
\sum_{d,e}\kappa_r(d)\kappa_t(e)N_X(d,e;h).
}
\]
As before, \(N_X=0\) unless \((d,e)\mid h\), and in the compatible case
\[
N_X=X/[d,e]+B_X(a,[d,e]).
\]

Therefore every fixed almost-prime correlation, including prime pairs \(r=t=1\), decomposes exactly into:
1. a CRT equilibrium term;
2. a positive-cone boundary term with modular-inverse/Kloosterman phases.

After multiplicative-character diagonalization, the charge-\(r\) boundary symbol is \(Z_{r,\chi}/L(s,\chi)\). For exact primes it is \(P_\chi/L\).

## STRUCTURAL CONSEQUENCE — canonical vs grand-canonical obstruction
The grand-canonical fugacity field factorizes over Euler places. Extracting a fixed total charge coefficient destroys that local tensor-product factorization:
- grand canonical: Euler product \(F_\chi(z,s)\);
- canonical charge \(r\): symmetric-power coefficient \(Z_{r,\chi}(s)\);
- divisor/CRT boundary kernel: \(Z_{r,\chi}(s)/L(s,\chi)\).

This is a precise statistical-mechanical form of the local-to-prime obstruction. Static local equilibrium controls the grand-canonical field; primes require a canonical one-particle projection coupling all prime modes globally.

## LIVE FRONTIER
Use \(\kappa_1\), not \(\mu\), in the exact smoothed CRT/Kloosterman boundary operator for prime pairs. Determine whether its special structure
\[
K_{1,\chi}=P_\chi/L
\]
permits stronger cancellation than arbitrary coefficients in Kloosterman-fraction bounds. Analyze moments of \(P_\chi/L\) over characters/moduli and compare with reciprocal-\(L\) large sieve technology. This is the corrected direct spectral target.
