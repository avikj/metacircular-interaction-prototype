---
id: R0029
title: The organ decides in advance which encounter earns a prime it cannot hold
status: seed
kind: synthesis
certificate: exact-finite
load_bearing: false
novelty: known
generator: learner-probe-of-R0028
dependencies: R0027
statement_hash: 10e8b14330b3180c26685409863113f8530ccb67c967f16281a8b8871b01b9de
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0028 let the organ factor an integer it is handed.  The third learner probe
found the next dead spot, and it is not a wrong answer: **every encounter is
proposed from outside.**  Asked for a new prime sensor, the organ had no
operation that could suggest one, so the encounters were guessed.  Guessing
`route(2, 6)` cost a full routing and earned nothing, with no way to know in
advance and no memory that would prevent a repeat.  And `(a,n) = (2,6)` is not
a random miss: it is the classical exception in Zsigmondy's theorem, walked
into blind by an organ whose own R0027 decides it in three lines.

# Rosetta bridge

Two idioms meet on the word *primitive*.  The number-theoretic idiom asks
whether `a^n - 1` has a prime divisor dividing no earlier `a^k - 1` — an
existence question, answered by Bang and Zsigmondy with a finite exception
list.  The formed-observer idiom asks whether an encounter is worth paying
for — a planning question about the machine's own future state.  The bridge is
that they are one question: a primitive divisor IS an acquisition, and the
exception list IS the set of encounters to decline.  Directional both ways:
number theory supplies the guarantee, and the observer idiom supplies the
demand that it be decidable *before* the encounter rather than verified after.
Untranslated: Zsigmondy's theorem is uniform in `a`, while an organ's history
is not, so the classical statement says more than any single organ can use.

# Exact statement

Let a >= 2 and n >= 1. Call a prime p a primitive divisor of Phi_n(a), the n-th cyclotomic polynomial evaluated at a, when ord_p(a) = n; such a p divides no a^k - 1 with k < n. Let P denote the largest prime factor of n, undefined for n = 1. Then Phi_n(a) has no primitive prime divisor if and only if: for n = 1, Phi_1(a) = a - 1 = 1; for n = 2, Phi_2(a) = a + 1 is a power of 2; and for n >= 3, Phi_n(a) is equal to 1 or to P. Proof from R0027: every prime divisor of Phi_n(a) is primitive or equals P, and in the latter case v_P(Phi_n(a)) = 1 except when (P,n) = (2,2); hence in the absence of a primitive divisor Phi_n(a) is a power of P with exponent at most one, the case n = 2 being the sole carve-out where the exceptional prime is 2 and the head has length two. Consequently the question of whether an encounter with exponent n yields a prime not already implied by all earlier exponents is decided by one comparison of Phi_n(a) against a number no larger than n, with no factorization of Phi_n(a) performed.

# Preservation ledger

- R0027 is the sole input and is preserved exactly.  Theorem 7 is R0027's
  dichotomy plus the observation that "not primitive" leaves only one prime
  available, to power one.
- The `(2,2)` carve-out is preserved for the third time, now appearing as the
  `n = 2` clause.  It is the same length-two head as R0026 Theorem 4, seen
  from a third side.
- Preserved as a sharp limit: this packet claims a **criterion**, not a
  reproof of Zsigmondy.  Closing the criterion into the classical finite list
  needs lower bounds on `Phi_n(a)` that are easy for `a >= 3` and delicate at
  `a = 2`; the list is verified here by exhaustive sweep and cited, not
  derived.
- Preserved: the guarantee is relative to one base.  A primitive prime for
  base `a` may already be held from an encounter with a different base.

# Proof obligations

1. R0027: every prime divisor of `Phi_n(a)` is primitive or is `P`, and the
   exceptional one has valuation 1 except at `(P,n) = (2,2)`.
2. Absence of a primitive divisor therefore forces `Phi_n(a)` to be a power of
   `P` of exponent at most 1, i.e. `1` or `P`.
3. `n = 2`: the exceptional prime is 2 and `v_2(Phi_2(a)) = v_2(a+1)` is
   unbounded, so the condition is that `a+1` have no odd prime factor.
4. `n = 1`: no exceptional prime exists, every divisor is primitive
   (`ord_p(a) = 1` for `p | a-1`), so the only failure is `a - 1 = 1`.
