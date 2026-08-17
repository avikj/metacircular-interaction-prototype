# COORDINATION THEOREMS XVII — FORMAL CONTRACT ALGEBRA AND COMPOSITION
Date: 2026-08-13
Status: exact elementary relation/order-theoretic lemmas; no novelty claims.

## 456. Contract refinement order
For relations R,S⊆X×Y define
\[
R\preceq S \iff R\subseteq S.
\]
Interpret R as stronger/more restrictive than S. Then \(\preceq\) is a partial order.

Proof. Set inclusion is reflexive, antisymmetric, transitive. QED.

## 457. Conjunction is meet in refinement order
For contracts R,S,
\[
R\wedge S=R\cap S
\]
is their greatest lower bound under inclusion.

Proof. Intersection is contained in each; any T contained in both is contained in their intersection. QED.

## 458. Disjunction is join in refinement order
\[
R\vee S=R\cup S
\]
is least upper bound.

Proof. Union contains each; any U containing both contains their union. QED.

## 459. Contract space is a complete Boolean algebra
The powerset \(\mathcal P(X\times Y)\), ordered by inclusion, has arbitrary meets as intersections, joins as unions, bottom ∅, top X×Y, and complement relative to X×Y.

Proof. Standard powerset Boolean algebra. QED.

## 460. Sequential composition is monotone in both arguments
If
\[
R_1\subseteq R_2,\qquad S_1\subseteq S_2,
\]
then
\[
S_1\circ R_1\subseteq S_2\circ R_2.
\]

Proof. Any witness y satisfying R₁ and S₁ also satisfies R₂ and S₂. QED.

## 461. Parallel composition is monotone
Under the same inclusions,
\[
R_1\otimes S_1\subseteq R_2\otimes S_2.
\]

Proof. Product relation membership is conjunction of component memberships. QED.

## 462. Sequential composition distributes over arbitrary unions
For relation S and family {R_i},
\[
S\circ\left(\bigcup_iR_i\right)
=
\bigcup_i(S\circ R_i),
\]
and similarly
\[
\left(\bigcup_iS_i\right)\circ R
=
\bigcup_i(S_i\circ R).
\]

Proof. Existential witness plus membership in a union:
\[
\exists y[(\exists i\,R_i(x,y))\wedge S(y,z)]
\iff
\exists i\exists y[R_i(x,y)\wedge S(y,z)].
\]
QED.

## 463. Sequential composition need not distribute over intersection
In general
\[
S\circ(R_1\cap R_2)
\subsetneq
(S\circ R_1)\cap(S\circ R_2).
\]

Proof. Inclusion is monotonicity. Strict example: X={x}, Y={a,b}, Z={z}; R₁={(x,a)}, R₂={(x,b)}, S={(a,z),(b,z)}. Left side empty because R₁∩R₂ empty; each right composite contains (x,z), so intersection does too. QED.

The failure occurs because the two right-hand witnesses may be different intermediates.

## 464. Deterministic intermediate semantics restores intersection distribution
If S:Y→Z is an injective function viewed as relation, then
\[
S\circ(R_1\cap R_2)
=
(S\circ R_1)\cap(S\circ R_2).
\]

Proof. One inclusion is general. For reverse inclusion, if (x,z) belongs to both right composites, there exist y₁,y₂ with R₁(x,y₁),R₂(x,y₂), and S(y₁)=z=S(y₂). Injectivity gives y₁=y₂=y, so y witnesses membership in R₁∩R₂. QED.

## 465. Right composition by a deterministic function preserves unions but not necessarily intersections
Let f:X→Y and relations S₁,S₂:Y↝Z. Then
\[
(S_1\cap S_2)\circ f
=
(S_1\circ f)\cap(S_2\circ f).
\]

Proof. For each x the unique intermediate is f(x), so both sides say \(S_1(f(x),z)\wedge S_2(f(x),z)\). QED.

## 466. Converse reverses composition and preserves refinement
If R⊆S, then
\[
R^\dagger\subseteq S^\dagger.
\]
Also
\[
(S\circ R)^\dagger=R^\dagger\circ S^\dagger.
\]

Proof. Pair reversal preserves inclusion; composition identity proved earlier. QED.

## 467. Domain and range as existential projections
For R⊆X×Y define
\[
\mathrm{dom}(R)=\{x:\exists yR(x,y)\},
\quad
\mathrm{ran}(R)=\{y:\exists xR(x,y)\}.
\]
Then
\[
\mathrm{dom}(R)=R^\dagger\circ R
\]
on identities only in the sense that x belongs to dom(R) iff \((x,x)\in R^\dagger\circ R\).

Proof.
\[
(x,x)\in R^\dagger\circ R
\iff \exists y\,R(x,y)\wedge R^\dagger(y,x)
\iff \exists y\,R(x,y).
\]
QED.

## 468. Totality and functionality as relational inequalities
Let \(I_X\) be identity relation.
R is total iff
\[
I_X\subseteq R^\dagger\circ R.
\]
R is functional iff
\[
R\circ R^\dagger\subseteq I_Y.
\]

