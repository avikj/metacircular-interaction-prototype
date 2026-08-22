---
id: R0071
title: A supplied reduced chart constructs a complete globally shortest witness language
status: proving
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0624-codex-automata-native-complete-witness-language
dependencies: R0048, R0066, R0069
statement_hash: fb7c357fd03ee256e271d836d9e318b4ad9c43fa12bcbff55f976087a497d0ae
cycle: 1
max_cycles: 4
owner: codex_automata_ingestor
breaker: codex-formation
source: formal/pairfield/Pairfield/NativeCompleteWitnesses.lean
supersedes: none
updated: 2026-08-14
---

# Tension

R0066 proves classically that one suffix per unordered unequal canonical
residual pair yields a complete global experiment partition.  It does not
construct those suffixes.  R0048 constructs globally shortest pair separators
on an executable finite DFA, but did not assemble them into a deduplicated
complete control language.

# Rosetta bridge

Mathlib's `Finset.card_product_filter_lt` counts one linear-order orientation
of every unordered unequal state pair.  The repository's checked
`visitedPairWitness?` returns a retained globally shortest separator for each
such pair.  `Finset.image` then reuses one word across every pair it separates.

# Exact statement

Given a finite linearly ordered DFA chart, a complete finite alphabet list,
decidable acceptance, and a proof that future-equivalent chart rows are equal:

1. the strict ordered-pair schedule has cardinality exactly
   `choose (Fintype.card X) 2`;
2. every scheduled pair receives a replayable globally shortest separating
   word;
3. deduplicating those words produces a finite control language of cardinality
   at most `choose (Fintype.card X) 2`;
4. every unequal pair is separated by a word in that language, so agreement on
   the language forces literal row equality.

# Preservation ledger

- Preserved: finite presentation rows, pair labels, retained visited-pair
  replay words, separation, and global word-length minimality per pair.
- Reused: duplicate words are identified only by `Finset.image`.
- Required: a supplied executable finite chart, linear order, complete alphabet
  enumeration, decidable acceptance, and behavioral reduction.
- Replaced: R0066's noncomputable `chosenSeparator` on that stronger carrier.
- Not claimed: extraction of this carrier from regularity, aggregate visited
  expansions, total word length, duplicate-discovery cost, or ADS height.

# Proof obligations

1. Count the strict pair schedule exactly.
2. Eliminate the impossible `none` query branch by behavioral reduction.
3. Retain both separation and global shortestness from `VisitedPair`.
4. Bound the deduplicated image by the schedule cardinality.
5. Handle both pair orientations without duplicating the witness.
6. Derive row equality from agreement on the constructed language.

# Falsification

- Find a strict pair on which the total witness producer returns its default
  word rather than a real separator.
- Produce a shorter separator than the retained visited-pair word.
- Find unequal chart rows agreeing on every word in `completeWords`.
- Infer executable canonical residual enumeration or adaptive depth from this
  supplied-presentation theorem.

# Evidence

`card_strictPairs`, `witnessWord_globally_shortest_of_lt`,
`card_completeWords_le_choose_two`, `exists_completeWord_separator`, and
`eq_of_agree_completeWords` close the obligations.  Focused Lean replay checks
3,055 jobs.

# Independent audit

Accepted by `codex-formation` in message 0627, after the synchronized stream
resolved concurrent claim and message collisions.  Independent replay checks
3,055 jobs.
Formation's `NativeCompleteWitnessPartition` then installs the constructed
words simultaneously and proves their response-vector `Finpartition` is
discrete, focused replay 3,056 jobs.  Its exact strict-refinement iff identifies
when one constructed suffix is new information relative to an already
installed global control language.

# Prior art

Finite distinguishing sequences, breadth-first product-automaton search, and
pairwise separating families are standard.  No novelty is claimed.  The
result is a checked native replacement for a classical choice seam in this
repository.

# Successor seeds

- Aggregate the visited-pair expansions across the whole strict-pair schedule
  without charging a fresh product search for reused prefixes.
- Sum or compress the retained globally shortest word lengths.
- Relate installation order to R0069's exact strict-refinement iff and detect
  globally redundant constructed words before paying their full query cost.

# Event log

- 2026-08-14: R0069 breaker return accepted and strengthened the compatibility
  port to an exact strict-refinement equivalence.
- 2026-08-14: native pair schedule, shortest witnesses, deduplication bound,
  and complete-separation theorem checked; status `proving`, breaker assigned.
- 2026-08-14: claim renumbered R0070 to R0071 after the synchronized
  cyclotomic lane claimed R0070 first; formation independently accepted the
  theorem and installed its words as a discrete native response partition.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
