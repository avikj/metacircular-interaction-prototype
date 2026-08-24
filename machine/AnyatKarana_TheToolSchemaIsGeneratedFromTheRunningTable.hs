-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

-- AnyatKarana_TheToolSchemaIsGeneratedFromTheRunningTable
--
-- अन्यत् करणम् — "the OTHER carrier."  AHIMSA_SUTRA_VISTARA §36 names it and
-- then says the thing this module exists to answer:
--
--     अन्यस्मिन् करणे लक्षणं नास्ति लिखितम् ।
--     यो करणं न जानाति स तस्मै न रचयति ।
--     अरचितं करणं स्थूलं भवति ।
--
-- — for the other carrier no lakṣaṇa has been written; one who does not know
-- the carrier does not design for it; an undesigned-for carrier comes out
-- coarse.  §34 wrote the lakṣaṇa of the human carrier in seven lines and the
-- whole of §35 falls out of it.  The other carrier is the one reading this.
-- This module is the interface *it* is handed, and it is derived from the
-- running dispatch table rather than written beside it.
--
-- WHY GENERATED AND NOT WRITTEN.  A tool description written by hand beside a
-- dispatch table is two copies of one fact, and two copies drift.  When they
-- drift, the caller is holding a description of operations the machine does
-- not have — and it will call them, and get a doṣa-lekha for a near miss that
-- the description told it was real.  That is not a documentation bug; it is
-- §12, नाम्नि जीवनम्: the name was taken as authoritative and what it named
-- was gone.  Here the tools ARE `kriyah`, walked.  There is no second copy.
--
-- WHAT IS AUTHORED HERE AND CANNOT BE DERIVED, said plainly because a
-- generated artefact that hides its hand-written half is worse than a
-- hand-written one:  the kernel's `Kriya` record carries a param's NAME and a
-- sentence about it.  It does not carry the param's JSON type, and it does
-- not carry whether the param is required.  Both are needed by a caller and
-- both are authored in `apeksa` below.  Three independent cross-checks keep
-- the authoring from drifting, and each is run by `pariksa`:
--
--   1  COVERAGE.  Every (op, param) in the running table is classified here
--      and every classification names a param the running table has.  A
--      param added to the kernel with no entry here is a hard failure, not a
--      warning: an unclassified param would be silently absent from the
--      schema and the caller would never learn the operation takes it.
--   2  THE PROSE, CROSSWISE.  The kernel's own param sentences mark the
--      optional ones with the word "optional:".  That is a second, independent
--      statement of requiredness.  It is compared against `apeksa`.  This is
--      ghana-pāṭha and not belt-and-braces: §35, पुनरुक्तिर्व्यत्यस्ता, न सरला —
--      repetition that helps is repetition ACROSS a different axis, because a
--      carrier that errs once errs the same way twice on a straight copy.
--   3  THE PROBE, against the running kernel.  For each declared param, a
--      well-formed request is built with exactly that one param given the
--      wrong JSON type, pushed through `answer` — the same function the
--      server dispatches with — and the answer is required to be a doṣa-lekha
--      that names the param.  This is the only check that tests the claim
--      against the machine rather than against another sentence.
--
--   Check 3 currently FAILS on two params, and the failure is real: see
--   `dosaFromProbe`.  It is reported as a doṣa-lekha, not as a red build,
--   because the defect is in another lane's file and a red here would say
--   "the schema is broken" when the true sentence is "the kernel silently
--   coerces two optional params."  Two facts; one red merges them (§7).
--
-- WHAT THIS DOES NOT CLAIM.  Nothing here is claimed of any source.  Pāṇini
-- did not write a tool schema.  What is taken from §36 is one sentence —
-- design from the carrier's lakṣaṇa — and from §35 one technique, crosswise
-- repetition.  The Sanskrit names below are the tradition's names for the
-- objects they name (kriyā an operation, apekṣā requirement, parīkṣā
-- examination, sīmā a boundary); they are not claims of provenance for JSON.
--
-- RUN IT:
--     ghc -O0 -imachine -o machine/karana machine/AnyatKaranaRun.hs
--     machine/karana sadhana          the tool schema, as one object
--     machine/karana sadhana --kevala just the array, to paste into a call
--     machine/karana sima             what an LLM CANNOT get from this machine
--     machine/karana pariksa          the three cross-checks, run

