{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.DSOContinuationFullAbstract where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; min)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (Σ ; _,_)
import NaturalMachine.DSOFinite as D

-- Extended natural costs.  Infinity is structural unreachability, not a large
-- sentinel chosen by a benchmark.
data Cost : Type₀ where
  fin : ℕ → Cost
  ∞ : Cost

_⊗_ : Cost → Cost → Cost
fin m ⊗ fin n = fin (m + n)
fin m ⊗ ∞ = ∞
∞ ⊗ c = ∞

minC : Cost → Cost → Cost
minC (fin m) (fin n) = fin (min m n)
minC (fin m) ∞ = fin m
minC ∞ c = c

Relation : Type₀
Relation = Bool → Bool → Cost

Continuation : Type₀
Continuation = Bool → Cost

bellman : Relation → Continuation → Continuation
bellman K V a = minC (K a false ⊗ V false) (K a true ⊗ V true)

_⋆_ : Relation → Relation → Relation
(K ⋆ L) a c = minC (K a false ⊗ L false c) (K a true ⊗ L true c)

dirac : Bool → Continuation
dirac false false = fin zero
dirac false true = ∞
dirac true false = ∞
dirac true true = fin zero

⊗-zero-right : (c : Cost) → c ⊗ fin zero ≡ c
⊗-zero-right (fin n) = cong fin (+-zero n)
  where
  +-zero : (m : ℕ) → m + zero ≡ m
  +-zero zero = refl
  +-zero (suc m) = cong suc (+-zero m)
⊗-zero-right ∞ = refl

⊗-∞-right : (c : Cost) → c ⊗ ∞ ≡ ∞
⊗-∞-right (fin n) = refl
⊗-∞-right ∞ = refl

min-∞-right : (c : Cost) → minC c ∞ ≡ c
min-∞-right (fin n) = refl
min-∞-right ∞ = refl

-- Dirac continuations recover every matrix entry.  Therefore the Bellman
-- transformer loses no information about a finite cost relation.
dirac-reconstruct : (K : Relation) (a c : Bool)
  → bellman K (dirac c) a ≡ K a c
dirac-reconstruct K a false =
  cong₂ minC (⊗-zero-right (K a false)) (⊗-∞-right (K a true))
    ∙ min-∞-right (K a false)
dirac-reconstruct K a true with K a false | K a true
... | fin m | fin n = ⊗-zero-right (fin n)
... | fin m | ∞ = refl
... | ∞ | fin n = ⊗-zero-right (fin n)
... | ∞ | ∞ = refl

-- Full abstraction: equality on all continuations implies equality of the
-- underlying relation, because Dirac tests expose each entry.
transformer-full-abstraction : (K L : Relation)
  → ((V : Continuation) (a : Bool) → bellman K V a ≡ bellman L V a)
  → K ≡ L
transformer-full-abstraction K L same = funExt λ a → funExt λ c →
  sym (dirac-reconstruct K a c) ∙ same (dirac c) a ∙ dirac-reconstruct L a c

-- Identity is the Dirac cost relation; min-plus composition preserves it.
identity : Relation
identity false false = fin zero
identity false true = ∞
identity true false = ∞
identity true true = fin zero

⋆-identity-right : (K : Relation) → K ⋆ identity ≡ K
⋆-identity-right K = funExt λ a → funExt λ
  { false → dirac-reconstruct K a false
  ; true → dirac-reconstruct K a true }

-- Proof-relevant active witnesses: argmin returns the interface that realizes
-- the Bellman value, not only the scalar consequence.
Active : Relation → Continuation → Bool → Bool → Type₀
Active K V a b = bellman K V a ≡ K a b ⊗ V b

record Argmin (K : Relation) (V : Continuation) (a : Bool) : Type₀ where
  constructor active
  field
    witness : Bool
    realizes : Active K V a witness

-- Lift the existing checked premature-argmin control into extended costs.
Kᵉ Lᵉ : Relation
Kᵉ a b = fin (D.K a b)
Lᵉ a b = fin (D.L a b)

terminalFalse : Continuation
terminalFalse false = fin zero
terminalFalse true = ∞

global-active : Argmin Kᵉ (bellman Lᵉ terminalFalse) false
global-active = active true refl

local-active : Argmin Kᵉ (λ _ → fin zero) false
local-active = active false refl

active-witnesses-differ : (Argmin.witness local-active ≡ Argmin.witness global-active) → ⊥
active-witnesses-differ p = false≠true p
  where
  false≠true : (false ≡ true) → ⊥
  false≠true p = subst Disc p tt
    where
    Disc : Bool → Type₀
    Disc false = Unit
    Disc true = ⊥

-- Bellman composition is executable functoriality on the planted control:
-- composing relations first equals transforming the continuation in stages.
bellman-composition-control :
  bellman (Kᵉ ⋆ Lᵉ) terminalFalse false
    ≡ bellman Kᵉ (bellman Lᵉ terminalFalse) false
bellman-composition-control = refl

premature-local-argmin :
  Kᵉ false (Argmin.witness local-active) ≡ fin zero
premature-local-argmin = refl

global-needs-locally-nonminimal :
  Argmin.witness global-active ≡ true
global-needs-locally-nonminimal = refl
