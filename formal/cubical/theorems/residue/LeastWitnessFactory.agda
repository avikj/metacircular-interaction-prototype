{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module LeastWitnessFactory where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; isSetℕ)
open import Cubical.Data.Nat.Properties using (discreteℕ)
open import Cubical.Data.Nat.Order.Recursive
open import Cubical.Relation.Nullary using (Dec)
open import Cubical.HITs.PropositionalTruncation as Trunc
  using (∥_∥₁ ; ∣_∣₁)
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.List using ([] ; _∷_)

open import PolynomialRewrite
open import ProductiveIndraNet

open Minimal

MereWitness : ∀ {ℓ} → (ℕ → Type ℓ) → Type ℓ
MereWitness P = ∥ Σ ℕ P ∥₁

leastSelector : ∀ {ℓ} {P : ℕ → Type ℓ}
  → ((n : ℕ) → isProp (P n))
  → ((n : ℕ) → Dec (P n))
  → MereWitness P
  → Σ ℕ (Least P)
leastSelector proposition decide =
  Trunc.rec (isPropΣLeast proposition) (→Least decide)

leastSelector-unique : ∀ {ℓ} {P : ℕ → Type ℓ}
  (proposition : (n : ℕ) → isProp (P n))
  (decide : (n : ℕ) → Dec (P n))
  (existence : MereWitness P)
  (candidate : Σ ℕ (Least P))
  → leastSelector proposition decide existence ≡ candidate
leastSelector-unique proposition decide existence candidate =
  isPropΣLeast proposition _ candidate

canonicalPolynomial : ∀ {ℓ} {S : Signature} {P : ℕ → Type ℓ}
  → ((n : ℕ) → isProp (P n))
  → ((n : ℕ) → Dec (P n))
  → (ℕ → Term S)
  → MereWitness P
  → Term S
canonicalPolynomial proposition decide candidates existence =
  candidates (leastSelector proposition decide existence .fst)

canonicalNet : ∀ {ℓ} {Root : Type₀} {S : Signature}
  {P : ℕ → Type ℓ}
  → ((n : ℕ) → isProp (P n))
  → ((n : ℕ) → Dec (P n))
  → (ℕ → Term S)
  → MereWitness P
  → Net Root (Term S)
Net.view (canonicalNet proposition decide candidates existence) _ _ =
  canonicalPolynomial proposition decide candidates existence
Net.next (canonicalNet proposition decide candidates existence) =
  canonicalNet proposition decide candidates existence

------------------------------------------------------------------------
-- Computing finite control: a supplied witness at 2 is searched downward;
-- the selected polynomial and every productive view contain numeral 2.
------------------------------------------------------------------------

IsTwo : ℕ → Type₀
IsTwo n = n ≡ 2

isPropIsTwo : (n : ℕ) → isProp (IsTwo n)
isPropIsTwo n = isSetℕ n 2

isTwo? : (n : ℕ) → Dec (IsTwo n)
isTwo? n = discreteℕ n 2

mereTwo : MereWitness IsTwo
mereTwo = ∣ 2 , refl ∣₁

selected-two : leastSelector isPropIsTwo isTwo? mereTwo .fst ≡ 2
selected-two = refl

numeral : ℕ → Term Arithmetic
numeral zero = aZero
numeral (suc n) = aSuc (numeral n)

polynomial-two :
  canonicalPolynomial isPropIsTwo isTwo? numeral mereTwo
    ≡ aSuc (aSuc aZero)
polynomial-two = refl

productive-two :
  Net.view (canonicalNet {Root = Bool} isPropIsTwo isTwo? numeral mereTwo)
    false true
    ≡ aSuc (aSuc aZero)
productive-two = refl

productive-two-prefix :
  observe 2 (canonicalNet {Root = Bool} isPropIsTwo isTwo? numeral mereTwo)
    ≡ ((λ _ _ → aSuc (aSuc aZero)) ∷
       (λ _ _ → aSuc (aSuc aZero)) ∷ [])
productive-two-prefix = refl
