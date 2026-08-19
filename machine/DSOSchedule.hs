-- DSOSchedule: the machine schedules its own work order by Delta 28.
--
-- Delta 28 §39 states that the architecture planner is itself a DSO instance,
-- governed by the meta-Bellman V(D) = min_a ( cost(a|D) + V(D u {a}) ).  This
-- module instantiates that recursion (imported from DSO.hs) on a concrete
-- finite batch — the +/x law family — and MEASURES, with exact integer counts
-- over a fully specified cost model, that the DSO-ordered schedule discharges
-- the same set of conjectures in fewer total rewrite steps than the naive
-- (declaration-order) schedule, and at a lower peak semantic cut width.
--
-- Run: runghc machine/DSOSchedule.hs
--
-- Honesty note (repo protocol).  The per-attempt rewrite costs below are a
-- STIPULATED finite model of how one proved law cheapens another as a rewrite
-- rule; each saving is annotated with the derivation that justifies it.  GIVEN
-- that model, everything reported here is EXACT and exhaustive: the optimum is
-- the min over all 2^n dependency states (memoized Bellman, DSO.hs), the mean
-- and worst case are the exact statistics over all n! orders (enumerated), and
-- the optimum is independently cross-checked against the sum of per-conjecture
-- minima (a lower bound realizable because the enabler relation is a DAG).
-- No number here is fitted or sampled.

module Main (main) where

import DSO
  ( Mask, SchedProblem(..)
  , hasItem, orderCost, optimalSchedule
  , totalSemiring, peakSemiring
  )
