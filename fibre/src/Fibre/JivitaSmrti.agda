{-# OPTIONS --cubical --safe --guardedness #-}
-- जीविता-स्मृति — the living memory.
--
-- The carried observable of the INFINITE orbit is recomputed at every depth,
-- never a stale payload: at depth n it is exactly योग of the n-th state.
-- Losslessness read forward through an infinite trajectory — the carried
-- datum is उपयोग (alive) at every rung of the coinductive orbit.
module Fibre.JivitaSmrti where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (_×_)
open import Fibre.Orbit using (lookup ; iterate)
open import Fibre.Viveka

कर्ण-योग : (y : ℕ × ℕ) → दक्षिण (अवतरण y) ≡ योग y
कर्ण-योग y = refl

जीविता-स्मृति : (x : ℕ × ℕ) (n : ℕ)
             → दक्षिण (lookup (आरम्भ x) n) ≡ योग (iterate Φ n x)
जीविता-स्मृति x n =
  cong दक्षिण (अनन्त-निरीक्षण x n) ∙ कर्ण-योग (iterate Φ n x)
