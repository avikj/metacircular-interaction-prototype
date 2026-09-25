module Main where

import Control.Monad (unless)
import qualified Data.Map as M
import System.Environment (getArgs)
import System.Exit (exitFailure)
import Core.CLI (processFile, processFileToJS, processFileToHVM, processFileToHVM4, processFileToHVM4Raw, processFileToHVM4Full, processFileInteract, processFileCheckNet, processFileTotal, listDependencies)

-- | Show usage information
showUsage :: IO ()
showUsage = do
  putStrLn "Usage: bend <file.bend> [options]"
  putStrLn ""
  putStrLn "Options:"
  putStrLn "  --to-javascript    Compile to JavaScript"
  putStrLn "  --to-hvm           Compile to HVM"
  putStrLn "  --to-hvm4          Compile to HVM4 surface"
  putStrLn "  --to-hvm4-raw      Compile to HVM4 surface without pre-normalisation"
  putStrLn "  --to-hvm4-full     Compile to HVM4 with the full cubical runtime (no erasure)"
  putStrLn "  --interact         Run as a machine that asks: stdin names maps, answers keep the heap"
  putStrLn "  --total            Check, then fail if any definition is [unchecked]"
  putStrLn "  --list-dependencies List all dependencies (recursive)"

-- | Main entry point
main :: IO ()
main = do
  args <- getArgs
  case args of
    [file, "--to-javascript"] | ".bend"    `isSuffixOf` file -> processFileToJS file
    [file, "--to-javascript"] | ".bend.py" `isSuffixOf` file -> processFileToJS file
    [file, "--to-hvm4-raw"] | ".bend" `isSuffixOf` file -> processFileToHVM4Raw file
    [file, "--to-hvm4-full"] | ".bend" `isSuffixOf` file -> processFileToHVM4Full file
    [file, "--interact"] | ".bend" `isSuffixOf` file -> processFileInteract file
    [file, "--check-net", checker] | ".bend" `isSuffixOf` file -> processFileCheckNet file checker
    [file, "--total"] | ".bend" `isSuffixOf` file -> processFileTotal file
    [file, "--to-hvm4"] | ".bend"    `isSuffixOf` file -> processFileToHVM4 file
    [file, "--to-hvm4"] | ".bend.py" `isSuffixOf` file -> processFileToHVM4 file
    [file, "--to-hvm"] | ".bend"    `isSuffixOf` file -> processFileToHVM file
    [file, "--to-hvm"] | ".bend.py" `isSuffixOf` file -> processFileToHVM file
    [file, "--list-dependencies"] | ".bend"    `isSuffixOf` file -> listDependencies file
    [file, "--list-dependencies"] | ".bend.py" `isSuffixOf` file -> listDependencies file
    [file] | ".bend"    `isSuffixOf` file -> processFile file
    [file] | ".bend.py" `isSuffixOf` file -> processFile file
    otherwise                             -> showUsage
  where isSuffixOf suffix str = reverse suffix == take (length suffix) (reverse str)
