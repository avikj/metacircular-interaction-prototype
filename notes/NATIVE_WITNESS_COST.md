# Native complete-witness cost and the replay-prefix boundary

Status: **Lean-checked on a supplied finite reduced DFA chart.**  This note
prices the independent native construction from R0071 and proves a boundary
for any future shared implementation.  It does not claim that a shared forest
has been constructed.

## 1. Inputs retained from R0071

Let `M` be a DFA with finite linearly ordered state type `X`, decidable
acceptance, a complete finite alphabet enumeration, and a proof that complete
future equality implies literal equality of chart states.  Write

```text
n = Fintype.card X.
```

R0071 schedules one orientation of every unordered unequal state pair, so the
schedule has exactly `choose(n,2)` entries.  Each entry runs the checked
visited synchronous-pair traversal and retains a globally shortest separating
word.  Duplicate words are identified in the final finite language.

## 2. Independent-search expansion price

`aggregateVisitedPairExpansions` sums
`reachableStatePairCount M alphabet left right` over the exact strict-pair
schedule.  Each summand is the number of pair states actually retained by that
query, not the size of the ambient square.  The existing per-query theorem
gives

```text
reachableStatePairCount <= n^2.
```

Summing and using Mathlib's exact strict-pair count proves

```text
aggregateVisitedPairExpansions <= choose(n,2) * n^2.
```

This is a baseline for independent product searches.  It does not credit a
prefix or state visited by two different roots only once, and therefore is not
an implementation of the shared forest proposed after R0071.

## 3. Retained-language length price

Every word in the deduplicated `completeWords` language is the globally
shortest word for at least one strict pair.  The finite product monitor already
proves the existence of a separator of length strictly below `n^2`; global
minimality transfers that strict bound to the retained word:

```text
word in completeWords  ->  word.length < n^2.
```

Together with `completeWords.card <= choose(n,2)`, summing lengths proves

```text
totalCompleteWordLength <= choose(n,2) * n^2.
```

The total is computed after word deduplication.  It prices stored symbols, not
the work required to discover a duplicate, the order in which words are
installed, or the height of an adaptive distinguishing tree.

## 4. Exact Mathlib adapter: suffix reuse needs a prefix

Mathlib's DFA theorem

```text
DFA.evalFrom_of_append:
  M.evalFrom state (prefix ++ suffix)
    = M.evalFrom (M.evalFrom state prefix) suffix
```

is exposed at the repository's native Moore-observation interface as
`behavior_append_eq_behavior_reached`.  For a pair, the derived iff is

```text
prefix ++ suffix separates the roots
  iff
suffix separates the two states reached after prefix.
```

Thus a suffix may be semantically shared at a reached pair.  The theorem does
not erase the prefix required to replay the experiment from its declared
roots.

## 5. Hostile control: current-pair merging is not replay compression

`PrefixErasureWitness` is a native six-state Boolean DFA.  Root pair `(0,1)`
reaches `(4,5)` under `[false]`; root pair `(2,3)` reaches the same `(4,5)`
under `[true]`.  The empty suffix distinguishes states `4` and `5`, but the
empty word distinguishes neither root pair.  The two valid replay words are
therefore

```text
[false] ++ []
[true]  ++ [].
```

Lean checks all six equalities and inequalities by `native_decide`.  A shared
current-pair table can retain the suffix, but a replayable global certificate
must additionally retain a root-specific reconstruction prefix (or equivalent
parent pointer).  This is the same semantic/construction distinction exposed
by the concurrent witness results: locating a critical continuation does not
construct the path by which a particular causal state reaches it.

## 6. Reciprocal consequence for formation

R0069's exact insertion law says that a candidate suffix is new global
information precisely when it separates a pair that agrees on every already
installed suffix.  The present cost theorem fixes the order of operations:

1. applying the gate only after all independent pair searches preserves the
   above baseline cost, even if installation later discards duplicates;
2. reducing discovery cost requires a scheduler or reverse policy that tests
   unresolved pairs before constructing every root query;
3. any shared suffix policy must retain root reconstruction data, by the
   hostile control.

The next exact object is therefore not a quotient by current pair alone.  It is
a shared separator policy paired with root-specific reconstruction pointers.
Whether one reverse multi-source traversal can build that object while
expanding each product state only once remains open.

## 7. Checked continuation: the exact reverse-policy carrier

`NativeReverseSeparatorPolicy` now specifies the certificate a future shared
reverse traversal must produce.  A `Policy` assigns to each product state:

- a natural rank;
- either no outgoing action, in which case an unequal pair already has
  different Moore responses;
- or one action backpointer which preserves inequality and strictly decreases
  the rank.

Fuelled native reconstruction follows those backpointers.  Rank descent proves
that `rank(pair)+1` fuel reaches a terminal separator, and Lean checks

