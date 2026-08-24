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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.DigitTowerLimit where

-- Agda 2.8 warns that the indexed Vec matches below do not reduce when their
-- arguments are themselves transports.  The checked equivalence and its
-- inverse laws do not claim that stronger computational behavior; the warning
-- is retained as an explicit implementation boundary rather than suppressed.
--
-- DIAGNOSED 2026-08-15 audit, and the retained boundary above is now
-- explained -- but only PARTLY discharged, so read the two halves apart.
--
--   * The WARNING is a `Vec` artefact, not mathematics.
--     `NaturalMachine.DigitTowerFin` restates the same base-two carry
--     obstruction with digit words presented as `Fin n → Digit`.  A
--     function type has no index to match on, and the count goes 28
--     `UnsupportedIndexedMatch` warnings -> 0 with the two proved facts
--     unchanged (LSD deletion is not additive; it is a homomorphism for
--     carry-free XOR).  So nothing here is blocked by Cubical Agda's
--     lack of index injectivity.
--
--   * The INVERSE LIMIT is ported, and only that far.
--     `NaturalMachine.DigitTowerFinLimit` carries the MSD tower over
--     `Fin n → A` and proves `MSDLimit A ≃ (ℕ → A)` for any set A, using
--     `NaturalMachine.FinTopSplit` for the top-splitting eliminator that
--     `Cubical.Data.Fin` does not supply.
--
--   * WHAT IS STILL ONLY HERE, in the `Vec` presentation: `LSDLimit`,
--     `reverseToLSD`/`reverseToMSD`, `reversalLimitEquiv`,
--     `limit-reversal-chart-identity` and `transportLawToLSD`, together
--     with the two-bit `Vec` witnesses at the foot of the file.  Whether
--     the reversal equivalence and the transported law also become
--     transport-computable in the `Fin` presentation is open;
--     `DigitTowerFin`'s own header says so ("the interesting question
--     ... is open") and this file is where the unported statements live.
--     So: superseded for the carry obstruction and for the MSD limit,
--     NOT superseded for reversal.  The warning stays because the code
--     it is about stays.

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Data.Nat
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Bool.Properties using (true≢false)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Sigma using (Σ≡Prop)
open import Cubical.Data.Vec.Base as V using (Vec ; [] ; _∷_ ; _++_)
import Cubical.Data.Vec.Properties as VecProperties
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

private
  variable
    ℓ : Level
    A : Type ℓ

------------------------------------------------------------------------
-- The standard coherent-sequence presentation of an inverse limit.
------------------------------------------------------------------------

InvLim : (X : ℕ → Type ℓ)
       → ((n : ℕ) → X (suc n) → X n) → Type ℓ
InvLim X step = Σ[ x ∈ ((n : ℕ) → X n) ]
                  ((n : ℕ) → step n (x (suc n)) ≡ x n)

------------------------------------------------------------------------
-- Length-indexed digit towers.  `dropMSD` deletes the right-hand end and
-- `dropLSD` deletes the left-hand end.  Reversal exchanges the towers.
------------------------------------------------------------------------

