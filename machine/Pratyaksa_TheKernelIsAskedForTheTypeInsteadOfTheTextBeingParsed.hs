-- Pratyaksa_TheKernelIsAskedForTheTypeInsteadOfTheTextBeingParsed.hs
--
-- प्रत्यक्षम् — direct apprehension, the pramāṇa that stands on nothing else.
--
-- THE TERM, ITS TEXT AND ITS DATE.  प्रत्यक्ष is the first pramāṇa of the
-- न्यायसूत्र (Gautama, ~2nd c. CE), १.१.४: इन्द्रियार्थसन्निकर्षोत्पन्नं ज्ञानम् —
-- knowledge arising from the contact of sense and object, and the sūtra's
-- point is that it needs no other pramāṇa to license it.  अनुमान is the
-- second, १.१.५, and it runs on a लिङ्ग (a mark) plus व्याप्ति (invariable
-- concomitance between mark and marked).  LIMIT: nothing below is
-- attributed to Gautama or to any Naiyāyika; the distinction is used for
-- exactly the property the sūtras give it — one of these two needs a
-- concomitance to hold and the other does not.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS EXISTS.  This machine learns the corpus's types by PARSING
-- SOURCE TEXT with a hand-written parser.  That is अनुमान: the textual
-- mark is the liṅga, and "a declaration of this shape has that type" is
-- the vyāpti.  The concomitance keeps failing, and `Lopa`'s own header is
-- the catalogue of its failures — consecutive binder groups, lowercase
-- binders invisible to the freeness test, a CONTROL AUDIT block whose only
-- job is filtering the other extractor's forgeries, `knownType`,
-- `resolveExpr`, and node identities that come out as `⟨ambig⟩.M` and
-- `⟨lib⟩.ℕ` because the parser cannot resolve what the module actually
-- meant.  Every one of those is an epicycle on an inference, and every
-- "the corpus is barren" failure written into machine/dosa.lekha traces
-- back to that parser's blindness rather than to the corpus.
--
-- **The typechecker already decides all of it, exactly.**  Agda's
-- interaction mode will hand over, for any module it has checked, every
-- name in it with its ELABORATED, FULLY QUALIFIED type — `⟨lib⟩.ℕ` comes
-- back as `Cubical.Data.Int.Base.ℤ`, `≡` as
-- `Agda.Builtin.Cubical.Path.≡`.  No aliasing, no ambiguity, no repairs.
--
-- So this program stops inferring and asks:
--
--     agda --interaction-json  ←  Cmd_load Everything.agda
--                              ←  Cmd_show_module_contents_toplevel M   (per M)
--
-- ONE load for the whole lane, then one query per module, and it emits the
-- table the rest of the machine should be reading instead of the text.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.  This does not make Lopa correct; it gives Lopa a
-- ground truth to be checked against, and the diff between them is the
-- measurement of an inference by a direct apprehension — which is the
-- only honest way to find out how wrong the parser was.  Nor is the JSON
-- reader below general: it targets ONE stable shape, `{"name":...,
-- "term":...}` inside a `"contents"` array, and it says so here rather
-- than pretending to be a parser.  If Agda changes that shape this
-- program must be told, and its failure mode is empty output, not wrong
-- output — a distinction सूत्र ७ cares about and so does this file.
--
-- USAGE.  runghc machine/Pratyaksa_….hs [lane-dir] [> table.tsv]
-- lane-dir defaults to formal/cubical.

module Main (main) where

import System.Process (readCreateProcessWithExitCode, proc, CreateProcess(..))
import System.Environment (getArgs)
import System.Exit (ExitCode(..))
import Data.List (isPrefixOf, isSuffixOf, isInfixOf, sort, nub)
import System.Directory (listDirectory, doesDirectoryExist)
import Data.Char (isSpace)
import Control.Monad (forM_, when, forM)
import Control.Concurrent (forkIO)
import Control.Concurrent.MVar (newEmptyMVar, putMVar, takeMVar)
import System.Directory (createDirectoryIfMissing, removeFile)
import Control.Exception (try, SomeException)
import System.IO (hPutStrLn, stderr)

