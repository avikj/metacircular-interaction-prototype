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
emit book = go where
  go :: Term -> String
  go t = case t of
    Var n _        -> binderName n
    Ref k          -> "@" ++ hvmName k
    Sub x          -> go x
    Loc _ x        -> go x
    Chk x _        -> go x
    Ind x          -> go x
    Frz x          -> go x

    -- recursion: HVM4 has @fix(&f) = (f @fix(f)); emit a self-application form
    Fix k f        -> "!" ++ k ++ "&F = " ++ go (f (Var k 0)) ++ "; " ++ k

    Let v f        -> "(" ++ go f ++ " " ++ go v ++ ")"

    -- functions (binders cloned for affine runtime)
    Lam k f        -> "λ&" ++ binderName k ++ ". " ++ go (f (Var k 0))
    App f x        -> go f ++ "(" ++ go x ++ ")"

    -- data
    Zer            -> "#Zer"
    Suc n          -> "#Suc{" ++ go n ++ "}"
    Bt0            -> "0"
    Bt1            -> "1"
    One            -> "1"
    Nil            -> "#Nil"
    Con h tl       -> "#Con{" ++ go h ++ ", " ++ go tl ++ "}"
    Val (U64_V v)  -> show v
    Val (CHR_V c)  -> "'" ++ [c] ++ "'"
    Val _          -> "0"
    Sym s          -> "#" ++ s

    -- tuples: #Pair (Sig-encoded ctors would need the type; use #Pair)
    Tup a b        -> "#Pair{" ++ go a ++ ", " ++ go b ++ "}"

    -- eliminators -> HVM4 match/switch lambdas, immediately applied
    BitM x f tr    -> "λ{0: " ++ go f ++ "; _: λ&_p. " ++ go tr ++ "}(" ++ go x ++ ")"
    NatM x z s     -> "λ{#Zer: " ++ go z ++ "; #Suc: " ++ go s ++ "}(" ++ go x ++ ")"
    LstM x n c     -> "λ{#Nil: " ++ go n ++ "; #Con: " ++ go c ++ "}(" ++ go x ++ ")"
    UniM x f       -> "λ{1: " ++ go f ++ "}(" ++ go x ++ ")"
    SigM x f       -> "λ{#Pair: " ++ go f ++ "}(" ++ go x ++ ")"
    EnuM x cs d    -> "λ{" ++ intercalate "; " (map (\(s,b) -> "#" ++ s ++ ": " ++ go b) cs)
                       ++ "; _: λ&_p. " ++ go d ++ "}(" ++ go x ++ ")"

    -- numeric ops
    Op2 o a b      -> "(" ++ go a ++ " " ++ op2 o ++ " " ++ go b ++ ")"

    -- superpositions -> real HVM4 SUP/DUP nodes (the point of targeting HVM4)
    Sup l a b      -> "&" ++ label l ++ "{" ++ go a ++ ", " ++ go b ++ "}"
    Era            -> "&{}"

    -- cubical: paths pass through content, interval arg erased; types erase
    PLm _ f        -> go (f Era)
    PAp p _        -> go p
    Coe _ _ _ x    -> go x            -- residual (neutral) coe is proof-level
    HCm _ _ _ _ x  -> go x            -- residual hcomp cap
    Ua a _ _ _ _ _ -> go a

    -- type-level formers with no runtime content
    Set   -> "&{}"; Emp   -> "&{}"; Uni   -> "&{}"; Bit -> "&{}"
    Nat   -> "&{}"; Lst _ -> "&{}"; Enu _ -> "&{}"; Num _ -> "&{}"
    Sig _ _ -> "&{}"; All _ _ -> "&{}"; Eql _ _ _ -> "&{}"; Rfl -> "&{}"
    Itv -> "&{}"; I0 -> "&{}"; I1 -> "&{}"
    INot _ -> "&{}"; IAnd _ _ -> "&{}"; IOr _ _ -> "&{}"; Pth _ _ _ -> "&{}"
    EmpM x -> "λ{}(" ++ go x ++ ")"
    EqlM _ f -> go f
    Op1 _ a -> go a
    Log _ x -> go x
    Met _ _ _ -> "&{}"
    Frk l a b -> "&" ++ label l ++ "{" ++ go a ++ ", " ++ go b ++ "}"
    SupM x l f -> "!&D&" ++ label l ++ " = " ++ go x ++ "; " ++ go f
    Pri _ -> "&{}"
    Pat _ _ _ -> "&{}"

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
