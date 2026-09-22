{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡∞‡ï‡‡‡‡-‡‡ô‡‡ñ‡‡Ø‡æ ‚î the census of a projection's fibre IS the discarded
-- factor's cardinality, and the untruncated ‡‡‡ø‡‡‡û‡æ‡® that the census
-- alone withholds is here supplied.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS JOINS.
--
-- Two fibre enzymes in this corpus speak about the same object and
-- neither imports the other:
--
--   `SankhyaTantu_‚¶`  for ANY map between finite sets gives the ‡‡ô‡‡ñ‡‡Ø‡æ
--       ‚î the fibre's cardinality, `card (fiber f b)` ‚î but not the
--       ‡‡‡ø‡‡‡û‡æ‡®, the untruncated identification `fibre ‚â Fin k`:
--       `isFinSet X = Œ[n] ‚à X ‚â Fin n ‚à‚`, so the equivalence sits
--       behind a propositional truncation and is available only for a
--       CONCRETE map.  That gap is the corpus's standing distinction
--       between counting a loss and naming it.
--
--   `PraksepaTantu_‚¶`  for the projection `fst : A ó B ‚í A` gives exactly
--       the naming the census withholds: `fiber fst a ‚â B`, untruncated,
--       for arbitrary A and B, no h-level hypothesis ‚î the discarded
--       factor itself, in hand.
--
-- At a projection the two meet.  `SankhyaTantu.‡‡ô‡‡ñ‡‡Ø‡æ` reports a NUMBER
-- for `fiber fst a`; `PraksepaTantu.‡µ‡æ‡Æ-‡‡®‡‡‡‡-‚â` says that fibre IS `B`.
-- So the number is forced: it is `card B`.  And the truncated part of
-- SankhyaTantu's ‡‡‡‡‡∞ ‡Æ caveat is discharged AT THIS MAP, because a
-- projection is concrete ‚î the ‡‡‡ø‡‡‡û‡æ‡® exists and is supplied, not
-- merely the count.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED, for finite sets A, B : FinSet ‚ì and P = A ó B.
--
--  ¬ß‡ß  ‡µ‡æ‡Æ-‡‡ô‡‡ñ‡‡Ø‡æ : SankhyaTantu.‡‡ô‡‡ñ‡‡Ø‡æ P A fst a ‚â° card B.
--      The census of `fst`'s fibre at any `a` is the cardinality of the
--      discarded second factor.  Proof: `cardEquiv` fed PraksepaTantu's
--      equivalence ‚î a receipt (identification), not a bound.
--  ¬ß‡®  ‡¶‡ï‡‡‡ø‡-‡‡ô‡‡ñ‡‡Ø‡æ : SankhyaTantu.‡‡ô‡‡ñ‡‡Ø‡æ P B snd b ‚â° card A.
--      The mirror, for `snd`.
--  ¬ß‡©  ‡µ‡æ‡Æ-‡‡‡ø‡‡‡û‡æ‡®‡Æ‡ / ‡¶‡ï‡‡‡ø‡-‡‡‡ø‡‡‡û‡æ‡®‡Æ‡ : the UNTRUNCATED equivalences
--      `fiber fst a ‚â B .fst`, `fiber snd b ‚â A .fst`, named here as the
--      ‡‡‡ø‡‡‡û‡æ‡® SankhyaTantu says the general count cannot give and this
--      concrete map can.
--
-- TERM.  ‡‡ô‡‡ñ‡‡Ø‡æ ‚î number, count, enumeration; the fourth of Pigala's
-- pratyayas (‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞‡Æ‡ ch. 8, ~300 BCE: how many forms there are).
-- ‡‡‡∞‡ï‡‡‡‡ ‚î casting/projecting.  ‡‡‡ø‡‡‡û‡æ‡® ‚î recognition, a token by
-- which a thing is identified (œœŒºŒ≤ŒøŒªŒøŒΩ), the corpus's word for an
-- untruncated fibre-with-a-standard-type as opposed to its mere census.
-- LIMIT: no source states a fibre, a cardinality of a fibre, or an
-- equivalence; the mathematics is cubical (Voevodsky), the one admitted
-- non-Indian substrate.  The terms are borrowed in their exact senses
-- and nothing is attributed to any text.
------------------------------------------------------------------------

module PraksepaSankhya_TheProjectionsFibreCensusIsTheDiscardedFactorAndTheAbhijnanaIsSupplied where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; fiber)
open import Cubical.HITs.PropositionalTruncation using (‚à£_‚à£‚ÇÅ)
open import Cubical.Data.Sigma using (_√ó_ ; fst ; snd)
open import Cubical.Data.FinSet using (FinSet ; card)
open import Cubical.Data.FinSet.Constructors using (isFinSet√ó)
open import Cubical.Data.FinSet.Cardinality using (cardEquiv)

