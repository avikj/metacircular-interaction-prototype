{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Unison.Server.Local.Endpoints.BendSubterm
  ( BendSubtermAPI
  , BendSubtermResponse(..)
  , serveBendSubterm
  ) where

import Bend.UCM.Subterm
  ( PresentationSpan(..), StoredSubterm(..), projectStoredSubterm )
import Core.CanonicalComponent
  ( parseSyntheticMemberName, parseSyntheticConstructorName
  , syntheticConstructorName )
import Control.Monad.Except (throwError)
import Core.Projection
  ( Projection(..), RootSelector(..), SubtermAddress(..) )
import Core.Reify (Flat(..), reifyTerm)
import Core.SemanticIdentity (semanticVersion)
import Core.Type (Span(..))
import Control.Monad.IO.Class (liftIO)
import Data.Aeson (ToJSON(..), Value, object, (.=))
import qualified Data.ByteString as Bytes
import Data.Char (digitToInt, isHexDigit)
import Data.OpenApi (ToSchema(..),NamedSchema(..))
import qualified Data.Set as Set
import qualified Data.Text as Text
import Servant (Get, JSON, QueryParam, (:>))
import Servant.Docs
  ( DocQueryParam(..), ParamKind(..), ToParam(..), ToSample(..), noSamples )
import U.Codebase.Sqlite.Queries qualified as Q
import U.Codebase.Reference qualified as Ref
import Unison.Codebase (Codebase)
import Unison.Codebase qualified as Codebase
import Unison.Hash qualified as Hash
import Unison.Server.Backend (Backend, BackendError(..))

-- All coordinates are native Bend component coordinates. The path indexes
-- Core.Reify's alpha-invariant first-order term tree.
type BendSubtermAPI =
  "bend" :> "subterm"
    :> QueryParam "digest" Text.Text
    :> QueryParam "member" Int
    :> QueryParam "root" Text.Text
    :> QueryParam "path" Text.Text
    :> Get '[JSON] BendSubtermResponse

newtype BendSubtermResponse = BendSubtermResponse Value

instance ToJSON BendSubtermResponse where
  toJSON (BendSubtermResponse value) = value

instance ToSchema BendSubtermResponse where
  declareNamedSchema _ = pure (NamedSchema Nothing mempty)

instance ToSample BendSubtermResponse where
  toSamples _ = noSamples

instance ToParam (QueryParam "digest" Text.Text) where
  toParam _ = DocQueryParam "digest" [] "Full 64-byte Bend component hash in hexadecimal." Normal

instance ToParam (QueryParam "member" Int) where
  toParam _ = DocQueryParam "member" ["0"] "Zero-based member slot in the addressed component." Normal

instance ToParam (QueryParam "root" Text.Text) where
  toParam _ = DocQueryParam "root" ["body","type","hit","constructor:0"]
    "Bend member root to inspect." Normal

instance ToParam (QueryParam "path" Text.Text) where
  toParam _ = DocQueryParam "path" ["0,1"] "Comma-separated canonical subterm child indices." Normal

serveBendSubterm
  :: Codebase IO v a
  -> Maybe Text.Text -> Maybe Int -> Maybe Text.Text -> Maybe Text.Text
  -> Backend IO BendSubtermResponse
serveBendSubterm codebase digestText member rootText pathText = do
  digest <- either (throwError . BendSubtermBadRequest) pure
    (maybe (Left "missing Bend2 digest") parseDigest digestText)
  index <- maybe (throwError (BendSubtermBadRequest "missing member index")) pure member
  if index < 0
    then throwError (BendSubtermBadRequest "negative member index")
    else pure ()
  root <- either (throwError . BendSubtermBadRequest) pure
    (maybe (Left "missing Bend2 root selector") (parseRoot digest index) rootText)
  path <- either (throwError . BendSubtermBadRequest) pure
    (parsePath pathText)
  outcome <- liftIO $ Codebase.runTransaction codebase $ do
    objectId <- Q.loadObjectIdForPrimaryHash (Hash.fromByteString digest)
    case objectId of
      Nothing -> pure (Left "Bend2 component digest not found")
      Just oid -> do
        projected <- projectStoredSubterm (Ref.Id oid (fromIntegral index)) root path
        peers <- case root of
          BodyRoot -> do
            identity <- Q.loadBendSemanticIdentity oid (fromIntegral index) semanticVersion
            case identity of
              Nothing -> pure []
              Just normalFormHash -> do
                refs <- Q.findBendMembersBySemanticIdentity semanticVersion normalFormHash
                traverse (\(Ref.Id peerOid peerIndex) -> do
                  peerDigest <- Hash.toByteString <$> Q.expectPrimaryHashByObjectId peerOid
                  pure (peerDigest,fromIntegral peerIndex))
                  (filter (/= Ref.Id oid (fromIntegral index)) refs)
          _ -> pure []
        pure ((\value -> (value,peers)) <$> projected)
  either (throwError . BendSubtermBadRequest)
    (pure . BendSubtermResponse . uncurry storedJSON) outcome

parseDigest :: Text.Text -> Either String Bytes.ByteString
parseDigest value
  | Text.length value /= 128 = Left "Bend2 digest must contain 128 hex characters"
  | Text.any (not . isHexDigit) value = Left "Bend2 digest contains non-hexadecimal characters"
  | otherwise =
      let chars = Text.unpack value
          bytes = [fromIntegral (digitToInt hi * 16 + digitToInt lo)
                  | (hi,lo) <- pairs chars]
      in Right (Bytes.pack bytes)
  where
    pairs (a:b:rest) = (a,b) : pairs rest
    pairs _ = []

parseRoot :: Bytes.ByteString -> Int -> Text.Text -> Either String RootSelector
parseRoot digest member value = case Text.unpack value of
  "body" -> Right BodyRoot
  "type" -> Right TypeRoot
  "hit" -> Right HitRoot
  name | Just ordinal <- stripPrefix "constructor:" name ->
    case reads ordinal of
      [(index,"")] | index >= 0 ->
        Right (ConstructorRoot (syntheticConstructorName digest member index))
      _ -> Left "constructor root must have a nonnegative ordinal"
  _ -> Left "root must be body, type, hit, or constructor:ORDINAL"
  where
    stripPrefix prefix input
      | take (length prefix) input == prefix = Just (drop (length prefix) input)
      | otherwise = Nothing

parsePath :: Maybe Text.Text -> Either String [Int]
parsePath Nothing = Right []
parsePath (Just value)
  | Text.null value = Right []
  | otherwise = traverse parseIndex (Text.splitOn "," value)
  where
    parseIndex chunk
      | Text.null chunk || Text.any (\c -> c < '0' || c > '9') chunk =
          Left "path must be comma-separated nonnegative child indices"
      | otherwise = case reads (Text.unpack chunk) of
          [(index,"")] -> Right index
          _ -> Left "path child index exceeds Int range"

projectionJSON :: Projection -> Value
projectionJSON projected =
  object
    [ "address" .= maybe (object []) addressJSON (projectionAddress projected)
    , "constructors" .= projectionConstructors projected
    , "term" .= flatJSON (projectionFlat projected)
    , "type" .= flatJSON (reifyTerm (projectionType projected))
    , "dependencies" .= map dependencyJSON (Set.toAscList (projectionDependencies projected))
    , "span" .= fmap spanJSON (projectionSpan projected)
    ]

storedJSON :: StoredSubterm -> [(Bytes.ByteString,Int)] -> Value
storedJSON stored peers =
  object
    [ "projection" .= projectionJSON (storedProjection stored)
    , "presentations" .= map presentationJSON (storedPresentations stored)
    , "semanticPeers" .= map (\(digest,member) ->
        object ["digest" .= hexBytes digest,"member" .= member]) peers
    ]

presentationJSON :: PresentationSpan -> Value
presentationJSON presentation =
  object
    [ "sourceDigest" .= hexBytes (presentationDigest presentation)
    , "authoredName" .= presentationName presentation
    , "sourcePath" .= presentationPath presentation
    , "sourceByteRange" .=
        [fst (presentationByteRange presentation),snd (presentationByteRange presentation)]
    , "span" .= fmap spanJSON (presentationSpan presentation)
    , "error" .= presentationError presentation
    ]

dependencyJSON :: String -> Value
dependencyJSON name = case parseSyntheticMemberName name of
  Just (digest,member) ->
    object ["digest" .= hexBytes digest,"member" .= member]
  Nothing -> object ["name" .= name]

addressJSON :: SubtermAddress -> Value
addressJSON address =
  object
    [ "digest" .= hexBytes (addressComponentHash address)
    , "member" .= addressMemberIndex address
    , "root" .= rootJSON address
    , "path" .= addressTermPath address
    ]

rootJSON :: SubtermAddress -> Text.Text
rootJSON address = case addressRoot address of
  BodyRoot -> "body"
  TypeRoot -> "type"
  HitRoot -> "hit"
  ConstructorRoot name ->
    case parseSyntheticConstructorName name of
      Just (_,_,ordinal) -> Text.pack ("constructor:" ++ show ordinal)
      Nothing -> Text.pack ("constructor:" ++ name)

spanJSON :: Span -> Value
spanJSON span =
  object
    [ "start" .= [fst (spanBeg span),snd (spanBeg span)]
    , "end" .= [fst (spanEnd span),snd (spanEnd span)]
    ]

flatJSON :: Flat -> Value
flatJSON flat = case flat of
  Bound index -> object ["kind" .= ("bound" :: Text.Text),"index" .= index]
  Free name index -> object ["kind" .= ("free" :: Text.Text),"name" .= name,"index" .= index]
  Global name -> object ["kind" .= ("global" :: Text.Text),"name" .= name]
  Node tag children -> object ["kind" .= ("node" :: Text.Text),"tag" .= tag,"children" .= map flatJSON children]
  Text value -> object ["kind" .= ("text" :: Text.Text),"value" .= value]
  NatAtom value -> object ["kind" .= ("int" :: Text.Text),"value" .= value]
  WordAtom value -> object ["kind" .= ("word64" :: Text.Text),"value" .= show value]
  SignedAtom value -> object ["kind" .= ("int64" :: Text.Text),"value" .= show value]
  DoubleBits bits -> object ["kind" .= ("float64-bits" :: Text.Text),"value" .= hexWord 16 bits]
  CharAtom value -> object ["kind" .= ("char" :: Text.Text),"value" .= [value]]
  BoolAtom value -> object ["kind" .= ("bool" :: Text.Text),"value" .= value]

hexBytes :: Bytes.ByteString -> String
hexBytes = concatMap (hexWord 2 . toInteger) . Bytes.unpack

hexWord :: Integral a => Int -> a -> String
hexWord width value =
  let alphabet = "0123456789abcdef"
      n = toInteger value
      digits = reverse (take width (go n ++ repeat '0'))
      go 0 = []
      go x = alphabet !! fromInteger (x `mod` 16) : go (x `div` 16)
  in digits
