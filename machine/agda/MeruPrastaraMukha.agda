-- ‡ ‡‡‡‡Æ‡ ‡  One machine, one law: which side of `f a ‚â° b` is bound is everything.
-- Output bound: singl (f a), contractible ‚î the datum rides free.  Input bound:
-- fiber f b ‚î the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect ‚î there is no third path (ahis).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhag, and the sources are the origin
-- (Umsvti, Samantabhadra, Akalaka ‚î restatements are named as such).  The
-- kernel decides truth; carriers ask and generate.  This file is one naya, true
-- and not whole.

{-# OPTIONS --guardedness #-}

------------------------------------------------------------------------
-- ‡Æ‡‡ñ ‚î the mouth: the ONLY unchecked part of the ‡Æ‡‡∞‡-‡‡‡∞‡‡‡‡æ‡∞ organ.
-- The whole computation is the --safe checked core (MeruPrastara); this
-- module is the ~half-dozen-line IO membrane that prints the report.
------------------------------------------------------------------------

module MeruPrastaraMukha where

open import Agda.Builtin.IO
open import Agda.Builtin.Unit
open import Agda.Builtin.String
open import MeruPrastara using (report)

postulate
  putStr' : String ‚Üí IO ‚ä§

{-# FOREIGN GHC import qualified Data.Text.IO as TIO #-}
{-# COMPILE GHC putStr' = TIO.putStr #-}

main : IO ‚ä§
main = putStr' report
