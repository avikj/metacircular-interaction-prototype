-- Run the fast engine, and check it against the one it is fast for.
--
--   runghc -imachine machine/LaghavaRun.hs           self-test + equivalence
--   ./laghava bench [n]                              timing, with conditions
--   ./laghava <words>                                derive one form
--
-- THE EQUIVALENCE IS THE POINT.  `Laghava_...` re-encodes the sutras of
-- `Astadhyayi.hs` against the CPU.  A re-encoding is a claim, and the
-- claim is checked here exhaustively rather than asserted: every ordered
-- pair of the 47 sounds of the varnasamamnaya, at a pada juncture and at
-- a morph juncture, plus a word corpus, plus every sound alone -- each
-- derived by BOTH engines and compared form for form.  Where they
-- disagree the reference is right.  Neither file holds the answer alone;
-- the disagreement is a syndrome (JALAM_ONE_BODY s.5).

import qualified Astadhyayi as A
import qualified Laghava_TheSameSutrasOnTheCarrierTheyActuallyRunOn as L

import Data.List (foldl')
import Data.Time.Clock
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, setForeignEncoding, utf8)

-- the corpus AstadhyayiRun.hs traces, so the timing is over the same forms
corpus14 :: [String]
corpus14 =
  [ "dadhi + indra", "deva + indra", "mahā + indra", "su + ukta"
  , "deva + ṛṣi", "mahā + ṛṣi", "madhu + ari", "deva + aiśvarya"
  , "te + api", "ne - ana", "rāmas", "tat + ca", "tat + jalam", "vāc" ]

sounds :: [String]
sounds = map L.phName [ 0 .. fromIntegral L.nPhones - 1 ]

prefixes, suffixes :: [String]
prefixes = [ "dadhi","deva","mahā","su","madhu","te","ne","rāmas","tat","vāc"
           , "go","nau","agni","pitṛ","tad","vāk","mahat","kim","śiv","viṣṇu" ]
suffixes = [ "indra","ari","ukta","ṛṣi","aiśvarya","api","ana","ca","jalam"
           , "īśa","ūrmi","eva","odana","ātman","hara","śiva","ṣaṣ","tu"
           , "dhana","nara","bhava" ]

equivCorpus :: [String]
equivCorpus =
  corpus14
  ++ [ p ++ " " ++ j ++ " " ++ q | p <- sounds, q <- sounds, j <- ["+","-"] ]
  ++ [ p ++ " " ++ j ++ " " ++ q | p <- prefixes, q <- suffixes, j <- ["+","-"] ]
  ++ sounds
  ++ prefixes ++ suffixes

disagreements :: [(String, String, String)]
disagreements =
  [ (s, a, l) | s <- equivCorpus, let a = A.derive s, let l = L.derive s, a /= l ]

sig :: String -> Int
sig = foldl' (\acc c -> acc * 31 + fromEnum c) 0

-- BEST OF k, and the reason is stated rather than assumed: this repository
-- runs several agents at once, so the mean of a wall-clock timing here is a
-- measurement of the other agents.  The minimum over k repetitions is the
-- run least contaminated by contention, and it is the only one of the k
-- that is a statement about the code.  The spread is printed too, because a
-- number without its conditions looks like knowledge.
timeIt :: String -> (Int -> Int -> Int) -> Int -> Int -> IO Double
timeIt nm f n k = do
  _ <- return $! f 0 1
  ts <- mapM (\rep -> once f rep n) [1 .. k]
  let best  = minimum (map fst ts)
      worst = maximum (map fst ts)
  putStrLn ("  " ++ pad 12 nm
            ++ "  " ++ pad 9 (show n) ++ " derivations, best of " ++ show k
            ++ ": " ++ show best ++ " s"
            ++ "   " ++ show (round (fromIntegral n / best) :: Int) ++ " /s"
            ++ "   " ++ show (best * 1e6 / fromIntegral n) ++ " us each"
            ++ "   [worst " ++ show worst ++ " s"
            ++ ", checksum " ++ show (snd (head ts)) ++ "]")
  return best
  where
    pad j x = x ++ replicate (max 0 (j - length x)) ' '
    once g rep m = do
      t0 <- getCurrentTime
      s  <- return $! g rep m
      t1 <- getCurrentTime
      return (realToFrac (diffUTCTime t1 t0) :: Double, s)


runRef, runFast :: Int -> Int -> Int
runRef  rep n = foldl' (\acc k -> acc + sig (A.derive (corpus14 !! (k `mod` 14)))) rep [0 .. n - 1]
runFast rep n = foldl' (\acc k -> acc + sig (L.derive (corpus14 !! (k `mod` 14)))) rep [0 .. n - 1]

main :: IO ()
main = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8; setForeignEncoding utf8
  hSetEncoding stdout utf8; hSetEncoding stderr utf8
  args <- getArgs
  case args of
    ("bench" : rest) -> do
      let n = case rest of (x : _) -> read x; _ -> 20000
      putStrLn "== timing, both engines, same forms, same process =============="
      dr <- timeIt "reference" runRef  n 5
      df <- timeIt "laghava"   runFast n 5
      putStrLn ("  ratio        " ++ show (dr / df) ++ "x")
    ("bench-only" : rest) -> do
      let n = case rest of (x : _) -> read x; _ -> 200000
      _ <- timeIt "laghava" runFast n 5
      return ()
    (w : ws) -> putStrLn (L.derive (unwords (w : ws)))
    [] -> do
      putStrLn "== laghava self-test ==========================================="
      case L.laghavaSelfTest of
        [] -> putStrLn "  all checks pass"
        fs -> mapM_ (putStrLn . ("  FAIL  " ++)) fs
      putStrLn "== reference self-test ========================================="
      case A.selfTest of
        [] -> putStrLn "  all checks pass"
        fs -> mapM_ (putStrLn . ("  FAIL  " ++)) fs
      putStrLn "== equivalence with the reference =============================="
      putStrLn ("  inputs compared: " ++ show (length equivCorpus))
      case disagreements of
        [] -> putStrLn "  every form identical"
        ds -> do
          mapM_ (\(s, a, l) -> putStrLn ("  DISAGREE  " ++ show s
                                         ++ "  reference " ++ show a
                                         ++ "  laghava " ++ show l))
                (take 40 ds)
          putStrLn ("  " ++ show (length ds) ++ " disagreements")
      if null L.laghavaSelfTest && null A.selfTest && null disagreements
        then return ()
        else exitFailure
