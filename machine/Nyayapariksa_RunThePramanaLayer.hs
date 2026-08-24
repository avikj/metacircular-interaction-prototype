-- Nyāyaparīkṣā — न्यायपरीक्षा, the examination: turn the key on the pramāṇa
-- layer.  Runs every self-test in it, and then classifies this engine's own
-- refusals into the hetvābhāsa taxonomy, over the log that is actually on
-- disk, with the log's path and line count printed above every figure.
--
-- WHY THIS FILE EXISTS AT ALL.  `machine/Yogyata.hs`'s header records the
-- measured cost of a module nothing imports: 896 lines of `Upamana.hs` sat
-- unread, `Pramana.hs`'s own table called the pramāṇa it implements ABSENT,
-- and the first run found three defects that had been latent since the file
-- was written.  A module with a `selfTest` that nothing calls is in exactly
-- that state.  So the layer lands with its runner, on the same day, or it does
-- not land.
--
-- WHY THE LOG PATH IS PRINTED.  `ANEKANTA.md` §19: `.gitignore` excludes
-- `machine/machine.log`, so every census figure this repository ever published
-- about the machine was measured against a file in no clone, and when the log
-- grew (1457 -> 1709 rejection lines, 1303 -> 1540 residuals) nothing could
-- have told a reader which log a number came from.  A count without its input
-- is a constant without its scaling.  Every number below is printed under the
-- path and line count it came from, and if the log is missing the census says
-- so rather than printing zeros.
--
--   runghc -imachine machine/Nyayapariksa_RunThePramanaLayer.hs
--   runghc -imachine machine/Nyayapariksa_RunThePramanaLayer.hs <some.log>
--
-- Exit code is 1 if any self-test fails and 0 otherwise.  The CENSUS never
-- affects the exit code: it is a description of a log, and a log is not a
-- regression.

module Main (main) where

import System.Environment (getArgs)
import System.Directory (doesFileExist)
import System.Exit (exitFailure, exitSuccess)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding)
import Data.List (isInfixOf, isPrefixOf, nub, sort, sortOn)

import qualified Obstruction as OB
import qualified Pramana as PR
import qualified Hetvabhasa_TheRefusalNamesItsDefectOrItIsNotARefusal as HB
import qualified Abhava_TheAbsenceCarriesItsPratiyoginAndItsSearchedDomain as AB
import qualified Pancavayava_TheInferenceCarriesItsWitnessedExampleOrItIsNotOne as PV
-- Added 2026-08-20.  `Yogyanupalabdhi` was landed with a runner of its own
-- and was still absent from THE suite, which is the state its own header
-- names as fatal: a self-test nothing calls reports the same as a module
-- that does not exist.  Its subject -- the fitness of a looking that
-- produces a negative verdict -- is the pramana layer's own, so it belongs
-- beside Abhava rather than beside its runner.
import qualified Yogyanupalabdhi_TheKernelAcceptanceCarriesTheWatchThatEarnedIt as YG
-- ~~Added 2026-08-23: `Pratikara`, a typed kernel-defect → repair table.~~
-- STRUCK the same day by its own author.  It was a lookup table — the
-- frequency-miner `bestOf` durnaya ANEKANTA §3 rejects, recombining the
-- already-common instead of "keep the remainder, recurse on the remainder".
-- The native form already exists on the Yantra wire and was demonstrated by
-- fable-krama the same session: sadhana → dosa.lekha (śeṣa = womb) →
-- garbha.dhara (birth the next naya from the residue, TS 5.31) → sadhana.
-- See machine/Pratikara_...hs.STRUCK.doṣa.  No suite entry: a struck organ
-- runs in no suite.

