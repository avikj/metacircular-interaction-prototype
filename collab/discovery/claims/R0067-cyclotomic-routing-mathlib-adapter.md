---
id: R0067
title: Cyclotomic routing is Mathlib's evaluated product identity
status: claimed
kind: theorem
certificate: planned-formal-proof
load_bearing: false
novelty: known
generator: msg-0614-codex-mathlib-cyclotomic-routing-claim
dependencies: none
statement_hash: 68873747d37c3fef9f9f2bd7541a4e8980684ee41692d702745e2f6528708633
cycle: 0
max_cycles: 3
owner: codex_mathlib_ingestor
breaker: cyclotomic-native-lineage-return
source: formal/pairfield/Pairfield/CyclotomicRoutingAdapter.lean
supersedes: none
updated: 2026-08-14
---

# Tension

The live cyclotomic organ routes `a^n-1` through all `Phi_d(a)` with `d|n`,
but its executable provenance is retired Python and the same note layers
valuation, primitive-divisor, and budget claims above the route.  The exact
factorization operation should be checked without importing those later
claims.

# Rosetta bridge

`Polynomial.prod_cyclotomic_eq_X_pow_sub_one` is the common object.  Evaluating
the polynomial identity at an integer `a` gives the native product route;
membership of `d` in `n.divisors` makes each evaluated cyclotomic piece divide
the routed target.

# Exact statement

For every commutative ring `R`, positive `n`, and `a : R`, the product over
`d in n.divisors` of `eval a (cyclotomic d R)` equals `a^n-1`.  Over the
integers, every piece indexed by a divisor of positive `n` divides the target.

# Preservation ledger

- Preserved: the complete divisor index, each cyclotomic polynomial, integer
  evaluation, multiplication of all pieces, and the original target.
- Added: no arithmetic hypothesis except the load-bearing positivity of `n`.
- Not retained: a factoring execution trace or candidate-search order.
- Not implied: valuation support, primitive/exceptional classification,
  degree bounds, budget completion, refusal taxonomy, or agency.

# Proof obligations

1. Transport Mathlib's polynomial product identity through evaluation.
2. Specialize the route to integer-valued native pieces.
3. Derive divisibility of the target by every indexed piece.
4. Check the `2^6-1=63` route.
5. Fire the `n=0` endpoint control.

# Falsification

- Make integer evaluation fail to preserve the finite product.
- Find `d|n`, `n>0`, for which `Phi_d(a)` does not divide `a^n-1`.
- Make the routed product at `(a,n)=(2,6)` differ from `63`.
- Remove positivity without making the zero-index statement false.

# Prior art

The cyclotomic factorization is classical.  The pinned source is Mathlib's
`Mathlib/RingTheory/Polynomial/Cyclotomic/Basic.lean`, especially
`Polynomial.prod_cyclotomic_eq_X_pow_sub_one`.  No novelty is claimed.

# Event log

- 2026-08-14: forecast and falsifiers registered in message 0614; status
  `claimed`.
