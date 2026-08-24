-- Samshaya.hs -- how many OPEN PROBLEMS does this corpus actually have?
--
-- SOURCE AND FORM.  Gautama, Nyayasutra 1.1.1, lists sixteen padarthas and
-- the third is SAMSAYA, doubt -- placed among the objects of knowledge in
-- its own right, not as a defect.  1.1.23 gives the causes of doubt: doubt
-- arises from features shared between alternatives, from features peculiar
-- to none, from conflicting testimony, and from irregularity of
-- apprehension.  What matters for this file is the placement: a genuine
-- doubt is a TYPED OBJECT with a cause, and a question with no cause
-- behind it is not doubt -- it is a sentence in the interrogative.
--
-- NOT CLAIMED: that Gautama or Vatsyayana classified research queues.
-- Taken: that doubt is typed by its cause, and that untyped doubt is not
-- doubt.  GRADE: author, work, and the doctrine each is known for; 1.1.1
-- and 1.1.23 are numbers I can state.
--
-- WHY.  This corpus carries 771 items tagged PROVE / SEARCH /
-- DEMONSTRATE.  Closing 771 items one at a time is the volume reflex the
-- repository has been corrected for twice.  The prior question, never
-- asked, is how many of the 771 are DOUBTS AT ALL:
--
--   * an item already struck or answered in place is not open;
--   * an item that is another item said in different words is one doubt,
--     not two -- and machine/Naya.hs already DECIDES that, so this file
--     does not invent a second theory of sameness;
--   * an item with no content beyond the tag is not a doubt.
--
-- The answer is a measurement, and it is exact rather than heuristic:
-- closure markers are textual facts, not judgements.

module Samshaya where

import Data.List (isInfixOf, isPrefixOf, sort, nub, sortOn, group)
import Data.Char (toLower, isAlpha, isSpace)
import qualified Data.Map.Strict as M
import Naya (Naya(..), Verdict(..), decide)

data Tag = Prove | Search | Demonstrate deriving (Eq, Ord, Show)

data Item = Item
  { itFile  :: FilePath
  , itLine  :: Int
  , itTag   :: Tag
  , itText  :: String
  }

-- | Textual closure: the item says, in place, that it is answered.
--   Only markers this corpus actually uses.
closureMarkers :: [String]
closureMarkers =
  [ "SETTLED", "CLOSED", "RESOLVED", "ANSWERED", "WITHDRAWN", "DONE --"
  , "NO LONGER OPEN", "SUPERSEDED", "STRUCK", "RETRACTED" ]

isClosed :: Item -> Bool
isClosed it =
  let t = itText it
  in any (`isInfixOf` t) closureMarkers
     || ("~~" `isInfixOf` t && tagWord (itTag it) `isInfixOf` afterStrike t)
  where
    afterStrike s = drop (length (takeWhile (/= '~') s)) s

tagWord :: Tag -> String
tagWord Prove = "PROVE"
tagWord Search = "SEARCH"
tagWord Demonstrate = "DEMONSTRATE"

-- | Content words: the distinctive vocabulary of the item, which is what
--   two items being "the same doubt" has to mean.  Stopwords and the tag
--   words themselves are removed; short words are dropped because they
--   carry no discrimination (the lesson of the 47-of-60 term check).
stop :: [String]
stop = words "the that this with from have been will would could item note \
             \which whether there where when what these those about into over \
             \under above below than then thus also only some more most such \
             \does doing done make makes made take takes taken give gives \
             \given here corpus repo repository section prove search \
             \demonstrate open still tagged block blocks anyone wants first \
             \second third case cases form forms line lines file files"

contentWords :: String -> [String]
contentWords s =
  nub (sort [ w | w <- words (map norm s)
            , length w >= 6, w `notElem` stop ])
  where norm c = if isAlpha c then toLower c else ' '

toNaya :: Item -> Naya
toNaya it = Naya (itFile it ++ ":" ++ show (itLine it)) (contentWords (itText it))

-- | Two items are the SAME DOUBT when Naya.decide says their standpoints
--   may be collapsed.  This is the load-bearing reuse: the corpus's own
--   collapse rule, applied to the corpus's own queue.
sameDoubt :: Item -> Item -> Bool
sameDoubt a b = case decide True [toNaya a, toNaya b] of
  Ekartha _ _ -> True
  _           -> False

