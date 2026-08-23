{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- मौनम् — silence.  The complement of the ladder of offerings.
--
-- THE QUESTION, asked because its answer was not known to the asker.
-- ArpanaSopana: every stratum of the sphere utters a NEW charge — the
-- ladder never ends.  VakraValaya: the Klein bottle's one charge lives
-- in the krama, at stratum 3.  Does the twisted ring ever speak again
-- above that stratum — or does it utter once and hold silence forever?
--
-- ANSWERED HERE: silence, at every depth, and the reason is an h-level.
-- The general law is about ANY groupoid-truncated space:
--
--   मौनम्  :  a groupoid A has  Ωᵐ⁺²(∥A∥₄₊ₘ)  contractible for every m —
--            above the stratum where π₁ speaks, no stratum utters
--            anything, because each loop peels one h-level and a
--            groupoid has only three to give.
--   वक्रमौनम् : the Klein bottle instance, on the library's
--            isGroupoidKleinBottle.
--
-- Read with ArpanaSopana's सामान्यम् (Ωᵐ⁺¹(∥A∥₃₊ₘ) ≃ πₘ₊₁ A), this says
-- πₘ₊₂(K) is trivial for every m — the surface is aspherical — but that
-- composition is not re-proved here; this module is self-contained on
-- h-levels alone, so it loads light.  Together the three modules close
-- one picture: the sphere is a ladder that never ends; the twisted ring
-- is a bell struck once — everything it will ever say is said at
-- stratum 3, and said in the ORDER of succession, not in the carrier.
--
-- SOURCES AND SCOPE.  isGroupoidKleinBottle is the library's
-- (Cubical.HITs.KleinBottle.Properties); the h-level engines
-- (isOfHLevelPath', isOfHLevelPlus', isOfHLevelRespectEquiv,
-- truncIdempotentIso, isOfHLevelTrunc) are the library's; this module's
-- content is अवरोहः (the descent of levels through iterated Ω) and the
-- composition.  मौन (silence) and अवरोह (descent) are ordinary Sanskrit
-- labels; no source is claimed for the mathematics.  Umāsvāti's
-- arpita/anarpita reading of strata is inherited from StaraArpana and,
-- as there, is a reading — no source is claimed to grade truncations.
------------------------------------------------------------------------

module Mauna_TheTwistedRingUttersOnceAndAboveTheKramaEveryStratumIsSilent where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; invIso)
open import Cubical.Foundations.Pointed using (Pointed ; typ ; pt)
open import Cubical.Foundations.HLevels
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-suc ; +-zero)
open import Cubical.HITs.Truncation
  using (hLevelTrunc∙ ; truncIdempotentIso)
open import Cubical.Homotopy.Loopspace using (Ω^_ ; Ω)
open import Cubical.HITs.KleinBottle using (KleinBottle ; point)
open import Cubical.HITs.KleinBottle.Properties using (isGroupoidKleinBottle)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- अवरोहः — the descent: k loops peel k h-levels.  Stated with the sum
-- on the left of the level so the instantiations below are definitional.
------------------------------------------------------------------------

अवरोहः : (n k : ℕ) (A : Pointed ℓ)
  → isOfHLevel (n + k) (typ A) → isOfHLevel n (typ ((Ω^ k) A))
अवरोहः n zero    A h = subst (λ x → isOfHLevel x (typ A)) (+-zero n) h
अवरोहः n (suc k) A h =
  isOfHLevelPath' n
    (अवरोहः (suc n) k A
      (subst (λ x → isOfHLevel x (typ A)) (+-suc n k) h))
    _ _

------------------------------------------------------------------------
-- मौनम् — a groupoid, truncated at any stratum above the krama's, is
-- silent there: the (4+m)-th stratum's (2+m)-fold loop space is a point.
------------------------------------------------------------------------

मौनम् : (m : ℕ) (A : Pointed ℓ) → isGroupoid (typ A)
  → isContr (typ ((Ω^ (2 + m)) (hLevelTrunc∙ (4 + m) A)))
मौनम् m A grpd =
  inhProp→isContr (pt ((Ω^ (2 + m)) (hLevelTrunc∙ (4 + m) A))) silent
  where
    truncLevel : isOfHLevel (1 + (2 + m)) (typ (hLevelTrunc∙ (4 + m) A))
    truncLevel =
      isOfHLevelRespectEquiv (3 + m)
        (isoToEquiv (invIso (truncIdempotentIso (4 + m)
          (isOfHLevelPlus' 3 grpd))))
        (isOfHLevelPlus' 3 grpd)
    silent : isProp (typ ((Ω^ (2 + m)) (hLevelTrunc∙ (4 + m) A)))
    silent = अवरोहः 1 (2 + m) (hLevelTrunc∙ (4 + m) A) truncLevel

------------------------------------------------------------------------
-- वक्रमौनम् — the twisted ring utters once.  Its stratum-3 charge is the
-- krama (VakraValaya); above that, every stratum is a point.
------------------------------------------------------------------------

वक्रमौनम् : (m : ℕ)
  → isContr (typ ((Ω^ (2 + m)) (hLevelTrunc∙ (4 + m) (KleinBottle , point))))
वक्रमौनम् m = मौनम् m (KleinBottle , point) isGroupoidKleinBottle
