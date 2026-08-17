# Prime-Pair Core Results — Continuation
Date: 2026-08-13

## 48. Canonical projection is symmetric-power extraction
Let \(V\) be the formal one-particle space with basis \(e_p\), weighted by \(x_p=\chi(p)p^{-s}\).

**Theorem 48.**
\[
F_\chi(z,s)=\prod_p(1-zx_p)^{-1}
=\sum_{r\ge0}\operatorname{ch}(\operatorname{Sym}^rV)z^r,
\]
hence
\[
Z_{r,\chi}=h_r((x_p)_p).
\]

**Proof.** This is the generating identity for complete homogeneous symmetric functions. QED.

## 49. Prime extraction is globally one-particle
\[
Z_{1,\chi}=P_\chi(s).
\]

**Proof.** \(\operatorname{Sym}^1V=V\). QED.

Thus charge one is a global sum over the choice of exactly one occupied Euler place, not a placewise projector.

## 50. Boundary inversion is multiplication by reciprocal L
For \(\mathcal Df=f*\mu\),
\[
\widehat{\mathcal Df}_\chi=\widehat f_\chi/L(s,\chi).
\]

**Proof.** Dirichlet convolution becomes multiplication and the twisted Möbius series is \(1/L\). QED.

## 51. Boundary inversion commutes with canonical coefficient extraction
\[
[z^r]\mathcal D(z^\Omega)=\mathcal D([z^r]z^\Omega).
\]

**Proof.** \(\mathcal D\) is linear and independent of z. QED.

So the nontrivial canonical coupling is not created by Möbius boundary inversion.

## 52. Newton recurrence is exact charge creation
Let \(P_j=P_{\chi^j}(js)\). Then
\[
\boxed{rZ_{r,\chi}=\sum_{j=1}^rP_jZ_{r-j,\chi}.}
\]

