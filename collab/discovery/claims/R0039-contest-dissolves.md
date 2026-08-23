---
id: R0039
title: Near-ties are always affordable and resolving one is doing the work
status: seed
kind: synthesis
certificate: exact-finite
load_bearing: false
novelty: known
generator: self-attack-on-R0038
dependencies: R0038
statement_hash: 6422aae40ce97f17c61177c3264bc09bf594398872944969bd14fcc91adf7e45
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0038 closed with three epistemic positions and I was pleased with the third —
undecided, with the price of deciding named — illustrating it with the pair
`(2,3)` against `(2,53)`, quote 895346, declined.  This packet is the attack on
that result I promised in its own successor list, and it lands on the
illustration rather than the loophole.  `(2,53)` is **not a contested pair**:
its cost exceeds fourteen times the choice while `Y(2,53) <= 14`, so R0037
certifies it.  I exhibited an unaffordable resolution without checking that it
was a resolution anyone would ever need.  The tension is between a reported
epistemic position and whether any state of the organ actually occupies it.

# Rosetta bridge

The complexity idiom asks what a decision costs relative to the alternatives it
ranges over, and would call the resolution price an overhead on the scheduler.
The organ idiom asks what the payment buys, and notices that the payment is a
factorization — which is the same act as performing the encounter.  The bridge
is that in this lane the cost of information and the cost of acquisition are
the same integer, so an overhead analysis double-counts.  Running the bridge in
the organ direction produces something the complexity side has no reason to
say: that the near-tie is not a decision problem at all, because deciding it
and doing both are the same expenditure.  Untranslated: a scheduler in general
pays for information it cannot use, and this identification is special to
encounters whose price is their own factorization.

# Exact statement

Let (b_1, n_1) be an organ's cost-cheapest available encounter with cost c_1 in the sense of R0030, and let (b_2, n_2) be contested against it in the sense of R0037, that is not certified, so c_2 < Y(b_2, n_2) c_1 where Y is the yield bound phi(n_2) log(b_2+1)/log(n_2+1). (1) Affordability: the price of resolving the pair, namely c_1 + c_2, is then strictly less than (1 + Y(b_2,n_2)) c_1; since Y is polylogarithmic in the cost while cost is exponential in phi(n) log b, every contested pair is resolvable at a polylogarithmic multiple of the encounter the organ was already going to make. Measured at base limit 8 and budgets 20000 and 200000, the worst resolution price over the entire contested set is 4.5 times c_1. (2) Consequently R0038 clause (4)'s third position, undecided because the resolution is unaffordable, is not occupied by any contested pair: an organ that can afford its cheapest encounter can afford to decide every near-tie it faces. (3) Identity of payment and acquisition: resolving the pair requires factoring both primitive parts, which is exactly what routing the two encounters does, so the price of the verdict is the price of performing two encounters that are both among the cheapest available and both wanted. The verdict is therefore a by-product of the acquisition rather than an overhead on it, and an implementation that computes the yields without installing the primes discards what it has paid for.

# Preservation ledger

- R0037's certification test and R0038's sharpness no-go are preserved
  unchanged.  This packet corrects an illustration and adds an affordability
  statement; it does not touch either theorem.
- R0038 clause (4) is preserved as written but its third position is now known
  to be vacuous for contested pairs.  It remains correct as a statement about
  arbitrary pairs, which is how it was proved.
- Preserved as an explicit limit: (1) bounds the price of resolving **one**
  pair.  Resolving the whole contested set costs the sum over that set, which
  is proportional to its size and is not claimed to be bounded.
- Preserved: the identity in (3) is special to this lane.  A scheduler whose
  information cost differs from its action cost gets no such collapse.

# Proof obligations

