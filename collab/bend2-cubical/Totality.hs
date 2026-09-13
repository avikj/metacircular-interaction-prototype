{-./Type.hs-}

-- Conservative totality / productivity classifier.
--
-- For each definition, examine its recursive self-references:
--   Total      no self-reference, or every self-call passes a structurally
--              smaller argument (a variable bound strictly inside an
--              eliminator branch of some parameter).
--   Productive not structurally total, but every self-reference sits under
--              at least one value constructor (Suc/Con/Tup/PLm/Sup), i.e.
--              each observation peels one constructor: guardedness.
--   Unchecked  neither; the definition may loop.
--
-- This is an analysis, not a gate: Bend2's logic is non-total by design,
-- and the tag makes the trust boundary visible per definition.

module Core.Totality where

import qualified Data.Set as S

import Core.Type

data Tot = Total | Productive | Unchecked
  deriving (Eq, Show)

totTag :: Tot -> String
totTag Total      = "\x1b[2m[total]\x1b[0m"
totTag Productive = "\x1b[2m[productive]\x1b[0m"
totTag Unchecked  = "\x1b[33m[unchecked]\x1b[0m"

-- Variables known to be structurally smaller than some parameter are
-- tagged by binding them as Var names in this set (by unique index).
classify :: Name -> Term -> Tot
classify self term =
  let calls = collect 0 S.empty False term in
  case calls of
    [] -> Total
    _  | all fst calls -> Total       -- every call has a smaller arg
       | all snd calls -> Productive  -- every call is constructor-guarded
       | otherwise     -> Unchecked
  where
    -- returns one (smallerArg, guarded) per self-call found
    collect :: Int -> S.Set Int -> Bool -> Term -> [(Bool, Bool)]
    collect d sm g t = case t of
      Ref k | k == self -> [(False, g)]  -- bare self-ref (no args)
      App _ _ ->
        let (fn, xs) = spine t []
        in case fn of
          Ref k | k == self ->
            let smaller = any (argSmall sm) xs
            in [(smaller, g)] ++ concatMap (collect d sm g) xs
          _ -> collect d sm g fn ++ concatMap (collect d sm g) xs
      -- eliminators: branch binders are smaller than the scrutinee
      NatM x z s ->
        collect d sm g x ++ collect d sm g z ++ branch1 d sm g s
      LstM x n c ->
        collect d sm g x ++ collect d sm g n ++ branch2 d sm g c
      SigM x f ->
        collect d sm g x ++ branch2 d sm g f
      EnuM x cs e ->
        collect d sm g x ++ concatMap (collect d sm g . snd) cs ++ collect d sm g e
      BitM x a b -> concatMap (collect d sm g) [x, a, b]
      UniM x f   -> collect d sm g x ++ collect d sm g f
      EqlM x f   -> collect d sm g x ++ collect d sm g f
      EmpM x     -> collect d sm g x
      SupM x l f -> collect d sm g x ++ collect d sm g l ++ branch2 d sm g f
      -- value constructors: everything under them is guarded
      Suc n     -> collect d sm True n
      Con h tl  -> collect d sm True h ++ collect d sm True tl
      Tup a b   -> collect d sm True a ++ collect d sm True b
      Sup l a b -> collect d sm g l ++ collect d sm True a ++ collect d sm True b
      PLm k f   -> collect (d+1) sm True (f (Var k d))
      -- plain binders: keep flags
      Lam k f   -> collect (d+1) sm g (f (Var k d))
      Fix k f   -> collect (d+1) sm g (f (Var k d))
      Let v f   -> collect d sm g v ++ collect d sm g f
      Chk a b   -> collect d sm g a ++ collect d sm g b
      Loc _ a   -> collect d sm g a
      Rwt a b c -> concatMap (collect d sm g) [a, b, c]
      Ind a     -> collect d sm g a
      Frz a     -> collect d sm g a
      Sig a b   -> collect d sm g a ++ collect d sm g b
      All a b   -> collect d sm g a ++ collect d sm g b
      Lst a     -> collect d sm g a
      Eql a b c -> concatMap (collect d sm g) [a, b, c]
      Pth a b c -> concatMap (collect d sm g) [a, b, c]
      PAp a b   -> collect d sm g a ++ collect d sm g b
      INot a    -> collect d sm g a
      IAnd a b  -> collect d sm g a ++ collect d sm g b
      IOr a b   -> collect d sm g a ++ collect d sm g b
      Coe a b c e -> concatMap (collect d sm g) [a, b, c, e]
      HCm a r u0 u1 x -> concatMap (collect d sm g) [a, r, u0, u1, x]
      Ua a b f' g' gf fg -> concatMap (collect d sm g) [a, b, f', g', gf, fg]
      Op2 _ a b -> collect d sm g a ++ collect d sm g b
      Op1 _ a   -> collect d sm g a
      Log a b   -> collect d sm g a ++ collect d sm g b
      Met _ a xs -> collect d sm g a ++ concatMap (collect d sm g) xs
      Sub a     -> collect d sm g a
      _         -> []
      where
        -- one-binder branch whose variable is smaller (Nat pred)
        branch1 dd s0 gg (Lam k f) = collect (dd+1) (S.insert dd s0) gg (f (Var k dd))
        branch1 dd s0 gg other     = collect dd s0 gg other
        -- two-binder branch (List head/tail, Sigma fst/snd): binders smaller
        branch2 dd s0 gg (Lam k f) = case f (Var k dd) of
          Lam k2 f2 -> collect (dd+2) (S.insert dd (S.insert (dd+1) s0)) gg (f2 (Var k2 (dd+1)))
          other     -> collect (dd+1) (S.insert dd s0) gg other
        branch2 dd s0 gg other     = collect dd s0 gg other

    spine (App f x) acc = spine f (x:acc)
    spine (Loc _ t) acc = spine t acc
    spine f acc         = (f, acc)

    argSmall s0 a = case cut a of
      Var _ i -> S.member i s0
      _       -> False
