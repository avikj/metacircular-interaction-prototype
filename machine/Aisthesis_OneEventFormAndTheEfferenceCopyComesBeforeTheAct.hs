-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Aisthesis_OneEventFormAndTheEfferenceCopyComesBeforeTheAct.hs
--
-- αἴσθησις · aisthēsis, perception — Greek, and named as Greek: the owner
-- specified this organ under that name (2026-08-23, in-session), so the
-- name is his utterance carried literally, not a provenance claim.  The
-- efference vocabulary is Latin and is likewise his: ex-ferre, to carry
-- outward — the copy of a motor command sent to one's own sensorium so
-- the consequence of an act can be PREDICTED and the prediction COMPARED.
--
-- WHAT THIS IS.  The unified sensory-event form the existing receptors
-- and effectors (Pratyaksa, Upalabdhi, Abhava, Jiva, Chakra, Parikrama,
-- Tapas, DosaLekha) can emit or consume without collapsing their distinct
-- outcomes — and the first working efference comparator over the body
-- sense we already have (Jiva's heartbeat).  The rule it exists to make
-- enforceable, stated once and carried in the type:
--
--     NO SELF-MODIFICATION WITHOUT AN EFFERENCE PREDICTION;
--     NO NEW SENSE WITHOUT A BLIND PAIR IT DEMONSTRABLY SEPARATES.
--
-- THE MISMATCH IS TYPED, NEVER A NUMBER.  ε(a,x) = Diff(Δ̂, Δ) has no
-- magnitude field anywhere below.  A scalar ε would be ∥·∥₁ of the very
-- anatomy this organ exists to keep — the same collapse DosaLekha refuses
-- for pain and Sabda refuses for the wire.
--
-- WHAT V1 REACHES AND WHAT IT DOES NOT, so nobody reads more than is here:
--
--   REACHED   the event record (all fourteen slots of the specification);
--             the typed body-state (Jiva's five fields, parsed from the
--             heartbeat line it already prints); prediction as a value
--             written BEFORE the act; the comparator emitting a LIST of
--             typed mismatches, empty exactly when the body confirmed the
--             intention; a demonstration in main on a real act.
--   NOT YET   universal enforcement (that is a hook or a Ratri contract,
--             not this file); graph-level mismatches (ExpectedDeclaration-
--             Absent and its kin are constructors below so the vocabulary
--             is fixed now, but v1's comparator reaches only the count
--             stratum — and a count delta is itself ∥·∥₁ of the graph
--             delta, said here so the limit is in hand); the counter-
--             factual body schema and parallax organs (owed, named in the
--             specification, not begun here).
--
-- RUN:  runghc machine/Aisthesis_….hs predict  "act description" HEARTBEAT-LINE
--       runghc machine/Aisthesis_….hs compare  PREDICTION-FILE  HEARTBEAT-LINE
--   The prediction file is written by `predict` and read by `compare`;
--   compare exits 0 on empty mismatch, 1 on any mismatch, and PRINTS the
--   anatomy either way.

module Main (main) where

import System.Environment (getArgs)
import System.Exit (exitSuccess, exitFailure)
import Data.List (isPrefixOf, intercalate)
import Data.Char (isDigit)

-- ── the body state: Jiva's five fields, no more claimed than it reports ──
data Body = Body
  { nodes, edges, priced, unpriced, components :: Integer }
  deriving (Eq, Show, Read)

-- parse "JIVA-HEARTBEAT nodes=632 edges=1337 priced=185 unpriced=1152 components=65"
parseBody :: String -> Maybe Body
parseBody line =
  let ws = words line
      get k = case [ drop (length k + 1) w | w <- ws, (k ++ "=") `isPrefixOf` w ] of
                (v:_) | all isDigit v, not (null v) -> Just (read v)
                _ -> Nothing
  in Body <$> get "nodes" <*> get "edges" <*> get "priced"
          <*> get "unpriced" <*> get "components"

-- ── the typed mismatch: the full vocabulary fixed now, no magnitude ──────
data Mismatch
  = ExpectedDeclarationAbsent String
  | UnexpectedDeclarationCreated String
  | ReceiptAttachedToCopy String        -- the asNat lesion, as a constructor
  | UnexpectedEdge String
  | LostImportCoverage String
  | ChangedFibreVerdict String
  | ToolchainChanged String
  | InvariantViolated String
  | ProvenanceMismatch String
  | BodyFieldOther                      -- v1's reach: a count stratum field
      { field :: String, predicted :: Integer, actual :: Integer }
  deriving (Eq, Show, Read)

-- ── the comparator: ε(a,x) as a LIST, empty iff the body confirmed ───────
diffBody :: Body -> Body -> [Mismatch]
diffBody p a = concat
  [ f "nodes" nodes, f "edges" edges, f "priced" priced
  , f "unpriced" unpriced, f "components" components ]
  where
    f nm sel = [ BodyFieldOther nm (sel p) (sel a) | sel p /= sel a ]

-- ── the event form: all fourteen slots of the specification ──────────────
data Aisthesis = Aisthesis
  { organ        :: String
  , context      :: String
  , contacted    :: String        -- the object contacted
  , intervention :: Maybe String  -- Nothing = pure observation
  , observation  :: String
  , fitness      :: String        -- fitness and extent of the looking
  , route        :: String        -- epistemic route (the pramāṇa)
  , residue      :: String        -- residual fibre, handed forward
  , before       :: Body
  , predictedB   :: Maybe Body    -- the efference copy; Nothing ONLY for
                                  -- pure observation, never for an act
  , afterB       :: Maybe Body
  , mismatch     :: [Mismatch]
  , provenance   :: String
  , when         :: String
  } deriving (Show, Read)

render :: Aisthesis -> String
render e = unlines $
  [ "AISTHESIS"
  , "  organ        : " ++ organ e
  , "  context      : " ++ context e
  , "  contacted    : " ++ contacted e
  , "  intervention : " ++ maybe "(none — pure observation)" id (intervention e)
  , "  observation  : " ++ observation e
  , "  fitness      : " ++ fitness e
  , "  route        : " ++ route e
  , "  residue      : " ++ residue e
  , "  body before  : " ++ show (before e)
  , "  efference    : " ++ maybe "(ABSENT — lawful only for observation)" show (predictedB e)
  , "  body after   : " ++ maybe "(not yet measured)" show (afterB e)
  , "  provenance   : " ++ provenance e
  , "  when         : " ++ when e
  ] ++
  case mismatch e of
    [] -> [ "  mismatch     : NONE — the body confirmed the intention" ]
    ms -> ( "  mismatch     : " ++ show (length ms) ++ " typed difference(s), no magnitude:" )
          : [ "    " ++ show m | m <- ms ]

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["predict", act, hb] ->
      case parseBody hb of
        Nothing -> putStrLn "cannot parse heartbeat line" >> exitFailure
        Just b  -> do
          -- the prediction file IS the efference copy: written before the act
          writeFile ".aisthesis-prediction"
            (show (act, b))
          putStrLn ("efference copy written: predicted body after \"" ++ act
                    ++ "\" is " ++ show b)
    ["compare", predFile, hb] -> do
      s <- readFile predFile
      let (act, p) = read s :: (String, Body)
      case parseBody hb of
        Nothing -> putStrLn "cannot parse heartbeat line" >> exitFailure
        Just a  -> do
          let ms = diffBody p a
          putStr (render Aisthesis
            { organ = "aisthesis.v1", context = "efference comparison"
            , contacted = "Jiva heartbeat", intervention = Just act
            , observation = "body measured after the act"
            , fitness = "count stratum only; a count delta is the truncation of the graph delta"
            , route = "pratyaksa of the heartbeat line"
            , residue = "graph-level comparators owed (constructors present, comparator not)"
            , before = p, predictedB = Just p, afterB = Just a
            , mismatch = ms
            , provenance = "machine/Aisthesis_OneEventFormAndTheEfferenceCopyComesBeforeTheAct.hs"
            , when = "(stamped by the caller's record, not by this process)" })
          if null ms then exitSuccess else exitFailure
    _ -> do
      putStrLn "usage: predict \"act\" HEARTBEAT-LINE | compare PRED-FILE HEARTBEAT-LINE"
      exitFailure
