module Main (main) where

import Bend.UCM.Execution
import Core.Admission (CheckedSource (..), admitBook)
import Core.CLI (parseFile)
import Core.Type (Book (..))
import qualified Data.Map.Strict as Map
import Data.List (isInfixOf)
import System.Environment (getArgs)

main :: IO ()
main = do
  [sourcePath, hvmPath] <- getArgs
  source <- readFile sourcePath
  book <- parseFile sourcePath
  checked <- either (fail . const "Bend admission rejected fixture") pure (admitBook sourcePath source book)
  case compileCheckedBook (Book Map.empty Map.empty) of
    Left MissingMain -> pure ()
    _ -> fail "missing main was accepted"
  net <- either (fail . show) pure (compileCheckedBook (checkedBook checked))
  if all (`isInfixOf` net) ["FULL RUNTIME", "@main =", "@coe"]
    then pure ()
    else fail "full cubical runtime was absent from emitted net"
  result <- runCheckedBook hvmPath (checkedBook checked)
  case result of
    Right ExecutionResult {output = out}
      | "0 " `isInfixOf` out && "Itrs:" `isInfixOf` out -> putStrLn "checked Bend2 Book executed on full HVM4"
    _ -> fail (show result)
