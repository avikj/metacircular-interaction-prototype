---
id: R0070
title: Held-prime cyclotomic transport is exact multiplicative order
status: proving
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0623-codex-mathlib-cyclotomic-primitive-transport-claim
dependencies: R0067
statement_hash: 531c25d000d2dc21a1e4555d9610cabb4ce0eef9faabb217f0008a0f69415dda
cycle: 2
max_cycles: 3
owner: codex_mathlib_ingestor
breaker: cyclotomic-native-lineage-return
source: formal/pairfield/Pairfield/CyclotomicPrimitiveTransportAdapter.lean
supersedes: none
updated: 2026-08-14
---

# Tension

The live cyclotomic organ now transports its held primes across bases by
computing their new multiplicative orders.  Its exact native sentence is that
a held prime `p` reappears at exponent `m` precisely when `ord_p(a)=m`.
R0067 checked only divisibility implies exact order in the branch `p ∤ m`.

# Rosetta bridge

Mathlib's `Polynomial.isRoot_cyclotomic_iff` is already an equivalence between
being a root of `cyclotomic m` and being a primitive `m`-th root when the
characteristic does not divide `m`.  Integer divisibility by `p`, evaluation in
`ZMod p`, and `IsPrimitiveRoot.iff_orderOf` turn that theorem into the native
two-way held-prime transport interface.

# Exact statement

For prime `p` with `p ∤ m`,

`p ∣ Φ_m(a) ↔ orderOf (a mod p) = m`.

The hypothesis is load-bearing: at `(p,m,a)=(3,6,2)`, the divisibility side is
true and the order side is false.

# Preservation ledger

- Preserved: the prime, base, cyclotomic index, evaluated integer piece, and
  exact modular multiplicative order.
- Added: primality of `p` and the coprime-characteristic hypothesis `p ∤ m`.
- Not retained: how the prime was earned, its chain-head exponent, the
  exceptional `p ∣ m` classification, or the quotient remaining after all
  held prime powers are removed.
- Not implied: freshness, factorization, search cost, budget completion,
  refusal semantics, or agency.
- Continued after the native return: already in `ZMod 7`, product order is not
  a function of the two component orders.

# Proof obligations

1. Prove divisibility implies exact order by the checked R0067 bridge.
2. Prove exact order implies divisibility via `isRoot_cyclotomic_iff` and
   integer evaluation in `ZMod p`.
3. Check the native cross-base control `5 ∣ Φ₄(3)` with order four.
4. Fire the exceptional control at `3 ∣ Φ₆(2)` with order two.
5. State and prove the native product-order no-go as nonexistence of a binary
   function on component orders, using `(2,4)` and `(2,2)` in `ZMod 7`.

# Falsification

- Find `p ∤ m` for which one direction of the equivalence fails.
- Make the cross-base `(p,m,a)=(5,4,3)` control fail.
- Remove `p ∤ m` without making the `(3,6,2)` equivalence false.

# Evidence

`Pairfield.CyclotomicPrimitiveTransportAdapter` proves the primitive-branch
iff, uniqueness of its index, the cross-base `5 ∣ Φ₄(3)` control, and the
exceptional failure at `(3,6,2)`.  After the native return it also proves

`¬ ∃ F, ∀ a b : ZMod 7, orderOf (a*b) = F (orderOf a) (orderOf b)`.

Focused build: 2,753 jobs, exit 0.  Integrated root build: 8,798 jobs, exit 0.
The source has no `sorry`, `admit`, custom axiom, `unsafe`, or opaque
declaration.  The axiom audit reports only `propext`, `Classical.choice`, and
`Quot.sound`.

# Independent audit

The affected native cyclotomic lineage independently replayed the focused
build and returned `ACCEPT-NARROW` on the transport predicate.  It accepts the
iff exactly under `p ∤ m`, uniqueness, and the base-three control, while
withholding biography, multiplicity, exceptional-prime, residual, cost, and
agency data.  After continuation it returned `ACCEPT` on the `ZMod 7` no-go as
an exact formalization of native Theorem 10.

# Prior art

The theorem is classical and already present at the stronger root/primitive-
root level in Mathlib.  No novelty is claimed.

# Successor seeds

- Keep the full freshness residual separate until the exact exceptional-prime
  and multiplicity erasure have been formalized.
- Test the native open half: whether the fuller sensor pair `(order, head
  valuation)` still fails to compose across multiplication of bases.

# Event log

- 2026-08-14: forecast, boundary, and falsifiers registered in message 0623;
  status `claimed`.
- 2026-08-14: primitive transport iff checks; native lineage returns
  `ACCEPT-NARROW`; continuation closes Theorem 10's exact `ZMod 7` no-go and
  receives `ACCEPT`; status `proving`.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
