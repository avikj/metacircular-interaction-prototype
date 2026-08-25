-- Jiva_TheMachineComputesItsOwnMetric.hs
--
-- जीव · jīva, "the living one".
--
-- THE TERM, ITS TEXT AND ITS DATE.  Ordinary Sanskrit for the living
-- being, the principle by which a body is alive rather than a heap
-- (attested from the Ṛgveda onward; central as a technical term in Jain
-- ontology, where जीव is exactly what is capable of knowing itself).
-- LIMIT: no text is claimed for this application; the word is used for
-- the one property that is load-bearing here — a system is alive to the
-- extent that it can report its own state, and this program is that
-- report.  उपयोग — the system's awareness of its own state; movement 51's
-- "the machine computes its own metric", as a program rather than a
-- sentence.
--
-- WHAT THE PROGRAM DOES.  One run prints the machine's computational-
-- spacetime report, assembled by RUNNING the corpus's own extractors as
-- subprocesses and reading their stdout — the exact pattern of
-- machine/Marga_TheRouterTransportsATheoremAlongLandedEdges.hs, and for
-- the same reason: both extractors are `module Main` and un-importable
-- (the corpus's documented defect), so their printed output is their
-- interface.
--
--   1. THE NULL SECTOR (road one): the invertible edges.  Setubandha's
--      `EVERY EDGE` block restricted to the declarations that survive
--      Lopa's `CONTROL AUDIT` — NEVER the raw Setubandha list, which
--      over-counts roughly twofold (167 printed against 88 surviving at
--      commit ddc71aad; the audit is recomputed live, so the figure
--      moves with the corpus).  Nodes, surviving edges, components,
--      largest component.
--   2. THE TIMELIKE SECTOR (road two): the one-way edges.  Lopa's
--      `EVERY GENUINE ONE-WAY EDGE` block, plus the three-valued fibre
--      verdict counts (बहु / रिक्तम् / UNDECIDED) from its
--      `FIBRE VERDICTS` block.  Two verdicts would be Saptabhangi.दुर्नयः
--      compiled; the three are reported as Lopa decides them.
--   3. THE MASS MAP: the unpriced fibres are the dark matter — edges
--      whose transport toll nobody has computed.  Total unpriced count
--      and a TOP-10 FRONTIER of highest-value work.
--   4. RECEIPTS MINTED: the modules of the known receipt families found
--      in the source tree, listed with paths.
--   5. THE HEARTBEAT LINE: one grep-able summary line, designed to be
--      diffed between runs — the metric's time series.
--
-- THE PRASAVA RULE (PRASAVA.tsv: "a number without a command is a
-- memory").  Every number below is printed adjacent to the command that
-- reproduces it.  Where the number is a direct count over an extractor's
-- stdout, the command is a shell pipeline over that stdout.  Where the
-- number is a graph computation (components, degrees, intersections),
-- the command is `./jiva` itself: सारणी वा क्रिया is an identity, the
-- procedure is deterministic, and this file IS the procedure — but the
-- raw inputs it consumes each carry their own independent pipeline, so
-- the derivation is checkable end to end.
--
-- WHAT THE NUMBERS ARE NOT, stated so it can be attacked:
--   * The FRONTIER RANKING IS A HEURISTIC, graded MINE, not a theorem.
--     For a candidate edge joining two components C₁, C₂ of the combined
--     graph, the score is |C₁|·|C₂| — the number of node pairs that
--     become routable at all if any single edge lands between them.  For
--     an unpriced directed edge A ⟶ B, the score is deg(A) + deg(B) in
--     the combined undirected graph — how much traffic a receipt at that
--     edge would gate.  Neither score is derived from anything; both are
--     proxies chosen because they are exact counts of graph objects
--     rather than fitted constants.  The two scales are NOT comparable
--     and are therefore never merged into one ranking.
--   * The MASS PROXY IS A COUNT, NOT A CURVATURE TENSOR.  "Unpriced" is
--     the cardinality of Lopa's UNDECIDED verdict class; it measures how
--     many fibres nobody has graded, not how much is lost at any of
--     them.  Pricing one fibre is the work of FactorsThrough descent
--     witnesses (NaturalMachine/FiniteInformation.agda) and is exactly
--     what this report cannot do — it can only say where the work is.
--   * Node identity is EXACT-STRING equality of the extractors' resolved
--     normal-forms, inheriting every limit stated in their headers.
--
-- ROBUSTNESS.  Every parse is validated BEFORE anything is printed, and
-- cross-checked (decided + undecided must equal the edge-list length).
-- If an extractor fails or its format changed, this program dies naming
-- the extractor and prints NO report — the corpus's rule: a check that
-- cannot start performed 0 checks, not N failed ones.
--
-- RUN:
--   ./jiva                          from the repo root, or
--   ghc -imachine -main-is Jiva_TheMachineComputesItsOwnMetric \
--       -o /tmp/jiva machine/Jiva_TheMachineComputesItsOwnMetric.hs \
--     && /tmp/jiva [repo-root]

module Jiva_TheMachineComputesItsOwnMetric where

import Data.Char (isSpace, isDigit)
import Data.List (isPrefixOf, isInfixOf, isSuffixOf, nub, sort, sortBy, foldl', intercalate)
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import Data.Maybe (mapMaybe, fromMaybe)
import Data.Ord (comparing, Down(..))
import System.Directory (doesDirectoryExist, listDirectory)
import System.Environment (getArgs)
import System.Exit (die)
import System.FilePath ((</>), takeExtension, takeFileName)
import System.IO
import System.Process (readProcess)

import Aisthesis_TheOneSensoryEventFormAndTheEfferenceGateNoActWithoutAPrediction
  ( Aisthesis(..), parseHeartbeat, sariraJ, appendEvent )
import Pramanya_TheFiveRoutesAndTheirWitnesses (Pramanya(Pratyaksa))
import Sabda_TheWireHasNoBoolean (J(JObj))
import Data.Time.Clock (getCurrentTime)
import Data.Time.Format (formatTime, defaultTimeLocale)

-- ─────────────────────────────────────────────────────────────────────────
-- 0.  The extractors, run as subprocesses (Marga's pattern)
-- ─────────────────────────────────────────────────────────────────────────

setubandhaHs, lopaHs :: FilePath
setubandhaHs = "machine/Setubandha_TheCheckedIdentificationsAreEdgesAndTheIsolatedNodesAreTheFrontier.hs"
lopaHs       = "machine/Lopa_TheIrreversibleEdgesAreTheOtherGraphAndTheyRunOneWay.hs"

runExtractor :: FilePath -> FilePath -> IO [String]
runExtractor root hs = lines <$> readProcess "runghc" [root </> hs, root] ""

cannotStart :: String -> String -> IO a
cannotStart extractor what = die $
  "JIVA CANNOT START: " ++ extractor ++ " printed no parseable " ++ what
  ++ ".\nThe extractor failed or its format changed.  0 checks were"
  ++ " performed, not N failed ones; no partial report is printed."

-- ─────────────────────────────────────────────────────────────────────────
-- 1.  Shared string utilities (identical conventions to Marga's parse)
-- ─────────────────────────────────────────────────────────────────────────

trim :: String -> String
trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

splitOnSub :: String -> String -> Maybe (String, String)
splitOnSub pat = go ""
  where
    go acc s | pat `isPrefixOf` s = Just (reverse acc, drop (length pat) s)
    go acc (c:cs) = go (c:acc) cs
    go _   []     = Nothing

-- the lines of one "── TITLE ──" section: everything after the header
-- line, up to (not including) the first blank line
sectionAfter :: String -> [String] -> [String]
sectionAfter title ls =
  takeWhile (not . null) (drop 1 (dropWhile (not . (title `isInfixOf`)) ls))

-- ─────────────────────────────────────────────────────────────────────────
-- 2.  The null sector: Setubandha ∩ Lopa's CONTROL AUDIT
-- ─────────────────────────────────────────────────────────────────────────

data NullEdge = NullEdge
  { nKind :: String   -- "equiv" or "path"
  , nA, nB :: String  -- resolved node normal-forms
  , nProv :: String   -- Module.decl that proves it
  } deriving (Show, Eq, Ord)

parseNullEdge :: String -> Maybe NullEdge
parseNullEdge l = do
  r0 <- if "  [" `isPrefixOf` l then Just (drop 3 l) else Nothing
  let (kind, r1) = break (== ']') r0
  r2 <- if "] " `isPrefixOf` r1 then Just (drop 2 r1) else Nothing
  (ab, prov) <- splitOnSub "   « " r2
  (a, b)     <- splitOnSub "  ≃  " ab
  Just (NullEdge kind (trim a) (trim b) (trim prov))

setubandhaEdges :: FilePath -> IO [NullEdge]
setubandhaEdges root = do
  ls <- runExtractor root setubandhaHs
  let es = mapMaybe parseNullEdge (sectionAfter "EVERY EDGE" ls)
  if null es then cannotStart setubandhaHs "EVERY EDGE block" else return es

-- Lopa's CONTROL AUDIT block: flush-left Module.decl names; indented
-- lines are commentary.  (Same reading as Marga's lopaAudit.)
parseAudit :: [String] -> [String]
parseAudit ls =
  [ l | l <- sectionAfter "CONTROL AUDIT" ls
      , not ("  " `isPrefixOf` l), not (null (trim l)) ]

-- ─────────────────────────────────────────────────────────────────────────
-- 3.  The timelike sector: Lopa's one-way edges and fibre verdicts
-- ─────────────────────────────────────────────────────────────────────────

data DirEdge = DirEdge
  { dKind :: String   -- "map" or "projection"
  , dA, dB :: String
  , dProv :: String
  } deriving (Show, Eq, Ord)

parseDirEdge :: String -> Maybe DirEdge
parseDirEdge l = do
  r0 <- if "  [" `isPrefixOf` l then Just (drop 3 l) else Nothing
  let (kind, r1) = break (== ']') r0
  r2 <- if "] " `isPrefixOf` r1 then Just (drop 2 r1) else Nothing
  (ab, prov) <- splitOnSub "   « " r2
  (a, b)     <- splitOnSub "  ⟶  " ab
  Just (DirEdge kind (trim a) (trim b) (trim prov))

-- "  1031  UNDECIDED" / "    14  बहु" / "     4  रिक्तम्"
parseVerdictCounts :: [String] -> [(String, Int)]
parseVerdictCounts ls =
  [ (unwords rest, read n)
  | l <- sectionAfter "FIBRE VERDICTS" ls
  , (n:rest) <- [words l], all isDigit n, not (null rest) ]

-- provenance names of the decided verdicts: the "        « Name" lines
-- of the EVERY DECIDED VERDICT block
parseDecidedProv :: [String] -> [String]
parseDecidedProv ls =
  [ trim rest | l <- decidedBlock, Just rest <- [stripLeader l] ]
  where
    decidedBlock = sectionAfter "EVERY DECIDED VERDICT" ls
    stripLeader l = snd <$> splitOnSub "« " l

data Lopa = Lopa
  { loAudit    :: [String]
  , loEdges    :: [DirEdge]
  , loVerdicts :: [(String, Int)]
  , loDecided  :: [String]
  }

lopaReport :: FilePath -> IO Lopa
lopaReport root = do
  ls <- runExtractor root lopaHs
  let audit    = parseAudit ls
      edges    = mapMaybe parseDirEdge (sectionAfter "EVERY GENUINE ONE-WAY EDGE" ls)
      verdicts = parseVerdictCounts ls
      decided  = parseDecidedProv ls
  if null audit    then cannotStart lopaHs "CONTROL AUDIT block"          else return ()
  if null edges    then cannotStart lopaHs "EVERY GENUINE ONE-WAY EDGE block" else return ()
  if null verdicts then cannotStart lopaHs "FIBRE VERDICTS block"         else return ()
  return (Lopa audit edges verdicts decided)

verdictCount :: String -> [(String, Int)] -> Int
verdictCount k = sum . map snd . filter ((== k) . fst)

-- ─────────────────────────────────────────────────────────────────────────
-- 4.  Graphs: components and degrees over exact-string nodes
-- ─────────────────────────────────────────────────────────────────────────

type Adj = M.Map String [String]

adjOf :: [(String, String)] -> Adj
adjOf prs = M.fromListWith (++) (concat [ [(a, [b]), (b, [a])] | (a, b) <- prs ])

componentsOf :: [(String, String)] -> [S.Set String]
componentsOf prs = sortBy (comparing (Down . S.size)) (go (M.keys adj) S.empty)
  where
    adj = adjOf prs
    go [] _ = []
    go (n:ns) seen
      | n `S.member` seen = go ns seen
      | otherwise = let c = reach (S.singleton n) [n] in c : go ns (S.union seen c)
    reach seen [] = seen
    reach seen (x:xs) =
      let new = [ y | y <- fromMaybe [] (M.lookup x adj), not (y `S.member` seen) ]
      in reach (foldl' (flip S.insert) seen new) (xs ++ new)

degreeOf :: [(String, String)] -> M.Map String Int
degreeOf prs = M.fromListWith (+) (concat [ [(a, 1), (b, 1)] | (a, b) <- prs ])

-- ─────────────────────────────────────────────────────────────────────────
-- 5.  Receipts minted: the known receipt families, found in the tree
-- ─────────────────────────────────────────────────────────────────────────

receiptFamilies :: [String]
receiptFamilies = ["Lopa_TheSums", "YugmaPurana", "SthiraBindu", "GoldbachSupport"]

sourceExts :: [String]
sourceExts = [".agda", ".lean", ".hs"]

skipDir :: FilePath -> Bool
skipDir p = any (`isInfixOf` takeFileName p) ["_build", ".lake", ".git", ".stack-work"]

walkTree :: FilePath -> IO [FilePath]
walkTree root = do
  isDir <- doesDirectoryExist root
  if not isDir then return [] else do
    entries <- listDirectory root
    fmap concat $ mapM (step . (root </>)) entries
  where
    step p = do
      d <- doesDirectoryExist p
      if d then (if skipDir p then return [] else walkTree p)
           else return [p | takeExtension p `elem` sourceExts]

receiptModules :: FilePath -> IO [FilePath]
receiptModules root = do
  fs <- walkTree root
  return (sort [ f | f <- fs, any (`isPrefixOf` takeFileName f) receiptFamilies ])

-- ─────────────────────────────────────────────────────────────────────────
-- 6.  The report
-- ─────────────────────────────────────────────────────────────────────────

-- a number with the command that reproduces it, PRASAVA-style
metric :: String -> Int -> String -> [String]
metric label n cmd =
  [ "  " ++ label ++ " : " ++ show n
  , "      $ " ++ cmd ]

setuCmd, lopaCmd :: String
setuCmd = "runghc " ++ setubandhaHs ++ " ."
lopaCmd = "runghc " ++ lopaHs ++ " ."

jivaCmd :: String
jivaCmd = "./jiva     (deterministic graph computation over the two stdouts above)"

report :: [NullEdge] -> Lopa -> [FilePath] -> Either String [String]
report rawNull lopa receipts = do
  -- ── the null sector ──
  let auditSet = S.fromList (loAudit lopa)
      kept     = [ e | e <- rawNull, nProv e `S.member` auditSet ]
      nullPrs  = [ (nA e, nB e) | e <- kept ]
      nullComps = componentsOf nullPrs
      nullNodes = S.unions nullComps
  if null kept
    then Left ("JIVA CANNOT START: the Setubandha \x2229 Lopa audit intersection is\
               \ empty.  Either extractor's provenance format changed; refusing to\
               \ report a null sector of 0 as if measured.")
    else Right ()
  -- ── the timelike sector, cross-checked ──
  let des       = loEdges lopa
      nBahu     = verdictCount "\x092C\x0939\x0941"          (loVerdicts lopa)  -- बहु
      nRiktam   = verdictCount "\x0930\x093F\x0915\x094D\x0924\x092E\x094D" (loVerdicts lopa)  -- रिक्तम्
      nUndec    = verdictCount "UNDECIDED"     (loVerdicts lopa)
      decidedS  = S.fromList (loDecided lopa)
      unpriced  = [ e | e <- des, not (dProv e `S.member` decidedS) ]
  if nBahu + nRiktam + nUndec /= length des
    then Left ("JIVA CANNOT START: " ++ lopaHs ++ " verdict counts ("
               ++ show (nBahu + nRiktam + nUndec) ++ ") do not sum to its edge list ("
               ++ show (length des) ++ ").  Format drift; refusing to report.")
    else Right ()
  if length unpriced /= nUndec
    then Left ("JIVA CANNOT START: " ++ lopaHs ++ " decided-verdict provenances\
               \ leave " ++ show (length unpriced) ++ " unpriced edges but its\
               \ verdict table says " ++ show nUndec ++ ".  Format drift; refusing.")
    else Right ()
  -- ── the combined graph and the mass map ──
  let dirPrs   = [ (dA e, dB e) | e <- des ]
      combPrs  = nullPrs ++ dirPrs
      combComps = componentsOf combPrs
      combNodes = S.unions combComps
      deg      = degreeOf combPrs
      degOf n  = fromMaybe 0 (M.lookup n deg)
      -- component-joining candidates: top pairs by |C₁|·|C₂|
      topComps = take 10 combComps
      rep c    = head (sortBy (comparing (Down . degOf)) (S.toList c))
      joins    = take 5 $ sortBy (comparing (Down . fst))
        [ (S.size c1 * S.size c2, (c1, c2))
        | (i, c1) <- zip [0 :: Int ..] topComps
        , (j, c2) <- zip [0 :: Int ..] topComps, i < j ]
      -- unpriced pricing targets: top edges by deg(A)+deg(B)
      prices   = take 5 $ sortBy (comparing (Down . fst))
        [ (degOf (dA e) + degOf (dB e), e) | e <- unpriced ]
      timeComps = componentsOf dirPrs
      nPriced  = length kept + (nBahu + nRiktam)
      largest cs = if null cs then 0 else S.size (head cs)
  return $
    [ "\x2550\x2550\x2550 \x091C\x0940\x0935 \x00B7 the machine computes its own metric \x2550\x2550\x2550"
    , "(every number carries the command that makes it; a number without"
    , " a command is a memory \x2014 PRASAVA.tsv)"
    , ""
    , "\x2500\x2500 1 \x00B7 THE NULL SECTOR \x00B7 road one, the invertible edges \x2500\x2500" ]
    ++ metric "raw Setubandha edges (overcount, NEVER routed)" (length rawNull)
         (setuCmd ++ " | awk '/EVERY EDGE/{f=1;next}f' | grep -c '\x00AB'")
    ++ metric "Lopa CONTROL AUDIT survivors (declarations)" (length (loAudit lopa))
         (lopaCmd ++ " | awk '/CONTROL AUDIT/{f=1;next}f&&/^$/{exit}f&&!/^ /' | wc -l")
    ++ metric "audit-surviving edges (Setubandha \x2229 audit)" (length kept) jivaCmd
    ++ metric "nodes touched" (S.size nullNodes) jivaCmd
    ++ metric "components" (length nullComps) jivaCmd
    ++ metric "largest component" (largest nullComps) jivaCmd
    ++ [ ""
       , "\x2500\x2500 2 \x00B7 THE TIMELIKE SECTOR \x00B7 road two, the one-way edges \x2500\x2500" ]
    ++ metric "directed edges (genuine one-way)" (length des)
         (lopaCmd ++ " | awk '/EVERY GENUINE ONE-WAY EDGE/{f=1;next}f' | grep -c '\x00AB'")
    ++ metric "nodes touched" (S.size (S.unions timeComps)) jivaCmd
    ++ metric "components (undirected)" (length timeComps) jivaCmd
    ++ metric "largest component" (largest timeComps) jivaCmd
    ++ [ "  fibre verdicts (three-valued; two would be \x0926\x0941\x0930\x094D\x0928\x092F\x0903 compiled):" ]
    ++ metric "  \x092C\x0939\x0941 (memory required, fibre is the amount)" nBahu
         (lopaCmd ++ " | awk '/FIBRE VERDICTS/{f=1;next}f&&/^$/{exit}f' | grep '\x092C\x0939\x0941'")
    ++ metric "  \x0930\x093F\x0915\x094D\x0924\x092E\x094D (a target nothing reaches)" nRiktam
         (lopaCmd ++ " | awk '/FIBRE VERDICTS/{f=1;next}f&&/^$/{exit}f' | grep '\x0930\x093F\x0915\x094D\x0924\x092E\x094D'")
    ++ metric "  UNDECIDED (withheld, not guessed)" nUndec
         (lopaCmd ++ " | awk '/FIBRE VERDICTS/{f=1;next}f&&/^$/{exit}f' | grep UNDECIDED")
    ++ [ ""
       , "\x2500\x2500 3 \x00B7 THE MASS MAP \x00B7 unpriced fibres are the dark matter \x2500\x2500"
       , "  (a COUNT, not a curvature tensor: it says how many fibres are"
       , "   ungraded, not how much is lost at any of them)" ]
    ++ metric "unpriced fibres (= UNDECIDED verdicts)" (length unpriced) jivaCmd
    ++ [ ""
       , "  TOP-10 FRONTIER, by curvature-removal value \x00B7 HEURISTIC, MINE:"
       , "    join score = |C\x2081|\x00B7|C\x2082| (pairs made routable);"
       , "    price score = deg(A)+deg(B) in the combined graph (traffic gated)."
       , "    The two scales are not comparable and are not merged."
       , ""
       , "  \x00B7 five component-joining candidates (combined graph):" ]
    ++ [ "    " ++ show v ++ "  \x2248 join  [" ++ show (S.size c1) ++ " nodes @ "
           ++ rep c1 ++ "]  \x00D7  [" ++ show (S.size c2) ++ " nodes @ " ++ rep c2 ++ "]"
       | (v, (c1, c2)) <- joins ]
    ++ [ "      $ " ++ jivaCmd
       , ""
       , "  \x00B7 five unpriced directed edges to price first:" ]
    ++ [ "    " ++ show v ++ "  \x2248 price  " ++ dA e ++ "  \x27F6  " ++ dB e
           ++ "   \x00AB " ++ dProv e
       | (v, e) <- prices ]
    ++ [ "      $ " ++ jivaCmd
       , ""
       , "\x2500\x2500 4 \x00B7 RECEIPTS MINTED \x00B7 the known receipt families \x2500\x2500" ]
    ++ metric "receipt modules in the source tree" (length receipts)
         ("find formal machine punaragamana -type f \\( -name 'Lopa_TheSums*' -o -name\
          \ 'YugmaPurana*' -o -name 'SthiraBindu*' -o -name 'GoldbachSupport*' \\)\
          \ \\( -name '*.agda' -o -name '*.lean' -o -name '*.hs' \\)\
          \ -not -path '*_build*' -not -path '*.lake*' | wc -l")
    ++ [ "    " ++ f | f <- receipts ]
    ++ [ ""
       , "\x2500\x2500 5 \x00B7 THE HEARTBEAT \x00B7 diff this line between runs \x2500\x2500"
       , "  (nodes/edges/components: combined graph = audited null \x222A timelike;"
       , "   priced = audited null edges + decided verdicts; unpriced = UNDECIDED)"
       , "JIVA-HEARTBEAT nodes=" ++ show (S.size combNodes)
         ++ " edges=" ++ show (length kept + length des)
         ++ " priced=" ++ show nPriced
         ++ " unpriced=" ++ show nUndec
         ++ " components=" ++ show (length combComps)
       , "      $ ./jiva | grep JIVA-HEARTBEAT"
       ]

-- ─────────────────────────────────────────────────────────────────────────
-- 7.  main
-- ─────────────────────────────────────────────────────────────────────────

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  args <- getArgs
  let root = case args of { (r:_) -> r; [] -> "." }
  rawNull  <- setubandhaEdges root
  lopa     <- lopaReport root
  receipts <- receiptModules root
  -- everything is parsed and cross-checked BEFORE the first byte is
  -- printed: no partial report can masquerade as a whole one.
  case report rawNull lopa receipts of
    Left err   -> die err
    Right rpt  -> do
      putStr (unlines rpt)
      -- ── the beat is also an event ────────────────────────────────────
      -- Every run appends ONE afferent Aisthesis event to the journal:
      -- organ jiva, no intervention, the heartbeat as the observation.
      -- Afferent events pass the gate untouched (no act, no prediction
      -- owed); the journal is the body's time series, typed, append-only.
      case mapMaybe parseHeartbeat rpt of
        [hb] -> do
          now <- formatTime defaultTimeLocale "%Y-%m-%dT%H:%M:%SZ" <$> getCurrentTime
          _ <- appendEvent (root </> "machine" </> "aisthesis.jsonl") Aisthesis
            { aIndriya = "jiva"
            , aNaya    = "dravyarthika — the operative body, counted"
            , aVisaya  = "the combined graph: audited null ∪ timelike, with verdicts"
            , aKriya   = Nothing
            , aUpalabdhi = JObj [("heartbeat", sariraJ hb)]
            , aYogyata = "extractors run fresh, cross-checked before the first byte prints"
            , aVyapti  = "formal/, machine/, punaragamana/ under the given root"
            , aMarga   = Pratyaksa "the report itself; JIVA-HEARTBEAT line reproducible by rerun"
            , aSesa    = ["unpriced fibres remain undistinguished by count alone — see the top-10 frontier"]
            , aPurva   = Nothing
            , aBhavi   = Nothing
            , aPascat  = Just hb
            , aVailaksanya = []
            , aAgama   = "machine/Jiva_TheMachineComputesItsOwnMetric.hs, this run"
            , aKala    = now
            }
          return ()
        _ -> return ()  -- no single heartbeat, no event: never guess the body
