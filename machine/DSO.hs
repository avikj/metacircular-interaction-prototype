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

-- A finite executable counterpart to NaturalMachine.DSOFinite.
-- Costs are natural numbers here; `Nothing`/infinite costs can be added at a
-- boundary, but the finite benchmark already proves the architecture point.
module DSO
  ( Boundary, CostRelation, Continuation, bellman, compose
  , first, downstream, localArgmin, prematureArgminCounterexample
    -- Delta 28 §39: the architecture planner is itself a DSO instance.
    -- Powerset lift of `bellman` to the meta-Bellman V(D)=min_a(cost+V(D')).
  , Mask, SchedProblem(..)
  , fullMask, hasItem, addItem
  , orderCost, optimalSchedule
  , totalSemiring, peakSemiring
  ) where

import Data.Array (Array, listArray, (!))
import Data.Bits (setBit, testBit, shiftL)
import Data.List (minimumBy, foldl')
import Data.Ord (comparing)

type Boundary = Bool
type CostRelation = Boundary -> Boundary -> Integer
type Continuation = Boundary -> Integer

bellman :: CostRelation -> Continuation -> Boundary -> Integer
bellman k v a = min (k a False + v False) (k a True + v True)

compose :: CostRelation -> CostRelation -> CostRelation
compose k l a c =
  min (k a False + l False c) (k a True + l True c)

first :: CostRelation
first False False = 0
first False True  = 1
first True  _     = 3

downstream :: CostRelation
downstream False _ = 2
downstream True  _ = 0

localArgmin :: CostRelation -> Boundary -> Boundary
localArgmin k a = if k a False <= k a True then False else True

-- True is locally more expensive (1 > 0), but is the globally cheaper
-- continuation (1 < 2).  This is the finite DSO counterexample.
prematureArgminCounterexample :: Bool
prematureArgminCounterexample =
  localArgmin first False == False
  && compose first downstream False False == 1
  && first False False + downstream False False == 2

-- ---------------------------------------------------------------------------
-- Delta 28 §39: DSO applied to its own planner.
--
-- The two-boundary `bellman`/`compose` above optimize a single elimination.
-- The scheduler below lifts the SAME min-plus recursion to the powerset
-- dependency lattice: the "boundary state" is the set of already-proved
-- conjectures (a bitmask), an "action" is which conjecture to attempt next,
-- and the meta-Bellman value is
--
--     V(D) = min_a ( cost(a | D) + V(D u {a}) ),   V(full) = 0.
--
-- `cost(a | D)` is the number of rewrite steps to discharge conjecture `a`
-- when the lemmas in `D` are already available as rewrite rules — a proved
-- enabler is a *compressed interface* across the cut (Delta 28 §14-22), so it
-- lowers the future-distinct dependency modes that must be reconstructed and
-- hence the rewrite cost.  Ordering to minimize the accumulated cost is
-- exactly "attempt the conjectures that maximally cheapen the rest first".
--
-- Semiring-parametric per Delta 28 §2/§9 ("one formula, several semirings"):
--   * (+ , 0)   -> min-plus: minimize TOTAL rewrite steps;
--   * (max, 0)  -> min-max (bottleneck): minimize PEAK semantic cut width.
-- Both are computed by the identical Bellman code, differing only in (x).

type Mask = Int

-- A scheduling problem over `spN` items on the powerset lattice.
-- `spCost i proved` = cost of attempting item i given the proved-set bitmask.
data SchedProblem = SchedProblem
  { spN    :: Int
  , spCost :: Int -> Mask -> Integer
  }

fullMask :: Int -> Mask
fullMask n = (1 `shiftL` n) - 1

hasItem :: Mask -> Int -> Bool
hasItem = testBit

addItem :: Mask -> Int -> Mask
addItem = setBit

-- The tropical carrier: how per-attempt costs accumulate along a schedule.
--   totalSemiring: (+ , 0)  — total rewrite steps.
--   peakSemiring : (max, 0) — peak single-attempt cut width.
totalSemiring, peakSemiring :: (Integer -> Integer -> Integer, Integer)
totalSemiring = ((+), 0)
peakSemiring  = (max, 0)

-- Cost of one fixed schedule (a permutation of [0..n-1]) under a carrier,
-- together with the per-attempt cost trace (each entry is a paid cut width).
orderCost :: (Integer -> Integer -> Integer, Integer)
          -> SchedProblem -> [Int] -> (Integer, [Integer])
orderCost (combine, unit) sp order =
  let (_, total, steps) = foldl' step (0 :: Mask, unit, []) order
      step (m, acc, tr) i =
        let c = spCost sp i m
        in (addItem m i, combine acc c, tr ++ [c])
  in (total, steps)

-- Meta-Bellman optimum over the whole powerset: the certified best schedule.
-- Returns the optimal accumulated cost and a witnessing order.  Memoized over
-- all 2^n masks (a lazy array), so this is an exact exhaustive optimum, not a
-- heuristic — for n items it examines every reachable dependency state.
optimalSchedule :: (Integer -> Integer -> Integer, Integer)
                -> SchedProblem -> (Integer, [Int])
optimalSchedule (combine, unit) sp = memo ! 0
  where
    n    = spN sp
    full = fullMask n
    memo :: Array Mask (Integer, [Int])
    memo = listArray (0, full) [ solve m | m <- [0 .. full] ]
    solve m
      | m == full = (unit, [])
      | otherwise =
          minimumBy (comparing fst)
            [ let c            = spCost sp i m
                  (rest, ord)  = memo ! addItem m i
              in (combine c rest, i : ord)
            | i <- [0 .. n - 1], not (hasItem m i) ]
