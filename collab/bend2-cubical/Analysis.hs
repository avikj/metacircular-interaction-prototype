{-./Type.hs-}

-- Per-definition mathematical analysis: the checker as an instrument,
-- not a gate. For each definition we report:
--
--   totality      total / productive / unchecked (Core.Totality)
--   shape         theorem (goal is an equality/path), family (ends in Set),
--                 or program
--   proof cost    for theorems: definitional (refl/path-lambda-constant --
--                 the kernel pays only normalization), or the rewrite and
--                 transport cell counts (Rwt/EqlM/coe/hcomp/ua occurrences:
--                 exactly the non-contractible-fibre cost, measured)
--   unused args   hypotheses the body never consumes (erasable)
--   sup labels    superposition labels the definition touches
--   universe      how many Set-typed binders the type takes (Set:Set load)

module Core.Analysis where

import Data.List (intercalate, nub)

import Core.Type
import Core.Totality

data Report = Report
  { rTot     :: Tot
  , rShape   :: String
  , rCost    :: String
  , rUnused  :: [Name]
  , rLabels  :: [String]
  , rSetArgs :: Int
  }

reportLine :: Report -> String
reportLine r = intercalate "  " (filter (not . null) parts)
  where
    parts =
      [ totTag (rTot r)
      , "\x1b[2m" ++ rShape r ++ "\x1b[0m"
      , rCost r
      , if null (rUnused r) then "" else "\x1b[33munused: " ++ intercalate "," (rUnused r) ++ "\x1b[0m"
      , if null (rLabels r) then "" else "\x1b[2msup: " ++ intercalate "," (rLabels r) ++ "\x1b[0m"
      , if rSetArgs r == 0 then "" else "\x1b[2mSet-binders: " ++ show (rSetArgs r) ++ "\x1b[0m"
      ]

