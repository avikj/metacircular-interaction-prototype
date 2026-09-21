{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTwoDirectionsUpgradeToAnEquivalenceBecauseBothSidesArePropositions
--
-- ON THE NAME.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/` and
-- invented.**  Counting how many members of a finite collection satisfy
-- a predicate is Jaina enumerative territory (*Anuyogadvra*,
-- *Sthnga*) and I have NOT established that as the source of
-- anything here; the h-level argument is Voevodsky's substrate, which
-- this repository declares as a tool and not a frame.  A  label
-- would assert a provenance nobody checked.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE AUDIT.  Target: `RateOneIsExactlyTheUniversalClaim`, an
-- `Exactly` â” a biconditional claim.
--
-- **THE TITLE IS EARNED, IN THE WEAK SENSE, AND THAT WAS THE QUESTION
-- ASKED.**  Both directions are there: `allGivesFullCount` and
-- `fullCountGivesAll`, each a plain induction on the list.  Nothing is
-- assumed, nothing is smuggled, and neither direction is more expensive
-- than the other â” which is what diagnostic (1) predicts when the two
-- sides are joined by an INDUCTION rather than by an implication
-- assumed or a path given.
--
-- **BUT THE MODULE SAYS SOMETHING STRONGER THAN IT PROVES, AND IT IS
-- TRUE, AND IT IS FREE.**  Its Â§2 heading is *"The universal claim and
-- rate one are the same claim"*, and its prose says `count bs â‰¡ length
-- bs` and `All bs` "are the same claim".  Two implications are not
-- sameness â” they are logical equivalence, and for general types that
-- is strictly weaker than identity of the propositions.  Â§"WHAT IS
--
-- **HERE THE STRONGER READING HOLDS, AND THE REASON IS AN H-LEVEL, NOT
-- AN INDUCTION.**  `count bs â‰¡ length bs` is a path in â• and â• is a
-- set, so it is a proposition.  `All bs` is an iterated product of
-- paths in `Bool` and `Bool` is a set, so it is a proposition too.  Two
-- propositions that imply each other are EQUIVALENT â” `propBiimplâ’Equiv`
-- â” so Â§2's two functions do assemble into `All bs â‰ (count bs â‰¡ length
-- bs)`, and the module's own prose was right by an argument it did not
-- give.
--
-- **THE POINT IS NOT THAT IT WAS WRONG.**  It is that "the same claim"
-- has two readings that read identically in prose, exactly like `free`
-- did at 28e9a0a4, and the one that holds here holds for a reason â”
-- both sides being propositions â” that fails as soon as the population
-- carries data rather than Booleans.  Over `List A` with `A` a general
-- type, `All` need not be a proposition and the upgrade is unavailable.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   isPropAll        `All bs` is a proposition, by induction with
--                    `isProp—` and `isSetBool`
--   isPropRateOne    so is `count bs â‰¡ length bs`, by `isSetâ•`
--   allIsRateOne     hence `All bs â‰ (count bs â‰¡ length bs)`, with the
--                    audited module's two functions REUSED, not
--                    restated
------------------------------------------------------------------------

module TheTwoDirectionsUpgradeToAnEquivalenceBecauseBothSidesArePropositions where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; propBiimplâ†’Equiv)
open import Cubical.Foundations.HLevels using (isPropÃ—)
open import Cubical.Data.Nat using (â„• ; isSetâ„•)
open import Cubical.Data.Bool using (Bool ; true ; isSetBool)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; isPropUnit)

open import RateOneIsExactlyTheUniversalClaim
  using (All ; count ; length ; allGivesFullCount ; fullCountGivesAll)

------------------------------------------------------------------------
-- 1.  Both sides are propositions
------------------------------------------------------------------------

isPropAll : (bs : List Bool) â†’ isProp (All bs)
isPropAll []       = isPropUnit
isPropAll (b âˆ· bs) = isPropÃ— (isSetBool b true) (isPropAll bs)

isPropRateOne : (bs : List Bool) â†’ isProp (count bs â‰¡ length bs)
isPropRateOne bs = isSetâ„• (count bs) (length bs)

------------------------------------------------------------------------
-- 2.  So the two directions are an equivalence, not merely a pair
------------------------------------------------------------------------

allIsRateOne : (bs : List Bool) â†’ All bs â‰ƒ (count bs â‰¡ length bs)
allIsRateOne bs =
  propBiimplâ†’Equiv
    (isPropAll bs)
    (isPropRateOne bs)
    (allGivesFullCount bs)
    (fullCountGivesAll bs)
