-- द्रष्टा — the seer.  Patañjali, *Yogasūtra* 1.3, तदा द्रष्टुः स्वरूपेऽवस्थानम्
-- (~2nd c. BCE – 4th c. CE), where draṣṭṛ is the one that observes as opposed
-- to what is observed.  The word is taken for what it names.  Nothing here is
-- attributed to the sūtra.
--
-- WHAT THIS IS.  An elementary cellular automaton — the simplest interesting
-- rule there is — with a layer on top that nobody usually puts there:
--
--     for each observer, DECIDE whether it sees a law, and say which.
--
-- The decision is exact.  Width w is small, the state space is all 2^w rows,
-- and the check is a finite exhaustive verification over every state — a
-- certificate, not a sample.  The theorem behind it is checked in
--
--     formal/cubical/Anuvrtti_AnObserverSeesALawExactlyWhenItsClassIsA
--     CongruenceAndThenItCarriesForward.agda   (--cubical --safe, exit 0)
--
-- and says exactly this:
--
--   * अनुवृत्तिः — if the observer's class is a CONGRUENCE for the rule
--     (same reading ⇒ same next reading), then the observer's entire future
--     is fixed by its present reading, at every step, forever.  There is an
--     emergent law, and this program prints it.
--
--   * अभाव्यम् — if ONE pair of states reads the same and steps to different
--     readings, then NO function of the observed value predicts the next
--     observed value.  Not the ones anyone tried — every function at once.
--     This program exhibits that pair.
--
-- So the two columns below are not "we found a pattern" and "we didn't".
-- They are "here is the law" and "here is the proof that there is none".
--
-- WHY IT MATTERS FOR A RULE-SPACE SEARCH.  An observed law being simple says
-- nothing about the rule being simple.  It says the observer's equivalence
-- happens to be compatible with the rule.  The same rule, watched one query
-- finer, can go from noise to an exact law — the last section shows a rule
-- where that happens.
--
-- Run:
--   runghc machine/Drashta_WhichObserversOfAnElementaryRuleSeeALawAndWhichProvablyCannot.hs
--   runghc machine/Drashta_...hs 110 9        -- one rule, width 9, in detail
--   runghc machine/Drashta_...hs sweep 8      -- all 256 rules, width 8
module Main (main) where

import System.Environment (getArgs)
import System.IO (hSetEncoding, stdout, utf8)
import Data.List (intercalate, sortOn, groupBy, nub)
import Data.Bits (testBit)
import Data.Function (on)

-- ------------------------------------------------------------------- rule
type Row = [Bool]

-- the eight neighbourhoods, in Wolfram's own numbering
stepRule :: Int -> Row -> Row
stepRule r xs = [ bitAt (idx (at (i-1)) (at i) (at (i+1))) | i <- [0 .. n-1] ]
  where
    n = length xs
    at i = xs !! ((i + n) `mod` n)
    idx a b c = (if a then 4 else 0) + (if b then 2 else 0) + (if c then 1 else 0)
    bitAt k = testBit r k

allRows :: Int -> [Row]
allRows 0 = [[]]
allRows n = [ b : rest | b <- [False, True], rest <- allRows (n-1) ]

-- ------------------------------------------------------------- observers
-- an observer is a name and a reading.  The reading is compared for equality
-- and nothing else is ever asked of it.
data Drashta = Drashta { dName :: String, dRead :: Row -> String }

live :: Row -> Int
live = length . filter id

boundaries :: Row -> Int          -- cyclic count of unequal neighbours
boundaries xs = length [ () | i <- [0 .. n-1], xs !! i /= xs !! ((i+1) `mod` n) ]
  where n = length xs

observers :: [Drashta]
observers =
  [ Drashta "the whole row"        (concatMap (\b -> if b then "1" else "0"))
  , Drashta "ω  live cells"        (show . live)
  , Drashta "ω mod 2"              (show . (`mod` 2) . live)
  , Drashta "ω mod 3"              (show . (`mod` 3) . live)
  , Drashta "leftmost cell"        (\r -> case r of (b:_) -> show b; _ -> "")
  , Drashta "boundaries"           (show . boundaries)
  , Drashta "boundaries mod 2"     (show . (`mod` 2) . boundaries)
  , Drashta "is the row empty"     (show . all not)
  , Drashta "(ω, boundaries)"      (\r -> show (live r, boundaries r))
  ]

-- ------------------------------------------------------- the decision
-- Group every state by its reading.  The observer sees a law exactly when the
-- NEXT reading is constant on every group.  Exhaustive over all 2^w rows.
data Verdict
  = Niyama [(String, String)]     -- अनुवृत्तिः: the induced law, reading ↦ next
  | Andha Row Row String String   -- अभाव्यम्: the blind pair, and the two futures

