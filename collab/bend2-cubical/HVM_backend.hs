{-./../Core/Type.hs-}

{-# LANGUAGE ViewPatterns #-}

module Target.HVM where

import Control.Monad (forM)
import Core.Type
import Core.WHNF (whnf, EvalLevel(..), coeMarker)
import Data.Either (partitionEithers)
import Data.List (isInfixOf, unsnoc)
import Debug.Trace
import qualified Data.Map as M
import qualified Data.Map.Strict as MS
import qualified Data.Set as S
import qualified HVM.Type as HVM

compile :: Book -> String
compile book@(Book defs) =
  let ds       = map (compileDef book) (M.toList defs)
      (ts, fs) = partitionEithers ds
  in prelude ++ unlines ts ++ unlines fs

-- Reduce cubical redexes (Coe/HCm) to their computational content before
-- lowering: a transport is not erased, it EXECUTES into the value-changing
-- function (coe along ua ↦ that function; along a Sup line ↦ dup+route;
-- along a constant/rigid line ↦ identity), exactly the whnfCoe semantics.
-- Everything else recurses structurally, under HOAS binders too. A coe/hcomp
-- that is genuinely stuck (no reduction) is left in place for termToHVM to
-- report, rather than silently dropped.
elimCubical :: Book -> Term -> Term
elimCubical book = go where
  red t = let w = whnf Full book t
          in case w of
               Coe {} -> mapSub w   -- stuck: keep head, clean children
               HCm {} -> mapSub w
               _      -> go w
  mapSub t = case t of
    Coe p r s x     -> Coe (go p) (go r) (go s) (go x)
    HCm a r u0 u1 x -> HCm (go a) (go r) (go u0) (go u1) (go x)
    _               -> go t
  -- Faithful Sup×Path lowering.  Transport along a superposed line
  -- &L{A(i),B(i)} must become a label-L DUP of the input paired with a
  -- label-L SUP of the two per-universe transports: on HVM the DUP-SUP at
  -- the SAME label ANNIHILATES, routing component-wise (the corpus's
  -- fibre-exact routing = HVM's native annihilation).  Using whnfCoe's
  -- Haskell dup here instead would duplicate the input under a fresh label
  -- and lose the pairing (the &0{&0{..}..} bug).
  coeGo pP r s x =
    case whnf Full book (App pP coeMarker) of
      Sup l _ _ ->
        let aLn = Lam "i" (\i -> case whnf Full book (App pP i) of { Sup _ a _ -> a ; y -> y })
            bLn = Lam "i" (\i -> case whnf Full book (App pP i) of { Sup _ _ b -> b ; y -> y })
        in SupM (go x) l (Lam "t0" (\t0 -> Lam "t1" (\t1 ->
             Sup l (coeGo aLn r s t0) (coeGo bLn r s t1))))
      _ -> let w = whnf Full book (Coe pP r s x)
           in case w of
                Coe {} -> Coe (go pP) (go r) (go s) (go x)  -- stuck
                _      -> go w
  go t = case t of
    Coe pP r s x    -> coeGo pP r s x
    HCm {}          -> red t
    Var n i         -> Var n i
    Ref k           -> Ref k
    Sub x           -> Sub (go x)
    Fix n f         -> Fix n (\v -> go (f v))
    Let v f         -> Let (go v) (go f)
    Chk v ty        -> Chk (go v) (go ty)
    App f x         -> App (go f) (go x)
    Lam n f         -> Lam n (\v -> go (f v))
    Suc n           -> Suc (go n)
    NatM x z s      -> NatM (go x) (go z) (go s)
    Con h tl        -> Con (go h) (go tl)
    LstM x n c      -> LstM (go x) (go n) (go c)
    BitM x a b      -> BitM (go x) (go a) (go b)
    UniM x f        -> UniM (go x) (go f)
    SigM x f        -> SigM (go x) (go f)
    EnuM x cs e     -> EnuM (go x) [(k, go v) | (k,v) <- cs] (go e)
    EmpM x          -> EmpM (go x)
    EqlM x f        -> EqlM (go x) (go f)
    SupM x l f      -> SupM (go x) (go l) (go f)
    Tup a b         -> Tup (go a) (go b)
    Sup l a b       -> Sup (go l) (go a) (go b)
    Frk l a b       -> Frk (go l) (go a) (go b)
    All a b         -> All (go a) (go b)
    Sig a b         -> Sig (go a) (go b)
    Lst a           -> Lst (go a)
    Eql a b c       -> Eql (go a) (go b) (go c)
    Rwt a b c       -> Rwt (go a) (go b) (go c)
    Op2 o a b       -> Op2 o (go a) (go b)
    Op1 o a         -> Op1 o (go a)
    Log a b         -> Log (go a) (go b)
    Loc s x         -> Loc s (go x)
    Ind x           -> Ind (go x)
    Frz x           -> Frz (go x)
    Met n ty xs     -> Met n (go ty) (map go xs)
    -- cubical value/type formers that survive to the backend
    Pth p a b       -> Pth (go p) (go a) (go b)
    PLm k f         -> PLm k (\v -> go (f v))
    PAp p r         -> PAp (go p) (go r)
    INot a          -> INot (go a)
    IAnd a b        -> IAnd (go a) (go b)
    IOr a b         -> IOr (go a) (go b)
    Ua a b f g gf fg -> Ua (go a) (go b) (go f) (go g) (go gf) (go fg)
    _               -> t

prelude :: String
prelude = unlines [
    "// Prelude",
    "// -------",
    "data List { #Nil #Cons{head tail} }",
    "data Nat { #Z #S{n} }",
    "data Pair { #P{fst snd} }",
    "@fix(&f) = (f @fix(f))",
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
compileFn book nam tm = "@" ++ (hvmNam nam) ++ " = " ++ HVM.showCore (termToHVM MS.empty (elimCubical book tm))

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


termToHVM :: MS.Map Name HVM.Name -> Term -> HVM.Core
termToHVM ctx tm = go tm where
  subst a f = f (Var a 0)

  go (Var n i) =
    case MS.lookup n ctx of
      Just n  -> HVM.Var n
      Nothing -> HVM.Var n
  go (Ref k)      = HVM.Ref (hvmNam k) 0 [] -- TODO: Ref arguments
  go (Sub t)      = termToHVM ctx t
  go (Fix n f)    = HVM.Ref "fix" 0 [HVM.Lam ('&':n) (termToHVM (MS.insert n n ctx) (f (Var n 0)))]
  go (Let v f)    = HVM.App (termToHVM ctx f) (termToHVM ctx v)
  go Set          = HVM.Era
  go (Chk v t)    = termToHVM ctx v
  go Emp          = HVM.Era
  go (EmpM x)     = HVM.Era
  go Uni          = HVM.Era
  go One          = HVM.U32 1
  go (UniM x f)   = termToHVM ctx f
  go Bit          = HVM.Era
  go Bt0          = HVM.U32 0
  go Bt1          = HVM.U32 1
  go (BitM x f t) = HVM.Mat HVM.SWI (termToHVM ctx x) [] [("0", [], termToHVM ctx f), ("_", [], termToHVM ctx t)]
  go Nat          = HVM.Era
  go Zer          = HVM.Ctr "#Z" []
  go (Suc p)      = HVM.Ctr "#S" [termToHVM ctx p]
  go (NatM x z s) = HVM.Mat (HVM.MAT 0) (termToHVM ctx x) [] [("#Z", [], termToHVM ctx z), ("#S", [], termToHVM ctx s)]
  go (Lst t)      = HVM.Era
  go Nil          = HVM.Ctr "#Nil" []
  go (Con h t)    = HVM.Ctr "#Cons" [termToHVM ctx h, termToHVM ctx t]
  go (LstM x n c) = HVM.Mat (HVM.MAT 0) (termToHVM ctx x) [] [("#Nil", [], termToHVM ctx n), ("#Cons", [], termToHVM ctx c)]
  go (Enu s)      = HVM.Era
  go (Sym s)      = error "TODO: bare Sym toHVM"
  go (EnuM x c e) = error "TODO: bare EnuM toHVM"
  go (Log s x)    = termToHVM ctx x  -- For HVM, just return the result expression
  go (Num _)      = HVM.Era
  go (Val (U64_V v)) = HVM.U32 (fromIntegral v)
  go (Val (I64_V v)) = HVM.Era
  go (Val (F64_V v)) = HVM.Era
  go (Val (CHR_V c)) = HVM.Chr c
  go (Op2 o a b)  = op2ToHVM o a b where
    op2ToHVM ADD a b = HVM.Op2 HVM.OP_ADD (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM SUB a b = HVM.Op2 HVM.OP_SUB (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM MUL a b = HVM.Op2 HVM.OP_MUL (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM DIV a b = HVM.Op2 HVM.OP_DIV (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM MOD a b = HVM.Op2 HVM.OP_MOD (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM POW a b = error "TODO"
    op2ToHVM EQL a b = HVM.Op2 HVM.OP_EQ  (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM NEQ a b = HVM.Op2 HVM.OP_NE  (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM LST a b = HVM.Op2 HVM.OP_LT  (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM GRT a b = HVM.Op2 HVM.OP_GT  (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM LEQ a b = HVM.Op2 HVM.OP_LTE (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM GEQ a b = HVM.Op2 HVM.OP_GTE (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM AND a b = HVM.Op2 HVM.OP_AND (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM OR  a b = HVM.Op2 HVM.OP_OR  (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM XOR a b = HVM.Op2 HVM.OP_XOR (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM SHL a b = HVM.Op2 HVM.OP_LSH (termToHVM ctx a) (termToHVM ctx b)
    op2ToHVM SHR a b = HVM.Op2 HVM.OP_RSH (termToHVM ctx a) (termToHVM ctx b)
  go (Op1 o a)    = op1ToHVM o a where
    op1ToHVM NOT = error "TODO"
    op1ToHVM NEG = error "TODO"
  go (Sig _ _)    = HVM.Era
  go (Tup x y) = case extractCtr x y of
      Just (k, x) -> HVM.Ctr ('#':hvmNam k) (map (termToHVM ctx) x)
      Nothing     -> HVM.Ctr "#P" [termToHVM ctx x, termToHVM ctx y]
    where 
      extractCtr (Sym k) y = 
        case unsnoc (flattenTup y) of
          Just (xs, One) -> Just (k, xs)
          _              -> Nothing
      extractCtr _ _ = Nothing
  go (SigM x f)  = case extractCtrM f of
      Just (cs,t,b,d) -> HVM.Let HVM.LAZY t (termToHVM ctx x) (matToHVM ctx t b cs d) -- TODO: Default case should rewrite (ctrNam, ctrBod) to the default case var
      Nothing         -> HVM.Mat (HVM.MAT 0) (termToHVM ctx x) [] [("#P", [], termToHVM ctx f)]
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
      matToHVM ctx t b [(ctr,fds,bod)]    d = mkIfl t ctr (termToHVM ctx bod) fds d' -- Make dflt case match entire ctr, not just the tag
                                     where d' = (rewriteHVM (HVM.Ctr "#P" [HVM.Var t, HVM.Var b]) (HVM.Var t) (termToHVM ctx d))
      matToHVM ctx t b ((ctr,fds,bod):cs) d = mkIfl t ctr (termToHVM ctx bod) fds (matToHVM ctx t b cs d)
      matToHVM _ _ _ _ _ = error "matToHVM: unreachable"

      mkIfl x ctr bod fds d = HVM.Mat (HVM.IFL 0) (HVM.Var x) [] [('#':hvmNam ctr, [], foldr HVM.Lam bod (map ('&':) (reverse fds))), (('&':x), [], d)]
  go (All _ _)    = HVM.Era
  go (Lam n f)    = HVM.Lam ('&':n) (termToHVM (MS.insert n n ctx) (f (Var n 0)))
  go (App f x)    = HVM.App (termToHVM ctx f) (termToHVM ctx x)
  go (Eql _ _ _)  = HVM.Era
  go Rfl          = HVM.Era
  go (EqlM x f)   = termToHVM ctx f
  go (Met n t ts) = HVM.Era -- TODO: Met
  go (Ind t)      = termToHVM ctx t
  go (Frz t)      = termToHVM ctx t
  go Era          = HVM.Era
  go (Sup l a b)  = HVM.Ref "SUP" 0 [termToHVM ctx l, termToHVM ctx a, termToHVM ctx b]
  go (SupM x l f) = HVM.Ref "DUP" 0 [termToHVM ctx l, termToHVM ctx x, termToHVM ctx f]
  go (Frk l a b)  = tmLab where
    -- Only fork variables free in the bodies of a and b
    tmLab             = HVM.Let HVM.STRI "&L$" (termToHVM ctx l) tmDup 
    tmDup             = foldr dup tmSup vars
    tmSup             = HVM.Ref "SUP" 0 [HVM.Var "L$", termToHVM ctxA a, termToHVM ctxB b]
    dup (_,v,(a,b)) x = HVM.Ref "DUP" 0 [HVM.Var "L$", HVM.Var v, HVM.Lam ('&':a) (HVM.Lam ('&':b) x)]
    vars              = [(k, v, (suff v "0", suff v "1")) | (k, v) <- MS.toList ctx, k `S.member` free]
    free              = freeVars S.empty a `S.union` freeVars S.empty b
    suff v s          = if "$$" `isInfixOf` v then v ++ s else v ++ "$$" ++ s
    ctxA              = MS.fromList [(k, a) | (k, _, (a, _)) <- vars]
    ctxB              = MS.fromList [(k, b) | (k, _, (_, b)) <- vars]
  go (Loc s t)    = termToHVM ctx t
  go (Rwt _ _ x)  = termToHVM ctx x
  go (Pri p)      = HVM.Era
  go (Pat x m c)  = HVM.Era
  -- cubical layer, native lowering.  The interval is a runtime u32 (i0=0,
  -- i1=1); a path lambda is a lambda over it; path application is
  -- application; a Path TYPE and a bare universe path (ua) are erased like
  -- every other type former.  Coe/HCm are reduced away by elimCubical before
  -- lowering; if one reaches here it is genuinely stuck, and we say so.
  go Itv          = HVM.Era
  go I0           = HVM.U32 0
  go I1           = HVM.U32 1
  go (INot r)     = HVM.Op2 HVM.OP_SUB (HVM.U32 1) (termToHVM ctx r)
  go (IAnd a b)   = HVM.Op2 HVM.OP_AND (termToHVM ctx a) (termToHVM ctx b)
  go (IOr a b)    = HVM.Op2 HVM.OP_OR  (termToHVM ctx a) (termToHVM ctx b)
  go (Pth _ _ _)  = HVM.Era
  go (PLm k f)    = HVM.Lam ('&':k) (termToHVM (MS.insert k k ctx) (f (Var k 0)))
  go (PAp p r)    = HVM.App (termToHVM ctx p) (termToHVM ctx r)
  go (Ua _ _ _ _ _ _) = HVM.Era
  go t@(Coe {})   = error ("toHVM: stuck transport (no reduction rule fired), refusing to erase: " ++ show t)
  go t@(HCm {})   = error ("toHVM: stuck hcomp (no reduction rule fired), refusing to erase: " ++ show t)

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
  Pri _      -> S.empty
  Pat s m c  -> error "TODO: Pat"
