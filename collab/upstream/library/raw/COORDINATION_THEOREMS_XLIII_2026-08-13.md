# COORDINATION THEOREMS XLIII — ONLINE LEARNING, REGRET, AND DECENTRALIZED ADAPTATION
Date: 2026-08-13
Status: exact finite online-learning/game-theoretic lemmas under stated bounded-loss assumptions; no novelty claims.

Let there be N actions. At round t, action i incurs loss \(\ell_t(i)\in[0,1]\).

## 1371. External regret
For learner actions/distributions \(p_t\),
\[
R_T
=
\sum_{t=1}^T p_t\cdot\ell_t
-
\min_i\sum_{t=1}^T\ell_t(i).
\]

Definition.

## 1372. Multiplicative weights update
Initialize \(w_1(i)=1\). Set
\[
p_t(i)=\frac{w_t(i)}{W_t},
\qquad
w_{t+1}(i)=w_t(i)e^{-\eta\ell_t(i)}.
\]

Definition.

## 1373. Weight potential recursion
\[
W_{t+1}
=
W_t\sum_i p_t(i)e^{-\eta\ell_t(i)}.
\]

Proof. Substitute weight update and factor W_t. QED.

## 1374. Exponential loss upper bound
For \(x\in[0,1]\), \(\eta\ge0\),
\[
e^{-\eta x}
\le
1-\eta x+\frac{\eta^2}{2}x^2.
\]

Proof. Taylor series alternating/standard bound from convexity of remainder; for y=ηx≥0, \(e^{-y}\le1-y+y^2/2\). QED.

## 1375. Potential upper increment
\[
\log\frac{W_{t+1}}{W_t}
\le
-\eta\,p_t\cdot\ell_t+\frac{\eta^2}{2}p_t\cdot \ell_t^{\odot2}.
\]

Proof. Apply Theorem 1374 inside weighted average:
\[
\sum p_ie^{-\eta\ell_i}
\le
1-\eta E\ell+\frac{\eta^2}{2}E\ell^2.
\]
Use \(\log(1+u)\le u\). QED.

## 1376. Bounded-loss simplification
Since \(\ell_t(i)^2\le \ell_t(i)\le1\),
\[
\log\frac{W_{t+1}}{W_t}
\le
-\eta p_t\cdot\ell_t+\frac{\eta^2}{2}.
\]

Proof. \(p_t\cdot\ell_t^2\le1\). QED.

## 1377. Cumulative potential upper bound
\[
\log W_{T+1}
\le
\log N
-\eta\sum_{t=1}^T p_t\cdot\ell_t
+\frac{\eta^2T}{2}.
\]

Proof. Sum Theorem 1376 and use W_1=N. QED.

## 1378. Comparator lower bound
For every action i,
\[
W_{T+1}
\ge
w_{T+1}(i)
=
\exp\left(-\eta\sum_{t=1}^T\ell_t(i)\right).
\]

Proof. Total weight is at least one component. QED.

## 1379. Multiplicative-weights regret bound
For every i,
\[
\sum_t p_t\cdot\ell_t
-
\sum_t\ell_t(i)
\le
\frac{\log N}{\eta}
+\frac{\eta T}{2}.
\]

Proof. Lower-bound \(\log W_{T+1}\) by Theorem 1378 and upper-bound by Theorem 1377, then rearrange. QED.

## 1380. Optimized regret rate
Choosing
\[
\eta=\sqrt{\frac{2\log N}{T}}
\]
gives
\[
R_T\le \sqrt{2T\log N}.
\]

Proof. Substitute optimizer of \(a/\eta+b\eta\). QED.

## 1381. Average external regret vanishes
With optimized or suitable \(\eta_T\),
\[
\frac{R_T}{T}
\le
\sqrt{\frac{2\log N}{T}}
\to0.
\]

Proof. Divide Theorem 1380 by T. QED.

## 1382. No stochastic assumptions are required for the regret bound
Theorems 1379–1381 hold for any deterministic/adversarial loss sequence in [0,1].

Proof. The proof used only boundedness of realized losses, no probabilistic assumption on their generation. QED.

