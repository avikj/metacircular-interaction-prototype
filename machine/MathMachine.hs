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

import qualified Data.Map.Strict as M
import Data.List (sortOn, foldl', intercalate)
import Data.Maybe (mapMaybe, isJust)
import Data.IORef
import Control.Monad (forM_, when, unless)
import System.IO
import System.CPUTime (getCPUTime)
import Text.Printf (hPrintf)

-- ---------------------------------------------------------------- terms

data Term = V !Int | F !String [Term] deriving (Eq, Ord)

instance Show Term where
  show (V i) | i < 6 = [ "xyzuvw" !! i ]
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

subsetOf :: [Int] -> [Int] -> Bool
subsetOf a b = all (`elem` b) a

-- --------------------------------------------------------- the language
--
-- A symbol carries its arity and its meaning as a computation.  The
-- machine's vocabulary is data: it starts small and widens when the
-- machine exhausts what it can see.

-- A symbol is three things at once, and the machine needs all three:
-- how it computes (for killing conjectures), what it MEANS (its
-- defining equations, which are what makes proof possible at all), and
-- its arity.  A symbol without defining equations is a black box the
-- machine can test but never reason about — the first version of this
-- file had exactly that bug and proved nothing but coincidences.
data Sym = Sym { symName :: String
               , symArity :: Int
               , symSem :: [Integer] -> Integer
               , symDefs :: [(Term,Term)] }

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

vocabulary :: [Sym]
vocabulary =
  [ Sym "0"   0 (const 0)      []
  , Sym "s"   1 (\vs -> head vs + 1) []
  , Sym "+"   2 (\vs -> vs !! 0 + vs !! 1)
      [ (bin "+" x_ zero_,      x_)
      , (bin "+" x_ (su y_),    su (bin "+" x_ y_)) ]
  , Sym "*"   2 (\vs -> vs !! 0 * vs !! 1)
      [ (bin "*" x_ zero_,      zero_)
      , (bin "*" x_ (su y_),    bin "+" (bin "*" x_ y_) x_) ]
  , Sym "max" 2 (\vs -> max (vs !! 0) (vs !! 1))
      [ (bin "max" x_ zero_,          x_)
      , (bin "max" zero_ x_,          x_)
      , (bin "max" (su x_) (su y_),   su (bin "max" x_ y_)) ]
  , Sym "gcd" 2 (\vs -> gcd (vs !! 0) (vs !! 1))
      [ (bin "gcd" x_ zero_, x_)
      , (bin "gcd" zero_ x_, x_) ]
  ]

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
    Nothing -> 0

-- deterministic pseudo-random assignments: the machine must be
-- reproducible, so no system entropy enters.
lcg :: Integer -> Integer
lcg x = (6364136223846793005 * x + 1442695040888963407) `mod` (2^(62::Int))

assignments :: Int -> Int -> [[Integer]]
assignments nv count = go 12345 count
  where
    go _ 0 = []
    go s k = let vals = take nv (tail (iterate lcg s))
                 env = map (\v -> v `mod` 9) vals
             in env : go (lcg (s + 7)) (k-1)

-- the behavioural fingerprint of a term: what it computes everywhere
-- the machine has looked.  Terms with different fingerprints are
-- different functions and no conjecture between them can survive.
fingerprint :: M.Map String ([Integer] -> Integer) -> [[Integer]] -> Term -> [Integer]
fingerprint sem envs t = map (\e -> eval sem e t) envs

-- --------------------------------------------------------- generation

genTerms :: [(String,Int)] -> Int -> Int -> [Term]
genTerms sig nv maxSize = concat table
  where
    -- a lazy list, not a strict map: `build n` consults `ofSize m` only
    -- for m < n, so the knot ties, but only if the table's entries stay
    -- unforced until asked for.
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
decreases :: Term -> Term -> Bool
decreases u v
  | lpo u v = True
  | lpo v u = False
  | otherwise = (size v, v) < (size u, u)

normalize :: [Rule] -> Term -> Term
normalize rs = go (200 :: Int)
  where
    go 0 t = t
    go k t = case step rs t of
               Nothing -> t
               Just t' -> go (k-1) t'

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
    []    -> -1          -- the eigenconstant sits below everything

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

proveByInduction :: [Rule] -> (Term,Term) -> Maybe String
proveByInduction rs (l,r) =
  case ordNub (vars l ++ vars r) of
    [] -> Nothing
    vs -> firstJust [ tryVar v | v <- vs ]
  where
    firstJust xs = case mapMaybe id xs of
                     (x:_) -> Just x
                     []    -> Nothing
    tryVar v =
      let base = (substVar v zeroT l, substVar v zeroT r)
          hypL = substVar v eigen l
          hypR = substVar v eigen r
          goal = (substVar v (sucT eigen) l, substVar v (sucT eigen) r)
          -- the hypothesis goes in both directions; `step` will only
          -- fire it where it decreases, so an unorientable IH (the
          -- commutativity case) is still usable and still sound
          hyps = [(hypL,hypR),(hypR,hypL)]
      in if provedByRewriting rs base && provedByRewriting (hyps ++ rs) goal
           then Just ("induction on " ++ show (V v))
           else Nothing

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

-- --------------------------------------------------------- the machine

data Machine = Machine
  { mRules   :: [Rule]        -- proved equations, working as operations
  , mLemmas  :: [(Term,Term)] -- proved but unorientable (e.g. commutativity)
  , mKnown   :: M.Map (Term,Term) ()  -- everything already stated
  , mVocab   :: Int           -- how many symbols are in play
  , mSize    :: Int           -- current term-size horizon
  , mRound   :: Int
  }

start :: Machine
start = Machine [] [] M.empty 3 4 0

-- ordered rewriting lets unorientable theorems (commutativity) still be
-- used: apply them only in the direction that decreases the term.
lemmaRules :: [(Term,Term)] -> [Rule]
lemmaRules = concatMap (\(a,b) -> [(a,b),(b,a)])

-- What the machine may use to reason: the defining equations of the
-- symbols currently in play, everything it has proved and oriented, and
-- its unorientable theorems applied only in the decreasing direction.
usableRules :: Machine -> [Rule]
usableRules m =
  definitionsOf (take (mVocab m) vocabulary)
    ++ mRules m
    ++ lemmaRules (mLemmas m)

round1 :: Handle -> Handle -> IORef Machine -> IO ()
round1 logh libh ref = do
  m <- readIORef ref
  t0 <- getCPUTime
  let syms = take (mVocab m) vocabulary
      sig = arities syms
      sem = semantics syms
      nv = 3
      envs = assignments nv 40
      rules = usableRules m
      raw = genTerms sig nv (mSize m)
      -- knowledge pays here: everything already known collapses
      normed = ordNub (map (normalize rules) raw)
      classes = M.elems (M.fromListWith (++)
                  [ (fingerprint sem envs t, [t]) | t <- normed ])
      conjectures = ordNub
        [ canonVars (rep, other)
        | cls <- classes
        , length cls > 1
        , let sorted = sortOn (\t -> (size t, t)) cls
        , let rep = head sorted
        , other <- tail sorted
        ]
      -- rewriting settles the ones already implied by what we know
      -- a theorem is stated once, ever: a machine that keeps rediscovering
      -- what it wrote down last round is not learning, it is looping
      fresh = [ c | c <- conjectures
                  , not (M.member c (mKnown m))
                  , not (provedByRewriting rules c) ]
      -- Proofs must be usable the moment they exist, not next round: a
      -- theorem proved at 10am should already be killing conjectures at
      -- 10:01.  So the round folds its own discoveries back in as it goes.
      results = reverse (snd (foldl' attempt (rules, []) fresh))
      attempt (acc, out) c
        | provedByRewriting acc c = (acc, out)
        | otherwise =
            case proveByInduction acc c of
              Nothing -> (acc, out)
              Just pf ->
                let acc' = acc ++ maybe [] (:[]) (orient c)
                            ++ (if isJust (orient c) then [] else lemmaRules [c])
                in (acc', (c,pf):out)
  t1 <- getCPUTime
  let secs = fromIntegral (t1 - t0) / (1e12 :: Double)
      prunedPct :: Double
      prunedPct = if null raw then 0
                  else 100 * (1 - fromIntegral (length normed)
                                  / fromIntegral (length raw))
      newRules = mapMaybe (orient . fst) results
      newLemmas = [ c | (c,_) <- results, not (isJust (orient c)) ]
      m' = m { mRules = mRules m ++ newRules
             , mLemmas = mLemmas m ++ newLemmas
             , mKnown = foldl' (\k (c,_) -> M.insert c () k) (mKnown m) results
             , mRound = mRound m + 1 }
  forM_ results $ \((l,r),pf) -> do
    hPrintf libh "%-46s = %-24s   [%s]\n" (show l) (show r) pf
    hPrintf logh "  THEOREM  %s = %s   (%s)\n" (show l) (show r) pf
  hFlush libh
  hPrintf logh
    "round %d  vocab=%d size=%d  terms=%d normed=%d pruned=%.1f%%  conj=%d fresh=%d proved=%d  known=%d  %.2fs\n"
    (mRound m) (mVocab m) (mSize m) (length raw) (length normed)
    prunedPct (length conjectures) (length fresh) (length results)
    (length (mRules m') + length (mLemmas m')) secs
  hFlush logh
  -- GROW: nothing new means the machine must change what it is looking at
  let stuck = null results
      m'' | not stuck = m'
          | mVocab m' < length vocabulary && even (mRound m') =
              m' { mVocab = mVocab m' + 1 }
          | mSize m' < 9 = m' { mSize = mSize m' + 1 }
          | mVocab m' < length vocabulary = m' { mVocab = mVocab m' + 1 }
          | otherwise = m' { mSize = mSize m' + 1 }
  when (stuck && mVocab m'' > mVocab m') $
    hPrintf logh "  GROW  vocabulary widens to %d symbols (%s)\n"
      (mVocab m'') (symName (vocabulary !! (mVocab m'' - 1)))
  when (stuck && mSize m'' > mSize m') $
    hPrintf logh "  GROW  size horizon rises to %d\n" (mSize m'')
  hFlush logh
  writeIORef ref m''

main :: IO ()
main = do
  logh <- openFile "machine/machine.log" AppendMode
  libh <- openFile "machine/library.txt" AppendMode
  hSetBuffering logh LineBuffering
  hSetBuffering libh LineBuffering
  hPutStrLn logh "=== MathMachine start ==="
  ref <- newIORef start
  let loop = do
        round1 logh libh ref
        m <- readIORef ref
        when (mSize m <= 12) loop
  loop
  hPutStrLn logh "=== horizon reached ==="
  hClose logh
  hClose libh