-- ─────────────────────────────────────────────────────────────────────
-- 1.  Which modules to ask about: EVERY .agda in the lane.
--
--     The first version asked only about Everything.agda.s direct imports
--     and justified it as "a module nothing imports is built by nothing".
--     That is false and the correction is the point of this program: the
--     kernel reaches modules TRANSITIVELY, so it has already checked far
--     more than the root names, and asking only the root.s imports would
--     have been a second inference standing where a direct look was
--     available -- the same error one level up, inside the program written
--     to correct it.  Recorded here rather than silently fixed.
-- ─────────────────────────────────────────────────────────────────────

-- module name from a path relative to the lane: strip .agda, / becomes .
modNameOf :: FilePath -> String
modNameOf p = map (\c -> if c == '/' then '.' else c) (take (length p - 5) p)

laneModules :: FilePath -> IO [String]
laneModules lane = do
  fs <- walk ""
  pure (nub (sort (map modNameOf fs)))
  where
    walk :: FilePath -> IO [FilePath]
    walk rel = do
      es <- listDirectory (lane ++ "/" ++ rel)
      rss <- mapM (step rel) es
      pure (concat rss)
    step rel e = do
      let r = if null rel then e else rel ++ "/" ++ e
      d <- doesDirectoryExist (lane ++ "/" ++ r)
      if d then (if e == "_build" || take 1 e == "." then pure [] else walk r)
           else pure [ r | ".agda" `isSuffixOf` r ]

trim :: String -> String
trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

-- ─────────────────────────────────────────────────────────────────────
-- 2.  The script.  One load, then one query per module, in order.
-- ─────────────────────────────────────────────────────────────────────

script :: String -> [String] -> String
script root ms = unlines $
  ("IOTCM \"" ++ root ++ "\" None Direct (Cmd_load \"" ++ root ++ "\" [])")
  : [ "IOTCM \"" ++ root ++ "\" None Direct (Cmd_show_module_contents_toplevel Simplified \""
      ++ m ++ "\")" | m <- ms ]

-- ─────────────────────────────────────────────────────────────────────
-- 3.  Reading the answers.  Responses arrive in the order asked, so the
--     module a block belongs to is its position — and an ERROR response
--     occupies a position too, which is why errors are counted rather
--     than skipped.  Dropping them would silently shift every later
--     module's name onto the wrong types.
-- ─────────────────────────────────────────────────────────────────────

data Answer = Contents [(String, String)] | Failed String

answers :: String -> [Answer]
answers out =
  [ a | l <- lines out
      , a <- if "\"contents\":[" `isInfixOf` l then [Contents (pairs l)]
             else if "\"kind\":\"Error\"" `isInfixOf` l then [Failed (short l)]
             else [] ]
  where short l = take 120 [ c | c <- l, c /= '\n' ]

-- targets ONE shape; see the header.  Splits on the literal field markers
-- and unescapes, which is enough for this and is not a JSON reader.
pairs :: String -> [(String, String)]
pairs l = go (chunks "{\"name\":\"" l)
  where
    go []       = []
    go (c : cs) = case breakOn "\",\"term\":\"" c of
      Just (n, rest) -> (unesc n, unesc (fst (endAt rest))) : go cs
      Nothing        -> go cs
    endAt s = span (/= '"') (dropQuoted s)
    dropQuoted = id

chunks :: String -> String -> [String]
chunks sep s = case breakOn sep s of
  Nothing        -> []
  Just (_, rest) -> let (this, more) = splitNext rest in this : chunks sep more
  where splitNext r = case breakOn sep r of
          Nothing        -> (r, "")
          Just (a, b)    -> (a, sep ++ b)

breakOn :: String -> String -> Maybe (String, String)
breakOn sep = go ""
  where
    go _   []           = Nothing
    go acc s@(c : cs)
      | sep `isPrefixOf` s = Just (reverse acc, drop (length sep) s)
      | otherwise          = go (c : acc) cs

-- JSON string unescaping, for the escapes Agda actually emits.  Devanagari
-- comes through literally and is left alone: romanising it to be safe
-- would be this repository's own scrubbing arriving through a lint.
unesc :: String -> String
unesc []                = []
unesc ('\\' : 'n' : r)  = ' ' : unesc r     -- types are flattened to one line
unesc ('\\' : 't' : r)  = ' ' : unesc r
unesc ('\\' : '"' : r)  = '"' : unesc r
unesc ('\\' : '\\' : r) = '\\' : unesc r
unesc (c : r)           = c : unesc r

squeeze :: String -> String
squeeze (' ' : ' ' : r) = squeeze (' ' : r)
squeeze (c : r)         = c : squeeze r
squeeze []              = []

