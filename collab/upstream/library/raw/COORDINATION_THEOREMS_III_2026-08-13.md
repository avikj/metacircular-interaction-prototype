# COORDINATION THEOREMS III — CUTS, GLUING, SYNERGY, AND CERTIFICATES
Date: 2026-08-13

Status: exact mathematical lemmas and proofs. No novelty claims.

## 45. Cut-set lower bound on exact distributed computation

Let G=(V,E) be a directed communication network. Partition V=A ⊔ B. Let X_A denote all private inputs initially held in A and X_B all private inputs initially held in B. Let C=f(X_A,X_B) be a target that must be exactly reconstructed by some node in B.

Let M_{A→B} denote the complete collection of messages crossing directed edges from A to B during an arbitrary finite interactive protocol, and let R be public randomness.

Then
H(M_{A→B}|X_B,R) ≥ H(C|X_B,R).

Proof. Condition on X_B,R and all messages M_{A→B}. Every message generated inside B or sent from B to A is recursively determined by B's initial state, public randomness, and previously received messages. Hence the final B-view and therefore C are deterministic functions of (X_B,R,M_{A→B}). Thus H(C|X_B,R,M_{A→B})=0. Therefore
H(C|X_B,R)=I(C;M_{A→B}|X_B,R)≤H(M_{A→B}|X_B,R). QED.

## 46. Edge-capacity cut bound

If each cut edge e carries message M_e with H(M_e)≤c_e, then
Σ_{e∈δ⁺(A)} c_e ≥ H(C|X_B,R).

Proof. H(M_{A→B})≤Σ_e H(M_e)≤Σ_e c_e. Combine with Theorem 45. QED.

## 47. Approximate cut-set lower bound

If B reconstructs finite-valued C with error probability ε, then
H(M_{A→B}|X_B,R) ≥ H(C|X_B,R)-h(ε)-ε log(|C|-1).

Proof. Conditional Fano plus I≤H. QED.

## 48. Internal computation cannot change the cut lower bound

Adding arbitrary local computation inside A or B without changing the cross-cut transcript cannot change the lower bounds above.

Proof. The bounds depend only on residual target entropy and the cross-cut transcript. QED.

## 49. Target information cannot be created by local post-processing

If C→(Y,M)→Z conditional on Y, then
I(C;Z|Y)≤I(C;M|Y).

Proof. Conditional data processing. QED.

## 50. Perfect privacy beyond the target

Let X be private state, Y side information, C=f(X,Y), and transcript M. Assume exact recovery H(C|Y,M)=0. Then
I(X;M|Y)=H(C|Y)+I(X;M|Y,C).
Therefore the following are equivalent:
(i) I(X;M|Y)=H(C|Y);
(ii) I(X;M|Y,C)=0;
(iii) X ⟂ M | (Y,C).

Proof. Chain rule together with determinism of C from (X,Y) and from (Y,M). QED.

## 51. Exact public interface theorem for multiple predicates

For C=(C₁,…,C_k)=F(X,Y), any exact transcript M satisfies
I(X;M|Y)≥H(C|Y),
with equality iff X ⟂ M | (Y,C).

Proof. Theorem 50 applied to vector-valued C. QED.

## 52. Fiber privacy

Under equality in Theorem 51, for every c,y and every x in the fiber F_y^{-1}(c),
P(M|X=x,Y=y)=P(M|C=c,Y=y).

Proof. This is conditional independence. QED.

## 53. Gluing theorem for compatible local functions

Let {U_i} cover U and let s_i:U_i→A satisfy s_i=s_j on every overlap U_i∩U_j. Then there exists a unique s:U→A restricting to each s_i.

Proof. Define s(x)=s_i(x) for any i with x∈U_i. Overlap compatibility gives well-definedness; covering gives existence; restrictions give uniqueness. QED.

## 54. Pairwise satisfiability need not imply global satisfiability

Let bits x,y,z satisfy local constraints
x⊕y=0, y⊕z=0, x⊕z=1.
Every pair of constraints is jointly satisfiable, but all three are not.

Proof. Each pair admits an assignment. The first two imply x=z, contradicting the third. QED.

## 55. Minimal unsatisfiable coalitions are irreducible obstruction hyperedges

If S is minimally unsatisfiable, every proper subset is satisfiable. Therefore no obstruction representation using only satisfiability labels of proper subsets can certify the failure of S.

Proof. All proper-subset labels are positive; the contradiction first appears at S. QED.

## 56. Threshold secret sharing

Let C be uniform in F_q. Choose a random degree <k polynomial
p(t)=C+a₁t+…+a_{k-1}t^{k-1}
and shares W_i=p(α_i) at distinct nonzero α_i.

Then any k shares determine C exactly, while any fewer than k shares are statistically independent of C.

Proof. k evaluations interpolate p. For r<k evaluations and fixed secret c, the linear constraints leave k-1-r free coefficients, giving q^{k-1-r} solutions independent of c. QED.

## 57. Informational hyperedge arity of threshold sharing

In Theorem 56,
I(C;W_S)=0 for |S|<k,
while H(C|W_S)=0 for |S|≥k.

Hence the smallest informative coalition has arity k. QED.

## 58. No bounded-arity dependence formalism is universal

For every k there exists a finite distributed state with a target C such that every coalition of size <k is independent of C while some k-coalition reconstructs C exactly.