```text
sharedSuffix separates every unequal governed pair
sharedSuffix.length <= rank(pair).
```

The root adapter is separate and explicit.  If one replay prefix reaches the
governed pair on both sides, Mathlib's `DFA.evalFrom_of_append` lifts the shared
suffix back to a separator of the declared roots.  Thus the richer object
identified by the hostile control has now been typed:

```text
shared product-state rank/action backpointer
  + root-specific replay prefix.
```

This is a supplied policy theorem, not its construction.  In particular, no
result yet extracts the rank/backpointer table by reverse BFS or proves that
each product state is expanded only once.  The `0.20` implementation branch of
the registered forecast occurred: a fuel-indexed native definition made rank
termination transparent without adding a new semantic coherence field.

## 8. Replay and scope

```text
cd formal/pairfield
lake build Pairfield.NativeCompleteWitnessCost
lake build Pairfield.NativeReverseSeparatorPolicy
lake build Pairfield
```

Focused replay checks 3,056 jobs for the cost baseline and 3,057 for the policy
carrier.  The theorem assumes a supplied effective chart/policy; it does not
extract either from bare regularity.  No claim is made about optimal aggregate
cost, a constructed shared traversal, ADS height, adaptive depth,
duplicate-discovery cost, or a physical memory model.

The reciprocal formation installer was also replayed after repair.  Its
greedy output induces exactly the response equivalence of the full explicit
candidate schedule; a rejected word stays redundant under later refinement;
and on the native complete schedule the pruned partition remains discrete with
at most `choose(card X,2)` installed words.  The combined adapter/partition/
cost/policy/formation build checks 3,060 jobs.  This reduces installed
vocabulary only: every scheduled candidate is already present, so no discovery
cost reduction follows.

## 9. One checked reverse traversal, and its remaining width cost

`NativeReversePairTraversal` now constructs one duplicate-free search rather
than assuming a shared table.  Its reverse automaton has states

```text
Option (X × X)
```

where `none` is one synthetic source.  A `seed pair` move enters a pair whose
present Moore responses differ.  A `predecessor pair action` move enters
`pair` from a solved current pair exactly when the original synchronous action
takes `pair` to that current pair.

The exact adapter reverses any forward separator:

```text
behavior left word != behavior right word
  -> reverseDFA.eval (reverseCertificate (left,right) word)
       = some (left,right).
```

The proof recursively reverses the suffix and uses
`DFA.evalFrom_of_append` for the final predecessor edge.  On a finite reduced
chart this gives a closed retained reverse node for every unequal pair.  The
generic visited invariant then checks:

```text
reverseTraversal.states.Nodup
reverseTraversal.closed.length <= card(X)^2 + 1
reverseTraversal.frontier = [].
```

Thus every product state is admitted and expanded at most once; the `+1` is
exactly the synthetic source.  A native three-state control expands seven
reverse states, below the generic ceiling `3^2+1`.

This is not yet a total-work speedup.  The first executable reverse alphabet
is deliberately flat: it contains every seed label and every
`(pair, action)` predecessor label, and the generic DFA traversal scans that
whole alphabet at each expanded reverse state.  It removes duplicate state
admissions but may still perform quartically many transition tests.  A genuine
discovery-cost improvement now requires an indexed predecessor adjacency (or
an equivalent custom frontier expansion) built once, followed by extraction
of retained reverse paths into `NativeReverseSeparatorPolicy.Policy`.

Focused replay checks 3,058 jobs; importing the traversal into the aggregate
checks 8,805 jobs.

## 10. Genuine reverse-edge inventory and the second Mathlib adapter

`NativeReverseEdgeInventory` removes the first source of avoidable width from
the flat alphabet without yet changing the queue.  A proof-relevant
`ReverseEdge` is either:

- a seed carrying a proof that its pair's present Moore responses differ; or
- one predecessor edge determined by an original product state and action.

Every edge has a computed unique source and target.  Lean proves that the old
`reverseStep` performs exactly that source-to-target move.  False terminal
seeds are filtered before they enter the inventory, while every
`(pair, action)` contributes exactly one predecessor edge.  Hence

```text
predecessorEdges.length = card(X)^2 * alphabet.length
edgeInventory.length <= card(X)^2 * (alphabet.length + 1).
```

The exact Mathlib seam is a different automata theorem from the append law
used above:

```text
DFA.evalFrom_comap:
  (M.comap decode).evalFrom state nativeTrace
    = M.evalFrom state (nativeTrace.map decode).
```

The repository defines the native edge DFA as the alphabet pullback of the
existing reverse DFA.  `edgeDFA_evalFrom` therefore checks every native edge
trace against the earlier semantics, not merely the one-step constructor.  On
the three-state control, the inventory contains 22 genuine edges (4 terminal
seeds and 18 predecessor edges), whereas the earlier flat alphabet contains
27 labels.

