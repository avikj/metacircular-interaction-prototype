module Main where

import Core.Projection
import Core.Reify (Flat(..), reifyTerm)
import Core.Type
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import qualified Data.ByteString as Bytes

assert :: Bool -> String -> IO ()
assert True _ = pure ()
assert False why = error why

main :: IO ()
main = do
  let identity = Lam "x" (\x -> x)
      identityType = All Nat (Lam "_" (\_ -> Nat))
      pathIdentity = PLm "i" (\i -> i)
      pathType = Pth (Lam "_" (\_ -> Itv)) I0 I1
      located = Loc (Span (3,2) (3,5) "input.bend") Zer
      hit = HitDecl 0 Set [("point",HitCtor 0 0 (HTy "H" []))]
      box = HitDecl 1 (All Set (Lam "A" (\_ -> Set)))
        [("box",HitCtor 1 0 (All Set (Lam "A" (\a ->
          All a (Lam "x" (\_ -> HTy "Box" [a]))))))]
      transport = Coe (Lam "i" (\_ -> Nat)) I0 I1 Zer
      functionType = All Nat (Lam "_" (\_ -> Nat))
      book = Book (M.fromList
        [ ("identity",(False,identity,identityType))
        , ("intervalPath",(False,pathIdentity,pathType))
        , ("located",(False,located,Nat))
        , ("uses",(False,Ref "located",Nat))
        , ("transport",(False,transport,Nat))
        , ("boxed",(False,HCon "Box" "box" [Nat] [Zer] [],HTy "Box" [Nat]))
        , ("boxedFunction",(False,HCon "Box" "box" [functionType] [Lam "n" (\n -> n)] [],
            HTy "Box" [functionType]))
        ]) (M.fromList [("H",hit),("Box",box)])
  case projectSubterm book (DefinitionBody "identity") [1,0] of
    Left _ -> error "failed to project lambda body"
    Right p -> do
      assert (projectionFlat p == Bound 0) "lambda body lost bound reference"
      assert (reifyTerm (projectionType p) == reifyTerm Nat) "lambda body type changed"
      assert (S.null (projectionDependencies p)) "bound variable appeared as dependency"
      assert (projectionConstructors p == ["Lam","Body","atom"]) "constructor path changed"
  case projectSubterm book (DefinitionBody "intervalPath") [1,0] of
    Left _ -> error "failed to project cubical path binder"
    Right p ->
      assert (S.null (projectionDependencies p)) "bound interval appeared as dependency"
  case projectSubterm book (DefinitionBody "located") [1] of
    Left _ -> error "failed to project located term"
    Right p -> do
      assert (reifyTerm (projectionType p) == reifyTerm Nat) "located term type changed"
      assert (case projectionSpan p of Just s -> spanBeg s == (3,2); _ -> False)
             "source span was lost"
  case projectSubterm book (DefinitionBody "uses") [] of
    Left _ -> error "failed to project reference"
    Right p ->
      assert (projectionDependencies p == S.singleton "located") "reference dependency lost"
  assert (case projectSubterm book (DefinitionBody "identity") [50] of Left (InvalidPath _) -> True; _ -> False)
         "bad term path accepted"
  case projectSubterm book (HitConstructorType "H" "point") [] of
    Left _ -> error "failed to project HIT constructor type"
    Right p ->
      assert (reifyTerm (projectionType p) == reifyTerm Set) "HIT constructor type changed"
  case projectSubterm book (DefinitionBody "transport") [3] of
    Left _ -> error "failed to project cubical transport input"
    Right p ->
      assert (reifyTerm (projectionType p) == reifyTerm Nat) "transport input type changed"
  case projectSubterm book (DefinitionBody "boxed") [3,0] of
    Left _ -> error "failed to project HIT constructor field"
    Right p ->
      assert (reifyTerm (projectionType p) == reifyTerm Nat) "HIT field type changed"
  case projectSubterm book (DefinitionBody "boxedFunction") [3,0] of
    Left _ -> error "failed to project check-mode HIT constructor field"
    Right p ->
      assert (reifyTerm (projectionType p) == reifyTerm functionType)
             "HIT lambda field lost dependent constructor type"
  case projectAddressed (Bytes.replicate 64 42) ["H","identity"] book 1 BodyRoot [0,0] of
    Left _ -> error "failed to project addressed component subterm"
    Right p ->
      assert (projectionAddress p == Just (SubtermAddress (Bytes.replicate 64 42) 1 BodyRoot [0,0]))
             "stable subterm address changed"
  let renamed = Book (M.insert "identity" (False,Loc (Span (99,1) (99,2) "renamed.bend")
                         (Lam "renamed" (\x -> x)),identityType) (bookDefs book)) (bookHits book)
  case projectAddressed (Bytes.replicate 64 42) ["H","identity"] renamed 1 BodyRoot [0,0] of
    Left _ -> error "source presentation changed canonical subterm address"
    Right p ->
      assert (projectionAddress p == Just (SubtermAddress (Bytes.replicate 64 42) 1 BodyRoot [0,0]))
             "presentation changed canonical address"
  assert (case sourceSpanAt located [] of
            Right (Just s) -> spanBeg s == (3,2)
            _ -> False) "authored source span failed canonical path lookup"
  assert (case projectAddressed (Bytes.replicate 63 42) ["identity"] book 0 BodyRoot [] of
            Left (InvalidComponentHashLength _) -> True; _ -> False)
         "invalid digest length accepted"
  putStrLn "Core.Projection tests passed"
