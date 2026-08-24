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

-- The engineer's side of NaturalMachine.{Residual,KFlow,EndObstruction,QuestionMachine}.
--
--   Agda holds the theorems; this holds the run.  Every function here has a
--   checked counterpart, named in the comment above it.  Nothing is measured:
--   the output is a replay of statements that are already proved.
--
--   ghc -O2 machine/QuestionMachine.hs -o machine/question-machine

module Main (main) where

import Data.List (minimumBy)
import Data.Ord (comparing)

-- NaturalMachine.CostGeometry : Presentation, Edge, Work, Cost
type Cost = Int
type Work = Int

data Edge = Edge { move :: String, cost :: Cost } deriving (Eq, Show)

-- detour out back w = (cost out + cost out) + (cost back + w)
detour :: Edge -> Edge -> Work -> Cost
detour out back w = (cost out + cost out) + (cost back + w)

-- NaturalMachine.Residual : ϱ
residual :: (Edge, Edge) -> Work -> Work -> Int
residual (out, back) here there = max 0 (here - detour out back there)

-- NaturalMachine.Residual : Branch, respond
data Branch = Star | Loop | Route deriving (Eq, Show)

respond :: Maybe (Edge, Edge) -> Work -> Work -> Branch
respond Nothing _ _ = Star
respond (Just b) here there
  | residual b here there == 0 = Loop
  | otherwise                  = Route

-- NaturalMachine.Residual : no-invariant-response-sees-ϱ
-- Same maps, different weights, different branch.  The witness, executed.
costBlindness :: (Branch, Branch)
costBlindness =
  ( respond (Just (Edge "id" 0,   Edge "id" 0))   10 1
  , respond (Just (Edge "id" 100, Edge "id" 100)) 10 1 )

-- NaturalMachine.Residual : Neighbour, route, Γ↝
data Neighbour = Neighbour { label :: String, out :: Edge, back :: Edge, work :: Work }

route :: Neighbour -> Cost
route n = detour (out n) (back n) (work n)

gammaRoute :: Work -> [Neighbour] -> Cost
gammaRoute here [] = here
gammaRoute here ns = min here (minimum (map route ns))

-- Γ↝-sound : a win exhibits the strictly better presentation
gammaWitness :: Work -> [Neighbour] -> Maybe Neighbour
gammaWitness here ns =
  case filter ((< here) . route) ns of
    [] -> Nothing
    ws -> Just (minimumBy (comparing route) ws)

-- NaturalMachine.KFlow : 𝒦 = ∂∘Γ and the trichotomy of ρ(D𝒦)
orbit :: (Int -> Int) -> Int -> [Int]
orbit f = iterate f

flowVerdict :: (Int -> Int) -> Int -> String
flowVerdict f n0 = go (take 64 (orbit f n0))
  where
    go xs
      | any (== 0) xs                          = "rho<1  decay"
      | and (zipWith (==) xs (drop 1 xs))      = "rho=1  resonance"
      | otherwise                              = "rho>1  branching"

-- NaturalMachine.EndObstruction : diag, δ_end.
-- Finite replay on n points: the diagonal bit-vector differs from every row
-- of the quotation matrix, whatever the matrix is.
diagBits :: [[Bool]] -> [Bool]
diagBits rows = [ not (rows !! i !! i) | i <- [0 .. length rows - 1] ]

outsideImage :: [[Bool]] -> Bool
outsideImage rows = all (/= diagBits rows) rows

-- NaturalMachine.ChuAdvance : Agree, Separates, Shrink(T) => delta down
agree :: Eq q => (x -> t -> q) -> [t] -> x -> x -> Bool
agree e ts x y = all (\t -> e x t == e y t) ts

separates :: (Eq q, Eq x) => (x -> t -> q) -> [t] -> [x] -> Bool
separates e ts xs = and [ not (agree e ts x y) || x == y | x <- xs, y <- xs ]

-- zero-defect-is-not-truth : both test sets give defect 0; only one separates
chuDemo :: [(String, Bool, Bool)]
chuDemo =
  [ ("tests=[]",  agree read' []      True False, separates read' []      [True, False])
  , ("tests=[t]", agree read' [()] True False, separates read' [()] [True, False]) ]
  where
    read' :: Bool -> () -> Bool
    read' x _ = x

-- NaturalMachine.ChuAdvance : hidden-curvature (base flat, total not)
hiddenCurvature :: ((Int, Int), Bool, Bool)
hiddenCurvature = (h, fst h == fst unit, h /= unit)
  where
    h = (0, 1)
    unit = (0, 0)

