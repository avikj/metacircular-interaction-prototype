# COORDINATION THEOREMS V — SEMILATTICES, ASYNCHRONY, FIXED POINTS, AND COORDINATION-FREE INVARIANTS
Date: 2026-08-13

Status: exact mathematical lemmas and proofs. No novelty claims.

## 110. Join merge is order-, grouping-, and duplicate-independent

Let (L,∨) be a join-semilattice. For any finite multiset of states \(x_1,\dots,x_n\), the merged state
\[
x_1\vee\cdots\vee x_n
\]
is invariant under permutation and parenthesization, and duplicate occurrences do not change it.

### Proof
Associativity gives parenthesization invariance, commutativity gives permutation invariance, and idempotence \(x\vee x=x\) removes duplicates. QED.

## 111. Eventual-delivery convergence for join-replicated state

Let replicas start from common \(x_0\in L\). Each update contributes an element \(u\in L\), and replica state is updated by join. If every replica eventually receives the same finite set U of updates, then every replica converges to
\[
x^*=x_0\vee\bigvee_{u\in U}u
\]
independently of message order and duplication.

### Proof
By Theorem 110, any order and any number of duplicate joins over the same underlying update set produces the same join. QED.

## 112. No consensus on interleaving is required for pure join semantics

Under Theorem 111, replicas need agree only on the eventual set of updates, not on any total order of those updates.

### Proof
The terminal state depends only on the set through its join, by commutativity and idempotence. QED.

## 113. Monotone inflationary asynchronous convergence on a finite poset

Let (L,≤) be a finite poset. Let \(f_1,\dots,f_m:L\to L\) be monotone and inflationary:
\[
x\le f_i(x)
\]
for all x,i. Starting at \(x_0\), choose a fair infinite schedule \(i_0,i_1,\dots\) in which every i occurs infinitely often, and iterate
\[
x_{t+1}=f_{i_t}(x_t).
\]
Then the sequence stabilizes at a common fixed point \(x^*\):
\[
f_i(x^*)=x^*\quad\forall i.
\]

### Proof
Inflationarity yields \(x_t\le x_{t+1}\), so \((x_t)\) is an ascending chain. Finiteness of L implies eventual stabilization: \(x_t=x^*\) for all \(t\ge T\). Fix i. Fairness gives some \(t\ge T\) with \(i_t=i\). Then
\[
x^*=x_{t+1}=f_i(x_t)=f_i(x^*).
\]
Thus every i fixes \(x^*\). QED.

## 114. Least common fixed point above the initial state

Under Theorem 113, the limit \(x^*\) is the least common fixed point y satisfying \(x_0\le y\).

### Proof
Let y be any common fixed point with \(x_0\le y\). Inductively, if \(x_t\le y\), then monotonicity gives
\[
x_{t+1}=f_{i_t}(x_t)\le f_{i_t}(y)=y.
\]
Thus \(x_t\le y\) for every t, hence \(x^*\le y\). QED.

## 115. Fair asynchronous schedule independence

Under Theorem 113, every fair schedule from the same \(x_0\) converges to the same state.

### Proof
By Theorem 114 every fair schedule converges to the unique least common fixed point above \(x_0\). QED.

This is exact order-independence without requiring pairwise commutation of the update functions.

## 116. Inflationary monotone collective behavior defines a canonical closure operator

Define
\[
C(x)=\text{the least common fixed point of }\{f_i\}\text{ above }x
\]
on finite L. Then:
1. \(x\le C(x)\) (extensive);
2. \(x\le y\Rightarrow C(x)\le C(y)\) (monotone);
3. \(C(C(x))=C(x)\) (idempotent).

### Proof
(1) by definition.
(2) \(C(y)\) is a common fixed point above y and hence above x; minimality of C(x) gives \(C(x)\le C(y)\).
(3) C(x) is already a common fixed point, so the least common fixed point above C(x) is C(x). QED.

Thus the entire asynchronous collective computation is represented extensionally by a closure operator.

## 117. Fixed points are precisely closed states

For C from Theorem 116,
\[
C(x)=x
\iff
f_i(x)=x\quad\forall i.
\]

### Proof
If C(x)=x, C(x) is by construction a common fixed point. Conversely, if x is already a common fixed point, it is the least common fixed point above itself. QED.

## 118. Common fixed points of closure operators are closed under meet when the meet exists

Let \(C:L\to L\) be a closure operator on a lattice. If x,y are fixed points of C, then \(x\wedge y\) is a fixed point.

### Proof
Since \(x\wedge y\le x,y\), monotonicity gives
\[
C(x\wedge y)\le C(x)=x,\qquad C(x\wedge y)\le y.
\]
Thus \(C(x\wedge y)\le x\wedge y\). Extensivity gives the reverse inequality. QED.

## 119. Knaster–Tarski fixed-point theorem

Let L be a complete lattice and \(f:L\to L\) monotone. Then the set of fixed points of f is a complete lattice. In particular f has least and greatest fixed points.

