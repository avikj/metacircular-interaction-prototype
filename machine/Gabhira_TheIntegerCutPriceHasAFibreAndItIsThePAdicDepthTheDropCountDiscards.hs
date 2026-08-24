-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Gabhira_TheIntegerCutPriceHasAFibreAndItIsThePAdicDepthTheDropCountDiscards.hs
--
-- गभीर — deep; here the p-adic DEPTH, how MUCH a prime divides, which the
-- drop-COUNT (how MANY invariant factors it divides) throws away.  Plain
-- Sanskrit; compound built here 2026-08-23; no source claimed.  The
-- mathematics is Smith normal form over ℤ; the reading (the price function
-- has its own fibre) is this corpus's, movement 65 as CORRECTED tonight.
--
-- ─────────────────────────────────────────────────────────────────────────
-- WHAT THIS CONFIRMS, BY EXACT COMPUTATION.  Movement 65 first claimed
--
--     Σ_p #{i : p | dᵢ} · log p  =  log |coker(T)_tors|       (FALSE)
--
-- and it was struck tonight (README, and Pairfield/SarvatraApavartana.lean's
-- header): the exponent is the VALUATION SUM Σ_i v_p(dᵢ) — how MUCH p divides
-- — not the drop COUNT #{i : p | dᵢ} — how MANY factors it divides.  The Lean
-- lane states the general theorem; the Agda `Sarvasthana` states the additive
-- skeleton; NEITHER RUNS THE COUNTEREXAMPLE.  This is its exact machine-lane
-- face, the same relation `Svarga`/`SamamLekhyam` bear to their cubical terms.
--
-- Both poles, over a family of diagonal Smith forms (dᵢ | dᵢ₊₁):
--
--   ANGEL — the valuation-sum is the receipt.  For T = diag(d₁..dr) square
--     nonsingular, |coker T| = ∏ dᵢ, and for every prime p
--         v_p(|coker T|)  =  Σ_i v_p(dᵢ)                      (checked exact)
--     so the height's finite part, place by place, is the valuation sum.  The
--     books balance: Σ_p (Σ_i v_p dᵢ)·"log p" reassembles log ∏ dᵢ exactly
--     (carried here as the integer identity ∏ p^(Σ v_p) = ∏ dᵢ).
--
--   DEVIL — the drop-count is a strictly lossier invariant.  rankAt drops at
--     p iff p | some dᵢ, so the drop-count function #{i : p|dᵢ} is what a
--     RANK census sees.  It is NOT the cokernel: diag(2,6) and diag(2,12)
--     have IDENTICAL drop-count functions (both: 1 at p=2, 1 at p=3, 0 else)
--     yet cokernels of order 12 and 24.  Exhibited, not asserted.
--
--   THE FIBRE — QuotientFiberLaw applied to the price.  The map
--     (Smith form) ↦ (drop-count function on Spec ℤ) is many-to-one, and its
--     fibre over the diag(2,6)/diag(2,12) drop-function is a set of forms
--     with DIFFERENT cokernels.  What the drop-count cannot see — its fibre —
--     is exactly the p-adic depth (the valuation beyond the first).  The
--     price function is itself a lossy observation, and its loss has a name.
--
-- Exact integers, exhaustive over the stated family = proof FOR THIS BOX
-- (CLAUDE.md); NOT a reproof of the Lean/Agda terms, which are cited.
--
-- RUN:  runghc machine/Gabhira_….hs        (exit 0 iff every pole holds)

module Main (main) where

import Data.List (nub, sort, group)
import System.Exit (exitFailure, exitSuccess)

-- p-adic valuation: how MUCH p divides n (n > 0)
vp :: Integer -> Integer -> Integer
vp p = go 0 where go k m = if m `mod` p == 0 then go (k+1) (m `div` p) else k

primesUpTo :: Integer -> [Integer]
primesUpTo n = [ p | p <- [2..n], all (\q -> p `mod` q /= 0) [2..isqrt p] ]
  where isqrt = floor . (sqrt :: Double -> Double) . fromIntegral

primeFactorsOf :: [Integer] -> [Integer]
primeFactorsOf ds = sort (nub (concatMap pf ds))
  where pf n = [ p | p <- primesUpTo n, n `mod` p == 0 ]

