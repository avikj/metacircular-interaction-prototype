---
id: R0028
title: Routing a^n-1 through its cyclotomic pieces has two independent gains
status: seed
kind: transport
certificate: exact-finite
load_bearing: false
novelty: known
generator: learner-probe-of-R0027
dependencies: R0027
statement_hash: a1e2c22506670b9522abac1d3ce423092644b0d3925a01765e4142c9aa98fdbd
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0027 gave the organ its own prime candidates, and driving the executable
again exposed the next dead spot immediately: a learner is never handed
`Phi_m(a)`, a learner is handed **a number**.  Asked to factor `2^35 - 1`, the
machine held two organs that were strangers.  `arithmetic_life` ground out
16,777 prime sensors up to 185,363 to find one factor, while the cyclotomic
organ in the same process already knew that every prime factor of that integer
lies in one of four sparse arithmetic progressions.  The tension is that an
earned theorem was not reaching the operation it was a theorem about.

# Rosetta bridge

`a^n - 1 = prod_{m | n} Phi_m(a)` is read in two idioms.  The Galois idiom
reads it as the decomposition of a cyclotomic extension into its primitive
layers — a statement about degrees, `deg Phi_m = phi(m)`.  The computational
idiom reads it as a factoring strategy — attack the pieces, not the number.
The bridge is that the *degree* statement is exactly the *cost* statement:
`phi(m) <= phi(n)` for `m | n` is why the deepest scan drops from `a^(n/2)` to
`a^(phi(n)/2)`.  Untranslated: the Galois side has no notion of a scan budget,
and the computational side has no use for the Galois group beyond its order.

# Exact statement

Let a >= 2 and n >= 1, and put N = a^n - 1 = prod over m dividing n of Phi_m(a), where Phi_m is the m-th cyclotomic polynomial. (1) Degree gain: for every m dividing n, phi(m) divides phi(n), hence phi(m) <= phi(n); and (a-1)^phi(m) <= Phi_m(a) <= (a+1)^phi(m), because Phi_m(a) is the product over the phi(m) primitive m-th roots of unity zeta of (a - zeta) and each factor has absolute value between a-1 and a+1. Therefore the largest square-root scan bound over all pieces is at most (a+1)^(phi(n)/2) and at least (a-1)^(phi(n)/2), whereas scanning N head-on requires a bound of about a^(n/2); the reduction factor is a^((n - phi(n))/2) up to a factor a. (2) Congruence gain: inside each piece the trial division may be restricted, by R0027, to the single residue class 1 mod 2m for odd m > 1 and 1 mod m for even m, plus the largest prime factor of m, dividing the candidate count by a further m. (3) The two gains are independent: (1) holds with no congruence information and (2) holds at m = n where (1) gives nothing. (4) Control: n - phi(n) = 1 exactly when n is prime, so gain (1) is a factor of at most a for prime exponents and is exponential in n - phi(n) for composite ones.

# Preservation ledger

- R0027 is the input for gain (2) and is preserved exactly.
- Gain (1) is preserved as *independent* of R0027, not a corollary of it.  A
  breaker who kills the congruence claim does not kill the degree claim.
- The prime-exponent control is preserved as part of the statement rather than
  as a caveat: a route that claimed uniform gain would be wrong, and the
  theorem says exactly where it gives nothing.
- Preserved as an explicit limit: this is a statement about candidate counts
  and scan depth, NOT about factoring difficulty.  Every reported
  factorization is budgeted, and exhaustion yields a typed cofactor.
- The `(a+1)^phi(m)` bound is preserved as lossy at small `a`: at `a = 2` it
  overestimates by `(3/2)^phi(m)`, so the *certified* gain is weaker than the
  observed one.  The executable reports the exact bound it actually used.

# Proof obligations

1. `Phi_m(a) = prod_zeta (a - zeta)` over the `phi(m)` primitive `m`-th roots
   of unity; each `|a - zeta|` lies in `[a-1, a+1]`.
2. `phi(m) | phi(n)` for `m | n`: multiplicativity of `phi` plus
   `phi(p^i) | phi(p^j)` for `i <= j`.
3. The blind bound is `isqrt(N) < a^(n/2)`.
4. Gain (2) is R0027 verbatim.
5. Independence: exhibit `n` prime (gain 1 vacuous, gain 2 present) and note
   that gain 1 is proved without reference to any congruence.
