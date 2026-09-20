{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheScoreOrderAndTheWeightOrderDisagree
--
-- the Darwin Gdel Machine (Zhang, Hu, Lu, Lange, Clune,
-- arXiv:2505.22954) as
--
--     w_i = 1/(1 + exp[âˆ’10(Î_i âˆ’ 0.5)]) Â 1/(1 + n_i)
--
-- with Î_i benchmark accuracy and n_i the number of functioning
-- children, and reads off its design intent: "a high-scoring but
-- underexplored node is favored, while every eligible node has nonzero
-- probability."
--
-- Both halves of that sentence are facts about the FORM `f(Î)/(1+n)`,
-- and Â§2â“Â§3 check them exactly, in â•, with no reals and no sigmoid.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- HOW THE REALS ARE AVOIDED, AND WHAT IS LOST BY IT
--
-- Comparing `fâ/(1+nâ)` against `fâ/(1+nâ)` is comparing
-- `fâÂ(1+nâ)` against `fâÂ(1+nâ)` â” cross-multiplication, valid because
-- both denominators are positive.  That is a â• comparison once `f` is a
-- â•.  So `f` below is a POSITIVE INTEGER SURROGATE for the sigmoid
-- factor, not the sigmoid.
--
-- WHAT IS LOST: the sigmoid's range.  Ï(10(Îâˆ’0.5)) is strictly between 0 and
-- 1 and never attains an integer; Â§2's witness uses scores 3 and 2 and claims
-- nothing about which accuracies Î could produce a ratio 3:2. The
-- disagreement proved is a property of the SHAPE of the weight, not of any
-- particular run.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheScoreOrderAndTheWeightOrderDisagree where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_ ; +-comm)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.Sigma

------------------------------------------------------------------------
-- 1.  A node is a score and a child count; weights compare by
--     cross-multiplication
------------------------------------------------------------------------

Node : Type
Node = â„• Ã— â„•          -- (score surrogate f, number of functioning children n)

scoreOf : Node â†’ â„•
scoreOf = fst

childrenOf : Node â†’ â„•
childrenOf = snd

-- w a > w b  iff  f a Â (1 + n b)  >  f b Â (1 + n a)
WeightBelow : Node â†’ Node â†’ Type
WeightBelow a b =
  (scoreOf a Â· suc (childrenOf b)) < (scoreOf b Â· suc (childrenOf a))

------------------------------------------------------------------------
-- 2.  The two orders disagree: a better-scoring node can weigh less
--
-- `explored` has the higher score and three functioning children;
-- `fresh` scores lower and has none.
------------------------------------------------------------------------

explored fresh : Node
explored = 3 , 3
fresh    = 2 , 0

scoreOrderPrefersExplored : scoreOf fresh < scoreOf explored
scoreOrderPrefersExplored = 0 , refl

weightOrderPrefersFresh : WeightBelow explored fresh
weightOrderPrefersFresh = 4 , refl

theTwoOrdersDisagree :
    (scoreOf fresh < scoreOf explored)
  Ã— (WeightBelow explored fresh)
theTwoOrdersDisagree = scoreOrderPrefersExplored , weightOrderPrefersFresh

------------------------------------------------------------------------
-- 3.  And no eligible node is excluded: a positive score keeps a
--     positive weight whatever the child count
------------------------------------------------------------------------

positiveScoreKeepsPositiveWeight :
  (f n : â„•) â†’ 0 < (suc f Â· suc n)
positiveScoreKeepsPositiveWeight f n =
  (n + f Â· suc n) , +-comm (n + f Â· suc n) 1

------------------------------------------------------------------------
-- 4.  The reading
--
-- Â§2 is the exact content of "a high-scoring but underexplored node is
-- favored": the weight order is NOT the score order, so the archive is
-- not hill-climbing on the benchmark.  Saying which of the two orders is
-- better would be a bare comparative and is not said â” they are
-- different orders, and the design chooses the second on purpose.
--
-- Â§3 is the exact content of "every eligible node has nonzero
-- probability": the child count divides the weight down but never to
-- zero, so no node is ever removed from consideration by having been
-- explored.
--
-- Together they say the sentence in Â§1 of that note is two structural
-- facts about `f(Î)/(1+n)` and needs no benchmark to hold â” which is
-- the part of the DGM design that survives the note's own refusal to
-- import DGM's empirical claims.
------------------------------------------------------------------------
