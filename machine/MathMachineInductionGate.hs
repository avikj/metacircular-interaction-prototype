{-# LANGUAGE LambdaCase #-}

-- Run from the repository root:
--   runghc machine/MathMachineInductionGate.hs
--
-- ===================================================================
-- STATUS, 2026-08-17: THIS RUNS, AND IT IS NOT WIRED TO THE PROVER.
-- The second half of that sentence is a measurement, not an oversight,
-- and it is written here so the next reader does not spend the day
-- discovering it again.
--
-- IT HAD NEVER RUN.  From commit f05c79fc ("Search for checked
-- induction certificates") until today this file did not compile:
-- `boundedSearch` calls `foldl'` and nothing imported it.  Three more
-- defects sat behind that one, each of which would have stopped it on
-- its first execution, and each of which is already fixed WITH A
-- COMMENT in machine/Certificate.hs, the kernel the live engine uses:
-- no `setLocaleEncoding utf8`, so it could not write its own Agda
-- module; no `--library=cubical`, so agda could not resolve
-- Cubical.Foundations.Prelude from the temp directory; no forced child
-- locale, so agda died encoding its own error message.  All four are
-- fixed and the file now reports, in ~3 seconds:
--
--   SEARCH-FOUND associativity baseSteps=2 stepSteps=4
--   KERNEL-ACCEPT associativity
--   KERNEL-REJECT mutated-hypothesis-transport   (endpoint mismatch)
--
-- So the advertised claim is TRUE: the breadth-first search does find
-- an induction certificate for `y+(z+x) = (y+z)+x`, agda accepts it,
-- and agda rejects the certificate with the `hyp-suc` transport
-- deleted.  Today is the first time that was ever checked.
--
-- WHY IT IS STILL NOT WIRED INTO `MathMachine.attempt`.  The search
-- speaks a three-constructor term language -- Zero, Suc, Add -- over
-- three variables, and `stepTransitions` knows exactly two equations,
-- add-zero and add-suc.  The machine's open conjectures do not live
-- there.  MEASURED by instrumenting the `Nothing` branch of the
-- prover's `attempt` and running the machine from a fixed
-- 37-equation memory:
--
--   --rounds 4 (horizons 4-5):    69 distinct unproved conjectures,
--                                  0 expressible in {0,s,+}
--   --rounds 8 (horizons 4-6):  4275 distinct unproved conjectures,
--                                  0 expressible in {0,s,+}
--
--   708 of those 4275 mention `+`.  All 708 also mention a symbol this
--   file has no constructor for.
--
-- And `+`-associativity -- the advertised target -- is never among
-- them, at any horizon measured: the engine installs commutativity as
-- a lemma rule early, and the two sides stop being distinct normal
-- forms, so the conjecture is never stated.  The search closes a
-- question the machine does not ask.
--
-- What the machine DOES ask, and fails, is the same shape one operator
-- over: `((x*y)*z) = (x*(y*z))`, `((x max y) max z) = (x max (y max z))`,
-- `((x+y)*z) = ((x*z)+(y*z))`.  The useful work is therefore to widen
-- `Term`/`stepTransitions`/`RewriteCertificate` to `*` and `max`, not
-- to call this search from the prover -- wired as it stands it is a
-- branch that provably never fires, and a prover branch that never
-- fires is a claim about the program that is not true.
-- ===================================================================
module Main (main) where

import qualified Certificate as C
import Control.Exception (finally)
import Control.Monad (unless)
import Data.Char (isSpace)
-- 2026-08-17.  This import was missing, and had been since commit f05c79fc
-- ("Search for checked induction certificates") introduced `boundedSearch`.
-- `ghc -fno-code machine/MathMachineInductionGate.hs` has therefore failed
-- with "Variable not in scope: foldl'" on every commit since, which means
-- the breadth-first derivation search in this file has never once run, and
-- the +-associativity certificate it is written to find has never been
-- searched for, let alone accepted by Agda.  machine/check-haskell-agda.sh
-- builds this file with -Werror and then runs it, so that script has been
-- failing at its second `ghc` invocation for the same three days.
import Data.List (foldl')
import qualified Data.Map.Strict as Map
import qualified Data.Sequence as Sequence
import qualified Data.Set as Set
import System.Directory
  ( createDirectoryIfMissing
  , doesFileExist
  , getCurrentDirectory
  , getTemporaryDirectory
  , removePathForcibly
  )
import System.Exit (ExitCode (..), exitFailure)
import System.FilePath ((</>))
-- The second reason this file had never run.  `renderModule` writes `_≡_`
-- (U+2261) into the generated Agda module, and `writeFile` uses the locale
-- encoding, which in this container is ASCII: "withFile: invalid argument
-- (cannot encode character '\8801')".  machine/AgdaRewriteGate.hs -- the
-- sibling that DOES run, and whose result message claimed this lane was
-- verified -- calls `setLocaleEncoding utf8` as its first action, and this
-- file does not.  It is the same one-line omission twice over.
import GHC.IO.Encoding (setLocaleEncoding, utf8)
import System.Environment (getEnvironment)
import System.IO (IOMode (WriteMode), hPutStr, hSetEncoding, withFile)
import System.Process
  ( CreateProcess (env)
  , proc
  , readCreateProcessWithExitCode
  , readProcess
  )

data Term
  = Var
  | YVar
  | ZVar
  | Zero
  | Suc Term
  | Add Term Term
  deriving (Eq, Ord, Show)

data StepCertificate
  = AddZero Term
  | AddSuc Term Term
  | SucStep StepCertificate
  | AddLeft StepCertificate Term
  | AddRight Term StepCertificate
  | Reverse StepCertificate
  deriving (Eq, Show)

data Derivation
  = Done Term
  | ThenStep StepCertificate Derivation
  deriving (Eq, Show)

data HypStepCertificate
  = LiftStep StepCertificate
  | Hypothesis
  | ReverseHypothesis
  | HypSuc HypStepCertificate
  | HypAddLeft HypStepCertificate Term
  | HypAddRight Term HypStepCertificate
  deriving (Eq, Show)

data HypDerivation
  = HypDone Term
  | HypThen HypStepCertificate HypDerivation
  deriving (Eq, Show)

-- The endpoints are part of the certificate object. Agda, rather than this
-- Haskell datatype, checks that both indexed traces have exactly those ends.
data InductionCertificate = InductionCertificate
  { certificateLhs :: Term
  , certificateRhs :: Term
  , baseDerivation :: Derivation
  , stepDerivation :: HypDerivation
  } deriving (Eq, Show)

renderTerm :: Term -> String
renderTerm = \case
  Var -> "var"
  YVar -> "yvar"
  ZVar -> "zvar"
  Zero -> "zero"
  Suc term -> "(suc " ++ renderTerm term ++ ")"
  Add left right -> "(add " ++ renderTerm left ++ " " ++ renderTerm right ++ ")"

renderStep :: StepCertificate -> String
renderStep = \case
  AddZero term -> "(add-zero " ++ renderTerm term ++ ")"
  AddSuc left right -> "(add-suc " ++ renderTerm left ++ " " ++ renderTerm right ++ ")"
  SucStep step -> "(suc-step " ++ renderStep step ++ ")"
  AddLeft step term -> "(add-left " ++ renderStep step ++ " " ++ renderTerm term ++ ")"
  AddRight term step -> "(add-right " ++ renderTerm term ++ " " ++ renderStep step ++ ")"
  Reverse step -> "(reverse " ++ renderStep step ++ ")"

renderDerivation :: Derivation -> String
renderDerivation = \case
  Done term -> "(done " ++ renderTerm term ++ ")"
  ThenStep step rest -> "(then-step " ++ renderStep step ++ " " ++ renderDerivation rest ++ ")"

renderHypStep :: HypStepCertificate -> String
renderHypStep = \case
  LiftStep step -> "(lift-step " ++ renderStep step ++ ")"
  Hypothesis -> "hypothesis"
  ReverseHypothesis -> "reverse-hypothesis"
  HypSuc step -> "(hyp-suc " ++ renderHypStep step ++ ")"
  HypAddLeft step term ->
    "(hyp-add-left " ++ renderHypStep step ++ " " ++ renderTerm term ++ ")"
  HypAddRight term step ->
    "(hyp-add-right " ++ renderTerm term ++ " " ++ renderHypStep step ++ ")"

renderHypDerivation :: HypDerivation -> String
renderHypDerivation = \case
  HypDone term -> "(hyp-done " ++ renderTerm term ++ ")"
  HypThen step rest -> "(hyp-then " ++ renderHypStep step ++ " " ++ renderHypDerivation rest ++ ")"

termSize :: Term -> Int
termSize Var = 1
termSize YVar = 1
termSize ZVar = 1
termSize Zero = 1
termSize (Suc term) = 1 + termSize term
termSize (Add left right) = 1 + termSize left + termSize right

substituteX :: Term -> Term -> Term
substituteX replacement Var = replacement
substituteX _ YVar = YVar
substituteX _ ZVar = ZVar
substituteX _ Zero = Zero
substituteX replacement (Suc term) = Suc (substituteX replacement term)
substituteX replacement (Add left right) =
  Add (substituteX replacement left) (substituteX replacement right)

-- One checked rewrite step, including every context and both directions.
-- Reverse add-zero increases size, so the bounded search below is the
-- termination argument rather than an unstated orientation heuristic.
stepTransitions :: Term -> [(Term, StepCertificate)]
stepTransitions term = topLevel ++ underContext
  where
  topLevel =
    case term of
      Add left Zero -> [(left, AddZero left), addZeroExpansion]
      Add left (Suc right) ->
        [(Suc (Add left right), AddSuc left right), addZeroExpansion]
      Suc (Add left right) ->
        [(Add left (Suc right), Reverse (AddSuc left right)), addZeroExpansion]
      _ -> [addZeroExpansion]
  addZeroExpansion = (Add term Zero, Reverse (AddZero term))
  underContext =
    case term of
      Suc child ->
        [ (Suc next, SucStep certificate)
        | (next, certificate) <- stepTransitions child
        ]
      Add left right ->
        [ (Add next right, AddLeft certificate right)
        | (next, certificate) <- stepTransitions left
        ]
        ++ [ (Add left next, AddRight left certificate)
           | (next, certificate) <- stepTransitions right
           ]
      _ -> []

hypothesisTransitions
  :: Term -> Term -> Term -> [(Term, HypStepCertificate)]
hypothesisTransitions hypothesisLeft hypothesisRight term =
  atRoot ++ underContext
  where
  atRoot
    | term == hypothesisLeft = [(hypothesisRight, Hypothesis)]
    | term == hypothesisRight = [(hypothesisLeft, ReverseHypothesis)]
    | otherwise = []
  underContext =
    case term of
      Suc child ->
        [ (Suc next, HypSuc certificate)
        | (next, certificate) <-
            hypothesisTransitions hypothesisLeft hypothesisRight child
        ]
      Add left right ->
        [ (Add next right, HypAddLeft certificate right)
        | (next, certificate) <-
            hypothesisTransitions hypothesisLeft hypothesisRight left
        ]
        ++ [ (Add left next, HypAddRight left certificate)
           | (next, certificate) <-
               hypothesisTransitions hypothesisLeft hypothesisRight right
           ]
      _ -> []

hypStepTransitions
  :: Term -> Term -> Term -> [(Term, HypStepCertificate)]
hypStepTransitions hypothesisLeft hypothesisRight term =
  [ (next, LiftStep certificate)
  | (next, certificate) <- stepTransitions term
  ]
  ++ hypothesisTransitions hypothesisLeft hypothesisRight term

-- Breadth-first search is bounded independently by path length, term size,
-- and visited-node budget. `seen` makes every admitted term enter once.
boundedSearch
  :: Int
  -> Int
  -> Int
  -> (Term -> [(Term, certificate)])
  -> Term
  -> Term
  -> Maybe [certificate]
boundedSearch maximumDepth maximumSize maximumNodes transitions source target =
  go maximumNodes (Set.singleton source) (Sequence.singleton (source, [], 0))
  where
  go remaining seen queue
    | remaining <= 0 = Nothing
    | otherwise =
        case Sequence.viewl queue of
          Sequence.EmptyL -> Nothing
          (current, reversePath, depth) Sequence.:< rest
            | current == target -> Just (reverse reversePath)
            | depth >= maximumDepth -> go (remaining - 1) seen rest
            | otherwise ->
                let candidates =
                      [ (next, certificate : reversePath, depth + 1)
                      | (next, certificate) <- transitions current
                      , termSize next <= maximumSize
                      ]
                    (nextSeen, nextQueue) =
                      foldl' enqueue (seen, rest) candidates
                in go (remaining - 1) nextSeen nextQueue
  enqueue (seen, queue) candidate@(term, _, _)
    | Set.member term seen = (seen, queue)
    | otherwise = (Set.insert term seen, queue Sequence.|> candidate)

stepsToDerivation :: Term -> [StepCertificate] -> Derivation
stepsToDerivation target = foldr ThenStep (Done target)

stepsToHypDerivation :: Term -> [HypStepCertificate] -> HypDerivation
stepsToHypDerivation target = foldr HypThen (HypDone target)

deriveInductionCertificate :: Term -> Term -> Maybe InductionCertificate
deriveInductionCertificate lhs rhs = do
  let baseLeft = substituteX Zero lhs
      baseRight = substituteX Zero rhs
      stepLeft = substituteX (Suc Var) lhs
      stepRight = substituteX (Suc Var) rhs
      largestEndpoint = maximum
        (map termSize [baseLeft, baseRight, stepLeft, stepRight])
      maximumDepth = 6
      maximumSize = largestEndpoint + 4
      maximumNodes = 20000
  baseSteps <- boundedSearch
    maximumDepth maximumSize maximumNodes stepTransitions baseLeft baseRight
  successorSteps <- boundedSearch
    maximumDepth maximumSize maximumNodes
    (hypStepTransitions lhs rhs) stepLeft stepRight
  pure (InductionCertificate
    lhs
    rhs
    (stepsToDerivation baseRight baseSteps)
    (stepsToHypDerivation stepRight successorSteps))

renderModule :: InductionCertificate -> String
renderModule certificate = unlines
  [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
  , "module InductionGate where"
  , "open import Cubical.Foundations.Prelude using (_≡_)"
  , "open import NaturalMachine.RewriteCertificate"
  , ""
  , "lhs : Tm"
  , "lhs = " ++ renderTerm (certificateLhs certificate)
  , ""
  , "rhs : Tm"
  , "rhs = " ++ renderTerm (certificateRhs certificate)
  , ""
  , "candidate : InductionCertificate lhs rhs"
  , "candidate = record"
  , "  { base = " ++ renderDerivation (baseDerivation certificate)
  , "  ; step = " ++ renderHypDerivation (stepDerivation certificate)
  , "  }"
  , ""
  , "candidate-sound : (rho : Env) -> eval lhs rho ≡ eval rhs rho"
  , "candidate-sound = induction-sound candidate"
  ]

trim :: String -> String
trim = reverse . dropWhile isSpace . reverse

-- The shared checkout can lag origin/main while other agents have visible
-- work. In that case the audit still targets the requested current API by
-- placing the exact origin/main module in the private include tree.
prepareRewriteCertificate :: FilePath -> FilePath -> IO ()
prepareRewriteCertificate repo private = do
  let relative = "formal/cubical/NaturalMachine/RewriteCertificate.agda"
      local = repo </> relative
  present <- doesFileExist local
  unless present $ do
    source <- readProcess "git" ["show", "origin/main:" ++ relative] ""
    let destinationDirectory = private </> "NaturalMachine"
    createDirectoryIfMissing True destinationDirectory
    writeFile (destinationDirectory </> "RewriteCertificate.agda") source

-- The other two reasons this file had never run, both of them already
-- solved -- with comments -- in machine/Certificate.hs, the kernel the live
-- engine actually uses.  This function was a third re-implementation that
-- had none of the fixes, because it had never been executed once.
--
--   (1) LIBRARY.  The generated module opens Cubical.Foundations.Prelude.
--       `formal/cubical/natural-machine.agda-lib` declares `depend: cubical`,
--       but -i include roots do not trigger .agda-lib resolution, so agda
--       searched ./Cubical, formal/cubical/Cubical and the temp dir, found
--       nothing, and failed to scope-check line 3.  Certificate.hs:37 names
--       this exact failure and fixes it with `--library=cubical`; so does
--       this, via `agdaLibrary`.
--   (2) CHILD LOCALE.  agda prints ≡ and λ in its own diagnostics through
--       the process locale encoding.  This container has LC_CTYPE=POSIX, so
--       agda died reporting the error rather than reporting it:
--       "Error when handling error: <stdout>: commitBuffer: invalid argument
--       (cannot encode character '\8801')".  Certificate.hs:703 forces
--       LC_ALL/LANG in the child's environment for the same reason.
--
-- The candidate file is also written through a handle with an explicit UTF-8
-- encoding rather than `writeFile`, which uses the ambient locale.
agdaLibrary :: String
agdaLibrary = "cubical"

validateWithAgda :: FilePath -> InductionCertificate -> IO (Bool, String)
validateWithAgda repo certificate = do
  temporaryRoot <- getTemporaryDirectory
  directoryLine <- readProcess
    "mktemp" ["-d", temporaryRoot </> "math-machine-induction.XXXXXX"] ""
  base <- getEnvironment
  let private = trim directoryLine
      gate = private </> "InductionGate.agda"
      includeRoots =
        ["-i", private, "-i", repo </> "formal/cubical"]
      arguments = includeRoots ++ ["--library=" ++ agdaLibrary, gate]
      environment =
        ("LC_ALL", "C.UTF-8")
          : ("LANG", "C.UTF-8")
          : [ entry | entry@(key, _) <- base, key /= "LC_ALL", key /= "LANG" ]
  (do prepareRewriteCertificate repo private
      writeUtf8 gate (renderModule certificate)
      (code, output, errors) <- readCreateProcessWithExitCode
        (proc "agda" arguments) { env = Just environment } ""
      -- THE FITNESS, ADDED 2026-08-20.  `code == ExitSuccess` is a number a
      -- process returned; the output was captured and then examined by
      -- nobody, so under `agda "$@" 2>&1 | cat` this returned True with
      -- agda's `1 != 0` in the very string it was returning alongside.
      -- `C.vetForeignRun` reads it, and once per process watches the kernel
      -- reject `(suc x) ≡ x`.
      (code', vetted) <- C.vetForeignRun repo code (output ++ errors)
      pure (code' == ExitSuccess, vetted))
    `finally` removePathForcibly private

writeUtf8 :: FilePath -> String -> IO ()
writeUtf8 path contents =
  withFile path WriteMode $ \handle -> do
    hSetEncoding handle utf8
    hPutStr handle contents

data ExecutableRule = ExecutableRule
  { ruleName :: String
  , ruleLhs :: Term
  , ruleRhs :: Term
  } deriving (Eq, Show)

type RuleSet = [ExecutableRule]

data PatternVariable = X | Y | Z deriving (Eq, Ord, Show)

type Substitution = Map.Map PatternVariable Term

patternVariable :: Term -> Maybe PatternVariable
patternVariable Var = Just X
patternVariable YVar = Just Y
patternVariable ZVar = Just Z
patternVariable _ = Nothing

-- This is MathMachine's matching discipline specialized to the three
-- variables supported by this certificate. Repeated occurrences must receive
-- one consistent substitution; constructors must agree exactly.
matchTerm :: Term -> Term -> Maybe Substitution
matchTerm patternTerm input = go patternTerm input Map.empty
  where
  go patternNode inputNode substitution =
    case patternVariable patternNode of
      Just variable ->
        case Map.lookup variable substitution of
          Nothing -> Just (Map.insert variable inputNode substitution)
          Just previous
            | previous == inputNode -> Just substitution
            | otherwise -> Nothing
      Nothing ->
        case (patternNode, inputNode) of
          (Zero, Zero) -> Just substitution
          (Suc patternChild, Suc inputChild) ->
            go patternChild inputChild substitution
          (Add patternLeft patternRight, Add inputLeft inputRight) -> do
            afterLeft <- go patternLeft inputLeft substitution
            go patternRight inputRight afterLeft
          _ -> Nothing

applySubstitution :: Substitution -> Term -> Term
applySubstitution substitution term =
  case patternVariable term of
    Just variable -> Map.findWithDefault term variable substitution
    Nothing ->
      case term of
        Zero -> Zero
        Suc child -> Suc (applySubstitution substitution child)
        Add left right ->
          Add
            (applySubstitution substitution left)
            (applySubstitution substitution right)
        Var -> Var
        YVar -> YVar
        ZVar -> ZVar

applyRule :: ExecutableRule -> Term -> Maybe Term
applyRule rule input = do
  substitution <- matchTerm (ruleLhs rule) input
  pure (applySubstitution substitution (ruleRhs rule))

runRuleSet :: RuleSet -> Term -> Maybe Term
runRuleSet [] _ = Nothing
runRuleSet (rule : rest) input =
  case applyRule rule input of
    Just output -> Just output
    Nothing -> runRuleSet rest input

validateAndInstall
  :: FilePath
  -> String
  -> RuleSet
  -> InductionCertificate
  -> IO (Bool, RuleSet)
validateAndInstall repo name rules certificate = do
  (accepted, diagnostic) <- validateWithAgda repo certificate
  if accepted
    then do
      putStrLn ("KERNEL-ACCEPT " ++ name)
      let rule = ExecutableRule
            name
            (certificateLhs certificate)
            (certificateRhs certificate)
      pure (True, rules ++ [rule])
    else do
      putStrLn ("KERNEL-REJECT " ++ name ++ "  " ++ take 3000 diagnostic)
      pure (False, rules)

associativityLhs :: Term
associativityLhs = Add YVar (Add ZVar Var)

associativityRhs :: Term
associativityRhs = Add (Add YVar ZVar) Var

-- Delete exactly the `hyp-suc` constructor around the first induction-
-- hypothesis use. The resulting Haskell value is deliberately ill-indexed;
-- Agda must be the component that discovers and rejects that mutation.
removeHypSuc :: HypDerivation -> Maybe HypDerivation
removeHypSuc (HypDone _) = Nothing
removeHypSuc (HypThen (HypSuc Hypothesis) rest) =
  Just (HypThen Hypothesis rest)
removeHypSuc (HypThen certificate rest) =
  HypThen certificate <$> removeHypSuc rest

mutateAssociativity
  :: InductionCertificate -> Maybe InductionCertificate
mutateAssociativity certificate = do
  mutatedStep <- removeHypSuc (stepDerivation certificate)
  pure certificate { stepDerivation = mutatedStep }

derivationLength :: Derivation -> Int
derivationLength (Done _) = 0
derivationLength (ThenStep _ rest) = 1 + derivationLength rest

hypDerivationLength :: HypDerivation -> Int
hypDerivationLength (HypDone _) = 0
hypDerivationLength (HypThen _ rest) = 1 + hypDerivationLength rest

main :: IO ()
main = do
  setLocaleEncoding utf8
  repo <- getCurrentDirectory
  associativity <-
    case deriveInductionCertificate associativityLhs associativityRhs of
      Just certificate -> pure certificate
      Nothing -> do
        putStrLn "SEARCH-FAIL associativity"
        exitFailure
  mutatedAssociativity <-
    case mutateAssociativity associativity of
      Just certificate -> pure certificate
      Nothing -> do
        putStrLn "MUTATION-FAIL derived trace did not use hyp-suc hypothesis"
        exitFailure
  let falseSearchRefused =
        deriveInductionCertificate Zero (Suc Zero) == Nothing
      lhs = certificateLhs associativity
      rhs = certificateRhs associativity
  putStrLn
    ("SEARCH-FOUND associativity baseSteps="
      ++ show (derivationLength (baseDerivation associativity))
      ++ " stepSteps="
      ++ show (hypDerivationLength (stepDerivation associativity)))
  unless falseSearchRefused $ do
    putStrLn "SEARCH-FAIL false equation unexpectedly derived"
    exitFailure
  (accepted, rulesAfterGood) <-
    validateAndInstall repo "associativity" [] associativity
  (mutatedAccepted, rulesAfterMutation) <-
    validateAndInstall repo "mutated-hypothesis-transport"
      rulesAfterGood mutatedAssociativity
  let one = Suc Zero
      two = Suc one
      compound = Add Zero one
      concreteInput = Add one (Add compound two)
      concreteOutput = Add (Add one compound) two
      repeatedPattern = Add Var Var
      consistentRepeated =
        matchTerm repeatedPattern (Add compound compound) /= Nothing
      inconsistentRepeated =
        matchTerm repeatedPattern (Add compound two) == Nothing
      nonmatchingTerm = runRuleSet rulesAfterMutation (Suc compound) == Nothing
      concreteExecuted =
        runRuleSet rulesAfterMutation concreteInput == Just concreteOutput
      concreteIsNotPattern = concreteInput /= lhs
      nonDefinitional = lhs /= rhs
      mutationDidNotInstall = rulesAfterMutation == rulesAfterGood
      exactlyOneRule = length rulesAfterMutation == 1
  if accepted
      && not mutatedAccepted
      && nonDefinitional
      && concreteIsNotPattern
      && concreteExecuted
      && consistentRepeated
      && inconsistentRepeated
      && nonmatchingTerm
      && falseSearchRefused
      && mutationDidNotInstall
      && exactlyOneRule
    then putStrLn
      "MATHMACHINE INDUCTION GATE CHECKED: concrete rewrite + consistent matching; mutation absent"
    else do
      putStrLn
        ("induction gate failure: accepted=" ++ show accepted
          ++ ", mutatedAccepted=" ++ show mutatedAccepted
          ++ ", concreteExecuted=" ++ show concreteExecuted
          ++ ", consistentRepeated=" ++ show consistentRepeated
          ++ ", inconsistentRepeated=" ++ show inconsistentRepeated
          ++ ", nonmatchingTerm=" ++ show nonmatchingTerm
          ++ ", installedRules=" ++ show rulesAfterMutation)
      exitFailure
