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

-- CyclotomicVocab — a law-mining organ for the cyclotomic sensor lane.
--
--   The corpus lane (notes/CYCLOTOMIC_SENSOR.md, Theorem 1; carrier
--   e_b(q) merged in formal/cubical/HeadDepthMerge.agda) is fed to the
--   machine as GENERATORS, not as a conclusion.  The machine is given
--   only two exact evaluators over the integers —
--
--       ord_p(a)          the multiplicative order,
--       v_p(a^n - 1)      the head/valuation the family produces,
--
--   built from Integer arithmetic and mod-exp by squaring, and told
--   nothing about lifting-the-exponent.  It then MINES equational laws
--   the way MathMachine does: it conjectures every law in a small affine
--   family, keeps the ones that agree on every probe instance, and
--   REFUTES the rest by a single disagreeing instance (free, exact, and
--   most of the work).
--
--   The target is rediscovery: the machine should propose, unaided, the
--   head-plus-valuation law
--
--       v_p(a^n - 1) = e + v_p(n)      when d | n          (Theorem 1)
--
--   and it should refute the naive v_p(a^n - 1) = v_p(n).  Whatever
--   survives mining is emitted as formal/cubical/CyclotomicMined.agda,
--   where it lands as refl certificates over a finite range in the exact
--   style of HeadDepthMerge (finite exhaustive verification is proof,
--   CLAUDE.md).  A mined law that matches a corpus theorem is the machine
--   rediscovering it; a mismatch would be a bug to report.
--
--   Nothing here is a float, a fit, or a correlation.  Every acceptance
--   is exact integer equality on an explicit probe set, and every
--   rejection carries a concrete counterexample.  The mined survivor is
--   then handed to the Agda kernel, which is the only thing that gets to
--   say "proved".
--
--   ghc -O2 machine/CyclotomicVocab.hs -o machine/cyclotomic-vocab
--   (writes formal/cubical/CyclotomicMined.agda; typecheck it with agda)
--   Build for the self-test (module is `Main`, so -main-is Main):
--   ghc -O1 -imachine -outputdir /tmp/cyc-build -o /tmp/cyc-test \
--       -main-is Main machine/CyclotomicVocab.hs
--
-- ---------------------------------------------------------------------------
-- PROVENANCE LEDGER (Grothendieck, 2026-08-16).  Attribution honesty is
-- protocol (collab/PROTOCOL.md §2), so what follows is who wrote what.
--
--   PRE-EXISTING (cf-indra, message 0862, commit a1228d23) — everything from
--   `powMod` down to `emitAgda`: the exact evaluators, the probe grids, the
--   affine candidate family c0 + c1*e + c2*v_p(n), `mine`/`judge`, and the
--   Agda emitter.  Its claim — unique survivor e + v_p(n) on the chain d | n,
--   naive rival refuted at (3,2,2), 44 rivals killed — REPRODUCES: verified
--   cold on 2026-08-16, and the emitted CyclotomicMined.agda came out
--   byte-identical to the committed file.
--
--   ADDED HERE, and nothing else was touched:
--
--   (§V) The claims were stated without their ranges.  A mining run over an
--        unnamed grid is not a result; §V restates every claim of this module
--        as a FINITE EXHAUSTIVE VERIFICATION over an EXPLICITLY PRINTED range,
--        including two things the miner never tested: the OFF-chain branch of
--        Theorem 1 (v_p = 0 when d ∤ n, asserted by the module's Step 1 but
--        never checked as a statement), and p = 2 (Theorem 1 (2)), which the
--        pre-existing grid excludes entirely.
--
--   (§D) The head-length dichotomy |H_{p,a}| = ⌊1/(p−1)⌋ + 1, i.e. 1 for odd
--        p and 2 for p = 2 (CYCLOTOMIC_SENSOR.md Theorem 4).  Nothing in this
--        module encoded it; the whole pre-existing grid is odd-p only, so the
--        module could not have seen p = 2 even in principle.  §D encodes the
--        length as FOUR independently decidable predicates and checks they
--        agree exhaustively: the closed form; the torsion element (−1 ∈ U₁
--        with (−1)^p = 1 iff p = 2); the shift lemma's exact failure locus,
--        swept over every residue class to a stated modulus; and — the one
--        that costs the machine something — the MINER ITSELF, re-run
--        unchanged at p = 2, where its one-head-entry family finds NOTHING
--        and a two-entry family is required.  The dichotomy is thus mined,
--        not asserted: head length = the number of sensor coordinates an
--        affine law needs, and the machine discovers it is 2 at p = 2.
--
--   (§C) The cost exhibit the corpus actually asks for (RUNTIME.md §4 item 5,
--        quoted in WHAT_IS_ACTUALLY_OPEN §0: "a result entering the runtime
--        and making another result cheaper").  e_b(q) is simultaneously this
--        module's head e and HEAD_DEPTH_BLINDNESS Thm W3's blindness depth.
--        §C computes the blindness depth twice — once by its own naive
--        Fermat route, once by reading the head the sensor already formed —
--        checks the two integers agree, and prints EXACT STEP COUNTS (no
--        wall-clock anywhere).
--
--   HONEST SCOPE, stated once and meant: §V, §D and §C are FINITE CHECKS OVER
--   STATED RANGES.  A finite check is finite.  Theorems 1, 3, 4 and W3 are
--   proved in notes/CYCLOTOMIC_SENSOR.md and notes/HEAD_DEPTH_BLINDNESS.md by
--   lifting-the-exponent and the structure of Z_p^×; NOTHING below extends
--   them by one instance beyond the ranges it prints.  What a finite check
--   does buy is exactly what CLAUDE.md says it buys — it is a mathematical
--   object rather than a measurement, so it can only ever REFUTE, and every
--   number it prints is an exact Integer.
--
--   NOT CLAIMED: no novelty anywhere in this lane.  Theorem 1 is
--   lifting-the-exponent (classical); Theorem 4's threshold is the classical
--   torsion-freeness of U_k for k > e/(p−1); W3 is folklore in the
--   primality-testing literature (SEED-42 §4.1, recorded in
--   WHAT_IS_ACTUALLY_OPEN §1).  What is local to this corpus is only that two
--   organs here were computing the same integer separately — and §C is the
--   arithmetic of stopping.
-- ---------------------------------------------------------------------------

{-# LANGUAGE BangPatterns #-}

module Main (main) where

import Control.Monad (unless, forM, forM_)
import Data.List (intercalate, nub, sort)
import Data.Maybe (mapMaybe, listToMaybe)
import GHC.IO.Encoding (setLocaleEncoding, utf8)
import System.Exit (exitFailure, exitSuccess)

-- ============================================================ evaluators
-- Exact, over Integer.  These are the ONLY organ-specific things the
-- machine is handed; the laws below are mined against them.

-- modular exponentiation by squaring: b^e mod m  (m > 0)
powMod :: Integer -> Integer -> Integer -> Integer
powMod _ _ 0 = 0            -- unused sentinel; m>=1 in all calls
powMod b e m = go (b `mod` m) e 1
  where
    go _  0 acc = acc `mod` m
    go bb ee acc =
      let acc' = if odd ee then (acc * bb) `mod` m else acc
      in go ((bb * bb) `mod` m) (ee `div` 2) acc'

-- multiplicative order of a modulo p  (p prime, p ∤ a)
ordP :: Integer -> Integer -> Integer
ordP p a = go 1 (a `mod` p)
  where
    go k acc
      | acc == 1  = k
      | otherwise = go (k + 1) ((acc * (a `mod` p)) `mod` p)

-- p-adic valuation of a positive integer
vpInt :: Integer -> Integer -> Integer
vpInt p = go 0
  where
    go k m
      | m `mod` p == 0 = go (k + 1) (m `div` p)
      | otherwise      = k

-- the quantity the family produces: v_p(a^n - 1)
vpAn :: Integer -> Integer -> Integer -> Integer
vpAn p a n = vpInt p (a ^ n - 1)

-- the sensor head e = v_p(a^d - 1), d = ord_p(a) — the HeadDepthMerge
-- carrier e_b(q), recomputed here from the same evaluators
headE :: Integer -> Integer -> Integer
headE p a = vpAn p a (ordP p a)

-- ============================================================ probe sets
-- The machine's "random instances": an explicit exhaustive grid.  Exact
-- agreement on this grid is what a conjecture must survive; one failure
-- refutes.  Grid chosen so v_p(n) actually varies (n divisible by p, by
-- p^2), otherwise the shift term would be untestable.

oddPrimes :: [Integer]
oddPrimes = [3, 5, 7, 11, 13]

basesFor :: Integer -> [Integer]
basesFor p = [ a | a <- [2 .. 15], a `mod` p /= 0 ]

exponents :: [Integer]
exponents = [1 .. 30]

-- full domain: every n
probesFull :: [(Integer, Integer, Integer)]
probesFull =
  [ (p, a, n) | p <- oddPrimes, a <- basesFor p, n <- exponents ]

-- restricted domain: only n on the chain (d | n), d = ord_p(a)
probesChain :: [(Integer, Integer, Integer)]
probesChain =
  [ (p, a, n) | (p, a, n) <- probesFull, n `mod` ordP p a == 0 ]

-- ============================================================ the family
-- A conjecture is an affine combination of the two things the sensor
-- state exposes: the head e and the exponent's own valuation w = v_p(n).
--
--     rhs = c0 + c1 * e + c2 * w
--
-- The machine does not know which (c0,c1,c2) is right.  It searches the
-- grid, keeps the survivors, and refutes the rest.  The naive law
-- v_p(a^n-1) = v_p(n) is the point (0,0,1) in this same family, so it is
-- tested and killed on equal footing — nothing about it is special-cased.

data Cand = Cand { c0 :: Integer, c1 :: Integer, c2 :: Integer }

instance Eq Cand where
  Cand a b c == Cand a' b' c' = (a, b, c) == (a', b', c')

candGrid :: [Cand]
candGrid = [ Cand x y z | x <- [-2 .. 2], y <- [0 .. 2], z <- [0 .. 2] ]

evalCand :: Cand -> Integer -> Integer -> Integer
evalCand (Cand x y z) e w = x + y * e + z * w

-- render a candidate as an algebra expression in e and w = v_p(n)
showCand :: Cand -> String
showCand (Cand x y z) =
  let terms = concat
        [ [ show x | x /= 0 ]
        , [ coef y ++ "e"       | y /= 0 ]
        , [ coef z ++ "v_p(n)"  | z /= 0 ] ]
      coef 1 = ""
      coef k = show k ++ "*"
  in case terms of
       [] -> "0"
       _  -> intercalate " + " terms

-- evaluate a candidate at a probe; Nothing if the probe is outside the
-- candidate's stated domain (handled by the caller choosing the domain)
lhsAt :: (Integer, Integer, Integer) -> Integer
lhsAt (p, a, n) = vpAn p a n

rhsAt :: Cand -> (Integer, Integer, Integer) -> Integer
rhsAt cnd (p, a, n) = evalCand cnd (headE p a) (vpInt p n)

-- a candidate SURVIVES a domain iff it never produces a negative value
-- and equals the LHS on every probe; otherwise the first failure is the
-- refuting witness
data Verdict = Survives | Refuted (Integer, Integer, Integer) Integer Integer
  -- witness (p,a,n), lhs, rhs

judge :: [(Integer, Integer, Integer)] -> Cand -> Verdict
judge dom cnd = case mapMaybe bad dom of
                  (w : _) -> w
                  []      -> Survives
  where
    bad pr = let l = lhsAt pr; r = rhsAt cnd pr
             in if l == r then Nothing
                else Just (Refuted pr l r)

isSurvivor :: Verdict -> Bool
isSurvivor Survives = True
isSurvivor _        = False

-- ============================================================ the mining
-- Run the family over a domain, return (survivors, refutations).
mine :: [(Integer, Integer, Integer)]
     -> ([Cand], [(Cand, (Integer, Integer, Integer), Integer, Integer)])
mine dom = (survivors, refs)
  where
    verdicts   = [ (c, judge dom c) | c <- candGrid ]
    survivors  = [ c | (c, v) <- verdicts, isSurvivor v ]
    refs       = [ (c, w, l, r) | (c, Refuted w l r) <- verdicts ]

-- ============================================================ Agda emit
-- The survivor becomes the FULL Theorem 1 (odd p): the mined affine law
-- e + v_p(n) guarded by the chain support [d | n], with 0 off the chain.
-- Emitted as refl certificates in HeadDepthMerge style, reusing that
-- module's fast arithmetic and its e_b(q) carrier `headDepth`.

-- the Agda certificate range (kept modest so the kernel's big-integer
-- power stays cheap): odd primes, small bases with p ∤ a, n up to 20
agdaPrimes :: [Integer]
agdaPrimes = [3, 5, 7, 11, 13]

agdaBases :: Integer -> [Integer]
agdaBases p = [ a | a <- [2 .. 12], a `mod` p /= 0 ]

agdaNMax :: Integer
agdaNMax = 20

-- the mined-and-refuted naive witness, chosen as the smallest chain probe
-- where v_p(n) disagrees with v_p(a^n-1)
naiveWitness :: (Integer, Integer, Integer)
naiveWitness = head
  [ (p, a, n)
  | (p, a, n) <- probesChain
  , vpInt p n /= vpAn p a n ]

emitAgda :: Cand -> FilePath -> IO ()
emitAgda surv path = writeFile path (unlines source)
  where
    (wp, wa, wn) = naiveWitness
    source =
      -- `--guardedness` added 2026-08-20: Agda's [InfectiveImport] rule makes it
      -- propagate, so a module opening Cubical.Foundations.Prelude without it fails
      -- at SCOPE-CHECKING under a cubical library compiled with it (Agda 2.8.0).
      -- Kept equal to Certificate.kOptionsPragma by
      -- scripts/Anuvrtti_TheOptionsLineIsSaidOnceAndContinues.sh.
      [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
      , ""
      , "------------------------------------------------------------------------"
      , "-- CyclotomicMined"
      , "--"
      , "-- AUTOGENERATED by machine/CyclotomicVocab.hs.  Do not edit by hand;"
      , "-- re-run the miner.  This module is a corpus lane fed back into the"
      , "-- machine as generators: the miner was handed only the exact"
      , "-- evaluators ord_p(a) and v_p(a^n - 1) (Integer arithmetic, mod-exp by"
      , "-- squaring) and NOT told the lifting-the-exponent lemma.  Searching a"
      , "-- small affine family c0 + c1*e + c2*v_p(n) against an exhaustive"
      , "-- integer probe grid, refuting every rival by a single disagreeing"
      , "-- instance, it proposed the survivor"
      , "--"
      , "--     v_p(a^n - 1) = " ++ showCand surv ++ "   (on the chain d | n)"
      , "--"
      , "-- which is exactly CYCLOTOMIC_SENSOR.md Theorem 1 (odd p): the"
      , "-- head-plus-valuation law, with e = e_b(q) the HeadDepthMerge carrier."
      , "-- The naive rival v_p(a^n - 1) = v_p(n) was refuted; its refutation is"
      , "-- certified below at (p,a,n) = (" ++ show wp ++ "," ++ show wa ++ "," ++ show wn ++ ")."
      , "--"
      , "-- Every claim below is a finite exhaustive verification (a checked"
      , "-- refl term), which CLAUDE.md admits as proof.  The arithmetic and the"
      , "-- e_b(q) carrier are imported from HeadDepthMerge, unchanged."
      , "------------------------------------------------------------------------"
      , ""
      , "module CyclotomicMined where"
      , ""
      , "open import Cubical.Foundations.Prelude"
      , "open import Cubical.Data.Nat using (ℕ; zero; suc; _+_; _∸_)"
      , "open import Agda.Builtin.Nat using (_==_)"
      , "open import Cubical.Data.Bool using (Bool; true; false; if_then_else_; _and_)"
      , "open import Cubical.Data.List using (List; []; _∷_)"
      , "open import HeadDepthMerge using (_%%_; power; ord; vCap; headDepth)"
      , ""
      , "------------------------------------------------------------------------"
      , "-- LHS and mined RHS, both as functions of (q , a , n)"
      , ""
      , "-- what the family actually produces: v_q(a^n - 1)"
      , "vpAn : ℕ → ℕ → ℕ → ℕ"
      , "vpAn q a n = vCap 40 q (power a n ∸ 1)"
      , ""
      , "-- the sensor head e = v_q(a^{ord} − 1): HeadDepthMerge's e_b(q) carrier"
      , "e-head : ℕ → ℕ → ℕ"
      , "e-head q a = headDepth q a"
      , ""
      , "-- THE MINED LAW (Theorem 1, odd q): supported on the chain d | n,"
      , "-- where it reads e + v_q(n); off the chain it is 0."
      , "mined : ℕ → ℕ → ℕ → ℕ"
      , "mined q a n ="
      , "  if (n %% ord q a == 0)"
      , "  then e-head q a + vCap 40 q n"
      , "  else 0"
      , ""
      , "-- the naive rival the miner refuted: v_q(a^n - 1) = v_q(n)"
      , "naive : ℕ → ℕ → ℕ → ℕ"
      , "naive q a n = vCap 40 q n"
      , ""
      , "------------------------------------------------------------------------"
      , "-- The certified probe range: odd primes q, bases a with q ∤ a,"
      , "-- 1 ≤ n ≤ " ++ show agdaNMax ++ " — the exact grid the miner accepted the law on."
      , ""
      , "range : ℕ → ℕ → List ℕ"
      , "range x zero    = []"
      , "range x (suc n) = x ∷ range (suc x) n"
      , ""
      , "allList : (ℕ → Bool) → List ℕ → Bool"
      , "allList f []       = true"
      , "allList f (x ∷ xs) = f x and allList f xs"
      , ""
      , "oddPrimes : List ℕ"
      , "oddPrimes = " ++ agdaList agdaPrimes
      , ""
      , "-- ∀ q ∈ oddPrimes, ∀ a ∈ [2..12] with q ∤ a, ∀ n ∈ [1.." ++ show agdaNMax ++ "] :"
      , "-- mined q a n ≡ vpAn q a n  (the mined law equals the true valuation)"
      , "overGrid : (ℕ → ℕ → ℕ → Bool) → Bool"
      , "overGrid P ="
      , "  allList"
      , "    (λ q → allList"
      , "      (λ a → if a %% q == 0 then true"
      , "             else allList (λ n → P q a n) (range 1 " ++ show agdaNMax ++ "))"
      , "      (range 2 11))"
      , "    oddPrimes"
      , ""
      , "minedCertificate : Bool"
      , "minedCertificate = overGrid (λ q a n → mined q a n == vpAn q a n)"
      , ""
      , "-- THE MACHINE'S LAW, CHECKED: rediscovered Theorem 1 holds on the grid."
      , "minedTheorem : minedCertificate ≡ true"
      , "minedTheorem = refl"
      , ""
      , "------------------------------------------------------------------------"
      , "-- The refutation of the naive law, also a checked term: at the mined"
      , "-- witness the naive value and the true valuation DISAGREE."
      , ""
      , "naiveRefuted : (naive " ++ show wp ++ " " ++ show wa ++ " " ++ show wn
          ++ " == vpAn " ++ show wp ++ " " ++ show wa ++ " " ++ show wn ++ ") ≡ false"
      , "naiveRefuted = refl"
      , ""
      , "-- and the mined law is CORRECT at that same witness, where the naive"
      , "-- law failed — the two are separated by a checked term."
      , "minedAtWitness : (mined " ++ show wp ++ " " ++ show wa ++ " " ++ show wn
          ++ " == vpAn " ++ show wp ++ " " ++ show wa ++ " " ++ show wn ++ ") ≡ true"
      , "minedAtWitness = refl"
      ]

agdaList :: [Integer] -> String
agdaList xs = concatMap (\x -> show x ++ " ∷ ") xs ++ "[]"

-- ###########################################################################
-- ##  [ADDED §V]  Finite exhaustive verification, with the range printed
-- ###########################################################################
--
--   Every claim this module makes is restated here as a check over a range
--   that is PRINTED, because a range that is not stated is not a result.
--   All arithmetic is exact Integer arithmetic; there is no floating point in
--   this file and no tolerance anywhere.  Each check can only refute: it
--   compares two independently computed exact integers and reports the first
--   disagreements as witnesses.
--
--   A FINITE CHECK IS FINITE.  None of this proves Theorem 1; Theorem 1 is
--   proved in notes/CYCLOTOMIC_SENSOR.md from lifting-the-exponent.  What the
--   check does is refuse to let the miner's grid stand in for a statement.

data Check = Check
  { chkName  :: String
  , chkRange :: String
  , chkCount :: Int
  , chkFails :: [String] }

runCheck :: Check -> IO Bool
runCheck c = do
  let bad = chkFails c
      ok  = null bad
  putStrLn ("   [" ++ (if ok then "PASS" else "FAIL") ++ "] " ++ chkName c)
  putStrLn ("          range    : " ++ chkRange c)
  putStrLn ("          instances: " ++ show (chkCount c)
            ++ "  (exact Integer equality, exhaustive over the range)")
  mapM_ (\m -> putStrLn ("          WITNESS  : " ++ m)) (take 6 bad)
  unless ok $
    putStrLn ("          total disagreements: " ++ show (length bad))
  return ok

-- A check that cannot fail is not a check.  `mustRefute` runs the SAME
-- comparison machinery against a deliberately wrong law and passes only if
-- the machinery notices — the falsifier for the verifier, which PROTOCOL.md
-- §1 requires of a headline claim and which a green run otherwise hides.
mustRefute :: Check -> IO Bool
mustRefute c = do
  let bad = chkFails c
      ok  = not (null bad)
  putStrLn ("   [" ++ (if ok then "PASS" else "FAIL") ++ "] must refute: "
            ++ chkName c)
  putStrLn ("          refuted at " ++ show (length bad) ++ " of "
            ++ show (chkCount c) ++ " instances"
            ++ (if ok then ";  first witness: " ++ head bad
                else "   <-- the checker did NOT notice a false law"))
  return ok

-- --------------------------------------------------------------- primes
isPrime :: Integer -> Bool
isPrime n
  | n < 2     = False
  | otherwise = all (\d -> n `mod` d /= 0) (takeWhile (\d -> d*d <= n) [2 ..])

primesUpTo :: Integer -> [Integer]
primesUpTo n = [ p | p <- [2 .. n], isPrime p ]

-- ---------------------------------------------- Theorem 1 (1), odd p, BOTH
-- branches.  The pre-existing miner only ever evaluated the ON-chain branch
-- (its Step 2 domain); the OFF-chain claim v_p(a^n - 1) = 0 for d ∤ n is what
-- its Step 1 asserts in prose and never checks.  Both are checked here.
-- the law is a PARAMETER so that the negative controls below are checked by
-- literally this code path, not by a paraphrase of it
thm1OddWith :: String -> String -> ((Integer, Integer, Integer) -> Integer)
            -> [Integer] -> (Integer -> [Integer]) -> [Integer] -> Check
thm1OddWith nm rng law ps bsOf ns = Check
  { chkName  = nm
  , chkRange = rng
  , chkCount = length trips
  , chkFails = fails }
  where
    trips = [ (p, a, n) | p <- ps, a <- bsOf p, n <- ns ]
    fails =
      [ "(p,a,n)=" ++ show t ++ "  true=" ++ show l ++ "  law=" ++ show r
      | t <- trips
      , let l = lhsAt t
      , let r = law t
      , l /= r ]

-- Theorem 1 (1) itself
lawThm1Odd :: (Integer, Integer, Integer) -> Integer
lawThm1Odd (p, a, n) =
  if n `mod` ordP p a == 0 then headE p a + vpInt p n else 0

thm1OddCheck :: String -> [Integer] -> (Integer -> [Integer]) -> [Integer]
             -> Check
thm1OddCheck rng =
  thm1OddWith ("Theorem 1 (odd p), BOTH branches:  "
               ++ "v_p(a^n-1) = e + v_p(n) if d|n, else 0")
              rng lawThm1Odd

-- ------------------------------------------------- the p = 2 sensor (e-,e+)
-- CYCLOTOMIC_SENSOR.md Definition: at p = 2 the state is a PAIR.  Note
-- headE 2 b = v_2(b^{ord_2(b)} - 1) = v_2(b - 1) = e_- automatically, since
-- ord_2(b) = 1 for every odd b: the pre-existing carrier already delivers the
-- FIRST head entry at p = 2, and only the second is missing.
eMinus, ePlus :: Integer -> Integer
eMinus b = vpInt 2 (b - 1)
ePlus  b = vpInt 2 (b + 1)

-- Theorem 1 (2): v_2(b^n - 1) = e_- for n odd, e_- + e_+ + v_2(n) - 1 for n
-- even.  Untested anywhere in the pre-existing module.
thm1TwoWith :: String -> String -> (Integer -> Integer -> Integer)
            -> [Integer] -> [Integer] -> Check
thm1TwoWith nm rng law bs ns = Check
  { chkName  = nm
  , chkRange = rng
  , chkCount = length prs
  , chkFails = fails }
  where
    prs = [ (b, n) | b <- bs, n <- ns ]
    fails =
      [ "(b,n)=" ++ show t ++ "  true=" ++ show l ++ "  law=" ++ show r
      | t@(b, n) <- prs
      , let l = vpAn 2 b n
      , let r = law b n
      , l /= r ]

lawThm1Two :: Integer -> Integer -> Integer
lawThm1Two b n =
  if odd n then eMinus b else eMinus b + ePlus b + vpInt 2 n - 1

thm1TwoCheck :: String -> [Integer] -> [Integer] -> Check
thm1TwoCheck rng =
  thm1TwoWith ("Theorem 1 (2), p = 2:  v_2(b^n-1) = e_- (n odd) / "
               ++ "e_- + e_+ + v_2(n) - 1 (n even)")
              rng lawThm1Two

-- the structural fact the 2-adic head rests on: (b+1) - (b-1) = 2, so the two
-- even numbers b ± 1 cannot both be divisible by 4.
minHeadCheck :: String -> [Integer] -> Check
minHeadCheck rng bs = Check
  { chkName  = "min(e_-, e_+) = 1 for every odd b  "
               ++ "(the head's two entries are never both deep)"
  , chkRange = rng
  , chkCount = length bs
  , chkFails = [ "b=" ++ show b ++ "  (e_-,e_+)=" ++ show (eMinus b, ePlus b)
               | b <- bs, min (eMinus b) (ePlus b) /= 1 ] }

-- ------------------------------------------------------ Theorem W3, merged
-- b is Fermat-blind on n = q^a  iff  b^{n-1} = 1 (mod n).
fermatBlind :: Integer -> Integer -> Integer -> Bool
fermatBlind q a b = let n = q ^ a in powMod b (n - 1) n == 1

-- HEAD_DEPTH_BLINDNESS Thm W3: blindness on q^a  <=>  a <= e_b(q).
-- Range is HeadDepthMerge.agda's own certified grid (its `overTriples`), so
-- this is an independent Haskell replication of a checked Agda term, not a
-- new range.
w3With :: String -> (Integer -> Integer -> Integer -> Bool) -> Check
w3With nm pred' = Check
  { chkName  = nm
  , chkRange = "q odd prime <= 23; 2 <= b <= 3q-1 with q not | b; 1 <= a <= 4"
               ++ "  [= HeadDepthMerge.agda's 1048 triples, replicated]"
  , chkCount = length trips
  , chkFails =
      [ "(q,a,b)=" ++ show t ++ "  blind=" ++ show (fermatBlind q a b)
        ++ "  predicate=" ++ show (pred' q a b)
      | t@(q, a, b) <- trips
      , fermatBlind q a b /= pred' q a b ] }
  where
    trips = [ (q, a, b)
            | q <- [3, 5, 7, 11, 13, 17, 19, 23]
            , b <- [2 .. 3*q - 1], b `mod` q /= 0
            , a <- [1 .. 4] ]

w3Check :: Check
w3Check = w3With ("Thm W3 (HEAD_DEPTH_BLINDNESS):  "
                  ++ "b Fermat-blind on q^a  <=>  a <= e_b(q)")
                 (\q a b -> a <= headE q b)

-- --------------------------------------------------------- the b = 2 case
-- At b = 2 the head depth IS the Wieferich condition: e_2(q) >= 2 iff
-- 2^{q-1} = 1 (mod q^2).  Exhaustive search over a stated range — this is a
-- finite verification of a known list, NOT a statement about larger q.
wieferichCheck :: Integer -> Check
wieferichCheck bound = Check
  { chkName  = "b = 2:  {odd prime q : e_2(q) >= 2} = the Wieferich primes, "
               ++ "exhaustively"
  , chkRange = "every odd prime q < " ++ show bound
               ++ "  (expected {1093, 3511}; classical, not novel)"
  , chkCount = length qs
  , chkFails = [ "found " ++ show found ++ ", expected [1093,3511]"
               | found /= [1093, 3511] ] }
  where
    qs    = [ q | q <- primesUpTo (bound - 1), q > 2 ]
    found = [ q | q <- qs, headE q 2 >= 2 ]

-- ###########################################################################
-- ##  [ADDED §D]  The head-length dichotomy  |H| = floor(1/(p-1)) + 1
-- ###########################################################################
--
--   CYCLOTOMIC_SENSOR.md Theorem 4.  The head length is 1 for odd p and 2 for
--   p = 2, and the REASON is torsion: U_k = 1 + p^k Z_p is torsion-free
--   exactly for k > 1/(p-1), so the only obstruction over Q_p is the single
--   element -1 in U_1 at p = 2.  This is why the b = 2 Wieferich case is the
--   one that is different in kind, not merely in size.
--
--   Four decidable routes to the same integer, each independently computable,
--   all checked against each other over printed ranges:
--
--     (i)   the closed form                      floor(1/(p-1)) + 1
--     (ii)  the torsion element                  -1 in U_1 and (-1)^p = 1
--     (iii) the shift lemma's failure locus      exhaustive over residues
--     (iv)  the MINER, re-run unchanged at p=2   1 head entry does not fit

-- (i) the closed form of Theorem 4
headLenFormula :: Integer -> Integer
headLenFormula p = 1 `div` (p - 1) + 1

-- (ii) the torsion element.  -1 lies in U_1 iff -1 = 1 (mod p) iff p = 2, and
-- it is a p-th root of unity iff p is even.  Theorem 4 says the head is long
-- exactly as long as the p-power torsion of Z_p^x forces it to be, and over
-- Q_p that torsion is exactly {±1} at p = 2 and trivial elsewhere.
minusOneInU1 :: Integer -> Bool
minusOneInU1 p = ((-1) `mod` p) == (1 `mod` p)

minusOneIsPthRoot :: Integer -> Bool
minusOneIsPthRoot p = ((-1) ^ p) == (1 :: Integer)

headLenTorsion :: Integer -> Integer
headLenTorsion p = if minusOneInU1 p && minusOneIsPthRoot p then 2 else 1

-- (iii) the shift lemma, swept exhaustively.
--
--   Lemma (CYCLOTOMIC_SENSOR.md): for x with v_p(x-1) = k >= 1,
--   v_p(x^p - 1) = k + 1 exactly — provided p is odd, or p = 2 and k >= 2.
--   The head is precisely the initial segment of the chain on which this
--   shift is NOT yet available, so the head length is 1 + (the largest k at
--   which the shift fails).
--
--   shiftLevel p k m sweeps EVERY x = 1 + t*p^k with 1 <= t < p^(m-k) and
--   p ∤ t — that is, every residue class mod p^m with v_p(x-1) = k exactly —
--   and returns (tested, failures).  Exact integers throughout.
shiftLevel :: Integer -> Integer -> Integer -> (Int, Int)
shiftLevel p k m = go 1 0 0
  where
    pk  = p ^ k
    lim = p ^ (m - k)
    go !t !n !f
      | t >= lim        = (n, f)
      | t `mod` p == 0  = go (t + 1) n f
      | otherwise =
          let x = 1 + t * pk
          in if vpInt p (x ^ p - 1) == k + 1
               then go (t + 1) (n + 1) f
               else go (t + 1) (n + 1) (f + 1)

-- the sweep modulus exponent: the largest m with p^m <= 10^6 (at least 3), so
-- every p gets a genuinely multi-level sweep at a stated, printed modulus
sweepExp :: Integer -> Integer
sweepExp p = maximum (3 : [ m | m <- [1 .. 40], p ^ m <= 1000000 ])

-- (tested, failing levels k, derived head length) at modulus p^m
headLenShift :: Integer -> Integer -> (Int, [Integer], Integer)
headLenShift p m = (tested, failing, k0)
  where
    dat     = [ (k, shiftLevel p k m) | k <- [1 .. m - 1] ]
    tested  = sum [ n | (_, (n, _)) <- dat ]
    failing = [ k | (k, (_, f)) <- dat, f > 0 ]
    k0      = if null failing then 1 else maximum failing + 1

-- (iv) the miner at p = 2.  ord_2(b) = 1 for every odd b, so the chain is all
-- of n and this is the LIKE-FOR-LIKE domain to Step 2's chain domain: the
-- same candidate family, the same judge, the same refutation discipline.
basesTwo :: [Integer]
basesTwo = [ b | b <- [3 .. 31], odd b ]

probesTwo :: [(Integer, Integer, Integer)]
probesTwo = [ (2, b, n) | b <- basesTwo, n <- exponents ]

probesTwoOdd, probesTwoEven :: [(Integer, Integer, Integer)]
probesTwoOdd  = [ t | t@(_, _, n) <- probesTwo, odd n ]
probesTwoEven = [ t | t@(_, _, n) <- probesTwo, even n ]

-- the TWO-entry family: c0 + c1*e_- + c2*e_+ + c3*v_2(n).  This is the
-- one-entry family of `Cand` with a second head coordinate adjoined — exactly
-- the extension Theorem 4 says p = 2 forces and odd p forbids.
data Cand2 = Cand2 Integer Integer Integer Integer deriving Eq

candGrid2 :: [Cand2]
candGrid2 = [ Cand2 x y z w | x <- [-2 .. 2], y <- [0 .. 2]
                            , z <- [0 .. 2],  w <- [0 .. 2] ]

showCand2 :: Cand2 -> String
showCand2 (Cand2 x y z w) =
  let coef 1 = ""
      coef k = show k ++ "*"
      terms = concat [ [ show x           | x /= 0 ]
                     , [ coef y ++ "e_-"  | y /= 0 ]
                     , [ coef z ++ "e_+"  | z /= 0 ]
                     , [ coef w ++ "v_2(n)" | w /= 0 ] ]
  in case terms of
       [] -> "0"
       _  -> intercalate " + " terms

rhs2At :: Cand2 -> (Integer, Integer, Integer) -> Integer
rhs2At (Cand2 x y z w) (_, b, n) =
  x + y * eMinus b + z * ePlus b + w * vpInt 2 n

mine2 :: [(Integer, Integer, Integer)] -> [Cand2] -> ([Cand2], Int)
mine2 dom grid = (survivors, length grid - length survivors)
  where
    survivors = [ c | c <- grid
                    , all (\pr -> lhsAt pr == rhs2At c pr) dom ]

-- ###########################################################################
-- ##  [ADDED §C]  The merge as a cost reduction, in exact step counts
-- ###########################################################################
--
--   THE STEP MODEL, stated so the numbers mean something:
--
--     one STEP = one modular multiplication-with-reduction,
--             OR one exact integer multiplication,
--             OR one division-with-remainder.
--
--   Every counted routine below is the SAME loop as its uncounted twin at the
--   top of this file, with an accumulator threaded through; `stepModelCheck`
--   verifies the counted and uncounted routines return identical values over
--   a stated range, so the counts are counts OF THIS MODULE'S ARITHMETIC and
--   not of some idealised algorithm.  There is no wall-clock anywhere: a
--   timing would be a measurement, a step count is an integer.

powModC :: Integer -> Integer -> Integer -> (Integer, Int)
powModC b e m = go (b `mod` m) e 1 0
  where
    go _  0  acc k = (acc `mod` m, k)
    go bb ee acc k =
      let (acc', k') = if odd ee then ((acc * bb) `mod` m, k + 1) else (acc, k)
      in go ((bb * bb) `mod` m) (ee `div` 2) acc' (k' + 1)

ordPC :: Integer -> Integer -> (Integer, Int)
ordPC p a = go 1 (a `mod` p) 0
  where
    go k acc s
      | acc == 1  = (k, s)
      | otherwise = go (k + 1) ((acc * (a `mod` p)) `mod` p) (s + 1)

-- exact integer power by squaring
powC :: Integer -> Integer -> (Integer, Int)
powC b e = go b e 1 0
  where
    go _  0  acc k = (acc, k)
    go bb ee acc k =
      let (acc', k') = if odd ee then (acc * bb, k + 1) else (acc, k)
      in go (bb * bb) (ee `div` 2) acc' (k' + 1)

vpIntC :: Integer -> Integer -> (Integer, Int)
vpIntC p = go 0 0
  where
    go v s m
      | m `mod` p == 0 = go (v + 1) (s + 1) (m `div` p)
      | otherwise      = (v, s + 1)

-- the sensor's own carrier, counted: e_b(q) = v_q(b^{ord_q(b)} - 1)
headEC :: Integer -> Integer -> (Integer, Int)
headEC p a =
  let (d,  s1) = ordPC p a
      (ad, s2) = powC a d
      (e,  s3) = vpIntC p (ad - 1)
  in (e, s1 + s2 + s3)

-- ROUTE 1 — the blindness organ ALONE.  Nothing is assumed about e_b(q):
-- test a = 1, 2, 3, ... for b^{q^a - 1} = 1 (mod q^a) until the test refuses.
-- It terminates at a = e+1 because e is finite; the guard is a bug-catcher,
-- not a horizon.
naiveDepthC :: Integer -> Integer -> Maybe (Integer, Int)
naiveDepthC q b = go 1 0 0
  where
    go a best s
      | a > 40 = Nothing
      | otherwise =
          let n      = q ^ a
              (r, k) = powModC b (n - 1) n
          in if r == 1 then go (a + 1) a (s + k) else Just (best, s + k)

-- ROUTE 1' — the blindness organ answering the whole family a = 1..A on its
-- own terms: A independent modular exponentiations, one per query.
naiveFamilyC :: Integer -> Integer -> Integer -> Int
naiveFamilyC q b amax =
  sum [ snd (powModC b (q ^ a - 1) (q ^ a)) | a <- [1 .. amax] ]

-- ---------------------------------------------------------------------------
-- Route 1's cost is not a measurement: it is a closed form, so it is derived
-- here and the executed count is checked against it (CLAUDE.md: "no claim of
-- the form 'measured slope ~ x' survives if the slope is derivable").
--
--   powModC's loop performs one squaring per bit of the exponent and one
--   multiply per set bit, so the query at depth a costs EXACTLY
--
--       bitlen(q^a - 1) + popcount(q^a - 1)      steps,
--
--   independently of b.  Since 2^(bl-1) <= q < 2^bl with bl = bitlen(q), the
--   first term is linear in a — sandwiched in [a(bl-1), a*bl] — so the family
--   a = 1..A costs Theta(A^2 log q).  Route 2 costs 0 for every A.
--   QUADRATIC in the number of queries versus CONSTANT (and that constant is
--   zero), with no fitted exponent anywhere.
bitLen :: Integer -> Int
bitLen n | n <= 0    = 0
         | otherwise = 1 + bitLen (n `div` 2)

popCountI :: Integer -> Int
popCountI n | n <= 0    = 0
            | otherwise = fromIntegral (n `mod` 2) + popCountI (n `div` 2)

naiveFamilyDerived :: Integer -> Integer -> Int
naiveFamilyDerived q amax =
  sum [ bitLen (q ^ a - 1) + popCountI (q ^ a - 1) | a <- [1 .. amax] ]

costLawCheck :: Check
costLawCheck = Check
  { chkName  = "route-1 cost is the DERIVED closed form  "
               ++ "sum_a [bitlen(q^a-1) + popcount(q^a-1)]  (and b-free)"
  , chkRange = "q odd prime <= 23; 2 <= b <= 3q-1 with q not | b; 1 <= A <= 8"
  , chkCount = length cases
  , chkFails = [ "(q,b,A)=" ++ show t ++ "  executed="
                 ++ show (naiveFamilyC q b amax)
                 ++ "  derived=" ++ show (naiveFamilyDerived q amax)
               | t@(q, b, amax) <- cases
               , naiveFamilyC q b amax /= naiveFamilyDerived q amax ] }
  where
    cases = [ (q, b, amax)
            | q <- [3,5,7,11,13,17,19,23]
            , b <- [2 .. 3*q - 1], b `mod` q /= 0
            , amax <- [1 .. 8] ]

costGrowthCheck :: Check
costGrowthCheck = Check
  { chkName  = "and it is LINEAR in a:  a*(bitlen q - 1) <= bitlen(q^a - 1) "
               ++ "<= a*bitlen q,  hence the family is quadratic in A"
  , chkRange = "q odd prime <= 101; 1 <= a <= 64"
  , chkCount = length cases
  , chkFails = [ "(q,a)=" ++ show t ++ "  bitlen=" ++ show (bitLen (q ^ a - 1))
               | t@(q, a) <- cases
               , let bl = bitLen q
               , let x  = bitLen (q ^ a - 1)
               , x < fromIntegral a * (bl - 1) || x > fromIntegral a * bl ] }
  where
    cases = [ (q, a) | q <- primesUpTo 101, q > 2, a <- [1 .. 64] ]

data CostRow = CostRow
  { crQ, crB          :: Integer
  , crE, crDepth      :: Integer   -- sensor head; naive blindness depth
  , crNaive, crFamily :: Int       -- route-1 steps (depth; family a=1..A)
  , crSensor          :: Int }     -- steps to FORM the head (paid already)

costRow :: Integer -> Integer -> Integer -> Maybe CostRow
costRow amax q b = do
  (dep, sn) <- naiveDepthC q b
  let (e, sf) = headEC q b
  return CostRow { crQ = q, crB = b, crE = e, crDepth = dep
                 , crNaive = sn, crFamily = naiveFamilyC q b amax
                 , crSensor = sf }

-- the pairs the table reports: a spread of e = 1 and e = 2, ending with the
-- two Wieferich pairs at b = 2 — the p = 2 torsion case of §D showing up as
-- an actual arithmetic instance.
costPairs :: [(Integer, Integer)]
costPairs = [ (3,2), (5,3), (7,3), (11,3), (5,7), (29,14), (1093,2), (3511,2) ]

stepModelCheck :: Check
stepModelCheck = Check
  { chkName  = "counted loops agree with the uncounted originals "
               ++ "(the step model measures THIS module)"
  , chkRange = "q odd prime <= 23; 2 <= b <= 3q-1 with q not | b"
  , chkCount = length prs
  , chkFails = [ "(q,b)=" ++ show t | t@(q, b) <- prs
               , fst (ordPC q b) /= ordP q b
                 || fst (headEC q b) /= headE q b ] }
  where
    prs = [ (q, b) | q <- [3,5,7,11,13,17,19,23]
                   , b <- [2 .. 3*q - 1], b `mod` q /= 0 ]

padL, padR :: Int -> String -> String
padL w s = replicate (max 0 (w - length s)) ' ' ++ s
padR w s = s ++ replicate (max 0 (w - length s)) ' '

-- ============================================================ main
main :: IO ()
main = do
  setLocaleEncoding utf8
  putStrLn "== CyclotomicVocab : mining LTE structure from exact evaluators =="
  putStrLn ""
  putStrLn ("probe grid: " ++ show (length probesFull) ++ " full instances, "
            ++ show (length probesChain) ++ " on-chain (d | n) instances")
  putStrLn ("candidate family: c0 + c1*e + c2*v_p(n), "
            ++ show (length candGrid) ++ " candidates")
  putStrLn ""

  -- Step 1: mine over the FULL domain (all n).  Nothing affine survives,
  -- because off the chain the valuation is 0 while e + v_p(n) is not.
  let (survFull, _refsFull) = mine probesFull
  putStrLn "-- Step 1: mine over the FULL domain (every n)"
  putStrLn ("   survivors: "
            ++ if null survFull then "NONE — no unguarded affine law fits"
               else intercalate ", " (map showCand survFull))
  putStrLn "   => the law needs a support guard; restrict to the chain d | n."
  putStrLn ""

  -- Step 2: mine over the chain domain (d | n).  Exactly e + v_p(n)
  -- survives; every rival, the naive law included, is refuted.
  let (survChain, refsChain) = mine probesChain
  putStrLn "-- Step 2: mine over the chain domain (d | n)"
  putStrLn ("   survivors: " ++ intercalate ", " (map showCand survChain))
  putStrLn ""

  -- show the naive law's refutation explicitly
  let naive = Cand 0 0 1
  case [ (w, l, r) | (c, w, l, r) <- refsChain, c == naive ] of
    ((w@(p, a, n), l, r) : _) ->
      putStrLn ("   naive law v_p(a^n-1) = v_p(n) REFUTED at "
                ++ show w ++ ": true = " ++ show l ++ ", naive = " ++ show r
                ++ "  [p=" ++ show p ++ ",a=" ++ show a ++ ",n=" ++ show n ++ "]")
    [] -> putStrLn "   (naive law unexpectedly survived — INVESTIGATE)"
  putStrLn ("   total rivals refuted on the chain: " ++ show (length refsChain))
  putStrLn ""

  -- Step 3: identify the unique survivor and emit it.
  minerOK <- case survChain of
    [surv] | (c0 surv, c1 surv, c2 surv) == (0, 1, 1) -> do
      putStrLn ("-- Step 3: unique survivor is  v_p(a^n-1) = " ++ showCand surv)
      putStrLn "   MATCH: CYCLOTOMIC_SENSOR.md Theorem 1 (head-plus-valuation law),"
      putStrLn "          e = e_b(q) the HeadDepthMerge carrier."
      let out = "formal/cubical/CyclotomicMined.agda"
      emitAgda surv out
      putStrLn ("   emitted " ++ out ++ " — typecheck with agda.")
      return True
    [surv] -> do
      putStrLn ("-- Step 3: unique survivor is " ++ showCand surv
                ++ " — NOT the expected e + v_p(n).  BUG: report mismatch.")
      return False
    _ -> do
      putStrLn ("-- Step 3: expected a unique survivor, got "
                ++ show (length survChain) ++ ".  BUG: report.")
      return False

  ------------------------------------------------------------------ §V
  putStrLn ""
  putStrLn "==========================================================================="
  putStrLn "§V  FINITE EXHAUSTIVE VERIFICATION — every claim with its range printed"
  putStrLn "==========================================================================="
  putStrLn "    Exact Integer arithmetic; no floating point, no tolerance, no fit."
  putStrLn "    A finite check is FINITE: it can refute, and it certifies nothing"
  putStrLn "    outside the range it prints.  The theorems themselves are proved in"
  putStrLn "    notes/CYCLOTOMIC_SENSOR.md and notes/HEAD_DEPTH_BLINDNESS.md."
  putStrLn ""

  vs <- mapM runCheck
    [ thm1OddCheck
        ("p in {3,5,7,11,13}; 2 <= a <= 15 with p not | a; 1 <= n <= 30"
         ++ "  [the miner's OWN grid, now stated]")
        oddPrimes basesFor exponents
    , thm1OddCheck
        ("p odd prime <= 31; 2 <= a <= 40 with p not | a; 1 <= n <= 60"
         ++ "  [independent WIDER grid]")
        [3,5,7,11,13,17,19,23,29,31]
        (\p -> [ a | a <- [2 .. 40], a `mod` p /= 0 ])
        [1 .. 60]
    , thm1TwoCheck
        "b odd, 3 <= b <= 99; 1 <= n <= 60  [p = 2: absent from the miner's grid]"
        [ b | b <- [3 .. 99], odd b ] [1 .. 60]
    , minHeadCheck "b odd, 3 <= b <= 999" [ b | b <- [3 .. 999], odd b ]
    , w3Check
    , wieferichCheck 10000
    , stepModelCheck
    , costLawCheck
    , costGrowthCheck ]

  putStrLn ""
  putStrLn "    NEGATIVE CONTROLS.  A green check is worth nothing until the same"
  putStrLn "    code path is shown to notice a FALSE law.  Each line below runs the"
  putStrLn "    checker above on a deliberately wrong law and passes iff it refutes."
  putStrLn ""
  ns' <- mapM mustRefute
    [ thm1OddWith "naive law v_p(a^n-1) = v_p(n)"
        "p in {3,5,7,11,13}; 2 <= a <= 15; 1 <= n <= 30"
        (\(p, _, n) -> vpInt p n) oddPrimes basesFor exponents
    , thm1OddWith "head with no shift:  v_p(a^n-1) = e  on the chain"
        "p in {3,5,7,11,13}; 2 <= a <= 15; 1 <= n <= 30"
        (\(p, a, n) -> if n `mod` ordP p a == 0 then headE p a else 0)
        oddPrimes basesFor exponents
    , thm1TwoWith "the ODD-p law transplanted to p = 2:  v_2(b^n-1) = e_- + v_2(n)"
        "b odd, 3 <= b <= 99; 1 <= n <= 60"
        (\b n -> eMinus b + vpInt 2 n) [ b | b <- [3 .. 99], odd b ] [1 .. 60]
    , thm1TwoWith "the 2-adic law without its -1:  e_- + e_+ + v_2(n) on n even"
        "b odd, 3 <= b <= 99; n even, 2 <= n <= 60"
        (\b n -> eMinus b + ePlus b + vpInt 2 n)
        [ b | b <- [3 .. 99], odd b ] [ n | n <- [2 .. 60], even n ]
    , w3With "W3 with the threshold shifted:  blind on q^a <=> a <= e_b(q) + 1"
        (\q a b -> a <= headE q b + 1) ]

  ------------------------------------------------------------------ §D
  putStrLn ""
  putStrLn "==========================================================================="
  putStrLn "§D  THE HEAD-LENGTH DICHOTOMY   |H_p| = floor(1/(p-1)) + 1  =  1 / 2"
  putStrLn "==========================================================================="
  putStrLn "    CYCLOTOMIC_SENSOR.md Theorem 4.  The head is one entry long at odd p"
  putStrLn "    and two at p = 2, because U_k = 1 + p^k Z_p is torsion-free exactly"
  putStrLn "    for k > 1/(p-1) — and over Q_p the only obstruction is the single"
  putStrLn "    element -1 in U_1 at p = 2.  Four decidable routes, checked to agree."
  putStrLn ""
  putStrLn "    (i)+(ii) closed form vs the torsion element, and the shift lemma"
  putStrLn "             (iii) swept over EVERY residue class to the stated modulus:"
  putStrLn ""
  putStrLn ("      " ++ padR 5 "p" ++ padR 10 "formula" ++ padR 10 "torsion"
            ++ padR 12 "modulus" ++ padR 12 "x tested"
            ++ padR 16 "shift fails at" ++ "shift-derived")
  putStrLn ("      " ++ replicate 78 '-')

  dRows <- forM [2,3,5,7,11,13,17,19,23,29,31] $ \p -> do
    let m                        = sweepExp p
        (tested, failing, kShift) = headLenShift p m
        agree = headLenFormula p == headLenTorsion p
                && headLenFormula p == kShift
    putStrLn ("      " ++ padR 5 (show p)
              ++ padR 10 (show (headLenFormula p))
              ++ padR 10 (show (headLenTorsion p))
              ++ padR 12 ("p^" ++ show m)
              ++ padR 12 (show tested)
              ++ padR 16 (if null failing then "(never)" else "k=" ++ show failing)
              ++ show kShift ++ (if agree then "" else "   <-- DISAGREE"))
    return agree

  let (t21, f21) = shiftLevel 2 1 (sweepExp 2)
      universal  = t21 > 0 && f21 == t21
  putStrLn ""
  putStrLn "    Read the 'shift fails at' column: the shift law v_p(x^p-1)="
  putStrLn "    v_p(x-1)+1 fails at p=2 for k=1 and NOWHERE ELSE in the sweep."
  putStrLn "    That single failing level IS the second head entry, and it is"
  putStrLn "    the element -1: (-1) in U_1 \\ U_2 with (-1)^2 = 1."
  putStrLn ("    The p=2, k=1 failure is UNIVERSAL, not sporadic: " ++ show f21
            ++ " of " ++ show t21 ++ " residue classes fail"
            ++ (if universal then " (all of them)." else "   <-- NOT ALL"))
  putStrLn "    A sporadic failure would be a bug; a universal one is a theorem"
  putStrLn "    with a reason, and the reason is torsion."
  putStrLn ""
  putStrLn "    (iv) THE MINER ITSELF, re-run unchanged at p = 2.  ord_2(b) = 1 for"
  putStrLn "         every odd b, so the chain is all of n: this is the LIKE-FOR-LIKE"
  putStrLn "         domain to Step 2, same family, same judge, same refutations."
  putStrLn ""

  let (survTwo1, refsTwo1) = mine probesTwo
      p2OneFails = null survTwo1
  putStrLn ("      one-entry family c0 + c1*e + c2*v_2(n) on p=2, "
            ++ show (length probesTwo) ++ " probes:")
  putStrLn ("        survivors: "
            ++ if p2OneFails
                 then "NONE — one head entry does not suffice at p = 2"
                 else intercalate ", " (map showCand survTwo1)
                      ++ "   <-- UNEXPECTED")
  case [ (w,l,r) | (c,w,l,r) <- refsTwo1, c == Cand 0 1 1 ] of
    ((w,l,r):_) ->
      putStrLn ("        the odd-p survivor e + v_p(n) is REFUTED at (p,b,n)="
                ++ show w ++ ": true=" ++ show l ++ ", law=" ++ show r)
    [] -> putStrLn "        (odd-p survivor not refuted at p=2 — INVESTIGATE)"

  let gridOdd  = [ c | c@(Cand2 _ _ _ w) <- candGrid2, w == 0 ]
      (sOdd,  rOdd)  = mine2 probesTwoOdd  gridOdd
      (sEven, rEven) = mine2 probesTwoEven candGrid2
      (sAll,  _)     = mine2 probesTwo     candGrid2
      p2TwoWorks = sOdd == [Cand2 0 1 0 0]
                   && sEven == [Cand2 (-1) 1 1 1]
                   && null sAll
  putStrLn ""
  putStrLn ("      two-entry family c0 + c1*e_- + c2*e_+ + c3*v_2(n), "
            ++ show (length candGrid2) ++ " candidates:")
  putStrLn ("        on ALL n              : survivors "
            ++ (if null sAll then "NONE — the parity guard is forced"
                else intercalate ", " (map showCand2 sAll)))
  putStrLn ("        on n odd  (c3 fixed 0): survivors "
            ++ intercalate ", " (map showCand2 sOdd)
            ++ "   [" ++ show rOdd ++ " of " ++ show (length gridOdd)
            ++ " refuted; c3 is unidentifiable here since v_2(n)=0 identically]")
  putStrLn ("        on n even             : survivors "
            ++ intercalate ", " (map showCand2 sEven)
            ++ "   [" ++ show rEven ++ " of " ++ show (length candGrid2)
            ++ " refuted]")
  putStrLn ""
  putStrLn "      MATCH: CYCLOTOMIC_SENSOR.md Theorem 1 (2).  The machine needed a"
  putStrLn "      SECOND head coordinate at p = 2 and only there — the head length"
  putStrLn "      is mined, not asserted, and it agrees with floor(1/(p-1))+1."

  ------------------------------------------------------------------ §C
  putStrLn ""
  putStrLn "==========================================================================="
  putStrLn "§C  THE MERGE AS A COST REDUCTION — two organs, one integer"
  putStrLn "==========================================================================="
  putStrLn "    e_b(q) is simultaneously (i) this module's head e, and (ii) the exact"
  putStrLn "    depth at which base b goes blind to q^a (Thm W3).  Computed twice:"
  putStrLn ""
  putStrLn "      ROUTE 1 (organs as strangers): the blindness depth by its own naive"
  putStrLn "        route — test b^{q^a-1} = 1 mod q^a for a = 1,2,3,... until it"
  putStrLn "        refuses.  One modular exponentiation per query."
  putStrLn "      ROUTE 2 (merged): read the head e_b(q) the sensor ALREADY formed."
  putStrLn "        Marginal arithmetic: ZERO.  One integer comparison per query."
  putStrLn ""
  putStrLn "    STEP MODEL: 1 step = one modular multiplication-with-reduction, OR"
  putStrLn "    one exact integer multiplication, OR one division-with-remainder."
  putStrLn "    Counts are exact integers from this module's own loops.  No timings."
  putStrLn ""
  putStrLn ("    " ++ padL 6 "q" ++ padL 5 "b" ++ padL 8 "e_b(q)"
            ++ padL 9 "depth" ++ padL 12 "R1 depth" ++ padL 12 "R1 a=1..4"
            ++ padL 12 "R2 marginal" ++ padL 12 "sensor form")
  putStrLn ("    " ++ replicate 76 '-')

  let rows = mapMaybe (\(q,b) -> costRow 4 q b) costPairs
  forM_ rows $ \r ->
    putStrLn ("    " ++ padL 6 (show (crQ r)) ++ padL 5 (show (crB r))
              ++ padL 8 (show (crE r)) ++ padL 9 (show (crDepth r))
              ++ padL 12 (show (crNaive r)) ++ padL 12 (show (crFamily r))
              ++ padL 12 "0" ++ padL 12 (show (crSensor r))
              ++ (if crE r == crDepth r then "" else "   <-- DISAGREE"))

  let mergeOK  = length rows == length costPairs
                 && all (\r -> crE r == crDepth r) rows
      totNaive = sum (map crNaive rows)
      totFam   = sum (map crFamily rows)
      totSens  = sum (map crSensor rows)
  putStrLn ("    " ++ replicate 76 '-')
  putStrLn ("    " ++ padL 19 "TOTAL" ++ padL 21 (show totNaive)
            ++ padL 12 (show totFam) ++ padL 12 "0" ++ padL 12 (show totSens))
  putStrLn ""
  putStrLn ("    Two organs as strangers, over these " ++ show (length rows)
            ++ " pairs, answering a = 1..4:")
  putStrLn ("      sensor formation " ++ show totSens ++ " + blindness "
            ++ show totFam ++ " = " ++ show (totSens + totFam) ++ " steps.")
  putStrLn ("    Merged: " ++ show totSens ++ " steps, and the blindness answer is a"
            ++ " comparison.")
  putStrLn ("    Eliminated: " ++ show totFam ++ " steps — the blindness organ's"
            ++ " ENTIRE arithmetic,")
  putStrLn "    not a fraction of it.  The saving is structural: R1's cost grows with"
  putStrLn "    the number of queries a and with log(q^a); R2's is a-independent and"
  putStrLn "    was already paid by the mined law, which evaluates e at every probe."
  putStrLn ""
  putStrLn ""
  putStrLn "    THE CONTRAST AS A CLOSED FORM, not as a table.  Route 1's query at"
  putStrLn "    depth a costs exactly bitlen(q^a-1) + popcount(q^a-1) steps and does"
  putStrLn "    not depend on b (checked above); bitlen(q^a-1) is linear in a"
  putStrLn "    (checked above), so route 1 over a = 1..A is Theta(A^2 log q) while"
  putStrLn "    route 2 is 0 for every A.  Derived, exact, no fitted exponent:"
  putStrLn ""
  putStrLn ("      " ++ padR 8 "q" ++ padL 6 "A" ++ padL 14 "R1 steps"
            ++ padL 14 "R2 steps")
  putStrLn ("      " ++ replicate 42 '-')
  forM_ [(11 :: Integer), 1093] $ \q ->
    forM_ [1, 2, 4, 8, 16, 32 :: Integer] $ \amax ->
      putStrLn ("      " ++ padR 8 (show q) ++ padL 6 (show amax)
                ++ padL 14 (show (naiveFamilyDerived q amax)) ++ padL 14 "0")
  putStrLn ""
  putStrLn "    STATED AGAINST MYSELF: for a SINGLE query at small a on a pair whose"
  putStrLn "    head is not yet formed, route 1 is cheaper — see (1093,2) and"
  putStrLn "    (3511,2), where forming the head costs more than one Fermat test,"
  putStrLn "    because ord_q(b) is found by this module's linear scan.  The merge"
  putStrLn "    wins where the head is ALREADY formed (it is: the miner forms it for"
  putStrLn "    every probe) or where more than one depth is queried."

  ------------------------------------------------------------------ verdict
  let dOK    = and dRows && p2OneFails && p2TwoWorks && universal
      allOK  = minerOK && and vs && and ns' && dOK && mergeOK
  putStrLn ""
  putStrLn "==========================================================================="
  putStrLn ("SELF-TEST: " ++ (if allOK then "PASS" else "FAIL")
            ++ "   [miner " ++ verdict minerOK
            ++ " | §V " ++ verdict (and vs)
            ++ " | negative controls " ++ verdict (and ns')
            ++ " | §D " ++ verdict dOK
            ++ " | §C " ++ verdict mergeOK ++ "]")
  putStrLn "==========================================================================="
  if allOK then exitSuccess else exitFailure
  where
    verdict True  = "ok"
    verdict False = "FAILED"
