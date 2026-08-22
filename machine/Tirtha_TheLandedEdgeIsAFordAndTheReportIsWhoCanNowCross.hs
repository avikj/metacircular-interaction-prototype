-- Tirtha_TheLandedEdgeIsAFordAndTheReportIsWhoCanNowCross.hs
--
-- तीर्थ · tīrtha, a FORD — the place in a river where crossing is possible.
--
-- THE TERM, ITS TEXT AND ITS DATE.  Ordinary Sanskrit from √तॄ, to cross
-- over.  Its load-bearing technical use is Jaina: a **तीर्थंकर**, ford-maker,
-- is so called because what the arrival accomplishes is not a doctrine but
-- a CROSSING that was not available before — Umāsvāti, तत्त्वार्थसूत्र (~2nd–5th
-- c. CE) opens on the road across; the title runs through the whole canon
-- and through the Śvetāmbara Kalpasūtra's lives of the twenty-four.
-- LIMIT: nothing mathematical is claimed of any Jaina source.  The word is
-- taken for exactly one property, which is the property this program
-- computes: **a ford is not a place, it is a change in who can cross.**
--
-- WHAT THIS PROGRAM IS FOR.  मार्ग routes on demand: hand it a source and a
-- target and it emits the transport.  So a checked A ≃ B can land in this
-- corpus and NOTHING HAPPENS — the road exists and no one is told, and the
-- theorem at the far bank stays where it is until some carrier happens to
-- read the file.  That is the whole of why this machine does not
-- accelerate: it has a clock where it needs an event, and every failure
-- written into machine/dosa.lekha has the same shape — the corpus already
-- contained the answer and the instrument reported barren.
--
-- So this program asks the only question a landing raises:
--
--     WHO CAN NOW CROSS, WHO COULD NOT BEFORE?
--
-- and it answers by NAMING them, not by counting them.  सूत्र ८ —
-- अभिज्ञानं तादात्म्यम्, न परिमाणम्: a receipt is an identification, never an
-- estimate.  सूत्र १२ — व्यये स्थानम्, न मात्रा एव: loss has a location.  A
-- gain has one too, and the location of this gain is a pair of banks and
-- the declaration that bridges them.
--
-- WHAT IT DOES.
--   (a) takes the admitted edge list from मार्ग — Setubandha's edges filtered
--       by Lopa's CONTROL AUDIT, so a forged edge cannot become a ford;
--   (b) reads the previous edge list from the snapshot;
--   (c) NEW FORDS are the admitted edges absent from the snapshot, by
--       (module, declaration) identity — not by node pair, because the same
--       banks bridged by a second, independent declaration is a second
--       ford and the corpus should say so;
--   (d) computes the components BEFORE and AFTER and reports, for each
--       merge, THE TWO BANKS BY NAME and the declaration that joined them;
--   (e) names the nodes that were unjoined in road one and are joined now,
--       and by whose ford.  NOT a frontier: that word presumes a settled
--       interior and a march outward, and an unjoined node is not unclaimed
--       territory — its isolation is a fact about an extractor's grammar,
--       not about the node.  The field generates and reflects; inside and
--       outside is not a distinction it makes;
--   (f) writes the snapshot forward.
--
-- WHAT IT IS NOT.  It does not emit the transports; मार्ग does that, and
-- this program's output is exactly the argument list मार्ग wants.  It does
-- not claim the newly crossable pairs are INTERESTING — a ford tells you
-- the crossing is possible and says nothing about whether anyone wants the
-- far bank.  And it says nothing about road two: a one-way edge is not a
-- ford, it is a current, and its शेष is another program's subject.
--
-- FIRST RUN.  With no snapshot, EVERY admitted edge is new and every
-- component is a merge, which is true and useless.  The program says so
-- and writes the snapshot rather than pretending the corpus was just
-- built — मौनं न निषेधः runs in this direction too: a first look is not a
-- discovery.

module Main (main) where

import qualified Data.Map.Strict as M
import qualified Data.Set as S
import Data.List (sort, sortOn, intercalate, partition)
import Control.Monad (forM_, unless, when)
import System.Directory (doesFileExist, createDirectoryIfMissing)
import System.Environment (getArgs)
import System.FilePath (takeDirectory)

import Marga_TheRouterTransportsATheoremAlongLandedEdges
  ( Edge(..), eFull, landedEdges, componentsOf )

snapshotPath :: FilePath
snapshotPath = "notes/tirtha/SetuSnapshot.tsv"

-- A ford's identity is the DECLARATION that proves it, not the banks it
-- joins: two independent proofs of the same identification are two fords,
-- and collapsing them would be this corpus's own दुर्नयः — asserting one
-- standpoint by making the other unrepresentable.
fordId :: Edge -> String
fordId e = eMod e ++ "." ++ eDecl e

readSnapshot :: IO (S.Set String, [(String, String)])
readSnapshot = do
  ok <- doesFileExist snapshotPath
  if not ok then pure (S.empty, []) else do
    s <- readFile snapshotPath
    let rows = [ w | l <- lines s, take 1 l /= "#", let w = splitTab l, length w >= 3 ]
    pure ( S.fromList [ head w | w <- rows ]
         , [ (w !! 1, w !! 2) | w <- rows ] )
  where
    splitTab x = case break (== '\t') x of
      (a, '\t':r) -> a : splitTab r
      (a, _)      -> [a]