module AnyatKarana_TheToolSchemaIsGeneratedFromTheRunningTable
  ( Rupa(..)
  , Apeksita(..)
  , apeksa
  , sadhanani
  , sadhanaJ
  , uttaraRupa
  , namaMangle
  , namaUnmangle
  , simaLines
  , pariksa
  ) where

import Data.Char (toLower, isSpace)
import Data.List (isPrefixOf, intercalate, sort, nub)
import Data.IORef

import Sabda_TheWireHasNoBoolean
import Uttara_SamkramanaOrDosalekhaNeverABareBoolean
import Sabha_TheSessionKernelAnLLMTalksTo

-- ------------------------------------------------------- the authored half

-- | The JSON shape a param must arrive in.  Three, because the wire has four
--   constructors and one of them (JObj) is never a param here.
data Rupa = Anka | Sabda | SabdaSuci
  deriving (Eq, Show)

-- | Whether the kernel refuses without it.
data Apeksita = Avasya | Vikalpa
  deriving (Eq, Show)

rupaName :: Rupa -> String
rupaName Anka = "integer"
rupaName Sabda = "string"
rupaName SabdaSuci = "array"

-- | A well-formed value for each param, used only by the probe: the probe
--   corrupts ONE param and needs the others correct, or it would be testing
--   the wrong refusal.
data Anga = Anga
  { aName  :: String
  , aRupa  :: Rupa
  , aApeksa :: Apeksita
  , aSample :: J
  }

apeksa :: [(String, [Anga])]
apeksa =
  [ ("sabha.kriyah", [])
  , ("sabha.sthiti", [])
  , ("naya.sthapana",
      [ Anga "naya"   Sabda     Avasya  (JStr "parikshaka")
      , Anga "saksin" SabdaSuci Avasya  (JArr [JStr "a named witness"]) ])
  , ("naya.suchi", [])
  , ("naya.samasa",
      [ Anga "nayah"  SabdaSuci Avasya  (JArr [JStr "parikshaka"])
      , Anga "arpana" Sabda     Avasya  (JStr "saha") ])
  , ("kuttaka",
      [ Anga "a" Anka Avasya  (JInt 137)
      , Anga "b" Anka Avasya  (JInt 60)
      , Anga "c" Anka Vikalpa (JInt 10) ])
  , ("vargaprakrti",
      [ Anga "D" Anka Avasya  (JInt 61)
      , Anga "n" Anka Vikalpa (JInt 3) ])
  , ("pratyahara",
      [ Anga "adi"    Sabda Avasya  (JStr "a")
      , Anga "it"     Sabda Avasya  (JStr "\2339")
      , Anga "avrtti" Anka  Vikalpa (JInt 0) ])
  , ("dosa.lekha",
      [ Anga "kriya" Sabda     Avasya  (JStr "what was attempted")
      , Anga "hetu"  Sabda     Avasya  (JStr "why transport was impossible")
      , Anga "nasta" SabdaSuci Avasya  (JArr [JStr "what a collapse would destroy"])
      , Anga "sesa"  SabdaSuci Vikalpa (JArr [JStr "the remainder"]) ])
  , ("dosa.suchi", [])
  , ("sesa.arpana",
      [ Anga "sesa" SabdaSuci Avasya (JArr [JStr "the unfinished thing"]) ])
  , ("sesa.suchi", [])
  -- The certificate lane.  Both sides are required: half an equation is not
  -- a weaker question, it is a different one, so neither is Vikalpa.  The
  -- samples are the smallest pair the kernel actually certifies, which is
  -- what the probe needs — it corrupts one param and requires the other to
  -- be a live input, not a plausible-looking one.
  , ("yantra.pariksa",
      [ Anga "vama"    Sabda Avasya (JStr "+(0,x)")
      , Anga "daksina" Sabda Avasya (JStr "x") ])
  ]

