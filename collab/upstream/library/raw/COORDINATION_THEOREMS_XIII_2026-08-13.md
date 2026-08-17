# COORDINATION THEOREMS XIII — QUOTIENT CONTRACTS, COMPOSITIONAL INFORMATION COST, AND LOCAL-GLOBAL OBSTRUCTIONS
Date: 2026-08-13
Status: exact lemmas/proofs under stated finite/discrete hypotheses; no novelty claims.

## 336. Canonical contract quotient
Let X be hidden implementation state and let \(\mathcal F=\{f_\alpha:X\to Y_\alpha\}\) be all externally admissible observations. Define
\[
x\sim x' \iff \forall\alpha,\ f_\alpha(x)=f_\alpha(x').
\]
Then the quotient q:X→Q=X/~ is the coarsest deterministic interface through which every admissible observation factors.

Proof. As in the canonical task-interface theorem: each fα is constant on equivalence classes, so factors through q. Any interface T supporting all fα identifies only pairs agreeing under all fα, hence T(x)=T(x') implies q(x)=q(x'), giving q=r∘T. QED.

## 337. Contract freedom is exactly quotient-fiber freedom
For public semantic state q(x)=s, all hidden implementations in
\[
q^{-1}(s)
\]
are indistinguishable by every admissible observation.

Proof. By definition, members of the same q-fiber agree under every fα. QED.

## 338. Enlarging the observation family refines the contract quotient
If \(\mathcal F\subseteq\mathcal G\), then
\[
x\sim_\mathcal G x' \implies x\sim_\mathcal F x'.
\]
Thus every \(\mathcal G\)-fiber lies inside an \(\mathcal F\)-fiber.

Proof. Agreement on all functions in G implies agreement on its subfamily F. QED.

Hence adding externally enforced semantics weakly reduces internal implementation freedom.

## 339. Removing observations coarsens semantics
If \(\mathcal F\subseteq\mathcal G\), there exists a canonical surjection
\[
r:Q_\mathcal G\to Q_\mathcal F
\]
with
\[
q_\mathcal F=r\circ q_\mathcal G.
\]

Proof. Theorem 338 makes r([x]_G)=[x]_F well-defined and surjective. QED.

## 340. Entropic implementation freedom
Let X be random and Q=q(X). Define residual implementation entropy
\[
F_q:=H(X\mid Q).
\]
For deterministic interfaces T supporting the same task family,
\[
H(X\mid T)\le H(X\mid Q).
\]

Proof. Q=r(T), so conditioning on T gives at least as much information as conditioning on Q:
\[
H(X\mid T)\le H(X\mid Q).
\]
QED.

Thus the canonical quotient maximizes hidden-state entropy among exact deterministic interfaces.

## 341. Exact decomposition of hidden-state entropy
For deterministic Q=q(X),
\[
H(X)=H(Q)+H(X\mid Q).
\]

Proof. H(Q|X)=0, so
\[
H(X,Q)=H(X)=H(Q)+H(X|Q).
\]
QED.

Public semantic entropy plus private implementation entropy exactly partitions total state entropy.

## 342. Semantic tightening trades implementation entropy for public information
Let Q_F,Q_G be canonical quotients with \(\mathcal F\subseteq\mathcal G\). Then
\[
H(X\mid Q_F)-H(X\mid Q_G)
=
I(X;Q_G\mid Q_F)
=
H(Q_G\mid Q_F).
\]

Proof. Since Q_F is a function of Q_G,
\[
I(X;Q_G|Q_F)=H(Q_G|Q_F)-H(Q_G|X,Q_F)=H(Q_G|Q_F).
\]
Also by the chain rule for conditional mutual information,
\[
I(X;Q_G|Q_F)=H(X|Q_F)-H(X|Q_F,Q_G)=H(X|Q_F)-H(X|Q_G).
\]
QED.

Every exact semantic refinement consumes exactly its conditional entropy in hidden implementation freedom.

## 343. Composition of deterministic semantic quotients
Let X→Q→R be deterministic quotient maps q and r. Then
\[
H(X\mid R)=H(X\mid Q)+H(Q\mid R)
\]
iff Q is a deterministic function of X and R a deterministic function of Q.

Proof.
\[
H(X,Q|R)=H(Q|R)+H(X|Q,R).
\]
Because Q is determined by X, \(H(X,Q|R)=H(X|R)\). Because R is determined by Q, \(H(X|Q,R)=H(X|Q)\). QED.

Thus information lost by successive quotienting adds exactly as conditional entropy.

## 344. Data-processing monotonicity of reconstructibility
For deterministic X→Q→R,
\[
H(X\mid R)\ge H(X\mid Q).
\]

Proof. Theorem 343 and \(H(Q|R)\ge0\). QED.

## 345. Exact extra information required to invert a quotient
Let Q=q(X). Suppose Z permits exact reconstruction:
\[
H(X\mid Q,Z)=0.
\]
Then
\[
I(X;Z\mid Q)=H(X\mid Q).
\]

