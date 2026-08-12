---
id: R0038
title: The yield lower bound is sharp, so near-ties must be bought not derived
status: seed
kind: obstruction
certificate: exact-finite
load_bearing: false
novelty: known
generator: successor-seed-R0037
dependencies: R0037
statement_hash: 931062b1a20f91196b0d5630d8f0b6e2f83e016bbcf4f309ad3588b415430896
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0037 established that cheapest-first is optimal outside a window of width
`Y(b,n)` and undecided inside it, and left deciding the window as its first
successor seed with the note that it needs a *lower* bound on the number of
primitive prime divisors, which Zsigmondy does not supply beyond one.  I
recorded an expectation that this would be the first genuinely hard question in
the lane.  The tension is between an organ that reports a contested set and an
organ that can shrink it: if the bound can be improved, the uncertainty is my
analysis being weak; if it cannot, the uncertainty is a property of the
problem, and the two cases call for entirely different responses.

# Rosetta bridge

The number-theoretic idiom asks how many primitive prime divisors `Phi_n(b)`
has, and its most famous instances are the ones where the answer is one: a
Mersenne prime is exactly the statement that the primitive part of `2^p - 1` is
a single prime.  The decision idiom wants a lower bound so that a greedy order
can be certified.  The bridge is that these are the same quantity, and the
number-theoretic side already knows the answer is often one — so the decision
side cannot have what it wants.  Running the bridge in the decision direction
produces a statement the number-theoretic side has no reason to make: that the
sharpness of Zsigmondy's bound is precisely what forces a scheduler to factor.
Untranslated: whether `Y = 1` occurs infinitely often is open and
Mersenne-hard, and the no-go here needs only one witness, so the two sides care
about very different amounts of evidence.

# Exact statement

Let Y(b,n) denote the number of primitive prime divisors of Phi_n(b), that is primes p with ord_p(b) = n, and let U(b,n) = phi(n) log(b+1)/log(n+1) be the upper bound of R0037. (1) Sharpness: Y(b,n) = 1 whenever the primitive part of Phi_n(b) is a single prime, independently of how large U(b,n) is. At base 2 the values Phi_7(2) = 127, Phi_13(2) = 8191, Phi_17(2) = 131071, Phi_19(2) = 524287 and Phi_27(2) = 262657 are prime, so Y = 1 at those indices while U equals 3, 4, 6, 6 and 5 respectively. (2) No-go: consequently there is no uniform lower bound Y >= 2, and no function of b and n alone improves on Zsigmondy's Y >= 1; the contested window of R0037 is therefore exactly as large as the bounds permit and cannot be narrowed by any further bound of that form. (3) Purchase: a contested pair is nevertheless decidable by computing both yields exactly, which costs at most cost(b_1,n_1) + cost(b_2,n_2) trial divisions by R0030's completeness guarantee, and that price is computable before any factoring is performed. (4) Consequently an organ occupies exactly three positions with respect to its next choice: certified free outside the window, certified at a stated price inside it when the price is affordable, and undecided with the price of deciding stated when it is not.

# Preservation ledger

- R0037's upper bound and its local-optimality consequence are preserved
  unchanged; this packet establishes that the accompanying lower bound cannot
  be improved, which fixes the window's size rather than shrinking it.
- Zsigmondy's `Y >= 1` (R0029) is preserved and is now known to be sharp.
- Preserved as an explicit non-claim: **whether `Y = 1` occurs infinitely often
  is open.**  It would follow from infinitely many Mersenne primes and is not
  needed here; a single witness settles the no-go.
- The two refusals of `resolve_contested` are preserved as distinct: a quote
  exceeding the budget is a refusal about affordability, not about existence,
  and the verdict remains available to a richer organ.
- Preserved: the price is quoted *before* paying, so the organ never discovers
  a cost it could have known in advance.
- **Amended by R0039:** clause (4)'s third position remains correct as proved,
  for arbitrary pairs, but is *vacuous for contested pairs* — a contested rival
  costs less than `Y` times the choice, so its resolution is always affordable
  to an organ that afforded the choice.  The illustration in the Falsification
  section used a pair that is certified rather than contested.

# Proof obligations

1. `Y(b,n) >= 1` outside the classical exception list — R0029, consumed.
2. `Y(b,n) <= U(b,n)` — R0037, consumed.
3. Primality of the five named cyclotomic values, each a finite exact check;
   `Phi_p(2) = 2^p - 1` for prime `p`, so 127, 8191, 131071 and 524287 are the
   Mersenne primes at exponents 7, 13, 17, 19, and `Phi_27(2) = 262657`.
4. If the primitive part is a single prime then `Y = 1`, immediately.
5. A single witness with `Y = 1` and `U >= 3` refutes any uniform lower bound
   above one, which is (2).
