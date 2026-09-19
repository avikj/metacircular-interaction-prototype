{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}
module Main where

import Codec.Serialise (deserialiseOrFail, serialise)
import Core.Admission (admitSource)
import Core.ComponentPlan (AddressedComponent(..), addressComponents)
import Core.ComponentPlan (ComponentPlan(..))
import Core.Type (Book(..))
import Control.Monad (forM_)
import Crypto.Hash (Digest, SHA3_512, hash)
import qualified Data.Aeson as Aeson
import qualified Data.ByteArray as ByteArray
import qualified Data.ByteString as Bytes
import qualified Data.ByteString.Lazy as LazyBytes
import qualified Data.Map.Strict as Map
import Data.Foldable (toList)
import qualified Data.Set as Set
import Data.Text (Text)
import System.Environment (getArgs)
import qualified U.Codebase.Sqlite.TempEntity as TempEntity
import qualified U.Codebase.Sqlite.Bend.Format as BendFormat
import qualified Unison.Hash as Hash
import qualified Unison.Hash32 as Hash32
import Unison.Server.Orphans ()
import qualified Unison.Sync.Common as Sync
import qualified Unison.Sync.EntityValidation as Validation
import qualified Unison.Sync.Types as Share

main :: IO ()
main = do
  [sourcePath] <- getArgs
  bendSource <- readFile sourcePath
  checked <- either (const (fail "Bend admission failed")) pure (admitSource sourcePath bendSource)
  addressed <- either fail pure (addressComponents checked)
  forM_ addressed \(AddressedComponent plan _ bytes) -> do
    roles <- either fail pure (BendFormat.memberRoles (LazyBytes.toStrict bytes))
    let Book defs hits = componentBook plan
        expected = [(Map.member name defs, Map.member name hits) | name <- componentNames plan]
        actual = [(BendFormat.hasTerm role, BendFormat.hasType role) | role <- toList roles]
    if actual == expected then pure () else fail "Bend member-role index differs from checked Book"
  forM_ addressed \(AddressedComponent _ componentDigest bytes) -> do
    let hash32 = Hash32.fromHash (Hash.fromByteString componentDigest)
        componentEntity = Share.B (Share.BendComponent (LazyBytes.toStrict bytes) [] [] [])
          :: Share.Entity Text Hash32.Hash32 Hash32.Hash32
    case Validation.validateEntity hash32 componentEntity of
      Nothing -> pure ()
      Just err -> fail ("valid checked Bend component failed Share ingestion: " ++ show err)
  canonical <- case addressed of
    AddressedComponent _ _ bytes : _ -> pure (LazyBytes.toStrict bytes)
    [] -> fail "Bend source has no component"
  let source = Bytes.pack [100,101,102,32,109,97,105,110]
      digest bytes = ByteArray.convert (hash bytes :: Digest SHA3_512) :: Bytes.ByteString
      objectHash = Hash32.fromHash (Hash.fromByteString (digest canonical))
      externalHash = Hash32.fromHash (Hash.fromByteString (digest (Bytes.pack [9])))
      bend = Share.BendComponent canonical [(0,1)] [(0,externalHash,0)]
        [(0,digest source,source,0,8,"main","example.bend")]
      entity = Share.B bend :: Share.Entity Text Hash32.Hash32 Hash32.Hash32
  if Share.entityDependencies entity == Set.singleton externalHash
    then pure () else fail "Bend Share entity included local SCC edge as remote dependency"
  decoded <- either fail pure (Aeson.eitherDecode (Aeson.encode entity))
  if decoded == entity then pure () else fail "Bend Share JSON roundtrip differs"
  let temp = Sync.entityToTempEntity id entity
      restored = Sync.tempEntityToEntity temp
  if restored == entity then pure () else fail "Bend Share/temp conversion differs"
  restoredTemp <- either (fail . show) pure (deserialiseOrFail (serialise temp))
  let typedRestoredTemp = restoredTemp :: TempEntity.TempEntity
  if typedRestoredTemp == temp then pure () else fail "Bend temp CBOR roundtrip differs"
  case Validation.validateEntity objectHash entity of
    Nothing -> pure ()
    Just errorValue -> fail ("valid Bend Share entity rejected: " ++ show errorValue)
  let corrupt = Share.B (bend { Share.bendBytes = Bytes.pack [0] })
  case Validation.validateEntity objectHash corrupt of
    Nothing -> fail "Bend Share accepted wrong component hash"
    Just _ -> pure ()
  let malformedBytes = Bytes.pack [0]
      malformedHash = Hash32.fromHash (Hash.fromByteString (digest malformedBytes))
  case Validation.validateEntity malformedHash corrupt of
    Nothing -> fail "Bend Share accepted malformed canonical payload with matching hash"
    Just _ -> pure ()
  let badSource = Share.B (bend { Share.bendPresentations =
        [(0,Bytes.pack [0],source,0,8,"main","example.bend")] })
  case Validation.validateEntity objectHash badSource of
    Nothing -> fail "Bend Share accepted wrong source digest"
    Just _ -> pure ()
  let badRange = Share.B (bend { Share.bendPresentations =
        [(0,digest source,source,0,9,"main","example.bend")] })
  case Validation.validateEntity objectHash badRange of
    Nothing -> fail "Bend Share accepted invalid source range"
    Just _ -> pure ()
  case Aeson.eitherDecodeStrict' (Bytes.pack [123,125]) :: Either String (Share.Entity Text Hash32.Hash32 Hash32.Hash32) of
    Right _ -> fail "Bend Share accepted missing entity payload"
    Left _ -> pure ()
  putStrLn "Bend Share JSON/CBOR/dependency/validation tests passed"
