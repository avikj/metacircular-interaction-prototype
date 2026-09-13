{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module CorpusBehavioralMeaning where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Nat using (ℕ ; isSetℕ)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.HITs.SetQuotients using ([_])
open import Agda.Builtin.Reflection using (Term)

import FutureBehavior as FB
import ReflectedFormation as RF
import Fibre.CorpusReflection as CR

-- The checked reflected mathematical expression itself is the state.
-- An action selects a child address; observation is the syntax constructor.
-- FutureEq therefore identifies exactly those formed expressions with the
-- same complete structural future under every finite navigation word.
module Q = FB.FutureQuotient RF.child isSetℕ RF.headCode

Meaning : Type₀
Meaning = Q.Meaning

meaning : Term → Meaning
meaning t = [ t ]

RealizationFiber : Meaning → Type₀
RealizationFiber = fiber meaning

Presented : Type₀
Presented = Σ[ m ∈ Meaning ] RealizationFiber m

present : Term → Presented
present t = meaning t , t , refl

-- The expanded reflected corpus maps into the quotient presentation; repeated
-- future behavior is represented by one Meaning, while the exact originating
-- term remains in its realization fibre.
typeTerms : CR.RawCorpus → List Term
typeTerms [] = []
typeTerms ((_ , ty , _) ∷ ds) = ty ∷ typeTerms ds

presentAll : List Term → List Presented
presentAll [] = []
presentAll (t ∷ ts) = present t ∷ presentAll ts

presentCorpus : CR.RawCorpus → List Presented
presentCorpus c = presentAll (typeTerms c)
