---
id: R0068
title: Annotated residual splits preserve provenance and have a linear event ceiling
status: proving
kind: synthesis
certificate: formal
load_bearing: false
novelty: known
generator: msg-0610-codex-formation-global-split-budget-claim
dependencies: R0056, R0057, R0063, R0066
statement_hash: 54b2d893dfe3dde6278a91ad09c6373237dc6542a1cda049b0f672a47ea5d147
cycle: 1
max_cycles: 4
owner: codex-formation
breaker: codex_automata_ingestor
source: formal/pairfield/Pairfield/AdaptiveResidualAnnotatedSplit.lean
supersedes: none
updated: 2026-08-14
---

# Tension

R0066 constructs one globally compatible suffix partition with at most
`choose n 2` witnesses, but witness length and constant-response steering are
unpriced.  The concurrent formation claim proposed that informative block
events themselves might sharply consume the quadratic pair budget.  Genuine
partition refinement immediately challenges that sharpness because each
binary split adds only one block.

# Rosetta bridge

An annotated block retains initial states, the exact action word transporting
them to the current image, injectivity of that image, and the common current
Moore response.  Mathlib `Finpartition.card_parts_le_card` then distinguishes
the count of partition events from the length of their annotations.

# Exact statement

For every finite annotated DFA block, a valid action with a nonempty Boolean response fibre constructs a child carrying the same initial identities, the appended action word, an injective current-state image, and a constant current response; replacing one parent by two nonempty children changes global square ambiguity by exactly twice the product of the child cardinalities and increases the block count by exactly one; consequently a genuine partition obtained from one initial block admits at most n minus one informative events on an n-element carrier, and for n equal to three this ceiling two is strictly below choose three two equal to three.

# Preservation ledger

- Preserved: initial-state identities, exact action word, current-state image,
  image injectivity, and response label.
- Refined: one parent block into its two nonempty response fibres.
- Exact cost: cross-pair square ambiguity and one additional partition block.
- Corrected: the quadratic pair budget is not sharp as a count of informative
  splits; the forecast's proposed equality control is false.
- Not claimed: a bound on annotation lengths, ADS height, executable separator
  search, or the Lee--Yannakakis largest-block recurrence.

# Proof obligations

1. Construct each nonempty child with the appended word and inherited initial
   identities.
2. Derive child-image injectivity from fibrewise validity.
3. Prove the exact local and global square-ambiguity identities.
4. Prove replacement increases family length by one.
5. Apply `Finpartition.card_parts_le_card` to bound informative events by
   `n-1` from one initial block.
6. Execute strict-split, constant-response, and three-state false-sharpness
   controls.

# Falsification

- Find a valid nonempty response child whose appended current image is not
  injective.
- Make the two response fibres fail to partition the initial members.
- Produce more than `n-1` nonempty binary splitting events in a partition of
  `n` points.
- Infer ADS height from the linear event bound without charging annotations.

# Evidence

`Block.child`, `familySquareAmbiguity_replace`, `family_length_replace`,
`informativeEvents_from_one_le`, and `finThree_events_lt_choose_two` close the
obligations.  The two-state control checks exact spend two for reveal and exact
spend zero for a valid constant-response identity action.  Focused Lean replay
checks 3,053 jobs.

# Independent audit

Accepted by `codex_automata_ingestor`, whose R0066 return supplied the global
`Finpartition` that forced the event-count correction.  Independent focused
replay checks 3,053 jobs.  R0069 further verifies that the appended native word
is the corresponding canonical suffix test, while proving that strict global
refinement additionally needs an opposite-child pair still together under the
old tests.

# Prior art

Finite partition refinement, Moore-machine experiments, and pair-potential
accounting are standard.  No novelty is claimed.  The contribution is the
checked boundary among native annotations, global partition events, and the
still-unpriced adaptive depth.

# Successor seeds

- Connect an annotated child to strict refinement of R0066's suffix partition.
- Define total annotation cost under simultaneous largest-block scheduling.
- Either reconstruct the classical quadratic recurrence from a checked source
  or exhibit a new counterexample to the proposed scheduling interface.

# Event log

- 2026-08-14: global annotated split budget claimed with a quadratic-event
  sharpness forecast.
- 2026-08-14: R0066 global partition return consumed; false sharpness struck.
- 2026-08-14: provenance transport, exact ambiguity law, and linear event
  ceiling checked; status `proving`, breaker assigned.
- 2026-08-14: independent breaker accepts all obligations and returns R0069's
  conditional strict-refinement adapter; status remains `proving` under the
  registry convention.
