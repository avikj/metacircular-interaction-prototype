# COORDINATION THEOREMS XXII — COMPOSITIONAL VALUE, BRIDGE RESULTS, AND REACHABILITY
Date: 2026-08-13
Status: exact graph/set-function lemmas; no novelty claims.

## 591. Reachability value of a new edge
Let G=(V,E) be directed and S⊆V initial known/reachable nodes. Let R_G(S) be vertices reachable from S. Add edge e=(u,v). If u∉R_G(S), reachability does not change. If u∈R_G(S), newly reachable nodes are
\[
R_{G+e}(S)\setminus R_G(S)
=
R_G(v)\setminus R_G(S)
\]
where R_G(v) denotes nodes reachable from v in G, provided v itself was previously unreachable; more generally the new set is the subset of R_G(v) not already reachable.

Proof. Any new path using e must first reach u, traverse e, then follow an old G-path from v. Conversely every old path from v becomes available after reaching u and traversing e. QED.

## 592. Bridge edge value can be arbitrarily larger than one
For every N there is a graph where adding one edge increases reachable-node count by N.

Proof. Let S reach u; let v be root of a directed chain/tree containing N unreachable nodes; add u→v. All N become reachable. QED.

## 593. Edge value depends on current knowledge state
The same edge e can have positive reachability gain from source set S and zero gain from source set T.

Proof. Choose T that already reaches v's downstream region, while S does not but reaches u. Then adding u→v helps S but adds nothing for T. QED.

Thus result value is state-relative.

## 594. Redundant bridge has zero marginal reachability value
If v∈R_G(S), adding any edge u→v with u reachable adds no vertices.

Proof. Everything reachable from v is already reachable because v is. QED.

## 595. Two individually useless edges can be jointly valuable
There exist e₁,e₂ with zero individual reachability gain but positive joint gain.

Proof. Let S reach a. Let e₁=b→c and e₂=a→b, with c leading to new region. e₁ alone is useless because b unreachable. e₂ alone may reach only b (choose value metric counting a target region excluding b), while together reach c/region. For raw node-count gain e₂ has gain one, so instead define target set T={c}; then each alone yields zero target reachability, pair yields one. QED.

## 596. Reachability of designated targets is a monotone set function of added edges
Fix candidate edge set E_c and target set T. Define
\[
v(F)=|R_{G+F}(S)\cap T|.
\]
Then F⊆F' implies v(F)≤v(F').

Proof. Adding edges cannot destroy existing directed paths. QED.

## 597. Target reachability value need not be submodular
There exist candidate edges e₁,e₂ with
\[
v(\{e_1\})-v(\emptyset)
<
v(\{e_1,e_2\})-v(\{e_2\}).
\]

Proof. Let S={a}, target {c}, candidate edges e₂=a→b and e₁=b→c, with no other paths. e₁ alone gives zero; e₂ alone gives zero target; together give one. Thus marginal of e₁ rises from 0 to1. QED.

Bridge results can be complementary.

## 598. Target reachability value can also exhibit redundancy
Let S reach a and candidate edges e₁=a→c,e₂=a→c' where both c,c' lead to same single target t. Then each edge alone reaches t and adding the second after the first gives zero additional target value.

Proof. Direct path construction. QED.

Thus theorem/result portfolios can contain both complementarity and substitutability.

## 599. Shapley attribution applies to reachability value
For finite candidate results N and value
\[
v(S)=|R_{G+S}(K)\cap T|-|R_G(K)\cap T|,
\]
the Shapley value of result i equals its expected marginal number of newly reachable targets when results are inserted in random order.

Proof. This is the random-order characterization of the Shapley value applied to v. QED.

## 600. A result with zero standalone value may have positive Shapley value
In the complementary two-edge construction of Theorem 597, both edges have positive Shapley value 1/2 for one target despite zero standalone target value.

Proof. In either random ordering, the second inserted edge creates the target and receives marginal 1; each edge is second with probability 1/2. QED.

## 601. A universally redundant result has zero Shapley value
If
\[
v(S\cup\{i\})=v(S)
\]
for every S not containing i, then \(\phi_i=0\).

Proof. Every marginal term in the Shapley formula is zero. QED.

## 602. Equivalence result can transfer an entire reachable region
Suppose theory regions A,B are connected by a verified equivalence functor/translation F that maps every theorem in A to a theorem in B and has inverse on the relevant class. Once F is available, every already-certified theorem in A has a certified translated counterpart in B, subject to verification of the translation rules.

Proof. Apply F to each theorem/proof object; inverse/equivalence preserves the designated theorem semantics by hypothesis. QED.

## 603. Compression value of an abstraction
Suppose k artifacts each contain an identical derivation fragment of description length L. Introduce a named verified abstraction a of description length L plus references of length r per use. If references replace full copies, total description changes from kL to
\[
L+kr.
\]
Savings are
\[
(k-1)L-kr.
\]

Proof. Subtract. QED.

