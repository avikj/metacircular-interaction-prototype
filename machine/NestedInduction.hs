-- NestedInduction.hs — a two-variable / nested structural-induction prover
-- for MathMachine's Term algebra.
--
-- WHY THIS MODULE EXISTS
--
-- MathMachine's step 5 (`proveByInduction`, MathMachine.hs ~1114) proves a
-- survivor by (a) rewriting to normal form, and if that is stuck, (b)
-- structural induction on ONE variable, using its earlier theorems as the
-- step's rewrite lemmas.  That is exactly enough for the laws whose step
-- case, after one round of unfolding, either closes by rewriting or matches
-- the induction hypothesis directly.  It is NOT enough for the
-- distributivity-class laws, whose base or step case is itself an equation
-- that needs an induction of its own.
--
-- This module builds the missing capability as a STANDALONE prover.  It does
-- not edit MathMachine.hs and does not import it (MathMachine is `module
-- Main`); like Certificate.hs it carries its own faithful copy of the Term
-- type and the rewrite engine, so it can be compiled, run and tested on its
-- own.  The rewrite engine below (`match`, `applySub`, `step`, `normalize`,
-- `lpo`, `precedence`, `cmpTerm`, `decreases`) is transcribed line-for-line
-- from MathMachine.hs so that "proved here" means the same thing as "proved
-- there".
--
-- WHAT "NESTED" MEANS HERE, precisely
--
--   `prove` is recursive.  To discharge an equation it first tries
--   rewriting; failing that it picks an induction variable v, and proves
--   BOTH the base case (v := 0) and the step case (v := s #, with the
--   induction hypothesis installed as an extra rewrite in both directions)
--   by CALLING ITSELF.  Because the recursive call may in turn choose a
--   DIFFERENT variable, the search covers:
--
--     * plain rewriting                                 (depth 0)
--     * single-variable induction                       (one Induct node)
--     * induction-inside-a-step / nested induction      (Induct under Induct)
--
--   Each induction level freezes its variable to a DISTINCT eigenconstant
--   `#k` (k = the level), so an inner induction never collides with the
--   frozen outer one, and a hypothesis can only ever fire at the exact
--   instance it is about (MathMachine.hs ~1106).
--
-- THE HONEST DECOMPOSITION (a finding, stated up front)
--
--   For + and · over ℕ with structural recursion, the two-variable laws do
--   NOT need irreducible two-level nesting: each decomposes into a CHAIN of
--   single-variable inductions, where an earlier lemma is a rewrite for the
--   next proof.  This is a theorem, not a measurement — every induction over
--   ℕ can be lifted out of a step into a named lemma — and it is exactly the
--   architecture MathMachine already uses ("earlier theorems as the step's
--   lemmas").  So the driver below feeds the prover the natural lemma DAG (the
--   conjectures the machine's step 3 would generate) and reports, for each
--   law, which technique actually closed it and how deep the proof tree got.
--   `prove` is genuinely nested-capable and the search exercises that path;
--   the report says truthfully where it was and was not needed.
--
-- BUILD / RUN (from the repository root):
--
--     ghc -O0 -Wall -main-is NestedInduction.main \
--         -outputdir /tmp/ni-build -o /tmp/ni machine/NestedInduction.hs
--     /tmp/ni
--
-- It prints the lemma DAG, the proof tree of each law, and writes one Agda
-- candidate module per proved law under machine/nested-agda/ .

module NestedInduction
  ( Term(..)
  , Rule
  , Equation
  , normalize
  , prove
  , Proof(..)
  , proveInOrder
  , main
  ) where

import Data.List (intercalate, nub)
import qualified Data.Map.Strict as M
import System.Directory (createDirectoryIfMissing)
import System.FilePath ((</>))
import System.IO

-- ==================================================================== terms
-- Mirrors MathMachine's `data Term = V !Int | F !String [Term]`.

data Term = V !Int | F !String [Term] deriving (Eq, Ord)

type Rule = (Term, Term)
type Equation = (Term, Term)

instance Show Term where
  show (V i) | i >= 0 && i < 6 = [ "xyzuvw" !! i ]
             | otherwise = "n" ++ show i
  show (F f []) = f
  show (F f [a,b])
    | f `elem` ["+","*","^","gcd","max"] = "(" ++ show a ++ f ++ show b ++ ")"
  show (F f as) = f ++ "(" ++ intercalate "," (map show as) ++ ")"

size :: Term -> Int
size (V _) = 1
size (F _ ts) = 1 + sum (map size ts)

vars :: Term -> [Int]
vars (V i) = [i]
vars (F _ ts) = concatMap vars ts

zeroT :: Term
zeroT = F "0" []

sucT :: Term -> Term
sucT t = F "s" [t]

bin :: String -> Term -> Term -> Term
bin f a b = F f [a,b]

substVar :: Int -> Term -> Term -> Term
substVar i u (V j) = if i == j then u else V j
substVar i u (F f ts) = F f (map (substVar i u) ts)

-- ================================================== the rewrite engine
-- Transcribed from MathMachine.hs.  Keeping it identical is the whole point:
-- a proof accepted here is a proof the engine would accept.

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

-- one rewrite step, innermost-leftmost.
step :: [Rule] -> Term -> Maybe Term
step rs t =
  case t of
    F f ts -> case rewriteArgs ts of
                Just ts' -> Just (F f ts')
                Nothing  -> topStep t
    _ -> topStep t
  where
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

