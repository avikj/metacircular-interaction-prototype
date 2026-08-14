# PRIME-PAIR RESEARCH DELTA — divisor-lattice characteristic polynomial and two-charge renormalization

## VERIFIED EXACT — factorization characteristic polynomial
For every positive integer n define
\[
\Phi_n(t)
=
\sum_{d\mid n}\mu(n/d)t^{\Omega(d)}.
\]
This is the Möbius transform of the rank-generating function of the divisor lattice, graded by \(\Omega\).

For a prime power \(p^a\),
\[
\Phi_{p^a}(t)=t^a-t^{a-1}=t^{a-1}(t-1).
\]
By multiplicativity,
\[
\boxed{
\Phi_n(t)
=
t^{\Omega(n)-\omega(n)}(t-1)^{\omega(n)}.
}
\]

This is, up to the conventional rank reversal, the characteristic polynomial of the ranked divisor lattice (a product of chains). For squarefree n it is the Boolean-lattice characteristic polynomial \((t-1)^{\omega(n)}\).

## VERIFIED EXACT — closed formula for every fixed-charge divisor kernel
Let
\[
\kappa_r=1_{\{\Omega=r\}}*\mu.
\]
Since
\[
\Phi_n(t)=\sum_{r\ge0}\kappa_r(n)t^r,
\]
we obtain
\[
\boxed{
\kappa_r(n)
=
\begin{cases}
(-1)^{\Omega(n)-r}
\binom{\omega(n)}{r-\Omega(n)+\omega(n)},
&
0\le r-\Omega(n)+\omega(n)\le\omega(n),\\
0,&\text{otherwise}.
\end{cases}
}
\]

Consequences:
- \(\kappa_r(n)\neq0\) only if the repeated-prime excess
  \[
  \Omega(n)-\omega(n)\le r;
  \]
- for primes \(r=1\), support consists exactly of squarefree integers and integers with one squared prime and all other exponents one;
- on squarefree n,
  \[
  \kappa_r(n)=(-1)^{\omega(n)-r}\binom{\omega(n)}r.
  \]

This gives explicit sparse coefficient structure for the canonical charge boundary operator.

## VERIFIED EXACT — two independent factorization charges
Define
\[
R(n)=\Omega(n)-\omega(n)
\quad\text{(repeat/prime-power charge),}
\]
\[
W(n)=\omega(n)
\quad\text{(distinct-prime support charge).}
\]
Then
\[
\Omega=R+W.
\]

The bivariate grand partition function is
\[
\boxed{
\mathcal F(u,v;s)
=
\sum_n\frac{u^{R(n)}v^{W(n)}}{n^s}
=
\prod_p\left(1+\frac{v p^{-s}}{1-u p^{-s}}\right)
=
\prod_p\frac{1+(v-u)p^{-s}}{1-u p^{-s}}.
}
\]

Specializations:
- \(u=v=z\): \(F(z,s)=\sum z^{\Omega(n)}n^{-s}\);
- \((u,v)=(1,1)\): \(\zeta(s)\);
- \(u=0\): squarefree distinct-prime field \(\prod_p(1+vp^{-s})\);
- \((u,v)=(0,-1)\): \(1/\zeta(s)\), Möbius;
- \((u,v)=(-1,-1)\): \(\zeta(2s)/\zeta(s)\), Liouville;
- primes are the canonical coefficient \([u^0v^1]\mathcal F=\sum_p p^{-s}\).

The divisor-lattice characteristic polynomial is the one-dimensional line
\[
\boxed{\Phi_n(t)=t^{R(n)}(t-1)^{W(n)},}
\]
i.e. \((u,v)=(t,t-1)\).

## VERIFIED EXACT — only distinct-prime charge controls the critical singularity
For bounded \(u,v\) near the relevant region,
\[
\mathcal F(u,v;s)=\zeta(s)^v\,G(u,v;s),
\]
where
\[
G(u,v;s)
=
\prod_p
\frac{1+(v-u)p^{-s}}{1-u p^{-s}}
(1-p^{-s})^v
\]
has local logarithm with its \(p^{-s}\) term canceled and is analytic/nonzero in a standard half-plane beyond \(\Re s>1/2\), modulo finitely many local singularities.

Thus:
\[
\boxed{
v=\omega\text{-fugacity is the relevant critical coupling;}
\qquad
u=\Omega-\omega\text{ is an analytic prime-power correction.}
}
\]

This is a rigorous renormalization statement: repeated prime powers do not control the logarithmic critical exponent. The hard prime boundary can be placed entirely in the squarefree plane \(u=0\), with \(v\to0\) / coefficient \(v^1\).

## CONJECTURAL UPGRADE — shifted two-charge Selberg–Delange
The natural shifted master family should be refined to
\[
\sum_{n\le X}
\prod_i
u_i^{\Omega(L_i(n))-\omega(L_i(n))}
v_i^{\omega(L_i(n))}.
\]
The predicted log exponent is controlled only by \(\sum_i(v_i-1)\); all \(u_i\) dependence belongs to the holomorphic local factor. Exact prime tuples are the coefficient
\[
\prod_i[u_i^0v_i^1].
\]

Potential strategic gain: work first in the squarefree plane \(u_i=0\), eliminating the analytically irrelevant prime-power direction, and attack uniformity only in distinct-prime charge \(v_i\sim1/\log\log X\).

## MATROID / TUTTE STATUS
The matroid lens is now mathematically real but specific:
- the divisor lattice is a product of chains;
- \(\Phi_n(t)\) is its characteristic polynomial;
- fixed-charge kernels are its Whitney coefficients.
A richer arithmetic-matroid theory is unnecessary unless it supplies estimates for shifted products of these coefficients. The exact useful object is the divisor-lattice characteristic polynomial above.
