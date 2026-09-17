module Bend.UCM.Subterm
  ( StoredSubterm(..)
  , PresentationSpan(..)
  , projectStoredSubterm
  ) where

import Bend.UCM.Storage (loadDependencyClosedBook, loadStoredComponent)
import Core.CanonicalComponent (syntheticMemberName, syntheticConstructorName)
import Core.Projection
  ( Projection, RootSelector(..), projectAddressed, sourceSpanAt )
import Core.Provenance (sourceOrigins)
import Core.Type (Book(..), Name, Span, Term, hitCtors, hitType, ctorType)
import qualified Data.ByteString as Bytes
import qualified Data.Map.Strict as Map
import qualified Data.Set as Set
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified U.Codebase.Sqlite.Queries as Q
import qualified U.Codebase.Sqlite.Reference as S
import qualified U.Codebase.Reference as Ref
import qualified Unison.Hash as Hash
import Unison.Sqlite (Transaction)

-- One native stored member ref and a canonical first-order term path are
-- sufficient to serve typed subterm information. The complete dependency
-- Book is loaded before Bend's checker is asked about the selected term.
data PresentationSpan = PresentationSpan
  { presentationDigest :: Bytes.ByteString
  , presentationName :: Name
  , presentationPath :: FilePath
  , presentationByteRange :: (Int,Int)
  , presentationSpan :: Maybe Span
  , presentationError :: Maybe String
  }

data StoredSubterm = StoredSubterm
  { storedProjection :: Projection
  , storedPresentations :: [PresentationSpan]
  }

projectStoredSubterm
  :: S.Id -> RootSelector -> [Int] -> Transaction (Either String StoredSubterm)
projectStoredSubterm ref@(Ref.Id objectId memberIndex) root path = do
  digest <- Hash.toByteString <$> Q.expectPrimaryHashByObjectId objectId
  rootComponent <- loadStoredComponent objectId
  closure <- loadDependencyClosedBook ref
  authored <- Q.loadBendPresentations objectId memberIndex
  pure $ do
    component <- case rootComponent of
      Nothing -> Left "stored reference is not a Bend2 component"
      Just (Left why) -> Left why
      Just (Right book) -> Right book
    book <- closure
    let count = memberCount component
        names = [syntheticMemberName digest i | i <- [0 .. count - 1]]
    case projectAddressed digest names book (fromIntegral memberIndex) root path of
      Left why -> Left (showProjectionError why)
      Right projected ->
        Right (StoredSubterm projected
          (map (recover digest (fromIntegral memberIndex) root path) authored))

memberCount :: Book -> Int
memberCount (Book defs hits) =
  Set.size (Map.keysSet defs `Set.union` Map.keysSet hits)

showProjectionError :: Show a => a -> String
showProjectionError = show

recover :: Integral a => Bytes.ByteString -> Int -> RootSelector -> [Int]
        -> (Bytes.ByteString,Bytes.ByteString,a,a,T.Text,T.Text)
        -> PresentationSpan
recover componentDigest memberIndex root path (digest,source,start,end,authoredName,sourcePath) =
  let sourceName = T.unpack authoredName
      outcome = do
        sourceText <- either (Left . show) Right (TE.decodeUtf8' source)
        (parsed,_,_) <- sourceOrigins (T.unpack sourcePath) (T.unpack sourceText)
        term <- selectRoot componentDigest memberIndex parsed sourceName root
        either (Left . show) Right (sourceSpanAt term path)
      (span,errorText) = case outcome of
        Right found -> (found,Nothing)
        Left reason -> (Nothing,Just reason)
  in PresentationSpan digest sourceName (T.unpack sourcePath) (fromIntegral start,fromIntegral end) span errorText

selectRoot :: Bytes.ByteString -> Int -> Book -> Name -> RootSelector -> Either String Term
selectRoot digest memberIndex (Book defs hits) name selector = case selector of
  BodyRoot -> maybe (Left "authored definition body missing") (\(_,body,_) -> Right body)
    (Map.lookup name defs)
  TypeRoot -> maybe (Left "authored definition type missing") (\(_,_,typ) -> Right typ)
    (Map.lookup name defs)
  HitRoot -> maybe (Left "authored HIT declaration missing") (Right . hitType)
    (Map.lookup name hits)
  ConstructorRoot ctorName -> do
    hit <- maybe (Left "authored HIT declaration missing") Right (Map.lookup name hits)
    ctor <- maybe (Left "authored HIT constructor ordinal missing") Right
      (lookup ctorName
        [(syntheticConstructorName digest memberIndex i,ctor)
         | (i,(_,ctor)) <- zip [0..] (hitCtors hit)])
    Right (ctorType ctor)
