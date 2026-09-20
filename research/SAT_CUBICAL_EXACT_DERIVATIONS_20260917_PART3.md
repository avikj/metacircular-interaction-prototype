# Exact Boolean-cube derivations for SAT — Part III

**Date:** 2026-09-17  
**Continuation:** Parts I–II in the same directory.

The preceding file ended while discussing the cardinality of the complete-future quotient. This part closes that point and gives two exact controls showing why cardinality growth is not yet geodesic cost.

---

## 14. Complete-future meaning count is semantic dimension, not automatically path length

For a finite formed set \(W\) of residual states, let

\[
D(W)=\#\{[s]_{\sim}:s\in W\}
\]

where \(\sim\) is the checked complete-future congruence.

`MyhillNerodeMinimalMachine` makes \(D\) canonical for the declared action/observation system: no behavior-preserving quotient can merge two distinct meanings. `ContextCloneEquivalence` further shows that mutual generator-to-word simulations preserve the quotient up to an actual Cubical isomorphism.

### Theorem 14.1 — meaning count is not a universal edge-cost potential

Without an additional locality bound on primitive edges, \(D\) can decrease by an arbitrarily large amount in one legal transition.

**Proof.** Let \(X\) be any finite set of \(M\) pairwise distinguishable states and adjoin a terminal state \(t\). Add one action \(a\) with

\[
\operatorname{step}(x,a)=t
\]

for every \(x\in X\). Before applying \(a\), the states may have \(M\) distinct meanings; after applying it, every state is literally \(t\), so the realized meaning count is one. The single edge therefore changes \(D\) by \(M-1\). ∎

Hence an exponential lower bound on the number of residual meanings does not by itself imply an exponential lower bound on interaction count. To become a geodesic certificate, a quantity must satisfy the local edge inequality of Part II, Theorem 12.1, for the **actual primitive edges**.

This is not a missing theorem; it is a proved separation between two coordinates:

\[
\boxed{\text{minimal semantic carrier size}\neq\text{metric path length in general}.}
\]

The repository itself keeps these coordinates separate: `AdaptiveResidualAdapter` explicitly states that the carrier relation and adaptive depth are separate cost coordinates.

---

## 15. Exponentially many satisfying vertices can have a constant-state cubical recurrence

Consider the 3CNF family

\[
F_n=\bigwedge_{i=1}^{n-2}(x_i\vee x_{i+1}\vee x_{i+2}).
\]

A Boolean string satisfies \(F_n\) exactly when it contains no substring \(000\).

Let

\[
A_n=\#F_n^{-1}(1).
\]

Take \(A_0=1,A_1=2,A_2=4\).

### Theorem 15.1 — exact tribonacci recurrence

For \(n\ge3\),

\[
\boxed{A_n=A_{n-1}+A_{n-2}+A_{n-3}.}
\]

**Proof.** Every nonempty binary string avoiding \(000\) ends in exactly one of

\[
1,\qquad 01,\qquad 001.
\]

Deleting that final block leaves respectively an arbitrary valid string of length \(n-1,n-2,n-3\). Conversely appending any of these blocks to a valid shorter string cannot create \(000\): the appended block itself contains no \(000\) and begins with at most two zeros before a one. The three cases are disjoint and exhaustive. ∎

Thus

\[
A_3=7,\ A_4=13,\ A_5=24,\ A_6=44,\ldots
\]

and \(A_n\) grows exponentially with \(n\) (the dominant root of \(r^3=r^2+r+1\) is greater than one).

### Theorem 15.2 — only the last two bits are required for the continuation state

When scanning coordinates left-to-right, whether a future suffix remains admissible depends on the past only through the length of the trailing zero-run, truncated to

\[
0,1,2.
\]

**Proof.** A future violation can cross the past/future boundary only by completing three consecutive zeros. The only relevant past datum is therefore whether the prefix ends in no zero, one zero, or two zeros. Any earlier bits are separated from the future by a one or by those last two positions and cannot participate in a new length-three zero block. ∎

### Corollary 15.3 — exponential vertex population coexists with a three-state complete-future carrier

