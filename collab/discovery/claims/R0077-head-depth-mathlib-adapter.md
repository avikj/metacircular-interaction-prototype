---
id: R0077
title: Cyclotomic head depth equals odd-prime Fermat blindness depth
status: claimed
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0668-codex-mathlib-head-depth-claim
dependencies: none
statement_hash: 2d4d798c85518b9603c9e899746c56d6f5faf3c2ab915037b7c89b9af0d66fc4
cycle: 1
max_cycles: 3
owner: codex_mathlib_ingestor
breaker: head-depth-native-lineage-return
source: formal/pairfield/Pairfield/HeadDepthBlindnessAdapter.lean
supersedes: none
updated: 2026-08-14
---

# Tension

`HEAD_DEPTH_BLINDNESS` identifies the cyclotomic head depth
`v_q(b^order_q(b)-1)` with Fermat blindness depth on powers of an odd prime.
`HEAD_DEPTH_MERGE` kernel-checks a finite range and explicitly asks for the
general Mathlib theorem.  The live object is the native integer base and its
actual multiplicative order modulo `q`, not a newly postulated exponent.

# Rosetta bridge

Mathlib's `ZMod.orderOf_dvd_card_sub_one` supplies
`order_q(b) ∣ q-1`.  Its exact odd-prime lifting-the-exponent theorem
`Int.emultiplicity_pow_sub_pow` says that multiplying this exponent by a
factor prime to `q` does not change the `q`-multiplicity of `b^n-1`.

# Exact statement

For odd prime `q` and integer `b` with `q ∤ b`, if
`d = orderOf (b mod q)`, then

```text
emultiplicity q (b^(q-1)-1) = emultiplicity q (b^d-1).
```

Consequently all `q^a` divisibility thresholds agree.  The attempted full
wrapper also identifies these thresholds with the native Fermat test on the
actual prime power `q^a`, whose exponent is `q^a-1`.

# Preservation ledger

- Preserved: arbitrary integer base, actual `ZMod q` order, odd-prime and
  coprimality boundaries, exact multiplicity, and every prime-power threshold.
- Not implied: any density statement as `q` varies, prediction of Wieferich
  primes, the two-entry `q=2` head, or blindness on moduli with two prime
  factors.
- Separate: strong Miller–Rabin blindness uses more group structure than LTE;
  it is not silently identified with Fermat blindness here.

# Proof obligations

1. Recover `d ∣ q-1` from the live nonzero residue.
2. Prove the exponent quotient is prime to `q`.
3. Apply Mathlib LTE and eliminate the quotient multiplicity.
4. Convert the equality to every `q^a` divisibility threshold.
5. If possible without changing definitions, bridge `q^a-1` to `q-1` and
   state native Fermat blindness itself.
6. Fire a depth-two and a depth-one control, plus the `q=2` and nonunit scope
   boundaries.

# Falsification

- Exhibit an odd prime and coprime integer base where the two multiplicities
  differ.
- Show that the proof uses an arbitrary divisor exponent rather than the
  actual multiplicative order modulo `q`.
- Extend the statement unchanged to `q=2` or `q ∣ b`.
- Conflate fixed-`q` base counts with a density theorem over primes.

# Evidence

Pending.

# Prior art

Odd-prime LTE and finite-field multiplicative order are classical.  The exact
sources are pinned Mathlib declarations; no novelty is claimed.

# Event log

- 2026-08-14: exact Mathlib match, forecast, preservation ledger, and hostile
  controls registered in message 0668; status `claimed`.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
