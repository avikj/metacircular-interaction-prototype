{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sha256Varga — the hash factors through its classes: every class is a
-- fibre, the descended map forgets nothing, and the kernel separates
-- concrete classes by computing.
--
-- The owner's correction, taken literally.  न-तुल्यता (Parimana) was
-- information-theoretically obvious — the codomain has slack, so of
-- course the map is no equivalence.  The object that is NOT obvious is
-- the MAP OF EQUIVALENCE CLASSES OF INPUTS BY HASH, and that is what
-- this module hands to the kernel:
--
--   x ∼ y  :=  sha256 x ≡ sha256 y        (the kernel relation)
--   वर्गाः  :=  Bits / ∼                    (the space of classes)
--   अवतरणम् : वर्गाः → Bits                 (the map of classes)
--
-- WHAT IS PROVED:
--   §2  वर्ग-तन्तु — the class of x, read as a type, IS the fibre of
--       sha256 over its digest.  By refl: they are the same type.  The
--       partition crypto cares about and the fibre the completion
--       carries are one object.
--   §3  अवतरण-घटना — sha256 factors: sha256 = अवतरणम् ∘ [_], and the
--       factorization is definitional.
--   §4  अवतरण-एकैकम् — the descended map is INJECTIVE: on classes the
--       hash forgets nothing.  So ALL the forgetting — all the
--       one-wayness — lives in the projection [_] onto classes, and
--       none of it in the leg that lands in digest space.
--   §5  वर्ग-पूर्णता — every class is inhabited by a message ([_] is
--       surjective): the quotient carries no phantom classes.
--   §6  भेदः / वर्ग-भेदः — concrete class separation, COMPUTED: the
--       kernel evaluates both full pipelines and separates the class
--       of the empty message from the class of "abc" at bit 1 of the
--       digests.  Whether two GIVEN messages share a class is always
--       answerable this way — the kernel computes both digests and
--       compares.  What remains open is exhibiting two DISTINCT
--       messages in ONE class: that inhabitant of ∼ off the diagonal
--       is precisely a collision, Sesa's exchange rate.
--
-- Reading: the equivalence-class map is computed in the only sense
-- available to anyone — pointwise, by running the hash — and it is
-- now carried as structure: classes ↪ digests, injectively, with the
-- class of every message literally the fibre the lossless completion
-- keeps.  The quotient is where the secret's address book lives.
--
-- CHECKED: Agda 2.8.0, --cubical --safe, through scripts/oracle.
------------------------------------------------------------------------

module Sha256Varga_TheHashFactorsThroughItsClassesEveryClassIsAFibreAndTheDescendedMapForgetsNothing where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.List.Properties using (isOfHLevelList)
open import Cubical.Data.Bool using (Bool ; true ; false ; isSetBool ; false≢true)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ-syntax ; ∃-syntax ; _,_)
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.HITs.SetQuotients as SQ
  using (_/_ ; [_] ; eq/ ; squash/)
open import Cubical.Relation.Binary.Base using (module BinaryRelation)
open import Cubical.Relation.Nullary using (¬_)

open import Sha256 using (sha256 ; fromBytes)

Bits : Type
Bits = List Bool

isSetBits : isSet Bits
isSetBits = isOfHLevelList 0 isSetBool

------------------------------------------------------------------------
-- §1  The kernel relation: same digest.
------------------------------------------------------------------------

_∼_ : Bits → Bits → Type
x ∼ y = sha256 x ≡ sha256 y

∼-prop : BinaryRelation.isPropValued _∼_
∼-prop x y = isSetBits (sha256 x) (sha256 y)

∼-equivRel : BinaryRelation.isEquivRel _∼_
∼-equivRel = BinaryRelation.equivRel
  (λ x → refl)
  (λ x y p → sym p)
  (λ x y z p q → p ∙ q)

------------------------------------------------------------------------
-- §2  The class of x IS the fibre over its digest — the same type.
------------------------------------------------------------------------

वर्गः : Bits → Type
वर्गः x = Σ[ y ∈ Bits ] (y ∼ x)

वर्ग-तन्तु : (x : Bits) → वर्गः x ≡ fiber sha256 (sha256 x)
वर्ग-तन्तु x = refl

------------------------------------------------------------------------
-- §3  The quotient, and the factorization through it.
------------------------------------------------------------------------

वर्गाः : Type
वर्गाः = Bits / _∼_

-- the map OF equivalence classes: each class to its one digest
अवतरणम् : वर्गाः → Bits
अवतरणम् = SQ.rec isSetBits sha256 (λ x y p → p)

-- sha256 = अवतरणम् ∘ [_], definitionally
अवतरण-घटना : (x : Bits) → अवतरणम् [ x ] ≡ sha256 x
अवतरण-घटना x = refl

------------------------------------------------------------------------
-- §4  The descended map forgets nothing: injective on classes.
------------------------------------------------------------------------

अवतरण-एकैकम् : (a b : वर्गाः) → अवतरणम् a ≡ अवतरणम् b → a ≡ b
अवतरण-एकैकम् =
  SQ.elimProp2 (λ a b → isPropΠ (λ _ → squash/ a b)) (λ x y p → eq/ x y p)

------------------------------------------------------------------------
-- §5  Every class is a message's class: no phantom classes.
------------------------------------------------------------------------

वर्ग-पूर्णता : (c : वर्गाः) → ∃[ x ∈ Bits ] ([ x ] ≡ c)
वर्ग-पूर्णता = SQ.[]surjective

------------------------------------------------------------------------
-- §6  Concrete separation, computed by the kernel: the empty message
--     and "abc" lie in different classes, split at bit 1.
------------------------------------------------------------------------

abc : Bits
abc = fromBytes (0x61 ∷ 0x62 ∷ 0x63 ∷ [])

bit : ℕ → Bits → Bool
bit _       []       = false
bit zero    (b ∷ _)  = b
bit (suc n) (_ ∷ bs) = bit n bs

-- the kernel runs both full pipelines and separates the digests
भेदः : ¬ ([] ∼ abc)
भेदः p = false≢true (sym (cong (bit 1) p))

-- so the two classes are distinct points of the quotient
वर्ग-भेदः : ¬ Path वर्गाः [ [] ] [ abc ]
वर्ग-भेदः q = भेदः (SQ.effective ∼-prop ∼-equivRel [] abc q)
