# COORDINATION THEOREMS XII — BOUNTIES, ENTRY, PUBLIC GOODS, AND DECENTRALIZED SEARCH
Date: 2026-08-13
Status: exact elementary game/economic lemmas under stated models; no novelty claims.

## 301. Fixed bounty induces a threshold entry rule
A solver i has private deterministic cost c_i≥0 to produce a valid witness and receives bounty B≥0 if it is guaranteed to be paid upon success. If success is certain conditional on paying the cost and there are no strategic competitors, participation utility is B-c_i. The solver participates iff
\[
c_i\le B
\]
under weak preference for participation at equality.

Proof. Participation weakly dominates nonparticipation exactly when B-c_i≥0. QED.

## 302. Nonmonetary utility lowers the required monetary bounty
Let solver i gain intrinsic/reputational value s_i from solving, in addition to monetary bounty B, at cost c_i. Participation occurs iff
\[
B+s_i\ge c_i.
\]
Hence minimum monetary bounty inducing participation is
\[
B_i^{\min}=\max(0,c_i-s_i).
\]

Proof. Rearrange the participation inequality with B≥0. QED.

## 303. Heterogeneous intrinsic value can induce socially costly work at arbitrarily small bounty
For any cost c>0 and any ε>0, if a solver has intrinsic value s=c, then bounty B=ε yields strictly positive participation utility ε.

Proof. Utility is ε+c-c=ε>0. QED.

Thus monetary payment need not approximate total private motivation or resource cost.

## 304. Prize value and output value are mathematically independent in the basic entry model
Let social/output value V be arbitrary and solver participation depend only on B+s_i-c_i. Holding B,s_i,c_i fixed while varying V does not change the solver's entry decision.

Proof. V does not appear in private utility by assumption. QED.

Therefore observed prize size does not identify output value.

## 305. Multiple independent potential solvers increase discovery probability
Suppose solver i independently succeeds with probability p_i if participating. If all participate, probability at least one succeeds is
\[
1-\prod_i(1-p_i).
\]

Proof. Failure of all independent attempts has probability product of failure probabilities. Complement. QED.

## 306. Marginal discovery gain from an additional independent solver
Given current participant set S with failure probability
\[
F_S=\prod_{i\in S}(1-p_i),
\]
adding solver j raises success probability by
\[
F_S p_j.
\]

Proof.
\[
[1-F_S(1-p_j)]-[1-F_S]=F_Sp_j.
\]
QED.

## 307. Discovery probability has diminishing returns under independent fixed success probabilities
For set function
\[
v(S)=1-\prod_{i\in S}(1-p_i),
\]
the marginal contribution of j is weakly smaller for larger S.

Proof. If S⊆T, then \(F_T\le F_S\), so \(F_Tp_j\le F_Sp_j\). QED.

Thus this particular search-value model is submodular, unlike general informational production.

## 308. Diversity can dominate duplication under correlated failure
Let two strategies A,B each succeed with marginal probability p. If their success indicators have joint success probability q, then probability at least one succeeds is
\[
2p-q.
\]
For fixed p, this is larger when q is smaller.

Proof. Inclusion-exclusion:
\[
P(A\cup B)=P(A)+P(B)-P(A\cap B)=2p-q.
\]
QED.

Thus lower correlation among approaches raises portfolio discovery probability at fixed individual success rates.

## 309. Perfectly duplicated strategies provide no additional success probability
If B succeeds iff A succeeds, then
\[
P(A\cup B)=P(A)=p.
\]

Proof. Events A and B are identical. QED.

## 310. Mutually exclusive success modes add
If A∩B=∅, then
\[
P(A\cup B)=P(A)+P(B).
\]

Proof. Inclusion-exclusion with zero intersection. QED.

## 311. Winner-take-all prize with symmetric costly entry can dissipate rent
Consider n identical agents. Each may enter at cost c. If k≥1 agents enter, exactly one winner is chosen uniformly and receives prize B; nonwinners receive zero. If k agents enter, each entrant's expected payoff is
\[
B/k-c.
\]

Proof. Winning probability is 1/k. QED.

## 312. Pure-entry equilibrium condition with k entrants
In the game of Theorem 311, a profile with exactly k entrants is a pure Nash equilibrium iff
\[
B/k\ge c
\]
and, if k<n,
\[
B/(k+1)\le c.
\]

