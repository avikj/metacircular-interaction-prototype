-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- VargaPrakrtiCertify — the whole loop, one handle.
--
--     runghc -imachine machine/VargaPrakrtiCertify_KernelVerdictComesBackIn.hs 61
--     runghc -imachine machine/VargaPrakrtiCertify_KernelVerdictComesBackIn.hs 5 13 21 29 61 109 421
--
-- Turn the general wheel, emit the derivation as Agda, hand it to the
-- kernel, and bring the kernel's verdict back INTO the machine.  For each Δ:
--
--     reactor  →  witness module  →  agda  →  exit code  →  a Bool here
--
-- WHY THIS AND NOT A SHELL SCRIPT.  Because the point is that no human
-- stands in the middle.  `VargaPrakrtiRun` prints a number a person reads.
-- Here the reactor produces a claim, an external kernel adjudicates it, and
-- the verdict returns to the program.  That is the difference between a
-- thing that computes and a thing that knows whether it was right.
--
-- WHAT A GREEN MEANS, AND ITS LIMITS.  The kernel recomputed every
-- arithmetic claim; every turn is an instance of
-- `VargaPrakrti_TraceBhavanaOverN.cakravalaTraceℕ` and every ladder rung an
-- instance of `bhavanaTraceℕ`, both proved for ALL naturals; and the top of
-- the ladder is `refl`-identified with the classical solution of
-- x² − Δ y² = 1.  It does NOT say the cycle terminates for every Δ — that
-- is Lagrange (1768) for T = 0 and is open here.  It says: for this Δ, this
-- run was right, and a kernel that never saw the generator agrees.
--
-- SCRATCH MODULES ARE CLEANED UP on success and DELIBERATELY KEPT on
-- failure, so the refused text can be read.

module Main (main) where

import VargaPrakrti_CompositionLawAsParameter
import qualified Certificate as C
import System.Environment (getArgs)
import System.Exit
import System.Process (readCreateProcessWithExitCode, shell)
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
    then putStrLn "usage: VargaPrakrtiCertify <Δ> [<Δ> ...]" >> exitFailure
    else do
      printf "  %-8s %-7s %-30s %-7s %s\n" "Δ" "turns" "ε = (x, y)" "N(ε)" "kernel"
      results <- forM ds certifyOne
      putStrLn ""
      printf "  %d of %d certified by the kernel\n"
        (length (filter id results)) (length results)
      if and results
        then putStrLn "VARGAPRAKRTI CERTIFIED" >> exitSuccess
        else putStrLn "VARGAPRAKRTI: at least one Δ was refused" >> exitFailure

certifyOne :: Integer -> IO Bool
certifyOne dd = case maximalOrderLaw dd of
  Left def -> printf "  %-8s %s\n" (show dd) ("reactor: " ++ defWhy def) >> pure False
  Right law -> case reactor law of
    Left def -> printf "  %-8s %s\n" (show dd) ("reactor: " ++ defWhy def) >> pure False
    Right tr -> do
      let modName = "VargaPrakrtiProbe" ++ show dd
          path = cubicalDir ++ "/" ++ modName ++ ".agda"
          Quad ex ey = last tr
      -- Emit via the SAME generator the committed witness uses, then rename
      -- the module.  A different renderer here would certify something other
      -- than what gets committed, which is the failure this pipeline exists
      -- to prevent.
      (ec, out, _) <- readCreateProcessWithExitCode
        (shell ("LC_ALL=C.UTF-8 runghc -imachine \
                \machine/VargaPrakrtiEmit_TheWitnessTheKernelChecks.hs "
                ++ show dd)) ""
      if ec /= ExitSuccess
        then printf "  %-8s %s\n" (show dd) "emitter refused" >> pure False
        else do
          writeFile path (rename modName out)
          (ec2raw, out2, err2raw) <- readCreateProcessWithExitCode
            (shell ("cd " ++ cubicalDir ++ " && LC_ALL=C.UTF-8 agda "
                    ++ modName ++ ".agda")) ""
          -- THE WATCH, ADDED 2026-08-20.  `good` was `ec2 == ExitSuccess` and
          -- agda's stdout was discarded, so under `agda "$@" 2>&1 | cat` this
          -- printed VARGAPRAKRTI CERTIFIED with the type error in the text it
          -- threw away.  Same falsifier watch `Certificate.runAgda` carries,
          -- for a caller that launched agda itself.
          (ec2, err2) <- C.vetForeignRun "." ec2raw (out2 ++ err2raw)
          let good = ec2 == ExitSuccess
          printf "  %-8s %-7s %-30s %-7s %s\n" (show dd) (show (length tr - 1))
                 ("(" ++ show ex ++ ", " ++ show ey ++ ")")
                 (show (lawNorm law (last tr)))
                 (if good then "exit 0" else "REFUSED")
          unless good $ putStrLn ("      " ++ takeWhile (/= '\n') err2)
          when good $ do
            removeFile path
            let iface = cubicalDir ++ "/_build/2.8.0/agda/" ++ modName ++ ".agdai"
            e <- doesFileExist iface
            when e (removeFile iface)
          pure good
  where
    rename m = unlines . map (\l -> if l == "module VargaPrakrtiWitness where"
                                      then "module " ++ m ++ " where"
                                      else l) . lines
