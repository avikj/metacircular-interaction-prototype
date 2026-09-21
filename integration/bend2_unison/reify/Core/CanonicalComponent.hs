module Core.CanonicalComponent
  ( CanonicalNames(..)
  , namesForComponent
  , encodeCanonicalComponent
  , canonicalOrder
  , decodeCanonicalComponent
  , decodeCanonicalComponentSynthetic
  , syntheticMemberName
  , syntheticConstructorName
  , parseSyntheticMemberName
  , parseSyntheticConstructorName
  ) where

import Core.FlatCodec (decodeFlat, encodeFlat)
import Core.Reify (Flat(..), reflectDefn, reflectHit, reifyDefn, reifyHit)
import Core.Type (Book(..), Name, hitCtors)
import qualified Data.ByteString as Bytes
import qualified Data.ByteString.Lazy as Lazy
import qualified Data.Map.Strict as Map
import Data.List (groupBy, permutations, sortOn)
import Numeric (showHex)
import Data.Char (digitToInt, isHexDigit)

type Reference = (Bytes.ByteString, Int)

-- Presentation information lives outside the content-addressed payload.
-- Namespace lookup supplies names for external refs; authored HIT source
-- supplies constructor names by ordinal. Multiple aliases may be kept by the
-- caller; this table chooses one executable name per address.
data CanonicalNames = CanonicalNames
  { canonicalMemberNames :: [Name]
  , canonicalLocalConstructors :: Map.Map Int [Name]
  , canonicalExternalNames :: Map.Map Reference Name
  , canonicalExternalConstructors :: Map.Map (Reference,Int) Name
  }

namesForComponent :: [Name] -> Map.Map Name Reference -> Book -> CanonicalNames
namesForComponent members resolved (Book _ hits) =
  CanonicalNames
    { canonicalMemberNames = members
    , canonicalLocalConstructors =
        Map.fromList
          [ (slot,map fst (hitCtors hit))
          | (slot,name) <- zip [0..] members
          , Just hit <- [Map.lookup name hits] ]
    , canonicalExternalNames =
        Map.fromListWith min
          [ (ref,name) | (name,ref) <- Map.toList resolved ]
    , canonicalExternalConstructors =
        Map.fromListWith min
          [ ((ref,ordinal),ctor)
          | (hitName,hit) <- Map.toAscList hits
          , Just ref <- [Map.lookup hitName resolved]
          , (ordinal,(ctor,_)) <- zip [0..] (hitCtors hit) ]
    }

-- Encode the exact checked component object that receives the codebase hash.
-- Local names become slots; external names become already-addressed refs.
-- HIT constructor names become ordinals under their HIT address. The full
-- checked Book supplies constructor ownership for external HIT references.
encodeCanonicalComponent
  :: [Name] -> Map.Map Name Reference -> Book -> Book
  -> Either String Lazy.ByteString
encodeCanonicalComponent members resolved fullBook (Book defs hits) = do
  let locals = Map.fromList (zip members [0..])
      fullHits = case fullBook of Book _ hs -> hs
      resolve name = case Map.lookup name locals of
        Just slot -> Right (Node "LocalRef" [NatAtom slot])
        Nothing -> case Map.lookup name resolved of
          Just (digest,index)
            | Bytes.length digest == 64 -> Right (externalRef digest index)
            | otherwise -> Left ("invalid external digest length for " ++ name)
          Nothing -> Left ("unresolved Bend2 name: " ++ name)
      constructorOrdinal hitName ctorName = do
        hit <- maybe (Left ("unknown HIT: " ++ hitName)) Right (Map.lookup hitName fullHits)
        maybe (Left ("unknown constructor " ++ ctorName ++ " of " ++ hitName)) Right
          (lookup ctorName (zip (map fst (hitCtors hit)) [0..]))
      constructorRef ctorName =
        case [ (hitName,ordinal)
             | (hitName,hit) <- Map.toAscList fullHits
             , (ordinal,(name,_)) <- zip [0..] (hitCtors hit)
             , name == ctorName ] of
          [(hitName,ordinal)] -> do
            hitRef <- resolve hitName
            Right (Node "CtorRef" [hitRef,NatAtom ordinal])
          [] -> Left ("unknown HIT constructor: " ++ ctorName)
          _ -> Left ("ambiguous HIT constructor name: " ++ ctorName)
      transform flat = case flat of
        Global name -> resolve name
        Node "Loc" [_,term] -> transform term
        Node "Sub" [term] -> transform term
        Node tag [Text _,body] | tag `elem` ["Fix","Lam","PLm"] ->
          Node tag . pure <$> transform body
        Node "HTy" [Text name,args] ->
          Node "HTy" <$> sequence [resolve name,transform args]
        Node "HCon" [Text hitName,Text ctorName,ps,args,ivs] -> do
          hitRef <- resolve hitName
          ordinal <- constructorOrdinal hitName ctorName
          Node "HCon" <$> sequence
            [Right hitRef,Right (NatAtom ordinal),transform ps,transform args,transform ivs]
        Node "Branch" [Text ctorName,body] ->
          Node "Branch" <$> sequence [constructorRef ctorName,transform body]
        Node "Ctor" [Text _,nargs,dim,typ] ->
          Node "Ctor" <$> sequence [transform nargs,transform dim,transform typ]
        Node tag children -> Node tag <$> traverse transform children
        atom -> Right atom
      member name = do
        defn <- traverse (transform . reifyDefn) (Map.lookup name defs)
        hit <- traverse (transform . reifyHit) (Map.lookup name hits)
        Right (Node "Member"
          [maybe (Node "Absent" []) id defn,maybe (Node "Absent" []) id hit])
  entries <- traverse member members
  if Map.keysSet defs /= Map.keysSet (Map.fromList [(n,()) | n <- members, Map.member n defs])
       || Map.keysSet hits /= Map.keysSet (Map.fromList [(n,()) | n <- members, Map.member n hits])
    then Left "component members do not match slot names"
    else Right (encodeFlat (Node "CanonicalBendComponentV2" entries))

