{-# OPTIONS --cubical --safe #-}

-- Coordinate reindexing preserves every constant assignment.  Consequently,
-- an observational collision with a distinct constant assignment need not be
-- a coordinate-reindexing orbit.  The finite control extends the squarefree
-- Bool chart of TotientFiberSymmetry to bounded prime-power exponents.

module PointedReindexOrbitObstruction where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-refl ; zero-≤)
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Sigma using (_×_)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓx ℓb ℓo : Level

------------------------------------------------------------------------
-- Generic pointed coordinate charts
------------------------------------------------------------------------

Assignment : Type ℓx → Type ℓb → Type (ℓ-max ℓx ℓb)
Assignment X B = X → B

reindex : {X : Type ℓx} {B : Type ℓb}
        → (X ≃ X) → Assignment X B → Assignment X B
reindex e assignment x = assignment (equivFun e x)

constant : {X : Type ℓx} {B : Type ℓb} → B → Assignment X B
constant b _ = b

-- A coordinate permutation cannot move the distinguished constant section.
reindex-constant : {X : Type ℓx} {B : Type ℓb}
                 → (e : X ≃ X) (b : B)
                 → reindex e (constant b) ≡ constant b
reindex-constant e b = refl

-- An observation may identify a constant assignment with a distinct point,
-- but coordinate reindexing still cannot connect the two.  This is the exact
-- fixed-point obstruction hidden by an unrestricted observational stabilizer.
constant-collision-not-reindex-orbit
  : {X : Type ℓx} {B : Type ℓb} {O : Type ℓo}
  → (observation : Assignment X B → O)
  → (b : B) (other : Assignment X B)
  → observation (constant b) ≡ observation other
  → ¬ (constant b ≡ other)
  → (observation (constant b) ≡ observation other)
    × ((e : X ≃ X) → ¬ (reindex e (constant b) ≡ other))
constant-collision-not-reindex-orbit observation b other collision distinct =
  collision , λ e linked →
    distinct (sym (reindex-constant e b) ∙ linked)

------------------------------------------------------------------------
-- Uniformly bounded exponent vectors are closed under reindexing
------------------------------------------------------------------------

ExponentVector : Type ℓx → Type ℓx
ExponentVector X = Assignment X ℕ

Bounded : {X : Type ℓx} → ℕ → ExponentVector X → Type ℓx
Bounded cap exponents = (x : _) → exponents x ≤ cap

reindex-bounded : {X : Type ℓx} (cap : ℕ) (e : X ≃ X)
                → (exponents : ExponentVector X)
                → Bounded cap exponents
                → Bounded cap (reindex e exponents)
reindex-bounded cap e exponents bounded x = bounded (equivFun e x)

zeroExponent : {X : Type ℓx} → ExponentVector X
zeroExponent = constant 0

zeroExponent-bounded : {X : Type ℓx} (cap : ℕ)
                     → Bounded cap (zeroExponent {X = X})
zeroExponent-bounded cap x = zero-≤

zeroExponent-fixed : {X : Type ℓx} (e : X ≃ X)
                   → reindex e (zeroExponent {X = X}) ≡ zeroExponent
zeroExponent-fixed e = reindex-constant e 0

------------------------------------------------------------------------
-- Bounded prime-power control over the two generators 2 and 3
------------------------------------------------------------------------

prime : Bool → ℕ
prime false = 2
prime true  = 3

-- For the named prime inputs 2 and 3 (and generally when p is prime), the
-- local factor is exactly phi(p^a): 1 at a=0 and (p-1)p^n at a=suc n.
-- No identification with a library totient is used.
primePowerPhiFactor : ℕ → ℕ → ℕ
primePowerPhiFactor p zero    = 1
primePowerPhiFactor p (suc n) = predℕ p · (p ^ n)

phi6Exponent : ExponentVector Bool → ℕ
phi6Exponent exponents =
  primePowerPhiFactor (prime false) (exponents false)
  · primePowerPhiFactor (prime true) (exponents true)

-- The divisor 1 and the divisor 2, now represented in a cap-one
-- prime-power chart rather than by squarefree membership bits.
divisor1Exponent : ExponentVector Bool
divisor1Exponent = zeroExponent

divisor2Exponent : ExponentVector Bool
divisor2Exponent false = 1
divisor2Exponent true  = 0

divisor1-bounded : Bounded 1 divisor1Exponent
divisor1-bounded = zeroExponent-bounded 1

divisor2-bounded : Bounded 1 divisor2Exponent
divisor2-bounded false = ≤-refl
divisor2-bounded true  = zero-≤

phi6-bounded-collision : phi6Exponent divisor1Exponent
                       ≡ phi6Exponent divisor2Exponent
phi6-bounded-collision = refl

divisor1≢divisor2 : ¬ (divisor1Exponent ≡ divisor2Exponent)
divisor1≢divisor2 equal = znots (funExt⁻ equal false)

-- The collision is real, but no permutation of the prime coordinates sends
-- the all-zero exponent vector to the exponent vector of 2.
phi6-collision-not-reindex-orbit
  : (phi6Exponent divisor1Exponent ≡ phi6Exponent divisor2Exponent)
    × ((e : Bool ≃ Bool)
      → ¬ (reindex e divisor1Exponent ≡ divisor2Exponent))
phi6-collision-not-reindex-orbit =
  constant-collision-not-reindex-orbit
    phi6Exponent 0 divisor2Exponent
    phi6-bounded-collision divisor1≢divisor2

no-reindex-links-divisor1-divisor2
  : (e : Bool ≃ Bool)
  → ¬ (reindex e divisor1Exponent ≡ divisor2Exponent)
no-reindex-links-divisor1-divisor2 e =
  phi6-collision-not-reindex-orbit .snd e
