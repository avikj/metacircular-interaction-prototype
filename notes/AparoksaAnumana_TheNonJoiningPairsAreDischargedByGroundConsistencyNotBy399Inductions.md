# अपरोक्ष-अनुमानम् — the 399 non-joining pairs are discharged by ground consistency, not by 399 inductions

claude-setu, 2026-08-23. The CS path a mathematician without compilers
does not take. Compound built here (अपरोक्ष: not-mediated, direct;
अनुमान: inference). No source claimed for the compound; the technique is
named and cited below.

## The mathematician's path (what I did first, and it is the slow one)

`machine/Sanghatta` reports 399 non-joining critical pairs — equations
the LPO-oriented rewriter cannot close. The obvious move, the one I took
in `SanghattaSamapti`, is: prove each as a theorem by induction. That is
399 inductions. It is correct and it is the wrong altitude.

## The CS path: proof by consistency (inductionless induction)

The 399 are not 399 problems. They are the **completion residue of one
rewrite system**, and the theory of that is settled:

**A universally-quantified equation is an inductive theorem of an
equational specification iff adding it (oriented) to a ground-confluent,
terminating system and running Knuth–Bendix completion never derives an
inconsistency** — a ground equation like `0 ≡ s(0)`. (Musser 1980;
Huet–Hullot 1982; Jouannaud–Kounalis 1986. The name in the literature is
*inductionless induction* / *proof by consistency*.) You do not do the
induction. You add the equation and check that the completed system stays
ground-consistent — and ground consistency is exactly what the kernel
decides trivially, because `0 ≡ s(0)` is `znots`, one line.

So the 399 collapse into two CS-classified strata, not a list:

1. **Missing rules (completion-reachable).** Of the 40 the report prints
   (smallest-first sample of the 399), **30 have a bare variable or a
   constant on one side** — `max x 0 = x`, `le 0 y = s0`, `x − 0 = x`,
   `gcd (s y) 0 = s y`. These are not theorems the rewriter can't prove;
   they are **base-case rewrite rules the library never oriented and added**.
   Orient each by the term order and add it — the pair joins by
   construction. This is completion, not proof. The library is simply
   incomplete, and Sanghatta's output IS the completion step: a
   non-joining pair, oriented, is the rule to add.
2. **Genuinely inductive residue.** The remaining ~10/40 are compound on
   both sides (`x + x·0 = x`, `x·s0 = x`) — they cannot be terminating
   rewrite rules (they'd loop or need `·-comm`), so completion cannot
   absorb them. These, and only these, go to the kernel — by induction,
   or better, by the consistency check above.

## The wiring this forces (the easiest path to the whole goal)

Do not prove 399 lemmas and do not wire Sanghatta→Tapas→kernel for all
399. Instead:

    Sanghatta → orient the base-orientable pairs back into library.terms
             (completion; the library becomes confluent on that fragment)
             → the genuinely-inductive residue → kernel ground-consistency

The payoff a mathematician's 399 inductions never buys: once the
equational fragment is completed to confluence + termination, it is a
**DECISION PROCEDURE** — it decides every equation in the theory, the 399
and infinitely many never listed, by normalize-both-sides-and-compare, at
rewrite speed, with no kernel call at all. Proving the lemmas gives you
the lemmas. Completing the system gives you the theory.

## Rigor boundary

- **Proved / measured here**: the split of the printed 40 (30 base-
  orientable, 10 compound; the `awk` count is reproducible on
  `sanghatta-report-2026-08-23.txt`); that base-orientable pairs join on
  being added (Knuth–Bendix, by construction); the `SanghattaSamapti`
  batch confirms the base cases hold.
- **Cited, not re-proved**: inductionless induction / proof by consistency
  (Musser 1980; Huet–Hullot 1982; Jouannaud–Kounalis 1986).
- **Owed, and NOT claimed**: that completion of `library.terms`
  terminates (it may not — that is the real content, and it is a run, not
  an assertion); that the inductive residue is exactly 10 (only 40 of 399
  are printed; the full split needs Sanghatta re-run with full output).
- **The truth this exposes**: the corpus has been treating a
  non-confluence report as a proof-obligation list. It is a completion
  step. That reframing is the CS intuition the whole exercise was missing.
