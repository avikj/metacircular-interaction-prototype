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

-- The simultaneous regime, run against the engine's own implementation of it.
--
--   sh machine/run-asiddhavat.sh
--
-- THREE COLUMNS, over the same corpus, with only the tie-break differing:
--
--   engine   `Astadhyayi.deriveAsiddhavat` as it stands: overlapping offers
--            inside the 6.4.22 block are settled by
--                foldl (\a b -> if num (fst b) > num (fst a) then b else a)
--            which is 1.4.2 para, alone, unnamed, with apavāda -- the metarule
--            that OUTRANKS it, and that the same file's `resolveN` tries first
--            at the sequential site -- never consulted.
--
--   named    the general scheduler with `tParatva = True`: apavāda, then
--            antaraṅga, then nitya, then para.  Same five paribhāṣās in
--            Nāgeśa Bhaṭṭa's own ranking, and the winner says which one
--            decided it.  Where this DIFFERS from `engine`, the engine's
--            unnamed para overrode a stronger metarule and changed a form.
--
--   6.4.22   the general scheduler with `tParatva = False`, ground
--            `Yugapatkrama`: para is not merely abstaining, it is not
--            AVAILABLE, because inside an asiddhavat block no rule is later
--            than any other.  Clashes that the three position-free metarules
--            do not settle come out अवक्तव्यम्, the block does not act at
--            that site, and the defect is written.  No fallback to pūrva: a
--            fallback is succession and succession is what this regime
--            denies.
--
-- WHAT A DIFFERENCE BETWEEN COLUMNS 2 AND 3 MEANS.  It is the exact measure
-- of how much of the engine's simultaneous derivation is being carried by a
-- metarule the regime forbids.  If they agree everywhere, the defect in
-- `asiddhavatPass` is latent on this corpus and not active -- which is a
-- fact worth having and is not the same as the defect not existing.
--
-- SOURCES.  Pāṇini, Aṣṭādhyāyī ~500 BCE, 6.4.22 / 8.2.1 / 1.4.2.  Nāgeśa
-- Bhaṭṭa, Paribhāṣenduśekhara c. 1730, paribhāṣā 38.  Akalaṅka,
-- Laghīyastraya c. 720-780, kramārpaṇa against sahārpaṇa.

import qualified Asiddhavat_TheSimultaneousBlockHasNoLaterAndItsClashesAreAvaktavya as Y
import qualified Vipratisedha_ConflictIsDecidedByMetaruleNotByListPosition as V
import qualified Astadhyayi as A

import Data.List (sortOn, nub)
import System.Exit (exitFailure, exitSuccess)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, setForeignEncoding, utf8)

------------------------------------------------------------------------
-- The tripādī as a simultaneous block.
--
-- `Astadhyayi.sectionB` is not exported, so it is rebuilt here from the two
-- things that are -- `sutras` and `tripadi` -- by the same definition the
-- file uses.  A copy of a DEFINITION is not a copy of a rule set.
------------------------------------------------------------------------

blockSutras :: [A.Sutra]
blockSutras = sortOn A.num [ s | s <- A.sutras, A.tripadi (A.num s) ]

-- Every offer the block makes on one input, computed against that input
-- alone.  This IS 6.4.22: no rule sees another's effect.
offersOn :: [A.Item] -> [(A.Sutra, A.Rewrite)]
offersOn xs = [ (s, r) | s <- blockSutras, r <- A.fires s (A.readingUnder [] s) xs ]

sasanani :: [V.Sasana [A.Item]]
sasanani =
  [ V.Sasana (A.num s) (A.text s) (A.apavadaTo s)
      (\xs -> [ V.Nyasa (A.rSutra r) (A.rPos r) (A.rLen r) (A.applyRw xs r) (A.rNote r)
              | r <- A.fires s (A.readingUnder [] s) xs ])
  | s <- blockSutras ]

tantraWith :: Bool -> V.Tantra [A.Item]
tantraWith paratva = V.Tantra
  { V.tSasanani  = sasanani
  , V.tApavada   = \_ _ -> False       -- declared, in `apavadaTo`
  , V.tAntaranga = \_ _ -> Nothing     -- Astadhyayi.hs encodes no nimitta depth
  , V.tOverlap   = \a b -> V.nyPos a < V.nyPos b + V.nyLen b
                        && V.nyPos b < V.nyPos a + V.nyLen a
  , V.tStratum   = const 0             -- the block is one stratum, by definition
  , V.tParatva   = paratva
  , V.tSame      = (==)
  }

