-- A finite executable counterpart to NaturalMachine.DSOFinite.
-- Costs are natural numbers here; `Nothing`/infinite costs can be added at a
-- boundary, but the finite benchmark already proves the architecture point.
module DSO
  ( Boundary, CostRelation, Continuation, bellman, compose
  , first, downstream, localArgmin, prematureArgminCounterexample
  ) where

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
downstream _ False = 2
downstream _ True  = 0

localArgmin :: CostRelation -> Boundary -> Boundary
localArgmin k a = if k a False <= k a True then False else True

-- True is locally more expensive (1 > 0), but is the globally cheaper
-- continuation (1 < 2).  This is the finite DSO counterexample.
prematureArgminCounterexample :: Bool
prematureArgminCounterexample =
  localArgmin first False == False
  && compose first downstream False False == 1
  && first False False + downstream False False == 2