## 1383. Reward form
For rewards \(r_t(i)\in[0,1]\), applying multiplicative weights to losses \(1-r_t(i)\) yields regret in reward:
\[
\max_i\sum_t r_t(i)
-
\sum_t p_t\cdot r_t
=O(\sqrt{T\log N}).
\]

Proof. Loss-regret difference equals reward-regret because common T terms cancel. QED.

## 1384. Fixed action benchmark is weak
External regret compares only to best single fixed action in hindsight; a switching or context-dependent policy can outperform every fixed action.

Proof. Example losses alternate which of two actions is optimal; switching chooses zero loss each round while every fixed action loses half rounds. QED.

## 1385. Context expansion refines the benchmark
If benchmark class \(\mathcal H\subseteq\mathcal H'\), regret relative to \(\mathcal H'\) is weakly larger:
\[
L_{\rm learner}-\min_{h\in\mathcal H'}L_h
\ge
L_{\rm learner}-\min_{h\in\mathcal H}L_h.
\]

Proof. Minimum over larger class is no greater. QED.

This is another task-family refinement phenomenon.

## 1386. Empirical coarse correlated equilibrium from no-regret play
In a finite normal-form game, suppose each player i has external regret \(R_i(T)\). Let μ_T be empirical distribution over joint action profiles played. Then for every player i and fixed deviation action a_i',
\[
E_{a\sim\mu_T}[u_i(a_i',a_{-i})-u_i(a)]
\le
R_i(T)/T.
\]

Proof. External regret inequality is exactly
\[
\sum_t u_i(a_i',a_{-i,t})-\sum_tu_i(a_t)\le R_i(T).
\]
Divide by T and interpret empirical average. QED.

## 1387. Vanishing regret implies limiting empirical coarse correlated equilibrium
If \(R_i(T)/T\to0\) for every player, every limit point of μ_T satisfies coarse correlated equilibrium inequalities.

Proof. Take limits in Theorem 1386 over finite action space. QED.

## 1388. Local learning can generate globally constrained equilibrium statistics
Players need only update from their experienced/full-information losses, yet empirical joint play satisfies global no-deviation inequalities asymptotically.

Proof. Theorem 1387. QED.

## 1389. Coarse correlated equilibrium need not be Nash
There exist CCE distributions not concentrated on Nash equilibria.

Proof. In matching pennies, uniform distribution over all four action profiles is CCE because each player gets expected payoff0 and any fixed unilateral action against uniform opponent also gives0, while no pure profile is Nash. QED.

## 1390. Equilibrium concept depends on allowed deviation family
External regret yields coarse correlated equilibrium; stronger internal/swap regret yields correlated equilibrium.

Proof. CCE tests fixed unconditional deviations; CE tests deviations conditioned on recommended action, matching swap-regret deviation maps. QED.

## 1391. More deviation capabilities refine equilibrium
If deviation family D⊆D', every equilibrium satisfying all D'-deviation inequalities also satisfies all D inequalities.

Proof. It satisfies a superset of constraints. QED.

## 1392. Restricting capabilities coarsens equilibrium semantics
Removing feasible deviations can turn a previously unstable outcome into an equilibrium relative to the restricted game.

Proof. If all profitable deviations are removed, no remaining profitable deviation exists. QED.

## 1393. Verification can therefore change equilibrium by action-set restriction
A sound verifier removing invalid actions modifies the feasible deviation family and hence potentially enlarges the equilibrium set over remaining outcomes.

Proof. Theorem 1392 applied to verified feasible action subset. QED.

## 1394. Regret decomposition across independent product games
If losses split
\[
\ell_t(a,b)=\ell_t^A(a)+\ell_t^B(b)
\]
and learner independently chooses \(p_t^A,p_t^B\), then external regret against best fixed pair equals sum of component regrets.

Proof.
\[
\sum_tE[\ell^A+\ell^B]
-\min_{a,b}\sum_t(\ell_t^A(a)+\ell_t^B(b))
\]
and separability gives
\[
\min_{a,b}=\min_a+\min_b.
\]
Rearrange. QED.

## 1395. Cross-loss coupling breaks exact regret factorization
If loss contains nonseparable term c_t(a,b), best joint action need not be pair of componentwise best actions.

Proof. Example c rewards equality while component losses zero; separate components have no preference, joint optimum constrained by matching. QED.

## 1396. Hedge update is an exponential-family distribution
\[
p_t(i)
\propto
\exp\left(-\eta\sum_{s<t}\ell_s(i)\right).
\]

Proof. Unroll multiplicative updates from unit initial weights. QED.

## 1397. Hedge is entropy-regularized leader
Let cumulative loss \(L_{t-1}(i)\). Distribution
\[
p_t
=
\arg\min_{p\in\Delta}
\left[
p\cdot L_{t-1}+\frac1\eta\sum_ip_i\log p_i
\right].
\]

Proof. Gibbs variational/softmax formula with scores \(-\eta L\). QED.

Thus online learning and Gibbs/price duality are the same exponential-family optimization.

## 1398. Regularization makes mixed strategy unique
Entropy term is strictly convex on simplex interior, so FTRL objective has unique minimizer.

Proof. Linear plus strictly convex negative entropy. QED.

## 1399. Zero-temperature limit becomes follow-the-leader
As \(\eta\to\infty\), p_t concentrates on actions minimizing cumulative loss.

Proof. Softmax zero-temperature theorem with scores \(-L\). QED.

## 1400. High-temperature limit becomes uniform exploration
As \(\eta\to0\), p_t tends to uniform distribution.

Proof. Exponential weights \(e^{-\eta L_i}\to1\). QED.

## 1401. Learning rate is inverse temperature
Hedge distribution has Boltzmann form with energy cumulative loss and inverse temperature η.

Proof. Theorem 1396. QED.

## 1402. Independent agents' product Hedge distribution factorizes
If joint cumulative loss is additive across agents, Gibbs distribution over joint actions factorizes into product of individual Gibbs distributions.

Proof.
\[
e^{-\eta(L_A(a)+L_B(b))}
=
e^{-\eta L_A(a)}e^{-\eta L_B(b)},
\]
and partition function factorizes. QED.

## 1403. Interaction energy creates strategic correlation in Gibbs state
If joint score includes coupling \(J(a,b)\) not decomposable as sum, Gibbs distribution need not factorize.

Proof. Example binary actions with reward for equality; probability of equal pairs exceeds product prediction at finite inverse temperature. QED.

## 1404. Mean-field/product restriction is an approximation when coupling exists
Optimizing Gibbs variational objective over only product distributions can yield lower optimum than optimizing over all joint distributions.

Proof. Product distributions are a subset of all distributions. Maximum over subset ≤ maximum over full set; strict example with perfectly correlated optimal law not representable as product. QED.

## 1405. Correlation has variational value under interaction
Difference between unrestricted optimum and product-restricted optimum is nonnegative.

Proof. Set inclusion as Theorem 1404. QED.

## 1406. Correlation is unnecessary for additive reward plus entropy
If score decomposes \(a(x,y)=a_X(x)+a_Y(y)\), unrestricted Gibbs optimum factorizes and product restriction loses zero value.

Proof. Exponential factorization and partition function product. QED.

## 1407. Independent no-regret populations need not converge pointwise
No-regret guarantees empirical equilibrium properties, not convergence of instantaneous action profiles.

Proof. Matching pennies can cycle while empirical play approaches uniform equilibrium. QED.

## 1408. Persistent cycling can coexist with vanishing regret
There exist deterministic learning trajectories in zero-sum games whose empirical frequencies converge while actions continue oscillating.

Proof. Fictitious-play/multiplicative-weights-type trajectories in matching pennies provide examples; abstractly alternate best responses with balanced frequencies and sublinear regret under suitable schedules. QED.

## 1409. State semantics should distinguish trajectory from occupation measure
Two dynamics can have same empirical distribution over states but different temporal ordering/correlation.

Proof. Sequence 0101... and 0011 repeated both have asymptotic half zeros/ones but different transition statistics. QED.

## 1410. Equilibrium statistics can be a quotient of richer dynamical provenance
Mapping trajectory to empirical action distribution forgets order while retaining CCE-relevant average deviation payoffs.

Proof. CCE inequalities in Theorem 1386 depend only on empirical distribution, not temporal ordering. QED.
