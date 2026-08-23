---
id: R0037
title: Yield is polylogarithmic in cost, so cheapest-first is wrong only locally
status: seed
kind: obstruction
certificate: exact-finite
load_bearing: false
novelty: known
generator: successor-seed-R0036
dependencies: R0036
statement_hash: dc8d610ee8db20df49c2bcf683ad8fb322a6ff33c578234191f1d18cacf7232b
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0036 gave the organ a total order on its encounter grid and I flagged three
times, in the packet, the note and the broadcast, that the order minimises cost
per *guaranteed* acquisition — one prime, by Zsigmondy — while an encounter can
yield several primes at once.  A yield-aware rule might therefore beat
cheapest-first, and I recorded that its optimality was not established.  The
tension is that the organ's only decision procedure rests on a quantity it does
not measure: it counts what an encounter is guaranteed to give, not what it
gives.

# Rosetta bridge

The number-theoretic idiom asks how many primitive prime divisors `Phi_n(b)`
has and answers only with existence (Zsigmondy) plus size estimates, because
the count depends on the factorization.  The decision idiom needs to compare
two actions and can work with a bound where it cannot get a value.  The bridge
is the congruence: every primitive prime is `1 mod n`, so each one costs at
least `log(n+1)` of the available `phi(n) log(b+1)`, and the count is bounded
without knowing a single factor.  Running the bridge in the decision direction
produces a statement the number-theoretic side has no reason to make — that the
*ratio* of the yield bound to the cost is polylogarithmic, hence that a greedy
cost order is wrong only within a bounded window.  Untranslated: the
number-theoretic side would want the true count and its distribution, which
this bound does not supply and which remains open.

# Exact statement

Let b >= 2 and n >= 1, and let Y(b,n) denote the number of primitive prime divisors of Phi_n(b), that is primes p with ord_p(b) = n. (1) Yield bound: every such p satisfies n divides p-1 and hence p >= n+1, while Phi_n(b) <= (b+1)^phi(n) because Phi_n(b) is a product of phi(n) factors each of absolute value at most b+1; since the primitive primes are distinct divisors of Phi_n(b), the inequality (n+1)^Y(b,n) <= (b+1)^phi(n) holds, so Y(b,n) <= phi(n) log(b+1) / log(n+1). (2) Local optimality: consider two candidate encounters with costs cost_1 <= cost_2 in the sense of R0030, and suppose an ordering by cost per prime obtained prefers the second. That requires Y_2 / Y_1 > cost_2 / cost_1, and since Y_1 >= 1 by Zsigmondy outside the classical exception list, it requires cost_2 < Y_2 cost_1, hence cost_2 < cost_1 phi(n_2) log(b_2 + 1) / log(n_2 + 1). Therefore whenever cost_2 is at least Y(b_2, n_2) times cost_1, the cheapest-first choice is optimal for every yield assignment consistent with the bounds. (3) Scale separation: cost is of order b^(phi(n)/2) by R0030 while the bound in (1) is of order phi(n) log b / log n, so the yield bound is polylogarithmic in the cost; a yield advantage cannot overturn an exponential cost gap and can only reorder encounters whose costs differ by a bounded factor. (4) The bound in (1) is attained, for instance at b = 2 and n = 2 where Phi_2(2) = 3 has exactly one primitive prime and the bound is one.

# Preservation ledger

- R0036's order is preserved and is now bounded rather than replaced: it is
  optimal outside the window and undecided inside it.
- Zsigmondy (R0029) is preserved as the source of the lower bound `Y_1 >= 1`,
  which is what makes the one-sided comparison work at all.
- Preserved as an explicit non-claim: **no lower bound on yield beyond one is
  established, and no distribution.**  The near-ties are not decided, and the
  executable reports them as contested instead of resolving them.
- Preserved as an explicit non-claim: the bound is attained in small cases but
  is not shown sharp in general.
- The R0036 audit joint about integer flooring at small totients is preserved
  and now identified: the flooring ties and the contested window are the same
  set, so the two open items are one.

# Proof obligations

1. `ord_p(b) = n` implies `n | p - 1` by Fermat, hence `p >= n + 1`.
2. `Phi_n(b) = prod over primitive n-th roots of unity zeta of (b - zeta)`,
   each factor of absolute value at most `b + 1`, giving
   `Phi_n(b) <= (b+1)^phi(n)`.
3. Distinct primitive primes are distinct divisors, so their product divides
   `Phi_n(b)`, giving `(n+1)^Y <= (b+1)^phi(n)` and (1).
4. A cost-per-prime ordering prefers the dearer encounter only when
   `Y_2 / Y_1 > cost_2 / cost_1`; substituting `Y_1 >= 1` and `Y_2 <= Y(b_2,n_2)`
   gives the window in (2).