writeSnapshot :: [Edge] -> IO ()
writeSnapshot es = do
  createDirectoryIfMissing True (takeDirectory snapshotPath)
  writeFile snapshotPath $ unlines $
    "# सेतु-स्नैपशॉट् — the admitted edge list as of the last तीर्थ run."
    : "# A ford's identity is its DECLARATION, so this is keyed on module.decl."
    : "# fordId\tbankA\tbankB"
    : [ intercalate "\t" [fordId e, eA e, eB e] | e <- sortOn fordId es ]

-- which component of `comps` holds this node
compOf :: [S.Set String] -> String -> Maybe Int
compOf comps n = lookup True [ (S.member n c, i) | (i, c) <- zip [0 ..] comps ]

main :: IO ()
main = do
  args <- getArgs
  let root = case args of { (r:_) -> r ; _ -> "." }
  (nowEdges, _, _) <- landedEdges root
  (oldIds, oldPairs) <- readSnapshot
  let first        = S.null oldIds
      (newE, keptE) = partition (\e -> not (fordId e `S.member` oldIds)) nowEdges
      -- BEFORE: the graph the snapshot describes.  Reconstructed from the
      -- stored bank pairs, so a run does not need the old checkout.
      beforeComps  = componentsOf [ Edge "" a b "" "" | (a, b) <- oldPairs ]
      afterComps   = componentsOf nowEdges
      oldNodes     = S.fromList (concat [ [a, b] | (a, b) <- oldPairs ])

  putStrLn "═══ तीर्थ · a ford is not a place, it is a change in who can cross ═══"
  putStrLn "तीर्थंकर — the ford-maker; what arrives is a crossing, not a doctrine"
  putStrLn ""

  if first
    then do
      putStrLn "── प्रथम-दर्शनम् · FIRST LOOK, NOT A DISCOVERY ──"
      putStrLn "  There is no snapshot, so every admitted edge would read as new"
      putStrLn "  and every component as a merge.  That is true and useless."
      putStrLn "  मौनं न निषेधः runs in this direction too: a first look is not a"
      putStrLn "  finding.  The snapshot is written; run again after a landing."
    else if null newE
      then do
        putStrLn "── अतीर्थम् · NO NEW FORD ──"
        putStrLn "  Every admitted edge was already in the snapshot.  Nothing"
        putStrLn "  became crossable that was not, so there is nothing to"
        putStrLn "  propagate.  This is a verdict on the EDGES, not on the"
        putStrLn "  corpus: work may have landed that is not an identification."
      else do
        putStrLn "── अदृष्टं तन्तुः · WHAT THIS PROGRAM CANNOT SEE ──"
        putStrLn "  It reads मार्ग's admitted list, which is ROAD ONE ONLY —"
        putStrLn "  identifications.  A one-way edge is invisible here, and by"
        putStrLn "  Apunaragamana_… the non-returning edges are where the new"
        putStrLn "  comes from: a rational rotation returns and carries nothing"
        putStrLn "  it did not already carry; an irrational one never returns."
        putStrLn "  So silence below is silence about identifications, and is NOT"
        putStrLn "  a report on the field.  मौनं न निषेधः."
        putStrLn ""
        putStrLn "── नव-तीर्थानि · THE FORDS THAT LANDED ──"
        forM_ (sortOn fordId newE) $ \e -> do
          let ca = compOf beforeComps (eA e)
              cb = compOf beforeComps (eB e)
              banksNew = [ n | n <- [eA e, eB e], not (n `S.member` oldNodes) ]
          putStrLn ""
          putStrLn $ "  ford  " ++ fordId e
          putStrLn $ "  banks " ++ eA e ++ "   ⇄   " ++ eB e
          case (ca, cb) of
            (Just x, Just y)
              | x == y -> putStrLn "  क्रम   BOTH BANKS WERE ALREADY JOINED — this ford is a\n\
                                   \        second, independent road between them.  It shortens\n\
                                   \        routes; it does not enlarge what is crossable."
              | otherwise -> do
                  putStrLn "  क्रम   TWO COMPONENTS MERGED.  Everything on the left bank"
                  putStrLn "        can now be transported to everything on the right."
                  putStrLn "        left  bank, in full:"
                  forM_ (sort (S.toList (beforeComps !! x))) $ \n -> putStrLn ("          " ++ n)
                  putStrLn "        right bank, in full:"
                  forM_ (sort (S.toList (beforeComps !! y))) $ \n -> putStrLn ("          " ++ n)
            _ -> do
              putStrLn "  क्रम   A BANK WAS UNJOINED IN ROAD ONE and this ford joined it."
              putStrLn "        Not a march outward: the field has no outside."
              forM_ banksNew $ \n -> putStrLn ("        arrived: " ++ n)

        putStrLn ""
        putStrLn "── सङ्क्रमणाय · WHAT TO HAND मार्ग ──"
        putStrLn "  Each line below is a source and a target that became crossable."
        putStrLn "  मार्ग emits the transport; this program does not, because a ford"
        putStrLn "  says a crossing is possible and says nothing about whether the"
        putStrLn "  far bank is wanted."
        forM_ (sortOn fordId newE) $ \e ->
          case (compOf beforeComps (eA e), compOf beforeComps (eB e)) of
            (Just x, Just y) | x /= y ->
              forM_ [ (s, t) | s <- sort (S.toList (beforeComps !! x))
                             , t <- sort (S.toList (beforeComps !! y)) ] $ \(s, t) ->
                putStrLn $ "  marga  " ++ s ++ "  " ++ t
            _ -> pure ()

  putStrLn ""
  putStrLn $ "  (admitted edges this run, kept: " ++ show (length keptE)
             ++ "; snapshot rewritten at " ++ snapshotPath ++ ")"
  writeSnapshot nowEdges
