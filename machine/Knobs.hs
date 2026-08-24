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

-- Knobs -- MathMachine's tunable constants, as data instead of as source text.
--
--   ghc -O1 machine/Knobs.hs -o machine/knobs && machine/knobs      # self-test
--   machine/knobs --print-defaults                                  # a template
--   machine/knobs --check machine/knobs.conf                        # validate
--
-- WHAT THIS IS FOR, AND WHAT IT IS NOT.
--
-- MathMachine.hs carries a KNOBS banner whose own text says: "HONEST STATUS:
-- nothing rewrites them yet.  The evolve step (mutate source, compile variant,
-- race it, exec the winner) is designed and not built."  This module builds
-- exactly the first word of that sentence and nothing else.  It makes the
-- constants ADDRESSABLE -- a record, a file format, a checked reader, a
-- printer.  It does not mutate MathMachine.hs, it does not choose a knob
-- setting, and it does not exec anything.  Its companion machine/race-variants.sh
-- measures settings and prints a table; the table is a RECOMMENDATION for a
-- person to act on.  Selection with no human in the loop is out of scope here
-- on purpose, and writing this header in the present tense about a step that
-- does not exist is the founding sin of this repository.
--
-- THE FILE FORMAT.  `machine/knobs.conf`, one `key = value` per line, `#` to
-- end of line is a comment, blank lines ignored.  Keys are the Haskell
-- identifiers themselves, so the file greps against the banner it replaces.
-- Absent keys take their default.  Four things are HARD ERRORS, never
-- warnings and never silent fallbacks:
--
--   * an unknown key            (a typo silently ignored is a knob that
--                                did not move in a race that says it did)
--   * a repeated key            (which of the two won is not a question a
--                                measurement should have to ask)
--   * a value that is not a whole number
--   * a value outside its range, with the range and its reason named
--
-- ABOUT THE RANGES.  Each bound below is labelled SEMANTIC or GUARD, and the
-- distinction is load-bearing.  A SEMANTIC bound is derived from the engine's
-- own code and is stated with the derivation: outside it the machine does not
-- do a worse job, it does a different thing (states no theorem, never
-- terminates, generates a certificate Agda cannot read).  A GUARD is a fence
-- against a typo costing an afternoon.  It has no mathematical content and
-- says so, because a number presented without its reason looks like knowledge.
--
-- Dependencies: base and directory, both shipped with GHC.  The only IO is
-- reading and writing the one file, plus the self-test's temporary copy of it.

module Knobs
  ( Knobs (..)
  , defaultKnobs
  , KnobSpec (..)
  , BoundKind (..)
  , knobSpecs
  , parseKnobs
  , renderKnobs
  , coherenceProblems
  , defaultKnobsPath
  , readKnobsFile
  , writeKnobsFile
  , loadKnobs
  , selfTest
  , main
  ) where

import Control.Exception (bracket_)
import Control.Monad (forM_, unless)
import Data.Char (isSpace)
import Data.List (intercalate, isInfixOf, nub)
import System.Directory (doesFileExist, getTemporaryDirectory, removeFile)
import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess)
import System.IO (hClose, hPutStrLn, openTempFile, stderr)

-- ------------------------------------------------------------------ the set

-- The seven constants of MathMachine.hs's KNOBS banner, in banner order.
-- Field names are the banner's own identifiers, so `kProbe` here and `kProbe`
-- there are the same word and a reader never has to translate.
data Knobs = Knobs
  { kProbe       :: !Int
  , kAssign      :: !Int
  , kMinPrune    :: !Int
  , kConceptMin  :: !Int
  , kConceptGain :: !Int
  , kVars        :: !Int
  , kSizeCap     :: !Int
  } deriving (Eq, Show)

-- The values in the banner as of this writing.  This is the default so that
-- an absent or empty machine/knobs.conf reproduces today's engine exactly:
-- introducing the file must not by itself change a single measurement.
defaultKnobs :: Knobs
defaultKnobs = Knobs
  { kProbe       = 400
  , kAssign      = 40
  , kMinPrune    = 1
  , kConceptMin  = 8
  , kConceptGain = 8
  , kVars        = 3
  , kSizeCap     = 7
  }

data BoundKind = Semantic | Guard deriving (Eq, Show)

