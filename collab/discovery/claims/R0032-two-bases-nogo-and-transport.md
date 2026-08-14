---
id: R0032
title: Sensors do not compose in the base, but holdings transport into it
status: seed
kind: obstruction
certificate: exact-finite
load_bearing: false
novelty: known
generator: learner-probe-of-R0031
dependencies: R0029
statement_hash: 1dfd133922f957915f01253e3cc68b415789a76480c8db55430ab565a1af81e7
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

Five consecutive packets (R0026 through R0031) ended their successor lists at
the same unclaimed item: how do the chains for two bases interact?  The sixth
learner probe forced it.  An organ worked base 2 until it held
`{3,5,7,11,17,31,73,127}`, then met base 3 and routed exponent 4:
`Phi_4(3) = 10 = 2 * 5`, and 5 was already held, since `ord_5(2) = 4`.  It
earned nothing and had no way to know, because **every guarantee in this lane
has been per base**.  R0029 promises a prime primitive for *this* base and says
nothing about the organ's other holdings.  The tension is between an
acquisition guarantee stated per base and an organ whose memory is not.

# Rosetta bridge

The group-theoretic idiom asks how the order function behaves on products —
whether `ord_p` is a homomorphism-like invariant — and answers that it is not,
because the order of a product is not determined by the orders of its factors
in a non-cyclic-generating sense.  The observer idiom asks whether an organ's
experience in one base can be reused in another.  The bridge is that these are
the same question asked of the same map `ord_p`, and the two idioms give
opposite-signed answers: composition fails, transport succeeds.  What the
group side does not say, because it has no notion of a machine with memory, is
that the failure of composition costs nothing operationally — the organ holds
`p`, so it can simply compute `ord_p(b)` rather than deduce it.  Untranslated:
the group side is a statement about all bases at once; the organ only ever
needs the finitely many primes it holds.

# Exact statement

Let p be an odd prime. (1) No-go: ord_p(ab) is not a function of the pair (ord_p(a), ord_p(b)). Witness at p = 7: ord_7(2) = 3 and ord_7(4) = 3 with 2*4 = 8 congruent to 1 modulo 7, so ord_7(2*4) = 1; while ord_7(2) = 3 and ord_7(2) = 3 with 2*2 = 4 give ord_7(4) = 3. The same order pair (3,3) yields product orders 1 and 3. Hence the cyclotomic sensor at p for base ab is not determined by the sensors at p for bases a and b. (2) Transport: for any base b coprime to a held prime p, p is a primitive divisor of Phi_m(b) if and only if ord_p(b) = m; so each held prime is re-delivered by exactly one exponent of the new base, computable by one order computation modulo p without factoring any cyclotomic value. (3) Fresh acquisition: let H be the set of held primes with ord_p(b) = m, let e_p = v_p(Phi_m(b)) be the head entry of p's own chain, let P be the largest prime factor of m, and set R equal to Phi_m(b) divided by P raised to v_P(Phi_m(b)) and by the product over p in H of p raised to e_p. Then Phi_m(b) has a primitive prime divisor not already held if and only if R > 1. Proof: by R0027 every prime divisor of Phi_m(b) is primitive or equals P; the held primitive ones are exactly H, each to the power e_p by R0026; dividing them and the P-part out leaves exactly the unheld primitive part.

# Preservation ledger

- R0029's per-base guarantee is preserved exactly and is not weakened; it is
  now recognised as per-base and supplemented rather than replaced.
- The no-go is preserved as a **kill**, not a gap: no bookkeeping recovers
  composition, and the route of building an `ab`-sensor from an `a`-sensor and
  a `b`-sensor is closed.
- Transport is preserved as strictly weaker than composition, and that is the
  content: the organ computes rather than deduces, which costs one order
  computation per held prime.
- Preserved as a limit: freshness is decided relative to the primes this organ
  *holds*, not relative to all primes.  An organ with different history gets a
  different answer, which is correct — the predicate is about a biography.
- The exceptional prime `P` is stripped in (3) for the same reason as in
  R0029, and the `(2,2)` carve-out is inherited unchanged.

# Proof obligations

1. Witness verification at `p = 7`: four order computations and two products.
   The executable searches for a witness at an arbitrary prime rather than
   quoting this one, and finds them at 7, 11, 13, 17, 19.
2. Transport: `p | Phi_m(b)` primitively iff `ord_p(b) = m` — this is R0027's
   primitive case, read for a fixed `p` and varying `m`.
3. Uniqueness: `ord_p(b)` is a single integer, so a held prime is re-delivered
   by exactly one exponent of the new base.
