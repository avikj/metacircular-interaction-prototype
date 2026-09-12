{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- CorpusIdentity
--
-- Content identity for the corpus, computed inside the kernel.
--
-- A declaration's identity is the hash of its ELABORATED form: the
-- reflected Term/Definition, serialized canonically.  Reflected terms
-- use de Bruijn indices, so bound-variable names never enter the
-- serialization — alpha-invariance is structural, not scrubbed.
-- References to other definitions appear as their qualified names in
-- this first stratum (hash-of-structure-with-names); the second
-- stratum, hashing references by their own hashes, is derived from
-- this one outside by a fixpoint over the emitted reference lists.
--
-- What this module adds to Fibre.CorpusReflection:
--   serializeDefn : Name -> Term -> Definition -> String   (canonical)
--   refsOf        : Term / Definition -> List Name          (the edges)
--   fnv           : String -> Nat                           (FNV-1a 64)
--   line          : one exportable line per declaration:
--                   name \t hash \t ref,ref,...
--
-- Everything here is --safe: the identity of the mathematics is itself
-- checked mathematics.  A driver reads these strings back over the
-- interaction protocol; no external parser touches the terms.
------------------------------------------------------------------------

module CorpusIdentity where

open import Agda.Builtin.Reflection
open import Agda.Builtin.String
open import Agda.Builtin.Char
open import Agda.Builtin.Nat
open import Agda.Builtin.List
open import Agda.Builtin.Sigma
open import Agda.Builtin.Bool
open import Agda.Builtin.Word
open import Agda.Builtin.Float

open import Fibre.CorpusReflection using (RawDeclaration ; RawCorpus)

infixr 5 _++_
_++_ : String → String → String
_++_ = primStringAppend

infixr 5 _∷ˢ_
_∷ˢ_ : String → List String → List String
x ∷ˢ xs = x ∷ xs

joinWith : String → List String → String
joinWith sep [] = ""
joinWith sep (x ∷ []) = x
joinWith sep (x ∷ xs) = x ++ sep ++ joinWith sep xs

showN : Nat → String
showN = primShowNat

qn : Name → String
qn = primShowQName

------------------------------------------------------------------------
-- §1  Canonical serialization of the reflected syntax.
--     S-expression discipline: every constructor is one head token,
--     children in fixed order, no whitespace variability.
------------------------------------------------------------------------

sVis : Visibility → String
sVis visible   = "v"
sVis hidden    = "h"
sVis instance′ = "i"

sRel : Relevance → String
sRel relevant   = "r"
sRel irrelevant = "ir"

sQ : Quantity → String
sQ quantity-0 = "q0"
sQ quantity-ω = "qw"

sMod : Modality → String
sMod (modality r q) = sRel r ++ sQ q

sArgInfo : ArgInfo → String
sArgInfo (arg-info v m) = sVis v ++ sMod m

sLit : Literal → String
sLit (nat n)    = "ln" ++ showN n
sLit (word64 n) = "lw" ++ showN (primWord64ToNat n)
sLit (float x)  = "lf" ++ primShowFloat x
sLit (char c)   = "lc" ++ showN (primCharToNat c)
sLit (string s) = "ls" ++ primShowString s
sLit (name x)   = "lq" ++ qn x
sLit (meta x)   = "lm"

mutual
  sArgTerm : Arg Term → String
  sArgTerm (arg i t) = "(" ++ sArgInfo i ++ " " ++ sTerm t ++ ")"

  sArgs : List (Arg Term) → String
  sArgs []       = ""
  sArgs (a ∷ as) = sArgTerm a ++ sArgs as

  sAbs : Abs Term → String
  -- the bound name is metadata; identity ignores it (de Bruijn body)
  sAbs (abs _ t) = sTerm t

  sSort : Sort → String
  sSort (set t)     = "Ss" ++ sTerm t
  sSort (lit n)     = "Sl" ++ showN n
  sSort (prop t)    = "Sp" ++ sTerm t
  sSort (propLit n) = "SP" ++ showN n
  sSort (inf n)     = "Si" ++ showN n
  sSort unknown     = "Su"

  sClause : Clause → String
  sClause (clause tel ps t)      = "(c " ++ sTel tel ++ "|" ++ sPats ps ++ "|" ++ sTerm t ++ ")"
  sClause (absurd-clause tel ps) = "(a " ++ sTel tel ++ "|" ++ sPats ps ++ ")"

  sClauses : List Clause → String
  sClauses []       = ""
  sClauses (c ∷ cs) = sClause c ++ sClauses cs

  sTel : List (Σ String (λ _ → Arg Type)) → String
  sTel [] = ""
  sTel ((_ , arg i t) ∷ tel) = "(t " ++ sArgInfo i ++ " " ++ sTerm t ++ ")" ++ sTel tel

  sPat : Pattern → String
  sPat (con c ps) = "(pc " ++ qn c ++ " " ++ sPatsArgs ps ++ ")"
  sPat (dot t)    = "(pd " ++ sTerm t ++ ")"
  sPat (var x)    = "(pv " ++ showN x ++ ")"
  sPat (lit l)    = "(pl " ++ sLit l ++ ")"
  sPat (proj f)   = "(pp " ++ qn f ++ ")"
  sPat (absurd x) = "(pa " ++ showN x ++ ")"

  sPatsArgs : List (Arg Pattern) → String
  sPatsArgs []             = ""
  sPatsArgs (arg i p ∷ ps) = "(" ++ sArgInfo i ++ " " ++ sPat p ++ ")" ++ sPatsArgs ps

  sPats : List (Arg Pattern) → String
  sPats = sPatsArgs

  sTerm : Term → String
  sTerm (var x args)      = "(V " ++ showN x ++ " " ++ sArgs args ++ ")"
  sTerm (con c args)      = "(C " ++ qn c ++ " " ++ sArgs args ++ ")"
  sTerm (def f args)      = "(D " ++ qn f ++ " " ++ sArgs args ++ ")"
  sTerm (lam v t)         = "(L " ++ sVis v ++ " " ++ sAbs t ++ ")"
  sTerm (pat-lam cs args) = "(P " ++ sClauses cs ++ "|" ++ sArgs args ++ ")"
  sTerm (pi a b)          = "(Pi " ++ sArgTerm a ++ " " ++ sAbs b ++ ")"
  sTerm (agda-sort s)     = "(S " ++ sSort s ++ ")"
  sTerm (lit l)           = "(Li " ++ sLit l ++ ")"
  sTerm (meta _ args)     = "(M " ++ sArgs args ++ ")"
  sTerm unknown           = "(U)"

sNames : List Name → String
sNames []       = ""
sNames (x ∷ xs) = qn x ++ ";" ++ sNames xs

sDefn : Definition → String
sDefn (function cs)       = "[fun " ++ sClauses cs ++ "]"
sDefn (data-type pars cs) = "[dat " ++ showN pars ++ " " ++ sNames cs ++ "]"
sDefn (record-type c fs)  = "[rec " ++ qn c ++ "]"
sDefn (data-cons d _)     = "[con " ++ qn d ++ "]"
sDefn axiom               = "[axm]"
sDefn prim-fun            = "[prm]"

serializeDefn : Name → Term → Definition → String
serializeDefn n ty d = "{" ++ sTerm ty ++ " " ++ sDefn d ++ "}"
-- the declaration's own name is deliberately absent: identity is the
-- elaborated content; the name is a label kept beside it, not inside it.

------------------------------------------------------------------------
-- §2  The edges: names referenced by the elaborated content.
------------------------------------------------------------------------

infixr 5 _++ᴸ_

mutual
  refsArgs : List (Arg Term) → List Name
  refsArgs []             = []
  refsArgs (arg _ t ∷ as) = refsTerm t ++ᴸ refsArgs as

  refsClauses : List Clause → List Name
  refsClauses [] = []
  refsClauses (clause tel ps t ∷ cs)      = refsTel tel ++ᴸ (refsPats ps ++ᴸ (refsTerm t ++ᴸ refsClauses cs))
  refsClauses (absurd-clause tel ps ∷ cs) = refsTel tel ++ᴸ (refsPats ps ++ᴸ refsClauses cs)

  refsTel : List (Σ String (λ _ → Arg Type)) → List Name
  refsTel [] = []
  refsTel ((_ , arg _ t) ∷ tel) = refsTerm t ++ᴸ refsTel tel

  refsPats : List (Arg Pattern) → List Name
  refsPats [] = []
  refsPats (arg _ p ∷ ps) = refsPat p ++ᴸ refsPats ps

  refsPat : Pattern → List Name
  refsPat (con c ps) = c ∷ refsPats ps
  refsPat (dot t)    = refsTerm t
  refsPat (proj f)   = f ∷ []
  refsPat _          = []

  refsTerm : Term → List Name
  refsTerm (var _ args)      = refsArgs args
  refsTerm (con c args)      = c ∷ refsArgs args
  refsTerm (def f args)      = f ∷ refsArgs args
  refsTerm (lam _ (abs _ t)) = refsTerm t
  refsTerm (pat-lam cs args) = refsClauses cs ++ᴸ refsArgs args
  refsTerm (pi (arg _ a) (abs _ b)) = refsTerm a ++ᴸ refsTerm b
  refsTerm (agda-sort (set t))  = refsTerm t
  refsTerm (agda-sort (prop t)) = refsTerm t
  refsTerm (agda-sort _)     = []
  refsTerm (lit (name x))    = x ∷ []
  refsTerm (lit _)           = []
  refsTerm (meta _ args)     = refsArgs args
  refsTerm unknown           = []

  _++ᴸ_ : List Name → List Name → List Name
  []       ++ᴸ ys = ys
  (x ∷ xs) ++ᴸ ys = x ∷ (xs ++ᴸ ys)

refsDefn : Definition → List Name
refsDefn (function cs)     = refsClauses cs
refsDefn (data-type _ cs)  = cs
refsDefn (record-type c _) = c ∷ []
refsDefn (data-cons d _)   = d ∷ []
refsDefn _                 = []

refsOf : Term → Definition → List Name
refsOf ty d = refsTerm ty ++ᴸ refsDefn d

------------------------------------------------------------------------
-- §3  FNV-1a over the serialization (64-bit arithmetic on Nat,
--     truncated by mod 2^64).  The same hash family the repository's
--     defect log chains with — precedent, not coincidence.
------------------------------------------------------------------------

private
  two64 : Nat
  two64 = 18446744073709551616

  fnvPrime : Nat
  fnvPrime = 1099511628211

  offset : Nat
  offset = 14695981039346656037

half : Nat → Nat
half n = div-helper 0 1 n 1

parity : Nat → Nat
parity n = mod-helper 0 1 n 1

xorBit : Nat → Nat → Nat
xorBit 0 0 = 0
xorBit 1 1 = 0
xorBit _ _ = 1

-- 64-bit xor with explicit fuel: structurally terminating.
xorGo : Nat → Nat → Nat → Nat → Nat → Nat
xorGo zero    _ _ _   acc = acc
xorGo (suc k) a b bit acc =
  xorGo k (half a) (half b) (bit * 2) (acc + bit * xorBit (parity a) (parity b))

xor64 : Nat → Nat → Nat
xor64 a b = xorGo 64 a b 1 0

fnvStep : Nat → Nat → Nat
fnvStep h b = mod-helper 0 (two64 - 1) (xor64 h b * fnvPrime) (two64 - 1)

fnvChars : List Char → Nat → Nat
fnvChars []       h = h
fnvChars (c ∷ cs) h = fnvChars cs (fnvStep h (primCharToNat c))

fnv : String → Nat
fnv s = fnvChars (primStringToList s) offset

------------------------------------------------------------------------
-- §4  Export lines.
------------------------------------------------------------------------

tab : String
tab = primStringFromList ('\t' ∷ [])

nl : String
nl = primStringFromList ('\n' ∷ [])

-- The exported line carries the CANONICAL SERIALIZATION itself (the
-- identity-bearing object); hashing those bytes is representation-free
-- bookkeeping a driver may do.  fnv above remains available for
-- in-kernel hashing of small objects.
line : RawDeclaration → String
line (n , ty , d) =
  qn n ++ tab ++ serializeDefn n ty d ++ tab ++ sNames (refsOf ty d)

export : RawCorpus → String
export []       = ""
export (x ∷ xs) = line x ++ nl ++ export xs
