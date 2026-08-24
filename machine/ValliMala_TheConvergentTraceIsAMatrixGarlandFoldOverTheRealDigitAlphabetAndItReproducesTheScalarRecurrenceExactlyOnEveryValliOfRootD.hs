-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- ValliMala_TheConvergentTraceIsAMatrixGarlandFoldOverTheRealDigitAlphabetAndItReproducesTheScalarRecurrenceExactlyOnEveryValliOfRootD.hs
--
-- वल्ली-माला — the garland of the vallī.  वल्ली, Āryabhaṭa's quotient column
-- (Āryabhaṭīya, Gaṇitapāda 32–33, 499); माला, garland — the free-monoid image
-- taken from `formal/cubical/MalaSetu_….agda`, which this file serves.  Both
-- words ordinary; the compound is built here 2026-08-23, no source claimed.
--
-- ─────────────────────────────────────────────────────────────────────────
-- WHAT THIS CONTRIBUTES, and WHOSE SEAM IT CLOSES.
--
-- `MalaSetu_….agda` (cubical, --safe, landed tonight) proved that Piṅgala's
-- घात (exponentiation, alphabet Unit) and the vallī trace (alphabet R, the
-- quotient digits) are TWO ALPHABETS of ONE free-monoid homomorphism
-- `foldMap` into a monoid.  It states TWO limits IN ITS OWN HEADER:
--
--   · §5 exhibits the R-alphabet (vallī) instance only on a TOY 2-state
--     transformation monoid, "so instance (I) is a checked term and not only
--     prose" — NOT on the real digit alphabet and its real matrix monoid;
--   · it does NOT claim `replay` and `foldMap L` are the SAME TERM as
--     `KuttakaValli`'s, because that module is parametrised by its own monoid
--     and is not imported.
--
-- This is the machine-lane face of exactly that R-instance, on REAL data.
-- The continued fraction [a₀; a₁, …] has convergents (hₙ, kₙ) given by the
-- MATRIX product
--
--     M(a₀)·M(a₁)···M(aₙ)  =  [[hₙ, hₙ₋₁], [kₙ, kₙ₋₁]],   M(a) = [[a,1],[1,0]]
--
-- which is precisely `foldMap` into the (NON-commutative) monoid of 2×2
-- integer matrices, over the garland of vallī digits — the R-alphabet
-- instance MalaSetu named.  Two poles, exact, over the vallī of √D for a
-- family of non-square D:
--
--   ANGEL — the fold IS the trace.  The matrix garland-fold over the real
--     digits [a₀,…,a_{r-1}] reproduces Vallirekha's scalar 3-term convergent
--     (h_{r-1}, k_{r-1}) EXACTLY, every D.  The abstract `foldMap` and the
--     concrete cakravāla/kuṭṭaka convergent are one map on real data, not a
--     resemblance and not a toy.
--
--   DEVIL — the monoid is genuinely non-commutative, so the order of the
--     garland is content, not decoration.  Exhibited: two real vallī digits
--     a≠b give M(a)·M(b) ≠ M(b)·M(a).  This is why MalaSetu insisted on the
--     assoc-only (non-commutative) homomorphism law; here it bites on the
--     actual digits.  And मालायोगः (foldMap of a concatenation splits) is
--     re-exhibited on a real vallī garland split in the real matrix monoid —
--     the law §5 could only show on {t0,t1}.
--
-- CROSS-CHECK, load-bearing: at D=61 the fold must deliver the same
-- (1766319049, 226153980) after the odd-period square, Bhāskara II's value
-- (Bījagaṇita 1150).  Exact integers, exhaustive over the box = proof FOR
-- THIS BOX (CLAUDE.md); NOT a reproof of MalaSetu's general cubical term,
-- which is cited.
--
-- RUN:  runghc machine/ValliMala_….hs        (exit 0 iff every pole holds)

module Main (main) where

import System.Exit (exitFailure, exitSuccess)

-- ── floor √D, exact (integer Newton), and squareness ──────────────────────
isqrt :: Integer -> Integer
isqrt n = go n where go x = let y = (x + n `div` x) `div` 2 in if y < x then go y else x
adjust :: Integer -> Integer
adjust n = let a = isqrt n in head [ b | b <- [a+1,a,a-1], b*b <= n, (b+1)*(b+1) > n ]
floorSqrt :: Integer -> Integer
floorSqrt 0 = 0
floorSqrt n = adjust n
isSquare :: Integer -> Bool
isSquare n = let a = floorSqrt n in a*a == n

-- ── the vallī of √D: one period of the CF, exact (m,d,a) recurrence ────────
valli :: Integer -> (Integer, [Integer])
valli d = (a0, go 0 1 a0)
  where
    a0 = floorSqrt d
    go m dd a =
      let m' = dd*a - m ; d' = (d - m'*m') `div` dd ; a' = (a0 + m') `div` d'
      in a' : if a' == 2*a0 then [] else go m' d' a'

