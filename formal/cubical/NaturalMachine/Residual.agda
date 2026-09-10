{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- ϱ : THE RESIDUAL, AND Γ↝ : THE FIFTH RESPONSE
--
--   δ ≢ 0                 ↦ ★   (no bridge; Γ∅ Γ⇑ Γ↻ Γ^ apply)
--   δ ≡ 0 ∧ ϱ ≡ 0         ↦ ↻   (bridged, flat; classification complete)
--   δ ≡ 0 ∧ ϱ ≢ 0         ↦ ↝   (bridged, not flat; मार्गान्तरम्)
--
-- ϱ = wHere ⊖ detour: the residual is invisible to every equivalence-
-- invariant response, because `Edge` carries `cost` in a field the maps do
-- not determine.  `no-invariant-response-sees-ϱ` is that statement, proved.
--
-- Γ↝ = min-plus over neighbours (`DSOMinPlusFinite`, `DSOBellmanFinite` are
-- the same operator on other data).  It never loses, and when it wins it
-- exhibits a strictly better presentation.

module NaturalMachine.Residual where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; snotz)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ¬-<-zero ; ¬m<m ; ≤-trans)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.CostGeometry

--------------------------------------------------------------------------
-- 0.  Truncated difference
--------------------------------------------------------------------------

_⊖_ : ℕ → ℕ → ℕ
n ⊖ zero = n
zero ⊖ suc m = zero
suc n ⊖ suc m = n ⊖ m

⊖≡0→≤ : (m n : ℕ) → m ⊖ n ≡ 0 → m ≤ n
⊖≡0→≤ zero n _ = zero-≤
⊖≡0→≤ (suc m) zero p = ⊥.rec (snotz p)
⊖≡0→≤ (suc m) (suc n) p = suc-≤-suc (⊖≡0→≤ m n p)

≤→⊖≡0 : (m n : ℕ) → m ≤ n → m ⊖ n ≡ 0
≤→⊖≡0 zero zero _ = refl
≤→⊖≡0 zero (suc n) _ = refl
≤→⊖≡0 (suc m) zero p = ⊥.rec (¬-<-zero p)
≤→⊖≡0 (suc m) (suc n) p = ≤→⊖≡0 m n (pred-≤-pred p)

⊖-suc→< : (m n k : ℕ) → m ⊖ n ≡ suc k → n < m
⊖-suc→< zero zero k p = ⊥.rec (snotz (sym p))
⊖-suc→< zero (suc n) k p = ⊥.rec (snotz (sym p))
⊖-suc→< (suc m) zero k p = suc-≤-suc zero-≤
⊖-suc→< (suc m) (suc n) k p = suc-≤-suc (⊖-suc→< m n k p)

--------------------------------------------------------------------------
-- 1.  δ ≡ 0 is a checked round trip; ϱ is what survives it
--------------------------------------------------------------------------

Bridge : (A B : Presentation) → Type₀
Bridge A B = Edge A B × Edge B A

ϱ : {A B : Presentation} → Bridge A B → Work → Work → ℕ
ϱ (out , back) wHere wThere = wHere ⊖ detour out back wThere

--------------------------------------------------------------------------
-- 2.  The ternary branch
--------------------------------------------------------------------------

data Branch : Type₀ where
  ★ : Branch
  ↻ : Branch
  ↝ : Branch

branchOf : ℕ → Branch
branchOf zero = ↻
branchOf (suc _) = ↝

respond : {A B : Presentation} → Maybe (Bridge A B) → Work → Work → Branch
respond nothing _ _ = ★
respond (just b) wHere wThere = branchOf (ϱ b wHere wThere)

is↝ : Branch → Type₀
is↝ ★ = ⊥
is↝ ↻ = ⊥
is↝ ↝ = Unit

is↻ : Branch → Type₀
is↻ ★ = ⊥
is↻ ↻ = Unit
is↻ ↝ = ⊥

branchOf-↻ : (k : ℕ) → branchOf k ≡ ↻ → k ≡ 0
branchOf-↻ zero _ = refl
branchOf-↻ (suc k) p = ⊥.rec (subst is↝ p tt)

branchOf-↝ : (k : ℕ) → branchOf k ≡ ↝ → Σ[ j ∈ ℕ ] k ≡ suc j
branchOf-↝ zero p = ⊥.rec (subst is↻ p tt)
branchOf-↝ (suc k) _ = k , refl

--------------------------------------------------------------------------
-- 3.  The branch is exactly the cost geometry
--------------------------------------------------------------------------

↻-is-flat :
    {A B : Presentation} (b : Bridge A B) (wHere wThere : Work)
  → respond (just b) wHere wThere ≡ ↻
  → NoSpeedup (fst b) (snd b) wHere wThere
↻-is-flat (out , back) wHere wThere p =
  ⊖≡0→≤ wHere (detour out back wThere)
        (branchOf-↻ (wHere ⊖ detour out back wThere) p)

↝-is-speedup :
    {A B : Presentation} (b : Bridge A B) (wHere wThere : Work)
  → respond (just b) wHere wThere ≡ ↝
  → Speedup (fst b) (snd b) wHere wThere
