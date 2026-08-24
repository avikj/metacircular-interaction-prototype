-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

module Main (main) where

import Control.Exception (evaluate)
import System.CPUTime (getCPUTime)
import System.Environment (getArgs)
import Text.Printf (printf)
import qualified MAlonzo.Code.Agda.Builtin.Bool as AB
import qualified MAlonzo.Code.TheoremCompiledObservation as T

timed :: String -> IO AB.T_Bool_6 -> IO AB.T_Bool_6
timed label action = do
  t0 <- getCPUTime
  answer <- action >>= evaluate
  t1 <- getCPUTime
  printf "%s cpu_ms=%.6f\n" label
    (fromIntegral (t1 - t0) / (10 ^ (9 :: Int)) :: Double)
  pure answer

same :: AB.T_Bool_6 -> AB.T_Bool_6 -> Bool
same AB.C_false_8 AB.C_false_8 = True
same AB.C_true_10 AB.C_true_10 = True
same _ _ = False

main :: IO ()
main = do
  args <- getArgs
  let sizes = if null args then [10000, 100000, 500000] else map read args
  mapM_ (\n -> do
    direct <- timed ("direct n=" ++ show n) (pure (T.d_directEvenValue_312 n))
    compiled <- timed ("compiled n=" ++ show n) (pure T.d_compiledEvenValue_316)
    if same direct compiled then pure () else fail "compiled quotient changed parity") sizes
