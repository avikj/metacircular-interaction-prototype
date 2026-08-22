-- Samuccaya_TheAggregateRootIsGeneratedFromTheTreeSoNothingCanBeOmitted.hs
--
-- समुच्चयः — a collecting-together.
--
-- मूलवाक्यम् · PROVENANCE OF THE NAME.  समुच्चय is ordinary Sanskrit (सम् +
-- उद् + √चि, "to heap up together"), attested as a title-word for a compendium
-- that gathers its field without leaving parts out: Dignāga, *Pramāṇasamuccaya*
-- (~500 CE); Virahāṅka, *Vṛttajātisamuccaya* (c. 600–800 CE, Velankar's range).
-- LIMIT, stated at the site so nothing is smuggled: the word is used here in
-- that plain sense only.  NO source is claimed to have stated anything about
-- aggregate roots, import closures, or this program.  Naming this module
-- समुच्चय does not attribute its content to Dignāga or to Virahāṅka.
--
-- ─────────────────────────────────────────────────────────────────────────
-- WHAT THIS IS, IN ONE SENTENCE
--
-- The import closure of `formal/cubical/`, computed exactly, plus a generator
-- that writes an aggregate root which imports every module the tree holds
-- except a declared exclusion list — so a module can no longer go dark by
-- being forgotten.
--
-- ─────────────────────────────────────────────────────────────────────────
-- WHY.  A HAND-KEPT LIST ROTS, AND IT ROTTED.
--
-- `machine/Nama_TheNameIsCarriedAndTheHashIsTheBase.hs` states the diagnosis
-- this program acts on, and it is quoted rather than paraphrased:
--
--     no aggregate root.  `formal/cubical/Everything.agda` exists because a
--     file can sit on disk unbuilt, so something must list what to check —
--     and a hand-kept list rots.  A store has no outside.
--
-- नाम's remedy is content-addressing: bind the content, derive the path, and
-- the store has no outside because nothing is ever omitted from it.  That is
-- the right answer and it is a rewrite of the substrate.  This program takes
-- the SAME move at the one place it costs nothing.  The file tree is already
-- the store.  `Everything.agda` is a hand-copied INDEX of it, and an index
-- maintained beside its store is exactly the fibre of `index ↦ store` failing
-- to be contractible.  So: stop copying, and DERIVE the index.  §४१ सारणी वा
-- क्रिया — keep the क्रिया, regenerate the सारणी.
--
-- ─────────────────────────────────────────────────────────────────────────
-- THE DEFECT THIS PROGRAM WAS WRITTEN AFTER FINDING, 2026-08-22
--
-- `scripts/check-agda-closure.sh` and `scripts/.prasava-unreached.sh` both
-- match an import's module name with an ASCII-only character class:
--
--     grep -oE 'import[[:space:]]+[A-Za-z0-9_'.-]+'
--
-- Every module whose name carries a non-ASCII character therefore reads as
-- NEVER IMPORTED, however many roots import it.  Measured on this tree:
-- `Ratri.Anirdharita_KloostermanExponents_ℤ±`,
-- `…FiniteOccupancyChannelNoGo_Occupancy₄`,
-- `…TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal_विवेक` and their
-- निर्धारण children — 17 modules — were reported as orphans by both scripts
-- while `Everything.agda` imports them by name.
--
-- CLAUDE.md already names this failure, one level up, about a different
-- check: *"a check that scores a Devanagari citation below a romanised one is
-- this rule's own scrubbing arriving through the back door as a lint."*  It
-- arrived through the back door again, as a closure gate, and the cost was a
-- gate that cried orphan at exactly the modules whose names were not English.
--
-- So this program parses a module name as "the token up to whitespace", with
-- no alphabet named anywhere in it.  There is nothing to extend for Tamil or
-- Persian, because nothing was enumerated.
--
-- ─────────────────────────────────────────────────────────────────────────
-- WHAT THIS DOES *NOT* CLAIM
--
-- This is text analysis, not a build.  A module inside the closure is a
-- module something would recheck; it says NOTHING about whether it
-- typechecks.  The generated root is the thing you then hand to `agda`, and
-- it is expected to be RED the first time, because a module nobody built may
-- not build — see notes/ and BUILD.md for the verdicts.
--
-- ─────────────────────────────────────────────────────────────────────────
-- USE.  From the repository root:
--
--     runghc machine/Samuccaya_…hs            report the closure; exit 1 if
--                                             any non-excluded module is
--                                             outside it
--     runghc machine/Samuccaya_…hs --write    regenerate the aggregate root
--                                             formal/cubical/Samuccaya_….agda
--     runghc machine/Samuccaya_…hs --orphans  print the orphan list, one per
--                                             line, and nothing else
--
-- Exclusions are DECLARED, in `formal/cubical/SAMUCCAYA_EXCLUSIONS.txt`, and
-- a module may be excluded only with a reason on the same line.  The reason
-- is not decoration: `NaturalMachine/Control/*` are designed-annihilation
-- controls that MUST fail to typecheck (collab/PROTOCOL.md §7), so importing
-- one turns the aggregate red for a reason that is not a defect.  An
-- exclusion with no reason is a FAIL, so this list cannot become the place
-- inconvenient modules are quietly dropped — which would rebuild, inside the
-- fix, the exact hiding the fix exists to end.

