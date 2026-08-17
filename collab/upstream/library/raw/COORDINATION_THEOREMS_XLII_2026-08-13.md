# COORDINATION THEOREMS XLII — ENTROPY–PRICE DUALITY, LOG-PARTITION, AND SOFTMAX
Date: 2026-08-13
Status: exact finite convex/information-theoretic lemmas; no novelty claims.

Let finite state set Ω and vector \(a=(a_\omega)\).

## 1326. Log-sum-exp
Define
\[
\operatorname{LSE}(a)=\log\sum_{\omega}e^{a_\omega}.
\]

Definition.

## 1327. Softmax distribution
Define
\[
p_\omega^*=\frac{e^{a_\omega}}{\sum_{\nu}e^{a_\nu}}.
\]
Then \(p^*\) is a probability distribution.

Proof. Positive entries and normalization by denominator. QED.

## 1328. Gibbs variational formula
For distributions p on Ω,
\[
\log\sum_\omega e^{a_\omega}
=
\max_p\left\{
\sum_\omega p_\omega a_\omega+H(p)
\right\},
\]
with natural-log entropy. Unique maximizer is softmax p*.

Proof. Let Z=\sum e^{a_\omega}, q_\omega=e^{a_\omega}/Z. Then
\[
D_{KL}(p\|q)
=
\sum p_\omega\log p_\omega
-\sum p_\omega a_\omega
+\log Z.
\]
Rearrange:
\[
\sum p_\omega a_\omega+H(p)
=
\log Z-D_{KL}(p\|q)
\le\log Z,
\]
with equality iff p=q. QED.

## 1329. Temperature-scaled variational formula
For τ>0,
\[
\tau\log\sum_\omega e^{a_\omega/\tau}
=
\max_p\left\{
E_p[a]+\tau H(p)
\right\}.
\]

Proof. Apply Theorem 1328 to \(a/\tau\) and multiply by τ. QED.

## 1330. Zero-temperature limit is max
\[
\lim_{\tau\downarrow0}
\tau\log\sum_\omega e^{a_\omega/\tau}
=
\max_\omega a_\omega.
\]

Proof. Let M=max a. Then
\[
e^{M/\tau}
\le\sum e^{a_\omega/\tau}
\le |\Omega|e^{M/\tau}.
\]
Take log×τ:
\[
M\le\tau\log\sum e^{a/\tau}\le M+\tau\log|\Omega|.
\]
Squeeze. QED.

## 1331. Softmax concentrates on maximizers as temperature vanishes
For
\[
p_\tau(\omega)\propto e^{a_\omega/\tau},
\]
probability mass outside argmax(a) tends to zero as τ→0.

Proof. If a_\omega≤M-\delta, its relative weight to a maximizer is ≤e^{-\delta/\tau}→0; finite union. QED.

## 1332. Infinite-temperature limit is uniform
As τ→∞,
\[
p_\tau(\omega)\to1/|\Omega|.
\]

Proof. \(e^{a_\omega/\tau}\to1\) for each finite a_\omega. QED.

Thus temperature trades optimization sharpness for entropy.

## 1333. Gradient of log-partition is softmax
\[
\frac{\partial}{\partial a_\omega}\operatorname{LSE}(a)
=
p_\omega^*.
\]

Proof. Differentiate log Z:
\[
\partial_\omega\log Z=e^{a_\omega}/Z.
\]
QED.

## 1334. Hessian is covariance matrix
For softmax p,
\[
\nabla^2\operatorname{LSE}(a)
=
\operatorname{diag}(p)-pp^\top.
\]

Proof. Differentiate \(p_i\):
\[
\partial_jp_i=p_i(\delta_{ij}-p_j).
\]
QED.

## 1335. Log-sum-exp is convex
\[
\nabla^2\operatorname{LSE}\succeq0.
\]

