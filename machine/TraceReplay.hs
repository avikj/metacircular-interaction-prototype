-- TraceReplay — compile the engine's own rewrite trace into an Agda proof.
--
-- WHY THIS EXISTS
--
-- `machine/Certificate.hs` certifies a discovered theorem by emitting an
-- induction skeleton and SEARCHING for the clause bodies: it tries `refl`,
-- then `ih`, then `cong suc (ih)`, then a menu of `cong` sections, one Agda
-- process per attempt, up to a fixed budget.  Two costs follow.
--
--   * Reach.  Measured on the engine's own library snapshot
--     (machine/CERTIFICATE_REACH.md): 15 of 28 theorems certify.  Six of the
--     thirteen failures are not argument-order artefacts -- they are proofs
--     the one-shape menu simply cannot express, because the real derivation
--     is several rewrites at several positions.
--   * Speed.  Every failure burns the whole budget in Agda process launches.
--
-- Both are the same mistake: the engine ALREADY KNEW the proof.  At the
-- moment `proveByInduction` returns, it has just normalised both sides and
-- watched every rewrite fire -- which rule, at which subterm, under which
-- substitution, in what order.  Searching for that proof a second time, in
-- another language, is work the machine has already done and thrown away.
--
-- This module is the transcription instead.  A trace becomes a path:
--
--     one rewrite at the root      ->  the rule's lemma, instantiated
--     one rewrite under a context  ->  cong (\ h -> C[h]) (that lemma)
--     a rule fired right-to-left   ->  sym (...)
--     a sequence of rewrites       ->  p1 ∙ p2 ∙ ... ∙ pn
--     left trace vs right trace    ->  L ∙ sym R   (both reach one normal form)
--     the induction hypothesis     ->  the structural recursive call
--
-- so a certificate costs ONE Agda call and expresses exactly the proof the
-- engine found, however many steps it took.
--
-- STATUS.  Self-contained and self-tested: this module carries its own
-- matcher and rewriter so it can build real traces and check the emitted
-- modules with Agda, without importing (and without being broken by) the
-- files other agents are editing concurrently.  It is NOT yet wired into
-- MathMachine's gate; wiring is a two-file change across `MathMachine.hs`
-- and `Certificate.hs`, and both were owned by other agents when this was
-- written.  The wiring contract is stated in `replayContract` below.
--
-- Build and check:
--   ghc -O1 -imachine -outputdir /tmp/tr-build -o /tmp/tr-test \
--       -main-is TraceReplay machine/TraceReplay.hs
--   /tmp/tr-test .

module TraceReplay
  ( Term(..)
  , Rule
  , TraceStep(..)
  , Deriv(..)
  , rewriteTrace
  , normalizeTrace
  , LemmaEnv(..)
  , emptyEnv
  , peanoEnv
  , replayClause
  , replayModule
  , replayWithRules
  , addReflLemmas
  , reflProvable
  , libRules
  , deriveByInduction
  , peanoRules
  , replayContract
  , main
  ) where

import Data.List (intercalate, isPrefixOf)
import qualified Data.Map.Strict as M
import Data.Maybe (mapMaybe, isJust)
import Control.Exception (finally)
import System.Directory (removePathForcibly, getTemporaryDirectory)
import System.Environment (getArgs, getEnvironment)
import System.Exit (ExitCode(..), exitFailure, exitSuccess)
import System.FilePath ((</>))
import System.IO
import System.Process (proc, cwd, env, readCreateProcessWithExitCode, readProcess)
import Data.Char (isSpace)
import Text.Printf (printf)
import GHC.IO.Encoding (setLocaleEncoding)

-- ---------------------------------------------------------------- terms
--
-- Deliberately the same shape as MathMachine's `Term`, so a wiring change
-- is a coercion and not a translation.

data Term = V !Int | F !String [Term] deriving (Eq, Ord)

instance Show Term where
  show (V i) | i < 6 = [ "xyzuvw" !! i ]
             | otherwise = "n" ++ show i
  show (F f []) = f
  show (F f [a,b]) | f `elem` ["+","*"] = "(" ++ show a ++ f ++ show b ++ ")"
  show (F f as) = f ++ "(" ++ intercalate "," (map show as) ++ ")"

type Rule = (Term, Term)