Proof. Existing entrant does not want to exit iff payoff B/k-c≥0. A nonentrant joining would create k+1 entrants and gain B/(k+1)-c, so nonentry is optimal iff this is ≤0. QED.

## 313. Prize competition can induce near-complete rent dissipation
If k entrants satisfy approximately
\[
k\approx B/c,
\]
total entry cost kc is approximately B.

Proof. Substitute. QED.

This is a property of the winner-take-all contest model, not a universal statement about research prizes.

## 314. First-valid-witness bounty does not reward reusable intermediate contributions
Suppose payment B is made only to the agent submitting terminal witness w*, while intermediate artifact a created by another agent receives zero contractual payment even if w* causally depends on a.

Proof. This follows directly from the payment rule, which is a function only of terminal submitter identity. QED.

## 315. Provenance-dependent payment cannot be implemented by terminal-winner identity alone
If two successful derivations have the same terminal winner but different intermediate contributors and desired payments differ, no payment function of terminal-winner identity alone can implement the desired rule.

Proof. Same input to such a payment function would have to produce the same payment vector, contradiction. QED.

## 316. Recursive bounty decomposition preserves an upper budget bound under conservation
Let parent task carry budget B. A solver allocates sub-bounties \(B_1,\dots,B_k\) satisfying
\[
\sum_jB_j\le B.
\]
If each sub-bounty is paid at most once and parent receives no additional external funds, total subtask payout is at most B.

Proof. Sum of paid amounts is bounded by the allocated sum. QED.

## 317. Nested budget conservation
If every task node allocates to children at most the budget it receives, then total payout to leaves of any finite task tree is at most the root budget.

Proof. Induct on tree depth. For a node, total leaf payout below child j is at most B_j by induction; summing gives at most \(\sum_jB_j\le B\). QED.

## 318. Budget conservation does not determine economically efficient decomposition
There exist two decompositions obeying the same budget constraint where one yields a solution and the other does not.

Proof. Let root budget B=1. Task requires subtask A costing 1 and irrelevant subtask D. Allocation (1 to A,0 to D) succeeds; allocation (0 to A,1 to D) fails. Both conserve budget. QED.

Thus accounting correctness and allocation intelligence are distinct.

## 319. Public-good underprovision in a voluntary-contribution threshold model
Two agents each value a public result at v>0. The result is produced if total contributions reach cost c, where
\[
v<c<2v.
\]
Each pays its own contribution. Then “both contribute c/2” gives each payoff \(v-c/2>0\), but “contribute zero” is also a Nash equilibrium if unilateral contributions are restricted to either 0 or c/2.

Proof. At (0,0), unilateral contribution c/2 does not reach threshold c, so contributor pays c/2 and gets no result, payoff \(-c/2<0\); hence no deviation. At (c/2,c/2), result is produced and each gets \(v-c/2>0\); deviating to zero destroys the result and yields 0, so contribution is preferred. QED.

Thus socially valuable collective production can coexist with a no-production equilibrium.

## 320. Assurance contract removes the losing-contribution downside
Modify Theorem 319 so contributions are refunded if the threshold is not reached. At (0,0), unilateral contribution c/2 yields refund and payoff 0, not negative.

Proof. By refund rule, failed provision costs the contributor zero net payment. QED.

This weakly changes the strategic risk of attempted coordination, though it does not by itself make contribution strictly dominant.

## 321. Dominant-strategy provision via external subsidy can be constructed in the binary threshold example
In Theorem 319, add subsidy s>0 paid to each contributor whenever they contribute, whether or not threshold is met, and refund failed contributions. If
\[
s>0
\]
and at successful provision
\[
v-c/2+s>v
\]
relative to free-riding when the other contributes, i.e.
\[
s>c/2,
\]
then contribution is strictly dominant.

Proof. If other does not contribute, own contribution fails, is refunded, and earns s>0 versus 0. If other contributes, contributing yields \(v-c/2+s\), while free-riding yields 0 because threshold c is missed when only c/2 is contributed in this restricted action model. In fact here s>0 suffices in the second comparison too since free-riding destroys provision; the stated stronger condition certainly suffices. QED.

## 322. Verification eliminates false-claim payment in a bounty mechanism
Suppose bounty B is paid iff verifier V accepts submitted witness w, and V is sound for relation R. Then no R-invalid witness can receive payment.

Proof. Soundness says V acceptance implies R. Payment requires acceptance. QED.

