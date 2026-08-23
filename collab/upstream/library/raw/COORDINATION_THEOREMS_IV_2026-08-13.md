# COORDINATION THEOREMS IV — PROTOCOL GEOMETRY, COHOMOLOGICAL GLUING, AND MECHANISM DESIGN
Date: 2026-08-13

Status: exact mathematical lemmas and proofs. No novelty claims.

## 80. Deterministic two-party transcript rectangles

Let Alice hold x∈X and Bob hold y∈Y. Consider a deterministic finite interactive protocol. For any complete transcript τ, the set
\[
R_\tau=\{(x,y):\text{the protocol on }(x,y)\text{ produces }\tau\}
\]
is a combinatorial rectangle:
\[
R_\tau=A_\tau\times B_\tau
\]
for some \(A_\tau\subseteq X\), \(B_\tau\subseteq Y\).

### Proof
Induct on protocol depth. Before communication the possible input set is X×Y, a rectangle. Suppose the current node is reached on rectangle A×B. If Alice speaks, her next message is a function only of x and the prior transcript. Fixing one outgoing message restricts A to a subset A' but leaves B unchanged, producing A'×B. If Bob speaks, similarly obtain A×B'. Continue to the leaf transcript τ. QED.

## 81. Exact deterministic computation partitions the input matrix into monochromatic rectangles

Let f:X×Y→Z be computed exactly by a deterministic protocol. Then the transcript rectangles form a partition of X×Y, and every rectangle is f-monochromatic.

### Proof
Every input yields exactly one complete transcript, so transcript sets partition X×Y. The final output is determined by the transcript, hence all inputs yielding the same transcript have the same f-value. By Theorem 80 each transcript set is a rectangle. QED.

## 82. Rectangle-partition lower bound

Let \(\chi(f)\) be the minimum number of monochromatic rectangles in any partition of X×Y. Every deterministic protocol computing f exactly with at most c bits of transcript satisfies
\[
2^c\ge \chi(f),
\qquad
c\ge \lceil \log_2\chi(f)\rceil.
\]

### Proof
A c-bit protocol has at most \(2^c\) possible transcripts. By Theorem 81 these transcripts form a monochromatic rectangle partition. Therefore their number is at least \(\chi(f)\). QED.

## 83. Equality requires two monochromatic rectangles

Let X=Y={0,1}^n and EQ(x,y)=1 iff x=y. Any monochromatic rectangle contained in the 1-inputs contains at most one pair (x,x).

