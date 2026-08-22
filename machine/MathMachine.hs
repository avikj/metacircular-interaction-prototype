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
import qualified Prastara_TheSearchSpaceIsGeneratedNotStored as P
import Data.List (sortOn, sortBy, foldl', intercalate, permutations, sort, partition, isInfixOf, isPrefixOf)
import Data.Maybe (mapMaybe, isJust, isNothing)
import Data.IORef
import Control.Monad (forM_, replicateM_, when, unless, filterM, foldM)
import Control.Exception (finally)
import System.IO
import System.Directory (getTemporaryDirectory, removePathForcibly)
import System.FilePath ((</>))
import System.Process (readProcess, readProcessWithExitCode)
import System.Exit (ExitCode(..), exitFailure)
import System.Environment (getArgs, lookupEnv)
import System.IO.Unsafe (unsafePerformIO)
import System.CPUTime (getCPUTime)
import Text.Printf (hPrintf)
import Text.ParserCombinators.ReadP
import qualified Certificate as C
import qualified Certify as CY
import qualified TraceReplay as TR
import qualified Knobs as K
-- THE GANAPATHA SEAM.  The Term algebra, the `Sym` record and the eight base
-- symbols left this file so that the copy the engine RUNS ON can be imported
-- and compared, instead of being described as verbatim in two other headers
-- that nothing could check (machine/dosa.lekha 0023).  The `Sym` constructor
-- is not exported from there: `akanksitaSym` carries the declared arity into
-- the evaluator, and every Sym this file builds goes through it.
import Ganapatha_TheBaseVocabularyIsOneCitedListAndEverySymbolHonoursItsDeclaredAkanksa
-- DISPATCH SEAM (2026-08-16).  Three modules built this session as standalone
-- programs are wired in below, each behind a knob whose DEFAULT reproduces the
-- engine that was running before this edit, bit for bit.  See `Dispatch`.
import qualified ArithVocab as AV
import qualified PairVocab as PV
import qualified DSO as D
import qualified NestedInduction as NI
-- THE KUTTAKA SEAM.  `Obstruction` parses the kernel's refusal back into
-- terms; the gate below returns it instead of discarding it, and the round
-- feeds the genuine residuals into the next round's conjecture queue.  See
-- `KernelOutcome` and `harvestResiduals`.
import qualified Obstruction as OB
import qualified Saptabhangi_TheSevenfoldVerdict as SB
-- THE PRAMANA SEAM.  `Pramana` names the means by which a claim came to be
-- known, so that "the kernel accepted it" stops being an unindexed sentence.
-- Two uses below and they are the same use: `KernelOutcome` now records WHICH
-- naya spoke (or was attempted, on a refusal), and `machine/library.terms`
-- carries that naya forward as sabda, so re-admission asks the gate the
-- question the original proof answered instead of guessing `refl`.
import qualified Pramana as P
import qualified Vipratisedha_ConflictIsDecidedByMetaruleNotByListPosition as V
import qualified AvaktavyaPrasava_TheFourthPositionBearsTheRuleThatDecidesIt as G
import Data.Char (isAlphaNum, isSpace, isDigit)
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

-- `Term`, `Sym`, `baseVocabulary` and the term helpers now live in
-- machine/Ganapatha_TheBaseVocabularyIsOneCitedListAndEverySymbolHonoursItsDeclaredAkanksa.hs
-- and are imported above.  They left this file because this file is
-- `module Main`, so the copy the engine actually runs on was importable
-- by nothing and the two modules calling themselves verbatim copies of
-- it could be checked against it only in prose (machine/dosa.lekha 0023).

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

-- SABDA.  The memory file used to be `lhs \t rhs` and nothing else, and that
-- missing field is what made memory cost more than it saved: re-admission had
-- to RE-DERIVE the proof note by running `proveByInduction` against whatever
-- rules happened to be visible at load, and when that reconstruction failed
-- the gate was handed nothing, which `Certificate.certifyWith` reads as
-- `refl`, which refuses.
--
-- A third tab field now carries the justification (`Pramana.Justification`):
-- the naya the theorem was actually established under, the delimitor it was
-- established under, and the round that established it.  Ninety-two committed
-- lines have two fields and still parse — to `mrJust = Nothing`, which is
-- exactly true of them and puts the caller back on the old reconstruction
-- path for those lines only.
--
-- WHAT THIS DOES NOT DO.  It does not install anything.  `Pramana`'s header
-- says why at length; the short form is that the note only chooses WHICH
-- module agda is asked to check, never whether it is asked, so a false note
-- in an edited memory file buys a candidate one wasted agda call and no more.
parseMemory :: String -> [P.MemoryRecord Term]
parseMemory = mapMaybe (P.parseRecord parseTerm) . lines

-- The equation a memory record is about.
memoryEquation :: P.MemoryRecord Term -> (Term,Term)
memoryEquation rec = (P.mrLhs rec, P.mrRhs rec)

-- The file is an append log, so it repeats -- and now the repeats need not
-- agree: ninety-two committed lines carry no justification and every line
-- written after this change carries one, so the SAME equation appears both
-- with and without testimony.  Deduplicating by the whole record would keep
-- both and count one theorem as two memories; deduplicating by the equation
-- alone would let the order of the file decide whether the naya survives.
--
-- So: one entry per equation, in first-appearance order (which is what the
-- fold's size sort then re-orders anyway), and the entry kept is the LAST one
-- that carries testimony, falling back to the first.  Last, because the file
-- is append-only and a later line is a later hearing of the same speaker.
dedupeMemory :: [P.MemoryRecord Term] -> [P.MemoryRecord Term]
dedupeMemory recs = [ best e | e <- ordNub (map memoryEquation recs) ]
  where
    best e = case [ rec | rec <- recs, memoryEquation rec == e
                        , isJust (P.mrJust rec) ] of
      [] -> head [ rec | rec <- recs, memoryEquation rec == e ]
      js -> last js

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

-- THE VARIABLE HORIZON, and it was missing.  `requiredVocabulary` lets a
-- thought file raise the SYMBOL horizon; nothing let it raise the VARIABLE
-- horizon, and `kVars` defaults to 3.  A researcher candidate naming `u`
-- (V 3) therefore reached `fingerprint`, which evaluates it against
-- `assignments 3 …`, and `eval`'s `env !! i` died with
--
--     MathMachine.hs: Prelude.!!: index too large
--
-- -- a Prelude crash, in a file whose entire discipline is to fail loud and
-- CORRECTLY.  The thought-file path had no guard: a four-variable candidate
-- did not get rejected, it killed the process.  Measured: WIRE 6's first run
-- with machine/thoughts.bhavana.math, before this line existed.
--
-- The fix is the exact analogue of `requiredVocabulary`: the batch may raise
-- the environment width, clamped to 6, which is not a chosen ceiling but
-- `Certificate.agdaVar`'s -- a candidate over seven variables could never be
-- certified whatever the fingerprint said.
--
-- WHY THIS IS INERT FOR EVERY EXISTING MEASUREMENT, and it is a proof and
-- not a hope.  `assignments nv k` is `take nv (drop 1 (iterate lcg s))` per
-- environment, so `assignments 4 k` extends each row of `assignments 3 k` by
-- one coordinate and changes no earlier one.  `eval` reads `env !! i` only
-- for variables the term actually contains, so a term over x,y,z has a
-- BYTE-IDENTICAL fingerprint under either width.  Term GENERATION still uses
-- `kVars` and is untouched: the generator's width and the fingerprint's
-- width were the same number by accident, not by argument.
variableHorizon :: [(Term,Term)] -> Int
variableHorizon cs =
  min agdaVarCeiling (maximum (1 : [ i + 1 | (l,r) <- cs, i <- vars l ++ vars r ]))

-- Not a chosen number: `Certificate.agdaVar` is Nothing for i >= 6 and
-- `agdaCertificate` binds exactly (x y z u v w), so a candidate over a
-- seventh variable is untranslatable however true it is.  It is the same
-- ceiling `Knobs.kVars` carries, and for the same reason.
agdaVarCeiling :: Int
agdaVarCeiling = 6

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
-- The Sym record, the term helpers and the eight base symbols are in
-- machine/Ganapatha_TheBaseVocabularyIsOneCitedListAndEverySymbolHonoursItsDeclaredAkanksa.hs.
-- The `Sym` CONSTRUCTOR is not exported from there: `akanksitaSym` is the
-- only way to build one, and it carries the declared arity into the
-- evaluator, so a symbol admitted to this engine cannot answer an
-- argument list of the wrong length.  That covers the symbols imported
-- from ArithVocab and PairVocab below, which are rebuilt through it, and
-- the concepts the engine invents at runtime, which are too.

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
avSym s = akanksitaSym (AV.symName s) (AV.symArity s) (AV.symSem s)
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

-- ------------------------------------------------- the pair vocabulary
--
-- WIRE 5.  machine/PairVocab.hs was built as a standalone module and, until
-- this edit, had never been run by anything and never been reachable from the
-- engine.  What is imported here is NOT its ℤ vocabulary: that one's `leglo`
-- computes `w - r` in Haskell, which the certificate emitter would render as
-- `a0 ∸ a1` over `Cubical.Data.Nat`, so the engine would be testing one
-- function and certifying another.  `PV.natPairSymbols` is the ℕ chart
-- (PairVocab §3c), whose evaluators are truncated so that the Haskell
-- function and the emitted Agda definition are the same function by
-- construction, and whose defining equations are audited over ℕ by
-- PairVocab §10 before they get here.
--
-- Exactly one of the three pair identities survives the passage to ℕ, and it
-- is the split norm; §10 verifies that exhaustively (1681 points, 0 failures)
-- and verifies the other two failing off the cone (820 of 1681) as its own
-- controls.  So this wire brings ONE real theorem within reach, not three:
--
--     leglo(w,r) * leghi(w,r)  =  splitnorm(w,r),   i.e.
--     (w ∸ r) · (w + r)        =  (w · w) ∸ (r · r)   over ℕ, unconditionally.
--
-- `centre` and `radius` are not imported: they need `div 2`, which is neither
-- in this term language nor in the certified Agda fragment.
--
-- WIRE 6 (BHAVANA).  `PV.natPairSymbols` now carries FOUR more, PairVocab
-- §3d: the D = 2 norm `nrm2(x,y) = x·x ∸ 2·(y·y)` and the two components of
-- BRAHMAGUPTA'S COMPOSITION RULE (bhavana, Brahmasphutasiddhanta, 628 CE) at
-- D = 1 and D = 2 --- `bcx1(x,y,z,u) = x·z + y·u`,
-- `bcx2(x,y,z,u) = x·z + 2·(y·u)`, `bcy(x,y,z,u) = x·u + z·y`.  They are
-- APPENDED, so leglo/leghi/splitnorm keep indices 8,9,10 and `pairVocabCap`
-- goes 11 -> 15.  D is a NUMERAL and not a variable: a variable D makes
-- bhavana a five-variable statement and `Certificate.agdaVar` spells six
-- variables while `proveByInduction` splits exactly one.
--
-- These are the first FOUR-ARY symbols the engine has ever carried.  At the
-- generator's working size a 4-ary application does not fit (f(a,b,c,d) is
-- size 5 at minimum), so they enter through the thought file --- the
-- researcher-input path of THOUGHT_FORMAT.md --- and not through the term
-- space, and a seeded candidate still gets no privileged proof status.
--
-- WHAT THE ℕ CHART COSTS HERE, and it is more than it cost WIRE 5: bhavana
-- AS BRAHMAGUPTA STATES IT IS FALSE OVER ℕ.  Monus flattens a negative norm
-- to 0, so where both true norms are negative the left side is 0·0 = 0 and
-- the right side is their positive product; PairVocab §11 exhibits the first
-- witness (x1,y1,x2,y2) = (0,1,0,1), 0 = 1 at D=1 and 0 = 4 at D=2.  What
-- survives with all arguments free is the SUBTRACTION-FREE form (§3d(b)),
-- verified at 28561 of 28561 points at each D, and the specialisations in
-- machine/thoughts.bhavana.math.
--
-- PLACED BEFORE `arithVocabulary`, so the reachable prefix `base ++ pair` is a
-- vocabulary the certificate emitter can translate END TO END, which
-- `base ++ arith` is not (`Certificate.render` has no clause for mod, lcm or
-- v2 and they carry no single defining equation, so every candidate naming
-- one is Untranslatable).  Indices 0..7 -- the only ones any recorded normal
-- form mentions -- are unchanged; mod/lcm/v2 move from 8,9,10 to 11,12,13,
-- and nothing in machine/library.terms, library.txt or the notes names them.
pvSym :: PV.Sym -> Sym
pvSym s = akanksitaSym (PV.symName s) (PV.symArity s) (PV.symSem s)
              [ (fromPV l, fromPV r) | (l,r) <- PV.symDefs s ]

fromPV :: PV.Term -> Term
fromPV (PV.V i)    = V i
fromPV (PV.F f ts) = F f (map fromPV ts)

pairVocabulary :: [Sym]
pairVocabulary = map pvSym PV.natPairSymbols

vocabulary :: [Sym]
vocabulary = baseVocabulary ++ pairVocabulary ++ arithVocabulary

-- How far the engine must reach to see the pair chart and nothing beyond it.
pairVocabCap :: Int
pairVocabCap = length baseVocabulary + length pairVocabulary

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

-- सारणी वा क्रिया (Piṅgala, Chandaḥśāstra 8.24–28).  This was
--     smallEnvironments n bound = sequence (replicate n [0 .. bound])
-- — the whole refutation box laid out.  It is now naṣṭa in mixed radix:
-- the same (bound+1)^n rows in the same order, each made from its index
-- and dropped, with the count in hand before the first row.  Order-identity
-- is checked exhaustively in machine/PrastaraRun.hs.
smallEnvironments :: Int -> Integer -> [[Integer]]
smallEnvironments n bound = P.rows (P.envPrastara n bound)

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
    --
    -- UNTIL 2026-08-20 THIS LINE READ `(x:_) -> Just x`: whichever rule sat
    -- first in the list won, and the list is
    -- `definitionsOf ... ++ mRules m ++ lemmaRules ...`, three unrelated
    -- collections concatenated.  That is not "no policy"; it is Pāṇini's
    -- WEAKEST paribhāṣā, पूर्व `pūrva` (the earlier rule wins), applied
    -- anonymously.  Of the five ranked in Paribhāṣenduśekhara 38 --
    -- pūrva < para < nitya < antaraṅga < apavāda -- the engine was using the
    -- one that loses to all four others, and was not saying so.
    --
    -- Now the site goes through `topResolve`, which tries them in the
    -- tradition's own strength order and NAMES the one that decided.  Where
    -- none decides, `topResolve` returns a written defect and only then falls
    -- back to pūrva, so the historical answer is preserved (transport) and
    -- the undecided sites are countable instead of invisible
    -- (`--vipratisedha-census`).
    topStep u = case topResolve rs u of
                  Nothing          -> Nothing
                  Just (v, _, _, _) -> Just v
    rewriteArgs [] = Nothing
    rewriteArgs (x:xs) =
      case step rs x of
        Just x' -> Just (x':xs)
        Nothing -> fmap (x:) (rewriteArgs xs)

-- --------------------------------------- vipratiṣedha: WHICH rule fires
--
-- The scheduler is `Vipratisedha_ConflictIsDecidedByMetaruleNotByListPosition`
-- (Pāṇini 1.4.2, 8.2.1; Nāgeśa Bhaṭṭa, Paribhāṣenduśekhara 38, c. 1730).
-- This is the MathMachine instance of it: what a rule is here, what counts as
-- a conflict here, and -- the part that matters -- which of the metarules this
-- domain is entitled to use and which it must abstain from.
--
-- APAVĀDA IS COMPUTABLE HERE, and it is the same test the grammarians run.
-- Rule A is an apavāda to rule B when A's left-hand side is a STRICT INSTANCE
-- of B's: everything A matches, B matches, and not conversely.  A is then the
-- special case that B would otherwise swallow, and it wins wherever both
-- apply, regardless of position.  Worked instance, in this engine's own rule
-- set: `plus(x,0) = x` (a defining clause) against `plus(x,y) = plus(y,x)`
-- (a proved theorem).  `plus(x,0)` is an instance of `plus(x,y)`; `plus(x,y)`
-- is not an instance of `plus(x,0)`.  So the definition is the apavāda and it
-- fires.  It fired before too -- because `definitionsOf` happens to be
-- concatenated in front of `mRules`.  Under 1.4.2 para alone the proved
-- theorem, being later, would have won and `plus(a,0)` would rewrite to
-- `plus(0,a)`.  Same answer, different reason, and the reason is now printed.
--
-- ANTARAṄGA: THIS DOMAIN ABSTAINS, deliberately.  अन्तरङ्गं बहिरङ्गात् ranks
-- rules by whether their conditioning causes lie further inside the form.  For
-- a term-rewriting rule the conditioning cause IS the left-hand side pattern,
-- and "further inside" for patterns is exactly the instance relation --
-- which is apavāda, already used and ranked above this. There is no second,
-- independent notion of inwardness here.  Returning `False` would be a
-- verdict; the honest value is `Nothing`, abstain.
--
-- PARA: THIS DOMAIN ABSTAINS, and this is the finding.  1.4.2 works because
-- the Aṣṭādhyāyī's order was AUTHORED: a sūtra's number encodes its relation
-- to its neighbours.  MathMachine's rule order is a concatenation of three
-- collections that were never placed with respect to one another.  Two rules
-- contending at the same root therefore have no relative position, so every
-- rule is given the same `Sthana` and para has nothing to compare.  Declaring
-- a position that does not exist, in order to get a tie broken, is the
-- collapse this whole layer exists to prevent.
--
-- WHAT HAPPENS WHEN NOTHING DECIDES.  `nirnaya` returns `Avaktavya` with a
-- written defect.  `topResolve` hands that defect back and then applies pūrva
-- -- the weakest paribhāṣā, which is what the engine has always silently done
-- -- so no derivation changes and nothing in the 5599 lines below moves.  The
-- difference is that the defect is now a value.  `--vipratisedha-census`
-- counts and prints them.
showRuleBrief :: Rule -> String
showRuleBrief (l, r) = showTermP l ++ " = " ++ showTermP r

-- `A` is a strict instance of `B`: B's pattern matches A's, not conversely.
strictInstanceOf :: Term -> Term -> Bool
strictInstanceOf a b = isJust (match b a) && isNothing (match a b)

-- One śāsana per rule.  The Sthāna's third component is the list index and is
-- there for IDENTITY ONLY -- `tParatva = False` below forbids the scheduler
-- from reading it as a rank.  Every offer sits at the root, `nyPos = 0`, so
-- every pair of candidates overlaps.
topSasanani :: [Rule] -> [V.Sasana Term]
topSasanani rs =
  [ V.Sasana (0, 0, i) (showRuleBrief rl) []
      (\u -> [ V.Nyasa (0, 0, i) 0 1 v (showTermP u ++ " ⇒ " ++ showTermP v)
             | Just sub <- [match l u]
             , let v = applySub sub rr
             , decreases u v ])
  | (i, rl@(l, rr)) <- zip [0 ..] rs ]

mmTantra :: [Rule] -> V.Tantra Term
mmTantra rs = V.Tantra
  { V.tSasanani  = topSasanani rs
    -- apavāda, COMPUTED: A excepts B when A's pattern is a strict instance
    -- of B's.  This is the elsewhere condition and it is the whole reason the
    -- defining clauses survive contact with the proved theorems.
  , V.tApavada   = \(_, _, i) (_, _, j) ->
                     i /= j && strictInstanceOf (fst (rs !! i)) (fst (rs !! j))
  , V.tAntaranga = \_ _ -> Nothing      -- abstain, on purpose; see above
  , V.tOverlap   = \_ _ -> True         -- one site: the root
  , V.tStratum   = const 0
  , V.tParatva   = False                -- a concatenation is not an authorship
  , V.tSame      = (==)
  }

-- The resolution, run for real by `step`.  Returns the resulting term, the
-- metarule that decided, the rules it beat, and -- when every metarule went
-- silent -- the written defect, after which pūrva is applied so that no
-- derivation in the 5599 lines below changes.
topResolve :: [Rule] -> Term -> Maybe (Term, V.Balya, [V.Sthana], Maybe V.Dosa)
topResolve rs u =
  case concatMap (\s -> V.saFires s u) (V.tSasanani tantra) of
    []       -> Nothing
    [x]      -> Just (V.nyResult x, V.Eka, [], Nothing)
    offers   -> case V.nirnaya tantra u offers of
      V.Nirnita w lost by -> Just (V.nyResult w, by, lost, Nothing)
      V.Avaktavya d _     ->
        let x0 = head offers    -- pūrva: the weakest paribhāṣā, named, after
        in Just (V.nyResult x0, V.Purva, [], Just d)  -- the defect is written first
  where tantra = mmTantra rs

-- Every closed term over a signature up to a depth.  Finite and exhaustive:
-- the transport check in `--vipratisedha-self-test` is a verification, not a
-- sample, and this is what makes it one.
termsUpTo :: Int -> [String] -> [String] -> [String] -> [Term]
termsUpTo d consts unaries binaries = go d
  where
    go 0 = [ F c [] | c <- consts ]
    go k = let below = go (k - 1)
           in below
              ++ [ F f [t] | f <- unaries, t <- below ]
              ++ [ F g [a, b] | g <- binaries, a <- below, b <- below ]

-- Every root site in a term population where the metarules go silent.
-- A term and every subterm of it, root first.
subtermsAll :: Term -> [Term]
subtermsAll t@(F _ ts) = t : concatMap subtermsAll ts
subtermsAll t          = [t]

vipratisedhaCensus :: [Rule] -> [Term] -> ([(Term, V.Balya)], [(Term, V.Dosa)])
vipratisedhaCensus rs pop =
  ( [ (t, b) | t <- sites, Just (_, b, _, Nothing) <- [topResolve rs t] ]
  , [ (t, d) | t <- sites, Just (_, _, _, Just d)  <- [topResolve rs t] ] )
  where
    sites = ordNub (concatMap subterms pop)
    subterms t@(F _ ts) = t : concatMap subterms ts
    subterms t = [t]

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

-- THE FUEL IS THE PLACE THE YOGYA CONDITION LIVES, and until 2026-08-18 it
-- was invisible.  `go 0 t = t` returns a term that is NOT a normal form and
-- says nothing about it, so `provedByRewriting rs (l,r)` -- which is just
-- `normalize rs l == normalize rs r` -- reports False in two situations that
-- are epistemically opposite:
--
--   (i)  both sides reached a fixed point and the fixed points differ.  The
--        strategy has been run to exhaustion: not-equal-by-rewriting is then
--        a fact about the rewrite relation.
--   (ii) one side ran out of fuel.  Nothing has been established at all; the
--        comparison is between a normal form and an arbitrary intermediate
--        term.
--
-- Collapsing (i) and (ii) into one `False` is anupalabdhi WITHOUT the yogya
-- condition -- non-apprehension used as proof of absence where the object was
-- never fit to be apprehended in the first place.  `normalizeFix` returns the
-- distinction; `normalize` is `fst` of it and is unchanged, same fuel, same
-- strategy, same result on every input.
kNormalizeFuel :: Int
kNormalizeFuel = 200

normalizeFix :: [Rule] -> Term -> (Term, Bool)
normalizeFix rs = go kNormalizeFuel
  where
    go 0 t = (t, False)
    go k t = case step rs t of
               Nothing -> (t, True)
               Just t' -> go (k-1) t'

normalize :: [Rule] -> Term -> Term
normalize rs t = fst (normalizeFix rs t)

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

