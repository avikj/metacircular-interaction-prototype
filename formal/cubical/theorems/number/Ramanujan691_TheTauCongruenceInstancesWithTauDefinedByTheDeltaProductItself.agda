{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन् ६९१ — THE TAU CONGRUENCE: INSTANCES WITH THE COFACTOR IN
-- HAND, AND TAU DEFINED BY THE DELTA PRODUCT ITSELF.
--
-- Ramanujan (1916), "On certain arithmetical functions": expand
--
--     Δ = q ∏ (1 − qⁿ)²⁴ = Σ τ(n) qⁿ
--
-- and then the congruence that startled everybody:
--
--     τ(n) ≡ σ₁₁(n)  (mod 691).
--
-- τ is DEFINED here the way Ramanujan found it — the coefficients of
-- the product, computed.  Signed coefficients are carried as FORMAL
-- DIFFERENCES of naturals (a , b) standing for a − b, added and
-- multiplied by the semiring rules — the discipline the corpus's own
-- KuttakaValli teaches: keep the slot, and no signed branch is ever
-- taken.  The polynomial product is truncated at degree 8, each
-- (1 − qⁿ)²⁴ is twenty-four honest multiplications, and the τ table
-- falls out by refl through the difference-to-ℤ reading:
--
--     τ: 1, −24, 252, −1472, 4830, −6048, −16744, 84480
--
-- with Ramanujan's multiplicativity visible at its first coprime
-- pair, τ(6) = τ(2)·τ(3), by refl.
--
-- THE CONGRUENCE, entirely in ℕ, subtraction-free, cofactor in hand:
-- with (a , b) the computed difference pair of τ(n),
--
--     σ₁₁(n) + b ≡ a + 691 · q        (q exhibited)
--
--     n = 2 : q = 3         n = 3 : q = 256
--     n = 4 : q = 6075      n = 5 : q = 70656
--     n = 6 : q = 525300
--
-- each one refl, and each valid for WHATEVER representative pair the
-- kernel computes, because the equation depends only on a − b.  The
-- general congruence is the Eisenstein series E₁₂ and the Bernoulli
-- number −691/2730; it is named, and the five instances are what the
-- kernel computed from the product itself.
------------------------------------------------------------------------

module Ramanujan691_TheTauCongruenceInstancesWithTauDefinedByTheDeltaProductItself where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just ; rec ; map-Maybe)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)
open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (le?)

------------------------------------------------------------------------
-- §1  Formal differences: signs without branches.
------------------------------------------------------------------------

D : Type
D = ℕ × ℕ

dadd : D → D → D
dadd (a , b) (c , d) = a + c , b + d

dmul : D → D → D
dmul (a , b) (c , d) = a · c + b · d , a · d + b · c

-- Reading a difference: only at the boundary, only on small finals.
toℤ : D → ℤ
toℤ (a , b) = rec (negsuc ((b ∸ a) ∸ 1)) (λ _ → pos (a ∸ b)) (le? b a)

------------------------------------------------------------------------
-- §2  Truncated polynomial arithmetic over D (degree < 9).
------------------------------------------------------------------------

Poly : Type
Poly = List D

d0 d1 dm1 : D
d0 = 0 , 0
d1 = 1 , 0
dm1 = 0 , 1

take9 : ℕ → Poly → Poly
take9 zero    _        = []
take9 (suc n) []       = []
take9 (suc n) (x ∷ xs) = x ∷ take9 n xs

padd : Poly → Poly → Poly
padd []       ys       = ys
padd xs       []       = xs
padd (x ∷ xs) (y ∷ ys) = dadd x y ∷ padd xs ys

pscale : D → Poly → Poly
pscale a []       = []
pscale a (x ∷ xs) = dmul a x ∷ pscale a xs

pmul : Poly → Poly → Poly
pmul []       ys = []
pmul (x ∷ xs) ys = take9 9 (padd (pscale x ys) (d0 ∷ pmul xs ys))

-- (1 − qⁿ), truncated.
one-minus-q^ : ℕ → Poly
one-minus-q^ n = d1 ∷ mk n
  where
  mk : ℕ → Poly
  mk zero          = []
  mk (suc zero)    = dm1 ∷ []
  mk (suc (suc m)) = d0 ∷ mk (suc m)

pow24 : Poly → Poly
pow24 b = go 24 (d1 ∷ [])
  where
  go : ℕ → Poly → Poly
  go zero    acc = acc
  go (suc k) acc = go k (pmul b acc)

etaProd : ℕ → Poly
etaProd zero    = d1 ∷ []
etaProd (suc n) = pmul (pow24 (one-minus-q^ (suc n))) (etaProd n)

Δ : Poly
Δ = d0 ∷ etaProd 8

coeff : ℕ → Poly → D
coeff _       []       = d0
coeff zero    (x ∷ _)  = x
coeff (suc n) (_ ∷ xs) = coeff n xs

-- The difference pair of τ(n), as the product hands it over.
τp : ℕ → D
τp n = coeff n Δ

τ : ℕ → ℤ
τ n = toℤ (τp n)

------------------------------------------------------------------------
-- §3  The τ table, and multiplicativity on the spot.
------------------------------------------------------------------------

τ-table :
  (τ 1 ≡ pos 1) × (τ 2 ≡ negsuc 23) × (τ 3 ≡ pos 252)
  × (τ 4 ≡ negsuc 1471) × (τ 5 ≡ pos 4830) × (τ 6 ≡ negsuc 6047)
  × (τ 7 ≡ negsuc 16743) × (τ 8 ≡ pos 84480)
τ-table = refl , refl , refl , refl , refl , refl , refl , refl

τ-multiplicative-at-6 : τ 6 ≡ toℤ (dmul (τp 2) (τp 3))
τ-multiplicative-at-6 = refl

------------------------------------------------------------------------
-- §4  σ₁₁ over the witness-typed divisor scan.
------------------------------------------------------------------------

pow11 : ℕ → ℕ
pow11 m = m · (m · (m · (m · (m · (m · (m · (m · (m · (m · m)))))))))

σind : ℕ → ℕ → ℕ
σind k m = rec 0 (λ _ → pow11 k) (find-q m)
  where
  find-q : (b : ℕ) → Maybe (Σ ℕ (λ q → q · k ≡ m))
  find-q zero    = map-Maybe (λ p → zero , p) (eq? zero m)
  find-q (suc b) =
    rec (find-q b) (λ p → just (suc b , p)) (eq? (suc b · k) m)

σsum : ℕ → ℕ → ℕ
σsum m zero    = 0
σsum m (suc k) = σind (suc k) m + σsum m k

σ₁₁ : ℕ → ℕ
σ₁₁ m = σsum m m

------------------------------------------------------------------------
-- §5  THE CONGRUENCE: five instances, in ℕ, cofactors in hand.
------------------------------------------------------------------------

congruence-2 : σ₁₁ 2 + snd (τp 2) ≡ fst (τp 2) + 691 · 3
congruence-2 = refl

congruence-3 : σ₁₁ 3 + snd (τp 3) ≡ fst (τp 3) + 691 · 256
congruence-3 = refl

congruence-4 : σ₁₁ 4 + snd (τp 4) ≡ fst (τp 4) + 691 · 6075
congruence-4 = refl

congruence-5 : σ₁₁ 5 + snd (τp 5) ≡ fst (τp 5) + 691 · 70656
congruence-5 = refl

congruence-6 : σ₁₁ 6 + snd (τp 6) ≡ fst (τp 6) + 691 · 525300
congruence-6 = refl