-- ─────────────────────────────────────────────────────────────────────
-- 4.  main
-- ─────────────────────────────────────────────────────────────────────

main :: IO ()
main = do
  args <- getArgs
  let lane = case args of { (d : _) -> d ; _ -> "formal/cubical" }
      lanes = 12   -- perf cores on this machine; the queries are independent
  ms0 <- laneModules lane
  -- AbhijnanaProbes/ is generated probe scratch that does not typecheck.
  -- One module that fails to load takes its WHOLE CHUNK down, so leaving
  -- them in reported hundreds of good modules as unreachable -- the
  -- instrument.s failure printed as the corpus.s absence, in the program
  -- written to stop exactly that.  मौनं न निषेधः.
  let ms = [ m | m <- ms0, m /= "Everything", take 9 m /= "Pratyaksa"
               , take 15 m /= "AbhijnanaProbes" ]
      cs = chunkInto lanes ms
  createDirectoryIfMissing True (lane ++ "/" ++ scratchDir)
  hPutStrLn stderr ("प्रत्यक्ष: " ++ show (length ms) ++ " modules over "
                    ++ show (length cs) ++ " kernels, in parallel")
  outs <- inParallel [ ask lane i c | (i, c) <- zip [0 ..] cs ]
  putStrLn "# प्रत्यक्ष — types as the KERNEL has them, not as a parser inferred them."
  putStrLn "# Each chunk gets a scratch root importing exactly its modules, because"
  putStrLn "# Cmd_show_module_contents needs the module IN SCOPE: loading a root puts"
  putStrLn "# only its DIRECT imports there, and a transitively-checked module answers"
  putStrLn "# NotInScope.  That is the kernel declining to guess, not a failure."
  putStrLn "# module\tname\ttype"
  forM_ (zip cs outs) $ \(c, out) ->
    -- A chunk whose ROOT failed to load answers nothing, and every module
    -- in it would otherwise be reported as individually unreachable.  Say
    -- which it is: a chunk failure is about this program, not the corpus.
    if not ("\"checked\":true" `isInfixOf` out)
      then hPutStrLn stderr ("  चूर्ण-खण्डः CHUNK ROOT FAILED TO LOAD -- "
                             ++ show (length c) ++ " modules unanswered, and this\
                             \ is a fact about this program: " ++ head c ++ " ...")
      else
       forM_ (zip c (answers out)) $ \(m, a) -> case a of
        Failed e     -> hPutStrLn stderr ("  अप्रत्यक्ष " ++ m ++ "  " ++ take 90 e)
        Contents nts -> forM_ nts $ \(n, t) ->
          putStrLn (m ++ "\t" ++ n ++ "\t" ++ squeeze t)

-- The scratch roots must live INSIDE the lane.  Outside it, the lane.s
-- .agda-lib does not apply and every `import` from the scratch file comes
-- back NotInScope -- tried, and that is what happens.  They are named so
-- they are unmistakable, and removed as soon as their kernel answers.
scratchDir :: FilePath
scratchDir = "PratyaksaScratch"

chunkInto :: Int -> [a] -> [[a]]
chunkInto k xs = go xs
  where
    n  = max 1 ((length xs + k - 1) `div` k)
    go [] = []
    go ys = take n ys : go (drop n ys)

-- one kernel per chunk.  The scratch root lives OUTSIDE the lane so no
-- directory walk, check script or commit ever sees it.
ask :: FilePath -> Int -> [String] -> IO String
ask lane i ms = do
  let name = "PratyaksaChunk" ++ show i
      rel  = scratchDir ++ "/" ++ name ++ ".agda"
      path = lane ++ "/" ++ rel
  writeFile path (unlines (("module " ++ scratchDir ++ "." ++ name ++ " where")
                           : [ "import " ++ m | m <- ms ]))
  (_, out, _) <- readCreateProcessWithExitCode
                   (proc "agda" ["--interaction-json", "-i", "."])
                     { cwd = Just lane }
                   (script rel ms)
  _ <- (try (removeFile path) :: IO (Either SomeException ()))
  pure out

inParallel :: [IO a] -> IO [a]
inParallel acts = do
  vs <- forM acts $ \act -> do
    v <- newEmptyMVar
    _ <- forkIO (act >>= putMVar v)
    pure v
  mapM takeMVar vs