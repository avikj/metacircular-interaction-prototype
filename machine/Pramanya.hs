-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Pramanya.hs -- the VALIDITY of a claim: where it comes from, and the
-- rule that it is the minimum over everything the claim rests on.
--
-- RENAMED 2026-08-20.  This was written as `Pramana.hs` and collided, in
-- the same hour, with another identity's `machine/Pramana.hs` -- six
-- means, memory records, wired into MathMachine's self-test.  Theirs
-- landed first and keeps the name.  Nothing of theirs was taken; the
-- conflict was on the filename only, and the two files are about
-- different objects.
--
-- THE RENAME IS BETTER THAN THE ORIGINAL AND THIS IS WHY.
--
-- pramanya -- validity, authoritativeness of a cognition -- is the exact
-- technical term for what this file computes, and it names a live
-- classical dispute rather than a neutral label:
--
--   svatah-pramanya   validity is INTRINSIC.  A cognition is valid by
--                     arising; invalidity is what needs a cause.  The
--                     Bhatta and Prabhakara Mimamsakas, and Kumarila
--                     argues it at length.
--   paratah-pramanya  validity is EXTRINSIC.  It is conferred from
--                     outside -- by the reliability of the source, by
--                     corroboration, by what the cognition rests on.
--                     The Nyaya position.
--
-- THIS FILE IMPLEMENTS PARATAH-PRAMANYA, AND SAYS SO RATHER THAN
-- PRETENDING TO BE NEUTRAL.  The minimum-propagation rule below IS the
-- extrinsic thesis mechanised: a claim earns nothing from arising, and
-- everything from what stands under it.
--
-- The Mimamsaka would reject the whole construction, and the objection
-- is not weak: on svatah-pramanya, demanding a warrant for every
-- cognition launches a regress that terminates nowhere, and in practice
-- a person who suspends every belief pending corroboration cannot act.
-- That objection is not answered here.  It is recorded, because a naya
-- asserting itself by denying the others is a durnaya (Siddhasena,
-- Sanmatitarka 1.21), and because this repository's rule is that the
-- dispute is content and gets kept.
--
-- What can be said in the extrinsic thesis's favour WITHOUT denying the
-- other: in a corpus, claims are not cognitions arising in a knower --
-- they are text, copied, and the copy carries no warrant with it.  The
-- regress objection bites on a mind and does not obviously bite on a
-- file.  Whether that distinction survives is exactly what the two
-- schools would argue about, and it is left open.
--
--
-- THE PROBLEM, at the only scale that matters.
--
-- Every claim in every corpus today is a sentence.  It does not carry how
-- it is known, what it rests on, or how hard anybody looked.  So a
-- sentence copied from a summary and a sentence produced by a proof are
-- the same object, and downstream nothing can tell them apart.  That is
-- how "Pell's equation" survives, how a fitted constant reaches a paper,
-- how a correction fails to propagate, and how a model trained on the
-- result reproduces all three with total fluency.
--
-- SOURCE AND FORM.  Nyaya types a cognition by the CAUSAL ROUTE that
-- produced it -- Gautama, Nyayasutra 1.1.3, four pramanas: pratyaksa
-- (perception), anumana (inference), upamana (comparison), sabda
-- (testimony).  The Bhatta Mimamsakas add anupalabdhi (non-apprehension)
-- and arthapatti (postulation); Kumarila, Slokavarttika, Abhavapariccheda
-- (c. 7th c.), and the anupalabdhi is admitted only under the FITNESS
-- condition -- yogya-anupalabdhi, that the looking was of a kind that
-- would have found the thing.
--
-- GRADE, per the discipline this file is trying to mechanise: I have
-- these at author, work and doctrine level; 1.1.3 is a number I can
-- state.  Verse numbering for the Slokavarttika is not verified here.
--
-- WHAT IS NOT CLAIMED: that Gautama or Kumarila ranked the pramanas.
-- They did not, and ranking them would be a durnaya -- a standpoint
-- asserting itself by denying the others.  So this file does NOT rank
-- them.  Route is TYPED and unranked.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ONE THING THAT IS RANKED, AND WHY IT LEGITIMATELY CAN BE.
--
-- Not the route.  The STATUS of this instance -- what was actually done.
-- "I ran the proof" and "I remember reading it" are both sabda-or-anumana
-- shaped and they are not the same act, and the difference is ordered:
--
--     Siddha       a checked term, a finite exhaustive verification, a
--                  computation that ran here
--     Drsta        the source was consulted -- text open, page read
--     Sruta        the source is cited but was not consulted
--     Anumita      derived from other claims, and inherits from them
--     Asiddha      asserted; nothing behind it
--
-- AND THE LOAD-BEARING RULE: the grade of a claim is the MINIMUM over
-- itself and everything it rests on.  A brilliant inference from an
-- unconsulted source is Sruta.  This cannot be gamed, because the
-- minimum propagates through the whole graph and no amount of downstream
-- rigour raises it.  Every "GRADE:" paragraph hand-written in this
-- repository's commit messages is this computation done by hand.

