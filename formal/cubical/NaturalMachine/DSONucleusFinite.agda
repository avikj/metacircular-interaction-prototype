{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- A finite, checked nucleus seam for DSO.
--
-- The random runtime anchor (batch 02, #6) is a wall/port trace: a state
-- becomes usable only after its boundary coordinate is exposed.  Its exact
-- mathematical residue is a two-boundary cost relation with a retained
-- latent mode.  This module records one saturated rank-one mode.  It does
-- not claim an implementation of arbitrary Isbell completion or a general
-- tropical-rank algorithm.
------------------------------------------------------------------------

module NaturalMachine.DSONucleusFinite where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Sigma using (Σ ; _,_)

-- The finite boundary relation.  It is exactly separable through one mode:
-- K(a,c) = x(a) + y(c), with x = (0,1) and y = (0,1).
K : Bool → Bool → ℕ
K false false = zero
K false true  = suc zero
K true  false = suc zero
K true  true  = suc (suc zero)

x : Bool → ℕ
x false = zero
x true  = suc zero

y : Bool → ℕ
y false = zero
y true  = suc zero

outer : (Bool → ℕ) → (Bool → ℕ) → Bool → Bool → ℕ
outer u v a c = u a + v c

-- The order used by the soundness certificate.
_≤_ : ℕ → ℕ → Type₀
m ≤ n = Σ ℕ (λ k → n ≡ m + k)

rank-one-exact : outer x y ≡ K
rank-one-exact = funExt λ { false → funExt λ { false → refl ; true → refl }
                           ; true  → funExt λ { false → refl ; true → refl } }

-- Finite saturation: every row and column coordinate is tight against the
-- relation.  This is the concrete nucleus condition needed here: neither
-- dual profile can be lowered at any coordinate while preserving K ≤ x+y.
record SaturatedMode : Type₀ where
  constructor mode
  field
    left  : Bool → ℕ
    right : Bool → ℕ
    sound : (a c : Bool) → K a c ≤ (left a + right c)
    row-tight : (a : Bool) → Σ Bool (λ c → K a c ≡ left a + right c)
    col-tight : (c : Bool) → Σ Bool (λ a → K a c ≡ left a + right c)

sat : SaturatedMode
sat = mode x y sound row-tight col-tight
  where
  sound : (a c : Bool) → K a c ≤ (x a + y c)
  sound false false = zero , refl
  sound false true  = zero , refl
  sound true  false = zero , refl
  sound true  true  = zero , refl

  row-tight : (a : Bool) → Σ Bool (λ c → K a c ≡ x a + y c)
  row-tight false = false , refl
  row-tight true  = false , refl

  col-tight : (c : Bool) → Σ Bool (λ a → K a c ≡ x a + y c)
  col-tight false = false , refl
  col-tight true  = false , refl

-- The mode is not merely sound: its lower envelope is exactly the target.
sat-exact : outer (SaturatedMode.left sat) (SaturatedMode.right sat) ≡ K
sat-exact = rank-one-exact

-- The random trace's useful distinction is therefore retained as an explicit
-- intermediate dependency, rather than erased by a row-wise local minimum.
retained-mode : (SaturatedMode.left sat true ≡ suc zero)
retained-mode = refl
