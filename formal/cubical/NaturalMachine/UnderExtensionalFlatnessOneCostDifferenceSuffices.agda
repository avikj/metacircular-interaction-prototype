-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.UnderExtensionalFlatnessOneCostDifferenceSuffices
--
-- `notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md` pairs two sections:
--
--   §4  "Theorem 28.2: any two elimination orders of I give the same
--        boundary factor.  Exact dependency elimination is extensionally
--        flat: different internal histories, one boundary transformer."
--   §5  "Different orders create different fill-in scopes; PeakScope and
--        PeakEntries are order-dependent even though the result is not.
--        Semantic flatness does not imply computational flatness."
--
-- §2 is what the pairing gives, and it is sharper than the general
-- non-factoring lemma: under flatness, EVERY pair of orders is already a
-- collision, so a SINGLE cost difference — anywhere — refutes the
-- existence of a decoder from result to cost.  No collision has to be
-- hunted for.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS ADDS TO THE STANDING LEMMA
--
-- `TranscriptDescent.collisionObstructsDecoder` needs two objects the
-- observation identifies and the transcript separates, and finding such
-- a pair is normally the work.  Flatness supplies the first half for
-- free at every pair.  So the practical statement for an
-- order-selection problem is: correctness constrains the choice of order
-- NOT AT ALL, and every scrap of information about which order to pick
-- lives in the cost model.  §5's sentence, from the other side.
--
-- WHAT IS NOT CLAIMED.  NOT Theorem 28.2 — flatness is a HYPOTHESIS
-- here, named `Flat`, and nothing below proves it for elimination
-- orders or for anything else.  NOT anything about PeakScope,
-- PeakEntries, fill-in, treewidth, the tropical Schur complement, or
-- any other section of that note.  NOT that costs must differ: §3 says
-- plainly that if the cost is also constant the decoder exists, and that
-- case is exactly the uninteresting one.
--
-- KEPT APART.  This is not `AskingIsNotAPropertyOfTheFunction` or
-- `Anuvrtti` again.  Those exhibit a specific collision to refute a
-- specific factoring.  Here the collision is a THEOREM ABOUT THE
-- HYPOTHESIS: flatness makes collisions universal, which is why one
-- difference suffices.  Same lemma downstream, different work upstream.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.UnderExtensionalFlatnessOneCostDifferenceSuffices where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.FiniteInformation using (FactorsThrough)
open import NaturalMachine.TranscriptDescent using (collisionObstructsDecoder)

------------------------------------------------------------------------
-- 1.  Orders, their result, their cost, and flatness
------------------------------------------------------------------------

module _ (Order Result Cost : Type)
         (result : Order → Result) (cost : Order → Cost) where

  -- §4's conclusion, taken as a hypothesis
  Flat : Type
  Flat = (o o' : Order) → result o ≡ result o'

  --------------------------------------------------------------------
  -- 2.  Under flatness a single cost difference refutes the decoder
  --------------------------------------------------------------------

  oneCostDifferenceSuffices :
    Flat → (o o' : Order) → ¬ (cost o ≡ cost o')
    → ¬ FactorsThrough result cost
  oneCostDifferenceSuffices flat o o' differ =
    collisionObstructsDecoder result cost {o} {o'} (flat o o') differ

  -- restated as the operative fact for order selection: if the result is
  -- flat, then either every order costs the same, or no invariant of the
  -- result can tell you which to pick
  correctnessSaysNothingAboutCost :
    Flat
    → ((o o' : Order) → ¬ (cost o ≡ cost o') → ¬ FactorsThrough result cost)
  correctnessSaysNothingAboutCost = oneCostDifferenceSuffices

------------------------------------------------------------------------
-- 3.  The limit, stated so §2 is not read as more than it is
--
-- Flatness does NOT by itself refute the decoder.  If the cost is also
-- constant, the decoder exists — take the constant function — and §2's
-- hypothesis `¬ (cost o ≡ cost o')` is unsatisfiable.  So §2 is exactly:
-- flatness converts ANY observed cost difference into an obstruction,
-- and supplies no obstruction on its own.
--
-- That is the whole of what §4 and §5 give when put together, and it is
-- why "semantic flatness does not imply computational flatness" is a
-- claim about the cost model and not about the semantics: the semantics
-- has, by §4, nothing left to say.
------------------------------------------------------------------------
