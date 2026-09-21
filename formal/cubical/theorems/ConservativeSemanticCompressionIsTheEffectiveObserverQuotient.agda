{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ConservativeSemanticCompressionIsTheEffectiveObserverQuotient
--
-- The mathematical heart of conservative semantic compression, as a
-- checked term rather than a slogan.
--
--   "find a smaller representation, prove every protected observation
--    factors through it, and make reconstruction executable."
--
-- Fix a state space X and a family of PROTECTED OBSERVERS O i : X → V i
-- into sets.  Two states are indistinguishable when every observer
-- agrees:  x ≈ y  :=  (i : I) → O i x ≡ O i y.
--
-- THE OBJECT.  compress : X → X / ≈  is the coarsest representation that
-- keeps every observer.  This file proves the four properties that make
-- it a lossless, executable, universal compression:
--
--   readout      -- each observer is recovered FROM the compressed form
--                   (reconstruction is executable: readout i ∘ compress ≡ O i,
--                    definitionally, by refl).
--   lossless     -- compress x ≡ compress y  ≃  x ≈ y.  The compressed
--                   forms coincide EXACTLY when no observer separates the
--                   states: nothing detectable is lost, nothing is merged
--                   that an observer could tell apart.  This is
--                   set-quotient EFFECTIVENESS.
--   universal    -- any evaluator into a set that respects ≈ factors
--                   through compress (the quotient's universal property):
--                   every downstream reading is a reading of the
--                   compressed object.
--   minimal      -- compress is the COARSEST observer-preserving encoder:
--                   any encoder E that still keeps every observer factors
--                   compress — i.e. compress merges at least as much as E.
--
-- The observer class is a PARAMETER, made explicit exactly as the theory
-- demands: "the dangerous operation is quotienting before declaring the
-- observer class."  Here the class is declared, and the quotient is
-- proved to erase precisely the ≈-indistinguishable distinctions and no
-- others.
--
-- Machine-checked, Agda 2.8.0 + cubical v0.9, --safe, no postulates.
------------------------------------------------------------------------

module ConservativeSemanticCompressionIsTheEffectiveObserverQuotient where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Relation.Binary
open import Cubical.HITs.SetQuotients as SQ

open BinaryRelation

private variable
  ℓ ℓ' ℓ'' ℓz : Level

module _
  {X : Type ℓ} {I : Type ℓ''} {V : I → Type ℓ'}
  (setV : (i : I) → isSet (V i))
  (O    : (i : I) → X → V i)
  where

  --------------------------------------------------------------------
  -- The observer-indistinguishability relation, and that it is a
  -- proposition-valued equivalence relation (the two hypotheses
  -- effectiveness needs).
  --------------------------------------------------------------------

  _≈_ : X → X → Type (ℓ-max ℓ'' ℓ')
  x ≈ y = (i : I) → O i x ≡ O i y

  ≈-isPropValued : isPropValued _≈_
  ≈-isPropValued x y = isPropΠ (λ i → setV i (O i x) (O i y))

  ≈-isEquivRel : isEquivRel _≈_
  ≈-isEquivRel = equivRel
    (λ x i → refl)
    (λ x y p i → sym (p i))
    (λ x y z p q i → p i ∙ q i)

  --------------------------------------------------------------------
  -- The compressed object and the compression map.
  --------------------------------------------------------------------

  Compressed : Type (ℓ-max ℓ (ℓ-max ℓ'' ℓ'))
  Compressed = X / _≈_

  compress : X → Compressed
  compress = [_]

  --------------------------------------------------------------------
  -- READOUT.  Reconstruction is executable: every protected observer is
  -- a function OF the compressed form, and recovering it is definitional.
  --------------------------------------------------------------------

  readout : (i : I) → Compressed → V i
  readout i = SQ.rec (setV i) (O i) (λ x y r → r i)

  readout-β : (i : I) (x : X) → readout i (compress x) ≡ O i x
  readout-β i x = refl

  --------------------------------------------------------------------
  -- LOSSLESS, EXACTLY.  compress x ≡ compress y  ≃  x ≈ y.
  --------------------------------------------------------------------

  lossless-fwd : (x y : X) → compress x ≡ compress y → x ≈ y
  lossless-fwd x y = effective ≈-isPropValued ≈-isEquivRel x y

  lossless-bwd : (x y : X) → x ≈ y → compress x ≡ compress y
  lossless-bwd x y = eq/ x y

  lossless : (x y : X) → (compress x ≡ compress y) ≃ (x ≈ y)
  lossless x y = isoToEquiv (iso
    (lossless-fwd x y)
    (lossless-bwd x y)
    (λ p → ≈-isPropValued x y (lossless-fwd x y (lossless-bwd x y p)) p)
    (λ q → squash/ (compress x) (compress y)
              (lossless-bwd x y (lossless-fwd x y q)) q))

  --------------------------------------------------------------------
  -- UNIVERSAL.  Any evaluator into a set that respects ≈ factors
  -- (uniquely) through compress: every downstream reading is a reading
  -- of the compressed object.
  --------------------------------------------------------------------

  factor : {Z : Type ℓz} → isSet Z → (f : X → Z)
         → ((x y : X) → x ≈ y → f x ≡ f y)
         → Compressed → Z
  factor sZ f resp = SQ.rec sZ f resp

  factor-β : {Z : Type ℓz} (sZ : isSet Z) (f : X → Z)
             (resp : (x y : X) → x ≈ y → f x ≡ f y) (x : X)
           → factor sZ f resp (compress x) ≡ f x
  factor-β sZ f resp x = refl

  factor-unique : {Z : Type ℓz} (sZ : isSet Z)
                  (g h : Compressed → Z)
                → ((x : X) → g (compress x) ≡ h (compress x))
                → (c : Compressed) → g c ≡ h c
  factor-unique sZ g h agree =
    SQ.elimProp (λ c → sZ (g c) (h c)) agree

  --------------------------------------------------------------------
  -- MINIMAL.  compress is the COARSEST observer-preserving encoder: if
  -- an encoder E : X → Z keeps every observer (E x ≡ E y ⇒ x ≈ y), then
  -- compress factors through E on E's image — compress merges at least
  -- as much as E does.  Stated as: the fibres of E refine the fibres of
  -- compress.
  --------------------------------------------------------------------

  minimal : {Z : Type ℓz} (E : X → Z)
          → ((x y : X) → E x ≡ E y → x ≈ y)
          → (x y : X) → E x ≡ E y → compress x ≡ compress y
  minimal E keeps x y p = lossless-bwd x y (keeps x y p)
