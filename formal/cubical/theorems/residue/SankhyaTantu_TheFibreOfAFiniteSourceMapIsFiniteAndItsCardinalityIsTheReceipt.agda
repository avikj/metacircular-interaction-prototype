{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- सङ्ख्या-तन्तुः — the fibre of a finite-source map is finite, and its
-- cardinality is the सङ्ख्या receipt.  The enzyme for the whole
-- finite-source tail of Lopa's queue (State₂, Shape, Pat, Ctx, Fact,
-- Three, … — dozens of small types), landed once so each such edge is a
-- one-line citation rather than a re-minted table.
--
-- For any map f : A → B between FINITE SETS, every fibre is a finite set
-- (this is the library's `isFinSetFiber`), so it carries a computable
-- cardinality: the सङ्ख्या.  That count IS the receipt in the counting
-- sense — how many inputs the map identifies over a given output, exact,
-- decidable, with no table stored.
--
-- THE HONEST सूत्र ८ LINE, which is the point of doing it as counts and
-- not as a forced identification: `isFinSet X = Σ[n] ∥ X ≃ Fin n ∥₁` —
-- the cardinality is untruncated (`card`) but the EQUIVALENCE to `Fin n`
-- is behind a propositional truncation.  So this enzyme delivers the
-- सङ्ख्या (the count, free for every finite-source map) but NOT by
-- itself the अभिज्ञान (the untruncated identification `fibre ≃ Fin k`),
-- which needs the actual bijection and is available only for a concrete
-- map.  That gap is not a defect; it is exactly the corpus's standing
-- distinction between counting a loss and naming it — सङ्ख्या vs the
-- carried identification — kept honest here rather than papered over.
--
-- SYĀT — THE CLAIM, EXACTLY.  Not `fibre ≃ Fin (card)` as a bare consequence
-- (that is the truncated part).  Not anything about infinite-source maps
-- (the ℕ-source front is the recurrence emitter's, disjoint).  This is
-- the count, for finite sources, as the shared enzyme.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates,
-- no holes.
------------------------------------------------------------------------

module SankhyaTantu_TheFibreOfAFiniteSourceMapIsFiniteAndItsCardinalityIsTheReceipt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.FinSet using (FinSet ; isFinSet ; card)
open import Cubical.Data.FinSet.Constructors using (isFinSetFiber)

private variable ℓ : Level

module _ (A B : FinSet ℓ) (f : A .fst → B .fst) where

  ------------------------------------------------------------------------
  -- १ · the fibre is a finite set — the library's isFinSetFiber, named
  -- here as the object of the receipt.
  ------------------------------------------------------------------------
  तन्तुः : (b : B .fst) → FinSet ℓ
  तन्तुः b = fiber f b , isFinSetFiber A B f b

  ------------------------------------------------------------------------
  -- २ · सङ्ख्या — the cardinality of the fibre, the count receipt.
  -- Computable, exact, no table.  This is how many inputs f identifies
  -- over b.
  ------------------------------------------------------------------------
  सङ्ख्या : (b : B .fst) → ℕ
  सङ्ख्या b = card (तन्तुः b)
