-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MachineCurriculum — the lemmas the engine asked for, answered.
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
--     unblocks 14   0 = y·0
--     unblocks  8   x·0 = 0
--     unblocks  5   x = x+0
--     unblocks  3   0 = 0∸y
--     unblocks  2   x = x + 0·x
--
-- ┌─ AS-OF, added 2026-08-18.  READ THIS BEFORE BELIEVING ANY NUMBER ABOVE
-- │  OR BELOW.  Every figure in this header — 130 / 78 / 54, the five
-- │  `unblocks` counts, and the "179 proofs … 6 back" at the end — is an
-- │  aggregate that `machine/Obstruction.hs` computed from
-- │  `machine/machine.log` on a run whose date and log size were never
-- │  recorded.  They were quoted in the present tense, which is what makes
-- │  them rot; `notes/INDIAN_LANE_CITATION_AUDIT.md` F8(d) is the finding.
-- │
-- │  `machine/machine.log` at the time of this edit: `wc -l` = 10700.  It
-- │  is gitignored (`.gitignore`:16) — NOT present in a fresh clone, so
-- │  none of these numbers is reproducible from one.  It is append-only
-- │  across runs (61 `DISPATCH` blocks at that size) and it is LIVE: it
-- │  grew from 10475 to 10700 lines while this repair was being made.
-- │
-- │  The counts are deliberately NOT re-measured and substituted here,
-- │  for two reasons.  (i) Substituting a fresh number without its log
-- │  size just re-arms the same trap.  (ii) More seriously, "179 proofs
-- │  and got 6 back" is no longer even well-defined against this file:
-- │  it described ONE live round of ONE run, and `round=N` is now reused
-- │  by all 61 runs, so the log's per-round tallies aggregate across runs
-- │  and no round matches.  For the record, at 10700 lines the per-round
-- │  totals are round=0 2142/846, 1 0/112, 2 8/235, 3 2/152, 4 78/453,
-- │  5 55/363, 6 102/245, 7 14/244, 8 5/98 (accepts/rejects).  The audit
-- │  found round=4 at 6/165; it is now 78/453.  That is not drift in a
-- │  measurement, it is a different population.
-- │
-- │  WHAT SURVIVES, and it is the whole point of this module: the RANKING
-- │  is illustrative, the LEMMAS are not.  Nothing proved below depends on
-- │  any count — `+zero`, `·zero`, `+·zero`, `oneMul` are theorems of ℕ and
-- │  are checked by the kernel here.  The mechanism claim (§ "WHY THE
-- │  ENGINE IS ASKING FOR THESE") is an argument about how Agda's `_·_`
-- │  recurses, not a measurement, and stands on its own.
-- └─
--
-- WHY THE ENGINE IS ASKING FOR THESE, which is the part worth understanding.
-- It already HAS `x·0 = 0` — it is a defining equation of `*` in its own
-- vocabulary.  It is demanding a lemma it knows.  The reason is that Agda's
-- `_·_` on ℕ recurses on its SECOND argument (`m · zero = zero` holds only
-- after induction on m, while `zero · n` is immediate), so `x · 0` is not
-- definitionally `0` here, whereas the engine's rewriter discharges it at
-- once.  Every one of these lemmas is a place where the engine's notion of
-- equality is computational and Agda's is not.
--
-- So this module is not a list of things the machine did not know.  It is
-- the BRIDGE between the machine's rewriting and the kernel's definitional
-- equality, and closing it is what raises the acceptance rate — a live round
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
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)

------------------------------------------------------------------------
-- the four that carry the ranking

-- unblocks 5.  Right unit of +.  `zero + x` is immediate; `x + zero` is not.
+zero : (x : ℕ) → x + zero ≡ x
+zero zero = refl
+zero (suc x) = cong suc (+zero x)

-- unblocks 8 (and 14, and 6, as `0 = y·0` and `0 = z·0` — the engine states
-- the same law once per variable name it happened to use).  Right
-- annihilator.  This is the single most demanded lemma in the whole stream.
·zero : (x : ℕ) → x · zero ≡ zero
·zero zero = refl
·zero (suc x) = ·zero x

-- unblocks 2.  The residual of `x ≡ 1 · x`: Agda unfolds `1 · x` to
-- `x + 0 · x` and stalls there.  This is the exact statement the kernel
-- handed back, and proving it closes the parent.
+·zero : (x : ℕ) → x + zero · x ≡ x
+·zero x = +zero x

------------------------------------------------------------------------
-- the same laws in the ORIENTATION the engine actually emitted
--
-- The stream contains both `x = x+0` and `x+0 = x`, and both `0 = y·0` and
-- `x·0 = 0`.  They are the same mathematics, and a queue that does not
-- canonicalise orientation pays for each twice — recorded here because the
-- duplication is a property of the engine worth fixing, not of ℕ.

zero+· : (y : ℕ) → zero ≡ y · zero
zero+· y = sym (·zero y)

zero+ : (x : ℕ) → x ≡ x + zero
zero+ x = sym (+zero x)

------------------------------------------------------------------------
-- consequence: the parent that was stalling
--
-- `x ≡ 1 · x` was refused by the kernel with residual `x != x + 0 · x`.
-- With the bridge in hand it closes immediately.  This is the whole
-- mechanism, demonstrated end to end on the case that motivated it.

oneMul : (x : ℕ) → x ≡ suc zero · x
oneMul x = sym (+·zero x)
