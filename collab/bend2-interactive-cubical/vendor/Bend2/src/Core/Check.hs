{-./Type.hs-}

{-# LANGUAGE ViewPatterns #-}

module Core.Check where

import qualified Data.Map as M
import Data.List (find)

import Debug.Trace

import Core.Equal
import Core.Rewrite
import Data.List (tails)
import Core.Type
import Core.WHNF

-- Context
-- -------

extend :: Ctx -> Name -> Term -> Term -> Ctx
extend (Ctx ctx) k v t = Ctx (ctx ++ [(k, v, t)])

format :: Int -> Book -> Term -> Term
format d book x = normalCap 48 d book $ x
-- format d book x = x

formatCtx :: Int -> Book -> Ctx -> Ctx
formatCtx d book (Ctx ctx) = Ctx (map formatAnn ctx)
  where formatAnn (k,v,t) = (k, format d book v, format d book t)

-- Type Checker
-- ------------

-- Infer the type of a term
infer :: Int -> Span -> Book -> Ctx -> Term -> Result Term
infer d span book@(Book defs _) ctx term =
  -- trace ("- infer: " ++ show (format d book term)) $
  case term of
    Var _ i -> do
      let Ctx ks = ctx
      if i < length ks
        then let (_, _, typ) = ks !! i
             in Done typ
        else Fail $ CantInfer span (formatCtx d book ctx)
    Ref k -> do
      case deref book k of
        Just (_, _, typ) -> Done typ
        Nothing          -> Fail $ CantInfer span (formatCtx d book ctx)
    Sub x -> do
      infer d span book ctx x
    Let v f -> do
      infer d span book ctx (App f v)
    Fix k f -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    -- `@c{as}::T(ps)` on a constructor of a parametric HIT supplies the
    -- parameters (the annotation names the HIT, not the constructor's type)
    Chk v t | HCon tn c [] as ivs <- cut v, Just (tn', h, _) <- derefCtor book c, tn' == tn, hitArity h > 0 ->
      case force book t of
        HTy tn'' ps | tn'' == tn -> infer d span book ctx (HCon tn c ps as ivs)
        _ -> do
          check d span book ctx v t
          Done t
    Chk v t -> do
      check d span book ctx v t
      Done t
    Set -> do
      Done Set
    Emp -> do
      Done Set
    EmpM _ -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Uni -> do
      Done Set
    One -> do
      Done Uni
    UniM _ _ -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Bit -> do
      Done Set
    Bt0 -> do
      Done Bit
    Bt1 -> do
      Done Bit
    BitM _ _ _ -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Nat -> do
      Done Set
    Zer -> do
      Done Nat
    Suc n -> do
      nT <- infer d span book ctx n
      case force book nT of
        Nat ->
          Done $ Nat
        Eql Nat a b ->
          Done $ Eql Nat (Suc a) (Suc b)
        _ ->
          Fail $ TypeMismatch span (formatCtx d book ctx) (format d book Nat) (format d book nT)
    NatM _ _ _ -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Lst t -> do
      check d span book ctx t Set
      Done Set
    Nil -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Con h t -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    LstM _ _ _ -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Enu s -> do
      Done Set
    Sym s -> do
      let bookEnums = [ Enu tags | (k, (_, (Sig (Enu tags) _), Set)) <- M.toList defs ]
      case find isEnuWithTag bookEnums of
        Just t  -> Done t
        Nothing -> Fail $ CantInfer span (formatCtx d book ctx)
        where
          isEnuWithTag (Enu tags) = s `elem` tags
          isEnuWithTag _ = False
    EnuM _ _ _ -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Sig a b -> do
      check d span book ctx a Set
      check d span book ctx b (All a (Lam "_" (\_ -> Set)))
      Done Set
    Tup a b -> do
      aT <- infer d span book ctx a
      bT <- infer d span book ctx b
      Done $ Sig aT (Lam "_" (\_ -> bT))
    SigM _ _ -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    All a b -> do
      check d span book ctx a Set
      check d span book ctx b (All a (Lam "_" (\_ -> Set)))
      Done Set
    Lam _ _ -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Itv -> do
      Done Set
    I0 -> do
      Done Itv
    I1 -> do
      Done Itv
    INot r -> do
      check d span book ctx r Itv
      Done Itv
    IAnd r s -> do
      check d span book ctx r Itv
      check d span book ctx s Itv
      Done Itv
    IOr r s -> do
      check d span book ctx r Itv
      check d span book ctx s Itv
      Done Itv
    Pth t a b -> do
      check d span book ctx t (All Itv (Lam "_" (\_ -> Set)))
      check d span book ctx a (App t I0)
      check d span book ctx b (App t I1)
      Done Set
    Coe pP r s t -> do
      check d span book ctx pP (All Itv (Lam "_" (\_ -> Set)))
      check d span book ctx r Itv
      check d span book ctx s Itv
      check d span book ctx t (epNormCtx d book ctx (App pP r))
      Done (epNormCtx d book ctx (App pP s))
    Ua a b f g gf fg -> do
      check d span book ctx a Set
      check d span book ctx b Set
      check d span book ctx f (All a (Lam "_" (\_ -> b)))
      check d span book ctx g (All b (Lam "_" (\_ -> a)))
      check d span book ctx gf (All a (Lam "x" (\x -> Pth (Lam "_" (\_ -> a)) (App g (App f x)) x)))
      check d span book ctx fg (All b (Lam "y" (\y -> Pth (Lam "_" (\_ -> b)) (App f (App g y)) y)))
      Done (Pth (Lam "_" (\_ -> Set)) a b)
    Glu a fs -> do
      -- Glue A [(φ,T,e)] : Set.  A : Set; on extent φ a partial type T : Set
      -- and its forward map e : T -> A (the equivalence's function; the
      -- coherence obligation on e is a partial-element condition not typed here).
      check d span book ctx a Set
      mapM_ (\(p,t,e) -> do
        check d span book ctx p Itv
        check d span book ctx t Set
        check d span book ctx e (equivTy t a)) fs
      Done Set
    GlB a fs x -> do
      -- glue A [(φ,t)] x is checked against its Glue type; it is inferable
      -- only when every face is false (then it is just x : A)
      check d span book ctx x a
      mapM_ (\(p,_) -> check d span book ctx p Itv) fs
      if all (\(p,_) -> case force book p of { I0 -> True; _ -> False }) fs
        then Done a
        else Fail $ CantInfer span (formatCtx d book ctx)
    UnG g -> do
      gT <- infer d span book ctx g
      case force book gT of
        Glu a _ -> Done a
        gT'     -> Done gT'   -- a Glue with no live faces IS its base type; unglue is the identity there
    -- Sub(A, φ, u) : Set — the restricted type A[φ ↦ u] (CCHM)
    Rst a p u -> do
      check d span book ctx a Set
      check d span book ctx p Itv
      -- the partial element need only be defined on φ, so it is checked at A
      -- restricted to each cell of φ
      mapM_ (\lits -> check d span book ctx (restrictLits d book lits u)
                                             (restrictLits d book lits a))
            (faceDNF p)
      Done Set
    -- Propositional truncation ||A|| and its constructors
    Tru a -> do
      check d span book ctx a Set
      Done Set
    TIn a -> do
      aT <- infer d span book ctx a
      Done (Tru aT)
    TSq x y -> do
      xT <- infer d span book ctx x
      check d span book ctx y xT
      Done (Pth (Lam "_" (\_ -> xT)) x y)
    -- trec x pB f : B  —  f : A -> B and pB : isProp B, which is what makes
    -- the squash path's image forced.
    TRec x pb f -> do
      fT <- infer d span book ctx f
      case force book fT of
        All aT (Lam _ bf) -> do
          let bT = bf (Var "_trec" d)
          check d span book ctx x (Tru aT)
          check d span book ctx pb
            (All bT (Lam "u" (\u -> All bT (Lam "v" (\v ->
              Pth (Lam "_" (\_ -> bT)) u v)))))
          Done bT
        All aT bfn -> do
          let bT = App bfn (Var "_trec" d)
          check d span book ctx x (Tru aT)
          Done bT
        fT' -> Fail $ TypeMismatch span (formatCtx d book ctx)
                        (format d book (All Set (Lam "_" (\_ -> Set)))) (format d book fT')
    -- The circle S1 and its constructors
    Cir   -> Done Set
    CBase -> Done Cir
    CLoop -> Done (Pth (Lam "_" (\_ -> Cir)) CBase CBase)
    -- S1.rec x b l : B  —  b : B, l : Path(B, b, b)
    CRec x b l -> do
      check d span book ctx x Cir
      bT <- infer d span book ctx b
      check d span book ctx l (Pth (Lam "_" (\_ -> bT)) b b)
      Done bT
    -- Partial(φ, A) : Set
    Prt p a -> do
      check d span book ctx p Itv
      check d span book ctx a Set
      Done Set
    -- a SYSTEM in an inferred position: its face is the join of its branches
    -- and its carrier is inferred from the first one. Against a known Partial
    -- type the `check` clause applies instead, where coverage is enforced.
    Sys fs -> case fs of
      [] -> Fail $ TypeMismatch span (formatCtx d book ctx)
                     (format d book (Prt I0 Set)) (format d book (Sys []))
      ((_, v0) : _) -> do
        a <- infer d span book ctx v0
        Done (Prt (foldr1 IOr (map fst fs)) a)
    -- pout(u) : A for u : Partial(φ, A) — legitimate only where φ holds, so
    -- the face is required to be true here.
    POut u -> do
      uT <- infer d span book ctx u
      case force book uT of
        Prt p a -> case whnf Soft book p of
          I1 -> Done a
          p' -> Fail $ TypeMismatch span (formatCtx d book ctx)
                         (format d book I1) (format d book p')
        uT' -> Done uT'
    -- transp(L, φ, x) : L(i1).  L must be CONSTANT on φ — checked cell by
    -- cell with the same marker-occurrence test `coe` uses for regularity.
    Trp l p x -> do
      check d span book ctx l (All Itv (Lam "_" (\_ -> Set)))
      check d span book ctx p Itv
      check d span book ctx x (App l I0)
      mapM_ (\lits ->
        let l' = restrictLits d book lits l
            body = normal 0 book (App l' coeMarker)
        in if occursMarker body
             then Fail $ TypeMismatch span (formatCtx d book ctx)
                    (format d book (App l' I0)) (format d book body)
             else Done ())
        (faceDNF p)
      Done (App l I1)
    -- inS(x) in an INFERRED position: the tightest type we can give it is the
    -- vacuously-restricted A[i0 ↦ x]. Against a known Sub type the `check`
    -- clause applies instead, and there the φ obligation is enforced.
    InS x -> do
      xT <- infer d span book ctx x
      Done (Rst xT I0 x)
    -- outS(s) : A  for  s : Sub(A, φ, u)
    OutS s -> do
      sT <- infer d span book ctx s
      case force book sT of
        Rst a _ _ -> Done a
        sT'       -> Done sT'
    Quo a r -> do
      -- A / R : Set.  A : Set, R : A -> A -> Set (a prop-valued equivalence
      -- relation; the equiv/prop obligations are discharged by the .bend proofs
      -- that build eq/ and use effectivity, not required at formation).
      check d span book ctx a Set
      check d span book ctx r (All a (Lam "_" (\_ -> All a (Lam "_" (\_ -> Set)))))
      Done Set
    HCm a fs x -> do
      check d span book ctx a Set
      check d span book ctx x a
      -- each tube u on face φ is a j-line in a whose j=i0 end agrees with
      -- the base on every cell of φ (DNF over interval literals)
      mapM_ (\(p, u) -> do
        check d span book ctx p Itv
        mapM_ (\lits ->
          -- restrict the tube, the base, AND the type to the cell: on a face
          -- like inot(i) the cell fixes i:=i0, so the tube's j=i0 end (and its
          -- type a) must be compared already substituted, not with a symbolic i.
          let a' = restrictLits d book lits a
              x' = restrictLits d book lits x
              u' = restrictLits d book lits u
          in check d span book ctx u' (Pth (Lam "_" (\_ -> a')) x' (PAp u' I1)))
          (faceDNF p)) fs
      -- adjacency: on every cell of φ ∧ ψ the two tubes must agree, so the
      -- reduction (any satisfied face wins) is order-independent
      mapM_ (\((p,u),(q,v)) ->
        mapM_ (\lits ->
          let u' = epNormCtx d book ctx (restrictLits d book lits u)
              v' = epNormCtx d book ctx (restrictLits d book lits v)
          in if equal d book u' v' then Done () else
               Fail $ TypeMismatch span (formatCtx d book ctx) (format d book u') (format d book v'))
          (faceDNF (IAnd p q))) (facePairs fs)
      Done a
    PLm _ _ -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    PAp p r -> do
      check d span book ctx r Itv
      case cut p of
        PLm _ f -> infer d span book ctx (f r)   -- beta: (<i> t) @ r
        _ -> do
          pT <- infer d span book ctx p
          case force book pT of
            Pth t a b -> Done (App t r)
            _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (Pth (Var "_" 0) (Var "_" 0) (Var "_" 0))) (format d book pT)
    App f x ->
      case f of
        Lam k body -> do
          xT <- infer d span book ctx x
          infer (d+1) span book (extend ctx k x xT) (body x)
        _ -> do
          fT <- infer d span book ctx f
          case force book fT of
            All fA fB -> do
              check d span book ctx x fA
              Done $ App fB x
            _ -> do
              Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (All (Var "_" 0) (Lam "_" (\_ -> Var "_" 0)))) (format d book fT)
    Eql t a b -> do
      check d span book ctx t Set
      check d span book ctx a t
      check d span book ctx b t
      Done Set
    Rfl -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    EqlM _ _ -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Ind _ -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Frz _ -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Loc l t ->
      infer d l book ctx t
    Rwt a b x ->
      Fail $ CantInfer span (formatCtx d book ctx)
    Era -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Sup l a b -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    SupM x l f -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Frk l a b -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Met _ _ _ -> do
      Fail $ CantInfer span (formatCtx d book ctx)
    Num _ -> do
      Done Set
    Val (U64_V _) -> do
      Done (Num U64_T)
    Val (I64_V _) -> do
      Done (Num I64_T)
    Val (F64_V _) -> do
      Done (Num F64_T)
    Val (CHR_V _) -> do
      Done (Num CHR_T)
    Op2 op a b -> do
      ta <- infer d span book ctx a
      tb <- infer d span book ctx b
      inferOp2Type d span book ctx op a b ta tb
    Op1 op a -> do
      ta <- infer d span book ctx a
      inferOp1Type d span book ctx op a ta
    Pri U64_TO_CHAR -> do
      Done (All (Num U64_T) (Lam "x" (\_ -> Num CHR_T)))
    Log s x -> do
      check d span book ctx s (Lst (Num CHR_T))
      infer d span book ctx x
    -- quotient point/path/truncation are check-mode (they need the quotient's
    -- R, which is not recoverable from the term alone); recursor too (needs B).
    QCl _ -> Fail $ CantInfer span (formatCtx d book ctx)
    QEq _ _ _ -> Fail $ CantInfer span (formatCtx d book ctx)
    QSq -> Fail $ CantInfer span (formatCtx d book ctx)
    QRec _ _ _ _ -> Fail $ CantInfer span (formatCtx d book ctx)
    -- General HITs. The type: parameters against the declared telescope.
    HTy t ps -> case derefHit book t of
      Nothing -> Fail $ CantInfer span (formatCtx d book ctx)
      Just h  -> do
        _ <- applyTele d span book ctx (hitType h) ps
        Done Set
    -- A constructor: its closed Pi-type applied to parameters and fields,
    -- then to the intervals given so far (each peels one Path).
    HCon t c ps as ivs -> case derefCtor book c of
      Just (t', h, k) | t' == t && length ps == hitArity h && length as == ctorNArgs k && length ivs <= ctorDim k -> do
        ty  <- applyTele d span book ctx (ctorType k) (ps ++ as)
        foldMR (\ty' i -> do
                  check d span book ctx i Itv
                  case force book ty' of
                    Pth l _ _ -> Done (App l i)
                    _ -> Fail $ CantInfer span (formatCtx d book ctx)) ty ivs
      _ -> Fail $ CantInfer span (formatCtx d book ctx)
    -- The dependent eliminator: motive over the HIT, one branch per
    -- constructor; a path constructor's branch is a PathP over the motive
    -- whose endpoints are the eliminator on the declared endpoints, so the
    -- boundary agreement is exactly the typed endpoint law.
    HEl p bs x -> do
      xT <- infer d span book ctx x
      case force book xT of
        HTy t ps | Just h <- derefHit book t -> do
          check d span book ctx p (All (HTy t ps) (Lam "_" (\_ -> Set)))
          checkBranches d span book ctx h t ps p (HEl p bs) bs
          Done (App p x)
        xT' -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (HTy "HIT" [])) (format d book xT')
    HRec _ _ -> Fail $ CantInfer span (formatCtx d book ctx)
    Pat _ _ _ -> do
      error "Pat not supported in infer"

-- Infer the result type of a binary numeric operation
inferOp2Type :: Int -> Span -> Book -> Ctx -> NOp2 -> Term -> Term -> Term -> Term -> Result Term
inferOp2Type d span book ctx op a b ta tb = do
  -- For arithmetic ops, both operands must have the same numeric type
  case op of
    ADD -> numericOp ta tb
    SUB -> numericOp ta tb
    MUL -> numericOp ta tb
    DIV -> numericOp ta tb
    MOD -> numericOp ta tb
    POW -> numericOp ta tb
    -- Comparison ops return Bool
    EQL -> comparisonOp ta tb
    NEQ -> comparisonOp ta tb
    LST -> comparisonOp ta tb
    GRT -> comparisonOp ta tb
    LEQ -> comparisonOp ta tb
    GEQ -> comparisonOp ta tb
    -- Bitwise/logical ops work on both integers and booleans
    AND -> boolOrIntegerOp ta tb
    OR  -> boolOrIntegerOp ta tb
    XOR -> boolOrIntegerOp ta tb
    SHL -> integerOp ta tb
    SHR -> integerOp ta tb
  where
    numericOp ta tb = case (force book ta, force book tb) of
      (Num t1, Num t2) | t1 == t2 -> Done (Num t1)
      _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (Ref "Num")) (format d book ta)
    
    comparisonOp ta tb = case (force book ta, force book tb) of
      (Num t1, Num t2) | t1 == t2 -> Done Bit
      (Bit, Bit) -> Done Bit  -- Allow Bool comparison
      _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book ta) (format d book tb)
    
    integerOp ta tb = case (force book ta, force book tb) of
      (Num U64_T, Num U64_T) -> Done (Num U64_T)
      (Num I64_T, Num I64_T) -> Done (Num U64_T)  -- Bitwise on I64 returns U64
      (Num F64_T, Num F64_T) -> Done (Num U64_T)  -- Bitwise on F64 returns U64
      (Num CHR_T, Num CHR_T) -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (Ref "Num")) (format d book ta)  -- Bitwise not supported for CHR
      _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (Ref "Num")) (format d book ta)
    
    boolOrIntegerOp ta tb = case (force book ta, force book tb) of
      (Bit, Bit) -> Done Bit  -- Logical operations on booleans
      (Num U64_T, Num U64_T) -> Done (Num U64_T)  -- Bitwise operations on integers
      (Num I64_T, Num I64_T) -> Done (Num U64_T)
      (Num F64_T, Num F64_T) -> Done (Num U64_T)
      _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book ta) (format d book tb)

