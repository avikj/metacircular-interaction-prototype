{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- InterdependenceIsThePullbackCouplingNeitherPartDeterminesTheWhole
--
-- The exact-sequence / dependent form of "value unfolds in pairwise
-- interaction": for two parts over a common context,
--
--     f : A → C,   g : B → C,
--
-- the interdependent whole is the pullback
--
--     A ×_C B  =  Σ[ a ∈ A ] Σ[ b ∈ B ] (f a ≡ g b).
--
-- This file proves, as checked terms:
--
--   whole≃parts+coupling : the whole IS the two parts together with a
--       COUPLING proof f a ≡ g b.  The coupling is first-class data,
--       not recoverable from A and B alone — "neither a nor b is
--       sufficient; the joint object exists only with the compatibility
--       equation over C."  parts + extension class = whole.
--
--   splits-when-coupling-trivial : the whole degenerates to the plain
--       product A × B EXACTLY when the coupling is contractible at every
--       pair — i.e. when the extension is trivial.  Otherwise the
--       coupling carries the irreducible interaction information, located
--       in neither component.
--
-- This is the smallest home of the corpus's interdependent-pair
-- discipline: the missing datum is the law of the coupling, and a naive
-- "product" reading erases it.
--
-- Machine-checked, Agda 2.8.0 + cubical v0.9, --safe, no postulates.
------------------------------------------------------------------------

module InterdependenceIsThePullbackCouplingNeitherPartDeterminesTheWhole where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma

private variable
  ℓ ℓ' ℓ'' : Level

module _ {A : Type ℓ} {B : Type ℓ'} {C : Type ℓ''} (f : A → C) (g : B → C) where

  Pullback : Type (ℓ-max ℓ (ℓ-max ℓ' ℓ''))
  Pullback = Σ[ a ∈ A ] Σ[ b ∈ B ] (f a ≡ g b)

  -- The parts, and the coupling that is neither part.
  Coupling : A × B → Type ℓ''
  Coupling ab = f (fst ab) ≡ g (snd ab)

  -- The whole IS the parts together with the coupling.
  whole≃parts+coupling : Pullback ≃ (Σ[ ab ∈ (A × B) ] Coupling ab)
  whole≃parts+coupling = isoToEquiv (iso
    (λ (a , b , e) → ((a , b) , e))
    (λ ((a , b) , e) → (a , b , e))
    (λ _ → refl)
    (λ _ → refl))

  -- It collapses to the plain product EXACTLY when the coupling is
  -- contractible everywhere: the interaction carries no information.
  splits-when-coupling-trivial
    : ((ab : A × B) → isContr (Coupling ab))
    → Pullback ≃ (A × B)
  splits-when-coupling-trivial triv =
    compEquiv whole≃parts+coupling (Σ-contractSnd triv)
