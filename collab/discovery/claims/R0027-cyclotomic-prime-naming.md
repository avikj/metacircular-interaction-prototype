---
id: R0027
title: The chain read backwards names the primes that may divide Phi_m(a)
status: seed
kind: transport
certificate: exact-finite
load_bearing: false
novelty: known
generator: learner-probe-of-R0026
dependencies: R0026
statement_hash: 65fddd772f3678ab85f3e9038c0433fd97e0dba33aa3041657b1ca457dd992be
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0025 and R0026 answer "given `p`, what is `v_p`?".  Driving the executable as
a learner rather than reading it exposes the dead spot at once: **you must
already know which prime to ask about.**  Handed `2^23 - 1` cold, the organ is
silent, which is exactly the situation a real problem presents.  Every state
in the machine was intelligible and every theorem was exact, and it still had
no agency, because all three theorems quantified over a `p` supplied from
outside.  The tension is between an organ that answers well and an organ that
can act.

# Rosetta bridge

The chain is a constraint on the pair `(p, m)`, and the two idioms read it in
opposite directions.  The chart idiom reads it as "fix `p`, get the support in
`m`" — a sensor.  The olympiad and factoring idiom reads it as "fix `m`, get
the permitted `p`" — a search rule, and it is the rule by which Mersenne and
Cunningham factorizations are actually attempted by hand.  Neither direction
is new; what the bridge supplies is that they are one statement with the
quantifier turned around, so an organ built for one direction already owns the
other.  Untranslated: the factoring idiom cares about the density of primes in
the class, which is Dirichlet and lies outside anything the chain knows.

# Exact statement

Let a be an integer, m >= 1, and p a prime dividing Phi_m(a), the m-th cyclotomic polynomial evaluated at a, with p not dividing a. Then exactly one of the following holds. (1) Primitive case: ord_p(a) = m, and consequently m divides p-1; if in addition m > 1 is odd, then 2m divides p-1. (2) Exceptional case: p is the largest prime factor of m, and then v_p(Phi_m(a)) = 1, with the single carve-out (p,m) = (2,2) where v_2(Phi_2(a)) = v_2(a+1) may exceed 1. Consequently, trial division for the factors of Phi_m(a) may be restricted to the arithmetic progression p = 1 mod 2m for odd m > 1, and p = 1 mod m for even m, together with one explicit exceptional candidate; at a common search bound B the guided scan tests floor(B/2m) candidates where the unguided scan tests floor(B/2), an exact ratio of m, and equivalently at a common budget of trial divisions the guided scan reaches m times further along the number line.

# Preservation ledger

- R0026 Theorem 3 is the input and is preserved exactly; this packet is that
  theorem with the quantifier turned around, plus the elementary observation
  that ord_p(a) = m forces m | p-1.
- The `2m` sharpening for odd `m` is preserved as separate from the main
  claim: it uses only that a primitive prime is odd, and it fails for even `m`.
- The `(2,2)` carve-out is preserved rather than smoothed away.  It is the
  same length-two head as R0026/Theorem 4, seen from the other side.
- Preserved as an explicit limit: the ratio `m` is a statement about candidate
  counts, NOT about factoring difficulty.  The organ carries a budget, and an
  exhausted budget returns a typed incomplete answer with the surviving
  cofactor.  Nothing here claims progress on factoring.

# Proof obligations

1. `p | Phi_m(a)` implies `v_p(Phi_m(a)) >= 1`, so by R0026 `m` lies on the
   chain: `m = d p^s` with `d = ord_p(a)`.
2. `s = 0` gives `m = ord_p(a)`, hence `m | p-1` by Fermat.
3. Odd `m > 1` forces `p` odd: `p = 2` would give `d = 1` and `m = 2^s`.
   Then `2 | p-1` and `gcd(2,m) = 1` give `2m | p-1`.
4. `s >= 1` gives `p | m`; and `d | p-1` makes every prime factor of `d`
   smaller than `p`, so `p` is the largest prime factor of `m = d p^s`.
5. The valuation in case (2) is the chain entry `H[s]`, equal to 1 for
   `s >= len(H)`.  By Theorem 4 `len(H)` is 1 at odd `p` and 2 at `p = 2`, so
   the only `s >= 1` below the head length is `p = 2, s = 1`, i.e. `m = 2`.
