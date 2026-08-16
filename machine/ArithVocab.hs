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
import Data.List (sortOn, sortBy, foldl', intercalate)
import Data.Maybe (mapMaybe, isJust)
import Text.Printf (printf)

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

precedence :: String -> Int
precedence f =
  case [ i | (i,s) <- zip [0..] vocabulary, symName s == f ] of
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
  ]

-- ============================================================ term generation
-- The simple generator from MathMachine (genTermsModulo [] []): all
-- well-formed terms of the signature up to a size bound, over nv variables.

genTerms :: [(String,Int)] -> Int -> Int -> [Term]
genTerms sig nv maxSize = concat table
  where
    table = [ build n | n <- [1..maxSize] ]
    ofSize n | n >= 1 && n <= maxSize = table !! (n-1)
             | otherwise = []
    build 1 = [ V i | i <- [0..nv-1] ] ++ [ F f [] | (f,0) <- sig ]
    build n = [ F f args | (f,a) <- sig, a > 0, args <- argsOf a (n-1) ]
      where
        argsOf 1 k | k >= 1 = map (:[]) (ofSize k)
                   | otherwise = []
        argsOf a k = [ t:rest | i <- [1..k-a+1]
                              , t <- ofSize i
                              , rest <- argsOf (a-1) (k-i) ]

-- ============================================================ refutation
-- Exact refutation by exhaustive computation over a small box.  A single
-- disagreeing environment is a certificate that the equation is false; the
-- convention is MathMachine's `ruleCounterexample`, widened to a chosen box.

smallEnvironments :: Int -> Integer -> [[Integer]]
smallEnvironments n bound = sequence (replicate n [0 .. bound])

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
  putStrLn "ARITHVOCAB SELF-TEST COMPLETE"

reportRewrite :: (String,Rule) -> IO ()
reportRewrite (grp,(l,r)) =
  printf "  [%-11s] %-30s -> %-14s  %s\n" grp (show l) (show r)
    (case orient (l,r) of
       Just (a,b) | (a,b) == (l,r) -> "oriented L->R"
                  | otherwise      -> "oriented R->L (flipped)"
       Nothing                     -> "UNORIENTABLE (lemma only)")
