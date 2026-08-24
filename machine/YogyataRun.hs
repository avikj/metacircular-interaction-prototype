-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Run the fitness survey over this repository.
--
--   ./yogyata              survey machine/ and formal/cubical/
--   ./yogyata <dir> ...    survey the given directories
--
-- Exit code is 0 always.  This is advisory by construction, in line with
-- .claude/hooks/source-coverage.sh, whose own header records that a blocking
-- guard on a judgement call is an outage wearing enforcement's name.  Whether
-- a module SHOULD be reachable is a judgement; that it is not reachable is a
-- fact, and only the fact is reported.
import Yogyata
import System.Environment (getArgs)
import System.Directory (listDirectory, doesDirectoryExist, doesFileExist)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, utf8)
import Data.List (isSuffixOf, isPrefixOf, isInfixOf, sort)
import Control.Monad (filterM, forM)

-- The gates.  A gate is a module that is run or checked by something outside
-- this survey -- CI, a script, a person -- and therefore counts as a root
-- even though nothing in the corpus imports it.
--
-- formal/cubical: IndianLane and NaturalMachine are the aggregates
-- formal/cubical/check.sh actually typechecks; Everything is wider and is
-- checked too (BUILD.md records it as expected red under the pin, which is a
-- statement about its contents, not about whether it is a root).
gates :: [String]
gates = [ "IndianLane", "NaturalMachine", "Everything" ]

-- RECURSIVE.  The first version of this listed one directory level, which
-- is 140 of the 602 Agda files under formal/cubical/, and the survey was
-- then read as covering the corpus.  See Yogyata.hs's report header.
sourceIn :: FilePath -> IO [FilePath]
sourceIn d = do
  ok <- doesDirectoryExist d
  if not ok then return [] else do
    ns <- listDirectory d
    parts <- mapM (\n -> do
       let p = d ++ "/" ++ n
       isdir <- doesDirectoryExist p
       if isdir then sourceIn p
       else return [ p | ".hs" `isSuffixOf` n || ".agda" `isSuffixOf` n ]) ns
    return (sort (concat parts))