data KnobSpec = KnobSpec
  { knobName  :: String
  , knobGet   :: Knobs -> Int
  , knobSet   :: Int -> Knobs -> Knobs
  , knobMin   :: Int
  , knobMax   :: Int
  , knobLoKind :: BoundKind
  , knobHiKind :: BoundKind
  , knobRole  :: String   -- one line: what the constant does in the engine
  , knobWhy   :: String   -- why the bounds are where they are
  }

knobSpecs :: [KnobSpec]
knobSpecs =
  [ KnobSpec
      { knobName = "kProbe"
      , knobGet = kProbe
      , knobSet = \v k -> k { kProbe = v }
      , knobMin = 1
      , knobMax = 1000000
      , knobLoKind = Semantic
      , knobHiKind = Guard
      , knobRole = "size of the term sample the value gates are measured on"
      , knobWhy =
          "floor SEMANTIC: the probe is `take kProbe normed`, so at 0 it is "
          ++ "empty, marginalPrune is 0 for every candidate, and with any "
          ++ "positive kMinPrune no proof is ever installed.  ceiling GUARD: "
          ++ "`take` saturates at the number of normal forms, so there is no "
          ++ "semantic ceiling; this one only fences a typo."
      }
  , KnobSpec
      { knobName = "kAssign"
      , knobGet = kAssign
      , knobSet = \v k -> k { kAssign = v }
      , knobMin = 1
      , knobMax = 100000
      , knobLoKind = Semantic
      , knobHiKind = Guard
      , knobRole = "how many random environments a fingerprint is taken over"
      , knobWhy =
          "floor SEMANTIC: `assignments nv 0 = []`, and with no environments "
          ++ "every term fingerprints to the empty list, so every pair of "
          ++ "terms is conjectured equal and refutation stops working "
          ++ "entirely.  Negative counts do not terminate: the recursion's "
          ++ "only base case is `go _ 0`.  ceiling GUARD: cost is linear "
          ++ "here, so the fence is against a typo, not a cliff."
      }
  , KnobSpec
      { knobName = "kMinPrune"
      , knobGet = kMinPrune
      , knobSet = \v k -> k { kMinPrune = v }
      , knobMin = 0
      , knobMax = 1000000
      , knobLoKind = Semantic
      , knobHiKind = Guard
      , knobRole = "normal forms a theorem must collapse before it is kept"
      , knobWhy =
          "floor SEMANTIC: the gate is `marginalPrune < kMinPrune`, so 0 "
          ++ "disables it and every negative value is that same setting "
          ++ "spelled worse.  ceiling GUARD, but see the coherence law: "
          ++ "marginalPrune is bounded by kProbe - 1, so the effective "
          ++ "ceiling is kProbe and it is checked separately."
      }
  , KnobSpec
      { knobName = "kConceptMin"
      , knobGet = kConceptMin
      , knobSet = \v k -> k { kConceptMin = v }
      , knobMin = 1
      , knobMax = 1000000
      , knobLoKind = Semantic
      , knobHiKind = Guard
      , knobRole = "times a shape must recur before it is a naming candidate"
      , knobWhy =
          "floor SEMANTIC: it is compared against an occurrence tally, which "
          ++ "is at least 1 by construction, so 1 and every value below it "
          ++ "are the same setting -- the vacuous one.  ceiling GUARD: a "
          ++ "pattern may occur many times per probe term, so no bound "
          ++ "follows from kProbe."
      }
  , KnobSpec
      { knobName = "kConceptGain"
      , knobGet = kConceptGain
      , knobSet = \v k -> k { kConceptGain = v }
      , knobMin = 0
      , knobMax = 1000000
      , knobLoKind = Semantic
      , knobHiKind = Guard
      , knobRole = "symbols a new name must save across the probe"
      , knobWhy =
          "floor SEMANTIC: 0 admits any name that does not lengthen the "
          ++ "description, and a negative threshold asserts that a name "
          ++ "making the description longer is worth having, which "
          ++ "contradicts the only currency the banner says a DEFINITION "
          ++ "can be paid in.  ceiling GUARD."
      }
  , KnobSpec
      { knobName = "kVars"
      , knobGet = kVars
      , knobSet = \v k -> k { kVars = v }
      , knobMin = 1
      , knobMax = 6
      , knobLoKind = Semantic
      , knobHiKind = Semantic
      , knobRole = "distinct variables the term generator may use"
      , knobWhy =
          "floor SEMANTIC: with no variables the machine generates ground "
          ++ "terms only and states no general theorem.  ceiling SEMANTIC "
          ++ "and derived, not chosen: `agdaTerm (V i)` is Nothing for "
          ++ "i >= 6 and `agdaCertificate` binds exactly (x y z u v w), so "
          ++ "any equation mentioning a seventh variable is KERNEL-SKIPped.  "
          ++ "Above 6 the extra variables can enlarge the search and can "
          ++ "never enlarge the library."
      }
  , KnobSpec
      { knobName = "kSizeCap"
      , knobGet = kSizeCap
      , knobSet = \v k -> k { kSizeCap = v }
      , knobMin = 1
      , knobMax = 32
      , knobLoKind = Semantic
      , knobHiKind = Guard
      , knobRole = "ceiling the size horizon may deepen to"
      , knobWhy =
          "floor SEMANTIC: the horizon is a term-size bound and below 1 no "
          ++ "term is generated.  Note the machine starts at horizon 4, so "
          ++ "any cap at or below 4 does not shrink the search -- it disables "
          ++ "the Deepen move and leaves only Widen, which is a setting "
          ++ "worth racing rather than an error.  ceiling GUARD: the term "
          ++ "count grows superexponentially in the bound, so this fence is "
          ++ "against an afternoon, not against a wrong answer."
      }
  ]

