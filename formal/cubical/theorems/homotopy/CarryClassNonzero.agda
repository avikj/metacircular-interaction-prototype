{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CarryClassNonzero
--
-- ATLAS_OF_N.md Proposition 2.11, the cohomological half:
--
--     for every base b â‰ 2, every n â‰ 1, and EVERY digit section
--     s : â/bâ¿ â’ â/bâ¿âºÂ whatever, the carry class
--
--         [câ™]  â‰   0     in   HÂ²(â/bâ¿ ; ker Ïâ™),
--
-- where HÂ² is the group constructed in `GroupCohomologyH2`
-- as ZÂ²/BÂ² (the library quotient group), câ™ is `CarryObstruction`'s
-- `Carry.carry` â” i.e. the note's s(u)+s(v)âˆ’s(u+v) â” and Ïâ™ is the
-- truncation â/bâ¿âºÂ â  â/bâ¿.
--
-- The two inputs are combined here and nothing else happens:
--
--   * `GroupCohomologyH2.CarryClass.class-zeroâ’hom-section` â” if the class
--     of the carry vanishes then the extension has a *homomorphic*
--     section;
--   * `CarryObstruction.BasePower.extension-does-not-split` â” it has none.
--
-- Split out of `GroupCohomologyH2` so that the general construction and
-- its arithmetic instance can be checked independently.
--
-- Coefficients are `ker Ïâ™` as a group in its own right, NOT â/b: the
-- isomorphism bâ¿â/bâ¿âºÂ â‰ â/b is not used.
------------------------------------------------------------------------

module CarryClassNonzero where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure

open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Fin.Arithmetic using (+â‚˜-comm)

open import Cubical.Relation.Nullary using (Â¬_)

open import Cubical.Algebra.Group.Base

open import CarryObstruction as CO using ()
open import GroupCohomologyH2 using (module CarryClass)

------------------------------------------------------------------------

-- b = 2 + k â‰ 2 and n = 1 + nâ² â‰ 1, exactly as in `CarryObstruction`.
module CyclicCarryClass (k n' : â„•) where

  open CO.BasePower k n'

  -- For an arbitrary digit set.  (`open â¦ public` is deliberately not
  -- used: only the theorem is re-abstracted over s and sect.)
  module At (s : Fin N â†’ Fin M)
            (sect : (q : Fin N) â†’ red (s q) â‰¡ q) where

    open CarryClass G Q +â‚˜-comm redHom s sect

    -- PROPOSITION 2.11.  The carry class is nonzero.
    carryClassâ‰ 0 : Â¬ (class carryK â‰¡ GroupStr.1g (snd HÂ²))
    carryClassâ‰ 0 =
      class-zeroâ†’hom-section (Î» Ïƒ h â†’ extension-does-not-split Ïƒ h)

  -- â¦ and in particular for the schoolbook alphabet {0,â¦,bâ¿âˆ’1}, whose
  -- carry is the note's câ™ literally.
  module Std = At stdSection stdSection-sect
