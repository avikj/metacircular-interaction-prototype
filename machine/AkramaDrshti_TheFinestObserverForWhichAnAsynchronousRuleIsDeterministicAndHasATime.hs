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

-- अक्रम-दृष्टिः — the view under non-succession.
--
-- क्रम (krama) is succession; अक्रम its absence.  Akalaṅka, *Laghīyastraya*
-- (c. 720–780), sets krama (assertion in succession) against saha/yugapat
-- (assertion at once), and the corpus already carries that distinction in
-- `machine/Asiddhavat_...` and `formal/cubical/Saptabhangi.agda`.  The
-- compound is built here.  Nothing is attributed to those texts.
--
-- THE OBJECT.  An elementary rule applied ASYNCHRONOUSLY: at each step
-- exactly one cell is updated, and any cell may be the one.  A state
-- therefore has up to w successors, the system is a multiway system, and it
-- is in general NOT confluent — two update orders reach different states and
-- never come back together.  This is the standard hard case, and the usual
-- move is to assume confluence (in the computational-physics reading, causal
-- invariance) so the history does not depend on the order.
--
-- WHAT IS COMPUTED HERE INSTEAD.  `formal/cubical/EkaVakyata_...`
-- (--cubical --safe, exit 0) proves that confluence is not needed:
--
--     if the observer cannot see WHICH branch was taken — same reading in,
--     same reading out, whichever successor — then any two runs of the same
--     length from equally-read starts are equally read at every step.  The
--     observer has a deterministic law AND a well-defined time, inside a rule
--     that branches without limit.  No confluence hypothesis appears.
--
-- So the question stops being "is this rule causally invariant" and becomes
-- "what is the FINEST observer for which it is" — the most an observer may
-- resolve and still see one world.  That is what this computes, exactly, for
-- every state:
--
--     the least congruence identifying every pair of co-successors,
--     closed under the multiway step.
--
-- which is `formal/cubical/Vyapti_...`'s closure with the co-successor pairs
-- as its seed, and union-find with a worklist is that proof compiled.  If it
-- collapses to one class, the rule admits NO nontrivial frame at all: every
-- observer that can distinguish anything can see the branching.  If it does
-- not, its blocks ARE the frame, and the induced law on them is printed.
--
-- Every number is exhaustive over all 2^w states.  Nothing is sampled.
--
-- Run:
--   runghc machine/AkramaDrshti_TheFinestObserverForWhichAnAsynchronousRuleIsDeterministicAndHasATime.hs 110 6
--   runghc machine/AkramaDrshti_...hs sweep 5
module Main (main) where

import System.Environment (getArgs)
import System.IO (hSetEncoding, stdout, utf8)
import Data.Bits (testBit, xor, shiftL)
import Data.List (nub, intercalate, sortOn)
import qualified Data.Map.Strict as M
import qualified Data.Set as S

type St = Int

-- ------------------------------------------------------------ the multiway
-- update exactly one cell, any cell: a state has up to w successors.
succsOf :: Int -> Int -> St -> [St]
succsOf r w x = nub [ upd i | i <- [0 .. w-1] ]
  where
    at i = testBit x ((i + w) `mod` w)
    upd i =
      let a = at (i-1); b = at i; c = at (i+1)
          k = (if a then 4 else 0) + (if b then 2 else 0) + (if c then 1 else 0)
          new = testBit r k
      in if new == b then x else x `xor` (1 `shiftL` i)

-- --------------------------------------------- व्याप्तिः, on co-successors
-- The least congruence identifying every pair of co-successors and closed
-- under the step.  Union-find with a worklist; when two states are merged,
-- their successor-representatives are enqueued, because the observer must not
-- be able to tell those apart either.
finestFrame :: (St -> [St]) -> Int -> [Int]
finestFrame sc n = normalise (go start seeds)
  where
    start = M.fromList [ (i,i) | i <- [0 .. n-1] ]
    -- every state's own successors must be indistinguishable from each other
    seeds = concat [ zip ss (drop 1 ss) | i <- [0 .. n-1], let ss = sc i
                   , not (null ss) ]
    root m i = if m M.! i == i then i else root m (m M.! i)
    rep m i = case sc i of (s:_) -> Just (root m s); [] -> Nothing
    go m [] = [ root m i | i <- [0 .. n-1] ]
    go m ((x,y):q) =
      let rx = root m x; ry = root m y
      in if rx == ry then go m q
         else
           let m' = M.insert rx ry m
               nxt = case (rep m' x, rep m' y) of
                       (Just a, Just b) -> [(a,b)]
                       _                -> []
           in go m' (nxt ++ q)