### Proof
Let
\[
P=\{x:f(x)\le x\}
\]
be the prefixed points and define \(a=\bigwedge P\). For every x∈P, \(a\le x\), so monotonicity gives \(f(a)\le f(x)\le x\). Hence \(f(a)\le a\), so \(f(a)\in P\). Since a is the meet of P, \(a\le f(a)\). Thus f(a)=a. If y is any fixed point, y∈P, hence a≤y; therefore a is the least fixed point.

Dually, let
\[
Q=\{x:x\le f(x)\}
\]
and \(b=\bigvee Q\). The dual argument gives f(b)=b and b greatest.

For completeness of the fixed-point set: given fixed points S, consider the monotone map on the interval above \(\bigvee S\) and take its least fixed point to obtain the join in Fix(f); dually obtain meets. QED.

## 120. Monotone global rule admits least semantics without choosing an execution path

If a collective specification is a monotone map \(f:L\to L\) on a complete lattice, its least fixed point
\[
\mu f
\]
is mathematically determined by f alone, independently of any operational schedule used to approximate it.

### Proof
Existence and uniqueness as the least fixed point follow from Theorem 119. QED.

## 121. Kleene iteration on a finite lattice reaches the least fixed point above bottom

Let L be finite with bottom ⊥ and f monotone. Assume f is inflationary. Then
\[
\bot\le f(\bot)\le f^2(\bot)\le\cdots
\]
stabilizes after finitely many steps at the least fixed point of f.

### Proof
Inflationarity gives an ascending chain, finite L gives stabilization at x with f(x)=x. Any fixed point y satisfies ⊥≤y; induction by monotonicity gives \(f^n(\bot)\le y\), hence the limit x≤y. QED.

## 122. Join-closed invariant preservation

Let S⊆L be an invariant set in a join-semilattice. Suppose:
1. \(x_0\in S\);
2. every locally generated update state u belongs to S;
3. S is closed under join:
\[
x,y\in S\Rightarrow x\vee y\in S.
\]
Then every replica state obtained by arbitrary joins of valid updates remains in S.

### Proof
Induct on the number of joined update states using join-closure. QED.

## 123. Join-closure is necessary for unrestricted coordination-free merge preservation

Suppose local replicas may independently reach any states x,y∈S and then merge by join. If every such merge must preserve invariant S without coordination, then necessarily
\[
x,y\in S\Rightarrow x\vee y\in S.
\]

### Proof
Choose arbitrary x,y∈S as independently reachable replica states. Their required coordination-free merge is x∨y and must lie in S. QED.

Thus, under unrestricted independent reachability and join merge,
\[
\boxed{\text{coordination-free invariant preservation}\iff\text{invariant is join-closed}.}
\]

## 124. Non-join-closed invariants force some restriction on independent evolution

If there exist x,y∈S with \(x\vee y\notin S\), then no system allowing both x and y to arise independently and later merge by join can preserve S without an additional restriction.

### Proof
Their merge violates S. Therefore at least one of: independent reachability, unrestricted merge, or the invariant requirement must be restricted. QED.

This is a precise lower-bound form of “coordination is required”: some cross-replica constraint must prevent the bad pair from simultaneously arising or merging.

## 125. Escrow-style decomposition theorem for a conserved additive resource

Let a total resource capacity be K and replicas hold nonnegative integer rights \(r_i\) with
\[
\sum_i r_i=K.
\]
Replica i may independently consume \(c_i\le r_i\), replacing \(r_i\) by \(r_i-c_i\). Then aggregate consumption never exceeds K:
\[
\sum_i c_i\le K.
\]

### Proof
Since each \(c_i\le r_i\),
\[
\sum_i c_i\le\sum_i r_i=K.
\]
QED.

Thus a global inequality constraint can be made coordination-free by pre-distributing conserved local capabilities.

## 126. Capability conservation converts a global invariant into local admissibility

Under Theorem 125, define local admissibility as \(c_i\le r_i\). Then the global invariant “total consumption ≤K” follows from conjunction of local admissibility checks.

### Proof
Theorem 125. QED.

This is a general pattern: decompose a global conserved quantity into locally held capabilities whose sum is conserved.

## 127. Transfer of capabilities preserves the global invariant

Suppose replicas may transfer d units of rights from i to j:
\[
r_i'=r_i-d,\qquad r_j'=r_j+d,
\]
with \(0\le d\le r_i\). Then
\[
\sum_k r_k'=\sum_k r_k=K.
\]

### Proof
The -d and +d terms cancel. QED.

Hence capability ownership can move without changing total authority.

## 128. Double-spending a capability is exactly violation of conservation

If the same unit of right is simultaneously counted in two replicas' available rights, then the represented total \(\sum_i r_i\) exceeds the true conserved capacity.

### Proof
Duplicating one unit adds one to the represented sum without a corresponding conserved source. QED.