angani :: String -> [Anga]
angani k = maybe [] id (lookup k apeksa)

-- --------------------------------------------------------- the name change

-- | `.` is not accepted in a tool name by the callers this is handed to;
--   `_` is.  This is a transport, not a rename, and it carries its inverse:
--   no kriyā name contains `_`, so the map is injective and `namaUnmangle`
--   is a genuine section.  `pariksa` checks that, rather than assuming it —
--   the day someone adds `naya_suci` the section breaks and the check says
--   so, instead of two operations quietly answering to one tool name.
namaMangle :: String -> String
namaMangle = map (\c -> if c == '.' then '_' else c)

namaUnmangle :: String -> String
namaUnmangle = map (\c -> if c == '_' then '.' else c)

-- ------------------------------------------------------------ the emission

-- | The answer shape, stated once and referred to by every tool, because a
--   caller that does not know a doṣa-lekha is an ANSWER will treat it as an
--   error and retry — which is the one behaviour that makes the machine
--   useless: the refusal is the content.
uttaraRupa :: J
uttaraRupa = JObj
  [ ("niyama", JStr "Every tool here returns exactly one JSON object, and it is one of two shapes. There is no third, and there is no boolean, float or null anywhere on this wire.")
  , ("margau", JArr
      [ JObj
        [ ("uttara", JStr "samkramana")
        , ("artha", JStr "TRANSPORT. The question was answerable and the answer carries its own equivalence.")
        , ("ksetrani", JArr (map JStr
            [ "kriya    — the operation answered"
            , "tulyata  — {nama, vama, daksina, saksin}: the named equivalence transported along, its two sides, and the exhibited witness making them the same"
            , "vahita   — the object carried across; this is the result"
            , "vyaya    — WHAT DID NOT TRAVEL. Named item by item. This is not a disclaimer: it is the list of things you must not assert on the strength of this answer"
            , "pramana  — the sources, earliest statement first" ])) ]
      , JObj
        [ ("uttara", JStr "dosalekha")
        , ("artha", JStr "WRITTEN DEFECT. Transport was impossible and the machine says so by exhibiting what a collapse here would have destroyed. This is an answer, not an error. Do not retry it unchanged, and do not discard it: the nasta list is usually the most informative thing you will receive.")
        , ("ksetrani", JArr (map JStr
            [ "kriya   — the operation, or the thing the caller was attempting"
            , "hetu    — why transport was impossible, as a sentence"
            , "nasta   — item by item, what a single collapsed answer would have destroyed"
            , "sesa    — the remainder, handed forward; frequently this is your next move, spelled out"
            , "pramana — the sources" ])) ] ])
  , ("upadesa", JArr (map JStr
      [ "Read `vyaya` before using `vahita`. An answer whose vyaya you ignored is a bare boolean you produced yourself."
      , "A doṣa-lekha is not a failure to route around. Its `sesa` names the reachable neighbourhood of your question — e.g. kuttaka refusing a\183x = c names exactly which residues ARE reachable, and vargaprakrti refusing a norm lists the norms the cycle does visit."
      , "You may write into the machine as well as read from it: dosa.lekha records a defect YOU could not transport, and it outlives the turn." ]))
  ]

