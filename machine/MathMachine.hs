-- MathMachine — a mathematics engine, not a checker.
--
-- It runs on CPU, unattended, forever.  Each round it:
--
--   1. GENERATES the terms of its current vocabulary up to a size bound
--   2. NORMALIZES them with everything it has already proved
--      (this is where past knowledge pays: proved theorems are rewrite
--       operations, so vast families of terms collapse to one and are
--       never looked at again)
--   3. CONJECTURES equations between terms that agree on every random
--      instance it can throw at them
--   4. REFUTES the rest by computation (a single disagreeing instance
--      kills a conjecture; this is free and it is most of the work)
--   5. PROVES survivors by rewriting, and when rewriting is not enough,
--      by structural induction using its own earlier theorems as the
--      step's lemmas
--   6. INSTALLS each proof as a new rewrite operation, so the next
--      round is cheaper — and records by how much
--   7. GROWS: when a round yields nothing new, the vocabulary widens
--      (a new function symbol) or the size bound rises.  A machine that
--      never runs out of things to look at is one that keeps changing
--      what it is looking at.
--
-- Self-improvement here is a measured quantity, not a slogan: the
-- `pruned` percentage in the log is the fraction of the term space that
-- earlier theorems removed from consideration before any work was done.
--
-- Everything it proves is written to machine/library.txt; everything it
-- does is written to machine/machine.log.  Both are appended, never
-- rewritten.

module Main (main) where

