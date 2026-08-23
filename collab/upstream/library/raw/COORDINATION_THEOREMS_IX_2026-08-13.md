# COORDINATION THEOREMS IX — VERIFIABLE RELATIONS AS GENERAL COMPUTATIONAL CONTRACTS
Date: 2026-08-13

Status: exact mathematical lemmas and proofs. Complexity statements use standard finite-string encodings and explicit polynomial-balance hypotheses. No novelty claims.

## 212. Deterministic programs are functional relations

Let \(f:X\to Y\). Its graph
\[
R_f=\{(x,y):y=f(x)\}
\]
is a relation with exactly one admissible output y for every input x.

### Proof
By definition of a function, for each x there exists exactly one f(x). QED.

Thus functions embed into relations as the single-output special case.

## 213. A relation exposes implementation freedom through output fibers

For relation \(R\subseteq X\times Y\), define
\[
R(x)=\{y:R(x,y)\}.
\]
The relation is functional iff every fiber R(x) has cardinality at most one.

### Proof
A relation is the graph of a partial function exactly when no input relates to two distinct outputs. QED.

## 214. Any selector implements a total relation

If every fiber R(x) is nonempty and \(s:X\to Y\) satisfies
\[
s(x)\in R(x)
\]
for every x, then \(R_s\subseteq R\).

### Proof
For every x, \((x,s(x))\in R\). Therefore every graph pair of s lies in R. QED.

Different selectors are distinct implementations of the same admissibility relation.

## 215. Contextual substitutability of relation-respecting implementations

Let \(s_1,s_2:X\to Y\) both satisfy \(R_{s_i}\subseteq R\). Let downstream acceptance depend only on whether \((x,y)\in R\), not on which selector produced y. Then replacing s₁ by s₂ cannot turn an accepted output into a relation-invalid one.

### Proof
Both selectors always return elements of R(x). QED.

## 216. Polynomial-time verifiable relation

Let strings x,y be public boundary values. Call relation R efficiently verifiable if there exists a polynomial-time verifier V and polynomial p such that
\[
R(x,y)\iff \exists w,\ |w|\le p(|x|+|y|),\ V(x,y,w)=1.
\]

This is a definition.

## 217. Deterministic polynomial-time computation induces an efficiently verifiable relation

If f is polynomial-time computable and output length is polynomially bounded, then
\[
R_f(x,y)\iff y=f(x)
\]
is efficiently verifiable with empty witness.

### Proof
Verifier computes f(x) and compares with y in polynomial time. QED.

## 218. Conjunction closure

If R₁ and R₂ on the same public boundary (x,y) are efficiently verifiable, then
\[
R(x,y)=R_1(x,y)\wedge R_2(x,y)
\]
is efficiently verifiable.

### Proof
Use witness pair \((w_1,w_2)\) and run both verifiers. Polynomial witness bounds add and polynomial runtimes add. QED.

## 219. Disjunction closure

If R₁,R₂ are efficiently verifiable, then
\[
R=R_1\vee R_2
\]
is efficiently verifiable.

### Proof
Witness consists of one selector bit b plus a witness for R_b. Run the selected verifier. QED.

## 220. Parallel-product closure

If
\[
R_1:X_1\rightsquigarrow Y_1,\qquad
R_2:X_2\rightsquigarrow Y_2
\]
are efficiently verifiable, then
\[
(R_1\otimes R_2)((x_1,x_2),(y_1,y_2))
\iff
R_1(x_1,y_1)\wedge R_2(x_2,y_2)
\]
is efficiently verifiable.

### Proof
Theorem 218 with paired encodings. QED.

## 221. Existential projection closure

Let R(x,y,z) be efficiently verifiable and suppose any admissible z has polynomial length in \(|x|+|y|\). Define
\[
\bar R(x,y)\iff \exists z\,R(x,y,z).
\]
Then \(\bar R\) is efficiently verifiable.