-- Establish slot order from name-free member shapes. Distinct shapes sort by
-- their bytes; within a tied shape class, select the bytewise least full
-- component encoding. Thus renaming, including within a recursive SCC, does
-- not change either the exact persisted bytes or their content hash. The
-- tied-class search is deliberately exact; a graph-labeling optimization can
-- replace it without changing the wire format.
canonicalOrder
  :: [Name] -> Map.Map Name Reference -> Book -> Book
  -> Either String ([Name],Lazy.ByteString)
canonicalOrder members resolved fullBook componentBook = do
  initial <- encodeCanonicalComponent members resolved fullBook componentBook
  parsed <- decodeFlat initial
  entries <- case parsed of
    Node "CanonicalBendComponentV2" xs -> Right xs
    _ -> Left "invalid canonical component during ordering"
  let shaped = sortOn fst
        [ (encodeFlat (eraseLocalSlots entry),name)
        | (name,entry) <- zip members entries ]
      classes = map (map snd) (groupBy (\a b -> fst a == fst b) shaped)
      orders = foldr
        (\names tails -> [permutation ++ suffix
                         | permutation <- permutations names, suffix <- tails])
        [[]] classes
      searchSize = product (map (factorial . length) classes)
      choose acc order = do
        bytes <- encodeCanonicalComponent order resolved fullBook componentBook
        Right (case acc of
          Nothing -> Just (order,bytes)
          Just best@(_,bestBytes)
            | bytes < bestBytes -> Just (order,bytes)
            | otherwise -> Just best)
  if searchSize > 100000
    then do
      -- Exact graph canonicalization of a very large tied SCC needs a more
      -- scalable labeling algorithm. This deterministic fallback preserves
      -- collision resistance and termination; such components may change
      -- address on rename.
      let order = concatMap (sortOn id) classes
      bytes <- encodeCanonicalComponent order resolved fullBook componentBook
      Right (order,bytes)
    else case foldl' (\result order -> result >>= \acc -> choose acc order)
                     (Right Nothing) orders of
      Left err -> Left err
      Right (Just answer) -> Right answer
      Right Nothing -> Left "empty canonical member ordering"
  where
    factorial n = product [1 .. toInteger n]

eraseLocalSlots :: Flat -> Flat
eraseLocalSlots (Node "LocalRef" [NatAtom _]) = Node "LocalRef" []
eraseLocalSlots (Node tag children) = Node tag (map eraseLocalSlots children)
eraseLocalSlots atom = atom

