-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Run the ākāṅkṣā audit against the vocabularies that can be imported.
--
--     runghc -imachine machine/AkanksaRun.hs
--
-- It prints one Uttara per question and NO TOTAL.  Summing saṃkramaṇas
-- against doṣas would be the act under audit: seven distinguishable
-- situations flattened into one scalar no caller can un-flatten
-- (machine/Nasti_TruncationCensus.hs makes the same refusal, for the same
-- reason).  Exit is 0 in every case; a doṣa here is a finding to read, not
-- an outage.
module Main (main) where

import GHC.IO.Encoding (setFileSystemEncoding, setLocaleEncoding, utf8)
import System.IO (hSetEncoding, stdout)

import qualified ArithVocab as AV
import qualified PairVocab as PV
import Akanksa_TheDeclaredExpectancyAndTheEvaluatorAreIdentifiedByNothing
import Uttara_SamkramanaOrDosalekhaNeverABareBoolean (Uttara, uttaraKind, uttaraLines)

say :: Uttara -> IO ()
say = mapM_ putStrLn . uttaraLines

main :: IO ()
main = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8; hSetEncoding stdout utf8

  putStrLn "=== ĀKĀṄKṢĀ · does the evaluator hold the expectancy the symbol declared? ==="
  putStrLn "    machine/Akanksa_TheDeclaredExpectancyAndTheEvaluatorAreIdentifiedByNothing.hs"
  putStrLn ""

  section "§1  PairVocab.natVocabulary"
  us1 <- mapM (\s -> do ps <- akanksaOf (PV.symSem s)
                        return (akanksaUttara "PairVocab" (PV.symName s) (PV.symArity s) ps))
              PV.natVocabulary
  mapM_ (\u -> say u >> putStrLn "") us1

  section "§2  ArithVocab.vocabulary"
  us2 <- mapM (\s -> do ps <- akanksaOf (AV.symSem s)
                        return (akanksaUttara "ArithVocab" (AV.symName s) (AV.symArity s) ps))
              AV.vocabulary
  mapM_ (\u -> say u >> putStrLn "") us2

  section "§3  नाम-अभेदः · is a name still one symbol?"
  say (namaAbheda "PairVocab.natVocabulary"
         [ (PV.symName s, PV.symArity s) | s <- PV.natVocabulary ])
  putStrLn ""
  say (namaAbheda "ArithVocab.vocabulary"
         [ (AV.symName s, AV.symArity s) | s <- AV.vocabulary ])
  putStrLn ""
  -- The composition MathMachine actually forms: pairVocabulary ++
  -- arithVocabulary.  Its base half is `module Main` and unreachable, so
  -- this is the reachable half and it is labelled as such.
  say (namaAbheda "MathMachine.pairVocabulary ++ arithVocabulary (base half unreachable)"
         ([ (PV.symName s, PV.symArity s) | s <- PV.natPairSymbols ]
          ++ [ (AV.symName s, AV.symArity s) | s <- [AV.modSym, AV.lcmSym, AV.vpSym] ]))
  putStrLn ""

  section "§4  पद-संक्रमणम् · the two Term types, identified as data"
  say (padaSamkramana 3)
  putStrLn ""

  section "§5  भाषा-अभेदः · are the two base vocabularies the same vocabulary?"
  mapM_ (\n -> say (bhasaAbheda n) >> putStrLn "") ["0", "s", "+", "*", "-"]

  section "the vector.  Not summed; see this file's header."
  putStrLn "  ākāṅkṣā, PairVocab.natVocabulary:"
  mapM_ putStrLn (tally [ PV.symName s | s <- PV.natVocabulary ] us1)
  putStrLn "  ākāṅkṣā, ArithVocab.vocabulary:"
  mapM_ putStrLn (tally [ AV.symName s | s <- AV.vocabulary ] us2)
  putStrLn ""
  putStrLn "  Each line above is a list of kinds in vocabulary order, not a score."
  putStrLn "  The names are in the Uttara records; go and read them."

section :: String -> IO ()
section t = do
  putStrLn (replicate 70 '-')
  putStrLn t
  putStrLn (replicate 70 '-')

tally :: [String] -> [Uttara] -> [String]
tally ns us = [ "    " ++ pad n ++ uttaraKind u | (n, u) <- zip ns us ]
  where pad s = s ++ replicate (max 1 (12 - length s)) ' '
