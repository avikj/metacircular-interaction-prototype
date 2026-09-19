module Core.Projection
  ( MemberRoot(..)
  , RootSelector(..)
  , SubtermAddress(..)
  , Projection(..)
  , ProjectionError(..)
  , projectSubterm
  , projectAddressed
  , sourceSpanAt
  ) where

import Core.Check (check, extend, infer)
import Core.Deps (getDeps)
import Core.Reify (Flat(..), alphaTerm, reifyTerm, reflectTermIn)
import Core.Type
import Core.WHNF (force)
import qualified Data.ByteString as Bytes
import qualified Data.Map.Strict as M
import qualified Data.Set as S

-- A path is a sequence of child indices in reifyTerm's first-order tree.
-- Component references can be supplied by UCM above this layer; Bend names
-- here only select members of the checked dependency-closed Book.
data MemberRoot
  = DefinitionBody Name
  | DefinitionType Name
  | HitType Name
  | HitConstructorType Name Name
  deriving (Eq, Show)

data RootSelector
  = BodyRoot
  | TypeRoot
  | HitRoot
  | ConstructorRoot Name
  deriving (Eq, Show)

data SubtermAddress = SubtermAddress
  { addressComponentHash :: Bytes.ByteString
  , addressMemberIndex :: Int
  , addressRoot :: RootSelector
  , addressTermPath :: [Int]
  } deriving (Eq, Show)

data Projection = Projection
  { projectionAddress :: Maybe SubtermAddress
  , projectionRoot :: MemberRoot
  , projectionPath :: [Int]
  , projectionConstructors :: [String]
  , projectionFlat :: Flat
  , projectionTerm :: Term
  , projectionType :: Term
  , projectionDependencies :: S.Set Name
  , projectionSpan :: Maybe Span
  }

data ProjectionError
  = MissingMember Name
  | MissingConstructor Name Name
  | InvalidPath [Int]
  | NonTermNode [Int] String
  | MissingBinderType [Int]
  | CannotTypeSubterm [Int] Error
  | InvalidReification [Int] String
  | InvalidMemberIndex Int
  | InvalidComponentHashLength Int
  deriving (Show)

-- The component member order is ComponentPlan.componentNames. The hash is the
-- SHA3-512 component digest, not an emitted HVM artifact hash.
projectAddressed :: Bytes.ByteString -> [Name] -> Book -> Int -> RootSelector -> [Int]
                 -> Either ProjectionError Projection
projectAddressed digest names book memberIndex selector path = do
  if Bytes.length digest == 64
    then pure ()
    else Left (InvalidComponentHashLength (Bytes.length digest))
  name <- if memberIndex >= 0 && memberIndex < length names
    then Right (names !! memberIndex)
    else Left (InvalidMemberIndex memberIndex)
  let root = case selector of
        BodyRoot -> DefinitionBody name
        TypeRoot -> DefinitionType name
        HitRoot -> HitType name
        ConstructorRoot ctor -> HitConstructorType name ctor
  (term,_) <- memberRoot book root
  presentationPath <- translatePath (alphaTerm term) (reifyTerm term) path
  projection <- projectSubterm book root presentationPath
  pure projection
    { projectionAddress = Just (SubtermAddress digest memberIndex selector path)
    , projectionPath = path }

-- The address path follows alphaTerm, which excludes presentation-only Loc,
-- Sub, and binder-name nodes. Translate it to the current presentation tree
-- only while serving the query. Thus source-span edits do not move subterms.
translatePath :: Flat -> Flat -> [Int] -> Either ProjectionError [Int]
translatePath canonical presentation path = go [] canonical presentation path
  where
    go traversed c p rest = case p of
      Node "Loc" [_,inner] -> go (traversed ++ [1]) c inner rest
      Node "Sub" [inner] -> go (traversed ++ [0]) c inner rest
      _ -> case rest of
        [] -> Right traversed
        index:more -> case (c,p) of
          (Node ctag cc,Node ptag pc)
            | ctag == ptag && index >= 0 && index < length cc ->
                let pIndex = if ctag `elem` ["Fix","Lam","PLm"] then index + 1 else index
                in if pIndex < length pc
                     then go (traversed ++ [pIndex]) (cc !! index) (pc !! pIndex) more
                     else Left (InvalidPath path)
          _ -> Left (InvalidPath path)

