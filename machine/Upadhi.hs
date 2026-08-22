-- Upadhi — the defeating condition a pervasion misses.
--
-- NYAYA.  A vyapti is a pervasion: wherever smoke, there fire.  What
-- licenses it?  The Naiyayikas' answer turns on the UPADHI — the
-- adventitious condition under which the pervasion fails.  Smoke pervades
-- fire only given wet fuel; wet fuel is the upadhi, and a vyapti with an
-- undetected upadhi is not knowledge, it is a hasty generalisation.
-- (Gautama, Nyayasutra; the upadhi machinery is developed by the
-- Navya-Naiyayikas, Gangesa's Tattvacintamani, 14th c.)
--
-- THE ENGINE ASSERTS VYAPTI FROM 40 INSTANCES.  `MathMachine.assignments`
-- (873-879) draws kAssign = 40 assignments from an LCG and reduces every
-- variable `mod 9`.  Two terms agreeing on all 40 are declared to have the
-- same fingerprint and the equation between them is sent to the kernel.
--
-- MEASURED — how much of the space those 40 actually see:
--
--     arity 1:   9 distinct of     9   = 100%
--     arity 2:  29 distinct of    81   = 35.8%
--     arity 3:  38 distinct of   729   =  5.2%
--     arity 4:  40 distinct of  6561   =  0.61%
--
-- The constant is wrong in BOTH directions.  At arity 1 it spends 40
-- evaluations to reach 9 points — 31 of every 40 are redundant, on the most
-- common shape in the library.  At arity 4 it sees six-tenths of one percent,
-- and arity 4 is exactly where `PairVocab`'s bcx1/bcx2/bcy live.
--
-- WHAT I DID NOT FIND, recorded because it constrains the claim.  I searched
-- all depth<=2 terms over 2 variables — 51 terms, 19 fingerprint classes —
-- for two terms agreeing on all 40 engine assignments and differing on a
-- wider probe including values 9, 10, 13, 17, 40.  ZERO.  So the sampler is
-- structurally thin; it is NOT demonstrated to be producing false
-- conjectures at small depth and low arity.  The risk is real and the
-- failure is unobserved, and those are different statements.
--
-- Two places the risk becomes live, neither yet measured:
--   * arity 4 (PairVocab) at 0.61% coverage — I could not search it here
--     because this module has no pair symbols;
--   * any vocabulary whose constants exceed 8.  `mod 9` means no variable is
--     ever bound above 8.  For the arithmetic vocabulary at kSizeCap = 7
--     that is probably harmless — the largest numeral expressible in size 7
--     is s^6(0) = 6 — but CyclotomicVocab and HeadDepthVocab concern primes
--     and q^a, which live far above 9, and there the cap is a wall.
--
-- THE FIX is not a bigger constant.  It is to scale with arity and to
-- include the boundary deliberately rather than hoping an LCG lands there.

module Upadhi
  ( assignmentsFor
  , engineAssignments
  , coverage
  , selfTest
  ) where

import Data.List (nub)

lcg :: Integer -> Integer
lcg x = (6364136223846793005 * x + 1442695040888963407) `mod` (2 ^ (62 :: Int))

-- The engine's generator, reproduced verbatim so the comparison is exact.
engineAssignments :: Int -> Int -> [[Integer]]
engineAssignments nv sampleCount = go 12345 sampleCount
  where
    go _ 0 = []
    go s k = let vals = take nv (drop 1 (iterate lcg s))
                 env  = map (\v -> v `mod` 9) vals
             in env : go (lcg (s + 7)) (k - 1)

-- Arity-scaled, boundary-inclusive.
--
-- Three parts, in this order, because the cheapest refutations should come
-- first: the corners (every combination of 0, 1, 2 — where monus, le and max
-- change behaviour), then a spread that deliberately crosses 9, then LCG
-- fill.  Deterministic: no system entropy, so a verdict is reproducible.
assignmentsFor :: Int -> [[Integer]]
assignmentsFor nv = nub (corners ++ spread ++ fill)
  where
    corners = seqN nv [0, 1, 2]
    spread  = [ take nv (cycle v) | v <- seqN (min nv 2) [0, 1, 7, 9, 13, 26] ]
    -- scale the random fill with the space, not with a constant
    fillN   = 24 * nv * nv
    fill    = go 12345 fillN
      where
        go _ 0 = []
        go s k = let vals = take nv (drop 1 (iterate lcg s))
                     env  = map (\v -> v `mod` 31) vals
                 in env : go (lcg (s + 7)) (k - 1)
    seqN 0 _ = [[]]
    seqN n xs = [ x : r | x <- xs, r <- seqN (n - 1) xs ]

-- distinct assignments produced, against the size of the engine's own box
coverage :: Int -> (Int, Int)
coverage nv = (length (nub (engineAssignments nv 40)), length (nub (assignmentsFor nv)))

selfTest :: IO Bool
selfTest = do
    putStrLn "  arity | engine distinct | arity-scaled distinct"
    mapM_ report [1 .. 4]
    -- the property that matters: never fewer than the engine, and the gap
    -- must widen with arity rather than staying flat
    let gaps = [ snd (coverage n) - fst (coverage n) | n <- [1 .. 4] ]
        monotone = and (zipWith (<=) gaps (tail gaps))
        neverWorse = all (>= 0) gaps
    putStrLn ("  gaps by arity: " ++ show gaps)
    putStrLn ("  never fewer than the engine: " ++ show neverWorse)
    putStrLn ("  gap widens with arity:       " ++ show monotone)
    pure (neverWorse && monotone)
  where
    report n = let (e, a) = coverage n
               in putStrLn ("    " ++ show n ++ "   |  " ++ show e ++ "  |  " ++ show a)

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only; nothing here is a correction to the module.
--
-- The sentence "the risk is real and the failure is unobserved, and those
-- are different statements" is now a checked theorem, in
-- `formal/cubical/NaturalMachine/TheSecondUpadhiConditionDoesAllTheWork.agda`
-- (--safe, no postulates, no holes).  What it establishes:
--
--   * The Naiyayika pair of conditions on an upadhi is not redundant.
--     Condition one alone (sadhya-vyapakatva) is met by U = S for EVERY
--     inference, with no hypothesis — so it carries no information.
--   * For that trivial candidate, condition two IS the failure of the
--     pervasion, as the same type (`refl`).
--   * Hence "some upadhi exists" and "the vyapti fails" are
--     interderivable.  Asserting that a defeating condition exists is
--     therefore NOT weaker evidence for the same claim; it is the same
--     claim.  Only a NAMED upadhi adds anything.
--
--   That is why this module's two sentences are genuinely different: the
--   thin-sampler observation names a candidate condition (agreement
--   beyond `mod 9`), while "unobserved failure" is the bare existential.
--
--   The named upadhi is exhibited there for a nine-point probe: two
--   functions agreeing on 0..8 and differing at 9.  It is NOT a pair of
--   engine terms, and this module's own negative search over depth<=2,
--   arity-2 terms — ZERO such pairs found — is untouched by it and is
--   restated there as standing.
-- ---------------------------------------------------------------------