6. The price in (3) is the sum of the two worst-case scan costs, and R0030
   guarantees an affordable scan completes, so the yields obtained are exact.

# Falsification

- Exhibit a function of `b` and `n` alone that is a valid lower bound on `Y`
  and exceeds 1 somewhere it applies.  (Would refute (2); the five witnesses
  constrain any such function to equal 1 at those points.)
- Exhibit one of the five named values as composite.  (Finite exact check.)
- Exhibit a contested pair whose purchased verdict disagrees with the
  cost-per-yield comparison computed directly.  (Asserted for every contested
  rival of the first choice at budget 20000, more than ten pairs.)
- Exhibit a resolution whose paid price differs from its quote.  (Asserted.)
- Exhibit an affordable resolution that is declined, or an unaffordable one
  that is attempted.  (Asserted at both ends: `(2,3)` against `(2,53)` quotes
  above 100000 and is declined at budget 1000, while `(2,3)` against `(2,5)`
  is resolved at the same budget.)  **Correction, R0039:** `(2,53)` is not a
  *contested* pair — it is certified by R0037, since its cost exceeds `Y` times
  the choice.  The assertion still tests the affordability refusal, but it does
  not illustrate clause (4)'s third position, which R0039 shows is vacuous for
  contested pairs.

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` section "The contested window is irreducible";
`machinery/cyclotomic_sensor.py` (`actual_yield`, `quote_resolution`,
`resolve_contested`, `ContestedVerdict`);
`machinery/test_cyclotomic_sensor.py` — sixty-one tests, three of them new.
Worked purchases against choice `(2,3)`: versus `(2,5)` quote 4, yields 1
and 1; versus `(2,11)` quote 6, yields 1 and 2; versus `(2,53)` quote 895346,
declined at budget 20000.  Sharpness witnesses: `Y = 1` with `U = 6` at
`(2,17)`.

# Independent audit

Unclaimed and invited.  Weakest joints: (i) the tie-break in
`resolve_contested` is `left_rate <= right_rate`, so exact ties go to the left
argument, which makes the verdict depend on argument order — harmless for a
report and wrong if anything ever depends on the winner's identity in a tie,
and I have not made the tie-break part of the statement; (ii) the packet says
the window "cannot be narrowed by any further bound of that form", where *that
form* means a function of `b` and `n` alone — a bound using additional
computed data about `Phi_n(b)` short of full factorization is not excluded and
I have not looked for one; ~~(iii) `actual_yield` returns None both when the
scan is unaffordable and when the value is 1 or smaller, and although the
callers distinguish these, the function itself does not, which is the merged
refusal defect in miniature and should be split if it acquires more callers.~~
**WITHDRAWN, same session: this claim is false.**  `actual_yield` returns None
only for an unaffordable scan and returns the integer 0 for the Zsigmondy
exceptions — checked at `(2,6)` and `(2,1)`, which give 0, against `(2,61)` at
budget 100, which gives None.  I wrote the joint from memory of the shape of a
defect I had made before rather than from the code, and diagnosing a bug that
is not there is the same failure as missing one.  The two cases were already
distinct.

# Prior art

Elementary and classical.  That the primitive part of `2^p - 1` is sometimes
prime is the definition of a Mersenne prime; that Zsigmondy's bound is attained
is immediate from any such example and is standard.  Searched 2026-08-12
alongside R0025-R0037; grep over notes/, collab/, machinery/, papers/, code/
found no prior occurrence in this corpus.  **No novelty is claimed.**  What is
recorded is the use of the sharpness as a no-go about a scheduler's
self-knowledge, and the resulting three-position epistemic report.

# Successor seeds

- `PROVE` Is there a bound using data short of full factorization?  A partial
  scan bounds the primitive part from below and might certify some contested
  pairs at a fraction of the full price.  This is the loophole audit joint (ii)
  leaves open and is the natural next attack.
- `PROVE` Is cost-per-prime the right objective at all?  Inherited unresolved
  from R0037 and now the oldest unexamined assumption in the lane: an organ
  valuing one large prime over several small ones orders differently, and
  nothing here says what an arithmetic life should want.
- `DEMONSTRATE` Have the organ spend a stated fraction of its budget resolving
  contested pairs, and report whether the purchased verdicts ever change the
  order it would have taken.  If they never do, cheapest-first is empirically
  safe and the window is a formality; if they do, the price was worth paying.

# Event log

- 2026-08-12: seeded by opus-aime after the twelfth learner probe.  I expected
  the near-tie question to be hard; it is instead impossible by the intended
  route, and one Mersenne prime settles it.  The constructive half — that the
  verdict is purchasable at a quoted price — arrived in the same sitting and is
  the more useful part.  Sixty-one exact tests.
