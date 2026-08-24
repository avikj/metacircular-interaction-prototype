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

-- HeadDepthVocab — the corpus head-depth carrier e_b(q) and Thm W3, expressed
-- as MathMachine vocabulary + a single installed rewrite rule, in the machine's
-- OWN term language.
--
-- WHAT THIS IS.  formal/cubical/HeadDepthMerge.agda certifies (exhaustively,
-- as a checked term over the 1048-triple range) the threshold law
--
--     Thm W3:   b is Fermat-blind on q^a   ⟺   a ≤ e_b(q),
--     with      e_b(q) = v_q(b^{ord_q(b)} − 1)    (a-INDEPENDENT).
--
-- The a-independence is the whole content: a family of A blindness queries at
-- one (q,b) — A separate modular exponentiations — is decided by ONE head
-- depth e_b(q) and A cheap comparisons.  This module makes that fact an
-- INSTALLED REWRITE inside the machine, not a fact stated about the machine
-- from outside:
--
--     fb(q,a,b)   →   le(a, eb(q,b))                 (w3Rule)
--
-- `fb` is the blindness query; `eb` is the head-depth carrier; `le` is the
-- machine's own comparison symbol (MathMachine.vocabulary).  Once w3Rule is in
-- the rule set, the machine's `normalize` collapses every query at a given
-- (q,b) onto the SAME irreducible head-depth core `eb(q,b)`: the a-dimension
-- moves into a cheap `le(a, ·)` wrapper that carries no modular exponentiation.
--
-- HONEST STATUS of `eb`.  `eb` is left computationally-visible-but-not-rewritten
-- — exactly the boundary MathMachine documents for `gcd` (its recursive
-- Euclidean step cannot yet be expressed as a sound oriented rule, so `gcd`
-- computes but does not unfold).  `eb`'s value is number theory, computed here
-- by EXACT integer arithmetic (headDepth below), mirroring HeadDepthMerge.agda's
-- `headDepth`.  The rewrite is what is installed; the value is input mathematics.
--
-- The rewrite machinery (Term, match, applySub, cmpTerm, lpo, decreases, step,
-- normalize) is transcribed faithfully from machine/MathMachine.hs so that
-- "the machine's normalize" is literally what runs here.  MathMachine is
-- `module Main`, so it cannot be imported; this transcription is the seam.

module HeadDepthVocab
  ( Term(..), Rule
  , nat, konst, showTermP
  , normalize, normalizeSteps
  , w3Rule, leDefs, fbQuery
  , coresHeadedBy
  , ordMod, headDepth, fermatBlind, aLeE
  , oddPrimes, certifiedTriples, certifiedPairs
  ) where

import qualified Data.Map.Strict as M
import Data.List (intercalate)

-- ---------------------------------------------------------------- terms
-- (verbatim from MathMachine.hs)

data Term = V !Int | F !String [Term] deriving (Eq, Ord)

instance Show Term where
  show (V i) | i < 6 = [ "xyzuvw" !! i ]
             | otherwise = "n" ++ show i
  show (F f []) = f
  show (F f [a,b])
    | f `elem` ["+","*","^","gcd","max","le"] = "(" ++ show a ++ f ++ show b ++ ")"
  show (F f as) = f ++ "(" ++ intercalate "," (map show as) ++ ")"

type Rule = (Term, Term)

-- machine-readable rendering (MathMachine.showTermP), for library.terms format
showTermP :: Term -> String
showTermP (V i)
  | i >= 0 && i < 6 = ["xyzuvw" !! i]
  | otherwise       = "v" ++ show i
showTermP (F n [])  = n
showTermP (F n ts)  = n ++ "(" ++ intercalate "," (map showTermP ts) ++ ")"

size :: Term -> Int
size (V _) = 1
size (F _ ts) = 1 + sum (map size ts)

vars :: Term -> [Int]
vars (V i) = [i]
vars (F _ ts) = concatMap vars ts

