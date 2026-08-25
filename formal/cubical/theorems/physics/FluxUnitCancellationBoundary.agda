{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- A Leibniz-shaped flux sends the multiplicative unit to zero only after
-- unit and additive-cancellation data are supplied explicitly.
--
-- The sampled `FluxDerivation` intentionally omits those laws.  This module
-- proves the positive algebraic seam and gives a Boolean inhabitant showing
-- why the missing cancellation cannot be inferred from the record itself.
------------------------------------------------------------------------

module FluxUnitCancellationBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; _and_ ; _or_ ; true≢false)
open import Cubical.Relation.Nullary using (¬_)

open import HolonomyFluxDerivation
  using (FluxDerivation)
open FluxDerivation

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- The exact additional laws needed by the standard `D(1)=0` argument.
------------------------------------------------------------------------

record UnitalCancellationAt (F : FluxDerivation ℓ)
    (one zero : Carrier F) : Type ℓ where
  field
    ⋆-identity-left  : (x : Carrier F) → _⋆_ F one x ≡ x
    ⋆-identity-right : (x : Carrier F) → _⋆_ F x one ≡ x

    -- This is the precise cancellation step used below.  An additive group
    -- supplies it, but no group structure is assumed or reconstructed here.
    cancel-double : (x : Carrier F)
      → x ≡ _⊕_ F x x → x ≡ zero

open UnitalCancellationAt

flux-one-zero : (F : FluxDerivation ℓ) (one zero : Carrier F)
  → UnitalCancellationAt F one zero
  → flux F one ≡ zero
flux-one-zero F one zero laws =
  cancel-double laws (flux F one) doubled
  where
  doubled : flux F one ≡ _⊕_ F (flux F one) (flux F one)
  doubled =
      sym (cong (flux F) (⋆-identity-left laws one))
    ∙ leibniz F one one
    ∙ cong₂ (_⊕_ F)
        (⋆-identity-right laws (flux F one))
        (⋆-identity-left laws (flux F one))

------------------------------------------------------------------------
-- Hostile control: a unital Boolean multiplication and a valid Leibniz path
-- do not suffice when the displayed addition is idempotent rather than
-- cancellative.
------------------------------------------------------------------------

boolFlux : FluxDerivation ℓ-zero
Carrier boolFlux = Bool
_⋆_ boolFlux = _and_
_⊕_ boolFlux = _or_
flux boolFlux x = x
leibniz boolFlux false y = refl
leibniz boolFlux true false = refl
leibniz boolFlux true true = refl

bool-one-left : (x : Bool) → true and x ≡ x
bool-one-left x = refl

bool-one-right : (x : Bool) → x and true ≡ x
bool-one-right false = refl
bool-one-right true = refl

bool-flux-one-nonzero : ¬ (flux boolFlux true ≡ false)
bool-flux-one-nonzero = true≢false

bool-double-idempotent : true ≡ true or true
bool-double-idempotent = refl

bool-cancel-double-fails :
  ¬ ((x : Bool) → x ≡ x or x → x ≡ false)
bool-cancel-double-fails cancellation =
  true≢false (cancellation true bool-double-idempotent)

bool-no-unital-cancellation :
  ¬ UnitalCancellationAt boolFlux true false
bool-no-unital-cancellation laws =
  bool-flux-one-nonzero (flux-one-zero boolFlux true false laws)