normalise :: Ord a => [a] -> [Int]
normalise xs = map (ren M.!) xs
  where ren = M.fromList (zip (nub xs) [0 ..])

blocks :: [Int] -> Int
blocks p = length (nub p)

-- the induced law: on the frame, one step is a function, and this is it
inducedLaw :: (St -> [St]) -> Int -> [Int] -> [(Int, Int)]
inducedLaw sc n p =
  nub [ (p !! i, p !! s) | i <- [0 .. n-1], s <- sc i ]

-- how badly the rule branches, for contrast
branchWidth :: (St -> [St]) -> Int -> Int
branchWidth sc n = maximum [ length (sc i) | i <- [0 .. n-1] ]

confluentIn1 :: (St -> [St]) -> Int -> Bool
confluentIn1 sc n = and [ length (nub (sc i)) <= 1 | i <- [0 .. n-1] ]

-- ---------------------------------------------------------------- display
row :: Int -> St -> String
row w x = [ if testBit x i then '█' else '·' | i <- [0 .. w-1] ]

detail :: Int -> Int -> IO ()
detail r w = do
  let n  = 2 ^ w
      sc = succsOf r w
      p  = finestFrame sc n
      b  = blocks p
  putStrLn ("rule " ++ show r ++ " applied ASYNCHRONOUSLY, width " ++ show w
            ++ ", " ++ show n ++ " states.\n")
  putStrLn ("  branching: up to " ++ show (branchWidth sc n)
            ++ " successors per state"
            ++ (if confluentIn1 sc n then "  (deterministic — no branching)" else ""))
  putStrLn ""
  if b == 1
    then do
      putStrLn "  THE FINEST FRAME IS TRIVIAL — one class."
      putStrLn "  Every observer that can distinguish any two states at all can see"
      putStrLn "  the branching.  This rule admits no observer for whom it is one"
      putStrLn "  world, and by अभाव्यम् no reading-level law exists for any of them."
    else do
      putStrLn ("  THE FINEST FRAME: " ++ show b ++ " classes, "
                ++ show (ceilLog2 b) ++ " bit(s).")
      putStrLn  "  This is the most an observer may resolve and still see ONE world:"
      putStrLn  "  a deterministic law and a well-defined time, with no confluence."
      putStrLn ("    law on the frame: " ++ showLaw (inducedLaw sc n p))
      putStrLn ("    class sizes: " ++ showSizes p)
      putStrLn ("    e.g. these are one class: " ++ sample w p)
  where
    ceilLog2 k = head [ e | e <- [0 :: Int ..], 2 ^ e >= k ]
    showLaw ps
      | length ps > 12 = intercalate " " [ show a ++ "→" ++ show c | (a,c) <- take 12 ps ] ++ " …"
      | otherwise      = intercalate " " [ show a ++ "→" ++ show c | (a,c) <- ps ]
    showSizes p =
      let cs = [ length [ () | q <- p, q == c ] | c <- [0 .. blocks p - 1] ]
      in intercalate ", " (map show (take 12 (sortOn negate cs)))
         ++ (if blocks p > 12 then ", …" else "")
    sample w' p =
      let n = length p
          c0 = head [ c | c <- [0 .. blocks p - 1]
                    , length [ () | q <- p, q == c ] > 1 ]
          mem = take 4 [ i | i <- [0 .. n-1], p !! i == c0 ]
      in intercalate " ≡ " (map (row w') mem) ++ " …"

sweep :: Int -> IO ()
sweep w = do
  let n = 2 ^ w
  putStrLn ("all 256 elementary rules, applied asynchronously at width "
            ++ show w ++ " (" ++ show n ++ " states).")
  putStrLn  "For each: the finest observer for which the multiway system is one"
  putStrLn  "deterministic world.  1 class means no such observer exists.\n"
  putStrLn  "  frame size   rules"
  let rows = [ (blocks (finestFrame (succsOf r w) n), r) | r <- [0 .. 255] ]
      grps = [ (b, [ r | (b', r) <- rows, b' == b ]) | b <- nub (map fst rows) ]
  mapM_ (\(b, rs) ->
           putStrLn ("  " ++ pad 12 (show b) ++ show (length rs) ++ " rules   "
                     ++ shortly rs))
        (sortOn fst grps)
  putStrLn "\n  exhaustive over every state, for every rule.  No sampling, and no"
  putStrLn "  confluence assumed anywhere."
  where
    pad k s = s ++ replicate (k - length s) ' '
    shortly rs | length rs > 12 = intercalate "," (map show (take 12 rs)) ++ ",…"
               | otherwise      = intercalate "," (map show rs)

main :: IO ()
main = do
  hSetEncoding stdout utf8
  as <- getArgs
  putStrLn "अक्रम-दृष्टिः — the finest observer for which an asynchronous rule is one world.\n"
  case as of
    ("motion":w:_)  -> motion (read w)
    ("tower":r:w:_) -> showTower (read r) (read w)
    ("tower":r:_)   -> showTower (read r) 5
    ("sweep":w:_) -> sweep (read w)
    ("sweep":_)   -> sweep 5
    (r:w:_)       -> detail (read r) (read w)
    (r:_)         -> detail (read r) 6
    []            -> detail 110 6 >> putStrLn "" >> sweep 5
  putStrLn "\n(the theorem: formal/cubical/EkaVakyata_CausalInvarianceIsNotNeeded\
           \AndABranchBlindCongruenceGivesTheObserverATimeAndALaw.agda\n \
           \ the closure it compiles: formal/cubical/Vyapti_...agda)"

-- ---------------------------------------------------------------- the tower
-- A frame is a rung, not a number.  `formal/cubical/EkaVakyata_...`'s स्तरः
-- says a coarsening h ∘ o of a branch-blind observer stays branch-blind when
-- h is a congruence for the predictor g — and g is a FUNCTION.  So every
-- world this branching rule can present is a congruence of the single
-- DETERMINISTIC system living on its finest frame, and the whole tower is
-- that system's congruence lattice.
--
-- Computed as: all congruences generated by one pair, then closed under join,
-- which is the lattice they generate.

inducedStep :: (St -> [St]) -> Int -> [Int] -> Int -> Int
inducedStep sc n p b = head [ p !! s | i <- [0 .. n-1], p !! i == b, s <- sc i ]

-- least congruence of a deterministic map on m points containing a seed set
closeOn :: (Int -> Int) -> Int -> [(Int,Int)] -> [Int]
closeOn f m sds = normalise (go (M.fromList [ (i,i) | i <- [0 .. m-1] ]) sds)
  where
    root mm i = if mm M.! i == i then i else root mm (mm M.! i)
    go mm [] = [ root mm i | i <- [0 .. m-1] ]
    go mm ((x,y):q) =
      let rx = root mm x; ry = root mm y
      in if rx == ry then go mm q
         else go (M.insert rx ry mm) ((f x, f y) : q)

pairsOf :: [Int] -> [(Int,Int)]
pairsOf p = [ (i,j) | i <- [0 .. length p - 1], j <- [i+1 .. length p - 1]
            , p !! i == p !! j ]

joinC :: (Int -> Int) -> Int -> [Int] -> [Int] -> [Int]
joinC f m a b = closeOn f m (pairsOf a ++ pairsOf b)
-- A MAXIMAL CHAIN of frames, from the finest to the blind one.  Enumerating
-- the whole congruence lattice is exponential in general and was tried and
-- abandoned; a chain is what "the tower of worlds" actually means and it is
-- computed in m² closures.  At each rung, coarsen by the SMALLEST possible
-- step — the identification that loses the least — so the chain descends as
-- slowly as the rule allows.  Greedy, so this is A maximal chain and not the
-- only one; that is said rather than hidden.
chain :: (Int -> Int) -> Int -> [[Int]]
chain f m = go (normalise [0 .. m-1])
  where
    memo = [ f i | i <- [0 .. m-1] ]
    f2 i = memo !! i
    go p
      | blocks p <= 1 = [p]
      | otherwise =
          let nxts = [ closeOn f2 m (pairsOf p ++ [(a,b)])
                     | a <- [0 .. m-1], b <- [a+1 .. m-1], p !! a /= p !! b ]
              best = head (sortOn (negate . blocks)
                            [ q | q <- nxts, blocks q < blocks p ])
          in p : go best


showTower :: Int -> Int -> IO ()
showTower r w = do
  let n  = 2 ^ w
      sc = succsOf r w
      p  = finestFrame sc n
      m  = blocks p
      f  = inducedStep sc n p
  putStrLn ("rule " ++ show r ++ " asynchronous, width " ++ show w ++ ".")
  putStrLn ("  finest frame: " ++ show m ++ " classes; the deterministic system")
  putStrLn  "  living on it is what every coarser world is a congruence of.\n"
  if m <= 1
    then putStrLn "  nothing to climb: the finest frame is already trivial."
    else do
      let rungs = chain f m
      putStrLn ("  A MAXIMAL TOWER: " ++ show (length rungs)
                ++ " nested worlds, finest to blind.")
      putStrLn  "  (rung = classes an observer resolves; bits = its cost)"
      mapM_ (rung f m) rungs
  where
    rung f m q = do
      let b = blocks q
          lawq = nub [ (q !! i, q !! f i) | i <- [0 .. m-1] ]
          fixed = length [ () | (a,c) <- lawq, a == c ]
      putStrLn ("    " ++ pad 5 (show b) ++ "classes  "
                ++ pad 4 (show (ceilLog2 b) ++ "b")
                ++ "  fixed points: " ++ pad 4 (show fixed)
                ++ "  " ++ (if b == 1 then "(sees nothing)"
                            else if b == m then "(the finest frame itself)"
                            else ""))
    pad k s = s ++ replicate (k - length s) ' '
    ceilLog2 k = head [ e | e <- [0 :: Int ..], 2 ^ e >= k ]

-- ---------------------------------------------------------------- motion
-- Every rule looked at by hand showed the same thing: on its finest frame,
-- almost every class is FIXED by the induced law.  That is a claim about the
-- whole rule space and it is cheap to settle exhaustively, so it is settled
-- rather than asserted: for each rule, how many classes of its finest frame
-- actually move.
motionOf :: Int -> Int -> (Int, Int)
motionOf r w =
  let n  = 2 ^ w
      sc = succsOf r w
      p  = finestFrame sc n
      m  = blocks p
      f  = inducedStep sc n p
  in (m, length [ () | b <- [0 .. m-1], f b /= b ])

motion :: Int -> IO ()
motion w = do
  putStrLn ("all 256 elementary rules asynchronous at width " ++ show w
            ++ ": on the finest frame,")
  putStrLn  "how many of its classes are actually MOVED by the induced law.\n"
  let rs = [ (r, motionOf r w) | r <- [0 .. 255] ]
      byMove = [ (mv, [ r | (r,(_,mv')) <- rs, mv' == mv ]) | mv <- nub [ mv | (_,(_,mv)) <- rs ] ]
  putStrLn "  moving classes   rules"
  mapM_ (\(mv, xs) -> putStrLn ("  " ++ pad 17 (show mv) ++ show (length xs)
                                ++ " rules   " ++ shortly xs))
        (sortOn fst byMove)
  putStrLn ""
  putStrLn ("  largest frame with any motion at all: "
            ++ show (maximum (0 : [ m | (_,(m,mv)) <- rs, mv > 0 ])))
  putStrLn ("  largest number of moving classes anywhere: "
            ++ show (maximum [ mv | (_,(_,mv)) <- rs ]))
  where
    pad k s = s ++ replicate (k - length s) ' '
    shortly xs | length xs > 10 = intercalate "," (map show (take 10 xs)) ++ ",…"
               | otherwise      = intercalate "," (map show xs)