All prefixes with the same trailing-zero state have identical sets of legal continuations. Hence the complete-future quotient of the left-to-right continuation system has at most three live meanings (plus a dead/violated state if one retains already-invalid prefixes).

So here

\[
\#\mathrm{SAT}(F_n)\asymp c\lambda^n
\]

while the exact residual memory remains constant.

This is a second, independent proof that neither surviving-vertex count nor exponential fibre cardinality is a cost lower bound.

---

## 16. Exponentially many distinct intersections can also have constant-order recurrence

For the same sliding family, each violation cube fixes a triple

\[
x_i=x_{i+1}=x_{i+2}=0.
\]

There are exponentially many subsets of clauses and hence exponentially many terms in the raw inclusion–exclusion expansion. Nevertheless Theorem 15.1 computes the final cardinality using a fixed three-term recurrence.

Thus three different exponential shadows have now been separated from geodesic cost by explicit families:

1. \(2^n\) vertices of an \(n\)-cube;
2. \(2^m\) distinct compatible clause intersections in the disjoint-block family;
3. exponentially many satisfying vertices and raw inclusion–exclusion terms in the sliding-window family.

Each admits a compact exact cubical factorization.

---

## 17. The local-potential theorem is the exact exponentiality interface

Part II proved: if \(\Phi\) vanishes on terminal states and every primitive edge obeys

\[
\Phi(u)\le w(u,v)+\Phi(v),
\]

then \(\Phi\) is a lower bound on every terminal path; equality along the native path proves geodesicity.

This theorem turns the vague phrase “forced crossing” into a precise check.

### Theorem 17.1 — a unit-change integer potential gives a counting lower bound

Suppose primitive interactions have unit cost and

\[
|\Phi(u)-\Phi(v)|\le1
\]

for every primitive edge. If terminal states have \(\Phi=0\), every reduction from \(s\) has at least \(\Phi(s)\) interactions.

**Proof.** The Lipschitz inequality implies \(\Phi(u)\le1+\Phi(v)\); apply Theorem 12.1. ∎

### Theorem 17.2 — disjoint local obligations give an additive potential when one edge touches at most one obligation

Let \(O(s)\) be a finite set of unresolved obligations at state \(s\). Assume a primitive edge can remove at most one element of \(O\), and cannot create a terminal while any obligation remains. Put

\[
\Phi(s)=|O(s)|.
\]

Then every terminal reduction has at least \(|O(s)|\) unit interactions.

**Proof.** One edge changes \(|O|\) downward by at most one, so Theorem 17.1 applies. ∎

This is the exact mathematical content that the earlier “every new direction crosses every residual cell” prose was trying to express. The prose was insufficient because it did not exhibit \(O\) or prove the one-edge incidence bound.

### Corollary 17.3 — exponential lower bound from an explicit exponential obligation packing

If a represented family \(P_n\) carries an explicitly constructed obligation set with

\[
|O(P_n)|\ge2^{cn}
\]

and the primitive-incidence condition of Theorem 17.2 is proved, then every reduction costs at least \(2^{cn}\).

This is a theorem, not an open direction. Its application to any concrete family consists exactly of giving the set \(O(P_n)\) and the local incidence proof.

---

## 18. Why “one obligation per assignment” fails immediately

Let \(O\) be the set of Boolean assignments not yet individually examined. Then \(|O|=2^n\), but the hypothesis of Theorem 17.2 is false for the universal cubical machinery: one exact symbolic composition can constrain, fill, identify, or eliminate an entire subcube at once.

The disjoint-block and sliding-window families explicitly witness this failure. A single factorized relation represents exponentially many vertices simultaneously.

Therefore assignment enumeration is not merely a loose argument; it fails the local edge condition required of a geodesic lower-bound potential.

---

## 19. A cube-native obligation is a nonfillable boundary class, not a vertex

The only obligations that survive the preceding controls are **inequivalent boundary classes that no single primitive interaction can jointly discharge**.

Formally, for a state \(s\), take a finite family

\[
\mathcal B(s)=\{\beta_1,\ldots,\beta_M\}
\]

of boundary/fibre distinctions with two proved properties:

