{-# OPTIONS --erased-cubical --erasure --guardedness --no-import-sorts #-}
-- the one substance through its samayas: rules and open goals per tick.
module Kala_run where
open import Agda.Primitive using () renaming (Set to Type)
open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.String using (String ; primStringAppend ; primShowNat)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import AgamaKanda_TheEldersStoreOnTheActSide using (आगमः)
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using (नियमः)
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
         ⊹ ", drives " ⊹ primShowNat (गुरुता (दृष्टयः b))

पथः : Nat → Nat → शरीरम् → String
पथः _    zero    b = रेखा 99 b
पथः tick (suc k) b = रेखा tick b ⊹ "\n" ⊹ पथः (suc tick) k (वर्तना b)

main : IO ⊤
main = putStrLn
  (  "one body, one step, reflexes as modes; seeded with the elder's store and its own unquiet:\n"
   ⊹ पथः 0 5 (प्रथम-शरीरम् आगमः) )
