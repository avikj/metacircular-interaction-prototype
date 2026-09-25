{-./Type.hs-}

{-# LANGUAGE ViewPatterns #-}

module Core.Equal where

import System.IO.Unsafe
import Data.IORef
import Data.Bits
import GHC.Float (castDoubleToWord64, castWord64ToDouble)

import Core.Type
import Core.WHNF

-- Equality
-- ========

equal :: Int -> Book -> Term -> Term -> Bool
equal d book a b = eql 3 d book a b

eql :: Int -> Int -> Book -> Term -> Term -> Bool
eql lv d book a b | lv <= 0 = cmp 0 d book (cut a) (cut b)
eql lv d book a b = identical || sameHead || similar where
  identical = eql 0 d book a b
  -- two applications of the same global with convertible arguments are
  -- equal WITHOUT unfolding: unfolding a recursive type family (e.g. a
  -- depth-indexed Σ) on a variable depth regresses forever, one fresh
  -- variable per level, so it must be tried only after this
  -- The spine may mix ordinary and PATH applications (a recursive path
  -- lemma applied at an interval): without seeing through `@`, two spines
  -- differing only in a convertible argument get unfolded instead, and a
  -- recursive definition stuck on a variable regenerates the same shape one
  -- level deeper, forever.
  sameHead  = case (spineOf a, spineOf b) of
    ((Ref ka, xs), (Ref kb, ys)) ->
      ka == kb && not (null xs) && sameArgs xs ys
    _ -> False
  sameArgs xs ys = length xs == length ys && and (zipWith sameArg xs ys)
  sameArg (Left x) (Left y)   = eql lv d book x y
  sameArg (Right x) (Right y) = eql lv d book x y
  sameArg _ _                 = False
  spineOf t = go (cut t) [] where
    go (App f x) acc = go (cut f) (Left x : acc)
    go (PAp f x) acc = go (cut f) (Right x : acc)
    go h acc         = (h, acc)
  similar   = cmp lv d book (force book a) (force book b)

cmp :: Int -> Int -> Book -> Term -> Term -> Bool
cmp lv d book a b =
  case (a , b) of
    (Fix ka fa    , Fix kb fb    ) -> eql lv d book (fa (fb (Var ka d))) (fb (fa (Var kb d)))
    (Fix ka fa    , b            ) -> eql lv d book (fa b) b
    (a            , Fix kb fb    ) -> eql lv d book a (fb (Fix kb fb))
    (Ref ka       , Ref kb       ) -> ka == kb
    (Ref ka       , b            ) -> case unfoldRef book ka of { Just term -> eql lv d book term b ; Nothing -> False }
    (a            , Ref kb       ) -> case unfoldRef book kb of { Just term -> eql lv d book a term ; Nothing -> False }
    (Var ka ia    , Var kb ib    ) -> ia == ib
    (Sub ta       , Sub tb       ) -> eql lv d book ta tb
    (Let va fa    , Let vb fb    ) -> eql lv d book va vb && eql lv d book fa fb
    (Set          , Set          ) -> True
    (Chk xa ta    , Chk xb tb    ) -> eql lv d book xa xb && eql lv d book ta tb
    (Emp          , Emp          ) -> True
    (EmpM xa      , EmpM xb      ) -> eql lv d book xa xb
    (Uni          , Uni          ) -> True
    (One          , One          ) -> True
    (UniM xa fa   , UniM xb fb   ) -> eql lv d book xa xb && eql lv d book fa fb
    (Bit          , Bit          ) -> True
    (Bt0          , Bt0          ) -> True
    (Bt1          , Bt1          ) -> True
    (BitM xa fa ta, BitM xb fb tb) -> eql lv d book xa xb && eql lv d book fa fb && eql lv d book ta tb
    (Nat          , Nat          ) -> True
    (Zer          , Zer          ) -> True
    (Suc na       , Suc nb       ) -> eql lv d book na nb
    (NatM xa za sa, NatM xb zb sb) -> eql lv d book xa xb && eql lv d book za zb && eql lv d book sa sb
    (Lst ta       , Lst tb       ) -> eql lv d book ta tb
    (Nil          , Nil          ) -> True
    (Con ha ta    , Con hb tb    ) -> eql lv d book ha hb && eql lv d book ta tb
    (LstM xa na ca, LstM xb nb cb) -> eql lv d book xa xb && eql lv d book na nb && eql lv d book ca cb
    (Enu sa       , Enu sb       ) -> sa == sb
    (Sym sa       , Sym sb       ) -> sa == sb
    (EnuM xa ca da, EnuM xb cb db) -> eql lv d book xa xb && length ca == length cb && all (\ ((s1,t1), (s2,t2)) -> s1 == s2 && eql lv d book t1 t2) (zip ca cb) && eql lv d book da db
    (Sig aa ba    , Sig ab bb    ) -> eql lv d book aa ab && eql lv d book ba bb
    (Tup aa ba    , Tup ab bb    ) -> eql lv d book aa ab && eql lv d book ba bb
    -- Σ-η: (a,b) ≡ n  iff  a ≡ fst n and b ≡ snd n  (conversion is typed, so n : Σ)
    (Tup aa ba    , b2           ) -> eql lv d book aa (SigM b2 sigFst) && eql lv d book ba (SigM b2 sigSnd)
    (a2           , Tup ab bb    ) -> eql lv d book (SigM a2 sigFst) ab && eql lv d book (SigM a2 sigSnd) bb
    (SigM xa fa   , SigM xb fb   ) -> eql lv d book xa xb && eql lv d book fa fb
    (All aa ba    , All ab bb    ) -> eql lv d book aa ab && eql lv d book ba bb
    (Lam ka fa    , Lam kb fb    ) -> eql lv (d+1) book (fa (Var ka d)) (fb (Var kb d))
    (Lam ka fa    , b            ) -> eql lv (d+1) book (fa (Var ka d)) (App b (Var ka d))
    (a            , Lam kb fb    ) -> eql lv (d+1) book (App a (Var kb d)) (fb (Var kb d))
    (App fa xa    , App fb xb    ) -> eql lv d book fa fb && eql lv d book xa xb
    (Eql ta aa ba , Eql tb ab bb ) -> eql lv d book ta tb && eql lv d book aa ab && eql lv d book ba bb
    -- (Eql ta _  _  , b            ) -> eql lv d book ta b
    -- (a            , Eql tb _  _  ) -> eql lv d book a tb
    (Rfl          , Rfl          ) -> True
    (EqlM xa fa   , EqlM xb fb   ) -> eql lv d book xa xb && eql lv d book fa fb
    (Ind ta       , b            ) -> eql lv d book ta b
    (a            , Ind tb       ) -> eql lv d book a tb
    (Frz ta       , b            ) -> eql lv d book ta b
    (a            , Frz tb       ) -> eql lv d book a tb
    (Loc _ ta     , b            ) -> eql lv d book ta b
    (a            , Loc _ tb     ) -> eql lv d book a tb
    (Rwt _ _ xa   , _            ) -> eql lv d book xa b
    (_            , Rwt _ _ xb   ) -> eql lv d book a xb
    (Itv          , Itv          ) -> True
    (I0           , I0           ) -> True
    (I1           , I1           ) -> True
    (INot xa      , INot xb      ) -> eql lv d book xa xb
    (IAnd aa ba   , IAnd ab bb   ) -> eql lv d book aa ab && eql lv d book ba bb
    (IOr aa ba    , IOr ab bb    ) -> eql lv d book aa ab && eql lv d book ba bb
    (Pth ta aa ba , Pth tb ab bb ) -> eql lv d book ta tb && eql lv d book aa ab && eql lv d book ba bb
    (Ua aa ba fa ga _ _, b2      ) | isIdUa lv d book aa ba fa ga -> eql lv d book (PLm "_" (\_ -> aa)) b2
    (a2           , Ua ab bb fb gb _ _) | isIdUa lv d book ab bb fb gb -> eql lv d book a2 (PLm "_" (\_ -> ab))
    (PAp (cut -> Ua aa ba fa ga _ _) _, b2) | isIdUa lv d book aa ba fa ga -> eql lv d book aa b2
    (a2           , PAp (cut -> Ua ab bb fb gb _ _) _) | isIdUa lv d book ab bb fb gb -> eql lv d book a2 ab
    (PLm ka fa    , PLm kb fb    ) -> eql lv (d+1) book (fa (Var ka d)) (fb (Var kb d))
    (PLm ka fa    , b            ) -> eql lv (d+1) book (fa (Var ka d)) (PAp b (Var ka d))
    (a            , PLm kb fb    ) -> eql lv (d+1) book (PAp a (Var kb d)) (fb (Var kb d))
    (PAp fa xa    , PAp fb xb    ) -> eql lv d book fa fb && eql lv d book xa xb
    (Coe pa ra sa ta, Coe pb rb sb tb) -> eql lv d book pa pb && eql lv d book ra rb && eql lv d book sa sb && eql lv d book ta tb
    (Ua aa ba fa ga _ _, Ua ab bb fb gb _ _) -> eql lv d book aa ab && eql lv d book ba bb && eql lv d book fa fb && eql lv d book ga gb
    (HCm aa fa xa, HCm ab fb xb) -> eql lv d book aa ab && length fa == length fb && and (zipWith (\(pa,ua) (pb,ub) -> eql lv d book pa pb && eql lv d book ua ub) fa fb) && eql lv d book xa xb
    (Glu aa fa, Glu ab fb) -> eql lv d book aa ab && length fa == length fb && and (zipWith (\(pa,ta,ea) (pb,tb,eb) -> eql lv d book pa pb && eql lv d book ta tb && eql lv d book ea eb) fa fb)
    (GlB aa fa xa, GlB ab fb xb) -> eql lv d book aa ab && length fa == length fb && and (zipWith (\(pa,ta) (pb,tb) -> eql lv d book pa pb && eql lv d book ta tb) fa fb) && eql lv d book xa xb
    (UnG ga, UnG gb) -> eql lv d book ga gb
    -- propositional truncation
    (Tru aa, Tru ab) -> eql lv d book aa ab
    (TIn aa, TIn ab) -> eql lv d book aa ab
    (TSq xa ya, TSq xb yb) -> eql lv d book xa xb && eql lv d book ya yb
    (TRec xa pa fa, TRec xb pb fb) ->
      eql lv d book xa xb && eql lv d book pa pb && eql lv d book fa fb
    -- the circle
    (Cir, Cir) -> True
    (CBase, CBase) -> True
    (CLoop, CLoop) -> True
    (CRec xa ba la, CRec xb bb lb) ->
      eql lv d book xa xb && eql lv d book ba bb && eql lv d book la lb
    -- restricted types, partial elements, transp with a cofibration
    (Rst aa pa ua, Rst ab pb ub) ->
      eql lv d book aa ab && eql lv d book pa pb && eql lv d book ua ub
    (InS xa, InS xb) -> eql lv d book xa xb
    (OutS xa, OutS xb) -> eql lv d book xa xb
    (Prt pa aa, Prt pb ab) -> eql lv d book pa pb && eql lv d book aa ab
    (Sys fa, Sys fb) -> length fa == length fb &&
      and [ eql lv d book qa qb && eql lv d book va vb
          | ((qa,va),(qb,vb)) <- zip fa fb ]
    (POut ua, POut ub) -> eql lv d book ua ub
    (Trp la pa xa, Trp lb pb xb) ->
      eql lv d book la lb && eql lv d book pa pb && eql lv d book xa xb
    (Quo aa ra, Quo ab rb) -> eql lv d book aa ab && eql lv d book ra rb
    (QCl a, QCl b) -> eql lv d book a b
    (QEq a1 b1 r1, QEq a2 b2 r2) -> eql lv d book a1 a2 && eql lv d book b1 b2 && eql lv d book r1 r2
    (QSq, QSq) -> True
    (QRec x1 s1 f1 r1, QRec x2 s2 f2 r2) -> eql lv d book x1 x2 && eql lv d book s1 s2 && eql lv d book f1 f2 && eql lv d book r1 r2
    (HTy t1 p1, HTy t2 p2) -> t1 == t2 && length p1 == length p2 && and (zipWith (eql lv d book) p1 p2)
    (HCon t1 c1 p1 a1 i1, HCon t2 c2 p2 a2 i2) -> t1 == t2 && c1 == c2 && length a1 == length a2 && length i1 == length i2 && and (zipWith (eql lv d book) (a1 ++ i1) (a2 ++ i2))
    (HEl p1 b1 x1, HEl p2 b2 x2) -> eql lv d book p1 p2 && eql lv d book x1 x2 && length b1 == length b2 && and [ c1 == c2 && eql lv d book t1 t2 | ((c1,t1),(c2,t2)) <- zip b1 b2 ]
    (HRec b1 x1, HRec b2 x2) -> eql lv d book x1 x2 && length b1 == length b2 && and [ c1 == c2 && eql lv d book t1 t2 | ((c1,t1),(c2,t2)) <- zip b1 b2 ]
    (Era          , Era          ) -> True
    (Sup la aa ba , Sup lb ab bb ) -> eql lv d book la lb && eql lv d book aa ab && eql lv d book ba bb
    (SupM xa la fa, SupM xb lb fb) -> eql lv d book xa xb && eql lv d book la lb && eql lv d book fa fb
    (Frk la aa ba , Frk lb ab bb ) -> eql lv d book la lb && eql lv d book aa ab && eql lv d book ba bb
    (Num ta       , Num tb       ) -> ta == tb
    (Val va       , Val vb       ) -> va == vb
    (Op2 oa aa ba , Op2 ob ab bb ) -> oa == ob && eql lv d book aa ab && eql lv d book ba bb
    (Op1 oa aa    , Op1 ob ab    ) -> oa == ob && eql lv d book aa ab
    (Pri pa       , Pri pb       ) -> pa == pb
    (Met _  _  _  , Met _  _  _  ) -> error "not-supported"
    (Pat _  _  _  , Pat _  _  _  ) -> error "not-supported"
    (_            , _            ) -> False


-- ua(A,B,f,g,..) is the identity path when A ≡ B and both functions are
-- (eta-)convertible to the identity. Then the whole path is constant.
isIdUa :: Int -> Int -> Book -> Term -> Term -> Term -> Term -> Bool
isIdUa lv d book a b f g =
  eql lv d book a b &&
  eql lv d book f (Lam "x" (\x -> x)) &&
  eql lv d book g (Lam "x" (\x -> x))

-- Σ projection eliminators for the Σ-η rule in `cmp`.
sigFst :: Term
sigFst = Lam "x" (\x -> Lam "y" (\_ -> x))

sigSnd :: Term
sigSnd = Lam "x" (\_ -> Lam "y" (\y -> y))
