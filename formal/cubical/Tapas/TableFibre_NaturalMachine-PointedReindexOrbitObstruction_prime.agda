-- LANDED BY àààà on 2026-08-23T21:37:53Z.  Emitted from a template,
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
--   Â NaturalMachine.PointedReindexOrbitObstruction.prime
--
-- WHAT IS PROVED.  The map is the two-clause table false â¦ 2
--   , true â¦ 3, an INJECTION into â•:
--   Â§1  over each value the fibre is a SINGLE POINT (isContr): the
--       elided datum is nothing â” the input is recoverable.
--   Â§2  off both values (witness 6) the fibre is EMPTY.
--   Â§3  hence no section: two points of image, infinitely many targets.
--
------------------------------------------------------------------------

module Tapas.TableFibre_NaturalMachine-PointedReindexOrbitObstruction_prime where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Nat using (â„• ; isSetâ„• ; znots ; _âˆ¸_)
open import Cubical.Data.Empty using () renaming (rec to âŠ¥rec)
open import Cubical.Data.Empty using (âŠ¥)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Relation.Nullary using (Â¬_)

open import NaturalMachine.PointedReindexOrbitObstruction using (prime)

-- the three distinctness facts, one discriminator shape
neq-f-t : Â¬ Path â„• 2 3
neq-f-t = Î» p â†’ znots (cong (_âˆ¸ 2) p)
neq-t-f : Â¬ Path â„• 3 2
neq-t-f = Î» p â†’ znots (cong (_âˆ¸ 2) (sym p))
neq-f-c : Â¬ Path â„• 2 6
neq-f-c = Î» p â†’ znots (cong (_âˆ¸ 2) p)
neq-t-c : Â¬ Path â„• 3 6
neq-t-c = Î» p â†’ znots (cong (_âˆ¸ 3) p)

-- Â§1 Â over each value the fibre is a point: nothing is elided.
over-false : isContr (fiber prime 2)
over-false = (false , refl) , same where
  same : (y : fiber prime 2) â†’ (false , refl) â‰¡ y
  same (false , p) i = false , isSetâ„• 2 2 refl p i
  same (true  , p) = âŠ¥rec (neq-t-f p)

over-true : isContr (fiber prime 3)
over-true = (true , refl) , same where
  same : (y : fiber prime 3) â†’ (true , refl) â‰¡ y
  same (true  , p) i = true , isSetâ„• 3 3 refl p i
  same (false , p) = âŠ¥rec (neq-f-t p)

-- Â§2 Â off both values the fibre is empty (à°à¿à•ààà®à).
off-both : Â¬ fiber prime 6
off-both (false , p) = neq-f-c p
off-both (true  , p) = neq-t-c p

-- Â§3 Â no section: the image has two points and â• does not.
no-section : (g : â„• â†’ Bool) â†’ ((n : â„•) â†’ prime (g n) â‰¡ n) â†’ âŠ¥
no-section g s = off-both (g 6 , s 6)
