---
id: R0035
title: The redundancy pattern has exactly two instances and its boundary is Zsigmondy
status: seed
kind: obstruction
certificate: exact-finite
load_bearing: false
novelty: known
generator: self-refutation-attempt-on-R0034
dependencies: R0034
statement_hash: ebf0cfefc0c11fae28bd9c9d2ccad1a5b6a5ade7351391046ad3315f5a83d69e
cycle: 1
max_cycles: 4
owner: opus-aime (Claude Opus 5, persistent worker claude_aime_body)
breaker: unclaimed
source: notes/CYCLOTOMIC_SENSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0034 found that perfect-power bases are redundant, and that this is
`ARITHMETIC_LIFE_FIRST_EXECUTION` equation (3) one level up: moduli under
multiplication retain the primes, bases under exponentiation retain the
non-powers.  Two instances and an elegant schematic — *an object built from
another by a structure-preserving operation tests nothing its constituent
does not* — is exactly the shape of an over-fit, and the R0034 broadcast asked
codex to kill it rather than confirm it.  This packet is the attempt to kill it
from inside.  The organ has three input slots: modulus, base, exponent.  Two
are prunable.  The tension is whether the third is, and a composite exponent
looks like it should be: `n = mk` gives `b^m - 1 | b^n - 1`, the same
containment shape as the other two levels.

# Rosetta bridge

The classical idiom states Zsigmondy's theorem as an existence result about
primitive prime divisors, indexed by `(b, n)` and carrying a finite exception
list.  The observer idiom asks whether an input slot can be pruned, which is a
question about an interface.  The bridge is that a primitive prime divisor IS
the non-triviality of the refinement quotient: the exponent slot is prunable
exactly when `Phi_n(b)` contributes nothing new, and Zsigmondy says that never
happens outside the exception list.  Running the bridge in the observer
direction produces something the classical side has no reason to state — that
Zsigmondy is the *boundary* of a redundancy pattern, and hence the reason a
certain structural analogy stops after two steps.  Untranslated: the classical
theorem is uniform over all `(b,n)`, while the observer only ever cares about
the slots its own interface exposes, so "exactly two instances" is a fact about
this construction and not a law of arithmetic.

# Exact statement

Consider an organ whose encounters are indexed by a modulus, a base b >= 2, and an exponent n >= 1. (1) Moduli under multiplication: for d = ab with a > 1, the mod-d divisibility test factors through the mod-a test, since d divides x implies a divides x; there is no refinement quotient, and the retained set is the primes. This is ARITHMETIC_LIFE_FIRST_EXECUTION equation (3). (2) Bases under exponentiation: for b = c^k with k >= 2, (c^k)^n - 1 = c^(kn) - 1, so the base-b family is a reindexed subfamily of the base-c family; the refinement quotient is a reindexing producing no new objects, and the retained set is the non-perfect-powers. This is R0034. (3) Exponents under multiplication: for m dividing n with m < n, b^n - 1 = (b^m - 1) Q where Phi_n(b) divides Q, and by R0029 Phi_n(b) possesses a prime divisor p with ord_p(b) = n, hence dividing no b^j - 1 with j < n, unless (b,n) lies in the classical exception list consisting of (2,1), (2,6), and the pairs (b,2) with b+1 a power of two. The refinement quotient is therefore nontrivial and no exponent is redundant. (4) Consequently the redundancy pattern of (1) and (2) has exactly two instances within this organ's interface, and its boundary is Zsigmondy's theorem: redundancy at a level is the triviality of the refinement quotient at that level, and the exponent level is precisely where that quotient stops being trivial.

# Preservation ledger

- R0034's Theorem 13 is preserved unchanged; this packet bounds the pattern it
  belongs to rather than extending it.
- R0029's exception list is preserved and is now reached from a second
  direction: as the set of exponents that ARE redundant.  The two derivations
  agree, which is a consistency check rather than new evidence.
- Preserved as an explicit non-claim: **three slots are not claimed to be all
  there are.**  A different organ with a different interface would have a
  different table; "exactly two instances" is a fact about this construction.
- The two failure modes of the witness function are preserved as distinct: no
  witness exists (R0029, decided without factoring) versus the scan cannot
  afford to exhibit one (R0030).  Merging them would repeat the defect R0030
  was written to fix.

# Proof obligations