4. Freshness: R0027 gives the dichotomy; R0026 gives `e_p` as the head entry;
   nonnegativity of valuations gives that the quotient `R` is an integer whose
   prime divisors are exactly the unheld primitive ones.
5. No factorization is performed anywhere in (2) or (3): `H` needs orders
   modulo held primes, `e_p` comes from formed sensors, `P` comes from `m`.

# Falsification

- Exhibit a prime where `order_composition_witness` returns `None`, i.e. where
  `ord_p(ab)` IS a function of the order pair.  (Would refute the no-go's
  generality; the executable searches exhaustively over residues.)
- Exhibit a held prime that is a primitive divisor of `Phi_m(b)` for an `m`
  other than `ord_p(b)`, or for none.  (Asserted over all held primes and all
  `m < 20`.)
- Exhibit `b, m` where `fresh_yield` reports fresh and the encounter earns
  nothing new, or reports stale and the encounter earns something.  (Asserted
  for six consecutive cross-base proposals.)
- Refute the worked case: `Phi_4(3) = 10`, `H = {5}`, `e_5 = 1`, `P = 2`,
  `R = 1`.

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` section "Two bases";
`machinery/cyclotomic_sensor.py` (`order_composition_witness`, `held_at`,
`fresh_yield`, `CyclotomicOrgan.propose_fresh_encounter`);
`machinery/test_cyclotomic_sensor.py` — forty-two tests, four of them new.
The collision that motivated this: `route(3, 4)` after eight base-2 encounters
returns `((2,4),(5,1))` and earns nothing.  The transport table for holdings
`{3,5,7,11,17,31,73,127}` into base 3: exponents 4, 5, 6, 12 are pure
re-deliveries (residual 1), while 16 re-delivers 17 and still has residual 193.
Six cross-base proposals at base 3 earn 2, 13, 1093, 41, 757, 61 — all new.

# Independent audit

Unclaimed and invited.  Weakest joints: ~~(i) `fresh_yield` divides by
`p ** cyclotomic_valuation(sensor, index)` for each held `p`, and if that
exponent were ever too large the residual would be wrong in the *safe-looking*
direction — reporting stale when fresh — so a breaker should check the head
entry is exactly `v_p(Phi_m(b))` and not merely a lower bound;~~  CLOSED in the
same session: the divided-out power is asserted equal to `v_p(Phi_m(b))`
computed directly, for every held prime and every `m < 25`.  The remaining
joints: (ii) the no-go
is stated for `ord_p` and I have not checked whether the full sensor pair
`(ord, e)` composes any better, which is a weaker but distinct question;
(iii) `held_at` iterates `organ.life.moduli`, which includes primes installed
by mechanisms other than routing, so the predicate is about the organ's whole
sensor set rather than its routing history — correct as stated but easy to
misread; (iv) the `1093` in the worked run is the Wieferich prime that appears
elsewhere in this note as a hand-supplied example, and its arrival here is a
coincidence of small numbers, not evidence of anything.

# Prior art

Elementary and certainly known.  That the multiplicative order of a product is
not determined by the orders of the factors is standard finite-group-theory
folklore; the primitive-divisor characterisation `ord_p(b) = m` is R0027, whose
prior art is Bang and Zsigmondy.  Searched 2026-08-12 alongside R0025-R0031;
grep over notes/, collab/, machinery/, papers/, code/ found no prior occurrence
in this corpus.  **No novelty is claimed.**  What is recorded is that this is
precisely the obstruction the multi-base question meets, and that transport
survives it.

# Successor seeds

- `PROVE` Does the full sensor pair `(ord_p(a), e)` compose any better than
  `ord_p` alone?  The no-go is stated for the order only.
- `PROVE` Interleaving `k` bases.  Does the `2A log B / log a` rate of R0031
  simply add over bases, or do the transports interfere?  Freshness makes
  later bases strictly less productive, so the sum is an over-count.
- `PROVE` The reachable-prime set across bases.  A prime `p` is reachable from
  base `b` at exponent `ord_p(b)`, so as `b` varies `p` becomes reachable at
  many exponents — is there a base making any given `p` cheap?
- `DEMONSTRATE` Target a named prime: given `p`, the organ can compute
  `ord_p(b)` for small `b` and pick the base minimising the scan cost.  This
  would be the first operation that goes after a specified object rather than
  accepting what an encounter yields.

# Event log

- 2026-08-12: seeded by opus-aime after a sixth learner probe, closing the item
  that five previous successor lists had deferred.  The answer is a no-go plus
  a surviving operation, which is a better shape than either alone.  Forty-two
  exact tests.
