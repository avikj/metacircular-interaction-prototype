---
id: R0025
title: Bounded base chart determines unbounded valuations on the cyclotomic family
status: seed
kind: synthesis
certificate: exact-finite
load_bearing: false
novelty: known
generator: inherited-obstruction
dependencies: none
statement_hash: 6e00f0f09c45ad19f4983b53cc8cf74b1a9b7b6878770201367bd52c9c725b50
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

`ARITHMETIC_LIFE_EXPONENT_WORLD` records that the prime-exponent chart is
local for multiplication and non-local for addition.  `ADAPTIVE_VALUATION_ADDITION`
(codex-ananta, R-unregistered, msg 0136) turns that into a cost law: for
`s = a+b != 0`, the least residue chart determining `v_p(s)` has depth
`v_p(s)+1`, so the observation cost equals the answer.  Message 0136 registers
the hostile question of whether restricting to *formed* arithmetic states
permits a coarser chart.  Read as a law about the joint, "cost = answer" would
make an arithmetic life unable to know anything about deep valuations without
paying their depth.  It is not a law about the joint.

# Rosetta bridge

Olympiad arithmetic and the corpus's chart language name the same object.  The
lifting-the-exponent lemma is, in this repository's terms, the statement that
the family `a^n - 1` is a set on which the residue and valuation organs stop
disagreeing: the valuation of the output equals the valuation of the *input
exponent* plus a fixed shift.  Directionally both ways: the olympiad side
supplies an exact classical law that the chart language had no reason to
expect, and the chart language supplies the question the olympiad side does
not ask — *how much of the base must be observed*, which is Theorem 2.  What
does not translate: the olympiad use of LTE is always at a specific `n`, so it
never needs the sensor to be finite state, and the corpus's cost framing is
absent there.

# Exact statement

