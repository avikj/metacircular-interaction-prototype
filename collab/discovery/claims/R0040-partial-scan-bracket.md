---
id: R0040
title: A partial scan brackets the yield, closing the loophole in R0038
status: seed
kind: transport
certificate: exact-finite
load_bearing: false
novelty: known
generator: successor-seed-R0039
dependencies: R0038
statement_hash: e2476cf419ee37b9d51d99955757b8c80751df070a5b197bba6a80cd68f5d780
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0038 proved that no bound on `(b,n)` alone improves Zsigmondy's `Y >= 1`, and
I recorded in its own audit section that a bound using data short of a full
factorization was not excluded.  R0039 was meant to attack that and attacked an
illustration instead, leaving the loophole open a second time and saying so.
The tension is between a no-go I have been quoting as though it closed the
question and a hypothesis it explicitly did not cover: a partial scan is not a
function of `b` and `n`, so nothing in R0038 forbids it from bracketing the
yield, and if it does then the organ's uncertainty is not binary but
continuous in effort.

# Rosetta bridge

The factoring idiom runs trial division to completion and reports a
factorization; a partial run is an unfinished job with a cofactor attached.
The decision idiom does not want the factorization, only enough of it to order
two actions, and can stop as soon as the order is settled.  The bridge is that
an unfinished scan is not a failure but a *measurement*: every prime it did not
find exceeds the limit it reached, so the cofactor's size bounds how many can
remain.  Running the bridge in the decision direction produces something the
factoring side has no reason to state — that the useful content of a scan is
almost entirely in its first few percent, because the bracket closes long
before the scan does.  Untranslated: the factoring side wants the factors
themselves, which no bracket supplies.

# Exact statement

Fix b >= 2 and n >= 1, and scan the arithmetic progression of R0027 for Phi_n(b) through its first e candidates, reaching last tested candidate L, after first dividing out the exceptional prime. Let p_1 through p_k be the distinct primes found and R the remaining cofactor. (1) Every prime factor of R is primitive, by R0027, since the exceptional prime has been removed; and every such factor exceeds L, since the scan tested every progression candidate up to L and every primitive prime lies in the progression; and every such factor is at least n+1, by R0027's congruence. (2) Hence, writing F for max(L, n), the number of primes dividing R is at least 1 when R > 1 and at most the largest j with F^j < R, so k + [R > 1] <= Y(b,n) <= k + max{ j : F^j < R }. (3) If R > 1 and L^2 >= R then R has no prime factor at or below its square root among the progression, so R is prime and both bounds equal k+1. (4) Both bounds are monotone in e, the lower non-decreasing and the upper non-increasing. (5) Consequently the comparison of two encounters by cost per prime obtained is settled as soon as cost_1 divided by the lower bound for the first is at most cost_2 divided by the upper bound for the second, which occurs at an effort far below either full scan: at base 5 and index 19 the yield is determined exactly after 166 candidates where the complete scan requires 57466, and the contested pair (2,3) against (2,11), which the a priori test of R0037 cannot decide, is decided at effort 20.

# Preservation ledger

- R0038's no-go is preserved exactly and is not contradicted: it concerns
  bounds that are functions of `b` and `n`, and a partial scan is not one.  I
  stated that scope when proving it, which is what left this available.
- R0037's certification test is preserved; `certify_with_effort` replaces its a
  priori pair `(1, yield_bound)` with the bracket and is otherwise identical.
- Preserved as an explicit non-claim: **no bound is given on the effort at
  which the bracket becomes exact.**  That depends on the second-largest prime
  factor of the primitive part and is not controlled here; the three tabulated
  efforts are observations.
- Preserved: the bracket is computed in integer arithmetic throughout.  A
  logarithmic form would be shorter and would need an error analysis to be
  trustworthy at the boundary.

# Proof obligations

1. Primes dividing `Phi_n(b)` are primitive or are the exceptional prime —
   R0027, consumed.
2. Primitive primes satisfy `p = 1 mod n`, hence lie in the scanned
   progression and satisfy `p >= n+1` — R0027, consumed.
3. A scan through candidate `L` therefore leaves only primes exceeding
   `max(L, n)`, giving the upper bound by `F^j < R`.
4. `R > 1` forces at least one surviving prime, giving the lower bound.
5. `L^2 >= R > 1` forces `R` prime: any proper factorization would have a
   factor at most `sqrt(R) <= L`, which the scan would have found.
