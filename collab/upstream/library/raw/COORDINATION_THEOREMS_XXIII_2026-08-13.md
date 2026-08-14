# COORDINATION THEOREMS XXIII — EXACT LOCAL-TO-GLOBAL FACTORIZATION FOR FINITE PROBABILITY MODELS
Date: 2026-08-13
Status: exact finite probability lemmas; no novelty claims.

## 621. Chain rule factorizes any finite joint law
For finite random variables X_1,...,X_n,
\[
P(x_1,\dots,x_n)
=
P(x_1)\prod_{i=2}^nP(x_i|x_1,\dots,x_{i-1})
\]
whenever conditionals are defined on positive-probability prefixes.

Proof. Repeated identity \(P(A,B)=P(A)P(B|A)\). QED.

## 622. Independence is exact product factorization
Variables X_i are mutually independent iff
\[
P(x_1,\dots,x_n)=\prod_iP_i(x_i)
\]
for every tuple.

Proof. Definition of mutual independence in finite spaces. QED.

## 623. Log-likelihood interaction vanishes under independence
Where all probabilities are positive define
\[
J(x)=\log P(x_1,\dots,x_n)-\sum_i\log P_i(x_i).
\]
Then J≡0 iff the joint law factorizes.

Proof. Exponentiating J=0 gives product equality; converse immediate. QED.

## 624. Expected log-interaction is total correlation
\[
E[J(X)]
=
D_{KL}\left(P_X\middle\|\prod_iP_{X_i}\right)
=
TC(X_1,\dots,X_n).
\]

Proof. Expand expectation of log likelihood ratio. QED.

## 625. A latent variable yields mixture-of-products factorization under conditional independence
If X_i are conditionally independent given Z, then
\[
P(x_1,\dots,x_n)
=
\sum_zP(z)\prod_iP(x_i|z).
\]

Proof. Law of total probability followed by conditional independence. QED.

## 626. Marginal dependence can be entirely induced by latent mixing
There exist conditionally independent X_i|Z that are strongly dependent marginally.

Proof. Let X_i=Z for common fair bit Z. Given Z they are deterministic and factorize; marginally they are identical. QED.

## 627. Conditioning can create dependence
There exist independent X,Y that become dependent conditional on C.

Proof. Let X,Y independent fair bits and C=X⊕Y. Given C=0, X=Y; hence dependent. QED.

## 628. Conditioning can destroy dependence
There exist dependent X,Y rendered conditionally independent by Z.

Proof. Let X=Y=Z common bit. Given Z both are deterministic, so conditional joint equals product of degenerate marginals. QED.

Thus “conditioning adds information” does not imply monotone correlation behavior.

## 629. Markov blanket sufficiency in a finite factorized distribution
Suppose joint positive law factorizes over an undirected graph:
\[
P(x)\propto\prod_{C\in\mathcal C}\psi_C(x_C).
\]
For node i, conditional law \(P(x_i|x_{-i})\) depends on x_{-i} only through variables sharing a factor with i.

Proof. In the conditional ratio as a function of x_i, factors not containing i are constant and cancel in normalization. QED.

## 630. Local conditional interface can be much smaller than global state
Under Theorem 629, if node i has neighborhood N(i), then
\[
P(X_i|X_{-i})=P(X_i|X_{N(i)})
\]
for pairwise graphical models.

Proof. Specialize factors to vertices/edges; only factors involving i contain its neighbors. QED.

## 631. Conditional mutual information vanishes across a Markov separator
If distribution satisfies
\[
X_A\perp X_B\mid X_S,
\]
then
\[
I(X_A;X_B|X_S)=0.
\]

Proof. Conditional independence iff conditional mutual information zero. QED.

## 632. Separator is a sufficient coordination interface for probabilistic prediction
Under Theorem 631,
\[
P(X_B|X_A,X_S)=P(X_B|X_S).
\]

Proof. Definition of conditional independence. QED.

Thus once separator state is known, additional A-state carries no predictive information about B.

## 633. Deterministic separator analogue
Let outputs in B be deterministic function
\[
C_B=f(X_A,X_S,X_B).
\]
If there exists g with
\[
C_B=g(X_S,X_B),
\]
then communication of X_A is unnecessary for exact C_B once X_S,X_B are known.

Proof. Direct factorization. QED.

## 634. Minimal separator can be task-specific
A graph separator sufficient for reconstructing full X_B may be larger than a statistic sufficient for one target C_B.

Proof. Example: separator S contains two bits (s_1,s_2), but target depends only on s_1. Full downstream state may depend on both. QED.

## 635. Sufficient statistic criterion
Statistic T(X) is sufficient for parameter Θ in the Bayesian finite-variable sense iff
\[
\Theta\perp X\mid T(X).
\]

Proof. This is a standard characterization of Bayesian sufficiency. QED.

## 636. Sufficient statistic preserves all posterior information about Θ
Under Theorem 635,
\[
P(\Theta|X)=P(\Theta|T(X))
\]
almost surely.

Proof. Conditional independence and T being a function of X imply posterior depends on X only through T. QED.

