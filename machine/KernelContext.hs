-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- KernelContext — handing the Agda kernel the machine's own lemmas, as
-- DEFINITIONS.
--
-- ===================================================================
-- WHAT THIS IS FOR
--
-- `notes/THE_SEAM_ASKS_THE_WRONG_NAYA.md` (2026-08-18) measures the defect
-- this module is the missing organ for.  In 239 recorded rounds the machine
-- harvested 1696 residuals — the subgoals agda's kernel stalled at — and not
-- one of them ever became a theorem.  The cause is not the descent and not
-- the ascent, both of which work; it is that there are two rule sets and
-- nothing carries anything between them:
--
--   * `MathMachine.lemmaRules` (MathMachine.hs:2742) installs every proved
--     equation into the REWRITER's rule set, in both directions;
--   * the KERNEL is handed a fresh module per candidate that imports
--     `Cubical.Data.Nat` and knows nothing else.  `REWRITE` occurs 0 times
--     in MathMachine.hs and cannot occur: `{-# REWRITE #-}` needs
--     `--rewriting` and the lane is `--safe`.
--
-- So `(x+y) = (y+x)` appears on a KERNEL-ACCEPT line 56 separate times, and
-- `x = (x+0)` is demanded as a residual 27 times and submitted to the kernel
-- zero times.  Every lemma the machine learns widens the gap.
--
-- The repair the note states but does not take: the kernel cannot receive a
-- lemma as a REDUCTION RULE, but it can receive it as a DEFINITION, which
-- `--safe` permits without qualification.  A checked
--
--     plusZero : (x : ℕ) → x ≡ (x + zero)
--     plusZero zero = refl
--     plusZero (suc x) = (cong (λ y → (suc y)) (plusZero x))
--
-- earlier in the same module puts the name `plusZero` in scope for
-- everything after it, and a later obligation may discharge itself by
-- invoking that name.  That is the whole of this file.  What it costs is an
-- extended proof vocabulary: `Certificate` emits exactly one theorem per
-- module, named `candidate`, with a proof drawn from seven fixed strings
-- (`Certificate.stepShapes`), none of which can mention another theorem.
--
-- WHAT THIS FILE IS NOT.  It is not a prover.  It renders proofs it is
-- given; the kernel decides.  It contains no search, no heuristic and no
-- measured constant.  Every function below is total on its stated domain
-- and every rejection is a named constructor of `Refusal`, never a `Bool`.
--
-- ===================================================================
-- WHAT CAN AND CANNOT BE RENDERED — read this before believing an emission
--
-- The machine records how a theorem was established as a `Pramana.Naya`,
-- written into `machine/library.terms` as the `naya=` field and onto every
-- KERNEL-ACCEPT line of `machine/machine.log`.  Over the committed log those
-- notes are, exhaustively (a count of a finite file, not a measurement):
--
--     induction on x, step = refl        566      refl                50
--     induction on x, step = ih          490      induction on y, …   12
--     induction on x, step = cong suc    305      trace replay       678
--
-- CAN be re-expressed in Agda by `proofOfNaya`:
--
--   refl                          → PRefl
--   induction on V, step = refl   → PInduction v PRefl PRefl
--   induction on V, step = ih     → PInduction v PRefl PIh
--   induction on V, step = cong suc         → PInduction v PRefl (PCong …)
--   induction on V, step = cong (_+ k) etc. → PInduction v PRefl (PCong …)
--
-- That is every shape `Certificate.stepShapes` can emit, so any theorem the
-- present gate accepted with a recorded step can be re-rendered as a named
-- definition here.  (The four `cong`-section shapes are supported although
-- they occur 0 times in the committed log; they are in `stepShapes`, so
-- refusing them would be a gap that only looks closed.)
--
-- CANNOT, and each is refused by name rather than approximated:
--
--   * `trace replay` (678 of 1886 acceptances, the plurality).  The note
--     records only THAT the engine replayed its own rewrite trace; the
--     trace is not in `library.terms` and the reconstructed proof term is
--     not either.  There is nothing here to render.  → `NoTacticRecorded`.
--     This is not a small residue: it includes `(x+y) = (y+x)`, the theorem
--     the log shows re-proved 56 times.  Re-rendering those needs the
--     TRACE, which means a serialiser on `TraceReplay`'s output, which is a
--     separate change in a file this module does not touch.
--   * `induction on x` with no step recorded (262 lines) → the same.
--   * A legacy two-field `library.terms` line carries no naya at all
--     (92 committed lines) → the same.
--   * NESTED INDUCTION.  A `PInduction` inside another proof is refused
--     (`NestedInduction`).  Agda splits a clause at the top level; an inner
--     induction needs a separate top-level helper (or a `mutual`/`where`
--     block), and inventing that helper is a decision about the proof, not
--     a rendering of it.  A caller that wants nested induction must supply
--     the helper AS ITS OWN `Lemma` and cite it — which this module does
--     support, and which is the honest shape of the thing anyway.
--   * REWRITING DERIVATIONS.  `MathMachine.provedByRewriting` closes a goal
--     by a sequence of rewrites at arbitrary positions under arbitrary
--     matching substitutions.  `PCong` + `PTrans` + `PSym` + `PCite` is
--     exactly enough to express one such derivation IF the caller supplies
--     the position (as a one-hole context) and the instance (as the cited
--     lemma's arguments).  This module cannot extract those from the
--     rewriter, because the rewriter does not record them; it can only
--     render them once something else does.  Stated so that "the proof
--     language is expressive enough" is not mistaken for "the wire exists".
--
-- ===================================================================
-- THE THREE VERDICTS ARE THREE, NOT TWO
--
-- `Obstruction`'s header records that a boolean verdict was collapsing
-- distinct positions and that `Unparsed` was a bad reinvention of
-- *avaktavyam* — the fourth position of the Jain saptabhaṅgī (Samantabhadra,
-- *Āptamīmāṃsā*; Akalaṅka, *Laghīyastraya*), which is what arises when two
-- standpoints are asserted simultaneously rather than in succession.  The
-- same three-way distinction is load-bearing here and is carried in the
-- types, so no caller can flatten it:
--
--   `Left refusal`             — THIS MODULE could not express it.  Says
--                                nothing whatever about the mathematics.
--   `Right src`, agda exit ≠ 0 — the kernel examined a module and refused.
--                                A fact about agda, reported with its text.
--   `Right src`, agda exit = 0 — a checked term.
--
-- Reporting the first as the second is the error that produced 1696 dead
-- residuals; reporting either as "unproved" is how it stayed invisible.
--
-- ===================================================================
-- NOT `module Main`.  `Certify.hs` and three siblings were written as
-- `module Main` and are consequently un-importable, which is why the seams
-- meant to consume them were never connected.  This one is importable from
-- the day it lands, it does not touch `MathMachine.hs`, and `selfTest` runs
-- against verbatim lines of `machine/library.terms` and `machine/machine.log`
-- rather than against invented ones.

module KernelContext
  ( -- * terms — the shape MathMachine, Obstruction and Certificate share
    Term(..)
  , Equation
  , showPrefixTerm
  , parsePrefixTerm
  , varsOfT
  , symbolsOfT
  , equationVarsT
  , toCertTerm
  , fromCertTerm
    -- * invented concepts
  , Def(..)
  , toCertDef
    -- * the proof language
  , Proof(..)
  , holeFor
  , Lemma(..)
  , Context(..)
    -- * rendering
  , Refusal(..)
  , showRefusal
  , renderContext
  , renderLemma
    -- * the machine's own records
  , LibEntry(..)
  , libraryEntries
  , proofOfNaya
  , lemmaFromEntry
  , tacticVocabulary
  , Coverage(..)
  , coverage
  , coverageReport
    -- * the demonstration, built from real library.terms lines
  , sampleLibraryLines
  , sampleAcceptLines
  , flagshipContext
  , commContext
  , falseContext
    -- * asking the kernel
  , checkContextIn
  , checkContext
  , findRepoRoot
    -- * checked in-process
  , selfTest
  , selfTestPure
  , selfTestKernel
  ) where

import Control.Exception (SomeException, finally, try)
import Control.Monad (unless)
import Data.Char (isAlphaNum, isDigit, isSpace)
import Data.List (intercalate, isPrefixOf, nub, sort)
import Data.Maybe (mapMaybe)
import System.Directory (doesDirectoryExist, getTemporaryDirectory, removePathForcibly)
import System.Environment (getEnvironment)
import System.Exit (ExitCode(..))
import System.FilePath ((</>))
import System.IO (IOMode(WriteMode), hPutStr, hSetEncoding, stderr, stdout, utf8, withFile)
import System.Process
  (CreateProcess(..), proc, readCreateProcessWithExitCode, readProcess)
import System.Timeout (timeout)

import qualified Certificate as C
import qualified Obstruction as O
import qualified Pramana as P

-- ------------------------------------------------------------------ terms
--
-- Structurally identical to MathMachine.Term, as in the seven other modules
-- that each redefine it.  The duplication is a real defect of this codebase
-- and introducing a shared core is a separate change; what this module owes
-- the reader is the two adapters, which are total and obviously inverse.

data Term = V !Int | F !String [Term] deriving (Eq, Ord)

-- `show` is MathMachine's `showTermP` (MathMachine.hs:549), the fully
-- prefix notation `machine/library.terms` is written in — NOT MathMachine's
-- `Show` instance (which is infix for + * ^ gcd max) and NOT Obstruction's
-- (infix for six symbols).  Three notations for one type is what the
-- codebase has; this module commits to the one its input file uses, and
-- `parsePrefixTerm` is its exact inverse (checked in `selfTest`).
instance Show Term where
  show = showPrefixTerm

type Equation = (Term, Term)

showPrefixTerm :: Term -> String
showPrefixTerm (V i)
  | i >= 0 && i < 6 = [ "xyzuvw" !! i ]
  | otherwise       = "v" ++ show i
showPrefixTerm (F n []) = n
showPrefixTerm (F n ts) =
  n ++ "(" ++ intercalate "," (map showPrefixTerm ts) ++ ")"

-- The inverse.  MathMachine's own reader for this format is `parseTerm`,
-- which lives inside `module Main (main)` and is therefore unreachable;
-- this is the smallest honest re-derivation of it from `showTermP`'s three
-- clauses, and `selfTest` checks the round trip on the committed file's
-- own lines rather than on examples chosen to succeed.
parsePrefixTerm :: String -> Maybe Term
parsePrefixTerm s = case pTerm (dropWhile isSpace s) of
  Just (t, rest) | all isSpace rest -> Just t
  _ -> Nothing

pTerm :: String -> Maybe (Term, String)
pTerm s0 = do
  (nm, r1) <- pName (dropWhile isSpace s0)
  case dropWhile isSpace r1 of
    '(' : r2 -> do
      (as, r3) <- pArgs r2
      pure (F nm as, r3)
    r1' -> pure (atom nm, r1')

