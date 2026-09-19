module Main where

import Core.Admission
import qualified Data.Set as Set
import System.Exit (die)

main :: IO ()
main = do
  let path = "collab/bend2-cubical/path_transport.bend"
  source <- readFile path
  checked <- case admitSource path source of
    Left _ -> die "admission rejected checked path transport fixture"
    Right value -> pure value
  let members = checkedMembers checked
      hasHit = any isSegmentHit members
      hasDefn = any isSegmentDefn members
      referencesHit = any refersToSegment members
  if hasHit && hasDefn && referencesHit
    then putStrLn "admission passed: checked HIT, generated definition, and dependency retained"
    else die "admission lost HIT, generated definition, or dependency"

isSegmentHit :: CheckedMember -> Bool
isSegmentHit (CheckedHit "Segment" _) = True
isSegmentHit _ = False

isSegmentDefn :: CheckedMember -> Bool
isSegmentDefn (CheckedDefn "Segment" _ _ _) = True
isSegmentDefn _ = False

refersToSegment :: CheckedMember -> Bool
refersToSegment member = Set.member "Segment" (memberDependencies member)
