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

-- Run the falsifier.  Nothing here is a stored answer; every line is
-- computed against `Astadhyayi`.
--
--   runghc -imachine machine/NigrahasthanaRun.hs
--
-- Exit is non-zero if any check fails, so a green here is a green for a
-- party that did not produce it.  The defect record prints whether or not
-- the checks pass: a suite that reports only its passes is the thing this
-- file exists to correct.
--
-- The mutation report is a separate program because it rebuilds the
-- grammar twenty times:  sh machine/nigrahasthana-mutants.sh

import qualified Astadhyayi as A
import Nigrahasthana_TheMachineIsJudgedByWhatItRefuses

import System.Exit (exitFailure)
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, setForeignEncoding, utf8)

bar :: String -> IO ()
bar t = do
  putStrLn ""
  putStrLn ("== " ++ t ++ " " ++ replicate (max 0 (66 - length t)) '=')

main :: IO ()
main = do
  mapM_ (\f -> f utf8) [setLocaleEncoding, setFileSystemEncoding, setForeignEncoding]

  bar "the machine's own self-test (all success cases)"
  case A.selfTest of
    [] -> putStrLn "  [] -- every success case passes"
    fs -> mapM_ (putStrLn . ("  FAIL  " ++)) fs

  bar "what must not derive"
  mapM_ one pratisiddha

  bar "where the derivation must stall"
  mapM_ (\(i, n, k) ->
           putStrLn ("  " ++ pad 24 (show i) ++ "-> " ++ pad 22 (show (A.derive i))
                     ++ show n ++ " steps, first sound outside the varṇasamāmnāya at "
                     ++ show k)) junk

  bar "the rule that must not fire, and the same rule alive elsewhere"
  mapM_ (\(i, r, why) ->
           putStrLn ("  " ++ pad 18 i ++ "  " ++ showRef r ++ " must NOT fire: " ++ why))
        mustNotFire
  mapM_ (\(i, r) ->
           putStrLn ("  " ++ pad 18 i ++ "  " ++ showRef r ++ " DOES fire here"))
        mustFire

  bar "1.4.2 vipratiṣedhe paraṃ kāryam: who lost, and what they wanted"
  mapM_ (\w ->
           putStrLn ("  " ++ pad 18 (vInput w) ++ "  " ++ showRef (vWinner w)
                     ++ " beat " ++ showRef (vLoser w) ++ ", which would have given "
                     ++ vLoserGot w)) paratvaWitnesses

  bar "8.2.1 pūrvatrāsiddham: the rule whose condition is met and is refused"
  mapM_ (\w ->
           putStrLn ("  " ++ pad 18 (aInput w) ++ "  refused "
                     ++ unwords (map showRef (aRefused w))
                     ++ "; it would have given " ++ aWouldBe w)) asiddhaWitnesses

  bar "the defect record -- properties that ought to hold and do not"
  mapM_ (\(name, want, got) -> do
           putStrLn ""
           putStrLn ("  " ++ name)
           putStrLn ("      ought:  " ++ want)
           putStrLn ("      is:     " ++ got)) dosha

  bar "verdict"
  mapM_ (putStrLn . ("  " ++)) report
  case nigraha of
    [] -> putStrLn "\n  nigraha: [] -- every refusal holds"
    fs -> do
      putStrLn ""
      mapM_ (putStrLn . ("  FAIL  " ++)) fs
      exitFailure
  case A.selfTest of
    [] -> return ()
    _  -> exitFailure
  where
    pad n s = s ++ replicate (max 0 (n - length s)) ' '
    showRef (a, b, c) = show a ++ "." ++ show b ++ "." ++ show c

    one p = do
      putStrLn ""
      putStrLn ("  " ++ pInput p ++ "   ⇒   " ++ pAttested p
                ++ "   (engine: " ++ A.derive (pInput p) ++ ")")
      mapM_ (\(bad, why) -> putStrLn ("      not  " ++ pad 16 bad ++ "  " ++ why))
            (pForbidden p)