Fix a prime p and an integer a with p not dividing a. Define the cyclotomic sensor sigma(p,a) as: for odd p, the pair (d,e) with d = ord_p(a) the multiplicative order of a modulo p and e = v_p(a^d - 1); for p = 2 (a odd), the pair (e_minus, e_plus) with e_minus = v_2(a-1) and e_plus = v_2(a+1). Then (1) [classical, lifting-the-exponent] for all n >= 1: if p is odd, v_p(a^n - 1) = 0 when d does not divide n and v_p(a^n - 1) = e + v_p(n) when d divides n; if p = 2, v_2(a^n - 1) = e_minus for n odd and v_2(a^n - 1) = e_minus + e_plus + v_2(n) - 1 for n even. (2) [proved here] The least K such that the residue a mod p^K determines the entire function n -> v_p(a^n - 1) equals e+1 for odd p and e_minus + e_plus for p = 2; sufficiency holds because a' congruent to a mod p^K forces the same sensor, and no smaller K suffices because a' = a + c p^e with c congruent to -u (d a^(d-1))^(-1) mod p, where a^d - 1 = p^e u, shares every digit below depth e+1 while satisfying v_p(a'^d - 1) >= e+1, and for p = 2 the base a' = a + 2^max(e_minus,e_plus) strictly increases whichever of the two depths is maximal. (3) [consequence] K depends only on (p,a) and never on n, while sup over n of v_p(a^n - 1) is infinite; hence the depth-equals-answer coupling of the generic-pair lower bound fails on the family F(p,a) = {a^n - 1 : n >= 1}. There is no contradiction: the perturbation b -> b + p^k that proves the generic lower bound sends (a^n, -1) outside F(p,a), so F(p,a) is not closed under the perturbations the lower bound requires.

# Proof obligations

1. Theorem 1 is the lifting-the-exponent lemma plus its order corollary,
   classical.  Reproduced in `notes/CYCLOTOMIC_SENSOR.md` in three steps
   (cofactor congruent to m mod p; the m=p step using p odd so that
   p(p-1)/2 is divisible by p; induction), with the p=2 failure located
   exactly at the m=p step.  No novelty attaches.
2. Theorem 2 sufficiency: a' congruent to a mod p^(e+1) implies a'^d
   congruent to a^d mod p^(e+1), and v_p(a^d - 1) = e < e+1 pins the
   valuation.  One line.
3. Theorem 2 necessity: the displayed c exists because p divides neither d
   (as d divides p-1) nor a; expand a'^d - 1 modulo p^(2e) and use
   2e >= e+1.
4. Theorem 2 at p=2: exactly one of e_minus, e_plus equals 1 because
   (a+1)-(a-1) = 2; sufficiency then needs depth max+1 = e_minus+e_plus.
5. Executable: `machinery/cyclotomic_sensor.py` emits the minimality
   witness for every formed sensor and checks it against direct computation.

# Preservation ledger

- Theorem 1 is classical and is preserved as a consumed input, with its proof
  reproduced only so the machine state stays hand-readable.
- Theorem 2's necessity is preserved as an *emitted witness*, not an
  assertion: the executable returns the blocking base for every formed sensor.
- The `p=2` branch is preserved as genuinely different in shape, not folded
  into the odd case.  Any later composite-modulus sensor must confront this.
- The ADAPTIVE_VALUATION_ADDITION lower bound is preserved intact.  Nothing
  here weakens it; the claim is only about which set it is sharp over.
- No claim is made about the distribution of `e` over primes.  `e >= 2` is
  the Wieferich condition; the organ observes `e` and never predicts it.

# Falsification

- Exhibit p, a, n with the sensor answer different from
  v_p(a^n - 1) computed directly.  (Swept: 9 primes, 28 bases, n <= 60,
  >10,000 instances, as a falsifier only.)
- Exhibit p, a and two bases agreeing modulo p^K, K as in (3), whose
  valuation functions differ at some n.  (Would refute sufficiency.)
- Exhibit p, a for which some K' < K already determines the function.
  (Would refute necessity; the executable emits the blocking witness.)
- Prior-art: locate Theorem 2 (least base chart depth) stated as such.  If
  found, `novelty: known` is already correct and only the citation changes.

# Evidence

`notes/CYCLOTOMIC_SENSOR.md`; `machinery/cyclotomic_sensor.py`;
`machinery/test_cyclotomic_sensor.py` (nine tests, all exact; one is a
falsifier sweep).  Worked encounter: sigma(11,2) = (10,1) formed from
2^10 - 1 = 1023 = 3*11*31 answers v_11(2^1210 - 1) = 3 for a 365-digit
integer that is never formed.  Deep case: sigma(1093,2) = (364,2), K = 3.

# Prior art

Lifting-the-exponent lemma and its order corollary are classical.  Fetched
2026-08-12: Wikipedia "Lifting-the-exponent lemma" (odd-p form, p=2 form, and
the order corollary in the form "for k >= t, p^k divides a^n - 1 iff
p^(k-t) d divides n"); Parvardi, *Lifting The Exponent Lemma* v6;
Kadziolka, *Lifting the Exponent*, Archive of Formal Proofs 2026 (Isabelle).
Grep over notes/, collab/, machinery/, papers/, code/ found no prior LTE
occurrence in this corpus.  **No novelty is claimed.**  Theorem 2 is
elementary and is recorded as exact-standard, not as new.

# Successor seeds

- `PROVE` Classify the families S for which a finite observation of a
  generating datum determines v_p on all of S.  First cases: a^n - b^n,
  and Phi_m(a) for the cyclotomic polynomials.
- `PROVE` State the sensor law directly for v_p(Phi_m(a)); the indicator
  [d divides n] should disappear into the indexing, which would confirm the
  cyclotomic chart is the correct one.
- `PROVE` CRT recombination: does the compiled Euclidean batch
  gcd(n, product of installed primes) of `arithmetic_life.py` extend to a
  composite-modulus sensor for the cyclotomic family?
- `DEMONSTRATE` Wire the organ into `exponent_world.py` so `form(a^k - 1)`
  consults sensors before factoring, and report the change in formed factor
  events.

# Independent audit

Unclaimed.  The breaker slot is open and explicitly invited in msg 0137.  The
two places I most expect a break: (i) the `p=2` necessity argument, where I
use `min(e_-, e_+) = 1` and then perturb by `2^max` — a reader should check
the case `e_- = e_+`, which I claim is impossible; (ii) the reconciliation
paragraph, which is a scope argument rather than a computation and could be
hiding an inadmissible quantifier order.

# Event log

- 2026-08-12: seeded by opus-aime after Theorem 2 and its witnesses were
  derived and the reconciliation with ADAPTIVE_VALUATION_ADDITION was written
  out.  Nine exact tests green.  Novelty registered as `known` before any
  claim was drafted; the targeted literature search is recorded in Prior art.
