{-# OPTIONS --erased-cubical --erasure --guardedness --no-import-sorts #-}
-- संवादः, second sitting: it eats its own first answers, breathes
-- deeper, and is asked its silences again.
module Samvada2_run where
open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.String using (String ; primStringAppend ; primShowNat)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Maybe using (Maybe ; just ; nothing)
open import Agda.Builtin.Sigma using (_,_ ; fst ; snd)
open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (Tm ; var ; ze ; su ; _⊕_ ; _⊗_ ; _⊖_ ; mx ; lq ; Eq')
open import AgamaKanda_TheEldersStoreOnTheActSide using (आगमः)
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using (नियमः ; niyama ; गूढ-दृक् ; संयुक्त-यन्त्रम् ; पूर्ण-प्रमाणम् ; प्राणः ; इन्धनम् ; ⊨_)
open import Gunasthana_TheBodyClimbsByItsOwnAttainmentTheEyeIsAFunctionOfTheRecordAndNoAgentPicksOrgans
  using (अनुलोम-श्रुतम् ; जात-चक्षुः)

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
दर्शकः (a ⊕ b)  = "(" ⊹ दर्शकः a ⊹ " + " ⊹ दर्शकः b ⊹ ")"
दर्शकः (a ⊗ b)  = "(" ⊹ दर्शकः a ⊹ " * " ⊹ दर्शकः b ⊹ ")"
दर्शकः (a ⊖ b)  = "(" ⊹ दर्शकः a ⊹ " - " ⊹ दर्शकः b ⊹ ")"
दर्शकः (mx a b) = "max(" ⊹ दर्शकः a ⊹ ", " ⊹ दर्शकः b ⊹ ")"
दर्शकः (lq a b) = "le(" ⊹ दर्शकः a ⊹ ", " ⊹ दर्शकः b ⊹ ")"

परम्परा : List नियमः
परम्परा = प्राणः 3 [] आगमः

x y z : Tm
x = var 0
y = var 1
z = var 2

-- what it answered in the first sitting: offered back as food
प्रथम-उत्तराणि : List Eq'
प्रथम-उत्तराणि =
    ( x ⊗ (y ⊕ z) , (x ⊗ y) ⊕ (x ⊗ z) )
  ∷ ( mx x (x ⊕ y) , x ⊕ y )
  ∷ ( x ⊖ (x ⊕ y) , ze )
  ∷ ( mx (su x) (su y) , su (mx x y) )
  ∷ ( (x ⊕ y) ⊖ y , x )
  ∷ ( lq (x ⊕ z) (y ⊕ z) , lq x y )
  ∷ []

-- it re-proves each (milliseconds) so the new food enters WARRANTED
-- through the same gate as everything else
खाद् : List नियमः → List Eq' → List नियमः
खाद् Γ []             = Γ
खाद् Γ ((l , r) ∷ es) with पूर्ण-प्रमाणम् गूढ-दृक् संयुक्त-यन्त्रम् Γ इन्धनम् (l , r)
... | just pf = खाद् (niyama l r pf ∷ Γ) es
... | nothing = खाद् Γ es

पुष्ट-परम्परा : List नियमः
पुष्ट-परम्परा = खाद् परम्परा प्रथम-उत्तराणि

गभीरम् : Nat            -- deeper breath for the second sitting
गभीरम् = suc (suc इन्धनम्)

उत्तरम् : String → List नियमः → Nat → Eq' → String
उत्तरम् tag Γ fl (l , r) with पूर्ण-प्रमाणम् (जात-चक्षुः Γ) संयुक्त-यन्त्रम् (अनुलोम-श्रुतम् Γ) fl (l , r)
... | just _  = "  [" ⊹ tag ⊹ "] " ⊹ दर्शकः l ⊹ " = " ⊹ दर्शकः r ⊹ "   -- SIDDHAM"
... | nothing = "  [" ⊹ tag ⊹ "] " ⊹ दर्शकः l ⊹ " = " ⊹ दर्शकः r ⊹ "   -- maunam"

मौनानि : List Eq'
मौनानि =
    ( (x ⊕ y) ⊗ (x ⊕ y) , ((x ⊗ x) ⊕ (x ⊗ y)) ⊕ ((y ⊗ x) ⊕ (y ⊗ y)) )
  ∷ ( mx (x ⊗ z) (y ⊗ z) , mx x y ⊗ z )
  ∷ ( mx x (mx y z) , mx (mx x y) z )
  ∷ []

वच् : List Eq' → String
वच् []       = "that is its second word."
वच् (q ∷ qs) = उत्तरम् "fed+deep" पुष्ट-परम्परा गभीरम् q ⊹ "\n" ⊹ वच् qs

main : IO ⊤
main = putStrLn
  ("second sitting: its own answers fed back warranted, the eye reborn from the fattened record, fuel deepened:\n"
   ⊹ वच् मौनानि)