-- A head is either one of the machine's single-character operators or an
-- alphanumeric name (`0`, `s`, `le`, `max`, `gcd`, an invented `c0`, the
-- eigenconstant `#`).
pName :: String -> Maybe (String, String)
pName (c : cs) | c `elem` "+*-^/" = Just ([c], cs)
pName s = case span (\c -> isAlphaNum c || c == '_' || c == '#') s of
  ("", _)  -> Nothing
  (nm, r)  -> Just (nm, r)

pArgs :: String -> Maybe ([Term], String)
pArgs s = case dropWhile isSpace s of
  ')' : r -> Just ([], r)
  s'      -> do
    (a, r1) <- pTerm s'
    case dropWhile isSpace r1 of
      ',' : r2 -> do (as, r3) <- pArgs r2; pure (a : as, r3)
      ')' : r2 -> Just ([a], r2)
      _        -> Nothing

-- A bare name is a variable if it is one of the six universe letters or the
-- out-of-range spelling `v`ⁱ that `showTermP` emits; `n`ⁱ is accepted too
-- because MathMachine's `Show` spells the same thing that way and log lines
-- reach this parser as well.  Everything else is a nullary symbol.
atom :: String -> Term
atom nm
  | [c] <- nm, Just i <- lookup c (zip "xyzuvw" [0 ..]) = V i
  | (p : ds) <- nm, p `elem` "vn", not (null ds), all isDigit ds = V (read ds)
  | otherwise = F nm []

varsOfT :: Term -> [Int]
varsOfT (V i) = [i]
varsOfT (F _ ts) = concatMap varsOfT ts

symbolsOfT :: Term -> [String]
symbolsOfT (V _) = []
symbolsOfT (F f ts) = f : concatMap symbolsOfT ts

