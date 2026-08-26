{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AFoolingSetForcesDistinctRectangles
--
-- Closes, as far as it goes, an item I left open one cycle ago:
-- `AFoolingPairForcesTwoRectangles` gave "at least two" from a fooling
-- PAIR and explicitly did not give the k-element version.  Here it is,
-- in the form that needs no counting: distinct members of a fooling set
-- are assigned DISTINCT rectangles by any sound cover.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED, AND WHAT "AS FAR AS IT GOES" MEANS
--
-- A fooling family is an index type `I` with cells `(r i , c i)` such
-- that for `i ≠ j` at least one exchanged corner is 0 — the standard
-- condition, in its either-corner form.  Given any assignment of a sound
-- rectangle to each cell, covering that cell, §2 shows the assignment is
-- injective.
--
-- INJECTIVITY IS NOT "≥ k".  Turning "distinct cells get distinct
-- rectangles" into "at least k rectangles" is a COUNTING step: it needs
-- `I` finite with k elements and a pigeonhole over the cover.  Neither
-- finiteness nor counting appears below, so the cardinality statement is
-- NOT proved and NOT claimed.  What is proved is the part that carries
-- the content — the injectivity — and the counting step is standard and
-- separate.
--
-- WHY THE EITHER-CORNER FORM.  `DSOCutCalibration`'s instance has the
-- 0 at one specific corner, and the pair lemma took that corner as its
-- hypothesis.  For a set, which corner is 0 can differ per pair, so the
-- hypothesis is a `⊎` and §2 does both cases.  That is the only thing
-- the generalisation costs.
--
-- WHAT IS NOT CLAIMED.  Nothing about r_e, d_e, raw width, or the
-- calibration's matrix — see that module and `AFoolingPairForcesTwoRectangles`
-- for what each does and does not establish.  No cover is constructed
-- here, so no upper bound is implied.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module AFoolingSetForcesDistinctRectangles where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import AFoolingPairForcesTwoRectangles
  using (Rect ; Sound ; Covers ; foolingPairNotInOneRectangle)

------------------------------------------------------------------------
-- 1.  A fooling family
------------------------------------------------------------------------

module _ (Row Col : Type) (M : Row → Col → Bool) where

  Fooling : (I : Type) (r : I → Row) (c : I → Col) → Type
  Fooling I r c =
    (i j : I) → ¬ (i ≡ j)
    → (M (r i) (c j) ≡ false) ⊎ (M (r j) (c i) ≡ false)

------------------------------------------------------------------------
-- 2.  Any sound cover is injective on a fooling family
------------------------------------------------------------------------

  foolingSetForcesDistinctRectangles :
    (I : Type) (r : I → Row) (c : I → Col)
    → Fooling I r c
    → (assign : I → Rect Row Col M)
    → ((i : I) → Sound Row Col M (assign i))
    → ((i : I) → Covers Row Col M (assign i) (r i) (c i))
    → (i j : I) → ¬ (i ≡ j) → ¬ (assign i ≡ assign j)
  foolingSetForcesDistinctRectangles I r c fool assign sound covers i j i≢j same
    with fool i j i≢j
  ... | inl zeroAtIJ =
    foolingPairNotInOneRectangle Row Col M (r i) (r j) (c i) (c j)
      zeroAtIJ (assign i) (sound i)
      ( covers i
      , subst (λ R → Covers Row Col M R (r j) (c j)) (sym same) (covers j) )
  ... | inr zeroAtJI =
    foolingPairNotInOneRectangle Row Col M (r j) (r i) (c j) (c i)
      zeroAtJI (assign i) (sound i)
      ( subst (λ R → Covers Row Col M R (r j) (c j)) (sym same) (covers j)
      , covers i )

------------------------------------------------------------------------
-- 3.  The reading
--
-- The pair lemma said one rectangle cannot hold two fooling cells.  §2
-- is that, quantified: a cover cannot reuse a rectangle across the
-- family at all.  The step from there to a numeric lower bound is
-- pigeonhole over a finite index, and it is deliberately outside this
-- module — the corpus's standing rule is that a count is not a
-- classification, and injectivity is the classification.
--
-- Note again what the proof uses: only the 0 at ONE exchanged corner per
-- pair, and the two `Covers` witnesses.  The 1-entries at the fooling
-- cells never appear, exactly as in the pair case.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by this module's author, at the end, altering no
-- line above.
--
-- §"WHAT IS PROVED, AND WHAT 'AS FAR AS IT GOES' MEANS" says:
-- "INJECTIVITY IS NOT '≥ k'.  Turning 'distinct cells get distinct
-- rectangles' into 'at least k rectangles' is a COUNTING step: it needs
-- `I` finite with k elements and a pigeonhole over the cover."
--
-- That step is now taken, in `NRectanglesCannotCoverSucNFoolingCells`,
-- using `Cubical.Data.Fin.Properties.pigeonhole-special` (which the
-- pinned library carries):
--
--   nRectanglesCannotCoverSucNFoolingCells :
--     (n : ℕ) (r : Fin (suc n) → Row) (c : Fin (suc n) → Col)
--     → Fooling (Fin (suc n)) r c
--     → (rects : Fin n → Rect) (pick : Fin (suc n) → Fin n)
--     → ((i) → Sound (rects (pick i)))
--     → ((i) → Covers (rects (pick i)) (r i) (c i))
--     → ⊥
--
-- IN THE CONTRAPOSITIVE, DELIBERATELY.  "At least k rectangles" is a
-- statement about a cardinal, and a cardinal needs the cover's index
-- counted.  The form above quantifies over the indexing instead:
-- whatever n-indexed family you offer, suc n fooling cells refute it.
-- That is the whole content of the numeric claim, stated without a
-- cardinality.
--
-- STILL NOT CLAIMED, and it is a different theorem rather than a gap:
-- any UPPER bound, and any claim that the maximum fooling set matches
-- the minimum cover — which is false in general for rectangle covers.
------------------------------------------------------------------------
