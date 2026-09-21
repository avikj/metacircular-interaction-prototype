{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- संख्या — number, computable.
--
-- The library's integers add and multiply by unary recursion, so a
-- certificate with entries in the thousands cannot be checked by
-- evaluation.  The naturals, by contrast, are Agda builtins backed by
-- machine integers.  This file gives signed integers over the builtin
-- naturals, with the two operations a certificate needs, and proves
-- each sound against the library's ℤ.  The proofs are by induction and
-- never run; the operations run at machine speed.
--
--   §1  THE TYPE: ⁺ n and ⁻ n (denoting n and −n; ⁻ 0 = ⁺ 0 in ℤ).
--   §2  MULTIPLICATION, sound: toℤ (x ⊗ y) ≡ toℤ x · toℤ y.
--   §3  ADDITION, sound: like signs add, unlike signs subtract with the
--       sign decided by a builtin monus.
--
-- संख्या (saṅkhyā, number/count) is ordinary Sanskrit.
------------------------------------------------------------------------

module Sankhya_SignedIntegersOverTheBuiltinNaturalsWithSoundArithmeticIntoTheLibrarysIntegersSoCertificatesComputeAtMachineSpeed where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_ ; snotz ; +-zero ; +-comm ; ·-comm ; 0≡m·0)
open import Cubical.Data.Nat.Order using (_≤_ ; zero-≤ ; suc-≤-suc ; ≤-∸-+-cancel)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
import Cubical.Data.Int as ℤ
open ℤ using (ℤ ; pos ; negsuc ; neg ; sucℤ ; predℤ)

------------------------------------------------------------------------
-- १ · The type.
------------------------------------------------------------------------

data 𝕊 : Type₀ where
  ⁺_ : ℕ → 𝕊
  ⁻_ : ℕ → 𝕊

toℤ : 𝕊 → ℤ
toℤ (⁺ n) = pos n
toℤ (⁻ n) = neg n

------------------------------------------------------------------------
-- २ · Multiplication.
------------------------------------------------------------------------

_⊗_ : 𝕊 → 𝕊 → 𝕊
(⁺ a) ⊗ (⁺ b) = ⁺ (a · b)
(⁺ a) ⊗ (⁻ b) = ⁻ (a · b)
(⁻ a) ⊗ (⁺ b) = ⁻ (a · b)
(⁻ a) ⊗ (⁻ b) = ⁺ (a · b)

-- neg (a · b) ≡ pos a · neg b
pos·neg : (a b : ℕ) → neg (a · b) ≡ pos a ℤ.· neg b
pos·neg a zero    = cong neg (sym (0≡m·0 a)) ∙ sym (ℤ.·AnnihilR (pos a))
pos·neg a (suc b) = sym (ℤ.-pos (a · suc b)) ∙ cong ℤ.-_ (ℤ.pos·pos a (suc b)) ∙ sym (ℤ.pos·negsuc a b)

neg·pos : (a b : ℕ) → neg (a · b) ≡ neg a ℤ.· pos b
neg·pos a b = cong neg (·-comm a b) ∙ pos·neg b a ∙ ℤ.·Comm (pos b) (neg a)

neg·neg : (a b : ℕ) → pos (a · b) ≡ neg a ℤ.· neg b
neg·neg zero    b       = sym (ℤ.·AnnihilL (neg b))
neg·neg (suc a) zero    = cong pos (sym (0≡m·0 (suc a))) ∙ sym (ℤ.·AnnihilR (negsuc a))
neg·neg (suc a) (suc b) = ℤ.pos·pos (suc a) (suc b) ∙ sym (ℤ.negsuc·negsuc a b)

⊗-sama : (x y : 𝕊) → toℤ (x ⊗ y) ≡ toℤ x ℤ.· toℤ y
⊗-sama (⁺ a) (⁺ b) = ℤ.pos·pos a b
⊗-sama (⁺ a) (⁻ b) = pos·neg a b
⊗-sama (⁻ a) (⁺ b) = neg·pos a b
⊗-sama (⁻ a) (⁻ b) = neg·neg a b

------------------------------------------------------------------------
-- ३ · Addition.
------------------------------------------------------------------------

open import Cubical.Algebra.CommRing using (CommRing→Ring)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
import Cubical.Algebra.Ring.Properties as RP

-- a − b as a signed integer, the sign decided by a builtin monus
miśra-go : ℕ → ℕ → ℕ → 𝕊
miśra-go a b zero    = ⁺ (a ∸ b)
miśra-go a b (suc _) = ⁻ (b ∸ a)

