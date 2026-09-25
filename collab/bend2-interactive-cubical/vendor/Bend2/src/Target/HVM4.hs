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
import Core.WHNF (normal, force, coeRep, pathRep, coeMarker, occursMarker)

compile :: Book -> String
compile book@(Book defs _) = prelude ++ unlines (map def (M.toList defs))
  where
    def (nam, (_, tm, _)) =
      "@" ++ hvmName nam ++ " = " ++ emitWith False book (normal 0 book tm)

-- Raw mode: emit WITHOUT pre-normalising in Haskell, so coe/ua/path
-- reduction happens on the interaction net itself (measurable in
-- interactions), not at compile time.
compileRaw :: Book -> String
compileRaw book@(Book defs _) = prelude ++ unlines (map def (M.toList defs))
  where
    def (nam, (_, tm, _)) =
      "@" ++ hvmName nam ++ " = " ++ emitWith True book tm

prelude :: String
prelude = unlines
  [ "// Bend2 -> HVM4 (normalize-then-erase; cubical proof structure erased)"
  , "// universe paths are represented by their forward transport function;"
  , "// coe along a path is application of that function."
  , "// a universe path is a Church pair (fwd, bwd); coe picks a direction"
  , "@cub_idfn = λx. x"
  , "@cub_idPath = λ&k. k(@cub_idfn)(@cub_idfn)"
  , "@cub_pathFwd = λ&p. p(λ&f. λ&g. f)"
  , "@cub_pathBwd = λ&p. p(λ&f. λ&g. g)"
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
emit = emitWith False

-- strict: refuse (error) any cubical form outside the runtime path algebra
-- instead of erasing it to a cap / identity (raw mode must never guess).
emitWith :: Bool -> Book -> Term -> String
emitWith strict book t0 = go 0 t0 where
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

    Let v f        -> appFun d f ++ "(" ++ go d v ++ ")"

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
    -- Every other literal used to emit as "0" through a silent catch-all, so
    -- an I64 program compiled to a program about zero and nothing said so.
    -- HVM4 numbers are unsigned 32-bit and have no negative literal syntax,
    -- so a negative is emitted as a subtraction and wraps mod 2^32 at
    -- runtime -- a limitation that is now visible instead of a zero.
    Val (I64_V v)  -> if v >= 0 then show v else "(0 - " ++ show (negate v) ++ ")"
    Val (F64_V v)  -> error ("HVM4 emitter: F64 literal " ++ show v
                             ++ " has no runtime representation")
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
    PLm _ f        -> let b = f Era in if isTypeLine b then "@cub_idPath" else
                      -- a line whose body is a type former / hcomp in Set is a
                      -- universe path: emit its runtime representation
                      case f coeMarker of
                        bm | isSetLine bm -> case pathRep t of
                               Just r  -> go d r
                               Nothing -> unsupported "universe path" t
                        _ -> go d b
    -- a literal endpoint is resolved before erasure: `p @ i1` where p is a
    -- path lambda / hcomp must yield the tube top, never the erased body.
    PAp p r        -> case cut r of
                        I0 -> go d (force book (PAp p r))
                        I1 -> go d (force book (PAp p r))
                        _  -> go d p
    -- coe along a Set-line: the line's runtime representation (closed
    -- under composition / inverse / Pi / Sigma) applied in the direction
    Coe pP r s x   -> case coeRep pP r s x of
                        Just t' -> go d t'
                        Nothing -> if strict then unsupported "coe line" pP else go d x
    HCm _ _ x      -> go d x            -- residual hcomp cap
    Glu _ _        -> "&{}"
    GlB _ _ x      -> go d x            -- residual glue: its base (after normalisation)
    Tru _       -> "&{}"
    TIn a       -> go d a
    TSq _ _     -> "&{}"
    TRec x _ _  -> go d x
    Cir         -> "&{}"
    CBase       -> "&{}"
    CLoop       -> "&{}"
    CRec x _ _  -> go d x
    HTy _ _     -> "&{}"
    HCon t c _ as _ -> "#" ++ hvmName t ++ "_" ++ c ++ "{" ++ intercalate ", " (map (go d) as) ++ "}"
    HEl _ _ x   -> go d x
    HRec _ x    -> go d x
    Prt _ a     -> go d a
    POut u      -> go d u
    Trp l _ x   -> go d x
    Rst a _ _   -> go d a
    InS x      -> go d x
    OutS x     -> go d x
    UnG g          -> go d g
    Ua _ _ f g _ _ -> "(λ&b" ++ show d ++ ". b" ++ show d ++ "(" ++ go (d+1) f ++ ")(" ++ go (d+1) g ++ "))"

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

  unsupported :: String -> Term -> String
  unsupported what t = error ("HVM4 raw emission: unsupported cubical " ++ what ++ " (outside the runtime path algebra): " ++ show t)

  isSetLine :: Term -> Bool
  isSetLine bm = occursMarker bm && case cut bm of
    All _ _     -> True
    Sig _ _     -> True
    HCm a _ _   -> case cut a of { Set -> True; _ -> False }
    _           -> False

  -- Function position of an application: atomic heads print bare; any
  -- binder/eliminator head is parenthesized so `(λx.M)(N)` is not misread.
  appFun :: Int -> Term -> String
  appFun d f = case cut f of
    Var _ _ -> go d f
    Ref _   -> go d f
    App _ _ -> go d f
    _       -> "(" ++ go d f ++ ")"

  -- A path lambda whose body is a type former is a constant line in Set:
  -- its runtime meaning is the identity path (transport is the identity).
  isTypeLine :: Term -> Bool
  isTypeLine t = case cut t of
    Set -> True; Bit -> True; Nat -> True; Uni -> True; Emp -> True
    Lst _ -> True; Enu _ -> True; Num _ -> True; Sig _ _ -> True
    All _ _ -> True; Itv -> True; Pth _ _ _ -> True; Eql _ _ _ -> True
    _ -> False

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
