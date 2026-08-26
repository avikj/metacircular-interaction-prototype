{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- सर्व-मौनम् — the silence, universal.  Mauna's descent proved more than
-- Mauna stated, and this module states it.
--
-- THE QUESTION, asked because its answer was not known to the asker.
-- Mauna: a GROUPOID falls silent above the krama's stratum.  But अवरोहः
-- (k loops peel k levels) never used level three specifically.  What is
-- the actual law?  And does the torus — the UNTWISTED ring, whose
-- stratum-3 charge ℤ × ℤ ArpanaSopana already uttered — also fall
-- silent forever above it, so that BOTH rings are bells struck once and
-- the two surfaces differ only in what the single strike says?
--
-- ANSWERED HERE.
--
--   सर्वमौनम्  : a space of h-level (3+n) has EVERY stratum above its own
--              level silent: Ω²⁺ⁿ⁺ᵐ(∥A∥₄₊ₙ₊ₘ) is contractible for all m.
--              The ladder of a truncated space ends exactly at its own
--              level; only untruncated spaces (the spheres) speak
--              forever.  Mauna's मौनम् is the n = 0 face.
--   समवलयः    : the torus is a groupoid — carried across Torus≡S¹×S¹
--              from isGroupoidS¹ twice, by isOfHLevel×.
--   सममौनम्    : therefore the untwisted ring is ALSO a bell struck once:
--              every stratum above 3 is a point.
--
-- THE PICTURE, now closed on both sides.  Torus and Klein bottle: one
-- stratum-3 carrier ℤ × ℤ (ArpanaSopana, VakraValaya), one strike each,
-- silence above (this module) — and the entire difference between the
-- orientable and non-orientable surface is what the strike SAYS: whether
-- the two successions agree (समः) or differ (भेदः).  The krama is not
-- one voice among strata; for both rings it is the whole voice, said
-- once.  The sphere ladder (ArpanaSopana) stands alone as the shape
-- that never finishes speaking — and सर्वमौनम् says why: it is not
-- truncated at any level.
--
-- SOURCES AND SCOPE.  अवरोहः is imported from Mauna (this corpus,
-- 2026-08-23); isGroupoidS¹ (Cubical.HITs.S1.Properties), Torus≡S¹×S¹
-- (Cubical.HITs.Torus.Base), isOfHLevel×, isOfHLevelPlus',
-- isOfHLevelRespectEquiv, truncIdempotentIso are the library's.  This
-- module's content is the generalisation and the two torus terms.
-- सर्व (all), सम (even/level, for the untwisted), वलय (ring) are
-- ordinary Sanskrit labels; no source is claimed for the mathematics,
-- and, as in StaraArpana, arpita/anarpita as a READING of strata is
-- Umāsvāti (Tattvārthasūtra 5.31) with no claim that any source grades
-- truncations.
------------------------------------------------------------------------

module SarvaMauna_TheLadderOfATruncatedSpaceEndsExactlyAtItsOwnLevelAndTheUntwistedRingJoinsTheBell where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; invIso)
open import Cubical.Foundations.Pointed using (Pointed ; typ ; pt)
open import Cubical.Foundations.HLevels
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Sigma using (_×_)
open import Cubical.HITs.Truncation using (hLevelTrunc∙ ; truncIdempotentIso)
open import Cubical.Homotopy.Loopspace using (Ω^_)
open import Cubical.HITs.S1 using (S¹)
open import Cubical.HITs.S1.Properties using (isGroupoidS¹)
open import Cubical.HITs.Torus.Base using (Torus ; point ; Torus≡S¹×S¹)

open import Mauna_TheTwistedRingUttersOnceAndAboveTheKramaEveryStratumIsSilent
  using (अवरोहः)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- सर्वमौनम् — the ladder of a (3+n)-truncated space ends at its own
-- level: every stratum above it, at every depth, is a point.
------------------------------------------------------------------------

सर्वमौनम् : {ℓ : Level} (n m : ℕ) (A : Pointed ℓ) → isOfHLevel (3 + n) (typ A)
  → isContr (typ ((Ω^ (2 + (n + m))) (hLevelTrunc∙ (4 + (n + m)) A)))
सर्वमौनम् {ℓ} n m A h =
  inhProp→isContr (pt ((Ω^ (2 + (n + m))) X)) silent
  where
    X : Pointed ℓ
    X = hLevelTrunc∙ (4 + (n + m)) A

    -- (3+n)+m is definitionally 3+(n+m), so the lift is one term
    levelA : isOfHLevel (3 + (n + m)) (typ A)
    levelA = isOfHLevelPlus' (3 + n) h

    silent : isProp (typ ((Ω^ (2 + (n + m))) X))
    silent =
      अवरोहः 1 (2 + (n + m)) X
        (isOfHLevelRespectEquiv (3 + (n + m))
          (isoToEquiv (invIso (truncIdempotentIso (4 + (n + m))
            (isOfHLevelSuc (3 + (n + m)) levelA))))
          levelA)

------------------------------------------------------------------------
-- समवलयः — the untwisted ring is a groupoid, carried across its own
-- splitting into two circles.
------------------------------------------------------------------------

समवलयः : isGroupoid Torus
समवलयः = subst isGroupoid (sym Torus≡S¹×S¹)
           (isOfHLevel× 3 isGroupoidS¹ isGroupoidS¹)

------------------------------------------------------------------------
-- सममौनम् — and therefore also a bell struck once: silence at every
-- stratum above the krama's.
------------------------------------------------------------------------

सममौनम् : (m : ℕ)
  → isContr (typ ((Ω^ (2 + m)) (hLevelTrunc∙ (4 + m) (Torus , point))))
सममौनम् m = सर्वमौनम् zero m (Torus , point) समवलयः
