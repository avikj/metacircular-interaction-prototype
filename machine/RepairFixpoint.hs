-- RepairFixpoint — exhaustive certification of the coarsest-repair algorithm.
--
-- THE PROBLEM (notes/LENS_REPAIR.md §5 seed 1, restated verbatim as seed 2
-- of LENS_REPAIR_TWO_AXIS_WITNESS, and named the most delegable open item
-- in WHAT_IS_ACTUALLY_OPEN_across_the_whole_corpus_2026_08_14.md §2):
--
--   Given partitions pi, sigma of a finite X, compute the COARSEST rho
--   that refines pi and commutes with sigma.  LENS_REPAIR proves such a
--   rho is unique, proves local search cannot find it (the repair set is
--   join-closed but not merge-connected), and computes it only by
--   exhaustive enumeration -- exponential in |X|.  Its author: "This is
--   the open question I care about most and I have no evidence either
--   way."
--
-- THE ANSWER: polynomial.  rho commutes with sigma iff the subspace
-- V_rho = span{1_B : B in rho} is P_sigma-invariant, and rho refines pi
-- iff V_rho contains V_pi.  So the coarsest repair is the SMALLEST
-- P_sigma-invariant partition subspace containing V_pi.  Because P_sigma
-- is IDEMPOTENT, the least invariant subspace containing V is V + P_sigma V
-- -- one step, not a series -- and the least partition subspace containing
-- a subspace is its level-set partition.  Alternating two monotone
-- operators inside an |X|-dimensional space reaches a fixpoint in at most
-- |X| rounds.
--
-- Combinatorially it is one refinement rule:
--
--   split each block of rho by  x |-> ( |B & E(x)| / |E(x)| )_{B in rho}
--
-- where E(x) is the sigma-block of x: split by the density profile of your
-- sigma-block over the current blocks.  Repeat until stable.
--
-- TWO THINGS ARE CERTIFIED HERE, and the order matters because the second
-- would be circular without the first.
--
--   CERT 1.  The operator criterion agrees with the combinatorial one.
--            `commutesGrid` is Delta-style proportionality, |B&E|*|C| =
--            |B|*|E| within each block C of the join -- the definition
--            LENS_ORDER_COMMUTATION works with.  `commutesInv` is "one
--            refinement step changes nothing", which is literally
--            P_sigma-invariance of V_rho.  They are checked to agree on
--            every ordered pair.  This is the content of the equivalence
--            the whole proof rests on, verified rather than assumed.
--
--   CERT 2.  The fixpoint equals the true coarsest repair, where "true"
--            means: fold the join over EVERY partition that refines pi and
--            satisfies the grid criterion.  Brute force, no shortcuts.
--
-- All arithmetic is exact (Ratio Integer).  No floating point appears
-- anywhere in this file, and no quantity is fitted, sampled or estimated.
-- The output is a proposition about a finite range, true or false.

module Main (main) where

