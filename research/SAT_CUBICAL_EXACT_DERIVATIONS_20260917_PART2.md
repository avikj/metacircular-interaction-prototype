# Exact Boolean-cube derivations for SAT — Part II

**Date:** 2026-09-17  
**Continuation of:** `SAT_CUBICAL_EXACT_DERIVATIONS_20260917.md` (which was intentionally preserved after the first write ended mid-sentence).  

This note continues from §8 and turns the residual/cost direction into actual theorems rather than a list of obligations.

---

## 8. Complete residual equality is already the checked minimal quotient

Let an observed transition system be

\[
(X,A,\operatorname{step},\operatorname{observe}).
\]

The checked repository construction `MyhillNerodeMinimalMachine` defines

\[
x\sim y
\iff
\forall w\in A^*,\quad
\operatorname{observe}(\operatorname{run}(x,w))
=
\operatorname{observe}(\operatorname{run}(y,w)).
\]

The source proves that this is the greatest observation-compatible step congruence and that

\[
\operatorname{Meaning}=X/{\sim}
\]

is the minimal fully abstract quotient: its complete behavior map is injective and every other behavior-preserving congruence quotient maps uniquely to it.

For Boolean cubes, instantiate a state by a residual Boolean section and an action by a permitted further cubical restriction/transformation. Then two residuals are one meaning exactly when every permitted future cubical continuation has the same Boolean endpoint.

This immediately gives the correct replacement for “count the branches”: **count distinct complete residual meanings only after quotienting by all future-equivalent presentations admitted by the action system.**

### Theorem 8.1 — one separating continuation forbids identification

If there is a finite action word \(w\) with

\[
\operatorname{observe}(\operatorname{run}(x,w))
\ne
\operatorname{observe}(\operatorname{run}(y,w)),
\]

then \(x\not\sim y\).

**Proof.** The defining universal equality for \(x\sim y\) fails at \(w\). This is also exactly the checked `FutureSeparation.futureSep→¬nerodeCongruence`. ∎

### Theorem 8.2 — child separation lifts to parent separation

If action \(a\) sends \(x,y\) to children separated by word \(w\), then the parents are separated by \(a::w\).

**Proof.** Running \(a::w\) from the parents is definitionally running \(w\) from the children. This is checked as `FutureSeparation.childSep→parentSep`. ∎

Thus a Boolean difference at any future face propagates backward as an exact nonidentification certificate.

### Theorem 8.3 — adaptive response-conditioned trees do not create a finer residual relation

For Bool observations, equality under every finite response-conditioned experiment tree is isomorphic to equality under every ordinary action word.

**Proof.** This is the checked `AdaptiveResidualAdapter.nerodeCongruence-adaptiveIso`. One direction recursively transports complete future equality through the chosen response branch. The reverse embeds every fixed word as an adaptive tree whose two continuations are definitionally identical. ∎

So adaptivity can alter a cost coordinate such as depth, but it does not alter the complete residual quotient itself.

### Theorem 8.4 — bounded cubical observation is complete exactly when its kernel is action-closed

For horizon \(h\), let

\[
x\sim_h y
\]

mean that every action word of length at most \(h\) gives equal observations. Then

\[
\sim_h=\sim
\]

exactly when \(\sim_h\) is preserved by every installed action.

**Proof.** `ObservableHorizon` proves both directions. If the bounded relation is action-closed, it is a behavioral congruence; greatestness of complete future equality gives \(\sim_h\subseteq\sim\), while the reverse inclusion is immediate by restriction to bounded words. Conversely, if bounded equality already implies complete future equality, step preservation follows from step preservation of complete future equality and restriction back to the bounded window. ∎

This is an exact stopping criterion: a finite cubical window has captured the whole future precisely when one more legal local move cannot split any of its fibres.

---

## 9. Fixed coordinate filtrations: exact residual width

Let

\[
f:Q_n\to Q_1
\]

and fix a coordinate order \(x_1,\ldots,x_n\). For a prefix \(a\in Q_k\), define the residual function

\[
f_a:Q_{n-k}\to Q_1,
\qquad
f_a(z)=f(a,z).
\]

Let

\[
R_k(f)=\{f_a:a\in Q_k\},
\qquad
W_k(f)=|R_k(f)|.
\]

### Theorem 9.1 — residual equality is exactly future equality for the fixed-order cube

Two prefixes \(a,b\in Q_k\) have the same complete Boolean future iff

\[
f_a=f_b.
\]

**Proof.** A future suffix \(z\in Q_{n-k}\) is exactly a completion of the remaining coordinates. Equality for every future completion says \(f(a,z)=f(b,z)\) for every \(z\), which is function equality. ∎

