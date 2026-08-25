{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FutureSeparation
--
-- Witnessed inequality for FutureBehavior.  A future separator is one
-- finite action word held in hand.  For Bool observations, failure of
-- FutureEq yields such a separator only under double negation.  Markov's
-- Principle removes the double negation when an explicit countable chart of
-- action words is supplied; arbitrary Action has no such chart by default.
------------------------------------------------------------------------

module FutureSeparation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.List using (List; _∷_)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_; yes; no)
open import FutureBehavior
open import Apoha
  using (MP; eqB; eqB→≡; ≡→eqB; ¬false≡true)

private
  variable
    ℓX ℓA ℓO : Level
    X : Type ℓX
    A : Type ℓA
    O : Type ℓO

-- A finite experiment that distinguishes the two states.
FutureSep : {ℓX ℓA ℓO : Level}
  {X : Type ℓX} {A : Type ℓA} {O : Type ℓO}
  → (X → A → X) → (X → O) → X → X
  → Type (ℓ-max ℓA ℓO)
FutureSep {A = A} step observe x y =
  Σ[ w ∈ List A ]
    (¬ (behavior step observe x w ≡ behavior step observe y w))

futureSep→¬futureEq : (step : X → A → X) (observe : X → O) {x y : X}
  → FutureSep step observe x y → ¬ FutureEq step observe x y
futureSep→¬futureEq step observe (w , differs) same = differs (same w)

futureEq→¬futureSep : (step : X → A → X) (observe : X → O) {x y : X}
  → FutureEq step observe x y → ¬ FutureSep step observe x y
futureEq→¬futureSep step observe same (w , differs) = differs (same w)

-- A distinction after taking action a is already a distinction of the
-- parent states, witnessed by prefixing a to the experiment.
childSep→parentSep : (step : X → A → X) (observe : X → O) {x y : X}
  → (a : A)
  → FutureSep step observe (step x a) (step y a)
  → FutureSep step observe x y
childSep→parentSep step observe a (w , differs) = a ∷ w , differs

-- Bool equality is stable at each fixed word.  Consequently the negative
-- form and witnessed form differ by exactly one double negation even when
-- the action alphabet itself has no enumeration.
¬futureSep→futureEqBool : (step : X → A → X) (observe : X → Bool) {x y : X}
  → ¬ FutureSep step observe x y → FutureEq step observe x y
¬futureSep→futureEqBool step observe {x} {y} noSep w
  with behavior step observe x w ≟ behavior step observe y w
... | yes p = p
... | no d  = ⊥.rec (noSep (w , d))

¬futureEq→¬¬futureSepBool :
    (step : X → A → X) (observe : X → Bool) {x y : X}
  → ¬ FutureEq step observe x y → ¬ ¬ FutureSep step observe x y
¬futureEq→¬¬futureSepBool step observe notSame noSep =
  notSame (¬futureSep→futureEqBool step observe noSep)

------------------------------------------------------------------------
-- MP applies only after a countable chart covers every action word.
------------------------------------------------------------------------

MP→enumeratedFutureSep :
    (mp : MP)
    (step : X → A → X) (observe : X → Bool) {x y : X}
    (enumerate : ℕ → List A)
    (covers : (w : List A) → Σ[ n ∈ ℕ ] enumerate n ≡ w)
  → ¬ FutureEq step observe x y
  → FutureSep step observe x y
MP→enumeratedFutureSep mp step observe {x} {y} enumerate covers notSame =
  enumerate n , differs
  where
    test : ℕ → Bool
    test k = eqB
      (behavior step observe x (enumerate k))
      (behavior step observe y (enumerate k))

    notAllTrue : ¬ ((k : ℕ) → test k ≡ true)
    notAllTrue allTrue = notSame allWordsSame
      where
        allWordsSame : FutureEq step observe x y
        allWordsSame w with covers w
        ... | k , chart = subst
          (λ v → behavior step observe x v ≡ behavior step observe y v)
          chart
          (eqB→≡
            (behavior step observe x (enumerate k))
            (behavior step observe y (enumerate k))
            (allTrue k))

    found : Σ[ k ∈ ℕ ] test k ≡ false
    found = mp test notAllTrue

    n : ℕ
    n = fst found

    differs : ¬
      (behavior step observe x (enumerate n)
        ≡ behavior step observe y (enumerate n))
    differs same = ¬false≡true
      (sym (snd found) ∙
        ≡→eqB
          (behavior step observe x (enumerate n))
          (behavior step observe y (enumerate n))
          same)
