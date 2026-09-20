# Exact Boolean-cube derivations for SAT

**Date:** 2026-09-17  
**Role:** continuation/correction of `research/SAT_CUBICAL_GEODESIC_NOTES_20260916.md`.  
**Discipline:** every numbered statement below is proved in the text or is explicitly identified as an already-checked repository theorem. There is no future-work list.

The purpose of this note is to push the Boolean/cubical calculation itself rather than turn available consequences into obligations.

---

## 1. The Boolean cube is the vertex cube

Write

\[
Q_N=\{0,1\}^N.
\]

For SAT coverage, this is the **Boolean vertex cube**. A partial assignment is naturally a combinatorial subcube of the vertex set. If one geometrically realizes it as a face of the continuous cube \([0,1]^N\), then a union of proper codimension-three faces cannot cover the continuous interior. Therefore the exact SAT statement is coverage of \(Q_N\), equivalently coverage of the 0-skeleton, not coverage of the continuous topological cube.

This removes an ambiguity in the previous note while preserving all coordinate/fibre calculations.

### Theorem 1.1 — cardinality of a partial-assignment cube

Let \(p:D\to\{0,1\}\) with \(D\subseteq[N]\), and

\[
B_p=\{x\in Q_N:x|_D=p\}.
\]

Then

\[
B_p\cong Q_{N-|D|},\qquad |B_p|=2^{N-|D|}.
\]

**Proof.** Coordinates in \(D\) are fixed and every coordinate outside \(D\) is free. Restriction to \([N]\setminus D\) and extension by \(p\) are inverse maps. ∎

### Theorem 1.2 — exact intersection law

For partial assignments \(p:D\to2\) and \(q:E\to2\),

\[
B_p\cap B_q=
\begin{cases}
B_{p\cup q},&p|_{D\cap E}=q|_{D\cap E},\\
\varnothing,&\text{otherwise}.
\end{cases}
\]

In the compatible case,

\[
|B_p\cap B_q|=2^{N-|D\cup E|}.
\]

**Proof.** A vertex lies in both exactly when it extends both partial functions. Such an extension exists iff they agree on their common domain, in which case extending both is exactly extending their union. Apply Theorem 1.1. ∎

### Corollary 1.3 — overlap is exactly shared bits

Use normalized counting measure \(\mu(A)=|A|/2^N\). For compatible \(p,q\),

\[
\mu(B_p)=2^{-|D|},\qquad
\mu(B_q)=2^{-|E|},
\]

and

\[
\mu(B_p\cap B_q)
=2^{-|D\cup E|}
=\mu(B_p)\mu(B_q)2^{|D\cap E|}.
\]

Thus every agreeing shared coordinate contributes exactly one factor of two relative to independent multiplication. If the shared coordinates conflict, the intersection is zero.

Equivalently, with

\[
I(B_p):=-\log_2\mu(B_p)=|D|,
\]

compatible composition obeys the exact bit identity

\[
I(B_p\cap B_q)=I(B_p)+I(B_q)-|D\cap E|.
\]

There is no separate information-theoretic story here: it is the rank formula for the same Boolean cube.

---

## 2. One 3-clause

Let

\[
C=\ell_i\vee\ell_j\vee\ell_k
\]

with three distinct variables. There is a unique assignment

\[
v_C:\{i,j,k\}\to2
\]

on which all three literals are false.

### Theorem 2.1 — violation is one codimension-three Boolean subcube

The violating set is

\[
V_C=B_{v_C}\cong Q_{N-3},
\]

so

\[
|V_C|=2^{N-3},\qquad \mu(V_C)=2^{-3}=1/8.
\]

**Proof.** Violation fixes exactly the three clause coordinates to their unique falsifying values. ∎

### Theorem 2.2 — the clause observation loses two visible bits

As a map

\[
c:Q_3\to Q_1,
\]

the input carrier has \(\log_2 8=3\) bits and the output carrier has \(\log_2 2=1\) bit. Hence the visible carrier dimension drops by exactly

\[
3-1=2\text{ bits}.
\]

This is distinct from the three-bit surprisal \(-\log_2(1/8)=3\) of the unique violating fibre under the uniform distribution. The previous conversation’s “two bits” refers to the former quantity.

### Repository identification

The already-checked fibre completion applies directly:

\[
Q_3\simeq\sum_{b:Q_1}\operatorname{fib}_c(b).
\]

The visible two-bit collapse therefore does not destroy those distinctions in the conservative total object; they become fibre coordinates.

---

## 3. A whole 3CNF is an exact union-of-subcubes problem

