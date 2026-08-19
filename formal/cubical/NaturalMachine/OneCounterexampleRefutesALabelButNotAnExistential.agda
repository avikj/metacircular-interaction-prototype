{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.OneCounterexampleRefutesALabelButNotAnExistential
--
-- `notes/DARWIN_GODEL_MATH.md` §7 ends its pre-registered kill criteria
-- with one that is different in kind from the others:
--
--   "any artifact labeled kernel-checked or independently replayed fails
--    a clean replay.  One such authority-label error is a boundary
--    failure, not tolerable benchmark noise."
--
-- Every other criterion in that list is a threshold on a rate — 25% of
-- compute, 80% of children, half the development gain, 10% relative
-- score.  This one is not a threshold, and §2–§3 are why: a LABEL is a
-- Π-claim, and a Π-claim is refuted by one instance, while the
-- claim-shapes the other criteria use are not.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED, AND THE HONEST WEAKNESS OF THE CONTRAST
--
-- §2: one labelled artifact that fails to replay refutes the label's
-- soundness outright.  No rate, no tolerance, nothing to average over.
--
-- §3: the same single failure leaves an EXISTENTIAL claim standing.
-- That is the weakest possible witness that claim-shapes differ in
-- refutation conditions, and it is chosen because it needs no counting.
--
-- WHAT IS NOT MODELLED, said rather than glossed: a genuine RATE claim
-- ("more than half", "at most 25%").  That needs a measure and a count,
-- neither of which appears below.  §3 therefore does NOT establish the
-- comparison §7's list invites — it establishes only that at least one
-- other claim-shape survives what kills a label, which is the direction
-- of the point and not its full strength.
--
-- WHAT IS NOT CLAIMED: anything about DGM, its archive, its benchmark
-- numbers, or whether the pilot in §6–§7 should be run.  That note
-- quarantines the design as "not canonical architecture" and declines to
-- import DGM's empirical claims; nothing here changes that, nothing was
-- run, and arXiv:2505.22954 was NOT read by me.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.OneCounterexampleRefutesALabelButNotAnExistential where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1.  A label is a claim about every artifact carrying it
------------------------------------------------------------------------

module _ (Artifact : Type) (Labeled Replays : Artifact → Type) where

  LabelSound : Type
  LabelSound = (a : Artifact) → Labeled a → Replays a

  SomethingReplays : Type
  SomethingReplays = Σ[ a ∈ Artifact ] Replays a

  --------------------------------------------------------------------
  -- 2.  One labelled artifact that fails to replay refutes the label
  --------------------------------------------------------------------

  oneFailureRefutesTheLabel :
    (a : Artifact) → Labeled a → ¬ Replays a → ¬ LabelSound
  oneFailureRefutesTheLabel a lab noRep sound = noRep (sound a lab)

------------------------------------------------------------------------
-- 3.  The same failure leaves an existential standing
--
-- Artifacts are `Bool`; every artifact carries the label; an artifact
-- replays exactly when it is `true`.  So `false` is a labelled failure
-- and `true` is a replaying artifact.
------------------------------------------------------------------------

private
  everything : Bool → Type
  everything _ = Unit

  isTrue : Bool → Type
  isTrue b = b ≡ true

theLabelIsRefuted : ¬ LabelSound Bool everything isTrue
theLabelIsRefuted =
  oneFailureRefutesTheLabel Bool everything isTrue false tt false≢true

theExistentialSurvives : SomethingReplays Bool everything isTrue
theExistentialSurvives = true , refl

bothAtOnce :
    (¬ LabelSound Bool everything isTrue)
  × (SomethingReplays Bool everything isTrue)
bothAtOnce = theLabelIsRefuted , theExistentialSurvives

------------------------------------------------------------------------
-- 4.  The reading
--
-- §7's last criterion is not a stricter threshold than the others; it is
-- not a threshold at all.  A label asserts a Π, and a Π has no
-- tolerance: one counterexample is the whole refutation, which is
-- exactly what "a boundary failure, not tolerable benchmark noise"
-- says.
--
-- §3 shows a single failure is compatible with another claim-shape
-- holding, so "noise" is a meaningful notion for SOME claims — just not
-- for this one.  Which claims, and with what tolerance, is a question
-- about rates and is not answered here.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by this module's author, at the end, altering no
-- line above.
--
-- §"WHAT IS NOT MODELLED" above says: "a genuine RATE claim ('more than
-- half', 'at most 25%') … needs a measure and a count, neither of which
-- appears below.  §3 therefore does NOT establish the comparison §7's
-- list invites."
--
-- The count is now supplied, in
-- `NaturalMachine.RateOneIsExactlyTheUniversalClaim`, over a finite
-- population as a `List Bool`:
--
--   countIsAtMostLength : count bs ≤ length bs
--   allGivesFullCount   : All bs → count bs ≡ length bs
--   fullCountGivesAll   : count bs ≡ length bs → All bs
--
-- So the universal claim and rate one are THE SAME CLAIM, and the label
-- criterion is not a different KIND of criterion from a threshold — it
-- is the threshold at 1, where a single failure moves the count off the
-- length and there is nothing left to tolerate.  A strictly lower
-- threshold surviving that same failure is exhibited there.
--
-- STILL ABSENT, and still said: percentages.  "More than half" is
-- stateable as `length xs < 2 · count xs`; it is not stated there, and
-- no threshold other than 1 is analysed.  The population is a LIST, so
-- multiplicity is counted and order carried — neither matters to the
-- equivalence and both would matter to a finer measure.
------------------------------------------------------------------------
