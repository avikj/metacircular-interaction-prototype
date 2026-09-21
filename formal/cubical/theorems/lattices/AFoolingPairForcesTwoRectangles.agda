{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AFoolingPairForcesTwoRectangles
--
-- `formal/cubical/DSOCutCalibration.agda` establishes, for one concrete
-- 4—2 Boolean cut matrix, that r_e = 2 < d_e = 3 < 4 = raw, and it
-- obtains the lower bound r_e â‰ 2 by an argument its header states
-- explicitly and calls out as an argument rather than an enumeration:
--
--   "NO single sound rectangle covers both diagonal 1-entries (fooling
--    pair râ,râ), so r_e â‰ 2 â” proved, not enumerated: a rectangle
--    through (râ,câ) and (râ,câ) must contain (râ,câ), where the matrix
--    is 0."
--
-- That argument uses nothing about the matrix, its size, or its
-- carriers.  Â§2 is it, for arbitrary row and column types.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT I READ FIRST
--
-- `DSOCutCalibration.agda`'s header and the shape of its statements:
-- the min-plus closure over `V4`, the two elimination orders, and the
-- four rows (1,0),(0,1),(1,1),(1,1) with raw = 4 and deterministic = 3
-- certified by kernel count.  I did not re-derive any of that and Â§2
-- does not depend on it.
--
-- KEPT SEPARATE from the last-cut result.  That one showed a
-- computed instance was also a quantified fact about any import
-- relation.  This one lifts an ARGUMENT, not a fact: the calibration
-- already gives the argument in prose and calls it a proof; Â§2 makes it
-- a term and removes the carriers.  Different move, and neither derives
-- the other.
------------------------------------------------------------------------

module AFoolingPairForcesTwoRectangles where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- 1.  Boolean matrices, rectangles, and soundness
------------------------------------------------------------------------

module _ (Row Col : Type) (M : Row â†’ Col â†’ Bool) where

  -- a combinatorial rectangle: a set of rows and a set of columns
  Rect : Typeâ‚
  Rect = (Row â†’ Type) Ã— (Col â†’ Type)

  -- sound: every cell of the rectangle is a 1-entry of the matrix
  Sound : Rect â†’ Type
  Sound (R , C) = (r : Row) (c : Col) â†’ R r â†’ C c â†’ M r c â‰¡ true

  Covers : Rect â†’ Row â†’ Col â†’ Type
  Covers (R , C) r c = R r Ã— C c

  --------------------------------------------------------------------
  -- 2.  A fooling pair cannot lie in one sound rectangle
  --
  -- The whole argument: a rectangle containing (râ,câ) and (râ,câ)
  -- contains (râ,câ) â” rectangles are closed under exchanging the row
  -- and column of two of their cells â” and there the matrix is 0.
  --------------------------------------------------------------------

  foolingPairNotInOneRectangle :
    (râ‚ râ‚‚ : Row) (câ‚ câ‚‚ : Col)
    â†’ M râ‚ câ‚‚ â‰¡ false
    â†’ (rect : Rect) â†’ Sound rect
    â†’ Â¬ (Covers rect râ‚ câ‚ Ã— Covers rect râ‚‚ câ‚‚)
  foolingPairNotInOneRectangle râ‚ râ‚‚ câ‚ câ‚‚ zeroAtCorner (R , C) sound
    ((Rrâ‚ , _) , (_ , Ccâ‚‚)) =
      trueâ‰¢false (sym (sound râ‚ câ‚‚ Rrâ‚ Ccâ‚‚) âˆ™ zeroAtCorner)

  -- the same statement in the form the calibration uses it: the two
  -- 1-entries are witnesses, and they are what makes the pair fooling
  foolingPairFromTwoOnesAndAZero :
    (râ‚ râ‚‚ : Row) (câ‚ câ‚‚ : Col)
    â†’ M râ‚ câ‚ â‰¡ true â†’ M râ‚‚ câ‚‚ â‰¡ true â†’ M râ‚ câ‚‚ â‰¡ false
    â†’ (rect : Rect) â†’ Sound rect
    â†’ Â¬ (Covers rect râ‚ câ‚ Ã— Covers rect râ‚‚ câ‚‚)
  foolingPairFromTwoOnesAndAZero râ‚ râ‚‚ câ‚ câ‚‚ _ _ zeroAtCorner =
    foolingPairNotInOneRectangle râ‚ râ‚‚ câ‚ câ‚‚ zeroAtCorner

------------------------------------------------------------------------
-- 3.  The reading
--
-- The calibration's lower bound is carrier-free.  What its instance
-- supplies is the three cells â” two 1-entries and one 0 at the exchanged
-- corner â” and Â§2 shows those three are the entire hypothesis: no
-- appeal to the matrix's size, to its other entries, or to how the cut
-- arose.
--
-- Note which of the two 1-entries Â§2 actually uses: NEITHER.  The proof
-- needs only `R râ`, `C câ` and the 0 at (râ,câ); the two 1-entries are
-- what make the pair worth choosing, not what makes the argument run.
-- `foolingPairFromTwoOnesAndAZero` keeps them in the statement because
-- that is how the method is used, and discards them in the proof, which
-- is where the sharper statement shows.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- The generalisation to a fooling SET is in
-- `AFoolingSetForcesDistinctRectangles`:
--
--   Fooling I r c = (i j) â’ Â (i â‰¡ j)
--     â’ (M (r i) (c j) â‰¡ false) âŠ (M (r j) (c i) â‰¡ false)
--
--   foolingSetForcesDistinctRectangles :
--     Fooling I r c â’ (assign : I â’ Rect) â’ ((i) â’ Sound (assign i))
--     â’ ((i) â’ Covers (assign i) (r i) (c i))
--     â’ (i j) â’ Â (i â‰¡ j) â’ Â (assign i â‰¡ assign j)
--
-- The generalisation costs exactly one thing: for a SET, which exchanged
-- corner carries the 0 may differ per pair, so the hypothesis is a `âŠ`
-- and both cases are done.
------------------------------------------------------------------------
