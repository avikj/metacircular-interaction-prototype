module Core.LspAnalysis
  ( BendDiagnostic(..)
  , BendAnalysis(..)
  , analyzeBendSource
  , analyzeBendBook
  , bendHoverAt
  , bendReferenceAt
  , bendDefinitionAt
  , bendDefinitionNameAt
  ) where

import Prelude hiding (span)
import Core.Admission
import Core.ComponentPlan (AddressedComponent(..),ComponentPlan(..),addressComponents)
import Core.Projection
import Core.Reify
import Core.Type
import qualified Data.ByteString as Bytes
import qualified Data.Map.Strict as Map
import Data.List (minimumBy)
import Data.Ord (comparing)

data BendDiagnostic = BendDiagnostic
  { diagnosticSpan :: Maybe Span
  , diagnosticMessage :: String
  }

data BendAnalysis = BendAnalysis
  { analysisBook :: Book
  , analysisRoots :: [(MemberRoot,Term)]
  , analysisReferences :: Map.Map Name (Bytes.ByteString,Int)
  }

analyzeBendSource :: FilePath -> String -> Either BendDiagnostic BendAnalysis
analyzeBendSource path source = case admitSource path source of
  Left failure -> Left (admissionDiagnostic failure)
  Right checked -> Right (fromChecked checked (checkedBook checked))

analyzeBendBook :: FilePath -> String -> Book -> Book -> Either BendDiagnostic BendAnalysis
analyzeBendBook path source assembled local = case admitBook path source assembled of
  Left failure -> Left (admissionDiagnostic failure)
  Right checked -> Right (fromChecked checked local)

fromChecked :: CheckedSource -> Book -> BendAnalysis
fromChecked checked (Book defs hits) =
    let book@(Book allDefs allHits) = checkedBook checked
        roots = concat
          [ [ (DefinitionBody name,body) | (name,(_,body,_)) <- Map.toList defs ]
          , [ (DefinitionType name,typ) | (name,(_,_,typ)) <- Map.toList defs ]
          , [ (HitType name,hitType hit) | (name,hit) <- Map.toList hits ]
          , [ (HitConstructorType name ctorName,ctorType ctor)
              | (name,hit) <- Map.toList hits
              , (ctorName,ctor) <- hitCtors hit ]
          ]
        refs
          | Map.size defs /= Map.size allDefs || Map.size hits /= Map.size allHits = Map.empty
          | otherwise = case addressComponents checked of
              Left _ -> Map.empty
              Right addressed -> Map.fromList
                [ (name,(addressedDigest component,index))
                | component <- addressed
                , (name,index) <- zip (componentNames (addressedPlan component)) [0..] ]
    in BendAnalysis book roots refs

admissionDiagnostic :: AdmissionError -> BendDiagnostic
admissionDiagnostic failure = case failure of
  ParseFailure message -> BendDiagnostic Nothing message
  DefinitionTypeFailure name err -> BendDiagnostic (errorSpan err) (name ++ ": " ++ errorMessage err)
  DefinitionTermFailure name err -> BendDiagnostic (errorSpan err) (name ++ ": " ++ errorMessage err)
  HitTypeFailure name err -> BendDiagnostic (errorSpan err) (name ++ ": " ++ errorMessage err)
  HitConstructorFailure name ctor err -> BendDiagnostic (errorSpan err) (name ++ "." ++ ctor ++ ": " ++ errorMessage err)
  OriginFailure message -> BendDiagnostic Nothing message

errorSpan :: Error -> Maybe Span
errorSpan err = Just $ case err of
  CantInfer span _ -> span
  TypeMismatch span _ _ _ -> span
  TermMismatch span _ _ _ -> span
  IncompleteMatch span _ -> span

errorMessage :: Error -> String
errorMessage err = case err of
  CantInfer _ _ -> "Cannot infer type"
  TypeMismatch _ _ expected actual -> "Type mismatch: expected " ++ show expected ++ ", inferred " ++ show actual
  TermMismatch _ _ left right -> "Terms differ: " ++ show left ++ " and " ++ show right
  IncompleteMatch _ _ -> "Incomplete pattern match"

