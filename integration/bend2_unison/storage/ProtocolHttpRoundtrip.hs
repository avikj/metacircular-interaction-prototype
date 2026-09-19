{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Lens ((%~), (&))
import Control.Monad (forM_, unless)
import qualified Bend.UCM.Storage
import Bend.UCM.Execution (output, runCheckedBook, selectEntryAsMain)
import qualified Data.Aeson as Aeson
import Data.Aeson ((.=))
import qualified Data.ByteArray.Encoding as Base
import qualified Data.ByteString.Lazy as Lazy
import qualified Data.Map.NonEmpty as NEMap
import qualified Data.Map.Strict as Map
import qualified Data.Set.NonEmpty as NESet
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text
import qualified Network.HTTP.Client as Http
import qualified Network.HTTP.Types as Http
import qualified Network.Wai as Wai
import qualified Network.Wai.Handler.Warp as Warp
import System.Environment (getArgs)
import System.IO (hClose, openTempFile)
import qualified U.Codebase.Sqlite.Queries as Q
import U.Codebase.Sqlite.V2.HashHandle (v2HashHandle)
import qualified Unison.Hash as Hash
import qualified Unison.Hash32 as Hash32
import qualified Unison.Share.API.Hash as JWT
import qualified Unison.Sqlite as Sqlite
import qualified Unison.Sync.Common as Sync
import qualified Unison.Sync.EntityValidation as Validation
import qualified Unison.Sync.Types as Share
import Core.Admission (CheckedSource(..), admitSource)
import Core.ComponentPlan (AddressedComponent(..), addressComponents)

main :: IO ()
main = do
  [sourcePath,hvmPath] <- getArgs
  source <- readFile sourcePath
  checked <- either (const (fail "Bend admission failed")) pure (admitSource sourcePath source)
  components <- either fail pure (addressComponents checked)
  (sourceDb,sourceHandle) <- openTempFile "/private/tmp" "bend-http-source.sqlite"
  hClose sourceHandle
  (targetDb,targetHandle) <- openTempFile "/private/tmp" "bend-http-target.sqlite"
  hClose targetHandle
  Sqlite.withConnection "bend-http-source" sourceDb \first ->
    Sqlite.withConnection "bend-http-target" targetDb \second -> do
      prepare first
      prepare second
      -- Import into the first database through the native checked-source path.
      saved <- Sqlite.runTransaction first (Bend.UCM.Storage.saveCheckedSource checked)
      either fail pure saved
      manager <- Http.newManager Http.defaultManagerSettings
      Warp.testWithApplication (pure (server second)) \port -> do
        let endpoint action = "http://127.0.0.1:" ++ show port ++ "/ucm/v1/sync/entities/" ++ action
        forM_ components \component -> do
          let hash32 = componentHash component
          entity <- Sqlite.runTransaction first (Sync.expectEntity hash32)
          let payload = Share.UploadEntitiesRequest
                (Share.RepoInfo "@local/bend") (NEMap.singleton hash32 entity)
          response <- postJSON manager (endpoint "upload") payload
          case Aeson.eitherDecode response of
            Right Share.UploadEntitiesSuccess -> pure ()
            other -> fail ("Share upload failed: " ++ show (other :: Either String Share.UploadEntitiesResponse))
        -- Pull every component through the same Share DownloadEntitiesResponse
        -- JSON envelope, then compare the re-export from the second codebase.
        forM_ components \component -> do
          let hash32 = componentHash component
              payload = Share.DownloadEntitiesRequest
                (Share.RepoInfo "@local/bend") (NESet.singleton (jwt hash32))
          response <- postJSON manager (endpoint "download") payload
          case Aeson.eitherDecode response of
            Right (Share.DownloadEntitiesSuccess entities) -> do
              entity <- maybe (fail "Share download omitted component") pure
                (NEMap.lookup hash32 entities)
              let restored = entity & Share.entityHashes_ %~ JWT.hashJWTHash
              original <- Sqlite.runTransaction first (Sync.expectEntity hash32)
              unless (restored == original) (fail "Share download changed Bend component")
            Left err -> fail ("Share download JSON failed: " ++ err)
            Right _ -> fail "Share download returned failure"
      mainEntry <- Sqlite.runTransaction second do
        refs <- Q.findBendMembersByAuthoredName "main"
        case refs of
          [ref] -> Bend.UCM.Storage.loadDependencyClosedEntryBook ref
          _ -> pure (Left "Share import did not preserve unique main presentation")
      (entryName,closedBook) <- either fail pure mainEntry
      runnable <- either fail pure (selectEntryAsMain entryName closedBook)
      direct <- runCheckedBook hvmPath (checkedBook checked)
      restored <- runCheckedBook hvmPath runnable
      directOutput <- either (fail . show) (pure . output) direct
      restoredOutput <- either (fail . show) (pure . output) restored
      unless (stable directOutput == stable restoredOutput)
        (fail "Share HTTP imported Bend closure executes differently")
      putStrLn ("Share v1 HTTP upload/download: " ++ show (length components) ++ " Bend components")

stable :: String -> ([String],[String])
stable value =
  (take 1 (lines value), filter (\line -> take 7 line == "- Itrs:") (lines value))

componentHash :: AddressedComponent -> Hash32.Hash32
componentHash = Hash32.fromHash . Hash.fromByteString . addressedDigest

server :: Sqlite.Connection -> Wai.Application
server target request respond = do
  body <- Wai.strictRequestBody request
  case (Wai.requestMethod request, Wai.pathInfo request) of
    ("POST",["ucm","v1","sync","entities","upload"]) ->
      case Aeson.eitherDecode body of
        Left err -> bad respond err
        Right (Share.UploadEntitiesRequest _ entities) -> do
          forM_ (Map.toList (NEMap.toMap entities)) \(hash32,entity) -> do
            case Validation.validateEntity hash32 entity of
              Nothing -> pure ()
              Just err -> fail ("invalid Share upload: " ++ show err)
            result <- Sqlite.runTransaction target
              (Q.saveTempEntityInMain v2HashHandle hash32 (Sync.entityToTempEntity id entity))
            case result of
              Right _ -> pure ()
              Left _ -> fail "Bend upload unexpectedly saved a causal"
          respond (json Share.UploadEntitiesSuccess)
    ("POST",["ucm","v1","sync","entities","download"]) ->
      case Aeson.eitherDecode body of
        Left err -> bad respond err
        Right (Share.DownloadEntitiesRequest _ hashes) -> do
          let wanted = fmap JWT.hashJWTHash (NESet.toList hashes)
          pairs <- traverse (\hash32 -> do
            entity <- Sqlite.runTransaction target (Sync.expectEntity hash32)
            pure (hash32, entity & Share.entityHashes_ %~ jwt)) wanted
          respond (json (Share.DownloadEntitiesSuccess (NEMap.fromList pairs)))
    _ -> bad respond "unknown Share endpoint"

postJSON :: (Aeson.ToJSON a) => Http.Manager -> String -> a -> IO Lazy.ByteString
postJSON manager url payload = do
  request <- Http.parseRequest url
  response <- Http.httpLbs request
    { Http.method = "POST",
      Http.requestHeaders = [("Content-Type","application/json")],
      Http.requestBody = Http.RequestBodyLBS (Aeson.encode payload)
    } manager
  unless (Http.responseStatus response == Http.status200) (fail "Share HTTP status differs")
  pure (Http.responseBody response)

json :: (Aeson.ToJSON a) => a -> Wai.Response
json value = Wai.responseLBS Http.status200 [("Content-Type","application/json")] (Aeson.encode value)

bad :: (Wai.Response -> IO Wai.ResponseReceived) -> String -> IO Wai.ResponseReceived
bad respond msg = respond (Wai.responseLBS Http.status400 [] (Lazy.fromStrict (Text.encodeUtf8 (Text.pack msg))))

jwt :: Hash32.Hash32 -> JWT.HashJWT
jwt hash32 =
  let claims = Aeson.object ["h" .= hash32, "u" .= Aeson.Null, "t" .= ("hj" :: Text.Text)]
      encoded = Text.decodeUtf8 (Base.convertToBase Base.Base64URLUnpadded (Lazy.toStrict (Aeson.encode claims)))
   in JWT.HashJWT ("e30." <> encoded <> ".x")

prepare :: Sqlite.Connection -> IO ()
prepare connection = do
  let sqlRoot = "/private/tmp/unison-84b95a623711b57b9ff7163f124b214d626b81e4/codebase2/codebase-sqlite/sql/"
  schema <- readFile (sqlRoot ++ "create.sql")
  Sqlite.runTransaction connection do
    Sqlite.executeStatements (Text.pack schema)
    Q.addTempEntityTables
    Q.addBendComponentTables
