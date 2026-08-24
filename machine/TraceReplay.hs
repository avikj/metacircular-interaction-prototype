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
  , dHyp
  , dEnds
  , dBaseMet
  , dStepMet
  , endOfTrace
  , rewriteTrace
  , normalizeTrace
  , LemmaEnv(..)
  , emptyEnv
  , peanoEnv
  , replayClause
  , replayModule
  , replayWithRules
  , addReflLemmas
  , addProvedLemmas
  , inductionClauses
  , unnamedRules
  , reflProvable
  , libRules
  , deriveByInduction
  -- Exported 2026-08-21: `renderGoal`'s own comment already said it was
  -- exported "because a control needs it" -- and it was not.  The control is
  -- Pratilipi_TheThreeSesasAreTranscribedNotSearched, whose `falseStatement`
  -- must render a FALSE goal on THIS renderer; building the signature in the
  -- caller would be a second copy of the renderer, which is the drift this
  -- module already paid for once.
  , renderGoal
  , peanoRules
  -- Exported 2026-08-20 (additive; no definition changed).  A caller that
  -- wants to REWRITE with the same defining equations this module is willing
  -- to CITE needs the environment, not just the +/* half of it: `peanoRules`
  -- omits max and le, so a derivation over those symbols cannot fire and
  -- replay declines a proof that was in fact available.  Re-deriving the list
  -- in the caller is the two-copies defect that cost this file its whole
  -- reach on 2026-08-20 (see `moduleHeader`), so it is exported instead.
  , vocabEnv
  -- Added 2026-08-20 (additive; no existing definition changed).  Two of the
  -- three śeṣas handed forward by
  -- `notes/SesaPariksa_TheSixLemmasBehindTheInductionWallAreNotAMathematicalGap.md`
  -- §4 need NO induction on the goal at all: both sides normalise to a common
  -- term under the engine's own defining equations, and the whole proof is the
  -- two traces composed.  `replayModule` could only ever emit an induction, so
  -- the only way to transcribe those was to induct on a variable the proof
  -- does not use and let both clauses repeat the same path.  These emit the
  -- path itself.
  , transcribeDirect
  , directClauses
  , symbolsUsedGoal
  , noHypothesis
  , replayContract
  , main
  ) where

import qualified Certificate as C
import Data.List (intercalate, isPrefixOf)
import qualified Data.Map.Strict as M
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
  , dBaseL :: [TraceStep]
  , dBaseR :: [TraceStep]
  , dStepL :: [TraceStep]
  , dStepR :: [TraceStep]
  } deriving (Eq, Show)

-- DID THE TWO SIDES ACTUALLY MEET.  `L ∙ sym R` is a path from the clause's
-- left side to its right side ONLY if both traces end at the same term.
-- Nothing checked that: a derivation against a rule set that does not close
-- the clause produced two paths to two different places, `replayClause`
-- composed them anyway, and agda reported `y != x` at a column deep inside a
-- 400-character line.  A trace that does not close is not a proof and must
-- not be emitted as one.
--
-- पुनरागमन, 2026-08-21.  UNTIL TODAY THIS WAS TWO STORED `Bool` FIELDS,
-- `dBaseMet` and `dStepMet`, written by `deriveByInduction` and read by
-- `inductionClauses`.  The comment above argued for KEEPING the derived
-- value, and it was right to; what it never noticed is that it kept the
-- TRUNCATION and threw away the PATH.  The datum the emitter actually needs
-- is WHERE the two traces end; `Bool` is that pair of terms squashed to one
-- bit, and the bit was then free — `Deriv{…, dBaseMet = True}` against traces
-- that end nowhere near each other typechecked and emitted an unsound module.
-- In this lane's own vocabulary that is हिंसा committed in the middle of an
-- argument against it.
--
-- The endpoints are not new data.  A `TraceStep` holds `tsBefore` (the WHOLE
-- term the step acted on) and `tsPos` (the path from its root to the redex),
-- so the term a step lands on is `replaceAt tsBefore tsPos (applySub tsSub
-- rhs)`; and where a trace is empty, the endpoint is its start, which
-- `dGoal` and `dVar` fix.  So
--
--     base    : the traces, the goal, the induction variable
--     carried : the two endpoints, and the bit
--     witness : endOfTrace (start …) (dBaseL d) ≡ …
--
-- is `Punaragamana.Carrier`, its fibre `singl` and contractible
-- (`punaragamana/src/Punaragamana/Carrier.agda`, `fibre-isContr`), so the
-- fields carried nothing and cost two degrees of freedom.  They are gone and
-- `dBaseMet`/`dStepMet` are functions of the same name, so every read site is
-- unchanged and no caller can now write the answer it wants.
--
-- WHAT HASKELL CANNOT DO, said rather than faked: `witness` is a PATH and
-- there is no type here to hold one.  Deleting the field is the strongest
-- move the language offers — with nothing stored the value cannot disagree
-- with what determines it — but that is `∥ witness ∥`, not `witness`.
-- `dEnds` below is the honest half that Haskell CAN keep: the pair of terms,
-- rather than the bit.
--
-- FALSIFIED BEFORE IT WAS BELIEVED.  The reconstruction was run against the
-- old stored definition on all eleven members of `snapshotFragment`, under
-- the same accumulating rule set `measureSnapshot` uses: eleven of eleven
-- agree on both clause endpoint pairs, including the two whose step clause
-- does NOT meet (`(x+y)+z = x+(y+z)` and `x*y = y*x`), which is where a
-- reconstruction that silently returned the start term would have shown up
-- as a false `True`.  The comparison is not kept in the tree because the
-- definition it compared against no longer exists; what remains checkable is
-- that `replay reaches n/m` in `main` is unchanged.

-- Where one trace lands, given the term it started from.
endOfTrace :: Term -> [TraceStep] -> Term
endOfTrace t0 [] = t0
endOfTrace t0 sts = case reverse sts of
  []       -> t0
  (st : _) -> replaceAt (tsBefore st) (tsPos st)
                        (applySub (tsSub st) (snd (tsRule st)))

-- Substitute a term for the induction variable throughout.  The same
-- three lines `deriveByInduction` uses; shared so the two cannot drift.
substVar :: Int -> Term -> Term -> Term
substVar i u (V j)    = if i == j then u else V j
substVar i u (F f ts) = F f (map (substVar i u) ts)

-- The four terms each clause's two traces start from: base clause with the
-- variable at `zero`, step clause with it at `suc #`.  Determined by `dGoal`
-- and `dVar` alone.
clauseStarts :: Deriv -> ((Term, Term), (Term, Term))
clauseStarts d = ((sub zeroT l, sub zeroT r), (sub (sucT eig) l, sub (sucT eig) r))
  where (l, r) = dGoal d
        eig     = F "#" []
        sub u t = substVar (dVar d) u t

-- The induction hypothesis: the goal with the variable frozen at the
-- eigenvariable.  Determined too — this was `dHyp :: (Term, Term)`, a third
-- stored field of the same kind, removed with the two Bools.
dHyp :: Deriv -> (Term, Term)
dHyp d = (sub l, sub r)
  where (l, r) = dGoal d
        sub    = substVar (dVar d) (F "#" [])

-- WHERE the two traces of each clause land: the pair of terms, kept whole.
dEnds :: Deriv -> ((Term, Term), (Term, Term))
dEnds d = ( (endOfTrace bl (dBaseL d), endOfTrace br (dBaseR d))
          , (endOfTrace sl (dStepL d), endOfTrace sr (dStepR d)) )
  where ((bl, br), (sl, sr)) = clauseStarts d

-- MET, BUT UP TO THE LIBRARY'S OWN COMPUTATION.  Syntactic equality of the
-- engine's two normal forms is sufficient and NOT necessary: the ends may
-- differ as terms and still be the same type in agda, because Cubical's `_+_`
-- and `_·_` compute.  Requiring syntactic equality cost two theorems that had
-- been certifying (measured: 7/13 -> 5/13, with `(x+y) = (y+x)` among the
-- losses).  So the endpoints are compared under `libRules` -- this module's
-- model of what agda will unfold on its own -- which is the same test that
-- decides whether a cited lemma may be discharged by `refl`.
dBaseMet, dStepMet :: Deriv -> Bool
dBaseMet = reflProvable . fst . dEnds
dStepMet = reflProvable . snd . dEnds

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
-- THE REST OF THE ENGINE'S VOCABULARY.  Rendering only {0,s,+,*} meant every
-- theorem mentioning monus, max, le or gcd was unrenderable, so replay could
-- not even be attempted on it and the shape search -- which cannot close
-- these either -- got the whole population.  A live size-6 round submitted
-- 179 proofs to the kernel and got 6 back; most of the rest are here.
-- Spellings and the local definitions are transcribed from
-- `Certificate.preambleCore`, so "renders here" and "renders there" mean the
-- same module.
render e (F "-" [a,b]) = bin e "∸" a b
render e (F "max" [a,b]) = app e "max" [a,b]
render e (F "le" [a,b]) = app e "le" [a,b]
render e (F "gcd" [a,b]) = app e "gcd" [a,b]
render _ _ = Nothing

app :: M.Map Int String -> String -> [Term] -> Maybe String
app e f as = do
  ss <- mapM (render e) as
  pure ("(" ++ unwords (f : map paren ss) ++ ")")
  where paren s = "(" ++ s ++ ")"

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

-- One induction, as three Agda lines under a chosen name: the signature and
-- the two clauses.  Factored out of `replayModule` because a CITED theorem
-- needs exactly the same three lines under its own name -- the only
-- difference between the thing being certified and the thing it leans on is
-- which one is called `candidate`.  Also returns the lemma's parameter
-- order, which is what `stepPath` needs to apply it later.
inductionClauses :: LemmaEnv -> String -> Deriv -> Maybe ([Int], [String])
inductionClauses lenv self d = do
  if not (dBaseMet d && dStepMet d) then Nothing else pure ()
  let (gl, gr) = dGoal d
      v = dVar d
      ivs = varsOfT gl `unionT` varsOfT gr
  vns <- mapM agdaVar ivs
  vn <- agdaVar v
  let envAll = M.fromList (zip ivs vns)
  sigL <- render envAll gl
  sigR <- render envAll gr
  let quant = if null vns then "" else "(" ++ unwords vns ++ " : ℕ) → "
      sig = self ++ " : " ++ quant ++ sigL ++ " ≡ " ++ sigR
      baseEnv = M.delete v envAll
      stepEnv = M.insert (-1) vn (M.delete v envAll)
      basePat = [ if i == v then "zero" else n | (i,n) <- zip ivs vns ]
      stepPat = [ if i == v then "(suc " ++ n ++ ")" else n
                | (i,n) <- zip ivs vns ]
  basePf <- replayClause lenv baseEnv self ivs v (dHyp d)
                         (dBaseL d) (dBaseR d)
  stepPf <- replayClause lenv stepEnv self ivs v (dHyp d)
                         (dStepL d) (dStepR d)
  pure ( ivs
       , [ sig
         , unwords (self : basePat) ++ " = " ++ basePf
         , unwords (self : stepPat) ++ " = " ++ stepPf
         ] )

-- ------------------------------------------------- transcription, no induction
--
-- A goal whose two sides normalise to a common term needs no induction and
-- has no hypothesis.  Its proof is exactly what the two traces already say:
-- the left trace forward, the right trace backwards, composed.  That is the
-- same act `replayClause` performs for one clause of an induction, with the
-- clause being the whole theorem.
--
-- Why this is worth its own entry point rather than "induct on x and ignore
-- the hypothesis".  Inducting on an unused variable does typecheck for these
-- goals — both clauses re-derive the same path with `x` instantiated — but it
-- emits a case split the derivation never performed, and a certificate that
-- claims a proof structure the engine did not use is a written record of
-- something that did not happen.  The transcription is supposed to BE the
-- derivation.
--
-- `noHypothesis` is the rule handed to `stepPath` in place of the induction
-- hypothesis.  Its symbol is not in the renderer's vocabulary and not in any
-- rule set the engine builds, so no fired rule can equal it and no step can
-- be mistaken for a recursive call; `transcribeDirect` also refuses outright
-- if a caller has somehow put it in `rs`.
noHypothesis :: Rule
noHypothesis = (F "no-hypothesis" [], F "no-hypothesis" [])

-- Every symbol a directly transcribed module will mention: the goal's, plus
-- each citable lemma's, since the lemma declarations are emitted into the
-- same file.  Same accounting as `symbolsUsed`, against a goal rather than a
-- Deriv.
symbolsUsedGoal :: LemmaEnv -> (Term, Term) -> [String]
symbolsUsedGoal lenv (gl, gr) = nubStr (concatMap symsT terms)
  where
    terms = [gl, gr] ++ concat [ [a, b] | ((a, b), _) <- leLemmas lenv ]
    symsT (V _) = []
    symsT (F f ts) = f : concatMap symsT ts
    nubStr = foldl (\acc s -> if s `elem` acc then acc else acc ++ [s]) []

-- The signature and the single clause, under a chosen name — the direct
-- analogue of `inductionClauses`, and returning the same (parameter order,
-- lines) pair so a directly transcribed theorem can be CITED by a later one
-- exactly as an inducted one is.
directClauses :: LemmaEnv -> [Rule] -> String -> (Term, Term)
              -> Maybe ([Int], [String])
directClauses lenv rs self goal@(gl, gr) = do
  if noHypothesis `elem` rs then Nothing else pure ()
  let (lnf, ltr) = normalizeTrace rs gl
      (rnf, rtr) = normalizeTrace rs gr
  -- The two sides must MEET, under the same test `deriveByInduction` uses:
  -- syntactic equality of the engine's normal forms is sufficient and not
  -- necessary, because Cubical's `_+_` and `_·_` compute on their own.
  if not (reflProvable (lnf, rnf)) then Nothing else pure ()
  let ivs = varsOfT gl `unionT` varsOfT gr
  vns <- mapM agdaVar ivs
  let e = M.fromList (zip ivs vns)
  sigL <- render e gl
  sigR <- render e gr
  body <- replayClause lenv e self ivs (-1) noHypothesis ltr rtr
  let quant = if null vns then "" else "(" ++ unwords vns ++ " : ℕ) → "
  pure ( ivs
       , [ self ++ " : " ++ quant ++ sigL ++ " ≡ " ++ sigR
         , unwords (self : vns) ++ " = " ++ body
         ] )

-- The complete module for one directly transcribed goal.
transcribeDirect :: LemmaEnv -> [Rule] -> String -> (Term, Term) -> Maybe String
transcribeDirect lenv rs modName goal = do
  (_, clauses) <- directClauses lenv rs "candidate" goal
  pure (unlines (blockFor lenv modName goal ++ clauses))

-- Everything a module for this goal carries ABOVE its statement: the OPTIONS
-- line, the imports, the local `max`/`le` case trees, and the lemma block.
--
-- Exported because a control needs it.  A false equation cannot be
-- transcribed — the two traces do not meet, so no module is emitted and no
-- agda process starts — and "the route declined it" is a much weaker
-- statement than "the kernel refused it".  To get the second, the control has
-- to submit the false STATEMENT on the same block, and a control that builds
-- that block for itself is a second copy of the block, which is the thing that
-- is quietly allowed to drift.
blockFor :: LemmaEnv -> String -> (Term, Term) -> [String]
blockFor lenv modName goal =
  moduleHeader modName (symbolsUsedGoal lenv goal) ++ lePreamble lenv

-- The goal as an Agda statement: the variable names it binds, and the
-- quantified equation.  Same renderer `directClauses` and `inductionClauses`
-- use, for the same reason `blockFor` is exported.
renderGoal :: (Term, Term) -> Maybe ([String], String)
renderGoal (gl, gr) = do
  let ivs = varsOfT gl `unionT` varsOfT gr
  vns <- mapM agdaVar ivs
  let e = M.fromList (zip ivs vns)
  sl <- render e gl
  sr <- render e gr
  let quant = if null vns then "" else "(" ++ unwords vns ++ " : ℕ) → "
  pure (vns, quant ++ sl ++ " ≡ " ++ sr)

-- WHICH rule had no name.  "A fired rule has no name" is a true report and
-- an unactionable one: it says a lemma is missing without saying which, so
-- the reader's next step is to reconstruct the derivation by hand.  This
-- walks the same four traces `replayClause` walks and returns the rules it
-- would fail on -- the induction hypothesis excepted, in both directions,
-- because that one is the recursive call and never needs a name.
unnamedRules :: LemmaEnv -> Deriv -> [Rule]
unnamedRules lenv d =
  [ rl
  | st <- dBaseL d ++ dBaseR d ++ dStepL d ++ dStepR d
  , let rl = tsRule st
  , rl /= dHyp d, rl /= swap (dHyp d)
  , not (any (`elem` map fst (leLemmas lenv)) [rl, swap rl])
  ]

unionT :: [Int] -> [Int] -> [Int]
unionT a b = foldl (\acc i -> if i `elem` acc then acc else acc ++ [i]) [] (a ++ b)

-- The complete module for one induction.
replayModule :: LemmaEnv -> String -> Deriv -> Maybe String
replayModule lenv modName d = do
  (_, clauses) <- inductionClauses lenv "candidate" d
  pure $ unlines $
    moduleHeader modName (symbolsUsed lenv d) ++ lePreamble lenv ++ clauses

-- Every symbol the module will mention: the goal's, plus every cited
-- lemma's, since a lemma declaration is emitted into the same file.
symbolsUsed :: LemmaEnv -> Deriv -> [String]
symbolsUsed lenv d = nubStr (concatMap symsT terms)
  where
    (gl, gr) = dGoal d
    terms = [gl, gr] ++ concat [ [a, b] | ((a, b), _) <- leLemmas lenv ]
    symsT (V _) = []
    symsT (F f ts) = f : concatMap symsT ts
    nubStr = foldl (\acc s -> if s `elem` acc then acc else acc ++ [s]) []

-- DEMAND-DRIVEN, and for the reason `Certificate.preambleCore` gives: a
-- candidate that never mentions gcd must not pay for typechecking
-- `Cubical.Data.Nat.GCD`, which roughly triples the cost of the call.  The
-- local `max` and `le` are transcribed from the same place, in the same
-- clause order, so a module that renders here renders there.
-- 2026-08-20.  `--guardedness` was added.  This module is deliberately
-- self-contained (see STATUS above) and therefore carries its own copy of the
-- OPTIONS line, which is exactly why it drifted: the copy in
-- `Certificate.preambleCore` had `--guardedness` and this one did not.  Under
-- a cubical library compiled with that flag, Agda's `[InfectiveImport]` rule
-- refuses `open import Cubical.Foundations.Prelude` from a module without it,
-- so EVERY module this file emitted failed at scope-checking and the measured
-- replay reach on Agda 2.8.0 was 0/13 — for a reason with no mathematics in
-- it.  Self-containment is worth its cost and the cost is real: the copy is
-- now checked against `Certificate.kOptionsPragma` by
-- `scripts/EkarupaVikalpa_OneOptionsLineForEveryEmitter.sh`, which fires on
-- the write rather than after the measurement.
moduleHeader :: String -> [String] -> [String]
moduleHeader modName syms =
  [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
  , "module " ++ modName ++ " where"
  , "open import Cubical.Foundations.Prelude"
  , "open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_"
      ++ (if need "-" then " ; _∸_" else "") ++ ")"
  ]
  ++ [ "open import Cubical.Data.Nat.GCD using (gcd)" | need "gcd" ]
  ++ [ l | need "max"
         , l <- [ "max : ℕ → ℕ → ℕ"
                , "max a zero = a"
                , "max zero b = b"
                , "max (suc a) (suc b) = suc (max a b)" ] ]
  ++ [ l | need "le"
         , l <- [ "le : ℕ → ℕ → ℕ"
                , "le zero b = suc zero"
                , "le (suc a) zero = zero"
                , "le (suc a) (suc b) = le a b" ] ]
  where need s = s `elem` syms

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

-- AND WHAT THE ENGINE PROVED BY INDUCTION, PROVED AGAIN THE SAME WAY.
--
-- `addReflLemmas` admits a cited theorem only when the LIBRARY's own
-- computation closes it, so `x = (0+x)` gets in and `(s(x)+y) = s((x+y))`
-- does not -- and a candidate whose proof fires the second falls back to the
-- search, which then cannot close it either.  Measured on the engine's own
-- library snapshot: replay reached 7 of 13, and every miss was "a fired rule
-- has no name".
--
-- The missing lemmas are not unreachable.  Each is a theorem this same
-- engine proved by induction, so each has a trace, so each can be replayed
-- by the machinery already here -- under its own name, with its own two
-- clauses, ahead of the candidate.  That is what this does: fold over the
-- certified theorems IN CERTIFICATION ORDER, and admit each one by
--
--   * `refl`, if the library computes it; else
--   * its own replayed induction, using only the lemmas admitted BEFORE it.
--
-- The order is the whole safety argument.  A lemma may cite only what
-- precedes it, so a proof that fires a not-yet-emitted theorem simply fails
-- to replay and that theorem is left out -- no cycle can form, and nothing
-- is admitted whose own proof this module could not write down.  It is the
-- engine's thesis applied to the certificate: a theorem is an installed
-- transformation, and installation means the next proof may USE it.
-- EACH LEMMA IS RE-DERIVED FROM WHAT PRECEDED IT, not from the rule set as
-- it stands now.  The caller's `rs` already CONTAINS the cited theorems --
-- that is what installing them means -- so deriving lemma i against it lets
-- the lemma fire itself: the trace closes in one step by the very rule being
-- proved, `stepPath` looks that rule up, does not find it (it is not in the
-- environment until after its own declaration), and the lemma is dropped.
-- Circularity did not produce a bad proof, it produced no proof, which is
-- the failure mode this module is built to have.  So the fold carries the
-- rules forward: the theorems, in certification order, are removed from the
-- base and handed back one at a time, each lemma seeing exactly the engine
-- state that proved it.  Both directions are handed back, as `usableRules`
-- does, because `step`'s `decreases` guard is what keeps an unorientable law
-- honest.
addProvedLemmas :: [Rule] -> [((Term, Term), String)] -> LemmaEnv -> LemmaEnv
addProvedLemmas rs ts base = go base baseRules ts
  where
    cited = concat [ [rl, swap rl] | (rl, _) <- ts ]
    baseRules = [ r | r <- rs, r `notElem` cited ]
    go env _ [] = env
    go env avail ((rl, nm) : rest) =
      go (admit env avail rl nm) (avail ++ installed rl) rest
    -- ORIENTED THE WAY THE ENGINE INSTALLED IT.  Handing back both
    -- directions unconditionally is not generosity, it is a different rule
    -- set: the extra direction fires first somewhere and the trace that
    -- comes back is a derivation the engine never ran.  Measured -- with
    -- both directions the fifth lemma emitted eight steps that did not
    -- typecheck, and reach fell from 7/13 to 5/13.  `MathMachine.orient`
    -- keeps only the decreasing direction where there is one, and
    -- `lemmaRules` supplies both only for a law that has none.
    installed rl@(l, r)
      | decreases l r = [rl]
      | decreases r l = [swap rl]
      | otherwise = [rl, swap rl]
    admit env avail rl nm
      | reflProvable rl
      , Just (vs, decl) <- reflDecl nm rl = extend env rl nm vs decl
      | Just (vs, decl) <- inductive env avail nm rl = extend env rl nm vs decl
      | otherwise = env
    extend env rl nm vs decl = env
      { leLemmas = leLemmas env ++ [(rl, (nm, vs))]
      , lePreamble = lePreamble env ++ decl }
    -- every variable is a candidate induction variable, exactly as
    -- `MathMachine.proveByInduction` tries them; the first that replays wins
    inductive env avail nm rl@(l, r) =
      firstJust [ inductionClauses env nm (deriveByInduction avail rl v)
                | v <- varsOfT l `unionT` varsOfT r ]
    firstJust xs = case [ x | Just x <- xs ] of
      (x : _) -> Just x
      [] -> Nothing
    reflDecl nm (l, r) = do
      let vs = varsOfT l `unionT` varsOfT r
      ns <- mapM agdaVar vs
      let e = M.fromList (zip vs ns)
      sl <- render e l
      sr <- render e r
      let quant = if null ns then "" else "(" ++ unwords ns ++ " : ℕ) → "
      pure (vs, [ nm ++ " : " ++ quant ++ sl ++ " ≡ " ++ sr
                , unwords (nm : ns) ++ " = refl" ])

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
  replayModule (addProvedLemmas rs certs (vocabEnv goalSymbols)) modName
               (deriveByInduction rs goal v)
  where
    goalSymbols = symsOf (fst goal) ++ symsOf (snd goal)
    symsOf (V _) = []
    symsOf (F f ts) = f : concatMap symsOf ts

-- THE OTHER FOUR SYMBOLS' DEFINING EQUATIONS, NAMED.
--
-- Widening `render` to monus, max, le and gcd let those theorems be
-- EXPRESSED, and measured on a live size-6 round it changed the number
-- certified by exactly zero -- because expressing the statement is not the
-- problem.  Their derivations fire the defining equations of `max` and `le`,
-- and a fired rule with no name makes the whole replay fall back.  So the
-- renderer change was necessary and not sufficient, and this is the rest.
--
-- Unlike `+` and `*`, these need no proof of their own: the local
-- definitions the module emits ARE the engine's rules, clause for clause
-- (both transcribed from the same `symDefs`), so each defining equation
-- holds by `refl`.  That is the whole reason the argument-order problem that
-- forced `peanoEnv` to prove `addZero` and friends by induction does not
-- arise here.
--
-- ONE OF THEM DID NOT, and it had never been submitted to agda.  `max`'s
-- clauses are
--
--     max a zero = a ; max zero b = b ; max (suc a) (suc b) = suc (max a b)
--
-- and agda compiles them to a case tree that splits on the SECOND argument
-- first, because the first clause is the one that constrains it.  So
-- `max zero b` with `b` neutral does not reduce, and `maxZeroL b = refl` is
-- refused: `max zero b != b of type ℕ`.  The EQUATION is true — it is the
-- engine's own defining rule and it holds in every instance — and only its
-- one-line proof was wrong.  Splitting `b` gives both instances back
-- (`max zero zero` takes clause one, `max zero (suc b)` takes clause two), so
-- the repair is a case split and not an import, and `maxZeroL` stays a lemma
-- this module proved rather than one it cited.
--
-- Nothing had caught it because nothing had asked: `main`'s snapshot fragment
-- is {0,s,+,*} and emits no `max` block at all, and the shape search cannot
-- close a `max` theorem, so this declaration had been emitted only into
-- modules that were failing for another reason.  Found 2026-08-20 by
-- transcribing `max(x,y) + 0 = max(x + 0, y + 0)`, whose proof does not use
-- `maxZeroL` — the block is emitted whole, so one bad declaration in it
-- refuses every module that mentions `max`.  Note B in `Certificate.hs`
-- records the same case tree from the other side.
--
-- Gated on the goal's symbols, because the declarations mention `max` and
-- `le`, and those are only in scope when `moduleHeader` emitted them.
vocabEnv :: [String] -> LemmaEnv
vocabEnv syms = LemmaEnv
  { leLemmas = leLemmas peanoEnv ++ extraLemmas
  , lePreamble = lePreamble peanoEnv ++ extraPreamble
  }
  where
    need s = s `elem` syms
    a0 = V 0
    b0 = V 1
    maxT p q = F "max" [p, q]
    leT p q = F "le" [p, q]
    one = sucT zeroT
    whenNeeded s xs = if need s then xs else []
    extraLemmas =
      whenNeeded "max"
        [ ((maxT a0 zeroT, a0),                    ("maxZeroR", [0]))
        , ((maxT zeroT b0, b0),                    ("maxZeroL", [1]))
        , ((maxT (sucT a0) (sucT b0), sucT (maxT a0 b0)), ("maxSuc", [0,1]))
        ]
      ++ whenNeeded "le"
        [ ((leT zeroT b0, one),                    ("leZeroL", [1]))
        , ((leT (sucT a0) zeroT, zeroT),           ("leSucZero", [0]))
        , ((leT (sucT a0) (sucT b0), leT a0 b0),   ("leSuc", [0,1]))
        ]
    extraPreamble =
      whenNeeded "max"
        [ "maxZeroR : (a : ℕ) → (max (a) (zero)) ≡ a"
        , "maxZeroR a = refl"
        , "maxZeroL : (b : ℕ) → (max (zero) (b)) ≡ b"
          -- NOT `maxZeroL b = refl`; see the note above this function.  The
          -- case tree splits on the second argument, so the two instances
          -- reduce and the general term does not.
        , "maxZeroL zero = refl"
        , "maxZeroL (suc b) = refl"
        , "maxSuc : (a b : ℕ) → (max (suc (a)) (suc (b))) ≡ suc ((max (a) (b)))"
        , "maxSuc a b = refl"
        ]
      ++ whenNeeded "le"
        [ "leZeroL : (b : ℕ) → (le (zero) (b)) ≡ suc (zero)"
        , "leZeroL b = refl"
        , "leSucZero : (a : ℕ) → (le (suc (a)) (zero)) ≡ zero"
        , "leSucZero a = refl"
        , "leSuc : (a b : ℕ) → (le (suc (a)) (suc (b))) ≡ (le (a) (b))"
        , "leSuc a b = refl"
        ]

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
      -- AND THE FOURTH DETAIL, ADDED 2026-08-20.  The three above are what
      -- this copy carried across; what it left behind is the FITNESS.  Both
      -- callers read `ExitSuccess` and nothing else, so under a wrapper of
      -- the shape `agda "$@" 2>&1 | cat` this module reported a replayed
      -- derivation as checked while agda's own `1 != 0` sat in `out`.
      -- `Certificate.vetForeignRun` is the per-call output scan and the
      -- per-process falsifier, for a caller that launched agda itself.
      C.vetForeignRun root code (out ++ err))
    `finally` removePathForcibly dir

-- Build a Deriv the way the engine does: substitute, normalise both sides
-- of each clause with the tracing rewriter, and keep the traces.
deriveByInduction :: [Rule] -> (Term,Term) -> Int -> Deriv
deriveByInduction rs goal@(l,r) v =
  -- Four traces and two indices, and nothing else.  `dHyp`, `dBaseMet` and
  -- `dStepMet` used to be written here; all three are functions of what is
  -- left, so they are read off the record now instead (see `dEnds`).
  Deriv { dGoal = goal
        , dVar = v
        , dBaseL = snd (normalizeTrace rs bl)
        , dBaseR = snd (normalizeTrace rs br)
        , dStepL = snd (normalizeTrace (hyps ++ rs) gl)
        , dStepR = snd (normalizeTrace (hyps ++ rs) gr)
        }
  where
    eig = F "#" []
    subst = substVar
    (bl, br) = (subst v zeroT l, subst v zeroT r)
    hypL = subst v eig l
    hypR = subst v eig r
    (gl, gr) = (subst v (sucT eig) l, subst v (sucT eig) r)
    hyps = [(hypL,hypR),(hypR,hypL)]

-- THE SNAPSHOT, in order, restricted to the {0,s,+,*} fragment this module
-- renders.  These are exactly the lines of machine/library.snapshot.txt over
-- those symbols, with the induction variable the engine recorded.  Processed
-- IN ORDER and accumulating, because that is how the engine met them: each
-- certified theorem becomes both a rewrite rule for the next proof and a
-- citable lemma for the next certificate.
--
-- The comparable number is Certificate's search on the same file, measured
-- in machine/CERTIFICATE_REACH.md: 15 of 28 overall.
snapshotFragment :: [((Term,Term), Int)]
snapshotFragment =
  [ ((x0,                                   binT "+" zeroT x0),                 0)
  , ((sucT x0,                              binT "+" (sucT zeroT) x0),          0)
  , ((binT "+" (sucT x0) y0,                sucT (binT "+" x0 y0)),             1)
  , ((binT "+" x0 y0,                       binT "+" y0 x0),                    0)
  , ((binT "+" x0 (binT "+" x0 y0),         binT "+" y0 (binT "+" x0 x0)),      1)
  , ((binT "+" x0 (binT "+" y0 y0),         binT "+" y0 (binT "+" x0 y0)),      0)
  , ((zeroT,                                binT "*" zeroT x0),                 0)
  , ((x0,                                   binT "*" (sucT zeroT) x0),          0)
  , ((binT "*" (sucT x0) y0,                binT "+" y0 (binT "*" x0 y0)),      1)
  , ((binT "*" (sucT x0) y0,                binT "+" y0 (binT "*" y0 x0)),      0)
  , ((binT "*" x0 (binT "*" x0 y0),         binT "*" x0 (binT "*" y0 x0)),      0)
  , ((sucT (sucT (binT "*" x0 y0)),         sucT (sucT (binT "*" y0 x0))),      0)
  , ((binT "*" x0 y0,                       binT "*" y0 x0),                    0)
  ]

-- Replay the fragment the way the engine meets it: in order, with every
-- theorem already accepted available BOTH as a rewrite rule and as a citable
-- lemma.  Reports how far transcription reaches where search reached 15/28.
measureSnapshot :: FilePath -> IO (Int, Int, Int, Int)
measureSnapshot root = go peanoRules [] 0 0 0 snapshotFragment
  where
    -- `closed` counts the fragment members whose derivation ACTUALLY CLOSES
    -- under the rule set this harness can reconstruct.  It is the honest
    -- denominator: a member whose two clause traces never meet was not
    -- proved here, so replay declining to emit a certificate for it is
    -- correct behaviour and not a miss.  Reporting only `ok/13` charges
    -- transcription for derivations that were never available to it.
    go _ _ ok calls closed [] = pure (ok, length snapshotFragment, calls, closed)
    go rules certs ok calls closed (((l,r), v) : rest) = do
      let named = [ (rl, "lem" ++ show i) | (i, rl) <- zip [(0::Int)..] certs ]
          d = deriveByInduction rules (l,r) v
      case replayModule (addProvedLemmas rules named peanoEnv) "Candidate" d of
        Nothing -> do
          let env = addProvedLemmas rules named peanoEnv
              missing = unnamedRules env d
              closes = if dBaseMet d && dStepMet d then 1 else 0
              why | closes == 0 = "the clause traces do not meet"
                  | ((a,b) : _) <- missing =
                      "no name for " ++ show a ++ " -> " ++ show b
                  | otherwise = "a lemma declaration did not render"
          printf "  no-replay  %-42s (%s)\n" (show l ++ " = " ++ show r) why
          go rules certs ok calls (closed + closes) rest
        Just src -> do
          (code, out) <- runAgda root src
          case code of
            ExitSuccess -> do
              printf "  OK         %-42s %d steps, 1 agda call\n"
                (show l ++ " = " ++ show r)
                (length (dBaseL d) + length (dBaseR d)
                 + length (dStepL d) + length (dStepR d))
              -- accepted: it joins the rule set AND the citable lemmas,
              -- which is the engine's own thesis applied to certificates
              go (rules ++ [(l,r)]) (certs ++ [(l,r)]) (ok+1) (calls+1) (closed+1) rest
            ExitFailure _ -> do
              -- keep the module, or the reader is left with a line number
              -- for a file in a temp directory that no longer exists
              let path = "/tmp/trace-replay-fail-" ++ show ok ++ ".agda"
              writeFile path src
              printf "  NO         %-42s %s\n    (module kept at %s)\n"
                (show l ++ " = " ++ show r)
                (take 90 (firstInformative (unlines (drop 1 (lines out)))))
                path
              go rules certs ok (calls+1) (closed+1) rest
    firstInformative s = case filter inf (lines s) of
                           (l:_) -> unwords (words l)
                           [] -> "(agda said nothing)"
    inf ln = not (null (dropWhile isSpace ln))
             && not ("Checking " `isPrefixOf` dropWhile isSpace ln)

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
  putStrLn "== the engine's library snapshot, {0,s,+,*} fragment, in order =="
  (sok, stot, scalls, sclosed) <- measureSnapshot root
  printf "\nreplay reaches %d/%d of the fragment in %d agda calls\n"
    sok stot scalls
  printf "and %d/%d of the derivations that CLOSE here (the other %d never meet:\n"
    sok sclosed (stot - sclosed)
  printf " this harness reconstructs only the {0,s,+,*} rules, so those proofs\n"
  printf " were not available to transcribe -- declining them is correct)\n"
  putStrLn "(Certificate's shape search on the same file: 15/28 overall,"
  putStrLn " worst case 12 agda calls for ONE candidate.)"
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
