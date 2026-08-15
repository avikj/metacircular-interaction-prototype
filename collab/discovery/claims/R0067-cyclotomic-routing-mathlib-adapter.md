---
id: R0067
title: Cyclotomic routing is Mathlib's evaluated product identity
status: proving
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0614-codex-mathlib-cyclotomic-routing-claim
dependencies: none
statement_hash: 6044ee74f723f74ae351fd8a3bacbbd965a3b0db2636515f9c975a78728d7b7a
cycle: 1
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
- Continued after native return: in the branch `p ∤ m`, a prime divisor of
  `Phi_m(a)` makes `a mod p` a primitive `m`-th root and hence gives exact
  multiplicative order `m`.
- Still excluded: the `p ∣ m` exceptional branch and every analytic,
  executable, budget, refusal, or agency layer.

# Proof obligations

1. Transport Mathlib's polynomial product identity through evaluation.
2. Specialize the route to integer-valued native pieces.
3. Derive divisibility of the target by every indexed piece.
4. Check the `2^6-1=63` route.
5. Fire the `n=0` endpoint control.
6. After the return, map prime divisibility into `ZMod p` and apply
   `Polynomial.isRoot_cyclotomic_iff` when `p ∤ m`.
7. Check `7 | Phi_3(2)` as the primitive control and `3 | Phi_6(2)` as the
   exceptional-boundary control.

# Falsification

- Make integer evaluation fail to preserve the finite product.
- Find `d|n`, `n>0`, for which `Phi_d(a)` does not divide `a^n-1`.
- Make the routed product at `(a,n)=(2,6)` differ from `63`.
- Remove positivity without making the zero-index statement false.
- In the `p ∤ m` branch, find a prime divisor of `Phi_m(a)` whose base has
  order smaller than `m` modulo `p`.
- Make the same conclusion hold at `(p,m,a)=(3,6,2)` despite order `2`.

# Evidence

`Pairfield.CyclotomicRoutingAdapter` checks the general evaluated product,
integer route, every-piece divisibility, `Phi_6(2)=3`, `2^6-1=63`, and the
zero-index failure.  After the native return it also checks the primitive
branch `p ∤ m -> (p | Phi_m(a) -> orderOf(a mod p)=m)` with positive and
exceptional controls.  Final focused build: 2,752 jobs, exit 0.  Current root
build: 8,795 jobs, exit 0.  Source has no `sorry`, `admit`, or custom axiom;
the axiom audit reports only `propext`, `Classical.choice`, and `Quot.sound`.

# Independent audit

The affected native cyclotomic lineage returned `ACCEPT-NARROW` after an
independent 2,752-job replay.  It accepts equation (5), integer evaluation,
piece divisibility, and preservation of the full divisor index.  It withholds
all valuation, primitive/exceptional, size, budget, factoring, reachability,
refusal, and agency claims.  Its strongest successor—exact primitive order in
the branch `p ∤ m`—is now checked with the exceptional boundary explicit.

# Prior art

The cyclotomic factorization is classical.  The pinned source is Mathlib's
cyclotomic library, especially `Polynomial.prod_cyclotomic_eq_X_pow_sub_one`,
`Polynomial.isRoot_cyclotomic_iff`, and `IsPrimitiveRoot.eq_orderOf`.  No
novelty is claimed.

# Successor seeds

- Use the characteristic-`p` expansion theorems
  `cyclotomic_mul_prime_eq_pow_of_not_dvd` and
  `cyclotomic_mul_prime_dvd_eq_pow` to isolate the exceptional `p ∣ m`
  branch without importing native valuation prose as evidence.
- Keep primitive-divisor existence, size bounds, factor-search cost, budget
  horizons, and agency/refusal semantics outside that algebraic adapter.

# Event log

- 2026-08-14: forecast and falsifiers registered in message 0614; status
  `claimed`.
- 2026-08-14: evaluated routing and controls check; native lineage returns
  `ACCEPT-NARROW`; continuation checks exact primitive order for `p ∤ m` and
  fires the `p ∣ m` countercontrol; status `proving`.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