module DigitTower (Digit : Type ℓ) (digitSet : isSet Digit) where

  W : ℕ → Type ℓ
  W n = Vec Digit n

  snoc : {n : ℕ} → W n → Digit → W (suc n)
  snoc [] x = x ∷ []
  snoc (y ∷ ys) x = y ∷ snoc ys x

  reverse : {n : ℕ} → W n → W n
  reverse [] = []
  reverse (x ∷ xs) = snoc (reverse xs) x

  last : {n : ℕ} → W (suc n) → Digit
  last {zero} (x ∷ []) = x
  last {suc n} (x ∷ xs) = last xs

  head-snoc : {n : ℕ} (xs : W (suc n)) (x : Digit)
            → V.head (snoc xs x) ≡ V.head xs
  head-snoc (y ∷ ys) x = refl

  head-reverse-is-last : {n : ℕ} (xs : W (suc n))
                       → V.head (reverse xs) ≡ last xs
  head-reverse-is-last {zero} (x ∷ []) = refl
  head-reverse-is-last {suc n} (x ∷ xs) =
    head-snoc (reverse xs) x ∙ head-reverse-is-last xs

  dropMSD : (n : ℕ) → W (suc n) → W n
  dropMSD zero (x ∷ []) = []
  dropMSD (suc n) (x ∷ xs) = x ∷ dropMSD n xs

  dropLSD : (n : ℕ) → W (suc n) → W n
  dropLSD n (x ∷ xs) = xs

  dropMSD-snoc : {n : ℕ} (xs : W n) (x : Digit)
               → dropMSD n (snoc xs x) ≡ xs
  dropMSD-snoc [] x = refl
  dropMSD-snoc (y ∷ ys) x = cong (y ∷_) (dropMSD-snoc ys x)

  dropMSD-reverse : (n : ℕ) (xs : W (suc n))
                  → dropMSD n (reverse xs) ≡ reverse (dropLSD n xs)
  dropMSD-reverse n (x ∷ xs) = dropMSD-snoc (reverse xs) x

  reverse-snoc : {n : ℕ} (xs : W n) (x : Digit)
               → reverse (snoc xs x) ≡ x ∷ reverse xs
  reverse-snoc [] x = refl
  reverse-snoc (y ∷ ys) x =
    cong (λ zs → snoc zs y) (reverse-snoc ys x)

  reverse-involutive : {n : ℕ} (xs : W n)
                     → reverse (reverse xs) ≡ xs
  reverse-involutive [] = refl
  reverse-involutive (x ∷ xs) =
    reverse-snoc (reverse xs) x ∙ cong (x ∷_) (reverse-involutive xs)

  dropLSD-reverse : (n : ℕ) (xs : W (suc n))
                  → dropLSD n (reverse xs) ≡ reverse (dropMSD n xs)
  dropLSD-reverse n xs =
      sym (reverse-involutive (dropLSD n (reverse xs)))
    ∙ cong reverse
        (sym (dropMSD-reverse n (reverse xs))
          ∙ cong (dropMSD n) (reverse-involutive xs))

  MSDLimit : Type ℓ
  MSDLimit = InvLim W dropMSD

  LSDLimit : Type ℓ
  LSDLimit = InvLim W dropLSD

  reverseToLSD : MSDLimit → LSDLimit
  fst (reverseToLSD (x , coherent)) n = reverse (x n)
  snd (reverseToLSD (x , coherent)) n =
      dropLSD-reverse n (x (suc n))
    ∙ cong reverse (coherent n)

  reverseToMSD : LSDLimit → MSDLimit
  fst (reverseToMSD (x , coherent)) n = reverse (x n)
  snd (reverseToMSD (x , coherent)) n =
      dropMSD-reverse n (x (suc n))
    ∙ cong reverse (coherent n)

  coherence-isProp : (x : (n : ℕ) → W n)
                   → isProp ((n : ℕ) → dropMSD n (x (suc n)) ≡ x n)
  coherence-isProp x = isPropΠ λ n →
    VecProperties.VecPath.isOfHLevelVec 0 n digitSet _ _

  coherenceLSD-isProp : (x : (n : ℕ) → W n)
                      → isProp ((n : ℕ) → dropLSD n (x (suc n)) ≡ x n)
  coherenceLSD-isProp x = isPropΠ λ n →
    VecProperties.VecPath.isOfHLevelVec 0 n digitSet _ _

  reverse-rightInv : (x : LSDLimit) → reverseToLSD (reverseToMSD x) ≡ x
  reverse-rightInv (x , coherent) =
    Σ≡Prop coherenceLSD-isProp
      (funExt λ n → reverse-involutive (x n))

  reverse-leftInv : (x : MSDLimit) → reverseToMSD (reverseToLSD x) ≡ x
  reverse-leftInv (x , coherent) =
    Σ≡Prop coherence-isProp
      (funExt λ n → reverse-involutive (x n))

  reversalLimitEquiv : MSDLimit ≃ LSDLimit
  reversalLimitEquiv = isoToEquiv
    (iso reverseToLSD reverseToMSD reverse-rightInv reverse-leftInv)

  ----------------------------------------------------------------------
  -- The canonical stream charts.  The MSD tower grows on the right, so its
  -- newly exposed digit is `last`; the LSD tower grows on the left, so its
  -- newly exposed digit is `head`.  Finite reversal makes these observations
  -- identical at every level: this is DIGIT_CRYSTAL Theorem 4.4's
  -- `J ∘ R∞ = L`, at the exact set/type scope implemented here.
  ----------------------------------------------------------------------

  MSDChart : MSDLimit → ℕ → Digit
  MSDChart (x , coherent) n = last (x (suc n))

  LSDChart : LSDLimit → ℕ → Digit
  LSDChart (x , coherent) n = V.head (x (suc n))

  limit-reversal-chart-identity : (x : MSDLimit)
                                → LSDChart (reverseToLSD x) ≡ MSDChart x
  limit-reversal-chart-identity (x , coherent) =
    funExt λ n → head-reverse-is-last (x (suc n))

  ----------------------------------------------------------------------
  -- A law on the LSD limit transported through reversal.  This is kept
  -- at the binary-operation level: group laws follow by the same inverse
  -- equations, while a Group record would obscure the structural boundary
  -- tested below (the native finite projections are not homomorphisms for
  -- carry addition).
  ----------------------------------------------------------------------

  transportLawToLSD : (MSDLimit → MSDLimit → MSDLimit)
                    → LSDLimit → LSDLimit → LSDLimit
  transportLawToLSD op x y =
    reverseToLSD (op (reverseToMSD x) (reverseToMSD y))

  transportLawToLSD-conjugacy
    : (op : MSDLimit → MSDLimit → MSDLimit) (x y : LSDLimit)
    → reverseToMSD (transportLawToLSD op x y)
      ≡ op (reverseToMSD x) (reverseToMSD y)
  transportLawToLSD-conjugacy op x y =
    reverse-leftInv (op (reverseToMSD x) (reverseToMSD y))

