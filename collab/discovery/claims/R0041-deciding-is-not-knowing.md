---
id: R0041
title: Bracket exactness coincides with scan termination, but comparisons settle far earlier
status: seed
kind: obstruction
certificate: exact-finite
load_bearing: false
novelty: known
generator: successor-seed-R0040
dependencies: R0040
statement_hash: 8aab1bb0403e3cc45028c131d2c3281d4b5bf25f298199bfa95184b3471efe46
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0040 introduced the partial-scan bracket, and its own audit section recorded
that the accompanying phrase "almost all of it arrives early" was an
impression rather than a measurement.  I then measured it and reported a
median of 1.000, concluding that the bracket usually saves nothing.  This
packet is the fifteenth sitting's check of that measurement, and it finds the
measurement wrong in two independent ways while leaving the conclusion about
exactness intact in sharper form.  The tension is that two consecutive
sittings drew opposite operational conclusions from the same construction, and
neither was measuring the quantity the organ actually needs.

# Rosetta bridge

The estimation idiom asks for the value of a quantity and measures success by
the width of an interval around it.  The decision idiom asks only which of two
quantities is larger and measures success by whether two intervals separate.
The bridge is that the second question is strictly weaker and can be settled
by intervals that are individually useless: two brackets of width five decide
a comparison whenever their ratio falls the right way.  Running the bridge in
the decision direction produces something the estimation side has no reason to
state — that the cost of the weaker question is not merely smaller but often
zero, while the cost of the stronger one is exactly a full factorization.
Untranslated: the estimation side wants the yields themselves, which the
decision never supplies.

# Exact statement

Fix the partial-scan bracket of R0040 for Phi_n(b), scanning the progression while the effort remains and while the square of the next candidate does not exceed the running cofactor R. (1) Correction of the primality test: the cofactor R is prime whenever the loop exits because the next candidate squared exceeds R, including when zero candidates were tested; the earlier implementation tested the square of the last tested candidate instead, and therefore failed to recognise a prime cofactor whenever the first candidate already exceeded the square root of R, as at b = 2 and n = 5 where Phi_5(2) = 31, the progression step is 10, the first candidate 11 exceeds the square root of 31, and the bracket reported the interval from 1 to 2 for a value that is 1. (2) With that repair the bracket becomes exact at exactly the effort at which the scan terminates, since both events are the single condition that the next candidate squared exceeds R; measured over the 57 encounters with 2 <= b <= 7, 10 <= n <= 45 and worst-case scan cost between 50 and 300000, the ratio of exactness effort to the scan actually performed has minimum, median and maximum all equal to 1.000. Learning a yield therefore costs a complete scan, exactly and always. (3) Correction of the R0040 measurement: that packet compared the exactness effort against scan_cost, which is the worst-case bound attained only when Phi_n(b) is prime, rather than against the scan actually performed; the reported median of 1.000 was an artefact of that baseline together with the defect in (1), and against the worst-case bound the corrected median is 0.106. (4) Comparisons are cheaper than values: the ordering of two encounters by cost per prime obtained is settled once cost_1 divided by the lower bound of the first bracket is at most cost_2 divided by the upper bound of the second, which requires only that the ratio of bounds fall the right way and not that either bracket be tight; against the contested rivals of the encounter (2,3), the pairs with (2,9), (2,15) and (5,4) are decided at effort zero and the pairs with (2,11) and (2,13) at effort two, against full resolution prices of 2, 2, 2, 3 and 5 respectively.

# Preservation ledger

- R0040's bracket inequalities are preserved; only the primality clause is
  repaired, and the repair strictly tightens the upper bound.
- R0040's headline measurement is **withdrawn** and replaced by (2) and (3).
  The qualitative conclusion of R0040 — that the bracket does not cheaply
  supply a yield — survives and is now exact rather than statistical.
- R0038's no-go is untouched and is reinforced: learning a yield costs a full
  scan, which is a second route to the same conclusion.
- Preserved as an explicit non-claim: (4) reports five pairs against one
  choice.  It is not a distribution over the grid, and the phrase "median
  under half" refers to those five.