decodeCanonicalComponent :: CanonicalNames -> Lazy.ByteString -> Either String Book
decodeCanonicalComponent names bytes = do
  flat <- decodeFlat bytes
  entries <- case flat of
    Node "CanonicalBendComponentV2" members -> Right members
    _ -> Left "invalid canonical Bend2 component envelope"
  let memberNames = canonicalMemberNames names
  if length entries /= length memberNames
    then Left "canonical Bend2 member count differs from presentation table"
    else do
      pairs <- traverse decodeMember (zip [0..] entries)
      let definitions = [(name,defn) | (name,Just defn,_) <- pairs]
          hits = [(name,hit) | (name,_,Just hit) <- pairs]
      Right (Book (Map.fromList definitions) (Map.fromList hits))
  where
    local slot = maybe (Left ("missing local member slot " ++ show slot)) Right
      (at slot (canonicalMemberNames names))
    external digest slot =
      maybe (Left "missing external presentation name") Right
        (Map.lookup (digest,slot) (canonicalExternalNames names))
    ref flat = case flat of
      Node "LocalRef" [NatAtom slot] -> local slot
      Node "ExternalRef" [Node "Digest" digestAtoms,NatAtom slot] -> do
        digest <- digestBytes digestAtoms
        external digest slot
      _ -> Left ("invalid canonical reference: " ++ show flat)
    ctorName hitRef ordinal = case hitRef of
      Node "LocalRef" [NatAtom slot] -> do
        ctors <- maybe (Left "missing local HIT constructor names") Right
          (Map.lookup slot (canonicalLocalConstructors names))
        maybe (Left "missing local HIT constructor ordinal") Right (at ordinal ctors)
      Node "ExternalRef" [Node "Digest" digestAtoms,NatAtom slot] -> do
        digest <- digestBytes digestAtoms
        maybe (Left "missing external HIT constructor name") Right
          (Map.lookup ((digest,slot),ordinal) (canonicalExternalConstructors names))
      _ -> Left "invalid HIT constructor owner reference"
    restore flat = case flat of
      Node "LocalRef" _ -> Global <$> ref flat
      Node "ExternalRef" _ -> Global <$> ref flat
      Node tag [body] | tag `elem` ["Fix","Lam","PLm"] ->
        Node tag <$> sequence [Right (Text "_"), Node "Body" . pure <$> restoreBody body]
      Node "HTy" [hitRef,args] ->
        Node "HTy" <$> sequence [Text <$> ref hitRef,restore args]
      Node "HCon" [hitRef,NatAtom ordinal,ps,args,ivs] -> do
        hitName <- ref hitRef
        ctor <- ctorName hitRef ordinal
        Node "HCon" <$> sequence
          [Right (Text hitName),Right (Text ctor),restore ps,restore args,restore ivs]
      Node "Branch" [ctorRef,body] -> case ctorRef of
        Node "CtorRef" [hitRef,NatAtom ordinal] -> do
          ctor <- ctorName hitRef ordinal
          Node "Branch" <$> sequence [Right (Text ctor),restore body]
        _ -> Left "invalid canonical constructor branch reference"
      Node tag children -> Node tag <$> traverse restore children
      atom -> Right atom
    -- The canonical binder's one child is the original Body wrapper.
    restoreBody (Node "Body" [body]) = restore body
    restoreBody other = Left ("invalid canonical binder body: " ++ show other)
    restoreHit slot flat = do
      restored <- restore flat
      ctors <- maybe (Left "missing HIT constructor presentation") Right
        (Map.lookup slot (canonicalLocalConstructors names))
      case restored of
        Node "HitDecl" [arity,typ,Node "Constructors" bodies]
          | length ctors == length bodies -> do
              withNames <- traverse (uncurry addCtorName) (zip ctors bodies)
              reflectHit (Node "HitDecl" [arity,typ,Node "Constructors" withNames])
        _ -> Left "invalid canonical HIT declaration"
    addCtorName name (Node "Ctor" [nargs,dim,typ]) =
      Right (Node "Ctor" [Text name,nargs,dim,typ])
    addCtorName _ other = Left ("invalid canonical HIT constructor: " ++ show other)
    decodeMember (slot,Node "Member" [defn,hit]) = do
      name <- local slot
      definition <- case defn of
        Node "Absent" [] -> Right Nothing
        _ -> Just <$> (restore defn >>= reflectDefn)
      hitDecl <- case hit of
        Node "Absent" [] -> Right Nothing
        _ -> Just <$> restoreHit slot hit
      Right (name,definition,hitDecl)
    decodeMember _ = Left "invalid canonical Bend2 member"

-- Runtime loading needs no authored namespace. Every address is converted to
-- the same synthetic Bend name in every dependency closure; multiple source
-- aliases therefore link to one checked object. UI names remain external.
decodeCanonicalComponentSynthetic
  :: Bytes.ByteString -> Lazy.ByteString -> Either String Book
decodeCanonicalComponentSynthetic digest bytes = do
  if Bytes.length digest == 64
    then pure ()
    else Left "invalid component digest length"
  flat <- decodeFlat bytes
  entries <- case flat of
    Node "CanonicalBendComponentV2" members -> Right members
    _ -> Left "invalid canonical Bend2 component envelope"
  let localNames = [syntheticMemberName digest i | i <- [0 .. length entries - 1]]
      localCtors = Map.fromList
        [ (slot,[syntheticConstructorName digest slot ordinal
                 | ordinal <- [0 .. length ctors - 1]])
        | (slot,Node "Member" [_,Node "HitDecl" [_,_,Node "Constructors" ctors]]) <-
            zip [0..] entries ]
      externals = collectExternals flat
      externalNames = Map.fromList
        [ (ref,uncurry syntheticMemberName ref) | ref <- externals ]
      externalCtors = Map.fromList
        [ ((ref,ordinal),let (owner,slot) = ref in syntheticConstructorName owner slot ordinal)
        | (ref,ordinal) <- collectCtorRefs flat ]
      names = CanonicalNames localNames localCtors externalNames externalCtors
  decodeCanonicalComponent names bytes

