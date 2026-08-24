-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- समता-चक्र-निर्णयः — the join test modulo AC closes the rearrangement
-- sector, and the inductive residue is measured instead of guessed.
--
-- WHAT THIS IS.  The artifact `notes/SamataChakra_TheThreeNinetyNineIs
-- AnACCompletionArtifactNotAProofBacklog.md` names as OWED: "the Haskell
-- AC-canon normalizer, wired into Sanghatta['s join test]; the full 399
-- (only 40 are printed) re-run under it; the exact inductive-residue
-- count then measured, not guessed."  This file is that instrument, and
-- nothing else.
--
-- THE MOVE (Peterson–Stickel 1981, stated not invented).  Pull the AC
-- axioms out of the rewrite relation entirely and rewrite MODULO them:
--
--   1. DETECT, from the rule set itself, which symbols carry a
--      commutativity axiom  f(x,y) = f(y,x)  and which carry an
--      associativity axiom  f(f(x,y),z) = f(x,f(y,z))  — matched up to
--      variable renaming, no hand list, so the report cannot claim an
--      AC status the library does not state.
--   2. EXCLUDE from the rewrite rules every rule that is an AC-identity
--      (its two sides have the same AC-canonical form).  As plain
--      rewrite rules those are the disease: an oriented commutativity is
--      a swap rule, so Sanghatta's fuel-bounded `normal` is
--      PARITY-UNSTABLE — the "normal form" of a sum depends on how much
--      fuel is left when the swap fires.  Part of the 399 is that
--      instability, not mathematics.
--   3. JOIN TEST: normalize both closures with the remaining rules,
--      then compare AC-CANONICAL FORMS — flatten nested applications of
--      each associative symbol, sort the arguments of each commutative
--      symbol.  A pair that differs only by rearrangement joins by
--      construction.
--
-- WHAT IS AND IS NOT CLAIMED OF THE RESIDUE.  A pair that still fails
-- this join test is NOT thereby proved inductive: critical pairs are
-- still computed with SYNTACTIC unification (full AC-unification is not
-- done here — Stickel 1981 gives it, and it is a separate instrument),
-- and normalize-then-canon is one pass, not a fixpoint interleaving.
-- So the residue printed below is an UPPER BOUND on the genuinely
-- inductive sector, measured under a stated procedure — against the
-- previous state, where the corresponding figure was "roughly 399" and
-- known to be mostly artifact.  Every pair of the residue is printed,
-- not the smallest 40: a frontier only the head of which is visible
-- recruits work toward its head.
--
-- COMPOUND BUILT HERE (naming rule, CLAUDE.md note 2): समता (equality,
-- the commutative axiom), चक्र (the wheel), निर्णय (the decision) — no
-- source text is claimed for the compound.  The mathematics cited:
-- Knuth–Bendix 1970 (critical pairs); Peterson–Stickel, JACM 28(2),
-- 1981 (rewriting modulo AC); Baader–Nipkow, Term Rewriting and All
-- That, §7 (divergence of plain completion on AC theories).
--
-- RUN:  runghc machine/SamataChakraNirnaya_….hs        (from the repo root)
-- Reads machine/library.terms; writes nothing.  Standalone beside
-- Sanghatta for Sanghatta's own stated reason: an instrument beside the
-- machine, whose output the engine's owner can wire in — or refuse.
-- The parse, rewrite and critical-pair machinery below is Sanghatta's,
-- taken clause for clause, so the two reports differ ONLY in the join
-- test and in how much of the frontier they print.

{-# LANGUAGE LambdaCase #-}
module Main (main) where

import qualified Data.Map.Strict as M
import Data.List (nub, sortOn, sort, isPrefixOf)
import Data.Maybe (mapMaybe, fromMaybe)
import System.IO
import qualified Data.Set as S

-- ------------------------------------------------------------------ terms
data Term = V String | F String [Term] deriving (Eq, Ord, Show)

parseT :: String -> Maybe Term
parseT s = case pTerm (filter (/= ' ') s) of
             Just (t, "") -> Just t
             _            -> Nothing
  where
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
    nameChar c = c `elem` (['a'..'z'] ++ ['A'..'Z'] ++ ['0'..'9'] ++ "-*+'")
    vars = ["x","y","z","u","v","w"
           ,"x'","y'","z'","u'","v'","w'"]

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

freshen :: Term -> (Term, Term) -> (Term, Term)
freshen against (l, r) =
  let taken = S.fromList (varsOf against)
      ren v = if v `S.member` taken then v ++ "'" else v
      go (V v)    = V (ren v)
      go (F f as) = F f (map go as)
  in (go l, go r)

-- --------------------------------------------------------------- rewriting
type Rule = (Term, Term)

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
nonVarPos :: Term -> [([Int], Term)]
nonVarPos t@(F _ as) =
  ([], t) : [ (i : p, u) | (i, a) <- zip [0 ..] as, (p, u) <- nonVarPos a ]
nonVarPos _ = []

replaceAt :: Term -> [Int] -> Term -> Term
replaceAt _ [] u = u
replaceAt (F f as) (i:p) u =
  F f [ if j == i then replaceAt a p u else a | (j, a) <- zip [0 ..] as ]
replaceAt t _ _ = t

criticalPairs :: Rule -> Rule -> [(Term, Term)]
criticalPairs r1@(l1, r1r) r2 =
  [ (apply s r1r, apply s (replaceAt l1 pos re2))
  | let (l2, re2) = freshen l1 r2
  , (pos, sub) <- nonVarPos l1
  , pos /= [] || fst r1 /= l2
  , Just s <- [unify sub l2]
  ]

-- ------------------------------------------- AC detection, from the data
-- alpha-equality: same term up to a variable bijection
alphaEq :: Term -> Term -> Bool
alphaEq a b = go a b M.empty M.empty /= Nothing
  where
    go (V v) (V w) f g =
      case (M.lookup v f, M.lookup w g) of
        (Nothing, Nothing) -> Just (M.insert v w f, M.insert w v g)
        (Just w', Just v') | w' == w && v' == v -> Just (f, g)
        _ -> Nothing
    go (F c as) (F d bs) f g
      | c == d && length as == length bs = goList (zip as bs) f g
      | otherwise = Nothing
    go _ _ _ _ = Nothing
    goList [] f g = Just (f, g)
    goList ((p, q):rest) f g = do (f', g') <- go p q f g
                                  goList rest f' g'

-- the axiom SHAPES, per binary symbol f
commShape, assocShapeL :: String -> (Term, Term)
commShape  f = (F f [V "x", V "y"], F f [V "y", V "x"])
assocShapeL f = (F f [F f [V "x", V "y"], V "z"], F f [V "x", F f [V "y", V "z"]])

hasAxiom :: [(Term, Term)] -> (Term, Term) -> Bool
hasAxiom eqs (sl, sr) =
  any (\(l, r) -> (alphaEq l sl && alphaEq r sr) || (alphaEq l sr && alphaEq r sl))
      (map pairT eqs ++ map (pairT . swap) eqs)
  where pairT = id
        swap (a, b) = (b, a)

binarySymbols :: [(Term, Term)] -> [String]
binarySymbols eqs = nub [ f | (l, r) <- eqs, F f [_, _] <- concatMap subT [l, r] ]
  where subT t@(F _ as) = t : concatMap subT as
        subT t          = [t]

-- ----------------------------------------------------- AC-canonical form
-- flatten each associative symbol's nested applications; sort the
-- argument list of each commutative symbol.  Sorting a flattened list is
-- sound only under BOTH axioms; a commutative-only symbol has exactly
-- its two arguments sorted, which needs no associativity.
acCanon :: S.Set String -> S.Set String -> Term -> Term
acCanon assocS commS = go
  where
    go (V v)    = V v
    go (F f as)
      | f `S.member` assocS =
          let as'  = map go as
              flat = concatMap (peel f) as'
              ord  = if f `S.member` commS then sort flat else flat
          in rebuild f ord
      | f `S.member` commS, [a, b] <- map go as =
          let [a', b'] = sort [a, b] in F f [a', b']
      | otherwise = F f (map go as)
    peel f t@(F g as) | g == f = concatMap (peel f) as
    peel _ t                   = [t]
    rebuild f [t]      = t
    rebuild f (t:ts)   = F f [t, rebuild f ts]   -- right comb, canonical
    rebuild _ []       = error "acCanon: empty flatten (unreachable)"

-- ------------------------------------------------------------------- main
main :: IO ()
main = do
  hSetEncoding stdout utf8
  -- the handle's encoding is set explicitly (Certificate.hs, writeUtf8:
  -- trust nothing ambient); library.terms carries UTF-8 metadata tails
  h <- openFile "machine/library.terms" ReadMode
  hSetEncoding h utf8
  raw <- lines <$> hGetContents h
  let eqs = [ (l, r)
            | ln <- raw
            , not ("#" `isPrefixOf` ln), not (null ln)
            , let (a, rest) = break (== '\t') ln
            , let b = takeWhile (/= '\t') (drop 1 rest)
            , Just l <- [parseT a], Just r <- [parseT b]
            ]
      bins   = binarySymbols eqs
      commS  = S.fromList [ f | f <- bins, hasAxiom eqs (commShape f) ]
      assocS = S.fromList [ f | f <- bins, hasAxiom eqs (assocShapeL f) ]
      canon  = acCanon assocS commS
      -- Sanghatta's orientation, minus the AC-identities (the Peterson–
      -- Stickel move: AC lives in the join test, not the rewrite relation)
      rwAll  = [ (r, l) | (l, r) <- eqs, size r >= size l ]
      rw     = [ ru | ru@(l, r) <- rwAll, canon l /= canon r ]
      pulled = length rwAll - length rw
      cps    = nub [ (a, b)
                   | ru1 <- rw, ru2 <- rw
                   , (a, b) <- criticalPairs ru1 ru2
                   , a /= b ]
      -- the two join tests, side by side over the SAME pair set
      plainNJ = nub [ (na, nb)
                    | (a, b) <- cps
                    , let na = normal rw a, let nb = normal rw b
                    , na /= nb ]
      acNJ    = nub [ (canon na, canon nb)
                    | (na, nb) <- plainNJ
                    , canon na /= canon nb ]
  putStrLn ("rules read                       : " ++ show (length eqs))
  putStrLn ("commutative symbols (from data)  : " ++ show (S.toList commS))
  putStrLn ("associative symbols (from data)  : " ++ show (S.toList assocS))
  putStrLn ("AC-identity rules pulled out     : " ++ show pulled)
  putStrLn ("rewrite rules remaining          : " ++ show (length rw))
  putStrLn ("critical pairs                   : " ++ show (length cps))
  putStrLn ("non-joining, plain test          : " ++ show (length plainNJ))
  putStrLn ("non-joining, MODULO AC           : " ++ show (length acNJ))
  putStrLn ("closed by the AC join test       : " ++ show (length plainNJ - length acNJ))
  putStrLn ""
  putStrLn "-- THE RESIDUE, IN FULL (an upper bound on the inductive sector:"
  putStrLn "-- syntactic CPs, one normalize-then-canon pass; see header) --"
  mapM_ (\(a, b) -> putStrLn (render a ++ "\t" ++ render b))
        (sortOn (\(a, b) -> size a + size b) acNJ)
