-- LANDED BY àààà on 2026-08-23T21:38:12Z.  Emitted from a template,
-- checked by the kernel standing here before landing; the only edit is
-- qualifying the module name to its path.  Never overwritten later.
{-# OPTIONS --cubical --safe --guardedness --no-import-sorts #-}

------------------------------------------------------------------------
-- àààà â” a MINTED fibre receipt.  Emitted by
-- machine/Tapas_TheTemplateIsTheProofShapeAndEveryNonMatchIsAWrittenRefusal.hs
-- from template T-TABLE-BOOL-NAT, then CHECKED BY THE KERNEL before landing;
-- the only later edit is the module line, qualified to its path.
--
-- THE EDGE (Lopa's queue, verdict UNDECIDED before this module):
--   âŸ¨libâŸ©.Bool  âŸ  âŸ¨libâŸ©.â•
--   Â SimplicialDefectFailure.stepB
--
-- WHAT IS PROVED.  The map is the two-clause table false â¦ 0
--   , true â¦ 1, an INJECTION into â•:
--   Â§1  over each value the fibre is a SINGLE POINT (isContr): the
--       elided datum is nothing â” the input is recoverable.
--   Â§2  off both values (witness 2) the fibre is EMPTY.
--   Â§3  hence no section: two points of image, infinitely many targets.
--
------------------------------------------------------------------------

module Tapas.TableFibre_SimplicialDefectFailure_stepB where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Nat using (â„• ; isSetâ„• ; znots ; _âˆ¸_)
open import Cubical.Data.Empty using () renaming (rec to âŠ¥rec)
open import Cubical.Data.Empty using (âŠ¥)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Relation.Nullary using (Â¬_)

open import SimplicialDefectFailure using (stepB)

-- the three distinctness facts, one discriminator shape
neq-f-t : Â¬ Path â„• 0 1
neq-f-t = Î» p â†’ znots (cong (_âˆ¸ 0) p)
neq-t-f : Â¬ Path â„• 1 0
neq-t-f = Î» p â†’ znots (cong (_âˆ¸ 0) (sym p))
neq-f-c : Â¬ Path â„• 0 2
neq-f-c = Î» p â†’ znots (cong (_âˆ¸ 0) p)
neq-t-c : Â¬ Path â„• 1 2
neq-t-c = Î» p â†’ znots (cong (_âˆ¸ 1) p)

-- Â§1 Â over each value the fibre is a point: nothing is elided.
over-false : isContr (fiber stepB 0)
over-false = (false , refl) , same where
  same : (y : fiber stepB 0) â†’ (false , refl) â‰¡ y
  same (false , p) i = false , isSetâ„• 0 0 refl p i
  same (true  , p) = âŠ¥rec (neq-t-f p)

over-true : isContr (fiber stepB 1)
over-true = (true , refl) , same where
  same : (y : fiber stepB 1) â†’ (true , refl) â‰¡ y
  same (true  , p) i = true , isSetâ„• 1 1 refl p i
  same (false , p) = âŠ¥rec (neq-f-t p)

-- Â§2 Â off both values the fibre is empty (à°à¿à•ààà®à).
off-both : Â¬ fiber stepB 2
off-both (false , p) = neq-f-c p
off-both (true  , p) = neq-t-c p

-- Â§3 Â no section: the image has two points and â• does not.
no-section : (g : â„• â†’ Bool) â†’ ((n : â„•) â†’ stepB (g n) â‰¡ n) â†’ âŠ¥
no-section g s = off-both (g 2 , s 2)
