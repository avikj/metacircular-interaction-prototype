{-# OPTIONS --erased-cubical --erasure --guardedness --no-import-sorts #-}
-- third sitting: feeding alone, normal fuel, the plain गूढ eye — which
-- ingredient was the binding one?
module Samvada3_run where
open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.String using (String ; primStringAppend)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Maybe using (Maybe ; just ; nothing)
open import Agda.Builtin.Sigma using (_,_)
open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (Tm ; var ; ze ; su ; _⊕_ ; _⊗_ ; _⊖_ ; mx ; lq ; Eq')
open import AgamaKanda_TheEldersStoreOnTheActSide using (आगमः)
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using (नियमः ; niyama ; गूढ-दृक् ; संयुक्त-यन्त्रम् ; पूर्ण-प्रमाणम् ; प्राणः ; इन्धनम्)
open import Gunasthana_TheBodyClimbsByItsOwnAttainmentTheEyeIsAFunctionOfTheRecordAndNoAgentPicksOrgans
  using (अनुलोम-श्रुतम्)

postulate putStrLn : String → IO ⊤
{-# FOREIGN GHC import qualified Data.Text.IO as T #-}
{-# COMPILE GHC putStrLn = T.putStrLn #-}

infixr 5 _⊹_
_⊹_ : String → String → String
_⊹_ = primStringAppend

परम्परा : List नियमः
परम्परा = प्राणः 3 [] आगमः

x y z : Tm
x = var 0
y = var 1
z = var 2

खाद् : List नियमः → List Eq' → List नियमः
खाद् Γ []             = Γ
खाद् Γ ((l , r) ∷ es) with पूर्ण-प्रमाणम् गूढ-दृक् संयुक्त-यन्त्रम् Γ इन्धनम् (l , r)
... | just pf = खाद् (niyama l r pf ∷ Γ) es
... | nothing = खाद् Γ es

पुष्टा : List नियमः
पुष्टा = खाद् परम्परा
  ( ( x ⊗ (y ⊕ z) , (x ⊗ y) ⊕ (x ⊗ z) )
  ∷ ( (x ⊗ y) ⊕ (x ⊗ z) , x ⊗ (y ⊕ z) )
  ∷ ( mx (su x) (su y) , su (mx x y) )
  ∷ [] )

उ : String → Eq' → String
उ tag (l , r) with पूर्ण-प्रमाणम् गूढ-दृक् संयुक्त-यन्त्रम् (अनुलोम-श्रुतम् पुष्टा) इन्धनम् (l , r)
... | just _  = "  [" ⊹ tag ⊹ "] SIDDHAM"
... | nothing = "  [" ⊹ tag ⊹ "] maunam"

main : IO ⊤
main = putStrLn
  (  "third sitting (fed only, normal fuel, plain gudha eye):\n"
   ⊹ उ "square " ( (x ⊕ y) ⊗ (x ⊕ y) , ((x ⊗ x) ⊕ (x ⊗ y)) ⊕ ((y ⊗ x) ⊕ (y ⊗ y)) ) ⊹ "\n"
   ⊹ उ "mx-dist" ( mx (x ⊗ z) (y ⊗ z) , mx x y ⊗ z ) ⊹ "\n"
   ⊹ उ "mx-asso" ( mx x (mx y z) , mx (mx x y) z ) )
