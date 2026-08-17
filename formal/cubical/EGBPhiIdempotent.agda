{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EGBPhiIdempotent
--
-- The achromatic component of the EGB reflection operator Φ is a
-- genuine reflector: it stabilizes after one application.
--
-- The corpus's one honest, checked Φ-component is the set-quotient of
-- NaturalMachine.FutureBehavior (Meaning = X / FutureEq, realized by
-- the HIT Cubical.HITs.SetQuotients._/_).  This module proves that any
-- such quotient component is IDEMPOTENT: quotienting A / R a second
-- time, by the only relation the first pass leaves available — its own
-- path relation _≡_ — produces an equivalent type.
--
--   achromaticIdempotent : ((A / R) / _≡_) ≃ (A / R)
--
-- proved from the general fact (pathQuotEquiv) that for any SET X,
-- X / _≡_ ≃ X: rec by the identity one way (a path IS the required
-- coherence), [_] the other way, round-trips by elimProp into the
-- prop-valued goals supplied by squash/ and by isSet X.
--
-- COROLLARY (checked below as secondPassAddsNothing): every
-- identification in the re-quotient (A / R) / _≡_ between classes
-- [ x ] and [ y ] already holds between x and y in A / R.  The second
-- application of the achromatic quotient adds NO new identifications
-- and NO new elements.
--
-- CONSEQUENCE FOR THE BRAID (the checked half of Delta-24, "Φ cannot
-- be an ordinary reflector"): if Φ were only its achromatic/quotient
-- component, then S → Φ(S) → Φ²(S) would stabilize at the first stage
-- — this file's theorems — and EGB stages 7–12 would be vacuous.
-- Since the stages are (by design) non-vacuous, the generativity of Φ
-- cannot live in the quotient: it must live in the RETAINED DEFECT
-- (the diagonal/defect component, cf. AchromaticToy §4 "defect as
-- object" and LawvereDiagonal).  The quotient is the loop that
-- repeats; the defect is the loop that develops.
------------------------------------------------------------------------

module EGBPhiIdempotent where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.HITs.SetQuotients as SQ
  using (_/_ ; [_] ; eq/ ; squash/)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  General form: for a set X, quotienting by the path relation
--     changes nothing.  fun is rec by the identity — the coherence
--     obligation for rec is exactly the path we are handed; inv is the
--     class-of constructor; the round-trips are prop-valued (isSet X,
--     squash/) so elimProp closes them on generators.

pathQuotIso : {X : Type ℓ} → isSet X → Iso (X / _≡_) X
Iso.fun (pathQuotIso setX) = SQ.rec setX (λ x → x) (λ _ _ p → p)
Iso.inv (pathQuotIso setX) = [_]
Iso.rightInv (pathQuotIso setX) x = refl
Iso.leftInv (pathQuotIso setX) =
  SQ.elimProp (λ _ → squash/ _ _) (λ _ → refl)

pathQuotEquiv : {X : Type ℓ} → isSet X → (X / _≡_) ≃ X
pathQuotEquiv setX = isoToEquiv (pathQuotIso setX)

------------------------------------------------------------------------
-- 2.  The achromatic reflection stabilizes: a set-quotient A / R is
--     itself a set (squash/), so re-quotienting it by its induced path
--     relation is the identity up to equivalence.

achromaticIdempotent : {A : Type ℓ} {R : A → A → Type ℓ'}
  → ((A / R) / _≡_) ≃ (A / R)
achromaticIdempotent = pathQuotEquiv squash/

------------------------------------------------------------------------
-- 3.  One-line checked consequence: the second pass identifies nothing
--     the first pass had not already identified.  Any path between
--     classes in the re-quotient descends to a path in A / R.

secondPassAddsNothing : {A : Type ℓ} {R : A → A → Type ℓ'}
  (x y : A / R)
  → Path ((A / R) / _≡_) [ x ] [ y ]
  → x ≡ y
secondPassAddsNothing x y p =
  cong (Iso.fun (pathQuotIso squash/)) p
