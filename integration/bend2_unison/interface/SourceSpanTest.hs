module Main where

import Core.Parse.Book (doParseBook)
import Core.Projection (sourceSpanAt)
import Core.Type (Book(..), Span(..))
import qualified Data.Map.Strict as Map

main :: IO ()
main = do
  let source = "def main() -> Nat:\n  0n\n"
  Book defs _ <- either error pure (doParseBook "example.bend" source)
  (_,body,_) <- maybe (error "main missing") pure (Map.lookup "main" defs)
  case sourceSpanAt body [] of
    Right (Just span)
      | spanBeg span == (2,3) && spanEnd span == (2,5) ->
          putStrLn "authored Bend source span recovered"
      | otherwise -> error ("unexpected span: " ++ show span)
    Right Nothing -> error "parsed Bend body carried no source span"
    Left err -> error (show err)