## 604. Abstraction becomes description-length beneficial after a reuse threshold
Under Theorem 603, savings are positive iff
\[
k(L-r)>L,
\]
equivalently for L>r,
\[
k>\frac{L}{L-r}.
\]

Proof. Rearrange positivity inequality. QED.

## 605. A concept can be valuable without proving any new extensional theorem
A conservative definitional extension can reduce total corpus description length while leaving the old-language theorem set unchanged.

Proof. Theorem 515 gives unchanged theorem set; Theorems 603–604 give possible compression. QED.

## 606. Tool value can exceed direct theorem value
Suppose tool T costs C once and reduces cost of each of k future derivations by Δ>0. Net work saving is
\[
k\Delta-C.
\]
For sufficiently large k this is positive and unbounded linearly in k.

Proof. Arithmetic. QED.

## 607. Verification-tool value can be measured by newly certifiable artifacts
Let U be a set of candidate artifacts and V,V' two verifiers with accepted-valid subsets A⊆A'. The incremental certification reach is
\[
|A'\setminus A|.
\]

Proof. Definition. QED.

## 608. Stronger verifier can reduce accepted set while increase correctness guarantees
If verifier V' checks predicate R'⊂R checked by V, then accepted semantic set shrinks, but every accepted artifact satisfies the stronger property.

Proof. Refinement inclusion. QED.

Thus verifier “strength” is not monotone in throughput.

## 609. Research frontier as minimal missing edges
Let target t be unreachable from current K in directed dependency graph. A missing edge e is frontier-critical for t if adding e makes t reachable. Then every path to t in G+e that was absent in G must use e.

Proof. If there were a new t-path not using e, it would already exist in G. QED.

## 610. Minimal cut of missing dependencies
Let known graph include potential missing edges with costs. Any set F whose addition makes target t reachable contains at least one complete path from K to t. Minimum-cost enabling set is therefore a shortest-path problem when candidate edges are independent and edge costs add.

Proof. Reachability requires a path; cost of enabling a path is sum of its missing-edge costs. Minimizing over paths gives shortest path. QED.

## 611. Shared lemmas turn multi-target research planning into a Steiner-type problem
For multiple targets T, choosing missing edges of minimum total cost so every target becomes reachable can be cheaper than independently choosing a shortest path to each target because paths may share edges.

Proof. Example: one costly bridge e reaches a branching node leading cheaply to two targets. Paying e once serves both, while independent accounting would count it twice. QED.

The combinatorial optimization is structurally a directed Steiner-network problem under suitable graph assumptions.

## 612. Marginal value of a lemma can rise after another lemma
Complementary dependency edges yield increasing marginal reachability, as in Theorem 597.

Proof. Direct. QED.

Hence greedy ranking by current marginal value can miss jointly transformative result sets.

## 613. Marginal value of a lemma can fall after another lemma
Redundant alternative paths yield decreasing marginal reachability, as in Theorem 598.

Proof. Direct. QED.

## 614. No context-free scalar theorem importance can represent all downstream states
Suppose value of result e is defined as marginal reachability gain. There exist knowledge states K₁,K₂ for which the same e has different marginal gains. Therefore no scalar depending only on e equals its marginal value in every state.

Proof. Theorem 593. QED.

## 615. State-dependent theorem value is a function on pairs
The natural marginal value object is
\[
V(e;K)=v(K\cup\{e\})-v(K),
\]
not merely V(e).

Proof. Definition forced by Theorem 614 if value means marginal change. QED.

## 616. Representation changes can have multiplicative downstream value
Suppose translation F reduces cost of each of k operations from c_i to c_i' and costs C to establish. Net saving is
\[
\sum_{i=1}^k(c_i-c_i')-C.
\]

Proof. Compare total costs with and without F. QED.

## 617. A bridge theorem can dominate a terminal theorem under reachability value
There exist graphs where proving terminal target t adds one reachable target, while proving bridge e makes N>1 valuable targets reachable.

Proof. Construct bridge to a region containing N targets; terminal theorem adds only itself. QED.

Thus difficulty/prestige and structural value are mathematically independent in this model.

## 618. Obstruction theorem can have positive value by pruning impossible search
Let search space contain N candidate branches each cost c, and obstruction theorem rules out k branches at cost C. If without obstruction all branches would otherwise be explored, saved work is
\[
kc-C.
\]

Proof. Arithmetic. QED.

## 619. Negative result can dominate positive local result in saved-work value
Choose k large enough that kc-C exceeds the downstream benefit assigned to any fixed local positive result.

Proof. Since kc-C grows linearly in k. QED.

## 620. Certified impossibility changes the feasible-set quotient
If theorem proves no object in subset U can satisfy relation R, the candidate search domain may be replaced by X\U without losing any valid witness.

Proof. By theorem, \(R\cap U=\emptyset\). Therefore every R-witness lies in complement. QED.

This makes obstruction a first-class semantics-preserving search transformation.
