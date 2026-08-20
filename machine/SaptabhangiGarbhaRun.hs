-- SaptabhangiGarbhaRun -- the runtime returns the seven positions, with
-- their standpoints, on the machine's own two contradictory log lines.
--
--     sh machine/run-saptabhangi-garbha.sh
--     runghc -imachine machine/SaptabhangiGarbhaRun.hs
--
-- The two lines below are quoted verbatim from machine/machine.log at the
-- positions given.  That file is gitignored and append-only, so a LINE is
-- quotable and a COUNT is not (SaptabhangiNaya.agda's header records why).
-- Both were re-checked on 2026-08-18 and are exact.
module Main (main) where

import SaptabhangiGarbha_TheResidueIsTheSeed
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding)

rule :: String -> IO ()
rule t = putStrLn ("\n== " ++ t ++ " " ++ replicate (max 0 (64 - length t)) '=')

show' :: String -> Bhanga -> IO ()
show' lbl b = do
  putStrLn ("  " ++ lbl)
  mapM_ (putStrLn . ("  " ++)) (renderBhanga b)

main :: IO ()
main = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8; hSetEncoding stdout utf8
  putStrLn "=== SAPTABHANGI: what the machine returns instead of a Bool ==="
  putStrLn "spec: formal/cubical/NaturalMachine/SaptabhangiGarbha_ThePositions..."

  let accepting = Naya "induction on x, step = cong suc" []
        "machine.log:174  KERNEL-ACCEPT  round=0  x = (xmaxx)"
      refusing  = Naya "refl" []
        "machine.log:146  KERNEL-REJECT  round=0  x != max x x, of type N"
      asti  = SyadAsti accepting
      nasti = SyanNasti refusing

  rule "the two nayas, as the log has them"
  putStrLn ("  sadhaka: " ++ renderNaya accepting)
  putStrLn ("  badhaka: " ++ renderNaya refusing)
  putStrLn "  Same claim, same round, accepted and refused.  A Bool cannot"
  putStrLn "  say that.  Neither can a three-valued type with an `Unparsed`."

  rule "krama-arpana -- asserted in succession"
  show' "the THIRD position:" (krama asti nasti)

  rule "saha-arpana -- asserted at once, from one standpoint, in one utterance"
  show' "the FOURTH position:" (saha asti nasti)

  rule "the residue is the seed: three births from that one fourth position"
  case saha asti nasti of
    SyadAvaktavyam v -> mapM_ (uncurry showLevel) (zip [1 :: Int ..] (take 3 (garbhaDhara v)))
    other -> show' "unexpected:" other

  rule "laws (exhaustive finite verification; each proved in Agda)"
  mapM_ (\(nm, ok) -> putStrLn ("  " ++ (if ok then "OK  " else "FAIL") ++ "  " ++ nm))
        selfTest
  let bad = length [ () | (_, False) <- selfTest ]
  putStrLn ("\n  " ++ show (length selfTest - bad) ++ "/" ++ show (length selfTest)
            ++ " hold." ++ (if bad == 0 then "" else "  FAILURES ABOVE."))
  where
    showLevel k b = do
      putStrLn ("  --- level " ++ show k ++ " (Tattvarthasutra 5.31, arpita/anarpita)")
      mapM_ (putStrLn . ("  " ++)) (renderBhanga b)
