{-./Type.hs-}

{-# LANGUAGE ViewPatterns #-}

module Core.WHNF where

import Debug.Trace

import Core.Type

import System.IO.Unsafe
import Data.IORef
import Data.Bits
import GHC.Float (castDoubleToWord64, castWord64ToDouble)

-- Evaluation
-- ==========

data EvalLevel
  = Soft
  | Full
  deriving (Show,Eq)

-- Levels:
-- - 0: undo ugly forms
-- - 1: full evaluation

-- Reduction
whnf :: EvalLevel -> Book -> Term -> Term
whnf lv book term
  | lv == Soft && ugly nf = term
  | otherwise             = nf
  where nf = whnfGo lv book term

whnfGo :: EvalLevel -> Book -> Term -> Term
whnfGo lv book term =
  case term of
    Let v f    -> whnfLet lv book v f
    Ref k      -> whnfRef lv book k
    Fix k f    -> whnfFix lv book k f
    Chk x _    -> whnf lv book x
    App f x    -> whnfApp lv book f x
    Loc _ t    -> whnf lv book t
    Op2 o a b  -> whnfOp2 lv book o a b
    Op1 o a    -> whnfOp1 lv book o a
    Pri p      -> Pri p
    UniM x f   -> whnfUniM lv book x f
    BitM x f t -> whnfBitM lv book x f t
    NatM x z s -> whnfNatM lv book x z s
    LstM x n c -> whnfLstM lv book x n c
    EnuM x c f -> whnfEnuM lv book x c f
    SigM x f   -> whnfSigM lv book x f
    EqlM x f   -> whnfEqlM lv book x f
    SupM x l f -> whnfSupM lv book x l f
    Log s x    -> whnfLog lv book s x
    PAp f x    -> whnfPAp lv book f x
    Coe pp r t x -> whnfCoe lv book pp r t x
    HCm a r u0 u1 x -> whnfHCm lv book a r u0 u1 x
    INot a     -> whnfINot lv book a
    IAnd a b   -> whnfIAnd lv book a b
    IOr a b    -> whnfIOr lv book a b
    _          -> term

-- Normalizes a let binding
whnfPAp :: EvalLevel -> Book -> Term -> Term -> Term
whnfPAp lv book p r =
  case whnf lv book p of
    PLm _ f      -> whnf lv book (f r)
    Ua a b f g gf fg -> case whnf lv book r of
      I0 -> whnf lv book a
      I1 -> whnf lv book b
      r' -> PAp (Ua a b f g gf fg) r'
    p'           -> PAp p' r

-- The interval marker used to inspect a type line's dependency on its
-- interval variable. Never escapes: used only for coe dispatch.
coeMarker :: Term
coeMarker = Var "__coe_i__" (-1)

isCoeMarker :: Term -> Bool
isCoeMarker (Var "__coe_i__" (-1)) = True
isCoeMarker _                      = False

-- Does the marker occur in a term? (Traverses HOAS bodies with dummy vars.)
occursMarker :: Term -> Bool
occursMarker t = go t where
  go x = case x of
    Var "__coe_i__" (-1) -> True
    Var _ _    -> False
    Ref _      -> False
    Sub a      -> go a
    Fix k f    -> go (f (Var k 0))
    Let v f    -> go v || go f
    Set        -> False
    Chk a b    -> go a || go b
    Emp        -> False
    EmpM a     -> go a
    Uni        -> False
    One        -> False
    UniM a b   -> go a || go b
    Bit        -> False
    Bt0        -> False
    Bt1        -> False
    BitM a b c -> go a || go b || go c
    Nat        -> False
    Zer        -> False
    Suc n      -> go n
    NatM a b c -> go a || go b || go c
    Lst a      -> go a
    Nil        -> False
    Con a b    -> go a || go b
    LstM a b c -> go a || go b || go c
    Enu _      -> False
    Sym _      -> False
    EnuM a cs e -> go a || any (go . snd) cs || go e
    Sig a b    -> go a || go b
    Tup a b    -> go a || go b
    SigM a b   -> go a || go b
    All a b    -> go a || go b
    Lam k f    -> go (f (Var k 0))
    App a b    -> go a || go b
    Eql a b c  -> go a || go b || go c
    Rfl        -> False
    EqlM a b   -> go a || go b
    Met _ a xs -> go a || any go xs
    Ind a      -> go a
    Frz a      -> go a
    Era        -> False
    Sup a b c  -> go a || go b || go c
    SupM a b c -> go a || go b || go c
    Frk a b c  -> go a || go b || go c
    Num _      -> False
    Val _      -> False
    Op2 _ a b  -> go a || go b
    Op1 _ a    -> go a
    Pri _      -> False
    Loc _ a    -> go a
    Rwt a b c  -> go a || go b || go c
    Log a b    -> go a || go b
    Pat _ _ _  -> False
    Itv        -> False
    I0         -> False
    I1         -> False
    INot a     -> go a
    IAnd a b   -> go a || go b
    IOr a b    -> go a || go b
    Pth a b c  -> go a || go b || go c
    PLm k f    -> go (f (Var k 0))
    PAp a b    -> go a || go b
    Coe a b c d2 -> go a || go b || go c || go d2
    HCm a b c d2 e2 -> go a || go b || go c || go d2 || go e2
    Ua a b c d2 e2 f2 -> go a || go b || go c || go d2 || go e2 || go f2

-- hcomp (binary system): if the face direction is an endpoint, the
-- composite is the corresponding side's cap; otherwise neutral.
whnfHCm :: EvalLevel -> Book -> Term -> Term -> Term -> Term -> Term -> Term
whnfHCm lv book a r u0 u1 x =
  case whnf lv book r of
    I0 -> whnf lv book (PAp u0 I1)
    I1 -> whnf lv book (PAp u1 I1)
    r' -> HCm a r' u0 u1 x

-- coe: generalized transport along a type line P from r to s.
whnfCoe :: EvalLevel -> Book -> Term -> Term -> Term -> Term -> Term
whnfCoe lv book pP r s t =
  let r' = whnf lv book r
      s' = whnf lv book s
  in if sameEnd r' s'
    then whnf lv book t
    else
      let body = normal 0 book (App pP coeMarker) in
      if not (occursMarker body)
        -- regularity: constant line, coe is the identity
        then whnf lv book t
        else case body of
          -- Pi: transport the argument backwards, the result forwards
          All _ _ ->
            let domAt i = case whnf Full book (App pP i) of { All a _ -> a ; _ -> App pP i }
                domLn   = Lam "i" (\i -> domAt i)
                codAt i x = case whnf Full book (App pP i) of
                  All _ (Lam _ bf) -> bf (Coe domLn s' i x)
                  All _ bfn        -> App bfn (Coe domLn s' i x)
                  _                -> App pP i
            in Lam "x" (\x -> Coe (Lam "i" (\i -> codAt i x)) r' s' (App t (Coe domLn s' r' x)))
          -- Sigma: transport components, second along the filled first
          Sig _ _ ->
            case whnf lv book t of
              Tup a b ->
                let fstAt i = case whnf Full book (App pP i) of { Sig a' _ -> a' ; _ -> App pP i }
                    fstLn   = Lam "i" (\i -> fstAt i)
                    sndAt i = case whnf Full book (App pP i) of
                      Sig _ (Lam _ bf) -> bf (Coe fstLn r' i a)
                      Sig _ bfn        -> App bfn (Coe fstLn r' i a)
                      _                -> App pP i
                in Tup (Coe fstLn r' s' a) (Coe (Lam "i" (\i -> sndAt i)) r' s' b)
              t' -> Coe pP r' s' t'
          -- ua: the line is a univalence path; apply the function
          PAp u m | isCoeMarker m ->
            case whnf Full book u of
              Ua _ _ f g _ _ -> case (r', s') of
                (I0, I1) -> whnf lv book (App f t)
                (I1, I0) -> whnf lv book (App g t)
                _        -> Coe pP r' s' t
              _ -> Coe pP r' s' t
          -- Path family: transport a path p : Path (A i) (u i) (v i) along
          -- the line by conjugating with the coerced endpoints. The result at
          -- s must have boundary (v-line s .. ) fixed, so we hcomp the coerced
          -- path against the two endpoint-coercion sides.  A i, u i, v i are
          -- read from the line; the base is the pointwise-coerced path, and the
          -- side lines carry the endpoints back to the s-fibre.
          Pth _ _ _ ->
            let aAt  i = case whnf Full book (App pP i) of { Pth a _ _ -> a ; x -> x }
                uAt  i = case whnf Full book (App pP i) of { Pth _ u _ -> u ; x -> x }
                vAt  i = case whnf Full book (App pP i) of { Pth _ _ v -> v ; x -> x }
                aLn    = Lam "i" (\i -> aAt i)
                -- the carried path, coerced pointwise into the s-fibre type
                base j = Coe aLn r' s' (PAp t j)
                -- endpoint correction sides: coe of the family's declared
                -- endpoints from an interior point to s
                sideL k = Coe (Lam "i" (\i -> aAt i)) k s' (uAt k)
                sideR k = Coe (Lam "i" (\i -> aAt i)) k s' (vAt k)
            in PLm "j" (\j ->
                 HCm (aAt s') s'
                   (PLm "k" (\k -> sideL k))
                   (PLm "k" (\k -> sideR k))
                   (base j))
          -- superposed line: dup the value at the label, transport each
          -- universe along its own line, resuperpose (fibre-exact routing)
          Sup _ _ _ ->
            let labAt = case body of { Sup l _ _ -> l ; _ -> body }
                aAt i = case whnf Full book (App pP i) of { Sup _ a _ -> a ; x -> x }
                bAt i = case whnf Full book (App pP i) of { Sup _ _ b -> b ; x -> x }
                (t0, t1) = dup book labAt t
            in Sup labAt (Coe (Lam "i" (\i -> aAt i)) r' s' t0)
                         (Coe (Lam "i" (\i -> bAt i)) r' s' t1)
          -- rigid inductives and Set: identity
          Nat     -> whnf lv book t
          Bit     -> whnf lv book t
          Uni     -> whnf lv book t
          Emp     -> whnf lv book t
          Enu _   -> whnf lv book t
          Num _   -> whnf lv book t
          Set     -> whnf lv book t
          Itv     -> whnf lv book t
          -- lists: map coe over canonical spines
          Lst _ ->
            let elAt i = case whnf Full book (App pP i) of { Lst e -> e ; _ -> App pP i }
                elLn   = Lam "i" (\i -> elAt i)
            in case whnf lv book t of
              Nil      -> Nil
              Con h tl -> Con (Coe elLn r' s' h) (Coe pP r' s' tl)
              t'       -> Coe pP r' s' t'
          _ -> Coe pP r' s' t
  where
    sameEnd I0 I0 = True
    sameEnd I1 I1 = True
    sameEnd (Var _ a) (Var _ b) = a == b
    sameEnd _ _   = False

whnfINot :: EvalLevel -> Book -> Term -> Term
whnfINot lv book a =
  case whnf lv book a of
    I0      -> I1
    I1      -> I0
    INot a' -> a'
    a'      -> INot a'

whnfIAnd :: EvalLevel -> Book -> Term -> Term -> Term
whnfIAnd lv book a b =
  case whnf lv book a of
    I0 -> I0
    I1 -> whnf lv book b
    a' -> case whnf lv book b of
      I0 -> I0
      I1 -> a'
      b' -> IAnd a' b'

whnfIOr :: EvalLevel -> Book -> Term -> Term -> Term
whnfIOr lv book a b =
  case whnf lv book a of
    I1 -> I1
    I0 -> whnf lv book b
    a' -> case whnf lv book b of
      I1 -> I1
      I0 -> a'
      b' -> IOr a' b'

whnfLet :: EvalLevel -> Book -> Term -> Term -> Term
whnfLet lv book v f = whnf lv book (App f v)

-- Normalizes a reference
whnfRef :: EvalLevel -> Book -> Name -> Term
whnfRef lv book k =
  case deref book k of
    Just (False, term, _) -> whnf lv book term
    otherwise             -> Ref k

-- Normalizes a fixpoint
whnfFix :: EvalLevel -> Book -> String -> Body -> Term
whnfFix lv book k f = whnf lv book (f (Fix k f))

-- Normalizes an application
whnfApp :: EvalLevel -> Book -> Term -> Term -> Term
whnfApp lv book f x =
  case whnf lv book f of
    Lam _ f'  -> whnfAppLam lv book f' x
    Pri p     -> whnfAppPri lv book p x
    Sup l a b -> whnfAppSup lv book l a b x
    Frk _ _ _ -> error "unrechable"
    f'        -> App f' x

-- Normalizes a lambda application
whnfAppLam :: EvalLevel -> Book -> Body -> Term -> Term
whnfAppLam lv book f x = whnf lv book (f x)

-- (&L{a b} x)
-- ----------------- APP-SUP
-- ! &L{x0 x1} = x
-- &L{(a x0) (b x1)}
whnfAppSup :: EvalLevel -> Book -> Term -> Term -> Term -> Term -> Term
whnfAppSup lv book l a b x = whnf lv book $ Sup l (App a x0) (App b x1)
  where (x0,x1) = dup book l x

-- Eliminator normalizers
-- ----------------------

-- Normalizes a unit match
whnfUniM :: EvalLevel -> Book -> Term -> Term -> Term
whnfUniM lv book x f =
  case whnf lv book x of
    One -> whnf lv book f
    Sup l a b -> whnf lv book $ Sup l (UniM a f0) (UniM b f1)
      where (f0, f1) = dup book l f
    x'  -> UniM x' f

-- Normalizes a boolean match
whnfBitM :: EvalLevel -> Book -> Term -> Term -> Term -> Term
whnfBitM lv book x f t =
  case whnf lv book x of
    Bt0 -> whnf lv book f
    Bt1 -> whnf lv book t
    Sup l a b -> whnf lv book $ Sup l (BitM a f0 t0) (BitM b f1 t1)
      where (f0, f1) = dup book l f
            (t0, t1) = dup book l t
    x'  -> BitM x' f t

-- Normalizes a natural number match
whnfNatM :: EvalLevel -> Book -> Term -> Term -> Term -> Term
whnfNatM lv book x z s =
  case whnf lv book x of
    Zer   -> whnf lv book z
    Suc n -> whnf lv book (App s (whnf lv book n))
    Sup l a b -> whnf lv book $ Sup l (NatM a z0 s0) (NatM b z1 s1)
      where (z0,z1) = dup book l z
            (s0,s1) = dup book l s
    x'    -> NatM x' z s

-- Normalizes a list match
whnfLstM :: EvalLevel -> Book -> Term -> Term -> Term -> Term
whnfLstM lv book x n c =
  case whnf lv book x of
    Nil     -> whnf lv book n
    Con h t -> whnf lv book (App (App c (whnf lv book h)) (whnf lv book t))
    Sup l a b -> whnf lv book $ Sup l (LstM a n0 c0) (LstM b n1 c1)
      where (n0,n1) = dup book l n
            (c0,c1) = dup book l c
    x'      -> LstM x' n c

-- Normalizes a pair match
whnfSigM :: EvalLevel -> Book -> Term -> Term -> Term
whnfSigM lv book x f =
  case whnf lv book x of
    Tup a b -> whnf lv book (App (App f (whnf lv book a)) (whnf lv book b))
    Sup l a b -> whnf lv book $ Sup l (SigM a f0) (SigM b f1)
      where (f0, f1) = dup book l f
    x'      -> SigM x' f

-- Normalizes an enum match
whnfEnuM :: EvalLevel -> Book -> Term -> [(String,Term)] -> Term -> Term
whnfEnuM lv book x c f =
  case whnf lv book x of
    Sym s -> case lookup s c of
      Just t  -> whnf lv book t
      Nothing -> whnf lv book (App f (Sym s))
    Sup l a b -> whnf lv book $ Sup l (EnuM a c0 f0) (EnuM b c1 f1)
      where (c0, c1) = unzip (map (\(s,t) -> let (t0,t1) = dup book l t in ((s,t0),(s,t1))) c)
            (f0, f1) = dup book l f
    x' -> EnuM x' c f

-- Normalizes an equality match
whnfEqlM :: EvalLevel -> Book -> Term -> Term -> Term
whnfEqlM lv book x f =
  case whnf lv book x of
    Rfl -> whnf lv book f
    Sup l a b -> whnf lv book $ Sup l (EqlM a f0) (EqlM b f1)
      where (f0, f1) = dup book l f
    x' -> EqlM x' f

-- Normalizes a superposition match
whnfSupM :: EvalLevel -> Book -> Term -> Term -> Term -> Term
whnfSupM lv book x l f = whnf lv book (App (App f x0) x1) where
    (x0, x1) = dup book l (whnf lv book x)

-- Normalizes a log operation
whnfLog :: EvalLevel -> Book -> Term -> Term -> Term
whnfLog lv book s x =
  let extractString :: Term -> Maybe String
      extractString Nil = Just ""
      extractString (Con (Val (CHR_V c)) rest) = do
        restStr <- extractString (whnf lv book rest)
        return (c : restStr)
      extractString (Loc _ t) = extractString t
      extractString _ = Nothing
  in case extractString (whnf lv book s) of
       Just str -> trace str (whnf lv book x)
       Nothing  -> whnf lv book x

-- Normalizes a primitive application
whnfAppPri :: EvalLevel -> Book -> PriF -> Term -> Term
whnfAppPri lv book p x =
  case whnf lv book x of
    Sup l a b -> whnf lv book $ Sup l (App (Pri p) a) (App (Pri p) b)
    x' -> case (p, x') of
      (U64_TO_CHAR, Val (U64_V n)) -> Val (CHR_V (toEnum (fromIntegral n)))
      _ -> App (Pri p) x'

-- Numeric operations
-- ------------------

whnfOp2 :: EvalLevel -> Book -> NOp2 -> Term -> Term -> Term
whnfOp2 lv book op a b =
  let a' = whnf lv book a in
  case a' of
    Sup l a0 a1 -> whnf lv book $ Sup l (Op2 op a0 b0) (Op2 op a1 b1)
      where (b0, b1) = dup book l b
    _ -> let b' = whnf lv book b in
      case b' of
        Sup l b0 b1 -> whnf lv book $ Sup l (Op2 op a'0 b0) (Op2 op a'1 b1)
          where (a'0, a'1) = dup book l a'
        _ -> case (a', b') of
          -- Bool operations
          (Bt0, Bt0) -> case op of
            AND -> Bt0; OR  -> Bt0; XOR -> Bt0; EQL -> Bt1; NEQ -> Bt0
            _   -> Op2 op a' b'
          (Bt0, Bt1) -> case op of
            AND -> Bt0; OR  -> Bt1; XOR -> Bt1; EQL -> Bt0; NEQ -> Bt1
            _   -> Op2 op a' b'
          (Bt1, Bt0) -> case op of
            AND -> Bt0; OR  -> Bt1; XOR -> Bt1; EQL -> Bt0; NEQ -> Bt1
            _   -> Op2 op a' b'
          (Bt1, Bt1) -> case op of
            AND -> Bt1; OR  -> Bt1; XOR -> Bt0; EQL -> Bt1; NEQ -> Bt0
            _   -> Op2 op a' b'
          -- Numeric operations
          (Val (U64_V x), Val (U64_V y)) -> case op of
            ADD -> Val (U64_V (x + y))
            SUB -> Val (U64_V (x - y))
            MUL -> Val (U64_V (x * y))
            DIV -> if y == 0 then Op2 op a' b' else Val (U64_V (x `div` y))
            MOD -> if y == 0 then Op2 op a' b' else Val (U64_V (x `mod` y))
            EQL -> if x == y then Bt1 else Bt0
            NEQ -> if x /= y then Bt1 else Bt0
            LST -> if x < y then Bt1 else Bt0
            GRT -> if x > y then Bt1 else Bt0
            LEQ -> if x <= y then Bt1 else Bt0
            GEQ -> if x >= y then Bt1 else Bt0
            AND -> Val (U64_V (x .&. y))
            OR  -> Val (U64_V (x .|. y))
            XOR -> Val (U64_V (x `xor` y))
            SHL -> Val (U64_V (x `shiftL` fromIntegral y))
            SHR -> Val (U64_V (x `shiftR` fromIntegral y))
            POW -> Val (U64_V (x ^ y))
          (Val (I64_V x), Val (I64_V y)) -> case op of
            ADD -> Val (I64_V (x + y))
            SUB -> Val (I64_V (x - y))
            MUL -> Val (I64_V (x * y))
            DIV -> if y == 0 then Op2 op a' b' else Val (I64_V (x `div` y))
            MOD -> if y == 0 then Op2 op a' b' else Val (I64_V (x `mod` y))
            EQL -> if x == y then Bt1 else Bt0
            NEQ -> if x /= y then Bt1 else Bt0
            LST -> if x < y then Bt1 else Bt0
            GRT -> if x > y then Bt1 else Bt0
            LEQ -> if x <= y then Bt1 else Bt0
            GEQ -> if x >= y then Bt1 else Bt0
            AND -> Val (U64_V (fromIntegral x .&. fromIntegral y))
            OR  -> Val (U64_V (fromIntegral x .|. fromIntegral y))
            XOR -> Val (U64_V (fromIntegral x `xor` fromIntegral y))
            SHL -> Val (U64_V (fromIntegral x `shiftL` fromIntegral y))
            SHR -> Val (U64_V (fromIntegral x `shiftR` fromIntegral y))
            POW -> Val (I64_V (x ^ y))
          (Val (F64_V x), Val (F64_V y)) -> case op of
            ADD -> Val (F64_V (x + y))
            SUB -> Val (F64_V (x - y))
            MUL -> Val (F64_V (x * y))
            DIV -> Val (F64_V (x / y))
            MOD -> Op2 op a' b'
            EQL -> if x == y then Bt1 else Bt0
            NEQ -> if x /= y then Bt1 else Bt0
            LST -> if x < y then Bt1 else Bt0
            GRT -> if x > y then Bt1 else Bt0
            LEQ -> if x <= y then Bt1 else Bt0
            GEQ -> if x >= y then Bt1 else Bt0
            AND -> Val (U64_V (castDoubleToWord64 x .&. castDoubleToWord64 y))
            OR  -> Val (U64_V (castDoubleToWord64 x .|. castDoubleToWord64 y))
            XOR -> Val (U64_V (castDoubleToWord64 x `xor` castDoubleToWord64 y))
            SHL -> Val (U64_V (castDoubleToWord64 x `shiftL` fromIntegral (castDoubleToWord64 y)))
            SHR -> Val (U64_V (castDoubleToWord64 x `shiftR` fromIntegral (castDoubleToWord64 y)))
            POW -> Val (F64_V (x ** y))
          (Val (CHR_V x), Val (CHR_V y)) -> case op of
            ADD -> Val (CHR_V (toEnum (fromEnum x + fromEnum y)))
            SUB -> Val (CHR_V (toEnum (fromEnum x - fromEnum y)))
            MUL -> Val (CHR_V (toEnum (fromEnum x * fromEnum y)))
            DIV -> if fromEnum y == 0 then Op2 op a' b' else Val (CHR_V (toEnum (fromEnum x `div` fromEnum y)))
            MOD -> if fromEnum y == 0 then Op2 op a' b' else Val (CHR_V (toEnum (fromEnum x `mod` fromEnum y)))
            EQL -> if x == y then Bt1 else Bt0
            NEQ -> if x /= y then Bt1 else Bt0
            LST -> if x < y then Bt1 else Bt0
            GRT -> if x > y then Bt1 else Bt0
            LEQ -> if x <= y then Bt1 else Bt0
            GEQ -> if x >= y then Bt1 else Bt0
            POW -> Val (CHR_V (toEnum ((fromEnum x) ^ (fromEnum y))))
            _   -> Op2 op a' b'
          _ -> Op2 op a' b'

whnfOp1 :: EvalLevel -> Book -> NOp1 -> Term -> Term
whnfOp1 lv book op a =
  case whnf lv book a of
    Sup l a0 a1 -> whnf lv book $ Sup l (Op1 op a0) (Op1 op a1)
    a' -> case a' of
      -- Bool operations
      Bt0 -> case op of
        NOT -> Bt1
        _   -> Op1 op a'
      Bt1 -> case op of
        NOT -> Bt0
        _   -> Op1 op a'
      -- Numeric operations
      Val (U64_V x) -> case op of
        NOT -> Val (U64_V (complement x))
        NEG -> Op1 op a'
      Val (I64_V x) -> case op of
        NOT -> Val (U64_V (complement (fromIntegral x)))
        NEG -> Val (I64_V (-x))
      Val (F64_V x) -> case op of
        NOT -> Val (U64_V (complement (castDoubleToWord64 x)))
        NEG -> Val (F64_V (-x))
      _ -> Op1 op a'

-- Duplication
-- -----------

dup :: Book -> Term -> Term -> (Term, Term)
dup book l (Var k i)    = (Var k i, Var k i)
dup book l (Ref k)      = (Ref k, Ref k)
dup book l (Sub x)      = (Sub x, Sub x)
dup book l (Fix k f)    = dup book l (f (Fix k f))
dup book l (Let v f)    = (Let v0 f0, Let v1 f1)
  where (v0,v1)         = dup book l v
        (f0,f1)         = dup book l f
dup book l Set          = (Set, Set)
dup book l (Chk x t)    = (Chk x0 t0, Chk x1 t1)
  where (x0,x1)         = dup book l x
        (t0,t1)         = dup book l t
dup book l Emp          = (Emp, Emp)
dup book l (EmpM x)     = (EmpM x0, EmpM x1)
  where (x0,x1)         = dup book l x
dup book l Uni          = (Uni, Uni)
dup book l One          = (One, One)
dup book l (UniM x f)   = (UniM x0 f0, UniM x1 f1)
  where (x0,x1)         = dup book l x
        (f0,f1)         = dup book l f
dup book l Bit          = (Bit, Bit)
dup book l Bt0          = (Bt0, Bt0)
dup book l Bt1          = (Bt1, Bt1)
dup book l (BitM x f t) = (BitM x0 f0 t0, BitM x1 f1 t1)
  where (x0,x1)         = dup book l x
        (f0,f1)         = dup book l f
        (t0,t1)         = dup book l t
dup book l Nat          = (Nat, Nat)
dup book l Zer          = (Zer, Zer)
dup book l (Suc n)      = (Suc n0, Suc n1)
  where (n0,n1)         = dup book l n
dup book l (NatM x z s) = (NatM x0 z0 s0, NatM x1 z1 s1)
  where (x0,x1)         = dup book l x
        (z0,z1)         = dup book l z
        (s0,s1)         = dup book l s
dup book l (Lst t)      = (Lst t0, Lst t1)
  where (t0,t1)         = dup book l t
dup book l Nil          = (Nil, Nil)
dup book l (Con h t)    = (Con h0 t0, Con h1 t1)
  where (h0,h1)         = dup book l h
        (t0,t1)         = dup book l t
dup book l (LstM x n c) = (LstM x0 n0 c0, LstM x1 n1 c1)
  where (x0,x1)         = dup book l x
        (n0,n1)         = dup book l n
        (c0,c1)         = dup book l c
dup book l (Enu s)      = (Enu s, Enu s)
dup book l (Sym s)      = (Sym s, Sym s)
dup book l (EnuM x c e) = (EnuM x0 c0 e0, EnuM x1 c1 e1)
  where (x0,x1)         = dup book l x
        (c0,c1)         = unzip (map (\(s,t) -> let (t0,t1) = dup book l t in ((s,t0),(s,t1))) c)
        (e0,e1)         = dup book l e
dup book l (Sig a b)    = (Sig a0 b0, Sig a1 b1)
  where (a0,a1)         = dup book l a
        (b0,b1)         = dup book l b
dup book l (Tup a b)    = (Tup a0 b0, Tup a1 b1)
  where (a0,a1)         = dup book l a
        (b0,b1)         = dup book l b
dup book l (SigM x f)   = (SigM x0 f0, SigM x1 f1)
  where (x0,x1)         = dup book l x
        (f0,f1)         = dup book l f
dup book l (All a b)    = (All a0 b0, All a1 b1)
  where (a0,a1)         = dup book l a
        (b0,b1)         = dup book l b
dup book l (Lam k f)    = (lam0, lam1)
  where lam0            = Lam k $ \x -> fst (dup book l (f x))
        lam1            = Lam k $ \x -> snd (dup book l (f x))
dup book l (App f x)    = (App f0 x0, App f1 x1)
  where (f0,f1)         = dup book l f
        (x0,x1)         = dup book l x
dup book l (Eql t a b)  = (Eql t0 a0 b0, Eql t1 a1 b1)
  where (t0,t1)         = dup book l t
        (a0,a1)         = dup book l a
        (b0,b1)         = dup book l b
dup book l Rfl          = (Rfl, Rfl)
dup book l (EqlM x f)   = (EqlM x0 f0, EqlM x1 f1)
  where (x0,x1)         = dup book l x
        (f0,f1)         = dup book l f
dup book l (Ind t)      = (Ind t0, Ind t1)
  where (t0,t1)         = dup book l t
dup book l (Frz t)      = (Frz t0, Frz t1)
  where (t0,t1)         = dup book l t
dup book l Itv          = (Itv, Itv)
dup book l I0           = (I0, I0)
dup book l I1           = (I1, I1)
dup book l (INot a)     = (INot a0, INot a1)
  where (a0,a1)         = dup book l a
dup book l (IAnd a b)   = (IAnd a0 b0, IAnd a1 b1)
  where (a0,a1)         = dup book l a
        (b0,b1)         = dup book l b
dup book l (IOr a b)    = (IOr a0 b0, IOr a1 b1)
  where (a0,a1)         = dup book l a
        (b0,b1)         = dup book l b
dup book l (Pth t a b)  = (Pth t0 a0 b0, Pth t1 a1 b1)
  where (t0,t1)         = dup book l t
        (a0,a1)         = dup book l a
        (b0,b1)         = dup book l b
dup book l (PLm k f)    = (plm0, plm1)
  where plm0            = PLm k $ \x -> fst (dup book l (f x))
        plm1            = PLm k $ \x -> snd (dup book l (f x))
dup book l (PAp f x)    = (PAp f0 x0, PAp f1 x1)
  where (f0,f1)         = dup book l f
        (x0,x1)         = dup book l x
dup book l (Coe p r s t) = (Coe p0 r0 s0 t0, Coe p1 r1 s1 t1)
  where (p0,p1)         = dup book l p
        (r0,r1)         = dup book l r
        (s0,s1)         = dup book l s
        (t0,t1)         = dup book l t
dup book l (HCm a r u0 u1 x) = (HCm a0 r0 u00 u10 x0, HCm a1 r1 u01 u11 x1)
  where (a0,a1)          = dup book l a
        (r0,r1)          = dup book l r
        (u00,u01)        = dup book l u0
        (u10,u11)        = dup book l u1
        (x0,x1)          = dup book l x
dup book l (Ua a b f g gf fg) = (Ua a0 b0 f0 g0 gf fg, Ua a1 b1 f1 g1 gf fg)
  where (a0,a1)         = dup book l a
        (b0,b1)         = dup book l b
        (f0,f1)         = dup book l f
        (g0,g1)         = dup book l g
dup book l Era          = (Era, Era)
dup book l (Sup r a b)
  | ieql book l r       = (a, b)
  | otherwise           = (Sup r a0 b0, Sup r a1 b1)
  where (a0,a1)         = dup book l a
        (b0,b1)         = dup book l b
dup book l (SupM x r f) = dup book l (App (App f x0) x1)
  where (x0,x1)         = dup book r x
dup book l (Met k t c)  = (Met k t0 c0, Met k t1 c1)
  where (t0,t1)         = dup book l t
        (c0,c1)         = unzip (map (dup book l) c)
dup book l (Loc s t)    = (Loc s t0, Loc s t1)
  where (t0,t1)         = dup book l t
dup book l (Rwt a b x)  = (Rwt a0 b0 x0, Rwt a1 b1 x1)
  where (a0,a1)         = dup book l a
        (b0,b1)         = dup book l b
        (x0,x1)         = dup book l x
dup book l (Num t)      = (Num t, Num t)
dup book l (Val v)      = (Val v, Val v)
dup book l (Op2 o a b)  = (Op2 o a0 b0, Op2 o a1 b1)
  where (a0,a1)         = dup book l a
        (b0,b1)         = dup book l b
dup book l (Op1 o a)    = (Op1 o a0, Op1 o a1)
  where (a0,a1)         = dup book l a
dup book l (Pri p)      = (Pri p, Pri p)
dup book l (Log s x)    = (Log s0 x0, Log s1 x1)
  where (s0,s1)         = dup book l s
        (x0,x1)         = dup book l x
dup book l (Frk _ _ _)  = error "unreachable"
dup book l (Pat _ _ _)  = error "unreachable"





-- Normalization
-- =============

normal :: Int -> Book -> Term -> Term
normal d book term =
  -- trace ("normal: " ++ show ++ " " ++ show term) $
  case whnf Soft book term of
    Var k i    -> Var k i
    Ref k      -> Ref k
    Sub t      -> t
    Fix k f    -> Fix k (\x -> normal (d+1) book (f (Sub x)))
    Let v f    -> Let (normal d book v) (normal d book f)
    Set        -> Set
    Chk x t    -> Chk (normal d book x) (normal d book t)
    Emp        -> Emp
    EmpM x     -> EmpM (normal d book x)
    Uni        -> Uni
    One        -> One
    UniM x f   -> UniM (normal d book x) (normal d book f)
    Bit        -> Bit
    Bt0        -> Bt0
    Bt1        -> Bt1
    BitM x f t -> BitM (normal d book x) (normal d book f) (normal d book t)
    Nat        -> Nat
    Zer        -> Zer
    Suc n      -> Suc (normal d book n)
    NatM x z s -> NatM (normal d book x) (normal d book z) (normal d book s)
    Lst t      -> Lst (normal d book t)
    Nil        -> Nil
    Con h t    -> Con (normal d book h) (normal d book t)
    LstM x n c -> LstM (normal d book x) (normal d book n) (normal d book c)
    Enu s      -> Enu s
    Sym s      -> Sym s
    EnuM x c e -> EnuM (normal d book x) (map (\(s, t) -> (s, normal d book t)) c) (normal d book e)
    Sig a b    -> Sig (normal d book a) (normal d book b)
    Tup a b    -> Tup (normal d book a) (normal d book b)
    SigM x f   -> SigM (normal d book x) (normal d book f)
    All a b    -> All (normal d book a) (normal d book b)
    Lam k f    -> Lam k (\x -> normal d book (f (Sub x)))
    App f x    -> foldl (\f' x' -> App f' (normal d book x')) fn xs
      where (fn,xs) = collectApps (App f x) []
    Eql t a b  -> Eql (normal d book t) (normal d book a) (normal d book b)
    Rfl        -> Rfl
    EqlM x f   -> EqlM (normal d book x) (normal d book f)
    Ind t      -> Ind (normal d book t)
    Frz t      -> Frz (normal d book t)
    Loc l t    -> Loc l (normal d book t)
    Rwt a b x  -> Rwt (normal d book a) (normal d book b) (normal d book x)
    Log s x    -> Log (normal d book s) (normal d book x)
    Itv        -> Itv
    I0         -> I0
    I1         -> I1
    INot a     -> INot (normal d book a)
    IAnd a b   -> IAnd (normal d book a) (normal d book b)
    IOr a b    -> IOr (normal d book a) (normal d book b)
    Pth t a b  -> Pth (normal d book t) (normal d book a) (normal d book b)
    PLm k f    -> PLm k (\x -> normal d book (f (Sub x)))
    PAp f x    -> PAp (normal d book f) (normal d book x)
    Coe p r s t -> Coe (normal d book p) (normal d book r) (normal d book s) (normal d book t)
    Ua a b f g gf fg -> Ua (normal d book a) (normal d book b) (normal d book f) (normal d book g) (normal d book gf) (normal d book fg)
    HCm a r u0 u1 x -> HCm (normal d book a) (normal d book r) (normal d book u0) (normal d book u1) (normal d book x)
    Era        -> Era
    Sup l a b  -> Sup l (normal d book a) (normal d book b)
    SupM x l f -> SupM (normal d book x) (normal d book l) (normal d book f)
    Frk l a b  -> error "Fork interactions unsupported in Haskell"
    Num t      -> Num t
    Val v      -> Val v
    Op2 o a b  -> Op2 o (normal d book a) (normal d book b)
    Op1 o a    -> Op1 o (normal d book a)
    Pri p      -> Pri p
    Met _ _ _  -> error "not-supported"
    Pat _ _ _  -> error "not-supported"

normalCtx :: Int -> Book -> Ctx -> Ctx
normalCtx d book (Ctx ctx) = Ctx (map normalAnn ctx)
  where normalAnn (k,v,t) = (k, normal d book v, normal d book t)

-- Utils
-- =====

-- Shapes that are rolled back for pretty printing
-- This is safe because these terms are stuck
ugly :: Term -> Bool
ugly (cut -> UniM _ _  ) = True
ugly (cut -> BitM _ _ _) = True
ugly (cut -> NatM _ _ _) = True
ugly (cut -> LstM _ _ _) = True
ugly (cut -> EnuM _ _ _) = True
ugly (cut -> SigM _ _  ) = True
ugly (cut -> EqlM _ _  ) = True
ugly _                   = False

-- Evaluates terms that whnf won't, including:
-- - Type decorations like Ind/Frz
-- - Injective Refs (whnf skips them for pretty printing)
force :: Book -> Term -> Term
force book term =
  case whnf Full book term of
    Ind t -> force book t
    Frz t -> force book t
    term' -> case fn of
      Ref k -> case deref book k of
        Just (_,fn',_) -> force book $ foldl App fn' xs
        otherwise      -> term'
      _ -> term'
      where (fn,xs) = collectApps term' []

-- Converts a term to an Int
termToInt :: Book -> Term -> Maybe Int
termToInt book term = go term where
    go (whnf Full book -> Zer)           = Just 0
    go (whnf Full book -> Suc n)         = fmap (+1) (go n)
    go (whnf Full book -> Val (U64_V w)) = Just (fromIntegral w)
    go (whnf Full book -> Val (I64_V i)) = Just (fromIntegral i)
    go (whnf Full book -> Val (F64_V d)) = Just (truncate d)
    go (whnf Full book -> Val (CHR_V c)) = Just (fromEnum c)
    go _                                 = Nothing

-- Compares the Int value of two terms
ieql :: Book -> Term -> Term -> Bool
ieql book a b = case (termToInt book a, termToInt book b) of
  (Just x, Just y) -> x == y
  _                -> False
