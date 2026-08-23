-- The process at the other end of the wire.  No network, no Python, no prose
-- on stdout except under `--transcript`.
--
--   runghc -imachine machine/PariksaRun.hs --selftest
--   runghc -imachine machine/PariksaRun.hs --emit 2000 > corpus.jsonl
--   runghc -imachine machine/PariksaRun.hs --transcript
--   runghc -imachine machine/PariksaRun.hs           -- JSON lines in, JSON lines out
--
-- With no flag it is the wire: one query per line on stdin, one record per
-- line on stdout, flushed per line so a training loop can drive it
-- interactively.  Unknown flags are not silently ignored.
module Main (main) where

import Pariksa_TheExaminationWireTheDerivationCorpusAndTheScoreThatPrefersRefusalToLuck
import qualified Astadhyayi as A

import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, setForeignEncoding, utf8)

main :: IO ()
main = do
  mapM_ (\f -> f utf8) [setLocaleEncoding, setFileSystemEncoding, setForeignEncoding]
  hSetBuffering stdout LineBuffering
  args <- getArgs
  case args of
    ["--selftest"] -> do
      let es = A.selfTest ++ selfTest
      mapM_ (hPutStrLn stderr . ("FAIL " ++)) es
      putStrLn (handle "{\"v\":1,\"op\":\"selftest\"}")
      if null es then return () else exitFailure
    ["--emit"]     -> mapM_ (putStrLn . tripleRecord) corpus
    ["--emit", n]  -> mapM_ (putStrLn . tripleRecord) (take (read n) corpus)
    ["--count"]    -> print (length corpus)
    ["--stats"]    -> putStrLn (handle "{\"v\":1,\"op\":\"stats\"}")
    ["--transcript"] -> mapM_ (\q -> putStrLn (handle q)) transcript
    []             -> interact (unlines . map handle . lines)
    _              -> do
      hPutStrLn stderr "usage: [--selftest|--emit [N]|--count|--transcript]"
      exitFailure

-- The worked transcript, so the commit message is reproducible by running
-- one command rather than by trusting a paste.
transcript :: [String]
transcript =
  [ "{\"v\":1,\"op\":\"adjudicate\",\"input\":\"deva + indra\"}"
  , "{\"v\":1,\"op\":\"adjudicate\",\"input\":\"dadhi + indra\"}"
  , "{\"v\":1,\"op\":\"adjudicate\",\"input\":\"vāc\"}"
  , "{\"v\":1,\"op\":\"adjudicate\",\"input\":\"deva + zeus\"}"
  , "{\"v\":1,\"op\":\"score\",\"input\":\"deva + indra\",\"claim\":\"pratijna\",\"form\":\"devendra\",\"derivation\":[\"6.1.87\"]}"
  , "{\"v\":1,\"op\":\"score\",\"input\":\"deva + indra\",\"claim\":\"pratijna\",\"form\":\"devendra\",\"derivation\":[\"6.1.101\"]}"
  , "{\"v\":1,\"op\":\"score\",\"input\":\"deva + indra\",\"claim\":\"virama\",\"form\":\"\",\"derivation\":[]}"
  , "{\"v\":1,\"op\":\"score\",\"input\":\"deva + indra\",\"claim\":\"pratijna\",\"form\":\"devaindra\",\"derivation\":[]}"
  , "{\"v\":1,\"op\":\"score\",\"input\":\"vāc\",\"claim\":\"pratijna\",\"form\":\"vāk\",\"derivation\":[]}"
  , "{\"v\":1,\"op\":\"score\",\"input\":\"vāc\",\"claim\":\"virama\",\"form\":\"\",\"derivation\":[]}"
  , "not json at all"
  ]