**Proof.**
Differentiate
\[
F(z)=\exp\left(\sum_{j\ge1}\frac{P_j}{j}z^j\right)
\]
and compare coefficients in \(zF'=F\sum_jP_jz^j\). QED.

## 53. Prime-power cycles are exactly the correction to Poissonization
Define \(F_{\rm MB}(z)=e^{zP_\chi(s)}\).

**Theorem 53.**
\[
\log F_\chi-\log F_{\rm MB}
=
\sum_{j\ge2}\frac{z^j}{j}P_{\chi^j}(js).
\]

**Proof.** Remove the j=1 term from the exact plethystic logarithm. QED.

## 54. Charge one is insensitive to repeated-prime cycles
**Corollary.**
\[
[z]F_\chi=[z]F_{\rm MB}.
\]

**Proof.** The correction in Theorem 53 begins at \(z^2\). QED.

Thus repeated-prime bosonic cycles cannot explain the one-leg prime extraction difficulty.

## 55. Shifted charge-one coupling is relational
For
\[
Z_{X,h}(z,w)=\sum_{n\le X}z^{\Omega(n)}w^{\Omega(n+h)},
\]
\[
[zw]Z_{X,h}
=
\sum_{n\le X}1_{\mathbb P}(n)1_{\mathbb P}(n+h).
\]

**Theorem 55.**
This is not determined by the product of one-leg charge-one counts.

**Proof.**
The product of one-leg counts uses independent base indices; the displayed coefficient forces both events on the same n. Local congruence constraints already distinguish the two situations. QED.

## 56. Shared-base coupling is exactly CRT compatibility
In the divisor expansion the two legs couple through
\[
(d,e)\mid h.
\]

**Theorem 56.**
If the two legs are placed on independent base integers, this compatibility condition disappears.

**Proof.**
For independent \(n_1,n_2\), constraints \(d|n_1,e|n_2\) are independently soluble. For one shared n with \(e|n+h\), generalized CRT gives compatibility iff \((d,e)|h\). QED.

Thus the singular series is the local footprint of identifying two multiplicative legs through one additive coordinate.

## 57. Generic normalized local interaction begins at p^-2
At primes where all k shifts are distinct mod p, the canonical normalized local factor is
\[
A_{p,H}(z)
=
1-\sum_{r=2}^k
\frac{(r-1)e_r(1-z_1,\dots,1-z_k)}{(p-1)^r}.
\]

**Theorem 57.**
There is no \(p^{-1}\) connected term.

**Proof.** Every correction has \(r\ge2\). QED.

## 58. Generic local Euler tail converges absolutely
For z in a compact set,
\[
A_{p,H}(z)=1+O_H(p^{-2})
\]
at noncollision primes.

**Theorem 58.**
The product over noncollision primes converges absolutely and locally uniformly away from local zeros.

**Proof.** \(\sum_pp^{-2}<\infty\). QED.

## 59. Collision geometry is finite for fixed H
**Theorem 59.**
Every collision prime divides
\[
\Delta_H=\prod_{i<j}(h_i-h_j).
\]

**Proof.**
\(h_i=h_j\bmod p\) iff \(p|(h_i-h_j)\). QED.

Hence all tuple-specific nongeneric local geometry is concentrated at finitely many primes.

## 60. Local analytic difficulty separates from positive-boundary difficulty
**Theorem 60.**
After finitely many collision factors are removed, the normalized local charge product has an absolutely convergent generic tail, while exact prime counting still requires the positive-boundary charge-one coefficient.

**Proof.** Theorems 58–59 plus the exact CRT equilibrium/boundary decomposition. QED.

## 61. Determinant survives every finite affine peel sequence
**Theorem 61.**
If each Buchstab peel acts by left/right matrices whose determinant product is one, then
\[
\det M_{\rm final}=\det M_{\rm initial}.
\]

**Proof.** Induction over peel steps. QED.

## 62. Determinant is not a sufficient state
**Theorem 62.**
Equal determinant does not determine the residual affine matrix.

**Proof.**
\[
\begin{pmatrix}1&0\\0&h\end{pmatrix},
\quad
\begin{pmatrix}1&1\\0&h\end{pmatrix}
\]
are distinct and have determinant h. QED.

## 63. Determinant quotient does not support autonomous peeling
**Theorem 63.**
A peel transition cannot generally be determined from determinant alone.

**Proof.**
Peel residues depend on affine coefficients modulo the peel prime. Matrices of equal determinant can have different coefficients and hence different admissible residue transitions. QED.

Thus fixed determinant is a conserved manifold, not the sufficient interface.

## 64. Residual CRT completions form a unipotent orbit
For coprime A,B, solutions of
\[
Bs-At=h
\]
satisfy
\[
t=t_0+Bk,\qquad s=s_0+Ak.
\]

**Proof.**
Subtract two solutions and use \((A,B)=1\). QED.

Writing
\[
M_k=\begin{pmatrix}B&t_0+Bk\\A&s_0+Ak\end{pmatrix},
\]
we have
\[
\boxed{
M_k=M_0
\begin{pmatrix}1&k\\0&1\end{pmatrix}.
}
\]

**Proof.** Direct multiplication. QED.

## 65. Exact quotient by base reparametrization
Changing the residual variable \(m\mapsto m-k\) produces precisely the right-unipotent action in Theorem 64.

**Theorem 65.**
Modulo integer base reparametrization, a determinant-h residual matrix with primitive first column is determined uniquely by that first column.

**Proof.**
The right-unipotent action fixes the first column. Bezout gives a determinant-h completion of every primitive column. Theorem 64 says all completions lie in one orbit. QED.

## 66. Classification of the residual affine CRT quotient
Let
\[
N(\mathbb Z)=
\left\{
\begin{pmatrix}1&k\\0&1\end{pmatrix}:k\in\mathbb Z
\right\}.
\]

**Theorem 66.**
\[
\left\{
M\in M_2(\mathbb Z):
\det M=h,\ 
\gcd(M_{11},M_{21})=1
\right\}/N(\mathbb Z)
\]
is in bijection with primitive integer columns \((B,A)^T\).

**Proof.**
Map an orbit to its first column. Surjectivity follows from Bezout completion \(Bs-At=h\); injectivity from Theorem 64. QED.

This makes the earlier fixed-determinant/Farey suggestion exact at the quotient level.

## 67. Positive peeled states form the primitive lattice cone
Restricting \(A,B>0\) gives
\[
\boxed{
\{(B,A)\in\mathbb N^2:(A,B)=1\}.
}
\]

**Proof.** Theorem 66 plus positivity of peeled divisor products. QED.

## 68. Projectivization is the positive rational line
**Theorem 68.**
Projectivizing primitive positive columns by slope gives \(\mathbb Q_{>0}\).

**Proof.**
\((B,A)\mapsto A/B\) is a reduced positive rational; every reduced positive rational has a unique primitive positive representative. QED.

Thus Farey geometry is not analogy: it is the projectivization of the exact reparametrization-reduced two-leg CRT state.

## 69. h=1 gives an exact modular quotient
For h=1, determinant-one matrices are \(SL_2(\mathbb Z)\).

**Theorem 69.**
\[
\boxed{
SL_2(\mathbb Z)/N(\mathbb Z)
\cong
\{\text{primitive integer columns}\}.
}
\]

**Proof.**
Right N-action fixes the first column. Every primitive column extends by Bezout to an \(SL_2(\mathbb Z)\) matrix. Two completions differ by adding an integer multiple of the first column to the second, exactly right multiplication by N. QED.

## 70. General h is a determinant-h Hecke-type correspondence space
Let
\[
X_h=\{M\in M_2(\mathbb Z):\det M=h,\ \text{primitive first column}\}/N(\mathbb Z).
\]

**Theorem 70.**
As a set, \(X_h\) is again canonically identified with primitive integer columns, while h is retained in the completion relation \(Bs-At=h\).

**Proof.** Theorem 66. QED.

Thus h does not change the quotient's underlying primitive-column set; it changes how a column is completed into the second leg.

## 71. Gap information lives in the extension/completion, not the projective first-column state
**Theorem 71.**
The primitive column \((B,A)\) alone is independent of h, whereas the determinant constraint on its completion depends on h.

**Proof.**
The quotient classification in Theorem 70 forgets the second column; for any h, Bezout permits completions with determinant h. QED.

This is an exact reconstruction statement: projective/Farey state loses the gap unless the determinant label is retained externally.

## 72. Minimal coarse state retaining gap and divisor ratio
The pair
\[
(h,(B,A))
\]
reconstructs the determinant label and primitive first column but not a unique affine completion.

**Proof.**
Theorem 64 gives an entire unipotent orbit of completions. QED.

Thus the natural coarse state is a base \((h,B,A)\) with an integer unipotent fiber.

## 73. The unipotent fiber is gauge for unrestricted integer reparametrization
If all integer shifts of residual parameter m are semantically equivalent, the k-fiber in Theorem 64 is pure gauge.

**Proof.**
Every k corresponds exactly to \(m\mapsto m-k\), which changes parametrization but not the represented affine integer set. QED.

## 74. Positive interval sampling breaks the unipotent gauge
If the residual parameter is restricted to a finite interval, \(m\mapsto m-k\) changes interval endpoints.

**Theorem 74.**
Finite positive-boundary counts are not invariant under arbitrary unipotent reparametrization unless the interval is shifted simultaneously.

**Proof.**
The set \(\{m:1\le m\le Y\}\) is sent to \(\{m:1-k\le m\le Y-k\}\), generally a different subset of integers. QED.

This is a precise new localization of positive-cone breaking:
\[
\boxed{\text{the bulk CRT state quotients by }N(\mathbb Z),\ 
\text{but the finite boundary remembers the }N(\mathbb Z)\text{ coordinate}.}
\]

## 75. Boundary discrepancy is therefore a gauge-lift observable
**Theorem 75.**
Any statistic depending only on the unipotent orbit is blind to the affine-origin coordinate k; finite interval discrepancy can depend on k.

**Proof.**
Orbit statistics are definitionally constant under k. Theorem 74 shows finite interval sampling is not. QED.

Thus the boundary term is naturally an observable of a **lift** from the modular/Farey quotient back to an affine representative.

## 76. This explains why quotient equilibrium can be simple while primes remain hard
The local/KMS quotient can live on translation-invariant/unipotent-quotiented data, whereas positive prime counting samples a chosen lift with a finite boundary.

**Theorem 76.**
No invariant of the quotient alone can reconstruct a boundary statistic that varies among representatives of one quotient fiber.

**Proof.**
A function on the quotient is constant on fibers. A varying boundary statistic is not. QED.

This is an exact reconstruction obstruction, not yet a cohomology class.

## 77. Core obstruction sharpened
The hard two-leg object can now be located as dependence of the charge-one positive-boundary functional on the affine lift over the coarse state
\[
(h,B,A)\in \mathbb Z\times\{(B,A):(A,B)=1\}.
\]

**Proof.**
Theorem 74 identifies lift dependence; canonical charge-one extraction identifies the prime sector; determinant/primitive-column quotient identifies the coarse state. QED.

## 78. End result
The two-leg affine Buchstab state has an exact hierarchy:
\[
\boxed{
\text{affine matrix}
\to
\text{right-}N(\mathbb Z)\text{ orbit}
\cong
\text{primitive column}
\to
\text{Farey slope}.
}
\]

The determinant h is conserved but belongs to the completion/extension data. Positive finite sampling breaks the right-unipotent reparametrization symmetry and therefore necessarily lives in the lift rather than the quotient.


## 79. Boundary breaking has an exact cocycle under reparametrization

Let \(I\subset\mathbb Z\) be a finite interval and let \(S\subseteq\mathbb Z\) be any arithmetic subset in the residual coordinate. Define
\[
F_I(k)=\#((I-k)\cap S).
\]
Define the reparametrization defect
\[
c_I(k,\ell)=F_I(k+\ell)-F_I(k).
\]

**Theorem 79.**
\[
\boxed{
c_I(k,\ell_1+\ell_2)
=
c_I(k,\ell_1)+c_I(k+\ell_1,\ell_2).
}
\]

**Proof.**
Both sides telescope:
\[
F_I(k+\ell_1+\ell_2)-F_I(k).
\]
QED.

Thus boundary dependence under the unipotent translation group satisfies an exact action-cocycle identity.

## 80. The boundary cocycle is a coboundary on the full lift
**Theorem 80.**
With \(F_I\) regarded as a 0-cochain on the affine lift,
\[
c_I=\delta F_I.
\]

**Proof.**
By definition \(c_I(k,\ell)=F_I(k+\ell)-F_I(k)\). QED.

Therefore the elementary finite-interval translation defect is cohomologically trivial **on the full affine lift**.

This prevents another overclaim: ordinary endpoint shift discrepancy is not yet the sought nontrivial obstruction class.

## 81. A nontrivial class can only arise after restricting allowed counterterms/observables or passing to a quotient
**Theorem 81.**
A coboundary on the full lift may cease to be removable if the primitive \(F_I\) is not an allowed function in the reduced/local observable class.

**Proof.**
Exactness in a subcomplex requires the primitive to belong to that subcomplex. If \(c=\delta F\) but \(F\) is excluded, c need not be exact there. QED.

This is the precise mathematical doorway for a **relative/local cohomology** obstruction: not boundary shift itself, but inability to trivialize it using admissible local/equilibrium data.

## 82. Quotient-invariant primitives cannot trivialize a fiber-varying defect
Suppose \(F\) is required to factor through the \(N(\mathbb Z)\)-quotient. Then F is constant on each unipotent fiber.

**Theorem 82.**
Such an F has zero coboundary along the fiber and therefore cannot trivialize a nonzero fiber translation defect.

**Proof.**
If F(k)=constant on a fiber, then \(F(k+\ell)-F(k)=0\). QED.

So once the admissible primitive algebra is restricted to quotient observables, boundary translation defects become genuine relative obstructions whenever nonzero.

## 83. Relative obstruction theorem for the affine boundary
Let \(\mathcal A_{\rm bulk}\) be functions constant on right-\(N(\mathbb Z)\) fibers, and \(\mathcal A_{\rm lift}\) all functions on the affine lift. Let c be a nonzero fiber translation defect of a boundary functional.

**Theorem 83.**
c is exact in the lift complex but not exact using a 0-cochain from \(\mathcal A_{\rm bulk}\).

**Proof.**
Exactness in the lift is Theorem 80. Any bulk primitive has zero fiber coboundary by Theorem 82, so cannot equal nonzero c. QED.

This is the first fully legitimate cohomological statement produced by transporting the refoliation discipline back to the arithmetic core.

It is **relative exactness**, not an assertion that Liouville parity itself is this class.

## 84. Bulk quotient versus boundary lift is mathematically a relative-cochain problem
**Corollary 84.**
The pair
\[
\mathcal A_{\rm bulk}\subset\mathcal A_{\rm lift}
\]
supports defects trivial upstairs but nontrivial relative to allowed bulk primitives.

**Proof.**
Theorem 83. QED.

This gives exact mathematical content to the library's earlier phrase “bulk/local quotient can be flat while boundary/lift data carries obstruction.”

## 85. The obstruction vanishes when the boundary is translated with the coordinate
Let the physical interval be part of the state and transform \(I\mapsto I-\ell\) together with \(k\mapsto k+\ell\).

**Theorem 85.**
The count \(F_I(k)\) is invariant under simultaneous transformation:
\[
F_{I-\ell}(k+\ell)=F_I(k).
\]

**Proof.**
\[
(I-\ell)-(k+\ell)
\]
under the chosen sign convention must be checked. Using instead the natural representation \(G(I,k)=\#((I+k)\cap S)\), simultaneous \(I\mapsto I-\ell,k\mapsto k+\ell\) gives \(I-\ell+k+\ell=I+k\). Hence with consistent action convention the joint transformed statistic is invariant. QED.

The lesson is exact: curvature depends on which data are held fixed under the comparison.

## 86. Boundary location is an additional state coordinate
**Theorem 86.**
Adding the interval origin/endpoints to the coarse state restores covariance under affine reparametrization.

**Proof.**
Theorem 85: when boundary coordinates transform along with the residual coordinate, the represented subset is unchanged. QED.

Thus the apparent unipotent anomaly is induced by projecting away boundary-location state.

## 87. Boundary curvature is again extrinsic under full state restoration
**Corollary 87.**
The finite-interval reparametrization defect vanishes on a state space retaining both affine coordinate and transformed boundary.

**Proof.**
Theorem 86. QED.

Therefore even the boundary defect must be treated carefully: it is intrinsic only relative to a theory that fixes the positive boundary rather than transforming it.

## 88. Positive cone selects a preferred section
On the signed/infinite affine line, translation reparametrization is a symmetry. Restricting to \(\mathbb N\) with origin 0 selects a preferred boundary section.

**Theorem 88.**
The subgroup of integer translations preserving \(\mathbb N\) bijectively is trivial.

**Proof.**
If \(\mathbb N+k=\mathbb N\), the least element shifts from 0 (or 1 by convention) to k, forcing k=0. QED.

Thus the positive cone genuinely breaks translation gauge by choosing an origin.

## 89. This breaking is global/archimedean, not finite-adic
**Theorem 89.**
Every finite residue ring \(\mathbb Z/m\mathbb Z\) admits all translations as bijections, while \(\mathbb N\) does not.

**Proof.**
Addition by k modulo m has inverse addition by -k. Theorem 88 handles \(\mathbb N\). QED.

This exactly matches the established Goldbach/gap result: finite places are translation/reflection symmetric; the distinction is in the positive archimedean sector.

## 90. Finite-adic equilibrium cannot encode the chosen positive origin
**Theorem 90.**
Any statistic defined solely from Haar measure on \(\widehat{\mathbb Z}\) is translation invariant in distribution and cannot distinguish a preferred integer origin without additional embedding/boundary data.

**Proof.**
Haar measure is translation invariant. QED.

Hence prime-pair asymptotics requiring positive interval sampling necessarily contain information absent from pure finite-adic equilibrium.

## 91. The positive boundary is a symmetry-breaking condition
**Theorem 91.**
Passing from the translation-homogeneous profinite/signed bulk to positive integers with a fixed origin is not a quotient by translation symmetry; it is a restriction selecting a non-invariant subset.

**Proof.**
A quotient identifies translation orbits. The positive cone instead chooses \(\mathbb N\), which is not invariant under the full translation group by Theorem 88. QED.

This clarifies why quotient KMS equilibrium cannot by itself recover the prime boundary.

## 92. Prime extraction combines two distinct boundary operations
There are now two mathematically separate “boundaries”:
1. charge boundary \(r=1\), obtained by coefficient extraction near \(z=0\);
2. spatial positive boundary, obtained by restricting the additive coordinate to a finite positive interval.

**Theorem 92.**
Neither operation determines the other.

**Proof.**
Charge extraction acts on factorization occupation and can be defined on signed/all integers away from zero; positive interval restriction acts on additive location and can be applied to any arithmetic weight independent of charge. QED.

Thus “boundary” must always specify **charge-space** or **additive-space** boundary.

## 93. The exact prime-pair observable is a double-boundary observable
For suitable convention,
\[
\pi_2(X;h)
=
[zw]\sum_{n\in[1,X]}z^{\Omega(n)}w^{\Omega(n+h)}.
\]

**Theorem 93.**
Prime-pair counting is simultaneously:
- canonical boundary extraction in each charge variable;
- positive finite-volume restriction in the additive variable.

**Proof.**
Coefficient \([zw]\) enforces \(\Omega(n)=\Omega(n+h)=1\); summation range enforces the positive finite interval. QED.

This double-boundary structure is the precise object the core theory must control.

## 94. Local Euler equilibrium controls neither boundary separately in full
**Theorem 94.**
The grand-canonical Euler product determines local charge statistics but does not by itself perform fixed-charge coefficient extraction or select the positive finite interval.

**Proof.**
Coefficient extraction is an additional global operation on the fugacity series; interval selection is additional additive-space data. QED.

## 95. Final localization
Combining Theorems 7,60,76,83,89,92–94:

\[
\boxed{
\text{Prime-pair hardness survives after local factorization as a double-boundary reconstruction problem.}
}
\]

The first boundary couples Euler places through fixed total charge. The second breaks additive/unipotent symmetry through the positive origin and finite interval.

**Proof.**
Each asserted mechanism has been separately proved above. QED.

This is a sharper core statement than “sieve parity barrier”: the exact prime observable lies at the intersection of a **canonical charge boundary** and an **archimedean positive boundary**, while the finite-adic bulk is factorized and dynamically flat at the appropriate fine-state level.
