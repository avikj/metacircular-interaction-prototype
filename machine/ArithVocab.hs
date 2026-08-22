-- ArithVocab — an arithmetic vocabulary extension for the natural machine.
--
-- MathMachine.hs generates over {0, s, +, *, max, -, gcd, le}.  Its own
-- header records that gcd is admitted to the term space but that only its
-- SOUND base cases (gcd x 0 = x, gcd 0 x = x) reach the proof kernel: the
-- Euclidean step gcd a b = gcd b (a mod b) could not be stated, because the
-- language had no `mod`.  The corpus's live arithmetic — prime-pair fields,
-- p-adic valuations v_p, gcd descent — needs exactly that missing operation.
--
-- This module is a DROP-IN vocabulary extension.  It deliberately mirrors
-- MathMachine's Term algebra and rewrite interface byte-for-byte (Term, Sym,
-- eval, match/applySub, step/normalize, cmpTerm/lpo/precedence, orient), so
-- the generators below (`gcdSym`, `modSym`, `lcmSym`, `vpSym`) are the same
-- kind of object as the entries in MathMachine's `vocabulary` list and could
-- be appended to it without translation.  It is standalone (its own module,
-- its own `main`) because MathMachine is `module Main` and two `main`s cannot
-- share one program; nothing here is edited into MathMachine.
--
-- What it adds:
--   * gcd, mod, lcm as binary symbols; v_p (p-adic valuation at a fixed
--     prime) as a nontrivial derived unary symbol.  Each carries an EXACT
--     integer evaluator, so refutation is by computation, never by fit.
--   * the known defining rewrites, in the machine's Rule = (Term,Term)
--     format, with an honest orientability report (a defining recurrence is
--     not automatically a terminating rewrite).
--   * a self-test `main` that runs MathMachine's own loop shape — generate,
--     normalize, fingerprint, conjecture-by-agreement, refute-by-computation
--     — over this vocabulary, and then adjudicates a curated list of
--     classical identities.
--
-- PROTOCOL NOTE (CLAUDE.md).  Every identity checked here is a classical
-- theorem with a one-line proof; the machine does not DISCOVER them, it
-- PROPOSES and REFUTES them.  All evaluation is exact integer arithmetic, so
-- each refutation below is a certificate (a concrete counterexample), not a
-- correlation.  The conventions that make the laws total over ℕ (a mod 0 = a,
-- lcm 0 0 = 0, v_p 0 = 0) are stated at each evaluator, because — as the
-- valuation additivity law demonstrates — a boundary convention decides
-- whether a law survives.

module ArithVocab where

