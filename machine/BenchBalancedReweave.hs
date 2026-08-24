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
import qualified MAlonzo.Code.BalancedReweave as B
import qualified MAlonzo.Code.Agda.Builtin.Bool as AB

timed :: String -> (Integer -> Integer) -> Integer -> IO ()
timed label f n = do
  t0 <- getCPUTime
  answer <- evaluate (f n)
  t1 <- getCPUTime
  if answer /= n then fail (label ++ " changed the result") else pure ()
  printf "%s n=%d cpu_ms=%.3f\n" label n
    (fromIntegral (t1 - t0) / (10 ^ (9 :: Int)) :: Double)

timedBool :: String -> (Integer -> AB.T_Bool_6) -> Integer -> IO AB.T_Bool_6
timedBool label f n = do
  t0 <- getCPUTime
  answer <- evaluate (f n)
  t1 <- getCPUTime
  printf "%s n=%d cpu_ms=%.3f\n" label n
    (fromIntegral (t1 - t0) / (10 ^ (9 :: Int)) :: Double)
  pure answer

timedMixed :: String -> (Integer -> Integer -> Integer -> AB.T_Bool_6)
  -> (Integer, Integer, Integer) -> IO AB.T_Bool_6
timedMixed label f (epochs, writes, reads) = do
  t0 <- getCPUTime
  answer <- evaluate (f epochs writes reads)
  t1 <- getCPUTime
  printf "%s epochs=%d writes/epoch=%d reads/epoch=%d cpu_ms=%.3f\n"
    label epochs writes reads
    (fromIntegral (t1 - t0) / (10 ^ (9 :: Int)) :: Double)
  pure answer

main :: IO ()
main = do
  args <- getArgs
  let sizes = case args of
        [] -> [1000, 10000, 100000]
        _ -> map read args
  mapM_ (\n -> do
    timed "linear" B.d_linearPlanCount_268 n
    timed "balanced" B.d_balancedCount_264 n
    chain <- timedBool "balanced-flip" B.d_balancedFlipCount_498 n
    fused <- timedBool "fused-flip" B.d_fusedFlipCount_490 n
    case (chain, fused) of
      (AB.C_false_8, AB.C_false_8) -> pure ()
      (AB.C_true_10, AB.C_true_10) -> pure ()
      _ -> fail "checked-equivalent flip implementations disagreed") sizes
  let regimes =
        [(100, 100, 1), (100, 100, 4), (20, 1000, 100), (10, 1000, 2000)]
  mapM_ (\regime -> do
    lazy <- timedMixed "mixed-lazy" B.d_lazyMixed_966 regime
    adaptive <- timedMixed "mixed-adaptive" B.d_adaptiveMixed_912 regime
    fused <- timedMixed "mixed-fused" B.d_fusedMixed_1020 regime
    case (lazy, adaptive, fused) of
      (AB.C_false_8, AB.C_false_8, AB.C_false_8) -> pure ()
      (AB.C_true_10, AB.C_true_10, AB.C_true_10) -> pure ()
      _ -> fail "mixed strategies disagreed") regimes
