{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FreeMonoid
--
-- Presentation (ii): the free monoid on one generator, `List Unit`.
--
-- This module is the *warm-up* instance of charter §7 layer 2, done in
-- full: an equivalence is constructed (not asserted), a path is
-- produced with `ua`, the natively-defined concatenation is shown to be
-- literally the transport of the natively-defined addition, and finally
-- the structure identity principle is used to conclude that the two
-- monoids are EQUAL, not merely isomorphic.
------------------------------------------------------------------------

module FreeMonoid where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat
open import Cubical.Data.List
open import Cubical.Data.Unit
open import Cubical.Data.Sigma
open import Cubical.Algebra.Monoid.Base

------------------------------------------------------------------------
-- 1.  The presentation, defined independently of ℕ.
------------------------------------------------------------------------

Tally : Type₀
Tally = List Unit

isSetTally : isSet Tally
isSetTally = isOfHLevelList 0 isSetUnit

------------------------------------------------------------------------
-- 2.  The equivalence, constructed.
------------------------------------------------------------------------

len : Tally → ℕ
len []       = zero
len (_ ∷ xs) = suc (len xs)

unlen : ℕ → Tally
unlen zero    = []
unlen (suc n) = tt ∷ unlen n

len-unlen : (n : ℕ) → len (unlen n) ≡ n
len-unlen zero    = refl
len-unlen (suc n) = cong suc (len-unlen n)

unlen-len : (xs : Tally) → unlen (len xs) ≡ xs
unlen-len []       = refl
unlen-len (x ∷ xs) = cong (tt ∷_) (unlen-len xs)

ℕ≃Tally : ℕ ≃ Tally
ℕ≃Tally = isoToEquiv (iso unlen len unlen-len len-unlen)

ℕ≡Tally : ℕ ≡ Tally
ℕ≡Tally = ua ℕ≃Tally

------------------------------------------------------------------------
-- 3.  Both operations are defined natively; then the homomorphism law
--     is proved.
------------------------------------------------------------------------

unlen-+ : (m n : ℕ) → unlen (m + n) ≡ unlen m ++ unlen n
unlen-+ zero    n = refl
unlen-+ (suc m) n = cong (tt ∷_) (unlen-+ m n)

len-++ : (xs ys : Tally) → len (xs ++ ys) ≡ len xs + len ys
len-++ []       ys = refl
len-++ (x ∷ xs) ys = cong suc (len-++ xs ys)

------------------------------------------------------------------------
-- 4.  Transport, not assertion.
--
-- The transported addition is *equal* to concatenation, as a function.
------------------------------------------------------------------------

transport-+-is-++ :
  transport (λ i → ℕ≡Tally i → ℕ≡Tally i → ℕ≡Tally i) _+_ ≡ _++_
transport-+-is-++ = funExt (λ xs → funExt (λ ys →
    transportUAop₂ ℕ≃Tally _+_ xs ys
  ∙ unlen-+ (len xs) (len ys)
  ∙ cong₂ _++_ (unlen-len xs) (unlen-len ys)))

-- The same for the generator: successor transports to consing.
transport-suc-is-cons :
  transport (λ i → ℕ≡Tally i → ℕ≡Tally i) suc ≡ (tt ∷_)
transport-suc-is-cons = funExt (λ xs →
    transportUAop₁ ℕ≃Tally suc xs
  ∙ cong (tt ∷_) (unlen-len xs))

------------------------------------------------------------------------
-- 5.  The univalent punchline: the two monoids are EQUAL.
------------------------------------------------------------------------

ℕ-Monoid : Monoid ℓ-zero
ℕ-Monoid = makeMonoid zero _+_ isSetℕ +-assoc +-zero (λ _ → refl)

Tally-Monoid : Monoid ℓ-zero
Tally-Monoid =
  makeMonoid [] _++_ isSetTally
    (λ xs ys zs → sym (++-assoc xs ys zs))
    ++-unit-r
    (λ _ → refl)

ℕ≃Tally-MonoidEquiv : MonoidEquiv ℕ-Monoid Tally-Monoid
ℕ≃Tally-MonoidEquiv = ℕ≃Tally , monoidequiv refl unlen-+

-- Not "isomorphic": equal, as elements of the type of monoids.
ℕ-Monoid≡Tally-Monoid : ℕ-Monoid ≡ Tally-Monoid
ℕ-Monoid≡Tally-Monoid = equivFun (MonoidPath ℕ-Monoid Tally-Monoid) ℕ≃Tally-MonoidEquiv

-- ... and the underlying type path is the one we started from.
carrier-of-monoid-path : cong ⟨_⟩ ℕ-Monoid≡Tally-Monoid ≡ ℕ≡Tally
carrier-of-monoid-path = refl
