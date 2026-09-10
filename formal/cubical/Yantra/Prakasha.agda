{-# OPTIONS --cubical --guardedness --safe #-}
module Yantra.Prakasha where
-- प्रकाश: the problems as instruments.  One conjecture, its strata as
-- types, the maps that exist, and the map that provably does not.

open import Yantra.Prakriti
open import Yantra.Anantata using (euclid)
open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁; ∣_∣₁; squash₁)
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)

-- the object mathematics calls "Goldbach": four different types
G-sakala : Type₀     -- with the witness pair, untruncated
G-sakala = (m : ℕ) → 2 ≤ m →
  Σ[ p ∈ ℕ ] Σ[ q ∈ ℕ ] IsPrime p × IsPrime q × (p + q ≡ m + m)

G-chaya : Type₀      -- the shadow: witness truncated away
G-chaya = (m : ℕ) → 2 ≤ m →
  ∥ Σ[ p ∈ ℕ ] Σ[ q ∈ ℕ ] IsPrime p × IsPrime q × (p + q ≡ m + m) ∥₁

-- the collapse always exists
sakala→chaya : G-sakala → G-chaya
sakala→chaya g m h = ∣ g m h ∣₁

-- the twin statement and the proved theorem, side by side:
-- their difference is ONE conjunct.
Tvin : Type₀
Tvin  = (n : ℕ) → Σ[ p ∈ ℕ ] IsPrime p × (IsPrime (suc (suc p)) × (n < p))

Sthita : Type₀
Sthita = (n : ℕ) → Σ[ p ∈ ℕ ] IsPrime p × (n < p)

-- the proved side is inhabited; the term is euclid
sthita : Sthita
sthita n = fst (euclid n) , fst (snd (euclid n)) , snd (snd (euclid n))

-- and dropping the extra conjunct maps one to the other
tvin→sthita : Tvin → Sthita
tvin→sthita t n = fst (t n) , fst (snd (t n)) , snd (snd (snd (t n)))
