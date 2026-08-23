# COORDINATION THEOREMS XV — MARKET CLEARING AS DUAL GLUING AND DECENTRALIZED OPTIMIZATION
Date: 2026-08-13
Status: exact convex-analysis lemmas under stated hypotheses; no novelty claims.

## 401. Lagrangian dual separates local objectives
Consider
\[
\max_{x_i\in X_i}\sum_{i=1}^n u_i(x_i)
\quad\text{s.t.}\quad
\sum_i A_ix_i=b.
\]
For multiplier \(\lambda\),
\[
L(x,\lambda)
=
\sum_i u_i(x_i)-\lambda^\top\left(\sum_iA_ix_i-b\right)
=
\lambda^\top b+\sum_i[u_i(x_i)-\lambda^\top A_ix_i].
\]

Proof. Expand and regroup. QED.

## 402. Dual function is sum of local response functions
Define
\[
g(\lambda)=\sup_{x_i\in X_i}L(x,\lambda).
\]
Then
\[
g(\lambda)
=
\lambda^\top b+\sum_i
\sup_{x_i\in X_i}[u_i(x_i)-\lambda^\top A_ix_i].
\]

Proof. The feasible product domain is \(\prod_iX_i\), and the Lagrangian is a sum of functions of separate x_i, so the supremum separates. QED.

## 403. One shared multiplier vector coordinates all local optimizers at a saddle point
If \((x^*,\lambda^*)\) is a Lagrangian saddle point, then every x_i^* independently solves
\[
x_i^*\in\arg\max_{x_i\in X_i}
[u_i(x_i)-(\lambda^*)^\top A_ix_i],
\]
while the global coupling satisfies
\[
\sum_iA_ix_i^*=b.
\]

Proof. Saddle optimality in x for fixed λ* plus separability gives local maximization. Primal feasibility gives coupling equality. QED.

## 404. Market-clearing residual is the dual gradient under differentiability
Suppose each local maximizer x_i(λ) is unique and the dual function is differentiable. Then
\[
\nabla g(\lambda)=
b-\sum_iA_ix_i(\lambda)
\]
for the sign convention of Theorem 401.

Proof. Envelope theorem: derivative of \(\lambda^\top b-\sum_i\lambda^\top A_ix_i\) at optimizing x_i(λ) is \(b-\sum_iA_ix_i(\lambda)\). QED.

Thus excess demand/resource mismatch is exactly the dual gradient.

## 405. Dual stationary point clears the coupling constraint
If \(\nabla g(\lambda^*)=0\), then
\[
\sum_iA_ix_i(\lambda^*)=b.
\]

Proof. Theorem 404. QED.

## 406. Price adjustment is gradient descent on dual mismatch
Under differentiability, iteration
\[
\lambda_{t+1}
=
\lambda_t-\eta\nabla g(\lambda_t)
=
\lambda_t+\eta\left(\sum_iA_ix_i(\lambda_t)-b\right)
\]
raises prices in directions of excess aggregate usage and lowers them in directions of slack.

Proof. Algebraic substitution from Theorem 404. QED.

## 407. Local agents need not reveal utility functions to compute dual residual
To form
\[
r(\lambda)=\sum_iA_ix_i(\lambda)-b,
\]
the coordinator needs each aggregate contribution \(A_ix_i(\lambda)\), not the full function u_i.

Proof. r is defined solely from those contributions and b. QED.

This is an exact information-interface statement, not a privacy guarantee about what responses may indirectly reveal.

## 408. Aggregation can hide individual responses while preserving the dual update
If a protocol reveals only
\[
S(\lambda)=\sum_iA_ix_i(\lambda)
\]
and not individual terms, then the dual update in Theorem 406 can be computed exactly from S and b.

Proof. Substitute S into the update. QED.

## 409. Secure aggregation is semantically sufficient for dual coordination
Any cryptographic protocol that correctly outputs S(λ) to the price updater while hiding individual contributions preserves the exact dual iteration.

Proof. The mathematical update depends only on S. Correct secure computation of S therefore supplies the same input to the updater. QED.

## 410. Exact decomposition of global objective gap under a supporting price
Let λ* be a saddle multiplier and x* primal optimal. For any product choice x,
\[
\sum_i u_i(x_i^*)-\sum_i u_i(x_i)
=
\sum_i\left(
[u_i(x_i^*)-\lambda^{*\top}A_ix_i^*]
-
[u_i(x_i)-\lambda^{*\top}A_ix_i]
\right)
+
\lambda^{*\top}\left(
\sum_iA_ix_i^*-\sum_iA_ix_i
\right).
\]

Proof. Add and subtract \(\lambda^{*\top}\sum_iA_ix_i^*\) and \(\lambda^{*\top}\sum_iA_ix_i\). QED.

If x is also globally feasible with the same equality b, the final coupling term vanishes, and the global objective gap is the sum of local price-adjusted gaps.

## 411. Feasible local optimality at common price implies global optimality
If x is globally feasible and each x_i maximizes
\[
u_i(x_i)-\lambda^\top A_ix_i
\]
for a common λ, then x globally maximizes \(\sum_i u_i(x_i)\) over all globally feasible y.

Proof. For every feasible y,
\[
u_i(x_i)-\lambda^\top A_ix_i
\ge
u_i(y_i)-\lambda^\top A_iy_i.
\]
Sum:
\[
\sum_i u_i(x_i)-\lambda^\top b
\ge
\sum_i u_i(y_i)-\lambda^\top b.
\]
Cancel the common term. QED.