### Proof
The witness for \(\bar R\) is \((z,w)\), where w verifies R. The assumed polynomial bound on z plus the original polynomial witness bound yields a polynomial total witness. The verifier runs V_R. QED.

## 222. Bounded relational composition preserves efficient verifiability

Let
\[
R:X\rightsquigarrow Y,\qquad
S:Y\rightsquigarrow Z
\]
be efficiently verifiable. Assume that whenever
\[
(S\circ R)(x,z)
\]
holds, there exists some intermediate y whose encoding length is polynomially bounded in \(|x|+|z|\), and corresponding witnesses are polynomially bounded as required.

Then
\[
(S\circ R)(x,z)\iff \exists y\,R(x,y)\wedge S(y,z)
\]
is efficiently verifiable.

### Proof
Witness is \((y,w_R,w_S)\). Verify R(x,y) and S(y,z). All witness lengths and runtimes are polynomial by hypothesis. QED.

## 223. Finite DAGs of bounded verifiable relations collapse to one bounded verifiable boundary relation

Let a finite DAG have public boundary variables b and internal variables z. Suppose:
1. every local constraint is efficiently verifiable;
2. the total encoding length of all internal values and local witnesses is polynomially bounded in |b|;
3. the number of vertices is polynomially bounded in |b|.

Then the existential boundary relation
\[
R_{\partial}(b)\iff \exists z\ \bigwedge_v R_v
\]
is efficiently verifiable.

### Proof
Witness consists of every internal value and every local witness. Its total size is polynomial by assumptions. Verify all local constraints; polynomially many polynomial-time checks remain polynomial. QED.

## 224. Arbitrarily expensive witness discovery is compatible with cheap verification

The definition of efficient verifiability imposes a runtime bound on V, not on the algorithm used to find w. Therefore an efficiently verifiable relation can have witnesses whose discovery requires computational resources far larger than verification.

### Proof
Directly from the quantifier structure
\[
R(x,y)\iff \exists w\,V(x,y,w)=1.
\]
No witness-generation algorithm occurs in the definition. QED.

## 225. Search and verification complexities are logically distinct

There exist relations with trivial verification but exponentially large naive search spaces.

### Proof
Given a Boolean formula F on n variables, relation
\[
R(F,a)\iff a\text{ satisfies }F
\]
is verified by evaluating F on a in time polynomial in |F|. The space of possible assignments has size \(2^n\). This demonstrates that verification complexity and brute-force search-space size are distinct. QED.

This does not prove lower bounds for all solving algorithms; it proves the structural separation.

## 226. Proof-carrying computation localizes trust to verifier soundness

Let an untrusted solver output (y,w). Suppose verifier V is sound:
\[
V(x,y,w)=1\Rightarrow R(x,y).
\]
Then acceptance of V implies relation-valid output regardless of the solver's internal algorithm or objective.

### Proof
This is exactly the soundness implication. QED.

## 227. Solver alignment is unnecessary for relation validity when sound verification is complete at the boundary

Suppose every externally relevant safety/correctness requirement is included in R and V is sound for R. Then a malicious solver cannot cause the verifier to accept an externally invalid output unless verifier soundness fails.

### Proof
If V accepts, soundness gives R. By hypothesis R contains every externally relevant requirement. Hence accepted output is externally valid. QED.

This statement is only as strong as the completeness of the boundary specification.

## 228. Omitted requirements cannot be recovered from verifier soundness

If desired property P is not implied by R, then there exists in principle some relation-valid output that may violate P whenever
\[
\exists x,y:\ R(x,y)\wedge\neg P(x,y).
\]
A sound verifier for R does not exclude that output.

### Proof
Soundness certifies only R. The displayed witness is R-valid but P-invalid. QED.

Thus specification completeness and verifier soundness are independent obligations.

## 229. Exact verification converts behavioral trust into specification trust