analyze :: Name -> Term -> Term -> Report
analyze name term typ = Report
  { rTot     = classify name term
  , rShape   = shape (skipPis typ)
  , rCost    = cost
  , rUnused  = unusedArgs term typ
  , rLabels  = nub (labels term)
  , rSetArgs = setBinders typ
  }
  where
    skipPis (All _ (Lam k f)) = skipPis (f (Var k 0))
    skipPis (All _ b)         = b
    skipPis (Loc _ t)         = skipPis t
    skipPis t                 = t

    shape t = case t of
      Eql _ _ _ -> "theorem(=)"
      Pth _ _ _ -> "theorem(path)"
      Set       -> "family"
      _         -> "program"

    isThm = case shape (skipPis typ) of
      't':'h':_ -> True
      _         -> False

    cost
      | not isThm = ""
      | definitional (skipLams term) =
          "\x1b[32mdefinitional\x1b[0m"
      | otherwise =
          let (rw, cells) = costs term
          in "\x1b[36mrewrites: " ++ show rw ++ ", cells: " ++ show cells ++ "\x1b[0m"

    skipLams (Lam k f) = skipLams (f (Var k 0))
    skipLams (Loc _ t) = skipLams t
    skipLams t         = t

    -- a proof is definitional when its body is refl / a path lambda whose
    -- body has no proof machinery: the kernel checks it by computation
    definitional t = case t of
      Rfl     -> True
      PLm k f -> noCells (f (Var k 0))
      _       -> False

    noCells t = let (rw, cells) = costs t in rw == 0 && cells == 0

    -- rewrite steps and transport cells in the proof term
    costs :: Term -> (Int, Int)
    costs t = go t where
      go x = case x of
        Rwt a b c   -> add3 (1,0) a b c
        EqlM a b    -> add2 (1,0) a b
        Coe a b c e -> add4 (0,1) a b c e
        HCm a r u0 u1 v -> add5 (0,1) a r u0 u1 v
        Ua a b f g gf fg -> plus (0,1) (foldr plus (0,0) (map go [a,b,f,g,gf,fg]))
        Lam k f     -> go (f (Var k 0))
        PLm k f     -> go (f (Var k 0))
        Fix k f     -> go (f (Var k 0))
        App a b     -> add2 (0,0) a b
        Tup a b     -> add2 (0,0) a b
        Con a b     -> add2 (0,0) a b
        Suc a       -> go a
        Let a b     -> add2 (0,0) a b
        Chk a b     -> add2 (0,0) a b
        Loc _ a     -> go a
        Ind a       -> go a
        Frz a       -> go a
        Sig a b     -> add2 (0,0) a b
        All a b     -> add2 (0,0) a b
        Lst a       -> go a
        Eql a b c   -> add3 (0,0) a b c
        Pth a b c   -> add3 (0,0) a b c
        PAp a b     -> add2 (0,0) a b
        INot a      -> go a
        IAnd a b    -> add2 (0,0) a b
        IOr a b     -> add2 (0,0) a b
        Sup a b c   -> add3 (0,0) a b c
        SupM a b c  -> add3 (0,0) a b c
        Frk a b c   -> add3 (0,0) a b c
        NatM a b c  -> add3 (0,0) a b c
        LstM a b c  -> add3 (0,0) a b c
        BitM a b c  -> add3 (0,0) a b c
        UniM a b    -> add2 (0,0) a b
        EmpM a      -> go a
        SigM a b    -> add2 (0,0) a b
        EnuM a cs e -> foldr plus (plus (go a) (go e)) (map (go . snd) cs)
        Op2 _ a b   -> add2 (0,0) a b
        Op1 _ a     -> go a
        Log a b     -> add2 (0,0) a b
        Sub a       -> go a
        _           -> (0,0)
      plus (a,b) (c,d) = (a+c, b+d)
      add2 k a b     = plus k (plus (go a) (go b))
      add3 k a b c   = plus (add2 k a b) (go c)
      add4 k a b c e = plus (add3 k a b c) (go e)
      add5 k a b c e f' = plus (add4 k a b c e) (go f')

    labels :: Term -> [String]
    labels t = go t where
      go x = case x of
        Sup l a b  -> show l : go a ++ go b
        SupM a l f -> go a ++ (show l : go f)
        Frk l a b  -> show l : go a ++ go b
        Lam k f    -> go (f (Var k 0))
        PLm k f    -> go (f (Var k 0))
        Fix k f    -> go (f (Var k 0))
        App a b    -> go a ++ go b
        Tup a b    -> go a ++ go b
        Let a b    -> go a ++ go b
        Loc _ a    -> go a
        Coe a b c e -> concatMap go [a,b,c,e]
        HCm a r u0 u1 v -> concatMap go [a,r,u0,u1,v]
        PAp a b    -> go a ++ go b
        Sig a b    -> go a ++ go b
        All a b    -> go a ++ go b
        _          -> []

    -- unused parameters: walk the Lam telescope, check occurrence
    unusedArgs :: Term -> Term -> [Name]
    unusedArgs tm ty = go 0 tm where
      go d (Lam k f)
        | k /= "_" && not (occursV d (f (Var k d))) = k : go (d+1) (f (Var k d))
        | otherwise = go (d+1) (f (Var k d))
      go d (Loc _ t2) = go d t2
      go _ _ = []

    occursV :: Int -> Term -> Bool
    occursV i t = go t where
      go x = case x of
        Var _ j    -> j == i
        Lam k f    -> go (f (Var k (-2)))
        PLm k f    -> go (f (Var k (-2)))
        Fix k f    -> go (f (Var k (-2)))
        App a b    -> go a || go b
        Tup a b    -> go a || go b
        Con a b    -> go a || go b
        Suc a      -> go a
        Let a b    -> go a || go b
        Chk a b    -> go a || go b
        Loc _ a    -> go a
        Ind a      -> go a
        Frz a      -> go a
        Sig a b    -> go a || go b
        All a b    -> go a || go b
        Lst a      -> go a
        Eql a b c  -> go a || go b || go c
        Pth a b c  -> go a || go b || go c
        PAp a b    -> go a || go b
        INot a     -> go a
        IAnd a b   -> go a || go b
        IOr a b    -> go a || go b
        Coe a b c e -> go a || go b || go c || go e
        HCm a r u0 u1 v -> go a || go r || go u0 || go u1 || go v
        Ua a b f g gf fg -> any go [a,b,f,g,gf,fg]
        Sup a b c  -> go a || go b || go c
        SupM a b c -> go a || go b || go c
        Frk a b c  -> go a || go b || go c
        NatM a b c -> go a || go b || go c
        LstM a b c -> go a || go b || go c
        BitM a b c -> go a || go b || go c
        UniM a b   -> go a || go b
        EmpM a     -> go a
        SigM a b   -> go a || go b
        EnuM a cs e -> go a || any (go . snd) cs || go e
        Rwt a b c  -> go a || go b || go c
        EqlM a b   -> go a || go b
        Op2 _ a b  -> go a || go b
        Op1 _ a    -> go a
        Log a b    -> go a || go b
        Sub a      -> go a
        _          -> False

    setBinders :: Term -> Int
    setBinders t = go t where
      go (All a (Lam k f)) = (if isSet a then 1 else 0) + go (f (Var k 0))
      go (All a b)         = (if isSet a then 1 else 0) + go b
      go (Loc _ x)         = go x
      go _                 = 0
      isSet (Loc _ x) = isSet x
      isSet Set       = True
      isSet _         = False