-- ------------------------------------------------------- the coherence law

-- One constraint that no single-knob range can express, and that is derived
-- rather than tasteful.
--
--   marginalPrune rules probe c = before - after,  where `before` and `after`
--   count DISTINCT normal forms of the same probe of at most kProbe terms.
--   A nonempty probe has at least one normal form under any rule set, so
--   after >= 1 whenever before >= 1, and hence
--
--       marginalPrune <= kProbe - 1.
--
--   The gate rejects a proof when marginalPrune < kMinPrune.  So at
--   kMinPrune >= kProbe the gate rejects every candidate that will ever be
--   offered, the library stays empty, and the run looks like a machine that
--   cannot prove anything rather than one whose gate is shut.  That failure
--   is indistinguishable from a real result in a race table, which is
--   precisely why it is refused at load time instead.
coherenceProblems :: Knobs -> [String]
coherenceProblems k
  | kMinPrune k >= kProbe k =
      [ "kMinPrune = " ++ show (kMinPrune k) ++ " with kProbe = "
        ++ show (kProbe k) ++ ": marginalPrune is at most kProbe - 1 = "
        ++ show (kProbe k - 1) ++ ", so this gate rejects every proof and "
        ++ "the run would report an empty library as if it were a finding.  "
        ++ "Require kMinPrune < kProbe." ]
  | otherwise = []

-- ---------------------------------------------------------------- the parser

-- Overrides are applied to `base`, so an absent key means "leave it alone"
-- and an empty file is exactly `base`.
parseKnobs :: Knobs -> String -> Either String Knobs
parseKnobs base text = do
  entries <- concat <$> mapM parseLine (zip [1 :: Int ..] (lines text))
  checkDuplicates entries
  knobs <- foldl (\acc entry -> acc >>= applyEntry entry) (Right base) entries
  case coherenceProblems knobs of
    []      -> Right knobs
    (why:_) -> Left ("incoherent knob set: " ++ why)

data Entry = Entry !Int !String !Int

parseLine :: (Int, String) -> Either String [Entry]
parseLine (lineNo, raw)
  | null stripped = Right []
  | otherwise = case break (== '=') stripped of
      (_, "") -> Left (at lineNo ("expected `key = value`, found: " ++ stripped))
      (keyText, _ : valueText) -> do
        let key = trim keyText
            value = trim valueText
        spec <- findSpec lineNo key
        n <- readInt lineNo key value
        checkRange lineNo spec n
        Right [Entry lineNo key n]
  where
    stripped = trim (takeWhile (/= '#') raw)

findSpec :: Int -> String -> Either String KnobSpec
findSpec lineNo key =
  case [ s | s <- knobSpecs, knobName s == key ] of
    (s:_) -> Right s
    []    -> Left (at lineNo
      ("unknown knob `" ++ key ++ "`.  Known knobs: "
        ++ intercalate ", " (map knobName knobSpecs)
        ++ ".  (An ignored typo is a knob that did not move in a race that "
        ++ "reports that it did, so this is an error, not a warning.)"))

