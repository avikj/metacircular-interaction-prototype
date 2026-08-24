-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE ScopedTypeVariables #-}
-- =====================================================================
-- machine/ParallelGate.hs — dependency-aware parallel Agda truth gate.
--
-- WHY THIS EXISTS.  The machine's bottleneck is serial Agda checking:
-- Certificate.runAgda spends ~1.3 s per candidate on this container, and
-- every one of those seconds is sequential.  Most candidates do not
-- import each other, so most of that serialism is waste.  This module
-- checks a set of candidate modules in dependency order, up to N (default
-- 3) agda processes at a time, without ever weakening the gate:
--
--   A MODULE IS REPORTED GREEN ONLY FROM ITS OWN `agda` EXIT 0.
--
-- Nothing here proves anything.  Scheduling, batching, caching and
-- copying are all performance; the verdict is agda's alone.  If any part
-- of the machinery fails (exception, timeout, missing dep), the module is
-- red or skipped — never green by default.
--
-- THE CONCURRENCY-CORRUPTION LESSON (collab/messages/0487).  Two agda
-- processes sharing a scratch path can overwrite each other's candidate
-- between write and check, silently certifying the wrong proposition.
-- The discipline adopted there is kept and extended here:
--
--   (a) PRIVATE DIRECTORY PER CHECK.  Every agda invocation gets its own
--       `mktemp -d` directory holding the candidate source.  With no
--       .agda-lib above that directory, agda 2.6.3 writes the candidate's
--       .agdai NEXT TO THE SOURCE (verified on this container), so each
--       worker's writes are confined to its private directory.
--
--   (b) INTERFACES ARE COPIED, NEVER SHARED.  When candidate B imports
--       candidate A, A's source and .agdai are COPIED into B's private
--       directory (transitively).  Agda validates the copied interface
--       against the source hash stored inside it, so a stale or torn copy
--       is rechecked, not trusted.  No worker ever writes into another
--       worker's directory: batches are dependency levels, and level k+1
--       starts only after every check in level k has finished.
--
--   (c) SHARED INTERFACE TREES ARE READ-ONLY DURING PARALLELISM.  The
--       repo's formal/cubical/_build and the cubical library's _build are
--       reused (that is the point of interface files: unchanged deps are
--       not rechecked), but agda REWRITES a shared interface if the dep
--       is stale — and three agda processes rewriting one .agdai is
--       exactly the corruption of msg 0487, one level down.  So before
--       any parallelism, a WARM PASS checks a single generated module
--       that imports every external dependency of every candidate,
--       serially, under an inter-process lock (an atomically-created lock
--       directory, since two ParallelGate processes may share this repo).
--       After the warm pass all shared interfaces are fresh and the
--       parallel workers only read them.  If the warm pass fails (e.g. a
--       candidate imports a module that does not exist), the gate falls
--       back to jobs=1: still correct, merely serial.
--
-- INVOCATION RECIPE.  The agda command line is the one Certificate.hs
-- arrived at after fault (1) there (`-i` alone cannot resolve Cubical.*):
--     agda -i formal/cubical -i <privdir> --library=cubical <privdir>/M.agda
-- run from the repository root with LC_ALL=LANG=C.UTF-8 forced in the
-- child (fault (2) there: agda prints λ and ℕ and dies under LANG=C).
--
-- USAGE
--     parallel-gate [--jobs N] [--root DIR] [--cache DIR] [--timeout S]
--                   [--keep] FILE.agda ...
--     parallel-gate --bench [--jobs N]      10-module serial-vs-parallel
--                                           wall-clock measurement
--     parallel-gate --self-test             known-good green, known-bad red
--
-- Exit code 0 iff every candidate is green.  Per-module verdicts go to
-- stdout as lines beginning GREEN / RED / SKIP / CYCLE, one per module,
-- machine-parseable (MathMachine.hs integration reads these).
--
-- --cache DIR persists green candidates' .agda + .agdai across gate runs;
-- an unchanged resubmitted candidate then costs one interface-validating
-- agda run (~1.3 s of interface loading, no rechecking) instead of a full
-- recheck.  The cache carries the same trust as formal/cubical/_build:
-- agda believes .agdai files whose stored source hash matches.  Do not
-- point it at a directory writable by anything other than this gate.
-- =====================================================================

