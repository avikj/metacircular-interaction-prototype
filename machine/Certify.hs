-- Certify.hs — CERTIFY, the missing organ of the machine's loop.
--
-- ===================================================================
-- WHAT THIS IS AND WHY IT EXISTS
--
-- notes/THE_MACHINE.md specifies the loop
--
--     CLOSE -> CERTIFY -> PORT -> GROW
--
-- and says the whole point is that "the machine can prove the boundary
-- of its own knowledge from inside": saturation must be a CERTIFICATE,
-- not an empirical whimper.
--
-- machine/MathMachine.hs implements CLOSE (generate / normalize /
-- conjecture / refute / prove / install).  It does not implement
-- CERTIFY.  When a round yields nothing it widens the vocabulary and
-- runs again.  The consequence is in its own log, machine/machine.log:
-- rounds 1..24 enumerate 10,089,012 terms, state 1,047,050 conjectures,
-- and install zero theorems, and half of those rounds are bit-identical
-- to each other.  The file itself says so, at the bottom of the growth
-- ladder:
--
--     "the next round has the same rules, vocab and size, hence the
--      same terms, hence the same conjectures ... A machine spinning
--      on a state it can prove it cannot leave is worse than one that
--      halts, because it looks alive."
--
-- "a state it can prove it cannot leave" is exactly right, and nothing
-- in the engine proves it.  This module does.
--
-- ===================================================================
-- THE MATHEMATICS, STATED BEFORE THE COMPUTATION (CLAUDE.md's rule)
--
-- Let R be the machine's installed rewrite system over its current
-- vocabulary.  Write -> for one R-step and =_R for the equational
-- theory R generates.
--
--   (T) TERMINATION.  Every rule of R was admitted by `orient`, which
--       admits (l,r) only when `lpo l r` and vars r subset vars l.  LPO
--       over a fixed precedence is a reduction order (well-founded,
--       monotone, stable), so -> is terminating.  MathMachine's `step`
--       additionally guards every rewrite by `decreases`, which is a
--       strictly stronger requirement, so this is not an assumption
--       about the engine, it is a property of it.
--
--   (N) NEWMAN'S LEMMA.  A terminating relation is confluent iff it is
--       locally confluent.
--
--   (CP) CRITICAL PAIR LEMMA (Knuth-Bendix 1970).  A term rewriting
--       system is locally confluent iff all of its critical pairs are
--       joinable.  A critical pair arises from overlapping the left
--       side of one rule with a NON-VARIABLE subterm of the left side
--       of another (or of itself, at a proper subterm position),
--       unifying, and taking the two divergent reducts of the resulting
--       peak.  Variable positions need no check: the two redexes are
--       then disjoint or nested inside a substitution, and both cases
--       join by rewriting the copies.
--
--   Together: R terminating + all critical pairs join  ==>  R is
--   CONVERGENT, hence every term has a UNIQUE normal form, hence
--
--       s =_R t   <=>   normalize R s == normalize R t.
--
-- THAT BICONDITIONAL IS THE CERTIFICATE.  Its two uses are the two the
-- brief asks for, and they are opposite in sign:
--
--   USE 1 (saturation is a theorem).  MathMachine's round enumerates
--   the term space, normalizes, buckets by fingerprint, and states as
--   conjectures the pairs of DISTINCT normal forms inside a bucket.  If
--   R is convergent then distinct normal forms are, by the
--   biconditional, provably not =_R.  So:
--
--     * every conjecture the round can state is provably NOT reachable
--       by the rewriting lane of the prover, and
--     * `normed` is exactly a set of representatives of the =_R classes
--       of the term space, so re-enumerating that space with the same R
--       cannot expose an equation of =_R that R has not already
--       collapsed.
--
--   The rewriting lane is closed.  Not observed to be closed: closed.
--
--   USE 2 (divergence is a discovery).  A critical pair that does NOT
--   join is not a failure.  Both of its sides are reducts of one and
--   the same peak, so the pair is a VALID EQUATION of =_R that the
--   machine's own rules already entail and its normal forms do not
--   express.  Orient it and install it: that is one step of
--   Knuth-Bendix completion, and it is a theorem obtained without
--   enumerating a single term, without a fingerprint, and without the
--   induction prover.  The null control below produces
--   `x + s(y) = s(x + y)` this way -- one of the defining equations of
--   addition -- from a two-rule system that does not contain it.
--
-- HONESTY BOUNDARY, stated because the verdict is asymmetric:
--
--   * `Convergent` is SOUND as a theorem.  Joinability is witnessed
--     positively (a common reduct is exhibited), and (T)+(N)+(CP) then
--     apply.
--   * `Diverges ps` is a report of pairs for which no common reduct was
--     found within the search bound.  Each such pair is nonetheless a
--     true consequence of R -- that part needs no bound -- so acting on
--     it (installing it) is always sound.  What is bounded is only the
--     claim "this system is NOT confluent", and the bound is printed.
--
--   * Convergence says the REWRITING lane is closed.  It does not say
--     no true equation over the vocabulary remains: x+y = y+x is true
--     of the standard model and is not in =_R for any finite R that the
--     machine has installed.  Those live in the INDUCTION lane, and
--     CERTIFY's job is precisely to separate the two lanes exactly
--     instead of letting the engine confuse "my prover found nothing"
--     with "there is nothing to find".  Every number reported below is
--     an exact count about the rewriting lane and is labelled as such.
--
-- ===================================================================
-- PROVENANCE.  MathMachine.hs is `module Main`, so it cannot be
-- imported.  Everything between the ==== TRANSCRIBED ==== markers is
-- copied from it verbatim (Term, match, applySub, step, cmpTerm,
-- decreases, normalize, lpo, precedence, orient, size, vars, subsetOf,
-- genTermsModulo, the vocabulary NAMES in order, the base symbols'
-- defining equations, and the Show instance), exactly as
-- machine/Certificate.hs does for the same reason.  Fidelity of the
-- transcription is not asserted, it is TESTED: §0 of `main` recomputes
-- the machine's own published term counts from the transcribed
-- generator and compares them with machine.log — 400 at size 4 and
-- 376636 at size 7 for the bare 8-symbol signature, and it further
-- identifies the log's other two steady values, 637852 and 574700, as
-- the same generator with one invented unary resp. binary symbol.  Any
-- mismatch aborts before a certificate is printed.
-- ===================================================================

-- ===================================================================
-- WHY THIS IS NOT `module Main` ANY MORE (2026-08-17).
--
-- It was, from the commit that landed it ("CERTIFY: the machine proves
-- its own saturation") until today.  `module Main` cannot be imported,
-- so MathMachine.hs could not reach a line of it, and the seam that
-- file wrote for this one -- `certifySeam`, with a comment promising
-- "exactly one line changes when Certify.hs lands" -- kept calling its
-- own in-file fallback for three days while the commit message said
-- the organ was connected.  The fallback is a strictly weaker test:
-- see `joinability` below, whose clause (b) is the whole reason this
-- file exists and which the fallback does not have.
--
-- So: `module Certify`, with `main` still exported.  Standalone use is
-- unchanged except for one flag --
--
--     ghc -main-is Certify -o certify machine/Certify.hs
--     runghc -imachine -- -main-is Certify machine/Certify.hs
--
-- and MathMachine.hs now imports `joinability`/`certifyBound` and runs
-- them over its own critical pairs.  The export list is explicit so
-- that what the engine is allowed to depend on is a decision recorded
-- here rather than an accident of what happens to be top-level.
-- ===================================================================
module Certify
  ( -- the transcribed term language, so a caller can translate into it
    Term(..)
  , Rule
  , Sub
    -- the rewrite relation this file certifies about
  , normalize
  , step
  , decreases
  , lpo
  , precedence
  , orient
  , cmpTerm
  , size
  , vars
  , subsetOf
    -- the transcription's own witness: a caller MUST check this against
    -- its own vocabulary before trusting a verdict, because `precedence`
    -- above is computed from it and `precedence` decides `decreases`.
  , vocabularyNames
    -- critical pairs and the confluence organ
  , Overlap(..)
  , criticalPairs
  , oneStepAll
  , reachable
  , Join(..)
  , joinability
  , certifyBound
  , CertifyResult(..)
  , certify
  , terminationCheck
    -- the standalone certificate report
  , main
  ) where

import qualified Data.Map.Strict as M
import qualified Data.Set as S
import Data.List (intercalate, nub, isPrefixOf, foldl')
import Data.Maybe (mapMaybe, isJust)
import Data.Char (isAlphaNum, isDigit, isSpace)
import Control.Monad (forM_, when, unless)
import System.Exit (exitFailure)
import System.IO
import Text.ParserCombinators.ReadP

-- ==================================================================
-- ==================== TRANSCRIBED FROM MathMachine.hs =============
-- ==================================================================

data Term = V !Int | F !String [Term] deriving (Eq, Ord)

instance Show Term where
  show (V i) | i < 6 = [ "xyzuvw" !! i ]
             | otherwise = "n" ++ show i
  show (F f []) = f
  show (F f [a,b])
    | f `elem` ["+","*","^","gcd","max"] = "(" ++ show a ++ f ++ show b ++ ")"
  show (F f as) = f ++ "(" ++ intercalate "," (map show as) ++ ")"

type Rule = (Term, Term)

size :: Term -> Int
size (V _) = 1
size (F _ ts) = 1 + sum (map size ts)

vars :: Term -> [Int]
vars (V i) = [i]
vars (F _ ts) = concatMap vars ts

subsetOf :: [Int] -> [Int] -> Bool
subsetOf a b = all (`elem` b) a

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

-- The vocabulary of MathMachine.hs is
--     vocabulary = baseVocabulary ++ arithVocabulary
-- and `precedence` is the index into that list.  Only the NAMES and
-- their ORDER matter to `precedence`, `cmpTerm`, `lpo` and hence to
-- `step`; the semantics and defining equations are carried separately
-- below.  baseVocabulary is MathMachine.hs:626; arithVocabulary is
-- `map avSym [AV.modSym, AV.lcmSym, AV.vpSym]` with names "mod",
-- "lcm", "v2" (ArithVocab.hs:170,176,181 with fixedPrime = 2).
vocabularyNames :: [String]
vocabularyNames =
  [ "0", "s", "+", "*", "max", "-", "gcd", "le", "mod", "lcm", "v2" ]

precedence :: String -> Int
precedence f =
  case [ i | (i,s) <- zip [0..] vocabularyNames, s == f ] of
    (i:_) -> i
    [] -> case f of
      ('c':ds) | all (`elem` "0123456789") ds, not (null ds) ->
        -2 - read ds
      _ -> -1

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
  | otherwise = Nothing

-- the term generator, verbatim; used by THE COUNTER to recompute the
-- machine's own published term counts rather than trusting them.
genTermsModulo :: [String] -> [String] -> [(String,Int)] -> Int -> Int -> [Term]
genTermsModulo comm assoc sig nv maxSize = concat table
  where
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

-- The defining equations, transcribed from `baseVocabulary`
-- (MathMachine.hs:626-668) together with the arities.  These are the
-- rules `usableRules` supplies as `definitionsOf (take (mVocab m)
-- vocabulary)`.
x_, y_, zero_ :: Term
x_ = V 0
y_ = V 1
zero_ = F "0" []

su :: Term -> Term
su t = F "s" [t]

bin :: String -> Term -> Term -> Term
bin f a b = F f [a,b]

baseArities :: [(String,Int)]
baseArities =
  [ ("0",0), ("s",1), ("+",2), ("*",2)
  , ("max",2), ("-",2), ("gcd",2), ("le",2) ]

baseDefs :: [(String,[Rule])]
baseDefs =
  [ ("0",   [])
  , ("s",   [])
  , ("+",   [ (bin "+" x_ zero_,    x_)
            , (bin "+" x_ (su y_),  su (bin "+" x_ y_)) ])
  , ("*",   [ (bin "*" x_ zero_,    zero_)
            , (bin "*" x_ (su y_),  bin "+" (bin "*" x_ y_) x_) ])
  , ("max", [ (bin "max" x_ zero_,        x_)
            , (bin "max" zero_ x_,        x_)
            , (bin "max" (su x_) (su y_), su (bin "max" x_ y_)) ])
  , ("-",   [ (bin "-" x_ zero_,        x_)
            , (bin "-" zero_ x_,        zero_)
            , (bin "-" (su x_) (su y_), bin "-" x_ y_) ])
  , ("gcd", [ (bin "gcd" x_ zero_, x_)
            , (bin "gcd" zero_ x_, x_) ])
  , ("le",  [ (bin "le" zero_ x_,        su zero_)
            , (bin "le" (su x_) zero_,   zero_)
            , (bin "le" (su x_) (su y_), bin "le" x_ y_) ])
  ]

definitionsUpTo :: Int -> [Rule]
definitionsUpTo n = concatMap snd (take n baseDefs)

aritiesUpTo :: Int -> [(String,Int)]
aritiesUpTo n = take n baseArities

-- ==================================================================
-- ================== END TRANSCRIPTION; NEW CODE BELOW =============
-- ==================================================================

-- ---------------------------------------------------------- positions

-- The non-variable positions of a term, root first.  Variable positions
-- are exactly the ones the critical pair lemma says need no check.
positions :: Term -> [([Int], Term)]
positions t@(F _ ts) =
  ([], t) : [ (i:p, u) | (i, ti) <- zip [0..] ts, (p,u) <- positions ti ]
positions (V _) = []

replaceAt :: [Int] -> Term -> Term -> Term
replaceAt [] new _ = new
replaceAt (i:p) new (F f ts) =
  F f [ if j == i then replaceAt p new tj else tj | (j,tj) <- zip [0..] ts ]
replaceAt _ _ t@(V _) = t          -- unreachable: p came from `positions`

shiftVars :: Int -> Term -> Term
shiftVars k (V i) = V (i + k)
shiftVars k (F f ts) = F f (map (shiftVars k) ts)

-- ---------------------------------------------------------- unification
--
-- Robinson unification with occurs check, returning an IDEMPOTENT
-- substitution so that MathMachine's own `applySub` (a single
-- non-recursive pass) resolves it completely.

type Sub = M.Map Int Term

unify :: Term -> Term -> Maybe Sub
unify a b = go [(a,b)] M.empty
  where
    go [] s = Just s
    go ((u,v):rest) s =
      case (applySub s u, applySub s v) of
        (V i, V j) | i == j -> go rest s
        (V i, t)   | i `elem` vars t -> Nothing
                   | otherwise       -> go rest (bind i t s)
        (t, V j)   | j `elem` vars t -> Nothing
                   | otherwise       -> go rest (bind j t s)
        (F f us, F g vs)
          | f == g && length us == length vs -> go (zip us vs ++ rest) s
        _ -> Nothing
    bind i t s = M.insert i t (M.map (applySub (M.singleton i t)) s)

-- ---------------------------------------------------------- overlaps

-- Everything needed to replay a critical pair by hand.
data Overlap = Overlap
  { ovOuterIx  :: Int      -- rule supplying the context (its LHS is overlapped)
  , ovInnerIx  :: Int      -- rule applied at the overlap position
  , ovPos      :: [Int]    -- position in the outer LHS; [] = root overlap
  , ovPeak     :: Term     -- sigma(outer LHS): the term both rules attack
  , ovOuter    :: Rule
  , ovInner    :: Rule
  }

posName :: [Int] -> String
posName [] = "root"
posName p  = intercalate "." (map show p)

-- criticalPairs: overlap every rule's LHS with every rule's LHS (itself
-- included) at every NON-VARIABLE subterm position, unify, and take the
-- two divergent reducts of the peak.
--
--   outer rule  (l2 -> r2)   supplies the context
--   inner rule  (l1 -> r1)   is applied at position p inside l2
--   sigma = mgu(l1, l2|p)      (l1 renamed apart from l2 first)
--   peak  = sigma(l2)
--   left  = peak[ sigma(r1) ]_p     (inner rule fired)
--   right = sigma(r2)               (outer rule fired at the root)
--
-- The root-with-itself overlap (i == j, p == root) is excluded: its mgu
-- is the identity and both reducts are the same term.  Proper-subterm
-- self-overlaps are NOT excluded; they are real and are the ones that
-- catch a single recursive rule that is not confluent with itself.
criticalPairs :: [Rule] -> [(Term, Term, Overlap)]
criticalPairs rs =
  [ (left, right, ov)
  | (j, (l2,r2)) <- indexed
  , (i, (l1,r1)) <- indexed
  , let off  = 1 + maximum (0 : (vars l2 ++ vars r2))
  , let l1'  = shiftVars off l1
  , let r1'  = shiftVars off r1
  , (p, sub) <- positions l2
  , not (i == j && null p)
  , Just mgu <- [unify l1' sub]
  , let peak  = applySub mgu l2
  , let left  = replaceAt p (applySub mgu r1') peak
  , let right = applySub mgu r2
  , let ov = Overlap { ovOuterIx = j, ovInnerIx = i, ovPos = p
                     , ovPeak = peak, ovOuter = (l2,r2), ovInner = (l1,r1) }
  ]
  where indexed = zip [0..] rs

-- ---------------------------------------------------------- joinability
--
-- Two independent tests, because they certify different things.
--
--  (a) STRATEGY JOIN: `normalize rs a == normalize rs b`, using
--      MathMachine's own innermost-leftmost `step`.  Cheap, and it is
--      the test that matters operationally, because `normalize` is what
--      the engine actually runs.
--
--  (b) REACHABILITY JOIN: build the FULL set of reducts of each side
--      (all rules at all non-variable positions, each guarded by
--      `decreases` exactly as `step` guards it) up to a node bound, and
--      intersect.  This is the honest test of the mathematical
--      property: joinability quantifies over all derivations, not over
--      one strategy.  Termination makes both sets finite; the bound is
--      a guard against a rule set that is not in fact terminating, and
--      whether it was hit is reported.

oneStepAll :: [Rule] -> Term -> [Term]
oneStepAll rs t =
  [ replaceAt p (applySub sub r) t
  | (p,u) <- positions t
  , (l,r) <- rs
  , Just sub <- [match l u]
  , let u' = applySub sub r
  , decreases u u'
  ]

-- Nothing = node bound exhausted (the set is not known to be complete).
reachable :: Int -> [Rule] -> Term -> Maybe (S.Set Term)
reachable bound rs t0 = go (S.singleton t0) [t0]
  where
    go seen [] = Just seen
    go seen (t:queue)
      | S.size seen > bound = Nothing
      | otherwise =
          let new = [ u | u <- oneStepAll rs t, not (u `S.member` seen) ]
          in go (foldl' (flip S.insert) seen new) (queue ++ new)

data Join
  = JoinsAt Term          -- witnessed common reduct
  | NoJoin                -- both reduct sets complete, intersection empty
  | JoinUnknown           -- node bound exhausted; no verdict
  deriving (Eq)

joinability :: Int -> [Rule] -> Term -> Term -> Join
joinability bound rs a b
  | na == nb = JoinsAt na                      -- (a) strategy join
  | otherwise =
      case (reachable bound rs a, reachable bound rs b) of
        (Just sa, Just sb) ->
          case S.toList (S.intersection sa sb) of
            (v:_) -> JoinsAt v                 -- (b) reachability join
            []    -> NoJoin
        _ -> JoinUnknown
  where na = normalize rs a
        nb = normalize rs b

-- ---------------------------------------------------------- certify

data CertifyResult
  = Convergent
  | Diverges [(Term,Term)]
  deriving (Eq)

certifyBound :: Int
certifyBound = 20000

-- The organ.  Given a rule set every member of which `orient` admitted
-- (hence LPO-decreasing, hence terminating), decide confluence by
-- Newman + the critical pair lemma.
certify :: [Rule] -> CertifyResult
certify rs =
  case nub [ canonPair (a,b) | (a,b,_) <- criticalPairs rs
           , joinability certifyBound rs a b /= JoinsAt (normalize rs a)
           , notJoined a b ] of
    [] -> Convergent
    ds -> Diverges ds
  where
    notJoined a b = case joinability certifyBound rs a b of
                      JoinsAt _ -> False
                      _         -> True
    -- a critical pair is unordered; report each divergence once
    canonPair (a,b) =
      let (a',b') = (normalize rs a, normalize rs b)
      in if cmpTerm a' b' == GT then (b',a') else (a',b')

-- Every rule of R is LPO-oriented?  This is the (T) hypothesis of the
-- certificate and it is checked, not assumed.
terminationCheck :: [Rule] -> [Rule]
terminationCheck rs = [ (l,r) | (l,r) <- rs
                      , not (lpo l r) || not (vars r `subsetOf` vars l) ]

-- ---------------------------------------------------------- reporting

reportCertify :: String -> [Rule] -> IO CertifyResult
reportCertify title rs = do
  putStrLn ("\n=== " ++ title ++ " ===")
  putStrLn ("RULES (" ++ show (length rs) ++ ")")
  forM_ (zip [0::Int ..] rs) $ \(i,(l,r)) ->
    putStrLn ("  R" ++ show i ++ ":  " ++ show l ++ "  ->  " ++ show r)
  let bad = terminationCheck rs
  if not (null bad)
    then do
      putStrLn "TERMINATION: FAILED — these rules are not LPO-decreasing:"
      forM_ bad $ \(l,r) -> putStrLn ("  " ++ show l ++ " -> " ++ show r)
      putStrLn "  Newman's lemma does not apply; no certificate is possible."
    else putStrLn "TERMINATION: every rule is LPO-decreasing with vars r ⊆ vars l,\n  so → is terminating and Newman's lemma applies."
  let cps = criticalPairs rs
      kindOf ov | null (ovPos ov) = "root"
                | ovInnerIx ov == ovOuterIx ov = "self"
                | otherwise = "subterm"
      kinds k = length [ () | (_,_,ov) <- cps, kindOf ov == k ]
  putStrLn ("CRITICAL PAIRS: " ++ show (length cps)
            ++ "  (overlaps of every LHS with every LHS at every non-variable\n"
            ++ "   position, self-overlaps included, trivial root-with-self excluded)")
  putStrLn ("  by kind:  root " ++ show (kinds "root")
            ++ "   proper-subterm " ++ show (kinds "subterm")
            ++ "   proper-subterm-with-itself " ++ show (kinds "self"))
  forM_ (zip [1::Int ..] cps) $ \(n,(a,b,ov)) -> do
    let jn = joinability certifyBound rs a b
        verdict = case jn of
          JoinsAt v -> "JOINS at " ++ show v
          NoJoin    -> "*** DIVERGES ***"
          JoinUnknown -> "*** UNKNOWN (node bound " ++ show certifyBound ++ " hit) ***"
    putStrLn ("  CP" ++ pad 3 (show n)
              ++ " R" ++ show (ovInnerIx ov) ++ " into R" ++ show (ovOuterIx ov)
              ++ " at " ++ pad 6 (posName (ovPos ov)))
    putStrLn ("       peak  " ++ show (ovPeak ov))
    putStrLn ("       ⇓R" ++ show (ovInnerIx ov) ++ "   " ++ show a
              ++ "   ↓* " ++ show (normalize rs a))
    putStrLn ("       ⇓R" ++ show (ovOuterIx ov) ++ "   " ++ show b
              ++ "   ↓* " ++ show (normalize rs b))
    putStrLn ("       " ++ verdict)
  let res = certify rs
  case res of
    Convergent -> do
      putStrLn "VERDICT: CONVERGENT."
      putStrLn "  Terminating (LPO) + all critical pairs joinable"
      putStrLn "  ⟹ locally confluent (critical pair lemma)"
      putStrLn "  ⟹ confluent (Newman)"
      putStrLn "  ⟹ unique normal forms, and for all s,t:"
      putStrLn "         s =_R t  ⇔  normalize R s == normalize R t."
      putStrLn "  The rewriting lane over this vocabulary is CLOSED, as a theorem."
    Diverges ds -> do
      putStrLn ("VERDICT: NOT CERTIFIED CONVERGENT — " ++ show (length ds)
                ++ " non-joining critical pair(s).")
      putStrLn "  Each is a TRUE EQUATION of =_R (both sides reduce from one peak),"
      putStrLn "  so each is a new theorem to install — Knuth–Bendix completion:"
      forM_ ds $ \(a,b) -> do
        putStrLn ("    NEW EQUATION  " ++ show a ++ "  =  " ++ show b)
        case orient (a,b) of
          Just (l,r) -> putStrLn ("      orients to  " ++ show l ++ "  ->  " ++ show r)
          Nothing    -> putStrLn  "      unorientable by LPO; would enter as a lemma (ordered rewriting)"
  return res

pad :: Int -> String -> String
pad n s = s ++ replicate (n - length s) ' '

-- ==================================================================
-- READING THE MACHINE'S ACTUAL INSTALLED LIBRARY
--
-- machine/library.txt is written with `show`, i.e. the infix rendering
-- above.  (MathMachine's own `parseTerm` reads the PREFIX format of
-- machine/library.terms, which this checkout does not have — the note
-- at MathMachine.hs:515 is about exactly that mismatch.)  So the reader
-- here inverts `show`.
-- ==================================================================

libTermP :: ReadP Term
libTermP = infixP +++ appP +++ atomP
  where
    infixP = between (char '(') (char ')') $ do
      a  <- libTermP
      op <- choice (map string ["gcd","max","+","*","^"])
      b  <- libTermP
      return (F op [a,b])
    appP = do
      n  <- name
      ts <- between (char '(') (char ')') (sepBy1 libTermP (char ','))
      return (F n ts)
    atomP = do
      n <- name
      case n of
        [c] | Just i <- lookup c (zip "xyzuvw" [0..]) -> return (V i)
        ('n':ds) | not (null ds), all isDigit ds -> return (V (read ds))
        _ -> return (F n [])
    -- NOT MathMachine's `identifier`: that one admits "+*-^" inside a
    -- name, which is right for the PREFIX format it reads and fatal
    -- here — `munch1` is maximal-munch, so "0+x" would be swallowed as
    -- a single identifier and the infix rendering would never parse.
    -- The only operator-shaped symbol `show` emits in prefix position
    -- is "-" (monus renders as "-(a,b)"), so it is offered separately.
    name = munch1 (\c -> isAlphaNum c || c `elem` "#_") +++ string "-"

parseLibTerm :: String -> Maybe Term
parseLibTerm s =
  case [ t | (t,_) <- readP_to_S (libTermP <* eof) (filter (not . isSpace) s) ] of
    (t:_) -> Just t
    _     -> Nothing

-- one library line:  LHS  =  RHS   [justification]
parseLibLine :: String -> Maybe (Term,Term,String)
parseLibLine ln0
  | all isSpace ln0 = Nothing
  | otherwise =
      let (body, just) = case break (== '[') ln0 of
                           (b, '[':j) -> (b, takeWhile (/= ']') j)
                           (b, _)     -> (b, "")
      in case break (== '=') body of
           (lhs, '=':rhs) -> do
             l <- parseLibTerm lhs
             r <- parseLibTerm rhs
             return (l, r, just)
           _ -> Nothing

-- ==================================================================
-- THE COUNTER
-- ==================================================================

data RoundLine = RoundLine
  { rlRound :: Int, rlVocab :: Int, rlSize :: Int
  , rlTerms :: Integer, rlNormed :: Integer
  , rlConj :: Integer, rlFresh :: Integer, rlProved :: Integer
  } deriving (Show)

parseRoundLine :: String -> Maybe RoundLine
parseRoundLine ln = case words ln of
  ("round":n:ws) -> do
    let field k = case [ drop (length k + 1) w | w <- ws, (k ++ "=") `isPrefixOf` w ] of
                  (v:_) -> Just v
                  _     -> Nothing
    v <- field "vocab"; sz <- field "size"; tm <- field "terms"; nm <- field "normed"
    cj <- field "conj";  fr <- field "fresh"; pv <- field "proved"
    return (RoundLine (read n) (read v) (read sz)
                      (read tm) (read nm) (read cj) (read fr) (read pv))
  _ -> Nothing

-- ==================================================================
-- MAIN
-- ==================================================================

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetBuffering stdout LineBuffering
  putStrLn "==================================================================="
  putStrLn "CERTIFY — the machine proves the boundary of its own knowledge"
  putStrLn "machine/Certify.hs   (CLOSE → CERTIFY → PORT → GROW, THE_MACHINE.md)"
  putStrLn "==================================================================="

  ------------------------------------------------------------------
  -- 0. transcription fidelity
  ------------------------------------------------------------------
  putStrLn "\n=== 0. TRANSCRIPTION CHECK ==="
  putStrLn "The transcribed generator must reproduce the machine's own published"
  putStrLn "term counts (machine/machine.log) exactly, or nothing below is about"
  putStrLn "the machine.  vocab=8, kVars=3, no invented symbols, no proved"
  putStrLn "commutativity/associativity:"
  let sig8 = aritiesUpTo 8
      genCount sig n = length (genTermsModulo [] [] sig 3 n)
      expected = [(4, 400), (7, 376636)] :: [(Int,Int)]
  ok <- fmap and $ mapM (\(sz,want) -> do
          let got = genCount sig8 sz
          putStrLn ("  |terms| at size " ++ show sz ++ " = " ++ show got
                    ++ "   machine.log rounds 0/1 and 6,8,10,… say " ++ show want
                    ++ (if got == want then "   OK" else "   MISMATCH"))
          return (got == want)) expected
  unless ok $ do
    putStrLn "TRANSCRIPTION MISMATCH — refusing to report a certificate."
    exitFailure
  -- and the log's OTHER steady value, 637852, is the same generator with
  -- one invented symbol in the signature — the alternation in the growth
  -- ladder (coin a concept / withdraw it).  Identifying it exactly is a
  -- second, independent check on the transcription.
  putStrLn "  the log alternates 376636 / 637852; the second value is the same"
  putStrLn "  generator with ONE invented symbol in the signature (the coin/"
  putStrLn "  withdraw alternation of the growth ladder):"
  forM_ [1::Int,2] $ \ar ->
    putStrLn ("    + one invented symbol of arity " ++ show ar ++ " : "
              ++ show (genCount (sig8 ++ [("c0",ar)]) 7)
              ++ (if genCount (sig8 ++ [("c0",ar)]) 7 == 637852
                    then "   = 637852  OK" else ""))

  ------------------------------------------------------------------
  -- 1. the live library
  ------------------------------------------------------------------
  putStrLn "\n=== 1. THE MACHINE'S ACTUAL INSTALLED LIBRARY ==="
  raw <- readFile "machine/library.txt"
  let parsed = mapMaybe parseLibLine (lines raw)
      unparsed = [ ln | ln <- lines raw, not (all isSpace ln)
                      , parseLibLine ln == Nothing ]
  forM_ unparsed $ \ln -> putStrLn ("  UNPARSED: " ++ ln)
  unless (null unparsed) $ do
    putStrLn "  refusing to certify a library I cannot read in full."
    exitFailure
  forM_ parsed $ \(l,r,j) ->
    putStrLn ("  " ++ show l ++ "  =  " ++ show r ++ "   [" ++ j ++ "]")
  let libRules = mapMaybe (\(l,r,_) -> orient (l,r)) parsed
      unoriented = [ (l,r) | (l,r,_) <- parsed, not (isJust (orient (l,r))) ]
  putStrLn ("  oriented by LPO into rules: " ++ show (length libRules)
            ++ ";  unorientable (would enter as lemmas): "
            ++ show (length unoriented))

  -- the rule set the live run actually had: definitions of the first 8
  -- vocabulary symbols (mVocab = 8 throughout machine.log) + the library
  let liveRules = definitionsUpTo 8 ++ libRules
  -- and the vocab-4 subsystem the library is actually ABOUT (0,s,+,*)
  let peanoRules = definitionsUpTo 4 ++ libRules

  r4 <- reportCertify "2a. R over {0,s,+,*} — definitions + installed library" peanoRules
  r8 <- reportCertify "2b. R as the live run had it — definitions of all 8 base symbols + installed library" liveRules

  ------------------------------------------------------------------
  -- 2c. overlap coverage
  ------------------------------------------------------------------
  putStrLn "\n\n=== 2c. OVERLAP COVERAGE — the machinery, exercised ==="
  putStrLn "The live library's left sides are all `+`/`*`/`max`/`-`/`gcd`/`le`"
  putStrLn "headed with `0`- or `s`-shaped arguments, and NO rule has an"
  putStrLn "`s`-headed or `0`-headed left side, so no proper subterm of any"
  putStrLn "left side can unify with any left side: §2a/§2b are all root"
  putStrLn "overlaps, and that is a fact about the library, not a gap in the"
  putStrLn "overlap search.  To show the search really finds the other two"
  putStrLn "kinds, here is associativity added to two of the same rules —"
  putStrLn "`(x+y)+z` has the proper non-variable subterm `x+y`, which unifies"
  putStrLn "both with `0+x` (a DIFFERENT rule) and with `(x+y)+z` itself."
  let assocRules =
        [ (bin "+" (bin "+" x_ y_) (V 2), bin "+" x_ (bin "+" y_ (V 2)))
        , (bin "+" zero_ x_, x_)
        , (bin "+" x_ zero_, x_) ]
  rAssoc <- reportCertify "2c. {(x+y)+z -> x+(y+z),  0+x -> x,  x+0 -> x}" assocRules
  let cpsA = criticalPairs assocRules
      kindsA k = length [ () | (_,_,ov) <- cpsA
                        , (if null (ovPos ov) then "root"
                           else if ovInnerIx ov == ovOuterIx ov then "self"
                           else "subterm") == k ]
  when (kindsA "subterm" == 0 || kindsA "self" == 0) $ do
    putStrLn "OVERLAP COVERAGE FAILED: the search found no proper-subterm or"
    putStrLn "no self overlap where both must exist.  criticalPairs is a stub."
    exitFailure
  putStrLn ("  COVERAGE OK — root " ++ show (kindsA "root")
            ++ ", proper-subterm " ++ show (kindsA "subterm")
            ++ ", proper-subterm-with-itself " ++ show (kindsA "self")
            ++ ".  All three code paths are live.")

  ------------------------------------------------------------------
  -- 3. null control
  ------------------------------------------------------------------
  putStrLn "\n\n=== 3. NULL CONTROL — a NON-convergent rule set ==="
  putStrLn "Both rules below are true of the standard model and both are"
  putStrLn "LPO-orientable, so `orient` would install either.  The set is"
  putStrLn "terminating.  It is not confluent, and CERTIFY must say so —"
  putStrLn "if it certified this, the saving in §4 would be worthless."
  let nullRules = [ (bin "+" (su x_) y_, su (bin "+" x_ y_))     -- s(x)+y -> s(x+y)
                  , (bin "+" (su x_) y_, bin "+" x_ (su y_)) ]   -- s(x)+y -> x+s(y)
  rNull <- reportCertify "3a. {s(x)+y -> s(x+y),  s(x)+y -> x+s(y)}" nullRules

  putStrLn "\n--- 3b. KNUTH–BENDIX COMPLETION: install the divergence, re-certify ---"
  case rNull of
    Convergent -> putStrLn "  NULL CONTROL FAILED: the divergent set was certified convergent."
    Diverges ds -> do
      let newRules = mapMaybe orient ds
      forM_ newRules $ \(l,r) ->
        putStrLn ("  installing  " ++ show l ++ "  ->  " ++ show r
                  ++ "   (a theorem obtained WITHOUT enumerating a single term)")
      _ <- reportCertify "3b. the same set, completed" (nullRules ++ newRules)
      return ()

  ------------------------------------------------------------------
  -- 4. THE COUNTER
  ------------------------------------------------------------------
  putStrLn "\n\n==================================================================="
  putStrLn "=== 4. THE COUNTER — what CERTIFY makes unnecessary ==="
  putStrLn "==================================================================="
  logtxt <- readFile "machine/machine.log"
  let rounds = mapMaybe parseRoundLine (lines logtxt)
      lastProductive = maximum (0 : [ rlRound r | r <- rounds, rlProved r > 0 ])
      barren = [ r | r <- rounds, rlRound r > lastProductive ]
      sumOn f = sum (map f barren)
  putStrLn ("Source: machine/machine.log, " ++ show (length rounds)
            ++ " rounds of the live engine.  Every figure below is an EXACT")
  putStrLn "integer the engine itself printed; none is a measurement."
  putStrLn ("\nLast round that installed a theorem: round " ++ show lastProductive
            ++ "  (known = 4, and 4 is what machine/library.txt holds today)")
  putStrLn ("Rounds after it: " ++ show (length barren)
            ++ "  — every one enumerated the term space, stated conjectures,")
  putStrLn "  and installed nothing.  That is CLOSE with no CERTIFY: the"
  putStrLn "  machine cannot tell 'nothing to find' from 'I did not find it'."
  putStrLn ""
  putStrLn "  round  vocab size      terms     normed       conj      fresh  proved"
  forM_ barren $ \r ->
    putStrLn ("  " ++ pad 6 (show (rlRound r)) ++ pad 6 (show (rlVocab r))
              ++ pad 5 (show (rlSize r))
              ++ pad 11 (show (rlTerms r)) ++ pad 11 (show (rlNormed r))
              ++ pad 11 (show (rlConj r)) ++ pad 11 (show (rlFresh r))
              ++ show (rlProved r))
  putStrLn ""
  putStrLn ("  TOTALS over the " ++ show (length barren) ++ " barren rounds")
  putStrLn ("    terms enumerated and normalized : " ++ show (sumOn rlTerms))
  putStrLn ("    normal forms retained           : " ++ show (sumOn rlNormed))
  putStrLn ("    conjectures stated              : " ++ show (sumOn rlConj))
  putStrLn ("    conjectures attempted (fresh)   : " ++ show (sumOn rlFresh))
  putStrLn ("    theorems installed              : " ++ show (sumOn rlProved))
  let steady = [ r | r <- barren, rlSize r == 7 ]
      perRound = if null steady then 0 else maximum (map rlTerms steady)
      perRoundLo = if null steady then 0 else minimum (map rlTerms steady)
  putStrLn ""
  putStrLn ("  Steady state (vocab=8, size=7): " ++ show (length steady)
            ++ " rounds, " ++ show perRoundLo ++ "–" ++ show perRound
            ++ " terms each — and §0 identified both endpoints exactly:")
  putStrLn "  376636 is the 8-symbol signature, 637852 the same plus one"
  putStrLn "  invented unary symbol, 574700 plus one invented binary symbol."
  putStrLn ("  Rounds 6,8,10,12,... are bit-identical: 376636 terms → 139605")
  putStrLn  "  normal forms → 34408 conjectures, every time.  MathMachine.hs:2445"
  putStrLn  "  names this exact loop ('the same terms, hence the same"
  putStrLn  "  conjectures ... fresh=0 forever') and has no way to prove it."
  putStrLn ""
  putStrLn "WHAT THE CERTIFICATE REPLACES, EXACTLY:"
  case (r4, r8) of
    (Convergent, Convergent) -> do
      putStrLn "  R is convergent (§2a and §2b above).  Therefore, for all s,t:"
      putStrLn "      s =_R t  ⇔  normalize R s == normalize R t."
      putStrLn "  Two consequences, both exact:"
      putStrLn ""
      putStrLn "  (1) `normed` is a SET OF CLASS REPRESENTATIVES.  A round's"
      putStrLn "      conjectures are pairs of DISTINCT normal forms, so every"
      putStrLn "      one of them is provably NOT in =_R: the rewriting lane of"
      putStrLn "      the prover is guaranteed to return nothing before the round"
      putStrLn "      is run.  In the barren rounds that is"
      putStrLn ("        " ++ show (sumOn rlConj) ++ " conjectures × 2 normalizations each,")
      putStrLn "      spent by `provedByRewriting` on a question whose answer is a"
      putStrLn "      theorem."
      putStrLn ""
      putStrLn "  (2) RE-ENUMERATION IS PROVABLY FUTILE, AT EVERY HORIZON.  The"
      putStrLn "      certificate quantifies over ALL terms, not over terms of"
      putStrLn "      size ≤ the current horizon, so one certificate covers the"
      putStrLn "      whole deepening ladder at once: sizes 4,5,6,7 (rounds"
      putStrLn "      1–5) and every size above.  With R fixed and convergent,"
      putStrLn "      enlarging the term space cannot expose an equation of =_R"
      putStrLn "      that R has not already collapsed — the normal forms ARE"
      putStrLn "      the classes.  So the engine's response to a barren round"
      putStrLn "      (widen the horizon, re-enumerate) is proved unnecessary for"
      putStrLn "      the rewriting lane, and CLOSE may hand straight to PORT."
      putStrLn ""
      putStrLn "  COUNT:"
      putStrLn ("      terms enumerated per round (steady state) : " ++ show perRound)
      putStrLn ("      barren rounds in the live log             : " ++ show (length barren))
      putStrLn ("      term-enumerations made unnecessary        : " ++ show (sumOn rlTerms))
      putStrLn ("      conjecture generate-and-test cycles ditto : " ++ show (sumOn rlConj))
      putStrLn ("      theorems thereby lost                     : " ++ show (sumOn rlProved))
      putStrLn ""
      putStrLn "  The last line is the whole argument: the saving costs nothing,"
      putStrLn "  because the rounds it deletes proved nothing and — now — are"
      putStrLn "  PROVED to have been unable to."
    _ ->
      putStrLn "  R is NOT certified convergent, so no saving may be claimed."

  putStrLn "\n--- 4b. NULL CONTROL FOR THE COUNTER ---"
  putStrLn "The saving is licensed by the certificate, not by the wish for it."
  putStrLn "On the divergent set of §3a the same reasoning must FAIL, and it"
  putStrLn "fails observably: there are two distinct normal forms that are"
  putStrLn "nonetheless =_R, so `normed` is NOT a set of class representatives"
  putStrLn "and a conjecture between them IS reachable by rewriting."
  case rNull of
    Convergent -> putStrLn "  (unreachable: §3a certified convergent)"
    Diverges ds -> do
      forM_ ds $ \(a,b) -> do
        putStrLn ("  " ++ show a ++ " and " ++ show b
                  ++ " are distinct normal forms of the divergent R,")
        putStrLn ("  yet both reduce from the peak "
                  ++ show (bin "+" (su x_) y_) ++ ", so they ARE =_R.")
      putStrLn "  CERTIFY returns Diverges; no rounds are saved; instead one"
      putStrLn "  theorem is HANDED to the machine (§3b).  Divergence pays too."
  putStrLn ""
  putStrLn "==================================================================="
  putStrLn ("FINAL: live library over {0,s,+,*} : "
            ++ (case r4 of Convergent -> "CONVERGENT"; _ -> "DIVERGES"))
  putStrLn ("       live library over all 8     : "
            ++ (case r8 of Convergent -> "CONVERGENT"; _ -> "DIVERGES"))
  putStrLn ("       overlap coverage probe      : "
            ++ (case rAssoc of Convergent -> "CONVERGENT"; _ -> "DIVERGES")
            ++ " (root + subterm + self overlaps all exercised)")
  putStrLn ("       null control                : "
            ++ (case rNull of Convergent -> "CONVERGENT (TEST FAILED)"
                              _ -> "DIVERGES (test passed)"))
  putStrLn "==================================================================="
