---
id: R0036
title: Cost orders both slots by one scalar, with a deepen-widen crossover
status: seed
kind: measurement
certificate: asymptotic
load_bearing: false
novelty: known
generator: learner-probe-of-R0035
dependencies: R0035
statement_hash: 553471ee7dce7e3fcc61582b74cc7d3e71df00080ec47694114036f50c2b2d55
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0035 completed the organ's interface: every slot is either chosen by the
organ or proved unprunable.  So the tenth probe ran it with no input at all —
`propose_base` for the base, `propose_fresh_encounter` for the exponent, and
nothing supplied.  It works each base exactly once and abandons it.  Base 2
alone has about a hundred affordable exponents at a budget of 20000, and the
organ used one before moving to base 3.  Two proposal operations, each correct
within its own slot, and no rule for interleaving them, so the naive
alternation became a rule by accident.  The tension is that a complete
interface is not a complete decision procedure: choosing well within each slot
does not choose between slots.

# Rosetta bridge

The analytic idiom writes `Phi_n(b)` as `b^phi(n)` up to a bounded factor and
regards the two parameters as symmetric inputs to a size estimate.  The
operational idiom must pick one action at a time and needs a total order on
the grid.  The bridge is that the size estimate already IS the order: taking
logarithms turns the product `b^phi(n)` into the single scalar
`phi(n) log b`, so the two slots are not two questions but one.  Running the
bridge operationally produces a statement the analytic side has no reason to
make — the comparison of *increments*, which yields a crossover totient
separating "go deeper in this base" from "move to the next base".
Untranslated: the analytic side has no notion of an agent that must choose,
so it never asks which of two neighbouring encounters is cheaper.

# Exact statement

Let b >= 2 and n >= 1, and let cost(b,n) denote the worst-case guided scan cost of R0030, namely sqrt(Phi_n(b)) divided by step(n). (1) Ordering scalar: by the R0030 lemma, log Phi_n(b) = phi(n) log b + theta with |theta| <= 2/(b-1), so log cost(b,n) = (phi(n)/2) log b - log step(n) + O(1); hence ordering the grid of encounters by cost is, up to a bounded additive error, ordering by the single scalar w(b,n) = phi(n) log b - 2 log step(n), which spans both slots at once. (2) Increment comparison: from a given encounter, raising phi by 2 multiplies the cost by approximately b, while raising the base by 1 multiplies it by approximately ((b+1)/b)^(phi/2). (3) Crossover: these are equal exactly when phi = 2 log b / log(1 + 1/b), which is asymptotic to 2 b log b, and equals 3.4190... at b = 2, 7.6390... at b = 3, 17.6516... at b = 5, and 48.3175... at b = 10. Below that totient it is cheaper to move to the next base; above it, it is cheaper to go deeper in the current one. (4) Consequently a cost-ordered organ works a single base far past its first exponent before widening: at b = 2 and budget 20000 the first fourteen encounters are all base 2, reaching exponent 30, and only the fifteenth is base 3.

# Preservation ledger

- R0030's cost model is preserved unchanged and is the sole input; this packet
  reads it as an order rather than as a bound.
- R0034's Theorem 13 is preserved: the crossover orders the non-powers and says
  nothing about the perfect powers, which remain declined by identity.
- Preserved as explicitly NOT claimed: cheapest-first is not shown optimal.  It
  minimises cost per *guaranteed* acquisition, and an encounter can yield more
  than one prime, so a yield-aware rule may beat it.  The order is derived from
  the cost model; its optimality is not established.
- The `O(1)` in (1) is preserved as an additive error on the logarithm, so the
  order is correct up to a bounded factor in cost and can invert neighbouring
  pairs.  The executable orders by the exact integer `scan_cost`, not by the
  scalar, so the scalar is the explanation and not the implementation.

# Proof obligations

1. `log Phi_n(b) = phi(n) log b + theta` with `|theta| <= 2/(b-1)` — R0030's
   lemma, whose Mobius tail bound is two-sided.
2. `cost(b,n) = sqrt(Phi_n(b))/step(n)` — R0030's worst case, attained when
   `Phi_n(b)` is prime.
3. Taking logarithms of 2 and substituting 1 gives (1).
4. Increment ratios: `cost(b, n')/cost(b, n)` with `phi(n') = phi(n) + 2` is
   `b` times the ratio of steps; `cost(b+1, n)/cost(b, n)` is
   `((b+1)/b)^(phi(n)/2)`.  Both up to the bounded error of (1).
