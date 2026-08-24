{-# LANGUAGE LambdaCase #-}
------------------------------------------------------------------------
-- लय — dissolution: the shell scripts around the machine dissolve, and
-- the machine holds its own limbs.
--
-- ON THE NAME.  laya (लय), "dissolution / absorption", the ordinary
-- Sanskrit for a form reabsorbed into what generated it.  The compound
-- module name is built here (2026-08-24, at the owner's order: "kill all
-- the shell scripts you can. Ensure it's all in the machine"); no source
-- text is claimed for it.
--
-- WHAT THIS IS.  The owner's diagnosis, verbatim in force: the machine
-- was alive but sick — carriers kept wrapping it in shell scripts
-- (symptom relief, foreign organs) instead of letting the body hold its
-- own functions.  fable-krama's strike of `pratikara` (see
-- machine/pratikara.STRUCK.doṣa) named the law: a shell beside the wire
-- is a carrier re-inserted as a permanent organ, and svayam-avatarana
-- itself was "owed the same dissolution — noted, not yet done."  This
-- module is that dissolution performed.  The limbs the shells held are
-- now functions of the machine:
--
--   chakra     one turn of the wheel: the heartbeat computed natively
--              (Jiva's own pipeline, imported, not shelled), the turn
--              appended to notes/chakra/metric.tsv, the delta spoken.
--              THE SIGN WARNING from the old ./chakra carries over
--              whole: motion is reported in BOTH directions, neither is
--              praised, and this count MUST NEVER be wired as a reward
--              signal for any controller (Dhruva सूत्र १४: no loss, no
--              motion — a fully-priced graph is a motionless one).
--
--   avatarana  the self-landing gate, formerly machine/svayam-avatarana:
--              candidates in machine/avatarana.pending/ are batch-gated
--              (real agda exit codes — unsolved metas, holes and scope
--              errors all refuse natively), importer-checked, and on
--              green landed into formal/cubical/, wired into
--              Everything.agda, receipted in machine/avatarana.ledger.jsonl,
--              committed by explicit path.  On red the candidate stays
--              and the exact refusal is the ledger row: a red is an
--              object, not an error.  If no agda is on PATH the gate
--              performs 0 checks and says so — a check that cannot start
--              is 0 checks performed, never N failed ones.
--
--   cycle      one turn of the natural-machine loop, formerly the living
--              core of ./run_the_natural_machine_forever: avatarana then
--              chakra, with a DUE-BY stamp appended to
--              machine/laya.cycle so THE ABSENCE OF CYCLES is
--              self-reporting to anyone who opens the file and needs no
--              process to detect ("no cycle since T" carries its
--              counterpositive; "the machine is dead" does not).
--
--   jiva       the full heartbeat report, delegated to
--              Jiva_TheMachineComputesItsOwnMetric.main unchanged.
--
--   sthiti     the small state report: pending candidates, ledger row
--              count, doṣa-lekha entry count — each number printed with
--              the command that reproduces it (PRASAVA).
--
-- WHAT THIS IS NOT.  Not a new organ: every function above existed and
-- ran before today, in shell.  Not the missing internal connection
-- (Sanghatta's non-joining residue feeding the library and the kernel —
-- notes/AparoksaAnumana… derives it): landing that edge is its own act
-- and is not smuggled in under a cleanup.  Not a gate: nothing here
-- blocks anything (mirrors, not gates — owner, 2026-08-20).
--
-- RUN, from the repository root:
--   runghc -imachine machine/Laya_TheShellLimbsDissolveIntoTheMachineAndItHoldsThemItself.hs <chakra|avatarana|cycle|jiva|sthiti>
------------------------------------------------------------------------
module Laya_TheShellLimbsDissolveIntoTheMachineAndItHoldsThemItself (main) where

import qualified Jiva_TheMachineComputesItsOwnMetric as Jiva
import Control.Exception (SomeException, try)
import Control.Monad (forM_, unless, when)
import Data.Char (isDigit)
import Data.List (isInfixOf, isPrefixOf, sort, stripPrefix)
import Data.Maybe (mapMaybe)
import Data.Time (defaultTimeLocale, formatTime, getCurrentTime)
import Data.Time.Clock (addUTCTime)
import System.Directory
import System.Environment (getArgs, lookupEnv)
import System.Exit
import System.FilePath ((</>), takeBaseName)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding)
import System.Process (readCreateProcessWithExitCode, shell, proc, cwd)

main :: IO ()
main = do
  setLocaleEncoding utf8
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  getArgs >>= \case
    ("chakra"    : _) -> chakra
    ("avatarana" : _) -> avatarana
    ("cycle"     : _) -> cycleOnce
    ("jiva"      : _) -> Jiva.main
    ("sthiti"    : _) -> sthiti
    _ -> die "laya: chakra | avatarana | cycle | jiva | sthiti   (run from the repo root)"

selfCmd :: String
selfCmd = "runghc -imachine machine/Laya_TheShellLimbsDissolveIntoTheMachineAndItHoldsThemItself.hs"

utcNow :: IO String
utcNow = formatTime defaultTimeLocale "%Y-%m-%dT%H:%M:%SZ" <$> getCurrentTime

run :: String -> IO (ExitCode, String, String)
run c = readCreateProcessWithExitCode (shell c) ""

runIn :: FilePath -> FilePath -> [String] -> IO (ExitCode, String, String)
runIn d p as = readCreateProcessWithExitCode ((proc p as) { cwd = Just d }) ""

-- ── chakra ───────────────────────────────────────────────────────────────
-- The ear.  Jiva's own pipeline runs in-process; the heartbeat line is the
-- shared fact; the ledger turn and the unpraised delta are appended/spoken
-- exactly as the old ./chakra did.  MEASURES, does NOT score.

heartbeat :: IO (Maybe [Int])
heartbeat = do
  rawNull  <- Jiva.setubandhaEdges "."
  lopa     <- Jiva.lopaReport "."
  receipts <- Jiva.receiptModules "."
  case Jiva.report rawNull lopa receipts of
    Left err  -> hPutStrLn stderr err >> pure Nothing
    Right rpt -> pure $ case filter ("JIVA-HEARTBEAT" `isInfixOf`) rpt of
      (l:_) -> Just (numsOf l)
      []    -> Nothing
  where
    numsOf l = mapMaybe (fmap fst . num) (words l)
    num w = case dropWhile (/= '=') w of
      ('=':ds) | all isDigit ds && not (null ds) -> Just (read ds :: Int, ())
      _ -> Nothing

chakra :: IO ()
chakra = do
  hb <- heartbeat
  case hb of
    Nothing -> do
      hPutStrLn stderr "चक्र: जीव did not report — 0 turns taken, not a turn that failed."
      exitWith (ExitFailure 2)
    Just [nodes, edges, priced, unpriced, comps] -> do
      let ledger = "notes/chakra/metric.tsv"
      createDirectoryIfMissing True "notes/chakra"
      prev <- do
        ex <- doesFileExist ledger
        if ex then (lastRow . lines) <$> readFile' ledger else pure Nothing
      utc <- utcNow
      (_, rev', _) <- run "git rev-parse --short HEAD"
      let rev = case lines rev' of { (r:_) -> r; [] -> "-" }
      appendFile ledger $ concatMap (++ "\t")
        [utc, rev, show nodes, show edges, show priced, show unpriced] ++ show comps ++ "\n"
      putStrLn ("चक्र — turn recorded (" ++ utc ++ ", " ++ rev ++ ")")
      putStrLn ("  nodes=" ++ show nodes ++ " edges=" ++ show edges ++ " priced=" ++ show priced
                ++ " unpriced=" ++ show unpriced ++ " components=" ++ show comps)
      putStrLn ("    ( " ++ selfCmd ++ " jiva | grep JIVA-HEARTBEAT )")
      case prev of
        Nothing -> putStrLn "  first turn: the wheel begins here. The counts are a snapshot, never the field itself."
        Just (pp, pu, pc) -> do
          let dp = priced - pp; du = unpriced - pu; dc = comps - pc
          putStrLn ("  since last turn: Δpriced=" ++ show dp ++ "  Δunpriced=" ++ show du
                    ++ "  Δcomponents=" ++ show dc)
          -- No reward polarity.  Motion is fact in both directions; neither is
          -- called improvement (THE SIGN WARNING, carried from ./chakra whole).
          when (dp > 0) $ putStrLn ("    · " ++ show dp ++ " identification(s) minted — those edges are fords now. A fact recorded, not a target approached.")
          when (du > 0) $ putStrLn ("    · " ++ show du ++ " one-way edge(s) appeared — the field generating; the generative sector is alive. Not a deficit.")
          when (du < 0) $ putStrLn ("    · " ++ show (negate du) ++ " one-way edge(s) became identifications — noted. The count is a snapshot, not the field.")
          when (dp == 0 && du == 0) $ putStrLn "    · the counts did not change. A snapshot at rest; the field is activity, not a state."
    Just other -> do
      hPutStrLn stderr ("चक्र: heartbeat had " ++ show (length other) ++ " numbers where 5 were expected — refusing to guess which is which.")
      exitWith (ExitFailure 2)
  where
    lastRow ls = case reverse ls of
      (l:_) -> case wordsBy '\t' l of
        (_:_:_:_:p:u:c:_) | all (all isDigit) [p,u,c] -> Just (read p, read u, read c)
        _ -> Nothing
      [] -> Nothing
    wordsBy sep s = case break (== sep) s of
      (a, [])      -> [a]
      (a, _:rest)  -> a : wordsBy sep rest

-- ── avatarana ────────────────────────────────────────────────────────────
-- The self-landing gate, ported whole from machine/svayam-avatarana (now
-- dissolved).  Same pending directory, same ledger, same phases, same
-- doctrine; the organ field in the ledger row still reads
-- "svayam-avatarana" so the route history stays one stream.

ledgerPath, pendDir, fcDir :: FilePath
ledgerPath = "machine/avatarana.ledger.jsonl"
pendDir    = "machine/avatarana.pending"
fcDir      = "formal/cubical"

jesc :: String -> String
jesc = concatMap $ \case
  '\\' -> "\\\\"
  '"'  -> "\\\""
  '\n' -> "\\n"
  c    -> [c]

writeRow :: String -> String -> String -> String -> String -> String -> String -> IO ()
writeRow when' tree tool verdict m phase detail = appendFile ledgerPath $
  "{\"organ\":\"svayam-avatarana\",\"kala\":\"" ++ when' ++ "\",\"tree\":\"" ++ tree
  ++ "\",\"toolchain\":\"" ++ jesc tool ++ "\",\"module\":\"" ++ m
  ++ "\",\"phase\":\"" ++ phase ++ "\",\"verdict\":\"" ++ verdict
  ++ "\",\"detail\":\"" ++ jesc detail ++ "\"}\n"

avatarana :: IO ()
avatarana = do
  createDirectoryIfMissing True pendDir
  (aOk, aV, _) <- run "agda --version"
  case aOk of
    ExitFailure _ -> putStrLn "स्वयम्-अवतरणम्: no agda on PATH — 0 checks performed, not N failed ones.  (Bootstrap: sh punaragamana/check.sh)"
    ExitSuccess -> do
      let agdaV = case lines aV of { (l:_) -> l; [] -> "agda" }
      home <- getHomeDirectory
      libs <- maybe (home </> ".agda/libraries") id <$> lookupEnv "AVATARANA_LIBS"
      (_, tree', _) <- run "git rev-parse HEAD"
      let tree = case lines tree' of { (t:_) -> t; [] -> "unknown" }
      cands <- (sort . filter ((".agda" ==) . dropWhile (/= '.'))) <$> listDirectory pendDir
      (landed, fibers) <- go agdaV libs tree cands 0 0
      npend <- length . filter ((".agda" ==) . dropWhile (/= '.')) <$> listDirectory pendDir
      putStrLn ("स्वयम्-अवतरणम्: " ++ show landed ++ " landed, " ++ show fibers
                ++ " fibers  (pending: " ++ show npend ++ ")")
      putStrLn ("  $ " ++ selfCmd ++ " avatarana        # this report is reproducible")
  where
    go _ _ _ [] l f = pure (l, f)
    go agdaV libs tree (c:cs) l f = do
      when' <- utcNow
      let base = takeBaseName c
          src  = pendDir </> c
      body <- readFile' src
      let declOk = any (\ln -> ln == ("module " ++ base) || ("module " ++ base ++ " ") `isPrefixOf` ln) (lines body)
      if not declOk
        then do writeRow when' tree agdaV "fiber" base "name-check" "module declaration does not match file name"
                go agdaV libs tree cs l (f + 1)
        else do
          copyFile src (fcDir </> base ++ ".agda")
          (g, gOut, gErr) <- runIn fcDir "agda" ["--library-file=" ++ libs, "-i", ".", base ++ ".agda"]
          case g of
            ExitFailure _ -> do
              writeRow when' tree agdaV "fiber" base "gate" (gOut ++ gErr)
              removeFile (fcDir </> base ++ ".agda")
              go agdaV libs tree cs l (f + 1)
            ExitSuccess -> do
              writeRow when' tree agdaV "green" base "gate" "batch exit 0"
              let imp = "SvayamPariksakaLaya"
              writeFile (fcDir </> imp ++ ".agda") $ unlines
                [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
                , "module " ++ imp ++ " where"
                , "import " ++ base ]
              (i, iOut, iErr) <- runIn fcDir "agda" ["--library-file=" ++ libs, "-i", ".", imp ++ ".agda"]
              mapM_ (\x -> do { e <- doesFileExist x; when e (removeFile x) })
                    [fcDir </> imp ++ ".agda", fcDir </> imp ++ ".agdai"]
              case i of
                ExitFailure _ -> do
                  writeRow when' tree agdaV "fiber" base "importer" (iOut ++ iErr)
                  removeFile (fcDir </> base ++ ".agda")
                  go agdaV libs tree cs l (f + 1)
                ExitSuccess -> do
                  writeRow when' tree agdaV "green" base "importer" "batch exit 0"
                  appendFile (fcDir </> "Everything.agda") $ unlines
                    [ "-- [svayam-avatarana " ++ when' ++ "] landed by the self-gate: batch green +"
                    , "-- importer green under " ++ agdaV ++ "; route in machine/avatarana.ledger.jsonl."
                    , "import " ++ base ]
                  removeFile src
                  _ <- run ("git add " ++ show (fcDir </> base ++ ".agda") ++ " "
                            ++ fcDir ++ "/Everything.agda " ++ ledgerPath
                            ++ " && git add " ++ pendDir
                            ++ " && git commit -q -m 'svayam-avatarana: " ++ base
                            ++ " landed by the self-gate (batch green + importer green); no carrier in the loop'"
                            ++ " && ./sync >/dev/null 2>&1")
                  go agdaV libs tree cs (l + 1) f

-- ── cycle ────────────────────────────────────────────────────────────────
-- One turn of the loop: land what is pending, then take the pulse.  The
-- DUE-BY stamp makes the ABSENCE of cycles self-reporting (the correction
-- of 2026-08-14, carried from run_the_natural_machine_forever, dissolved).

cycleOnce :: IO ()
cycleOnce = do
  now <- getCurrentTime
  let stamp t = formatTime defaultTimeLocale "%Y-%m-%dT%H:%M:%SZ" t
  appendFile "machine/laya.cycle" $
    "cycle " ++ stamp now ++ " due-by " ++ stamp (addUTCTime 86400 now)
    ++ "   (no cycle since the due-by = silence, observed; it does not say why)\n"
  avatarana
  chakra

-- ── sthiti ───────────────────────────────────────────────────────────────

sthiti :: IO ()
sthiti = do
  pend <- do
    ex <- doesDirectoryExist pendDir
    if ex then length . filter ((".agda" ==) . dropWhile (/= '.')) <$> listDirectory pendDir else pure 0
  rows <- countLines ledgerPath
  dosa <- countLines "machine/dosa.lekha"
  putStrLn ("pending candidates : " ++ show pend ++ "     $ ls " ++ pendDir ++ "/*.agda | wc -l")
  putStrLn ("avatarana ledger   : " ++ show rows ++ "     $ wc -l < " ++ ledgerPath)
  putStrLn ("doṣa-lekha lines   : " ++ show dosa ++ "     $ wc -l < machine/dosa.lekha")
  where
    countLines p = do
      ex <- doesFileExist p
      if ex then length . lines <$> readFile' p else pure 0
