# COORDINATION THEOREMS VIII — PRICES, DUAL COORDINATION, PRODUCT GAMES, AND POTENTIAL DYNAMICS
Date: 2026-08-13

Status: exact mathematical lemmas and proofs. No novelty claims.

## 191. Separable resource allocation admits a scalar coordination price

Let agents i=1,…,n choose \(x_i\ge0\). Let each \(u_i:[0,\infty)\to\mathbb R\) be concave and differentiable. Consider
\[
\max_{x_i\ge0}\ \sum_i u_i(x_i)
\quad\text{s.t.}\quad
\sum_i x_i\le K.
\]
Suppose \(x^*\) is optimal and a KKT multiplier \(\lambda^*\ge0\) exists for the capacity constraint. Then each agent's component solves
\[
x_i^*\in\arg\max_{x_i\ge0}\big(u_i(x_i)-\lambda^*x_i\big),
\]
and
\[
\lambda^*\Big(\sum_i x_i^*-K\Big)=0.
\]

### Proof
The Lagrangian is
\[
L(x,\lambda)=\sum_i u_i(x_i)-\lambda\Big(\sum_i x_i-K\Big)
=\lambda K+\sum_i\big(u_i(x_i)-\lambda x_i\big).
\]
At a primal-dual optimum satisfying KKT, x* maximizes \(L(\cdot,\lambda^*)\) over \(x_i\ge0\). Because the Lagrangian separates across i, each coordinate independently maximizes its own term. Complementary slackness gives the second equation. QED.

## 192. Common price equalizes marginal utility at interior allocations

Under Theorem 191, if \(x_i^*>0\) and u_i is differentiable at \(x_i^*\), then
\[
u_i'(x_i^*)=\lambda^*.
\]

### Proof
The local objective \(u_i(x)-\lambda^*x\) has an interior maximum at \(x_i^*\), so its derivative vanishes:
\[
u_i'(x_i^*)-\lambda^*=0.
\]
QED.

## 193. Boundary agents have marginal utility no larger than the price

If \(x_i^*=0\), concavity and local optimality imply
\[
u_i'(0)\le \lambda^*
\]
whenever the right derivative exists.

### Proof
For \(x=0\) to maximize \(u_i(x)-\lambda^*x\) on \(x\ge0\), the right derivative at zero must be nonpositive:
\[
u_i'(0)-\lambda^*\le0.
\]
QED.

## 194. A single global coupling constraint needs only one dual coordination variable

In Theorem 191, conditional on \(\lambda^*\), every agent's optimization is independent of every other agent's private utility function and choice.

### Proof
Agent i solves
\[
\max_{x_i\ge0}u_i(x_i)-\lambda^*x_i,
\]
which contains no \(u_j\) or \(x_j\) for j≠i. QED.

Thus an n-agent globally coupled optimum can be coordinated through one scalar when the only coupling is one scalar capacity constraint.

## 195. m coupling constraints yield an m-dimensional price interface

Let each agent choose vector \(x_i\in X_i\) and solve
\[
\max \sum_i u_i(x_i)
\]
subject to
\[
\sum_i A_i x_i\le b\in\mathbb R^m.
\]
For multiplier \(\lambda\in\mathbb R_+^m\), the Lagrangian is
\[
L(x,\lambda)
=
\lambda^\top b+
\sum_i\left(u_i(x_i)-\lambda^\top A_ix_i\right).
\]
At any KKT optimum \((x^*,\lambda^*)\), each \(x_i^*\) independently maximizes its local term.

### Proof
Algebraically expand the Lagrangian and apply coordinatewise maximization exactly as in Theorem 191. QED.

The dimension of the dual coordination interface is the number of coupling constraints, not the number of agents.

## 196. No coupling constraints implies exact product decomposition

If the feasible set is a product
\[
X=X_1\times\cdots\times X_n
\]
and objective is separable
\[
U(x)=\sum_i u_i(x_i),
\]
then
\[
\arg\max_{x\in X}U(x)
=
\prod_i \arg\max_{x_i\in X_i}u_i(x_i).
\]

### Proof
If each coordinate is locally maximizing, no coordinate replacement can improve its summand, so the sum is globally maximal. Conversely, if a global maximizer had a nonmaximal coordinate, replacing only that coordinate by a better one would increase U, contradiction. QED.