type Sub = M.Map Int Term

match :: Term -> Term -> Maybe Sub
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

applySub :: Sub -> Term -> Term
applySub m (V i) = M.findWithDefault (V i) i m
applySub m (F f ts) = F f (map (applySub m) ts)

size :: Term -> Int
size (V _) = 1
size (F _ ts) = 1 + sum (map size ts)

varsOfT :: Term -> [Int]
varsOfT (V i) = [i]
varsOfT (F _ ts) = concatMap varsOfT ts

-- THE REDUCTION ORDER, and why it is not just term size.
--
-- The engine does not accept a rewrite because the term got shorter; it
-- accepts one because the term got SMALLER IN A WELL-FOUNDED ORDER.  The
-- distinction is load-bearing here and a size-only test was this module's
-- first bug: `x + s(y) -> s(x + y)` leaves the size unchanged, so a size
-- test blocks the single most important defining equation and the trace
-- silently stops short of the normal form.
--
-- This is the lexicographic path order over a precedence in which a symbol
-- defined later outranks the ones it was defined from (* > + > s > 0), with
-- a (size, then a fixed total order) fallback for the pairs LPO cannot
-- compare.  Both halves are transcribed from MathMachine's `lpo`,
-- `precedence`, `cmpTerm` and `decreases`: the certificate must replay the
-- proof the engine actually found, so it has to accept exactly the rewrites
-- the engine accepted.
precedenceOf :: String -> Int
precedenceOf f = case f of
  "0" -> 0
  "s" -> 1
  "+" -> 2
  "*" -> 3
  "#" -> -1        -- the frozen induction variable: below everything
  _   -> -1

lpo :: Term -> Term -> Bool
lpo s t
  | s == t = False
  | otherwise = case (s, t) of
      (V _, _) -> False
      (F _ _, V x) -> x `elem` varsOfT s
      (F f ss, F g ts)
        | any (\si -> si == t || lpo si t) ss -> True
        | precedenceOf f > precedenceOf g && all (lpo s) ts -> True
        | f == g && all (lpo s) ts && lexGt ss ts -> True
        | otherwise -> False
  where
    lexGt (a:as) (b:bs) | a == b = lexGt as bs
                        | otherwise = lpo a b
    lexGt _ _ = False

cmpTerm :: Term -> Term -> Ordering
cmpTerm (V a) (V b) = compare a b
cmpTerm (V _) (F _ _) = LT
cmpTerm (F _ _) (V _) = GT
cmpTerm s@(F f as) t@(F g bs) =
  compare (size s) (size t)
    <> compare (precedenceOf f) (precedenceOf g)
    <> compare (length as) (length bs)
    <> mconcat (zipWith cmpTerm as bs)

-- The fallback applies ONLY where LPO is silent; if LPO ranks the two terms
-- the other way, size must not override it, or the same equation fires in
-- both directions and normal forms oscillate.
decreases :: Term -> Term -> Bool
decreases u v
  | lpo u v = True
  | lpo v u = False
  | otherwise = cmpTerm v u == LT

-- ---------------------------------------------------------------- traces

-- One rewrite, with everything the proof needs and nothing it does not.
-- `tsBefore` is the WHOLE term the step acted on, so the congruence context
-- can be reconstructed by replacing the redex with a hole; `tsPos` is the
-- argument path from the root to that redex.
data TraceStep = TraceStep
  { tsBefore :: Term
  , tsPos    :: [Int]
  , tsRule   :: Rule
  , tsSub    :: Sub
  } deriving (Eq, Show)

-- A completed induction, exactly as the engine holds it at the moment it
-- succeeds: the conclusion, the variable, the frozen hypothesis, and the
-- four traces that close the two clauses.
data Deriv = Deriv
  { dGoal  :: (Term, Term)
  , dVar   :: Int
  , dHyp   :: (Term, Term)
  , dBaseL :: [TraceStep]
  , dBaseR :: [TraceStep]
  , dStepL :: [TraceStep]
  , dStepR :: [TraceStep]
  } deriving (Eq, Show)

