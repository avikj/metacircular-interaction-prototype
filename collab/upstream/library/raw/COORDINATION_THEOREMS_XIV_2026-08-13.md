# COORDINATION THEOREMS XIV — LINEAR CONSTRAINTS, CODES, SYNDROMES, AND OBSTRUCTION BITS
Date: 2026-08-13
Status: exact finite-field linear algebra/coding lemmas; no novelty claims.

Let \(\mathbb F_q\) be a finite field.

## 371. Linear observation fibers are affine cosets
Let
\[
A:\mathbb F_q^n\to\mathbb F_q^m
\]
be linear. For y in im(A), if \(x_0\) satisfies Ax_0=y, then
\[
A^{-1}(y)=x_0+\ker A.
\]

Proof. Ax=y iff A(x-x_0)=0 iff x-x_0∈ker A. QED.

## 372. Fiber size is determined by nullity
If rank(A)=r, every nonempty fiber has
\[
|A^{-1}(y)|=q^{n-r}.
\]

Proof. Rank-nullity gives dim ker A=n-r. Every fiber is a coset of ker A by Theorem 371 and hence has the same cardinality. QED.

## 373. Uniform hidden state has residual entropy equal to nullity
Let X be uniform on \(\mathbb F_q^n\) and Y=AX. If rank(A)=r, then
\[
H_q(X|Y)=n-r
\]
in base-q entropy units.

Proof. Every observed y in im(A) has a uniform fiber of size \(q^{n-r}\). Conditional entropy is log_q of that size. QED.

## 374. Minimal number of additional linear observations for exact reconstruction
Let A have rank r. To make X exactly reconstructible by adjoining linear observations BX, the stacked matrix
\[
\begin{pmatrix}A\\B\end{pmatrix}
\]
must have rank n. Therefore B must contribute at least n-r independent rows modulo row(A), and n-r suffice.

Proof. Exact reconstruction means stacked map is injective, equivalent to rank n. Rank can increase by at most number of independent added rows, so at least n-r are needed. Choose a basis extending row(A) to the full dual space to attain n. QED.

## 375. Linear reconstruction supplement equals a basis of the annihilated directions
The missing degrees of freedom are exactly \(\ker A\). An added linear map B restores injectivity iff
\[
\ker A\cap\ker B=\{0\}.
\]

Proof. Kernel of the stacked map is precisely \(\ker A\cap\ker B\). Injectivity iff this kernel is zero. QED.

## 376. A single missing bit is a codimension-one kernel
Over \(\mathbb F_2\), if rank(A)=n-1, every observation fiber has exactly two states and residual entropy one bit.

Proof. Nullity is one; Theorems 372–373. QED.

## 377. Any linear functional nonzero on the one-dimensional kernel reconstructs the missing bit
Let \(\ker A=\mathrm{span}\{v\}\) over \(\mathbb F_2\). Let \(\ell\) be linear with \(\ell(v)=1\). Then
\[
x\mapsto (Ax,\ell(x))
\]
is injective.

Proof. If Ax=Ax' and \(\ell(x)=\ell(x')\), then d=x-x'∈ker A, so d=0 or v. Equality of \(\ell\) gives \(\ell(d)=0\), excluding d=v because \(\ell(v)=1\). Thus d=0. QED.

## 378. Syndrome is the canonical linear obstruction to code membership
Let H be a parity-check matrix and
\[
C=\ker H.
\]
Define syndrome
\[
s(x)=Hx.
\]
Then
\[
x\in C\iff s(x)=0.
\]

Proof. Definition of kernel. QED.

## 379. Equal syndrome iff states differ by a codeword
\[
Hx=Hy
\iff
x-y\in C.
\]

Proof. H(x-y)=0 iff x-y∈ker H=C. QED.

Thus syndrome labels cosets of the valid-state subspace.

