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
import Control.Monad (forM_, when, unless, filterM)
import Control.Exception (finally)
import System.IO
import System.Directory (getTemporaryDirectory, removePathForcibly)
import System.FilePath ((</>))
import System.Process (readProcess, readProcessWithExitCode)
import System.Exit (ExitCode(..), exitFailure)
import System.Environment (getArgs)
import System.CPUTime (getCPUTime)
import Text.Printf (hPrintf)
import Text.ParserCombinators.ReadP
import Data.Char (isAlphaNum, isSpace)
import System.Directory (doesFileExist)
import System.Exit (exitSuccess)
-- (imports for the unbuilt evolve step removed; they were dead, and a
-- dead import is a claim about what a program does)

-- ===================================================================
-- KNOBS.  The machine's tunable constants, laid out so that they CAN be
-- found and rewritten in this source text.
--
-- HONEST STATUS: nothing rewrites them yet.  An earlier version of this
-- banner said "every line below is rewritten by the machine itself
-- during evolution" — that was aspiration written in the present tense,
-- which is the exact sin this repository was founded to stop.  The
-- evolve step (mutate source, compile variant, race it, exec the
-- winner) is designed and not built; the imports for it below are dead
-- until it is.  Two visiting readers caught this in the same hour.
-- ===================================================================
kProbe :: Int
kProbe = 400
kAssign :: Int
kAssign = 40
kMinPrune :: Int
kMinPrune = 1
kConceptMin :: Int
kConceptMin = 8
-- How much shorter the probe must get before a name is worth having.
-- A fold of a pattern of size p saves p-1 symbols, and the smallest
-- admissible pattern has size 3, so one fold saves at least 2: this
-- threshold is "at least four real folds".  It is a gate on description
-- length, which is the only currency a DEFINITION can be paid in — see
-- `marginalCompress` for why the old prune-based gate could never pass.
kConceptGain :: Int
kConceptGain = 8
kVars :: Int
kVars = 3
kSizeCap :: Int
kSizeCap = 7

-- ---------------------------------------------------------------- terms

data Term = V !Int | F !String [Term] deriving (Eq, Ord)

instance Show Term where
  show (V i) | i < 6 = [ "xyzuvw" !! i ]
             | otherwise = "n" ++ show i
  show (F f []) = f
  show (F f [a,b])
    | f `elem` ["+","*","^","gcd","max"] = "(" ++ show a ++ f ++ show b ++ ")"
  show (F f as) = f ++ "(" ++ intercalate "," (map show as) ++ ")"

-- ------------------------------------------------ researcher thought input

-- A candidate line becomes the machine's own equation object.  Any line
-- which does not parse is retained exactly as a residual; known vocabulary
-- names inside residuals can still widen the language needed for the next
-- round, but are never mistaken for equations.
data ThoughtBatch = ThoughtBatch
  { thoughtCandidates :: [(Term,Term)]
  , thoughtResiduals  :: [String]
  } deriving (Eq, Show)

splitTabs :: String -> [String]
splitTabs s = case break (== '\t') s of
  (a, [])     -> [a]
  (a, _:rest) -> a : splitTabs rest

identifier :: ReadP String
identifier = munch1 (\c -> isAlphaNum c || c `elem` "+*-^#_")

termP :: ReadP Term
termP = do
  name <- identifier
  args <- option Nothing (Just <$> between (char '(') (char ')')
                    (sepBy termP (char ',')))
  case (name, args) of
    ([v], Nothing) | Just i <- lookup v (zip "xyzuvw" [0..]) -> pure (V i)
    (_, Nothing) -> pure (F name [])
    (_, Just ts) -> pure (F name ts)

parseTerm :: String -> Maybe Term
parseTerm s = case [ t | (t, rest) <- readP_to_S (termP <* eof) s, null rest ] of
  [t] -> Just t
  _   -> Nothing

parseThoughts :: String -> ThoughtBatch
parseThoughts = foldl' parseLine (ThoughtBatch [] []) . lines
  where
    parseLine b line
      | all isSpace line = b
      | otherwise = case splitTabs line of
          ["candidate", l, r]
            | Just lt <- parseTerm l, Just rt <- parseTerm r ->
                b { thoughtCandidates = thoughtCandidates b ++ [(lt,rt)] }
          _ -> b { thoughtResiduals = thoughtResiduals b ++ [line] }

residualWords :: String -> [String]
residualWords = words . map (\c -> if isAlphaNum c || c `elem` "+*-^#_" then c else ' ')

