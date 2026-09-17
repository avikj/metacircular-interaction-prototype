module Main (main) where

import Bend.UCM.Execution (ExecutionResult (..), runCheckedBook, selectEntryAsMain)
import Core.Admission (admitBook)
import Core.CanonicalComponent (syntheticMemberName)
import Core.ComponentPlan (AddressedComponent (..), ComponentPlan (..), addressComponents, decodeStoredComponent)
import Core.CLI (parseFile)
import Core.Type (Book (..))
import qualified Data.Map.Strict as Map
import Data.List (isInfixOf)
import System.Environment (getArgs)

main :: IO ()
main = do
  [sourcePath, hvmPath, expectedIterations, expectedHeap] <- getArgs
  source <- readFile sourcePath
  parsed <- parseFile sourcePath
  checked <- either (const (fail "Bend admission rejected canonical fixture")) pure (admitBook sourcePath source parsed)
  addressed <- either fail pure (addressComponents checked)
  entries <- traverse decode addressed
  let Book definitions hits = foldr merge (Book Map.empty Map.empty) (map snd entries)
      mainEntries = [name | (Just name, _) <- entries]
  mainName <- case mainEntries of
    [name] -> pure name
    _ -> fail "expected exactly one main component member"
  executable <- either fail pure (selectEntryAsMain mainName (Book definitions hits))
  result <- runCheckedBook hvmPath executable
  case result of
    Right ExecutionResult {output = out, diagnostics = err}
      | take 2 out == "0 "
          && ("Itrs: " ++ expectedIterations ++ " interactions") `isInfixOf` (out ++ err)
          && ("Heap: " ++ expectedHeap ++ " nodes") `isInfixOf` (out ++ err) ->
          putStrLn ("canonical components executed: " ++ expectedIterations ++ " interactions\n" ++ out ++ err)
    _ -> fail (show result)
  where
    decode component = do
      let names = componentNames (addressedPlan component)
          mainIndex = lookup "main" (zip names [0 ..])
          entry = syntheticMemberName (addressedDigest component) <$> mainIndex
      book <- either fail pure (decodeStoredComponent (addressedDigest component) (addressedBytes component))
      pure (entry, book)

    merge (Book leftDefs leftHits) (Book rightDefs rightHits) =
      Book (Map.union leftDefs rightDefs) (Map.union leftHits rightHits)
