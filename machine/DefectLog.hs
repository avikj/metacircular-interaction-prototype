-- DefectLog.hs
--
-- दोषलेखः — the written defect.  The machine's SECOND organ.
--
-- ─────────────────────────────────────────────────────────────────────
-- THE CONTRACT, quoted, because this file is one half of it.
--
--   notes/AHIMSA_SUTRA_VISTARA.md §६ · द्वौ मार्गौ
--
--       अयम् अहिंसा ।
--       अन्यो मार्गो दोषलेखः ।
--       यत्र संक्रमणं न सम्भवति तत्र दोषो लिख्यते ।
--       लिखितो दोषो जीवति । अलिखितो दोषो हिंसा ।
--       अयम् अपि अहिंसा ।
--       तृतीयो मार्गो न विद्यते ।
--
--   Transport (`transport (ua e)`) carries everything; that is the first
--   path.  Where no equivalence exists, transport is not available, and
--   the ONLY remaining non-violent act is to WRITE THE DEFECT.  A written
--   defect lives.  An unwritten defect is himsa.  There is no third path.
--
-- The first organ is checked in Agda: uaβ says transport loses nothing.
-- The second organ is this file: a log with a type, so that a refusal
-- is an OBJECT and not a silence.
--
-- ─────────────────────────────────────────────────────────────────────
-- WHY A SILENCE IS THE THING BEING PREVENTED, with the repository's own
-- measurement rather than an argument.
--
--   ANEKANTA.md §1.  machine/MathMachine.hs:1743 answered every kernel
--   refusal with 160 characters into a log and a `False`.  A census over
--   that log found the single bit carrying at least four unrelated
--   situations across 1457 refusals, 455 of them claims the SAME LOG
--   accepts elsewhere, one pair four lines apart:
--
--       machine.log:146   KERNEL-REJECT  round=0  x = (xmaxx)   refl
--       machine.log:174   KERNEL-ACCEPT  round=0  x = (xmaxx)   induction on x
--
--   Nothing was lying.  The refusal simply had nowhere typed to go, so it
--   went into prose and stopped being an object.  That is the defect this
--   organ exists to make structurally impossible: not "agents forget to
--   record", but "a refusal has no type, therefore no reader".
--
-- ─────────────────────────────────────────────────────────────────────
-- WHAT EVERY ENTRY MUST CARRY, and why each field is not optional.
--
--   yatna   what was attempted.  Without it the entry is a mood.
--   hetu    why transport was impossible.  §6 is conditional -- the defect
--           is written WHERE TRANSPORT IS NOT POSSIBLE -- so an entry that
--           does not say why is claiming the condition without meeting it.
--   nasta   WHAT WOULD HAVE BEEN DESTROYED, EXHIBITED.  Not described.
--           §5, नास्ति-प्रत्यानयनम्: there is no retraction from ∥A∥₁ --
--           not "hard", NONE.  A summary of a loss is itself the loss,
--           performed a second time.  So the witnesses go in the record,
--           one per line, and an entry with zero witnesses is REFUSED at
--           write time.  This is the one rule the writer cannot argue with.
--   yogyata THE FITNESS OF THE LOOKING.  Kumarila Bhatta, Slokavarttika,
--           Abhavapariccheda, c. 7th c.: an absence is knowable only under
--           YOGYA-ANUPALABDHI -- the thing must be such that it WOULD have
--           been apprehended had it been there.  "No pot on the floor" is
--           knowledge; "no ghost in the room" by the same looking is not.
--           A negative verdict is worth EXACTLY what its looking is worth,
--           so the looking is recorded in three parts: what was examined
--           (drsta), over what domain (ksetra), and the limit outside
--           which this entry issues NO verdict at all (avadhi).
--           The Prabhakara position -- that anupalabdhi is not a separate
--           pramana but folds into perception -- is live and this file
--           takes no side; it records the condition both sides accept.
--   punarabhinaya  the command that replays it.  A defect nobody can
--           re-exhibit is a rumour with a date.
--   sara    a chain hash.  See below.
--
-- ─────────────────────────────────────────────────────────────────────
-- APPEND-ONLY IS A MECHANISM HERE, NOT A REQUEST.
--
-- CLAUDE.md: "when a rule here is violated repeatedly, the next move is a
-- mechanism that fires at the moment of the act, not a paragraph", and
-- scripts/check-no-silent-deletion.sh exists because commit 142bba1f
-- removed 53 registry files and 2145 lines and was found by an archivist
-- draw rather than by any check.
--
-- So each record carries `sara:` -- a 64-bit FNV-1a over the previous
-- record's sara concatenated with this record's canonical text.  Editing
-- any past record, deleting one, or reordering two breaks the chain at
-- that point, and `dosalekha verify` names the first record where the
-- recomputed value diverges.  The log is a file anyone can open in an
-- editor; the chain is why an edit cannot be silent.
--
-- Corrections are therefore NEW RECORDS.  A record that answers, repairs,
-- or supersedes an earlier one names it in `uttara:`.  Nothing is ever
-- struck.  That is the same discipline CLAUDE.md applies to its own struck
-- paragraph, which is preserved in place and marked.
--
-- ─────────────────────────────────────────────────────────────────────
-- WHAT THIS DELIBERATELY DOES NOT ABSORB.
--
-- collab/FAILURES.md is an append-only ledger of research WALKS and their
-- yields, 1165 lines, reframed 2026-08-12 away from "failure".  It is not
-- this and must not be merged into this.  A walk-yield says WHAT WAS
-- LEARNED BY GOING; a dosa says WHAT WOULD HAVE BEEN DESTROYED BY
-- COLLAPSING.  Merging them would force every walk to name a loss it did
-- not incur, and force every dosa into a narrative of progress it does not
-- have.  The refusal is itself entry 0007 in the log, with its witnesses.
--
-- Nor is this machine/GATE_AUDIT_DISPOSITION.md (what was DONE about six
-- findings against one gate) or machine/CertReplay.hs (whether a proved
-- equation survives a ledger round-trip).  Those are records of repair and
-- of re-checking.  This is the record of REFUSAL.
--
-- ─────────────────────────────────────────────────────────────────────
-- THE KINDS (jati).  Seven of them, and that number is INCIDENTAL: this is
-- not the saptabhangi and no correspondence is claimed.  Each is here
-- because collapsing it into a neighbour destroys something nameable.
--
--   sankramana-asambhava  transport is not possible: no equivalence exists
--                         between the two sides.  §6.  The base case.
--   nasti-krta            a truncation was PERFORMED; the loss is already
--                         incurred and is irreversible.  §5.  Distinct from
--                         the above: one is a road not taken, the other is
--                         a road taken that cannot be walked back.
--   durnaya-nirodha       a collapse of standpoints was attempted and
--                         REFUSED.  Siddhasena Divakara, Sanmatitarka 1.21:
--                         a naya asserting itself by denying the others is
--                         a durnaya.  machine/Naya.hs decides this case and
--                         prints the loss; this records it.
--   avaktavya             two standpoints asserted SIMULTANEOUSLY (saha /
--                         yugapat), where no single utterance carries them.
--                         Akalanka, Laghiyastraya, c. 720-780, kramarpana
--                         against saharpana.  NOT a failure and NOT
--                         ignorance: the fourth bhanga is positive.  It is
--                         logged because an unlogged avaktavya becomes, one
--                         session later, a silent collapse to whichever
--                         side was written down.
--   ayogya-darsana        the LOOKING was unfit.  The defect is against the
--                         instrument of knowledge, not against the object,
--                         and NO verdict on the object is issued.  This is
--                         the entry that must never be read as a negative
--                         result.
--   upadhi-anaviskrta     a generalisation was made without searching for
--                         the condition that defeats it.  Nyaya: vyapti is
--                         killed by an upadhi, and an upadhi must be
--                         SOUGHT, not waited for.  The fitted-constant
--                         failure (exp27) is this shape.
--   karana-dosa           the instrument or its environment is defective:
--                         the gate read an exit status, the kernel was
--                         absent, the cache was unauthenticated.  Sound
--                         about mathematics, unsound about its own
--                         environment.  machine/GATE_AUDIT_DISPOSITION.md.
--
-- ─────────────────────────────────────────────────────────────────────
-- USE.  Build and run through machine/run-dosa-lekha.sh, or directly:
--
--   ghc -O0 -Wall -main-is DefectLog.main \
--       -outputdir /tmp/dl -o /tmp/dosalekha \
--       machine/DefectLog.hs
--
--   dosalekha schema              the field grammar and the kinds, for an
--                                 LLM about to write an entry
--   dosalekha count               how many defects, of which kinds
--   dosalekha verify              recompute the chain; name the first break
--   dosalekha query [filters]     FULL records, never summaries
--   dosalekha show <id>           one record
--   dosalekha replay <id> [--run] re-exhibit it
--   dosalekha write < entry       validate and append (stdin, field syntax)
--
-- Query filters: --jati K  --karta W  --vastu SUBSTR  --grep SUBSTR
--                --answered / --unanswered  --id N
--
-- Exact throughout.  Nothing here is sampled, fitted or estimated: the
-- counts are counts and the chain is a fold.
--
-- NOT CLAIMED of the sources: none of Kumarila, Siddhasena or Akalanka
-- wrote a log format.  What is taken from each is the DISTINCTION named
-- beside it, and the rule for when it applies.

