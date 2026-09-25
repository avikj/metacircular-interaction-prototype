{-# LANGUAGE ViewPatterns #-}

module Core.Type where

import Data.List (intercalate)
import Debug.Trace
import Highlight (highlightError)
import Data.Int (Int32, Int64)
import Data.Word (Word32, Word64)
import Data.Maybe (fromMaybe)
import qualified Data.Map as M
import qualified Data.Set as S

data Bits = O Bits | I Bits | E deriving Show
type Name = String
type Body = Term -> Term
type Case = ([Term], Term)
type Move = (String, Term)
type Type = Term

data NTyp
  = U64_T
  | I64_T
  | F64_T
  | CHR_T
  deriving (Show, Eq)

data NVal
  = U64_V Word64
  | I64_V Int64
  | F64_V Double
  | CHR_V Char
  deriving (Show, Eq)

data NOp2
  = ADD | SUB | MUL | DIV | MOD | POW
  | EQL | NEQ  
  | LST | GRT | LEQ | GEQ
  | AND | OR  | XOR
  | SHL | SHR
  deriving (Show, Eq)

data NOp1
  = NOT | NEG
  deriving (Show, Eq)

data PriF
  = U64_TO_CHAR
  deriving (Show, Eq)

-- Bend's Term Type
data Term
  -- Variables
  = Var Name Int -- x
  | Ref Name     -- x
  | Sub Term     -- x

  -- Definitions
  | Fix Name Body -- μx. f
  | Let Term Term -- !v; f

  -- Universe
  | Set -- Set

  -- Annotation
  | Chk Term Type -- x::t

  -- Empty
  | Emp       -- Empty
  | EmpM Term -- ~x{}

  -- Unit
  | Uni            -- Unit
  | One            -- ()
  | UniM Term Term -- ~x{():f}

  -- Bool
  | Bit                 -- Bool
  | Bt0                 -- False
  | Bt1                 -- True
  | BitM Term Term Term -- ~x{False:t;True:t}

  -- Nat
  | Nat                 -- Nat
  | Zer                 -- 0
  | Suc Term            -- ↑n
  | NatM Term Term Term -- ~x{0n:z;1n+:s}

  -- List
  | Lst Type            -- T[]
  | Nil                 -- []
  | Con Term Term       -- h<>t
  | LstM Term Term Term -- ~x{[]:n;<>:c}

  -- Enum
  | Enu [String]                   -- {@foo,@bar...}
  | Sym String                     -- @foo
  | EnuM Term [(String,Term)] Term -- ~x{@foo:f;@bar:b;...d}

  -- Numbers
  | Num NTyp           -- CHR | U64 | I64 | F64
  | Val NVal           -- 123 | +123 | +123.0
  | Op2 NOp2 Term Term -- x + y
  | Op1 NOp1 Term      -- !x

  -- Pair
  | Sig Type Type       -- ΣA.B
  | Tup Term Term       -- (a,b)
  | SigM Term Term      -- ~x{(,):f}

  -- Function
  | All Type Type -- ∀A.B
  | Lam Name Body -- λx.f
  | App Term Term -- (f x)

  -- Equality
  | Eql Type Term Term -- T{a==b}
  | Rfl                -- {==}
  | EqlM Term Term     -- ~x{{==}:f}

  -- MetaVar
  | Met Int Type [Term] -- ?N:T{x0,x1,...}
  
  -- Hints
  | Ind Type -- ~~T
  | Frz Type -- ∅T

  -- Cubical: interval and paths (CCHM-lite)
  | Itv                 -- Interval
  | I0                  -- i0
  | I1                  -- i1
  | INot Term           -- inot(r)
  | IAnd Term Term      -- iand(r,s)
  | IOr  Term Term      -- ior(r,s)
  | Pth Term Term Term  -- PathP: Pth P a b, P : Interval -> Set
  | Coe Term Term Term Term -- coe(P, r, s, t) : transport t from P r to P s
  | Ua  Term Term Term Term Term Term -- ua(A,B,f,g,gf,fg) : Path(Set, A, B)
  | HCm Term [(Term, Term)] Term -- hcomp(A, base, {φ => u; …}): compose base
  | Glu Term [(Term,Term,Term)]       -- Glue A [(φ,T,e)] ; e : T -> A (forward map of an equivalence)
  | GlB Term [(Term,Term)] Term       -- glue A [(φ,t)] a : Glue A [...]
  | UnG Term                          -- unglue g : A
  -- Restricted (Sub) types, CCHM: A[φ ↦ u] is the type of elements of A that
  -- are DEFINITIONALLY u wherever φ holds.  inS injects (with that obligation
  -- checked on the cell φ=1); outS projects back, and outS s ≡ u on φ.
  -- Propositional truncation ||A||, a HIT whose path constructor joins ANY
  -- two elements, so the type is a proposition by construction.
  | Tru Term                          -- ||A|| : Set
  | TIn Term                          -- |a| : ||A||                  (point ctor)
  | TSq Term Term                     -- squash x y : Path(||A||,x,y) (path ctor)
  | TRec Term Term Term               -- trec x pB f : B  (pB : isProp B)
  -- The circle S1, a HIT with one point and one PATH constructor.  Its
  -- recursor is driven by the path constructor: rec(loop @ i) = l @ i.
  | Cir                               -- S1 : Set
  | CBase                             -- base : S1                    (point ctor)
  | CLoop                             -- loop : Path(S1, base, base)  (path ctor)
  | CRec Term Term Term               -- S1.rec x b l : B
  -- Partial elements (CCHM): Partial(φ, A) is the type of elements of A
  -- defined only where φ holds; its inhabitants are SYSTEMS {ψ ↦ v; …}.
  | Prt Term Term                     -- Partial(φ, A) : Set
  | Sys [(Term, Term)]                -- {ψ ↦ v; …} : Partial(φ, A)
  | POut Term                         -- pout(u) : A, available where φ holds
  -- transp with a cofibration (CCHM): transp(L, φ, x) where L is CONSTANT on
  -- φ.  It is the identity wherever φ holds, and plain transport where it does not.
  | Trp Term Term Term                -- transp(L, φ, x) : L(i1)
  | Rst Term Term Term                -- Sub(A, φ, u) : Set
  | InS Term                          -- inS(x)  : Sub(A, φ, u)
  | OutS Term                         -- outS(s) : A
                                 -- with tubes u on cofibration faces φ

  -- Set-quotient HIT: Quot A R  (R : A -> A -> Set, prop-valued equiv rel)
  | Quo Type Term                     -- A / R
  | QCl Term                          -- [a] : Quot A R                     (point ctor)
  | QEq Term Term Term                -- eq/ a b r : Path (Quot A R) [a] [b] (path ctor)
  | QSq                               -- squash/ : isSet (Quot A R)         (opaque truncation)
  | QRec Term Term Term Term          -- SQ.rec scrutinee setB f resp : B   (recursor into a set)
  -- General higher inductive types, declared as
  --   type T(params): case @c: fields... path @p(fields): Path(...)
  -- HTy T ps is the type; HCon T c ps args ivs a constructor applied to its
  -- fields and (for a path constructor) to the intervals given so far; HEl
  -- is the dependent eliminator, HRec the recursor whose motive is the goal.
  | HTy Name [Term]                     -- T(ps)
  | HCon Name Name [Term] [Term] [Term] -- @c{args} (of T ps), applied at ivs
  | HEl Term [(Name, Term)] Term        -- helim(x, P) { @c: b; ... } : P(x)
  | HRec [(Name, Term)] Term            -- hrec(x) { @c: b; ... }

  | PLm Name Body       -- <i> t
  | PAp Term Term       -- p @ r

  -- Supperpositions
  | Era                 -- *
  | Sup Term Term Term  -- &L{a,b}
  | SupM Term Term Term -- ~x{&L{,}:f}

  -- Errors
  | Loc Span Term -- x
  | Rwt Term Term Term -- a → b ; x

  -- Logging
  -- NOTE: THIS IS A NEW PRIMITIVE (WIP)
  -- when the user writes:
  -- `log "foo" 123`
  -- the evaluator (whnf) will log "foo" to the screen, and return 123
  -- it will do so from Haskell-side by using Debug.Trace
  -- the first term must be a Char[]. the whnfLog function will normalize the
  -- Bend string layer by layer to convert to a Haskell string, and then print.
  -- if this fails (say, if ill-typed, or stuck), nothing will be printed.
  | Log Term Term -- log s ; x

  -- Primitive
  | Pri PriF -- SOME_FUNC

  -- Sugars
  | Pat [Term] [Move] [Case] -- match x ... { with k=v ... ; case @A ...: F ; ... }
  | Frk Term Term Term       -- fork L:a else:b

-- Book of Definitions
type Inj  = Bool -- "is injective" flag. improves pretty printing
type Defn = (Inj, Term, Type)

-- A declared higher inductive type. Every constructor carries its CLOSED
-- Pi-type over the type's parameters and its own fields, ending in the HIT
-- itself (a point constructor, dim 0) or in a Path/PathP type into it whose
-- nesting depth is the constructor's dimension.
data HitCtor = HitCtor
  { ctorNArgs :: Int   -- number of fields (after the parameters)
  , ctorDim   :: Int   -- 0 for a point constructor, n for an n-path
  , ctorType  :: Term  -- All params. All fields. T(ps) | Path(.., ..) ...
  }
data HitDecl = HitDecl
  { hitArity :: Int               -- number of parameters
  , hitType  :: Term              -- All params. Set
  , hitCtors :: [(Name, HitCtor)] -- in declaration order
  }
data Book = Book (M.Map Name Defn) (M.Map Name HitDecl)

bookDefs :: Book -> M.Map Name Defn
bookDefs (Book defs _) = defs

bookHits :: Book -> M.Map Name HitDecl
bookHits (Book _ hits) = hits

derefHit :: Book -> Name -> Maybe HitDecl
derefHit (Book _ hits) name = M.lookup name hits

-- the HIT a constructor name belongs to, with its signature
derefCtor :: Book -> Name -> Maybe (Name, HitDecl, HitCtor)
derefCtor (Book _ hits) c =
  case [ (t, h, k) | (t, h) <- M.toList hits, (c', k) <- hitCtors h, c' == c ] of
    (r : _) -> Just r
    []      -> Nothing

-- Substitution Map
type Subs = [(Term,Term)]

-- Context (new type)
data Ctx = Ctx [(Name,Term,Term)]

-- Error Location (NEW TYPE)
data Span = Span
  { spanBeg :: (Int,Int)
  , spanEnd :: (Int,Int)
  , spanSrc :: String -- original file
  }

data Error
  = CantInfer Span Ctx
  | TypeMismatch Span Ctx Term Term
  | TermMismatch Span Ctx Term Term
  | IncompleteMatch Span Ctx

data Result a
  = Done a
  | Fail Error

instance Functor Result where
  fmap f (Done a) = Done (f a)
  fmap _ (Fail e) = Fail e

instance Applicative Result where
  pure              = Done
  Done f <*> Done a = Done (f a)
  Fail e <*> _      = Fail e
  _      <*> Fail e = Fail e

instance Monad Result where
  Done a >>= f = f a
  Fail e >>= _ = Fail e

instance Show Term where
  show (Var k i)      = k -- ++ "^" ++ show i
  show (Ref k)        = k
  show (Sub t)        = show t
  show (Tru a)        = "Trunc(" ++ show a ++ ")"
  show (TIn a)        = "tin(" ++ show a ++ ")"
  show (TSq x y)      = "tsquash(" ++ show x ++ "," ++ show y ++ ")"
  show (TRec x p f)   = "trec(" ++ show x ++ "," ++ show p ++ "," ++ show f ++ ")"
  show Cir            = "S1"
  show CBase          = "s1base"
  show CLoop          = "s1loop"
  show (CRec x b l)   = "srec(" ++ show x ++ "," ++ show b ++ "," ++ show l ++ ")"
  show (Rst a p u)    = "Sub(" ++ show a ++ "," ++ show p ++ "," ++ show u ++ ")"
  show (InS x)        = "inS(" ++ show x ++ ")"
  show (OutS x)       = "outS(" ++ show x ++ ")"
  show (Prt p a)      = "Partial(" ++ show p ++ "," ++ show a ++ ")"
  show (Sys fs)       = "system([" ++ concatMap (\(q,v) -> "(" ++ show q ++ "," ++ show v ++ ")") fs ++ "])"
  show (POut u)       = "pout(" ++ show u ++ ")"
  show (Trp l p x)    = "transp(" ++ show l ++ "," ++ show p ++ "," ++ show x ++ ")"
  show (Fix k f)      = "μ" ++ k ++ ". " ++ show (f (Var k 0))
  show (Let v f)      = "!" ++ show v ++ ";" ++ show f
  show (Set)          = "Set"
  show (Chk x t)      = "(" ++ show x ++ "::" ++ show t ++ ")"
  show (Emp)          = "Empty"
  show (EmpM x)       = "~" ++ show x ++ "{}"
  show (Uni)          = "Unit"
  show (One)          = "()"
  show (UniM x f)     = "~ " ++ show x ++ " { (): " ++ show f ++ " }"
  show (Bit)          = "Bool"
  show (Bt0)          = "False"
  show (Bt1)          = "True"
  show (BitM x f t)   = "~ " ++ show x ++ " { False: " ++ show f ++ " ; True: " ++ show t ++ " }"
  show (Nat)          = "Nat"
  show (Zer)          = "0n"
  show (Suc n)        = "1n+" ++ show n
  show (NatM x z s)   = "~ " ++ show x ++ " { 0n: " ++ show z ++ " ; 1n+: " ++ show s ++ " }"
  show (Lst t)        = show t ++ "[]"
  show (Nil)          = "[]"
  show (Con h t)      = fromMaybe (show h ++ "<>" ++ show t) (prettyStr (Con h t))
  show (LstM x n c)   = "~ " ++ show x ++ " { []:" ++ show n ++ " ; <>:" ++ show c ++ " }"
  show (Enu s)        = "&{" ++ intercalate "," (map (\x -> "&" ++ x) s) ++ "}"
  show (Sym s)        = "&" ++ s
  show (EnuM x c e)   = "~ " ++ show x ++ " { " ++ intercalate " ; " (map (\(s,t) -> "&" ++ s ++ ": " ++ show t) c) ++ " ; " ++ show e ++ " }"
  show (Sig a b)      = sig a b where
    sig a (Lam "_" f) = show a ++ "&" ++ show (f (Var "_" 0))
    sig a (Lam k f)   = "Σ" ++ k ++ ":" ++ show a ++ ". " ++ (show (f (Var k 0)))
    sig a b           = "Σ" ++ show a ++ ". " ++ (show b)
  show tup@(Tup _ _)  = fromMaybe ("(" ++ intercalate "," (map show (flattenTup tup)) ++ ")") (prettyCtr tup)
  show (SigM x f)     = "~ " ++ show x ++ " { (,):" ++ show f ++ " }"
  show (All a b) = case b of
      Lam "_" f -> showArg a ++ " -> " ++ showCodomain (f (Var "_" 0))
      Lam k   f -> "∀" ++ k ++ ":" ++ showArg a ++ ". " ++ show (f (Var k 0))
      _         -> "∀" ++ showArg a ++ ". " ++ show b
    where
      showArg t = case t of
          All{} -> "(" ++ show t ++ ")"
          _     -> show t
      showCodomain t = case t of
          All _ (Lam k _) | k /= "_"  -> "(" ++ show t ++ ")"
          _                           -> show t
  show (Lam k f)      = "λ" ++ k ++ ". " ++ show (f (Var k 0))
  show app@(App _ _)  = fnStr ++ "(" ++ intercalate "," (map show args) ++ ")" where
           (fn, args) = collectApps app []
           fnStr      = case cut fn of
              Var k i -> show (Var k i)
              Ref k   -> show (Ref k)
              fn      -> "(" ++ show fn ++ ")"
  show (Eql t a b)     = show t ++ "{" ++ show a ++ "==" ++ show b ++ "}"
  show (Rfl)           = "{==}"
  show (EqlM x f)      = "~ " ++ show x ++ " { {==}:" ++ show f ++ " }"
  show (Ind t)         = "~~ {" ++ show t ++ "}"
  show (Frz t)         = "∅" ++ show t
  show (Loc _ t)       = show t
  show (Rwt a b x)     = show a ++ " ⇒ " ++ show b ++ "; " ++ show x
  show (Itv)           = "Interval"
  show (I0)            = "i0"
  show (I1)            = "i1"
  show (INot a)        = "inot(" ++ show a ++ ")"
  show (IAnd a b)      = "iand(" ++ show a ++ "," ++ show b ++ ")"
  show (IOr a b)       = "ior(" ++ show a ++ "," ++ show b ++ ")"
  show (Pth t a b)     = "PathP(" ++ show t ++ "," ++ show a ++ "," ++ show b ++ ")"
  show (Coe p r s t)   = "coe(" ++ show p ++ "," ++ show r ++ "," ++ show s ++ "," ++ show t ++ ")"
  show (Ua a b f g _ _) = "ua(" ++ show a ++ "," ++ show b ++ "," ++ show f ++ "," ++ show g ++ ",..)"
  show (HCm a fs x)    = "hcomp(" ++ show a ++ "," ++ show x ++ ",{" ++ concatMap (\(p,u) -> show p ++ " => " ++ show u ++ "; ") fs ++ "})"
  show (Glu a fs)      = "Glue(" ++ show a ++ ",{" ++ concatMap (\(p,t,e) -> show p ++ "=>(" ++ show t ++ "," ++ show e ++ "); ") fs ++ "})"
  show (GlB a fs x)    = "glue(" ++ show a ++ "," ++ show x ++ ",{" ++ concatMap (\(p,t) -> show p ++ "=>" ++ show t ++ "; ") fs ++ "})"
  show (UnG g)         = "unglue(" ++ show g ++ ")"
  show (Quo a r)       = "(" ++ show a ++ " / " ++ show r ++ ")"
  show (QCl a)         = "[" ++ show a ++ "]"
  show (QEq a b r)     = "eq/(" ++ show a ++ "," ++ show b ++ "," ++ show r ++ ")"
  show QSq             = "squash/"
  show (QRec x s f r)  = "~q " ++ show x ++ " { [_]:" ++ show f ++ " ; eq/:" ++ show r ++ " }"
  show (HTy t ps)      = t ++ (if null ps then "" else "(" ++ intercalate "," (map show ps) ++ ")")
  show (HCon _ c _ as ivs) = "@" ++ c ++ "{" ++ intercalate "," (map show as) ++ "}" ++ concatMap (\i -> " @ " ++ show i) ivs
  show (HEl p bs x)    = "helim(" ++ show x ++ "," ++ show p ++ "){" ++ intercalate "; " [ "@" ++ c ++ ": " ++ show b | (c,b) <- bs ] ++ "}"
  show (HRec bs x)     = "hrec(" ++ show x ++ "){" ++ intercalate "; " [ "@" ++ c ++ ": " ++ show b | (c,b) <- bs ] ++ "}"
  show (PLm k f)       = "<" ++ k ++ "> " ++ show (f (Var k 0))
  show (PAp p r)       = "(" ++ show p ++ " @ " ++ show r ++ ")"
  show (Era)           = "*"
  show (Sup l a b)     = "&" ++ show l ++ "{" ++ show a ++ "," ++ show b ++ "}"
  show (SupM x l f)    = "~ " ++ show x ++ " { &" ++ show l ++ "{,}:" ++ show f ++ " }"
  show (Frk l a b)     = "fork " ++ show l ++ ":" ++ show a ++ " else:" ++ show b
  show (Met _ _ _)     = "?"
  show (Log s x)       = "log " ++ show s ++ " " ++ show x
  show (Pri p)         = pri p where
    pri U64_TO_CHAR    = "U64_TO_CHAR"
  show (Num U64_T)     = "U64"
  show (Num I64_T)     = "I64"
  show (Num F64_T)     = "F64"
  show (Num CHR_T)     = "Char"
  show (Val (U64_V n)) = show n
  show (Val (I64_V n)) = if n >= 0 then "+" ++ show n else show n
  show (Val (F64_V n)) = show n
  show (Val (CHR_V c)) = "'" ++ showChar c ++ "'" where
         showChar '\n' = "\\n"
         showChar '\t' = "\\t"
         showChar '\r' = "\\r"
         showChar '\0' = "\\0"
         showChar '\\' = "\\\\"
         showChar '\'' = "\\'"
         showChar c    = [c]
  show (Op2 ADD a b)   = "(" ++ show a ++ " + " ++ show b ++ ")"
  show (Op2 SUB a b)   = "(" ++ show a ++ " - " ++ show b ++ ")"
  show (Op2 MUL a b)   = "(" ++ show a ++ " * " ++ show b ++ ")"
  show (Op2 DIV a b)   = "(" ++ show a ++ " / " ++ show b ++ ")"
  show (Op2 MOD a b)   = "(" ++ show a ++ " % " ++ show b ++ ")"
  show (Op2 EQL a b)   = "(" ++ show a ++ " == " ++ show b ++ ")"
  show (Op2 NEQ a b)   = "(" ++ show a ++ " !== " ++ show b ++ ")"
  show (Op2 LST a b)   = "(" ++ show a ++ " < " ++ show b ++ ")"
  show (Op2 GRT a b)   = "(" ++ show a ++ " > " ++ show b ++ ")"
  show (Op2 LEQ a b)   = "(" ++ show a ++ " <= " ++ show b ++ ")"
  show (Op2 GEQ a b)   = "(" ++ show a ++ " >= " ++ show b ++ ")"
  show (Op2 AND a b)   = "(" ++ show a ++ " && " ++ show b ++ ")"
  show (Op2 OR a b)    = "(" ++ show a ++ " | " ++ show b ++ ")"
  show (Op2 XOR a b)   = "(" ++ show a ++ " ^ " ++ show b ++ ")"
  show (Op2 SHL a b)   = "(" ++ show a ++ " << " ++ show b ++ ")"
  show (Op2 SHR a b)   = "(" ++ show a ++ " >> " ++ show b ++ ")"
  show (Op2 POW a b)   = "(" ++ show a ++ " ** " ++ show b ++ ")"
  show (Op1 NOT a)     = "(not " ++ show a ++ ")"
  show (Op1 NEG a)     = "(-" ++ show a ++ ")"
  show (Pat t m c)     = "match " ++ unwords (map show t) ++ " {" ++ showMoves ++ showCases ++ " }" where
             showMoves = if null m then "" else " with " ++ intercalate " with " (map mv m) where
               mv(k,x) = k ++ "=" ++ show x
             showCases = if null c then "" else " " ++ intercalate " " (map cs c) where
               cs(p,x) = "case " ++ unwords (map showPat p) ++ ": " ++ show x
             showPat p = "(" ++ show p ++ ")"

instance Show Book where
  show (Book defs _) = unlines (map defn (M.toList defs))
    where defn (k,(_,x,t)) = k ++ " : " ++ show t ++ " = " ++ show x

instance Show Span where
  show span = "\n\x1b[1mLocation:\x1b[0m "
    ++ "\x1b[2m(line "++show (fst $ spanBeg span)++ ", column "++show (snd $ spanBeg span)++")\x1b[0m\n"
    ++ highlightError (spanBeg span) (spanEnd span) (spanSrc span)

instance Show Error where
  show (CantInfer span ctx) = 
    "\x1b[1mCantInfer:\x1b[0m" ++
    "\n\x1b[1mContext:\x1b[0m\n" ++ show ctx ++
    show span
  show (TypeMismatch span ctx goal typ) = 
    "\x1b[1mMismatch:\x1b[0m" ++
    "\n- Goal: " ++ show goal ++ 
    "\n- Type: " ++ show typ ++
    "\n\x1b[1mContext:\x1b[0m\n" ++ show ctx ++
    show span
  show (TermMismatch span ctx a b) = 
    "\x1b[1mMismatch:\x1b[0m" ++
    "\n- " ++ show a ++ 
    "\n- " ++ show b ++
    "\n\x1b[1mContext:\x1b[0m\n" ++ show ctx ++
    show span
  show (IncompleteMatch span ctx) = 
    "\x1b[1mIncompleteMatch:\x1b[0m" ++
    "\n\x1b[1mContext:\x1b[0m\n" ++ show ctx ++
    show span

instance Show Ctx where
  show (Ctx ctx)
    | null lines = ""
    | otherwise  = init (unlines lines)
    where
      lines = map snd (reverse (clean S.empty (reverse (map showAnn ctx))))

      showAnn :: (Name,Term,Term) -> (Name,String)
      showAnn (k,_,t) = (k, "- " ++ k ++ " : " ++ show t)
    
      clean :: S.Set Name -> [(Name,String)] -> [(Name,String)]
      clean _    []                             = []
      clean seen ((n,l):xs) | n `S.member` seen = clean seen xs
                            | take 1 n == "_"   = clean seen xs
                            | otherwise         = (n,l) : clean (S.insert n seen) xs

-- Utils
-- -----

deref :: Book -> Name -> Maybe Defn
deref (Book defs _) name = M.lookup name defs

cut :: Term -> Term
cut (Loc _ t) = cut t
cut (Chk x _) = cut x
cut t         = t

unlam :: Name -> Int -> (Term -> Term) -> Term
unlam k d f = f (Var k d)

collectArgs :: Term -> ([(String, Term)], Term)
collectArgs = go [] where
  go acc (Loc _ t)         = go acc t
  go acc (All t (Lam k f)) = go (acc ++ [(k, t)]) (f (Var k 0))
  go acc goal              = (acc, goal)

collectApps :: Term -> [Term] -> (Term, [Term])
collectApps (cut -> App f x) args = collectApps f (x:args)
collectApps f                args = (f, args)

noSpan :: Span
noSpan = Span (0,0) (0,0) ""

flattenTup :: Term -> [Term]
flattenTup (Tup l r) = l : flattenTup r
flattenTup t         = [t]

lastElem :: Term -> Maybe Term
lastElem (Tup _ r) = lastElem r
lastElem t         = Just t

prettyCtr :: Term -> Maybe String
prettyCtr (Tup (Sym name) rest) = 
  case lastElem rest of
    Just One -> Just ("@" ++ name ++ "{" ++ intercalate "," (map show (init (flattenTup rest))) ++ "}")
    _        -> Nothing
prettyCtr _ = Nothing

prettyStr :: Term -> Maybe String
prettyStr = go [] where
  go :: [Char] -> Term -> Maybe String
  go acc Nil                        = Just ("\"" ++ reverse acc ++ "\"")
  go acc (Con (Val (CHR_V c)) rest) = go (c:acc) rest
  go acc (Loc _ t)                  = go acc t
  go _   _                          = Nothing
