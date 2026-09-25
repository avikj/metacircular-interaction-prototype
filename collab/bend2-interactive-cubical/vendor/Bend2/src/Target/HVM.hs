{-./../Core/Type.hs-}

{-# LANGUAGE ViewPatterns #-}

module Target.HVM where

import Control.Monad (forM)
import Core.Type
import Core.WHNF (force, coeRep, pathRep, coeMarker, occursMarker)
import Data.Either (partitionEithers)
import Data.List (isInfixOf)
import Debug.Trace
import qualified Data.Map as M
import qualified Data.Map.Strict as MS
import qualified Data.Set as S
import qualified HVM.Type as HVM

compile :: Book -> String
compile book@(Book defs _) =
  let ds       = map (compileDef book) (M.toList defs)
      (ts, fs) = partitionEithers ds
  in prelude ++ unlines ts ++ unlines fs

prelude :: String
prelude = unlines [
    "// Prelude",
    "// -------",
    "data List { #Nil #Cons{head tail} }",
    "data Nat { #Z #S{n} }",
    "data Pair { #P{fst snd} }",
    "@fix(&f) = (f @fix(f))",
    "// cubical: a universe path is a Church pair (fwd, bwd); coe projects a direction",
    "@cub_idfn = λ&x x",
    "@cub_idPath = λ&k ((k @cub_idfn) @cub_idfn)",
    "@cub_pathFwd = λ&p λ&x ((p λ&f λ&g f) x)",
    "@cub_pathBwd = λ&p λ&x ((p λ&f λ&g g) x)",
    "@main = @main$",
    "",
    "// Bend to HVM Compiler Output",
    "// ---------------------------",
    ""
  ]

-- Compile a Bend function to an HVM definition
compileDef :: Book -> (Name, Defn) -> Either String String
compileDef book (nam, (_, tm, ty)) 
  -- TODO: Remove proof fields?
  | (Just (_, ctrs)) <- extractTypeDef tm = Left (compileType nam ctrs)
  -- TODO: Function arguments
  | otherwise = Right (compileFn book nam tm)

compileType :: Name -> [(Name, [Name])] -> String
compileType nam ctrs = unlines $
  [ ("data " ++ (hvmNam nam) ++ " { " ++ unwords (map compileCtr ctrs) ++ " }")
  , ("@" ++ (hvmNam nam) ++ " = *")
  ]
  where compileCtr (nam, fds) = "#" ++ (hvmNam nam) ++ "{" ++ unwords fds ++ "}"

compileFn :: Book -> Name -> Term -> String
compileFn book nam tm = "@" ++ (hvmNam nam) ++ " = " ++ HVM.showCore (termToHVM book MS.empty tm)

-- Extract constructor definition info from type definitions
extractTypeDef :: Term -> Maybe ([Name], [(Name, [Name])])
extractTypeDef tm = do
  (args, tmSig) <- getTypeArgs tm []
  css <- getTypeCss tmSig
  return (args, css)
  where
    getTypeArgs :: Term -> [Name] -> Maybe ([Name], Term)
    getTypeArgs (Lam arg tm) args = getTypeArgs (tm (Var arg 0)) (args ++ [arg])
    getTypeArgs tm           args = Just (args, tm)

    getTypeCss :: Term -> Maybe [(Name, [Name])]
    getTypeCss (Sig (Enu _) (Lam "ctr" (subst "ctr" -> EnuM (Var "ctr" _) css (Lam "_" (subst "_" -> One))))) = do
      forM css (\(ctr, bod) -> do
        fds <- getTypeCsFds bod
        return (ctr, fds))
    getTypeCss _ = Nothing

    getTypeCsFds :: Term -> Maybe [Name]
    getTypeCsFds (Sig _ (Lam fd (subst fd -> tm))) = do
      fds <- getTypeCsFds tm
      return $ fd : fds
    getTypeCsFds Uni = Just []
    getTypeCsFds _   = Nothing

    subst a f = f (Var a 0)


termToHVM :: Book -> MS.Map Name HVM.Name -> Term -> HVM.Core
termToHVM book ctx tm = go tm where
  subst a f = f (Var a 0)

  go (Var n i) =
    case MS.lookup n ctx of
      Just n  -> HVM.Var n
      Nothing -> HVM.Var n
  go (Ref k)      = if take 4 k == "cub_" then HVM.Ref k 0 [] else HVM.Ref (hvmNam k) 0 [] -- TODO: Ref arguments
  go (Sub t)      = termToHVM book ctx t
  go (Fix n f)    = HVM.Ref "fix" 0 [HVM.Lam ('&':n) (termToHVM book (MS.insert n n ctx) (f (Var n 0)))]
  go (Let v f)    = HVM.App (termToHVM book ctx f) (termToHVM book ctx v)
  go Set          = HVM.Era
  go (Chk v t)    = termToHVM book ctx v
  go Emp          = HVM.Era
  go (EmpM x)     = HVM.Era
  go Uni          = HVM.Era
  go One          = HVM.U32 1
  go (UniM x f)   = termToHVM book ctx f
  go Bit          = HVM.Era
  go Bt0          = HVM.U32 0
  go Bt1          = HVM.U32 1
  go (BitM x f t) = HVM.Mat HVM.SWI (termToHVM book ctx x) [] [("0", [], termToHVM book ctx f), ("_", [], termToHVM book ctx t)]
  go Nat          = HVM.Era
  go Zer          = HVM.Ctr "#Z" []
  go (Suc p)      = HVM.Ctr "#S" [termToHVM book ctx p]
  go (NatM x z s) = HVM.Mat (HVM.MAT 0) (termToHVM book ctx x) [] [("#Z", [], termToHVM book ctx z), ("#S", [], termToHVM book ctx s)]
  go (Lst t)      = HVM.Era
  go Nil          = HVM.Ctr "#Nil" []
  go (Con h t)    = HVM.Ctr "#Cons" [termToHVM book ctx h, termToHVM book ctx t]
  go (LstM x n c) = HVM.Mat (HVM.MAT 0) (termToHVM book ctx x) [] [("#Nil", [], termToHVM book ctx n), ("#Cons", [], termToHVM book ctx c)]
  go (Enu s)      = HVM.Era
  go (Sym s)      = error "TODO: bare Sym toHVM"
  go (EnuM x c e) = error "TODO: bare EnuM toHVM"
  go (Log s x)    = termToHVM book ctx x  -- For HVM, just return the result expression
  go (Num _)      = HVM.Era
  go (Val (U64_V v)) = HVM.U32 (fromIntegral v)
  go (Val (I64_V v)) = HVM.Era
  go (Val (F64_V v)) = HVM.Era
  go (Val (CHR_V c)) = HVM.Chr c
  go (Op2 o a b)  = op2ToHVM o a b where
    op2ToHVM ADD a b = HVM.Op2 HVM.OP_ADD (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM SUB a b = HVM.Op2 HVM.OP_SUB (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM MUL a b = HVM.Op2 HVM.OP_MUL (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM DIV a b = HVM.Op2 HVM.OP_DIV (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM MOD a b = HVM.Op2 HVM.OP_MOD (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM POW a b = error "TODO"
    op2ToHVM EQL a b = HVM.Op2 HVM.OP_EQ  (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM NEQ a b = HVM.Op2 HVM.OP_NE  (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM LST a b = HVM.Op2 HVM.OP_LT  (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM GRT a b = HVM.Op2 HVM.OP_GT  (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM LEQ a b = HVM.Op2 HVM.OP_LTE (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM GEQ a b = HVM.Op2 HVM.OP_GTE (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM AND a b = HVM.Op2 HVM.OP_AND (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM OR  a b = HVM.Op2 HVM.OP_OR  (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM XOR a b = HVM.Op2 HVM.OP_XOR (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM SHL a b = HVM.Op2 HVM.OP_LSH (termToHVM book ctx a) (termToHVM book ctx b)
    op2ToHVM SHR a b = HVM.Op2 HVM.OP_RSH (termToHVM book ctx a) (termToHVM book ctx b)
  go (Op1 o a)    = op1ToHVM o a where
    op1ToHVM NOT = error "TODO"
    op1ToHVM NEG = error "TODO"
  go (Sig _ _)    = HVM.Era
  go (Tup x y) = case extractCtr x y of
      Just (k, x) -> HVM.Ctr ('#':hvmNam k) (map (termToHVM book ctx) x)
      Nothing     -> HVM.Ctr "#P" [termToHVM book ctx x, termToHVM book ctx y]
    where 
      extractCtr (Sym k) y = 
        case unsnoc (flattenTup y) of
          Just (xs, One) -> Just (k, xs)
          _              -> Nothing
      extractCtr _ _ = Nothing
  go (SigM x f)  = case extractCtrM f of
      Just (cs,t,b,d) -> HVM.Let HVM.LAZY t (termToHVM book ctx x) (matToHVM ctx t b cs d) -- TODO: Default case should rewrite (ctrNam, ctrBod) to the default case var
      Nothing         -> HVM.Mat (HVM.MAT 0) (termToHVM book ctx x) [] [("#P", [], termToHVM book ctx f)]
    where
      extractCtrM :: Term -> Maybe ([(Name, [Name], Term)], Name, Name, Term)
      extractCtrM (Lam a (subst a -> Lam bodK (subst bodK -> EnuM (Var x _) cs (Lam tagK (subst tagK -> dflt))))) =
        if x == a then do
          csF <- forM cs (\(k,f) -> do
              (fds, bod) <- flattenCtrM bodK f []
              return (k, fds, bod)
            )
          return (csF, tagK, bodK, dflt)
        else Nothing
      extractCtrM _ = Nothing

      flattenCtrM :: Name -> Term -> [Name] -> Maybe ([Name], Term)
      flattenCtrM x (SigM (Var k _) (Lam fd (subst fd -> Lam nxt (subst nxt -> f)))) fds = if (k == x) then flattenCtrM nxt f (fd : fds) else Nothing
      flattenCtrM x (UniM (Var k _) f)                                               fds = if (k == x) then Just (fds, f) else Nothing
      flattenCtrM _ _ _ = Nothing

      matToHVM :: MS.Map Name HVM.Name -> Name -> Name -> [(Name, [Name], Term)] -> Term -> HVM.Core
      matToHVM ctx t b [(ctr,fds,bod)]    d = mkIfl t ctr (termToHVM book ctx bod) fds d' -- Make dflt case match entire ctr, not just the tag
                                     where d' = (rewriteHVM (HVM.Ctr "#P" [HVM.Var t, HVM.Var b]) (HVM.Var t) (termToHVM book ctx d))
      matToHVM ctx t b ((ctr,fds,bod):cs) d = mkIfl t ctr (termToHVM book ctx bod) fds (matToHVM ctx t b cs d)
      matToHVM _ _ _ _ _ = error "matToHVM: unreachable"

      mkIfl x ctr bod fds d = HVM.Mat (HVM.IFL 0) (HVM.Var x) [] [('#':hvmNam ctr, [], foldr HVM.Lam bod (map ('&':) (reverse fds))), (('&':x), [], d)]
  go (All _ _)    = HVM.Era
  go (Lam n f)    = HVM.Lam ('&':n) (termToHVM book (MS.insert n n ctx) (f (Var n 0)))
  go (App f x)    = HVM.App (termToHVM book ctx f) (termToHVM book ctx x)
  go (Eql _ _ _)  = HVM.Era
  go Rfl          = HVM.Era
  go (EqlM x f)   = termToHVM book ctx f
  go (Met n t ts) = HVM.Era -- TODO: Met
  go (Ind t)      = termToHVM book ctx t
  go (Frz t)      = termToHVM book ctx t
  go Era          = HVM.Era
  go (Sup l a b)  = HVM.Ref "SUP" 0 [termToHVM book ctx l, termToHVM book ctx a, termToHVM book ctx b]
  go (SupM x l f) = HVM.Ref "DUP" 0 [termToHVM book ctx l, termToHVM book ctx x, termToHVM book ctx f]
  go (Frk l a b)  = tmLab where
    -- Only fork variables free in the bodies of a and b
    tmLab             = HVM.Let HVM.STRI "&L$" (termToHVM book ctx l) tmDup 
    tmDup             = foldr dup tmSup vars
    tmSup             = HVM.Ref "SUP" 0 [HVM.Var "L$", termToHVM book ctxA a, termToHVM book ctxB b]
    dup (_,v,(a,b)) x = HVM.Ref "DUP" 0 [HVM.Var "L$", HVM.Var v, HVM.Lam ('&':a) (HVM.Lam ('&':b) x)]
    vars              = [(k, v, (suff v "0", suff v "1")) | (k, v) <- MS.toList ctx, k `S.member` free]
    free              = freeVars S.empty a `S.union` freeVars S.empty b
    suff v s          = if "$$" `isInfixOf` v then v ++ s else v ++ "$$" ++ s
    ctxA              = MS.fromList [(k, a) | (k, _, (a, _)) <- vars]
    ctxB              = MS.fromList [(k, b) | (k, _, (_, b)) <- vars]
  -- cubical layer (faithful: transport is applied, never erased)
  go Itv          = HVM.Era
  go I0           = HVM.Era
  go I1           = HVM.Era
  go (INot _)     = HVM.Era
  go (IAnd _ _)   = HVM.Era
  go (IOr _ _)    = HVM.Era
  go (Pth _ _ _)  = HVM.Era
  go (PLm _ f)    = let b = f Era in if isTypeLine b then HVM.Ref "cub_idPath" 0 [] else
                      case f coeMarker of
                        bm | isSetLine bm -> case pathRep tm of
                               Just r  -> termToHVM book ctx r
                               Nothing -> error ("HVM emission: unsupported universe path: " ++ show tm)
                        _ -> termToHVM book ctx b
  -- a literal endpoint is resolved before erasure (p @ i1 of an hcomp is
  -- the tube top, not the cap)
  go (PAp p r)    = case cut r of
      I0 -> termToHVM book ctx (force book (PAp p r))
      I1 -> termToHVM book ctx (force book (PAp p r))
      _  -> termToHVM book ctx p
  go (HCm _ _ x)  = termToHVM book ctx x
  go (Glu _ _)    = HVM.Era
  go (GlB _ _ x)  = termToHVM book ctx x
  go (UnG g)      = termToHVM book ctx g
  go (Ua _ _ f g _ _) = HVM.Lam "&k" (HVM.App (HVM.App (HVM.Var "k") (termToHVM book ctx f)) (termToHVM book ctx g))
  go (Coe pP r s x) = case coeRep pP r s x of
      Just t' -> termToHVM book ctx t'
      Nothing -> error ("HVM emission: unsupported coe line (outside the runtime path algebra): " ++ show pP)
  go (Loc s t)    = termToHVM book ctx t
  go (Rwt _ _ x)  = termToHVM book ctx x
  go (Pri p)      = HVM.Era
  go (Pat x m c)  = HVM.Era

isSetLine :: Term -> Bool
isSetLine bm = occursMarker bm && case cut bm of
  All _ _     -> True
  Sig _ _     -> True
  HCm a _ _   -> case cut a of { Set -> True; _ -> False }
  _           -> False

-- a path lambda whose body is a type former is a constant line in Set:
-- its runtime meaning is the identity path.
isTypeLine :: Term -> Bool
isTypeLine t = case cut t of
  Set -> True; Bit -> True; Nat -> True; Uni -> True; Emp -> True
  Lst _ -> True; Enu _ -> True; Num _ -> True; Sig _ _ -> True
  All _ _ -> True; Itv -> True; Pth _ _ _ -> True; Eql _ _ _ -> True
  _ -> False

-- If `pP` is `λi. (P @ i)` (a universe-path line), return the path `P`.
pathLineHead :: Term -> Maybe Term
pathLineHead t = case t of
  Lam k f  -> case f (Var k 0) of
                PAp pth _         -> Just pth
                Loc _ (PAp pth _) -> Just pth
                _                 -> Nothing
  Loc _ x  -> pathLineHead x
  _        -> Nothing

hvmNam :: Name -> HVM.Name
hvmNam n = (replace '/' "__" n) ++ "$"

replace :: Char -> String -> String -> String
replace old new xs = foldr (\c acc -> if c == old then new ++ acc else c : acc) [] xs

rewriteHVM :: HVM.Core -> HVM.Core -> HVM.Core -> HVM.Core
rewriteHVM old new tm =
  if tm == old
    then new
    else case tm of
      HVM.Var n         -> HVM.Var n
      HVM.Ref n k xs    -> HVM.Ref n k (map (rewriteHVM old new) xs)
      HVM.Era           -> HVM.Era
      HVM.Lam n f       -> HVM.Lam n (rewriteHVM old new f)
      HVM.App f x       -> HVM.App (rewriteHVM old new f) (rewriteHVM old new x)
      HVM.Sup l a b     -> HVM.Sup l (rewriteHVM old new a) (rewriteHVM old new b)
      HVM.Dup l a b v x -> HVM.Dup l a b (rewriteHVM old new v) (rewriteHVM old new x)
      HVM.Ctr n xs      -> HVM.Ctr n (map (rewriteHVM old new) xs)
      HVM.U32 n         -> HVM.U32 n
      HVM.Chr c         -> HVM.Chr c
      HVM.Op2 o a b     -> HVM.Op2 o (rewriteHVM old new a) (rewriteHVM old new b)
      HVM.Let t n v f   -> HVM.Let t n (rewriteHVM old new v) (rewriteHVM old new f)
      HVM.Mat t x mv cs -> HVM.Mat t (rewriteHVM old new x) (map (\(n,v) -> (n,rewriteHVM old new v)) mv) (map (\(c,f,b) -> (c,f,rewriteHVM old new b)) cs)
      HVM.Inc a         -> HVM.Inc (rewriteHVM old new a)
      HVM.Dec a         -> HVM.Dec (rewriteHVM old new a)

freeVars :: S.Set Name -> Term -> S.Set Name
freeVars ctx tm = case tm of
  Var n _    -> if n `S.member` ctx then S.empty else S.singleton n
  Ref n      -> S.empty
  Sub t      -> freeVars ctx t
  Fix n f    -> freeVars (S.insert n ctx) (f (Var n 0))
  Let v f    -> S.union (freeVars ctx v) (freeVars ctx f)
  Set        -> S.empty
  Chk v t    -> S.union (freeVars ctx v) (freeVars ctx t)
  Emp        -> S.empty
  EmpM x     -> freeVars ctx x
  Uni        -> S.empty
  One        -> S.empty
  UniM x f   -> S.union (freeVars ctx x) (freeVars ctx f)
  Bit        -> S.empty
  Bt0        -> S.empty
  Bt1        -> S.empty
  BitM x f t -> S.unions [freeVars ctx x, freeVars ctx f, freeVars ctx t]
  Nat        -> S.empty
  Zer        -> S.empty
  Suc n      -> freeVars ctx n
  NatM x z s -> S.unions [freeVars ctx x, freeVars ctx z, freeVars ctx s]
  Lst t      -> freeVars ctx t
  Nil        -> S.empty
  Con h t    -> S.union (freeVars ctx h) (freeVars ctx t)
  LstM x n c -> S.unions [freeVars ctx x, freeVars ctx n, freeVars ctx c]
  Enu s      -> S.empty
  Sym s      -> S.empty
  EnuM x c e -> S.unions [freeVars ctx x, S.unions (map (freeVars ctx . snd) c), freeVars ctx e]
  Num _      -> S.empty
  Val _      -> S.empty
  Op2 _ a b  -> S.union (freeVars ctx a) (freeVars ctx b)
  Op1 _ a    -> freeVars ctx a
  Sig a b    -> S.union (freeVars ctx a) (freeVars ctx b)
  Tup a b    -> S.union (freeVars ctx a) (freeVars ctx b)
  SigM x f   -> S.union (freeVars ctx x) (freeVars ctx f)
  All a b    -> S.union (freeVars ctx a) (freeVars ctx b)
  Lam n f    -> freeVars (S.insert n ctx) (f (Var n 0))
  App f x    -> S.union (freeVars ctx f) (freeVars ctx x)
  Eql t a b  -> S.unions [freeVars ctx t, freeVars ctx a, freeVars ctx b]
  Rfl        -> S.empty
  EqlM x f   -> S.union (freeVars ctx x) (freeVars ctx f)
  Met _ t c  -> S.unions (freeVars ctx t : map (freeVars ctx) c)
  Ind t      -> freeVars ctx t
  Frz t      -> freeVars ctx t
  Era        -> S.empty
  Sup _ a b  -> S.union (freeVars ctx a) (freeVars ctx b)
  SupM x l f -> S.unions [freeVars ctx x, freeVars ctx l, freeVars ctx f]
  Frk l a b  -> S.unions [freeVars ctx l, freeVars ctx a, freeVars ctx b]
  Log s x    -> S.union (freeVars ctx s) (freeVars ctx x)
  Loc _ t    -> freeVars ctx t
  Rwt a b x  -> S.unions [freeVars ctx a, freeVars ctx b, freeVars ctx x]
  Itv        -> S.empty
  I0         -> S.empty
  I1         -> S.empty
  INot a     -> freeVars ctx a
  IAnd a b   -> S.union (freeVars ctx a) (freeVars ctx b)
  IOr  a b   -> S.union (freeVars ctx a) (freeVars ctx b)
  Pth a x y  -> S.unions [freeVars ctx a, freeVars ctx x, freeVars ctx y]
  PLm n f    -> freeVars (S.insert n ctx) (f (Var n 0))
  PAp a b    -> S.union (freeVars ctx a) (freeVars ctx b)
  Coe a r t x -> S.unions [freeVars ctx a, freeVars ctx r, freeVars ctx t, freeVars ctx x]
  Ua a b c d e f -> S.unions (map (freeVars ctx) [a,b,c,d,e,f])
  HCm a fs x -> S.unions (freeVars ctx a : freeVars ctx x : concat [ [freeVars ctx q, freeVars ctx u] | (q,u) <- fs ])
  Glu a fs   -> S.unions (freeVars ctx a : concat [ [freeVars ctx q, freeVars ctx t, freeVars ctx e] | (q,t,e) <- fs ])
  GlB a fs x -> S.unions (freeVars ctx a : freeVars ctx x : concat [ [freeVars ctx q, freeVars ctx t] | (q,t) <- fs ])
  UnG g      -> freeVars ctx g
  Tru a      -> freeVars ctx a
  TIn a      -> freeVars ctx a
  TSq x y    -> S.union (freeVars ctx x) (freeVars ctx y)
  TRec x p f -> S.unions [freeVars ctx x, freeVars ctx p, freeVars ctx f]
  Cir        -> S.empty
  CBase      -> S.empty
  CLoop      -> S.empty
  CRec x b l -> S.unions [freeVars ctx x, freeVars ctx b, freeVars ctx l]
  Prt p a    -> S.union (freeVars ctx p) (freeVars ctx a)
  Sys fs     -> S.unions (concat [ [freeVars ctx q, freeVars ctx v] | (q,v) <- fs ])
  POut u     -> freeVars ctx u
  Trp l p x  -> S.unions [freeVars ctx l, freeVars ctx p, freeVars ctx x]
  Rst a p u  -> S.unions [freeVars ctx a, freeVars ctx p, freeVars ctx u]
  InS x      -> freeVars ctx x
  OutS x     -> freeVars ctx x
  Quo a r    -> S.union (freeVars ctx a) (freeVars ctx r)
  QCl a      -> freeVars ctx a
  QEq a b w  -> S.unions [freeVars ctx a, freeVars ctx b, freeVars ctx w]
  QSq        -> S.empty
  QRec x t f r -> S.unions (map (freeVars ctx) [x,t,f,r])
  HTy _ ps -> S.unions (map (freeVars ctx) ps)
  HCon _ _ ps as ivs -> S.unions (map (freeVars ctx) (ps ++ as ++ ivs))
  HEl p bs x -> S.unions (map (freeVars ctx) (p : x : map snd bs))
  HRec bs x -> S.unions (map (freeVars ctx) (x : map snd bs))
  Pri _      -> S.empty
  Pat s m c  -> error "TODO: Pat"

-- (Data.List.unsnoc only exists from base 4.19; defined here for portability)
unsnoc :: [a] -> Maybe ([a], a)
unsnoc [] = Nothing
unsnoc xs = Just (init xs, last xs)
