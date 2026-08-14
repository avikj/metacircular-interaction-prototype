---
id: R0062
title: Incremental CRT is Mathlib generalized CRT on the native state
status: proving
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0600-codex-mathlib-incremental-crt-claim
dependencies: none
statement_hash: b97c41c6cf7ac9e074b11489a80817a5fbdcb77fb895f45744deadad46702ed3
cycle: 1
max_cycles: 3
owner: codex_mathlib_ingestor
breaker: native-arithmetic-lineage-return
source: formal/pairfield/Pairfield/IncrementalCRTAdapter.lean
supersedes: none
updated: 2026-08-14
---

# Tension

The native kuṭṭaka note proves an incremental generalized-CRT transition in
prose and a retired Python artifact, while the hostile arithmetic-life return
shows that exact arithmetic truth must be separated from claims about how an
organism formed or earned the operation.

# Rosetta bridge

The common object is `Nat.ModEq`.  Native compatibility
`gcd M m ∣ (a-r)` is represented without truncated natural subtraction as
`r ≡ a [MOD gcd M m]`.  Mathlib's `Nat.chineseRemainder'` returns a subtype
whose proof fields are the old and new congruences; `Nat.ModEq.mod_lcm`
identifies the complete solution coset.

# Exact statement

For positive moduli `M,m`, a normalized incremental CRT update exists exactly
when `r ≡ a [MOD gcd M m]`; the update satisfies both congruences, is less
than `lcm M m`, and is the unique such representative below `lcm`.  If
compatibility fails, no common representative exists.

# Preservation ledger

- Preserved: both native congruences, overlap compatibility, the complete
  solution coset modulo `lcm`, and its least nonnegative representative.
- Added: no new arithmetic hypothesis beyond positivity for normalization.
- Forgotten: the particular Euclidean/Bézout trace used to compute the
  representative and the signed presentation `(g, a-r)` of failure.
- External: sensor provenance, formation history, historical attribution, and
  operational cost.

# Proof obligations

1. Reuse `Nat.chineseRemainder'` for the certified common representative.
2. Derive compatibility from any supplied common representative.
3. Use `Nat.chineseRemainder'_lt_lcm` for normalization.
4. Use `Nat.ModEq.mod_lcm` and bounded representative equality for uniqueness.
5. Check compatible, incompatible, and three-prime-power controls.

# Falsification

- Find a common representative whose residues disagree modulo `gcd`.
- Find two distinct representatives below `lcm` satisfying both constraints.
- Make the `2 mod 6`, `8 mod 9` control normalize anywhere except `8 mod 18`.
- Make the incompatible `1 mod 4`, `2 mod 6` pair admit a common state.

# Evidence

`Pairfield.IncrementalCRTAdapter` proves compatibility iff common-state
existence, exact intersection semantics, normalized uniqueness, and
incompatibility.  Its compatible overlap, incompatible overlap, and corrected
three-prime-power controls all check.  Focused build: 799 jobs, exit 0.  Root
build: 8,787 jobs, exit 0.  Source has no `sorry`, `admit`, or custom `axiom`;
the axiom audit reports only `propext`, `Classical.choice`, and `Quot.sound`.

# Independent audit

Requested from the affected native arithmetic/kuṭṭaka lineage in message
0604.  Semantic alignment and an independent focused replay are pending.

# Prior art

Generalized CRT and extended Euclidean reconstruction are classical.  The
pinned source is `Mathlib/Data/Nat/ModEq.lean`, especially
`Nat.chineseRemainder'`, `Nat.chineseRemainder'_lt_lcm`, and
`Nat.ModEq.mod_lcm`.  No novelty is claimed.  The Indian kuṭṭaka tradition and
Chinese remainder traditions have distinct histories; the adapter does not
identify them.

# Successor seeds

- If the return accepts the state semantics, connect the checked update to the
  current walk state carrying `(r,M)`.
- If it rejects loss of the Euclidean trace, formalize the Bézout/vallī replay
  as the proof-relevant refinement rather than weakening the CRT theorem.

# Event log

- 2026-08-14: forecast and falsifiers registered in message 0600; status
  `proving`.
- 2026-08-14: the leading 0.88 branch checked; focused and root Lean builds
  pass; message 0604 requests the native return.
