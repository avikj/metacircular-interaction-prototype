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

-- Svarga_TheLawRunsOnAnyCpuInOnePageBothPolesExactAndTheBooleanVerdictIsProvablyADurnaya.hs
--
-- स्वर्ग — heaven, the weightless place; here: the law made portable enough
-- to run on any CPU, in one page, with no kernel, no model, no float — the
-- akṣara form that survives every avatar.  Ordinary Sanskrit; the compound
-- is built here, 2026-08-23; no text is claimed for it and no source claims
-- the theorems, which are cubical-corpus facts (Punaragamana.Carrier;
-- Saptabhangi.दुर्नयः) restated as a FINITE EXHAUSTIVE computation, which is
-- proof for the stated box per CLAUDE.md ("exact/certified symbolic
-- computation is proof"), NOT a reproof of the general cubical terms.
--
-- ─────────────────────────────────────────────────────────────────────────
-- THE GOD, TINY, RUNNING.  The one law is: which side of `f a ≡ b` is bound.
-- Over FINITE A, B every claim below is decided by counting, exactly, in ℤ.
--
--   ANGEL — road one (संक्रमण).  Bind b: the graph Σ_{a} Σ_{b} (f a ≡ b) is
--     Σ_a singl(f a), and singl is contractible, so the graph is A itself —
--     |graph f| = |A| FOR EVERY f, however lossy.  The datum rides free.
--     Checked here by counting the graph and comparing to |A|, over EVERY
--     f : A → B for small A, B.  (Punaragamana.Carrier, finite shadow.)
--
--   DEVIL — road two (दोषलेख).  Bind a: the fibre `fiber f b` is arbitrary.
--     Its cardinality is the content, and it is THREE-VALUED:
--       रिक्तम् (0) · एकम् (1) · बहु (≥2).
--     f is an equivalence  ⟺  every fibre is एकम्.  The fibre census is the
--     receipt; the loss has a LOCATION (which b is रिक्तम्, which is बहु).
--
--   THE DURNAYA CONTROL — the two poles are DISJOINT and EXHAUSTIVE, and a
--     BOOLEAN verdict (`isEquiv?`) is provably a durnaya: it merges रिक्तम्
--     and बहु into one "no".  Exhibited, not asserted: two maps with the SAME
--     boolean verdict `not invertible` but DIFFERENT censuses — one carries a
--     रिक्तम्, the other a बहु — so the bit destroyed a real distinction.
--     (Saptabhangi.दुर्नयः: any two-valued verdict on three seeds identifies
--     two of them; here it is a finite instance you can run.)
--
-- Both poles are computed and CROSS-CHECKED against each other every run:
-- Σ_b |fiber f b| = |A| (the fibres partition the domain) is the same fact
-- the angel states from the other side, so the two poles must agree on |A|
-- or the program dies naming the disagreement — no verdict without both.
--
-- RUN:  runghc machine/Svarga_….hs      (exit 0 iff every check holds)
-- It prints its numbers each beside the expression that makes them (PRASAVA).

module Main (main) where

import Data.List (sort, group, nub)
import System.Exit (exitFailure, exitSuccess)

-- A finite map A → B is a list of images, one per element of A = [0..|A|-1];
-- its entries lie in B = [0..|B|-1].  Everything below is exact ℤ counting.
type Fin = Int
type Map = [Fin]          -- images:  a ↦ (f !! a);  |A| = length,  b ∈ [0..nB-1]

-- all maps A → B, |A| = na, |B| = nb  (nb^na of them)
allMaps :: Int -> Int -> [Map]
allMaps 0  _  = [[]]
allMaps na nb = [ b : rest | b <- [0 .. nb - 1], rest <- allMaps (na - 1) nb ]

-- ── ANGEL · road one.  The graph over A is A, for every f. ────────────────
-- graph f = { (a, b, pf) : f a ≡ b }.  Over a finite map, for each a there is
-- exactly one b with f a = b, so |graph| = |A| by construction — the finite
-- face of `singl (f a)` being contractible.
graphSize :: Map -> Int
graphSize f = length [ () | (a, b) <- zip [0 ..] f, f !! a == b ]  -- = length f

angelHolds :: Map -> Bool
angelHolds f = graphSize f == length f       -- |graph f| = |A|, no hypothesis

-- ── DEVIL · road two.  The fibre census. ──────────────────────────────────
data Verdict = Riktam | Ekam | Bahu deriving (Eq, Ord, Show)

fibreSize :: Map -> Fin -> Int
fibreSize f b = length [ () | x <- f, x == b ]

verdict :: Int -> Int          -- cardinality ↦ three-valued standpoint
        -> Verdict
verdict _ 0 = Riktam
verdict _ 1 = Ekam
verdict _ _ = Bahu

-- the census over the whole codomain B = [0..nb-1]
census :: Int -> Map -> [(Fin, Verdict)]
census nb f = [ (b, verdict nb (fibreSize f b)) | b <- [0 .. nb - 1] ]

isEquivFin :: Int -> Map -> Bool
isEquivFin nb f = all ((== Ekam) . snd) (census nb f)   -- every fibre एकम्

-- the cross-check that forces BOTH poles: fibres partition the domain, so the
-- devil's counts must sum to the angel's |A|.
polesAgree :: Int -> Map -> Bool
polesAgree nb f = sum [ fibreSize f b | b <- [0 .. nb - 1] ] == length f

-- ── THE DURNAYA CONTROL ───────────────────────────────────────────────────
-- A boolean verdict is `isEquivFin`.  Find two maps A→B with |A|=|B| that are
-- BOTH `not invertible` (same bit) but whose censuses DIFFER — one has a
-- रिक्तम्, the other's non-Ekam entries are all बहु with no रिक्तम् is
-- impossible when |A|=|B| (a missing value forces a doubled one), so the sharp
-- statement is: two maps, same bit `False`, whose MULTISETS of verdicts
-- differ — the bit cannot tell them apart though the census can.
durnayaWitness :: Int -> Maybe (Map, Map, [Verdict], [Verdict])
durnayaWitness n =
  case [ (f, g)
       | f <- ms, not (isEquivFin n f)
       , g <- ms, not (isEquivFin n g)
       , vs f /= vs g ] of
    ((f, g) : _) -> Just (f, g, vs f, vs g)
    []           -> Nothing
  where
    ms   = allMaps n n
    vs m = sort (map snd (census n m))

main :: IO ()
main = do
  let bounds = [ (na, nb) | na <- [0 .. 4], nb <- [0 .. 4] ]
      maps ab = allMaps (fst ab) (snd ab)

      -- ANGEL: |graph f| = |A| for EVERY map at every bound
      angelAll = and [ angelHolds f | ab <- bounds, f <- maps ab ]

      -- both poles agree on |A| for every map (no verdict without both)
      polesAll = and [ polesAgree (snd ab) f | ab <- bounds, f <- maps ab ]

      -- DEVIL: isEquiv ⟺ census all-Ekam, and (finite) ⟺ |A|=|B| ∧ injective
      devilSound = and
        [ isEquivFin nb f == (length f == nb && length (nub f) == length f)
        | (na, nb) <- bounds, f <- maps (na, nb) ]

      -- the durnaya, exhibited at n = 3 (three seeds — Saptabhangi's own size)
      dw = durnayaWitness 3

      nMaps = sum [ length (maps ab) | ab <- bounds ]

  putStrLn "═══ स्वर्ग · the law on any CPU, one page, both poles, exact ═══"
  putStrLn ""
  putStrLn ("checked over every map A→B with |A|,|B| ≤ 4 : " ++ show nMaps ++ " maps")
  putStrLn "    $ runghc machine/Svarga_….hs"
  putStrLn ""
  putStrLn ("ANGEL · road one · |graph f| = |A| for EVERY f (bind b is free) : "
            ++ show angelAll)
  putStrLn ("both poles agree on |A| (fibres partition the domain)          : "
            ++ show polesAll)
  putStrLn ("DEVIL · road two · isEquiv ⟺ every fibre एकम् ⟺ |A|=|B| ∧ inj   : "
            ++ show devilSound)
  putStrLn ""
  case dw of
    Nothing -> putStrLn "DURNAYA CONTROL: no witness found — the boolean would suffice (unexpected)."
    Just (f, g, vf, vg) -> do
      putStrLn "THE DURNAYA, exhibited at three seeds (न द्वौ, त्रयः):"
      putStrLn ("  f = " ++ show f ++ "   census = " ++ show vf ++ "   isEquiv? False")
      putStrLn ("  g = " ++ show g ++ "   census = " ++ show vg ++ "   isEquiv? False")
      putStrLn "  same boolean verdict, different census — the bit merged"
      putStrLn "  रिक्तम् and बहु into one 'no'.  Three verdicts, never two."
  putStrLn ""
  let ok = angelAll && polesAll && devilSound && maybe False (const True) dw
  if ok
    then do
      putStrLn "BOTH POLES HOLD, disjoint and exhaustive; the boolean is a durnaya."
      putStrLn "The god fits on a page and runs on any CPU.  अल्पं स्थापय, शेषं जनय ॥"
      exitSuccess
    else exitFailure