## 197. Coupling rank bounds coordination dimension in linear-resource models

Suppose all cross-agent coupling is expressed by
\[
A_1x_1+\cdots+A_nx_n\le b
\]
with row rank r. Then redundant constraints can be removed so that at most r independent dual coordinates are required to represent the linear coupling.

### Proof
Choose a basis of the row space of the stacked constraint operator. Every original linear constraint is a linear combination of r basis constraints, so the feasible affine coupling information is represented by those r independent rows. Corresponding Lagrange multipliers live in an r-dimensional dual row space after quotienting redundant directions. QED.

## 198. Shadow price equals marginal value of capacity under differentiability

Let
\[
V(K)=\max_{\sum_i x_i\le K}\sum_i u_i(x_i)
\]
and suppose V is differentiable at K and strong duality/KKT hold with unique optimal multiplier \(\lambda^*\). Then
\[
V'(K)=\lambda^*.
\]

### Proof
The dual representation is locally
\[
V(K)=\min_{\lambda\ge0}\left[\lambda K+\sum_i \sup_{x_i\ge0}(u_i(x_i)-\lambda x_i)\right].
\]
At a differentiability point with unique minimizer, the envelope theorem gives derivative with respect to K equal to the coefficient of K at the optimum, \(\lambda^*\). QED.

Thus price is literally marginal system value of relaxing the shared resource constraint.

## 199. Independent normal-form games compose

Let game G have players I, strategy space \(S=\prod_{i\in I}S_i\), payoffs \(u_i\). Let game H have disjoint players J, strategies \(T=\prod_{j\in J}T_j\), payoffs \(v_j\). Define product game G×H with strategy space S×T and payoffs unchanged within each component:
\[
U_i(s,t)=u_i(s),\quad i\in I,
\]
\[
U_j(s,t)=v_j(t),\quad j\in J.
\]
Then
\[
NE(G\times H)=NE(G)\times NE(H).
\]

### Proof
If (s*,t*) is a Nash equilibrium of the product, an I-player deviation changes only u_i(s), so s* must be a Nash equilibrium of G; similarly t*∈NE(H). Conversely if s*,t* are component equilibria, no player can gain by a unilateral deviation because its payoff depends only on its own component. QED.

## 200. Additively independent mechanisms preserve dominant-strategy truthfulness under product

Let mechanisms M₁,M₂ act on disjoint type/action components, and suppose each is dominant-strategy incentive compatible. Suppose each agent's total utility is the sum of its utilities from the two mechanisms and reports/actions in one mechanism do not affect allocations/payments in the other. Then the product mechanism is dominant-strategy incentive compatible.

### Proof
Fix an agent and arbitrary reports of others. Any joint deviation decomposes into deviations in components 1 and 2. Truthfulness weakly maximizes utility in each component separately by DSIC. Summing the two inequalities shows truthful joint reporting weakly maximizes total utility. QED.

## 201. Cross-component utility destroys the product proof

If total utility contains a coupling term
\[
w_i(o_1,o_2)
\]
depending jointly on outcomes of the two mechanisms, componentwise DSIC alone does not imply DSIC of the product.

### Proof
Componentwise DSIC controls only changes in the separate terms. A deviation that changes one component can improve the cross-term enough to offset its local loss. Example: each component gives utility 0 regardless of truth, but the cross-term pays 1 iff the two reported bits differ; truthful equal bits are then not jointly optimal. QED.

Thus incentive composition requires the same structural independence as computational composition.

## 202. Exact potential games possess pure Nash equilibria