-- Resolve the same canonical path against an authored, location-bearing term
-- without requiring the authored namespace to be the executable namespace.
-- This is used with bend_presentation source bytes after stored Loc nodes
-- have been removed from the hashed component.
sourceSpanAt :: Term -> [Int] -> Either ProjectionError (Maybe Span)
sourceSpanAt term canonicalPath = do
  let presented = reifyTerm term
  physicalPath <- translatePath (alphaTerm term) presented canonicalPath
  locate Nothing presented physicalPath
  where
    locate current _ [] = Right current
    locate current (Node tag children) (index:rest)
      | index >= 0 && index < length children =
          let current' = case (tag,index,children) of
                ("Loc",1,[spanNode,_]) -> flatSpan spanNode
                _ -> current
          in locate current' (children !! index) rest
    locate _ _ _ = Left (InvalidPath canonicalPath)

projectSubterm :: Book -> MemberRoot -> [Int] -> Either ProjectionError Projection
projectSubterm book root path = do
  (term, typ) <- memberRoot book root
  walk [] [] (Ctx []) [] (Just typ) Nothing (reifyTerm term) path
  where
    walk traversed tags ctx env expected source node rest =
      let here = reverse traversed
          tag = case node of Node name _ -> name; _ -> "atom"
          tags' = tags ++ [tag]
      in case rest of
        [] -> do
          term <- either (Left . InvalidReification here) Right (reflectTermIn env node)
          typ <- case expected of
            Just known -> case check (contextDepth ctx) noSpan book ctx term known of
              Done () -> Right known
              Fail err -> Left (CannotTypeSubterm here err)
            Nothing -> case infer (contextDepth ctx) noSpan book ctx term of
              Done inferred -> Right inferred
              Fail err -> Left (CannotTypeSubterm here err)
          let Ctx bindings = ctx
              bound = S.fromList [name | (name,_,_) <- bindings]
          Right Projection
            { projectionAddress = Nothing
            , projectionRoot = root
            , projectionPath = path
            , projectionConstructors = tags'
            , projectionFlat = node
            , projectionTerm = term
            , projectionType = force book typ
            , projectionDependencies = getDeps term `S.difference` bound
            , projectionSpan = source
            }
        index:more -> case node of
          Node constructor children
            | index >= 0 && index < length children -> do
                let child = children !! index
                    source' = case (constructor,index,children) of
                      ("Loc",1,[spanNode,_]) -> flatSpan spanNode
                      _ -> source
                (ctx',env',childExpected) <-
                  if constructor `elem` ["Lam","PLm","Fix"] && index == 1
                    then enterBinder book here constructor ctx env expected children
                    else Right (ctx,env,expectedChild book ctx env expected constructor index children)
                walk (index:traversed) tags' ctx' env' childExpected source' child more
            | otherwise -> Left (InvalidPath (here ++ [index]))
          _ -> Left (InvalidPath (here ++ [index]))

memberRoot :: Book -> MemberRoot -> Either ProjectionError (Term,Term)
memberRoot (Book defs hits) root = case root of
  DefinitionBody name ->
    maybe (Left (MissingMember name)) (\(_,body,typ) -> Right (body,typ)) (M.lookup name defs)
  DefinitionType name ->
    maybe (Left (MissingMember name)) (\(_,_,typ) -> Right (typ,Set)) (M.lookup name defs)
  HitType name ->
    maybe (Left (MissingMember name)) (\hit -> Right (hitType hit,Set)) (M.lookup name hits)
  HitConstructorType hitName ctorName -> do
    hit <- maybe (Left (MissingMember hitName)) Right (M.lookup hitName hits)
    ctor <- maybe (Left (MissingConstructor hitName ctorName)) Right (lookup ctorName (hitCtors hit))
    Right (ctorType ctor,Set)