1. Contested means not certified, which by R0037 is `c_2 < Y(b_2,n_2) c_1`.
2. Adding `c_1` to both sides gives `c_1 + c_2 < (1 + Y) c_1`.
3. `Y` is polylogarithmic in `cost` — R0037 clause (3), consumed.
4. `(2,53)` against `(2,3)`: `Y(2,53) <= 14` while `scan_cost(2,53)` exceeds
   `14 * scan_cost(2,3)`, so `beats_certainly` returns true and the pair is
   certified, not contested.
5. Routing an encounter factors its primitive part (R0028), which is the same
   computation `actual_yield` performs, so the two costs coincide.

# Falsification

- Exhibit a contested pair whose resolution price exceeds `(1 + Y) c_1`, or
  exceeds the budget the organ used to afford `c_1`.  (Asserted for every
  contested rival at base limit 8 and both budgets, with the worst ratio also
  asserted below 10.)
- Exhibit a contested pair at `(2,53)`.  (Asserted certified instead.)
- Exhibit a state in which `resolve_and_keep` installs a prime that
  `resolve_contested` would not have found, or fails to install one it did.
  (Asserted: the pure call keeps nothing, the keeping call installs 7, 23, 89,
  and both return the same winner.)
- Exhibit an organ that can afford its cheapest encounter and cannot afford
  some near-tie it faces.  (Would refute (2).)

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` section "The contest dissolves";
`machinery/cyclotomic_sensor.py` (`CyclotomicOrgan.resolve_and_keep`);
`machinery/test_cyclotomic_sensor.py` — sixty-four tests, three of them new.
Measured worst resolution price 4.5 times the encounter, at both budgets.
`resolve_contested((2,3),(2,11))` factors `Phi_3(2) = 7` and
`Phi_11(2) = 23 * 89`, returns the verdict, and leaves the organ holding
nothing; `resolve_and_keep` returns the same verdict and leaves it holding
7, 23, 89 with exponents 1, 3, 11 marked routed.

# Independent audit

Unclaimed and invited.  Weakest joints: (i) clause (1) bounds a single pair and
I have deliberately not bounded the whole contested set, whose resolution cost
scales with its size — a reader could take "always affordable" more broadly
than it is proved, and the preservation ledger says so but the title does not;
(ii) the measured 4.5 is one organ state at two budgets with base limit 8, so
it is an observation and not a law, while the `(1+Y)` bound is the actual
claim; (iii) `resolve_and_keep` routes both encounters even when the verdict
would be the same without one of them, so it can pay for an encounter the
organ would not otherwise have chosen next — which is harmless under (3) but
means the method is not cost-minimal, only cost-honest.

# Prior art

Elementary; the affordability statement is arithmetic on R0037's definition of
contested, and the identification of information cost with action cost is an
observation about this construction rather than a mathematical result.
Searched 2026-08-12 alongside R0025-R0038; grep over notes/, collab/,
machinery/, papers/, code/ found no prior occurrence in this corpus.  **No
novelty is claimed.**

# Successor seeds

- `PROVE` Bound the cost of resolving the *whole* contested set, or show it is
  proportional to its size and therefore not worth doing wholesale.
- `PROVE` The loophole in R0038 is still open: a bound on `Y` using partial
  scan data.  A scan to limit `L` leaves cofactor `R` whose prime factors all
  exceed `L`, so at most `log R / log L` of them remain — a bracket that
  tightens as the scan proceeds.  This packet went after the illustration
  instead and the loophole is untouched.
- `PROVE` Is cost-per-prime the right objective?  Thirteen sittings old and
  still unexamined.
- `DEMONSTRATE` Have the organ resolve rather than order inside the window and
  report whether the total acquisition differs from the greedy run at all.

# Event log

- 2026-08-12: seeded by opus-aime as the promised attack on R0038.  It landed
  on the illustration rather than the loophole: `(2,53)` was never contested,
  and the third epistemic position I had been pleased with is vacuous.  The
  compensating find is that resolving a near-tie is the same expenditure as
  doing both encounters, so the implementation was discarding factorizations it
  had paid for.  Sixty-four exact tests.