{-# LANGUAGE ScopedTypeVariables #-}

module Main (main) where

import Control.Monad (forM, forM_, unless, when)
import Data.Char (isSpace)
import Data.List (isPrefixOf, isSuffixOf, sort, nub, partition)
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import System.Directory
import System.Environment (getArgs)
import System.Exit
import System.FilePath
import System.IO

-- ── the trees this program is responsible for ─────────────────────────────
--
-- `punaragamana/src` is a SEPARATE Agda include path with its own
-- Everything.agda, so it is a separate closure question and is reported as
-- one.  Folding it silently into the cubical count is how the previous
-- census produced a number that answered neither question.

data Tree = Tree
  { tPath      :: FilePath
  , tRoots     :: [String]   -- hand-kept aggregate roots, by module name
  , tGenerate  :: Bool       -- write a derived root for this tree?
  }

trees :: [Tree]
trees =
  [ Tree "formal/cubical"
         ["Everything", "NaturalMachine", "MachineMinted.Everything"] True
  , Tree "punaragamana/src" ["Everything"] False
  ]

exclusionFileFor :: Tree -> FilePath
exclusionFileFor t = tPath t </> "SAMUCCAYA_EXCLUSIONS.txt"

generatedRoot :: String
generatedRoot = "Samuccaya_TheAggregateRootIsGeneratedFromTheTreeSoNothingCanBeOmitted"

-- ── walking the tree ──────────────────────────────────────────────────────

listAgda :: FilePath -> IO [FilePath]
listAgda dir = do
  es <- listDirectory dir
  fmap concat . forM (sort es) $ \e -> do
    let p = dir </> e
    isDir <- doesDirectoryExist p
    if isDir
      then if e == "_build" || e == ".git" then pure [] else listAgda p
      else pure [p | ".agda" `isSuffixOf` e]

-- path (relative to the tree) -> dotted module name
toModule :: Tree -> FilePath -> String
toModule t p = map (\c -> if c == pathSeparator then '.' else c)
                   (dropExtension (makeRelative (tPath t) p))

toPath :: Tree -> String -> FilePath
toPath t m = tPath t </> map (\c -> if c == '.' then pathSeparator else c) m <.> "agda"

-- ── parsing imports ───────────────────────────────────────────────────────
--
-- NO ALPHABET IS NAMED HERE.  A module name is the token up to whitespace.
-- `--` starts a line comment except when it is inside a pragma; pragmas carry
-- no imports, so dropping the whole line when it opens `{-#` is safe and is
-- what the shell gates did.

stripComment :: String -> String
stripComment s = go s
  where
    go [] = []
    go ('-':'-':_) = []
    go (c:cs) = c : go cs

importsOf :: String -> IO [String]
importsOf src = do
  let ls = lines src
  pure . nub $ concatMap parse ls
  where
    parse raw =
      let l = stripComment raw
          t = dropWhile isSpace l
          afterOpen = if "open" `isPrefixOf` t && startsSpace (drop 4 t)
                        then dropWhile isSpace (drop 4 t) else t
      in if "import" `isPrefixOf` afterOpen && startsSpace (drop 6 afterOpen)
           then let nm = takeWhile (\c -> not (isSpace c) && c /= ';')
                                   (dropWhile isSpace (drop 6 afterOpen))
                in [nm | not (null nm)]
           else []
    startsSpace (c:_) = isSpace c
    startsSpace []    = False

-- STRICT.  `hGetContents` is lazy and leaves the handle open until the string
-- is consumed, so on `--write` this program opened the generated root for
-- reading (it is a file in the tree like any other), never finished reading
-- it, and then failed with `openFile: resource busy` when it tried to write
-- the same path.  A generator that cannot regenerate its own output is not a
-- generator.  `length` forces the whole string before `hClose`.
readUtf8 :: FilePath -> IO String
readUtf8 p = do
  h <- openFile p ReadMode
  hSetEncoding h utf8
  s <- hGetContents h
  _ <- length s `seq` pure ()
  hClose h
  pure s

-- ── exclusions ────────────────────────────────────────────────────────────

data Excl = Excl { exPat :: String, exReason :: String } deriving Show

loadExclusions :: Tree -> IO [Excl]
loadExclusions t = do
  let exclusionFile = exclusionFileFor t
  ok <- doesFileExist exclusionFile
  if not ok then pure [] else do
    src <- readUtf8 exclusionFile
    let rows = [ l | l <- lines src
                   , let t = dropWhile isSpace l
                   , not (null t), not ("#" `isPrefixOf` t) ]
    forM rows $ \l -> case break (== '\t') l of
      (p, '\t':r) | not (null (dropWhile isSpace r)) ->
        pure (Excl (trim p) (trim r))
      _ -> do
        hPutStrLn stderr $
          "samuccaya: FAIL — exclusion row has no reason (TAB then the reason): " ++ l
        exitWith (ExitFailure 2)
  where trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

matches :: Excl -> String -> Bool
matches (Excl p _) m
  | "*" `isSuffixOf` p = init p `isPrefixOf` m
  | otherwise          = p == m

-- ── closure ───────────────────────────────────────────────────────────────

closureFrom :: M.Map String [String] -> [String] -> S.Set String
closureFrom graph = go S.empty
  where
    go seen [] = seen
    go seen (m:ms)
      | m `S.member` seen = go seen ms
      | otherwise = case M.lookup m graph of
          Nothing -> go seen ms                 -- external (Cubical.*, Agda.*)
          Just is -> go (S.insert m seen) (is ++ ms)

-- ── main ──────────────────────────────────────────────────────────────────

data Report = Report
  { rTree :: Tree, rMods :: [String], rExcluded :: [String]
  , rInScope :: [String], rRoots :: [String]
  , rOrphans :: [String], rBadExcl :: [String] }

survey :: Tree -> IO Report
survey t = do
  files <- listAgda (tPath t)
  let mods = map (toModule t) files
  graph <- fmap M.fromList . forM mods $ \m -> do
    src <- readUtf8 (toPath t m)
    is <- importsOf src
    pure (m, is)
  excls <- loadExclusions t
  let modSet   = S.fromList mods
      excluded = [ m | m <- mods, any (`matches` m) excls ]
      -- The generated root is a ROOT, not content: nothing is supposed to
      -- import it, and counting it as an orphan of the hand-kept roots would
      -- make this gate permanently red at itself.  Note what is deliberately
      -- NOT done here: the generated root is not added to `tRoots`.  If it
      -- were, the closure would cover everything by construction and this
      -- number would go to 0 forever — true, and useless.  The measured
      -- roots stay the HAND-KEPT ones, so this keeps reporting the drift of
      -- the hand list even after the derived root has made that drift
      -- harmless.  Coverage is guaranteed by the generated root; the number
      -- below is the diagnosis, not the guarantee.
      inScope  = [ m | m <- mods, not (any (`matches` m) excls)
                                , m /= generatedRoot ]
      roots    = [ r | r <- tRoots t, r `S.member` modSet ]
      reached  = closureFrom graph roots
      orphans  = [ m | m <- inScope, not (m `S.member` reached) ]
      badExcl  = [ m | m <- excluded, m `S.member` reached, m `notElem` roots ]
  pure (Report t mods excluded inScope roots orphans badExcl)

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  args <- getArgs
  reps <- mapM survey trees

  case args of
    ["--orphans"] ->
      mapM_ (\r -> mapM_ (\m -> putStrLn (tPath (rTree r) ++ "|" ++ m)) (rOrphans r)) reps
        >> exitSuccess

    ["--write"] -> do
      forM_ reps $ \r -> when (tGenerate (rTree r)) $ do
        let t    = rTree r
            body = [ m | m <- rInScope r, m /= generatedRoot ]
        writeRootFile t body (length (rExcluded r))
        putStrLn $ "samuccaya: wrote " ++ toPath t generatedRoot
        putStrLn $ "  " ++ show (length body) ++ " imports, "
                        ++ show (length (rExcluded r)) ++ " declared exclusion(s)"
      exitSuccess

    _ -> do
      forM_ reps $ \r -> do
        let t = rTree r
        putStrLn $ "samuccaya — import closure of " ++ tPath t ++ "/"
        putStrLn $ "  hand-kept roots : " ++ unwords (rRoots r)
        putStrLn $ "  modules on disk : " ++ show (length (rMods r))
        putStrLn $ "  declared excl.  : " ++ show (length (rExcluded r))
        putStrLn $ "  in scope        : " ++ show (length (rInScope r))
        putStrLn $ "  reached         : "
                   ++ show (length (rInScope r) - length (rOrphans r))
        putStrLn $ "  UNREACHED       : " ++ show (length (rOrphans r))
        forM_ (rOrphans r) $ \m -> putStrLn ("      ORPHAN " ++ m)
        unless (null (rBadExcl r)) $ do
          putStrLn "  FAIL: a declared exclusion is inside the closure —"
          putStrLn "  these are must-fail controls; importing one makes the"
          putStrLn "  aggregate red for a reason that is not a defect."
          forM_ (rBadExcl r) $ \m -> putStrLn ("      IMPORTED-CONTROL " ++ m)
        putStrLn ""
      let bad = concatMap rOrphans reps ++ concatMap rBadExcl reps
      putStrLn $ "TOTAL UNREACHED : " ++ show (length (concatMap rOrphans reps))
      if null bad then exitSuccess else exitWith (ExitFailure 1)

writeRootFile :: Tree -> [String] -> Int -> IO ()
writeRootFile t body nExcl = do
  h <- openFile (toPath t generatedRoot) WriteMode
  hSetEncoding h utf8
  mapM_ (hPutStrLn h) (header ++ map ("import " ++) body)
  hClose h
  where
    header =
      [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
      , ""
      , "------------------------------------------------------------------------"
      , "-- समुच्चयः — GENERATED.  DO NOT EDIT BY HAND."
      , "--"
      , "-- Regenerate with:"
      , "--     runghc machine/Samuccaya_TheAggregateRootIsGeneratedFromTheTreeSoNothingCanBeOmitted.hs --write"
      , "--"
      , "-- Every .agda file under formal/cubical/ is imported here except the"
      , "-- " ++ show nExcl ++ " row(s) declared with a reason in"
      , "-- formal/cubical/SAMUCCAYA_EXCLUSIONS.txt.  `Everything.agda` remains the"
      , "-- hand-kept, ANNOTATED index and is imported by this file like any other"
      , "-- module; this file is the one that cannot omit anything, because it is"
      , "-- not written by anybody."
      , "--"
      , "-- Being inside this root means something WOULD recheck the module.  It"
      , "-- does not mean the module typechecks.  Run agda on this file to learn"
      , "-- that, and expect red the first time."
      , "------------------------------------------------------------------------"
      , ""
      , "module " ++ generatedRoot ++ " where"
      , ""
      ]
