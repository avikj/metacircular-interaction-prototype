{-# LANGUAGE OverloadedStrings #-}

module Bend.UCM.Name (fromBendName) where

import Data.List.NonEmpty (NonEmpty (..))
import Data.Text (Text)
import Data.Text qualified as Text
import Unison.Name (Name)
import Unison.Name qualified as Name
import Unison.NameSegment.Internal (NameSegment (NameSegment))

-- Bend's checker has already validated declaration identifiers. Build the
-- branch name from those identifiers directly: Unison's source parser rejects
-- some valid Bend names (for example `alias`) solely because they are Unison
-- keywords. The stored name segment and Bend spelling remain identical.
-- Slash is Bend's import path separator; dot is UCM's namespace separator.
fromBendName :: Text -> Either String Name
fromBendName authored =
  case concatMap (Text.splitOn ".") (Text.splitOn "/" authored) of
    [] -> Left "empty Bend name"
    x : xs
      | any Text.null (x : xs) -> Left ("empty Bend name segment in " ++ Text.unpack authored)
      | otherwise -> Right (Name.fromSegments (NameSegment x :| map NameSegment xs))
