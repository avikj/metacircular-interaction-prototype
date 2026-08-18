-- Turn the wheel.
--
--     runghc -imachine machine/NalandaRun.hs 61
--     runghc -imachine machine/NalandaRun.hs --self-test
--     runghc -imachine machine/NalandaRun.hs 61 --chain 5
--
-- Prints the whole cycle, one line per turn, so the answer arrives with its
-- derivation attached and nothing has to be trusted.  `Nalanda` is not
-- `module Main` and is importable; this is the only Main.

module Main (main) where

import qualified Nalanda as N
import System.Environment (getArgs)
import System.Exit
import Text.Printf (printf)

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["--self-test"] -> do
      ok <- N.selfTest
      putStrLn (if ok then "NALANDA REACTOR CHECKED" else "NALANDA FAILED")
      if ok then exitSuccess else exitFailure
    (raw : rest) | [(d, "")] <- reads raw -> run d rest
    _ -> do
      putStrLn "usage: NalandaRun <D> [--chain N]   |   NalandaRun --self-test"
      exitFailure

run :: Integer -> [String] -> IO ()
run d rest = case N.cakravala d of
  Left err -> putStrLn ("  " ++ err) >> exitFailure
  Right trace -> do
    printf "cakravala on x^2 - %d y^2 = 1\n\n" d
    printf "  turn   %-22s %-20s k\n" "a" "b"
    mapM_ line (zip [0 :: Int ..] trace)
    let t = last trace
    printf "\n  fundamental solution:  a = %d\n" (N.tA t)
    printf "                         b = %d\n" (N.tB t)
    printf "  check  a^2 - %d b^2 = %d\n" d (N.tA t * N.tA t - d * N.tB t * N.tB t)
    case rest of
      ["--chain", n] | [(k, "")] <- reads n -> do
        printf "\n  bhavana, %d further solutions, composed not searched:\n" (k :: Int)
        mapM_ (\u -> printf "    (%d, %d)   norm %d\n"
                       (N.tA u) (N.tB u) (N.tK u))
              (take k (drop 1 (N.chain d t)))
      _ -> pure ()
  where
    line (i, t) = printf "  %-6d %-22s %-20s %d\n"
                    i (show (N.tA t)) (show (N.tB t)) (N.tK t)