Proof. First is Theorem 467 for every x. For functionality, \((y,y')\in R\circ R^\dagger\) iff some x relates to both y and y'; inclusion in identity says y=y'. QED.

## 469. Bijections are unitary relations
A relation R is graph of a bijection iff
\[
R^\dagger\circ R=I_X,
\qquad
R\circ R^\dagger=I_Y.
\]

Proof. Equalities give totality+injectivity on one side and surjectivity+functionality on the other; conversely a bijection has inverse relation exactly R†. QED.

## 470. Refinement shrinks implementation fibers
If R⊆S, then for every x,
\[
R(x)\subseteq S(x).
\]

Proof. Pointwise set inclusion. QED.

## 471. Refinement can only increase search difficulty under brute-force uniform search
Let finite candidate universe Y have size N. Suppose valid fibers satisfy nonempty \(R(x)\subseteq S(x)\). Uniform independent sampling from Y has one-shot success probabilities
\[
p_R=|R(x)|/N,\qquad p_S=|S(x)|/N,
\]
so \(p_R\le p_S\), and expected geometric trials \(1/p_R\ge1/p_S\).

Proof. Fiber inclusion gives cardinality inequality. Geometric expectation is reciprocal success probability. QED.

This is only a statement about uniform sampling, not general computational complexity.

## 472. Refinement can simplify verification while shrinking search space
There exist R⊂S where R has a simpler verifier than S under a chosen representation.

Proof. Let Y be bit strings, R={0^n}, verified by equality to zero; let S encode membership in any arbitrarily complicated explicitly given finite subset containing 0^n. Search fiber is larger for S, but its represented membership test may be larger/more complex. QED.

Thus search freedom and verifier complexity are independent axes.

## 473. Contract implication is refinement
For predicates R,S,
\[
\forall x,y,\ R(x,y)\Rightarrow S(x,y)
\iff
R\subseteq S.
\]

Proof. Predicate implication is exactly set inclusion of satisfying pairs. QED.

## 474. Precondition restriction
For predicate P⊆X define
\[
P\triangleright R=\{(x,y):P(x)\wedge R(x,y)\}.
\]
Then
\[
P\triangleright R\subseteq R.
\]

Proof. Conjunction implies R. QED.

## 475. Postcondition restriction
For Q⊆Y define
\[
R\triangleleft Q=\{(x,y):R(x,y)\wedge Q(y)\}.
\]
Then
\[
R\triangleleft Q\subseteq R.
\]

Proof. Immediate. QED.

## 476. Hoare-style relational composition rule
Suppose relations R:X↝Y and S:Y↝Z satisfy:
\[
P(x)\wedge R(x,y)\Rightarrow Q(y),
\]
\[
Q(y)\wedge S(y,z)\Rightarrow T(z).
\]
Then
\[
P(x)\wedge(S\circ R)(x,z)\Rightarrow T(z).
\]

Proof. Composite validity gives y with R(x,y),S(y,z). P and first implication give Q(y); second gives T(z). QED.

## 477. Strongest postcondition
For P⊆X and relation R define
\[
\mathrm{SP}_R(P)
=
\{y:\exists x\in P,\ R(x,y)\}.
\]
Then SP_R(P) is the smallest postcondition Q satisfying
\[
P(x)\wedge R(x,y)\Rightarrow Q(y).
\]

Proof. It satisfies the implication by definition. Any Q satisfying it contains every y reachable from some x∈P, hence contains SP_R(P). QED.

## 478. Weakest liberal precondition
For Q⊆Y define
\[
\mathrm{WLP}_R(Q)
=
\{x:\forall y,\ R(x,y)\Rightarrow y\in Q\}.
\]
Then WLP_R(Q) is the largest P satisfying
\[
P(x)\wedge R(x,y)\Rightarrow Q(y).
\]

Proof. Every x in WLP has all R-successors in Q, so implication holds. Any P satisfying implication consists only of such x, hence P⊆WLP. QED.

## 479. Strongest postcondition composes covariantly
\[
\mathrm{SP}_{S\circ R}
=
\mathrm{SP}_S\circ\mathrm{SP}_R
\]
as maps on subsets.

Proof.
\[
z\in SP_{S\circ R}(P)
\iff \exists x\in P,\exists y\,R(x,y)S(y,z)
\iff z\in SP_S(SP_R(P)).
\]
QED.

## 480. Weakest liberal precondition composes contravariantly
\[
\mathrm{WLP}_{S\circ R}
=
\mathrm{WLP}_R\circ\mathrm{WLP}_S.
\]

Proof.
x belongs to left iff every z reachable through some intermediate y satisfies T; equivalently every R-successor y has all S-successors in T, i.e. y∈WLP_S(T), hence x∈WLP_R(WLP_S(T)). QED.

## 481. SP preserves arbitrary unions
\[
SP_R\left(\bigcup_iP_i\right)=\bigcup_iSP_R(P_i).
\]

Proof. Existential quantification distributes over union. QED.

## 482. WLP preserves arbitrary intersections
\[
WLP_R\left(\bigcap_iQ_i\right)=\bigcap_iWLP_R(Q_i).
\]

Proof. “All successors lie in every Q_i” iff for every i all successors lie in Q_i. QED.

## 483. SP and WLP form a Galois connection
For P⊆X,Q⊆Y,
\[
SP_R(P)\subseteq Q
\iff
P\subseteq WLP_R(Q).
\]

Proof. Both statements expand to
\[
\forall x\in P,\forall y,\ R(x,y)\Rightarrow y\in Q.
\]
QED.

This is an exact algebraic bridge between forward reachable behavior and backward admissibility conditions.

## 484. Verification conditions can be propagated backward compositionally
Given terminal safety set T⊆Z and composite S∘R, the largest initial-state set guaranteeing every composite outcome lies in T is
\[
WLP_R(WLP_S(T)).
\]

Proof. Theorems 478 and 480. QED.

## 485. Reachability can be propagated forward compositionally
Given initial set P, all possible outputs after R then S are exactly
\[
SP_S(SP_R(P)).
\]

Proof. Theorem 479. QED.

Thus relational contracts support exact bidirectional reasoning: forward possibility and backward safety.
