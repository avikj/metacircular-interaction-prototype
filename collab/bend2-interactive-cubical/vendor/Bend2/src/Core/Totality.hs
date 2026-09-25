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
import qualified Data.Map.Strict as M

import Core.Type

data Tot = Total | Productive | Unchecked
  deriving (Eq, Show)

totTag :: Tot -> String
totTag Total      = "\x1b[2m[total]\x1b[0m"
totTag Productive = "\x1b[2m[productive]\x1b[0m"
totTag Unchecked  = "\x1b[33m[unchecked]\x1b[0m"

-- Variables known to be structurally smaller than some parameter are
-- tagged by binding them as Var names in this set (by unique index).
-- `sm` maps the de Bruijn level of a strictly-smaller variable to the INDEX
-- of the parameter it descends from. A recursive call decreases in column i
-- only when argument i is such a variable whose origin parameter is i itself,
-- so termination needs a single fixed argument position that provably shrinks
-- in every call (a descending column), not merely some smaller value moved
-- into a position it does not own.
classify :: Name -> Term -> Tot
classify self term =
  let (pars, body) = peel 0 0 M.empty term
      calls        = collect (M.size pars) pars M.empty False body
  in case calls of
    [] -> Total
    _  | not (S.null (commonSmall calls)) -> Total
       | all guardedOf calls               -> Productive
       | otherwise                         -> Unchecked
  where
    guardedOf (_, g) = g
    commonSmall :: [(S.Set Int, Bool)] -> S.Set Int
    commonSmall [] = S.empty
    commonSmall ((s,_):rest) = foldl (\acc (s',_) -> S.intersection acc s') s rest

    -- Peel the parameter telescope, recording each parameter's level -> index.
    peel :: Int -> Int -> M.Map Int Int -> Term -> (M.Map Int Int, Term)
    peel d i pars (Lam k f) = peel (d+1) (i+1) (M.insert d i pars) (f (Var k d))
    peel d i pars (Loc _ t) = peel d i pars t
    peel _ _ pars t         = (pars, t)

    -- origin parameter index of a term, if it is a variable that is a
    -- parameter or a strictly-smaller descendant of one
    originOf :: M.Map Int Int -> M.Map Int Int -> Term -> Maybe Int
    originOf pars sm a = case cut a of
      Var _ i -> case M.lookup i sm of
                   Just j  -> Just j
                   Nothing -> M.lookup i pars
      _       -> Nothing

    -- strictly-smaller descendant only (used at the recursive call)
    strictOrigin :: M.Map Int Int -> Term -> Maybe Int
    strictOrigin sm a = case cut a of { Var _ i -> M.lookup i sm ; _ -> Nothing }

    collect :: Int -> M.Map Int Int -> M.Map Int Int -> Bool -> Term -> [(S.Set Int, Bool)]
    collect d pars sm g t = case t of
      Ref k | k == self -> [(S.empty, g)]
      App _ _ ->
        let (fn, xs) = spine t []
        in case fn of
          Ref k | k == self ->
            let cols = S.fromList [ i | (i,x) <- zip [0..] xs, strictOrigin sm x == Just i ]
            in (cols, g) : concatMap (collect d pars sm g) xs
          _ -> collect d pars sm g fn ++ concatMap (collect d pars sm g) xs
      -- eliminators: the branch binders descend from the scrutinee's origin
      NatM x z s -> collect d pars sm g x ++ collect d pars sm g z
                 ++ branch1 (originOf pars sm x) d s
      LstM x n c -> collect d pars sm g x ++ collect d pars sm g n
                 ++ branch2 (originOf pars sm x) d c
      -- A Σ/record match yields NO structural descent: every declared `type`
      -- admits infinite inhabitants (corecursive definitions are typed by
      -- Fix and unfolded lazily), so a recursion consuming a record's field
      -- can diverge (loop(s) = match s { Cons h t -> loop t } on ones).
      -- Records are coinductive by default in this semantics; termination
      -- comes from a Nat/List fuel or from productivity, never from the
      -- record itself.
      SigM x f   -> collect d pars sm g x ++ branch2 Nothing d f
      EnuM x cs e -> collect d pars sm g x
                  ++ concatMap (collect d pars sm g . snd) cs ++ collect d pars sm g e
      BitM x a b -> concatMap (collect d pars sm g) [x, a, b]
      UniM x f   -> collect d pars sm g x ++ collect d pars sm g f
      EqlM x f   -> collect d pars sm g x ++ collect d pars sm g f
      EmpM x     -> collect d pars sm g x
      SupM x l f -> collect d pars sm g x ++ collect d pars sm g l
                 ++ branch2 (originOf pars sm x) d f
      Suc n     -> collect d pars sm True n
      Con h tl  -> collect d pars sm True h ++ collect d pars sm True tl
      Tup a b   -> collect d pars sm True a ++ collect d pars sm True b
      Sup l a b -> collect d pars sm g l ++ collect d pars sm True a ++ collect d pars sm True b
      PLm k f   -> collect (d+1) pars sm True (f (Var k d))
      Lam k f   -> collect (d+1) pars sm g (f (Var k d))
      Fix k f   -> collect (d+1) pars sm g (f (Var k d))
      Let v f   -> collect d pars sm g v ++ collect d pars sm g f
      Chk a b   -> collect d pars sm g a ++ collect d pars sm g b
      Loc _ a   -> collect d pars sm g a
      Rwt a b c -> concatMap (collect d pars sm g) [a, b, c]
      Ind a     -> collect d pars sm g a
      Frz a     -> collect d pars sm g a
      -- Type formers guard exactly as value constructors do: a declared
      -- `type` whose field mentions itself (tail: Stream) is the productive
      -- fixed point of its type operator — the record shape, read by
      -- observation, like the corecursive values that inhabit it. Σ guards
      -- both components (positive), Π guards only its codomain (the domain
      -- is a negative position and stays as it was).
      Sig a b   -> collect d pars sm True a ++ collect d pars sm True b
      All a b   -> collect d pars sm g a ++ collect d pars sm True b
      Lst a     -> collect d pars sm g a
      Eql a b c -> concatMap (collect d pars sm g) [a, b, c]
      Pth a b c -> concatMap (collect d pars sm g) [a, b, c]
      PAp a b   -> collect d pars sm g a ++ collect d pars sm g b
      INot a    -> collect d pars sm g a
      IAnd a b  -> collect d pars sm g a ++ collect d pars sm g b
      IOr a b   -> collect d pars sm g a ++ collect d pars sm g b
      Coe a b c e -> concatMap (collect d pars sm g) [a, b, c, e]
      HCm a fs x -> concatMap (collect d pars sm g) (a : x : concatMap (\(p,u) -> [p,u]) fs)
      Glu a fs -> concatMap (collect d pars sm g) (a : concatMap (\(p,t,e) -> [p,t,e]) fs)
      GlB a fs x -> concatMap (collect d pars sm g) (a : x : concatMap (\(p,t) -> [p,t]) fs)
      UnG gg -> collect d pars sm g gg
      Quo a r -> concatMap (collect d pars sm g) [a, r]
      QCl a -> collect d pars sm g a
      QEq a b r -> concatMap (collect d pars sm g) [a, b, r]
      QSq -> []
      QRec x s f r -> concatMap (collect d pars sm g) [x, s, f, r]
      Ua a b f' g' gf fg -> concatMap (collect d pars sm g) [a, b, f', g', gf, fg]
      Op2 _ a b -> collect d pars sm g a ++ collect d pars sm g b
      Op1 _ a   -> collect d pars sm g a
      Log a b   -> collect d pars sm g a ++ collect d pars sm g b
      Met _ a xs -> collect d pars sm g a ++ concatMap (collect d pars sm g) xs
      Sub a     -> collect d pars sm g a
      _         -> []
      where
        ins org lvl s0 = case org of { Just j -> M.insert lvl j s0 ; Nothing -> s0 }
        branch1 org dd (Lam k f) = collect (dd+1) pars (ins org dd sm) g (f (Var k dd))
        branch1 _   dd other     = collect dd pars sm g other
        branch2 org dd (Lam k f) = case f (Var k dd) of
          Lam k2 f2 -> collect (dd+2) pars (ins org (dd+1) (ins org dd sm)) g (f2 (Var k2 (dd+1)))
          other     -> collect (dd+1) pars (ins org dd sm) g other
        branch2 _   dd other     = collect dd pars sm g other

    spine (App f x) acc = spine f (x:acc)
    spine (Loc _ t) acc = spine t acc
    spine f acc         = (f, acc)