Thus prevention of duplication, not total ordering of unrelated actions, is the irreducible coordination requirement for conserved transferable capabilities.

## 129. Disjoint capability spending commutes

Let state \(r=(r_1,\dots,r_n)\). Spending \(a\) from replica i and \(b\) from replica j with i≠j gives the same final state in either order, provided both spends are locally admissible:
\[
S_i^a S_j^b(r)=S_j^b S_i^a(r).
\]

### Proof
The two maps subtract from distinct coordinates. QED.

## 130. Same-capability competing spends need conflict resolution

Let one account have right r and two proposed spends a,b with
\[
a\le r,\quad b\le r,\quad a+b>r.
\]
Each spend is individually admissible from the initial state, but both cannot be jointly admitted while preserving nonnegative remaining rights.

### Proof
Joint admission leaves \(r-a-b<0\). QED.

The conflict is localized exactly to overlapping claims on the same conserved capability.

## 131. Conflict graph for conserved-resource operations

Given proposed resource-consuming events e with demanded capability subsets D_e, define conflict
\[
e\#f\iff D_e\cap D_f\ne\varnothing
\]
for indivisible rights, or more generally when joint demand exceeds shared capacity. Any set of pairwise/noncollectively nonconflicting events can execute without serialization while preserving conservation.

### Proof
If demands are disjoint, deductions occur on disjoint resource coordinates and commute; aggregate consumption cannot duplicate a right. For divisible capacity, require feasibility of the selected demand set. QED.

## 132. Event configurations form a downward-closed feasibility family

Let E be proposed events and define \(\mathcal F\subseteq 2^E\) as sets whose joint resource demands are feasible. Then
\[
S\in\mathcal F,\ T\subseteq S\Rightarrow T\in\mathcal F.
\]

### Proof
Removing demands cannot turn a feasible resource allocation into an infeasible one. QED.

## 133. Feasibility can require hypergraph conflicts rather than pairwise conflicts

There exist capacity systems where every pair of events is jointly feasible but a triple is infeasible.

### Proof
Let shared capacity K=2 and three events each demand one unit. Every pair demands 2≤K; all three demand 3>K. QED.

Therefore conflict structures for resource constraints are generally hypergraphic, matching the higher-order informational obstruction result.

## 134. Monotone knowledge accumulation is a join-semilattice

Let K be a universe of certified facts and system state be any subset S⊆K. Ordered by inclusion, \(2^K\) is a complete lattice with join union:
\[
S\vee T=S\cup T.
\]
Adding certified facts is inflationary and monotone.

### Proof
Standard power-set lattice properties. If S⊆T then \(S\cup\{k\}\subseteq T\cup\{k\}\), and S⊆S∪{k}. QED.

## 135. Independent certified discoveries commute exactly

For fact-addition maps \(F_a(S)=S\cup\{a\}\) and \(F_b(S)=S\cup\{b\}\),
\[
F_aF_b=F_bF_a.
\]

### Proof
Both yield \(S\cup\{a,b\}\). QED.

## 136. Deductive closure is a closure operator

Let \(\vdash\) be any monotone consequence relation and define
\[
\mathrm{Cl}(S)=\{\varphi:S\vdash\varphi\}.
\]
Assume reflexivity, monotonicity, and cut/idempotence of consequence. Then Cl is extensive, monotone, and idempotent.

### Proof
Reflexivity gives S⊆Cl(S). Monotonicity of consequence gives S⊆T⇒Cl(S)⊆Cl(T). Cut says consequences of consequences are already consequences of S, hence Cl(Cl(S))=Cl(S). QED.

## 137. Asynchronous theorem-rule firing converges to deductive closure in a finite rule system

Let K be finite and inference rules be monotone inflationary operators on \(2^K\). Under a fair schedule that repeatedly applies every rule, starting from S₀, the system converges to the least rule-closed superset of S₀.

### Proof
Apply Theorems 113–115 to the finite lattice \(2^K\). QED.

Thus a finite theorem-producing society of sound monotone inference rules does not require a global execution order to reach its canonical closure.

## 138. A retraction identifies exact summary state

Let C:L→L be a closure operator and let Fix(C) be its closed states. The inclusion
\[
i:\mathrm{Fix}(C)\hookrightarrow L
\]
and closure map
\[
C:L\to\mathrm{Fix}(C)
\]
satisfy
\[
C\circ i=\mathrm{id}_{\mathrm{Fix}(C)}.
\]

### Proof
Every closed state x satisfies C(x)=x. QED.

Hence closed states are a retract of raw states: closure is an exact semantic summarization of arbitrary intermediate execution histories.

## 139. Two histories with the same closure are indistinguishable to every closure-invariant query

If C(x)=C(y) and q satisfies \(q=q\circ C\), then q(x)=q(y).

### Proof
\[
q(x)=q(C(x))=q(C(y))=q(y).
\]
QED.

Thus closure defines the canonical quotient for all queries invariant under further deduction/update completion.
