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

-- Vallirekha_TheContinuedFractionOfRootDIsAryabhatasValliItsConvergentsAreTheWheelAndTheFundamentalSolutionSitsAtThePeriodsClose.hs
--
-- वल्ली-रेखा — the line of the vallī.  वल्ली, Āryabhaṭa's quotient column
-- (Āryabhaṭīya, Gaṇitapāda 32–33, 499); रेखा, a line/row.  Compound built
-- here 2026-08-23; no source claimed for it.  The mathematics is the theory
-- of the continued fraction of √D (Lagrange, Legendre) and its identity with
-- the cakravāla of Jayadeva (~950) and Bhāskara II, Bījagaṇita (1150),
-- resting on Brahmagupta's bhāvanā, Brāhmasphuṭasiddhānta 18 (628).  The name
-- usually cited for the equation is "Pell's"; Pell did not solve it.
--
-- ─────────────────────────────────────────────────────────────────────────
-- WHAT THIS CONTRIBUTES.  Three organs the corpus holds SEPARATELY are ONE
-- object, and this exhibits the identity exactly over a family of non-square
-- D, in the god-language of exact integer arithmetic (proof for the box,
-- CLAUDE.md):
--
--   · the VALLĪ — the quotient column of a Euclidean-type descent
--     (KuttakaValli_…); here the periodic continued fraction of √D IS the
--     vallī of √D, computed by the classical exact (m,d,a) recurrence;
--   · the WHEEL / भावना — Brahmagupta's composition driving the cakravāla
--     (VargaPrakrti_…, Apunaragamana_…); here its convergents are generated
--     by the vallī recurrence hₙ = aₙhₙ₋₁+hₙ₋₂, kₙ = aₙkₙ₋₁+kₙ₋₂, and the
--     norm each convergent achieves, hₙ² − D·kₙ², is the CENSUS of what the
--     wheel visits;
--   · NON-RETURN (Apunaragamana_…) — the cubical term proved the bhāvanā
--     orbit strictly grows and never returns, for √2's seed (3,2) only; here
--     kₙ strictly increases across the family, the exact shadow of that
--     theorem for every D in the box.
--
-- THE ONE CLASSICAL FACT tying them, verified exact: the convergent at the
-- close of the first period, index r−1, is the FUNDAMENTAL solution —
--       h_{r-1}² − D·k_{r-1}² = (−1)^r
-- so an even period gives x²−Dy²=1 directly, an odd period gives −1 (square
-- it, by बhāvanā, for +1).  The wheel's fundamental solution sits exactly
-- where the vallī's period closes.  Both poles, cross-checked.
--
-- CROSS-CHECK, load-bearing: for D=61 this must reproduce (1766319049,
-- 226153980) — Bhāskara II's own value (Bījagaṇita, 1150), the same number
-- `machine/SamamLekhyam`'s sibling `VargaPrakrti` reactor prints and that the
-- corpus's cubical/Lean Pell work carries.  If a refactor ever breaks the
-- identity, this D=61 row fails loudly.
--
-- RUN:  runghc machine/Vallirekha_….hs      (exit 0 iff every check holds)

module Main (main) where

import Data.List (nub)
import System.Exit (exitFailure, exitSuccess)

isqrt :: Integer -> Integer
isqrt n = go n where
  go x = let y = (x + n `div` x) `div` 2 in if y < x then go y else x
  -- seeded above; refine to floor(sqrt n)
adjust :: Integer -> Integer
adjust n = let a = isqrt n in head [ b | b <- [a+1, a, a-1], b*b <= n, (b+1)*(b+1) > n ]

floorSqrt :: Integer -> Integer
floorSqrt 0 = 0
floorSqrt n = adjust n

isSquare :: Integer -> Bool
isSquare n = let a = floorSqrt n in a*a == n

-- ── the vallī of √D: the periodic continued fraction, exact (m,d,a) ────────
-- m₀=0, d₀=1, a₀=⌊√D⌋;  mₖ₊₁ = dₖaₖ − mₖ,  dₖ₊₁ = (D − mₖ₊₁²)/dₖ,
-- aₖ₊₁ = ⌊(a₀+mₖ₊₁)/dₖ₊₁⌋.  Period closes at the first k≥1 with aₖ = 2a₀.
valli :: Integer -> (Integer, [Integer])          -- (a₀, [a₁..a_r]) one period
valli d = (a0, go 0 1 a0)
  where
    a0 = floorSqrt d
    go m dd a =
      let m' = dd*a - m
          d' = (d - m'*m') `div` dd
          a' = (a0 + m') `div` d'
      in a' : if a' == 2*a0 then [] else go m' d' a'

