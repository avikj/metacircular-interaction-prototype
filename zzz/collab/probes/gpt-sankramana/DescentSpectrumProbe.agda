{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DescentSpectrumProbe
--
-- The dependent no-go and the indexed sphere candidate speak about descent at
-- particular truncation strata.  This file supplies the missing order law:
-- descent through an observation is DOWNWARD CLOSED in truncation depth.
--
-- If the (m+n)-truncation of every fiber descends, then its n-truncation
-- descends.  The receipt is the library's checked
--
--   truncOfTruncEq n m :
--     ∥A∥ₙ ≃ ∥ ∥A∥_(m+n) ∥ₙ
--
-- followed by truncating the descended-family path.  Contrapositively, once
-- descent fails at level n, it fails at every finer level m+n.  Therefore an
-- adjacent pair
--
--   descends at n  ×  does not descend at suc n
--
-- is an exact threshold: every level above suc n is excluded automatically.
-- No sphere, charge, or finite example is used in the generic theorem.
--
-- STATUS. Complete no-hole daemon-facing candidate outside `Everything.agda`.
-- Not called checked until a route-bearing warm Nadi load answers.
------------------------------------------------------------------------

module DescentSpectrumProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Nat using (ℕ ; suc ; _+_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.HITs.Truncation using (hLevelTrunc)
open import Cubical.HITs.Truncation.Properties using (truncOfTruncEq)

open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- 1. Descent at one truncation stratum.
------------------------------------------------------------------------

TruncatedFamily : {X : Type ℓ} → ℕ → (X → Type ℓ'') → X → Type ℓ''
TruncatedFamily n Family x = hLevelTrunc n (Family x)

DescendsAt : {X : Type ℓ} {O : Type ℓ'}
  → (X → O) → (X → Type ℓ'') → ℕ
  → Type (ℓ-max (ℓ-max ℓ ℓ') (ℓ-suc ℓ''))
DescendsAt observe Family n =
  DependentFactorsThrough observe (TruncatedFamily n Family)

ExactDescentDepth : {X : Type ℓ} {O : Type ℓ'}
  → (X → O) → (X → Type ℓ'') → ℕ
  → Type (ℓ-max (ℓ-max ℓ ℓ') (ℓ-suc ℓ''))
ExactDescentDepth observe Family n =
  DescendsAt observe Family n
  × (¬ DescendsAt observe Family (suc n))

------------------------------------------------------------------------
-- 2. THE ORDER LAW: descent is downward closed.
------------------------------------------------------------------------

lower-descent : {X : Type ℓ} {O : Type ℓ'}
  (observe : X → O) (Family : X → Type ℓ'')
  (n m : ℕ)
  → DescendsAt observe Family (m + n)
  → DescendsAt observe Family n
lower-descent observe Family n m (Descended , commutes) =
  (λ o → hLevelTrunc n (Descended o)) , λ x →
      ua (truncOfTruncEq n m)
    ∙ cong (hLevelTrunc n) (commutes x)

------------------------------------------------------------------------
-- 3. Contrapositive: a failed stratum excludes every finer stratum.
------------------------------------------------------------------------

failure-persists-upward : {X : Type ℓ} {O : Type ℓ'}
  (observe : X → O) (Family : X → Type ℓ'')
  (n m : ℕ)
  → ¬ DescendsAt observe Family n
  → ¬ DescendsAt observe Family (m + n)
failure-persists-upward observe Family n m noLow high =
  noLow (lower-descent observe Family n m high)

------------------------------------------------------------------------
-- 4. An adjacent witness is an exact threshold, not one isolated failure.
------------------------------------------------------------------------

above-exact-depth-fails : {X : Type ℓ} {O : Type ℓ'}
  (observe : X → O) (Family : X → Type ℓ'')
  (n m : ℕ)
  → ExactDescentDepth observe Family n
  → ¬ DescendsAt observe Family (m + suc n)
above-exact-depth-fails observe Family n m (_ , noNext) =
  failure-persists-upward observe Family (suc n) m noNext

-- The two projections by name, so a consumer need not unpack the pair and
-- silently reverse which side is the positive one.
exact-depth-descends : {X : Type ℓ} {O : Type ℓ'}
  (observe : X → O) (Family : X → Type ℓ'') (n : ℕ)
  → ExactDescentDepth observe Family n
  → DescendsAt observe Family n
exact-depth-descends observe Family n = fst

exact-depth-refuses-next : {X : Type ℓ} {O : Type ℓ'}
  (observe : X → O) (Family : X → Type ℓ'') (n : ℕ)
  → ExactDescentDepth observe Family n
  → ¬ DescendsAt observe Family (suc n)
exact-depth-refuses-next observe Family n = snd