Proof. Theorem 56 with n=k. QED.

## 59. Certificate composition over a hypergraph

Let local relations R_α((y_i)_{i∈S_α}) have sound-complete verifiers V_α(...,π_α). Then the conjunction relation has verifier equal to the conjunction of all local verifiers.

Proof. Acceptance is equivalent to acceptance of every local relation. QED.

## 60. Existential hiding preserves verifiability

If R(y,z) has verifier V(y,z,π), then the boundary relation
R̄(y) ⇔ ∃z R(y,z)
has witness (z,π) and verifier V̄(y;(z,π))=V(y,z,π).

Proof. Immediate. QED.

## 61. Recursive existential elimination is order-independent

For finite variables z₁,…,z_m,
∃z₁…∃z_m R(b,z)
is unchanged by permuting the elimination order.

Proof. Finite existential quantifiers commute. QED.

## 62. Boundary semantics is invariant under internal refactoring

If
∃z R₁(b,z) ⇔ ∃w R₂(b,w)
for every boundary value b, then no context interacting only through b can distinguish the two internal systems by admissible boundary behavior.

Proof. Their induced boundary relations are pointwise equal. QED.

## 63. Informational coalition value

Let
v(S)=I(C;W_S|Y)=H(C|Y)-H(C|Y,W_S).
Then v(∅)=0, v is monotone, and 0≤v(S)≤H(C|Y).

Proof. Conditioning reduces entropy. QED.

## 64. Marginal informational contribution

For i∉S,
v(S∪{i})-v(S)=I(C;W_i|Y,W_S).

Proof. Expand the conditional entropies. QED.

## 65. Informational Shapley value

For the game v above,
φ_i = Σ_{S⊆N\{i}} |S|!(n-|S|-1)!/n! · I(C;W_i|Y,W_S).

Equivalently, under a uniformly random ordering Π,
φ_i=E_Π I(C;W_i|Y,W_{Pred_i(Π)}).

Proof. Substitute Theorem 64 into the defining Shapley formula. QED.

## 66. Efficiency

Σ_i φ_i=I(C;W_N|Y).
If W_N reconstructs C exactly, then Σ_i φ_i=H(C|Y).

Proof. Shapley efficiency and exact reconstruction. QED.

## 67. XOR synergy shares equally

Let W₁,…,W_n be independent fair bits and C=W₁⊕…⊕W_n. Then φ_i=1/n bit for every i.

Proof. Symmetry and efficiency. QED.

## 68. Informational coalition games are not universally submodular

For XOR with two shares,
v({1})=v({2})=0, v({1,2})=1,
so submodularity fails. QED.

## 69. Informational coalition games are not universally supermodular

For W₁=W₂=C a fair bit,
v({1})=v({2})=v({1,2})=1,
so supermodularity fails. QED.

## 70. No additive pricing by standalone mutual information

There is no p with p(0)=0 such that universally
I(C;W_N)=Σ_i p(I(C;W_i)).

Proof. Two-share XOR has zero singleton mutual informations but one bit joint information. QED.

## 71. Möbius interaction decomposition

For v on the Boolean lattice, define
m(S)=Σ_{T⊆S}(-1)^{|S|-|T|}v(T).
Then
v(S)=Σ_{T⊆S}m(T).

Proof. Möbius inversion. QED.

## 72. Pure k-way synergy is top-order Möbius mass

If v(S)=0 for every proper S⊊N and v(N)=h, then
m(S)=0 for S⊊N and m(N)=h.

Proof. Möbius inversion recursively. QED.

## 73. Redundancy gives negative higher-order correction

For W₁=W₂=C with H(C)=1,
m({1})=m({2})=1 and m({1,2})=-1.

Proof. m({1,2})=1-1-1=-1. QED.

## 74. Shapley value decomposes interaction coefficients equally

For any finite cooperative game,
φ_i=Σ_{T∋i} m(T)/|T|.

Proof. Decompose v into unanimity games via Möbius inversion and use linearity plus the Shapley value of a unanimity game. QED.

## 75. Output-only rewards cannot recover provenance-sensitive attribution

Let F map derivation DAGs to terminal outputs, and A be an attribution vector. If F(d)=F(d') but A(d)≠A(d'), no map Ā on outputs satisfies A=Ā∘F.

Proof. Equal outputs would force equal attributions. QED.

## 76. Minimal attribution-preserving quotient

Define d~d' iff F(d)=F(d') and A(d)=A(d'). Then D/~ is the coarsest quotient from which both F and A are recoverable.

Proof. Canonical task-interface theorem for {F,A}. QED.

## 77. Compositional refutation certificates

If a proof system has locally checkable inference rules and derives ⊥ from constraints, then a finite derivation tree of ⊥ is globally checkable by verifying every inference edge.

Proof. Induct on the proof tree. QED.

## 78. Minimal unsatisfiable sets are irreducible constraint-level obstructions

If S is minimally unsatisfiable, removal of any member restores satisfiability. Hence every member is necessary for that obstruction.

Proof. Definition. QED.

## 79. Finite SAT has both solution and obstruction certificates at the proof-system level

For Boolean CNF F, satisfiability has a directly checkable assignment certificate. If F is unsatisfiable, propositional resolution completeness gives a finite resolution refutation; each inference is locally checkable.

Proof. Direct verification plus completeness of resolution. QED.
