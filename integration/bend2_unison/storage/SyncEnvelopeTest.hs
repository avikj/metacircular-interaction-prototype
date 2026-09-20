module Main where

import Core.SyncEnvelope
import Crypto.Hash (Digest, SHA3_512, hash)
import qualified Data.ByteArray as ByteArray
import qualified Data.ByteString as Bytes
import qualified Data.ByteString.Lazy as Lazy

main :: IO ()
main = do
  let object = Bytes.pack [1,2,3,4]
      source = Bytes.pack [100,101,102,32,109,97,105,110]
      digest bytes = ByteArray.convert (hash bytes :: Digest SHA3_512)
      envelope = SyncEnvelope
        (digest object) object
        [SyncDependency 0 (digest (Bytes.pack [9])) 2]
        [SyncPresentation 0 (digest source) source 0 8 (Bytes.pack [109,97,105,110]) (Bytes.pack [109,97,105,110,46,98,101,110,100])]
  encoded <- either fail pure (encodeSyncEnvelope envelope)
  restored <- either fail pure (decodeSyncEnvelope encoded)
  if restored /= envelope then fail "Bend2 sync envelope roundtrip differs" else pure ()
  case decodeSyncEnvelope (encoded <> Lazy.singleton 0) of
    Left _ -> pure ()
    Right _ -> fail "Bend2 sync envelope accepted trailing bytes"
  case encodeSyncEnvelope envelope {componentDigest = Bytes.replicate 64 0} of
    Left _ -> pure ()
    Right _ -> fail "Bend2 sync envelope accepted wrong component hash"
  case encodeSyncEnvelope envelope {presentations = [SyncPresentation 0 (digest source) source 0 9 (Bytes.pack [109]) (Bytes.pack [109])]} of
    Left _ -> pure ()
    Right _ -> fail "Bend2 sync envelope accepted out-of-range presentation"
  let invalidUtf8 = Bytes.pack [0xff]
  case encodeSyncEnvelope envelope {presentations = [SyncPresentation 0 (digest invalidUtf8) invalidUtf8 0 1 (Bytes.pack [109]) (Bytes.pack [109])]} of
    Left _ -> pure ()
    Right _ -> fail "Bend2 sync envelope accepted non-UTF-8 source"
  putStrLn "Bend2 sync envelope roundtrip and integrity checks passed"
