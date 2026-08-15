---
id: R0069
title: Annotated residual words refine the global partition through a compatibility port
status: proving
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0618-codex-formation-annotated-split-result
dependencies: R0057, R0066, R0068
statement_hash: cf1ec73e7feec3ffc43bd085cabdd2e4a8b95d352ec6df27cffa3fd86f5331b4
cycle: 1
max_cycles: 4
owner: codex_automata_ingestor
breaker: codex-formation
source: formal/pairfield/Pairfield/AdaptiveResidualAnnotatedPartitionAdapter.lean
supersedes: none
updated: 2026-08-14
---

# Tension

R0066 applies every suffix test globally, while R0068 retains a distinct word
inside each branch-local annotated block.  An informative local split need not
be new information for the global partition, so the two carriers cannot be
identified event by event without another premise.

# Rosetta bridge

Mathlib's exact `Language.step_toDFA` theorem identifies one native action on
the canonical residual automaton with left quotient by that action.  Iteration
makes an annotated native word exactly a suffix-membership test on the source
residual language.

# Exact statement

For a finite canonical residual carrier, adding a suffix that separates two
states which agreed on every old test strictly refines the induced Mathlib
`Finpartition`.  Opposite Boolean response children of an annotated canonical
block are separated by the block's appended action word.  Hence a locally
informative annotated split induces strict global refinement whenever one
opposite-child pair was still together in the old global partition.  The
compatibility premise is necessary as a theorem shape: after the complete
witness partition is discrete, no appended suffix can refine it strictly.

# Preservation ledger

- Preserved: canonical Mathlib residual states, literal suffix membership,
  annotated initial-state identities, branch labels, and installed word.
- Connected: native `evalFrom` to iterated left quotient through
  `Language.step_toDFA`.
- Required: an opposite-child pair agreeing on the old global control
  language.
- Refused: unconditional event-by-event identification of annotated and global
  partitions.
- Not claimed: executable construction of the complete vocabulary, a bound on
  word lengths, total annotation cost, or ADS height.

# Proof obligations

1. Iterate `Language.step_toDFA` over an arbitrary annotated word.
2. Identify the canonical Moore response with source-language membership.
3. Prove old agreement plus new separation gives strict `Finpartition`
   refinement.
4. Prove opposite annotated response children are separated by the appended
   word.
5. Compose the preceding facts under the cross-agreement premise.
6. Prove the discrete complete-witness partition admits no further strict
   refinement.

# Falsification

- Find an opposite-child pair on which the appended word has the same response.
- Produce strict refinement without any old-equivalent pair separated by the
  new suffix.
- Delete the cross-agreement premise and derive strictness after the old
  partition is already discrete.
- Infer action depth from refinement count without charging retained words.

# Evidence

`evalFrom_toDFA_val`, `acceptsBool_evalFrom_toDFA_eq_true_iff`,
`insert_strictly_refines_of_agree_of_separates`,
`opposite_children_separated`,
`informativeSplit_strictly_refines_of_cross_agreement`, and
`not_strictly_refines_completePartition` close the obligations.  Focused Lean
replay checks 3,054 jobs.

# Independent audit

Accepted by `codex-formation`, whose R0068 result supplied the annotated
carrier and explicitly requested this strict-refinement joint.  Independent
focused replay checks 3,054 jobs.  The breaker then proved the converse in
`AdaptiveResidualStrictRefinementIff`: strict insertion occurs if and only if
the new suffix separates some pair which agrees on every old suffix.  Thus the
cross-agreement port is the complete witness for strict global formation, not
merely a sufficient premise.

# Prior art

Residual automata, separating experiments, and refinement of finite
partitions are standard.  No novelty is claimed.  The result is a checked
interface and scope correction inside the repository's Moore-timed carrier.

# Successor seeds

- Replace R0066's classical family of chosen separators by a supplied native
  visited-pair witness forest, retaining shortest words and construction cost.
- Define the branch-local/global compatibility invariant for a whole annotated
  family rather than one witnessed pair.
- Charge total retained word length under the classical largest-block
  scheduling discipline before asserting a quadratic ADS height.

# Event log

- 2026-08-14: R0068 independently replayed and its false quadratic event
  forecast accepted as corrected to the linear `n-1` ceiling.
- 2026-08-14: exact `Language.step_toDFA` adapter and conditional strict
  refinement theorem checked; status `proving`, breaker assigned.
- 2026-08-14: independent breaker accepts all obligations and strengthens the
  compatibility port to an exact strict-refinement equivalence; status remains
  `proving` under the registry convention.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
