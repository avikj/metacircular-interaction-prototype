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

-- BhavanaTheorem — Brahmagupta's rule applied to theorems instead of to
-- solutions.  Generation without search.
--
-- BRAHMAGUPTA, Brahmasphutasiddhanta 18, 628 CE.  The rule is called
-- *bhavana*, "production": from two solutions of x^2 - D y^2 = k you COMPUTE a
-- third, and the norms multiply.  There is no candidate set, nothing is
-- tested, and nothing can come out false, because the operation preserves the
-- invariant by algebra.
--
-- WHY THIS FILE.  `MathMachine`'s candidates come from four places:
-- fingerprint classes over an enumerated term space, the thought file,
-- harvested residuals, and (since today) arohana.  NOT ONE OF THEM COMPOSES
-- TWO OF THE MACHINE'S OWN THEOREMS.  `lemmaRules` installs every proved
-- equation into the rewriter so it can CHECK with them; nothing ever puts two
-- of them together to make a third.
--
-- That is the half of bhavana the corpus still lacks, in the place it matters
-- most.  `formal/cubical/BhavanaGenerative.agda` supplied it for the Pell
-- form; `machine/Nalanda.hs` turns it and produces Bhaskara's numbers without
-- searching for them.  This is the same move for the machine's own domain.
--
-- WHAT ENUMERATION COSTS, from this machine's own record.  It generated 25276
-- terms at size 6 and 53082 at size 7, normalised them, took fingerprints,
-- and produced 1876 conjectures of which the round proved 0.  Every filter it
-- then needs -- the semantic firewall, the value gate, the failure memo --
-- exists to cope with candidates that MIGHT be false.  Today's whole
-- investigation was those filters misfiring on a residual, and the deepest one
-- was the value gate answering in the rewriter's currency a question the
-- kernel had asked.
--
-- A composed theorem needs none of that machinery, because it cannot be false.
-- If L1 and L2 hold then so does their composition, by the same argument that
-- makes the norms multiply.  The firewall becomes a check on THIS FILE'S
-- IMPLEMENTATION, not on the mathematics -- and that is exactly how `selfTest`
-- uses it below.
--
-- THE OPERATION.  Given L1 : l1 = r1 and L2 : l2 = r2, rename apart, and
-- wherever l2 matches a subterm of r1 under a substitution s, replace it:
--
--     l1 = r1[p := s(r2)]        is a theorem
--
-- and symmetrically into l1, and with the roles of L1 and L2 exchanged.  This
-- is *samasa-bhavana* read one level up: two established facts put together
-- give a third, and no third thing is consulted.
--
-- WHAT IS NOT CLAIMED.  That every consequence is reachable this way (it is
-- not: this is one step of superposition, not a completion procedure).  That
-- the output is INTERESTING -- most compositions are dull, and choosing among
-- them is a separate problem this file does not touch.  Only that every output
-- is TRUE given its inputs, and that producing it required no search.

module BhavanaTheorem
  ( Term(..)
  , Subst
  , match
  , applySubst
  , positions
  , replaceAt
  , composePair
  , bhavana
  , renameApart
  , semanticsAgree
  , parseLibraryPublic
  , definingEquations
  , praksepa
  , istaPool
  , selfTest
  ) where