-- Apply the winners of distinct overlap classes together.  They are pairwise
-- disjoint by construction, so the only bookkeeping is the domain's: rewrite
-- right-to-left so an earlier site keeps its index while a later one is
-- replaced.  `Astadhyayi.asiddhavatPass` does exactly this and this matches
-- it deliberately -- the regimes are being compared, not the arithmetic.
--
-- A `V.Nyasa` carries the object after ITS OWN offer, not the offer, so the
-- rewrite is recovered from the input by its address (sūtra, position,
-- length).  The offers came from this input, so the lookup is exact.
sahaYojana :: [A.Item] -> [V.Nyasa [A.Item]] -> [A.Item]
sahaYojana xs ws =
  foldl A.applyRw xs (reverse (sortOn A.rPos (concatMap recover ws)))
  where
    pool = map snd (offersOn xs)
    recover w = take 1 [ r | r <- pool
                           , A.rSutra r == V.nyRule w
                           , A.rPos r == V.nyPos w
                           , A.rLen r == V.nyLen w ]

yugapatWith :: Bool -> Y.Yugapat [A.Item]
yugapatWith paratva = Y.Yugapat
  { Y.yuTantra = tantraWith paratva
  , Y.yuBlock  = sasanani
  , Y.yuSaha   = sahaYojana
  , Y.yuHetu   = if paratva then Y.Adhikrtakrama else Y.Yugapatkrama
  }

------------------------------------------------------------------------
-- Phase A, exactly as `Astadhyayi.deriveAsiddhavat` runs it: the mutually
-- siddha section to a fixpoint, then ONE simultaneous pass over the block.
------------------------------------------------------------------------

phaseA :: [A.Item] -> [A.Item]
phaseA = go (64 :: Int)
  where
    go 0 xs = xs
    go k xs = case A.stepANUnder [] xs of
      Nothing            -> xs
      Just (w, _, _, _)  -> let ys = A.applyRw xs w
                            in if ys == xs then xs else go (k - 1) ys

runNamed :: Bool -> String -> Y.Phala [A.Item]
runNamed paratva = Y.yugapatPada (yugapatWith paratva) . phaseA . A.parseInput

------------------------------------------------------------------------

corpus :: [String]
corpus =
  [ "vāc", "rāmas", "tat + ca", "tat + jalam", "tat + śiva"
  , "dadhi + indra", "deva + indra", "mahā + indra", "su + ukta"
  , "deva + ṛṣi", "mahā + ṛṣi", "madhu + ari", "deva + aiśvarya"
  , "te + api", "ne - ana" ]

