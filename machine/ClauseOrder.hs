-- ClauseOrder — pricing the OTHER half of Certificate.hs's Note A.
--
-- ===================================================================
-- WHAT THIS MEASURES AND WHY IT EXISTS
--
-- `machine/Certificate.hs`, Note A (header, ~line 87):
--
--     Agda's `+` and `·` recurse on the FIRST argument; MathMachine's
--     symDefs recurse on the second (x+0=x, x+s y = s(x+y)) … The clause
--     order differs only in which equations hold *definitionally*, and the
--     first-argument order was measured to certify strictly more of the
--     machine's library than a transcription of the symDefs would (it makes
--     (s x + y) = s (x + y) and (s x · y) = y + x · y refl, which the
--     second-argument order does not).
--
-- That sentence carries a measurement with **no number and no reproduction**.
-- `notes/THE_SEAM_ASKS_THE_WRONG_NAYA.md` §8 priced the opposite side of the
-- same trade exactly — 75 of 137 demanded lemmas exist only because the two
-- standpoints disagree about `+` and `·` — and then said, correctly, that the
-- Note A side had not been re-run and might well come out worse.  This module
-- re-runs it.
--
-- It is a MEASUREMENT, which this repository's protocol permits only under a
-- narrow licence: it is exact (a count of a finite committed file), it does
-- no sampling, it fits nothing, and every count below states what it counted.
-- There is no theorem it stands in for, because the quantity is "how many of
-- these 42 equations does agda 2.6.3 accept under each of two module
-- preambles" — a property of a checker's reduction behaviour on a fixed
-- finite list, not of ℕ.
--
-- ===================================================================
-- THE TWO ARMS, AND WHAT KEEPS THEM COMPARABLE
--
-- `FirstArg`  — verbatim `Certificate.agdaCertificateWith` /
--               `Certificate.agdaInductionCertificate` output.  `_+_`, `_·_`
--               and `_∸_` are Cubical/`Agda.Builtin.Nat`'s, recursing on the
--               first argument.  This is what the gate emits today.
--
-- `SecondArg` — the SAME emitter's output, with exactly ONE line rewritten:
--
--                 open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_)
--
--               becomes an import of `_∸_` alone plus local transcriptions of
--               MathMachine's own `symDefs` (MathMachine.hs:722–727):
--
--                 _+_ : ℕ → ℕ → ℕ           _·_ : ℕ → ℕ → ℕ
--                 a + zero    = a           a · zero    = zero
--                 a + (suc b) = suc (a + b) a · (suc b) = (a · b) + a
--
-- The names are SHADOWED, not renamed: the terms `Certificate.agdaTermWith`
-- renders are byte-for-byte identical in the two arms, and so are the proof
-- terms, the telescope, the `max`/`le`/`gcd` transcriptions, the invented
-- concept definitions, and the `--safe` line.  The two modules differ in
-- their definition of `+` and `·` and in nothing else.  That is the whole
-- experimental control, and it is why the difference in the counts can be
-- attributed to the clause order rather than to two emitters.
--
-- `_∸_` is left as the builtin in BOTH arms.  Certificate's header already
-- establishes that MathMachine's `-` symDefs and `Agda.Builtin.Nat._-_` are
-- the same clauses in the same order; nothing about monus is being varied
-- here and varying it would confound the measurement.  (One residual gap,
-- stated because it is real: the machine applies `-(0,x) = 0` and
-- `max(x,0) = x` as unconditional rewrite rules on OPEN terms, while an Agda
-- case tree must split a column first.  That gap is present identically in
-- both arms.)
--
-- ===================================================================
-- THE POPULATION, AND THE SEARCH PROTOCOL
--
-- Population: the 42 DISTINCT equations of `machine/library.terms`, the
-- machine's real proved library (97 lines, 42 distinct left/right pairs; the
-- multiplicities are reported alongside).  Plus the four deliberate
-- falsehoods of `Certificate.falsehoods`, which must be rejected in both
-- arms or neither arm's positive count means anything.
--
-- Protocol, IDENTICAL in the two arms: for each equation, run the gate's own
-- search (`refl`, then the induction skeleton with each of
-- `Certificate.stepShapes`, stopping early when agda blames the base clause)
-- once per variable of the equation, in ascending index order, and take the
-- first success.  Trying every variable rather than only `x` is the point at
-- which a careless protocol would bias the answer: the whole disagreement is
-- about WHICH ARGUMENT POSITION reduces, so a search fixed to one induction
-- column would hand the result to whichever arm that column suits.
--
-- No result of this module is cached to disk (`MATH_CERTCACHE=0` is forced in
-- the child's environment), because a cache entry keyed on a source that this
-- module rewrites is exactly the kind of stale evidence the protocol's
-- "measure it cold" clause exists for.  Identical module sources within one
-- run are memoised in process, which changes no verdict.

-- ===================================================================
-- THE RESULT, so that reading this file is enough
--
--   (i)  FirstArg  certified 36 / 42   (86 of the 97 library.terms lines)
--   (ii) SecondArg certified 35 / 42   (85 of the 97 lines)
--   (i)  refl alone 5 / 42       (ii) refl alone 0 / 42
--   4 equations certify only under (i), 3 only under (ii)
--   falsehoods 4/4 refused in both arms; kernel controls PASS
--
--   arm (i) on mirror(library) 35 / 42 — the SAME 35 equations arm (ii)
--   certifies on the library itself.  The two arms are one gate composed
--   with an involution of the term language, so the 36-vs-35 measures how
--   far `machine/library.terms` is from being closed under that involution
--   and nothing else.
--
-- And `machine/library.terms` is not a neutral population: it is appended
-- only inside `MathMachine`'s kernel-accepted loop (MathMachine.hs:3948),
-- and a conjecture the machine's REWRITER closes never becomes a theorem at
-- all (MathMachine.hs:3452's own comment), so the file is disjoint by
-- construction from the equations that are definitional under (ii).  That
-- is the whole of the measured 5-vs-0.
--
-- Written up, with the proof that no third preamble exists and with the
-- other side of the trade, in `notes/CLAUSE_ORDER_TRADE.md`.
-- ===================================================================

module ClauseOrder
  ( Convention(..)
  , kBuiltinImportLine
  , transcribedPreambleLines
  , retune
  , Outcome(..)
  , certifyUnder
  , Row(..)
  , libraryEquations
  , falsehoods
  , runArm
  , main
  ) where

import Control.Monad (forM, unless)
import Data.IORef (IORef, modifyIORef', newIORef, readIORef)
import Data.List (isInfixOf, isPrefixOf, nub, sort)
import Data.Maybe (fromMaybe, mapMaybe)
import System.Environment (getArgs, getEnvironment)
import System.Exit (ExitCode(..), exitFailure, exitSuccess)
import System.FilePath ((</>))
import System.IO
  (BufferMode(LineBuffering), hSetBuffering, hSetEncoding, stdout, utf8)

import qualified Certificate as C
import qualified KernelContext as K

-- ------------------------------------------------------------ the two arms

data Convention
  = FirstArg    -- ^ Cubical's `_+_`/`_·_`: recursion on the first argument.
  | SecondArg   -- ^ MathMachine's symDefs: recursion on the second argument.
  deriving (Eq, Show)

-- The exact line `Certificate.preambleCore` emits.  Matched literally: if
-- the preamble ever changes shape, this module must fail loudly rather than
-- silently measure two copies of the same arm.
kBuiltinImportLine :: String
kBuiltinImportLine =
  "open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_)"

-- MathMachine.hs:722–727, transcribed clause for clause and in that order.
--
--   Sym "+" 2 …  [ (x + 0,      x)
--                , (x + s y,    s (x + y)) ]
--   Sym "*" 2 …  [ (x * 0,      0)
--                , (x * s y,    (x * y) + x) ]
--
-- Parameters are `a`/`b`, not `x`/`y`, for the reason `Certificate.defVar`
-- gives: the universe letters name the candidate's quantified variables and
-- a local definition must not appear to capture them.  The fixities are
-- `Agda.Builtin.Nat`'s, so that a `cong (_+ k)` section parses the same way
-- in both arms; every term the emitter renders is fully parenthesised, so
-- fixity cannot change what any candidate MEANS, only whether it parses.
transcribedPreambleLines :: [String]
transcribedPreambleLines =
  [ "open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _∸_)"
  , "infixl 6 _+_"
  , "infixl 7 _·_"
  , "_+_ : ℕ → ℕ → ℕ"
  , "a + zero = a"
  , "a + (suc b) = suc (a + b)"
  , "_·_ : ℕ → ℕ → ℕ"
  , "a · zero = zero"
  , "a · (suc b) = (a · b) + a"
  ]

-- How much later everything after the import line sits in the SecondArg
-- module.  Needed because `Certificate.agdaInductionCertificate` reports the
-- 1-based line number of the base clause, and the base/step distinction is
-- what stops the search early.
kLineShift :: Int
kLineShift = length transcribedPreambleLines - 1

-- Rewrite the emitter's module for one arm.  `Left` when the preamble no
-- longer has the shape this module was written against — the same
-- fail-loudly discipline as `KernelContext.PreambleShapeChanged`.
retune :: Convention -> String -> Either String String
retune FirstArg src = Right src
retune SecondArg src = case break (== kBuiltinImportLine) (lines src) of
  (_, []) -> Left ("Certificate.preambleCore no longer emits "
                     ++ show kBuiltinImportLine)
  (before, _ : after) ->
    Right (unlines (before ++ transcribedPreambleLines ++ after))

-- ------------------------------------------------------------- the gate

-- `Certificate.Verdict` plus the one case this module can produce that the
-- gate cannot: the preamble did not have the expected shape.  Kept distinct
-- for `KernelContext`'s reason — "this module could not express it" and "the
-- kernel refused it" are different facts and collapsing them is how 1696
-- residuals died invisibly.
data Outcome
  = Accepted String Int      -- ^ shape that worked, agda calls spent
  | Refused String Int       -- ^ agda's first error line, calls spent
  | NotEmitted String        -- ^ no module was ever written
  deriving (Eq, Show)

isAccepted :: Outcome -> Bool
isAccepted (Accepted _ _) = True
isAccepted _ = False

spent :: Outcome -> Int
spent (Accepted _ n) = n
spent (Refused _ n) = n
spent (NotEmitted _) = 0

-- One in-process memo of module source -> (exit, output).  Two (equation,
-- induction variable) attempts share their `refl` module verbatim, so this
-- removes duplicate agda processes without removing any agda process that
-- would have answered a different question.
type Memo = IORef [(String, (ExitCode, String))]

runModule :: Memo -> FilePath -> String -> IO (ExitCode, String, Int)
runModule memo root src = do
  seen <- readIORef memo
  case lookup src seen of
    Just (c, o) -> pure (c, o, 0)
    Nothing -> do
      (c, o) <- C.runAgda root src
      modifyIORef' memo ((src, (c, o)) :)
      pure (c, o, 1)

-- `Certificate.certifyWith`'s search, with the preamble retuned and with the
-- induction variable supplied by the caller rather than read out of a proof
-- note.  Every other decision — the shape order, the cong-argument cap, the
-- early stop on a blamed base clause, the fail-closed handling of an
-- environment fault — is the gate's, unchanged.
certifyUnder :: Memo -> Convention -> [C.Definition] -> FilePath
             -> C.Equation -> Int -> IO Outcome
certifyUnder memo conv defs root eq v =
  case C.agdaCertificateWith defs eq of
    Nothing -> pure (NotEmitted "outside the emitter's fragment")
    Just refl0 -> case retune conv refl0 of
      Left why -> pure (NotEmitted why)
      Right reflSrc -> do
        (code, out, n0) <- runModule memo root reflSrc
        case code of
          ExitSuccess -> pure (Accepted "refl" n0)
          ExitFailure _
            | environmentFault out -> pure (Refused (firstErrorLine out) n0)
            | otherwise -> do
                let ks = take C.kMaxCongArguments
                           (mapMaybe C.agdaVar (equationVars eq))
                case inductionHypothesis eq of
                  Nothing -> pure (Refused (firstErrorLine out) n0)
                  Just ih -> tryShapes (C.stepShapes ih ks) n0 (firstErrorLine out)
  where
    tryShapes [] used lastErr = pure (Refused lastErr used)
    tryShapes ((label, step) : more) used _ =
      case C.agdaInductionCertificate defs eq v step of
        Nothing -> pure (Refused "induction variable outside the equation" used)
        Just (src0, baseLine0) -> case retune conv src0 of
          Left why -> pure (NotEmitted why)
          Right src -> do
            let baseLine = case conv of
                  FirstArg -> baseLine0
                  SecondArg -> baseLine0 + kLineShift
            (code, out, n) <- runModule memo root src
            let used' = used + n
            case code of
              ExitSuccess ->
                pure (Accepted ("induction on " ++ fromMaybe (show v) (C.agdaVar v)
                                  ++ ", step = " ++ label) used')
              ExitFailure _
                | environmentFault out -> pure (Refused (firstErrorLine out) used')
                | blamedLine out == Just baseLine ->
                    pure (Refused ("base clause: " ++ firstErrorLine out) used')
                | otherwise -> tryShapes more used' (firstErrorLine out)

-- `Certificate.inductionHypothesis`, which is not exported.  Same two lines.
inductionHypothesis :: C.Equation -> Maybe String
inductionHypothesis eq = do
  names <- mapM C.agdaVar (equationVars eq)
  pure ("candidate " ++ unwords names)

equationVars :: C.Equation -> [Int]
equationVars (l, r) = sort (nub (C.varsOf l ++ C.varsOf r))

-- `Certificate.firstErrorLine`, `blamedLine`, `environmentFault`: none are
-- exported, all are three lines, and re-deriving them here keeps this module
-- from needing an edit to `Certificate.hs`.
firstErrorLine :: String -> String
firstErrorLine out = case dropWhile uninformative (lines out) of
  [] -> "(agda said nothing)"
  ls -> unwords (words (unwords (take 2 ls)))
  where
    uninformative ln =
      null (dropWhile (== ' ') ln)
        || "Checking " `isPrefixOf` dropWhile (== ' ') ln
        || ".agda:" `isInfixOf` ln

blamedLine :: String -> Maybe Int
blamedLine out = case mapMaybe grab (lines out) of
  (n : _) -> Just n
  [] -> Nothing
  where
    grab ln = case break (== ':') (dropWhile (== ' ') ln) of
      (_, ':' : rest) | (ds@(_ : _), ',' : _) <- span isDigitC rest -> Just (read ds)
      _ -> Nothing
    isDigitC c = c >= '0' && c <= '9'

environmentFault :: String -> Bool
environmentFault out = C.kEnvironmentFault `isPrefixOf` dropWhile (== ' ') out

-- --------------------------------------------------------- the population

data Row = Row
  { rowEq :: C.Equation
  , rowShown :: String        -- ^ as written in library.terms, lhs TAB rhs
  , rowCount :: Int           -- ^ how many of the 97 lines carry it
  } deriving (Eq, Show)

-- `machine/library.terms`, read with `KernelContext.parsePrefixTerm` (the
-- inverse of MathMachine's `showTermP`, which is the notation the file is
-- written in), deduplicated on the equation with multiplicity kept.  A line
-- that does not parse is DROPPED AND COUNTED, never silently skipped.
libraryEquations :: String -> ([Row], [String])
libraryEquations txt = (rows, bad)
  where
    parsed = [ (ln, twoFields ln) | ln <- lines txt, not (null (trim ln)) ]
    bad = [ ln | (ln, Nothing) <- parsed ]
    good = [ p | (_, Just p) <- parsed ]
    keys = nub (map fst good)
    rows = [ Row eq shown (length [ () | (e, _) <- good, e == eq ])
           | k <- keys
           , let eq = k
           , let shown = head [ s | (e, s) <- good, e == eq ] ]
    twoFields ln = case splitTab ln of
      (a : b : _) -> do
        l <- K.parsePrefixTerm a
        r <- K.parsePrefixTerm b
        pure ((K.toCertTerm l, K.toCertTerm r), a ++ " = " ++ b)
      _ -> Nothing
    splitTab s = case break (== '\t') s of
      (a, '\t' : b) -> a : splitTab b
      (a, _) -> [a]
    trim = dropWhile (`elem` " \t\r")

-- `Certificate.falsehoods`, verbatim.  An arm that certifies any of these is
-- not measuring mathematics and its positive count is void.
falsehoods :: [(String, C.Equation)]
falsehoods =
  [ ("s(x) = x", (su x_, x_))
  , ("(x+y) = (x*y)", (bin "+" x_ y_, bin "*" x_ y_))
  , ("x = le(x,x)", (x_, bin "le" x_ x_))
  , ("(xmaxy) = (x+y)", (bin "max" x_ y_, bin "+" x_ y_))
  ]
  where
    x_ = C.V 0
    y_ = C.V 1
    su t = C.F "s" [t]
    bin f a b = C.F f [a, b]

-- ------------------------------------------------------------- one arm

-- For each equation: the gate's search, once per variable, first success
-- wins.  Returns the outcome and the total agda processes launched.
runArm :: Memo -> Convention -> FilePath -> [C.Equation] -> IO [Outcome]
runArm memo conv root eqs = forM eqs $ \eq -> do
  let vs = case equationVars eq of { [] -> [0] ; xs -> xs }
  go eq vs (NotEmitted "no variable to induct on") 0
  where
    -- `used` always already includes the spend of `acc`, so the total is set
    -- rather than added: a call count that double-counts its last attempt is
    -- a number that looks like knowledge and is not.
    go _ [] acc used = pure (setSpent acc used)
    go eq (v : vs) _ used = do
      o <- certifyUnder memo conv [] root eq v
      let used' = used + spent o
      if isAccepted o then pure (setSpent o used') else go eq vs o used'
    setSpent (Accepted s _) n = Accepted s n
    setSpent (Refused s _) n = Refused s n
    setSpent o _ = o

-- The refl-only pass.  Note A's parenthetical — "(it makes (s x + y) =
-- s (x + y) and (s x · y) = y + x · y refl, which the second-argument order
-- does not)" — is a claim about which equations hold DEFINITIONALLY, and
-- that is a strictly smaller question than which ones the gate can close.
-- It is also the question that generates the residual stream, since the
-- kernel stalls exactly where the two definitions disagree
-- (`notes/THE_SEAM_ASKS_THE_WRONG_NAYA.md` §8).  One agda call per
-- equation per arm, no induction, no step shapes.
reflOnly :: Memo -> Convention -> FilePath -> C.Equation -> IO Outcome
reflOnly memo conv root eq = case C.agdaCertificateWith [] eq of
  Nothing -> pure (NotEmitted "outside the emitter's fragment")
  Just src0 -> case retune conv src0 of
    Left why -> pure (NotEmitted why)
    Right src -> do
      (code, out, n) <- runModule memo root src
      pure $ case code of
        ExitSuccess -> Accepted "refl" n
        ExitFailure _ -> Refused (firstErrorLine out) n

-- ------------------------------------------------- the involution, tested
--
-- THE PREDICTION THIS EXISTS TO RISK.
--
-- Arm (ii)'s `+` and `·` are arm (i)'s with their two argument columns
-- exchanged, clause for clause:
--
--   arm (i)   zero + m = m        arm (ii)  a + zero    = a
--             suc n + m = suc (n + m)       a + (suc b) = suc (a + b)
--   arm (i)   zero · m = zero     arm (ii)  a · zero    = zero
--             suc n · m = m + n · m         a · (suc b) = (a · b) + a
--
-- Under the involution `mirrorTerm`, which swaps the arguments of every `+`
-- and every `*` node and fixes everything else, arm (i)'s clause set IS arm
-- (ii)'s.  `Certificate.stepShapes` is closed under the same swap (the four
-- cong-section shapes come in left/right pairs; `refl`, `ih` and `cong suc`
-- are fixed), and this module's search tries every induction variable, so
-- the search is closed under it too.
--
-- THEREFORE, if the comparison in the COUNTS section is a fact about the two
-- clause orders at all rather than a fact about the population, arm (i) run
-- on `mirrorTerm`-image of the library must certify exactly what arm (ii)
-- certifies on the library itself — same count, and the same equations up to
-- the mirror.  A discrepancy refutes the involution argument and must be
-- reported; agreement means the published difference between the arms is a
-- measurement of how far `machine/library.terms` is from being closed under
-- the mirror, and of nothing else.
--
-- This is a prediction made before the run and printed with its outcome
-- either way.
mirrorTerm :: C.Term -> C.Term
mirrorTerm (C.V i) = C.V i
mirrorTerm (C.F f [a, b])
  | f == "+" || f == "*" = C.F f [mirrorTerm b, mirrorTerm a]
mirrorTerm (C.F f ts) = C.F f (map mirrorTerm ts)

mirrorEq :: C.Equation -> C.Equation
mirrorEq (l, r) = (mirrorTerm l, mirrorTerm r)

-- ---------------------------------------------------------------- report

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetBuffering stdout LineBuffering
  argv <- getArgs
  let root = case [ a | a <- argv, not ("--" `isPrefixOf` a) ] of
        (p : _) -> p
        [] -> "."
  env <- getEnvironment
  putStrLn "ClauseOrder — reproducing Certificate.hs Note A, both sides."
  putStrLn ("repository root: " ++ show root)
  putStrLn ("MATH_CERTCACHE = "
              ++ show (fromMaybe "(unset)" (lookup "MATH_CERTCACHE" env))
              ++ "   (this module never reads or writes the on-disk cache;"
              ++ " it calls Certificate.runAgda, not runAgdaCached)")

  checking <- C.kernelIsChecking root
  putStrLn ("kernel controls (Certificate.kernelIsChecking): "
              ++ (if checking then "PASS" else "FAIL"))
  unless checking $ do
    putStrLn "agda is not checking here; no count below would mean anything."
    exitFailure

  let libPath = root </> "machine" </> "library.terms"
  putStrLn ("library: " ++ libPath)
  txt <- readFile libPath
  let (rows, bad) = libraryEquations txt
      eqs = map rowEq rows
  putStrLn ""
  putStrLn ("machine/library.terms: " ++ show (length (lines txt)) ++ " lines, "
              ++ show (sum (map rowCount rows)) ++ " parsed, "
              ++ show (length rows) ++ " distinct equations, "
              ++ show (length bad) ++ " unparsed")
  mapM_ (\l -> putStrLn ("  UNPARSED  " ++ show l)) bad

  memo <- newIORef []
  putStrLn ""
  putStrLn "== arm (i) FirstArg: Cubical's _+_ and _·_ (what the gate emits today) =="
  aI <- runArm memo FirstArg root eqs
  mapM_ (report rows) (zip eqs aI)

  putStrLn ""
  putStrLn "== arm (ii) SecondArg: MathMachine's symDefs transcribed =="
  aII <- runArm memo SecondArg root eqs
  mapM_ (report rows) (zip eqs aII)

  putStrLn ""
  putStrLn "== refl only: which of the 42 hold DEFINITIONALLY in each arm =="
  rI <- mapM (reflOnly memo FirstArg root) eqs
  rII <- mapM (reflOnly memo SecondArg root) eqs
  let dI = [ eq | (eq, o) <- zip eqs rI, isAccepted o ]
      dII = [ eq | (eq, o) <- zip eqs rII, isAccepted o ]
      shownOf0 eq = head ([ rowShown r | r <- rows, rowEq r == eq ] ++ ["?"])
  putStrLn ("  (i)  FirstArg  refl-certified " ++ show (length dI) ++ " / " ++ show (length eqs))
  mapM_ (\eq -> putStrLn ("      " ++ shownOf0 eq)) dI
  putStrLn ("  (ii) SecondArg refl-certified " ++ show (length dII) ++ " / " ++ show (length eqs))
  mapM_ (\eq -> putStrLn ("      " ++ shownOf0 eq)) dII
  putStrLn ("  definitional in (i) only:  "
              ++ show (length [ () | eq <- dI, eq `notElem` dII ]))
  mapM_ (\eq -> putStrLn ("      " ++ shownOf0 eq)) [ eq | eq <- dI, eq `notElem` dII ]
  putStrLn ("  definitional in (ii) only: "
              ++ show (length [ () | eq <- dII, eq `notElem` dI ]))
  mapM_ (\eq -> putStrLn ("      " ++ shownOf0 eq)) [ eq | eq <- dII, eq `notElem` dI ]

  putStrLn ""
  putStrLn "== the involution test: arm (i) on the mirrored library =="
  putStrLn "   prediction: this equals arm (ii) on the library itself,"
  putStrLn "   equation for equation under mirrorTerm."
  mI <- runArm memo FirstArg root (map mirrorEq eqs)
  let mAcc = [ eq | (eq, o) <- zip eqs mI, isAccepted o ]
      iiAcc = [ eq | (eq, o) <- zip eqs aII, isAccepted o ]
      agree = sort (map show mAcc) == sort (map show iiAcc)
  mapM_ (\(eq, o) -> putStrLn ("  " ++ (if isAccepted o then "OK   " else "NO   ")
                                 ++ pad 34 (shownOf1 rows eq) ++ verdictWord o))
        (zip eqs mI)
  putStrLn ("  arm (i) on mirror(library): " ++ show (length mAcc) ++ " / " ++ show (length eqs))
  putStrLn ("  arm (ii) on library:        " ++ show (length iiAcc) ++ " / " ++ show (length eqs))
  putStrLn ("  PREDICTION " ++ (if agree then "HELD: same equations, up to the mirror."
                                else "REFUTED. Differences:"))
  unless agree $ do
    mapM_ (\eq -> putStrLn ("      only arm (i)/mirror: " ++ shownOf1 rows eq))
          [ eq | eq <- mAcc, eq `notElem` iiAcc ]
    mapM_ (\eq -> putStrLn ("      only arm (ii):       " ++ shownOf1 rows eq))
          [ eq | eq <- iiAcc, eq `notElem` mAcc ]

  putStrLn ""
  putStrLn "== falsehood controls (both arms must refuse all four) =="
  fI <- forM falsehoods $ \(lbl, eq) -> do
          o <- runArm memo FirstArg root [eq]
          pure (lbl, head o)
  fII <- forM falsehoods $ \(lbl, eq) -> do
          o <- runArm memo SecondArg root [eq]
          pure (lbl, head o)
  mapM_ (\(l, o) -> putStrLn ("  (i)  " ++ pad 18 l ++ verdictWord o)) fI
  mapM_ (\(l, o) -> putStrLn ("  (ii) " ++ pad 18 l ++ verdictWord o)) fII

  let okI = [ eq | (eq, o) <- zip eqs aI, isAccepted o ]
      okII = [ eq | (eq, o) <- zip eqs aII, isAccepted o ]
      onlyI = [ eq | eq <- okI, eq `notElem` okII ]
      onlyII = [ eq | eq <- okII, eq `notElem` okI ]
      linesOf eq = sum [ rowCount r | r <- rows, rowEq r == eq ]
      shownOf eq = head ([ rowShown r | r <- rows, rowEq r == eq ] ++ ["?"])
      admitted = [ l | (l, o) <- fI ++ fII, isAccepted o ]

  putStrLn ""
  putStrLn "== COUNTS =="
  putStrLn ("  distinct equations: " ++ show (length eqs))
  putStrLn ("  (i)  FirstArg  certified " ++ show (length okI)
              ++ " / " ++ show (length eqs)
              ++ "   (" ++ show (sum (map linesOf okI)) ++ " of "
              ++ show (sum (map rowCount rows)) ++ " library.terms lines)")
  putStrLn ("  (ii) SecondArg certified " ++ show (length okII)
              ++ " / " ++ show (length eqs)
              ++ "   (" ++ show (sum (map linesOf okII)) ++ " of "
              ++ show (sum (map rowCount rows)) ++ " library.terms lines)")
  putStrLn ("  (i)  FirstArg  refl alone  " ++ show (length dI)
              ++ " / " ++ show (length eqs))
  putStrLn ("  (ii) SecondArg refl alone  " ++ show (length dII)
              ++ " / " ++ show (length eqs))
  putStrLn ("  (i)  FirstArg  on mirror(library) " ++ show (length mAcc)
              ++ " / " ++ show (length eqs)
              ++ "   involution prediction "
              ++ (if agree then "HELD" else "REFUTED"))
  putStrLn ("  certified by (i) only:  " ++ show (length onlyI))
  mapM_ (\eq -> putStrLn ("      " ++ shownOf eq
                            ++ "   [" ++ show (linesOf eq) ++ " lines]")) onlyI
  putStrLn ("  certified by (ii) only: " ++ show (length onlyII))
  mapM_ (\eq -> putStrLn ("      " ++ shownOf eq
                            ++ "   [" ++ show (linesOf eq) ++ " lines]")) onlyII
  -- Every pass, including the refl-only pass and the mirrored arm.  A total
  -- that silently omits a pass is the same species of error as a per-equation
  -- count that adds its last attempt twice; both were present in the first
  -- version of this file and both are fixed here.
  putStrLn ("  agda processes launched this run: "
              ++ show (sum (map spent (aI ++ aII ++ mI ++ rI ++ rII))
                       + sum (map (spent . snd) (fI ++ fII))))

  putStrLn ""
  if null admitted
    then do
      putStrLn ("falsehoods: " ++ show (length fI) ++ "/" ++ show (length fI)
                  ++ " refused in arm (i), " ++ show (length fII) ++ "/"
                  ++ show (length fII) ++ " refused in arm (ii)")
      putStrLn "CLAUSE ORDER TRADE MEASURED"
      exitSuccess
    else do
      putStrLn ("UNSOUND: an arm certified " ++ show admitted)
      exitFailure
  where
    shownOf1 rows eq = head ([ rowShown r | r <- rows, rowEq r == eq ] ++ ["?"])
    pad n s = s ++ replicate (max 0 (n - length s)) ' '
    verdictWord (Accepted s n) = "ACCEPTED (" ++ s ++ ", " ++ show n ++ " calls)"
    verdictWord (Refused s n) = "refused  (" ++ clip s ++ ", " ++ show n ++ " calls)"
    verdictWord (NotEmitted s) = "not emitted (" ++ s ++ ")"
    clip s = let t = unwords (words s)
             in if length t > 60 then take 57 t ++ "..." else t
    report rows (eq, o) =
      putStrLn ("  " ++ (if isAccepted o then "OK   " else "NO   ")
                  ++ pad 34 (head ([ rowShown r | r <- rows, rowEq r == eq ] ++ ["?"]))
                  ++ verdictWord o)
