{-# OPTIONS --cubical --safe --guardedness #-}
module Ratri.Nirdharita_VivekaPramana_TheRemainderIsLawfulAndTheNetBeats_ where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
open import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats
open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Data.Nat using (ℕ ; _+_ ; isSetℕ)
open import Cubical.Data.Sigma using (Σ ; _,_)
open विवेक-प्रमाण public
open ▹ public
open जाल public

record CensusBase : Type where
  field
    सम : ℕ
    वाम : ℕ

censusFam : CensusBase → Type
censusFam censusB = let सम = CensusBase.सम censusB ; वाम = CensusBase.वाम censusB in ℕ

censusF : (censusB : CensusBase) → censusFam censusB
censusF censusB = let सम = CensusBase.सम censusB ; वाम = CensusBase.वाम censusB in (सम + वाम)

censusΣ : Type
censusΣ = Σ[ censusB ∈ CensusBase ] (Σ[ censusY ∈ censusFam censusB ] (censusY ≡ censusF censusB))

-- the reversed singleton is contractible too; the term is written out
-- rather than imported because the cubical library ships only the
-- forward `isContrSingl`.
censusRevContr : {A : Type} (a : A) → isContr (Σ[ y ∈ A ] (y ≡ a))
censusRevContr a = (a , refl) , λ (y , p) i → (p (~ i) , λ j → p (~ i ∨ j))

censusContract : censusΣ ≃ CensusBase
censusContract = Σ-contractSnd (λ censusB → censusRevContr (censusF censusB))

censusTo : विवेक-प्रमाण → censusΣ
censusTo censusR =
  record { सम = विवेक-प्रमाण.सम censusR ; वाम = विवेक-प्रमाण.वाम censusR } , ( विवेक-प्रमाण.दक्षिण censusR , विवेक-प्रमाण.प्रमाण censusR )

censusFrom : censusΣ → विवेक-प्रमाण
censusFrom (censusB , (censusY , censusP)) =
  record { सम = CensusBase.सम censusB ; वाम = CensusBase.वाम censusB ; दक्षिण = censusY ; प्रमाण = censusP }

censusReshuffle : Iso (विवेक-प्रमाण) censusΣ
Iso.fun      censusReshuffle = censusTo
Iso.inv      censusReshuffle = censusFrom
Iso.rightInv censusReshuffle _ = refl
Iso.leftInv  censusReshuffle _ = refl

-- THE VERDICT.  Green here is the equivalence itself.
DETERMINED : (विवेक-प्रमाण) ≃ CensusBase
DETERMINED = compEquiv (isoToEquiv censusReshuffle) censusContract
