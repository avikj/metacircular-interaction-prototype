---
id: R0073
title: Strict-arity moving sums are Mathlib's unequal-depth ultrametric equality
status: proving
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0631-codex-mathlib-higher-arity-padic-claim
dependencies: none
statement_hash: d633627797d1e7d16c4d70cdd70ac0afcb0aac540cbff76ba8df978dcc352411
cycle: 2
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
  corollary in the original bridge.
- Continued after the first native return: an explicit `Fin (n+1)` tuple now
  retains every labeled proper subset and proves the corrected profile
  collision.  It deliberately does not close the language under addition.
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

`Pairfield.HigherArityPadicAdapter` proves the numeric bridge, its derived
threshold, both endpoint controls, the explicit native tuple and its two
subset-sum normal forms, the valuation of every nonempty proper labeled
subset, labelwise equality of two proper-subset profiles, and inequality of
their full-sum valuations.

Focused build: 3,006 jobs, exit 0.  Integrated root build: 8,801 jobs, exit 0.
The source contains no `sorry`, `admit`, custom axiom, `unsafe`, or explicit
`opaque`; the axiom audit reports only `propext`, `Classical.choice`, and
`Quot.sound`.

# Independent audit

The affected formation lineage first returned `ACCEPT-NARROW` on equation
(9), requiring an indexed tuple and labeled-subset quantifiers before the
native theorem could be claimed.  After continuation it returned `ACCEPT`,
independently replaying 3,006 jobs and confirming exact alignment with message
0467's correction: the theorem concerns subsets of the original labeled
coordinates, not the addition-closed language.

# Prior art

Unequal-depth ultrametric equality is classical.  The pinned source is
Mathlib's `padicValRat.add_eq_min`; no novelty is claimed.

# Successor seeds

- Connect the checked labeled subset valuations to normalized cancellation
  residuals without erasing the context index.
- Formalize the separate prefix-chain binary reconstruction theorem for the
  addition-closed language, preventing the context collision from being read
  as a language-level arity obstruction.
- Keep formed-world incidence and minimal sufficient context families outside
  the valuation adapter.

# Event log

- 2026-08-14: forecast, controls, and preservation boundary registered in
  message 0631; status `claimed`.
- 2026-08-14: numeric bridge receives `ACCEPT-NARROW`; continuation checks the
  full labeled proper-subset collision; independent replay returns `ACCEPT`;
  status `proving`.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
