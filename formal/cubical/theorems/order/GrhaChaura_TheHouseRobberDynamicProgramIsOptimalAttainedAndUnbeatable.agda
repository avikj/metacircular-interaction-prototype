{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- गृहचौर — THE HOUSE ROBBER DYNAMIC PROGRAM IS OPTIMAL: ATTAINED AND
-- UNBEATABLE.
--
-- Checked at the pin: Agda 2.8.0, agda/cubical v0.9 -- EXIT 0
-- (2026-08-29), --safe.  HONEST NOTE: `opt`/`optG` match on `Sel`/`Gap`
-- whose indices are the house list, so Agda emits
-- -W UnsupportedIndexedMatch — these two functions will not COMPUTE on a
-- transported selection.  It is a warning, not an error; the proofs are
-- accepted under --safe, and nothing here transports a selection, so the
-- non-computation is never triggered.  The corpus elsewhere avoids this
-- by recursion over lists rather than indexed matching; that refactor is
-- available and not done here.
--
-- THE PROBLEM (LeetCode 198, "House Robber").  A row of houses, each
-- holding some money; you may take from a set of houses no two of
-- which are adjacent; maximise the total taken.  The textbook linear
-- dynamic program is
--     rob []        = 0
--     rob (x ∷ xs)  = max (rob xs) (x + robTail xs)
--     robTail (y ∷ ys) = rob ys        -- taking x forbids its neighbour
-- and everyone "knows" it is optimal.  This module proves it, in full,
-- as a checked term — optimality, not merely correctness.
--
-- OPTIMALITY IS TWO THEOREMS, and both are here.  A `Sel xs` is a legal
-- selection over the houses `xs` (the `take`/`Gap` structure makes "no
-- two adjacent" a thing you cannot even write down illegally), and
-- `value` sums what it takes.  Then:
--
--   · opt   (∀ s → value s ≤ rob xs)          — the LOWER BOUND: no
--           legal selection beats the program.  Nothing does better.
--   · attain (Σ s , value s ≡ rob xs)         — the program's number is
--           actually achieved by a legal selection; it is not an
--           unreachable overestimate.
--
-- Together (`robber-optimal`): rob xs is the maximum, attained, over
-- every legal selection.  That conjunction is exactly what "optimal
-- solution" means, and it is a finite certificate — which is why this
-- kernel can hold it.
--
-- METHOD.  `max` and its two projection bounds are the kernel's own
-- (`left-≤-max`, `right-≤-max`); `max-cases` — the fact that a `max` is
-- one of its two arguments — is the only lemma this proof adds, and it
-- is what turns the upper bound into an attained optimum.  The order is
-- the library's Σ-based `_≤_`, so transitivity and monotonicity are the
-- standard lemmas, not re-derived.
--
-- SYĀT.  This proves House Robber optimal — that named program, that
-- selection structure.  It does not prove any universal "every DP is so
-- certified"; it is one real instance carried to the end, exhibiting
-- that optimality (lower bound included) is a checkable object for a
-- genuine algorithm, not only for a toy.
------------------------------------------------------------------------

module GrhaChaura_TheHouseRobberDynamicProgramIsOptimalAttainedAndUnbeatable where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Order
  using (_≤_ ; ≤-trans ; zero-≤ ; ≤-k+ ; left-≤-max ; right-≤-max)
open import Cubical.Data.Nat.Properties using (max)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)

------------------------------------------------------------------------
-- §1  The dynamic program.
------------------------------------------------------------------------

rob     : List ℕ → ℕ
robTail : List ℕ → ℕ

rob []        = zero
rob (x ∷ xs)  = max (rob xs) (x + robTail xs)

robTail []       = zero
robTail (y ∷ ys) = rob ys

------------------------------------------------------------------------
-- §2  Legal selections: no two chosen houses adjacent, by construction.
--     `Sel xs` may take or skip its head; `Gap xs` is a selection whose
--     head is FORCED to be skipped (the slot right after a taken house).
------------------------------------------------------------------------

data Sel : List ℕ → Type
data Gap : List ℕ → Type

data Sel where
  ε    : Sel []
  skip : {x : ℕ} {xs : List ℕ} → Sel xs → Sel (x ∷ xs)
  take : {x : ℕ} {xs : List ℕ} → Gap xs → Sel (x ∷ xs)

data Gap where
  gε    : Gap []
  gskip : {y : ℕ} {ys : List ℕ} → Sel ys → Gap (y ∷ ys)

value : {xs : List ℕ} → Sel xs → ℕ
gval  : {xs : List ℕ} → Gap xs → ℕ

value ε            = zero
value (skip s)     = value s
value (take {x} g) = x + gval g

gval gε        = zero
gval (gskip s) = value s

------------------------------------------------------------------------
-- §3  THE LOWER BOUND.  No legal selection beats the program.
------------------------------------------------------------------------

opt  : (xs : List ℕ) (s : Sel xs) → value s ≤ rob xs
optG : (xs : List ℕ) (g : Gap xs) → gval g ≤ robTail xs

opt []       ε        = zero-≤
opt (x ∷ xs) (skip s) = ≤-trans (opt xs s) left-≤-max
opt (x ∷ xs) (take g) = ≤-trans (≤-k+ (optG xs g)) right-≤-max

optG []       gε         = zero-≤
optG (y ∷ ys) (gskip s)  = opt ys s

------------------------------------------------------------------------
-- §4  The one added lemma: a max is one of its two arguments.
------------------------------------------------------------------------

max-cases : (a b : ℕ) → (max a b ≡ a) ⊎ (max a b ≡ b)
max-cases zero    b       = inr refl
max-cases (suc a) zero    = inl refl
max-cases (suc a) (suc b) with max-cases a b
... | inl p = inl (cong suc p)
... | inr p = inr (cong suc p)

------------------------------------------------------------------------
-- §5  ATTAINABILITY.  The program's number is achieved by a legal
--     selection — take whichever branch of the max actually won.
------------------------------------------------------------------------

attain  : (xs : List ℕ) → Σ[ s ∈ Sel xs ] (value s ≡ rob xs)
attainG : (xs : List ℕ) → Σ[ g ∈ Gap xs ] (gval g ≡ robTail xs)

attain []       = ε , refl
attain (x ∷ xs) with max-cases (rob xs) (x + robTail xs)
... | inl p = let (s , q) = attain  xs in skip s , (q ∙ sym p)
... | inr p = let (g , q) = attainG xs in take g , (cong (x +_) q ∙ sym p)

attainG []       = gε , refl
attainG (y ∷ ys) = let (s , q) = attain ys in gskip s , q

------------------------------------------------------------------------
-- §6  THE OPTIMUM.  rob xs is the maximum, attained, over all legal
--     selections: a witness reaching it, and a proof none exceeds it.
------------------------------------------------------------------------

robber-optimal : (xs : List ℕ)
  → (Σ[ s ∈ Sel xs ] (value s ≡ rob xs))
  × ((s : Sel xs) → value s ≤ rob xs)
robber-optimal xs = attain xs , opt xs