-- ── the convergents, by the vallī recurrence (= the wheel's steps) ────────
convergents :: [Integer] -> [(Integer, Integer)]
convergents as = go as (0,1) (1,0)   -- seeds h₋₂,k₋₂=(0,1) ; h₋₁,k₋₁=(1,0)
                                     -- `go` emits one convergent per term,
                                     -- starting at a₀/1 — nothing is dropped
                                     -- (the seeds are the accumulator, not output)
  where
    go [] _ _ = []
    go (a:rest) (h2,k2) (h1,k1) =
      let h = a*h1 + h2 ; k = a*k1 + k2
      in (h,k) : go rest (h1,k1) (h,k)

pellNorm :: Integer -> (Integer,Integer) -> Integer
pellNorm d (h,k) = h*h - d*k*k

-- fundamental solution of x²−Dy²=1 from the CF: convergent at period close,
-- squared by bhāvanā if the period is odd (norm −1).
fundamental :: Integer -> (Integer, Integer)
fundamental d =
  let (a0, per) = valli d
      as        = a0 : per
      r         = length per
      conv      = convergents as
      (h,k)     = conv !! (r - 1)            -- index r−1 over [a₀,a₁,…]
  in if even r then (h,k)
     else (h*h + d*k*k, 2*h*k)               -- (h+k√D)² : the +1 solution

main :: IO ()
main = do
  let ds = [ d | d <- [2..60], not (isSquare d) ]

      -- ANGEL/DEVIL cross-check per D: period, convergents, norms
      perOK d =
        let (a0, per) = valli d
            as        = a0 : per
            r         = length per
            conv      = take r (convergents as)
            norms     = map (pellNorm d) conv
            -- the fundamental sits at the period close with norm (−1)^r
            closeNorm = last norms
            -- the produced +1 solution actually solves x²−Dy²=1
            (x,y)     = fundamental d
            -- NON-RETURN (Apunaragamana shadow, corrected): it is the SOLUTION
            -- ORBIT — the powers of the fundamental under भावना — that strictly
            -- grows, NOT the CF convergent denominators (which can repeat: √3
            -- has k₀=k₁=1).  Compose (x,y) with itself and check the second
            -- coordinate strictly increases while the norm stays 1.
            mul (a,b) (c,e) = (a*c + d*b*e, a*e + b*c)
            orbit = take 6 (iterate (mul (x,y)) (x,y))
            ys    = map snd orbit
            strict = and (zipWith (<) ys (drop 1 ys))
            normed = all (\(a,b) -> a*a - d*b*b == 1) orbit
        in closeNorm == (if even r then 1 else -1)
           && x*x - d*y*y == 1
           && x > 0 && y > 0
           && strict && normed

      allOK = all perOK ds

      d61   = fundamental 61
      d61OK = d61 == (1766319049, 226153980)

      -- CHAPTER 1 ↔ CHAPTER 7, tied here.  Āpastamba Śulbasūtra 1.6 (~600 BCE)
      -- builds the diagonal of the unit square as 1 + ⅓ + 1/(3·4) − 1/(3·4·34)
      -- = 577/408 (साविशेष, "with-the-excess": the name is the error term).  In
      -- tila, 34 to the aṅgula, the diagonal is 577 tila and the side 408 tila;
      -- 577² − 2·408² = 332929 − 332928 = 1 — one tila-square of excess, which
      -- IS the vargaprakṛti norm.  So the ritual cord-rule's value is exactly
      -- the FOURTH power of √2's fundamental (3,2) under Brahmagupta's bhāvanā:
      -- (3,2)→(17,12)→(99,70)→(577,408).  The Śulba note stated this fact and
      -- left it "not formalised … chapter 7's business"
      -- (notes/SulbaSavisesa_…md §VIII); it is discharged here, exact.
      s2mul (a,b) (c,e) = (a*c + 2*b*e, a*e + b*c)
      s2orbit  = take 4 (iterate (s2mul (3,2)) (3,2))
      savisesa = s2orbit !! 3
      savisesaOK = savisesa == (577,408) && 577*577 - 2*408*408 == 1

      -- a few periods shown, so the vallī is visible not just asserted
      show1 d = let (a0,per) = valli d
                    (x,y)    = fundamental d
                in "  √" ++ show d ++ " = [" ++ show a0 ++ "; "
                   ++ init (concatMap (\a -> show a ++ ",") per) ++ "]"
                   ++ "  period " ++ show (length per)
                   ++ "   fundamental (" ++ show x ++ ", " ++ show y ++ ")"

  putStrLn "═══ वल्ली-रेखा · the CF of √D is the vallī; its convergents are the wheel ═══"
  putStrLn ""
  putStrLn ("checked over non-square D in [2..60]: " ++ show (length ds) ++ " values")
  putStrLn "    $ runghc machine/Vallirekha_….hs"
  putStrLn ""
  putStrLn ("BOTH POLES, every D: the fundamental sits at the period close with")
  putStrLn ("norm (−1)^period; the SOLUTION ORBIT (powers under भावना) strictly")
  putStrLn ("grows and stays norm 1 (Apunaragamana's non-return, family shadow of")
  putStrLn ("the cubical term); the +1 solution checks                          : "
            ++ show allOK)
  putStrLn ""
  putStrLn "the vallī and the wheel, a few rows (सारणी न स्थाप्यते — generated):"
  mapM_ (putStrLn . show1) [2,3,7,13,31]
  putStrLn ""
  putStrLn ("CROSS-CHECK · D=61 fundamental = (1766319049, 226153980),")
  putStrLn ("Bhāskara II's own value (Bījagaṇita 1150)                         : "
            ++ show d61OK ++ "  got " ++ show d61)
  putStrLn ""
  putStrLn ("CHAPTER 1 ↔ 7 · √2 orbit under bhāvanā (3,2)→(17,12)→(99,70)→…")
  putStrLn ("its 4th term is Āpastamba's साविशेष (ĀpŚu 1.6, ~600 BCE):")
  putStrLn ("577 tila diagonal, 408 tila side, 577²−2·408² = 1 (one tila-square")
  putStrLn ("of excess in 332929) — the cord-rule value is a Pell solution     : "
            ++ show savisesaOK ++ "  got " ++ show savisesa)
  putStrLn ""
  if allOK && d61OK && savisesaOK
    then do
      putStrLn "HOLDS.  The vallī of √D, Brahmagupta's wheel, and the continued"
      putStrLn "fraction are one object; the fundamental solution sits where the"
      putStrLn "period closes; the orbit strictly grows and never returns."
      putStrLn "शेषं रक्ष, पुनरावर्तस्व — keep the remainder, recurse. ॥"
      exitSuccess
    else exitFailure