### Proof
Suppose a 1-monochromatic rectangle A×B contains (x,x) and (x',x') with x≠x'. Then x,x'∈A and x,x'∈B, so (x,x')∈A×B. But EQ(x,x')=0, contradiction. QED.

## 84. Deterministic equality requires at least n bits

Any exact deterministic protocol for EQ on n-bit strings has worst-case communication at least n bits.

### Proof
There are \(2^n\) distinct 1-inputs (x,x). By Theorem 83 each requires a distinct 1-monochromatic rectangle. Hence any monochromatic partition has at least \(2^n\) rectangles. Apply Theorem 82. QED.

## 85. Fooling-set lower bound

Let f:X×Y→{0,1}. Suppose F={(x_i,y_i)}_{i=1}^m is a 1-fooling set:
1. f(x_i,y_i)=1 for every i;
2. for every i≠j, at least one of f(x_i,y_j), f(x_j,y_i) equals 0.

Then every exact deterministic protocol for f uses at least \(\lceil\log_2m\rceil\) bits.

### Proof
No 1-monochromatic rectangle can contain two distinct fooling-set elements, because if it contained (x_i,y_i) and (x_j,y_j), rectangularity would force both cross-pairs into it, contradicting condition 2. Hence at least m distinct 1-rectangles are needed. Apply Theorem 82. QED.

## 86. Deterministic protocol transcripts are semantic quotients of input state

For exact f, define input equivalence
\[
(x,y)\sim_\tau(x',y')
\iff
\text{the protocol produces the same transcript}.
\]
Then f factors through the quotient \((X×Y)/{\sim_\tau}\).

### Proof
By exactness, equal transcripts imply equal outputs. Hence f is constant on each equivalence class and therefore factors through the quotient. QED.

## 87. Every protocol quotient refines the canonical task quotient

Define the canonical task equivalence
\[
u\sim_f v\iff f(u)=f(v).
\]
For any exact deterministic protocol,
\[
u\sim_\tau v\implies u\sim_f v.
\]

### Proof
Same transcript implies same protocol output, which equals f on both inputs. QED.

Thus protocol transcripts may reveal strictly more than the minimum semantics required by the task.

## 88. Transcript privacy criterion

An exact deterministic protocol reveals no information beyond the task value at the purely extensional level iff
\[
u\sim_\tau v \iff u\sim_f v.
\]

### Proof
The protocol quotient always refines the task quotient by Theorem 87. Equality of equivalence relations is exactly equality of the induced quotients. QED.

## 89. Nondeterministic certificates correspond to rectangle covers

Let f:X×Y→{0,1}. Suppose a prover supplies a certificate w and Alice/Bob can verify acceptance using no communication beyond knowing w, with Alice checking predicate A_w(x) and Bob checking B_w(y). Then each certificate accepts the rectangle
\[
R_w=\{x:A_w(x)=1\}\times\{y:B_w(y)=1\}.
\]
Soundness makes \(R_w\subseteq f^{-1}(1)\); completeness says the rectangles cover \(f^{-1}(1)\).

### Proof
Acceptance for certificate w occurs exactly when both local predicates hold, which is a Cartesian product. Soundness and completeness give containment and covering. QED.

## 90. Certificate-cover lower bound

If every certificate has at most c bits, then at most \(2^c\) certificate rectangles exist. Therefore if the minimum 1-rectangle cover number is \(C_1(f)\),
\[
c\ge \lceil\log_2 C_1(f)\rceil.
\]

### Proof
At most one verifier rectangle per certificate string; completeness requires a cover. QED.

## 91. Local pairwise differences form a Čech 1-cocycle

Let \(\{U_i\}\) be a cover and let \(\mathcal A\) be a sheaf of abelian groups. Suppose local sections \(s_i\in\mathcal A(U_i)\) are given. Define on overlaps
\[
d_{ij}=s_j|_{U_{ij}}-s_i|_{U_{ij}}.
\]
Then on every triple overlap \(U_{ijk}\),
\[
d_{ij}+d_{jk}+d_{ki}=0.
\]

### Proof
On \(U_{ijk}\),
\[
(s_j-s_i)+(s_k-s_j)+(s_i-s_k)=0.
\]
QED.

## 92. Vanishing difference cocycle is equivalent to exact gluing after local corrections

With the setup of Theorem 91, suppose there exist local corrections \(t_i\in\mathcal A(U_i)\) such that
\[
d_{ij}=t_j-t_i
\]
on every overlap. Then corrected sections
\[
s_i'=s_i-t_i
\]
agree on every overlap and therefore glue uniquely to a global section if \(\mathcal A\) is a sheaf.

Conversely, if there exist corrections \(t_i\) such that the corrected sections glue, then \(d_{ij}=t_j-t_i\).

### Proof
If d_{ij}=t_j-t_i, then
\[
s_j'-s_i'
=(s_j-t_j)-(s_i-t_i)
=d_{ij}-(t_j-t_i)=0.
\]
The sheaf gluing axiom gives a unique global section. Conversely, overlap equality of corrected sections rearranges to \(d_{ij}=t_j-t_i\). QED.

Thus the obstruction to correction-and-gluing is exactly the cohomology class of the 1-cocycle.

## 93. Graph synchronization theorem for additive offsets

Let G=(V,E) be a connected graph. Each oriented edge i→j carries \(d_{ij}\in A\) for an abelian group A, with \(d_{ji}=-d_{ij}\). There exist vertex potentials \(t_i\in A\) satisfying
\[
d_{ij}=t_j-t_i
\]
for every edge iff the sum of d around every cycle is zero.

### Proof
Necessity telescopes around cycles.

For sufficiency choose root r and set t_r=0. For each vertex v choose any path r=v_0,…,v_k=v and define
\[
t_v=\sum_{\ell=0}^{k-1} d_{v_\ell v_{\ell+1}}.
\]
Zero cycle sums imply path-independence: two paths together form a closed walk whose total is zero. For an edge i→j, compare a root-to-i path followed by that edge with a root-to-j path to obtain \(t_j=t_i+d_{ij}\). QED.

## 94. Spanning-tree data plus cycle obstructions is complete

For connected finite G, choose a spanning tree T. Arbitrary edge labels on T uniquely determine vertex potentials up to an additive global constant. For each non-tree edge e, the unique fundamental cycle created by e contributes one obstruction value; all edge labels arise from potentials iff every such obstruction vanishes.

### Proof
Tree paths from a root uniquely define potentials. Each non-tree edge must agree with the potential difference already induced along the tree path; this is equivalent to zero sum around its fundamental cycle. Fundamental cycles form a basis of the cycle space, so these conditions are complete. QED.

## 95. Multiplicative synchronization theorem

Let G be connected and edge labels \(g_{ij}\) lie in a group H with \(g_{ji}=g_{ij}^{-1}\). Suppose H is not necessarily abelian. There exist vertex labels \(h_i\in H\) such that
\[
g_{ij}=h_jh_i^{-1}
\]
for every oriented edge iff the ordered product of edge labels around every directed cycle equals the identity.

### Proof
Necessity telescopes:
\[
(h_1h_0^{-1})(h_2h_1^{-1})\cdots(h_0h_{k-1}^{-1})=e.
\]
For sufficiency choose root r, set h_r=e, and define h_v as the ordered product along any root-to-v path. Cycle-triviality gives path-independence. The edge relation follows by extending a path to i by edge i→j. QED.

## 96. Gauge redundancy of synchronized potentials

Under Theorem 95, if \(\{h_i\}\) is a solution, then for any fixed \(k\in H\),
\[
h_i' = h_i k
\]
gives the same edge labels:
\[
h_j'(h_i')^{-1}=h_jh_i^{-1}.
\]