Proof. For vector v,
\[
v^\top(\operatorname{diag}p-pp^\top)v
=
E_p[v_\omega^2]-(E_p[v_\omega])^2
=
Var_p(v_\omega)\ge0.
\]
QED.

## 1336. Hessian null direction is global additive gauge
\[
\operatorname{LSE}(a+c\mathbf1)=c+\operatorname{LSE}(a),
\]
while softmax is invariant:
\[
p(a+c1)=p(a).
\]

Proof. Factor \(e^c\) out of numerator/denominator. QED.

Thus absolute energy/utility level is gauge; only differences affect probabilities.

## 1337. Softmax odds encode utility differences
\[
\log\frac{p_i}{p_j}=a_i-a_j.
\]

Proof. Ratio cancels partition function. QED.

## 1338. Probability ratios reconstruct scores up to additive constant
If all p_i>0 and p=softmax(a), then
\[
a_i=\log p_i+c
\]
for common c.

Proof. From definition \(p_i=e^{a_i}/Z\), so \(a_i=\log p_i+\log Z\). QED.

## 1339. Shannon entropy is convex-conjugate dual to log-sum-exp on simplex
Theorem 1328 equivalently states
\[
\operatorname{LSE}(a)
=
\sup_{p\in\Delta}\{\langle p,a\rangle-(-H(p))\}.
\]

Proof. Rewrite \(+H=-(-H)\). QED.

## 1340. KL-regularized optimization
Given prior q with q_\omega>0,
\[
\max_p\left\{
E_p[a]-\tau D_{KL}(p\|q)
\right\}
=
\tau\log\sum_\omega q_\omega e^{a_\omega/\tau}.
\]
Maximizer:
\[
p_\omega^*
=
\frac{q_\omega e^{a_\omega/\tau}}
{\sum_\nu q_\nu e^{a_\nu/\tau}}.
\]

Proof. Let tilted distribution r proportional to q e^{a/τ}. Expand \(D(p\|r)\) exactly as in Gibbs formula. QED.

## 1341. Bayesian update is exponential tilting when likelihood is exponentiated score
If likelihood \(L(\omega)\) satisfies \(a_\omega=\log L(\omega)\), then with τ=1,
\[
p^*(\omega)
\propto q(\omega)L(\omega),
\]
which is Bayes' rule.

Proof. Substitute into Theorem 1340. QED.

## 1342. Posterior is optimizer of expected log-likelihood minus KL movement from prior
Bayesian posterior q(ω)L(ω)/Z uniquely maximizes
\[
E_p[\log L(\omega)]-D_{KL}(p\|q).
\]

Proof. Theorem 1340 with a=log L, τ=1. QED.

Thus Bayesian inference is a variational tradeoff between fit and informational deviation from prior.

## 1343. Maximum entropy under mean constraint has exponential-family form
Let feature \(T:\Omega\to\mathbb R^d\). Maximize H(p) subject to
\[
E_p[T]=\mu,\qquad \sum p=1.
\]
At an interior optimum, there exists λ such that
\[
p_\lambda(\omega)
=
\frac{e^{\lambda^\top T(\omega)}}{Z(\lambda)}.
\]

Proof. Lagrangian
\[
-\sum p\log p+\lambda^\top(\sum pT-\mu)+\gamma(\sum p-1).
\]
Stationarity:
\[
-(\log p_\omega+1)+\lambda^\top T(\omega)+\gamma=0,
\]
so p is exponential; normalize. QED.

## 1344. Log-partition gradient gives moments
For
\[
Z(\lambda)=\sum_\omega e^{\lambda^\top T(\omega)},
\]
\[
\nabla_\lambda\log Z(\lambda)=E_{p_\lambda}[T].
\]

Proof. Differentiate under finite sum. QED.

## 1345. Log-partition Hessian is feature covariance
\[
\nabla^2_\lambda\log Z(\lambda)
=
\operatorname{Cov}_{p_\lambda}(T).
\]

