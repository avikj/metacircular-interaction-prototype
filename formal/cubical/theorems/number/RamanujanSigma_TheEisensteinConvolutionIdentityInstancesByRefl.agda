{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन्, सिग्मा — THE EISENSTEIN CONVOLUTION IDENTITY,
-- INSTANCES BY REFL.
--
-- Ramanujan, "On certain arithmetical functions" (1916), proved by
-- elementary means what E₄² = E₈ says in the modular language:
--
--     σ₇(n)  =  σ₃(n) + 120 · Σ_{k=1}^{n−1} σ₃(k) · σ₃(n−k).
--
-- Every quantity is a finite sum of divisor powers; the identity is
-- exact arithmetic through and through.  This file computes both
-- sides for n = 1..8 — divisor sums by the witness-typed cofactor
-- scan, the convolution by a countdown fold — and the kernel closes
-- each instance by refl.  At n = 8 the two sides agree at 2113665.
--
-- The statement for every n at once is the one-dimensionality of the
-- weight-8 modular forms; it is named, and the eight instances are
-- what the kernel computed.
------------------------------------------------------------------------

module RamanujanSigma_TheEisensteinConvolutionIdentityInstancesByRefl where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just ; rec ; map-Maybe)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)

------------------------------------------------------------------------
-- §1  Divisor power sums by interrogation.
------------------------------------------------------------------------

pow3 : ℕ → ℕ
pow3 m = m · (m · m)

pow7 : ℕ → ℕ
pow7 m = m · (m · (m · (m · (m · (m · m)))))

-- k contributes its power exactly when a cofactor witness exists.
contrib : (ℕ → ℕ) → ℕ → ℕ → ℕ
contrib f k m = rec 0 (λ _ → f k) (find m)
  where
  find : (b : ℕ) → Maybe (Σ ℕ (λ q → q · k ≡ m))
  find zero    = map-Maybe (λ p → zero , p) (eq? zero m)
  find (suc b) = rec (find b) (λ p → just (suc b , p)) (eq? (suc b · k) m)

σof : (ℕ → ℕ) → ℕ → ℕ
σof f m = go m
  where
  go : ℕ → ℕ
  go zero    = 0
  go (suc k) = contrib f (suc k) m + go k

σ₃ : ℕ → ℕ
σ₃ = σof pow3

σ₇ : ℕ → ℕ
σ₇ = σof pow7

------------------------------------------------------------------------
-- §2  The convolution.
------------------------------------------------------------------------

-- Σ_{k=1}^{j} σ₃(k) · σ₃(n−k), counted down.
conv : ℕ → ℕ → ℕ
conv n zero    = 0
conv n (suc j) = σ₃ (suc j) · σ₃ (n ∸ suc j) + conv n j

σ₃∗σ₃ : ℕ → ℕ
σ₃∗σ₃ n = conv n (n ∸ 1)

------------------------------------------------------------------------
-- §3  THE IDENTITY, eight instances.
------------------------------------------------------------------------

eisenstein-1 : σ₇ 1 ≡ σ₃ 1 + 120 · σ₃∗σ₃ 1
eisenstein-1 = refl

eisenstein-2 : σ₇ 2 ≡ σ₃ 2 + 120 · σ₃∗σ₃ 2
eisenstein-2 = refl

eisenstein-3 : σ₇ 3 ≡ σ₃ 3 + 120 · σ₃∗σ₃ 3
eisenstein-3 = refl

eisenstein-4 : σ₇ 4 ≡ σ₃ 4 + 120 · σ₃∗σ₃ 4
eisenstein-4 = refl

eisenstein-5 : σ₇ 5 ≡ σ₃ 5 + 120 · σ₃∗σ₃ 5
eisenstein-5 = refl

eisenstein-6 : σ₇ 6 ≡ σ₃ 6 + 120 · σ₃∗σ₃ 6
eisenstein-6 = refl

eisenstein-7 : σ₇ 7 ≡ σ₃ 7 + 120 · σ₃∗σ₃ 7
eisenstein-7 = refl

eisenstein-8 : σ₇ 8 ≡ σ₃ 8 + 120 · σ₃∗σ₃ 8
eisenstein-8 = refl

-- The n = 8 meeting point, named: both sides are 2113665.
at-eight : σ₇ 8 ≡ 2113665
at-eight = refl
