-- BhavanaSeparation -- generation against enumeration, as an exact
-- separation and not as a benchmark.
--
-- WHY THIS FILE EXISTS.  Two architectures ran in this repository in the
-- same week, on the same substrate, against arithmetic of the same kind.
--
--   MathMachine   enumerates terms and tests them.  25k terms, then 396k.
--                 239 rounds, 1696 residuals, ZERO theorems installed, and
--                 rounds 19 and 20 byte-identical with fresh = 0.
--
--   Nalanda       composes.  Seeded with D = 61 it returned the fundamental
--                 solution of x^2 - 61 y^2 = 1 -- (1766319049, 226153980) --
--                 in NINE turns.  No candidate set.  Nothing tested.
--
-- That contrast has been sitting here as an anecdote.  It is not an
-- anecdote.  It is a theorem, and the theorem is exact.
--
-- THE STATEMENT.  Fix a non-square D and let (x1, y1) be the least
-- positive solution of x^2 - D y^2 = 1.
--
--   (a) Any procedure that finds a solution by generating candidates and
--       testing them -- in ANY order that is monotone in y -- must perform
--       at least y1 tests, because no smaller y admits a solution.  That is
--       not an empirical observation about a particular enumerator; it is
--       forced by minimality.
--
--   (b) The cakravala performs t turns, each a fixed amount of exact
--       integer arithmetic (one kuttaka, one choice of m, one bhavana).
--
--   (c) So the cost ratio is y1 / t, and both numbers are exact integers.
--
-- NOTHING IS FITTED AND NOTHING IS MEASURED.  Per the protocol in
-- CLAUDE.md, a correlation has no content and the content is the error
-- term; here there is no error term because there is no estimate.  Every
-- row of the table this module prints is: an exact integer y1, an exact
-- integer t, and their exact quotient.  A run of this file on another
-- machine, in another decade, prints the same integers.
--
-- HOW MINIMALITY IS ESTABLISHED, honestly, in two tiers:
--
--   * `leastUpTo` is an EXHAUSTIVE finite verification -- for every y from
--     1 to B, D y^2 + 1 is not a perfect square.  Finite exhaustive
--     verification is proof (CLAUDE.md: "exact / certified symbolic
--     computation is proof"), and it needs no theory at all.  Where
--     y1 <= B this certifies y1 exactly minimal, and the ratio is exact.
--
--   * Where y1 > B, the certified statement is weaker and is reported as
--     weaker: "no solution with y <= B", which already forces the
--     enumerator to at least B tests.  The claim that the cakravala's
--     answer is THE minimal one is then standard theory (every solution is
--     a bhavana-power of the fundamental one; Lagrange 1768 for
--     termination) and is NOT re-proved here.  The table marks which tier
--     each row is in.  A row that says CERTIFIED needed no theory; a row
--     that says BOUNDED is a lower bound only.
--
-- WHY THIS IS ABOUT THE MACHINE AND NOT ABOUT PELL'S EQUATION.  The
-- repository's own enumerator generates terms up to a size bound.  A truth
-- whose smallest witness exceeds that bound is unreachable at that bound,
-- and raising the bound costs exponentially in the number of terms.  The
-- Pell family is the clean instance where the smallest witness is a single
-- integer and its size can be exhibited: at D = 61 the smallest witness has
-- nine digits, and the composing machine reaches it in nine steps.  The
-- separation is not about arithmetic.  It is about what an architecture
-- with no growth rule can reach.
--
-- SOURCES.  Aryabhata, Aryabhatiya, Ganitapada 32-33 (499), the kuttaka --
-- "keep the remainder and recurse", which is the growth rule.  Brahmagupta,
-- Brahmasphutasiddhanta 18 (628), the bhavana -- two solutions in, one out,
-- norms multiplied, no search.  Jayadeva (~950, transmitted in
-- Udayadivakara's Sundari, 1073) and Bhaskara II, Bijaganita (1150), the
-- cakravala.  Bhaskara's own worked case is D = 61.  Fermat posed it as a
-- challenge to the English in 1657, five hundred years later; Lagrange
-- proved termination in 1768, six hundred.
--
-- Integer throughout.  No floating point, including in the integer square
-- root, which is Nalanda's Newton iteration over Integer.

module BhavanaSeparation
  ( Row(..)
  , Tier(..)
  , turns
  , fundamental
  , leastUpTo
  , row
  , table
  , defaultFamily
  , digits
  , selfTest
  ) where

import Nalanda (Triple(..), cakravala, isqrt, verify)

------------------------------------------------------------------------
-- the two costs
------------------------------------------------------------------------

-- (b) the cost of composing: how many turns the cycle takes.
turns :: Integer -> Either String Int
turns d = fmap length (cakravala d)

-- the answer itself, re-verified against the defining equation here rather
-- than trusted from Nalanda
fundamental :: Integer -> Either String (Integer, Integer)
fundamental d = do
  ts <- cakravala d
  case reverse ts of
    (t : _) | tK t == 1 && verify d t -> Right (tA t, tB t)
    (t : _) -> Left ("cakravala ended at norm " ++ show (tK t) ++ " for D = " ++ show d)
    []      -> Left ("cakravala returned nothing for D = " ++ show d)

-- (a) the cost of enumerating, as a certified statement rather than a run:
-- EXHAUSTIVELY, no y in [1, b] admits a solution.  Finite, exact, and it
-- needs no theory.
leastUpTo :: Integer -> Integer -> Bool
leastUpTo d b = go 1
  where
    go y | y > b = True
         | isSquare (d * y * y + 1) = False
         | otherwise = go (y + 1)

isSquare :: Integer -> Bool
isSquare n | n < 0 = False
           | otherwise = let r = isqrt n in r * r == n

digits :: Integer -> Int
digits n = length (show (abs n))

------------------------------------------------------------------------
-- a row of the table
------------------------------------------------------------------------

-- CERTIFIED: the exhaustive check reached y1 itself, so y1 is minimal by
--            finite verification and the ratio is exact.
-- BOUNDED:   the exhaustive check stopped below y1, so what is certified is
--            a LOWER bound on the enumerator's cost, not the exact one.
data Tier = Certified | Bounded
  deriving (Eq, Show)

data Row = Row
  { rD        :: Integer
  , rTurns    :: Int          -- what composing costs, in turns
  , rX        :: Integer      -- the solution found
  , rY        :: Integer
  , rBound    :: Integer      -- how far the exhaustive check ran
  , rTier     :: Tier
  , rCertCost :: Integer      -- tests the enumerator must perform, THEORY-FREE
  , rFullCost :: Integer      -- tests it must perform if y1 is minimal (= y1)
  } deriving (Show)

row :: Integer -> Integer -> Either String Row
row b d = do
  t <- turns d
  (x, y) <- fundamental d
  let clean = leastUpTo d (min b (y - 1))
      tier  = if y - 1 <= b then Certified else Bounded
      cost  = if tier == Certified then y else b
  if not clean
    then Left ("D = " ++ show d ++ ": a smaller solution exists below "
               ++ show (min b (y - 1)) ++ " -- cakravala did not return the least")
    else Right (Row d t x y (min b (y - 1)) tier cost y)

table :: Integer -> [Integer] -> [Either String Row]
table b = map (row b)

-- The family: the small cases where minimality is certified outright, then
-- Bhaskara's own D = 61, then the ones the tradition and Fermat both used
-- to make the point that enumeration is hopeless.
defaultFamily :: [Integer]
defaultFamily =
  [ 2, 3, 5, 6, 7, 8, 10, 11, 12, 13
  , 29, 31, 43, 46, 53
  , 61                       -- Bhaskara II, Bijaganita 1150; Fermat 1657
  , 67, 73, 86, 89, 94, 97
  , 103, 109                 -- Fermat's other challenge
  , 149, 151, 166, 181, 193, 199
  , 211, 214, 277, 313, 331, 397, 409, 421, 433, 439
  , 541, 661, 1021, 1621
  ]

------------------------------------------------------------------------
-- self-test: the claims this module makes about itself
------------------------------------------------------------------------

selfTest :: [String]
selfTest = concat
  [ chk "D=61 is Bhaskara's answer"
      (fundamental 61) (Right (1766319049, 226153980))
  , chk "D=61 takes 9 turns" (turns 61) (Right 9)
  , chk "D=2 is (3,2)"   (fundamental 2)  (Right (3, 2))
  , chk "D=3 is (2,1)"   (fundamental 3)  (Right (2, 1))
  , chk "D=13 is (649,180)" (fundamental 13) (Right (649, 180))
  , chk "D=29 is (9801,1820)" (fundamental 29) (Right (9801, 1820))
  , chk "D=109 is Fermat's other one"
      (fundamental 109) (Right (158070671986249, 15140424455100))
  -- the exhaustive check agrees with the answer where they meet
  , chk "no solution below y1 for D=13" (leastUpTo 13 179) True
  , chk "and there IS one at y1 for D=13" (leastUpTo 13 180) False
  , chk "no solution below y1 for D=29" (leastUpTo 29 1819) True
  , chk "and there IS one at y1 for D=29" (leastUpTo 29 1820) False
  -- every solution really solves the equation
  , concat [ chk ("D=" ++ show d ++ " satisfies x^2-Dy^2=1")
               (fmap (\(x, y) -> x * x - d * y * y) (fundamental d)) (Right 1)
           | d <- [2, 3, 5, 6, 7, 13, 29, 61, 109, 421] ]
  ]
  where
    chk name got want
      | got == want = []
      | otherwise   = [ name ++ ": got " ++ show got ++ ", wanted " ++ show want ]