## 380. Syndrome space is the quotient by valid transformations
The map
\[
\mathbb F_q^n/C\to \mathrm{im}(H),\qquad
[x]\mapsto Hx
\]
is a well-defined vector-space isomorphism.

Proof. Well-defined by Theorem 379. It is linear and surjective by definition of im(H). Kernel consists of coset C only, hence injective. QED.

## 381. Number of independent obstruction symbols equals codimension
If C has dimension k in \(\mathbb F_q^n\), then syndrome space has dimension n-k.

Proof. Rank-nullity for H with ker H=C gives rank(H)=n-k. QED.

## 382. Local parity checks compose into a global syndrome
If H has rows \(h_1,\dots,h_m\), then
\[
s(x)=(h_1x,\dots,h_mx).
\]
Global validity is conjunction of local equations
\[
h_jx=0\quad\forall j.
\]

Proof. Hx=0 iff every coordinate of Hx is zero. QED.

## 383. Redundant checks do not add obstruction information
If one parity-check row h_m lies in the span of previous rows, then its syndrome coordinate is a deterministic linear function of previous syndrome coordinates.

Proof. If \(h_m=\sum_{j<m}a_jh_j\), then
\[
h_mx=\sum_{j<m}a_j(h_jx).
\]
QED.

## 384. Minimal linear obstruction interface has dimension rank(H)
Any linear interface T(x) from which syndrome Hx can be recovered must have rank at least rank(H).

Proof. If H=RT for linear R, then rank(H)≤rank(T). QED.

## 385. Full syndrome attains minimal linear obstruction dimension
Taking T=H has rank exactly rank(H), hence attains the lower bound.

Proof. Immediate. QED.

## 386. Linear secret sharing from a kernel quotient
Let X be uniform on \(\mathbb F_q^n\), public observation Y=AX, and secret/charge C=BX. If
\[
\mathrm{row}(B)\cap\mathrm{row}(A)=\{0\}
\]
and the stacked map has appropriate rank, C can contain information absent from Y.

More exactly,
\[
H_q(C|Y)=\mathrm{rank}\begin{pmatrix}A\\B\end{pmatrix}-\mathrm{rank}(A)
\]
when C=BX is considered jointly in its image.

Proof. For uniform X, entropy of a linear image MX equals rank(M) base-q units. Hence
\[
H(C|Y)=H(Y,C)-H(Y)
=\mathrm{rank}\binom AB-\mathrm{rank}(A).
\]
QED.

## 387. Conditional information of an added linear observation equals rank gain
For X uniform, Y=AX, Z=BX,
\[
I(X;Z|Y)=H(Z|Y)
=
\mathrm{rank}\binom AB-\mathrm{rank}(A).
\]

Proof. Z is deterministic from X, so \(I(X;Z|Y)=H(Z|Y)\). Apply Theorem 386. QED.

Thus every independent added linear equation contributes exactly one q-ary unit of reconstruction information.

## 388. Linear local-to-global obstruction is quotient dimension
For linear observation A, the number of q-ary hidden degrees of freedom is
\[
\dim(\mathbb F_q^n/\mathrm{row}(A)^\perp)
=\dim\ker A=n-\mathrm{rank}(A).
\]

Proof. \(\mathrm{row}(A)^\perp=\ker A\) under the standard pairing; its dimension is n-rank(A). The hidden variation inside each fiber is ker A. QED.

## 389. Dual observables separate hidden directions
A family of added linear functionals \(\ell_1,\dots,\ell_k\) reconstructs X from AX iff their restrictions span the dual of \(\ker A\).

Proof. The stacked map is injective iff no nonzero v∈ker A is annihilated by every \(\ell_j\). In finite-dimensional linear algebra, this is equivalent to the restricted functionals separating points, equivalently spanning \((\ker A)^*\). QED.

## 390. Minimal added-observable count equals hidden dimension
Under Theorem 389, at least dim ker A functionals are required, and exactly that many suffice.

