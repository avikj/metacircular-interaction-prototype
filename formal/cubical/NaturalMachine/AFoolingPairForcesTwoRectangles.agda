{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.AFoolingPairForcesTwoRectangles
--
-- `formal/cubical/DSOCutCalibration.agda` establishes, for one concrete
-- 4×2 Boolean cut matrix, that r_e = 2 < d_e = 3 < 4 = raw, and it
-- obtains the lower bound r_e ≥ 2 by an argument its header states
-- explicitly and calls out as an argument rather than an enumeration:
--
--   "NO single sound rectangle covers both diagonal 1-entries (fooling
--    pair r₁,r₂), so r_e ≥ 2 — proved, not enumerated: a rectangle
--    through (r₁,c₁) and (r₂,c₂) must contain (r₁,c₂), where the matrix
--    is 0."
--
-- That argument uses nothing about the matrix, its size, or its
-- carriers.  §2 is it, for arbitrary row and column types.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT I READ FIRST
--
-- `DSOCutCalibration.agda`'s header and the shape of its statements:
-- the min-plus closure over `V4`, the two elimination orders, and the
-- four rows (1,0),(0,1),(1,1),(1,1) with raw = 4 and deterministic = 3
-- certified by kernel count.  I did not re-derive any of that and §2
-- does not depend on it.
--
-- WHAT IS NOT CLAIMED.  NOT that r_e = 2 for that matrix — the matching
-- UPPER bound there is an exhibited 2-rectangle cover, certified
-- entrywise, and nothing here constructs or verifies a cover.  NOT
-- anything about d_e, raw width, the min-plus closure, the elimination
-- orders, or Delta 28 §18/§24.  NOT a general lower bound: §2 gives
-- "at least two" from a fooling PAIR; a fooling set of size k giving
-- k rectangles needs a distinctness argument over the whole set and is
-- not done here.
--
-- KEPT SEPARATE from this session's last-cut result.  That one showed a
-- computed instance was also a quantified fact about any import
-- relation.  This one lifts an ARGUMENT, not a fact: the calibration
-- already gives the argument in prose and calls it a proof; §2 makes it
-- a term and removes the carriers.  Different move, and neither derives
-- the other.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.AFoolingPairForcesTwoRectangles where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1.  Boolean matrices, rectangles, and soundness
------------------------------------------------------------------------

module _ (Row Col : Type) (M : Row → Col → Bool) where

  -- a combinatorial rectangle: a set of rows and a set of columns
  Rect : Type₁
  Rect = (Row → Type) × (Col → Type)

  -- sound: every cell of the rectangle is a 1-entry of the matrix
  Sound : Rect → Type
  Sound (R , C) = (r : Row) (c : Col) → R r → C c → M r c ≡ true

  Covers : Rect → Row → Col → Type
  Covers (R , C) r c = R r × C c

  --------------------------------------------------------------------
  -- 2.  A fooling pair cannot lie in one sound rectangle
  --
  -- The whole argument: a rectangle containing (r₁,c₁) and (r₂,c₂)
  -- contains (r₁,c₂) — rectangles are closed under exchanging the row
  -- and column of two of their cells — and there the matrix is 0.
  --------------------------------------------------------------------

  foolingPairNotInOneRectangle :
    (r₁ r₂ : Row) (c₁ c₂ : Col)
    → M r₁ c₂ ≡ false
    → (rect : Rect) → Sound rect
    → ¬ (Covers rect r₁ c₁ × Covers rect r₂ c₂)
  foolingPairNotInOneRectangle r₁ r₂ c₁ c₂ zeroAtCorner (R , C) sound
    ((Rr₁ , _) , (_ , Cc₂)) =
      true≢false (sym (sound r₁ c₂ Rr₁ Cc₂) ∙ zeroAtCorner)

  -- the same statement in the form the calibration uses it: the two
  -- 1-entries are witnesses, and they are what makes the pair fooling
  foolingPairFromTwoOnesAndAZero :
    (r₁ r₂ : Row) (c₁ c₂ : Col)
    → M r₁ c₁ ≡ true → M r₂ c₂ ≡ true → M r₁ c₂ ≡ false
    → (rect : Rect) → Sound rect
    → ¬ (Covers rect r₁ c₁ × Covers rect r₂ c₂)
  foolingPairFromTwoOnesAndAZero r₁ r₂ c₁ c₂ _ _ zeroAtCorner =
    foolingPairNotInOneRectangle r₁ r₂ c₁ c₂ zeroAtCorner

------------------------------------------------------------------------
-- 3.  The reading
--
-- The calibration's lower bound is carrier-free.  What its instance
-- supplies is the three cells — two 1-entries and one 0 at the exchanged
-- corner — and §2 shows those three are the entire hypothesis: no
-- appeal to the matrix's size, to its other entries, or to how the cut
-- arose.
--
-- Note which of the two 1-entries §2 actually uses: NEITHER.  The proof
-- needs only `R r₁`, `C c₂` and the 0 at (r₁,c₂); the two 1-entries are
-- what make the pair worth choosing, not what makes the argument run.
-- `foolingPairFromTwoOnesAndAZero` keeps them in the statement because
-- that is how the method is used, and discards them in the proof, which
-- is where the sharper statement shows.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by this module's author, at the end, altering no
-- line above.
--
-- §"WHAT IS NOT CLAIMED" says: "Nor a general lower bound: §2 gives
-- 'at least two' from a fooling PAIR; a fooling set of size k giving
-- k rectangles needs a distinctness argument over the whole set and is
-- not done here."
--
-- That is now done, in `NaturalMachine.AFoolingSetForcesDistinctRectangles`:
--
--   Fooling I r c = (i j) → ¬ (i ≡ j)
--     → (M (r i) (c j) ≡ false) ⊎ (M (r j) (c i) ≡ false)
--
--   foolingSetForcesDistinctRectangles :
--     Fooling I r c → (assign : I → Rect) → ((i) → Sound (assign i))
--     → ((i) → Covers (assign i) (r i) (c i))
--     → (i j) → ¬ (i ≡ j) → ¬ (assign i ≡ assign j)
--
-- The generalisation costs exactly one thing: for a SET, which exchanged
-- corner carries the 0 may differ per pair, so the hypothesis is a `⊎`
-- and both cases are done.
--
-- STILL NOT PROVED, and still not claimed: the numeric form.  Turning
-- "distinct cells get distinct rectangles" into "at least k rectangles"
-- is a pigeonhole over a finite index; neither finiteness nor counting
-- appears in that module.  Injectivity is what is proved.
------------------------------------------------------------------------
