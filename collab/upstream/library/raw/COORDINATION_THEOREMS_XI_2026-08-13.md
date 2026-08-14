# COORDINATION THEOREMS XI — MERKLE COMMITMENTS, CONTENT ADDRESSING, AND PROVENANCE DAGS
Date: 2026-08-13
Status: exact lemmas under stated ideal hash assumptions; no novelty claims.

Assume a hash function H with domain-separated encodings. Collision resistance is invoked only where explicitly stated.

## 271. Merkle parent commits to ordered children under collision resistance
Define
\[
P=H(0\|L\|R)
\]
for child digests L,R. If two ordered pairs (L,R)≠(L',R') yield the same P, then they form a collision in H on distinct encoded inputs.

Proof. Domain-separated encoding is injective in the tuple, so distinct pairs give distinct hash inputs. Equal outputs are a hash collision. QED.

## 272. Merkle root commits to all leaves under collision resistance
For a fixed binary tree shape, if two distinct leaf vectors yield the same Merkle root, then some internal application of H collides.

Proof. Descend from the equal roots. If their child-digest pairs differ, Theorem 271 gives a collision. If equal, descend into a child subtree containing a differing leaf. Since the leaves differ, eventually an equal parent digest has unequal child inputs, yielding a collision. QED.

## 273. Merkle inclusion proof length is logarithmic in a balanced tree
For a full balanced binary Merkle tree with N=2^h leaves, an inclusion proof for one leaf consists of h sibling hashes, hence O(log N) digests.

Proof. The leaf-to-root path has exactly h=log_2 N edges; one sibling digest is needed per level. QED.

## 274. Inclusion verification recomputes only the authentication path
Given a leaf, its index/orientation bits, h sibling digests, and claimed root, membership is checked using exactly h parent-hash evaluations.

Proof. Starting from the leaf digest, combine with the sibling at each level in the specified order. After h hashes obtain the reconstructed root and compare. QED.

## 275. Content-addressed identity is invariant under storage location
Let artifact identity be id(a)=H(enc(a)). Moving the bytes of a between storage locations without changing enc(a) leaves id(a) unchanged.

Proof. H receives identical input. QED.

## 276. Content-addressed dependency identity commits transitively
Define an artifact node
\[
a=(payload, id(d_1),...,id(d_k))
\]
and id(a)=H(enc(a)). If any dependency content changes and collision resistance holds transitively, then either id(a) changes or a hash collision occurs.

Proof. Changed dependency content changes its digest unless collision. That changes a's encoded input unless collision higher in the chain. QED.

## 277. A Merkle DAG commits to reachable provenance
Let root artifact r content-address its direct dependencies recursively. Under collision resistance, changing any reachable dependency while preserving r's digest implies a collision somewhere on a dependency path.

Proof. Follow a path from changed node to r and apply Theorem 276 inductively. QED.

## 278. Identical content deduplicates automatically
If id(a)=H(enc(a)) and two independently produced artifacts have byte-identical canonical encodings, then they have identical IDs.

Proof. Equal hash input gives equal output. QED.

## 279. Canonicalization is necessary for semantic deduplication by raw hashing
If semantically equivalent artifacts can have different encodings, raw content hashes need not agree.

Proof. H is applied to encodings, not semantic equivalence classes. Distinct encodings generally need not hash equally. QED.

Thus semantic deduplication requires canonicalization or hashing a canonical semantic representative.

## 280. Hashing a canonical quotient representative deduplicates equivalent implementations
Let ~ be an equivalence relation and c:X→X a canonicalization satisfying
\[
x\sim y\iff c(x)=c(y).
\]
Define sid(x)=H(enc(c(x))). Then equivalent x,y have equal sid; under collision resistance, unequal canonical representatives do not share sid except by collision.

Proof. Direct from the defining iff and hashing. QED.

## 281. Provenance identity and semantic identity can coexist
Let
\[
pid(a)=H(enc(payload,dependency\ IDs,derivation)),
\]
while
\[
sid(a)=H(enc(canonical\ semantics)).
\]
Then two artifacts may satisfy sid(a)=sid(b) while pid(a)≠pid(b).

Proof. Choose two distinct derivations with equal canonical semantics. Semantic encodings coincide; provenance encodings differ, hence provenance hashes differ absent collision. QED.

This realizes simultaneously an extensional quotient and an intensional lift.

## 282. Provenance-sensitive rewards factor through provenance ID but not necessarily semantic ID
If reward A is a deterministic function of the full canonical provenance object, then A factors through a collision-free idealization of pid. If two derivations share sid but have different rewards, A cannot factor through sid.

Proof. First claim is direct identification of canonical provenance by its ideal unique digest. Second is the output-only attribution theorem. QED.

## 283. Immutable content addressing turns references into commitments
If a reference stores id(a), then replacing a by distinct canonical content a' while preserving the reference requires H(enc(a))=H(enc(a')), a collision.

Proof. Immediate. QED.

## 284. Append-only derivation DAG preserves historical referential integrity
Suppose nodes are immutable and referenced only by content digest. Adding new nodes cannot alter the content or identity of any existing reachable sub-DAG.

Proof. Existing nodes contain fixed digests and immutable payloads. Addition creates new nodes/edges from new nodes; it does not mutate old encodings. QED.

## 285. Branching requires no global serialization in an immutable DAG
Two agents may independently create nodes a,b referencing the same prior root r. Both objects are well-defined without choosing whether a precedes b or b precedes a.

