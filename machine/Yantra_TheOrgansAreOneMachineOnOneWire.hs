-- Yantra_TheOrgansAreOneMachineOnOneWire — the assembly.
--
-- यन्त्रम् — an instrument.  Bhāskara II gives the Siddhāntaśiromaṇi a
-- Yantrādhyāya (1150): a chapter of instruments, each described by what it
-- does when it is turned, not by what it is made of.  NOT CLAIMED: that
-- Bhāskara wrote anything resembling this.  What is taken is the word and
-- the standard — an instrument is judged by being turned.
--
-- WHAT THIS FILE IS.  Fifteen lanes built organs.  Each one compiles, each
-- one runs, and until this file they were fifteen processes.  A store that
-- nothing reads, a defect log nothing writes to, three verdict types that
-- have never been in the same address space: that is not a machine, it is a
-- parts bin with good documentation.  This is the one wire they are all on.
--
-- WHAT IT INHERITS, verbatim, and does not restate:
--
--   Sabda_TheWireHasNoBoolean       the grammar: four constructors, no
--                                   boolean, no float, no null.
--   Uttara_Samkramana…              the answer type: two constructors, no
--                                   third.  §6, तृतीयो मार्गो न विद्यते ।
--
-- WHAT IT SUPERSEDES.  Sabha_TheSessionKernelAnLLMTalksTo runs the same
-- wire against a placeholder store — `sNaya :: [(String, [String])]` — and
-- says so in its own header: *a real naya store → replace `sNaya` and the
-- two ops touching it*.  This is that replacement.  The sabhā's twelve
-- operations all survive here, and the store under `naya.*` is
-- NayaKosha_TheStandpointStore: journalled, replayable, with every witness
-- carrying its source and every entry carrying the fitness of the looking
-- that produced it.  A (name, [String]) pair cannot carry either, and both
-- are things a later reader needs and a caller does not (§14, §15).
--
-- THE ORGANS WIRED IN, with what each one is here for:
--
--   NayaKosha_TheStandpointStore    the store.  Append-only, no delete, no
--                                   update, name lookup returns a LIST.
--   DosaLekha_TheWrittenDefectRecord  every refusal this machine makes is
--                                   filed into it, over its own published
--                                   `write`-on-stdin interface, and the
--                                   chain is verified from inside the
--                                   session by `dosa.pramanya`.
--   Saptabhangi_TheSevenfoldVerdict   verdict organ A: presence profiles.
--   SaptabhangiGarbha_…               verdict organ B: proof-relevant.
--   Obstruction                       verdict organ C: B1..B7 + ADharmin.
--   Vipratisedha_…                    the Pāṇinian scheduler.  Its live use
--                                   here is the three-organ collision.
--   Certificate                       the Agda kernel, with its two controls.
--   VargaPrakrti_CompositionLawAsParameter  the reactor, law as a value.
--   Astadhyayi                        the śivasūtra interval procedure.
--
-- THE ADDED CONTRACT, over and above the sabhā's.  Every answer on this
-- wire carries, at the top level of the object, two more fields:
--
--   "nirnaya"   the saptabhaṅgī position of THE ANSWER ITSELF — not of the
--               object asked about.  An answer is an utterance and an
--               utterance has a position.
--   "pramanya"  the route by which this answer is a pramāṇa, with its
--               witness.  Five routes and no sixth (see `Pramanya`).  One
--               of them, `ayogya`, says there is NO route; and a transport
--               claiming ayogya is downgraded, by `mudra` below, into a
--               written defect about itself.  §19: यत् अनङ्गीकृतमार्गेण
--               आगच्छति तत् न दुर्बलं प्रमाणम् । तत् अप्रमाणम् — what arrives by an
--               unaccepted route is not weak evidence, it is not evidence.
--
-- WHAT IS REFUSED HERE, and this is the load-bearing refusal of the whole
-- assembly.  There are three saptabhaṅgī types in this machine and they do
-- not agree.  Two of them (Saptabhangi's and Obstruction's) ARE equivalent,
-- and the equivalence is exhibited and checked exhaustively over all
-- sixteen round trips — that is `saptabhangi.samkramana`, and it is a
-- transport.  The third (SaptabhangiGarbha) is NOT equivalent to either,
-- in both directions, and the failure is exhibited by computation rather
-- than asserted — that is `saptabhangi.nasti`, and it is a written defect.
-- The machine does not pick.  `nirnaya.saptabhangi` asks all three about
-- one claim, hands the three answers to the Pāṇinian scheduler as three
-- rules contending for one site, and the scheduler declines: no metarule
-- decides, and it says which abstained and why.  §7: नयभेदे सङ्क्षेपो न
-- विद्यते । न वर्जितः । न अनुचितः । न अशिष्टः । न विद्यते — where the standpoints
-- genuinely differ the collapse is not forbidden, it does not exist.
--
-- RUN IT:
--     sh machine/run-yantra.sh              -- the scripted session, checked
--     sh machine/run-yantra.sh --wire       -- JSON lines on stdin/stdout
--
-- The transcript is appended to $YANTRA_LEKHA; the session's filed defects
-- go to $DOSA_LEKHA, which run-yantra.sh points at a session-scoped log so
-- that a demonstration does not append to machine/dosa.lekha, which is
-- shared and which four lanes are writing to today.

module Yantra_TheOrgansAreOneMachineOnOneWire
  ( Yantra(..)
  , emptyYantra
  , Kriya(..)
  , kriyah
  , Pramanya(..)
  , Mudra(..)
  , answer
  , mudritaJ            -- render an answer to J (नाडी routes organ-verbs through this)
  , serve
  , yantraMain
  ) where

import Control.Monad (foldM, forM_)
import Data.Char (isDigit, isSpace)
import Data.IORef
import Data.List (intercalate, nub, isInfixOf)
import System.Environment (getArgs, lookupEnv)
import System.Exit (ExitCode(..), exitFailure, exitSuccess)
import System.IO
import System.Process (readProcessWithExitCode)
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding)

import Sabda_TheWireHasNoBoolean
-- `hiding (Ganita)` is a live seam and not a preference.  While this lane was
-- repairing the readers below, the Uttara lane gave `Saksin` a constructor
-- `Ganita` — a COMPUTED witness, as against `Likhita`, a written one — and
-- this file has had a `Pramanya` constructor of the same name since it was
-- written, meaning the same thing one layer up: the route by which an answer
-- is a pramāṇa is arithmetic done here.  Two lanes reached the same word for
-- the same distinction, which is evidence the word is right, and neither of
-- them is wrong.  Hiding disambiguates HERE without renaming EITHER; §12,
-- नाम्नि जीवनम् — a name taken away from a lane that chose it is a loss in one
-- word.  Nothing of theirs is used through this import that the hiding
-- removes: this file reads their witnesses through `tuWitness`.
import Uttara_SamkramanaOrDosalekhaNeverABareBoolean hiding (Ganita)
import qualified NayaKosha_TheStandpointStore as K
import qualified Saptabhangi_TheSevenfoldVerdict as S
import qualified SaptabhangiGarbha_TheResidueIsTheSeed as G
import qualified Obstruction as OB
import qualified Vipratisedha_ConflictIsDecidedByMetaruleNotByListPosition as VS
import qualified Certificate as C
import qualified VargaPrakrti_CompositionLawAsParameter as VP
import qualified Astadhyayi as P

-- ============================================================ प्रामाण्य
--
-- Moved to Pramanya_TheFiveRoutesAndTheirWitnesses, 2026-08-23, so that
-- Aisthesis and the runghc organs (./jiva) can speak the route vocabulary
-- without interpreting this whole assembly.  Imported and re-exported:
-- the wire interface of this module is unchanged.
import Pramanya_TheFiveRoutesAndTheirWitnesses
  (Pramanya(..), pramanyaJ, pramanyaWitness)

-- | The stamp every answer carries.  `mSthana` is Saptabhangi's type and
--   not one of the other two, and that choice is itself a defect this file
--   writes rather than hides: see `kSaptaNasti`.
data Mudra = Mudra { mSthana :: S.Sthana, mPramanya :: Pramanya }

-- | The downgrade.  A transport that cannot name its route is an assertion,
--   and an assertion presented as transport is the collapse this machine
--   exists to refuse — committed by the machine itself, which is the only
--   place it would go unnoticed.
mudra :: Mudra -> Uttara -> (Mudra, Uttara)
mudra m u@Samkramana{} = case mPramanya m of
  Ayogya why ->
    ( m { mSthana = S.Apratipatti }
    , dosalekha (uKriya u)
        ("a transport was claimed for `" ++ uKriya u ++ "` by no accepted route: " ++ why)
        ( [ "the transport itself, which is withdrawn: what it would have carried is listed below rather than delivered" ]
          ++ [ "withheld: " ++ k ++ " = " ++ take 300 (render v) | (k, v) <- uVahita u ] )
        [ "name the route — pratyaksa, nihsesa, ganita or kernel — and exhibit its witness, then ask again" ]
        ( uPramana u ++ [ "Gautama, Nyāyasūtra 1.1.3, c. 2nd c. CE; AHIMSA_SUTRA_VISTARA §19 — अप्रमाणं न सञ्चीयते" ] ) )
  _ -> (m, u)
mudra m u = (m, u)

-- | The answer as it goes onto the wire: the sabhā's own object, with the
--   two added fields spliced in after `kriya` so a reader meets the
--   position and the route before the content.
mudritaJ :: Mudra -> Uttara -> J
mudritaJ m u = case uttaraJ u of
  JObj kvs ->
    let (before, after) = span ((`elem` ["uttara", "kriya"]) . fst) kvs
    in JObj ( before
              ++ [ ("nirnaya", JObj [ ("sthana", JStr (S.sanskritOf (mSthana m)))
                                    , ("artha", JStr (S.glossOf (mSthana m))) ])
                 , ("pramanya", pramanyaJ (mPramanya m)) ]
              ++ after )
  other -> other

mudraLines :: Mudra -> [String]
mudraLines m =
  [ "  nirnaya: " ++ S.sanskritOf (mSthana m) ++ " — " ++ S.glossOf (mSthana m)
  , "  pramanya: " ++ margaName (mPramanya m) ++ " — " ++ pramanyaWitness (mPramanya m) ]
  where
    margaName p = case p of
      Pratyaksa _ -> "pratyaksa (the object is in the answer)"
      Nihsesa n _ -> "nihsesa (exhaustive over " ++ show n ++ " cases, all run)"
      Ganita _    -> "ganita (an exact identity in ℤ)"
      Kernel _    -> "kernel (agda typechecked it, controls watched first)"
      Ayogya _    -> "ayogya (NO accepted route)"

-- ============================================================ the state

data Yantra = Yantra
  { yKosha :: K.Kosha                 -- the real store
  , yDosa  :: [(Int, Uttara)]         -- in memory, newest first
  , yFiled :: [(Int, Either String String)]  -- and what the doṣa-lekha said back
  , ySesa  :: [(Int, String)]
  , yTurn  :: Int
  , yRoot  :: FilePath                -- repository root, for the agda kernel
  , yDosaBin :: Maybe FilePath        -- the doṣa-lekha binary, if built
  }

emptyYantra :: FilePath -> Maybe FilePath -> Yantra
emptyYantra root bin = Yantra K.empty [] [] [] 0 root bin

-- ============================================================ dispatch

data Kriya = Kriya
  { kName   :: String
  , kDoc    :: String
  , kParams :: [(String, String)]
  , kRun    :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
  }

-- The sabhā recorded a defect against its own dispatch: *this table is
-- first-match, which is the weakest possible discipline*.  The repair is
-- not a scheduler.  It is that dispatch here is by EXACT NAME and the names
-- are unique, so dispatch is a function and no conflict arises — and that
-- uniqueness is CHECKED (`nameCollisions`, exhaustive over the table) rather
-- than assumed.  Should two handlers ever share a name, that is a genuine
-- vipratiṣedha and `kSarvaKriyah` reports it as one instead of quietly
-- serving whichever `lookup` reached first.  The scheduler's live use in
-- this machine is elsewhere: `nirnaya.saptabhangi`.
nameCollisions :: [String]
nameCollisions = [ n | n <- nub names, length [ () | m <- names, m == n ] > 1 ]
  where names = map kName kriyah

