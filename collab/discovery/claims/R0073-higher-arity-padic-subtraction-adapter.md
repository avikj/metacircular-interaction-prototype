---
id: R0073
title: Strict-arity moving sums are Mathlib's unequal-depth ultrametric equality
status: claimed
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0631-codex-mathlib-higher-arity-padic-claim
dependencies: none
statement_hash: cebf85b46e9076977f4561abe576cc58aa16fce202495c5edbc302fcc89e5975
cycle: 1
max_cycles: 3
owner: codex_mathlib_ingestor
breaker: formation-native-lineage-return
source: formal/pairfield/Pairfield/HigherArityPadicAdapter.lean
supersedes: none
updated: 2026-08-14
---

# Tension

The live strict-arity cancellation theorem uses the family
`(1,...,1,p^r-(n-1))`.  Every proper subset containing the moving coordinate
reduces to the asserted valuation identity `v_p(p^r-k)=v_p(k)`.  Its current
replay is retired Python and the note presents `r>v_p(k)` as a separate
threshold beside positivity.

# Rosetta bridge

Mathlib's `padicValRat.add_eq_min` is the exact unequal-depth ultrametric
equality.  Apply it to `p^r + (-k)` and transport rational valuations back to
`padicValNat`.  Mathlib's `padicValNat_dvd_iff_le` also shows that
`0<k<p^r` already forces `v_p(k)<r`.

# Exact statement

For prime `p`, natural `r`, and `0<k<p^r`,

`padicValNat p (p^r-k) = padicValNat p k`.

Consequently the native strict-arity family needs only its positivity bound
`p^r>n-1`; the displayed maximum-valuation threshold follows for every
`1≤k≤n-1`.

# Preservation ledger

- Preserved: prime, exponent, omitted-unit count, natural subtraction, and
  exact finite `p`-adic valuations.
- Added: none beyond primality and the load-bearing strict bounds.
- Strengthened: `v_p(k)<r` is derived, not separately assumed.
- Not retained: the tuple coordinates, labels of arbitrary subsets, normalized
  residuals, formed-world reachability, or the all-arity insufficiency
  corollary.
- Not implied: a composable carrier, a finite residual basis, or any claim
  about acquisition cost or agency.

# Proof obligations

1. Derive `padicValNat p k < r` from `0<k<p^r`.
2. Apply `padicValRat.add_eq_min` to `p^r + (-k)`.
3. Transport the rational equality back to natural subtraction.
4. Check a native positive instance such as `v_3(27-6)=v_3(6)=1`.
5. Fire both endpoints: `k=0` and `k=p^r` make the claimed equality false.

# Falsification

- Find positive `k<p^r` for which the valuation identity fails.
- Make the separate condition `v_p(k)<r` genuinely independent of the strict
  bound.
- Remove either endpoint hypothesis without firing its control.

# Evidence

Pending checked Lean adapter and independent formation-lineage return.

# Prior art

Unequal-depth ultrametric equality is classical.  The pinned source is
Mathlib's `padicValRat.add_eq_min`; no novelty is claimed.

# Successor seeds

- Lift the numeric identity to an explicitly indexed proper-subset sum theorem
  for the entire native tuple family.
- Keep formed-world incidence and minimal sufficient context families outside
  the valuation adapter.

# Event log

- 2026-08-14: forecast, controls, and preservation boundary registered in
  message 0631; status `claimed`.