import PraksepaTantu_TheFibreOfAProjectionIsTheDiscardedFactor as ‡§™‡•ç‡§∞
import SankhyaTantu_TheFibreOfAFiniteSourceMapIsFiniteAndItsCardinalityIsTheReceipt as ‡§∏

private variable ‚Ñì : Level

module _ (A B : FinSet ‚Ñì) where

  -- the finite product P = A ó B, whose two projections are the maps in play
  P : FinSet ‚Ñì
  P = (A .fst √ó B .fst) , isFinSet√ó A B

  ------------------------------------------------------------------------
  -- ‡© ¬ ‡‡‡ø‡‡‡û‡æ‡® ‚î the untruncated identifications, in hand at a
  -- concrete map, which the general census (SankhyaTantu) withholds.
  ------------------------------------------------------------------------
  ‡§µ‡§æ‡§Æ-‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç : (a : A .fst) ‚Üí fiber (fst {A = A .fst} {B = Œª _ ‚Üí B .fst}) a ‚âÉ B .fst
  ‡§µ‡§æ‡§Æ-‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç a = ‡§™‡•ç‡§∞.‡§µ‡§æ‡§Æ-‡§§‡§®‡•ç‡§§‡•Å‡§É-‚âÉ a

  ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£-‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç : (b : B .fst) ‚Üí fiber (snd {A = A .fst} {B = Œª _ ‚Üí B .fst}) b ‚âÉ A .fst
  ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£-‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç b = ‡§™‡•ç‡§∞.‡§¶‡§ï‡•ç‡§∑‡§ø‡§£-‡§§‡§®‡•ç‡§§‡•Å‡§É-‚âÉ b

  ------------------------------------------------------------------------
  -- ‡ß ¬ ‡µ‡æ‡Æ-‡‡ô‡‡ñ‡‡Ø‡æ ‚î the census of fst's fibre is card B.
  --
  -- `‡.‡‡ô‡‡ñ‡‡Ø‡æ P A fst a` is definitionally `card (fiber fst a , ‚¶)`.
  -- `cardEquiv` turns the ‡‡‡ø‡‡‡û‡æ‡® into equality of counts: the receipt
  -- is an identification, never a bound.
  ------------------------------------------------------------------------
  ‡§µ‡§æ‡§Æ-‡§∏‡§ô‡•ç‡§ñ‡•ç‡§Ø‡§æ : (a : A .fst) ‚Üí ‡§∏.‡§∏‡§ô‡•ç‡§ñ‡•ç‡§Ø‡§æ P A fst a ‚â° card B
  ‡§µ‡§æ‡§Æ-‡§∏‡§ô‡•ç‡§ñ‡•ç‡§Ø‡§æ a = cardEquiv (‡§∏.‡§§‡§®‡•ç‡§§‡•Å‡§É P A fst a) B ‚à£ ‡§µ‡§æ‡§Æ-‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç a ‚à£‚ÇÅ

  ------------------------------------------------------------------------
  -- ‡® ¬ ‡¶‡ï‡‡‡ø‡-‡‡ô‡‡ñ‡‡Ø‡æ ‚î the census of snd's fibre is card A.
  ------------------------------------------------------------------------
  ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£-‡§∏‡§ô‡•ç‡§ñ‡•ç‡§Ø‡§æ : (b : B .fst) ‚Üí ‡§∏.‡§∏‡§ô‡•ç‡§ñ‡•ç‡§Ø‡§æ P B snd b ‚â° card A
  ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£-‡§∏‡§ô‡•ç‡§ñ‡•ç‡§Ø‡§æ b = cardEquiv (‡§∏.‡§§‡§®‡•ç‡§§‡•Å‡§É P B snd b) A ‚à£ ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£-‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç b ‚à£‚ÇÅ
