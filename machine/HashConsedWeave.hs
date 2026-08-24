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

{-# LANGUAGE BangPatterns #-}
module Main (main) where

import Control.Exception (evaluate)
import Data.IntMap.Strict (IntMap)
import qualified Data.IntMap.Strict as IM
import Data.List (sort)
import qualified Data.Map.Strict as M
import System.CPUTime (getCPUTime)
import Text.Printf (printf)

data Tm = Z | S Tm | A Tm Tm
data Key = KZ | KS !Int | KA !Int !Int deriving (Eq, Ord)
data Node = NZ | NS !Int | NA !Int !Int
type Heap = IntMap Node

-- Tree normalization deliberately models the old presentation boundary:
-- identical subterms are independent occurrences and are normalized again.
normTree :: Tm -> Int
normTree Z = 0
normTree (S t) = 1 + normTree t
normTree (A l r) = normTree l + normTree r

-- Interning is construction-time sharing.  Equal constructor keys receive
-- exactly one node id; the benchmark does not include an unproved digest.
intern :: Key -> (M.Map Key Int, Heap) -> ((M.Map Key Int, Heap), Int)
intern k st@(tab, heap) = case M.lookup k tab of
  Just i -> (st, i)
  Nothing -> let !i = IM.size heap
                 !n = case k of KZ -> NZ; KS x -> NS x; KA x y -> NA x y
             in ((M.insert k i tab, IM.insert i n heap), i)

sharedTower :: Int -> (Heap, Int)
sharedTower depth = let
  (st0, z) = intern KZ (M.empty, IM.empty)
  (st1, one) = intern (KS z) st0
  go 0 st x = (snd st, x)
  go n st x = let (st', y) = intern (KA x x) st in go (n - 1) st' y
  in go depth st1 one

sharedTowerChanged :: Int -> (Heap, Int)
sharedTowerChanged depth = let
  (st0, z) = intern KZ (M.empty, IM.empty)
  (st1, one) = intern (KS z) st0
  (st2, two) = intern (KS one) st1
  go 0 st x = (snd st, x)
  go n st x = let (st', y) = intern (KA x x) st in go (n - 1) st' y
  in go depth st2 two

treeTower :: Int -> Tm
treeTower 0 = S Z
treeTower n = let t = treeTower (n - 1) in A t t

-- Each reachable dependency is normalized once.  The memo is the precise
-- dependency-cone cache; no rooted view is traversed or materialized.
{-# NOINLINE normDAG #-}
normDAG :: Int -> Heap -> Int -> (Int, Int)
normDAG salt heap root = let (v, memo) = go IM.empty root
                         in (v + salt - salt, IM.size memo) where
  go memo i = case IM.lookup i memo of
    Just v -> (v, memo)
    Nothing -> case heap IM.! i of
      NZ -> (0, IM.insert i 0 memo)
      NS x -> let (v, m) = go memo x; !w = v + 1 in (w, IM.insert i w m)
      NA x y -> let (vx, m1) = go memo x
                    (vy, m2) = go m1 y
                    !w = vx + vy
                in (w, IM.insert i w m2)

time :: IO a -> IO (a, Double)
time action = do
  a <- getCPUTime
  x <- action
  b <- getCPUTime
  pure (x, fromIntegral (b - a) / 1.0e9) -- milliseconds

median :: [Double] -> Double
median xs = sort xs !! (length xs `div` 2)

main :: IO ()
main = do
  let depth = 25
      tree = treeTower depth
      (heap, root) = sharedTower depth
  (treeValue, ts) <- time $ evaluate (normTree tree)
  samples <- sequence [snd <$> time
    (let (h, r) = sharedTower (depth + i - i) in evaluate (fst (normDAG i h r)))
    | i <- [1.. nine]]
  let td = median samples
      speedup = ts / td
      occurrences = 3 * (2 :: Integer) ^ depth - 1
  printf "depth=%d tree-occurrences=%d dag-nodes=%d\n" depth occurrences (IM.size heap)
  printf "tree-normalize-ms=%.3f dag-normalize-median-ms=%.6f speedup=%.1fx\n" ts td speedup
  let (dagValue, visited) = normDAG 0 heap root
  if treeValue /= dagValue then fail "normal forms disagree" else pure ()
  if visited /= IM.size heap then fail "dependency cone was not visited exactly once" else pure ()
  let (changedHeap, changedRoot) = sharedTowerChanged depth
      (changedValue, changedVisited) = normDAG 0 changedHeap changedRoot
  if changedValue /= 2 * dagValue then fail "changed-leaf control did not propagate" else pure ()
  if changedVisited /= IM.size changedHeap then fail "changed dependency cone violated once-only traversal" else pure ()
  where nine = 9 :: Int