## 323. Completeness ensures every valid witness is payable
If V is complete for R and payment is triggered by acceptance, then every R-valid witness with a completeness witness can trigger payment.

Proof. Completeness gives accepting proof/certificate; payment rule then applies. QED.

## 324. Sound-complete verification turns bounty eligibility into exact relation membership
Under Theorems 322–323,
\[
\text{payable}(x,y)
\iff
R(x,y)
\]
assuming valid claimants can supply the required verification witness.

Proof. Soundness gives payable⇒R; completeness gives R⇒payable. QED.

## 325. Solver identity is unnecessary for correctness when payment is bearer-style
If payment depends only on presentation of a valid unspent claim/capability plus a valid witness for R, then correctness of the output relation does not require persistent real-world identity of the solver.

Proof. Relation validity is established by the witness; payment authorization is established by the capability. Neither predicate logically requires a civil identity field. QED.

This does not imply identity is unnecessary for legal, reputational, or sybil-sensitive mechanisms.

## 326. Sybil invariance criterion for fixed terminal bounty
If exactly one fixed bounty B is paid per unique solved task regardless of number of submitting identities, creating additional identities cannot increase total payout for that task beyond B.

Proof. Payment cap is one B per task. QED.

## 327. Per-identity subsidy is sybil-vulnerable absent identity cost or uniqueness constraint
If each registered identity receives subsidy s>0 with no cost or uniqueness restriction, an actor controlling k identities receives ks, unbounded as k grows.

Proof. Additivity of per-identity subsidy. QED.

## 328. Contribution-based rewards require contribution uniqueness rather than person uniqueness
Suppose reward is attached to a content-addressed artifact ID and each artifact ID is paid at most once. Submitting the same artifact under multiple identities cannot multiply its reward.

Proof. All byte-identical canonical artifacts share the same content ID; the one-payment-per-ID rule triggers once. QED.

Distinct but semantically equivalent artifacts remain a separate deduplication problem.

## 329. Canonical semantic IDs remove duplicate rewards for equivalent artifacts
If canonicalization c satisfies \(a\sim b\iff c(a)=c(b)\) and reward is paid once per semantic ID \(H(c(a))\), then equivalent artifacts cannot receive duplicate rewards absent hash collision.

Proof. Equivalent artifacts have identical canonical semantic ID. One-payment-per-ID rule applies. QED.

## 330. Semantic deduplication can conflict with provenance attribution
If two independently discovered artifacts are semantically equivalent but produced by different derivations, semantic-ID deduplication identifies them while provenance-sensitive attribution distinguishes them.

Proof. Semantic equality gives same semantic ID; distinct derivations give different provenance objects. QED.

Therefore payment policy must specify whether value attaches to semantic novelty, independent discovery, provenance contribution, or some combination.

## 331. A terminal bounty induces no payment obligation for failed search under pure success contingency
If contract pays B iff valid terminal witness is submitted and zero otherwise, failed attempts receive zero contractual payment.

Proof. Directly from the contingent payment rule. QED.

## 332. Success-contingent bounty transfers search risk to solvers
Let solver incur random search cost C_i before learning success indicator S_i. Payment is B S_i. Expected solver payoff is
\[
B\,P(S_i=1)-E[C_i]
\]
when cost is incurred regardless of success.

Proof. Linearity of expectation. QED.

## 333. Risk-neutral entry threshold under stochastic success
A risk-neutral solver enters iff
\[
B p_i+s_i\ge E[C_i],
\]
where p_i is success probability and s_i any expected nonmonetary utility.

Proof. Expected payoff from entry is \(Bp_i+s_i-E[C_i]\); compare with zero. QED.

## 334. Required bounty falls with intrinsic value and rises as success probability falls
For p_i>0, minimum bounty under Theorem 333 is
\[
B_i^{\min}=\max\left(0,\frac{E[C_i]-s_i}{p_i}\right).
\]

Proof. Solve the entry inequality for B≥0. QED.

## 335. Heterogeneous private search technologies make centralized cost prediction unnecessary for entry selection
Given posted B, each solver i privately compares its own \(p_i,s_i,E[C_i]\) via Theorem 333. The mechanism need not know these quantities to induce the corresponding participation set.

Proof. The decision rule is evaluated by each solver from private parameters; B is public. QED.

This is decentralization of the production-method choice, not a claim of welfare optimality.
