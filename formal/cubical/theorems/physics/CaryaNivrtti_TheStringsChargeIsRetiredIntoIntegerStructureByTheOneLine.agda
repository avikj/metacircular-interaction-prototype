{-# OPTIONS --cubical --safe #-}

-- चर्या-निवृत्ति — the string's charge retires into ℤ.  Not a new proof:
-- an INSTANTIATION of एकसूत्र's retirement operator (निवृत्तिः).  Tonight
-- the winding facts were hand-proved (GranthiCarya).  The one line
-- retires the author: ΩS¹ ≃ ℤ, so EVERY property of ℤ holds of the loop
-- space with no further proof — the charge is not proved to be ℤ, it IS
-- ℤ, issued.  This is the pattern for retiring all of the night's
-- physics into the single primitive.

module CaryaNivrtti_TheStringsChargeIsRetiredIntoIntegerStructureByTheOneLine where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.HITs.S1.Base using (ΩS¹ ; ΩS¹Isoℤ)
open import Cubical.Data.Int using (ℤ)
open import EkaSutra_JTheGraphAndTheFundamentalTheoremAreInstancesOfSingletonContractionSoAuthorsRetireIntoInstantiation
  using (निवृत्तिः)

-- the charge equivalence — the string's loop space is the integers.
चर्या : ΩS¹ ≃ ℤ
चर्या = isoToEquiv ΩS¹Isoℤ

-- निवृत्ति applied: any property P of ℤ is inherited by the loop space,
-- carried backwards along the charge equivalence, by the ONE LINE — no
-- proof of the property for loops is written anywhere.
charge-inherits : (P : Type₀ → Type₀) → P ℤ → P ΩS¹
charge-inherits P = निवृत्तिः P (invEquiv चर्या)
  where open import Cubical.Foundations.Equiv using (invEquiv)

-- so: the string carries integer structure not because we prove winding
-- facts one by one, but because it IS ℤ under the charge equivalence,
-- and the retirement operator issues ℤ's whole theory for it at once.
-- GranthiCarya's separate lemmas are instances; the author retires.