module Pramanya where

import Data.List (nub, sort, sortOn, intercalate)
import qualified Data.Map.Strict as M
import Data.Maybe (fromMaybe)

-- | The causal route.  TYPED, NOT RANKED.
data Route
  = Pratyaksa      -- perception: it was observed / the program was run
  | Anumana        -- inference
  | Upamana        -- comparison
  | Sabda          -- testimony: a text, a person, a paper
  | Anupalabdhi    -- non-apprehension: an absence
  | Arthapatti     -- postulation: the only thing that would explain it
  deriving (Eq, Ord, Show)

-- | The status of THIS instance.  Ranked, because verification is
--   genuinely ordered and nothing in the darsanas is being ranked by it.
-- ANVISTA ADDED 2026-08-20, and the reason it is not self-flattery.
--
-- The first version had no grade between "cited from memory" and "text
-- consulted", so every citation in this repository sat at Sruta.  A grade
-- added to move ones own claims up a notch is exactly the gaming the
-- minimum rule exists to stop, so: the distinction is real and it is
-- CHECKABLE.  Recall can confabulate a citation whole -- author, work,
-- date, all fluent, all invented.  A located source cannot be
-- confabulated: the search either returns something that states the claim
-- or it does not.  Different acts, different failure modes.
--
--   Anvista  a source was LOCATED that states this.  It was not read.
--
-- And it was earned before it was added.  See PramanyaRun.hs: two roots
-- were raised by actually running the searches, and both came back with
-- MORE than corroboration -- apoha is chapter 5 of the
-- Pramanasamuccayavrtti and its standard formulation is "cow" = not a
-- non-cow (so the DviApoha reading modelled in the Agda as a defensive
-- alternative is the standard one); and Madhavas correction is named
-- ANTYA-SAMSKARA, end-correction, 11 decimals from 21 terms.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CEILING ON THIS CONTAINER, MEASURED, so that Sruta and Anvista are
-- not read as laziness.
--
-- DRSTA IS UNREACHABLE HERE.  Measured 2026-08-20: WebFetch returns
-- "Unable to verify if domain gretil.sub.uni-goettingen.de is safe to
-- fetch", and curl through the agent proxy returns
--
--     curl: (56) CONNECT tunnel failed, response 403
--
-- with the proxy naming it: {"kind":"connect_rejected","detail":"gateway
-- answered 403 to CONNECT (policy denial or upstream failure)","host":
-- "gretil.sub.uni-goettingen.de:443"}.  Same class as the Hackage denial
-- recorded in formal/cubical/check.sh.  WebSearch works; fetching a text
-- does not.
--
-- So on this container a claim resting on a text CANNOT exceed Anvista,
-- by organisation egress policy and not by anyones effort.  That is an
-- environment fact and it belongs next to the grade, because a reader
data Status = Asiddha | Sruta | Anvista | Anumita | Drsta | Siddha
  deriving (Eq, Ord, Show, Enum, Bounded)

data Source = Source
  { srcAuthor :: String
  , srcVia    :: String        -- how the source was REACHED: the provenance
                              -- of the provenance.  "recall" / "search
                              -- 2026-08-20" / "consulted".
  , srcWork   :: String
  , srcDate   :: String
  } deriving (Eq, Show)

