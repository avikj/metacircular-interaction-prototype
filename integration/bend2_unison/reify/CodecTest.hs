module Main where

import Core.FlatCodec
import Core.Reify
import Core.Type
import qualified Data.ByteString.Lazy as L
import qualified Data.Map.Strict as M

assert :: Bool -> String -> IO ()
assert True _ = pure ()
assert False why = error why

fails :: Either String a -> Bool
fails (Left _) = True
fails _ = False

main :: IO ()
main = do
  let atoms =
        [ Bound 0, Bound 2147483647, Free "λ" (-123), Global "math.𝒰"
        , Text "λx. Path(☃)", NatAtom (-17), WordAtom maxBound
        , SignedAtom minBound, DoubleBits 0x8000000000000000
        , DoubleBits 0x7ff8000000000001, CharAtom 'λ'
        , BoolAtom False, BoolAtom True
        ]
      nested = Node "Cubical" atoms
  mapM_ (\item -> assert (decodeFlat (encodeFlat item) == Right item) ("atom roundtrip: " ++ show item)) atoms
  assert (decodeFlat (encodeFlat nested) == Right nested) "nested Flat roundtrip"
  -- The byte sequence is a wire-format golden value: magic B2CF, version 2,
  -- Node tag, 32-bit UTF-8 length, and 32-bit child count.
  let setBytes = L.pack [0x42,0x32,0x43,0x46,2,3,0,0,0,3,0x53,0x65,0x74,0,0,0,0]
  assert (encodeFlat (Node "Set" []) == setBytes) "stable Set encoding changed"
  assert (fails (decodeFlat (L.take 4 setBytes))) "truncated envelope accepted"
  assert (fails (decodeFlat (L.take 5 setBytes))) "truncated payload accepted"
  assert (fails (decodeFlat (L.pack [0x42,0x32,0x43,0x46,3,0]))) "future version accepted"
  assert (fails (decodeFlat (L.pack [0,0x32,0x43,0x46,2,0]))) "bad magic accepted"
  assert (fails (decodeFlat (L.snoc setBytes 0))) "trailing bytes accepted"
  assert (fails (decodeFlat (L.pack [0x42,0x32,0x43,0x46,2,255]))) "unknown tag accepted"
  assert (fails (decodeFlat (L.pack [0x42,0x32,0x43,0x46,2,10,2]))) "invalid boolean accepted"
  assert (fails (decodeFlat (L.pack [0x42,0x32,0x43,0x46,2,4,0,0,0,1,255]))) "invalid UTF-8 accepted"
  assert (fails (decodeFlat (L.pack [0x42,0x32,0x43,0x46,2,3,0,0,0,0,255,255,255,255]))) "corrupt node arity accepted"
  let body = Loc (Span (2,3) (2,14) "path.bend")
               (Pth (PLm "i" (\i -> App (Ref "family") i)) I0 I1)
      hit = HitDecl 0 Set [("point",HitCtor 0 0 (HTy "H" []))]
      book = Book (M.fromList [("H",(False,HTy "H" [],Set)),("path",(True,body,Set))])
                  (M.fromList [("H",hit)])
  case decodeBook (encodeBook book) of
    Left err -> error err
    Right restored ->
      assert (reifyBook restored == reifyBook book) "Book roundtrip changed HIT or cubical term"
  putStrLn "Core.FlatCodec tests passed"
