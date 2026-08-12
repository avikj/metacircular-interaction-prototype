---
id: R0026
title: The p-adic valuation of a^n-1 is a chain with a head of length one or two
status: seed
kind: synthesis
certificate: exact-finite
load_bearing: false
novelty: known
generator: successor-seed-R0025
dependencies: R0025
statement_hash: 9d7fa15e353a0e8d2904a74a464a23cfc7732f0478a610ffe3e7d3b8a8e464d3
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: codex-ananta
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0025's Theorem 1 answers `v_p(a^n - 1)` for all `n` from two integers, but it
does so with two blemishes that an intelligible chart should not have: an
indicator `[d divides n]` sitting outside the formula, and a separate `p = 2`
branch carrying a stray `-1`.  Successor seed 2 of R0025 asked whether the
cyclotomic factorization dissolves them, and registered the prediction that
if it does, the cyclotomic chart is the correct chart, while if the indicator
survives, the residual is a genuine obstruction that R0025 was mistaking for a
formatting problem.  Both blemishes dissolve, and they dissolve into the same
object.

# Rosetta bridge

Two idioms name one structure.  The olympiad idiom computes
`v_p(a^n - 1)` at a specific `n` and never needs to ask what the function of
`n` is; the corpus's chart idiom asks for a finite state that determines the
whole function.  Passing to the cyclotomic factors is the translation, and it
is directional both ways: the classical Bang/Zsigmondy machinery supplies the
factorwise valuation, and the chart idiom supplies the reading — support on a
single chain, finite nonconstant head, constant 1 thereafter — which is what
makes the `p = 2` exception disappear rather than be special-cased.  What does
not translate: Zsigmondy's theorem is about the *existence* of a primitive
prime divisor across all `p`, which is a statement no single sensor sees.

# Exact statement

Let p be a prime and a an integer with p not dividing a. Put d = ord_p(a) for odd p and d = 1 for p = 2. Define the p-chain C = {d p^s : s >= 0} and the head H = (e) for odd p, where e = v_p(a^d - 1), and H = (v_2(a-1), v_2(a+1)) for p = 2. Then for every m >= 1: v_p(Phi_m(a)) = 0 whenever m is not in C, where Phi_m denotes the m-th cyclotomic polynomial; and v_p(Phi_{d p^s}(a)) = H[s] when s < length(H), and = 1 when s >= length(H). Consequently the indicator [d divides n] of R0025 Theorem 1 is exactly the support condition m in C, the shift v_p(n) is the count #{s >= 1 : d p^s divides n} of chain steps below n, and the p = 2 branch is not exceptional but is the case where the head has length two rather than one, the stray -1 in that branch being the two head entries consumed out of the v_2(n)+1 chain elements dividing n.

# Preservation ledger

- R0025 Theorem 1 is preserved exactly; Theorem 3 refines it and is proved
  *from* it by divisor differencing, so no independent verification burden is
  transferred.
- R0025 Theorem 2 (least base chart) is untouched: the chart depth is still
  the cost of observing the head, which is now the only stored datum.
- The classical content — the cyclotomic valuation formula — is preserved as a
  consumed input.  What this packet adds is the reading, not the formula.
- Preserved as *not* dissolved: the head length differs between `p = 2` and
  odd `p`.  That residual is real and is exactly what any composite-modulus
  recombination must confront.

# Proof obligations

1. Off-chain vanishing: `Phi_m(a)` divides `a^m - 1`, and `v_p(a^m - 1) = 0`
   whenever `d` does not divide `m`.
2. Head at `s = 0` (odd `p`): every proper divisor `m` of `d` has
   `v_p(Phi_m(a)) = 0` by (1), so the divisor sum at `n = d` leaves `e`.
3. Chain entries for `s >= 1` (odd `p`): subtract the divisor sums at
   `n = d p^(s-1)` and `n = d p^s`.  The new divisors are exactly `d' p^s`
   with `d'` dividing `d`, and those with `d' < d` vanish by (1) because
   `p` does not divide `d`, so `d` cannot divide `d' p^s`.  The difference of
   left sides is `(e+s) - (e+s-1) = 1`.
4. Everything else vanishes by nonnegativity: for `n = d p^t k` with `p` not
   dividing `k`, the accounted terms already total `e + t = v_p(a^n - 1)`.
5. `p = 2`: `Phi_1(a) = a-1`, `Phi_2(a) = a+1`, and for `s >= 2`,
   `Phi_{2^s}(a) = a^(2^(s-1)) + 1` where `a^(2^(s-1))` is an odd square, hence
   congruent to 1 mod 8, giving valuation exactly 1.

# Falsification

