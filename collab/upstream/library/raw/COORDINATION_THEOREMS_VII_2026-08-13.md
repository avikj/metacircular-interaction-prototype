# COORDINATION THEOREMS VII — SECRECY, COMMITMENTS, COMMON KNOWLEDGE, AND AGREEMENT
Date: 2026-08-13

Status: exact mathematical lemmas and proofs. No novelty claims.

## 167. Perfect secrecy implies ciphertext carries no message information

Let M be a message, K a key independent of M, C=Enc(M,K), and suppose perfect secrecy holds:
\[
P(M=m\mid C=c)=P(M=m)
\]
whenever \(P(C=c)>0\). Then
\[
I(M;C)=0.
\]

### Proof
Perfect secrecy is exactly independence of M and C. Mutual information is zero iff variables are independent. QED.

## 168. Shannon key-entropy lower bound

Assume:
1. K is independent of M;
2. C=Enc(M,K);
3. zero-error decryption: \(H(M\mid C,K)=0\);
4. perfect secrecy: \(I(M;C)=0\).

Then
\[
\boxed{H(K)\ge H(M).}
\]

### Proof
Perfect secrecy gives
\[
H(M\mid C)=H(M).
\]
By zero-error decryption,
\[
H(M\mid C,K)=0.
\]
Hence
\[
H(M)
=H(M\mid C)
=I(M;K\mid C).
\]
But
\[
I(M;K\mid C)\le H(K\mid C)\le H(K).
\]
QED.

Thus perfect secrecy with exact decryption requires at least as much key entropy as message entropy.

## 169. One-time pad attains the Shannon bound for uniform messages

Let M,K be independent uniform n-bit strings and
\[
C=M\oplus K.
\]
Then:
1. \(M=C\oplus K\), so decryption is exact;
2. M and C are independent;
3. \(H(K)=H(M)=n\).

### Proof
Exactness follows from XOR cancellation. For any m,c,
\[
P(C=c\mid M=m)=P(K=m\oplus c)=2^{-n},
\]
independent of m, so C is independent of M. Entropies are n bits. QED.

## 170. Perfect hiding and perfect binding are incompatible for a noninteractive information-theoretic commitment with common commitment alphabet

Let a commitment scheme for messages m have commitment distributions \(\mu_m\) over a finite commitment space C.