Under Theorem 227, external correctness depends on:
1. whether R expresses the intended requirements;
2. whether V soundly verifies R;
not on whether the solver follows a trusted internal procedure.

### Proof
Accepted outputs are characterized by V; soundness maps acceptance to R. Solver internals do not appear in the implication. QED.

## 230. Functional refinement recovers ordinary programming

If R is total and functional, then there exists a unique function f with
\[
R=R_f.
\]

### Proof
For every x there is exactly one y with R(x,y); define f(x)=y. QED.

Hence program semantics is the zero-implementation-freedom limit of relational contract semantics.

## 231. A relation may encode optimization without prescribing an optimizer

Let feasible set F(x) and objective U(x,y) be given. Define
\[
R_{\mathrm{opt}}(x,y)
\iff
y\in F(x)
\ \wedge\
\forall y'\in F(x),\ U(x,y)\ge U(x,y').
\]
Any algorithm returning any optimal y implements the same relation.

### Proof
Relation membership depends only on global optimality, not on the algorithm. Every optimizer's output lies in the argmax fiber. QED.

Efficient verification of this relation is a separate question and is not implied by the definition.

## 232. Approximation contracts are relations

For tolerance ε≥0 define
\[
R_\epsilon(x,y)
\iff
y\in F(x)
\ \wedge\
U^*(x)-U(x,y)\le\epsilon.
\]
Then
\[
0\le\epsilon_1\le\epsilon_2
\implies
R_{\epsilon_1}\subseteq R_{\epsilon_2}.
\]

### Proof
Any output within ε₁ of optimum is also within larger tolerance ε₂. QED.

Thus relaxing a contract enlarges its admissible implementation/output fiber monotonically.

## 233. Stronger specifications shrink fibers

If predicates satisfy
\[
R_1(x,y)\Rightarrow R_2(x,y)
\]
for every x,y, then
\[
R_1(x)\subseteq R_2(x)
\]
for every x.

### Proof
Pointwise implication. QED.

Therefore specification strength and implementation freedom are oppositely ordered.

## 234. Specification conjunction is fiber intersection

For relations R,S on X×Y,
\[
(R\wedge S)(x)=R(x)\cap S(x).
\]

### Proof
y satisfies conjunction iff it lies in both fibers. QED.

## 235. Specification disjunction is fiber union

\[
(R\vee S)(x)=R(x)\cup S(x).
\]

### Proof
Immediate. QED.

## 236. Existential abstraction enlarges external indistinguishability

Let detailed relation R(x,y,z) and external projection
\[
\bar R(x,y)\iff\exists zR(x,y,z).
\]
Different internal z values witnessing the same (x,y) are indistinguishable to any context whose semantics depends only on \(\bar R\).

### Proof
The external boundary predicate records only existence of some z, not which z. QED.

## 237. Universal abstraction imposes robustness against all hidden states

Define
\[
R_\forall(x,y)\iff \forall z\in Z(x,y),\ P(x,y,z).
\]
Then \(R_\forall\) is stronger than the existential version
\[
R_\exists(x,y)\iff \exists z\in Z(x,y),\ P(x,y,z)
\]
whenever Z is nonempty:
\[
R_\forall\Rightarrow R_\exists.
\]

### Proof
If P holds for every z and at least one z exists, then P holds for some z. QED.

Existential contracts certify existence of a valid realization; universal contracts certify robustness across all admissible hidden realizations.

## 238. Composition preserves exact safety implications

Suppose
\[
R(x,y)\Rightarrow P(x,y)
\]
and
\[
S(y,z)\Rightarrow Q(y,z).
\]
Then any composite witness for \((S\circ R)(x,z)\) supplies an intermediate y satisfying both P(x,y) and Q(y,z).

### Proof
Composite validity gives some y with R(x,y) and S(y,z); apply each implication. QED.

## 239. End-to-end properties require compositional closure conditions

