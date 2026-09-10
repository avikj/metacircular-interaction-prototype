{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- द्वि-दृष्टि — the two sights.
--
-- PEAK NORMALIZATION AND ENERGY PRESERVATION ARE EACH BLIND, WITH AN
-- EXPLICIT ONE-PARAMETER FIBRE.  TOGETHER THEY RECONSTRUCT, AND THE
-- FACTOR BY WHICH THEY DO IS `d + 2`.
--
-- In logarithmic scaling coordinates a = log A, λ = log ℓ, the two
-- readings a rescaling can be asked for are
--
--     peak   a λ  =  a + λ                (A ℓ M = 1)
--     energy a λ  =  2a - dλ              (A² ℓ^{-d} = 1) .
--
-- The determinant of that pair is -(d+2), and this module carries the
-- consequences of that one number without ever dividing by it — every
-- statement below is an identity in an arbitrary commutative ring, with
-- integer coefficients as iterated addition imported from `SesaDvaya`.
--
--   §1  EACH READING ALONE IS BLIND, and the fibre is exhibited rather
--       than asserted: `peak` is unchanged along (a,λ) ↦ (a+t, λ-t),
--       and `energy` along (a,λ) ↦ (a + d·t, λ + t + t).  These are the
--       kernels of the two rows, written out.
--
--   §2  BUT THE PAIR RECONSTRUCTS, up to exactly the determinant:
--
--         d·(peak) + (energy)          ≡  (d+2)·a ,
--         (peak + peak) - (energy)     ≡  (d+2)·λ .
--
--       This is the adjugate of a 2×2 matrix, written without matrices,
--       and it is the left inverse that certifies joint faithfulness.
--
--   §3  SO THE TWO READINGS ARE JOINTLY FAITHFUL, up to `d+2` in
--       general, and exactly when `d+2` is cancellable — which is
--       carried as a hypothesis, since a general ring need not admit it.
--
--   §4  AND THE DERIVED TIME READING ADDS NOTHING: the Euler balance
--       τ₀ = A ℓ reads `a + λ`, which IS the peak reading, by `refl`.
--       A reading in the span of the ones already taken cuts no fibre
--       the earlier ones left — the identity is the sharpest possible
--       form of that, since the third row is not merely dependent but
--       equal to the first.
--
-- AND THE SAME `d + 2` GOVERNS THE JET THRESHOLDS, over ℕ where the
-- order lives.  An invisible harmonic velocity m-jet and a remote
-- pressure k-jet have observer thresholds (d-2)/(2m+d) and (d-2)/(d+k);
-- comparing them at velocity-derivative order q is comparing the
-- denominators 2q+d and d+q+1:
--
--   §5  AT q = 1 THEY AGREE: d + 1 + 1 ≡ 2·1 + d, so there is NO gap at
--       the first derivative — the two readings threshold together,
--       which is exactly why the first-order picture looks flat.
--
--   §6  AT q ≥ 2 THE PRESSURE DENOMINATOR IS STRICTLY SMALLER, for every
--       d, so the pressure threshold is strictly larger: the gap opens
--       at the second jet and is dimension-uniform.
--
--   §7  and the difference of the two thresholds, cross-multiplied so
--       that no division occurs, is a product with `q - 1` as a factor —
--       which is why §5 is exactly the case where it vanishes.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–4 in any commutative ring, for every
-- dimension `d` as a natural number and every pair of coordinates.
-- §§5–7 in ℕ.  NOT claimed: that the readings correspond to any
-- particular physical normalization — `peak` and `energy` are two linear
-- forms and the module never leaves that; anything about M, about
-- logarithms, or about the exponents -2/(d+2) and -d/(d+2), which are
-- what §2 becomes after dividing by d+2 and are therefore NOT stated
-- here; that `d+2` is cancellable, which §3 carries as a hypothesis;
-- and nothing about jets, harmonic velocities, or pressure beyond the
-- comparison of two natural numbers — §§5–7 are about denominators, and
-- the thresholds they came from are not constructed.
------------------------------------------------------------------------

module DviDrsti_EachScalingReadingHasAOneParameterFibreButTheirDeterminantIsDimensionPlusTwoSoTogetherTheyReconstructAndTheDerivedTimeReadingAddsNothing where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; +-comm)
  renaming (_+_ to _+ℕ_ ; _·_ to _·ℕ_)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import Cubical.Tactics.NatSolver using (solveℕ!)

import SesaDvaya_TheTruncatedInverseOfTheSquaredShiftDefectHasAResidualOfExactlyTwoTermsAtEveryDepth as SD

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- PART ONE · Two linear readings and their determinant.
------------------------------------------------------------------------