Proof. Differentiate moment formula; standard covariance expansion. QED.

## 1346. Moment map is monotone in one dimension
For scalar T,
\[
\frac{d}{d\lambda}E_{p_\lambda}[T]
=
Var_{p_\lambda}(T)\ge0.
\]

Proof. Theorem 1345. QED.

## 1347. Strictly positive variance gives locally invertible moment-price map
If covariance matrix in Theorem 1345 is positive definite at λ, then by inverse function theorem the map
\[
\lambda\mapsto E_{p_\lambda}[T]
\]
is locally invertible.

Proof. Jacobian is positive-definite covariance and hence nonsingular. QED.

Thus dual price λ can parameterize constrained moments locally when features are nondegenerate.

## 1348. Redundant features create price gauge directions
If vector c satisfies
\[
c^\top T(\omega)=\text{constant}
\quad\forall\omega,
\]
then shifting λ→λ+tc changes all exponents by same constant and leaves p_\lambda unchanged.

Proof. Common factor cancels normalization. QED.

## 1349. Effective dual dimension is feature span modulo constants
Only directions of λ that change relative values \(\lambda^\top T(\omega)-\lambda^\top T(\nu)\) affect distribution.

Proof. Theorem 1348 characterizes null directions as feature combinations constant over Ω. QED.

## 1350. Entropy regularization makes argmax unique in the interior
If q has full support and τ>0, objective
\[
E_p[a]-\tau D(p\|q)
\]
is strictly concave in p on simplex, hence has unique maximizer.

Proof. Linear term plus negative KL; KL is strictly convex in p on full-support simplex, so negative is strictly concave. QED.

## 1351. Unregularized linear optimization can have an entire optimal face
Maximize E_p[a] over simplex. Any distribution supported on argmax(a) is optimal.

Proof. Expected value ≤max a, with equality iff all mass lies on maximizing states. QED.

## 1352. Entropy chooses a canonical interior representative among near-equivalent options
For equal maximal scores and uniform prior q, finite τ softmax assigns equal probability to tied alternatives.

Proof. Equal a yields equal exponent weights. QED.

## 1353. Relative entropy decomposes under conditioning
For joint p(x,y),q(x,y),
\[
D(p_{XY}\|q_{XY})
=
D(p_X\|q_X)
+
E_{p_X}D(p_{Y|X}\|q_{Y|X}).
\]

Proof. Expand log ratio
\[
\log\frac{p_Xp_{Y|X}}{q_Xq_{Y|X}}
=
\log\frac{p_X}{q_X}
+
\log\frac{p_{Y|X}}{q_{Y|X}}
\]
and average. QED.

## 1354. Marginalization reduces KL
\[
D(p_X\|q_X)\le D(p_{XY}\|q_{XY}).
\]

Proof. Conditional KL term in Theorem 1353 is nonnegative. QED.

This is KL data processing for forgetting Y.

## 1355. Exact KL loss under quotient is conditional divergence
The information lost by marginalizing Y is
\[
D(p_{XY}\|q_{XY})-D(p_X\|q_X)
=
E_{p_X}D(p_{Y|X}\|q_{Y|X}).
\]

Proof. Rearrangement of Theorem 1353. QED.

## 1356. Quotient preserves discrimination iff conditionals agree
Marginal X retains all KL discrimination between p,q iff
\[
p_{Y|X}=q_{Y|X}
\]
p_X-almost surely.

Proof. Equality in Theorem 1354 iff conditional KL term zero. QED.

## 1357. Minimal sufficient statistics preserve likelihood ratios
In finite dominated families, statistic T is sufficient iff likelihood ratio between any two parameters is a function of T.

Proof. Standard factorization/sufficiency characterization; posterior odds depend on likelihood ratios, and sufficiency means raw x provides no further parameter information after T. QED.

## 1358. Exponential-family sufficient statistic
For
\[
p_\theta(x)=h(x)\exp(\theta^\top T(x)-A(\theta)),
\]
T(x) is sufficient for θ.