requiredVocabulary :: ThoughtBatch -> Int
requiredVocabulary b = maximum (3 : demanded)
  where
    names = concatMap (\(l,r) -> symbolsIn l ++ symbolsIn r)
              (thoughtCandidates b)
            ++ concatMap residualWords (thoughtResiduals b)
    demanded = [ i + 1 | (i,s) <- zip [0..] vocabulary, symName s `elem` names ]

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
  , Sym "-"   2 (\vs -> max 0 (vs !! 0 - vs !! 1))
      [ (bin "-" x_ zero_,          x_)
      , (bin "-" zero_ x_,          zero_)
      , (bin "-" (su x_) (su y_),   bin "-" x_ y_) ]
  , Sym "gcd" 2 (\vs -> gcd (vs !! 0) (vs !! 1))
      -- gcd needs its recursion, not just its base cases: a symbol the
      -- machine can compute but not unfold is a black box it can test
      -- and never reason about.
      [ (bin "gcd" x_ zero_, x_)
      , (bin "gcd" zero_ x_, x_)
      , (bin "gcd" (su x_) (su y_), bin "gcd" (F "-" [su x_, su y_]) (su y_)) ]
  , Sym "le"  2 (\vs -> if vs !! 0 <= vs !! 1 then 1 else 0)
      -- Eleven of the machine's thirty-five theorems were `max`-shaped
      -- restatements of x <= y.  It was not producing junk; it was
      -- reaching for a predicate it had no name for.  (x+y) = ((x+y)max x)
      -- IS x <= x+y wearing a costume.
      [ (bin "le" zero_ x_,          su zero_)
      , (bin "le" (su x_) zero_,     zero_)
      , (bin "le" (su x_) (su y_),   bin "le" x_ y_) ]
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
genTerms = genTermsModulo [] []

-- Compile a proved commutativity law into the grammar: for a binary symbol
-- in `comm`, generate one representative of the transposition orbit.  This
-- removes the losing branch before a `Term` exists.
genTermsModulo :: [String] -> [String] -> [(String,Int)] -> Int -> Int -> [Term]
genTermsModulo comm assoc sig nv maxSize = concat table
  where
    -- a lazy list, not a strict map: `build n` consults `ofSize m` only
    -- for m < n, so the knot ties, but only if the table's entries stay
    -- unforced until asked for.
    table = [ build n | n <- [1..maxSize] ]
    ofSize n | n >= 1 && n <= maxSize = table !! (n-1)
             | otherwise = []
    build 1 = [ V i | i <- [0..nv-1] ] ++ [ F f [] | (f,0) <- sig ]
    build n = [ F f args | (f,a) <- sig, a > 0, args <- argsOf a (n-1)
                          , canonical f args ]
      where
        canonical f [l,r] | f `elem` comm && f `elem` assoc =
          not (headed f l) && sortedBy cmpTerm (flatten f l ++ flatten f r)
        canonical f [l,r] | f `elem` comm = cmpTerm l r /= GT
        canonical _ _ = True
        headed f (F g _) = f == g
        headed _ _ = False
        flatten f (F g [l,r]) | f == g = flatten f l ++ flatten f r
        flatten _ t = [t]
        sortedBy _ [] = True
        sortedBy _ [_] = True
        sortedBy cmp (x:y:xs) = cmp x y /= GT && sortedBy cmp (y:xs)
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
-- The fallback must agree with the precedence, not with Haskell's
-- derived Ord — which compares symbol names as ASCII ("*" < "+" < "0"
-- < "gcd" < "max" < "s"), an order orthogonal to the one the machine
-- reasons with.  Sorting by a stranger's alphabet is why a third of the
-- library came out as `max`-shaped restatements of single facts.
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
    [] -> case f of
      -- An invented concept must sit BELOW everything its defining
      -- pattern mentions, so that rewriting folds into it; and later
      -- concepts below earlier ones, so a concept built from concepts
      -- still folds.  Giving them all -1 left the machine's own ideas
      -- mutually unorderable — second-class citizens in its own order.
      ('c':ds) | all (`elem` "0123456789") ds, not (null ds) ->
        -2 - read ds
      _ -> -1            -- the eigenconstant sits below everything

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

-- f(a,b) = f(a',b') where a=a' and b=b' are already known is not a
-- discovery, it is congruence.  Most of what an unfiltered explorer
-- emits is this: one law wearing a hat.  Stating it costs a proof
-- search and buys nothing, so it is filtered before induction is spent.
congruent :: [Rule] -> M.Map (Term,Term) () -> (Term,Term) -> Bool
congruent rs known (F f as, F g bs)
  | f == g, length as == length bs, or (zipWith (/=) as bs) =
      and [ a == b
            || provedByRewriting rs (a,b)
            || M.member (canonVars (a,b)) known
            || M.member (canonVars (b,a)) known
          | (a,b) <- zip as bs ]