### Corollary 9.2 — exact minimal number of meanings at depth \(k\)

For the fixed-order restriction action system, the checked minimal future quotient has exactly

\[
W_k(f)
\]

meanings among depth-\(k\) prefixes.

**Proof.** By Theorem 9.1 its quotient classes are precisely equal residual functions. `MyhillNerodeMinimalMachine` proves no behavior-preserving congruence quotient can identify two different such classes. ∎

### Theorem 9.3 — exact section recurrence

For \(g\in R_k(f)\), let \(g_0,g_1\) be its two sections in the next coordinate. Then

\[
R_{k+1}(f)=\{g_0,g_1:g\in R_k(f)\},
\]

with ordinary set equality removing all coincident residuals.

**Proof.** Every prefix of length \(k+1\) is uniquely a prefix of length \(k\) followed by one bit. Conversely every such section is realized by that extended prefix. ∎

This is the exact “identify or split” recurrence. No branch is counted twice after future equality is imposed.

---

## 10. Exponential residual population is not coordinate-invariant

Define the Boolean inner-product family

\[
\operatorname{IP}_n(x_1,\ldots,x_n,y_1,\ldots,y_n)
=
\bigoplus_{i=1}^n x_i y_i.
\]

### Theorem 10.1 — all-x-first order has \(2^n\) distinct residuals at its midpoint

Use order

\[
x_1,\ldots,x_n,y_1,\ldots,y_n.
\]

After fixing \(x=a\in Q_n\), the residual is

\[
g_a(y)=a\cdot y\pmod2.
\]

For \(a\ne b\), choose a coordinate \(j\) with \(a_j\ne b_j\) and put \(y=e_j\). Then

\[
g_a(e_j)=a_j\ne b_j=g_b(e_j).
\]

Therefore every \(a\) gives a different complete future and

\[
\boxed{W_n(\operatorname{IP}_n)=2^n.}
\]

By Theorem 9.2 this is not a failure to merge syntax: it is the exact minimal future quotient **for that declared coordinate filtration**.

### Theorem 10.2 — interleaving the same cube keeps constant residual memory

Use order

\[
x_1,y_1,x_2,y_2,\ldots,x_n,y_n.
\]

After each completed pair, the past affects the future only through the accumulated parity

\[
p_k=\bigoplus_{i\le k}x_i y_i\in Q_1.
\]

Thus there are at most two residual meanings immediately after a completed pair. Immediately after revealing \(x_{k+1}\) but before \(y_{k+1}\), the residual is determined by the pair

\[
(p_k,x_{k+1})\in Q_2,
\]

so there are at most four meanings. Hence the width is bounded by four at every depth.

**Proof.** The remaining function is

\[
p_k\oplus x_{k+1}y_{k+1}\oplus\cdots\oplus x_ny_n.
\]

At pair boundaries only \(p_k\) from the past occurs; between the two coordinates of a pair only \((p_k,x_{k+1})\) occurs. ∎

### Corollary 10.3 — exponential residual width is not an intrinsic property of the extensional Boolean function

The same \(\operatorname{IP}_n\) has midpoint residual width \(2^n\) in one coordinate presentation and width at most four throughout another.

Therefore any exponentiality certificate that counts residual classes in one fixed coordinate filtration is a certificate for that filtration, not for the fully transportable cubical object.

This is the exact finite-Boolean analogue of the repository’s `TransportDivScale` control: a presentation can carry exponential apparent work while an equivalent chart removes it.

---

## 11. Mutual action simulation is the exact coordinate-change guard

`ContextCloneEquivalence` proves a stronger checked statement than mere permutation invariance. If every generator of action system A is executable as a finite word in system B and conversely, then the two complete-future relations are isomorphic and their Cubical minimal quotients are isomorphic, identity-on-state representatives.

### Theorem 11.1 — any residual cardinal invariant must be invariant under mutual generator-to-word simulation

Let two action presentations mutually simulate in the checked sense. Then their `Meaning` carriers are isomorphic. In particular, for finite carriers they have equal cardinality.

**Proof.** `ContextCloneEquivalence.MutualQuotient.meaningIso`. ∎

So a proposed cubical exponentiality witness that changes under such a mutual simulation is immediately presentation-dependent and cannot be the final intrinsic certificate.

---

## 12. The exact geodesic lower-bound dual

Now forget SAT temporarily and take the already-declared weighted reduction graph literally. Let \(V\) be states/presentations, let an edge \(u\to v\) have nonnegative cost \(w(u,v)\), and let \(T\subseteq V\) be terminal states carrying the demanded Boolean answer.

A finite path