-- One innermost-leftmost rewrite that strictly decreases the term, paired
-- with the record of what it did.  The decrease condition is what makes
-- `normalizeTrace` terminate and is the same discipline MathMachine uses.
rewriteTrace :: [Rule] -> Term -> Maybe (Term, TraceStep)
rewriteTrace rs t =
  case t of
    F f ts -> case args 0 ts of
                Just (ts', st) -> Just (F f ts', st { tsBefore = t
                                                    , tsPos = tsPos st })
                Nothing -> root t
    _ -> root t
  where
    root u =
      case [ (u', TraceStep t [] (l, r) sub)
           | (l, r) <- rs, Just sub <- [match l u]
           , let u' = applySub sub r, decreases u u' ] of
        (x:_) -> Just x
        []    -> Nothing
    args _ [] = Nothing
    args i (x:xs) =
      case rewriteTrace rs x of
        Just (x', st) -> Just (x':xs, st { tsPos = i : tsPos st })
        Nothing -> fmap (\(xs', st) -> (x:xs', st)) (args (i+1) xs)

normalizeTrace :: [Rule] -> Term -> (Term, [TraceStep])
normalizeTrace rs = go (200 :: Int) []
  where
    go 0 acc t = (t, reverse acc)
    go k acc t = case rewriteTrace rs t of
                   Nothing -> (t, reverse acc)
                   Just (t', st) -> go (k-1) (st:acc) t'

-- --------------------------------------------------------- the lemma env
--
-- What a fired rule is ALLOWED to become in the emitted proof.  Nothing is
-- guessed: a rule that is not in the environment (and is not the induction
-- hypothesis) makes the whole replay fail, so a certificate never silently
-- appeals to something it cannot name.

data LemmaEnv = LemmaEnv
  { leLemmas :: [(Rule, (String, [Int]))]
    -- ^ rule ==> (Agda name, the variable indices it takes, in order)
  , lePreamble :: [String]
    -- ^ the declarations those names come from, emitted verbatim
  }

emptyEnv :: LemmaEnv
emptyEnv = LemmaEnv [] []

x0, y0 :: Term
x0 = V 0
y0 = V 1

zeroT :: Term
zeroT = F "0" []

sucT :: Term -> Term
sucT t = F "s" [t]

binT :: String -> Term -> Term -> Term
binT f a b = F f [a, b]

-- The engine's own defining equations for + and *, as lemmas PROVED in the
-- emitted module.  MathMachine recurses on the second argument; Cubical's
-- _+_ and _·_ recurse on the first, so these do not hold definitionally and
-- must be discharged -- four lines each, by induction, from the library's
-- definitions.
--
-- They are deliberately not `open import Cubical.Data.Nat.Properties`: that
-- module carries +-comm and ·-comm too, and a certificate allowed to cite
-- those would let the library prove the engine's headline theorem while the
-- log still said the engine did.  Defining equations are inheritance; the
-- theorem stays the engine's.
peanoEnv :: LemmaEnv
peanoEnv = LemmaEnv
  { leLemmas =
      [ ((binT "+" x0 zeroT, x0),                       ("addZero", [0]))
      , ((binT "+" x0 (sucT y0), sucT (binT "+" x0 y0)), ("addSuc",  [0,1]))
      , ((binT "*" x0 zeroT, zeroT),                    ("mulZero", [0]))
      , ((binT "*" x0 (sucT y0), binT "+" (binT "*" x0 y0) x0),
                                                        ("mulSuc",  [0,1]))
      ]
  , lePreamble =
      [ "addZero : (a : ℕ) → (a + zero) ≡ a"
      , "addZero zero = refl"
      , "addZero (suc a) = cong suc (addZero a)"
      , "addSuc : (a b : ℕ) → (a + suc b) ≡ suc (a + b)"
      , "addSuc zero b = refl"
      , "addSuc (suc a) b = cong suc (addSuc a b)"
      , "addAssoc : (a b c : ℕ) → ((a + b) + c) ≡ (a + (b + c))"
      , "addAssoc zero b c = refl"
      , "addAssoc (suc a) b c = cong suc (addAssoc a b c)"
      , "mulZero : (a : ℕ) → (a · zero) ≡ zero"
      , "mulZero zero = refl"
      , "mulZero (suc a) = mulZero a"
      , "mulSuc : (a b : ℕ) → (a · suc b) ≡ ((a · b) + a)"
      , "mulSuc zero b = refl"
      , "mulSuc (suc a) b ="
      , "  cong (λ h → suc (b + h)) (mulSuc a b)"
      , "  ∙ cong suc (sym (addAssoc b (a · b) a))"
      , "  ∙ sym (addSuc (b + (a · b)) a)"
      ]
  }

-- ------------------------------------------------------------- rendering

agdaVar :: Int -> Maybe String
agdaVar i | i >= 0 && i < 6 = Just [ "xyzuvw" !! i ]
          | otherwise = Nothing

-- `env` maps a variable index to the name bound in the clause; index -1 is
-- the induction variable's bound name in the step clause, and -2 is the
-- `cong` hole.  A term mentioning anything else does not render, and the
-- replay fails rather than emitting an unbound name.
render :: M.Map Int String -> Term -> Maybe String
render e (V i) = M.lookup i e
render e (F "#" []) = M.lookup (-1) e
render e (F "?" []) = M.lookup (-2) e
render _ (F "0" []) = Just "zero"
render e (F "s" [t]) = (\u -> "suc (" ++ u ++ ")") <$> render e t
render e (F "+" [a,b]) = bin e "+" a b
render e (F "*" [a,b]) = bin e "·" a b
render _ _ = Nothing

bin :: M.Map Int String -> String -> Term -> Term -> Maybe String
bin e op a b = do
  s <- render e a
  t <- render e b
  pure ("(" ++ s ++ " " ++ op ++ " " ++ t ++ ")")

replaceAt :: Term -> [Int] -> Term -> Term
replaceAt _ [] u = u
replaceAt (F f ts) (i:p) u =
  F f [ if j == i then replaceAt t p u else t | (j,t) <- zip [0..] ts ]
replaceAt t _ _ = t

swap :: Rule -> Rule
swap (a,b) = (b,a)

-- One trace step as one path.  `self` is the name of the theorem being
-- proved, so the induction hypothesis can appear as its recursive call.
stepPath :: LemmaEnv -> M.Map Int String -> String -> [Int] -> Int
         -> (Term,Term) -> TraceStep -> Maybe String
stepPath lenv e self selfVars v hyp st = do
  inner <- lemmaPath
  case tsPos st of
    [] -> pure inner
    p  -> do
      ctx <- render (M.insert (-2) "h" e) (replaceAt (tsBefore st) p (F "?" []))
      pure ("cong (λ h → " ++ ctx ++ ") (" ++ inner ++ ")")
  where
    rl = tsRule st
    sub = tsSub st
    lemmaPath
      | rl == hyp      = ihCall False
      | rl == swap hyp = ihCall True
      | otherwise =
          case lookup rl (leLemmas lenv) of
            Just (nm, is) -> named False nm is
            Nothing -> case lookup (swap rl) (leLemmas lenv) of
              Just (nm, is) -> named True nm is
              Nothing -> Nothing
    named rev nm is = do
      as <- mapM (\i -> render e (M.findWithDefault (V i) i sub)) is
      pure (wrap rev (unwords (nm : map paren as)))
    ihCall rev = do
      as <- mapM argFor selfVars
      pure (wrap rev (unwords (self : map paren as)))
    argFor i
      | i == v = M.lookup (-1) e
      | otherwise = render e (M.findWithDefault (V i) i sub)
    paren s = "(" ++ s ++ ")"
    wrap True s = "sym (" ++ s ++ ")"
    wrap False s = s

-- A whole clause: the left trace forward, the right trace reversed,
-- composed.  Both traces end at the same normal form, so L ∙ sym R is a
-- path from the clause's left side to its right side.  No steps at all
-- means the two sides met definitionally, and the clause is `refl`.
replayClause :: LemmaEnv -> M.Map Int String -> String -> [Int] -> Int
             -> (Term,Term) -> [TraceStep] -> [TraceStep] -> Maybe String
replayClause lenv e self selfVars v hyp ltr rtr = do
  ls <- mapM (stepPath lenv e self selfVars v hyp) ltr
  rs <- mapM (stepPath lenv e self selfVars v hyp) rtr
  pure $ case ls ++ map (\p -> "sym (" ++ p ++ ")") (reverse rs) of
    [] -> "refl"
    ps -> intercalate " ∙ " ps

-- The complete module for one induction.
replayModule :: LemmaEnv -> String -> Deriv -> Maybe String
replayModule lenv modName d = do
  let (gl, gr) = dGoal d
      v = dVar d
      ivs = varsOf gl `union'` varsOf gr
  vns <- mapM agdaVar ivs
  vn <- agdaVar v
  let envAll = M.fromList (zip ivs vns)
  sigL <- render envAll gl
  sigR <- render envAll gr
  let quant = if null vns then "" else "(" ++ unwords vns ++ " : ℕ) → "
      sig = "candidate : " ++ quant ++ sigL ++ " ≡ " ++ sigR
      baseEnv = M.delete v envAll
      stepEnv = M.insert (-1) vn (M.delete v envAll)
      basePat = [ if i == v then "zero" else n | (i,n) <- zip ivs vns ]
      stepPat = [ if i == v then "(suc " ++ n ++ ")" else n
                | (i,n) <- zip ivs vns ]
  basePf <- replayClause lenv baseEnv "candidate" ivs v (dHyp d)
                         (dBaseL d) (dBaseR d)
  stepPf <- replayClause lenv stepEnv "candidate" ivs v (dHyp d)
                         (dStepL d) (dStepR d)
  pure $ unlines $
    [ "{-# OPTIONS --cubical --safe --no-import-sorts #-}"
    , "module " ++ modName ++ " where"
    , "open import Cubical.Foundations.Prelude"
    , "open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)"
    ] ++ lePreamble lenv ++
    [ sig
    , unwords ("candidate" : basePat) ++ " = " ++ basePf
    , unwords ("candidate" : stepPat) ++ " = " ++ stepPf
    ]
  where
    varsOf (V i) = [i]
    varsOf (F _ ts) = concatMap varsOf ts
    union' a b = foldl (\acc i -> if i `elem` acc then acc else acc ++ [i]) [] (a ++ b)

-- CITING WHAT THE ENGINE ALREADY PROVED.
--
-- The engine's thesis is that a theorem is an installed transformation: once
-- proved it becomes a rewrite rule and the next round reasons with it.  Its
-- certificates did not have that property.  A proof that fires an earlier
-- theorem hits a rule with no name in the lemma environment, replay returns
-- Nothing, and the search runs -- which is why the live engine cannot
-- install `(x+y) = (y+x)`: the proof cites `x = (0+x)`, certified in round 0
-- and then forgotten by the gate.
--
-- So earlier theorems are emitted as named lemmas ahead of `candidate`.  The
-- question is what proof to give them, and the answer here is deliberately
-- the narrow one: a theorem is admitted to the environment only when it
-- holds by the LIBRARY's own computation, i.e. when both sides normalise to
-- the same term under Cubical's first-argument definitions.  Then its
-- declaration is `refl` and it cannot be wrong.
--
-- `libRules` is those definitions as rewrite rules.  Note they are NOT the
-- engine's: the engine recurses on the second argument, Cubical on the
-- first, and that difference is the whole reason this module exists.  Using
-- the library's orientation here is what makes `= refl` the correct proof.
libRules :: [Rule]
libRules =
  [ (binT "+" zeroT y0,          y0)                              -- zero + n = n
  , (binT "+" (sucT x0) y0,      sucT (binT "+" x0 y0))           -- suc m + n = suc (m + n)
  , (binT "*" zeroT y0,          zeroT)                           -- zero · n = zero
  , (binT "*" (sucT x0) y0,      binT "+" y0 (binT "*" x0 y0))    -- suc m · n = n + m · n
  ]

-- Does the library compute both sides to the same term?  If so the lemma is
-- `refl` and needs no proof of its own.  This is an exact syntactic test, not
-- a heuristic: it either meets or it does not, and a theorem that does not
-- meet is simply left out of the environment.
reflProvable :: (Term, Term) -> Bool
reflProvable (l, r) = fst (normalizeTrace libRules l)
                   == fst (normalizeTrace libRules r)

-- Extend an environment with certified theorems, each emitted as a named
-- lemma proved by `refl`.  Anything not `reflProvable` is silently skipped:
-- the cost of skipping is a fallback to the search, and the cost of guessing
-- would be an unsound certificate.
addReflLemmas :: [((Term, Term), String)] -> LemmaEnv -> LemmaEnv
addReflLemmas ts base = base
  { leLemmas   = leLemmas base   ++ [ (rl, (nm, vs)) | (rl, nm, vs, _) <- ok ]
  , lePreamble = lePreamble base ++ concat [ d | (_, _, _, d) <- ok ]
  }
  where
    ok = [ (rl, nm, vs, decl)
         | (rl, nm) <- ts
         , reflProvable rl
         , Just (vs, decl) <- [declFor nm rl] ]
    declFor nm (l, r) = do
      let vs = nubOrd (varsOfT l ++ varsOfT r)
      ns <- mapM agdaVar vs
      let e = M.fromList (zip vs ns)
      sl <- render e l
      sr <- render e r
      let quant = if null ns then "" else "(" ++ unwords ns ++ " : ℕ) → "
      pure (vs, [ nm ++ " : " ++ quant ++ sl ++ " ≡ " ++ sr
                , unwords (nm : ns) ++ " = refl" ])
    nubOrd = foldl (\acc i -> if i `elem` acc then acc else acc ++ [i]) []

-- THE ENTRY POINT the engine calls.
--
-- `rs` is the engine's OWN rule set at the moment it discharged the
-- theorem, so the trace this re-derives is the derivation the engine
-- actually ran: same rules, same innermost-leftmost strategy, same
-- reduction order.  It is one deterministic function computed twice, not a
-- second search -- which is why no proof can appear here that the engine
-- did not find.
--
-- Naming, though, is restricted to `peanoEnv`: a step that fires a rule
-- with no name in the lemma environment makes the whole replay return
-- Nothing, and the caller falls back to the shape search.  A certificate
-- never silently appeals to something it cannot name, and a theorem the
-- engine proved using an EARLIER theorem will fall back until that earlier
-- theorem is entered in the environment under the name it was emitted with
-- (see `replayContract`).
replayWithRules :: [((Term, Term), String)] -> [Rule] -> (Term, Term) -> Int
                -> String -> Maybe String
replayWithRules certs rs goal v modName =
  replayModule (addReflLemmas certs peanoEnv) modName (deriveByInduction rs goal v)

-- What a caller must supply for the wiring.  Stated as prose because the
-- types live in two modules that were being edited when this was written.
replayContract :: [String]
replayContract =
  [ "MathMachine.proveByInduction must return the Deriv it already has:"
  , "  the conclusion, the induction variable, the frozen hypothesis, and"
  , "  the four traces from normalising both clauses.  The traces are the"
  , "  output of a rewriter instrumented exactly as `rewriteTrace` here --"
  , "  same strategy, same decrease test -- so that proof and certificate"
  , "  can never disagree about which rewrite happened."
  , "Certificate.certifyWith must try `replayModule` FIRST and fall back to"
  , "  the shape search only when replay returns Nothing (a rule outside"
  , "  the lemma environment).  Replay costs one agda call and never"
  , "  searches; the menu stays as the escape hatch, not the main road."
  , "Every previously certified theorem should enter `leLemmas` with the"
  , "  name it was emitted under, so a later proof may cite an earlier one"
  , "  -- which is the engine's whole thesis (a theorem is an installed"
  , "  transformation) applied to its own certificates."
  ]

-- ------------------------------------------------------------- self-test

-- The engine's defining equations as REWRITE rules, i.e. what its
-- normaliser actually runs with.  Same content as `peanoEnv`'s lemmas,
-- oriented left-to-right.
peanoRules :: [Rule]
peanoRules = map fst (leLemmas peanoEnv)

-- The invocation, copied deliberately from `Certificate.runAgda` rather
-- than reinvented.  Three details are load-bearing and each was a real
-- fault once (see the fault list at the top of Certificate.hs):
--
--   * the module is written to a PRIVATE temp directory and named
--     `Candidate`, so concurrent engines cannot overwrite each other's
--     proposition between write and check;
--   * agda runs with cwd = repository root and BOTH `-i formal/cubical`
--     (for the .agda-lib) and `-i <tmpdir>` (so the candidate itself
--     resolves).  Writing the candidate into formal/cubical instead makes
--     agda resolve the module against the cubical library root and fail
--     with "the name of the top level module does not match the file
--     name" -- which is what this function did on its first draft;
--   * `--library=cubical` is what actually loads Cubical.*; `-i` alone
--     adds include paths and does NOT read a library.
runAgda :: FilePath -> String -> IO (ExitCode, String)
runAgda root source = do
  setLocaleEncoding utf8
  tmp <- getTemporaryDirectory
  dirLine <- readProcess "mktemp" ["-d", tmp </> "trace-replay.XXXXXX"] ""
  let dir = reverse (dropWhile isSpace (reverse dirLine))
      file = dir </> "Candidate.agda"
  (do h <- openFile file WriteMode
      hSetEncoding h utf8
      hPutStr h source
      hClose h
      base <- getEnvironment
      let env' = ("LC_ALL","C.UTF-8") : ("LANG","C.UTF-8")
                 : [ kv | kv@(k,_) <- base, k /= "LC_ALL", k /= "LANG" ]
          cp = (proc "agda" [ "-i", "formal/cubical", "-i", dir
                            , "--library=cubical", file ])
                 { cwd = Just root, env = Just env' }
      (code, out, err) <- readCreateProcessWithExitCode cp ""
      pure (code, out ++ err))
    `finally` removePathForcibly dir

-- Build a Deriv the way the engine does: substitute, normalise both sides
-- of each clause with the tracing rewriter, and keep the traces.
deriveByInduction :: [Rule] -> (Term,Term) -> Int -> Deriv
deriveByInduction rs goal@(l,r) v =
  Deriv { dGoal = goal
        , dVar = v
        , dHyp = (hypL, hypR)
        , dBaseL = snd (normalizeTrace rs bl)
        , dBaseR = snd (normalizeTrace rs br)
        , dStepL = snd (normalizeTrace (hyps ++ rs) gl)
        , dStepR = snd (normalizeTrace (hyps ++ rs) gr)
        }
  where
    eig = F "#" []
    subst i u (V j) = if i == j then u else V j
    subst i u (F f ts) = F f (map (subst i u) ts)
    (bl, br) = (subst v zeroT l, subst v zeroT r)
    hypL = subst v eig l
    hypR = subst v eig r
    (gl, gr) = (subst v (sucT eig) l, subst v (sucT eig) r)
    hyps = [(hypL,hypR),(hypR,hypL)]

cases :: [(String, (Term,Term), Int)]
cases =
  [ ("x + 0 = x           (definitional, no steps)", (binT "+" x0 zeroT, x0), 0)
  , ("0 + x = x           (needs induction)",        (binT "+" zeroT x0, x0), 0)
  , ("x + s(0) = s(x)",   (binT "+" x0 (sucT zeroT), sucT x0), 0)
  , ("x * 0 = 0",         (binT "*" x0 zeroT, zeroT), 0)
  ]

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetBuffering stdout LineBuffering
  argv <- getArgs
  let root = case argv of { (p:_) -> p ; [] -> "." }
  putStrLn "TraceReplay self-test: engine trace -> Agda path, checked."
  putStrLn ""
  results <- mapM (one root) cases
  putStrLn ""
  let ok = length (filter id results)
  printf "%d/%d replayed traces type-check\n" ok (length results)
  putStrLn ""
  putStrLn "Wiring contract:"
  mapM_ (putStrLn . ("  " ++)) replayContract
  if ok == length results then exitSuccess else exitFailure
  where
    one root (label, goal, v) = do
      let d = deriveByInduction peanoRules goal v
          nSteps = length (dBaseL d) + length (dBaseR d)
                 + length (dStepL d) + length (dStepR d)
      case replayModule peanoEnv "Candidate" d of
        Nothing -> do
          printf "  SKIP  %-46s (a fired rule is outside the lemma env)\n" label
          pure False
        Just src -> do
          (code, out) <- runAgda root src
          case code of
            ExitSuccess -> do
              printf "  OK    %-46s %d trace steps, 1 agda call\n" label nSteps
              pure True
            ExitFailure _ -> do
              printf "  NO    %-46s %s\n" label (firstLine out)
              pure False
    firstLine s = case filter informative (lines s) of
                    (l:_) -> unwords (words l)
                    []    -> "(agda said nothing)"
    informative ln = not (null (dropWhile isSpace ln))
                     && not ("Checking " `isPrefixOf` dropWhile isSpace ln)
