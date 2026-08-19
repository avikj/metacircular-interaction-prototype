-- Run the fitness survey over this repository.
--
--   ./yogyata              survey machine/ and formal/cubical/
--   ./yogyata <dir> ...    survey the given directories
--
-- Exit code is 0 always.  This is advisory by construction, in line with
-- .claude/hooks/source-coverage.sh, whose own header records that a blocking
-- guard on a judgement call is an outage wearing enforcement's name.  Whether
-- a module SHOULD be reachable is a judgement; that it is not reachable is a
-- fact, and only the fact is reported.
import Yogyata
import System.Environment (getArgs)
import System.Directory (listDirectory, doesDirectoryExist)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, utf8)
import Data.List (isSuffixOf, sort)
import Control.Monad (filterM, forM)

-- The gates.  A gate is a module that is run or checked by something outside
-- this survey -- CI, a script, a person -- and therefore counts as a root
-- even though nothing in the corpus imports it.
--
-- formal/cubical: IndianLane and NaturalMachine are the aggregates
-- formal/cubical/check.sh actually typechecks; Everything is wider and is
-- checked too (BUILD.md records it as expected red under the pin, which is a
-- statement about its contents, not about whether it is a root).
gates :: [String]
gates = [ "IndianLane", "NaturalMachine", "Everything" ]

sourceIn :: FilePath -> IO [FilePath]
sourceIn d = do
  ok <- doesDirectoryExist d
  if not ok then return [] else do
    ns <- listDirectory d
    return (sort [ d ++ "/" ++ n | n <- ns
                 , ".hs" `isSuffixOf` n || ".agda" `isSuffixOf` n ])

main :: IO ()
main = do
  setLocaleEncoding utf8
  setFileSystemEncoding utf8
  hSetEncoding stdout utf8
  args <- getArgs
  let dirs = if null args then ["machine", "formal/cubical"] else args
  paths <- concat <$> mapM sourceIn dirs
  units <- forM paths $ \p -> do
    h <- openFile p ReadMode
    hSetEncoding h utf8
    src <- hGetContents h
    let u = parseUnit gates p src
    length (uName u) `seq` length (uImports u) `seq` uLines u `seq` return u
  mapM_ putStrLn (renderSurvey (survey dirs units))
