-- Run both instantiations of the general derivational core.
--
--   runghc -imachine machine/PrakriyaRun.hs
--
-- Prints the residual first, because a factoring that reports no loss is a
-- factoring nobody checked, and the loss is the whole difference between this
-- and mining.
import Prakriya_TheGeneralDerivationCoreFactoredFromTheAstadhyayi (residual)
import qualified PrakriyaSamskrta_TheAstadhyayiRunByTheGeneralCore as S
import qualified EnglishPluralAllomorphy_TheSecondInstantiationOfTheCore as E
import System.Exit (exitFailure)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, setForeignEncoding, utf8)

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

  bar "what the abstraction LOSES relative to the Aṣṭādhyāyī"
  mapM_ (putStrLn . ("  " ++)) residual

  bar "instantiation 1 (primary): Pāṇini, Aṣṭādhyāyī, ~500 BCE"
  mapM_ (putStrLn . ("  " ++)) S.report
  putStrLn ""
  putStrLn "  cross-check against Astadhyayi.hs's own engine, form by form:"
  case S.agreement of
    [] -> putStrLn "    the two engines agree on every form in the corpus"
    ds -> mapM_ (putStrLn . ("    DISAGREE  " ++)) ds
  putStrLn ""
  case S.selfTest of
    [] -> putStrLn "  all checks pass"
    fs -> mapM_ (putStrLn . ("  FAIL  " ++)) fs

  bar "instantiation 2: English plural allomorphy (a toy, and it says so)"
  mapM_ (putStrLn . ("  " ++)) E.report
  putStrLn ""
  case E.selfTest of
    [] -> putStrLn "  all checks pass"
    fs -> mapM_ (putStrLn . ("  FAIL  " ++)) fs

  if null (S.selfTest ++ E.selfTest) then return () else exitFailure
