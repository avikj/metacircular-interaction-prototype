-- Yogyata -- योग्यता, fitness: which knowledge here is in the reactor and
-- which is on a shelf, established as an ABSENCE that is warranted rather
-- than asserted.
--
-- WHY THIS EXISTS, and it is not a hypothetical.  On 2026-08-19
-- machine/Upamana.hs was found to be 896 lines implementing the third
-- pramana -- sourced, dated, with the gavaya in its header and a section 9
-- posing Dignaga's reduction question to the engine -- imported by NOTHING.
-- machine/Pramana.hs's own table listed upamana as ABSENT.  The header could
-- not tell a shelf from an absence, because nobody had turned the key.  When
-- the key was finally turned, three defects fell out in the first three
-- attempts, all latent since the file was written: a verdict function that
-- crashed on a symbol its own audit had already flagged, a memo table that
-- forced itself and could not terminate, and two number-theory functions
-- that did not terminate off their certified range.
--
-- None of that was findable by reading.  A module nothing imports is not
-- checked by anything, not run by anything, and reports the same as a module
-- that does not exist.  CLAUDE.md already states the rule this file obeys:
-- when something is violated repeatedly, the next move is A MECHANISM THAT
-- FIRES AT THE MOMENT OF THE ACT, not a paragraph.  The paragraph has now
-- been written twice.  This is the mechanism.
--
-- THE EPISTEMOLOGY IS NOT DECORATION.  "Nothing imports this module" is a
-- claim about an ABSENCE, and Nyaya has the exact machinery for when such a
-- claim is knowledge and when it is a guess.
--
--     ANUPALABDHI -- non-apprehension as a means of knowing -- is admitted
--     by the Bhatta Mimamsakas (Kumarila Bhatta, Slokavarttika,
--     Abhavapariccheda, c. 7th c.) and by Advaita, and is refused as
--     separate by Prabhakara, who folds it into perception.  The dispute is
--     live and this file takes no side in it.
--
--     What both sides agree on is the CONDITION.  An absence may be
--     inferred only under YOGYA-ANUPALABDHI -- FIT non-apprehension: the
--     thing must be such that it WOULD have been apprehended had it been
--     there.  You may conclude "there is no pot on the floor" from not
--     seeing one; you may not conclude "there is no ghost in the room" the
--     same way, because a ghost is not the kind of thing your looking would
--     have caught.  The absence is knowledge exactly to the extent that the
--     looking was fit to find it.
--
-- So every verdict below CARRIES ITS DOMAIN: how many files were read, which
-- directories, and which entry points were treated as roots.  An inertness
-- verdict without that is unwarranted, and this module will not emit one.
-- The same discipline is already in machine/Obstruction.hs, whose Aviruddha
-- carries the domain searched rather than a bare "unrefuted"; this is that
-- pattern applied to the corpus instead of to a term.
--
-- THREE STATES, NOT TWO.  A boolean would collapse distinctions that matter:
--
--   Reactor   reachable from an entry point.  Something runs it.
--   Shelf     imported by something, but that something is not reachable
--             from any entry point either.  A closed loop off to the side --
--             the whole component is inert, and reading any one file in it
--             tells you nothing about that.
--   Orphan    imported by nothing at all.  Upamana was here.
--
-- Adding "no entry point exists for this language" as a fourth state would
-- be a different claim again and is reported separately rather than folded
-- in, for the same reason Obstruction distinguishes Tusnim from Khandita.
--
-- Exact, no measurement: the import graph is read off the text and the
-- reachability is a finite closure.  Nothing here is sampled or estimated.

module Yogyata
  ( Sthiti(..)
  , Unit(..)
  , Yogya(..)
  , parseUnit
  , reachable
  , survey
  , renderSurvey
  ) where

import Data.Char (isSpace, isUpper, isAlphaNum)
import Data.List (isPrefixOf, isSuffixOf, sort, nub, partition)
import qualified Data.Map.Strict as M
import qualified Data.Set as S

------------------------------------------------------------------------
-- 1.  A unit of the corpus.
------------------------------------------------------------------------

data Sthiti = Reactor | Shelf | Orphan
  deriving (Eq, Ord, Show)

