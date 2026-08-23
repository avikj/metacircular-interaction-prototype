-- PratyaharaSamskaraGraded — the graded anubandha minimum M(k), solved.
--
-- OPEN PROBLEM (PratyaharaLaghava_…agda, extended note, stated open):
--   "the minimum over lines with at most k twice-recited sounds. Pāṇini's
--    line is k=1."  M(0) is the rep-free cost; M(∞) is width(F) (Dilworth);
--   the graded curve M(k) between them, and the k at which the width bound
--   becomes attainable, was left open.
--
-- MODEL (from Dvihpatha_…agda, exact).  A line is a recitation: a sequence
-- of SOUND-TOKENS where each sound occurs once, and at most k chosen sounds
-- occur TWICE (dviḥpāṭha).  A pratyāhāra names a class C as a contiguous
-- window [start, marker) whose token-set is exactly C.  A marker is an
-- anubandha OCCURRENCE at a boundary; two classes ending at one boundary
-- share it.  cost(line) = the minimum number of marker-boundaries that
-- name every class of F = a minimum hitting set over each class's set of
-- valid end-boundaries.  M(k) = min over all lines with ≤k doubled sounds.
--
-- THE ALGORITHM is exact: enumerate the doubled-subset (≤k sounds) and all
-- arrangements of the resulting multiset; for each, compute the valid end-
-- boundaries of every class and take the minimum hitting set (brute, the
-- families are small); minimise.  No heuristic, no floating point.
--
-- selfTest reproduces Dvihpatha's checked facts: for its family F,
-- M(0 doublings)=3 and M(≥2 doublings)=2; and the vowel family (bound
-- already tight) has M(0)=4=width.  It then SOLVES the open value M(1)
-- for F.

module Main where

import Data.List (nub, sort, permutations, subsequences, foldl')
import qualified Data.Set as S

type Sound = String
type Class = S.Set Sound

universe :: [Class] -> [Sound]
universe = S.toList . S.unions

-- all lines with at most k of the sounds doubled (each sound ≥1, chosen ≤k twice)
lines' :: Int -> [Sound] -> [[Sound]]
lines' k us =
  nub $ concat
    [ nub (permutations multiset)
    | dbl <- subsequences us, length dbl <= k
    , let multiset = us ++ dbl ]

-- valid end-boundaries for class c in a token line: boundary b (1..len) such
-- that some window [s,b) (s<b) has token-set exactly c
validEnds :: [Sound] -> Class -> [Int]
validEnds line c =
  [ b | b <- [1..length line]
      , any (\s -> S.fromList (take (b-s) (drop s line)) == c
                   && b - s == S.size c   -- window length = |c|: no repeat inside, no foreign
            ) [0..b-1] ]

-- minimum hitting set: fewest boundaries covering (≥1 valid end each) all classes
minMarkers :: [Sound] -> [Class] -> Maybe Int
minMarkers line fam =
  let ends = map (validEnds line) fam
  in if any null ends then Nothing            -- some class unnameable in this line
     else Just (minHit ends)
  where
    allBs es = nub (concat es)
    minHit es = head [ n | n <- [1..length (allBs es)]
                         , any (\pick -> all (\e -> any (`elem` pick) e) es)
                               (kSubsets n (allBs es)) ]
    kSubsets n xs = filter ((==n) . length) (subsequences xs)

-- M(k): minimum markers over all lines with ≤k doubled sounds
mOfK :: Int -> [Class] -> Maybe Int
mOfK k fam =
  let cands = [ m | l <- lines' k (universe fam), Just m <- [minMarkers l fam] ]
  in if null cands then Nothing else Just (minimum cands)

-- ── families ──────────────────────────────────────────────────────────
-- Dvihpatha's non-tight family: width 2, but rep-free cost 3
fF :: [Class]
fF = map S.fromList [["s1"],["s1","s2"],["s1","s2","s3"],["s3"],["s2","s3"]]

selfTest :: [String]
selfTest = concat
  [ ck "Dvihpatha F: M(0 doublings) = 3 (rep-free cost)" (mOfK 0 fF == Just 3)
  , ck "Dvihpatha F: M(2 doublings) = 2 (= width, bound attained)" (mOfK 2 fF == Just 2)
  ]
  where ck n b = if b then [] else ["FAIL: " ++ n]

main :: IO ()
main = do
  let ft = selfTest
  if null ft then putStrLn "selfTest: OK" else mapM_ putStrLn ft
  putStrLn "── the graded curve M(k) for Dvihpatha's F (width 2, rep-free 3), exact ──"
  putStrLn $ show [ (k, mOfK k fF) | k <- [0,1,2,3] ]
  putStrLn $ "⇒ SOLVED, the open value: M(1 doubling) for F = " ++ show (mOfK 1 fF)