import Data.List (nub, foldl', sort)
import qualified Data.Map.Strict as M
import Data.Ratio ((%))
import Control.Monad (forM_)
import System.IO
import System.Exit (exitFailure)

-- A partition of [0..n-1] as a restricted growth string: element i carries
-- the index of its block in order of first appearance.  Canonical, so
-- partition equality is list equality.
type Part = [Int]

canon :: Ord a => [a] -> Part
canon xs = map (m M.!) xs
  where m = M.fromList (zip (nub xs) [0 :: Int ..])

partitions :: Int -> [Part]
partitions n = go n
  where
    go 0 = [[]]
    go k = [ p ++ [b] | p <- go (k - 1)
                      , b <- [0 .. (if null p then -1 else maximum p) + 1] ]

blocksOf :: Part -> [[Int]]
blocksOf p = M.elems (M.fromListWith (flip (++)) [ (b, [i]) | (i, b) <- zip [0 :: Int ..] p ])

-- rho refines pi: pi is constant on rho-blocks.
refines :: Part -> Part -> Bool
refines rho pi_ = all same (blocksOf rho)
  where same bs = all (\i -> pi_ !! i == pi_ !! head bs) bs

-- the join: finest partition coarser than both.
join :: Part -> Part -> Part
join a b = canon (zip (rootsOf a b) (repeat (0 :: Int)))
  where
    rootsOf p q =
      let n = length p
          uf0 = M.fromList [ (i, i) | i <- [0 .. n - 1] ]
          rt m i = let j = m M.! i in if j == i then i else rt m j
          stepU m (i, j) = let ri = rt m i; rj = rt m j
                           in if ri == rj then m else M.insert ri rj m
          uf = foldl' stepU uf0
                 [ (i, j) | i <- [0 .. n - 1], j <- [i + 1 .. n - 1]
                          , p !! i == p !! j || q !! i == q !! j ]
      in [ rt uf i | i <- [0 .. n - 1] ]

-- ---------------------------------------------------------------------
-- COMMUTATION, two ways

-- (a) the grid / proportionality criterion, as the corpus states it:
--     for B in rho and E in sigma inside the same join-block C,
--        |B & E| * |C| == |B| * |E|
commutesGrid :: Part -> Part -> Bool
commutesGrid rho sigma =
  and [ ilen (isect b e) * ilen c == ilen b * ilen e
      | b <- blocksOf rho
      , e <- blocksOf sigma
      , let c = blockAt (head b)
      , head e `elem` c ]
  where
    j = join rho sigma
    blockAt i = [ k | k <- [0 .. length j - 1], j !! k == j !! i ]
    isect u v = filter (`elem` v) u
    ilen = toInteger . length

-- (b) P_sigma-invariance of V_rho, which is exactly "the refinement step
--     below is already stable at rho".
commutesInv :: Part -> Part -> Bool
commutesInv rho sigma = refineStep rho sigma == rho

-- ---------------------------------------------------------------------
-- THE REFINEMENT STEP, and the algorithm

-- Split each block of rho by the exact density profile of one's
-- sigma-block over the blocks of rho.
refineStep :: Part -> Part -> Part
refineStep rho sigma = canon (map profile [0 .. n - 1])
  where
    n = length rho
    bs = blocksOf rho
    sigAt i = [ k | k <- [0 .. n - 1], sigma !! k == sigma !! i ]
    density b i = let e = sigAt i
                  in toInteger (length (filter (`elem` b) e)) % toInteger (length e)
    profile i = (rho !! i, [ density b i | b <- bs ])

coarsestRepair :: Part -> Part -> Part
coarsestRepair pi_ sigma = go pi_
  where
    go rho = let rho' = refineStep rho sigma
             in if rho' == rho then rho else go rho'

-- THE CLOSED FORM.  No iteration: one step is already stable, because for
-- B = A & q^-1(c) the function P_sigma 1_B is d_{A,c} * 1_{q^-1(c)}, and
-- q^-1(c) is a union of blocks of that very partition.  So
--
--     rho* = pi  /\  q^-1(~)
--
-- where q(x) is the sigma-block of x and E ~ E' iff |A&E|/|E| = |A&E'|/|E'|
-- for every block A of pi.  Two points survive together iff they share a
-- pi-block AND their sigma-blocks have the same pi-density profile.
closedForm :: Part -> Part -> Part
closedForm pi_ sigma = canon [ (pi_ !! i, profileOf (sigAt i)) | i <- [0 .. n - 1] ]
  where
    n = length pi_
    sigAt i = [ k | k <- [0 .. n - 1], sigma !! k == sigma !! i ]
    profileOf e = [ toInteger (length (filter (`elem` a) e)) % toInteger (length e)
                  | a <- blocksOf pi_ ]

-- SEED 2 of the same note: "Characterize when the meet is minimal.  Which
-- (pi,sigma) have pi ^ sigma as their coarsest repair?  A block-size
-- condition would be ideal."
--
-- The closed form answers it.  rho* = pi /\ sigma exactly when ~ is
-- discrete on sigma-blocks: if E ~ E' with E /= E', any pi-block meeting E
-- has positive density there, hence positive density at E', hence meets E'
-- too -- so the two fuse and rho* is strictly coarser.  Criterion:
--
--   the meet is optimal  <=>  distinct sigma-blocks have distinct
--                             pi-density profiles.
meetIsOptimal :: Part -> Part -> Bool
meetIsOptimal pi_ sigma = length profiles == length (nub profiles)
  where
    n = length pi_
    profiles = [ [ toInteger (length (filter (`elem` a) e)) % toInteger (length e)
                 | a <- blocksOf pi_ ]
               | e <- blocksOf sigma ]

meet :: Part -> Part -> Part
meet a b = canon (zip a b)

-- how many rounds the fixpoint takes, for the bound in the write-up
rounds :: Part -> Part -> Int
rounds pi_ sigma = go pi_ 0
  where
    go rho k = let rho' = refineStep rho sigma
               in if rho' == rho then k else go rho' (k + 1)

-- ---------------------------------------------------------------------
-- the reference answer: join of every repair, by the GRID criterion only

bruteCoarsest :: Part -> Part -> Part
bruteCoarsest pi_ sigma = foldl' join disc reps
  where
    n = length pi_
    disc = [0 .. n - 1]
    reps = [ r | r <- partitions n, refines r pi_, commutesGrid r sigma ]

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering
  putStrLn "RepairFixpoint - exhaustive certification"
  putStrLn ""
  putStrLn "CERT 1: grid criterion == P_sigma-invariance, on every ordered pair"
  c1 <- mapM cert1 [1 .. 7]
  putStrLn ""
  putStrLn "CERT 2: density-profile fixpoint == join of all repairs (brute force)"
  c2 <- mapM cert2 [1 .. 6]
  putStrLn ""
  putStrLn ""
  putStrLn "CERT 3: the CLOSED FORM  rho* = pi /\\ q^-1(~)  equals the fixpoint"
  forM_ [1 .. 7 :: Int] $ \n -> do
    let ps = partitions n
        bad = [ (p, s) | p <- ps, s <- ps, closedForm p s /= coarsestRepair p s ]
    putStrLn ("  n = " ++ show n ++ ": " ++ show (length ps * length ps)
              ++ " pairs, " ++ show (length bad) ++ " disagreements")
  putStrLn ""
  putStrLn "CERT 4: seed 2's criterion, and the note's own 410/1900 count at n = 5"
  forM_ [4, 5, 6 :: Int] $ \n -> do
    let ps = partitions n
        prs = [ (p, s) | p <- ps, s <- ps ]
        noncomm = [ (p, s) | (p, s) <- prs, not (commutesGrid p s) ]
        strictly = [ (p, s) | (p, s) <- noncomm, closedForm p s /= meet p s ]
        crit = [ (p, s) | (p, s) <- prs
               , meetIsOptimal p s /= (closedForm p s == meet p s) ]
    putStrLn ("  n = " ++ show n ++ ": " ++ show (length noncomm)
              ++ " noncommuting ordered pairs, of which " ++ show (length strictly)
              ++ " have rho* strictly coarser than the meet;  criterion mismatches: "
              ++ show (length crit))
  putStrLn ""
  putStrLn "SCAN: how many refinement rounds are actually needed?"
  putStrLn "  (n <= 6 all showed 1.  If that is a theorem it should survive n = 8;"
  putStrLn "   if it is an artifact of small n a witness appears here.)"
  forM_ [7, 8 :: Int] $ \n -> do
    let ps = partitions n
        rs = [ (rounds p s, p, s) | p <- ps, s <- ps ]
        mx = maximum (0 : map (\(k, _, _) -> k) rs)
        wit = take 1 [ (p, s) | (k, p, s) <- rs, k == mx, mx > 1 ]
    putStrLn ("  n = " ++ show n ++ ": max rounds = " ++ show mx
              ++ (if null wit then "" else "  witness: " ++ show wit))
  let f1 = concatMap snd c1
      f2 = concatMap snd c2
  if null f1 && null f2
    then do
      putStrLn ("CERT 1 PASSED on " ++ show (sum (map fst c1)) ++ " ordered pairs (n <= 7).")
      putStrLn ("CERT 2 PASSED on " ++ show (sum (map fst c2)) ++ " ordered pairs (n <= 6).")
      putStrLn "The fixpoint IS the coarsest repair, on every instance in range."
    else do
      putStrLn "FAILURES:"
      forM_ (take 20 f1) print
      forM_ (take 20 f2) print
      exitFailure

cert1 :: Int -> IO (Int, [(Part, Part)])
cert1 n = do
  let ps = partitions n
      bad = [ (r, s) | r <- ps, s <- ps, commutesGrid r s /= commutesInv r s ]
  putStrLn ("  n = " ++ show n ++ ": " ++ show (length ps * length ps)
            ++ " pairs, " ++ show (length bad) ++ " disagreements")
  return (length ps * length ps, bad)

cert2 :: Int -> IO (Int, [(Part, Part, Part, Part)])
cert2 n = do
  let ps = partitions n
      bad = [ (p, s, got, want)
            | p <- ps, s <- ps
            , let got = coarsestRepair p s
            , let want = bruteCoarsest p s
            , got /= want ]
      maxr = maximum (0 : [ rounds p s | p <- ps, s <- ps ])
  putStrLn ("  n = " ++ show n ++ ": " ++ show (length ps * length ps)
            ++ " pairs, " ++ show (length bad) ++ " disagreements"
            ++ ", max rounds to fixpoint = " ++ show maxr)
  return (length ps * length ps, bad)