## 412. Common dual signal plus feasibility is a global optimality certificate
Under Theorem 411, the pair consisting of:
1. a common λ certifying each local price-adjusted optimum;
2. a proof of global feasibility;
is sufficient to certify global optimality.

Proof. Theorem 411 is exactly the implication. QED.

## 413. Approximate local optimality yields additive global suboptimality
Suppose x is globally feasible and for common λ each agent satisfies
\[
u_i(x_i)-\lambda^\top A_ix_i
\ge
\sup_{z_i\in X_i}[u_i(z_i)-\lambda^\top A_iz_i]-\epsilon_i.
\]
Then for every globally feasible y,
\[
\sum_i u_i(x_i)
\ge
\sum_i u_i(y_i)-\sum_i\epsilon_i.
\]

Proof. Apply the local inequality to y_i, sum, and cancel \(\lambda^\top b\) using feasibility of x and y. QED.

## 414. Local certificate errors add in separable optimality verification
If each local optimization certificate proves ε_i-optimality and feasibility is exact, the global certificate proves \(\sum_iε_i\)-optimality.

Proof. Theorem 413. QED.

## 415. Coupling violations appear as a priced global error term
Without exact feasibility, Theorem 410 gives for any feasible comparator y:
\[
\sum_i u_i(y_i)-\sum_i u_i(x_i)
\le
\sum_i\epsilon_i
+
\lambda^\top\left(
\sum_iA_ix_i-b
\right)
\]
under the corresponding local ε-optimality inequalities and sign orientation.

Proof. Sum local inequalities comparing x_i to y_i and use \(\sum_iA_iy_i=b\). Rearrange. QED.

Thus local optimization error and global coordination error separate algebraically.

## 416. Multiple independent markets tensorize
Suppose optimization problem decomposes into two disjoint systems with variables x and z, objectives U(x)+V(z), and independent constraints A x=b and B z=c. Then any pair of optimal solutions is jointly optimal, and dual variables concatenate.

Proof. Feasible set is product and objective sum; apply product optimization theorem. Lagrangian is sum with multipliers (λ,μ). QED.

## 417. Cross-market coupling destroys exact tensorization
If an additional constraint
\[
D x+E z=d
\]
is imposed, separate optima need not be jointly feasible.

Proof. Example: each market independently chooses scalar 1 as optimum, while added constraint x+z=1 is violated by (1,1). QED.

## 418. Every independent coupling constraint adds a potential dual coordination direction
At a regular point, adding a linearly independent equality constraint adds one independent component to the multiplier space.

Proof. Multipliers live in the dual of the constraint codomain. Increasing rank by one increases its dimension by one. QED.

## 419. Constraint rank is invariant under invertible reparameterization
Replace coupling equations
\[
Ax=b
\]
by
\[
MAx=Mb
\]
for invertible M. Then rank and feasible set are unchanged, while multipliers transform by
\[
\lambda=M^\top\mu.
\]

Proof. Invertibility gives equivalent equations and preserves rank. Equality of Lagrangian terms
\[
\mu^\top M(Ax-b)=(M^\top\mu)^\top(Ax-b).
\]
QED.

Thus coordination dimension is representation-invariant under invertible changes of constraint basis.

## 420. Redundant constraints create nonunique prices but no new feasible information
If one constraint row is a linear combination of others, adding it does not change the feasible set. The associated multiplier representation can become nonunique.

Proof. The equation is implied by existing equations, so feasibility is unchanged. In the Lagrangian, multiplier components along dependencies can be redistributed while producing the same aggregate dual vector \(A^\top\lambda\). QED.

## 421. The economically relevant price signal is the induced dual action, not a redundant coordinate representation
Two multiplier vectors λ,λ' satisfying
\[
A^\top\lambda=A^\top\lambda'
\]
produce identical local linear price terms \(\lambda^\top Ax=\lambda'^\top Ax\) for every x.

Proof.
\[
(\lambda-\lambda')^\top Ax
=x^\top A^\top(\lambda-\lambda')=0.
\]
QED.

Hence dual signals themselves possess a semantic quotient.

## 422. Canonical price semantics is a quotient by \(\ker A^\top\)
Define
\[
\lambda\sim\lambda'
\iff
A^\top\lambda=A^\top\lambda'.
\]
Then equivalence classes are affine cosets of \(\ker A^\top\), and the effective price signal is \(A^\top\lambda\).

Proof. Equality iff \(A^\top(\lambda-\lambda')=0\), i.e. difference lies in kernel. QED.

## 423. Effective price-space dimension equals rank(A)
The image of \(A^\top\) has dimension rank(A). Therefore the semantic dimension of linear price signals is rank(A), regardless of redundant multiplier coordinates.

Proof. rank(A^T)=rank(A). QED.

## 424. Market coordination itself has a reconstruction/quotient structure
Raw multiplier λ is reconstructible only modulo \(\ker A^\top\) from its effect on agents. Two multipliers in the same coset are observationally identical to all local linear-response objectives.

Proof. Theorems 421–422. QED.

## 425. Global feasibility residual lies in the primal constraint space while price lies in its dual
Residual
\[
r=\sum_iA_ix_i-b
\]
is a vector in constraint space \(\mathbb R^m\); multiplier λ is in its dual, and scalar mismatch penalty is pairing
\[
\lambda^\top r.
\]

Proof. By dimensions and definition of Lagrangian pairing. QED.

This is the exact primal/dual interface through which local actions and global coordination meet.
