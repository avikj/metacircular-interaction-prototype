{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- BraidCoherenceBoundary
--
-- A bounded exact response to UP-D0025, T25.E.  The word "braid" and
-- invertibility of two arbitrary proposed generators do not supply a braid
-- action.  This control does not address generators induced from one shared
-- local binary crossing, which would be strictly more structure.
-- The Yang--Baxter equation is additional coherence data that must be
-- proved.  On three Boolean strands we exhibit both sides of the boundary:
--
-- * the actual adjacent coordinate swaps are involutive equivalences and
--   satisfy sigma1 sigma2 sigma1 = sigma2 sigma1 sigma2;
-- * Boolean negation on the first coordinate and the identity are also
--   involutive equivalences, but fail that equation at a named point.
--
-- This does not decide whether any historical three-lens EGB cycle has an
-- associator, hexagon, Yang--Baxter witness, or holonomy.  It proves the
-- control needed before such a structure can be inferred.
------------------------------------------------------------------------

module BraidCoherenceBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; false≢true)
open import Cubical.Relation.Nullary using (¬_)

Triple : Type₀
Triple = Bool × (Bool × Bool)

------------------------------------------------------------------------
-- The equation that two endomorphisms must satisfy to be the two local
-- generators of a three-strand braid action.  Composition is written out,
-- removing any convention about diagram order.

YangBaxter : (Triple → Triple) → (Triple → Triple) → Type₀
YangBaxter σ₁ σ₂ =
  (x : Triple) → σ₁ (σ₂ (σ₁ x)) ≡ σ₂ (σ₁ (σ₂ x))

------------------------------------------------------------------------
-- Positive control: genuine adjacent transpositions.

swap₁ : Triple → Triple
swap₁ (a , b , c) = b , a , c

swap₂ : Triple → Triple
swap₂ (a , b , c) = a , c , b

swap₁-involutive : (x : Triple) → swap₁ (swap₁ x) ≡ x
swap₁-involutive (a , b , c) = refl

swap₂-involutive : (x : Triple) → swap₂ (swap₂ x) ≡ x
swap₂-involutive (a , b , c) = refl

swap₁Equiv : Triple ≃ Triple
swap₁Equiv =
  isoToEquiv (iso swap₁ swap₁ swap₁-involutive swap₁-involutive)

swap₂Equiv : Triple ≃ Triple
swap₂Equiv =
  isoToEquiv (iso swap₂ swap₂ swap₂-involutive swap₂-involutive)

adjacent-swaps-yang-baxter : YangBaxter swap₁ swap₂
adjacent-swaps-yang-baxter (a , b , c) = refl

------------------------------------------------------------------------
-- Negative control: invertibility alone does not entail Yang--Baxter.

flipFirst : Triple → Triple
flipFirst (a , b , c) = not a , b , c

identityCrossing : Triple → Triple
identityCrossing x = x

flipFirst-involutive : (x : Triple) → flipFirst (flipFirst x) ≡ x
flipFirst-involutive (true  , b , c) = refl
flipFirst-involutive (false , b , c) = refl

identity-involutive : (x : Triple) → identityCrossing (identityCrossing x) ≡ x
identity-involutive x = refl

flipFirstEquiv : Triple ≃ Triple
flipFirstEquiv =
  isoToEquiv
    (iso flipFirst flipFirst flipFirst-involutive flipFirst-involutive)

identityCrossingEquiv : Triple ≃ Triple
identityCrossingEquiv =
  isoToEquiv
    (iso identityCrossing identityCrossing
      identity-involutive identity-involutive)

invertible-crossings-fail-yang-baxter :
  ¬ YangBaxter flipFirst identityCrossing
invertible-crossings-fail-yang-baxter yb =
  false≢true (cong fst (yb (false , false , false)))

-- The countermodel is packaged with the two equivalence certificates: this
-- rules out the tempting implication "two arbitrary self-equivalences imply
-- a braid action", not merely a statement about two arbitrary functions.
invertibility-does-not-force-yang-baxter :
  Σ[ σ₁ ∈ (Triple ≃ Triple) ]
  Σ[ σ₂ ∈ (Triple ≃ Triple) ]
    ¬ YangBaxter (equivFun σ₁) (equivFun σ₂)
invertibility-does-not-force-yang-baxter =
  flipFirstEquiv ,
  identityCrossingEquiv ,
  invertible-crossings-fail-yang-baxter