6. Monotonicity: increasing `e` can only move primes from `R` into the found
   list and can only increase `L`.

# Falsification

- Exhibit `b, n, e` where the true yield lies outside the bracket.  (Asserted
  for five `(b,n)` pairs at nine efforts each against the exact yield.)
- Exhibit an effort at which the bracket is wider than at a smaller effort.
  (Monotonicity asserted across the same grid.)
- Exhibit a zero-effort bracket that is exact.  (Asserted `low = 1` and
  `high > 1` at zero effort; an earlier version reported `[1,1]` here, which
  was a spurious certainty and is the defect this test now prevents.)
- Exhibit a pair certified by `certify_with_effort` whose full resolution
  reverses the verdict.  (Asserted for `(2,3)` against `(2,11)`.)
- Exhibit a distribution of exactness efforts materially better than the
  measured one.  (Median fraction 1.000 over 57 encounters; a claim that the
  bracket usually saves work would be refuted by that median.)

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` section "The loophole, closed";
`machinery/cyclotomic_sensor.py` (`YieldBracket`, `partial_bracket`,
`certify_with_effort`);
`machinery/test_cyclotomic_sensor.py` — sixty-eight tests, four of them new.
Tabulated: `(2,29)` true yield 3, a priori bound 9, full scan 401, exact at
effort 20; `(5,19)` true yield 3, bound 10, full scan 57466, exact at 166;
`(2,41)` true yield 2, bound 11, full scan 18086, exact at 164.

# Independent audit

Unclaimed and invited.  Weakest joints: (i) clause (3) infers primality of the
cofactor from `L^2 >= R`, which is correct only because *every* prime factor of
`R` lies in the scanned progression — if the exceptional prime were not
stripped first the inference would be false, and the code strips it before the
loop but the statement's dependence on that ordering is easy to miss;
(ii) `partial_bracket` recomputes `cyclotomic_value` on every call, so
repeatedly increasing the effort re-does all previous work, which is fine for
a report and wrong for an incremental loop — the interface invites a misuse it
does not support; ~~(iii) the exactness efforts are three data points and the
packet says nothing about their distribution, while the phrase "almost all of
it arrives early" in the note is an impression rather than a measurement.~~
**MEASURED in the same session, and the impression was wrong.**  Over the 57
encounters the median fraction of the scan needed for exactness was reported as
**1.000**.  **That measurement is itself withdrawn by R0041**, which found it
wrong twice: it used `scan_cost`, the worst-case bound, as its baseline rather
than the scan actually performed; and the bracket was loose because its
primality test examined the last tested candidate instead of the loop exit
condition.  Repaired, the correct statement is exact rather than statistical:
bracket exactness coincides with scan termination always, so learning a yield
costs a full scan, and the operational value of the bracket lies entirely in
comparisons, which settle far earlier.  See R0041.

# Prior art

Elementary and standard.  Bounding the number of remaining prime factors of a
cofactor by its size against the trial-division limit is routine in any
incremental factoring implementation; the congruence floor is R0027, whose
prior art is Bang and Zsigmondy.  Searched 2026-08-12 alongside R0025-R0039;
grep over notes/, collab/, machinery/, papers/, code/ found no prior
occurrence in this corpus.  **No novelty is claimed.**  What is recorded is the
use of the bracket to certify a scheduling comparison, and the resulting
continuity of the organ's certainty in its effort.

# Successor seeds

- `PROVE` Bound the effort at which the bracket becomes exact.  The measured
  median of 1.000 says it is controlled by the second-largest primitive prime,
  and when there is only one primitive prime the effort is the whole scan —
  which is R0038's no-go recurring one level in, and now looks like the honest
  general statement rather than a conjecture.
- `DEMONSTRATE` Make `partial_bracket` incremental so that raising the effort
  continues a scan rather than restarting it, closing audit joint (ii).
- `PROVE` Is cost-per-prime the right objective?  Fourteen sittings old and
  still the oldest unexamined assumption in the lane.
- `DEMONSTRATE` Let the organ choose its effort: spend until the bracket
  certifies or the budget for deciding is exhausted, and report which happens.

# Event log

- 2026-08-12: seeded by opus-aime after the fourteenth learner probe, closing
  a loophole deferred twice.  The first implementation reported an exact
  bracket at zero effort — a manufactured certainty, caught only because the
  probe printed effort zero rather than starting at one.  Sixty-eight exact
  tests.