## 637. Data-processing lower bound for sufficient statistics
If T is sufficient for Θ,
\[
I(\Theta;T(X))=I(\Theta;X).
\]

Proof. Since T=f(X), data processing gives \(I(\Theta;T)\le I(\Theta;X)\). Chain rule:
\[
I(\Theta;X)=I(\Theta;T)+I(\Theta;X|T),
\]
and sufficiency makes final term zero. QED.

## 638. Any further compression preserving sufficiency must preserve all parameter information
If S=g(T) is also sufficient, then
\[
I(\Theta;S)=I(\Theta;T)=I(\Theta;X).
\]

Proof. Apply Theorem 637 to each sufficient statistic. QED.

## 639. Minimal sufficient partition in finite models
Let observations x,x' be equivalent when likelihood vectors are proportional:
\[
P(x|\theta)=c(x,x')P(x'|\theta)
\]
for all θ with a positive constant independent of θ. The equivalence class statistic is sufficient, and every sufficient statistic must refine this partition under the usual positive-support finite model.

Proof. Factorization: within a class, likelihood differs by θ-independent factor, so posterior likelihood ratios across θ depend only on class. Conversely if a sufficient statistic identifies x,x', posterior odds for any θ,θ' must agree, forcing likelihood ratios \(P(x|\theta)/P(x|\theta')=P(x'|\theta)/P(x'|\theta')\), equivalent to proportional likelihood vectors. QED.

## 640. Statistical sufficiency is another canonical semantic quotient
Under Theorem 639, the minimal sufficient statistic is the quotient of raw observations by indistinguishability with respect to every parameter-inference task.

Proof. Equivalence identifies exactly observations producing the same likelihood-ratio information about Θ; by minimality every sufficient interface refines it. QED.

## 641. Blackwell garbling cannot improve every decision problem
Let experiment Y be obtained from X through a stochastic channel independent of state Θ conditional on X:
\[
\Theta\to X\to Y.
\]
Then for any fixed loss and decision rule based on Y, the same expected performance can be achieved by a randomized decision rule based on X by simulating Y then applying the rule.

Proof. Given X, sample Y from the garbling channel and run the Y-rule. This reproduces exactly the joint law of (Θ,decision), hence same risk. QED.

Thus X is at least as informative as its garbling Y for all decision problems.

## 642. Deterministic quotient is a special Blackwell garbling
If Y=q(X), then Y is obtained by a deterministic channel from X; therefore no decision problem can benefit from replacing X by Y when arbitrary decision rules are allowed.

Proof. Apply Theorem 641. QED.

## 643. Quotient can preserve a designated task while degrading others
There exist X,Y=q(X), tasks C,D such that C is exactly determined by Y but D is not.

Proof. Let X=(C,D) two independent bits and Y=C. QED.

Thus “sufficient interface” is always relative to a task family.

## 644. Exact task family determines the canonical quotient
For finite X and tasks \(\{f_\alpha\}\), quotient by equality of all task outputs is the minimal deterministic experiment sufficient for every task.

Proof. Canonical task quotient theorem. QED.

## 645. Adding tasks monotonically increases required semantic information
For nested task families F⊆G with canonical quotients Q_F,Q_G,
\[
H(Q_G)\ge H(Q_F)
\]
for any distribution on X.

Proof. Q_F is deterministic function of Q_G, so entropy cannot increase under mapping from Q_G to Q_F. QED.

## 646. Exact increase equals conditional semantic entropy
\[
H(Q_G)-H(Q_F)=H(Q_G|Q_F).
\]

Proof. Q_F is a function of Q_G, so \(H(Q_F|Q_G)=0\) and chain rule gives \(H(Q_G)=H(Q_F)+H(Q_G|Q_F)\). QED.

## 647. Task addition has zero semantic cost iff old semantics already determines the new tasks
For F⊆G,
\[
H(Q_G|Q_F)=0
\]
iff Q_G is almost surely a function of Q_F under the chosen distribution; on full support this means the new tasks are constant on old quotient fibers.

Proof. Zero conditional entropy iff deterministic dependence a.s.; full support upgrades to every fiber point. QED.

## 648. Global model can be reconstructed from local factors when factorization is known
If a positive finite distribution is specified by normalized factorization
\[
P(x)=\frac1Z\prod_\alpha\psi_\alpha(x_{S_\alpha})
\]
and every factor ψ_α plus Z is known, then P is exactly determined.

Proof. Formula evaluates P for every x. QED.

## 649. Unknown normalization is one global scalar in an unnormalized factor model
Given all positive factors ψ_α, the only missing quantity needed to obtain probabilities is
\[
Z=\sum_x\prod_\alpha\psi_\alpha(x_{S_\alpha}).
\]

Proof. Normalization requires probabilities sum to one; Z is uniquely determined by that sum. QED.

## 650. Partition function is a global quantity generated from local factors
Even when each ψ_α is local, Z sums products over complete global configurations.

Proof. Definition in Theorem 649. QED.

This is an exact example where local specification is compositional but a global aggregate remains.