readInt :: Int -> String -> String -> Either String Int
readInt lineNo key value = case reads value of
  [(n, rest)] | all isSpace rest -> Right n
  _ -> Left (at lineNo
    ("`" ++ key ++ "` needs a whole number, found: " ++ show value))

checkRange :: Int -> KnobSpec -> Int -> Either String ()
checkRange lineNo spec n
  | n >= knobMin spec && n <= knobMax spec = Right ()
  | otherwise = Left (at lineNo
      ("`" ++ knobName spec ++ " = " ++ show n ++ "` is out of range ["
        ++ show (knobMin spec) ++ ", " ++ show (knobMax spec) ++ "] ("
        ++ show (knobLoKind spec) ++ " floor, " ++ show (knobHiKind spec)
        ++ " ceiling).  " ++ knobRole spec ++ ".  " ++ knobWhy spec))

checkDuplicates :: [Entry] -> Either String ()
checkDuplicates entries =
  case [ key | key <- nub keys, length (filter (== key) keys) > 1 ] of
    [] -> Right ()
    (key:_) ->
      let lns = [ n | Entry n k _ <- entries, k == key ]
      in Left ("`" ++ key ++ "` is set more than once, on lines "
                ++ intercalate ", " (map show lns)
                ++ ".  Which one wins is not a question a measurement "
                ++ "should have to ask.")
  where keys = [ k | Entry _ k _ <- entries ]

applyEntry :: Entry -> Knobs -> Either String Knobs
applyEntry (Entry lineNo key n) knobs = do
  spec <- findSpec lineNo key
  Right (knobSet spec n knobs)

at :: Int -> String -> String
at lineNo message = "line " ++ show lineNo ++ ": " ++ message

trim :: String -> String
trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

-- --------------------------------------------------------------- the printer

-- Every knob is written, including the ones at their default, so the file is
-- a complete statement of the setting rather than a diff against a banner
-- that may since have moved.  `parseKnobs defaultKnobs . renderKnobs` is the
-- identity; the self-test below checks that rather than asserting it.
renderKnobs :: Knobs -> String
renderKnobs knobs = unlines (header ++ concatMap entry knobSpecs ++ footer)
  where
    header =
      [ "# machine/knobs.conf -- MathMachine's KNOBS, as data."
      , "#"
      , "# Written by machine/Knobs.hs.  Keys are the engine's own"
      , "# identifiers; `#` comments to end of line; absent keys take their"
      , "# default.  An unknown key, a repeated key, a non-integer value or"
      , "# an out-of-range value is a hard error, not a warning."
      , "#"
      , "# Each range is labelled SEMANTIC (derived from the engine's code,"
      , "# stated with its derivation in machine/Knobs.hs) or GUARD (a fence"
      , "# against a typo, with no mathematical content)."
      , "#"
      , "# Nothing reads this file and then rewrites MathMachine.hs.  A"
      , "# setting gets adopted when a person adopts it."
      , ""
      ]
    entry spec =
      [ "# " ++ knobName spec ++ ": " ++ knobRole spec
      , "#   range [" ++ show (knobMin spec) ++ ", " ++ show (knobMax spec)
          ++ "]  (" ++ show (knobLoKind spec) ++ " floor, "
          ++ show (knobHiKind spec) ++ " ceiling)"
      , knobName spec ++ " = " ++ show (knobGet spec knobs)
      , ""
      ]
    footer =
      [ "# Coherence law, derived and checked at load time:"
      , "#   kMinPrune < kProbe, because marginalPrune <= kProbe - 1."
      ]

-- ------------------------------------------------------------------ the file

defaultKnobsPath :: FilePath
defaultKnobsPath = "machine/knobs.conf"

readKnobsFile :: FilePath -> IO (Either String Knobs)
readKnobsFile path = do
  text <- readFile path
  pure $ case parseKnobs defaultKnobs text of
    Left problem -> Left (path ++ ": " ++ problem)
    Right knobs  -> Right knobs

writeKnobsFile :: FilePath -> Knobs -> IO ()
writeKnobsFile path = writeFile path . renderKnobs

-- The engine's entry point.  An absent file means "the defaults", which is
-- today's engine.  A present but unreadable file is fatal: silently falling
-- back to the defaults would make a broken override look like a knob setting
-- that simply did not help.
loadKnobs :: IO Knobs
loadKnobs = do
  present <- doesFileExist defaultKnobsPath
  if not present
    then pure defaultKnobs
    else do
      result <- readKnobsFile defaultKnobsPath
      either (ioError . userError) pure result

