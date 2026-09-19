{-# OPTIONS --cubical --safe #-}

-- àààà®à¾à°àà—-ààà¦ â” the many paths are distinct: Wolfram's MULTIWAY
-- systems keep branching histories and refuse to collapse them.  Put to
-- the kernel: two computational branches with different winding are
-- PROVABLY unequal â” the multiway does not collapse, as a theorem.
--
-- This is the checked witness of Wolfram's core multicomputational
-- principle (a branch is not identified with another branch, ever) â” and
-- it is exactly why the corpus's proof-relevant e-graph KEEPS distinct
-- paths (CRYSTAL.md L2: "distinct automorphisms survive as distinct
-- paths").  In a set (an h-set) all paths collapse; the circle is NOT a
-- set, and winding is the invariant that tells the branches apart.

module BahumargaBheda_TheMultiwayDoesNotCollapseDistinctBranchesAreProvablyDistinct where

open import Cubical.Foundations.Prelude
open import Cubical.HITs.S1.Base using (base ; loop ; Î©SÂ¹ ; winding)
open import Cubical.Data.Int using (â„¤ ; pos ; injPos)
open import Cubical.Data.Nat using (znots)
open import Cubical.Relation.Nullary using (Â¬_)

-- once-around and the trivial branch carry different windings,
-- so they are NOT the same path: the multiway keeps them apart.
loopâ‰¢refl : Â¬ (loop â‰¡ refl)
loopâ‰¢refl p = znots (injPos (cong winding (sym p)))
  -- cong winding p : winding loop â‰¡ winding refl, i.e. pos 1 â‰¡ pos 0;
  -- injPos : 1 â‰¡ 0 in â•; znots : Â (0 â‰¡ suc _).  (sym to match znots.)

-- more strongly: two branches wind differently â’ they are distinct.
-- distinct winding is a SUFFICIENT witness of branch-distinctness, which
-- is the whole content of "the multiway does not collapse."
different-windingâ†’different-branch :
  (a b : Î©SÂ¹) â†’ Â¬ (winding a â‰¡ winding b) â†’ Â¬ (a â‰¡ b)
different-windingâ†’different-branch a b waâ‰¢wb aâ‰¡b =
  waâ‰¢wb (cong winding aâ‰¡b)