main :: IO ()
main = do
  setLocaleEncoding utf8
  setFileSystemEncoding utf8
  hSetEncoding stdout utf8
  args <- getArgs
  let dirs = if null args then ["machine", "formal/cubical"] else args
  paths <- concat <$> mapM sourceIn dirs
  units <- forM paths $ \p -> do
    h <- openFile p ReadMode
    hSetEncoding h utf8
    src <- hGetContents h
    let u = parseUnit gates p src
    length (uName u) `seq` length (uImports u) `seq` uLines u `seq` return u
  mapM_ putStrLn (renderSurveyWith ["NaturalMachine","Everything"] (survey dirs units))
  putStrLn ""
  putStrLn "== CORRECTION PROPAGATION =============================================="
  putStrLn "A module whose header says \"CORRECTION TO `X`\" retracts something in X."
  putStrLn "If X never names the corrector, a reader of X meets the retracted claim"
  putStrLn "and never learns.  Same shape as a module nothing imports, one level up."
  putStrLn ""
  let ups = unpropagated units
      decl = length [ () | u <- units, not (null (uCorrects u)) ]
      pairs = [ (uName c, tn) | c <- units, tn <- uCorrects c
              , tn `elem` map (lastComponent . uName) units ]
  -- THE SAME REFUSAL THE SURVEY MAKES, ADDED 2026-08-19.
  --
  -- Run from inside machine/ (so that the relative paths `machine` and
  -- `formal/cubical` name nothing), the survey printed "NO ROOT FOUND.
  -- Every verdict below would be vacuous.  Refusing to emit them." -- and
  -- then this section printed
  --
  --     modules declaring a correction : 0
  --     (corrector, target) pairs ...  : 0
  --     targets with NO back-reference : 0
  --
  -- three zeros, with nothing looked at, one line above the sentence "A
  -- zero here is only worth the pair list above it."  The file's whole
  -- epistemology is Kumarila's yogya-anupalabdhi: an absence is knowledge
  -- only when the looking was FIT to find the thing.  Zero files read is
  -- the paradigm case of unfit looking, and the survey half knew it while
  -- this half did not.  A tool that refuses in one section and not the
  -- next teaches the reader to trust the number, which is worse than
  -- having no section at all.
  if null units
    then do
      putStrLn "  NOTHING WAS READ.  0 files.  Every count here would be vacuous."
      putStrLn "  Refusing to emit them.  (Run from the repository root:"
      putStrLn "     runghc -imachine machine/YogyataRun.hs )"
    else do
      putStrLn ("  modules declaring a correction : " ++ show decl)
      putStrLn ("  (corrector, target) pairs whose target resolves to a module here: "
                ++ show (length pairs))
      mapM_ (\(c, t) -> putStrLn ("    " ++ c ++ "  corrects  " ++ t
                          ++ (if any (\u -> upCorrector u == c && lastComponent (upTarget u) == t) ups
                                then "   -- NO BACK-REFERENCE"
                                else "   -- back-reference present"))) pairs
      -- The second unfit looking, and it is not the same as the first.
      -- Declarations can resolve to nothing: a header naming a target that
      -- is not a module here (renamed, deleted, or written with a typo)
      -- silently drops out of `pairs`, and then "0 unpropagated" reports
      -- that every correction landed when in fact none was checked.
      if decl > 0 && null pairs
        then putStrLn "  NO DECLARATION RESOLVED.  The zero below is blindness, not health."
        else return ()
      putStrLn ("  targets with NO back-reference : " ++ show (length ups))
      putStrLn "  A zero here is only worth the pair list above it."
      -- and the declarations that named a target nothing here provides
      let unresolved = [ (uName c, tn) | c <- units, tn <- uCorrects c
                       , not (tn `elem` map (lastComponent . uName) units) ]
      if null unresolved then return () else do
        putStrLn ""
        putStrLn ("  DECLARED BUT UNRESOLVED (" ++ show (length unresolved)
                  ++ ") -- named a target this survey does not provide,")
        putStrLn "  so the back-reference test never ran on them:"
        mapM_ (\(c, t) -> putStrLn ("    " ++ c ++ "  claims to correct  " ++ t)) unresolved

      -- ── corrections that land in PROSE ────────────────────────────────
      --
      -- ADDED 2026-08-19, in the same edit that made the section refuse on
      -- unfit looking, and found BY that refusal.  Three declarations were
      -- never tested; two of them name `notes/*.md`.  This survey reads
      -- .hs and .agda, so EVERY correction aimed at a note fell outside
      -- the check silently, and the check reported "0 unpropagated".
      --
      -- That is not a small gap.  Both of this repository's known
      -- propagation failures were prose: `notes/BRAHMASPHUTASIDDHANTA_IN_
      -- ITS_OWN_ORDER.md` §IV kept the exact Whig sentence CLAUDE.md
      -- quotes to prohibit, with a correction sitting at the end of the
      -- same note and §IV unmarked; and the SiteAudit → THE_WITNESS_NUMBER
      -- correction was written four minutes after the module that carried
      -- the retracted claim and never reached it.  A checker blind to
      -- exactly the medium where the failures happened is worse than none,
      -- because its zero is read as coverage.
      --
      -- The test is the same one, unchanged: does the target name the
      -- corrector?  Only the resolution differs -- a path, then a grep,
      -- rather than a module lookup.
      let proseTargets = [ (uName c, tn) | c <- units, tn <- uCorrects c
                         , ".md" `isSuffixOf` tn ]
      if null proseTargets then return () else do
        putStrLn ""
        putStrLn ("  CORRECTIONS AIMED AT PROSE (" ++ show (length proseTargets) ++ "):")
        mapM_ (\(c, tn) -> do
                 let short = reverse (takeWhile (/= '.') (reverse c))
                 ex <- doesFileExist tn
                 if not ex
                   then putStrLn ("    " ++ tn ++ "  <- " ++ c
                                  ++ "   -- NO SUCH FILE; nothing was tested")
                   else do
                     h <- openFile tn ReadMode
                     hSetEncoding h utf8
                     src <- hGetContents h
                     let hit = short `isInfixOf` src
                     length src `seq` hClose h
                     putStrLn ("    " ++ tn ++ "  <- " ++ c
                               ++ (if hit then "   -- back-reference present"
                                          else "   -- NO BACK-REFERENCE")))
              proseTargets