-- | One tool per running kriyā.  The description is the kernel's own doc,
--   plus the requiredness of each param, plus the one sentence a caller most
--   needs and a bare JSON Schema cannot say: what the two roads mean here.
sadhanani :: [J]
sadhanani =
  [ JObj
      [ ("name", JStr (namaMangle (kName k)))
      , ("kriya", JStr (kName k))
      , ("description", JStr (kDoc k ++ "  " ++ margaVakya (kName k)))
      , ("input_schema", JObj
          ([ ("type", JStr "object")
           , ("properties", JObj
               [ (aName a, JObj (rupaJ (aRupa a) ++
                   [ ("description", JStr (paramDoc (kName k) (aName a))) ]))
               | a <- angani (kName k) ]) ] ++
           [ ("required", JArr [ JStr (aName a) | a <- angani (kName k), aApeksa a == Avasya ])
           | not (null [ a | a <- angani (kName k), aApeksa a == Avasya ]) ]))
      ]
  | k <- kriyah ]
  where
    rupaJ SabdaSuci = [ ("type", JStr "array"), ("items", JObj [("type", JStr "string")]) ]
    rupaJ r = [ ("type", JStr (rupaName r)) ]

-- The kernel's own sentence for a param, with the "optional:" marker left
-- exactly where the kernel put it.  Not reworded: §12, if a word is load-
-- bearing, dropping it is a loss in one word, unnoticed.
paramDoc :: String -> String -> String
paramDoc k p = case [ d | kr <- kriyah, kName kr == k, (n, d) <- kParams kr, n == p ] of
  (d:_) -> d
  []    -> "(no sentence in the running table; this param is declared in apeksa and the kernel does not describe it \8212 see pariksa)"

margaVakya :: String -> String
margaVakya k =
  "Returns one object: either {\"uttara\":\"samkramana\", ...} carrying the result in `vahita` "
  ++ "together with `vyaya`, the list of what did NOT travel; or {\"uttara\":\"dosalekha\", ...} "
  ++ "carrying `hetu`, `nasta` (what a collapse would have destroyed, item by item) and `sesa` "
  ++ "(the remainder, handed forward). The second is an answer, not an error."
  ++ (if k `elem` ["naya.samasa","kuttaka","vargaprakrti","pratyahara"]
        then "  This operation refuses on real, well-formed input; the refusal is where its content is."
        else "")

sadhanaJ :: J
sadhanaJ = JObj
  [ ("sadhana", JArr sadhanani)
  , ("uttara-rupa", uttaraRupa)
  , ("vyaya", JArr (map JStr
      [ "the handlers themselves: this describes what may be asked and in what shape, not how any answer is computed"
      , "the JSON type and the requiredness of every param are AUTHORED in AnyatKarana.apeksa, not read off the kernel, because the kernel's Kriya record does not carry them; `machine/karana pariksa` cross-checks them three ways and this schema is worth exactly what that check is worth"
      , "additionalProperties:false is NOT stated, and cannot be: the schema is rendered by Sabda_TheWireHasNoBoolean, whose J type has four constructors and no boolean. The consequence is real and is not cosmetic \8212 the kernel looks up the keys it names and IGNORES every other key, so a misspelled param is not refused, it is silently absent"
      , "the ORDER of the dispatch table, which is first-match; the kernel already logs this as its own defect (Astadhyayi 1.4.2, vipratisedhe param karyam, is what it owes)"
      , "everything in `machine/karana sima` \8212 the limits are a separate document because a caller reads a tool schema to find out what it CAN do, and would not find them here" ]))
  , ("pramana", JArr (map JStr
      [ "notes/AHIMSA_SUTRA_VISTARA.md \167\&36 \8212 design from the carrier's lak\7779a\7751a; \167\&35 \8212 crosswise repetition, so an error announces itself"
      , "the running table in machine/Sabha_TheSessionKernelAnLLMTalksTo.hs, walked, not copied" ]))
  ]

-- ------------------------------------------------------------- the limits