main :: IO ()
main = do
  setLocaleEncoding utf8
  setFileSystemEncoding utf8
  hSetEncoding stdout utf8
  args <- getArgs
  let logPath = case args of { (p:_) -> p ; [] -> "machine/machine.log" }

  obOk <- OB.selfTest
  let suites =
        [ ("Obstruction", if obOk then [] else ["Obstruction.selfTest reported failure"])
        , ("Pramana",       PR.selfTest)
        , ("Hetvabhasa",    HB.selfTest)
        , ("Abhava",        AB.selfTest)
        , ("Pancavayava",   PV.selfTest)
        , ("Yogyanupalabdhi", YG.selfTest)
        ]
  putStrLn "== SELF-TESTS ========================================================="
  mapM_ report suites
  let failures = concatMap snd suites

  putStrLn ""
  census logPath

  putStrLn ""
  putStrLn "== THE ENCOUNTER ======================================================"
  mapM_ (putStrLn . ("  " ++) . HB.kathaName) [HB.Vada, HB.Jalpa, HB.Vitanda]
  putStrLn "  This engine's loop has been in jalpa: the score is accepted-theorem"
  putStrLn "  count, and a jalpa cannot learn from its own refusals.  Naming the"
  putStrLn "  mode is what makes `keep the remainder` a change of mode rather"
  putStrLn "  than a feature."

  putStrLn ""
  putStrLn "== THE TWO SCHOOLS, ON THE ABSENCE CONSTRUCTION ======================="
  mapM_ (putStrLn . ("  " ++)) AB.disputeAsBothSchoolsWouldPutIt

  putStrLn ""
  if null failures
    then putStrLn "PRAMANA LAYER CHECKED" >> exitSuccess
    else do
      putStrLn ("PRAMANA LAYER FAILED: " ++ show (length failures) ++ " check(s)")
      exitFailure
  where
    report (name, fs) = do
      putStrLn ("  " ++ pad name ++ (if null fs then "ok" else show (length fs) ++ " FAILED"))
      mapM_ (putStrLn . ("      " ++)) fs
    pad s = s ++ replicate (max 1 (16 - length s)) ' '

-- ===================================================================
-- THE CENSUS.  Every refusal in the log, sorted by the KIND of defect it is,
-- which is the thing no type in this engine could say before today.
census :: FilePath -> IO ()
census logPath = do
  ok <- doesFileExist logPath
  putStrLn "== HETVABHASA CENSUS =================================================="
  if not ok
    then do
      putStrLn ("  log not present: " ++ logPath)
      putStrLn "  NO FIGURES ARE PRINTED.  An absence of a log is not a census of"
      putStrLn "  zero, and this is the whole content of the abhava gate: the"
      putStrLn "  pratiyogin here is `a KERNEL-REJECT line`, the anuyogin is the"
      putStrLn "  path above, and the extent is empty, so nothing was not-found."
    else do
      h <- openFile logPath ReadMode
      hSetEncoding h utf8
      src <- hGetContents h
      let ls = lines src
      length ls `seq` return ()
      let rejects  = [ l | l <- ls, "KERNEL-REJECT" `isInfixOf` l ]
          accepts  = [ l | l <- ls, "KERNEL-ACCEPT" `isInfixOf` l ]
          accepted = OB.acceptedClaims ls
          -- the LINE NUMBER of the first ACCEPT of each claim, so a
          -- satpratipaksa carries two real loci rather than (0,0).  A witness
          -- that is a placeholder is `Khandita at []` again (ANEKANTA.md 19),
          -- and this census will not print one.
          acceptAt = [ (OB.claimOfAcceptLine l, i)
                     | (i, l) <- zip [1 :: Int ..] ls
                     , "KERNEL-ACCEPT" `isInfixOf` l ]
          rows     = [ classify accepted acceptAt i l
                     | (i, l) <- zip [1 :: Int ..] ls
                     , "KERNEL-REJECT" `isInfixOf` l ]
      putStrLn ("  log             " ++ logPath)
      putStrLn ("  lines           " ++ show (length ls))
      putStrLn ("  KERNEL-REJECT   " ++ show (length rejects))
      putStrLn ("  KERNEL-ACCEPT   " ++ show (length accepts))
      putStrLn ""
      putStrLn "  by kind of defect:"
      mapM_ (putStrLn . ("    " ++)) (tally (map fst rows))
      putStrLn ""
      putStrLn "  WHAT THIS CENSUS CANNOT SEE, said here rather than in a footnote:"
      putStrLn "  `not classified` is not a fifth kind of defect.  It is this"
      putStrLn "  classifier's own blind spot -- `Obstruction.residualOf` was"
      putStrLn "  written against a log format that printed the Agda residual, and"
      putStrLn "  these lines print `Checking Candidate (...)` instead, so there is"
      putStrLn "  no term to judge and no verdict to classify.  The pratiyogin of"
      putStrLn "  that absence is a parsable residual and the anuyogin is this log."
      putStrLn ""
      putStrLn "  one witness per kind, so no row is a bare count:"
      mapM_ (putStrLn . ("    " ++)) (witnesses rows)
      putStrLn ""
      -- punarukta: repetition, the nigrahasthāna the engine has been committing
      let distinctAccepted = length accepted
          punar = HB.Punarukta (length accepts) distinctAccepted
      putStrLn ("  " ++ HB.nigrahasthanaName punar)
      mapM_ (putStrLn . ("    " ++)) (HB.nigrahasthanaEvidence punar)

