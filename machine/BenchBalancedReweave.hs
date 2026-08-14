module Main (main) where

import Control.Exception (evaluate)
import System.CPUTime (getCPUTime)
import System.Environment (getArgs)
import Text.Printf (printf)
import qualified MAlonzo.Code.BalancedReweave as B

timed :: String -> (Integer -> Integer) -> Integer -> IO ()
timed label f n = do
  t0 <- getCPUTime
  answer <- evaluate (f n)
  t1 <- getCPUTime
  if answer /= n then fail (label ++ " changed the result") else pure ()
  printf "%s n=%d cpu_ms=%.3f\n" label n
    (fromIntegral (t1 - t0) / (10 ^ (9 :: Int)) :: Double)

main :: IO ()
main = do
  args <- getArgs
  let sizes = case args of
        [] -> [1000, 10000, 100000]
        _ -> map read args
  mapM_ (\n -> do
    timed "linear" B.d_linearPlanCount_268 n
    timed "balanced" B.d_balancedCount_264 n) sizes
