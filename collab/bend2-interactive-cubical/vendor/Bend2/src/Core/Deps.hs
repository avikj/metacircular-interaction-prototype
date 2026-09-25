{-./Type.hs-}

module Core.Deps where 

import qualified Data.Set as S
import qualified Data.Map as M

import Core.Type

getDeps :: Term -> S.Set Name
getDeps = collectDeps S.empty

getBookDeps :: Book -> S.Set Name
getBookDeps (Book defs hits) = S.unions (map getDefnDeps (M.toList defs) ++ map hitDeps (M.elems hits)) where
  hitDeps h = S.unions (getDeps (hitType h) : [ getDeps (ctorType k) | (_, k) <- hitCtors h ])
  getDefnDeps :: (Name, Defn) -> S.Set Name
  getDefnDeps (name, (_, term, typ)) = S.union (getDeps term) (getDeps typ)

-- -- | Collects all external references from a term, handling variable binding.
-- -- This is a specialized version of `collectRefs` that also handles `Pat` constructors
-- -- by treating the head of a pattern application as a reference.
collectDeps :: S.Set Name -> Term -> S.Set Name
collectDeps bound term = case term of
  Var k _     -> if k `S.member` bound then S.empty else S.singleton k
  Ref k       -> S.singleton k
  Sub t       -> collectDeps bound t
  Fix k f     -> collectDeps (S.insert k bound) (f (Var k 0))
  Let v f     -> S.union (collectDeps bound v) (collectDeps bound f)
  Set         -> S.empty
  Chk x t     -> S.union (collectDeps bound x) (collectDeps bound t)
  Emp         -> S.empty
  EmpM x      -> collectDeps bound x
  Uni         -> S.empty
  One         -> S.empty
  UniM x f    -> S.union (collectDeps bound x) (collectDeps bound f)
  Bit         -> S.empty
  Bt0         -> S.empty
  Bt1         -> S.empty
  BitM x f t  -> S.unions [collectDeps bound x, collectDeps bound f, collectDeps bound t]
  Nat         -> S.empty
  Zer         -> S.empty
  Suc n       -> collectDeps bound n
  NatM x z s  -> S.unions [collectDeps bound x, collectDeps bound z, collectDeps bound s]
  Lst t       -> collectDeps bound t
  Nil         -> S.empty
  Con h t     -> S.union (collectDeps bound h) (collectDeps bound t)
  LstM x n c  -> S.unions [collectDeps bound x, collectDeps bound n, collectDeps bound c]
  Enu _       -> S.empty
  Sym _       -> S.empty
  EnuM x cs d -> S.unions [collectDeps bound x, S.unions (map (collectDeps bound . snd) cs), collectDeps bound d]
  Num _       -> S.empty
  Val _       -> S.empty
  Op2 _ a b   -> S.union (collectDeps bound a) (collectDeps bound b)
  Op1 _ a     -> collectDeps bound a
  Sig a b     -> S.union (collectDeps bound a) (collectDeps bound b)
  Tup a b     -> S.union (collectDeps bound a) (collectDeps bound b)
  SigM x f    -> S.union (collectDeps bound x) (collectDeps bound f)
  All a b     -> S.union (collectDeps bound a) (collectDeps bound b)
  Lam k f     -> collectDeps (S.insert k bound) (f (Var k 0))
  App f x     -> S.union (collectDeps bound f) (collectDeps bound x)
  Eql t a b   -> S.unions [collectDeps bound t, collectDeps bound a, collectDeps bound b]
  Rfl         -> S.empty
  EqlM x f    -> S.union (collectDeps bound x) (collectDeps bound f)
  Met _ t ctx -> S.unions (collectDeps bound t : map (collectDeps bound) ctx)
  Ind t       -> collectDeps bound t
  Frz t       -> collectDeps bound t
  Itv         -> S.empty
  I0          -> S.empty
  I1          -> S.empty
  INot a      -> collectDeps bound a
  IAnd a b    -> S.union (collectDeps bound a) (collectDeps bound b)
  IOr a b     -> S.union (collectDeps bound a) (collectDeps bound b)
  Pth t a b   -> S.unions [collectDeps bound t, collectDeps bound a, collectDeps bound b]
  PLm k f     -> collectDeps (S.insert k bound) (f (Var k 0))
  PAp f x     -> S.union (collectDeps bound f) (collectDeps bound x)
  Coe pp r t x -> S.unions [collectDeps bound pp, collectDeps bound r, collectDeps bound t, collectDeps bound x]
  Ua a b f g gf fg -> S.unions [collectDeps bound a, collectDeps bound b, collectDeps bound f, collectDeps bound g, collectDeps bound gf, collectDeps bound fg]
  HCm a fs x -> S.unions (collectDeps bound a : collectDeps bound x : concatMap (\(p,u) -> [collectDeps bound p, collectDeps bound u]) fs)
  Glu a fs -> S.unions (collectDeps bound a : concatMap (\(p,t,e) -> [collectDeps bound p, collectDeps bound t, collectDeps bound e]) fs)
  GlB a fs x -> S.unions (collectDeps bound a : collectDeps bound x : concatMap (\(p,t) -> [collectDeps bound p, collectDeps bound t]) fs)
  UnG g -> collectDeps bound g
  Tru a -> collectDeps bound a
  TIn a -> collectDeps bound a
  TSq x y -> S.union (collectDeps bound x) (collectDeps bound y)
  TRec x p f -> S.unions [collectDeps bound x, collectDeps bound p, collectDeps bound f]
  Cir -> S.empty
  CBase -> S.empty
  CLoop -> S.empty
  CRec x b l -> S.unions [collectDeps bound x, collectDeps bound b, collectDeps bound l]
  Prt p a -> S.union (collectDeps bound p) (collectDeps bound a)
  Sys fs -> S.unions (concat [ [collectDeps bound q, collectDeps bound v] | (q,v) <- fs ])
  POut u -> collectDeps bound u
  Trp l p x -> S.unions [collectDeps bound l, collectDeps bound p, collectDeps bound x]
  Rst a p u -> S.unions [collectDeps bound a, collectDeps bound p, collectDeps bound u]
  InS x -> collectDeps bound x
  OutS x -> collectDeps bound x
  Quo a r -> S.unions [collectDeps bound a, collectDeps bound r]
  QCl a -> collectDeps bound a
  QEq a b r -> S.unions [collectDeps bound a, collectDeps bound b, collectDeps bound r]
  QSq -> S.empty
  QRec x s f r -> S.unions [collectDeps bound x, collectDeps bound s, collectDeps bound f, collectDeps bound r]
  HTy t ps -> S.insert t (S.unions (map (collectDeps bound) ps))
  HCon t _ ps as ivs -> S.insert t (S.unions (map (collectDeps bound) (ps ++ as ++ ivs)))
  HEl p bs x -> S.unions (collectDeps bound p : collectDeps bound x : [ collectDeps bound b | (_,b) <- bs ])
  HRec bs x -> S.unions (collectDeps bound x : [ collectDeps bound b | (_,b) <- bs ])
  Era         -> S.empty
  Sup _ a b   -> S.union (collectDeps bound a) (collectDeps bound b)
  SupM x l f  -> S.unions [collectDeps bound x, collectDeps bound l, collectDeps bound f]
  Loc _ t     -> collectDeps bound t
  Rwt a b x   -> S.unions [collectDeps bound a, collectDeps bound b, collectDeps bound x]
  Log s x     -> S.union (collectDeps bound s) (collectDeps bound x)
  Pri _       -> S.empty
  Pat s m c   -> S.unions $ map (collectDeps bound) s ++ map (collectDeps bound . snd) m ++ concatMap (collectCaseDeps bound) c
  Frk l a b   -> S.unions [collectDeps bound l, collectDeps bound a, collectDeps bound b]

