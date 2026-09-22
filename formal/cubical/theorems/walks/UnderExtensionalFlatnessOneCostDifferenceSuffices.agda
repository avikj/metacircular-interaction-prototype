{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- UnderExtensionalFlatnessOneCostDifferenceSuffices
--
--
--   Â§4  "Theorem 28.2: any two elimination orders of I give the same
--        boundary factor.  Exact dependency elimination is extensionally
--        flat: different internal histories, one boundary transformer."
--   Â§5  "Different orders create different fill-in scopes; PeakScope and
--        PeakEntries are order-dependent even though the result is not.
--        Semantic flatness does not imply computational flatness."
--
-- Â§2 is what the pairing gives, and it is sharper than the general
-- non-factoring lemma: under flatness, EVERY pair of orders is already a
-- collision, so a SINGLE cost difference â” anywhere â” refutes the
-- existence of a decoder from result to cost.  No collision has to be
-- hunted for.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS ADDS TO THE STANDING LEMMA
--
-- `TranscriptDescent.collisionObstructsDecoder` needs two objects the
-- observation identifies and the transcript separates, and finding such
-- a pair is normally the work.  Flatness supplies the first half for
-- free at every pair.  So the practical statement for an
-- order-selection problem is: correctness constrains the choice of order
-- NOT AT ALL, and every scrap of information about which order to pick
-- lives in the cost model.  Â§5's sentence, from the other side.
--
-- KEPT APART.  This is not `AskingIsNotAPropertyOfTheFunction` or
-- `Anuvrtti` again.  Those exhibit a specific collision to refute a
-- specific factoring.  Here the collision is a THEOREM ABOUT THE
-- HYPOTHESIS: flatness makes collisions universal, which is why one
-- difference suffices.  Same lemma downstream, different work upstream.
------------------------------------------------------------------------

module UnderExtensionalFlatnessOneCostDifferenceSuffices where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

------------------------------------------------------------------------
-- 1.  Orders, their result, their cost, and flatness
------------------------------------------------------------------------

module _ (Order Result Cost : Type)
         (result : Order â†’ Result) (cost : Order â†’ Cost) where

  -- Â§4's conclusion, taken as a hypothesis
  Flat : Type
  Flat = (o o' : Order) â†’ result o â‰¡ result o'

  --------------------------------------------------------------------
  -- 2.  Under flatness a single cost difference refutes the decoder
  --------------------------------------------------------------------

  oneCostDifferenceSuffices :
    Flat â†’ (o o' : Order) â†’ Â¬ (cost o â‰¡ cost o')
    â†’ Â¬ FactorsThrough result cost
  oneCostDifferenceSuffices flat o o' differ =
    collisionObstructsDecoder result cost {o} {o'} (flat o o') differ

  -- restated as the operative fact for order selection: if the result is
  -- flat, then either every order costs the same, or no invariant of the
  -- result can tell you which to pick
  correctnessSaysNothingAboutCost :
    Flat
    â†’ ((o o' : Order) â†’ Â¬ (cost o â‰¡ cost o') â†’ Â¬ FactorsThrough result cost)
  correctnessSaysNothingAboutCost = oneCostDifferenceSuffices

------------------------------------------------------------------------
-- 3.  The limit, stated so Â§2 is not read as more than it is
--
-- Flatness does NOT by itself refute the decoder.  If the cost is also
-- constant, the decoder exists â” take the constant function â” and Â§2's
-- hypothesis `Â (cost o â‰¡ cost o')` is unsatisfiable.  So Â§2 is exactly:
-- flatness converts ANY observed cost difference into an obstruction,
-- and supplies no obstruction on its own.
--
-- That is the whole of what Â§4 and Â§5 give when put together, and it is
-- why "semantic flatness does not imply computational flatness" is a
-- claim about the cost model and not about the semantics: the semantics
-- has, by Â§4, nothing left to say.
------------------------------------------------------------------------