↝-is-speedup (out , back) wHere wThere p =
  ⊖-suc→< wHere (detour out back wThere)
          (fst witness) (snd witness)
  where
    witness : Σ[ j ∈ ℕ ] (wHere ⊖ detour out back wThere) ≡ suc j
    witness = branchOf-↝ (wHere ⊖ detour out back wThere) p

-- ↝ has a target: the far presentation is strictly better at the work.
↝-forces-better-presentation :
    {A B : Presentation} (b : Bridge A B) (wHere wThere : Work)
  → respond (just b) wHere wThere ≡ ↝
  → wThere < wHere
↝-forces-better-presentation b wHere wThere p =
  speedup-forces-better-neighbour (fst b) (snd b) wHere wThere
    (↝-is-speedup b wHere wThere p)

--------------------------------------------------------------------------
-- 4.  ϱ is null for every equivalence-invariant response
--------------------------------------------------------------------------

-- A response is invariant when it reads the maps and not the weights.
Invariant : ({A B : Presentation} → Bridge A B → Work → Work → Branch) → Type₁
Invariant Γ =
    {A B : Presentation} (out out' : Edge A B) (back back' : Edge B A)
  → move out ≡ move out' → move back ≡ move back'
  → (wHere wThere : Work)
  → Γ (out , back) wHere wThere ≡ Γ (out' , back') wHere wThere

respondB : {A B : Presentation} → Bridge A B → Work → Work → Branch
respondB b wHere wThere = respond (just b) wHere wThere

-- Γ∅ Γ⇑ Γ↻ Γ^ are all invariant, hence all blind here: two bridges with
-- the same maps and different weights land in different branches.
no-invariant-response-sees-ϱ : ¬ Invariant respondB
no-invariant-response-sees-ϱ inv = subst is↝ (inv cheap dear cheap dear refl refl 10 1) tt
  where
    U : Presentation
    U = pres Unit (λ _ _ → tt)

    cheap : Edge U U
    cheap = edge (λ x → x) 0

    dear : Edge U U
    dear = edge (λ x → x) 100

--------------------------------------------------------------------------
-- 5.  Γ↝ : min-plus over neighbours
--------------------------------------------------------------------------

_⊓_ : ℕ → ℕ → ℕ
zero ⊓ _ = zero
suc _ ⊓ zero = zero
suc m ⊓ suc n = suc (m ⊓ n)

⊓-≤-left : (m n : ℕ) → m ⊓ n ≤ m
⊓-≤-left zero n = zero-≤
⊓-≤-left (suc m) zero = zero-≤
⊓-≤-left (suc m) (suc n) = suc-≤-suc (⊓-≤-left m n)

⊓-≤-right : (m n : ℕ) → m ⊓ n ≤ n
⊓-≤-right zero n = zero-≤
⊓-≤-right (suc m) zero = zero-≤
⊓-≤-right (suc m) (suc n) = suc-≤-suc (⊓-≤-right m n)

⊓-split : (m n : ℕ) → (m ⊓ n ≡ m) ⊎ (m ⊓ n ≡ n)
⊓-split zero n = inl refl
⊓-split (suc m) zero = inr refl
⊓-split (suc m) (suc n) with ⊓-split m n
... | inl p = inl (cong suc p)
... | inr p = inr (cong suc p)

record Neighbour (A : Presentation) : Type₁ where
  constructor nbr
  field
    there : Presentation
    out   : Edge A there
    back  : Edge there A
    work  : Work

open Neighbour public

route : {A : Presentation} → Neighbour A → Cost
route n = detour (out n) (back n) (work n)

Γ↝ : {A : Presentation} → Work → List (Neighbour A) → Cost
Γ↝ wHere [] = wHere
Γ↝ wHere (n ∷ ns) = route n ⊓ Γ↝ wHere ns

-- (Γ1)  The fifth response never loses.
Γ↝-never-worse :
    {A : Presentation} (wHere : Work) (ns : List (Neighbour A))
  → Γ↝ wHere ns ≤ wHere
Γ↝-never-worse wHere [] = 0 , refl
Γ↝-never-worse wHere (n ∷ ns) =
  ≤-trans (⊓-≤-right (route n) (Γ↝ wHere ns)) (Γ↝-never-worse wHere ns)

-- (Γ2)  When the fifth response wins, it exhibits the better presentation.
Γ↝-sound :
    {A : Presentation} (wHere : Work) (ns : List (Neighbour A))
  → Γ↝ wHere ns < wHere
  → Σ[ n ∈ Neighbour A ] (work n < wHere)
Γ↝-sound wHere [] lt = ⊥.rec (¬m<m lt)
Γ↝-sound wHere (n ∷ ns) lt with ⊓-split (route n) (Γ↝ wHere ns)
... | inr p = Γ↝-sound wHere ns (subst (_< wHere) p lt)
... | inl p =
      n , speedup-forces-better-neighbour (out n) (back n) wHere (work n)
            (subst (_< wHere) p lt)

-- CHECKED: Agda 2.6.3, cubical **v0.7** (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9), nor against the v0.5
-- the rest of this lane's headers quote: three toolchain states are live in
-- this repository at once and this file has only seen one of them.
