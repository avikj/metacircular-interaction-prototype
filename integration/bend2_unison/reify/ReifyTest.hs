module Main where

import Core.Reify
import Core.Type
import Data.List (isInfixOf)
import qualified Data.Map.Strict as M

assert :: Bool -> String -> IO ()
assert True _ = pure ()
assert False msg = error msg

main :: IO ()
main = do
  let termX = Lam "x" (\x -> Lam "y" (\y -> App x y))
      termA = Lam "a" (\a -> Lam "b" (\b -> App a b))
      wanted = Node "Lam" [Node "Body" [Node "Lam" [Node "Body" [Node "App" [Bound 1, Bound 0]]]]]
  assert (alphaTerm termX == wanted) "nested binders must use de Bruijn indices"
  assert (alphaTerm termX == alphaTerm termA) "alpha-renaming changed structural key"
  assert (reifyTerm termX /= reifyTerm termA) "presentation binder names were lost"
  case reflectTerm (reifyTerm termX) of
    Left err -> error err
    Right restored ->
      assert (reifyTerm restored == reifyTerm termX) "HOAS capture changed on reflection"
  assert (case reflectTerm (Node "Lam" [Text "x",Node "Body" [Bound 1]]) of Left _ -> True; Right _ -> False)
         "invalid de Bruijn reference was accepted"
  let located = Loc (Span (1,2) (1,5) "λx.x") termX
  assert (alphaTerm located == alphaTerm termX) "source span changed structural key"
  let cube = Pth (PLm "i" (\i -> App (Ref "Family") i)) (Ref "left") (Ref "right")
      hit = HitDecl 1 (All Set (Lam "A" (\_ -> Set)))
              [("base", HitCtor 0 0 (HTy "Circle" [])),
               ("loop", HitCtor 0 1 (Pth (Lam "i" (\_ -> HTy "Circle" [])) CBase CBase))]
      repr = reifyTerm cube
  assert ("PLm" `isInfixOf` show repr) "cubical binder was omitted"
  assert ("loop" `isInfixOf` show (reifyHit hit)) "HIT constructor was omitted"
  case reflectHit (reifyHit hit) of
    Left err -> error err
    Right restored ->
      assert (reifyHit restored == reifyHit hit) "HIT declaration changed on reflection"
  let book = Book (M.fromList [("Circle",(False,HTy "Circle" [],Set))]) (M.fromList [("Circle",hit)])
  case reflectBook (reifyBook book) of
    Left err -> error err
    Right restored ->
      assert (reifyBook restored == reifyBook book) "same-name definition/HIT changed on reflection"
  case reflectTerm repr of
    Left err -> error err
    Right restored ->
      assert (reifyTerm restored == repr) "cubical term changed on reflection"
  assert ((read (show repr) :: Flat) == repr) "flat representation failed textual roundtrip"
  assert (reifyTerm (Val (F64_V (-0.0))) /= reifyTerm (Val (F64_V 0.0))) "float bits collapsed"
  putStrLn "Core.Reify tests passed"