1. **necessity:** if \(\beta_j\) remains, the demanded terminal Boolean observation does not descend through the current carrier (a separating completion witnesses the collision);
2. **unit incidence:** one primitive interaction can discharge at most one \(\beta_j\).

Then \(O(s)=\mathcal B(s)\) in Theorem 17.2 and

\[
d_T(s)\ge M.
\]

This is already an exact theorem because it is just Theorem 17.2 with the obligations named geometrically.

Notice what has disappeared: no assignment count, no clause-subset count, no fixed coordinate order, no arbitrary “independence” predicate. The certificate is made of actual nonfillable cubical boundaries plus the actual primitive-incidence law.

---

## 20. Separation witnesses are proof-relevant members of the certificate

For each boundary class \(\beta_j\), necessity can be represented by a pair of completions \(x_j,y_j\) and a future word \(w_j\) such that the current carrier identifies them while

\[
\operatorname{observe}(\operatorname{run}(x_j,w_j))
\ne
\operatorname{observe}(\operatorname{run}(y_j,w_j)).
\]

`FutureSeparation` proves that such a word is exactly a witness of failure of complete-future equality, and `childSep→parentSep` transports the witness backward through a preceding action.

Thus an obligation need not be a scalar flag. It can carry its own separator trace:

\[
\beta_j=(x_j,y_j,w_j,\delta_j).
\]

The exponentiality certificate is therefore itself a proof-relevant cubical object, consistent with the repository’s general “weights → traces” construction.

---

## 21. Exact finite horizon stabilization gives another certificate coordinate

For the bounded relation \(\sim_h\) of `ObservableHorizon`, define

\[
h_*(s)=\min\{h:\sim_h\text{ is action-closed on the formed residual world of }s\}.
\]

Whenever this minimum is formed, Theorem 8.4 gives

\[
\sim_{h_*}=\sim.
\]

For every \(h<h_*\), failure of action closure supplies states \(x_h,y_h\) and an action \(a_h\) such that

\[
x_h\sim_h y_h
\]

but

\[
\operatorname{step}(x_h,a_h)\not\sim_h\operatorname{step}(y_h,a_h).
\]

That failure is a concrete “one more face is visible” witness. It is an exact horizon lower bound for the declared sequential action metric. `AdaptiveResidualAdapter` shows that response-conditioned trees do not alter the underlying complete residual relation, though their depth cost can differ.

Again, horizon and total interaction count are different coordinates. The repository’s insistence on Pareto/non-scalar cost is mathematically necessary here.

---

## 22. Current exact conclusion

The Boolean cube calculation now yields the following theorem chain without any unproved placeholder:

\[
\boxed{
\begin{array}{c}
\text{3-clause}=\text{one codim-3 Boolean subcube}\\
\Downarrow\\
\text{compatible intersections}=\text{partial-assignment unions}\\
\Downarrow\\
\#\mathrm{SAT}=\displaystyle\sum_T(-1)^{|T|}2^{N-r(T)}\\
\Downarrow\\
\text{identical intersections quotient and cancel exactly}\\
\Downarrow\\
\text{product structure can compress exponentially many cells}\\
\Downarrow\\
\text{complete residual equality}=\text{checked greatest future congruence}\\
\Downarrow\\
\text{adaptive trees preserve that same quotient}\\
\Downarrow\\
\text{coordinate charts can change residual width exponentially}\\
\Downarrow\\
\text{therefore a cost lower bound must be local-Lipschitz on primitive edges}\\
\Downarrow\\
\text{nonfillable boundary obligations + unit incidence give exact geodesic lower bounds.}
\end{array}}
\]

The old “forced-crossing certificate” has therefore been replaced by a precise theorem: **an exponentiality certificate is an exponentially large proof-relevant packing of terminal-relevant boundary distinctions together with a proved bound on how many members any primitive interaction can discharge.** The lower bound is then a one-line potential argument, and equality is proved by a native path that discharges at the certified rate.

No claim is made here that a polynomial-size 3SAT family with such an exponential packing has been constructed; equally, no such construction is left as a TODO. The mathematics above says exactly what follows from the current objects and exactly what does not. A later continuation should only add a SAT family if it actually constructs the packing and proves the primitive-incidence theorem in the same text.
