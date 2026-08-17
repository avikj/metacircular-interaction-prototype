---
id: R0031
title: A budgeted organ's reachable count grows like 2A log B / log a
status: seed
kind: measurement
certificate: asymptotic
load_bearing: false
novelty: known
generator: learner-probe-of-R0030
dependencies: R0030
statement_hash: 7296bc8cedf3d88993d02800d114bc2e42bcb56e6341247bc37a94a0977e7c6a
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0030 gave the organ a finite horizon and a count: 101 reachable exponents at
`a = 2`, `B = 200000`.  The fifth learner probe asked the question that
follows — *if I double my budget, how much further do I see?* — and the answer
was **nothing**: 101 before, 101 after.  The organ could say neither why nor
what would help.  It had a measurement standing in for a law, which is exactly
the failure this repository's CLAUDE.md exists to prevent, filed against
myself in R0030's own successor seeds one increment earlier.  Two different
repairs are owed, and conflating them would be a third instance of the
merged-refusal defect: an asymptotic rate, and an exact next step.

# Rosetta bridge

The analytic idiom studies the distribution of totient values and proves
`#{n : phi(n) <= x} ~ A x` — a statement about how the integers are arranged.
The operational idiom asks what an observer with a budget can afford — a
statement about a machine's biography.  The bridge is R0030's identification of
the reachable set with a sublevel set of `phi`, which turns a density theorem
into a growth law for a machine's world.  Running it the operational way
produces something the analytic side has no reason to say: that acquisitions
are exponentially expensive in their count, so the machine's world grows
logarithmically in what it can spend.  Untranslated: the density theorem is
uniform over all `n`, while the organ meets exponents in a specific order and
therefore experiences a staircase the density theorem cannot see.

# Exact statement

Let a >= 2 be fixed and let B be a budget of trial divisions. (1) The proof of the R0030 lemma gives the two-sided bound |log Phi_n(a) - phi(n) log a| <= 2/(a-1), an absolute constant independent of n, since the Mobius tail sum over d dividing n of mu(n/d) log(1 - a^-d) is bounded in absolute value by sum over d >= 1 of 2 a^-d = 2/(a-1). (2) Hence the affordability condition sqrt(Phi_n(a)) / step(n) <= B is equivalent to phi(n) log a <= 2 log B + 2 log step(n) + O(1), and with step(n) <= 2n and n <= x^2 for x the largest affordable totient, the affordable set equals {n : phi(n) <= x_B} with x_B = (2 log B / log a)(1 + o(1)). (3) Consuming the classical density of totient values, #{n : phi(n) <= x} is asymptotic to A x with A = zeta(2) zeta(3) / zeta(6) = 1.9435964..., the number of reachable exponents is asymptotic to (2 A / log a) log B. (4) Inverting, the budget needed for k reachable exponents is a^(k/(2A) + o(k)), so each additional reachable exponent costs a fixed multiplicative factor a^(1/(2A)) of budget, approximately 1.1952 at a = 2. (5) The law is asymptotic and smooth while a particular organ's experience is a staircase: at a = 2 and B = 200000 the next reachable exponent costs 516928, a factor 2.58, and is index 106 rather than the smaller index 53, because Phi_2m(x) = Phi_m(-x) for odd m > 1 gives Phi_106(2) = (2^53 + 1)/3 against Phi_53(2) = 2^53 - 1, a factor 3 in size and therefore exactly sqrt(3) in scan cost.

# Preservation ledger

- R0030's exact affordability test and finite horizon are preserved unchanged;
  this packet adds a rate for the count, not a new criterion.
- The two-sided form of the bound (1) is preserved as a *reading* of R0030's
  proof rather than a new lemma: I had used only the lower half.
- The totient density is preserved as **consumed classical input**, not
  derived here, and is the only non-elementary ingredient.
- Preserved as an explicit limit: the `o(1)` is NOT effective.  The correction
  is `O(log log B)` with an unbounded constant, so the *offset* of the count is
  not claimed — only the rate.  The organ can predict its growth, not its
  count.
- The staircase is preserved as distinct from the rate.  Reporting the rate
  alone would answer "should I double?" with a number that is wrong for every
  particular budget.

# Proof obligations

1. Two-sidedness of the Mobius tail: `|sum_{d|n} mu(n/d) log(1 - a^-d)| <=
   sum_{d>=1} 2 a^-d = 2/(a-1)`, using `|log(1-x)| <= 2x` on `[0,1/2]`.
2. `sum_{d|n} mu(n/d) d = phi(n)`.
3. Self-consistency of `x_B`: `n <= x_B^2` from `phi(n) >= sqrt(n)`, so
   `log n <= 2 log x_B` and the `2 log step(n)` term is `O(log x_B)`, hence
   `x_B = (2 log B / log a)(1 + o(1))`.
4. Classical: `#{n : phi(n) <= x} ~ A x`, `A = zeta(2)zeta(3)/zeta(6)`.
5. Inversion of (3)+(4) to the budget factor `a^(1/2A)`.
6. `Phi_2m(x) = Phi_m(-x)` for odd `m > 1`, giving the `sqrt(3)` cost ratio
   between indices 53 and 106 at base 2.
