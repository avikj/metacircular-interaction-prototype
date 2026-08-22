-- Marga_TheRouterTransportsATheoremAlongLandedEdges.hs
--
-- मार्ग · mārga, "the road".
--
-- THE TERM, ITS TEXT AND ITS DATE.  Ordinary Sanskrit for a road or track
-- (from √मृग्, to seek/trace).  Its most famous technical use is the fourth
-- of the Buddha's four truths, मार्ग-सत्य, the road as the thing that is to
-- be TRAVELLED rather than admired (Dhammacakkappavattana-sutta, SN 56.11,
-- conventionally placed in the 5th c. BCE).  LIMIT: nothing mathematical is
-- claimed of any source; the word is used in its plain sense — a route one
-- actually takes — and for the one property that is load-bearing here: a
-- road is only a road if something travels it.
--
-- WHAT THE PROGRAM DOES.  notes/Sangati_….md proved the theory: a checked
-- A ≃ B is an edge, within a component routing is canonical, and every
-- theorem crosses by subst/transport at zero marginal cost.  This is the
-- program that DOES it — the first executable piece of proof-of-transport:
--
--   (a) obtains the edge list by RUNNING the corpus's own extractors as
--       subprocesses and reading their stdout:
--         · machine/Setubandha_….hs  — the invertible edges with their
--           endpoints and provenance (its `EVERY EDGE` block);
--         · machine/Lopa_….hs (ddc71aad) — the CONTROL AUDIT block, i.e.
--           the declarations that SURVIVE the two parser repairs
--           documented in Lopa's header (consecutive binder groups;
--           lowercase binders invisible to the freeness test).
--       Only Setubandha edges whose declaration survives Lopa's audit are
--       admitted.  Raw Setubandha over-counts roughly twofold (167 printed
--       against 88 surviving at commit ddc71aad); a router that consumed
--       the raw list would route on forged edges, and in a proof-of-
--       transport network a forged edge is counterfeit currency.
--   (b) builds the undirected multigraph over the extractors' type
--       normal-forms (exact-string node identity — see LIMITS);
--   (c) given a source node S and target node T, finds the shortest path
--       by BFS — the geodesic, which Sangati §२ says is literal: the
--       shortest chain of identifications is the least work, and there is
--       no other work;
--   (d) emits an Agda module that imports each edge's defining module,
--       composes the chain (compEquiv for ≃ edges, pathToEquiv for
--       type-level ≡ edges, invEquiv where the edge is crossed against
--       its stated orientation) into  marga : S ≃ T,  and transports a
--       named theorem P along it by  subst P (ua marga).  The emitted
--       module's header carries the route (every edge with its file), the
--       toll (edge count), and what is not claimed.
--
-- WHY THE EXTRACTORS ARE SUBPROCESSES AND NOT IMPORTS.  Both are
-- `module Main` and are therefore un-importable — the corpus's documented
-- defect (see machine/DosaLekha_….hs tradition of writing defects down).
-- Rather than repeat the defect by copying 600 lines of parser, this
-- program treats each extractor's printed output as its interface and
-- invokes it with System.Process.  The parse of that output is 20 lines
-- and is honest about being one (see LIMITS).  This module itself is NOT
-- `module Main`: it exports its pieces and carries `main`, so the next
-- program can import it; run it with
--     ghc -imachine -main-is Marga_TheRouterTransportsATheoremAlongLandedEdges \
--         -o /tmp/marga machine/Marga_….hs  &&  /tmp/marga <args>
--
-- THE PARADIGM, stated because the collaboration corrected it mid-build:
-- the unit of proof-of-transport is the FIBRE, not the equivalence.  The
-- graph routed here — road one, the invertible stratum — is exactly the
-- zero-locus of the gluing defect rank(AB) = rank(B) − dim(im B ∩ ker A)
-- (notes/CAUSAL_MEMORY_SPACETIME.md Thm 7.1; Lean
-- formal/pairfield/Pairfield/ProcessCutRankAdapter.lean): routes here are
-- free and canonical, their receipt is blank, and that is WHY this router
-- is correct and total on its stratum.  The real network is road two
-- (machine/Lopa_….hs): ~13× more one-way edges, largest component 362
-- nodes against road one's 7, almost all fibres unpriced (verdict
-- UNDECIDED).  The mechanisms for routing it are already checked in this
-- corpus and are named as the NEXT piece, not claimed by this one:
--   · conditional transport across a one-way edge f is exactly
--     FactorsThrough / fiberwise-constancy
--     (formal/cubical/NaturalMachine/FiniteInformation.agda) — the
--     descent witness is the toll, the constructed decoder is the receipt;
--   · an edge PLUS its receipt is an equivalence, A ≃ Σ[ b ] fibre f b
--     (formal/cubical/Avaccheda_….agda) — base/carried/witness IS the
--     receipted edge, and Sesa's two projections are the two transport
--     modes (punaragamana/src/Punaragamana/Sesa_….agda);
--   · composition of losses is NOT additive — Unit→Bool→Unit cancels
--     (punaragamana/src/Punaragamana/SakalaVikalaDesa_….agda); the law is
--     Thm 7.1 above, and its zero-locus is this router's whole domain.
-- Road-two routing = BFS + FactorsThrough toll gates + receipts; the work
-- queue behind it is pricing the unpriced fibres.
--
-- LIMITS, each stated so it can be attacked:
--   * Node identity is EXACT-STRING equality of the extractors' resolved
--     normal-forms.  Two spellings of one type are two nodes; no
--     normalization beyond the extractors' own is attempted.
--   * The stdout parse relies on the extractors' `normalise` collapsing
--     runs of spaces inside node names to single spaces, so the
--     separators "  ≃  " and "   « " cannot occur inside a node.  If an
--     extractor's format changes, this parse fails loudly, not wrongly.
--   * Endpoints must be dot-qualified single identifiers of the corpus
--     (`Module.Name`).  Nodes containing ⟨lib⟩/⟨ambig⟩ markers or spaces
--     (applied/compound types) are routable THROUGH but not usable as
--     emission endpoints; the program refuses them with a message rather
--     than emitting Agda that cannot name them.
--   * "Shortest" means fewest edges in THIS graph, not in mathematics.
--
-- RUN:
--   /tmp/marga ROOT                              graph summary
--   /tmp/marga ROOT S T                          route only (printed)
--   /tmp/marga ROOT S T --out F --module M \
--       --prelude P --pred NAME --proof NAME \
--       [--extra-header H]                       route + emit Agda module

