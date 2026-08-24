-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Recite the corpus in every frame and print the syndromes.
--
--   runghc -imachine machine/GhanaPathaRun.hs
--   runghc -imachine machine/GhanaPathaRun.hs "deva + indra"
--
-- Nothing here is a stored answer.  Every line is a comparison between two
-- derivations computed in this run; where they agree, the frames that agreed
-- are named, and where they part, the position is printed with both
-- readings and no verdict.
import GhanaPatha_TheFramesDisagreeAndTheDisagreementIsThePosition
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, setForeignEncoding, utf8)

corpus :: [String]
corpus =
  [ "dadhi + indra"
  , "deva + indra"
  , "mahā + indra"
  , "su + ukta"
  , "deva + ṛṣi"
  , "mahā + ṛṣi"
  , "madhu + ari"
  , "deva + aiśvarya"
  , "te + api"
  , "ne - ana"
  , "rāmas"
  , "tat + ca"
  , "tat + jalam"
  , "vāc"
  -- three padas: the accretive frames only have something to say here
  , "deva + indra + iva"
  , "tat + ca + indra"
  , "madhu + ari + iva"
  ]

bar :: String -> IO ()
bar t = do
  putStrLn ""
  putStrLn ("== " ++ t ++ " " ++ replicate (max 0 (66 - length t)) '=')

main :: IO ()
main = do
  setLocaleEncoding utf8
  setFileSystemEncoding utf8
  setForeignEncoding utf8
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  args <- getArgs
  case args of
    (w : ws) -> mapM_ putStrLn (showPatha (patha (unwords (w : ws))))
    [] -> do
      bar "self-test of the frame machinery"
      case selfTestGhana of
        [] -> putStrLn "  all checks pass"
        fs -> mapM_ (putStrLn . ("  FAIL  " ++)) fs
      bar "the frames"
      mapM_ (\f -> putStrLn ("  " ++ pad 12 (frName f) ++ frGloss f)) frames
      bar "the recitation"
      mapM_ (mapM_ putStrLn . showPatha . patha) corpus
      bar "syndromes, gathered"
      let all_ = [ (i, s) | i <- corpus, s <- syndromes i ]
      if null all_
        then putStrLn "  no frame disagreed on this corpus"
        else mapM_ (\(i, s) -> do putStrLn ("  " ++ i)
                                  mapM_ putStrLn (showSyndrome s)) all_
      putStrLn ""
      putStrLn ("  " ++ show (length all_) ++ " syndrome(s) over "
                ++ show (length corpus) ++ " inputs and "
                ++ show (length frames) ++ " frames")
      case selfTestGhana of
        [] -> return ()
        _  -> exitFailure
  where
    pad n s = s ++ replicate (max 0 (n - length s)) ' '
