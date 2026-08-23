# COORDINATION THEOREMS XVIII — COMPOSITIONAL SAFETY KERNELS AND MAXIMAL PERMISSIVENESS
Date: 2026-08-13
Status: exact finite relational/game lemmas; no novelty claims.

## 486. Safe-action kernel
Let state x have feasible action set A(x), transition relation R(x,a,x'), and safe-state set S. Define
\[
K_S(x)=\{a\in A(x):\forall x',R(x,a,x')\Rightarrow x'\in S\}.
\]
Then choosing any action in K_S(x) guarantees one-step safety.

Proof. Definition. QED.

## 487. Maximality of the one-step safety kernel
If action a∉K_S(x), then there exists an R-possible successor outside S. Hence no action set strictly containing K_S(x) can guarantee one-step safety against all transition nondeterminism.

Proof. Negate the universal condition in the definition. QED.

## 488. Safety kernel is a weakest-liberal-precondition construction
For each action a define relation R_a:X↝X. Then
\[
a\in K_S(x)
\iff
x\in WLP_{R_a}(S).
\]

Proof. Both say every R_a-successor of x lies in S. QED.

## 489. Controlled invariant set
Define operator on state subsets
\[
\Gamma(S)=\{x:\exists a\in A(x)\ \forall x',R(x,a,x')\Rightarrow x'\in S\}.
\]
A set S is controlled invariant iff
\[
S\subseteq\Gamma(S).
\]

Proof. S⊆Γ(S) says every state in S admits an action keeping every possible next state in S, exactly controlled invariance. QED.

## 490. Γ is monotone
If S⊆T, then
\[
\Gamma(S)\subseteq\Gamma(T).
\]

Proof. Any action whose successors all lie in S also has successors all in T. QED.

## 491. Greatest controlled-invariant subset of a safety set on a finite state space
Let Safe⊆X finite. Define
\[
S_0=Safe,\qquad
S_{k+1}=Safe\cap\Gamma(S_k).
\]
Then the descending sequence stabilizes at S* and S* is the greatest controlled-invariant subset of Safe.

Proof. Monotonicity and intersection give \(S_{k+1}\subseteq S_k\); finiteness yields stabilization S*. Then
\[
S*=Safe\cap\Gamma(S*)
\]
so S*⊆Γ(S*), hence controlled invariant.

If T⊆Safe is any controlled-invariant set, inductively T⊆S_k: true for k=0; if T⊆S_k, monotonicity gives Γ(T)⊆Γ(S_k), while T⊆Γ(T), so T⊆Safe∩Γ(S_k)=S_{k+1}. Thus T⊆S*. QED.

## 492. Maximal permissive safe controller
At x∈S*, define allowed actions
\[
A^*(x)=\{a\in A(x):\forall x',R(x,a,x')\Rightarrow x'\in S^*\}.
\]
Then allowing every action in A*(x) preserves S* forever, and adding any action outside A*(x) at x destroys the guarantee of remaining in S* for one step.

Proof. First part by induction over time: every allowed transition stays in S*. Second part by Theorem 487. QED.

Thus safety need not select one prescribed policy; it can expose the entire maximal safe action fiber.

## 493. Maximal safe freedom is a relation
Define
\[
R_{\mathrm{safe}}(x,a)\iff x\in S^*\ \wedge\ a\in A^*(x).
\]
Every controller selecting any a from this relation is safe, and every universally safe controller on S* is a subrelation of it.

Proof. Safety follows from Theorem 492. Any universally safe controller cannot choose an action with a successor outside S*, hence all its choices lie in A*. QED.

This is the exact “constraint rather than prescribed algorithm” construction for finite safety games.

## 494. Stronger safety set shrinks the one-step kernel
If S⊆T, then
\[
K_S(x)\subseteq K_T(x).
\]

Proof. Keeping every successor in smaller S implies keeping it in larger T. QED.

## 495. More adversarial nondeterminism shrinks safe freedom
Let transition relations R⊆R' (R' permits all R transitions plus more). Then
\[
K_S^{R'}(x)\subseteq K_S^R(x).
\]

Proof. An action safe against every R'-successor is safe against the subset of R-successors. QED.

## 496. Verification can enforce the maximal safe kernel without choosing among safe actions
Suppose a verifier accepts action a at x iff \(a\in A^*(x)\). Then any accepted action preserves safety, while agents remain free to optimize arbitrary secondary objectives within A*(x).

Proof. Accepted implies membership in maximal safe set; Theorem 492 gives safety. The verifier imposes no ranking among accepted actions. QED.

## 497. Safety constraints and utility optimization compose lexicographically by feasible restriction
Let agent utility u(x,a). If action choice is restricted to A*(x), then
\[
a^\star\in\arg\max_{a\in A^*(x)}u(x,a)
\]
is safe regardless of the form of u.

Proof. Every element of A*(x) is safe; optimization selects one of them. QED.

Thus safety can be architectural while preference remains unconstrained inside the safe fiber.

## 498. Alignment burden reduction theorem
Let original action set A(x) contain unsafe actions U(x)=A(x)\A*(x). Without enforcement, guaranteeing safety through preferences requires the chosen policy never select U(x). With exact enforcement of A*(x), no preference condition concerning U(x) is needed.

Proof. Enforcement makes U(x) infeasible. Policy optimization occurs only over A*(x). QED.

## 499. Incomplete safety predicate leaves residual alignment burden
If verifier permits B(x) with
\[
A^*(x)\subsetneq B(x)\subseteq A(x),
\]
then guaranteeing safety additionally requires the agent never choose any action in
\[
B(x)\setminus A^*(x).
\]

Proof. Those actions remain feasible but are not certified universally safe. Therefore architecture alone does not exclude them. QED.

## 500. Exact specification minimizes preference assumptions for a fixed safety objective
Among enforcement sets B(x) that contain all maximally safe actions A*(x), choosing B=A* eliminates every unsafe feasible action while retaining every universally safe action.

Proof. Any strict superset contains at least one action outside A*, which by maximality has an unsafe successor. Any strict subset unnecessarily removes a universally safe action. QED.

## 501. Distributed product safety kernel factorizes under independent dynamics
Let X=X_A×X_B, Safe=S_A×S_B, actions factor, and transitions factor:
\[
R((x_A,x_B),(a_A,a_B),(x_A',x_B'))
\iff
R_A(x_A,a_A,x_A')\wedge R_B(x_B,a_B,x_B').
\]
Then
\[
K_{Safe}(x_A,x_B)=K_{S_A}(x_A)\times K_{S_B}(x_B).
\]

Proof. All product successors lie in S_A×S_B iff every A-successor lies in S_A and every B-successor lies in S_B. QED.

## 502. Coupled safety constraints destroy kernel factorization
There exist independent dynamics with nonproduct Safe for which the global safe-action kernel is not a product of local kernels.

Proof. Let two bits each independently choose next bit, but Safe={(0,0),(1,1)}. From (0,0), allowed joint next choices are (0,0) or (1,1), not the Cartesian product of individual choices {0,1}×{0,1}, because mixed choices are unsafe. QED.

The coupling resides entirely in the global invariant.

## 503. A conserved-sum safety constraint yields coupled but low-dimensional coordination
Let nonnegative resources x_i satisfy
\[
\sum_i x_i=K.
\]
Actions transfer amounts while preserving the sum. The global invariant is one scalar equation even though it couples all n components.

Proof. Valid state set is the codimension-one hyperplane/simplex intersection defined by the single sum equation. QED.

## 504. Capability decomposition localizes conserved-sum safety
If each local action may spend only locally owned capability and transfers preserve total capability, then global nonoverspending follows from local checks plus conservation.

Proof. Previous escrow/capability conservation theorems. QED.

## 505. Barrier certificate sufficient condition
Let deterministic continuous-time system
\[
\dot x=f(x)
\]
and differentiable B:X→R. Define safe region
\[
S=\{x:B(x)\le0\}.
\]
If on the boundary B(x)=0,
\[
\nabla B(x)\cdot f(x)\le0,
\]
and standard existence/uniqueness regularity holds, trajectories starting in S cannot cross the boundary outward at a first exit time.

Proof. Suppose first exit occurs. At first boundary contact from inside followed by outward crossing, the right derivative of B along trajectory must be positive at some boundary crossing point. But
\[
\frac d{dt}B(x(t))=\nabla B\cdot f\le0
\]
on the boundary, contradiction to outward first crossing under the regularity assumptions. QED.

## 506. Controlled barrier kernel
For controlled dynamics \(\dot x=f(x,u)\), define boundary-safe controls
\[
K_B(x)=\{u:\nabla B(x)\cdot f(x,u)\le0\}
\]
when B(x)=0. Any feedback selecting from K_B on the boundary satisfies the barrier sufficient condition.

Proof. Substitution into Theorem 505. QED.

## 507. Barrier enforcement leaves interior policy freedom
The condition in Theorem 506 constrains controls only where needed by the chosen barrier certificate; controls strictly inside B<0 may remain unrestricted unless additional conditions are imposed.

Proof. The stated sufficient condition is only a boundary inequality. QED.

This gives a continuous-state analogue of maximal safe fibers, though maximality is not claimed for a general barrier certificate.

## 508. Safety certificates compose under conjunction
Let safe predicates be \(B_j(x)\le0\), each preserved by every accepted transition/control. Then their conjunction is preserved.

Proof. If every individual predicate remains true after each accepted step, all remain true simultaneously. QED.

## 509. Local safety certificates imply global safety for product invariants
Under product dynamics and product safe set, independently certified local invariant preservation implies global invariant preservation.

Proof. Theorem 501 plus induction over transitions. QED.

## 510. Nonproduct invariant requires a joint certificate or sufficient conserved summary
If Safe⊂X_A×X_B is not representable as S_A×S_B, purely independent local membership certificates for fixed S_A,S_B cannot characterize Safe exactly.

Proof. Any conjunction of independent predicates \(P_A(x_A)\wedge P_B(x_B)\) defines a Cartesian product of their satisfying sets. A nonproduct Safe cannot equal such a set. QED.

Thus exact decentralized safety requires either a genuinely joint predicate or an interface carrying sufficient coupling information.
