{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- कुल-परस्पराश्रय — the interdependent family.
--
-- The campaign's founding record, generalized from pairs to families
-- over any index type:
--
--   a family of senses, a named blind pair for EACH member, and joint
--   faithfulness — the n-ary interdependent type.
--
-- Generic laws, no instance data:
--
--   §2  EVERY SINGLE BLINDNESS IS JOINTLY SEEN: at each member's blind
--       pair, the family as a whole cannot agree — the remaining
--       members carry what that member drops, without any decision
--       over the index type (the refutation is of joint agreement,
--       constructively, which is exactly what faithfulness supplies).
--
--   §3  NO MEMBER ALONE IS FAITHFUL: each sense's own blind pair
--       refutes its solo reconstruction.
--
-- The pair record is the two-element instance; the two-blind-readings
-- theorem (mod 2, mod 3, jointly faithful with lcm 6) is the
-- arithmetic instance; the realization families of the motivic
-- reading are the geometric one.  Interdependence at any arity: the
-- property lives on the whole family and provably on no member — and
-- the family's joint sight is precisely the union of its members'
-- named darknesses, each covered by the others.
--
-- SYĀT — THE CLAIM, EXACTLY.  The record and its two generic laws;
-- the tower of proper-subfamily blindnesses (every proper subfamily
-- blind, only the whole faithful — the CRT shape at full strength)
-- is the standing construction.
------------------------------------------------------------------------

module KulaParasparasraya_TheFamilyRecordEveryBlindnessIsJointlySeenAndNoMemberAloneIsFaithful where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- १ · The family record.
------------------------------------------------------------------------

record Kula (I : Type ℓ) (X : Type ℓ') (O : I → Type ℓ'')
       : Type (ℓ-max ℓ (ℓ-max ℓ' ℓ'')) where
  field
    dṛś   : (i : I) → X → O i
    andha : (i : I) → Σ[ x ∈ X ] Σ[ y ∈ X ]
              ((x ≡ y → ⊥) × (dṛś i x ≡ dṛś i y))
    yugma : (x y : X) → ((i : I) → dṛś i x ≡ dṛś i y) → x ≡ y

  -- §2 · Every single blindness is jointly seen.
  kula-paśyati : (i : I)
               → ((j : I) → dṛś j (fst (andha i))
                           ≡ dṛś j (fst (snd (andha i))))
               → ⊥
  kula-paśyati i h =
    fst (snd (snd (andha i)))
        (yugma (fst (andha i)) (fst (snd (andha i))) h)

  -- §3 · No member alone is faithful.
  na-ekākin : (i : I)
            → ((x y : X) → dṛś i x ≡ dṛś i y → x ≡ y)
            → ⊥
  na-ekākin i solo =
    fst (snd (snd (andha i)))
        (solo (fst (andha i)) (fst (snd (andha i)))
              (snd (snd (snd (andha i)))))
