-- Prastara — प्रस्तारः as a first-class capability of the machine: every
-- search space is addressed by index, never laid out and held.
--
-- SOURCE, and it is the origin, not a footnote.
--
--   Piṅgala, *Chandaḥśāstra* (c. 300–200 BCE), ch. 8.  A metre of n
--   syllables has 2ⁿ laghu/guru patterns.  Piṅgala does not store the
--   2ⁿ rows.  He writes four procedures:
--
--     प्रस्तारः  prastāra  — the layout, as a RULE for the next row
--     नष्टम्     naṣṭa     — "the lost one": row number ↦ pattern.
--                            Halve the number; halved evenly, write guru;
--                            odd, add one, halve, write laghu; until zero.
--     उद्दिष्टम्  uddiṣṭa   — "the pointed-at one": pattern ↦ row number.
--                            naṣṭa run backwards.
--     सङ्ख्या    saṅkhyā   — how many: 2ⁿ by repeated squaring, log n
--                            multiplications, not 2ⁿ additions.
--
--   Halāyudha, *Mṛtasañjīvanī* (10th c.), on Chandaḥśāstra 8.34–35: the
--   meru-prastāra, each entry the sum of the two above it — so a row is
--   generated from the row above and only one row is ever held.
--
--   Virahāṅka, *Vṛttajātisamuccaya* (c. 600–800 CE), ch. 6: M(n+2) =
--   M(n+1) + M(n) for the mātrā-vṛtta — the mātrāmeru, two cells of state.
--
--   Later restatements: Pascal 1654 (the array), Fibonacci 1202 (the
--   recurrence), Leibniz 1703 (index ↦ binary pattern).
--
-- WHAT THIS FILE IS.  The naṣṭa/uddiṣṭa pair, generalised from Piṅgala's
-- one radix (two syllables per place) to a radix per place, packaged so
-- the machine's own search spaces are values of type `Prastara a` — a
-- count, an unranker, a ranker — and are enumerated by counting up rather
-- than by holding a list.
--
-- Piṅgala's radix is 2 and it is fixed.  The per-place radix, and the
-- disjoint-sum and graded-grammar combinators below, are this file's
-- extension of his method to the machine's spaces; nothing about them is
-- claimed of the Chandaḥśāstra.  What IS his is the pair of procedures,
-- their being mutually inverse, and the decision not to store the table.
--
-- CHECKED.  `formal/cubical/NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn.agda`
-- (--cubical --safe, no postulates, no holes) proves, for a radix list rs:
--   नष्टोद्दिष्ट   naṣṭa ∘ uddiṣṭa ≡ id                (on the nose)
--   उद्दिष्टनष्ट   uddiṣṭa ∘ naṣṭa ≡ id, below saṅkhyā
--   प्रस्तारः      अङ्कस्थान rs ≃ Fin (सङ्ख्या rs)
--   पङ्क्ति-सत्य   the one-row meru generator IS the meru array
--   युगल-सत्य     the two-cell mātrāmeru generator IS Virahāṅka's M(n)
-- `prodP`/`powerP`/`meruNext`/`matrameru` below are those functions.
--
-- SPACE.  `PrastaraRun.hs` reports the figures and checks, by exhaustive
-- comparison against the stored enumerations it replaces, that the
-- generated order is the same order — so the substitution is not a
-- behaviour change.

module Prastara_TheSearchSpaceIsGeneratedNotStored
  ( -- the object
    Prastara(..)
  , rows, rowAt, roundTrips
    -- the algebra
  , nihP, ekaP, chedaP, saraniP, prodP, sumP, chooseP, isoP, powerP
    -- Piṅgala's four procedures
  , Aksara(..), chandas, sankhyaVarga, sankhyaVargaSteps
  , meruNext, meruRow, matrameru, matrameruRow
    -- the machine's spaces
  , envPrastara, gridPrastara
  , Vyakarana(..), gradedSizes, gradedExactP, gradedUpToP
  ) where


