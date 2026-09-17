{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheReachableLawDoesNotComposeWithoutPreservation
--
-- Both modules on the certificate line closed with the same unstated
-- item:
--
--   "Nothing is said about migrations that preserve the observation
--    only on REACHABLE states, which is the version a real compiler
--    would use."
--
-- It is stated here, and it turns out NOT to be a weakening of the
-- global law with the same behaviour.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   Reach step i        reachability from an initial state under a
--                       step relation ‚î an inductive family, no Fin,
--                       no index matching
--   reachIsClosedUnderSteps
--                       so it is an invariant, which is what makes it
--                       a legitimate `R` below
--   LawfulOn R d e mig  the observation is preserved on R only
--   Preserves R d e mig the migration keeps R
--   globalLawIsLawfulOnAnything
--                       the global law implies the reachable law for
--                       EVERY R ‚î so this really is a weakening
--   composeLawfulOn     reachable laws compose GIVEN preservation by
--                       the first migration
--   totalInvariantGivesBackTheGlobalLaw
--                       if R holds everywhere the two laws coincide
--   preservationIsNecessary
--                       three systems and two migrations, each lawful
--                       on R, whose composite is NOT lawful on R
--
-- **THE POINT IS THE LOSS OF A FREE COMPOSITION.**  On the certificate
-- line the global law was one of the components that composed for
-- nothing: `composeLawful` is two paths and a `‚àô`.  The reachable law
-- does not: `composeLawfulOn` needs `Preserves`, and
-- `preservationIsNecessary` shows the hypothesis cannot be dropped.
-- The witness is small and concrete ‚î the first migration sends a
-- reachable state to an unreachable one, where the second migration's
-- law says nothing, and the composite observes the wrong thing.
--
-- So the version "a real compiler would use" is strictly more
-- expensive than the version already checked: a certificate carrying
-- the reachable law must carry a reachability-preservation component
-- as well, or it does not survive sequencing.  That is a SIXTH
-- component, and unlike the fifth it is needed for composition rather
-- than for meaning.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- NO NOVELTY.  Refinement relative to an invariant, and the failure of
-- naive composition when the invariant is not preserved, are standard
-- in refinement calculi and in Floyd‚ìHoare style reasoning (the
-- invariant must be re-established at the interface); nothing here
-- improves on that.  The content is only that this corpus's own
-- certificate loses a free component when it moves to the reachable
-- law.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheReachableLawDoesNotComposeWithoutPreservation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false ; false‚â¢true)
open import Cubical.Relation.Nullary using (¬¨_)

open import MigrationNeedsALawAndTheLawIsNotFree using (Lawful)

------------------------------------------------------------------------
-- 1.  Reachability is an invariant
------------------------------------------------------------------------

data Reach {S : Type} (step : S ‚Üí S ‚Üí Type) (i : S) : S ‚Üí Type where
  here : Reach step i i
  next : {x y : S} ‚Üí Reach step i x ‚Üí step x y ‚Üí Reach step i y

reachIsClosedUnderSteps :
  {S : Type} (step : S ‚Üí S ‚Üí Type) (i x y : S)
  ‚Üí Reach step i x ‚Üí step x y ‚Üí Reach step i y
reachIsClosedUnderSteps step i x y r s = next r s

------------------------------------------------------------------------
-- 2.  The law relative to an invariant
------------------------------------------------------------------------