import qualified Data.Map.Strict as M
import Data.List (sortOn, foldl', intercalate)
import Text.Printf (printf)
import System.Exit (exitFailure, exitSuccess)
import qualified Prastara_TheSearchSpaceIsGeneratedNotStored as P

-- ============================================================ Term algebra
-- Copied verbatim from MathMachine.hs so this module's terms ARE its terms.

data Term = V !Int | F !String [Term] deriving (Eq, Ord)

instance Show Term where
  show = showTerm

showTerm :: Term -> String
showTerm (V i) | i >= 0 && i < 6 = [ "xyzuvw" !! i ]
               | otherwise       = "n" ++ show i
showTerm (F f []) = f
showTerm (F f [a,b])
  | f `elem` ["+","*","^","gcd","max","lcm","mod"] =
      "(" ++ showTerm a ++ f ++ showTerm b ++ ")"
showTerm (F f as) = f ++ "(" ++ intercalate "," (map showTerm as) ++ ")"

size :: Term -> Int
size (V _) = 1
size (F _ ts) = 1 + sum (map size ts)

vars :: Term -> [Int]
vars (V i) = [i]
vars (F _ ts) = concatMap vars ts

subsetOf :: [Int] -> [Int] -> Bool
subsetOf a b = all (`elem` b) a

symbolsIn :: Term -> [String]
symbolsIn (V _) = []
symbolsIn (F f ts) = f : concatMap symbolsIn ts

ordNub :: Ord a => [a] -> [a]
ordNub = go M.empty
  where
    go _ [] = []
    go seen (x:xs) | M.member x seen = go seen xs
                   | otherwise = x : go (M.insert x () seen) xs

-- term constructors -------------------------------------------------------

x_, y_, z_ :: Term
x_ = V 0
y_ = V 1
z_ = V 2

zero_ :: Term
zero_ = F "0" []

su :: Term -> Term
su t = F "s" [t]

bin :: String -> Term -> Term -> Term
bin f a b = F f [a,b]

un :: String -> Term -> Term
un f a = F f [a]

-- ============================================================ vocabulary
-- A `Sym` is the exact record MathMachine uses: name, arity, an exact
-- evaluator, and defining equations (the axioms the proof search may use).

data Sym = Sym { symName :: String
               , symArity :: Int
               , symSem :: [Integer] -> Integer
               , symDefs :: [(Term,Term)] }

-- The fixed prime for the p-adic valuation.  A symbol's semantics is a
-- fixed [Integer] -> Integer, so the prime is baked in rather than passed;
-- v_2 is enough to exhibit every valuation law and its convention hazards.
fixedPrime :: Integer
fixedPrime = 2

vpName :: String
vpName = "v" ++ show fixedPrime

-- exact evaluators --------------------------------------------------------

evGcd :: [Integer] -> Integer
evGcd [a,b] = gcd a b
evGcd _ = error "gcd: arity"

-- TOTAL mod with the convention a mod 0 = a.  This is the convention under
-- which the Euclidean identity gcd a b = gcd b (a mod b) holds
-- UNCONDITIONALLY over ℕ (at b = 0 both sides are a).  Haskell's `mod` is
-- partial at 0; making it total is what lets the recurrence be an equation.
evMod :: [Integer] -> Integer
evMod [a,b] = if b == 0 then a else a `mod` b
evMod _ = error "mod: arity"

-- lcm with the standard total convention lcm 0 _ = lcm _ 0 = 0 (Haskell's).
evLcm :: [Integer] -> Integer
evLcm [a,b] = lcm a b
evLcm _ = error "lcm: arity"

-- v_p(n): the exponent of p in n.  v_p(0) is mathematically +∞ and is not
-- representable in ℕ; we set v_p(0) = 0 by convention.  This is the single
-- boundary that makes valuation ADDITIVITY (v_p(xy) = v_p x + v_p y) fail —
-- and the self-test surfaces exactly that failure, then shows the square
-- law v_p(x·x) = v_p x + v_p x survive it (both arguments vanish together).
valuation :: Integer -> Integer -> Integer
valuation p n
  | n == 0 = 0
  | otherwise = go n 0
  where go m k | m `mod` p == 0 = go (m `div` p) (k+1)
               | otherwise      = k

evVp :: [Integer] -> Integer
evVp [a] = valuation fixedPrime a
evVp _ = error "vp: arity"

-- The new generators, as machine symbols. -------------------------------

gcdSym :: Sym
gcdSym = Sym "gcd" 2 evGcd
  -- Only the sound, orientable base cases enter symDefs (the kernel-safe
  -- set), exactly as MathMachine does.  The Euclidean recurrence is exposed
  -- separately in `definingRewrites` because it is not LPO-orientable.
  [ (bin "gcd" x_ zero_, x_)
  , (bin "gcd" zero_ x_, x_) ]

modSym :: Sym
modSym = Sym "mod" 2 evMod
  [ (bin "mod" x_ zero_, x_)          -- convention: a mod 0 = a
  , (bin "mod" zero_ x_, zero_)       -- 0 mod b = 0 (b=0 gives 0 too)
  , (bin "mod" x_ x_,    zero_) ]     -- a mod a = 0 (a=0 gives 0 by convention)

lcmSym :: Sym
lcmSym = Sym "lcm" 2 evLcm
  [ (bin "lcm" x_ zero_, zero_)
  , (bin "lcm" zero_ x_, zero_) ]

vpSym :: Sym
vpSym = Sym vpName 1 evVp
  [ (un vpName zero_, zero_)          -- convention: v_p(0) = 0
  , (un vpName (su zero_), zero_) ]   -- v_p(1) = 0

-- The base vocabulary this module reasons over: MathMachine's arithmetic
-- core plus the four new symbols.  ORDER IS THE PRECEDENCE (later outranks
-- earlier), which is what makes the reduction order well-founded: 0 < s <
-- + < * < - < gcd < mod < lcm < v_p.
vocabulary :: [Sym]
vocabulary =
  [ Sym "0" 0 (const 0) []
  , Sym "s" 1 (\vs -> head vs + 1) []
  , Sym "+" 2 (\vs -> vs!!0 + vs!!1)
      [ (bin "+" x_ zero_,   x_)
      , (bin "+" x_ (su y_), su (bin "+" x_ y_)) ]
  , Sym "*" 2 (\vs -> vs!!0 * vs!!1)
      [ (bin "*" x_ zero_,   zero_)
      , (bin "*" x_ (su y_), bin "+" (bin "*" x_ y_) x_) ]
  , Sym "-" 2 (\vs -> max 0 (vs!!0 - vs!!1))
      [ (bin "-" x_ zero_, x_)
      , (bin "-" zero_ x_, zero_)
      , (bin "-" (su x_) (su y_), bin "-" x_ y_) ]
  , gcdSym
  , modSym
  , lcmSym
  , vpSym
  ]

definitionsOf :: [Sym] -> [Rule]
definitionsOf = concatMap symDefs

arities :: [Sym] -> [(String,Int)]
arities = map (\s -> (symName s, symArity s))

semantics :: [Sym] -> M.Map String ([Integer] -> Integer)
semantics ss = M.fromList [ (symName s, symSem s) | s <- ss ]

-- ============================================================ computation

eval :: M.Map String ([Integer] -> Integer) -> [Integer] -> Term -> Integer
eval _ env (V i) = env !! i
eval sem env (F f ts) =
  case M.lookup f sem of
    Just g  -> g (map (eval sem env) ts)
    Nothing -> error ("ArithVocab.eval: unknown symbol " ++ show f)

-- deterministic pseudo-random assignments, copied from MathMachine so the
-- machine stays reproducible: no system entropy enters.
lcg :: Integer -> Integer
lcg x = (6364136223846793005 * x + 1442695040888963407) `mod` (2^(62::Int))

assignments :: Int -> Int -> [[Integer]]
assignments nv sampleCount = go 12345 sampleCount
  where
    go _ 0 = []
    go s k = let vals = take nv (drop 1 (iterate lcg s))
                 env = map (\v -> v `mod` 9) vals
             in env : go (lcg (s + 7)) (k-1)

fingerprint :: M.Map String ([Integer] -> Integer) -> [[Integer]] -> Term -> [Integer]
fingerprint sem envs t = map (\e -> eval sem e t) envs

-- ============================================================ well-formedness

termShapeProblems :: [Sym] -> Term -> [String]
termShapeProblems _ (V _) = []
termShapeProblems syms (F f ts) = arityProblem ++ concatMap (termShapeProblems syms) ts
  where
    arityProblem = case [ symArity s | s <- syms, symName s == f ] of
      [] -> ["unknown symbol " ++ show f]
      (arity:_)
        | arity == length ts -> []
        | otherwise -> ["symbol " ++ show f ++ " arity " ++ show arity
                        ++ " got " ++ show (length ts)]

wellFormedTerm :: [Sym] -> Term -> Bool
wellFormedTerm syms = null . termShapeProblems syms

-- ============================================================ rewriting
-- The reduction machinery, copied from MathMachine: ordered rewriting under
-- an LPO with a size/precedence fallback, so unorientable laws still fire
-- only where they shrink the term and normal forms always exist.

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

-- Precedence reads the EXTENDED vocabulary (`vocabulary ++ lteSymbols`).
-- The extension only appends, so every symbol of the original list keeps its
-- index and the reduction order on pre-existing terms is bit-for-bit what it
-- was; the five lifting-the-exponent symbols simply outrank all of them.
precedence :: String -> Int
precedence f =
  case [ i | (i,s) <- zip [0..] extendedVocabulary, symName s == f ] of
    (i:_) -> i
    []    -> -1

cmpTerm :: Term -> Term -> Ordering
cmpTerm (V a) (V b) = compare a b
cmpTerm (V _) (F _ _) = LT
cmpTerm (F _ _) (V _) = GT
cmpTerm s@(F f as) t@(F g bs) =
  compare (size s) (size t)
    <> compare (precedence f) (precedence g)
    <> compare (length as) (length bs)
    <> mconcat (zipWith cmpTerm as bs)

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

decreases :: Term -> Term -> Bool
decreases u v
  | lpo u v = True
  | lpo v u = False
  | otherwise = cmpTerm v u == LT

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

normalize :: [Rule] -> Term -> Term
normalize rs = go (200 :: Int)
  where
    go 0 t = t
    go k t = case step rs t of
               Nothing -> t
               Just t' -> go (k-1) t'

orient :: (Term,Term) -> Maybe Rule
orient (l,r)
  | l == r = Nothing
  | lpo l r, vars r `subsetOf` vars l = Just (l,r)
  | lpo r l, vars l `subsetOf` vars r = Just (r,l)
  | otherwise = Nothing

canonVars :: (Term,Term) -> (Term,Term)
canonVars (l,r) = (applySub ren l, applySub ren r)
  where
    order = ordNub (vars l ++ vars r)
    ren = M.fromList (zip order (map V [0..]))

-- ============================================================ defining rewrites
-- The known defining rewrites, in the machine's own Rule format, grouped by
-- the symbol they define.  This is the deliverable "installable rewrite
-- rules": each pair can be dropped into a `[Rule]` and fed to `normalize`.
--
-- Base cases live in each symbol's `symDefs` (kernel-safe, orientable).
-- The Euclidean STEP is a defining recurrence, not a terminating rewrite:
-- rewriting gcd a b -> gcd b (a mod b) introduces `mod` on the right and
-- does NOT shrink the term in the LPO, so `orient` returns Nothing for it
-- (reported honestly below).  It is still a true equation and a valid
-- semantic law; it is simply installed as a lemma the conjecturer can raise,
-- not as an oriented reduction.

euclideanStep :: Rule
euclideanStep = (bin "gcd" x_ y_, bin "gcd" y_ (bin "mod" x_ y_))

definingRewrites :: [(String,[Rule])]
definingRewrites =
  [ ("gcd(base)", symDefs gcdSym)
  , ("gcd(euclid)", [euclideanStep])
  , ("mod", symDefs modSym)
  , ("lcm", symDefs lcmSym)
  , (vpName, symDefs vpSym)
  , ("LTE(conv)", concatMap symDefs lteSymbols)
  , ("LTE(law)", [lteRuleTotal])
  ]

-- ============================================================ term generation
-- The simple generator from MathMachine (genTermsModulo [] []): all
-- well-formed terms of the signature up to a size bound, over nv variables.

-- The term space as a prastāra.  Atoms are the size-1 rows; each symbol of
-- arity a > 0 is a constructor; `termView` is what makes uddiṣṭa definable,
-- i.e. what lets a term report its own row number.
termGrammar :: [(String,Int)] -> Int -> P.Vyakarana Term
termGrammar sig nv = P.Vyakarana
  { P.atomsOf = [ V i | i <- [0..nv-1] ] ++ [ F f [] | f <- nullaries ]
  , P.ctorsOf = [ (a, F f) | (f,a) <- sig, a > 0 ]
  , P.viewOf  = termView
  }
  where
    nullaries = [ f | (f,0) <- sig ]
    positives = [ f | (f,a) <- sig, a > 0 ]
    termView (V i)    = Left i
    termView (F f []) = Left (nv + ix f nullaries)
    termView (F f as) = Right (ix f positives, as)
    ix x xs = length (takeWhile (/= x) xs)

-- सारणी वा क्रिया.  This was
--     genTerms sig nv maxSize = concat table
--       where table  = [ build n | n <- [1..maxSize] ]
--             ofSize = (table !!) . subtract 1
--             build 1 = atoms
--             build n = [ F f args | (f,a) <- sig, a > 0, args <- argsOf a (n-1) ]
--             argsOf 1 k = map (:[]) (ofSize k)
--             argsOf a k = [ t:rest | i <- [1..k-a+1], t <- ofSize i
--                                   , rest <- argsOf (a-1) (k-i) ]
-- — every term of every size, memoised, and held for the whole run because
-- `ofSize` reads back into `table`.  The recurrence is unchanged; what the
-- memo now holds is maxSize PRASTĀRAS (a count and two closures each), and
-- the terms are made when asked for.  Same rows, same order — checked
-- exhaustively in machine/PrastaraRun.hs, which also reports the figures.
genTerms :: [(String,Int)] -> Int -> Int -> [Term]
genTerms sig nv maxSize = P.rows (P.gradedUpToP (termGrammar sig nv) maxSize)

-- ============================================================ refutation
-- Exact refutation by exhaustive computation over a small box.  A single
-- disagreeing environment is a certificate that the equation is false; the
-- convention is MathMachine's `ruleCounterexample`, widened to a chosen box.

-- सारणी वा क्रिया.  This was
--     smallEnvironments n bound = sequence (replicate n [0 .. bound])
-- — the box laid out.  It is now Piṅgala's naṣṭa in mixed radix: the same
-- (bound+1)^n rows, in the same order, produced from an index and dropped.
-- The count is in hand before the first row, so a refutation search can
-- start anywhere, be split, or be resumed from one Integer.
-- Order-identity is checked exhaustively in machine/PrastaraRun.hs.
smallEnvironments :: Int -> Integer -> [[Integer]]
smallEnvironments n bound = P.rows (P.envPrastara n bound)

varCount :: Term -> Term -> Int
varCount l r = case vars l ++ vars r of
  [] -> 0
  us -> 1 + maximum us

exhaustiveCounterexample
  :: M.Map String ([Integer]->Integer) -> Integer -> (Term,Term)
  -> Maybe ([Integer],Integer,Integer)
exhaustiveCounterexample sem bound (l,r) =
  case [ (env,lv,rv)
       | env <- smallEnvironments (varCount l r) bound
       , let lv = eval sem env l
       , let rv = eval sem env r
       , lv /= rv ] of
    (w:_) -> Just w
    []    -> Nothing

-- random-instance agreement: the machine RAISES a conjecture when both
-- sides agree on every random assignment it throws.  Returns the first
-- disagreeing random env if there is one.
randomDisagreement
  :: M.Map String ([Integer]->Integer) -> [[Integer]] -> (Term,Term)
  -> Maybe ([Integer],Integer,Integer)
randomDisagreement sem envs (l,r) =
  case [ (env,lv,rv)
       | env <- envs
       , let lv = eval sem env l
       , let rv = eval sem env r
       , lv /= rv ] of
    (w:_) -> Just w
    []    -> Nothing

-- ============================================================ the self-test

data Verdict
  = RaisedSurvives              -- agreed on randoms AND exhaustive box
  | RaisedThenRefuted [Integer] Integer Integer  -- agreed on randoms, killed exhaustively
  | RefutedImmediately [Integer] Integer Integer -- a random instance already disagreed

adjudicate
  :: M.Map String ([Integer]->Integer) -> [[Integer]] -> Integer -> (Term,Term)
  -> Verdict
adjudicate sem envs bound eqn =
  case randomDisagreement sem envs eqn of
    Just (e,lv,rv) -> RefutedImmediately e lv rv
    Nothing -> case exhaustiveCounterexample sem bound eqn of
      Just (e,lv,rv) -> RaisedThenRefuted e lv rv
      Nothing        -> RaisedSurvives

renderVerdict :: Verdict -> String
renderVerdict RaisedSurvives =
  "RAISED, SURVIVES  (agrees on all randoms and full small box)"
renderVerdict (RaisedThenRefuted e lv rv) =
  "RAISED then REFUTED  (randoms agreed; exhaustive box disagrees at "
    ++ showEnv e ++ ": left=" ++ show lv ++ " right=" ++ show rv ++ ")"
renderVerdict (RefutedImmediately e lv rv) =
  "REFUTED on a random instance  at " ++ showEnv e
    ++ ": left=" ++ show lv ++ " right=" ++ show rv

showEnv :: [Integer] -> String
showEnv e = "{" ++ intercalate "," (zipWith (\v n -> [v] ++ "=" ++ show n)
                                     "xyzuvw" e) ++ "}"

-- The curated classical identities.  Each is a known theorem (or, for the
-- deliberately-false ones, a plausible non-theorem) that the machine's
-- generate/fingerprint loop would raise as a conjecture.  Names carry a
-- one-word note on their mathematical status.
classicalIdentities :: [(String,(Term,Term))]
classicalIdentities =
  [ ("gcd commutativity      gcd(x,y)=gcd(y,x)",
       (bin "gcd" x_ y_, bin "gcd" y_ x_))
  , ("gcd idempotence        gcd(x,x)=x",
       (bin "gcd" x_ x_, x_))
  , ("gcd associativity      gcd(gcd(x,y),z)=gcd(x,gcd(y,z))",
       (bin "gcd" (bin "gcd" x_ y_) z_, bin "gcd" x_ (bin "gcd" y_ z_)))
  , ("gcd absorption         gcd(x,x*y)=x",
       (bin "gcd" x_ (bin "*" x_ y_), x_))
  , ("Euclid step            gcd(x,y)=gcd(y,x mod y)",
       euclideanStep)
  , ("gcd-lcm product        gcd(x,y)*lcm(x,y)=x*y",
       (bin "*" (bin "gcd" x_ y_) (bin "lcm" x_ y_), bin "*" x_ y_))
  , ("lcm commutativity      lcm(x,y)=lcm(y,x)",
       (bin "lcm" x_ y_, bin "lcm" y_ x_))
  , ("lcm idempotence        lcm(x,x)=x",
       (bin "lcm" x_ x_, x_))
  , ("mod self               x mod x=0",
       (bin "mod" x_ x_, zero_))
  , ("mod of multiple        (x*y) mod y=0",
       (bin "mod" (bin "*" x_ y_) y_, zero_))
  , ("mod idempotent         (x mod y) mod y = x mod y",
       (bin "mod" (bin "mod" x_ y_) y_, bin "mod" x_ y_))
  , (vpName++" square law         "++vpName++"(x*x)="++vpName++"(x)+"++vpName++"(x)",
       (un vpName (bin "*" x_ x_), bin "+" (un vpName x_) (un vpName x_)))
  , (vpName++" additivity (FALSE) "++vpName++"(x*y)="++vpName++"(x)+"++vpName++"(y)",
       (un vpName (bin "*" x_ y_), bin "+" (un vpName x_) (un vpName y_)))
  , ("mod commutativity (FALSE) x mod y=y mod x",
       (bin "mod" x_ y_, bin "mod" y_ x_))
  ]

-- Autonomous conjecturing: exactly MathMachine's round-1 pipeline restricted
-- to this vocabulary.  Generate terms, normalize with the defining rewrites,
-- group by behavioural fingerprint, and emit each surviving pair.  Every
-- emitted pair is one the machine would raise; we then adjudicate it.
autonomousConjectures
  :: [Sym] -> Int -> Int -> [[Integer]] -> [(Term,Term)]
autonomousConjectures syms nv maxSize envs =
  ordNub
    [ canonVars (rep, other)
    | cls <- classes
    , length cls > 1
    , rep:others <- [sortOn (\t -> (size t, t)) cls]
    , other <- others ]
  where
    sig   = arities syms
    sem   = semantics syms
    rules = definitionsOf syms
    raw   = genTerms sig nv maxSize
    normed = ordNub (map (normalize rules) raw)
    classes = M.elems (M.fromListWith (++)
                [ (fingerprint sem envs t, [t]) | t <- normed ])

main :: IO ()
main = do
  let syms  = vocabulary
      sem   = semantics syms
      nv    = 3
      envs  = assignments nv 300
      box   = 15 :: Integer

  putStrLn "=== ArithVocab: gcd / mod / lcm / v_p vocabulary extension ==="
  printf "fixed prime p = %d   (v_p symbol name = %s)\n\n" fixedPrime vpName

  -- 1. the generators and their exact evaluators, sanity-printed
  putStrLn "-- generators (exact evaluators, spot values) --"
  printf "  gcd(12,8)=%d  gcd(0,5)=%d  gcd(5,0)=%d\n"
    (evGcd [12,8]) (evGcd [0,5]) (evGcd [5,0])
  printf "  12 mod 8=%d  5 mod 0=%d (convention)  0 mod 0=%d\n"
    (evMod [12,8]) (evMod [5,0]) (evMod [0,0])
  printf "  lcm(4,6)=%d  lcm(0,0)=%d  lcm(0,5)=%d\n"
    (evLcm [4,6]) (evLcm [0,0]) (evLcm [0,5])
  printf "  %s(8)=%d  %s(12)=%d  %s(0)=%d (convention)  %s(1)=%d\n\n"
    vpName (evVp [8]) vpName (evVp [12]) vpName (evVp [0]) vpName (evVp [1])

  -- 2. the defining rewrites, with orientability reported honestly
  putStrLn "-- defining rewrites (installable Rules; orientability) --"
  mapM_ reportRewrite (concatMap (\(g,rs) -> map ((,) g) rs) definingRewrites)
  putStrLn ""

  -- firewall: every rewrite in symDefs must survive a small exhaustive audit
  putStrLn "-- defining-rewrite firewall (exhaustive over 0..8) --"
  let defFailures =
        [ (symName s, l, r, e, lv, rv)
        | s <- syms, (l,r) <- symDefs s
        , Just (e,lv,rv) <- [exhaustiveCounterexample sem 8 (l,r)] ]
  if null defFailures
    then putStrLn "  all defining rewrites in symDefs survive the audit (sound)."
    else mapM_ (\(n,l,r,e,lv,rv) ->
           printf "  UNSOUND %s: %s = %s fails at %s (%d vs %d)\n"
             n (show l) (show r) (showEnv e) lv rv) defFailures
  putStrLn ""

  -- 3. autonomous conjecturing over the vocabulary (the machine proposing
  --    gcd/mod laws on its own), size-bounded so it stays fast.
  putStrLn "-- autonomous conjectures the machine raises (size<=4, 3 vars) --"
  let autos = autonomousConjectures syms nv 4 envs
      -- keep the ones that mention a NEW symbol and are non-trivial
      newSyms = ["gcd","mod","lcm",vpName]
      interesting =
        [ eqn | eqn@(l,r) <- autos
              , any (`elem` newSyms) (symbolsIn l ++ symbolsIn r)
              , l /= r ]
      surviving =
        [ (eqn, adjudicate sem envs box eqn) | eqn <- interesting ]
      survivors = [ e | (e,RaisedSurvives) <- surviving ]
  printf "  raised %d conjectures over the vocabulary; %d mention a new symbol.\n"
    (length autos) (length interesting)
  printf "  of those, %d survive the exhaustive small box (shown, up to 20):\n"
    (length survivors)
  mapM_ (\(l,r) -> printf "    %s = %s\n" (show l) (show r))
        (take 20 survivors)
  putStrLn ""

  -- 4. adjudicate the curated classical identities
  putStrLn "-- curated classical identities: raise, then refute-by-computation --"
  results <- mapM (\(nm,eqn) -> do
      let v = adjudicate sem envs box eqn
      printf "  %-42s %s\n" nm (renderVerdict v)
      pure (nm,v)) classicalIdentities
  putStrLn ""

  -- 5. summary
  let survives  = [ nm | (nm,RaisedSurvives) <- results ]
      refutedEx = [ nm | (nm,RaisedThenRefuted{}) <- results ]
      refutedR  = [ nm | (nm,RefutedImmediately{}) <- results ]
  putStrLn "-- SUMMARY --"
  printf "  survived (raised and never refuted): %d\n" (length survives)
  mapM_ (putStrLn . ("    + " ++)) survives
  printf "  refuted by computation: %d\n" (length refutedEx + length refutedR)
  mapM_ (putStrLn . ("    - " ++)) (refutedEx ++ refutedR)
  putStrLn ""

  -- 6-9. the lifting-the-exponent merge (added 2026-08-16)
  lteFailures <- reportLTE

  -- ----------------------------------------------------------- exit gate
  -- [ADDED.]  Before this, `main` always exited 0 and a clerk had to read
  -- the output to learn whether anything was wrong.  A self-test that cannot
  -- fail is not a test.  The gate collects every condition that would mean
  -- the module is WRONG — an unsound defining rewrite, a law failure inside
  -- a range this file claims to have verified, a broken instrument, a
  -- vacuous falsifier, a disagreement between the two routes, or a curated
  -- identity landing on the wrong side of its known status — and exits
  -- nonzero if any fired.  The two identities marked (FALSE) are REQUIRED to
  -- be refuted; the other twelve are required to survive.
  let expectationFailures =
        [ "expected REFUTED but it survived: " ++ nm
        | (nm, RaisedSurvives) <- results, isMarkedFalse nm ]
        ++
        [ "expected to survive but it was refuted: " ++ nm
        | (nm, v) <- results, not (isMarkedFalse nm), not (isSurvival v) ]
      firewallFailures =
        [ "unsound defining rewrite for " ++ nm | (nm,_,_,_,_,_) <- defFailures ]
      allFailures = firewallFailures ++ expectationFailures ++ lteFailures
  putStrLn "-- EXIT GATE --"
  if null allFailures
    then do
      putStrLn "  no failures."
      putStrLn ""
      putStrLn "ARITHVOCAB SELF-TEST COMPLETE"
      exitSuccess
    else do
      printf "  %d FAILURES:\n" (length allFailures)
      mapM_ (putStrLn . ("    ! " ++)) allFailures
      putStrLn ""
      putStrLn "ARITHVOCAB SELF-TEST FAILED"
      exitFailure

isMarkedFalse :: String -> Bool
isMarkedFalse nm = "(FALSE)" `elem` words nm

isSurvival :: Verdict -> Bool
isSurvival RaisedSurvives = True
isSurvival _ = False

-- ==========================================================================
-- ==================================================== LIFTING THE EXPONENT
-- ==========================================================================
-- [ADDED 2026-08-16, Ramanujan.  Everything ABOVE this banner pre-existed:
--  the Term algebra, the gcd/mod/lcm/v_2 vocabulary, the rewriting machinery,
--  the curated identities and their adjudication, and sections 1-5 of `main`.
--  Everything BELOW it, plus sections 6-9 of `main` and the exit-code gate,
--  is the addition.  Nothing above was deleted; three lines were touched —
--  the `System.Exit` import, `precedence` (now reads `extendedVocabulary`,
--  which appends and therefore preserves every existing index), and the two
--  new groups at the end of `definingRewrites`.]
--
-- WHY THIS IS HERE.  `notes/RUNTIME.md` §4.5 is the standing criticism:
-- "No connection to this repository's mathematics.  The demo is group
-- theory.  Nothing in notes/ has been expressed in the IR.  Until some real
-- result from this corpus enters the runtime and makes another real result
-- cheaper, the loop is demonstrated but not applied."  This section answers
-- exactly that, with the corpus's sharpest arithmetic fact — the head-depth
-- carrier e_b(q) = v_q(b^{ord_q(b)} - 1) and the valuation law behind it.
--
-- THE STATEMENT (notes/CYCLOTOMIC_SENSOR.md, Theorem 1; classical
-- lifting-the-exponent plus its order corollary — cited as known, not
-- claimed).  For an ODD PRIME p and an integer a with p ∤ a, writing
-- d = ord_p(a) and e = v_p(a^d - 1):
--
--     v_p(a^n - 1) = 0            if d ∤ n
--     v_p(a^n - 1) = e + v_p(n)   if d | n
--
-- and for p = 2 with a odd, writing e- = v_2(a-1), e+ = v_2(a+1):
--
--     v_2(a^n - 1) = e-                       n odd
--     v_2(a^n - 1) = e- + e+ + v_2(n) - 1     n even
--
-- The proof is in the note (it is reproduced there in full, ~25 lines).  It
-- is NOT reproved here.  What is done here is the thing the note could not
-- do: put the law into the machine's own vocabulary as executable exact
-- symbols, CERTIFY it by finite exhaustive verification, and then USE it —
-- exhibit the cost collapse it buys, in exact counted digit operations.
--
-- WHAT KIND OF EVIDENCE THE VERIFICATION BELOW IS.  CLAUDE.md: "Exact /
-- certified symbolic computation is proof and is always allowed: an
-- irreducibility certificate over Q, A FINITE EXHAUSTIVE VERIFICATION, a
-- resultant, a factorization."  `lteOddFailures` and `lteTwoFailures` are
-- finite exhaustive verifications: every triple in an explicitly bounded
-- range is checked with exact Integer arithmetic, no sampling and no
-- floating point anywhere in this module.  They therefore PROVE their own
-- statements, which are the finitely-bounded ones, and nothing more.  The
-- unbounded theorem is the note's, by the note's proof.  A finite check is
-- never evidence for an asymptotic claim, and no claim below is asymptotic:
-- the cost table reports counted integers at named n, not a fitted slope.
--
-- THE RANGES ARE PART OF THE RESULT.  A bound that is not stated is not a
-- result (CLAUDE.md, the X-dependence corollary).  They are the named
-- constants immediately below, printed verbatim by the self-test.

-- ---------------------------------------------------------------- ranges

-- odd branch: every odd prime p < lteOddPrimeBound, every base
-- 2 <= a <= lteBaseBound with p ∤ a, every exponent 1 <= n <= lteExpBound.
lteOddPrimeBound, lteBaseBound, lteExpBound :: Integer
lteOddPrimeBound = 100
lteBaseBound     = 40
lteExpBound      = 60

-- p = 2 branch: every odd base 3 <= a <= lteTwoBaseBound, every exponent
-- 1 <= n <= lteExpBound.  (a = 1 is excluded: a^n - 1 = 0, whose valuation
-- is +infinity and is represented here by the module's v_p(0) = 0
-- convention, so it is outside the law's domain rather than a failure of it.)
lteTwoBaseBound :: Integer
lteTwoBaseBound = 81

primesUpTo :: Integer -> [Integer]
primesUpTo n = [ q | q <- [2..n], isPrimeInt q ]

isPrimeInt :: Integer -> Bool
isPrimeInt m
  | m < 2 = False
  | otherwise = null [ q | q <- takeWhile (\q -> q*q <= m) [2..], m `mod` q == 0 ]

-- ------------------------------------------------- exact evaluators (1)
-- All exact over Integer.  All TOTAL: every one has a stated convention at
-- every boundary, because (as the v_p additivity failure above already
-- demonstrated in this very module) a boundary convention decides whether a
-- law survives.  No Double, no Float, no `fromIntegral` to a float, anywhere.

-- v_p(n) at an arbitrary modulus p, the binary form of the module's unary
-- `valuation`.  Conventions: p < 2 gives 0 (no valuation exists), and
-- v_p(0) = 0 as everywhere else in this module.
vpAt :: Integer -> Integer -> Integer
vpAt p n
  | p < 2 = 0
  | otherwise = valuation p n

-- ord_p(a): the least k >= 1 with a^k = 1 (mod p), found by BOUNDED search.
-- Convention: 0 when no such k exists (p < 2, or gcd(a,p) /= 1).  The search
-- to p-1 is complete for every modulus p >= 2, because the order of a unit
-- divides |(Z/p)^*| = phi(p) <= p-1; so this evaluator is correct at
-- composite p too.  It is the LAW, not the evaluator, that needs p prime.
ordAt :: Integer -> Integer -> Integer
ordAt p a
  | p < 2 = 0
  | gcd (a `mod` p) p /= 1 = 0
  | otherwise = go 1 (a `mod` p)
  where
    go k acc
      | acc == 1  = k
      | k >= p    = 0                     -- unreachable for a unit; total anyway
      | otherwise = go (k+1) ((acc * (a `mod` p)) `mod` p)

-- e_p(a) = v_p(a^{ord_p(a)} - 1): the head-depth carrier, the corpus's
-- e_b(q).  Convention: 0 when ord_p(a) = 0.
ePrimeAt :: Integer -> Integer -> Integer
ePrimeAt p a
  | d == 0 = 0
  | otherwise = vpAt p (a ^ d - 1)
  where d = ordAt p a

-- the quantity the law computes: v_p(a^n - 1), by the NAIVE route (form the
-- integer, strip factors of p).  Convention: n < 0 gives 0; a^n - 1 = 0 gives
-- 0 by the module's v_p(0) = 0 convention.
vpPowMinus1 :: Integer -> Integer -> Integer -> Integer
vpPowMinus1 p a n
  | p < 2 || n < 0 = 0
  | otherwise      = vpAt p (a ^ n - 1)

-- the chain indicator: 1 when d | n (n is on the multiplicative chain of a
-- mod p), 0 otherwise.  Convention: 0 when ord_p(a) = 0.  This is the device
-- that turns the two-case law into ONE unconditional equation, which is what
-- lets it be written as a machine Rule at all.
onChain :: Integer -> Integer -> Integer -> Integer
onChain p a n
  | d == 0 = 0
  | n `mod` d == 0 = 1
  | otherwise = 0
  where d = ordAt p a

-- ------------------------------------------------ the law as a predicate (2)

-- The right-hand side of Theorem 1 (odd p), in its total one-equation form:
--     v_p(a^n - 1) = [d | n] * (e_p(a) + v_p(n)).
lteRHSOdd :: Integer -> Integer -> Integer -> Integer
lteRHSOdd p a n = onChain p a n * (ePrimeAt p a + vpAt p n)

-- The decidable predicate.  DECIDABLE, not asserted: both sides are exact
-- Integers and the test is (==).
lteHoldsOdd :: Integer -> Integer -> Integer -> Bool
lteHoldsOdd p a n = vpPowMinus1 p a n == lteRHSOdd p a n

-- The p = 2 branch, Theorem 1 (2).  e- = v_2(a-1), e+ = v_2(a+1).
lteRHSTwo :: Integer -> Integer -> Integer
lteRHSTwo a n
  | odd n     = em
  | otherwise = em + ep + vpAt 2 n - 1
  where em = vpAt 2 (a - 1)
        ep = vpAt 2 (a + 1)

lteHoldsTwo :: Integer -> Integer -> Bool
lteHoldsTwo a n = vpPowMinus1 2 a n == lteRHSTwo a n

-- ---------------------------------------- the finite exhaustive verifications

lteOddTriples :: [(Integer,Integer,Integer)]
lteOddTriples =
  [ (p,a,n)
  | p <- filter (> 2) (primesUpTo (lteOddPrimeBound - 1))
  , a <- [2 .. lteBaseBound]
  , a `mod` p /= 0
  , n <- [1 .. lteExpBound] ]

-- FINITE EXHAUSTIVE VERIFICATION.  Every failure is returned with its
-- witness (p,a,n) and both sides; an empty list is the certificate that the
-- odd-p law holds identically on the stated range.
lteOddFailures :: [((Integer,Integer,Integer),Integer,Integer)]
lteOddFailures =
  [ ((p,a,n), vpPowMinus1 p a n, lteRHSOdd p a n)
  | (p,a,n) <- lteOddTriples
  , not (lteHoldsOdd p a n) ]

lteTwoPairs :: [(Integer,Integer)]
lteTwoPairs =
  [ (a,n) | a <- [3,5 .. lteTwoBaseBound], n <- [1 .. lteExpBound] ]

lteTwoFailures :: [((Integer,Integer),Integer,Integer)]
lteTwoFailures =
  [ ((a,n), vpPowMinus1 2 a n, lteRHSTwo a n)
  | (a,n) <- lteTwoPairs
  , not (lteHoldsTwo a n) ]

-- THE FALSIFIER (PROTOCOL §1: a headline claim ships with the control that
-- was designed to kill it).  The law is DOMAIN-RESTRICTED: p must be an odd
-- prime.  If the check above passed merely because the predicate is vacuous
-- or the arithmetic is degenerate, it would also pass off the domain.  It
-- does not: this searches the same predicate at composite moduli and at
-- p = 2 and returns the first witness where the odd-p form is FALSE.  A
-- non-empty answer here is what makes the empty answer above informative.
lteOffDomainWitness :: Maybe ((Integer,Integer,Integer),Integer,Integer)
lteOffDomainWitness =
  case [ ((p,a,n), vpPowMinus1 p a n, lteRHSOdd p a n)
       | p <- 2 : [ q | q <- [4 .. 40], not (isPrimeInt q) ]
       , a <- [2 .. 20], gcd a p == 1
       , n <- [1 .. 40]
       , not (lteHoldsOdd p a n) ] of
    (w:_) -> Just w
    []    -> Nothing

-- A second control: the law must not be an accident of a degenerate range.
-- Count how many triples in the verified range actually EXERCISE each branch
-- (d | n with v_p(n) > 0 is the only place the shift term v_p(n) is visible;
-- if that count were 0 the check would be untested where it matters).
lteBranchCensus :: (Int,Int,Int)
lteBranchCensus = foldl' bump (0,0,0) lteOddTriples
  where
    bump (off,onFlat,onShift) (p,a,n)
      | onChain p a n == 0 = (off+1, onFlat, onShift)
      | vpAt p n > 0       = (off, onFlat, onShift+1)
      | otherwise          = (off, onFlat+1, onShift)

-- ------------------------------------------- the law in the machine's idiom
-- Five new `Sym`s: the same record the vocabulary above is built from, with
-- exact evaluators and convention-recording defining equations.  The prime is
-- an ARGUMENT here (unlike the module's unary v_2, whose prime is baked in),
-- because the law quantifies over p.

ordSym, vpAtSym, eSym, chainSym, vpowSym :: Sym

ordSym = Sym "ord" 2 (\vs -> ordAt (vs!!0) (vs!!1))
  [ (F "ord" [zero_, x_], zero_) ]          -- convention: no modulus, no order

vpAtSym = Sym "vp" 2 (\vs -> vpAt (vs!!0) (vs!!1))
  [ (F "vp" [x_, zero_], zero_)             -- convention: v_p(0) = 0
  , (F "vp" [zero_, x_], zero_) ]           -- convention: p < 2 gives 0

eSym = Sym "e" 2 (\vs -> ePrimeAt (vs!!0) (vs!!1))
  [ (F "e" [zero_, x_], zero_) ]

chainSym = Sym "onchain" 3 (\vs -> onChain (vs!!0) (vs!!1) (vs!!2))
  [ (F "onchain" [zero_, x_, y_], zero_) ]

vpowSym = Sym "vpow" 3 (\vs -> vpPowMinus1 (vs!!0) (vs!!1) (vs!!2))
  [ (F "vpow" [x_, y_, zero_], zero_)       -- a^0 - 1 = 0, v_p(0) = 0
  , (F "vpow" [zero_, x_, y_], zero_) ]

lteSymbols :: [Sym]
lteSymbols = [ ordSym, vpAtSym, eSym, chainSym, vpowSym ]

-- APPEND-ONLY: every original symbol keeps its index, hence its precedence.
extendedVocabulary :: [Sym]
extendedVocabulary = vocabulary ++ lteSymbols

-- Theorem 1 (odd p) as a single machine Rule, in the module's Rule format,
-- droppable into any [Rule] and fed to `normalize`:
--
--     vpow(p,a,n)  ->  onchain(p,a,n) * (e(p,a) + vp(p,n))
--
-- The chain indicator is what makes the two-case law one equation.  This is
-- the merge the corpus flagged three times as unexecuted; it is now a term.
lteRuleTotal :: Rule
lteRuleTotal =
  ( F "vpow" [x_, y_, z_]
  , bin "*" (F "onchain" [x_, y_, z_])
            (bin "+" (F "e" [x_, y_]) (F "vp" [x_, z_])) )

-- HONESTY, in the idiom this module already uses for the Euclidean step.
-- `lteRuleTotal` is a true equation ON ITS DOMAIN (p an odd prime, p ∤ a,
-- n >= 1) and FALSE off it — `lteOffDomainWitness` exhibits the witness.  It
-- is therefore deliberately NOT placed in any symbol's `symDefs`, which is
-- the kernel-safe set the unrestricted proof search may use: an unguarded
-- first-order rewrite engine has no way to carry the side condition, and
-- installing it there would let the kernel derive falsehoods.  It is
-- installed as a LEMMA, exactly as the Euclidean step is.

-- ================================================== (3) THE COST REDUCTION
-- The point of the merge: a result from the corpus entering the runtime and
-- making another result CHEAPER.  Both routes to v_p(a^n - 1) are run, and
-- the work is COUNTED — exact integers from an instrumented evaluator, never
-- a wall-clock reading and never a fitted slope.
--
-- THE COST MODEL, stated so the numbers are checkable rather than believed.
-- One unit = one base-p digit operation:
--   * multiplying a k-digit number by an L-digit number costs k*L
--     (schoolbook; each digit of one meets each digit of the other);
--   * subtracting 1 from a k-digit number costs k (the borrow pass);
--   * dividing a k-digit number by the single digit p, or testing
--     divisibility by it, costs k (one pass);
--   * one step of the order loop (multiply two single digits, reduce the
--     2-digit product mod p) costs 3.
-- The model is uniform across both routes, so the RATIO is a statement about
-- the two algorithms and not about the model.  Alongside it the table also
-- prints D(n) = the number of base-p digits of a^n - 1, which is an
-- ALGORITHM-INDEPENDENT LOWER BOUND on the naive route: any method whatever
-- that forms the integer a^n - 1 must at minimum write down its D(n) digits.

-- number of base-p digits of |m|  (0 has one digit).  Exact; no logarithms.
digitsP :: Integer -> Integer -> Integer
digitsP p m
  | p < 2 = 0
  | otherwise = go (abs m) 0
  where go u k | u == 0    = max 1 k
               | otherwise = go (u `div` p) (k+1)

-- strip factors of p, counting: each trial division costs the digit count of
-- the current value, and there are v+1 of them (v that succeed, one that
-- fails and stops the loop).  Returns (v_p(m), cost).
stripCounted :: Integer -> Integer -> (Integer, Integer)
stripCounted p m
  | p < 2  = (0, 0)
  | m == 0 = (0, 1)
  | otherwise = go (abs m) 0 0
  where
    go u k c
      | u `mod` p == 0 = go (u `div` p) (k+1) (c + digitsP p u)
      | otherwise      = (k, c + digitsP p u)

data NaiveRun = NaiveRun
  { nrVal    :: !Integer   -- v_p(a^n - 1), computed the naive way
  , nrCost   :: !Integer   -- counted digit operations
  , nrDigits :: !Integer   -- D(n) = base-p digits of a^n - 1
  }

-- (i) THE NAIVE ROUTE: form a^n by n successive multiplications, subtract 1,
-- strip factors of p.  The running digit count is maintained incrementally
-- against a threshold power (so instrumenting the loop does not itself cost
-- more than the loop); `digitsAgreeFailures` checks that this incremental
-- count equals `digitsP` exactly, so the instrument is verified, not trusted.
naiveVpCounted :: Integer -> Integer -> Integer -> NaiveRun
naiveVpCounted p a n = NaiveRun v (cPow + cSub + cStrip) dOut
  where
    la = digitsP p a
    (an, cPow) = powLoop 1 1 p 0 0
    -- invariant: p^(k-1) <= acc < p^k, so k = digitsP p acc
    powLoop acc k pk j c
      | j >= n = (acc, c)
      | otherwise =
          let c'   = c + k * la           -- multiply a k-digit acc by an la-digit a
              acc' = acc * a
              (k', pk') = bump k pk acc'
          in powLoop acc' k' pk' (j+1) c'
      where
        bump kk q u | u >= q    = bump (kk+1) (q*p) u
                    | otherwise = (kk, q)
    cSub = digitsP p an                    -- the "- 1" borrow pass
    (v, cStrip) = stripCounted p (an - 1)
    dOut = digitsP p (an - 1)

data LawRun = LawRun
  { lrVal   :: !Integer    -- v_p(a^n - 1), via e + v_p(n)
  , lrSetup :: !Integer    -- ONE-TIME cost of the sensor (d, e); independent of n
  , lrQuery :: !Integer    -- per-n cost once the sensor is known
  }

-- (ii) THE LAW ROUTE: one-time O(p) computation of d = ord_p(a) and
-- e = v_p(a^d - 1) (the carrier e_b(q)); thereafter each n costs only a
-- divisibility test and v_p(n).
lawVpCounted :: Integer -> Integer -> Integer -> LawRun
lawVpCounted p a n = LawRun val setup query
  where
    d     = ordAt p a
    cOrd  = 3 * d                          -- d steps of the order loop
    eRun  = naiveVpCounted p a d           -- e, paid for ONCE, at exponent d < p
    e     = nrVal eRun
    setup = cOrd + nrCost eRun
    cTest = digitsP p n                    -- one pass to decide d | n
    (w, cW) = stripCounted p n             -- v_p(n)
    (val, query)
      | d == 0            = (0, cTest)
      | n `mod` d /= 0    = (0, cTest)     -- off the chain: the answer is 0
      | otherwise         = (e + w, cTest + cW + 1)   -- +1 for the addition e + w

-- the instrument's own audit: incremental digit tracking must agree with the
-- direct count at every exponent it is used at.
digitsAgreeFailures :: [(Integer,Integer,Integer,Integer,Integer)]
digitsAgreeFailures =
  [ (p,a,n, nrDigits (naiveVpCounted p a n), digitsP p (a^n - 1))
  | p <- [3,5,7,11], a <- [2,3,5,10], n <- [1..25]
  , nrDigits (naiveVpCounted p a n) /= digitsP p (a^n - 1) ]

-- the cost table's instances.  Both are on-chain families with the shift
-- term v_p(n) actually varying, plus two off-chain n where the law answers 0
-- without touching a^n at all.
costInstances :: [((Integer,Integer),[Integer])]
costInstances =
  [ ((7,3), [6, 12, 42, 84, 294, 588, 2058, 5, 100])
  , ((3,2), [2, 6, 18, 54, 162, 486, 1458, 7, 1001])
  ]

data CostRow = CostRow
  { crN :: !Integer, crChain :: !Bool, crDigits :: !Integer
  , crNaive :: !Integer, crQuery :: !Integer
  , crAgree :: !Bool, crValue :: !Integer }

costRow :: Integer -> Integer -> Integer -> CostRow
costRow p a n = CostRow n (onChain p a n == 1) (nrDigits nr)
                        (nrCost nr) (lrQuery lr)
                        (nrVal nr == lrVal lr) (nrVal nr)
  where nr = naiveVpCounted p a n
        lr = lawVpCounted p a n

-- exact ratio, reduced; no floating point.  Rendered as "num/den ~ q"
-- with q the exact integer quotient (floor).
showExactRatio :: Integer -> Integer -> String
showExactRatio num den
  | den == 0 = "inf"
  | otherwise =
      let g = gcd num den
      in show (num `div` g) ++ "/" ++ show (den `div` g)
         ++ " (floor " ++ show (num `div` den) ++ ")"

-- ============================================================ the LTE report

reportLTE :: IO [String]
reportLTE = do
  putStrLn "-- (6) lifting the exponent: the corpus law, in the machine's vocabulary --"
  putStrLn "  notes/CYCLOTOMIC_SENSOR.md Theorem 1 (classical LTE + order corollary)."
  putStrLn "    odd p, p not dividing a, d = ord_p(a), e = v_p(a^d - 1):"
  putStrLn "      v_p(a^n - 1) = 0           if d does not divide n"
  putStrLn "      v_p(a^n - 1) = e + v_p(n)  if d divides n"
  printf "  carrier spot values  e_7(3)=%d (d=%d)   e_3(2)=%d (d=%d)   e_5(7)=%d (d=%d)\n"
    (ePrimeAt 7 3) (ordAt 7 3) (ePrimeAt 3 2) (ordAt 3 2) (ePrimeAt 5 7) (ordAt 5 7)
  putStrLn "  as ONE machine Rule (chain indicator absorbs the case split):"
  reportRewrite ("LTE(law)", lteRuleTotal)
  putStrLn "    ^ true on its domain only; installed as a LEMMA, never in symDefs."
  putStrLn ""

  -- the new symbols' conventions get the same firewall the old ones get
  putStrLn "-- (7) new symbols: convention firewall (exhaustive over 0..8) --"
  let semX = semantics extendedVocabulary
      convFails =
        [ (symName s, l, r, e, lv, rv)
        | s <- lteSymbols, (l,r) <- symDefs s
        , Just (e,lv,rv) <- [exhaustiveCounterexample semX 8 (l,r)] ]
  if null convFails
    then printf "  all %d convention rewrites of ord/vp/e/onchain/vpow survive (sound).\n"
           (length (concatMap symDefs lteSymbols))
    else mapM_ (\(nm,l,r,e,lv,rv) ->
           printf "  UNSOUND %s: %s = %s fails at %s (%d vs %d)\n"
             nm (show l) (show r) (showEnv e) lv rv) convFails
  putStrLn ""

  -- (2) the finite exhaustive verification
  putStrLn "-- (8) FINITE EXHAUSTIVE VERIFICATION of the law --"
  putStrLn "  CLAUDE.md admits a finite exhaustive verification as PROOF.  What is"
  putStrLn "  proved is exactly the finitely-bounded statement below; the unbounded"
  putStrLn "  theorem is the note's, by the note's proof.  Nothing here is asymptotic."
  printf "  odd branch, range VERIFIED IN FULL:\n"
  printf "    p  odd prime, 3 <= p <= %d      (%d primes)\n"
    (last (filter (>2) (primesUpTo (lteOddPrimeBound - 1))))
    (length (filter (>2) (primesUpTo (lteOddPrimeBound - 1))))
  printf "    a  integer,   2 <= a <= %d, p does not divide a\n" lteBaseBound
  printf "    n  integer,   1 <= n <= %d\n" lteExpBound
  printf "    triples checked: %d      failures: %d\n"
    (length lteOddTriples) (length lteOddFailures)
  let (offC, flatC, shiftC) = lteBranchCensus
  printf "    branch census: %d off-chain (law says 0), %d on-chain with v_p(n)=0,\n" offC flatC
  printf "                   %d on-chain with v_p(n)>0 (the shift term exercised)\n" shiftC
  mapM_ (\((p,a,n),lv,rv) ->
          printf "    FAIL p=%d a=%d n=%d: v_p(a^n-1)=%d but law says %d\n" p a n lv rv)
        (take 5 lteOddFailures)
  printf "  p = 2 branch (the module's own fixed prime; e- = v_2(a-1), e+ = v_2(a+1)):\n"
  printf "    a odd, 3 <= a <= %d;  1 <= n <= %d;  pairs checked: %d      failures: %d\n"
    lteTwoBaseBound lteExpBound (length lteTwoPairs) (length lteTwoFailures)
  mapM_ (\((a,n),lv,rv) ->
          printf "    FAIL a=%d n=%d: v_2(a^n-1)=%d but law says %d\n" a n lv rv)
        (take 5 lteTwoFailures)
  putStrLn "  FALSIFIER (the control designed to kill the claim):"
  case lteOffDomainWitness of
    Just ((p,a,n),lv,rv) ->
      printf "    off-domain, the SAME predicate is false at p=%d (not an odd prime), a=%d, n=%d:\n      v_p(a^n-1)=%d, law says %d.  The empty failure list above is therefore\n      a statement about odd primes, not a vacuous identity.\n" p a n lv rv
    Nothing ->
      putStrLn "    NONE FOUND -- the predicate did not fail off-domain; the verification\n    above may be vacuous and must not be trusted."
  putStrLn ""

  -- (3) the cost reduction
  putStrLn "-- (9) THE PAYOFF: the law as a COST REDUCTION (exact counted work) --"
  putStrLn "  unit = one base-p digit operation (model stated in the source above)."
  putStrLn "  (i)  naive : form a^n - 1, strip factors of p."
  putStrLn "  (ii) law   : one-time (d,e); then per n, a divisibility test + v_p(n)."
  rowsAndFails <- mapM reportCostBlock costInstances
  putStrLn ""

  let digitFails = digitsAgreeFailures
  if null digitFails
    then putStrLn "  instrument audit: incremental digit counter agrees with digitsP on all\n    (p,a,n) with p in {3,5,7,11}, a in {2,3,5,10}, 1<=n<=25."
    else printf "  INSTRUMENT BROKEN: %d disagreements\n" (length digitFails)
  putStrLn ""

  pure $ concat
    [ [ "unsound convention rewrite: " ++ nm | (nm,_,_,_,_,_) <- convFails ]
    , [ printf "odd-p law fails at p=%d a=%d n=%d" p a n
      | ((p,a,n),_,_) <- take 5 lteOddFailures ]
    , [ printf "p=2 law fails at a=%d n=%d" a n
      | ((a,n),_,_) <- take 5 lteTwoFailures ]
    , [ "falsifier found no off-domain counterexample: verification may be vacuous"
      | lteOffDomainWitness == Nothing ]
    , [ "digit instrument disagrees with digitsP" | not (null digitFails) ]
    , concat rowsAndFails
    ]

reportCostBlock :: ((Integer,Integer),[Integer]) -> IO [String]
reportCostBlock ((p,a),ns) = do
  let d     = ordAt p a
      e     = ePrimeAt p a
      setup = lrSetup (lawVpCounted p a (head ns))
      rows  = map (costRow p a) ns
  printf "\n  p = %d, a = %d:  d = ord_p(a) = %d, e = e_p(a) = %d\n" p a d e
  printf "    one-time sensor cost (d and e, together): %d digit ops -- INDEPENDENT OF n\n" setup
  putStrLn "        n  chain   D(n)=digits_p(a^n-1)     naive cost   law/query   naive:law"
  mapM_ (\r ->
      printf "    %5d  %-5s   %10d          %14d   %9d   %s\n"
        (crN r) (if crChain r then "yes" else "no") (crDigits r)
        (crNaive r) (crQuery r)
        (showExactRatio (crNaive r) (crQuery r))) rows
  let firstOver = [ crN r | r <- rows, crChain r, crNaive r > setup ]
  case firstOver of
    (n0:_) -> printf "    the one-time cost is repaid by the FIRST on-chain query at n >= %d\n" n0
    []     -> putStrLn "    (no tabulated n exceeds the one-time cost)"
  putStrLn "    cross-check: both routes must return the same valuation at every n."
  let bad = [ r | r <- rows, not (crAgree r) ]
  if null bad
    then printf "    agreement: all %d rows agree (values %s)\n" (length rows)
           (intercalate "," (map (show . crValue) rows))
    else mapM_ (\r -> printf "    MISMATCH at n=%d\n" (crN r)) bad
  pure [ printf "cost-table route mismatch at p=%d a=%d n=%d" p a (crN r) | r <- bad ]

reportRewrite :: (String,Rule) -> IO ()
reportRewrite (grp,(l,r)) =
  printf "  [%-11s] %-30s -> %-14s  %s\n" grp (show l) (show r)
    (case orient (l,r) of
       Just (a,b) | (a,b) == (l,r) -> "oriented L->R"
                  | otherwise      -> "oriented R->L (flipped)"
       Nothing                     -> "UNORIENTABLE (lemma only)")
