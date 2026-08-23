-- SvamRupam_AQuotedWordNamesItselfAndIsNotACitation
--
-- स्वं रूपम् — a word's own form.  Pāṇini, Aṣṭādhyāyī 1.1.68 (c. 500 BCE):
--
--     स्वं रूपं शब्दस्याशब्दसंज्ञा
--     svaṃ rūpaṃ śabdasyāśabdasaṃjñā
--
-- In a sūtra a word denotes ITS OWN FORM, not its meaning, unless it is a
-- technical name.  Write `agni` in a rule and the rule is about the four
-- letters, not about fire.  Patañjali, Mahābhāṣya ad 1.1.68, works the
-- consequence out: without the rule every grammatical statement would be
-- a statement about the world instead of about the language, and no
-- grammar could be written at all.
--
-- NOT CLAIMED: that Pāṇini or Patañjali wrote a citation scanner, or
-- discussed version control.  What is taken is the distinction — a word
-- USED and a word MENTIONED are two objects — and the rule that the
-- second is the default inside a metalinguistic text.
--
--     runghc -imachine machine/SvamRupam_AQuotedWordNamesItselfAndIsNotACitation.hs
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS FOR.
--
-- machine/MulaPramana_ACitationNamesAFixedObjectOrItIsNotOne.hs decides
-- whether a designation names a fixed object, and its `scanLine` runs a
-- census over machine/dosa.lekha for citations that name a moving one.
-- That census is a grep, and a grep cannot tell a word used from a word
-- mentioned.  Run today it reports every occurrence of the four-letter
-- string `head` — including Haskell's partial list function inside a
-- quoted line of source, and the English noun in "arithmetic done in my
-- head" — as a HEAD-relative git query.
--
-- Reporting those as citations that name nothing is not a small
-- overcount.  It is the same act the census exists to prevent, performed
-- one level up: a name taken as a mere token, and the life in it
-- collapsed.  notes/AHIMSA_SUTRA_VISTARA.md §12 —
--
--     नाम्नि जीवनम् । शब्दे जीवनानि ।
--     यः शब्दं पर्यायम् इव गृह्णाति स जीवनानि सङ्क्षिपति ।
--     अनवधानेन शब्दो नष्टिं करोति ।
--
-- Through inattention a word performs the destruction.  So this module
-- does not delete the census and does not raise its threshold.  It splits
-- its output in two and says, for every hit it moves out of the count,
-- WHICH RULE moved it and what the word was doing there.
--
-- ────────────────────────────────────────────────────────────────────
-- THE THREE RULES, and why each is decidable rather than a judgement.
--
--   S1 · CASE.  A git revision is written `HEAD` in every one of this
--        repository's records and in git's own documentation.  Lowercase
--        `head` in machine/dosa.lekha is, in every instance, one of three
--        other words: Haskell's `head` (inside a quoted line of source),
--        the shell utility `head` (in a pipeline), or the English noun.
--        Decidable: the case of the letters.  The claim that no record
--        uses lowercase `head` AS a revision is exhibited, not assumed —
--        `svarupaLines` prints all three so the reader checks it.
--
--   S2 · APPOSITION.  `HEAD a8b6435a` names the commit and then says
--        where it stood.  The hash is the fixed object; the word is
--        apposition to it, and deleting the word changes nothing about
--        what is named.  Decidable: a hex token of seven or more digits
--        follows on the same line.
--
--   S3 · FIELD.  machine/DosaLekha_TheWrittenDefectRecord.hs requires
--        `nasta` to EXHIBIT and not describe, and `hetu` to give the
--        reason transport was impossible.  Both fields are, by the
--        schema's own definition, an account of what was done — past
--        tense, quoted, with its output beside it.  A command quoted
--        inside them is the object under discussion.  The fields that
--        instruct a later reader are `vastu`, `sesa` and `punarabhinaya`,
--        and a moving citation there is a real one.  Decidable: the field
--        key, which the record syntax puts first on the line.
--
-- S3 is the load-bearing one and it is also the one an adversary would
-- attack: a writer who wants a count to pass need only put it in `hetu`.
-- That is true and it is not a hole in the rule, because a count in
-- `hetu` is not a replay — nobody re-runs it, and `dosalekha replay`
-- reads `punarabhinaya` and nothing else.  The rule and the replay agree
-- about which field is a instruction.
--
-- ────────────────────────────────────────────────────────────────────
-- WHOSE DISPUTE THIS IS, named before the term is used.
--
-- The rules above decide by inspecting the characters, so they inherit
-- the dispute the sibling module already records and does not settle:
--
--   The BUDDHIST PRAMĀṆA school.  Dignāga, Pramāṇasamuccaya V (c. 480–540
--   CE): a word's content is anyāpoha, exclusion of the other.  On that
--   reading a rule over character case is not a poor substitute for
--   meaning — it is the only thing a word ever did, and S1 excludes
--   exactly what it excludes.
--
--   The NAIYĀYIKAS.  Uddyotakara, Nyāyavārttika (c. 550–610 CE), and
--   Jayanta Bhaṭṭa, Nyāyamañjarī (c. 890 CE): apoha is circular, and a
--   character rule that separates `head` from `HEAD` has separated two
--   spellings, not two words.  They would say S1 works here only because
--   a reader already knows which of four words each occurrence is, and
--   that knowledge is nowhere in the rule.
--
-- BOTH CHARGES LAND.  This module does not pick.  It applies the
-- character rules, PRINTS EVERY LINE IT MOVED so the reader supplies the
-- knowledge the rule does not have, and leaves the classification open in
-- the open form.  Byte equality is not synonymy, and byte inequality is
-- not difference of meaning either: machine/mula.pramana now records a
-- case where a record's own quotation of a source differs from the source
-- by an en dash, and means the same thing.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT FALLS.  Not the census — machine/dosa.lekha is append-only and a
-- moving citation already written is never deleted.  What falls is
-- UNANSWERED: a moving citation is answered when a later record names its
-- doṣa in `uttara:` and names machine/mula.pramana in `pramana:`, where
-- the fixed object standing in its place is written down.  Zero is an
-- invariant and not a count: a later record carrying a moving citation
-- raises it, and this replay diverges, which is the point.
--
-- ────────────────────────────────────────────────────────────────────
-- AND THE INVARIANT WAS SATISFIABLE BY NOT OPENING THE FILE.  2026-08-22.
-- Recorded here and not in `machine/dosa.lekha`, whose chain is broken
-- from record 0040 and whose `write` refuses to append; resealing it is
-- the edit that organ was founded to forbid.
--
--     readFileOr p = do (_, out, _) <- readProcessWithExitCode "cat" [p] ""
--                       pure out
--
-- The exit status is discarded at the pattern and stderr with it, so an
-- unreadable लेख returned `""`.  `padas "" = []`, so `hits`, `sva` and
-- `cal` are all empty, so the tally prints four zeros and `unanswered: 0`
-- — and the paragraph directly above calls that zero an invariant that a
-- later record raises.  An invariant satisfied by the file not opening is
-- not held.  It is unexamined, and the two must not print the same line.
--
-- EXHIBITED.  A scratch tree holding a copy of this repository's
-- `machine/dosa.lekha`, `chmod 000`.  Against the code at HEAD before
-- this commit the whole tally read:
--
--     hits reported by the census        0
--     svarupa, moved out with a rule     0
--     calat, naming a moving object      0
--     unanswered: 0
--
-- The same tree, after: `machine/dosa.lekha was not read: cat:
-- machine/dosa.lekha: Permission denied`, no census, no tally, exit 2.
-- The discarded slot is `cat`'s own sentence, one function above the
-- place that read a finding off its silence.  Output over the real record
-- is byte-identical before and after.
--
-- The same defect stood in the two sibling readers of the same record and
-- was repaired in the two commits before this one.
module Main (main) where

