-- NalandaCertify — the whole loop, one handle.
--
--     runghc -imachine machine/NalandaCertify.hs 61
--     runghc -imachine machine/NalandaCertify.hs 2 3 5 6 7 8 10 11 12 13
--
-- Turn the wheel, emit the derivation as Agda, hand it to the kernel, and
-- report the kernel's verdict.  For each D:
--
--     cakravala  ->  CakravalaWitness-like module  ->  agda  ->  exit code
--
-- WHY THIS AND NOT A SHELL SCRIPT.  Because the point is that no human stands
-- in the middle.  `NalandaRun` prints a number a person reads; `NalandaEmit`
-- writes a file a person then checks.  Here the reactor produces a claim and
-- an external kernel adjudicates it, and the verdict comes back INTO the
-- machine.  That is the difference between a thing that computes and a thing
-- that knows whether it was right.
--
-- WHAT THE VERDICT MEANS, and its limits.  A green here says: the kernel
-- recomputed every arithmetic claim, and every turn's identity is an instance
-- of `CakravalaNat.cakravalaℕ` (proved for ALL naturals) or, for the finish,
-- of `BhavanaSemiring.bhavanaℕ`.  It does NOT say the cycle terminates for
-- every D — that is Lagrange's theorem and remains open here.  It says: for
-- this D, this run was right, and a kernel that never saw the generator
-- agrees.
--
-- SCRATCH MODULES ARE CLEANED UP.  Each D gets a temporary module under
-- formal/cubical (Agda resolves imports by directory, so it must live there),
-- checked, then deleted along with its interface file.  A failure leaves the
-- .agda in place deliberately, so the refused text can be read.

module Main (main) where

import qualified Nalanda as N
import qualified Certificate as C
import System.Environment (getArgs)
import System.Exit
import System.Process (readCreateProcessWithExitCode, shell, CreateProcess(..))
import System.Directory (removeFile, doesFileExist)
import Control.Monad (forM, when, unless)
import Text.Printf (printf)

cubicalDir :: FilePath
cubicalDir = "formal/cubical"

main :: IO ()
main = do
  args <- getArgs
  let ds = [ d | a <- args, [(d, "")] <- [reads a] ]
  if null ds
    then putStrLn "usage: NalandaCertify <D> [<D> ...]" >> exitFailure
    else do
      printf "  %-6s %-7s %-24s %s\n" "D" "turns" "fundamental a" "kernel"
      results <- forM ds certifyOne
      let ok = and results
      putStrLn ""
      printf "  %d of %d certified by the kernel\n"
        (length (filter id results)) (length results)
      if ok then putStrLn "NALANDA CERTIFIED" >> exitSuccess
            else putStrLn "NALANDA: at least one D was refused" >> exitFailure

certifyOne :: Integer -> IO Bool
certifyOne d = case N.cakravala d of
  Left err -> printf "  %-6s %s\n" (show d) ("reactor: " ++ err) >> pure False
  Right trace -> do
    let modName = "NalandaProbe" ++ show d
        path = cubicalDir ++ "/" ++ modName ++ ".agda"
        t = last trace
    -- Emit via the same generator the committed witness uses, then rename the
    -- module.  Using a DIFFERENT renderer here would mean certifying something
    -- other than what gets committed, which is the failure mode this whole
    -- pipeline exists to prevent.
    (ec, out, _) <- readCreateProcessWithExitCode
                      (shell ("LC_ALL=C.UTF-8 runghc -imachine machine/NalandaEmit.hs "
                              ++ show d)) ""
    if ec /= ExitSuccess
      then printf "  %-6s %s\n" (show d) "emitter refused" >> pure False
      else do
        writeFile path (rename modName out)
        (ec2raw, out2, err2raw) <- readCreateProcessWithExitCode
          (shell ("cd " ++ cubicalDir ++ " && LC_ALL=C.UTF-8 agda "
                  ++ modName ++ ".agda")) ""
        -- THE WATCH, ADDED 2026-08-20.  Until today `good` was `ec2 ==
        -- ExitSuccess` and nothing else: a number a process returned, read as
        -- a proof.  agda's stdout was discarded unexamined, so under a
        -- wrapper of the shape `agda "$@" 2>&1 | cat` this loop reported
        -- NALANDA CERTIFIED with the type error sitting in the text it threw
        -- away.  `vetForeignRun` is the same falsifier watch
        -- `Certificate.runAgda` carries, for a caller that launched agda
        -- itself.  See `machine/Yogyanupalabdhi_…hs`.
        (ec2, err2) <- C.vetForeignRun "." ec2raw (out2 ++ err2raw)
        let good = ec2 == ExitSuccess
        printf "  %-6s %-7s %-24s %s\n" (show d) (show (length trace - 1))
               (show (N.tA t)) (if good then "exit 0" else "REFUSED")
        unless good $ putStrLn ("      " ++ takeWhile (/= '\n') err2)
        -- clean up on success; keep the refused text on failure so it can be read
        when good $ do
          removeFile path
          let iface = cubicalDir ++ "/_build/2.6.3/agda/" ++ modName ++ ".agdai"
          e <- doesFileExist iface
          when e (removeFile iface)
        pure good
  where
    rename m = unlines . map (\l -> if l == "module CakravalaWitness where"
                                      then "module " ++ m ++ " where"
                                      else l) . lines
