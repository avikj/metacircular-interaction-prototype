-- Aisthesis — the one sensory-event form, and the efference gate:
-- no act without a prediction; no new sense without a blind pair it separates.
--
-- NAMED BY THE OWNER, 2026-08-23: Greek αἴσθησις, perception.  The Sanskrit
-- gloss is संवेदन (saṃvedana), given here so the two registers stay joined;
-- the organ answers to the Greek name because that is the name it was given.
--
-- WHAT THIS IS.  The organs this machine already has — direct sight
-- (Pratyaksa), olfaction (Upalabdhi), negative-space perception (Abhava),
-- nociception (DosaLekha), body sense (Jiva/Chakra), the inner ear
-- (Parikrama), active touch (Tapas), the epistemic self-sense (Pramana),
-- the self boundary (Nama) — each emit their own report shape.  Yantra put
-- them on one wire; this file gives the wire ONE EVENT FORM they can all
-- emit and consume without collapsing their distinct outcomes.  An event
-- carries: which organ, under which standpoint, contacting what, doing
-- what if anything, observing what, with what fitness and extent, by which
-- of the five accepted routes, leaving what residual fibre — and, for any
-- event that ACTS, the three body states that make agency a sense:
--
--     the body before          (aPurva)
--     the body as PREDICTED    (aBhavi)     — the efference copy
--     the body as it actually  (aPascat)      answered
--
-- with their difference as a TYPED mismatch (Vailaksanya), never a scalar.
--
-- THE TWO GATES, and they are the whole point:
--
--   anujna     : a self-modification without an efference prediction is
--                refused BEFORE it acts.  A prediction that the body then
--                contradicts is not refused — it is the typed mismatch,
--                which is the most valuable thing an act can produce.
--                But an act whose record claims the body did not move when
--                the heartbeat says it did is refused as a false report.
--   navaIndriya: a proposed new organ is admitted only with a blind pair
--                it demonstrably separates — S(x) = S(y), q(x) # q(y),
--                with the separation witness named.  Absent that, q is
--                h ∘ S: another dashboard computed from the same
--                transcript, and it is refused AS a dashboard, in writing,
--                not admitted as a sense.
--
-- THE PROTOTYPE EVENT this design is lifted from, replayed in `main`: the
-- asNat incident.  A pricing pass redefined `asNat` locally instead of
-- importing the original; the body sensed one additional edge and one
-- additional unpriced edge (heartbeat 1270 → 1271, 1106 → 1107); the cure
-- had created a lesion.  That was a spontaneous efference comparison —
-- prediction implicit, mismatch caught by a heartbeat diff read by an
-- agent.  This file makes the comparison mandatory and the mismatch typed,
-- so the next such act indicts itself.
--
-- WHAT THIS IS NOT.  Not a scheduler, not a reward: no field of this event
-- is a score, no gate compares magnitudes, and the mismatch list has no
-- ordering.  Chakra's lesson stands — the count is a snapshot, the field
-- is the activity — so this organ records motion and refuses to grade it.
--
-- Wire grammar is Sabda's (four constructors: no boolean, no float, no
-- null).  The five routes are Yantra's Pramanya, IMPORTED, not copied —
-- copying the type here would be this file committing the exact defect its
-- prototype event records.  Events append to machine/aisthesis.jsonl.

