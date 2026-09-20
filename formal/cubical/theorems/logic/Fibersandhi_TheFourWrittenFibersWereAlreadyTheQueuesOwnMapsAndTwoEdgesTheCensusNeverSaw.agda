{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àà¨ààààà¨àà§à¿ â” àà¨àààà à²à¿à–à¿àà, à—àà¨à¾ àà àà¨àà§à¾ à
--
-- (the fiber was written; it was the census that could not see.)
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE METHOD, and its false-positive rate, which is the point.
--
-- `interactive/Lopa_â¦hs` grades 1046 one-way edges in this corpus UNDECIDED:
-- no syntactic rule names a fiber.  But a fiber WRITTEN OUT is a Î ending
-- in an equation into the index â”
--
--     Fib n = Î[ w âˆˆ Word ] (value w â‰¡ n)
--
-- â” and 46 such definitions already exist in `formal/cubical` and
-- `fiber/src`.  Joining their SOURCE TYPES against the queue's
-- gives leads.  A source-type match is a LEAD AND NOT A VERDICT: eleven
-- leads were examined and SIX DIED on inspection.  They are listed by
-- name in Â§à¦ below, because a method's false-positive rate is what
-- decides whether to run it on the other 238 source types, and a report
-- that prints only its hits has measured nothing.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED.  Nothing is constructed; all four are `refl`.
--
--   `fiber f b` unfolds to `Î[ a ] (f a â‰¡ b)`.  Where the written type
--   is literally that Î for a map the census is holding, the two types
--   are equal on the nose and the identification costs one line.
--
-- Â§à§  chargeOneFiber  â‰¡  fiber chargeOneProjector true   (queued edge)
-- Â§à¨  Fib n           â‰¡  fiber value n                   (queued edge)
-- Â§à©  EvenQuery       â‰¡  fiber (sgn âˆ˜ Î©) true            (COMPOSITE of
--     two queued edges, `Number âŸ â• Â Î©` and `â• âŸ Bool Â sgn`; the
--     composite is not itself a queue entry, and this is stated rather
--     than smoothed over, because the queue does not contain the map
--     this fiber belongs to â” it contains its two halves.)
-- Â§à  ThreeKernel     â‰¡  fiber triple (pos 0)            (NOT IN THE
--     QUEUE AT ALL, see below.)
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE TWO EDGES THE CENSUS NEVER SAW, which is the finding.
--
-- `triple : â â’ â` (`S3IntegerRelativeCoordinates.agda:83`) and
-- `à®à¾ààà°à¾ : à°àà â’ â•` (`fiber/src/â¦/Prastara_â¦.agda:157`) are
-- top-level, total, non-injective maps whose fibers are written 12 and
-- 95 lines below them respectively.  NEITHER APPEARS among the 1046.
-- So the queue's number is not an upper bound on the corpus's one-way
-- edges and was being read as one.  The reason the parse drops them is
-- not established here and is left open rather than guessed; a verdict
-- guessed is worse than a verdict withheld, which is the census's own
-- standing line about itself.
--
-- The à®à¾ààà°à¾ closure is NOT carried in this module: `LosslessReturn.â¦` is a
-- separate library root and importing it here would change what
-- `formal/check.sh` builds.  It is `refl` in exactly the same way, and
-- belongs in that root.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- CHECKED: --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module Tantusandhi_TheFourWrittenFibersWereAlreadyTheQueuesOwnMapsAndTwoEdgesTheCensusNeverSaw where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Bool using (Bool ; true)
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Int using (â„¤ ; pos)

open import ChenTwoChargeProjector using (Charge ; chargeOneProjector ; chargeOneFiber)
open import CarryFiber using (Word ; value ; Fib)
open import ParitySeparator using (Number ; Î© ; sgn)
open import OracleSeparation using (EvenQuery)
open import S3IntegerRelativeCoordinates using (triple ; ThreeKernel)

------------------------------------------------------------------------
-- à¦.  THE SIX THAT DIED, named, with the reason each died.
--
-- Every one of the six is a Î over a source type that the queue does
-- carry.  The type-level shape is what kills them, and the shape is
-- worth stating because it is a REPAIR to the join, not an excuse:
--
--   (i)  a NEGATED equation is not a fiber.  `fiber f b` is
--        `Î[ a ] (f a â‰¡ b)`; `Î[ a ] Â (f a â‰¡ b)` is its complement and
--        is a fiber of nothing.
--          Â LawfulContinuationCore.AdmissibleModulus  (Î[ q âˆˆ â• ] Â (L mod q â‰¡ zero))
--          Â LawfulContinuationCore.BranchingFiber     (Î left Î right Â left â‰¡ right)
--          Â OracleSeparation.Charged                  (Î[ Ï âˆˆ Signs ] Â (P Ï â‰¡ P (flip Ï)))
--        The middle one is named "â¦Fiber" and is not one; the name was
--        the whole of its evidence.
--
--   (ii) a FIXED-POINT type is not a fiber.  `Î[ a ] (g a â‰¡ a)` is the
--        equalizer of g and the identity: the index varies with the
--        point, so there is no b for `fiber g b` to be taken over.
--          Â RelationalTensorObstructionBridge.LoopStable  (Î[ phase âˆˆ Bool ] subst â¦ loop phase â‰¡ phase)
--          Â S3ConjugacyObservation.Fixed                  (Î[ x âˆˆ Fin3 ] g .fst x â‰¡ x)
--        LoopStable additionally occurs in the queue as a TARGET, never
--        as a source, so the join matched it on the wrong end.
--
--   (iii) right shape, WRONG MAP.  PingalaPrastara's `à²à˜à-àà™àà–àà¯à¾` counts
--        laghus; `Metre`'s equation is over `matraOf`, which sums morae.
--        Same two types, different map, no identification.  (Checked and
--        reported in the previous pass; the `matraOf` fibers themselves
--        did close, in `Chandomudra_â¦agda`.)
--
-- FOUR of eleven leads closed; SIX died; one closed only after the
-- source-type match was replaced by a map-level one.  So the join on
-- source types alone runs at roughly 55% false positives, and the two
-- cheap filters that would remove most of them â” reject a negated
-- equation, reject an equation whose right side mentions the bound
-- variable â” are stated above as text because they are one grep each.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- à§.  Charge âŸ Bool Â chargeOneProjector      (queue entry)
------------------------------------------------------------------------

chargeOneFiber-is-fiber : chargeOneFiber â‰¡ fiber chargeOneProjector true
chargeOneFiber-is-fiber = refl

------------------------------------------------------------------------
-- à¨.  Word âŸ â• Â value                        (queue entry)
--
-- This is the edge whose fiber the host module already proved is NOT of
-- constant cardinality â” `Fib 1` contractible, `Fib 2` two points â” so
-- the receipt for this lossy map is a named type that is provably not a
-- torsor.  Naming it as a fiber is what lets that statement be about the
-- map rather than about a coincidence of definitions.
------------------------------------------------------------------------

Fib-is-fiber : (n : â„•) â†’ Fib n â‰¡ fiber value n
Fib-is-fiber _ = refl

------------------------------------------------------------------------
-- à©.  Number âŸ â• Â Î©  then  â• âŸ Bool Â sgn    (two queue entries)
--
-- The queue holds the two halves; the written fiber belongs to the
-- composite.  A fiber of a composite is not a fiber of either factor,
-- and the identification below is therefore about a map the census is
-- not holding â” which is a statement about the census's granularity and
-- is recorded as one.
------------------------------------------------------------------------

sgnÎ© : Number â†’ Bool
sgnÎ© n = sgn (Î© n)

EvenQuery-is-fiber : EvenQuery â‰¡ fiber sgnÎ© true
EvenQuery-is-fiber = refl

------------------------------------------------------------------------
-- à.  â âŸ â Â triple                          (NOT a queue entry)
------------------------------------------------------------------------

ThreeKernel-is-fiber : ThreeKernel â‰¡ fiber triple (pos 0)
ThreeKernel-is-fiber = refl
