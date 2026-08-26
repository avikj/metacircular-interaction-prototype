{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- अलोप-सेतुः — the rewriting engine's invariance IS the orbit law.
--
-- `NaturalMachine/Alopa_TheEngineNeverTouchesTheMeaning.agda` proves
-- `step-sound : eval ρ (step rs t) ≡ eval ρ t` and then does its own
-- induction on n to reach `अलोपः : eval ρ (normalize n rs t) ≡ eval ρ t`.
-- That second half is `Kaksya_….ध्रुवं-कक्ष्यायाम्` at (eval ρ, step rs):
-- step-sound IS संरक्षणम्, and the induction is already proved once for
-- every observable and every endomorphism.
--
-- The only real content of the bridge is that the two iteration orders
-- differ -- normalize steps THEN recurses, कक्ष्या recurses THEN steps --
-- so §२ proves they commute.
--
-- CHECKED: Agda 2.6.3 + cubical v0.5, --safe, exit 0.

module Alopasetu_TheEnginesInvarianceIsTheOrbitLawInstantiatedAndNotASeparateInduction where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List)

open import Alopa_TheEngineNeverTouchesTheMeaning
  using (Term ; Env ; Rule ; eval ; step ; normalize ; step-sound)
open import Kaksya_TheChargeIsConstantAlongTheWholeOrbitAndNotOnlyAcrossOneStep
  using (कक्ष्या ; ध्रुवं-कक्ष्यायाम्)
open import Dhruva_TheSymmetryLivesInTheFiberAndWithoutALossThereIsNoSymmetry
  using (संरक्षणम्)

module _ (rs : List Rule) (ρ : Env) where

  -- १ · step-sound IS conservation, on the nose.
  संरक्षणम्-इति-step-sound : संरक्षणम् (eval ρ) (step rs)
  संरक्षणम्-इति-step-sound = step-sound rs ρ

  -- २ · the two iteration orders agree.
  कक्ष्या-step : (n : ℕ) (t : Term)
              → कक्ष्या (eval ρ) (step rs) n (step rs t)
              ≡ step rs (कक्ष्या (eval ρ) (step rs) n t)
  कक्ष्या-step zero    t = refl
  कक्ष्या-step (suc n) t = cong (step rs) (कक्ष्या-step n t)

  normalize-इति-कक्ष्या : (n : ℕ) (t : Term)
                        → normalize n rs t ≡ कक्ष्या (eval ρ) (step rs) n t
  normalize-इति-कक्ष्या zero    t = refl
  normalize-इति-कक्ष्या (suc n) t =
    normalize-इति-कक्ष्या n (step rs t) ∙ कक्ष्या-step n t

  -- ३ · and therefore the engine's अलोपः is the orbit law instantiated,
  --     with no induction of its own.
  अलोपः-इति-ध्रुवम् : (n : ℕ) (t : Term)
                    → eval ρ (normalize n rs t) ≡ eval ρ t
  अलोपः-इति-ध्रुवम् n t =
    cong (eval ρ) (normalize-इति-कक्ष्या n t)
    ∙ ध्रुवं-कक्ष्यायाम् (eval ρ) (step rs) संरक्षणम्-इति-step-sound n t