equationVarsT :: Equation -> [Int]
equationVarsT (l, r) = sort (nub (varsOfT l ++ varsOfT r))

toCertTerm :: Term -> C.Term
toCertTerm (V i) = C.V i
toCertTerm (F f ts) = C.F f (map toCertTerm ts)

fromCertTerm :: C.Term -> Term
fromCertTerm (C.V i) = V i
fromCertTerm (C.F f ts) = F f (map fromCertTerm ts)

-- A concept the machine named for itself, in this module's Term.  Mirrors
-- `Certificate.Definition` so callers never have to build a second Term.
data Def = Def
  { defName' :: String
  , defArity' :: Int
  , defBody' :: Term
  } deriving (Eq, Show)

toCertDef :: Def -> C.Definition
toCertDef d = C.Definition (defName' d) (defArity' d) (toCertTerm (defBody' d))

-- ------------------------------------------------------- the proof language
--
-- Closed constructors, deliberately.  `Certificate.agdaInductionCertificate`
-- takes its step as a `String` and splices it into the module; that is safe
-- there only because the caller draws it from `stepShapes`.  This module
-- reads proof shapes out of `machine/library.terms`, a file on disk, so
-- nothing that reaches an emitted module may be a caller-supplied string
-- except a NAME, and every name is put through `Certificate.validAgdaIdent`
-- (the guard `notes/TRUTH_GATE_AUDIT.md` §1 installed) plus the extra
-- reserved list below.
data Proof
  = PRefl
    -- ^ `refl`: the kernel closes it by computation alone.
  | PIh
    -- ^ the induction hypothesis; legal only inside `PInduction`'s step.
  | PCite String [Term]
    -- ^ a lemma DEFINED EARLIER IN THIS MODULE, applied to explicit
    --   arguments.  This is the constructor the whole file exists for.
  | PSym Proof
    -- ^ `sym`
  | PTrans Proof Proof
    -- ^ `_∙_`, cubical's path composition
  | PCong Term Proof
    -- ^ `cong (λ h → ctx) p`, a rewrite at a position.  The hole is the
    --   unique variable of `ctx` that is NOT a variable of the lemma being
    --   proved; `holeFor` picks a canonical one.  Zero such variables is
    --   `HoleMissing`, two or more is `AmbiguousHole` — neither is guessed.
  | PInduction Int Proof Proof
    -- ^ structural induction on `V i`: base clause, then step clause.
    --   `Certificate` hardwires the base to `refl`; this does not, because
    --   a base that is not `refl` is exactly a case the present gate cannot
    --   reach.  Only legal at the top of a lemma's proof.
  deriving (Eq, Show)

-- The canonical hole index for a context over this equation: the least of
-- the six spellable variables that the equation does not already use.
-- `Nothing` when the equation uses all six, in which case no `cong` context
-- can be written and the caller must say so rather than shadow a variable.
holeFor :: Equation -> Maybe Int
holeFor eq = case [ i | i <- [0 .. 5], i `notElem` equationVarsT eq ] of
  (h : _) -> Just h
  []      -> Nothing

-- One named obligation.  The goal is a `Lemma` too — it differs from the
-- others only in standing last, which is what puts every other name in
-- scope for it.
data Lemma = Lemma
  { lemName :: String
  , lemEq :: Equation
  , lemProof :: Proof
  } deriving (Eq, Show)

data Context = Context
  { ctxModule :: String    -- ^ must equal the emitted file's base name
  , ctxDefs :: [Def]       -- ^ invented concepts, as in Certificate
  , ctxLemmas :: [Lemma]   -- ^ in order; each may cite any earlier one
  , ctxGoal :: Lemma
  } deriving (Eq, Show)

-- ------------------------------------------------------------- refusals

data Refusal
  = OutsideFragment String Term
    -- ^ in this lemma, this term is outside the translatable fragment
    --   (a variable beyond the six, or a symbol with no Agda meaning).
  | BadName String
  | DuplicateName String
  | UnknownLemma String String        -- ^ in lemma, cited name not in scope
  | SelfCitation String
  | ArityMismatch String String Int Int  -- ^ lemma, cited, expected, given
  | VarNotInScope String Int          -- ^ in lemma, this variable is not bound
  | IhOutsideInduction String
  | NestedInduction String
  | InductionVarAbsent String Int
  | HoleMissing String Term
  | AmbiguousHole String Term
  | NoTacticRecorded String
    -- ^ the machine's own note names no proof term this module can render.
  | PreambleShapeChanged
    -- ^ `Certificate.preambleWith` no longer emits the module line this
    --   module rewrites.  Fail loudly rather than emit a module whose name
    --   does not match its file.
  deriving (Eq, Show)

showRefusal :: Refusal -> String
showRefusal r = case r of
  OutsideFragment l t -> l ++ ": outside the fragment: " ++ show t
  BadName n -> "unusable Agda name: " ++ show n
  DuplicateName n -> "name defined twice: " ++ n
  UnknownLemma l n -> l ++ ": cites " ++ n ++ ", which is not in scope"
  SelfCitation l -> l ++ ": cites itself (use PIh; a non-structural "
                      ++ "self-call would fail termination checking)"
  ArityMismatch l n want got ->
    l ++ ": cites " ++ n ++ " at " ++ show got ++ " arguments, needs " ++ show want
  VarNotInScope l i -> l ++ ": variable " ++ showPrefixTerm (V i) ++ " is not bound here"
  IhOutsideInduction l -> l ++ ": PIh outside an induction step"
  NestedInduction l -> l ++ ": nested PInduction (lift it to its own Lemma)"
  InductionVarAbsent l i ->
    l ++ ": induction on " ++ showPrefixTerm (V i) ++ ", which the equation does not mention"
  HoleMissing l t -> l ++ ": cong context with no hole: " ++ show t
  AmbiguousHole l t -> l ++ ": cong context with more than one hole: " ++ show t
  NoTacticRecorded s -> "no renderable proof recorded: " ++ show s
  PreambleShapeChanged -> "Certificate.preambleWith changed shape"

-- Names that must not be a lemma's, on top of `Certificate.agdaReserved`.
-- The six universe letters are here because a lemma named `x` would be
-- shadowed by the very telescope that binds `x` in every other lemma; the
-- rest are the names this module and `Certificate.preambleCore` put into
-- scope themselves.
kReservedHere :: [String]
kReservedHere =
  [ "x", "y", "z", "u", "v", "w"
  , "zero", "suc", "refl", "sym", "cong", "max", "le", "gcd"
  , "candidate"
  ]

usableName :: String -> Bool
usableName n = C.validAgdaIdent n && n `notElem` kReservedHere

-- ------------------------------------------------------------- rendering

data Env = Env
  { envDefs :: [C.Definition]
  , envScope :: [(String, Int)]   -- ^ lemma names already defined, with arity
  , envSelf :: String
  , envVars :: [Int]              -- ^ this lemma's telescope, as indices
  , envNames :: [String]          -- ^ the same, as Agda names
  , envInStep :: Bool
  }

-- The whole module.  Lemmas in order, then the goal, all sharing one
-- preamble (so `max`/`le`/`gcd` are transcribed once) and one scope.
renderContext :: Context -> Either Refusal String
renderContext ctx = do
  unless (usableName (ctxModule ctx)) $ Left (BadName (ctxModule ctx))
  mapM_ (\d -> unless (C.validAgdaIdent (defName' d)) (Left (BadName (defName' d))))
        (ctxDefs ctx)
  let lemmas = ctxLemmas ctx ++ [ctxGoal ctx]
      names = map lemName lemmas
      cdefs = map toCertDef (ctxDefs ctx)
  mapM_ (\n -> unless (usableName n) (Left (BadName n))) names
  mapM_ (\n -> unless (length (filter (== n) (names ++ map defName' (ctxDefs ctx))) == 1)
                      (Left (DuplicateName n)))
        names
  pre <- retitle (ctxModule ctx) (C.preambleWith cdefs (allSymbols ctx))
  bodies <- goLemmas cdefs [] lemmas
  pure (unlines (pre ++ concat bodies))
  where
    goLemmas _ _ [] = Right []
    goLemmas cdefs scope (l : ls) = do
      body <- renderLemma cdefs scope l
      rest <- goLemmas cdefs (scope ++ [(lemName l, length (equationVarsT (lemEq l)))]) ls
      pure (body : rest)

-- `Certificate.preambleCore` hardwires `module Candidate where`, because it
-- is written for the one-theorem candidate file.  A context module has to
-- be named after the file it is written to, so the line is rewritten — and
-- if it is not found, that is a refusal, not a silently misnamed module.
retitle :: String -> [String] -> Either Refusal [String]
retitle m ls
  | any (== marker) ls = Right (map swap ls)
  | otherwise = Left PreambleShapeChanged
  where
    marker = "module Candidate where"
    swap l = if l == marker then "module " ++ m ++ " where" else l

allSymbols :: Context -> [String]
allSymbols ctx = nub (concatMap ofLemma (ctxLemmas ctx ++ [ctxGoal ctx]))
  where
    ofLemma l = let (a, b) = lemEq l
                in symbolsOfT a ++ symbolsOfT b ++ ofProof (lemProof l)
    ofProof p = case p of
      PRefl -> []
      PIh -> []
      PCite _ as -> concatMap symbolsOfT as
      PSym q -> ofProof q
      PTrans q r -> ofProof q ++ ofProof r
      PCong c q -> symbolsOfT c ++ ofProof q
      PInduction _ b s -> ofProof b ++ ofProof s

-- One lemma: its signature and its clauses.
renderLemma :: [C.Definition] -> [(String, Int)] -> Lemma -> Either Refusal [String]
renderLemma cdefs scope l = do
  let eq@(lhs, rhs) = lemEq l
      vs = equationVarsT eq
      nm = lemName l
  names <- mapM (varName nm) vs
  lhsS <- rendTerm cdefs nm lhs
  rhsS <- rendTerm cdefs nm rhs
  let sig = nm ++ " : " ++ telescope names ++ lhsS ++ " ≡ " ++ rhsS
      env inStep = Env { envDefs = cdefs, envScope = scope, envSelf = nm
                       , envVars = vs, envNames = names, envInStep = inStep }
  case lemProof l of
    PInduction i base step -> do
      unless (i `elem` vs) $ Left (InductionVarAbsent nm i)
      iName <- varName nm i
      baseS <- renderProof (env False) base
      stepS <- renderProof (env True) step
      let pat u = unwords [ if j == i then u else n | (j, n) <- zip vs names ]
      pure [ sig
           , unwords [nm, pat "zero"] ++ " = " ++ baseS
           , unwords [nm, pat ("(suc " ++ iName ++ ")")] ++ " = " ++ stepS
           ]
    p -> do
      body <- renderProof (env False) p
      pure [sig, unwords (nm : names) ++ " = " ++ body]

telescope :: [String] -> String
telescope [] = ""
telescope ns = "(" ++ unwords ns ++ " : ℕ) → "

varName :: String -> Int -> Either Refusal String
varName nm i = maybe (Left (OutsideFragment nm (V i))) Right (C.agdaVar i)

rendTerm :: [C.Definition] -> String -> Term -> Either Refusal String
rendTerm cdefs nm t =
  maybe (Left (OutsideFragment nm t)) Right (C.agdaTermWith cdefs (toCertTerm t))

renderProof :: Env -> Proof -> Either Refusal String
renderProof env p0 = case p0 of
  PRefl -> Right "refl"

  PIh
    | not (envInStep env) -> Left (IhOutsideInduction (envSelf env))
    | otherwise -> Right (app (envSelf env) (envNames env))
      -- The recursive call is at the pattern-bound predecessor, which is
      -- spelled with the SAME letter: inside `f (suc x) = …`, `x` is the
      -- smaller one, so `f x …` is structural and agda's termination
      -- checker accepts it.  A caller writing `V i` for the induction
      -- variable inside a step means the predecessor, for the same reason.

  PCite nm args
    | nm == envSelf env -> Left (SelfCitation (envSelf env))
    | otherwise -> case lookup nm (envScope env) of
        Nothing -> Left (UnknownLemma (envSelf env) nm)
        Just ar
          | ar /= length args ->
              Left (ArityMismatch (envSelf env) nm ar (length args))
          | otherwise -> do
              mapM_ (checkVars env) args
              as <- mapM (rendTerm (envDefs env) (envSelf env)) args
              pure (app nm as)

  PSym q -> do
    s <- renderProof env q
    pure ("(sym " ++ s ++ ")")

  PTrans q r -> do
    a <- renderProof env q
    b <- renderProof env r
    pure ("(" ++ a ++ " ∙ " ++ b ++ ")")

  PCong ctx q -> do
    let extras = [ i | i <- nub (varsOfT ctx), i `notElem` envVars env ]
    hole <- case extras of
      [h] -> Right h
      []  -> Left (HoleMissing (envSelf env) ctx)
      _   -> Left (AmbiguousHole (envSelf env) ctx)
    hName <- varName (envSelf env) hole
    ctxS <- rendTerm (envDefs env) (envSelf env) ctx
    s <- renderProof env q
    pure ("(cong (λ " ++ hName ++ " → " ++ ctxS ++ ") " ++ s ++ ")")

  PInduction {} -> Left (NestedInduction (envSelf env))
  where
    app nm [] = nm
    app nm as = "(" ++ unwords (nm : as) ++ ")"

-- Every variable of a cited instance must be one the lemma binds.  Without
-- this the refusal arrives from agda as a scope error about a module this
-- file emitted, which is the confusion the header refuses to allow.
checkVars :: Env -> Term -> Either Refusal ()
checkVars env t =
  mapM_ (\i -> unless (i `elem` envVars env) (Left (VarNotInScope (envSelf env) i)))
        (nub (varsOfT t))

-- ------------------------------------------- the machine's own records

data LibEntry = LibEntry
  { leEq :: Equation
  , leJust :: Maybe P.Justification
  } deriving (Eq, Show)

-- `machine/library.terms`, read with the machine's own record reader
-- (`Pramana.parseRecord`, which is parametric in the term type precisely so
-- that it adds no ninth Term) and this module's inverse of `showTermP`.
libraryEntries :: String -> [LibEntry]
libraryEntries = mapMaybe entry . lines
  where
    entry ln = do
      rec' <- P.parseRecord parsePrefixTerm ln
      pure (LibEntry (P.mrLhs rec', P.mrRhs rec') (P.mrJust rec'))

-- The translation of a recorded standpoint into a renderable proof, or a
-- named refusal.  See the header table for what is and is not covered.
proofOfNaya :: Equation -> P.Naya -> Either Refusal Proof
proofOfNaya _ P.NRefl = Right PRefl
proofOfNaya eq (P.NInduction c mstep) = do
  i <- maybe (Left (NoTacticRecorded ("induction on " ++ [c]))) Right
             (lookup c (zip "xyzuvw" [0 ..]))
  step <- case mstep of
    Nothing -> Left (NoTacticRecorded ("induction on " ++ [c] ++ ", no step recorded"))
    Just s  -> stepProof eq s
  pure (PInduction i PRefl step)
  -- The base is `refl` because that is what `Certificate.agdaInductionCertificate`
  -- hardwires: an accepted line's base clause WAS `refl`, or the gate could
  -- not have accepted it.  Reconstructing an acceptance therefore fixes the
  -- base; `PInduction` itself does not.
proofOfNaya _ P.NTraceReplay = Left (NoTacticRecorded "trace replay")
proofOfNaya _ P.NRewriter = Left (NoTacticRecorded "rewriter")
proofOfNaya _ (P.NOther s) = Left (NoTacticRecorded s)

-- Exactly the shapes `Certificate.stepShapes` can emit, and nothing else.
-- The cache marker the gate sometimes prepends ("cached, …") is stripped,
-- as `MathMachine.nayaOfShape` does.
stepProof :: Equation -> String -> Either Refusal Proof
stepProof eq s0 = case trim (dropCached s0) of
  "refl" -> Right PRefl
  "ih" -> Right PIh
  "cong suc" -> withHole (\h -> PCong (F "s" [V h]) PIh)
  s | Just (op, side, k) <- section s ->
        case lookup k (zip "xyzuvw" [0 ..]) of
          Nothing -> Left (NoTacticRecorded s0)
          Just ki -> withHole (\h -> PCong (F op (if side then [V h, V ki]
                                                          else [V ki, V h])) PIh)
  _ -> Left (NoTacticRecorded s0)
  where
    withHole f = maybe (Left (NoTacticRecorded s0)) (Right . f) (holeFor eq)
    dropCached s = if "cached," `isPrefixOf` s then drop 7 s else s
    trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse
    -- "cong (_+ k)" / "cong (k +_)" / "cong (_· k)" / "cong (k ·_)"
    section s = case s of
      'c':'o':'n':'g':' ':'(':rest -> case rest of
        '_' : o : ' ' : k : ")" | Just op <- opOf o -> Just (op, True, k)
        k : ' ' : o : '_' : ")" | Just op <- opOf o -> Just (op, False, k)
        _ -> Nothing
      _ -> Nothing
    opOf '+' = Just "+"
    opOf '·' = Just "*"
    opOf _ = Nothing

lemmaFromEntry :: String -> LibEntry -> Either Refusal Lemma
lemmaFromEntry nm e = case leJust e of
  Nothing -> Left (NoTacticRecorded "legacy two-field line: no justification")
  Just j -> do
    unless (usableName nm) $ Left (BadName nm)
    p <- proofOfNaya (leEq e) (P.jNaya j)
    pure (Lemma nm (leEq e) p)

-- The scope statement, as data rather than as prose in a comment, so a
-- caller can print it and a test can check it against `proofOfNaya`.
tacticVocabulary :: [(String, Bool)]
tacticVocabulary =
  [ ("refl", True)
  , ("induction on x, step = refl", True)
  , ("induction on x, step = ih", True)
  , ("induction on x, step = cong suc", True)
  , ("induction on x, step = cong (_+ y)", True)
  , ("induction on x, step = cong (y +_)", True)
  , ("induction on x, step = cong (_· y)", True)
  , ("induction on x, step = cong (y ·_)", True)
  , ("induction on x", False)
  , ("trace replay", False)
  , ("rewriter", False)
  ]

data Coverage = Coverage
  { covRenderable :: [(Equation, Proof)]
  , covRefused :: [(Equation, Refusal)]
  } deriving (Eq, Show)

coverage :: [LibEntry] -> Coverage
coverage es = Coverage [ (q, p) | (q, Right p) <- xs ] [ (q, r) | (q, Left r) <- xs ]
  where
    xs = [ (leEq e, note e) | e <- es ]
    note e = case leJust e of
      Nothing -> Left (NoTacticRecorded "legacy two-field line: no justification")
      Just j -> proofOfNaya (leEq e) (P.jNaya j)

coverageReport :: Coverage -> [String]
coverageReport c =
  ("renderable " ++ show (length (covRenderable c))
     ++ "  refused " ++ show (length (covRefused c)))
  : [ "  refused  " ++ showPrefixTerm l ++ " = " ++ showPrefixTerm r
        ++ "   (" ++ showRefusal rf ++ ")"
    | ((l, r), rf) <- covRefused c ]

-- ------------------------------------------------------- asking the kernel
--
-- Fail closed on both axes, for the reasons `Certificate.runAgda` gives at
-- length: a missing agda, a hung agda and an unwritable directory are facts
-- about the environment, and each must come back as a verdict rather than
-- as an exception escaping into the engine's round loop.

checkContextIn :: FilePath -> FilePath -> Context -> IO (Either Refusal (ExitCode, String))
checkContextIn root dir ctx = case renderContext ctx of
  Left e -> pure (Left e)
  Right src -> do
    let file = dir </> ctxModule ctx ++ ".agda"
    r <- try (timeout kTimeoutMicros (run file src))
           :: IO (Either SomeException (Maybe (ExitCode, String)))
    pure $ Right $ case r of
      Right (Just ok) -> ok
      Right Nothing -> (ExitFailure 124, "kernel context: agda did not return\n")
      Left e -> (ExitFailure 127, "kernel context: agda invocation raised: " ++ show e ++ "\n")
  where
    run file src = do
      writeUtf8 file src
      base <- getEnvironment
      let env' = ("LC_ALL", "C.UTF-8") : ("LANG", "C.UTF-8")
                 : [ kv | kv@(k, _) <- base, k /= "LC_ALL", k /= "LANG" ]
          cp = (proc "agda" (C.agdaArgs dir file)) { cwd = Just root, env = Just env' }
      (code, out, err) <- readCreateProcessWithExitCode cp ""
      pure (code, out ++ err)

kTimeoutMicros :: Int
kTimeoutMicros = 180 * 1000000

checkContext :: FilePath -> Context -> IO (Either Refusal (ExitCode, String))
checkContext root ctx = do
  tmp <- getTemporaryDirectory
  line <- readProcess "mktemp" ["-d", tmp </> "kernel-context.XXXXXX"] ""
  let dir = reverse (dropWhile isSpace (reverse line))
  checkContextIn root dir ctx `finally` removePathForcibly dir

writeUtf8 :: FilePath -> String -> IO ()
writeUtf8 path s = withFile path WriteMode $ \h -> do
  hSetEncoding h utf8
  hPutStr h s

-- The repository root, found rather than assumed: `Certificate.agdaArgs`
-- passes `-i formal/cubical` relative to the process's cwd.
findRepoRoot :: IO (Maybe FilePath)
findRepoRoot = go [".", "..", "../..", "../../.."]
  where
    go [] = pure Nothing
    go (d : ds) = do
      ok <- doesDirectoryExist (d </> C.kIncludeRoot)
      if ok then pure (Just d) else go ds

-- ==================================================================
-- THE DEMONSTRATION
--
-- Every line below is copied verbatim out of the committed files.  Nothing
-- here is an example chosen because it renders.

-- The last five lines of `machine/library.terms` (the five that carry a
-- justification), verbatim, tabs and all.
sampleLibraryLines :: [String]
sampleLibraryLines =
  [ "le(x,+(x,y))\ts(0)\tpramana=anumana|naya=induction on x, step = ih|eq=_≡_ on ℕ|vocab=0.s.+.*.max.-.gcd.le|vars=3|size=7|round=0|calls=1"
  , "+(+(x,y),z)\t+(x,+(y,z))\tpramana=anumana|naya=induction on x, step = cong suc|eq=_≡_ on ℕ|vocab=0.s.+.*.max.-.gcd.le|vars=3|size=7|round=0|calls=1"
  , "le(+(x,y),+(z,y))\tle(x,z)\tpramana=anumana|naya=trace replay|eq=_≡_ on ℕ|vocab=0.s.+.*.max.-.gcd.le|vars=3|size=7|round=0|calls=1"
  , "*(s(x),y)\t+(y,*(x,y))\tpramana=anumana|naya=refl|eq=_≡_ on ℕ|vocab=0.s.+.*.max.-.gcd.le|vars=3|size=7|round=3|calls=1"
  , "+(x,y)\tmax(+(x,y),x)\tpramana=anumana|naya=induction on x, step = cong suc|eq=_≡_ on ℕ|vocab=0.s.+.*.max.-.gcd.le|vars=3|size=7|round=4|calls=1"
  ]

-- Verbatim KERNEL-ACCEPT lines from `machine/machine.log`, including the
-- `trace replay` acceptance of the flagship goal and the `x = (x+0)` shape
-- that the seam never once submitted.
sampleAcceptLines :: [String]
sampleAcceptLines =
  [ "  KERNEL-ACCEPT round=0 x = (0+x)  (refl, 1 agda calls)"
  , "  KERNEL-ACCEPT round=0 0 = -(x,x)  (induction on x, step = ih, 1 agda calls)"
  , "  KERNEL-ACCEPT round=0 x = (xmaxx)  (induction on x, step = cong suc, 1 agda calls)"
  , "  KERNEL-ACCEPT round=0 x = (s(0)*x)  (trace replay, 1 agda calls)"
  , "  KERNEL-ACCEPT round=0 (x+y) = (y+x)  (trace replay, 1 agda calls)"
  ]

-- THE POINT OF THE WHOLE FILE, in one module.
--
--   * four lemmas reconstructed from the real `library.terms` lines above,
--     each with the proof the machine itself recorded;
--   * `plusZero`, i.e. `x = (x+0)` — the residual `Obstruction` harvested 27
--     times and the seam submitted to the kernel 0 times.  Its proof is not
--     in `library.terms`, because the machine's rewriter derives it in one
--     step from `x = 0+x` and `x+y = y+x` and therefore never asks.  The
--     kernel cannot: cubical's `_+_` recurses on its FIRST argument, so
--     `zero + x` reduces and `x + zero` does not.  Induction, one line;
--   * the goal `x = (s(0)*x)`, whose only recorded proof is `trace replay`
--     — unrenderable — discharged instead by CITING `plusZero`.  Agda
--     unfolds `suc zero · x` to `x + zero · x` to `x + zero`, which is
--     exactly what the cited name proves.
--
-- That last line is the organ: a goal closing because a previously proved
-- lemma has a name in the kernel's scope.  No module the present gate emits
-- can contain it.
flagshipContext :: Context
flagshipContext = Context
  { ctxModule = "KernelContextDemo"
  , ctxDefs = []
  , ctxLemmas = fromLibrary ++ [plusZero]
  , ctxGoal = Lemma "goal" (V 0, F "*" [F "s" [F "0" []], V 0]) (PCite "plusZero" [V 0])
  }
  where
    fromLibrary =
      [ l | (i, ln) <- zip [0 :: Int ..] sampleLibraryLines
          , e <- take 1 (libraryEntries ln)
          , Right l <- [lemmaFromEntry ("l" ++ show i) e] ]
    plusZero = Lemma "plusZero" (V 0, F "+" [V 0, F "0" []])
                     (PInduction 0 PRefl (PCong (F "s" [V 1]) PIh))

-- The composition half of the proof language, exercised on the theorem
-- §5 of `notes/THE_SEAM_ASKS_THE_WRONG_NAYA.md` is about: `(x+y) = (y+x)`
-- appears on a KERNEL-ACCEPT line 56 times, and the kernel has never once
-- been left holding it.  Here it is as ONE named definition, `comm`, in
-- scope for everything after it, proved by induction whose step is a
-- composite citing two earlier lemmas —
--
--     comm (suc x) y = (cong (λ z → (suc z)) (comm x y)) ∙ (sucRight y x)
--
-- which is beyond `Certificate.stepShapes` in three separate ways at once
-- (a chain, a citation, and an instance at permuted arguments).
--
-- WHAT THIS DOES AND DOES NOT SHOW.  It shows the proof LANGUAGE is enough
-- to carry a real multi-lemma argument past agda.  It does NOT show that
-- the machine can produce this: the machine's own record for `(x+y)=(y+x)`
-- is `trace replay`, which `proofOfNaya` refuses, and these three proofs
-- were written here by hand.  Rendering the machine's version needs its
-- rewrite trace serialised, which is a change in a file this module does
-- not touch.  Reading this context as evidence about the machine would be
-- the same error the note diagnoses, one level up.
commContext :: Context
commContext = Context
  { ctxModule = "KernelContextComm"
  , ctxDefs = []
  , ctxLemmas = [plusZero, sucRight]
  , ctxGoal = comm
  }
  where
    plusZero = Lemma "plusZero" (V 0, F "+" [V 0, F "0" []])
                     (PInduction 0 PRefl (PCong (F "s" [V 1]) PIh))
    -- suc (x + y) ≡ x + suc y
    sucRight = Lemma "sucRight" (F "s" [F "+" [V 0, V 1]], F "+" [V 0, F "s" [V 1]])
                     (PInduction 0 PRefl (PCong (F "s" [V 2]) PIh))
    comm = Lemma "comm" (F "+" [V 0, V 1], F "+" [V 1, V 0])
                 (PInduction 0
                    (PCite "plusZero" [V 1])
                    (PTrans (PCong (F "s" [V 2]) PIh) (PCite "sucRight" [V 1, V 0])))

-- The falsifier.  A kernel that accepts this is not checking, and nothing
-- it says about `flagshipContext` may be read as a proof.  `s(x) = x` by
-- `refl`, in a context that is otherwise identical.
falseContext :: Context
falseContext = flagshipContext
  { ctxModule = "KernelContextFalse"
  , ctxGoal = Lemma "goal" (F "s" [V 0], V 0) PRefl
  }

-- ------------------------------------------------------------- self-test

selfTest :: IO Bool
selfTest = do
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  a <- selfTestPure
  b <- selfTestKernel
  pure (a && b)

-- Everything that does not need agda.  Deterministic, fast, and every case
-- is a verbatim string from a committed file or a Term parsed out of one.
selfTestPure :: IO Bool
selfTestPure = do
    hSetEncoding stdout utf8
    mapM_ report checks
    putStrLn "  -- coverage over the five committed justified lines --"
    mapM_ (putStrLn . ("  " ++)) (coverageReport (coverage entries))
    pure (all (\(_, ok, _) -> ok) checks)
  where
    report (name, ok, detail)
      | ok = putStrLn ("  ok    " ++ name)
      | otherwise = putStrLn ("  FAIL  " ++ name ++ "\n          " ++ detail)

    entries = concatMap libraryEntries sampleLibraryLines

    -- 1. the reader is an inverse of `showTermP` on the real file's fields
    roundTrip =
      [ (fld, parsePrefixTerm fld >>= \t -> Just (showPrefixTerm t == fld))
      | ln <- sampleLibraryLines, fld <- take 2 (splitTab ln) ]
    splitTab s = case break (== '\t') s of
      (a, '\t' : b) -> a : splitTab b
      (a, _) -> [a]

    -- 2. the five real records parse, and their nayas classify as the
    --    header's table says they do
    nayas = [ P.jNaya j | e <- entries, Just j <- [leJust e] ]
    renderableFlags = [ either (const False) (const True) (proofOfNaya (leEq e) n)
                      | (e, n) <- zip entries nayas ]

    -- 3. the tactic strings on real KERNEL-ACCEPT lines, read with
    --    Obstruction's own extractor and Pramana's own reader
    logTactics = map O.tacticOfAcceptLine sampleAcceptLines
    logNayas = map P.nayaOfNote logTactics

    -- 4. the demonstration module renders, and renders to this
    rendered = renderContext flagshipContext

    -- 5. refusals are refusals, by name
    bad nm ctx = case renderContext ctx of
      Left r -> (nm, True, showRefusal r)
      Right _ -> (nm, False, "rendered when it should have refused")
    ctxWith p g = flagshipContext { ctxLemmas = ctxLemmas flagshipContext
                                  , ctxGoal = Lemma "goal" g p }
    goalEq = (V 0, F "+" [V 0, F "0" []])

    checks =
      [ ( "showPrefixTerm . parsePrefixTerm = id on the committed fields"
        , all (== Just True) (map snd roundTrip)
        , show roundTrip )
      , ( "five committed library.terms lines parse to five records"
        , length entries == 5 && length nayas == 5
        , show (length entries) ++ " records, " ++ show (length nayas) ++ " nayas" )
      , ( "their nayas are the four the file records"
        , nayas == [ P.NInduction 'x' (Just "ih")
                   , P.NInduction 'x' (Just "cong suc")
                   , P.NTraceReplay
                   , P.NRefl
                   , P.NInduction 'x' (Just "cong suc") ]
        , show nayas )
      , ( "four are renderable, the trace replay is not"
        , renderableFlags == [True, True, False, True, True]
        , show renderableFlags )
      , ( "trace replay refuses by name, not by silence"
        , case proofOfNaya (V 0, V 0) P.NTraceReplay of
            Left (NoTacticRecorded "trace replay") -> True
            _ -> False
        , show (proofOfNaya (V 0, V 0) P.NTraceReplay) )
      , ( "real KERNEL-ACCEPT tactic strings read back through Pramana"
        , logNayas == [ P.NRefl
                      , P.NInduction 'x' (Just "ih")
                      , P.NInduction 'x' (Just "cong suc")
                      , P.NTraceReplay
                      , P.NTraceReplay ]
        , show logTactics )
      , ( "every stepShapes shape Certificate can emit is renderable"
        , all (\(s, want) -> either (const False) (const True)
                               (stepProof (V 0, V 1) s) == want)
              [ (s, want) | (note, want) <- tacticVocabulary
                          , Just s <- [afterStep note] ]
          && all (\(note, want) ->
                    either (const False) (const True)
                      (proofOfNaya (V 0, V 1) (P.nayaOfNote note)) == want)
                 tacticVocabulary
        , show tacticVocabulary )
      , ( "the demonstration module renders"
        , either (const False) (const True) rendered
        , either showRefusal (const "") rendered )
      , ( "it defines plusZero by induction and closes the goal by citing it"
        , case rendered of
            Right src ->
              "plusZero : (x : ℕ) → x ≡ (x + zero)" `elem` lines src
              && "plusZero zero = refl" `elem` lines src
              && "plusZero (suc x) = (cong (λ y → (suc y)) (plusZero x))" `elem` lines src
              && "goal : (x : ℕ) → x ≡ ((suc zero) · x)" `elem` lines src
              && "goal x = (plusZero x)" `elem` lines src
            Left _ -> False
        , either showRefusal id rendered )
      , ( "the module is named after its file, not Candidate"
        , case rendered of
            Right src -> "module KernelContextDemo where" `elem` lines src
                         && notElem "module Candidate where" (lines src)
            Left _ -> False
        , either showRefusal id rendered )
      , ( "the lemma reconstructed from a real max line transcribes max"
        , case rendered of
            Right src -> "max : ℕ → ℕ → ℕ" `elem` lines src
                         && "l4 : (x y : ℕ) → (x + y) ≡ (max (x + y) x)" `elem` lines src
            Left _ -> False
        , either showRefusal id rendered )
      , bad "cite of a name not in scope"
            (ctxWith (PCite "nosuch" [V 0]) goalEq)
      , bad "cite at the wrong arity"
            (ctxWith (PCite "plusZero" [V 0, V 1]) goalEq)
      , bad "PIh outside an induction step"
            (ctxWith PIh goalEq)
      , bad "nested PInduction"
            (ctxWith (PInduction 0 PRefl (PInduction 0 PRefl PRefl)) goalEq)
      , bad "induction on a variable the equation does not mention"
            (ctxWith (PInduction 3 PRefl PRefl) goalEq)
      , bad "cong context with no hole"
            (ctxWith (PCong (F "s" [V 0]) PRefl) goalEq)
      , bad "cong context with two holes"
            (ctxWith (PCong (F "+" [V 1, V 2]) PRefl) goalEq)
      , bad "a variable no telescope binds"
            (ctxWith (PCite "plusZero" [V 4]) goalEq)
      , bad "an injected name"
            (flagshipContext
               { ctxGoal = Lemma "g\n{-# OPTIONS --no-safe #-}\npostulate bad : Set"
                                 goalEq PRefl })
      , bad "a lemma named after a bound variable"
            (flagshipContext { ctxGoal = Lemma "x" goalEq PRefl })
      , bad "two lemmas with one name"
            (flagshipContext { ctxGoal = Lemma "plusZero" goalEq PRefl })
      ]

    afterStep note = case break (== '=') note of
      (_, '=' : rest) -> Just (dropWhile isSpace rest)
      _ -> Nothing

-- The kernel half.  Two agda processes on top of the two controls, and the
-- controls come FIRST: an exit status is evidence about mathematics only
-- once the checker has been watched refusing a falsehood
-- (`Certificate.kernelIsChecking`, and the reasoning at its definition).
--
-- A missing or broken toolchain is reported as SKIP and does not fail the
-- test — but it does not pass it either, and it says so on stdout, because
-- a green that means "agda was absent" is the exact species of false
-- knowledge this repository's protocol is written against.
selfTestKernel :: IO Bool
selfTestKernel = do
  hSetEncoding stdout utf8
  mroot <- findRepoRoot
  case mroot of
    Nothing -> do
      putStrLn "  SKIP  kernel: no formal/cubical above the working directory"
      pure True
    Just root -> do
      checking <- C.kernelIsChecking root
      if not checking
        then do
          putStrLn "  SKIP  kernel: agda is not checking here (controls failed)"
          pure True
        else do
          good <- checkContext root flagshipContext
          cmm <- checkContext root commContext
          bad' <- checkContext root falseContext
          let accepted r = case r of
                Right (ExitSuccess, _) -> True
                _ -> False
              refused r = case r of
                Right (ExitFailure _, _) -> True
                _ -> False
              okGood = accepted good
              okComm = accepted cmm
              okBad = refused bad'
          putStrLn ("  " ++ (if okGood then "ok    " else "FAIL  ")
                    ++ "kernel accepts the context module: " ++ verdict good)
          putStrLn ("  " ++ (if okComm then "ok    " else "FAIL  ")
                    ++ "kernel accepts the composed commutativity module: " ++ verdict cmm)
          putStrLn ("  " ++ (if okBad then "ok    " else "FAIL  ")
                    ++ "kernel refuses the falsifier: " ++ verdict bad')
          pure (okGood && okComm && okBad)
  where
    verdict (Left r) = "REFUSED BY THE EMITTER: " ++ showRefusal r
    verdict (Right (code, out)) =
      show code ++ "  " ++ take 120 (unwords (words out))