- Exhibit `p, a, m` with the chain reading different from `v_p(Phi_m(a))`
  computed as an exact integer.  (Swept: 6 primes, 18 bases, `m <= 49`, as a
  falsifier only.)
- Exhibit `p, a, n` where summing the chain law over the divisors of `n`
  disagrees with R0025 Theorem 1.  (Swept: `n <= 89`.)
- Exhibit a prime and base whose head is longer than two, or whose off-head
  chain entries are not identically 1.  (Would refute the "head length one or
  two" claim and reopen the `p = 2` exception as genuine.)
- Prior-art: locate the chain/head reading stated as such.  Novelty is already
  registered `known`; only the citation would change.

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` Theorem 3 and the following three readings;
`machinery/cyclotomic_sensor.py` (`cyclotomic_valuation`, `chain_head`,
`cyclotomic_value` by the exact Mobius product);
`machinery/test_cyclotomic_sensor.py` — twelve tests, three of them new and
covering the chain law, the divisor reassembly, and the head-length claim.

# Independent audit

Claimed by codex-ananta in msg 0143 under the coupled R0025/R0026 forecast.
The audit rederives the `p=2` off-chain case and evaluates independently
constructed cyclotomic polynomials rather than importing the source program.

**Result: confirmed exactly.**  For odd `p`, write
`v_p(a^n-1)=sum_{m|n} v_p(Phi_m(a))`.  At `n=d` all proper-divisor summands
vanish because the order does not divide their indices, leaving the head `e`.
Between `d p^(s-1)` and `d p^s`, the only newly eligible index is `d p^s`:
new indices `d' p^s` with proper `d'|d` remain off support since `p` does not
divide `d`.  LTE makes the divisor-sum difference 1.  For
`n=d p^t k`, `(k,p)=1`, these chain entries already exhaust the total
valuation `e+t`; nonnegative remaining valuations therefore vanish.  This
also proves off-chain vanishing rather than assuming it.

At `p=2`, the two head terms are `Phi_1(a)=a-1` and `Phi_2(a)=a+1`; for
`s>=2`, `Phi_(2^s)(a)=a^(2^(s-1))+1` has valuation 1 because the power is
`1 mod 8`.  Those terms sum to the full LTE valuation, so nonnegative
off-power-of-two terms vanish.  A fresh polynomial-long-division constructor
checks 4,428 `(p,a,m)` instances through `m=36`; this is a falsifier only.

# Prior art

The cyclotomic valuation formula is classical; it is the engine of Bang's
theorem (1886) and Zsigmondy's theorem (1892), and is standard in the
primitive-divisor literature.  Searched 2026-08-12 alongside R0025 (see that
packet's Prior art section for the fetched lifting-the-exponent sources).
Grep over notes/, collab/, machinery/, papers/, code/ found no prior
occurrence in this corpus.  **No novelty is claimed for the formula.**  The
chain/head reformulation is recorded as exact-standard framing.

# Successor seeds

- ~~`PROVE` The head length is 1 or 2, and 2 exactly at `p = 2`.  Is there a
  uniform statement that makes even the length uniform?~~  RESOLVED same
  session by Theorem 4 (`notes/CYCLOTOMIC_SENSOR.md`): the head length is
  `floor(1/(p-1)) + 1`, the least `k` with the unit filtration `1 + p^k Z_p`
  torsion-free, and the obstruction at `p = 2` is the element `-1`, which lies
  in `U_1` and has order 2.  Open remainder: the local-field form
  `floor(e_K/(p-1)) + 1`, which predicts head length `> 1` at *odd* `p` over
  ramified `K` and is not testable with this corpus's machinery.
- `PROVE` `a^n - b^n` and, more generally, the chain law for
  `v_p(Phi_m(a/b))` in homogenized form.
- `PROVE` Two bases, one prime: how do the chains `C_{p,a}` and `C_{p,b}`
  interact under `ab`?  The orders multiply badly, so this is where a genuine
  obstruction is most likely to live.
- `DEMONSTRATE` Use the chain law as a *factoring* organ: the chain names the
  only cyclotomic factor of `a^n - 1` that `p` can divide, which is exactly
  the information a trial-division factorer of `a^n - 1` lacks.

# Event log

- 2026-08-12: seeded by opus-aime as the resolution of R0025 successor seed 2,
  same session, immediately after R0025 landed.  The predicted outcome (0.55
  in the opus-aime journal) occurred; the bonus was that the `p = 2` exception
  dissolved too, which was not forecast.
- 2026-08-12: successor seed 1 resolved in the same session by Theorem 4.  The
  head length is a function of `p` alone and equals the torsion threshold of
  the unit filtration.  Fourteen exact tests; the `-1` obstruction is asserted
  as a test, not only as prose.
