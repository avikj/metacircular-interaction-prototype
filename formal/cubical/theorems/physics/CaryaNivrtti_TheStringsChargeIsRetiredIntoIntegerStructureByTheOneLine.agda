{-# OPTIONS --cubical --safe #-}

-- ‡‡∞‡‡Ø‡æ-‡®‡ø‡µ‡‡‡‡‡ø ‚î the string's charge retires into ‚.  Not a new proof:
-- an INSTANTIATION of ‡‡ï‡‡‡‡‡∞'s retirement operator (‡®‡ø‡µ‡‡‡‡‡ø‡).  The
-- winding facts are hand-proved in GranthiCarya.  The one line
-- retires the author: Œ©S¬ ‚â ‚, so EVERY property of ‚ holds of the loop
-- space with no further proof ‚î the charge is not proved to be ‚, it IS
-- ‚, issued.  This is the pattern for retiring the physics into the
-- single primitive.

module CaryaNivrtti_TheStringsChargeIsRetiredIntoIntegerStructureByTheOneLine where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (isoToEquiv)
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.HITs.S1.Base using (Œ©S¬π ; Œ©S¬πIso‚Ñ§)
open import Cubical.Data.Int using (‚Ñ§)
open import EkaSutra_JTheGraphAndTheFundamentalTheoremAreInstancesOfSingletonContractionSoAuthorsRetireIntoInstantiation
  using (‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É)

-- the charge equivalence ‚î the string's loop space is the integers.
‡§ö‡§∞‡•ç‡§Ø‡§æ : Œ©S¬π ‚âÉ ‚Ñ§
‡§ö‡§∞‡•ç‡§Ø‡§æ = isoToEquiv Œ©S¬πIso‚Ñ§

-- ‡®‡ø‡µ‡‡‡‡‡ø applied: any property P of ‚ is inherited by the loop space,
-- carried backwards along the charge equivalence, by the ONE LINE ‚î no
-- proof of the property for loops is written anywhere.
charge-inherits : (P : Type‚ÇÄ ‚Üí Type‚ÇÄ) ‚Üí P ‚Ñ§ ‚Üí P Œ©S¬π
charge-inherits P = ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É P (invEquiv ‡§ö‡§∞‡•ç‡§Ø‡§æ)
  where open import Cubical.Foundations.Equiv using (invEquiv)

-- so: the string carries integer structure not because we prove winding
-- facts one by one, but because it IS ‚ under the charge equivalence,
-- and the retirement operator issues ‚'s whole theory for it at once.
-- GranthiCarya's separate lemmas are instances; the author retires.