Let

\[
F=\bigwedge_{\alpha=1}^m C_\alpha
\]

and let \(p_\alpha\) be the three-coordinate violating partial assignment of clause \(C_\alpha\). Put

\[
V_\alpha=B_{p_\alpha}.
\]

### Theorem 3.1 — De Morgan coverage

\[
F(x)=0\iff x\in\bigcup_{\alpha=1}^mV_\alpha.
\]

Hence

\[
F\text{ is UNSAT}\iff \bigcup_{\alpha=1}^mV_\alpha=Q_N.
\]

**Proof.** \(F(x)=0\) iff at least one clause is false; clause \(\alpha\) is false exactly on \(V_\alpha\). ∎

### Theorem 3.2 — exact SAT indicator

Let \(v_\alpha(x)\in\{0,1\}\) be the indicator of \(V_\alpha\). Then

\[
\mathbf1_{F(x)=1}=\prod_{\alpha=1}^m(1-v_\alpha(x)).
\]

**Proof.** Every factor is one exactly when its clause is not violated. Their product is one exactly when no clause is violated. ∎

This is the whole Boolean proposition as a product of local cube-complements.

---

## 4. Exact intersection expansion

For \(T\subseteq[m]\), say \(T\) is **compatible** when the partial assignments \(\{p_\alpha:\alpha\in T\}\) agree wherever their domains overlap. For compatible \(T\), define

\[
p_T=\bigcup_{\alpha\in T}p_\alpha,
\qquad
r(T)=|\operatorname{dom}p_T|.
\]

Put \(r(\varnothing)=0\).

### Theorem 4.1 — every clause intersection is either empty or one cube

\[
\bigcap_{\alpha\in T}V_\alpha=
\begin{cases}
B_{p_T},&T\text{ compatible},\\
\varnothing,&T\text{ incompatible}.
\end{cases}
\]

In the compatible case,

\[
\left|\bigcap_{\alpha\in T}V_\alpha\right|=2^{N-r(T)},
\qquad
\mu\left(\bigcap_{\alpha\in T}V_\alpha\right)=2^{-r(T)}.
\]

**Proof.** Induct Theorem 1.2 over \(T\). ∎

### Corollary 4.2 — exact redundancy of a compatible clause family

If \(|T|=t\), the clauses individually mention \(3t\) coordinate occurrences. Their joint violation fixes only \(r(T)\) distinct coordinates. Therefore

\[
3t-r(T)
\]

is exactly the repeated-coordinate redundancy in that compatible intersection, counted with multiplicity beyond first occurrence.

No independence approximation is involved.

### Theorem 4.3 — exact satisfying-assignment count

\[
\boxed{
\#\mathrm{SAT}(F)
=
\sum_{\substack{T\subseteq[m]\\T\text{ compatible}}}
(-1)^{|T|}2^{N-r(T)}.
}
\]

Equivalently, the satisfying fraction is

\[
\boxed{
\mu(F^{-1}(1))
=
\sum_{\substack{T\subseteq[m]\\T\text{ compatible}}}
(-1)^{|T|}2^{-r(T)}.
}
\]

**Proof.** Expand Theorem 3.2:

\[
\prod_\alpha(1-v_\alpha)
=
\sum_{T\subseteq[m]}(-1)^{|T|}\prod_{\alpha\in T}v_\alpha.
\]

Sum over \(x\in Q_N\). The product of indicators is the indicator of the intersection. Apply Theorem 4.1; incompatible terms contribute zero. ∎

### Corollary 4.4 — exact UNSAT equation

\[
\boxed{
F\text{ UNSAT}
\iff
\sum_{\substack{T\subseteq[m]\\T\text{ compatible}}}
(-1)^{|T|}2^{-r(T)}=0.
}
\]

This is a single exact equation in the cubical incidence data.

---

## 5. Quotient the expansion by identical intersections

Different clause subsets can produce the same partial assignment \(p_T\). They are not distinct cubical states and should be combined immediately.

Let \(\mathcal P_F\) be the finite set of partial assignments obtainable as compatible unions of violating clause assignments, including the empty assignment. Define

\[
a_F(p)=
\sum_{\substack{T\subseteq[m]\text{ compatible}\\p_T=p}}
(-1)^{|T|}.
\]

### Theorem 5.1 — intersection-quotient formula

\[
\boxed{
\#\mathrm{SAT}(F)
=
\sum_{p\in\mathcal P_F}a_F(p)2^{N-|\operatorname{dom}p|}.
}
\]

