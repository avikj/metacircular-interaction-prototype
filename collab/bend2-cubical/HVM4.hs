{-./../Core/Type.hs-}

{-# LANGUAGE ViewPatterns #-}

-- Bend2 -> HVM4 surface emitter.
--
-- Strategy: normalize each definition first (Core.WHNF.normal reduces coe /
-- hcomp / ua-applications wherever they compute, so the residual cubical
-- constructs are proof-level and carry no runtime content), then print HVM4
-- surface syntax directly. Cubical type-level formers and proof cells erase to
-- the eraser `&{}`; path lambdas / applications pass through their content
-- (the interval argument is erased). Every lambda binder is emitted cloned
-- (`λ&x`) so the affine runtime accepts repeated use without hand-placed dups.

module Target.HVM4 where

import Data.List (intercalate, isInfixOf)
import qualified Data.Map as M

import Core.Type
import Core.WHNF (normal)

compile :: Book -> String
compile book@(Book defs) = prelude ++ unlines (map def (M.toList defs))
  where
    def (nam, (_, tm, _)) =
      "@" ++ hvmName nam ++ " = " ++ emit book (normal 0 book tm)

prelude :: String
prelude = unlines
  [ "// Bend2 -> HVM4 (normalize-then-erase; cubical proof structure erased)"
  , "// universe paths are represented by their forward transport function;"
  , "// coe along a path is application of that function."
  , "@idfn = λx. x"
  , "" ]

hvmName :: Name -> String
hvmName = concatMap (\c -> if c == '/' then "__" else [c])

-- fresh-ish binder names avoiding clashes with HVM4 syntax
binderName :: Name -> String
binderName "_" = "_"
binderName k   = case k of
  ('_':rest) -> 'v' : sanitize rest
  _          -> sanitize k
  where sanitize = concatMap (\c -> if c `elem` ("_0123456789" ++ ['a'..'z'] ++ ['A'..'Z']) then [c] else "")

emit :: Book -> Term -> String
emit book t0 = go 0 t0 where
  go :: Int -> Term -> String
  go d t = case t of
    Var _ i        -> if i < 0 then "_" else "b" ++ show i
    Ref k          -> "@" ++ hvmName k
    Sub x          -> go d x
    Loc _ x        -> go d x
    Chk x _        -> go d x
    Ind x          -> go d x
    Frz x          -> go d x

    -- recursion: HVM4 has @fix(&f) = (f @fix(f)); emit a self-application form
    Fix k f        -> "!b" ++ show d ++ "&F = " ++ go (d+1) (f (Var k d)) ++ "; b" ++ show d

    Let v f        -> "(" ++ go d f ++ " " ++ go d v ++ ")"

    -- functions (binders cloned for affine runtime)
    Lam k f        -> "λ&b" ++ show d ++ ". " ++ go (d+1) (f (Var k d))
    App f x        -> appFun d f ++ "(" ++ go d x ++ ")"

    -- data
    Zer            -> "#Zer"
    Suc n          -> "#Suc{" ++ go d n ++ "}"
    Bt0            -> "0"
    Bt1            -> "1"
    One            -> "1"
    Nil            -> "#Nil"
    Con h tl       -> "#Con{" ++ go d h ++ ", " ++ go d tl ++ "}"
    Val (U64_V v)  -> show v
    Val (CHR_V c)  -> "'" ++ [c] ++ "'"
    Val _          -> "0"
    Sym s          -> "#" ++ s

    -- tuples: #Pair (Sig-encoded ctors would need the type; use #Pair)
    Tup a b        -> "#Pair{" ++ go d a ++ ", " ++ go d b ++ "}"

    -- eliminators -> HVM4 match/switch lambdas, immediately applied
    BitM x f tr    -> "λ{0: " ++ go d f ++ "; _: λ&b" ++ show d ++ ". " ++ go (d+1) tr ++ "}(" ++ go d x ++ ")"
    NatM x z s     -> "λ{#Zer: " ++ go d z ++ "; #Suc: " ++ go d s ++ "}(" ++ go d x ++ ")"
    LstM x n c     -> "λ{#Nil: " ++ go d n ++ "; #Con: " ++ go d c ++ "}(" ++ go d x ++ ")"
    UniM x f       -> "λ{1: " ++ go d f ++ "}(" ++ go d x ++ ")"
    SigM x f       -> "λ{#Pair: " ++ go d f ++ "}(" ++ go d x ++ ")"
    EnuM x cs df   -> "λ{" ++ intercalate "; " (map (\(sy,b) -> "#" ++ sy ++ ": " ++ go d b) cs)
                       ++ "; _: λ&b" ++ show d ++ ". " ++ go (d+1) df ++ "}(" ++ go d x ++ ")"

    -- numeric ops
    Op2 o a b      -> "(" ++ go d a ++ " " ++ op2 o ++ " " ++ go d b ++ ")"

    -- superpositions -> real HVM4 SUP/DUP nodes (the point of targeting HVM4)
    Sup l a b      -> "&" ++ label l ++ "{" ++ go d a ++ ", " ++ go d b ++ "}"
    Era            -> "&{}"

    -- cubical: paths pass through content, interval arg erased; types erase
    PLm _ f        -> go d (f Era)
    PAp p _        -> go d p
    Coe pP r s x   -> case pathLineHead pP of
                        -- coe along a universe path `<i> P @ i`: run the
                        -- path's forward transport (its runtime rep) on x.
                        Just pth -> case (r, s) of
                          (I1, I0) -> "@pathBwd(" ++ go d pth ++ ")(" ++ go d x ++ ")"
                          _        -> go d pth ++ "(" ++ go d x ++ ")"
                        -- coe over a type that does not vary in i: identity.
                        Nothing  -> go d x
    HCm _ _ _ _ x  -> go d x            -- residual hcomp cap
    Ua _ _ f _ _ _ -> go d f

    -- type-level formers with no runtime content
    Set   -> "&{}"; Emp   -> "&{}"; Uni   -> "&{}"; Bit -> "&{}"
    Nat   -> "&{}"; Lst _ -> "&{}"; Enu _ -> "&{}"; Num _ -> "&{}"
    Sig _ _ -> "&{}"; All _ _ -> "&{}"; Eql _ _ _ -> "&{}"; Rfl -> "&{}"
    Itv -> "&{}"; I0 -> "&{}"; I1 -> "&{}"
    INot _ -> "&{}"; IAnd _ _ -> "&{}"; IOr _ _ -> "&{}"; Pth _ _ _ -> "&{}"
    EmpM x -> "λ{}(" ++ go d x ++ ")"
    EqlM _ f -> go d f
    Op1 _ a -> go d a
    Log _ x -> go d x
    Met _ _ _ -> "&{}"
    Frk l a b -> "&" ++ label l ++ "{" ++ go d a ++ ", " ++ go d b ++ "}"
    SupM x l f -> "!&D&" ++ label l ++ " = " ++ go d x ++ "; " ++ go d f
    Pri _ -> "&{}"
    Pat _ _ _ -> "&{}"

  -- Function position of an application: atomic heads print bare; any
  -- binder/eliminator head is parenthesized so `(λx.M)(N)` is not misread.
  appFun :: Int -> Term -> String
  appFun d f = case cut f of
    Var _ _ -> go d f
    Ref _   -> go d f
    App _ _ -> go d f
    _       -> "(" ++ go d f ++ ")"

  -- If `pP` is `λi. (P @ i)` (a universe-path line), return the path `P`
  -- whose runtime representation is its forward transport function.
  pathLineHead :: Term -> Maybe Term
  pathLineHead t = case t of
    Lam k f  -> case f (Var k 0) of
                  PAp pth _ -> Just pth
                  Loc _ (PAp pth _) -> Just pth
                  _         -> Nothing
    Loc _ x  -> pathLineHead x
    _        -> Nothing

  label :: Term -> String
  label (Loc _ t)     = label t
  label (Val (U64_V v)) = "L" ++ show v
  label (Sym s)       = s
  label _             = "L"

  op2 :: NOp2 -> String
  op2 ADD = "+"; op2 SUB = "-"; op2 MUL = "*"; op2 DIV = "/"; op2 MOD = "%"
  op2 EQL = "=="; op2 NEQ = "!="; op2 LST = "<"; op2 GRT = ">"
  op2 LEQ = "<="; op2 GEQ = ">="; op2 AND = "&&"; op2 OR = "||"
  op2 XOR = "^"; op2 SHL = "<<"; op2 SHR = ">>"; op2 POW = "*"
