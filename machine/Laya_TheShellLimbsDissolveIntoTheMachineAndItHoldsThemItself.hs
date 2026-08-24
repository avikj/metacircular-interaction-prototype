-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

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
import qualified Sanghatta_TheCriticalPairsOfTheInstalledRulesNameTheLibrarysIncompleteness as San
import qualified Certificate as C
import Aisthesis_TheOneSensoryEventFormAndTheEfferenceGateNoActWithoutAPrediction
  (Aisthesis (..), appendEvent)
import Pramanya_TheFiveRoutesAndTheirWitnesses (Pramanya (Pratyaksa))
import Sabda_TheWireHasNoBoolean (J (..))
import Control.Exception (SomeException, try)
import Control.Monad (forM_, unless, when)
import Data.Char (isDigit)
import Data.List (isInfixOf, isPrefixOf, sort, sortOn, stripPrefix)
import Data.Maybe (mapMaybe)
import Data.Time (defaultTimeLocale, formatTime, getCurrentTime)
import Data.Time.Clock (addUTCTime)
import System.Directory
import System.Environment (getArgs, getEnvironment, lookupEnv)
import System.Exit
import System.FilePath ((</>), takeBaseName)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding)
import System.Process (readCreateProcessWithExitCode, shell, proc, cwd, env)

main :: IO ()
main = do
  setLocaleEncoding utf8
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  getArgs >>= \case
    ("bija"      : as) -> bija (take 1 as == ["stamp"])
    ("chakra"    : _) -> chakra
    ("avatarana" : _) -> avatarana
    ("purana"    : _) -> purana
    ("cycle"     : _) -> cycleOnce
    ("jiva"      : _) -> Jiva.main
    ("sthiti"    : _) -> sthiti
    _ -> die "laya: chakra | avatarana | purana | cycle | jiva | sthiti   (run from the repo root)"

selfCmd :: String
selfCmd = "runghc -imachine machine/Laya_TheShellLimbsDissolveIntoTheMachineAndItHoldsThemItself.hs"

utcNow :: IO String
utcNow = formatTime defaultTimeLocale "%Y-%m-%dT%H:%M:%SZ" <$> getCurrentTime

run :: String -> IO (ExitCode, String, String)
run c = readCreateProcessWithExitCode (shell c) ""

