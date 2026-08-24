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

-- Run the standpoint-collapse decision on real cases.
--     runghc -imachine machine/NayaRun.hs
import Naya
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, utf8)

caseOf :: String -> Bool -> [Naya] -> IO ()
caseOf title saha ns = do
  putStrLn ""
  putStrLn ("== " ++ title ++ " " ++ replicate (max 0 (66 - length title)) '=')
  mapM_ (\n -> putStrLn ("  naya `" ++ nayaName n ++ "` : "
                         ++ show (length (witnesses n)) ++ " witness(es)")) ns
  putStrLn ("  asserted: " ++ (if saha then "SIMULTANEOUSLY (saha)" else "IN SUCCESSION (krama)"))
  putStrLn ""
  mapM_ putStrLn (render (decide saha ns))

main :: IO ()
main = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8; hSetEncoding stdout utf8
  putStrLn "=== NAYA: may these standpoints be collapsed into one verdict? ==="
  putStrLn "Decides the finite-witness fragment.  Spec: formal/cubical/"
  putStrLn "ApohaParyaya_… and NaturalMachine/Durnaya_TheProhibitionHasContent…"

  -- 1. The case the whole corpus is about: two documented positions.
  caseOf "the 2022/2025 statements" True
    [ Naya "harm-is-real"
        [ "Oct 2022 antisemitic statements, publicly, incl. threats"
        , "2025 posts incl. praise of Hitler"
        , "Jewish organisations and individuals condemned it; people frightened"
        , "a thousand years of expulsion, ghettos, six million murdered 1941-45" ]
    , Naya "episode-is-real"
        [ "documented four-month manic-psychotic episode from early 2025"
        , "stated periods of not wanting to be alive"
        , "diagnosed bipolar at 39; 2016 UCLA hold"
        , "psychosis produces paranoia, grandiosity, loss of shared reality" ] ]

  -- 2. The same two, in succession rather than at once.
  caseOf "the same two, asserted one after the other" False
    [ Naya "harm-is-real"    [ "the statements", "the fear", "the history" ]
    , Naya "episode-is-real" [ "the episode", "the diagnosis", "the suicidality" ] ]

  -- 3. The anti-sycophancy case.  A machine that always says
  --    "hold both" is worthless.  This must be able to say YES.
  caseOf "two framings of one finding (must return YES)" True
    [ Naya "sleep-loss-precipitates-mania"
        [ "Wehr Sack Rosenthal 1987", "experimental sleep deprivation in bipolar patients" ]
    , Naya "mania-follows-lost-sleep"
        [ "Wehr Sack Rosenthal 1987", "experimental sleep deprivation in bipolar patients" ] ]

  -- 4. Affirm/deny: the third bhanga, not the fourth.
  caseOf "one affirms, one has nothing under it" False
    [ Naya "transmission-is-documented" []
    , Naya "motive-opportunity-proximity"
        [ "Jesuits in Cochin from mid-1500s"
        , "Ricci wrote to Rome in 1581 asking about Indian calendrical computation"
        , "longitude problem needed better trigonometric tables"
        , "Yuktibhasa written in that region c. 1530" ] ]

  -- 5. Apoha-shaped: every standpoint proposition-valued (<=1 witness).
  --    ApohaParyaya §3: agreement degenerates to mutual entailment.
  caseOf "apoha-shaped standpoints (one witness each)" True
    [ Naya "excludes-non-cow" [ "not-non-cow" ]
    , Naya "excludes-non-bovine" [ "not-non-cow" ] ]

  -- 6. Outside the fragment: refuse rather than guess.
  caseOf "a standpoint with an empty witness label" True
    [ Naya "a" [ "" ], Naya "b" [ "x" ] ]