-- ---------------------------------------------------------------- self-test

selfTest :: IO Bool
selfTest = do
  temporary <- getTemporaryDirectory
  results <- sequence
    [ pure (check "round-trip: defaults"
        (parseKnobs defaultKnobs (renderKnobs defaultKnobs) == Right defaultKnobs))
    , pure (check "round-trip: a non-default set"
        (parseKnobs defaultKnobs (renderKnobs perturbed) == Right perturbed))
    , pure (check "round-trip: every knob differs from its default"
        (and [ knobGet s perturbed /= knobGet s defaultKnobs | s <- knobSpecs ]))
    , pure (check "overrides: absent keys keep their default"
        (parseKnobs defaultKnobs "kVars = 2\n# a comment\n\nkSizeCap = 9  # trailing\n"
          == Right defaultKnobs { kVars = 2, kSizeCap = 9 }))
    , fileRoundTrip temporary
    , pure (rejects "unknown key" "kProbes = 400\n" "unknown knob")
    , pure (rejects "out of range, range named" "kVars = 7\n" "[1, 6]")
    , pure (rejects "not a whole number" "kProbe = four hundred\n" "whole number")
    , pure (rejects "repeated key" "kProbe = 100\nkProbe = 200\n" "more than once")
    , pure (rejects "no `=` on the line" "kProbe 400\n" "expected `key = value`")
    , pure (rejects "incoherent set (kMinPrune >= kProbe)"
        "kProbe = 400\nkMinPrune = 400\n" "kMinPrune < kProbe")
    , pure (check "the coherence law is not vacuous on the defaults"
        (null (coherenceProblems defaultKnobs)))
    ]
  forM_ results $ \(ok, label, detail) ->
    putStrLn ((if ok then "PASS  " else "FAIL  ") ++ label
               ++ (if ok then "" else "   " ++ detail))
  let failed = length [ () | (False, _, _) <- results ]
  if failed == 0
    then do
      putStrLn ("KNOBS CHECKED: " ++ show (length knobSpecs)
                 ++ " knobs, " ++ show (length results)
                 ++ " checks, round-trip exact, malformed input refused")
      pure True
    else do
      putStrLn (show failed ++ " check(s) failed")
      pure False
  where
    perturbed = Knobs
      { kProbe = 250, kAssign = 64, kMinPrune = 2, kConceptMin = 5
      , kConceptGain = 12, kVars = 4, kSizeCap = 6 }

    check label ok = (ok, label, "")

    rejects label text needle = case parseKnobs defaultKnobs text of
      Right knobs -> (False, "reject: " ++ label, "accepted " ++ show knobs)
      Left problem
        | needle `isInfixOf` problem -> (True, "reject: " ++ label, "")
        | otherwise -> (False, "reject: " ++ label
                       , "refused, but the message never says " ++ show needle
                         ++ ": " ++ problem)

    fileRoundTrip temporary = do
      (path, handle) <- openTempFile temporary "knobs-selftest.conf"
      hClose handle
      bracket_ (pure ()) (removeFile path) $ do
        writeKnobsFile path perturbed
        result <- readKnobsFile path
        pure (check "round-trip: through a real file"
                (result == Right perturbed))

-- -------------------------------------------------------------------- driver

usage :: String
usage = unlines
  [ "usage: knobs [--self-test | --print-defaults | --check FILE]"
  , "  --self-test       round-trip a knob set and refuse malformed input"
  , "                    (the default with no arguments)"
  , "  --print-defaults  write a complete machine/knobs.conf template"
  , "  --check FILE      parse FILE against the defaults and print the"
  , "                    canonical rendering; nonzero exit if it is bad"
  ]

main :: IO ()
main = do
  args <- getArgs
  case args of
    []              -> runSelfTest
    ["--self-test"] -> runSelfTest
    ["--print-defaults"] -> putStr (renderKnobs defaultKnobs)
    ["--check", path] -> do
      result <- readKnobsFile path
      case result of
        Left problem -> hPutStrLn stderr problem >> exitFailure
        Right knobs  -> putStr (renderKnobs knobs)
    ["-h"]     -> putStr usage
    ["--help"] -> putStr usage
    _ -> hPutStrLn stderr usage >> exitFailure
  where
    runSelfTest = do
      ok <- selfTest
      unless ok exitFailure
      exitSuccess