### Proof
\[
(h_jk)(h_ik)^{-1}=h_jkk^{-1}h_i^{-1}=h_jh_i^{-1}.
\]
QED.

Thus local potentials are determined only up to a global right action: the edge observables are gauge-invariant.

## 97. Cycle holonomy is a complete obstruction to graph gluing

In the group-valued graph problem, define holonomy of a cycle γ as the ordered edge product Hol(γ). A global vertex potential exists iff
\[
\mathrm{Hol}(\gamma)=e
\]
for every cycle γ.

### Proof
Theorem 95. QED.

## 98. Direct revelation principle

Consider any mechanism with type profile \(\theta=(\theta_i)\), strategy spaces S_i, outcome rule g(s), and equilibrium strategy profile \(s_i^*(\theta_i)\) implementing outcome
\[
f(\theta)=g(s^*(\theta)).
\]
Define a direct mechanism in which agents report \(\hat\theta_i\) and the mechanism chooses
\[
\tilde g(\hat\theta)=g(s_1^*(\hat\theta_1),\dots,s_n^*(\hat\theta_n)).
\]
Then truthful reporting is an equilibrium of the direct mechanism and implements f.

### Proof
Fix agent i with true type \(\theta_i\) and truthful reports by others. Reporting \(\hat\theta_i\) in the direct mechanism induces exactly the original-mechanism strategy \(s_i^*(\hat\theta_i)\), while truthful reporting induces \(s_i^*(\theta_i)\). Since \(s_i^*(\theta_i)\) is a best response in the original equilibrium against \(s_{-i}^*(\theta_{-i})\), no misreport improves utility. QED.

## 99. Verification-restricted revelation principle

Suppose reports must satisfy a verifiable feasibility relation
\[
V_i(\theta_i,\hat\theta_i)=1.
\]
If an indirect mechanism has equilibrium strategies \(s_i^*(\theta_i)\) implementable only through reports satisfying V, then the direct mechanism of Theorem 98 may restrict agent i's report set to
\[
F_i(\theta_i)=\{\hat\theta_i:V_i(\theta_i,\hat\theta_i)=1\}
\]
without changing the implemented equilibrium outcome.

### Proof
The truthful report is feasible by assumption. Any infeasible deviation was unavailable in the original verified mechanism, so deleting it changes no feasible best-response comparison. The revelation-principle argument then applies on the restricted report set. QED.

## 100. Groves truthfulness theorem

Let agents have quasi-linear utility
\[
u_i(a,p_i;\theta_i)=v_i(a,\theta_i)-p_i.
\]
Let the social choice rule choose
\[
a^*(\hat\theta)\in\arg\max_a \sum_j v_j(a,\hat\theta_j).
\]
For arbitrary functions \(h_i(\hat\theta_{-i})\), define payments
\[
p_i(\hat\theta)
=
h_i(\hat\theta_{-i})
-
\sum_{j\ne i} v_j(a^*(\hat\theta),\hat\theta_j).
\]
Then truthful reporting is a dominant strategy.

### Proof
Fix reports \(\hat\theta_{-i}\) of others and true \(\theta_i\). Under report r_i, agent i's utility is
\[
v_i(a^*(r_i,\hat\theta_{-i}),\theta_i)
+\sum_{j\ne i}v_j(a^*(r_i,\hat\theta_{-i}),\hat\theta_j)
-h_i(\hat\theta_{-i}).
\]
The final term is independent of r_i. Truthful report \(r_i=\theta_i\) makes \(a^*\) maximize exactly the preceding sum over a, so no alternative report can yield higher utility. QED.

## 101. VCG pivot payment internalizes externality

Under the Groves mechanism choose
\[
h_i(\theta_{-i})=\max_a\sum_{j\ne i}v_j(a,\theta_j).
\]
Then
\[
p_i
=
\max_a\sum_{j\ne i}v_j(a,\theta_j)
-
\sum_{j\ne i}v_j(a^*(\theta),\theta_j).
\]
This equals the welfare loss agent i imposes on the other agents relative to their optimum without i.

