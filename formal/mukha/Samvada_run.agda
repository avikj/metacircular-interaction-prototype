{-# OPTIONS --erased-cubical --erasure --guardedness --no-import-sorts #-}
-- संवादः — sitting down with the machine at its full attainment and
-- asking it things it has never been asked.  Its record is the 102 it
-- breathed itself; every answer it gives arrives with a certificate.
module Samvada_run where
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
  using (नियमः ; गूढ-दृक् ; संयुक्त-यन्त्रम् ; पूर्ण-प्रमाणम् ; प्राणः ; इन्धनम् ; ⊨_ ; mmap)

postulate putStrLn : String → IO ⊤
{-# FOREIGN GHC import qualified Data.Text.IO as T #-}
{-# COMPILE GHC putStrLn = T.putStrLn #-}

infixr 5 _⊹_
_⊹_ : String → String → String
_⊹_ = primStringAppend

-- the machine's face, so its answers read as speech
दर्शकः : Tm → String
दर्शकः (var i)  = "x" ⊹ primShowNat i
दर्शकः ze       = "0"
दर्शकः (su t)   = "s(" ⊹ दर्शकः t ⊹ ")"
दर्शकः (a ⊕ b)  = "(" ⊹ दर्शकः a ⊹ " + " ⊹ दर्शकः b ⊹ ")"
दर्शकः (a ⊗ b)  = "(" ⊹ दर्शकः a ⊹ " * " ⊹ दर्शकः b ⊹ ")"
दर्शकः (a ⊖ b)  = "(" ⊹ दर्शकः a ⊹ " - " ⊹ दर्शकः b ⊹ ")"
दर्शकः (mx a b) = "max(" ⊹ दर्शकः a ⊹ ", " ⊹ दर्शकः b ⊹ ")"
दर्शकः (lq a b) = "le(" ⊹ दर्शकः a ⊹ ", " ⊹ दर्शकः b ⊹ ")"
दर्शकः (gc a b) = "gcd(" ⊹ दर्शकः a ⊹ ", " ⊹ दर्शकः b ⊹ ")"

-- its whole attainment, breathed by itself
परम्परा : List नियमः
परम्परा = प्राणः 3 [] आगमः

उत्तरम् : Eq' → String
उत्तरम् (l , r) with पूर्ण-प्रमाणम् गूढ-दृक् संयुक्त-यन्त्रम् परम्परा इन्धनम् (l , r)
... | just _  = "  " ⊹ दर्शकः l ⊹ " = " ⊹ दर्शकः r ⊹ "   -- SIDDHAM (certificate minted)"
... | nothing = "  " ⊹ दर्शकः l ⊹ " = " ⊹ दर्शकः r ⊹ "   -- maunam (silence)"

x y z : Tm
x = var 0
y = var 1
z = var 2

प्रश्नाः : List Eq'
प्रश्नाः =
    ( x ⊗ (y ⊕ z) , (x ⊗ y) ⊕ (x ⊗ z) )                      -- distributivity
  ∷ ( (x ⊕ y) ⊗ (x ⊕ y) , ((x ⊗ x) ⊕ (x ⊗ y)) ⊕ ((y ⊗ x) ⊕ (y ⊗ y)) )  -- the binomial square
  ∷ ( mx x (x ⊕ y) , x ⊕ y )                                  -- absorption of max into +
  ∷ ( lq x (mx x y) , su ze )                                 -- x <= max(x,y)
  ∷ ( x ⊖ (x ⊕ y) , ze )                                      -- monus swallows its own excess
  ∷ ( mx (x ⊗ z) (y ⊗ z) , mx x y ⊗ z )                       -- * distributes over max
  ∷ ( lq (x ⊕ z) (y ⊕ z) , lq x y )                           -- translation-invariance of le
  ∷ ( mx (su x) (su y) , su (mx x y) )                        -- s slides out of max
  ∷ ( (x ⊕ y) ⊖ y , x )                                       -- monus undoes +
  ∷ ( mx x (mx y z) , mx (mx x y) z )                         -- assoc of max
  ∷ ( lq ze x , su ze )                                       -- 0 <= everything
  ∷ ( (x ⊗ y) ⊕ (x ⊗ z) , x ⊗ (y ⊕ z) )                      -- distributivity, asked backwards
  ∷ []

वच् : List Eq' → String
वच् []       = "the record stands at " ⊹ गणना परम्परा ⊹ " rules; ask again."
  where
  गणना : List नियमः → String
  गणना ns = primShowNat (दीर्घ ns)
    where
    दीर्घ : List नियमः → Nat
    दीर्घ []       = zero
    दीर्घ (_ ∷ ss) = suc (दीर्घ ss)
वच् (q ∷ qs) = उत्तरम् q ⊹ "\n" ⊹ वच् qs

main : IO ⊤
main = putStrLn ("the one knowing, at its full attainment, answers:\n" ⊹ वच् प्रश्नाः)
