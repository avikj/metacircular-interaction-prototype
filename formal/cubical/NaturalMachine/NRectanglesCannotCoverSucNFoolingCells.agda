{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.NRectanglesCannotCoverSucNFoolingCells
--
-- Closes the last piece I left open on this line.
-- `AFoolingSetForcesDistinctRectangles` proved a sound cover is
-- INJECTIVE on a fooling family and said, in its own words: "INJECTIVITY
-- IS NOT '≥ k'.  Turning 'distinct cells get distinct rectangles' into
-- 'at least k rectangles' is a COUNTING step: it needs `I` finite with
-- k elements and a pigeonhole over the cover."
--
-- Here is that step, in the contrapositive form that needs no
-- arithmetic: a fooling family of `suc n` cells cannot be covered by a
-- family of `n` rectangles.  The pigeonhole is
-- `Cubical.Data.Fin.Properties.pigeonhole-special`, which the pinned
-- library already carries — I checked before planning on it:
--
--   pigeonhole-special : (f : Fin (suc n) → Fin n)
--     → Σ[ i ] Σ[ j ] (¬ i ≡ j) × (f i ≡ f j)
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THE CONTRAPOSITIVE IS THE HONEST FORM
--
-- "At least k rectangles" is a statement about a cardinal, and a
-- cardinal needs the cover's index to be finite and to be COUNTED.  The
-- statement below quantifies instead over the indexing itself: whatever
-- `n`-indexed family of rectangles you offer, and whatever assignment of
-- cells to it, a fooling family of `suc n` cells refutes it.  That is
-- the whole content of the numeric claim and it is stated without a
-- cardinality.
--
-- WHAT IS NOT CLAIMED.  Nothing about r_e, d_e, raw width, or
-- `DSOCutCalibration`'s matrix; no cover is constructed anywhere on this
-- line, so no upper bound is implied by any of it.  Nor is the general
-- "minimum cover size = maximum fooling set" claimed — that is false in
-- general for rectangle covers, and nothing here suggests otherwise:
-- §2 gives a LOWER bound only.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.NRectanglesCannotCoverSucNFoolingCells where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Fin.Properties using (pigeonhole-special)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.AFoolingPairForcesTwoRectangles
  using (Rect ; Sound ; Covers)
open import NaturalMachine.AFoolingSetForcesDistinctRectangles
  using (Fooling ; foolingSetForcesDistinctRectangles)

------------------------------------------------------------------------
-- 1.  A cover of n rectangles, and an assignment of cells to it
------------------------------------------------------------------------

module _ (Row Col : Type) (M : Row → Col → Bool) where

  ------------------------------------------------------------------
  -- 2.  suc n fooling cells cannot all be covered
  ------------------------------------------------------------------

  nRectanglesCannotCoverSucNFoolingCells :
    (n : ℕ)
    (r : Fin (suc n) → Row) (c : Fin (suc n) → Col)
    → Fooling Row Col M (Fin (suc n)) r c
    → (rects : Fin n → Rect Row Col M)
    → (pick : Fin (suc n) → Fin n)
    → ((i : Fin (suc n)) → Sound Row Col M (rects (pick i)))
    → ((i : Fin (suc n)) → Covers Row Col M (rects (pick i)) (r i) (c i))
    → ⊥
  nRectanglesCannotCoverSucNFoolingCells n r c fool rects pick sound covers =
    foolingSetForcesDistinctRectangles Row Col M
      (Fin (suc n)) r c fool
      (λ i → rects (pick i)) sound covers
      i j i≢j (cong rects samePick)
    where
      collision : Σ[ i ∈ Fin (suc n) ] Σ[ j ∈ Fin (suc n) ]
                    (¬ i ≡ j) × (pick i ≡ pick j)
      collision = pigeonhole-special pick

      i = collision .fst
      j = collision .snd .fst
      i≢j = collision .snd .snd .fst
      samePick = collision .snd .snd .snd

------------------------------------------------------------------------
-- 3.  The line, complete
--
--   AFoolingPairForcesTwoRectangles  one sound rectangle cannot hold two
--                                    fooling cells (carrier-free; uses
--                                    NEITHER 1-entry)
--   AFoolingSetForcesDistinctRectangles
--                                    a sound cover is injective on a
--                                    fooling family
--   this module                      and therefore n rectangles cannot
--                                    serve suc n fooling cells
--
-- Each step said what it did not do; each next step did exactly that and
-- said what IT did not do.  What is still not done, and is not a gap in
-- the line but a different theorem: any UPPER bound, and any claim that
-- the maximum fooling set matches the minimum cover.
------------------------------------------------------------------------
