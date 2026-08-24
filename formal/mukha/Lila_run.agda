{-# OPTIONS --erased-cubical --erasure --guardedness --no-import-sorts #-}
-- the problem session: leet-flavor problems posed as optimization,
-- solved with certificates, judged by the clock at scales.
module Lila_run where
open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.String using (String ; primStringAppend ; primShowNat)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Sigma using (_,_)
open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (Tm ; var ; ze ; su ; _⊕_ ; _⊗_ ; _⊖_ ; mx ; lq ; gc)
open import AgamaKanda_TheEldersStoreOnTheActSide using (आगमः)
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using (नियमः ; प्राणः)
open import Lilavati_ThePosedProblemIsSolvedAsOptimizationTheAnswerCertifiedAndTheCostJudgedAtScales
open import KalaDravya_TimeIsASubstanceInTheSameTongueAndTheMachineProvesCostAsItProvesTruth
  using (कालम्)

postulate putStrLn : String → IO ⊤
{-# FOREIGN GHC import qualified Data.Text.IO as T #-}
{-# COMPILE GHC putStrLn = T.putStrLn #-}

infixr 5 _⊹_
_⊹_ : String → String → String
_⊹_ = primStringAppend

दर्शकः : Tm → String
दर्शकः (var i)  = "x" ⊹ primShowNat i
दर्शकः ze       = "0"
दर्शकः (su t)   = "s(" ⊹ दर्शकः t ⊹ ")"
दर्शकः (a ⊕ b)  = "(" ⊹ दर्शकः a ⊹ "+" ⊹ दर्शकः b ⊹ ")"
दर्शकः (a ⊗ b)  = "(" ⊹ दर्शकः a ⊹ "*" ⊹ दर्शकः b ⊹ ")"
दर्शकः (a ⊖ b)  = "(" ⊹ दर्शकः a ⊹ "-" ⊹ दर्शकः b ⊹ ")"
दर्शकः (mx a b) = "max(" ⊹ दर्शकः a ⊹ "," ⊹ दर्शकः b ⊹ ")"
दर्शकः (lq a b) = "le(" ⊹ दर्शकः a ⊹ "," ⊹ दर्शकः b ⊹ ")"
दर्शकः (gc a b) = "gcd(" ⊹ दर्शकः a ⊹ "," ⊹ दर्शकः b ⊹ ")"

Γ : List नियमः
Γ = प्राणः 3 [] आगमः

वच्-वेदना : वेदना → String
वच्-वेदना साधितम् = "dominance PROVEN over every input"
वच्-वेदना दृष्टम्  = "cheaper at every probe scale (measured, syat)"
वच्-वेदना तुल्यम्  = "no cheaper certified form found at this bound"

x y : Tm
x = var 0
y = var 1

क्रीडा : String → Tm → String
क्रीडा nm spec =
     nm ⊹ ": " ⊹ दर्शकः spec
   ⊹ "\n  answer " ⊹ दर्शकः (समाधानम्.उत्तरम् sol)
   ⊹ "  [cost " ⊹ primShowNat (मानम् spec) ⊹ " -> " ⊹ primShowNat (मानम् (समाधानम्.उत्तरम् sol))
   ⊹ "]  " ⊹ वच्-वेदना (समाधानम्.निर्णयः sol)
  where
  sol : समाधानम् spec
  sol = लीला Γ 3 spec

main : IO ⊤
main = putStrLn
  (  क्रीडा "P1 sum via max/min      " (mx x y ⊕ ((x ⊕ y) ⊖ mx x y)) ⊹ "\n"
   ⊹ क्रीडा "P2 add then subtract    " ((x ⊕ y) ⊖ y) ⊹ "\n"
   ⊹ क्रीडा "P3 redundant max        " (mx x (mx x y)) ⊹ "\n"
   ⊹ क्रीडा "P4 absolute difference  " ((x ⊖ y) ⊕ (y ⊖ x)) ⊹ "\n"
   ⊹ क्रीडा "P5 gcd with zero        " (gc (x ⊕ y) ze) )
