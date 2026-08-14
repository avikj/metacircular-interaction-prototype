# COORDINATION / INFORMATION / PROVENANCE THEOREMS II
Date: 2026-08-12

Status: exact mathematical lemmas. No novelty claims.

## Theorem A — Interactive cut lower bound
Let X_A,X_B,R be random variables, with R public randomness. Consider any finite interactive protocol between sides A and B. Let M_{A→B} denote the full concatenation of all messages sent from A to B, and let C be B's exact final output. Assume C is a deterministic function of (X_A,X_B,R) and the protocol is deterministic conditional on R. Then
\[
H(C\mid X_B,R,M_{A\to B})=0,
\]
hence
\[
I(C;M_{A\to B}\mid X_B,R)=H(C\mid X_B,R),
\]
and therefore
\[
H(M_{A\to B}\mid X_B,R)\ge H(C\mid X_B,R).
\]

### Proof
Given X_B,R and the entire A→B transcript, every B→A message can be reconstructed inductively: B's first message is a function of X_B,R and prior A→B messages; then the next, etc. Thus B's complete view and final output C are deterministic functions of (X_B,R,M_{A→B}). The entropy identity follows, and the final bound is \(I\le H\). QED.

## Theorem B — Perfect zero knowledge is information-minimal exact predicate disclosure
Let X be private state, Y public/local side information, and C=f(X,Y) a deterministic predicate/output. Let Π be any transcript such that C is exactly recoverable from (Y,Π). Then
\[
I(X;\Pi\mid Y)\ge I(X;C\mid Y)=H(C\mid Y).
\]
If in addition Π is perfectly simulatable from (Y,C), i.e.
\[
X \perp \Pi\mid (Y,C),
\]
then equality holds:
\[
I(X;\Pi\mid Y)=H(C\mid Y).
\]

### Proof
Because C is a deterministic function of (Y,Π), conditional data processing gives
\[
I(X;\Pi\mid Y)\ge I(X;C\mid Y).
\]
Since C is deterministic from (X,Y),
\[
I(X;C\mid Y)=H(C\mid Y).
\]
Under \(X\perp \Pi\mid(Y,C)\),
\[
I(X;\Pi,C\mid Y)=I(X;C\mid Y),
\]
while C is a function of (Y,Π), so
\[
I(X;\Pi,C\mid Y)=I(X;\Pi\mid Y).
\]
Hence equality. QED.

## Theorem C — Canonical coarsest exact interface for a task family
Let X be a set and \(\mathcal F\) a family of functions \(f:X\to Y_f\). Define
\[
x\sim_{\mathcal F}x'
\iff
\forall f\in\mathcal F,\ f(x)=f(x').
\]
Let \(q:X\to X/{\sim_{\mathcal F}}\) be the quotient map.

Then:
1. Every \(f\in\mathcal F\) factors uniquely through q.
2. If \(T:X\to Z\) is any interface through which every \(f\in\mathcal F\) factors, then q factors through T:
\[
q = r\circ T
\]
for a unique map r on \(T(X)\).

Thus q is the coarsest exact interface supporting all tasks in \(\mathcal F\).

### Proof
(1) Define \(\bar f([x])=f(x)\); this is well-defined by the equivalence relation.
(2) If T(x)=T(x'), then every f factors through T, so f(x)=f(x') for all f, hence x~x'. Therefore [x] depends only on T(x), giving r. Uniqueness on T(X) is immediate. QED.

## Theorem D — Entropy of the canonical task interface
Let X now be random and let Q=q(X) for the canonical task quotient above. If T is any exact interface supporting \(\mathcal F\), then
\[
H(Q)\le H(T).
\]
If T is deterministic from X.

### Proof
By Theorem C, \(Q=r(T)\). Hence entropy cannot increase under deterministic processing:
\[
H(Q)\le H(T).
\]
QED.

## Theorem E — Criterion for an additive provenance charge to survive semantic quotienting
Let \(\mathcal C\) be a category and A an abelian group. Let
\[
q:\mathrm{Mor}(\mathcal C)\to A
\]
satisfy
\[
q(g\circ f)=q(g)+q(f),\qquad q(\mathrm{id})=0.
\]
Let \(F:\mathcal C\to\mathcal D\) be a semantics functor.

There exists a function
\[
\bar q:\mathrm{Mor}(F(\mathcal C))\to A
\]
with
\[
q=\bar q\circ F
\]
iff
\[
F(f)=F(g)\implies q(f)=q(g).
\]

### Proof
Necessity is immediate. For sufficiency define \(\bar q(F(f)):=q(f)\). The condition makes this well-defined. Additivity follows from functoriality:
\[
\bar q(F(g)\circ F(f))
=\bar q(F(g\circ f))
=q(g\circ f)
=q(g)+q(f).
\]
QED.

## Corollary E.1 — Kernel-loop obstruction
Under the same assumptions, if there exist parallel morphisms f,g with
\[
F(f)=F(g),\qquad q(f)\ne q(g),
\]
then the extensional semantics F necessarily destroys q.

Equivalently, any semantic identification carrying nonzero charge difference is an obstruction to charge descent.

## Theorem F — Universal refinement retaining both semantics and charge
Under Theorem E's assumptions define
\[
\widetilde F(f)=(F(f),q(f)).
\]
Then any map G on morphisms from which both F and q factor also factors uniquely through \(\widetilde F\).

### Proof
If \(F=\alpha\circ G\) and \(q=\beta\circ G\), define
\[
\gamma(G(f))=(\alpha(G(f)),\beta(G(f)))=(F(f),q(f)).
\]
This is forced, hence unique. QED.

Thus \((F,q)\) is the universal joint observable retaining extensional semantics and additive provenance charge.

## Theorem G — Exact cut decomposition for a tree of computations
Let T be a rooted tree. Each leaf i holds Xi. Each internal vertex v computes
\[
Y_v=f_v((Y_u)_{u\in \mathrm{ch}(v)}).
\]
Let C be the root output. For any edge e separating subtree A from the remainder B, any exact protocol replacing the edge value by a message M_e available to B must satisfy
\[
H(M_e\mid X_B)\ge H(C\mid X_B)
\]
whenever all information from A to the root passes through e.

### Proof
Condition on X_B. Since every influence of A on C crosses e, exact reconstruction of C at the root makes C a deterministic function of (X_B,M_e). Apply the exact cut bound. QED.

## Theorem H — Multiple independent cuts add
Let \(C=(C_1,\dots,C_k)\) with \(C_j\) conditionally independent given Y:
\[
P(C\mid Y)=\prod_j P(C_j\mid Y).
\]
Suppose disjoint transcripts \(M_j\) satisfy exact recovery of \(C_j\) from \((Y,M_j)\). Then
\[
\sum_j H(M_j\mid Y)\ge H(C\mid Y).
\]

### Proof
For each j,
\[
H(M_j\mid Y)\ge H(C_j\mid Y).
\]
Conditional independence gives
\[
H(C\mid Y)=\sum_j H(C_j\mid Y).
\]
Sum. QED.

## Theorem I — Minimal exact disclosure for a deterministic target is the target quotient
Let \(C=f(X)\). Among deterministic interfaces T(X) from which C is exactly recoverable, the coarsest interface is C itself up to bijection on its image.

### Proof
This is Theorem C for the singleton task family {f}. Any exact T satisfies C=g(T), so the quotient induced by C factors through T. QED.

