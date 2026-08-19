{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.AProvabilityDeterminedImplicationForbidsIndependence where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Unit using (tt)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)
open import GodelSeparation
  using ( Theory ; Sent ; Pf ; neg
        ; W ; wtop ; wbot ; wg ; wng ; wneg ; wPf ; Wit )
open import NaturalMachine.IndependenceNeedsAnInternalImplication
  using (Independent)
open import NaturalMachine.TheDiagonalLemmaDischargesGoedelFix
  using (HasDiagonal ; imp ; mp)
open import NaturalMachine.RepresentabilityIsNotEnoughForIndependence
  using (witHasDiagonal)
open import NaturalMachine.WitSatisfiesEveryHypothesisButOmegaConsistency
  using (impIntro ; witContra)

------------------------------------------------------------------------
-- NaturalMachine.AProvabilityDeterminedImplicationForbidsIndependence
--
-- The positive case, attempted and shown impossible for the class of
-- models this thread has been building.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ATTEMPT
--
-- `WitSatisfiesEveryHypothesisButOmegaConsistency` leaves one thing
-- unshown: sufficiency.  `Wit` cannot supply it, being ω-inconsistent,
-- so the next move was a SECOND small theory — ω-consistent, satisfying
-- the other five hypotheses — in which independence would follow.
--
-- It cannot be built the way `Wit` was built, and the reason is a
-- theorem rather than a difficulty.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  Suppose the internal implication is PROVABILITY-DETERMINED:
--       whenever provability of `a` entails provability of `b`, the
--       sentence `a → b` is provable.  Suppose contraposition, modus
--       ponens, and one sentence `bot` that is unprovable and whose
--       negation is provable.  Then NO sentence is independent.
--
--       Four lines.  Given `¬ Pf s`, the entailment `Pf s → Pf bot`
--       holds vacuously, so `s → bot` is provable; contraposition gives
--       `¬bot → ¬s`; modus ponens with the provable `¬bot` gives
--       `Pf (neg s)`, which is the second half of independence
--       refuted.
--
--   §2  and `Wit` is in that class: `impIntro` (proved last cycle) is
--       exactly the provability-determined rule, `witContra` is
--       contraposition, and `wbot` is the sentence.  So `Wit`'s failure
--       of independence was not about ω-consistency at all — it was
--       forced by the shape of its implication, and would have happened
--       in any ω-consistent model built the same way.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS SAYS ABOUT THE POSITIVE CASE
--
-- A model exhibiting independence must have an implication that is NOT
-- determined by the provability of its parts: there must be sentences
-- `a`, `b` with `a` unprovable and `a → b` unprovable too.  That is
-- exactly what a real theory has and a truth-table does not, and it is
-- why every model in this thread so far — all of them built by reading
-- `imp` off a two-valued assignment — was going to fail.
--
-- AND A CORRECTION TO THE PREVIOUS MODULE'S FRAMING, which this
-- forces.  `WitSatisfiesEveryHypothesisButOmegaConsistency` says
-- ω-consistency is "the one hypothesis whose removal the derivation
-- cannot survive, witnessed by a model satisfying all the others".  The
-- formal statement there is unaffected — the counterexample is a
-- counterexample, and the derivation does need ω-consistency.  The
-- INTERPRETATION is not supported: §1 uses neither ω-consistency nor
-- its negation, nor HBL1, nor consistency, and shows `Wit` would have
-- failed independence whatever its ω-status.  So that witness does not
-- isolate ω-consistency as the thing doing the work; it is
-- overdetermined, and a witness that fails for two reasons attests to
-- neither.  A correction is appended at that module.
--
-- ────────────────────────────────────────────────────────────────────
-- NOT CLAIMED
--
-- That no small ω-consistent model exhibits independence — only that
-- none with a provability-determined implication does, of any size.
-- The positive case remains open and now has a stated requirement.
--
-- That the requirement is sufficient.  §1 is an obstruction; dropping
-- it does not construct anything.
--
-- That `impIntro` is a defect of `Wit`.  It is a correct property of a
-- correct model, and §2 uses it as such.
--
-- PRIOR ART, by the conclusion type: a grep of `formal/cubical` for
-- `Independent` finds this thread's modules only, and nothing states an
-- obstruction to it.  A version phrased over a valuation function
-- rather than over `Pf` would evade that grep.
------------------------------------------------------------------------

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1.  The obstruction
------------------------------------------------------------------------

module _ (T : Theory ℓ) (D : HasDiagonal T)
         (impIsProvabilityDetermined :
            (a b : Sent T) → (Pf T a → Pf T b) → Pf T (imp D a b))
         (contra : (a b : Sent T)
                 → Pf T (imp D a b) → Pf T (imp D (neg T b) (neg T a)))
         (bot : Sent T)
         (botUnprovable : ¬ Pf T bot)
         (negBotProvable : Pf T (neg T bot))
         where

  noIndependentSentence : (s : Sent T) → ¬ Independent T s
  noIndependentSentence s ind =
    snd ind
      (mp D (neg T bot) (neg T s)
          (contra s bot
            (impIsProvabilityDetermined s bot
              (λ ps → Empty.rec (fst ind ps))))
          negBotProvable)

------------------------------------------------------------------------
-- 2.  `Wit` is in the class, so its failure was overdetermined
------------------------------------------------------------------------

witBotUnprovable : ¬ wPf wbot
witBotUnprovable p = p

witNegBotProvable : Pf Wit (neg Wit wbot)
witNegBotProvable = tt

witNoIndependentSentence : (s : W) → ¬ Independent Wit s
witNoIndependentSentence =
  noIndependentSentence Wit witHasDiagonal impIntro witContra
    wbot witBotUnprovable witNegBotProvable

------------------------------------------------------------------------
-- POINTER, not a correction.
--
-- `NaturalMachine.NegationCompletenessForbidsIndependence` §1 reaches
-- the same conclusion for `Wit` from a hypothesis with no connectives
-- in it: if `¬ Pf T s` implies `Pf T (neg T s)` for every `s`, nothing
-- is independent.  One line, and `Wit` satisfies it in four cases.
--
-- Neither statement subsumes the other.  In the respect of what is
-- assumed about the connectives, that one asks less — no `imp`, no
-- contraposition, no modus ponens.  In the respect of what is assumed
-- about the theory, §1 above asks less — it never says the theory
-- decides every sentence.  Both are kept.
------------------------------------------------------------------------
