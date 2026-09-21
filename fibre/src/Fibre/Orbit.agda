{-# OPTIONS --cubical --safe --guardedness #-}

-- Punarāgamana · Orbit
--
-- The infinite trajectory of an endomorphism, coinductively.  `unfold Φ a` is
-- a, Φ a, Φ² a, … as a single object rather than as a family indexed by ℕ.
--
-- The result here is that path equality of orbits IS bisimulation:
--
--   (x ≡ y)  ≃  (x ≈ y)     and hence     (x ≡ y)  ≡  (x ≈ y).
--
-- Both directions are corecursive and both round trips are, so the Iso is
-- built from four coinductive definitions rather than from a transport.
--
-- ON --guardedness UNDER --safe.  This is safe, and the pairing is the point:
-- --safe REJECTS --sized-types, and it is --sized-types and --guardedness
-- TOGETHER that are inconsistent.  --guardedness alone is fine, and the
-- cubical library itself ships --safe --guardedness modules.

module Fibre.Orbit where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence
open import Cubical.Data.Nat

private
  variable
    ℓ : Level

record Orbit (A : Type ℓ) : Type ℓ where
  coinductive
  field
    here : A
    next : Orbit A

open Orbit public

unfold : {A : Type ℓ} (Φ : A → A) → A → Orbit A
here (unfold Φ a) = a
next (unfold Φ a) = unfold Φ (Φ a)

mapO : {A B : Type ℓ} (f : A → B) → Orbit A → Orbit B
here (mapO f o) = f (here o)
next (mapO f o) = mapO f (next o)

-- Bisimulation: agreement at the head, and bisimulation of the tails.
record _≈_ {A : Type ℓ} (x y : Orbit A) : Type ℓ where
  coinductive
  field
    ≈here : here x ≡ here y
    ≈next : next x ≈ next y

open _≈_ public

bisim : {A : Type ℓ} {x y : Orbit A} → x ≈ y → x ≡ y
here (bisim p i) = ≈here p i
next (bisim p i) = bisim (≈next p) i

path→bisim : {A : Type ℓ} {x y : Orbit A} → x ≡ y → x ≈ y
≈here (path→bisim p) = λ i → here (p i)
≈next (path→bisim p) = path→bisim (λ i → next (p i))

iso1 : {A : Type ℓ} {x y : Orbit A} (p : x ≡ y) → bisim (path→bisim p) ≡ p
here (iso1 p i j) = here (p j)
next (iso1 p i j) = iso1 (λ i → next (p i)) i j

iso2 : {A : Type ℓ} {x y : Orbit A} (p : x ≈ y) → path→bisim (bisim p) ≡ p
≈here (iso2 p i) = ≈here p
≈next (iso2 p i) = iso2 (≈next p) i

-- Path equality IS bisimulation.
path≃bisim : {A : Type ℓ} {x y : Orbit A} → (x ≡ y) ≃ (x ≈ y)
path≃bisim = isoToEquiv (iso path→bisim bisim iso2 iso1)

path≡bisim : {A : Type ℓ} {x y : Orbit A} → (x ≡ y) ≡ (x ≈ y)
path≡bisim = ua path≃bisim

refl≈ : {A : Type ℓ} {x : Orbit A} → x ≈ x
≈here refl≈ = refl
≈next refl≈ = refl≈

-- The finite view: the n-th iterate, and the n-th element of an orbit.
iterate : {A : Type ℓ} (Φ : A → A) → ℕ → A → A
iterate Φ zero    a = a
iterate Φ (suc n) a = iterate Φ n (Φ a)

lookup : {A : Type ℓ} → Orbit A → ℕ → A
lookup o zero    = here o
lookup o (suc n) = lookup (next o) n

unfold-lookup : {A : Type ℓ} (Φ : A → A) (a : A) (n : ℕ)
              → lookup (unfold Φ a) n ≡ iterate Φ n a
unfold-lookup Φ a zero    = refl
unfold-lookup Φ a (suc n) = unfold-lookup Φ (Φ a) n
