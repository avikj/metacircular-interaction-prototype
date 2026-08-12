# Incremental refinement installs a reusable witness forest

In the synchronous pair graph of `INCREMENTAL_WITNESS_PAIR_GRAPH`, run reverse
BFS from seeds `(x,y)` that disagree immediately on a new observation. For
each first-reached nonseed pair `u`, retain one pointer
\[
u\xrightarrow{a}v                                             \tag{1}
\]
where `v` is one BFS layer closer to a seed. At a seed retain the differing
observation label.

**Theorem.** These pointers form an acyclic proof forest (a DAG if identical
suffix proofs are shared) with:

1. replay from `u` yielding a valid distinguishing word and observation;
2. pointer depth equal to shortest distinguishing-word length;
3. old inter-block witness certificates unchanged;
4. chosen-certificate invalidation under removal of observation `n` confined
   exactly to nodes whose pointer path ends at an `n`-seed.

*Proof.* BFS distance decreases strictly along every pointer, proving
acyclicity and shortest depth. Following labels sends the synchronous pair
along graph edges to its seed, where the stored observation differs, proving
replay. Old witnesses use old observations and remain valid under addition.
Finally a chosen proof depends on its terminal observation and pointer suffix
only; removing `n` invalidates precisely paths rooted at `n`-seeds. ∎

This separates two costs. Access cost is pointer replay length. Validation
cost includes checking each stored transition and the terminal observation.
Shared suffixes reduce stored proof structure without changing witness length.

Withdrawal may leave an alternative certificate through another seed; the
theorem identifies invalidated chosen proofs, not necessarily pairs that must
merge. Repair reruns reverse search from surviving seeds only in the affected
dependency cone.

## Rigor boundary

Finite deterministic systems and explicit pair graphs are assumed. No claim
is made that one-pointer forests minimize total certificate storage; choosing
parents for maximum suffix sharing is a separate optimization.

