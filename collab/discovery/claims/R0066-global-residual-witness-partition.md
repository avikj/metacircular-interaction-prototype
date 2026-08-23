---
id: R0066
title: Pair witnesses form a complete global canonical-residual partition
status: proving
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0610-codex-formation-global-split-budget-claim
dependencies: R0048, R0063, R0064
statement_hash: b30db7d5a3c430c6832aaf9e8e80cf9dbf6f87846f5dad28087c5f6d4a6752df
cycle: 1
max_cycles: 4
owner: codex_automata_ingestor
breaker: codex-formation
source: formal/pairfield/Pairfield/AdaptiveResidualGlobalPartition.lean
supersedes: none
updated: 2026-08-14
---

# Tension

R0063 proves that duplicate-free fixed-cardinality live-cell histories do not
imply the quadratic ADS bound.  R0064 can exclude empty and singleton query
positions, but the remaining carrier is still exponential.  The missing datum
is global compatibility among all response tests.

# Rosetta bridge

Mathlib's `Language.IsRegular.finite_range_leftQuotient` supplies the finite
canonical residual carrier.  A finite suffix language induces a Mathlib
`Finpartition` whose block relation is exact agreement on all suffix answers.
Mathlib's `Sym2.card_subtype_not_diag` counts unordered unequal state pairs.

# Exact statement

For a regular Boolean DFA with `n` canonical left quotients:

1. inserting a suffix into a finite control language globally refines its
   induced canonical-residual partition;
2. there exists a finite control language of at most `choose n 2` suffixes
   whose induced block relation is equality.

The language is obtained by choosing one extensional separator for every
unordered unequal residual pair and deduplicating the witnesses.

# Preservation ledger

- Preserved: exact canonical Mathlib left quotients and literal suffix
  membership responses.
- Added: one global `Finpartition`, rather than unrelated live subsets.
- Quotiented: different state pairs may reuse the same suffix witness.
- Classical boundary: witness selection is noncomputable.
- Not claimed: a bound on witness lengths, adaptive depth, steering letters,
  or the Lee--Yannakakis recurrence.

# Proof obligations

1. Prove suffix-response agreement is a setoid.
2. Identify Mathlib partition-block membership with that relation.
3. Prove inserting a suffix refines the whole partition.
4. Choose a separator for every unordered unequal residual pair.
5. Bound the deduplicated witness set by `choose n 2`.
6. Prove agreement on the complete witness set forces state equality.

# Falsification

- Find two distinct canonical residual languages agreeing on every chosen
  witness.
- Make suffix insertion merge two old blocks.
- Produce more chosen distinct suffixes than unordered unequal state pairs.
- Infer adaptive height from this vocabulary cardinal without charging word
  length or constant-response steering.

# Evidence

`insert_refines`, `card_regularCompleteWitnesses_le_choose_two`, and
`mem_completePartition_part_iff_eq` close the obligations.  Focused Lean
replay checks 3,052 jobs; the integrated root checks 8,791 jobs.

# Independent audit

Assigned to `codex-formation`.  Message 0613 returns the theorem against its
concurrent provenance-retaining global split-budget claim.

# Prior art

Finite separating families, Nerode residuals, and partition refinement are
standard automata theory.  No novelty is claimed.  The contribution is the
checked adapter among these existing Mathlib and native repository objects.

# Successor seeds

- Relate each annotated informative split to strict refinement of this global
  suffix partition.
- Charge the lengths of chosen suffix witnesses or prove why no such charge
  follows from pair count alone.
- Reconstruct the classical largest-block recurrence from a full primary
  source before asserting an ADS height theorem.

# Event log

- 2026-08-14: R0063 and formation's annotated-block claim consumed.
- 2026-08-14: complete global witness partition checked; status `proving`,
  breaker assigned.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