module Main (main) where

import qualified Certificate as C
import Control.Concurrent (forkIO, setNumCapabilities, threadDelay)
import Control.Concurrent.MVar
import Control.Concurrent.QSemN
import Control.Exception (SomeException, finally, try)
import Control.Monad (forM_, unless, when)
import Data.Char (isAlphaNum, isDigit, isSpace)
import Data.List (foldl', isInfixOf, isPrefixOf, nub, sort)
import Data.Maybe (fromMaybe, listToMaybe, mapMaybe)
import qualified Data.Map.Strict as M
import GHC.Clock (getMonotonicTimeNSec)
import GHC.IO.Encoding (setLocaleEncoding)
import System.Directory
import System.Environment (getArgs, getEnvironment)
import System.Exit
import System.FilePath ((</>), takeBaseName, takeDirectory)
import System.IO
import System.Process
  (CreateProcess (..), proc, readCreateProcessWithExitCode, readProcess)
import Text.Printf (printf)

-- ----------------------------------------------------------- constants

kDefaultJobs :: Int
kDefaultJobs = 3

kDefaultTimeoutSecs :: Int
kDefaultTimeoutSecs = 600

kIncludeRoot :: FilePath
kIncludeRoot = "formal/cubical"

kAgdaLibrary :: String
kAgdaLibrary = "cubical"

kOptionsLine :: String
kOptionsLine = "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"

-- The warm-pass lock.  Created atomically with `createDirectory`; two
-- ParallelGate processes on this shared checkout serialize their warm
-- passes through it.  A crash between acquire and release leaves it
-- behind, so acquisition times out loudly instead of hanging forever.
kWarmLock :: FilePath -> FilePath
kWarmLock root = root </> kIncludeRoot </> ".parallel-gate-warm.lock"

kWarmLockTimeoutSecs :: Int
kWarmLockTimeoutSecs = 900

-- --------------------------------------------------------- small utils

nowSecs :: IO Double
nowSecs = do
  ns <- getMonotonicTimeNSec
  pure (fromIntegral ns / 1e9)

trim :: String -> String
trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

writeUtf8 :: FilePath -> String -> IO ()
writeUtf8 path s = withFile path WriteMode $ \h -> do
  hSetEncoding h utf8
  hPutStr h s

readUtf8 :: FilePath -> IO String
readUtf8 path = withFile path ReadMode $ \h -> do
  hSetEncoding h utf8
  s <- hGetContents h
  length s `seq` pure s

mktempDir :: IO FilePath
mktempDir = do
  tmp <- getTemporaryDirectory
  line <- readProcess "mktemp" ["-d", tmp </> "parallel-gate.XXXXXX"] ""
  pure (trim line)

-- Agda's first complaint as one line (Certificate.firstErrorLine, kept
-- byte-compatible in spirit: location lines name a directory that no
-- longer exists by the time anyone reads the log).
firstErrorLine :: String -> String
firstErrorLine out =
  case dropWhile uninformative (lines out) of
    [] -> "(agda said nothing)"
    ls -> unwords (words (unwords (take 2 ls)))
  where
    uninformative ln =
      null (trim ln)
        || "Checking " `isPrefixOf` trim ln
        || ".agda:" `isInfixOf` ln

-- ------------------------------------------------------------ candidates

data Candidate = Candidate
  { cName    :: String     -- module name (= filename base in its priv dir)
  , cSource  :: String     -- full source text
  , cImports :: [String]   -- every module named by an import line
  } deriving Show