data Unit = Unit
  { uPath    :: FilePath
  , uName    :: String          -- the module name it declares
  , uImports :: [String]        -- module names it imports
  , uLines   :: Int
  , uIsEntry :: Bool            -- is it a root: Main, or a declared gate
  } deriving (Show)

-- Read one file into a Unit.  Both languages spell the two things we need
-- almost the same way, so one parser serves; the difference is only that
-- Agda writes `open import` and Haskell writes `import qualified`.
parseUnit :: [String]           -- ^ module names to treat as gates
          -> FilePath -> String -> Unit
parseUnit gates path src = Unit
  { uPath    = path
  , uName    = nm
  , uImports = nub [ m | Just m <- map importOf ls ]
  , uLines   = length ls
  , uIsEntry = nm == "Main" || nm `elem` gates || any isMainDecl ls
  }
  where
    ls = lines src
    nm = case [ m | Just m <- map moduleOf ls ] of
           (m : _) -> m
           []      -> baseName path

    isMainDecl l = "main ::" `isPrefixOf` dropWhile isSpace l

    moduleOf l = case words (stripComment l) of
      ("module" : m : _) -> Just (takeWhile (/= '(') m)
      _                  -> Nothing

    importOf l = case words (stripComment l) of
      ("import" : rest)          -> firstModule rest
      ("open" : "import" : rest) -> firstModule rest
      _                          -> Nothing

    firstModule ws = case dropWhile (== "qualified") ws of
      (m : _) | not (null m) && isUpper (head m) -> Just (sanitize m)
      _                                          -> Nothing

    sanitize = takeWhile (\c -> isAlphaNum c || c == '.' || c == '_' || c == '\'')

    -- enough to keep a commented-out import from counting as an import
    stripComment l = go l
      where go ('-' : '-' : _) = []
            go (c : cs)        = c : go cs
            go []              = []

baseName :: FilePath -> String
baseName p = reverse (takeWhile (/= '/') (reverse (dropExt p)))
  where dropExt q = if any (`isSuffixOf` q) [".hs", ".agda"]
                      then reverse (drop 1 (dropWhile (/= '.') (reverse q)))
                      else q

------------------------------------------------------------------------
-- 2.  Reachability -- a finite closure, so the verdict is exact.
------------------------------------------------------------------------

