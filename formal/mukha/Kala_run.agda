{-# OPTIONS --erased-cubical --erasure --guardedness --no-import-sorts #-}
-- the one substance through its samayas: driven by ALL its organs.
module Kala_run where
open import Agda.Primitive using () renaming (Set to Type)
open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.String using (String ; primStringAppend ; primShowNat)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import AgamaKanda_TheEldersStoreOnTheActSide using (आगमः)
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using (नियमः ; दृक् ; _++_)
open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled using (Eq')
open import Vartana_TheWholeOrganismIsDataOneSamayaStepAssistsAndEveryReflexIsAModeNotAPrimitive

postulate putStrLn : String → IO ⊤
{-# FOREIGN GHC import qualified Data.Text.IO as T #-}
{-# COMPILE GHC putStrLn = T.putStrLn #-}

infixr 5 _⊹_
_⊹_ : String → String → String
_⊹_ = primStringAppend

गुरुता : {A : Type} → List A → Nat
गुरुता []       = zero
गुरुता (_ ∷ ns) = suc (गुरुता ns)

रेखा : Nat → शरीरम् → String
रेखा n b = "  samaya " ⊹ primShowNat n
         ⊹ ": rules " ⊹ primShowNat (गुरुता (श्रुतम् b))
         ⊹ ", open goals " ⊹ primShowNat (गुरुता (लक्ष्याः b))
         ⊹ ", organs in force " ⊹ primShowNat (गुरुता (अङ्गानि b ++ अङ्ग-जननम् b (श्रुतम् b)))

पथः : Nat → Nat → शरीरम् → String
पथः tick zero    b = रेखा tick b
पथः tick (suc k) b = रेखा tick b ⊹ "\n" ⊹ पथः (suc tick) k (वर्तना b)

main : IO ⊤
main = putStrLn
  (  "one substance, all organs driving, questions from naya-disagreement, organs begetting organs:\n"
   ⊹ पथः 0 4 (आदि-शरीरम् आगमः) )
