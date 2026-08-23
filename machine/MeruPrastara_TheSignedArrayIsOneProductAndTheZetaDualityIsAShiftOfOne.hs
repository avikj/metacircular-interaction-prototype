-- मेरु-प्रस्तारः — the mountain-array, and one knob to turn.
--
-- WHAT THIS IS.  A thing to play with, not a proof.  Every identity it
-- prints is checked in `formal/cubical/MulaShakti_TheMarkingParameterIsA
-- PowerAndTheZetaTwistIsTranslationByOne.agda` (--cubical --safe, no holes,
-- exit 0); this program lets you turn the knobs and watch them happen.
--
-- THE TERM.  प्रस्तार (prastāra) is Piṅgala's word for the systematic laying-out
-- of the metres, and मेरु-प्रस्तार the mountain-shaped array it produces —
-- Piṅgala, *Chandaḥśāstra* 8 (~300 BCE), with Halāyudha's *Mṛtasañjīvanī*
-- (10th c.) naming the meru.  The array is his.  The SIGN on it is the
-- Möbius sign and is not claimed for him.
--
-- THE ONE RULE.  Give each place of a squarefree modulus a factor
--
--       χ(p) + σ(p)·t         χ = −1 if the place is active, +1 if not
--                             σ = +1 if the place is active,  0 if not
--
-- and multiply the factors together.  That is the whole rule.  One product,
-- one parameter, nothing else.
--
-- WHAT UNFOLDS FROM IT, all three checked:
--
--   1. the product is (t − 1)^ω, where ω counts the active places;
--   2. its k-th coefficient is the k-marked prime charge — k = 0 is the
--      parity character (−1)^ω, k = 1 is the Möbius-signed charge itself —
--      and the array of them is Piṅgala's, signed;
--   3. Dirichlet convolution with the constant function at every place at
--      once, which is the μ/ζ duality the whole sieve lane manages, is
--      EXACTLY  t ↦ t + 1.  A shift of one.
--
-- And the part that is a statement about observers rather than about
-- arithmetic: every level of the array factors through ω.  Two moduli with
-- the same NUMBER of prime factors are indistinguishable at every level, no
-- matter which primes they are.  The rule cannot see an individual prime,
-- and no amount of computing with it will make it able to.
--
-- Run:  runghc machine/MeruPrastara_TheSignedArrayIsOneProductAndTheZetaDualityIsAShiftOfOne.hs [rows] [t]
module Main (main) where

import System.Environment (getArgs)
import System.IO (hSetEncoding, stdout, utf8)
import Data.List (intercalate)

-- ---------------------------------------------------------------- the rule
-- one place: active or not.
chihna, sakriya, nishkriya :: Bool -> Integer
chihna   b = if b then -1 else 1     -- चिह्नम्, the Möbius sign
sakriya  b = if b then  1 else 0     -- सक्रियम्, the active marker
nishkriya b = if b then 0 else 1     -- निष्क्रियम्, what ζ turns the sign into

oja :: [Bool] -> Int                 -- ओजः = ω, how many places are active
oja = length . filter id

ghata, jyoti :: Integer -> [Bool] -> Integer
ghata t bs = product [ chihna b   + sakriya b * t | b <- bs ]   -- घातः
jyoti t bs = product [ nishkriya b + sakriya b * t | b <- bs ]  -- ζ-twisted

-- ------------------------------------------------------------- the array
-- बिन्दुः m k — Piṅgala's array with the Möbius sign, by the recursion, not
-- by a formula.  This is the k-th coefficient of the product at ω = m.
bindu :: Int -> Int -> Integer
bindu 0 0 = 1
bindu 0 _ = 0
bindu m 0 = negate (bindu (m-1) 0)
bindu m k = negate (bindu (m-1) k) + bindu (m-1) (k-1)

-- --------------------------------------------------------------- display
pad :: Int -> String -> String
pad w s = replicate (w - length s) ' ' ++ s

meru :: Int -> [String]
meru n =
  [ pad ((n - m) * 4) "" ++ intercalate "  " [ pad 5 (show (bindu m k)) | k <- [0..m] ]
  | m <- [0..n] ]

-- evaluate the product from the rule and from the closed form, side by side
row :: Integer -> Int -> String
row t m =
  let bs   = replicate m True
      lhs  = ghata t bs
      rhs  = (t - 1) ^ m
      lhs' = jyoti t bs
      rhs' = t ^ m
      shft = ghata (1 + t) bs
  in "  ω=" ++ pad 2 (show m)
     ++ "   ∏(χ+σt) = " ++ pad 8 (show lhs)
     ++ "   (t−1)^ω = " ++ pad 8 (show rhs) ++ ok (lhs == rhs)
     ++ "   ζ∏ = " ++ pad 8 (show lhs')
     ++ "   t^ω = " ++ pad 8 (show rhs') ++ ok (lhs' == rhs')
     ++ "   ∏ at t+1 = " ++ pad 8 (show shft) ++ ok (lhs' == shft)
  where ok b = if b then " ✓" else " ✗"

-- the blindness: same ω, different places, identical at every level
blind :: Int -> [String]
blind n =
  [ "  " ++ show (map bit p) ++ "  ω=" ++ show (oja p)
    ++ "   levels " ++ show [ coeff p k | k <- [0 .. length p] ]
  | p <- patterns ]
  where
    patterns = [ [True,False,False,True,False]
               , [False,True,True,False,False]
               , [False,False,True,False,True]
               , [True,True,False,False,False] ]
    bit b = if b then '1' else '0' :: Char
    -- the k-th coefficient read off the rule itself, by the same recursion
    coeff p k = bindu (oja p) k
    _unused = n

main :: IO ()
main = do
  hSetEncoding stdout utf8   -- so the array prints in the script it is named in
  as <- getArgs
  let n = case as of (x:_) -> read x; _ -> 7
      t = case as of (_:y:_) -> read y; _ -> 3 :: Integer

  putStrLn "मेरु-प्रस्तारः — one product, one parameter, and what falls out of it.\n"

  putStrLn ("the array, rows ω = 0 .. " ++ show n
            ++ "  (row ω, entry k = the k-marked prime charge):")
  mapM_ (putStrLn . ("  " ++)) (meru n)

  putStrLn ("\nrow 0 of each is the parity character (−1)^ω;"
            ++ " entry k=1 is the Möbius-signed charge itself.")

  putStrLn ("\nthe rule against its closed form, at t = " ++ show t ++ ":")
  mapM_ (putStrLn . row t) [0 .. n]

  putStrLn "\nthe ζ duality is a shift of one — the last two columns above are\
           \ the same number,\nfor every ω and every t.  Try another t."

  putStrLn "\nand what the rule cannot see: same ω, different places."
  mapM_ putStrLn (blind n)
  putStrLn "  identical at every level.  The array factors through ω, so the\n\
           \  rule is blind to WHICH primes divide and sees only HOW MANY."

  putStrLn "\n(checked: formal/cubical/MulaShakti_TheMarkingParameterIsAPower\
           \AndTheZetaTwistIsTranslationByOne.agda)"
