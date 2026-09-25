{-./Type.hs-}

module Core.Rewrite where

import System.IO.Unsafe
import Data.IORef
import Data.Bits
import GHC.Float (castDoubleToWord64, castWord64ToDouble)

import Core.Equal
import Core.Type
import Core.WHNF

import Debug.Trace

-- Rewrite
-- =======

rewrite :: Int -> Int -> Book -> Term -> Term -> Term -> Term
rewrite lv d book old neo val
  | equal d book old val = neo
  -- an application of a definition is rewritten in its ARGUMENTS, never by
  -- unfolding it: the occurrence being rewritten is local, so it can only
  -- sit in the arguments, and unfolding a productive (corecursive)
  -- definition here would go on forever
  | isVar (cut old), (Ref k, xs@(_ : _)) <- collectApps (cut val) [] = foldl App (Ref k) (map (rewrite lv d book old neo) xs)
  | otherwise            = rewriteGo lv d book old neo $ whnf Soft book val
  -- | equal d book old val = trace ("eq " ++ show old ++ " → " ++ show neo ++ " |" ++ show val ++ " → " ++ show (whnf 2 d book val)) $ neo
  -- | otherwise            = trace ("rw " ++ show old ++ " → " ++ show neo ++ " |" ++ show val ++ " → " ++ show (whnf 2 d book val))
                         -- $ rewriteGo lv d book old neo $ whnf 2 d book val

isVar :: Term -> Bool
isVar (Var _ _) = True
isVar _         = False