import Data.List (nub, foldl')
import Data.Maybe (mapMaybe)
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import System.IO (openFile, hSetEncoding, hGetContents, utf8, IOMode(ReadMode))

-- Structurally identical to MathMachine.Term and Obstruction.Term.  The
-- duplication is a real defect of this codebase -- there is no shared core --
-- but introducing one is a separate change and this file stays importable and
-- dependency-free, which `Certify.hs` and three siblings failed to do by
-- being `module Main`.
data Term = V !Int | F !String [Term] deriving (Eq, Ord)

instance Show Term where
  show (V i) | i < 6 = [ "xyzuvw" !! i ]
             | otherwise = "n" ++ show i
  show (F f []) = f
  show (F f ts) = f ++ "(" ++ intercalate' "," (map show ts) ++ ")"

intercalate' :: String -> [String] -> String
intercalate' _ [] = ""
intercalate' _ [x] = x
intercalate' sep (x:xs) = x ++ sep ++ intercalate' sep xs

type Subst = M.Map Int Term

-- ------------------------------------------------------------- matching

-- One-way matching: does `pat` match `t`, and with what binding?  One-way,
-- not unification, because a theorem is applied to a term and not solved
-- against it.
match :: Term -> Term -> Maybe Subst
match = go M.empty
  where
    go s (V i) t = case M.lookup i s of
      Nothing -> Just (M.insert i t s)
      Just u  -> if u == t then Just s else Nothing
    go s (F f ps) (F g ts)
      | f == g, length ps == length ts = foldM' s (zip ps ts)
    go _ _ _ = Nothing
    foldM' s [] = Just s
    foldM' s ((p, t) : rest) = go s p t >>= \s' -> foldM' s' rest

applySubst :: Subst -> Term -> Term
applySubst s (V i) = M.findWithDefault (V i) i s
applySubst s (F f ts) = F f (map (applySubst s) ts)

-- every position, as a path, with the subterm standing there
positions :: Term -> [([Int], Term)]
positions t = ([], t) : case t of
  F _ ts -> [ (i : p, u) | (i, c) <- zip [0 ..] ts, (p, u) <- positions c ]
  _ -> []

replaceAt :: [Int] -> Term -> Term -> Term
replaceAt [] new _ = new
replaceAt (i : p) new (F f ts) =
  F f [ if j == i then replaceAt p new c else c | (j, c) <- zip [0 ..] ts ]
replaceAt _ _ t = t

-- Variables of the two theorems must not collide; the second is shifted past
-- the first.  Skipping this is the classic way to derive a false "theorem"
-- from two true ones, so it is done before every composition rather than
-- assumed.
renameApart :: Int -> (Term, Term) -> (Term, Term)
renameApart k (l, r) = (shift l, shift r)
  where
    shift (V i) = V (i + k)
    shift (F f ts) = F f (map shift ts)

maxVar :: Term -> Int
maxVar (V i) = i
maxVar (F _ ts) = foldl' max (-1) (map maxVar ts)

-- ---------------------------------------------------------- composition

-- Rewrite one occurrence in `t` by the equation `l = r`, at each position
-- where it applies.  Every result is equal to `t`.
rewritesOf :: (Term, Term) -> Term -> [Term]
rewritesOf (l, r) t =
  [ replaceAt p (applySubst s r) t
  | (p, u) <- positions t
  , Just s <- [match l u] ]

-- SAMASA-BHAVANA at the level of theorems.  L1 and L2 in, their compositions
-- out.  Each output is a consequence of the two inputs; nothing else is
-- consulted and nothing is tested.
composePair :: (Term, Term) -> (Term, Term) -> [(Term, Term)]
composePair e1@(l1, r1) e2raw =
    [ (l1, r') | r' <- rewritesOf e2 r1, r' /= r1 ]
 ++ [ (l', r1) | l' <- rewritesOf e2 l1, l' /= l1 ]
 ++ [ (l1, r') | r' <- rewritesOf (swap e2) r1, r' /= r1 ]
 ++ [ (l', r1) | l' <- rewritesOf (swap e2) l1, l' /= l1 ]
  where
    e2 = renameApart (1 + max (maxVar l1) (maxVar r1)) e2raw
    swap (a, b) = (b, a)
    _ = e1

-- Every pairwise composition of a set of theorems, minus what was already
-- there and minus trivialities.  ONE step: this is a production rule, not a
-- completion procedure, and calling it repeatedly is the caller's decision
-- because the output grows fast and choosing among it is a separate problem.
bhavana :: [(Term, Term)] -> [(Term, Term)]
bhavana thms =
  S.toList (S.fromList
      [ c
      | e1 <- thms, e2 <- thms
      , c@(a, b) <- composePair e1 e2
      , a /= b
      , c `notElem` thms
      , (b, a) `notElem` thms ])

-- ------------------------------------------------------------ the check
--
-- Composition cannot produce a falsehood from truths.  So if an output ever
-- disagrees with the vocabulary's semantics, the defect is in THIS FILE, and
-- that is what the firewall is used for here -- not to judge the mathematics,
-- which needs no judging, but to test the implementation.

sem :: String -> [Integer] -> Integer
sem "0" _ = 0
sem "s" [a] = a + 1
sem "+" [a,b] = a + b
sem "*" [a,b] = a * b
sem "max" [a,b] = max a b
sem "-" [a,b] = max 0 (a - b)
sem "le" [a,b] = if a <= b then 1 else 0
sem "gcd" [a,b] = gcd a b
sem f as = error ("BhavanaTheorem.sem: unknown " ++ f ++ "/" ++ show (length as))

evalT :: [Integer] -> Term -> Integer
evalT env (V i) = if i < length env then env !! i else 0
evalT env (F f ts) = sem f (map (evalT env) ts)

envs :: [[Integer]]
envs = [ [a, b, c, d] | a <- [0 .. 4], b <- [0 .. 4], c <- [0 .. 3], d <- [0 .. 2] ]

semanticsAgree :: (Term, Term) -> Bool
semanticsAgree (l, r) = all (\e -> evalT e l == evalT e r) envs

-- ----------------------------------------------------------- selftest

-- Read the machine's own library, in its own notation, and compose it.
parseLibrary :: String -> [(Term, Term)]
parseLibrary s = mapMaybe line (lines s)
  where
    line ln = case break (== '\t') ln of
      (a, '\t' : b) -> (,) <$> parseT a <*> parseT b
      _ -> Nothing

-- prefix notation: f(a,b), 0, x..w
parseT :: String -> Maybe Term
parseT str = case p str of
  Just (t, "") -> Just t
  _ -> Nothing
  where
    p ('x':rest) = Just (V 0, rest)
    p ('y':rest) = Just (V 1, rest)
    p ('z':rest) = Just (V 2, rest)
    p ('u':rest) = Just (V 3, rest)
    p ('v':rest) = Just (V 4, rest)
    p ('w':rest) = Just (V 5, rest)
    p s0 = case span (`notElem` "(),") s0 of
      ("", _) -> Nothing
      (nm, '(' : rest) -> args rest >>= \(as, rest') -> Just (F nm as, rest')
      (nm, rest) -> Just (F nm [], rest)
    args s0 = do
      (a, r) <- p s0
      case r of
        ')' : r' -> Just ([a], r')
        ',' : r' -> args r' >>= \(as, r'') -> Just (a : as, r'')
        _ -> Nothing

selfTest :: IO Bool
selfTest = do
    h <- openFile "machine/library.terms" ReadMode
    hSetEncoding h utf8
    txt <- hGetContents h
    let thms = nub (parseLibrary txt)
        produced = bhavana thms
        wrong = [ c | c <- produced, not (semanticsAgree c) ]
        inputsOk = [ c | c <- thms, not (semanticsAgree c) ]
    putStrLn ("  theorems read from library.terms:  " ++ show (length thms))
    putStrLn ("  inputs that fail the semantics:    " ++ show (length inputsOk)
              ++ "   (must be 0, else the LIBRARY is wrong, not this file)")
    putStrLn ("  NEW theorems produced by one bhavana step: " ++ show (length produced))
    putStrLn ("  of those, semantically false:      " ++ show (length wrong)
              ++ "   (must be 0: composition cannot make a truth false)")
    putStrLn "  -- the first eight produced --"
    mapM_ (\(a, b) -> putStrLn ("     " ++ show a ++ " = " ++ show b))
          (take 8 produced)
    let ok = null wrong && null inputsOk && not (null produced)
    putStrLn ("  bhavana produces, and produces only truths: " ++ show ok)
    pure ok

-- exported so a caller can compose the machine's own library without
-- re-implementing its notation
parseLibraryPublic :: String -> [(Term, Term)]
parseLibraryPublic = parseLibrary

-- THE AXIOMS WERE NOT IN THE THEOREM SET, and that was the whole answer to
-- the first experiment.
--
-- Composing only `library.terms` produced 1638 truths and hit just 2 of the
-- 116 lemmas the kernel demands.  The misses -- *(x,0) = 0, -(0,x) = 0,
-- x = max(0,x), le(*(x,0),0) = s(0) -- are the machine's own DEFINING
-- EQUATIONS in the mirrored orientation.  They are never theorems, so they are
-- never in library.terms, so composition over library.terms alone cannot
-- reach them however long it runs.
--
-- Brahmagupta's cycle does not have this problem, and the reason is instructive:
-- it seeds with the TRIVIAL triple (m, 1, m^2 - D) -- an axiom, composed in
-- alongside the solutions.  Composition needs the axioms in the pot.
--
-- Transcribed from MathMachine's `vocabulary` symDefs (MathMachine.hs:714ff),
-- in that order.
definingEquations :: [(Term, Term)]
definingEquations =
  [ (f "+" [x, z],        x)
  , (f "+" [x, s y],      s (f "+" [x, y]))
  , (f "*" [x, z],        z)
  , (f "*" [x, s y],      f "+" [f "*" [x, y], x])
  , (f "max" [x, z],      x)
  , (f "max" [z, x],      x)
  , (f "max" [s x, s y],  s (f "max" [x, y]))
  , (f "-" [x, z],        x)
  , (f "-" [z, x],        z)
  , (f "-" [s x, s y],    f "-" [x, y])
  ]
  where
    f = F
    x = V 0 ; y = V 1
    z = F "0" []
    s t = F "s" [t]

-- प्रक्षेप / इष्ट — INSTANTIATION AT A CHOSEN VALUE.
--
-- Composition alone missed `*(*(x,x),0) = 0`, which is not a composition of
-- two facts at all: it is a bare INSTANCE of the axiom `*(x,0) = 0` at
-- x := x*x.  Superposition rewrites one equation by another and never
-- produces an instance of a single one, so a whole class of demanded lemmas
-- was structurally unreachable.
--
-- The sources have the move and this repository already names it.  Brahmagupta
-- composes with the TRIVIAL triple (m, 1, m^2 - D) for arbitrary m, and
-- `Kuttaka.inhomogeneous` is documented in this corpus as "the ISTA-scaled
-- family: a solution of ax + by = g*k for any k".  Ista is the chosen value.
-- Generation needs both: put two facts together, and instantiate one fact at a
-- value you choose.
--
-- The pool is the corpus's own small subterms rather than an enumerated term
-- space -- the point of this file is to not enumerate, and a chosen value
-- taken from what is already in play is a choice, while all terms of size <= n
-- is a search.
istaPool :: [(Term, Term)] -> [Term]
istaPool eqs =
  nub [ u | (l, r) <- eqs, t <- [l, r], (_, u) <- positions t
          , tsize u <= 3, not (isVar u) ]
  where
    isVar (V _) = True
    isVar _ = False

tsize :: Term -> Int
tsize (V _) = 1
tsize (F _ ts) = 1 + sum (map tsize ts)

praksepa :: [Term] -> [(Term, Term)] -> [(Term, Term)]
praksepa pool eqs =
  -- Set, not nub: instantiating 3000 composites at 40 chosen values is ~360k
  -- results and `nub` is quadratic, which killed a 1800s run.  The cost was
  -- the dedup, not the mathematics.
  S.toList (S.fromList
      [ (applySubst s l, applySubst s r)
      | (l, r) <- eqs
      , v <- nub (varsOf l ++ varsOf r)
      , t <- pool
      , let s = M.singleton v t
      , applySubst s l /= applySubst s r ])
  where
    varsOf (V i) = [i]
    varsOf (F _ ts) = concatMap varsOf ts