import MulaPramana_ACitationNamesAFixedObjectOrItIsNotOne
  (Calat(..), calatGloss, scanLine)

import Data.Char (isHexDigit, isSpace, isUpper)
import Data.List (isInfixOf, isPrefixOf, nub, sort)
import GHC.IO.Encoding (setFileSystemEncoding, setLocaleEncoding, utf8)
import Control.Exception (try, IOException)
import System.Directory (doesFileExist)
import System.Exit (ExitCode(..), exitWith)
import System.IO
import System.Process (readProcessWithExitCode)

lekha :: FilePath
lekha = "machine/dosa.lekha"

registry :: String
registry = "machine/mula.pramana"

-- ─────────────────────────────────────────────────────────── the record

-- | One line of the log, with the doṣa it belongs to and its field key.
data Pada = Pada
  { padaDosa  :: String   -- ^ the four-digit id, or "----" before the first
  , padaField :: String   -- ^ the field key, "" for a continuation line
  , padaText  :: String   -- ^ the line, left-trimmed
  } deriving (Eq, Show)

padas :: String -> [Pada]
padas src = go "----" (lines src)
  where
    go _   []     = []
    go cur (l:ls)
      | "dosa " `isPrefixOf` l = go (trim (drop 5 l)) ls
      | null t || "#" `isPrefixOf` t || t == "." = go cur ls
      | otherwise = Pada cur (fieldOf t) t : go cur ls
      where t = dropWhile isSpace l
    fieldOf t = case break (== ':') t of
      (k, ':':_) | not (null k), all fieldChar k -> k
      _ -> ""
    fieldChar c = c `elem` ("abcdefghijklmnopqrstuvwxyz-" :: String)

