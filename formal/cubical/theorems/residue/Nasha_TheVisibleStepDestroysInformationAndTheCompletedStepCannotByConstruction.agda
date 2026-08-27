{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- नाश — destruction.  THE VISIBLE STEP DESTROYS INFORMATION; THE
-- COMPLETED STEP CANNOT, BY CONSTRUCTION.
--
-- A one-rule machine that erases the scanned stroke sends two distinct
-- configurations to the same configuration: the collision is computed
-- (`collision` is refl) and the distinctness is a two-line refutation.
-- So the visible step is not injective — the machine really does
-- destroy a bit, and here is the bit.
--
-- The completed step cannot do this.  For ANY map, the lossless
-- completion is injective (`completed-injective`), because it is an
-- equivalence; instantiated at the eraser, the two colliding
-- configurations are separated by their kept fibres
-- (`fibres-separate`).  Irreversibility is real at the level of the
-- projection and impossible at the level of the completion — which is
-- exactly what "the forgotten object is the fibre" means when it is
-- cashed out on a concrete machine.
------------------------------------------------------------------------

module Nasha_TheVisibleStepDestroysInformationAndTheCompletedStepCannotByConstruction where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (equivFun ; invEq ; retEq)
open import Cubical.Data.Nat using (snotz)
open import Cubical.Data.List using ([] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Empty as Empty using (⊥)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource

------------------------------------------------------------------------
-- §1  The eraser, and its computed collision.
------------------------------------------------------------------------

-- One rule: reading a stroke, erase it, stay.
eraser : Code
eraser = (0 , 1 , 0 , 0 , stay) ∷ []

-- A stroke under the head, and a blank under the head.
struck : Machine
struck = eraser , 0 , [] , 1 , []

blank : Machine
blank = eraser , 0 , [] , 0 , []

-- Both step to the blank: the stroke is erased, the blank stands
-- still.  The collision is computation, not argument.
collision : uStep struck ≡ uStep blank
collision = refl

-- And the two are distinct: their scanned cells already differ.
distinct : ¬ struck ≡ blank
distinct p = snotz (cong (λ mc → fst (snd (snd (snd mc)))) p)

-- So the visible step destroyed exactly one bit, exhibited.
the-step-forgets : Σ[ x ∈ Machine ] Σ[ y ∈ Machine ]
  (¬ x ≡ y) × (uStep x ≡ uStep y)
the-step-forgets = struck , blank , distinct , collision

------------------------------------------------------------------------
-- §2  The completed step cannot forget.
------------------------------------------------------------------------

-- The lossless completion of ANY map is injective: it is an
-- equivalence, and the retraction is the proof.
completed-injective : {ℓ ℓ' : Level} {A : Type ℓ} {B : Type ℓ'}
  (f : A → B) (a a' : A) →
  equivFun (lossless f) a ≡ equivFun (lossless f) a' → a ≡ a'
completed-injective f a a' p =
  sym (retEq (lossless f) a) ∙ cong (invEq (lossless f)) p ∙ retEq (lossless f) a'

-- Instantiated at the machine: the completed universal step separates
-- what the visible step collided.  The two configurations differ, so
-- their completed steps must differ — the kept fibre is the receipt.
fibres-separate : ¬ (equivFun (lossless uStep) struck ≡ equivFun (lossless uStep) blank)
fibres-separate p = distinct (completed-injective uStep struck blank p)
