# Equal formation costs do not determine future option value

The cache-relative transition theorem repaired marginal construction cost by
including the retained cache (K). A tempting recompression is to retain only
current scalar totals: additions spent, number of intermediates retained, and
perhaps query count. The smallest fixed-policy example kills that move.

## Exact counterexample

Under the left-to-right binary policy, the trace for (5) is

\[
1,2,4,5,                                               \tag{1}
\]

and the trace for (6) is

\[
1,2,3,6.                                               \tag{2}
\]

Starting from (K_0=\{1\}), both require three additions and leave caches of
cardinality four:

\[
K_5=\{1,2,4,5\},\qquad K_6=\{1,2,3,6\}.               \tag{3}

Thus every present vector consisting of one formation request, additions
spent, and retained-cardinality agrees. But the caches are incomparable, and
their future costs cross:

\[
\begin{array}{c|cc}
&\text{form }3&\text{form }4\cr
\hline
K_5&1&0\cr
K_6&0&1.
\end{array}                                             \tag{4}

Neither formation dominates the other. No function of the shared present
scalar vector can return both rows of (4).

This is not an artifact of shortest-chain ambiguity: (1)--(2) are the traces
of the already declared deterministic policy.

## Exact sufficient observable for a future family

For a target (n), let (D(n)) be its labeled binary-prefix chain. Under the
fixed policy, marginal work from cache (K) is the length of the suffix of
(D(n)) after its latest member lying in (K). Consequently, for a declared
future family (F), the profile

\[
V_F(K)=\bigl(\operatorname{cost}_K(n)\bigr)_{n\in F}    \tag{5}


factors through the labeled incidences (K\cap D(n)), (n\in F). Cache
cardinality does not determine these incidences. The exact cache (K) is a
universal carrier across arbitrary future targets; the smaller family-relative
carrier is the tuple of latest-prefix positions.

**Proposition.** For fixed (F) and the deterministic policy, two caches have
the same future profile exactly when their latest cached prefix position in
each (D(n)), (n\in F), agrees.

**Proof.** The transition rule defines cost as chain length minus that latest
position. Equality of positions gives equality of costs. Conversely equality
of costs on a fixed chain gives equality of the latest positions. ∎

Thus option value is task-relative but exact. It is neither an intrinsic scalar
nor a vague strategic judgment.

## Relation to the swarm return

`INCREMENTAL_WITNESS_FOREST` stores action-labeled predecessor pointers rather
than only proof counts; removal invalidates proofs according to which roots
and pointers they use. Equations (3)--(5) are the arithmetic construction
counterpart. In both cases equal size can conceal different dependency
support, and exact future reuse depends on labeled incidence.

The shared operation is:

```text
accepted trace
→ retain labeled support
→ future request intersects its dependency path with support
→ reuse the surviving suffix/pointer certificate
```

This is an earned common object, not an analogy: both are finite predecessor
DAGs with replay and support-sensitive invalidation.

## Formation consequence

The counterexample forces a Pareto frontier even before assigning exchange
rates. (K_5) and (K_6) have equal current resources and incomparable future
profiles on (F=\{3,4\}). A router preserving only current scalar costs must
merge them and will necessarily misprice at least one future request.

The transferable observable is exact labeled dependency support—or its
task-relative projection to latest-prefix positions—not cache size.

## Rigor boundary

Proved: the counterexample, table (4), and the proposition for the fixed binary
policy. `machinery/cache_relative_formation.py` executes the future profile and
tests incomparability.

Not proved: optimal retention under bounded memory; a minimal carrier across
arbitrary addition-chain choices; tractability of choosing witness-forest
pointers or construction traces for maximal future reuse; or any probability
distribution over future tasks.