-- Infer the result type of a unary numeric operation
inferOp1Type :: Int -> Span -> Book -> Ctx -> NOp1 -> Term -> Term -> Result Term
inferOp1Type d span book ctx op a ta = case op of
  NOT -> case force book ta of
    Bit       -> Done Bit  -- Logical NOT on Bool
    Num U64_T -> Done (Num U64_T)
    Num I64_T -> Done (Num U64_T)  -- Bitwise NOT on I64 returns U64
    Num F64_T -> Done (Num U64_T)  -- Bitwise NOT on F64 returns U64
    Num CHR_T -> Fail $ CantInfer span (formatCtx d book ctx)  -- Bitwise NOT not supported for CHR
    _         -> Fail $ CantInfer span (formatCtx d book ctx)
  NEG -> case force book ta of
    Num I64_T -> Done (Num I64_T)
    Num F64_T -> Done (Num F64_T)
    Num CHR_T -> Fail $ CantInfer span (formatCtx d book ctx)  -- Negation not supported for CHR
    _         -> Fail $ CantInfer span (formatCtx d book ctx)

-- Check if a term has the expected type
check :: Int -> Span -> Book -> Ctx -> Term -> Term -> Result ()
check d span book ctx term goal =
  -- trace ("- check: " ++ show (format d book term) ++ " :: " ++ show (format d book goal)) $
  case (term, force book goal) of
    (term, Rwt a b goal) -> do
      let new_ctx  = rewriteCtx 3 d book a b ctx
      let new_goal = rewrite 3 d book a b goal
      -- trace ("> REWRITE " ++ show (normal d book a) ++ " → " ++ show (normal d book b) ++ ":\n" ++
        -- "- ctx : " ++ show (normalCtx d book ctx) ++ " → " ++ show (normalCtx d book new_ctx) ++ "\n" ++
        -- "- goal: " ++ show (normal d book goal) ++ " → " ++ show (normal d book new_goal)) $
      check d span book new_ctx term new_goal
    (Era, _) -> do
      Done ()
    (Let v f, _) -> do
      check d span book ctx (App f v) goal
    (One, Uni) -> do
      Done ()
    (Bt0, Bit) -> do
      Done ()
    (Bt1, Bit) -> do
      Done ()
    (Zer, Nat) -> do
      Done ()
    (Suc n, Eql t (force book -> Suc a) (force book -> Suc b)) -> do
      check d span book ctx n (Eql t a b)
    (Suc n, Nat) -> do
      check d span book ctx n Nat
    (Nil, Lst _) -> do
      Done ()
    (Nil, goal) ->
      Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (Lst (Var "_" 0))) (format d book goal)
    (Con h t, Lst tT) -> do
      check d span book ctx h tT
      check d span book ctx t (Lst tT)
    (Lam k f, All a (Lam _ b)) -> do
      let x = Var k d
      check (d+1) span book (extend ctx k x a) (f x) (b x)
    (PLm k f, Pth t a b) -> do
      let x = Var k d
      check (d+1) span book (extend ctx k x Itv) (f x) (App t x)
      -- endpoints headed by a HIT constructor get the parameters from the line
      let nrm u = epNormCtx d book ctx (fillHit book (App t I0) u)
      if equal d book (nrm (f I0)) (nrm a)
        then if equal d book (nrm (f I1)) (nrm b)
          then Done ()
          else Fail $ TermMismatch span (formatCtx d book ctx) (format d book (nrm (f I1))) (format d book (nrm b))
        else Fail $ TermMismatch span (formatCtx d book ctx) (format d book (nrm (f I0))) (format d book (nrm a))
    (EmpM x, _) -> do
      xT <- infer d span book ctx x
      case force book xT of
        Emp -> do
          Done ()
        Eql t a b -> do
          check d span book ctx a t
          check d span book ctx b t
          if not (equal d book a b)
            then Done ()
            else Fail $ TermMismatch span (formatCtx d book ctx) (format d book a) (format d book b)
        _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book Emp) (format d book xT)
    (UniM x f, _) -> do
      xT <- infer d span book ctx x
      case force book xT of
        Uni -> do
          check d span book ctx f (Rwt x One goal)
        _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book Uni) (format d book xT)
    (BitM x f t, _) -> do
      xT <- infer d span book ctx x
      case force book xT of
        Bit -> do
          check d span book ctx f (Rwt x Bt0 goal)
          check d span book ctx t (Rwt x Bt1 goal)
        _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book Bit) (format d book xT)
    (NatM x z s, _) -> do
      xT <- infer d span book ctx x
      case force book xT of
        Nat -> do
          check d span book ctx z (Rwt x Zer goal)
          check d span book ctx s $ All Nat (Lam "p" (\p -> Rwt x (Suc p) goal))
        _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book Nat) (format d book xT)
    (LstM x n c, _) -> do
      xT <- infer d span book ctx x
      case force book xT of
        Lst a -> do
          check d span book ctx n (Rwt x Nil goal)
          check d span book ctx c $ All a (Lam "h" (\h -> All (Lst a) (Lam "t" (\t -> Rwt x (Con h t) goal))))
        _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (Lst (Var "_" 0))) (format d book xT)
    (Sym s, Enu y) -> do
      if s `elem` y
        then Done ()
        else Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (Enu y)) (format d book (Sym s))
    (EnuM x cs df, _) -> do
      xT <- infer d span book ctx x
      case force book xT of
        Enu syms -> do
          mapM_ (\(s, t) -> check d span book ctx t (Rwt x (Sym s) goal)) cs
          let covered_syms = map fst cs
          let all_covered = length covered_syms >= length syms
                         && all (`elem` syms) covered_syms
          if not all_covered
            then do
              case df of
                (cut -> Lam k (unlam k d -> One)) -> do
                  Fail $ IncompleteMatch span (formatCtx d book ctx)
                otherwise -> do
                  let enu_type = Enu syms
                  let lam_goal = All enu_type (Lam "_" (\v -> Rwt x v goal))
                  check d span book ctx df lam_goal
            else Done ()
        _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (Enu [])) (format d book xT)
    (SigM x f, _) -> do
      xT <- infer d span book ctx x
      case force book xT of
        Sig a b -> do
          check d span book ctx f $ All a (Lam "x" (\h -> All (App b h) (Lam "y" (\t -> Rwt x (Tup h t) goal))))
        _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (Sig (Var "_" 0) (Lam "_" (\_ -> Var "_" 0)))) (format d book xT)
    (Tup a b, Sig aT (Lam _ bT)) -> do
      check d span book ctx a aT
      check d span book ctx b (bT a)
    (Rfl, Eql t a b) -> do
      check d span book ctx a t
      check d span book ctx b t
      if equal d book a b
        then Done ()
        else Fail $ TermMismatch span (formatCtx d book ctx) (format d book a) (format d book b)
    (EqlM x f, _) -> do
      xT <- infer d span book ctx x
      case force book xT of
        Eql t a b -> do
          check d span book ctx f (Rwt x Rfl (Rwt a b goal))
        _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (Eql (Var "_" 0) (Var "_" 0) (Var "_" 0))) (format d book xT)
    (Fix k f, _) -> do
      check (d+1) span book (extend ctx k (Fix k f) goal) (f (Fix k f)) goal
    (Loc l t, _) -> do
      check d l book ctx t goal
    (Val (U64_V _), Num U64_T) -> do
      Done ()
    (Val (I64_V _), Num I64_T) -> do
      Done ()
    (Val (F64_V _), Num F64_T) -> do
      Done ()
    (Val (CHR_V _), Num CHR_T) -> do
      Done ()
    (Op2 op a b, _) -> do
      ta <- infer d span book ctx a
      tb <- infer d span book ctx b
      tr <- inferOp2Type d span book ctx op a b ta tb
      if equal d book tr goal
        then Done ()
        else Fail $ TypeMismatch span (formatCtx d book ctx) (format d book goal) (format d book tr)
    (Op1 op a, _) -> do
      ta <- infer d span book ctx a
      tr <- inferOp1Type d span book ctx op a ta
      if equal d book tr goal
        then Done ()
        else Fail $ TypeMismatch span (formatCtx d book ctx) (format d book goal) (format d book tr)
    (Sup l a b, Sup l2 ta tb) | equal d book l l2 -> do
      check d span book ctx a ta
      check d span book ctx b tb
    (Sup l a b, _) -> do
      check d span book ctx a goal
      check d span book ctx b goal
    (SupM x l f, _) -> do
      check d span book ctx l (Num U64_T)
      xT <- infer d span book ctx x
      check d span book ctx f (All xT (Lam "p" (\p -> All xT (Lam "q" (\q -> Rwt x (Sup l p q) goal)))))
    (Frk l a b, _) -> do
      check d span book ctx l (Num U64_T)
      check d span book ctx a goal
      check d span book ctx b goal
    (Pat _ _ _, _) -> do
      error "not-supported"
    -- (f x) :: G
    -- --------------------------------------------------- specialize
    -- f :: ∀(v : typeof x). (G where x is rewritten by v)
    (App f x, _) ->
      if isLamApp f
        then do
          case f of
            Lam k b -> do
              check d span book ctx (b x) goal
            f  -> do
              xt <- infer d span book ctx x
              check d span book ctx f $ All xt $ Lam "_" $ \v -> goal
        else do
          verify d span book ctx term goal
    -- glue A [(φ,t)] x : Glue A [(φ,T,e)] — each section t : T on its face,
    -- and coherent with the base there: fst(e) t ≡ x on every cell of φ
    -- A SYSTEM against Partial(φ, A): every branch is an A on its own cells,
    -- branches agree on overlaps, and the branches COVER φ.
    (Sys fs, force book -> Prt p a) -> do
      mapM_ (\(q, v) -> do
        check d span book ctx q Itv
        mapM_ (\lits -> check d span book ctx (restrictLits d book lits v)
                                              (restrictLits d book lits a))
              (faceDNF q)) fs
      mapM_ (\((q,v),(r,w)) ->
        mapM_ (\lits -> do
          let v' = epNormCtx d book ctx (restrictLits d book lits v)
              w' = epNormCtx d book ctx (restrictLits d book lits w)
          if equal d book v' w' then Done ()
            else Fail $ TypeMismatch span (formatCtx d book ctx)
                          (format d book v') (format d book w'))
          (faceDNF (IAnd q r)))
        [ (x1,y1) | (x1:ys) <- tails fs, y1 <- ys ]
      -- coverage: on every cell of φ some branch must be true
      mapM_ (\lits ->
        if any (\(q,_) -> case whnf Soft book (restrictLits d book lits q) of
                            I1 -> True ; _ -> False) fs
          then Done ()
          else Fail $ TypeMismatch span (formatCtx d book ctx)
                        (format d book I1) (format d book p))
        (faceDNF p)
      Done ()
    -- trec against a KNOWN goal B: take A from the scrutinee and check the
    -- branch and the propness witness against B. (The inferring rule needs
    -- f's type, which a bare lambda does not have.)
    (TRec x pb f, _) -> do
      xT <- infer d span book ctx x
      case force book xT of
        Tru aT -> do
          check d span book ctx f (All aT (Lam "_" (\_ -> goal)))
          check d span book ctx pb
            (All goal (Lam "u" (\u -> All goal (Lam "v" (\v ->
              Pth (Lam "_" (\_ -> goal)) u v)))))
          Done ()
        xT' -> Fail $ TypeMismatch span (formatCtx d book ctx)
                        (format d book (Tru Set)) (format d book xT')
    -- inS(x) : Sub(A, φ, u) — x : A, AND on every cell of φ, x is
    -- DEFINITIONALLY u. That obligation is what makes outS computable there.
    (InS x, force book -> Rst a p u) -> do
      check d span book ctx x a
      mapM_ (\lits -> do
        let x' = epNormCtx d book ctx (restrictLits d book lits x)
            u' = epNormCtx d book ctx (restrictLits d book lits u)
        if equal d book x' u'
          then Done ()
          else Fail $ TypeMismatch span (formatCtx d book ctx)
                        (format d book u') (format d book x'))
        (faceDNF p)
      Done ()
    (GlB a fs x, force book -> Glu a' gfs) -> do
      check d span book ctx a Set
      if not (equal d book a a') then Fail $ TypeMismatch span (formatCtx d book ctx) (format d book a') (format d book a) else Done ()
      check d span book ctx x a'
      mapM_ (\(p, t) -> do
        check d span book ctx p Itv
        case [ (tT, e) | (q, tT, e) <- gfs, iSyntEq (force book p) (force book q) ] of
          [] -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book goal) (format d book (GlB a fs x))
          ((tT, e) : _) -> do
            check d span book ctx t tT
            mapM_ (\lits ->
              let l = epNormCtx d book ctx (restrictLits d book lits (App (equivFun e) t))
                  r = epNormCtx d book ctx (restrictLits d book lits x)
              in if equal d book l r then Done () else
                   Fail $ TypeMismatch span (formatCtx d book ctx) (format d book r) (format d book l))
              (faceDNF p)) fs
    -- [a] : A / R  — the point constructor: a must live in the carrier.
    (QCl a, force book -> Quo aT _) ->
      check d span book ctx a aT
    -- eq/ a b w : Path (A/R) [a] [b] — the generator path.  Its line must be
    -- the constant quotient type; w witnesses R a b; endpoints are [a],[b].
    (QEq a b w, force book -> Pth p e0 e1) -> do
      let qt = epNormCtx d book ctx (App p I0)
      case force book qt of
        Quo aT r -> do
          check d span book ctx a aT
          check d span book ctx b aT
          check d span book ctx w (App (App r a) b)
          if equal d book e0 (QCl a) && equal d book e1 (QCl b)
            then Done ()
            else Fail $ TypeMismatch span (formatCtx d book ctx) (format d book goal) (format d book (QEq a b w))
        _ -> verify d span book ctx term goal
    -- squash/ : isSet (A/R) — the set-truncation.  Accepted only when the goal
    -- is the isSet Pi shape whose carrier is a quotient (isSet of a quotient is
    -- genuinely inhabited by this constructor); never against an arbitrary type.
    -- a constructor whose parameters were left to the goal: peel the goal's
    -- Path layers down to the HIT and read them off, then verify
    (HCon t c [] as ivs, _) | Just (t', h, k) <- derefCtor book c, t' == t, hitArity h > 0 -> do
      let peel :: Int -> Term -> Maybe Term
          peel 0 g = Just g
          peel n g = case force book (epNormCtx d book ctx g) of
            Pth l _ _ -> peel (n - 1) (App l I0)
            _         -> Nothing
      case peel (ctorDim k - length ivs) goal of
        Just g | HTy t'' ps <- force book g, t'' == t -> verify d span book ctx (HCon t c ps as ivs) goal
        _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (HTy t [])) (format d book goal)
    (PAp _ _, _) | (HCon t c [] as [], rs) <- collectPAps term [], Just (t', h, k) <- derefCtor book c, t' == t, hitArity h > 0 -> do
      let peel :: Int -> Term -> Maybe Term
          peel 0 g = Just g
          peel n g = case force book (epNormCtx d book ctx g) of
            Pth l _ _ -> peel (n - 1) (App l I0)
            _         -> Nothing
      case peel (ctorDim k - length rs) goal of
        Just g | HTy t'' ps <- force book g, t'' == t -> verify d span book ctx (foldl PAp (HCon t c ps as []) rs) goal
        _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (HTy t [])) (format d book goal)
    -- the recursor: the motive is constant at the goal
    (HRec bs x, _) -> do
      xT <- infer d span book ctx x
      case force book xT of
        HTy t ps | Just h <- derefHit book t -> checkBranches d span book ctx h t ps (Lam "_" (\_ -> goal)) (HRec bs) bs
        xT' -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (HTy "HIT" [])) (format d book xT')
    (QSq, _) -> case force book (epNormCtx d book ctx goal) of
      All x _ | (case force book x of { Quo _ _ -> True; _ -> False }) -> Done ()
      _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book goal) (format d book QSq)
    -- SQ.rec scrutinee setB f resp : B — checked against the result type B.
    (QRec x s f rsp, _) -> do
      xt <- infer d span book ctx x
      case force book xt of
        Quo aT r -> do
          _ <- infer d span book ctx s   -- setB : isSet B, the truncation evidence (not used computationally)
          check d span book ctx f (All aT (Lam "_" (\_ -> goal)))
          check d span book ctx rsp
            (All aT (Lam "a" (\a -> All aT (Lam "b" (\b ->
              All (App (App r a) b) (Lam "_" (\_ ->
                Pth (Lam "_" (\_ -> goal)) (App f a) (App f b))))))))
          Done ()
        _ -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (Quo (Set) (Set))) (format d book xt)
    (Log s x, _) -> do
      check d span book ctx s (Lst (Num CHR_T))
      check d span book ctx x goal
    (_, _) -> do
      verify d span book ctx term goal