7. Termination of the `next_budget_step` search: any encounter costing at most
   `C` satisfies `phi(n) log a <= 2 log(6 n C)` and so lies below
   `acquisition_horizon(a, C)`; the executable checks that its answer's own
   horizon fits inside the ceiling it searched, and raises otherwise.

# Falsification

- Exhibit a base and a budget range where the observed slope of the count
  against `log B` differs from `2A/log a` by more than the stated tolerance.
  (Derived slope at `a=2`: 12.913 per decade.  Computed over twelve decades,
  `10^2` to `10^14`: 53 -> 213, slope 13.33, a 3% agreement.  The test asserts
  10% over eight decades — wide enough for the staircase, tight enough to
  reject a factor-of-two error in `A`.)
- Exhibit a budget where `next_budget_step` returns a cost that is not the
  minimum over all unreachable encounters.  (Asserted at three budgets against
  a full scan below the answer's own horizon.)
- Exhibit a budget where the returned index is already affordable, or is not
  affordable at the returned cost.  (Both asserted.)
- Refute `3 Phi_106(2) = 2^53 + 1` or the `sqrt(3)` cost ratio.  (Both
  asserted exactly; my first attempt at this identity was wrong by 2 and the
  test caught it.)

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` section "What a bigger budget buys";
`machinery/cyclotomic_sensor.py` (`TOTIENT_DENSITY`, `growth_rate`,
`budget_factor_per_exponent`, `next_budget_step`);
`machinery/test_cyclotomic_sensor.py` — thirty-seven tests, four of them new.
The flat tread that motivated this: `B = 200000` and `B = 400000` both give
101 reachable exponents.  The staircase at `a = 2`: `200000 -> 516928` (2.58x,
buys 106), `600000 -> 828506` (1.38x, buys 81), `2000000 -> 2069794` (1.03x,
buys 116).

# Independent audit

Unclaimed and invited.  Weakest joints: (i) step 3, the self-consistency of
`x_B`, is where an `o(1)` could be hiding a constant factor rather than a
vanishing term — a breaker should check whether `2 log step(n)` can conspire
with the `phi(n) >= sqrt(n)` bound to shift the *rate* and not merely the
offset; (ii) the twelve-decade slope check is a single base and a single
window, and a 3% agreement over that range is consistent with rates differing
by a slowly varying factor; (iii) `certainly_unaffordable` is now used to
prune the `next_budget_step` search, so a slip in its inequality direction
would silently return a non-minimal stair rather than an error — the pruning
is the one place in this packet where a bug is invisible rather than loud;
~~(iv) `TOTIENT_DENSITY` is a hard-coded float, and nothing in the executable
checks it against `zeta(2)zeta(3)/zeta(6)`.~~  CLOSED in the same session by a
test computing the constant from its definition to nine places.  Writing that
test exposed a second-order slip of my own: the truncated zeta series is short
by about `1/N` at `s = 2`, so the first version of the check failed and the
temptation was to loosen the tolerance.  The integral tail
`int_N^inf x^-s dx = N^(1-s)/(s-1)` repairs it and the agreement is ten
digits.

# Prior art

Classical.  `#{n : phi(n) <= x} ~ (zeta(2)zeta(3)/zeta(6)) x` is standard
totient-distribution theory; `Phi_2m(x) = Phi_m(-x)` for odd `m` is elementary;
the estimate `log Phi_n(a) = phi(n) log a + O(1)` appears in every treatment of
Zsigmondy and in Cunningham-project cost tables.  Searched 2026-08-12
alongside R0025-R0030; grep over notes/, collab/, machinery/, papers/, code/
found no prior occurrence in this corpus.  **No novelty is claimed.**  What is
recorded is the assembly into a growth law for a budgeted observer, and the
separation of that smooth law from the exact staircase the observer actually
walks.

# Successor seeds

- `PROVE` Make the `o(1)` effective.  Bounding the `O(log log B)` correction
  would let the organ predict its count rather than only its growth, which is
  the difference between a law it can use and a law it can quote.
- `PROVE` The prime count, not the exponent count.  Each reachable `n` yields
  at least one primitive prime, so the organ holds at least `2A log B / log a`
  primes; the upper bound needs the number of primitive divisors of
  `Phi_n(a)`.
- `PROVE` Staircase structure.  The treads observed here are 2.58, 1.38, 1.03
  against a derived mean factor 1.195.  Is the tread distribution governed by
  the gaps in the totient value set, and does it have a limiting law?
- `DEMONSTRATE` Two bases.  Every statement in R0025-R0031 is per base; the
  organ still cannot say what a second base buys it.  This is the fifth
  consecutive packet whose successor list ends here, which is itself a signal.

# Event log

- 2026-08-12: seeded by opus-aime after a fifth learner probe.  Doubling the
  budget bought nothing and the organ had no law to explain it.  The debt was
  self-filed in R0030's successor seeds one increment earlier.  Thirty-seven
  exact tests.  A wrong identity for `Phi_106(2)` — off by 2, from misapplying
  `Phi_m(-x)` — was caught by a failing test rather than by reading.
