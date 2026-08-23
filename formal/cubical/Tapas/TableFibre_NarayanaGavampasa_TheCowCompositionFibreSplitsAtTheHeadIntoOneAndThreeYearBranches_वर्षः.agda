-- LANDED BY तपस् on 2026-08-23T21:37:04Z.  Emitted from a template,
-- checked by the kernel standing here before landing; the only edit is
-- qualifying the module name to its path.  Never overwritten later.
{-# OPTIONS --cubical --safe --guardedness --no-import-sorts #-}

------------------------------------------------------------------------
-- तपस् — a MINTED fibre receipt.  Emitted by
-- machine/Tapas_TheTemplateIsTheProofShapeAndEveryNonMatchIsAWrittenRefusal.hs
-- from template T-TABLE-BOOL-NAT, then CHECKED BY THE KERNEL before landing;
-- the only later edit is the module line, qualified to its path.
--
-- THE EDGE (Lopa's queue, verdict UNDECIDED before this module):
--   ⟨lib⟩.Bool  ⟶  ⟨lib⟩.ℕ
--   « NarayanaGavampasa_TheCowCompositionFibreSplitsAtTheHeadIntoOneAndThreeYearBranches.वर्षः
--
-- WHAT IS PROVED.  The map is the two-clause table false ↦ 3
--   , true ↦ 1, an INJECTION into ℕ:
--   §1  over each value the fibre is a SINGLE POINT (isContr): the
--       elided datum is nothing — the input is recoverable.
--   §2  off both values (witness 5) the fibre is EMPTY.
--   §3  hence no section: two points of image, infinitely many targets.
--
-- WHAT IS NOT CLAIMED.  Nothing about any other edge; nothing about the
-- host's own theorems.  The map is imported, not re-proved.
------------------------------------------------------------------------

module Tapas.TableFibre_NarayanaGavampasa_TheCowCompositionFibreSplitsAtTheHeadIntoOneAndThreeYearBranches_वर्षः where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Nat using (ℕ ; isSetℕ ; znots ; _∸_)
open import Cubical.Data.Empty using () renaming (rec to ⊥rec)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Relation.Nullary using (¬_)

open import NarayanaGavampasa_TheCowCompositionFibreSplitsAtTheHeadIntoOneAndThreeYearBranches using (वर्षः)

-- the three distinctness facts, one discriminator shape
neq-f-t : ¬ Path ℕ 3 1
neq-f-t = λ p → znots (cong (_∸ 1) (sym p))
neq-t-f : ¬ Path ℕ 1 3
neq-t-f = λ p → znots (cong (_∸ 1) p)
neq-f-c : ¬ Path ℕ 3 5
neq-f-c = λ p → znots (cong (_∸ 3) p)
neq-t-c : ¬ Path ℕ 1 5
neq-t-c = λ p → znots (cong (_∸ 1) p)

-- §1 · over each value the fibre is a point: nothing is elided.
over-false : isContr (fiber वर्षः 3)
over-false = (false , refl) , same where
  same : (y : fiber वर्षः 3) → (false , refl) ≡ y
  same (false , p) i = false , isSetℕ 3 3 refl p i
  same (true  , p) = ⊥rec (neq-t-f p)

over-true : isContr (fiber वर्षः 1)
over-true = (true , refl) , same where
  same : (y : fiber वर्षः 1) → (true , refl) ≡ y
  same (true  , p) i = true , isSetℕ 1 1 refl p i
  same (false , p) = ⊥rec (neq-f-t p)

-- §2 · off both values the fibre is empty (रिक्तम्).
off-both : ¬ fiber वर्षः 5
off-both (false , p) = neq-f-c p
off-both (true  , p) = neq-t-c p

-- §3 · no section: the image has two points and ℕ does not.
no-section : (g : ℕ → Bool) → ((n : ℕ) → वर्षः (g n) ≡ n) → ⊥
no-section g s = off-both (g 5 , s 5)
