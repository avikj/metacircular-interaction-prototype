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

-- Run the general scheduler on TWO domains and check it is the same machine.
--
--   ./vipratisedha
--
-- Domain 1: the Aṣṭādhyāyī itself.  `Astadhyayi.hs` has its own hand-written
-- `resolve` and its own two-phase `deriveTrace`.  The general scheduler is
-- pointed at the same sūtras and must reach the SAME forms, step for step,
-- by the same metarules.  That is the transport check: if the general layer
-- lost anything in the lift, the derivations diverge and this says so.
--
-- Domain 2: MathMachine's term rewriting -- run from inside MathMachine
-- itself, `./math-machine --vipratisedha-self-test`, because the engine is a
-- `Main` module and cannot be imported.  This runner names the command rather
-- than duplicating the rule set, which would be a copy pretending to be a
-- call path.
--
-- WHAT THE TWO DOMAINS SHOW TOGETHER.  Same four metarules, and they resolve
-- DIFFERENTLY, because the domains differ in what they are entitled to claim:
--
--   * The Aṣṭādhyāyī has authored positions.  A sūtra's number is a statement
--     about its neighbours, so 1.4.2 paratva decides, and `dadhi + indra`
--     exhibits it: 6.1.77 and 6.1.101 both want the same site, and 101 wins
--     because 101 > 77.
--   * MathMachine's rule list is a concatenation of three collections that
--     were never placed with respect to each other.  It sets
--     `tParatva = False`, para abstains, and the undecided sites come out as
--     written defects instead of being broken by `(x:_)`.
--
-- Same machinery, opposite verdict on whether position may be read -- and
-- that difference is declared by the domain, in one field, rather than
-- being smuggled in by whichever list happened to be concatenated first.

import qualified Vipratisedha_ConflictIsDecidedByMetaruleNotByListPosition as V
import qualified Astadhyayi as A

import Data.List (sortOn, intercalate)
import System.Exit (exitFailure, exitSuccess)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, setForeignEncoding, utf8)

------------------------------------------------------------------------
-- The Aṣṭādhyāyī as a Tantra.  Nothing here is new grammar; it is the
-- adapter, and every field is a fact already stated in Astadhyayi.hs.
------------------------------------------------------------------------