import Data.List (foldl')
import Data.Maybe (listToMaybe, fromMaybe)

-- ===================================================================== object

-- A prastāra: how many rows, the row at an index, and the index of a row.
-- The rows are never a field.  `nasta` and `uddista` are mutually inverse
-- on [0 .. sankhya-1]; that is the whole contract.
data Prastara a = Prastara
  { sankhya :: !Integer          -- सङ्ख्या — how many rows
  , nasta   :: Integer -> a      -- नष्टम् — index ↦ row
  , uddista :: a -> Integer      -- उद्दिष्टम् — row ↦ index
  }

-- The layout, when someone genuinely wants it: counting up, lazily, and
-- retaining nothing but the current index.  Never a stored field.
rows :: Prastara a -> [a]
rows p = map (nasta p) [0 .. sankhya p - 1]

rowAt :: Prastara a -> Integer -> a
rowAt = nasta

-- The contract, checkable at any finite size (exhaustive, so a proof of
-- the bounded statement, not a sample).
roundTrips :: Eq a => Prastara a -> Bool
roundTrips p = all ok [0 .. sankhya p - 1]
  where ok i = uddista p (nasta p i) == i

-- ================================================================== algebra

nihP :: Prastara a                       -- शून्यम् — no rows
nihP = Prastara 0 (\i -> error ("nasta: no such row " ++ show i)) (const 0)

ekaP :: a -> Prastara a                  -- one row
ekaP x = Prastara 1 (const x) (const 0)

-- One place of a positional numeral: the digits 0..b.  Piṅgala's place is
-- b = 1 — laghu and guru.
chedaP :: Integer -> Prastara Integer
chedaP b = Prastara (b + 1) id id

-- सारणी — a stored table.  Here because sometimes a set really has no rule
-- (§4 below says where), and because naming it makes its cost visible.
saraniP :: Eq a => [a] -> Prastara a
saraniP xs = Prastara (toInteger (length xs)) pick rank
  where
    pick i = xs !! fromInteger i
    rank x = fromMaybe 0 (listToMaybe [ i | (i, y) <- zip [0 ..] xs, y == x ])

-- मिश्रच्छेदः — mixed radix.  The LEFT factor is the more significant place,
-- so `rows (prodP p q)` is lexicographic with p varying slowest.  This is
-- Piṅgala's halving step with the divisor `sankhya q` instead of 2.
prodP :: Prastara a -> Prastara b -> Prastara (a, b)
prodP p q = Prastara (sankhya p * sankhya q) pick rank
  where
    m = sankhya q
    pick i = case i `divMod` m of (hi, lo) -> (nasta p hi, nasta q lo)
    rank (x, y) = uddista p x * m + uddista q y

-- Disjoint union: the left prastāra's rows first, then the right's.
sumP :: Prastara a -> Prastara b -> Prastara (Either a b)
sumP p q = Prastara (sankhya p + sankhya q) pick rank
  where
    n = sankhya p
    pick i | i < n     = Left  (nasta p i)
           | otherwise = Right (nasta q (i - n))
    rank = either (uddista p) (\y -> n + uddista q y)

-- A run of alternatives over one type, concatenated in order.  `which`
-- names the branch a row came from — the ranker cannot guess it.
chooseP :: [Prastara a] -> (a -> Int) -> Prastara a
chooseP ps which = Prastara total pick rank
  where
    ns    = map sankhya ps
    offs  = scanl (+) 0 ns
    total = sum ns
    pick i = go (zip3 ps ns offs)
      where
        go [] = error ("nasta: no such row " ++ show i)
        go ((q, n, o) : more)
          | i < o + n = nasta q (i - o)
          | otherwise = go more
    rank x = let j = which x in (offs !! j) + uddista (ps !! j) x

isoP :: (a -> b) -> (b -> a) -> Prastara a -> Prastara b
isoP f g p = Prastara (sankhya p) (f . nasta p) (uddista p . g)

-- n places of the same prastāra, first place most significant.  This is
-- exactly `sequence (replicate n xs)` — the same list, in the same order,
-- with nothing held.
powerP :: Int -> Prastara a -> Prastara [a]
powerP n0 p = go n0
  where
    go k | k <= 0    = ekaP []
         | otherwise =
             let t = go (k - 1)
             in isoP (\(x, xs) -> x : xs) uncons (prodP p t)
    uncons (x : xs) = (x, xs)
    uncons []       = error "uddista: pattern shorter than the prastāra"

-- ================================================== §1 Piṅgala's four, exactly

data Aksara = Laghu | Guru deriving (Eq, Ord, Show)

-- छन्दस् — the 2ⁿ patterns of an n-syllable metre.  `nasta` is Piṅgala's
-- halving, `uddista` is it run backwards; `sankhya` is 2ⁿ and no row is
-- stored.  Note the first place is the most significant here, which is the
-- reading order of a written metre; Piṅgala halves from the first syllable,
-- which is the same bijection read from the other end.
chandas :: Int -> Prastara [Aksara]
chandas n = powerP n (isoP toA fromA (chedaP 1))
  where
    toA 0 = Laghu
    toA _ = Guru
    fromA Laghu = 0
    fromA Guru  = 1

-- सङ्ख्या by repeated squaring — Chandaḥśāstra 8.28–31, the śūnya/dvi rule:
-- write the exponent in binary; at a marker square, on an odd digit double.
-- log₂ n multiplications, not n.
sankhyaVarga :: Integer -> Integer
sankhyaVarga = fst . sankhyaVargaSteps

-- the value, and the number of multiplications it took, so the log is a
-- reported figure and not an assertion
sankhyaVargaSteps :: Integer -> (Integer, Int)
sankhyaVargaSteps n = foldl' step (1, 0) (bits n)
  where
    step (acc, k) b = (if b then 2 * (acc * acc) else acc * acc, k + 1)
    bits 0 = []
    bits m = reverse (go m)
      where go 0 = []
            go j = odd j : go (j `div` 2)

-- ==================================== §2 meru-prastāra — one row ever held

-- Halāyudha's rule as a generator: the next row from the row above.
meruNext :: [Integer] -> [Integer]
meruNext r = 1 : zipWith (+) r (drop 1 r ++ [0])

-- Row n of the meru.  Holds one row (n+1 cells), never the triangle
-- ((n+1)(n+2)/2 cells).
meruRow :: Int -> [Integer]
meruRow n = go n [1]
  where
    go 0 r = r
    go k r = let r' = meruNext r in r' `seq` go (k - 1) r'

-- ============================== §3 mātrāmeru — two cells of state, no list

-- Virahāṅka's recurrence as an iteration.  M 0 = M 1 = 1.
matrameru :: Int -> Integer
matrameru n = fst (go n)
  where
    go 0 = (1, 1)
    go k = case go (k - 1) of (a, b) -> let c = a + b in c `seq` (b, c)

-- the first n+1 values, still two cells of state at any moment
matrameruRow :: Int -> [Integer]
matrameruRow n = map matrameru [0 .. n]

-- ============================= §4 the machine's own spaces, as prastāras

-- The refutation box.  This is exactly
--     smallEnvironments n bound = sequence (replicate n [0 .. bound])
-- (machine/ArithVocab.hs, machine/MathMachine.hs) and exactly
--     gridFor vs = map (zip vs) (mapM (const [0 .. kGrid]) vs)
-- (machine/GateAudit.hs), in the same order — but with a count in hand,
-- so a counterexample search can start at any index, be split across
-- workers, or be resumed from a single Integer.
envPrastara :: Int -> Integer -> Prastara [Integer]
envPrastara n bound = powerP n (chedaP bound)

gridPrastara :: [Int] -> Integer -> Prastara [(Int, Integer)]
gridPrastara vs bound =
  isoP (zip vs) (map snd) (envPrastara (length vs) bound)

-- ---------------------------------------------------------------- grammar

-- A size-graded term grammar: atoms of size 1, constructors of arity a
-- whose size is 1 + the sizes of the arguments.  `viewOf` is what makes
-- uddiṣṭa definable — without a way to look INTO a row there is a
-- generator but no ranker, and half of Piṅgala is missing.
data Vyakarana a = Vyakarana
  { atomsOf :: [a]                          -- the size-1 rows, in order
  , ctorsOf :: [(Int, [a] -> a)]            -- (arity ≥ 1, builder), in order
  , viewOf  :: a -> Either Int (Int, [a])   -- atom index | (ctor index, args)
  }

sizeOfV :: Vyakarana a -> a -> Int
sizeOfV g t = case viewOf g t of
  Left _        -> 1
  Right (_, as) -> 1 + sum (map (sizeOfV g) as)

-- THE ONE TABLE THAT REMAINS, and it is maxSize entries long.
--
-- The stored generator (`genTerms` in machine/ArithVocab.hs, `genTermsModulo`
-- in machine/MathMachine.hs) memoises `table = [ build n | n <- [1..maxSize] ]`
-- and then holds `concat table` — every term, in memory, because `ofSize`
-- reads back into it.  Here the memo holds maxSize PRASTĀRAS: a count and two
-- closures each.  Same recurrence, same order, and the terms are made when
-- asked for and dropped.
gradedTable :: Vyakarana a -> Int -> [Prastara a]
gradedTable g maxSize = table
  where
    table = [ mk s | s <- [1 .. maxSize] ]

    exactAt s | s >= 1 && s <= maxSize = table !! (s - 1)
              | otherwise              = nihP

    -- size 1: the atoms.  A genuine सारणी, and small (nv + constants).
    mk 1 = Prastara (toInteger (length (atomsOf g)))
                    (\i -> atomsOf g !! fromInteger i)
                    (\t -> case viewOf g t of
                             Left j  -> toInteger j
                             Right _ -> 0)
    -- size s: constructors in signature order, arguments summing to s-1
    mk s = chooseP [ isoP build unbuild (argsP a (s - 1))
                   | (a, build) <- ctorsOf g, a > 0 ]
                   ctorIx
      where
        ctorIx t = case viewOf g t of
          Right (j, _) -> j
          Left _       -> 0
        unbuild t = case viewOf g t of
          Right (_, as) -> as
          Left _        -> []

    -- argument lists: arity a, total size k.  First argument's size ascending,
    -- then the argument, then the rest — the order of the nested comprehension
    -- it replaces.
    argsP 1 k
      | k >= 1    = isoP (: []) headArg (exactAt k)
      | otherwise = nihP
      where headArg (x : _) = x
            headArg []      = error "uddista: empty argument list"
    argsP a k =
      chooseP [ isoP consArg unconsArg (prodP (exactAt i) (argsP (a - 1) (k - i)))
              | i <- splits ]
              whichSplit
      where
        splits = [ 1 .. k - a + 1 ]
        consArg (x, xs) = x : xs
        unconsArg (x : xs) = (x, xs)
        unconsArg []       = error "uddista: argument list too short"
        whichSplit (x : _) = length (takeWhile (< sizeOfV g x) splits)
        whichSplit []      = 0

-- All rows of exact size s.
gradedExactP :: Vyakarana a -> Int -> Int -> Prastara a
gradedExactP g maxSize s
  | s >= 1 && s <= maxSize = gradedTable g maxSize !! (s - 1)
  | otherwise              = nihP

-- How many rows at each size — saṅkhyā for the term space, by the same
-- recurrence the enumeration obeys.  maxSize Integers.
gradedSizes :: Vyakarana a -> Int -> [Integer]
gradedSizes g maxSize = map sankhya (gradedTable g maxSize)

-- Everything of size 1..maxSize, concatenated by size — the whole of
-- `genTerms sig nv maxSize`, generated.
gradedUpToP :: Vyakarana a -> Int -> Prastara a
gradedUpToP g maxSize =
  chooseP (gradedTable g maxSize) (\t -> sizeOfV g t - 1)
