{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àààà â” a MINTED fibre receipt.  Emitted by
-- machine/Tapas_TheTemplateIsTheProofShapeAndEveryNonMatchIsAWrittenRefusal.hs
-- from template T-CONST-BOOL, then CHECKED BY THE KERNEL before landing;
-- the only later edit is the module line, qualified to its path.
--
-- THE EDGE (Lopa's queue, verdict UNDECIDED before this module):
--   NaturalMachine.BatchDepthMemoryBoundary.Old  âŸ  âŸ¨libâŸ©.Bool
--   Â NaturalMachine.BatchDepthMemoryBoundary.oldValue
--
-- WHAT IS PROVED, following the structure of
-- Lopa_TheSumsFibreIsExactlyNPlusOneAndNoLeftInverseExists:
--   Â§1  over the constant's value false, the fibre IS the domain:
--       fiber oldValue false â‰ Old.  A constant map loses
--       EVERYTHING, and the fibre says so exactly: the elided datum is
--       the whole input.
--   Â§2  off the value the fibre is EMPTY: Â fiber oldValue true.
--       à°à¿à•ààà®à â” the third verdict, which a two-valued isContr check
--       conflates with Â§1's opposite.
--   Â§3  hence no section, and so certainly no left inverse in the other
--       role: nothing the map does can be undone, because half the
--       codomain is never reached.
--
------------------------------------------------------------------------

module ConstantFibre_NaturalMachine-BatchDepthMemoryBoundary_oldValue where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; fiber)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Data.Bool using (Bool ; false ; true ; isSetBool ; falseâ‰¢true)
open import Cubical.Data.Empty using (âŠ¥)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)

open import NaturalMachine.BatchDepthMemoryBoundary using (Old ; oldValue)

-- Â§1 Â over the value: the fibre is the whole domain.
over-value : fiber oldValue false â‰ƒ Old
over-value = isoToEquiv i where
  i : Iso (fiber oldValue false) Old
  Iso.fun i = fst
  Iso.inv i x = x , refl
  Iso.rightInv i x = refl
  Iso.leftInv i (x , p) j = x , isSetBool false false refl p j

-- Â§2 Â off the value: the fibre is empty (à°à¿à•ààà®à, the third verdict).
off-value : Â¬ fiber oldValue true
off-value (x , p) = falseâ‰¢true p

-- Â§3 Â no section: the map reaches half the codomain and no map back
-- can pretend otherwise.
no-section : (g : Bool â†’ Old) â†’ ((b : Bool) â†’ oldValue (g b) â‰¡ b) â†’ âŠ¥
no-section g s = falseâ‰¢true (s true)