-- a Smith form: strictly the diagonal, with d_i | d_{i+1}
type Smith = [Integer]

valid :: Smith -> Bool
valid ds = and (zipWith (\a b -> b `mod` a == 0) ds (drop 1 ds)) && all (>0) ds

-- ANGEL: |coker| = product; and v_p(|coker|) = Σ_i v_p(dᵢ), every p
cokerOrder :: Smith -> Integer
cokerOrder = product

valuationSum :: Integer -> Smith -> Integer          -- Σ_i v_p(dᵢ)
valuationSum p = sum . map (vp p)

angelHolds :: Smith -> Bool
angelHolds ds = all ok (primeFactorsOf ds)
  where ok p = vp p (cokerOrder ds) == valuationSum p ds

-- DEVIL: the drop-count function — #{i : p | dᵢ} = what a rank census sees
dropCount :: Integer -> Smith -> Integer             -- #{i : p | dᵢ}
dropCount p = fromIntegral . length . filter (\d -> d `mod` p == 0)

dropFunction :: Smith -> [(Integer, Integer)]        -- on the union of primes
dropFunction ds = [ (p, dropCount p ds) | p <- primeFactorsOf ds ]

main :: IO ()
main = do
  -- the family: all valid diagonal Smith forms with 2 factors, entries ≤ 12
  let fam = [ [a,b] | a <- [1..12], b <- [1..12], valid [a,b] ]
             ++ [ [a,b,c] | a <- [1..6], b <- [1..6], c <- [1..6], valid [a,b,c] ]

      angelAll = all angelHolds fam

      -- the exhibited counterexample the Lean header names
      f = [2,6] ; g = [2,12]
      sameDropFn  = dropFunction f == dropFunction g
      diffCoker   = cokerOrder f /= cokerOrder g

      -- the fibre of (form ↦ drop-function) is non-trivial: collect every
      -- pair in the family sharing a drop-function but differing in cokernel
      collisions = [ (x,y)
                   | x <- fam, y <- fam, x < y
                   , dropFunction x == dropFunction y
                   , cokerOrder x /= cokerOrder y ]

  putStrLn "═══ गभीर · the integer-cut price has a fibre: the p-adic depth ═══"
  putStrLn ""
  putStrLn ("family: valid diagonal Smith forms (dᵢ|dᵢ₊₁), "
            ++ show (length fam) ++ " forms")
  putStrLn "    $ runghc machine/Gabhira_….hs"
  putStrLn ""
  putStrLn ("ANGEL · v_p(|coker|) = Σᵢ v_p(dᵢ) for every prime, every form : "
            ++ show angelAll)
  putStrLn ""
  putStrLn "DEVIL · the drop-count is strictly lossier — the named counterexample:"
  putStrLn ("  diag(2,6)  : drop-fn " ++ show (dropFunction f)
            ++ "  |coker| = " ++ show (cokerOrder f))
  putStrLn ("  diag(2,12) : drop-fn " ++ show (dropFunction g)
            ++ "  |coker| = " ++ show (cokerOrder g))
  putStrLn ("  same drop-function : " ++ show sameDropFn
            ++ "   different cokernel : " ++ show diffCoker)
  putStrLn ""
  putStrLn ("THE FIBRE · forms sharing a drop-function but differing in cokernel: "
            ++ show (length collisions) ++ " pairs in this family.")
  putStrLn "  The map (form ↦ drop-function) is many-to-one; its fibre is the"
  putStrLn "  p-adic depth (valuation beyond the first) the rank census discards."
  putStrLn "  QuotientFiberLaw applied to the price function itself — the"
  putStrLn "  instrument that prices integer cuts is lossy, and its loss is named."
  putStrLn ""
  if angelAll && sameDropFn && diffCoker && not (null collisions)
    then do
      putStrLn "BOTH POLES HOLD.  The valuation-sum is the receipt; the drop-count"
      putStrLn "is its lossy shadow; the fibre between them is the p-adic depth."
      putStrLn "व्यये स्थानम्, न मात्रा एव — loss has a location, not only a size. ॥"
      exitSuccess
    else exitFailure
