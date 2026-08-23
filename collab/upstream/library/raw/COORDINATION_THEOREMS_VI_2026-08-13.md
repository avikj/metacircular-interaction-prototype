# COORDINATION THEOREMS VI — PETRI NETS, RESOURCE INVARIANTS, QUORUMS, AND BYZANTINE THRESHOLDS
Date: 2026-08-13

Status: exact mathematical lemmas and proofs. No novelty claims.

## 140. Petri-net firing equation

Let a Petri net have finite place set P and transition set T. Let
\[
\mathrm{Pre},\mathrm{Post}\in \mathbb N^{P\times T}
\]
and incidence matrix
\[
C=\mathrm{Post}-\mathrm{Pre}\in\mathbb Z^{P\times T}.
\]
A marking is \(m\in\mathbb N^P\). If transition t is enabled at m and fires, then
\[
m'=m+C e_t,
\]
where \(e_t\) is the t-th standard basis vector.

### Proof
Firing subtracts \(\mathrm{Pre}(:,t)\) and adds \(\mathrm{Post}(:,t)\):
\[
m'=m-\mathrm{Pre}(:,t)+\mathrm{Post}(:,t)=m+C e_t.
\]
QED.

## 141. Firing-sequence state equation

If a firing sequence \(\sigma=t_1\cdots t_k\) is executable from m and has Parikh/count vector
\[
y=\sum_{j=1}^k e_{t_j}\in\mathbb N^T,
\]
then the final marking is
\[
\boxed{m'=m+Cy.}
\]

### Proof
Iterate Theorem 140:
\[
m'=m+\sum_j C e_{t_j}=m+C\sum_j e_{t_j}=m+Cy.
\]
QED.

Thus terminal marking depends on transition multiplicities through C, though executability can still depend on order.

## 142. Place invariants are conserved quantities

Let \(w\in\mathbb Z^P\) satisfy
\[
w^\top C=0.
\]
Then every executable firing sequence conserves
\[
w^\top m.
\]

### Proof
By Theorem 141,
\[
w^\top m'=w^\top m+w^\top Cy=w^\top m.
\]
QED.

## 143. Positive place invariants bound reachable resource states

If \(w\in\mathbb N^P\) has strictly positive entries and \(w^\top C=0\), then every reachable marking m' satisfies
\[
w^\top m'=w^\top m_0.
\]
In particular each coordinate is bounded:
\[
m'_p\le \frac{w^\top m_0}{w_p}.
\]

### Proof
Conservation is Theorem 142. Since all marking coordinates are nonnegative,
\[
w_p m'_p\le \sum_q w_qm'_q=w^\top m_0.
\]
QED.

## 144. Transition invariants generate state-neutral cycles

If \(y\in\mathbb N^T\) satisfies
\[
Cy=0
\]
and there exists an executable firing sequence with Parikh vector y from m, then the sequence returns to m.

### Proof
Theorem 141 gives \(m'=m+Cy=m\). QED.

## 145. Strongly independent Petri transitions commute

Let transitions t,u satisfy
\[
m\ge \mathrm{Pre}(:,t)+\mathrm{Pre}(:,u)
\]
coordinatewise. Then both orders tu and ut are executable from m and yield the same marking
\[
m+C e_t+C e_u.
\]

### Proof
After firing t,
\[
m_t=m-\mathrm{Pre}_t+\mathrm{Post}_t
\ge \mathrm{Pre}_u+\mathrm{Post}_t
\ge \mathrm{Pre}_u,
\]
so u remains enabled. Symmetrically t remains enabled after u. The final marking in either order is the additive incidence update
\[
m+C e_t+C e_u.
\]
QED.

## 146. Resource contention is exactly failure of joint enabling for locally enabled transitions

It is possible that t and u are each individually enabled at m while
\[
m\not\ge \mathrm{Pre}_t+\mathrm{Pre}_u.
\]
Then the pair competes for some token/resource and one firing may disable the other.

### Proof
Example: one place contains one token and each transition consumes that token. Each is individually enabled; their combined pre-demand is two tokens, unavailable. Firing either removes the sole token and disables the other. QED.

## 147. Petri conflict can be higher-order

There exist transitions \(t_1,t_2,t_3\) such that every pair can fire jointly but all three cannot.

### Proof
One place has marking 2. Each transition consumes one token. Every pair requires two tokens and is jointly executable; all three require three and are not. QED.

Thus exact conflict structure is generally a feasibility hypergraph, not merely a graph.

## 148. Conserved capability systems are Petri-net place invariants

Represent each transferable capability unit by tokens in ownership places. Transfers move tokens between ownership places without creation/destruction. Let w assign weight 1 to every ownership place. Then
\[
w^\top C=0,
\]
so total capability supply is conserved.

### Proof
Every transfer transition removes one token from one ownership place and adds one to another, giving column sum zero. Hence \(w^\top C=0\). Apply Theorem 142. QED.

## 149. Burning and minting are precisely nonzero charge transitions

With total-supply weight vector w, a transition t changes total supply by
\[
\Delta_t=w^\top C e_t.
\]
Transfers satisfy \(\Delta_t=0\); minting has \(\Delta_t>0\); burning has \(\Delta_t<0\).

### Proof
Immediate from the firing equation. QED.

## 150. Product of independent Petri nets has additive invariants

Let nets N₁,N₂ have incidence matrices C₁,C₂. Their disjoint parallel product has block-diagonal incidence matrix
\[
C=C_1\oplus C_2.
\]
If \(w_i^\top C_i=0\), then
\[
(w_1,w_2)^\top C=0.
\]

### Proof
Block multiplication gives
\[
(w_1,w_2)^\top(C_1\oplus C_2)
=(w_1^\top C_1,w_2^\top C_2)=(0,0).
\]
QED.

Conserved quantities therefore compose under independent parallel composition.

## 151. Relations form a category

Let objects be sets and morphisms \(R:X\rightsquigarrow Y\) be relations \(R\subseteq X\times Y\). Composition is
\[
(S\circ R)(x,z)\iff \exists y\,R(x,y)\wedge S(y,z),
\]
and identity is equality relation
\[
\mathrm{id}_X=\{(x,x):x\in X\}.
\]
Then composition is associative and identities are units.

### Proof
Associativity follows by rearranging finite existential quantifiers and conjunction. For identity,
\[
(\mathrm{id}_Y\circ R)(x,y)
\iff \exists y' R(x,y')\wedge y'=y
\iff R(x,y),
\]
and similarly on the other side. QED.

## 152. Cartesian product gives parallel composition of relations

For \(R:X\rightsquigarrow Y\) and \(S:X'\rightsquigarrow Y'\), define
\[
R\otimes S:(X\times X')\rightsquigarrow(Y\times Y')
\]
by
\[
(R\otimes S)((x,x'),(y,y'))
\iff R(x,y)\wedge S(x',y').
\]
Then
\[
(R_2\otimes S_2)\circ(R_1\otimes S_1)
=
(R_2\circ R_1)\otimes(S_2\circ S_1).
\]

### Proof
The left side holds iff there exist y,y' such that
\[
R_1(x,y)\wedge S_1(x',y')\wedge R_2(y,z)\wedge S_2(y',z').
\]
The existential variables separate, giving exactly
\[
(R_2\circ R_1)(x,z)\wedge(S_2\circ S_1)(x',z').
\]
QED.

This is the interchange law between sequential and independent parallel composition.

## 153. Relational converse is a dagger

Define
\[
R^\dagger:Y\rightsquigarrow X,\qquad
R^\dagger(y,x)\iff R(x,y).
\]
Then
\[
(R^\dagger)^\dagger=R,\qquad
(S\circ R)^\dagger=R^\dagger\circ S^\dagger.
\]

### Proof
Both follow by reversing ordered pairs and the existential witness in relational composition. QED.

## 154. Quorum intersection size

Let universe N have n members. Any two subsets Q₁,Q₂ each of size at least q satisfy
\[
|Q_1\cap Q_2|\ge 2q-n.
\]

### Proof
\[
|Q_1\cup Q_2|
=|Q_1|+|Q_2|-|Q_1\cap Q_2|
\le n.
\]
Rearrange:
\[
|Q_1\cap Q_2|\ge |Q_1|+|Q_2|-n\ge 2q-n.
\]
QED.

## 155. Byzantine-safe quorum intersection condition

Suppose at most f members are Byzantine and honest members never endorse two conflicting values. To guarantee that any two quorums of size q intersect in at least one honest member, it is necessary and sufficient that
\[
2q-n>f.
\]

### Proof
By Theorem 154 every pair intersects in at least \(2q-n\) members. If this exceeds f, the intersection cannot consist entirely of Byzantine members, so contains an honest member.

Conversely if \(2q-n\le f\), choose two q-subsets whose intersection has size \(2q-n\) (possible by taking union all n members) and declare every intersection member Byzantine. Then no honest intersection is guaranteed. QED.

## 156. Byzantine quorum availability condition

If at most f members may refuse to participate, then guaranteeing that honest/available members alone can form a quorum requires
\[
q\le n-f.
\]

### Proof
In the worst case exactly f members are unavailable, leaving n-f. A quorum larger than n-f cannot be formed; any q≤n-f can in principle be formed from all remaining members. QED.

## 157. Safety plus availability implies \(n>3f\)

Suppose a single uniform quorum threshold q must satisfy:
\[
2q-n>f
\]
for honest intersection and
\[
q\le n-f
\]
for availability.
Then such q exists iff
\[
\boxed{n>3f.}
\]

### Proof
Safety requires
\[
q>\frac{n+f}{2}.
\]
Availability requires
\[
q\le n-f.
\]
A real q can satisfy both iff
\[
\frac{n+f}{2}<n-f,
\]
equivalently
\[
n+f<2n-2f
\iff 3f<n.
\]
For integer q, when n≥3f+1 choose q=2f+1 (or suitable equivalent threshold); then safety and availability hold. QED.

## 158. Canonical \(3f+1\) quorum arithmetic

If
\[
n=3f+1,\qquad q=2f+1,
\]
then:
\[
2q-n=f+1
\]
and
\[
n-f=2f+1=q.
\]

### Proof
Direct calculation. QED.

Thus any two quorums share at least f+1 members, guaranteeing at least one honest overlap, while all nonfaulty members suffice exactly to form a quorum.

## 159. Conflicting quorum certificates are impossible under honest non-equivocation

Assume at most f Byzantine signers, quorum size q satisfies \(2q-n>f\), and honest signers never sign conflicting values for the same slot. Then two conflicting values cannot both obtain quorum certificates.

### Proof
Two quorum signer sets intersect in more than f members, hence at least one honest signer by Theorem 155. That signer would have to sign both conflicting values, contradicting honest non-equivocation. QED.

## 160. Threshold aggregation compresses evidence without changing quorum combinatorics

Suppose an aggregate signature/certificate is accepted iff it proves participation of a signer set of size at least q. Replacing q individual signatures by one aggregate certificate changes certificate representation size but not the safety condition \(2q-n>f\).

### Proof
Safety depends only on the existence and intersection cardinality of signer sets satisfying the acceptance threshold. Compression of their evidence does not alter those sets or their intersection arithmetic. QED.

## 161. Cryptographic authentication and quorum intersection solve different problems

Quorum intersection guarantees overlap of signer identities. Authentication guarantees an adversary cannot forge an honest signer's endorsement. Neither property implies the other.

### Proof
Intersection without authentication: an adversary could fabricate signatures from overlapping honest identities, defeating the semantic meaning of overlap. Authentication without intersection: two disjoint authenticated signer sets can each endorse conflicting values without any signer equivocating. Hence independence. QED.

## 162. Committee decomposition requires cross-committee intersection or certified bridging for conflicting shared state

Let committees A,B each issue certificates about the same exclusive state variable. If their accepted signer sets can be disjoint and no external bridge proves mutual consistency, then it is possible for A and B to certify conflicting values without any individual signer equivocating.

### Proof
Let every signer in A sign value 0 and every signer in B sign value 1. With disjoint signer sets, no signer signs both. If each committee's local threshold is independently satisfied and there is no cross-consistency predicate, both certificates are locally valid. QED.

Thus sharding shared exclusive state moves, rather than removes, the coordination requirement: consistency must appear at the semantic intersection.

## 163. Independent shards need no quorum intersection

If shard A's accepted transitions act only on state X_A and shard B's only on X_B, and the global state is \(X_A\times X_B\), then conflicting certificates cannot arise across shards because there is no shared exclusive variable. Their certified transitions commute.

### Proof
Disjoint support gives commutation as in the independent-transformation theorem. A certificate about X_A asserts nothing incompatible with a certificate about X_B. QED.

## 164. Cross-shard atomicity is a joint relation, not two independent local relations

Suppose desired operation transfers a conserved object from shard A to shard B. Let local predicates be
\[
R_A:\text{debit object from A},
\qquad
R_B:\text{credit object to B}.
\]
The intended atomic transfer predicate is
\[
R_{\mathrm{atomic}}=R_A\wedge R_B
\]
with shared identity linking the same object. Accepting R_A or R_B independently does not imply the conjunction.

### Proof
Logical conjunction is strictly stronger than either conjunct. A history satisfying only debit burns the object; one satisfying only credit mints/duplicates it. Therefore atomic correctness requires a joint witness/certificate or protocol establishing both linked effects. QED.

## 165. Conservation supplies an exact bridge predicate for cross-shard transfer

Let total-object charge be
\[
Q=Q_A+Q_B.
\]
A cross-shard transfer is conservation-preserving iff
\[
\Delta Q_A+\Delta Q_B=0.
\]

### Proof
\[
Q'-Q=(Q_A'+Q_B')-(Q_A+Q_B)=\Delta Q_A+\Delta Q_B.
\]
Thus Q'=Q iff the displayed sum is zero. QED.

The bridge therefore need not serialize unrelated shard history; it must certify the specific conservation equation at the shared semantic boundary.

## 166. Quorum requirements localize to noncommuting/exclusive state

If two certified operations commute and cannot violate any shared invariant when jointly applied, quorum intersection between their signer sets is unnecessary for logical consistency of those operations.

### Proof
Even if both certificates are accepted, joint application yields the same valid state in either order by hypothesis. Therefore no honest common signer is needed to prevent a conflicting pair, because the pair is not conflicting. QED.

Quorum intersection is required by conflict structure, not by decentralization per se.