main :: IO ()
main = do
  mapM_ (\f -> f utf8) [setLocaleEncoding, setFileSystemEncoding, setForeignEncoding]
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8

  putStrLn "ASIDDHAVAT -- the simultaneous block has no LATER, so it cannot use 1.4.2."
  putStrLn ""
  putStrLn "Pāṇini, Aṣṭādhyāyī ~500 BCE.  6.4.22 asiddhavad atrābhāt: inside the block"
  putStrLn "a rule's effect counts as not having taken place for every OTHER rule of"
  putStrLn "the block -- mutual blindness, the rules apply yugapat, at once.  8.2.1"
  putStrLn "pūrvatrāsiddham is the other device and is one-way.  1.4.2 vipratiṣedhe"
  putStrLn "paraṃ kāryam picks the LATER operation, which presupposes a sequence of"
  putStrLn "operations; 6.4.22 says there is none."
  putStrLn ""
  putStrLn "Akalaṅka, Laghīyastraya c. 720-780: kramārpaṇa (in succession) against"
  putStrLn "sahārpaṇa (at once).  What cannot be said under simultaneous assertion is"
  putStrLn "avaktavyam, the FOURTH position -- not unknown, not undefined, not empty."
  putStrLn ""

  putStrLn "== the three columns ==================================================="
  putStrLn ""
  putStrLn ("  " ++ pad 16 "input" ++ pad 14 "engine" ++ pad 14 "named"
            ++ pad 14 "6.4.22" ++ "metarules used")
  putStrLn ("  " ++ replicate 72 '-')
  rows <- mapM row corpus
  putStrLn ""

  let engineVsNamed = [ w | (w, e, n, _, _) <- rows, e /= n ]
      namedVs6422   = [ w | (w, _, n, s, _) <- rows, n /= s ]
      allDosa       = concat [ ds | (_, _, _, _, ds) <- rows ]

  putStrLn "== what the columns say ================================================"
  putStrLn ""
  report "engine vs named   " engineVsNamed
    "the engine's unnamed para overrode a stronger metarule and changed a form"
    "on this corpus no clash inside the block has an apavāda, an antaraṅga or a\n     nitya available, so naming the metarules does not move a single form --\n     the defect in `asiddhavatPass` is LATENT here, which is not the same as\n     absent, and a corpus that reached 6.4's own sūtras could activate it"
  putStrLn ""
  -- WHICH metarule the engine's unnamed para displaced, computed rather than
  -- asserted: for each input where the columns differ, the metarules the
  -- named run actually used.
  mapM_ (\w -> putStrLn ("     " ++ w ++ ": the named run acted by "
                         ++ unwords (nub [ show (Y.kaBalya k)
                                         | k <- Y.phKaryani (runNamed True w) ])
                         ++ ", which outranks para"))
        engineVsNamed
  putStrLn ""
  report "named vs 6.4.22   " namedVs6422
    "para is carrying these forms, and 6.4.22 forbids para -- each is a site\n     where the engine's simultaneous derivation depends on succession"
    "no form in this corpus depends on para inside the block"
  putStrLn ""

  putStrLn "== the defect ledger, sahārpaṇa ========================================"
  putStrLn ""
  putStrLn "  READ THE `Para` LINE BELOW AGAINST THE `regime:` LINE UNDER IT.  The"
  putStrLn "  scheduler reports para's silence as \"the domain declares its rule order"
  putStrLn "  unauthored: a list index is not a position\" -- and that is the WRONG"
  putStrLn "  ground here.  The sūtra numbers ARE authored; 6.4.22 forbids reading"
  putStrLn "  them.  `V.Tantra` carries one Bool for both grounds, so a ledger built"
  putStrLn "  from it cannot tell a MISSING AUTHORSHIP (fixable: author the order and"
  putStrLn "  1.4.2 returns) from a STRUCTURAL PROHIBITION (not fixable, ever).  The"
  putStrLn "  `regime:` line is that distinction, supplied by `Paratvahetu`."
  putStrLn ""
  if null allDosa
    then putStrLn "  no clash inside the simultaneous block went undecided on this corpus."
    else mapM_ (putStrLn . ("  " ++)) (concatMap (Y.showAvaktavya Y.Yugapatkrama) allDosa)
  putStrLn ""

  putStrLn "== one clash, in full =================================================="
  putStrLn ""
  showFull "vāc"
  putStrLn ""

  putStrLn "== HONEST COVERAGE ====================================================="
  putStrLn ""
  mapM_ (putStrLn . ("  " ++)) A.coverage
  putStrLn ""
  putStrLn "  This module adds ONE STRATUM MODE and ZERO SŪTRAS.  The number above"
  putStrLn "  does not move because of it.  No sūtra of 6.4 is encoded anywhere in"
  putStrLn "  this repository; running the tripādī's rules simultaneously is the"
  putStrLn "  counterfactual Astadhyayi.hs §7a already declares itself to be."
  putStrLn ""

  case A.selfTest of
    [] -> putStrLn "  Astadhyayi.selfTest: all checks pass."
    fs -> mapM_ (putStrLn . ("  Astadhyayi.selfTest FAILED: " ++)) fs

  -- WHAT COUNTS AS A FAILURE HERE.  A difference between columns is a FINDING
  -- and never a failure -- reporting it is the point of the run.  These four
  -- are structural properties of the regime, and if one of them breaks the
  -- module is wrong about 6.4.22 rather than the engine being wrong about it.
  putStrLn ""
  putStrLn "== structural checks ==================================================="
  putStrLn ""
  let allInputs = map (phaseA . A.parseInput) corpus

      -- 1. `varga` is a PARTITION: nothing double-counted, nothing dropped.
      partitionOk =
        and [ length (concat (Y.varga (tantraWith False) offers)) == length offers
            | xs <- allInputs
            , let offers = concatMap (\s -> V.saFires s xs) sasanani ]

      -- 2. classes are genuinely non-contending across the partition, so
      --    applying their winners together is not itself a hidden ordering.
      disjointOk =
        and [ not (V.tOverlap (tantraWith False) a b)
            | xs <- allInputs
            , let cls = Y.varga (tantraWith False) (concatMap (\s -> V.saFires s xs) sasanani)
            , (i, c1) <- zip [(0::Int) ..] cls, (j, c2) <- zip [0 ..] cls, i /= j
            , a <- c1, b <- c2 ]

      -- 3. under 6.4.22 no action is ever authorised by a POSITIONAL metarule.
      noPositional =
        [ (w, b) | w <- corpus
                 , k <- Y.phKaryani (runNamed False w)
                 , let b = Y.kaBalya k
                 , b == V.Para || b == V.Purva ]

      -- 4. where nothing came out avaktavya, forbidding para lost nothing:
      --    the two columns must agree.  A disagreement WITHOUT a written
      --    defect would mean a form changed silently, which is the collapse.
      silentLoss =
        [ w | (w, _, n, s, ds) <- rows, null ds, n /= s ]

      broken =
        [ "varga is not a partition of the offers"     | not partitionOk ]
        ++ [ "two distinct overlap classes contend"    | not disjointOk ]
        ++ [ "a positional metarule authorised an action under 6.4.22: "
             ++ show noPositional                      | not (null noPositional) ]
        ++ [ "a form changed with no defect written: " ++ unwords silentLoss
                                                       | not (null silentLoss) ]

  putStrLn ("  varga is a partition of the offers ........... "
            ++ yn partitionOk)
  putStrLn ("  distinct overlap classes do not contend ...... "
            ++ yn disjointOk)
  putStrLn ("  no Para and no Purva authorises anything ..... "
            ++ yn (null noPositional))
  putStrLn ("  no form changes without a written defect ..... "
            ++ yn (null silentLoss))
  putStrLn ""
  mapM_ (putStrLn . ("  CHECK FAILED: " ++)) broken
  if not (null A.selfTest) || not (null broken) then exitFailure else exitSuccess

  where
    yn b = if b then "yes" else "NO"

    pad n s = s ++ replicate (max 1 (n - length s)) ' '

    row w = do
      let e  = A.deriveAsiddhavat w
          pn = runNamed True w
          ps = runNamed False w
          n  = A.render (Y.phResult pn)
          s  = A.render (Y.phResult ps)
          used = nub [ show (Y.kaBalya k) | k <- Y.phKaryani pn ]
      putStrLn ("  " ++ pad 16 w ++ pad 14 e ++ pad 14 n ++ pad 14 s
                ++ unwords used
                ++ (if null (Y.phAvaktavya ps) then ""
                     else "  [" ++ show (length (Y.phAvaktavya ps)) ++ " avaktavya]"))
      return (w, e, n, s, Y.phAvaktavya ps)

    report name xs whenSome whenNone = do
      putStrLn ("  " ++ name ++ ": " ++ show (length xs) ++ " of "
                ++ show (length corpus) ++ " inputs differ")
      if null xs
        then putStrLn ("     " ++ whenNone)
        else do putStrLn ("     " ++ unwords xs)
                putStrLn ("     " ++ whenSome)

    showFull w = do
      let xs = phaseA (A.parseInput w)
      putStrLn ("  " ++ w ++ " reaches the block as " ++ A.render xs)
      putStrLn "  every offer the block makes on it, each computed against that input"
      putStrLn "  alone -- which is the whole of 6.4.22:"
      mapM_ (\(s, r) -> putStrLn ("    " ++ V.showSthana (A.num s) ++ "  "
                                  ++ A.text s ++ "  at " ++ show (A.rPos r)
                                  ++ "+" ++ show (A.rLen r) ++ "  -- " ++ A.rNote r))
            (offersOn xs)
      let p = Y.yugapatPada (yugapatWith False) xs
      putStrLn "  under 6.4.22 (para not available):"
      mapM_ (putStrLn . ("    " ++)) (concatMap Y.showKarya (Y.phKaryani p))
      mapM_ (putStrLn . ("  " ++))
            (concatMap (Y.showAvaktavya Y.Yugapatkrama) (Y.phAvaktavya p))
      putStrLn ("    result: " ++ A.render (Y.phResult p))
