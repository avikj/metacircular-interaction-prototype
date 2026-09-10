-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate.  This file is one naya, true
-- and not whole.

{-# OPTIONS --guardedness #-}

------------------------------------------------------------------------
-- मुख — the mouth: the ONLY unchecked part of the मेरु-प्रस्तार organ.
-- The whole computation is the --safe checked core (MeruPrastara); this
-- module is the ~half-dozen-line IO membrane that prints the report.
------------------------------------------------------------------------

module MeruPrastaraMukha where

open import Agda.Builtin.IO
open import Agda.Builtin.Unit
open import Agda.Builtin.String
open import MeruPrastara using (report)

postulate
  putStr' : String → IO ⊤

{-# FOREIGN GHC import qualified Data.Text.IO as TIO #-}
{-# COMPILE GHC putStr' = TIO.putStr #-}

main : IO ⊤
main = putStr' report