Suppose perfect hiding means
\[
\mu_m=\mu_{m'}
\]
for every pair m,m'.

Suppose perfect binding means no commitment value c can occur with positive probability under two distinct messages:
\[
\mathrm{supp}(\mu_m)\cap \mathrm{supp}(\mu_{m'})=\varnothing
\quad (m\ne m').
\]

If there are at least two possible messages and commitments occur with probability one, these conditions are incompatible.

### Proof
Perfect hiding makes \(\mu_m=\mu_{m'}\), so their supports are equal and nonempty. Perfect binding demands those same supports be disjoint. A nonempty set cannot be disjoint from itself. Contradiction. QED.

Hence unconditional commitment requires relaxing at least one side or adding interaction/setup/physical assumptions.

## 171. Deterministic binding implies message information is present in the commitment-plus-opening pair

Let C be a commitment and O an opening such that exact verification uniquely recovers message M:
\[
H(M\mid C,O)=0.
\]
Then
\[
I(M;C,O)=H(M).
\]

### Proof
\[
I(M;C,O)=H(M)-H(M\mid C,O)=H(M).
\]
QED.

Binding concerns the joint commitment/opening object; hiding concerns what is revealed before O.

## 172. Secret-sharing lower bound from exact reconstruction

Let secret S be reconstructed exactly from shares \(W_A\) for an authorized coalition A:
\[
H(S\mid W_A)=0.
\]
Then
\[
H(W_A)\ge H(S).
\]

### Proof
\[
H(S)=I(S;W_A)\le H(W_A).
\]
QED.

## 173. Perfect unauthorized privacy

If coalition B is unauthorized with perfect secrecy
\[
I(S;W_B)=0,
\]
then
\[
H(S\mid W_B)=H(S).
\]

### Proof
By definition,
\[
I(S;W_B)=H(S)-H(S\mid W_B).
\]
QED.

## 174. Any authorized extension must supply the entire residual secret entropy

If B is unauthorized with perfect secrecy and A extends B to an authorized coalition, then
\[
I(S;W_{A\setminus B}\mid W_B)=H(S).
\]

### Proof
Unauthorized privacy gives \(H(S\mid W_B)=H(S)\). Authorized reconstruction gives \(H(S\mid W_A)=0\). Therefore
\[
I(S;W_{A\setminus B}\mid W_B)
=H(S\mid W_B)-H(S\mid W_A)
=H(S).
\]
QED.

This is the exact cut-information statement for threshold knowledge.

## 175. Epistemic knowledge operator

Let Ω be a finite state space and let \(\Pi_i\) be agent i's information partition. For event E⊆Ω define
\[
K_i(E)=\{\omega:\Pi_i(\omega)\subseteq E\}.
\]
Then:
1. \(K_i(E)\subseteq E\);
2. if \(E\subseteq F\), then \(K_i(E)\subseteq K_i(F)\);
3. \(K_i(E\cap F)=K_i(E)\cap K_i(F)\).

### Proof
(1) If the entire information cell containing ω lies in E, then ω∈E.
(2) Inclusion of events preserves containment of cells.
(3) A cell is contained in E∩F iff it is contained in both E and F. QED.

## 176. Mutual knowledge iteration and common knowledge

Define
\[
K(E)=\bigcap_i K_i(E),
\]
and iterates \(K^1(E)=K(E)\), \(K^{n+1}(E)=K(K^n(E))\). Define common knowledge
\[
CK(E)=\bigcap_{n\ge1} K^n(E).
\]
Then \(CK(E)\subseteq K^n(E)\subseteq E\) for every n.

### Proof
By definition of intersection and Theorem 175(1), inductively. QED.

## 177. Common knowledge cell characterization

Let \(\sim_i\) identify states in the same information cell for agent i. Let \(\sim^*\) be the transitive closure of the union of all \(\sim_i\). Then E is common knowledge at ω iff the entire \(\sim^*\)-connected component of ω is contained in E.

### Proof
A state reachable from ω by one \(\sim_i\)-step is considered possible by some agent; two steps correspond to what an agent considers possible about another agent's possibilities; iterating generates all finite chains. Membership in every finite mutual-knowledge iterate is therefore equivalent to E containing every state reachable by any finite chain, exactly the \(\sim^*\)-component. QED.

## 178. Coordinated-attack impossibility for finite unreliable-message protocols

Two agents A,B must choose Attack or Not. Success requires both attack; attacking alone is unacceptable. Messages can be lost, and there is no guaranteed delivery acknowledgment primitive. Suppose a protocol uses at most N messages in every execution and requires certainty before attacking.

Then no protocol can guarantee coordinated attack after communication.

### Proof
Assume some finite-message protocol guarantees both attack in some execution. Choose such a successful execution with the minimum number k of delivered messages.

If k=0, the agents attack without communication, so the same local states occur in an execution where coordination assumptions are absent; certainty cannot have been created by communication.

For k>0, consider the last delivered message in the successful execution. The sender cannot know whether that final message is delivered, because there is no later acknowledgment. Therefore the sender's local state before choosing Attack is identical in two executions: one where the last message arrives and one where it is lost. If the sender attacks with certainty in the delivered execution, it must make the same choice in the lost execution. For the receiver to coordinate safely in the lost execution as well, the last delivered message was unnecessary. Removing it yields a successful execution with k-1 delivered messages, contradicting minimality. Repeating reduces to k=0. Therefore finite unreliable communication cannot create the certainty required for guaranteed coordinated attack. QED.

## 179. No finite acknowledgment tower creates common knowledge under possible message loss

Suppose event E initially is not common knowledge, and communication consists of a finite sequence of messages each of which may be lost without the sender learning that fact. Then no finite successful-delivery history can make E common knowledge solely by acknowledgment nesting.

### Proof
Take a supposed shortest successful history making E common knowledge. Remove its last delivered message. The sender cannot distinguish delivery from loss, so if common knowledge required the last message, the sender cannot know that common knowledge holds after sending it. But common knowledge implies the sender knows common knowledge holds. Contradiction. QED.

## 180. Reliable public broadcast can create common knowledge of the broadcast event

Suppose a primitive publicly broadcasts message m such that every agent observes delivery and knows that every agent observes delivery, recursively without bound as part of the primitive's semantics. Then the event “m was broadcast” is common knowledge after broadcast.

### Proof
The primitive assumption directly states all finite levels of mutual knowledge. Therefore the event belongs to every \(K^n\), hence to CK. QED.

This isolates the resource needed: not merely information transfer, but a delivery semantics supporting common knowledge.

## 181. Aumann agreement theorem, finite form

Let Ω be finite with common prior probability P giving positive probability to relevant cells. Agents i and j have information partitions \(\Pi_i,\Pi_j\). Let E be an event and define posteriors
\[
p_i(\omega)=P(E\mid \Pi_i(\omega)),
\qquad
p_j(\omega)=P(E\mid \Pi_j(\omega)).
\]
Suppose at state ω₀ it is common knowledge that
\[
p_i=a,\qquad p_j=b.
\]
Then
\[
\boxed{a=b.}
\]

### Proof
Let C be the common-knowledge cell (the connected component under the join of the two partitions) containing ω₀. Common knowledge of the posterior values means p_i=a and p_j=b at every state in C.

The set C is a union of i-information cells. Therefore
\[
P(E\mid C)
=
\sum_{A\subseteq C,\ A\in\Pi_i}
P(E\mid A)P(A\mid C)
=
\sum_A a\,P(A\mid C)
=a.
\]
Similarly, because C is a union of j-information cells,
\[
P(E\mid C)=b.
\]
Hence a=b. QED.

## 182. Persistent disagreement requires failure of at least one Aumann hypothesis

Under the hypotheses of Theorem 181, common-knowledge posterior disagreement is impossible. Therefore if two Bayesian agents persistently disagree with posteriors a≠b, at least one of the following fails:
1. common prior;
2. Bayesian conditionalization on the modeled partitions;
3. common knowledge of the posterior values;
4. the shared state-space/model assumptions.

### Proof
Contrapositive of Theorem 181. QED.

## 183. Public posterior announcements refine partitions monotonically

When an agent publicly announces a posterior value, every observer can eliminate states at which that agent's posterior differs. Hence the common public information partition weakly refines.

### Proof
The announcement event is the level set
\[
A_a=\{\omega:p_i(\omega)=a\}.
\]
After a truthful public announcement, states outside \(A_a\) are excluded. Intersecting information cells with \(A_a\) refines or leaves unchanged the partition. QED.

## 184. Finite repeated public posterior announcements stabilize

On a finite state space, iteratively making truthful public posterior announcements produces a monotonically refining sequence of finite partitions, hence eventually stabilizes.

### Proof
A finite state space admits only finitely many partitions. Each truthful public announcement weakly refines the public partition by Theorem 183. A strictly refining chain of finite partitions cannot continue indefinitely. QED.

## 185. At stabilization under common prior, publicly known posteriors agree

If the stabilized announcement process makes each agent's posterior common knowledge, then all agents' posteriors for the event are equal.

### Proof
Apply Theorem 181 pairwise. QED.

## 186. Consensus of beliefs is different from consensus of actions

Agents can have equal posterior \(P(E\mid\cdot)=p\) yet rationally choose different actions when their utility functions differ.

### Proof
Let two agents share the same belief p about E. Agent 1 receives utility 1 from action A regardless of E and 0 from B; agent 2 receives utility 1 from B regardless of E and 0 from A. They have identical beliefs but choose different utility-maximizing actions. QED.

Thus epistemic agreement does not imply value alignment.

## 187. Identical utilities plus identical posteriors imply identical optimal action sets under common feasible actions

Let agents have identical expected-utility function U(a,p) over the same feasible action set A and share posterior p. Then their argmax sets are identical:
\[
\arg\max_{a\in A}U(a,p).
\]

### Proof
They optimize the same function over the same set. QED.

## 188. Value alignment and information alignment are orthogonal coordinates

There exist:
1. agents with identical beliefs but different optimal actions;
2. agents with different beliefs but the same optimal action.

### Proof
Case 1 is Theorem 186.
Case 2: give both agents a strictly dominant action A independent of state; beliefs may differ arbitrarily while both choose A. QED.

Therefore coordination requires separate treatment of epistemic state and utility/objective structure.

## 189. Common objective does not remove hidden-information constraints

Suppose all agents share exactly the same objective C=f(X_1,\dots,X_n), but no one initially knows enough to determine C. Then exact achievement can still require communication satisfying the cut bounds of Theorems 45–47.

### Proof
The cut bounds depend on conditional entropy of C given local information, not on whether utilities are aligned. Shared objectives do not reduce \(H(C\mid X_B)\) unless they also convey information. QED.

## 190. Perfect information does not remove incentive constraints

Suppose every agent observes the full state X but has utility functions under which some agent benefits from deviating from a desired action profile. Then information completeness alone does not make the desired profile an equilibrium.

### Proof
Equilibrium requires no profitable unilateral deviation. Full observability changes knowledge, not payoffs. If a profitable deviation exists, equilibrium fails. QED.

Thus distributed coordination has at least two mathematically independent obstructions:
\[
\boxed{\text{information insufficiency}}
\qquad\text{and}\qquad
\boxed{\text{incentive incompatibility}}.
\]
Cryptographic feasibility constraints form a third independent axis.
