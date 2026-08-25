-- Run the door.  Every line printed here is computed; nothing is stored.
--
--   runghc -imachine machine/DvaraVadaRun.hs
--   runghc -imachine machine/DvaraVadaRun.hs "dadhi + indra" dadhyindra
--   runghc -imachine machine/DvaraVadaRun.hs "dadhi + indra" dadhīndra 6.1.101
--
-- With no arguments it runs both self-tests -- Astadhyayi's and the door's --
-- and then walks the admission corpus: what passes, and what is refused and
-- with what residual.  It exits non-zero if any check fails, so a green here
-- is a green for a party that did not produce it.

import qualified Astadhyayi as A
import Astadhyayi (Vacya(..), Karaka(..), Vibhakti(..))
import DvaraVada_TheDoorAdmitsTheDerivationNotTheForm

import System.Environment (getArgs)
import System.Exit (exitFailure)
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, setForeignEncoding, utf8)

bar :: String -> IO ()
bar t = do
  putStrLn ""
  putStrLn ("== " ++ t ++ " " ++ replicate (max 0 (68 - length t)) '=')

parseRef :: String -> A.Ref
parseRef s = case wordsBy '.' s of
               [a, b, c] -> (read a, read b, read c)
               _         -> (0, 0, 0)
  where
    wordsBy ch str = case break (== ch) str of
                       (w, [])       -> [w]
                       (w, _ : rest) -> w : wordsBy ch rest

put :: Query -> IO ()
put q = do
  putStrLn ""
  putStrLn ("  ?  " ++ describe q)
  mapM_ (putStrLn . ("  " ++)) (renderResponse (dvara q))
  where
    describe (AskSandhi j f cs) =
      j ++ "  ⇒  " ++ f
      ++ (if null cs then "   (no citation offered)"
                     else "   cited: " ++ unwords (map showRef cs))
    describe (AskVarga a m ms) = "pratyāhāra " ++ a ++ m ++ " = " ++ unwords ms
    describe (AskKaraka v k vb) = show v ++ " " ++ show k ++ " ⇒ " ++ show vb

admitted, refused :: [Query]
admitted =
  [ AskSandhi "deva + indra"  "devendra"  []
  , AskSandhi "deva + indra"  "devendra"  [(6,1,87)]
  , AskSandhi "dadhi + indra" "dadhīndra" [(6,1,101)]
  , AskSandhi "te + api"      "te'pi"     []
  , AskSandhi "ne - ana"      "nayana"    []
  , AskSandhi "tat + jalam"   "tajjalam"  [(8,2,39),(8,4,40)]
  , AskSandhi "vāc"           "vāk"       []
  , AskSandhi "vāc"           "vāg"       []
  , AskVarga  "i" "k" ["i","u","ṛ","ḷ"]
  , AskKaraka Karmani Kartr Trtiya
  ]
refused =
  [ AskSandhi "dadhi + indra" "dadhyindra" []
  , AskSandhi "te + api"      "tayapi"     []
  , AskSandhi "tat + jalam"   "tadjalam"   []
  , AskSandhi "deva + indra"  "devendra"   [(6,1,101)]
  , AskSandhi "tat + jalam"   "tajjalam"   [(8,4,40)]
  , AskSandhi "vāc"           "vāc"        []
  , AskSandhi "deva + zeus"   "devazeus"   []
  , AskVarga  "i" "k" ["i","u","ṛ","ḷ","e"]
  , AskKaraka Kartari Kartr Trtiya
  ]

main :: IO ()
main = do
  mapM_ (\f -> f utf8) [setLocaleEncoding, setFileSystemEncoding, setForeignEncoding]
  args <- getArgs
  case args of
    (j : f : cs) -> put (AskSandhi j f (map parseRef cs))
    _ -> do
      bar "Aṣṭādhyāyī selfTest (the rules the door adjudicates on)"
      case A.selfTest of
        [] -> putStrLn "  [] -- every check passes"
        es -> mapM_ (putStrLn . ("  FAIL " ++)) es
      bar "door selfTest (half of it is cases that must fail)"
      case selfTest of
        [] -> putStrLn "  [] -- every check passes, including every must-fail"
        es -> mapM_ (putStrLn . ("  FAIL " ++)) es
      bar "WHAT THE DOOR ADMITS"
      mapM_ put admitted
      bar "WHAT THE DOOR REFUSES, AND WITH WHAT RESIDUAL"
      mapM_ put refused
      bar "coverage, not rounded up"
      mapM_ (putStrLn . ("  " ++)) A.coverage
      putStrLn ""
      if null A.selfTest && null selfTest then return () else exitFailure