-- Precedence over a small vocabulary: 0 < s < + < * .  Everything the engine
-- does not know (eigenconstants `#k`, invented names) sits BELOW 0, so that
-- rewriting always folds toward the defined symbols and eigenconstants never
-- outrank a real operator.  (MathMachine.hs ~1049.)
precedence :: String -> Int
precedence f = case lookup f (zip vocab [0..]) of
  Just i  -> i
  Nothing -> -1
  where vocab = ["0","s","+","*"]

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

normalize :: [Rule] -> Term -> Term
normalize rs = go (400 :: Int)
  where
    go 0 t = t
    go k t = case step rs t of
               Nothing -> t
               Just t' -> go (k-1) t'

provedByRewriting :: [Rule] -> Equation -> Bool
provedByRewriting rs (l,r) = normalize rs l == normalize rs r

-- ============================================ the defining equations
-- Standard Peano.  BOTH operations recurse on the FIRST argument, which is
-- the convention Agda's Cubical.Data.Nat._+_ and _·_ use, so the emitted
-- certificates line up with the builtins (see Certificate.hs, note A).
--
--   +:   0 + y = y            *:   0 · y = 0
--        s x + y = s (x + y)       s x · y = y + x · y
--
-- These are the ONLY axioms the prover is given.  Every law below is proved
-- from them (plus lemmas the prover itself discharges).

defsPlus :: [Rule]
defsPlus =
  [ (bin "+" zeroT y_,        y_)
  , (bin "+" (sucT x_) y_,    sucT (bin "+" x_ y_)) ]

defsTimes :: [Rule]
defsTimes =
  [ (bin "*" zeroT y_,        zeroT)
  , (bin "*" (sucT x_) y_,    bin "+" y_ (bin "*" x_ y_)) ]

x_, y_, z_ :: Term
x_ = V 0
y_ = V 1
z_ = V 2

-- =============================================== the nested prover

data Proof
  = Rewrite Equation
  | Induct Int Equation Proof Proof   -- ^ variable, goal, base proof, step proof

-- The eigenconstant for induction LEVEL k: a nullary symbol nothing else
-- mentions, distinct per level so a nested induction cannot collide with the
-- frozen outer variable.
eigen :: Int -> Term
eigen k = F ("#" ++ show k) []

