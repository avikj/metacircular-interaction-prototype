-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Parikrama_EveryNullCircuitOfRoadOneEnumeratedEachAnAutomorphismASecondRoadOrAGaugeCandidateWithItsKernelProbe.hs
--
-- परिक्रमा · parikramā — the circuit walked deliberately and closed where it
-- began.  Ordinary Sanskrit (the circumambulation of a shrine); the compound
-- title is built here, 2026-08-23, and no text is claimed for it.
--
-- ─────────────────────────────────────────────────────────────────────────
-- WHY THIS ORGAN EXISTS.
--
-- The corpus proved, the night the spacetime reading landed: closed loops
-- exist only at zero receipt — on the null cone, pure gauge (README §6,
-- "every directed cycle in the walked graph is a disguised equivalence").
-- And the gauge sector is where the charge lives: of 14 loops decided by
-- hand in `Paryaya_ElevenOfTheFourteenLoopsMoveAPoint…agda`, ELEVEN moved a
-- point.  Since then the loop inventory has been nobody's job: Setubandha
-- files cycles as "no reachability", जीव counts components, and the gauge
-- sector of the WHOLE admitted graph has never been enumerated.
--
-- A null circuit is also the "right configuration" of the receipt economy:
-- a composition of landed equivalences that closes on itself runs forever
-- at zero marginal cost — the one perpetual motion conservation permits,
-- because it is motion in the fibre (Dhruva; movement 30: the fibre is the
-- freedom).  So the inventory below is simultaneously
--
--   · the CYCLE BASIS of road one — every independent closed circuit,
--     dimension E − V + C, each with its full provenance chain;
--   · the GAUGE CANDIDATE LIST — each circuit composes (compEquiv along
--     the chain, invEquiv where crossed backward) to an automorphism of
--     its base node, and either that automorphism is refl (the circuit is
--     redundancy: a second road, shortening routes, carrying no charge) or
--     it moves a point (real holonomy: a generator of the corpus's checked
--     gauge group at that component);
--   · the KERNEL QUEUE — for each circuit, the probe that decides it, by
--     the one-line discriminant Paryaya established: `ua e ≡ refl →
--     equivFun e a ≡ a` (uaβ), so ONE MOVED POINT refutes nullity.
--
-- WHAT THIS PROGRAM DOES NOT DO, stated so it can be attacked.  It does
-- not decide holonomy: that is the kernel's verdict, and this host may not
-- even carry a kernel — each circuit is emitted as a PROBE, not a verdict
-- (सूत्र ७, मौनं न निषेधः: an unprobed circuit is undecided, not null).  It
-- inherits the extractors' exact-string node identity and the Lopa audit's
-- admission judgment, through `Marga.landedEdges`, unrepeated.  The cycle
-- basis depends on the spanning forest chosen (BFS from each component's
-- first node in sorted order — deterministic), but its DIMENSION does not,
-- and the span of the circuits does not.  A length-2 circuit (two admitted
-- edges between one pair of banks) is reported as what it is: a SECOND
-- ROAD — तीर्थ's own category — whose composite against the first road's
-- inverse is still a probe, because two independent proofs of one
-- identification may differ as paths, and that difference, if the kernel
-- finds one, is itself charge.
--
-- PRASAVA: every number below is printed beside the one command that
-- reproduces all of them:
--
--     runghc -imachine machine/Parikrama_….hs .
--
-- ─────────────────────────────────────────────────────────────────────────

module Main (main) where

import qualified Data.Map.Strict as M
import qualified Data.Set as S
import Data.List (sort, sortOn, intercalate)
import Control.Monad (forM_)
import System.Environment (getArgs)
import System.IO

import Marga_TheRouterTransportsATheoremAlongLandedEdges
  ( Edge(..), eFull, landedEdges )

-- one attested crossing of one edge, in a stated direction
data Step = Step { sEdge :: Edge, sForward :: Bool }

stepFrom, stepTo :: Step -> String
stepFrom (Step e True)  = eA e
stepFrom (Step e False) = eB e
stepTo   (Step e True)  = eB e
stepTo   (Step e False) = eA e

showStep :: Step -> String
showStep st = stepFrom st ++ "  →  " ++ stepTo st
           ++ "   via " ++ eFull (sEdge st)
           ++ (if sForward st then "" else "  (inverted)")

-- ── the spanning forest, deterministic ──────────────────────────────────
-- parent map: node ↦ the Step that first reached it.  Edges are offered in
-- sorted provenance order and roots in sorted node order, so the forest —
-- and with it the printed basis — is a function of the tree alone.