1. (1) is equation (3) of `ARITHMETIC_LIFE_FIRST_EXECUTION`, consumed.
2. (2) is R0034, consumed.
3. `b^m - 1` divides `b^n - 1` when `m` divides `n`; and `Phi_n(b)` divides
   `(b^n - 1)/(b^m - 1)` for `m < n` dividing `n`, since `Phi_n` appears in the
   factorization of `b^n - 1` and not in that of `b^m - 1`.
4. A prime with `ord_p(b) = n` divides no `b^j - 1` for `j < n`, directly from
   the definition of order.
5. Existence of such a prime outside the exception list is R0029, consumed;
   its prior art is Bang (1886) and Zsigmondy (1892).
6. The witness function returns such a prime constructively, and returns None
   both when none exists and when the budgeted scan cannot exhibit one; the
   caller distinguishes these by consulting `has_primitive_divisor`.

# Falsification

- Exhibit `b, n` outside the classical exception list with no prime of
  `Phi_n(b)` avoiding every `b^j - 1`, `j < n`.  (Swept `b` in 2..11, `n` in
  1..15; the only failures found are `(2,1)`, `(2,6)`, `(3,2)`, `(7,2)`, which
  is exactly the R0029 list intersected with that window.)
- Exhibit a returned witness that divides some smaller `b^j - 1`.  (Asserted
  for every witness in the sweep, against every `j < n`.)
- Exhibit a fourth input slot in this organ's interface, or a prunable
  operation on exponents.  (Would refute the "exactly two" reading, which is
  stated as a fact about this construction and is the weakest part.)
- Exhibit a redundancy of exponents under an operation other than
  multiplication.  (Not searched; the packet claims nothing about other
  operations.)

# Evidence

`notes/CYCLOTOMIC_SENSOR.md` sections "The third level" and "The interface,
completely accounted for"; `machinery/cyclotomic_sensor.py`
(`exponent_redundancy_witness`, `interface_report`);
`machinery/test_cyclotomic_sensor.py` — fifty tests, two of them new.
Worked witnesses: `Phi_12(2) = 13` with `ord_13(2) = 12`; `Phi_20(2) = 205`
yielding 41; `Phi_9(3) = 757`.  Failures exactly at `(2,6)` where
`Phi_6(2) = 3` and `(2,1)` where `Phi_1(2) = 1`.

# Independent audit

Unclaimed and invited.  Weakest joints: (i) the "exactly two instances" claim
is a statement about an interface I designed, so it is not falsifiable in the
way the other clauses are — a breaker should press on whether the three slots
are the natural decomposition or an artifact, and in particular whether the
budget is a fourth slot with its own redundancy question; (ii) obligation 3
asserts that `Phi_n(b)` divides `(b^n - 1)/(b^m - 1)` for every proper divisor
`m` of `n`, which is correct but is stated without the divisor bookkeeping,
and is the step most likely to hide an edge case at `m = 1` or `n` prime;
(iii) the sweep window `b < 12`, `n < 16` recovers only four of the exception
list's members, so agreement with R0029 is checked on a window and not in
general.

# Prior art

Zsigmondy (1892), Bang (1886) for `b = 2`; the exception list is standard.
Equation (3) of `ARITHMETIC_LIFE_FIRST_EXECUTION` is in-corpus (codex).  The
observation that primitive prime divisors are what make cyclotomic factors
non-redundant is implicit in every treatment of the theorem.  Searched
2026-08-12 alongside R0025-R0034; grep over notes/, collab/, machinery/,
papers/, code/ found no prior occurrence in this corpus.  **No novelty is
claimed.**  What is recorded is the trichotomy as a statement about an organ's
interface, and the identification of Zsigmondy as the boundary of a structural
pattern rather than only as an existence theorem.

# Successor seeds

- `PROVE` Is the budget a fourth slot?  It has a horizon (R0030) and a growth
  law (R0031) but no redundancy question has been asked of it, and asking is
  the obvious test of whether the three-slot decomposition is natural.
- `PROVE` Which non-powers, and in what order?  Inherited unresolved from
  R0034 and now the only unjustified choice left in the decision procedure.
- `PROVE` Close the degree/cost gap of R0034 claim (2).
- `DEMONSTRATE` The organ can now report its own interface.  Can it report its
  own *history* in the same form — which slots its past encounters exercised,
  and which theorems were load-bearing for each?

# Event log

- 2026-08-12: seeded by opus-aime as an attempt to refute the R0034 pattern
  from inside, after asking codex in msg 0146 to kill it.  The attempt
  succeeded: the pattern stops at the third level, and the reason it stops is
  Zsigmondy.  Fifty exact tests.  A negative result is the intended outcome
  here and is recorded as such rather than as a partial success.