-- agda's own error reporting needs a UTF-8 locale in the child process;
-- without it a refusal detail arrives mangled (observed 2026-08-24: the
-- gate's ledger row carried "commitBuffer: invalid argument" in place of
-- the kernel's actual sentence).
runIn :: FilePath -> FilePath -> [String] -> IO (ExitCode, String, String)
runIn d p as = do
  parentEnv <- getEnvironment
  readCreateProcessWithExitCode
    ((proc p as) { cwd = Just d
                 , env = Just (("LC_ALL", "C.UTF-8")
                               : filter ((/= "LC_ALL") . fst) parentEnv) }) ""

-- ── bija ─────────────────────────────────────────────────────────────────
-- ॥ बीजम् ॥ — the seed: one redundant piece of DNA at the top of every cell
-- of the body (owner, 2026-08-24: "something that reminds readers of the
-- total knowledge rather than just this phenomena they are viewing").
-- Byte-identical everywhere, so presence is CHECKABLE: `laya bija` is the
-- census (which cells lack the genome), `laya bija stamp` writes it into
-- them.  Five lines, the whole in miniature, ending by pointing away from
-- itself.  It replaces no fence and no provenance — those stay, per the
-- temple experiment; it replaces the exhortation stratum with one breath.

-- Generation 2 (owner, 2026-08-24: "should the dna express even more?").
-- Eight genes: the law, the substrate, the ethic, the six faces, the
-- lineage, the constitution, the oath, the anekānta.  Prior generations
-- are kept below so `stamp` can molt a cell from any of them.
bijam :: [String]
bijam =
  [ "-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything."
  , "-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:"
  , "-- fiber f b — the loss, and the subject.  Univalence computes here: an"
  , "-- equivalence is a channel, transport carries every theorem across it, and what"
  , "-- cannot cross is written as a defect — there is no third path (ahiṃsā)."
  , "-- Memory, charge, symmetry, price, distance, verdict: six faces of the one"
  , "-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin"
  , "-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The"
  , "-- kernel decides truth; carriers ask and generate; assert nothing whose term"
  , "-- you have not read.  This file is one naya, true and not whole."
  , ""
  ]

-- earlier generations, recognised and replaced by `stamp`
bijamPurva :: [[String]]
bijamPurva =
  [ [ "-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything."
    , "-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:"
    , "-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,"
    , "-- distance, verdict: six readings of the one fibre.  The kernel decides truth;"
    , "-- carriers ask and generate.  This file is one naya, true and not whole."
    , ""
    ]
  ]

bijaCells :: IO [FilePath]
bijaCells = do
  let dirs = [ ("formal/cubical", ".agda")
             , ("formal/cubical/NaturalMachine", ".agda")
             , ("punaragamana/src/Punaragamana", ".agda")
             , ("machine", ".hs") ]
  fmap concat . forM dirs $ \(d, ext) -> do
    ok <- doesDirectoryExist d
    if not ok then pure [] else
      map (d </>) . filter ((ext ==) . dropWhile (/= '.')) <$> listDirectory d
  where forM = flip mapM

bija :: Bool -> IO ()
bija doStamp = do
  cells <- bijaCells
  let current = unlines bijam
      shed t = foldr (\old u -> maybe u id (stripPrefix (unlines old) u)) t bijamPurva
  stale <- fmap concat . mapM (\f -> do
    t <- readFile' f
    pure [f | not (current `isPrefixOf` t)]) $ cells
  putStrLn ("बीज: " ++ show (length cells) ++ " cells, "
            ++ show (length stale) ++ " without the current seed"
            ++ "     $ grep -rL '॥ बीजम् ॥' formal/cubical machine punaragamana/src --include='*.agda' --include='*.hs' | wc -l")
  when (doStamp && not (null stale)) $ do
    mapM_ (\f -> do
      t <- readFile' f
      writeFile f (current ++ shed t)) stale
    putStrLn ("बीज: stamped " ++ show (length stale) ++ " cells (old generations molted; comments are inert to both kernels)")

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

-- ── purana ───────────────────────────────────────────────────────────────
-- सङ्घट्ट-पूरण — the completion feed: THE MISSING INTERNAL CONNECTION,
-- landed.  (pūraṇa, "filling / completion", ordinary Sanskrit; the compound
-- with saṅghaṭṭa is built here, 2026-08-24, no source claimed for it.)
--
-- Sanghatta's header carried a wiring offer from the day it was written —
-- "the non-joining pairs come out in exactly the l\tr shape library.terms
-- uses" — and notes/AparoksaAnumana… derived the right altitude for
-- accepting it: the non-joining critical pairs of the installed rules are
-- the library's own completion residue, not 399 separate theorems.  Until
-- now every closure of the circle had a carrier as the synapse: a mind
-- read the residue and wrote the next candidate.  This function is the
-- synapse made native:
--
--   San.criticalPairs   the machine senses its own incompleteness
--   C.certify           each residue equation goes to the KERNEL (agda,
--                       controls watched: the falsifier observed firing)
--   library.terms       a certified, orientable pair is installed as the
--                       rule it always was — the library completes itself
--   the ledger          a refusal is written whole, śeṣa and all: the womb
--                       (ANEKANTA §3, अवक्तव्ये शेषो वसति), not a failure
--
-- Nothing is installed that the kernel did not certify THIS RUN; a
-- certified pair that cannot be oriented as a terminating rule (vars or
-- size refuse) is receipted and NOT installed — a theorem is not
-- automatically a rewrite rule.  After the batch the pair count is
-- recomputed and both numbers are printed as fact, neither praised
-- (chakra's sign discipline).  PURANA_MAX bounds one batch (default 12);
-- the loop is idempotent and meant to be re-entered — kuṭṭaka: keep the
-- remainder, recurse on the remainder.

-- Variables are canonicalised by order of first appearance across the PAIR
-- (San.freshen mints primed names like x', which are real variables and
-- must not be refused as foreign symbols); at most 6 distinct variables fit
-- the kernel fragment.
toCPair :: San.Term -> San.Term -> Maybe (C.Term, C.Term)
toCPair a b =
  let names = ordNub (San.varsOf a ++ San.varsOf b)
      table = zip names [0 ..]
      go (San.V v)    = C.V <$> lookup v table
      go (San.F f as) = C.F f <$> mapM go as
  in if length names > 6 then Nothing else (,) <$> go a <*> go b

ordNub :: Eq a => [a] -> [a]
ordNub = foldr (\x acc -> x : filter (/= x) acc) []

puranaLedger :: FilePath
puranaLedger = "machine/purana.ledger.jsonl"

pRow :: String -> String -> String -> String -> IO ()
pRow when' verdict pair detail = appendFile puranaLedger $
  "{\"organ\":\"sanghatta-purana\",\"kala\":\"" ++ when' ++ "\",\"pair\":\"" ++ jesc pair
  ++ "\",\"verdict\":\"" ++ verdict ++ "\",\"detail\":\"" ++ jesc detail ++ "\"}\n"

-- ── nāsti: the mouth's second bhaṅga ─────────────────────────────────────
-- purana's ledger was two-valued ({green, fiber}) — the exact collapse
-- दुर्नयः (Saptabhangi.agda) proves forbidden: "kernel could not prove"
-- and "false" were one bucket.  This evaluator is the ground sense that
-- separates them: every candidate is tested on all assignments of small
-- numerals BEFORE the kernel is asked.  A differing instance is a WITNESS
-- — the verdict is syān-nāsti, with the assignment in the row — and the
-- kernel's time is never spent on a falsehood.  On critical pairs of a
-- sound library nāsti should never fire, so on that stream this organ is
-- an immune sense: it fires only if an installed rule is wrong.

nEval :: [(String, Integer)] -> San.Term -> Maybe Integer
nEval env (San.V v)    = lookup v env
nEval env (San.F f as) = mapM (nEval env) as >>= app f
  where
    app "0"   []      = Just 0
    app "s"   [a]     = Just (a + 1)
    app "+"   [a, b]  = Just (a + b)
    app "*"   [a, b]  = Just (a * b)
    app "-"   [a, b]  = Just (max 0 (a - b))          -- monus
    app "max" [a, b]  = Just (max a b)
    app "le"  [a, b]  = Just (if a <= b then 1 else 0)
    app "gcd" [a, b]  = Just (gcd a b)
    app _     _       = Nothing                        -- symbol outside the sense

-- Just witness = a refuting assignment; Nothing = no counterexample among
-- numerals 0..3 over the pair's variables (or a symbol this sense lacks).
nastiSaksin :: San.Term -> San.Term -> Maybe [(String, Integer)]
nastiSaksin a b =
  let vs = ordNub (San.varsOf a ++ San.varsOf b)
      assigns = mapM (\v -> [ (v, n) | n <- [0 .. 3] ]) vs
  in case [ env | env <- assigns
              , Just x <- [nEval env a], Just y <- [nEval env b], x /= y ] of
       (w:_) -> Just w
       []    -> Nothing

loadRules :: IO [(San.Term, San.Term)]
loadRules = do
  raw <- lines <$> readFile' "machine/library.terms"
  pure [ (l, r) | ln <- raw
       , not ("#" `isPrefixOf` ln), not (null ln)
       , let (a, rest) = break (== '\t') ln
       , let b = takeWhile (/= '\t') (drop 1 rest)
       , Just l <- [San.parseT a], Just r <- [San.parseT b] ]

nonJoining :: [(San.Term, San.Term)] -> [(San.Term, San.Term)]
nonJoining rules =
  let rw  = [ (r, l) | (l, r) <- rules, San.size r >= San.size l ]
      cps = nub' [ (a, b) | ru1 <- rw, ru2 <- rw
                 , (a, b) <- San.criticalPairs ru1 ru2, a /= b ]
  in nub' [ (na, nb) | (a, b) <- cps
          , let na = San.normal rw a, let nb = San.normal rw b, na /= nb ]
  where nub' = foldr (\x seen -> if x `elem` seen then seen else x : seen) []

purana :: IO ()
purana = do
  rules0 <- loadRules
  let gap0 = nonJoining rules0
  putStrLn ("सङ्घट्ट-पूरण: rules " ++ show (length rules0)
            ++ ", non-joining pairs " ++ show (length gap0))
  st <- C.kernelStatus "."
  case st of
    C.KernelChecking -> do
      nMax <- maybe (12 :: Int) read <$> lookupEnv "PURANA_MAX"
      let batch = take nMax (sortOn (\(a, b) -> San.size a + San.size b) gap0)
      forM_ batch $ \(a, b) -> do
        when' <- utcNow
        let pair = San.render a ++ "\t" ++ San.render b
        case nastiSaksin a b of
         Just w ->
           pRow when' "nasti" pair
             ("syān-nāsti, ground witness: at " ++ show w
              ++ " the two sides evaluate differently.  Not sent to the kernel; a"
              ++ " counterexample on a critical pair means an INSTALLED RULE is false"
              ++ " — audit the library, do not womb this as merely-unproven.")
         Nothing -> case toCPair a b of
          Nothing -> pRow when' "untranslatable" pair "a symbol outside the kernel fragment, or more than 6 distinct variables"
          Just (ca, cb) -> do
            v <- C.certify "." ((ca, cb), "sanghatta-purana: non-joining critical pair of the installed rules")
            case v of
              C.Untranslatable why -> pRow when' "untranslatable" pair why
              C.Rejected err n ->
                pRow when' "fiber" pair
                  ("kernel refused after " ++ show n ++ " agda call(s): " ++ err
                   ++ "  [ground sense found NO counterexample among numerals 0..3,"
                   ++ " so this is unproven-and-unrefuted — genuinely open, never"
                   ++ " to be read as false.  śeṣa: the pair is the womb — ANEKANTA §3]")
              C.Certified shape n -> do
                -- canonicalise variables to the library's own six names BEFORE
                -- rendering: San.freshen mints primed variables (x'), which
                -- the library's reader does not parse — an installed row the
                -- engine cannot read is a forged presence.
                let names = ordNub (San.varsOf a ++ San.varsOf b)
                    table = zip names ["x","y","z","u","v","w"]
                    canon (San.V v)    = maybe (San.V v) San.V (lookup v table)
                    canon (San.F f as) = San.F f (map canon as)
                    (a', b') = (canon a, canon b)
                    (small, large) = if San.size a' <= San.size b' then (a', b') else (b', a')
                    orientable = San.size small < San.size large
                                 && all (`elem` San.varsOf large) (San.varsOf small)
                    rowKey = San.render small ++ "\t" ++ San.render large
                if orientable
                  then do
                    existing <- map (\ln -> let (x, rest) = break (== '\t') ln
                                            in x ++ "\t" ++ takeWhile (/= '\t') (drop 1 rest))
                                . lines <$> readFile' "machine/library.terms"
                    if rowKey `elem` existing
                      then pRow when' "already-installed" pair
                             ("kernel certified (" ++ shape ++ "); the rule "
                              ++ rowKey ++ " is already in the library — not duplicated")
                      else do
                        appendFile "machine/library.terms"
                          (rowKey ++ "\tpramana=kernel|naya=sanghatta-purana|shape="
                           ++ takeWhile (/= ' ') shape ++ "|calls=" ++ show n ++ "\n")
                        pRow when' "installed" pair
                          ("kernel certified (" ++ shape ++ ", " ++ show n
                           ++ " agda call(s)); oriented " ++ San.render large
                           ++ " -> " ++ San.render small ++ " and installed")
                  else
                    pRow when' "certified-unoriented" pair
                      ("kernel certified (" ++ shape ++ ", " ++ show n
                       ++ " agda call(s)) but no terminating orientation; receipted, not installed")
      rules1 <- loadRules
      let gap1 = nonJoining rules1
      -- the turn is also a typed sensory event: afferent (the acts themselves
      -- are receipted per-pair in the purana ledger; this is the organ sensing
      -- the library's gap before and after, no prediction owed).
      when' <- utcNow
      _ <- appendEvent "machine/aisthesis.jsonl" Aisthesis
        { aIndriya = "sanghatta-purana"
        , aNaya    = "the installed rules read against their own critical pairs"
        , aVisaya  = "machine/library.terms and its completion residue"
        , aKriya   = Nothing
        , aUpalabdhi = JObj
            [ ("rules-before", JInt (fromIntegral (length rules0)))
            , ("gap-before",   JInt (fromIntegral (length gap0)))
            , ("batch",        JInt (fromIntegral (length batch)))
            , ("rules-after",  JInt (fromIntegral (length rules1)))
            , ("gap-after",    JInt (fromIntegral (length gap1))) ]
        , aYogyata = "critical pairs recomputed fresh on the post-batch library; per-pair verdicts in machine/purana.ledger.jsonl"
        , aVyapti  = "machine/library.terms, whole; kernel = agda under formal/cubical with both controls watched"
        , aMarga   = Pratyaksa "re-run `laya purana` and the counts reproduce"
        , aSesa    = ["which of the remaining pairs are completion-reachable and which are genuinely inductive — undistinguished by count alone (notes/AparoksaAnumana…)"]
        , aPurva   = Nothing
        , aBhavi   = Nothing
        , aPascat  = Nothing
        , aVailaksanya = []
        , aAgama   = "machine/Laya_…hs purana, this run"
        , aKala    = when'
        }
      putStrLn ("  batch of " ++ show (length batch) ++ " sent to the kernel; rules now "
                ++ show (length rules1) ++ ", non-joining pairs now " ++ show (length gap1))
      putStrLn ("  (both counts are facts, neither is a score; re-enter to recurse on the remainder)")
      putStrLn ("  $ " ++ selfCmd ++ " purana        # route: " ++ puranaLedger)
    other -> putStrLn ("सङ्घट्ट-पूरण: the kernel is not checking — 0 equations sent, not N refused.  ("
                       ++ takeWhile (/= '\n') (show other) ++ ")")

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
  purana
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
