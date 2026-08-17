# COORDINATION THEOREMS XXI — CONDITIONAL EXPECTATION AS OPTIMAL OBSERVABLE COMPRESSION
Date: 2026-08-13
Status: exact Hilbert-space probability lemmas for square-integrable variables; no novelty claims.

Let \((\Omega,\mathcal F,P)\) be a probability space and \(\mathcal G\subseteq\mathcal F\) a sub-sigma-algebra.

## 566. Conditional expectation is an orthogonal projection
For \(X\in L^2\), \(Y=E[X|\mathcal G]\) is \(\mathcal G\)-measurable and satisfies
\[
E[(X-Y)Z]=0
\]
for every \(\mathcal G\)-measurable \(Z\in L^2\).

Proof. For bounded G-measurable simple Z this follows from the defining property of conditional expectation. Extend to L² G-measurable Z by density and Cauchy-Schwarz. QED.

## 567. Pythagorean decomposition
For any \(\mathcal G\)-measurable \(Z\in L^2\),
\[
E[(X-Z)^2]
=
E[(X-E[X|\mathcal G])^2]
+
E[(E[X|\mathcal G]-Z)^2].
\]

Proof. Write \(X-Z=(X-Y)+(Y-Z)\), expand square, and use orthogonality from Theorem 566 to kill cross term. QED.

## 568. Conditional expectation is the unique minimum-MSE estimator from visible information
Among all \(\mathcal G\)-measurable Z,
\[
E[X|\mathcal G]
\]
uniquely minimizes \(E[(X-Z)^2]\) up to almost-sure equality.

Proof. Theorem 567: second term is nonnegative and vanishes iff Z=Y a.s. QED.

## 569. Residual variance is irreducible under the visible sigma-algebra
The minimum achievable MSE from \(\mathcal G\) is
\[
E[(X-E[X|\mathcal G])^2]
=
E[\mathrm{Var}(X|\mathcal G)].
\]

Proof. Standard conditional variance identity:
\[
Var(X|\mathcal G)=E[(X-E[X|\mathcal G])^2|\mathcal G].
\]
Take expectations. QED.

## 570. Law of total variance
\[
Var(X)
=
Var(E[X|\mathcal G])
+
E[Var(X|\mathcal G)].
\]

Proof. Apply Pythagorean decomposition with Z=E[X] constant, or expand \(X-E[X]=(X-Y)+(Y-E[X])\) and use orthogonality. QED.

Visible information splits variance into explained and unresolved components.

## 571. Refining observations weakly reduces irreducible MSE
If \(\mathcal G\subseteq\mathcal H\subseteq\mathcal F\), then
\[
E[Var(X|\mathcal H)]
\le
E[Var(X|\mathcal G)].
\]

Proof. H-measurable estimators include all G-measurable estimators, so the minimum MSE over the larger class cannot increase. QED.

## 572. Exact gain from refinement in L²
For \(\mathcal G\subseteq\mathcal H\),
\[
E[Var(X|\mathcal G)]
-
E[Var(X|\mathcal H)]
=
E\left[
(E[X|\mathcal H]-E[X|\mathcal G])^2
\right].
\]

Proof. Apply Pythagorean theorem to the nested projections of X onto \(L^2(\mathcal H)\) and \(L^2(\mathcal G)\). QED.

## 573. No gain iff refined conditional mean is unchanged
Under Theorem 572, refinement H gives no MSE improvement iff
\[
E[X|\mathcal H]=E[X|\mathcal G]\quad a.s.
\]

Proof. Difference in errors is expected square of their difference. QED.

## 574. Conditional balance annihilates every visible predictor
If A∈L² satisfies
\[
E[A|\mathcal G]=0,
\]
then for every \(\mathcal G\)-measurable B∈L²,
\[
E[AB]=0.
\]

Proof. Orthogonality theorem with X=A,Y=0. QED.

This is the exact Hilbert-space form of a local parity barrier.

## 575. Any nonzero correlation certifies information outside the annihilating observable algebra
If E[A|G]=0 but E[AB]≠0, then B cannot be G-measurable.

Proof. Contrapositive of Theorem 574. QED.

## 576. Projection norm measures visible signal
For centered X,
\[
\|E[X|\mathcal G]\|_2^2
=
Var(X)-E[Var(X|\mathcal G)].
\]

Proof. Law of total variance and centeredness gives \(Var(E[X|G])=E[E[X|G]^2]\). QED.

## 577. Nested visible-signal norm is monotone
If G⊆H and X centered,
\[
\|E[X|\mathcal G]\|_2
\le
\|E[X|\mathcal H]\|_2.
\]

Proof. By Theorem 571/576, explained variance increases under refinement. QED.

## 578. Martingale of progressively refined observations
Let \(\mathcal G_0\subseteq\mathcal G_1\subseteq\cdots\) and define
\[
M_k=E[X|\mathcal G_k].
\]
Then
\[
E[M_{k+1}|\mathcal G_k]=M_k.
\]

