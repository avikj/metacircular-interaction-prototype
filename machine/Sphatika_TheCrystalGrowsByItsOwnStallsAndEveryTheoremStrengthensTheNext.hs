-- स्फटिक (sphaṭika), crystal — ordinary Sanskrit; the compound title is
-- built here (2026-08-24) and claimed of no source.
--
-- THE DRIVER THE SEAM NEVER GOT.
--
-- Three organs were built for one loop and the loop was never closed:
--
--   * KernelContext renders an ordered lemma list where EACH LEMMA MAY
--     CITE ANY EARLIER ONE (`PCite` — "the constructor the whole file
--     exists for") and asks the kernel about the whole;
--   * Obstruction reads the kernel's stall text back into terms — the
--     residual is the machine stating, in its own words, the lemma it
--     needs next — and carries the triage that keeps false parents from
--     livelocking the feedback (its header: "the seam that was supposed
--     to consume them was never connected");
--   * the endogenous frontier (Sanghatta's non-joining pairs) names the
--     equations the rewriter cannot close by rewriting alone.
--
-- This file is ONLY the loop: no new Term type (the eighth respelling is
-- a defect, not a contribution — KernelContext.hs:196 names the count),
-- no new store beyond the crystal itself, no heuristic, no measured
-- constant.
--
--   take a goal → ask the kernel IN THE CRYSTAL'S CONTEXT
--     landed  → the lemma is appended and is in scope for every later
--               proof: memory compounds instead of scattering
--     refused → the residual of the refl attempt, triaged
--               (Obstruction.pravesha — a refuted or subjectless
--               residual turns back), becomes the NEXT GOAL, and the
--               parent is retried only when the crystal has grown
--               (Obstruction's mFailed doctrine: "a conjecture is not
--               retried until the machine knows something it did not
--               know when it failed")
--
-- Termination is NOT a descent argument — Obstruction.hs:260 refutes
-- that reading explicitly (residuals can be larger than their parents).
-- It is: finiteness of the distinct-residual set (measured, 112 over the
-- whole historical log), the pass fixpoint (a full pass that lands
-- nothing ends the run), the per-goal call budget, and the retry gate.
--
-- The crystal file (machine/sphatika.crystal) is the memory; the checked
-- rendering (formal/cubical/Sphatika.agda) is the body, re-verified as a
-- whole by the kernel at every landing because `checkContext` checks the
-- full context, never a lemma alone.
module Main (main) where

import Control.Monad (foldM, forM_, unless, when)
import Data.Char (isSpace)
import Data.List (isInfixOf, isPrefixOf, nub)
import Data.Maybe (fromMaybe, mapMaybe)
import System.Directory (doesFileExist)
import System.Environment (getArgs)
import System.Exit (ExitCode (..), exitFailure)
import System.IO (BufferMode (LineBuffering), hSetBuffering, hSetEncoding, stdout, utf8)

import qualified KernelContext as K
import qualified Obstruction as O

crystalFile :: FilePath
crystalFile = "machine/sphatika.crystal"

renderedFile :: FilePath
renderedFile = "formal/cubical/Sphatika.agda"

-- ------------------------------------------------------------------ canon
--
-- Variables renumbered by first appearance across (lhs, rhs), the same
-- discipline the engine's canonVars kept, so "the same equation" is a
-- syntactic test and the crystal never holds one truth twice under two
-- namings.
canon :: K.Equation -> K.Equation
canon (l, r) =
  let order = nub (K.varsOfT l ++ K.varsOfT r)
      ren t = case t of
        K.V i -> K.V (fromMaybe i (lookup i (zip order [0 ..])))
        K.F f ts -> K.F f (map ren ts)
  in (ren l, ren r)

sameEq :: K.Equation -> K.Equation -> Bool
sameEq a b = canon a == canon b

flippedEq :: K.Equation -> K.Equation -> Bool
flippedEq a (l, r) = canon a == canon (r, l)

-- ------------------------------------------------------- proof (de)notation
--
-- Only the shapes this driver can emit are serialised; the reader is
-- total on what the writer produces and refuses everything else.
showProof :: K.Proof -> String
showProof K.PRefl = "refl"
showProof (K.PCite n _) = "cite " ++ n
showProof (K.PSym (K.PCite n _)) = "symcite " ++ n
showProof (K.PInduction v b s) =
  "ind " ++ show v ++ " " ++ leaf b ++ " " ++ leaf s
  where
    leaf K.PRefl = "refl"
    leaf K.PIh = "ih"
    leaf (K.PCong (K.F "s" [K.V _]) K.PIh) = "congsuc"
    leaf _ = "?"
showProof _ = "?"

readProof :: K.Equation -> String -> Maybe K.Proof
readProof eq s = case words s of
  ["refl"] -> Just K.PRefl
  ["cite", n] -> Just (K.PCite n (idArgs eq))
  ["symcite", n] -> Just (K.PSym (K.PCite n (idArgs eq)))
  ["ind", v, b, st] -> do
    b' <- leaf b
    s' <- leaf st
    Just (K.PInduction (read v) b' s')
  _ -> Nothing
  where
    leaf "refl" = Just K.PRefl
    leaf "ih" = Just K.PIh
    leaf "congsuc" = do
      h <- K.holeFor eq
      Just (K.PCong (K.F "s" [K.V h]) K.PIh)
    leaf _ = Nothing

idArgs :: K.Equation -> [K.Term]
idArgs eq = map K.V (K.equationVarsT eq)

-- --------------------------------------------------------------- the store
loadCrystal :: IO [K.Lemma]
loadCrystal = do
  here <- doesFileExist crystalFile
  if not here then pure [] else do
    ls <- lines <$> readFile crystalFile
    pure (mapMaybe row ls)
  where
    row ln = case splitTabs ln of
      [n, lt, rt, p] -> do
        l <- K.parsePrefixTerm lt
        r <- K.parsePrefixTerm rt
        pf <- readProof (l, r) p
        Just (K.Lemma n (l, r) pf)
      _ -> Nothing

appendCrystal :: K.Lemma -> IO ()
appendCrystal (K.Lemma n (l, r) p) =
  appendFile crystalFile
    (n ++ "\t" ++ K.showPrefixTerm l ++ "\t" ++ K.showPrefixTerm r
       ++ "\t" ++ showProof p ++ "\n")

splitTabs :: String -> [String]
splitTabs s = case break (== '\t') s of
  (a, '\t' : rest) -> a : splitTabs rest
  (a, "") -> [a]
  _ -> [s]

-- --------------------------------------------------------------- the goals
goalsFromReport :: String -> [K.Equation]
goalsFromReport txt =
  [ canon (l, r)
  | ln <- dropWhile (not . isInfixOf "non-joining") (lines txt)
  , [lt, rt] <- [splitTabs ln]
  , Just l <- [K.parsePrefixTerm lt]
  , Just r <- [K.parsePrefixTerm rt]
  ]

-- ------------------------------------------------------------- the shapes
--
-- Cheapest first, exactly the recorded tactic vocabulary plus the cite —
-- nothing here that Certificate's shape menu and the historical naya
-- census do not already name.
shapes :: [K.Lemma] -> K.Equation -> [K.Proof]
shapes crystal eq =
  [ K.PRefl ]
  ++ [ K.PCite (K.lemName lm) (idArgs eq)
     | lm <- crystal, sameEq (K.lemEq lm) eq ]
  ++ [ K.PSym (K.PCite (K.lemName lm) (idArgs eq))
     | lm <- crystal, flippedEq (K.lemEq lm) eq ]
  ++ concat
     [ [ K.PInduction v K.PRefl K.PRefl
       , K.PInduction v K.PRefl K.PIh
       ]
       ++ [ K.PInduction v K.PRefl (K.PCong (K.F "s" [K.V h]) K.PIh)
          | Just h <- [K.holeFor eq] ]
     | v <- K.equationVarsT eq ]

kCallBudget :: Int
kCallBudget = 10

-- ------------------------------------------------------------- one attempt
--
-- Returns the landed lemma, or the refl attempt's kernel text (the one
-- whose stall carries the residual — Obstruction reads refl stalls).
attempt :: FilePath -> [K.Lemma] -> String -> K.Equation
        -> IO (Either String K.Lemma)
attempt root crystal name eq = go (take kCallBudget (shapes crystal eq)) ""
  where
    go [] reflMsg = pure (Left reflMsg)
    go (p : ps) reflMsg = do
      let lm = K.Lemma name eq p
          ctx = K.Context "Sphatika" [] crystal lm
      r <- K.checkContext root ctx
      case r of
        Right (ExitSuccess, _) -> pure (Right lm)
        Right (_, out) ->
          go ps (if p == K.PRefl then out else reflMsg)
        Left _ -> go ps reflMsg

-- ----------------------------------------------------------------- driver
--
-- The agenda is (equation, residual-depth).  A refusal's residual enters
-- ahead of its parent, depth-bounded; the parent re-enters behind it and
-- is skipped until the crystal is larger than it was at the failure.
kDepthBound :: Int
kDepthBound = 4

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetBuffering stdout LineBuffering
  args <- getArgs
  report <- case args of
    [p] -> readFile p
    _ -> putStrLn "usage: sphatika REPORT" >> exitFailure >> pure ""
  mroot <- K.findRepoRoot
  root <- maybe (putStrLn "no repo root" >> exitFailure >> pure ".") pure mroot
  crystal0 <- loadCrystal
  putStrLn ("sphatika: crystal holds " ++ show (length crystal0) ++ " lemmas")
  let goals0 = [ g | g <- goalsFromReport report
               , not (any (\lm -> sameEq (K.lemEq lm) g
                                  || flippedEq (K.lemEq lm) g) crystal0)
               , enters g ]
  putStrLn ("sphatika: " ++ show (length goals0) ++ " goals enter")
  crystalN <- passes root crystal0 (map (\g -> (g, 0)) goals0)
  writeRendering root crystalN
  putStrLn ("sphatika: crystal holds " ++ show (length crystalN)
            ++ " lemmas; rendering " ++ renderedFile)
  where
    -- Obstruction's gate, held by matching (its own doctrine: no
    -- `entered :: Bool` helper — the verdict is carried, not collapsed)
    enters g = case O.pravesha (O.triage (toO g)) of
      O.Pravishati _ -> True
      O.Nivartate _ -> False
    toO (l, r) = (convert l, convert r)
    convert (K.V i) = O.V i
    convert (K.F f ts) = O.F f (map convert ts)

    -- full passes to fixpoint: a pass that lands nothing ends the run
    passes root crystal agenda = do
      (crystal', landedAny, retry) <- onePass root crystal agenda
      if landedAny && not (null retry)
        then passes root crystal' retry
        else pure crystal'

    onePass _ crystal [] = pure (crystal, False, [])
    onePass root crystal agenda = go crystal False [] agenda ([] :: [(K.Equation, Int)])
      where
        go cr landed retry [] _ = pure (cr, landed, reverse retry)
        go cr landed retry ((g, d) : rest) seen
          | any (\lm -> sameEq (K.lemEq lm) g || flippedEq (K.lemEq lm) g) cr =
              go cr landed retry rest seen
          | otherwise = do
              let name = "sp" ++ pad (length cr + 1)
              r <- attempt root cr name g
              case r of
                Right lm -> do
                  appendCrystal lm
                  putStrLn ("  " ++ name ++ "  landed  "
                            ++ K.showPrefixTerm (fst g) ++ " = "
                            ++ K.showPrefixTerm (snd g)
                            ++ "  [" ++ showProof (K.lemProof lm) ++ "]")
                  go (cr ++ [lm]) True retry rest seen
                Left reflMsg -> do
                  let res = case O.classify (toO' g) reflMsg of
                        O.Residual p | d < kDepthBound -> harvest p
                        _ -> Nothing
                  case res of
                    Just rEq
                      | not (any (sameEq rEq . fst) seen)
                        && not (any (\lm -> sameEq (K.lemEq lm) rEq) cr)
                        && enters rEq -> do
                          putStrLn ("  " ++ name ++ "  stalls; residual enters: "
                                    ++ K.showPrefixTerm (fst rEq) ++ " = "
                                    ++ K.showPrefixTerm (snd rEq))
                          go cr landed ((g, d) : retry)
                             ((rEq, d + 1) : rest) ((rEq, d) : seen)
                    _ -> do
                      putStrLn ("  " ++ name ++ "  refused; retried when the crystal grows")
                      go cr landed ((g, d) : retry) rest seen
        toO' (l, r) = (convert l, convert r)
        harvest (a, b) = Just (canon (back a, back b))
        back (O.V i) = K.V i
        back (O.F f ts) = K.F f (map back ts)

    pad s = let t = show s in replicate (3 - length t) '0' ++ t

    writeRendering root crystal =
      case crystal of
        [] -> pure ()
        _ -> case K.renderContext
                    (K.Context "Sphatika" [] (init crystal) (last crystal)) of
          Left e -> putStrLn ("render refused: " ++ K.showRefusal e)
          Right src -> do
            writeFile renderedFile src
            putStrLn ("rendered " ++ show (length crystal) ++ " lemmas")