spanningForest :: [Edge] -> M.Map String Step
spanningForest es = foldl grow M.empty (sort nodes)
  where
    adj = M.fromListWith (++)
            (concat [ [ (eA e, [Step e True]), (eB e, [Step e False]) ]
                    | e <- sortOn eFull es, eA e /= eB e ])
    nodes = S.toList (S.fromList (concat [ [eA e, eB e] | e <- es ]))
    grow par r
      | r `M.member` par = par
      | otherwise        = walk (M.insert r rootMark par) [r]
      where rootMark = Step (Edge "root" r r "⟨root⟩" r) True
            walk p [] = p
            walk p (x : xs) =
              let steps = [ s | s <- M.findWithDefault [] x adj
                          , not (stepTo s `M.member` p) ]
                  p' = foldl (\m s -> if stepTo s `M.member` m then m
                                      else M.insert (stepTo s) s m) p steps
                  new = [ stepTo s | s <- steps, stepTo s `M.member` p'
                        , not (stepTo s `M.member` p) ]
              in walk p' (xs ++ new)

isRoot :: Step -> Bool
isRoot s = eMod (sEdge s) == "⟨root⟩"

-- path from a node back to its component root, as Steps walked root-ward
pathToRoot :: M.Map String Step -> String -> [Step]
pathToRoot par n = case M.lookup n par of
  Nothing -> []
  Just s | isRoot s  -> []
         | otherwise -> s : pathToRoot par (stepFrom s)

-- the fundamental circuit of a non-tree edge: walk eA → root, cross the
-- edge backward from eB's side... assembled as: up-path from eA joined to
-- reversed up-path from eB, with the chord closing it.  Shared tail (above
-- the meet) cancels.
invertStep :: Step -> Step
invertStep (Step e d) = Step e (not d)

circuitOf :: M.Map String Step -> Edge -> [Step]
circuitOf par e
  | eA e == eB e = [Step e True]                    -- an automorphism edge
  | otherwise =
      let ua' = reverse (pathToRoot par (eA e))     -- root … → eA (forward)
          ub  = reverse (pathToRoot par (eB e))     -- root … → eB (forward)
          shared = length (takeWhile id (zipWith same ua' ub))
          same x y = eFull (sEdge x) == eFull (sEdge y)
                     && sForward x == sForward y
          upA = drop shared ua'                      -- meet → eA
          upB = drop shared ub                       -- meet → eB
      in map invertStep (reverse upA)                -- eA → meet
         ++ upB                                      -- meet → eB
         ++ [Step e False]                           -- eB → eA (the chord)

classify :: [Step] -> String
classify [_] = "AUTOMORPHISM — a landed A ≃ A: charge candidate on one node"
classify c
  | length c == 2 = "SECOND ROAD — two admitted proofs of one identification; their path-difference is the probe"
  | otherwise     = "CIRCUIT — length " ++ show (length c) ++ " gauge candidate"

main :: IO ()
main = do
  hSetEncoding stdout utf8
  args <- getArgs
  let root = case args of { (r : _) -> r; [] -> "." }
  (es, _, nKept) <- landedEdges root
  let par     = spanningForest es
      nodes   = S.fromList (concat [ [eA e, eB e] | e <- es ])
      treeIds = S.fromList [ eFull (sEdge s) | s <- M.elems par, not (isRoot s) ]
      chords  = [ e | e <- sortOn eFull es, eFull e `S.notMember` treeIds ]
      nComp   = length [ s | s <- M.elems par, isRoot s ]
      dimExpected = nKept - S.size nodes + nComp
      circuits = [ (e, circuitOf par e) | e <- chords ]

  putStrLn "═══ परिक्रमा · every null circuit of road one, walked and named ═══"
  putStrLn ""
  putStrLn ("  admitted edges (Setubandha ∩ Lopa audit) : " ++ show nKept)
  putStrLn ("  nodes                                    : " ++ show (S.size nodes))
  putStrLn ("  components                               : " ++ show nComp)
  putStrLn ("  cycle-space dimension E − V + C          : " ++ show dimExpected)
  putStrLn ("  fundamental circuits found               : " ++ show (length circuits)
            ++ (if length circuits == dimExpected then "   (equals the dimension: the basis is complete)"
                else "   !! DOES NOT MATCH THE DIMENSION — a defect in this program, not in the corpus"))
  putStrLn  "      $ runghc -imachine machine/Parikrama_….hs ."
  putStrLn ""
  putStrLn "  Each circuit composes to an automorphism of its base node.  NONE is"
  putStrLn "  decided here: by uaβ, `ua(chain) ≡ refl → equivFun(chain) a ≡ a`,"
  putStrLn "  so one moved point refutes nullity — the kernel decides, as it"
  putStrLn "  decided 11 of 14 by that discriminant in Paryaya_….agda.  This is"
  putStrLn "  the queue; मौनं न निषेधः for every circuit until its probe runs."
  putStrLn ""
  forM_ (zip [1 :: Int ..] circuits) $ \(i, (e, c)) -> do
    putStrLn ("── circuit " ++ show i ++ " · base " ++ eA e ++ " · " ++ classify c)
    forM_ c (putStrLn . ("    " ++) . showStep)
    putStrLn ("    PROBE: compose the chain (compEquiv; invEquiv where inverted);"
              ++ " test equivFun ≡ id pointwise, then ua(chain) ≡ refl.")
    putStrLn ""