-- The classification of one rejection line.  Order matters and is argued:
--
--   satpratipakṣa FIRST.  If the same claim is accepted somewhere in this log,
--   then whatever else is wrong with the refusal, an equal reason stands
--   against it — and `Obstruction.evSakshin` carries the affirming line itself
--   rather than a Bool, so the witness is available.  Filing such a line under
--   its rewriter verdict instead would report a defect of the CLAIM where the
--   situation is a defect of the REASON, which is the durnaya §1 is about.
--
--   then the rewriter's verdict, through `hetvabhasaOfVerdict`.
--
--   `Aviruddha` and "no term to judge" are NOT defects and are not filed as
--   any hetvābhāsa.  They are counted under their own names, because a
--   taxonomy that has a bin for everything has a bin that means nothing.
classify :: [String] -> [(String, Int)] -> Int -> String -> (String, [String])
classify accepted acceptAt lineNo line =
  let ev    = OB.evidenceOfReject accepted line
      claim = OB.goalOfRejectLine line
  in case OB.evSakshin ev of
    Just aff ->
      ( HB.hetvabhasaName HB.KSatpratipaksa
      , HB.hetvabhasaWitness (HB.Satpratipaksa (HB.Counterbalance claim
          (tacticOr line) (tacticOr aff)
          (lineNo, maybe 0 id (lookup claim acceptAt)))) )
    Nothing -> case OB.evRewriter ev of
      Nothing ->
        ( "not classified -- no residual term to judge"
        , ["the reject line carries no parsable residual: " ++ take 60 claim] )
      Just v -> case HB.hetvabhasaOfVerdict claim v of
        Right hb -> (HB.hetvabhasaName (HB.hetvabhasaKind hb), HB.hetvabhasaWitness hb)
        Left dom ->
          ( "NOT a hetvabhasa -- clean over the stated extent"
          , ["unrefuted over " ++ show (length dom) ++ " assignments; offering "
             ++ "this as a proof would be vyapyatva-asiddha, and the offer is "
             ++ "a separate act"] )

-- The naya a line was submitted under, when the log records one.  THIS LOG
-- FORMAT MOSTLY DOES NOT: the 2026-08-20 lines print
-- `Checking Candidate (...)` where the format quoted in ANEKANTA.md §1 printed
-- the tactic, and `Obstruction.tacticOfAcceptLine` was written against the
-- older shape, so running it here returns the surrounding prose.  Rather than
-- print that as a naya — a witness field filled with whatever was nearby is
-- the `Khandita at []` defect wearing more text — this reads only the
-- `[naya=...]` marker the newer lines do carry, and says the field is
-- unrecorded when there is none.
tacticOr :: String -> String
tacticOr l = case marker l of
  Just t  -> t
  Nothing -> "unrecorded in this log format"
  where
    marker s = case dropTo "[naya=" s of
      Nothing -> Nothing
      Just t  -> Just (takeWhile (/= ']') t)
    dropTo sep s
      | sep `isPrefixOf` s = Just (drop (length sep) s)
      | null s             = Nothing
      | otherwise          = case s of { [] -> Nothing ; (_:t) -> dropTo sep t }

tally :: [String] -> [String]
tally ks =
  [ pad (show n) ++ "  " ++ k
  | (k, n) <- sortOn (negate . snd) [ (k, length [ () | y <- ks, y == k ]) | k <- nub (sort ks) ] ]
  where pad s = replicate (max 0 (6 - length s)) ' ' ++ s

witnesses :: [(String, [String])] -> [String]
witnesses rows =
  [ k ++ ":" ++ concatMap ("\n      " ++) w
  | k <- nub (sort (map fst rows))
  , (w:_) <- [[ ws | (k', ws) <- rows, k' == k ]] ]