decide :: Int -> Int -> Drashta -> Verdict
decide r w (Drashta _ o) =
  case [ (x, y, o (stepRule r x), o (stepRule r y))
       | grp <- groups, (x:rest) <- [grp], y <- rest
       , o (stepRule r x) /= o (stepRule r y) ] of
    ((x,y,fx,fy):_) -> Andha x y fx fy
    []              -> Niyama [ (o x, o (stepRule r x)) | (x:_) <- groups ]
  where
    rows   = allRows w
    groups = map (map snd)
           . groupBy ((==) `on` fst)
           . sortOn fst
           $ [ (o x, x) | x <- rows ]

-- ---------------------------------------------------------------- display
render :: Row -> String
render = concatMap (\b -> if b then "█" else "·")

spacetime :: Int -> Int -> Row -> [String]
spacetime r d seed = take d (map render (iterate (stepRule r) seed))

centred :: Int -> Row
centred w = [ i == w `div` 2 | i <- [0 .. w-1] ]

lawTable :: [(String, String)] -> String
lawTable ps
  | length ps > 10 = intercalate ", " [ a ++ "↦" ++ b | (a,b) <- take 10 ps ] ++ ", …"
  | otherwise      = intercalate ", " [ a ++ "↦" ++ b | (a,b) <- ps ]

detail :: Int -> Int -> IO ()
detail r w = do
  putStrLn ("rule " ++ show r ++ ", width " ++ show w
            ++ ", all " ++ show (2 ^ w :: Int) ++ " rows checked\n")
  putStrLn "  the rule unfolding from one live cell:"
  mapM_ (putStrLn . ("    " ++)) (spacetime r 16 (centred w))
  putStrLn ""
  mapM_ (report r w) observers

report :: Int -> Int -> Drashta -> IO ()
report r w d = case decide r w d of
  Niyama ps -> do
    putStrLn ("  ✓ " ++ pad 20 (dName d) ++ "  SEES A LAW — and it is:")
    putStrLn ("      " ++ lawTable ps)
  Andha x y fx fy -> do
    putStrLn ("  ✗ " ++ pad 20 (dName d) ++ "  no law exists, and here is why:")
    putStrLn ("      " ++ render x ++ "  and  " ++ render y
              ++ "  read the same,")
    putStrLn ("      but step to readings " ++ fx ++ " and " ++ fy
              ++ ".  By अभाव्यम्, no function of the reading predicts it.")
  where pad n s = s ++ replicate (n - length s) ' '

-- --------------------------------------------------------------- the sweep
sweep :: Int -> IO ()
sweep w = do
  putStrLn ("all 256 elementary rules at width " ++ show w
            ++ ", every one of the " ++ show (2 ^ w :: Int)
            ++ " rows checked for each observer.\n")
  putStrLn ("  " ++ pad 22 "observer" ++ "rules whose law it sees")
  mapM_ line observers
  putStrLn "\n  every entry is a finite exhaustive verification, not a sample."
  where
    pad n s = s ++ replicate (n - length s) ' '
    line d =
      let ok = [ r | r <- [0 .. 255], isLaw (decide r w d) ]
      in putStrLn ("  " ++ pad 22 (dName d) ++ show (length ok) ++ "/256"
                   ++ (if null ok then ""
                       else "   " ++ shortly ok))
    isLaw (Niyama _) = True
    isLaw _          = False
    shortly rs | length rs > 14 = intercalate "," (map show (take 14 rs)) ++ ",…"
               | otherwise      = intercalate "," (map show rs)

-- ------------------------------------------------------- one query finer
finer :: Int -> IO ()
finer w = do
  putStrLn "\none query apart — the same rule, watched two ways.\n"
  let candidates =
        [ (r, dA, dB)
        | r <- [0 .. 255]
        , let dA = head [ d | d <- observers, dName d == "ω  live cells" ]
        , let dB = head [ d | d <- observers, dName d == "(ω, boundaries)" ]
        , not (isLaw (decide r w dA)), isLaw (decide r w dB) ]
  case candidates of
    [] -> putStrLn "  (none at this width — try a larger w)"
    ((r, dA, dB) : _) -> do
      putStrLn ("  rule " ++ show r ++ ":")
      report r w dA
      report r w dB
      putStrLn "\n  Same rule.  One more question asked, and noise became a law."
      putStrLn ("  There are " ++ show (length candidates)
                ++ " rules at this width where exactly that happens.")
  where
    isLaw v = case v of Niyama _ -> True; _ -> False

-- ------------------------------------------------------------------- main
main :: IO ()
main = do
  hSetEncoding stdout utf8
  as <- getArgs
  putStrLn "द्रष्टा — which observers of a rule see a law, and which provably cannot.\n"
  case as of
    ("sweep":w:_) -> sweep (read w) >> finer (read w)
    ("sweep":_)   -> sweep 8 >> finer 8
    (r:w:_)       -> detail (read r) (read w)
    (r:_)         -> detail (read r) 9
    []            -> do
      detail 110 9
      putStrLn ""
      sweep 8
      finer 8
  putStrLn "\n(the two verdicts are theorems: formal/cubical/Anuvrtti_AnObserver\
           \SeesALawExactlyWhenItsClassIsACongruenceAndThenItCarriesForward.agda)"

_unusedNub :: [Int] -> [Int]
_unusedNub = nub