-- Reduce endpoint applications (p @ i0, p @ i1) of path-typed context
-- variables to their endpoints. This provides the definitional boundary
-- equations that untyped conversion cannot see on neutral paths.
epNormCtx :: Int -> Book -> Ctx -> Term -> Term
epNormCtx d book ctx t0 = go t0 where
  go t = case t of
    HCm a fs x ->
      let fs' = [ (force book (go p), go u) | (p,u) <- fs ] in
      case [ u | (I1, u) <- fs' ] of
        (u : _) -> go (PAp u I1)
        []      -> HCm (go a) [ f | f@(p, _) <- fs', notI0 p ] (go x)
    PAp p r ->
      let p' = go p
          r' = go r
      in case (spineEndpoints d book ctx p', force book r') of
           (Just (x, _), I0) -> go x
           (Just (_, y), I1) -> go y
           _                 -> PAp p' r'
    -- A Ref-headed application is unfolded (force) so that endpoint
    -- redexes inside a lemma's body (e.g. t(x0) @ i1 under an hcomp face)
    -- are still reduced against the context; without this, conversion
    -- unfolds the Ref itself and never sees the typed endpoint law.
    App f x    ->
      let r = App (go f) (go x) in
      if unfoldable d book ctx r
        then case force book r of
               r' | refHeaded r' -> r'
                  -- ONE level only: the unfolded body is normalised without
                  -- further Ref unfolding, or a productive (corecursive)
                  -- definition such as  ones = Cons 1 ones  unfolds forever
                  | otherwise    -> goNoUnfold r'
        else r
    Tup a b    -> Tup (go a) (go b)
    SigM x f   -> SigM (go x) (go f)
    Suc n      -> Suc (go n)
    Con h tl   -> Con (go h) (go tl)
    INot a     -> INot (go a)
    IAnd a b   -> IAnd (go a) (go b)
    IOr a b    -> IOr (go a) (go b)
    Pth a x y  -> Pth (go a) (go x) (go y)
    Coe a r s x -> Coe (go a) (go r) (go s) (go x)
    Glu a fs   -> Glu (go a) [ (go p, go t, go e) | (p,t,e) <- fs ]
    GlB a fs x -> GlB (go a) [ (go p, go t) | (p,t) <- fs ] (go x)
    UnG g      -> UnG (go g)
    PLm k f    -> PLm k (\x -> go (f x))
    Lam k f    -> Lam k (\x -> go (f x))
    Sig a b    -> Sig (go a) (go b)
    All a b    -> All (go a) (go b)
    Eql a x y  -> Eql (go a) (go x) (go y)
    Loc l x    -> Loc l (go x)
    Chk x a    -> Chk (go x) (go a)
    _          -> t
  goNoUnfold t = case t of
    App f x    -> App (goNoUnfold f) (goNoUnfold x)
    Tup a b    -> Tup (goNoUnfold a) (goNoUnfold b)
    SigM x f   -> SigM (goNoUnfold x) (goNoUnfold f)
    Lam k f    -> Lam k (\x -> goNoUnfold (f x))
    PLm k f    -> PLm k (\x -> goNoUnfold (f x))
    PAp p r    -> let p' = goNoUnfold p; r' = goNoUnfold r in
                  case (spineEndpoints d book ctx p', force book r') of
                    (Just (x, _), I0) -> goNoUnfold x
                    (Just (_, y), I1) -> goNoUnfold y
                    _                 -> PAp p' r'
    Loc l x    -> Loc l (goNoUnfold x)
    _          -> t

refHeaded :: Term -> Bool
refHeaded t = case cut t of
  App f _ -> refHeaded f
  Ref _   -> True
  _       -> False

notI0 :: Term -> Bool
notI0 I0 = False
notI0 _  = True

-- The endpoints of a var- or Ref-headed spine of path type.
spineEndpoints :: Int -> Book -> Ctx -> Term -> Maybe (Term, Term)
spineEndpoints d book ctx p = do
  ty <- spineTy d book ctx p
  case force book ty of
    Pth _ x y -> Just (x, y)
    _         -> Nothing

-- The declared type of a var- or Ref-headed spine (context/book lookup,
-- peeling Pi and Path applications).
spineTy :: Int -> Book -> Ctx -> Term -> Maybe Term
spineTy d book (Ctx ks) = spineType
  where
    spineType t = case cut t of
      Var _ i | i < length ks -> let (_, _, ty) = ks !! i in Just ty
      Ref k -> do (_, _, ty) <- deref book k; Just ty
      App f x -> do
        fT <- spineType f
        case force book fT of
          All _ (Lam _ b) -> Just (b x)
          All _ b         -> Just (App b x)
          _               -> Nothing
      PAp q r -> do
        qT <- spineType q
        case force book qT of
          Pth a _ _ -> Just (App a r)
          _         -> Nothing
      _ -> Nothing

-- Unfold a Ref-headed application in epNormCtx only when it is saturated
-- (not a Pi) and not path-typed (where the endpoint law must stay visible).
unfoldable :: Int -> Book -> Ctx -> Term -> Bool
unfoldable d book ctx r = refHeaded r && case fmap (force book) (spineTy d book ctx r) of
  Just (Pth _ _ _) -> False
  Just (All _ _)   -> False
  _                -> True

-- Verify that a term has the expected type by inference
verify :: Int -> Span -> Book -> Ctx -> Term -> Term -> Result ()
verify d span book ctx term goal = do
  t <- infer d span book ctx term
  if equal d book t goal || equal d book (epNormCtx d book ctx t) (epNormCtx d book ctx goal)
    then Done ()
    else Fail $ TypeMismatch span (formatCtx d book ctx) (format d book goal) (format d book t)

-- Utils
-- -----

-- Check all definitions in a Book
checkBook :: Book -> Result ()
checkBook book@(Book defs _) = mapM_ checkDef (M.toList defs)
  where
    checkDef (name, (_, term, typ)) = do
      check 0 noSpan book (Ctx []) term typ

-- Utils
-- -----

isLamApp :: Term -> Bool
isLamApp (cut -> App f _)    = isLamApp f
isLamApp (cut -> Lam _ _)    = True
isLamApp (cut -> EmpM _)     = True
isLamApp (cut -> UniM _ _)   = True
isLamApp (cut -> BitM _ _ _) = True
isLamApp (cut -> NatM _ _ _) = True
isLamApp (cut -> LstM _ _ _) = True
isLamApp (cut -> EnuM _ _ _) = True
isLamApp (cut -> SigM _ _)   = True
isLamApp (cut -> EqlM _ _)   = True
isLamApp _                   = False


-- Cofibration faces.  A face formula φ over interval literals is put in
-- disjunctive normal form: a list of cells, each cell a conjunction of
-- literals (v := i0 / v := i1).  A boundary condition "on φ" is checked on
-- every cell by substituting the cell's literals (this is exactly the old
-- binary rule when φ is r or inot(r)).
faceDNF :: Term -> [[(Term, Term)]]
faceDNF t = filter consistent (go t) where
  go f = case f of
    Loc _ p        -> go p
    I1             -> [[]]
    I0             -> []
    INot p         -> goNot p
    IAnd p q       -> [ c1 ++ c2 | c1 <- go p, c2 <- go q ]
    IOr  p q       -> go p ++ go q
    v              -> [[(v, I1)]]
  goNot f = case f of
    Loc _ p        -> goNot p
    I1             -> []
    I0             -> [[]]
    INot p         -> go p
    IAnd p q       -> goNot p ++ goNot q                      -- De Morgan
    IOr  p q       -> [ c1 ++ c2 | c1 <- goNot p, c2 <- goNot q ]
    v              -> [[(v, I0)]]
  consistent cell = and [ not (sameVar v w) || sameEnd e f | (v,e) <- cell, (w,f) <- cell ]
  sameVar (Var _ i) (Var _ j) = i == j
  sameVar _ _                 = False
  sameEnd I0 I0 = True
  sameEnd I1 I1 = True
  sameEnd _  _  = False

-- substitute a cell's literals into a term
restrictLits :: Int -> Book -> [(Term, Term)] -> Term -> Term
restrictLits d book lits x = foldr (\(v, e) acc -> substVar v e acc) x lits

-- | Substitute a literal for an interval VARIABLE, syntactically.  The
-- variable is a binder of the current context, so it can only occur
-- syntactically; the semantic `rewrite` (whnf then recurse) would unfold a
-- recursive definition stuck on another variable at every level, forever
-- (an hcomp whose tube mentions a recursive definition never checked).
substVar :: Term -> Term -> Term -> Term
substVar (Var k i) e = go where
  go t = case t of
    Var k' i' | k' == k && i' == i -> e
    _ -> mapSub go t
substVar _ _ = id

facePairs :: [a] -> [(a, a)]
facePairs []       = []
facePairs (x : xs) = [ (x, y) | y <- xs ] ++ facePairs xs


-- General HITs
-- ============

foldMR :: (a -> b -> Result a) -> a -> [b] -> Result a
foldMR _ z []       = Done z
foldMR f z (x : xs) = f z x >>= \z' -> foldMR f z' xs

-- Apply a closed Pi-telescope to arguments, checking each against its
-- domain; returns the remaining type.
applyTele :: Int -> Span -> Book -> Ctx -> Term -> [Term] -> Result Term
applyTele d span book ctx = foldMR step where
  step ty x = case force book ty of
    All a b -> do
      check d span book ctx x a
      Done (appCod b x)
    ty' -> Fail $ TypeMismatch span (formatCtx d book ctx) (format d book (All (Var "_" 0) (Lam "_" (\_ -> Var "_" 0)))) (format d book ty')