Let desired end-to-end property T(x,z) be given. Local safety properties P(x,y),Q(y,z) imply T for every valid composite iff
\[
\forall x,y,z,\quad
P(x,y)\wedge Q(y,z)\Rightarrow T(x,z).
\]

### Proof
This implication is exactly the condition under which every intermediate-valid pair yields the end-to-end property. Necessity follows by considering arbitrary triples satisfying P,Q; sufficiency is direct. QED.

Thus local verification composes into global safety only when the desired invariant is closed under the composition rule.

## 240. Probabilistic local soundness errors add by union bound

Suppose a global certificate consists of k local probabilistic checks. For an invalid global object, let E_i be the event that local check i falsely accepts its invalid local condition, with
\[
P(E_i)\le\epsilon_i.
\]
If global false acceptance implies at least one E_i, then
\[
P(\text{global false acceptance})
\le
\sum_{i=1}^k\epsilon_i.
\]

### Proof
By hypothesis global false acceptance is contained in \(\bigcup_iE_i\). Apply the union bound. QED.

No independence assumption is needed.

## 241. Independent repetition multiplies soundness error

If a probabilistic verifier falsely accepts an invalid statement with probability at most ε per run, and k repetitions use independent verifier randomness and accept only if every run accepts, then false-accept probability is at most
\[
\epsilon^k.
\]

### Proof
For an invalid statement, each acceptance event has probability ≤ε. Independence gives probability of intersection equal to product ≤ε^k. QED.

## 242. Parallel verification can preserve wall-clock depth under unlimited processors

Let k independent deterministic verifiers each run in depth/time at most T and have no data dependencies. With k processors they can all be evaluated in parallel in wall-clock depth at most T plus aggregation depth.

### Proof
Start all verifiers simultaneously. The slowest finishes by T. Combining k Boolean outputs by a balanced AND tree requires depth \(\lceil\log_2 k\rceil\) with binary gates, or constant depth with unbounded fan-in. QED.

Thus logical conjunction does not intrinsically require serial replay.

## 243. Verification DAG critical path bounds parallel verification depth

Let verification dependencies form a DAG. Associate each vertex v runtime t_v. With unlimited processors, any schedule respecting dependencies has completion time at least
\[
L=\max_{\text{directed paths }P}\sum_{v\in P}t_v,
\]
and a greedy earliest-start schedule achieves L when communication/processor overhead is ignored.

### Proof
Every path is sequentially constrained, giving lower bound L. In earliest-start scheduling, each vertex completes at time equal to its weight plus the maximum completion time of its predecessors; induction over a topological order shows each completion time equals the maximum weighted path ending there. The maximum over sinks is L. QED.

Therefore the intrinsic parallel depth is the causal critical path, not the total number of verified operations.

## 244. Independent proof branches do not increase intrinsic logical depth

If a proof DAG consists of k branches of depth at most d feeding one final conjunction node, then parallel proof-checking depth is \(d+O(\log k)\) under bounded-fan-in aggregation.

### Proof
Check branches concurrently, taking depth d. Combine their acceptance bits by a balanced tree. QED.

## 245. Total work and causal depth are independent complexity measures

There exist DAG computations with:
1. work W=n and depth 1;
2. work W=n and depth n.

### Proof
(1) n independent unit tasks.
(2) a chain of n unit tasks.
QED.

Therefore charging/coordination solely by total operation count conflates intrinsically parallel and intrinsically sequential computation.

## 246. Relation semantics quotients away solver work while certificates retain correctness evidence

Let solvers A,B produce the same boundary pair (x,y) satisfying R but use different internal work histories H_A,H_B. Relation semantics identifies them at the boundary, while a provenance layer may retain H_A,H_B separately.

### Proof
R evaluates only (x,y), so both have identical extensional contract status. Distinct histories remain distinct under any provenance representation that records their internal derivations. QED.

This formally separates semantic validity from computational provenance.
