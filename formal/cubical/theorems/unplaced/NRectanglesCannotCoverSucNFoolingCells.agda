{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NRectanglesCannotCoverSucNFoolingCells
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

module NRectanglesCannotCoverSucNFoolingCells where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Fin.Properties using (pigeonhole-special)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import AFoolingPairForcesTwoRectangles
  using (Rect ; Sound ; Covers)
open import AFoolingSetForcesDistinctRectangles
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

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  Recording site: commit 083dfbd2,
-- `NRectanglesCannotCoverSucNFoolingCellsEvenWhenTheCoveringIsOnlyAProperty`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin).
--
-- **THE COVERING HYPOTHESIS ABOVE IS STRUCTURE, NOT A PROPERTY.**  This
-- module is titled as an impossibility about COVERING, and covering is
-- naturally a property: a cell is covered when SOME sound rectangle of
-- the family contains it.  What §2 takes instead is a `pick : Fin (suc
-- n) → Fin n` together with pointwise `Sound (rects (pick i))` and
-- `Covers (rects (pick i)) (r i) (c i)` — a cover ALREADY EQUIPPED with
-- a choice of which rectangle serves each cell.  §"WHAT IS NOT CLAIMED"
-- above disclaims upper bounds, r_e, d_e, raw width and the
-- min-cover/max-fooling equality, and says nothing about the shape of
-- its own hypothesis.
--
-- **IT IS A PRICE, NOT A HOLE, AND BOTH FORMS ARE NOW PROVED.**
--
--   cannotCoverSigma      hypothesis `(i) → Σ[ k ] (Sound × Covers)`.
--                         FREE: a Π of Σ already contains its own
--                         choice function, so `pick i` is `fst (h i)`
--                         and the rest is projection.
--   cannotCoverTruncated  hypothesis `(i) → ∥ Σ[ k ] (Sound × Covers) ∥₁`,
--                         which is the honest reading of "is covered".
--                         No `pick` can be projected out — the
--                         conclusion for a single cell is not a
--                         proposition — and it goes through anyway, paid
--                         for by `finChoiceFin`, choice over a FINITE
--                         index into a truncation, proved by induction
--                         on the BOUND with `fsplit` and `subst`.  The
--                         final goal being `⊥`, a proposition, is what
--                         lets the truncation be eliminated at the end.
--
-- Neither repair restates anything here: both END at
-- `nRectanglesCannotCoverSucNFoolingCells`, handing it the same
-- `pick`/`sound`/`covers` triple built from the weaker hypothesis.
--
-- **AND FINITENESS IS NOW LOAD-BEARING FOR A SECOND, DIFFERENT REASON.**
-- Up to here `Fin` appeared on this line only because the pigeonhole
-- needs it.  `finChoiceFin` needs it for choice, which is unavailable
-- over an arbitrary index; so the line's use of finiteness is not one
-- fact but two, and §3's summary above — which presents the line as
-- three steps each naming what it did not do — is missing that.
--
-- NOTHING ABOVE IS RETRACTED.  §2 is true as stated and is the theorem
-- both repairs end at; §3's account of the three steps is correct as
-- far as it goes.  The name is NOT changed: renaming would break
-- importers and erase the record.
--
-- Still not done, as before, and not a gap in the line: any UPPER
-- bound, and the min-cover/max-fooling equality, which is false in
-- general for rectangle covers.
------------------------------------------------------------------------
