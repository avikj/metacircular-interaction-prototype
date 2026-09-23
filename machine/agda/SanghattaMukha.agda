-- à àààà®à à  One machine, one law: which side of `f a â‰¡ b` is bound is everything.
-- Output bound: singl (f a), contractible â” the datum rides free.  Input bound:
-- fiber f b â” the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect â” there is no third path (ahis).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhag, and the sources are the origin
-- (Umsvti, Samantabhadra, Akalaka â” restatements are named as such).  The
-- kernel decides truth; carriers ask and generate.  This file is one naya, true
-- and not whole.

{-# OPTIONS --guardedness #-}

------------------------------------------------------------------------
-- à®àà– â” the mouth: the ONLY unchecked part of the àà™àà˜àŸààŸ-à¯à¨àààà° organ.
-- The typed world-leaf.  The whole computation is the --safe checked core
-- (SanghattaMachine_â¦); this module is the ~dozen-line IO membrane that
-- reads the file and prints the report.  It is NOT --safe, because
-- reading the world and printing to it cannot be a checked term â” and
-- that boundary is exactly where code stops and the world begins.
------------------------------------------------------------------------

module SanghattaMukha where

open import Agda.Builtin.IO
open import Agda.Builtin.Unit
open import Agda.Builtin.String
open import SanghattaMachine_TheCriticalPairOrganAsCheckedTermsCompiledByTheKernelsOwnBackend
  using (report)

postulate
  readFileT : String â†’ IO String
  putStr'   : String â†’ IO âŠ¤
  _>>=IO_   : {A B : Set} â†’ IO A â†’ (A â†’ IO B) â†’ IO B

{-# FOREIGN GHC import qualified Data.Text as T #-}
{-# FOREIGN GHC import qualified Data.Text.IO as TIO #-}
{-# COMPILE GHC readFileT = \ p -> TIO.readFile (T.unpack p) #-}
{-# COMPILE GHC putStr'   = TIO.putStr #-}
{-# COMPILE GHC _>>=IO_   = \ _ _ -> (Prelude.>>=) #-}

main : IO âŠ¤
main = readFileT "machine/library.terms" >>=IO Î» contents â†’
       putStr' (report contents)