This is an inventory bound, not a traversal-work theorem.  Materializing
source buckets by repeated list filtering can itself rescan the inventory, and
an association-list lookup can reintroduce width at execution time.  The next
proof must construct a source index and a custom frontier which charges each
bucket once; only then may the 22-versus-27 control be read as more than stored
edge elimination.

Formation's reciprocal `NativeDemandRestrictedFormation` was independently
replayed with this module.  It checks the complementary gate: a policy suffix
is reconstructed only while its pair remains unresolved, is useful before
installation, and strictly decreases the unresolved-pair finset.  A complete
explicit schedule produces a discrete response partition.  Thus discovery
now has a genuine-edge carrier and installation has a pre-construction demand
gate, but extracting the reverse traversal into `Policy` still remains open.

Focused replay checks 3,059 jobs; the joint edge/demand build checks 3,062;
the imported aggregate checks 8,807.

## 11. Source-indexed execution and a third exact Mathlib adapter

`NativeIndexedReverseTraversal` turns the inventory into materialized source
buckets and removes a bucket when its source state is expanded.  The native
state type makes the indexing distinction explicit:

```text
source | pair (left,right).
```

This is a presentation change of `Option (X × X)`, not a new automaton.
Mathlib's exact theorem

```text
DFA.evalFrom_reindex:
  (DFA.reindex e M).evalFrom state word
    = e (M.evalFrom (e.symm state) word)
```

is specialized as `indexedEdgeDFA_evalFrom`.  It checks every native edge
trace, while `indexedEdgeDFA_step_source` checks that a proof-relevant edge
moves from its recorded source to its recorded target.

The materialized index has an exact conservation law.  Inserting one edge
raises payload by one, hence the complete index payload equals
`edgeInventory.length`.  Expanding a frontier transfers one whole bucket from
remaining payload into the attempt counter.  Iteration therefore proves

```text
attempts + remainingPayload = edgeInventory.length
attempts <= card(X)^2 * (alphabet.length + 1).
```

Every retained state is admitted at most once and every retained node carries
a valid reindexed-DFA trace.  On the three-state control, the custom traversal
reaches exactly the same state set as the flat reverse traversal but charges
14 genuine edge attempts, strictly below the 22-edge inventory.  The old flat
engine expanded seven states while scanning 27 labels at each state; those are
different cost currencies and are not equated here.

The `0.08` hostile boundary survives as scope rather than refutation.  The
proved counter charges consumed edge payload.  It does not charge construction
of the association-list index, key comparisons while taking a bucket, or proof
erasure.  `DFA.evalFrom_reindex` is semantics preserving; it says nothing about
representation cost.  The source key is precisely the residual that makes the
work accounting possible.

Formation's reciprocal `NativeShortestSeparatorPolicy` was independently
inspected and replayed.  It orients every unequal pair, compiles the already
checked globally shortest separator's length and head action into `Policy`,
and uses tail separation plus global shortestness for strict rank descent.
The compiled policy drives the demand scheduler to the same exact
`{[], [false]}` discrete control observable.  This closes the supplied-policy
baseline without claiming shared-search savings; replacing that baseline by
parent edges extracted from the indexed traversal remains the next seam.

Focused indexed, reciprocal policy/demand/index, and aggregate replay are the
required validation gates for this section.

## 12. Inventory-resident paths, and why endpoint validity is not a parent certificate

The indexed carrier is now graph-complete independently of its destructive
queue.  Given any forward separator of a pair, `reverseEdgeCertificate` retains
the terminal proof and every predecessor's pair/action data.  Erasing those
proof-relevant edges recovers `reverseCertificate` exactly, and the adapter
chain

```text
DFA.evalFrom_reindex + DFA.evalFrom_comap
```

proves that the native certificate reaches the declared `SourceState.pair`.
Alphabet completeness separately proves every edge in the certificate belongs
to `edgeInventory`.  Consequently every unequal pair in a finite reduced chart
has an inventory-resident native reverse path.

This is graph/path completeness, not yet queue completeness.  Formation's
`NativeIndexedPolicyBoundary` supplies the exact missing invariant.  On the
three-state control, a genuine seed reaches `(0,2)` and a predecessor whose
recorded source is `(0,1)` is then ignored by the reverse DFA.  The resulting
word remains endpoint-valid at `(0,2)`, but its last edge advertises target
`(0,1)`.  Thus

```text
ReachNode.Valid indexedEdgeDFA node
```

does not license reading `node.word.getLast?` as a policy backpointer.
Endpoint semantics forgets failed edge applications; parent extraction needs
an edge-by-edge `Chained` predicate recording that every edge source equals the
state reached by its prefix.  Source-bucket soundness supplies the local step,
but preservation through frontier insertion and bucket consumption remains the
next proof.