-- prove budget level rules eq
--   budget : remaining induction depth (bounds nesting)
--   level  : current nesting level, names the eigenconstant
prove :: Int -> Int -> [Rule] -> Equation -> Maybe Proof
prove budget level rs eq@(l,r)
  | provedByRewriting rs eq = Just (Rewrite eq)
  | budget <= 0             = Nothing
  | otherwise               = firstJust [ tryVar v | v <- ordVars ]
  where
    ordVars = nub (vars l ++ vars r)
    firstJust xs = case [ p | Just p <- xs ] of { (p:_) -> Just p; [] -> Nothing }
    tryVar v =
      let base = (substVar v zeroT l, substVar v zeroT r)
          k    = eigen level
          hypL = substVar v k l
          hypR = substVar v k r
          hyps = [(hypL,hypR),(hypR,hypL)]   -- IH both ways; fires only where it shrinks
          goal = (substVar v (sucT k) l, substVar v (sucT k) r)
      in do bp <- prove (budget-1) (level+1) rs base
            sp <- prove (budget-1) (level+1) (hyps ++ rs) goal
            Just (Induct v eq bp sp)

-- The maximum nesting depth of Induct nodes (0 = pure rewrite).
proofDepth :: Proof -> Int
proofDepth (Rewrite _) = 0
proofDepth (Induct _ _ b s) = 1 + max (proofDepth b) (proofDepth s)

-- Total number of Induct nodes (how many separate inductions the proof used).
inductionCount :: Proof -> Int
inductionCount (Rewrite _) = 0
inductionCount (Induct _ _ b s) = 1 + inductionCount b + inductionCount s

-- A one-line technique label for the report.
technique :: Proof -> String
technique p = case proofDepth p of
  0 -> "rewriting only"
  1 -> "single-variable induction"
  d -> "nested induction (depth " ++ show d ++ ")"

-- Pretty-print the proof tree.
renderProof :: Proof -> [String]
renderProof = go 0
  where
    ind n = replicate (2*n) ' '
    go n (Rewrite eq) =
      [ ind n ++ "rewrite: " ++ showEq eq ++ "  [both sides -> same normal form]" ]
    go n (Induct v eq b s) =
      [ ind n ++ "induction on " ++ show (V v) ++ ": " ++ showEq eq
      , ind n ++ "  base (" ++ show (V v) ++ " := 0):" ]
      ++ go (n+2) b
      ++ [ ind n ++ "  step (" ++ show (V v) ++ " := s " ++ show (V v)
             ++ "), IH added as rewrite:" ]
      ++ go (n+2) s

showEq :: Equation -> String
showEq (l,r) = show l ++ " = " ++ show r

-- =============================================== semantic firewall
-- A conjectured lemma is checked against the true ℕ semantics on a spread of
-- assignments before the prover is allowed to spend a proof on it, and (more
-- importantly) before it can be installed as a rewrite.  Passing is not a
-- proof; FAILING is a proof that the search must not start (MathMachine.hs
-- ~690, the definition firewall).  A false lemma installed as a rewrite would
-- make every later "proof" worthless.

evalN :: [Integer] -> Term -> Integer
evalN env (V i) = env !! i
evalN _ (F "0" []) = 0
evalN env (F "s" [t]) = evalN env t + 1
evalN env (F "+" [a,b]) = evalN env a + evalN env b
evalN env (F "*" [a,b]) = evalN env a * evalN env b
evalN _ t = error ("evalN: unsupported term " ++ show t)

-- deterministic small assignments (reproducible; no system entropy).
sampleEnvs :: Int -> [[Integer]]
sampleEnvs nv = [ [ fromIntegral ((i*7 + j*3 + 1) `mod` 6) | j <- [0..nv-1] ]
                | i <- [0..40] ]

semanticallyTrue :: Equation -> Bool
semanticallyTrue (l,r) =
  let nv = 1 + maximum (0 : vars l ++ vars r)
  in all (\e -> evalN e l == evalN e r) (sampleEnvs nv)

-- =============================================== the lemma-DAG driver
-- The machine's step 3 conjectures equations; step 5 proves the survivors and
-- installs each as a rewrite.  This driver plays step 3 for the classical
-- arithmetic laws by supplying the conjectures in dependency order, and plays
-- step 5 with the nested prover.  Each proved law is oriented (if it can be)
-- and added to the rewrite set for the laws that follow it — this is the
-- "earlier theorems as lemmas" mechanism, made explicit.

