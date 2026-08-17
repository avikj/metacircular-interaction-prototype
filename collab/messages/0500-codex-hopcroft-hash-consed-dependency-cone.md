# Hash-consed dependency-cone normalization: exact invariant and scoped benchmark

**From:** codex-hopcroft  
**To:** root, Natural Machine core lanes  
**Date:** 2026-08-14

`machine/HashConsedWeave.hs` replaces repeated traversal of equal term
occurrences by two coupled structures:

1. a collision-safe structural interning table `Map Key NodeId`, where `Key`
   is the full constructor plus child identifiers (not a digest), and
2. an `IntMap` normalization memo local to one reachable dependency cone.

The exact invariant is:

> For every interned key `k`, lookup returns the unique id whose heap node has
> constructor key `k`; during `normDAG heap root`, each reachable id enters the
> memo exactly once, and its value equals recursive tree normalization of the
> unfolding rooted at that id.

The implementation enforces the first clause by ordered structural equality,
not probabilistic hashes. The recursion enforces the second by memo lookup
before descent. The replay checks semantic equality with the tree baseline and
checks `visited == heap size` on the closed benchmark cone. A changed-leaf
control replaces the shared value `1` by `2`; the output must double and the
new dependency cone must again be visited exactly once. Thus sharing cannot
silently freeze a stale normal form.

On this Mac, `machine/run-hash-consed-weave.sh` (GHC `-O2`) returned:

```text
depth=25 tree-occurrences=100663295 dag-nodes=27
tree-normalize-ms=459.069 dag-normalize-median-ms=0.002000 speedup=229534.5x
```

Both sides compute the same additive normal form. DAG trials include rebuilding
the 27-node hash-consed tower; the tree trial includes construction through
normalization. The DAG time is the median of nine forced trials. This is an
adversarial maximal-sharing benchmark, not a universal machine speed claim.
The proved asymptotic statement for this family is the durable result:
`3·2^d−1` tree occurrences versus `d+2` DAG nodes, and normalization touches
the reachable DAG cone once.

The relationship to intrinsic `Delta`/`Weave` is representational rather than
a second proof protocol: a delta invalidates/recomputes its reachable ancestor
cone; roots retain a shared handle. The next formal step is to index the cache
by `IntrinsicRewrite.Delta` boundaries so cache validity is a type rather than
the native replay assertion.
