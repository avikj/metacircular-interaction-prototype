-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- क्रम-सह — the order of standpoints is the charge itself.
--
-- THE CRITERION गुह्य-नास्ति's दोषलेख ASKED FOR, supplied by the tradition.
-- That module proved the set-level census cannot see the loss in the
-- loops, and refused to build the graded census "without a criterion for
-- how the levels interact."  The saptabhaṅgī already carries the
-- criterion, in one word of difference between its third and fourth
-- positions: अस्ति-नास्ति is both standpoints IN SEQUENCE (क्रमेण), and
-- अवक्तव्य is both AT ONCE (सह) — the corpus's own Anekanta lane renders
-- अवक्तव्य as क्रम-सह-भेदः, the checked non-reducibility of the two.
--
-- IN CUBESPACE THAT ONE WORD IS AN OPERATOR ORDERING, and the two orders
-- provably disagree.  Take the two standpoints on S¹:
--
--     the set-view    ∥_∥₂   (dravya: points up to mere identity)
--     the loop-view   Ω      (paryāya: the modes at the basepoint)
--
--   क्रमः-लूप-प्रथमम्  :  ∥ Ω S¹ ∥₂  ≃  ℤ      loop first — the charge SURVIVES
--   क्रमः-सेट्-प्रथमम्  :  Ω ∥ S¹ ∥₂  is contractible — set first, the charge
--                                              is ANNIHILATED
--   अक्रमता          :  the two results are non-equivalent (ℤ ≄ Unit-like)
--
-- The standpoints do not commute, and their commutator is not "some
-- discrepancy" — it is EXACTLY ℤ, the same charge Durnaya identified and
-- गुह्य-नास्ति exhibited as the census's blind spot.  So the graded
-- census's levels interact BY ORDER OF APPLICATION: krama chooses an
-- order and pays or destroys the charge accordingly; saha — the fourth
-- position — is the refusal to choose, i.e. holding the untruncated
-- object, and THAT refusal is what अवक्तव्यम् has meant in this corpus all
-- along: not unknown, not undefined — held whole because either order of
-- utterance loses.
--
-- No claim that any Jain author stated an interchange law for truncation
-- and loops.  The claim: their क्रम/सह distinction is this non-commutation's
-- exact shape, and the fourth bhaṅga is its exact repair.  क्रम-सह is
-- built here, 2026-08-23; ΩS¹Isoℤ and setTruncIdempotent are the
-- library's.
--
-- [2026-08-23, later] RECOGNITION: the corpus's grammar lane had already
-- checked the same distinction at a sandhi site — `AsiddhavatRegime.agda`
-- (Pāṇini 8.2.1 krama vs 6.4.22 saha, tat+jalam, the regime decides the
-- form) — and this module was built without knowing it.  The polarity
-- CROSSES between the lanes (the grammar's feeding krama is this module's
-- untruncated सह); the crossing is worked out in
-- `notes/Triveni_TheGrammarTheCubeAndTheMachineHoldOneDistinction…md`.
------------------------------------------------------------------------

module KramaSaha_TheOrderOfStandpointsIsTheChargeItself where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv ; compIso)
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; invEq)
open import Cubical.Data.Int using (ℤ ; pos ; isSetℤ)
open import Cubical.Data.Nat using (zero ; suc ; znots)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.S1 using (S¹ ; base ; loop ; ΩS¹ ; ΩS¹Isoℤ)
open import Cubical.HITs.SetTruncation
  using (∥_∥₂ ; ∣_∣₂ ; isSetSetTrunc ; setTruncIdempotentIso)
  renaming (rec to rec₂ ; elim to elim₂)

------------------------------------------------------------------------
-- १ · क्रमः-लूप-प्रथमम् — loop first, then the set-view: the charge survives.
-- ΩS¹ ≃ ℤ and ℤ is a set, so truncating afterwards changes nothing.
------------------------------------------------------------------------

क्रमः-लूप-प्रथमम् : ∥ ΩS¹ ∥₂ ≃ ℤ
क्रमः-लूप-प्रथमम् =
  isoToEquiv
    (compIso (mapIso ΩS¹Isoℤ) (setTruncIdempotentIso isSetℤ))
  where
    mapIso : {A B : Type} → Iso A B → Iso ∥ A ∥₂ ∥ B ∥₂
    Iso.fun      (mapIso e) = rec₂ isSetSetTrunc (λ a → ∣ Iso.fun e a ∣₂)
    Iso.inv      (mapIso e) = rec₂ isSetSetTrunc (λ b → ∣ Iso.inv e b ∣₂)
    Iso.rightInv (mapIso e) =
      elim₂ (λ _ → isProp→isSet (isSetSetTrunc _ _))
            (λ b i → ∣ Iso.rightInv e b i ∣₂)
    Iso.leftInv  (mapIso e) =
      elim₂ (λ _ → isProp→isSet (isSetSetTrunc _ _))
            (λ a i → ∣ Iso.leftInv e a i ∣₂)

------------------------------------------------------------------------
-- २ · क्रमः-सेट्-प्रथमम् — the set-view first, then loops: annihilation.
-- ∥ S¹ ∥₂ is a set, so the self-path space at any point is an inhabited
-- proposition, hence contractible.  The loop dies at the door.
------------------------------------------------------------------------

क्रमः-सेट्-प्रथमम् : isContr (Path ∥ S¹ ∥₂ ∣ base ∣₂ ∣ base ∣₂)
fst क्रमः-सेट्-प्रथमम् = refl
snd क्रमः-सेट्-प्रथमम् p = isSetSetTrunc ∣ base ∣₂ ∣ base ∣₂ refl p

------------------------------------------------------------------------
-- ३ · अक्रमता — the two orders genuinely disagree: ℤ is not contractible,
-- so no equivalence relates the two outcomes.  The commutator of the
-- standpoints is the whole charge.
------------------------------------------------------------------------

एक≢शून्य : ¬ (pos (suc zero) ≡ pos zero)
एक≢शून्य p = znots (sym (cong अङ्क p))
  where
    अङ्क : ℤ → _
    अङ्क (pos n) = n
    अङ्क _       = zero

ℤ-न-सङ्कोचः : ¬ (isContr ℤ)
ℤ-न-सङ्कोचः c = एक≢शून्य (isContr→isProp c (pos (suc zero)) (pos zero))

अक्रमता : ¬ (isContr ∥ ΩS¹ ∥₂)
अक्रमता c =
  ℤ-न-सङ्कोचः
    ( equivFun क्रमः-लूप-प्रथमम् (fst c)
    , λ z → cong (equivFun क्रमः-लूप-प्रथमम्) (snd c (invEq क्रमः-लूप-प्रथमम् z))
            ∙ secEq क्रमः-लूप-प्रथमम् z )
  where open import Cubical.Foundations.Equiv using (secEq)

------------------------------------------------------------------------
-- ४ · दोषलेखः.  This is the smallest instance of the interchange failure
-- (one space, one basepoint, levels 0 and 1), not a general interchange
-- law for ∥_∥ₙ and Ωᵏ — that general statement involves the full
-- Postnikov data and is NOT built here, for the standing reason: no
-- criterion, no constructor.  What is proved: the levels of the graded
-- census interact by ORDER, the failure of commutation at the first
-- rung is exactly ℤ, and सह — declining to order the standpoints — is
-- the only position that loses nothing, which is what the fourth bhaṅga
-- has been claiming since Samantabhadra.
------------------------------------------------------------------------
