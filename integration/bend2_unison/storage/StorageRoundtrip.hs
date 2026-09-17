module Main where

import Core.Admission (CheckedSource(..), AdmissionError(..), admitSource, admitBook)
import Core.FlatCodec (decodeBook, encodeBook)
import Core.ComponentPlan (ComponentPlan(..), AddressedComponent(..), addressComponents, decodeStoredComponent)
import Core.Reify (reifyBook)
import Core.Parse.Book (doParseBook)
import Core.Type (Book(..))
import qualified Data.ByteString.Lazy as Lazy
import qualified Data.Map.Strict as Map
import System.Environment (getArgs)

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["encode", sourcePath, outputPath] -> do
      checked <- loadChecked sourcePath
      let bytes = encodeBook (checkedBook checked)
      Lazy.writeFile outputPath bytes
      putStrLn ("encoded checked Bend2 book: " ++ show (Lazy.length bytes) ++ " bytes")
    ["verify", sourcePath, storedPath] -> do
      checked <- loadChecked sourcePath
      bytes <- Lazy.readFile storedPath
      case decodeBook bytes of
        Left err -> fail err
        Right restored
          | reifyBook restored == reifyBook (checkedBook checked) ->
              putStrLn "checked Bend2 book survived storage roundtrip"
          | otherwise -> fail "stored Bend2 book differs from checked source"
    ["plan", sourcePath] -> do
      checked <- loadChecked sourcePath
      reportPlan checked
    ["plan-merged", libraryPath, clientPath] -> do
      librarySource <- readFile libraryPath
      clientSource <- readFile clientPath
      library <- either fail pure (doParseBook libraryPath librarySource)
      client <- either fail pure (doParseBook clientPath clientSource)
      let Book libraryDefs libraryHits = library
          Book clientDefs clientHits = client
          merged = Book (Map.union clientDefs libraryDefs) (Map.union clientHits libraryHits)
      checked <- either (fail . showAdmission) pure
        (admitBook clientPath (librarySource ++ clientSource) merged)
      reportPlan checked
    ["compare-plan", firstPath, secondPath] -> do
      first <- loadChecked firstPath
      second <- loadChecked secondPath
      firstAddressed <- either fail pure (addressComponents first)
      secondAddressed <- either fail pure (addressComponents second)
      let keyed addressed = Map.fromList
            [ (componentNames plan, digest) | AddressedComponent plan digest _ <- addressed ]
      if keyed firstAddressed == keyed secondAddressed
        then putStrLn "Bend2 component addresses are invariant under source order"
        else fail "Bend2 component addresses changed with source order"
    ["test-rename"] -> do
      let oldSource = "def alpha() -> Nat:\n  0n\n"
          newSource = "def renamed() -> Nat:\n  0n\n"
          addressed source = do
            checked <- either (fail . showAdmission) pure (admitSource "rename.bend" source)
            components <- either fail pure (addressComponents checked)
            case components of
              [component] -> pure component
              _ -> fail "expected one checked component"
      old <- addressed oldSource
      new <- addressed newSource
      if addressedBytes old == addressedBytes new && addressedDigest old == addressedDigest new
        then putStrLn "checked source rename preserves canonical bytes and native reference hash"
        else fail "checked source rename changed the canonical object"
    ["component-encode", sourcePath, memberName, outputPath] -> do
      checked <- loadChecked sourcePath
      components <- either fail pure (addressComponents checked)
      component <- findComponent memberName components
      Lazy.writeFile outputPath (addressedBytes component)
      putStrLn ("encoded native Bend2 component: " ++ show (Lazy.length (addressedBytes component)) ++ " bytes")
    ["component-verify", sourcePath, memberName, storedPath] -> do
      checked <- loadChecked sourcePath
      components <- either fail pure (addressComponents checked)
      component <- findComponent memberName components
      bytes <- Lazy.readFile storedPath
      if bytes /= addressedBytes component then fail "stored bytes differ from addressed Bend2 component" else pure ()
      case decodeStoredComponent (addressedDigest component) bytes of
        Left err -> fail err
        Right _ -> putStrLn "native addressed Bend2 component survived storage roundtrip"
    _ -> fail "usage: storage-roundtrip (encode|verify|plan) SOURCE [BLOB] | plan-merged LIBRARY CLIENT"

reportPlan :: CheckedSource -> IO ()
reportPlan checked =
      case addressComponents checked of
        Left err -> fail err
        Right components -> do
          putStrLn ("addressed Bend2 components: " ++ show (length components))
          mapM_ (\(AddressedComponent plan digest _) -> putStrLn (show (componentNames plan) ++ " " ++ show (Lazy.length (Lazy.fromStrict digest)))) components

findComponent :: String -> [AddressedComponent] -> IO AddressedComponent
findComponent _ [] = fail "Bend2 component member not found"
findComponent name (component : rest)
  | name `elem` componentNames (addressedPlan component) = pure component
  | otherwise = findComponent name rest

loadChecked :: FilePath -> IO CheckedSource
loadChecked sourcePath = do
  source <- readFile sourcePath
  case admitSource sourcePath source of
    Left err -> fail (showAdmission err)
    Right checked -> pure checked

showAdmission :: AdmissionError -> String
showAdmission err = case err of
  ParseFailure msg -> "parse: " ++ msg
  DefinitionTypeFailure name why -> "definition type " ++ name ++ ": " ++ show why
  DefinitionTermFailure name why -> "definition term " ++ name ++ ": " ++ show why
  HitTypeFailure name why -> "HIT type " ++ name ++ ": " ++ show why
  HitConstructorFailure name ctor why -> "HIT constructor " ++ name ++ "." ++ ctor ++ ": " ++ show why