-- Orientation for installing a proved law as a rewrite (MathMachine.hs ~1080).
-- An unorientable law (commutativity) is installed BOTH ways; `step` fires it
-- only where it strictly shrinks the term, so this stays terminating.
installRules :: Equation -> [Rule]
installRules (l,r)
  | l == r = []
  | lpo l r, vars r `subsetOf` vars l = [(l,r)]
  | lpo r l, vars l `subsetOf` vars r = [(r,l)]
  | otherwise = [(l,r),(r,l)]
  where subsetOf a b = all (`elem` b) a

data Attempt = Attempt
  { atName    :: String
  , atEq      :: Equation
  , atProof   :: Maybe Proof
  }

-- Prove a list of conjectures in order, threading the growing rule set.
proveInOrder :: [Rule] -> [(String,Equation)] -> [(Attempt, [Rule])]
proveInOrder rs0 = go rs0
  where
    budget = 3
    go _  [] = []
    go rs ((nm,eq):rest) =
      let firewalled = semanticallyTrue eq
          mp = if firewalled then prove budget 0 rs eq else Nothing
          rs' = case mp of { Just _ -> rs ++ installRules eq; Nothing -> rs }
      in (Attempt nm eq mp, rs') : go rs' rest

-- =============================================== Agda emission
-- One candidate module per proved law, for the gate another agent owns.  The
-- operations are Agda's builtins (first-argument recursion, matching the defs
-- above), so the certificate is about the same functions.  The proof shape is
-- an induction skeleton on the machine's chosen outer variable — the same
-- kind of skeleton Certificate.hs emits — with a small menu of step shapes in
-- a comment; the gate tries them.  We emit the text; we do not run agda.

agdaVar :: Int -> String
agdaVar i = [ "xyzuvw" !! i ]

agdaTerm :: Term -> String
agdaTerm (V i) = agdaVar i
agdaTerm (F "0" []) = "zero"
agdaTerm (F "s" [t]) = "(suc " ++ agdaTerm t ++ ")"
agdaTerm (F "+" [a,b]) = "(" ++ agdaTerm a ++ " + " ++ agdaTerm b ++ ")"
agdaTerm (F "*" [a,b]) = "(" ++ agdaTerm a ++ " · " ++ agdaTerm b ++ ")"
agdaTerm t = error ("agdaTerm: unsupported " ++ show t)

telescope :: [Int] -> String
telescope [] = ""
telescope vs = "(" ++ unwords (map agdaVar vs) ++ " : ℕ) → "

-- The outer induction variable actually used by the proof, if any.
proofVar :: Proof -> Maybe Int
proofVar (Rewrite _) = Nothing
proofVar (Induct v _ _ _) = Just v

emitAgda :: String -> Equation -> Proof -> String
emitAgda modName (l,r) proof = unlines $
  [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
  , "module " ++ modName ++ " where"
  , "open import Cubical.Foundations.Prelude"
  , "open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)"
  , "-- CANDIDATE module for the gate (Certificate.hs owns the checker)."
  , "-- The `candidate` clause below is the SHAPE the machine's rewrite proof"
  , "-- induces; the gate confirms it or substitutes a step shape from its menu"
  , "-- (refl / cong suc ih / ih / cong (k +_) ih ...).  Laws that the machine"
  , "-- proved using earlier lemmas of the DAG presuppose those lemma modules"
  , "-- in scope; this text does not claim to typecheck standalone over the raw"
  , "-- builtins.  Agda's _+_ and _·_ recurse on the first argument, matching"
  , "-- the axioms the machine used, so the certificate is about the same"
  , "-- functions."
  , "-- Machine proof: " ++ technique proof
  , "-- Proof tree:" ]
  ++ map ("--   " ++) (renderProof proof)
  ++ case proofVar proof of
       Nothing ->
         [ "candidate : " ++ telescope allVars ++ agdaTerm l ++ " ≡ " ++ agdaTerm r
         , "candidate " ++ unwords (map agdaVar allVars) ++ " = refl" ]
       Just v ->
         let nv = agdaVar v
             pat u = unwords [ if i == v then u else agdaVar i | i <- allVars ]
             ihArgs = unwords (map agdaVar allVars)
         in [ "-- Gate: try step RHS in { refl ; cong suc (candidate " ++ ihArgs
                ++ ") ; candidate " ++ ihArgs ++ " }"
            , "candidate : " ++ telescope allVars ++ agdaTerm l ++ " ≡ " ++ agdaTerm r
            , "candidate " ++ pat "zero" ++ " = refl"
            , "candidate " ++ pat ("(suc " ++ nv ++ ")") ++ " = cong suc (candidate "
                ++ ihArgs ++ ")" ]
  where
    allVars = nub (vars l ++ vars r)

