-- Run the pratyāhāra decision procedure.  Nothing printed here is stored:
-- every name is decided against the varṇasamāmnāya, and the width is a
-- matching computed on the containment poset of the classes.
--
--   ./pratyahara                 the report and the self-test
--   ./pratyahara e o             decide one class from its members
--
-- The theorem the report is quoting is
-- formal/cubical/PratyaharaLaghava_TheMarkerCountIsForcedByTheAntichain.agda:
-- classes sharing one anubandha are a ⊆-chain, so an antichain forces that
-- many anubandhas, in any linear order whatever.
import Pratyahara_TheIntervalDecisionProcedure
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, setForeignEncoding, utf8)

main :: IO ()
main = do
  setLocaleEncoding utf8
  setFileSystemEncoding utf8
  setForeignEncoding utf8
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  args <- getArgs
  case args of
    [] -> do report
             case selfTest of
               [] -> return ()
               _  -> exitFailure
    ws -> case nameClass ws of
            Right (s, m) -> putStrLn (unwords ws ++ "  =  " ++ s ++ " .. " ++ m)
            Left err     -> do putStrLn (unwords ws ++ "  NOT NAMEABLE -- " ++ err)
                               exitFailure