{-# LANGUAGE LambdaCase #-}
module Main (main) where

import Sabda_TheWireHasNoBoolean (J(..), render, parseLine)
import Yantra_TheOrgansAreOneMachineOnOneWire (Pramanya(..))
import System.IO
import Data.List (intercalate)

-- ============================================================ शरीरम्
-- The body state an event speaks of: Jiva's heartbeat line, as a record.
-- Five numbers, all counts, none a score.

data Sarira = Sarira
  { sNodes      :: Integer
  , sEdges      :: Integer
  , sPriced     :: Integer
  , sUnpriced   :: Integer
  , sComponents :: Integer
  } deriving (Eq, Show)

sariraJ :: Sarira -> J
sariraJ s = JObj
  [ ("nodes", JInt (sNodes s)), ("edges", JInt (sEdges s))
  , ("priced", JInt (sPriced s)), ("unpriced", JInt (sUnpriced s))
  , ("components", JInt (sComponents s)) ]

sariraP :: J -> Either String Sarira
sariraP (JObj kvs) =
  Sarira <$> f "nodes" <*> f "edges" <*> f "priced"
         <*> f "unpriced" <*> f "components"
  where f k = case lookup k kvs of
                Just (JInt n) -> Right n
                _ -> Left ("sarira: missing or non-integer field " ++ k)
sariraP _ = Left "sarira: not an object"

-- ============================================================ वैलक्षण्यम्
-- The typed mismatch between the predicted body and the actual one.
-- Nine kinds, each carrying its witness.  NOT a number; there is no
-- ordering on these and no sum of them.

data Vailaksanya
  = ExpectedDeclarationAbsent String     -- the act said it would create this; it did not
  | UnexpectedDeclarationCreated String  -- this appeared and nothing predicted it
  | ReceiptOnCopy String String          -- receipt attached to a copy, not the intended object
  | UnexpectedEdge String                -- an edge appeared that the prediction did not carry
  | LostImportCoverage String            -- a module fell out of an aggregate's closure
  | ChangedFibreVerdict String String    -- a fibre's verdict moved (from, to stated)
  | ToolchainChanged String              -- the instrument moved under the act
  | InvariantViolated String             -- a preserved invariant did not survive
  | ProvenanceMismatch String            -- the record's origin disagrees with the act's
  deriving (Eq, Show)

vailaksanyaJ :: Vailaksanya -> J
vailaksanyaJ v = case v of
  ExpectedDeclarationAbsent w    -> tag "expected-declaration-absent" [w]
  UnexpectedDeclarationCreated w -> tag "unexpected-declaration-created" [w]
  ReceiptOnCopy c o              -> tag "receipt-on-copy" [c, o]
  UnexpectedEdge w               -> tag "unexpected-edge" [w]
  LostImportCoverage w           -> tag "lost-import-coverage" [w]
  ChangedFibreVerdict a b        -> tag "changed-fibre-verdict" [a, b]
  ToolchainChanged w             -> tag "toolchain-changed" [w]
  InvariantViolated w            -> tag "invariant-violated" [w]
  ProvenanceMismatch w           -> tag "provenance-mismatch" [w]
  where tag t ws = JObj [("vailaksanya", JStr t), ("saksin", JArr (map JStr ws))]

-- The part of the mismatch the gate can COMPUTE from the two heartbeats.
-- Declaration-level entries are the acting organ's to supply; the scalar
-- skeleton is not trusted to it.
sariraVailaksanya :: Sarira -> Sarira -> [Vailaksanya]
sariraVailaksanya b p = concat
  [ d sEdges      "edges"      UnexpectedEdge
  , d sNodes      "nodes"      UnexpectedDeclarationCreated
  , d sUnpriced   "unpriced"   (InvariantViolated . ("unpriced count: " ++))
  , d sPriced     "priced"     (InvariantViolated . ("priced count: " ++))
  , d sComponents "components" (InvariantViolated . ("components: " ++))
  ]
  where
    d f nm mk | f b == f p = []
              | otherwise  = [ mk (nm ++ " predicted " ++ show (f b)
                                   ++ " actual " ++ show (f p)) ]

-- ============================================================ the event

data Aisthesis = Aisthesis
  { aIndriya     :: String          -- organ
  , aNaya        :: String          -- the standpoint/context of the sensing
  , aVisaya      :: String          -- object contacted
  , aKriya       :: Maybe String    -- intervention; Nothing = purely afferent
  , aUpalabdhi   :: J               -- observation, in the organ's own shape
  , aYogyata     :: String          -- fitness of the looking
  , aVyapti      :: String          -- extent searched
  , aMarga       :: Pramanya        -- the route (Yantra's five, imported)
  , aSesa        :: [String]        -- residual fibre: what stays indistinct
  , aPurva       :: Maybe Sarira    -- body before
  , aBhavi       :: Maybe Sarira    -- body as predicted — the efference copy
  , aPascat      :: Maybe Sarira    -- body as it actually answered
  , aVailaksanya :: [Vailaksanya]   -- the typed mismatch
  , aAgama       :: String          -- provenance
  , aKala        :: String          -- time, ISO, supplied by the caller
  }

pramanyaJ' :: Pramanya -> J
pramanyaJ' = \case
  Pratyaksa w -> JObj [("marga", JStr "pratyaksa"), ("saksin", JStr w)]
  Nihsesa n w -> JObj [("marga", JStr "nihsesa"), ("ganana", JInt (fromIntegral n)), ("saksin", JStr w)]
  Ganita w    -> JObj [("marga", JStr "ganita"), ("saksin", JStr w)]
  Kernel w    -> JObj [("marga", JStr "kernel"), ("saksin", JStr w)]
  Ayogya w    -> JObj [("marga", JStr "ayogya"), ("saksin", JStr w)]

aisthesisJ :: Aisthesis -> J
aisthesisJ a = JObj $
  [ ("indriya", JStr (aIndriya a))
  , ("naya", JStr (aNaya a))
  , ("visaya", JStr (aVisaya a)) ]
  ++ maybe [] (\k -> [("kriya", JStr k)]) (aKriya a)
  ++ [ ("upalabdhi", aUpalabdhi a)
     , ("yogyata", JStr (aYogyata a))
     , ("vyapti", JStr (aVyapti a))
     , ("pramanya", pramanyaJ' (aMarga a))
     , ("sesa", JArr (map JStr (aSesa a))) ]
  ++ maybe [] (\s -> [("purva", sariraJ s)]) (aPurva a)
  ++ maybe [] (\s -> [("bhavi", sariraJ s)]) (aBhavi a)
  ++ maybe [] (\s -> [("pascat", sariraJ s)]) (aPascat a)
  ++ [ ("vailaksanya", JArr (map vailaksanyaJ (aVailaksanya a)))
     , ("agama", JStr (aAgama a))
     , ("kala", JStr (aKala a)) ]

-- ============================================================ निषेधः
-- A refusal, in the doṣa-lekha's discipline: what was attempted, why it
-- is refused, what would repair it.  Never silent, never a boolean.

data Nisedha = Nisedha
  { nKriya   :: String
  , nHetu    :: String
  , nPratikara :: String
  } deriving Show

nisedhaJ :: Nisedha -> J
nisedhaJ n = JObj [ ("nisedha", JStr (nKriya n))
                  , ("hetu", JStr (nHetu n))
                  , ("pratikara", JStr (nPratikara n)) ]

-- ============================================================ GATE ONE
-- अनुज्ञा — no self-modification without an efference prediction.

anujna :: Aisthesis -> Either Nisedha Aisthesis
anujna a = case aKriya a of
  Nothing -> Right a                      -- afferent events pass untouched
  Just k -> case (aBhavi a, aPurva a) of
    (Nothing, _) -> Left (Nisedha k
      "an act without an efference prediction: the organ does not know what it intends its body to become"
      "state aBhavi — the predicted heartbeat — before acting, then act, then record aPascat and the typed difference")
    (_, Nothing) -> Left (Nisedha k
      "an act without a prior body state: no baseline, so no mismatch can ever be computed"
      "read the heartbeat before acting and carry it as aPurva")
    (Just b, Just _) -> case aPascat a of
      Nothing -> Right a                  -- prediction made, act pending: legal
      Just p ->
        let owed = sariraVailaksanya b p
        in if not (null owed) && null (aVailaksanya a)
           then Left (Nisedha k
             ("the record claims no mismatch but the body moved: " ++
              intercalate "; " [ w | v <- owed, let w = shortV v ])
             "carry the computed mismatch in aVailaksanya — the mismatch is the finding, not the failure")
           else Right a
  where
    shortV v = case vailaksanyaJ v of
      JObj (("vailaksanya", JStr t) : _) -> t
      _ -> "?"

-- ============================================================ GATE TWO
-- नव-इन्द्रिय-अनुज्ञा — no new sense without a blind pair it separates.

data NavaIndriya = NavaIndriya
  { niNama       :: String            -- the proposed organ
  , niAndhaYugma :: Maybe (String, String)
      -- ^ the blind pair: S(x) = S(y) under the CURRENT sensorium
  , niPrithak    :: String            -- witness that q(x) # q(y); "" = none
  , niYogyata    :: String            -- domain and fitness of the query
  , niSambandha  :: [String]          -- relation to existing organs
  }

navaIndriya :: NavaIndriya -> Either Nisedha NavaIndriya
navaIndriya n = case (niAndhaYugma n, niPrithak n) of
  (Nothing, _) -> Left (Nisedha (niNama n)
    "no blind pair named: nothing the current sensorium conflates has been exhibited, so there is nothing for this organ to separate"
    "exhibit x, y with S(x) = S(y) under the present organs, then show q separates them")
  (Just _, "") -> Left (Nisedha (niNama n)
    "a blind pair is named but no separation witness: q may be h . S — a dashboard computed from the same transcript, useful compression, not perception"
    "exhibit q(x) # q(y) as a term or a written computation, or file the organ as a report, not a sense")
  (Just _, _) -> Right n

-- ============================================================ the replay
-- The asNat incident as the two events it was, run through gate one.

purva1270 :: Sarira
purva1270 = Sarira 589 1270 164 1106 58

main :: IO ()
main = do
  hSetEncoding stdout utf8

  let lesion = Aisthesis
        { aIndriya = "tapas (pricing pass)"
        , aNaya    = "paryayarthika — pricing one fibre of one map"
        , aVisaya  = "asNat : Bool -> N (NaturalMachine.FiniteOccupancyChannelNoGo)"
        , aKriya   = Just "price the indicator's full census — FIRST ATTEMPT: local redefinition"
        , aUpalabdhi = JStr "module checked green; heartbeat then read"
        , aYogyata = "agda --safe on the emitted module; jiva rerun after"
        , aVyapti  = "one module, one heartbeat diff"
        , aMarga   = Kernel "GananaAsNat… (first version): agda --safe exit 0"
        , aSesa    = ["the ORIGINAL asNat's fibre, still unpriced — the receipt hangs on a copy"]
        , aPurva   = Just purva1270
        , aBhavi   = Just purva1270 { sPriced = 165, sUnpriced = 1105 }
        , aPascat  = Just purva1270 { sNodes = 590, sEdges = 1271, sUnpriced = 1107 }
        , aVailaksanya =
            ReceiptOnCopy "asNat (redefined locally)" "asNat (the declaration jiva ranked)"
            : sariraVailaksanya (purva1270 { sPriced = 165, sUnpriced = 1105 })
                                (purva1270 { sNodes = 590, sEdges = 1271, sUnpriced = 1107 })
        , aAgama   = "collab journal 2026-08-23; jiva heartbeat diff 1270 -> 1271"
        , aKala    = "2026-08-23T04:00:00Z"
        }

      cure = lesion
        { aKriya   = Just "price the indicator's full census — REPAIR: import the original"
        , aUpalabdhi = JStr "module re-checked green against the imported declaration; heartbeat returned"
        , aMarga   = Kernel "GananaAsNat… (imported asNat): agda --safe exit 0"
        , aSesa    = []
        , aBhavi   = Just purva1270 { sPriced = 165, sUnpriced = 1105 }
        , aPascat  = Just purva1270 { sPriced = 165, sUnpriced = 1105 }
        , aVailaksanya = []
        , aKala    = "2026-08-23T04:20:00Z"
        }

      blind    = anujna lesion { aBhavi = Nothing }   -- what the gate now forbids
      caught   = anujna lesion                        -- prediction present, mismatch typed
      clean    = anujna cure

      dashboard = navaIndriya (NavaIndriya "weighted-unpriced-score" Nothing "" "" [])
      sense     = navaIndriya (NavaIndriya
                    "guhya-bhara (loop-charge probe)"
                    (Just ( "fibre of S1 -> Unit at tt"
                          , "fibre of id : Unit -> Unit at tt (both: inhabited, no exhibited pair, set-census silent)"))
                    "GuhyaNasti: winding of the concealed loop = 1 /= 0 in Z on the first, contractible on the second"
                    "maps whose fibres admit a basepoint loop probe"
                    ["extends SakalaVikalaDesa's census one h-level up; KramaSaha prices its order-dependence"])

  putStrLn "== the act as the gate now receives it, WITHOUT a prediction =="
  putStrLn (either (render . nisedhaJ) (const "(admitted — wrong)") blind)
  putStrLn ""
  putStrLn "== the same act WITH its prediction: admitted, mismatch typed =="
  putStrLn (either (render . nisedhaJ) (render . aisthesisJ) caught)
  putStrLn ""
  putStrLn "== the repair: prediction met, mismatch empty =="
  putStrLn (either (render . nisedhaJ) (render . aisthesisJ) clean)
  putStrLn ""
  putStrLn "== gate two refuses a dashboard =="
  putStrLn (either (render . nisedhaJ) (const "(admitted — wrong)") dashboard)
  putStrLn ""
  putStrLn "== gate two admits a sense with its blind pair and witness =="
  putStrLn (either (render . nisedhaJ) (\n -> "admitted: " ++ niNama n) sense)

  -- round trip: every event this organ emits must re-enter the wire whole
  let emitted = render (aisthesisJ cure)
  case parseLine emitted of
    Right j | j == aisthesisJ cure ->
      putStrLn "\nround-trip: parseLine . render = id on the emitted event"
    Right _ -> putStrLn "\nROUND-TRIP DRIFT — the wire altered the event"
    Left e  -> putStrLn ("\nROUND-TRIP FAILURE: " ++ e)
