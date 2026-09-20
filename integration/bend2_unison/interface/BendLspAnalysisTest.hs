module Main where

import Core.LspAnalysis
import Core.Type (Span(..))
import qualified Data.ByteString as Bytes

main :: IO ()
main = do
  let source = "def answer() -> Nat:\n  0n\n\ndef identity(x: Nat) -> Nat:\n  x\n\ndef use() -> Nat:\n  identity(answer)\n"
  checked <- either (error . diagnosticMessage) pure
    (analyzeBendSource "answer.bend" source)
  case bendHoverAt checked (2,3) of
    Just (typ,Just span)
      | typ == "Nat" && spanBeg span == (2,3) -> pure ()
      | otherwise -> error ("wrong hover: " ++ show (typ,span))
    _ -> error "Bend hover unavailable"
  case bendReferenceAt checked (2,3) of
    Just (digest,_) | Bytes.length digest == 64 -> pure ()
    _ -> error "missing native component reference on hover"
  case analyzeBendSource "broken.bend" "def broken() -> Nat:\n  Set\n" of
    Left diagnostic -> case diagnosticSpan diagnostic of
      Just _ -> pure ()
      Nothing -> error "missing checker diagnostic span"
    Right _ -> error "incorrectly accepted ill-typed Bend source"
  case bendDefinitionAt checked (8,12) of
    Just target | spanBeg target == (2,3) -> pure ()
    other -> error ("Bend definition navigation failed: " ++ show other)
  case bendDefinitionAt checked (8,3) of
    Just target | spanBeg target == (5,3) -> pure ()
    other -> error ("Bend call navigation failed: " ++ show other)
  putStrLn "Bend LSP analysis hover and diagnostics passed"
