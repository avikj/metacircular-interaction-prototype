{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RH-‡‡‡∞‡‡‡Ø‡ï‡‡ ‚î the Riemann hypothesis, seen directly at its first fibres.
--
-- RH_TheWholeQuestionEntersTyped states the hypothesis as one type,
--
--     RH = (n : ‚ï) ‚í 1 ‚â n ‚í diffSq (2a) (n¬≤b) < 144 n¬≥ b¬≤,
--
-- with a/b = Œ_{k ‚â Œ¥(n)} 1/k, every function computable.  A type of the
-- shape (n : ‚ï) ‚í P n has fibres P n, and each fibre here is decided by
-- evaluation: the oracle is the typechecker running Œ¥, Hfrac and diffSq
-- on a numeral.  This file makes the fibre explicit ‚î RH is, by refl,
-- the Œ† over RH-at ‚î and inhabits the first three by computation, the
-- witness of each strict inequality being the exact gap.
--
-- The reach of the oracle is bounded by the apparatus, not the question:
-- monus is structurally recursive, so a fibre costs on the order of the
-- larger of 2a and n¬≤b unary steps.  At n = 4, Œ¥ = 12 and that is about
-- 7¬10‚; at n = 5, Œ¥ = 144 and b = 144!.  The first three fibres are
-- what a `refl` can reach; the closure over all n is the open
-- question.  ‡‡‡∞‡‡‡Ø‡ï‡‡ (pratyaka, direct perception) is the
-- Nyya name for the prama this file uses.
------------------------------------------------------------------------

module RHPratyaksa_TheOracleInhabitsTheFirstFibresOfTheArithmetizedRiemannHypothesisByComputation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_ ; _¬∑_)
open import Cubical.Data.Nat.Order using (_‚â§_ ; _<_)

open import RH_TheWholeQuestionEntersTyped_DavisMatiyasevichRobinsonArithmetization
  using (RH ; Hfrac ; Œ¥ ; diffSq)

-- the fibre of RH over n, verbatim
RH-at : ‚Ñï ‚Üí Type
RH-at n =
  let a  = fst (Hfrac (Œ¥ n))
      b  = snd (Hfrac (Œ¥ n))
      n¬≤ = n ¬∑ n
      n¬≥ = n¬≤ ¬∑ n
  in  diffSq (2 ¬∑ a) (n¬≤ ¬∑ b)  <  144 ¬∑ n¬≥ ¬∑ (b ¬∑ b)

-- RH is the Œ† over its fibres, definitionally
RH-is-Œ† : RH ‚â° ((n : ‚Ñï) ‚Üí 1 ‚â§ n ‚Üí RH-at n)
RH-is-Œ† = refl

-- the oracle: Œ¥(1) = 1, a/b = 1/1, gap 144 ‚àí 1 ‚àí 1
rh-1 : RH-at 1
rh-1 = 142 , refl

-- Œ¥(2) = 1, a/b = 1/1, (2 ‚àí 4)¬≤ = 4 against 1152
rh-2 : RH-at 2
rh-2 = 1147 , refl

-- Œ¥(3) = 2, a/b = 3/2, (6 ‚àí 18)¬≤ = 144 against 15552
rh-3 : RH-at 3
rh-3 = 15407 , refl