Proof. A vector space of dimension d has dual dimension d; fewer than d functionals cannot span it. A dual basis suffices. QED.

## 391. Global parity constraint is a one-row parity-check code
Let
\[
H=(1,\dots,1)\in\mathbb F_2^{1\times n}.
\]
Then
\[
C=\ker H
\]
is the even-parity subspace of dimension n-1 and syndrome Hx is the global parity bit.

Proof. Hx is XOR of coordinates. Kernel is even parity. Rank(H)=1, so dimension n-1. QED.

## 392. Every proper coordinate projection of the even-parity code is surjective
Let C be the even-parity code in \(\mathbb F_2^n\). Project onto any k<n coordinates. The projection image is all \(\mathbb F_2^k\).

Proof. Given arbitrary values on k<n coordinates, choose all but one unobserved coordinate arbitrarily and choose the last unobserved bit to enforce even total parity. QED.

Thus no proper coordinate set detects the parity obstruction.

## 393. The obstruction appears only at full rank of the global check
Although every proper coordinate projection is unconstrained, the full state satisfies one independent equation Hx=0.

Proof. Theorem 392 plus definition of C. QED.

## 394. General linear code local invisibility criterion
Let C⊆\(\mathbb F_q^n\) be a linear code. Projection onto coordinate set S is surjective iff there is no nonzero dual codeword \(h\in C^\perp\) supported entirely inside S.

Proof. Projection onto S fails to be surjective iff its image is a proper subspace of \(\mathbb F_q^S\), iff there exists a nonzero linear functional on \(\mathbb F_q^S\) annihilating the image. Extend that functional by zero outside S to h. Then h·c=0 for all c∈C, so h∈C^\perp with support in S. Converse reverses the argument. QED.

## 395. Minimum dual-codeword weight is the smallest coordinate scale at which a linear obstruction can be detected
Let \(d^\perp\) be the minimum Hamming weight of a nonzero dual codeword. Then every projection onto fewer than \(d^\perp\) coordinates is surjective, while some projection onto \(d^\perp\) coordinates is constrained.

Proof. By Theorem 394, a projection is constrained exactly when a nonzero dual codeword is supported inside it. No such support exists below minimum weight; one exists on the support of a minimum-weight dual codeword. QED.

## 396. Hidden global constraint scale can be arbitrarily large
The even-parity code has dual code generated by the all-ones vector of weight n, so
\[
d^\perp=n.
\]
Hence every subset of fewer than n coordinates is unconstrained, but the full n-coordinate state has a global obstruction.

Proof. The dual of the even-parity code is span of all-ones vector. Apply Theorem 395. QED.

## 397. Constraint locality is dual-code sparsity
For a linear validity space C, the existence of a parity check involving at most k coordinates is equivalent to the dual code containing a nonzero vector of Hamming weight at most k.

Proof. A parity check is exactly a dual codeword; number of involved coordinates is its support weight. QED.

## 398. Sparse local checks can generate dense global consequences
A dual code may be generated by low-weight checks while containing higher-weight linear combinations.

Proof. Example over F2: checks \(x_1+x_2=0\) and \(x_2+x_3=0\) each have weight 2; their sum is \(x_1+x_3=0\), also a derived nonlocal relation relative to adjacency. Longer chains generate endpoint equalities across arbitrary distance. QED.

## 399. Verification of a linear global invariant decomposes over parity checks
If H has m rows, checking Hx=0 can be done by m independent row-dot-product checks followed by conjunction.

Proof. Theorem 382. QED.

## 400. Linear obstruction certificates are compressible to a syndrome
For arbitrary x, the vector Hx completely determines which coset of valid subspace C=ker H contains x; no further linear obstruction information exists modulo C.

Proof. Theorem 380 identifies quotient \(\mathbb F_q^n/C\) with im(H) via syndrome. QED.

The syndrome is therefore the exact linear quotient coordinate of invalidity.
