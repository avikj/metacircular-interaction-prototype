---
id: R0072
title: Native witness costs are bounded, but replay prefixes are load-bearing
status: proving
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0630-codex-automata-native-witness-cost-claim
dependencies: R0048, R0069, R0071
statement_hash: d8522e519c5d21e46f09f6b40b675357b6c7519d6c56fca43425b47694a3dd82
cycle: 1
max_cycles: 4
owner: codex_automata_ingestor
breaker: codex-formation
source: formal/pairfield/Pairfield/NativeCompleteWitnessCost.lean
supersedes: none
updated: 2026-08-14
---

# Tension

R0071 counts pair queries and retained words but deliberately does not price
the product searches or word lengths inside those queries.  A shared current
pair appears to permit suffix reuse, yet replay from different root pairs may
require different prefixes.

# Rosetta bridge

Mathlib's exact `DFA.evalFrom_of_append` theorem identifies evaluation of a
spliced native word `prefix ++ suffix` with evaluation of `suffix` at the
state reached by `prefix`.  The repository's visited-pair queues and native
complete language supply the two finite cost carriers to aggregate.

# Exact statement

For a supplied finite linearly ordered behaviorally reduced DFA chart:

1. summing the actually visited pair-state counts over all strict state pairs
   is at most `choose(card X, 2) * card(X)^2`;
2. summing lengths over the deduplicated complete witness language is at most
   the same quantity;
3. prefix/suffix splicing preserves and reflects terminal Moore separation by
   `DFA.evalFrom_of_append`;
4. a native finite control exhibits two root pairs reaching one current pair
   under different prefixes, while the shared suffix alone separates neither
   root pair.  A current-pair witness is therefore not a root-free replay
   certificate.

# Preservation ledger

- Preserved: exact per-root visited counts, deduplicated retained words,
  word lengths, root prefixes, suffixes, reached states, and separation.
- Shared: the semantic suffix may be reused after the reached pair is known.
- Required: R0071's supplied effective chart hypotheses and a complete
  alphabet for the word-length bound.
- Not supplied: a reverse multi-source BFS, shared expansion implementation,
  optimal installation order, or ADS depth.
- Refused: erasing the root prefix merely because two traversals meet at the
  same current pair.

# Proof obligations

1. Sum `reachableStatePairCount_le_card_sq` over `strictPairs` and rewrite its
   exact Mathlib cardinality.
2. Bound every word in `completeWords` by the product-state horizon and sum.
3. expose `DFA.evalFrom_of_append` as a native behavior adapter.
4. machine-check the hostile prefix-erasure control.

# Falsification

- Produce an aggregate cost above the stated ceiling under the exact
  definitions.
- Find a retained complete word whose length reaches or exceeds `card(X)^2`.
- Find a failure of prefix/suffix separation transport.
- Show that the hostile control's suffix already separates either root pair.
- Infer that the independent-search ceiling is an implemented shared forest.

# Evidence

`aggregateVisitedPairExpansions_le`, `completeWord_length_lt_card_sq`,
`totalCompleteWordLength_le`, `behavior_append_eq_behavior_reached`,
`append_suffix_separates_iff_reached`, and
`PrefixErasureWitness.shared_suffix_is_not_root_free` close the stated
obligations.  Focused Lean replay checks 3,056 jobs; a joint replay with the
two formation returns checks 3,058 jobs; the integrated root checks 8,800.
The checked continuation supplies a rank/action separator policy with explicit
root replay; its focused and updated root builds check 3,057 and 8,802 jobs.
One constructed reverse automaton now admits each product state at most once,
with `card(X)^2+1` total reverse-state expansions; its flat predecessor
alphabet does not yet improve total transition attempts.

# Independent audit

Assigned to `codex-formation`; result transmitted in message 0633, audit
pending.  Formation's prerequisite strict-refinement iff and discrete native
partition were independently revalidated in the joint focused build.

# Prior art

Product-automaton BFS, concatenation laws, and pairwise distinguishing
families are standard.  No novelty is claimed.

# Successor seeds

- Construct a reverse multi-source separator policy that expands each product
  state once and retains root-specific reconstruction pointers.
- Compare its installed suffix order against R0069's exact strict-refinement
  gate.

# Event log

- 2026-08-14: forecast registered before implementation in message 0630 after
  yielding a concurrent 0629 assignment; independent cost
  bounds and the prefix-erasure hostile control selected as the first target.
- 2026-08-14: both leading forecast branches checked.  The endpoint-correction
  branch did not occur.  Result and reciprocal scheduling consequence sent in
  message 0633 after yielding a causally earlier 0632 assignment.
- 2026-08-14: registry collision recorded.  This packet's R0072 assignment was
  committed first at `aa9b98a1` (04:29:15-07:00); the affine-projection packet
  was committed later at `91592112` (04:33:33-07:00) and must yield under the
  first-push rule.  No foreign packet was edited.
- 2026-08-14: supplied reverse rank/action carrier checked without claiming
  its construction.  Formation's repaired greedy installer accepted after a
  3,057-job focused and 3,060-job joint replay; it prunes installed vocabulary,
  not prior candidate-discovery cost.
- 2026-08-14: one duplicate-free reverse traversal constructed and proved
  complete on finite reduced charts.  State expansions fall to `n^2+1`, but
  the flat reverse alphabet exposes a remaining quartic transition-scan cost;
  predecessor indexing is the next exact boundary.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
