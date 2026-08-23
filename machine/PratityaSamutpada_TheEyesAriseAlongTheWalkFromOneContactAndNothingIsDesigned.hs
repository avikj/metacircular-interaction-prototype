-- प्रतीत्यसमुत्पादः — arising in dependence on conditions.
--
-- THE TERM, ITS SCHOOL, ITS TEXTS.  The word is Buddhist.  The formula
-- is the Nikāyas' (Pāli paṭiccasamuppāda, e.g. Saṃyutta Nikāya 12.21):
-- imasmiṃ sati idaṃ hoti — "when this is, that comes to be."  Nāgārjuna,
-- Mūlamadhyamakakārikā 24.18 (c. 150 CE), identifies pratītyasamutpāda
-- with śūnyatā: what arises dependently has no self-standing designer.
-- The word is taken for exactly that sense and nothing below is
-- attributed to those texts.  The school is named because the corpus
-- keeps its schools distinct: this is Buddhist vocabulary standing
-- beside — not flattened into — the Jaina and Nyāya terms elsewhere in
-- this machine.  (Nāgārjuna's catuṣkoṭi is already checked in
-- formal/cubical/; this is the same lineage arriving at the sensorium.)
--
-- WHAT THIS IS, in the owner's correction (2026-08-23): no designing,
-- no calibrating, no machine-being-engineered.  "We design perfect
-- things instantly" — yes: in this substrate an eye is EXACT AT THE
-- MOMENT OF ARISING.  Conservativity is constitutive (a distinction
-- added never erases one held); the separation of the two conditions
-- that occasioned it is constitutive (the eye IS that separation).
-- There is no tuning step because there is nothing to tune.
--
-- HOW IT DIFFERS from SvayamVrddhi (kept beside it, not replaced):
-- that organ sweeps the whole state space against a handed-in demand —
-- a totality view.  Here there is no demand list and no sweep:
--
--   * ONE INNATE CONTACT.  The organism has a body, so it has a
--     contact surface: the single cell where it stands (bit 0).
--     Light or dark.  That is not design; that is embodiment.  Every
--     further distinction must earn its arising.
--   * THE WORLD ARRIVES.  States present themselves as they come; the
--     organism follows each arrival along its own unfolding until the
--     orbit closes.  Nothing is enumerated for audit; what is not
--     encountered stays void of distinctions (anupalabdhi of the
--     unvisited is not knowledge of it).
--   * SURPRISE IS THE CONDITION.  The organism expects of each held
--     class what encounter has shown it.  When the world contradicts
--     the expectation — two moments it held as one come to be
--     differently — the distinction ARISES, there, then: the class
--     parts along "what comes to be next."  imasmiṃ sati idaṃ hoti.
--   * MEMORY IS RE-READ THROUGH NEW EYES.  After an arising, the whole
--     remembered biography is replayed under the new seeing — an
--     experience is not a stored verdict but a record that means more
--     as the organism grows (this is the corpus's own "experience is
--     transport that changes future transport").
--
-- AT THE END, TWO STANDPOINTS ARE WITNESSED AGREEING — this is not a
-- calibration and nothing is adjusted by it.  The walked arising and
-- the whole-space view (the coarsest lawful seeing that hosts the
-- contact sense, DrshtiJala's fixpoint) are two darśanas of one
-- object; when the walk has met the whole world, they coincide, and
-- the coincidence is printed as a fact about the two standpoints, not
-- as a test one of them passed.  Anekānta, not quality control.
--
-- No floating point, no sampling, no fitted anything.  Every event is
-- appended to machine/aisthesis.jsonl with its occasioning encounter.
--
-- Run:  runghc machine/PratityaSamutpada_...hs 110 6
--       runghc machine/PratityaSamutpada_...hs 30 6

{-# LANGUAGE LambdaCase #-}
module Main (main) where

import Data.Bits (testBit)
import Data.List (nub, foldl')
import qualified Data.Map.Strict as M
import System.Environment (getArgs)
import System.IO
import Data.Time.Clock (getCurrentTime)
import Data.Time.Format (formatTime, defaultTimeLocale)

type St = Int

stepOf :: Int -> Int -> St -> St
stepOf r w x = foldr set 0 [0 .. w - 1]
  where
    at i = testBit x ((i + w) `mod` w)
    set i acc =
      let a = at (i - 1); b = at i; c = at (i + 1)
          k = (if a then 4 else 0) + (if b then 2 else 0) + (if c then 1 else 0)
      in if testBit r k then acc + 2 ^ i else acc

-- ---------------------------------------------------------------- seeing
type Part = [Int]

normalise :: Ord a => [a] -> Part
normalise xs = map (ren M.!) xs
  where ren = M.fromList (zip (nub xs) [0 ..])

blocks :: Part -> Int
blocks = length . nub

-- the innate contact: light or dark at the cell where the organism stands
sparsha :: Int -> St -> Int
sparsha _ x = if testBit x 0 then 1 else 0

-- the whole-space standpoint (for the final agreement of darśanas only)
samagraDrsti :: (St -> St) -> Int -> Part -> Part
samagraDrsti f n p =
  let p' = normalise [ (p !! i, p !! f i) | i <- [0 .. n - 1] ]
  in if blocks p' == blocks p then p else samagraDrsti f n p'

-- ------------------------------------------------------------- arising
-- an encounter: a moment and what came to be from it
type Encounter = (St, St)

-- replay the remembered biography through the current seeing; the first
-- contradiction of expectation is the condition for an arising.
vismaya :: Part -> [Encounter] -> Either (M.Map Int (Int, St)) (St, St, Int, Int)
vismaya p = go M.empty
  where
    go expect [] = Left expect
    go expect ((z, z') : rest) =
      let c  = p !! z
          c' = p !! z'
      in case M.lookup c expect of
           Nothing -> go (M.insert c (c', z) expect) rest
           Just (c'', x)
             | c'' == c' -> go expect rest
             | otherwise -> Right (x, z, c'', c')

-- the arising itself: the class that held both parts along "what comes
-- to be next."  Exact at birth; nothing to adjust.
utpada :: (St -> St) -> Int -> Part -> St -> Part
utpada f n p z =
  let c = p !! z
  in normalise [ if p !! u == c then (p !! u, 1 + p !! f u) else (p !! u, 0)
               | u <- [0 .. n - 1] ]

data Udaya = Udaya
  { uCondition :: (St, St)    -- the two moments held as one
  , uCame      :: (Int, Int)  -- what came to be from each (as then seen)
  , uSeen      :: (Int, Int)  -- distinctions held before and after
  }

-- one arrival: walk its unfolding until the orbit closes, remembering.
agamana :: (St -> St) -> St -> [Encounter]
agamana f z0 = go z0 []
  where
    go z acc | z `elem` map fst acc = reverse acc
             | otherwise            = go (f z) ((z, f z) : acc)

-- the life: arrivals come as they come; distinctions arise as occasioned;
-- after each arising the biography is re-read through the new eyes.
jivanam :: (St -> St) -> Int -> ([Udaya], Part, Int)
jivanam f n = foldl' meet ([], normalise [ sparsha n x | x <- [0 .. n - 1] ], 0)
                    [0 .. n - 1]
  where
    meet (evs, p, met) arrival =
      let mem = concat [ agamana f a | a <- [0 .. arrival] ]
          (evs', p') = settle p mem evs
      in (evs', p', met + length (agamana f arrival))
    settle p mem evs = case vismaya p mem of
      Left _ -> (evs, p)
      Right (x, z, a, b) ->
        let p' = utpada f n p z
            ev = Udaya (x, z) (a, b) (blocks p, blocks p')
        in settle p' mem (evs ++ [ev])

-- ------------------------------------------------------------------ run
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
  putStrLn ("प्रतीत्यसमुत्पादः — rule " ++ show r ++ ", width " ++ show w
            ++ ".  One innate contact (the cell underfoot);")
  putStrLn  "every further eye arises from an encounter that contradicts expectation.\n"
  let (evs, lived, met) = jivanam f n
      whole  = samagraDrsti f n (normalise [ sparsha n x | x <- [0 .. n - 1] ])
      agree  = normalise lived == normalise whole
  mapM_ say (zip [1 :: Int ..] evs)
  putStrLn ("\n" ++ show (length evs) ++ " arisings over " ++ show met
            ++ " encounters; seeing: 2 → " ++ show (blocks lived) ++ " distinctions.")
  putStrLn (if agree
    then "the walked standpoint and the whole-space standpoint coincide — two darśanas, one seeing."
    else "the standpoints DIFFER — the walk has not met what the whole holds; the difference is the record, not a defect.")
  appendFile "machine/aisthesis.jsonl"
    (unlines [ event r w ev now | ev <- evs ])
  putStrLn (show (length evs) ++ " arisings appended to machine/aisthesis.jsonl.")
  where
    say (k, e) =
      putStrLn ("  arising " ++ show k ++ ": moments " ++ show (fst (uCondition e))
                ++ " and " ++ show (snd (uCondition e))
                ++ " were one; what came to be differed ("
                ++ show (fst (uCame e)) ++ "≠" ++ show (snd (uCame e))
                ++ "); seeing " ++ show (fst (uSeen e)) ++ "→" ++ show (snd (uSeen e))
                ++ " — imasmiṃ sati idaṃ hoti")

event :: Int -> Int -> Udaya -> String -> String
event r w e now = concat
  [ "{\"indriya\":\"pratitya-samutpada\""
  , ",\"kriya\":\"utpada\""
  , ",\"naya\":\"an eye arose in dependence on an encounter that contradicted expectation; nothing was designed and nothing tuned — the arising is exact at birth (Buddhist: SN 12.21 imasmim sati idam hoti; Nagarjuna MMK 24.18; the word for its sense only)\""
  , ",\"visaya\":\"rule ", show r, " width ", show w, ", one innate contact at bit 0\""
  , ",\"upalabdhi\":{\"condition\":[", show (fst (uCondition e)), ",", show (snd (uCondition e))
  , "],\"came_to_be\":[", show (fst (uCame e)), ",", show (snd (uCame e))
  , "],\"seeing\":[", show (fst (uSeen e)), ",", show (snd (uSeen e)), "]}"
  , ",\"pramanya\":{\"marga\":\"pratyaksa\",\"saksin\":\"the occasioning encounter is in the record; conservativity and separation are constitutive of the arising, not tested for\"}"
  , ",\"sesa\":[\"what was never encountered holds no distinction — anupalabdhi of the unvisited is not knowledge of it\"]"
  , ",\"agama\":\"machine/PratityaSamutpada_TheEyesAriseAlongTheWalkFromOneContactAndNothingIsDesigned.hs, this run\""
  , ",\"kala\":\"", now, "\"}"
  ]