Proof.
\[
I(X;Z|Q)=H(X|Q)-H(X|Q,Z)=H(X|Q).
\]
QED.

## 346. Any exact reconstruction supplement has entropy at least residual implementation entropy
Under Theorem 345,
\[
H(Z\mid Q)\ge H(X\mid Q).
\]

Proof. \(I(X;Z|Q)\le H(Z|Q)\). QED.

## 347. Independent quotient losses add
Let X=(X_1,X_2), with independent pairs \((X_1,Q_1)\perp(X_2,Q_2)\) and \(Q_i=q_i(X_i)\). Then
\[
H(X_1,X_2\mid Q_1,Q_2)
=
H(X_1\mid Q_1)+H(X_2\mid Q_2).
\]

Proof. Conditional independence induced by product factorization gives additive conditional entropy. QED.

## 348. Correlated quotient losses need not add
There exist X_1,X_2,Q_1,Q_2 such that
\[
H(X_1,X_2|Q_1,Q_2)
<
H(X_1|Q_1)+H(X_2|Q_2).
\]

Proof. Let X_1=X_2=C be the same fair bit and Q_1,Q_2 constants. Joint residual entropy is 1 bit; sum of marginal residual entropies is 2. QED.

Thus reconstruction resources can be redundant across components.

## 349. Synergistic reconstruction supplement
There exist X and supplements Z_1,Z_2 such that
\[
I(X;Z_1)=I(X;Z_2)=0
\]
but
\[
H(X|Z_1,Z_2)=0.
\]

Proof. Let X=Z_1⊕Z_2 with independent fair bits Z_1,Z_2. QED.

Thus reconstruction information can exist purely jointly.

## 350. Conditional total correlation identity
For random variables W_1,...,W_n and side information Y define
\[
TC(W_1,\dots,W_n|Y)
=
\sum_i H(W_i|Y)-H(W_1,\dots,W_n|Y).
\]
Then
\[
TC\ge0.
\]

Proof. Conditional entropy is subadditive:
\[
H(W_1,\dots,W_n|Y)\le\sum_iH(W_i|Y).
\]
QED.

## 351. Total correlation is KL divergence
For finite variables,
\[
TC(W_1,\dots,W_n|Y)
=
\mathbb E_Y D_{KL}\left(
P_{W_1,\dots,W_n|Y}
\middle\|
\prod_i P_{W_i|Y}
\right).
\]

Proof. Expand the conditional KL:
\[
\sum_w P(w|y)\log\frac{P(w|y)}{\prod_iP(w_i|y)}
=-H(W|y)+\sum_iH(W_i|y).
\]
Average over y. QED.

Thus total correlation exactly measures departure from conditional product structure.

## 352. Zero total correlation iff conditional independence
\[
TC(W_1,\dots,W_n|Y)=0
\]
iff
\[
P_{W_1,\dots,W_n|Y}=\prod_iP_{W_i|Y}
\]
almost surely in Y.

Proof. KL divergence is nonnegative and zero iff its arguments agree almost surely. QED.

## 353. Correlation is a compression resource
For lossless joint encoding conditioned on Y, the entropy saving relative to separately entropy-coding each W_i is exactly
\[
TC(W_1,\dots,W_n|Y).
\]

Proof. Ideal separate entropy cost is \(\sum_iH(W_i|Y)\); ideal joint entropy cost is \(H(W_1,\dots,W_n|Y)\). Difference is TC. QED.

## 354. Mutual information is the two-variable total correlation
For n=2,
\[
TC(W_1,W_2|Y)=I(W_1;W_2|Y).
\]

Proof. Substitute definitions. QED.

## 355. Global state can contain less information than sum of local descriptions because of shared structure
For any W_i,
\[
H(W_1,\dots,W_n|Y)
=
\sum_iH(W_i|Y)-TC(W_1,\dots,W_n|Y).
\]

Proof. Rearrangement of definition. QED.

## 356. Independent local certificates have additive ideal description entropy
If certificate variables Π_i are conditionally independent given public statement Y, then
\[
H(\Pi_1,\dots,\Pi_n|Y)=\sum_iH(\Pi_i|Y).
\]

Proof. Conditional independence makes total correlation zero; apply Theorem 355. QED.

## 357. Correlated certificates admit joint compression
If \(TC(\Pi_1,\dots,\Pi_n|Y)>0\), then
\[
H(\Pi_1,\dots,\Pi_n|Y)<\sum_iH(\Pi_i|Y).
\]

Proof. Theorem 355. QED.

This is information-theoretic compression, independent of whether an efficient compressor exists.

## 358. Common hidden cause creates certificate correlation
Let latent Z influence conditionally independent certificates:
\[
\Pi_i\perp\Pi_j\mid(Z,Y)
\]
but Z is not conditioned on publicly. Then Π_i may be dependent given Y.

Proof. Example: Z fair bit and Π_1=Π_2=Z. They are deterministic and hence conditionally independent given Z, but perfectly correlated marginally. QED.

