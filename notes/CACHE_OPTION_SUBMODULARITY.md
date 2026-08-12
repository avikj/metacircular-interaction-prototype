# Future work saved by a fixed trace cache is submodular

Let `F` be a finite family of future construction targets.  Each target `t`
has a fixed trace

\[
D_t=(v_{t,0},v_{t,1},\ldots,v_{t,\ell_t}).
\]

For a retained cache `K`, define the saved suffix work

\[
s_t(K)=\max\bigl(\{i:v_{t,i}\in K\}\cup\{0\}\bigr).     \tag{1}
\]

Let nonnegative workload weights be `w_t`, and put

\[
S(K)=\sum_{t\in F}w_t s_t(K).                            \tag{2}
\]

**Theorem.** `S` is a normalized monotone submodular set function.

*Proof.* For one target, assign each possible cached value `x` the weight

\[
a_t(x)=\max\bigl(\{i:v_{t,i}=x\}\cup\{0\}\bigr).
\]

Then `s_t(K)=max_{x∈K} a_t(x)`.  If `A⊆B` and `x∉B`, the marginal gain is

\[
\max(0,a_t(x)-s_t(A))\ge
\max(0,a_t(x)-s_t(B)),
\]

because `s_t(A)≤s_t(B)`.  Thus each `s_t` is monotone submodular.
Nonnegative sums preserve both properties.  The empty cache has value zero by
the convention in (1). □

Under a cardinality budget `|K|≤B`, the standard greedy algorithm that adds
the value with largest current marginal gain therefore achieves at least
`1-1/e` of optimum.  This invokes the classical Nemhauser--Wolsey--Fisher
theorem; the submodularity proof above is self-contained.

The result does not make the cache state scalar.  Equal values of `S` can hide
different future profiles and different marginal gains.  The labeled support
remains the state needed for subsequent updates.

## Exactness boundary

If all traces form one rooted tree and retained nodes cover descendant suffix
work, stronger dynamic programs may exist.  Generic deterministic construction
traces need not be laminar: distinct histories can meet at the same numerical
value or reuse values non-prefixwise.  The theorem therefore gives a general
approximation law without claiming a universal exact tree optimizer.

The same proof applies to chosen witness paths when utility is the amount of
replay suffix covered.  It does not price alternative certificates after
observation withdrawal; that requires the larger shortest-proof DAG.
