# Exact Boolean-cube derivations for SAT — Part V

**Date:** 2026-09-17

This part fixes another possible collapse: the one-bit SAT decision and construction of a satisfying vertex are different projections of the same cubical fibre. It also lifts the scalar geodesic certificate to the repository’s non-scalar/Pareto cost geometry.

---

## 33. SAT decision and SAT witness are different cubical targets

For a fixed Boolean predicate

\[
F:Q_N\to Q_1,
\]

let

\[
S_F=F^{-1}(1)
\]

be its satisfying fibre.

There are two distinct outputs:

\[
\mathrm{Dec}_F=\|S_F\|
\]

(the mere proposition that the fibre is inhabited), and

\[
\mathrm{Wit}_F=S_F
\]

(the actual satisfying vertex together with its membership proof).

### Theorem 33.1 — witness projects to decision

There is the canonical truncation

\[
\tau:S_F\to\|S_F\|.
\]

Thus every witness determines the decision “SAT”.

### Theorem 33.2 — decision does not in general recover which witness

If \(S_F\) contains two distinct vertices \(x\ne y\), no left inverse

\[
s:\|S_F\|\to S_F
\]

can satisfy

\[
s(\tau z)=z
\]

for every witness \(z\in S_F\).

**Proof.** Propositional truncation identifies \(\tau x=\tau y\). Applying \(s\) and the two left-inverse laws gives \(x=y\), contradiction. ∎

This is exactly the general truncation distinction already recorded in `PNP_GEODESIC_REDUCTION_20260916.md`, now specialized to the Boolean cube.

### Theorem 33.3 — the fibre of the SAT truncation over an inhabited decision is the whole satisfying cube

Given \(p:\|S_F\|\),

\[
\operatorname{fib}_\tau(p)\simeq S_F.
\]

**Proof.** This is the checked repository truncation-fibre theorem specialized to \(E=S_F\): send \((x,r)\mapsto x\); send \(x\mapsto(x,\operatorname{squash}(|x|,p))\). ∎

So the one-bit/propositional decision discards exactly the “which satisfying vertex” fibre. For SAT discussions, one must state which projection is being costed.

---

## 34. The two targets can have radically different residual geometry

### Theorem 34.1 — a constant decision can coexist with a large witness fibre

Take \(F\equiv1\) on \(Q_N\). Then

\[
S_F=Q_N,
\qquad
\|S_F\|\text{ is inhabited},
\]

while the truncation fibre is equivalent to \(Q_N\), containing \(2^N\) vertices.

**Proof.** Immediate from Theorem 33.3. ∎

This does **not** imply witness construction costs \(2^N\): a section may choose the all-zero vertex compactly. It proves only that decision and witness carry different cubical information.

### Theorem 34.2 — a unique satisfying vertex makes decision and witness propositionally equivalent once the unique point is supplied

If \(S_F\) is contractible, then \(S_F\simeq\|S_F\|\).

**Proof.** A contractible type is a proposition and is inhabited; propositional truncation of an inhabited proposition is equivalent to the proposition itself. ∎

Again this is a statement about carriers, not the time required to construct the contraction center from a formula presentation.

---

## 35. Coverage and witness are complementary sections of the same cube

With violation union

\[
V_F=\bigcup_\alpha V_\alpha,
\]

we have a disjoint partition of Boolean vertices

\[
Q_N=S_F\;\dot\cup\;V_F.
\]

Hence

\[
|S_F|+|V_F|=2^N.
\]

The decision “UNSAT” is \(S_F=\varnothing\), equivalently \(V_F=Q_N\). A SAT witness is a point in the complementary section \(Q_N\setminus V_F\). Thus the decision and witness problems are not two separate geometries; they are two observations of the same partition.

---

## 36. Vector-valued geodesic certificates

The repository’s checked `ParetoCost.agda` proves that resource coordinates need not admit a canonical scalarization. Accordingly, let primitive edges carry costs in

\[
\mathbb N^d
\]

with componentwise order.

Let

\[
\Phi:V\to\mathbb N^d
\]

satisfy \(\Phi(t)=0\) on terminals and, for every edge \(u\to v\),

\[
\Phi(u)\preceq w(u,v)+\Phi(v)
\]

componentwise.

### Theorem 36.1 — vector potential lower bound

For every path \(\gamma:s\rightsquigarrow T\),

\[
\boxed{\Phi(s)\preceq\operatorname{cost}(\gamma).}
\]

**Proof.** Apply the scalar telescoping proof coordinatewise. ∎

### Corollary 36.2 — one exponential mandatory coordinate is enough to certify exponential growth in that resource

If coordinate \(j\) obeys

\[
\Phi_j(P_n)\ge2^{cn},
\]

then every terminal path has

\[
\operatorname{cost}_j\ge2^{cn}.
\]

No scalar exchange rate between resource coordinates is required.

### Theorem 36.3 — exact Pareto attainment

If a native path satisfies componentwise equality

\[
\Phi(v_i)=w_i+\Phi(v_{i+1})
\]

at every step, then its cost vector equals \(\Phi(s)\). Any competing path has cost vector componentwise at least \(\Phi(s)\).

**Proof.** Telescope the equalities and combine with Theorem 36.1. ∎

This is the correct non-scalar generalization of the geodesic certificate. It respects the repository’s result that two routes can be incomparable under componentwise resource order and that choosing a scalar objective is extra policy data.

---

## 37. Information coordinates can themselves be carried as vector potentials only after a local edge law is proved

The Boolean cube supplies many exact quantities:

\[
N,\quad |S_F|,\quad |V_F|,\quad M_1,M_2,\ldots,
\quad \#\text{future meanings},\quad\text{boundary classes},\ldots
\]

Any finite selection can be retained as a vector. But Theorem 36.1 turns a coordinate into a **cost lower bound only if its primitive-edge inequality is proved**.

This cleanly separates:

- a coordinate that describes the current cubical object;
- a coordinate that is monotone/Lipschitz under the declared dynamics;
- a coordinate that therefore lower-bounds path cost.

The first is information. The second is information plus dynamics. The third is the same object read metrically.

No separate complexity ontology is required.

---

## 38. The exact place where an exponential SAT certificate must live

For one-bit SAT decision, output size is constant. Parts I–IV eliminate raw vertex count, clause-intersection count, fixed-coordinate residual width, and satisfying-fibre cardinality as universal lower bounds.

Therefore an exponential certificate for the **actual universal reduction semantics** must be a primitive-edge potential on the proof-relevant residual geometry itself. In cube language it is a collection of terminal-relevant nonfillable boundary distinctions whose total certified measure cannot fall faster than the paid local interaction rate.

That sentence is not a hypothesis: it is the contrapositive of the potential theorem plus the explicit counterexamples already constructed for the simpler candidate quantities.

If a claimed lower bound lacks such an edge law, Parts I–IV already provide models in which the claimed exponential quantity collapses under exact factoring or coordinate change.