trim :: String -> String
trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

-- ─────────────────────────────────────────────────── the three rules

-- | Why a hit was moved out of the count.  A hit that is not moved is a
--   citation that names a moving object and stands.
data Svarupa
  = Case      -- ^ S1: lowercase `head`; no record uses it as a revision
  | Apposed   -- ^ S2: `HEAD` with a hash beside it; the hash is the object
  | Exhibit   -- ^ S3: quoted inside `nasta` or `hetu`, which exhibit
  deriving (Eq, Ord, Show)

svarupaRule :: Svarupa -> String
svarupaRule Case =
  "S1 case: lowercase `head` -- Haskell's list function, the shell"
  ++ " utility, or the English noun.  A git revision is written HEAD"
svarupaRule Apposed =
  "S2 apposition: a commit hash stands on the same line, so the hash is"
  ++ " what is named and the word HEAD says only where it stood"
svarupaRule Exhibit =
  "S3 field: quoted inside `nasta` or `hetu`, which by the store's own"
  ++ " schema exhibit what was done; only vastu, sesa and punarabhinaya"
  ++ " instruct a later reader, and `dosalekha replay` reads punarabhinaya"

-- | Decide one hit.  `Nothing` means it stands as a moving citation.
adhikara :: Pada -> Calat -> Maybe Svarupa
adhikara p d
  | Shirsha w <- d, not (any isUpper w)       = Just Case
  | Shirsha _ <- d, hashOnLine                = Just Apposed
  | padaField p `elem` ["nasta", "hetu"]      = Just Exhibit
  | otherwise                                 = Nothing
  where
    hashOnLine = any looksHash (words (padaText p))
    looksHash w = let c = filter (/= ',') w
                  in length c >= 7 && length c <= 40 && all isHexDigit c

-- ───────────────────────────────────────────────────────── answering

-- | A doṣa is ANSWERED when some record names it in `uttara:` and names
--   the registry in `pramana:`.  Naming it alone is not enough: dosa 0011
--   answers 0010 and pins nothing.
answered :: [Pada] -> String -> Bool
answered ps i = or [ ans | (d, ans) <- byDosa ]
  where
    ids = nub [ padaDosa q | q <- ps ]
    byDosa = [ (d, hasUttara d && hasRegistry d) | d <- ids ]
    hasUttara d = or [ trim (drop 7 (padaText q)) == i
                     | q <- ps, padaDosa q == d, padaField q == "uttara" ]
    hasRegistry d = or [ registry `isInfixOf` padaText q
                       | q <- ps, padaDosa q == d, padaField q == "pramana" ]