**Proof.** Partition the terms of Theorem 4.3 by the value of \(p_T\). Every term in a block has the same exponent because it has the same domain. ∎

### Corollary 5.2 — exact cancellation

If \(a_F(p)=0\), the entire family of syntactic clause subsets whose compatible union is \(p\) contributes nothing to the final count. It is algebraically absent after quotienting. Thus counting clause subsets before this quotient can overstate the represented distinction arbitrarily.

---

## 6. A decisive control: exponentially many intersections can be completely factored

Take \(m\) clauses on pairwise disjoint triples of variables. For concreteness,

\[
C_j=x_{3j-2}\vee x_{3j-1}\vee x_{3j}.
\]

Every violating assignment sets its own triple to \(000\).

### Theorem 6.1 — all \(2^m\) clause intersections are distinct and compatible

For every \(T\subseteq[m]\),

\[
r(T)=3|T|,
\]

and \(T\mapsto p_T\) is injective. Hence the intersection family has exactly \(2^m\) members including the whole cube.

**Proof.** The domains are disjoint, so compatibility is automatic and the union domain has size \(3|T|\). The union domain itself recovers \(T\). ∎

### Theorem 6.2 — nevertheless the satisfying set is a direct product

Each triple admits exactly seven satisfying local vertices. Therefore

\[
F^{-1}(1)
=
\prod_{j=1}^m(Q_3\setminus\{000\}),
\]

and

\[
\boxed{\#\mathrm{SAT}(F)=7^m.}
\]

**Proof.** The clauses use disjoint coordinates, so satisfying one block imposes no condition on any other block. Cartesian multiplication gives \(7^m\). ∎

### Corollary 6.3 — the full exponential inclusion–exclusion collapses to one binomial identity

Theorem 4.3 becomes

\[
\#\mathrm{SAT}(F)
=
\sum_{t=0}^m\binom mt(-1)^t2^{3m-3t}
=(8-1)^m
=7^m.
\]

Thus **even \(2^m\) pairwise distinct compatible cubical intersections do not certify exponential reduction cost**. Their whole incidence pattern can be one product.

This directly kills the insufficient version of the “forced-crossing certificate” in the previous note. Pairwise nonidentifiability and doubling of represented vertices/cells are not enough; product structure can carry all of them without expansion.

---

## 7. Exact section calculus

Let \(S\subseteq Q_N\) be any Boolean subset and choose coordinate \(i\). Define its two sections

\[
S_b=\{y\in Q_{N-1}:\operatorname{insert}_i(b,y)\in S\},\qquad b\in\{0,1\}.
\]

### Theorem 7.1 — exact reconstruction from opposite sections

\[
S=(\{0\}\times_i S_0)\;\dot\cup\;(\{1\}\times_i S_1).
\]

The union is disjoint.

**Proof.** Every Boolean vertex has a unique \(i\)-th bit. ∎

### Corollary 7.2 — exact irrelevance criterion

Coordinate \(i\) is absent from membership in \(S\) exactly when

\[
S_0=S_1.
\]

In that case

\[
S\cong Q_1\times S_0.
\]

**Proof.** If the sections agree, membership is independent of the inserted bit. Conversely, independence makes the two sections equal pointwise. ∎

### Corollary 7.3 — exact forced-bit criterion

If \(S_0=\varnothing\) and \(S_1\neq\varnothing\), every point of \(S\) has bit \(i=1\); symmetrically for \(S_1=\varnothing\).

This is the cube statement underlying forced Boolean coordinates; no separate propagation vocabulary is needed.

---

## 8. Residual cubes and the checked minimal future quotient

Fix an order of coordinate revelations. A partial assignment \(p\) determines a residual Boolean subset/function on the unrevealed coordinates by sectioning. Two prefixes should be identified exactly when **all remaining continuations produce the same final Boolean observation**.

That relation is not being invented here. It is exactly the already-checked `MyhillNerodeMinimalMachine.NerodeCongruence` after instantiating:

- state = current residual Boolean section;
- action = reveal/fix a remaining coordinate according to the declared action interface;
- observation = the final Boolean observable available at the state;
- future word = a finite sequence of further coordinate actions.

The repository proves:

1. future equality is a behavioral congruence;
2. it is the **greatest** observation-compatible congruence;
3. the set quotient `Meaning = X / NerodeCongruence` is effective;
4. its complete behavior map is injective;
5. every behavior-preserving congruence quotient maps uniquely onto it.

Therefore the correct shared residual carrier for this declared cubical action system is already the checked minimal fully abstract quotient. Syntactically different residual sections with