-- Recursively rewrites occurrences of 'old' with 'neo' in 'val'
rewriteGo :: Int -> Int -> Book -> Term -> Term -> Term -> Term
rewriteGo lv d book old neo val = case val of
  Var k i    -> Var k i
  Ref k      -> Ref k
  Sub t      -> t
  Fix k f    -> Fix k (\x -> rewrite lv d book old neo (f x))
  Let v f    -> Let (rewrite lv d book old neo v) (rewrite lv d book old neo f)
  Set        -> Set
  Chk x t    -> Chk (rewrite lv d book old neo x) (rewrite lv d book old neo t)
  Emp        -> Emp
  EmpM x     -> EmpM (rewrite lv d book old neo x)
  Uni        -> Uni
  One        -> One
  UniM x f   -> UniM (rewrite lv d book old neo x) (rewrite lv d book old neo f)
  Bit        -> Bit
  Bt0        -> Bt0
  Bt1        -> Bt1
  BitM x f t -> BitM (rewrite lv d book old neo x) (rewrite lv d book old neo f) (rewrite lv d book old neo t)
  Nat        -> Nat
  Zer        -> Zer
  Suc n      -> Suc (rewrite lv d book old neo n)
  NatM x z s -> NatM (rewrite lv d book old neo x) (rewrite lv d book old neo z) (rewrite lv d book old neo s)
  Lst t      -> Lst (rewrite lv d book old neo t)
  Nil        -> Nil
  Con h t    -> Con (rewrite lv d book old neo h) (rewrite lv d book old neo t)
  LstM x n c -> LstM (rewrite lv d book old neo x) (rewrite lv d book old neo n) (rewrite lv d book old neo c)
  Enu s      -> Enu s
  Sym s      -> Sym s
  EnuM x c e -> EnuM (rewrite lv d book old neo x) (map (\(s,t) -> (s, rewrite lv d book old neo t)) c) (rewrite lv d book old neo e)
  Num t      -> Num t
  Val v      -> Val v
  Op2 o a b  -> Op2 o (rewrite lv d book old neo a) (rewrite lv d book old neo b)
  Op1 o a    -> Op1 o (rewrite lv d book old neo a)
  Sig a b    -> Sig (rewrite lv d book old neo a) (rewrite lv d book old neo b)
  Tup a b    -> Tup (rewrite lv d book old neo a) (rewrite lv d book old neo b)
  SigM x f   -> SigM (rewrite lv d book old neo x) (rewrite lv d book old neo f)
  All a b    -> All (rewrite lv d book old neo a) (rewrite lv d book old neo b)
  Lam k f    -> Lam k (\v -> rewrite lv d book old neo (f v))
  -- the head is rewritten too: after a Nat refinement a goal can sit as
  -- `(λp. body)(p)` (Soft whnf keeps the application when the body is a
  -- stuck match), and the matched variable lives inside that body
  App f x    -> foldl (\ f x -> App f (rewrite lv d book old neo x)) (rewriteHead fn) xs
          where (fn,xs) = collectApps (App f x) []
                rewriteHead h = case h of
                  Lam k g -> Lam k (\v -> rewrite lv d book old neo (g v))
                  Loc l t -> rewriteHead t
                  _       -> h
  Eql t a b  -> Eql (rewrite lv d book old neo t) (rewrite lv d book old neo a) (rewrite lv d book old neo b)
  Rfl        -> Rfl
  EqlM x f   -> EqlM (rewrite lv d book old neo x) (rewrite lv d book old neo f)
  Met i t a  -> Met i (rewrite lv d book old neo t) (map (rewrite lv d book old neo) a)
  Ind t      -> Ind (rewrite lv d book old neo t)
  Frz t      -> Frz (rewrite lv d book old neo t)
  Itv        -> Itv
  I0         -> I0
  I1         -> I1
  INot a     -> INot (rewrite lv d book old neo a)
  IAnd a b   -> IAnd (rewrite lv d book old neo a) (rewrite lv d book old neo b)
  IOr a b    -> IOr (rewrite lv d book old neo a) (rewrite lv d book old neo b)
  Pth t a b  -> Pth (rewrite lv d book old neo t) (rewrite lv d book old neo a) (rewrite lv d book old neo b)
  PLm k f    -> PLm k (\x -> rewrite lv d book old neo (f x))
  PAp f x    -> PAp (rewrite lv d book old neo f) (rewrite lv d book old neo x)
  Coe pp r t x -> Coe (rewrite lv d book old neo pp) (rewrite lv d book old neo r) (rewrite lv d book old neo t) (rewrite lv d book old neo x)
  Ua a b f g gf fg -> Ua (rewrite lv d book old neo a) (rewrite lv d book old neo b) (rewrite lv d book old neo f) (rewrite lv d book old neo g) (rewrite lv d book old neo gf) (rewrite lv d book old neo fg)
  HCm a fs x -> HCm (rewrite lv d book old neo a) [ (rewrite lv d book old neo p, rewrite lv d book old neo u) | (p,u) <- fs ] (rewrite lv d book old neo x)
  Glu a fs -> Glu (rewrite lv d book old neo a) [ (rewrite lv d book old neo p, rewrite lv d book old neo t, rewrite lv d book old neo e) | (p,t,e) <- fs ]
  GlB a fs x -> GlB (rewrite lv d book old neo a) [ (rewrite lv d book old neo p, rewrite lv d book old neo t) | (p,t) <- fs ] (rewrite lv d book old neo x)
  UnG g -> UnG (rewrite lv d book old neo g)
  Quo a r -> Quo (rewrite lv d book old neo a) (rewrite lv d book old neo r)
  QCl a -> QCl (rewrite lv d book old neo a)
  QEq a b r -> QEq (rewrite lv d book old neo a) (rewrite lv d book old neo b) (rewrite lv d book old neo r)
  QSq -> QSq
  QRec x s f r -> QRec (rewrite lv d book old neo x) (rewrite lv d book old neo s) (rewrite lv d book old neo f) (rewrite lv d book old neo r)
  Era        -> Era
  Sup l a b  -> Sup l (rewrite lv d book old neo a) (rewrite lv d book old neo b)
  SupM x l f -> SupM (rewrite lv d book old neo x) (rewrite lv d book old neo l) (rewrite lv d book old neo f)
  Frk l a b  -> Frk (rewrite lv d book old neo l) (rewrite lv d book old neo a) (rewrite lv d book old neo b)
  Loc s t    -> Loc s (rewrite lv d book old neo t)
  Rwt a b x  -> Rwt (rewrite lv d book old neo a) (rewrite lv d book old neo b) (rewrite lv d book old neo x)
  Log s x    -> Log (rewrite lv d book old neo s) (rewrite lv d book old neo x)
  Pri p      -> Pri p
  Pat t m c  -> Pat (map (rewrite lv d book old neo) t) (map (\(k,v) -> (k, rewrite lv d book old neo v)) m) (map (\(ps,v) -> (map (rewrite lv d book old neo) ps, rewrite lv d book old neo v)) c)
  -- every other constructor (the cubical layer, the HITs): one structural level
  _          -> mapSub (rewrite lv d book old neo) val

rewriteCtx :: Int -> Int -> Book -> Term -> Term -> Ctx -> Ctx
rewriteCtx lv d book old neo (Ctx ctx) = Ctx (map rewriteAnn ctx)
  where rewriteAnn (k,v,t) = (k, v, rewrite lv d book old neo t)
