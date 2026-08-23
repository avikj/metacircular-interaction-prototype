-- SamamLekhyam_TheHilbertProductBalancesAtEveryPlaceAndDroppingTheInfiniteColumnBreaksExactlyTheDoublyNegativePairs.hs
--
-- समं लेख्यम् — "the books balanced."
--
-- THE TERM, ITS TEXT AND ITS DATE.  From this repository's own root text:
-- संरक्षण-सूत्राणि ३०, README.md, composed 2026-08-22 — "समं लेख्यम्, मुक्तो
-- मार्गः, शान्तं त्रयम्" (the books balanced, the road free, the three at
-- peace).  The compound is DECLARED BUILT HERE; no ancient text is claimed
-- for it, and none is claimed for the mathematics below, whose provenance
-- is stated honestly per the provenance rule: quadratic reciprocity was
-- conjectured by Euler and proved by Gauss (1796, the aureum theorema);
-- the symbol, its local formulas, and the PRODUCT FORMULA over the places
-- of ℚ are Hilbert's (Zahlbericht, 1897).  The local formulas used below
-- are as in Serre, *A Course in Arithmetic*, ch. III.  What this corpus
-- supplies is the READING (movements 63–65, landed 2026-08-22): the
-- product formula is the conservation law of a ledger whose columns are
-- the places, loss is always local, and the compensating term for the
-- finite columns lives at the archimedean one.
--
-- WHAT THIS PROGRAM IS.  The first reciprocity receipt in the tree:
--
--   १ · THE BALANCE.  For every pair of nonzero integers a, b with
--       |a|,|b| ≤ 60 (14,400 pairs), compute the Hilbert symbol (a,b)_v
--       at every place where it can differ from 1 — v = ∞, v = 2, and
--       the odd primes dividing ab — and check the product over all
--       places is EXACTLY 1.  Exact integers throughout; a finite
--       exhaustive verification is proof (CLAUDE.md) — proof for this
--       box, not of Hilbert's general theorem, which is cited, not
--       reproved.
--
--   २ · THE FIRST CONTROL, which is the session's thesis measured:
--       DROP THE ARCHIMEDEAN COLUMN — single-entry bookkeeping, the
--       accounting all of continuum physics does — and count what
--       breaks.  Since the total is forced to 1, the finite product
--       equals (a,b)_∞, so the books must break on EXACTLY the pairs
--       with a < 0 and b < 0 and no others: the infinite column of this
--       ledger carries precisely the joint-sign charge.  The program
--       counts both sides and demands equality.
--
--   ३ · THE SECOND CONTROL: drop the column at 2 — the first veil,
--       सूत्रे "two is the first veil" — and count the breakage.  That
--       number is how much of the ledger the smallest prime carries in
--       this box; it is printed, not estimated.
--
--   ४ · THE SHADOW: Gauss's reciprocity extracted back out.  For all
--       odd primes p < q ≤ 97, check (p|q)(q|p) = (−1)^{ε(p)ε(q)}, and
--       both supplements ((−1|p) and (2|p)) — the aureum theorema as
--       the visible shadow of the balance, verified pair by pair.
--
-- WHAT IS NOT CLAIMED.  No general theorem is proved here.  No entropy
-- reading, no analytic content, no claim about any place of any field
-- other than ℚ.  The Legendre symbol is computed by Euler's criterion
-- (modular exponentiation, exact); the local formulas are checked
-- against each other by the balance itself and against Gauss by §४ —
-- two independent instruments, which is the corpus's standard for
-- trusting either.
--
-- PRASAVA: every number below is printed by this file, and the command
-- that reproduces all of them is one line:
--
--     runghc machine/SamamLekhyam_….hs        (exit 0 iff every check holds)

module Main (main) where

import System.Exit (exitFailure, exitSuccess)

-- ───────────────────────────────────────────── exact modular arithmetic

powmod :: Integer -> Integer -> Integer -> Integer
powmod _ 0 _ = 1
powmod b e m
  | even e    = let h = powmod b (e `div` 2) m in (h * h) `mod` m
  | otherwise = (b `mod` m) * powmod b (e - 1) m `mod` m

-- Legendre symbol (u|p) for odd prime p, p ∤ u, by Euler's criterion.
legendre :: Integer -> Integer -> Integer
legendre u p =
  let r = powmod (u `mod` p) ((p - 1) `div` 2) p
  in if r == p - 1 then -1 else r

-- p-adic valuation and unit part: n = p^k · u with p ∤ u.
valUnit :: Integer -> Integer -> (Integer, Integer)
valUnit p = go 0
  where go k m | m `mod` p == 0 = go (k + 1) (m `div` p)
               | otherwise      = (k, m)

-- ε(u) = (u−1)/2 mod 2 and ω(u) = (u²−1)/8 mod 2, sign-safe for odd u.
epsO, omg :: Integer -> Integer
epsO u = if u `mod` 4 == 1 then 0 else 1
omg  u = if u `mod` 8 `elem` [1, 7] then 0 else 1

sgnPow :: Integer -> Integer -> Integer      -- (±1)^k
sgnPow s k = if odd k && s == -1 then -1 else 1

-- ───────────────────────────────────────────── the local columns

hilbertInf :: Integer -> Integer -> Integer
hilbertInf a b = if a < 0 && b < 0 then -1 else 1

hilbert2 :: Integer -> Integer -> Integer
hilbert2 a b =
  let (al, u) = valUnit 2 a
      (be, v) = valUnit 2 b
      ex = epsO u * epsO v + al * omg v + be * omg u
  in if odd ex then -1 else 1