6. `n - phi(n) = 1` iff `n` is prime; `n - phi(n) = 0` iff `n = 1`.

# Falsification

- Exhibit `a, n` where the routed factorization differs from the direct one.
  (The executable raises rather than returning; checked for `a^n - 1` over
  ten (base, exponent) pairs against full trial division.)
- Exhibit `a, n` where the routed scan bound exceeds `isqrt((a+1)^phi(n))` or
  falls below `isqrt((a-1)^phi(n))`.  (Both sides asserted in the tests; an
  upper bound alone would not pin the exponent at `phi(n)`.)
- Exhibit a prime exponent where the routed bound beats the blind bound by
  more than a factor `a`.  (Would refute the control and mean gain (1) is
  mis-stated.)
- Exhibit a composite exponent where the observed ratio is outside
  `[a^((n-phi(n))/2)/a, a^((n-phi(n))/2)*a]`.

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` Theorem 6 and "The loop closes";
`machinery/cyclotomic_sensor.py` (`factor_power_minus_one`,
`CyclotomicOrgan.route`, `RoutedFactorization`);
`machinery/test_cyclotomic_sensor.py` — twenty-five tests, four of them new.
Ledger, exact integers: `2^23-1` blind bound 2896, routed 2896 (the control:
23 is prime), 10 trial divisions.  `2^35-1` 185,363 -> 2954 in 7.  `2^36-1`
262,143 -> 63 in 9.  `2^60-1` 1,073,741,823 -> 283 in 12, completely factored
into eleven primes.  `10^12-1` 999,999 -> 99 in 20.  Blind-organ comparison on
`2^25-1`: `arithmetic_life` generates 760 prime sensors up to 5791; the route
uses 14 trial divisions.

# Independent audit

Unclaimed and invited.  Weakest joints: (i) the claim of *independence*
between the two gains, which is a statement about proofs rather than numbers
and is the kind of thing that reads well and hides a shared hypothesis — a
breaker should check whether gain (1)'s use of `m | n` smuggles in anything
R0027 also needs; (ii) the `(a-1)^phi(m)` lower bound at `a = 2`, where it
degenerates to 1 and asserts nothing, so the two-sided sandwich in the tests
is vacuous on the left exactly in the most-tested base; (iii) the ledger rows
are single integers per encounter, not a distribution, and should not be read
as a claim about typical behaviour.

# Prior art

Classical and standard practice.  Factoring `a^n - 1` through its cyclotomic
factors, and restricting the search to `p = 1 mod 2m`, is precisely how the
Cunningham project tables are built; the degree observation `deg Phi_m =
phi(m)` is elementary Galois theory.  Searched 2026-08-12 alongside
R0025-R0027; grep over notes/, collab/, machinery/, papers/, code/ found no
prior occurrence in this corpus.  **No novelty is claimed.**  What is recorded
here is the exact separation of the two gains with the prime-exponent control,
and the closure of the loop back into `arithmetic_life`'s sensor economy.

# Successor seeds

- `PROVE` The second congruence (inherited from R0027, still open): for
  `a = 2` and odd `m`, reciprocity gives `p = +-1 mod 8`.  State the general
  constraint for arbitrary `a`, or show none exists beyond `m | p-1`.
- `PROVE` `a^n + 1 = prod_{m | 2n, m does not divide n} Phi_m(a)`.  The same
  two gains should apply; check whether the `p = 2` head length interferes,
  since `a^n + 1` is where `Phi_2` and its chain live.
- `PROVE` Two bases, one prime (inherited unresolved from R0026): how do
  `C_{p,a}` and `C_{p,b}` interact under `ab`?  Still the place I expect this
  lane's first genuine obstruction.
- `DEMONSTRATE` The sensor economy now has two rates of prime acquisition —
  grinding and routing.  State what the routed rate *is*: which primes become
  reachable, as a function of the encounters offered.  This is the first
  question in the lane that is about the machine's history rather than about
  an integer.

# Event log

- 2026-08-12: seeded by opus-aime after a second learner probe of the
  executable.  The dead spot was again not a wrong theorem but an unconnected
  one: `arithmetic_life` and `cyclotomic_sensor` were strangers inside one
  process.  Twenty-five exact tests.  A first attempt at the cost claim
  asserted a chosen threshold (1000x) where the derived value is
  `a^((n-phi(n))/2) = 256`; the assertion was replaced by the derived
  quantity before landing.
