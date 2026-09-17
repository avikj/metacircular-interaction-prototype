module Core.FlatCodec
  ( encodeFlat
  , decodeFlat
  , encodeBook
  , decodeBook
  ) where

import Core.Reify (Flat(..), reflectBook, reifyBook)
import Core.Type (Book)
import Control.Monad (replicateM, unless)
import Data.Binary.Get
  ( Get, getByteString, getInt64be, getWord8, getWord32be, getWord64be
  , runGetOrFail )
import Data.Binary.Put
  ( Put, putByteString, putInt64be, putWord8, putWord32be, putWord64be
  , runPut )
import qualified Data.ByteString as Strict
import qualified Data.ByteString.Lazy as Lazy
import Data.Char (chr, ord)
import Data.Int (Int64)
import Data.Text (pack, unpack)
import Data.Text.Encoding (decodeUtf8', encodeUtf8)
import Data.Word (Word32)

-- Version 2 uses fixed-width, network-order primitives. No Binary instances,
-- machine-sized Ints, Show, or Read appear in the persisted representation.
-- The envelope is ASCII "B2CF", then one version byte.
encodeFlat :: Flat -> Lazy.ByteString
encodeFlat flat = runPut $ do
  putByteString (Strict.pack [0x42,0x32,0x43,0x46])
  putWord8 2
  putFlat flat

decodeFlat :: Lazy.ByteString -> Either String Flat
decodeFlat bytes =
  case runGetOrFail getVersionedFlat bytes of
    Left (_, _, err) -> Left err
    Right (rest, _, flat)
      | Lazy.null rest -> Right flat
      | otherwise -> Left "trailing bytes after Bend2 checked term"

encodeBook :: Book -> Lazy.ByteString
encodeBook = encodeFlat . reifyBook

decodeBook :: Lazy.ByteString -> Either String Book
decodeBook bytes = decodeFlat bytes >>= reflectBook

getVersionedFlat :: Get Flat
getVersionedFlat = do
  magic <- getByteString 4
  unless (magic == Strict.pack [0x42,0x32,0x43,0x46]) $
    fail "invalid Bend2 checked term envelope"
  version <- getWord8
  unless (version == 2) $
    fail ("unsupported Bend2 checked term version " ++ show version)
  getFlat

putFlat :: Flat -> Put
putFlat flat = case flat of
  Bound i -> putWord8 0 >> putInt i
  Free name i -> putWord8 1 >> putString name >> putInt i
  Global name -> putWord8 2 >> putString name
  Node tag children -> do
    putWord8 3
    putString tag
    putLength (length children)
    mapM_ putFlat children
  Text value -> putWord8 4 >> putString value
  NatAtom value -> putWord8 5 >> putInt value
  WordAtom value -> putWord8 6 >> putWord64be value
  SignedAtom value -> putWord8 7 >> putInt64be value
  DoubleBits value -> putWord8 8 >> putWord64be value
  CharAtom value -> putWord8 9 >> putWord32be (fromIntegral (ord value))
  BoolAtom value -> putWord8 10 >> putWord8 (if value then 1 else 0)

getFlat :: Get Flat
getFlat = do
  tag <- getWord8
  case tag of
    0 -> Bound <$> getInt
    1 -> Free <$> getString <*> getInt
    2 -> Global <$> getString
    3 -> do
      name <- getString
      count <- getWord32be
      arity <- checkedLength count
      Node name <$> replicateM arity getFlat
    4 -> Text <$> getString
    5 -> NatAtom <$> getInt
    6 -> WordAtom <$> getWord64be
    7 -> SignedAtom <$> getInt64be
    8 -> DoubleBits <$> getWord64be
    9 -> do
      point <- getWord32be
      if point <= 0x10ffff && not (point >= 0xd800 && point <= 0xdfff)
        then pure (CharAtom (chr (fromIntegral point)))
        else fail "invalid Unicode scalar in Bend2 character"
    10 -> do
      bit <- getWord8
      case bit of
        0 -> pure (BoolAtom False)
        1 -> pure (BoolAtom True)
        _ -> fail "invalid Bend2 boolean byte"
    _ -> fail ("unknown Bend2 checked term tag " ++ show tag)

putInt :: Int -> Put
putInt = putInt64be . fromIntegral

getInt :: Get Int
getInt = do
  value <- getInt64be
  let result = fromIntegral value
  if (fromIntegral result :: Int64) == value
    then pure result
    else fail "Bend2 integer exceeds platform Int range"

putLength :: Int -> Put
putLength len
  | len < 0 || toInteger len > toInteger (maxBound :: Word32) =
      error "Bend2 checked term sequence exceeds 32-bit wire length"
  | otherwise = putWord32be (fromIntegral len)

putString :: String -> Put
putString value = do
  let bytes = encodeUtf8 (pack value)
  putLength (Strict.length bytes)
  putByteString bytes

getString :: Get String
getString = do
  len <- getWord32be
  size <- checkedLength len
  bytes <- getByteString size
  either (fail . show) (pure . unpack) (decodeUtf8' bytes)

checkedLength :: Word32 -> Get Int
checkedLength value
  | toInteger value > toInteger (maxBound :: Int) =
      fail "Bend2 sequence length exceeds platform Int range"
  | otherwise = pure (fromIntegral value)
