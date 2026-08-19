-- Run the Astadhyayi.  Every line printed here is computed by the sutras in
-- `Astadhyayi.hs`; nothing is a stored answer.
--
--   ./astadhyayi            self-test, coverage, and the derivation traces
--   ./astadhyayi <words>    derive one form, e.g.  ./astadhyayi "deva + indra"
import Astadhyayi
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, setForeignEncoding, utf8)

bar :: String -> IO ()
bar t = do
  putStrLn ""
  putStrLn ("== " ++ t ++ " " ++ replicate (max 0 (66 - length t)) '=')

trace1 :: String -> IO ()
trace1 input = do
  let xs = parseInput input
      (steps, final) = deriveTrace xs
  putStrLn ""
  putStrLn ("  " ++ input ++ "   ->   " ++ render final)
  mapM_ step steps
  let aud = asiddhaAudit xs
  mapM_ (\(r, why) ->
          putStrLn ("      8.2.1 pūrvatrāsiddham: " ++ show r
                    ++ " would fire on the tripādī's output and is refused ("
                    ++ why ++ ")")) aud
  where
    step st = do
      putStrLn ("      " ++ showRef (stSutra st) ++ "  " ++ stText st)
      putStrLn ("              " ++ stNote st)
      putStrLn ("              " ++ stBefore st ++ "  ⇒  " ++ stAfter st)
      case stBeaten st of
        [] -> return ()
        ls -> putStrLn ("              beat " ++ unwords (map showRef ls)
                        ++ " -- " ++ stReason st)
    showRef (a,b,c) = show a ++ "." ++ show b ++ "." ++ show c

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
  ]

main :: IO ()
main = do
  -- the arguments are Sanskrit; the container's locale is not
  setLocaleEncoding utf8
  setFileSystemEncoding utf8
  setForeignEncoding utf8
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  args <- getArgs
  case args of
    (w : ws) -> trace1 (unwords (w : ws))
    [] -> do
      bar "self-test"
      case selfTest of
        [] -> putStrLn "  all checks pass"
        fs -> do mapM_ (putStrLn . ("  FAIL  " ++)) fs
                 putStrLn ("  " ++ show (length fs) ++ " failures")
      bar "the fourteen śivasūtras, as one line"
      putStrLn ("  " ++ unwords [ slotShow s | s <- varnasamamnaya ])
      putStrLn ""
      putStrLn "  the pratyāhāras this grammar uses, each computed as an interval:"
      mapM_ (\(nm, s, m) ->
               putStrLn ("    " ++ pad 6 nm ++ " = "
                         ++ unwords (pratyaharaSet s m)))
        [ ("aṆ","a","ṇ"), ("aK","a","k"), ("iK","i","k"), ("eṄ","e","ṅ")
        , ("aC","a","c"), ("eC","e","c"), ("aṬ","a","ṭ"), ("yaṆ","y","ṇ")
        , ("ñaM","ñ","m"), ("jhaṢ","jh","ṣ"), ("jhaŚ","jh","ś"), ("jaŚ","j","ś")
        , ("khaY","kh","y"), ("jhaY","jh","y"), ("śaR","ś","r"), ("caR","c","r")
        , ("śaL","ś","l"), ("jhaL","jh","l"), ("haL","h","l"), ("aL","a","l") ]
      bar "derivations"
      mapM_ trace1 corpus
      bar "how much of Pāṇini is here"
      mapM_ (putStrLn . ("  " ++)) coverage
      case selfTest of
        [] -> return ()
        _  -> exitFailure
  where
    slotShow (Snd s) = s
    slotShow (It m)  = "|" ++ m
    pad n s = s ++ replicate (max 0 (n - length s)) ' '
