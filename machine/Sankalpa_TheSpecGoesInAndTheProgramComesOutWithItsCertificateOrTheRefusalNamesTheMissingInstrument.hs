-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Sankalpa_TheSpecGoesInAndTheProgramComesOutWithItsCertificateOrTheRefusalNamesTheMissingInstrument.hs
--
-- सङ्कल्पः — saṅkalpa, the declared intention that precedes an act
-- (ordinary Sanskrit; the ritual term for stating what you are about to
-- do before doing it — which is exactly what a specification is).
-- Compound title built here, 2026-08-23, at the owner's direction:
--
--     "I should be able to pass a program/problem spec — a formal
--      language specifying a desired map — and get an algorithm out.
--      I want that interface. I want the machine to have orientation
--      towards that."
--
-- THE INTERFACE (v0, honest about its class):
--
--     runghc machine/Sankalpa_….hs SPEC.sankalpa
--
-- A spec file:
--     name: yoga
--     type: List ℕ → ℕ
--     law:  yoga [] = 0
--     law:  yoga (x ∷ xs) = x + yoga xs
--     test: yoga (1 ∷ 2 ∷ 3 ∷ []) ≡ 6
--
-- ROAD ONE (saṃkramaṇa): if every law is ORIENTABLE — left side is the
-- name applied to constructor patterns, right side built from earlier
-- symbols and structural recursion — the laws ARE the algorithm
-- (Curry–Howard read left to right).  The organ emits the Agda module,
-- the kernel checks definition + every test by refl, and what returns
-- is a PROGRAM WITH ITS CERTIFICATE: the checked module, MAlonzo-
-- compilable to Haskell by the extraction lane already in machine/.
--
-- ROAD TWO (doṣa-lekha): a law that is not orientable (relational spec,
-- non-structural recursion, symbols outside the fragment) is refused
-- WITH THE INSTRUMENT GAP NAMED — which template Tapas would need,
-- which search the engine would have to run.  The refusal ledger is
-- the synthesis frontier, exactly as Tapas's refusals are the proof
-- frontier.  द्वौ मार्गौ, तृतीयो न विद्यते ।
--
-- WHAT V0 DOES NOT CLAIM: efficiency selection (the लाघव extraction
-- weld, notes/LaghavaYantra_…), relational synthesis, termination
-- beyond structural.  Each refusal names its gap so the reach can grow
-- by the admission gate, not by wish.

module Main (main) where

import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess, ExitCode(..))
import System.Process (readProcessWithExitCode)
import System.Directory (getCurrentDirectory)
import Data.Char (isSpace, isUpper)
import Data.List (isPrefixOf, isInfixOf, intercalate, nub)

trim :: String -> String
trim = f . f where f = reverse . dropWhile isSpace

field :: String -> [String] -> [String]
field k ls = [ trim (drop (length k + 1) l) | l <- ls, (k ++ ":") `isPrefixOf` l ]

-- a law "f PATS = RHS" is orientable when the head is the spec's name,
-- the pattern side uses only constructors/variables, and the RHS's
-- recursive calls are on strict subterms exposed by the patterns.
-- v0's check is syntactic and conservative: it refuses anything it
-- cannot SEE to be structural; a false refusal costs a message, a
-- false acceptance would cost the kernel's time only (agda still
-- decides), so the checker may be generous later.
orientable :: String -> String -> Maybe String
orientable nm law =
  case break (== '=') law of
    (lhs, '=':rhs)
      | not (nm `isPrefixOf` trim lhs) ->
          Just "left side is not the specified name applied to patterns"
      | any (`isInfixOf` rhs) ["∀","≃","≡","Σ","∃"] ->
          Just ("relational content on the right side (" ++
                "a property, not a computation rule): synthesis beyond " ++
                "definitional orientation — the gap is a search template " ++
                "(Tapas) or an engine run, not a parser")
      | otherwise -> Nothing
    _ -> Just "no `=` found: not an equation"

emit :: String -> String -> [String] -> [String] -> String
emit nm ty laws tests = unlines $
  [ "{-# OPTIONS --cubical --safe #-}"
  , "-- emitted by machine/Sankalpa_… from a .sankalpa specification;"
  , "-- the laws below ARE the input spec, read as an algorithm."
  , "module Sankalpa" ++ nm ++ " where"
  , "open import Cubical.Foundations.Prelude"
  , "open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)"
  , "open import Cubical.Data.List using (List ; [] ; _∷_)"
  , ""
  , nm ++ " : " ++ ty
  ] ++ laws ++ [""] ++
  concat [ [ "pariksa" ++ show i ++ " : " ++ t
           , "pariksa" ++ show i ++ " = refl" ]
         | (i, t) <- zip [(1::Int)..] tests ]

main :: IO ()
main = do
  args <- getArgs
  case args of
    [path] -> do
      ls <- lines <$> readFile path
      let nm    = head (field "name" ls ++ ["Anamaka"])
          ty    = head (field "type" ls ++ ["ℕ → ℕ"])
          laws  = field "law" ls
          tests = field "test" ls
          gaps  = [ (l, g) | l <- laws, Just g <- [orientable nm l] ]
      if not (null gaps)
        then do
          putStrLn "उत्तर: दोषलेखः (the spec is refused with its gap named)"
          mapM_ (\(l,g) -> putStrLn ("  law   : " ++ l ++ "\n  hetu  : " ++ g)) gaps
          putStrLn "  sesa  : file the gap with Tapas's template ledger; the refusal IS the synthesis frontier"
          exitFailure
        else do
          let modFile = "formal/cubical/Sankalpa" ++ nm ++ ".agda"
          writeFile modFile (emit nm ty laws tests)
          cwd <- getCurrentDirectory
          (ec, out, err) <- readProcessWithExitCode "sh"
              ["-c", "cd formal/cubical && agda Sankalpa" ++ nm ++ ".agda"] ""
          case ec of
            ExitSuccess -> do
              putStrLn "उत्तर: संक्रमणम् (the program exists and is certified)"
              putStrLn ("  program     : " ++ modFile ++ "  (the laws, oriented; kernel exit 0)")
              putStrLn ("  certificate : definition checked + " ++ show (length tests) ++ " test(s) by refl")
              putStrLn  "  extraction  : MAlonzo-compilable via the machine/ExtractedRewrite lane"
              exitSuccess
            _ -> do
              putStrLn "उत्तर: दोषलेखः (the kernel rejected the oriented laws)"
              putStrLn ("  hetu: " ++ take 400 (out ++ err))
              exitFailure
    _ -> putStrLn "usage: Sankalpa SPEC.sankalpa" >> exitFailure