Proof. Each node's identity depends on its own content and r, not on the other node. There is no dependency edge between a and b, hence no causal order in the DAG. QED.

## 286. Merge node records only actual dependency
A merge artifact m depending on a and b may reference both:
\[
m=(payload,id(a),id(b)).
\]
Then a,b precede m causally, while no order between a,b is introduced.

Proof. DAG edges a→m and b→m induce those precedence relations; absent a path between a and b they remain incomparable. QED.

## 287. Provenance DAG is a partial-order certificate
In an acyclic dependency graph, define x≤y iff x=y or there is a directed path x→...→y. Then ≤ is a partial order.

Proof. Reflexivity by equality; transitivity by concatenating paths; antisymmetry because paths both ways between distinct vertices would form a directed cycle. QED.

## 288. Topological serialization is noncanonical representation of a provenance DAG
Every finite DAG has at least one topological ordering. If two vertices are incomparable, there exist topological orders differing in their relative order.

Proof. Existence is standard by repeatedly removing a source. For incomparable a,b, adding relation a<b preserves acyclicity and gives a topological order with a before b; adding b<a likewise. QED.

Thus storing one topological order adds arbitrary information absent from provenance causality.

## 289. Number of linearizations measures serialization redundancy
For a finite DAG P, let L(P) be its set of topological orderings. Choosing one total serialization requires
\[
\log_2 |L(P)|
\]
bits to identify that ordering among all valid linearizations, in the uniform coding idealization.

Proof. Distinguishing |L(P)| equiprobable alternatives requires log_2|L(P)| bits of Shannon information. QED.

## 290. Independent n-event history has n! valid serializations
If n events are pairwise incomparable, every permutation is a topological ordering:
\[
|L(P)|=n!.
\]

Proof. There are no precedence constraints, so every permutation respects the poset. QED.

## 291. Serialization redundancy for n independent events is Θ(n log n) bits
For n pairwise independent events,
\[
\log_2 n! = n\log_2 n-(\log_2 e)n+O(\log n).
\]

Proof. Stirling's formula
\[
\log n!=n\log n-n+O(\log n)
\]
converted to base 2. QED.

Thus a total ledger order can encode Θ(n log n) bits of arbitrary interleaving choice that the causal computation itself does not contain.

## 292. A chain has zero serialization redundancy
If n events form a total causal chain, then
\[
|L(P)|=1,\qquad \log_2|L(P)|=0.
\]

Proof. Every pair has forced order, leaving exactly one topological ordering. QED.

## 293. Serialization redundancy interpolates between causal chain and antichain
For every n-event poset,
\[
1\le |L(P)|\le n!.
\]

Proof. At least one linear extension exists for finite posets. Every linear extension is a permutation, of which there are n!. QED.

## 294. Adding causal constraints weakly reduces serialization redundancy
If poset Q extends P by adding order relations without contradiction, then
\[
L(Q)\subseteq L(P),
\]
hence
\[
|L(Q)|\le |L(P)|.
\]

Proof. Every ordering satisfying the stronger relation Q also satisfies all relations of P. QED.

## 295. Causal entropy of a finite event structure
Define
\[
S_{\mathrm{lin}}(P)=\log |L(P)|.
\]
Then adding genuine causal constraints cannot increase \(S_{\mathrm{lin}}\), while removing redundant ordering constraints can increase it without changing trace semantics if the removed relations were between commuting independent events.

Proof. First statement is Theorem 294. Second follows because deleting a nonrequired order admits additional linear extensions; if the events commute, those extensions remain semantically equivalent. QED.

This quantity measures freedom of interleaving, not thermodynamic entropy.

## 296. Merkle commitment and causal partial order are orthogonal
A Merkle DAG can cryptographically commit to a dependency partial order without selecting a total order of incomparable nodes.

Proof. Each node commits to listed parent digests. Reachability determines causal precedence. Incomparable nodes need no mutual reference, so hashing imposes no total order. QED.

## 297. A single root can commit to a whole unordered dependency frontier after canonical set encoding
Let frontier digests be a finite set S. Canonically sort or otherwise canonically encode S and hash
\[
r=H(enc(S)).
\]
Then r commits to the set S without assigning semantic temporal order to its elements.

Proof. Canonical encoding is a representation of the mathematical set; its implementation sorting is only canonicalization, while decoded semantics is S. Collision resistance commits to the encoded set. QED.

## 298. Content addressing plus local certificates yields immutable proof-carrying artifacts
Let artifact a contain payload, dependency IDs, and certificate π verified against those dependencies. Its content ID commits to all three. Changing payload, dependency references, or π while preserving ID requires a hash collision.

Proof. They are all fields of the canonical encoded hash input. QED.

## 299. Verification status can be monotone without mutating artifacts
Let artifact a remain immutable. A later verification artifact v may reference id(a) and contain a stronger certificate. Then knowledge state can gain “a has verification level V” by adding v, without changing a.

Proof. v is a new immutable statement about a. Existing identity remains unchanged. QED.

## 300. Corrections can be append-only
Let claim artifact a be false or superseded. Add correction artifact c referencing a and carrying a refutation/replacement certificate. The history preserves both the original claim and its correction without mutation.

Proof. Append-only DAG semantics permits new nodes referencing old ones. No old node changes. QED.

Thus epistemic revision need not require destructive rewriting of provenance.