-- Positions accepted here use Bend's one-based source coordinates.
bendHoverAt :: BendAnalysis -> (Int,Int) -> Maybe (String,Maybe Span)
bendHoverAt analysis pos = do
  (root,path,span) <- innermostTerm analysis pos
  projection <- either (const Nothing) Just (projectSubterm (analysisBook analysis) root path)
  pure (show (projectionType projection),Just span)

bendReferenceAt :: BendAnalysis -> (Int,Int) -> Maybe (Bytes.ByteString,Int)
bendReferenceAt analysis pos = do
  (root,_,_) <- innermostTerm analysis pos
  let name = memberName root
  Map.lookup name (analysisReferences analysis)

bendDefinitionAt :: BendAnalysis -> (Int,Int) -> Maybe Span
bendDefinitionAt analysis pos = do
  name <- bendDefinitionNameAt analysis pos
  _ <- lookup name
    [ (memberName member,term) | (member,term) <- analysisRoots analysis ]
  let candidates = [span | (member,term) <- analysisRoots analysis
                         , memberName member == name
                         , span <- topSpans (reifyTerm term)]
  case candidates of
    span:_ -> Just span
    [] -> Nothing

bendDefinitionNameAt :: BendAnalysis -> (Int,Int) -> Maybe Name
bendDefinitionNameAt analysis pos = do
  (root,path,_) <- innermostTerm analysis pos
  projection <- either (const Nothing) Just (projectSubterm (analysisBook analysis) root path)
  referenceName (projectionTerm projection)

referenceName :: Term -> Maybe Name
referenceName term = case term of
  Ref name -> Just name
  Loc _ body -> referenceName body
  Sub body -> referenceName body
  _ -> Nothing

memberName :: MemberRoot -> Name
memberName root = case root of
  DefinitionBody name -> name
  DefinitionType name -> name
  HitType name -> name
  HitConstructorType name _ -> name

innermostTerm :: BendAnalysis -> (Int,Int) -> Maybe (MemberRoot,[Int],Span)
innermostTerm analysis pos = case candidates of
  [] -> Nothing
  _ -> Just (minimumBy (comparing rank) candidates)
  where
    candidates = [ (root,path,span)
                 | (root,term) <- analysisRoots analysis
                 , (path,span) <- locatedPaths pos (reifyTerm term)
                 , Right _ <- [projectSubterm (analysisBook analysis) root path] ]
    rank (_,path,span) = (spanSize span,negate (length path))

locatedPaths :: (Int,Int) -> Flat -> [([Int],Span)]
locatedPaths pos = go [] Nothing
  where
    go path current flat = case flat of
      Node "Loc" [Node "Span" [NatAtom bl,NatAtom bc,NatAtom el,NatAtom ec,Text src],inner] ->
        let span = Span (bl,bc) (el,ec) src
        in if contains span pos then go (path ++ [1]) (Just span) inner else []
      Node _ children ->
        maybe [] (\span -> [(path,span)]) current ++
          concat [go (path ++ [index]) current child | (index,child) <- zip [0..] children]
      _ -> maybe [] (\span -> [(path,span)]) current

topSpans :: Flat -> [Span]
topSpans flat = case flat of
  Node "Loc" [Node "Span" [NatAtom bl,NatAtom bc,NatAtom el,NatAtom ec,Text src],_] ->
    [Span (bl,bc) (el,ec) src]
  Node _ children -> concatMap topSpans children
  _ -> []

contains :: Span -> (Int,Int) -> Bool
contains span position = spanBeg span <= position && position <= spanEnd span

spanSize :: Span -> Int
spanSize span =
  let (bl,bc) = spanBeg span
      (el,ec) = spanEnd span
  in (el-bl) * 1000000 + ec-bc
