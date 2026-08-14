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
