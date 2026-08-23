{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TransportMulWitness
--
-- The digit multiplier of `NaturalMachine.TransportMul`, RUNNING, at
-- base 10, on words written directly as digit strings — no `digitsC`
-- anywhere, so no unary detour inside the computation.
--
-- Words are little-endian (head = least significant digit), so 99 is
-- `d9 ∷ d9 ∷ []` and 9801 is `d1 ∷ d0 ∷ d8 ∷ d9 ∷ []`.
--
-- A digit is an element of `Fin 10 = Σ[ i ∈ ℕ ] (i < 10)`, and in
-- cubical `i < n` unfolds to `Σ[ j ∈ ℕ ] j + suc i ≡ n`, so the second
-- component of `dᵢ` is the numeral `9 − i` and the third is `refl`.
-- Writing the bound out is not noise: it is the reason `Fin` needs no
-- indexed matching here (see WalkCapacity's recorded constraint).
--
-- These are `refl`.  The kernel carries the ripple and the shift.  That
-- is the difference between a theorem about a chart and a chart one can
-- compute in — and computing in the chart is what the walk needs if it
-- is ever to run past frontier 8 (see TransportMul's header for why
-- that wall is the capacity theorem rather than a hardware limit).
--
-- CHECKED: Agda 2.6.3, cubical v0.5, --cubical --safe, 2026-08-14.
-- No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TransportMulWitness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_,_)

open import NaturalMachine.Digits 8 using (Word ; Digit ; value ; b)
open import NaturalMachine.TransportMul 8 using (mulw ; shiftw ; repAdd)

base-is-10 : b ≡ 10
base-is-10 = refl

d0 d1 d2 d4 d5 d6 d7 d8 d9 : Digit
d0 = 0 , 9 , refl
d1 = 1 , 8 , refl
d2 = 2 , 7 , refl
d4 = 4 , 5 , refl
d5 = 5 , 4 , refl
d6 = 6 , 3 , refl
d7 = 7 , 2 , refl
d8 = 8 , 1 , refl
d9 = 9 , 0 , refl

------------------------------------------------------------------------
-- The multiplier runs.
------------------------------------------------------------------------

-- 99 × 99 = 9801, entirely on digit strings: two shifts and four ripples
mul-99-99 : mulw (d9 ∷ d9 ∷ []) (d9 ∷ d9 ∷ [])
          ≡ (d1 ∷ d0 ∷ d8 ∷ d9 ∷ [])
mul-99-99 = refl

-- 7 × 8 = 56: a single column with a carry out
mul-7-8 : mulw (d7 ∷ []) (d8 ∷ []) ≡ (d6 ∷ d5 ∷ [])
mul-7-8 = refl

-- 0 × anything is the empty word, not a word of zeros: canonicity holds
-- on the nose rather than up to normalisation
mul-0 : mulw [] (d9 ∷ d9 ∷ []) ≡ []
mul-0 = refl

-- scaling by one digit is repeated ripple: 3 × 24 = 72
scale-3-24 : repAdd 3 (d4 ∷ d2 ∷ []) ≡ (d2 ∷ d7 ∷ [])
scale-3-24 = refl

-- multiplication by the base is a shift, with no arithmetic at all
shift-347 : shiftw (d7 ∷ d4 ∷ d1 ∷ []) ≡ (d0 ∷ d7 ∷ d4 ∷ d1 ∷ [])
shift-347 = refl

------------------------------------------------------------------------
-- and the chart map agrees with ℕ on what was computed
------------------------------------------------------------------------

value-of-9801 : value (d1 ∷ d0 ∷ d8 ∷ d9 ∷ []) ≡ 9801
value-of-9801 = refl

value-of-product : value (mulw (d9 ∷ d9 ∷ []) (d9 ∷ d9 ∷ [])) ≡ 9801
value-of-product = refl

------------------------------------------------------------------------
-- The same multiplier at a DIFFERENT base, since the module is
-- parameterised and an instantiation at one base proves nothing about
-- the parameter.  Base 2: digits are `Fin 2`, and 3 × 3 = 9 reads
-- 1001₂, i.e. `1 ∷ 0 ∷ 0 ∷ 1 ∷ []` little-endian.
------------------------------------------------------------------------

module Base2 where
  open import NaturalMachine.Digits 0 using () renaming (Digit to Bit ; value to value₂ ; b to b₂)
  open import NaturalMachine.TransportMul 0 using () renaming (mulw to mulw₂ ; shiftw to shiftw₂)

  base-is-2 : b₂ ≡ 2
  base-is-2 = refl

  z o : Bit
  z = 0 , 1 , refl
  o = 1 , 0 , refl

  -- 3 × 3 = 9
  mul-3-3 : mulw₂ (o ∷ o ∷ []) (o ∷ o ∷ []) ≡ (o ∷ z ∷ z ∷ o ∷ [])
  mul-3-3 = refl

  -- doubling is a shift, in every base
  double-5 : shiftw₂ (o ∷ z ∷ o ∷ []) ≡ (z ∷ o ∷ z ∷ o ∷ [])
  double-5 = refl

  value-of-9 : value₂ (o ∷ z ∷ z ∷ o ∷ []) ≡ 9
  value-of-9 = refl