data Claim = Claim
  { cId      :: String
  , cText    :: String
  , cRoute   :: Route
  , cStatus  :: Status          -- what was done for THIS claim alone
  , cSource  :: Maybe Source
  , cRests   :: [String]        -- ids this claim rests on
  , cLooking :: Maybe String    -- for Anupalabdhi: what was searched
  }

-- | The fitness condition, and it is a HARD GATE, not a demerit.
--   An absence with no statement of the looking is not weak evidence of
--   absence.  It is not evidence.  (Kumarila's yogya-anupalabdhi; and it
--   is common ground even to Prabhakara, who denies anupalabdhi is a
--   separate pramana at all.)
fit :: Claim -> Bool
fit c = case cRoute c of
  Anupalabdhi -> maybe False (not . null) (cLooking c)
  Sabda       -> maybe False (\s -> not (null (srcWork s)) && not (null (srcDate s))) (cSource c)
  _           -> True

-- | Why a claim failed the gate, in words, or Nothing if it passed.
unfit :: Claim -> Maybe String
unfit c
  | fit c = Nothing
  | otherwise = Just $ case cRoute c of
      Anupalabdhi -> "an absence with no statement of what was searched: \
                     \not weak evidence of absence, not evidence"
      Sabda       -> "testimony with no work and date: the citation names \
                     \an author, which propagates for free, and not a work, \
                     \which appears only where somebody opened the book"
      _           -> "unfit"

-- | The grade: minimum over self and the transitive closure of `cRests`.
--   Cycles are treated as Asiddha at the point of re-entry rather than
--   diverging, and the cycle is reported -- a claim that rests on itself
--   has earned nothing.
grade :: M.Map String Claim -> String -> Status
grade env = go []
  where
    go seen i
      | i `elem` seen = Asiddha
      | otherwise = case M.lookup i env of
          Nothing -> Asiddha
          Just c
            | not (fit c) -> Asiddha
            | otherwise   -> minimum (cStatus c : map (go (i : seen)) (cRests c))

cyclic :: M.Map String Claim -> String -> Bool
cyclic env = go []
  where
    go seen i
      | i `elem` seen = True
      | otherwise = case M.lookup i env of
          Nothing -> False
          Just c  -> any (go (i : seen)) (cRests c)

-- | Where a claim's grade actually comes from: the weakest thing under
--   it.  This is the sentence a reader needs and never gets.
weakest :: M.Map String Claim -> String -> [(String, Status)]
weakest env i =
  let g = grade env i
      all' = reach [] i
  in [ (j, cStatus c) | j <- all', Just c <- [M.lookup j env], cStatus c == g ]
  where
    reach seen j
      | j `elem` seen = seen
      | otherwise = case M.lookup j env of
          Nothing -> j : seen
          Just c  -> foldl reach (j : seen) (cRests c)

env :: [Claim] -> M.Map String Claim
env cs = M.fromList [ (cId c, c) | c <- cs ]

-- | The report for one claim.
verdict :: M.Map String Claim -> Claim -> [String]
verdict e c =
  let g = grade e (cId c)
      w = [ j | (j, _) <- weakest e (cId c), j /= cId c ]
  in [ "  " ++ cId c ++ "  [" ++ show (cRoute c) ++ "]" ]
  ++ [ "      " ++ cText c ]
  ++ (case cSource c of
        Just s  -> [ "      source: " ++ srcAuthor s ++ ", " ++ srcWork s
                     ++ " (" ++ srcDate s ++ ")   [reached by: " ++ srcVia s ++ "]" ]
        Nothing -> [])
  ++ (case unfit c of
        Just why -> [ "      UNFIT: " ++ why
                    , "      GRADE: Asiddha -- the gate is hard, not a demerit" ]
        Nothing ->
          [ "      own status: " ++ show (cStatus c)
          , "      GRADE:      " ++ show g
                ++ (if g < cStatus c then "   <- LOWERED by what it rests on" else "") ]
          ++ (if null w then []
              else [ "      weakest under it: " ++ intercalate ", " w ])
          ++ (if cyclic e (cId c)
              then [ "      CYCLE: this claim rests on itself; it has earned nothing" ]
              else []))