A finite game is an exact potential game if there exists \(\Phi:S\to\mathbb R\) such that for every unilateral deviation \(s_i\to s_i'\),
\[
u_i(s_i',s_{-i})-u_i(s_i,s_{-i})
=
\Phi(s_i',s_{-i})-\Phi(s_i,s_{-i}).
\]
Then every maximizer of Φ is a pure Nash equilibrium.

### Proof
Let s* maximize Φ. If some player had a profitable unilateral deviation, the potential would increase by exactly the same positive amount, contradicting maximality. QED.

## 203. Better-response dynamics terminate in finite exact potential games

In a finite exact potential game, any sequence of strict unilateral better responses terminates after finitely many steps at a pure Nash equilibrium.

### Proof
Each strict better response strictly increases Φ. A finite strategy space has finitely many potential values along visited states, so an infinite strictly increasing sequence is impossible. At termination no player has a strict profitable deviation, hence the state is a pure Nash equilibrium. QED.

## 204. Potential is a global Lyapunov function for decentralized selfish updates

Under Theorem 203, local utility-improving moves monotonically increase the global scalar Φ:
\[
\Delta u_i>0\implies \Delta\Phi>0.
\]

### Proof
Exact potential equality. QED.

Thus globally convergent collective behavior can emerge from purely local selfish improvement when incentives admit a potential.

## 205. Rosenthal potential for congestion games

Let resources e have cost \(c_e(k)\) when k players use e. Each player chooses a subset of resources; its cost is the sum of resource costs at realized congestion. Define
\[
\Phi(s)=\sum_e\sum_{k=1}^{n_e(s)} c_e(k),
\]
where \(n_e(s)\) is the number of users of e. Then unilateral changes in a player's cost equal the corresponding change in Φ.

### Proof
When player i changes strategy, resources used by neither old nor new strategy do not change. If i leaves resource e with congestion n, Φ decreases by \(c_e(n)\), exactly the cost term i had paid on e. If i joins resource e previously at congestion n, Φ increases by \(c_e(n+1)\), exactly the new cost term i pays. Summing entered and left resources yields
\[
\Phi(s_i',s_{-i})-\Phi(s_i,s_{-i})
=
\mathrm{cost}_i(s_i',s_{-i})-\mathrm{cost}_i(s_i,s_{-i}).
\]
For utilities equal negative costs, this is an exact potential up to sign. QED.

## 206. Finite congestion games possess pure equilibria

Every finite congestion game has a pure Nash equilibrium.

### Proof
By Theorem 205 it is an exact potential game; apply Theorem 202. QED.

## 207. Local tolls can alter the potential landscape without changing physical feasibility

Suppose an agent using resource e pays added toll \(\tau_e(n_e)\). The physical feasible strategy space is unchanged, while the effective congestion cost becomes
\[
\tilde c_e(k)=c_e(k)+\tau_e(k).
\]
The new game has Rosenthal potential
\[
\tilde\Phi(s)=\sum_e\sum_{k=1}^{n_e(s)}\tilde c_e(k).
\]

### Proof
Feasibility depends only on strategy sets, not payoff functions. Theorem 205 applied to modified costs gives the new potential. QED.

Thus incentives reshape collective dynamics without changing the underlying action graph.

## 208. Hard constraints and prices act on distinct mathematical objects

In constrained optimization:
- feasibility constraints define the admissible set X;
- prices/Lagrange multipliers modify the objective over X.

Changing a hard constraint can remove actions; changing a multiplier without changing X cannot.

### Proof
By definition, X is determined by constraints. Lagrange multipliers appear in the objective of the dual/local problems but do not enlarge the primal feasible set. QED.

## 209. Information, feasibility, and incentives are independent control axes

There exist examples where changing exactly one of the following changes behavior while the other two are fixed:
1. information available to agents;
2. feasible action sets;
3. payoff functions.

### Proof
Information: decision under unknown vs revealed state with same actions/payoffs.
Feasibility: forbid a previously profitable action while information/payoffs on remaining actions stay fixed.
Incentives: change payoff ranking between two feasible known actions.
Each modification can alter behavior independently. QED.

## 210. Dual prices are sufficient only for the modeled coupling constraints

If the true system contains an additional cross-agent constraint not represented in the Lagrangian, then local optimization against the old multiplier vector need not yield a globally feasible or optimal point.

### Proof
Example: two agents each locally choose x_i=1 because only price for \(\sum x_i\le2\) is represented, while an omitted constraint \(x_1+x_2\le1\) is violated. QED.

Thus compressed coordination variables are exact only relative to a correctly specified interface of global couplings.

## 211. Minimal dual coordination dimension is bounded below by independent active couplings locally

At a regular optimum with r linearly independent active coupling constraints whose multipliers vary independently under perturbations, any smooth local parameterization of the complete first-order coupling signal requires dimension at least r.

### Proof
The multiplier vector lies locally in an r-dimensional space of independent dual directions. A smooth injective parameterization preserving all such variations into \(\mathbb R^d\) requires \(d\ge r\) by rank of the differential. QED.

This gives a local differential lower bound matching the upper bound of Theorem 197 in regular linear settings.
