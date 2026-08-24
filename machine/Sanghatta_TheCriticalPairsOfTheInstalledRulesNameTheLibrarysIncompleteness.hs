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

-- सङ्घट्टः — collision.  The critical pairs of the installed rules name the
-- library's incompleteness.
--
-- WHAT THIS IS.  MathMachine conjectures ONLY from enumeration: terms up to
-- a size bound, equalities that survive random refutation.  Knuth–Bendix
-- says there is a second source, and it is not optional if confluence is the
-- goal: overlap the installed rules on each other (superposition), normalize
-- both closures, and every pair that fails to join is a theorem the rewriter
-- NEEDS and enumeration has not reached — or a genuine divergence.  This
-- module is that second source, standalone: it reads machine/library.terms,
-- orients each equation left-to-right exactly as stored (the engine already
-- committed to an orientation when it installed), computes all critical
-- pairs, joins what joins, and prints what does not, ranked by size.
--
-- WHY STANDALONE.  MathMachine.hs is another seat's live engine; the norm is
-- message-then-edit for shared instruments.  This reads the same library and
-- writes nothing: an instrument beside the machine, whose output is a
-- conjecture source the engine's owner can wire into the queue with one
-- import — or refuse.  (Wiring offer: the non-joining pairs come out in
-- exactly the `l\tr` shape library.terms uses.)
--
-- WHAT IT IS NOT.  Not a completion loop: no orientation decisions are made
-- here (an unorientable critical pair is REPORTED, not oriented), no rules
-- are installed, nothing recurses.  One pass, one report.
--
-- सङ्घट्ट is built here, 2026-08-23.  Knuth–Bendix 1970 for critical pairs;
-- no novelty claimed for the algorithm, only for the report.

{-# LANGUAGE LambdaCase #-}
-- [2026-08-24, laya] `module Main` renamed to the file's own name so the
-- machine can import this instrument as an organ (the wiring offer in the
-- header, accepted at last — see Laya's `purana`).  `main` is unchanged;
-- run it with -main-is as before.
module Sanghatta_TheCriticalPairsOfTheInstalledRulesNameTheLibrarysIncompleteness
  ( main, Term(..), Rule, parseT, render, size, varsOf, normal, criticalPairs
  ) where

import qualified Data.Map.Strict as M
import Data.List (nub, sortOn, isPrefixOf)
import Data.Maybe (mapMaybe, fromMaybe, catMaybes)
import Data.Char (isAlphaNum)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding)
import qualified Data.Set as S

-- ------------------------------------------------------------------ terms
data Term = V String | F String [Term] deriving (Eq, Ord, Show)

-- the engine's own surface syntax: f(a,b), s(x), 0, variables x y z u v w
parseT :: String -> Maybe Term
parseT s = case pTerm (filter (/= ' ') s) of
             Just (t, "") -> Just t
             _            -> Nothing
  where
    pTerm :: String -> Maybe (Term, String)
    pTerm cs = do
      (nm, rest) <- pName cs
      case rest of
        '(':rest' -> do (args, rest'') <- pArgs rest' []
                        pure (F nm args, rest'')
        _ | nm `elem` vars -> pure (V nm, rest)
          | otherwise      -> pure (F nm [], rest)
    pArgs cs acc = do
      (t, rest) <- pTerm cs
      case rest of
        ',':rest' -> pArgs rest' (acc ++ [t])
        ')':rest' -> pure (acc ++ [t], rest')
        _         -> Nothing
    pName cs = case span nameChar cs of
                 ("", _)    -> Nothing
                 (nm, rest) -> Just (nm, rest)
    nameChar c = isAlphaNum c || c `elem` "-*+"   -- ops are names: +,*,max,-,gcd,le,s,0
    vars = ["x","y","z","u","v","w"]

render :: Term -> String
render (V v)     = v
render (F f [])  = f
render (F f as)  = f ++ "(" ++ intercalate "," (map render as) ++ ")"
  where intercalate sep = foldr1 (\a b -> a ++ sep ++ b)

size :: Term -> Int
size (V _)    = 1
size (F _ as) = 1 + sum (map size as)

varsOf :: Term -> [String]
varsOf (V v)    = [v]
varsOf (F _ as) = nub (concatMap varsOf as)

-- ------------------------------------------------------- substitution, mgu
type Sub = M.Map String Term

apply :: Sub -> Term -> Term
apply s (V v)    = fromMaybe (V v) (M.lookup v s)
apply s (F f as) = F f (map (apply s) as)

occurs :: String -> Term -> Bool
occurs v t = v `elem` varsOf t

unify :: Term -> Term -> Maybe Sub
unify a b = go [(a, b)] M.empty
  where
    go [] s = Just s
    go ((V v, t):rest) s
      | V v == t         = go rest s
      | occurs v t       = Nothing
      | otherwise        = let s1 = M.insert v t (M.map (apply (M.singleton v t)) s)
                           in go [ (apply s1 l, apply s1 r) | (l, r) <- rest ] s1
    go ((t, V v):rest) s = go ((V v, t):rest) s
    go ((F f as, F g bs):rest) s
      | f == g && length as == length bs = go (zip as bs ++ rest) s
      | otherwise = Nothing

