-- सिद्धिः — attainment.  The wire the machine's own map has named since
-- it was drawn (YantraJnana weld #1) and its own conjecture organ
-- blessed in its header ("the non-joining pairs come out in exactly the
-- l\tr shape library.terms uses — wiring offer"):
--
--     Sanghatta finds the exact theorems the rewriter is missing
--        → Certificate proves them, controls watched, kernel judging
--           → the proven, ORIENTABLE ones are installed into
--             machine/library.terms
--              → the gap is re-measured and has shrunk.
--
-- The machine closing its own gap, with a number that can refuse to move.
--
-- WHAT IS INSTALLED, exactly: only pairs the kernel ACCEPTED whose two
-- sides differ in size.  A strictly size-decreasing rule keeps the
-- normalizer terminating.  A kernel-proven pair of EQUAL size (the
-- commutative face) is TRUE but not installable as a rewrite without
-- completion modulo AC — the समता-चक्रम् diagnosis — so it is proven,
-- reported, and withheld from the store, by name, not silently.
--
-- WHAT THIS FILE ADDS OF ITS OWN: nothing mathematical.  The census is
-- Sanghatta's (its term/unification/critical-pair code, carried here so
-- the before/after measure runs in one process — with the one repair its
-- original needs: the store is read as UTF-8 explicitly, the fault class
-- Certificate.hs §(2) documents).  The proving is Certificate's, watched
-- controls and all.  The store format is the store's.  One wire.
--
-- Run:  runghc -imachine machine/Siddhi_...hs            (default caps)
--       runghc -imachine machine/Siddhi_...hs 80 14      (pairs, max size)

{-# LANGUAGE LambdaCase #-}
module Main (main) where

import qualified Data.Map.Strict as M
import qualified Data.Set as S
import Data.List (nub, sortOn, isPrefixOf, intercalate)
import Control.Monad (foldM)
import Data.Maybe (mapMaybe, fromMaybe)
import Data.Char (isAlphaNum)
import System.Environment (getArgs)
import System.IO
import Data.Time.Clock (getCurrentTime)
import Data.Time.Format (formatTime, defaultTimeLocale)

import qualified Certificate as C

-- ── Sanghatta's term world, carried (surface syntax of library.terms) ──
data Term = V String | F String [Term] deriving (Eq, Ord, Show)

vars :: [String]
vars = ["x","y","z","u","v","w"]

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
    nameChar c = isAlphaNum c || c `elem` "-*+"

render :: Term -> String
render (V v)     = v
render (F f [])  = f
render (F f as)  = f ++ "(" ++ intercalate "," (map render as) ++ ")"

size :: Term -> Int
size (V _)    = 1
size (F _ as) = 1 + sum (map size as)

varsOfT :: Term -> [String]
varsOfT (V v)    = [v]
varsOfT (F _ as) = nub (concatMap varsOfT as)

type Sub = M.Map String Term

apply :: Sub -> Term -> Term
apply s (V v)    = fromMaybe (V v) (M.lookup v s)
apply s (F f as) = F f (map (apply s) as)

occurs :: String -> Term -> Bool
occurs v t = v `elem` varsOfT t

unify :: Term -> Term -> Maybe Sub
unify a0 b0 = go [(a0, b0)] M.empty
  where
    go [] s = Just s
    go ((V v, t):rest) s
      | V v == t   = go rest s
      | occurs v t = Nothing
      | otherwise  = let s1 = M.insert v t (M.map (apply (M.singleton v t)) s)
                     in go [ (apply s1 l, apply s1 r) | (l, r) <- rest ] s1
    go ((t, V v):rest) s = go ((V v, t):rest) s
    go ((F f as, F g bs):rest) s
      | f == g && length as == length bs = go (zip as bs ++ rest) s
      | otherwise = Nothing

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

nonVarPos :: Term -> [([Int], Term)]
nonVarPos t@(F _ as) =
  ([], t) : [ (i : p, u) | (i, a) <- zip [0 ..] as, (p, u) <- nonVarPos a ]
nonVarPos _ = []

replaceAt :: Term -> [Int] -> Term -> Term
replaceAt _ [] u = u
replaceAt (F f as) (i:p) u =
  F f [ if j == i then replaceAt a p u else a | (j, a) <- zip [0 ..] as ]
replaceAt t _ _ = t

freshen :: Term -> (Term, Term) -> (Term, Term)
freshen against (l, r) =
  let taken = S.fromList (varsOfT against)
      ren v = if v `S.member` taken then v ++ "'" else v
      go (V v)    = V (ren v)
      go (F f as) = F f (map go as)
  in (go l, go r)

criticalPairs :: Rule -> Rule -> [(Term, Term)]
criticalPairs r1@(l1, r1r) r2 =
  [ (apply s r1r, apply s (replaceAt l1 pos re2))
  | let (l2, re2) = freshen l1 r2
  , (pos, sub) <- nonVarPos l1
  , pos /= [] || fst r1 /= l2
  , Just s <- [unify sub l2]
  ]

-- the measure: read the store (UTF-8, explicitly), count the gap.
readStore :: IO [(Term, Term)]
readStore = do
  h <- openFile "machine/library.terms" ReadMode
  hSetEncoding h utf8
  raw <- lines <$> hGetContents h
  let rules = [ (l, r)
              | ln <- raw
              , not ("#" `isPrefixOf` ln), not (null ln)
              , let (a, rest) = break (== '\t') ln
              , let b = takeWhile (/= '\t') (drop 1 rest)
              , Just l <- [parseT a], Just r <- [parseT b] ]
  length rules `seq` hClose h
  pure rules

gapOf :: [(Term, Term)] -> [(Term, Term)]
gapOf rules =
  let rw  = [ (r, l) | (l, r) <- rules, size r >= size l ]
      cps = nub [ (a, b) | ru1 <- rw, ru2 <- rw
                         , (a, b) <- criticalPairs ru1 ru2, a /= b ]
  in nub [ (na, nb) | (a, b) <- cps
                    , let na = normal rw a, let nb = normal rw b
                    , na /= nb ]

-- ── the bridge into Certificate's world ──
-- Critical pairs carry freshened variables (x', y'); the prover's world
-- has six names.  Canonicalize both sides together, by first occurrence,
-- before crossing — the first pass's own refusal column found this: every
-- primed pair was refused before refl was even attempted.
canonical :: (Term, Term) -> (Term, Term)
canonical (a, b) =
  let occ = nub (varsOfT a ++ varsOfT b)
      ren = M.fromList (zip occ vars)
      go (V v)    = V (fromMaybe v (M.lookup v ren))
      go (F f ts) = F f (map go ts)
  in (go a, go b)

toC :: Term -> Maybe C.Term
toC (V v)    = C.V <$> lookup v (zip vars [0 ..])
toC (F "0" []) = Just (C.F "0" [])
toC (F f as)   = C.F f <$> mapM toC as

-- prove a ≡ b: refl first, then induction on each variable, first win.
prove :: (Term, Term) -> IO (Maybe String)
prove p0 = let (a, b) = canonical p0 in case (,) <$> toC a <*> toC b of
  Nothing -> pure Nothing
  Just (ca, cb) -> go ("" : [ "induction on " ++ v | v <- varsOfT a ])
    where
      go [] = pure Nothing
      go (note : rest) = do
        v <- C.certify "." ((ca, cb), note)
        case v of
          C.Certified shape _ -> pure (Just (if null note then shape else note ++ ", " ++ shape))
          _                   -> go rest

main :: IO ()
main = do
  hSetEncoding stdout utf8
  as <- getArgs
  let (capPairs, capSize) = case as of
        (p:s:_) -> (read p, read s)
        (p:_)   -> (read p, 12)
        []      -> (60, 12)
  now <- formatTime defaultTimeLocale "%Y-%m-%dT%H:%M:%SZ" <$> getCurrentTime
  rules0 <- readStore
  let gap0 = gapOf rules0
      todo = take capPairs
               [ p | p@(a, b) <- sortOn (\(a', b') -> size a' + size b') gap0
                   , size a /= size b            -- installable: strictly decreasing
                   , size a + size b <= capSize ]
      held = length [ () | (a, b) <- gap0, size a == size b ]
  putStrLn ("सिद्धिः — the gap, before: " ++ show (length gap0)
            ++ " non-joining pairs (" ++ show held
            ++ " equal-size, withheld for the AC lane by the समता-चक्रम् diagnosis)")
  putStrLn ("attempting " ++ show (length todo)
            ++ " installable pairs (size ≤ " ++ show capSize ++ "), kernel judging each,")
  putStrLn  "and each PROVEN rule installs only if it strictly shrinks the gap it"
  putStrLn  "claims to close — the second pass of this organ measured the naive"
  putStrLn  "install going BACKWARDS (387→411: new rules breed new critical pairs,"
  putStrLn  "plain completion on an AC theory is generative, as समता-चक्रम् said),"
  putStrLn  "so descent is now the licence, per rule, before landing:\n"
  (_, _, installedRev) <- foldM (attempt now) (rules0, gap0, []) todo
  let installed = reverse installedRev
  if null installed
    then putStrLn "\nnothing installed this pass."
    else do
      appendFile "machine/library.terms" $ unlines $
        ("# siddhi " ++ now ++ " — kernel-accepted closures of the rewriter's own critical pairs;"
         ++ " each row's proof shape is beside it; controls were watched in this process (Certificate)")
        : installed
      rules1 <- readStore
      let gap1 = gapOf rules1
      putStrLn ("\nthe gap, after: " ++ show (length gap1) ++ " non-joining pairs")
      putStrLn ("closed by the machine's own act: "
                ++ show (length gap0 - length gap1))
      appendFile "machine/aisthesis.jsonl" $ concat
        [ "{\"indriya\":\"siddhi\",\"kriya\":\"svagata-sthapana\""
        , ",\"naya\":\"the rewriter's own missing theorems, proven by the watched kernel and installed into its own store; only strictly size-decreasing rules land, so the normalizer's termination is preserved\""
        , ",\"visaya\":\"machine/library.terms\""
        , ",\"upalabdhi\":{\"gap_before\":", show (length gap0)
        , ",\"gap_after\":", show (length gap1)
        , ",\"installed\":", show (length installed)
        , ",\"withheld_equal_size\":", show held, "}"
        , ",\"pramanya\":{\"marga\":\"kernel\",\"saksin\":\"each installed row was Certified by agda with the two controls watched first (Certificate.certify); the gap counts are exhaustive critical-pair censuses over the store before and after\"}"
        , ",\"sesa\":[\"the equal-size faces await completion modulo AC — the store cannot hold them as rules without losing termination\"]"
        , ",\"agama\":\"machine/Siddhi_TheMachineProvesWhatItToldItselfItWasMissingAndInstallsIt.hs, this run\""
        , ",\"kala\":\"", now, "\"}\n"
        ]
  where
    attempt _ st@(store, gap, acc) (a, b)
      -- already joined by an earlier install this pass: nothing to do
      | let rw = [ (r, l) | (l, r) <- store, size r >= size l ]
      , normal rw a == normal rw b = pure st
      | otherwise = do
          let (small, large) = if size a < size b then (a, b) else (b, a)
          r <- prove (large, small)
          case r of
            Nothing -> do
              putStrLn ("  ✗ " ++ render large ++ "  =  " ++ render small
                        ++ "   (no shape in the prover's reach — stays on the list)")
              pure st
            Just shape -> do
              let store' = store ++ [(small, large)]
                  gap'   = gapOf store'
              if length gap' < length gap
                then do
                  putStrLn ("  ✓ " ++ render large ++ "  =  " ++ render small
                            ++ "   [" ++ shape ++ "]  gap "
                            ++ show (length gap) ++ "→" ++ show (length gap')
                            ++ "  → installed")
                  pure (store', gap', (render small ++ "\t" ++ render large) : acc)
                else do
                  putStrLn ("  ≈ " ++ render large ++ "  =  " ++ render small
                            ++ "   [" ++ shape ++ "]  PROVEN but generative (gap "
                            ++ show (length gap) ++ "→" ++ show (length gap')
                            ++ ") — true, withheld from the store, named for the AC lane")
                  pure st
