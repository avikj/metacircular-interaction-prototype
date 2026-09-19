module Main where

import Core.CanonicalComponent
import Core.Check (check)
import Core.Reify (reifyBook)
import Core.Type
import qualified Data.ByteString as Bytes
import qualified Data.ByteString.Lazy as Lazy
import qualified Data.Map.Strict as Map

assert :: Bool -> String -> IO ()
assert True _ = pure ()
assert False why = error why

checked :: Either String a -> a
checked (Right value) = value
checked (Left why) = error why

main :: IO ()
main = do
  let externalDigest = Bytes.replicate 64 23
      first = Book
        (Map.fromList [("alpha",(False,Ref "prior",Nat))])
        Map.empty
      second = Book
        (Map.fromList [("renamed",(False,Ref "renamedPrior",Nat))])
        Map.empty
      oldRefs = Map.singleton "prior" (externalDigest,2)
      newRefs = Map.singleton "renamedPrior" (externalDigest,2)
      firstBytes = checked (encodeCanonicalComponent ["alpha"] oldRefs first first)
      secondBytes = checked (encodeCanonicalComponent ["renamed"] newRefs second second)
  assert (firstBytes == secondBytes) "local/external rename changed canonical component bytes"
  let firstNames = namesForComponent ["alpha"] oldRefs first
  assert (reifyBook (checked (decodeCanonicalComponent firstNames firstBytes)) == reifyBook first)
         "external reference failed executable reconstruction"

  let mkHit name ctor =
        let hit = HitDecl 0 Set [(ctor,HitCtor 0 0 (HTy name []))]
        in Book
          (Map.fromList [(name,(False,HTy name [],Set)),
                         ("make",(False,HCon name ctor [] [] [],HTy name []))])
          (Map.singleton name hit)
      oldHit = mkHit "Circle" "base"
      newHit = mkHit "LoopType" "origin"
      oldHitBytes = checked (encodeCanonicalComponent ["Circle","make"] Map.empty oldHit oldHit)
      newHitBytes = checked (encodeCanonicalComponent ["LoopType","make"] Map.empty newHit newHit)
  assert (oldHitBytes == newHitBytes) "HIT/constructor rename changed canonical bytes"
  let hitZ = mkHit "z" "base"
      hitA = mkHit "a" "origin"
      (_,hitZBytes) = checked (canonicalOrder ["make","z"] Map.empty hitZ hitZ)
      (_,hitABytes) = checked (canonicalOrder ["a","make"] Map.empty hitA hitA)
  assert (hitZBytes == hitABytes) "HIT rename crossing lexical slot order changed bytes"
  assert (reifyBook (checked (decodeCanonicalComponent
            (namesForComponent ["LoopType","make"] Map.empty newHit) newHitBytes))
          == reifyBook newHit) "HIT/constructor names failed reconstruction"
  let oldCycle = Book (Map.fromList
        [("a",(False,Ref "b",Nat)),("b",(False,Ref "a",Nat))]) Map.empty
      renamedCycle = Book (Map.fromList
        [("z",(False,Ref "b",Nat)),("b",(False,Ref "z",Nat))]) Map.empty
      (_,oldCycleBytes) = checked (canonicalOrder ["a","b"] Map.empty oldCycle oldCycle)
      (_,newCycleBytes) = checked (canonicalOrder ["b","z"] Map.empty renamedCycle renamedCycle)
  assert (oldCycleBytes == newCycleBytes) "recursive SCC rename changed canonical bytes"
  let oldPair = Book (Map.fromList
        [("a",(False,Zer,Nat)),("b",(False,Ref "a",Nat))]) Map.empty
      newPair = Book (Map.fromList
        [("z",(False,Zer,Nat)),("b",(False,Ref "z",Nat))]) Map.empty
      (_,oldPairBytes) = checked (canonicalOrder ["a","b"] Map.empty oldPair oldPair)
      (_,newPairBytes) = checked (canonicalOrder ["b","z"] Map.empty newPair newPair)
  assert (oldPairBytes == newPairBytes) "distinct-shape member rename changed slot ordering"
  let colliding = Book
        (Map.singleton "eliminate" (False,HRec [("same",Zer)] (Ref "x"),Nat))
        (Map.fromList
          [("H1",HitDecl 0 Set [("same",HitCtor 0 0 (HTy "H1" []))])
          ,("H2",HitDecl 0 Set [("same",HitCtor 0 0 (HTy "H2" []))])])
      collidingMember = Book (bookDefs colliding) Map.empty
  assert (case encodeCanonicalComponent ["eliminate"] Map.empty colliding collidingMember of
            Left _ -> True; Right _ -> False)
         "ambiguous constructor name was silently retargeted"
  let many = Book (Map.fromList
        [(show i,(False,Zer,Nat)) | i <- [1..9 :: Int]]) Map.empty
  assert (case canonicalOrder (Map.keys (bookDefs many)) Map.empty many many of
            Right (names,_) -> length names == 9
            Left _ -> False) "large tied component failed deterministic fallback"
  assert (case decodeCanonicalComponent (namesForComponent ["Circle","make"] Map.empty oldHit)
               (Lazy.fromStrict (Bytes.pack [0])) of Left _ -> True; Right _ -> False)
         "corrupt canonical payload accepted"
  let digestA = Bytes.replicate 64 31
      digestB = Bytes.replicate 64 32
      source = Book (Map.singleton "origin" (False,Zer,Nat)) Map.empty
      consumer = Book (Map.singleton "consumer" (False,Ref "origin",Nat)) Map.empty
      full = Book (Map.union (bookDefs consumer) (bookDefs source)) Map.empty
      sourceBytes = checked (encodeCanonicalComponent ["origin"] Map.empty full source)
      consumerBytes = checked (encodeCanonicalComponent ["consumer"]
        (Map.singleton "origin" (digestA,0)) full consumer)
      Book sourceDefs _ = checked (decodeCanonicalComponentSynthetic digestA sourceBytes)
      Book consumerDefs _ = checked (decodeCanonicalComponentSynthetic digestB consumerBytes)
      linked = Book (Map.union consumerDefs sourceDefs) Map.empty
  assert (parseSyntheticMemberName (syntheticMemberName digestA 7) == Just (digestA,7))
         "synthetic member reference failed roundtrip"
  assert (parseSyntheticConstructorName (syntheticConstructorName digestA 7 3) == Just (digestA,7,3))
         "synthetic HIT constructor reference failed roundtrip"
  assert (case Map.lookup (syntheticMemberName digestB 0) consumerDefs of
            Just (_,term,typ) -> case check 0 noSpan linked (Ctx []) term typ of
              Done () -> True
              Fail _ -> False
            Nothing -> False) "synthetic cross-component reference failed typechecking"
  let hitSource = Book (Map.singleton "Circle" (False,HTy "Circle" [],Set))
        (Map.singleton "Circle" (HitDecl 0 Set
          [("base",HitCtor 0 0 (HTy "Circle" []))]))
      hitUse = Book (Map.singleton "use" (False,HCon "Circle" "base" [] [] [],HTy "Circle" []))
        Map.empty
      hitFull = Book (Map.union (bookDefs hitUse) (bookDefs hitSource))
                     (bookHits hitSource)
      hitBytes = checked (encodeCanonicalComponent ["Circle"] Map.empty hitFull hitSource)
      useBytes = checked (encodeCanonicalComponent ["use"]
        (Map.singleton "Circle" (digestA,0)) hitFull hitUse)
      Book decodedHitDefs decodedHits = checked (decodeCanonicalComponentSynthetic digestA hitBytes)
      Book decodedUseDefs _ = checked (decodeCanonicalComponentSynthetic digestB useBytes)
      linkedHit = Book (Map.union decodedUseDefs decodedHitDefs) decodedHits
  assert (case Map.lookup (syntheticMemberName digestB 0) decodedUseDefs of
            Just (_,term,typ) -> case check 0 noSpan linkedHit (Ctx []) term typ of
              Done () -> True
              Fail _ -> False
            Nothing -> False) "synthetic external HIT constructor failed typechecking"
  let recursor = Book (Map.singleton "recursor"
        (False,HRec [("base",Zer)] (HCon "Circle" "base" [] [] []),Nat)) Map.empty
      recursorFull = Book (Map.union (bookDefs recursor) (bookDefs hitSource))
                          (bookHits hitSource)
      recursorBytes = checked (encodeCanonicalComponent ["recursor"]
        (Map.singleton "Circle" (digestA,0)) recursorFull recursor)
      Book recursorDefs _ = checked (decodeCanonicalComponentSynthetic digestB recursorBytes)
  assert (case Map.lookup (syntheticMemberName digestB 0) recursorDefs of
            Just (_,HRec [(ctorName,_)] _,_) ->
              ctorName == syntheticConstructorName digestA 0 0
            _ -> False) "external HIT branch name failed synthetic reconstruction"
  putStrLn "Core.CanonicalComponent tests passed"