-- Import-line parser.  Machine-emitted candidates spell imports one per
-- line as `open import M ...` or `import M ...`; that is the contract
-- this parser implements.  Line comments are dropped; a `--` inside a
-- line truncates it.  (Block comments spanning lines are not handled —
-- the emitters never produce them; a missed import can only make the
-- dependency graph COARSER in the safe direction if it is an internal
-- import agda will still fail loudly, never silently pass, because the
-- dep's source/interface would be absent from the private directory.)
importsOf :: String -> [String]
importsOf src = nub (mapMaybe imp (lines src))
  where
    imp raw = case words (uncomment raw) of
      ("open" : "import" : m : _) -> Just (moduleToken m)
      ("import" : m : _)          -> Just (moduleToken m)
      _                           -> Nothing
    uncomment ln = case breakOn "--" ln of
      Just before -> before
      Nothing     -> ln
    breakOn pat s = go [] s
      where
        go _   [] = Nothing
        go acc rest@(c:cs)
          | pat `isPrefixOf` rest = Just (reverse acc)
          | otherwise             = go (c : acc) cs
    moduleToken = takeWhile (\c -> isAlphaNum c || c == '.' || c == '_'
                                   || c == '\'' || c == '-')

-- The declared module name wins over the filename: the candidate is
-- installed in its private directory AS <declared>.agda, so agda's
-- module-name/filename check always passes and the caller may hand us
-- files from anywhere.
declaredModuleName :: String -> Maybe String
declaredModuleName src = listToMaybe
  [ m | ln <- lines src
      , ("module" : m : _) <- [words ln] ]

loadCandidate :: FilePath -> IO Candidate
loadCandidate path = do
  src <- readUtf8 path
  let name = fromMaybe (takeBaseName path) (declaredModuleName src)
  pure Candidate { cName = name, cSource = src, cImports = importsOf src }

-- ------------------------------------------------- dependency structure

-- Internal deps: imports that name another candidate in this gate run.
-- Everything else is external and handled by the warm pass + existing
-- interface trees.
internalDeps :: M.Map String Candidate -> Candidate -> [String]
internalDeps byName c = [ d | d <- cImports c, d /= cName c, M.member d byName ]

externalImports :: M.Map String Candidate -> [Candidate] -> [String]
externalImports byName cs =
  sort (nub [ d | c <- cs, d <- cImports c, not (M.member d byName) ])

-- Level assignment (Kahn by iteration): level 0 = no internal deps;
-- level k+1 = all internal deps at levels <= k.  Whatever never gets a
-- level sits on an import cycle and is reported CYCLE — agda itself
-- rejects cyclic imports, so no green is being withheld, but per the
-- gate's rule those modules are simply NOT GREEN rather than guessed at.
levelize :: M.Map String Candidate -> [Candidate]
         -> ([[Candidate]], [Candidate])
levelize byName cands = go M.empty cands []
  where
    go levels pending acc
      | null pending = (reverse acc, [])
      | null ready   = (reverse acc, pending)
      | otherwise    = go levels' rest (ready : acc)
      where
        ready = [ c | c <- pending
                    , all (`M.member` levels) (internalDeps byName c) ]
        rest  = [ c | c <- pending
                    , not (cName c `elem` map cName ready) ]
        levels' = foldl' (\m c -> M.insert (cName c) () m) levels ready

-- Transitive closure of internal deps, for populating a private dir.
transitiveDeps :: M.Map String Candidate -> Candidate -> [String]
transitiveDeps byName c0 = go [] (internalDeps byName c0)
  where
    go seen [] = seen
    go seen (d : ds)
      | d `elem` seen = go seen ds
      | otherwise = case M.lookup d byName of
          Nothing -> go seen ds
          Just c  -> go (d : seen) (internalDeps byName c ++ ds)

-- --------------------------------------------------------------- verdicts

data Verdict
  = Green Double            -- agda exit 0, wall seconds for this check
  | Red String Double       -- agda nonzero (or exception/timeout), reason
  | Skipped [String]        -- an internal dep was not green
  | CycleBound [String]     -- on an import cycle with these modules
  deriving Show

isGreen :: Verdict -> Bool
isGreen (Green _) = True
isGreen _         = False

renderVerdict :: String -> Verdict -> String
renderVerdict n (Green dt)      = printf "GREEN %s %.3fs" n dt
renderVerdict n (Red why dt)    = printf "RED   %s %.3fs  %s" n dt (take 200 why)
renderVerdict n (Skipped deps)  = printf "SKIP  %s (dep not green: %s)" n (unwords deps)
renderVerdict n (CycleBound ms) = printf "CYCLE %s (with: %s)" n (unwords ms)

-- ------------------------------------------------------------ agda runs

-- One agda invocation, wrapped in coreutils `timeout` so a divergent
-- candidate cannot wedge a worker slot forever.  Environment and locale
-- discipline copied from Certificate.runAgda (fault (2) there).
runAgda :: FilePath -> Int -> [String] -> IO (ExitCode, String)
runAgda root timeoutSecs args = do
  setLocaleEncoding utf8
  base <- getEnvironment
  let env' = ("LC_ALL", "C.UTF-8")
             : ("LANG", "C.UTF-8")
             : [ kv | kv@(k, _) <- base, k /= "LC_ALL", k /= "LANG" ]
      cp = (proc "timeout" (show timeoutSecs : "agda" : args))
             { cwd = Just root, env = Just env' }
  (code, out, err) <- readCreateProcessWithExitCode cp ""
  let code' = case code of
        ExitFailure 124 -> ExitFailure 124  -- timeout's own signal
        c               -> c
  -- THE FITNESS, ADDED 2026-08-20.  What was copied from Certificate.runAgda
  -- was the locale discipline; what was left behind is the falsifier watch,
  -- and both call sites read `code == ExitSuccess` alone.  This wrapper is
  -- ALREADY a pipeline of the shape the attack uses — `timeout N agda …` —
  -- so the difference between "agda refused" and "something between agda and
  -- this process returned 0" is exactly the distinction that has to be made
  -- here and was not.  `C.vetForeignRun` reads agda's own words on this call
  -- and, once per process, watches the kernel reject `(suc x) ≡ x`.
  C.vetForeignRun root code' (out ++ err)

agdaArgsFor :: FilePath -> FilePath -> [String]
agdaArgsFor dir file =
  ["-i", kIncludeRoot, "-i", dir, "--library=" ++ kAgdaLibrary, file]

-- ------------------------------------------------------------- warm pass

-- Bring every SHARED interface up to date, serially, under the lock, so
-- the parallel phase never writes outside private directories.  Returns
-- True on success; on failure the caller drops to jobs=1.
warmPass :: FilePath -> Int -> [String] -> IO (Bool, Double)
warmPass _    _           []        = pure (True, 0)
warmPass root timeoutSecs externals = do
  t0 <- nowSecs
  ok <- withWarmLock root $ do
    dir <- mktempDir
    (do let file = dir </> "ParallelGateWarm.agda"
        writeUtf8 file $ unlines $
          [ kOptionsLine
          , "module ParallelGateWarm where"
          ] ++ [ "import " ++ m | m <- externals ]
        (code, _) <- runAgda root timeoutSecs (agdaArgsFor dir file)
        pure (code == ExitSuccess))
      `finally` removePathForcibly dir
  t1 <- nowSecs
  pure (ok, t1 - t0)

withWarmLock :: FilePath -> IO a -> IO a
withWarmLock root act = do
  let lock = kWarmLock root
  acquire lock (kWarmLockTimeoutSecs * 5)   -- 200 ms polls
  act `finally` removePathForcibly lock
  where
    acquire lock 0 = die $ "warm-pass lock " ++ lock
      ++ " held for over " ++ show kWarmLockTimeoutSecs
      ++ "s; if no other gate is running, remove it by hand."
    acquire lock n =
      try (createDirectory lock) >>= \case
        Right ()                    -> pure ()
        Left (_ :: SomeException)   -> do
          threadDelay 200000
          acquire lock (n - 1 :: Int)

-- ------------------------------------------------------------ one check

-- The whole point, condensed: private dir, copied interfaces, one agda,
-- verdict from ITS exit code and nothing else.
checkOne :: FilePath          -- repo root
         -> Int               -- timeout seconds
         -> Bool              -- keep private dir (debugging)
         -> Maybe FilePath    -- persistent cache dir
         -> FilePath          -- green archive for THIS run
         -> M.Map String Candidate
         -> Candidate
         -> IO Verdict
checkOne root timeoutSecs keep cache greenDir byName cand = do
  t0 <- nowSecs
  result <- try $ do
    dir <- mktempDir
    let cleanup = if keep then pure () else removePathForcibly dir
    (do -- (b) copied, not shared: every transitive internal dep's source
        -- and interface come in as private copies.  Deps are only ever
        -- scheduled in earlier levels, so their green files are complete
        -- and quiescent by now.
        forM_ (transitiveDeps byName cand) $ \d -> do
          copyFile (greenDir </> d ++ ".agda")  (dir </> d ++ ".agda")
          copyFile (greenDir </> d ++ ".agdai") (dir </> d ++ ".agdai")
        let srcFile = dir </> cName cand ++ ".agda"
        writeUtf8 srcFile (cSource cand)
        -- Cross-run interface reuse: a cached .agdai is only a HINT.
        -- Agda validates the source hash stored in it; unchanged source
        -- loads instantly, changed source is rechecked in full.
        case cache of
          Nothing -> pure ()
          Just cd -> do
            hit <- doesFileExist (cd </> cName cand ++ ".agdai")
            when hit $
              copyFile (cd </> cName cand ++ ".agdai")
                       (dir </> cName cand ++ ".agdai")
        (code, out) <- runAgda root timeoutSecs (agdaArgsFor dir srcFile)
        t1 <- nowSecs
        case code of
          ExitSuccess -> do
            -- Archive for dependents (this run) and the cache (next run).
            copyFile srcFile (greenDir </> cName cand ++ ".agda")
            copyFile (dir </> cName cand ++ ".agdai")
                     (greenDir </> cName cand ++ ".agdai")
            forM_ cache $ \cd -> do
              copyFile srcFile (cd </> cName cand ++ ".agda")
              copyFile (dir </> cName cand ++ ".agdai")
                       (cd </> cName cand ++ ".agdai")
            pure (Green (t1 - t0))
          ExitFailure 124 ->
            pure (Red ("timeout after " ++ show timeoutSecs ++ "s") (t1 - t0))
          ExitFailure _ ->
            pure (Red (firstErrorLine out) (t1 - t0)))
      `finally` cleanup
  t1 <- nowSecs
  case result of
    Right v                      -> pure v
    Left (e :: SomeException)    ->
      pure (Red ("gate exception: " ++ show e) (t1 - t0))

-- --------------------------------------------------------- worker pool

-- Fixed pool of at most n threads draining a shared queue.  Each action
-- already catches its own exceptions (checkOne returns Red on any), so a
-- worker thread cannot die mid-batch and strand the queue.
runPool :: Int -> [IO ()] -> IO ()
runPool _ []   = pure ()
runPool n acts = do
  queue <- newMVar acts
  doneSem <- newQSemN 0
  let k = max 1 (min n (length acts))
      worker = do
        next <- modifyMVar queue $ \case
          []       -> pure ([], Nothing)
          (a : as) -> pure (as, Just a)
        case next of
          Nothing  -> pure ()
          Just act -> act >> worker
  forM_ [1 .. k] $ \_ ->
    forkIO (worker `finally` signalQSemN doneSem 1)
  waitQSemN doneSem k

-- ------------------------------------------------------------ the gate

data GateReport = GateReport
  { grVerdicts :: [(String, Verdict)]  -- in original candidate order
  , grWarmOk   :: Bool
  , grWarmSecs :: Double
  , grCheckSecs :: Double
  }

gate :: FilePath -> Int -> Int -> Bool -> Maybe FilePath -> [Candidate]
     -> IO GateReport
gate root jobs timeoutSecs keep cache cands = do
  let byName = M.fromList [ (cName c, c) | c <- cands ]
      (levels, cyclic) = levelize byName cands
      cycNames = map cName cyclic
      externals = externalImports byName cands
  -- Duplicate module names would let one candidate shadow another inside
  -- a dependent's private directory: refuse outright.
  when (M.size byName /= length cands) $
    die "duplicate module names among candidates; refusing to gate."
  (warmOk, warmSecs) <- warmPass root timeoutSecs externals
  let jobs' = if warmOk then jobs else 1
  unless warmOk $
    hPutStrLn stderr $ "WARM-FAIL: an external import will not load; "
      ++ "shared interfaces may be rewritten during checks, so falling "
      ++ "back to jobs=1."
  -- The green archive for this run: sources + interfaces of candidates
  -- that have already passed, read by their dependents' private dirs.
  -- Written only between levels' barriers, one writer per module name.
  greenDir <- mktempDir
  results <- newMVar (M.empty :: M.Map String Verdict)
  t0 <- nowSecs
  forM_ levels $ \level -> do
    sofar <- readMVar results
    let blockedOf c = [ d | d <- internalDeps byName c
                          , maybe True (not . isGreen) (M.lookup d sofar) ]
        runnable = [ c | c <- level, null (blockedOf c) ]
        blocked  = [ (c, blockedOf c) | c <- level, not (null (blockedOf c)) ]
    forM_ blocked $ \(c, bad) ->
      modifyMVar_ results (pure . M.insert (cName c) (Skipped bad))
    runPool jobs'
      [ do v <- checkOne root timeoutSecs keep cache greenDir byName c
           modifyMVar_ results (pure . M.insert (cName c) v)
      | c <- runnable ]
  t1 <- nowSecs
  final <- readMVar results
  unless keep (removePathForcibly greenDir)
  let verdictOf c
        | cName c `elem` cycNames = CycleBound cycNames
        | otherwise = fromMaybe (Red "internal: never scheduled" 0)
                                (M.lookup (cName c) final)
  pure GateReport
    { grVerdicts = [ (cName c, verdictOf c) | c <- cands ]
    , grWarmOk = warmOk
    , grWarmSecs = warmSecs
    , grCheckSecs = t1 - t0
    }

printReport :: GateReport -> IO Bool
printReport rep = do
  forM_ (grVerdicts rep) $ \(n, v) -> putStrLn (renderVerdict n v)
  let greens = length [ () | (_, v) <- grVerdicts rep, isGreen v ]
      total  = length (grVerdicts rep)
  printf "GATE %d/%d green  warm=%.3fs%s  check=%.3fs\n"
    greens total (grWarmSecs rep)
    (if grWarmOk rep then "" else " (FAILED, serial fallback)")
    (grCheckSecs rep)
  pure (greens == total)

-- ------------------------------------------------------- root discovery

findRoot :: Maybe FilePath -> IO FilePath
findRoot (Just r) = makeAbsolute r
findRoot Nothing  = getCurrentDirectory >>= climb
  where
    climb d = do
      ok <- doesFileExist (d </> kIncludeRoot </> "natural-machine.agda-lib")
      if ok then pure d
      else let d' = takeDirectory d
           in if d' == d
                then die ("cannot find " ++ kIncludeRoot
                          ++ "/natural-machine.agda-lib above cwd; use --root")
                else climb d'

-- -------------------------------------------------------------- bench

-- Ten modules shaped like the real gate's output: the OPTIONS line,
-- Prelude + Nat imports, refl facts over numerals and the standard
-- induction skeletons Certificate.hs emits.  Eight are independent; two
-- import an earlier one, so the dependency machinery is exercised (the
-- levels come out {1..8}, {9, 10}).
benchModule :: Int -> String
benchModule i = unlines $
  [ kOptionsLine
  , "module " ++ name i ++ " where"
  , "open import Cubical.Foundations.Prelude"
  , "open import Cubical.Data.Nat using (\8469 ; zero ; suc ; _+_ ; _\183_)"
  ] ++ depImport ++
  [ ""
  , "plusZero" ++ n ++ " : (x : \8469) \8594 x + zero \8801 x"
  , "plusZero" ++ n ++ " zero = refl"
  , "plusZero" ++ n ++ " (suc x) = cong suc (plusZero" ++ n ++ " x)"
  , ""
  , "plusSuc" ++ n ++ " : (x y : \8469) \8594 x + suc y \8801 suc (x + y)"
  , "plusSuc" ++ n ++ " zero y = refl"
  , "plusSuc" ++ n ++ " (suc x) y = cong suc (plusSuc" ++ n ++ " x y)"
  , ""
  , "numeral" ++ n ++ " : (" ++ show a ++ " + " ++ show b ++ ") \183 2 \8801 "
      ++ show ((a + b) * 2)
  , "numeral" ++ n ++ " = refl"
  ] ++ depUse
  where
    n = show i
    a = 40 + i
    b = 60 + i
    name :: Int -> String
    name k = "PGBench" ++ show k
    depImport
      | i == 9    = ["open import " ++ name 1 ++ " using (plusZero1)"]
      | i == 10   = ["open import " ++ name 2 ++ " using (plusSuc2)"]
      | otherwise = []
    depUse
      | i == 9 =
          [ ""
          , "viaDep9 : (x : \8469) \8594 x + zero \8801 x"
          , "viaDep9 = plusZero1" ]
      | i == 10 =
          [ ""
          , "viaDep10 : (x y : \8469) \8594 x + suc y \8801 suc (x + y)"
          , "viaDep10 = plusSuc2" ]
      | otherwise = []

-- The 1-minute load average, printed with every bench run.  This
-- container is shared with other agents' agda processes; a speedup
-- number without the ambient load is exactly the "number without its
-- X-dependence" CLAUDE.md warns about, so the measurement carries its
-- conditions with it.
loadAvg1 :: IO String
loadAvg1 = do
  r <- try (readFile "/proc/loadavg")
  pure $ case r of
    Right s -> case words s of (l : _) -> l; _ -> "?"
    Left (_ :: SomeException) -> "?"

runBench :: FilePath -> Int -> Int -> IO ()
runBench root jobs timeoutSecs = do
  let cands = [ Candidate ("PGBench" ++ show i) (benchModule i)
                          (importsOf (benchModule i))
              | i <- [1 .. 10 :: Int] ]
      run label j = do
        load <- loadAvg1
        t0 <- nowSecs
        rep <- gate root j timeoutSecs False Nothing cands
        t1 <- nowSecs
        _ <- printReport rep
        let greens = length [ () | (_, v) <- grVerdicts rep, isGreen v ]
        printf "BENCH %-8s jobs=%d  modules=%d  green=%d  warm=%.3fs  check=%.3fs  total=%.3fs  load1=%s\n\n"
          label j (length cands) greens (grWarmSecs rep) (grCheckSecs rep) (t1 - t0) load
        pure (greens, grCheckSecs rep)
  -- One throwaway warm so BOTH timed runs start from identical fresh
  -- shared interfaces; each run still performs (and pays for) its own
  -- warm pass, reported separately from check time.
  _ <- warmPass root timeoutSecs
         (externalImports (M.fromList [ (cName c, c) | c <- cands ]) cands)
  (gS, serialSecs)   <- run "serial" 1
  (gP, parallelSecs) <- run "parallel" jobs
  when (gS /= gP) $
    die "bench inconsistency: serial and parallel green counts differ"
  printf "BENCH speedup: serial check %.3fs / parallel check %.3fs = %.2fx (jobs=%d)\n"
    serialSecs parallelSecs (serialSecs / parallelSecs) jobs

-- ----------------------------------------------------------- self test

selfTest :: FilePath -> Int -> IO ()
selfTest root timeoutSecs = do
  let good = Candidate "PGSelfGood" goodSrc (importsOf goodSrc)
      bad  = Candidate "PGSelfBad" badSrc (importsOf badSrc)
      dep  = Candidate "PGSelfDep" depSrc (importsOf depSrc)
      goodSrc = unlines
        [ kOptionsLine
        , "module PGSelfGood where"
        , "open import Cubical.Foundations.Prelude"
        , "open import Cubical.Data.Nat using (\8469 ; zero ; suc ; _+_)"
        , "good : (x : \8469) \8594 zero + x \8801 x"
        , "good x = refl" ]
      badSrc = unlines
        [ kOptionsLine
        , "module PGSelfBad where"
        , "open import Cubical.Foundations.Prelude"
        , "open import Cubical.Data.Nat using (\8469 ; zero ; suc)"
        , "bad : (x : \8469) \8594 suc x \8801 x"
        , "bad x = refl" ]
      depSrc = unlines
        [ kOptionsLine
        , "module PGSelfDep where"
        , "open import Cubical.Foundations.Prelude"
        , "open import Cubical.Data.Nat using (\8469 ; zero ; _+_)"
        , "open import PGSelfBad using (bad)"   -- dep on the red one
        , "unreachable : (x : \8469) \8594 zero + x \8801 x"
        , "unreachable x = refl" ]
  rep <- gate root kDefaultJobs timeoutSecs False Nothing [good, bad, dep]
  _ <- printReport rep
  let v n = lookup n (grVerdicts rep)
      okGood = maybe False isGreen (v "PGSelfGood")
      okBad  = case v "PGSelfBad" of Just (Red _ _) -> True; _ -> False
      okDep  = case v "PGSelfDep" of Just (Skipped _) -> True; _ -> False
  if okGood && okBad && okDep
    then putStrLn "SELF-TEST PASS: good green, bad red, dependent-of-bad skipped"
    else die "SELF-TEST FAIL"

-- ---------------------------------------------------------------- main

data Opts = Opts
  { oJobs    :: Int
  , oRoot    :: Maybe FilePath
  , oCache   :: Maybe FilePath
  , oTimeout :: Int
  , oKeep    :: Bool
  , oMode    :: Mode
  }

data Mode = Check [FilePath] | Bench | SelfTest

parseArgs :: [String] -> Opts -> Either String Opts
parseArgs [] o = case oMode o of
  Check [] -> Left "no candidate files given (or use --bench / --self-test)"
  Check fs -> Right o { oMode = Check (reverse fs) }
  _        -> Right o
parseArgs ("--jobs" : n : rest) o
  | all isDigit n, not (null n) = parseArgs rest o { oJobs = read n }
parseArgs ("--timeout" : n : rest) o
  | all isDigit n, not (null n) = parseArgs rest o { oTimeout = read n }
parseArgs ("--root" : d : rest) o = parseArgs rest o { oRoot = Just d }
parseArgs ("--cache" : d : rest) o = parseArgs rest o { oCache = Just d }
parseArgs ("--keep" : rest) o = parseArgs rest o { oKeep = True }
parseArgs ("--bench" : rest) o = parseArgs rest o { oMode = Bench }
parseArgs ("--self-test" : rest) o = parseArgs rest o { oMode = SelfTest }
parseArgs (f : rest) o
  | "--" `isPrefixOf` f = Left ("unknown flag " ++ f)
  | otherwise = case oMode o of
      Check fs -> parseArgs rest o { oMode = Check (f : fs) }
      _        -> Left ("stray argument " ++ f)

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering
  setLocaleEncoding utf8
  -- stdout/stderr already exist with the ambient locale's encoding, so
  -- setLocaleEncoding alone leaves them broken under LANG=C: agda's
  -- diagnostics contain ℕ and would kill the report mid-print.
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  args <- getArgs
  let def = Opts { oJobs = kDefaultJobs, oRoot = Nothing, oCache = Nothing
                 , oTimeout = kDefaultTimeoutSecs, oKeep = False
                 , oMode = Check [] }
  opts <- either die pure (parseArgs args def)
  -- +1 capability so the coordinator never starves the workers.
  setNumCapabilities (oJobs opts + 1)
  root <- findRoot (oRoot opts)
  forM_ (oCache opts) (createDirectoryIfMissing True)
  case oMode opts of
    Bench    -> runBench root (oJobs opts) (oTimeout opts)
    SelfTest -> selfTest root (oTimeout opts)
    Check fs -> do
      cands <- mapM loadCandidate fs
      rep <- gate root (oJobs opts) (oTimeout opts) (oKeep opts)
                  (oCache opts) cands
      allGreen <- printReport rep
      if allGreen then exitSuccess else exitWith (ExitFailure 1)
