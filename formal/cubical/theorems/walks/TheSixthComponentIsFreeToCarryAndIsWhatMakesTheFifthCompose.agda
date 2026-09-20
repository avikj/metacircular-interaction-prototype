{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheSixthComponentIsFreeToCarryAndIsWhatMakesTheFifthCompose
--
-- `TheReachableLawDoesNotComposeWithoutPreservation` ended with the
-- step named and not taken:
--
--   "a certificate carrying the reachable law must carry a
--    reachability-preservation component as well, or it does not
--    survive sequencing.  That is a SIXTH component ‚¶ `LCertified` is
--    NOT amended here; extending the record with preservation is the
--    next cycle's named step."
--
-- Taken here, in a new module; `LCertified` is left as it stands.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   RCertified d e     SIX components: boundary semantics, strict cost
--                      improvement, the migration, the law ON THE
--                      INVARIANT, PRESERVATION of the invariant,
--                      provenance
--   composePreserves   preservation composes for nothing ‚î one
--                      application after another
--   composeRCertified  and so the whole six-component certificate
--                      composes
--   noSelfRCertified   still no certificate from a system to itself
--   aFullFiveComponentCertificateThatDoesNotPreserveTheInvariant
--                      an element of the FIVE-component `LCertified`
--                      ‚î real cost improvement, real semantics path,
--                      globally lawful migration, provenance ‚î
--                      whose migration leaves the invariant
--   preservationIsNotImpliedByTheOtherFive
--                      hence the sixth component is independent
--
-- **THE COUNT, FINALLY.**  Of the six, four are free (semantics path,
-- migration, preservation, provenance), one is earned by a theorem
-- proved elsewhere for another purpose (cost, by `‚ä-trans`), and one
-- ‚î the law on the invariant ‚î composes ONLY BECAUSE the sixth is in
-- the record.  So preservation is free to carry and is not free to
-- omit: it costs nothing to compose and it is what makes the fifth
-- component compose at all.  That is a different kind of component
-- from any of the others, and it is invisible until the law is
-- relativised to reachable states.
--
-- The independence witness is built the way the fifth component's was:
-- not merely "some function fails preservation", which would leave
-- open that the other five exclude it, but a genuine element of the
-- earlier record that fails only the new component.  Its observation
-- type is `Unit`, so its migration is globally lawful ‚î the strongest
-- form of the fifth component ‚î and it still leaves the invariant.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- NO NOVELTY.  This is the standard requirement that a refinement
-- re-establish the invariant at the interface; nothing here improves
-- on the refinement calculi.  The content is the count over this
-- corpus's own certificate.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheSixthComponentIsFreeToCarryAndIsWhatMakesTheFifthCompose where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.List using (List ; [] ; _‚à∑_ ; _++_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Bool using (Bool ; true ; false ; false‚â¢true)
open import Cubical.Relation.Nullary using (¬¨_)

open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates)
open import ANonEmptyArchiveHasANonEmptyStratum
  using (‚äè-irrefl ; ‚äè-trans)
open import TheReachableLawDoesNotComposeWithoutPreservation
  using (LawfulOn ; Preserves ; composeLawfulOn)
open import TheLawBelongsInTheRecordAndTheCertificateComposesAlongAChain
  using (LCertified ; semB ; costB ; stateB ; costImproves)

------------------------------------------------------------------------
-- 1.  The six-component certificate
------------------------------------------------------------------------

module _ {Sys B O Prov : Type}
         (sem  : Sys ‚Üí B)
         (cost : Sys ‚Üí List ‚Ñï)
         (M    : Sys ‚Üí Type)
         (obs  : (d : Sys) ‚Üí M d ‚Üí O)
         (R    : (d : Sys) ‚Üí M d ‚Üí Type)
  where

  RCertified : Sys ‚Üí Sys ‚Üí Type
  RCertified d e =
    Œ£[ mg ‚àà (M d ‚Üí M e) ]
        (sem e ‚â° sem d)
      √ó (StrictlyDominates (cost d) (cost e))
      √ó (LawfulOn M obs R d e mg)
      √ó (Preserves M obs R d e mg)
      √ó (List Prov)

  composePreserves :
    (d e f : Sys) (mg‚ÇÅ : M d ‚Üí M e) (mg‚ÇÇ : M e ‚Üí M f)
    ‚Üí Preserves M obs R d e mg‚ÇÅ ‚Üí Preserves M obs R e f mg‚ÇÇ
    ‚Üí Preserves M obs R d f (Œª m ‚Üí mg‚ÇÇ (mg‚ÇÅ m))
  composePreserves d e f mg‚ÇÅ mg‚ÇÇ p‚ÇÅ p‚ÇÇ m r = p‚ÇÇ (mg‚ÇÅ m) (p‚ÇÅ m r)

  composeRCertified :
    (d e f : Sys) ‚Üí RCertified d e ‚Üí RCertified e f ‚Üí RCertified d f
  composeRCertified d e f (mg‚ÇÅ , sde , imp‚ÇÅ , law‚ÇÅ , pre‚ÇÅ , prov‚ÇÅ)
                          (mg‚ÇÇ , sef , imp‚ÇÇ , law‚ÇÇ , pre‚ÇÇ , prov‚ÇÇ) =
      (Œª m ‚Üí mg‚ÇÇ (mg‚ÇÅ m))
    , sef ‚àô sde
    , ‚äè-trans (cost d) (cost e) (cost f) imp‚ÇÅ imp‚ÇÇ
    , composeLawfulOn M obs R d e f mg‚ÇÅ mg‚ÇÇ pre‚ÇÅ law‚ÇÅ law‚ÇÇ
    , composePreserves d e f mg‚ÇÅ mg‚ÇÇ pre‚ÇÅ pre‚ÇÇ
    , prov‚ÇÅ ++ prov‚ÇÇ

  noSelfRCertified : (d : Sys) ‚Üí ¬¨ RCertified d d
  noSelfRCertified d (_ , _ , imp , _ , _ , _) = ‚äè-irrefl (cost d) imp

------------------------------------------------------------------------
-- 2.  The sixth component is independent of the other five
--
-- The observation type is `Unit`, so EVERY migration satisfies the
-- fifth component in its strongest (global) form.  The invariant is
-- "the state is `true`"; the migration is the constant `false`.
------------------------------------------------------------------------

obsUnit : (d : Bool) ‚Üí stateB d ‚Üí Unit
obsUnit _ _ = tt

Inv : (d : Bool) ‚Üí stateB d ‚Üí Type
Inv _ m = m ‚â° true

toFalse : stateB true ‚Üí stateB false
toFalse _ = false

aFullFiveComponentCertificateThatDoesNotPreserveTheInvariant :
  LCertified {Prov = ‚Ñï} semB costB stateB obsUnit true false
aFullFiveComponentCertificateThatDoesNotPreserveTheInvariant =
  toFalse , refl , costImproves , (Œª m ‚Üí refl) , []

preservationIsNotImpliedByTheOtherFive :
  ¬¨ (Preserves stateB obsUnit Inv true false toFalse)
preservationIsNotImpliedByTheOtherFive p = false‚â¢true (p true refl)