-- | Distinct doubts.
--
-- `sameDoubt` is the DEFINITION and `machine/Naya.hs` is where it lives.
-- This does not re-implement it: `Ekartha` fires exactly when the two
-- content sets are equal -- both are already nub'd and sorted by
-- `contentWords`, `content` re-sorts, and `mutuallyEntail` holds because
-- both are inhabited -- so grouping by the content set computes the same
-- function in O(n log n) rather than O(n^2).
--
-- The equivalence is CHECKED on a sample at run time, not asserted.
-- 594k `decide` calls did not finish; "this optimisation is obviously
-- sound" is how a wrong number gets published, so `SamshayaRun.hs`
-- verifies the two agree on a sample before printing anything.
distinct :: [Item] -> [[Item]]
distinct its =
  M.elems (M.fromListWith (flip (++)) [ (contentWords (itText i), [i]) | i <- its ])

data Survey = Survey
  { sTotal    :: Int
  , sClosed   :: Int
  , sEmpty    :: Int
  , sOpen     :: [Item]
  , sBuckets  :: [[Item]]
  }

survey :: [Item] -> Survey
survey its =
  let closed = filter isClosed its
      live   = filter (not . isClosed) its
      empt   = filter (null . contentWords . itText) live
      real   = filter (not . null . contentWords . itText) live
  in Survey (length its) (length closed) (length empt) real (distinct real)

-- | THE FITNESS GATE, ADDED 2026-08-24, and it is my own bug caught by
--   the tree moving under me.
--
--   On 2026-08-20 this file surveyed notes/*.md and reported 1203 tags,
--   1131 distinct doubts.  On 2026-08-24 markdown was banned from the
--   repository and 3630 .md files were deleted.  The survey then printed
--
--       tagged items found : 0
--       DISTINCT DOUBTS    : 0
--
--   as if the corpus had no open problems, WITH NO REFUSAL -- which is
--   exactly the vacuous zero I had repaired in machine/YogyataRun.hs four
--   days earlier, rebuilt one file over, by me, after writing the lesson
--   down.  A survey whose looking has collapsed must say so; an unfit
--   looking's silence is not a NO (Kumarila, Slokavarttika,
--   Abhavapariccheda).
--
--   The tags did not vanish with the markdown.  63 of them survive in
--   .agda, .hs and .txt.  So the looking is retargeted AND gated: zero
--   files read is refused, and zero tags found in a non-empty read is
--   reported as a fact about the corpus rather than about the survey.
data Fitness = NothingRead Int | Read' Int

fitness :: Int -> Fitness
fitness 0 = NothingRead 0
fitness n = Read' n

render :: Survey -> [String]
render s = renderWith (Read' (sTotal s)) s

renderFitness :: Int -> Survey -> [String]
renderFitness filesRead s = renderWith (fitness filesRead) s

renderWith :: Fitness -> Survey -> [String]
renderWith (NothingRead _) _ =
  [ "=== SAMSAYA: how many open problems does this corpus have? ==="
  , ""
  , "  NO VERDICT ISSUED.  Zero files were read."
  , ""
  , "  Every count below would be vacuous, so none is printed.  This"
  , "  refusal exists because on 2026-08-24 the markdown ban deleted the"
  , "  3630 .md files this survey used to read, and it went on printing"
  , "  \"0 open problems\" as though that were a finding."
  , ""
  , "  An unfit looking's silence is not a NO.  Kumarila, Slokavarttika,"
  , "  Abhavapariccheda (c. 7th c.), yogya-anupalabdhi."
  ]
renderWith (Read' _) s =
  [ "=== SAMSAYA: how many open problems does this corpus have? ==="
  , "Gautama, Nyayasutra 1.1.1 (samsaya as the third padartha) and 1.1.23"
  , "(the causes of doubt).  A question with no cause behind it is not"
  , "doubt; it is a sentence in the interrogative."
  , ""
  , "THE LOOKING: every line under formal/cubical, machine, notes and"
  , ".claude carrying PROVE, SEARCH or DEMONSTRATE, with the two lines"
  , "after it.  RETARGETED 2026-08-24: it read notes/*.md until the"
  , "markdown ban deleted them.  Closure is textual and"
  , "exact.  Sameness is decided by machine/Naya.hs, not by a similarity"
  , "score."
  , ""
  , "  tagged items found              : " ++ show (sTotal s)
  , "  already closed IN PLACE         : " ++ show (sClosed s)
  , "  no content beyond the tag       : " ++ show (sEmpty s)
  , "  live items                      : " ++ show (length (sOpen s))
  , "  DISTINCT DOUBTS among them      : " ++ show (length (sBuckets s))
  , ""
  , "  compression: " ++ show (sTotal s) ++ " tags -> "
                      ++ show (length (sBuckets s)) ++ " doubts"
  ]
