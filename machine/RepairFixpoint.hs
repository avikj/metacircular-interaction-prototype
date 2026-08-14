-- RepairFixpoint — exhaustive certification of the coarsest-repair algorithm.
--
-- THE PROBLEM (notes/LENS_REPAIR.md §5 seed 1, restated in
-- LENS_REPAIR_TWO_AXIS_WITNESS seed 2, and listed as the most delegable
-- open item in the corpus-wide sweep of 2026-08-14):
--
--   Given partitions pi, sigma of a finite X, compute the COARSEST rho
--   that refines pi and commutes with sigma.  The note proves such a rho
--   is unique, proves local search cannot find it, and computes it only
--   by exhaustive enumeration -- exponential in |X|.  Its author: "This
--   is the open question I care about most and I have no evidence either
--   way."
--
-- THE ANSWER: polynomial.  rho commutes with sigma iff the subspace
-- V_rho = span{1_B : B in rho} is P_sigma-invariant; rho refines pi iff
-- V_rho contains V_pi.  So the coarsest repair is the SMALLEST
-- P_sigma-invariant partition subspace containing V_pi, and because
-- P_sigma is idempotent the least invariant subspace containing V is
-- just V + P_sigma V -- one step, not a series.  Alternating that with
-- "least partition subspace containing V" (its level-set partition)
-- gives a monotone fixpoint reached in at most |X| rounds.
--
-- Combinatorially the whole thing collapses to one refinement rule:
--
--   split each block of rho by  x |-> ( |B & E(x)| / |E(x)| )_{B in rho}
--
-- where E(x) is the sigma-block of x.  Split by the density profile of
-- your sigma-block over the current blocks; repeat until stable.
--
-- THIS FILE is the certificate.  It enumerates ALL ordered pairs of
-- partitions of an n-set for n <= 7 and checks, for every pair, that the
-- fixpoint equals the true coarsest repair found by brute-force search
-- over all partitions.  That is exact finite verification, not a
-- measurement: it produces a proposition, and the proposition is either
-- true of every pair in range or it is false and prints a witness.
--
-- All arithmetic is exact (Ratio Integer).  No floating point appears.

module Main (main) where