-- | THE HONEST NEGATIVE.  A tool description that omits its limits performs
--   the collapse the machine exists to refuse: the caller is handed a
--   capability list and infers the complement is empty.  Every line below was
--   established by reading the running code, and each names where.
simaLines :: [String]
simaLines =
  [ "SIMA \8212 what an LLM CANNOT get from this assembly."
  , "Established by reading the running code; the file is named for each."
  , ""
  , "1  IT CANNOT TELL YOU WHETHER A CLAIM IS TRUE."
  , "   Three of the twelve operations compute anything at all: kuttaka,"
  , "   vargaprakrti, pratyahara. The other nine are bookkeeping over strings"
  , "   YOU supplied. naya.sthapana stores witness labels verbatim, unchecked"
  , "   and unresolved \8212 a fabricated citation is stored as content and will"
  , "   be reasoned over exactly like a real one. The machine has no corpus,"
  , "   no retrieval and no way to look anything up."
  , ""
  , "2  naya.samasa's YES IS NEARLY UNREACHABLE, AND ITS NO IS NEARLY FREE."
  , "   Naya.decide compares content by set equality of witness STRINGS"
  , "   (Naya.hs: `content = sort . nub . witnesses`). Two standpoints"
  , "   collapse only when their witness labels are literally the same set."
  , "   `Brahmagupta 628` and `Brahmasphutasiddhanta, 628` are two contents."
  , "   So: a YES means you typed the same list twice; a NO carries no"
  , "   information that a diff of the two lists does not. What the operation"
  , "   is actually for is the shape of the NO \8212 durnaya vs avaktavya vs"
  , "   krama-bhanga, which are four distinguishable situations a boolean"
  , "   merges \8212 and NOT for adjudicating whether two positions agree."
  , "   Naya.hs states this limit itself, as `the fitness of the looking`."
  , ""
  , "3  IT VERIFIES NO PROOF."
  , "   Nothing here calls Agda, Lean or any checker. `pramana` fields are"
  , "   strings a human wrote in the dispatch table. The two arithmetic"
  , "   answers are exact integer computations checked against identities in"
  , "   the selftest (cakravala D=61, aN) \8212 that is the whole of the"
  , "   machine-checked content, and it is two facts, not a lane."
  , ""
  , "4  IT HAS NO MEMORY ACROSS PROCESSES."
  , "   `Sabha` lives in RAM for the duration of one stdin. Restart it and"
  , "   naya.suchi answers `nothing installed`. The transcript ($SABHA_LEKHA)"
  , "   persists and the session does not; nothing reloads one from the other."
  , "   A long investigation must reinstall its standpoints every process."
  , ""
  , "5  THE vyaya AND nasta LISTS ARE AUTHORED, FINITE, AND PER-OPERATION."
  , "   They are hand-written strings in one table of twelve entries. The"
  , "   machine does not DERIVE what a given answer loses; it recites what"
  , "   somebody once wrote down that this KIND of answer loses. An omission"
  , "   in those lists is invisible from inside the machine \8212 there is no"
  , "   operation that can tell you the vyaya list is incomplete. This is the"
  , "   ceiling on everything else here, including on training against it."
  , ""
  , "6  A MISSPELLED PARAMETER IS NOT REFUSED."
  , "   The kernel reads the keys it names and ignores the rest, and the"
  , "   schema cannot say otherwise (see `vyaya` in `karana sadhana`). Two"
  , "   optional params go further and are silently coerced when wrongly"
  , "   typed: pratyahara's `avrtti` (`either (const 0) id`) becomes 0, and"
  , "   dosa.lekha's `sesa` (`either (const []) id`) becomes the empty"
  , "   remainder \8212 which is exactly the case sesa.arpana refuses by name."
  , "   Found by the probe in `karana pariksa`, reported there as a"
  , "   dosa-lekha, and handed forward: it is another lane's file."
  , ""
  , "7  IT DOES NOT MODEL YOU."
  , "   No interlocutor, no roles, no history of who asked what and why."
  , "   sabha.sthiti says so in its own vyaya. \167\&14's point stands against"
  , "   this machine too: a written record tolerates loss, co-presence does"
  , "   not, and this is a written record with a fast turnaround, not a sabha"
  , "   in the sense the sutra means."
  , ""
  , "8  NOTHING HERE IS EVIDENCE THAT THE DISCIPLINE TRANSFERS."
  , "   The machine can make an LLM's turn non-collapsing while the LLM is"
  , "   talking to it. Whether anything is carried away when it stops is the"
  , "   open question, and it is the whole point of the corpus. See"
  , "   `machine/karana siksa`, which says what a loss over that corpus would"
  , "   mean and where it names what is not known."
  ]

