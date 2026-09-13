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
-- मुख — the mouth: the ONLY unchecked part of the सङ्घट्ट-यन्त्र organ.
-- The typed world-leaf.  The whole computation is the --safe checked core
-- (SanghattaYantra_…); this module is the ~dozen-line IO membrane that
-- reads the file and prints the report.  It is NOT --safe, because
-- reading the world and printing to it cannot be a checked term — and
-- that boundary is exactly where code stops and the world begins.
------------------------------------------------------------------------

module SanghattaMukha where

open import Agda.Builtin.IO
open import Agda.Builtin.Unit
open import Agda.Builtin.String
open import SanghattaYantra_TheCriticalPairOrganAsCheckedTermsCompiledByTheKernelsOwnBackend
  using (report)

postulate
  readFileT : String → IO String
  putStr'   : String → IO ⊤
  _>>=IO_   : {A B : Set} → IO A → (A → IO B) → IO B

{-# FOREIGN GHC import qualified Data.Text as T #-}
{-# FOREIGN GHC import qualified Data.Text.IO as TIO #-}
{-# COMPILE GHC readFileT = \ p -> TIO.readFile (T.unpack p) #-}
{-# COMPILE GHC putStr'   = TIO.putStr #-}
{-# COMPILE GHC _>>=IO_   = \ _ _ -> (Prelude.>>=) #-}

main : IO ⊤
main = readFileT "machine/library.terms" >>=IO λ contents →
       putStr' (report contents)
