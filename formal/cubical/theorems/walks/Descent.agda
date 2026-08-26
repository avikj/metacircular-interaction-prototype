{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- The descent law.
--
--   f factors through q  ⟺  f is constant on the fibers of q.
--
-- This is the statement the rest of the machine is a special case of:
-- an invariant is well defined on a quotient exactly when it cannot
-- tell apart two things the quotient identifies.  Everything the
-- repository calls a "certificate that X descends" is an inhabitant of
-- `Factors`, and everything it calls "X carries no information beyond
-- the quotient" is an inhabitant of `ConstantOnFibers`.  The theorem
-- below says the two are the same type, up to equivalence, whenever the
-- target is a set and q is surjective — and that under those same
-- hypotheses the factorisation is unique, so the certificate has no
-- content beyond its existence.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Descent where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Function
open import Cubical.Data.Sigma
open import Cubical.Functions.Surjection
open import Cubical.HITs.PropositionalTruncation as PT

private
  variable
    ℓ ℓ' ℓ'' : Level

module _ {A : Type ℓ} {B : Type ℓ'} {C : Type ℓ''} where

  -- f factors through q: a g on the quotient side with g ∘ q = f.
  Factors : (A → B) → (A → C) → Type (ℓ-max ℓ (ℓ-max ℓ' ℓ''))
  Factors q f = Σ[ g ∈ (B → C) ] ((a : A) → g (q a) ≡ f a)

  -- f is constant on the fibers of q.
  ConstantOnFibers : (A → B) → (A → C) → Type (ℓ-max ℓ (ℓ-max ℓ' ℓ''))
  ConstantOnFibers q f = (a a' : A) → q a ≡ q a' → f a ≡ f a'

  -- One direction is unconditional.
  factors→constant : (q : A → B) (f : A → C)
                   → Factors q f → ConstantOnFibers q f
  factors→constant q f (g , p) a a' e = sym (p a) ∙ cong g e ∙ p a'

  module _ (isSetC : isSet C) (q : A → B) (surj : isSurjection q) where

    -- The other direction needs a choice of preimage, which is exactly
    -- what constancy on fibers makes unnecessary: the value is
    -- 2-constant on the fiber, so it descends through the truncation.
    constant→factors : (f : A → C) → ConstantOnFibers q f → Factors q f
    constant→factors f c = g , gq
      where
        val : (b : B) → fiber q b → C
        val b w = f (w .fst)

        val2 : (b : B) → (w w' : fiber q b) → val b w ≡ val b w'
        val2 b w w' = c (w .fst) (w' .fst) (w .snd ∙ sym (w' .snd))

        g : B → C
        g b = PT.rec→Set isSetC (val b) (val2 b) (surj b)

        gq : (a : A) → g (q a) ≡ f a
        gq a = cong (PT.rec→Set isSetC (val (q a)) (val2 (q a)))
                    (squash₁ (surj (q a)) ∣ a , refl ∣₁)

    -- Under the same hypotheses the factorisation is unique, so
    -- `Factors` is a proposition: producing one is producing the only
    -- one there is.
    isPropFactors : (f : A → C) → isProp (Factors q f)
    isPropFactors f (g , p) (g' , p') =
      Σ≡Prop (λ _ → isPropΠ λ _ → isSetC _ _) (funExt pointwise)
      where
        pointwise : (b : B) → g b ≡ g' b
        pointwise b =
          PT.rec (isSetC _ _)
                 (λ w → cong g (sym (w .snd)) ∙ p (w .fst)
                      ∙ sym (p' (w .fst)) ∙ cong g' (w .snd))
                 (surj b)

    isPropConstantOnFibers : (f : A → C) → isProp (ConstantOnFibers q f)
    isPropConstantOnFibers f =
      isPropΠ3 λ _ _ _ → isSetC _ _

    -- The descent law.
    descent : (f : A → C) → Factors q f ≃ ConstantOnFibers q f
    descent f =
      propBiimpl→Equiv (isPropFactors f) (isPropConstantOnFibers f)
                       (factors→constant q f) (constant→factors f)
