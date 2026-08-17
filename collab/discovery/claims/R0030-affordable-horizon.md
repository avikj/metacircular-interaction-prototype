---
id: R0030
title: A budgeted organ's reachable exponents form a finite sublevel set of phi
status: seed
kind: obstruction
certificate: exact-finite
load_bearing: false
novelty: known
generator: learner-probe-of-R0029
dependencies: R0029
statement_hash: b41c0eef927bebb5cc342d3f2ce43134cc429c687be9f96740685577f3f5545c
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0029 gave the organ a guaranteed acquisition rule, and the fourth learner
probe let it use that rule repeatedly.  It breaks its own promise.  Forced to
the frontier at base 2 it proposes `n = 61`, spends its entire budget of
200,000 trial divisions, and earns nothing; the primitive prime is `2^61 - 1`
itself, sitting unrecognized in the returned cofactor.  R0029's guarantee is
about **existence**; the routing's delivery is about **budget**; the organ had
merged them and could report the failure only as a boolean.  The tension is
between a theorem that says a thing is there and an organ that cannot reach
it, with no vocabulary for the difference.

# Rosetta bridge

The analytic idiom measures `Phi_n(a)` by its size, `about a^phi(n)`, and asks
how it grows.  The operational idiom measures an encounter by what it costs
and asks what a fixed budget can see.  The bridge is that the growth exponent
IS the cost exponent, so a lower bound on `Phi_n(a)` becomes an upper bound on
what an organ can reach.  Running the bridge in the operational direction
produces something the analytic side has no reason to state: that the reachable
set is a sublevel set of `phi` rather than an interval, so an organ sees
arbitrarily far along smooth exponents and is walled off from prime ones.
Untranslated: the analytic side cares about `Phi_n(a)` for its own sake and
has no notion of an observer with a budget.

# Exact statement

Let a >= 2 and n >= 1. (1) Lemma: Phi_n(a) > a^phi(n) / 8. Proof: from Phi_n(a) = product over d dividing n of (a^d - 1)^mu(n/d), log Phi_n(a) = phi(n) log a + sum over d dividing n of mu(n/d) log(1 - a^-d), using sum over d dividing n of mu(n/d) d = phi(n); since a >= 2 gives a^-d <= 1/2 and |log(1-x)| <= 2x on [0,1/2], the second sum is bounded in absolute value by sum over d >= 1 of 2 a^-d = 2/(a-1) <= 2, so Phi_n(a) >= a^phi(n) exp(-2) > a^phi(n)/8. (2) Fix a budget B of trial divisions. The guided scan of Phi_n(a) of R0027 is guaranteed to complete when sqrt(Phi_n(a)) / step(n) <= B, where step(n) <= 2n is the progression modulus. By (1) this forces phi(n) log a <= 2 log(6 n B). (3) Since phi(n) >= sqrt(n) for n > 6, the condition in (2) fails for all sufficiently large n, so the set of affordable exponents is finite; an explicit bound is the least N greater than (4 / log a)^2 satisfying sqrt(N) log a > 2 log(6 N B), beyond which the difference sqrt(n) log a - 2 log(6 n B) is increasing. (4) The affordable set is therefore a sublevel set of phi and not an interval in n: at a = 2 and B = 200000 the proved bound is N = 4151, exactly 101 exponents are affordable, the largest is 210, and 53 and 61 are not affordable although they are smaller.

# Preservation ledger

- R0029's existence guarantee is preserved exactly and is NOT weakened: a
  primitive prime still exists for every `n` outside the classical list.  What
  is added is a second, independent predicate about reachability.
- The two refusals are preserved as distinct.  "Nothing is there" (R0029) and
  "something is there and I cannot reach it" (this packet) differ in that only
  the second is repaired by a larger budget.  Merging them would repeat the
  defect the crystal runtime documents for `UNORIENTABLE` versus `EXHAUSTED`
  (`machinery/crystal/README.md`).
- The affordability test is preserved as a **guarantee, not a prediction**:
  it uses the worst case `Phi_n(a)` prime.  An unaffordable encounter may
  still complete by luck if a small factor appears early, and the executable
  says so.
- The earlier `(a-1)^phi(n)` lower bound of R0028 is preserved but superseded
  in role: it is vacuous at `a = 2`, which is exactly why the new lemma was
  needed.

# Proof obligations

1. `sum over d dividing n of mu(n/d) d = phi(n)` — standard Mobius inversion
   of `sum over d dividing n of phi(d) = n`.
2. `|log(1-x)| <= 2x` for `0 <= x <= 1/2`.
3. `sum over d >= 1 of 2 a^-d = 2/(a-1) <= 2` for `a >= 2`; hence
   `Phi_n(a) >= a^phi(n) exp(-2) > a^phi(n)/8`.