-- Every declared constructor needs exactly one branch, of the type obtained
-- by mapping the motive through the constructor's Pi-type:
--   point  c : fields -> T          branch : fields -> P (c fields)
--   path   c : fields -> Path T a b  branch : fields -> PathP (i. P (c fields @ i)) (E a) (E b)
-- nested for higher dimensions, where E is this very eliminator (so a
-- branch may call its own definition on the endpoints and still convert).
checkBranches :: Int -> Span -> Book -> Ctx -> HitDecl -> Name -> [Term] -> Term -> (Term -> Term) -> [(Name, Term)] -> Result ()
checkBranches d span book ctx h t ps p elimTm bs = do
  mapM_ one (hitCtors h)
  mapM_ (\(c, _) -> if c `elem` map fst (hitCtors h) then Done () else Fail $ CantInfer span (formatCtx d book ctx)) bs
  where
    one (c, k) = case lookup c bs of
      Nothing -> Fail $ IncompleteMatch span (formatCtx d book ctx)
      Just b  -> do
        sigPs <- applyTele d span book ctx (ctorType k) ps
        check d span book ctx b (branchTy sigPs (ctorNArgs k) [])
        where
          branchTy ty 0 acc = etype ty (HCon t c ps acc [])
          branchTy ty n acc = case force book ty of
            All a bf -> All a (Lam "f" (\v -> branchTy (appCod bf v) (n - 1) (acc ++ [v])))
            ty'      -> ty'
    -- the type of E applied to u : ty
    etype ty u = case force book ty of
      Pth l a b -> Pth (Lam "i" (\i -> etype (App l i) (PAp u i))) (eterm (App l I0) a) (eterm (App l I1) b)
      _         -> App p u
    -- E applied to u : ty, as a term
    eterm ty u = case force book ty of
      Pth l _ _ -> PLm "j" (\j -> eterm (App l j) (PAp u j))
      _         -> elimTm u

-- a chain of path applications, head first
collectPAps :: Term -> [Term] -> (Term, [Term])
collectPAps (cut -> PAp p r) rs = collectPAps p (r : rs)
collectPAps p rs = (cut p, rs)

-- Fill the parameters of a constructor-headed term (possibly under path
-- applications) from a known type of that term.
fillHit :: Book -> Term -> Term -> Term
fillHit book ty u = case collectPAps u [] of
  (HCon t c [] as [], rs) | Just (_, h, k) <- derefCtor book c, hitArity h > 0 ->
    let peel :: Int -> Term -> Maybe Term
        peel 0 g = Just g
        peel n g = case force book g of
          Pth l _ _ -> peel (n - 1) (App l I0)
          _         -> Nothing
    in case peel (ctorDim k - length rs) ty of
         Just g | HTy t' ps <- force book g, t' == t -> foldl PAp (HCon t c ps as []) rs
         _ -> u
  _ -> u
