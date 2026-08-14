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
