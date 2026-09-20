{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CertifiedRewritesFormASemicategoryAndOnlyTheCostComponentNeedsAnHLevel
--
-- ON THE NAME.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/` and
-- invented.**  A semicategory law over certified rewrites has no Indian
-- source I have established; the h-level machinery is Voevodsky's
-- substrate, which this repository declares a tool and not a frame.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY THIS, AND WHY NOW ‚î the rest on this line was LIFTED, with a
-- criterion, at `e52b933e`.  Associativity is named as not-done in
-- THREE modules written in THREE separate cycles
-- (`ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem`,
-- `MigrationNeedsALawAndTheLawIsNotFree`,
-- `TheLawBelongsInTheRecordAndTheCertificateComposesAlongAChain`), so
-- it is demanded from OUTSIDE the line rather than suggested by it, and
-- it is structural rather than another instance of the line's pattern.
-- If that distinction is a rationalisation, say so and put the rest
-- back on.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   isProp‚âº                 the product order on fitness vectors is
--                           proposition-valued, by induction ‚î `Unit`,
--                           `‚ä`, and `isProp‚â` at the leaves
--   isPropStrictlyDominates hence so is strict domination
--   composeIsAssociative    `composeCertified` is associative
--
-- **AND THE FOUR COMPONENTS PAY FOUR DIFFERENT PRICES, WHICH IS THE
-- CONTENT.**  Diagnostic (1) placed each before it was written and each
-- came out where predicted:
--
--   semantics   a PATH, so associativity is `assoc` ‚î it holds UP TO A
--               PATH and not definitionally
--   cost        an H-LEVEL, and **this is the only component that could
--               have failed**: two bracketings of `‚ä-trans` are two
--               different proof terms, and nothing makes them equal
--               except `StrictlyDominates` being a proposition.  It is
--               one, and ¬ß1 proves it rather than assuming it
--   migration   DEFINITIONAL ‚î `Œª m ‚í mig‚ (mig‚ (mig‚ m))` either way,
--               so `refl`
--   provenance  a LIBRARY LEMMA, `++-assoc`
--
-- So the answer to "does the composition associate" is yes, and the
-- interesting part is that the obstruction lives in exactly the
-- component that already needed a theorem for composition
-- (`‚ä-trans`).  **The component that costs a theorem is the component
-- that costs an h-level.**  Nothing else on the record has proof
-- content to disagree about.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- **IT IS A SEMICATEGORY AND NOT A CATEGORY, AND THAT IS NOT A GAP.**
-- `noSelfRewrite` in the audited module proves `¬ Certified d d`: strict
-- cost improvement removes every identity.  So there is no unit law to
-- prove and none is missing; associativity is the whole of the
-- algebraic structure available here.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module CertifiedRewritesFormASemicategoryAndOnlyTheCostComponentNeedsAnHLevel where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.GroupoidLaws using (assoc)
open import Cubical.Foundations.HLevels using (isProp√ó)
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Nat.Order using (isProp‚â§)
open import Cubical.Data.List using (List ; [] ; _‚à∑_ ; _++_ ; ++-assoc)
open import Cubical.Data.Unit using (Unit ; isPropUnit)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; Œ£PathP)
open import Cubical.Data.Empty using (isProp‚ä•)
open import Cubical.Relation.Nullary using (¬¨_ ; isProp¬¨)

open import AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
  using (_‚âº_)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates)
open import ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem
  using (Certified ; composeCertified)

------------------------------------------------------------------------
-- 1.  The cost order is proposition-valued
------------------------------------------------------------------------

isProp‚âº : (v w : List ‚Ñï) ‚Üí isProp (v ‚âº w)
isProp‚âº []       []       = isPropUnit
isProp‚âº []       (_ ‚à∑ _)  = isProp‚ä•
isProp‚âº (_ ‚à∑ _)  []       = isProp‚ä•
isProp‚âº (x ‚à∑ xs) (y ‚à∑ ys) = isProp√ó isProp‚â§ (isProp‚âº xs ys)

isPropStrictlyDominates :
  (v w : List ‚Ñï) ‚Üí isProp (StrictlyDominates v w)
isPropStrictlyDominates v w =
  isProp√ó (isProp‚âº v w) (isProp¬¨ (w ‚âº v))

------------------------------------------------------------------------
-- 2.  So the composition associates, one price per component
------------------------------------------------------------------------

module _ {Sys B Prov : Type}
         (sem  : Sys ‚Üí B)
         (cost : Sys ‚Üí List ‚Ñï)
         (M    : Sys ‚Üí Type)
  where

  private
    Cert : Sys ‚Üí Sys ‚Üí Type
    Cert = Certified {Prov = Prov} sem cost M

    cmp : (d e f : Sys) ‚Üí Cert d e ‚Üí Cert e f ‚Üí Cert d f
    cmp = composeCertified sem cost M

  composeIsAssociative :
    (d e f g : Sys)
    (c‚ÇÅ : Cert d e) (c‚ÇÇ : Cert e f) (c‚ÇÉ : Cert f g)
    ‚Üí cmp d f g (cmp d e f c‚ÇÅ c‚ÇÇ) c‚ÇÉ
      ‚â° cmp d e g c‚ÇÅ (cmp e f g c‚ÇÇ c‚ÇÉ)
  composeIsAssociative d e f g
    (s‚ÇÅ , i‚ÇÅ , m‚ÇÅ , p‚ÇÅ) (s‚ÇÇ , i‚ÇÇ , m‚ÇÇ , p‚ÇÇ) (s‚ÇÉ , i‚ÇÉ , m‚ÇÉ , p‚ÇÉ) =
    Œ£PathP
      ( assoc s‚ÇÉ s‚ÇÇ s‚ÇÅ
      , Œ£PathP
          ( isPropStrictlyDominates (cost d) (cost g) _ _
          , Œ£PathP (refl , ++-assoc p‚ÇÅ p‚ÇÇ p‚ÇÉ) ) )