Proof. Tower property:
\[
E[E[X|\mathcal G_{k+1}]|\mathcal G_k]=E[X|\mathcal G_k].
\]
QED.

## 579. Orthogonal martingale increments
For j<k,
\[
E[(M_{j+1}-M_j)(M_{k+1}-M_k)]=0.
\]

Proof. The earlier increment is \(\mathcal G_k\)-measurable. The later increment has conditional expectation zero given \(\mathcal G_k\):
\[
E[M_{k+1}-M_k|\mathcal G_k]=0.
\]
Take conditional expectation of product. QED.

## 580. Variance gained across scales adds
For finite K,
\[
\|M_K-M_0\|_2^2
=
\sum_{k=0}^{K-1}\|M_{k+1}-M_k\|_2^2.
\]

Proof. Sum orthogonal increments and apply Pythagoras. QED.

This gives an exact scale-by-scale decomposition of newly revealed L² information.

## 581. If every finite-scale projection vanishes, finite-scale predictors have zero correlation
If \(E[A|\mathcal G_k]=0\) for every finite k, then every B measurable with respect to some finite \(\mathcal G_k\) satisfies E[AB]=0.

Proof. Apply Theorem 574 at the k containing B. QED.

## 582. Nonzero limiting correlation must live beyond every finite observable scale
Under Theorem 581, if B is measurable only with respect to \(\mathcal G_\infty=\sigma(\cup_k\mathcal G_k)\) and E[AB]≠0, then B is not measurable with respect to any finite \(\mathcal G_k\).

Proof. Otherwise Theorem 581 would force zero correlation. QED.

## 583. Full increasing sigma-algebra recovers X in L² when it generates X's information
If \(\mathcal G_\infty=\sigma(\cup_k\mathcal G_k)\) and X is \(\mathcal G_\infty\)-measurable, then
\[
E[X|\mathcal G_k]\to X
\]
in L² under the standard L² martingale convergence theorem.

Proof. \(M_k\) is an L²-bounded martingale because \(\|M_k\|_2\le\|X\|_2\). Martingale convergence gives limit \(E[X|\mathcal G_\infty]=X\). QED.

## 584. Finite-scale invisibility can coexist with full-scale reconstructibility
There exist increasing sigma-algebras G_k and nonzero X such that X is not measurable at any finite scale but is measurable in G_∞.

Proof. Let independent fair bits B_i and encode
\[
X=\sum_{i\ge1}2^{-i}B_i.
\]
Let G_k=σ(B_1,...,B_k). X depends on infinitely many bits and is not G_k-measurable for finite k, but is measurable in σ(all B_i). QED.

## 585. Tail sigma-algebra can carry no information for independent coordinates
For independent random variables \(B_i\), Kolmogorov's 0–1 law states every event in the tail sigma-algebra
\[
\bigcap_n\sigma(B_n,B_{n+1},...)
\]
has probability 0 or 1.

Proof sketch. A tail event is independent of every finite initial sigma-algebra, hence independent of their generated full sigma-algebra and therefore independent of itself. Thus P(E)=P(E)^2. QED.

## 586. Persistent nontrivial tail signal certifies failure of independent-tail assumptions
If a tail-measurable event E has probability strictly between 0 and 1, the coordinate sequence cannot satisfy the independence hypotheses of Kolmogorov's 0–1 law.

Proof. Contrapositive of Theorem 585. QED.

## 587. Conditional expectation defines the canonical L² semantic quotient
Two variables X,X' are indistinguishable to all G-measurable linear tests iff
\[
E[X|\mathcal G]=E[X'|\mathcal G].
\]

Proof. If projections equal, their difference has zero projection and is orthogonal to every G-measurable test. Conversely, if \(E[(X-X')Z]=0\) for every G-measurable Z, choose \(Z=E[X-X'|G]\); its squared norm is zero, so projections equal. QED.

## 588. Observable equivalence kernel is an orthogonal complement
The subspace of L² signals invisible to G is
\[
L^2(\mathcal G)^\perp
=
\{X:E[X|\mathcal G]=0\}.
\]

Proof. Theorem 566 characterizes the kernel of the orthogonal projection onto \(L^2(G)\). QED.

## 589. Adding an observable algebra splits hidden signal orthogonally
For G⊆H,
\[
E[X|H]
=
E[X|G]
+
\left(E[X|H]-E[X|G]\right),
\]
and the two terms are orthogonal after centering the second relative to G.

Proof. The increment has zero conditional expectation given G and is orthogonal to all G-measurable variables. QED.

## 590. Reconstruction/obstruction in L² is projection plus kernel
Every X∈L² decomposes uniquely as
\[
X=
E[X|G]
+
\left(X-E[X|G]\right),
\]
where first term is visible and second lies in \(L^2(G)^\perp\).

Proof. Orthogonal projection theorem. QED.

This is an exact mathematical realization of “observable part + obstruction/invisible remainder.”