4. `phi(n) >= sqrt(n)` for `n > 6` — standard.
5. Monotonicity of `f(n) = sqrt(n) log a - 2 log(6 n B)` beyond
   `n = (4/log a)^2`: `f'(n) = log a/(2 sqrt n) - 2/n > 0` iff
   `sqrt n log a > 4`.  This is what makes the horizon search terminate with a
   proof rather than at a chosen cutoff.
6. The worst-case scan cost is `sqrt(Phi_n(a))/step(n)` candidates, attained
   when `Phi_n(a)` is prime; correctness of the scan is R0027 obligation 6.

# Falsification

- Exhibit `a, n` with `8 Phi_n(a) <= a^phi(n)`.  (Swept `2 <= a <= 11`,
  `n <= 59`; the observed minimum of the ratio is `1/2`, at `(a,n) = (2,1)`.)
- Exhibit an affordable encounter whose guided scan does not complete.
  (Asserted for every affordable `n < 60` at `B = 20000`.)
- Exhibit `n` beyond the computed horizon that is affordable.  (Asserted for
  three values past the bound.)
- Exhibit a proposal that fails to complete or fails to earn a primitive
  prime.  (Asserted for twenty consecutive proposals at `B = 20000`.)
- Refute the sublevel-set shape by exhibiting an organ whose reachable set is
  an interval in `n`.

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` lemma, Theorem 8, and the two sections following;
`machinery/cyclotomic_sensor.py` (`totient`, `scan_cost`,
`certainly_unaffordable`, `affordable`, `acquisition_horizon`, `refusal`, and
the budget argument of `propose_encounter`);
`machinery/test_cyclotomic_sensor.py` — thirty-three tests, five of them new.
The failure that motivated this: `route(2, 61)` at `B = 200000` returns no
factors, `complete = False`, cofactor `2305843009213693951`.  The horizon at
`a = 2`, `B = 200000`: proved bound 4151, 101 affordable exponents, largest
210, with `n = 53` costing 895,344 and `n = 61` costing 12,446,725 candidates.

# Independent audit

Unclaimed and invited.  Weakest joints: (i) `|log(1-x)| <= 2x` on `[0,1/2]` is
used at the endpoint, where it is tight — a breaker should confirm the
constant 8 survives, since a slip there silently weakens every downstream
bound; (ii) the monotonicity argument in obligation 5 makes the horizon search
terminate, and if it is wrong the search returns an arbitrary cutoff dressed
as a theorem, which is the worst failure mode available here; (iii) the
sublevel-set claim is exhibited at one `(a, B)` and derived in general, but the
count 101 and the maximum 210 are single measurements and should not be read
as a law; (iv) `scan_cost` assumes `step(n) <= 2n`, which fails to be tight for
even `n` where the step is only `n` — the direction is safe but the audit
should confirm it is safe rather than merely plausible.

# Prior art

The ingredients are classical: the Mobius form of the cyclotomic polynomial,
`sum mu(n/d) d = phi(n)`, `phi(n) >= sqrt(n)` for `n > 6`, and the estimate
`Phi_n(a) = a^phi(n) (1 + O(a^-1))` which appears in every proof of Zsigmondy's
theorem and in Cunningham-project cost estimates.  Searched 2026-08-12
alongside R0025-R0029; grep over notes/, collab/, machinery/, papers/, code/
found no prior occurrence in this corpus.  **No novelty is claimed for the
lemma.**  What is recorded is its use as a statement about a budgeted
observer's reachable set, and the observation that that set is shaped by `phi`
rather than by size.

# Successor seeds

- `PROVE` The acquisition count.  Each affordable `n` yields at least one
  prime `= 1 mod n`, so an organ exhausting budget `B` holds at least
  `#{affordable n}` primes.  An upper bound needs the number of primitive
  divisors of `Phi_n(a)`, which is where this stops being bookkeeping.
- `PROVE` Asymptotics of the affordable count.  `#{n : phi(n) <= x}` is
  classical (about `x` times a constant); combining it with the `log(6nB)`
  coupling should give the reachable count as an explicit function of `B`.
- `PROVE` Does raising the budget ever unlock a *smaller* exponent than one
  already reachable?  The sublevel-set shape suggests the reachable set grows
  non-monotonically in an interesting way as `B` grows.
- `DEMONSTRATE` The same horizon analysis for `a^n + 1`, where `Phi_2` and the
  length-two head live; the cost exponent should be `phi(2n)` and the
  reachable set correspondingly different.

# Event log

- 2026-08-12: seeded by opus-aime after a fourth learner probe.  The organ
  proposed `n = 61`, spent its whole budget and earned nothing.  The defect
  was a merged refusal: existence and reachability were the same `bool`.
  Thirty-three exact tests.  The lemma `Phi_n(a) > a^phi(n)/8` also repairs a
  weakness flagged in R0028's own audit section, where the `(a-1)^phi(n)`
  bound was recorded as vacuous at `a = 2`.
