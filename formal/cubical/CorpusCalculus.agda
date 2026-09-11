{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module CorpusCalculus where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Prashna_TheInteractiveMachineStrictlyContainsTheTuringMachineAndDeterminismIsExactlyTheCollapse
  using (ISC ; respond)

-- A corpus point is nothing but an Agda type together with an inhabitant.
-- Every checked declaration d : A enters without re-encoding as (A , d).
Point : (ℓ : Level) → Type (ℓ-suc ℓ)
Point ℓ = Σ[ A ∈ Type ℓ ] A

point : {ℓ : Level} {A : Type ℓ} → A → Point ℓ
point {A = A} a = A , a

-- The questions available at (A , a) are exactly the typed maps out of A.
-- No semantic class of relation is introduced: an Agda function is the action.
Question : {ℓ : Level} → Point ℓ → Type (ℓ-suc ℓ)
Question {ℓ} s = Σ[ B ∈ Type ℓ ] (fst s → B)

target : {ℓ : Level} (s : Point ℓ) → Question s → Point ℓ
target s (B , f) = B , f (snd s)

-- A transition is licensed by the ordinary identity saying that its successor
-- is exactly the result of applying the supplied Agda map.
Event : {ℓ : Level} (s : Point ℓ) → Question s → Point ℓ → Type (ℓ-suc ℓ)
Event s q s' = target s q ≡ s'

CorpusISC : {ℓ : Level} → Point ℓ → Type (ℓ-suc ℓ)
CorpusISC {ℓ} = ISC (Point ℓ) Question Event

-- The corpus executes every typed map by ordinary Agda reduction, returns the
-- exact successor with refl as receipt, and continues coinductively at it.
run : {ℓ : Level} (s : Point ℓ) → CorpusISC s
respond (run s) q = target s q , refl , run (target s q)

-- One interaction is definitionally application of the raw checked term.
step : {ℓ : Level} {A B : Type ℓ} (a : A) (f : A → B)
  → fst (respond (run (point a)) (B , f)) ≡ point (f a)
step a f = refl

-- Composition is not an added corpus edge: two interactions reduce to
-- ordinary function composition on the underlying checked terms.
twoSteps : {ℓ : Level} {A B C : Type ℓ}
  (a : A) (f : A → B) (g : B → C)
  → target (target (point a) (B , f)) (C , g) ≡ point (g (f a))
twoSteps a f g = refl
