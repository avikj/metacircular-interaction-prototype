-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ModeAdjointFinitenessBoundary
--
-- Swarm.S02ModeAdjoint defines admissible transfers over an arbitrary
-- meet-semilattice with top.  Its accompanying prose identifies admissible
-- transfers with right adjoints only in the finite case.  This leaf checks
-- the exact boundary:
--
--   * every proof-relevant order adjunction gives an admissible transfer;
--   * S02's three-chain threshold has an explicit left adjoint;
--   * under S02's unrestricted hypotheses the converse fails: constant TOP is
--     admissible on (Nat,max,0), but has no left adjoint.
------------------------------------------------------------------------

module ModeAdjointFinitenessBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; max ; maxComm ; znots ; injSuc)
open import Cubical.Relation.Nullary using (¬_)

import Swarm.S02ModeAdjoint as S02

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1. A typed adjunction on the meet-induced order.
------------------------------------------------------------------------

module AdjointBoundary
  {S : Type ℓ}
  (_∧_     : S → S → S)
  (TOP     : S)
  (∧-idem  : (a : S) → a ∧ a ≡ a)
  (∧-comm  : (a b : S) → a ∧ b ≡ b ∧ a)
  (∧-assoc : (a b c : S) → (a ∧ b) ∧ c ≡ a ∧ (b ∧ c))
  (∧-unit  : (a : S) → TOP ∧ a ≡ a)
  where

  module Modes =
    S02.Modes _∧_ TOP ∧-idem ∧-comm ∧-assoc ∧-unit

  infix 4 _≤∧_

  _≤∧_ : S → S → Type ℓ
  x ≤∧ y = x ∧ y ≡ x

  -- A proof-relevant Galois adjunction.  No proposition truncation or
  -- antisymmetry record is hidden in the definition.
  Adjunction : (S → S) → (S → S) → Type ℓ
  Adjunction left right =
    (x y : S) →
      ((left x ≤∧ y → x ≤∧ right y)
      × (x ≤∧ right y → left x ≤∧ y))

  RightAdjoint : (S → S) → Type ℓ
  RightAdjoint right = Σ[ left ∈ (S → S) ] Adjunction left right

  ≤∧-refl : (x : S) → x ≤∧ x
  ≤∧-refl = ∧-idem

  ≤∧-top : (x : S) → x ≤∧ TOP
  ≤∧-top = Modes.∧-unitR

  ≤∧-trans : {x y z : S} → x ≤∧ y → y ≤∧ z → x ≤∧ z
  ≤∧-trans {x} {y} {z} xy yz =
      cong (_∧ z) (sym xy)
    ∙ ∧-assoc x y z
    ∙ cong (x ∧_) yz
    ∙ xy

  ≤∧-antisym : {x y : S} → x ≤∧ y → y ≤∧ x → x ≡ y
  ≤∧-antisym {x} {y} xy yx =
    sym xy ∙ ∧-comm x y ∙ yx

  meet≤-left : (x y : S) → (x ∧ y) ≤∧ x
  meet≤-left x y =
      ∧-assoc x y x
    ∙ cong (x ∧_) (∧-comm y x)
    ∙ sym (∧-assoc x x y)
    ∙ cong (_∧ y) (∧-idem x)

  meet≤-right : (x y : S) → (x ∧ y) ≤∧ y
  meet≤-right x y =
    ∧-assoc x y y ∙ cong (x ∧_) (∧-idem y)

  lower≤-meet : {w x y : S} → w ≤∧ x → w ≤∧ y → w ≤∧ (x ∧ y)
  lower≤-meet {w} {x} {y} wx wy =
    sym (∧-assoc w x y) ∙ cong (_∧ y) wx ∙ wy

  right-monotone : {left right : S → S}
    → Adjunction left right
    → {x y : S} → x ≤∧ y → right x ≤∧ right y
  right-monotone {left} {right} adj {x} {y} xy =
    adj (right x) y .fst
      (≤∧-trans (adj (right x) x .snd (≤∧-refl (right x))) xy)

  right-preserves-top : {left right : S → S}
    → Adjunction left right
    → Modes.PresTOP right
  right-preserves-top {left} {right} adj =
    ≤∧-antisym
      (≤∧-top (right TOP))
      (adj TOP TOP .fst (≤∧-top (left TOP)))

  right-preserves-meet : {left right : S → S}
    → Adjunction left right
    → Modes.Pres∧ right
  right-preserves-meet {left} {right} adj x y =
    ≤∧-antisym forward reverse
    where
      forward : right (x ∧ y) ≤∧ (right x ∧ right y)
      forward =
        lower≤-meet
          (right-monotone adj (meet≤-left x y))
          (right-monotone adj (meet≤-right x y))

      reverse : (right x ∧ right y) ≤∧ right (x ∧ y)
      reverse = adj (right x ∧ right y) (x ∧ y) .fst
        (lower≤-meet
          (adj (right x ∧ right y) x .snd (meet≤-left (right x) (right y)))
          (adj (right x ∧ right y) y .snd (meet≤-right (right x) (right y))))

  right-adjoint→Adm : {right : S → S}
    → RightAdjoint right
    → Modes.Adm right
  right-adjoint→Adm (left , adj) =
    right-preserves-meet adj , right-preserves-top adj