import qualified Data.Set as S
import qualified Data.Map.Strict as M
import Data.List (sortOn, sortBy, foldl', intercalate, permutations, sort, partition)
import Data.Maybe (mapMaybe, isJust, isNothing)
import Data.IORef
import Control.Monad (forM_, replicateM_, when, unless, filterM)
import Control.Exception (finally)
import System.IO
import System.Directory (getTemporaryDirectory, removePathForcibly)
import System.FilePath ((</>))
import System.Process (readProcess, readProcessWithExitCode)
import System.Exit (ExitCode(..), exitFailure)
import System.Environment (getArgs)
import System.CPUTime (getCPUTime)
import Text.Printf (hPrintf)
import Text.ParserCombinators.ReadP
import qualified Certificate as C
import qualified TraceReplay as TR
import qualified Knobs as K
-- DISPATCH SEAM (2026-08-16).  Three modules built this session as standalone
-- programs are wired in below, each behind a knob whose DEFAULT reproduces the
-- engine that was running before this edit, bit for bit.  See `Dispatch`.
import qualified ArithVocab as AV
import qualified DSO as D
import qualified NestedInduction as NI
import Data.Char (isAlphaNum, isSpace)
import System.Directory (doesFileExist)
import System.Exit (exitSuccess)
-- (imports for the unbuilt evolve step removed; they were dead, and a
-- dead import is a claim about what a program does)

-- ===================================================================
-- KNOBS.  The machine's tunable constants, laid out so that they CAN be
-- found and rewritten in this source text.
--
-- HONEST STATUS: nothing rewrites them yet.  An earlier version of this
-- banner said "every line below is rewritten by the machine itself
-- during evolution" — that was aspiration written in the present tense,
-- which is the exact sin this repository was founded to stop.  The
-- evolve step (mutate source, compile variant, race it, exec the
-- winner) is designed and not built; the imports for it below are dead
-- until it is.  Two visiting readers caught this in the same hour.
-- ===================================================================
-- The knob values below are the DEFAULTS.  They are no longer the values
-- the engine runs on: `machine/Knobs.hs` owns the knob set, the loader
-- reads machine/knobs.conf at startup, and the live set travels in the
-- Machine record as `mKnobs`.  Each name is kept here as `<name>Default`
-- so the banner above still reads as a list of constants with their
-- provenance, and so an absent conf reproduces today's engine exactly.
kProbeDefault :: Int
kProbeDefault = 400
kAssignDefault :: Int
kAssignDefault = 40
kMinPruneDefault :: Int
kMinPruneDefault = 1
kConceptMinDefault :: Int
kConceptMinDefault = 8
-- How much shorter the probe must get before a name is worth having.
-- A fold of a pattern of size p saves p-1 symbols, and the smallest
-- admissible pattern has size 3, so one fold saves at least 2: this
-- threshold is "at least four real folds".  It is a gate on description
-- length, which is the only currency a DEFINITION can be paid in — see
-- `marginalCompress` for why the old prune-based gate could never pass.
kConceptGainDefault :: Int
kConceptGainDefault = 8
kVarsDefault :: Int
kVarsDefault = 3
kSizeCapDefault :: Int
kSizeCapDefault = 7

-- ---------------------------------------------------------------- terms

data Term = V !Int | F !String [Term] deriving (Eq, Ord)

-- Theorem Factory II, stripped to its generic computational content.  A
-- bounded ordered fibre plus a decidable predicate and an accepted coverage
-- witness determines one canonical least inhabitant.  Coverage is input
-- mathematics; search never manufactures it.
data Coverage a = Coverage !a deriving (Eq, Show)

data CoverageResidual a
  = WitnessOutsideFiber !a
  | WitnessRejected !a
  deriving (Eq, Show)

data LeastWitness a = LeastWitness
  { leastValue :: !a
  , excludedPrefix :: [a]
  } deriving (Eq, Show)

leastCovered :: Eq a => [a] -> (a -> Bool) -> Coverage a
  -> Either (CoverageResidual a) (LeastWitness a)
leastCovered fibre predicate (Coverage supplied)
  | supplied `notElem` fibre = Left (WitnessOutsideFiber supplied)
  | not (predicate supplied) = Left (WitnessRejected supplied)
  | otherwise = Right (walk [] fibre)
  where
    walk rejected (x:xs)
      | predicate x = LeastWitness x (reverse rejected)
      | otherwise = walk (x:rejected) xs
    walk _ [] = error "leastCovered: validated coverage became empty"

-- Recurrence over an unbounded fibre cannot be totalized by a finite scan.
-- The residual retains the searched prefix instead of asserting absence.
data PartialWitness a = FoundLeast (LeastWitness a) | OpenBeyond [a]
  deriving (Eq, Show)

searchPrefix :: [a] -> (a -> Bool) -> PartialWitness a
searchPrefix fibre predicate = walk [] fibre
  where
    walk rejected [] = OpenBeyond (reverse rejected)
    walk rejected (x:xs)
      | predicate x = FoundLeast (LeastWitness x (reverse rejected))
      | otherwise = walk (x:rejected) xs

-- The live search projection keeps mathematical provenance separate from the
-- operational branch set.  Installing coverage changes only `activeWitnesses`;
-- `derivationFiber` remains available to explanations and later transports.
data BoundedSearch = BoundedSearch
  { searchFiber :: [Int]
  , searchPredicate :: Int -> Bool
  , acceptedCoverage :: Maybe (Coverage Int)
  }

data SearchProjection = SearchProjection
  { activeWitnesses :: [Int]
  , derivationFiber :: [Int]
  , existenceConsequence :: Bool
  , searchResidual :: Maybe (CoverageResidual Int)
  } deriving (Eq, Show)

-- Delta 26: a finite continuation-aware route compiler.  This is not another
-- Bellman implementation: DSOBellmanFinite.agda already checks the two-route
-- counterexample.  Here a route is compiled to its observable cost vector over
-- the continuations whose dependencies are active.  Equal vectors are one
-- contextual class while all originating route labels are retained; labels are
-- identifiers, not derivations or certificates.  A class is removed only when
-- another class is pointwise no worse and strictly better somewhere.
data DSORoute = DSORoute
  { dsoWitness :: !String
  , dsoBoundary :: !Int
  , dsoLocalCost :: !Int
  } deriving (Eq, Show)

data DSOContinuation = DSOContinuation
  { dsoContext :: !String
  , dsoDependency :: !String
  , dsoFutureCost :: Int -> Int
  }

data DSOTask = DSOTask
  { dsoTaskName :: !String
  , dsoTaskDependencies :: [String]
  , dsoTaskContinuations :: [DSOContinuation]
  , dsoTaskRoutes :: [DSORoute]
  }

data DSOClass = DSOClass
  { dsoProfile :: [Int]
  , dsoWitnesses :: [String]
  } deriving (Eq, Show)

data DSOCompilation = DSOCompilation
  { dsoActiveContexts :: [String]
  , dsoClasses :: [DSOClass]
  , dsoSurvivors :: [DSOClass]
  , dsoRawEvaluations :: !Int
  , dsoActiveEvaluations :: !Int
  } deriving (Eq, Show)

data DSOArchitectureCandidate = DSOArchitectureCandidate
  { dsoArchitectureName :: !String
  , dsoArchitectureOrigin :: [String]
  , dsoArchitectureRoutes :: [DSORoute]
  , dsoArchitectureMigration :: [(String,String)]
  }

data DSOArchitectureResult = DSOArchitectureResult
  { dsoArchitectureProfiles :: [(String,[Int])]
  , dsoEquivalentArchitectures :: [(String,String,[Int])]
  , dsoParetoArchitectures :: [String]
  , dsoArchitectureCosts :: [(String,(Int,Int))]
  , dsoArchitectureRegret :: [(String,(Int,Int))]
  , dsoRetainedMigrations :: [(String,[(String,String)])]
  } deriving (Eq, Show)

compileDSO :: [String] -> [DSOContinuation] -> [DSORoute] -> DSOCompilation
compileDSO active continuations routes =
  DSOCompilation (map dsoContext live) classes survivors rawCount activeCount
  where
    live = filter (\k -> dsoDependency k `elem` active) continuations
    profile r = [dsoLocalCost r + dsoFutureCost k (dsoBoundary r) | k <- live]
    grouped = M.fromListWith (++) [(profile r, [dsoWitness r]) | r <- routes]
    classes = [DSOClass costs (reverse witnesses)
              | (costs,witnesses) <- M.toAscList grouped]
    dominates a b = and (zipWith (<=) (dsoProfile a) (dsoProfile b))
                  && or (zipWith (<) (dsoProfile a) (dsoProfile b))
    survivors = [c | c <- classes, not (any (\d -> dominates d c) classes)]
    rawCount = length routes * length continuations
    activeCount = length routes * length live

-- A contextual quotient is valid only for the continuation family that was
-- actually evaluated.  Extending that family can resurrect a route class that
-- the smaller query dominated.  Compare stable route labels after recompiling
-- from raw routes; if any label reappears, cached survivors fail closed.  This
-- is an operational guard, not proof evidence: `String` is still only an
-- identifier and `DSOCompilation` does not retain a replayable derivation.
dsoSurvivorLabels :: DSOCompilation -> [String]
dsoSurvivorLabels = ordNub . concatMap dsoWitnesses . dsoSurvivors

checkDSOQueryExtension
  :: DSOCompilation -> DSOCompilation -> Either [String] DSOCompilation
checkDSOQueryExtension old new
  | not (all (`elem` dsoActiveContexts new) (dsoActiveContexts old)) =
      Left ["not-an-extension"]
  | null resurrected = Right new
  | otherwise = Left resurrected
  where
    oldLabels = dsoSurvivorLabels old
    resurrected =
      [ label
      | label <- dsoSurvivorLabels new
      , label `notElem` oldLabels ]

-- Existing bounded-search witnesses become architecture routes without
-- losing their native values.  The declared observation is the ordered-fibre
-- objective justified by `leastCovered`: it charges the witness index itself.
-- This is a consumer of that theorem-generated fibre, not a second search.
boundedDSOTask :: String -> BoundedSearch -> DSOTask
boundedDSOTask name plan = DSOTask name ["ordered-fibre"] observations routes
  where
    projection = executeBoundedSearch plan
    routes = [DSORoute (name ++ "/" ++ show n) n 0
             | n <- derivationFiber projection]
    observations =
      [ DSOContinuation "least-witness" "ordered-fibre" id
      , DSOContinuation "parity-audit" "audit" (`mod` 2)
      ]

-- Compare whole factorizations only through their boundary continuation
-- transformers.  Cost is (materialised routes, active route/context work).
-- Pareto comparison is restricted to architectures with the same transformer;
-- a cheaper but observably different factorisation is never a replacement.
compileDSOArchitectures :: [String] -> [DSOContinuation]
  -> [DSOArchitectureCandidate] -> DSOArchitectureResult
compileDSOArchitectures active continuations candidates =
  DSOArchitectureResult profiles equivalents pareto costs regrets migrations
  where
    live = filter (\k -> dsoDependency k `elem` active) continuations
    transformer candidate =
      [ minimum [dsoLocalCost r + dsoFutureCost k (dsoBoundary r)
                | r <- dsoArchitectureRoutes candidate]
      | k <- live ]
    profiles = [(dsoArchitectureName c, transformer c) | c <- candidates]
    equivalents =
      [ (dsoArchitectureName a, dsoArchitectureName b, transformer a)
      | (i,a) <- zip [0 :: Int ..] candidates
      , b <- drop (i + 1) candidates
      , transformer a == transformer b ]
    cost c = (length (dsoArchitectureRoutes c),
              length (dsoArchitectureRoutes c) * length live)
    costs = [(dsoArchitectureName c, cost c) | c <- candidates]
    dominates a b = transformer a == transformer b
      && fst (cost a) <= fst (cost b) && snd (cost a) <= snd (cost b)
      && (fst (cost a) < fst (cost b) || snd (cost a) < snd (cost b))
    winners = [c | c <- candidates,
                   not (any (\d -> dominates d c) candidates)]
    pareto = map dsoArchitectureName winners
    winnerCost c = minimum [cost w | w <- winners,
      transformer w == transformer c]
    regrets = [(dsoArchitectureName c,
                (fst (cost c) - fst (winnerCost c),
                 snd (cost c) - snd (winnerCost c))) | c <- candidates]
    migrations = [(dsoArchitectureName c, dsoArchitectureMigration c)
                 | c <- candidates]

boundedArchitectures :: String -> BoundedSearch -> [DSOArchitectureCandidate]
boundedArchitectures name plan = [direct, compiled]
  where
    task = boundedDSOTask name plan
    routes = dsoTaskRoutes task
    projection = executeBoundedSearch plan
    leastRoutes = [DSORoute (name ++ "/least/" ++ show n) n 0
                  | n <- activeWitnesses projection]
    target = case leastRoutes of
      r:_ -> dsoWitness r
      [] -> name ++ "/unresolved"
    direct = DSOArchitectureCandidate (name ++ "/direct")
      (map dsoWitness routes) routes [(dsoWitness r, dsoWitness r) | r <- routes]
    compiled = DSOArchitectureCandidate (name ++ "/least-selector")
      (map dsoWitness routes) leastRoutes [(dsoWitness r, target) | r <- routes]

-- A squarefree divisor history adjoins each of m distinct prime factors once,
-- hence is exactly a permutation.  Checkpoints remember the accumulated set,
-- not the within-block order.  Consequently the exact residual fibre is the
-- product of factorials of the checkpoint block lengths.
data HistoryDemand = EndpointDemand | SnapshotDemand [Int] | FullDemand
  deriving (Eq, Show)

data HistoryArchitecture = HistoryArchitecture
  { historyArchitectureName :: !String
  , historyCheckpoints :: [Int]
  , historyCandidate :: DSOArchitectureCandidate
  , historyFibres :: [[String]]
  }

factorial :: Int -> Int
factorial n = product [1..n]

historyBlocks :: Int -> [Int] -> [Int]
historyBlocks m checkpoints = zipWith (-) boundaries (0 : boundaries)
  where boundaries = sort (filter (\k -> k > 0 && k < m) checkpoints) ++ [m]

historyObservation :: Int -> [Int] -> [Int] -> [[Int]]
historyObservation m checkpoints history =
  [ sort (take (hi - lo) (drop lo history))
  | (lo,hi) <- zip (0 : boundaries) boundaries ]
  where boundaries = sort (filter (\k -> k > 0 && k < m) checkpoints) ++ [m]

mkHistoryArchitecture :: Int -> String -> [Int] -> HistoryArchitecture
mkHistoryArchitecture m name checkpoints =
  HistoryArchitecture name checkpoints candidate fibres
  where
    histories = permutations [0..m-1]
    keyed = M.fromListWith (++)
      [(historyObservation m checkpoints h, [show h]) | h <- histories]
    classes = zip [0..] (M.toAscList keyed)
    routeFor = M.fromList
      [(witness, name ++ "/class/" ++ show i)
      | (i,(_,witnesses)) <- classes, witness <- witnesses]
    routes = [DSORoute (name ++ "/class/" ++ show i) i 0
             | (i,_) <- classes]
    fibres = [reverse witnesses | (_,(_,witnesses)) <- classes]
    origins = map show histories
    migration = [(origin, routeFor M.! origin) | origin <- origins]
    candidate = DSOArchitectureCandidate name origins routes migration

historyAdequate :: Int -> HistoryDemand -> HistoryArchitecture -> Bool
historyAdequate m EndpointDemand _ = True
historyAdequate m (SnapshotDemand ranks) architecture =
  all (`elem` historyCheckpoints architecture) ranks
historyAdequate m FullDemand architecture =
  historyCheckpoints architecture == [1..m-1]

compileHistoryArchitectures :: Int -> [Int] -> HistoryDemand
  -> ([HistoryArchitecture], DSOArchitectureResult)
compileHistoryArchitectures m selected demand = (adequate, result)
  where
    endpoint = mkHistoryArchitecture m "history/endpoint" []
    snapshot = mkHistoryArchitecture m "history/snapshot" selected
    full = mkHistoryArchitecture m "history/full" [1..m-1]
    adequate = filter (historyAdequate m demand) [endpoint,snapshot,full]
    context = DSOContinuation (show demand) "history-demand" (const 0)
    result = compileDSOArchitectures ["history-demand"] [context]
      (map historyCandidate adequate)

-- Orientation control for the corrected divisor-history statement.  Reversing
-- an increasing construction removes the largest factor first.  Least-factor
-- peeling is the reverse of the decreasing construction word, not increasing.
increasingConstruction, decreasingConstruction :: Int -> [Int]
increasingConstruction m = [0..m-1]
decreasingConstruction m = reverse (increasingConstruction m)

reverseRemoval, leastFactorPeeling :: Int -> [Int]
reverseRemoval = reverse . increasingConstruction
leastFactorPeeling = reverse . decreasingConstruction

executeBoundedSearch :: BoundedSearch -> SearchProjection
executeBoundedSearch plan =
  let witnesses = filter (searchPredicate plan) (searchFiber plan)
      consequence = not (null witnesses)
  in case acceptedCoverage plan of
       Nothing -> SearchProjection witnesses witnesses consequence Nothing
       Just coverage -> case leastCovered (searchFiber plan) (searchPredicate plan) coverage of
         Left residual -> SearchProjection [] witnesses consequence (Just residual)
         Right least -> SearchProjection [leastValue least] witnesses consequence Nothing

-- A finite connected-groupoid atlas.  `toChart c` is the chosen spanning-tree
-- transport from the base; the remaining arrows are represented by loop
-- generators acting on the base fibre.
data FiniteAtlas = FiniteAtlas
  { atlasCharts :: [Int]
  , atlasCarrier :: [Int]
  , toChart :: Int -> Int -> Int
  , loopGenerators :: [Int -> Int]
  }

data HolonomyFailure = HolonomyFailure
  { failedBaseValue :: !Int
  , failedLoop :: !Int
  , loopImage :: !Int
  } deriving (Eq, Show)

data CompiledAtlas = CompiledAtlas
  { coherentFamilies :: [(Int, [(Int,Int)])]
  , holonomyFailures :: [HolonomyFailure]
  , assignmentBranches :: !Integer
  } deriving (Eq, Show)

compileAtlas :: FiniteAtlas -> CompiledAtlas
compileAtlas atlas = CompiledAtlas families failures rawBranches
  where
    carrier = atlasCarrier atlas
    loops = loopGenerators atlas
    fixed a = all (\g -> g a == a) loops
    families =
      [ (a, [ (chart, toChart atlas chart a) | chart <- atlasCharts atlas ])
      | a <- carrier, fixed a ]
    failures =
      [ HolonomyFailure a i (g a)
      | a <- carrier
      , Just (i,g) <- [firstFailure a (zip [0..] loops)] ]
    firstFailure _ [] = Nothing
    firstFailure a ((i,g):gs)
      | g a == a = firstFailure a gs
      | otherwise = Just (i,g)
    rawBranches = toInteger (length carrier) ^ length (atlasCharts atlas)

-- The finite two-bit instance of NaturalMachine.Endian: chart 0=id,
-- 1=reversal D, 2=complement E, 3=DE.  The loop is the actual reversal
-- action, so its tears are precisely the non-palindromic words 01 and 10.
reverseBits2 :: Int -> Int
reverseBits2 word = (word `mod` 2) * 2 + word `div` 2

complementBits2 :: Int -> Int
complementBits2 word = 3 - word

endianAtlas2 :: FiniteAtlas
endianAtlas2 = FiniteAtlas
  { atlasCharts = [0,1,2,3]
  , atlasCarrier = [0..3]
  , toChart = \chart word -> case chart of
      0 -> word
      1 -> reverseBits2 word
      2 -> complementBits2 word
      _ -> reverseBits2 (complementBits2 word)
  , loopGenerators = [reverseBits2]
  }

instance Show Term where
  show (V i) | i < 6 = [ "xyzuvw" !! i ]
             | otherwise = "n" ++ show i
  show (F f []) = f
  show (F f [a,b])
    | f `elem` ["+","*","^","gcd","max"] = "(" ++ show a ++ f ++ show b ++ ")"
  show (F f as) = f ++ "(" ++ intercalate "," (map show as) ++ ")"

-- ------------------------------------------------ researcher thought input

-- A candidate line becomes the machine's own equation object.  Any line
-- which does not parse is retained exactly as a residual; known vocabulary
-- names inside residuals can still widen the language needed for the next
-- round, but are never mistaken for equations.
data ThoughtBatch = ThoughtBatch
  { thoughtCandidates :: [(Term,Term)]
  , thoughtResiduals  :: [String]
  } deriving (Eq, Show)

splitTabs :: String -> [String]
splitTabs s = case break (== '\t') s of
  (a, [])     -> [a]
  (a, _:rest) -> a : splitTabs rest

identifier :: ReadP String
identifier = munch1 (\c -> isAlphaNum c || c `elem` "+*-^#_")

termP :: ReadP Term
termP = do
  name <- identifier
  args <- option Nothing (Just <$> between (char '(') (char ')')
                    (sepBy termP (char ',')))
  case (name, args) of
    ([v], Nothing) | Just i <- lookup v (zip "xyzuvw" [0..]) -> pure (V i)
    (_, Nothing) -> pure (F name [])
    (_, Just ts) -> pure (F name ts)

parseTerm :: String -> Maybe Term
parseTerm s = case [ t | (t, rest) <- readP_to_S (termP <* eof) s, null rest ] of
  [t] -> Just t
  _   -> Nothing

-- ===================================================================
-- MEMORY.  The machine wrote machine/library.txt and never read it.
--
-- That is not a small thing: `start` has mRules = [] and mKnown = empty,
-- so every run began from nothing and re-derived what earlier runs had
-- proved -- when the whole architecture rests on installed theorems
-- compounding, and the `pruned` percentage is advertised as measuring
-- exactly that compounding.  library.txt is written with `show`, which
-- renders infix, and the term parser above reads prefix, so the file it
-- wrote was not a file it could read.  The fix is a second, machine-
-- readable trace in the format `parseTerm` already accepts.
--
-- WHAT IS NOT DONE HERE, and it matters: a remembered theorem is not
-- trusted.  It is re-submitted to the same kernel gate at load, and one
-- that fails is dropped with a log line.  The invariant stays "every
-- installed rule was kernel-accepted in THIS process", which is the only
-- version of memory that does not quietly become an axiom store.
-- ===================================================================

showTermP :: Term -> String
showTermP (V i)
  | i >= 0 && i < 6 = ["xyzuvw" !! i]
  | otherwise       = "v" ++ show i
showTermP (F n [])  = n
showTermP (F n ts)  = n ++ "(" ++ intercalate "," (map showTermP ts) ++ ")"

memoryPath :: FilePath
memoryPath = "machine/library.terms"

parseMemory :: String -> [(Term,Term)]
parseMemory = mapMaybe line . lines
  where
    line s = case splitTabs s of
      [l,r] -> (,) <$> parseTerm l <*> parseTerm r
      _     -> Nothing

parseThoughts :: String -> ThoughtBatch
parseThoughts = foldl' parseLine (ThoughtBatch [] []) . lines
  where
    parseLine b line
      | all isSpace line = b
      | otherwise = case splitTabs line of
          ["candidate", l, r]
            | Just lt <- parseTerm l, Just rt <- parseTerm r ->
                b { thoughtCandidates = thoughtCandidates b ++ [(lt,rt)] }
          _ -> b { thoughtResiduals = thoughtResiduals b ++ [line] }

residualWords :: String -> [String]
residualWords = words . map (\c -> if isAlphaNum c || c `elem` "+*-^#_" then c else ' ')

requiredVocabulary :: ThoughtBatch -> Int
requiredVocabulary b = maximum (3 : demanded)
  where
    names = concatMap (\(l,r) -> symbolsIn l ++ symbolsIn r)
              (thoughtCandidates b)
            ++ concatMap residualWords (thoughtResiduals b)
    demanded = [ i + 1 | (i,s) <- zip [0..] vocabulary, symName s `elem` names ]

size :: Term -> Int
size (V _) = 1
size (F _ ts) = 1 + sum (map size ts)

vars :: Term -> [Int]
vars (V i) = [i]
vars (F _ ts) = concatMap vars ts

subsetOf :: [Int] -> [Int] -> Bool
subsetOf a b = all (`elem` b) a

-- --------------------------------------------------------- the language
--
-- A symbol carries its arity and its meaning as a computation.  The
-- machine's vocabulary is data: it starts small and widens when the
-- machine exhausts what it can see.

-- A symbol is three things at once, and the machine needs all three:
-- how it computes (for killing conjectures), what it MEANS (its
-- defining equations, which are what makes proof possible at all), and
-- its arity.  A symbol without defining equations is a black box the
-- machine can test but never reason about — the first version of this
-- file had exactly that bug and proved nothing but coincidences.
data Sym = Sym { symName :: String
               , symArity :: Int
               , symSem :: [Integer] -> Integer
               , symDefs :: [(Term,Term)] }

x_, y_ :: Term
x_ = V 0
y_ = V 1

zero_ :: Term
zero_ = F "0" []

su :: Term -> Term
su t = F "s" [t]

bin :: String -> Term -> Term -> Term
bin f a b = F f [a,b]

-- THE GIVEN VOCABULARY, and the seam where a wider one is dispatched.
--
-- `baseVocabulary` is the list this engine ran on before 2026-08-16, in the
-- order it ran on.  ORDER IS THE PRECEDENCE (`precedence` below reads an index
-- into `vocabulary`), so anything appended must be appended at the END or the
-- reduction order on every existing term changes and every normal form in
-- machine/library.terms becomes a different object.
--
-- `vocabulary = baseVocabulary ++ arithVocabulary` therefore leaves the
-- precedence of 0,s,+,*,max,-,gcd,le exactly where it was (indices 0..7) and
-- gives mod,lcm,v2 indices 8,9,10.  What keeps the DEFAULT behaviour identical
-- is not the order but `dVocabCap`: the machine may only ever look at
-- `take dVocabCap vocabulary`, and its default is `baseVocabCap = 8`.
baseVocabulary :: [Sym]
baseVocabulary =
  [ Sym "0"   0 (const 0)      []
  , Sym "s"   1 (\vs -> case vs of
                           [v] -> v + 1
                           _   -> error "successor received wrong arity") []
  , Sym "+"   2 (\vs -> vs !! 0 + vs !! 1)
      [ (bin "+" x_ zero_,      x_)
      , (bin "+" x_ (su y_),    su (bin "+" x_ y_)) ]
  , Sym "*"   2 (\vs -> vs !! 0 * vs !! 1)
      [ (bin "*" x_ zero_,      zero_)
      , (bin "*" x_ (su y_),    bin "+" (bin "*" x_ y_) x_) ]
  , Sym "max" 2 (\vs -> max (vs !! 0) (vs !! 1))
      [ (bin "max" x_ zero_,          x_)
      , (bin "max" zero_ x_,          x_)
      , (bin "max" (su x_) (su y_),   su (bin "max" x_ y_)) ]
  , Sym "-"   2 (\vs -> max 0 (vs !! 0 - vs !! 1))
      [ (bin "-" x_ zero_,          x_)
      , (bin "-" zero_ x_,          zero_)
      , (bin "-" (su x_) (su y_),   bin "-" x_ y_) ]
  , Sym "gcd" 2 (\vs -> gcd (vs !! 0) (vs !! 1))
      -- These are the only unconditional gcd equations currently admitted
      -- to the proof kernel.  The former recursive clause
      --
      --   gcd (s x) (s y) = gcd ((s x) - (s y)) (s y)
      --
      -- was false when x < y: at x=1,y=2 it asserted gcd 2 3 = gcd 0 3,
      -- hence 1 = 3.  A correct Euclidean step needs a comparison/guard or
      -- remainder operation.  Until the term language can express one, gcd
      -- remains computationally visible to conjecture generation but only
      -- its sound base cases are available to proof search.  The Agda module
      -- NaturalMachine.HaskellDefinitionBoundary checks this exact boundary.
      [ (bin "gcd" x_ zero_, x_)
      , (bin "gcd" zero_ x_, x_) ]
  , Sym "le"  2 (\vs -> if vs !! 0 <= vs !! 1 then 1 else 0)
      -- Eleven of the machine's thirty-five theorems were `max`-shaped
      -- restatements of x <= y.  It was not producing junk; it was
      -- reaching for a predicate it had no name for.  (x+y) = ((x+y)max x)
      -- IS x <= x+y wearing a costume.
      [ (bin "le" zero_ x_,          su zero_)
      , (bin "le" (su x_) zero_,     zero_)
      , (bin "le" (su x_) (su y_),   bin "le" x_ y_) ]
  ]

-- ---------------------------------------------- the arithmetic vocabulary
--
-- WIRE 1 of 3.  machine/ArithVocab.hs was built this session as a standalone
-- `module ArithVocab` carrying its own byte-for-byte copy of this file's Term
-- algebra, four exact evaluators (gcd, a TOTAL mod with a mod 0 = a, lcm, and
-- the 2-adic valuation v2 with v2 0 = 0) and, for each, only the defining
-- equations that are unconditionally true under those conventions.  Its own
-- header says it "could be appended to MathMachine's vocabulary list without
-- translation".  This is that append: the symbols are IMPORTED from the module
-- that was built and audited, not retyped here, so there is one definition of
-- `mod` in the repository and not two.
--
-- `gcdSym` is deliberately NOT taken: gcd is already at index 6 with the same
-- two base equations, and a second entry of the same name would give `arities`
-- and `semantics` a duplicate key and `precedence` a shadowed index.
--
-- The conversion is a relabelling of constructors; both modules define
-- `Term = V !Int | F !String [Term]`.
fromAV :: AV.Term -> Term
fromAV (AV.V i)    = V i
fromAV (AV.F f ts) = F f (map fromAV ts)

avSym :: AV.Sym -> Sym
avSym s = Sym (AV.symName s) (AV.symArity s) (AV.symSem s)
              [ (fromAV l, fromAV r) | (l,r) <- AV.symDefs s ]

arithVocabulary :: [Sym]
arithVocabulary = map avSym [AV.modSym, AV.lcmSym, AV.vpSym]

-- WHAT THIS WIRE DOES NOT DO, measured rather than assumed.  With `--arith`
-- the engine generates, conjectures over and refutes with mod/lcm/v2 (the term
-- space at vocab 11, horizon 4 goes 400 -> 956 and the conjecture count 41 ->
-- 86).  It proves nothing about them, and that is not a defect of the wire:
--
--   (a) the only arithmetic equations reaching proof search are the base cases
--       in `symDefs`, because the recurrence that would make gcd and mod
--       reasonable -- ArithVocab's `euclideanStep`, gcd x y = gcd y (mod x y),
--       true unconditionally under the total mod convention -- is NOT
--       LPO-orientable and so is not a defining equation.  It could be
--       admitted the way `mLemmas` are, applied only where it decreases; that
--       is a new axiom for the Haskell search and belongs to whoever audits
--       it, not to a wiring pass.
--   (b) even a proved one could not be installed: `Certificate.known` is
--       ["0","s","+","*","-","max","le","gcd"], so a statement mentioning mod,
--       lcm or v2 is `Untranslatable` and comes back KERNEL-SKIP.  That is the
--       gate failing closed, which is the correct behaviour, and it means the
--       binding constraint on arithmetic is the certificate emitter and not
--       the vocabulary.  The vocabulary is now the part that is done.

vocabulary :: [Sym]
vocabulary = baseVocabulary ++ arithVocabulary

-- How far into `vocabulary` the engine is allowed to reach by default.  This
-- is the whole of the safety argument for WIRE 1: with the cap at the length
-- of `baseVocabulary`, `take (mVocab m) vocabulary` can never produce a symbol
-- that did not exist before, the growth ladder stops where it always stopped,
-- and the startup vocabulary demand is clamped to it.
baseVocabCap :: Int
baseVocabCap = length baseVocabulary

definitionsOf :: [Sym] -> [Rule]
definitionsOf = concatMap symDefs

arities :: [Sym] -> [(String,Int)]
arities = map (\s -> (symName s, symArity s))

semantics :: [Sym] -> M.Map String ([Integer] -> Integer)
semantics ss = M.fromList [ (symName s, symSem s) | s <- ss ]

-- --------------------------------------------------------- computation

eval :: M.Map String ([Integer] -> Integer) -> [Integer] -> Term -> Integer
eval _ env (V i) = env !! i
eval sem env (F f ts) =
  case M.lookup f sem of
    Just g  -> g (map (eval sem env) ts)
    -- Unknown syntax must never acquire the accidental meaning zero.  Term
    -- generation and researcher input are checked before evaluation; this
    -- branch is the final fail-loud boundary if either caller regresses.
    Nothing -> error ("MathMachine.eval: unknown symbol " ++ show f)

-- deterministic pseudo-random assignments: the machine must be
-- reproducible, so no system entropy enters.
lcg :: Integer -> Integer
lcg x = (6364136223846793005 * x + 1442695040888963407) `mod` (2^(62::Int))

assignments :: Int -> Int -> [[Integer]]
assignments nv sampleCount = go 12345 sampleCount
  where
    go _ 0 = []
    go s k = let vals = take nv (drop 1 (iterate lcg s))
                 env = map (\v -> v `mod` 9) vals
             in env : go (lcg (s + 7)) (k-1)

-- the behavioural fingerprint of a term: what it computes everywhere
-- the machine has looked.  Terms with different fingerprints are
-- different functions and no conjecture between them can survive.
fingerprint :: M.Map String ([Integer] -> Integer) -> [[Integer]] -> Term -> [Integer]
fingerprint sem envs t = map (\e -> eval sem e t) envs

-- ------------------------------------------------ definition firewall
--
-- Defining equations are axioms of the Haskell proof search.  Fingerprints
-- only test conjectures; they cannot protect the kernel from a false equation
-- already installed here.  Before doing any search, exhaustively look for a
-- small semantic counterexample to every defining equation.  Passing this
-- finite audit is NOT a proof of soundness.  Failing it is, however, a proof
-- that the search must not start, so the firewall fails closed.

type DefinitionFailure = (String, Term, Term, [Integer], Integer, Integer)

termShapeProblems :: [Sym] -> Term -> [String]
termShapeProblems _ (V _) = []
termShapeProblems syms (F f ts) = arityProblem ++ concatMap (termShapeProblems syms) ts
  where
    arityProblem = case [ symArity s | s <- syms, symName s == f ] of
      [] -> ["unknown symbol " ++ show f]
      (arity:_)
        | arity == length ts -> []
        | otherwise -> ["symbol " ++ show f ++ " expects " ++ show arity
                          ++ " arguments, received " ++ show (length ts)]

wellFormedTerm :: [Sym] -> Term -> Bool
wellFormedTerm syms = null . termShapeProblems syms

definitionShapeFailures :: [Sym] -> [String]
definitionShapeFailures syms =
  [ symName s ++ ": " ++ show l ++ " = " ++ show r ++ ": " ++ problem
  | s <- syms
  , (l,r) <- symDefs s
  , problem <- termShapeProblems syms l
            ++ termShapeProblems syms r
            ++ [ "right side introduces a variable absent from the left"
               | not (vars r `subsetOf` vars l) ] ]

smallEnvironments :: Int -> Integer -> [[Integer]]
smallEnvironments n bound = sequence (replicate n [0 .. bound])

ruleCounterexample
  :: [Sym] -> Integer -> Rule -> Maybe ([Integer], Integer, Integer)
ruleCounterexample syms bound (l,r) =
  case [ (env, lv, rv)
       | env <- smallEnvironments variableCount bound
       , let lv = eval sem env l
       , let rv = eval sem env r
       , lv /= rv ] of
    (w:_) -> Just w
    []    -> Nothing
  where
    sem = semantics syms
    used = vars l ++ vars r
    variableCount = case used of
      [] -> 0
      _  -> 1 + maximum used

definitionFailures :: [Sym] -> Integer -> [DefinitionFailure]
definitionFailures syms bound =
  [ (symName s, l, r, env, lv, rv)
  | s <- syms
  , (l,r) <- symDefs s
  , Just (env,lv,rv) <- [ruleCounterexample syms bound (l,r)] ]

oldUnsoundGcdRule :: Rule
oldUnsoundGcdRule =
  ( bin "gcd" (su x_) (su y_)
  , bin "gcd" (bin "-" (su x_) (su y_)) (su y_) )

renderDefinitionFailure :: DefinitionFailure -> String
renderDefinitionFailure (name,l,r,env,lv,rv) =
  name ++ ": " ++ show l ++ " = " ++ show r
    ++ " fails at env=" ++ show env
    ++ " (left=" ++ show lv ++ ", right=" ++ show rv ++ ")"

definitionAuditBound :: Integer
definitionAuditBound = 8

definitionAudit :: Either [String] ()
definitionAudit = case definitionShapeFailures vocabulary
                    ++ map renderDefinitionFailure
                         (definitionFailures vocabulary definitionAuditBound) of
  [] -> Right ()
  fs -> Left fs

survivesSemanticFirewall :: [Sym] -> Rule -> Bool
survivesSemanticFirewall syms =
  not . isJust . ruleCounterexample syms definitionAuditBound

parseNaturalInt :: String -> Maybe Int
parseNaturalInt raw = case reads raw of
  [(n,"")] | n >= 0 -> Just n
  _                  -> Nothing

-- A bounded run with no side effects on the live corpus: no memory file is
-- written, and the log goes to /dev/null unless `--log` names a sink.  This is
-- the harness the dispatch wires are exercised through, precisely so that a
-- test of a new wire cannot append to machine/library.txt.
runSmokeMachineWith :: Dispatch -> Int -> IO Machine
runSmokeMachineWith disp n = do
  ref <- newIORef (case dVocabStart disp of
                     Nothing -> start
                     Just v  -> start { mVocab = max 1 (min v (dVocabCap disp)) })
  withFile (maybe "/dev/null" id (dLog disp)) AppendMode $ \sink -> do
    hSetBuffering sink LineBuffering
    hSetEncoding sink utf8
    hPrintf sink "=== MathMachine smoke ===\n  DISPATCH  %s\n" (show disp)
    replicateM_ n (round1 disp Nothing sink sink ref)
  readIORef ref

runSmokeMachine :: Int -> IO Machine
runSmokeMachine = runSmokeMachineWith defaultDispatch

smokeRounds :: Dispatch -> Int -> IO ()
smokeRounds disp n = do
  m <- runSmokeMachineWith disp n
  putStrLn ("MACHINE SMOKE CHECKED: rounds=" ++ show (mRound m)
    ++ " known=" ++ show (M.size (mKnown m))
    ++ " rules=" ++ show (length (mRules m))
    ++ " lemmas=" ++ show (length (mLemmas m))
    ++ " vocab=" ++ show (mVocab m)
    ++ " horizon=" ++ show (mSize m))

printSmokeDiscoveries :: Dispatch -> Int -> IO ()
printSmokeDiscoveries disp n = do
  m <- runSmokeMachineWith disp n
  forM_ (M.keys (mKnown m)) $ \(l,r) ->
    putStrLn (show l ++ " = " ++ show r)

-- OVER `baseVocabulary`, NOT `vocabulary`, and this is load-bearing.  The
-- emitted module is compared to `expectedDefinitionManifest` by `refl` in
-- NaturalMachine.HaskellDefinitionManifestGenerated; appending the arithmetic
-- symbols here would make that Agda check fail, which is the Agda side
-- correctly reporting that the boundary it certifies has moved.  The manifest
-- describes the certified fragment, and the certified fragment is the base
-- vocabulary until Certificate.hs and the boundary module learn mod/lcm/v2.
definitionManifest :: [String]
definitionManifest =
  [ symName s ++ " :: " ++ show l ++ " = " ++ show r
  | s <- baseVocabulary
  , (l,r) <- symDefs s ]

agdaString :: String -> String
agdaString raw = '"' : concatMap escape raw ++ "\""
  where
    escape '"'  = "\\\""
    escape '\\' = "\\\\"
    escape c    = [c]

renderAgdaList :: (a -> String) -> [a] -> String
renderAgdaList render xs = unlines
  (map (\entry -> "  " ++ render entry ++ " ∷") xs ++ ["  []"])

emitAgdaDefinitionManifest :: FilePath -> IO ()
emitAgdaDefinitionManifest path = writeFile path (unlines
  [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
  , "module NaturalMachine.HaskellDefinitionManifestGenerated where"
  , "open import Cubical.Foundations.Prelude"
  , "open import Cubical.Data.List using (List ; [] ; _∷_)"
  , "open import Agda.Builtin.String using (String)"
  , "open import NaturalMachine.HaskellDefinitionBoundary"
  , "  using (expectedDefinitionManifest)"
  , ""
  , "generatedDefinitionManifest : List String"
  , "generatedDefinitionManifest ="
  ] ++ renderAgdaList agdaString definitionManifest ++ unlines
  [ ""
  , "definition-manifest-agrees :"
  , "  generatedDefinitionManifest ≡ expectedDefinitionManifest"
  , "definition-manifest-agrees = refl"
  ])
-- The first bridge language is intentionally only the signature reached in
-- five deterministic rounds.  Unsupported syntax fails generation instead
-- of being encoded as an opaque string.
agdaDiscoveryTerm :: Term -> Either String String
agdaDiscoveryTerm (V i) = Right ("var " ++ show i)
agdaDiscoveryTerm (F "0" []) = Right "zeroT"
agdaDiscoveryTerm (F "s" [t]) = do
  rendered <- agdaDiscoveryTerm t
  Right ("sucT (" ++ rendered ++ ")")
agdaDiscoveryTerm (F "+" [l,r]) = do
  leftRendered <- agdaDiscoveryTerm l
  rightRendered <- agdaDiscoveryTerm r
  Right ("(" ++ leftRendered ++ " +T " ++ rightRendered ++ ")")
agdaDiscoveryTerm (F "*" [l,r]) = do
  leftRendered <- agdaDiscoveryTerm l
  rightRendered <- agdaDiscoveryTerm r
  Right ("(" ++ leftRendered ++ " ·T " ++ rightRendered ++ ")")
agdaDiscoveryTerm t = Left ("unsupported discovery syntax: " ++ show t)

agdaDiscoveryEquation :: Rule -> Either String String
agdaDiscoveryEquation (l,r) = do
  leftRendered <- agdaDiscoveryTerm l
  rightRendered <- agdaDiscoveryTerm r
  Right ("(" ++ leftRendered ++ " , " ++ rightRendered ++ ")")

-- Deliberately `runSmokeMachine` (defaultDispatch) and not the caller's
-- dispatch: the emitted list is compared to `expectedDiscoveries` by `refl` in
-- NaturalMachine.HaskellDiscoveryManifestGenerated, so it must describe the
-- engine the boundary module was written against, whatever flags the invoking
-- shell happened to carry.
emitAgdaDiscoveryManifest :: Int -> FilePath -> IO ()
emitAgdaDiscoveryManifest n path = do
  m <- runSmokeMachine n
  case traverse agdaDiscoveryEquation (M.keys (mKnown m)) of
    Left problem -> hPutStrLn stderr problem >> exitFailure
    Right rendered -> writeFile path (unlines
      [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
      , "module NaturalMachine.HaskellDiscoveryManifestGenerated where"
      , "open import Cubical.Foundations.Prelude"
      , "open import Cubical.Data.List using (List ; [] ; _∷_)"
      , "open import Cubical.Data.Sigma using (_,_ )"
      , "open import NaturalMachine.HaskellDiscoveryBoundary"
      , "  using (Equation ; AllSound ; var ; zeroT ; sucT ; _+T_ ; _·T_"
      , "        ; expectedDiscoveries ; expectedDiscoveriesSound)"
      , ""
      , "generatedDiscoveries : List Equation"
      , "generatedDiscoveries ="
      ] ++ renderAgdaList id rendered ++ unlines
      [ ""
      , "generated-discoveries-agree :"
      , "  generatedDiscoveries ≡ expectedDiscoveries"
      , "generated-discoveries-agree = refl"
      , ""
      , "generatedDiscoveriesSound : AllSound generatedDiscoveries"
      , "generatedDiscoveriesSound ="
      , "  subst AllSound (sym generated-discoveries-agree)"
      , "    expectedDiscoveriesSound"
      ])

-- --------------------------------------------------------- generation

genTerms :: [(String,Int)] -> Int -> Int -> [Term]
genTerms = genTermsModulo [] []

-- Compile a proved commutativity law into the grammar: for a binary symbol
-- in `comm`, generate one representative of the transposition orbit.  This
-- removes the losing branch before a `Term` exists.
genTermsModulo :: [String] -> [String] -> [(String,Int)] -> Int -> Int -> [Term]
genTermsModulo comm assoc sig nv maxSize = concat table
  where
    -- a lazy list, not a strict map: `build n` consults `ofSize m` only
    -- for m < n, so the knot ties, but only if the table's entries stay
    -- unforced until asked for.
    table = [ build n | n <- [1..maxSize] ]
    ofSize n | n >= 1 && n <= maxSize = table !! (n-1)
             | otherwise = []
    build 1 = [ V i | i <- [0..nv-1] ] ++ [ F f [] | (f,0) <- sig ]
    build n = [ F f args | (f,a) <- sig, a > 0, args <- argsOf a (n-1)
                          , canonical f args ]
      where
        canonical f [l,r] | f `elem` comm && f `elem` assoc =
          not (headed f l) && sortedBy cmpTerm (flatten f l ++ flatten f r)
        canonical f [l,r] | f `elem` comm = cmpTerm l r /= GT
        canonical _ _ = True
        headed f (F g _) = f == g
        headed _ _ = False
        flatten f (F g [l,r]) | f == g = flatten f l ++ flatten f r
        flatten _ t = [t]
        sortedBy _ [] = True
        sortedBy _ [_] = True
        sortedBy cmp (x:y:xs) = cmp x y /= GT && sortedBy cmp (y:xs)
        argsOf 1 k | k >= 1 = map (:[]) (ofSize k)
                   | otherwise = []
        argsOf a k = [ t:rest | i <- [1..k-a+1]
                              , t <- ofSize i
                              , rest <- argsOf (a-1) (k-i) ]

acCanonical :: String -> Term -> Term
acCanonical f = rebuild . sortBy cmpTerm . collect
  where
    collect (F g [l,r]) | f == g = collect l ++ collect r
    collect t = [mapChildren t]
    mapChildren (F g ts) = F g (map (acCanonical f) ts)
    mapChildren t = t
    rebuild [] = error "acCanonical: empty product"
    rebuild [t] = t
    rebuild (t:ts) = F f [t, rebuild ts]

-- --------------------------------------------------------- rewriting
--
-- A proved equation becomes an operation.  This is the only place where
-- knowledge is used, and it is why the machine gets faster.

type Rule = (Term, Term)

match :: Term -> Term -> Maybe (M.Map Int Term)
match pat t = go pat t M.empty
  where
    go (V i) u m = case M.lookup i m of
                     Nothing -> Just (M.insert i u m)
                     Just u' -> if u == u' then Just m else Nothing
    go (F f ps) (F g us) m
      | f == g && length ps == length us = foldM' ps us m
    go _ _ _ = Nothing
    foldM' [] [] m = Just m
    foldM' (p:ps) (u:us) m = go p u m >>= foldM' ps us
    foldM' _ _ _ = Nothing

applySub :: M.Map Int Term -> Term -> Term
applySub m (V i) = M.findWithDefault (V i) i m
applySub m (F f ts) = F f (map (applySub m) ts)

-- one rewrite step, innermost-leftmost: rewrite the first argument that
-- can move, otherwise rewrite at the root.
step :: [Rule] -> Term -> Maybe Term
step rs t =
  case t of
    F f ts -> case rewriteArgs ts of
                Just ts' -> Just (F f ts')
                Nothing  -> topStep t
    _ -> topStep t
  where
    -- Every rewrite must strictly decrease the term in the order.  For
    -- an oriented rule this is automatic (LPO is stable under
    -- substitution), so nothing is lost; for a symmetric law like
    -- commutativity it is the whole game — the equation may be used in
    -- either direction, but only where it makes the term smaller.  That
    -- is what lets an unorientable theorem still do work, and it makes
    -- non-termination impossible rather than merely unlikely.
    topStep u =
      case [ r' | (l,r) <- rs, Just sub <- [match l u]
                , let r' = applySub sub r, decreases u r' ] of
        (x:_) -> Just x
        []    -> Nothing
    rewriteArgs [] = Nothing
    rewriteArgs (x:xs) =
      case step rs x of
        Just x' -> Just (x':xs)
        Nothing -> fmap (x:) (rewriteArgs xs)

