-- Nalanda — a reactor, not a shelf.
--
-- WHAT THIS IS.  The corpus has Aryabhata's kuttaka (499), Brahmagupta's
-- bhavana (628) and the cakravala (Jayadeva ~950, Bhaskara II 1150) as
-- checked Agda modules.  Checked and inert.  They state what is true and
-- nothing turns them.
--
-- This file turns them.  Seed it with D and it runs the cycle until the
-- norm reaches 1, and what comes out is the fundamental solution of
-- x^2 - D y^2 = 1 -- Bhaskara's own answer for D = 61, which is
-- (1766319049, 226153980), reached by Brouncker in 1657 and proved
-- terminating by Lagrange in 1768, six hundred years late.
--
-- WHY IT IS NOT THE OTHER MACHINE.  `MathMachine` enumerates terms and
-- tests them: 25k terms, then 396k, conjectures generated and filtered, and
-- rounds 19 and 20 byte-identical with fresh = 0.  That is grinding against
-- a wall, and the wall is that ENUMERATION HAS NO GROWTH RULE -- it can only
-- sift a space someone else fixed.
--
-- Brahmagupta's rule is not a filter.  Given two solutions it COMPUTES a
-- third:
--
--     (x1^2 - D y1^2)(x2^2 - D y2^2) = (x1x2 + D y1y2)^2 - D(x1y2 + x2y1)^2
--
-- No search. No candidate set. The composition of two results IS a result,
-- and the norm multiplies, so the structure is closed and productive by
-- construction.  A reactor built on composition cannot deadlock the way an
-- enumerator does, because it never asks "which of these many things is
-- true" -- it only ever applies a rule that preserves truth.
--
-- And the cakravala is what supplies the fuel: when the norm is not 1, it
-- descends -- keep the remainder and recurse, which is the kuttaka's rule --
-- to a triple with a smaller norm, and the descent is exact because
-- Aryabhata's pulverizer solves the congruence that makes it exact.  The
-- three sources are one machine.  They always were; the separation into
-- three modules is an artefact of how the material reached us.
--
-- EXACT ARITHMETIC ONLY.  Integer throughout.  No floating point anywhere,
-- including the integer square root, which is Newton over Integer.  Per
-- CLAUDE.md a computed constant is worth nothing without its error term;
-- here there are no computed constants, only exact identities checked by
-- `verify` at every step and at the end.

module Nalanda
  ( Triple(..)
  , isqrt
  , valli
  , bezout
  , inverseMod
  , bhavana
  , tulya
  , compose
  , cakravala
  , chooseM
  , chain
  , verify
  , selfTest
  ) where

import Data.List (minimumBy)
import Data.Ord (comparing)

-- ---------------------------------------------------------------- state
--
-- A triple (a, b, k) with a^2 - D b^2 = k.  The invariant is not a comment:
-- `verify` checks it and every producer below is checked against it in
-- `selfTest`.  Nothing in this file returns a bare pair of numbers.
data Triple = Triple { tA :: !Integer, tB :: !Integer, tK :: !Integer }
  deriving (Eq, Show)

verify :: Integer -> Triple -> Bool
verify d (Triple a b k) = a * a - d * (b * b) == k

-- ------------------------------------------------------- kuttaka (499)
--
-- ARYABHATA, Aryabhatiya, Ganitapada 32-33; the procedure step by step in
-- Bhaskara I's bhasya, 629.  Divide, KEEP THE REMAINDER AND RECURSE ON IT,
-- and write each quotient into the valli -- the column.  Then climb the
-- column: the coefficients at each row are built from the row below.
--
-- The remainder is not error to be discarded.  It is the next problem.
-- That is the growth rule, and it is the one `MathMachine` never had.

-- the valli itself: the column of quotients, kept, because the column IS
-- the algorithm and not scratch work
valli :: Integer -> Integer -> [Integer]
valli _ 0 = []
valli a b = (a `div` b) : valli b (a `mod` b)