module _ {Sys O : Type}
         (M   : Sys ‚Üí Type)
         (obs : (d : Sys) ‚Üí M d ‚Üí O)
         (R   : (d : Sys) ‚Üí M d ‚Üí Type)
  where

  LawfulOn : (d e : Sys) ‚Üí (M d ‚Üí M e) ‚Üí Type
  LawfulOn d e mg = (m : M d) ‚Üí R d m ‚Üí obs e (mg m) ‚â° obs d m

  Preserves : (d e : Sys) ‚Üí (M d ‚Üí M e) ‚Üí Type
  Preserves d e mg = (m : M d) ‚Üí R d m ‚Üí R e (mg m)

  globalLawIsLawfulOnAnything :
    (d e : Sys) (mg : M d ‚Üí M e) ‚Üí Lawful M obs d e mg ‚Üí LawfulOn d e mg
  globalLawIsLawfulOnAnything d e mg l m _ = l m

  composeLawfulOn :
    (d e f : Sys) (mg‚ÇÅ : M d ‚Üí M e) (mg‚ÇÇ : M e ‚Üí M f)
    ‚Üí Preserves d e mg‚ÇÅ
    ‚Üí LawfulOn d e mg‚ÇÅ ‚Üí LawfulOn e f mg‚ÇÇ
    ‚Üí LawfulOn d f (Œª m ‚Üí mg‚ÇÇ (mg‚ÇÅ m))
  composeLawfulOn d e f mg‚ÇÅ mg‚ÇÇ pres l‚ÇÅ l‚ÇÇ m r =
    l‚ÇÇ (mg‚ÇÅ m) (pres m r) ‚àô l‚ÇÅ m r

  totalInvariantGivesBackTheGlobalLaw :
    ((d : Sys) (m : M d) ‚Üí R d m)
    ‚Üí (d e : Sys) (mg : M d ‚Üí M e) ‚Üí LawfulOn d e mg ‚Üí Lawful M obs d e mg
  totalInvariantGivesBackTheGlobalLaw tot d e mg l m = l m (tot d m)

------------------------------------------------------------------------
-- 3.  Preservation cannot be dropped
--
-- Three systems, indexed 0, 1, 2.  Every state space is `Bool`; the
-- invariant is "the state is `true`" everywhere; the middle system
-- observes a constant.  `mg‚` sends the reachable state to the
-- unreachable one, where `mg‚`'s law says nothing.
------------------------------------------------------------------------

State : ‚Ñï ‚Üí Type
State _ = Bool

look : (d : ‚Ñï) ‚Üí State d ‚Üí Bool
look zero          m = m
look (suc zero)    m = true
look (suc (suc _)) m = m

Inv : (d : ‚Ñï) ‚Üí State d ‚Üí Type
Inv _ m = m ‚â° true

mg‚ÇÅ : State 0 ‚Üí State 1
mg‚ÇÅ _ = false

mg‚ÇÇ : State 1 ‚Üí State 2
mg‚ÇÇ m = m

firstIsLawfulOnTheInvariant : LawfulOn State look Inv 0 1 mg‚ÇÅ
firstIsLawfulOnTheInvariant m r = sym r

secondIsLawfulOnTheInvariant : LawfulOn State look Inv 1 2 mg‚ÇÇ
secondIsLawfulOnTheInvariant m r = r

theCompositeIsNot : ¬¨ (LawfulOn State look Inv 0 2 (Œª m ‚Üí mg‚ÇÇ (mg‚ÇÅ m)))
theCompositeIsNot l = false‚â¢true (l true refl)

preservationIsNecessary : ¬¨ (Preserves State look Inv 0 1 mg‚ÇÅ)
preservationIsNecessary p = false‚â¢true (p true refl)

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The next step named above ‚î "extending the record with
-- preservation" ‚î is taken in
-- `TheSixthComponentIsFreeToCarryAndIsWhatMakesTheFifthCompose`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin ‚î check.sh returns 1 and says so):
-- `RCertified`, `composePreserves`, `composeRCertified`,
-- `noSelfRCertified`, and the independence witness.
--
-- Two things there were not visible from here.  `Preserves` COMPOSES
-- FOR NOTHING, so the sixth component is free to carry ‚î the price is
-- entirely in having to establish it per rewrite, not in sequencing.
-- And it is INDEPENDENT of the other five: the witness is a full
-- five-component `LCertified` whose observation type is `Unit`, so its
-- migration is globally lawful ‚î the strongest form of the fifth
-- component ‚î and it still leaves the invariant.
------------------------------------------------------------------------
