{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DerivationSoundnessIsTheCardinalityShadow ‚î the capstone of the
-- decategorification story.  Two modules established:
--   ¬ `TheCountingSemanticsIsADecategorification‚¶`: every Step is an
--     EQUIVALENCE, so a Derivation a b gives derivation-equiv : ‚ü¶a‚üß ‚â ‚ü¶b‚üß
--     (the categorified semantics), and `eval`/`derivation-sound` is a
--     readout into a SET that keeps a cardinality and drops the bijection.
--   ¬ `‚¶IsTheCardinalityOfTheCategorifiedOne‚¶`: card : ‚ü¶t‚üß(finEnv œ) ‚â
--     Fin (eval t œ) ‚î the counting value IS the cardinality of ‚ü¶t‚üß.
--
-- Put together, the kernel's ORIGINAL counting soundness is RECOVERED as
-- the œ‚ / cardinality image of the categorified equivalence: a derivation
-- a ‚ b gives a bijection ‚ü¶a‚üß ‚â ‚ü¶b‚üß, whose two sides have cardinalities
-- eval a œ and eval b œ, and cardinality is injective on Fin ‚î so
-- eval a œ ‚â° eval b œ falls out, with NO appeal to `derivation-sound`.
--
-- WHAT IS PROVEN, --safe, no postulates:
--   soundnessFromCategorification
--        (d : Derivation a b)(œ : Env) ‚í eval a œ ‚â° eval b œ, built ONLY
--        from derivation-equiv, card, and injectivity of Fin's cardinality
--        (SumFin‚âFin ‚àô Fin-inj) ‚î the counting soundness derived from the
--        univalent one.
--   recovers-derivation-sound
--        it agrees with the kernel's own derivation-sound (necessarily ‚î
--        both land in ‚ï, a set; the content is that the categorified route
--        is an independent construction giving the same equation, retaining
--        the bijection until the final cardinality step).
--
-- READING.  The counting semantics is not merely accompanied by a
-- categorified one; its SOUNDNESS is the shadow of the categorified
-- soundness under decategorification.  eval = cardinality; derivation-sound
-- = cardinality of derivation-equiv.  The bijection is present the whole
-- way and is collapsed only at the last step ‚î "never discard the fibre",
-- at the level of the kernel's semantics.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module DerivationSoundnessIsTheCardinalityShadowOfTheCategorifiedEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; invEquiv ; compEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Nat using (‚Ñï ; isSet‚Ñï)
open import Cubical.Data.SumFin using (Fin)
open import Cubical.Data.SumFin.Properties using (SumFin‚âÉFin)
open import Cubical.Data.Fin.Properties using (Fin-inj)

open import RewriteCertificate using (Tm ; Derivation ; Env ; eval ; derivation-sound)
open import TheCountingSemanticsIsADecategorificationAndTheBitItDropsIsASymmetry
  using (‚ü¶_‚üß ; derivation-equiv)
open import TheCountingSemanticsIsTheCardinalityOfTheCategorifiedOneEveryTermsTypeIsFinOfItsEvaluation
  using (finEnv ; card)

------------------------------------------------------------------------
-- The counting soundness, reconstructed from the categorified semantics.
------------------------------------------------------------------------

soundnessFromCategorification :
  {a b : Tm} (d : Derivation a b) (œÅ : Env) ‚Üí eval a œÅ ‚â° eval b œÅ
soundnessFromCategorification {a} {b} d œÅ =
  Fin-inj (eval a œÅ) (eval b œÅ)
    (ua (compEquiv (invEquiv (SumFin‚âÉFin (eval a œÅ)))
        (compEquiv finEquiv (SumFin‚âÉFin (eval b œÅ)))))
  where
    -- the derivation's bijection, transported onto the cardinalities:
    -- Fin (eval a œ) ‚â ‚ü¶a‚üß ‚â ‚ü¶b‚üß ‚â Fin (eval b œ).
    finEquiv : Fin (eval a œÅ) ‚âÉ Fin (eval b œÅ)
    finEquiv = compEquiv (invEquiv (card a œÅ))
                 (compEquiv (derivation-equiv d (finEnv œÅ)) (card b œÅ))

-- it is the kernel's own soundness (both land in ‚ï, a set).
recovers-derivation-sound :
  {a b : Tm} (d : Derivation a b) (œÅ : Env)
  ‚Üí soundnessFromCategorification d œÅ ‚â° derivation-sound d œÅ
recovers-derivation-sound {a} {b} d œÅ =
  isSet‚Ñï (eval a œÅ) (eval b œÅ) _ _
