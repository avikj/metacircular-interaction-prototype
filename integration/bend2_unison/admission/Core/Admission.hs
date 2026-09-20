-- | A non-CLI admission boundary for storing checked Bend books in a codebase.
-- Parsing a source string is useful for scratch files; callers resolving
-- codebase dependencies can pass their assembled Book to 'admitBook'.
module Core.Admission
  ( CheckedMember(..)
  , CheckedSource(..)
  , AdmissionError(..)
  , admitSource
  , admitBook
  , memberDependencies
  ) where

import qualified Data.Map.Strict as M
import qualified Data.Set as S

import Core.Check (check)
import Core.Deps (getDeps)
import Core.Parse.Book (doParseBook)
import Core.Type

data CheckedMember
  = CheckedDefn Name Inj Term Type
  | CheckedHit Name HitDecl

data CheckedSource = CheckedSource
  { checkedPath :: FilePath
  , checkedText :: String
  , checkedBook :: Book
  , checkedMembers :: [CheckedMember]
  }

data AdmissionError
  = ParseFailure String
  | DefinitionTypeFailure Name Error
  | DefinitionTermFailure Name Error
  | HitTypeFailure Name Error
  | HitConstructorFailure Name Name Error

-- | Each dependency is reported, including references to other members of
-- this Book. Component formation can classify local references after finding
-- strongly connected components; it must not discard type or HIT references.
memberDependencies :: CheckedMember -> S.Set Name
memberDependencies (CheckedDefn _ _ term typ) = getDeps term `S.union` getDeps typ
memberDependencies (CheckedHit _ hit) =
  S.unions (getDeps (hitType hit) : map (getDeps . ctorType . snd) (hitCtors hit))

-- | Admit a self-contained source string. Import resolution belongs to the
-- caller; 'admitBook' accepts the resulting assembled Book.
admitSource :: FilePath -> String -> Either AdmissionError CheckedSource
admitSource path source = do
  book <- either (Left . ParseFailure) Right (doParseBook path source)
  admitBook path source book

-- | Check both declarations and terms without printing or exiting UCM.
-- The ordinary CLI's checkBook only checks term bodies and its
-- checkDefinitions routine has terminal-side effects.
admitBook :: FilePath -> String -> Book -> Either AdmissionError CheckedSource
admitBook path source book@(Book defs hits) = do
  mapM_ checkHit (M.toList hits)
  mapM_ checkDef (M.toList defs)
  let members =
        [CheckedDefn name inj term typ | (name, (inj, term, typ)) <- M.toList defs]
          ++ [CheckedHit name hit | (name, hit) <- M.toList hits]
  pure (CheckedSource path source book members)
  where
    emptyCtx = Ctx []
    checkTerm term typ = check 0 noSpan book emptyCtx term typ
    checkDef (name, (_, term, typ)) = do
      case checkTerm typ Set of
        Done () -> pure ()
        Fail err -> Left (DefinitionTypeFailure name err)
      case checkTerm term typ of
        Done () -> pure ()
        Fail err -> Left (DefinitionTermFailure name err)
    checkHit (name, hit) = do
      case checkTerm (hitType hit) Set of
        Done () -> pure ()
        Fail err -> Left (HitTypeFailure name err)
      mapM_ (checkCtor name) (hitCtors hit)
    checkCtor name (ctorName, ctor) =
      case checkTerm (ctorType ctor) Set of
        Done () -> pure ()
        Fail err -> Left (HitConstructorFailure name ctorName err)
