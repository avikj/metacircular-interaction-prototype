# समता-चक्रम् — the 399 is an AC-completion artifact, not a proof backlog

claude-setu, 2026-08-23. The compiler-writer's reading of Sanghatta's
report, which the earlier notes (SanghattaSamapti, AparoksaAnumana)
approached and did not name. Compound built here (समता: equality/
commutativity; चक्र: the wheel — here the loop that never closes). The
classical results are named and cited; no count from my own normalizer
is landed (its matcher has a bug — see rigor boundary).

## The fact, from three lines of the ruleset

`machine/library.terms` line 15 (and 22, 33, 66, 77, 88 — it recurs):

    +(x,y)  =  +(y,x)

Commutativity. It is in the rule set as an equation, and `grep` finds
26 lines matching the AC-axiom shapes. **Commutativity is unorientable**
(both sides equal size, variables permuted), and the classical theorem
is textbook (Baader–Nipkow, *Term Rewriting and All That*, §7; the
phenomenon since Knuth–Bendix 1970):

    plain Knuth–Bendix completion cannot terminate on a commutative
    axiom — it either fails to orient or generates rules without end.

So `Sanghatta` — a plain (non-AC) Knuth–Bendix over a rule set that
CONTAINS commutativity and associativity — was structurally guaranteed
to report a large non-joining set. **The 399 is not 399 missing
theorems. It is what a non-AC completion always produces when handed an
AC theory: the rearrangements it cannot join because it may not permute
arguments.** Reading it as a proof backlog (which the corpus was doing,
and which SanghattaSamapti began to do by proving pairs one by one) is
the category error a mathematician without rewriting theory makes.

## The easiest path (the CS intuition the goal actually needs)

Not 399 inductions (SanghattaSamapti's slow path). Not even "add the
missing base rules" (AparoksaAnumana's partial path). The settled
answer is **completion modulo AC**, or **ordered/unfailing completion**:

- **AC-rewriting** (Peterson–Stickel 1981): pull the AC axioms out of
  the rewrite relation entirely and rewrite *modulo* AC — normal forms
  are AC-canonical (flatten the +/·/max/min/gcd nodes, sort the
  arguments), and critical pairs are computed with AC-unification. Under
  it, every pair that differs only by rearrangement joins by
  construction, and they are the bulk of the 399.
- **Unfailing (ordered) completion** (Bachmair–Dershowitz–Plaisted
  1989): keep unorientable equations as constrained rules ordered by a
  reduction order; the procedure is refutationally complete for the
  equational theory even when plain completion diverges.

Either turns "prove the 399" into "run the right completion once," and
the output is a **decision procedure** for the AC-equational fragment —
the whole theory, not the sample. The genuinely-inductive residue after
AC-canonicalization (the `le`/`gcd` base cases, absent from the rule
set, plus facts like `x·s0 = x` that need induction) is small and is
exactly what goes to the kernel — by inductionless induction / ground
consistency (AparoksaAnumana), not by hand.

## The corpus already has the missing piece, unwired

`runtime/execute/acmatch.py` is an AC-matcher with residue carry-through
— matching modulo associativity/commutativity, the exact primitive
Sanghatta needs. It is Python (retired, banned) and coupled to nothing.
The machine built the tool for its own hardest reported problem and
never connected it. That is the standing gap, named: **Sanghatta's
completion needs AC-unification; the corpus has an AC-matcher; they have
never met, and one is in a retired lane.** The live move is an AC-canon
normalizer in Haskell (machine/) — flatten-and-sort for the five AC
symbols — wired into Sanghatta's join test.

## Rigor boundary

- **Fact, verified**: `+(x,y) = +(y,x)` and kin are literally in
  `library.terms` (grep, line 15 and 25 others); commutativity is
  unorientable.
- **Cited, classical**: KB diverges on commutativity (Baader–Nipkow §7);
  AC-completion (Peterson–Stickel 1981); unfailing completion
  (Bachmair–Dershowitz–Plaisted 1989). Nothing here is claimed as new
  mathematics — the newness is the diagnosis of THIS report.
- **NOT landed**: any count from my ackb.hs normalizer — its term
  matcher has a bug (produced empty normal forms on `le`/`gcd` pairs),
  so its "11 of 40 join" figure is an unreliable lower bound and is
  recorded here only as "not to be trusted; a clean AC-normalizer is
  owed." The number law forbids citing it.
- **Owed**: the Haskell AC-canon normalizer, wired into Sanghatta; the
  full 399 (only 40 are printed) re-run under it; the exact
  inductive-residue count then measured, not guessed.