import Data.List (permutations, foldl', intercalate, sortBy)
import Data.Ord (comparing)
import Data.Ratio (Ratio, (%), numerator, denominator)

-- ---------------------------------------------------------------------------
-- The +/x law family.
--
-- Eight conjectures over a commutative semiring (Nat with + and x).  Each is
-- provable from scratch by induction (its `base` rewrite-step cost), but once
-- certain earlier laws are available as rewrite rules the proof collapses to a
-- short derivation.  A proved enabler is a compressed cut interface: it lowers
-- the future-distinct dependency modes crossing the proof, hence the cost.

data Conj = Conj
  { cId       :: Int
  , cName     :: String
  , cBase     :: Integer          -- rewrite steps if proved from scratch
  , cEnablers :: [(Int, Integer)] -- (enabler id, steps saved when available)
  }

-- ids
_AC, _AA, _MC, _MA, _DL, _DR, _SQ, _PE :: Int
_AC = 0; _AA = 1; _MC = 2; _MA = 3; _DL = 4; _DR = 5; _SQ = 6; _PE = 7

family :: [Conj]
family =
  [ Conj _AC "addComm     a+b = b+a"                      4  []
    -- base induction; no + / x law helps its own inductive step.

  , Conj _AA "addAssoc    (a+b)+c = a+(b+c)"              4  []
    -- base induction; independent of the others.

  , Conj _MC "mulComm     a*b = b*a"                      6
      [ (_AC, 3) ]
    -- inductive step a*(b+1) = a*b + a must commute a sum: addComm makes it
    -- direct, saving the manual re-derivation.

  , Conj _MA "mulAssoc    (a*b)*c = a*(b*c)"              7
      [ (_DL, 4) ]
    -- step a*(b*(c+1)) = a*(b*c + b): left-distributivity discharges the
    -- expansion in one rewrite instead of an inner induction.

  , Conj _DL "distL       a*(b+c) = a*b + a*c"            8
      [ (_AA, 3) ]
    -- step regroups a three-fold sum; addAssoc supplies the regrouping.

  , Conj _DR "distR       (a+b)*c = a*c + b*c"            8
      [ (_DL, 4), (_MC, 2) ]
    -- distR is distL conjugated by mulComm:
    --   (a+b)*c -MC-> c*(a+b) -DL-> c*a + c*b -MC,MC-> a*c + b*c.
    -- With both DL and MC available it is a 4-rewrite derivation (base 8 - 6),
    -- so proving DL and MC first turns an induction into a rewrite.

  , Conj _SQ "sqExpand    (a+b)*(a+b) = a*a+a*b+a*b+b*b" 12
      [ (_DL, 4), (_DR, 4), (_AA, 1) ]
    -- expand once by DR, twice by DL, regroup by AA.

  , Conj _PE "polyExpand  (a+b)*(c+d) = ac+ad+bc+bd"     16
      [ (_DL, 5), (_DR, 5), (_AA, 2) ]
    -- FOIL: one DR then two DL then AA regrouping; heaviest from scratch,
    -- cheapest downstream node once distributivity is in hand.
  ]

-- cost(a | D): base minus the savings of every enabler already proved in D.
-- Clamped at >= 1 (a discharged conjecture always costs at least one rewrite);
-- the clamp never triggers for this family (all minima are >= 2).
conjCost :: Conj -> Mask -> Integer
conjCost c proved =
  max 1 (cBase c - sum [ s | (e, s) <- cEnablers c, hasItem proved e ])

problem :: SchedProblem
problem = SchedProblem
  { spN    = length family
  , spCost = \i proved -> conjCost (family !! i) proved
  }

nm :: Int -> String
nm i = takeWhile (/= ' ') (cName (family !! i))

showOrder :: [Int] -> String
showOrder = intercalate " -> " . map nm

-- ---------------------------------------------------------------------------
-- Baselines and exact statistics over all orders.

n :: Int
n = length family

allItems :: [Int]
allItems = [0 .. n - 1]

-- the naive order = declaration order (how the batch currently enters the
-- queue: base laws by operator, then the composite identities).
naiveOrder :: [Int]
naiveOrder = allItems

-- exact mean / worst total cost over ALL n! orders (n=8 -> 40320 perms).
orderStats :: (Integer, Integer, Ratio Integer)
orderStats =
  let costs   = [ fst (orderCost totalSemiring problem p) | p <- permutations allItems ]
      cnt     = fromIntegral (length costs) :: Integer
      total   = foldl' (+) 0 costs
      worst   = maximum costs
      best    = minimum costs
  in (best, worst, total % cnt)

-- independent cross-check of the optimum: sum of each conjecture's minimum
-- attainable cost (all enablers available).  Realizable simultaneously because
-- the enabler relation is a DAG, so this lower bound is the true optimum.
sumOfMinima :: Integer
sumOfMinima =
  sum [ conjCost c (foldr (flip setBitI) 0 (map fst (cEnablers c))) | c <- family ]
  where setBitI m i = m + (if hasItem m i then 0 else bit i)
        bit k = 1 * (2 ^ k)

-- ---------------------------------------------------------------------------

hr :: String
hr = replicate 68 '-'

main :: IO ()
main = do
  putStrLn hr
  putStrLn "DSO self-scheduling  (Delta 28 meta-Bellman on the +/x law family)"
  putStrLn hr

  -- Total rewrite steps: min-plus Bellman.
  let (nTot, nSteps) = orderCost totalSemiring problem naiveOrder
      (oTot, oOrd)   = optimalSchedule totalSemiring problem
      (_, oSteps)    = orderCost totalSemiring problem oOrd

  putStrLn "NAIVE schedule (declaration order):"
  putStrLn ("  " ++ showOrder naiveOrder)
  putStrLn ("  per-attempt rewrite steps: " ++ show nSteps)
  putStrLn ("  TOTAL rewrite steps      : " ++ show nTot)
  putStrLn ("  PEAK  cut width          : " ++ show (maximum nSteps))
  putStrLn ""

  putStrLn "DSO schedule (min-plus meta-Bellman optimum V(D)=min_a(cost+V(D'))):"
  putStrLn ("  " ++ showOrder oOrd)
  putStrLn ("  per-attempt rewrite steps: " ++ show oSteps)
  putStrLn ("  TOTAL rewrite steps      : " ++ show oTot)
  putStrLn ("  PEAK  cut width          : " ++ show (maximum oSteps))
  putStrLn ""

  -- Peak semantic cut width: the SAME Bellman under the min-max (bottleneck)
  -- carrier (Delta 28 §2/§9, one formula several semirings).
  let (pkOpt, pkOrd) = optimalSchedule peakSemiring problem
      (nPk, _)       = orderCost peakSemiring problem naiveOrder
  putStrLn "PEAK-width optimum (same Bellman, min-max carrier):"
  putStrLn ("  order            : " ++ showOrder pkOrd)
  putStrLn ("  naive peak width : " ++ show nPk)
  putStrLn ("  DSO   peak width : " ++ show pkOpt)
  putStrLn ""

  -- Exact statistics over the whole permutation group + cross-check.
  let (best, worst, mean) = orderStats
  putStrLn hr
  putStrLn "Exact statistics over ALL 8! = 40320 orders (min-plus total):"
  putStrLn ("  best  (= DSO optimum) : " ++ show best)
  putStrLn ("  worst                 : " ++ show worst)
  putStrLn ("  mean                  : " ++ show (numerator mean)
             ++ "/" ++ show (denominator mean)
             ++ "  (~ " ++ show (fromRational mean :: Double) ++ ")")
  putStrLn ("  cross-check sum-of-minima (DAG lower bound) : " ++ show sumOfMinima)
  putStrLn ""

  -- Verdicts.
  let improveVsNaive = nTot - oTot
      improveVsMean  = mean - (oTot % 1)
  putStrLn hr
  putStrLn "RESULT"
  putStrLn ("  DSO vs naive : " ++ show nTot ++ " -> " ++ show oTot
             ++ "  (" ++ show improveVsNaive ++ " fewer rewrite steps, "
             ++ show (round (100 * (fromIntegral improveVsNaive
                                    / fromIntegral nTot) :: Double) :: Integer)
             ++ "%)")
  putStrLn ("  DSO vs mean  : " ++ show (numerator (mean)) ++ "/"
             ++ show (denominator mean) ++ " -> " ++ show oTot
             ++ "  (~" ++ show (fromRational improveVsMean :: Double)
             ++ " fewer)")
  putStrLn ("  peak width   : " ++ show nPk ++ " -> " ++ show pkOpt)
  putStrLn ""

  -- Certifications (exit non-zero on any failure).
  let checks =
        [ ("optimum equals min over all orders",        oTot == best)
        , ("optimum equals sum-of-minima lower bound",  oTot == sumOfMinima)
        , ("DSO total strictly beats naive",            oTot < nTot)
        , ("DSO peak <= naive peak",                    pkOpt <= nPk)
        , ("DSO order proves the same 8 conjectures",   sortI oOrd == allItems)
        ]
  mapM_ (\(l, ok) -> putStrLn ("  [" ++ (if ok then "ok " else "FAIL")
                                ++ "] " ++ l)) checks
  putStrLn hr
  if all snd checks
    then putStrLn "STATUS: all certifications passed."
    else error "DSO scheduler certification FAILED"
  where
    sortI = sortBy compare
