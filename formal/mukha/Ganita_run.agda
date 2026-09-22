{-# OPTIONS --erased-cubical --erasure --guardedness --no-import-sorts #-}
-- गणितम् — the cost ledger: the machine reads its own clock over its
-- whole inheritance, raw against eye-optimized, at a fixed input.
module Ganita_run where
open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.String using (String ; primStringAppend ; primShowNat)
open import Agda.Builtin.Nat using (Nat ; zero ; suc ; _+_)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Sigma using (_,_ ; fst ; snd)
open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (Tm ; Eq' ; eval)
open import AgamaKanda_TheEldersStoreOnTheActSide using (आगमः)
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using (दृक्पातः)
open import KalaDravya_TimeIsASubstanceInTheSameTongueAndTheMachineProvesCostAsItProvesTruth
  using (कालम् ; लाघव-नयनम्)

postulate putStrLn : String → IO ⊤
{-# FOREIGN GHC import qualified Data.Text.IO as T #-}
{-# COMPILE GHC putStrLn = T.putStrLn #-}

infixr 5 _⊹_
_⊹_ : String → String → String
_⊹_ = primStringAppend

ρ : Nat → Nat
ρ i = suc (suc i)      -- 2, 3, 4, …

स्थूल-योगः : List Eq' → Nat
स्थूल-योगः [] = zero
स्थूल-योगः ((l , _) ∷ es) = कालम् l ρ + स्थूल-योगः es

सूक्ष्म-योगः : List Eq' → Nat
सूक्ष्म-योगः [] = zero
सूक्ष्म-योगः ((l , _) ∷ es) = कालम् (दृक्पातः l) ρ + सूक्ष्म-योगः es

लाघव-योगः : List Eq' → Nat
लाघव-योगः [] = zero
लाघव-योगः ((l , _) ∷ es) = कालम् (लाघव-नयनम् l) ρ + लाघव-योगः es

main : IO ⊤
main = putStrLn
  (  "the clock over the whole inheritance at rho(i)=i+2: raw "
   ⊹ primShowNat (स्थूल-योगः आगमः)
   ⊹ " ticks, eye-optimized "
   ⊹ primShowNat (सूक्ष्म-योगः आगमः)
   ⊹ " ticks, laghava-organ "
   ⊹ primShowNat (लाघव-योगः आगमः)
   ⊹ " ticks; canonical is not cheap, and the time-organ knows the difference." )
