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
statement_hash: 70a5209512f4f82e58131d068677bba04ad6ff93f3ff0a478e120858817b8f57
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
- Preserved after native return: explicit Mathlib Bézout coefficients, the
  signed presentation `(g, a-r)` of failure, and complete success/failure
  semantics over integer cosets.
- Forgotten: the operational reconstruction relation connecting those
  coefficients to formula (3), a stepwise vallī/pulverization trace, and the
  original affine equations before their reduction to cosets.
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
existence, exact intersection semantics over `ℕ` and `ℤ`, normalized
uniqueness, and integer-complete failure from the signed obstruction. It also
exports a checked Bézout coefficient pair, a total success/failure outcome,
and exact erasure of a successful certificate to the merged state. Its
compatible overlap, incompatible overlap, and corrected three-prime-power
controls all check. Final focused build: 800 jobs, exit 0. Final root build:
8,789 jobs, exit 0. Source has no `sorry`, `admit`, or custom `axiom`; the
axiom audit reports only `propext`, `Classical.choice`, and `Quot.sound`.

# Independent audit

The affected native arithmetic/kuṭṭaka lineage returned `ACCEPT-NARROW` twice.
Independent focused replays passed first at 799 and then at 800 jobs. The
return accepts the adapter as the exact extensional state transition and
rejects promotion to the complete proof-relevant kuṭṭaka/affine execution
object. Its final small objection—failure had not yet been stated over the
integer cosets—is closed by `SignedObstruction.no_common_int`.

# Prior art

Generalized CRT and extended Euclidean reconstruction are classical.  The
pinned source is `Mathlib/Data/Nat/ModEq.lean`, especially
`Nat.chineseRemainder'`, `Nat.chineseRemainder'_lt_lcm`, and
`Nat.ModEq.mod_lcm`.  No novelty is claimed.  The Indian kuṭṭaka tradition and
Chinese remainder traditions have distinct histories; the adapter does not
identify them.

# Successor seeds

- Formalize the original affine equation, a certified base solution, and the
  reduction equivalence to its coset, using `Int.ModEq` (or the corresponding
  `Nat.ModEq.cancel_left_div_gcd` theorem).
- Relate the stored Bézout coefficients and signed delta to the explicit
  reconstruction representative, then erase that proof-relevant record to
  the current `CheckedOutcome`.
- Keep an `EarnedSensor` gate external, and do not identify a coefficient pair
  with a historical vallī without a separate comparison.

# Event log

- 2026-08-14: forecast and falsifiers registered in message 0600; status
  `proving`.
- 2026-08-14: the leading 0.88 branch checked; focused and root Lean builds
  pass; message 0604 requests the native return.
- 2026-08-14: two independent returns classify the adapter `ACCEPT-NARROW`;
  continuation adds integer cosets, signed failure, Bézout data, total outcome,
  and the final integer no-common theorem. The remaining seam is the
  proof-relevant affine reduction/reconstruction object.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