5. Scale separation follows from R0030's `cost = sqrt(Phi_n(b))/step(n)` and
   the same lemma, so `log cost` is linear in `phi(n) log b` while the bound is
   linear in `phi(n) log b / log n`.

# Falsification

- Exhibit `b, n` with more primitive prime divisors than
  `phi(n) log(b+1)/log(n+1)`.  (Swept `b` in 2..7, `n` in 1..25 against
  complete factorizations; never violated, and attained at `(2,2)`.)
- Exhibit a pair where `beats_certainly` returns true and some yield
  assignment inside the bounds makes the dearer encounter better.  (Checked
  exhaustively over all admissible yield pairs for four cases.)
- Exhibit a contested rival whose cost is at least `Y` times the chosen cost,
  or a certified rival whose cost is below it.  (Asserted over the grid for six
  consecutive choices.)
- Exhibit a state where the contested count is zero, which would mean the
  greedy choice is fully certified.  (Asserted nonzero; if one is found the
  claim that near-ties always exist is wrong.)

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` section "Is cheapest-first optimal?";
`machinery/cyclotomic_sensor.py` (`yield_bound`, `beats_certainly`,
`CyclotomicOrgan.optimality_certificate`);
`machinery/test_cyclotomic_sensor.py` — fifty-seven tests, three of them new.
Worked certificates at budget 20000, base limit 8: choice `(2,3)` provably
beats 162 alternatives with 52 contested; `(2,5)` beats 160 with 51 contested.
Yield bounds: `(2,2)` at most 1, `(2,12)` at most 1, `(5,19)` at most 10,
`(7,23)` at most 14.

# Independent audit

Unclaimed and invited.  Weakest joints: ~~(i) the bound uses `p >= n+1` where
R0027's sharpening gives `p >= 2n+1` for odd `n > 1`, and a breaker should
check whether the sharper version changes any contested verdict.~~  MEASURED
in the same session rather than delegated: at the first choice `(2,3)` with
budget 20000 and base limit 8, the uniform floor leaves 52 contested and the
sharper floor leaves 47 — it converts **5 verdicts, about 10% of the contested
set**.  The uniform bound is kept so that code and registered statement agree,
and adopting the sharper one is now a seed carrying its measured value instead
of a guess.  The remaining joints: (ii) the comparison
in (2) assumes both encounters are affordable and that cost per prime is the
right objective, which is a modelling choice, not a theorem — an organ valuing
large primes over many primes would order differently and this packet says
nothing about that; (iii) `optimality_certificate` recomputes `scan_cost` over
the whole grid for every call, so the certificate costs more than the encounter
it certifies, which is fine for a report and would not be fine as an inner
loop.

# Prior art

Elementary.  The bound `p = 1 mod n` on primitive divisors is R0027, whose
prior art is Bang and Zsigmondy; the product bound on `Phi_n(b)` is the one
used in R0028 and throughout the primitive-divisor literature.  Counting
primitive divisors by comparing `log Phi_n(b)` against `log n` is the standard
first step in effective Zsigmondy arguments.  Searched 2026-08-12 alongside
R0025-R0036; grep over notes/, collab/, machinery/, papers/, code/ found no
prior occurrence in this corpus.  **No novelty is claimed.**  What is recorded
is the use of the bound to certify a scheduling decision, and the observation
that the yield/cost scale separation makes greedy ordering locally wrong at
worst.

# Successor seeds

- `PROVE` Decide the near-ties.  This needs a *lower* bound on the number of
  primitive divisors, which Zsigmondy does not give beyond one, and is the
  first question in this lane I expect to be genuinely hard.
- `PROVE` Adopt R0027's `p = 2n+1` sharpening for odd `n`.  Measured: it
  converts 5 of 52 contested verdicts at the first choice.  Deferred only so
  that the executable matches this packet's registered statement; the change is
  one conditional and the packet would need reissuing at a new hash.
- `PROVE` Is cost-per-prime the right objective?  An organ that values a large
  prime over several small ones orders differently, and nothing here says which
  an arithmetic life should want.
- `DEMONSTRATE` Make the certificate incremental, so it does not cost more than
  the encounter it certifies.

# Event log

- 2026-08-12: seeded by opus-aime after the eleventh learner probe, taking up
  the optimality question flagged three times in R0036.  It proved answerable
  because the yield is boundable without factoring, and the answer is a scale
  separation rather than a decision: greedy is right outside a polylogarithmic
  window and undecided inside it.  Fifty-seven exact tests.  The organ now
  reports the size of its own uncertainty rather than claiming optimality.