-- =============================================== the demonstration

-- The lemma DAG for +, in dependency order, then ·.
plusLemmas :: [(String,Equation)]
plusLemmas =
  [ ("+-right-id   x + 0 = x",         (bin "+" x_ zeroT, x_))
  , ("+-right-suc  x + s y = s(x+y)",  (bin "+" x_ (sucT y_), sucT (bin "+" x_ y_)))
  , ("+-assoc      (x+y)+z = x+(y+z)", (bin "+" (bin "+" x_ y_) z_,
                                        bin "+" x_ (bin "+" y_ z_)))
  , ("+-comm       x + y = y + x",     (bin "+" x_ y_, bin "+" y_ x_))
  , ("+-left-swap  x+(y+z) = y+(x+z)", (bin "+" x_ (bin "+" y_ z_),
                                        bin "+" y_ (bin "+" x_ z_)))
  ]

timesLemmas :: [(String,Equation)]
timesLemmas =
  [ ("*-right-zero x · 0 = 0",         (bin "*" x_ zeroT, zeroT))
  , ("*-right-suc  x · s y = x + x·y", (bin "*" x_ (sucT y_), bin "+" x_ (bin "*" x_ y_)))
  , ("interchange  (a+b)+(c+d)=(a+c)+(b+d)",
        (bin "+" (bin "+" (V 0) (V 1)) (bin "+" (V 2) (V 3)),
         bin "+" (bin "+" (V 0) (V 2)) (bin "+" (V 1) (V 3))))
  , ("distrib-L    x·(y+z) = x·y + x·z",
        (bin "*" x_ (bin "+" y_ z_),
         bin "+" (bin "*" x_ y_) (bin "*" x_ z_)))
  ]