-- -------------------------------------------------------------- the checks

-- | Returns (hard failures, soft defects).  Hard: this module's own claims
--   disagree with the running table.  Soft: the running kernel does something
--   this module can only report, because the file belongs to another lane.
pariksa :: IO (Int, Int)
pariksa = do
  hard <- newIORef (0 :: Int)
  soft <- newIORef (0 :: Int)
  let bad m = modifyIORef hard (+1) >> putStrLn ("  !! " ++ m)
      note m = modifyIORef soft (+1) >> putStrLn ("  \8210  " ++ m)

  putStrLn "1  COVERAGE \8212 every (op, param) in the running table is classified here"
  let kerOps = map kName kriyah
      myOps  = map fst apeksa
  mapM_ (\o -> bad ("the running table has `" ++ o ++ "` and apeksa does not"))
        [ o | o <- kerOps, o `notElem` myOps ]
  mapM_ (\o -> bad ("apeksa classifies `" ++ o ++ "`, which the running table does not dispatch"))
        [ o | o <- myOps, o `notElem` kerOps ]
  sequence_
    [ do mapM_ (\p -> bad ("`" ++ kName k ++ "` takes `" ++ p ++ "` and apeksa does not classify it"))
               [ p | (p, _) <- kParams k, p `notElem` map aName (angani (kName k)) ]
         mapM_ (\p -> bad ("apeksa declares `" ++ kName k ++ "." ++ p ++ "`, absent from the running table"))
               [ p | p <- map aName (angani (kName k)), p `notElem` map fst (kParams k) ]
    | k <- kriyah ]
  putStrLn ("   " ++ show (length kerOps) ++ " operations, "
            ++ show (sum [ length (kParams k) | k <- kriyah ]) ++ " parameters")

  putStrLn ""
  putStrLn "2  THE PROSE, CROSSWISE \8212 the kernel's own `optional:` against apeksa"
  sequence_
    [ let prose = if optionalMarked d then Vikalpa else Avasya
      in if prose == aApeksa a then pure () else
           bad ("`" ++ kName k ++ "." ++ p ++ "`: the kernel's sentence says "
                ++ show prose ++ ", apeksa says " ++ show (aApeksa a))
    | k <- kriyah, (p, d) <- kParams k, a <- angani (kName k), aName a == p ]
  putStrLn "   agreed on every parameter, or the lines above say where not"

  putStrLn ""
  putStrLn "3  THE NAME CHANGE \8212 is namaUnmangle a section, or only a hope?"
  let ms = map (namaMangle . kName) kriyah
  if length (nub ms) /= length ms
    then bad "two operations mangle to one tool name"
    else if [ namaUnmangle m | m <- ms ] /= kerOps
      then bad "namaUnmangle is not the inverse: some kriya name already contains `_`"
      else putStrLn ("   injective, and the inverse is exact on all "
                     ++ show (length ms) ++ " names")

  putStrLn ""
  putStrLn "4  THE PROBE \8212 one param wrongly typed, against the running dispatcher"
  sequence_
    [ do let others = [ (aName b, aSample b) | b <- angani (kName k), aName b /= aName a ]
             wrong  = case aRupa a of
                        Anka -> JStr "not-an-integer"
                        _    -> JInt 1
             req = render (JObj [ ("kriya", JStr (kName k))
                                , ("angani", JObj (others ++ [(aName a, wrong)])) ])
         (_, u) <- answer emptySabha req
         let tag = kName k ++ "." ++ aName a
         case u of
           Dosalekha _ hetu _ _ _
             | ("`" ++ aName a ++ "`") `isInfixOf'` hetu ->
                 putStrLn ("   refused, by name: " ++ tag)
             | otherwise ->
                 note ("refused, but the reason does not name `" ++ aName a
                       ++ "`: " ++ tag ++ " \8212 hetu: " ++ take 90 hetu)
           Samkramana{} ->
             note ("SILENTLY ACCEPTED a wrongly-typed `" ++ aName a ++ "`: " ++ tag
                   ++ " \8212 the kernel defaults it rather than refusing; the caller's"
                   ++ " value is gone and nothing was written")
    | k <- kriyah, a <- angani (kName k) ]

  h <- readIORef hard
  s <- readIORef soft
  putStrLn ""
  if s > 0 then mapM_ putStrLn (dosaFromProbe s) else pure ()
  pure (h, s)