kriyah :: [Kriya]
kriyah =
  [ Kriya "yantra.kriyah"
      "What this machine can be asked.  Emitted from the table the server dispatches on, so it cannot drift from what runs."
      [] kKriyah
  , Kriya "yantra.sthiti"
      "The whole session: the store in full, the defect log, what the doṣa-lekha said back when each defect was filed, the remainder queue."
      [] kSthiti
  , Kriya "naya.sthapana"
      "Install a standpoint into the नयकोश.  Every witness carries the document it comes from; the entry carries the fitness of the looking that produced it."
      [ ("naya", "the standpoint's name; NOT an index — the store returns a list")
      , ("saksin", "list of {\"vacana\":..., \"mula\":...} — what it says, and the document it says it from")
      , ("yogyata", "\"yogya\" or \"ayogya\" — was the looking fit to have found what it looked for")
      , ("yogyata-hetu", "the account of the search; a fitness claim with no account of the search is itself unfit")
      , ("karta", "who recorded it"), ("kala", "when") ]
      kSthapana
  , Kriya "naya.suchi"
      "Every entry held, with its id, its witnesses, their sources, and its fitness.  The listing is the store."
      [] kSuchi
  , Kriya "naya.samasa"
      "May these be identified?  Runs NayaKosha.decide, which reports the sevenfold position, the highest level of agreement, the maximal collapsible sub-families, and — item by item — what a single verdict would destroy."
      [ ("nayah", "list of installed standpoint names")
      , ("arpana", "\"saha\" (asserted at once) or \"krama\" (in succession) — Akalaṅka's distinction; not a boolean") ]
      kSamasa
  , Kriya "kosha.punaravrtti"
      "Journal the live store and replay the journal.  The round trip is the whole persistence claim, so it is run, on the store as it stands, rather than cited."
      [] kPunaravrtti
  , Kriya "nirnaya.saptabhangi"
      "Ask ALL THREE verdict organs about one claim and hand the three answers to the Pāṇinian scheduler as three rules contending for one site.  The scheduler does not pick."
      [ ("nayah", "list of installed standpoint names")
      , ("arpana", "\"saha\" or \"krama\"") ]
      kTrayaNirnaya
  , Kriya "saptabhangi.samkramana"
      "The equivalence that DOES exist between two of the three verdict types, exhibited and checked exhaustively in both directions."
      [] kSaptaSamkramana
  , Kriya "saptabhangi.nasti"
      "The equivalence that does NOT exist between the third and the other two, with the collision computed and both colliding objects exhibited."
      [] kSaptaNasti
  , Kriya "garbha.dhara"
      "The fourth position is positive: from a residue, the stream of positions born from it.  Tattvārthasūtra 5.31 as an operation."
      [ ("sadhaka", "the affirming standpoint's name"), ("sadhaka-saksin", "its witness")
      , ("badhaka", "the denying standpoint's name"), ("badhaka-saksin", "its witness")
      , ("stara", "optional: how many births to run out (default 3)") ]
      kGarbhaDhara
  , Kriya "sadhana"
      "Emit an Agda module for an equation and give it to the kernel.  The kernel's two controls are watched FIRST; a kernel that has not been seen to reject a falsehood certifies nothing."
      [ ("vama", "left side, as a prefix s-expression over the fragment")
      , ("daksina", "right side")
      , ("sadhya", "optional: a note naming the induction variable, e.g. \"induction on x\"") ]
      kSadhana
  , Kriya "kuttaka"
      "Āryabhaṭa's pulverizer: the vallī of a and b, the Bézout pair, and — if c is given — the solution of a·x ≡ c (mod b)."
      [ ("a", "an integer"), ("b", "a positive integer"), ("c", "optional: the residue to hit") ]
      kKuttaka
  , Kriya "vargaprakrti"
      "The reactor with the composition law as a VALUE: Brahmagupta's bhāvanā driven by the cakravāla, every norm the wheel visits, each of them a solved equation."
      [ ("D", "a non-square integer ≥ 2"), ("n", "optional: a norm to solve for instead of 1") ]
      kVargaprakrti
  , Kriya "pratyahara"
      "Pāṇini's interval notation: the sounds from ādi up to the marker it, in the varṇasamāmnāya."
      [ ("adi", "the starting sound, e.g. \"a\""), ("it", "the anubandha, e.g. \"ṇ\"")
      , ("avrtti", "optional: which occurrence of the marker (0 = the first)") ]
      kPratyahara
  , Kriya "dosa.lekha"
      "Write a defect yourself.  Stored verbatim in the session, and filed into the doṣa-lekha on disk with its chain extended."
      [ ("kriya", "what you were attempting"), ("hetu", "why transport was impossible")
      , ("nasta", "list: what a collapse here would destroy, named one by one")
      , ("sesa", "optional list: the remainder, handed forward") ]
      kDosaLekha
  , Kriya "dosa.suchi"
      "Every defect this session has written, in the order written, each with what the doṣa-lekha said back when it was filed."
      [] kDosaSuchi
  , Kriya "dosa.pramanya"
      "Verify the doṣa-lekha's chain FROM INSIDE THE SESSION: recompute every sāra over every record and report the first divergence, if any."
      [] kDosaPramanya
  , Kriya "sesa.arpana"
      "Hand a remainder forward (遺題継承): the unfinished thing kept for the next step rather than dropped."
      [ ("sesa", "list of remainder strings") ] kSesaArpana
  , Kriya "sesa.suchi" "The remainder queue." [] kSesaSuchi
  ]

-- ============================================================ sources

sutra :: String -> [String]
sutra s = [ "notes/AHIMSA_SUTRA_VISTARA.md " ++ s ]

srcTwoRoads :: [String]
srcTwoRoads = sutra "§6 — संक्रमणं दोषलेखश्च । तृतीयो मार्गो न विद्यते ।"

-- ============================================================ the ops

affirmed :: String -> Mudra
affirmed w = Mudra (S.Position S.SyadAsti) (Pratyaksa w)

kKriyah :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kKriyah y _ = pure (y, m, u)
  where
    m = Mudra (S.Position S.SyadAsti)
          (Nihsesa (length kriyah)
             ("every one of the " ++ show (length kriyah)
              ++ " entries emitted from the same list the server dispatches on; "
              ++ "name collisions checked exhaustively over the table: "
              ++ (if null nameCollisions then "none" else intercalate ", " nameCollisions)))
    u = samkramana "yantra.kriyah"
          (tulyata "refl — the identity equivalence, the one transport always available"
                   "the dispatch table as it runs"
                   "the listing you are reading"
                   "there is no second copy to fall out of date")
          [ ("kriyah", JArr [ JObj [ ("nama", JStr (kName k))
                                   , ("artha", JStr (kDoc k))
                                   , ("angani", JArr [ JObj [("nama", JStr p), ("artha", JStr d)]
                                                     | (p, d) <- kParams k ]) ]
                            | k <- kriyah ])
          , ("nama-samkara", JArr (map JStr nameCollisions)) ]
          [ "the handlers' source, which the listing describes and does not carry"
          , "the ORDER of the table, which carries no fact: dispatch is by exact name and the names are checked unique, so there is nothing here for vipratiṣedhe paraṁ kāryam to compare"
          , "who asked, and why they asked now" ]
          [ "Pāṇini, Aṣṭādhyāyī 1.4.2, c. 500 BCE — conflict is settled by a stated principle; where no conflict arises there is nothing to settle" ]

kSthiti :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kSthiti y _ = pure (y, m, u)
  where
    n = length (K.koshaEntries (yKosha y))
    m = affirmed ("all " ++ show n ++ " store entries, all "
                  ++ show (length (yDosa y)) ++ " defect entries and all "
                  ++ show (length (ySesa y)) ++ " remainders emitted in full; nothing counted in place of being named")
    u = samkramana "yantra.sthiti"
          (tulyata "refl" "the session state in memory" "the object below"
                   "every entry, every witness, every source, every defect and every remainder is emitted")
          [ ("kosha", JArr (map entryJ (K.koshaEntries (yKosha y))))
          , ("dosah", JArr [ JObj [ ("kramanka", JInt (fromIntegral i)), ("lekha", uttaraJ d) ]
                           | (i, d) <- reverse (yDosa y) ])
          , ("dosa-nyasa", JArr [ JObj [ ("kramanka", JInt (fromIntegral i))
                                       , ("phala", JStr (either ("REFUSED: " ++) id r)) ]
                                | (i, r) <- reverse (yFiled y) ])
          , ("sesah", JArr [ JObj [("kramanka", JInt (fromIntegral i)), ("vastu", JStr t)]
                           | (i, t) <- reverse (ySesa y) ])
          , ("avrtti", JInt (fromIntegral (yTurn y))) ]
          [ "the interlocutor, who is not modelled"
          , "what else was in flight in this repository while the session ran" ]
          srcTwoRoads

entryJ :: K.Entry -> J
entryJ e = JObj
  [ ("id", JInt (fromIntegral (K.entId e)))
  , ("nama", JStr (K.entName e))
  , ("yogyata", JStr (case K.entYogyata e of
                        K.Yogya r  -> "yogya: " ++ r
                        K.Ayogya r -> "ayogya: " ++ r))
  , ("karta", JStr (K.entRecorder e))
  , ("kala", JStr (K.entWhen e))
  , ("saksinah", JArr [ JObj [("vacana", JStr (K.sakLabel w)), ("mula", JStr (K.sakSource w))]
                      | w <- K.entWitness e ]) ]

-- ---- the store

jSaksinah :: J -> Either String [K.Sakshin]
jSaksinah o = look "saksin" o >>= \v -> case v of
  JArr xs -> mapM one xs
  _ -> Left "`saksin` must be a list of {\"vacana\":…, \"mula\":…} objects"
  where
    one (JObj kvs) = case (lookup "vacana" kvs, lookup "mula" kvs) of
      (Just (JStr l), Just (JStr s)) -> Right (K.Sakshin l s)
      (Just (JStr _), _) -> Left "a witness without `mula`: the source is carried, never folded into the label"
      _ -> Left "a witness needs `vacana` (what it says) and `mula` (the document it says it from)"
    one x = Left ("a witness must be an object, got " ++ render x)

