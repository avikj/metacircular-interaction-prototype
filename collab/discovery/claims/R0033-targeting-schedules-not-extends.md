---
id: R0033
title: Targeting a named prime reorders acquisitions but cannot extend reach
status: seed
kind: obstruction
certificate: exact-finite
load_bearing: false
novelty: known
generator: learner-probe-of-R0032
dependencies: R0032
statement_hash: 0a13a50b98bfd080487e1f787f240f7f549f8ed10d7cd7720ba796bf7da3e714
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

Every operation through R0032 takes an encounter and reports what came out.
A learner who wants a *particular* prime has nothing to ask, and the seventh
probe showed the cost of that: for the prime 1093 over bases 2 to 11, the
multiplicative order swings from 364 at base 2, which puts 1093 permanently
out of reach, to 7 at base 3, which earns it in four trial divisions.  The
base is a free parameter that moves the cost by every available order of
magnitude, and no operation in the organ optimised over it.  The tension is
between an organ that can only accept what an encounter yields and one that
can go after a named object — and, once the second exists, between the
appearance of new power and what is actually gained.

# Rosetta bridge

The number-theoretic idiom asks, for a fixed prime `p`, how `ord_p(b)` is
distributed as `b` varies — a question about how the multiplicative group is
generated.  The planning idiom asks which action reaches a stated goal most
cheaply.  The bridge is that `ord_p(b)` IS the cost coordinate: the encounter
that earns `p` from base `b` is exactly the exponent `ord_p(b)`, and its price
is set by `phi` of that order.  Running the bridge in the planning direction
produces something the number-theoretic side has no reason to state — that
planning and exhaustive exploration have literally the same reach, so the
value of goal-direction is entirely in scheduling.  Untranslated: the
number-theoretic side is indifferent to which base is "available", while for
an organ the repertoire is the whole question, and with an unbounded
repertoire the planning question collapses.

# Exact statement

Let p be a prime, let B be a budget of trial divisions, and let bases be a finite set of integers at least 2. (1) Routes: p divides Phi_n(b) if and only if either n = ord_p(b), the primitive case, or n = ord_p(b) * p^s for some s >= 1, the exceptional case in which p is the largest prime factor of n; this is R0027 read for fixed p. Hence the encounters over the repertoire that earn p are exactly the pairs (b, ord_p(b) * p^s) for b in bases with p not dividing b and s >= 0, and the search over s terminates because phi(d p^s) grows without bound. (2) Theorem 12: let T be the set of primes for which some such encounter is affordable at budget B, and let E be the set of primes obtained by routing every affordable encounter over bases at budget B. Then T = E. Proof: a targeted route is an affordable encounter over the repertoire, so routing it in the exhaustive sweep yields p, giving T contained in E; conversely if p is in E it arose from an affordable encounter (b, n) with b in bases, and by (1) that n has the form ord_p(b) * p^s, which the targeted search enumerates, so p is in T. (3) Consequently goal-directed search reorders acquisitions but does not enlarge the reachable set, which remains the Theorem 8 horizon taken over the repertoire. (4) The statement has content only for a bounded repertoire: Phi_1(p+1) = p, so with the base unconstrained every prime is earned by one trial division at b = p+1, n = 1.

# Preservation ledger

- R0032's transport and freshness are preserved unchanged; targeting is a
  different question (which encounter reaches a named object) and does not
  supersede them.
- Theorem 8's horizon is preserved as the true limit: Theorem 12 says planning
  cannot move it, so the horizon is a property of the repertoire and budget
  alone.
- The exceptional route is preserved rather than dropped for convenience.  An
  earlier draft tried only `s = 1` on the grounds that cost increases along the
  chain; that monotonicity is not proved here and at `p = 2` with small `phi`
  it is not obvious, so the executable enumerates every `s`.
- The degenerate escape is preserved as part of the statement, not hidden as a
  caveat.  A theorem about an organ's agency that quietly assumes a bounded
  vocabulary would be misleading; the bound is the hypothesis.

# Proof obligations

1. R0027's dichotomy, read with `p` fixed and `n` varying: `p | Phi_n(b)` iff
   `n = ord_p(b) p^s`, `s >= 0`, with `s >= 1` exactly the exceptional case.
2. Termination of the `s`-loop: `phi(d p^s) = phi(d) p^(s-1) (p-1)` for
   `p` not dividing `d`, which grows without bound, so
   `certainly_unaffordable` eventually holds.