-- ───────────────────────────────────────────────────────────── output

rule :: String -> IO ()
rule t = putStrLn ("\n== " ++ t ++ " " ++ replicate (max 0 (66 - length t)) '=')

main :: IO ()
main = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8; hSetEncoding stdout utf8
  putStrLn "=== SVAM RUPAM: a quoted word names itself and is not a citation ==="
  putStrLn "Panini, Astadhyayi 1.1.68, svam rupam sabdasyasabdasamjna (c. 500 BCE)"
  putStrLn ("over " ++ lekha ++ ", answered against " ++ registry)

  ok <- doesFileExist lekha
  esrc <- if ok then readFileOr lekha
                else pure (Left ("no file at " ++ lekha))
  case esrc of
    -- No tally.  Everything below is computed from `src`, and an empty
    -- `src` makes every line of it zero -- including `unanswered`, which
    -- the tally itself calls an invariant that a later record raises.  An
    -- invariant satisfied by not opening the file is not held; it is
    -- unexamined, and the two must not print the same.
    Left why -> do
      putStrLn ""
      putStrLn ("  " ++ lekha ++ " was not read: " ++ why)
      putStrLn "  no census and no tally follow.  Zeros here would satisfy"
      putStrLn "  the unanswered-invariant by not looking at the record."
      exitWith (ExitFailure 2)
    Right src -> report src

report :: String -> IO ()
report src = do
  let ps   = padas src
      hits = [ (p, d) | p <- ps, d <- nub (scanLine (padaText p)) ]
      sva  = [ (p, d, s) | (p, d) <- hits, Just s <- [adhikara p d] ]
      cal  = [ (p, d)    | (p, d) <- hits, Nothing == adhikara p d ]

  rule "svarupa -- the word names itself; NO verdict on these records"
  putStrLn "  Every line moved out of the census is printed, because a rule over"
  putStrLn "  characters does not carry the knowledge that a reader has."
  mapM_ (\(p, d, s) -> do
           putStrLn ("\n  dosa " ++ padaDosa p ++ "  field " ++ padaField p)
           putStrLn ("    " ++ svarupaRule s)
           putStrLn ("    census said: " ++ take 108 (calatGloss d))
           putStrLn ("    text: " ++ take 150 (padaText p)))
        sva

  rule "calat -- these name a moving object, and stand"
  mapM_ (\(p, d) -> do
           putStrLn ("\n  dosa " ++ padaDosa p ++ "  field " ++ padaField p
                     ++ (if answered ps (padaDosa p)
                           then "   ANSWERED -- pinned in " ++ registry
                           else "   UNANSWERED"))
           putStrLn ("    " ++ take 150 (calatGloss d))
           putStrLn ("    text: " ++ take 130 (padaText p)))
        cal

  let calIds = sort (nub [ padaDosa p | (p, _) <- cal ])
      unans  = [ i | i <- calIds, not (answered ps i) ]

  rule "the tally"
  putStrLn ("  hits reported by the census        " ++ show (length hits))
  putStrLn ("  svarupa, moved out with a rule     " ++ show (length sva))
  putStrLn ("  calat, naming a moving object      " ++ show (length cal))
  putStrLn ("  dosas carrying one                 " ++ unwords calIds)
  putStrLn ""
  putStrLn ("  unanswered: " ++ show (length unans)
            ++ (if null unans then "" else "   " ++ unwords unans))
  putStrLn "  (an invariant, not a count: a later record carrying a moving"
  putStrLn "   citation raises it and this replay diverges, which is the point)"

  rule "every S1 line in full, so the case rule is checked and not believed"
  mapM_ (\(p, _, _) -> putStrLn ("  dosa " ++ padaDosa p ++ "  " ++ padaText p))
        [ h | h@(_, _, Case) <- sva ]

  rule "self-test -- the pure laws"
  mapM_ (\(nm, o) -> putStrLn ("  " ++ (if o then "ok  " else "FAIL") ++ "  " ++ nm))
        selfTest
  let bad = length [ () | (_, False) <- selfTest ]
  putStrLn ("\n  " ++ show (length selfTest - bad) ++ " / " ++ show (length selfTest)
            ++ " pass" ++ (if bad == 0 then "" else "  -- FAILURES ABOVE"))

