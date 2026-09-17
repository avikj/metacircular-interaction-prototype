{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Data.Set as Set
import qualified Data.Text as Text
import Bend.UCM.Storage (loadBendDefinitionTypeTextByHashRef)
import qualified U.Codebase.Reference as Ref
import U.Codebase.Sqlite.DbId (ObjectId)
import qualified U.Codebase.Sqlite.Operations as Operations
import qualified U.Codebase.Sqlite.Queries as Q
import qualified Unison.Sqlite as Sqlite
import Unison.Util.Defns (Defns(..))
import System.Environment (getArgs)

main :: IO ()
main = do
  [databasePath] <- getArgs
  Sqlite.withConnection "bend-dependency-graph" databasePath \connection -> do
    refs <- Sqlite.runTransaction connection $ mapM (\oid -> do
      digest <- Q.expectPrimaryHashByObjectId oid
      pure (Ref.Id digest 0)) ([1..22] :: [ObjectId])
    let scope = Defns (Set.fromList refs) Set.empty
        query = Defns (Set.fromList (map Ref.ReferenceDerived refs)) Set.empty
    edges <- Sqlite.runTransaction connection $
      Operations.transitiveDependentsGraphWithinScope (const False) scope query
    if null edges then fail "Bend dependency graph unexpectedly empty" else pure ()
    let typeToTerm = length [() | Operations.TypeDependsOnTerm _ _ <- edges]
    checkedType <- Sqlite.runTransaction connection $ do
      mainRefs <- Q.findBendMembersByAuthoredName "main"
      case mainRefs of
        [Ref.Id objectId member] -> do
          digest <- Q.expectPrimaryHashByObjectId objectId
          loadBendDefinitionTypeTextByHashRef (Ref.Id digest member)
        _ -> pure (Left "main presentation is absent or ambiguous")
    case checkedType of
      Right (Just value) | not (Text.null value) -> pure ()
      other -> fail ("Bend checked type display failed: " ++ show other)
    putStrLn ("Bend dependency graph: " ++ show (length edges) ++
      " classified edges, " ++ show typeToTerm ++ " type-to-term edges")