module DefectLog (main) where

import Control.Monad (forM_, unless, when)
import Data.Bits (xor, shiftR, (.&.))
import Data.Char (isDigit, isSpace, ord, toLower)
import Data.List (isInfixOf, isPrefixOf, foldl')
import qualified Data.Map.Strict as M
import Data.Maybe (fromMaybe)
import Data.Word (Word64)
import Numeric (showHex)
import System.Directory (doesFileExist)
import System.Environment (getArgs, lookupEnv)
import System.Exit
import System.IO
import System.Process (readCreateProcessWithExitCode, shell)

------------------------------------------------------------------------
-- 1.  The record.
------------------------------------------------------------------------

-- | One written defect.  Fields are kept as an ORDERED association list,
--   with repeats preserved, because `nasta:` and `hetu:` are repeatable
--   and their order is part of the exhibit.  A Map here would silently
--   keep one witness and drop the rest -- which is the exact failure the
--   file is about.
data Dosa = Dosa
  { dId     :: Int
  , dFields :: [(String, String)]   -- in file order, `sara` excluded
  , dSara   :: String               -- as recorded in the file
  , dLine   :: Int                  -- line number of its header, for errors
  } deriving (Show)

fieldsNamed :: String -> Dosa -> [String]
fieldsNamed k d = [ v | (k', v) <- dFields d, k' == k ]

field1 :: String -> Dosa -> String
field1 k d = case fieldsNamed k d of
  (v:_) -> v
  []    -> ""

-- | The seven kinds, each with the distinction it protects.
jatis :: [(String, String)]
jatis =
  [ ("sankramana-asambhava", "transport is not possible: no equivalence exists (VISTARA §6)")
  , ("nasti-krta",           "a truncation was performed; the loss is incurred and irreversible (§5)")
  , ("durnaya-nirodha",      "a collapse of standpoints was attempted and refused (Sanmatitarka 1.21)")
  , ("avaktavya",            "two standpoints asserted saha; no single utterance carries them (Akalanka)")
  , ("ayogya-darsana",       "the looking was unfit; NO verdict on the object (Slokavarttika, Abhavapariccheda)")
  , ("upadhi-anaviskrta",    "generalised without searching for the defeating condition (Nyaya: upadhi)")
  , ("karana-dosa",          "the instrument or its environment is defective, not the mathematics")
  ]

-- | Required fields.  Each refusal here is a refusal to accept an entry
--   that would not be worth reading later.
required :: [(String, String)]
required =
  [ ("kala",            "no date: an entry that cannot be placed in time cannot be superseded")
  , ("karta",           "no author: nobody to ask, and §14 says the reader arrives after the writer")
  , ("jati",            "no kind: an untyped defect is the prose the log replaces")
  , ("yatna",           "no attempt recorded: the entry is a mood, not a defect")
  , ("hetu",            "no reason transport was impossible: §6's condition is asserted, not met")
  , ("nasta",           "NO WITNESS: the loss is described instead of exhibited -- refused")
  , ("yogyata-drsta",   "the looking is unstated, so the verdict is worth nothing (yogya-anupalabdhi)")
  , ("yogyata-ksetra",  "the domain looked over is unstated: 'not found' without 'where'")
  , ("yogyata-avadhi",  "no limit stated: the entry claims a verdict outside what it examined")
  , ("punarabhinaya",   "no replay command: a defect nobody can re-exhibit is a rumour with a date")
  ]

-- | Optional fields.  `sesa` and `pramana` are here because a sibling lane
--   had already got them right and this record had nowhere to put them.
--   machine/Answer.hs builds the
--   IN-MEMORY answer type for the same sutra Â§6, and its `Dosalekha`
--   constructor carries `uSesa` -- the REMAINDER, handed forward.  Â§3:
--   à¤à¤µà¤à¥à¤¤à¤µà¥à¤¯à¥ à¤¶à¥à¤·à¥ à¤µà¤¸à¤¤à¤¿ à¥¤ à¤¶à¥à¤·à¥ à¤à¤°à¥à¤­à¤, à¤¨ à¤µà¤¿à¤«à¤²à¤¤à¤¾ â the remainder lives in the
--   inexpressible; it is a womb, not a failure.  Â§17, the kuttaka: à¤¯à¤¤à¥ à¤¨
--   à¤µà¤¿à¤­à¤à¤¤à¥ à¤¤à¤¤à¥ à¤°à¤à¥à¤·à¥à¤¯à¤¤à¥, what does not divide is KEPT and is the material of
--   the next step (Aryabhata, Aryabhatiya, Ganitapada 32-33, 499).
--
--   Dropping it here would have been this file's own first defect: a store
--   that records what was lost and discards what was left over.  So the
--   two types now line up field for field, and an `Uttara`'s Dosalekha
--   serialises into a record without loss:
--
--       uKriya   -> yatna        uHetu    -> hetu
--       uNasta   -> nasta        uSesa    -> sesa
--       uPramana -> pramana
--
--   The four fields that type does not carry -- kala, karta, yogyata-*,
--   punarabhinaya -- are what a PERSISTED defect needs and an in-memory
--   one does not: a value is read by its caller, a record is read by
--   somebody who was not there (Â§14, Â§15).
optional_ :: [(String, String)]
optional_ =
  [ ("vastu",   "the object: path, path:line, module, or claim the defect is about")
  , ("phala",   "expected outcome of the replay: exit=<n>, or out~<substring>")
  , ("sesa",    "the remainder handed forward: what the next step should pick up (repeatable)")
  , ("pramana", "a source, earliest statement first; or note/commit/module carrying more (repeatable)")
  , ("uttara",  "the id of an earlier dosa this record answers, repairs or supersedes")
  ]

knownField :: String -> Bool
knownField k = k `elem` map fst required ++ map fst optional_ ++ ["sara"]

------------------------------------------------------------------------
-- 2.  Syntax.  A record is
--
--        dosa 0007
--          key: value
--          key: value
--        .
--
--     Blank lines and lines whose first non-space character is '#' are
--     ignored between records.  A value continues onto the next line if
--     that line is indented and begins with '|'.
------------------------------------------------------------------------

logPath :: IO FilePath
logPath = fromMaybe "machine/dosa.lekha" <$> lookupEnv "DOSA_LEKHA"

trim :: String -> String
trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

parseLog :: String -> Either String [Dosa]
parseLog src = go (zip [1 :: Int ..] (lines src)) []
  where
    go [] acc = Right (reverse acc)
    go ((n, l):rest) acc
      | null (trim l)                     = go rest acc
      | "#" `isPrefixOf` trim l           = go rest acc
      | "dosa " `isPrefixOf` trim l =
          case reads (trim (drop 5 (trim l))) :: [(Int, String)] of
            [(i, r)] | null (trim r) -> body i n rest [] acc
            _ -> Left ("line " ++ show n ++ ": bad record header: " ++ l)
      | otherwise = Left ("line " ++ show n ++ ": text outside a record: " ++ l)

    body i hn ((n, l):rest) fs acc
      | trim l == "." =
          let sara = case [ v | ("sara", v) <- fs ] of
                       (v:_) -> v
                       []    -> ""
              fs'  = [ p | p@(k, _) <- reverse fs, k /= "sara" ]
          in go rest (Dosa i fs' sara hn : acc)
      | null (trim l)           = body i hn rest fs acc
      | "#" `isPrefixOf` trim l = body i hn rest fs acc
      | "|" `isPrefixOf` trim l =
          case fs of
            ((k, v):more) -> body i hn rest ((k, v ++ "\n" ++ trim (drop 1 (trim l))) : more) acc
            []            -> Left ("line " ++ show n ++ ": continuation before any field")
      | otherwise =
          case break (== ':') (trim l) of
            (k, ':':v) | not (null k) -> body i hn rest ((trim k, trim v) : fs) acc
            _ -> Left ("line " ++ show n ++ ": not `key: value` and not a `|` continuation: " ++ l)
    body i _ [] _ _ = Left ("record " ++ show i ++ ": ran off the end without a `.` terminator")

-- | Canonical text of a record, excluding `sara`.  This is what is hashed
--   and what is written; render and parse are inverse on it.
canonical :: Int -> [(String, String)] -> String
canonical i fs =
  unlines ( ("dosa " ++ pad4 i)
          : concatMap fieldLines fs )
  where
    fieldLines (k, v) = case lines v of
      []       -> ["  " ++ k ++ ": "]
      (x:more) -> ("  " ++ k ++ ": " ++ x) : [ "  | " ++ m | m <- more ]

pad4 :: Int -> String
pad4 i = let s = show i in replicate (max 0 (4 - length s)) '0' ++ s

renderDosa :: Dosa -> String
renderDosa d = canonical (dId d) (dFields d)
            ++ "  sara: " ++ dSara d ++ "\n.\n"

------------------------------------------------------------------------
-- 3.  The chain.  FNV-1a over the previous sara ++ this record's
--     canonical text.  Not cryptographic and not claimed to be: the
--     adversary here is an accidental edit, a lost rebase, a truncating
--     write -- the same adversary check-no-silent-deletion.sh has.  An
--     adversary with the filesystem also has this file, exactly as
--     GATE_AUDIT_DISPOSITION.md §3 says of the certificate store.
------------------------------------------------------------------------

fnv1a :: Word64 -> String -> Word64
fnv1a = foldl' step
  where
    step h c = foldl' mix h (bytesOf (ord c))
    mix h b = ((h `xor` fromIntegral b) * 0x100000001b3) .&. 0xFFFFFFFFFFFFFFFF
    bytesOf n
      | n < 0x80 = [n]
      | otherwise = [ (n `shiftR` s) .&. 0xFF | s <- [0, 8, 16, 24] ]

hex16 :: Word64 -> String
hex16 w = let s = showHex w "" in replicate (16 - length s) '0' ++ s

saraOf :: String -> Int -> [(String, String)] -> String
saraOf prev i fs = hex16 (fnv1a (fnv1a 0xcbf29ce484222325 prev) (canonical i fs))

-- | Recompute the whole chain.  Returns the first divergence, if any.
checkChain :: [Dosa] -> Either String ()
checkChain ds = go "genesis:dosa-lekha" 1 ds
  where
    go _ _ [] = Right ()
    go prev n (d:rest)
      | dId d /= n = Left ("record at line " ++ show (dLine d) ++ ": expected id "
                           ++ pad4 n ++ ", found " ++ pad4 (dId d)
                           ++ " -- a record was deleted, reordered, or renumbered")
      | want /= dSara d = Left ("dosa " ++ pad4 (dId d) ++ " (line " ++ show (dLine d)
                           ++ "): sara is " ++ dSara d ++ ", recomputes to " ++ want
                           ++ " -- this record or one before it was edited")
      | otherwise = go (dSara d) (n + 1) rest
      where want = saraOf prev (dId d) (dFields d)

------------------------------------------------------------------------
-- 4.  Validation at the moment of the act.
------------------------------------------------------------------------

validate :: [Dosa] -> Int -> [(String, String)] -> [String]
validate prior i fs = concat
  [ [ "missing `" ++ k ++ "` -- " ++ why
    | (k, why) <- required, null [ () | (k', v) <- fs, k' == k, not (null (trim v)) ] ]
  , [ "unknown field `" ++ k ++ "` (see `dosalekha schema`)"
    | (k, _) <- fs, not (knownField k) ]
  , [ "jati `" ++ j ++ "` is not one of the kinds (see `dosalekha schema`)"
    | let j = lookup1 "jati" fs, not (null j), j `notElem` map fst jatis ]
  , [ "`nasta` must EXHIBIT, not describe: witness " ++ show n
      ++ " is under 12 characters (`" ++ w ++ "`)"
    | (n, w) <- zip [1 :: Int ..] [ v | ("nasta", v) <- fs ], length (trim w) < 12 ]
  , [ "`uttara: " ++ u ++ "` names no existing record"
    | u <- [ v | ("uttara", v) <- fs ]
    , maybe True (\k -> k < 1 || k >= i) (readMaybeInt u)
    , u `notElem` map (pad4 . dId) prior ]
  , [ "`phala` must be `exit=<n>` or `out~<substring>`, found `" ++ p ++ "`"
    | p <- [ v | ("phala", v) <- fs ]
    , not (("exit=" `isPrefixOf` p && all isDigit (drop 5 p)) || "out~" `isPrefixOf` p) ]
  ]
  where lookup1 k xs = fromMaybe "" (lookup k xs)

readMaybeInt :: String -> Maybe Int
readMaybeInt s = case reads s :: [(Int, String)] of
  [(n, r)] | null (trim r) -> Just n
  _ -> Nothing

------------------------------------------------------------------------
-- 5.  Reading the log.
------------------------------------------------------------------------

loadLog :: IO (FilePath, [Dosa])
loadLog = do
  p <- logPath
  ex <- doesFileExist p
  if not ex
    then pure (p, [])
    else do
      h <- openFile p ReadMode
      hSetEncoding h utf8
      src <- hGetContents h
      case parseLog src of
        Left e   -> hPutStrLn stderr ("dosalekha: " ++ p ++ ": " ++ e) >> exitWith (ExitFailure 2)
        Right ds -> length src `seq` pure (p, ds)

------------------------------------------------------------------------
-- 6.  Commands.
------------------------------------------------------------------------

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  args <- getArgs
  case args of
    []              -> usage >> exitSuccess
    ("schema":_)    -> schema
    ("count":_)     -> cmdCount
    ("verify":_)    -> cmdVerify
    ("query":rest)  -> cmdQuery rest
    ("show":i:_)    -> cmdQuery ["--id", i]
    ("replay":rest) -> cmdReplay rest
    ("write":_)     -> cmdWrite
    ("help":_)      -> usage
    (c:_)           -> hPutStrLn stderr ("dosalekha: unknown command `" ++ c ++ "`")
                       >> usage >> exitWith (ExitFailure 2)

usage :: IO ()
usage = mapM_ putStrLn
  [ "dosalekha — दोषलेखः, the written defect.  The machine's second organ."
  , "  AHIMSA_SUTRA_VISTARA §6: where transport is not possible, the defect is"
  , "  written.  A written defect lives.  An unwritten defect is himsa."
  , ""
  , "  dosalekha schema                 the field grammar and the seven kinds"
  , "  dosalekha count                  how many defects, of which kinds"
  , "  dosalekha verify                 recompute the append-only chain"
  , "  dosalekha query [filters]        FULL records (never summaries)"
  , "  dosalekha show <id>              one record"
  , "  dosalekha replay <id> [--run]    re-exhibit the defect"
  , "  dosalekha write < entry.txt      validate and append (stdin)"
  , ""
  , "  filters: --jati K  --karta W  --vastu S  --grep S  --id N"
  , "           --answered  --unanswered"
  , ""
  , "  log file: $DOSA_LEKHA, default machine/dosa.lekha (run from repo root)"
  ]

schema :: IO ()
schema = mapM_ putStrLn $
  [ "RECORD SYNTAX"
  , ""
  , "  dosa 0008"
  , "    key: value"
  , "    key: value"
  , "    | continuation of the previous value"
  , "  ."
  , ""
  , "  Repeatable: hetu, nasta, sesa, pramana, uttara.  Order is preserved and is part"
  , "  of the exhibit.  `sara` is computed by `write`; never write it by hand."
  , ""
  , "REQUIRED — each refusal below is a refusal to store an unreadable entry"
  , "" ] ++
  [ "  " ++ padr 16 k ++ why | (k, why) <- required ] ++
  [ ""
  , "OPTIONAL"
  , "" ] ++
  [ "  " ++ padr 16 k ++ why | (k, why) <- optional_ ] ++
  [ ""
  , "FROM THE IN-MEMORY ANSWER TYPE"
  , ""
  , "  machine/Answer.hs is the same"
  , "  sutra section 6 as a value: two roads, no third.  Its Dosalekha"
  , "  constructor serialises here field for field --"
  , ""
  , "    uKriya -> yatna     uHetu -> hetu     uNasta -> nasta"
  , "    uSesa  -> sesa      uPramana -> pramana"
  , ""
  , "  and the four this store adds -- kala, karta, yogyata-*, punarabhinaya --"
  , "  are what a PERSISTED defect needs and an in-memory one does not: a"
  , "  value is read by its caller; a record is read by somebody who was not"
  , "  there, possibly after its writer is gone (sections 14, 15)." ] ++
  [ ""
  , "KINDS (jati) — seven; the number is incidental, this is NOT the saptabhangi"
  , "" ] ++
  [ "  " ++ padr 22 k ++ why | (k, why) <- jatis ] ++
  [ ""
  , "THE ONE RULE THAT CANNOT BE ARGUED WITH"
  , ""
  , "  `nasta` exhibits.  Put the witnesses in — the two log lines, the four"
  , "  census rows, the pair of terms, the counterexample.  Not \"information"
  , "  would be lost\".  §5: there is no retraction from a truncation, so a"
  , "  summary of the loss performs the loss a second time."
  , ""
  , "AND THE ONE THAT IS EASIEST TO SKIP"
  , ""
  , "  yogyata-*.  A negative verdict is worth exactly what its looking is"
  , "  worth (Kumarila Bhatta, Slokavarttika, Abhavapariccheda, c. 7th c.)."
  , "  State what you examined, over what domain, and the limit outside which"
  , "  you issue no verdict.  If the looking was the defect, the jati is"
  , "  `ayogya-darsana` and NO verdict on the object is recorded."
  ]

padr :: Int -> String -> String
padr n s = s ++ replicate (max 1 (n - length s)) ' '

cmdCount :: IO ()
cmdCount = do
  (p, ds) <- loadLog
  let byJati = M.fromListWith (+) [ (field1 "jati" d, 1 :: Int) | d <- ds ]
      answered = [ u | d <- ds, u <- fieldsNamed "uttara" d ]
      openN = length [ d | d <- ds, pad4 (dId d) `notElem` answered ]
      wit = sum [ length (fieldsNamed "nasta" d) | d <- ds ]
  putStrLn ("दोषलेखः  " ++ p)
  putStrLn ""
  putStrLn ("  defects written      " ++ show (length ds))
  putStrLn ("  witnesses exhibited  " ++ show wit)
  putStrLn ("  unanswered           " ++ show openN ++ "   (no later record names them in `uttara`)")
  putStrLn ("  answered             " ++ show (length ds - openN))
  putStrLn ""
  putStrLn "  by kind:"
  forM_ jatis $ \(k, why) ->
    putStrLn ("    " ++ padr 24 k ++ padr 5 (show (M.findWithDefault 0 k byJati)) ++ why)
  let strays = [ k | k <- M.keys byJati, k `notElem` map fst jatis ]
  forM_ strays $ \k ->
    putStrLn ("    " ++ padr 24 k ++ padr 5 (show (M.findWithDefault 0 k byJati)) ++ "*** not a declared kind")
  putStrLn ""
  case checkChain ds of
    Right () -> putStrLn "  chain: intact"
    Left e   -> putStrLn ("  chain: BROKEN — " ++ e)

cmdVerify :: IO ()
cmdVerify = do
  (p, ds) <- loadLog
  case checkChain ds of
    Right () -> do
      putStrLn ("dosalekha: " ++ p ++ ": " ++ show (length ds)
                ++ " records, chain intact, nothing edited or deleted.")
      exitSuccess
    Left e -> do
      hPutStrLn stderr ("dosalekha: " ++ p ++ ": CHAIN BROKEN")
      hPutStrLn stderr ("  " ++ e)
      hPutStrLn stderr "  A dosa is never edited and never deleted.  Correct it by APPENDING"
      hPutStrLn stderr "  a new record whose `uttara:` names the one it supersedes."
      exitWith (ExitFailure 1)

data Filt = Filt
  { fJati :: Maybe String, fKarta :: Maybe String, fVastu :: Maybe String
  , fGrep :: Maybe String, fId :: Maybe Int, fAns :: Maybe Bool }

emptyFilt :: Filt
emptyFilt = Filt Nothing Nothing Nothing Nothing Nothing Nothing

parseFilt :: [String] -> Either String Filt
parseFilt = go emptyFilt
  where
    go f [] = Right f
    go f ("--jati":v:r)  = go f { fJati = Just v } r
    go f ("--karta":v:r) = go f { fKarta = Just v } r
    go f ("--vastu":v:r) = go f { fVastu = Just v } r
    go f ("--grep":v:r)  = go f { fGrep = Just v } r
    go f ("--id":v:r)    = case readMaybeInt v of
                             Just n  -> go f { fId = Just n } r
                             Nothing -> Left ("--id wants a number, got " ++ v)
    go f ("--answered":r)   = go f { fAns = Just True } r
    go f ("--unanswered":r) = go f { fAns = Just False } r
    go _ (x:_) = Left ("unknown filter " ++ x)

cmdQuery :: [String] -> IO ()
cmdQuery args = case parseFilt args of
  Left e -> hPutStrLn stderr ("dosalekha: " ++ e) >> exitWith (ExitFailure 2)
  Right f -> do
    (_, ds) <- loadLog
    let answered = [ u | d <- ds, u <- fieldsNamed "uttara" d ]
        keep d = and
          [ maybe True (== field1 "jati" d) (fJati f)
          , maybe True (`isInfixOf` field1 "karta" d) (fKarta f)
          , maybe True (`isInfixOf` field1 "vastu" d) (fVastu f)
          , maybe True (\s -> lc s `isInfixOf` lc (renderDosa d)) (fGrep f)
          , maybe True (== dId d) (fId f)
          , maybe True (\a -> a == (pad4 (dId d) `elem` answered)) (fAns f)
          ]
        hits = filter keep ds
    forM_ hits (putStr . renderDosa)
    hPutStrLn stderr ("-- " ++ show (length hits) ++ " of " ++ show (length ds) ++ " records")
    when (null hits) $ exitWith (ExitFailure 1)
  where lc = map toLower

cmdReplay :: [String] -> IO ()
cmdReplay args = do
  let (ids, flags) = span (all isDigit) args
      runIt = "--run" `elem` flags
  case ids of
    (i:_) | Just n <- readMaybeInt i -> do
      (_, ds) <- loadLog
      case [ d | d <- ds, dId d == n ] of
        [] -> hPutStrLn stderr ("dosalekha: no dosa " ++ pad4 n) >> exitWith (ExitFailure 1)
        (d:_) -> do
          let cmd = field1 "punarabhinaya" d
              expect = field1 "phala" d
          putStr (renderDosa d)
          putStrLn ("-- punarabhinaya: " ++ cmd)
          if not runIt
            then putStrLn "-- not run.  Add --run to execute it here."
            else do
              (code, out, err) <- readCreateProcessWithExitCode (shell cmd) ""
              putStr out
              unless (null err) (hPutStr stderr err)
              putStrLn ("-- exit " ++ showCode code)
              case expect of
                "" -> putStrLn "-- no `phala` recorded: nothing to compare against."
                e | "exit=" `isPrefixOf` e ->
                      verdict (showCode code == drop 5 e) ("exit " ++ drop 5 e)
                  | "out~" `isPrefixOf` e ->
                      verdict (drop 4 e `isInfixOf` out) ("output containing `" ++ drop 4 e ++ "`")
                  | otherwise -> putStrLn "-- unreadable `phala`."
    _ -> hPutStrLn stderr "usage: dosalekha replay <id> [--run]" >> exitWith (ExitFailure 2)
  where
    showCode ExitSuccess = "0"
    showCode (ExitFailure k) = show k
    verdict True what  = putStrLn ("-- REPLAYED: got the recorded " ++ what ++ ".  The defect is still exhibited.")
    verdict False what = do
      putStrLn ("-- DIVERGED: the record expects " ++ what ++ " and this run did not produce it.")
      putStrLn "-- That is not a failure of the log.  Something changed.  Do NOT edit"
      putStrLn "-- this record: append a new one whose `uttara:` names it."
      exitWith (ExitFailure 1)

cmdWrite :: IO ()
cmdWrite = do
  hSetEncoding stdin utf8
  src <- getContents
  (p, prior) <- loadLog
  case checkChain prior of
    Left e -> do
      hPutStrLn stderr ("dosalekha write: refusing to append to a broken chain.\n  " ++ e)
      exitWith (ExitFailure 1)
    Right () -> pure ()
  fs <- case parseEntry src of
          Left e   -> hPutStrLn stderr ("dosalekha write: " ++ e) >> exitWith (ExitFailure 2)
          Right xs -> pure xs
  let i = length prior + 1
      problems = validate prior i fs
  unless (null problems) $ do
    hPutStrLn stderr "dosalekha write: REFUSED.  An entry that cannot be read later is not a record."
    forM_ problems $ \x -> hPutStrLn stderr ("  - " ++ x)
    hPutStrLn stderr "  See `dosalekha schema`."
    exitWith (ExitFailure 1)
  let prev = if null prior then "genesis:dosa-lekha" else dSara (last prior)
      sara = saraOf prev i fs
      txt  = canonical i fs ++ "  sara: " ++ sara ++ "\n.\n"
  h <- openFile p AppendMode
  hSetEncoding h utf8
  when (null prior) $ hPutStr h header
  hPutStr h txt
  hClose h
  putStr txt
  putStrLn ("-- appended to " ++ p ++ " as dosa " ++ pad4 i)

-- | An entry on stdin is the body of a record without the header, the
--   terminator or the sara.  Accepting the full record syntax too costs
--   nothing and lets `query` output be piped back in for a rewrite.
parseEntry :: String -> Either String [(String, String)]
parseEntry src =
  let body = unlines [ l | l <- lines src
                     , not ("dosa " `isPrefixOf` trim l)
                     , trim l /= "."
                     , not ("sara:" `isPrefixOf` trim l) ]
  in case parseLog ("dosa 0\n" ++ body ++ ".\n") of
       Left e      -> Left e
       Right [d]   -> Right (dFields d)
       Right _     -> Left "more than one record on stdin; write them one at a time"

header :: String
header = unlines
  [ "# दोषलेखः — the written defect.  APPEND ONLY.  NEVER EDIT.  NEVER DELETE."
  , "#"
  , "# AHIMSA_SUTRA_VISTARA §6: यत्र संक्रमणं न सम्भवति तत्र दोषो लिख्यते ।"
  , "#                          लिखितो दोषो जीवति । अलिखितो दोषो हिंसा ।"
  , "#"
  , "# Written by machine/DefectLog.hs, which computes"
  , "# `sara:` as a chain over every preceding record.  Edit any line above the"
  , "# last record and `dosalekha verify` names the record where it happened."
  , "# To correct a record, APPEND one whose `uttara:` names it."
  , "#"
  ]
