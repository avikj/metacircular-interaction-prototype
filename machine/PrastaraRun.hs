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

-- PrastaraRun — the प्रस्तार capability against the machine's own stored
-- enumerations: same rows, same order, and the figures for what is no
-- longer held.
--
-- Every check below is exhaustive over a stated finite space, so each is a
-- proof of the bounded statement (CLAUDE.md: exact/certified symbolic
-- computation is proof; a sample is not).  Nothing here is fitted and
-- nothing is measured.
--
-- The three stored enumerations it is checked against:
--   machine/ArithVocab.hs      smallEnvironments n bound = sequence (replicate n [0..bound])
--   machine/GateAudit.hs       gridFor vs = map (zip vs) (mapM (const [0..kGrid]) vs)
--   machine/ArithVocab.hs      genTerms sig nv maxSize = concat [ build n | n <- [1..maxSize] ]
--                              with ofSize reading back into the memo — so
--                              the whole term set is resident.
--
-- Sources for the method: Piṅgala, Chandaḥśāstra 8.24–28 (naṣṭa, uddiṣṭa,
-- saṅkhyā), 8.34–35 with Halāyudha's Mṛtasañjīvanī (meru-prastāra);
-- Virahāṅka, Vṛttajātisamuccaya ch. 6 (mātrāmeru).

module Main (main) where

import Text.Printf (printf)
import System.Exit (exitFailure, exitSuccess)

import Prastara_TheSearchSpaceIsGeneratedNotStored
import ArithVocab
  ( Term(..), Sym, vocabulary, arities, termGrammar, size )

-- ===================================================== the स्थापित originals
--
-- The three stored generators, copied here verbatim as they stood before
-- the substitution, so the equality below is a real comparison and not a
-- tautology.  These are reference copies; the engine no longer runs them.

storedSmallEnvironments :: Int -> Integer -> [[Integer]]
storedSmallEnvironments n bound = sequence (replicate n [0 .. bound])

storedSmallEnvironmentsZ :: Int -> Integer -> [[Integer]]
storedSmallEnvironmentsZ n b = sequence (replicate n [-b .. b])

storedGridFor :: [Int] -> Integer -> [[(Int, Integer)]]
storedGridFor vs kGrid = map (zip vs) (mapM (const [0 .. kGrid]) vs)

storedGenTerms :: [(String, Int)] -> Int -> Int -> [Term]
storedGenTerms sig nv maxSize = concat table
  where
    table = [ build n | n <- [1 .. maxSize] ]
    ofSize n | n >= 1 && n <= maxSize = table !! (n - 1)
             | otherwise = []
    build 1 = [ V i | i <- [0 .. nv - 1] ] ++ [ F f [] | (f, 0) <- sig ]
    build n = [ F f args | (f, a) <- sig, a > 0, args <- argsOf a (n - 1) ]
      where
        argsOf 1 k | k >= 1    = map (: []) (ofSize k)
                   | otherwise = []
        argsOf a k = [ t : rest | i <- [1 .. k - a + 1]
                                , t <- ofSize i
                                , rest <- argsOf (a - 1) (k - i) ]

-- ============================================================ the checks

-- how many heap-resident cells the stored form holds, counted honestly:
-- one cell per Integer in an environment, one per node in a term
envCells :: [[Integer]] -> Int
envCells = sum . map length

termNodes :: [Term] -> Int
termNodes = sum . map size

check :: String -> Bool -> IO Bool
check name ok = do
  printf "  %-58s %s\n" name (if ok then "ok" else "FAILED")
  pure ok