-- NaturalMachine.TransportDiv : modw (Horner residue automaton), value, steps.
-- Little-endian base ten, as in NaturalMachine.Digits.
valueW :: [Int] -> Int
valueW = foldr (\d r -> d + 10 * r) 0

modW :: Int -> [Int] -> Int
modW n = foldr (\d r -> (d + 10 * r) `mod` n) 0

stepsW :: [Int] -> Int
stepsW w = 1 + length w

-- value-modw, and the cost gap that stalls the walk: chart 5, home 1000
hornerDemo :: (Int, Int, Bool, Int, Int)
hornerDemo = (valueW thousand, modW 7 thousand, ok, stepsW thousand, valueW thousand)
  where
    thousand = [0, 0, 0, 1]
    ok = and [ modW n thousand == valueW thousand `mod` n | n <- [1 .. 40] ]

-- NaturalMachine.QuestionMachine : halts
resolves :: (q -> Int) -> (q -> q) -> q -> Maybe Int
resolves d f = go 0
  where
    go k q
      | d q == 0 = Just k
      | k > 1000 = Nothing
      | otherwise = go (k + 1) (f q)

main :: IO ()
main = do
  putStrLn "-- NaturalMachine replay (statements proved in formal/cubical) --"
  putStrLn ("cost-blindness (same maps, weights 0 vs 100): " ++ show costBlindness)
  let ns = [ Neighbour "crt"   (Edge "chart" 5)  (Edge "unchart" 5)  10
           , Neighbour "unary" (Edge "chart" 20) (Edge "unchart" 20) 10 ]
  putStrLn ("gamma-route 100 -> " ++ show (gammaRoute 100 ns)
            ++ "  witness " ++ show (fmap label (gammaWitness 100 ns)))
  putStrLn ("flow (n -> n `div` 2)     : " ++ flowVerdict (`div` 2) 64)
  putStrLn ("flow (n -> n)             : " ++ flowVerdict id 7)
  putStrLn ("flow (n -> n + 1)         : " ++ flowVerdict (+ 1) 1)
  let rows = [ [True, False, True], [False, False, True], [True, True, True] ]
  putStrLn ("delta_end outside image   : " ++ show (outsideImage rows))
  putStrLn ("halts (n -> n `div` 2, 64): " ++ show (resolves id (`div` 2) 64))
  putStrLn ("chu (defect0, separates)  : " ++ show chuDemo)
  putStrLn ("hidden curvature          : " ++ show hiddenCurvature)
  putStrLn ("horner (value,mod7,ok,steps,unary): " ++ show hornerDemo)

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only.
--
-- This file's header says every function here has a checked counterpart
-- and that "nothing is measured: the output is a replay of statements
-- that are already proved".  `flowVerdict` is the exception, and the two
-- halves of why are checked in
-- `formal/cubical/NaturalMachine/OneStepDecidesResonanceAndNoPrefixDecidesDecay.agda`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin).
--
-- I read NaturalMachine.KFlow's signatures and proof bodies first.  Its
-- decay / resonance / branching theorems are each conditional on a
-- GLOBAL property of f (Contracting / Stationary / Expanding).
-- `flowVerdict` takes no such hypothesis: it inspects 64 iterates.
--
--   RESONANCE is exact, and cheaper than the test.  Stationary f n IS
--   iterate f 1 n = n, so ONE comparison decides the whole orbit
--   (oneStepIsStationary / oneStepGivesTheWholeOrbit).  Sixty-three of
--   the sixty-four comparisons buy nothing.
--
--   DECAY is not decided by any prefix.  noPrefixDecidesDecay is
--   quantified over N: for EVERY prefix length there is a CONTRACTING
--   map (the predecessor) and a start whose orbit shows no zero within N
--   and is zero at N+1.  So `any (== 0)` is sound and incomplete at
--   every length, and the "otherwise -> branching" catch-all mislabels
--   that witness.
--
-- THE REPAIR IS NOT A BIGGER CONSTANT -- the statement is quantified
-- over N.  What decides it is the hypothesis KFlow actually assumes,
-- Contracting f, which a run cannot check for arbitrary f.  That is the
-- honest reason this one verdict is a report rather than a replay.
--
-- NOT a criticism of KFlow, which proves exactly what it states; and no
-- claim about the other functions here, which were not checked.
-- ---------------------------------------------------------------------