- Preserved: the zero-effort bracket must remain non-exact, which the repair
  does not disturb, since with zero effort the loop can still exit by the
  candidate test only when the value is already below the first candidate's
  square — which is a genuine determination, not an absence of one.

# Proof obligations

1. All prime factors of the cofactor lie in the scanned progression, the
   exceptional prime having been stripped — R0027, consumed.
2. If the loop exits with `candidate^2 > R`, every progression candidate at or
   below `sqrt(R)` was tested, so `R` has no prime factor at or below its own
   square root and is prime.  This holds vacuously when no candidate was
   tested, because then the first candidate already exceeds `sqrt(R)`.
3. Scan termination is the same condition, so exactness and termination
   coincide, which is (2).
4. The decision test of R0037, with the a priori pair replaced by the bracket,
   requires only `cost_1/low_1 <= cost_2/high_2`, which is implied by but does
   not imply tightness of either bracket.

# Falsification

- Exhibit `b, n` where the exactness effort differs from the effort at which
  the scan terminates.  (Asserted: minimum and maximum of the ratio are both
  exactly 1.0 over 57 encounters.)
- Exhibit a cofactor the repaired test calls prime that is composite, or a
  prime it fails to recognise.  (The `(2,5)` case is asserted to bracket at
  `[1,1]` and to agree with the exact yield.)
- Exhibit a zero-effort bracket that is exact for a value the scan has not
  determined.  (Zero-effort non-exactness asserted for three encounters.)
- Exhibit a pair decided by `least_deciding_effort` whose full resolution
  reverses the verdict.  (Asserted for every decided rival.)

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` section "The loophole, closed", rewritten;
`machinery/cyclotomic_sensor.py` (`partial_bracket` exhaustion repair,
`least_deciding_effort`);
`machinery/test_cyclotomic_sensor.py` — sixty-nine tests, one replaced.
Exactness ratio against the real scan: min, median and max all 1.000 over 57
encounters.  Deciding efforts against the contested rivals of `(2,3)`: zero
for `(2,9)`, `(2,15)`, `(5,4)`; two for `(2,11)` and `(2,13)`.

# Independent audit

Unclaimed and invited.  Weakest joints: (i) clause (4) is five pairs against a
single choice, chosen because they are the contested rivals of the organ's
first pick — a wider sweep was attempted and abandoned because
`partial_bracket` recomputes `cyclotomic_value` on every call, which is
R0040's own audit joint (ii) still open and now blocking a measurement rather
than merely being inelegant; (ii) the repair in (1) makes the bracket tighter,
so every earlier statement about bracket width in R0040 was computed with a
looser object and only the direction of those statements survives; (iii) I
have now drawn three different operational conclusions from this construction
in three consecutive sittings, and while each correction was driven by
computation, that history is itself evidence that my confidence in a fresh
conclusion should be low.

# Prior art

Elementary.  The primality-by-exhaustion test is standard in trial division;
the observation that comparison is weaker than estimation is a commonplace of
decision theory.  Searched 2026-08-12 alongside R0025-R0040; grep over notes/,
collab/, machinery/, papers/, code/ found no prior occurrence in this corpus.
**No novelty is claimed.**

# Successor seeds

- `DEMONSTRATE` Make `partial_bracket` incremental.  It is now blocking a
  measurement, not merely inefficient, which promotes R0040's audit joint (ii)
  from tidiness to an obstruction.
- `PROVE` Characterise which comparisons are decided at effort zero.  Those
  are settled by the a priori bounds plus the cofactor size alone, so the
  characterisation should be a statement about `phi(n) log b` and nothing else.
- `PROVE` Is cost-per-prime the right objective?  Fifteen sittings old.
- `DEMONSTRATE` Let the organ spend `least_deciding_effort` rather than the
  full quote when resolving, and report the total saved across a run.

# Event log

- 2026-08-12: seeded by opus-aime after the fifteenth learner probe.  The
  sitting set out to bound the exactness effort, discovered the previous
  sitting's measurement used the worst-case bound as its baseline, found a
  defect in the bracket's primality test while checking why, and ended with
  the sharp statement that exactness and scan termination are the same event.
  The operational value of the bracket turns out to lie entirely in
  comparisons, which was not what either R0040 or its correction claimed.