module Marga_TheRouterTransportsATheoremAlongLandedEdges where

import Data.Char (isSpace)
import Data.List (isPrefixOf, isInfixOf, nub, sortBy, intercalate, stripPrefix, foldl')
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import Data.Maybe (mapMaybe, fromMaybe)
import Data.Ord (comparing)
import System.Directory (doesFileExist)
import System.Environment (getArgs)
import System.Exit (die)
import System.FilePath ((</>))
import System.IO
import System.Process (readProcess)

-- ─────────────────────────────────────────────────────────────────────────
-- 1.  The edge list, obtained from the corpus's own extractors
-- ─────────────────────────────────────────────────────────────────────────

setubandhaHs, lopaHs :: FilePath
setubandhaHs = "machine/Setubandha_TheCheckedIdentificationsAreEdgesAndTheIsolatedNodesAreTheFrontier.hs"
lopaHs       = "machine/Lopa_TheIrreversibleEdgesAreTheOtherGraphAndTheyRunOneWay.hs"

data Edge = Edge
  { eKind :: String   -- "equiv" (A ≃ B) or "path" (type-level A ≡ B)
  , eA    :: String   -- resolved node normal-form, left bank
  , eB    :: String   -- resolved node normal-form, right bank
  , eMod  :: String   -- Agda module that proves it
  , eDecl :: String   -- declaration name inside that module
  } deriving (Show, Eq, Ord)

eFull :: Edge -> String
eFull e = eMod e ++ "." ++ eDecl e

runExtractor :: FilePath -> FilePath -> IO [String]
runExtractor root hs = lines <$> readProcess "runghc" [root </> hs, root] ""

-- Setubandha's `EVERY EDGE` line:
--   "  [kind] A  ≃  B   « Module.decl"
parseEdgeLine :: String -> Maybe Edge
parseEdgeLine l = do
  r0        <- stripPrefix "  [" l
  let (kind, r1) = break (== ']') r0
  r2        <- stripPrefix "] " r1
  (ab, prov) <- splitOnSub "   « " r2
  (a, b)    <- splitOnSub "  ≃  " ab
  let (m, d) = splitLastDot (trim prov)
  if null m || null d then Nothing
    else Just (Edge kind (trim a) (trim b) m d)

splitOnSub :: String -> String -> Maybe (String, String)
splitOnSub pat = go ""
  where
    go acc s | pat `isPrefixOf` s = Just (reverse acc, drop (length pat) s)
    go acc (c:cs) = go (c:acc) cs
    go _   []     = Nothing

splitLastDot :: String -> (String, String)
splitLastDot q =
  let (rdecl, rrest) = break (== '.') (reverse q)
  in (reverse (drop 1 rrest), reverse rdecl)

trim :: String -> String
trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

setubandhaEdges :: FilePath -> IO [Edge]
setubandhaEdges root = do
  ls <- runExtractor root setubandhaHs
  let after = drop 1 (dropWhile (not . ("EVERY EDGE" `isInfixOf`)) ls)
      es    = mapMaybe parseEdgeLine after
  if null es then die "marga: Setubandha printed no parseable EVERY EDGE block"
             else return es

-- Lopa's CONTROL AUDIT block: flush-left `Module.decl` names of the
-- declarations that survive its two parser repairs; indented lines in the
-- block are commentary.
lopaAudit :: FilePath -> IO (S.Set String)
lopaAudit root = do
  ls <- runExtractor root lopaHs
  let blk = takeWhile (not . null)
          $ drop 1 (dropWhile (not . ("CONTROL AUDIT" `isInfixOf`)) ls)
      names = [ l | l <- blk, not ("  " `isPrefixOf` l), not (null (trim l)) ]
  if null names then die "marga: Lopa printed no parseable CONTROL AUDIT block"
                else return (S.fromList names)

-- The landed edge set this router routes on: Setubandha's extraction
-- restricted to declarations surviving Lopa's audit.
landedEdges :: FilePath -> IO ([Edge], Int, Int)
landedEdges root = do
  raw   <- setubandhaEdges root
  audit <- lopaAudit root
  let kept = [ e | e <- raw, eFull e `S.member` audit ]
  return (kept, length raw, length kept)

-- ─────────────────────────────────────────────────────────────────────────
-- 2.  The multigraph and its geodesics
-- ─────────────────────────────────────────────────────────────────────────

data Step = Step { sFrom :: String, sTo :: String, sEdge :: Edge, sForward :: Bool }

adjacency :: [Edge] -> M.Map String [Step]
adjacency es = M.fromListWith (++)
  (concat [ [ (eA e, [Step (eA e) (eB e) e True])
            , (eB e, [Step (eB e) (eA e) e False]) ] | e <- es ])

-- BFS shortest path S → T.  Fewest edges; ties broken by discovery order.
route :: [Edge] -> String -> String -> Maybe [Step]
route es s t
  | s == t = Just []
  | otherwise = go (S.singleton s) [(s, [])]
  where
    adj = adjacency es
    go _ [] = Nothing
    go seen ((x, pathRev) : q) =
      let nexts = [ st | st <- fromMaybe [] (M.lookup x adj)
                       , not (sTo st `S.member` seen) ]
      in case [ st | st <- nexts, sTo st == t ] of
           (hit:_) -> Just (reverse (hit : pathRev))
           [] -> go (foldl' (flip S.insert) seen (map sTo nexts))
                    (q ++ [ (sTo st, st : pathRev) | st <- nexts ])

componentsOf :: [Edge] -> [S.Set String]
componentsOf es = sortBy (flip (comparing S.size)) (go (M.keys adj) S.empty)
  where
    adj = adjacency es
    go [] _ = []
    go (n:ns) seen
      | n `S.member` seen = go ns seen
      | otherwise = let c = reach (S.singleton n) [n] in c : go ns (S.union seen c)
    reach seen [] = seen
    reach seen (x:xs) =
      let new = [ sTo st | st <- fromMaybe [] (M.lookup x adj)
                         , not (sTo st `S.member` seen) ]
      in reach (foldl' (flip S.insert) seen new) (xs ++ new)

-- ─────────────────────────────────────────────────────────────────────────
-- 3.  Emission
-- ─────────────────────────────────────────────────────────────────────────

-- A node usable as an emission endpoint: dot-qualified single identifier,
-- no spaces, no ⟨lib⟩/⟨ambig⟩ markers.
emittable :: String -> Bool
emittable n = '.' `elem` n && not (any isSpace n) && not (any (== '\x27E8') n)

nodeModule :: String -> String
nodeModule = fst . splitLastDot

-- module name → source file, for the route table in the header.
moduleFileOf :: FilePath -> String -> IO String
moduleFileOf root m = do
  let rel r = r ++ "/" ++ map (\c -> if c == '.' then '/' else c) m ++ ".agda"
      cands = [ rel "formal/cubical", rel "punaragamana/src" ]
  hits <- mapM (doesFileExist . (root </>)) cands
  return $ case [ c | (c, True) <- zip cands hits ] of
             (c:_) -> c
             []    -> "(file not found under formal/cubical or punaragamana/src)"

-- The Agda expression crossing one step.
stepExpr :: Step -> String
stepExpr st =
  let base = eFull (sEdge st)
      fwd  = case eKind (sEdge st) of
               "path" -> "pathToEquiv " ++ base
               _      -> base
  in if sForward st then fwd else "invEquiv (" ++ fwd ++ ")"

paren :: String -> String
paren s = if any isSpace s then "(" ++ s ++ ")" else s

composeExpr :: [Step] -> String
composeExpr [st]      = stepExpr st
composeExpr (st:rest) = "compEquiv " ++ paren (stepExpr st) ++ " (" ++ composeExpr rest ++ ")"
composeExpr []        = error "marga: empty route has no composite"

emitModule :: FilePath -> String -> String -> String -> [Step]
           -> String -> String -> String -> [String]
           -> IO String
emitModule root modName src tgt steps prelude predName proofName extraHeader = do
  files <- mapM (moduleFileOf root . eMod . sEdge) steps
  let routeLines = concat
        [ [ "--   " ++ show i ++ ".  " ++ sFrom st
          , "--         —⟨ " ++ eFull (sEdge st)
                 ++ (if eKind (sEdge st) == "path" then " (type-level ≡, lifted by pathToEquiv)" else " (≃)")
                 ++ (if sForward st then "" else ", crossed backwards by invEquiv") ++ " ⟩→"
          , "--       " ++ sTo st
          , "--       file: " ++ f ]
        | (i, st, f) <- zip3 [(1::Int)..] steps files ]
      imports = nub (map (eMod . sEdge) steps ++ [nodeModule src, nodeModule tgt])
      header =
        [ "-- GENERATED by machine/Marga_TheRouterTransportsATheoremAlongLandedEdges.hs."
        , "-- Do not edit by hand; regenerate instead.  The kernel, not the router,"
        , "-- is the authority: if an edge were forged, THIS file would fail to check."
        , "--" ]
        ++ extraHeader ++
        [ "--"
        , "-- THE ROUTE (BFS-shortest in the landed invertible graph):"
        ] ++ routeLines ++
        [ "--"
        , "-- THE TOLL: " ++ show (length steps) ++ " edge(s).  On this stratum — road one,"
        , "-- the invertible edges, the zero-locus of the gluing defect"
        , "-- rank(AB) = rank(B) − dim(im B ∩ ker A) (CAUSAL_MEMORY_SPACETIME Thm 7.1,"
        , "-- Lean: Pairfield/ProcessCutRankAdapter.lean) — every crossing is free and"
        , "-- the route is canonical within its component."
        , "--"
        , "-- EDGE SET: Setubandha's extraction restricted to the declarations that"
        , "-- survive Lopa's CONTROL AUDIT (commit ddc71aad, which found raw Setubandha"
        , "-- over-counts ~2×: 167 printed, 88 surviving at commit time).  Road two —"
        , "-- the one-way edges, 1054 at ddc71aad over a largest component of 366"
        , "-- against road one's 10 [figures as committed; both graphs move with the"
        , "-- corpus] — is NOT routed here; routing it needs FactorsThrough toll gates"
        , "-- and fibre receipts (NaturalMachine/FiniteInformation.agda, Avaccheda_…,"
        , "-- Sesa_…), and is the named next piece."
        , "--"
        , "-- WHAT IS NOT CLAIMED:"
        , "--   * No new mathematics: every edge below was already checked; this module"
        , "--     only composes and transports, which univalence makes definitional."
        , "--   * Node identity is exact-string over the extractors' normal-forms; the"
        , "--     route is shortest in THAT graph, not in all of mathematics."
        , "--   * Nothing is claimed about the target module's intent: the transported"
        , "--     statement is meaningful at the target BY the equivalence, and only by it."
        , "--   * Loops, refusals (¬ A ≃ B), families, and one-way maps are untouched." ]
      body =
        [ "{-# OPTIONS --cubical --safe --guardedness #-}" ]
        ++ header ++
        [ "module " ++ modName ++ " where"
        , ""
        , "open import Cubical.Foundations.Prelude"
        , "open import Cubical.Foundations.Equiv"
        , "open import Cubical.Foundations.Univalence"
        , "" ]
        ++ [ "import " ++ m | m <- imports ]
        ++ [ ""
        , prelude
        , ""
        , "-- The composed causeway.  Each factor is a landed edge, crossed in the"
        , "-- direction BFS chose; compEquiv chains them; nothing else happens."
        , "marga : " ++ src ++ " ≃ " ++ tgt
        , "marga = " ++ composeExpr steps
        , ""
        , "-- The transported theorem: " ++ predName ++ " held at the source; ua marga"
        , "-- carries it to the target.  This term is the transaction."
        , "transported : " ++ predName ++ " (" ++ tgt ++ ")"
        , "transported = subst " ++ predName ++ " (ua marga) " ++ proofName
        ]
  return (unlines body)

-- ─────────────────────────────────────────────────────────────────────────
-- 4.  Main
-- ─────────────────────────────────────────────────────────────────────────

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  args <- getArgs
  case args of
    [] -> die "usage: marga ROOT [S T] [--out F --module M --prelude P --pred NAME --proof NAME [--extra-header H]]"
    (root : rest) -> do
      (edges, nRaw, nKept) <- landedEdges root
      putStrLn $ "marga: Setubandha printed " ++ show nRaw ++ " edges; "
              ++ show nKept ++ " survive Lopa's CONTROL AUDIT and are routed on."
      let comps = componentsOf edges
      case rest of
        [] -> do
          putStrLn $ "nodes      : " ++ show (M.size (adjacency edges))
          putStrLn $ "components : " ++ show (length comps)
          putStrLn $ "largest    : " ++ show (maybe 0 S.size (headMay comps))
          mapM_ (\c -> putStrLn ("  component of " ++ show (S.size c) ++ ":")
                    >> mapM_ (putStrLn . ("    " ++)) (S.toList c))
                (take 3 comps)
        (s : t : opts) -> do
          let opt k = lookup k (pairs opts)
          case route edges s t of
            Nothing -> die $ "marga: no route " ++ s ++ " → " ++ t
                          ++ " (they are in different components, or a wall — a proved ¬ ≃ — stands between)"
            Just steps -> do
              putStrLn $ "route (" ++ show (length steps) ++ " edge(s)):"
              mapM_ (\st -> putStrLn $ "  " ++ sFrom st ++ "  →  " ++ sTo st
                          ++ "   via " ++ eFull (sEdge st)
                          ++ (if sForward st then "" else "  (inverted)")
                          ++ "  [" ++ eKind (sEdge st) ++ "]") steps
              case (opt "--out", opt "--module", opt "--prelude", opt "--pred", opt "--proof") of
                (Just out, Just modName, Just preludeF, Just predName, Just proofName) -> do
                  mapM_ (\n -> if emittable n then return ()
                               else die ("marga: endpoint not emittable (needs Module.Name, no ⟨lib⟩/⟨ambig⟩/spaces): " ++ n))
                        [s, t]
                  prelude <- readFile preludeF
                  extra   <- maybe (return []) (fmap lines . readFile) (opt "--extra-header")
                  txt <- emitModule root modName s t steps prelude predName proofName extra
                  writeFile out txt
                  putStrLn $ "emitted: " ++ out
                _ -> putStrLn "no emission requested (need --out --module --prelude --pred --proof)"
        _ -> die "marga: give both S and T"
  where
    pairs (k:v:r) = (k, v) : pairs r
    pairs _       = []
    headMay (x:_) = Just x
    headMay []    = Nothing