-- rename rule 2's variables apart from rule 1's
freshen :: Term -> (Term, Term) -> (Term, Term)
freshen against (l, r) =
  let taken = S.fromList (varsOf against)
      ren v = if v `S.member` taken then v ++ "'" else v
      go (V v)    = V (ren v)
      go (F f as) = F f (map go as)
  in (go l, go r)

-- --------------------------------------------------------------- rewriting
type Rule = (Term, Term)

-- match l against t (l's vars bind); one leftmost-outermost step
matchT :: Term -> Term -> Maybe Sub
matchT l t = go l t M.empty
  where
    go (V v) u s = case M.lookup v s of
                     Nothing -> Just (M.insert v u s)
                     Just u' | u == u'   -> Just s
                             | otherwise -> Nothing
    go (F f as) (F g bs) s
      | f == g && length as == length bs = goList (zip as bs) s
      | otherwise = Nothing
    go _ _ _ = Nothing
    goList [] s = Just s
    goList ((a, b):rest) s = go a b s >>= goList rest

step :: [Rule] -> Term -> Maybe Term
step rules t =
  case mapMaybe (\(l, r) -> (\s -> apply s r) <$> matchT l t) rules of
    (t':_) -> Just t'
    [] -> case t of
            F f as -> F f <$> stepFirst as
            _      -> Nothing
  where
    stepFirst [] = Nothing
    stepFirst (a:as) = case step rules a of
                         Just a' -> Just (a' : as)
                         Nothing -> (a :) <$> stepFirst as

normal :: [Rule] -> Term -> Term
normal rules = go (400 :: Int)
  where go 0 t = t
        go k t = maybe t (go (k - 1)) (step rules t)

-- ---------------------------------------------------------- critical pairs
-- positions of non-variable subterms
nonVarPos :: Term -> [([Int], Term)]
nonVarPos t@(F _ as) =
  ([], t) : [ (i : p, u) | (i, a) <- zip [0 ..] as, (p, u) <- nonVarPos a ]
nonVarPos _ = []

replaceAt :: Term -> [Int] -> Term -> Term
replaceAt _ [] u = u
replaceAt (F f as) (i:p) u =
  F f [ if j == i then replaceAt a p u else a | (j, a) <- zip [0 ..] as ]
replaceAt t _ _ = t

-- overlap rule2 into a non-variable position of rule1's lhs
criticalPairs :: Rule -> Rule -> [(Term, Term)]
criticalPairs r1@(l1, r1r) r2 =
  [ (apply s r1r, apply s (replaceAt l1 pos re2))
  | let (l2, re2) = freshen l1 r2
  , (pos, sub) <- nonVarPos l1
  , pos /= [] || fst r1 /= l2          -- skip the trivial self-root overlap
  , Just s <- [unify sub l2]
  ]

-- ------------------------------------------------------------------- main
main :: IO ()
main = do
  -- 2026-08-24: reads of this corpus are UTF-8 (Devanagari identifiers);
  -- without this, readFile throws under a POSIX locale mid-run.
  setLocaleEncoding utf8
  hSetEncoding stdout utf8
  raw <- lines <$> readFile "machine/library.terms"
  let rules = [ (l, r)
              | ln <- raw
              , not ("#" `isPrefixOf` ln), not (null ln)
              , let (a, rest) = break (== '\t') ln
              , let b = takeWhile (/= '\t') (drop 1 rest)
              , Just l <- [parseT a], Just r <- [parseT b]
              ]
      -- orient as stored, but rewrite with the SMALLER side as target:
      -- library stores `small \t large`? Inspect: rows look like
      -- `x  +(x,0)` i.e. lhs is the NORMAL form.  So the rewrite rule is
      -- large -> small: (r, l).
      rw    = [ (r, l) | (l, r) <- rules, size r >= size l ]
      cps   = nub [ (a, b)
                  | ru1 <- rw, ru2 <- rw
                  , (a, b) <- criticalPairs ru1 ru2
                  , a /= b ]
      nonj  = nub [ (na, nb)
                  | (a, b) <- cps
                  , let na = normal rw a, let nb = normal rw b
                  , na /= nb ]
  putStrLn ("rules read              : " ++ show (length rules))
  putStrLn ("oriented for rewriting  : " ++ show (length rw))
  putStrLn ("critical pairs          : " ++ show (length cps))
  putStrLn ("NON-JOINING (the gap)   : " ++ show (length nonj))
  putStrLn ""
  putStrLn "-- non-joining pairs, smallest first, in library.terms shape --"
  mapM_ (\(a, b) -> putStrLn (render a ++ "\t" ++ render b))
        (take 40 (sortOn (\(a, b) -> size a + size b) nonj))