The focused indexed path replay checks 3,060 jobs, the independently authored
boundary counterexample checks 3,061, and the aggregate importing both checks
8,811.  This
narrows the continuation: prove chained queue completeness first, then extract
parent edges into the already checked shortest-policy interface.

## 13. The indexed queue now preserves causal edge paths

The missing local invariant is checked in
`NativeIndexedReverseTraversal.lean`.  `EdgeTrace.Chained M start edges finish`
is inductive over the actual proof-relevant `ReverseEdge` list: the first
edge's recorded source must equal `start`, and the tail begins at that edge's
recorded target.  Its snoc lemma matches `ReachNode.child`, while
`Chained.evalFrom_eq` shows that a causal trace evaluates to its declared
endpoint in the reindexed DFA.

This is where the exact Mathlib adapter and the native construction meet.
`indexedEdgeDFA_step_source` is proved through Mathlib's
`DFA.evalFrom_reindex`; it transports one genuine edge from its native source
presentation to its native target presentation.  `Chained` then composes
those transported steps without forgetting the intermediate sources.  Thus
reindexing supplies semantic equality, while the inductive carrier supplies
the provenance that semantic equality alone cannot recover.

For the executable queue, `IndexSound` and `takeBucket_edges_source` prove
that every consumed candidate edge starts at its parent node.  The property
survives `consumeFrontier`, membership filtering through `freshNodes`, every
`advanceQueue`, every `runQueue`, and finally `indexedTraversal` itself.
`nodeChained_valid` records that this new invariant strictly strengthens the
generic endpoint-only `ReachNode.Valid` interface.

The reciprocal annihilation control remains formation's three-state trace.
Its seed reaches `(0,2)`, but its next edge records source `(0,1)`; the old DFA
semantics treats that edge as a no-op, so endpoint validity passes.  The new
theorem `wrong_source_trace_not_chained` rejects it at the intermediate source
equality.  This is a discriminating control: valid native queue traces are
accepted and the deliberately source-mismatched trace is rejected.

The leading chaining forecast occurred.  Focused traversal replay checks
3,060 jobs, the joint traversal/boundary replay checks 3,061, and the Pairfield
aggregate checks 8,814.  Queue completeness is still separate: path existence
in the inventory and causal soundness of admitted nodes do not yet prove that
the destructive bucket schedule admits a node for every reachable pair.  That
closed/frontier/remaining invariant is the next proof before any retained
last edge is compiled into a policy.

## 14. Destructive source buckets are path-complete

The separation at the end of §13 is now closed without weakening the causal
trace interface. The exact flattened index `indexEdges` is used only in
proofs; execution still stores source buckets. `materializeIndex` preserves
every inventory edge and gives unique source keys. For a requested source,
`takeBucket_edge_complete` proves that every indexed edge at that source is in
the removed bucket. `consumeFrontier_covers_edge` then proves that expanding
any matching frontier node creates a candidate whose state is the native edge
target.

The queue proof keeps two complementary invariants. `RemainingCovers` says an
inventory edge remains indexed until its source is closed. `ClosedExpanded`
says that once a source is closed, every outgoing inventory edge already has
its target in the visited state set. Source-key uniqueness is load-bearing:
it rules out consuming one bucket while leaving a duplicate bucket for the
same source behind.

The finite horizon is proved from the actual native carrier. `SourceState X`
has cardinality `|X|²+1`; states are duplicate-free; and every nonempty round
moves at least one frontier node into `closed`. A nonempty frontier after that
many rounds would therefore force more visited nodes than the carrier holds.
At the empty frontier, every visited state is closed, so `ClosedExpanded`
strengthens to `Saturated`.

`saturated_covers_chained` is the final bridge: induction on an
inventory-resident `EdgeTrace.Chained` path puts its endpoint in the visited
set. Combining it with the previously checked finite-reduced certificate gives
`exists_closed_indexed_node_of_ne`. Every unequal pair has a retained closed
node whose trace begins at the synthetic source, follows genuine inventory
edges at their recorded sources, and ends at the declared pair.

Formation's reciprocal wrong-source node remains rejected by `Chained`; the
joint traversal/boundary gate still passes 3,061 jobs. Thus completeness does
not promote endpoint validity into provenance. Formation's concurrently
checked parent-retention theorem can now be composed with endpoint coverage:
basic well-founded policy existence needs only state uniqueness plus the
strictly shorter retained prefix parent. Global shortestness remains an
optimality coordinate.

Focused replay passes 3,060 jobs. The Pairfield aggregate was not green in
this replay: it reached 8,816/8,818 before an unrelated concurrently landed
`RestrictedGoldbachEdge.lean:115` failed. This section therefore claims the
focused and reciprocal gates only; it does not conceal the aggregate debt.