sutraTantra :: V.Tantra [A.Item]
sutraTantra = V.Tantra
  { V.tSasanani =
      [ V.Sasana (A.num s) (A.text s) (A.apavadaTo s)
          -- `fires` takes a Reading, not a raw input: a sūtra is not complete
          -- by itself, it is complete with what anuvṛtti carries down into it
          -- (Astadhyayi.hs's own device).  The scheduler never sees that; it
          -- sees only the offers that come out.
          (\xs -> [ V.Nyasa (A.rSutra r) (A.rPos r) (A.rLen r)
                      (A.applyRw xs r) (A.rNote r)
                  | r <- A.fires s (A.readingUnder [] s) xs ])
      | s <- A.sutras ]
  , V.tApavada   = \_ _ -> False        -- declared, in saApavadaTo
  , V.tAntaranga = \_ _ -> Nothing      -- Astadhyayi.hs encodes no nimitta depth
  , V.tOverlap   = \a b -> V.nyPos a < V.nyPos b + V.nyLen b
                        && V.nyPos b < V.nyPos a + V.nyLen a
    -- 8.2.1 pūrvatrāsiddham, as a stratum number
  , V.tStratum   = \r -> if A.tripadi r then 1 else 0
    -- the sūtra numbers ARE authored positions.  This is the field the
    -- MathMachine instance sets to False.
  , V.tParatva   = True
  , V.tSame      = (==)
  }

corpus :: [String]
corpus =
  [ "dadhi + indra", "deva + indra", "mahā + indra", "su + ukta"
  , "deva + ṛṣi", "mahā + ṛṣi", "madhu + ari", "deva + aiśvarya"
  , "te + api", "ne - ana", "rāmas", "tat + ca", "tat + jalam", "vāc" ]

showRefs :: [V.Sthana] -> String
showRefs = intercalate " " . map V.showSthana

------------------------------------------------------------------------

main :: IO ()
main = do
  mapM_ (\f -> f utf8) [setLocaleEncoding, setFileSystemEncoding, setForeignEncoding]
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8

  putStrLn "VIPRATIṢEDHA -- one scheduler, two domains."
  putStrLn ""
  putStrLn "Pāṇini, Aṣṭādhyāyī ~500 BCE: 1.4.2 vipratiṣedhe paraṃ kāryam, 8.2.1"
  putStrLn "pūrvatrāsiddham, utsarga/apavāda.  Nāgeśa Bhaṭṭa, Paribhāṣenduśekhara"
  putStrLn "c. 1730, paribhāṣā 38: pūrva < para < nitya < antaraṅga < apavāda."
  putStrLn ""

  putStrLn "== DOMAIN 1: the Aṣṭādhyāyī ============================================"
  putStrLn ""
  putStrLn "The general scheduler pointed at Astadhyayi.hs's own sūtras.  Each line"
  putStrLn "compares the general layer's output with the hand-written engine's."
  putStrLn ""
  bad <- mapM checkOne corpus
  putStrLn ""

  putStrLn "== the conflict, in full ==============================================="
  putStrLn ""
  putStrLn "dadhi + indra: 6.1.77 iko yaṇ aci and 6.1.101 akaḥ savarṇe dīrghaḥ both"
  putStrLn "want the same site.  Neither is declared an apavāda to the other, the"
  putStrLn "domain abstains on antaraṅga, kṛtākṛtaprasaṅga is silent -- so para"
  putStrLn "decides, and it is entitled to, because sūtra numbers are authored."
  putStrLn ""
  let xs = A.parseInput "dadhi + indra"
      (padas, mdosa, out) = V.prakriya sutraTantra 64 xs
  mapM_ showPada padas
  putStrLn ("  result: " ++ A.render out)
  case mdosa of
    Nothing -> putStrLn "  no vipratiṣedha went undecided."
    Just d  -> mapM_ putStrLn (V.showDosa d)
  putStrLn ""

  putStrLn "== the defect ledger over the whole corpus ============================="
  putStrLn ""
  mapM_ (putStrLn . ("  " ++))
    (V.dosaLekha sutraTantra 64 (map A.parseInput corpus))
  putStrLn ""

  putStrLn "== DOMAIN 2: MathMachine's rewrite engine =============================="
  putStrLn ""
  putStrLn "Same module, same four metarules, wired into `step`'s root site in"
  putStrLn "machine/MathMachine.hs (the line that used to read `(x:_) -> Just x`)."
  putStrLn "MathMachine is a Main module and cannot be imported, so it runs itself:"
  putStrLn ""
  putStrLn "    ghc -O0 -o math-machine machine/MathMachine.hs"
  putStrLn "    ./math-machine --vipratisedha-self-test"
  putStrLn ""
  putStrLn "There apavāda decides (a defining clause is a strict instance of a"
  putStrLn "proved theorem's left-hand side) and para ABSTAINS, because a"
  putStrLn "concatenation is not an authorship."
  putStrLn ""

  putStrLn "== HONEST COVERAGE ====================================================="
  putStrLn ""
  mapM_ (putStrLn . ("  " ++)) A.coverage
  putStrLn ""
  putStrLn "  This module adds FOUR METARULES and ZERO SŪTRAS.  The number above"
  putStrLn "  does not move because of it."
  putStrLn ""

  case A.selfTest of
    [] -> putStrLn "  Astadhyayi.selfTest: all checks pass."
    fs -> mapM_ (putStrLn . ("  Astadhyayi.selfTest FAILED: " ++)) fs

  if or bad || not (null A.selfTest)
    then hPutStrLn stderr "TRANSPORT FAILED: the general scheduler and the hand-written engine disagree." >> exitFailure
    else exitSuccess

  where
    showPada p =
      putStrLn ("    " ++ V.showSthana (V.pdRule p) ++ "  " ++ V.pdName p
                ++ "\n        " ++ V.pdNote p
                ++ "\n        " ++ A.render (V.pdBefore p) ++ "  ⇒  "
                ++ A.render (V.pdAfter p)
                ++ (if null (V.pdBeaten p) then ""
                     else "\n        beat " ++ showRefs (V.pdBeaten p)
                          ++ " -- " ++ V.showBalya (V.pdBalya p)))

    checkOne w = do
      let ys = A.parseInput w
          (_, _, mine) = V.prakriya sutraTantra 64 ys
          theirs = A.derive w
          ok = A.render mine == theirs
      putStrLn ("  " ++ pad 18 w ++ "general: " ++ pad 14 (A.render mine)
                ++ "Astadhyayi.hs: " ++ pad 14 theirs
                ++ (if ok then "same" else "DIVERGED"))
      return (not ok)

    pad n s = s ++ replicate (max 1 (n - length s)) ' '
