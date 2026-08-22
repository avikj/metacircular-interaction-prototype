-- Run the sevenfold verdict on real kernel decisions.
--
--     runghc -imachine machine/SaptabhangiRun.hs [logfile]
--
-- Default input is machine/machine.log.  Real runs, not invented lines; the
-- classifier is `Saptabhangi_TheSevenfoldVerdict.vacanaOfRejection`, which is
-- the SAME function `MathMachine.kernelAcceptSearch` calls at the moment it
-- decides -- this program differs only in reading the refusal off a log line
-- instead of off agda's stderr.
--
-- What it prints:
--
--   1. the laws, exhaustively verified over the seven positions.  Each is
--      also a checked term in
--      formal/cubical/SaptabhangiSamyoga_TheCompositionOfVerdicts.agda
--      (--cubical --safe, no postulates, no holes).
--   2. the two compositions, computed, including the counterexample that
--      shows `saha` does not associate.
--   3. the log's refusals, censused by position, with one worked instance of
--      each position and the evidence that put it there.
--   4. the claims the log both REFUSES and ACCEPTS -- the case that has no
--      Boolean answer at all.

import qualified Obstruction as OB
import qualified Saptabhangi_TheSevenfoldVerdict as SB

import Data.List (isInfixOf, nub)
import System.Environment (getArgs)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, utf8)

-- One refusal line, read as evidence.  `OB.residualOf` scans for agda's
-- `A != B of type T`, so handing it the whole line is the same call the
-- engine makes on agda's message.
vacanaOfLine :: [String] -> String -> SB.Vacana
vacanaOfLine accepted line =
  SB.sakshin accepted (OB.goalOfRejectLine line)
    (SB.vacanaOfRejection (nayaOf line) line)
  where
    nayaOf l = case break (== '=') (afterBracket '[' l) of
      (_, '=':r) -> takeWhile (/= ']') r
      _          -> "kernel-refl"
    afterBracket c s = drop 1 (dropWhile (/= c) s)

trim :: String -> String
trim = unwords . words

main :: IO ()
main = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8; hSetEncoding stdout utf8
  args <- getArgs
  let path = case args of { (p:_) -> p ; [] -> "machine/machine.log" }
  putStrLn "=== SAPTABHANGI: the verdict that used to be a Bool ==========="
  putStrLn ""
  putStrLn "-- 1. the laws, exhaustive over the seven positions -----------"
  mapM_ (\(nm, ok) -> putStrLn ((if ok then "  ok    " else "  FAIL  ") ++ nm))
        SB.selfTest
  let bad = length [ () | (_, ok) <- SB.selfTest, not ok ]
  putStrLn ("  " ++ show (length SB.selfTest - bad) ++ "/"
            ++ show (length SB.selfTest) ++ " hold, " ++ show bad ++ " failed")
  putStrLn ""
  putStrLn "-- 2. composition, computed ----------------------------------"
  putStrLn ("  krama asti nasti      = " ++ show (SB.krama SB.SyadAsti SB.SyadNasti)
            ++ "   -- in succession, both are said")
  putStrLn ("  saha  asti nasti      = " ++ show (SB.saha SB.SyadAsti SB.SyadNasti)
            ++ "   -- at once, the tongue breaks")
  putStrLn ("  saha (saha B3 B1) B2  = "
            ++ show (SB.saha (SB.saha SB.SyadAstiNasti SB.SyadAsti) SB.SyadNasti))
  putStrLn ("  saha B3 (saha B1 B2)  = "
            ++ show (SB.saha SB.SyadAstiNasti (SB.saha SB.SyadAsti SB.SyadNasti))
            ++ "   -- grouping changes it: saha does not associate")
  putStrLn ""

  ls <- fmap lines (readFile path)
  let accepted = OB.acceptedClaims ls
      rejects  = [ l | l <- ls, "KERNEL-REJECT" `isInfixOf` l ]
      skips    = [ l | l <- ls, "KERNEL-SKIP"   `isInfixOf` l ]
      vs       = [ (l, vacanaOfLine accepted l) | l <- rejects ]
      -- a KERNEL-SKIP predicates nothing at all: the emitter never formed a
      -- module, so no naya spoke.  That is apratipatti, and it is NOT the
      -- fourth position -- avaktavya is a position, this is the absence of
      -- one.  Keeping them apart is the whole point of the eighth profile
      -- not being an eighth bhanga.
      skipVs   = [ (l, SB.noVacana) | l <- skips ]
      sths     = [ SB.sthana v | (_, v) <- vs ++ skipVs ]
  putStrLn ("-- 3. " ++ path ++ ": " ++ show (length rejects)
            ++ " refusals + " ++ show (length skips)
            ++ " skips, each of which was a `False` ---")
  putStrLn ""
  mapM_ (\(k, n) -> putStrLn ("  " ++ pad 32 k ++ show n)) (SB.tallySthana sths)
  putStrLn ("  " ++ pad 32 "(distinct accepted claims)" ++ show (length accepted))
  putStrLn ""
  putStrLn "-- 4. one worked instance of each position, with its evidence -"
  mapM_ (report . snd) (firstOfEach (vs ++ skipVs))
  putStrLn ""
  putStrLn "-- 5. claims this log both REFUSES and ACCEPTS ---------------"
  let both = nub [ OB.goalOfRejectLine l | l <- rejects
                 , OB.goalOfRejectLine l `elem` accepted ]
  if null both
    then putStrLn "  none in this log."
    else do
      putStrLn ("  " ++ show (length both) ++ " claim(s).  Under a Bool each was")
      putStrLn "  False on one line and True on another, in the same process."
      putStrLn "  They are not in contradiction: two nayas spoke, in succession."
      mapM_ (\c -> putStrLn ("    " ++ trim c)) (take 6 both)
      case [ v | (l, v) <- vs, OB.goalOfRejectLine l `elem` both ] of
        (v:_) -> do putStrLn ""; mapM_ putStrLn (SB.renderSthana v)
        []    -> pure ()

pad :: Int -> String -> String
pad n s = s ++ replicate (max 1 (n - length s)) ' '

firstOfEach :: [(String, SB.Vacana)] -> [(String, SB.Vacana)]
firstOfEach = go []
  where
    go _ [] = []
    go seen ((l,v):rest)
      | k `elem` seen = go seen rest
      | otherwise     = (l,v) : go (k:seen) rest
      where k = SB.sanskritOf (SB.sthana v)

report :: SB.Vacana -> IO ()
report v = do
  putStrLn ""
  mapM_ putStrLn (SB.renderSthana v)