-- A step is progress if the path order says so, or failing that if the
-- term simply got smaller.  LPO is the honest order but it is partial:
-- it cannot compare `max x 1` with `max 1 x`, and a symmetric law it
-- cannot compare is a theorem that can never be used.  Falling back to
-- (size, then a fixed total order on terms) settles those cases and is
-- still well-founded, so normal forms exist.
-- The fallback applies ONLY where LPO is silent.  If LPO ranks the two
-- terms the other way, the size order must not override it: allowing
-- both made the same equation fire in both directions, normal forms
-- oscillated, and the successor law — which everything about addition
-- depends on — became unprovable.  Deference to the stronger order is
-- what keeps rewriting terminating.
-- The fallback must agree with the precedence, not with Haskell's
-- derived Ord — which compares symbol names as ASCII ("*" < "+" < "0"
-- < "gcd" < "max" < "s"), an order orthogonal to the one the machine
-- reasons with.  Sorting by a stranger's alphabet is why a third of the
-- library came out as `max`-shaped restatements of single facts.
cmpTerm :: Term -> Term -> Ordering
cmpTerm (V a) (V b) = compare a b
cmpTerm (V _) (F _ _) = LT
cmpTerm (F _ _) (V _) = GT
cmpTerm s@(F f as) t@(F g bs) =
  compare (size s) (size t)
    <> compare (precedence f) (precedence g)
    <> compare (length as) (length bs)
    <> mconcat (zipWith cmpTerm as bs)

decreases :: Term -> Term -> Bool
decreases u v
  | lpo u v = True
  | lpo v u = False
  | otherwise = cmpTerm v u == LT

normalize :: [Rule] -> Term -> Term
normalize rs = go (200 :: Int)
  where
    go 0 t = t
    go k t = case step rs t of
               Nothing -> t
               Just t' -> go (k-1) t'

-- The same normalisation, counting the rewrite steps it took.  Not a second
-- strategy: `normalizeSteps rs t` and `normalize rs t` are the same fold over
-- the same `step`, so `fst (normalizeSteps rs t) == normalize rs t` by
-- construction.  The count is what the DSO scheduler charges (WIRE 2), and it
-- is an EXACT integer about this rewrite engine, not a measurement of one.
normalizeSteps :: [Rule] -> Term -> (Term, Integer)
normalizeSteps rs = go (200 :: Int) 0
  where
    go 0 n t = (t, n)
    go k n t = case step rs t of
                 Nothing -> (t, n)
                 Just t' -> go (k-1) (n+1) t'



-- Which way should a proved equation be run?  Getting this wrong is
-- not a style question: an equation oriented the wrong way makes the
-- machine's normal forms worse, and a set of equations oriented
-- inconsistently can rewrite forever.  Term size is too crude to
-- decide it (s(x)+y and s(x+y) have the same size, and only one
-- direction is progress).  The answer is a genuine reduction order —
-- the lexicographic path order over a precedence on the symbols, where
-- a symbol defined later outranks the ones it was defined from
-- (* beats +, + beats s, s beats 0).  LPO is well-founded, so a rule
-- set it orients cannot loop.
precedence :: String -> Int
precedence f =
  case [ i | (i,s) <- zip [0..] vocabulary, symName s == f ] of
    (i:_) -> i
    [] -> case f of
      -- An invented concept must sit BELOW everything its defining
      -- pattern mentions, so that rewriting folds into it; and later
      -- concepts below earlier ones, so a concept built from concepts
      -- still folds.  Giving them all -1 left the machine's own ideas
      -- mutually unorderable — second-class citizens in its own order.
      ('c':ds) | all (`elem` "0123456789") ds, not (null ds) ->
        -2 - read ds
      _ -> -1            -- the eigenconstant sits below everything

lpo :: Term -> Term -> Bool
lpo s t
  | s == t = False
  | otherwise =
      case (s,t) of
        (V _, _) -> False
        (F _ _, V x) -> x `elem` vars s
        (F f ss, F g ts)
          | any (\si -> si == t || lpo si t) ss -> True
          | precedence f > precedence g && all (lpo s) ts -> True
          | f == g && all (lpo s) ts && lexGt ss ts -> True
          | otherwise -> False
  where
    lexGt (a:as) (b:bs) | a == b = lexGt as bs
                        | otherwise = lpo a b
    lexGt _ _ = False

orient :: (Term,Term) -> Maybe Rule
orient (l,r)
  | l == r = Nothing
  | lpo l r, vars r `subsetOf` vars l = Just (l,r)
  | lpo r l, vars l `subsetOf` vars r = Just (r,l)
  | otherwise = Nothing        -- e.g. commutativity: neither way shrinks