\[
\gamma:v_0\to v_1\to\cdots\to v_k
\]

has cost

\[
\operatorname{cost}(\gamma)=\sum_{i<k}w(v_i,v_{i+1}).
\]

### Theorem 12.1 — potential certificate

Suppose

\[
\Phi:V\to\mathbb N
\]

satisfies

\[
\Phi(t)=0\quad(t\in T)
\]

and for every edge

\[
\Phi(u)\le w(u,v)+\Phi(v).
\]

Then every path from \(s\) to a terminal has cost at least \(\Phi(s)\).

**Proof.** Along a path,

\[
\Phi(v_0)
\le w_0+\Phi(v_1)
\le w_0+w_1+\Phi(v_2)
\le\cdots\le
\sum_iw_i+\Phi(v_k).
\]

The terminal term is zero. ∎

This is a complete lower-bound certificate: no algorithm enumeration appears because the inequality is checked locally on every legal primitive edge.

### Theorem 12.2 — exact attainment criterion

If a path \(v_0\to\cdots\to v_k\in T\) additionally satisfies

\[
\Phi(v_i)=w(v_i,v_{i+1})+\Phi(v_{i+1})
\]

at every step, then

\[
\operatorname{cost}(\gamma)=\Phi(v_0)
\]

and \(\gamma\) is geodesic.

**Proof.** Sum the equalities to telescope; Theorem 12.1 gives the matching lower bound for every competing path. ∎

### Theorem 12.3 — the maximal certificate is distance itself

Define

\[
d_T(v)=\min\{\operatorname{cost}(\gamma):\gamma:v\rightsquigarrow T\}
\]

when a terminal is reachable and the minimum is attained. Then

\[
d_T(u)\le w(u,v)+d_T(v)
\]

for every edge, and every admissible \(\Phi\) of Theorem 12.1 obeys

\[
\Phi(v)\le d_T(v).
\]

Thus \(d_T\) is the pointwise greatest lower-bound potential.

**Proof.** Prepend edge \(u\to v\) to a minimizing path from \(v\) to obtain the first inequality. The second is Theorem 12.1 applied to a minimizing path. ∎

This is the abstract form of the repository’s finite Bellman/geodesic machinery. It also explains the rope proof: the causal-depth quantity is an explicit \(\Phi\), each crossing changes it by at most one, and the native word decreases it exactly one per crossing.

---

## 13. Exact definition of an exponentiality certificate

For a size-indexed family of represented Boolean problems \(P_n\) with terminal set \(T_n\), an **exponentiality certificate** is not a count of assignments, cube vertices, clause intersections, or residual states in one arbitrary chart. It is a family of locally certified potentials

\[
\Phi_n:V_n\to\mathbb N
\]

satisfying the edge inequalities of Theorem 12.1 and an explicit growth equation/inequality such as

\[
\Phi_n(P_n)\ge 2^{c n}
\]

for fixed \(c>0\).

### Theorem 13.1 — such a certificate proves exponential geodesic cost

If the displayed conditions hold, then

\[
d_{T_n}(P_n)\ge2^{cn}.
\]

If the native reduction attains equality edge-by-edge as in Theorem 12.2, then

\[
d_{T_n}(P_n)=\Phi_n(P_n)
\]

exactly.

**Proof.** Theorem 12.1 for the lower bound and Theorem 12.2 for equality. ∎

Nothing remains hypothetical in this theorem. A concrete family either comes equipped with such a function and local edge proofs or it does not.

### Corollary 13.2 — why the old forced-crossing sketch was incomplete

A recurrence saying that some chosen representation contains \(2^n\) cells does not supply the edge inequality

\[
\Phi(u)\le w(u,v)+\Phi(v)
\]

for **every** legal transport/factorization edge. The disjoint-clause product (§6) and inner-product reordering (§10) give explicit counterexamples to treating raw cell count or fixed-filtration residual width as such a \(\Phi\).

The correct object is therefore a quantity monotone/Lipschitz under the actual primitive reduction geometry.

---

## 14. Boolean cube coverage supplies an exact candidate potential family, but only after quotienting by complete future behavior

For a represented SAT state \(s\), let \(M(s)\) denote its point in the checked minimal complete-future quotient for the installed cubical actions. A Boolean distinction between two states survives precisely when some finite future separates their meanings (Theorem 8.1).

For a finite formed world \(W\) of residual states, define

\[
D(W)=\#\{\text{distinct realized meanings }M(s):s\in W\}.
\]

This is invariant under mere syntactic duplication and, by Theorem 11.1, under mutual action-clone simulation. It is therefore strictly better than raw branch/cell count.

But \(D\) itself is **