syntheticMemberName :: Bytes.ByteString -> Int -> Name
syntheticMemberName digest slot = "BendComponent_" ++ hexDigest digest ++ "_" ++ show slot

syntheticConstructorName :: Bytes.ByteString -> Int -> Int -> Name
syntheticConstructorName digest slot ordinal =
  "BendCtor_" ++ hexDigest digest ++ "_" ++ show slot ++ "_" ++ show ordinal

parseSyntheticMemberName :: Name -> Maybe (Bytes.ByteString,Int)
parseSyntheticMemberName name = do
  rest <- stripPrefix "BendComponent_" name
  let (hex,slotText) = splitAt 128 rest
  if length hex /= 128 || any (not . isHexDigit) hex || take 1 slotText /= "_"
    then Nothing
    else do
      slot <- case reads (drop 1 slotText) of
        [(value,"")] | value >= 0 -> Just value
        _ -> Nothing
      Just (Bytes.pack [fromIntegral (digitToInt a * 16 + digitToInt b)
                       | (a,b) <- hexPairs hex],slot)
  where
    stripPrefix prefix input
      | take (length prefix) input == prefix = Just (drop (length prefix) input)
      | otherwise = Nothing
    hexPairs (a:b:rest) = (a,b) : hexPairs rest
    hexPairs _ = []

parseSyntheticConstructorName :: Name -> Maybe (Bytes.ByteString,Int,Int)
parseSyntheticConstructorName name = do
  rest <- stripPrefix "BendCtor_" name
  let (hex,numbers) = splitAt 128 rest
  if length hex /= 128 || any (not . isHexDigit) hex || take 1 numbers /= "_"
    then Nothing
    else do
      let (slotText,ordinalText) = break (== '_') (drop 1 numbers)
      slot <- parseNat slotText
      ordinal <- parseNat (drop 1 ordinalText)
      if null ordinalText
        then Nothing
        else Just (Bytes.pack [fromIntegral (digitToInt a * 16 + digitToInt b)
                              | (a,b) <- hexPairs hex],slot,ordinal)
  where
    stripPrefix prefix input
      | take (length prefix) input == prefix = Just (drop (length prefix) input)
      | otherwise = Nothing
    parseNat text = case reads text of
      [(value,"")] | value >= 0 -> Just value
      _ -> Nothing
    hexPairs (a:b:rest) = (a,b) : hexPairs rest
    hexPairs _ = []

hexDigest :: Bytes.ByteString -> String
hexDigest = concatMap twoDigits . Bytes.unpack
  where
    twoDigits value =
      let chars = showHex value ""
      in if length chars == 1 then '0':chars else chars

collectExternals :: Flat -> [Reference]
collectExternals flat = case flat of
  Node "ExternalRef" [Node "Digest" bytes,NatAtom slot] ->
    case digestBytes bytes of
      Right digest -> [(digest,slot)]
      Left _ -> []
  Node _ children -> concatMap collectExternals children
  _ -> []

collectCtorRefs :: Flat -> [(Reference,Int)]
collectCtorRefs flat = case flat of
  Node "HCon" [Node "ExternalRef" [Node "Digest" bytes,NatAtom slot],NatAtom ordinal,ps,args,ivs] ->
    let owner = case digestBytes bytes of
          Right digest -> [((digest,slot),ordinal)]
          Left _ -> []
    in owner ++ concatMap collectCtorRefs [ps,args,ivs]
  Node "CtorRef" [Node "ExternalRef" [Node "Digest" bytes,NatAtom slot],NatAtom ordinal] ->
    case digestBytes bytes of
      Right digest -> [((digest,slot),ordinal)]
      Left _ -> []
  Node _ children -> concatMap collectCtorRefs children
  _ -> []

externalRef :: Bytes.ByteString -> Int -> Flat
externalRef digest index =
  Node "ExternalRef"
    [Node "Digest" (map (WordAtom . fromIntegral) (Bytes.unpack digest)),NatAtom index]

digestBytes :: [Flat] -> Either String Bytes.ByteString
digestBytes atoms = do
  values <- traverse byte atoms
  if length values == 64
    then Right (Bytes.pack values)
    else Left "invalid external digest length"
  where
    byte (WordAtom x) | x <= 255 = Right (fromIntegral x)
    byte _ = Left "invalid external digest byte"

at :: Int -> [a] -> Maybe a
at index xs | index >= 0 && index < length xs = Just (xs !! index)
at _ _ = Nothing
