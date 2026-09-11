{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module CorpusCalculus where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Prashna_TheInteractiveMachineStrictlyContainsTheTuringMachineAndDeterminismIsExactlyTheCollapse
  using (ISC ; respond)

Point : (ℓ : Level) → Type (ℓ-suc ℓ)
Point ℓ = Σ[ A ∈ Type ℓ ] A

point : {ℓ : Level} {A : Type ℓ} → A → Point ℓ
point {A = A} a = A , a

Question : {ℓ : Level} → Point ℓ → Type (ℓ-suc ℓ)
Question {ℓ} s = Σ[ B ∈ Type ℓ ] (fst s → B)

target : {ℓ : Level} (s : Point ℓ) → Question s → Point ℓ
target s (B , f) = B , f (snd s)

Event : {ℓ : Level} (s : Point ℓ) → Question s → Point ℓ → Type (ℓ-suc ℓ)
Event s q s' = target s q ≡ s'

CorpusISC : {ℓ : Level} → Point ℓ → Type (ℓ-suc ℓ)
CorpusISC {ℓ} = ISC (Point ℓ) Question Event

run : {ℓ : Level} (s : Point ℓ) → CorpusISC s
respond (run s) q = target s q , refl , run (target s q)

step : {ℓ : Level} {A B : Type ℓ} (a : A) (f : A → B)
  → fst (respond (run (point a)) (B , f)) ≡ point (f a)
step a f = refl

twoSteps : {ℓ : Level} {A B C : Type ℓ}
  (a : A) (f : A → B) (g : B → C)
  → target (target (point a) (B , f)) (C , g) ≡ point (g (f a))
twoSteps a f g = refl