-- =================================================== ANUPALABDHI, WITH YOGYA
--
-- Kumārila Bhaṭṭa, *Ślokavārttika*, abhāva-pariccheda (Mīmāṃsā, c. 7th c.):
-- anupalabdhi — non-apprehension — is an independent pramāṇa.  You know the
-- pot is absent from the floor because you do not perceive it, and Kumārila's
-- point against the Naiyāyikas is that this is not a disguised inference:
-- inference needs a positive liṅga (probans) and the absence of a cognition
-- is not a positive thing.
--
-- The whole content of the doctrine is the qualification, and it is the part
-- the machine did not have.  Valid anupalabdhi is YOGYA-ANUPALABDHI:
-- non-apprehension OF WHAT WOULD HAVE BEEN APPREHENDED HAD IT BEEN PRESENT
-- (the counterpositive must be dṛśya, upalabdhi-lakṣaṇa-prāpta — "having
-- attained the conditions of apprehension").  Not seeing a ghost establishes
-- nothing, because a ghost was never fit to be seen.
--
-- `mFailed` records "I did not find a proof" as a boolean keyed on the rule
-- count.  That is anupalabdhi with the yogya condition DELETED — precisely
-- the invalid form.  This type restores it:
--
--   Yogya   the search space was exhausted.  Every single-variable structural
--           induction over the current rule set was attempted, and every
--           normalisation inside those attempts reached a fixed point rather
--           than running out of fuel.  "No proof was found" is therefore "no
--           proof exists in this space" — knowledge, and a theorem.
--   Ayogya  the search was cut off, for the reason carried.  Nothing is
--           established: this is the ghost case.
--
-- DOES THE REDUCTION TO INFERENCE SUCCEED HERE?  Kumārila says no for the
-- perceiver, and for the perceiver he is right: there is no positive liṅga.
-- For the machine it SUCCEEDS, and the reason is worth stating because it is
-- what makes the organ buildable.  The machine has a positive liṅga the
-- perceiver lacks: the enumeration RETURNING BY EXHAUSTION, an observed
-- event, distinguishable in the type from the enumeration being cut off.
-- Given that event the inference is a plain modus tollens —
--   (major) if a proof lay in space S, an exhausted search of S would return it
--   (minor) the search of S was exhausted and returned nothing
--   ------
--   (concl) no proof lies in S.
-- So on the machine's case the Naiyāyika reduction goes through, and the
-- yogya condition is exactly the major premise.  What Kumārila supplies is
-- not the irreducibility but the DIAGNOSIS: an anupalabdhi whose major
-- premise is unavailable is not a weak inference, it is no cognition at all.
-- `Budgeted` in `CertifyVerdict` below is the same distinction, discovered
-- independently in the rewriting lane and never carried into the prover.
data Absence
  = Yogya !Int !Int
    -- ^ induction variables exhausted, rules in play.  The bounded space is
    --   named by both numbers: a Yogya verdict is a claim about THIS rule set
    --   and no other, which is why `mFailed` keys on the rule count.
  | Ayogya !String
    -- ^ the search was cut off; the string says where.
  deriving (Eq, Show)

isYogya :: Absence -> Bool
isYogya (Yogya _ _) = True
isYogya (Ayogya _)  = False

absenceReason :: Absence -> String
absenceReason (Yogya vs n) =
  "exhausted: " ++ show vs ++ " induction variable(s) over " ++ show n ++ " rules"
absenceReason (Ayogya why) = why

-- `provedByRewriting` with its yogya condition attached: the second component
-- says whether BOTH sides reached a fixed point, i.e. whether a `False` in the
-- first component is a fact about the rewrite relation or an artefact of the
-- fuel.
provedByRewritingFix :: [Rule] -> (Term,Term) -> (Bool, Bool)
provedByRewritingFix rs (l,r) =
  let (nl, fl) = normalizeFix rs l
      (nr, fr) = normalizeFix rs r
  in (nl == nr, fl && fr)

-- The prover, reporting on failure WHY it failed: exhaustion or cut-off.
-- `proveByInduction` is `either (const Nothing) Just` of this and is
-- unchanged in behaviour — same variables, same order, same short-circuit.
proveByInductionA :: [Rule] -> (Term,Term) -> Either Absence String
proveByInductionA rs (l,r) =
  case ordNub (vars l ++ vars r) of
    -- A ground equation admits no structural induction at all, so the space
    -- of single-variable inductions is empty and is exhausted vacuously.  The
    -- caller has already run `provedByRewriting` on it; there is nothing here
    -- that could have been apprehended.
    [] -> Left (Yogya 0 nRules)
    vs ->
      let outcomes = map tryVar vs
      in case [ pf | Right pf <- outcomes ] of
           (pf:_) -> Right pf
           -- Only reached when every variable failed, and only then are all
           -- the outcomes forced: the success path costs exactly what it did.
           []     -> case [ why | Left (Ayogya why) <- outcomes ] of
                       (why:_) -> Left (Ayogya why)
                       []      -> Left (Yogya (length vs) nRules)
  where
    nRules = length rs
    tryVar v =
      let base = (substVar v zeroT l, substVar v zeroT r)
          hypL = substVar v eigen l
          hypR = substVar v eigen r
          goal = (substVar v (sucT eigen) l, substVar v (sucT eigen) r)
          -- THE HYPOTHESIS HAS TO BE STATED IN THE LANGUAGE THE GOAL GETS
          -- REDUCED TO.  `step` rewrites innermost-first, so by the time the
          -- step case is anywhere near closing, every DEFINED symbol in it
          -- has been unfolded by its defining equation.  The hypothesis was
          -- being installed in the shape the conjecture was WRITTEN in, and
          -- those are the same shape only when a symbol's defining equations
          -- are pattern equations on its arguments (`+(x,0) = x`) rather than
          -- an unfolding of the symbol itself (`leglo(x,y) = x - y`).  The
          -- base vocabulary is entirely of the first kind, so this never
          -- showed; WIRE 5's chart is entirely of the second, and every one
          -- of its statements died in the step case with the hypothesis
          -- sitting there unable to match a single subterm.  Measured on the
          -- 11 pair candidates that reached the prover: 0 proved before this
          -- line, 4 after, and the base vocabulary gains 3 (see the A/B in
          -- the commit message).
          --
          -- SOUNDNESS.  `nL` and `nR` are `rs`-equal to `hypL` and `hypR`, and
          -- `rs` is the current rule set -- every member of which was kernel-
          -- accepted in this process.  So `nL = nR` is a consequence of the
          -- induction hypothesis together with theorems already installed,
          -- which is precisely what a step case is allowed to use.  Nothing
          -- here is trusted anyway: the resulting proof still goes to the
          -- Agda gate, and a proof this line enables that the gate declines
          -- is a KERNEL-REJECT like any other.
          (nL, fixL) = normalizeFix rs hypL
          (nR, fixR) = normalizeFix rs hypR
          -- both directions; `step` fires a rule only where it decreases, so
          -- an unorientable IH (the commutativity case) is still usable and
          -- still sound
          hyps = ordNub [ (a,b)
                        | (a,b) <- [(hypL,hypR),(hypR,hypL),(nL,nR),(nR,nL)]
                        , a /= b ]
          (baseOk, baseFix) = provedByRewritingFix rs base
          (stepOk, stepFix) = provedByRewritingFix (hyps ++ rs) goal
      in if baseOk && stepOk
           then Right ("induction on " ++ show (V v))
           -- `&&` short-circuits, so when the base fails the step case is
           -- never forced here either -- the cost is the old cost.
           else if not baseOk
             then if baseFix
                    then Left (Yogya 1 nRules)
                    else Left (Ayogya ("base case of the induction on "
                                       ++ show (V v) ++ " hit the "
                                       ++ show kNormalizeFuel
                                       ++ "-step normalisation fuel"))
             -- The hypothesis itself is built by normalisation, so a truncated
             -- hypothesis makes the step case's failure inconclusive too.
             else if stepFix && fixL && fixR
                    then Left (Yogya 1 nRules)
                    else Left (Ayogya ("step case of the induction on "
                                       ++ show (V v) ++ " hit the "
                                       ++ show kNormalizeFuel
                                       ++ "-step normalisation fuel"))

proveByInduction :: [Rule] -> (Term,Term) -> Maybe String
proveByInduction rs eq = either (const Nothing) Just (proveByInductionA rs eq)

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
-- MOVED ON MEASUREMENT, twice, in opposite directions.
--
-- It was 8000 because an exact size-6 round "did not finish in fifty
-- minutes".  That was true and my explanation of it was wrong.  The run that
-- stalled was the version with NO `kCollapseScan`, which normalised every
-- term a rule fired on -- thousands per candidate, once per candidate.  With
-- the hunt bounded, the same round with the exact test forced on:
--
--   round 20, |T| = 24792:  2.19 s   value-work 545   value-scan 2003685
--   round 21, |T| = 24645:  2.77 s   value-work 328   value-scan 2862512
--
-- against 1.60-2.34 s for the sampled test at the same rounds.  So the exact
-- test costs about a second a round there, its normalisation cost is
-- negligible (a few hundred, against 53270 terms generated), and its real
-- cost is the population scan -- millions of match tests, which are cheap.
-- The library after those two rounds: 70 theorems, against 36 with the
-- boundary at 8000 and 17 before any of this.
--
-- 32000 covers the measured case with margin and deliberately stops short of
-- the size-7 population (208804), which is eight times larger and has NOT
-- been measured.  `MATH_EXACT_POPULATION` moves it for whoever measures next.
kExactPopulation :: Int
kExactPopulation = 32000

{-# NOINLINE exactPopulationLimit #-}
exactPopulationLimit :: Int
exactPopulationLimit = unsafePerformIO $ do
  mv <- lookupEnv "MATH_EXACT_POPULATION"
  pure $ case mv >>= readNat of
    Just n | n > 0 -> n
    _ -> kExactPopulation
  where
    readNat v = case span isDigit (dropWhile isSpace v) of
      (ds@(_ : _), rest) | all isSpace rest -> Just (read ds)
      _ -> Nothing

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
-- Returns the verdict, the number of terms NORMALISED, and the number of
-- population members SCANNED.  Two counters because they are two different
-- costs and conflating them is how I mis-attributed a stall: the scan is a
-- match test per member, the normalisation is a full rewrite to normal form,
-- and both stop early -- the scan because `fired` is consumed lazily only as
-- far as `kCollapseScan`, the hunt because the first collapse settles it.
collapsesSomething :: S.Set Term -> [Rule] -> [Term] -> (Term,Term)
                   -> (Bool, Int, Int)
collapsesSomething popSet rules population c =
  let (verdict, normalised) = go S.empty 0 (map snd taken)
  in (verdict, normalised, scanned)
  where
    extra = extraRules c
    fired = [ (i, t) | (i, t) <- zip [(0 :: Int) ..] population
                     , isJust (step extra t) ]
    taken = take kCollapseScan fired
    -- how far into the population the scan actually had to go
    scanned = case reverse taken of
      ((i, _) : _) -> i + 1
      [] -> length population
    go _ n [] = (False, n)
    go seen n (t : ts)
      | S.member u popSet || S.member u seen = (True, n + 1)
      | otherwise = go (S.insert u seen) (n + 1) ts
      where u = normalize (extra ++ rules) t

-- WHERE THE REMAINING COST IS, and it is not the scan.
--
-- The population scan is a match test and cheap.  What is expensive is
-- NORMALISING the terms the rule fires on, once per proved candidate, with a
-- rule set that grows as the machine learns -- and a rule that fires on
-- thousands of terms and collapses none of them pays for every one of them.
-- That is what did not finish a size-6 round.
--
-- So the population scan stays exact and the COLLAPSE HUNT is bounded.  This
-- is sampling again, and worth being precise about why it is not the sampling
-- that was just removed.  The old probe sampled the POPULATION, so it asked
-- "did we happen to draw a term this rule touches?" -- and the answer was
-- deterministically no whenever the rule's left side was larger than a small
-- term, and ~(k/N)² otherwise.  This samples only terms the rule ACTUALLY
-- FIRES ON, so the remaining failure mode is narrower and nameable: a rule
-- that fires widely and collapses rarely, more than kCollapseScan terms in.
-- Nothing here is zero by construction.
kCollapseScan :: Int
kCollapseScan = 600

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
-- WHICH SIDE IS THE BODY.  A concept the machine invents carries its single
-- equation FOLDED — `(pattern, cN x0 … xk)`, because that is the direction a
-- rewrite runs — while a vocabulary symbol carries it UNFOLDED, `f(x0,…,xk) =
-- body`, because that is the direction its definition unfolds.  Both are the
-- same defining clause and both must reach the kernel; reading only the
-- folded one is why WIRE 5's pair symbols were KERNEL-SKIP on the first run
-- of this file after they were wired (`leglo` at round 0, 4 candidates).  The
-- head is identified structurally -- the symbol applied to exactly its own
-- parameters in order -- so an incidental rewrite still contributes nothing.
definingClause :: Sym -> Maybe (Term, Term)   -- (body, head)
definingClause s = do
  (l,r) <- conceptRule s
  let hd = F (symName s) (map V [0 .. symArity s - 1])
  if r == hd then Just (l, r)
             else if l == hd then Just (r, l)
                             else Nothing

certDefinitions :: [Sym] -> [C.Definition]
certDefinitions syms =
  [ C.Definition (symName s) (symArity s) (toCert body)
  | s <- syms
  , Just (body, fold) <- [definingClause s]
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

-- WHAT THE KERNEL HAS TO BE TOLD ABOUT.  `Certificate.render` has built-in
-- clauses for 0, s, +, *, -, max, le and gcd -- exactly `baseVocabulary` --
-- and for anything else it falls back to `lookupDef`, i.e. to a `Definition`
-- the caller supplied.  Until WIRE 5 the caller supplied only `mInvented`, so
-- every symbol past index 7 was invisible to the emitter and every statement
-- naming one came back Untranslatable however true it was.  Passing the
-- ACTIVE tail of the vocabulary alongside the invented concepts closes that,
-- and closes it through the same `certDefinitions` filter: a symbol with no
-- single well-formed defining clause, or one whose clause disagrees with its
-- evaluator anywhere on [0..8]^arity, still contributes no Definition and
-- still produces a KERNEL-SKIP.  Nothing is certified against a guess.
kernelSyms :: Machine -> [Sym]
kernelSyms m = drop baseVocabCap (take (mVocab m) vocabulary) ++ mInvented m

-- ===================================================================
-- WHAT THE GATE RETURNS, AND WHY IT IS NOT A BOOLEAN ANY MORE.
--
-- The kernel does not answer "no".  It answers `A != B of type ℕ`: the pair
-- of terms at the exact point where computation stalled.  Collapsing that to
-- `False` throws away the only new mathematical content a refusal has.  On
-- the committed machine/machine.log that is 1092 rejections carrying 946
-- recoverable residuals and 107 DISTINCT subgoals -- the machine stating,
-- about twelve hundred times a round, which lemmas it needs next, in its own
-- vocabulary, derived rather than guessed.
--
-- THE DECISION IS UNCHANGED.  `koAccepted` is the same Bool the old
-- `kernelAcceptWith` returned, produced on the same branches from the same
-- verdict; nothing here can turn a rejection into an acceptance.  The
-- invariant "every rule installed in this process was kernel-accepted in this
-- process" is therefore untouched.  What is added is `koObstruction`, which
-- is read only by the conjecture queue and never by the gate.
--
-- THE ANCESTOR.  Aryabhata's kuttaka (Aryabhatiya, 499 CE) solves a linear
-- Diophantine congruence by dividing, KEEPING THE REMAINDER, and recursing on
-- the remainder -- the valli, the column of quotients that reconstructs the
-- answer on the way back up (formal/cubical/KuttakaValli.agda).  The
-- remainder is not the failure of the division; it is the next problem, and
-- it is strictly smaller.  Cakravala (Jayadeva ~950, Bhaskara II 1150) is the
-- same move one level up, at quadratic forms.  "The obstruction is the
-- material" is that algorithm, not a slogan.
data KernelOutcome = KernelOutcome
  { koAccepted    :: !Bool
    -- ^ exactly the old return value of this function
  , koObstruction :: Maybe OB.Obstruction
    -- ^ Nothing when accepted, or when the emitter never produced a module
    --   (`Untranslatable` says something about the emitter, not about where
    --   computation stalled, so there is no residual to read).
  , koNaya        :: Maybe P.Naya
    -- ^ WHICH STANDPOINT SPOKE.  On an acceptance this is the naya that
    --   closed it, read off the shape `Certificate` returns.  On a refusal it
    --   is the naya that was ATTEMPTED — which is `NRefl` exactly when the
    --   proof note named no induction variable, because `certifyWith` refuses
    --   at that field before it emits a single step shape.
    --
    --   This field is why the corpus's central confusion is now expressible.
    --   machine.log:146 refuses `x = (xmaxx)` and machine.log:174 accepts it,
    --   same process, same round=0.  Before this field the two lines were
    --   `False` and `True` about the same claim and the codebase had no way
    --   to say they were not in contradiction.  They are not: one is
    --   `Just NRefl` with `koAccepted = False`, the other is
    --   `Just (NInduction 'x' (Just "cong suc"))` with `koAccepted = True`.
    --   Over the committed log that distinction covers 541 of 1457 refusals —
    --   refusals of claims the same log accepts elsewhere.
    --
    --   `Nothing` only for `Untranslatable`, where no naya was reached.
  , koCalls       :: !Int
    -- ^ agda processes this decision actually launched; 0 means every module
    --   came from `machine/.certcache`.  Recorded because the justification
    --   written into memory must not invent it: a `calls=0` that meant
    --   "unknown" would be indistinguishable from a genuine cache hit, and
    --   this repository has a documented history of exactly that mistake.
  , koVacana      :: SB.Vacana
    -- ^ THE VERDICT THAT `koAccepted` COULD NOT HOLD.  `koAccepted` is one
    --   bit and the census in ANEKANTA.md §1 found it carrying at least four
    --   unrelated situations across 1457 refusals.  This field carries the
    --   evidence, one witness per seed predicate, and
    --   `Saptabhangi_TheSevenfoldVerdict.sthana` reads a position off it:
    --
    --     asti       a naya AFFIRMED the claim (this decision, or another
    --                one in the same round -- machine.log 146/174)
    --     nasti      a naya DENIED it, carrying the stalled pair or the
    --                assignment that refutes it
    --     avaktavya  agda's refusal yields no term in the machine's
    --                language, so no predication is FORMABLE.  Fourth
    --                position, positive: not unknown, not undefined.
    --     adharmin   `x != y`, two distinct free variables -- no subject to
    --                predicate of, so not a bhanga at all
    --
    --   Every field is `Maybe String` and not `Bool`: nothing may be
    --   asserted without the text that asserts it, and a naya that did not
    --   speak leaves `Nothing`, which never becomes a denial.  An
    --   Untranslatable outcome leaves ALL of them empty and reads as
    --   `apratipatti` -- nothing was predicated -- which is what a
    --   KERNEL-SKIP actually is.
    --
    --   `koAccepted` is untouched and is still the only thing the gate
    --   reads, so no rule is installed or withheld on account of this field.
  }

toOb :: Term -> OB.Term
toOb (V i)    = OB.V i
toOb (F f ts) = OB.F f (map toOb ts)

fromOb :: OB.Term -> Term
fromOb (OB.V i)    = V i
fromOb (OB.F f ts) = F f (map fromOb ts)

claimText :: (Term, Term) -> String
claimText (l, r) = show l ++ " = " ++ show r

kernelAccept :: Handle -> Int -> ((Term,Term),String) -> IO Bool
kernelAccept logh roundNo cand =
  koAccepted <$> kernelAcceptWith [] [] [] logh roundNo cand

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

-- THE TRACE IS RENDERED AND THEN THROWN AWAY.
--
-- `TR.replayWithRules` returns `Just source` — a complete Agda module, the
-- proof written out. The kernel checks it, the machine records the words
-- "trace replay" in the log, and the source is dropped on the floor.
--
-- That path is 820 of 2362 `KERNEL-ACCEPT` lines, the plurality. It is also
-- exactly what `machine/KernelContext.hs` cannot render — its `proofOfNaya`
-- returns `NoTacticRecorded "trace replay"`, because `library.terms` records
-- THAT a trace was replayed and not the trace. So the largest single block of
-- the machine's memory is unusable by the organ built to feed the kernel, and
-- the reason is that the machine already had the answer and did not keep it.
--
-- Same defect as the verdicts, the display, the dead `residualTally`: evidence
-- produced at one boundary and discarded at the next. `tryReplay` now hands
-- the source back and `kernelAcceptWith` writes it down.
tryReplay :: [(Term,Term)] -> [Rule] -> ((Term,Term),String)
          -> IO (Maybe (Int, String))
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
            ExitSuccess -> pure (Just (calls, source))
            ExitFailure _ -> pure Nothing

-- Append-only, one record per replayed proof, delimited so it can be read back
-- without a parser for Agda.  The claim is in the machine's own prefix
-- notation, which is what `library.terms` uses and what `KernelContext`
-- already parses.
-- LIVE TARGET, TRACKED SNAPSHOT.
--
-- The first version appended straight to `machine/replay.traces`, which is
-- tracked -- and a tracked file that a long-running round loop appends to
-- means the working tree is never clean while the machine runs, so `./sync`
-- refuses for the whole run and the operator commits the same file over and
-- over.  I did that four times before noticing it was the design and not the
-- day.
--
-- So the live append target is `machine/replay.traces.live`, gitignored, and
-- `--harvest-traces` folds it into the tracked corpus deliberately, deduped by
-- claim.  That is exactly the relationship `machine.log` (live, ignored) and
-- `library.terms` (durable, tracked) already have; the traces belong on the
-- first side while a run is in flight and on the second afterwards.
--
-- This is NOT the machine.log mistake in disguise.  The corpus stays tracked
-- and reproducible; what moved is only where a run writes before harvest.
liveTraceFile :: FilePath
liveTraceFile = "machine/replay.traces.live"

recordTrace :: (Term, Term) -> String -> IO ()
recordTrace (l, r) source =
  appendFile liveTraceFile $
       "-- TRACE " ++ showTermP l ++ "\t" ++ showTermP r ++ "\n"
    ++ source
    ++ (if not (null source) && last source == '\n' then "" else "\n")
    ++ "-- END TRACE\n"

kernelAcceptWith :: [Sym] -> [(Term,Term)] -> [Rule] -> Handle -> Int
                 -> ((Term,Term),String) -> IO KernelOutcome
kernelAcceptWith invented known rules logh roundNo cand@((l,r),proofNote) = do
  replayed <- tryReplay known rules cand
  case replayed of
    Just (calls, source) -> do
      recordTrace (l, r) source
      hPrintf logh "  KERNEL-ACCEPT round=%d %s = %s  (trace replay, %d agda calls, trace kept)\n"
        roundNo (show l) (show r) calls
      pure (KernelOutcome True Nothing (Just P.NTraceReplay) calls
              (SB.noVacana { SB.vAsti =
                  Just ("trace replay closed it (" ++ show calls
                        ++ " agda calls); source kept in machine/replay.traces") }))
    Nothing -> kernelAcceptSearch invented logh roundNo ((l,r),proofNote)

-- The naya a shape string names.  `Certificate.cachedShape` prefixes
-- "cached, " when every module in the search came from the cache, which is a
-- statement about the cache and not about the standpoint, so it is stripped
-- before classification.  Anything unrecognised stays `NOther` with the text
-- kept, so a new step label added to `Certificate.stepShapes` shows up as
-- itself rather than as a silent misclassification.
nayaOfShape :: String -> P.Naya
nayaOfShape s = P.nayaOfNote (strip s)
  where
    marker = "cached, "
    strip t | take (length marker) t == marker = drop (length marker) t
            | otherwise                        = t

-- The naya a REFUSAL refused under, derived from the note rather than from
-- the error text.  This is exact, not a guess: `Certificate.certifyWith` tries
-- the refl module first and, when it fails, reads `inductionVariable` out of
-- the note and returns `Rejected` immediately if there is none.  So a note
-- naming no variable means refl was the whole of what was attempted.
nayaAttempted :: String -> P.Naya
nayaAttempted note = case C.inductionVariable note of
  Nothing -> P.NRefl
  Just v | v >= 0 && v < 6 -> P.NInduction ("xyzuvw" !! v) Nothing
         | otherwise       -> P.NOther note

-- What gets written into `machine/library.terms` beside the equation: the
-- naya that closed it and the delimitor it closed under.
--
-- The naya comes from `koNaya` -- the shape `Certificate` RETURNED -- and
-- falls back to classifying the note the prover SUBMITTED only when the gate
-- reported none, which today is the `Untranslatable` branch, where nothing is
-- installed anyway.  The two differ and the difference matters: the note says
-- "induction on x", the shape says "induction on x, step = cong suc", and a
-- later process handed the shape can be given back the module that worked
-- rather than the first of twelve.
--
-- The delimitor is read off the live machine, not off the defaults: `mVocab`
-- is how far into `vocabulary` this round could see, and `vocabulary`'s ORDER
-- is the precedence, so the list is recorded in order and not as a set.
justificationOf :: Machine -> Maybe P.Naya -> String -> Int -> P.Justification
justificationOf m mnaya pf calls = P.Justification
  { P.jPramana     = P.Anumana naya
  , P.jNaya        = naya
  , P.jAvacchedaka = P.Avacchedaka
      { P.avEquality   = "_\8801_ on \8469"
      , P.avVocabulary = map symName (take (mVocab m) vocabulary)
      , P.avVars       = K.kVars (mKnobs m)
      , P.avSizeBound  = K.kSizeCap (mKnobs m)
      }
  , P.jProvenance  = P.Provenance (mRound m) calls
  }
  where naya = maybe (P.nayaOfNote pf) id mnaya

kernelAcceptSearch :: [Sym] -> Handle -> Int -> ((Term,Term),String)
                   -> IO KernelOutcome
kernelAcceptSearch invented logh roundNo ((l,r),proofNote) = do
  verdict <- C.certifyWith (certDefinitions invented) "."
               ((toCert l, toCert r), proofNote)
  case verdict of
    C.Certified shape calls -> do
      hPrintf logh "  KERNEL-ACCEPT round=%d %s = %s  (%s, %d agda calls)\n"
        roundNo (show l) (show r) shape calls
      pure (KernelOutcome True Nothing (Just (nayaOfShape shape)) calls
              (SB.noVacana { SB.vAsti =
                  Just ("kernel accepted by " ++ shape) }))
    C.Rejected err calls -> do
      hPrintf logh "  KERNEL-REJECT round=%d %s = %s  (%d agda calls) [naya=%s] %s\n"
        roundNo (show l) (show r) calls
        (P.nayaNote (nayaAttempted proofNote))
        (take 160 (filter (/= '\n') err))
      -- The one line this whole seam exists for: `err` is agda's own
      -- `A != B of type ℕ`, and `OB.classify` turns it back into the pair of
      -- terms, against THIS candidate as the goal.  Everything above is
      -- byte-for-byte what it was.
      pure (KernelOutcome False (Just (OB.classify (toOb l, toOb r) err))
              (Just (nayaAttempted proofNote)) calls
              (SB.vacanaOfRejection (P.nayaNote (nayaAttempted proofNote)) err))
    C.Untranslatable why -> do
      hPrintf logh "  KERNEL-SKIP  unsupported fragment: %s = %s  (%s)\n"
        (show l) (show r) why
      pure (KernelOutcome False Nothing Nothing 0 SB.noVacana)

-- ===================================================================
-- READING THE REFUSALS AS A CURRICULUM.
--
-- WHY THIS TERMINATES, stated correctly.  The tempting argument is the
-- kuttaka's: Aryabhata's remainders strictly decrease, so the recursion
-- bottoms out.  THAT ARGUMENT DOES NOT APPLY HERE and must not be relied on.
-- The kuttaka divides; agda UNFOLDS, and an unfolding can grow the term --
-- the flagship example does exactly that, goal `x = 1·x` stalling at
-- `x = x + 0·x`, which is bigger.  There is no descent measure.
--
-- What bounds the feedback instead is that the residual set is FINITE AND
-- SMALL.  Over the whole committed machine/machine.log: 112 distinct
-- residuals, term sizes (both sides summed) from 2 to 20.  Residuals are what
-- agda's evaluator gets stuck on inside a fixed fragment with a fixed handful
-- of defining clauses, so the population it can produce is bounded by that
-- fragment, not by the number of candidates thrown at it.  Three further
-- brakes, none of them a measure:
--
--   * `usefulResidual` below drops the degenerate ones outright;
--   * a residual entering the queue crosses the SAME filters every other
--     conjecture crosses -- vocabulary, well-formedness, and the fingerprint
--     firewall -- so a residual of a FALSE parent (`x·x = s(x)`, 30
--     occurrences; `x·max(x,1) = s(x)`, 100) is refuted before it costs a
--     proof attempt, let alone an agda process;
--   * `mFailed` is keyed on the rule count at failure, so a residual that is
--     true, queued, and not proved is not retried until the machine knows
--     something it did not know then.  See `residualFailedContract`, which
--     is the check and not the assumption.
--
-- And the queue takes at most `kResidualQueueCap` per round, with the number
-- dropped written to the log.  A silent cap reads as "covered everything".
kResidualQueueCap :: Int
kResidualQueueCap = 48

-- WHICH RESIDUALS ARE MATERIAL.  Not this file's judgement: `Obstruction`
-- owns it, as `triage`, and the census behind it is over the whole of
-- machine/machine.log -- 112 distinct residuals, of which 78 are Plausible
-- (703 occurrences), 33 are Refuted (320) and one, `x = y`, is Degenerate
-- (63).  The separator is refutation by computation over Integer on fixed
-- deterministic assignments: one disagreement is a proof of falsity, and it
-- costs nothing next to an agda process.
--
-- The 33 refuted ones are exactly the livelock this queue could otherwise
-- create.  `x·max(x,1) = s(x)` (126 occurrences) and `x·x = s(x)` (30) are
-- both FALSE, and a false residual that is queued fails, gets its parent
-- retried, and regenerates itself, forever.
--
-- TWO LIMITS, so nothing downstream overclaims.  `Aviruddha` is the ABSENCE
-- OF A REFUTATION OVER A STATED DOMAIN — the domain is in the constructor,
-- and reading the verdict without reading it is the error the constructor
-- exists to prevent.  It is not a proof of truth; the kernel is still the only
-- thing that accepts a theorem, and every residual crosses it like everything
-- else.  And `triage` deliberately offers no opinion on a term containing a
-- symbol outside {0,s,+,*,max,-,gcd,le}: that is `Tusnim`, silence, naming the
-- symbol that caused it.  On THIS wire that branch is unreachable, and it is
-- worth saying why rather than relying on it: a residual only exists here if
-- `parseAgdaTerm` produced it, and that parser accepts exactly
-- zero/suc/numerals/variables and those same eight symbols.  Anything naming
-- an invented concept (`c0`) or a pair symbol comes back `Unparsed` and
-- contributes nothing.  If the parser is ever widened past the triage
-- vocabulary, that stops being true — and then `Tusnim` starts carrying the
-- name of whatever widened it, which is the report you would want.
residualVerdict :: (Term,Term) -> OB.Verdict
residualVerdict p = OB.triage (toOb (fst q), toOb (snd q))
  where q = orientLikeRound p

usefulResidual :: (Term,Term) -> Bool
-- The admission decision is a statement with its ground on both sides, so this
-- match holds the verdict that admitted the residual rather than a bare True.
-- Extension unchanged from the old `== Plausible`: aviruddha and tusnim enter.
usefulResidual p = fst q /= snd q
                && (case OB.pravesha (residualVerdict p) of
                      OB.Pravishati _ -> True
                      OB.Nivartate  _ -> False)
  where q = orientLikeRound p

-- THE ENGINE STATES A CONJECTURE SMALLEST-SIDE-FIRST.  `round1` takes the
-- smallest member of a fingerprint class as the representative and pairs
-- every other member against it, so `(x, x+0)` is the machine's own spelling
-- and `(x+0, x)` is a different key in `mKnown` and in `mFailed`.  The log
-- contains BOTH orientations of the same residual -- `x = x + 0` 23 times and
-- `x + 0 = x` 19 times -- so a queue that does not normalise orientation asks
-- for one lemma as two jobs and matches neither against what the round
-- already knows.  Orientation first, then `canonVars`, because renaming by
-- first appearance depends on which side is written first.
orientLikeRound :: (Term,Term) -> (Term,Term)
orientLikeRound (a,b)
  | (size a, a) <= (size b, b) = canonVars (a,b)
  | otherwise                  = canonVars (b,a)

-- The genuine subgoals in a round's refusals, each paired with the parent it
-- stalled.  `TacticTooWeak` contributes nothing to CONJECTURE (the statement
-- is already in hand; what has to change is the tactic), `Unparsed`
-- contributes nothing because the module refuses to guess, and `triage`
-- removes the refuted and the degenerate.  The subgoal set this produces is
-- `Obstruction.worthQueueing` of the same refusals -- checked, not asserted,
-- by `--obstruction-self-test`; the pairing with the parent is the extra this
-- function carries, and it is what makes "did the residual close its parent?"
-- an answerable question.
harvestResiduals :: [(((Term,Term),String), KernelOutcome)]
                 -> [((Term,Term),(Term,Term))]
harvestResiduals outcomes =
  [ (orientLikeRound (fromOb a, fromOb b), parent)
  | ((parent,_), ko) <- outcomes
  , Just (OB.Residual (a,b)) <- [koObstruction ko]
  , usefulResidual (fromOb a, fromOb b)
  ]

-- THE LIVELOCK CHECK, RUN RATHER THAN ASSUMED.  The hazard the queue creates
-- is: a residual is queued, fails, its parent is retried, the parent
-- regenerates the same residual, and the pair cycles forever at no cost to
-- anybody's counter.  `mFailed` is supposed to stop that, and this is the
-- statement of why, checked as a finite predicate so a later edit to the
-- freshness filter breaks a check and not a run:
--
--   a conjecture c with `M.lookup c mFailed == Just n` is excluded from
--   `freshSized` whenever the current rule count is n.
--
-- So a requeued residual costs one membership test and nothing else until the
-- rule set actually changes -- and when it changes, the machine genuinely
-- knows something it did not know when the residual failed, which is the only
-- condition under which retrying is not a loop.  The predicate below is
-- exactly the one `freshSized` applies, evaluated on a residual-shaped
-- witness, and it is reported in the round-0 log.
residualFailedContract :: Bool
residualFailedContract =
    not (freshAt 7) && freshAt 8 && not (usefulResidual (V 0, V 1))
                    && usefulResidual witness
  where
    -- `x = x + 0*x`, the flagship residual, recorded as having failed at a
    -- rule count of 7
    witness = canonVars (x_, bin "+" x_ (bin "*" zero_ x_))
    -- The memo entry has the shape `round1` now writes: the rule count is
    -- still the key the requeue test reads, and the yogya verdict rides
    -- alongside it without changing that test.
    failed  = M.singleton witness ((7 :: Int), Yogya 1 7)
    freshAt n = fmap fst (M.lookup witness failed) /= Just n

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
  -- conjecture -> (rule count when it failed, whether the search that failed
  -- was exhausted).  The `Int` is the memo key it always was; the `Absence` is
  -- the yogya condition, and it is what turns "I did not find a proof" from a
  -- boolean into a claim that can be true or false about the world.
  , mFailed  :: M.Map (Term,Term) (Int, Absence)
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
  -- ---- the kernel's refusals, kept.  See `KernelOutcome`. ----
  -- subgoals harvested from LAST round's refusals, waiting to be stated.
  -- Capped at `kResidualQueueCap`; what did not fit is logged, not dropped
  -- quietly.
  , mResidualQueue :: [(Term,Term)]
  -- subgoal -> the parents that stalled on it, cumulative.  This is the only
  -- structure that can answer the question the seam exists for: did a residual
  -- become a lemma that closed the candidate it came out of?
  , mResidualFrom :: M.Map (Term,Term) [(Term,Term)]
  -- residual-sourced subgoals that the kernel later accepted, cumulative
  , mResidualProved :: S.Set (Term,Term)
  -- आरोहण — the parents summoned by climbing the vallī when a subgoal became
  -- a theorem this round.  Written at the end of a round, spent at the start
  -- of the next.  See `arohana`.
  , mArohana :: S.Set (Term,Term)
  }

-- आरोहण — THE CLIMB BACK UP THE VALLĪ.
--
-- ĀRYABHAṬA, Āryabhaṭīya, Gaṇitapāda 32–33 (499), the kuṭṭaka; the procedure
-- given step by step in Bhāskara I's Āryabhaṭīyabhāṣya (629).  The pulverizer
-- has TWO motions and this machine was built with one.
--
-- Downward: divide, keep the remainder, recurse on it, and write each quotient
-- into the vallī — the column.  That motion exists here.  `Obstruction`
-- harvests the residual out of a kernel refusal and `mResidualFrom` records
-- which parent stalled on it.  The column is written every round.
--
-- Upward: you reach the bottom, seed it, and then CLIMB the column — each row
-- taking the value below it, and the answer at the bottom propagating to the
-- top.  The vallī is not scratch work.  It is the structure that carries the
-- result back, and without the ascent the descent is not a kuṭṭaka at all, it
-- is just division.
--
-- The ascent did not exist.  `mResidualFrom` was read in exactly one place —
-- `closedParents` — and read there to REPORT, after the fact, that a parent
-- had happened to be re-proposed by the fingerprint sampler in the same round
-- its subgoal happened to be proved, and had happened to go through.  The
-- machine measured the ascent it never performed.  A parent whose missing
-- lemma had just been supplied waited to be regenerated by chance, like a
-- stranger, and `mFailed`'s rule-count key could keep it out when it came.
--
-- This is the growth rule the corpus records the engine as never having had,
-- and it was available in 499.
--
-- Transitive, because a residual is itself refused and yields its own
-- residual: the column has more than two rows and the seed must reach the top.
-- `seen` carries the cycle guard — G can stall at R while R stalls at G, and
-- a vallī with a loop in it must terminate rather than climb forever.
arohana :: M.Map (Term,Term) [(Term,Term)]   -- the vallī: subgoal -> parents
        -> [(Term,Term)]                     -- seeds: subgoals proved this round
        -> [(Term,Term)]                     -- every ancestor they unblock
arohana valli seeds = go (S.fromList seeds) seeds []
  where
    go _    []     acc = reverse acc
    go seen (s:ss) acc =
      let ups = [ p | p <- M.findWithDefault [] s valli, not (S.member p seen) ]
      in go (foldl' (flip S.insert) seen ups) (ss ++ ups) (reverse ups ++ acc)

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
  [] M.empty S.empty S.empty

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
      in Just (akanksitaSym nm ar (\args -> eval sem args p)
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
--   dCertify     = 0             -> the barren round widens blindly, exactly
--                                   as it did before WIRE 4 existed.  Nothing
--                                   is computed, nothing is logged, and the
--                                   `criticalPairs` enumeration is not forced.
--                                   This default is NOT a cost decision; the
--                                   measurement that says so is on the field
--                                   itself, below.
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
  -- WIRE 4.  0 = off, and off is still the live default.  Any n > 0 is the
  -- budget of critical pairs CERTIFY may examine on a barren round before it
  -- gives up and lets the ladder run anyway.  See the WIRE 4 banner, and
  -- `certifySeam` for what n now buys that it did not buy before 2026-08-17.
  --
  -- WHY 0, RE-DECIDED 2026-08-17 WHEN THE SEAM WAS ACTUALLY CONNECTED, AND
  -- WHAT THE REASON IS NOT.  It is NOT cost.  Measured on this machine, four
  -- rounds, `machine/library.terms` restored to a fixed 37-equation state
  -- before every run so the runs are comparable, wall clock:
  --
  --     --rounds 4                    41.27s  41.60s  41.77s  40.92s
  --     --rounds 4 --certify 20000    42.23s  41.58s  41.09s  41.34s
  --
  -- The spread WITHIN the off column is 0.85s and the gap between the column
  -- means is about 0.5s, so the cost of running CERTIFY on this workload is
  -- not distinguishable from the noise of not running it.  Anyone who leaves
  -- this flag off to save time is saving nothing.
  --
  -- The reason is that turning it on CHANGES THE LADDER, and the change is
  -- unmeasured beyond four rounds.  A divergent critical pair that the kernel
  -- accepts is installed and GROWTH IS HELD for that round (see `COMPLETE` in
  -- `round1`); that is the intended behaviour and it is the whole point of
  -- completion-instead-of-widening, but it means the machine visits a
  -- different sequence of horizons than every log, note and count in this
  -- repository was written against.  It has been observed to fire: on a
  -- 15-equation memory it installed `0 = c0(0)` -- true, since c0 := x*x --
  -- which generate-and-test had not stated at any horizon it had reached.
  -- On the 37-equation memory it finds `s(x+(y-1)) = x+(y max 1)`, also true,
  -- every growing round, and the kernel declines it (the note it is given is
  -- a critical-pair provenance string, and `Certificate.certifyWith` reads
  -- its induction variable out of that note), so the round ends CERTIFY-HOLD
  -- and the ladder is unchanged.  Both outcomes are correct.  Neither has
  -- been run out to the horizon-7 plateau the corpus is written about.
  --
  -- So: off is a statement about what has been MEASURED, not about what is
  -- better.  `--certify 20000` is the measured-harmless way to ask for the
  -- organ, and the run that flips this default should be the run that has
  -- the long-horizon A/B in hand.
  , dCertify     :: Int
  -- WIRE 5.  Nothing = machine/thoughts.math, the live default and the only
  -- file the engine has ever read.  A path here replaces it, so a seeded run
  -- can hand the machine a different question set without editing the file
  -- every default run parses.
  , dThoughts    :: Maybe FilePath
  -- WIRE 6.  Whether a certified yogya-anupalabdhi is allowed to license a
  -- growth move.  ON by default, and unlike WIRE 4's `dCertify = 0` that is
  -- not a bet: the licence fires only where the round has PROVED that the
  -- region it is standing in cannot yield anything more, and the alternative
  -- to acting on that proof is re-running a computation whose result is
  -- already known.  `--no-anupalabdhi` is the single-factor control; the
  -- verdict is computed and logged either way, so the two arms differ in
  -- exactly one bit of behaviour.
  , dAnupalabdhi :: Bool
  -- WIRE 7: SAMASA-BHAVANA.  The generation step as COMPOSITION rather than
  -- enumeration.
  --
  -- NOT WIRE 6, and the two must not be collapsed.  WIRE 6 puts
  -- Brahmagupta's composition rule into the engine as CONTENT: four new
  -- symbols `bcx1`, `bcx2`, `bcy`, `nrm2` that the machine can write terms
  -- with and prove things about.  This wire puts it in as METHOD: the
  -- machine's way of getting a new equation from two it already has.
  -- Neither subsumes the other and neither is evidence for the other.
  --
  -- BRAHMAGUPTA, Brahmasphutasiddhanta 18 (628).  Given two solutions of
  -- x^2 - D y^2 = k, the samasa-bhavana COMPUTES a third; the norms multiply,
  -- so the rule is productive by construction and nothing is tested.
  -- `machine/Nalanda.hs` runs that rule as a reactor and its header states
  -- the diagnosis this wire acts on, in the file's own words: ENUMERATION HAS
  -- NO GROWTH RULE -- it can only sift a space someone else fixed.
  --
  -- WHAT THE COMPOSITION LAW IS, HERE.  This engine's objects are equations
  -- over a term algebra, not triples, and the composition law for equations
  -- was already in this file and was being used only as a FILTER.
  -- `criticalPairs` overlaps the left side of one rule with a subterm of
  -- another and returns the two results of the divergent peak.  Both results
  -- are reachable from the same term by rules the machine holds, so the
  -- equation between them is a CONSEQUENCE of what is already proved -- true
  -- by algebra, exactly as bhavana's product norm is k1*k2 by algebra.  Two
  -- theorems in, one theorem out, no candidate set.
  --
  -- WIRE 4 (`dCertify`) already computes these and uses them for a
  -- saturation verdict, taking at most ONE (the first divergent pair) and
  -- only on a round that was going to grow.  That is the composition law
  -- employed as a sieve.  This wire employs it as the generator: every
  -- non-joinable pair within budget is proposed, every round.
  --
  -- WHY THE COST CURVE IS DIFFERENT, which is the whole claim.  The
  -- enumerator's candidate count is Theta(r_b^s) in the size horizon s
  -- (LOOP_MEASUREMENT.md section 9, r_b = 1 + 4*sqrt(b)).  The composer's is
  -- O(n^2 * subterms) in the RULE COUNT n -- it grows with what the machine
  -- has proved, not with a space someone else fixed.
  --
  -- 0 = off, and off is the live default, so the engine with
  -- `defaultDispatch` is the engine before this wire existed.  Any n > 0 is
  -- the budget of critical pairs the composer may examine per round.
  , dSamasa     :: Int
  -- WIRE 7b.  With the composer on, drop the fingerprint-class conjectures
  -- and propose ONLY composed ones.  This is the strong reading of the
  -- charge -- generation IS composition, not composition ADDED to
  -- enumeration -- and it is a separate bit so that the two claims are
  -- measured separately rather than credited to each other.  Inert while
  -- `dSamasa` is 0.
  , dSamasaOnly :: Bool
  -- WIRE 8: PAKSA-LAKSANA.  Select and order in the KERNEL's currency
  -- instead of the machine's.  False = off, and off is the live default, so
  -- the engine with `defaultDispatch` is the engine before this wire existed.
  --
  -- WHAT IT CHANGES, exactly two things, both in the round:
  --
  --   (a) WIRE 7 stops discarding the M-joinable composites.  A composed
  --       pair whose two MACHINE normal forms agree is presently dropped --
  --       "it says nothing the rewriter does not already do".  That test is
  --       in M's currency and the bill is paid in K's.  With this on, such a
  --       pair is proposed in its UNNORMALISED form, which is the form that
  --       carries the content: `x + 0 = x` is M-joinable and is exactly what
  --       the kernel's residual stream keeps stalling on, because Agda's
  --       `_+_` recurses on the other argument.
  --   (b) within each priority class, `freshSized` proposes K-joinable
  --       conjectures first, so the round's agda calls are spent on the
  --       certain one-call `refl` acceptances before anything that costs
  --       two to eight and is then usually refused.
  --
  -- WHAT IT DOES NOT CHANGE, and this is the reason it is safe to turn on:
  -- `kernelJoins` is a PREDICTION, never a licence.  `kernelAccept` is still
  -- the only authority, still runs on every conjecture, and an equation the
  -- prediction gets wrong costs an ordinary refusal and nothing else.  The
  -- fingerprint firewall is untouched, so a false composed equation is
  -- refuted here as before.
  --
  -- THE MEASUREMENT THIS ACTS ON, reproducible by `sh machine/run-paksa.sh`.
  -- Over the 119,489 equations the three hands of bhavana compose:
  --
  --     (M yes, K yes)  10,713   refl, 1 call -- and M already rewrites it
  --     (M no,  K yes)   8,130   refl, 1 call -- and M CANNOT
  --     (M yes, K no )  14,928   induction, or refused after 8 calls
  --     (M no,  K no )  85,718   induction, or refused after 8 calls
  --
  -- The present rule drops all 25,641 M-joinable ones -- including the
  -- 14,928 bridging class -- and keeps 93,848 in which the 8,130 free
  -- acceptances sit at 1 in 11.5, unmarked and unordered.
  --
  -- THE NEGATIVE HALF, which is not optional and is printed by the same run:
  -- of the 9 lemmas the kernel's residual stream demands, the three hands
  -- REACH 1.  No selector over the composed set can deliver that curriculum;
  -- what is not reached is not selectable.  This wire is not a route to the
  -- demand and must not be reported as one.
  , dPaksa      :: Bool
  } deriving (Eq, Show)

defaultDispatch :: Dispatch
defaultDispatch = Dispatch baseVocabCap Nothing 0 0 Nothing Nothing 0 Nothing True 0 False False

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
      ("--certify", v:ms)      -> withNat v ms (\n -> d { dCertify = n })
      ("--log", v:ms)          -> go (d { dLog = Just v }) rest ms
      -- the whole arithmetic vocabulary, in one word
      ("--arith", ms)          -> go (d { dVocabCap = length vocabulary }) rest ms
      -- WIRE 5.  The pair chart, and START there rather than merely allowing
      -- it: `requiredVocabulary` is computed from thoughts.math, which names
      -- no pair symbol, so a raised cap alone would leave mVocab at 8 and the
      -- new symbols unreachable until the growth ladder crawled to them.
      ("--pair", ms)           -> go (d { dVocabCap = pairVocabCap
                                        , dVocabStart = Just pairVocabCap }) rest ms
      -- an alternative thought file; the default is machine/thoughts.math
      ("--thoughts", v:ms)     -> go (d { dThoughts = Just v }) rest ms
      -- WIRE 6.  The single-factor control for the anupalabdhi licence.  With
      -- it the round still COMPUTES and LOGS its yogya verdict -- so the A/B
      -- arms see the same numbers -- and simply does not act on it, which is
      -- exactly the engine of 2026-08-17.
      ("--no-anupalabdhi", ms) -> go (d { dAnupalabdhi = False }) rest ms
      -- WIRE 7.  The composer, and its budget of critical pairs per round.
      ("--samasa", v:ms)      -> withNat v ms (\n -> d { dSamasa = n })
      -- WIRE 7b.  Composition INSTEAD OF enumeration, not in addition.
      ("--samasa-only", ms)   -> go (d { dSamasaOnly = True }) rest ms
      -- WIRE 8.  Select and order in the kernel's currency.  Independent of
      -- `--samasa`: (b) applies to every conjecture the round proposes, so
      -- the flag is meaningful alone; (a) is inert unless the composer runs.
      ("--paksa", ms)         -> go (d { dPaksa = True }) rest ms
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

-- ===================================================== WIRE 8: KERNELA-NAYA
--
-- TWO REWRITERS, NOT ONE.  Everything above this line asks one rewriter --
-- the machine's own -- a question that only the kernel can answer, and pays
-- the bill in the kernel's currency.  This section gives the machine a
-- second normal form: what Agda's definitional unfolding does, as a CASE
-- TREE, so that `refl`-in-one-call can be predicted before agda is started.
--
-- THE TWO NAYAS, and neither is complete, which is the ordinary condition of
-- a naya (VISTARA section 2):
--
--   M  the machine's.  `symDefs` as unconditional rewrite rules in any
--      position.  `+` and `*` recurse on the SECOND argument; `max` fires
--      whichever of its two zero-clauses matches; `-` has `0 - x = 0`
--      unconditionally.  `normalize rules` above.
--   K  the kernel's.  Agda's clauses, fired only when the column the clause
--      splits on is ALREADY a constructor.  `_+_` and `_*_` recurse on the
--      FIRST argument.  An open term in the split column is stuck.
--
-- SOURCE OF THE CLAUSE LISTS.  machine/Certificate.hs notes A and B, which
-- state the divergence exactly and were written for a different purpose --
-- `_+_`/`_*_` from Agda.Builtin.Nat via Cubical.Data.Nat, `_-_` (monus),
-- and `max`/`le` from Certificate.preamble, which emits them in the
-- machine's own clause order.  `gcd`, `mod`, `lcm`, `v2` reduce on NO open
-- term in K and therefore have no clause here: every equation mentioning
-- them is K-stuck, for a reason about Cubical.Data.Nat.GCD and not about
-- the mathematics.
--
-- TRANSCRIBED, NOT DERIVED, and therefore falsifiable rather than trusted.
-- `machine/PaksaLaksana_WhatIsWorthHandingTheKernelIsWhereTheTwoRewritersDisagree.hs`
-- carries the same clauses and checks them AGAINST agda itself
-- (`sh machine/run-paksa.sh --kernel 8`): 32 samples, 8 per joint position,
-- 32 of 32 agreed with the prediction, and 0 of the 9 lemmas the residual
-- stream demands are K-joinable -- which is the negative control, since the
-- kernel STALLED on every one of them.  That is evidence, not faithfulness;
-- the falsifier is meant to be re-run, not quoted.
kernelStep :: Term -> Maybe Term
kernelStep (F "+" [a, b]) = case a of
  F "0" []  -> Just b
  F "s" [n] -> Just (F "s" [F "+" [n, b]])
  _         -> Nothing
kernelStep (F "*" [a, b]) = case a of
  F "0" []  -> Just (F "0" [])
  F "s" [n] -> Just (F "+" [b, F "*" [n, b]])
  _         -> Nothing
kernelStep (F "-" [a, b]) = case b of
  F "0" []  -> Just a
  F "s" [m] -> case a of
    F "0" []  -> Just (F "0" [])
    F "s" [n] -> Just (F "-" [n, m])
    _         -> Nothing
  _         -> Nothing
kernelStep (F "max" [a, b]) = case b of
  F "0" []   -> Just a
  F "s" [b'] -> case a of
    F "0" []   -> Just b
    F "s" [a'] -> Just (F "s" [F "max" [a', b']])
    _          -> Nothing
  _          -> Nothing
kernelStep (F "le" [a, b]) = case a of
  F "0" []   -> Just (F "s" [F "0" []])
  F "s" [a'] -> case b of
    F "0" []   -> Just (F "0" [])
    F "s" [b'] -> Just (F "le" [a', b'])
    _          -> Nothing
  _          -> Nothing
kernelStep _ = Nothing

-- Leftmost-outermost, descending into arguments when the head is stuck.
kernelOnce :: Term -> Maybe Term
kernelOnce t = case kernelStep t of
  Just u  -> Just u
  Nothing -> case t of
    F f ts -> descend f [] ts
    _      -> Nothing
  where
    descend _ _ [] = Nothing
    descend f pre (c:cs) = case kernelOnce c of
      Just c' -> Just (F f (reverse pre ++ c' : cs))
      Nothing -> descend f (c:pre) cs

-- A CAPPED RUN IS NOT A NORMAL FORM.  The Bool is `reached a normal form
-- within the budget`, and `kernelJoins` demands it of BOTH sides: a silent
-- cap would move an equation between positions with nothing said, which is
-- the fault this whole wire exists to remove.  Measured on the 119,489
-- equations of the three hands' reach: 0 caps at this budget.
kernelBudget :: Int
kernelBudget = 3000

kernelNormal :: Term -> (Term, Bool)
kernelNormal = go kernelBudget
  where
    go 0 t = (t, False)
    go n t = case kernelOnce t of
      Nothing -> (t, True)
      Just u  -> go (n - 1) u

-- The prediction: this equation costs the kernel ONE agda call and the proof
-- term is `refl`.  Nothing downstream trusts it -- `kernelAccept` is still
-- the authority and still runs -- it buys ORDER, and in `composedRetained`
-- it buys nothing at all.
kernelJoins :: (Term, Term) -> Bool
kernelJoins (l, r) =
  let (l', okl) = kernelNormal l
      (r', okr) = kernelNormal r
  in okl && okr && l' == r'

-- =========================================================== WIRE 4: CERTIFY
--
-- WHAT THIS REPLACES.  Until now the barren branch of `round1` was: nothing
-- proved, flow says grow, therefore widen the vocabulary.  That is a guess
-- dressed as a decision.  The machine had no way to distinguish
--
--   (a) "the current vocabulary really is exhausted -- every equation over it
--        that follows from what I know is already decided by my own rewrite
--        system", from
--   (b) "generate-and-test failed to *state* the remaining equation, because
--        the equation's two sides are both larger than the size horizon, or
--        never appeared as a pair of normal forms in the same fingerprint
--        class",
--
-- and it responded to both by widening.  In case (b) widening is strictly
-- wrong: it adds a symbol before the machine has finished with the ones it
-- has, and the missing equation stays missing at every later horizon.
--
-- Critical-pair analysis decides between (a) and (b) exactly, and it is not a
-- measurement -- it is the finite check whose success IS the theorem:
--
--   Knuth-Bendix / Newman.  A terminating rewrite system is confluent iff
--   every critical pair joins.  The rewrite relation here terminates by
--   construction: `step` fires a rule only where `decreases` holds, and
--   `decreases` is LPO with a (size, precedence, lexicographic) fallback, a
--   well-founded order.  So termination is free, and confluence -- hence
--   completeness of normalisation as a decision procedure for the equational
--   theory the installed rules generate -- reduces to a FINITE enumeration.
--
-- Two verdicts, two strictly-better actions than blind widening:
--
--   Convergent n  All n critical pairs join.  The machine has PROVED that no
--                 equation derivable from its current rules over its current
--                 vocabulary is still undecided by normalisation.  This is the
--                 licence to grow, and it is a theorem rather than a shrug.
--   Divergent     A critical pair does not join.  Its two sides are equal in
--                 the theory (both are one rewrite from a common peak, by
--                 rules already accepted) and unequal as normal forms.  That
--                 IS a new equation, and it is exactly the equation
--                 generate-and-test could not state.  Install it and keep
--                 working: completion, not growth.
--
-- SCOPE, stated here so no log line has to be read charitably.  Convergence is
-- about the EQUATIONAL theory generated by the installed rules.  It does not
-- say every true equation of arithmetic over the vocabulary is decided --
-- inductive theorems are not derivable from the rules by rewriting alone, and
-- finding those is what the round's prover is for.  The log line says this.
--
-- THE SEAM.  machine/Certify.hs is being built by another agent this round.
-- It is not on disk yet, so `certifySeam` below is the in-file fallback: the
-- same enumeration, written against this file's own `Term`, `normalize` and
-- `decreases`, so the wire is exercised end to end rather than described.
-- When Certify.hs lands, exactly one line changes -- the body of
-- `certifySeam` -- and the verdict type it must produce is `CertifyVerdict`
-- below.  Nothing else in `round1` knows where the verdict came from.

-- Syntactic unification with occurs check, kept idempotent so that a single
-- `applySub` resolves a term completely.  `match` (above) is one-sided and
-- cannot be reused: a critical pair needs both sides to move.
unify :: Term -> Term -> Maybe (M.Map Int Term)
unify a0 b0 = go [(a0,b0)] M.empty
  where
    go [] s = Just s
    go ((u,v):rest) s = case (applySub s u, applySub s v) of
      (V i, V j) | i == j -> go rest s
      (V i, t)            -> bind i t rest s
      (t, V i)            -> bind i t rest s
      (F f us, F g vs)
        | f == g, length us == length vs -> go (zip us vs ++ rest) s
        | otherwise                      -> Nothing
    bind i t rest s
      | occurs i t = Nothing
      | otherwise  = go rest (M.insert i t (M.map (applySub (M.singleton i t)) s))
    occurs i (V j) = i == j
    occurs i (F _ ts) = any (occurs i) ts

-- Every NON-VARIABLE subterm of a term, paired with the one-hole context that
-- puts a replacement back where it came from.  Overlaps at a variable position
-- are excluded because they never produce a critical pair (the instance is
-- reachable by the substitution, so the pair joins trivially) -- this is the
-- standard restriction, not an optimisation.
redexPositions :: Term -> [(Term, Term -> Term)]
redexPositions t@(V _) = [(t, id)]
redexPositions t@(F f ts) = (t, id) : inner
  where
    inner = [ (u, \x -> F f (pre ++ [k x] ++ post))
            | (pre, ti, post) <- splits ts
            , not (isVar ti)
            , (u,k) <- redexPositions ti ]
    isVar (V _) = True
    isVar _     = False
    splits xs = [ (take i xs, xs !! i, drop (i+1) xs)
                | i <- [0 .. length xs - 1] ]

shiftVars :: Int -> Term -> Term
shiftVars k (V i) = V (i + k)
shiftVars k (F f ts) = F f (map (shiftVars k) ts)

maxVarIn :: Term -> Int
maxVarIn (V i) = i
maxVarIn (F _ ts) = foldl' max (-1) (map maxVarIn ts)

-- A critical pair, carrying the two rules that produced it: the log has to be
-- able to name the overlap, or the "new equation" is an assertion.
data CriticalPair = CriticalPair
  { cpOuter    :: Rule        -- the rule rewritten at the root of the peak
  , cpInner    :: Rule        -- the rule rewritten at the overlap position
  , cpPeak     :: Term        -- the term both rewrites start from
  , cpEquation :: (Term,Term) -- the two results: equal in theory, and the test
  } deriving (Eq, Show)

-- The critical pairs of a rewrite system, lazily.  Quadratic in the rule count
-- times the subterm count; the consumer bounds it, and laziness means an early
-- divergence costs only the pairs before it.
criticalPairs :: [Rule] -> [CriticalPair]
criticalPairs rs =
  [ CriticalPair r1 r2 peak (canonVars (applySub sub rhs1, applySub sub (ctx rhs2)))
  | r1@(lhs1,rhs1) <- rs
  , let shift = 1 + max (maxVarIn lhs1) (maxVarIn rhs1)
  , r2@(lhs20,rhs20) <- rs
  , let lhs2 = shiftVars shift lhs20
  , let rhs2 = shiftVars shift rhs20
  , (u, ctx) <- redexPositions lhs1
  , not (isVarTerm u)
  , Just sub <- [unify u lhs2]
  -- a rule overlapped with itself at the root is the trivial pair (r,r)
  , not (r1 == r2 && u == lhs1)
  , let peak = applySub sub lhs1
  ]
  where
    isVarTerm (V _) = True
    isVarTerm _     = False

-- The verdict.  `Budgeted` is not a weaker `Convergent`: it is the honest
-- statement that the enumeration was cut off, so NOTHING is proved and the
-- caller must fall back to the behaviour it had before.  Collapsing the two
-- would turn a budget into a theorem, which is the exact failure this
-- repository's protocol file was written about.
data CertifyVerdict
  = Convergent !Int              -- all n critical pairs join: saturation proved
  | Divergent  !Int !CriticalPair -- pairs examined before this one diverged
  | Budgeted   !Int              -- budget spent, no divergence seen: no theorem
  deriving (Eq, Show)

-- The fallback implementation.  `budget` bounds pairs EXAMINED; the verdict is
-- `Convergent` only when the enumeration ran out first.
certifyLocal :: Int -> [Rule] -> CertifyVerdict
certifyLocal budget rs = go 0 (criticalPairs rs)
  where
    go n cps
      | n >= budget = Budgeted n
      | otherwise = case cps of
          []      -> Convergent n
          (cp:cs) | joins (cpEquation cp) -> go (n+1) cs
                  | otherwise             -> Divergent (n+1) cp
    joins (u,v) = normalize rs u == normalize rs v

-- ---------------------------------------------------- THE SEAM, CONNECTED
--
-- 2026-08-17.  machine/Certify.hs landed on 2026-08-14, in commit 634c01d0,
-- titled "CERTIFY: the machine proves its own saturation".  It was `module
-- Main`, so no file could import a line of it, and `certifySeam` went on
-- calling `certifyLocal` -- the in-file fallback the comment above calls a
-- stub -- for three days, while the commit message said the organ was
-- connected.  Certify.hs is now `module Certify` and this is the line that
-- changed.  It is more than one line because the swap has a hypothesis, and
-- the hypothesis is checked below rather than assumed.
--
-- WHAT IS GAINED, precisely.  `certifyLocal` tests joinability with ONE
-- strategy: `normalize u == normalize v`, innermost-leftmost.  That is the
-- test that matters operationally -- `normalize` is what the engine runs --
-- but it is not the mathematical property.  Joinability quantifies over ALL
-- derivations: u and v are joinable when SOME common reduct exists, in
-- whatever order the rules fire.  Certify's `joinability` runs the strategy
-- test first and, only when it fails, builds the full reduct set of each
-- side (every rule at every non-variable position, each guarded by the same
-- `decreases` that guards `step`) and intersects them.  Termination makes
-- both sets finite; `certifyBound` guards against a rule set that is not in
-- fact terminating, and a bound that is hit is reported as JoinUnknown --
-- no verdict -- never as a join.
--
-- So the swap is monotone in the safe direction.  Every pair `certifyLocal`
-- joined, this joins: clause (a) of `joinability` IS `certifyLocal`'s whole
-- test.  Pairs it called Divergent may now join.  Divergences therefore get
-- FEWER, and `Convergent` -- the verdict that prints THEOREM -- gets
-- STRICTLY more available, and is now backed by joinability rather than by
-- one strategy's normal forms.  Nothing here can turn a joined pair into a
-- divergent one, so no rule the machine would not have installed before
-- becomes installable now.
--
-- WHAT IS DELIBERATELY NOT TAKEN.  `Certify.certify` itself is not called.
-- It returns `Diverges [(Term,Term)]`: normalised pairs with the provenance
-- discarded.  The CERTIFY-DIVERGENT log line wants the peak and both parent
-- rules, and `Budgeted` -- the verdict that proves NOTHING and whose whole
-- purpose is that it must not be collapsed into Convergent -- has no
-- counterpart in `CertifyResult` at all.  So the enumeration and the budget
-- stay here, where the `CriticalPair` record is, and what is imported is the
-- joinability ORACLE.  That oracle is the entire thing `certifyLocal` was
-- missing; the rest of Certify.hs is a report generator for standalone use.
--
-- THE GUARD, and it is load-bearing.  Certify.hs does not import this file
-- (this one is `module Main`); it TRANSCRIBES `precedence` from it, as a
-- bare list of vocabulary names.  `precedence` decides `lpo`, which decides
-- `decreases`, which decides which rewrites exist at all.  If the two lists
-- ever drift -- a symbol added here, or reordered -- Certify's reduct sets
-- are the reduct sets of a DIFFERENT rewrite relation, and its verdict is a
-- true statement about an object the machine is not running.  That is not a
-- hypothetical: `arithVocabulary` was appended to `vocabulary` after this
-- file was first written.  So the lists are compared, here, against this
-- file's own `vocabulary`, and on a mismatch the seam falls back to
-- `certifyLocal` and the round says so, rather than certifying under an
-- order that is not the machine's.
certifySeam :: Int -> [Rule] -> CertifyVerdict
certifySeam budget rs
  | not certifyTranscriptionAgrees = certifyLocal budget rs
  | otherwise                           = go 0 (criticalPairs rs)
  where
    crs = [ (toCertifyTerm l, toCertifyTerm r) | (l,r) <- rs ]
    go n cps
      | n >= budget = Budgeted n
      | otherwise = case cps of
          []      -> Convergent n
          (cp:cs) | joinsCertify (cpEquation cp) -> go (n+1) cs
                  | otherwise                    -> Divergent (n+1) cp
    joinsCertify (u,v) =
      case CY.joinability CY.certifyBound crs (toCertifyTerm u) (toCertifyTerm v) of
        CY.JoinsAt _ -> True
        _            -> False

-- The two `Term` types are the same declaration written twice, in two files
-- that cannot import each other.  This is the cost of the transcription and
-- it is one function.
toCertifyTerm :: Term -> CY.Term
toCertifyTerm (V i)    = CY.V i
toCertifyTerm (F f ts) = CY.F f (map toCertifyTerm ts)

toTerm :: CY.Term -> Term
toTerm (CY.V i)    = V i
toTerm (CY.F f ts) = F f (map toTerm ts)

-- The hypothesis of the swap above, as a finite exhaustive check rather than
-- as a hope.
--
-- notes/CERTIFY_SCOPE_CORRECTION.md §2 names this exposure and leaves it
-- open: "Certify.hs transcribes MathMachine's engine and §0 pins it by
-- recomputing the machine's own published term counts ... But §0 pins the
-- GENERATOR only.  A change to `lpo`, `decreases`, or `orient` in
-- MathMachine.hs -- a file another session is editing live -- would pass §0
-- silently.  That is an open exposure, not a handled one."  It is handled
-- here, and on the only material that can matter.
--
-- Three clauses, and none of them is a sample of a distribution:
--
--   (1) the vocabulary lists agree, so `precedence` agrees on every symbol
--       either file can name.  Invented concepts need no entry: both files
--       send `c<n>` to -2-n by the same rule and neither list mentions them.
--   (2) `decreases` -- hence `lpo` and `cmpTerm`, which is all of the
--       reduction order -- agrees on EVERY ordered pair drawn from the
--       subterms of the rule set actually being certified.  `oneStepAll`
--       admits a rewrite exactly when `decreases` does, so if the two files
--       agree here they generate the same one-step relation on this
--       material, and `reachable` is then a set of reducts of the machine's
--       own rewrite relation and not of a neighbouring one.
--   (3) `normalize` agrees on each of those subterms, which pins `step`
--       (position order and strategy) on top of the order.
--
-- This is exhaustive over the subterms of `rs`, not a random probe, and it
-- is what CLAUDE.md calls a finite exhaustive verification rather than a
-- measurement.  It is quadratic in a set that is a few dozen terms wide, so
-- it costs microseconds against a call that normalises thousands of terms.
-- On failure the seam degrades to `certifyLocal`, which is correct and
-- weaker, and the round says so.
certifyTranscriptionAgrees :: Bool
certifyTranscriptionAgrees =
     CY.vocabularyNames == map symName vocabulary
  && and [ decreases u v == CY.decreases (toCertifyTerm u) (toCertifyTerm v)
         | u <- certifyProbeTerms, v <- certifyProbeTerms ]
  && and [ normalize defs t == toTerm (CY.normalize cdefs (toCertifyTerm t))
         | t <- certifyProbeTerms ]
  where
    defs  = definitionsOf vocabulary
    cdefs = [ (toCertifyTerm l, toCertifyTerm r) | (l,r) <- defs ]

-- The family the check above ranges over: EVERY term of size at most 3 over
-- the whole vocabulary in two variables.  Two variables are enough -- `lpo`
-- and `cmpTerm` never compare variable NAMES beyond equality and `compare`,
-- so a third adds no case -- and size 3 already contains a nested binary
-- application under every symbol, which is where a lexicographic-path order
-- can differ from a size order.  It is a fixed list, so GHC computes it (and
-- the `Bool` above) once per process and the check is free after the first
-- round that asks for it.
certifyProbeTerms :: [Term]
certifyProbeTerms = concat levels
  where
    levels = [ level k | k <- [1 .. 3 :: Int] ]
    at k = levels !! (k - 1)
    level 1 = [V 0, V 1]
           ++ [ F (symName s) [] | s <- vocabulary, symArity s == 0 ]
    level k = [ F (symName s) [t]
              | s <- vocabulary, symArity s == 1, t <- at (k-1) ]
           ++ [ F (symName s) [a,b]
              | s <- vocabulary, symArity s == 2
              , i <- [1 .. k-2], a <- at i, b <- at (k-1-i) ]

-- ------------------------------------------------------- RESIDUAL and PORT
--
-- machine/Residual.hs (the annihilator remainder and the port menu) is the
-- other agent's file and is likewise not on disk.  What follows is a
-- DELIBERATELY SMALL stub and it is labelled as one in its own output: it
-- reports the two things this file can compute honestly and claims nothing
-- about the annihilator.
--
--   remainder  the residual lines the machine carried in and never promoted to
--              equations, plus the count of conjectures it stated and failed.
--              These are facts about this process, not a torsor.
--   port menu  the next symbols the vocabulary could be granted, in order.
--              Each grant is one step of the ladder, which is the only sense
--              of "one quotient step" this file can justify today.
--
-- When Residual.hs lands, `residualSeam` takes its report instead and the
-- `rrStubbed` flag goes false; the log line already distinguishes the two, so
-- no note written against today's log becomes wrong tomorrow.
data ResidualReport = ResidualReport
  { rrRemainder :: [String]
  , rrPortMenu  :: [String]
  , rrStubbed   :: Bool
  } deriving (Eq, Show)

residualSeam :: Dispatch -> Machine -> ResidualReport
residualSeam disp m = ResidualReport
  { rrRemainder =
      [ "unpromoted-thought: " ++ line | line <- mResiduals m ]
      ++ [ "failed-conjectures: " ++ show (M.size (mFailed m)) ]
      ++ [ "invented-unused: " ++ symName s
         | s <- mInvented m
         , not (any (\(l,r) -> symName s `elem` (symbolsIn l ++ symbolsIn r))
                    (M.keys (mKnown m))) ]
  , rrPortMenu =
      [ symName s | s <- take 3 (drop (mVocab m) (take (dVocabCap disp) vocabulary)) ]
      ++ [ "horizon+1 (size " ++ show (mSize m + 1) ++ ")"
         | mSize m < K.kSizeCap (mKnobs m) ]
  , rrStubbed = True
  }

round1 :: Dispatch -> Maybe FilePath -> Handle -> Handle -> IORef Machine -> IO ()
round1 disp mem logh libh ref = do
  m <- readIORef ref
  t0 <- getCPUTime
  let syms = take (mVocab m) vocabulary ++ mInvented m
      sig = arities syms
      sem = semantics syms
      -- THE GENERATOR'S WIDTH AND THE FINGERPRINT'S WIDTH ARE TWO NUMBERS.
      -- They were one, and a four-variable researcher candidate consequently
      -- crashed `eval` (see `variableHorizon`).  `nv` still governs GENERATION
      -- and is still `kVars`; `nvEnv` governs the ENVIRONMENTS and is widened
      -- to whatever the thought file demands, clamped at `agdaVarCeiling`.
      -- Inert on every existing run: `assignments` extends a row rather than
      -- perturbing it, so a term over x,y,z fingerprints identically.
      nv = K.kVars (mKnobs m)
      nvEnv = max nv (variableHorizon (mThoughts m))
      envs = assignments nvEnv (mAssign m)
      rules = usableRules m
      raw = genTermsModulo (provedCommutative m) (provedAssociative m)
              sig nv (mSize m)
      -- knowledge pays here: everything already known collapses
      normed = ordNub (map (normalize rules) raw)
      classes = M.elems (M.fromListWith (++)
                  [ (fingerprint sem envs t, [t]) | t <- normed ])
      conjectures = ordNub
        ( classConjectures
        ++ [ canonVars (l,r)
           | (l,r) <- mThoughts m
           , all (`elem` map symName syms) (symbolsIn l ++ symbolsIn r)
           -- FAIL CORRECTLY, NOT LOUDLY-BY-ACCIDENT.  A candidate over more
           -- variables than the certificate emitter can spell is dropped
           -- here, before `fingerprint` indexes an environment that is not
           -- that wide.  Without this the drop happened as `Prelude.!!:
           -- index too large` and took the process with it.
           , all (< nvEnv) (vars l ++ vars r)
           , wellFormedTerm syms l
           , wellFormedTerm syms r
           , fingerprint sem envs l == fingerprint sem envs r ]
        -- THE KERNEL'S OWN QUESTIONS, asked back.  These are the subgoals
        -- agda stalled on while refusing last round's candidates.  They enter
        -- through exactly the filters a generated conjecture crosses -- in
        -- the vocabulary, well-formed, and agreeing on the fingerprint sample
        -- -- so a residual of a FALSE parent (`x·x = s(x)`, `x·max(x,1) =
        -- s(x)`) is refuted here and never reaches the prover.  Provenance
        -- buys priority in `freshSized` and nothing else.
        ++ residualAdmittedList
        -- THE CLIMB.  Parents whose subgoal became a theorem last round, pulled
        -- up the vallī rather than waited for.  Same firewall as everything
        -- else -- in the vocabulary, well-formed, fingerprint-agreeing -- so a
        -- summoned parent that is false is refuted here like any candidate.
        ++ arohanaAdmittedList
        -- WIRE 7.  Composed equations.  Empty unless --bhavana is on.
        ++ samasaAdmittedList )
      -- Same filters, named once so the log can report what survived them: a
      -- residual dropped by the firewall and a residual never generated look
      -- identical otherwise, and they are different diseases.  The `nvEnv`
      -- guard is the one WIRE 6 added for thought-file candidates and it
      -- belongs here for the same reason -- `fingerprint` on the line below
      -- indexes the environment, and `Obstruction`'s parser can produce any
      -- of x..w.
      residualAdmittedList =
        [ canonVars (l,r)
        | (l,r) <- mResidualQueue m
        , all (`elem` map symName syms) (symbolsIn l ++ symbolsIn r)
        , all (< nvEnv) (vars l ++ vars r)
        , wellFormedTerm syms l
        , wellFormedTerm syms r
        , fingerprint sem envs l == fingerprint sem envs r ]
      residualAdmitted = S.fromList residualAdmittedList
      -- Same filters, applied to the ascent.  A parent was a candidate once, so
      -- it will normally pass; running it through anyway costs nothing and
      -- means the climb cannot be the one path into the prover that skips the
      -- firewall.
      arohanaAdmittedList =
        [ canonVars (l,r)
        | (l,r) <- S.toList (mArohana m)
        , all (`elem` map symName syms) (symbolsIn l ++ symbolsIn r)
        , all (< nvEnv) (vars l ++ vars r)
        , wellFormedTerm syms l
        , wellFormedTerm syms r
        , fingerprint sem envs l == fingerprint sem envs r ]
      arohanaAdmitted = S.fromList arohanaAdmittedList
      -- ------------------------------------------------- WIRE 7: SAMASA-BHAVANA
      --
      -- The composed conjectures.  See the `dSamasa` banner in `Dispatch`
      -- for the source (Brahmagupta, Brahmasphutasiddhanta 18, 628) and for
      -- what is and is not being claimed of it.
      --
      -- `cpEquation` is the two results of a divergent peak.  Both sides are
      -- reachable from `cpPeak` by rules the machine already holds, so the
      -- equation is an equational CONSEQUENCE of those rules and is true
      -- whenever they are.  Nothing here is a candidate to be sifted: the
      -- law produces truths, and the kernel is asked only because this
      -- repository does not install what it has not checked.
      --
      -- Both sides are normalised before proposal, because the peak's raw
      -- results carry whatever the two rules happened to leave behind and the
      -- normal forms are the equation's actual new content.  A pair whose two
      -- normal forms agree is joinable -- it says nothing the rewriter does
      -- not already do -- and is dropped here, counted, and reported.
      composedRaw =
        [ (cp, canonVars (normalize rules l0, normalize rules r0), canonVars (l0, r0))
        | dSamasa disp > 0
        , cp <- take (dSamasa disp) (criticalPairs rules)
        , let (l0, r0) = cpEquation cp ]
      composedNovel = [ (cp, c) | (cp, c@(l,r), _) <- composedRaw, l /= r ]
      -- WIRE 8 (a).  THE SAME PEAKS, KEPT IN THE OTHER CURRENCY.
      --
      -- A pair the machine's rewriter joins is not empty; it is empty TO THE
      -- MACHINE.  Its M-normalised form really does say nothing -- both sides
      -- have collapsed to the same term, so the proposal would literally be
      -- `t = t` -- but its UNNORMALISED form is the equation between the two
      -- results of the peak, and that is the object the kernel is asking for.
      -- The flagship instance is `x + 0 = x`: M joins it in one step, K does
      -- not join it at all, and the residual stream has stalled on it for 239
      -- rounds.  So the retention rule is: propose the normalised pair when it
      -- is novel to M, and the raw pair when it is not.
      --
      -- Measured, `sh machine/run-paksa.sh`: this is 25,641 of 119,489 pairs
      -- restored, 14,928 of them the bridging class `machine/Obstruction.hs`
      -- diagnosed as the kernel's actual curriculum.  Both branches still pass
      -- the whole firewall below -- vocabulary, arity, variable count,
      -- well-formedness, fingerprint -- unchanged.
      composedRetained
        | not (dPaksa disp) = composedNovel
        | otherwise =
            [ (cp, c)
            | (cp, mnf@(ml, mr), raw) <- composedRaw
            , let c = if ml /= mr then mnf else raw
            , fst c /= snd c ]
      -- THE NEGATIVE CONTROL, and it is the reason this wire can be believed
      -- at all.  A composed equation is true by algebra, so the fingerprint
      -- -- forty random environments under the current semantics -- MUST
      -- agree on its two sides.  If it ever does not, either a rule in
      -- `usableRules` is unsound or the composition law is misapplied here,
      -- and in both cases the number below is nonzero and the round says so.
      -- `machine/CandidateGen.hs` submits a deliberate falsehood through its
      -- own gate for the same purpose; this is that discipline applied to a
      -- law rather than to a module.
      composedRefuted =
        [ c | (_, c@(l,r)) <- composedRetained
            , all (`elem` map symName syms) (symbolsIn l ++ symbolsIn r)
            , all (< nvEnv) (vars l ++ vars r)
            , wellFormedTerm syms l, wellFormedTerm syms r
            , fingerprint sem envs l /= fingerprint sem envs r ]
      samasaAdmittedList =
        [ c
        | (_, c@(l,r)) <- composedRetained
        , all (`elem` map symName syms) (symbolsIn l ++ symbolsIn r)
        , all (< nvEnv) (vars l ++ vars r)
        , wellFormedTerm syms l
        , wellFormedTerm syms r
        , fingerprint sem envs l == fingerprint sem envs r ]
      -- The enumerator's own conjectures, named so that WIRE 7b can withhold
      -- them.  With `--samasa-only` the round proposes composed equations,
      -- the thought file, the residuals and the climb -- and nothing that
      -- came out of `genTermsModulo`'s fingerprint classes.  The term space
      -- is still GENERATED (the pruning statistics, the probe and the gate
      -- all read it); what is withheld is its use as a source of questions.
      classConjectures
        | dSamasa disp > 0 && dSamasaOnly disp = []
        | otherwise =
            [ canonVars (rep, other)
            | cls <- classes
            , length cls > 1
            , rep:others <- [sortOn (\t -> (size t, t)) cls]
            , other <- others
            ]
      -- WHERE A RESIDUAL ACTUALLY DIES, per round.  This is the diagnostic
      -- that decides whether the wire can pay at all, and it is here because
      -- the answer turned out to be structural rather than empirical: the
      -- highest-leverage lemmas in the curriculum are `x·0 = 0`, `0 = y·0`
      -- and `x = x+0`, and every one of them is a DEFINING EQUATION of the
      -- machine's own vocabulary.  `provedByRewriting rules c` therefore
      -- discharges them, they never reach `fresh`, and even if they did the
      -- prover's fold tags them `follows-by-rewriting` and never submits them
      -- to the kernel.  Agda needs them because its `_·_` recurses on the
      -- other argument; the machine's rewriter does not.  A tally that hides
      -- that reads as "the residuals were queued" when they were discarded
      -- one filter later.
      -- KRAMA.  `Saptabhangi.no-single-vacana` proves that for EVERY single
      -- standpointed utterance there is a profile on which it disagrees with
      -- the joint content of two standpoints, and `krama-expresses` proves the
      -- ordered PAIR denotes it exactly.  This function used to return one
      -- string.  One string is one Vacana, so by that theorem it could not say
      -- what a residual's situation is — and the string it returned was
      -- `follows-by-rewriting`, the rewriter's word, standing in for the
      -- kernel's, which is the naya that asked the question.
      --
      -- So the status is two words in succession: what the rewriter says, then
      -- what the kernel says.  The kernel's side has three values and the third
      -- is the one that mattered — `kernel-unasked`. `x = x+0` sat there 27
      -- times over 239 rounds and nothing could see it, because the medium had
      -- room for one aspect at a time.
      rewriterSays c
        | provedByRewriting rules c    = "rewriter-derives"
        | congruent rules (mKnown m) c = "rewriter-congruent"
        | otherwise                    = "rewriter-silent"
      kernelSays c
        | M.member c (mKnown m)                            = "kernel-accepted"
        | fmap fst (M.lookup c (mFailed m)) == Just nRules  = "kernel-refused"
        | otherwise                                        = "kernel-unasked"
      residualStatus c@(l,r)
        | not (all (`elem` map symName syms) (symbolsIn l ++ symbolsIn r))
                                            = "out-of-vocabulary"
        | not (all (< nvEnv) (vars l ++ vars r)) = "too-many-variables"
        | not (wellFormedTerm syms l && wellFormedTerm syms r) = "ill-formed"
        | fingerprint sem envs l /= fingerprint sem envs r
                                            = "refuted-by-fingerprint"
        | otherwise = rewriterSays c ++ " / " ++ kernelSays c
      residualTally = M.toList (M.fromListWith (+)
        [ (residualStatus (canonVars c), 1 :: Int) | c <- mResidualQueue m ])
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
      -- RESIDUALS GO FIRST, and the reason is the same one the comment above
      -- gives for smallest-first: the fold feeds each proof back in as it
      -- goes.  A residual is by construction the subgoal some candidate
      -- stalled on, so proving it early is precisely what can close the
      -- parent in the same round -- and residuals are not always small (the
      -- flagship one, `x = x + 0·x`, is bigger than the goal that produced
      -- it), so size order alone would schedule them after the thing they are
      -- supposed to unblock.  The tie-break inside each class is unchanged,
      -- so with an empty residual queue this is the old order exactly.
      -- WIRE 8 (b).  CHEAP-AND-CERTAIN FIRST, WITHIN THE CLASS.
      --
      -- `kernelJoins` predicts `refl` in one agda call.  With `--paksa` the
      -- sort puts those ahead of their classmates, because the round's real
      -- budget is agda processes and this is the only key available that is
      -- denominated in them -- size is denominated in the machine's terms and
      -- has never been a price at the kernel.
      --
      -- WHY IT IS A SECONDARY KEY AND NOT THE FIRST ONE, said here so it can
      -- be overruled rather than inherited.  Ordering K-joinable ahead of
      -- EVERYTHING would demote the residuals and the climb, and residuals-go-
      -- first is the fix that ended 239 rounds of a subgoal dying between two
      -- standpoints (the comment above).  A cheap ordering that undoes a
      -- correctness ordering is a durnaya: one standpoint asserting itself by
      -- denying another.  So the classes stand and the cheap-first order runs
      -- inside each of them.  What that costs is that the 8,130 free
      -- acceptances still wait behind the residual queue; the residual queue
      -- is small and the wait is bounded by it.
      kFirst c | dPaksa disp = if kernelJoins c then 0 else 1 :: Int
               | otherwise   = 0
      freshSized = sortOn (\c@(l,r) -> ( if S.member c arohanaAdmitted then 0
                                         else if S.member c residualAdmitted
                                           then 1 else 2 :: Int
                                       , kFirst c
                                       , size l + size r, l, r))
              [ c | c <- conjectures
                  , not (M.member c (mKnown m))
                  -- THE MEMO IS A PROXY; THE VALLĪ IS THE ANSWER.  `mFailed`
                  -- keys on the rule count because "did anything change?" had
                  -- no better test available -- and it is the wrong test for
                  -- exactly this candidate, because a subgoal can be proved
                  -- without installing an orientable rule and leave the count
                  -- where it was.  For a parent reached by the climb the
                  -- question is already answered exactly: the lemma it stalled
                  -- on is now a theorem.  An exact answer overrides a proxy.
                  --
                  -- This terminates.  `mArohana` is rebuilt each round from
                  -- that round's newly-proved subgoals, so a parent is summoned
                  -- once per subgoal of its own that closes; if it still fails
                  -- it re-enters `mFailed` and is not summoned again until
                  -- another of its subgoals lands.
                  , S.member c arohanaAdmitted
                      || fmap fst (M.lookup c (mFailed m)) /= Just nRules
                  -- THE REWRITER MAY NOT SPEAK FOR THE KERNEL.  These two
                  -- tests are the rewriter's naya, and for an ordinary
                  -- generated conjecture they are the right filter: no point
                  -- asking the kernel what we can already derive.
                  --
                  -- For a RESIDUAL they are the wrong filter, and this is the
                  -- fault that kept the seam at zero for 239 rounds.  A
                  -- residual is a question the KERNEL asked — it stalled at
                  -- `x ≡ x + 0` and said so.  `provedByRewriting` then answers
                  -- yes, because library.terms holds `x = 0+x` and `x+y = y+x`
                  -- and the rewriter composes them; the residual is dropped and
                  -- never submitted.  Both standpoints are right and the
                  -- question dies between them.  Agda's `_+_` recurses on its
                  -- first argument, so `x + 0` does not reduce there, and no
                  -- theorem the rewriter holds can change that — `{-# REWRITE
                  -- #-}` needs `--rewriting` and this lane is `--safe`.
                  --
                  -- So: a residual is vetoed only by the naya that asked it.
                  -- `mKnown` (the kernel accepted it) and `mFailed` above (the
                  -- kernel refused it at this rule count) still apply; the
                  -- rewriter's opinion now buys priority in the sort and
                  -- nothing else.
                  , S.member c residualAdmitted || S.member c arohanaAdmitted
                      || not (provedByRewriting rules c)
                  , S.member c residualAdmitted || S.member c arohanaAdmitted
                      || not (congruent rules (mKnown m) c) ]
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
      -- `MATH_EXACT_POPULATION` moves the boundary, for the same reason
      -- `MATH_AGDA_TIMEOUT` moves the gate's: a constant nobody can reach
      -- from outside is a constant nobody has tested, and this one is
      -- explicitly parked at a measured-safe value with the experiment that
      -- would move it left undone.  Reading it here rather than at startup
      -- keeps it a diagnostic knob and not a configuration surface.
      exactAffordable = nNormedEstimate <= exactPopulationLimit
      nNormedEstimate = length normed
      -- The second component is how many terms the test NORMALISED to reach
      -- its answer.  I attributed a size-6 stall to this filter without
      -- isolating it, and wrote that down as unresolved; this is the
      -- isolation.  The round's own work is |raw| normalisations, so a
      -- value-work figure far below that acquits the filter and one far
      -- above it convicts, with no stopwatch and no second run to compare
      -- against.  The sampled branch reports its own cost the same way:
      -- `marginalPrune` normalises the probe twice.
      worthInstalling acc c
        | not exactAffordable =
            ( marginalPrune acc probe c >= K.kMinPrune (mKnobs m)
            , 2 * length probe, 0 )
        | K.kMinPrune (mKnobs m) <= 1 = collapsesSomething normedSet acc normed c
        | otherwise =
            ( exactPrune acc normed c >= K.kMinPrune (mKnobs m)
            , length normed, length normed )
      -- WHERE THE FRESH CONJECTURES DIE.  The round line reports `proved=`
      -- AFTER the kernel gate, so a round that states twenty thousand fresh
      -- conjectures and reports proved=0 has told the reader nothing about
      -- WHICH stage refused them -- the semantic firewall, the prover, the
      -- marginal-prune test that discards true statements with no
      -- consequences, or the gate.  Those are four different diseases with
      -- four different treatments, and from round 16 of a 70-round run they
      -- are indistinguishable in the log.  Counted here, printed as PROVER.
      (proverStats, results, dispositions, absences) =
        let zero4 = (0, 0, 0, 0, 0, 0) :: (Int, Int, Int, Int, Int, Int)
            (_, out, dl, st, ab) = foldl' attempt (rules, [], [], zero4, []) fresh
        in (st, reverse out, M.fromList dl, M.fromList ab)
      -- SEEDED, i.e. a researcher candidate from the thought file rather than
      -- a shape the generator happened to build.  The distinction buys exactly
      -- one thing, below: the VALUE gate, and nothing else.
      seededSet = S.fromList (map canonVars (mThoughts m))
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
      attempt (acc, out, dl, (nRewritten, nFirewall, nNoProof, nInert, nWork, nScan), ab) c
        -- THE VETO WAS LIFTED IN ONE OF THE TWO PLACES IT LIVES.
        --
        -- `freshSized` builds `fresh` and this fold consumes it, and both
        -- applied `provedByRewriting`.  Lifting it only in `freshSized` let
        -- residuals into `fresh` -- `RESIDUAL-REACHED-PROVER` duly reported
        -- 21 of 21 -- and this guard dropped them again on the next line.  So
        -- across every run since that change, `x = x+0` entered the candidate
        -- list and still never appeared on any of the 5160 KERNEL lines, and I
        -- read the first number as evidence the fix had landed.
        --
        -- Same reasoning as there: a residual is a question the KERNEL asked,
        -- and the rewriter deriving it is not an answer to that question.
        -- Only `mKnown`/`mFailed` -- the kernel's own record -- may drop one.
        | provedByRewriting acc c
        , not (S.member c residualAdmitted)
        , not (S.member c arohanaAdmitted) =
            (acc, out, (c,"follows-by-rewriting"):dl
            , (nRewritten + 1, nFirewall, nNoProof, nInert, nWork, nScan), ab)
        -- Proof search is only as trustworthy as its current axiom set and
        -- induction implementation.  This finite gate does not certify a
        -- theorem; it prevents any theorem with a concrete small refutation
        -- from becoming a new axiom and poisoning every later round.
        | not (survivesSemanticFirewall syms c) =
            (acc, out, (c,"firewall-refuted"):dl
            , (nRewritten, nFirewall + 1, nNoProof, nInert, nWork, nScan), ab)
        | otherwise =
            -- WIRE 3.  `proveByInduction` first, always; the nested prover is
            -- consulted only where it returned Nothing, so no proof this
            -- engine used to find is found by a different route now.  At
            -- dNestedDepth = 0 the second disjunct is `Nothing` immediately.
            --
            -- WIRE 6.  The failure branch now carries the yogya verdict of the
            -- search that failed.  `inducted` is forced exactly where
            -- `proveByInduction acc c` was; `nested` exactly where
            -- `nestedProve` was.
            let inducted = proveByInductionA acc c
                found = case inducted of
                  Right pf -> Just pf
                  Left _   -> nestedProve (dNestedDepth disp) acc c
                -- The nested prover IS budgeted: `NI.prove` takes a fuel and
                -- returns Nothing both when it exhausts the space and when it
                -- runs out.  It cannot tell the two apart, so consulting it
                -- and getting nothing destroys the yogya condition for this
                -- conjecture -- honestly, and by construction rather than by
                -- inspection.  At dNestedDepth = 0 it was never consulted and
                -- the inductive verdict stands.
                absence = case inducted of
                  Right _ -> Ayogya "proved"     -- unreachable below
                  Left a
                    | dNestedDepth disp > 0 ->
                        Ayogya ("the nested prover was consulted at budget "
                                ++ show (dNestedDepth disp)
                                ++ " and cannot report whether that budget "
                                ++ "exhausted its search space")
                    | otherwise -> a
            in case found of
              Nothing ->
                (acc, out, (c,"attempted-no-proof"):dl
                , (nRewritten, nFirewall, nNoProof + 1, nInert, nWork, nScan)
                , (c, absence) : ab)
              -- a proof is not enough: it must also make the world smaller,
              -- or it is a true statement with no consequences
              Just pf ->
                -- THE VALUE GATE AND WHO IT IS FOR.  `worthInstalling` asks
                -- whether installing this theorem collapses two of the terms
                -- the generator built this round.  For a shape the generator
                -- built, that is exactly the right question and it stays the
                -- question.  For a SEEDED candidate it is the wrong one twice
                -- over: the researcher already asserted the interest, and --
                -- measured, WIRE 5, round 0 -- a definitionally eliminable
                -- symbol cannot pass it even in principle.  `normed` is the
                -- NORMALISED term population, `leglo`, `leghi` and
                -- `splitnorm` all unfold, so not one of the 241 normal forms
                -- at vocab=11 size=4 contains a pair symbol and no pair
                -- theorem can collapse any pair of them.  Five true, proved
                -- pair statements died here on the first run after the
                -- induction fix, with `proved-but-inert=5` the only trace.
                --
                -- So the exemption is exactly this gate and exactly for
                -- thought-file candidates.  Everything that decides TRUTH is
                -- unchanged and still applies to them: the symbol and
                -- well-formedness check, fingerprint agreement, the semantic
                -- firewall above, the prover, and the Agda kernel gate below,
                -- which is the authority and has no idea where a candidate
                -- came from.  THOUGHT_FORMAT.md's "receives no privileged
                -- proof status" is about proof, and stays true.
                -- THE VALUE GATE ANSWERS IN THE WRONG CURRENCY FOR A RESIDUAL.
                --
                -- `worthInstalling` asks how many terms of the population
                -- normalise differently once the rule is installed.  That is
                -- the REWRITER's question and it is the right one for a
                -- generated conjecture.  For a residual it is guaranteed to
                -- answer zero, and for the same reason the kernel asked:
                -- `normed` is already normalised with respect to the machine's
                -- defining rules, so `x + 0` does not occur in it, so
                -- installing `x + 0 -> x` collapses nothing.  Value 0.  The
                -- machine assigns zero worth to the one lemma the kernel most
                -- needs, BECAUSE it already has it -- which is precisely what
                -- makes the kernel unable to proceed without it.
                --
                -- Measured, not argued: RESIDUAL-DISPOSITION prints
                -- `proved-but-inert` for x = (x+0), 0 = (x*0),
                -- (x*(y+0)) = ((x*y)+(x*0)) and ((xmaxy)+0) = ((x+0)max(y+0)),
                -- and `never-reached-fresh` for the same four the round after,
                -- once mFailed has them.
                --
                -- The exemption already existed for thought-file candidates,
                -- and a residual has the stronger claim to it: a seeded
                -- candidate is a human's suggestion, a residual is the kernel
                -- stating what it needs.  Truth is untouched -- the firewall,
                -- the prover and the kernel gate all still apply.
                let seeded = S.member c seededSet
                    asked  = S.member c residualAdmitted
                             || S.member c arohanaAdmitted
                    (worth0, work, scan) = worthInstalling acc c
                    worth = worth0 || seeded || asked
                    tag | worth0    = "proved"
                        | seeded    = "proved-inert-seeded"
                        | asked     = "proved-inert-kernel-asked"
                        | otherwise = "proved-but-inert"
                    st' = (nRewritten, nFirewall, nNoProof, nInert
                          , nWork + work, nScan + scan)
                in if not worth
                     then (acc, out, (c,tag):dl
                          , (nRewritten, nFirewall, nNoProof, nInert + 1
                            , nWork + work, nScan + scan), ab)
                     else
                       let acc' = acc ++ maybe [] (:[]) (orient c)
                                   ++ (if isJust (orient c) then []
                                       else lemmaRules [c])
                       in (acc', (c,pf):out, (c,tag):dl, st', ab)
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
  -- Was `filterM (kernelAcceptWith ...) results`.  Same call, same order, same
  -- decision -- `koAccepted` is the Bool `filterM` was reading -- but the
  -- refusal is kept alongside it instead of being discarded.
  outcomes <- mapM (\cand -> do
                      ko <- kernelAcceptWith (kernelSyms m) (M.keys (mKnown m))
                              rules logh (mRound m) cand
                      pure (cand, ko))
                   results
  let checkedResults = [ cand | (cand, ko) <- outcomes, koAccepted ko ]
      -- the same list, each entry carrying the naya that actually closed it.
      -- This is what goes into memory; `checkedResults` is left exactly as it
      -- was so that every count, filter and fold below is unchanged.
      checkedWithNaya = [ (cand, koNaya ko, koCalls ko) | (cand, ko) <- outcomes
                        , koAccepted ko ]
  t1 <- getCPUTime
  let secs = fromIntegral (t1 - t0) / (1e12 :: Double)
      prunedPct :: Double
      prunedPct = if null raw then 0
                  else 100 * (1 - fromIntegral (length normed)
                                  / fromIntegral (length raw))
      newRules = mapMaybe (orient . fst) checkedResults
      newLemmas = [ c | (c,_) <- checkedResults, not (isJust (orient c)) ]
      -- ---- the refusals of THIS round, read back ----
      harvest = harvestResiduals outcomes
      obTotal = length [ () | (_, ko) <- outcomes, isJust (koObstruction ko) ]
      obWeak  = length [ () | (_, ko) <- outcomes
                            , Just (OB.TacticTooWeak _) <- [koObstruction ko] ]
      obRaw   = length [ () | (_, ko) <- outcomes
                            , Just (OB.Residual _) <- [koObstruction ko] ]
      obUnparsed = length [ () | (_, ko) <- outcomes
                               , Just (OB.Unparsed _) <- [koObstruction ko] ]
      -- ---- the same decisions, read as the sevenfold ----
      --
      -- `koAccepted` is a Bool and this round's decisions do not fit in one.
      -- `koVacana` carries the evidence per decision; `sakshin` completes it
      -- with the one thing no single decision can know -- whether ANOTHER
      -- naya affirmed the same claim in this same round -- and `SB.sthana`
      -- reads the position off the completed evidence.  Nothing here feeds
      -- back into the gate: it is a report, and `checkedResults` above is
      -- untouched.
      acceptedThisRound = ordNub [ claimText c | ((c, _), ko) <- outcomes
                                 , koAccepted ko ]
      sbVacanas = [ (c, SB.sakshin acceptedThisRound (claimText c) (koVacana ko))
                  | ((c, _), ko) <- outcomes ]
      sbPositions = [ SB.sthana v | (_, v) <- sbVacanas ]
      sbTally = SB.tallySthana sbPositions
      -- one worked instance per distinct position, so the count can never be
      -- printed without the evidence that produced it
      sbExamples = go [] sbVacanas
        where
          go _ [] = []
          go seen ((c, v) : rest)
            | k `elem` seen = go seen rest
            | otherwise     = (c, v) : go (k : seen) rest
            where k = SB.sanskritOf (SB.sthana v)
      -- what triage did to the residuals, per occurrence.  The refuted count
      -- is the livelock that did NOT enter the queue, and it is the number
      -- that says whether the filter is earning its place in this run.
      obPairs = [ (fromOb a, fromOb b)
                | (_, ko) <- outcomes
                , Just (OB.Residual (a,b)) <- [koObstruction ko] ]
      obRefuted = length [ () | p <- obPairs
                              , OB.Khandita _ <- [residualVerdict p] ]
      obDegenerate = length [ () | p <- obPairs
                                 , OB.Nirdharmin _ <- [residualVerdict p] ]
      knownAfter = foldl' (\k (c,_) -> M.insert c () k) (mKnown m) checkedResults
      -- The subgoal -> parents index, cumulative.  Kept for every harvested
      -- residual, INCLUDING ones the queue has no room for, because the
      -- question "did this residual close its parent?" must still be
      -- answerable if it arrives by another route.
      residualFrom' = foldl' (\mp (sub,parent) ->
                                M.insertWith (\new old -> ordNub (new ++ old))
                                             sub [parent] mp)
                             (mResidualFrom m) harvest
      -- A residual that has already been proved, or that is already stated,
      -- is not material any more.  Everything else queues, newest first,
      -- capped -- and `residualDropped` below is what did not fit.
      residualPending = ordNub
        ( [ sub | (sub,_) <- harvest ]
          ++ mResidualQueue m )
      residualLive = [ c | c <- residualPending, not (M.member c knownAfter) ]
      residualQueue' = take kResidualQueueCap residualLive
      residualDropped = length residualLive - length residualQueue'
      -- THE NUMBER THE SEAM EXISTS FOR, in two parts.  A residual-sourced
      -- theorem is a subgoal the kernel handed back that later came back
      -- through the kernel as a theorem.  A closed parent is a candidate the
      -- kernel had REFUSED that is now accepted, and one of the residuals it
      -- stalled on is among those theorems.  The second is the whole point;
      -- the first is necessary for it and is reported separately so a partial
      -- result cannot be read as the full one.
      residualTheorems = [ c | (c,_) <- checkedResults
                             , M.member c residualFrom' ]
      residualProved' = foldl' (flip S.insert) (mResidualProved m) residualTheorems
      -- THE ASCENT, performed rather than measured.  Seeded by the subgoals
      -- that became theorems THIS round -- so it fires on the transition, once
      -- -- and climbing transitively to every ancestor above them.  Ancestors
      -- already proved are dropped: the climb summons what is still open.
      arohanaNext = [ p | p <- arohana residualFrom' residualTheorems
                        , not (M.member p knownAfter) ]
      -- The rule set this round ends with.  Used only by the dependence test
      -- below; nothing installs from it.
      roundRules = rules ++ concat
        [ maybe (lemmaRules [c]) (:[]) (orient c) | (c,_) <- checkedResults ]
      -- IS THE LEMMA LOAD-BEARING, or did the parent merely happen to be
      -- accepted in the same round?  "Accepted after its residual was proved"
      -- is a coincidence claim and this repository has been burned by
      -- coincidence claims.  The dependence claim is checkable and cheap:
      -- delete the residual's rules from the round's rule set and ask the
      -- engine's own prover again.  If the parent still goes through, the
      -- residual was not what closed it and it is not counted.
      subRules sub = maybe (lemmaRules [sub]) (:[]) (orient sub)
      dependsOnResidual sub parent =
        let without = [ rl | rl <- roundRules, rl `notElem` subRules sub ]
        in isJust (proveByInduction roundRules parent)
             && isNothing (proveByInduction without parent)
      closedParents =
        [ (p, sub)
        | (p,_) <- checkedResults
        , (sub, ps) <- M.toList residualFrom'
        , S.member sub residualProved'
        , p `elem` ps
        , dependsOnResidual sub p ]
      m' = m { mRules = mRules m ++ newRules
             , mLemmas = mLemmas m ++ newLemmas
             , mKnown = knownAfter
             , mResidualQueue = residualQueue'
             , mResidualFrom = residualFrom'
             , mResidualProved = residualProved'
             , mArohana = S.fromList arohanaNext
             -- The memo now carries WHY.  A conjecture that never reached the
             -- prover (settled by rewriting, or refuted by the firewall) has
             -- no entry in `absences`; the firewall's refutation is a
             -- concrete counterexample, which is a positive apprehension and
             -- not an anupalabdhi at all, so `Ayogya "not submitted to the
             -- prover"` is the honest default rather than a silent Yogya.
             , mFailed = foldl' (\k c -> M.insert c (nRules, absenceOf c) k)
                          (mFailed m)
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
      (proverRewritten, proverFirewall, proverNoProof, proverInert, proverWork
       , proverScan) = proverStats
      obstruction = nFresh - length checkedResults
      flow | obstruction == 0 = Resonance
           | otherwise        = flowOf (mObstruction m) obstruction
      sepP = separatedPairs classes
      gate = advanceGate nNormed sepP
      -- ------------------------------------------------------ ANUPALABDHI
      -- What the round's non-apprehension is worth.  `absences` has an entry
      -- for exactly the conjectures that reached the prover and came back
      -- without a proof; everything else was settled positively (rewritten
      -- away, refuted by counterexample, or proved) and is not an absence.
      absenceOf c = M.findWithDefault
        (Ayogya "not submitted to the prover") c absences
      roundAbsences = M.toList absences
      yogyaN  = length [ () | (_,a) <- roundAbsences, isYogya a ]
      ayogyaN = length roundAbsences - yogyaN
      firstAyogya = case [ a | (_,a) <- roundAbsences, not (isYogya a) ] of
                      (a:_) -> Just a
                      []    -> Nothing
      -- YOGYA-ANUPALABDHI OVER THE ROUND'S REGION.  Three conjuncts, and each
      -- is a fact rather than a classification:
      --
      --   (1) nothing was installed, so the rule set the round ends with is
      --       the rule set it began with;
      --   (2) every conjecture that reached the prover came back with an
      --       EXHAUSTED search: no single-variable structural induction over
      --       that rule set closes it and no normalisation was truncated;
      --   (3) the round actually looked at something -- a round with no fresh
      --       conjectures has apprehended nothing and refuted nothing, and
      --       calling that saturation is the ghost case one level up.
      --
      -- Together: every conjecture this region can state has been decided NOT
      -- provable here, and re-stating them against the same rules cannot
      -- change that.  Staying is therefore refuted, by proof.  What is NOT
      -- claimed: that these equations are false, or that a stronger prover
      -- cannot close them.  The scope is the prover's search space, and the
      -- log line says so.
      yogyaCertified = null checkedResults && ayogyaN == 0 && yogyaN > 0
      -- The LICENCE is the certificate ANDed with the control flag.  The
      -- certificate itself is computed and logged either way, so
      -- `--no-anupalabdhi` differs from the default in exactly one bit of
      -- BEHAVIOUR and in none of the reporting -- which is what makes the A/B
      -- a single-factor one.
      yogyaSaturated = yogyaCertified && dAnupalabdhi disp
  forM_ checkedWithNaya $ \(((l,r),pf), mnaya, calls) -> do
    hPrintf libh "%-46s = %-24s   [%s]\n" (show l) (show r) pf
    hPrintf logh "  THEOREM  %s = %s   (%s)\n" (show l) (show r) pf
    -- and the same theorem in the form this program can read back.  The
    -- prose library is for people; this is the machine's own memory.
    --
    -- THE THIRD FIELD, and it is the whole of sabda.  What is written is the
    -- naya the gate actually closed under -- `koNaya`, read off the shape
    -- `Certificate` returned, not off `pf`, which is the note the prover
    -- SUBMITTED and can differ (the note says "induction on x"; the shape
    -- says which of the twelve step shapes closed it, or that trace replay
    -- did).  Also the delimitor: the vocabulary in force, the variable and
    -- size horizons.  A later process reading this line can therefore ask
    -- the kernel the same question, and can see -- because the delimitor is
    -- there -- when it is no longer in a position to ask it.
    case mem of
      Nothing   -> return ()
      Just path -> appendFile path
        (P.renderRecord showTermP
           (P.MemoryRecord l r (Just (justificationOf m mnaya pf calls))) ++ "\n")
  hFlush libh
  -- ------------------------------------------------- the kuttaka's remainder
  --
  -- What the kernel refused, and what of it was material.  `parsed` counts
  -- refusals whose `A != B` came back as terms at all; `unparsed` is the
  -- honest remainder, kept as text by `Obstruction` rather than guessed at.
  -- `queued-in` is what the PREVIOUS round left, `admitted` how much of it
  -- survived the same filters every conjecture crosses, and `dropped-by-cap`
  -- is what did not fit -- a cap that does not say what it dropped reads as
  -- coverage it did not have.
  hPrintf logh
    "  OBSTRUCTION  refusals=%d parsed=%d tactic-too-weak=%d residual=%d unparsed=%d triage-refuted=%d triage-degenerate=%d material=%d distinct=%d queued-in=%d admitted=%d queued-out=%d dropped-by-cap=%d\n"
    obTotal (obWeak + obRaw) obWeak obRaw obUnparsed
    obRefuted obDegenerate
    (length harvest) (length (ordNub (map fst harvest)))
    (length (mResidualQueue m)) (S.size residualAdmitted)
    (length residualQueue') residualDropped
  -- THE VERDICT, SEVENFOLD.  Same decisions as the OBSTRUCTION line above,
  -- read through `Saptabhangi_TheSevenfoldVerdict` instead of through
  -- `koAccepted :: Bool`.  Sources for the scheme are in that module's
  -- header (Bhagavati Sutra; Umasvati, Tattvarthasutra 5.31; Siddhasena,
  -- Sanmatitarka 1.21; Samantabhadra; Akalanka, Laghiyastraya c. 720-780 for
  -- krama against saha).  The laws are checked in
  -- formal/cubical/SaptabhangiSamyoga_TheCompositionOfVerdicts.agda.
  hPrintf logh "  SAPTABHANGI  decisions=%d  %s\n"
    (length sbPositions)
    (intercalate "  " [ k ++ "=" ++ show n | (k, n) <- sbTally ])
  forM_ sbExamples $ \(c, v) -> do
    hPrintf logh "  SAPTABHANGI  %s : %s\n" (claimText c)
      (SB.sanskritOf (SB.sthana v))
    forM_ (SB.seeds v) $ \(k, w) ->
      hPrintf logh "      %s: %s\n" k (take 150 (filter (/= '\n') w))
  forM_ (take 8 (ordNub harvest)) $ \((sl,sr),(pl,pr)) ->
    hPrintf logh "  RESIDUAL  %s = %s   (%s = %s stalled here)\n"
      (show sl) (show sr) (show pl) (show pr)
  -- WHERE THE RESIDUALS ACTUALLY DIE.  `residualTally` was computed and then
  -- never used -- a dead binding, in the one diagnostic this file's own
  -- comment calls "the diagnostic that decides whether the wire can pay at
  -- all".  781 residuals were harvested across the 239 rounds in machine.log
  -- and RESIDUAL-THEOREM appears zero times in it, and nothing recorded why,
  -- because the answer was being computed and thrown away every round.
  forM_ residualTally $ \(status, n) ->
    hPrintf logh "  RESIDUAL-FATE  %-40s %d   e.g. %s\n" status n
      (intercalate " | "
        [ showTermP (fst c) ++ " = " ++ showTermP (snd c) | c <- take 3 (ordNub (map canonVars (mResidualQueue m)))
                       , residualStatus (canonVars c) == status ])
  -- AND WHETHER IT ACTUALLY REACHED THE PROVER.  A tally by status is still a
  -- claim about what the filter WOULD do; this is what the round did.  Added
  -- after an hour of inferring from counts why `x = x+0` never appears on a
  -- KERNEL line despite being harvested ten times in one run -- inference from
  -- aggregates is exactly the substitute for measurement this protocol
  -- forbids, and I was doing it.
  hPrintf logh "  RESIDUAL-REACHED-PROVER  %d of %d queued\n"
    (length [ () | c <- ordNub (map canonVars (mResidualQueue m))
                 , c `elem` fresh ])
    (length (ordNub (map canonVars (mResidualQueue m))))
  -- AND WHAT BECAME OF EACH ONE, from the fold's own record rather than
  -- re-derived here against a different rule set.
  --
  -- Added after a PREDICTION FAILED.  Both `provedByRewriting` guards were
  -- lifted, `RESIDUAL-REACHED-PROVER` reported 21 of 21 and then 40 of 40, and
  -- `x = x+0` still appeared on none of the kernel lines -- while
  -- `--prove-residuals` says the prover finds `induction on x` for exactly
  -- that goal at the full vocabulary.  Those cannot both be true of the same
  -- rule set, so the rule set differs, and guessing which way is what the last
  -- three rounds of this investigation were.  This prints the answer.
  forM_ (take 8 (S.toList residualAdmitted)) $ \c@(rl, rr) -> do
    let v | c `elem` map fst checkedResults  = "THEOREM"
          | c `elem` map fst results         = "proved-kernel-rejected"
          | Just d <- M.lookup c dispositions = d
          | c `notElem` fresh                = "never-reached-fresh"
          | otherwise                        = "withheld"
    hPrintf logh "  RESIDUAL-DISPOSITION  %-24s %s = %s\n" v (show rl) (show rr)
  forM_ residualTheorems $ \(l,r) ->
    hPrintf logh "  RESIDUAL-THEOREM  %s = %s   (this subgoal came out of a kernel refusal)\n"
      (show l) (show r)
  -- The claim this line makes is the strong one and it is checked, not
  -- inferred from co-occurrence: the parent goes through with the residual's
  -- rules in the set and does NOT go through without them.
  forM_ closedParents $ \((pl,pr),(sl,sr)) ->
    hPrintf logh "  RESIDUAL-CLOSES-PARENT  %s = %s   needs   %s = %s\n"
      (show pl) (show pr) (show sl) (show sr)
  -- The climb, named per parent so the ascent is auditable and not just a
  -- count: this is the machine going back up the vallī of its own accord.
  forM_ arohanaNext $ \(pl,pr) ->
    hPrintf logh "  AROHANA  %s = %s   (summoned: a subgoal it stalled on is now a theorem)\n"
      (show pl) (show pr)
  -- SEED DISPOSITION.  A seeded candidate that never appears in the log is
  -- indistinguishable from one that was never read, and on the first WIRE 5
  -- run that ambiguity cost a measurement: 20 pair candidates went in, the
  -- round line said conj=39 fresh=31 proved=0, and nothing said whether the
  -- pair statements had been refuted, rewritten away, tried and failed, or
  -- silently dropped for a missing symbol.  They are four different diseases.
  -- One line per researcher candidate, naming the stage it stopped at.
  forM_ (mThoughts m) $ \c0 -> do
    let c@(l,r) = canonVars c0
        missing = [ f | f <- symbolsIn l ++ symbolsIn r
                      , f `notElem` map symName syms ]
        verdict
          | not (null missing)             = "out-of-vocabulary:" ++ intercalate "," (ordNub missing)
          | not (wellFormedTerm syms l && wellFormedTerm syms r) = "ill-formed"
          -- must precede the fingerprint line: `fingerprint` would index an
          -- environment narrower than the candidate.  See `variableHorizon`.
          | any (>= nvEnv) (vars l ++ vars r) = "too-many-variables"
          | fingerprint sem envs l /= fingerprint sem envs r = "refuted-by-fingerprint"
          | M.member c (mKnown m)          = "already-known"
          | provedByRewriting rules c      = "follows-by-rewriting"
          | congruent rules (mKnown m) c   = "congruent-with-known"
          | c `elem` map fst checkedResults = "THEOREM"
          | c `elem` map fst results       = "proved-kernel-rejected"
          -- the prover's own verdict, recorded by the fold that produced it,
          -- not re-derived here against a different rule set
          | Just d <- M.lookup c dispositions = d
          | otherwise                      = "withheld"
    hPrintf logh "  SEED  %-22s %s = %s\n" verdict (show l) (show r)
  -- The four ways a fresh conjecture fails to become a theorem, and the
  -- fifth number is the gate's.  `proved` here is the PROVER's count; the
  -- round line's `proved=` is what survived the kernel.  When they differ
  -- the difference is exactly the KERNEL-REJECT lines above.
  hPrintf logh
    "  PROVER  fresh=%d already-rewritten=%d firewall-refuted=%d no-proof=%d proved-but-inert=%d proved=%d gated=%d value-test=%s value-work=%d value-scan=%d round-work=%d\n"
    (length fresh) proverRewritten proverFirewall proverNoProof proverInert
    (length results) (length checkedResults)
    (if exactAffordable then "exact" else "sampled" :: String)
    proverWork proverScan nRaw
  -- ANUPALABDHI, split.  `no-proof` above is the boolean the machine used to
  -- record; these two are what it was hiding.  `yogya` is the part that is
  -- knowledge -- the search space was exhausted, so no proof exists in it --
  -- and `ayogya` is the part that is not, with the first reason quoted so the
  -- cut-off is nameable rather than a total.
  hPrintf logh "  ANUPALABDHI  no-proof=%d yogya=%d ayogya=%d%s\n"
    (length roundAbsences) yogyaN ayogyaN
    (case firstAyogya of
       Nothing -> "" :: String
       Just a  -> "  first-cutoff=" ++ absenceReason a)
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
  -- WIRE 7.  What the composition law produced this round, and the negative
  -- control on it.  `refuted` is the count of composed equations whose two
  -- sides DISAGREE on the fingerprint.  A composed equation is an equational
  -- consequence of rules the machine holds, so this number must be 0; a
  -- nonzero value is a report that either a rule is unsound or the law is
  -- misapplied, and it is printed rather than assumed away.
  when (dSamasa disp > 0) $
    hPrintf logh "  SAMASA  examined=%d novel=%d admitted=%d refuted=%d  (refuted must be 0: a composed equation is true by algebra)%s\n"
      (length composedRaw) (length composedNovel)
      (length samasaAdmittedList) (length composedRefuted)
      (if dSamasaOnly disp
         then "  [samasa-only: the fingerprint classes proposed nothing]"
         else "")
  -- WIRE 8.  What the round is proposing in the KERNEL's currency, printed
  -- whether or not the wire is on -- both arms of an A/B therefore see the
  -- same numbers and differ in one bit of BEHAVIOUR, which is the control
  -- WIRE 6 established and this wire keeps.
  --
  --   retained  composed pairs kept (with --paksa, includes the M-joinable
  --             ones in their unnormalised form; without, it equals novel)
  --   k-refl    of `fresh`, how many `kernelJoins` predicts cost ONE agda
  --             call.  A prediction, never a licence: kernelAccept is still
  --             the authority and still runs on every one of them.
  --   k-stuck   the rest, costing two to eight calls and often refused.
  hPrintf logh "  PAKSA  %s  retained=%d  k-refl=%d k-stuck=%d  (prediction only; kernelAccept decides)\n"
    (if dPaksa disp then "on " else "off")
    (length composedRetained)
    (length [ () | c <- fresh, kernelJoins c ])
    (length [ () | c <- fresh, not (kernelJoins c) ])
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
      --
      -- WIRE 6.  THE THIRD LICENCE, AND IT IS THE ONLY ONE THAT IS A PROOF.
      -- `stuck'` and `widenOnly` are readings of KFlow's classification of ∂:
      -- heuristics, and good ones, but they are guesses about whether the
      -- frontier is worth another pass.  `yogyaSaturated` is not a guess.  It
      -- says every conjecture the round stated came back from an EXHAUSTED
      -- search over the rule set the round is still holding, so another pass
      -- over the same region cannot close any of them.  Staying is refuted.
      --
      -- What this overrides, and why it is allowed to.  FLOW-HOLD holds the
      -- horizon on a branching round, on the argument that "the frontier is
      -- growing faster than the machine closes it".  That argument reads ∂ as
      -- a backlog of unexamined questions.  Under yogya-anupalabdhi ∂ is not a
      -- backlog: every one of its elements has been examined to exhaustion and
      -- refuted within the prover's reach.  A ∂ that grew because the machine
      -- refuted more things is not the pathology FLOW-HOLD was written
      -- against, and holding on it is holding on a miscount.
      --
      -- WHICH AXIS, derived rather than laddered.  The certificate is about a
      -- RULE SET: "no proof of any stated conjecture exists over these rules".
      -- Deepening leaves the rule set alone and hands the same refuting
      -- instrument a larger pile of terms; widening (or coining a concept)
      -- adds a symbol WITH its defining equations, which changes the rule set
      -- and therefore voids the certificate's own hypothesis.  So the move
      -- that provably escapes the certified region is the vocabulary move, and
      -- the horizon move is what is left when the vocabulary is spent.  That
      -- is exactly the order the ladder below already runs -- measured into
      -- place by arm D of machine/LOOP_MEASUREMENT.md -- and it is now derived
      -- from the certificate instead of only measured.
      -- THE LICENCE IS DISCHARGED BY ANY CHANGE, NOT ONLY BY GROWTH.  The
      -- certificate says "something in this region must change".  Coining a
      -- concept IS that change -- the new symbol arrives with its defining
      -- equation, so the rule set the certificate quantifies over is not the
      -- rule set of the next round, and the certificate is void before it can
      -- be spent again.  Letting it also license a widen in the same round
      -- would be naming AND widening at once, which is the term-space
      -- explosion `bestOf`'s own comment measures (25k -> 396k with `proved`
      -- flat at zero).  `stuck'` already excludes the coining round for the
      -- same reason; this is that exclusion, kept.
      yogyaMove = yogyaSaturated && not (isJust invented)
      grows   = permitted && (stuck' || widenOnly || yogyaMove)
      deepens = permitted && (stuck' || yogyaMove)
  -- ===================================================================
  -- WIRE 4.  CERTIFY, and it fires in exactly one place: the instant before
  -- the machine would have widened blindly.  `grows` is that instant -- it is
  -- the predicate the whole growth ladder below is gated on -- so at
  -- dCertify = 0, or on any round that was not going to grow anyway, nothing
  -- below runs, nothing is logged, and the enumeration is never forced.  The
  -- live loop is unchanged by construction rather than by inspection.
  --
  -- The sequence is the one machine/THE_MACHINE.md specifies:
  --   CLOSE (the round above) -> CERTIFY -> {PORT menu, then GROW}
  --                                       | {install and continue}
  -- ===================================================================
  let syms2 = take (mVocab m2) vocabulary ++ mInvented m2
      vocabNames = intercalate "," (map symName syms2)
  certified <- if dCertify disp <= 0 || not grows
                 then pure Nothing
                 else do
                   -- The guard on `certifySeam` is silent by design -- it
                   -- degrades to a correct weaker test rather than failing --
                   -- so the ONLY place it can be seen is here.  A round that
                   -- certified under the fallback must not read like a round
                   -- that certified under Certify.hs.
                   unless certifyTranscriptionAgrees $
                     hPrintf logh "  CERTIFY-TRANSCRIPTION-DRIFT  machine/Certify.hs no longer agrees with this file on the reduction order or the rewrite strategy over the rules in play (its vocabulary is %s; this file's is %s); the joinability oracle is NOT in use this round, the in-file strategy-join fallback is, and it is strictly weaker\n"
                       (intercalate "," CY.vocabularyNames)
                       (intercalate "," (map symName vocabulary))
                   pure (Just (certifySeam (dCertify disp) (usableRules m2)))
  installedCP <- case certified of
    Nothing -> pure Nothing
    -- The budget ran out with no divergence.  This proves NOTHING: an
    -- unexamined critical pair may still diverge.  Say so and let the ladder
    -- run exactly as it did before the wire existed.
    Just (Budgeted n) -> do
      hPrintf logh "  CERTIFY-BUDGET  %d critical pairs examined, none diverged, budget spent; this is NOT a saturation proof, growing as before\n" n
      pure Nothing
    -- All critical pairs joined.  Termination is free here (every rewrite
    -- strictly decreases in `decreases`, a well-founded order), so by Newman
    -- the system is confluent and normalisation decides its equational
    -- theory.  That is a theorem about the wall, and the machine now knows
    -- where its wall is instead of assuming it has hit one.
    Just (Convergent n) -> do
      hPrintf logh "  THEOREM  saturation over {%s}: no equation derivable from the %d installed rules remains undecided by normalisation; proof: all %d critical pairs join, and the rewrite relation terminates (every step decreases in LPO-with-size-fallback), so Newman gives confluence.  SCOPE: the equational theory of the installed rules, NOT the inductive theory -- true-but-not-derivable equations are the prover's job, not this certificate's.\n"
        vocabNames (length (usableRules m2)) n
      let rep = residualSeam disp m2
          tag = if rrStubbed rep then "[seam-stub: machine/Residual.hs absent] " else ""
      forM_ (rrRemainder rep) $ \line ->
        hPrintf logh "  RESIDUAL  %s%s\n" tag line
      hPrintf logh "  PORT-MENU  %s%s\n" tag
        (if null (rrPortMenu rep) then "empty: nothing left to grant at this cap"
                                  else intercalate " | " (rrPortMenu rep))
      pure Nothing
    -- A critical pair that does not join.  Both sides descend from one peak by
    -- one rewrite each with rules already installed, so they are equal in the
    -- theory; they are unequal as normal forms, so the equation is not yet
    -- known.  This is a new equation that generate-and-test did not state --
    -- and it is found by completion, which is why the response is to install
    -- it and keep working rather than to widen.
    Just (Divergent n cp) -> do
      let eq = cpEquation cp
          note = "critical pair: " ++ show (fst (cpOuter cp)) ++ " = "
                 ++ show (snd (cpOuter cp)) ++ " over " ++ show (fst (cpInner cp))
                 ++ " = " ++ show (snd (cpInner cp)) ++ " at peak " ++ show (cpPeak cp)
      hPrintf logh "  CERTIFY-DIVERGENT  after %d joined pairs: %s = %s  (%s)\n"
        n (show (fst eq)) (show (snd eq)) note
      if fst eq == snd eq || M.member eq (mKnown m2)
        then do
          hPrintf logh "  CERTIFY-SKIP  the divergent pair is already known; growing as before\n"
          pure Nothing
        else if not (wellFormedTerm syms2 (fst eq) && wellFormedTerm syms2 (snd eq))
          then do
            hPrintf logh "  CERTIFY-SKIP  the divergent pair is outside the current well-formed fragment; growing as before\n"
            pure Nothing
          -- The same finite firewall every other candidate crosses.  A
          -- critical pair is valid whenever its parents are, so a failure here
          -- is a report about the parents, not about completion.
          else if not (survivesSemanticFirewall syms2 eq)
            then do
              hPrintf logh "  CERTIFY-REJECT  the divergent pair has a concrete counterexample below the audit bound; NOT installed, and the rules that produced it are suspect\n"
              pure Nothing
            -- and the same kernel, because the invariant is that every rule in
            -- play was accepted in THIS process.  Completion gets no exemption.
            else do
              ok <- koAccepted <$> kernelAcceptWith (kernelSyms m2)
                      (M.keys (mKnown m2))
                      (usableRules m2) logh (mRound m2) (eq, note)
              if not ok
                then do
                  hPrintf logh "  CERTIFY-HOLD  the kernel would not certify the divergent pair; it is NOT installed and the growth ladder runs unchanged\n"
                  pure Nothing
                else do
                  hPrintf logh "  COMPLETE  installing %s = %s as a %s; growth is held this round -- Knuth-Bendix completion is the cheaper move and it is the one the equation asked for\n"
                    (show (fst eq)) (show (snd eq))
                    (if isJust (orient eq) then "rule" else "lemma")
                  hPrintf libh "%-46s = %-24s   [%s]\n" (show (fst eq)) (show (snd eq)) note
                  hFlush libh
                  case mem of
                    Nothing   -> return ()
                    Just path -> appendFile path
                      (showTermP (fst eq) ++ "\t" ++ showTermP (snd eq) ++ "\n")
                  pure (Just eq)
  let -- The completed state.  When nothing was installed this is `m2` itself,
      -- so every expression below reads exactly as it did before WIRE 4.
      m3 = case installedCP of
        Nothing -> m2
        Just eq -> m2
          { mRules  = mRules m2 ++ maybe [] (:[]) (orient eq)
          , mLemmas = mLemmas m2 ++ [ eq | not (isJust (orient eq)) ]
          , mKnown  = M.insert eq () (mKnown m2) }
      -- COMPLETION BEATS GROWTH.  A round that installed a divergent pair is
      -- not barren any more: it closed something.  Widening on top of that
      -- would be the old blind move with an extra symbol's cost attached, and
      -- the next round can now use the equation it just gained.
      grows'   = grows && not (isJust installedCP)
      deepens' = deepens && not (isJust installedCP)
      -- Γ↝ over the growth moves whose cost this machine has actually
      -- observed.  No history for a move means no route for it, and the
      -- ladder below decides instead: a weight is recorded or it does not
      -- exist, never estimated.  (In fact there is never a history --
      -- see the unreachability argument at `gammaRoute`.)
      routed = if grows'
                 then gammaRoute (mCosts m3) (mVocab m3) (mSize m3)
                 else Nothing
      m'' | not grows' = m3
          -- `dVocabCap disp`, not `length vocabulary`: the arithmetic symbols
          -- exist in the list but are out of reach at the default cap, so the
          -- ladder terminates exactly where it did before (WIRE 1).
          | Just (Widen,_,_) <- routed, mVocab m3 < dVocabCap disp =
              m3 { mVocab = mVocab m3 + 1 }
          | Just (Deepen,_,_) <- routed, deepens'
          , mSize m3 < K.kSizeCap (mKnobs m3) =
              m3 { mSize = mSize m3 + 1 }
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
          | mVocab m3 < dVocabCap disp = m3 { mVocab = mVocab m3 + 1 }
          -- The vocabulary is spent.  At resonance the machine may go on
          -- to the horizon; at branching it may not, and holds -- that is
          -- the FLOW-HOLD below, and it is now the only thing FLOW-HOLD
          -- means.
          | not deepens' = m3
          | mSize m3 < K.kSizeCap (mKnobs m3) = m3 { mSize = mSize m3 + 1 }
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
          | otherwise = case reverse (mInvented m3) of
              s:rest -> case conceptRule s of
                Just (pat,_) ->
                  m3 { mInvented = reverse rest
                     , mRetired = mRetired m3 ++ [canonTerm pat] }
                Nothing -> m3 { mInvented = reverse rest }
              -- Nothing left to withdraw and nothing left to widen: the
              -- machine genuinely needs more room, and saying so by raising
              -- the horizon is now the honest move rather than the lazy one.
              [] -> m3 { mSize = mSize m3 + 1 }
  case routed of
    Just (mv,c,stay) ->
      hPrintf logh "  ROUTE  %s  cost %d < stay %d  (min-plus over observed weights)\n"
        (moveName mv) c stay
    Nothing -> return ()
  -- ------------------------------------------------------- WIRE 6: ANUPALABDHI
  -- The round's verdict on its own boundary, printed whether or not it is
  -- favourable.  A round that cannot certify its non-apprehension says so, and
  -- says which cut-off spoiled it, so an unearned saturation is never silent.
  if yogyaCertified
    then hPrintf logh "  THEOREM  yogya-anupalabdhi over {%s} at size %d: all %d conjectures this round stated were refuted by an EXHAUSTED search -- for each, every single-variable structural induction over the %d installed rules was attempted and every normalisation in those attempts reached a fixed point (none hit the %d-step fuel).  Nothing was installed, so the rule set is unchanged, and re-stating these conjectures against it cannot close any of them: staying in this region is refuted, not merely unpromising.  SCOPE: the prover's search space, NOT arithmetic -- these equations may be true and a stronger prover may close them; what is proved is that THIS prover would have found a proof had one been in its reach, and did not.\n"
           vocabNames (mSize m2) yogyaN (length (usableRules m2)) kNormalizeFuel
    else when (ayogyaN > 0) $
           hPrintf logh "  ANUPALABDHI-AYOGYA  %d of %d failures were cut off rather than exhausted%s; this round proves nothing about its own boundary and the ladder runs on the flow classification as before\n"
             ayogyaN (length roundAbsences)
             (case firstAyogya of
                Nothing -> "" :: String
                Just a  -> " (first: " ++ absenceReason a ++ ")")
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
  when (mVocab m'' > mVocab m3) $
    hPrintf logh "  GROW  vocabulary widens to %d symbols (%s)\n"
      (mVocab m'') (symName (vocabulary !! (mVocab m'' - 1)))
  when (mSize m'' > mSize m3) $
    hPrintf logh "  GROW  size horizon rises to %d\n" (mSize m'')
  when (length (mInvented m'') < length (mInvented m3)) $
    hPrintf logh "  RETIRE  %s went unused; withdrawn, and it will not be re-proposed\n"
      (case reverse (mInvented m3) of
         s:_ -> symName s
         []  -> "<none>")
  -- WHICH ROUNDS OWE THEIR MOVE TO THE CERTIFICATE.  `stuck' || widenOnly` is
  -- the heuristic ladder's own trigger, so a round where it is false and the
  -- state still moved is a round the ladder would have spent standing still.
  -- That is the whole measurement, and it is a count of rounds, not a rate.
  when (yogyaMove && not (stuck' || widenOnly)
        && (mVocab m'' /= mVocab m3 || mSize m'' /= mSize m3
            || length (mInvented m'') /= length (mInvented m3))) $
    hPrintf logh "  GROW-DERIVED  the move above was taken on the saturation certificate, not on the flow classification (flow was %s, which would have held)\n"
      (flowName flow)
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
    putStrLn ("  pair extension: "
      ++ intercalate " " (map symName pairVocabulary))
    putStrLn ("  arithmetic extension: "
      ++ intercalate " " (map symName arithVocabulary))
    putStrLn ("  reachable now: "
      ++ intercalate " " (map symName (take (dVocabCap disp) vocabulary)))
    exitSuccess
  -- ---------------------------------------------------------- vipratiṣedha
  --
  -- The scheduler doing visible work on the engine's OWN rule set.  Three
  -- things are printed and all three are computed, none stored:
  --
  --   (a) a conflict that used to be decided by list position and is now
  --       decided by a NAMED metarule, with the name;
  --   (b) what 1.4.2 alone would have done to it, so the ranking is seen to
  --       matter rather than asserted to;
  --   (c) every site in the base definitional rule set where all four
  --       metarules go silent, written out as a defect and not broken.
  when (args == ["--vipratisedha-self-test"]) $ do
    let defs = definitionsOf baseVocabulary
        comm = (bin "+" x_ y_, bin "+" y_ x_)      -- a proved theorem, oriented
        rules = defs ++ [comm]                     -- exactly usableRules' shape
        site = bin "+" (su zero_) zero_            -- s(0) + 0
    putStrLn "VIPRATIṢEDHA -- which rule fires, and by which metarule."
    putStrLn ""
    putStrLn ("  rule set: " ++ show (length defs) ++ " defining clauses of "
              ++ intercalate " " (map symName baseVocabulary)
              ++ ", then 1 proved theorem (+ is commutative).")
    putStrLn ("  This is the shape of `usableRules`: definitions concatenated in"
              ++ " front of proved rules.")
    putStrLn ""
    putStrLn ("  site: " ++ showTermP site)
    let contenders = [ (i, showRuleBrief r)
                     | (i, r@(l, rr)) <- zip [0 :: Int ..] rules
                     , Just sub <- [match l site]
                     , decreases site (applySub sub rr) ]
    forM_ contenders $ \(i, s) ->
      putStrLn ("    candidate [" ++ show i ++ "]  " ++ s)
    case topResolve rules site of
      Nothing -> hPutStrLn stderr "vipratisedha self-test: no rule fired" >> exitFailure
      Just (v, by, lost, mdosa) -> do
        putStrLn ""
        putStrLn ("  fires:   " ++ showTermP site ++ "  ⇒  " ++ showTermP v)
        putStrLn ("  metarule: " ++ V.showBalya by)
        putStrLn ("  beat:     " ++ intercalate ", " (map V.showSthana lost))
        case mdosa of
          Nothing -> pure ()
          Just d  -> mapM_ putStrLn (V.showDosa d)
        -- (b) what para alone would have done
        let paraOnly = last [ applySub sub rr
                            | (l, rr) <- rules
                            , Just sub <- [match l site]
                            , decreases site (applySub sub rr) ]
        putStrLn ("  under 1.4.2 paratva ALONE the later rule wins and the answer"
                  ++ " would be " ++ showTermP paraOnly ++ " --")
        putStrLn ("  which is why apavāda outranks para and not the reverse"
                  ++ " (Paribhāṣenduśekhara 38).")
        unless (by == V.Apavada && v == su zero_ && paraOnly == bin "+" zero_ (su zero_)) $ do
          hPutStrLn stderr "vipratisedha self-test: expected apavāda to decide this site"
          exitFailure
    -- (c) the defect ledger over the base definitions
    putStrLn ""
    putStrLn "  DEFECTS in the base definitional rule set -- sites where all four"
    putStrLn "  metarules go silent.  Nothing is broken here; each is written."
    let pop = [ bin f a b | f <- ["+","*","max","-"]
              , a <- [zero_, su zero_], b <- [zero_, su zero_] ]
              ++ [ su zero_, zero_ ]
        (decided, defects) = vipratisedhaCensus defs pop
    putStrLn ("  sites resolved by a named metarule: " ++ show (length decided))
    putStrLn ("  sites undecided (written below):    " ++ show (length defects))
    forM_ defects $ \(t, d) -> do
      putStrLn ""
      putStrLn ("  at " ++ showTermP t ++ ":")
      mapM_ (putStrLn . ("  " ++)) (V.showDosa d)
      let outs = ordNub [ applySub sub rr
                        | (l, rr) <- defs, Just sub <- [match l t]
                        , decreases t (applySub sub rr) ]
      putStrLn ("    the candidates' results: "
                ++ intercalate " | " (map showTermP outs)
                ++ (if length outs == 1
                      then "  -- they agree, so the defect is inert here; "
                           ++ "that it is inert is a FACT, not a reason to stop recording it"
                      else "  -- they DISAGREE; this site is live"))
    -- (d) TRANSPORT, checked exhaustively rather than asserted.  The old
    -- line was `(x:_) -> Just x`.  Enumerate every well-formed term over
    -- {0, s, +, *, max, -} up to depth 3 and compare, at every subterm, what
    -- pūrva chose against what the scheduler chooses.  This is a finite
    -- exhaustive verification, not a sample.
    putStrLn ""
    putStrLn "  TRANSPORT -- every site, exhaustively."
    let deep = termsUpTo 3 ["0"] ["s"] ["+","*","max","-"]
        purvaAt rls u = case [ applySub sub rr
                             | (l, rr) <- rls, Just sub <- [match l u]
                             , decreases u (applySub sub rr) ] of
                          (x : _) -> Just x
                          []      -> Nothing
        sched rls u = fmap (\(v, _, _, _) -> v) (topResolve rls u)
        cmpOn rls = [ (u, a, b) | u <- deep
                    , let a = purvaAt rls u, let b = sched rls u, a /= b ]
        diffsDefs = cmpOn defs
        diffsAll  = cmpOn rules
    putStrLn ("  terms enumerated (depth <= 3): " ++ show (length deep))
    putStrLn ("  definitions only -- sites where the scheduler differs from pūrva: "
              ++ show (length diffsDefs))
    putStrLn ("  definitions + the proved theorem -- sites where it differs:       "
              ++ show (length diffsAll))
    forM_ (take 12 diffsAll) $ \(u, a, b) ->
      putStrLn ("    " ++ showTermP u ++ ":  pūrva " ++ maybe "-" showTermP a
                ++ "  vs scheduler " ++ maybe "-" showTermP b)
    when (null diffsAll) $
      putStrLn ("    none.  The engine's answers are unchanged everywhere; what "
                ++ "changed is that\n    every one of them is now attributed to a "
                ++ "named metarule, and the ties that\n    no metarule decides are "
                ++ "written instead of taken silently.")
    putStrLn ""
    putStrLn "  Astadhyayi.coverage is unmoved by this file: 4 metarules, 0 sūtras added."
    exitSuccess

  -- ------------------------------------------------- avaktavya-prasava
  --
  -- THE FOURTH POSITION DOING SOMETHING.  `--vipratisedha-self-test` above
  -- reaches the fourth position and stops: it writes the undecided site out
  -- and falls back to pūrva, the weakest paribhāṣā.  That is the fourth
  -- position as a LABEL.
  --
  -- AHIMSA_SUTRA_VISTARA §३: अवक्तव्ये शेषो वसति । शेषो गर्भः, न विफलता ।
  -- गर्भाद् अग्रिमो नयो जायते -- in the avaktavya the residue dwells; the
  -- residue is a womb, not a failure; from the womb the next naya is born.
  --
  -- So here the residue is taken and made to bear.  What is missing at an
  -- undecided site is not the answer: it is a STANDPOINT whose scope is the
  -- contested item.  Both contenders speak about it anyārtha -- in passing,
  -- on the way elsewhere (Kātyāyana, vārttika 1 on Aṣṭādhyāyī 1.4.2, in
  -- Patañjali's Mahābhāṣya c. 150 BCE: द्वौ प्रसङ्गावन्यार्थावेकस्मिन् स
  -- विप्रतिषेधः).  The birth constructs the अनवकाश rule whose only scope IS
  -- that item, declares it an apavāda to both, and re-resolves.
  --
  -- Machinery: machine/AvaktavyaPrasava_TheFourthPositionBearsTheRuleThat-
  -- DecidesIt.hs.  Nothing here is stored; every line is computed.
  when (args == ["--avaktavya-prasava"]) $ do
    let defs   = definitionsOf baseVocabulary
        tan0   = mmTantra defs
        offersAt rs u = concatMap (\s -> V.saFires s u)
                                  (V.tSasanani (mmTantra rs))
        -- every site in a population where nirnaya returns the fourth
        -- position, WITH its residue (the offers, not their names)
        fourth rs us = [ (u, dd, se)
                       | u <- us
                       , let os = offersAt rs u
                       , length os > 1
                       , V.Avaktavya dd se <- [V.nirnaya (mmTantra rs) u os] ]
        pop0 = [ bin f a b | f <- ["+","*","max","-","gcd","le"]
               , a <- [zero_, su zero_], b <- [zero_, su zero_] ]
    putStrLn "AVAKTAVYA-PRASAVA -- the fourth position bears the rule that decides it."
    putStrLn ""
    putStrLn "  Umāsvāti, Tattvārthasūtra 5.31 (c. 2nd-5th c. CE): अर्पितानर्पितसिद्धेः."
    putStrLn "  Kātyāyana, vārttika 1 on Aṣṭādhyāyī 1.4.2, in Patañjali's Mahābhāṣya"
    putStrLn "  (c. 150 BCE): two rules, each with its scope ELSEWHERE, meeting on ONE"
    putStrLn "  item -- that is vipratiṣedha.  Siddhasena Divākara, Sanmatitarka 1.21"
    putStrLn "  (c. 5th c. CE): a naya asserting itself by denying another is durnaya."
    putStrLn ""
    putStrLn "== 1. WHERE THE ENGINE REACHES THE FOURTH POSITION ====================="
    putStrLn ""
    let sites = fourth defs (ordNub (concatMap subtermsAll pop0))
    putStrLn ("  population: every f(a,b) over {+,*,max,-,gcd,le} x {0,s(0)}, "
              ++ "and every subterm.")
    putStrLn ("  sites where all four metarules go silent: " ++ show (length sites))
    putStrLn ""
    forM_ (zip [0 :: Int ..] sites) $ \(i, (u, _, se@(V.Sesa _ os))) -> do
      putStrLn ("  ---- " ++ showTermP u ++ " ----")
      putStrLn "  the residue -- the standpoints themselves, not their names:"
      forM_ os $ \nz ->
        putStrLn ("    " ++ V.showSthana (V.nyRule nz) ++ "  "
                  ++ head ([ V.saName s | s <- V.tSasanani tan0
                           , V.saRef s == V.nyRule nz ] ++ ["?"])
                  ++ "   ⇒  " ++ showTermP (V.nyResult nz))
      let sth = G.navaSthana tan0 i
          (verdict, mp, _) = G.nirnayaPrasava tan0 showTermP 4 sth u os
      case mp of
        Nothing -> putStrLn "  (decided without a birth)"
        Just p  -> mapM_ (putStrLn . ("  " ++)) (G.showPrasuti showTermP p)
      case verdict of
        V.Nirnita w lost by -> do
          putStrLn ("  VERDICT: " ++ showTermP u ++ "  ⇒  "
                    ++ showTermP (V.nyResult w))
          putStrLn ("  by      " ++ V.showBalya by)
          putStrLn ("  winner  " ++ V.showSthana (V.nyRule w)
                    ++ ", beating " ++ intercalate " " (map V.showSthana lost))
        V.Avaktavya _ _ ->
          putStrLn "  VERDICT: the fourth position stands.  Nothing was born."
      putStrLn ""
      -- guard: the birth must never change the answer the contenders gave
      case (verdict, se) of
        (V.Nirnita w _ _, V.Sesa _ os') ->
          unless (all ((== V.nyResult w) . V.nyResult) os') $ do
            hPutStrLn stderr ("avaktavya-prasava: the birth at " ++ showTermP u
                              ++ " changed an answer")
            exitFailure
        _ -> pure ()
    putStrLn "== 2. THE DERIVATION GETS FURTHER ======================================"
    putStrLn ""
    putStrLn "  `V.prakriya` STOPS at the fourth position and hands back the object"
    putStrLn "  untouched.  `G.prakriyaPrasava` bears what the position bears and"
    putStrLn "  goes on, keeping every child for the rest of the derivation."
    putStrLn ""
    forM_ [bin "max" zero_ zero_, bin "-" zero_ zero_, bin "gcd" zero_ zero_] $ \st -> do
      let (pb, db, ob) = V.prakriya tan0 64 st
          (pa, births, da, oa) = G.prakriyaPrasava tan0 showTermP 64 4 st
      putStrLn ("  start: " ++ showTermP st)
      putStrLn ("    before:  " ++ show (length pb) ++ " step(s), reached "
                ++ showTermP ob
                ++ (case db of { Just _ -> "  -- STOPPED at a written defect"
                               ; Nothing -> "" }))
      putStrLn ("    after:   " ++ show (length pa) ++ " step(s), reached "
                ++ showTermP oa ++ ", " ++ show (length births) ++ " born"
                ++ (case da of { Just _ -> "  -- still stopped"
                               ; Nothing -> "  -- no defect remains" }))
      forM_ pa $ \pd ->
        putStrLn ("      " ++ V.showSthana (V.pdRule pd) ++ "  "
                  ++ showTermP (V.pdBefore pd) ++ "  ⇒  "
                  ++ showTermP (V.pdAfter pd) ++ "   ("
                  ++ show (V.pdBalya pd) ++ ")")
      unless (null births || (length pa > length pb && (case da of { Nothing -> True ; _ -> False }))) $ do
        hPutStrLn stderr "avaktavya-prasava: a birth that got nowhere"
        exitFailure
      putStrLn ""
    putStrLn "== 3. THE BIRTH IS NOT A TIE-BREAKER ==================================="
    putStrLn ""
    putStrLn "  CONSTRUCTED WITNESS -- these two clauses are not the engine's.  The"
    putStrLn "  machine's real clause is `le(s(x),0) = 0`; `le(x,0) = 0` below is a"
    putStrLn "  false over-generalisation of it, and le(0,0) is exactly where the"
    putStrLn "  falsehood shows.  Two standpoints, neither an instance of the other,"
    putStrLn "  disagreeing on the one item they share."
    putStrLn ""
    let bad = [ (bin "le" zero_ x_, su zero_)     -- true: le(0,x) = 1
              , (bin "le" x_ zero_, zero_) ]      -- FALSE at x = 0
        badT = mmTantra bad
        badSites = fourth bad [bin "le" zero_ zero_]
    forM_ badSites $ \(u, _, V.Sesa _ os) -> do
      let (verdict, mp, _) = G.nirnayaPrasava badT showTermP 4
                               (G.navaSthana badT 0) u os
      putStrLn ("  ---- " ++ showTermP u ++ " ----")
      forM_ os $ \nz -> putStrLn ("    " ++ V.showSthana (V.nyRule nz)
                                  ++ "  ⇒  " ++ showTermP (V.nyResult nz))
      case mp of
        Just p  -> mapM_ (putStrLn . ("  " ++)) (G.showPrasuti showTermP p)
        Nothing -> pure ()
      case verdict of
        V.Avaktavya _ _ -> do
          putStrLn "  VERDICT: the fourth position stands, as it must."
          putStrLn "  And note WHAT the refusal produced: the claim `s(0) = 0`, which"
          putStrLn "  is false, so one of the two clauses is false at this item.  The"
          putStrLn "  fourth position holding is not the machine failing to answer; it"
          putStrLn "  is the machine locating the falsehood -- which a tie-breaker"
          putStrLn "  would have hidden by picking whichever clause came first."
        V.Nirnita _ _ _ -> do
          hPutStrLn stderr "avaktavya-prasava: a rule was born over a disagreement"
          exitFailure
    when (null badSites) $ do
      hPutStrLn stderr "avaktavya-prasava: the constructed witness did not reach the fourth position"
      exitFailure
    putStrLn ""
    putStrLn "== 4. TRANSPORT, EXHAUSTIVELY =========================================="
    putStrLn ""
    putStrLn "  Every well-formed term over {0,s,+,*,max,-} up to depth 3, at every"
    putStrLn "  subterm.  Finite and exhaustive, not a sample."
    let deep = ordNub (termsUpTo 3 ["0"] ["s"] ["+","*","max","-"])
        purvaAt u = case [ applySub sub rr
                         | (l, rr) <- defs, Just sub <- [match l u]
                         , decreases u (applySub sub rr) ] of
                      (v : _) -> Just v
                      []      -> Nothing
        birthAt u = case offersAt defs u of
          []  -> (Nothing, "none")
          [z] -> (Just (V.nyResult z), "eka")
          os  -> case G.nirnayaPrasava tan0 showTermP 4 (G.navaSthana tan0 0) u os of
                   (V.Nirnita w _ by, Just _, _)  -> (Just (V.nyResult w), "born:" ++ show by)
                   (V.Nirnita w _ by, Nothing, _) -> (Just (V.nyResult w), show by)
                   (V.Avaktavya _ _, _, _)        -> (Nothing, "fourth")
        rows  = [ (u, purvaAt u, birthAt u) | u <- deep ]
        diffs = [ (u, a, v) | (u, a, (v, _)) <- rows, a /= v ]
        bornN = length [ () | (_, _, (_, w)) <- rows, take 5 w == "born:" ]
        heldN = length [ () | (_, _, (_, w)) <- rows, w == "fourth" ]
    putStrLn ("  distinct terms enumerated: " ++ show (length deep))
    putStrLn ("  sites where the born-rule resolution differs from pūrva: "
              ++ show (length diffs))
    putStrLn ("  sites decided by a rule BORN from the residue:            "
              ++ show bornN)
    putStrLn ("  sites where the fourth position still holds:              "
              ++ show heldN)
    forM_ (take 8 diffs) $ \(u, a, v) ->
      putStrLn ("    " ++ showTermP u ++ ":  pūrva " ++ maybe "-" showTermP a
                ++ "  vs born " ++ maybe "-" showTermP v)
    unless (null diffs) $ do
      hPutStrLn stderr "avaktavya-prasava: TRANSPORT FAILED"
      exitFailure
    putStrLn ""
    putStrLn "  none.  Every answer the engine gives is the answer it gave before."
    putStrLn "  What changed: the sites that used to be taken by pūrva -- the"
    putStrLn "  weakest of the five paribhāṣās, applied anonymously -- are now"
    putStrLn "  decided by apavāda, the strongest, and the rule that decides them"
    putStrLn "  is one the machine did not have when it reached the fourth position."
    putStrLn "  The derivation in §2 that stopped now finishes."
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
  -- WIRE 4's own self-test: both verdicts, on rule sets whose critical-pair
  -- structure is settled by hand, so the check is a comparison against known
  -- mathematics rather than a run whose output defines what is expected.
  when (args == ["--certify-self-test"]) $ do
    -- (1) The defining equations of the base vocabulary are ORTHOGONAL: the
    -- left-hand sides are `f(x,0)` and `f(x,s(y))` shapes, which share no
    -- non-variable overlap with each other or with themselves, so the critical
    -- pair set is empty and convergence holds vacuously.  This is the state a
    -- freshly started machine is in, and the verdict is a theorem about it.
    let defs = definitionsOf (take 3 vocabulary)
        defsVerdict = certifySeam 1000 defs
    -- (2) Associativity of `+` together with its own right-unit equation has
    -- exactly one interesting overlap: unify the subterm `+(x,y)` of the
    -- associativity left-hand side with `+(x',0)`.  The peak `+(+(x,0),z)`
    -- rewrites to `+(x,+(0,z))` by associativity and to `+(x,z)` by the unit,
    -- and those two are distinct normal forms because `0+z = z` is an
    -- INDUCTIVE theorem, not a rewrite consequence.  So the pair diverges and
    -- names the missing equation -- which is the whole point of the branch.
    let assoc = ( F "+" [F "+" [V 0, V 1], V 2]
                , F "+" [V 0, F "+" [V 1, V 2]] )
        unit  = ( F "+" [V 0, F "0" []], V 0 )
        openVerdict = certifySeam 1000 [assoc, unit]
    case (defsVerdict, openVerdict) of
      (Convergent n, Divergent _ cp) -> do
        let (u,v) = cpEquation cp
        hPrintf stdout
          "CERTIFY CHECKED: definitions convergent (%d critical pairs, all join); assoc+unit divergent, completion equation %s = %s\n"
          n (show u) (show v)
        exitSuccess
      other -> do
        hPutStrLn stderr ("--certify-self-test: unexpected verdicts " ++ show other)
        exitFailure
  -- THE SEAM, END TO END, IN THIS FILE'S OWN TYPES.  `Obstruction.selfTest`
  -- checks the parser against verbatim machine.log strings; this checks the
  -- WIRE -- that a rejection string plus the goal the engine actually holds
  -- comes back out as a MathMachine conjecture, and that the junk filter and
  -- the anti-livelock contract hold on the shapes the log really contains.
  -- A PROBE, because I had spent an hour inferring from aggregate counts what
  -- the prover does with a specific goal.  `RESIDUAL-REACHED-PROVER` says the
  -- flagship residuals DO enter `fresh`; no KERNEL line ever mentions them; so
  -- the internal prover is where they stop, and this asks it directly instead
  -- of reasoning about it from the outside.
  --
  -- The goals are the top of the curriculum the kernel's own refusals demand,
  -- read off machine/machine.log rather than invented.
  when (args == ["--prove-residuals"]) $ do
    let m0 = start { mVocab = length vocabulary }   -- NOT `start`: mVocab is 3
        rules = usableRules m0
        x = V 0 ; y = V 1
        z0 = F "0" [] ; suc t = F "s" [t]
        bin f a b = F f [a,b]
        goals =
          [ ("x = x + 0",        (x, bin "+" x z0))
          , ("0 = x * 0",        (z0, bin "*" x z0))
          , ("0 = y * 0",        (z0, bin "*" y z0))
          , ("x = 0 max x",      (x, bin "max" z0 x))
          , ("0 = 0 - x",        (z0, bin "-" z0 x))
          , ("x = 1 * x",        (x, bin "*" (suc z0) x))
          , ("0 = x - x",        (z0, bin "-" x x))
          ]
    hPrintf stdout "  rules available to the prover: %d\n" (length rules)
    forM_ goals $ \(name, g) ->
      hPrintf stdout "  %-16s rewriting=%-6s induction=%s\n" name
        (show (provedByRewriting rules g))
        (maybe "NO PROOF FOUND" id (proveByInduction rules g))
    exitSuccess

  -- HOW MUCH OF THE RESIDUAL STREAM IS AN ARTEFACT OF THE CLAUSE ORDER?
  --
  -- `Certificate.hs` Note A records that Agda's `+`/`·` recurse on the FIRST
  -- argument while MathMachine's symDefs recurse on the SECOND, and justifies
  -- keeping the mismatch: the first-argument order was measured to certify
  -- strictly more of the machine's library.  That measurement priced one side.
  -- This prices the other.
  --
  -- For every distinct lemma the kernel's own refusals demand, ask whether it
  -- is already definitional under (a) the machine's clause order and (b) the
  -- mirrored one.  A lemma definitional on ONE side and not the other is a
  -- residual that exists only because the two standpoints disagree about what
  -- `+` means -- not because the machine is missing mathematics.
  --
  -- Exact counts over the real log.  No sampling, no fitting.
  -- IS THE RESIDUAL WORTH INSTALLING, IN THE MACHINE'S OWN CURRENCY?
  --
  -- `attempt` discards a PROVED candidate as "proved-but-inert" when
  -- `worthInstalling` says installing it collapses nothing, and that branch
  -- never reaches the kernel.  `exactPrune` counts exactly that: how many of
  -- the population normalise differently once the rule is added.
  --
  -- The hypothesis this measures -- and I predicted once today and was wrong,
  -- so it is measured rather than asserted -- is that the flagship residuals
  -- score exactly 0, BECAUSE the machine's own defining rules already
  -- normalise them away.  If so, the machine assigns zero value to the one
  -- lemma the kernel most needs, and does so for the same reason the kernel
  -- needs it.
  -- Fold the live trace file into the tracked corpus, deduped by claim, and
  -- truncate the live file.  Run this between runs, not during one.
  when (args == ["--harvest-traces"]) $ do
    let tracked = "machine/replay.traces"
        readUtf8 p = do
          ex <- doesFileExist p
          if not ex then pure "" else do
            h <- openFile p ReadMode
            hSetEncoding h utf8
            s <- hGetContents h
            length s `seq` pure s
    old <- readUtf8 tracked
    new <- readUtf8 liveTraceFile
    let recs s = go (lines s)
          where
            go [] = []
            go (l : ls)
              | "-- TRACE " `isPrefixOf` l =
                  let (b, after) = break (== "-- END TRACE") ls
                  in (drop (length "-- TRACE ") l, l : b ++ ["-- END TRACE"])
                     : go (drop 1 after)
              | otherwise = go ls
        oldR = recs old
        newR = recs new
        keys = map fst oldR
        added = [ r | r <- newR, fst r `notElem` keys ]
    h <- openFile tracked AppendMode
    hSetEncoding h utf8
    mapM_ (mapM_ (hPutStrLn h) . snd) added
    hClose h
    writeFile liveTraceFile ""
    hPrintf stdout "  harvested %d new records (%d live, %d already tracked); corpus now %d\n"
      (length added) (length newR) (length oldR) (length oldR + length added)
    exitSuccess

  when (args == ["--residual-worth"]) $ do
    let m0 = start { mVocab = length vocabulary }
        rules = usableRules m0
        syms = take (mVocab m0) vocabulary
        population = take 400 (genTermsModulo [] [] (arities syms) 3 4)
        x = V 0 ; y = V 1
        z0 = F "0" [] ; suc t = F "s" [t]
        bin f a b = F f [a,b]
        goals =
          [ ("x = x + 0",   (x, bin "+" x z0))
          , ("0 = x * 0",   (z0, bin "*" x z0))
          , ("0 = y * 0",   (z0, bin "*" y z0))
          , ("x = 0 max x", (x, bin "max" z0 x))
          , ("x = 1 * x",   (x, bin "*" (suc z0) x))
          , ("0 = x - x",   (z0, bin "-" x x))
          ]
    hPrintf stdout "  population %d terms, %d rules\n"
      (length population) (length rules)
    hPrintf stdout "  %-14s %-9s %-9s %s\n" "goal" "proved" "collapses" "verdict"
    forM_ goals $ \(name, g) -> do
      let pr = case proveByInduction rules g of
                 Just _  -> "yes"
                 Nothing -> "no"
          n = exactPrune rules population g
      hPrintf stdout "  %-14s %-9s %-9d %s\n" name pr n
        (if n <= 0 then "PROVED-BUT-INERT: never reaches the kernel" else "installed")
    exitSuccess

  when (args == ["--convention-cost"]) $ do
    h <- openFile "machine/machine.log" ReadMode
    hSetEncoding h utf8
    ls <- fmap lines (hGetContents h)
    let rejects = [ l | l <- ls, "KERNEL-REJECT" `isInfixOf` l ]
        demanded = map fst (OB.curriculum rejects)
        goals = [ (fromOb a, fromOb b) | (a, b) <- demanded ]
        -- THE FULL VOCABULARY.  A first version of this probe used `start`,
        -- whose mVocab is 3, so `*`, `max` and `-` had no defining rules at
        -- all and every goal mentioning them counted as "missing mathematics".
        -- The number that produced was wrong and nearly got published.
        m0 = start { mVocab = length vocabulary }
        theirs = usableRules m0
        -- the mirrored clause order: Agda's, for + and *
        mirrored =
          [ (F "+" [F "0" [], V 0], V 0)
          , (F "+" [F "s" [V 0], V 1], F "s" [F "+" [V 0, V 1]])

          , (F "*" [F "0" [], V 0], F "0" [])
          , (F "*" [F "s" [V 0], V 1], F "+" [V 1, F "*" [V 0, V 1]]) ]
          ++ [ r | r@(l, _) <- theirs, headSym l `notElem` ["+", "*"] ]
        headSym (F f _) = f
        headSym _ = ""
        defT = length [ () | g <- goals, provedByRewriting theirs g ]
        defM = length [ () | g <- goals, provedByRewriting mirrored g ]
        onlyT = [ g | g <- goals, provedByRewriting theirs g
                    , not (provedByRewriting mirrored g) ]
        onlyM = [ g | g <- goals, provedByRewriting mirrored g
                    , not (provedByRewriting theirs g) ]
        neither = [ g | g <- goals, not (provedByRewriting theirs g)
                      , not (provedByRewriting mirrored g) ]
    hPrintf stdout "  distinct lemmas the kernel's refusals demand: %d\n"
      (length goals)
    hPrintf stdout "  definitional under the MACHINE's clause order:  %d\n" defT
    hPrintf stdout "  definitional under AGDA's clause order:        %d\n" defM
    hPrintf stdout "  definitional under machine ONLY (pure artefact of the split): %d\n"
      (length onlyT)
    hPrintf stdout "  definitional under agda ONLY:                  %d\n"
      (length onlyM)
    hPrintf stdout "  genuine missing mathematics on both readings:  %d\n"
      (length neither)
    putStrLn "  -- machine-only, the first eight --"
    forM_ (take 8 onlyT) $ \(l, r) ->
      hPrintf stdout "     %s = %s\n" (showTermP l) (showTermP r)
    putStrLn "  -- neither, the first eight: this is the real curriculum --"
    forM_ (take 8 neither) $ \(l, r) ->
      hPrintf stdout "     %s = %s\n" (showTermP l) (showTermP r)
    exitSuccess

  -- THE SEVENFOLD VERDICT, CHECKED HERE AND PROVED IN AGDA.
  --
  -- Exhaustive over the seven positions (343 triples for associativity), so
  -- this is a finite exhaustive verification and not a measurement.  Each
  -- law is also a checked term in
  -- formal/cubical/SaptabhangiSamyoga_TheCompositionOfVerdicts.agda, and the
  -- two must agree: if they ever disagree, one of them is wrong and the
  -- disagreement is the result.
  when (args == ["--saptabhangi-self-test"]) $ do
    let laws = SB.selfTest
        failed = [ nm | (nm, ok) <- laws, not ok ]
    forM_ laws $ \(nm, ok) ->
      hPrintf stdout "%s  %s\n" (if ok then "ok  " else "FAIL") nm
    -- the live seam, on the four situations the census found, using the
    -- SAME functions the round uses
    let mk = SB.vacanaOfRejection "refl"
        unparsedV  = mk "kernel gate environment fault: no module emitted"
        stalledV   = mk "cached: x != max x x of type \8469 when checking \
                        \that the expression refl has type x \8801 max x x"
        refutedV   = mk "cached: x \183 max x 1 != suc x of type \8469 when \
                        \checking that the expression refl has type \
                        \x \183 max x 1 \8801 suc x"
        adharminV  = mk "cached: x != y of type \8469 when checking that the \
                        \expression refl has type x \8801 y"
        krama'     = SB.sakshin ["x = (xmaxx)"] "x = (xmaxx)" stalledV
        positions  = map (SB.sanskritOf . SB.sthana)
                       [stalledV, refutedV, unparsedV, adharminV, krama']
        expected   = [ "syan-nasti", "syan-nasti", "syad-avaktavyam"
                     , "apratipatti", "syad-asti-nasti" ]
    forM_ (zip positions expected) $ \(got, want) ->
      hPrintf stdout "%s  live: %s\n" (if got == want then "ok  " else "FAIL") got
    unless (null failed && positions == expected) exitFailure
    hPrintf stdout
      "SAPTABHANGI CHECKED: laws=%d positions=%d distinct-live-situations=%d \
      \(one Bool was carrying all of them)\n"
      (length laws) (7 :: Int) (length (ordNub positions))
    exitSuccess
  when (args == ["--obstruction-self-test"]) $ do
    parserOk <- OB.selfTest
    let goalOneTimesX = (x_, bin "*" (su zero_) x_)
        rejectOneTimesX =
          "cached: x != x + 0 \183 x of type \8469 when checking that the \
          \expression refl has type x \8801 1 \183 x"
        goalMaxXX = (x_, bin "max" x_ x_)
        rejectMaxXX =
          "cached: x != max x x of type \8469 when checking that the \
          \expression refl has type x \8801 max x x"
        -- a residual of a FALSE parent, verbatim from the log: the parent
        -- `x·max(x,1) = s(x)` is false and so is the residual, and 126 of the
        -- log's occurrences are this one.  It must not reach the queue.
        goalFalse = (bin "*" x_ (bin "max" x_ (su zero_)), su x_)
        rejectFalse =
          "cached: x \183 max x 1 != suc x of type \8469 when checking that \
          \the expression refl has type x \183 max x 1 \8801 suc x"
        outcomes =
          [ ((goalOneTimesX, "[induction on x]")
            , KernelOutcome False
                (Just (OB.classify (toOb (fst goalOneTimesX)
                                   , toOb (snd goalOneTimesX)) rejectOneTimesX))
                (Just (nayaAttempted "[induction on x]")) 0 SB.noVacana)
          , ((goalMaxXX, "[induction on x]")
            , KernelOutcome False
                (Just (OB.classify (toOb (fst goalMaxXX), toOb (snd goalMaxXX))
                                   rejectMaxXX))
                (Just (nayaAttempted "[induction on x]")) 0 SB.noVacana)
          , ((goalFalse, "[induction on x]")
            , KernelOutcome False
                (Just (OB.classify (toOb (fst goalFalse), toOb (snd goalFalse))
                                   rejectFalse))
                (Just (nayaAttempted "[induction on x]")) 0 SB.noVacana)
          ]
        harvested = harvestResiduals outcomes
        -- the reproductive case: `x = 1·x` stalls at `x = x + 0·x`, which is
        -- a different and more primitive statement
        wantSub = orientLikeRound (x_, bin "+" x_ (bin "*" zero_ x_))
        -- `x = max x x` stalls at itself, so it yields no conjecture: the
        -- tactic has to escalate, the vocabulary does not have to grow
        harvestOk = map fst harvested == [wantSub]
        parentOk = map snd harvested == [goalOneTimesX]
        -- THE FILTER IS OBSTRUCTION'S, NOT THIS FILE'S.  `worthQueueing` is
        -- the specification; this checks that the harvest agrees with it on
        -- the same refusals, so the parent-tracking wrapper cannot drift away
        -- from the triage that was measured over the whole log.
        spec = OB.worthQueueing [ ob | (_, ko) <- outcomes
                                     , Just ob <- [koObstruction ko] ]
        specOk = S.fromList (map (\(a,b) -> (toOb a, toOb b)) (map fst harvested))
                   == S.fromList spec
        junkOk = not (usefulResidual (V 0, V 1))
                   && not (usefulResidual (x_, x_))
                   && not (usefulResidual (bin "*" x_ x_, su x_))
                   && usefulResidual wantSub
        -- both spellings of the same lemma collapse to one queue entry
        orientOk = orientLikeRound (x_, bin "+" x_ zero_)
                     == orientLikeRound (bin "+" x_ zero_, x_)
        -- आरोहण, checked on the shape of a real vallī rather than asserted.
        -- goalG stalls at subR; subR is itself refused and stalls at subR'.
        -- Proving subR' must summon subR AND goalG -- the seed reaching the
        -- top is the whole content of the back-substitution.
        goalG  = (x_, bin "*" (su zero_) x_)
        subR   = (x_, bin "+" x_ (bin "*" zero_ x_))
        subR'  = (bin "*" zero_ x_, zero_)
        valli  = M.fromList [ (subR, [goalG]), (subR', [subR]) ]
        climbOne   = arohana valli [subR]  == [goalG]
        climbChain = arohana valli [subR'] == [subR, goalG]
        -- a vallī with a loop must terminate rather than climb forever
        loopValli  = M.fromList [ (subR, [goalG]), (goalG, [subR]) ]
        climbLoop  = arohana loopValli [subR] == [goalG]
        -- and with nothing newly proved the climb summons nothing, which is
        -- what makes this seam inert on every round that proves no subgoal
        climbQuiet = null (arohana valli [])
        arohanaOk = climbOne && climbChain && climbLoop && climbQuiet
    hPrintf stdout "  parser (Obstruction.selfTest)       %s\n" (show parserOk)
    hPrintf stdout "  residual harvested as a conjecture  %s  %s\n"
      (show harvestOk) (show (map fst harvested))
    hPrintf stdout "  parent recorded for the residual    %s\n" (show parentOk)
    hPrintf stdout "  agrees with OB.worthQueueing        %s\n" (show specOk)
    hPrintf stdout "  refuted and degenerate dropped      %s\n" (show junkOk)
    hPrintf stdout "  both orientations collapse to one   %s\n" (show orientOk)
    hPrintf stdout "  mFailed suppresses a requeue        %s\n"
      (show residualFailedContract)
    hPrintf stdout "  arohana climbs the valli to the top %s\n" (show arohanaOk)
    if parserOk && harvestOk && parentOk && specOk && junkOk && orientOk
         && residualFailedContract && arohanaOk
      then putStrLn "OBSTRUCTION WIRE CHECKED" >> exitSuccess
      else hPutStrLn stderr "--obstruction-self-test: FAILED" >> exitFailure
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
  -- THE CALLER'S HALF OF THE GATE'S CONTRACT, tested where it lives.
  --
  -- `Certificate.certifyWith` certifies relative to the definitions it is
  -- HANDED: give it `c0 = id` and `c0(x) = x` and it is right to certify,
  -- because that equation is true of that definition, and it has no second
  -- source of truth for `c0`.  `machine/GateAudit.hs` section B submitted
  -- exactly that and counted the certificate as an unsoundness; it is not
  -- one, and the case has been reclassified with the argument recorded in
  -- machine/GATE_AUDIT_DISPOSITION.md §4.
  --
  -- But reclassifying it removed a check without adding one, and the audit
  -- cannot add it back: it imports `Certificate` and cannot reach here,
  -- because `MathMachine` is `module Main`.  So the check is here, against
  -- the three conditions `certDefinitions` imposes, each with a concept
  -- built to violate exactly one of them:
  --
  --   honest    -- rule (x+x -> c0(x)), semantics x+x.  Must be emitted.
  --   mismatch  -- rule (x -> c0(x)) while the semantics are x+x.  This is
  --                the audit's own case, and the grid catches it at x=1.
  --   unfolded  -- a rule that does not fold to c0 applied to its own
  --                parameters, so it is some incidental rewrite and not a
  --                defining clause.
  --   outofrange-- a body over V 1 at arity 1, breaking the contract
  --                `Certificate.render` relies on.
  --
  -- Each of the last three must contribute NO Definition, which is what
  -- makes every candidate mentioning it Untranslatable -- the one outcome
  -- that cannot be mistaken for a proof.
  when (args == ["--concept-emitter-self-test"]) $ do
    let base = take 3 vocabulary          -- 0, s, + : enough to evaluate x+x
        sem = semantics base
        double = bin "+" x_ x_
        conceptWith body fold =
          akanksitaSym "c0" 1 (\as -> eval sem as double) [(body, fold)]
        honest    = conceptWith double (F "c0" [x_])
        mismatch  = conceptWith x_ (F "c0" [x_])
        unfolded  = conceptWith double (bin "+" (F "c0" [x_]) x_)
        outOfRange = conceptWith (bin "+" y_ y_) (F "c0" [x_])
        emitted s = map C.defName (certDefinitions (base ++ [s]))
        -- WHICH CONDITION DOES THE WORK.  Three withholdings prove nothing
        -- if one condition is doing all of them: a test that cannot say
        -- what rejected a case cannot notice when the interesting line is
        -- deleted.  `mismatch` is the audit's own case, and it passes both
        -- STRUCTURAL conditions -- its rule folds to c0 applied to its own
        -- parameter, its body's variables are exactly V 0 -- so the only
        -- thing that can reject it is the exact grid comparison, which
        -- catches it at x = 1 (body says 1, semantics say 2).  Asserting
        -- that here is what makes the grid line load-bearing rather than
        -- decorative.
        mismatchIsStructurallyFine =
          case conceptRule mismatch of
            Just (body, fold) ->
              fold == F "c0" [V 0]
                && ordNub (sort (vars body)) == [0]
                && isJust (ruleCounterexample (vocabulary ++ base ++ [mismatch])
                             definitionAuditBound (body, fold))
            Nothing -> False
    unless (emitted honest == ["c0"]
            && emitted mismatch == []
            && emitted unfolded == []
            && emitted outOfRange == []
            && mismatchIsStructurallyFine) exitFailure
    putStrLn ("CONCEPT EMITTER CHECKED: honest=emitted "
              ++ "mismatch=withheld-by-the-grid-alone unfolded=withheld "
              ++ "out-of-range=withheld "
              ++ "(the gate proves what it is handed; this is what hands it)")
    exitSuccess
  -- PRAMANA, checked in-process.  `Pramana.selfTest` is pure, so this is the
  -- caller that makes it run at all -- four files in this directory are
  -- self-tests nothing invokes, and that is the failure mode being avoided.
  -- The last two assertions are this file's own wire, not Pramana's: the
  -- memory format must round-trip through THIS module's term printer and
  -- parser, and `nayaAttempted` must agree with `Certificate`'s reading of
  -- the note, since the second is what the gate actually consults.
  when (args == ["--pramana-self-test"]) $ do
    let sample = P.Justification
          { P.jPramana     = P.Anumana (P.NInduction 'x' (Just "cong suc"))
          , P.jNaya        = P.NInduction 'x' (Just "cong suc")
          , P.jAvacchedaka = P.Avacchedaka "_\8801_ on \8469"
                               (map symName (take baseVocabCap vocabulary)) 3 7
          , P.jProvenance  = P.Provenance 4 1
          }
        eq = (su x_, bin "max" x_ (su x_))
        line = P.renderRecord showTermP
                 (P.MemoryRecord (fst eq) (snd eq) (Just sample))
        wireOk = case parseMemory (line ++ "\n") of
          [rec] -> memoryEquation rec == eq
                     && fmap P.jNaya (P.mrJust rec) == Just (P.jNaya sample)
                     && fmap (P.avVocabulary . P.jAvacchedaka) (P.mrJust rec)
                          == Just (map symName (take baseVocabCap vocabulary))
          _ -> False
        -- the legacy shape, verbatim from the committed memory file
        legacyOk = case parseMemory "s(x)\tmax(x,s(x))\n" of
          [rec] -> memoryEquation rec == eq && P.mrJust rec == Nothing
          _ -> False
        -- the property the gate depends on, checked against the gate's own
        -- reader rather than against a copy of it
        gateOk = C.inductionVariable (P.nayaNote (P.jNaya sample)) == Just 0
                   && C.inductionVariable (P.nayaNote P.NRefl) == Nothing
                   && nayaAttempted "induction on y" == P.NInduction 'y' Nothing
                   && nayaAttempted "remembered" == P.NRefl
        -- the shape strings `Certificate` actually returns, cache marker and
        -- all, must not classify as NOther
        shapeOk = map nayaOfShape
                    [ "refl", "cached, refl"
                    , "induction on x, step = ih"
                    , "cached, induction on x, step = cong suc" ]
                  == [ P.NRefl, P.NRefl
                     , P.NInduction 'x' (Just "ih")
                     , P.NInduction 'x' (Just "cong suc") ]
    forM_ P.selfTest (hPutStrLn stderr)
    unless (null P.selfTest && wireOk && legacyOk && gateOk && shapeOk) $ do
      unless wireOk   (hPutStrLn stderr "pramana wire: memory record did not round-trip")
      unless legacyOk (hPutStrLn stderr "pramana wire: legacy two-field line did not parse")
      unless gateOk   (hPutStrLn stderr "pramana wire: note is unreadable to Certificate")
      unless shapeOk  (hPutStrLn stderr "pramana wire: certificate shapes misclassified")
      exitFailure
    putStrLn ("PRAMANA CHECKED: Pramana.selfTest failures=0, wire checks=4 "
              ++ "(memory record round-trips through this file's own printer "
              ++ "and parser; legacy two-field lines still parse; every "
              ++ "recorded naya is readable by Certificate.inductionVariable; "
              ++ "certificate shapes classify)")
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
      let thoughtsFile = maybe "machine/thoughts.math" id (dThoughts disp)
      exists <- doesFileExist thoughtsFile
      batch <- if exists then parseThoughts <$> readFile thoughtsFile
                         else pure (ThoughtBatch [] [])
      runMachine disp batch

-- RE-ADMISSION.  Memory stores the equation and not the proof, and that
-- one missing field was costing the machine almost all of its memory.
--
-- MEASURED, 2026-08-17, on the 59-line machine/library.terms of commit
-- ffe6c00: `remembered=59 re-admitted=4 dropped=55`.  The four survivors
-- are exactly the four agda closes with `refl` (x = 0+x, 0 = 0*x,
-- s(x) = s(0)+x, s(x)+y = s(x+y)).  The cause is in the gate, not in the
-- mathematics: `kernelAccept` submitted every remembered equation with the
-- proof note "remembered", and `Certificate.certifyWith` reads its
-- induction variable OUT OF THAT NOTE (`inductionVariable`).  Finding
-- none, it returns `Rejected` the instant the refl module fails, so not
-- one step shape was ever emitted for a remembered theorem; `tryReplay`
-- refuses at the same field one call earlier.  The evidence is a single
-- screen of machine.log: `0 = -(x,x)` is rejected at load with "checking
-- that the expression refl has type", and accepted seventy lines later,
-- in the same process, with "induction on x, step = ih" -- because the
-- round's prover supplied the note the file could not carry.
--
-- The repair reconstructs the field rather than storing it: the engine's
-- own `proveByInduction` is run against the rules admitted so far, and its
-- note -- the same string the round writes -- is what the gate is given.
-- That makes ORDER load-bearing, so this is a fold and not a filter.
-- Smallest first (the order `freshSized` uses, for the same reason), each
-- acceptance folded into the rule set before the next candidate is
-- proposed, and the drops retried on a further pass until a pass admits
-- nothing new.  A theorem whose proof needs an earlier lemma therefore
-- gets its lemma, and `known` reaches the trace replayer as citations.
-- Both halves are load-bearing and both were measured: with the note
-- alone the fold takes 35 of 37 on pass 1, and the two it leaves --
-- x+y = y+x and x+x = 2*x -- are admitted on pass 2, once the lemmas
-- they cite are installed.
--
-- The invariant is untouched.  Every equation returned here was accepted
-- by the same `kernelAcceptWith` the round uses, in this process.  The
-- note only chooses WHICH module agda is asked to check, never whether it
-- is asked, and a remembered theorem that no longer certifies is still
-- dropped.
-- THE SYMBOL LIST HAS TO BE THE SAME ONE THE ROUND USES.  Re-admission passed
-- `[]` where a round passes `kernelSyms m`, so a remembered theorem naming a
-- symbol past the base vocabulary was Untranslatable at load however it had
-- been proved.  Measured on the committed 63-line memory: remembered=63
-- distinct=41 re-admitted=40 dropped=1 -- the dropped one being the pair
-- theorem the previous run had just certified, which round 0 then proved and
-- appended all over again.  A memory that cannot hold what the loop puts in it
-- is not a memory; the caller now passes the startup vocabulary's tail.
-- ŚABDA, 2026-08-18.  The paragraphs above describe a reconstruction: run
-- `proveByInduction` at load and hand the gate whatever note it produces.
-- That reconstruction is a re-derivation, and it succeeds only when the rule
-- set and vocabulary at LOAD reproduce the ones at PROOF.  When they do not,
-- there is no note, and no note is `refl`, and `refl` refuses.
--
-- MEASURED, 2026-08-18, on the committed 92-line memory (37 distinct), with
-- no `machine/thoughts.math` present so `requiredVocabulary` gives the
-- default 3 rather than the 8 that unrelated prose file happens to demand:
--
--     re-admitted=6  dropped=31
--
-- Every one of the thirty-one had been proved by this engine under induction
-- and appended by this engine's own round.  The file simply did not carry the
-- field, so the machine asked itself the wrong question thirty-one times and
-- believed the answer.
--
-- The repair is Nyāya's, and it is one line: a theorem the machine itself
-- kernel-checked and wrote down is testimony from an āpta (*Nyāyasūtra*
-- 1.1.7, āptopadeśaḥ śabdaḥ), and what that testimony conveys is the NAYA.
-- `recordedNaya` below prefers the recorded note over the reconstruction;
-- reconstruction survives as the fallback for legacy two-field lines and for
-- a record whose note is `NOther ""` (i.e. no naya was recorded at all).
--
-- The gate is untouched.  `kernelAcceptWith` is the same call with the same
-- arguments; only the note differs, and the note chooses which module agda
-- checks, never whether agda is asked.  A remembered theorem that no longer
-- certifies is still dropped, and the counters below are what says so.
data Readmission = Readmission
  { rmAdmitted   :: [(Term,Term)]
  , rmPasses     :: Int
  , rmBySabda    :: Int   -- ^ admitted on a RECORDED naya
  , rmByRederive :: Int   -- ^ admitted on a note reconstructed at load
  , rmHeard      :: Int   -- ^ records that carried a usable naya at all
  }

readmitMemory :: Handle -> [Sym] -> [Rule] -> [P.MemoryRecord Term]
              -> IO Readmission
readmitMemory logh extraSyms baseRules remembered = go 1 [] baseRules ordered 0 0
  where
    ordered = sortOn (\rec -> let (l,r) = memoryEquation rec
                              in (size l + size r, l, r)) remembered
    heard = length [ () | rec <- remembered, isJust (recordedNaya rec) ]

    -- The testimony, if any: a recorded naya whose note the gate can act on.
    -- `NOther ""` is what an absent `naya=` field parses to, and it is not
    -- testimony -- it is a record that says nothing.  Rejecting it here is
    -- what keeps the fallback honest.
    recordedNaya :: P.MemoryRecord Term -> Maybe String
    recordedNaya rec = do
      j <- P.mrJust rec
      case P.jPramana j of
        P.Sabda src | P.aptatva src -> pure ()
        _                           -> Nothing
      let note = P.nayaNote (P.jNaya j)
      if null (dropWhile isSpace note) then Nothing else Just note

    go :: Int -> [(Term,Term)] -> [Rule] -> [P.MemoryRecord Term]
       -> Int -> Int -> IO Readmission
    go pass admitted rules pending nSabda nRederive = do
      (admitted', rules', dropped, nS, nR) <-
        foldM step (admitted, rules, [], nSabda, nRederive) pending
      let gained = length admitted' - length admitted
      if gained == 0 || null dropped
        then pure (Readmission admitted' pass nS nR heard)
        else go (pass + 1) admitted' rules' (reverse dropped) nS nR
    step (admitted, rules, dropped, nS, nR) rec = do
      let c = memoryEquation rec
          spoken = recordedNaya rec
          note = case spoken of
            Just n  -> n
            Nothing -> maybe "remembered" id (proveByInduction rules c)
      ok <- koAccepted <$> kernelAcceptWith extraSyms admitted rules logh 0 (c, note)
      pure $ if ok
               then ( admitted ++ [c]
                    , rules ++ maybe (lemmaRules [c]) (:[]) (orient c)
                    , dropped
                    , if isJust spoken then nS + 1 else nS
                    , if isJust spoken then nR else nR + 1 )
               else (admitted, rules, rec : dropped, nS, nR)

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
  -- The file is an append log, so it repeats: 59 lines were 37 distinct
  -- equations.  Deduplicating before the gate is not a relaxation -- the
  -- agda cache already served the repeats at zero calls -- it just stops
  -- the count from reporting the same theorem as several memories.
  let distinct = dedupeMemory remembered
  -- The rule set the re-admission fold starts from must be the one a round
  -- starts from -- `usableRules` on a fresh machine, which is exactly the
  -- defining equations of the visible vocabulary.  Starting it at [] leaves
  -- `proveByInduction` unable to reduce even `x + 0`, so it finds no
  -- induction variable, so the note is empty and the gate is back to refl.
  -- That is the same defect one level up, and it cost a measurement to see:
  -- with rules = [] the fold still re-admitted only the four refl theorems.
      startVocab = maybe (min (dVocabCap disp) (requiredVocabulary batch))
                         (\v -> max 1 (min v (dVocabCap disp)))
                         (dVocabStart disp)
      baseRules = definitionsOf (take startVocab vocabulary)
  rm <- readmitMemory logh
          (drop baseVocabCap (take startVocab vocabulary))
          baseRules distinct
  let admitted = rmAdmitted rm
  hPrintf logh "  MEMORY  remembered=%d distinct=%d re-admitted=%d dropped=%d passes=%d\n"
    (length remembered) (length distinct) (length admitted)
    (length distinct - length admitted) (rmPasses rm)
  -- SABDA, counted rather than claimed.  `heard` is how many memory records
  -- carried a naya at all -- a two-field legacy line carries none, so this is
  -- also the migration meter.  `on-sabda` is how many of the re-admissions
  -- were made on that recorded naya, `on-rederived` how many fell back to
  -- reconstructing the note at load, which is what the whole file did before
  -- 2026-08-18.  If `on-sabda` is 0 while `heard` is large, the testimony is
  -- being read and ignored and this line is what would say so.
  hPrintf logh "  SABDA  heard=%d on-sabda=%d on-rederived=%d unattributed=%d\n"
    (rmHeard rm) (rmBySabda rm) (rmByRederive rm)
    (length distinct - rmHeard rm)
  hPrintf logh "  DISPATCH  %s\n" (show disp)
  -- The residual feedback's safety condition, checked rather than asserted:
  -- `mFailed` keyed on the rule count is what stops a requeued residual from
  -- cycling, and this is that predicate evaluated on a residual-shaped
  -- witness.  A later edit to the freshness filter breaks the line, not a run.
  hPrintf logh "  OBSTRUCTION-CONTRACT  mfailed-suppresses-requeue=%s queue-cap=%d\n"
    (show residualFailedContract) kResidualQueueCap
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
                     , mVocab = startVocab
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