main :: IO ()
main = do
  putStrLn "=== प्रस्तारः — the search space is generated, not stored ==="
  putStrLn ""

  -- ------------------------------------------------ 1. Piṅgala, verbatim
  putStrLn "-- 1. Piṅgala's four pratyayas (Chandaḥśāstra 8) --"
  let n8 = chandas 8
  printf "  saṅkhyā of an 8-syllable metre        %d rows, 0 stored\n" (sankhya n8)
  printf "  naṣṭa of row 11 in a 4-syllable metre %s\n" (show (nasta (chandas 4) 11))
  printf "  uddiṣṭa of that pattern               %d\n"
         (uddista (chandas 4) (nasta (chandas 4) 11))
  let (v64, k64) = sankhyaVargaSteps 64
  printf "  saṅkhyā 2^64 by repeated squaring     %d, in %d multiplications\n" v64 k64
  let (v1000, k1000) = sankhyaVargaSteps 1000
  printf "  saṅkhyā 2^1000 by repeated squaring   %d digits, in %d multiplications\n"
         (length (show v1000)) k1000
  printf "  meru row 30 (one row held, %d cells)  head %s\n"
         (length (meruRow 30)) (show (take 5 (meruRow 30)))
  printf "  mātrāmeru M(12) (two cells of state)  %d\n" (matrameru 12)
  putStrLn ""

  r1 <- check "naṣṭa/uddiṣṭa mutually inverse on all 2^12 metres"
              (roundTrips (chandas 12))
  r2 <- check "saṅkhyā by squaring = 2^n for n = 0..64"
              (and [ sankhyaVarga n == 2 ^ n | n <- [0 .. 64 :: Integer] ])
  r3 <- check "meru row n = binomials, n = 0..24"
              (and [ meruRow n == [ binom n k | k <- [0 .. n] ] | n <- [0 .. 24] ])
  r4 <- check "mātrāmeru M(n+2) = M(n+1) + M(n), n = 0..40"
              (and [ matrameru (n + 2) == matrameru (n + 1) + matrameru n
                   | n <- [0 .. 40] ])
  putStrLn ""

  -- ------------------------------- 2. the refutation box (ArithVocab, MathMachine)
  putStrLn "-- 2. the refutation box: smallEnvironments n bound --"
  let boxCases = [ (n, b) | n <- [1 .. 3 :: Int], b <- [1, 6, 15 :: Integer] ]
  r5 <- check "generated order = sequence (replicate n [0..b]), all cases"
              (and [ rows (envPrastara n b) == storedSmallEnvironments n b
                   | (n, b) <- boxCases ])
  r6 <- check "naṣṭa/uddiṣṭa mutually inverse on every box"
              (and [ roundTrips (envPrastara n b) | (n, b) <- boxCases ])
  let signedP n b = powerP n (isoP (subtract b) (+ b) (chedaP (2 * b)))
  r6b <- check "PairVocab's signed box = sequence (replicate n [-b..b])"
               (and [ rows (signedP n b) == storedSmallEnvironmentsZ n b
                    | (n, b) <- boxCases ]
                && and [ roundTrips (signedP n b) | (n, b) <- boxCases ])
  let (n3, b15) = (3 :: Int, 15 :: Integer)
      stored3   = storedSmallEnvironments n3 b15
      p3        = envPrastara n3 b15
  printf "  ArithVocab main's box (nv=%d, bound=%d)\n" n3 b15
  printf "    stored     %d rows, %d Integer cells resident\n"
         (length stored3) (envCells stored3)
  printf "    generated  %d rows, %d cells held (one row) + 1 index\n"
         (sankhya p3) n3
  printf "    resume state  %d bits\n" (bitsFor (sankhya p3))
  putStrLn ""

  -- --------------------------------------------- 3. the audit grid (GateAudit)
  putStrLn "-- 3. the audit grid: gridFor vs, kGrid = 6 --"
  let kGrid = 6 :: Integer
      vsets = [[0], [0, 1], [0, 1, 2], [0, 1, 2, 3 :: Int]]
      storedGrid vs = storedGridFor vs kGrid
  r7 <- check "generated order = gridFor, 1..4 variables"
              (and [ rows (gridPrastara vs kGrid) == storedGrid vs | vs <- vsets ])
  mapM_ (\vs -> printf "    %d vars: stored %6d rows x %d cells = %7d;  held %d + 1 index\n"
                       (length vs) (length (storedGrid vs)) (length vs)
                       (length vs * length (storedGrid vs)) (length vs))
        vsets
  putStrLn ""

  -- --------------------------------------------- 4. the term space (genTerms)
  putStrLn "-- 4. the term space: genTerms sig nv maxSize --"
  let syms = vocabulary :: [Sym]
      sig  = arities syms
      nv   = 3 :: Int
      g    = termGrammar sig nv
  r8 <- check "generated order = genTerms, maxSize 1..4, nv = 3"
              (and [ rows (gradedUpToP g m) == storedGenTerms sig nv m | m <- [1 .. 4] ])
  r9 <- check "naṣṭa/uddiṣṭa mutually inverse on the whole size-4 space"
              (roundTrips (gradedUpToP g 4))
  r10 <- check "saṅkhyā per size = the stored count per size, maxSize 5"
               (gradedSizes g 5
                  == [ toInteger (length [ t | t <- storedGenTerms sig nv 5, size t == s ])
                     | s <- [1 .. 5] ])
  putStrLn ""
  mapM_ (\m -> do
           let stored = storedGenTerms sig nv m
               p      = gradedUpToP g m
           printf "    maxSize %d: stored %7d terms / %8d nodes resident;  memo %d prastāras\n"
                  m (length stored) (termNodes stored) m
           printf "               generated saṅkhyā %7d, resume state %d bits\n"
                  (sankhya p) (bitsFor (sankhya p)))
        [1 .. 5 :: Int]
  putStrLn ""
  printf "    size 6 saṅkhyā, never enumerated: %d terms (%d bits of index)\n"
         (sankhya (gradedUpToP g 6)) (bitsFor (sankhya (gradedUpToP g 6)))
  putStrLn ""

  -- ------------------------------------------------ 5. where a सारणी stays
  putStrLn "-- 5. where the table is unavoidable --"
  putStrLn "    genTermsModulo (MathMachine.hs, Certify.hs) quotients the term"
  putStrLn "    space by commutativity and associativity and then ordNubs.  A"
  putStrLn "    rank function for that quotient needs a canonical form per"
  putStrLn "    AC-class and a count of classes per size; neither is available"
  putStrLn "    here, so the ordNub set is genuinely stored.  Stated, not hidden."
  putStrLn "    Likewise the atom row (variables and constants) is a सारणी: it"
  putStrLn "    is a list with no rule, and it is O(nv + constants)."
  putStrLn ""

  let allOk = and [r1, r2, r3, r4, r5, r6, r6b, r7, r8, r9, r10]
  if allOk
    then putStrLn "ALL CHECKS PASSED" >> exitSuccess
    else putStrLn "SOME CHECKS FAILED" >> exitFailure

-- exact binomial, by the definition, for the meru check
binom :: Int -> Int -> Integer
binom n k
  | k < 0 || k > n = 0
  | otherwise      = product [ toInteger (n - k + i) | i <- [1 .. k] ]
                       `div` product [ toInteger i | i <- [1 .. k] ]

bitsFor :: Integer -> Int
bitsFor n
  | n <= 1    = 1
  | otherwise = length (takeWhile (< n) (iterate (* 2) 1))

