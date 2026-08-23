# COORDINATION THEOREMS XLIV — INFORMATION DESIGN, BLACKWELL ORDER, AND BAYES-PLAUSIBLE POSTERIORS
Date: 2026-08-13
Status: exact finite Bayesian decision/information lemmas; no novelty claims.

Let hidden state \(\Theta\) have prior \(\pi\) on finite set Ω. An experiment/channel sends signal S with kernel \(P(s|\theta)\).

## 1411. Posterior
After signal s with positive probability,
\[
\pi_s(\theta)
=
\frac{\pi(\theta)P(s|\theta)}
{\sum_{\theta'}\pi(\theta')P(s|\theta')}.
\]

Proof. Bayes rule. QED.

## 1412. Bayes plausibility
Expected posterior equals prior:
\[
E_S[\pi_S(\theta)]=\pi(\theta)
\quad\forall\theta.
\]

Proof.
\[
\sum_sP(s)\pi_s(\theta)
=
\sum_s\pi(\theta)P(s|\theta)
=
\pi(\theta).
\]
QED.

## 1413. Posterior is a martingale
For sequential signals \(S_1,\dots,S_t\), posterior process
\[
\pi_t(\theta)=P(\Theta=\theta|S_{\le t})
\]
satisfies
\[
E[\pi_{t+1}(\theta)|S_{\le t}]
=
\pi_t(\theta).
\]

Proof. Tower property of conditional expectation. QED.

## 1414. Information cannot shift average belief
Any signal can spread posterior beliefs but their prior-weighted mean remains π.

Proof. Theorem 1412. QED.

## 1415. Full revelation posterior distribution
If signal S=Θ, posterior is point mass \(\delta_\Theta\), and
\[
E[\delta_\Theta]=\pi.
\]

Proof. Direct. QED.

## 1416. Uninformative signal leaves posterior equal prior
If S independent of Θ, then
\[
\pi_s=\pi
\]
for every positive-probability s.

Proof. \(P(s|\theta)=P(s)\) cancels in Bayes rule. QED.

## 1417. Expected posterior entropy cannot exceed prior entropy
\[
E[H(\Theta|S=s)]
=
H(\Theta|S)
\le
H(\Theta).
\]

Proof. Conditioning reduces entropy. QED.

## 1418. Expected entropy reduction is mutual information
\[
H(\Theta)-E_sH(\pi_s)=I(\Theta;S).
\]

Proof. Definition of mutual information. QED.

## 1419. Blackwell garbling
Experiment T is a garbling of S if
\[
\Theta\to S\to T
\]
forms a Markov chain through a state-independent channel \(K(t|s)\).

Definition.

## 1420. Garbling weakly reduces mutual information
If T is a garbling of S,
\[
I(\Theta;T)\le I(\Theta;S).
\]

Proof. Data processing. QED.

## 1421. Garbling weakly raises posterior entropy on average
\[
H(\Theta|T)\ge H(\Theta|S).
\]

Proof. Subtract Theorem 1420 from common H(Θ). QED.

## 1422. More informative experiment weakly improves every Bayesian decision problem
Suppose T is a garbling of S. For any finite action set A and utility u(a,θ), maximum expected utility using S is at least maximum expected utility using T.

Proof. Any decision rule based on T can be implemented with S by simulating T via garbling K and then applying the T-rule. Thus S's feasible strategy set contains simulated T strategies. QED.

## 1423. Decision value of information
Define
\[
V(S)=E_s\max_a E[u(a,\Theta)|S=s].
\]
Then if T is a garbling of S,
\[
V(S)\ge V(T).
\]

Proof. Theorem 1422. QED.

## 1424. Information can have zero value for a particular decision
There exist informative S with \(I(\Theta;S)>0\) but \(V(S)=V(\emptyset)\).

Proof. Let one action a* strictly dominate every other action for every θ. No signal changes optimal action or utility. QED.

## 1425. Information value is task-dependent
The same signal S can have zero value for one utility function and positive value for another.

Proof. Use dominant-action utility for zero value; use prediction utility rewarding correct guess of Θ for positive value whenever S informative. QED.

## 1426. Perfect state revelation maximizes every unconstrained decision problem
Full-revelation signal Θ Blackwell-dominates every experiment S because S can be simulated from Θ using its channel.

Proof. Markov chain \(\Theta\to\Theta\to S\), where second channel is original experiment. Apply Theorem 1422. QED.

## 1427. No-information experiment is Blackwell-minimal
Every experiment S can be garbled to a constant signal.

Proof. Channel ignores S and emits fixed symbol. QED.

## 1428. Posterior-value function
For decision problem define
\[
g(p)=\max_a\sum_\theta p(\theta)u(a,\theta).
\]
Then
\[
V(S)=E_s g(\pi_s).
\]

Proof. Conditional expected utility at posterior p is linear in p for each action; optimal conditional value is g(p). QED.

## 1429. Posterior-value function is convex
g(p), as pointwise maximum of linear functions of p, is convex.

Proof. Maximum of affine/linear functions is convex. QED.

## 1430. Jensen gives nonnegative value of information
\[
E_sg(\pi_s)\ge g(E_s\pi_s)=g(\pi).
\]

Proof. Convexity Theorem 1429, Jensen, and Bayes plausibility Theorem 1412. QED.

Thus costless information cannot hurt an optimal Bayesian decision maker.

## 1431. Strict value arises when posterior dispersion crosses action regions
If g is affine on convex hull of all posterior beliefs \(\{\pi_s\}\), information has zero value. If Jensen inequality is strict for that posterior distribution, information has positive value.

Proof. Equality/strictness conditions for Jensen. QED.

## 1432. Bayes-plausible posterior distribution can be implemented by an experiment
Let finite posterior beliefs \(p_s\) and probabilities \(\lambda_s\) satisfy
\[
\sum_s\lambda_sp_s=\pi.
\]
For states with π(θ)>0 define
\[
P(s|\theta)=\frac{\lambda_sp_s(\theta)}{\pi(\theta)}.
\]
Then this is a valid experiment producing signal probability λ_s and posterior p_s.

Proof. Nonnegative. Row sum:
\[
\sum_sP(s|\theta)
=
\frac{\sum_s\lambda_sp_s(\theta)}{\pi(\theta)}=1.
\]
Signal probability:
\[
\sum_\theta\pi(\theta)P(s|\theta)
=\lambda_s.
\]
Bayes posterior:
\[
\frac{\pi(\theta)P(s|\theta)}{\lambda_s}=p_s(\theta).
\]
QED.

This is the finite splitting lemma.

## 1433. Bayes plausibility is the only constraint on finite posterior splittings
Under positive prior support, any finite distribution over posteriors whose mean is prior is implementable.

Proof. Theorem 1432. QED.

## 1434. Information design is distribution design over posterior simplex
Choosing an experiment is equivalent, at outcome-value level, to choosing a Bayes-plausible distribution over posterior beliefs.

Proof. Every experiment induces such distribution by Theorem 1412; every such finite distribution is implementable by Theorem 1433. QED.

## 1435. Public signal creates common posterior when prior/channel are common knowledge
If all agents share prior π, observe same public signal s, and know channel, they compute identical posterior π_s.

Proof. Bayes formula is identical for all. QED.

## 1436. Identical posterior does not imply identical action
If utilities differ, agents with same posterior may choose different optimal actions.

Proof. Earlier belief/value orthogonality theorem. QED.

## 1437. Private signals create heterogeneous posteriors
Different private signals can generate different posterior beliefs from same common prior.

Proof. Example binary state with noisy informative signals; observing 0 versus1 produces different Bayes posterior. QED.

## 1438. Posterior disagreement can itself reveal information when beliefs are communicated
If another agent's posterior is a deterministic function of their private signal, observing that posterior is a signal about Θ whenever it is statistically dependent on Θ.

Proof. Posterior report is a channel from private signal; if dependent on Θ, mutual information is positive. QED.

## 1439. Honest posterior reporting plus common prior can aggregate private evidence
If agents truthfully reveal sufficient statistics of conditionally independent private signals, a coordinator can compute joint posterior by multiplying likelihood ratios.

Proof. Conditional independence gives
\[
P(s_1,\dots,s_n|\theta)=\prod_iP(s_i|\theta).
\]
Bayes posterior is prior times product of local likelihoods, normalized. QED.

## 1440. Log-likelihood ratios add under conditional independence
For two states θ_1,θ_0,
\[
\log\frac{P(\theta_1|s_1,\dots,s_n)}{P(\theta_0|s_1,\dots,s_n)}
=
\log\frac{\pi(\theta_1)}{\pi(\theta_0)}
+
\sum_i
\log\frac{P(s_i|\theta_1)}{P(s_i|\theta_0)}.
\]

Proof. Bayes plus conditional-independence factorization; normalization cancels in odds ratio. QED.

## 1441. Log-likelihood contribution is an additive evidence interface
Each agent can contribute scalar/vector local log-likelihood ratios that sum to global log posterior odds.

Proof. Theorem 1440. QED.

## 1442. Secure aggregation can combine evidence without revealing individual evidence values
If a secure computation returns exact sum of local log-likelihood contributions, joint posterior odds can be computed exactly from the sum and prior.

Proof. Theorem 1440 depends on contributions only through their sum. QED.

## 1443. Correlated signals break naive additive evidence
If signals are not conditionally independent given Θ,
\[
P(s_1,\dots,s_n|\theta)\ne\prod_iP(s_i|\theta)
\]
and simply summing individual log-likelihood ratios can double-count or miscount evidence.

Proof. Additive formula derives from product factorization; when factorization fails, joint log-likelihood includes interaction term
\[
\log P(s_1,\dots,s_n|\theta)-\sum_i\log P(s_i|\theta).
\]
QED.

## 1444. Correlation correction is a higher-order evidence term
For arbitrary joint signals,
\[
\log P(s|\theta)
=
\sum_i\log P(s_i|\theta)
+
J_\theta(s),
\]
where
\[
J_\theta(s)=
\log\frac{P(s|\theta)}
{\prod_iP(s_i|\theta)}.
\]

Proof. Algebraic definition. QED.

## 1445. Conditional independence iff correlation correction vanishes
\[
J_\theta(s)=0
\]
for all positive-probability tuples iff signals factor conditionally.

Proof. Exponentiate equality. QED.

## 1446. Evidence interaction can itself be target-dependent
The correction difference
\[
J_{\theta_1}(s)-J_{\theta_0}(s)
\]
enters posterior log-odds beyond sum of local evidence.

Proof. Substitute Theorem 1444 into joint likelihood-ratio log. QED.

Thus multi-agent evidence aggregation can require irreducible higher-order terms.

## 1447. Public posterior is a sufficient semantic summary for future Bayesian decisions about Θ
Given common utility task family depending on hidden state only through posterior expected utilities, raw signal history can be replaced by posterior distribution without changing optimal Bayesian decisions.

Proof. Posterior determines expectation of every state-dependent utility; dynamic caveat aside, one-shot Bayesian decision depends on history only through posterior. QED.

## 1448. Posterior may be insufficient for provenance-sensitive tasks
Two signal histories can yield identical posterior but differ in source identity, legal provenance, or future signal dynamics.

Proof. Construct two channels/signals with same likelihood ratio at observed outcome but different metadata/future conditional laws. Posterior over current Θ equal, provenance/future tasks differ. QED.

## 1449. Belief-state quotient is dynamic only when posterior is Markov sufficient
In partially observed controlled processes, posterior over hidden state is a sufficient state for future control when model transition/observation kernels and reward depend on history only through hidden Markov state and action.

Proof. Standard belief-MDP construction: Bayesian filtering maps current posterior+action+new observation to next posterior; expected reward is posterior expectation. Thus history factors through belief. QED.

## 1450. Information state is itself a compositional state variable
Under Theorem 1449, raw observation history may grow without bound while belief state has fixed-dimensional simplex representation and supports recursive update.

Proof. Bayesian filter recursion. QED.

This is an exact model of a dynamically sufficient semantic interface replacing replicated history.
