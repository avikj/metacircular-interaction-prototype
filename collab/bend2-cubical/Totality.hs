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
import qualified Data.Map as M

import Core.Type

data Tot = Total | Productive | Unchecked
  deriving (Eq, Show)

totTag :: Tot -> String
totTag Total      = "\x1b[2m[total]\x1b[0m"
totTag Productive = "\x1b[2m[productive]\x1b[0m"
totTag Unchecked  = "\x1b[33m[unchecked]\x1b[0m"

-- Variables known to be structurally smaller than some parameter are
-- tagged by binding them as Var names in this set (by unique index).
-- Soundness note.  The earlier version tagged a self-call structurally
-- decreasing when ANY argument was a branch-bound variable, with no regard
-- to WHICH parameter it descended from or whether a consistent position
-- decreases across the recursion.  That is unsound: `loop(n,m){ 0->0 ;
-- 1+p -> loop(n,p) }` has the branch variable p among its args and so was
-- reported [total], yet it diverges (it recurses on n, unchanged).
--
-- The criterion here is the standard sound one for a single function: there
-- must be a fixed argument POSITION i such that EVERY self-call passes, in
-- position i, a variable strictly smaller than parameter i (obtained by
-- destructuring parameter i, possibly through a chain of eliminations).
-- `anc` records, for each strictly-smaller variable, the parameter position
-- it descends from; a call decreases at i iff its i-th argument descends
-- from parameter i; Total requires the intersection of the decreasing
-- positions over all calls to be non-empty.  Conservative: it may under-tag
-- (→ [productive]/[unchecked]), never over-tag.
classify :: Name -> Term -> Tot
classify self term =
  let (paramDepths, body) = peel 0 term
      params = M.fromList (zip paramDepths [0 ..])   -- binder depth -> position
      calls  = collect params (length paramDepths) M.empty False body
  in case calls of
    [] -> Total
    _  | not (S.null (foldr1 S.intersection (map fst calls))) -> Total
       | all snd calls                                        -> Productive
       | otherwise                                            -> Unchecked
  where
    -- peel the leading parameter telescope, recording each binder's depth
    peel :: Int -> Term -> ([Int], Term)
    peel d (Loc _ t) = peel d t
    peel d (Chk a _) = peel d a
    peel d (Lam k f) = let (ps, b) = peel (d+1) (f (Var k d)) in (d : ps, b)
    peel _ t         = ([], t)

    -- per self-call: (positions that strictly decrease, guarded-under-ctor)
    collect :: M.Map Int Int -> Int -> M.Map Int Int -> Bool -> Term -> [(S.Set Int, Bool)]
    collect params d anc g t = case t of
      Ref k | k == self -> [(S.empty, g)]
      App _ _ ->
        let (fn, xs) = spine t []
        in case fn of
          Ref k | k == self ->
            let dec = S.fromList [ i | (i, x) <- zip [0 ..] xs, descPos x == Just i ]
            in (dec, g) : concatMap (collect params d anc g) xs
          _ -> collect params d anc g fn ++ concatMap (collect params d anc g) xs
      NatM x z s  -> collect params d anc g x ++ collect params d anc g z ++ branch1 (ancOf x) s
      LstM x n c  -> collect params d anc g x ++ collect params d anc g n ++ branch2 (ancOf x) c
      SigM x f    -> collect params d anc g x ++ branch2 (ancOf x) f
      EnuM x cs e -> collect params d anc g x ++ concatMap (collect params d anc g . snd) cs ++ collect params d anc g e
      BitM x a b  -> concatMap (collect params d anc g) [x, a, b]
      UniM x f    -> collect params d anc g x ++ collect params d anc g f
      EqlM x f    -> collect params d anc g x ++ collect params d anc g f
      EmpM x      -> collect params d anc g x
      SupM x l f  -> collect params d anc g x ++ collect params d anc g l ++ branch2 (ancOf x) f
      Suc n       -> collect params d anc True n
      Con h tl    -> collect params d anc True h ++ collect params d anc True tl
      Tup a b     -> collect params d anc True a ++ collect params d anc True b
      Sup l a b   -> collect params d anc g l ++ collect params d anc True a ++ collect params d anc True b
      PLm k f     -> collect params (d+1) anc True (f (Var k d))
      Lam k f     -> collect params (d+1) anc g (f (Var k d))
      Fix k f     -> collect params (d+1) anc g (f (Var k d))
      Let v f     -> collect params d anc g v ++ collect params d anc g f
      Chk a b     -> collect params d anc g a ++ collect params d anc g b
      Loc _ a     -> collect params d anc g a
      Rwt a b c   -> concatMap (collect params d anc g) [a, b, c]
      Ind a       -> collect params d anc g a
      Frz a       -> collect params d anc g a
      Sig a b     -> collect params d anc g a ++ collect params d anc g b
      All a b     -> collect params d anc g a ++ collect params d anc g b
      Lst a       -> collect params d anc g a
      Eql a b c   -> concatMap (collect params d anc g) [a, b, c]
      Pth a b c   -> concatMap (collect params d anc g) [a, b, c]
      PAp a b     -> collect params d anc g a ++ collect params d anc g b
      INot a      -> collect params d anc g a
      IAnd a b    -> collect params d anc g a ++ collect params d anc g b
      IOr a b     -> collect params d anc g a ++ collect params d anc g b
      Coe a b c e -> concatMap (collect params d anc g) [a, b, c, e]
      HCm a r u0 u1 x -> concatMap (collect params d anc g) [a, r, u0, u1, x]
      Ua a b f' g' gf fg -> concatMap (collect params d anc g) [a, b, f', g', gf, fg]
      Op2 _ a b   -> collect params d anc g a ++ collect params d anc g b
      Op1 _ a     -> collect params d anc g a
      Log a b     -> collect params d anc g a ++ collect params d anc g b
      Met _ a xs  -> collect params d anc g a ++ concatMap (collect params d anc g) xs
      Sub a       -> collect params d anc g a
      _           -> []
      where
        -- which parameter position (if any) the scrutinee descends from
        ancOf s = case cut s of
          Var _ i -> case M.lookup i params of
                       Just p  -> Just p
                       Nothing -> M.lookup i anc
          _       -> Nothing
        -- a call arg strictly decreases at position i iff it is a variable
        -- that descends (strictly) from parameter i
        descPos x = case cut x of
          Var _ i -> M.lookup i anc
          _       -> Nothing
        -- one-binder branch (Nat pred): binder is smaller than scrutinee,
        -- inheriting the scrutinee's ancestor parameter
        branch1 aj (Lam k f) = collect params (d+1) (ins d aj anc) g (f (Var k d))
        branch1 _  other     = collect params d anc g other
        -- two-binder branch (List head/tail, Sigma fst/snd)
        branch2 aj (Lam k f) = case f (Var k d) of
          Lam k2 f2 -> collect params (d+2) (ins (d+1) aj (ins d aj anc)) g (f2 (Var k2 (d+1)))
          other     -> collect params (d+1) (ins d aj anc) g other
        branch2 _  other     = collect params d anc g other
        ins depth (Just p) m = M.insert depth p m
        ins _     Nothing  m = m

    spine (App f x) acc = spine f (x:acc)
    spine (Loc _ t) acc = spine t acc
    spine f acc         = (f, acc)