miśra : ℕ → ℕ → 𝕊
miśra a b = miśra-go a b (b ∸ a)

_⊕_ : 𝕊 → 𝕊 → 𝕊
(⁺ a) ⊕ (⁺ b) = ⁺ (a + b)
(⁻ a) ⊕ (⁻ b) = ⁻ (a + b)
(⁺ a) ⊕ (⁻ b) = miśra a b
(⁻ a) ⊕ (⁺ b) = miśra b a

-- neg (a + b) ≡ neg a + neg b
neg+ : (a b : ℕ) → neg (a + b) ≡ neg a ℤ.+ neg b
neg+ a b = sym (ℤ.-pos (a + b)) ∙ cong ℤ.-_ (ℤ.pos+ a b) ∙ sym (RP.RingTheory.-Dist (CommRing→Ring ℤCommRing) (pos a) (pos b))
         ∙ cong₂ ℤ._+_ (ℤ.-pos a) (ℤ.-pos b)

-- monus zero means ≤; monus successor means the other ≤
∸-śūnya : (a b : ℕ) → b ∸ a ≡ zero → b ≤ a
∸-śūnya a       zero    _ = zero-≤
∸-śūnya zero    (suc b) e = ⊥-elim (snotz e)
∸-śūnya (suc a) (suc b) e = suc-≤-suc (∸-śūnya a b e)

∸-suc : (a b k : ℕ) → b ∸ a ≡ suc k → a ≤ b
∸-suc zero    b       k _ = zero-≤
∸-suc (suc a) zero    k e = ⊥-elim (snotz (sym e))
∸-suc (suc a) (suc b) k e = suc-≤-suc (∸-suc a b k e)

-- pos (a ∸ b) ≡ pos a − pos b for b ≤ a
pos∸ : (a b : ℕ) → b ≤ a → pos (a ∸ b) ≡ pos a ℤ.- pos b
pos∸ a b le =
    sym (ℤ.plusMinus (pos b) (pos (a ∸ b)))
  ∙ cong (ℤ._- pos b) (sym (ℤ.pos+ (a ∸ b) b) ∙ cong pos (≤-∸-+-cancel le))

-- neg (b ∸ a) ≡ pos a − pos b for a ≤ b
neg∸ : (a b : ℕ) → a ≤ b → neg (b ∸ a) ≡ pos a ℤ.- pos b
neg∸ a b le =
    sym (ℤ.plusMinus (pos b) (neg (b ∸ a)))
  ∙ cong (ℤ._- pos b) lemma
  where
  -- neg (b ∸ a) + pos b ≡ pos a
  lemma : neg (b ∸ a) ℤ.+ pos b ≡ pos a
  lemma = cong (neg (b ∸ a) ℤ.+_) (cong pos (sym (≤-∸-+-cancel le)) ∙ ℤ.pos+ (b ∸ a) a)
        ∙ ℤ.+Assoc (neg (b ∸ a)) (pos (b ∸ a)) (pos a)
        ∙ cong (ℤ._+ pos a) (cong (ℤ._+ pos (b ∸ a)) (sym (ℤ.-pos (b ∸ a))) ∙ ℤ.-Cancel' (pos (b ∸ a)))
        ∙ sym (ℤ.pos0+ (pos a))

miśra-go-sama : (a b d : ℕ) → b ∸ a ≡ d → toℤ (miśra-go a b d) ≡ pos a ℤ.+ neg b
miśra-go-sama a b zero    eq = pos∸ a b (∸-śūnya a b eq) ∙ cong (pos a ℤ.+_) (ℤ.-pos b)
miśra-go-sama a b (suc k) eq = neg∸ a b (∸-suc a b k eq) ∙ cong (pos a ℤ.+_) (ℤ.-pos b)

miśra-sama : (a b : ℕ) → toℤ (miśra a b) ≡ pos a ℤ.+ neg b
miśra-sama a b = miśra-go-sama a b (b ∸ a) refl

⊕-sama : (x y : 𝕊) → toℤ (x ⊕ y) ≡ toℤ x ℤ.+ toℤ y
⊕-sama (⁺ a) (⁺ b) = ℤ.pos+ a b
⊕-sama (⁻ a) (⁻ b) = neg+ a b
⊕-sama (⁺ a) (⁻ b) = miśra-sama a b
⊕-sama (⁻ a) (⁺ b) = miśra-sama b a ∙ ℤ.+Comm (pos b) (neg a)
