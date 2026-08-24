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

-- SesaRun -- print the शेष queue of machine/Astadhyayi.hs section 7b.
--
-- यो शेषं त्यजति तस्य यन्त्रं न चलति ।
--
-- The engine used to return a stalled derivation in exactly the shape it
-- returns a finished one.  This prints what it now says instead: where it
-- stalled, on what, at whose demand, and which single missing sūtra would
-- unblock the most derivations in the corpus.
--
--   runghc -imachine machine/SesaRun_WhatThePaniniEngineAsksFor.hs
module Main (main) where

import Astadhyayi

main :: IO ()
main = do
  putStrLn "== the queue ========================================================="
  mapM_ (putStrLn . ("  " ++)) (sesaLekha sesaKosha)

  putStrLn ""
  putStrLn "== one stall, whole ================================================="
  putStrLn "  tam + ca  ->  ORDINARY SANSKRIT, and this engine derives:"
  putStrLn ("    " ++ derive "tam + ca")
  putStrLn "  m is neither jhaL nor cU nor s nor sTu, so nothing in the table"
  putStrLn "  reaches for that juncture at any configuration of the run."
  putStrLn ""
  mapM_ report [ s | s <- sesah "tam + ca" ]

  putStrLn ""
  putStrLn "== and one that is refused entry ===================================="
  putStrLn ("  rāmas + ca  ->  " ++ derive "rāmas + ca")
  mapM_ report [ s | s <- sesah "rāmas + ca" ]
  where
    report s = mapM_ (putStrLn . ("  " ++))
      [ "śeṣa      " ++ sesaPrccha s
      , "  hetu    " ++ show (sHetu s)
      , "  sandhi  " ++ showSandhi (sSandhi s) ++ "   at index " ++ show (sSthana s)
      , "  rūpa    " ++ show (sRupa s)
      , "  spardhī " ++ show (sSpardhi s) ++ "   (who contended here)"
      , "  dṛṣṭa   " ++ show (sDrsta s) ++ "   (who ever reached for it)"
      , "  janaka  " ++ show (sJanaka s) ++ "   (what demanded it)"
      , "  nirṇaya " ++ show (nirnaya s)
      , "  praveśa " ++ show (pravesha (nirnaya s))
      , "" ]
