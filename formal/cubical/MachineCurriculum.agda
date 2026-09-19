{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MachineCurriculum â” the lemmas the engine asked for, answered.
--
-- These are not chosen by a person.  `machine/Obstruction.hs` reads the
-- kernel's REFUSALS out of machine/machine.log, recovers the residual (the
-- pair of terms at which Agda's computation stalled), triages out the
-- refutable and the degenerate, and ranks what survives by how many
-- DISTINCT parent goals each one would unblock:
--
--     distinct stalled goals   130
--     distinct lemmas demanded  78
--     top 8 unblock             54 of the 130
--
-- The top of that ranking, verbatim, with the engine's own counts:
--
--     unblocks 14   0 = yÂ0
--     unblocks  8   xÂ0 = 0
--     unblocks  5   x = x+0
--     unblocks  3   0 = 0âˆy
--     unblocks  2   x = x + 0Âx
--
-- â”â” AS-OF, added 2026-08-18.  READ THIS BEFORE BELIEVING ANY NUMBER ABOVE
-- â”  OR BELOW.  Every figure in this header â” 130 / 78 / 54, the five
-- â”  `unblocks` counts, and the "179 proofs â¦ 6 back" at the end â” is an
-- â”  aggregate that `machine/Obstruction.hs` computed from
-- â”  `machine/machine.log` on a run whose date and log size were never
-- â”  recorded.  They were quoted in the present tense, which is what makes
-- â”  them rot; `notes/INDIAN_LANE_CITATION_AUDIT.md` F8(d) is the finding.
-- â”
-- â”  `machine/machine.log` at the time of this edit: `wc -l` = 10700.  It
-- â”  is gitignored (`.gitignore`:16) â” NOT present in a fresh clone, so
-- â”  none of these numbers is reproducible from one.  It is append-only
-- â”  across runs (61 `DISPATCH` blocks at that size) and it is LIVE: it
-- â”  grew from 10475 to 10700 lines while this repair was being made.
-- â”
-- â”  The counts are deliberately NOT re-measured and substituted here,
-- â”  for two reasons.  (i) Substituting a fresh number without its log
-- â”  size just re-arms the same trap.  (ii) More seriously, "179 proofs
-- â”  and got 6 back" is no longer even well-defined against this file:
-- â”  it described ONE live round of ONE run, and `round=N` is now reused
-- â”  by all 61 runs, so the log's per-round tallies aggregate across runs
-- â”  and no round matches.  For the record, at 10700 lines the per-round
-- â”  totals are round=0 2142/846, 1 0/112, 2 8/235, 3 2/152, 4 78/453,
-- â”  5 55/363, 6 102/245, 7 14/244, 8 5/98 (accepts/rejects).  The audit
-- â”  found round=4 at 6/165; it is now 78/453.  That is not drift in a
-- â”  measurement, it is a different population.
-- â”
-- â”  WHAT SURVIVES, and it is the whole point of this module: the RANKING
-- â”  is illustrative, the LEMMAS are not.  Nothing proved below depends on
-- â”  any count â” `+zero`, `Âzero`, `+Âzero`, `oneMul` are theorems of â• and
-- â”  are checked by the kernel here.  The mechanism claim (Â§ "WHY THE
-- â”  ENGINE IS ASKING FOR THESE") is an argument about how Agda's `_Â_`
-- â”  recurses, not a measurement, and stands on its own.
-- â””â”
--
-- WHY THE ENGINE IS ASKING FOR THESE, which is the part worth understanding.
-- It already HAS `xÂ0 = 0` â” it is a defining equation of `*` in its own
-- vocabulary.  It is demanding a lemma it knows.  The reason is that Agda's
-- `_Â_` on â• recurses on its SECOND argument (`m Â zero = zero` holds only
-- after induction on m, while `zero Â n` is immediate), so `x Â 0` is not
-- definitionally `0` here, whereas the engine's rewriter discharges it at
-- once.  Every one of these lemmas is a place where the engine's notion of
-- equality is computational and Agda's is not.
--
-- So this module is not a list of things the machine did not know.  It is
-- the BRIDGE between the machine's rewriting and the kernel's definitional
-- equality, and closing it is what raises the acceptance rate â” a live round
-- submitted 179 proofs and got 6 back.  (That sentence is kept in the past
-- tense it belongs in: it reports one round of one run, and per the AS-OF
-- block above it is no longer recoverable from `machine/machine.log`, whose
-- round numbers are now shared by 61 runs.  It is an anecdote about why the
-- bridge was built, not a fact the reader can check.)
--
-- Everything below is proved by induction, constructively, no postulates.
------------------------------------------------------------------------

module MachineCurriculum where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_)

------------------------------------------------------------------------
-- the four that carry the ranking

-- unblocks 5.  Right unit of +.  `zero + x` is immediate; `x + zero` is not.
+zero : (x : â„•) â†’ x + zero â‰¡ x
+zero zero = refl
+zero (suc x) = cong suc (+zero x)

-- unblocks 8 (and 14, and 6, as `0 = yÂ0` and `0 = zÂ0` â” the engine states
-- the same law once per variable name it happened to use).  Right
-- annihilator.  This is the single most demanded lemma in the whole stream.
Â·zero : (x : â„•) â†’ x Â· zero â‰¡ zero
Â·zero zero = refl
Â·zero (suc x) = Â·zero x

-- unblocks 2.  The residual of `x â‰¡ 1 Â x`: Agda unfolds `1 Â x` to
-- `x + 0 Â x` and stalls there.  This is the exact statement the kernel
-- handed back, and proving it closes the parent.
+Â·zero : (x : â„•) â†’ x + zero Â· x â‰¡ x
+Â·zero x = +zero x

------------------------------------------------------------------------
-- the same laws in the ORIENTATION the engine actually emitted
--
-- The stream contains both `x = x+0` and `x+0 = x`, and both `0 = yÂ0` and
-- `xÂ0 = 0`.  They are the same mathematics, and a queue that does not
-- canonicalise orientation pays for each twice â” recorded here because the
-- duplication is a property of the engine worth fixing, not of â•.

zero+Â· : (y : â„•) â†’ zero â‰¡ y Â· zero
zero+Â· y = sym (Â·zero y)

zero+ : (x : â„•) â†’ x â‰¡ x + zero
zero+ x = sym (+zero x)

------------------------------------------------------------------------
-- consequence: the parent that was stalling
--
-- `x â‰¡ 1 Â x` was refused by the kernel with residual `x != x + 0 Â x`.
-- With the bridge in hand it closes immediately.  This is the whole
-- mechanism, demonstrated end to end on the case that motivated it.

oneMul : (x : â„•) â†’ x â‰¡ suc zero Â· x
oneMul x = sym (+Â·zero x)