module _ (R : CommRing ℓ) (d : ℕ) where
  open CommRingStr (snd R)

  private
    A : Type ℓ
    A = ⟨ R ⟩

  scale : ℕ → A → A
  scale = SD.scale R

  peak energy time : A → A → A
  peak   a l = a + l
  energy a l = (a + a) + (- scale d l)
  time   a l = a + l

  --------------------------------------------------------------------
  -- १ · EACH READING ALONE IS BLIND, along an exhibited direction.
  --------------------------------------------------------------------

  peak-blind : (a l t : A) → peak (a + t) (l + (- t)) ≡ peak a l
  peak-blind a l t = solve! R

  energy-blind : (a l t : A)
    → energy (a + scale d t) (l + (t + t)) ≡ energy a l
  energy-blind a l t =
      cong (λ z → ((a + scale d t) + (a + scale d t)) + (- z))
           ( SD.scale-dist R d l (t + t)
           ∙ cong (scale d l +_) (SD.scale-dist R d t t) )
    ∙ shape a (scale d t) (scale d l)
    where
      shape : (p u v : A)
        → ((p + u) + (p + u)) + (- (v + (u + u))) ≡ (p + p) + (- v)
      shape p u v = solve! R

  --------------------------------------------------------------------
  -- २ · BUT THE PAIR RECONSTRUCTS, up to exactly the determinant.
  --------------------------------------------------------------------

  reconstruct-amplitude : (a l : A)
    → scale d (peak a l) + energy a l ≡ scale (d +ℕ 2) a
  reconstruct-amplitude a l =
      scale d (a + l) + ((a + a) + (- scale d l))
    ≡⟨ cong (_+ ((a + a) + (- scale d l))) (SD.scale-dist R d a l) ⟩
      (scale d a + scale d l) + ((a + a) + (- scale d l))
    ≡⟨ cancel (scale d a) (scale d l) (a + a) ⟩
      scale d a + (a + a)
    ≡⟨ cong (λ z → scale d a + (a + z)) (sym (+IdR a)) ⟩
      scale d a + (a + (a + 0r))
    ≡⟨ sym (SD.scale-+ R d 2 a) ⟩
      scale (d +ℕ 2) a ∎
    where
      cancel : (p q r : A) → (p + q) + (r + (- q)) ≡ p + r
      cancel p q r = solve! R

  reconstruct-length : (a l : A)
    → (peak a l + peak a l) + (- energy a l) ≡ scale (d +ℕ 2) l
  reconstruct-length a l =
      ((a + l) + (a + l)) + (- ((a + a) + (- scale d l)))
    ≡⟨ collapse a l (scale d l) ⟩
      (l + (l + 0r)) + scale d l
    ≡⟨ sym (SD.scale-+ R 2 d l) ⟩
      scale (2 +ℕ d) l
    ≡⟨ cong (λ m → scale m l) (+-comm 2 d) ⟩
      scale (d +ℕ 2) l ∎
    where
      collapse : (p q s : A)
        → ((p + q) + (p + q)) + (- ((p + p) + (- s))) ≡ (q + (q + 0r)) + s
      collapse p q s = solve! R

  --------------------------------------------------------------------
  -- ३ · SO THE PAIR IS JOINTLY FAITHFUL, up to the determinant.
  --------------------------------------------------------------------

  jointly-faithful : (a l a' l' : A)
    → peak a l ≡ peak a' l' → energy a l ≡ energy a' l'
    → (scale (d +ℕ 2) a ≡ scale (d +ℕ 2) a')
      × (scale (d +ℕ 2) l ≡ scale (d +ℕ 2) l')
  jointly-faithful a l a' l' hp he =
      ( sym (reconstruct-amplitude a l)
      ∙ cong₂ (λ u v → scale d u + v) hp he
      ∙ reconstruct-amplitude a' l' )
    , ( sym (reconstruct-length a l)
      ∙ cong₂ (λ u v → (u + u) + (- v)) hp he
      ∙ reconstruct-length a' l' )

  jointly-faithful-exact :
      ((x y : A) → scale (d +ℕ 2) x ≡ scale (d +ℕ 2) y → x ≡ y)
    → (a l a' l' : A)
    → peak a l ≡ peak a' l' → energy a l ≡ energy a' l'
    → (a ≡ a') × (l ≡ l')
  jointly-faithful-exact cancels a l a' l' hp he =
      cancels a a' (jointly-faithful a l a' l' hp he .fst)
    , cancels l l' (jointly-faithful a l a' l' hp he .snd)

  --------------------------------------------------------------------
  -- ४ · AND THE DERIVED TIME READING ADDS NOTHING.
  --------------------------------------------------------------------

  time-is-the-peak-reading : (a l : A) → time a l ≡ peak a l
  time-is-the-peak-reading a l = refl

  time-cuts-no-fibre : (a l a' l' : A)
    → peak a l ≡ peak a' l' → time a l ≡ time a' l'
  time-cuts-no-fibre a l a' l' hp = hp

------------------------------------------------------------------------
-- PART TWO · The same `d + 2` in the jet thresholds.
--
-- Threshold denominators at velocity-derivative order q:
--   vorticity-first : 2q + d       pressure-first : d + q + 1
------------------------------------------------------------------------

first-jet-coincidence : (d : ℕ) → (d +ℕ 1) +ℕ 1 ≡ (2 ·ℕ 1) +ℕ d
first-jet-coincidence d = solveℕ!

higher-jet-gap-opens : (d j : ℕ)
  → ((d +ℕ (2 +ℕ j)) +ℕ 1) < (((2 +ℕ j) +ℕ (2 +ℕ j)) +ℕ d)
higher-jet-gap-opens d j = j , solveℕ!

gap-numerator : (e j : ℕ)
  → e ·ℕ (((2 +ℕ j) +ℕ (2 +ℕ j)) +ℕ (e +ℕ 2))
    ≡ (e ·ℕ (((e +ℕ 2) +ℕ (2 +ℕ j)) +ℕ 1)) +ℕ (e ·ℕ (1 +ℕ j))
gap-numerator e j = solveℕ!