enterBinder :: Book -> [Int] -> String -> Ctx -> [Term] -> Maybe Term -> [Flat]
            -> Either ProjectionError (Ctx,[Term],Maybe Term)
enterBinder book path constructor ctx env expected children =
  case (children,expected) of
    ([Text name,_],Just goal) ->
      let depth = contextDepth ctx
          variable = Var name depth
          binderType = case (constructor,force book goal) of
            ("Lam",All domain _) -> Just domain
            ("PLm",Pth _ _ _) -> Just Itv
            ("Fix",_) -> Just goal
            _ -> Nothing
          bodyType = case (constructor,force book goal) of
            ("Lam",All _ (Lam _ body)) -> Just (body variable)
            ("PLm",Pth family _ _) -> Just (App family variable)
            ("Fix",_) -> Just goal
            _ -> Nothing
      in case binderType of
        Just domain -> Right (extend ctx name variable domain,variable:env,bodyType)
        Nothing -> Left (MissingBinderType path)
    _ -> Left (MissingBinderType path)

expectedChild :: Book -> Ctx -> [Term] -> Maybe Term -> String -> Int -> [Flat] -> Maybe Term
expectedChild book ctx env inherited constructor index children =
  let reflect flat = either (const Nothing) Just (reflectTermIn env flat)
      inferFlat flat = do
        term <- reflect flat
        case infer (contextDepth ctx) noSpan book ctx term of
          Done typ -> Just typ
          Fail _ -> Nothing
      at i = if i < length children then Just (children !! i) else Nothing
      telescopeAfter tel prior = foldl step (Just tel) prior
        where
          step current flat = do
            currentType <- current
            argument <- reflect flat
            case force book currentType of
              All _ codomain -> Just (App codomain argument)
              _ -> Nothing
      telescopeDomain tel prior = do
        rest <- telescopeAfter tel prior
        case force book rest of
          All domain _ -> Just domain
          _ -> Nothing
  in case (constructor,index) of
    ("Body",0) -> inherited
    ("Loc",1) -> inherited
    ("Sub",0) -> inherited
    ("Chk",0) -> at 1 >>= reflect
    ("Chk",1) -> Just Set
    ("All",0) -> Just Set
    ("All",1) -> do
      a <- at 0 >>= reflect
      Just (All a (Lam "_" (\_ -> Set)))
    ("Sig",0) -> Just Set
    ("Sig",1) -> do
      a <- at 0 >>= reflect
      Just (All a (Lam "_" (\_ -> Set)))
    ("Lst",0) -> Just Set
    ("Tup",0) -> case inherited of
      Just goal -> case force book goal of
        Sig domain _ -> Just domain
        _ -> Nothing
      _ -> Nothing
    ("Tup",1) -> do
      goal <- inherited
      first <- at 0 >>= reflect
      case force book goal of
        Sig _ codomain -> Just (App codomain first)
        _ -> Nothing
    ("Con",0) -> do
      goal <- inherited
      case force book goal of
        Lst element -> Just element
        _ -> Nothing
    ("Con",1) -> inherited
    ("Eql",0) -> Just Set
    ("Eql",1) -> at 0 >>= reflect
    ("Eql",2) -> at 0 >>= reflect
    ("Pth",0) -> Just (All Itv (Lam "_" (\_ -> Set)))
    ("Pth",1) -> do
      family <- at 0 >>= reflect
      Just (App family I0)
    ("Pth",2) -> do
      family <- at 0 >>= reflect
      Just (App family I1)
    ("HTy",1) -> do
      case at 0 of
        Just (Text name) -> hitType <$> derefHit book name
        _ -> Nothing
    ("HCon",2) -> do
      case at 1 of
        Just (Text name) -> ctorType . (\(_,_,ctor) -> ctor) <$> derefCtor book name
        _ -> Nothing
    ("HCon",3) -> do
      case (at 1,at 2) of
        (Just (Text name),Just (Node "Params" params)) -> do
          (_,_,ctor) <- derefCtor book name
          telescopeAfter (ctorType ctor) params
        _ -> Nothing
    ("HCon",4) -> Just Itv
    ("Params",_) -> inherited >>= \tel -> telescopeDomain tel (take index children)
    ("Args",_) -> inherited >>= \tel -> telescopeDomain tel (take index children)
    ("Intervals",_) -> Just Itv
    ("App",0) ->
      (at 0 >>= inferFlat) `orElse` do
        argumentType <- at 1 >>= inferFlat
        resultType <- inherited
        Just (All argumentType (Lam "_" (\_ -> resultType)))
    ("App",1) -> do
      f <- at 0 >>= inferFlat
      case force book f of
        All domain _ -> Just domain
        _ -> Nothing
    ("Let",0) -> at 0 >>= inferFlat
    ("Let",1) -> do
      valueType <- at 0 >>= inferFlat
      resultType <- inherited
      Just (All valueType (Lam "_" (\_ -> resultType)))
    ("Op2",2) -> (at 3 >>= inferFlat) `orElse` inherited
    ("Op2",3) -> (at 2 >>= inferFlat) `orElse` inherited
    ("Op1",1) -> inherited
    ("BitM",0) -> Just Bit
    ("NatM",0) -> Just Nat
    ("Suc",0) -> Just Nat
    ("Coe",0) -> Just (All Itv (Lam "_" (\_ -> Set)))
    ("Coe",1) -> Just Itv
    ("Coe",2) -> Just Itv
    ("Coe",3) -> do
      family <- at 0 >>= reflect
      origin <- at 1 >>= reflect
      Just (App family origin)
    ("Trp",0) -> Just (All Itv (Lam "_" (\_ -> Set)))
    ("Trp",1) -> Just Itv
    ("Trp",2) -> do
      family <- at 0 >>= reflect
      Just (App family I0)
    ("Prt",0) -> Just Itv
    ("Prt",1) -> Just Set
    ("Rst",0) -> Just Set
    ("Rst",1) -> Just Itv
    ("Rst",2) -> at 0 >>= reflect
    ("Glu",0) -> Just Set
    ("GlB",0) -> Just Set
    ("GlB",2) -> at 0 >>= reflect
    ("Tru",0) -> Just Set
    ("TIn",0) -> do
      goal <- inherited
      case force book goal of
        Tru carrier -> Just carrier
        _ -> Nothing
    ("Quo",0) -> Just Set
    ("Quo",1) -> do
      carrier <- at 0 >>= reflect
      Just (All carrier (Lam "_" (\_ -> All carrier (Lam "_" (\_ -> Set)))))
    ("QCl",0) -> do
      goal <- inherited
      case force book goal of
        Quo carrier _ -> Just carrier
        _ -> Nothing
    ("TSq",0) -> at 0 >>= inferFlat
    ("TSq",1) -> at 0 >>= inferFlat
    ("CRec",0) -> Just Cir
    ("CRec",1) -> at 1 >>= inferFlat
    ("CRec",2) -> do
      branch <- at 1 >>= reflect
      branchType <- at 1 >>= inferFlat
      Just (Pth (Lam "_" (\_ -> branchType)) branch branch)
    ("HCm",0) -> Just Set
    ("HCm",2) -> at 0 >>= reflect
    ("Sys",_) -> Nothing
    ("Log",0) -> Just (Lst (Num CHR_T))
    ("Log",1) -> inherited
    ("INot",0) -> Just Itv
    ("IAnd",_) -> Just Itv
    ("IOr",_) -> Just Itv
    ("PAp",1) -> Just Itv
    _ -> Nothing
  where
    orElse (Just value) _ = Just value
    orElse Nothing fallback = fallback

contextDepth :: Ctx -> Int
contextDepth (Ctx bindings) = length bindings

flatSpan :: Flat -> Maybe Span
flatSpan (Node "Span" [NatAtom bl,NatAtom bc,NatAtom el,NatAtom ec,Text src]) =
  Just (Span (bl,bc) (el,ec) src)
flatSpan _ = Nothing