-- ── the SCALAR trace (Vallirekha's map): 3-term convergent recurrence ──────
convergents :: [Integer] -> [(Integer,Integer)]
convergents = go (0,1) (1,0)
  where
    go _ _ []          = []
    go (h2,k2) (h1,k1) (a:rest) =
      let h = a*h1 + h2 ; k = a*k1 + k2 in (h,k) : go (h1,k1) (h,k) rest

-- ── the MATRIX garland-fold (MalaSetu's foldMap into the 2×2 ℤ monoid) ─────
-- a 2×2 integer matrix [[p,q],[r,s]] as (p,q,r,s); M(a) = [[a,1],[1,0]].
type Mat = (Integer,Integer,Integer,Integer)
idM :: Mat
idM = (1,0,0,1)
mm :: Mat -> Mat -> Mat                                   -- the monoid ⋆
mm (p,q,r,s) (p',q',r',s') =
  (p*p'+q*r', p*q'+q*s', r*p'+s*r', r*q'+s*s')
gen :: Integer -> Mat                                     -- the column map L
gen a = (a,1,1,0)
-- foldMap gen : List ℤ → Mat  (left fold, matching M(a₀)·…·M(aₙ))
foldMat :: [Integer] -> Mat
foldMat = foldl (\acc a -> mm acc (gen a)) idM

-- the convergent (hₙ,kₙ) read off the fold over [a₀..aₙ]: top-left, bottom-left
foldConv :: [Integer] -> (Integer,Integer)
foldConv as = let (p,_,r,_) = foldMat as in (p,r)

-- ── the fundamental, both ways, matching Vallirekha's odd-period squaring ──
fundamentalFrom :: Integer -> (Integer,Integer) -> Integer -> (Integer,Integer)
fundamentalFrom d (h,k) r =
  if even r then (h,k) else (h*h + d*k*k, 2*h*k)

main :: IO ()
main = do
  let ds = [ d | d <- [2..60], not (isSquare d) ]

      -- per D: the digits actually used for the fundamental convergent
      digitsFor d = let (a0,per) = valli d
                        r        = length per
                    in (a0, per, r, take r (a0 : per))   -- [a₀ .. a_{r-1}]

      -- ANGEL: matrix fold == scalar recurrence, at the fundamental index
      angel d =
        let (a0,per,r,used) = digitsFor d
            as              = a0 : per
            scalarConv      = convergents as !! (r-1)     -- (h_{r-1},k_{r-1})
            matrixConv      = foldConv used
        in scalarConv == matrixConv
           && fundamentalFrom d scalarConv (toInteger r)
              == fundamentalFrom d matrixConv (toInteger r)

      angelAll = all angel ds

      -- DEVIL: the real 2×2 ℤ monoid is non-commutative on real vallī digits
      -- take √7's period [1,1,1,4]: pick two distinct digits present, 1 and 4
      nonComm = mm (gen 1) (gen 4) /= mm (gen 4) (gen 1)

      -- मालायोगः on a REAL garland split (the homomorphism law §5 could only
      -- show on the toy monoid): fold(xs++ys) = fold xs ⋆ fold ys, √13's vallī
      (_,per13) = valli 13
      xs13      = take 2 per13 ; ys13 = drop 2 per13
      homSplit  = foldMat (xs13 ++ ys13) == mm (foldMat xs13) (foldMat ys13)

      -- CROSS-CHECK: D=61 via the matrix fold reaches Bhāskara II's value
      (a061,per61) = valli 61
      r61          = length per61
      used61       = take r61 (a061 : per61)
      d61          = fundamentalFrom 61 (foldConv used61) (toInteger r61)
      d61OK        = d61 == (1766319049, 226153980)

  putStrLn "═══ वल्ली-माला · the convergent trace is a matrix garland-fold (foldMap) ═══"
  putStrLn ""
  putStrLn ("checked over non-square D in [2..60]: " ++ show (length ds) ++ " values")
  putStrLn "    $ runghc machine/ValliMala_….hs"
  putStrLn ""
  putStrLn ("ANGEL · matrix fold ∏[[aᵢ,1],[1,0]] over real vallī digits equals")
  putStrLn ("Vallirekha's scalar 3-term convergent, every D (the fold IS the")
  putStrLn ("trace — MalaSetu's R-alphabet instance on REAL data)             : "
            ++ show angelAll)
  putStrLn ""
  putStrLn ("DEVIL · the 2×2 ℤ monoid is non-commutative on real digits")
  putStrLn ("(M(1)·M(4) ≠ M(4)·M(1), √7's vallī): order is content            : "
            ++ show nonComm)
  putStrLn ("मालायोगः on a real vallī split (√13): fold(xs++ys)=fold xs ⋆ fold ys : "
            ++ show homSplit)
  putStrLn ""
  putStrLn ("CROSS-CHECK · D=61 by the matrix fold = (1766319049, 226153980),")
  putStrLn ("Bhāskara II (Bījagaṇita 1150)                                     : "
            ++ show d61OK ++ "  got " ++ show d61)
  putStrLn ""
  if angelAll && nonComm && homSplit && d61OK
    then do
      putStrLn "HOLDS.  On the real digit alphabet and the real 2×2 integer matrix"
      putStrLn "monoid, the vallī's convergent trace is exactly foldMap of the column"
      putStrLn "map — the same homomorphism whose Unit-alphabet is Piṅgala's घात."
      putStrLn "एका मालया, द्वे लिप्यौ — one garland-fold, two alphabets. ॥"
      exitSuccess
    else exitFailure