-- | Helper for `collectDeps` to handle dependencies in pattern-match cases.
collectCaseDeps :: S.Set Name -> Case -> [S.Set Name]
collectCaseDeps bound (patterns, body) =
  let binders = S.unions (map collectPatternVars patterns)
      newBound = S.union bound binders
  in collectDeps newBound body : map (getPatternDeps bound) patterns

-- | Helper for `collectDeps` to extract dependencies from a single pattern.
-- In a pattern `f(x,y)`, `f` is a dependency, but `x` and `y` are binders.
getPatternDeps :: S.Set Name -> Term -> S.Set Name
getPatternDeps bound term = case cut term of
  Ref k     -> S.singleton k
  -- For an application in a pattern, only the function part can be a dependency.
  -- The arguments are binders, not expressions to be evaluated.
  App f _   -> collectDeps bound f
  Tup a b   -> S.union (getPatternDeps bound a) (getPatternDeps bound b)
  Con h t   -> S.union (getPatternDeps bound h) (getPatternDeps bound t)
  Suc n     -> getPatternDeps bound n
  Chk p _   -> getPatternDeps bound p
  -- Constructors that don't contain further dependencies
  _         -> S.empty

-- | Collects all variable names bound by a pattern.
collectPatternVars :: Term -> S.Set Name
collectPatternVars term = case cut term of
  Var k _   -> S.singleton k
  App _ _   -> let (_, args) = collectApps term [] in S.unions (map collectPatternVars args)
  Tup a b   -> S.union (collectPatternVars a) (collectPatternVars b)
  Con h t   -> S.union (collectPatternVars h) (collectPatternVars t)
  Suc n     -> collectPatternVars n
  Chk p _   -> collectPatternVars p
  _         -> S.empty
