{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module CorpusSamvada where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)

import Fibre.Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers as S
import Fibre.Carrier as C

private
  variable
    ℓ : Level

-- Raw mathematics, with no corpus ontology: a state is just a type together
-- with one of its checked inhabitants.
Point : (ℓ : Level) → Type (ℓ-suc ℓ)
Point ℓ = Σ[ A ∈ Type ℓ ] A

point : {A : Type ℓ} → A → Point ℓ
point {A = A} a = A , a

-- What may be asked of (A , a) is exactly a checked typed map out of A.
Question : Point ℓ → Type (ℓ-suc ℓ)
Question s = Σ[ B ∈ Type ℓ ] (fst s → B)

target : (s : Point ℓ) → Question s → Point ℓ
target s (B , f) = B , f (snd s)

-- The observable of a transition is the receipt that the successor really is
-- the typed application.  The event datum retains that receipt proof-relevantly.
Observation : (s : Point ℓ) → Question s → Point ℓ → Type (ℓ-suc ℓ)
Observation s q s' = target s q ≡ s'

Event : (s : Point ℓ) (q : Question s) (s' : Point ℓ)
      → Observation s q s' → Type (ℓ-suc ℓ)
Event _ _ _ receipt = receipt ≡ receipt

Corpus : Point ℓ → Type (ℓ-suc ℓ)
Corpus = S.ISC Question Observation Event

-- The entire future interaction is one guarded coinductive object.  No depth,
-- search frontier, scheduler, fixed-point loop, or external normalisation.
run : (s : Point ℓ) → Corpus s
S.react (run s) q = target s q , refl , refl , run (target s q)

-- One interaction is ordinary application definitionally.
step : {A B : Type ℓ} (a : A) (f : A → B)
     → S.visit (λ _ → B , f) (run (point a)) ≡ point (f a)
step a f = refl

------------------------------------------------------------------------
-- Lossless representation of the whole interactive state.
------------------------------------------------------------------------

module Carried {B : Type (ℓ-suc ℓ)} (read : Point ℓ → B) where

  State : Type (ℓ-suc ℓ)
  State = C.Carrier read

  embed : Point ℓ → State
  embed = C.descend read

  forget : State → Point ℓ
  forget = C.ascend read

  Questionᶜ : State → Type (ℓ-suc ℓ)
  Questionᶜ c = Question (forget c)

  targetᶜ : (c : State) → Questionᶜ c → State
  targetᶜ c q = embed (target (forget c) q)

  Observationᶜ : (c : State) → Questionᶜ c → State → Type (ℓ-suc ℓ)
  Observationᶜ c q c' = targetᶜ c q ≡ c'

  Eventᶜ : (c : State) (q : Questionᶜ c) (c' : State)
         → Observationᶜ c q c' → Type (ℓ-suc ℓ)
  Eventᶜ _ _ _ receipt = receipt ≡ receipt

  Process : State → Type (ℓ-suc ℓ)
  Process = S.ISC Questionᶜ Observationᶜ Eventᶜ

  runᶜ : (c : State) → Process c
  S.react (runᶜ c) q = targetᶜ c q , refl , refl , runᶜ (targetᶜ c q)

  -- Forgetting after a carried step is exactly the original typed step.
  forget-step : (s : Point ℓ) (q : Question s)
              → forget (targetᶜ (embed s) q) ≡ target s q
  forget-step s q = refl

  -- Carrying contributes no independent state: this is the existing theorem,
  -- now instantiated at the corpus state itself.
  state≃carried : Point ℓ ≃ State
  state≃carried = C.Carrier≃ read

  state≡carried : Point ℓ ≡ State
  state≡carried = C.Carrier≡ read