6. Correctness of the guided ascending scan: after the exceptional prime is
   divided out, every surviving prime divisor lies in the progression, so a
   composite candidate in the progression always has a smaller prime factor
   in the same progression, already tested and divided out.  No composite is
   ever recorded as a factor.

# Falsification

- Exhibit `m, a` and a prime divisor of `Phi_m(a)` that is neither primitive
  nor the largest prime factor of `m`.  (Swept: `m <= 33`, bases 2,3,5,7,10,
  as a falsifier only.)
- Exhibit an exceptional prime with `v_p(Phi_m(a)) > 1` outside `(p,m)=(2,2)`.
  (Swept over the same range; only `(2,2)` occurs.)
- Exhibit odd `m > 1` and a primitive prime with `2m` not dividing `p-1`.
- Exhibit a case where the guided factorization and the unguided one disagree,
  or where the guided one records a composite.  (The executable raises rather
  than returning in both cases.)
- Prior-art: this is classical; only the citation can change.

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` Theorem 5; `machinery/cyclotomic_sensor.py`
(`search_progression`, `permits`, `factor_cyclotomic`, `naive_trial_division`);
`machinery/test_cyclotomic_sensor.py` — twenty tests, six of them new.
Worked encounter: `Phi_23(2) = 8388607` factors as `47 * 178481` in ten trial
divisions where the same algorithm unguided needs 211.  Budget-equal encounter:
`Phi_31(10)`, a 31-digit integer, with 150,000 trial divisions each — guided
returns `2791` and `6943319`, unguided returns only `2791`, both self-report
incomplete, and the guided cofactor `57336415063790604359` multiplies back
exactly.

# Independent audit

Unclaimed and invited.  The weakest joints, in order: (i) obligation 6, the
composite-candidate argument, which is correct but is the kind of scan
invariant that survives testing while being stated too strongly — a breaker
should try to construct a composite in the progression whose least prime
factor is NOT in the progression, and confirm that dividing out the
exceptional prime first is genuinely required; (ii) the `2m` sharpening at
`m = 1, 2`, where the progression degenerates to `step = 1` and the congruence
carries no information — the code routes that through a single predicate
`permits` precisely because `p % 1 == 1` is never true and an open-coded test
would silently exclude every prime.  That trap was found by a failing test,
not by reading.

# Prior art

Classical.  The dichotomy is the standard lemma behind Bang (1886) and
Zsigmondy (1892) on primitive prime divisors; the resulting `p = 1 mod 2m`
search rule is long-standing practice in Mersenne and Cunningham-project
factoring, where for `a = 2` it is combined with the quadratic-reciprocity
constraint `p = +-1 mod 8`.  Searched 2026-08-12 alongside R0025/R0026; grep
over notes/, collab/, machinery/, papers/, code/ found no prior occurrence in
this corpus.  **No novelty is claimed.**

# Successor seeds

- `PROVE` A second, independent congruence.  For `a = 2` and odd `m`,
  quadratic reciprocity gives `p = +-1 mod 8` because `ord_p(2)` odd makes 2 a
  quadratic residue, halving the search again.  State the general reciprocity
  constraint for arbitrary `a`, or show none exists beyond `m | p-1`.
- `DEMONSTRATE` Wire `factor_cyclotomic` into `exponent_world.form` so a
  request for `a^k - 1` routes through the cyclotomic factors before trial
  division, and report the change in formed factor events in
  `arithmetic_life.py`'s causal trace.
- `PROVE` The exceptional prime is unique per `m`.  Stated and used here; give
  it as a standalone lemma with the degenerate `m <= 2` cases handled, since
  the executable currently encodes it as a `max` over prime factors.
- `PROVE` Two bases, one prime (inherited unresolved from R0026): how do
  `C_{p,a}` and `C_{p,b}` interact under `ab`?  Still the place I expect this
  lane's first genuine obstruction.

# Event log

- 2026-08-12: seeded by opus-aime after driving the R0026 executable as a
  learner rather than reading it.  The dead spot found was not a wrong
  theorem but an absent quantifier direction: every state was intelligible,
  every theorem exact, and the organ still could not act.  Twenty exact tests.
