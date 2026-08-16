-- Certificate.hs — the Agda emitter for MathMachine's kernel gate.
--
-- WHAT THIS REPLACES, AND WHY
--
-- MathMachine.hs proves equations with its own rewriting + structural
-- induction, then submits each one to `kernelAccept`, which emits a
-- candidate Agda module and typechecks it.  The emitter it currently uses
-- (`agdaCertificate`, MathMachine.hs ~1193) is
--
--     candidate : (x y z u v w : ℕ) → LHS ≡ RHS
--     candidate x y z u v w = refl
--
-- Three separate faults make that gate reject everything.  All three were
-- reproduced directly (see the notes on each below); this module fixes all
-- three.
--
--   (1) LIBRARY RESOLUTION.  The engine runs
--
--           agda -i formal/cubical -i <tmpdir> <tmpdir>/Candidate.agda
--
--       from the repository root.  `formal/cubical` is NOT the cubical
--       library — it is the NaturalMachine lane, and it carries
--       `natural-machine.agda-lib` (`depend: cubical`).  The cubical
--       library itself lives at /tmp/cubical and is reachable only through
--       ~/.agda/libraries.  Agda finds a library only by walking up from
--       the *checked file* to an .agda-lib; a module in a temp directory
--       has none, so `Cubical.Foundations.Prelude` is unresolvable and the
--       candidate dies at scope-checking, before any proof term is looked
--       at.  Reproduced with the engine's own positive control:
--
--           $ LC_ALL=C.UTF-8 ./math-machine --kernel-self-test
--             KERNEL-REJECT round=0 (0+x) = x  ... Failed to find source
--             of module Cubical.Fou...
--
--       i.e. the gate rejects `0 + x ≡ x`.  Zero KERNEL-ACCEPTs was never
--       a statement about the emitter's expressiveness; nothing could pass.
--       Fixed here by `kAgdaLibrary` / `agdaArgs`, which add
--       `--library=cubical` to the otherwise identical invocation.
--
--   (2) FILE ENCODING.  `kernelAccept` writes the candidate with plain
--       `writeFile`, which uses the locale encoding.  Without a UTF-8
--       locale in the machine's own environment this throws before agda is
--       ever spawned:
--
--           mm: /tmp/math-machine-agda.pXe4qi/Candidate.agda: withFile:
--               invalid argument (cannot encode character '\8469')
--
--       Fixed here by `writeUtf8`, which sets the handle encoding
--       explicitly rather than trusting the ambient locale, and by
--       forcing LC_ALL in the agda child's environment.
--
--   (3) EXPRESSIVENESS, the fault the seam was actually designed around.
--       `agdaTerm` knew only 0, s, + and · — four of the eight symbols in
--       `vocabulary` — and the only proof shape was `refl`, so nothing
--       needing induction could be certified.  Both are addressed below.
--
-- FAITHFULNESS (the load-bearing point)
--
-- A certificate about a different function is worse than no certificate.
-- Each symbol below is either an Agda function that is clause-for-clause
-- the same recursion as the corresponding `symDefs` in MathMachine's
-- `vocabulary`, or a local definition transcribed from those `symDefs`:
--
--   0, s     zero, suc                                     (identical)
--   +        Agda.Builtin.Nat._+_  via Cubical.Data.Nat     (see note A)
--   *        Agda.Builtin.Nat._*_  via Cubical.Data.Nat     (see note A)
--   -        Agda.Builtin.Nat._-_ = _∸_ via Cubical.Data.Nat
--            machine: -x0=x, -0x=0, -(sx)(sy)=-xy
--            builtin:  n-zero=n, zero-suc m=zero, suc n-suc m=n-m
--            — same clauses, same order.  Exact match.
--   max      LOCAL.  Cubical's `max` (Cubical.Data.Nat.Properties) is the
--            same function but splits on the FIRST argument, whereas
--            MathMachine's symDefs are (max x 0 = x), (max 0 x = x),
--            (max (s x) (s y) = s (max x y)) — first clause on the second
--            argument.  Emitted locally in the machine's clause order so
--            the machine's own reductions are available (see note B).
--   le       LOCAL.  Cubical has no ℕ-valued ≤ test.  Transcribed from
--            symDefs: le 0 x = s 0, le (s x) 0 = 0, le (s x) (s y) = le x y.
--            Agrees with `symSem` (\vs -> if a <= b then 1 else 0).
--   gcd      Cubical.Data.Nat.GCD.gcd.  Same function as Haskell `gcd` on
--            ℕ (both are the ≡-unique greatest common divisor, gcd 0 0 = 0),
--            but it is defined through `euclid` and reduces on no open
--            term, so gcd equations will essentially never certify.  It is
--            translated anyway: a KERNEL-REJECT carrying agda's message is
--            more informative than a KERNEL-SKIP.
--
-- Note A.  Agda's `+` and `·` recurse on the FIRST argument; MathMachine's
-- symDefs recurse on the second (x+0=x, x+s y = s(x+y)).  These are the
-- same function on ℕ — the machine's `symSem` is Haskell's (+) and (*),
-- and the cubical/builtin operations are ordinary ℕ addition and
-- multiplication — so the certificate is about the right object.  The
-- clause order differs only in which equations hold *definitionally*, and
-- the first-argument order was measured to certify strictly more of the
-- machine's library than a transcription of the symDefs would (it makes
-- (s x + y) = s (x + y) and (s x · y) = y + x · y refl, which the
-- second-argument order does not).
--
-- Note B.  No Agda case tree reproduces MathMachine's `max` reductions
-- exactly: the machine uses (max x 0 = x) and (max 0 x = x) as
-- unconditional rewrite rules in BOTH argument positions, while a case
-- tree must commit to splitting one column first.  The local definition
-- here matches the symDefs clause list literally; what it cannot match is
-- the machine's rewriting being stronger than pattern matching.  This is a
-- real residual gap and it is why `(x max s 0) = (s 0 max x)` does not
-- certify (see `main`'s report).
--
-- INVOCATION BUDGET
--
-- Trying several proof shapes means calling agda more than once per
-- candidate.  That is bounded and explicit: `kMaxAgdaCalls`.  The order is
-- always cheapest-first — a plain `refl` module (one call), then the
-- induction skeleton with step shapes from `stepShapes`.  If the *base*
-- clause is what agda rejects, the remaining step shapes cannot help, so
-- the search stops there (`baseClauseFailed`); a false equation therefore
-- costs 2 calls, not `kMaxAgdaCalls`.
--
-- This module deliberately has no dependency on MathMachine: it carries
-- its own copy of the Term type so it can be compiled, run and tested on
-- its own.  `main` is that test.  From the repository root:
--
--     ghc -O0 -Wall -main-is Certificate.main \
--         -outputdir /tmp/cert-build -o /tmp/cert machine/Certificate.hs
--     /tmp/cert            # or: /tmp/cert <repository-root>
--
-- It takes about 100 seconds and prints one line per equation.  Result at
-- the time of writing: 15 of the 28 lines of machine/library.snapshot.txt
-- certify, 13 are rejected with agda's reason, none are untranslatable,
-- and four deliberate falsehoods are all rejected.  Every one of the 13
-- rejections is a commutativity- or associativity-shaped statement whose
-- BASE case is itself a lemma (y ≢ y + zero definitionally); closing them
-- needs a lemma environment — certificates emitted in dependency order,
-- with earlier theorems in scope for later ones — not more step shapes.

module Certificate
  ( -- * terms
    Term(..)
  , Equation
  , varsOf
  , symbolsOf
    -- * translation
  , Definition(..)
  , agdaTerm
  , agdaTermWith
  , agdaVar
  , preamble
  , preambleWith
    -- * certificates
  , agdaCertificate
  , agdaCertificateWith
  , agdaInductionCertificate
  , inductionVariable
  , stepShapes
    -- * policy
  , kMaxAgdaCalls
  , kMaxCongArguments
  , kAgdaLibrary
  , kIncludeRoot
  , agdaArgs
    -- * running
  , Verdict(..)
  , certify
  , certifyWith
  , runAgda
  , main
    -- * serialisable certificates + replay (the re-checkable ledger)
  , ProofWitness(..)
  , SerialCert(..)
  , mkSerialCert
  , serTerm
  , parseSerTerm
  , serializeCert
  , parseSerialCert
  , reconstructModule
  , certifyCert
  , replayCert
    -- * reading machine/library.txt
  , parseShowTerm
  , parseLibraryLine
  ) where

import Control.Exception (finally)
import Data.Char (isAlphaNum, isDigit, isSpace)
import Data.List (intercalate, isInfixOf, isPrefixOf, nub, sort)
import Data.Maybe (isJust, mapMaybe)
import GHC.IO.Encoding (setLocaleEncoding)
import System.Environment (getArgs, getEnvironment)
import System.Exit (ExitCode(..), exitFailure, exitSuccess)
import System.FilePath ((</>))
import System.IO
import System.Directory (getTemporaryDirectory, removePathForcibly)
import System.Process
  (CreateProcess(..), proc, readProcess, readCreateProcessWithExitCode)
import Text.Printf (printf)

-- ------------------------------------------------------------------ terms
--
-- Mirrors MathMachine's `data Term = V !Int | F !String [Term]`.  Kept
-- separate on purpose: this module must be compilable and testable without
-- the engine.  The seam adapts one to the other.

data Term = V !Int | F !String [Term] deriving (Eq, Ord, Show)

type Equation = (Term, Term)

varsOf :: Term -> [Int]
varsOf (V i) = [i]
varsOf (F _ ts) = concatMap varsOf ts

symbolsOf :: Term -> [String]
symbolsOf (V _) = []
symbolsOf (F f ts) = f : concatMap symbolsOf ts

equationVars :: Equation -> [Int]
equationVars (l, r) = sort (nub (varsOf l ++ varsOf r))

equationSymbols :: Equation -> [String]
equationSymbols (l, r) = nub (symbolsOf l ++ symbolsOf r)

-- ------------------------------------------------------------ translation

-- The six universe names, matching MathMachine's Show instance for terms
-- so that log lines and certificates talk about the same variables.
agdaVar :: Int -> Maybe String
agdaVar i
  | i >= 0 && i < 6 = Just ["xyzuvw" !! i]
  | otherwise = Nothing

-- A concept the machine named for itself.  `inventConcept`
-- (MathMachine.hs ~1478) builds `Sym nm ar (\args -> eval sem args p)`
-- with the single defining equation (p, cN x0 … x_{ar-1}); so the Agda
-- transcription is `cN a0 … a_{ar-1} = p[V i := a_i]`, which is what
-- `preambleWith` emits.  Without this an invented symbol is a
-- KERNEL-SKIP, and concept invention is the machine's main growth axis.
data Definition = Definition
  { defName :: String   -- ^ the machine's name for it, e.g. "c0"
  , defArity :: Int
  , defBody :: Term     -- ^ body, over variables V 0 .. V (defArity - 1)
  } deriving (Eq, Show)

-- Every symbol of MathMachine's `vocabulary` (0 s + * max - gcd le), plus
-- whatever invented concepts the caller supplies.  Anything else — the
-- eigenconstant #, an unsupplied concept — returns Nothing, which the
-- caller reports as untranslatable.
agdaTerm :: Term -> Maybe String
agdaTerm = agdaTermWith []

agdaTermWith :: [Definition] -> Term -> Maybe String
agdaTermWith defs = render defs agdaVar

-- `nameOf` is how variables are spelled: the candidate's own variables are
-- x y z u v w, a local definition's parameters are a0 a1 ….
render :: [Definition] -> (Int -> Maybe String) -> Term -> Maybe String
render defs nameOf = go
  where
    go (V i) = nameOf i
    go (F "0" []) = Just "zero"
    go (F "s" [t]) = (\u -> "(suc " ++ u ++ ")") <$> go t
    go (F "+" [a, b]) = infixAgda go "+" a b
    go (F "*" [a, b]) = infixAgda go "·" a b
    go (F "-" [a, b]) = infixAgda go "∸" a b
    go (F "max" [a, b]) = prefixAgda go "max" [a, b]
    go (F "le" [a, b]) = prefixAgda go "le" [a, b]
    go (F "gcd" [a, b]) = prefixAgda go "gcd" [a, b]
    go (F f as)
      | Just d <- lookupDef defs f, defArity d == length as =
          prefixAgda go f as
    go _ = Nothing

lookupDef :: [Definition] -> String -> Maybe Definition
lookupDef defs f = case [ d | d <- defs, defName d == f ] of
  (d : _) -> Just d
  [] -> Nothing

infixAgda :: (Term -> Maybe String) -> String -> Term -> Term -> Maybe String
infixAgda go op a b = do
  x <- go a
  y <- go b
  pure ("(" ++ x ++ " " ++ op ++ " " ++ y ++ ")")

prefixAgda :: (Term -> Maybe String) -> String -> [Term] -> Maybe String
prefixAgda go f as = do
  xs <- mapM go as
  pure ("(" ++ unwords (f : xs) ++ ")")

-- Parameter names for a local definition's own clause.  Deliberately not
-- x y z u v w: those name the candidate's universally quantified
-- variables and a local definition must not appear to capture them.
defVar :: Int -> Maybe String
defVar i | i >= 0 = Just ("a" ++ show i)
         | otherwise = Nothing

-- Imports and local definitions are demand-driven: a candidate that never
-- mentions gcd must not pay for typechecking Cubical.Data.Nat.GCD (which
-- roughly triples the cost of a call).
preamble :: [String] -> [String]
preamble = preambleWith []

preambleWith :: [Definition] -> [String] -> [String]
preambleWith defs syms =
  preambleCore (syms ++ concatMap (symbolsOf . defBody) used)
    ++ concatMap emit used
  where
    -- transitive: c1's body may mention c0, and Agda needs c0 first.
    used = [ d | d <- defs, defName d `elem` closure ]
    closure = grow (filter (isJust . lookupDef defs) syms)
    grow seen =
      let more = nub (seen ++ [ f | s <- seen
                                  , Just d <- [lookupDef defs s]
                                  , f <- symbolsOf (defBody d)
                                  , isJust (lookupDef defs f) ])
      in if length more == length seen then seen else grow more
    emit d =
      case render defs defVar (defBody d) of
        Nothing -> []   -- an untranslatable body drops the definition, so
                        -- the candidate fails to scope-check rather than
                        -- silently meaning something else
        Just body ->
          [ defName d ++ " : " ++ concat (replicate (defArity d) "ℕ → ") ++ "ℕ"
          , unwords (defName d : params) ++ " = " ++ body
          ]
      where
        params = mapMaybe defVar [0 .. defArity d - 1]

preambleCore :: [String] -> [String]
preambleCore syms =
  [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
  , "module Candidate where"
  , "open import Cubical.Foundations.Prelude"
  -- _+_, _·_ and _∸_ come in unconditionally even when the equation does
  -- not mention them: the step shapes in `stepShapes` build sections like
  -- (y +_) and (_· k), and an operator that is not in scope makes the
  -- module fail to PARSE rather than to typecheck — which burns an
  -- invocation and reports a syntax error where the real answer is "that
  -- shape does not apply".  They all live in the module being opened
  -- anyway, so naming them costs nothing.
  , "open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_)"
  ]
  ++ [ "open import Cubical.Data.Nat.GCD using (gcd)" | need "gcd" ]
  ++ localMax
  ++ localLe
  where
    need s = s `elem` syms
    -- transcribed from vocabulary's symDefs for "max", in that order
    localMax
      | need "max" =
          [ "max : ℕ → ℕ → ℕ"
          , "max a zero = a"
          , "max zero b = b"
          , "max (suc a) (suc b) = suc (max a b)"
          ]
      | otherwise = []
    -- transcribed from vocabulary's symDefs for "le", in that order
    localLe
      | need "le" =
          [ "le : ℕ → ℕ → ℕ"
          , "le zero b = suc zero"
          , "le (suc a) zero = zero"
          , "le (suc a) (suc b) = le a b"
          ]
      | otherwise = []

-- ----------------------------------------------------------- certificates

-- The fast case, and the only case the old emitter had: an equation true
-- by definitional unfolding.
agdaCertificate :: Equation -> Maybe String
agdaCertificate = agdaCertificateWith []

agdaCertificateWith :: [Definition] -> Equation -> Maybe String
agdaCertificateWith defs eq@(l, r) = do
  lhs <- agdaTermWith defs l
  rhs <- agdaTermWith defs r
  names <- mapM agdaVar (equationVars eq)
  pure $ unlines $
    preambleWith defs (equationSymbols eq)
    ++ [ "candidate : " ++ telescope names ++ lhs ++ " ≡ " ++ rhs
       , "candidate " ++ unwords names ++ " = refl"
       ]

telescope :: [String] -> String
telescope [] = ""
telescope ns = "(" ++ unwords ns ++ " : ℕ) → "

-- The induction skeleton.  Returns the module source and the 1-based line
-- number of the base clause, so a base-clause failure can be told apart
-- from a step-clause failure without rerunning anything.
agdaInductionCertificate :: [Definition] -> Equation -> Int -> String
                         -> Maybe (String, Int)
agdaInductionCertificate defs eq@(l, r) v step = do
  lhs <- agdaTermWith defs l
  rhs <- agdaTermWith defs r
  let vs = equationVars eq
  nv <- agdaVar v
  if v `notElem` vs then Nothing else do
    names <- mapM agdaVar vs
    let pre = preambleWith defs (equationSymbols eq)
        sig = "candidate : " ++ telescope names ++ lhs ++ " ≡ " ++ rhs
        pat u = unwords [ if i == v then u else n | (i, n) <- zip vs names ]
        baseC = "candidate " ++ pat "zero" ++ " = refl"
        stepC = "candidate " ++ pat ("(suc " ++ nv ++ ")") ++ " = " ++ step
        baseLine = length pre + 2
    pure (unlines (pre ++ [sig, baseC, stepC]), baseLine)

-- The induction hypothesis, as a term: `candidate` applied to the same
-- variables, with the induction variable at its (now smaller) name.
inductionHypothesis :: Equation -> Int -> Maybe String
inductionHypothesis eq _ = do
  names <- mapM agdaVar (equationVars eq)
  pure ("candidate " ++ unwords names)

-- The ordered shape list for the step case.  Cheapest and most likely
-- first.  `ih` alone is not decoration: it is what closes every monus and
-- le theorem in the library (suc x ∸ suc x reduces to x ∸ x, so the goal
-- IS the hypothesis).
stepShapes :: String -> [String] -> [(String, String)]
stepShapes ih ks =
  [ ("refl", "refl")
  , ("ih", ih)
  , ("cong suc", "cong suc (" ++ ih ++ ")")
  ]
  ++ concat
     [ [ ("cong (_+ " ++ k ++ ")", "cong (_+ " ++ k ++ ") (" ++ ih ++ ")")
       , ("cong (" ++ k ++ " +_)", "cong (" ++ k ++ " +_) (" ++ ih ++ ")")
       , ("cong (_· " ++ k ++ ")", "cong (_· " ++ k ++ ") (" ++ ih ++ ")")
       , ("cong (" ++ k ++ " ·_)", "cong (" ++ k ++ " ·_) (" ++ ih ++ ")")
       ]
     | k <- ks ]

-- Read the machine's proof annotation.  MathMachine writes
-- "induction on " ++ show (V v); library.snapshot.txt writes it in
-- brackets.  Both are accepted, as is a bare variable name.
inductionVariable :: String -> Maybe Int
inductionVariable s = go (dropWhile isSpace s)
  where
    marker = "induction on "
    go [] = Nothing
    go t@(_:rest)
      | marker `isPrefixOf` t = nameToIndex (drop (length marker) t)
      | otherwise = go rest
    nameToIndex t = case dropWhile isSpace t of
      (c:_) | Just i <- lookup c (zip "xyzuvw" [0 ..]) -> Just i
      ('n':ds) | (d@(_:_), _) <- span isDigit ds -> Just (read d)
      _ -> Nothing

-- ---------------------------------------------------------------- policy

-- How many cong-shapes get an argument, and which arguments.  Every
-- variable of the equation is a candidate `k`; the cap keeps the budget a
-- constant rather than a function of the equation.
kMaxCongArguments :: Int
kMaxCongArguments = 2

-- The invocation budget per candidate, stated once and derived, not
-- guessed: one refl module plus one module per step shape.
kMaxAgdaCalls :: Int
kMaxAgdaCalls = 1 + length (stepShapes "ih" (replicate kMaxCongArguments "k"))

-- The cubical library, by name as registered in ~/.agda/libraries.
-- Without this the engine's invocation cannot resolve Cubical.* at all;
-- see fault (1) in the header.
kAgdaLibrary :: String
kAgdaLibrary = "cubical"

-- The engine's include root, kept so NaturalMachine.* stays reachable.
kIncludeRoot :: FilePath
kIncludeRoot = "formal/cubical"

agdaArgs :: FilePath -> FilePath -> [String]
agdaArgs dir file =
  ["-i", kIncludeRoot, "-i", dir, "--library=" ++ kAgdaLibrary, file]

-- --------------------------------------------------------------- running

data Verdict
  = Certified String Int     -- ^ shape that worked, agda calls spent
  | Rejected String Int      -- ^ agda's first error line, agda calls spent
  | Untranslatable String    -- ^ symbol or variable outside the fragment
  deriving (Eq, Show)

-- Write UTF-8 regardless of the ambient locale.  `writeFile` does not; see
-- fault (2) in the header.
writeUtf8 :: FilePath -> String -> IO ()
writeUtf8 path s = withFile path WriteMode $ \h -> do
  hSetEncoding h utf8
  hPutStr h s

-- One agda invocation.  `root` is the working directory (the repository
-- root, as the engine uses).  LC_ALL is forced because agda prints λ and
-- dies under the C locale.
--
-- The reader's own locale is forced too.  Agda's diagnostics contain ℕ and
-- ≡, and `readCreateProcessWithExitCode` decodes the child's pipes with
-- the process locale encoding; under LANG=C that throws
--   hGetContents: invalid argument (cannot decode byte sequence ...)
-- which is fault (2) again, on the way back.  This is idempotent global
-- state and is set on every call so the seam cannot forget it.
runAgda :: FilePath -> String -> IO (ExitCode, String)
runAgda root source = do
  setLocaleEncoding utf8
  tmp <- getTemporaryDirectory
  dirLine <- readProcess "mktemp" ["-d", tmp </> "math-machine-agda.XXXXXX"] ""
  let dir = reverse (dropWhile isSpace (reverse dirLine))
      file = dir </> "Candidate.agda"
  (do writeUtf8 file source
      base <- getEnvironment
      let env' = ("LC_ALL", "C.UTF-8")
                 : ("LANG", "C.UTF-8")
                 : [ kv | kv@(k, _) <- base, k /= "LC_ALL", k /= "LANG" ]
          cp = (proc "agda" (agdaArgs dir file))
                 { cwd = Just root, env = Just env' }
      (code, out, err) <- readCreateProcessWithExitCode cp ""
      pure (code, out ++ err))
    `finally` removePathForcibly dir

-- Agda's first complaint, as one line, for the log.  The location line
-- ("<tmpdir>/Candidate.agda:12,25-31") is dropped: the path is a temp
-- directory that no longer exists by the time anyone reads the log, and it
-- would otherwise crowd out the message.
firstErrorLine :: String -> String
firstErrorLine out =
  case dropWhile uninformative (lines out) of
    [] -> "(agda said nothing)"
    ls -> unwords (words (unwords (take 2 ls)))
  where
    uninformative ln =
      null (dropWhile isSpace ln)
        || "Checking " `isPrefixOf` dropWhile isSpace ln
        || ".agda:" `isInfixOf` ln

-- The line agda blamed, if it named one: "<path>:LINE,COL-..." .
blamedLine :: String -> Maybe Int
blamedLine out = case mapMaybe grab (lines out) of
  (n : _) -> Just n
  [] -> Nothing
  where
    grab ln = case break (== ':') (dropWhile isSpace ln) of
      (_, ':' : rest) | (ds@(_ : _), ',' : _) <- span isDigit rest -> Just (read ds)
      _ -> Nothing

-- The gate.  Fast path first, then the induction skeleton if the machine's
-- proof used induction.  Never exceeds kMaxAgdaCalls.
certify :: FilePath -> (Equation, String) -> IO Verdict
certify = certifyWith []

certifyWith :: [Definition] -> FilePath -> (Equation, String) -> IO Verdict
certifyWith defs root (eq, proofNote) =
  case agdaCertificateWith defs eq of
    Nothing -> pure (Untranslatable (untranslatableReason defs eq))
    Just reflSource -> do
      (code, out) <- runAgda root reflSource
      case code of
        ExitSuccess -> pure (Certified "refl" 1)
        ExitFailure _ ->
          case inductionVariable proofNote of
            Nothing -> pure (Rejected (firstErrorLine out) 1)
            Just v -> do
              let ks = take kMaxCongArguments
                         (mapMaybe agdaVar (equationVars eq))
              case inductionHypothesis eq v of
                Nothing -> pure (Rejected (firstErrorLine out) 1)
                Just ih -> tryShapes v (stepShapes ih ks) 1 (firstErrorLine out)
  where
    tryShapes _ [] used lastErr = pure (Rejected lastErr used)
    tryShapes v ((label, step) : more) used _lastErr =
      case agdaInductionCertificate defs eq v step of
        Nothing -> pure (Rejected "induction variable outside the equation" used)
        Just (source, baseLine) -> do
          (code, out) <- runAgda root source
          let used' = used + 1
          case code of
            ExitSuccess ->
              let nv = maybe (show v) id (agdaVar v)
              in pure (Certified ("induction on " ++ nv ++ ", step = " ++ label) used')
            ExitFailure _
              -- Agda blamed the base clause: no step shape can rescue it.
              | blamedLine out == Just baseLine ->
                  pure (Rejected ("base clause: " ++ firstErrorLine out) used')
              | otherwise -> tryShapes v more used' (firstErrorLine out)

untranslatableReason :: [Definition] -> Equation -> String
untranslatableReason defs eq@(l, r) =
  case [ s | s <- equationSymbols eq, not (known s) ] of
    (s : _) -> "unknown symbol " ++ show s
    [] -> case [ i | i <- equationVars eq, not (isJust (agdaVar i)) ] of
      (i : _) -> "variable index out of range: " ++ show i
      [] -> "untranslatable: " ++ show l ++ " = " ++ show r
  where
    known s = s `elem` ["0", "s", "+", "*", "-", "max", "le", "gcd"]
                || isJust (lookupDef defs s)

-- --------------------------------------------- serialisable certificates
--
-- The corpus wants machine/library.txt to be a re-checkable LEDGER, not a
-- trust-me list.  `certify` above proves a library equation once, inside
-- this process, and then the proof term is gone: the file records only the
-- equation and a prose note ("[induction on x]").  Re-reading the file
-- therefore re-runs the *search* (agdaCertificate + stepShapes), which is
-- not the same as re-checking a fixed proof — a change to `stepShapes` could
-- silently change which library entries are provable.
--
-- A `SerialCert` closes that gap.  It records the exact proof WITNESS that
-- agda accepted (refl, or induction on a named variable with the exact step
-- term), so:
--
--   (a) it RECONSTRUCTS THE PROOF TERM deterministically — `reconstructModule`
--       emits the one Agda module that carries the accepted proof, with no
--       search; and
--   (b) it ROUND-TRIPS — `serializeCert` / `parseSerialCert` are inverses on
--       the fragment, so a serialised ledger entry parses back to the same
--       witness, whose reconstructed module agda re-checks to the same
--       theorem (`replayCert`).
--
-- The Agda side these land in is NaturalMachine.RewriteCertificate: a checked
-- `candidate : lhs ≡ rhs` is exactly the hypothesis of `derivation-sound` /
-- `induction-sound` there, i.e. the semantic warrant that the endpoints
-- denote pointwise-equal functions ℕ → ℕ.

-- The proof that a `SerialCert` carries, in a form that reconstructs a
-- specific Agda module rather than a search.
data ProofWitness
  = WRefl                    -- ^ true by definitional unfolding: `refl`
  | WInduction Int String    -- ^ induction on variable i, with this exact
                             --   step term (an Agda expression, e.g. the
                             --   induction hypothesis under `cong suc`)
  deriving (Eq, Show)

-- A ledger entry: the theorem endpoints, the concept definitions its terms
-- need in scope, and the witness that discharges it.  Everything needed to
-- rebuild and re-check the proof, with nothing left to a search.
data SerialCert = SerialCert
  { scLhs :: Term
  , scRhs :: Term
  , scDefs :: [Definition]
  , scWitness :: ProofWitness
  } deriving (Eq, Show)

mkSerialCert :: [Definition] -> Equation -> ProofWitness -> SerialCert
mkSerialCert defs (l, r) w = SerialCert l r defs w

-- Canonical prefix serialisation of a Term.  Deliberately NOT the machine's
-- infix `show` (which is ambiguous for word operators like `max`: `(xmaxx)`);
-- this form is an exact inverse of `parseSerTerm` on the whole Term type.
serTerm :: Term -> String
serTerm (V i)    = "v" ++ show i
serTerm (F f ts) = "(" ++ unwords (f : map serTerm ts) ++ ")"

serTokenize :: String -> [String]
serTokenize [] = []
serTokenize (c : cs)
  | c == '('  = "(" : serTokenize cs
  | c == ')'  = ")" : serTokenize cs
  | isSpace c = serTokenize cs
  | otherwise =
      let (a, rest) = span (\x -> x /= '(' && x /= ')' && not (isSpace x)) (c : cs)
      in a : serTokenize rest

parseSerTerm :: String -> Maybe Term
parseSerTerm s = case pSer (serTokenize s) of
  Just (t, []) -> Just t
  _            -> Nothing

pSer :: [String] -> Maybe (Term, [String])
pSer ("(" : name : rest)
  | name /= "(" && name /= ")" = do
      (args, rest') <- pSerArgs rest
      pure (F name args, rest')
pSer (tok : rest)
  | ('v' : ds) <- tok, not (null ds), all isDigit ds = Just (V (read ds), rest)
pSer _ = Nothing

pSerArgs :: [String] -> Maybe ([Term], [String])
pSerArgs (")" : rest) = Just ([], rest)
pSerArgs toks = do
  (a, r1)  <- pSer toks
  (as, r2) <- pSerArgs r1
  pure (a : as, r2)

-- A ledger block.  Line-oriented and self-delimiting so many entries can
-- share one file.
serializeCert :: SerialCert -> String
serializeCert sc = unlines $
  [ "BEGIN-CERT 1"
  , "LHS " ++ serTerm (scLhs sc)
  , "RHS " ++ serTerm (scRhs sc)
  , "DEFS " ++ show (length (scDefs sc))
  ]
  ++ [ "DEF " ++ defName d ++ " " ++ show (defArity d) ++ " " ++ serTerm (defBody d)
     | d <- scDefs sc ]
  ++ [ case scWitness sc of
         WRefl            -> "WITNESS refl"
         WInduction v stp -> "WITNESS induction " ++ show v ++ " " ++ stp
     , "END-CERT"
     ]

parseSerialCert :: String -> Maybe SerialCert
parseSerialCert = parseSerialFrom . lines

-- Parses the first BEGIN-CERT..END-CERT block in a line list.
parseSerialFrom :: [String] -> Maybe SerialCert
parseSerialFrom ls0 = do
  rest0            <- dropTo "BEGIN-CERT" ls0
  (lhsL, rest1)    <- takePrefixed "LHS " rest0
  lhs              <- parseSerTerm lhsL
  (rhsL, rest2)    <- takePrefixed "RHS " rest1
  rhs              <- parseSerTerm rhsL
  (defsN, rest3)   <- takePrefixed "DEFS " rest2
  n                <- readMaybeInt defsN
  (defs, rest4)    <- readDefs n rest3
  (witL, _)        <- takePrefixed "WITNESS " rest4
  w                <- parseWitness witL
  pure (SerialCert lhs rhs defs w)
  where
    dropTo pfx ls = case dropWhile (not . isPrefixOf pfx) ls of
      (_ : more) -> Just more
      []         -> Nothing
    takePrefixed pfx (l : more)
      | pfx `isPrefixOf` l = Just (drop (length pfx) l, more)
    takePrefixed _ _ = Nothing
    readDefs 0 ls = Just ([], ls)
    readDefs k ls = do
      (dl, more) <- takePrefixed "DEF " ls
      d          <- parseDefLine dl
      (ds, r)    <- readDefs (k - 1) more
      pure (d : ds, r)
    parseDefLine dl = case words dl of
      (nm : arS : bodyToks) -> do
        ar   <- readMaybeInt arS
        body <- parseSerTerm (unwords bodyToks)
        pure (Definition nm ar body)
      _ -> Nothing
    parseWitness w = case words w of
      ["refl"]                -> Just WRefl
      ("induction" : v : stp) -> do
        vi <- readMaybeInt v
        pure (WInduction vi (unwords stp))
      _ -> Nothing

readMaybeInt :: String -> Maybe Int
readMaybeInt s = case reads s of { [(n, "")] -> Just n ; _ -> Nothing }

-- Rebuild the exact Agda module the witness names.  No search: a witness is
-- reconstructed to one module, and that module is what agda re-checks.
reconstructModule :: SerialCert -> Maybe String
reconstructModule sc = case scWitness sc of
  WRefl            -> agdaCertificateWith (scDefs sc) eq
  WInduction v stp -> fst <$> agdaInductionCertificate (scDefs sc) eq v stp
  where eq = (scLhs sc, scRhs sc)

-- Discover the certificate: prove the equation once and RECORD which witness
-- agda accepted, so it never has to be searched for again.  Same search order
-- and same budget as `certify`; the only difference is the return value.
certifyCert :: [Definition] -> FilePath -> (Equation, String)
            -> IO (Either String SerialCert)
certifyCert defs root (eq, proofNote) =
  case agdaCertificateWith defs eq of
    Nothing -> pure (Left (untranslatableReason defs eq))
    Just reflSource -> do
      (code, out) <- runAgda root reflSource
      case code of
        ExitSuccess -> pure (Right (mkSerialCert defs eq WRefl))
        ExitFailure _ ->
          case inductionVariable proofNote of
            Nothing -> pure (Left (firstErrorLine out))
            Just v -> case inductionHypothesis eq v of
              Nothing -> pure (Left (firstErrorLine out))
              Just ih ->
                let ks = take kMaxCongArguments (mapMaybe agdaVar (equationVars eq))
                in tryShapes v (stepShapes ih ks) (firstErrorLine out)
  where
    tryShapes _ [] lastErr = pure (Left lastErr)
    tryShapes v ((_label, stp) : more) _ =
      case agdaInductionCertificate defs eq v stp of
        Nothing -> pure (Left "induction variable outside the equation")
        Just (source, baseLine) -> do
          (code, out) <- runAgda root source
          case code of
            ExitSuccess -> pure (Right (mkSerialCert defs eq (WInduction v stp)))
            ExitFailure _
              | blamedLine out == Just baseLine ->
                  pure (Left ("base clause: " ++ firstErrorLine out))
              | otherwise -> tryShapes v more (firstErrorLine out)

-- Replay a serialised certificate: reconstruct the module named by the
-- witness and re-check it with agda.  This is the operation that makes the
-- ledger re-checkable — it trusts the witness, never re-searches.
replayCert :: FilePath -> SerialCert -> IO (Either String ())
replayCert root sc = case reconstructModule sc of
  Nothing     -> pure (Left "witness does not reconstruct to a module")
  Just source -> do
    (code, out) <- runAgda root source
    case code of
      ExitSuccess   -> pure (Right ())
      ExitFailure _ -> pure (Left (firstErrorLine out))

-- ------------------------------------------------ reading library.txt
--
-- library.txt is written with the machine's infix `show`
-- (MathMachine.hs ~465): variables are x y z u v w / nⁱ, `0` and other
-- nullary symbols are bare, `+ * ^ gcd max` are infix `(a op b)`, and every
-- other symbol (`s`, `-`, `le`, invented concepts `c0`…) is prefix
-- `f(a,b,…)`.  This parser is the exact inverse of that `show`, so a line the
-- machine wrote parses back to the term it denotes.

-- Operators the machine renders infix (Show instance's list).  Order does
-- not matter here: their first characters are disjoint.
showInfixOps :: [String]
showInfixOps = ["gcd", "max", "+", "*", "^"]

parseShowTerm :: String -> Maybe Term
parseShowTerm s = case pShow (dropWhile isSpace s) of
  Just (t, rest) | all isSpace rest -> Just t
  _                                 -> Nothing

pShow :: String -> Maybe (Term, String)
pShow ('(' : rest0) = do            -- infix: ( term OP term )
  (a, r1)   <- pShow rest0
  (op, r2)  <- pShowOp (dropWhile isSpace r1)
  (b, r3)   <- pShow r2
  case dropWhile isSpace r3 of
    ')' : r4 -> Just (F op [a, b], r4)
    _        -> Nothing
pShow s = do                        -- atom, possibly prefix-applied
  (name, r1) <- pShowName (dropWhile isSpace s)
  case dropWhile isSpace r1 of
    '(' : r2 -> do
      (args, r3) <- pShowArgs r2
      pure (F name args, r3)
    r1' -> pure (atom name, r1')

pShowOp :: String -> Maybe (String, String)
pShowOp s = case [ (op, drop (length op) s) | op <- showInfixOps, op `isPrefixOf` s ] of
  (r : _) -> Just r
  []      -> Nothing

-- A prefix head / atom name: alphanumerics plus `_ #`, or a bare `-` (monus).
pShowName :: String -> Maybe (String, String)
pShowName ('-' : rest) = Just ("-", rest)
pShowName s = case span (\c -> isAlphaNum c || c == '_' || c == '#') s of
  ("", _)     -> Nothing
  (nm, rest)  -> Just (nm, rest)

pShowArgs :: String -> Maybe ([Term], String)
pShowArgs s = case dropWhile isSpace s of
  ')' : rest -> Just ([], rest)
  s'         -> do
    (a, r1) <- pShow s'
    case dropWhile isSpace r1 of
      ',' : r2 -> do (as, r3) <- pShowArgs r2; pure (a : as, r3)
      ')' : r2 -> Just ([a], r2)
      _        -> Nothing

-- A bare name is a variable if it is one of the six universe letters or the
-- machine's out-of-range spelling nⁱ; otherwise a nullary symbol like `0`.
atom :: String -> Term
atom nm
  | [c] <- nm, Just i <- lookup c (zip "xyzuvw" [0 ..]) = V i
  | ('n' : ds) <- nm, not (null ds), all isDigit ds     = V (read ds)
  | otherwise                                           = F nm []

-- One line of library.txt / library.snapshot.txt: "LHS = RHS [note]".  The
-- note is returned verbatim (including its brackets) for `inductionVariable`.
parseLibraryLine :: String -> Maybe (Equation, String)
parseLibraryLine line0
  | all isSpace line0 = Nothing
  | otherwise = do
      let (lhsS, afterEq) = breakOn '=' line0
      rhsAndNote <- afterEq
      let (rhsS, note) = splitNote rhsAndNote
      l <- parseShowTerm lhsS
      r <- parseShowTerm rhsS
      pure ((l, r), note)
  where
    breakOn c s = case break (== c) s of
      (a, _ : b) -> (a, Just b)
      (a, [])    -> (a, Nothing)
    -- Split trailing "[...]" note off the RHS.
    splitNote s = case break (== '[') s of
      (r, note@('[' : _)) -> (r, note)
      (r, note)           -> (r, note)

-- ------------------------------------------------------------- self-test
--
-- Runs the gate against the repository root, on MathMachine's own library
-- snapshot plus deliberate falsehoods.  This is not a measurement standing
-- in for a theorem: each line either produces a machine-checked Agda term
-- or it does not, and the run reports which.

zero_ :: Term
zero_ = F "0" []

su :: Term -> Term
su t = F "s" [t]

bin :: String -> Term -> Term -> Term
bin f a b = F f [a, b]

x_, y_, z_ :: Term
x_ = V 0
y_ = V 1
z_ = V 2

c0 :: Term -> Term
c0 t = F "c0" [t]

-- The concept MathMachine actually invents first, verbatim from its own
-- self-test: "collision-pattern=x+x primitive=c0/1" (MathMachine.hs ~2174).
selfTestDefs :: [Definition]
selfTestDefs = [ Definition "c0" 1 (bin "+" (V 0) (V 0)) ]

-- machine/library.snapshot.txt, transcribed exactly, in order.
snapshot :: [(String, Equation, String)]
snapshot =
  [ ("x = (0+x)", (x_, bin "+" zero_ x_), "[induction on x]")
  , ("s(x) = (s(0)+x)", (su x_, bin "+" (su zero_) x_), "[induction on x]")
  , ("(s(x)+y) = s((x+y))", (bin "+" (su x_) y_, su (bin "+" x_ y_)), "[induction on y]")
  , ("(x+y) = (y+x)", (bin "+" x_ y_, bin "+" y_ x_), "[induction on x]")
  , ("(x+(x+y)) = (y+(x+x))", (bin "+" x_ (bin "+" x_ y_), bin "+" y_ (bin "+" x_ x_)), "[induction on y]")
  , ("(x+(y+y)) = (y+(x+y))", (bin "+" x_ (bin "+" y_ y_), bin "+" y_ (bin "+" x_ y_)), "[induction on x]")
  , ("(x+(y+z)) = (y+(x+z))", (bin "+" x_ (bin "+" y_ z_), bin "+" y_ (bin "+" x_ z_)), "[induction on x]")
  , ("0 = (0*x)", (zero_, bin "*" zero_ x_), "[induction on x]")
  , ("x = (s(0)*x)", (x_, bin "*" (su zero_) x_), "[induction on x]")
  , ("(s(x)*y) = (y+(x*y))", (bin "*" (su x_) y_, bin "+" y_ (bin "*" x_ y_)), "[induction on y]")
  , ("(s(x)*y) = (y+(y*x))", (bin "*" (su x_) y_, bin "+" y_ (bin "*" y_ x_)), "[induction on x]")
  , ("(x*(x*y)) = (x*(y*x))", (bin "*" x_ (bin "*" x_ y_), bin "*" x_ (bin "*" y_ x_)), "[induction on x]")
  , ("(x*(y*z)) = (x*(z*y))", (bin "*" x_ (bin "*" y_ z_), bin "*" x_ (bin "*" z_ y_)), "[induction on y]")
  , ("s((x*c0(x))) = s((c0(x)*x))", (su (bin "*" x_ (c0 x_)), su (bin "*" (c0 x_) x_)), "[induction on x]")
  , ("s((x*c0(y))) = s((c0(y)*x))", (su (bin "*" x_ (c0 y_)), su (bin "*" (c0 y_) x_)), "[induction on x]")
  , ("s(s((x*y))) = s(s((y*x)))", (su (su (bin "*" x_ y_)), su (su (bin "*" y_ x_))), "[induction on x]")
  , ("(x*y) = (y*x)", (bin "*" x_ y_, bin "*" y_ x_), "[induction on x]")
  , ("x = (xmaxx)", (x_, bin "max" x_ x_), "[induction on x]")
  , ("s(x) = (xmaxs(x))", (su x_, bin "max" x_ (su x_)), "[induction on x]")
  , ("s(x) = (s(x)maxx)", (su x_, bin "max" (su x_) x_), "[induction on x]")
  , ("(xmaxs(0)) = (s(0)maxx)", (bin "max" x_ (su zero_), bin "max" (su zero_) x_), "[induction on x]")
  , ("0 = -(x,x)", (zero_, bin "-" x_ x_), "[induction on x]")
  , ("0 = -(x,s(x))", (zero_, bin "-" x_ (su x_)), "[induction on x]")
  , ("s(0) = -(s(x),x)", (su zero_, bin "-" (su x_) x_), "[induction on x]")
  , ("0 = le(s(x),x)", (zero_, bin "le" (su x_) x_), "[induction on x]")
  , ("s(0) = le(x,x)", (su zero_, bin "le" x_ x_), "[induction on x]")
  , ("s(0) = le(x,s(x))", (su zero_, bin "le" x_ (su x_)), "[induction on x]")
  , ("le(x,0) = -(s(0),x)", (bin "le" x_ zero_, bin "-" (su zero_) x_), "[induction on x]")
  ]

-- Equations that are FALSE.  A gate that admits any of these is worthless,
-- so they are checked with the same code path and the same budget.
falsehoods :: [(String, Equation, String)]
falsehoods =
  [ ("s(x) = x  [FALSE]", (su x_, x_), "[induction on x]")
  , ("(x+y) = (x*y)  [FALSE]", (bin "+" x_ y_, bin "*" x_ y_), "[induction on x]")
  , ("x = le(x,x)  [FALSE]", (x_, bin "le" x_ x_), "[induction on x]")
  , ("(xmaxy) = (x+y)  [FALSE]", (bin "max" x_ y_, bin "+" x_ y_), "[induction on x]")
  ]

-- Not in the snapshot: exercises the gcd import path, which no snapshot
-- line reaches and which is the one symbol translated to a cubical
-- definition that does not reduce structurally.
extras :: [(String, Equation, String)]
extras =
  [ ("gcd(x,0) = x", (bin "gcd" x_ zero_, x_), "[induction on x]")
  ]

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetBuffering stdout LineBuffering
  argv <- getArgs
  let root = case argv of { (p : _) -> p ; [] -> "." }
  printf "Certificate self-test (repository root %s).\n" (show root)
  printf "budget = %d agda calls per candidate.\n\n" kMaxAgdaCalls
  putStrLn "== machine/library.snapshot.txt =="
  trues <- mapM (report root) snapshot
  putStrLn ""
  putStrLn "== beyond the snapshot =="
  _ <- mapM (report root) extras
  putStrLn ""
  putStrLn "== deliberate falsehoods (must all be rejected) =="
  falses <- mapM (report root) falsehoods
  putStrLn ""
  let ok = length [ () | Certified _ _ <- trues ]
      skipped = length [ () | Untranslatable _ <- trues ]
      worst = maximum (0 : map spent (trues ++ falses))
      admitted = [ () | Certified _ _ <- falses ]
  printf "snapshot: %d/%d certified, %d rejected, %d untranslatable\n"
    ok (length snapshot) (length snapshot - ok - skipped) skipped
  printf "worst-case agda invocations observed: %d (bound %d)\n" worst kMaxAgdaCalls
  if null admitted
    then do
      printf "falsehoods: %d/%d rejected\n" (length falses) (length falses)
      putStrLn "CERTIFICATE GATE CHECKED"
      exitSuccess
    else do
      putStrLn "UNSOUND: a false equation was certified"
      exitFailure
  where
    spent (Certified _ n) = n
    spent (Rejected _ n) = n
    spent (Untranslatable _) = 0
    report root (label, eq, note) = do
      v <- certifyWith selfTestDefs root (eq, note)
      case v of
        Certified how n ->
          printf "  OK    %-26s %-52s (%d call%s)\n" label how n (plural n)
        Rejected err n ->
          printf "  NO    %-26s %-52s (%d call%s)\n" label (clip err) n (plural n)
        Untranslatable why ->
          printf "  SKIP  %-24s %s\n" label why
      pure v
    plural (1 :: Int) = ""
    plural _ = "s"
    clip s = let t = intercalate " " (words s)
             in if length t > 52 then take 49 t ++ "..." else t