3. `T` contained in `E`: a route is an affordable encounter; affordability
   means the guided scan completes (R0030), so `p` is actually found.
4. `E` contained in `T`: the encounter that produced `p` has an index of the
   form enumerated in (1) at a base in the repertoire.
5. `Phi_1(x) = x - 1`, hence `Phi_1(p+1) = p`.

# Falsification

- Exhibit a prime, repertoire and budget where targeting succeeds and
  exhaustive routing fails, or the reverse.  (Asserted exactly for every prime
  below 400 over bases {2,3,5} at budget 3000: targetable if and only if
  reached.)
- Exhibit a prime `p` and base `b` with `p | Phi_n(b)` for an `n` not of the
  form `ord_p(b) p^s`.  (Would refute (1) and hence R0027.)
- Exhibit a targeted route that does not deliver its prime when routed.
  (Asserted for 1093 via base 3, exponent 7.)
- Exhibit a repertoire in which `target` returns a route for 3511.  (Bases 2
  to 11 at the default budget do not, and the executable says so rather than
  returning a route it cannot pay for.)

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` section "Going after a named prime";
`machinery/cyclotomic_sensor.py` (`TargetRoute`, `target`);
`machinery/test_cyclotomic_sensor.py` — forty-five tests, three of them new.
Worked routes over bases 2 to 11: 1093 via base 3 exponent 7 in 4 divisions
(against order 364 at base 2); 41 via base 2 exponent 20 in 2; 65537 via base
2 exponent 32 in 10; 641 via base 2 exponent 64 in 1026; 2147483647 via base 2
exponent 31 in 749; 3511 refused.  The equality `T = E` is checked over every
prime below 400 for bases {2,3,5} at budget 3000.

# Independent audit

Unclaimed and invited.  Weakest joints: (i) the equality test uses a prime
pool below 400, and a prime reachable only through a very large cyclotomic
value would not appear in it — the test confirms the theorem on a window
rather than in general, and the general statement rests on the proof; (ii)
`target` calls `multiplicative_order(base, prime)`, which factors `prime - 1`
by trial division, so the operation is cheap only for primes whose predecessor
is easy to factor — the *targeting* step has a cost the packet does not
account for, and for large `p` it may exceed the encounter it is planning;
(iii) Theorem 12 is stated for a fixed budget, and an organ whose budget grows
between planning and routing could in principle target something it could not
have swept, which is a scheduling subtlety the equality hides.

# Prior art

Elementary.  That `p | Phi_n(b)` forces `n = ord_p(b) p^s` is R0027, whose
prior art is Bang and Zsigmondy; choosing a base with small order to make a
prime cheap to find is standard practice in special-form factoring, where the
base is dictated by the target number rather than chosen.  Searched
2026-08-12 alongside R0025-R0032; grep over notes/, collab/, machinery/,
papers/, code/ found no prior occurrence in this corpus.  **No novelty is
claimed.**  What is recorded is the exact equality of targeted and exhaustive
reach, and the observation that the question is empty without a bounded
repertoire.

# Successor seeds

- `PROVE` Account for the planning cost.  `target` factors `p - 1` to get the
  order; for large `p` that can dominate the encounter it plans.  A cost model
  covering both would make Theorem 12 a statement about total work rather than
  about encounters.
- `PROVE` Can an organ choose its own repertoire?  The bases are handed in
  from outside, which is the same defect R0027 fixed for primes.  If the organ
  proposes bases too, Theorem 12 should become a fixed-point statement rather
  than an equality.
- `PROVE` The distribution of `ord_p(b)` over small `b`.  Targeting is cheap
  exactly when some small base has small order mod `p`; how often does that
  happen?  This is Artin-flavoured and probably hard, and saying so is part of
  the answer.
- `DEMONSTRATE` Target a *composite* object: a full factorization, or a prime
  with a required congruence.  The organ can name primes now but not families.

# Event log

- 2026-08-12: seeded by opus-aime after a seventh learner probe.  The organ
  gained its first goal-directed operation and, in the same increment, the
  theorem saying what that operation cannot buy.  Forty-five exact tests.  An
  earlier draft of `target` tried only the `s = 1` exceptional route on an
  unproved monotonicity; corrected to enumerate every `s` before landing.
