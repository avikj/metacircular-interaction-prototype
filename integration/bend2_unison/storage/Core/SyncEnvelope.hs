module Core.SyncEnvelope
  ( SyncEnvelope(..)
  , SyncDependency(..)
  , SyncPresentation(..)
  , encodeSyncEnvelope
  , decodeSyncEnvelope
  ) where

import Control.Monad (replicateM, unless)
import Crypto.Hash (Digest, SHA3_512, hash)
import qualified Data.ByteArray as ByteArray
import qualified Data.ByteString as Bytes
import qualified Data.ByteString.Lazy as Lazy
import Data.Binary.Get (Get, getByteString, getWord8, getWord32be, getWord64be, runGetOrFail)
import Data.Binary.Put (Put, putByteString, putWord8, putWord32be, putWord64be, runPut)
import qualified Data.Text.Encoding as Text
import Data.Word (Word32, Word64)

-- The exact component blob remains addressed by SHA3-512. Dependencies and
-- authored presentations travel beside it; changing either does not alter
-- the executable component's identity.
data SyncDependency = SyncDependency
  { dependentMember :: Word32
  , dependencyDigest :: Bytes.ByteString
  , dependencyMember :: Word32
  } deriving (Eq, Show)

data SyncPresentation = SyncPresentation
  { presentationMember :: Word32
  , presentationSourceDigest :: Bytes.ByteString
  , presentationSource :: Bytes.ByteString
  , presentationStart :: Word64
  , presentationEnd :: Word64
  , presentationName :: Bytes.ByteString
  , presentationPath :: Bytes.ByteString
  } deriving (Eq, Show)

data SyncEnvelope = SyncEnvelope
  { componentDigest :: Bytes.ByteString
  , componentBytes :: Bytes.ByteString
  , dependencies :: [SyncDependency]
  , presentations :: [SyncPresentation]
  } deriving (Eq, Show)

-- A separate versioned envelope for sync. Its canonical component bytes are
-- exactly the bytes stored in object.bytes, without re-encoding.
encodeSyncEnvelope :: SyncEnvelope -> Either String Lazy.ByteString
encodeSyncEnvelope envelope = do
  validate envelope
  pure (runPut (putEnvelope envelope))

decodeSyncEnvelope :: Lazy.ByteString -> Either String SyncEnvelope
decodeSyncEnvelope bytes =
  case runGetOrFail getEnvelope bytes of
    Left (_, _, err) -> Left err
    Right (rest, _, envelope)
      | not (Lazy.null rest) -> Left "trailing bytes after Bend2 sync envelope"
      | otherwise -> validate envelope >> Right envelope

putEnvelope :: SyncEnvelope -> Put
putEnvelope envelope = do
  putByteString (Bytes.pack [0x42, 0x32, 0x53, 0x59]) -- B2SY
  putWord8 1
  putByteString (componentDigest envelope)
  putBlob (componentBytes envelope)
  putCount (length (dependencies envelope))
  mapM_ putDependency (dependencies envelope)
  putCount (length (presentations envelope))
  mapM_ putPresentation (presentations envelope)

getEnvelope :: Get SyncEnvelope
getEnvelope = do
  magic <- getByteString 4
  unless (magic == Bytes.pack [0x42, 0x32, 0x53, 0x59]) (fail "invalid Bend2 sync envelope")
  version <- getWord8
  unless (version == 1) (fail "unsupported Bend2 sync envelope version")
  digest <- getByteString 64
  bytes <- getBlob
  dependencyCount <- getCount
  deps <- replicateM dependencyCount getDependency
  presentationCount <- getCount
  forms <- replicateM presentationCount getPresentation
  pure (SyncEnvelope digest bytes deps forms)

putDependency :: SyncDependency -> Put
putDependency (SyncDependency member digest dependency) =
  putWord32be member >> putByteString digest >> putWord32be dependency

getDependency :: Get SyncDependency
getDependency = SyncDependency <$> getWord32be <*> getByteString 64 <*> getWord32be

putPresentation :: SyncPresentation -> Put
putPresentation (SyncPresentation member digest source start end name path) = do
  putWord32be member
  putByteString digest
  putBlob source
  putWord64be start
  putWord64be end
  putBlob name
  putBlob path

getPresentation :: Get SyncPresentation
getPresentation = SyncPresentation <$> getWord32be <*> getByteString 64 <*> getBlob <*> getWord64be <*> getWord64be <*> getBlob <*> getBlob

putCount :: Int -> Put
putCount = putWord32be . fromIntegral

getCount :: Get Int
getCount = do
  count <- getWord32be
  if count > 1000000 then fail "Bend2 sync envelope count is too large" else pure (fromIntegral count)

putBlob :: Bytes.ByteString -> Put
putBlob bytes = putWord64be (fromIntegral (Bytes.length bytes)) >> putByteString bytes

getBlob :: Get Bytes.ByteString
getBlob = do
  length64 <- getWord64be
  if length64 > fromIntegral (maxBound :: Int)
    then fail "Bend2 sync envelope blob is too large"
    else getByteString (fromIntegral length64)

validate :: SyncEnvelope -> Either String ()
validate envelope = do
  checkDigest "component" (componentDigest envelope) (componentBytes envelope)
  unlessE (length (dependencies envelope) <= 1000000) "too many Bend2 dependencies"
  unlessE (length (presentations envelope) <= 1000000) "too many Bend2 presentations"
  mapM_ (\dep -> unlessE (Bytes.length (dependencyDigest dep) == 64) "invalid Bend2 dependency digest") (dependencies envelope)
  mapM_ checkPresentation (presentations envelope)
  where
    checkPresentation form = do
      checkDigest "source" (presentationSourceDigest form) (presentationSource form)
      unlessE (presentationStart form <= presentationEnd form) "invalid Bend2 source range"
      unlessE (presentationEnd form <= fromIntegral (Bytes.length (presentationSource form))) "Bend2 source range exceeds source"
      case Text.decodeUtf8' (presentationSource form) of
        Left _ -> Left "invalid UTF-8 Bend2 presentation source"
        Right _ -> Right ()
      case Text.decodeUtf8' (presentationName form) of
        Left _ -> Left "invalid UTF-8 Bend2 presentation name"
        Right _ -> Right ()
      case Text.decodeUtf8' (presentationPath form) of
        Left _ -> Left "invalid UTF-8 Bend2 presentation path"
        Right _ -> Right ()

checkDigest :: String -> Bytes.ByteString -> Bytes.ByteString -> Either String ()
checkDigest kind digest bytes =
  let actual = ByteArray.convert (hash bytes :: Digest SHA3_512) :: Bytes.ByteString
   in unlessE (digest == actual) ("Bend2 " ++ kind ++ " hash mismatch")

unlessE :: Bool -> String -> Either String ()
unlessE condition message = if condition then Right () else Left message