------------------------------------------------------------------------
-- 2. Positive finite control: S02's threshold has a left adjoint.
------------------------------------------------------------------------

module ThreeAdjoint =
  AdjointBoundary S02._∧₃_ S02.top S02.∧₃-idem S02.∧₃-comm
                  S02.∧₃-assoc S02.∧₃-unit

θ-left : S02.Three → S02.Three
θ-left S02.bot = S02.bot
θ-left S02.mid = S02.mid
θ-left S02.top = S02.mid

θ-adjunction : ThreeAdjoint.Adjunction θ-left S02.θ
θ-adjunction S02.bot _ = (λ _ → refl) , (λ _ → refl)
θ-adjunction S02.mid S02.bot = (λ p → p) , (λ p → p)
θ-adjunction S02.mid S02.mid = (λ _ → refl) , (λ _ → refl)
θ-adjunction S02.mid S02.top = (λ _ → refl) , (λ _ → refl)
θ-adjunction S02.top S02.bot =
  (λ p → ⊥rec (S02.decode p)) , (λ p → ⊥rec (S02.decode p))
θ-adjunction S02.top S02.mid = (λ _ → refl) , (λ _ → refl)
θ-adjunction S02.top S02.top = (λ _ → refl) , (λ _ → refl)

θ-right-adjoint : ThreeAdjoint.RightAdjoint S02.θ
θ-right-adjoint = θ-left , θ-adjunction

θ-adm-from-adjunction : S02.M3.Adm S02.θ
θ-adm-from-adjunction = ThreeAdjoint.right-adjoint→Adm θ-right-adjoint

------------------------------------------------------------------------
-- 3. Infinite hostile control: admissible need not mean right adjoint.
------------------------------------------------------------------------

max-idem : (n : ℕ) → max n n ≡ n
max-idem zero = refl
max-idem (suc n) = cong suc (max-idem n)

max-assoc : (a b c : ℕ) → max (max a b) c ≡ max a (max b c)
max-assoc zero b c = refl
max-assoc (suc a) zero c = refl
max-assoc (suc a) (suc b) zero = refl
max-assoc (suc a) (suc b) (suc c) = cong suc (max-assoc a b c)

max-unit : (n : ℕ) → max zero n ≡ n
max-unit _ = refl

module NatModes =
  S02.Modes max zero max-idem maxComm max-assoc max-unit

module NatAdjoint =
  AdjointBoundary max zero max-idem maxComm max-assoc max-unit

nat-constTop-adm : NatModes.Adm NatModes.constTop
nat-constTop-adm = NatModes.constTop-Adm

self≢suc : (n : ℕ) → ¬ (n ≡ suc n)
self≢suc zero = znots
self≢suc (suc n) p = self≢suc n (injSuc p)

max-self-suc : (n : ℕ) → max n (suc n) ≡ suc n
max-self-suc zero = refl
max-self-suc (suc n) = cong suc (max-self-suc n)

-- If constant zero had a left adjoint, the adjunction at x=0 and
-- y=suc(left 0) would say every natural is bounded by left 0 in the usual
-- order.  The next natural gives the contradiction.
nat-constTop-no-right-adjoint :
  ¬ NatAdjoint.RightAdjoint NatModes.constTop
nat-constTop-no-right-adjoint (left , adj) =
  self≢suc (left zero) (sym forced ∙ max-self-suc (left zero))
  where
    forced : max (left zero) (suc (left zero)) ≡ left zero
    forced = adj zero (suc (left zero)) .snd refl

adm-without-right-adjoint :
  NatModes.Adm NatModes.constTop
  × (¬ NatAdjoint.RightAdjoint NatModes.constTop)
adm-without-right-adjoint =
  nat-constTop-adm , nat-constTop-no-right-adjoint