-- --------------------------------------------------------- proving
--
-- Rewriting first (cheap, and it is also the test for "we already knew
-- this").  Then structural induction on one variable, which is where
-- the machine's own earlier theorems do the work in the step case.

zeroT :: Term
zeroT = F "0" []

sucT :: Term -> Term
sucT t = F "s" [t]

substVar :: Int -> Term -> Term -> Term
substVar i u (V j) = if i == j then u else V j
substVar i u (F f ts) = F f (map (substVar i u) ts)

provedByRewriting :: [Rule] -> (Term,Term) -> Bool
provedByRewriting rs (l,r) = normalize rs l == normalize rs r

-- The induction variable must be FROZEN.  If the hypothesis is stored
-- with a pattern variable in that position, rewriting may instantiate
-- it anywhere, which is assuming the very statement being proved.  The
-- eigenconstant `#` is a nullary symbol nothing else mentions, so the
-- hypothesis can only ever fire at the exact instance it is about.
eigen :: Term
eigen = F "#" []

proveByInduction :: [Rule] -> (Term,Term) -> Maybe String
proveByInduction rs (l,r) =
  case ordNub (vars l ++ vars r) of
    [] -> Nothing
    vs -> firstJust [ tryVar v | v <- vs ]
  where
    firstJust xs = case mapMaybe id xs of
                     (x:_) -> Just x
                     []    -> Nothing
    tryVar v =
      let base = (substVar v zeroT l, substVar v zeroT r)
          hypL = substVar v eigen l
          hypR = substVar v eigen r
          goal = (substVar v (sucT eigen) l, substVar v (sucT eigen) r)
          -- the hypothesis goes in both directions; `step` will only
          -- fire it where it decreases, so an unorientable IH (the
          -- commutativity case) is still usable and still sound
          hyps = [(hypL,hypR),(hypR,hypL)]
      in if provedByRewriting rs base && provedByRewriting (hyps ++ rs) goal
           then Just ("induction on " ++ show (V v))
           else Nothing

-- f(a,b) = f(a',b') where a=a' and b=b' are already known is not a
-- discovery, it is congruence.  Most of what an unfiltered explorer
-- emits is this: one law wearing a hat.  Stating it costs a proof
-- search and buys nothing, so it is filtered before induction is spent.
congruent :: [Rule] -> M.Map (Term,Term) () -> (Term,Term) -> Bool
congruent rs known (F f as, F g bs)
  | f == g, length as == length bs, or (zipWith (/=) as bs) =
      and [ a == b
            || provedByRewriting rs (a,b)
            || M.member (canonVars (a,b)) known
            || M.member (canonVars (b,a)) known
          | (a,b) <- zip as bs ]
congruent _ _ _ = False

-- What is a theorem worth?  The machine already measures its own
-- progress as the fraction of the term space its knowledge removes.
-- That same measurement, applied to ONE candidate, is its value: how
-- many distinct terms collapse if this equation is installed.  A law
-- that collapses nothing is a true statement with no consequences, and
-- the machine has proved a hundred and eighty of those.  Now it must
-- pay its way in.
-- THE PROBE WAS A PREFIX, AND A PREFIX IS SORTED BY SIZE.
--
-- `genTermsModulo` is `concat [build n | n <- [1..maxSize]]` and `ordNub`
-- keeps first occurrences, so `normed` is in nondecreasing size order and
-- `take k normed` is the k SMALLEST normal forms.  Let K be the largest size
-- among them.  A rewrite rule fires at a subterm only if its left-hand side
-- MATCHES there, and matching maps each pattern node to a distinct term
-- node, so a pattern of size s matches only terms of size >= s.  Therefore
--
--     size (lhs c) > K  =>  no probe term contains an instance of c
--                       =>  normalising the probe with c changes nothing
--                       =>  marginalPrune _ probe c = 0.
--
-- That is a theorem, not a tendency: with kProbe = 400 and three variables
-- the prefix stops around size 4, while round 21 of a real run is generating
-- terms of size 7.  Every theorem whose left side is bigger than a small
-- term was discarded as "a true statement with no consequences" WITHOUT ITS
-- CONSEQUENCES EVER BEING LOOKED AT -- 1211 of them in that one round, all
-- proved, all thrown away.  The value test was reading a ruler that stopped
-- before the object began.
--
-- A stride sample spans the whole size range at the same cost.  It does not
-- make the estimator unbiased -- large terms are still rarer in the sample
-- than in the population -- but it removes the region where the answer is
-- structurally zero, which is what the filter was actually measuring.
strideSample :: Int -> [a] -> [a]
strideSample k xs
  | k <= 0 = []
  | n <= k = xs
  | otherwise = [ x | (i, x) <- zip [(0 :: Int) ..] xs, i `mod` stride == 0 ]
  where
    n = length xs
    stride = max 1 (n `div` k)

-- THE VALUE TEST, COMPUTED INSTEAD OF SAMPLED.
--
-- `marginalPrune` asks how many distinct normal forms disappear if `c` is
-- installed, and answers it on a k-term sample.  Two facts about that
-- estimator, neither of them measured:
--
--   (i)  a collapse needs TWO population members to merge, so on a
--        k-sample of an N-term population a merge is seen only when both
--        members are drawn -- probability ~(k/N)^2.  At k=400, N=208804
--        that is 4e-6.  The sample statistic is not a noisy version of the
--        quantity; for almost every real merge it is deterministically 0.
--   (ii) with `kMinPrune = 1` the decision is a THRESHOLD at one, so the
--        false-negative rate of the whole filter is ~e^{-p k} in the
--        fraction p of the population the rule touches.  Nobody chose that
--        rate; it fell out of a `take`.
--
-- The exact quantity is affordable, because the population T is already
-- the set of distinct normal forms under `rules`, so `normalize` is the
-- identity on every term the new rule does not touch.  Write S for the
-- terms where it does fire.  Then the image of T is (T\S) together with
-- the images of S, and
--
--     collapse = |T| - |image| = |S| - |{ phi t | t <- S } \ (T\S)|.
--
-- So the whole computation is: one scan of T asking `step extra t` (a
-- match test, NO rewriting -- and `step`'s own `decreases` guard means an
-- unorientable law is only counted where it may legally fire), then
-- normalisation of the |S| terms that survive that scan.  Cost is
-- proportional to the rule's own reach, which is the thing being measured;
-- a rule that touches nothing costs one scan and honestly scores 0, and a
-- rule that touches half the population was always going to be worth it.
--
-- The scan is over the population the round actually generated, not a
-- window into it, so `size (lhs c) > max size in the sample` -- the
-- structural zero that made a 400-prefix reject every large theorem
-- outright -- cannot arise.
-- The largest population on which the exact value test has been MEASURED to
-- be affordable.  3287 is measured good, 24993 is measured bad; this sits
-- between them and is stated as what it is -- an unexplored gap, not a
-- tuned optimum.
kExactPopulation :: Int
kExactPopulation = 8000

exactPrune :: [Rule] -> [Term] -> (Term,Term) -> Int
exactPrune rules population c =
  let extra = extraRules c
      (fired, untouchedL) = partition (isJust . step extra) population
      untouched = S.fromList untouchedL
      images = S.fromList (map (normalize (extra ++ rules)) fired)
  in length fired - S.size (S.difference images untouched)

extraRules :: (Term,Term) -> [Rule]
extraRules c = case orient c of
  Just r  -> [r]
  Nothing -> lemmaRules [c]

-- AND THE DECISION IS CHEAPER THAN THE COUNT.  `kMinPrune` is 1, so the
-- filter asks a yes/no question and `exactPrune` answers a harder one: it
-- normalises every term the rule touches, even after the answer is settled.
-- At size 5 that is affordable and at size 6 it is not -- the first run of it
-- did not finish a size-6 round in fifty minutes, against 1.6s for the sample
-- it replaced.  Exactness was never the expensive part; the count was.
--
-- `population` is the round's set of distinct normal forms, so a term is
-- "untouched" exactly when it is in that set (any image of a fired term is
-- already normal under the extended rules).  That makes membership a lookup
-- in ONE set built once per round rather than a set built per candidate, and
-- the first collapse -- an image landing on another population member, or two
-- fired terms sharing an image -- ends the scan.  A rule that earns its place
-- says so in its first few terms; only a rule that collapses nothing pays for
-- the whole population, and that is the answer it deserves.
collapsesSomething :: S.Set Term -> [Rule] -> [Term] -> (Term,Term) -> Bool
collapsesSomething popSet rules population c = go S.empty fired
  where
    extra = extraRules c
    fired = [ t | t <- population, isJust (step extra t) ]
    go _ [] = False
    go seen (t : ts)
      | S.member u popSet || S.member u seen = True
      | otherwise = go (S.insert u seen) ts
      where u = normalize (extra ++ rules) t

marginalPrune :: [Rule] -> [Term] -> (Term,Term) -> Int
marginalPrune rules probe c =
  let before = length (ordNub (map (normalize rules) probe))
      extra = case orient c of
                Just r  -> [r]
                Nothing -> lemmaRules [c]
      after = length (ordNub (map (normalize (extra ++ rules)) probe))
  in before - after

-- THE CONCEPT GATE WAS UNSATISFIABLE.  For eighteen rounds the machine
-- reached for a new idea four times and named nothing, because the test
-- it had to pass cannot be passed.  This is a theorem, not a tuning
-- problem:
--
--   Let c be a symbol occurring neither in R nor in the probe set S, and
--   let R' = R ∪ {p → c(x₁…x_k)} where vars p = {x₁…x_k}.  Let u be the
--   unfolding that rewrites c(t₁…t_k) ↦ p[xᵢ↦tᵢ]; u is well defined
--   because c is fresh, and u(nf_{R'}(t)) = nf_R(t) for every c-free t.
--   So nf_{R'} restricted to S is injective wherever nf_R is, hence
--     |nf_{R'}(S)| ≥ |nf_R(S)|   and   marginalPrune ≤ 0,  always.
--
-- A definition FOLDS; it does not MERGE.  Asking a definition to collapse
-- distinct normal forms is asking it to be a theorem.  So `marginalPrune`
-- is the right currency for a proved equation and the wrong one for a
-- name, and the gate rejected every candidate for a reason no amount of
-- lowering kConceptMin would have reached.
--
-- The comment above `patternsOf` already said what the criterion should
-- be — "the criterion is description length" — and the code measured
-- something else.  This is that criterion: total size of the probe's
-- normal forms.  Folding x+x (size 3) into c₀(x) (size 2) shortens; a
-- name that does not shorten is not worth having.
marginalCompress :: [Rule] -> [Term] -> (Term,Term) -> Int
marginalCompress rules probe c =
  let extra = case orient c of
                Just r  -> [r]
                Nothing -> lemmaRules [c]
      before = sum (map (size . normalize rules) probe)
      after  = sum (map (size . normalize (extra ++ rules)) probe)
  in before - after

-- x+y = y+x and z+u = u+z are the same discovery.  Renaming variables
-- to their order of first appearance makes that a syntactic fact, so
-- the machine states each theorem once instead of once per alphabet.
canonVars :: (Term,Term) -> (Term,Term)
canonVars (l,r) = (applySub ren l, applySub ren r)
  where
    order = ordNub (vars l ++ vars r)
    ren = M.fromList (zip order (map V [0..]))

ordNub :: Ord a => [a] -> [a]
ordNub = go M.empty
  where
    go _ [] = []
    go seen (x:xs) | M.member x seen = go seen xs
                   | otherwise = x : go (M.insert x () seen) xs

-- ------------------------------------------------------- Agda kernel seam
-- The first proof-producing seam is intentionally narrow.  The Haskell
-- search may propose any equation, but only the shared Peano fragment can be
-- translated, and its first certificate language is Agda's `refl`.
-- Consequently acceptance means definitional equality in Agda itself; the
-- Haskell induction trace is never mistaken for a kernel certificate.

agdaTerm :: Term -> Maybe String
agdaTerm (V i)
  | i >= 0 && i < 6 = Just ["xyzuvw" !! i]
  | otherwise = Nothing
agdaTerm (F "0" []) = Just "zero"
agdaTerm (F "s" [t]) = (\u -> "suc (" ++ u ++ ")") <$> agdaTerm t
agdaTerm (F "+" [a,b]) = binAgda "+" a b
agdaTerm (F "*" [a,b]) = binAgda "·" a b
agdaTerm _ = Nothing

binAgda :: String -> Term -> Term -> Maybe String
binAgda op a b = do
  x <- agdaTerm a
  y <- agdaTerm b
  pure ("(" ++ x ++ " " ++ op ++ " " ++ y ++ ")")

-- The module name is supplied by the caller, because the candidate is
-- checked inside formal/cubical (see `kernelAccept`) and two processes
-- must not write the same file.
agdaCertificate :: (Term,Term) -> Maybe (String -> String)
agdaCertificate (l,r) = do
  lhs <- agdaTerm l
  rhs <- agdaTerm r
  pure $ \modName -> unlines
    [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
    , "module " ++ modName ++ " where"
    , "open import Cubical.Foundations.Prelude"
    , "open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)"
    , "candidate : (x y z u v w : ℕ) → " ++ lhs ++ " ≡ " ++ rhs
    , "candidate x y z u v w = refl"
    ]


-- ===================================================================
-- THE SEAM TO `machine/Certificate.hs`.
--
-- The gate below used to emit `candidate x y z u v w = refl` over the
-- four symbols 0, s, + and `·`, so it could certify only definitional
-- equalities and skipped everything else -- which is every theorem this
-- engine's own induction prover produces.  `Certificate` emits induction
-- skeletons, covers the whole vocabulary (with `max` and `le` as local
-- definitions transcribed from THIS module's `symDefs`, so the
-- certificate is about the same function the machine computed with), and
-- emits invented concepts as local definitions too, which removes the
-- KERNEL-SKIP category entirely.
--
-- Concept support is not a nicety: naming is the machine's growth axis,
-- so a gate that cannot certify a statement mentioning a coined symbol
-- caps the machine permanently at its given vocabulary.
-- ===================================================================

toCert :: Term -> C.Term
toCert (V i)    = C.V i
toCert (F f ts) = C.F f (map toCert ts)

-- THE GATE WAS HANDED THE WRONG HALF OF THE MACHINE'S OWN CONCEPT RULE.
-- `inventConcept` builds a concept's single rule as `(pattern, F nm args)`:
-- the PATTERN on the left, the folded name on the right, because that is
-- the direction a rewrite runs.  A `Definition` is the other object -- the
-- defining CLAUSE `nm a0 .. = pattern` -- so its body is the rule's FIRST
-- component.  Reading the second emitted `c0 a0 = (c0 a0)`, which agda
-- answers with "Termination checking failed", so every candidate mentioning
-- an invented concept was rejected for a reason that had nothing to do with
-- whether it was true.  Concept invention is this file's own growth axis
-- and at the gate that axis was closed.  Found by machine/GateAudit.hs
-- section B, which submits both halves side by side.
--
-- AND THE GATE PROVES THINGS ABOUT THE DEFINITIONS IT IS HANDED.  That is
-- all it can do: submit `c0(x) = x` together with `Definition "c0" 1 (V 0)`
-- and agda certifies it by refl, correctly, whatever `c0` means here.  So
-- the seam is not in the gate, it is in this function, and a comment
-- promising to be careful is not a check.  Three conditions are imposed,
-- and a concept failing any of them contributes no Definition -- which
-- makes every candidate mentioning it UNTRANSLATABLE, the one outcome that
-- cannot be mistaken for a proof:
--
--   * the rule folds to this very symbol applied to its own parameters,
--     so it is a defining clause and not some incidental rewrite;
--   * the body's variables are exactly V 0 .. V (arity-1), which is the
--     `Definition` contract that `Certificate.render` relies on;
--   * the body and the fold agree on the whole grid [0..8]^arity, by exact
--     Integer evaluation -- the same `ruleCounterexample` the invention
--     gate already uses, pointed here at the emitter.  One disagreeing
--     assignment is a proof of mismatch and costs nothing.
--
-- The third is the one that answers GateAudit section B: it is a finite
-- exhaustive verification that what the kernel is told `c0` means is what
-- this engine computes when it evaluates `c0`.
certDefinitions :: [Sym] -> [C.Definition]
certDefinitions syms =
  [ C.Definition (symName s) (symArity s) (toCert body)
  | s <- syms
  , Just (body, fold) <- [conceptRule s]
  , fold == F (symName s) (map V [0 .. symArity s - 1])
  , ordNub (sort (vars body)) == [0 .. symArity s - 1]
  -- `vocabulary ++` because a concept's body is built FROM the primitives
  -- (`mentionsPrimitive` in `bestOf` requires at least one), while the
  -- caller passes only the invented symbols; evaluating `c0 := x*x` against
  -- a semantics holding just `c0` reaches eval's fail-loud boundary.  It
  -- did, on the first run after this check was added, at round 12.
  , isNothing (ruleCounterexample (vocabulary ++ syms)
                 definitionAuditBound (body, fold))
  ]

kernelAccept :: Handle -> Int -> ((Term,Term),String) -> IO Bool
kernelAccept = kernelAcceptWith [] [] []

-- TRACE REPLAY, tried before the shape search.
--
-- `Certificate` certifies by emitting an induction skeleton and SEARCHING
-- the clause bodies, one agda process per attempt.  But the engine already
-- knew the proof: `proveByInduction` succeeded by normalising both clauses
-- and watching every rewrite fire.  `TraceReplay` re-runs that same
-- deterministic normalisation -- same rules, same innermost-leftmost
-- strategy, same reduction order, so it is one function computed twice and
-- not a second search -- and compiles the resulting trace into a path:
-- a rewrite at the root is the rule's lemma instantiated, under a context
-- it is `cong`, right-to-left it is `sym`, a sequence composes with `∙`,
-- and the induction hypothesis is the structural recursive call.
--
-- It returns Nothing, and the search runs unchanged, whenever a fired rule
-- has no name in the lemma environment -- which today means anything
-- outside the defining equations of + and *, including a theorem the
-- engine proved using an EARLIER theorem.  Widening that environment is
-- the next increment and is described in TraceReplay.replayContract.
--
-- Soundness does not rest on any of this.  The emitted module goes through
-- the same cached agda invocation as everything else; replay only changes
-- WHICH module is offered, never whether the kernel is asked.
toTR :: Term -> TR.Term
toTR (V i) = TR.V i
toTR (F f ts) = TR.F f (map toTR ts)

tryReplay :: [(Term,Term)] -> [Rule] -> ((Term,Term),String) -> IO (Maybe Int)
tryReplay known rules ((l,r),proofNote) =
  case C.inductionVariable proofNote of
    Nothing -> pure Nothing
    Just v ->
      let cited = [ ((toTR a, toTR b), "lem" ++ show i)
                  | (i, (a,b)) <- zip [(0::Int)..] known ]
      in case TR.replayWithRules cited
                                 (map (\(a,b) -> (toTR a, toTR b)) rules)
                                 (toTR l, toTR r) v "Candidate" of
        Nothing -> pure Nothing
        Just source -> do
          (code, _out, calls) <- C.runAgdaCached "." source
          case code of
            ExitSuccess -> pure (Just calls)
            ExitFailure _ -> pure Nothing

kernelAcceptWith :: [Sym] -> [(Term,Term)] -> [Rule] -> Handle -> Int
                 -> ((Term,Term),String) -> IO Bool
kernelAcceptWith invented known rules logh roundNo cand@((l,r),proofNote) = do
  replayed <- tryReplay known rules cand
  case replayed of
    Just calls -> do
      hPrintf logh "  KERNEL-ACCEPT round=%d %s = %s  (trace replay, %d agda calls)\n"
        roundNo (show l) (show r) calls
      pure True
    Nothing -> kernelAcceptSearch invented logh roundNo ((l,r),proofNote)

kernelAcceptSearch :: [Sym] -> Handle -> Int -> ((Term,Term),String) -> IO Bool
kernelAcceptSearch invented logh roundNo ((l,r),proofNote) = do
  verdict <- C.certifyWith (certDefinitions invented) "."
               ((toCert l, toCert r), proofNote)
  case verdict of
    C.Certified shape calls -> do
      hPrintf logh "  KERNEL-ACCEPT round=%d %s = %s  (%s, %d agda calls)\n"
        roundNo (show l) (show r) shape calls
      pure True
    C.Rejected err calls -> do
      hPrintf logh "  KERNEL-REJECT round=%d %s = %s  (%d agda calls) %s\n"
        roundNo (show l) (show r) calls (take 160 (filter (/= '\n') err))
      pure False
    C.Untranslatable why -> do
      hPrintf logh "  KERNEL-SKIP  unsupported fragment: %s = %s  (%s)\n"
        (show l) (show r) why
      pure False

kernelAcceptLegacy :: Handle -> Int -> ((Term,Term),String) -> IO Bool
kernelAcceptLegacy logh roundNo ((l,r),_) =
  case agdaCertificate (l,r) of
    Nothing -> do
      hPrintf logh "  KERNEL-SKIP  unsupported fragment: %s = %s\n" (show l) (show r)
      pure False
    Just sourceFor -> do
      -- WHERE THE CANDIDATE HAS TO LIVE, and why this was rewritten.
      --
      -- This gate used to write the candidate to a private directory under
      -- /tmp and run `agda -i formal/cubical -i <dir> <file>`.  That never
      -- compiled ANYTHING: `-i` adds include paths but does not make Agda
      -- read a library, so every candidate died on `Failed to find source
      -- of module Cubical.Foundations.Prelude` and was logged as a
      -- KERNEL-REJECT indistinguishable from a false statement.  The engine
      -- has therefore been rejecting all of its own output on a path error,
      -- which is why machine/library.txt stopped growing and why every run
      -- reports proved=0.  Found 2026-08-15 by reading the reject text
      -- instead of the count.
      --
      -- Agda finds `cubical` through the .agda-lib in formal/cubical, so
      -- the candidate must be checked FROM that directory.  The module
      -- therefore gets a unique name and lives there for the length of one
      -- check.  Uniqueness matters: concurrent machine processes would
      -- otherwise overwrite each other's proposition between write and
      -- check, which is the hazard the old /tmp directory was guarding
      -- against.
      nameLine <- readProcess "mktemp" ["-u", "Candidate_XXXXXX"] ""
      let modName = filter (\c -> isAlphaNum c || c == '_')
                      (reverse (dropWhile isSpace (reverse nameLine)))
          file = "formal/cubical" </> (modName ++ ".agda")
          source = sourceFor modName
      (do writeFile file source
          (code,out,err) <- readProcessWithExitCode "sh"
            ["-c", "cd formal/cubical && LC_ALL=C.UTF-8 agda " ++ modName ++ ".agda"] ""
          case code of
            ExitSuccess -> do
              hPrintf logh "  KERNEL-ACCEPT round=%d %s = %s\n"
                roundNo (show l) (show r)
              pure True
            ExitFailure _ -> do
              hPrintf logh "  KERNEL-REJECT round=%d %s = %s  %s\n"
                roundNo (show l) (show r) (take 160 (filter (/= '\n') (out ++ err)))
              pure False)
        `finally` (removePathForcibly file
                   >> removePathForcibly ("formal/cubical/_build/2.6.3/agda/"
                                          ++ modName ++ ".agdai"))

-- --------------------------------------------------------- the machine

data Machine = Machine
  { mRules   :: [Rule]        -- proved equations, working as operations
  , mLemmas  :: [(Term,Term)] -- proved but unorientable (e.g. commutativity)
  , mKnown   :: M.Map (Term,Term) ()  -- everything already stated
  , mInvented :: [Sym]        -- concepts the machine named for itself
  , mRetired :: [Term]        -- patterns it named, never used, and withdrew
  , mFailed  :: M.Map (Term,Term) Int  -- conjecture -> rule count when it failed
  , mThoughts :: [(Term,Term)] -- researcher candidates, as native terms
  , mResiduals :: [String]     -- exact lines not promoted to equations
  , mVocab   :: Int           -- how many symbols are in play
  , mSize    :: Int           -- current term-size horizon
  , mRound   :: Int
  , mBoundedSearches :: [BoundedSearch]
  , mAtlases :: [FiniteAtlas]
  , mDSOTasks :: [DSOTask]
  , mDSOArchitectureSearches :: [(DSOTask,[DSOArchitectureCandidate])]
  , mHistoryArchitectureSearches :: [(Int,[Int],HistoryDemand)]
  -- ∂ of the previous round: what it stated and did not close.  The growth
  -- rule below reads this, not a boolean.  (NaturalMachine.KFlow)
  , mObstruction :: Int
  -- how many random assignments the fingerprint is computed on.  It was a
  -- constant, which made the gate's advice ("enlarge the test set, not the
  -- term space") impossible to take.  ChuDefect.defect-mono says adding
  -- tests can only increase the defect, so this is the axis to move when
  -- the tests stop separating.
  , mAssign :: Int
  -- observed term count at each (vocab,size) the machine has actually been
  -- in.  This is the weight field of the cost geometry: an equivalence
  -- between two presentations does not determine it, so it is recorded and
  -- never derived.  (NaturalMachine.CostGeometry, NaturalMachine.Residual)
  , mCosts :: M.Map (Int,Int) Int
  -- the live knob set, read from machine/knobs.conf at startup by
  -- machine/Knobs.hs.  The constants at the top of this file are now only
  -- the DEFAULTS, and an absent conf reproduces them exactly.
  , mKnobs :: K.Knobs
  }

-- ===================================================================
-- THE THREE DECISION RULES, EACH CITING THE THEOREM IT IMPLEMENTS.
--
-- Until 2026-08-15 this loop grew on a boolean — "the round proved
-- nothing" — with no measure, no gate, and a fixed ladder.  All three
-- replacements are instances of statements checked in
-- formal/cubical/NaturalMachine/; the Agda is the proof and what follows
-- is the engine.  Where the Haskell cannot supply a hypothesis the Agda
-- needs, it is named in a comment rather than assumed away.
-- ===================================================================

-- The model of these three rules is NaturalMachine.MachineLoop, checked
-- against the same library, and each rule below names the theorem it
-- implements.  The model constrains exactly these decisions; it says
-- nothing about the prover, the term generator, or the fingerprint's
-- computation.
--
-- (1) KFlow's trichotomy.  ∂ is ℕ-valued, the step is classified by its
-- sign, and growth is a response to resonance rather than to silence.
-- MachineLoop.flow-total and .flow-unique: the classification is total
-- and the three verdicts are mutually exclusive.
-- MachineLoop.decay-closes-without-growth: a decaying loop reaches ∂ = 0
-- in finitely many rounds, so decay needs no growth.
-- MachineLoop.branching-never-closes: a branching loop never reaches 0,
-- which is why growth is not the answer to branching either.
-- MachineLoop.resonance-round-is-bit-identical: at resonance the orbit is
-- the point, so only a change of what is being looked at can move it.
data Flow = Decay | Resonance | Branching deriving (Eq)

flowName :: Flow -> String
flowName Decay     = "decay"
flowName Resonance = "resonance"
flowName Branching = "branching"

-- KFlow.decay / KFlow.resonance / KFlow.branching.  Total and mutually
-- exclusive by construction, which is the content of the Agda trichotomy.
flowOf :: Int -> Int -> Flow
flowOf before after
  | after < before  = Decay
  | after == before = Resonance
  | otherwise       = Branching

-- (2) ChuAdvance/ChuDefect.  The fingerprint classes ARE a Chu space: the
-- objects are normalised terms, the tests are the assignments, and the
-- defect is the number of pairs some assignment separates.  ChuDefect
-- proves this count is monotone in the test list, so a small defect is a
-- statement about the assignments and NOT about the terms — and
-- ChuAdvance.zero-defect-is-not-truth is the empty-test-list extreme.
-- Hence the gate below: never grow on a collapsed test set, because the
-- terms would look identical no matter what they are.
-- MachineLoop.do-not-grow-on-a-collapsed-test-set is that rule, and
-- MachineLoop.defect-monotone-in-assignments is why it is not paranoia.
-- MachineLoop.agree→same-fingerprint is the bridge from this engine's
-- Value-valued fingerprint to the Bool-valued Chu observation, and it
-- carries an explicit proviso: the probe list must contain the term's own
-- reading.  This engine supplies that by construction, since `envs` is
-- exactly the list the fingerprint is computed on.
separatedPairs :: [[Term]] -> Int
separatedPairs classes =
  let n      = sum (map length classes)
      inside = sum [ c * (c - 1) | cls <- classes, let c = length cls ]
  in (n * (n - 1) - inside) `div` 2

data Gate = Advance | Refused String

gateName :: Gate -> String
gateName Advance     = "advance"
gateName (Refused w) = "refused: " ++ w

-- AdvanceGate's separation clause, the one this loop can discharge
-- honestly.  Verification is the induction gate, provenance is the
-- append-only library, and the declared boundary is kSizeCap; those three
-- are structural.  Separation is the one that can silently fail.
--
-- UNREACHABLE, AND NOT FOR THE REASON THE MEASUREMENT GIVES.  Every run in
-- machine/LOOP_MEASUREMENT.md reports `GATE refusals=0`, and §8 there
-- explains it as a fact about the test set -- "reaching the refusing branch
-- needs a deliberately small kAssign, not a longer run".  That is wrong,
-- and shrinking kAssign will not do it.  The third clause is dead for a
-- structural reason instead:
--
--   `mAssign` starts at `kAssign`, whose range in machine/knobs.conf has a
--   SEMANTIC floor of 1, so `envs` is never empty.  `vocabulary` begins
--   "0", "s", so for any mVocab >= 2 and any mSize >= 2 the generated
--   terms include both `0` and `s 0`, whose normal forms are distinct
--   (that is soundness) and which therefore both survive into `normed`.
--   `eval` sends them to 0 and 1 under EVERY assignment, so they lie in
--   different fingerprint classes, so `separatedPairs >= 1`.  Hence
--   `nNormed > 1 && sepP == 0` is unsatisfiable at any budget and at any
--   in-range knob setting.
--
-- The rule is therefore wiring, not behaviour, and is left in place
-- deliberately: it is the honest response to a state the machine could
-- enter if the term generator ever stopped emitting a closed term of each
-- of two distinct values (a `kVars`-only generator, a semantics valued in
-- a one-element type).  Do not read `refusals=0` as evidence that the
-- separation clause has been tested.  It has not been, in either branch.
advanceGate :: Int -> Int -> Gate
advanceGate nNormed sepP
  | nNormed <= 1 = Advance                       -- nothing to separate
  | sepP > 0     = Advance
  | otherwise    = Refused "assignments separate nothing"

-- (3) Residual's Γ↝, min-plus over neighbouring presentations.  A growth
-- move is a neighbour; its route is the term count last OBSERVED at the
-- state it leads to; staying is always in the list, so the chooser is
-- never worse than staying (Residual.Γ↝-never-worse) and a strict win
-- exhibits a listed move (ResidualPath.Γ↝-sound-member).  With no
-- recorded cost for a move there is no route, and the machine falls back
-- to the ladder below rather than guessing a weight.
-- MachineLoop.choose-never-worse and .choose-exhibits-listed-move are the
-- two statements this implements; .choose-optimal and .choose-greatest
-- together pin the value as the minimum rather than merely below it.
data Move = Widen | Deepen deriving (Eq)

moveName :: Move -> String
moveName Widen  = "widen"
moveName Deepen = "deepen"

-- UNREACHABLE BY CONSTRUCTION -- this function returns `Nothing` on every
-- call, in every run, at every budget.  machine/LOOP_MEASUREMENT.md §8 and
-- §11 report `ROUTE firings=0` and put it down to accumulation ("fifteen
-- rounds do not accumulate one", "either seed mCosts or establish that 15
-- rounds cannot produce one").  No number of rounds can produce one, and
-- the argument is three lines:
--
--   1. `mCosts` is written in exactly one place, `mCosts = M.insert
--      (mVocab m, mSize m) nRaw (mCosts m)`.  Its key set is therefore
--      precisely the set of states the machine has OCCUPIED.
--   2. `mVocab` and `mSize` are only ever incremented (the growth ladder
--      below and the retirement fallback; nothing decrements either), so
--      the occupied set is a monotone staircase in (vocab, horizon).
--   3. The two states probed here, (vocab+1, horizon) and (vocab,
--      horizon+1), are strictly ahead of the current state on that
--      staircase.  A monotone path has not visited its own future, so both
--      lookups miss, the list is empty, and the guard returns `Nothing`.
--
-- The min-plus chooser is thus wiring rather than behaviour, and the
-- ladder decides every growth move the machine has ever made.  It is left
-- in place rather than deleted because the fix is a real one and belongs
-- to whoever wrote it: give the weight field the neighbours' costs, not
-- only the occupant's -- `length (genTermsModulo … sig nv (mSize m + 1))`
-- and the same at `mVocab m + 1` -- and the rule becomes live.  That costs
-- two extra enumerations a round, which at horizon 7 is the dominant cost
-- of the round, so it is a decision and not a typo.  Until someone takes
-- it, read `ROUTE firings=0` as "never consulted", not as "consulted and
-- declined".
--
-- Consequence for the A/B harness: `--baseline-variant old-flow` is a
-- single-factor control only while this holds, and by the argument above
-- it holds unconditionally.  (machine/run-loop-ab.sh's own note says the
-- same thing conditionally.)
gammaRoute :: M.Map (Int,Int) Int -> Int -> Int -> Maybe (Move,Int,Int)
gammaRoute costs vocab horizon =
  case [ (mv,c) | (mv,st) <- [(Widen,(vocab+1,horizon)),(Deepen,(vocab,horizon+1))]
                , Just c <- [M.lookup st costs] ] of
    []     -> Nothing
    routes ->
      let (mv,c) = minimumOn snd routes
          stay   = M.findWithDefault maxBound (vocab,horizon) costs
      in if c < stay then Just (mv,c,stay) else Nothing
  where
    minimumOn f = foldr1 (\a b -> if f a <= f b then a else b)

squareThresholdSearch :: BoundedSearch
squareThresholdSearch = BoundedSearch [0..20] (\n -> n * n >= 30)
  (Just (Coverage 12))

start :: Machine
start = Machine [] [] M.empty [] [] M.empty [] [] 3 4 0
  [squareThresholdSearch] [endianAtlas2]
  [boundedDSOTask "square-threshold" squareThresholdSearch]
  [(boundedDSOTask "square-threshold" squareThresholdSearch,
    boundedArchitectures "square-threshold" squareThresholdSearch)]
  [(4,[2],SnapshotDemand [2])]
  0 (K.kAssign K.defaultKnobs) M.empty K.defaultKnobs

-- CONCEPT INVENTION.  A machine whose vocabulary is a list somebody
-- else typed can only ever compress the consequences of that list; when
-- the consequences run out it is finished, and every genuinely new idea
-- in its life came from outside.  So it must be able to name things.
--
-- The criterion is description length: take the shapes that keep
-- recurring across the terms the machine actually works with, and give
-- a name to the one that would shorten the most.  `double` and `square`
-- are not primitive to arithmetic — they are the names worth having
-- because x+x and x*x keep showing up.  A named concept enters the
-- vocabulary with its defining equation, so everything downstream can
-- reason about it, and it is given the lowest precedence so that
-- rewriting FOLDS into it: the machine's own abbreviation becomes the
-- normal form.
patternsOf :: Term -> [Term]
patternsOf t = [ p | p <- subterms t, size p >= 3, size p <= 5
                   , not (null (vars p)), length (ordNub (vars p)) <= 2 ]
  where
    subterms u@(F _ ts) = u : concatMap subterms ts
    subterms u = [u]

symbolsIn :: Term -> [String]
symbolsIn (V _) = []
symbolsIn (F f ts) = f : concatMap symbolsIn ts

canonTerm :: Term -> Term
canonTerm t = applySub ren t
  where ren = M.fromList (zip (ordNub (vars t)) (map V [0..]))

inventConcept :: [Sym] -> [Term] -> [Term] -> Int -> Maybe Sym
inventConcept syms retired terms n =
  case best of
    []        -> Nothing
    ((p,_):_) ->
      let vs = ordNub (vars p)
          ar = length vs
          nm = "c" ++ show n
          sem = semantics syms
      in Just (Sym nm ar (\args -> eval sem args p)
                 [ (p, F nm (map V [0 .. ar-1])) ])
  where
    best = bestOf syms retired terms

conceptRule :: Sym -> Maybe Rule
conceptRule s = case symDefs s of
  [r] -> Just r
  _   -> Nothing

-- candidate concepts, best first: how often a shape appears times how
-- much naming it would save.  A shape already named is not a new idea.
bestOf :: [Sym] -> [Term] -> [Term] -> [(Term,Int)]
bestOf syms retired terms =
    take 1 (sortOn (\(p,c) -> negate (c * (size p - 1)))
             [ pc | pc@(p,c) <- counts, c >= kConceptMinDefault, headIsNotFresh p
                  , not (alreadyNamed p), not (trivialApp p)
                  , mentionsPrimitive p
                  , canonTerm p `notElem` retired ])
  where
    -- A TOWER IS NOT A THOUGHT.  With the description-length gate live,
    -- the machine's first name was `c0 := x+x` — exactly the `double`
    -- this code was written to hope for.  Its second was `c1 := c0(c0(x))`,
    -- its third `c2 := c1(c0(x))`, and so on: 2x, 4x, 8x, forever, each
    -- one shortening the probe and each one proving nothing.
    --
    -- That is not a threshold that needs raising, it is the gate being
    -- the wrong shape.  Description length ALWAYS improves under
    -- composition — naming f∘g saves a symbol at every occurrence, for
    -- any f and g — so no bound on compression can rule out the tower.
    -- The constraint has to be about content: a pattern assembled purely
    -- from names the machine already has contains no operation that was
    -- not already named.  It is a re-abbreviation.
    --
    -- So: concepts may appear INSIDE a pattern (the Lovelace point above
    -- stands — abstraction must be able to stack), but the pattern must
    -- contribute at least one primitive of its own.  c0(x)+x is a new
    -- function; c0(c0(x)) is c0 said twice.
    mentionsPrimitive p =
      any (`elem` map symName vocabulary) (symbolsIn p)
    counts = M.toList (M.fromListWith (+)
               [ (canonTerm p, 1::Int) | t <- terms, p <- patternsOf t ])
    -- Lovelace: rejecting c-headed patterns caps the tower of
    -- abstraction at height one — a concept could appear beneath a head
    -- but never as one, so no concept is ever built from concepts.
    headIsNotFresh (F _ _) = True
    headIsNotFresh _ = False
    -- f(x,y) is not a concept, it is f with a costume on.  A name earns
    -- its place by capturing structure the signature cannot say in one
    -- application: a repeated argument (x+x), or nesting (s(x+x)).
    trivialApp (F _ args) =
      all isVar args && length (ordNub (concatMap vars args)) == length args
      where isVar (V _) = True
            isVar _ = False
    trivialApp _ = True
    alreadyNamed p =
      any (\s -> any ((== canonTerm p) . canonTerm . fst) (symDefs s)) syms

-- ordered rewriting lets unorientable theorems (commutativity) still be
-- used: apply them only in the direction that decreases the term.
lemmaRules :: [(Term,Term)] -> [Rule]
lemmaRules = concatMap (\(a,b) -> [(a,b),(b,a)])

-- What the machine may use to reason: the defining equations of the
-- symbols currently in play, everything it has proved and oriented, and
-- its unorientable theorems applied only in the decreasing direction.
usableRules :: Machine -> [Rule]
usableRules m =
  -- Grothendieck: the invented symbols' OWN defining equations were
  -- missing here, while `round1` put those symbols into the term space
  -- and the fingerprint.  So every concept the machine named for itself
  -- became exactly the black box this file's header warns about — it
  -- could compute with it and never unfold it.  The bug documented for
  -- `gcd` at the top, reintroduced for the machine's own ideas.
  definitionsOf (take (mVocab m) vocabulary ++ mInvented m)
    ++ mRules m
    ++ lemmaRules (mLemmas m)

provedCommutative :: Machine -> [String]
provedCommutative m =
  [ symName s
  | s <- take (mVocab m) vocabulary ++ mInvented m
  , symArity s == 2
  , any (isCommutativity (symName s)) (M.keys (mKnown m)) ]

isCommutativity :: String -> (Term,Term) -> Bool
isCommutativity f (F g [V a,V b], F h [V c,V d]) =
  f == g && g == h && a /= b && a == d && b == c
isCommutativity _ _ = False

provedAssociative :: Machine -> [String]
provedAssociative m =
  [ symName s
  | s <- take (mVocab m) vocabulary ++ mInvented m
  , symArity s == 2
  , any (isAssociativity (symName s)) (M.keys (mKnown m)) ]

isAssociativity :: String -> (Term,Term) -> Bool
isAssociativity f equation = forward equation || forward (swap equation)
  where
    swap (a,b) = (b,a)
    forward (F g [F g' [V a,V b],V c],
             F h [V d,F h' [V e,V k]]) =
      f == g && g == g' && g == h && h == h'
      && a == d && b == e && c == k
      && length (ordNub [a,b,c]) == 3
    forward _ = False

-- ===================================================================
-- DISPATCH.  What the engine is allowed to use, as data.
--
-- Several modules built in this session (machine/ArithVocab.hs,
-- machine/DSO.hs, machine/NestedInduction.hs) were written standalone because
-- this file was owned by another concern.  They are wired in here.  The
-- governing constraint is that the loop is LIVE: a bad wire must not be able
-- to change what a running machine does.  So every wire is a field of this
-- record, and `defaultDispatch` is chosen so that the engine with it is the
-- engine before this edit -- not approximately, but by inspection:
--
--   dVocabCap    = baseVocabCap  -> `take (mVocab m) vocabulary` cannot reach
--                                   past `le`, and the ladder stops where it
--                                   stopped.  No new symbol exists.
--   dVocabStart  = Nothing       -> the startup vocabulary is exactly
--                                   `requiredVocabulary batch` as before
--                                   (then clamped, which at the default cap
--                                   is a no-op: the old value was already
--                                   <= 8 because `vocabulary` had 8 entries).
--   dDsoSchedule = 0             -> `fresh` keeps its smallest-first order.
--   dNestedDepth = 0             -> `proveByInduction` is the only prover.
--   dRounds      = Nothing       -> the loop does not halt.
--
-- Nothing here can make an unsound theorem installable: every wire feeds the
-- same kernel gate, and the gate is the authority.  What the wires change is
-- WHAT IS ASKED, never what is believed.
data Dispatch = Dispatch
  { dVocabCap    :: Int          -- how far into `vocabulary` the engine reaches
  , dVocabStart  :: Maybe Int    -- override the initial mVocab
  , dDsoSchedule :: Int          -- 0 = off; else DSO-order this many conjectures
  , dNestedDepth :: Int          -- 0 = off; else NestedInduction budget
  , dRounds      :: Maybe Int    -- Nothing = forever (the live default)
  , dLog         :: Maybe FilePath  -- smoke-mode log sink; Nothing = /dev/null
  } deriving (Eq, Show)

defaultDispatch :: Dispatch
defaultDispatch = Dispatch baseVocabCap Nothing 0 0 Nothing Nothing

-- 2^n memoised states in `D.optimalSchedule`, and n * 2^n cost evaluations,
-- each of which normalises two terms.  This is a hard ceiling, not a taste:
-- at n = 12 the scheduler already does ~49k normalisations per round.
kDsoScheduleCap :: Int
kDsoScheduleCap = 12

parseDispatch :: [String] -> Either String (Dispatch, [String])
parseDispatch = go defaultDispatch []
  where
    go d rest [] = Right (d, reverse rest)
    go d rest (flag:more) = case (flag, more) of
      ("--vocab-cap", v:ms)    -> withNat v ms (\n -> d { dVocabCap = min n (length vocabulary) })
      ("--vocab-start", v:ms)  -> withNat v ms (\n -> d { dVocabStart = Just n })
      ("--dso-schedule", v:ms) -> withNat v ms (\n -> d { dDsoSchedule = min n kDsoScheduleCap })
      ("--nested-depth", v:ms) -> withNat v ms (\n -> d { dNestedDepth = n })
      ("--rounds", v:ms)       -> withNat v ms (\n -> d { dRounds = Just n })
      ("--log", v:ms)          -> go (d { dLog = Just v }) rest ms
      -- the whole arithmetic vocabulary, in one word
      ("--arith", ms)          -> go (d { dVocabCap = length vocabulary }) rest ms
      _                        -> go d (flag:rest) more
      where
        withNat v ms f = case parseNaturalInt v of
          Just n  -> go (f n) rest ms
          Nothing -> Left (flag ++ " requires a nonnegative integer, got " ++ show v)

-- ---------------------------------------------------------- WIRE 2: DSO
--
-- machine/DSOSchedule.hs measured, on a fixed +/x law family, that the
-- DSO-ordered schedule discharges the same conjectures in fewer total rewrite
-- steps than declaration order; its engine is machine/DSO.hs, whose
-- `optimalSchedule` is the meta-Bellman V(D) = min_a (cost(a|D) + V(D u {a}))
-- memoised over the whole 2^n dependency lattice -- an exhaustive optimum, not
-- a heuristic.  That module hard-codes its family.  This wire supplies the
-- LIVE family instead: the round's own `fresh` conjectures.
--
-- WHAT THE COST MODEL IS, EXACTLY.  `spCost i proved` is the number of rewrite
-- steps `normalize` takes to reduce both sides of conjecture i, given the
-- current rule set PLUS the rules that the conjectures in `proved` would
-- install if they were discharged first (`orient`, or the two-way lemma pair
-- when unorientable -- the same construction the round's own `attempt` fold
-- uses).  So this is not a stipulated cost table: it is a count of steps this
-- engine's own `step` function performs, computed twice for the same reason
-- TraceReplay recomputes a normalisation.
--
-- TWO THINGS THE MODEL DOES NOT SAY, stated here rather than discovered later.
-- (i) It does not model the cost of proof SEARCH or of the agda call, which
-- dominate a round; ordering by it is a claim about rewrite work only, and the
-- log line says so.  (ii) `cost(a|D)` charges as if every conjecture in D had
-- been DISCHARGED, and the round's own fold only installs the ones that
-- actually prove, kernel included.  So the reported optimum is the optimum of
-- a schedule in a world where every attempt succeeds; it is an exact number
-- about that world and a lower bound on rewrite work in this one.  This is why
-- the wire may only permute the attempt ORDER and can never, by construction,
-- decide what is believed.
--
-- Restricted to the first `k <= 12` conjectures (already the smallest ones,
-- since `fresh` arrives size-sorted) because the lattice is 2^k.  The tail
-- keeps its existing order, so the wire is a permutation of a prefix.
conjectureEnablers :: (Term,Term) -> [Rule]
conjectureEnablers c = case orient c of
  Just r  -> [r]
  Nothing -> lemmaRules [c]

dsoScheduleProblem :: [Rule] -> [(Term,Term)] -> D.SchedProblem
dsoScheduleProblem rules cs = D.SchedProblem (length cs) cost
  where
    arr = cs
    cost i proved =
      let enabled = concat [ conjectureEnablers (arr !! j)
                           | j <- [0 .. length arr - 1]
                           , j /= i, D.hasItem proved j ]
          rs = enabled ++ rules
          (l,r) = arr !! i
      in snd (normalizeSteps rs l) + snd (normalizeSteps rs r)

-- Returns the reordered conjecture list and, when the wire fired, the
-- (declaration-order cost, optimal cost) pair for the log.
dsoReorder :: Int -> [Rule] -> [(Term,Term)] -> ([(Term,Term)], Maybe (Integer,Integer))
dsoReorder k rules fresh0
  | k <= 1 || length front <= 1 = (fresh0, Nothing)
  | otherwise = (map (front !!) order ++ back, Just (naive, best))
  where
    (front, back) = splitAt (min k kDsoScheduleCap) fresh0
    problem = dsoScheduleProblem rules front
    (best, order) = D.optimalSchedule D.totalSemiring problem
    naive = fst (D.orderCost D.totalSemiring problem [0 .. length front - 1])

-- ------------------------------------------------ WIRE 3: nested induction
--
-- machine/NestedInduction.hs is a standalone prover for the case this file's
-- `proveByInduction` cannot reach: an equation whose base or step case is
-- itself an equation needing an induction of its own (the distributivity
-- class).  It carries its own copy of this Term algebra and rewrite engine,
-- so the bridge is again a relabelling of constructors.
--
-- It is tried only AFTER `proveByInduction` has failed, so with the wire on,
-- every proof the engine used to find it still finds, by the same route.  A
-- nested proof is reported with the OUTER induction variable in the standard
-- note format, because that is what `Certificate.inductionVariable` reads;
-- whether the kernel can then discharge the resulting skeleton is the
-- kernel's business, and a failure there is a KERNEL-REJECT, not an install.
toNI :: Term -> NI.Term
toNI (V i) = NI.V i
toNI (F f ts) = NI.F f (map toNI ts)

niProofNote :: NI.Proof -> Maybe String
niProofNote (NI.Rewrite _) = Nothing   -- rewriting alone; `attempt` already tried it
niProofNote (NI.Induct v _ _ _) =
  Just ("induction on " ++ show (V v) ++ " (nested)")

nestedProve :: Int -> [Rule] -> (Term,Term) -> Maybe String
nestedProve budget rs (l,r)
  | budget <= 0 = Nothing
  | otherwise =
      NI.prove budget 0 [ (toNI a, toNI b) | (a,b) <- rs ] (toNI l, toNI r)
        >>= niProofNote

round1 :: Dispatch -> Maybe FilePath -> Handle -> Handle -> IORef Machine -> IO ()
round1 disp mem logh libh ref = do
  m <- readIORef ref
  t0 <- getCPUTime
  let syms = take (mVocab m) vocabulary ++ mInvented m
      sig = arities syms
      sem = semantics syms
      nv = K.kVars (mKnobs m)
      envs = assignments nv (mAssign m)
      rules = usableRules m
      raw = genTermsModulo (provedCommutative m) (provedAssociative m)
              sig nv (mSize m)
      -- knowledge pays here: everything already known collapses
      normed = ordNub (map (normalize rules) raw)
      classes = M.elems (M.fromListWith (++)
                  [ (fingerprint sem envs t, [t]) | t <- normed ])
      conjectures = ordNub
        ( [ canonVars (rep, other)
          | cls <- classes
          , length cls > 1
          , rep:others <- [sortOn (\t -> (size t, t)) cls]
          , other <- others
          ]
        ++ [ canonVars (l,r)
           | (l,r) <- mThoughts m
           , all (`elem` map symName syms) (symbolsIn l ++ symbolsIn r)
           , wellFormedTerm syms l
           , wellFormedTerm syms r
           , fingerprint sem envs l == fingerprint sem envs r ] )
      -- rewriting settles the ones already implied by what we know
      -- a theorem is stated once, ever: a machine that keeps rediscovering
      -- what it wrote down last round is not learning, it is looping
      -- A conjecture that failed is not retried until the machine knows
      -- something it did not know then.  Without this the same hundreds
      -- of failures are re-derived and re-attempted every round for the
      -- life of the process — the largest cost centre there is, and it
      -- is spent on questions already asked.
      nRules = length rules
      -- ORDER MATTERS, and it was hash order.  `conjectures` comes out of
      -- a Map keyed on fingerprints, so the machine attacked its own
      -- questions in an order determined by a hash function.  The fold
      -- below feeds each proof back in as it goes, so a small general
      -- lemma proved early pays for every later conjecture in the same
      -- round, and proved late pays for none of them — the difference
      -- between finding x+s(y)=s(x+y) before x+y=y+x and after it.
      -- Smallest first is the only order with that property.
      freshSized = sortOn (\(l,r) -> (size l + size r, l, r))
              [ c | c <- conjectures
                  , not (M.member c (mKnown m))
                  , M.lookup c (mFailed m) /= Just nRules
                  , not (provedByRewriting rules c)
                  , not (congruent rules (mKnown m) c) ]
      -- WIRE 2.  At dDsoSchedule = 0 this is `(freshSized, Nothing)` and the
      -- smallest-first order above is untouched; otherwise the first k are
      -- permuted into the meta-Bellman optimum for total rewrite steps.
      (fresh, dsoStats) = dsoReorder (dDsoSchedule disp) rules freshSized
      -- Proofs must be usable the moment they exist, not next round: a
      -- theorem proved at 10am should already be killing conjectures at
      -- 10:01.  So the round folds its own discoveries back in as it goes.
      probe = strideSample (K.kProbe (mKnobs m)) normed
      -- built once per round, not once per candidate
      normedSet = S.fromList normed
      -- WHERE THE EXACT TEST STOPS BEING AFFORDABLE, stated rather than
      -- discovered.  Measured: at |T| = 3287 the exact decision costs less
      -- than the sample it replaces (0.21s per round against 0.23s) and
      -- takes the library from 15 theorems to 35 in one round.  At
      -- |T| = 24993 it does not finish the round at all -- a rule that fires
      -- widely and collapses nothing normalises thousands of terms before
      -- the scan can answer no, once per proved candidate.  So the exact
      -- test runs where it has been measured to run, the sampled one runs
      -- beyond that, and the round says which answered.  This is a boundary,
      -- not a tuning knob: moving it up without fixing the cost (index the
      -- population by head symbol so `fired` is not a full scan) buys a
      -- stall, and moving it down throws away the theorems.
      exactAffordable = nNormedEstimate <= kExactPopulation
      nNormedEstimate = length normed
      worthInstalling acc c
        | not exactAffordable = marginalPrune acc probe c >= K.kMinPrune (mKnobs m)
        | K.kMinPrune (mKnobs m) <= 1 = collapsesSomething normedSet acc normed c
        | otherwise = exactPrune acc normed c >= K.kMinPrune (mKnobs m)
      -- WHERE THE FRESH CONJECTURES DIE.  The round line reports `proved=`
      -- AFTER the kernel gate, so a round that states twenty thousand fresh
      -- conjectures and reports proved=0 has told the reader nothing about
      -- WHICH stage refused them -- the semantic firewall, the prover, the
      -- marginal-prune test that discards true statements with no
      -- consequences, or the gate.  Those are four different diseases with
      -- four different treatments, and from round 16 of a 70-round run they
      -- are indistinguishable in the log.  Counted here, printed as PROVER.
      (proverStats, results) =
        let zero4 = (0, 0, 0, 0) :: (Int, Int, Int, Int)
            (_, out, st) = foldl' attempt (rules, [], zero4) fresh
        in (st, reverse out)
      bounded = map executeBoundedSearch (mBoundedSearches m)
      witnessBranches = sum (map (length . activeWitnesses) bounded)
      derivationBranches = sum (map (length . derivationFiber) bounded)
      atlases = map compileAtlas (mAtlases m)
      atlasRaw = sum (map assignmentBranches atlases)
      atlasFixed = sum (map (toInteger . length . coherentFamilies) atlases)
      atlasTears = sum (map (length . holonomyFailures) atlases)
      dsoCompiled =
        [ compileDSO (dsoTaskDependencies task)
            (dsoTaskContinuations task) (dsoTaskRoutes task)
        | task <- mDSOTasks m ]
      dsoRoutes = sum (map (length . dsoTaskRoutes) (mDSOTasks m))
      dsoClassesN = sum (map (length . dsoClasses) dsoCompiled)
      dsoSurvivorsN = sum (map (length . dsoSurvivors) dsoCompiled)
      dsoRawWork = sum (map dsoRawEvaluations dsoCompiled)
      dsoActiveWork = sum (map dsoActiveEvaluations dsoCompiled)
      dsoWitnessFiber = sum
        [ sum (map (length . dsoWitnesses) (dsoSurvivors compiled))
        | compiled <- dsoCompiled ]
      historyArchitectureResults =
        [ compileHistoryArchitectures mFactors checkpoints demand
        | (mFactors,checkpoints,demand) <- mHistoryArchitectureSearches m ]
      architectureResults =
        [ compileDSOArchitectures (dsoTaskDependencies task)
            (dsoTaskContinuations task) candidates
        | (task,candidates) <- mDSOArchitectureSearches m ]
        ++ map snd historyArchitectureResults
      architectureCandidatesN = sum (map (length . dsoArchitectureCosts) architectureResults)
      architectureParetoN = sum (map (length . dsoParetoArchitectures) architectureResults)
      architectureEquivalencesN = sum (map (length . dsoEquivalentArchitectures) architectureResults)
      architectureRegretStates = sum
        [ states | result <- architectureResults, (_, (states,_)) <- dsoArchitectureRegret result ]
      architectureRegretWork = sum
        [ work | result <- architectureResults, (_, (_,work)) <- dsoArchitectureRegret result ]
      retainedHistoryFibre = sum
        [ sum [sum (map length (historyFibres architecture))
              | architecture <- adequate
              , historyArchitectureName architecture `elem` dsoParetoArchitectures result]
        | (adequate,result) <- historyArchitectureResults ]
      attempt (acc, out, st@(nRewritten, nFirewall, nNoProof, nInert)) c
        | provedByRewriting acc c = (acc, out, (nRewritten + 1, nFirewall, nNoProof, nInert))
        -- Proof search is only as trustworthy as its current axiom set and
        -- induction implementation.  This finite gate does not certify a
        -- theorem; it prevents any theorem with a concrete small refutation
        -- from becoming a new axiom and poisoning every later round.
        | not (survivesSemanticFirewall syms c) =
            (acc, out, (nRewritten, nFirewall + 1, nNoProof, nInert))
        | otherwise =
            -- WIRE 3.  `proveByInduction` first, always; the nested prover is
            -- consulted only where it returned Nothing, so no proof this
            -- engine used to find is found by a different route now.  At
            -- dNestedDepth = 0 the second disjunct is `Nothing` immediately.
            case maybe (nestedProve (dNestedDepth disp) acc c) Just
                   (proveByInduction acc c) of
              Nothing -> (acc, out, (nRewritten, nFirewall, nNoProof + 1, nInert))
              Just pf
                -- a proof is not enough: it must also make the world
                -- smaller, or it is a true statement with no consequences
                | not (worthInstalling acc c) ->
                    (acc, out, (nRewritten, nFirewall, nNoProof, nInert + 1))
                | otherwise ->
                    let acc' = acc ++ maybe [] (:[]) (orient c)
                                ++ (if isJust (orient c) then []
                                    else lemmaRules [c])
                    in (acc', (c,pf):out, st)
  -- The timer used to bracket a lazy `let`, so nothing had been computed
  -- when it stopped and every round reported 0.00s.  A dead instrument is
  -- worse than none: it is the one that would have shown the rule set
  -- slowing the machine down.  Force the work before stopping the clock.
  let nRaw = length raw
      nNormed = length normed
      nConj = length conjectures
      nFresh = length fresh
      nRes = length results
  retainedHistoryFibre `seq` architectureRegretWork `seq` architectureRegretStates `seq`
    architectureEquivalencesN `seq` architectureParetoN `seq`
    architectureCandidatesN `seq` dsoWitnessFiber `seq` dsoActiveWork `seq` dsoRawWork `seq`
    dsoSurvivorsN `seq` dsoClassesN `seq` dsoRoutes `seq`
    nRes `seq` nFresh `seq` nConj `seq` nNormed `seq` nRaw `seq` return ()
  checkedResults <- filterM (kernelAcceptWith (mInvented m) (M.keys (mKnown m)) rules logh (mRound m)) results
  t1 <- getCPUTime
  let secs = fromIntegral (t1 - t0) / (1e12 :: Double)
      prunedPct :: Double
      prunedPct = if null raw then 0
                  else 100 * (1 - fromIntegral (length normed)
                                  / fromIntegral (length raw))
      newRules = mapMaybe (orient . fst) checkedResults
      newLemmas = [ c | (c,_) <- checkedResults, not (isJust (orient c)) ]
      m' = m { mRules = mRules m ++ newRules
             , mLemmas = mLemmas m ++ newLemmas
             , mKnown = foldl' (\k (c,_) -> M.insert c () k) (mKnown m) checkedResults
             , mFailed = foldl' (\k c -> M.insert c nRules k) (mFailed m)
                          [ c | c <- fresh, notElem c (map fst checkedResults) ]
             , mRound = mRound m + 1
             -- ∂ of THIS round: stated and not closed.  Read by the next
             -- round's flow classification.
             , mObstruction = obstruction
             -- the gate's own remedy, taken: when the assignments stop
             -- separating, buy more assignments rather than more terms.
             -- Bounded, because an unbounded test set is just a slower
             -- way to be stuck.
             , mAssign = case gate of
                 Advance   -> mAssign m
                 Refused _ -> min (8 * K.kAssign (mKnobs m)) (2 * mAssign m)
             -- the weight this state actually cost, recorded so a later
             -- round can route by it instead of guessing
             , mCosts = M.insert (mVocab m, mSize m) nRaw (mCosts m) }
      -- ∂, the obstruction the round leaves behind: conjectures it stated
      -- and did not close.  ∂ = 0 is QuestionMachine's `Resolves` — the
      -- question at this horizon is answered, so the machine must change
      -- what it is looking at, which is why it counts as resonance.
      (proverRewritten, proverFirewall, proverNoProof, proverInert) = proverStats
      obstruction = nFresh - length checkedResults
      flow | obstruction == 0 = Resonance
           | otherwise        = flowOf (mObstruction m) obstruction
      sepP = separatedPairs classes
      gate = advanceGate nNormed sepP
  forM_ checkedResults $ \((l,r),pf) -> do
    hPrintf libh "%-46s = %-24s   [%s]\n" (show l) (show r) pf
    hPrintf logh "  THEOREM  %s = %s   (%s)\n" (show l) (show r) pf
    -- and the same theorem in the form this program can read back.  The
    -- prose library is for people; this is the machine's own memory.
    case mem of
      Nothing   -> return ()
      Just path -> appendFile path (showTermP l ++ "\t" ++ showTermP r ++ "\n")
  hFlush libh
  -- The four ways a fresh conjecture fails to become a theorem, and the
  -- fifth number is the gate's.  `proved` here is the PROVER's count; the
  -- round line's `proved=` is what survived the kernel.  When they differ
  -- the difference is exactly the KERNEL-REJECT lines above.
  hPrintf logh
    "  PROVER  fresh=%d already-rewritten=%d firewall-refuted=%d no-proof=%d proved-but-inert=%d proved=%d gated=%d value-test=%s\n"
    (length fresh) proverRewritten proverFirewall proverNoProof proverInert
    (length results) (length checkedResults)
    (if exactAffordable then "exact" else "sampled" :: String)
  hPrintf logh "  BOUNDED  active-witnesses=%d derivation-fiber=%d\n"
    witnessBranches derivationBranches
  hPrintf logh "  ATLAS  assignments=%d fixed-base=%d holonomy-failures=%d\n"
    atlasRaw atlasFixed atlasTears
  hPrintf logh "  DSO  tasks=%s routes=%d classes=%d survivors=%d survivor-witnesses=%d continuation-work=%d->%d\n"
    (intercalate "," (map dsoTaskName (mDSOTasks m)))
    dsoRoutes dsoClassesN dsoSurvivorsN dsoWitnessFiber dsoRawWork dsoActiveWork
  hPrintf logh "  DSO-ARCH  candidates=%d transformer-equivalences=%d pareto=%d aggregate-regret=(%d states,%d work)\n"
    architectureCandidatesN architectureEquivalencesN architectureParetoN
    architectureRegretStates architectureRegretWork
  hPrintf logh "  DSO-HISTORY  searches=%d retained-history-fibre=%d\n"
    (length historyArchitectureResults) retainedHistoryFibre
  -- WIRE 2's own instrument.  Both numbers are exact rewrite-step counts under
  -- the model stated at `dsoScheduleProblem`, over the same conjecture set:
  -- declaration (smallest-first) order against the meta-Bellman optimum.
  case dsoStats of
    Nothing -> return ()
    Just (naive,best) ->
      hPrintf logh "  DSO-SCHEDULE  conjectures=%d rewrite-steps size-order=%d dso-optimum=%d saved=%d\n"
        (min (dDsoSchedule disp) (length freshSized)) naive best (naive - best)
  hPrintf logh
    "round %d  vocab=%d size=%d  terms=%d normed=%d pruned=%.1f%%  conj=%d fresh=%d proved=%d  known=%d  %.2fs\n"
    (mRound m) (mVocab m) (mSize m) (length raw) (length normed)
    prunedPct (length conjectures) (length fresh) (length checkedResults)
    (length (mRules m') + length (mLemmas m')) secs
  -- KFlow: the sign of the step in ∂, not the emptiness of a result list.
  hPrintf logh "  FLOW  %s  d %d -> %d\n"
    (flowName flow) (mObstruction m) obstruction
  -- ChuDefect: the defect of the round's own test set.  If this is zero
  -- with more than one term in play, the assignments have stopped
  -- separating and every conjecture below is an artefact of the tests.
  hPrintf logh "  GATE  %s  separated-pairs=%d terms=%d assignments=%d\n"
    (gateName gate) sepP nNormed (length envs)
  hFlush logh
  -- GROW: nothing new means the machine must change what it is looking at
  -- When the machine runs dry it first tries to think of a new idea:
  -- name the shape that keeps recurring in its own working terms.  Only
  -- if it cannot does it fall back to widening the given vocabulary or
  -- looking further out.
  -- The trigger.  It used to be `null checkedResults`: a round that proved
  -- nothing grew, and a round that proved something did not, with no
  -- account of whether the frontier was shrinking.  Both halves of that
  -- were wrong.  A round can prove nothing while ∂ falls (its failures got
  -- memoised, so the next round is strictly cheaper) — growing there is
  -- premature, and it was widening the vocabulary on rounds that were
  -- making progress.  A round can also prove something while ∂ rises,
  -- which is branching and was invisible.  KFlow's classification is the
  -- honest trigger: grow at resonance, not at silence.
  -- Grow at RESONANCE only.  The first version of this rule said "not
  -- decay", which still grows while branching, and the first run with the
  -- instrumentation showed why that is wrong: ten rounds, nothing proved,
  -- ∂ climbing 8 → 42 → 124 → 434 → 1604 → 7769 → 19878 → 31386 → 50978
  -- → 79656, and the machine widening its vocabulary 3 → 8 and its horizon
  -- 4 → 7 straight through it.  Growing while the frontier explodes is the
  -- same pathology the naming rule above already documents (25k → 396k
  -- terms with `proved` flat at zero); KFlow names it `branching`, and the
  -- response to branching is not more room.  Resonance -- ∂ unchanged, or
  -- ∂ = 0, which is QuestionMachine's `Resolves` -- is the only state in
  -- which more room is the answer.
  --
  -- THE FLOW CHOOSES THE AXIS, NOT WHETHER TO GROW.  That paragraph is
  -- right about deepening and was over-applied to widening, and the
  -- over-application is what arm D measured.  Read the evidence again:
  -- every run in it that exploded had the OLD ladder underneath, which
  -- alternated `even (mRound m2)` and therefore spent half of its growth
  -- moves on the horizon.  "Growing while the frontier explodes" was
  -- always, concretely, DEEPENING while the frontier explodes -- the two
  -- were never separated, because the ladder never let them be.  They are
  -- different moves: deepening multiplies the term count by r_b = 1+4√b
  -- per step and adds no symbol, so it hands the prover more of what it
  -- has already failed to close; widening adds one symbol at the same
  -- horizon and with it a fresh family of cheap definitional facts, which
  -- is where every theorem the resonance rule missed actually was (arm D:
  -- three each about max, monus and le).  Measured on the same trace:
  -- widening cost ×1.5 in terms (2764 → 4156), deepening ×7.6
  -- (5804 → 44332).
  --
  -- So the classification keeps its job and loses its veto over the cheap
  -- axis.  A round that proved nothing is barren; what the flow decides is
  -- which axis the machine may move:
  --
  --   decay      -- ∂ is falling, the round's failures got memoised and
  --                 the next round is strictly cheaper.  Do not grow at
  --                 all.  This is the half of KFlow the boolean rule got
  --                 wrong and it stays exactly as it was.
  --   resonance  -- the orbit is the point.  The whole ladder is licensed:
  --                 name, then widen, then deepen.
  --   branching  -- ∂ is climbing and nothing is closing.  The horizon is
  --                 held, because raising it is what made ∂ climb.  But
  --                 the vocabulary may still widen: it is the one move
  --                 that changes what is being looked at without handing
  --                 the prover a geometrically larger pile of the same
  --                 thing.  Before this, a branching barren round did
  --                 nothing at all, and in arm C's trace those are a third
  --                 of all rounds (6, 11, 13 of 15).
  --
  -- The next line is load-bearing for machine/run-loop-ab.sh, which builds
  -- its `--baseline-variant old-flow` single-factor control by rewriting
  -- this exact text to `  let stuck = null checkedResults` and aborts if it
  -- does not match once.  It is kept verbatim for that reason.  Reverting
  -- it still yields the pre-KFlow boolean rule: `stuck` then holds on every
  -- barren round, which subsumes `widenOnly` below, so `grows` collapses
  -- to `stuck'` and the control stays faithful.
  let stuck = flow == Resonance && null checkedResults
      -- branching and barren: the widen-only licence described above.
      widenOnly = flow == Branching && null checkedResults
      -- a name must pay for itself in exactly the currency a theorem
      -- does: it enters only if folding the shape into it makes the
      -- machine's own working set smaller
      -- A NAME EARNS ITS SUCCESSOR BY BEING USED.  Even with the tower
      -- ruled out, a machine allowed to name something every time it is
      -- stuck will name instead of prove: each new symbol multiplies the
      -- term space (25k → 396k over four rounds of naming, with `proved`
      -- flat at zero), so naming makes the next round harder and the one
      -- after that harder still.  The honest test of a name is whether a
      -- theorem was stated with it.  Until the last one has appeared in
      -- something proved, the machine may not coin another — it must
      -- either use the idea it has, or widen the vocabulary it was given.
      lastNameUsed = case mInvented m' of
        [] -> True
        ss -> case reverse ss of
          s:_ -> let nm = symName s
                 in any (\(l,r) -> nm `elem` (symbolsIn l ++ symbolsIn r))
                        (M.keys (mKnown m'))
          [] -> True
      candidate = if stuck && lastNameUsed
                    then inventConcept syms (mRetired m') normed
                           (length (mInvented m'))
                    else Nothing
      invented = case candidate of
        Just s | Just (pat,fold) <- conceptRule s
               , null (definitionShapeFailures (syms ++ [s]))
               , null (definitionFailures (syms ++ [s]) definitionAuditBound)
               -- same prefix-is-a-size-prefix argument as `strideSample`:
               -- a concept pattern of size 3 cannot shorten a term of size 2,
               -- so measuring its compression on the smallest 400 normal
               -- forms is measuring where it cannot appear.
               , marginalCompress (usableRules m')
                   (strideSample (K.kProbe (mKnobs m')) normed) (pat,fold)
                   >= K.kConceptGain (mKnobs m')
               -> Just s
        _ -> Nothing
  case invented of
    Just s -> case conceptRule s of
      Just (pat,_) -> hPrintf logh "  CONCEPT  named %s := %s  (arity %d)\n"
                        (symName s) (show pat) (symArity s)
      Nothing -> hPrintf logh "  CONCEPT-REJECT  %s has no unique definition\n"
                   (symName s)
    Nothing -> return ()
  let m2 = case invented of
             Just s  -> m' { mInvented = mInvented m' ++ [s] }
             Nothing -> m'
      stuck' = stuck && not (isJust invented)
      -- AdvanceGate.  Growing IS an advance, and advancing on a test set
      -- that separates nothing is exactly the move ChuAdvance refutes:
      -- the defect would be a fact about the assignments, so widening the
      -- vocabulary would add symbols the machine cannot tell apart.  When
      -- the gate refuses, the state is held and the refusal is logged --
      -- it is a signal to enlarge the test set, not the term space.
      permitted = case gate of
                    Advance   -> True
                    Refused _ -> False
      -- The two licences, after naming has had its turn.  `grows` is the
      -- old `stuck'` widened to take in the branching-barren round;
      -- `deepens` is the old `stuck'` exactly, and it is the only thing
      -- that may touch the horizon or the retirement branch.
      grows   = permitted && (stuck' || widenOnly)
      deepens = permitted && stuck'
      -- Γ↝ over the growth moves whose cost this machine has actually
      -- observed.  No history for a move means no route for it, and the
      -- ladder below decides instead: a weight is recorded or it does not
      -- exist, never estimated.  (In fact there is never a history --
      -- see the unreachability argument at `gammaRoute`.)
      routed = if grows
                 then gammaRoute (mCosts m2) (mVocab m2) (mSize m2)
                 else Nothing
      m'' | not grows = m2
          -- `dVocabCap disp`, not `length vocabulary`: the arithmetic symbols
          -- exist in the list but are out of reach at the default cap, so the
          -- ladder terminates exactly where it did before (WIRE 1).
          | Just (Widen,_,_) <- routed, mVocab m2 < dVocabCap disp =
              m2 { mVocab = mVocab m2 + 1 }
          | Just (Deepen,_,_) <- routed, deepens
          , mSize m2 < K.kSizeCap (mKnobs m2) =
              m2 { mSize = mSize m2 + 1 }
          -- WIDEN BEFORE DEEPENING, and the reason is measured rather
          -- than tasteful.  A factorial re-run (machine/LOOP_MEASUREMENT.md,
          -- arm D) held the certificate fixed and varied only the growth
          -- trigger: the OLD boolean rule reached 16 theorems where the
          -- resonance rule reached 7, spending less CPU.  The mechanism is
          -- the alternation below.  Deepening multiplies the term space
          -- geometrically and introduces no new symbol, so it recombines
          -- what the machine already has; widening introduces a symbol,
          -- and the nine theorems the old rule got and the new one missed
          -- were three each about max, monus and le -- symbols the
          -- resonance rule never reached, because it grew half as often
          -- and the alternation `even (mRound m2)` spent those growths on
          -- the horizon.
          --
          -- So the trigger stays (KFlow's classification is right about
          -- WHEN to grow) and the RESPONSE changes: at resonance take the
          -- axis that adds content, and deepen only once the given
          -- vocabulary is spent.  This is also what the flow says --
          -- resonance means the orbit is the point, and recombining the
          -- same symbols at a larger radius is the one move guaranteed
          -- not to move it.
          | mVocab m2 < dVocabCap disp = m2 { mVocab = mVocab m2 + 1 }
          -- The vocabulary is spent.  At resonance the machine may go on
          -- to the horizon; at branching it may not, and holds -- that is
          -- the FLOW-HOLD below, and it is now the only thing FLOW-HOLD
          -- means.
          | not deepens = m2
          | mSize m2 < K.kSizeCap (mKnobs m2) = m2 { mSize = mSize m2 + 1 }
          -- Past this point the given vocabulary is exhausted and the
          -- size horizon is at its cap.  The machine used to answer that
          -- by raising the horizon anyway and then halting — growing the
          -- one dimension its own numbers said was not the constraint
          -- (rounds 16-18: conjectures 9k → 18k, proved 0 → 5 → 0; the
          -- prover was the bottleneck, not the search).  The only way out
          -- is a name, and if the last name it coined is going unused
          -- then that name is the thing standing in the way: WITHDRAW IT.
          -- Retiring restores the term space the dead symbol was costing
          -- and frees the coin slot for a different pattern, and the
          -- retired pattern is remembered so it is not re-proposed.
          --
          -- Without this the previous rule deadlocks, and the deadlock is
          -- provable rather than probable: with no results, no concept
          -- and no axis moved, the next round has the same rules, vocab
          -- and size, hence the same terms, hence the same conjectures,
          -- all of them memoized-failed at the same rule count — fresh=0
          -- forever.  Rounds 19 and 20 of the previous run were
          -- bit-identical, 45 seconds each.  A machine spinning on a
          -- state it can prove it cannot leave is worse than one that
          -- halts, because it looks alive.
          | otherwise = case reverse (mInvented m2) of
              s:rest -> case conceptRule s of
                Just (pat,_) ->
                  m2 { mInvented = reverse rest
                     , mRetired = mRetired m2 ++ [canonTerm pat] }
                Nothing -> m2 { mInvented = reverse rest }
              -- Nothing left to withdraw and nothing left to widen: the
              -- machine genuinely needs more room, and saying so by raising
              -- the horizon is now the honest move rather than the lazy one.
              [] -> m2 { mSize = mSize m2 + 1 }
  case routed of
    Just (mv,c,stay) ->
      hPrintf logh "  ROUTE  %s  cost %d < stay %d  (min-plus over observed weights)\n"
        (moveName mv) c stay
    Nothing -> return ()
  -- FLOW-HOLD now reports exactly one thing: the horizon was held because
  -- the flow was branching.  It is no longer a report that nothing
  -- happened -- the vocabulary may have widened in the same round, and the
  -- GROW line below says so.
  when widenOnly $
    hPrintf logh "  FLOW-HOLD  branching with nothing proved; the frontier is growing faster than the machine closes it, so the horizon is held (the vocabulary may still widen)\n"
  when ((stuck' || widenOnly) && not permitted) $
    hPrintf logh "  GATE-HOLD  growth refused while the assignments separate nothing; enlarge the test set, not the term space\n"
  -- These three were guarded on `stuck`, which was the same predicate as
  -- the ladder's.  It is not any more: a widen-only round moves mVocab
  -- with `stuck` false, and guarding the log on the old predicate would
  -- have made the new growth moves invisible to machine/run-loop-ab.sh,
  -- whose `grow` column is parsed off exactly these lines.  Guard on the
  -- state change itself, which cannot drift out of step with it.
  when (mVocab m'' > mVocab m2) $
    hPrintf logh "  GROW  vocabulary widens to %d symbols (%s)\n"
      (mVocab m'') (symName (vocabulary !! (mVocab m'' - 1)))
  when (mSize m'' > mSize m2) $
    hPrintf logh "  GROW  size horizon rises to %d\n" (mSize m'')
  when (length (mInvented m'') < length (mInvented m2)) $
    hPrintf logh "  RETIRE  %s went unused; withdrawn, and it will not be re-proposed\n"
      (case reverse (mInvented m2) of
         s:_ -> symName s
         []  -> "<none>")
  hFlush logh
  writeIORef ref m''

main :: IO ()
main = do
  rawArgs <- getArgs
  -- The dispatch flags are consumed wherever they appear and removed; every
  -- comparison below therefore sees exactly the argument list it saw before
  -- this seam existed, and an invocation with no dispatch flag runs the engine
  -- that was running yesterday.
  (disp, args) <- case parseDispatch rawArgs of
    Left err        -> hPutStrLn stderr err >> exitFailure
    Right (d, rest) -> pure (d, rest)
  when (args == ["--print-dispatch"]) $ do
    putStrLn ("DISPATCH " ++ show disp)
    putStrLn ("  base vocabulary: "
      ++ intercalate " " (map symName baseVocabulary))
    putStrLn ("  arithmetic extension: "
      ++ intercalate " " (map symName arithVocabulary))
    putStrLn ("  reachable now: "
      ++ intercalate " " (map symName (take (dVocabCap disp) vocabulary)))
    exitSuccess
  when (args == ["--least-witness-self-test"]) $ do
    let fibre = [0..20 :: Int]
        predicate n = n >= 7 && n `mod` 3 == 1
        covered = leastCovered fibre predicate (Coverage 16)
        bad = leastCovered fibre predicate (Coverage 15)
        open = searchPrefix [0..6 :: Int] predicate
    unless (covered == Right (LeastWitness 7 [0..6])
            && bad == Left (WitnessRejected 15)
            && open == OpenBeyond [0..6]) exitFailure
    hPrintf stdout "LEAST WITNESS CHECKED: satisfying-fiber=5 representatives=1 least=7 open-prefix=7 residual=retained\n"
    exitSuccess
  when (args == ["--bounded-search-self-test"]) $ do
    let predicate n = n * n >= 30
        pending = BoundedSearch [0..20] predicate Nothing
        installed = pending { acceptedCoverage = Just (Coverage 12) }
        before = executeBoundedSearch pending
        after = executeBoundedSearch installed
    unless (derivationFiber before == [6..20]
            && activeWitnesses before == [6..20]
            && derivationFiber after == derivationFiber before
            && activeWitnesses after == [6]
            && existenceConsequence before == existenceConsequence after
            && searchResidual after == Nothing) exitFailure
    hPrintf stdout "BOUNDED SEARCH CHECKED: branches=15->1 eliminated=14 consequence=equal derivations=15\n"
    exitSuccess
  when (args == ["--atlas-fixed-point-self-test"]) $ do
    let atlas = FiniteAtlas
          { atlasCharts = [0,1,2,3]
          , atlasCarrier = [0..5]
          , toChart = \chart a -> (a + chart) `mod` 6
          , loopGenerators = [\a -> (-a) `mod` 6]
          }
        compiled = compileAtlas atlas
        expected =
          [ (0,[(0,0),(1,1),(2,2),(3,3)])
          , (3,[(0,3),(1,4),(2,5),(3,0)]) ]
    unless (assignmentBranches compiled == 1296
            && coherentFamilies compiled == expected
            && map failedBaseValue (holonomyFailures compiled) == [1,2,4,5])
      exitFailure
    hPrintf stdout "ATLAS CHECKED: assignments=1296 base-candidates=6 fixed=2 eliminated=1294 tears=4\n"
    exitSuccess
  when (args == ["--endian-atlas-self-test"]) $ do
    let compiled = compileAtlas endianAtlas2
        expected =
          [ (0,[(0,0),(1,0),(2,3),(3,3)])
          , (3,[(0,3),(1,3),(2,0),(3,0)]) ]
    unless (assignmentBranches compiled == 256
            && coherentFamilies compiled == expected
            && holonomyFailures compiled ==
                 [HolonomyFailure 1 0 2, HolonomyFailure 2 0 1]) exitFailure
    hPrintf stdout "ENDIAN ATLAS CHECKED: words=4 charts=4 assignments=256 fixed=2 eliminated=254 reversal-tears=2\n"
    exitSuccess
  when (args == ["--dso-context-self-test"]) $ do
    -- `goal` is exactly the K/L table checked in DSOBellmanFinite.agda:
    -- true has local cost 0 then future cost 2; false has 1 then 0.
    -- The second active probe makes contextual comparison non-scalar, while
    -- `diagnostic` is outside this query's dependency cone and is not run.
    let routes =
          [ DSORoute "true/direct" 1 0
          , DSORoute "false/direct" 0 1
          , DSORoute "false/factored" 0 1
          , DSORoute "true/detour" 1 3
          ]
        continuations =
          [ DSOContinuation "goal" "answer" (\b -> if b == 1 then 2 else 0)
          , DSOContinuation "robustness" "answer" (\b -> if b == 1 then 4 else 0)
          , DSOContinuation "diagnostic" "audit" (\b -> if b == 1 then 0 else 100)
          ]
        compiled = compileDSO ["answer"] continuations routes
        extended = compileDSO ["answer","audit"] continuations routes
        localGreedy = dsoWitness (head (sortOn dsoLocalCost routes))
        expectedClass = DSOClass [1,1] ["false/direct","false/factored"]
        expectedExtended =
          [ DSOClass [1,1,101] ["false/direct","false/factored"]
          , DSOClass [2,4,0] ["true/direct"]
          ]
    unless (localGreedy == "true/direct"
            && dsoActiveContexts compiled == ["goal","robustness"]
            && expectedClass `elem` dsoClasses compiled
            && dsoSurvivors compiled == [expectedClass]
            && dsoRawEvaluations compiled == 12
            && dsoActiveEvaluations compiled == 8
            && dsoActiveContexts extended == ["goal","robustness","diagnostic"]
            && dsoSurvivors extended == expectedExtended
            && checkDSOQueryExtension compiled extended == Left ["true/direct"])
      exitFailure
    hPrintf stdout "DSO CONTEXT CHECKED: local=true/0 contextual=false/1 routes=4 classes=3 survivors=1 origin-labels=2 continuation-evals=12->8 query-extension-rejected=true/direct\n"
    exitSuccess
  when (args == ["--dso-live-self-test"]) $ do
    let task = boundedDSOTask "square-threshold" squareThresholdSearch
        projection = executeBoundedSearch squareThresholdSearch
        compiled = compileDSO (dsoTaskDependencies task)
          (dsoTaskContinuations task) (dsoTaskRoutes task)
        survivorValues = map dsoProfile (dsoSurvivors compiled)
        retainedRoutes = map dsoWitness (dsoTaskRoutes task)
    unless (activeWitnesses projection == [6]
            && derivationFiber projection == [6..20]
            && existenceConsequence projection
            && retainedRoutes == map (\n -> "square-threshold/" ++ show n) ([6..20] :: [Int])
            && length (dsoClasses compiled) == 15
            && survivorValues == [[6]]
            && concatMap dsoWitnesses (dsoSurvivors compiled) == ["square-threshold/6"]
            && dsoRawEvaluations compiled == 30
            && dsoActiveEvaluations compiled == 15) exitFailure
    hPrintf stdout "LIVE DSO CHECKED: bounded-routes=15 classes=15 survivors=1 retained-fiber=15 continuation-work=30->15 least-output=6 consequence=equal\n"
    exitSuccess
  when (args == ["--dso-architecture-self-test"]) $ do
    let task = boundedDSOTask "square-threshold" squareThresholdSearch
        candidates = boundedArchitectures "square-threshold" squareThresholdSearch
        result = compileDSOArchitectures (dsoTaskDependencies task)
          (dsoTaskContinuations task) candidates
        compiledMigration = lookup "square-threshold/least-selector"
          (dsoRetainedMigrations result)
    unless (dsoArchitectureProfiles result ==
              [("square-threshold/direct",[6]),
               ("square-threshold/least-selector",[6])]
            && dsoEquivalentArchitectures result ==
              [("square-threshold/direct","square-threshold/least-selector",[6])]
            && dsoArchitectureCosts result ==
              [("square-threshold/direct",(15,15)),
               ("square-threshold/least-selector",(1,1))]
            && dsoParetoArchitectures result == ["square-threshold/least-selector"]
            && dsoArchitectureRegret result ==
              [("square-threshold/direct",(14,14)),
               ("square-threshold/least-selector",(0,0))]
            && maybe False ((== 15) . length) compiledMigration
            && maybe False (all ((== "square-threshold/least/6") . snd)) compiledMigration)
      exitFailure
    hPrintf stdout "DSO ARCHITECTURE CHECKED: transformer=[6]=[6] direct=(15,15) compiled=(1,1) pareto=compiled regret=(14,14) migrations=15 origins=retained\n"
    exitSuccess
  when (args == ["--divisor-history-self-test"]) $ do
    let architecture m checkpoints name =
          head [a | a <- fst (compileHistoryArchitectures m checkpoints EndpointDemand),
                    historyArchitectureName a == name]
        checkArchitecture m checkpoints name expectedClasses expectedFibre =
          let a = architecture m checkpoints name
              fibres = historyFibres a
              predicted = product (map factorial (historyBlocks m checkpoints))
              origins = dsoArchitectureOrigin (historyCandidate a)
              migrated = map fst (dsoArchitectureMigration (historyCandidate a))
          in length fibres == expectedClasses
             && all ((== expectedFibre) . length) fibres
             && predicted == expectedFibre
             && sort origins == sort migrated
             && sort origins == sort (concat fibres)
             && length origins == factorial m
        (_, endpoint4) = compileHistoryArchitectures 4 [2] EndpointDemand
        (snapshotArchitectures4, snapshot4) =
          compileHistoryArchitectures 4 [2] (SnapshotDemand [2])
        (_, full4) = compileHistoryArchitectures 4 [2] FullDemand
        selectedSnapshotFibre =
          [historyFibres a | a <- snapshotArchitectures4,
             historyArchitectureName a `elem` dsoParetoArchitectures snapshot4]
    unless (checkArchitecture 2 [] "history/endpoint" 1 2
            && checkArchitecture 2 [1] "history/snapshot" 2 1
            && checkArchitecture 2 [1] "history/full" 2 1
            && checkArchitecture 4 [] "history/endpoint" 1 24
            && checkArchitecture 4 [2] "history/snapshot" 6 4
            && checkArchitecture 4 [1,2,3] "history/full" 24 1
            && dsoParetoArchitectures endpoint4 == ["history/endpoint"]
            && dsoParetoArchitectures snapshot4 == ["history/snapshot"]
            && dsoParetoArchitectures full4 == ["history/full"]
            && map (map length) selectedSnapshotFibre == [replicate 6 4]
            && reverseRemoval 4 == [3,2,1,0]
            && leastFactorPeeling 4 == [0,1,2,3]
            && leastFactorPeeling 4 == reverse (decreasingConstruction 4)
            && leastFactorPeeling 4 /= reverse (increasingConstruction 4))
      exitFailure
    hPrintf stdout "DIVISOR HISTORY CHECKED: m=2 endpoint=1x2 full=2x1; m=4 endpoint=1x24 snapshot=6x4 full=24x1; selected=snapshot eliminated=18 retained-history=24 orientation=corrected\n"
    exitSuccess
  when (args == ["--commutative-grammar-self-test"]) $ do
    let sig = [("0",0),("+",2)]
        raw = genTerms sig 2 7
        quotient = genTermsModulo ["+"] [] sig 2 7
        commLaw = (bin "+" x_ y_, bin "+" y_ x_)
        oldNF = ordNub (map (normalize (lemmaRules [commLaw])) raw)
        newNF = ordNub (map (normalize (lemmaRules [commLaw])) quotient)
        renamedComm = (F "+" [V 9,V 4], F "+" [V 4,V 9])
        renamedAssoc = (F "+" [F "+" [V 8,V 3],V 11],
                        F "+" [V 8,F "+" [V 3,V 11]])
    unless (oldNF == newNF && length quotient < length raw
            && isCommutativity "+" renamedComm
            && isAssociativity "+" renamedAssoc) exitFailure
    hPrintf stdout "COMMUTATIVE GRAMMAR CHECKED: raw=%d representatives=%d eliminated=%d coverage=exact\n"
      (length raw) (length quotient) (length raw - length quotient)
    exitSuccess
  when (args == ["--ac-grammar-self-test"]) $ do
    let sig = [("0",0),("+",2)]
        raw = genTerms sig 2 7
        quotient = genTermsModulo ["+"] ["+"] sig 2 7
        oldNF = ordNub (map (acCanonical "+") raw)
        newNF = ordNub (map (acCanonical "+") quotient)
    unless (oldNF == newNF && length quotient < length raw) exitFailure
    hPrintf stdout "AC GRAMMAR CHECKED: raw=%d multisets=%d eliminated=%d coverage=exact\n"
      (length raw) (length quotient) (length raw - length quotient)
    exitSuccess
  when (args == ["--concept-invention-self-test"]) $ do
    let syms = take 3 vocabulary
        patternTerm = bin "+" x_ x_
        workingSet = replicate 12 patternTerm
        invented = inventConcept syms [] workingSet 0
    case invented of
      Nothing -> exitFailure
      Just concept -> do
        let expectedFold = F "c0" [x_]
            expectedRule = (patternTerm, expectedFold)
            extended = syms ++ [concept]
            installedRules = definitionsOf extended
            semanticValue = symSem concept [7]
            folded = normalize installedRules patternTerm
            compression = marginalCompress (definitionsOf syms)
              workingSet expectedRule
            towerOnly = replicate 12 (F "c0" [F "c0" [x_]])
            towerRejected = not (isJust (inventConcept extended [] towerOnly 1))
            retiredRejected = not (isJust
              (inventConcept syms [canonTerm patternTerm] workingSet 1))
        unless (symName concept == "c0"
                && symArity concept == 1
                && conceptRule concept == Just expectedRule
                && semanticValue == 14
                && null (definitionShapeFailures extended)
                && null (definitionFailures extended definitionAuditBound)
                && folded == expectedFold
                && compression >= kConceptGainDefault
                && towerRejected
                && retiredRejected) exitFailure
        hPrintf stdout
          "CONCEPT INVENTION CHECKED: collision-pattern=x+x primitive=c0/1 semantics(7)=14 definition-installed compression=%d tower=rejected retired=rejected\n"
          compression
        exitSuccess
  when (args == ["--check-thought-format"]) $ do
    let raw = "candidate\t+(x,0)\tx\ncandidate\tgcd(x,y\ty\nfree prose asks for max\n"
        b = parseThoughts raw
        expectedResiduals = ["candidate\tgcd(x,y\ty", "free prose asks for max"]
    unless (thoughtCandidates b == [(F "+" [V 0,F "0" []], V 0)]
            && thoughtResiduals b == expectedResiduals
            && requiredVocabulary b == 7) exitFailure
    putStrLn "THOUGHT-FORMAT CHECKED: candidate object + exact residual demand"
    exitSuccess
  when (args == ["--check-definitions"]) $ do
    case definitionAudit of
      Left failures -> do
        forM_ failures (hPutStrLn stderr)
        exitFailure
      Right () -> pure ()
    when (wellFormedTerm vocabulary (F "+" [x_])) $ do
      hPutStrLn stderr "definition firewall regression: malformed arity accepted"
      exitFailure
    case ruleCounterexample vocabulary definitionAuditBound oldUnsoundGcdRule of
      Nothing -> do
        hPutStrLn stderr "definition firewall regression: old false gcd rule escaped"
        exitFailure
      Just (env,lv,rv) ->
        putStrLn ("DEFINITION FIREWALL CHECKED: current rules survive bound "
          ++ show definitionAuditBound ++ "; rejected old gcd rule at env="
          ++ show env ++ " (left=" ++ show lv ++ ", right=" ++ show rv ++ ")")
    exitSuccess
  case definitionAudit of
    Left failures -> do
      hPutStrLn stderr "REFUSING TO START: defining equation failed semantic firewall"
      forM_ failures (hPutStrLn stderr)
      exitFailure
    Right () -> pure ()
  case args of
    ["--smoke-rounds", raw]
      | Just n <- parseNaturalInt raw -> smokeRounds disp n >> exitSuccess
      | otherwise -> hPutStrLn stderr "--smoke-rounds requires a nonnegative integer"
                       >> exitFailure
    _ -> pure ()
  case args of
    ["--print-smoke-discoveries", raw]
      | Just n <- parseNaturalInt raw -> printSmokeDiscoveries disp n >> exitSuccess
      | otherwise -> hPutStrLn stderr
          "--print-smoke-discoveries requires a nonnegative integer"
            >> exitFailure
    _ -> pure ()
  case args of
    ["--emit-agda-manifest", path] ->
      emitAgdaDefinitionManifest path >> exitSuccess
    _ -> pure ()
  case args of
    ["--emit-agda-discoveries", raw, path]
      | Just n <- parseNaturalInt raw ->
          emitAgdaDiscoveryManifest n path >> exitSuccess
      | otherwise -> hPutStrLn stderr
          "--emit-agda-discoveries requires a nonnegative round count and path"
            >> exitFailure
    _ -> pure ()
  case args of
    ["--kernel-self-test"] -> do
      accepted <- kernelAccept stdout 0 ((bin "+" zero_ x_, x_), "positive control")
      rejected <- kernelAccept stdout 0 ((su x_, x_), "negative control")
      unless (accepted && not rejected) exitFailure
    _ -> do
      exists <- doesFileExist "machine/thoughts.math"
      batch <- if exists then parseThoughts <$> readFile "machine/thoughts.math"
                         else pure (ThoughtBatch [] [])
      runMachine disp batch

runMachine :: Dispatch -> ThoughtBatch -> IO ()
runMachine disp batch = do
  logh <- openFile "machine/machine.log" AppendMode
  libh <- openFile "machine/library.txt" AppendMode
  hSetBuffering logh LineBuffering
  hSetBuffering libh LineBuffering
  -- The gate's rejections are agda's own diagnostics and agda writes ℕ, ≡
  -- and λ.  Under a non-UTF-8 ambient locale `hPutStr` on these handles
  -- raises `commitBuffer: invalid argument (cannot encode character
  -- '\8469')` -- and it raises it in the middle of a run, so a machine that
  -- had proved twenty theorems dies logging the twenty-first rejection.
  -- Same fault as `Certificate.writeUtf8` answers on the way out and
  -- `setLocaleEncoding` on the way back; this is the third mouth of it.
  hSetEncoding logh utf8
  hSetEncoding libh utf8
  hPutStrLn logh "=== MathMachine start ==="
  hPrintf logh "  THOUGHTS  candidates=%d residuals=%d required-vocab=%d\n"
    (length (thoughtCandidates batch)) (length (thoughtResiduals batch))
    (requiredVocabulary batch)
  forM_ (thoughtResiduals batch) $ \r -> hPrintf logh "  RESIDUAL  %s\n" r
  -- MEMORY.  Read back what earlier runs proved, and re-admit each one
  -- through the same kernel gate rather than trusting the file.  A
  -- remembered theorem that no longer certifies is dropped and logged: the
  -- invariant is that every rule in play was accepted in THIS process.
  memExists <- doesFileExist memoryPath
  remembered <- if memExists then parseMemory <$> readFile memoryPath
                             else pure []
  admitted <- filterM (\c -> kernelAccept logh 0 (c, "remembered")) remembered
  hPrintf logh "  MEMORY  remembered=%d re-admitted=%d dropped=%d\n"
    (length remembered) (length admitted)
    (length remembered - length admitted)
  hPrintf logh "  DISPATCH  %s\n" (show disp)
  -- CLAMPED, and the clamp is the safety of WIRE 1 at startup.  `vocabulary`
  -- now names `mod`, `lcm` and `v2`, and machine/thoughts.math contains the
  -- residual line "mod(x,y)-wants-a-name:...", whose words `requiredVocabulary`
  -- scans against the symbol names.  Unclamped, merely appending the symbols
  -- would have started tomorrow's machine at mVocab = 9 -- a silent change of
  -- what the loop looks at, produced by a line of prose in a notes file.  With
  -- the clamp the default start is `min 8 (requiredVocabulary batch)`, which
  -- is what it was, and `--arith` is the only way past it.
  let seeded = start { mThoughts = thoughtCandidates batch
                     , mResiduals = thoughtResiduals batch
                     , mVocab = maybe (min (dVocabCap disp)
                                           (requiredVocabulary batch))
                                      (\v -> max 1 (min v (dVocabCap disp)))
                                      (dVocabStart disp)
                     , mRules = mapMaybe orient admitted
                     , mLemmas = [ c | c <- admitted, not (isJust (orient c)) ]
                     , mKnown = foldl' (\k c -> M.insert c () k) M.empty admitted }
  knobs <- K.loadKnobs
  hPrintf logh "  KNOBS  %s\n" (show knobs)
  ref <- newIORef (seeded { mKnobs = knobs })
  -- A machine that halts is not a machine.  The old loop stopped when the
  -- size horizon passed its cap, which is to say: it enumerated a finite
  -- space and finished.  Nothing about arithmetic is finite; what was
  -- finite was the vocabulary somebody typed, and the organ for escaping
  -- that — concept invention — was gated on a condition no definition can
  -- satisfy (see `marginalCompress`).  With the gate fixed there is a real
  -- reason to keep going, so it keeps going.
  -- `dRounds = Nothing` is the live default and is the same non-terminating
  -- loop as before.  A bound exists only so that a wire can be exercised
  -- against the real path without leaving a process behind.
  let loop :: IO ()
      loop = round1 disp (Just memoryPath) logh libh ref >> loop
      bounded :: Int -> IO ()
      bounded 0 = return ()
      bounded k = round1 disp (Just memoryPath) logh libh ref >> bounded (k-1)
  case dRounds disp of
    Nothing -> loop
    Just k  -> bounded k
  hClose logh
  hClose libh
