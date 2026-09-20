{-# OPTIONS --cubical --safe --guardedness #-}

module Fibre.CorpusSamvada where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)

import Fibre.Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers as S
import Fibre.Carrier as C

private
  variable
    ℓ : Level

Point : (ℓ : Level) → Type (ℓ-suc ℓ)
Point ℓ = Σ[ A ∈ Type ℓ ] A

point : {A : Type ℓ} → A → Point ℓ
point {A = A} a = A , a

Question : Point ℓ → Type (ℓ-suc ℓ)
Question {ℓ} s = Σ[ B ∈ Type ℓ ] (fst s → B)

target : (s : Point ℓ) → Question s → Point ℓ
target s (B , f) = B , f (snd s)

Receipt : (s : Point ℓ) → Question s → Point ℓ → Type (ℓ-suc ℓ)
Receipt s q s' = target s q ≡ s'

Event : (s : Point ℓ) (q : Question s) (s' : Point ℓ)
      → Receipt s q s' → Type (ℓ-suc ℓ)
Event _ _ _ r = r ≡ r

Corpus : Point ℓ → Type (ℓ-suc ℓ)
Corpus = S.ISC Question Receipt Event

run : (s : Point ℓ) → Corpus s
S.react (run s) q = target s q , refl , refl , run (target s q)

step : {A B : Type ℓ} (a : A) (f : A → B)
     → fst (S.react (run (point a)) (B , f)) ≡ point (f a)
step a f = refl

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

  Receiptᶜ : (c : State) → Questionᶜ c → State → Type (ℓ-suc ℓ)
  Receiptᶜ c q c' = targetᶜ c q ≡ c'

  Eventᶜ : (c : State) (q : Questionᶜ c) (c' : State)
         → Receiptᶜ c q c' → Type (ℓ-suc ℓ)
  Eventᶜ _ _ _ r = r ≡ r

  Process : State → Type (ℓ-suc ℓ)
  Process = S.ISC Questionᶜ Receiptᶜ Eventᶜ

  runᶜ : (c : State) → Process c
  S.react (runᶜ c) q = targetᶜ c q , refl , refl , runᶜ (targetᶜ c q)

  forget-step : (s : Point ℓ) (q : Question s)
              → forget (targetᶜ (embed s) q) ≡ target s q
  forget-step s q = refl

  state≃carried : Point ℓ ≃ State
  state≃carried = C.Carrier≃ read

  state≡carried : Point ℓ ≡ State
  state≡carried = C.Carrier≡ read
