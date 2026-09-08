{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- विस्तार — the dilation.
--
-- Handoff §33 ([S13]): the exact energy-neutral adaptive dilation has
-- generator  D_E = 3/5 + (2/5) y·∇ = (2/5)(y·∇ + 3/2),  which is skew
-- in L² because
--
--     (y·∇f) g + f (y·∇g) + 3 f g  =  div(y f g)
--
-- is an exact divergence: integrated over ℝ³ it vanishes, so
-- ⟨(y·∇ + 3/2)f, g⟩ + ⟨f, (y·∇ + 3/2)g⟩ = 0.  The identity is checked
-- over any commutative ring with three derivations ∂ᵢ and coordinates
-- yᵢ with ∂ᵢ yᵢ = 1 (only the diagonal derivatives enter).
------------------------------------------------------------------------
module Vistara_TheDilationGeneratorPlusThreeHalvesIsSkewBecauseItsSymmetricPartOnAProductIsAnExactDivergence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A = ⟨ R ⟩

  ι : ℕ → A
  ι zero    = 0r
  ι (suc n) = 1r + ι n

  module _ (∂₁ ∂₂ ∂₃ : A → A)
           (∂₁-leib : (x y : A) → ∂₁ (x · y) ≡ ∂₁ x · y + x · ∂₁ y)
           (∂₂-leib : (x y : A) → ∂₂ (x · y) ≡ ∂₂ x · y + x · ∂₂ y)
           (∂₃-leib : (x y : A) → ∂₃ (x · y) ≡ ∂₃ x · y + x · ∂₃ y)
           (y₁ y₂ y₃ : A)
           (∂₁y₁ : ∂₁ y₁ ≡ 1r) (∂₂y₂ : ∂₂ y₂ ≡ 1r) (∂₃y₃ : ∂₃ y₃ ≡ 1r)
           where

    -- y·∇
    Y : A → A
    Y f = (y₁ · ∂₁ f + y₂ · ∂₂ f) + y₃ · ∂₃ f

    -- div(y h)
    div-y : A → A
    div-y h = (∂₁ (y₁ · h) + ∂₂ (y₂ · h)) + ∂₃ (y₃ · h)

    -- (y·∇f) g + f (y·∇g) + 3 f g  ≡  div(y f g)
    symmetric-part-is-exact : (f g : A) → (Y f · g + f · Y g) + ι 3 · (f · g) ≡ div-y (f · g)
    symmetric-part-is-exact f g =
        sym ( cong₂ _+_ (cong₂ _+_ (∂₁-leib y₁ (f · g) ∙ cong₂ _+_ (cong (_· (f · g)) ∂₁y₁) (cong (y₁ ·_) (∂₁-leib f g)))
                                   (∂₂-leib y₂ (f · g) ∙ cong₂ _+_ (cong (_· (f · g)) ∂₂y₂) (cong (y₂ ·_) (∂₂-leib f g))))
                        (∂₃-leib y₃ (f · g) ∙ cong₂ _+_ (cong (_· (f · g)) ∂₃y₃) (cong (y₃ ·_) (∂₃-leib f g)))
            ∙ shape f g (∂₁ f) (∂₂ f) (∂₃ f) (∂₁ g) (∂₂ g) (∂₃ g) )
      where
        shape : (f g f₁ f₂ f₃ g₁ g₂ g₃ : A)
          → ((1r · (f · g) + y₁ · (f₁ · g + f · g₁)) + (1r · (f · g) + y₂ · (f₂ · g + f · g₂))) + (1r · (f · g) + y₃ · (f₃ · g + f · g₃))
            ≡ ((((y₁ · f₁ + y₂ · f₂) + y₃ · f₃) · g + f · ((y₁ · g₁ + y₂ · g₂) + y₃ · g₃)) + (1r + (1r + (1r + 0r))) · (f · g))
        shape f g f₁ f₂ f₃ g₁ g₂ g₃ = solve! R

    -- the generator:  5·D_E f = 3f + 2 y·∇f = 2 (y·∇ + 3/2) f
    generator : (f : A) → ι 3 · f + ι 2 · Y f ≡ ι 2 · Y f + ι 3 · f
    generator f = +Comm _ _