-- | The read, WITH the reason it failed.  This returned `out` with the
--   exit status and stderr both discarded at the pattern `(_, out, _)`, so
--   an unreadable लेख came back as `""` -- and `""` is not inert here: it
--   gives `padas "" = []`, every list below empty, and the tally prints
--   `unanswered: 0`, whose own line calls it "an invariant, not a count:
--   a later record carrying a moving citation raises it and this replay
--   diverges, which is the point".  The invariant was satisfiable by the
--   file being unopenable.  The discarded slot is `cat`'s own sentence.
readFileOr :: FilePath -> IO (Either String String)
readFileOr p = do
  r <- try (readProcessWithExitCode "cat" [p] "")
  pure $ case r of
    Left e -> Left ("cat could not be run: "
                    ++ oneLine (show (e :: IOException)))
    Right (ExitSuccess, out, _) -> Right out
    Right (_, _, err)           -> Left (oneLine err)

oneLine :: String -> String
oneLine s = case [ l | l <- lines s, not (all isSpace l) ] of
  (l : _) -> take 160 l
  []      -> "no message"

-- ───────────────────────────────────────────────────────── pure laws

selfTest :: [(String, Bool)]
selfTest =
  [ ( "the field key is read off the line, and a continuation has none"
    , let ps = padas "dosa 0042\n  hetu: a\n  | more\n.\n"
      in map padaField ps == ["hetu", ""] )

  , ( "S1 moves lowercase head; Haskell's list function is not a revision"
    , let p = Pada "0023" "yogyata-ksetra" "yogyata-ksetra: both copies are `\\vs -> head vs + 1`"
      in [ adhikara p d | d <- scanLine (padaText p) ] == [Just Case] )

  , ( "S1 does not move uppercase HEAD standing alone"
    , let p = Pada "0027" "yogyata-ksetra" "yogyata-ksetra: run at HEAD plus the working tree"
      in [ adhikara p d | d <- scanLine (padaText p) ] == [Nothing] )

  , ( "S2 moves HEAD when a hash is apposed to it"
    , let p = Pada "0024" "yogyata-drsta" "yogyata-drsta: ran the probe at HEAD a8b6435a on this container"
      in [ adhikara p d | d <- scanLine (padaText p) ] == [Just Apposed] )

  , ( "S3 moves a count quoted inside nasta, which exhibits"
    , let p = Pada "0007" "nasta" "nasta: the run, exhibited: `grep -c 'pratiyogin' x.md` = 2"
      in all (== Just Exhibit) [ adhikara p d | d <- scanLine (padaText p) ] )

  , ( "S3 does not move the same count in punarabhinaya, which instructs"
    , let p = Pada "0007" "punarabhinaya" "punarabhinaya: grep -c 'pratiyogin' notes/D0020_LEDGER.md"
      in [ adhikara p d | d <- scanLine (padaText p) ] == [Nothing] )

  , ( "a bare position in vastu stands: vastu names the object"
    , let p = Pada "0001" "vastu" "vastu: machine/MathMachine.hs:2408"
      in [ adhikara p d | d <- scanLine (padaText p) ] == [Nothing] )

  , ( "uttara alone does not answer; the registry must be named too"
    , let ps = padas (unlines
                 [ "dosa 0010", "  hetu: x", ".", "dosa 0011"
                 , "  uttara: 0010", "  pramana: Kumarila", "." ])
      in not (answered ps "0010") )

  , ( "uttara plus a pramana naming the registry answers"
    , let ps = padas (unlines
                 [ "dosa 0010", "  hetu: x", ".", "dosa 0011"
                 , "  uttara: 0010", "  pramana: " ++ registry, "." ])
      in answered ps "0010" )

  , ( "the three rules are three and are not collapsed to a bit"
    , length (nub [Case, Apposed, Exhibit]) == 3
      && length (nub (map svarupaRule [Case, Apposed, Exhibit])) == 3 )
  ]
