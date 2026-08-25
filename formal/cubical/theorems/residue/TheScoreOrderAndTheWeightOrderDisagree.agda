{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheScoreOrderAndTheWeightOrderDisagree
--
-- the Darwin Gödel Machine (Zhang, Hu, Lu, Lange, Clune,
-- arXiv:2505.22954) as
--
--     w_i = 1/(1 + exp[−10(α_i − 0.5)]) · 1/(1 + n_i)
--
-- with α_i benchmark accuracy and n_i the number of functioning
-- children, and reads off its design intent: "a high-scoring but
-- underexplored node is favored, while every eligible node has nonzero
-- probability."
--
-- Both halves of that sentence are facts about the FORM `f(α)/(1+n)`,
-- and §2–§3 check them exactly, in ℕ, with no reals and no sigmoid.
--
-- ────────────────────────────────────────────────────────────────────
-- HOW THE REALS ARE AVOIDED, AND WHAT IS LOST BY IT
--
-- Comparing `f₁/(1+n₁)` against `f₂/(1+n₂)` is comparing
-- `f₁·(1+n₂)` against `f₂·(1+n₁)` — cross-multiplication, valid because
-- both denominators are positive.  That is a ℕ comparison once `f` is a
-- ℕ.  So `f` below is a POSITIVE INTEGER SURROGATE for the sigmoid
-- factor, not the sigmoid.
--
-- WHAT IS LOST: the sigmoid's range.  σ(10(α−0.5)) is strictly between
-- 0 and 1 and never attains an integer; §2's witness uses scores 3 and 2
-- and claims nothing about which accuracies α could produce a ratio 3:2.
-- The disagreement proved is a property of the SHAPE of the weight, not
-- of any particular run.  NOT CLAIMED: that DGM's actual archive ever
-- contains such a pair.
--
-- WHAT IS NOT CLAIMED at all: anything about DGM's benchmark numbers
-- (20.0 → 50.0 on the 200-task SWE-bench Verified subset, 14.2 → 30.7 on
-- Polyglot), which that note records and explicitly declines to import
-- as evidence about mathematical discovery.  Nothing here is evidence
-- about them, and no run of anything was performed.  The paper was NOT
-- read by me; §1's statement of the formula is carried from that note.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheScoreOrderAndTheWeightOrderDisagree where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-comm)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.Sigma

------------------------------------------------------------------------
-- 1.  A node is a score and a child count; weights compare by
--     cross-multiplication
------------------------------------------------------------------------

Node : Type
Node = ℕ × ℕ          -- (score surrogate f, number of functioning children n)

scoreOf : Node → ℕ
scoreOf = fst

childrenOf : Node → ℕ
childrenOf = snd

-- w a > w b  iff  f a · (1 + n b)  >  f b · (1 + n a)
WeightBelow : Node → Node → Type
WeightBelow a b =
  (scoreOf a · suc (childrenOf b)) < (scoreOf b · suc (childrenOf a))

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
  × (WeightBelow explored fresh)
theTwoOrdersDisagree = scoreOrderPrefersExplored , weightOrderPrefersFresh

------------------------------------------------------------------------
-- 3.  And no eligible node is excluded: a positive score keeps a
--     positive weight whatever the child count
------------------------------------------------------------------------

positiveScoreKeepsPositiveWeight :
  (f n : ℕ) → 0 < (suc f · suc n)
positiveScoreKeepsPositiveWeight f n =
  (n + f · suc n) , +-comm (n + f · suc n) 1

------------------------------------------------------------------------
-- 4.  The reading
--
-- §2 is the exact content of "a high-scoring but underexplored node is
-- favored": the weight order is NOT the score order, so the archive is
-- not hill-climbing on the benchmark.  Saying which of the two orders is
-- better would be a bare comparative and is not said — they are
-- different orders, and the design chooses the second on purpose.
--
-- §3 is the exact content of "every eligible node has nonzero
-- probability": the child count divides the weight down but never to
-- zero, so no node is ever removed from consideration by having been
-- explored.
--
-- Together they say the sentence in §1 of that note is two structural
-- facts about `f(α)/(1+n)` and needs no benchmark to hold — which is
-- the part of the DGM design that survives the note's own refusal to
-- import DGM's empirical claims.
------------------------------------------------------------------------