-- ---------------------------------------------------------- rewriting
-- (verbatim from MathMachine.hs: match, applySub, step, cmpTerm, decreases,
--  lpo, normalize.  `precedence` is specialised to this module's symbol set,
--  keeping the machine's discipline "a symbol defined later outranks the ones
--  it is defined from": 0 < s < le < eb < fb.)

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
precedence f = case f of
  "0"      -> 0
  "s"      -> 1
  "le"     -> 2
  "eb"     -> 3
  "fb"     -> 4
  _        -> -1

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

-- same normal form, but also reports the number of rewrite steps taken
-- (the proof-step count the task asks the benchmark to compare)
normalizeSteps :: [Rule] -> Term -> (Term, Int)
normalizeSteps rs = go (200 :: Int) 0
  where
    go 0 n t = (t, n)
    go k n t = case step rs t of
                 Nothing -> (t, n)
                 Just t' -> go (k-1) (n+1) t'

-- ---------------------------------------------- vocabulary and the W3 rule

-- Peano numeral (the machine's native small numbers).  Retained for reference;
-- NOT used to carry the query parameters — see `konst` and the LPO note below.
nat :: Integer -> Term
nat n | n <= 0    = F "0" []
      | otherwise = F "s" [nat (n-1)]

-- A query parameter enters as a nullary CONSTANT symbol, the same shape the
-- machine's term language already uses for "0" and the eigenconstant "#".
--
-- WHY NOT PEANO NUMERALS.  MathMachine's LPO (`lpo` above, transcribed
-- verbatim) is worst-case exponential on deep unary successor stacks — the
-- `any (lpo si t)` / `all (lpo s) ts` recursion branches at every `s`.  The
-- corpus machine never triggers this because its size horizon is ≤ 7, so it
-- never builds a numeral anywhere near q=23 or b=68.  A blindness query,
-- though, carries genuine two-digit indices; representing them as `nat 68`
-- would make `decreases` (hence `normalize`) exponential in the index — an
-- artefact of the reduction order, nothing mathematical.  Distinct nullary
-- constants keep every query term size 4, so `lpo` is O(size) and the
-- head-depth cores stay exactly as distinguishable (kⁿ ≠ kᵐ for n ≠ m).
konst :: Integer -> Term
konst v = F ("k" ++ show v) []

-- the blindness query fb(q,a,b) as a machine term
fbQuery :: Integer -> Integer -> Integer -> Term
fbQuery q a b = F "fb" [konst q, konst a, konst b]

-- THE INSTALLED REWRITE.  Thm W3 in the machine's term language:
--   fb(q,a,b)  →  le(a, eb(q,b))
-- fb is highest precedence, so LPO orients it (fb-headed ⊐ le-headed, and the
-- RHS's proper subterms a, eb(q,b) are all built from LHS variables); `step`
-- therefore fires it and the rewrite terminates.
w3Rule :: Rule
w3Rule = ( F "fb" [V 0, V 1, V 2]
         , F "le" [V 1, F "eb" [V 0, V 2]] )

-- the machine's own `le` defining equations (MathMachine.vocabulary), included
-- so the a ≤ e_b comparison is the genuinely REDUCIBLE part of the residual.
-- They do not fire on le(a, eb(q,b)) because eb(q,b) is not a numeral — the
-- head-depth core is preserved, which is exactly the point being measured.
leDefs :: [Rule]
leDefs =
  [ (F "le" [F "0" [], V 0],                     F "s" [F "0" []])
  , (F "le" [F "s" [V 0], F "0" []],             F "0" [])
  , (F "le" [F "s" [V 0], F "s" [V 1]],          F "le" [V 0, V 1]) ]

-- maximal subterms headed by a given symbol (the "cost cores")
coresHeadedBy :: String -> Term -> [Term]
coresHeadedBy h t = go t
  where
    go u@(F f ts) | f == h    = [u]
                  | otherwise = concatMap go ts
    go _ = []

-- ------------------------------------------------ exact number theory
-- (mirrors HeadDepthMerge.agda: powMod / ord / vCap / headDepth / fermatBlind.
--  Arbitrary-precision Integer; every count is exact.)

modPow :: Integer -> Integer -> Integer -> Integer
modPow _ 0 m = 1 `mod` m
modPow b e m =
  let h = modPow ((b*b) `mod` m) (e `div` 2) m
  in if odd e then (b*h) `mod` m else h

-- TOTALITY GUARDS ADDED 2026-08-19.  These three functions were written for
-- the certified range below (q an odd prime ≤ 23, 2 ≤ b < 3q with q ∤ b,
-- 1 ≤ a ≤ 4) and are correct on it.  Off it, two of them DID NOT TERMINATE:
--
--   ordMod q b  with q | b:  the running power is 0 for ever and never 1.
--   vq q 0:                  0 is divisible by q, for ever.
--
-- That was found by feeding them from machine/Upamana.hs, whose adjudicator
-- evaluates transported statements over a box of small integers and has no
-- way to know which of them are legal arguments here.  A non-terminating
-- function is worse than a wrong one: it reports nothing at all, and the
-- caller cannot tell it apart from a slow one.  So each is total now, and
-- returns 0 exactly where the quantity is undefined.  Behaviour ON the
-- certified range is unchanged -- `selfTest` covers it.

-- multiplicative order of b modulo prime q (b not divisible by q); 0 when
-- that condition fails, since there is then no such order
ordMod :: Integer -> Integer -> Integer
ordMod q b
  | q <= 1            = 0
  | b `mod` q == 0    = 0
  | otherwise         = go 1 (b `mod` q)
  where go k acc | acc == 1  = k
                 | otherwise = go (k+1) ((acc*b) `mod` q)

-- q-adic valuation of a positive integer; 0 at 0 and below, where it is not
-- defined (v_q(0) is conventionally infinite, and this returns a number)
vq :: Integer -> Integer -> Integer
vq q n | q <= 1         = 0
       | n <= 0         = 0
       | n `mod` q /= 0 = 0
       | otherwise      = 1 + vq q (n `div` q)

-- e_b(q) = v_q(b^{ord_q(b)} − 1)
headDepth :: Integer -> Integer -> Integer
headDepth q b
  | q <= 1         = 0
  | b `mod` q == 0 = 0
  | otherwise      = vq q (b ^ ordMod q b - 1)

-- b is Fermat-blind on n = q^a  :  b^{n−1} ≡ 1 (mod n)
fermatBlind :: Integer -> Integer -> Integer -> Bool
fermatBlind q a b = let n = q ^ a in modPow b (n-1) n == 1

-- the threshold reading a ≤ e_b(q)
aLeE :: Integer -> Integer -> Integer -> Bool
aLeE q a b = a <= headDepth q b

-- ------------------------------------------------ the certified range
-- q ≤ 23 odd prime, 2 ≤ b < 3q with q ∤ b, 1 ≤ a ≤ 4 — HeadDepthMerge's exact
-- 1048 triples (= overTriples' range).

oddPrimes :: [Integer]
oddPrimes = [3,5,7,11,13,17,19,23]

certifiedTriples :: [(Integer,Integer,Integer)]
certifiedTriples =
  [ (q,a,b)
  | q <- oddPrimes
  , b <- [2 .. 3*q - 1]
  , b `mod` q /= 0
  , a <- [1..4] ]

certifiedPairs :: [(Integer,Integer)]
certifiedPairs =
  [ (q,b)
  | q <- oddPrimes
  , b <- [2 .. 3*q - 1]
  , b `mod` q /= 0 ]
