{-# LANGUAGE LambdaCase #-}
-- First-order snapshot of Bend's checked Term. No evaluation, checking, or
-- compiler semantics are changed. The wire codec must version this schema.
module Core.Reify
  ( Flat(..)
  , reifyTerm
  , alphaTerm
  , reifyDefn
  , reifyHit
  , reifyBook
  , reflectTerm
  , reflectTermIn
  , reflectDefn
  , reflectHit
  , reflectBook
  ) where

import Core.Type
import Data.Int (Int64)
import Data.Word (Word64)
import GHC.Float (castDoubleToWord64, castWord64ToDouble)
import Data.List (find)
import qualified Data.Map.Strict as M

-- Bound uses a de Bruijn index (0 is the innermost Fix/Lam/PLm binder).
-- Node preserves constructor and ordered arguments. Text and numeric atoms
-- are separate from terms so the representation is unambiguous.
data Flat
  = Bound Int
  | Free Name Int
  | Global Name
  | Node String [Flat]
  | Text String
  | NatAtom Int
  | WordAtom Word64
  | SignedAtom Int64
  | DoubleBits Word64
  | CharAtom Char
  | BoolAtom Bool
  deriving (Eq, Show, Read)

reifyTerm :: Term -> Flat
reifyTerm = go []
  where
    -- Parsed/checked Bend variables have nonnegative indices. These negative
    -- probes identify HOAS binders without colliding with source variables.
    binder :: [Int] -> String -> Body -> Flat
    binder env label f =
      let probe = negate (length env + 1)
      in Node label [go (probe : env) (f (Var "" probe))]

    go :: [Int] -> Term -> Flat
    go env term =
      let n tag args = Node tag (map (go env) args)
          pair (a,b) = Node "Pair" [go env a, go env b]
          triple (a,b,c) = Node "Triple" [go env a, go env b, go env c]
      in case term of
        Var "" i | i < 0 ->
          case lookupIndex i env of
            Just depth -> Bound depth
            Nothing -> Free "" i
        Var name i -> Free name i
        Ref name -> Global name
        Sub a -> n "Sub" [a]
        Fix name f -> Node "Fix" [Text name, binder env "Body" f]
        Let a b -> n "Let" [a,b]
        Set -> n "Set" []
        Chk a b -> n "Chk" [a,b]
        Emp -> n "Emp" []
        EmpM a -> n "EmpM" [a]
        Uni -> n "Uni" []
        One -> n "One" []
        UniM a b -> n "UniM" [a,b]
        Bit -> n "Bit" []
        Bt0 -> n "Bt0" []
        Bt1 -> n "Bt1" []
        BitM a b c -> n "BitM" [a,b,c]
        Nat -> n "Nat" []
        Zer -> n "Zer" []
        Suc a -> n "Suc" [a]
        NatM a b c -> n "NatM" [a,b,c]
        Lst a -> n "Lst" [a]
        Nil -> n "Nil" []
        Con a b -> n "Con" [a,b]
        LstM a b c -> n "LstM" [a,b,c]
        Enu names -> Node "Enu" (map Text names)
        Sym name -> Node "Sym" [Text name]
        EnuM a cases b -> Node "EnuM" [go env a, Node "Cases" [Node "Case" [Text name, go env body] | (name,body) <- cases], go env b]
        Num t -> Node "Num" [Text (show t)]
        Val v -> case v of
          U64_V x -> Node "U64_V" [WordAtom x]
          I64_V x -> Node "I64_V" [SignedAtom x]
          F64_V x -> Node "F64_V" [DoubleBits (castDoubleToWord64 x)]
          CHR_V x -> Node "CHR_V" [CharAtom x]
        Op2 op a b -> Node "Op2" [Text (show op), go env a, go env b]
        Op1 op a -> Node "Op1" [Text (show op), go env a]
        Sig a b -> n "Sig" [a,b]
        Tup a b -> n "Tup" [a,b]
        SigM a b -> n "SigM" [a,b]
        All a b -> n "All" [a,b]
        Lam name f -> Node "Lam" [Text name, binder env "Body" f]
        App a b -> n "App" [a,b]
        Eql a b c -> n "Eql" [a,b,c]
        Rfl -> n "Rfl" []
        EqlM a b -> n "EqlM" [a,b]
        Met i typ xs -> Node "Met" [NatAtom i, go env typ, Node "Args" (map (go env) xs)]
        Ind a -> n "Ind" [a]
        Frz a -> n "Frz" [a]
        Itv -> n "Itv" []
        I0 -> n "I0" []
        I1 -> n "I1" []
        INot a -> n "INot" [a]
        IAnd a b -> n "IAnd" [a,b]
        IOr a b -> n "IOr" [a,b]
        Pth a b c -> n "Pth" [a,b,c]
        Coe a b c d -> n "Coe" [a,b,c,d]
        Ua a b c d e f -> n "Ua" [a,b,c,d,e,f]
        HCm a faces b -> Node "HCm" [go env a, Node "Faces" (map pair faces), go env b]
        Glu a faces -> Node "Glu" [go env a, Node "Faces" (map triple faces)]
        GlB a faces b -> Node "GlB" [go env a, Node "Faces" (map pair faces), go env b]
        UnG a -> n "UnG" [a]
        Tru a -> n "Tru" [a]
        TIn a -> n "TIn" [a]
        TSq a b -> n "TSq" [a,b]
        TRec a b c -> n "TRec" [a,b,c]
        Cir -> n "Cir" []
        CBase -> n "CBase" []
        CLoop -> n "CLoop" []
        CRec a b c -> n "CRec" [a,b,c]
        Prt a b -> n "Prt" [a,b]
        Sys faces -> Node "Sys" (map pair faces)
        POut a -> n "POut" [a]
        Trp a b c -> n "Trp" [a,b,c]
        Rst a b c -> n "Rst" [a,b,c]
        InS a -> n "InS" [a]
        OutS a -> n "OutS" [a]
        Quo a b -> n "Quo" [a,b]
        QCl a -> n "QCl" [a]
        QEq a b c -> n "QEq" [a,b,c]
        QSq -> n "QSq" []
        QRec a b c d -> n "QRec" [a,b,c,d]
        HTy name ps -> Node "HTy" [Text name, Node "Args" (map (go env) ps)]
        HCon name ctor ps args ivs -> Node "HCon" [Text name, Text ctor, Node "Params" (map (go env) ps), Node "Args" (map (go env) args), Node "Intervals" (map (go env) ivs)]
        HEl p branches x -> Node "HEl" [go env p, branchList branches, go env x]
        HRec branches x -> Node "HRec" [branchList branches, go env x]
        PLm name f -> Node "PLm" [Text name, binder env "Body" f]
        PAp a b -> n "PAp" [a,b]
        Era -> n "Era" []
        Sup a b c -> n "Sup" [a,b,c]
        SupM a b c -> n "SupM" [a,b,c]
        Loc span a -> Node "Loc" [spanFlat span, go env a]
        Rwt a b c -> n "Rwt" [a,b,c]
        Log a b -> n "Log" [a,b]
        Pri op -> Node "Pri" [Text (show op)]
        Pat scrutinees moves cases ->
          Node "Pat" [ Node "Scrutinees" (map (go env) scrutinees)
                     , Node "Moves" [Node "Move" [Text name, go env value] | (name,value) <- moves]
                     , Node "Cases" [Node "Case" [Node "Args" (map (go env) args), go env body] | (args,body) <- cases] ]
        Frk a b c -> n "Frk" [a,b,c]
      where
        branchList bs = Node "Branches" [Node "Branch" [Text name, go env body] | (name,body) <- bs]

    lookupIndex _ [] = Nothing
    lookupIndex target (x:xs)
      | target == x = Just 0
      | otherwise = (1+) <$> lookupIndex target xs

    spanFlat span = Node "Span" [NatAtom (fst (spanBeg span)), NatAtom (snd (spanBeg span)),
                                 NatAtom (fst (spanEnd span)), NatAtom (snd (spanEnd span)),
                                 Text (spanSrc span)]

-- Removes presentation-only binder names and source spans for an
-- alpha-invariant structural key. Definitional equality / normal-form
-- identity must still be established by Bend's checker, not this function.
alphaTerm :: Term -> Flat
alphaTerm = scrub . reifyTerm
  where
    scrub (Node "Loc" [_, term]) = scrub term
    scrub (Node "Sub" [term]) = scrub term
    scrub (Node tag [Text _, body]) | tag `elem` ["Fix", "Lam", "PLm"] =
      Node tag [scrub body]
    scrub (Node tag args) = Node tag (map scrub args)
    scrub atom = atom

reifyDefn :: Defn -> Flat
reifyDefn (inj, body, typ) = Node "Defn" [BoolAtom inj, reifyTerm body, reifyTerm typ]

reifyHit :: HitDecl -> Flat
reifyHit hit =
  Node "HitDecl"
    [ NatAtom (hitArity hit)
    , reifyTerm (hitType hit)
    , Node "Constructors"
        [ Node "Ctor" [Text name, NatAtom (ctorNArgs ctor), NatAtom (ctorDim ctor), reifyTerm (ctorType ctor)]
        | (name,ctor) <- hitCtors hit ]
    ]

-- Names are keyed independently in Bend's definition and HIT maps. A
-- generated HIT intentionally has both entries under the same name.
reifyBook :: Book -> Flat
reifyBook (Book defs hits) =
  Node "Book"
    [ Node "Definitions" [Node "NamedDefn" [Text name, reifyDefn defn] | (name,defn) <- M.toAscList defs]
    , Node "Hits" [Node "NamedHit" [Text name, reifyHit hit] | (name,hit) <- M.toAscList hits]
    ]

-- Validate the complete first-order tree before constructing HOAS closures.
-- A closure can then substitute any argument without introducing a new
-- decoding failure: its body shape and every bound index were checked here.
reflectTerm :: Flat -> Either String Term
reflectTerm = reflectTermIn []

-- Reflect a subtree below HOAS binders. The environment is innermost-first.
reflectTermIn :: [Term] -> Flat -> Either String Term
reflectTermIn = decode
  where
    decode :: [Term] -> Flat -> Either String Term
    decode env flat =
      let d = decode env
          list label (Node actual xs) | label == actual = traverse d xs
          list label x = Left ("expected " ++ label ++ " node: " ++ show x)
          pairs (Node "Faces" xs) = traverse (\case Node "Pair" [a,b] -> (,) <$> d a <*> d b; x -> Left ("expected Pair: " ++ show x)) xs
          pairs x = Left ("expected Faces node: " ++ show x)
          triples (Node "Faces" xs) = traverse (\case Node "Triple" [a,b,c] -> (,,) <$> d a <*> d b <*> d c; x -> Left ("expected Triple: " ++ show x)) xs
          triples x = Left ("expected Faces node: " ++ show x)
          binder body = do
            _ <- decode (Var "" (-1) : env) body
            pure (\x -> checked (decode (x : env) body))
      in case flat of
        Bound index | index >= 0 && index < length env -> Right (env !! index)
        Bound index -> Left ("invalid bound index: " ++ show index)
        Free name index -> Right (Var name index)
        Global name -> Right (Ref name)
        Node tag args -> case (tag,args) of
          ("Sub",[a]) -> Sub <$> d a
          ("Fix",[Text name,Node "Body" [body]]) -> Fix name <$> binder body
          ("Let",[a,b]) -> Let <$> d a <*> d b
          ("Set",[]) -> Right Set
          ("Chk",[a,b]) -> Chk <$> d a <*> d b
          ("Emp",[]) -> Right Emp
          ("EmpM",[a]) -> EmpM <$> d a
          ("Uni",[]) -> Right Uni
          ("One",[]) -> Right One
          ("UniM",[a,b]) -> UniM <$> d a <*> d b
          ("Bit",[]) -> Right Bit
          ("Bt0",[]) -> Right Bt0
          ("Bt1",[]) -> Right Bt1
          ("BitM",[a,b,c]) -> BitM <$> d a <*> d b <*> d c
          ("Nat",[]) -> Right Nat
          ("Zer",[]) -> Right Zer
          ("Suc",[a]) -> Suc <$> d a
          ("NatM",[a,b,c]) -> NatM <$> d a <*> d b <*> d c
          ("Lst",[a]) -> Lst <$> d a
          ("Nil",[]) -> Right Nil
          ("Con",[a,b]) -> Con <$> d a <*> d b
          ("LstM",[a,b,c]) -> LstM <$> d a <*> d b <*> d c
          ("Enu",xs) -> Enu <$> traverse asText xs
          ("Sym",[Text name]) -> Right (Sym name)
          ("EnuM",[a,Node "Cases" cs,b]) ->
            EnuM <$> d a <*> traverse (\case Node "Case" [Text name,body] -> (,) name <$> d body; x -> Left ("invalid enum case: " ++ show x)) cs <*> d b
          ("Num",[Text name]) -> Num <$> byShow name [U64_T,I64_T,F64_T,CHR_T]
          ("U64_V",[WordAtom x]) -> Right (Val (U64_V x))
          ("I64_V",[SignedAtom x]) -> Right (Val (I64_V x))
          ("F64_V",[DoubleBits x]) -> Right (Val (F64_V (castWord64ToDouble x)))
          ("CHR_V",[CharAtom x]) -> Right (Val (CHR_V x))
          ("Op2",[Text name,a,b]) -> Op2 <$> byShow name [ADD,SUB,MUL,DIV,MOD,POW,EQL,NEQ,LST,GRT,LEQ,GEQ,AND,OR,XOR,SHL,SHR] <*> d a <*> d b
          ("Op1",[Text name,a]) -> Op1 <$> byShow name [NOT,NEG] <*> d a
          ("Sig",[a,b]) -> Sig <$> d a <*> d b
          ("Tup",[a,b]) -> Tup <$> d a <*> d b
          ("SigM",[a,b]) -> SigM <$> d a <*> d b
          ("All",[a,b]) -> All <$> d a <*> d b
          ("Lam",[Text name,Node "Body" [body]]) -> Lam name <$> binder body
          ("App",[a,b]) -> App <$> d a <*> d b
          ("Eql",[a,b,c]) -> Eql <$> d a <*> d b <*> d c
          ("Rfl",[]) -> Right Rfl
          ("EqlM",[a,b]) -> EqlM <$> d a <*> d b
          ("Met",[NatAtom i,typ,xs]) -> Met i <$> d typ <*> list "Args" xs
          ("Ind",[a]) -> Ind <$> d a
          ("Frz",[a]) -> Frz <$> d a
          ("Itv",[]) -> Right Itv
          ("I0",[]) -> Right I0
          ("I1",[]) -> Right I1
          ("INot",[a]) -> INot <$> d a
          ("IAnd",[a,b]) -> IAnd <$> d a <*> d b
          ("IOr",[a,b]) -> IOr <$> d a <*> d b
          ("Pth",[a,b,c]) -> Pth <$> d a <*> d b <*> d c
          ("Coe",[a,b,c,e]) -> Coe <$> d a <*> d b <*> d c <*> d e
          ("Ua",[a,b,c,e,f,g]) -> Ua <$> d a <*> d b <*> d c <*> d e <*> d f <*> d g
          ("HCm",[a,faces,b]) -> HCm <$> d a <*> pairs faces <*> d b
          ("Glu",[a,faces]) -> Glu <$> d a <*> triples faces
          ("GlB",[a,faces,b]) -> GlB <$> d a <*> pairs faces <*> d b
          ("UnG",[a]) -> UnG <$> d a
          ("Tru",[a]) -> Tru <$> d a
          ("TIn",[a]) -> TIn <$> d a
          ("TSq",[a,b]) -> TSq <$> d a <*> d b
          ("TRec",[a,b,c]) -> TRec <$> d a <*> d b <*> d c
          ("Cir",[]) -> Right Cir
          ("CBase",[]) -> Right CBase
          ("CLoop",[]) -> Right CLoop
          ("CRec",[a,b,c]) -> CRec <$> d a <*> d b <*> d c
          ("Prt",[a,b]) -> Prt <$> d a <*> d b
          ("Sys",faces) -> Sys <$> traverse (\case Node "Pair" [a,b] -> (,) <$> d a <*> d b; x -> Left ("invalid system face: " ++ show x)) faces
          ("POut",[a]) -> POut <$> d a
          ("Trp",[a,b,c]) -> Trp <$> d a <*> d b <*> d c
          ("Rst",[a,b,c]) -> Rst <$> d a <*> d b <*> d c
          ("InS",[a]) -> InS <$> d a
          ("OutS",[a]) -> OutS <$> d a
          ("Quo",[a,b]) -> Quo <$> d a <*> d b
          ("QCl",[a]) -> QCl <$> d a
          ("QEq",[a,b,c]) -> QEq <$> d a <*> d b <*> d c
          ("QSq",[]) -> Right QSq
          ("QRec",[a,b,c,e]) -> QRec <$> d a <*> d b <*> d c <*> d e
          ("HTy",[Text name,ps]) -> HTy name <$> list "Args" ps
          ("HCon",[Text name,Text ctor,ps,as,ivs]) -> HCon name ctor <$> list "Params" ps <*> list "Args" as <*> list "Intervals" ivs
          ("HEl",[p,bs,x]) -> HEl <$> d p <*> branches bs <*> d x
          ("HRec",[bs,x]) -> HRec <$> branches bs <*> d x
          ("PLm",[Text name,Node "Body" [body]]) -> PLm name <$> binder body
          ("PAp",[a,b]) -> PAp <$> d a <*> d b
          ("Era",[]) -> Right Era
          ("Sup",[a,b,c]) -> Sup <$> d a <*> d b <*> d c
          ("SupM",[a,b,c]) -> SupM <$> d a <*> d b <*> d c
          ("Loc",[span,a]) -> Loc <$> decodeSpan span <*> d a
          ("Rwt",[a,b,c]) -> Rwt <$> d a <*> d b <*> d c
          ("Log",[a,b]) -> Log <$> d a <*> d b
          ("Pri",[Text name]) -> Pri <$> byShow name [U64_TO_CHAR]
          ("Pat",[Node "Scrutinees" ss,Node "Moves" ms,Node "Cases" cs]) ->
            Pat <$> traverse d ss
                <*> traverse (\case Node "Move" [Text name,x] -> (,) name <$> d x; x -> Left ("invalid move: " ++ show x)) ms
                <*> traverse (\case Node "Case" [Node "Args" xs,body] -> (,) <$> traverse d xs <*> d body; x -> Left ("invalid pattern case: " ++ show x)) cs
          ("Frk",[a,b,c]) -> Frk <$> d a <*> d b <*> d c
          _ -> Left ("invalid Term constructor or arity: " ++ tag)
          where
            branches (Node "Branches" bs) = traverse (\case Node "Branch" [Text name,body] -> (,) name <$> d body; x -> Left ("invalid branch: " ++ show x)) bs
            branches x = Left ("expected branches: " ++ show x)
        x -> Left ("expected Term node: " ++ show x)

    checked (Right x) = x
    checked (Left err) = error ("validated reified binder failed: " ++ err)
    asText (Text s) = Right s
    asText x = Left ("expected text: " ++ show x)
    byShow name values =
      maybe (Left ("unknown atom: " ++ name)) Right (find ((== name) . show) values)
    decodeSpan (Node "Span" [NatAtom bl,NatAtom bc,NatAtom el,NatAtom ec,Text src]) =
      Right (Span (bl,bc) (el,ec) src)
    decodeSpan x = Left ("invalid span: " ++ show x)

reflectDefn :: Flat -> Either String Defn
reflectDefn (Node "Defn" [BoolAtom inj,body,typ]) =
  (\b t -> (inj,b,t)) <$> reflectTerm body <*> reflectTerm typ
reflectDefn x = Left ("invalid definition: " ++ show x)

reflectHit :: Flat -> Either String HitDecl
reflectHit (Node "HitDecl" [NatAtom arity,typ,Node "Constructors" ctors]) =
  HitDecl arity <$> reflectTerm typ <*> traverse ctor ctors
  where
    ctor (Node "Ctor" [Text name,NatAtom nargs,NatAtom dim,typ]) =
      (,) name . HitCtor nargs dim <$> reflectTerm typ
    ctor x = Left ("invalid HIT constructor: " ++ show x)
reflectHit x = Left ("invalid HIT declaration: " ++ show x)

reflectBook :: Flat -> Either String Book
reflectBook (Node "Book" [Node "Definitions" ds,Node "Hits" hs]) = do
  defs <- traverse definition ds
  hits <- traverse hit hs
  if hasDuplicates (map fst defs) || hasDuplicates (map fst hits)
    then Left "duplicate Book member name"
    else Right (Book (M.fromList defs) (M.fromList hits))
  where
    definition (Node "NamedDefn" [Text name,defn]) = (,) name <$> reflectDefn defn
    definition x = Left ("invalid named definition: " ++ show x)
    hit (Node "NamedHit" [Text name,decl]) = (,) name <$> reflectHit decl
    hit x = Left ("invalid named HIT: " ++ show x)
    hasDuplicates names = length names /= M.size (M.fromList [(name,()) | name <- names])
reflectBook x = Left ("invalid Book: " ++ show x)