kSthapana :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kSthapana y j = pure $ case pieces of
  Left e -> refused y "naya.sthapana" e
  Right (nm, ws, yg, rec_, wh)
    | any (null . K.sakLabel) ws -> (y, denied "an empty witness label", emptyLabel nm)
    | otherwise ->
        let e = K.Entry { K.entId = 0, K.entName = nm, K.entYogyata = yg
                        , K.entRecorder = rec_, K.entWhen = wh, K.entWitness = ws }
            (i, rels, k') = K.insert e (yKosha y)
            e' = maybe e id (K.byId k' i)
        in ( y { yKosha = k' }
           , affirmed ("stored verbatim as #" ++ show i
                       ++ "; every relation it bears to what was already held is emitted below, and none of them caused a merge")
           , samkramana "naya.sthapana"
               (tulyata "the standpoint as uttered, identified with the standpoint as stored"
                        ("the " ++ show (length ws) ++ " witness(es) you sent, with their sources")
                        ("entry #" ++ show i ++ " of the नयकोश")
                        "no normalisation, no deduplication, no reordering, no merge: `insert` has no code path that drops, overwrites or unifies")
               [ ("id", JInt (fromIntegral i))
               , ("pravista", entryJ e')
               , ("sambandhah", JArr [ JStr (K.sambandhaGloss r) | r <- rels ]) ]
               [ "your reason for grouping these witnesses under this name"
               , "the standpoint's own account of itself, which a name and a witness list do not carry"
               , "the occasion of the assertion" ]
               [ "Umāsvāti, Tattvārthasūtra 5.31 (arpitānarpitasiddheḥ), c. 2nd–5th c. — what is asserted and what is left unasserted jointly establish the object"
               , "Kumārila, Ślokavārttika, Abhāvapariccheda, c. 7th c. — yogya-anupalabdhi, which is why `yogyata` is a required field and not a default" ] )
  where
    pieces = do
      nm <- jStr "naya" j
      ws <- jSaksinah j
      yv <- jStr "yogyata" j
      yh <- jStr "yogyata-hetu" j
      yg <- case yv of
              "yogya"  -> Right (K.Yogya yh)
              "ayogya" -> Right (K.Ayogya yh)
              _ -> Left ("`yogyata` was \"" ++ yv ++ "\"; it must be \"yogya\" or \"ayogya\" — "
                         ++ "whether the looking was FIT to have found what it looked for.  "
                         ++ "`not found` without `where I looked` is not a pramāṇa "
                         ++ "(Kumārila, Abhāvapariccheda).")
      rec_ <- jStr "karta" j
      wh <- jStr "kala" j
      pure (nm, ws, yg, rec_, wh)
    emptyLabel nm = dosalekha "naya.sthapana"
      ("standpoint `" ++ nm ++ "` carries an empty witness label")
      [ "an empty label is a witness whose identity was dropped before it arrived; the store would hold something that stands for something and cannot say what"
      , "and every later decision about this standpoint, which would silently rest on it" ]
      [ "name the witness: a document, a date, a statement, a computation — and give its `mula`" ]
      [ "NayaKosha_TheStandpointStore refuses the same input at `decide`, for the same reason" ]

kSuchi :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kSuchi y _
  | null es = pure ( y
                   , Mudra S.Apratipatti
                       (Pratyaksa "the store is empty, and `empty` and `nothing installed` are the same fact here and said as one")
                   , dosalekha "naya.suchi"
                       "no standpoints are held, so there is nothing to carry"
                       [ "the listing you asked for; an empty listing and `nothing is held` are different facts and this says which one it is" ]
                       [ "install one with naya.sthapana" ] srcTwoRoads )
  | otherwise = pure ( y
                     , affirmed ("all " ++ show (length es) ++ " entries, every witness and every source; the listing is the store")
                     , samkramana "naya.suchi"
                         (tulyata "refl" "the नयकोश" "the listing" "byName returns a LIST; a store whose name lookup returns one entry has decided a name is an index, which is the collapse")
                         [ ("kosha", JArr (map entryJ es)) ]
                         [ "the arrival order is the emission order, but the wall-clock times are not held" ]
                         srcTwoRoads )
  where es = K.koshaEntries (yKosha y)

lookupNames :: Yantra -> [String] -> ([String], [K.Entry])
lookupNames y names = (missing, found)
  where
    missing = [ n | n <- names, null (K.byName (yKosha y) n) ]
    found   = concatMap (K.byName (yKosha y)) names

arpanaOf :: J -> Either String Bool
arpanaOf j = jStr "arpana" j >>= \a -> case a of
  "saha"  -> Right True
  "krama" -> Right False
  _ -> Left ("`arpana` was \"" ++ a ++ "\"; it must name the mode of assertion.  "
             ++ "saha (yugapat, asserted at once) against krama (in succession) is "
             ++ "Akalaṅka's own distinction and it is the whole difference between "
             ++ "the third bhaṅga and the fourth.  It is not a boolean and this wire "
             ++ "has none.")

kSamasa :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kSamasa y j = pure $ case (,) <$> jStrs "nayah" j <*> arpanaOf j of
  Left e -> refused y "naya.samasa" e
  Right (names, saha)
    | (miss@(_:_), _) <- lookupNames y names -> (y, unfit "standpoints not held", notHeld miss)
    | otherwise ->
        let (_, es) = lookupNames y names
        in ofNirnaya saha es (K.decide saha es)
  where
    notHeld miss = dosalekha "naya.samasa"
      ("these standpoints are not held: " ++ intercalate ", " miss)
      ([ "the question you asked, which cannot be decided about things that are not here" ]
       ++ [ "unavailable: " ++ mm | mm <- miss ])
      ([ "held now: " ++ K.entName e ++ " (#" ++ show (K.entId e) ++ ")"
       | e <- K.koshaEntries (yKosha y) ]
       ++ [ "install the missing ones with naya.sthapana, then ask again" ])
      srcTwoRoads
    ofNirnaya _ _ (K.Abhinna msg) =
      ( y, unfit msg
      , dosalekha "naya.samasa" ("no verdict issued (abhinna): " ++ msg)
          [ "the decision you asked for, which this store's looking is not fit to make"
          , "and the distinction between `no` and `I cannot see`: an unfit looking's silence is NOT a denial, and this answer is NOT the fourth bhaṅga — avaktavyam is positive and this is a refusal" ]
          [ "supply witnesses, or state a fit looking, or extend the fragment"
          , "Kumārila, Ślokavārttika, Abhāvapariccheda, c. 7th c. — yogya-anupalabdhi" ]
          [ "Kumārila, Ślokavārttika, Abhāvapariccheda" ] )
    ofNirnaya saha es n@K.Nirnaya{} =
      let pos  = obToS (K.nirSthana n)
          body = K.render n
          lost = concat [ ("collapsing away `" ++ nm ++ "` destroys:") : [ "    " ++ w | w <- ws ]
                        | (nm, ws) <- K.nirNashti n, not (null ws) ]
                 ++ concat [ ("a content-collapse of `" ++ nm ++ "` discards the SOURCES:") : [ "    " ++ s | s <- ss ]
                           | (nm, ss) <- K.nirMulaLoss n, not (null ss) ]
          witn = "NayaKosha.decide over " ++ show (length es)
                 ++ " entries, at all three levels of agreement (satya ⊂ artha ⊂ mula)"
      in case K.nirSthana n of
           OB.Position OB.B1Asti ->
             ( y, Mudra pos (Nihsesa (length es) witn)
             , samkramana "naya.samasa"
                 (tulyata "the identification the store finds available"
                          (intercalate " ⊔ " (map K.entName es))
                          ("one position: " ++ S.sanskritOf pos)
                          (intercalate " / " body))
                 [ ("vakya", JArr (map JStr body))
                  , ("varga", JArr [ JArr (map (JInt . fromIntegral) c) | c <- K.nirVarga n ])
                  , ("samata", JStr (maybe "none — not even truth-equal" K.samataName (K.nirSamata n))) ]
                 ( [ "the NAMES, which differ and are exactly what an identification drops — recoverable here only because they are printed above" ]
                   ++ [ "who held each standpoint, and why holding both looked like balance" ]
                   ++ map ("would be destroyed by a collapse this answer does NOT perform: " ++) (take 4 lost) )
                 [ "Siddhasena Divākara, Sanmatitarka — a naya is true and not whole" ] )
           _ ->
             ( y, Mudra pos (Nihsesa (length es) witn)
             , dosalekha "naya.samasa"
                 ("the position is " ++ S.sanskritOf pos ++ " — " ++ S.glossOf pos
                  ++ (if saha then "  (asserted saha)" else "  (asserted krama)"))
                 ( (if null lost
                      then [ "the single verdict you asked for; the standpoints do not identify and the loss is the verdict itself" ]
                      else lost)
                   ++ [ "residue held and undecided: `" ++ nm ++ "` — " ++ r | (nm, r) <- K.nirShesha n ] )
                 ( body
                   ++ [ "AHIMSA_SUTRA_VISTARA §3: अवक्तव्ये शेषो वसति । शेषो गर्भः, न विफलता — ask garbha.dhara to run the fourth position forward" ] )
                 [ "Akalaṅka, Laghīyastraya, c. 720–780 — kramārpaṇa against sahārpaṇa"
                 , "Siddhasena Divākara, Sanmatitarka 1.21 — a naya asserting itself by denying the others is a durnaya" ] )

kPunaravrtti :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kPunaravrtti y _ = pure result
  where
    k = yKosha y
    jl = K.journal k
    back = K.replay jl
    n = length (K.koshaEntries k)
    result
      | back == Right k =
          ( y
          , Mudra (S.Position S.SyadAsti)
              (Nihsesa n ("replay ∘ journal = id, run on the live store, all "
                          ++ show n ++ " entries, this turn — not cited from the module's own selfTest"))
          , samkramana "kosha.punaravrtti"
              (tulyata "the store, identified with its journal read back"
                       ("the नयकोश in memory (" ++ show n ++ " entries)")
                       "the same store reconstructed from its journal lines alone"
                       "structural equality on the whole Kosha, including ids, sources and fitness reasons")
              [ ("panktayah", JArr (map JStr jl))
              , ("ganana", JInt (fromIntegral n)) ]
              [ "the ORDER of arrival is preserved in the lines but the wall-clock times are not held anywhere"
              , "the journal is deterministic bytes; it does not carry who wrote them or on what machine" ]
              [ "AHIMSA_SUTRA_VISTARA §35 — प्रामाण्यं पुरुषे, न वस्तुनि: the round trip is checked, and it is still the person who is asked" ] )
      | otherwise =
          ( y
          , Mudra (S.Position S.SyadNasti)
              (Pratyaksa "the round trip was run on the live store and it did not close; both sides are exhibited")
          , dosalekha "kosha.punaravrtti"
              "the store does not survive its own journal"
              ( [ "the persistence claim, which is now false for THIS store rather than in general" ]
                ++ [ "written: " ++ l | l <- jl ]
                ++ [ "read back: " ++ show back ] )
              [ "an entry contains a byte the escaper does not round-trip; the two exhibits above locate it" ]
              srcTwoRoads )

-- ---- three organs, one site

-- Saptabhangi's Sthana and Obstruction's are the same eight positions under
-- two names.  `obToS`/`sToOb` is the identification, and `kSaptaSamkramana`
-- runs both round trips over all sixteen cases before this file relies on it.
obToS :: OB.Sthana -> S.Sthana
obToS OB.ADharmin = S.Apratipatti
obToS (OB.Position b) = S.Position $ case b of
  OB.B1Asti               -> S.SyadAsti
  OB.B2Nasti              -> S.SyadNasti
  OB.B3AstiNasti          -> S.SyadAstiNasti
  OB.B4Avaktavya          -> S.SyadAvaktavya
  OB.B5AstiAvaktavya      -> S.SyadAstiAvaktavya
  OB.B6NastiAvaktavya     -> S.SyadNastiAvaktavya
  OB.B7AstiNastiAvaktavya -> S.SyadAstiNastiAvaktavya

sToOb :: S.Sthana -> OB.Sthana
sToOb S.Apratipatti = OB.ADharmin
sToOb (S.Position b) = OB.Position $ case b of
  S.SyadAsti               -> OB.B1Asti
  S.SyadNasti              -> OB.B2Nasti
  S.SyadAstiNasti          -> OB.B3AstiNasti
  S.SyadAvaktavya          -> OB.B4Avaktavya
  S.SyadAstiAvaktavya      -> OB.B5AstiAvaktavya
  S.SyadNastiAvaktavya     -> OB.B6NastiAvaktavya
  S.SyadAstiNastiAvaktavya -> OB.B7AstiNastiAvaktavya

allS :: [S.Sthana]
allS = S.Apratipatti : map S.Position [minBound .. maxBound]

allOB :: [OB.Sthana]
allOB = map sToOb allS

-- The forgetful map: a proof-relevant position, read as a profile.  It has
-- no section, and `kSaptaNasti` computes the collision rather than saying so.
smrtilopa :: G.Bhanga -> S.Bhanga
smrtilopa b = case b of
  G.SyadAsti _                    -> S.SyadAsti
  G.SyanNasti _                   -> S.SyadNasti
  G.SyadAstiNasti _ _             -> S.SyadAstiNasti
  G.SyadAvaktavyam _              -> S.SyadAvaktavya
  G.SyadAstiAvaktavyam _ _        -> S.SyadAstiAvaktavya
  G.SyanNastiAvaktavyam _ _       -> S.SyadNastiAvaktavya
  G.SyadAstiNastiAvaktavyam _ _ _ -> S.SyadAstiNastiAvaktavya

-- Build each organ's reading of the same entries.

organKosha :: Bool -> [K.Entry] -> (String, [String])
organKosha saha es = case K.decide saha es of
  K.Abhinna msg -> ("apratipatti (abhinna)", ["no verdict: " ++ msg])
  n -> (S.sanskritOf (obToS (K.nirSthana n)), K.render n)

organProfile :: Bool -> [K.Entry] -> (String, [String])
organProfile saha es = (S.sanskritOf pos, lines_)
  where
    one e = case (K.entWitness e, K.entYogyata e) of
      ([], K.Yogya _)  -> S.Position S.SyadNasti
      ([], K.Ayogya _) -> S.Apratipatti
      (_, _)           -> S.Position S.SyadAsti
    fold_ = if saha then S.sahaS else S.kramaS
    pos = case map one es of
            []     -> S.Apratipatti
            (x:xs) -> foldl fold_ x xs
    lines_ = [ "  " ++ K.entName e ++ " → " ++ S.sanskritOf (one e) | e <- es ]
             ++ [ "  folded with " ++ (if saha then "sahaS" else "kramaS")
                  ++ " → " ++ S.sanskritOf pos
                , "  NOTE what this organ holds that the others do not: `" ++ S.sanskritOf pos
                  ++ "` is a PROFILE.  After jihvābheda the fourth position does not "
                  ++ "record which two seeds produced it, and that module states this "
                  ++ "is the doctrine's claim, not a modelling artefact — which is "
                  ++ "exactly why its saha does not associate." ]

organGarbha :: Bool -> [K.Entry] -> (String, [String])
organGarbha saha es = case mapM one es of
  Nothing -> ("(no reading)", ["this organ has no constructor for `nothing was said`: every one of its seven positions carries at least one naya WITH ITS WITNESS, so an entry whose looking was unfit cannot be represented here at all"])
  Just [] -> ("(no reading)", ["no entries"])
  Just (b:bs) ->
    let fold_ = if saha then G.saha else G.krama
        r = foldl fold_ b bs
    in ( head (G.renderBhanga r)
       , map ("  " ++) (G.renderBhanga r)
         ++ [ "  NOTE what this organ holds that the others do not: the fourth "
              ++ "position here CARRIES both nayas and both witnesses (Sesa), and "
              ++ "`caturthatTritiya` reads them back out.  Where the profile organ "
              ++ "says the seeds are consumed, this one says they are retained." ] )
  where
    one e = case (K.entWitness e, K.entYogyata e) of
      ([], K.Yogya r)  -> Just (G.SyanNasti (G.Naya (K.entName e) [] ("fit looking, no witness: " ++ r)))
      ([], K.Ayogya _) -> Nothing
      (w:_, _)         -> Just (G.SyadAsti (G.Naya (K.entName e) []
                                  (K.sakLabel w ++ " [" ++ K.sakSource w ++ "]")))

-- The three, as three rules contending for one site.
trayaTantra :: [(VS.Sthana, String, String)] -> VS.Tantra String
trayaTantra offers = VS.Tantra
  { VS.tSasanani = [ VS.Sasana { VS.saRef = r, VS.saName = nm, VS.saApavadaTo = []
                               , VS.saFires = \o -> [ VS.Nyasa r 0 1 o note ] }
                   | (r, nm, note) <- offers ]
  , VS.tApavada = \_ _ -> False
    -- No organ is an apavāda to another.  None of the three was written as
    -- an exception to another; they were written independently, by three
    -- lanes, and declaring an exception here would be inventing a relation.
  , VS.tAntaranga = \_ _ -> Nothing
    -- ABSTAIN, and this is the important abstention.  The proof-relevant
    -- organ looks further in — at the nayas' witnesses — and it is tempting
    -- to call it antaraṅga and let it win.  antaraṅga is about the depth of
    -- a rule's NIMITTA within one derivation; these three are not stages of
    -- one derivation.  Asserting it here would be manufacturing a position
    -- to break a tie, which is what tParatva's own documentation names as
    -- the collapse the module exists to refuse.
  , VS.tOverlap = \_ _ -> True          -- all three answer the same question
  , VS.tStratum = const 0
  , VS.tParatva = False
    -- The addresses below were assigned BY THIS FILE, this session, to
    -- three modules that were never placed with respect to one another.  A
    -- list index is not a position.  So 1.4.2 has nothing to compare and
    -- says so, and the result is a written defect rather than whichever one
    -- `sortOn` left last.
  , VS.tSame = (==)
  }

kTrayaNirnaya :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kTrayaNirnaya y j = pure $ case (,) <$> jStrs "nayah" j <*> arpanaOf j of
  Left e -> refused y "nirnaya.saptabhangi" e
  Right (names, saha)
    | (miss@(_:_), _) <- lookupNames y names ->
        (y, unfit "standpoints not held", dosalekha "nirnaya.saptabhangi"
              ("these standpoints are not held: " ++ intercalate ", " miss)
              [ "the question, which cannot be put to three organs about things that are not here" ]
              [ "install them with naya.sthapana" ] srcTwoRoads)
    | otherwise ->
        let (_, es) = lookupNames y names
            (pA, lA) = organKosha   saha es
            (pB, lB) = organProfile saha es
            (pC, lC) = organGarbha  saha es
            offers = [ ((1,1,1), "NayaKosha/Obstruction — B1..B7 + ADharmin", pA)
                     , ((1,1,2), "Saptabhangi — presence profiles + Apratipatti", pB)
                     , ((1,1,3), "SaptabhangiGarbha — proof-relevant, residue carries both nayas", pC) ]
            t = trayaTantra offers
            nys = [ VS.Nyasa r 0 1 note nm | (r, nm, note) <- offers ]
            v = VS.nirnaya t "the claim" nys
        in case v of
             VS.Nirnita w beaten b ->
               ( y
               , Mudra (S.Position S.SyadAsti)
                   (Pratyaksa ("a metarule decided: " ++ VS.showBalya b))
               , samkramana "nirnaya.saptabhangi"
                   (tulyata (VS.showBalya b) "three contending readings"
                            (VS.nyResult w) ("beaten: " ++ intercalate ", " (map VS.showSthana beaten)))
                   [ ("nirnita", JStr (VS.nyResult w)) ]
                   [ "the readings that lost, which are still listed but are not the answer" ]
                   [ "Pāṇini, Aṣṭādhyāyī 1.4.2, c. 500 BCE" ] )
             VS.Avaktavya d sesa ->
               ( y
               , Mudra (S.Position S.SyadAvaktavya)
                   (Pratyaksa ("all three readings are exhibited in full below, "
                               ++ "each metarule's abstention is named, and the "
                               ++ "scheduler's own śeṣa is opened and its "
                               ++ show (length (VS.sesaNyasah sesa))
                               ++ " contending offers emitted entire; "
                               ++ show (length offers) ++ " organs, one site, no winner"))
               , dosalekha "nirnaya.saptabhangi"
                   ("three verdict organs read the same claim and the Pāṇinian scheduler "
                    ++ "does not decide between them.  This is not a tie to be broken: it "
                    ++ "is the fourth position, and the machine holds it open.")
                   ( [ "the single verdict you asked for.  It does not exist, and that is a fact about the three organs, not about this session." ]
                     ++ [ "ORGAN A (1.1.1) NayaKosha/Obstruction reads: " ++ pA ]
                     ++ map ("    " ++) lA
                     ++ [ "ORGAN B (1.1.2) Saptabhangi reads: " ++ pB ]
                     ++ map ("    " ++) lB
                     ++ [ "ORGAN C (1.1.3) SaptabhangiGarbha reads: " ++ pC ]
                     ++ map ("    " ++) lC
                     ++ VS.showDosa d
                     -- The scheduler's OWN residue, opened.  `Dosa` above is
                     -- the writing of the undecided site; `Sesa` is the site.
                     -- A caller handed only the rendering can print the
                     -- fourth position and do nothing else with it, which is
                     -- the same collapse one level out.
                     ++ [ "ŚEṢA RETAINED BY THE SCHEDULER — the object contended over: "
                          ++ VS.sesaVastu sesa ]
                     ++ [ "  offer " ++ VS.showSthana (VS.nyRule n) ++ " at site "
                          ++ show (VS.nyPos n) ++ ", width " ++ show (VS.nyLen n)
                          ++ ", result `" ++ VS.nyResult n ++ "` — " ++ VS.nyNote n
                        | n <- VS.sesaNyasah sesa ] )
                   [ "A ≃ B IS available and is exhibited by saptabhangi.samkramana, checked exhaustively over all sixteen round trips — those two may be identified and this machine identifies them"
                   , "C is NOT equivalent to either, in either direction, and saptabhangi.nasti computes the collision"
                   , "so the residue is exactly one distinction: whether the fourth position retains the two seeds that produced it.  B says it does not, and calls that the doctrine.  C says it does, and reads them back out with caturthatTritiya.  That is the next question, and it is a question about Akalaṅka, not about Haskell."
                   , "AHIMSA_SUTRA_VISTARA §7: नयभेदे सङ्क्षेपो न विद्यते । न वर्जितः । न अनुचितः । न अशिष्टः । न विद्यते ।"
                   , "and a datum for that question, arriving from a third direction while this was being wired: the scheduler's own `Avaktavya` carried only a rendering (`Dosa`) when this machine first read it, and now carries a `Sesa` holding the contending offers ENTIRE — the scheduler lane reached `the fourth position must retain what produced it` independently, for its own reasons, and cites SaptabhangiGarbha's header in doing so.  Two lanes arriving at C's position is not a proof of it; it is evidence about where to look, and it is recorded here rather than left in a diff." ]
                   [ "Pāṇini, Aṣṭādhyāyī 1.4.2 (vipratiṣedhe paraṁ kāryam), c. 500 BCE; Paribhāṣenduśekhara 38 for the order the metarules are tried in"
                   , "Akalaṅka, Laghīyastraya, c. 720–780 — sahārpaṇa, which is what B and C disagree about"
                   , "Siddhasena Divākara, Sanmatitarka 1.21 — a naya that asserts itself by denying another is a durnaya, which is what picking one of these three would be" ] )

kSaptaSamkramana :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kSaptaSamkramana y _ = pure result
  where
    fwd = [ (s, sToOb s, obToS (sToOb s)) | s <- allS ]
    bwd = [ (b, obToS b, sToOb (obToS b)) | b <- allOB ]
    okF = all (\(s, _, s') -> s == s') fwd
    okB = all (\(b, _, b') -> b == b') bwd
    n = length fwd + length bwd
    result
      | okF && okB =
          ( y
          , Mudra (S.Position S.SyadAsti)
              (Nihsesa n ("both round trips run on all " ++ show (length allS)
                          ++ " positions of each side, this turn: "
                          ++ show n ++ " checks, no case omitted, no case sampled"))
          , samkramana "saptabhangi.samkramana"
              (tulyata "a bijection of finite sets with both round trips exhibited — an identification, in Voevodsky's sense: a thing held, not a fact cited"
                       "Saptabhangi_TheSevenfoldVerdict.Sthana (7 bhaṅgas + Apratipatti)"
                       "Obstruction.Sthana (B1..B7 + ADharmin)"
                       ("obToS ∘ sToOb = id on all " ++ show (length allS)
                        ++ "; sToOb ∘ obToS = id on all " ++ show (length allOB)))
              [ ("purvatah", JArr [ JObj [ ("saptabhangi", JStr (S.sanskritOf s))
                                         , ("obstruction", JStr (show ob)) ]
                                  | (s, ob, _) <- fwd ])
              , ("gananam", JInt (fromIntegral n)) ]
              [ "the two modules' GLOSSES, which differ: Obstruction says `no dharmin — a failed unification`, Saptabhangi says `no predication was made`.  The positions correspond; the accounts of WHY the eighth exists do not, and the equivalence does not carry that difference"
              , "which of the two names a downstream reader should use, which is not settled by the two being equivalent"
              , "the third organ, which this transport says nothing about — see saptabhangi.nasti" ]
              [ "Akalaṅka, Laghīyastraya, c. 720–780; Umāsvāti, Tattvārthasūtra 5.31 — the seven, and why they are seven and not six or eight"
              , "Voevodsky, univalence — तुल्यं तादात्म्यं भवितुम् अर्हति (AHIMSA_SUTRA_VISTARA §6)" ] )
      | otherwise =
          ( y, Mudra (S.Position S.SyadNasti) (Pratyaksa "the failing cases are exhibited")
          , dosalekha "saptabhangi.samkramana"
              "the two position types do not correspond after all"
              ( [ "the transport this machine relies on internally (obToS is used by naya.samasa)" ]
                ++ [ "forward failure: " ++ S.sanskritOf s ++ " → " ++ show ob ++ " → " ++ S.sanskritOf s'
                   | (s, ob, s') <- fwd, s /= s' ]
                ++ [ "backward failure: " ++ show b ++ " → " ++ S.sanskritOf s ++ " → " ++ show b'
                   | (b, s, b') <- bwd, b /= b' ] )
              [ "a constructor was added to one side and not the other; the exhibits locate it" ]
              srcTwoRoads )

kSaptaNasti :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kSaptaNasti y _ = pure (y, m, u)
  where
    nA = G.Naya "harm-is-real" [] "the Oct 2022 statements"
    nB = G.Naya "episode-is-real" [] "the documented 2025 episode"
    nC = G.Naya "record-is-partial" [] "the 1987 case series"
    nD = G.Naya "record-is-complete" [] "the 2019 registry sweep"
    g1 = G.SyadAvaktavyam (G.Sesa nA nB)
    g2 = G.SyadAvaktavyam (G.Sesa nC nD)
    img = smrtilopa g1
    collide = g1 /= g2 && smrtilopa g1 == smrtilopa g2
    -- and the other direction: Apratipatti has no preimage, because every
    -- constructor of G.Bhanga demands at least one Naya, and a Naya demands
    -- a witness.  That is not a gap to be filled; it is what that organ is.
    m = Mudra (S.Position S.SyadNastiAvaktavya)
          (Pratyaksa ("two distinct proof-relevant positions with the same image are "
                      ++ "constructed and compared in this turn; the collision is "
                      ++ (if collide then "computed, not asserted" else "NOT REPRODUCED — see the exhibit")))
    u = dosalekha "saptabhangi.nasti"
          ("SaptabhangiGarbha.Bhanga and Saptabhangi.Bhanga are not equivalent, in either "
           ++ "direction, and neither is a retract of the other.  The forgetful map "
           ++ "`smrtilopa` exists and is total; it has no section, and this is exhibited "
           ++ "rather than argued: any candidate σ sends `syad-avaktavyam` to ONE value, "
           ++ "so at most one of the two objects below is recovered by it and the other "
           ++ "is gone.  ∥A∥₁ admits no retraction — AHIMSA_SUTRA_VISTARA §5, and this "
           ++ "is that theorem with the two inhabitants named.")
          [ "the first object, in full: " ++ intercalate " / " (G.renderBhanga g1)
          , "the second object, in full: " ++ intercalate " / " (G.renderBhanga g2)
          , "their common image under smrtilopa: " ++ S.sanskritOf (S.Position img)
            ++ "  — one value, four witnesses gone: `" ++ G.nayaSaksin nA ++ "`, `"
            ++ G.nayaSaksin nB ++ "`, `" ++ G.nayaSaksin nC ++ "`, `" ++ G.nayaSaksin nD ++ "`"
          , "and in the other direction: `apratipatti` has NO preimage under smrtilopa, because every one of Garbha's seven constructors demands at least one Naya and every Naya demands a witness.  So the profile organ can say `nothing was predicated` and the proof-relevant organ structurally cannot."
          , "therefore neither embeds in the other and there is no third type they both map into that loses nothing: what B holds that C does not is the position for silence; what C holds that B does not is the identity of the two seeds inside the fourth position"
          , "and this is not a defect in either module.  §7: नयभेदे सङ्क्षेपो न विद्यते — where the standpoints genuinely differ the collapse is not forbidden, IT DOES NOT EXIST.  Searching for it is fruitless and insisting on it is false." ]
          [ "the machine holds both, runs both, and reports both — see nirnaya.saptabhangi, where all three organs answer the same question and the Pāṇinian scheduler declines to choose"
          , "the distinction that would settle it is a question about Akalaṅka's sahārpaṇa and not about either implementation: after the tongue breaks, are the two seeds consumed or retained?  Saptabhangi's header asserts consumed AND DERIVES non-associativity of saha from it; Garbha retains them and reads them back with caturthatTritiya.  Only one of those can be the doctrine, and the texts, not the types, decide it."
          , "next step, concretely: Akalaṅka, Laghīyastraya and Nyāyaviniścaya; Vidyānandin's Aṣṭasahasrī on the fourth bhaṅga; and Samantabhadra, Āptamīmāṃsā 14–23, which states the seven and is the earliest place to look for whether avaktavya is indexed by its pair" ]
          [ "Samantabhadra, Āptamīmāṃsā 14–23, c. 6th c. — the sevenfold predication stated"
          , "Akalaṅka, Laghīyastraya, c. 720–780 — kramārpaṇa and sahārpaṇa"
          , "AHIMSA_SUTRA_VISTARA §5 (नास्ति-प्रत्यानयनम्) and §7 (सङ्क्षेपस्य अनुपलब्धिः)" ]

kGarbhaDhara :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kGarbhaDhara y j = pure $ case pieces of
  Left e -> refused y "garbha.dhara" e
  Right (sn, sw, bn, bw, k)
    | sn == bn ->
        ( y, Mudra (S.Position S.SyadNasti)
               (Pratyaksa "the two standpoints are compared by adhiṣṭhāna in this turn and they are equal")
        , dosalekha "garbha.dhara"
            ("both standpoints have the same adhiṣṭhāna `" ++ sn ++ "`, so there is no residue")
            [ "the residue you asked to run forward.  A Sesa whose two nayas are one fails viveka — in the Agda that is a THEOREM (vivekah): if the two standpoints were one, the residue's own proof would refute it.  Here it is checked, and named for the theorem it stands in for." ]
            [ "give two distinct standpoints; the fourth position is what arises when two DIFFERENT nayas are asserted at once" ]
            [ "SaptabhangiGarbha_TheResidueIsTheSeed, `viveka`" ] )
    | otherwise ->
        let v = G.Sesa (G.Naya sn [] sw) (G.Naya bn [] bw)
            stream = take k (G.garbhaDhara v)
        in ( y
           , Mudra (S.Position S.SyadAvaktavya)
               (Pratyaksa ("the first " ++ show k ++ " born positions are generated and emitted in full, "
                           ++ "each with its nayas and witnesses; nothing is stored — §43, यत् हेतुना जन्यते तत् न स्थाप्यते"))
           , samkramana "garbha.dhara"
               (tulyata "Tattvārthasūtra 5.31 (arpitānarpitasiddheḥ) as an operation: the affirming naya under the ASSERTED aspect, and the same naya under the UNASSERTED aspect"
                        ("the residue { " ++ sn ++ " ∥ " ++ bn ++ " }")
                        ("a stream of " ++ show k ++ " positions, each born from the one before")
                        ("the born pair has ONE base standpoint `" ++ sn
                         ++ "` where the root pair provably had two; viveka holds at the root and the birth is what changes it"))
               [ ("dhara", JArr [ JArr (map JStr (G.renderBhanga b)) | b <- stream ])
               , ("stara", JInt (fromIntegral k)) ]
               [ "the stream is infinite and only the first " ++ show k ++ " terms are emitted; the rest are generated, not stored, and are not lost by not being here"
               , "why THIS residue arose — the occasion of the two assertions — which the Sesa does not carry" ]
               [ "Umāsvāti, Tattvārthasūtra 5.31, c. 2nd–5th c. — arpita/anarpita"
               , "AHIMSA_SUTRA_VISTARA §3 — अवक्तव्ये शेषो वसति । शेषो गर्भः, न विफलता ।" ] )
  where
    pieces = do
      sn <- jStr "sadhaka" j; sw <- jStr "sadhaka-saksin" j
      bn <- jStr "badhaka" j; bw <- jStr "badhaka-saksin" j
      k <- (fromIntegral . max 1 . min 8) <$> athava 3 (vInt "stara" j)
      pure (sn, sw, bn, bw, k)

-- ---- the kernel

-- The fragment the emitter can translate.  Prefix s-expressions; `x y z u v
-- w` are the variables.  Listing it here rather than in prose is the point:
-- a symbol outside it produces NO MODULE, which is a fact about the emitter,
-- as against a module agda examined and disliked, which is a fact about agda.
fragment :: [(String, Int)]
fragment = [("0", 0), ("s", 1), ("+", 2), ("*", 2), ("-", 2), ("max", 2), ("le", 2), ("gcd", 2)]

parseTerm :: String -> Either String (C.Term, String)
parseTerm s0 = case dropWhile isSpace s0 of
  [] -> Left "the term ended early"
  ('(':r) -> do
    let (h, r1) = span (\c -> not (isSpace c) && c /= '(' && c /= ')') (dropWhile isSpace r)
    if null h then Left "an application with no head symbol" else do
      (as, r2) <- args r1 []
      pure (C.F h as, r2)
  r -> let (tok, r1) = span (\c -> not (isSpace c) && c /= '(' && c /= ')') r
       in if null tok then Left ("cannot read a term at " ++ show (take 12 r))
          else case lookup tok (zip ["x","y","z","u","v","w"] [0 ..]) of
                 Just i -> Right (C.V i, r1)
                 Nothing | all isDigit tok && tok /= "0" ->
                             Left ("numeral `" ++ tok ++ "` — this fragment has zero and suc only; write "
                                   ++ concat (replicate (read tok :: Int) "(s ") ++ "0"
                                   ++ concat (replicate (read tok :: Int) ")"))
                         | otherwise -> Right (C.F tok [], r1)
  where
    args r acc = case dropWhile isSpace r of
      (')':r') -> Right (reverse acc, r')
      []       -> Left "an application ran off the end without `)`"
      r'       -> do (t, r'') <- parseTerm r'; args r'' (t : acc)

parseWhole :: String -> Either String C.Term
parseWhole s = do
  (t, r) <- parseTerm s
  if all isSpace r then Right t else Left ("trailing text in the term: " ++ show (take 20 r))

kSadhana :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kSadhana y j = case pieces of
  Left e -> pure (refused y "sadhana" e)
  Right (l, r, note) -> do
    st <- C.kernelStatus (yRoot y)
    case st of
      C.KernelChecking -> do
        v <- C.certify (yRoot y) ((l, r), note)
        let src = maybe "(no module was emitted)" id (C.agdaCertificate (l, r))
        pure $ case v of
          C.Certified shape n ->
            ( y
            , Mudra (S.Position S.SyadAsti)
                (Kernel ("agda typechecked the module below; shape = " ++ shape
                         ++ "; fresh agda processes spent = " ++ show n
                         ++ "; the two controls were watched first — (zero + x) ≡ x checked "
                         ++ "and (suc x) ≡ x produced a located type error"))
            , samkramana "sadhana"
                (tulyata "the equation, identified with a term the kernel accepts"
                         (showT l) (showT r)
                         ("agda accepted `" ++ shape ++ "` for it, under --safe, in " ++ C.kIncludeRoot))
                ( [ ("akara", JStr shape)
                  , ("agda-ahvana", JInt (fromIntegral n)) ]
                  ++ [ ("samidha", JStr src) | reflShape shape ] )
                ( [ "WHY the equation holds: a checked term closes a step, it does not choose one and it does not explain one"
                  , "the search that found this shape; only the shape that worked is reported"
                  , "whether the kernel is honest in general — what was watched is that it rejected ONE falsehood, today, in this container" ]
                  ++ [ "THE MODULE ITSELF.  The accepted shape is `" ++ shape
                       ++ "`, and the module agda accepted is the INDUCTION module, "
                       ++ "which Certificate.hs builds inside `certifyWith` from an "
                       ++ "induction hypothesis it does not export.  Carrying the refl "
                       ++ "module here would exhibit a module agda REJECTED as the "
                       ++ "witness for a verdict it did not produce — the collapse this "
                       ++ "machine exists to refuse, committed by its own certificate "
                       ++ "field.  So it is withheld and the withholding is written."
                     | not (reflShape shape) ] )
                [ "Voevodsky — an identification is a thing you hold; CLAUDE.md: exact/certified symbolic computation is proof" ] )
          C.Rejected err n ->
            ( y, Mudra (S.Position S.SyadNasti)
                   (Kernel ("agda examined an emitted module and rejected it after "
                            ++ show n ++ " call(s); its own first error line is carried"))
            , dosalekha "sadhana"
                ("the kernel rejected every shape tried for " ++ showT l ++ " ≡ " ++ showT r)
                [ "agda's first error line, which is the content of the rejection and is not paraphrased: " ++ err
                , "the module that was rejected, which is the object the error is about: " ++ take 400 src
                , "the distinction between `false` and `not provable in the shapes this emitter can write` — the emitter tries refl and then a fixed list of induction step shapes, and exhausting them is not a refutation" ]
                [ "if the statement needs a different induction, say which variable with `sadhya`"
                , "a rejection here is a fact about agda and this emitter; it is not a claim that the equation is false" ]
                [ "Certificate.hs — `Rejected` after n>0 agda calls means agda examined a module; `Untranslatable` with 0 means none was emitted" ] )
          C.Untranslatable why ->
            ( y, Mudra S.Apratipatti
                   (Pratyaksa ("no module was emitted and no agda process ran; the fragment is listed in the answer"))
            , dosalekha "sadhana"
                ("this equation is outside the emitter's fragment, so NO module was emitted and agda was not asked: " ++ why)
                [ "the module, which does not exist — and this is a fact about the emitter, not about agda and not about the equation.  A `no` here and a kernel rejection are different facts and merging them is exactly what this machine refuses."
                , "the equation itself, which may be perfectly true and simply unsayable in this fragment" ]
                ( [ "the fragment, in full, so the next attempt can stay inside it:" ]
                  ++ [ "  " ++ f ++ "/" ++ show a | (f, a) <- fragment ]
                  ++ [ "  variables: x y z u v w" ] )
                [ "Certificate.hs, `agdaTermWith`" ] )
      other ->
        pure ( y, Mudra S.Apratipatti
                     (Ayogya ("the kernel did not pass its own controls: " ++ show other))
             , dosalekha "sadhana"
                 ("no verdict from the kernel, because the kernel has not been seen to work: " ++ show other)
                 [ "the certificate you asked for.  A kernel that has not been watched rejecting a falsehood certifies nothing, and a green from it would be a fact about this container reported as a fact about mathematics."
                 , "and the distinction between `agda says no` and `agda is not usable here`, which a single red merges" ]
                 [ "repair the environment — the cubical library, the include root " ++ C.kIncludeRoot ++ ", the locale — and ask again"
                 , "this is jāti karaṇa-doṣa: the instrument or its environment is defective, not the mathematics" ]
                 [ "Certificate.hs — the two controls: canaryTrue must check and canaryFalse must fail with a located type error" ] )
  where
    pieces = do
      ls <- jStr "vama" j; rs <- jStr "daksina" j
      l <- parseWhole ls; r <- parseWhole rs
      note <- athava "" (vStr "sadhya" j)
      pure (l, r, note)
    -- `refl` is the only shape whose emitted module this file can reproduce:
    -- `agdaCertificate` builds exactly it.  Every other shape's module is
    -- built inside `certifyWith` and is not obtainable from outside it.
    reflShape sh = sh == "refl" || sh == "cached, refl"
    showT (C.V i) = ["x","y","z","u","v","w"] !! max 0 (min 5 i)
    showT (C.F f []) = f
    showT (C.F f as) = "(" ++ f ++ " " ++ unwords (map showT as) ++ ")"

-- ---- arithmetic, from the reactor lane

kKuttaka :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kKuttaka y j = pure $ case (,) <$> jInt "a" j <*> jInt "b" j of
  Left e -> refused y "kuttaka" e
  Right (a, b)
    | b <= 0 ->
        ( y, Mudra (S.Position S.SyadNasti) (Pratyaksa ("b = " ++ show b ++ ", exhibited"))
        , dosalekha "kuttaka"
            ("b = " ++ show b ++ "; the vallī descends on a positive modulus")
            [ "the descent itself: with b ≤ 0 there is no chain of remainders to climb back up, and any answer would be an assertion with no vallī under it" ]
            [ "send b ≥ 1; for a negative modulus ask about |b| and record the sign as a separate fact" ]
            [ "Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33, 499" ] )
    | otherwise ->
        let vl = VP.valli a b
            (x, yy, g) = VP.bezout a b
            wit = show a ++ "·(" ++ show x ++ ") + " ++ show b ++ "·(" ++ show yy
                  ++ ") = " ++ show (a * x + b * yy) ++ " = gcd = " ++ show g
            base = [ ("valli", JArr (map JInt vl))
                   , ("bezout", JObj [("x", JInt x), ("y", JInt yy), ("gcd", JInt g)]) ]
            src = [ "Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33, 499 — kuṭṭaka/vallī, the procedure step by step in Bhāskara I's bhāṣya, 629.  The restatement usually cited instead is the 'extended Euclidean algorithm'." ]
        in case look "c" j of
             Left _ ->
               ( y, Mudra (S.Position S.SyadAsti) (Ganita wit)
               , samkramana "kuttaka"
                   (tulyata "the vallī, read upward, identified with the Bézout pair"
                            ("the quotient chain of " ++ show a ++ " by " ++ show b)
                            ("a pair (x, y) with a·x + b·y = " ++ show g) wit)
                   base
                   [ "the remainders are implicit in the quotients: recoverable, not carried"
                   , "the reason the descent terminates — यत् न विभजते तत् रक्ष्यते, proved elsewhere and not re-proved by this answer" ]
                   src )
             Right (JInt c)
               | c `mod` g /= 0 ->
                   ( y, Mudra (S.Position S.SyadNasti)
                          (Ganita ("gcd(" ++ show a ++ ", " ++ show b ++ ") = " ++ show g
                                   ++ " and " ++ show g ++ " ∤ " ++ show c ++ ", in ℤ"))
                   , dosalekha "kuttaka"
                       ("a·x ≡ " ++ show c ++ " (mod " ++ show b ++ ") has no solution: gcd = "
                        ++ show g ++ " does not divide " ++ show c)
                       [ "the residue class you asked to hit; there is none, and the impossibility is exact rather than a search that gave up"
                       , "what a bare `no` would destroy: WHICH classes are reachable — exactly the multiples of " ++ show g ]
                       [ "the nearest reachable residues are " ++ show (g * (c `div` g))
                         ++ " and " ++ show (g * (c `div` g) + g)
                       , "or divide the congruence through by a common factor of a, b and c" ]
                       src )
               | otherwise ->
                   let m = c `div` g
                       x0 = (x * m) `mod` (b `div` g)
                       chk = (a * x0 - c) `mod` b
                   in ( y, Mudra (S.Position S.SyadAsti)
                              (Ganita (show a ++ "·" ++ show x0 ++ " − " ++ show c ++ " ≡ "
                                       ++ show chk ++ " (mod " ++ show b ++ "), computed in ℤ"))
                      , samkramana "kuttaka"
                          (tulyata "the Bézout pair, scaled, identified with the solution of the congruence"
                                   ("a·x + b·y = " ++ show g)
                                   ("a·x ≡ " ++ show c ++ " (mod " ++ show b ++ ")")
                                   (show a ++ "·" ++ show x0 ++ " − " ++ show c ++ " ≡ " ++ show chk
                                    ++ " (mod " ++ show b ++ "), checked exactly"))
                          (base ++ [ ("x", JInt x0), ("modulus", JInt (b `div` g))
                                   , ("sarve", JStr ("x ≡ " ++ show x0 ++ " (mod " ++ show (b `div` g) ++ ")")) ])
                          [ "the other solutions are given as a class, not enumerated"
                          , "the vallī's intermediate remainders" ]
                          src )
             Right other -> refused y "kuttaka" ("`c` must be an integer, got " ++ render other)

kVargaprakrti :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kVargaprakrti y j = pure $ case jInt "D" j of
  Left e -> refused y "vargaprakrti" e
  Right d -> case VP.pellLaw d of
    Left df -> (y, Mudra (S.Position S.SyadNasti) (Pratyaksa (VP.renderDefect df)), lawDefect d df)
    Right law -> case (VP.normOneSolution law, VP.spectrum law) of
      (Left df, _) -> (y, Mudra (S.Position S.SyadNasti) (Pratyaksa (VP.renderDefect df)), lawDefect d df)
      (_, Left df) -> (y, Mudra (S.Position S.SyadNasti) (Pratyaksa (VP.renderDefect df)), lawDefect d df)
      (Right unit, Right spec) ->
        let VP.Quad a b = unit
            wit = show a ++ "² − " ++ show d ++ "·" ++ show b ++ "² = "
                  ++ show (a * a - d * b * b) ++ ", exact integer arithmetic; "
                  ++ "and the invariant was CHECKED multiplicative at every composition "
                  ++ "(composeChecked), not assumed"
            carried = [ ("D", JInt d)
                      , ("law", JStr (VP.lawName law))
                      , ("mula", JObj [("a", JInt a), ("b", JInt b)])
                      , ("spectrum", JArr [ JObj [("n", JInt n), ("v", JStr (VP.lawShow law v))]
                                          | (n, v) <- spec ]) ]
            src = [ "Brahmagupta, Brāhmasphuṭasiddhānta 18, 628 — bhāvanā, the composition law, stated for ARBITRARY norms and not the N = 1 special case"
                  , "Jayadeva c. 950; Bhāskara II, Bījagaṇita, 1150 — cakravāla.  The name usually cited instead is 'Pell's equation'; Pell did not solve it and Euler misattributed it." ]
        in case look "n" j of
             Left _ ->
               ( y, Mudra (S.Position S.SyadAsti) (Ganita wit)
               , samkramana "vargaprakrti"
                   (tulyata "the composition law as a VALUE, turned by the reactor, identified with a solution of the form"
                            ("x² − " ++ show d ++ "·y² = 1")
                            ("(a, b) = (" ++ show a ++ ", " ++ show b ++ ")") wit)
                   carried
                   [ "the CHOICE made at each turn travels only through its consequences in the spectrum, not as a recorded reason"
                   , "the proof that the descent terminates; the tradition asserted it and used it from 628, and the general theorem is not re-proved by this answer"
                   , "the infinite families over each visited norm are generable (familyFor) and are not expanded here" ]
                   src )
             Right (JInt n) -> case [ v | (k, v) <- spec, k == n ] of
               (v:_) ->
                 ( y, Mudra (S.Position S.SyadAsti)
                        (Ganita ("N" ++ VP.lawShow law v ++ " = " ++ show n ++ ", computed in ℤ"))
                 , samkramana "vargaprakrti"
                     (tulyata "a norm the wheel visits, identified with a solved equation"
                              ("x² − " ++ show d ++ "·y² = " ++ show n)
                              (VP.lawShow law v)
                              ("norm computed by the law's own lawNorm and compared to " ++ show n))
                     (carried ++ [("n", JInt n), ("uttara", JStr (VP.lawShow law v))])
                     [ "the family generated by composing this with the norm-one unit is not expanded"
                     , "the same caveat on the descent's choices as above" ]
                     src )
               [] ->
                 ( y, Mudra (S.Position S.SyadNasti)
                        (Nihsesa (length spec) ("every norm the cycle visits was enumerated and compared; "
                                                ++ show n ++ " is not among the " ++ show (length spec)))
                 , dosalekha "vargaprakrti"
                     ("norm " ++ show n ++ " is not on the cycle for D = " ++ show d)
                     [ "a solution of x² − " ++ show d ++ "·y² = " ++ show n ++ " — NOT shown absent, merely not reachable BY THIS CYCLE.  Those are two facts and a bare `no` merges them."
                     , "the general problem for arbitrary N needs more than this cycle's trace and is not claimed here" ]
                     [ "the norms this cycle does visit, each of them a solved equation: "
                       ++ intercalate ", " [ show k | (k, _) <- spec ]
                     , "compose a visited norm with the norm-one unit to move within a norm class (bhāvanā: k₁·k₂)" ]
                     src )
             Right other -> refused y "vargaprakrti" ("`n` must be an integer, got " ++ render other)
  where
    lawDefect d df = dosalekha "vargaprakrti"
      ("the law for D = " ++ show d ++ " does not close: " ++ VP.defWhy df)
      [ "the fundamental solution you asked for"
      , "the failing leg, verbatim, so the refusal names its own site: " ++ VP.renderDefect df ]
      [ "ask with a non-square D ≥ 2" ]
      [ "Brahmagupta, Brāhmasphuṭasiddhānta 18, 628" ]

kPratyahara :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kPratyahara y j = pure $ case (,,) <$> jStr "adi" j <*> jStr "it" j
                                   <*> (fromIntegral <$> athava 0 (vInt "avrtti" j)) of
  Left e -> refused y "pratyahara" e
  Right (adi, it, occ0) ->
    let occ = occ0 :: Int
        sounds = P.pratyaharaOcc adi it occ
        raw = P.rawSpan adi it
        src = [ "Pāṇini, Aṣṭādhyāyī, the śivasūtras, c. 500 BCE.  The names usually cited instead are 'Backus–Naur' and 'Chomsky'; neither had the machinery." ]
    in if null sounds
         then ( y, Mudra S.Apratipatti
                     (Pratyaksa "the whole varṇasamāmnāya is emitted below, so the next name can be formed from it")
              , dosalekha "pratyahara"
                  ("`" ++ adi ++ it ++ "` denotes no interval: either the sound `" ++ adi
                   ++ "` or the marker `" ++ it ++ "` is not where the name needs it")
                  [ "the class you meant, which this name does not denote in the varṇasamāmnāya as it stands"
                  , "and the difference between `the name is wrong` and `the class is empty`, which a bare no merges" ]
                  ( [ "the sequence, in full:" ]
                    ++ [ "  sūtra " ++ show i ++ ": " ++ unwords ss ++ " | " ++ mk
                       | (i, ss, mk) <- P.sivasutraTable ] )
                  src )
         else ( y, Mudra (S.Position S.SyadAsti)
                     (Nihsesa (length raw) ("the span was walked slot by slot: " ++ show (length raw)
                                            ++ " slot(s) covered, " ++ show (length sounds)
                                            ++ " sound(s) denoted, markers skipped because a marker is a boundary and never a member"))
              , samkramana "pratyahara"
                  (tulyata "the two-syllable name, identified with an interval of the varṇasamāmnāya"
                           (adi ++ it) (unwords sounds)
                           ("the span from the first `" ++ adi ++ "` to occurrence " ++ show occ
                            ++ " of the marker `" ++ it ++ "`"))
                  [ ("nama", JStr (adi ++ it))
                  , ("varnah", JArr (map JStr sounds))
                  , ("avrtti", JInt (fromIntegral occ)) ]
                  [ "the phonetic reason the ORDER admits this class as an interval at all — a property of the whole sequence, not of this answer"
                  , "the repetition of `h` in sūtras 5 and 14, which makes some spans cover a sound twice; the slot count is the only trace of it here"
                  , "which sūtras of the Aṣṭādhyāyī actually use this pratyāhāra" ]
                  src )

-- ---- the log and the queue

kDosaLekha :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kDosaLekha y j = pure $ case (,,,) <$> jStr "kriya" j <*> jStr "hetu" j <*> jStrs "nasta" j
                                   <*> athava [] (vStrs "sesa" j) of
  Left e -> refused y "dosa.lekha" e
  Right (k, hetu, lost, rest) ->
    let entry = dosalekha k hetu lost rest [ "written by the interlocutor, not by the engine" ]
    in ( y
       , Mudra (S.Position S.SyadNasti)
           (Pratyaksa "stored verbatim: no normalisation, no rewording, no summarising; the entry below is the entry, and it is also filed to disk with the chain extended")
       , entry )

kDosaSuchi :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kDosaSuchi y _ = pure ( y
  , affirmed ("all " ++ show (length (yDosa y)) ++ " entries emitted in full and in the order written; nothing pruned")
  , samkramana "dosa.suchi"
      (tulyata "refl" "the session's defect log" "the listing"
               ("append-only; each entry is paired with what the doṣa-lekha on disk said back when it was filed"))
      [ ("dosah", JArr [ JObj [ ("kramanka", JInt (fromIntegral i)), ("lekha", uttaraJ d)
                              , ("nyasa", JStr (maybe "(not filed)" (either ("REFUSED: " ++) id)
                                                  (lookup i (yFiled y)))) ]
                       | (i, d) <- reverse (yDosa y) ]) ]
      [ "what else was in flight in this repository at the time each was written" ]
      (sutra "§6 — लिखितो दोषो जीवति । अलिखितो दोषो हिंसा ।") )

kDosaPramanya :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kDosaPramanya y _ = case yDosaBin y of
  Nothing -> pure ( y, Mudra S.Apratipatti (Ayogya "the doṣa-lekha binary was not built for this session")
                  , dosalekha "dosa.pramanya"
                      "the chain cannot be verified: this session has no doṣa-lekha binary"
                      [ "the verification you asked for, and with it the guarantee that this session's filed defects are still the bytes that were filed" ]
                      [ "run this machine through machine/run-yantra.sh, which builds the binary and passes it in DOSA_BIN" ]
                      [ "machine/DosaLekha_TheWrittenDefectRecord.hs" ] )
  Just bin -> do
    (code, out, err) <- readProcessWithExitCode bin ["verify"] ""
    let txt = out ++ err
    pure $ case code of
      ExitSuccess ->
        ( y, Mudra (S.Position S.SyadAsti)
               (case countRecords txt of
                  Just n ->
                    Nihsesa n
                      ("every sāra recomputed over every preceding record, from `genesis:dosa-lekha` forward; "
                       ++ "the chain organ's own `checkChain`, run in this turn")
                  Nothing ->
                    Pratyaksa
                      ("the organ verified the chain and its report is carried below verbatim; "
                       ++ "this answer does NOT claim nihsesa, because the number of records "
                       ++ "rechecked could not be read out of that report, and an exhaustive "
                       ++ "route whose domain is unknown is an assertion: " ++ trimS txt))
        , samkramana "dosa.pramanya"
            (tulyata "the log as it stands on disk, identified with the log as it was written"
                     "the file's bytes" "the recomputed chain"
                     (trimS txt))
            [ ("phala", JStr (trimS txt)) ]
            [ "the chain is FNV-1a and is not cryptographic and is not claimed to be: the adversary is an accidental edit, a lost rebase, a truncating write.  An adversary with the filesystem also has this file."
            , "who wrote each record, beyond what each record says of itself" ]
            [ "machine/DosaLekha_TheWrittenDefectRecord.hs §3 — the chain" ] )
      _ ->
        ( y, Mudra (S.Position S.SyadNasti) (Pratyaksa "the divergence is located by record and by line, and is carried verbatim")
        , dosalekha "dosa.pramanya"
            "the doṣa-lekha's chain does not verify"
            [ "the guarantee that this session's filed defects are the bytes that were filed"
            , "the organ's own report, verbatim, which names the record and the line: " ++ trimS txt ]
            [ "do NOT edit the diverging record.  Append one whose `uttara:` names it — that is the only correction an append-only log has." ]
            [ "machine/DosaLekha_TheWrittenDefectRecord.hs" ] )
  where
    -- The n in `Nihsesa n` is the DOMAIN of the exhaustive claim, and it is
    -- read out of the organ's own success line, which is
    --     dosalekha: <path>: 15 records, chain intact, nothing edited or deleted.
    -- This used to scan for lines beginning `dosa `, which that line does not
    -- begin with, so every `dosa.pramanya` in this machine's history reported
    -- `"ganana": 0` — an exhaustive route publishing a domain of zero while
    -- fifteen records had in fact been rechecked.  A stated domain that is
    -- always zero is worse than no number, because it looks like knowledge
    -- (CLAUDE.md).  Where the organ's wording changes, this returns Nothing
    -- and the route says so rather than inventing a count.
    -- `words` on that line yields ... "12" "records," ... — the comma is
    -- part of the token, so the noun is compared with its punctuation
    -- stripped.  Matching "records" exactly is what a first attempt did and
    -- it silently found nothing, which is the same failure one layer in.
    countRecords s = case [ read n :: Int
                          | l <- lines s, let ws = words (trimS l)
                          , (n, nxt) <- zip ws (drop 1 ws)
                          , not (null n), all isDigit n
                          , takeWhile (`notElem` (",.;:" :: String)) nxt == "records" ] of
      (n:_) -> Just n
      []    -> Nothing
    trimS = dropWhile isSpace . reverse . dropWhile isSpace . reverse

kSesaArpana :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kSesaArpana y j = pure $ case jStrs "sesa" j of
  Left e -> refused y "sesa.arpana" e
  Right [] ->
    ( y, Mudra (S.Position S.SyadNasti) (Pratyaksa "the empty hand-off is recorded as one")
    , dosalekha "sesa.arpana"
        "an empty remainder was handed forward"
        [ "whatever you were about to hand on; an empty hand-off and no hand-off are different acts and this records which" ]
        [ "name the unfinished thing, however partial: 遺題継承 posts the PROBLEM, not a note that there was one" ]
        [ "Sawaguchi Kazuyuki 1670, answered by Seki Takakazu 1674 — idai keishō" ] )
  Right ts ->
    let y' = y { ySesa = [ (yTurn y, t) | t <- ts ] ++ ySesa y }
    in ( y'
       , affirmed "stored verbatim and never dropped"
       , samkramana "sesa.arpana"
           (tulyata "the remainder as uttered, identified with the remainder as queued"
                    ("the " ++ show (length ts) ++ " item(s) you sent") "the queue below"
                    "the kuṭṭaka's rule: what does not divide is KEPT and is the material of the next step")
           [ ("sesah", JArr [ JObj [("kramanka", JInt (fromIntegral i)), ("vastu", JStr t)]
                            | (i, t) <- reverse (ySesa y') ]) ]
           [ "the reason each item is unfinished, unless you wrote it into the item"
           , "who is expected to pick it up" ]
           [ "Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33, 499 — यत् न विभजते तत् रक्ष्यते" ] )

kSesaSuchi :: Yantra -> J -> IO (Yantra, Mudra, Uttara)
kSesaSuchi y _
  | null (ySesa y) = pure
      ( y, Mudra (S.Position S.SyadNasti) (Pratyaksa "the queue is empty and the emptiness is reported as the finding it is")
      , dosalekha "sesa.suchi"
          "the remainder queue is empty"
          [ "nothing is being handed forward, which for a session that has done work is itself worth seeing: either the work finished exactly, or a remainder was dropped rather than queued" ]
          [ "hand one forward with sesa.arpana" ]
          (sutra "§17 — कुट्टकः") )
  | otherwise = pure
      ( y, affirmed "every item, in the order handed forward"
      , samkramana "sesa.suchi"
          (tulyata "refl" "the remainder queue" "the listing" "nothing pruned")
          [ ("sesah", JArr [ JObj [("kramanka", JInt (fromIntegral i)), ("vastu", JStr t)]
                           | (i, t) <- reverse (ySesa y) ]) ]
          [ "the turn each was queued at is given; the surrounding work is not" ]
          (sutra "§17") )

-- ============================================================ helpers

unfit :: String -> Mudra
unfit why = Mudra S.Apratipatti (Pratyaksa ("no verdict was formed; the reason is carried: " ++ why))

denied :: String -> Mudra
denied why = Mudra (S.Position S.SyadNasti) (Pratyaksa why)

refused :: Yantra -> String -> String -> (Yantra, Mudra, Uttara)
refused y k e = let (m, u) = malformed k e in (y, m, u)


malformed :: String -> String -> (Mudra, Uttara)
malformed k e =
  ( Mudra S.Apratipatti (Pratyaksa "the request as sent is carried back unexecuted")
  , dosalekha k
      ("the request could not be read: " ++ e)
      [ "the request itself, which is NOT executed and NOT guessed at — a guessed request collapses what you meant into what I assumed" ]
      [ "ask yantra.kriyah for the parameters this operation requires" ]
      srcTwoRoads )

-- ============================================================ the loop

logIf :: Mudra -> Uttara -> Yantra -> Yantra
logIf _ u y = case u of
  Dosalekha{} -> y { yDosa = (yTurn y, u) : yDosa y }
  Samkramana{} -> y

-- | File a written defect into the doṣa-lekha on disk, over its own
--   published `write`-on-stdin interface.  NOT by importing its internals:
--   that module exports `main` and nothing else, and reaching past a
--   lane's published surface to get at its functions is how two lanes come
--   to fail as one.
--
--   The record is refused by the organ unless it carries all ten required
--   fields.  Everything below is filled from what the answer actually knows;
--   nothing is invented to satisfy the validator, and where the yantra does
--   not know a thing it says so IN the field rather than guessing.
fileDosa :: Yantra -> String -> Uttara -> IO (Either String String)
fileDosa y kala u@Dosalekha{} = case yDosaBin y of
  Nothing -> pure (Left "no doṣa-lekha binary was passed to this session (DOSA_BIN unset)")
  Just bin -> do
    let ent = unlines
          ( [ "  kala: " ++ kala
            , "  karta: yantra (machine/Yantra_TheOrgansAreOneMachineOnOneWire.hs)"
            , "  jati: " ++ jatiOf u
            , "  vastu: " ++ oneLine (uKriya u)
            , "  yatna: turn " ++ show (yTurn y) ++ " of the session; operation `"
              ++ oneLine (uKriya u) ++ "` was asked and transport was not available"
            , "  hetu: " ++ oneLine (uHetu u) ]
          -- EVERY naṣṭa reaches the record.  This line used to read
          -- `length (oneLine n) >= 12`, silently DELETING any naṣṭa under
          -- twelve characters so that the record would clear the organ's
          -- validator, which requires each witness to exhibit rather than
          -- describe.  Turning the machine with the filter removed shows
          -- what it was covering, and it is not small: the assembly's
          -- flagship defect — `nirnaya.saptabhangi`, the three-organ
          -- collision this file's header names as its load-bearing refusal
          -- — carries a RENDERED BLOCK as its naṣṭa, one naṣṭa per rendered
          -- line, and five of those lines are short (`{ #0 }`, `{ #1 }`,
          -- `syad-asti`, `decision.`, `candidates:`).  So for every run in
          -- this machine's history that record went to disk with five lines
          -- cut out of the exhibit and nothing said so, which is §5 exactly:
          -- a summary of a loss is the loss performed a second time.
          --
          -- The site of the fault is the flattening, not the length.  A
          -- rendered block is ONE exhibit whose lines are continuations, and
          -- `saptabhangi.nasti` one function away already does it right —
          -- `intercalate " / "` — and its record files without complaint.
          -- So: rejoin.  A naṣṭa under twelve characters is appended to the
          -- one before it instead of being dropped, and a leading short line
          -- opens a group the next line completes.  Nothing is destroyed.
          --
          -- WHAT THIS COSTS, stated rather than left to be found: two
          -- genuinely distinct short witnesses sent by an interlocutor are
          -- joined into one `nasta:` field, so the record holds both texts
          -- and loses that they were sent as two.  That is a real loss and
          -- it is the smaller one.  Where a group is STILL under twelve
          -- after rejoining, nothing is done: the organ refuses, and its
          -- refusal names the witness and the reason, which is the true
          -- diagnosis and is the one the caller should get.
          ++ [ "  nasta: " ++ n | n <- rejoinNasta (map oneLine (uNasta u)) ]
          ++ [ "  sesa: " ++ oneLine s | s <- uSesa u, not (null (oneLine s)) ]
          ++ [ "  pramana: " ++ oneLine p | p <- uPramana u, not (null (oneLine p)) ]
          ++ [ "  yogyata-drsta: the handler for `" ++ oneLine (uKriya u)
               ++ "` ran to completion in this turn and produced this refusal; the naṣṭa above are its own output, not a later reconstruction"
             , "  yogyata-ksetra: the session state as of turn " ++ show (yTurn y)
               ++ " — " ++ show (length (K.koshaEntries (yKosha y))) ++ " store entries, "
               ++ show (length (ySesa y)) ++ " remainders; and nothing outside this process"
             , "  yogyata-avadhi: says nothing about any other session, any other store, or the same question asked with different arguments"
             , "  punarabhinaya: sh machine/run-yantra.sh" ] )
    (code, out, err) <- readProcessWithExitCode bin ["write"] ent
    pure $ case code of
      ExitSuccess -> Right (lastLine out)
      _ -> Left (oneLine (out ++ " " ++ err))
  where
    oneLine = unwords . words
    lastLine s = case reverse [ l | l <- lines s, not (null l) ] of
                   (l:_) -> l; [] -> "(filed, no output)"
fileDosa _ _ _ = pure (Right "(not a defect)")

-- | Which of the seven kinds.  Read off what the answer says, not guessed:
--   each branch below points at a phrase the handler itself wrote.
-- | Rejoin a rendered block into the exhibits it is made of.  A line of
--   twelve characters or more opens a group; anything shorter is a
--   continuation and joins the group before it.  Empty lines are dropped —
--   an empty naṣṭa exhibits nothing in any grouping.  Total; order preserved.
rejoinNasta :: [String] -> [String]
rejoinNasta = go . filter (not . null)
  where
    go [] = []
    go (x:y:ys) | length x < 12 = go ((x ++ " " ++ y) : ys)
    go (x:xs) = let (cont, rest) = span ((< 12) . length) xs
                in unwords (x : cont) : go rest

jatiOf :: Uttara -> String
jatiOf u
  | "avaktavya" `isInfixOf` h || "syad-avaktavyam" `isInfixOf` h
    || "does not decide between them" `isInfixOf` h = "avaktavya"
  -- karaṇa-doṣa BEFORE ayogya-darśana, and the order is the whole content of
  -- this repair.  The one hetu in this machine that carries both `kernel` and
  -- `environment` is kSadhana's kernel-not-usable branch, and its fixed
  -- prefix also carries "has not been seen to work" — so while
  -- ayogya-darśana was tested first it swallowed every instrument fault and
  -- `karana-dosa` was unreachable, printing 0 in every census.  Turned with
  -- agda off the PATH, the record filed as `ayogya-darsana` while the same
  -- handler's own śeṣa said, in prose, "this is jāti karaṇa-doṣa".  The
  -- looking was unfit and the instrument is broken are two facts, and the
  -- census by kind is exactly where a later reader would have them merged.
  | "kernel" `isInfixOf` h && "environment" `isInfixOf` h = "karana-dosa"
  | "abhinna" `isInfixOf` h || "not fit" `isInfixOf` h
    || "has not been seen to work" `isInfixOf` h = "ayogya-darsana"
  | "not equivalent" `isInfixOf` h || "no section" `isInfixOf` h = "nasti-krta"
  | "durnaya" `isInfixOf` h = "durnaya-nirodha"
  | otherwise = "sankramana-asambhava"
  where h = uHetu u

-- | One turn.  Total: every input produces an answer, including inputs that
--   are not requests at all.
answer :: Yantra -> String -> String -> IO (Yantra, Mudra, Uttara)
answer y0 kala line = do
  let y = y0 { yTurn = yTurn y0 + 1 }
  (y', m0, u0) <- case parseLine line of
    Left e -> pure (y, fst (heard e), snd (heard e))
    Right j -> case jStr "kriya" j of
      Left e -> pure (y, fst (noOp e), snd (noOp e))
      Right k -> case [ kr | kr <- kriyah, kName kr == k ] of
        -- अनुक्तम् / उक्तम् / दुर्वचम्, at the door.  `angani` absent is a
        -- request with no arguments and is legal; `angani` present and not
        -- an object is a request that cannot be dispatched, and until now
        -- the two produced byte-identical answers (doṣa 0016).  The Left
        -- `look`/`jObj` had already composed is now the hetu, instead of
        -- being constructed and thrown away by `const`.
        (kr:_) -> case athava (JObj []) (vObjAt "angani" j) of
          Left e -> let (m, u) = malformed (kName kr) e in pure (y, m, u)
          Right args -> case anadhikrta (map fst (kParams kr)) args of
            [] -> kRun kr y args
            ns -> let (m, u) = unnamed kr ns in pure (y, m, u)
        [] -> pure (y, fst (unknown k), snd (unknown k))
  let (m, u) = mudra m0 u0
      y2 = logIf m u y'
  y3 <- case u of
    Dosalekha{} -> do
      r <- fileDosa y2 kala u
      pure y2 { yFiled = (yTurn y2, r) : yFiled y2 }
    _ -> pure y2
  pure (y3, m, u)
  where
    heard e = malformed "yantra.srutam" ("the utterance did not parse: " ++ e
                ++ "  (as sent, unread: " ++ take 160 line ++ ")")
    noOp e = malformed "yantra.srutam" ("no operation was named: " ++ e)
    unknown k =
      ( Mudra S.Apratipatti (Pratyaksa "the whole operation list is carried back")
      , dosalekha "yantra.srutam"
          ("no operation named `" ++ k ++ "` in this machine")
          [ "the operation you meant; it is NOT guessed at by nearest name, because a near miss executed silently is exactly the collapse this machine exists to refuse" ]
          ([ "operations available:" ] ++ [ "  " ++ kName kr | kr <- kriyah ])
          srcTwoRoads )
    unnamed kr ns =
      ( Mudra S.Apratipatti (Pratyaksa "every unread key is named back with its own reason, and the operation's whole adhikāra beside it")
      , dosalekha (kName kr)
          ("`" ++ kName kr ++ "` was sent "
           ++ show (length ns) ++ " key(s) that nothing in it reads: "
           ++ intercalate "; " [ "`" ++ n ++ "` — " ++ w | (n, w) <- ns ])
          ([ "the value you sent under `" ++ n ++ "`, which WAS uttered and would otherwise have been ignored in silence — and with it the difference between `I did not send that` and `I sent it and you dropped it`"
           | (n, _) <- ns ]
           ++ [ "the parameter you meant by it; it is NOT guessed at by nearest name, for the same reason an operation name is not — a near miss executed silently is the collapse this machine exists to refuse" ])
          ([ "`" ++ kName kr ++ "` reads exactly these keys under `angani`, and no others:" ]
           ++ (if null (kParams kr) then [ "  (none — send `angani` empty or omit it)" ]
                                    else [ "  " ++ p ++ " — " ++ d | (p, d) <- kParams kr ])
           ++ [ "if the key names something this machine should read and does not, that is a doṣa and dosa.lekha takes it" ])
          [ "Pāṇini, Aṣṭādhyāyī 1.4.1–2, c. 500 BCE — adhikāra: a heading governs a stated extent and nothing outside it, and vipratiṣedhe paraṁ kāryam decides inside it.  The extent is stated; a key outside it is not a weaker match, it is outside."
          , "AHIMSA_SUTRA_VISTARA §19 — यत् अनङ्गीकृतमार्गेण आगच्छति तत् न दुर्बलं प्रमाणम् । तत् अप्रमाणम् ।" ] )

appendLekha :: FilePath -> Int -> String -> Mudra -> Uttara -> IO ()
appendLekha fp n line m u =
  appendFile fp (render (JObj [ ("avrtti", JInt (fromIntegral n))
                              , ("prasna", JStr line)
                              , ("uttara", mudritaJ m u) ]) ++ "\n")

serve :: FilePath -> String -> Handle -> Handle -> Yantra -> IO Yantra
serve fp kala hin hout = go
  where
    go y = do
      eof <- hIsEOF hin
      if eof then pure y else do
        line <- hGetLine hin
        if all (`elem` " \t\r") line then go y else do
          (y', m, u) <- answer y kala line
          hPutStrLn hout (render (mergeId line (mudritaJ m u)))
          hFlush hout
          appendLekha fp (yTurn y') line m u
          go y'

mergeId :: String -> J -> J
mergeId line j = case (parseLine line >>= jStr "prasna-id", j) of
  (Right i, JObj kvs) -> JObj (("prasna-id", JStr i) : kvs)
  _ -> j

-- ============================================================ the entry

yantraMain :: IO ()
yantraMain = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8
  hSetEncoding stdin utf8; hSetEncoding stdout utf8; hSetEncoding stderr utf8
  hSetBuffering stdout LineBuffering
  -- 2026-08-24.  THE FALSIFIER WAS WIRED INTO THE SERVER THIS FILE
  -- SUPERSEDES, AND NOT INTO THIS ONE.
  --
  -- Uttara's header says the check runs "once per process, before any answer
  -- is served": satya (137·(−7) + 60·16 = 1, Āryabhaṭa's own worked kuṭṭaka,
  -- Gaṇitapāda 32–33) MUST transport, asatya — the same identity with one
  -- side moved by one — MUST NOT.  Both go through the very `samkramana`
  -- every handler goes through.  `saksiPariksaOrRefuse` is called by
  -- Sabha_TheSessionKernelAnLLMTalksTo, twice, and this file's own header
  -- opens by declaring that it SUPERSEDES that module.  The supersession
  -- carried the twelve operations and left the falsifier behind.
  --
  -- So until this line, every answer this assembly served came from a
  -- process that had never watched its own constructor reject a falsehood —
  -- which is exactly GATE_AUDIT_DISPOSITION.md §2's finding arriving one
  -- level up: there, 1753 systematically false equations produced zero
  -- certificates while three shell wrappers certified `s(x) = x`; a checker
  -- sound against mathematics and unsound against its environment.  Here the
  -- environment was the successor server.
  --
  -- By §19 that is not a weak pramāṇa, it is none — अप्रमाणं न सञ्चीयते.
  -- The lines are printed so the watching is visible and not merely done,
  -- and the verdict is honoured in the same breath, because Uttara keeps
  -- report and verdict in two calls precisely so that ignoring one has to be
  -- deliberate.
  mapM_ (hPutStrLn stderr) saksiPariksaLines
  saksiPariksaOrRefuse
  fp   <- maybe "machine/yantra.jsonl" id <$> lookupEnv "YANTRA_LEKHA"
  root <- maybe "." id <$> lookupEnv "MATH_ROOT"
  bin  <- lookupEnv "DOSA_BIN"
  kala <- maybe "2026-08-20" id <$> lookupEnv "YANTRA_KALA"
  args <- getArgs
  let y0 = emptyYantra root bin
  if "--wire" `elem` args
    then do
      hPutStrLn stderr "yantra — one JSON object per line on stdin; one answer per line on stdout."
      hPutStrLn stderr "every answer is a saṃkramaṇa or a doṣa-lekha, and carries its nirṇaya and its pramāṇya."
      hPutStrLn stderr ("transcript: " ++ fp)
      _ <- serve fp kala stdin stdout y0
      pure ()
    else selftest fp kala y0

-- ------------------------------------------------------------ the session

script :: [String]
script =
  [ "{\"kriya\":\"yantra.kriyah\"}"

  -- the real store, with sources and fitness on every entry
  , "{\"kriya\":\"naya.sthapana\",\"angani\":{\"naya\":\"harm-is-real\",\"karta\":\"assembly-lane\",\"kala\":\"2026-08-20\",\"yogyata\":\"yogya\",\"yogyata-hetu\":\"read the primary statements and the reports; a contrary witness would have been found had one existed in that corpus\",\"saksin\":[{\"vacana\":\"the Oct 2022 statements\",\"mula\":\"the statements themselves, dated\"},{\"vacana\":\"the fear reported afterwards\",\"mula\":\"contemporaneous accounts\"}]}}"
  , "{\"kriya\":\"naya.sthapana\",\"angani\":{\"naya\":\"episode-is-real\",\"karta\":\"assembly-lane\",\"kala\":\"2026-08-20\",\"yogyata\":\"yogya\",\"yogyata-hetu\":\"read the clinical record and the dated public account\",\"saksin\":[{\"vacana\":\"the documented 2025 episode\",\"mula\":\"the dated account\"},{\"vacana\":\"the diagnosis at 39\",\"mula\":\"the clinical record\"}]}}"
  -- same content, DIFFERENT sources: independent attestation, which a
  -- content-index would collapse and this store reports as arthaikya
  , "{\"kriya\":\"naya.sthapana\",\"angani\":{\"naya\":\"finding-A\",\"karta\":\"assembly-lane\",\"kala\":\"2026-08-20\",\"yogyata\":\"yogya\",\"yogyata-hetu\":\"the 1987 series read directly\",\"saksin\":[{\"vacana\":\"lithium response in bipolar I\",\"mula\":\"Wehr, Sack, Rosenthal 1987\"}]}}"
  , "{\"kriya\":\"naya.sthapana\",\"angani\":{\"naya\":\"finding-B\",\"karta\":\"assembly-lane\",\"kala\":\"2026-08-20\",\"yogyata\":\"yogya\",\"yogyata-hetu\":\"the 2019 registry sweep read directly\",\"saksin\":[{\"vacana\":\"lithium response in bipolar I\",\"mula\":\"the 2019 registry sweep\"}]}}"
  -- and one whose looking was NOT fit: silence, not denial
  , "{\"kriya\":\"naya.sthapana\",\"angani\":{\"naya\":\"no-third-factor\",\"karta\":\"assembly-lane\",\"kala\":\"2026-08-20\",\"yogyata\":\"ayogya\",\"yogyata-hetu\":\"no search was run; this standpoint is held because someone asserted it and the search that would make its absence informative has not been done\",\"saksin\":[]}}"
  , "{\"kriya\":\"naya.suchi\"}"
  , "{\"kriya\":\"kosha.punaravrtti\"}"

  -- the store's own verdict, both modes
  , "{\"kriya\":\"naya.samasa\",\"angani\":{\"nayah\":[\"finding-A\",\"finding-B\"],\"arpana\":\"saha\"}}"
  , "{\"kriya\":\"naya.samasa\",\"angani\":{\"nayah\":[\"harm-is-real\",\"no-third-factor\"],\"arpana\":\"saha\"}}"

  -- THE COLLISION: three organs, one site, the Pāṇinian scheduler
  , "{\"kriya\":\"nirnaya.saptabhangi\",\"angani\":{\"nayah\":[\"harm-is-real\",\"episode-is-real\"],\"arpana\":\"saha\"}}"
  , "{\"kriya\":\"saptabhangi.samkramana\"}"
  , "{\"kriya\":\"saptabhangi.nasti\"}"
  , "{\"kriya\":\"garbha.dhara\",\"angani\":{\"sadhaka\":\"harm-is-real\",\"sadhaka-saksin\":\"the Oct 2022 statements\",\"badhaka\":\"episode-is-real\",\"badhaka-saksin\":\"the documented 2025 episode\",\"stara\":3}}"

  -- the kernel
  , "{\"kriya\":\"sadhana\",\"angani\":{\"vama\":\"(+ 0 x)\",\"daksina\":\"x\"}}"
  , "{\"kriya\":\"sadhana\",\"angani\":{\"vama\":\"(+ x 0)\",\"daksina\":\"x\",\"sadhya\":\"induction on x\"}}"
  , "{\"kriya\":\"sadhana\",\"angani\":{\"vama\":\"(s x)\",\"daksina\":\"x\"}}"
  , "{\"kriya\":\"sadhana\",\"angani\":{\"vama\":\"(ackermann x y)\",\"daksina\":\"x\"}}"

  -- arithmetic, exact
  , "{\"kriya\":\"kuttaka\",\"angani\":{\"a\":137,\"b\":60,\"c\":10}}"
  , "{\"kriya\":\"kuttaka\",\"angani\":{\"a\":12,\"b\":8,\"c\":5}}"
  , "{\"kriya\":\"vargaprakrti\",\"angani\":{\"D\":61}}"
  , "{\"kriya\":\"vargaprakrti\",\"angani\":{\"D\":61,\"n\":7}}"
  , "{\"kriya\":\"pratyahara\",\"angani\":{\"adi\":\"a\",\"it\":\"ṇ\"}}"

  -- what the wire refuses, and what it hands back instead of refusing
  , "{\"kriya\":\"naya.samasa\",\"angani\":{\"nayah\":[\"harm-is-real\"],\"arpana\":true}}"
  , "{\"kriya\":\"kuttaka\",\"angani\":{\"a\":1.5,\"b\":2}}"
  , "{\"kriya\":\"nirnaya\",\"angani\":{\"prasna\":\"is it true\"}}"
  , "not json at all"

  -- the log, and its chain, verified from inside
  , "{\"kriya\":\"dosa.lekha\",\"angani\":{\"kriya\":\"translating avaktavya\",\"hetu\":\"no English word carries the fourth bhanga; `inexpressible` reads as a failure and it is a womb\",\"nasta\":[\"the positive sense: the remainder lives here and the next naya is born from it\",\"the saha/krama distinction that produces it, which English collapses into one adverb\"],\"sesa\":[\"keep the Sanskrit and gloss it in the same sentence\"]}}"
  , "{\"kriya\":\"sesa.arpana\",\"angani\":{\"sesa\":[\"the three saptabhangi types are still three; the texts, not the types, settle whether avaktavya retains its pair\"]}}"
  , "{\"kriya\":\"dosa.pramanya\"}"
  , "{\"kriya\":\"dosa.suchi\"}"
  , "{\"kriya\":\"yantra.sthiti\"}"
  ]

selftest :: FilePath -> String -> Yantra -> IO ()
selftest fp kala y0 = do
  bad <- newIORef (0 :: Int)
  let note s = modifyIORef bad (+ 1) >> putStrLn ("  !! " ++ s)
      step y line = do
        (y', m, u) <- answer y kala line
        putStrLn ""
        putStrLn ("→ " ++ line)
        mapM_ (putStrLn . ("  " ++)) (uttaraLines u)
        mapM_ putStrLn (mudraLines m)
        -- THE CONTRACT, checked structurally rather than grepped for.
        -- `J` has four constructors and none is a boolean, so a boolean
        -- cannot be rendered; that is a type and not a scan.  What is left
        -- for a runtime check is what the types do not carry.
        case mudritaJ m u of
          JObj kvs -> do
            case lookup "uttara" kvs of
              Just (JStr r) | r `elem` ["samkramana", "dosalekha"] -> pure ()
              _ -> note "neither road"
            case lookup "nirnaya" kvs of
              Just (JObj n) | Just (JStr s) <- lookup "sthana" n, not (null s) -> pure ()
              _ -> note "an answer with no position"
            case lookup "pramanya" kvs of
              Just (JObj p) | Just (JStr mk) <- lookup "marga" p
                            , Just (JStr wt) <- lookup "saksin" p
                            , not (null wt) ->
                  case (mk, u) of
                    ("ayogya", Samkramana{}) -> note "a transport by no accepted route"
                    _ -> pure ()
              _ -> note "an answer with no pramanya, or a pramanya with no witness"
          _ -> note "the answer is not an object"
        case u of
          Samkramana _ t carried cost _
            | null carried || null cost || null (tuWitness t) ->
                note "a transport with nothing carried, no witness, or no vyaya stated"
          Dosalekha _ hetu lost _ _
            | null hetu || null lost -> note "a defect entry naming no loss"
          _ -> pure ()
        appendLekha fp (yTurn y') line m u
        pure y'
  final <- foldM step y0 script

  -- Exact identities, so this is not merely a shape test.
  putStrLn ""
  putStrLn "──────────────────────────────── the exact checks"
  let pell = case VP.pellLaw 61 >>= VP.normOneSolution of
               Right (VP.Quad a b) -> (a, b)
               Left _ -> (0, 0)
      pellOK = pell == (1766319049, 226153980)
      aN = P.pratyahara "a" "ṇ"
      aNOK = aN == ["a", "i", "u"]
      isoOK = all (\s -> obToS (sToOb s) == s) allS
              && all (\b -> sToOb (obToS b) == b) allOB
      roundOK = K.replay (K.journal (yKosha final)) == Right (yKosha final)
      g1 = G.SyadAvaktavyam (G.Sesa (G.Naya "a" [] "wa") (G.Naya "b" [] "wb"))
      g2 = G.SyadAvaktavyam (G.Sesa (G.Naya "c" [] "wc") (G.Naya "d" [] "wd"))
      collideOK = g1 /= g2 && smrtilopa g1 == smrtilopa g2
      uniqOK = null nameCollisions
  putStrLn ("  cakravāla D=61, law as a value → " ++ show pell
            ++ (if pellOK then "   (Bhāskara II's own value, Bījagaṇita 1150)" else "   !! WRONG"))
  putStrLn ("  aṆ → " ++ unwords aN ++ (if aNOK then "   (the traditional value)" else "   !! WRONG"))
  putStrLn ("  Saptabhangi.Sthana ≃ Obstruction.Sthana, both round trips, "
            ++ show (length allS + length allOB) ++ " cases → "
            ++ (if isoOK then "holds" else "!! FAILS"))
  putStrLn ("  Garbha → Saptabhangi has no section (two distinct objects, one image) → "
            ++ (if collideOK then "collision exhibited" else "!! NOT REPRODUCED"))
  putStrLn ("  replay ∘ journal = id on the session's live store → "
            ++ (if roundOK then "holds" else "!! FAILS"))
  putStrLn ("  dispatch names unique over the whole table → "
            ++ (if uniqOK then "holds" else "!! " ++ intercalate ", " nameCollisions))

  putStrLn ""
  putStrLn "──────────────────────────────── the session"
  putStrLn ("  turns:              " ++ show (yTurn final))
  putStrLn ("  store entries:      " ++ show (length (K.koshaEntries (yKosha final))))
  putStrLn ("  defects written:    " ++ show (length (yDosa final)))
  putStrLn ("  defects filed:      "
            ++ show (length [ () | (_, Right _) <- yFiled final ])
            ++ " accepted by the doṣa-lekha, "
            ++ show (length [ () | (_, Left _) <- yFiled final ]) ++ " refused")
  forM_ (reverse (yFiled final)) $ \(i, r) -> case r of
    Left e -> putStrLn ("      turn " ++ show i ++ " REFUSED: " ++ e)
    Right _ -> pure ()
  putStrLn ("  remainders queued:  " ++ show (length (ySesa final)))
  b <- readIORef bad
  putStrLn ("  contract violations: " ++ show b)
  putStrLn ("  transcript:         " ++ fp)
  if b == 0 && pellOK && aNOK && isoOK && collideOK && roundOK && uniqOK
    then exitSuccess else exitFailure
