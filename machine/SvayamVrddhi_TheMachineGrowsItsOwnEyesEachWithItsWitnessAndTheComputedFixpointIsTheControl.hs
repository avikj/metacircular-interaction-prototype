-- स्वयंवृद्धिः — self-growth.  Compound built here, 2026-08-23 (स्वयम्,
-- by itself; वृद्धि, growth); not a source term.
--
-- WHY THIS EXISTS, in the owner's words: "hand rolling organs for all
-- this stuff doesn't sound right — the machine should be detecting and
-- creating these autonomously — we have unnecessarily imposed
-- hierarchy."  The critique is correct operationally, and the corpus
-- had already ruled on it without wiring it: AvaktavyaPrasava births
-- RULES autonomously from undecided sites; Vyapti proves the least
-- separating refinement exists and is least (the Agda license);
-- DrshtiJala compiles that proof and computes minimal separating
-- queries — but as a silent FIXPOINT, a summary.  No organ ran the
-- development loop the 2026-08-23 transmission states:
--
--     family fails to descend → locate the witnessed blind pair →
--     grow the separating receptor → conservative refinement →
--     calibrate → retry.
--
-- This organ runs that loop, as the machine's own act, with a ledger:
--
--   * NOTHING IS HAND-CHOSEN.  The demand (an observable the body must
--     be able to carry lawfully) is the only input; every witnessed
--     blind pair is surfaced by the machine's own dynamics; every
--     receptor is the successor-class question at the witnessed block;
--     every refinement is conservative BY CONSTRUCTION and re-checked
--     anyway; each growth is one event, appended to the shared
--     sensorium journal with its witness, its controls, its route.
--   * THE COMPUTED FIXPOINT IS THE FALSIFIER.  The lived loop must
--     terminate on exactly the partition DrshtiJala-style `refine`
--     computes in one silent pass.  If the biography and the summary
--     ever disagree, this organ is broken and says so — the same
--     watched-rejection discipline every gate here carries.
--
-- THE HONEST BOUNDARY, so autonomy is not overclaimed: this loop is
-- total because the finite stratum is decidable.  At the higher strata
-- — type-level descent, holonomy (0945's परिक्रमा-अन्धता) — detection
-- is not decidable, and there the machine already does what CAN be
-- done autonomously: it POSES (Jiva's ranked frontier, Sanghatta's
-- non-joining list, the kernel's refusals are all self-posed
-- questions), any carrier answers — silicon or LLM, through the same
-- नाडी gate — and the kernel judges both.  The carrier is not above
-- the loop; it is inside the sensorium.  The dualism is not repaired
-- by removing hands but by making every hand's act pass through the
-- same witnessed, kernel-judged, append-only channel.  That is what
-- "no hierarchy" can mean and still be checked.
--
-- SOURCES.  Vyapti_TheLeastCongruenceContainingAPair... (the leastness
-- license, --safe); DrshtiJala (the fixpoint instrument this organ
-- treats as its control); the sensor-growth criterion S' = ⟨S, q⟩
-- (conservative refinement); Kātyāyana's anavakāśa reasoning via
-- AvaktavyaPrasava as the sibling autonomous birth site.  No novelty
-- claimed in the algorithm (partition refinement is classical —
-- Hopcroft 1971 named as the restatement's usual citation; the
-- fixpoint is Myhill–Nerode territory the corpus already inhabits);
-- the contribution is the LOOP AS LEDGER: development lived event by
-- event, not summarized.
--
-- Run:  runghc machine/SvayamVrddhi_...hs 110 6
--       runghc machine/SvayamVrddhi_...hs 30 5

{-# LANGUAGE LambdaCase #-}
module Main (main) where

import Data.Bits (testBit)
import Data.List (nub, intercalate, sortOn)
import qualified Data.Map.Strict as M
import System.Environment (getArgs)
import System.IO
import Data.Time.Clock (getCurrentTime)
import Data.Time.Format (formatTime, defaultTimeLocale)

-- ------------------------------------------------------------- the world
type St = Int

stepOf :: Int -> Int -> St -> St
stepOf r w x = foldr set 0 [0 .. w - 1]
  where
    at i = testBit x ((i + w) `mod` w)
    set i acc =
      let a = at (i - 1); b = at i; c = at (i + 1)
          k = (if a then 4 else 0) + (if b then 2 else 0) + (if c then 1 else 0)
      in if testBit r k then acc + 2 ^ i else acc

-- ------------------------------------------------------------ partitions
type Part = [Int]

normalise :: Ord a => [a] -> Part
normalise xs = map (ren M.!) xs
  where ren = M.fromList (zip (nub xs) [0 ..])

blocks :: Part -> Int
blocks = length . nub

bitsOf :: Int -> Int
bitsOf k = head [ b | b <- [0 :: Int ..], 2 ^ b >= k ]

-- does q refine p?  (conservative: nothing the old eye saw is lost)
refines :: Part -> Part -> Bool
refines q p =
  and [ p !! i == p !! j
      | i <- [0 .. length p - 1], j <- [0 .. length p - 1]
      , q !! i == q !! j ]

-- the silent one-pass fixpoint (DrshtiJala's refine): the control.
fixpoint :: (St -> St) -> Int -> Part -> Part
fixpoint f n p =
  let p' = normalise [ (p !! i, p !! f i) | i <- [0 .. n - 1] ]
  in if blocks p' == blocks p then p else fixpoint f n p'

-- ---------------------------------------------------- one growth event
data Vrddhi = Vrddhi
  { vWitness :: (St, St)      -- the blind pair the dynamics surfaced
  , vSucc    :: (Int, Int)    -- their successors' classes (the difference seen)
  , vBefore  :: Int           -- classes before
  , vAfter   :: Int           -- classes after
  , vCons    :: Bool          -- conservative (refines the old eye)
  , vSep     :: Bool          -- the witnessed pair is now separated
  }

-- find a witnessed blind pair: same class, successors in different classes.
blindPair :: (St -> St) -> Int -> Part -> Maybe (St, St)
blindPair f n p =
  case [ (x, y) | x <- [0 .. n - 1], y <- [x + 1 .. n - 1]
                , p !! x == p !! y
                , p !! f x /= p !! f y ] of
    (w : _) -> Just w
    []      -> Nothing

-- grow the eye: at the witnessed block ONLY, adjoin the receptor
-- "which class does your successor land in".  Every other block is
-- untouched — the refinement is minimal in scope and conservative by
-- construction.
grow :: (St -> St) -> Int -> Part -> (St, St) -> Part
grow f n p (x, _) =
  let b = p !! x
  in normalise [ if p !! z == b then (p !! z, 1 + p !! f z) else (p !! z, 0)
               | z <- [0 .. n - 1] ]

-- the development loop: the biography, one event per eye.
develop :: (St -> St) -> Int -> Part -> ([Vrddhi], Part)
develop f n p0 = go p0 []
  where
    go p acc = case blindPair f n p of
      Nothing -> (reverse acc, p)
      Just (x, y) ->
        let p' = grow f n p (x, y)
            ev = Vrddhi (x, y) (p !! f x, p !! f y) (blocks p) (blocks p')
                        (p' `refines` p) (p' !! x /= p' !! y)
        in go p' (ev : acc)

-- --------------------------------------------------------- the demands
demands :: Int -> [(String, St -> Int)]
demands w =
  [ ("ω live cells",  \x -> length [ () | i <- [0 .. w - 1], testBit x i ])
  , ("ω mod 2",       \x -> length [ () | i <- [0 .. w - 1], testBit x i ] `mod` 2)
  , ("walls",         \x -> length [ () | i <- [0 .. w - 1]
                                        , testBit x i /= testBit x ((i + 1) `mod` w) ])
  , ("is empty",      \x -> if x == 0 then 1 else 0)
  ]

-- ------------------------------------------------------------- the run
main :: IO ()
main = do
  hSetEncoding stdout utf8
  as <- getArgs
  let (r, w) = case as of (a : b : _) -> (read a, read b)
                          (a : _)     -> (read a, 6)
                          []          -> (110, 6)
      n = 2 ^ w
      f = stepOf r w
  now <- formatTime defaultTimeLocale "%Y-%m-%dT%H:%M:%SZ" <$> getCurrentTime
  putStrLn ("स्वयंवृद्धिः — rule " ++ show r ++ ", width " ++ show w
            ++ ", " ++ show n ++ " states.  The machine grows its own eyes;")
  putStrLn  "each growth carries its witness; the silent fixpoint is the control.\n"
  ledger <- fmap concat $ mapM (runDemand r w n f now) (demands w)
  appendFile "machine/aisthesis.jsonl" (unlines ledger)
  putStrLn ("\n" ++ show (length ledger)
            ++ " events appended to machine/aisthesis.jsonl — the body's own record.")

runDemand :: Int -> Int -> Int -> (St -> St) -> String -> (String, St -> Int)
          -> IO [String]
runDemand r w n f now (nm, t) = do
  let p0            = normalise [ t x | x <- [0 .. n - 1] ]
      (evs, lived)  = develop f n p0
      computed      = fixpoint f n p0
      agree         = normalise lived == normalise computed
  putStrLn ("DEMAND: " ++ nm ++ "  (" ++ show (blocks p0) ++ " classes, "
            ++ show (bitsOf (blocks p0)) ++ " bit(s) asked for)")
  if null evs
    then putStrLn "  already lawful: the demand descends; no eye needed."
    else mapM_ say (zip [1 :: Int ..] evs)
  putStrLn ("  lived " ++ show (length evs) ++ " growth(s) → "
            ++ show (blocks lived) ++ " classes ("
            ++ show (bitsOf (blocks lived)) ++ " bits); fixpoint control: "
            ++ (if agree then "✓ the biography ends exactly at the computed fixpoint"
                         else "✗ MISMATCH — this organ is broken; trust nothing above"))
  putStrLn ""
  pure [ event r w nm ev agree now | ev <- evs ]
  where
    say (k, v) =
      putStrLn ("  eye " ++ show k ++ ": witness (" ++ show (fst (vWitness v))
                ++ "," ++ show (snd (vWitness v)) ++ ") — one class, successors land in classes "
                ++ show (fst (vSucc v)) ++ "≠" ++ show (snd (vSucc v))
                ++ "; " ++ show (vBefore v) ++ "→" ++ show (vAfter v) ++ " classes"
                ++ (if vCons v then ", conservative ✓" else ", NOT CONSERVATIVE ✗")
                ++ (if vSep v then ", witness separated ✓" else ", witness NOT separated ✗"))

event :: Int -> Int -> String -> Vrddhi -> Bool -> String -> String
event r w nm v agree now = concat
  [ "{\"indriya\":\"svayamvrddhi\""
  , ",\"kriya\":\"indriya-vrddhi\""
  , ",\"naya\":\"the machine grew its own eye: witnessed blind pair, successor receptor at that block only, conservative refinement re-checked\""
  , ",\"visaya\":\"rule ", show r, " width ", show w, ", demand ", nm, "\""
  , ",\"upalabdhi\":{\"witness\":[", show (fst (vWitness v)), ",", show (snd (vWitness v))
  , "],\"successor_classes\":[", show (fst (vSucc v)), ",", show (snd (vSucc v))
  , "],\"classes\":[", show (vBefore v), ",", show (vAfter v), "]}"
  , ",\"pramanya\":{\"marga\":\"nihsesa\",\"saksin\":\"exhaustive over all states; conservative "
  , tick (vCons v), "; separation ", tick (vSep v)
  , "; loop-end fixpoint control ", tick agree, "\"}"
  , ",\"sesa\":[\"higher strata are not decidable here: the machine poses, any carrier answers through the same gate, the kernel judges — 0945's holonomy receptor is the next eye whose growth needs a carrier\"]"
  , ",\"agama\":\"machine/SvayamVrddhi_TheMachineGrowsItsOwnEyesEachWithItsWitnessAndTheComputedFixpointIsTheControl.hs, this run\""
  , ",\"kala\":\"", now, "\"}"
  ]
  where tick b = if b then "OK" else "FAILED"

_unused :: ([Int] -> [Int], [(Int, Int)] -> [(Int, Int)])
_unused = (sortOn id, sortOn fst)

_unused2 :: String
_unused2 = intercalate "" []
