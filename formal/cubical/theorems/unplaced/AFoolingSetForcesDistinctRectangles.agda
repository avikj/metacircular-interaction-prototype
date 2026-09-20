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
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED, AND WHAT "AS FAR AS IT GOES" MEANS
--
-- A fooling family is an index type `I` with cells `(r i , c i)` such
-- that for `i â‰  j` at least one exchanged corner is 0 â” the standard
-- condition, in its either-corner form.  Given any assignment of a sound
-- rectangle to each cell, covering that cell, Â§2 shows the assignment is
-- injective.
--
-- INJECTIVITY IS NOT "â‰ k".  Turning "distinct cells get distinct
-- rectangles" into "at least k rectangles" is a COUNTING step: it needs
-- `I` finite with k elements and a pigeonhole over the cover.  Neither
-- finiteness nor counting appears below, so the cardinality statement is
-- NOT proved and NOT claimed.  What is proved is the part that carries
-- the content â” the injectivity â” and the counting step is standard and
-- separate.
--
-- WHY THE EITHER-CORNER FORM.  `DSOCutCalibration`'s instance has the
-- 0 at one specific corner, and the pair lemma took that corner as its
-- hypothesis.  For a set, which corner is 0 can differ per pair, so the
-- hypothesis is a `âŠ` and Â§2 does both cases.  That is the only thing
-- the generalisation costs.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module AFoolingSetForcesDistinctRectangles where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

open import AFoolingPairForcesTwoRectangles
  using (Rect ; Sound ; Covers ; foolingPairNotInOneRectangle)

------------------------------------------------------------------------
-- 1.  A fooling family
------------------------------------------------------------------------

module _ (Row Col : Type) (M : Row â†’ Col â†’ Bool) where

  Fooling : (I : Type) (r : I â†’ Row) (c : I â†’ Col) â†’ Type
  Fooling I r c =
    (i j : I) â†’ Â¬ (i â‰¡ j)
    â†’ (M (r i) (c j) â‰¡ false) âŠŽ (M (r j) (c i) â‰¡ false)

------------------------------------------------------------------------
-- 2.  Any sound cover is injective on a fooling family
------------------------------------------------------------------------

  foolingSetForcesDistinctRectangles :
    (I : Type) (r : I â†’ Row) (c : I â†’ Col)
    â†’ Fooling I r c
    â†’ (assign : I â†’ Rect Row Col M)
    â†’ ((i : I) â†’ Sound Row Col M (assign i))
    â†’ ((i : I) â†’ Covers Row Col M (assign i) (r i) (c i))
    â†’ (i j : I) â†’ Â¬ (i â‰¡ j) â†’ Â¬ (assign i â‰¡ assign j)
  foolingSetForcesDistinctRectangles I r c fool assign sound covers i j iâ‰¢j same
    with fool i j iâ‰¢j
  ... | inl zeroAtIJ =
    foolingPairNotInOneRectangle Row Col M (r i) (r j) (c i) (c j)
      zeroAtIJ (assign i) (sound i)
      ( covers i
      , subst (Î» R â†’ Covers Row Col M R (r j) (c j)) (sym same) (covers j) )
  ... | inr zeroAtJI =
    foolingPairNotInOneRectangle Row Col M (r j) (r i) (c j) (c i)
      zeroAtJI (assign i) (sound i)
      ( subst (Î» R â†’ Covers Row Col M R (r j) (c j)) (sym same) (covers j)
      , covers i )

------------------------------------------------------------------------
-- 3.  The reading
--
-- The pair lemma said one rectangle cannot hold two fooling cells.  Â§2
-- is that, quantified: a cover cannot reuse a rectangle across the
-- family at all.  The step from there to a numeric lower bound is
-- pigeonhole over a finite index, and it is deliberately outside this
-- module â” the corpus's standing rule is that a count is not a
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
-- Â§"WHAT IS PROVED, AND WHAT 'AS FAR AS IT GOES' MEANS" says:
-- "INJECTIVITY IS NOT 'â‰ k'.  Turning 'distinct cells get distinct
-- rectangles' into 'at least k rectangles' is a COUNTING step: it needs
-- `I` finite with k elements and a pigeonhole over the cover."
--
-- That step is now taken, in `NRectanglesCannotCoverSucNFoolingCells`,
-- using `Cubical.Data.Fin.Properties.pigeonhole-special` (which the
-- pinned library carries):
--
--   nRectanglesCannotCoverSucNFoolingCells :
--     (n : â•) (r : Fin (suc n) â’ Row) (c : Fin (suc n) â’ Col)
--     â’ Fooling (Fin (suc n)) r c
--     â’ (rects : Fin n â’ Rect) (pick : Fin (suc n) â’ Fin n)
--     â’ ((i) â’ Sound (rects (pick i)))
--     â’ ((i) â’ Covers (rects (pick i)) (r i) (c i))
--     â’ âŠ
--
-- IN THE CONTRAPOSITIVE, DELIBERATELY.  "At least k rectangles" is a
-- statement about a cardinal, and a cardinal needs the cover's index
-- counted.  The form above quantifies over the indexing instead:
-- whatever n-indexed family you offer, suc n fooling cells refute it.
-- That is the whole content of the numeric claim, stated without a
-- cardinality.
--
------------------------------------------------------------------------
