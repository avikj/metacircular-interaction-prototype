-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विप्रकर्ष — dispersion.  The message's climax as a term, and with NO
-- coprimality fence: the joint reciprocal itself supplies the inverse.
--
--   ū₁ − ū₂  ≡  (u₂ − u₁) · w   (mod v),      w = (u₁·u₂)⁻¹ mod v.
--
-- Squaring the reciprocal form in one wall variable produces the phase
-- e(−2ak(ū₁−ū₂)/v); this identity rewrites ū₁−ū₂ as the ADDITIVE
-- displacement h = u₂−u₁ times the joint reciprocal.  Goldbach's additive
-- displacement is regenerated inside the multiplicative reciprocal form —
-- "addition reappears after multiplication is differentiated against
-- itself."  (Owner's dispersion step; exact, no fence.)
--
-- HYPOTHESES (all mod v, as ℤ-divisibilities):
--   h1 : v ∣ (ū₁·u₁ − 1) ;  h2 : v ∣ (ū₂·u₂ − 1) ;  h3 : v ∣ (w·(u₁u₂) − 1).
-- CONCLUSION:  v ∣ ((ū₁ − ū₂) − (u₂ − u₁)·w).
--
-- WHY NO FENCE.  h3 gives w with w·u₁u₂ ≡ 1, so the cancellation of u₁u₂
-- is INTERNAL: v ∣ A·(u₁u₂) plus w·u₁u₂ ≡ 1 give v ∣ A directly.  The
-- inverse being present is exactly what the reciprocal form provides.
--
-- CHECKED under the pin (Agda 2.8.0 + cubical v0.9).
------------------------------------------------------------------------

module Viprakarsa_TheDifferenceOfTwoReciprocalsIsTheAdditiveDisplacementTimesTheJointReciprocal where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ; pos; _+_; -_; _·_)
open import Cubical.Data.Int.Properties using (·IdR)
open import Cubical.Data.Sigma using (Σ; Σ-syntax; _,_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)
open import Ekamula_TheWallOrientationsAreSquareRootsOfOneBuiltFromFactorizationsByTheKloostermanReciprocal
  using (_∣_)

private
  ∣-scale : (m a c : ℤ) → m ∣ a → m ∣ (c · a)
  ∣-scale m a c (k , e) = (c · k) , (cong (c ·_) e ∙ solve! ℤCommRing)

  ∣-+ : (m a b : ℤ) → m ∣ a → m ∣ b → m ∣ (a + b)
  ∣-+ m a b (k , e) (l , f) =
    (k + l) , (cong₂ _+_ e f ∙ solve! ℤCommRing)

module _ (u₁ u₂ ū₁ ū₂ w v : ℤ) where

  A : ℤ
  A = (ū₁ + (- ū₂)) + (- ((u₂ + (- u₁)) · w))

  private
    h1t h2t h3t : ℤ
    h1t = ū₁ · u₁ + (- pos 1)
    h2t = ū₂ · u₂ + (- pos 1)
    h3t = w · (u₁ · u₂) + (- pos 1)

    -- A·(u₁u₂) is an explicit ℤ-combination of the three residues
    -- (constant 1 kept as `one`; the +one·0 bookkeeping cancels).
    prodIsCombo : (one : ℤ)
      → A · (u₁ · u₂)
        ≡ ( u₂ · (ū₁ · u₁ + (- one))
          + ( (- u₁) · (ū₂ · u₂ + (- one))
            + (- (u₂ + (- u₁))) · (w · (u₁ · u₂) + (- one)) ) )
    prodIsCombo one = solve! ℤCommRing

  disp-prod : v ∣ h1t → v ∣ h2t → v ∣ h3t → v ∣ (A · (u₁ · u₂))
  disp-prod h1 h2 h3 =
    subst (v ∣_) (sym (prodIsCombo (pos 1)))
      (∣-+ v (u₂ · h1t) _
         (∣-scale v h1t u₂ h1)
         (∣-+ v ((- u₁) · h2t) ((- (u₂ + (- u₁))) · h3t)
            (∣-scale v h2t (- u₁) h2)
            (∣-scale v h3t (- (u₂ + (- u₁))) h3)))

  -- w·(u₁u₂) ≡ 1 (mod v) cancels u₁u₂ internally: v ∣ A.
  disp : v ∣ h1t → v ∣ h2t → v ∣ h3t → v ∣ A
  disp h1 h2 h3 =
    subst (v ∣_) (sym cancel)
      (∣-+ v (w · (A · (u₁ · u₂))) ((- A) · h3t)
         (∣-scale v (A · (u₁ · u₂)) w (disp-prod h1 h2 h3))
         (∣-scale v h3t (- A) h3))
    where
    -- generic in the unit `one`: the u₁u₂ factors cancel by commutativity,
    -- leaving A·one (valid for ALL one — no predℤ literal in the solver).
    cancelGen : (one : ℤ)
      → w · (A · (u₁ · u₂)) + (- A) · (w · (u₁ · u₂) + (- one)) ≡ A · one
    cancelGen one = solve! ℤCommRing
    cancel : A ≡ w · (A · (u₁ · u₂)) + (- A) · h3t
    cancel = sym (cancelGen (pos 1) ∙ ·IdR A)
