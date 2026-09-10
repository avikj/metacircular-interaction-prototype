{-# OPTIONS --erased-cubical --erasure --guardedness --no-import-sorts #-}
-- the jiva through its samayas, at three degrees of restraint.
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

रेखा : Nat → जीवः → String
रेखा n j = "  samaya " ⊹ primShowNat n
         ⊹ ": shed " ⊹ primShowNat (गुरुता (निर्जीर्णम् j))
         ⊹ ", bound veils " ⊹ primShowNat (गुरुता (आवरणम् j))

पथः : Nat → Nat → जीवः → String
पथः tick zero    j = रेखा tick j
पथः tick (suc k) j = रेखा tick j ⊹ "\n" ⊹ पथः (suc tick) k (वर्तना j)

main : IO ⊤
main = putStrLn
  (  "the jiva: yoga -> samvara -> gupti -> bandha -> tapas -> nirjara, one samaya:\n"
   ⊹ "gupti 0 (full restraint, only the received veils):\n"
   ⊹ पथः 0 3 (आदि-जीवः 0 आगमः)
   ⊹ "\ngupti 12:\n"
   ⊹ पथः 0 3 (आदि-जीवः 12 आगमः)
   ⊹ "\ngupti 60:\n"
   ⊹ पथः 0 3 (आदि-जीवः 60 आगमः) )