reachable :: [Unit] -> S.Set String
reachable us = go (S.fromList [ uName u | u <- us, uIsEntry u ]) S.empty
  where
    byName = M.fromList [ (uName u, u) | u <- us ]
    go frontier seen
      | S.null frontier = seen
      | otherwise =
          let seen'  = S.union seen frontier
              next   = S.fromList
                         [ i | n <- S.toList frontier
                             , Just u <- [M.lookup n byName]
                             , i <- uImports u
                             , M.member i byName ]
          in go (S.difference next seen') seen'

------------------------------------------------------------------------
-- 3.  The survey, with its own fitness attached.
--
-- `Yogya` is the verdict TOGETHER WITH the looking that warrants it.  There
-- is deliberately no way to obtain the verdicts without the domain: the
-- record has no constructor that omits it, which is the whole point of
-- yogya-anupalabdhi rendered as a type rather than as a comment.
------------------------------------------------------------------------

data Yogya = Yogya
  { yUnits    :: [(Unit, Sthiti)]
  , yScanned  :: Int            -- files read: the extent of the looking
  , yDirs     :: [FilePath]     -- where it looked
  , yEntries  :: [String]       -- what it treated as roots
  , yNoEntry  :: Bool           -- no root found at all: verdicts are void
  } deriving (Show)

survey :: [FilePath] -> [Unit] -> Yogya
survey dirs us = Yogya
  { yUnits   = [ (u, classify u) | u <- us ]
  , yScanned = length us
  , yDirs    = dirs
  , yEntries = sort [ uName u | u <- us, uIsEntry u ]
  , yNoEntry = null [ () | u <- us, uIsEntry u ]
  }
  where
    live = reachable us
    importedBy = M.fromListWith (+)
      [ (i, 1 :: Int) | u <- us, i <- uImports u ]
    classify u
      | S.member (uName u) live                = Reactor
      | M.findWithDefault 0 (uName u) importedBy > 0 = Shelf
      | otherwise                              = Orphan

------------------------------------------------------------------------
-- 4.  Reporting.  The domain is printed BEFORE the verdicts, not after,
-- because a reader who stops early must not walk away with the conclusion
-- and none of the fitness.
------------------------------------------------------------------------

renderSurvey :: Yogya -> [String]
renderSurvey y =
  [ "=== YOGYATA ==="
  , "Kumarila Bhatta, Slokavarttika, Abhavapariccheda (c. 7th c.):"
  , "anupalabdhi as a means of knowing an absence -- admitted by the"
  , "Bhattas and by Advaita, refused as separate by Prabhakara, who folds"
  , "it into perception.  This file takes no side; it obeys the condition"
  , "both sides impose."
  , ""
  , "THE LOOKING, stated first, because the verdicts are worth exactly as"
  , "much as it is (yogya-anupalabdhi -- fit non-apprehension):"
  , "  files read        : " ++ show (yScanned y)
  , "  directories       : " ++ unwords (yDirs y)
  , "  roots (entry pts) : " ++ show (length (yEntries y))
  ] ++
  (if yNoEntry y
     then [ ""
          , "NO ROOT FOUND.  Every verdict below would be vacuous -- with no"
          , "entry point nothing is reachable and everything reads as inert."
          , "Refusing to emit them." ]
     else
       [ "" ] ++
       section "IN THE REACTOR" Reactor ++
       [ "" ] ++
       section "ON A SHELF -- imported, but only by things that are themselves inert" Shelf ++
       [ "" ] ++
       section "ORPHANED -- imported by nothing at all" Orphan ++
       [ ""
       , "  reactor " ++ show (count Reactor)
         ++ "   shelf " ++ show (count Shelf)
         ++ "   orphan " ++ show (count Orphan)
       , ""
       , "An orphan is not a verdict about quality.  machine/Upamana.hs was"
       , "an orphan on 2026-08-19 and was correct, careful and sourced -- and"
       , "carried three defects that no amount of reading would have found,"
       , "because nothing ran it.  The claim here is only this: nothing in"
       , "the domain above imports it, so nothing checks it."
       ])
  where
    count s = length [ () | (_, s') <- yUnits y, s' == s ]
    section title s =
      (title ++ ":") :
      case sort [ (uPath u, uLines u) | (u, s') <- yUnits y, s' == s ] of
        [] -> [ "  (none)" ]
        xs -> [ "  " ++ pad 44 p ++ show n ++ " lines" | (p, n) <- xs ]
    pad n str = str ++ replicate (max 0 (n - length str)) ' '

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only; nothing here corrects this module.
--
-- The condition this file is built on -- yogya-anupalabdhi, an absence
-- is knowledge to the extent the looking was fit to find it -- is now a
-- checked theorem, with its converse, in
-- `formal/cubical/NaturalMachine/FitnessIsNecessaryUpToDoubleNegation.agda`
-- (--safe, no postulates, no holes).
--
--   fitAbsenceIsAbsolute  Yogya D P -> AbsenceOn D P -> (x) -> not (P x)
--   unfitAbsenceIsUnwarranted
--                         a clean search over an unfit domain, with the
--                         sought thing demonstrably present
--   fitnessIsNecessaryUpToDoubleNegation
--                         if a domain licenses EVERY absence, it is
--                         total -- but only under not-not
--   stableDomainMakesItTotal
--                         and the residue is stability OF THE DOMAIN,
--                         not of the thing sought
--
-- The last two are the half this file's prose does not state, and they
-- say something operational about it: "the domain searched" cannot be
-- upgraded to "everything" by any amount of clean searching; what closes
-- that gap is a decidability/stability fact about the domain itself --
-- here, that the file set is finite and enumerable.  This module already
-- relies on that (the import graph is read off the text and reachability
-- is a finite closure); the theorem says that reliance is load-bearing
-- and not incidental.
--
-- The Bhatta / Prabhakara dispute is untouched there, as here: both
-- sides accept the fitness condition and only that is used.  No verdict
-- about this repository's import graph is claimed there -- the three
-- states Reactor / Shelf / Orphan are this file's object, not that one's.
-- ---------------------------------------------------------------------
