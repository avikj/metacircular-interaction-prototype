{-# LANGUAGE LambdaCase #-}

-- A minimal executable Haskell -> Agda -> installation seam.
-- Run: runghc machine/AgdaRewriteGate.hs
module Main (main) where

import Control.Exception (finally)
import System.Directory (getCurrentDirectory, removePathForcibly)
import System.Exit (ExitCode (..), exitFailure)
import System.FilePath ((</>))
import System.Process (readProcess, readProcessWithExitCode)

data Term = Var | Zero | Suc Term | Add Term Term deriving (Eq, Show)

data StepCert
  = AddZero Term
  | AddSuc Term Term
  | SucStep StepCert
  | AddLeft StepCert Term
  | AddRight Term StepCert
  | Reverse StepCert
  deriving (Eq, Show)

data Derivation
  = Done Term
  | Then StepCert Derivation
  deriving (Eq, Show)

-- Unlike MathMachine's current String, the certificate carries its exact
-- conclusion. Agda checks both that the derivation has these endpoints and,
-- through RewriteCertificate.derivation-sound, that the installed endpoints
-- denote pointwise-equal functions Nat -> Nat.
data Certificate = Certificate
  { source :: Term
  , target :: Term
  , derivation :: Derivation
  } deriving (Eq, Show)

renderTerm :: Term -> String
renderTerm = \case
  Var -> "var"
  Zero -> "zero"
  Suc x -> "(suc " ++ renderTerm x ++ ")"
  Add x y -> "(add " ++ renderTerm x ++ " " ++ renderTerm y ++ ")"

renderStep :: StepCert -> String
renderStep = \case
  AddZero x -> "(add-zero " ++ renderTerm x ++ ")"
  AddSuc x y -> "(add-suc " ++ renderTerm x ++ " " ++ renderTerm y ++ ")"
  SucStep p -> "(suc-step " ++ renderStep p ++ ")"
  AddLeft p z -> "(add-left " ++ renderStep p ++ " " ++ renderTerm z ++ ")"
  AddRight z p -> "(add-right " ++ renderTerm z ++ " " ++ renderStep p ++ ")"
  Reverse p -> "(reverse " ++ renderStep p ++ ")"

renderDerivation :: Derivation -> String
renderDerivation = \case
  Done x -> "(done " ++ renderTerm x ++ ")"
  Then p rest -> "(then-step " ++ renderStep p ++ " " ++ renderDerivation rest ++ ")"

renderModule :: Certificate -> String
renderModule c = unlines
  [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
  , "module Gate where"
  , "open import NaturalMachine.RewriteCertificate"
  , "candidate : Derivation " ++ renderTerm (source c) ++ " " ++ renderTerm (target c)
  , "candidate = " ++ renderDerivation (derivation c)
  ]

validateWithAgda :: FilePath -> Certificate -> IO Bool
validateWithAgda repo c = do
  tmp <- init <$> readProcess "mktemp" ["-d"] ""
  let gate = tmp </> "Gate.agda"
  (do writeFile gate (renderModule c)
      (code, _, _) <- readProcessWithExitCode "agda"
        ["-i", repo </> "formal/cubical", "-i", tmp, gate] ""
      pure (code == ExitSuccess))
    `finally` removePathForcibly tmp

data NativeRule = NativeRule
  { ruleName :: String
  , ruleSource :: Term
  , ruleTarget :: Term
  , ruleCertificate :: Certificate
  } deriving (Eq, Show)

type Rules = [NativeRule]

-- Applicability is retained as an exact source match. A checked theorem does
-- not become a globally firing rewrite.
applyNative :: NativeRule -> Term -> Maybe Term
applyNative rule input
  | input == ruleSource rule = Just (ruleTarget rule)
  | otherwise = Nothing

-- Preserve operation identity and multiplicity. Equal targets are parallel
-- futures, not evidence that the branches may be collapsed.
parallelFutures :: Rules -> Term -> [(NativeRule, Term)]
parallelFutures rules input =
  [ (rule, output) | rule <- rules, Just output <- [applyNative rule input] ]

-- The rule enters the executable set only on Agda's successful exit.
validateAndInstall :: FilePath -> String -> Rules -> Certificate -> IO (Bool, Rules)
validateAndInstall repo name rules c = do
  accepted <- validateWithAgda repo c
  let native = NativeRule name (source c) (target c) c
  pure (accepted, if accepted then rules ++ [native] else rules)

good :: Certificate
good = Certificate
  (Add Var (Suc Zero))
  (Suc Var)
  (Then (AddSuc Var Zero)
    (Then (SucStep (AddZero Var)) (Done (Suc Var))))

-- One altered constructor: the inner add-zero step is no longer transported
-- through suc. Its source cannot match the preceding step's target.
mutated :: Certificate
mutated = Certificate
  (Add Var (Suc Zero))
  (Suc Var)
  (Then (AddSuc Var Zero)
    (Then (AddZero Var) (Done (Suc Var))))

-- The executable gate used to expose only `suc-step`, although the checked
-- calculus also permits rewriting under either argument of addition and
-- reversing a certified step.  These controls keep all three transports live.
underLeft :: Certificate
underLeft = Certificate
  (Add (Add Var Zero) Var)
  (Add Var Var)
  (Then (AddLeft (AddZero Var) Var) (Done (Add Var Var)))

underRightReversed :: Certificate
underRightReversed = Certificate
  (Add Var Var)
  (Add Var (Add Var Zero))
  (Then (AddRight Var (Reverse (AddZero Var)))
    (Done (Add Var (Add Var Zero))))

main :: IO ()
main = do
  repo <- getCurrentDirectory
  (ok, rules1) <- validateAndInstall repo "good" [] good
  (bad, rules2) <- validateAndInstall repo "mutated" rules1 mutated
  (leftOk, rules3) <- validateAndInstall repo "under-left" rules2 underLeft
  (rightReverseOk, rules4) <- validateAndInstall repo "under-right-reversed" rules3 underRightReversed
  -- A second checked installation with the same extensional action remains a
  -- second future. This is the executable no-premature-collapse control.
  (duplicateOk, rules5) <- validateAndInstall repo "good-second-source" rules4 good
  let futures = parallelFutures rules5 (source good)
      controlled = case rules1 of
        [rule] -> applyNative rule (source good) == Just (target good)
               && applyNative rule Zero == Nothing
        _ -> False
  if ok && not bad && leftOk && rightReverseOk
      && duplicateOk
      && length rules1 == 1
      && rules2 == rules1
      && controlled
      && map (ruleName . fst) futures == ["good", "good-second-source"]
    then putStrLn "AGDA GRAMMAR GATE CHECKED: controlled rules + two uncollapsed futures"
    else do
      putStrLn ("gate failure: accepted=" ++ show ok ++ ", mutated=" ++ show bad
                ++ ", installed=" ++ show rules2)
      exitFailure
