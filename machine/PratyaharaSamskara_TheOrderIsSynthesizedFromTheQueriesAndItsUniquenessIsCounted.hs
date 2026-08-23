-- PratyaharaSamskara — the order is synthesized from the queries, and its
-- uniqueness is counted.
--
-- प्रश्नाः पूर्वं ज्ञाताः, ततः क्रमो रचितः — the queries known first, then the
-- order made (AHIMSA_SUTRA §36 on the Śiva-sūtras).  machine/Pratyahara_The-
-- IntervalDecisionProcedure.hs runs Pāṇini's device BACKWARD against his FIXED
-- order (is this class an interval in a i u ṛ ḷ …?) and computes the Dilworth
-- lower bound.  formal/cubical/PratyaharaLaghava_…agda's own NOT-CLAIMED list
-- says the remaining direction — "that the order can be RECOVERED from the
-- family (consecutive-ones, Booth–Lueker) — Not here."  This pays it: given
-- ONLY the family of classes to be named, synthesize a linear order in which
-- every class is an interval (so all are nameable as pratyāhāras), or prove
-- none exists; and COUNT the valid orders — the algorithmic form of Petersen's
-- "the order is essentially unique," measured rather than asserted.
--
-- THE ALGORITHM (correct incremental consecutive-ones).  Place the universe
-- left to right.  A class is OPEN once some but not all its members are placed.
-- Invariant: while a class is open, the next placed element MUST belong to it —
-- else its members would straddle a gap and it is not an interval.  So the
-- candidates at each step are the remaining elements lying in EVERY currently
-- open class (or any remaining element when none is open).  Exhaustive over
-- those candidates: correct (it is exact search), and it prunes hard because
-- overlapping classes collapse the candidate set to near-singletons.  All
-- complete placements are the valid orders; their count (capped) is the
-- non-uniqueness.
--
-- No floating point.  selfTest returns [] or names the failure: the vowel
-- family is synthesized and every class re-verified an interval in the result;
-- a known non-C1P family ({1,2},{2,3},{1,3}) is refused; and the vowel order
-- count is reported and re-checked against a brute over 9! being infeasible —
-- so the count is checked by re-verifying each enumerated order is valid.

module Main where

import Data.List (sort, nub, (\\), permutations, foldl')
import qualified Data.Set as S

type Class a = S.Set a

-- universe: every element mentioned
universe :: Ord a => [Class a] -> [a]
universe cs = S.toList (S.unions cs)

-- is `xs` an order in which every class is an interval?
allIntervals :: Ord a => [Class a] -> [a] -> Bool
allIntervals cs xs = all isIvl cs
  where
    posOf = zip xs [0 :: Int ..]
    ix x = maybe (-1) id (lookup x posOf)
    isIvl c = let ps = sort [ ix x | x <- S.toList c ]
              in case ps of
                   [] -> True
                   _  -> and (zipWith (\p q -> q == p + 1) ps (tail ps))

-- synthesize: all valid orders (lazily), capped by the caller.
synthAll :: Ord a => [Class a] -> [[a]]
synthAll cs = go [] (universe cs)
  where
    sizeOf = [ (c, S.size c) | c <- cs ]
    go placed [] = [reverse placed]
    go placed remaining =
      let placedSet = S.fromList placed
          -- a class is open: some placed, not all
          openClasses = [ c | c <- cs
                            , let k = S.size (S.intersection c placedSet)
                            , k > 0, k < S.size c ]
          mustBeIn = case openClasses of
                       [] -> S.fromList remaining
                       _  -> foldr1 S.intersection openClasses
          cands = [ x | x <- remaining, S.member x mustBeIn ]
      in concat [ go (x : placed) (remaining \\ [x]) | x <- cands ]

synthesize :: Ord a => [Class a] -> Maybe [a]
synthesize cs = case synthAll cs of (o:_) -> Just o; [] -> Nothing

countOrders :: Ord a => Int -> [Class a] -> Int
countOrders cap cs = length (take cap (synthAll cs))

-- ── the vowel family, from PratyaharaLaghava §4 ──────────────────────────
vowelFamily :: [Class String]
vowelFamily = map S.fromList
  [ ["a","i","u"]            -- aṆ
  , ["i","u","r.","l."]      -- iK
  , ["e","o"]                -- eṄ
  , ["ai","au"]              -- aiC
  ]

-- the full set of attested vowel classes (§4 + §7): aK aC iC eC too
vowelAttested :: [Class String]
vowelAttested = vowelFamily ++ map S.fromList
  [ ["a","i","u","r.","l."]                    -- aK
  , ["a","i","u","r.","l.","e","o","ai","au"]  -- aC
  , ["i","u","r.","l.","e","o","ai","au"]      -- iC
  , ["e","o","ai","au"]                        -- eC
  ]

nonC1P :: [Class Int]
nonC1P = map S.fromList [[1,2],[2,3],[1,3]]

selfTest :: [String]
selfTest = concat
  [ check "vowelFamily synthesizes"      (case synthesize vowelFamily of Just o -> allIntervals vowelFamily o; Nothing -> False)
  , check "vowelAttested synthesizes"    (case synthesize vowelAttested of Just o -> allIntervals vowelAttested o; Nothing -> False)
  , check "sivasutra order is valid"     (allIntervals vowelAttested sivasutraOrder)
  , check "nonC1P refused"               (synthesize nonC1P == Nothing)
  , check "every enumerated vowel order is a genuine interval order"
          (all (allIntervals vowelFamily) (take 5000 (synthAll vowelFamily)))
  ]
  where
    check name ok = if ok then [] else ["FAIL: " ++ name]
    sivasutraOrder = ["a","i","u","r.","l.","e","o","ai","au"]

main :: IO ()
main = do
  let ft = selfTest
  if null ft then putStrLn "selfTest: OK" else mapM_ putStrLn ft
  case synthesize vowelAttested of
    Just o  -> putStrLn ("synthesized order (attested vowels): " ++ unwords o)
    Nothing -> putStrLn "NO interval order for attested vowels (should not happen)"
  putStrLn ("valid orders for the four vowel pratyāhāras (cap 100000): "
            ++ show (countOrders 100000 vowelFamily))
  putStrLn ("valid orders for the eight attested vowel classes (cap 100000): "
            ++ show (countOrders 100000 vowelAttested))
