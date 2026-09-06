{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RH-प्रत्यक्ष — the Riemann hypothesis, seen directly at its first fibres.
--
-- RH_TheWholeQuestionEntersTyped states the hypothesis as one type,
--
--     RH = (n : ℕ) → 1 ≤ n → diffSq (2a) (n²b) < 144 n³ b²,
--
-- with a/b = Σ_{k ≤ δ(n)} 1/k, every function computable.  A type of the
-- shape (n : ℕ) → P n has fibres P n, and each fibre here is decided by
-- evaluation: the oracle is the typechecker running δ, Hfrac and diffSq
-- on a numeral.  This file makes the fibre explicit — RH is, by refl,
-- the Π over RH-at — and inhabits the first three by computation, the
-- witness of each strict inequality being the exact gap.
--
-- The reach of the oracle is bounded by the apparatus, not the question:
-- monus is structurally recursive, so a fibre costs on the order of the
-- larger of 2a and n²b unary steps.  At n = 4, δ = 12 and that is about
-- 7·10⁹; at n = 5, δ = 144 and b = 144!.  The first three fibres are
-- what a `refl` can reach today; the closure over all n is the open
-- question, unchanged.  प्रत्यक्ष (pratyakṣa, direct perception) is the
-- Nyāya name for the pramāṇa this file uses.
------------------------------------------------------------------------

module RHPratyaksa_TheOracleInhabitsTheFirstFibresOfTheArithmetizedRiemannHypothesisByComputation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_)

open import RH_TheWholeQuestionEntersTyped_DavisMatiyasevichRobinsonArithmetization
  using (RH ; Hfrac ; δ ; diffSq)

-- the fibre of RH over n, verbatim
RH-at : ℕ → Type
RH-at n =
  let a  = fst (Hfrac (δ n))
      b  = snd (Hfrac (δ n))
      n² = n · n
      n³ = n² · n
  in  diffSq (2 · a) (n² · b)  <  144 · n³ · (b · b)

-- RH is the Π over its fibres, definitionally
RH-is-Π : RH ≡ ((n : ℕ) → 1 ≤ n → RH-at n)
RH-is-Π = refl

-- the oracle: δ(1) = 1, a/b = 1/1, gap 144 − 1 − 1
rh-1 : RH-at 1
rh-1 = 142 , refl

-- δ(2) = 1, a/b = 1/1, (2 − 4)² = 4 against 1152
rh-2 : RH-at 2
rh-2 = 1147 , refl

-- δ(3) = 2, a/b = 3/2, (6 − 18)² = 144 against 15552
rh-3 : RH-at 3
rh-3 = 15407 , refl
