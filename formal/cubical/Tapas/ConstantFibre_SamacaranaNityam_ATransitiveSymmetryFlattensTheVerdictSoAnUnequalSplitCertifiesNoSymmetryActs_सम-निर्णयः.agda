-- LANDED BY तपस् on 2026-08-23T21:36:55Z.  Emitted from a template,
-- checked by the kernel standing here before landing; the only edit is
-- qualifying the module name to its path.  Never overwritten later.
{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- तपस् — a MINTED fibre receipt.  Emitted by
-- machine/Tapas_TheTemplateIsTheProofShapeAndEveryNonMatchIsAWrittenRefusal.hs
-- from template T-CONST-BOOL, then CHECKED BY THE KERNEL before landing;
-- the only later edit is the module line, qualified to its path.
--
-- THE EDGE (Lopa's queue, verdict UNDECIDED before this module):
--   SamacaranaNityam_ATransitiveSymmetryFlattensTheVerdictSoAnUnequalSplitCertifiesNoSymmetryActs.द्वि-क्रमः  ⟶  ⟨lib⟩.Bool
--   « SamacaranaNityam_ATransitiveSymmetryFlattensTheVerdictSoAnUnequalSplitCertifiesNoSymmetryActs.सम-निर्णयः
--
-- WHAT IS PROVED, following the structure of
-- Lopa_TheSumsFibreIsExactlyNPlusOneAndNoLeftInverseExists:
--   §1  over the constant's value true, the fibre IS the domain:
--       fiber सम-निर्णयः true ≃ द्वि-क्रमः.  A constant map loses
--       EVERYTHING, and the fibre says so exactly: the elided datum is
--       the whole input.
--   §2  off the value the fibre is EMPTY: ¬ fiber सम-निर्णयः false.
--       रिक्तम् — the third verdict, which a two-valued isContr check
--       conflates with §1's opposite.
--   §3  hence no section, and so certainly no left inverse in the other
--       role: nothing the map does can be undone, because half the
--       codomain is never reached.
--
-- WHAT IS NOT CLAIMED.  Nothing about any other edge; nothing about the
-- host's own theorems.  द्वि-क्रमः is imported, not re-proved.
------------------------------------------------------------------------

module Tapas.ConstantFibre_SamacaranaNityam_ATransitiveSymmetryFlattensTheVerdictSoAnUnequalSplitCertifiesNoSymmetryActs_सम-निर्णयः where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Data.Bool using (Bool ; false ; true ; isSetBool ; true≢false)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import SamacaranaNityam_ATransitiveSymmetryFlattensTheVerdictSoAnUnequalSplitCertifiesNoSymmetryActs using (द्वि-क्रमः ; सम-निर्णयः)

-- §1 · over the value: the fibre is the whole domain.
over-value : fiber सम-निर्णयः true ≃ द्वि-क्रमः
over-value = isoToEquiv i where
  i : Iso (fiber सम-निर्णयः true) द्वि-क्रमः
  Iso.fun i = fst
  Iso.inv i x = x , refl
  Iso.rightInv i x = refl
  Iso.leftInv i (x , p) j = x , isSetBool true true refl p j

-- §2 · off the value: the fibre is empty (रिक्तम्, the third verdict).
off-value : ¬ fiber सम-निर्णयः false
off-value (x , p) = true≢false p

-- §3 · no section: the map reaches half the codomain and no map back
-- can pretend otherwise.
no-section : (g : Bool → द्वि-क्रमः) → ((b : Bool) → सम-निर्णयः (g b) ≡ b) → ⊥
no-section g s = true≢false (s false)
