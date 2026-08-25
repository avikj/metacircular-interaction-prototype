{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- द्वि-मात्रा — the fibre over total two is exactly Bool, the smallest veil.
--
-- Virahāṅka (c. 600-800 CE, Vṛttajātisamuccaya) on Piṅgala's
-- Chandaḥśāstra: the mātrā-fibre over n splits as the fibre over n-1
-- with the fibre over n-2 (that is विरहाङ्क-आवृत्तिः, already proved).
-- Piṅgala's map keeps only the TOTAL and forgets the sequence, and the
-- FIRST total at which it forgets anything is 2: below 2 the fibre is a
-- point (आदि-शून्यम्, आदि-एकम्), and at exactly 2 there are precisely two
-- sequences — laghu-laghu and guru.  This composes the recurrence at n=0
-- with the two contractible base fibres and Bool ≃ Unit ⊎ Unit, giving
--
--        fiber छन्दः 2  ≃  Bool
--
-- on the nose: the first loss is exactly one bit.  This is Dvayam's
-- "two is the smallest veil there is" made concrete at the boundary of
-- prosody, and it is the exact numerical statement that the Virahāṅka
-- count at 2 equals 1 + 1, seen as an identification of fibres rather
-- than an equality of numbers.
--
-- No new mathematics: every part is consumed, not reproved — the fibre
-- recurrence and both base contractions are Virahanka's own; ⊎-equiv,
-- isContr→≃Unit and Iso-⊤⊎⊤-Bool are the cubical library's.  SCOPE: this
-- does not claim Virahāṅka wrote Bool; it names the smallest lossy fibre
-- of his own decomposition.  TERM द्वि-मात्रा (two morae), Chandaḥśāstra
-- vocabulary; substrate cubical (Voevodsky).  Written 2026-08-23.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates,
-- no holes.
------------------------------------------------------------------------

module Mula.DviMatra_TheFibreOverTotalTwoIsExactlyBoolTheSmallestVeil where

open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv ; fiber)
open import Cubical.Foundations.Isomorphism using (isoToEquiv)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Bool.Properties using (Iso-⊤⊎⊤-Bool)
open import Cubical.Data.Sum using (⊎-equiv)
open import Cubical.Data.Unit using (Unit)
open import Cubical.Data.Unit.Properties using (isContr→≃Unit)

import Mula.Virahanka_TheMatraFibreSatisfiesTheTwoStepRecurrence as V

-- fiber छन्दः 2 ≃ (fiber छन्दः 1 ⊎ fiber छन्दः 0)      -- the recurrence at 0
--             ≃ (Unit ⊎ Unit)                           -- both bases a point
--             ≃ Bool                                    -- the bi-point type
द्वि-मात्रा-वरणम् : fiber V.छन्दः 2 ≃ Bool
द्वि-मात्रा-वरणम् =
  compEquiv (V.विरहाङ्क-आवृत्तिः 0)
    (compEquiv
      (⊎-equiv (isContr→≃Unit V.आदि-एकम्) (isContr→≃Unit V.आदि-शून्यम्))
      (isoToEquiv Iso-⊤⊎⊤-Bool))