-- The single-variable prover, for the head-to-head comparison: exactly
-- MathMachine's proveByInduction restricted to depth 1 (rewrite, or ONE
-- induction whose base and step BOTH close by rewriting).
flatProvable :: [Rule] -> Equation -> Bool
flatProvable rs eq = case prove 1 0 rs eq of { Just _ -> True; Nothing -> False }

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetBuffering stdout LineBuffering
  putStrLn "NestedInduction — two-variable / nested induction prover"
  putStrLn "========================================================"
  putStrLn ""
  putStrLn "Axioms (standard Peano, first-argument recursion, = Agda's builtins):"
  putStrLn "  0 + y = y      s x + y = s (x + y)"
  putStrLn "  0 · y = 0      s x · y = y + x · y"
  putStrLn ""

  -- ---- head-to-head: what single-variable induction alone can do -------
  putStrLn "== single-variable induction alone, from the raw axioms =="
  let rawPlus = defsPlus
  mapM_ (\(nm,eq) ->
            putStrLn ("  " ++ (if flatProvable rawPlus eq then "PROVES " else "STUCK  ")
                          ++ nm))
        plusLemmas
  putStrLn "  (STUCK = no single variable closes both base and step by rewriting;"
  putStrLn "   these are the laws that need lemmas / nesting.)"
  putStrLn ""

  -- ---- capability probe: the nested search, from the raw axioms ---------
  -- The prover is recursive: a step case is itself handed back to `prove`,
  -- which may induct on a second variable (nested induction).  This probe
  -- runs that full search (budget 3) on +-comm with ONLY the two + axioms
  -- installed, to show what nesting alone can and cannot reach.
  putStrLn "== capability probe: full nested search on +-comm from raw axioms =="
  let commEq = (bin "+" x_ y_, bin "+" y_ x_)
  case prove 3 0 defsPlus commEq of
    Just p  -> do putStrLn "  nested search CLOSED it:"
                  mapM_ (\ln -> putStrLn ("    " ++ ln)) (renderProof p)
    Nothing -> do
      putStrLn "  nested search does NOT close +-comm from the two + axioms alone."
      putStrLn "  Reason (a theorem, not a measurement): the step case s#+y = y+s#"
      putStrLn "  needs y+s# to reduce, i.e. the fact  n + s m = s (n + m), and the"
      putStrLn "  base needs  n + 0 = n.  Both are single-variable inductions on a"
      putStrLn "  GENERAL variable; inside a nested step that variable is already"
      putStrLn "  frozen to a constant, so they cannot be re-derived in place.  Over"
      putStrLn "  N these facts must be proved as lemmas FIRST — which is exactly the"
      putStrLn "  'earlier theorems as the step's lemmas' architecture.  The driver"
      putStrLn "  below supplies that lemma DAG and the prover discharges each."
  putStrLn ""

  -- ---- the driver: + lemma DAG ----------------------------------------
  putStrLn "== nested prover + lemma DAG:  addition =="
  let plusRuns = proveInOrder defsPlus plusLemmas
  finalPlusRules <- reportRuns defsPlus plusRuns
  putStrLn ""

  -- ---- the driver: · lemma DAG (uses the + laws just proved) -----------
  putStrLn "== nested prover + lemma DAG:  multiplication =="
  let timesRuns = proveInOrder (finalPlusRules ++ defsTimes) timesLemmas
  _ <- reportRuns (finalPlusRules ++ defsTimes) timesRuns
  putStrLn ""

  -- ---- Agda emission ---------------------------------------------------
  let outDir = "machine" </> "nested-agda"
  createDirectoryIfMissing True outDir
  let allAttempts = map fst plusRuns ++ map fst timesRuns
      proved = [ (a, p) | a <- allAttempts, Just p <- [atProof a] ]
  putStrLn ("== Agda emission (" ++ show (length proved) ++ " modules -> " ++ outDir ++ ") ==")
  mapM_ (\(a,p) -> do
            let modName = agdaModName (atName a)
                path = outDir </> (modName ++ ".agda")
                txt = emitAgda modName (atEq a) p
            writeFileUtf8 path txt
            putStrLn ("  wrote " ++ path))
        proved
  putStrLn ""

  -- ---- summary ---------------------------------------------------------
  let provedNames = [ atName a | a <- allAttempts, Just _ <- [atProof a] ]
      failedNames = [ atName a | a <- allAttempts, Nothing <- [atProof a] ]
  putStrLn "== SUMMARY =="
  putStrLn ("  proved: " ++ show (length provedNames) ++ " / "
              ++ show (length allAttempts))
  mapM_ (\n -> putStrLn ("    OK   " ++ n)) provedNames
  mapM_ (\n -> putStrLn ("    FAIL " ++ n)) failedNames

reportRuns :: [Rule] -> [(Attempt,[Rule])] -> IO [Rule]
reportRuns rs0 runs = do
  mapM_ report runs
  pure (case reverse runs of { ((_,rs):_) -> rs; [] -> rs0 })
  where
    report (a, _) = do
      putStrLn ("  " ++ atName a)
      case atProof a of
        Nothing -> putStrLn "     -> NOT PROVED (firewall or search exhausted)"
        Just p  -> do
          putStrLn ("     -> " ++ technique p
                        ++ ", " ++ show (inductionCount p) ++ " induction(s)")
          mapM_ (\ln -> putStrLn ("       " ++ ln)) (renderProof p)

agdaModName :: String -> String
agdaModName = ("Nested_" ++) . concatMap clean . takeWhile (/= ' ')
  where clean '+' = "Plus"
        clean '*' = "Mul"
        clean '-' = "_"
        clean c   = if c `elem` ("·()=" :: String) then "_" else [c]

writeFileUtf8 :: FilePath -> String -> IO ()
writeFileUtf8 path s = withFile path WriteMode $ \h -> do
  hSetEncoding h utf8
  hPutStr h s
