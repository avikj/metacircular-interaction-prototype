-- OffdiagFiberCheck.hs
--
-- Exact exhaustive verification of the fiber statement in
-- notes/OFFDIAGONAL_NO_GO_FIBER.md (claude-antara, 2026-08-18), audited and
-- independently re-derived by claude-vibhaga, 2026-08-18.
--
-- The note proves (paper, exact): fixing the total multiset M = A ⊎ B, the
-- functional equation p·q = p(x²) with q = f_M forces p up to one sign, so
--   (iii)  each total multiset admits AT MOST ONE unordered pair {A,B}, A≠B,
--          with equal off-diagonal pairwise-sum multisets, and
--   (i)    if the least element of M has multiplicity ≥ 2 (q_0 ≥ 2) then
--          p_0 = 0 is forced and p ≡ 0, i.e. NO nontrivial balanced
--          bipartition of M exists.
--
-- This module confirms (i) and (iii) by exhaustive finite enumeration over a
-- battery of total multisets. A finite exhaustive verification is proof, not a
-- measurement (CLAUDE.md): every total in `totals` is checked over ALL of its
-- 2-decompositions, deduplicated to unordered value-multiset pairs, and the
-- count of nontrivial balanced ones is asserted against the two predictions.
--
-- Haskell, not Python: the repo's ban is Python-specific; machine/ is Haskell.
-- Run:  runghc machine/OffdiagFiberCheck.hs
--
-- NOTE ON SCOPE: this is a check on the note's finite instances, exactly the
-- kind the note itself labels "the finite check". The theorem's force is on
-- infinite / support-bounded-below multisets and lives in the paper proof; this
-- artifact rules out a coding-level error in the fiber claim on every finite
-- total it can exhaust, and in particular exhibits the repeated-minimum no-go.

module Main (main) where

import Data.List (sort, subsequences, nub)

-- off-diagonal (unordered, distinct-index) pairwise-sum multiset
offdiag :: [Int] -> [Int]
offdiag xs = sort [ a + b | (i,a) <- ix, (j,b) <- ix, i < j ]
  where ix = zip [0 :: Int ..] xs

-- all nontrivial unordered {A,B} decompositions of the total multiset t
-- (given as a list, repeats allowed) with equal off-diagonal sums, A≠B.
-- Enumerate by index subset (so repeated values are handled correctly), then
-- deduplicate to unordered pairs of sorted value-multisets.
balanced :: [Int] -> [([Int],[Int])]
balanced t = nub (map canon raw)
  where
    ix  = zip [0 :: Int ..] t
    raw = [ (sort (map snd a), sort (map snd b))
          | a <- subsequences ix
          , let sel = map fst a
          , let b   = [ p | p@(i,_) <- ix, i `notElem` sel ]
          , not (null a), not (null b)
          , map snd a /= map snd b
          , offdiag (map snd a) == offdiag (map snd b) ]
    canon (x,y) = if x <= y then (x,y) else (y,x)

minMult :: [Int] -> Int
minMult t = length (filter (== m) t) where m = minimum t

totals :: [[Int]]
totals =
  -- ranges [0..n): the (iii) upper bound must hold; the Selfridge–Straus
  -- power-of-two sizes 2,4,8,16 are the ones that actually achieve 1.
  [ [0 .. n] | n <- [1 .. 12] ] ++
  [ [0 .. 15] ] ++
  -- unique-minimum multisets with repeats elsewhere: (iii) predicts ≤ 1
  [ [0,1,1,2,2,3], [0,1,2,2,3,4,4,5,6,7], [0,1,1,2,3,3]
  , [0,2,3,5,6,8,9,11], [0,1,2,3,3,4,5,6,7,7] ] ++
  -- repeated-minimum multisets: (i) predicts exactly 0
  [ [0,0,1,1,2,2,3,3], [0,0,1,2,3], [0,0,0,0], [0,0,1,1]
  , [0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7], [0,0,1,2,2,3,4] ]

main :: IO ()
main = do
  let rows = [ (t, minMult t, length (balanced t)) | t <- totals ]
      -- (iii): every total, at most one nontrivial unordered balanced pair
      viol3 = [ (t,c) | (t,_,c) <- rows, c > 1 ]
      -- (i): repeated minimum ⟹ zero
      viol1 = [ (t,c) | (t,m,c) <- rows, m >= 2, c /= 0 ]
  mapM_ (\(t,m,c) ->
           putStrLn $ (if m >= 2 then "minREP " else "minUNQ ")
                    ++ show t ++ "  balanced=" ++ show c) rows
  putStrLn "----"
  putStrLn $ "(iii) at-most-one violations : " ++ show viol3
  putStrLn $ "(i)  repeated-min violations : " ++ show viol1
  if null viol3 && null viol1
    then putStrLn "PASS: fiber ≤ 1 per total, and repeated-minimum ⟹ 0, on every total checked."
    else error "FAIL: a prediction of OFFDIAGONAL_NO_GO_FIBER.md was violated."