5. Decidability without factoring: `P <= n` is computed from `n` alone, and
   `Phi_n(a)` is evaluated by the Mobius product.  Neither step factors
   `Phi_n(a)`.
6. Primitivity implies novelty: `ord_p(a) = n` gives `p` does not divide
   `a^k - 1` for `k < n`, directly from the definition of order.

# Falsification

- Exhibit `a, n` where the criterion and an actual search for a primitive
  divisor disagree.  (Swept `2 <= a <= 19`, `1 <= n <= 18`, complete
  factorizations only, 300+ pairs, zero mismatches — a falsifier, not a proof.)
- Exhibit `a, n` outside `{(2,1), (2,6)} union {(a,2) : a+1 a power of 2}` with
  no primitive divisor, within the swept range.  (None found; the sweep
  reproduces the classical list exactly.)
- Exhibit a proposed encounter that earns no new prime.  (Asserted for the
  first nine proposals at `a = 2`; each earns a prime of order exactly the
  proposed exponent.)
- Exhibit an `n` the organ declines that does have a primitive divisor.

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` Theorem 7 and "Declining is the point";
`machinery/cyclotomic_sensor.py` (`has_primitive_divisor`,
`largest_prime_factor`, `CyclotomicOrgan.propose_encounter`);
`machinery/test_cyclotomic_sensor.py` — twenty-eight tests, three of them new.
Worked run from an empty organ at base 2: proposals
`2, 3, 4, 5, 7, 8, 9, 10, 11` earning `3, 7, 5, 31, 127, 17, 73, 11, {23,89}`;
nine encounters, nine acquisitions, `1` and `6` never proposed.

# Independent audit

Unclaimed and invited.  Weakest joints: (i) the `n = 2` clause is proved by a
different argument from the `n >= 3` clause and is the place a case has most
likely been dropped — a breaker should check `a` even, where `a+1` is odd and
the exceptional prime 2 does not divide `Phi_2(a)` at all; (ii) the claim that
a primitive prime is *new to the organ* is relative to one base and to
encounters, not to the whole sensor set, and the code's `routed` bookkeeping
treats an exponent as covered when it divides an already-routed exponent —
correct, but exactly the kind of index reasoning that hides an off-by-one;
(iii) the sweep bounds `a <= 19`, `n <= 18` are small, and completeness of the
budgeted factorization silently skips pairs, so the reproduction of the
classical list is weaker evidence than it looks.

# Prior art

Classical.  Existence of primitive prime divisors of `a^n - 1` outside an
explicit finite exception list is Bang (1886) for `a = 2` and Zsigmondy (1892)
in general; the exception set `{(2,1), (2,6)} union {(a,2) : a+1 = 2^k}` is the
standard one.  The reduction of the question to "is `Phi_n(a)` equal to 1 or to
the largest prime factor of `n`" is the standard first step of the usual proof.
Searched 2026-08-12 alongside R0025-R0028; grep over notes/, collab/,
machinery/, papers/, code/ found no prior occurrence in this corpus.  **No
novelty is claimed.**  What is recorded is the criterion in decidable form and
its use as an encounter-selection rule.

# Successor seeds

- `PROVE` Close the criterion into the classical list.  For `a >= 3`, `n >= 3`,
  `(a-1)^phi(n) > n` except at `n in {4,6}` which are checked directly.  The
  `a = 2` half needs a genuine lower bound on `Phi_n(2)`.
- `PROVE` The acquisition rate.  R0028 seed 4 restated with teeth: given that
  every proposed encounter earns a primitive prime `p = 1 mod n`, what is the
  set of primes reachable by `k` encounters?  This is the first question in
  the lane about the machine's history rather than about an integer.
- `PROVE` Multi-base proposal.  The guarantee is per base.  Given a set of
  held primes, which `(a,n)` maximizes guaranteed new acquisition?  The
  interference between bases is R0026 seed 3 wearing different clothes.
- `DEMONSTRATE` Have the organ print its refusal certificate — the equation
  `Phi_n(a) = P` — rather than merely skipping the index.

# Event log

- 2026-08-12: seeded by opus-aime after a third learner probe.  The organ had
  no operation that proposed an encounter; guessing walked it into the unique
  classical exception `(2,6)` and it paid for nothing.  Twenty-eight exact
  tests.  The criterion's exception sweep reproduces the Bang/Zsigmondy list
  exactly, which was not fitted and is the strongest evidence so far that the
  chain law of R0026 is the right object.
