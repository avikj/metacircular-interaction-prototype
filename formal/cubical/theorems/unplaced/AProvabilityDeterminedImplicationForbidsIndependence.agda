{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module AProvabilityDeterminedImplicationForbidsIndependence where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Unit using (tt)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)
open import GodelSeparation
  using ( Theory ; Sent ; Pf ; neg
        ; W ; wtop ; wbot ; wg ; wng ; wneg ; wPf ; Wit )
open import IndependenceNeedsAnInternalImplication
  using (Independent)
open import TheDiagonalLemmaDischargesGoedelFix
  using (HasDiagonal ; imp ; mp)
open import RepresentabilityIsNotEnoughForIndependence
  using (witHasDiagonal)
open import WitSatisfiesEveryHypothesisButOmegaConsistency
  using (impIntro ; witContra)

------------------------------------------------------------------------
-- AProvabilityDeterminedImplicationForbidsIndependence
--
-- The positive case, attempted and shown impossible for the class of
-- models this thread has been building.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ATTEMPT
--
-- `WitSatisfiesEveryHypothesisButOmegaConsistency` leaves one thing
-- unshown: sufficiency.  `Wit` cannot supply it, being ω-inconsistent,
-- so a SECOND small theory would be needed — ω-consistent, satisfying
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
--   §2  and `Wit` is in that class: `impIntro` is
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
-- ────────────────────────────────────────────────────────────────────
--
-- That the requirement is sufficient.  §1 is an obstruction; dropping
-- it does not construct anything.
--
-- That `impIntro` is a defect of `Wit`.  It is a correct property of a
-- correct model, and §2 uses it as such.
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
-- `NegationCompletenessForbidsIndependence` §1 reaches
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