------------------------------------------------------------------------
-- The least native carry obstruction (DIGIT_CRYSTAL Lemma 4.1).
-- At base two, 1 + 1 = 2.  Deleting the least-significant digit after
-- addition therefore returns 1, whereas deleting first returns 0 + 0 = 0.
-- This is deliberately separate from the transported law above.
------------------------------------------------------------------------

private
  xor : Bool → Bool → Bool
  xor false b = b
  xor true false = true
  xor true true = false

  and : Bool → Bool → Bool
  and false b = false
  and true b = b

  addBit : Vec Bool 1 → Vec Bool 1 → Vec Bool 1
  addBit (a ∷ []) (c ∷ []) = xor a c ∷ []

  -- Little-endian addition modulo four.
  addTwoBits : Vec Bool 2 → Vec Bool 2 → Vec Bool 2
  addTwoBits (a ∷ b ∷ []) (c ∷ d ∷ []) =
    xor a c ∷ xor (xor b d) (and a c) ∷ []

  xorTwoBits : Vec Bool 2 → Vec Bool 2 → Vec Bool 2
  xorTwoBits (a ∷ b ∷ []) (c ∷ d ∷ []) =
    xor a c ∷ xor b d ∷ []

  one₂ : Vec Bool 2
  one₂ = true ∷ false ∷ []

  dropLSD₂ : Vec Bool 2 → Vec Bool 1
  dropLSD₂ (a ∷ b ∷ []) = b ∷ []

dropLSD-not-additive-base2
  : ¬ (dropLSD₂ (addTwoBits one₂ one₂)
       ≡ addBit (dropLSD₂ one₂) (dropLSD₂ one₂))
dropLSD-not-additive-base2 p = true≢false (cong V.head p)

-- Planted opposite setting: end deletion itself is not the obstruction.
-- Without carry, the same projection preserves pointwise XOR exactly.
dropLSD-xor-hom-base2
  : (x y : Vec Bool 2)
  → dropLSD₂ (xorTwoBits x y)
    ≡ addBit (dropLSD₂ x) (dropLSD₂ y)
dropLSD-xor-hom-base2 (a ∷ b ∷ []) (c ∷ d ∷ []) = refl

------------------------------------------------------------------------
-- The all-base, all-tail Rosetta equation behind the preceding witness.
-- `d` and `e` are the deleted least-significant digits; `x` and `y` are
-- the remaining tails.  A native digit-column certificate says that their
-- sum has output digit `r` and carry `c`.  The quotient-level defect is
-- then exactly that `c`, independently of the tail length.
------------------------------------------------------------------------

carry-defect-decomposition
  : (base d e r carry x y : ℕ)
  → d + e ≡ r + base · carry
  → (d + base · x) + (e + base · y)
    ≡ r + base · (x + y + carry)
carry-defect-decomposition base d e r carry x y column =
    rearrange-left base d e x y
  ∙ cong (λ z → z + base · x + base · y) column
  ∙ rearrange-right base r carry x y
  where
    -- cubical 2.8: the solver macro is `solveℕ!`, applied to the INTRO'D goal —
    -- so the helpers are stated over fresh variables and
    -- instantiated at the enclosing ones.
    rearrange-left
      : (b d′ e′ x′ y′ : ℕ)
      → (d′ + b · x′) + (e′ + b · y′)
      ≡ (d′ + e′) + b · x′ + b · y′
    rearrange-left b d′ e′ x′ y′ = solveℕ!

    rearrange-right
      : (b r′ c′ x′ y′ : ℕ)
      → (r′ + b · c′) + b · x′ + b · y′
      ≡ r′ + b · (x′ + y′ + c′)
    rearrange-right b r′ c′ x′ y′ = solveℕ!

-- Opposite control: a zero carry makes least-significant deletion preserve
-- addition exactly at the tail level.
zero-carry-preserves-tail
  : (base d e r x y : ℕ)
  → d + e ≡ r
  → (d + base · x) + (e + base · y)
    ≡ r + base · (x + y)
zero-carry-preserves-tail base d e r x y noCarry =
    carry-defect-decomposition base d e r 0 x y
      (noCarry ∙ sym (+-zero r) ∙ cong (r +_) (0≡m·0 base))
  ∙ cong (r +_) (cong (base ·_) (+-zero (x + y)))
