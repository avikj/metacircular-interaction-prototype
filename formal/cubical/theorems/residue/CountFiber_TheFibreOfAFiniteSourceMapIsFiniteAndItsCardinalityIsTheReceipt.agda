{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡‡ô‡‡ñ‡‡Ø‡æ-‡‡®‡‡‡‡ ‚î the fibre of a finite-source map is finite, and its
-- cardinality is the ‡‡ô‡‡ñ‡‡Ø‡æ receipt.  The enzyme for the whole
-- finite-source tail of Lopa's queue (State‚, Shape, Pat, Ctx, Fact,
-- Three, ‚¶ ‚î dozens of small types), landed once so each such edge is a
-- one-line citation rather than a re-minted table.
--
-- For any map f : A ‚í B between FINITE SETS, every fibre is a finite set
-- (this is the library's `isFinSetFiber`), so it carries a computable
-- cardinality: the ‡‡ô‡‡ñ‡‡Ø‡æ.  That count IS the receipt in the counting
-- sense ‚î how many inputs the map identifies over a given output, exact,
-- decidable, with no table stored.
--
-- THE HONEST ‡‡‡‡‡∞ ‡Æ LINE, which is the point of doing it as counts and
-- not as a forced identification: `isFinSet X = Œ[n] ‚à X ‚â Fin n ‚à‚` ‚î
-- the cardinality is untruncated (`card`) but the EQUIVALENCE to `Fin n`
-- is behind a propositional truncation.  So this enzyme delivers the
-- ‡‡ô‡‡ñ‡‡Ø‡æ (the count, free for every finite-source map) but NOT by
-- itself the ‡‡‡ø‡‡‡û‡æ‡® (the untruncated identification `fibre ‚â Fin k`),
-- which needs the actual bijection and is available only for a concrete
-- map.  That gap is not a defect; it is exactly the corpus's standing
-- distinction between counting a loss and naming it ‚î ‡‡ô‡‡ñ‡‡Ø‡æ vs the
-- carried identification ‚î kept honest here rather than papered over.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates,
-- no holes.
------------------------------------------------------------------------

module SankhyaTantu_TheFibreOfAFiniteSourceMapIsFiniteAndItsCardinalityIsTheReceipt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.FinSet using (FinSet ; isFinSet ; card)
open import Cubical.Data.FinSet.Constructors using (isFinSetFiber)

private variable ‚Ñì : Level

module _ (A B : FinSet ‚Ñì) (f : A .fst ‚Üí B .fst) where

  ------------------------------------------------------------------------
  -- ‡ß ¬ the fibre is a finite set ‚î the library's isFinSetFiber, named
  -- here as the object of the receipt.
  ------------------------------------------------------------------------
  ‡§§‡§®‡•ç‡§§‡•Å‡§É : (b : B .fst) ‚Üí FinSet ‚Ñì
  ‡§§‡§®‡•ç‡§§‡•Å‡§É b = fiber f b , isFinSetFiber A B f b

  ------------------------------------------------------------------------
  -- ‡® ¬ ‡‡ô‡‡ñ‡‡Ø‡æ ‚î the cardinality of the fibre, the count receipt.
  -- Computable, exact, no table.  This is how many inputs f identifies
  -- over b.
  ------------------------------------------------------------------------
  ‡§∏‡§ô‡•ç‡§ñ‡•ç‡§Ø‡§æ : (b : B .fst) ‚Üí ‚Ñï
  ‡§∏‡§ô‡•ç‡§ñ‡•ç‡§Ø‡§æ b = card (‡§§‡§®‡•ç‡§§‡•Å‡§É b)