-- back-substitution up the valli: (x, y, g) with a*x + b*y = g = gcd(a,b).
-- Each step takes the row below and forms (y', x' - q*y'), which is
-- Aryabhata's rule verbatim.
bezout :: Integer -> Integer -> (Integer, Integer, Integer)
bezout a 0 = (1, 0, a)
bezout a b = let (x', y', g) = bezout b (a `mod` b)
             in (y', x' - (a `div` b) * y', g)

-- the pulverizer used as it is used inside the cycle: b^{-1} mod n.
-- Nothing here assumes primality; the kuttaka needs only gcd(b,n) = 1.
inverseMod :: Integer -> Integer -> Maybe Integer
inverseMod b n
  | n <= 0 = Nothing
  | g /= 1 = Nothing
  | otherwise = Just (x `mod` n)
  where (x, _, g) = bezout (b `mod` n) n

-- ------------------------------------------------------ bhavana (628)
--
-- BRAHMAGUPTA, Brahmasphutasiddhanta 18.  THE REACTOR CORE.  Two solutions
-- in, one out, norms multiplied.  This is generation, not search: there is
-- no candidate set and nothing is tested, because the rule preserves the
-- invariant by algebra.
bhavana :: Integer -> Triple -> Triple -> Triple
bhavana d (Triple a1 b1 k1) (Triple a2 b2 k2) =
  Triple (a1 * a2 + d * b1 * b2) (a1 * b2 + a2 * b1) (k1 * k2)

-- tulya-bhavana: composition with itself, the only move available when you
-- hold exactly one solution -- which is the situation the cycle starts in.
tulya :: Integer -> Triple -> Triple
tulya d t = bhavana d t t

-- iterate the composition from a unit-norm seed.  This is the generativity
-- the 628 rule is named for: one solution, an infinite family, no search.
chain :: Integer -> Triple -> [Triple]
chain d seed = iterate (bhavana d seed) seed

compose :: Integer -> [Triple] -> Triple
compose d = foldr1 (bhavana d)

-- ---------------------------------------------------- cakravala (~950)
--
-- JAYADEVA, surviving through Udayadivakara's Sundari (1073); BHASKARA II,
-- Bijaganita (1150).  The cycle.  Compose the current triple with the
-- trivial triple (m, 1, m^2 - D), then divide through by k -- which is
-- exact precisely when the kuttaka has solved k | (a + b m).
--
-- BHASKARA'S CHOICE RULE, which is his contribution over Jayadeva: among
-- the m satisfying that one congruence, take the one minimising |m^2 - D|.
-- That is what makes the cycle terminate rather than wander, and it is why
-- the method needs no bound, no table, and no guessing.

-- exact integer square root, Newton over Integer.  No Double: at D = 109
-- the answer has fifteen digits and a Double would silently be wrong.
isqrt :: Integer -> Integer
isqrt n
  | n < 0 = error "isqrt: negative"
  | n < 2 = n
  | otherwise = go (n `div` 2)
  where
    go x = let y = (x + n `div` x) `div` 2
           in if y >= x then x else go y

-- the m Bhaskara's rule selects, given the current triple.
--
-- The congruence is  a + b*m = 0  (mod |k|),  i.e.  m = -a * b^{-1}.  The
-- kuttaka supplies the inverse.  Then walk the residue class and take the
-- member minimising |m^2 - D|; the minimiser is adjacent to sqrt D, so a
-- short window around it is exhaustive rather than sampled -- the window is
-- checked in `selfTest` by re-running with a wider one and comparing.
chooseM :: Integer -> Triple -> Maybe Integer
chooseM d (Triple a b k) = do
  let n = abs k
  if n == 1
    then Just (isqrt d)          -- congruence is vacuous mod 1
    else do
      bi <- inverseMod b n
      let r  = ((- a) * bi) `mod` n
          t0 = (isqrt d - r) `div` n
          cands = [ r + t * n | t <- [t0 - 2 .. t0 + 2], r + t * n >= 0 ]
      if null cands
        then Nothing
        else Just (minimumBy (comparing (\m -> abs (m * m - d))) cands)

-- one turn of the wheel
step :: Integer -> Triple -> Maybe Triple
step d t@(Triple a b k) = do
  m <- chooseM d t
  let n = abs k
      a' = (a * m + d * b) `div` n
      b' = (a + b * m)     `div` n
      k' = (m * m - d)     `div` k
  pure (Triple (abs a') (abs b') k')

-- THE REACTOR.  Seed with the trivial triple and turn until the norm is 1.
-- Returns the whole trace, so every intermediate is auditable and the run
-- is not a number that must be trusted.
cakravala :: Integer -> Either String [Triple]
cakravala d
  | d < 2 = Left "cakravala: D must be at least 2"
  | isqrt d * isqrt d == d = Left "cakravala: D is a perfect square"
  | otherwise = go (Triple a0 1 (a0 * a0 - d)) (0 :: Int) []
  where
    a0 = isqrt d
    go t n acc
      | not (verify d t) = Left ("invariant broken at step " ++ show n
                                 ++ ": " ++ show t)
      | tK t == 1 = Right (reverse (t : acc))
      | n > 400   = Left ("no convergence in 400 turns; last " ++ show t)
      | otherwise = case step d t of
          Nothing -> Left ("congruence unsolvable at step " ++ show n
                           ++ ": " ++ show t)
          Just t' -> go t' (n + 1) (t : acc)

-- ---------------------------------------------------------------- test
--
-- The classical hard cases, each with the answer the tradition records.
-- D = 61 is Bhaskara's own worked example and the one Fermat later posed as
-- a challenge problem; D = 109 has a fifteen-digit answer and is where any
-- floating-point step would silently produce a wrong number.
--
-- Every line is checked by exact Integer arithmetic against the defining
-- equation, not against a stored answer alone: `verify` recomputes
-- a^2 - D b^2 and demands 1.
selfTest :: IO Bool
selfTest = do
    putStrLn "  D        turns   a                b                a^2-D b^2"
    rs <- mapM report classical
    putStrLn ""
    putStrLn "  -- bhavana generates: compose the fundamental solution with"
    putStrLn "     itself and the norm stays 1, without any search --"
    gen <- mapM genReport [2, 13, 61]
    putStrLn ""
    putStrLn "  -- the choice window is exhaustive, not sampled: rerunning"
    putStrLn "     every case with a window of +/-6 gives the same answers --"
    let wide = all wideAgrees classical
    putStrLn ("     window-independent: " ++ show wide)
    pure (and rs && and gen && wide)
  where
    -- (D, expected a, expected b) as the tradition records them
    classical =
      [ (2,   3,          2)
      , (3,   2,          1)
      , (13,  649,        180)
      , (61,  1766319049, 226153980)
      , (67,  48842,      5967)
      , (109, 158070671986249, 15140424455100)
      ]

    report (d, ea, eb) = case cakravala d of
      Left err -> putStrLn ("  " ++ show d ++ "  FAILED: " ++ err) >> pure False
      Right tr -> do
        let t = last tr
            ok = verify d t && tA t == ea && tB t == eb && tK t == 1
        putStrLn ("  " ++ pad 8 (show d) ++ pad 8 (show (length tr))
                  ++ pad 17 (show (tA t)) ++ pad 17 (show (tB t))
                  ++ show (tA t * tA t - d * tB t * tB t)
                  ++ (if ok then "" else "   <-- MISMATCH"))
        pure ok

    -- composition preserves the invariant with no search and no testing
    genReport d = case cakravala d of
      Left _ -> pure False
      Right tr -> do
        let s  = last tr
            ts = take 4 (chain d s)
            ok = all (\t -> verify d t && tK t == 1) ts
        putStrLn ("     D=" ++ pad 5 (show d)
                  ++ concatMap (\t -> " (" ++ show (tA t) ++ "," ++ show (tB t) ++ ")")
                               (take 3 ts)
                  ++ (if ok then "" else "   <-- MISMATCH"))
        pure ok

    wideAgrees (d, ea, eb) = case cakravalaWide d of
      Left _ -> False
      Right t -> tA t == ea && tB t == eb && tK t == 1

    pad n s = s ++ replicate (max 0 (n - length s)) ' '

-- The same reactor with a deliberately wider choice window, used only to
-- check that the narrow one is not quietly truncating the search.  If these
-- ever disagree the narrow window is wrong and `selfTest` says so.
cakravalaWide :: Integer -> Either String Triple
cakravalaWide d = go (Triple a0 1 (a0 * a0 - d)) (0 :: Int)
  where
    a0 = isqrt d
    go t n
      | not (verify d t) = Left "invariant broken"
      | tK t == 1 = Right t
      | n > 400 = Left "no convergence"
      | otherwise = case stepWide t of
          Nothing -> Left "congruence unsolvable"
          Just t' -> go t' (n + 1)
    stepWide t@(Triple a b k) = do
      m <- chooseMWide t
      let n = abs k
      pure (Triple (abs ((a * m + d * b) `div` n))
                   (abs ((a + b * m) `div` n))
                   ((m * m - d) `div` k))
    chooseMWide (Triple a b k) = do
      let n = abs k
      if n == 1 then Just (isqrt d) else do
        bi <- inverseMod b n
        let r  = ((- a) * bi) `mod` n
            t0 = (isqrt d - r) `div` n
            cands = [ r + t * n | t <- [t0 - 6 .. t0 + 6], r + t * n >= 0 ]
        if null cands then Nothing
          else Just (minimumBy (comparing (\m -> abs (m * m - d))) cands)