### Proof
Immediate from the definition: first term is others' best achievable welfare when i is ignored; second is their welfare at the chosen joint optimum. QED.

## 102. First welfare theorem for finite exchange economies

Consider a finite exchange economy with goods vector, consumers i with locally nonsatiated preferences, initial endowments \(\omega_i\), and a competitive equilibrium \((p,x_i)\) with strictly positive price vector p. Then the allocation x is Pareto efficient.

### Proof
Suppose y Pareto dominates x. By local nonsatiation and utility maximization at equilibrium prices, any consumer strictly preferring y_i to x_i must satisfy \(p\cdot y_i>p\cdot x_i\), while weak preference implies \(p\cdot y_i\ge p\cdot x_i\). At least one inequality is strict, so
\[
p\cdot\sum_i y_i > p\cdot\sum_i x_i.
\]
Feasibility gives \(\sum_i y_i\le\sum_i\omega_i\), while market clearing gives \(\sum_i x_i=\sum_i\omega_i\). Positive prices imply
\[
p\cdot\sum_i y_i\le p\cdot\sum_i\omega_i=p\cdot\sum_i x_i,
\]
contradiction. QED.

## 103. Competitive prices are sufficient coordination statistics for individual budget choice

At a competitive equilibrium with price vector p, consumer i's optimization uses other agents' states only through p and i's own budget \(p\cdot\omega_i\):
\[
x_i\in \arg\max_{x} u_i(x)\quad \text{s.t. }p\cdot x\le p\cdot\omega_i.
\]

### Proof
This is the definition of competitive equilibrium. Once p and own endowment are fixed, the individual optimization problem contains no other agents' utility functions or endowments. QED.

The equilibrium price vector therefore acts as a compressed interface through which dispersed information influences each local choice.

## 104. Price sufficiency does not imply reconstructibility of private states

There can exist distinct profiles of preferences/endowments producing the same equilibrium price vector p. Hence p may be sufficient for decentralized local optimization while being non-injective as an observation of the underlying economy.

### Proof
Example: one-good economy. Any strictly increasing preferences and any positive endowment profile produce the same normalized scalar price p=1. The private states can vary arbitrarily while price remains fixed. QED.

Thus an interface can be decision-sufficient while intentionally non-reconstructive.

## 105. Outcome sufficiency and state privacy are compatible

Let T(X) be an interface such that desired action C=f(X) factors through T, but T is non-injective. Then C is exactly computable from T while residual state uncertainty
\[
H(X\mid T)>0
\]
may remain.

### Proof
Factorization gives exact outcome sufficiency. Non-injectivity allows distinct hidden states with identical T; under any distribution placing positive probability on at least two such states, conditional entropy is positive on that fiber. QED.

## 106. Minimal exact interface maximizes hidden-fiber freedom among exact deterministic interfaces

Let q:X→Q be the canonical task quotient for a family \(\mathcal F\). Any exact deterministic interface T factors as
\[
q=r\circ T.
\]
Therefore every T-fiber lies inside a q-fiber:
\[
T^{-1}(t)\subseteq q^{-1}(r(t)).
\]

### Proof
If T(x)=t then q(x)=r(t); hence every point of the T-fiber lies in that q-fiber. QED.

Thus q identifies at least as many hidden states as any other exact interface; it is maximally coarse and therefore maximally permissive of hidden implementation variation.

## 107. Verification can convert strategic information into a feasibility constraint

Let type θ determine a predicate P(θ). Suppose an outcome rule needs only the truth value c=P(θ). Without verification an agent may strategically report c. With a sound-complete proof system accepting exactly true c=1 claims, the action “claim c=1” is feasible iff P(θ)=1.

### Proof
Soundness excludes false positive claims; completeness permits every true positive claim. Therefore the report dimension is no longer unrestricted strategic cheap talk: its feasible set is type-dependent and coincides with truth for the certified predicate. QED.

## 108. Residual incentive problem after verification

Let A_i(θ_i) be the action set remaining after all verifiable predicates are enforced. Any incentive-compatibility condition needs comparison only among actions inside A_i(θ_i).

### Proof
Infeasible actions cannot occur and therefore cannot be profitable deviations. QED.

## 109. Hard constraints weakly enlarge the set of implementable social choice rules relative to a fixed incentive budget

Fix a class of transfer/payment rules P. Suppose a desired rule f is implementable after verification removes deviations D, but not implementable under P when D remains feasible. Then adding the verification constraint strictly enlarges the implementable set for that fixed P.

### Proof
By hypothesis f belongs to the constrained implementable set but not the unconstrained one. QED.

This is a set-theoretic statement: cryptographic or formal verification can substitute for incentives by deleting deviations before equilibrium conditions are imposed.