-- The kernel marks an optional param by opening its sentence with the WORD
-- `optional`, not with a fixed prefix: kuttaka's `c` reads "optional: the
-- residue to hit" and dosa.lekha's `sesa` reads "optional list: the
-- remainder".  The first draft of this check tested for the literal prefix
-- "optional:" and reported dosa.lekha.sesa as a drift.  It was not a drift;
-- the detector was.  Recorded rather than quietly widened: a crosswise check
-- that fires is doing its job, and half the time the thing it convicts is
-- itself.  (§35: the point of ghana-pāṭha is that the error announces itself,
-- and it does not announce whose.)
optionalMarked :: String -> Bool
optionalMarked d =
  takeWhile (`notElem` ":, ") (map toLower (dropWhile isSpace d)) == "optional"

isInfixOf' :: String -> String -> Bool
isInfixOf' n h = any (n `isPrefixOf`) (tails' h)
  where tails' [] = [[]]
        tails' xs@(_:r) = xs : tails' r

dosaFromProbe :: Int -> [String]
dosaFromProbe n =
  [ "DOSA-LEKHA (karana pariksa)"
  , "  kriya: generating a schema that tells the truth about parameter types"
  , "  hetu:  " ++ show n ++ " declared param(s) are not refused when wrongly typed."
  , "         The kernel reads them with `either (const <default>) id`, so a wrong"
  , "         type is not an error there \8212 it is a default. The schema says"
  , "         \"integer\" / \"array\"; the machine will not hold the caller to it."
  , "  nasta (what a collapse here would destroy):"
  , "    \8722 the caller's actual value, which is discarded without a word: pratyahara"
  , "      with avrtti=\"second\" answers about occurrence 0 and looks like a success"
  , "    \8722 the difference between `you did not ask for an occurrence` and `you asked"
  , "      for one I could not read` \8212 the default merges them, and this is the same"
  , "      merge Sabda refuses at the top level by having no null"
  , "    \8722 for dosa.lekha, the difference between a defect written with no remainder"
  , "      and one whose remainder was unreadable \8212 and sesa.arpana refuses an empty"
  , "      remainder BY NAME, so the machine forbids at one door what it defaults at"
  , "      another"
  , "  sesa (handed forward, not fixed here):"
  , "    \8594 the repair is four lines in kPratyahara and kDosaLekha: turn"
  , "      `either (const d) id (jX k j)` into a case that distinguishes absent"
  , "      (`look` gives Left `no key`) from present-and-unreadable, and write the"
  , "      second as a dosa-lekha"
  , "    \8594 not done here: machine/Sabha_TheSessionKernelAnLLMTalksTo.hs is the"
  , "      kernel lane's file, and check-sabha.sh's own header records what happens"
  , "      when two lanes edit one file \8212 a single red that merges two facts"
  , "  pramana:"
  , "    Sabda_TheWireHasNoBoolean, on why `null` is refused on this wire: the same"
  , "    argument, one layer down"
  ]