hilbertOdd :: Integer -> Integer -> Integer -> Integer
hilbertOdd p a b =
  let (al, u) = valUnit p a
      (be, v) = valUnit p b
      e = (p - 1) `div` 2
      s0 = if odd (al * be * e) then -1 else 1
  in s0 * sgnPow (legendre u p) be * sgnPow (legendre v p) al

oddPrimeDivisors :: Integer -> [Integer]
oddPrimeDivisors n0 = go 3 (stripTwos (abs n0))
  where
    stripTwos m | even m, m > 0 = stripTwos (m `div` 2) | otherwise = m
    go p m | m == 1        = []
           | p * p > m     = [m]
           | m `mod` p == 0 = p : go p (strip m)
           | otherwise     = go (p + 2) m
      where strip k | k `mod` p == 0 = strip (k `div` p) | otherwise = k

-- the whole ledger row of one pair: (place, symbol) at every bad place
ledger :: Integer -> Integer -> [(String, Integer)]
ledger a b =
  ("infinity", hilbertInf a b)
  : ("2", hilbert2 a b)
  : [ (show p, hilbertOdd p a b) | p <- oddPrimeDivisors (a * b) ]

balance :: Integer -> Integer -> Integer
balance a b = product (map snd (ledger a b))

-- ───────────────────────────────────────────── main: the four checks

primesTo :: Integer -> [Integer]
primesTo n = sieve [2 .. n]
  where sieve []       = []
        sieve (p : xs) = p : sieve [x | x <- xs, x `mod` p /= 0]

main :: IO ()
main = do
  let nBox   = 60
      pairs  = [ (a, b) | a <- [-nBox .. nBox], a /= 0
                        , b <- [-nBox .. nBox], b /= 0 ]

      -- १ · the balance
      unbalanced = [ (a, b) | (a, b) <- pairs, balance a b /= 1 ]

      -- २ · drop the infinite column
      finiteOnly (a, b) = product [ s | (v, s) <- ledger a b, v /= "infinity" ]
      brokenNoInf   = length [ () | pr <- pairs, finiteOnly pr /= 1 ]
      doublyNegative = length [ () | (a, b) <- pairs, a < 0, b < 0 ]

      -- ३ · drop the column at 2
      no2 (a, b) = product [ s | (v, s) <- ledger a b, v /= "2" ]
      brokenNo2 = length [ () | pr <- pairs, no2 pr /= 1 ]

      -- ४ · the shadow: Gauss extracted back out, plus both supplements
      ops = drop 1 (primesTo 97)          -- odd primes ≤ 97
      recipBad = [ (p, q) | p <- ops, q <- ops, p < q
                 , legendre p q * legendre q p
                     /= (if odd (epsO p * epsO q) then -1 else 1) ]
      supBad = [ p | p <- ops
               , legendre (-1) p /= (if epsO p == 1 then -1 else 1)
                 || legendre 2 p /= (if omg p == 1 then -1 else 1) ]

  putStrLn "═══ समं लेख्यम् · the Hilbert product balances at every place ═══"
  putStrLn ""
  putStrLn ("१ · THE BALANCE over |a|,|b| <= " ++ show nBox
            ++ ": " ++ show (length pairs) ++ " pairs, "
            ++ show (length unbalanced) ++ " unbalanced.")
  putStrLn "    (every pair's product over infinity, 2, and the odd primes"
  putStrLn "     dividing ab is exactly 1 — the total was always zero.)"
  putStrLn ""
  putStrLn "    one row shown whole, the receipt of (-7,-15):"
  mapM_ (\(v, s) -> putStrLn ("      place " ++ v ++ " : " ++ show s))
        (ledger (-7) (-15))
  putStrLn ("      product      : " ++ show (balance (-7) (-15)))
  putStrLn ""
  putStrLn ("२ · SINGLE-ENTRY CONTROL — the infinite column dropped: "
            ++ show brokenNoInf ++ " pairs break; pairs with a<0 and b<0: "
            ++ show doublyNegative ++ "."
            ++ (if brokenNoInf == doublyNegative
                then "  EQUAL: the archimedean column carries exactly the joint-sign charge and nothing else."
                else "  NOT EQUAL — a formula above is wrong."))
  putStrLn ""
  putStrLn ("३ · FIRST-VEIL CONTROL — the column at 2 dropped: "
            ++ show brokenNo2 ++ " of " ++ show (length pairs)
            ++ " pairs break.  That is how much of this box's ledger the")
  putStrLn "    smallest prime carries; counted, not estimated."
  putStrLn ""
  putStrLn ("४ · THE SHADOW — Gauss extracted back out: all odd prime pairs"
            ++ " p<q<=97: " ++ show (length recipBad) ++ " violations;"
            ++ " supplements (-1|p),(2|p): " ++ show (length supBad)
            ++ " violations.")
  putStrLn ""
  if null unbalanced && brokenNoInf == doublyNegative
     && null recipBad && null supBad
    then do
      putStrLn "ALL CHECKS HOLD.  Loss is always local; globally the books"
      putStrLn "have always balanced; and the column physics forgets is the"
      putStrLn "one that pays for all the others.   समं लेख्यम् ॥"
      exitSuccess
    else do
      putStrLn "A CHECK FAILED — the failing objects are the finding:"
      mapM_ print (take 10 unbalanced)
      mapM_ print (take 10 recipBad)
      exitFailure