Proof. Factorization theorem:
\[
p_\theta(x)=h(x)\,g_\theta(T(x)).
\]
QED.

## 1359. Additive sufficient statistics compose over independent samples
For iid exponential-family observations x_1,...,x_n,
\[
\prod_i p_\theta(x_i)
=
\left(\prod_ih(x_i)\right)
\exp\left(
\theta^\top\sum_iT(x_i)-nA(\theta)
\right).
\]
Thus
\[
T_{\rm total}=\sum_iT(x_i)
\]
is sufficient.

Proof. Multiply likelihoods and collect exponents. QED.

## 1360. Local statistics can aggregate without raw-data centralization
Under Theorem 1359, a coordinator needing only parameter likelihood can use sum of local sufficient statistics rather than all raw observations.

Proof. Likelihood factorization depends on data through \(\sum_iT(x_i)\) and θ-independent factor irrelevant for normalized inference over θ. QED.

## 1361. Secure aggregation can preserve exact exponential-family inference
If a secure protocol outputs exact \(T_{\rm total}\) and no other data, any inference procedure depending on sample only through that sufficient statistic has unchanged result.

Proof. Sufficiency/factorization. QED.

## 1362. Sum statistic is an abelian compositional interface
\[
T_{\rm total}(D_1\sqcup D_2)
=
T(D_1)+T(D_2).
\]

Proof. Sum over union splits. QED.

## 1363. Sufficient-statistic merge is associative and commutative
Dataset summaries merge by addition:
\[
(s_1+s_2)+s_3=s_1+(s_2+s_3),\quad s_1+s_2=s_2+s_1.
\]

Proof. Abelian group/monoid addition. QED.

## 1364. Exact inference can therefore be order-free
When all needed inference depends only on additive sufficient statistic, order of sample arrival does not affect final summary or result.

Proof. Commutativity/associativity of sum. QED.

## 1365. Raw provenance may remain useful despite sufficient inference summary
Two datasets can share same sufficient statistic but differ in raw samples.

Proof. Bernoulli sample: sufficient statistic number of successes; many binary sequences have same count. QED.

Thus inference semantics and provenance remain distinct.

## 1366. Log-partition is a global normalization generated from local scores
Given additive score
\[
a(x)=\sum_i a_i(x),
\]
partition function
\[
Z=\sum_x e^{\sum_i a_i(x)}
\]
is global even though score decomposes locally.

Proof. Definition; exponent turns sum into product of local factors but sum ranges over global configurations. QED.

## 1367. Factor graph partition function
If
\[
p(x)\propto\prod_\alpha\psi_\alpha(x_\alpha),
\]
then
\[
\log Z
=
\log\sum_x\exp\left(\sum_\alpha\log\psi_\alpha(x_\alpha)\right).
\]

Proof. Algebraic rewrite. QED.

## 1368. Variational free-energy form
Let \(a(x)=\sum_\alpha\log\psi_\alpha(x_\alpha)\). Then
\[
\log Z
=
\max_p\{E_p[a(X)]+H(p)\}.
\]

Proof. Gibbs variational theorem 1328 on global configuration space. QED.

## 1369. Global coupling can therefore arise entirely through entropy/normalization
Even when energy/score decomposes into local factors, optimizing over a normalized joint distribution includes global entropy and consistency of one joint p.

Proof. Variational objective uses one global distribution p whose marginals across overlapping factors must be mutually consistent. QED.

## 1370. Price, probability, and entropy share one convex duality
Softmax probabilities are gradients of log-partition; moment constraints are dualized by λ; entropy is the convex-conjugate partner in the Gibbs variational principle.

Proof. Theorems 1328,1333,1339,1343–1345. QED.

This is an exact mathematical intersection of statistical mechanics, Bayesian inference, information theory, and decentralized price duality.