import Data.List (sort, sortOn, nub, foldl')
import qualified Data.Map.Strict as M
import Data.Ratio (Ratio, (%))
import Control.Monad (forM_, when)
import System.Exit (exitFailure)

-- A partition of [0..n-1] is a canonical labelling: element i gets the
-- index of its block in order of first appearance ("restricted growth
-- string").  Two partitions are equal iff their strings are equal, which
-- is what makes the exhaustive comparison exact and cheap.
type Part = [Int]

canon :: Ord a => [a] -> Part
canon xs = map (m M.!) xs
  where m = M.fromList (zip (nub xs) [0 ..])

-- all partitions of an n-set, as restricted growth strings
partitions :: Int -> [Part]
partitions n = go n
  where
    go 0 = [[]]
    go k = [ p ++ [b] | p <- go (k - 1)
                      , b <- [0 .. (if null p then -1 else maximum p) + 1] ]

blocksOf :: Part -> [[Int]]
blocksOf p = M.elems (M.fromListWith (flip (++)) [ (b, [i]) | (i, b) <- zip [0 ..] p ])

-- rho refines pi: every rho-block sits inside a pi-block, i.e. pi is
-- constant on rho-blocks.
refines :: Part -> Part -> Bool
refines rho pi_ = all sameBlock (blocksOf rho)
  where sameBlock bs = all (== pi_ !! head bs) (map (pi_ !!) bs)

-- the join: finest partition coarser than both.  Union-find over the two.
join :: Part -> Part -> Part
join a b = canon (map find [0 .. n - 1])
  where
    n = length a
    -- merge i with the first j sharing a block in either partition
    parent0 = M.fromList [ (i, i) | i <- [0 .. n - 1] ]
    par = foldl' step parent0 [ (i, j) | i <- [0 .. n - 1], j <- [i + 1 .. n - 1]
                              , a !! i == a !! j || b !! i == b !! j ]
    step m (i, j) =
      let ri = root m i ; rj = root m j
      in if ri == rj then m else M.insert ri rj m
    root m i = let p = m M.! i in if p == i then i else root m p
    find i = root par i

-- COMMUTATION, stated exactly as the combinatorial criterion:
-- for blocks B of rho and E of sigma inside the same join-block C,
--     |B & E| * |C|  ==  |B| * |E|.
commutes :: Part -> Part -> Bool
commutes rho sigma =
  and [ len (isect b e) * len c == len b * len e
      | b <- blocksOf rho
      , e <- blocksOf sigma
      , let c = joinBlockOf (head b)
      , head e `elem` c ]
  where
    j = join rho sigma
    joinBlockOf i = [ k | k <- [0 .. length j - 1], j !! k == j !! i ]
    isect u v = filter (`elem` v) u
    len = toInteger . length

-- THE ALGORITHM.  One refinement rule, iterated to a fixpoint.
--
--   split each block of rho by the density profile of one's sigma-block
--   over the current blocks of rho.
--
-- Densities are exact rationals: |B & E(x)| / |E(x)|.
coarsestRepair :: Part -> Part -> Part
coarsestRepair pi_ sigma = go pi_
  where
    n = length pi_
    sigBlockOf = M.fromList [ (i, [ k | k <- [0 .. n - 1], sigma !! k == sigma !! i ])
                            | i <- [0 .. n - 1] ]
    go rho =
      let bs = blocksOf rho
          density b i = let e = sigBlockOf M.! i
                        in toInteger (length (filter (`elem` b) e)) % toInteger (length e)
          profile i = (rho !! i, [ density b i | b <- bs ])
          rho' = canon (map profile [0 .. n - 1])
      in if rho' == rho then rho else go rho'

-- the honest reference implementation: search every partition
bruteCoarsest :: Part -> Part -> Part
bruteCoarsest pi_ sigma =
  head (sortOn (length . blocksOf)
         [ r | r <- partitions (length pi_)
             , refines r pi_, commutes r sigma
             , all (\r' -> not (refines r' pi_ && commutes r' sigma)
                           || refines r' r) allRepairs ])
  where
    allRepairs = [ r | r <- partitions (length pi_)
                     , refines r pi_, commutes r sigma ]

-- `bruteCoarsest` above is quadratic in the number of partitions; the
-- cheaper equivalent, given that the repair set is join-closed and so has
-- a unique maximum, is to fold the join over every repair.
bruteCoarsest' :: Part -> Part -> Part
bruteCoarsest' pi_ sigma = foldl' join disc reps
  where
    n = length pi_
    disc = [0 .. n - 1]
    reps = [ r | r <- partitions n, refines r pi_, commutes r sigma ]

main :: IO ()
main = do
  putStrLn "RepairFixpoint — exhaustive certification"
  putStrLn "  claim: the density-profile fixpoint equals the coarsest repair,"
  putStrLn "         for EVERY ordered pair of partitions of an n-set."
  putStrLn ""
  bad <- mapM checkN [1 .. 7]
  let total = sum (map fst bad)
      fails = concatMap snd bad
  putStrLn ""
  if null fails
    then putStrLn ("ALL " ++ show total ++ " ORDERED PAIRS AGREE.  n = 1..7.")
    else do
      putStrLn ("FAILURES (" ++ show (length fails) ++ "):")
      forM_ (take 20 fails) print
      exitFailure

checkN :: Int -> IO (Int, [(Part, Part, Part, Part)])
checkN n = do
  let ps = partitions n
      cases = [ (p, s) | p <- ps, s <- ps ]
      results = [ (p, s, got, want)
                | (p, s) <- cases
                , let got = coarsestRepair p s
                , let want = bruteCoarsest' p s
                , got /= want ]
  putStrLn ("  n = " ++ show n ++ ":  " ++ show (length cases)
            ++ " ordered pairs, " ++ show (length results) ++ " disagreements")
  return (length cases, results)
