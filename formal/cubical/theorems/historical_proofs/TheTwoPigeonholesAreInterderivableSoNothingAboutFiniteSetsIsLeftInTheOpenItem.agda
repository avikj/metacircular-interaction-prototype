{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTwoPigeonholesAreInterderivableSoNothingAboutFiniteSetsIsLeftInTheOpenItem
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Both statements here are ones I wrote about `OptimalObservation`'s own
-- definition; there is no source to cite, and a fabricated 
-- label would assert a provenance nobody checked.  That module's three
-- INSTANCES are Pigala's *Chandastra* uddia (c. 300 BCE),
-- Virahka's mtrmeru (c. 600‚ì800) and a CRT residue decode, named
-- here in that order and before any later name; **nothing below is a
-- claim about their mathematics.**  Checked before naming:
-- `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- first.  `--guardedness` carried; infective.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- 0.  A THIRD UPSTREAM BREAKAGE, and why this cycle's target changed
--
-- The intended target was `GterTwoCoordinate`, whose
-- header claims *"Nothing here is measured, fitted, or floating-point"*
-- ‚î a claim worth checking rather than trusting.  It cannot be checked
-- here:
--
--   cd formal/cubical && agda -i . NaturalMachine/GterTwoCoordinate.agda
--   ‚í GTER_EXIT=42
--   first error: GterTwoCoordinate.agda:205,1-5
--   "Multiple definitions of comp. Previous definition at ‚¶"
--
-- **That is a THIRD breakage, independent of the two already on
-- record** ‚î `Transport.agda:46` (`solve‚ï!` not exported by
-- `Cubical.Tactics.NatSolver.Reflection`) and
-- `DSONucleusOneSidedProduct.agda:17` (`Cubical.Data.Int` has no
-- `min`/`max`).  This one is a NAME COLLISION with
-- `Cubical.Core.Primitives`' `comp`, which is a trap already on my own
-- list; under the declared pin it evidently does not fire.  Three
-- distinct causes, all from the container not being the pin.  None is
-- mine and none is touched.  So this module was built on the only
-- ground known green: my own two modules and the library.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- 1.  WHAT IS PROVED, and it closes the smaller half of (w‚≥)
--
-- At 806bd0ea I proved `FinPigeonhole ‚í TheOpenPigeonhole` and wrote
-- that the converse *"is not proved either, though it should be
-- immediate at `X = Y = SFin n`"*.  It is, and here it is:
--
--   finSetOn n     the `FinSet` structure carried by `SFin n` itself ‚î
--                  `card` is `n` and the mere equivalence is `idEquiv`
--   theOpenPigeonholeGivesFinPigeonhole
--                  `TheOpenPigeonhole ‚í FinPigeonhole`, by instantiating
--                  at that structure on both sides, where the `card`
--                  conjunct of `Optimal` is `refl`
--
-- **TOGETHER WITH 806bd0ea THE TWO STATEMENTS ARE INTERDERIVABLE**, and
-- that is the point rather than the convenience.  The open item was
-- posed over `FinSet`, with cardinalities, mere equivalences and a
-- truncation to escape; it is now known to contain **no FinSet content
-- at all**.  Whatever is hard about it is hard about `‚ä ‚ä (‚ä ‚ä ‚¶ )`.
-- A reduction in one direction leaves open the possibility that the
-- general statement is strictly stronger; the second direction removes
-- it, and *that* is what "reduces to" could not say on its own ‚î
-- the distinction this line logged at 806bd0ea, now discharged.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheTwoPigeonholesAreInterderivableSoNothingAboutFiniteSetsIsLeftInTheOpenItem where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (idEquiv)
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Data.FinSet using (FinSet)
open import Cubical.Data.SumFin using () renaming (Fin to SFin)
open import Cubical.HITs.PropositionalTruncation using (‚à£_‚à£‚ÇÅ)

open import TheOpenPigeonholeReducesToFinAndTheTargetBeingAPropIsWhatMakesTheMereEquivalencesUsable
  using (FinPigeonhole)
open import TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself
  using (TheOpenPigeonhole)

------------------------------------------------------------------------
-- 2.  `SFin n` is its own finite set, with `card` definitionally `n`
------------------------------------------------------------------------

finSetOn : ‚Ñï ‚Üí FinSet ‚Ñì-zero
finSetOn n = SFin n , n , ‚à£ idEquiv (SFin n) ‚à£‚ÇÅ

------------------------------------------------------------------------
-- 3.  ‚¶so the general statement instantiates back to the finite one
--
-- The `card` conjunct of `Optimal` is `card (finSetOn n) ‚â° card
-- (finSetOn n)`, i.e. `n ‚â° n`, so `refl` discharges it and only the
-- injectivity hypothesis is passed through.
------------------------------------------------------------------------

theOpenPigeonholeGivesFinPigeonhole : TheOpenPigeonhole ‚Üí FinPigeonhole
theOpenPigeonholeGivesFinPigeonhole general n f inj =
  general (finSetOn n) (finSetOn n) f (inj , refl)