## 359. Revealing a sufficient latent variable can decorrelate components
If
\[
P(\Pi_1,\dots,\Pi_n|Z,Y)=\prod_iP(\Pi_i|Z,Y),
\]
then
\[
TC(\Pi_1,\dots,\Pi_n|Z,Y)=0.
\]

Proof. Theorem 352. QED.

## 360. Correlation localization problem has an exact information target
Given Y and variables W_1,...,W_n, a variable Z fully explains their conditional dependence iff
\[
TC(W_1,\dots,W_n|Y,Z)=0.
\]

Proof. By Theorem 352, this is equivalent to conditional independence after adjoining Z. QED.

## 361. Minimal decorrelating supplement is an optimization over conditional total correlation
For any admissible class of supplements Z, the exact decorrelation problem is
\[
\min H(Z|Y)
\quad\text{s.t.}\quad
TC(W_1,\dots,W_n|Y,Z)=0.
\]

Proof. This is a definition of the minimum-information exact decorrelating supplement; feasibility condition is exact by Theorem 360. QED.

## 362. A global hidden variable can explain arbitrarily large apparent dependence
Let Z be one fair bit and W_i=Z for all i. Then
\[
TC(W_1,\dots,W_n)=(n-1)\text{ bits},
\]
while
\[
H(Z)=1\text{ bit}
\]
and
\[
TC(W_1,\dots,W_n|Z)=0.
\]

Proof. Each H(W_i)=1 and joint entropy H(W_1,...,W_n)=1, so TC=n-1. Given Z all W_i are deterministic, hence conditionally independent. QED.

Thus one bit of latent structure can account for linearly growing redundant correlation.

## 363. Pairwise independence does not imply joint independence
Let U,V be independent fair bits and W=U⊕V. Then each pair among U,V,W is independent, but
\[
H(W|U,V)=0,
\]
so the triple is not jointly independent.

Proof. Direct enumeration: every pair is uniform on four possibilities; W is determined by U,V. QED.

## 364. Pairwise mutual information can miss all global dependence
In Theorem 363,
\[
I(U;V)=I(U;W)=I(V;W)=0,
\]
yet
\[
TC(U,V,W)=1\text{ bit}.
\]

Proof. Pairwise independence gives zero pairwise MI. Individual entropies sum to 3 bits; joint entropy is H(U,V)=2 bits because W is determined, so TC=1. QED.

## 365. Any exact universal coordination statistic must permit higher-order dependence
A representation retaining only all one-variable marginals and pairwise mutual informations cannot reconstruct the joint law of arbitrary finite systems.

Proof. Compare (U,V,W) from Theorem 363 with three independent fair bits. Both have identical one-variable marginals and zero pairwise mutual informations, but joint laws differ because XOR parity is deterministic only in the first. QED.

## 366. Global parity is a one-bit obstruction invisible to every proper marginal
Let \(X_1,\dots,X_n\) be uniform over the even-parity subset
\[
\{x\in\{0,1\}^n:\oplus_i x_i=0\}.
\]
Then every proper subset of coordinates is uniformly distributed, while the full tuple obeys one deterministic parity constraint.

Proof. Fix values on any k<n coordinates. There are \(2^{n-k-1}\) completions of even total parity, independent of the fixed values, so the marginal is uniform. Full parity is zero by construction. QED.

## 367. Even-parity law has exactly one bit of total correlation
Under Theorem 366,
\[
H(X_i)=1,\quad
H(X_1,\dots,X_n)=n-1,
\]
hence
\[
TC=1.
\]

Proof. Each proper one-coordinate marginal is uniform. The even-parity set has \(2^{n-1}\) equiprobable states. QED.

## 368. One residual charge bit exactly reconstructs the full product law extension class in the parity example
Let independent fair bits Y_1,...,Y_{n-1} and charge C∈{0,1}. Define
\[
X_i=Y_i\ (i<n),\qquad
X_n=C\oplus Y_1\oplus\cdots\oplus Y_{n-1}.
\]
Conditioning C=0 gives even parity; C=1 gives odd parity; averaging uniform C gives the full independent product law.

Proof. The parity of X is exactly C. For uniform C, every x has unique (Y,C), each probability \(2^{-n}\), hence uniform product law. QED.

Thus a single charge coordinate indexes two globally distinct joint sectors with identical proper-coordinate marginals.

## 369. Charge-sector mixing destroys the obstruction
In Theorem 368, if C is uniform and unobserved, the X_i become jointly independent.

Proof. The induced law is uniform on all \(2^n\) bit strings, which factorizes. QED.

## 370. Fixing a global charge creates dependence without changing proper marginals
Conditioning the independent product construction of Theorem 368 on C=c introduces one bit of total correlation while leaving every proper coordinate marginal uniform.

Proof. Theorems 366–368. QED.

This is an exact finite model of global dependence produced solely by fixing a conserved/sector label.