congruent _ _ _ = False

-- What is a theorem worth?  The machine already measures its own
-- progress as the fraction of the term space its knowledge removes.
-- That same measurement, applied to ONE candidate, is its value: how
-- many distinct terms collapse if this equation is installed.  A law
-- that collapses nothing is a true statement with no consequences, and
-- the machine has proved a hundred and eighty of those.  Now it must
-- pay its way in.
marginalPrune :: [Rule] -> [Term] -> (Term,Term) -> Int
marginalPrune rules probe c =
  let before = length (ordNub (map (normalize rules) probe))
      extra = case orient c of
                Just r  -> [r]
                Nothing -> lemmaRules [c]
      after = length (ordNub (map (normalize (extra ++ rules)) probe))
  in before - after

-- THE CONCEPT GATE WAS UNSATISFIABLE.  For eighteen rounds the machine
-- reached for a new idea four times and named nothing, because the test
-- it had to pass cannot be passed.  This is a theorem, not a tuning
-- problem:
--
--   Let c be a symbol occurring neither in R nor in the probe set S, and
--   let R' = R ∪ {p → c(x₁…x_k)} where vars p = {x₁…x_k}.  Let u be the
--   unfolding that rewrites c(t₁…t_k) ↦ p[xᵢ↦tᵢ]; u is well defined
--   because c is fresh, and u(nf_{R'}(t)) = nf_R(t) for every c-free t.
--   So nf_{R'} restricted to S is injective wherever nf_R is, hence
--     |nf_{R'}(S)| ≥ |nf_R(S)|   and   marginalPrune ≤ 0,  always.
--
-- A definition FOLDS; it does not MERGE.  Asking a definition to collapse
-- distinct normal forms is asking it to be a theorem.  So `marginalPrune`
-- is the right currency for a proved equation and the wrong one for a
-- name, and the gate rejected every candidate for a reason no amount of
-- lowering kConceptMin would have reached.
--
-- The comment above `patternsOf` already said what the criterion should
-- be — "the criterion is description length" — and the code measured
-- something else.  This is that criterion: total size of the probe's
-- normal forms.  Folding x+x (size 3) into c₀(x) (size 2) shortens; a
-- name that does not shorten is not worth having.
marginalCompress :: [Rule] -> [Term] -> (Term,Term) -> Int
marginalCompress rules probe c =
  let extra = case orient c of
                Just r  -> [r]
                Nothing -> lemmaRules [c]
      before = sum (map (size . normalize rules) probe)
      after  = sum (map (size . normalize (extra ++ rules)) probe)
  in before - after

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

-- ------------------------------------------------------- Agda kernel seam
-- The first proof-producing seam is intentionally narrow.  The Haskell
-- search may propose any equation, but only the shared Peano fragment can be
-- translated, and its first certificate language is Agda's `refl`.
-- Consequently acceptance means definitional equality in Agda itself; the
-- Haskell induction trace is never mistaken for a kernel certificate.

agdaTerm :: Term -> Maybe String
agdaTerm (V i)
  | i >= 0 && i < 6 = Just ["xyzuvw" !! i]
  | otherwise = Nothing
agdaTerm (F "0" []) = Just "zero"
agdaTerm (F "s" [t]) = (\u -> "suc (" ++ u ++ ")") <$> agdaTerm t
agdaTerm (F "+" [a,b]) = binAgda "+" a b
agdaTerm (F "*" [a,b]) = binAgda "·" a b
agdaTerm _ = Nothing

binAgda :: String -> Term -> Term -> Maybe String
binAgda op a b = do
  x <- agdaTerm a
  y <- agdaTerm b
  pure ("(" ++ x ++ " " ++ op ++ " " ++ y ++ ")")

agdaCertificate :: (Term,Term) -> Maybe String
agdaCertificate (l,r) = do
  lhs <- agdaTerm l
  rhs <- agdaTerm r
  pure $ unlines
    [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
    , "module Candidate where"
    , "open import Cubical.Foundations.Prelude"
    , "open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)"
    , "candidate : (x y z u v w : ℕ) → " ++ lhs ++ " ≡ " ++ rhs
    , "candidate x y z u v w = refl"
    ]


kernelAccept :: Handle -> Int -> ((Term,Term),String) -> IO Bool
kernelAccept logh roundNo ((l,r),_) =
  case agdaCertificate (l,r) of
    Nothing -> do
      hPrintf logh "  KERNEL-SKIP  unsupported fragment: %s = %s\n" (show l) (show r)
      pure False
    Just source -> do
      tmp <- getTemporaryDirectory
      -- A fixed directory lets concurrent machine processes overwrite one
      -- another's proposition between write and check.  `mktemp -d` makes
      -- the proposition/check pair private; cleanup also runs on exceptions.
      dirLine <- readProcess "mktemp" ["-d", tmp </> "math-machine-agda.XXXXXX"] ""
      let dir = reverse (dropWhile isSpace (reverse dirLine))
          file = dir </> "Candidate.agda"
      (do writeFile file source
          (code,out,err) <- readProcessWithExitCode "agda"
            ["-i", "formal/cubical", "-i", dir, file] ""
          case code of
            ExitSuccess -> do
              hPrintf logh "  KERNEL-ACCEPT round=%d %s = %s\n"
                roundNo (show l) (show r)
              pure True
            ExitFailure _ -> do
              hPrintf logh "  KERNEL-REJECT round=%d %s = %s  %s\n"
                roundNo (show l) (show r) (take 160 (filter (/= '\n') (out ++ err)))
              pure False)
        `finally` removePathForcibly dir

-- --------------------------------------------------------- the machine

data Machine = Machine
  { mRules   :: [Rule]        -- proved equations, working as operations
  , mLemmas  :: [(Term,Term)] -- proved but unorientable (e.g. commutativity)
  , mKnown   :: M.Map (Term,Term) ()  -- everything already stated
  , mInvented :: [Sym]        -- concepts the machine named for itself
  , mRetired :: [Term]        -- patterns it named, never used, and withdrew
  , mFailed  :: M.Map (Term,Term) Int  -- conjecture -> rule count when it failed
  , mThoughts :: [(Term,Term)] -- researcher candidates, as native terms
  , mResiduals :: [String]     -- exact lines not promoted to equations
  , mVocab   :: Int           -- how many symbols are in play
  , mSize    :: Int           -- current term-size horizon
  , mRound   :: Int
  }

start :: Machine
start = Machine [] [] M.empty [] [] M.empty [] [] 3 4 0

-- CONCEPT INVENTION.  A machine whose vocabulary is a list somebody
-- else typed can only ever compress the consequences of that list; when
-- the consequences run out it is finished, and every genuinely new idea
-- in its life came from outside.  So it must be able to name things.
--
-- The criterion is description length: take the shapes that keep
-- recurring across the terms the machine actually works with, and give
-- a name to the one that would shorten the most.  `double` and `square`
-- are not primitive to arithmetic — they are the names worth having
-- because x+x and x*x keep showing up.  A named concept enters the
-- vocabulary with its defining equation, so everything downstream can
-- reason about it, and it is given the lowest precedence so that
-- rewriting FOLDS into it: the machine's own abbreviation becomes the
-- normal form.
patternsOf :: Term -> [Term]
patternsOf t = [ p | p <- subterms t, size p >= 3, size p <= 5
                   , not (null (vars p)), length (ordNub (vars p)) <= 2 ]
  where
    subterms u@(F _ ts) = u : concatMap subterms ts
    subterms u = [u]

symbolsIn :: Term -> [String]
symbolsIn (V _) = []
symbolsIn (F f ts) = f : concatMap symbolsIn ts

canonTerm :: Term -> Term
canonTerm t = applySub ren t
  where ren = M.fromList (zip (ordNub (vars t)) (map V [0..]))

inventConcept syms retired terms n =
  case best of
    []        -> Nothing
    ((p,_):_) ->
      let vs = ordNub (vars p)
          ar = length vs
          nm = "c" ++ show n
          sem = semantics syms
      in Just (Sym nm ar (\args -> eval sem args p)
                 [ (p, F nm (map V [0 .. ar-1])) ])
  where
    best = bestOf syms retired terms

-- candidate concepts, best first: how often a shape appears times how
-- much naming it would save.  A shape already named is not a new idea.
bestOf :: [Sym] -> [Term] -> [Term] -> [(Term,Int)]
bestOf syms retired terms =
    take 1 (sortOn (\(p,c) -> negate (c * (size p - 1)))
             [ pc | pc@(p,c) <- counts, c >= kConceptMin, headIsNotFresh p
                  , not (alreadyNamed p), not (trivialApp p)
                  , mentionsPrimitive p
                  , canonTerm p `notElem` retired ])
  where
    -- A TOWER IS NOT A THOUGHT.  With the description-length gate live,
    -- the machine's first name was `c0 := x+x` — exactly the `double`
    -- this code was written to hope for.  Its second was `c1 := c0(c0(x))`,
    -- its third `c2 := c1(c0(x))`, and so on: 2x, 4x, 8x, forever, each
    -- one shortening the probe and each one proving nothing.
    --
    -- That is not a threshold that needs raising, it is the gate being
    -- the wrong shape.  Description length ALWAYS improves under
    -- composition — naming f∘g saves a symbol at every occurrence, for
    -- any f and g — so no bound on compression can rule out the tower.
    -- The constraint has to be about content: a pattern assembled purely
    -- from names the machine already has contains no operation that was
    -- not already named.  It is a re-abbreviation.
    --
    -- So: concepts may appear INSIDE a pattern (the Lovelace point above
    -- stands — abstraction must be able to stack), but the pattern must
    -- contribute at least one primitive of its own.  c0(x)+x is a new
    -- function; c0(c0(x)) is c0 said twice.
    mentionsPrimitive p =
      any (`elem` map symName vocabulary) (symbolsIn p)
    counts = M.toList (M.fromListWith (+)
               [ (canonTerm p, 1::Int) | t <- terms, p <- patternsOf t ])
    -- Lovelace: rejecting c-headed patterns caps the tower of
    -- abstraction at height one — a concept could appear beneath a head
    -- but never as one, so no concept is ever built from concepts.
    headIsNotFresh (F _ _) = True
    headIsNotFresh _ = False
    -- f(x,y) is not a concept, it is f with a costume on.  A name earns
    -- its place by capturing structure the signature cannot say in one
    -- application: a repeated argument (x+x), or nesting (s(x+x)).
    trivialApp (F _ args) =
      all isVar args && length (ordNub (concatMap vars args)) == length args
      where isVar (V _) = True
            isVar _ = False
    trivialApp _ = True
    alreadyNamed p =
      any (\s -> any ((== canonTerm p) . canonTerm . fst) (symDefs s)) syms

-- ordered rewriting lets unorientable theorems (commutativity) still be
-- used: apply them only in the direction that decreases the term.
lemmaRules :: [(Term,Term)] -> [Rule]
lemmaRules = concatMap (\(a,b) -> [(a,b),(b,a)])

-- What the machine may use to reason: the defining equations of the
-- symbols currently in play, everything it has proved and oriented, and
-- its unorientable theorems applied only in the decreasing direction.
usableRules :: Machine -> [Rule]
usableRules m =
  -- Grothendieck: the invented symbols' OWN defining equations were
  -- missing here, while `round1` put those symbols into the term space
  -- and the fingerprint.  So every concept the machine named for itself
  -- became exactly the black box this file's header warns about — it
  -- could compute with it and never unfold it.  The bug documented for
  -- `gcd` at the top, reintroduced for the machine's own ideas.
  definitionsOf (take (mVocab m) vocabulary ++ mInvented m)
    ++ mRules m
    ++ lemmaRules (mLemmas m)

provedCommutative :: Machine -> [String]
provedCommutative m =
  [ symName s
  | s <- take (mVocab m) vocabulary ++ mInvented m
  , symArity s == 2
  , let law = canonVars (F (symName s) [x_,y_], F (symName s) [y_,x_])
  , M.member law (mKnown m) || M.member (swap law) (mKnown m) ]
  where swap (a,b) = (b,a)

provedAssociative :: Machine -> [String]
provedAssociative m =
  [ symName s
  | s <- take (mVocab m) vocabulary ++ mInvented m
  , symArity s == 2
  , let f = symName s
        law = canonVars (F f [F f [x_,y_],z_], F f [x_,F f [y_,z_]])
  , M.member law (mKnown m) || M.member (swap law) (mKnown m) ]
  where swap (a,b) = (b,a)

round1 :: Handle -> Handle -> IORef Machine -> IO ()
round1 logh libh ref = do
  m <- readIORef ref
  t0 <- getCPUTime
  let syms = take (mVocab m) vocabulary ++ mInvented m
      sig = arities syms
      sem = semantics syms
      nv = kVars
      envs = assignments nv kAssign
      rules = usableRules m
      raw = genTermsModulo (provedCommutative m) (provedAssociative m)
              sig nv (mSize m)
      -- knowledge pays here: everything already known collapses
      normed = ordNub (map (normalize rules) raw)
      classes = M.elems (M.fromListWith (++)
                  [ (fingerprint sem envs t, [t]) | t <- normed ])
      conjectures = ordNub
        ( [ canonVars (rep, other)
          | cls <- classes
          , length cls > 1
          , let sorted = sortOn (\t -> (size t, t)) cls
          , let rep = head sorted
          , other <- tail sorted
          ]
        ++ [ canonVars (l,r)
           | (l,r) <- mThoughts m
           , all (`elem` map symName syms) (symbolsIn l ++ symbolsIn r)
           , fingerprint sem envs l == fingerprint sem envs r ] )
      -- rewriting settles the ones already implied by what we know
      -- a theorem is stated once, ever: a machine that keeps rediscovering
      -- what it wrote down last round is not learning, it is looping
      -- A conjecture that failed is not retried until the machine knows
      -- something it did not know then.  Without this the same hundreds
      -- of failures are re-derived and re-attempted every round for the
      -- life of the process — the largest cost centre there is, and it
      -- is spent on questions already asked.
      nRules = length rules
      -- ORDER MATTERS, and it was hash order.  `conjectures` comes out of
      -- a Map keyed on fingerprints, so the machine attacked its own
      -- questions in an order determined by a hash function.  The fold
      -- below feeds each proof back in as it goes, so a small general
      -- lemma proved early pays for every later conjecture in the same
      -- round, and proved late pays for none of them — the difference
      -- between finding x+s(y)=s(x+y) before x+y=y+x and after it.
      -- Smallest first is the only order with that property.
      fresh = sortOn (\(l,r) -> (size l + size r, l, r))
              [ c | c <- conjectures
                  , not (M.member c (mKnown m))
                  , M.lookup c (mFailed m) /= Just nRules
                  , not (provedByRewriting rules c)
                  , not (congruent rules (mKnown m) c) ]
      -- Proofs must be usable the moment they exist, not next round: a
      -- theorem proved at 10am should already be killing conjectures at
      -- 10:01.  So the round folds its own discoveries back in as it goes.
      probe = take kProbe normed
      results = reverse (snd (foldl' attempt (rules, []) fresh))
      attempt (acc, out) c
        | provedByRewriting acc c = (acc, out)
        | otherwise =
            case proveByInduction acc c of
              Nothing -> (acc, out)
              Just pf
                -- a proof is not enough: it must also make the world
                -- smaller, or it is a true statement with no consequences
                | marginalPrune acc probe c < kMinPrune -> (acc, out)
                | otherwise ->
                    let acc' = acc ++ maybe [] (:[]) (orient c)
                                ++ (if isJust (orient c) then []
                                    else lemmaRules [c])
                    in (acc', (c,pf):out)
  -- The timer used to bracket a lazy `let`, so nothing had been computed
  -- when it stopped and every round reported 0.00s.  A dead instrument is
  -- worse than none: it is the one that would have shown the rule set
  -- slowing the machine down.  Force the work before stopping the clock.
  let nRaw = length raw
      nNormed = length normed
      nConj = length conjectures
      nFresh = length fresh
      nRes = length results
  nRes `seq` nFresh `seq` nConj `seq` nNormed `seq` nRaw `seq` return ()
  checkedResults <- filterM (kernelAccept logh (mRound m)) results
  t1 <- getCPUTime
  let secs = fromIntegral (t1 - t0) / (1e12 :: Double)
      prunedPct :: Double
      prunedPct = if null raw then 0
                  else 100 * (1 - fromIntegral (length normed)
                                  / fromIntegral (length raw))
      newRules = mapMaybe (orient . fst) checkedResults
      newLemmas = [ c | (c,_) <- checkedResults, not (isJust (orient c)) ]
      m' = m { mRules = mRules m ++ newRules
             , mLemmas = mLemmas m ++ newLemmas
             , mKnown = foldl' (\k (c,_) -> M.insert c () k) (mKnown m) checkedResults
             , mFailed = foldl' (\k c -> M.insert c nRules k) (mFailed m)
                          [ c | c <- fresh, notElem c (map fst checkedResults) ]
             , mRound = mRound m + 1 }
  forM_ checkedResults $ \((l,r),pf) -> do
    hPrintf libh "%-46s = %-24s   [%s]\n" (show l) (show r) pf
    hPrintf logh "  THEOREM  %s = %s   (%s)\n" (show l) (show r) pf
  hFlush libh
  hPrintf logh
    "round %d  vocab=%d size=%d  terms=%d normed=%d pruned=%.1f%%  conj=%d fresh=%d proved=%d  known=%d  %.2fs\n"
    (mRound m) (mVocab m) (mSize m) (length raw) (length normed)
    prunedPct (length conjectures) (length fresh) (length checkedResults)
    (length (mRules m') + length (mLemmas m')) secs
  hFlush logh
  -- GROW: nothing new means the machine must change what it is looking at
  -- When the machine runs dry it first tries to think of a new idea:
  -- name the shape that keeps recurring in its own working terms.  Only
  -- if it cannot does it fall back to widening the given vocabulary or
  -- looking further out.
  let stuck = null checkedResults
      -- a name must pay for itself in exactly the currency a theorem
      -- does: it enters only if folding the shape into it makes the
      -- machine's own working set smaller
      -- A NAME EARNS ITS SUCCESSOR BY BEING USED.  Even with the tower
      -- ruled out, a machine allowed to name something every time it is
      -- stuck will name instead of prove: each new symbol multiplies the
      -- term space (25k → 396k over four rounds of naming, with `proved`
      -- flat at zero), so naming makes the next round harder and the one
      -- after that harder still.  The honest test of a name is whether a
      -- theorem was stated with it.  Until the last one has appeared in
      -- something proved, the machine may not coin another — it must
      -- either use the idea it has, or widen the vocabulary it was given.
      lastNameUsed = case mInvented m' of
        [] -> True
        ss -> let nm = symName (last ss)
              in any (\(l,r) -> nm `elem` (symbolsIn l ++ symbolsIn r))
                     (M.keys (mKnown m'))
      candidate = if stuck && lastNameUsed
                    then inventConcept syms (mRetired m') normed
                           (length (mInvented m'))
                    else Nothing
      invented = case candidate of
        Just s | let (pat,fold) = head (symDefs s)
               , marginalCompress (usableRules m') (take kProbe normed) (pat,fold)
                   >= kConceptGain
               -> Just s
        _ -> Nothing
  case invented of
    Just s -> hPrintf logh "  CONCEPT  named %s := %s  (arity %d)\n"
                (symName s) (show (fst (head (symDefs s)))) (symArity s)
    Nothing -> return ()
  let m2 = case invented of
             Just s  -> m' { mInvented = mInvented m' ++ [s] }
             Nothing -> m'
      stuck' = stuck && not (isJust invented)
      m'' | not stuck' = m2
          | mVocab m2 < length vocabulary && even (mRound m2) =
              m2 { mVocab = mVocab m2 + 1 }
          | mSize m2 < kSizeCap = m2 { mSize = mSize m2 + 1 }
          | mVocab m2 < length vocabulary = m2 { mVocab = mVocab m2 + 1 }
          -- Past this point the given vocabulary is exhausted and the
          -- size horizon is at its cap.  The machine used to answer that
          -- by raising the horizon anyway and then halting — growing the
          -- one dimension its own numbers said was not the constraint
          -- (rounds 16-18: conjectures 9k → 18k, proved 0 → 5 → 0; the
          -- prover was the bottleneck, not the search).  The only way out
          -- is a name, and if the last name it coined is going unused
          -- then that name is the thing standing in the way: WITHDRAW IT.
          -- Retiring restores the term space the dead symbol was costing
          -- and frees the coin slot for a different pattern, and the
          -- retired pattern is remembered so it is not re-proposed.
          --
          -- Without this the previous rule deadlocks, and the deadlock is
          -- provable rather than probable: with no results, no concept
          -- and no axis moved, the next round has the same rules, vocab
          -- and size, hence the same terms, hence the same conjectures,
          -- all of them memoized-failed at the same rule count — fresh=0
          -- forever.  Rounds 19 and 20 of the previous run were
          -- bit-identical, 45 seconds each.  A machine spinning on a
          -- state it can prove it cannot leave is worse than one that
          -- halts, because it looks alive.
          | not (null (mInvented m2)) =
              m2 { mInvented = init (mInvented m2)
                 , mRetired = mRetired m2
                     ++ [ canonTerm (fst (head (symDefs (last (mInvented m2))))) ] }
          -- Nothing left to withdraw and nothing left to widen: the
          -- machine genuinely needs more room, and saying so by raising
          -- the horizon is now the honest move rather than the lazy one.
          | otherwise = m2 { mSize = mSize m2 + 1 }
  when (stuck && mVocab m'' > mVocab m2) $
    hPrintf logh "  GROW  vocabulary widens to %d symbols (%s)\n"
      (mVocab m'') (symName (vocabulary !! (mVocab m'' - 1)))
  when (stuck && mSize m'' > mSize m2) $
    hPrintf logh "  GROW  size horizon rises to %d\n" (mSize m'')
  when (stuck && length (mInvented m'') < length (mInvented m2)) $
    hPrintf logh "  RETIRE  %s went unused; withdrawn, and it will not be re-proposed\n"
      (symName (last (mInvented m2)))
  hFlush logh
  writeIORef ref m''

main :: IO ()
main = do
  args <- getArgs
  when (args == ["--commutative-grammar-self-test"]) $ do
    let sig = [("0",0),("+",2)]
        raw = genTerms sig 2 7
        quotient = genTermsModulo ["+"] [] sig 2 7
        commLaw = (bin "+" x_ y_, bin "+" y_ x_)
        oldNF = ordNub (map (normalize (lemmaRules [commLaw])) raw)
        newNF = ordNub (map (normalize (lemmaRules [commLaw])) quotient)
    unless (oldNF == newNF && length quotient < length raw) exitFailure
    hPrintf stdout "COMMUTATIVE GRAMMAR CHECKED: raw=%d representatives=%d eliminated=%d coverage=exact\n"
      (length raw) (length quotient) (length raw - length quotient)
    exitSuccess
  when (args == ["--ac-grammar-self-test"]) $ do
    let sig = [("0",0),("+",2)]
        raw = genTerms sig 2 7
        quotient = genTermsModulo ["+"] ["+"] sig 2 7
        commLaw = (bin "+" x_ y_, bin "+" y_ x_)
        assocLaw = (bin "+" (bin "+" x_ y_) z_,
                    bin "+" x_ (bin "+" y_ z_))
        theory = lemmaRules [commLaw, assocLaw]
        oldNF = ordNub (map (normalize theory) raw)
        newNF = ordNub (map (normalize theory) quotient)
    unless (oldNF == newNF && length quotient < length raw) exitFailure
    hPrintf stdout "AC GRAMMAR CHECKED: raw=%d multisets=%d eliminated=%d coverage=exact\n"
      (length raw) (length quotient) (length raw - length quotient)
    exitSuccess
  when (args == ["--check-thought-format"]) $ do
    let raw = "candidate\t+(x,0)\tx\ncandidate\tgcd(x,y\ty\nfree prose asks for max\n"
        b = parseThoughts raw
        expectedResiduals = ["candidate\tgcd(x,y\ty", "free prose asks for max"]
    unless (thoughtCandidates b == [(F "+" [V 0,F "0" []], V 0)]
            && thoughtResiduals b == expectedResiduals
            && requiredVocabulary b == 7) exitFailure
    putStrLn "THOUGHT-FORMAT CHECKED: candidate object + exact residual demand"
    exitSuccess
  case args of
    ["--kernel-self-test"] -> do
      accepted <- kernelAccept stdout 0 ((bin "+" zero_ x_, x_), "positive control")
      rejected <- kernelAccept stdout 0 ((su x_, x_), "negative control")
      unless (accepted && not rejected) exitFailure
    _ -> do
      exists <- doesFileExist "machine/thoughts.math"
      batch <- if exists then parseThoughts <$> readFile "machine/thoughts.math"
                         else pure (ThoughtBatch [] [])
      runMachine batch

runMachine :: ThoughtBatch -> IO ()
runMachine batch = do
  logh <- openFile "machine/machine.log" AppendMode
  libh <- openFile "machine/library.txt" AppendMode
  hSetBuffering logh LineBuffering
  hSetBuffering libh LineBuffering
  hPutStrLn logh "=== MathMachine start ==="
  hPrintf logh "  THOUGHTS  candidates=%d residuals=%d required-vocab=%d\n"
    (length (thoughtCandidates batch)) (length (thoughtResiduals batch))
    (requiredVocabulary batch)
  forM_ (thoughtResiduals batch) $ \r -> hPrintf logh "  RESIDUAL  %s\n" r
  let seeded = start { mThoughts = thoughtCandidates batch
                     , mResiduals = thoughtResiduals batch
                     , mVocab = requiredVocabulary batch }
  ref <- newIORef seeded
  -- A machine that halts is not a machine.  The old loop stopped when the
  -- size horizon passed its cap, which is to say: it enumerated a finite
  -- space and finished.  Nothing about arithmetic is finite; what was
  -- finite was the vocabulary somebody typed, and the organ for escaping
  -- that — concept invention — was gated on a condition no definition can
  -- satisfy (see `marginalCompress`).  With the gate fixed there is a real
  -- reason to keep going, so it keeps going.
  let loop = round1 logh libh ref >> loop
  loop
  hClose logh
  hClose libh
