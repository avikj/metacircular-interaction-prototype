{-# OPTIONS --cubical --safe #-}

-- Minimal surface/intersection seam for finite graph holonomy--flux data.
-- A subdivision vertex is assumed off the surface: a coarse transverse
-- crossing is inherited by exactly one child edge.  This is not the concrete
-- SU(2) holonomy--flux algebra; no invariant vector fields, domains, or
-- geometric operators are asserted.

module NaturalMachine.OrientedSurfaceFlux where

open import Cubical.Foundations.Prelude

private variable ℓ : Level

data Sign : Type where
  neg zero pos : Sign

reverseSign : Sign → Sign
reverseSign neg = pos
reverseSign zero = zero
reverseSign pos = neg

reverseSign-involutive : (s : Sign) → reverseSign (reverseSign s) ≡ s
reverseSign-involutive neg = refl
reverseSign-involutive zero = refl
reverseSign-involutive pos = refl

-- The admissible intersection patterns for subdividing away from a surface.
-- This deliberately excludes a newly inserted vertex on the surface and a
-- coarse edge whose two children are both independently transverse.
data SignedSplit : Sign → Sign → Sign → Type where
  miss     : SignedSplit zero zero zero
  posFirst : SignedSplit pos pos zero
  posLast  : SignedSplit pos zero pos
  negFirst : SignedSplit neg neg zero
  negLast  : SignedSplit neg zero neg

reverseSplit : {s s₀ s₁ : Sign}
  → SignedSplit s s₀ s₁
  → SignedSplit (reverseSign s) (reverseSign s₀) (reverseSign s₁)
reverseSplit miss = miss
reverseSplit posFirst = negFirst
reverseSplit posLast = negLast
reverseSplit negFirst = posFirst
reverseSplit negLast = posLast

-- Abstract target of a signed flux insertion.  `positive` is the only
-- primitive action; negative orientation is constructed by `negate`.
record SignedFluxTarget (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    Carrier : Type ℓ
    neutral : Carrier
    _⊕_ : Carrier → Carrier → Carrier
    negate : Carrier → Carrier
    positive : Carrier → Carrier
    left-neutral : (x : Carrier) → neutral ⊕ x ≡ x
    right-neutral : (x : Carrier) → x ⊕ neutral ≡ x
    negate-neutral : negate neutral ≡ neutral
    negate-involutive : (x : Carrier) → negate (negate x) ≡ x

open SignedFluxTarget

signedFlux : (F : SignedFluxTarget ℓ) → Sign → Carrier F → Carrier F
signedFlux F neg x = negate F (positive F x)
signedFlux F zero x = neutral F
signedFlux F pos x = positive F x

-- Reversing edge orientation flips the signed action.  The zero case uses
-- preservation of the neutral insertion; the negative case uses involution.
orientation-reversal : (F : SignedFluxTarget ℓ) (s : Sign) (x : Carrier F)
  → signedFlux F (reverseSign s) x ≡ negate F (signedFlux F s x)
orientation-reversal F neg x = sym (negate-involutive F (positive F x))
orientation-reversal F zero x = sym (negate-neutral F)
orientation-reversal F pos x = refl

-- Cylindrical consistency of the signed sum: the coarse contribution equals
-- the sum of child contributions for every admissible off-surface split.
signed-subdivision : (F : SignedFluxTarget ℓ)
  {s s₀ s₁ : Sign} → SignedSplit s s₀ s₁ → (x : Carrier F)
  → signedFlux F s x
    ≡ _⊕_ F (signedFlux F s₀ x) (signedFlux F s₁ x)
signed-subdivision F miss x = sym (left-neutral F (neutral F))
signed-subdivision F posFirst x = sym (right-neutral F (positive F x))
signed-subdivision F posLast x = sym (left-neutral F (positive F x))
signed-subdivision F negFirst x =
  sym (right-neutral F (negate F (positive F x)))
signed-subdivision F negLast x =
  sym (left-neutral F (negate F (positive F x)))

-- Reversal commutes with the admissible subdivision classification itself.
-- Applying `signed-subdivision` to this witness gives the reversed-edge law
-- without an independent cylindrical axiom.
reversed-subdivision : (F : SignedFluxTarget ℓ)
  {s s₀ s₁ : Sign} (split : SignedSplit s s₀ s₁) (x : Carrier F)
  → signedFlux F (reverseSign s) x
    ≡ _⊕_ F (signedFlux F (reverseSign s₀) x)
              (signedFlux F (reverseSign s₁) x)
reversed-subdivision F split x = signed-subdivision F (reverseSplit split) x

