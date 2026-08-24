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

{-# LANGUAGE BangPatterns #-}

------------------------------------------------------------------------
-- SelfArchitecture: Delta 28 applied by the machine to itself.
--
-- notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md §46 says the
-- architecture planner is itself a DSO instance; §20–25 define the width
-- hierarchy it must plan against.  This program instantiates both on the
-- machine's own dependency graph: the import DAG of formal/cubical/.
--
-- WHAT IS COMPUTED (all of it exact; no floating point, no fitting):
--
--  1. The dependency DAG, read off the .agda sources themselves
--     (`open import M` / `import M`, comments stripped with proper
--     nesting, restricted to modules that live in the tree).  Edge
--     v -> d means "module v imports module d"; a checking order is a
--     topological order with dependencies first.
--
--  2. For each candidate tree decomposition — each checking order o
--     induces the path decomposition whose i-th cut separates the
--     checked prefix P_i from the unchecked suffix U_i — and each cut i:
--
--       separator   S_i   = { s ∈ P_i | some u ∈ U_i imports s directly }
--       cut matrix  K_i   : S_i × U_i → Bool,
--                   K_i(s,u) = true iff u transitively imports s
--                   (the REACHABILITY cut matrix, Boolean carrier)
--       raw width       = |S_i|          (separator states, the
--                                          calibration's "4")
--       deterministic
--       semantic width  = #distinct rows of K_i
--                                         (future-behavior classes, the
--                                          calibration's "3"; Delta 28
--                                          §16–17, weighted Myhill–Nerode
--                                          at Boolean weights)
--
--     Both are counted exactly, by kernel-style enumeration over bitset
--     rows — the same convention as formal/cubical/DSOCutCalibration.agda,
--     where raw = 4 carrier states and deterministic = 3 distinct rows.
--     The latent width r_e (min-plus/Boolean factor rank) is NOT computed:
--     minimum rectangle cover is NP-hard and a heuristic cover is exactly
--     what CLAUDE.md forbids presenting as a result.  d_e is an exact
--     upper bound for it (Thm 28.7: r ≤ d ≤ raw).
--
--  3. Candidate orders evaluated (each exact once fixed; the *choice*
--     of candidates is where any heuristic lives, and it is labelled):
--       alphabetical-kahn : ready-first, alphabetical tie-break
--       everything-dfs    : DFS postorder from Everything.agda in
--                           source import order, then remaining roots —
--                           i.e. the order `agda Everything.agda`
--                           actually materializes interfaces
--       by-depth          : stratified by longest dependency chain
--       greedy-min-raw    : myopic minimization of next raw width
--       greedy-min-det    : myopic minimization of next deterministic
--                           semantic width — the one-step (myopic)
--                           policy of the §46 meta-Bellman
--                           V(D) = min_a (K(D,a,D') + V(D'))
--
--     The emitted "optimal" order is optimal AMONG THESE CANDIDATES
--     (its per-cut widths are exact); global optimality over all
--     topological orders is NOT claimed — minimizing peak separator
--     width over linear arrangements is NP-hard in general, and an
--     exact branch-and-bound on this specific 385-vertex instance is a
--     queued item, not this program.
--
--  4. One order-independent exact fact, checked here rather than
--     assumed: every topological order ends at a module with no
--     dependents, and at the cut just before that final module m the
--     separator is exactly m's direct import set while EVERY row of the
--     cut matrix equals {m} — raw width |imports(m)|, deterministic
--     semantic width 1.  For the aggregate build (Everything.agda last)
--     this is the §23 "aggregate dependence" collapse in its purest
--     form, and no choice of order avoids paying |imports(m)| raw for a
--     cut whose semantic content is a single mode.
--
-- OUTPUT
--   machine/self_architecture.tsv     per-cut exact widths of the best
--                                     candidate order (+ '#' header with
--                                     the candidate summary table)
--   stdout                            summary + collapse-point analysis
--                                     (quoted by notes/MACHINE_SELF_ARCHITECTURE.md)
--
-- Build:  ghc -O2 SelfArchitecture.hs
-- Run:    ./SelfArchitecture [path-to-formal/cubical] [output.tsv] [include-list]
--         defaults: formal/cubical  machine/self_architecture.tsv  (whole tree)
--         include-list: optional file of relative .agda paths, one per
--         line (e.g. `git ls-files` output), pinning the analysis to a
--         reproducible snapshot when the shared checkout has in-flight
--         untracked files from concurrent sessions.
------------------------------------------------------------------------

module Main (main) where

import Control.Monad (forM, forM_, unless)
import Data.Array
import Data.Bits
import Data.List (foldl', intercalate, isSuffixOf, minimumBy, sort, sortBy)
import qualified Data.Map.Strict as M
import Data.Ord (comparing)
import qualified Data.Set as S
import GHC.IO.Encoding (setLocaleEncoding, utf8)
import System.Directory (doesDirectoryExist, listDirectory)
import System.Environment (getArgs)
import System.FilePath ((</>))
import System.IO

------------------------------------------------------------------------
-- Source discovery and exact import extraction

listAgdaFiles :: FilePath -> FilePath -> IO [FilePath]
listAgdaFiles root rel = do
  let dir = if null rel then root else root </> rel
  entries <- listDirectory dir
  fmap concat . forM (sort entries) $ \e -> do
    let relE = if null rel then e else rel </> e
    isDir <- doesDirectoryExist (root </> relE)
    if isDir
      then if e == "_build" || take 1 e == "."
             then pure []
             else listAgdaFiles root relE
      else pure [relE | ".agda" `isSuffixOf` e]

moduleName :: FilePath -> String
moduleName rel = map slash (take (length rel - length ".agda") rel)
  where slash '/' = '.'
        slash c   = c

-- Strip Agda comments exactly: nested {- -} blocks (pragmas {-# #-} are
-- swallowed too, harmlessly — no import lives inside one) and -- line
-- comments at depth 0.
stripComments :: String -> String
stripComments = go (0 :: Int)
  where
    go _ [] = []
    go 0 ('{':'-':rest) = go 1 rest
    go 0 ('-':'-':rest) = go 0 (dropWhile (/= '\n') rest)
    go 0 (c:rest)       = c : go 0 rest
    go d ('{':'-':rest) = go (d + 1) rest
    go d ('-':'}':rest) = go (d - 1) rest
    go d (_:rest)       = go d rest

-- Every token that follows the token "import", in source order.
importTargets :: String -> [String]
importTargets src = [ m | ("import", m) <- zip ts (drop 1 ts) ]
  where ts = words (stripComments src)

dedupKeepOrder :: Ord a => [a] -> [a]
dedupKeepOrder = go S.empty
  where go _ [] = []
        go seen (x:xs)
          | S.member x seen = go seen xs
          | otherwise       = x : go (S.insert x seen) xs

------------------------------------------------------------------------
-- Bitset helpers (Integer as an exact bitset over vertex indices)

bitsOf :: Integer -> [Int]
bitsOf = go 0
  where go _ 0 = []
        go !i m | testBit m 0 = i : go (i + 1) (shiftR m 1)
                | otherwise   =     go (i + 1) (shiftR m 1)

------------------------------------------------------------------------
-- The graph, closed exactly

data Graph = Graph
  { gN        :: Int
  , gName     :: Array Int String
  , gDeps     :: Array Int [Int]      -- direct imports, source order
  , gDepsMask :: Array Int Integer
  , gDD       :: Array Int Integer    -- direct dependents of each vertex
  , gReach    :: Array Int Integer    -- transitive imports of each vertex
  , gCoreach  :: Array Int Integer    -- transitive dependents of each vertex
  }

buildGraph :: [(String, [String])] -> Graph
buildGraph pairs = Graph n nameA depsA depsMaskA ddA reachA coreachA
  where
    mods  = sort (map fst pairs)
    n     = length mods
    ix    = M.fromList (zip mods [0 ..])
    depM  = M.fromList pairs
    nameA = listArray (0, n - 1) mods
    depsA = listArray (0, n - 1)
              [ map (ix M.!) (depM M.! m) | m <- mods ]
    depsMaskA = listArray (0, n - 1)
              [ foldl' setBit 0 (depsA ! v) | v <- [0 .. n - 1] ]
    ddA = accumArray (.|.) 0 (0, n - 1)
              [ (d, bit v) | v <- [0 .. n - 1], d <- depsA ! v ]
    -- lazy self-reference is well-founded exactly because the graph is
    -- a DAG (checked in main before any width is trusted)
    reachA = listArray (0, n - 1)
              [ foldl' (\acc d -> acc .|. bit d .|. reachA ! d) 0 (depsA ! v)
              | v <- [0 .. n - 1] ]
    coreachA = accumArray (.|.) 0 (0, n - 1)
              [ (d, bit v) | v <- [0 .. n - 1], d <- bitsOf (reachA ! v) ]

-- Kahn count: n iff acyclic.
acyclic :: Graph -> Bool
acyclic g = go 0 (foldl' setBit 0 [0 .. gN g - 1]) 0
  where
    go !done !remaining !pMask
      | remaining == 0 = done == gN g
      | otherwise =
          case [ v | v <- bitsOf remaining
                   , gDepsMask g ! v .&. complement pMask == 0 ] of
            []    -> False
            ready -> go (done + length ready)
                        (foldl' clearBit remaining ready)
                        (foldl' setBit pMask ready)

------------------------------------------------------------------------
-- Exact width evaluation of one checking order

data Cut = Cut
  { cutStep :: Int      -- 1-based: cut AFTER checking this many modules
  , cutMod  :: Int      -- the module checked at this step
  , cutRaw  :: Int      -- |S_i|
  , cutDet  :: Int      -- distinct rows of the reachability cut matrix
  } deriving Show

separatorAt :: Graph -> [Int] -> Integer -> [Int]
separatorAt g processed uMask =
  [ s | s <- processed, gDD g ! s .&. uMask /= 0 ]

detWidthAt :: Graph -> [Int] -> Integer -> Int
detWidthAt g sep uMask =
  S.size (S.fromList [ gCoreach g ! s .&. uMask | s <- sep ])

evalOrder :: Graph -> [Int] -> [Cut]
evalOrder g order
  | length order /= gN g = error "evalOrder: order does not cover the graph"
  | otherwise            = go 1 [] 0 fullMask order
  where
    fullMask = bit (gN g) - 1
    go _ _ _ _ [] = []
    go !i procRev !pMask !uMask (v:rest)
      | gDepsMask g ! v .&. complement pMask /= 0 =
          error ("evalOrder: not topological at " ++ (gName g ! v))
      | otherwise =
          let uMask' = clearBit uMask v
              proc'  = v : procRev
              sep    = separatorAt g proc' uMask'
              raw    = length sep
              det    = detWidthAt g sep uMask'
          in Cut i v raw det : go (i + 1) proc' (setBit pMask v) uMask' rest

------------------------------------------------------------------------
-- Candidate orders

-- Greedy over the ready set with an exact key; the key defines the
-- candidate, the widths later reported are recomputed exactly.
greedyOrder :: Graph -> (Integer -> [Int] -> Int -> (Int, Int, String)) -> [Int]
greedyOrder g key = go [] 0 fullMask
  where
    n        = gN g
    fullMask = bit n - 1
    go procRev !pMask !uMask
      | uMask == 0 = reverse procRev
      | otherwise  =
          let ready = [ v | v <- bitsOf uMask
                          , gDepsMask g ! v .&. complement pMask == 0 ]
              v     = snd (minimumBy (comparing fst)
                        [ (key uMask procRev c, c) | c <- ready ])
          in go (v : procRev) (setBit pMask v) (clearBit uMask v)

keyAlpha :: Graph -> Integer -> [Int] -> Int -> (Int, Int, String)
keyAlpha g _ _ v = (0, 0, gName g ! v)

keyMinRaw :: Graph -> Integer -> [Int] -> Int -> (Int, Int, String)
keyMinRaw g uMask procRev v =
  let uMask' = clearBit uMask v
      raw    = length (separatorAt g (v : procRev) uMask')
  in (raw, 0, gName g ! v)

keyMinDet :: Graph -> Integer -> [Int] -> Int -> (Int, Int, String)
keyMinDet g uMask procRev v =
  let uMask' = clearBit uMask v
      sep    = separatorAt g (v : procRev) uMask'
      det    = detWidthAt g sep uMask'
  in (det, length sep, gName g ! v)

-- DFS postorder from given roots, imports visited in source order.
dfsPost :: Graph -> [Int] -> [Int]
dfsPost g roots = reverse accFinal
  where
    (_, accFinal) = foldl' visit (S.empty, []) roots
    visit st@(seen, _) v
      | S.member v seen = st
      | otherwise =
          let (seen', acc') = foldl' visit (S.insert v seen, snd st)
                                           (gDeps g ! v)
          in (seen', v : acc')

-- longest dependency chain below v (leaves at 0)
levels :: Graph -> Array Int Int
levels g = lv
  where
    lv = listArray (0, gN g - 1)
           [ case gDeps g ! v of
               [] -> 0
               ds -> 1 + maximum (map (lv !) ds)
           | v <- [0 .. gN g - 1] ]

------------------------------------------------------------------------
-- Reporting

data Summary = Summary
  { sName     :: String
  , sPeakRaw  :: Int
  , sPeakRawAt :: (Int, String)
  , sPeakDet  :: Int
  , sPeakDetAt :: (Int, String)
  , sSumRaw   :: Integer
  , sSumDet   :: Integer
  }

summarize :: Graph -> String -> [Cut] -> Summary
summarize g nm cuts = Summary
  { sName      = nm
  , sPeakRaw   = cutRaw pr
  , sPeakRawAt = (cutStep pr, gName g ! cutMod pr)
  , sPeakDet   = cutDet pd
  , sPeakDetAt = (cutStep pd, gName g ! cutMod pd)
  , sSumRaw    = sum (map (fromIntegral . cutRaw) cuts)
  , sSumDet    = sum (map (fromIntegral . cutDet) cuts)
  }
  where
    pr = minimumBy (comparing (negate . cutRaw)) cuts   -- first max
    pd = minimumBy (comparing (negate . cutDet)) cuts

summaryLine :: Summary -> String
summaryLine s = intercalate "\t"
  [ sName s
  , show (sPeakRaw s)
  , show (fst (sPeakRawAt s)) ++ ":" ++ snd (sPeakRawAt s)
  , show (sPeakDet s)
  , show (fst (sPeakDetAt s)) ++ ":" ++ snd (sPeakDetAt s)
  , show (sSumRaw s)
  , show (sSumDet s)
  ]

-- Row classes of the cut matrix at a given cut: groups of separator
-- modules with an identical future-behavior row.
rowClasses :: Graph -> [Int] -> Integer -> [(Integer, [Int])]
rowClasses g sep uMask =
  M.toList (M.fromListWith (++)
    [ (gCoreach g ! s .&. uMask, [s]) | s <- sep ])

showClass :: Graph -> (Integer, [Int]) -> String
showClass g (row, members) =
  "    class of " ++ show (length members)
    ++ " separator module(s) " ++ preview (sort (map (gName g !) members))
    ++ " with identical future row = " ++ show (popCount row)
    ++ " unchecked dependent(s) " ++ preview (map (gName g !) (bitsOf row))
  where
    preview xs | length xs <= 5 = show xs
               | otherwise      = show (take 5 xs) ++ "+" ++ show (length xs - 5)

describeCut :: Graph -> [Int] -> Cut -> [String]
describeCut g order c =
  let k      = cutStep c
      prefix = take k order
      uMask  = foldl' clearBit (bit (gN g) - 1) prefix
      sep    = separatorAt g (reverse prefix) uMask
      cls    = sortBy (comparing (negate . length . snd)) (rowClasses g sep uMask)
  in ("  cut " ++ show k ++ " (after checking " ++ (gName g ! cutMod c)
        ++ "): raw " ++ show (cutRaw c) ++ ", deterministic semantic "
        ++ show (cutDet c) ++ ", collapse " ++ show (cutRaw c - cutDet c))
     : map (showClass g) (take 6 cls)

------------------------------------------------------------------------

main :: IO ()
main = do
  setLocaleEncoding utf8
  hSetEncoding stdout utf8
  args <- getArgs
  let root   = case args of (r:_) -> r; _ -> "formal/cubical"
      tsvOut = case args of (_:t:_) -> t; _ -> "machine/self_architecture.tsv"

  allFiles <- listAgdaFiles root ""
  files <- case args of
    (_:_:inc:_) -> do
      wanted <- (S.fromList . filter (not . null) . lines) <$> readFile inc
      pure [ f | f <- allFiles, S.member f wanted ]
    _ -> pure allFiles
  let known = S.fromList (map moduleName files)
  pairs <- forM files $ \f -> do
    let m = moduleName f
    src <- readFile (root </> f)
    length src `seq` pure
      ( m
      , dedupKeepOrder
          [ t | t <- importTargets src, S.member t known, t /= m ] )

  let g      = buildGraph pairs
      n      = gN g
      nEdges = sum (map (length . snd) pairs)
  unless (acyclic g) (error "import graph is not a DAG")

  putStrLn ("modules\t" ++ show n)
  putStrLn ("internal-import-edges\t" ++ show nEdges)

  -- order-independent exact fact: terminal cuts
  let sinks = [ v | v <- [0 .. n - 1], gDD g ! v == 0 ]
  putStrLn ("modules-with-no-dependents\t" ++ show (length sinks))
  forM_ sinks $ \v ->
    putStrLn ("  sink\t" ++ gName g ! v
              ++ "\tdirect-imports " ++ show (length (gDeps g ! v))
              ++ "\ttransitive-imports " ++ show (popCount (gReach g ! v)))
  putStrLn ("terminal-cut-fact\tany topological order ends at a sink m; "
            ++ "the cut before m has raw width = |direct imports of m| "
            ++ "and deterministic semantic width = 1 (every row = {m})")

  -- candidates
  let lv = levels g
      everythingIx = M.lookup "Everything" (M.fromList (zip (elems (gName g)) [0..]))
      evRoots = case everythingIx of
                  Just e  -> e : [ v | v <- [0 .. n - 1], v /= e ]
                  Nothing -> [0 .. n - 1]
      candidates =
        [ ("alphabetical-kahn", greedyOrder g (keyAlpha g))
        , ("everything-dfs",    dfsPost g evRoots)
        , ("by-depth",          sortBy (comparing (\v -> (lv ! v, gName g ! v)))
                                       [0 .. n - 1])
        , ("greedy-min-raw",    greedyOrder g (keyMinRaw g))
        , ("greedy-min-det",    greedyOrder g (keyMinDet g))
        ]
      evaluated = [ (nm, ord, evalOrder g ord) | (nm, ord) <- candidates ]
      summaries = [ summarize g nm cuts | (nm, _, cuts) <- evaluated ]

  putStrLn ""
  putStrLn ("candidate\tpeak-raw\tpeak-raw-at\tpeak-det\tpeak-det-at"
            ++ "\tsum-raw\tsum-det")
  mapM_ (putStrLn . summaryLine) summaries

  -- best candidate: exact widths, optimal among candidates only
  let best@(bestNm, bestOrd, bestCuts) =
        minimumBy (comparing (\(nm, _, cuts) ->
          ( maximum (map cutDet cuts)
          , maximum (map cutRaw cuts)
          , sum (map cutDet cuts)
          , nm )))
          evaluated
      _ = best

  putStrLn ""
  putStrLn ("best-candidate\t" ++ bestNm
            ++ "\t(optimal among the candidates above; global optimality "
            ++ "over all topological orders is not claimed)")

  -- collapse points of the best order: cuts with the largest raw - det
  let byCollapse = sortBy
        (comparing (\c -> (negate (cutRaw c - cutDet c), cutStep c))) bestCuts
      top = take 4 [ c | c <- byCollapse, cutRaw c - cutDet c > 0 ]
  putStrLn ""
  putStrLn "largest collapse points (raw - deterministic) of best order:"
  forM_ top $ \c -> mapM_ putStrLn (describeCut g bestOrd c)

  -- peak cuts of every candidate: where each order is widest, raw and
  -- semantic, and how the cut matrix factors there
  putStrLn ""
  putStrLn "peak cuts per candidate:"
  forM_ evaluated $ \(nm, ord, cuts) -> do
    let pr = minimumBy (comparing (negate . cutRaw)) cuts
        pd = minimumBy (comparing (negate . cutDet)) cuts
        collapsed = length [ c | c <- cuts, cutDet c < cutRaw c ]
    putStrLn (nm ++ ": " ++ show collapsed ++ " of " ++ show (length cuts)
              ++ " cuts have det < raw")
    putStrLn (nm ++ " peak-raw cut:")
    mapM_ putStrLn (describeCut g ord pr)
    putStrLn (nm ++ " peak-det cut:")
    mapM_ putStrLn (describeCut g ord pd)

  -- also describe the aggregate (pre-Everything) cut of everything-dfs
  case [ (nm, ord, cuts) | (nm, ord, cuts) <- evaluated, nm == "everything-dfs" ] of
    ((_, ord, cuts):_) ->
      case everythingIx of
        Just e -> do
          let pre = [ c | c <- cuts
                        , cutStep c + 1 <= length ord
                        , ord !! cutStep c == e ]   -- cut just before Everything
          putStrLn ""
          putStrLn "aggregate cut of everything-dfs (just before Everything):"
          forM_ pre $ \c -> mapM_ putStrLn (describeCut g ord c)
        Nothing -> pure ()
    _ -> pure ()

  -- TSV: candidate summary as comments + per-cut widths of best order
  let header =
        [ "# machine/self_architecture.tsv — generated by machine/SelfArchitecture.hs"
        , "# Import DAG of formal/cubical: " ++ show n ++ " modules, "
            ++ show nEdges ++ " internal import edges."
        , "# Cut i separates the first i checked modules from the rest."
        , "# raw_width = |separator S_i| (modules already checked with a"
        , "#   direct unchecked importer); det_width = number of distinct"
        , "#   rows of the Boolean reachability cut matrix K_i(s,u) ="
        , "#   [u transitively imports s], s in S_i, u unchecked — the"
        , "#   deterministic semantic width of Delta 28 §16-17 (exact)."
        , "# Latent width r (factor rank) is not computed (NP-hard);"
        , "#   Thm 28.7 gives r <= det <= raw."
        , "# Candidate summary (peak-raw, peak-det, sum-raw, sum-det):"
        ] ++
        [ "#   " ++ summaryLine s | s <- summaries ] ++
        [ "# Best candidate (min peak-det, then peak-raw, then sum-det): "
            ++ bestNm
        , "# The order below is optimal among these candidates only."
        , "step\tmodule\traw_width\tdet_width\tcollapse" ]
      rows = [ intercalate "\t"
                 [ show (cutStep c), gName g ! cutMod c
                 , show (cutRaw c), show (cutDet c)
                 , show (cutRaw c - cutDet c) ]
             | c <- bestCuts ]
  withFile tsvOut WriteMode $ \h -> do
    hSetEncoding h utf8
    mapM_ (hPutStrLn h) (header ++ rows)
  putStrLn ""
  putStrLn ("wrote\t" ++ tsvOut)

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only; nothing here corrects this program.
--
-- §4's "one order-independent exact fact" is now proved for an ARBITRARY
-- import relation, in
-- `formal/cubical/NaturalMachine/TheLastCutHasOneRowWhenItsSeparatorIsInhabited.agda`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin):
--
--   everySeparatorRowIsTrue / allSeparatorRowsAgree
--       at the last cut the suffix is a single module, so a row is one
--       Boolean, and for a separator element it is forced to true.
--       Every separator row is therefore the same row.
--
--   oneRowWhenInhabited / noRowsWhenEmpty
--       hence exactly one distinct row WHEN THE SEPARATOR IS INHABITED,
--       and none when it is empty.
--
-- Two things that adds to the computed version.  It is not only
-- ORDER-independent but GRAPH-independent: the argument uses exactly one
-- property of the cut matrix -- that a direct import is reached --
-- and needs neither acyclicity nor the topological order.
--
-- And it makes explicit a hypothesis §4's sentence leaves implicit:
-- "deterministic semantic width 1" holds when the final module imports
-- something.  If it imports nothing the separator is empty and the width
-- is 0, not 1.  On this graph the hypothesis holds; as a quantified
-- statement it has to be said.  That is the difference between a
-- computed instance and a quantified claim, not a defect in the program.
--
-- NOT formalised there, and NOT claimed: the RAW half, "raw width =
-- |imports(m)|" -- a cardinality claim, and nothing in that module is
-- finite or counted.  Nor topological orders, DAGs, path
-- decompositions, other cuts, the candidate orders of §3, or the latent
-- width r_e this program explicitly declines to compute.
-- ---------------------------------------------------------------------