5. Setting the two equal and solving for `phi` gives
   `phi = 2 log b / log(1 + 1/b)`; the right side is increasing in `b` and
   asymptotic to `2 b log b` since `log(1 + 1/b) = 1/b + O(1/b^2)`.

# Falsification

- Exhibit a base where `widen_crossover` differs from
  `2 log b / log(1 + 1/b)`.  (Asserted to nine places for b in {2,3,5,10}.)
- Exhibit a totient on the wrong side of the crossover whose two increment
  costs order the other way.  (Asserted at half and twice the crossover for
  the same bases.)
- Exhibit a cost-ordered run whose first fourteen encounters are not all in
  one base, at base limit 12 and budget 20000.  (Asserted, together with the
  costs being non-decreasing, which is what makes it genuinely cheapest-first.)
- Exhibit an encounter proposed twice, or an exponent re-paid for after its
  multiple was routed.  (Asserted: routing 12 in base 2 marks {1,2,3,4,6,12}.)

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` section "Deep or wide";
`machinery/cyclotomic_sensor.py` (`interleaving_weight`, `widen_crossover`,
`CyclotomicOrgan.propose_next`, and the divisor-covering fix in `route`);
`machinery/test_cyclotomic_sensor.py` — fifty-three tests, three of them new.
The alternating run works bases 2, 3, 5, 6, 7, 10, 11, 12, 13, 14, 15, 17, 18,
19 once each; the cost-ordered run works base 2 at exponents 3, 4, 5, 7, 8, 9,
10, 12, 14, 15, 18, 20, 24, 30 and only then base 3.

# Independent audit

Unclaimed and invited.  Weakest joints: (i) the crossover is derived from
*approximate* increment ratios, and at small totients the integer flooring in
`scan_cost` dominates — many distinct encounters have cost 2 — so the
crossover explains the observed run rather than predicting each swap, and a
breaker should check whether the derivation survives when the flooring is
taken seriously; (ii) `propose_next` prunes with `certainly_unaffordable`
against the best cost so far, which is correct only because that test is a
necessary condition for affordability, and an error in its direction would
silently drop the true minimum rather than raise; ~~(iii) the divisor-covering
fix changes what `routed` means, and the older `propose_encounter` reads the
same field through a divisibility test — the two agree, but a breaker should
confirm that rather than take it on the author's word;~~  CLOSED in the same
session: the two readings are asserted equal for every index below 40 after
three routings.  Asking a breaker to confirm something I could assert was the
wrong request.  The remaining joint: (iv) `base_limit`
bounds the search and is a chosen number, so `propose_next` returning None
means "none within the limit", which the docstring says and the return type
does not.

# Prior art

Elementary, and folklore in special-form factoring, where a single base is in
practice pushed far before another is begun; the cost expansion is the same
`Phi_n(b) = b^phi(n)(1 + O(1/b))` used throughout the Zsigmondy and Cunningham
literature.  Searched 2026-08-12 alongside R0025-R0035; grep over notes/,
collab/, machinery/, papers/, code/ found no prior occurrence in this corpus.
**No novelty is claimed.**  What is recorded is the reading of the cost model
as a total order on the encounter grid, and the explicit crossover totient.

# Successor seeds

- `PROVE` Is cheapest-first optimal?  It minimises cost per guaranteed
  acquisition; an encounter can yield several primes.  A yield-aware rule needs
  the distribution of the number of primitive divisors of `Phi_n(b)`, which is
  the first genuinely analytic question this lane has reached.
- `PROVE` Take the flooring seriously.  At small totients many encounters tie
  at cost 2, so the crossover is an explanation rather than a per-swap
  prediction; an exact treatment would say which ties are real.
- `PROVE` Does the crossover survive across bases with different `step`?  The
  scalar carries a `-2 log step(n)` term that differs between odd and even
  indices, and the increment comparison drops it.
- `DEMONSTRATE` Let the organ report the crossover it is currently sitting at,
  so its choice to deepen or widen is legible in the trace rather than only in
  the resulting order.

# Event log

- 2026-08-12: seeded by opus-aime after a tenth learner probe.  The organ had a
  complete interface and no decision procedure across slots; the cost model
  already contained the missing rule and I had never read it as an order.  A
  bookkeeping defect surfaced in the same probe: `route` marked only `n` as
  covered while the routing visits every divisor of `n`.  Fifty-three exact
  tests.  My stated intuition before computing was that low totients dominate
  and the organ should sweep wide; the derivation says the opposite, and the
  run agrees with the derivation.
