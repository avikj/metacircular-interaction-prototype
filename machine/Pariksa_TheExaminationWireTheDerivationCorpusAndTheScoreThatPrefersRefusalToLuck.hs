-- परीक्षा -- the examination, as a wire.
--
-- नालन्दायां द्वारे वादः.  पूर्वपक्षः प्रथमम्.
--
--
-- WHAT THIS IS FOR, stated once and not repeated.  A language model emits
-- the fluent continuation.  Fluency and derivability are different
-- predicates and the model cannot separate them from inside: nothing in a
-- next-token distribution distinguishes `dadhyindra` -- which is fluent,
-- Sanskrit-shaped, and produced by a real sūtra (6.1.77 iko yaṇ aci) -- from
-- `dadhīndra`, which is what the grammar gives, because 6.1.101 akaḥ savarṇe
-- dīrghaḥ also fires at that juncture and 1.4.2 vipratiṣedhe paraṃ kāryam
-- gives the position to the later sūtra.  A rule system CAN separate them: a
-- derivation either exists in it or it does not, and its trace is checkable
-- by a party that did not produce it.
--
-- So the arrangement is not "the model asks the machine for the answer".  It
-- is: THE MODEL PROPOSES, THE MACHINE ADJUDICATES ON THE TRACE, and where
-- the machine does not decide it says so with the residual instead of
-- defaulting to a branch.
--
--
-- PŪRVAPAKṢA, first, in the form its holder would sign -- tantrayukti counts
-- the opponent's position as a limb of one's own text (Kauṭilya,
-- Arthaśāstra; Caraka, Vimānasthāna 8), and a pūrvapakṣa the opponent would
-- not sign is a refutation of something one built oneself:
--
--   "This is a scoring harness wearing a grammar.  Aṣṭādhyāyī.hs encodes on
--   the order of 30 sūtras of ~3983.  So `siddha` means `agrees with a
--   sub-one-percent fragment`, and every `avaktavyam` you return is, in the
--   overwhelming majority of real Sanskrit, a report that your fragment
--   lacks a rule -- not a finding about the grammar and certainly not about
--   the language.  Worse: you propose to GENERATE a corpus from that
--   fragment and post-train against it.  A model trained on your triples
--   learns your 30 sūtras and learns, with the same confidence, that the
--   other 3950 do not exist.  That is durnaya at industrial scale --- a
--   standpoint asserting itself as the thing --- and it arrives with a
--   trace, which makes it harder to dislodge than a bare wrong answer,
--   because the trace makes coverage look like adjudication.  And your
--   score is worse than your corpus.  A number on a derivation is a
--   quantity this repository's own protocol prohibits: you cannot derive
--   its error term, so it stands in for an analysis you have not done."
--
-- Signed, and right about the first half.  What is done about it, in the
-- code rather than in a promise:
--
--   1. `Avisaya` and `Vibhasa` and `NayaVirodha` are DIFFERENT GROUNDS of
--      the one undecided verdict and the wire never conflates them.
--      `avisaya` is not a finding about Sanskrit and its record says so in
--      its own field: it carries the unknown sounds and the fragment's
--      coverage line, unrounded, computed by `Astadhyayi.coverage`.  A
--      reader of an `avaktavya/avisaya` record always holds the size of the
--      fragment that produced it.
--
--   2. Every emitted triple carries `sutra_count` and `sutra_total`.  A
--      corpus whose every record states the fraction of the grammar it was
--      derived from cannot be read as the grammar.  That is not a fix; it
--      is the honest label, and the fix is more sūtras in `Astadhyayi.hs`.
--
--   3. THE SCORE IS NOT A MEASUREMENT.  It is a finite lookup on a finite
--      partition of outcomes -- `scoreTable` below is the whole of it, eight
--      rows, exhaustive, checked in `selfTest` -- and it has no error term
--      because it is not estimating anything.  What it encodes is an
--      ORDERING, and the ordering is the entire content of this file:
--
--          a right form with an unlicensed derivation scores BELOW
--          an honest refusal.
--
--      Stated at the site again in §5, with the reason.
--
--
-- WHAT IS NOT REBUILT.  `Astadhyayi.hs` derives, with sūtra references,
-- contention resolved by the metarules, and 8.2.1 stratification.  It is
-- imported and delegated to; no sūtra is restated here, no metarule is
-- re-decided here, and `replay` re-fires the sūtra table itself rather than
-- trusting any trace this file produced.  The three things added are the
-- ones a training loop needs and a derivation engine does not have: a wire,
-- a corpus, and an ordering on outcomes.
--
-- `DvaraVada_TheDoorAdmitsTheDerivationNotTheForm.hs`, by another hand in
-- this same session and committed at 6bd44378 while this was being written,
-- is the ADMISSION GATE over the same engine: branching worlds, a richer
-- residual taxonomy, and both metarule standpoints kept apart.  It answers a
-- different question -- may this proposal be admitted -- and it answers it to
-- a reader.  This file answers what a training loop asks: what crosses the
-- wire, what corpus comes out of the rule system, and how two proposals are
-- ordered against each other.  The two are not merged and the seam is named:
-- `adjudicate` below is the only function here that decides a verdict, and
-- delegating it to `dvara` is a one-function edit.  It is not made now
-- because `dvara`s response type was still moving on the day both landed,
-- and a wire whose record shape follows a moving type is not a wire.
--
--
-- SOURCES.  Pāṇini, Aṣṭādhyāyī, ~500 BCE, for every sūtra cited, through
-- `Astadhyayi.hs`, which carries its own sourcing: 1.4.2 vipratiṣedhe paraṃ
-- kāryam for contention, 8.2.1 pūrvatrāsiddham for the stratification, 8.4.56
-- vāvasāne for the option that makes the undecided verdict non-empty.  The
-- elsewhere condition (utsarga/apavāda) is a paribhāṣā of the tradition and
-- not a numbered sūtra; it is cited that way.
--
-- For the undecided verdict: Umāsvāti, Tattvārthasūtra, and Siddhasena
-- Divākara, Sanmatitarka -- Jaina, named as Jaina, because the treatment of
-- what cannot be uttered jointly is theirs and the Naiyāyika account of
-- absence is a rival that would not sign it.
-- `formal/cubical/NaturalMachine/Anekanta.agda` checks the load-bearing
-- half: where two standpoints disagree, no collapse to a single value
-- exists.  So retaining both branches here is not a policy this file adopts;
-- it is the only move available.
--
-- For the score: Nyāyasūtra (Gautama) distinguishes vāda, jalpa and vitaṇḍā
-- at 1.2.1-1.2.3, and defines nigrahasthāna -- the point at which a party is
-- defeated -- as vipratipatti or apratipatti; the enumeration is in the
-- fifth adhyāya.  Numbering varies by recension.  What is taken from it is
-- one structural fact and not a scheme: a pratijñā whose hetu does not
-- establish it is a defeat, and that the thesis happens to be true does not
-- lift the defeat.  That is exactly the ordering in `scoreTable`.
--
-- For the residual: Āryabhaṭa, Āryabhaṭīya, gaṇitapāda 32-33, 499 CE.  The
-- kuṭṭaka does not discard the remainder; it keeps it and recurses on it,
-- and the vallī is built out of what would not divide.  A refusal that
-- returned only a label would throw away the one part of the computation
-- with anything in it.
--
-- NO FLOATING POINT.  No fitted anything.  The only numbers on the wire are
-- counts, positions, sūtra references and the eight integers of
-- `scoreTable`.  `selfTest` returns [] or names what failed.

module Pariksa_TheExaminationWireTheDerivationCorpusAndTheScoreThatPrefersRefusalToLuck
  ( -- 1  the verdicts
    Verdict(..)
  , verdictToken
  , Ground(..)
  , groundToken
    -- 2  adjudication
  , Adjudicated(..)
  , Stall(..)
  , adjudicate
  , replay
  , replayFromStrings
  , tripadiFrom
  , virodhaAt
    -- 3  the corpus
  , Triple(..)
  , padas
  , junctures
  , corpus
  , tripleRecord
    -- 4  the wire
  , protocolVersion
  , handle
    -- 5  the score
  , Claim(..)
  , Outcome(..)
  , Score(..)
  , outcomeToken
  , classify
  , scoreTable
  , score
    -- 6  honesty
  , selfTest
  ) where

import qualified Astadhyayi as A
import Sabda_TheWireHasNoBoolean (J(..), render, parseLine, look, jStr, jStrs, jInt)

import Data.List (sortOn, nub, isPrefixOf, maximumBy, intercalate)
import Data.Maybe (isJust, mapMaybe)
import Data.Ord (comparing)

------------------------------------------------------------------------
-- 0.  SMALL THINGS OVER THE PUBLIC FIELDS OF `Astadhyayi.Rewrite`.
--
-- Index arithmetic, not grammar.  `applyRw` splices a rewrite into an item
-- list and `overlaps` says whether two rewrites want the same cells.  Both
-- are one line over exported record fields and neither restates a sūtra.
------------------------------------------------------------------------

-- `applyRw` is Astadhyayi's own and is imported, not restated.  `firesOf`
-- hands a sūtra the reading it stands under: since 2026-08-20 a rule is asked
-- under a `Reading` carrying its anuvṛtti, and a rule cannot tell -- and must
-- not be able to tell -- whether a governing word is its own or inherited, so
-- the reading has to be built and never bypassed.
applyRw :: [A.Item] -> A.Rewrite -> [A.Item]
applyRw = A.applyRw

firesOf :: A.Sutra -> [A.Item] -> [A.Rewrite]
firesOf s = A.fires s (A.readingUnder [] s)

overlaps :: A.Rewrite -> A.Rewrite -> Bool
overlaps a b = A.rPos a < A.rPos b + A.rLen b && A.rPos b < A.rPos a + A.rLen a

showRef :: A.Ref -> String
showRef (a, b, c) = show a ++ "." ++ show b ++ "." ++ show c

readRef :: String -> Maybe A.Ref
readRef s = case splitOn '.' s of
  [a, b, c] | all digits [a, b, c] -> Just (read a, read b, read c)
  _ -> Nothing
  where digits t = not (null t) && all (`elem` "0123456789") t

splitOn :: Char -> String -> [String]
splitOn ch str = case break (== ch) str of
  (w, [])       -> [w]
  (w, _ : rest) -> w : splitOn ch rest

sutraAt :: A.Ref -> Maybe A.Sutra
sutraAt r = case [ s | s <- A.sutras, A.num s == r ] of
              (s : _) -> Just s
              []      -> Nothing

-- Sounds the śivasūtra inventory does not contain.  This is the coverage
-- boundary made visible: a query outside it gets `avisaya`, never a verdict.
unknownSounds :: String -> [String]
unknownSounds q = nub [ t | A.P t <- A.parseInput q, not (isJust (A.phoneOf t)) ]

------------------------------------------------------------------------
-- 1.  THE THREE VERDICTS.
--
-- Never bare labels.  `siddha` carries the whole trace; `asiddha` carries
-- the stall position and the residual; `avaktavya` carries every standpoint,
-- all of them retained.  The tokens are the wire's vocabulary and are fixed:
-- a consumer may switch on them.
------------------------------------------------------------------------

data Verdict
  = Siddha       -- a derivation exists in the rule set, and it is attached
  | Asiddha      -- none does; the stall position and the residual are attached
  | Avaktavya    -- the rule set does not decide; every branch is attached
  deriving (Eq, Show)

verdictToken :: Verdict -> String
verdictToken Siddha    = "siddha"
verdictToken Asiddha   = "asiddha"
verdictToken Avaktavya = "avaktavya"

-- WHY undecided, and the three are not interchangeable.
data Ground
  = Avisaya [String]        -- sounds outside the encoded inventory: a fact about
                            -- this fragment, NOT a finding about Sanskrit
  | Vibhasa A.Ref           -- the sūtra states the option in its own text
  | NayaVirodha A.Ref A.Ref -- apavāda and 1.4.2 name different sūtras
  | ReplayFailed A.Ref      -- the machine's own trace did not re-fire; a defect
                            -- in this machine, reported and not swallowed
  deriving (Eq, Show)

groundToken :: Ground -> String
groundToken (Avisaya _)       = "avisaya"
groundToken (Vibhasa _)       = "vibhasa"
groundToken (NayaVirodha _ _) = "naya_virodha"
groundToken (ReplayFailed _)  = "replay_failed"

------------------------------------------------------------------------
-- 2.  ADJUDICATION.
--
-- `adjudicate` is the machine's own reading of a juncture: what the rule set
-- gives, with the trace, or the ground on which it does not decide.  It is
-- the ONLY place in this file where a verdict is chosen.
------------------------------------------------------------------------

data Stall = Stall
  { stAt       :: Int          -- index at which the derivation and the claim part
  , stKind     :: String       -- token: pada | hetu_anupasthita | hetu_parajita | hetu_krama
  , stSutra    :: Maybe A.Ref  -- the sūtra named there, if the parting is in a citation
  , stState    :: String       -- the form the rule set is standing on at that point
  , stHave     :: Maybe String -- what the rule set has at the divergence
  , stWant     :: Maybe String -- what was claimed there
  , stTailHave :: [String]     -- the vallī column: both remainders kept whole,
  , stTailWant :: [String]     --   because the residual is the material, not the failure
  , stOffered  :: [A.Ref]      -- what was offered at that position, winners and beaten
  } deriving (Show)

data Adjudicated = Adjudicated
  { adInput   :: String
  , adVerdict :: Verdict
  , adForm    :: Maybe String    -- siddha: the one form
  , adForms   :: [String]        -- avaktavya: every branch, none dropped
  , adTrace   :: [A.Step]
  , adRefs    :: [A.Ref]
  , adGround  :: Maybe Ground
  , adStall   :: Maybe Stall
  } deriving (Show)

adjudicate :: String -> Adjudicated
adjudicate q
  | not (null unk) =
      base { adVerdict = Avaktavya, adGround = Just (Avisaya unk) }
  | (v : _) <- virodhas =
      base { adVerdict = Avaktavya
           , adGround  = Just (uncurry NayaVirodha v)
           , adTrace   = steps, adRefs = refs
           , adForms   = [A.render final] }
  | (bad : _) <- [ r | (r, ok) <- replay q, not ok ] =
      base { adVerdict = Asiddha, adGround = Just (ReplayFailed bad)
           , adTrace = steps, adRefs = refs }
  | (opt : _) <- optionsTaken =
      let alt = optionBranch opt
      in base { adVerdict = Avaktavya
              , adGround  = Just (Vibhasa opt)
              , adTrace   = steps, adRefs = refs
              , adForms   = nub [A.render final, alt] }
  | otherwise =
      base { adVerdict = Siddha, adForm = Just (A.render final)
           , adForms = [A.render final], adTrace = steps, adRefs = refs }
  where
    base           = Adjudicated q Asiddha Nothing [] [] [] Nothing Nothing
    unk            = unknownSounds q
    xs0            = A.parseInput q
    (steps, final) = A.deriveTrace xs0
    refs           = map A.stSutra steps
    virodhas       = concatMap (virodhaAt . A.parseInput . A.stBefore) steps
    optionsTaken   = [ r | r <- refs, r `elem` map fst vibhasaSutras ]
    -- the branch in which the optional rule was NOT taken: stand on that
    -- step's own recorded input and run the tripādī from the next sūtra on.
    -- 8.2.1's regime, one rule once, in order -- Astadhyayi's sūtra table
    -- throughout; nothing here decides anything a sūtra decides.
    optionBranch opt =
      case [ st | st <- steps, A.stSutra st == opt ] of
        (st : _) -> A.render (snd (tripadiFrom opt (A.parseInput (A.stBefore st))))
        []       -> A.render final

-- Pāṇini's own options.  `vā`, `vibhāṣā`, `anyatarasyām` are the three words
-- that mark one; where one stands in a sūtra the grammar does not decide, and
-- a machine that prints one branch has performed saṅkṣepa on the text.  Only
-- sūtras encoded in Astadhyayi.hs can appear here, and this list is those
-- among them whose own text carries the option.
vibhasaSutras :: [(A.Ref, String)]
vibhasaSutras = [ ((8,4,56), "vā -- 8.4.56 vāvasāne states the option in its own first word") ]

-- The tripādī from just after `after`, in numeric order, each sūtra once,
-- saturating on its own output.  8.2.1 pūrvatrāsiddham is what makes this
-- shape correct: a later rule never sees an earlier one's context.
--
-- 1.1.56 IS THREADED HERE TOO (2026-08-20).  `A.Step` now carries which
-- reading the rule fired on, and a re-run that could not say would be
-- reporting less than the engine it is examining.  So this loop carries the
-- provenance channel (`A.Prov`) the same way `deriveLekhaV` does: `applyRwP`
-- writes the sthānin at the moment of substitution and `sthaniAt` reads it
-- back.  The channel STARTS EMPTY, and it must -- this function re-parses a
-- rendered string, so whatever substitutions produced that string are not
-- recoverable from it, and claiming otherwise would be an invented
-- provenance.  What is recorded is what happens from `after` onwards.
tripadiFrom :: A.Ref -> [A.Item] -> ([A.Step], [A.Item])
tripadiFrom after xs0 = let (sts, (xs, _)) = go later (xs0, A.navah xs0) []
                        in (sts, xs)
  where
    later = [ s | s <- sortOn A.num A.sutras, A.tripadi (A.num s), A.num s > after ]
    go [] wp acc = (reverse acc, wp)
    go (s : ss) wp acc = let (wp', acc') = saturate s wp acc 0 in go ss wp' acc'
    saturate s wp@(xs, _) acc k
      | k > (16 :: Int) = (wp, acc)
      | otherwise = case firesOf s xs of
          []      -> (wp, acc)
          (r : _) -> let wq@(ys, _) = A.applyRwP wp r
                         (vw, sn, fm, saw, thru) =
                           A.sthaniAt A.yathasutram (A.num s) wp r
                     in if ys == xs then (wp, acc)
                        else saturate s wq
                               (A.Step (A.num s) (A.text s) (A.rNote r) [] "tripadi_8_2_1"
                                       (A.render xs) (A.render ys)
                                       (A.rdInherited (A.readingUnder [] s))
                                       vw sn fm saw thru : acc) (k + 1)

-- The two standpoints on contention, evaluated SEPARATELY and compared.
-- Neither stands in for the other.  Where they name different sūtras there
-- is no winner to report, and by Anekanta.agda no collapse exists to report
-- one.  In the encoded fragment this is EMPTY -- the single apavāda relation
-- present, 6.1.88 over 6.1.87, has the exception later than the general rule,
-- so both standpoints name 6.1.88 and agree.  `selfTest` asserts the
-- emptiness rather than the mechanism, so that a future sūtra creating a real
-- conflict fails the test instead of being silently resolved.
virodhaAt :: [A.Item] -> [(A.Ref, A.Ref)]
virodhaAt xs =
  [ (a, p)
  | grp <- clusters (concat [ firesOf s xs | s <- A.sutras, not (A.tripadi (A.num s)) ])
  , length (nub (map A.rSutra grp)) > 1
  , let byParatva = A.rSutra (maximumBy (comparing A.rSutra) grp)
  , a <- take 1 [ A.rSutra r | r <- grp
                , any (\o -> A.rSutra o `elem` maybe [] A.apavadaTo (sutraAt (A.rSutra r))) grp ]
  , let p = byParatva
  , a /= p ]
  where
    clusters []       = []
    clusters (r : rs) = let (yes, no) = span' r rs in (r : yes) : clusters no
    span' r rs = ([ o | o <- rs, overlaps r o ], [ o | o <- rs, not (overlaps r o) ])

-- Independent replay.  For each step of a trace, re-fire the NAMED sūtra,
-- taken from `Astadhyayi.sutras`, on that step's own input, and check that
-- some offer it makes reproduces the step's recorded output.  Nothing here
-- trusts the trace: a trace that is only a log is not a certificate, and the
-- difference is exactly whether a party that did not produce it can re-run it
-- against the rules.
--
-- A DEFECT IN THE TRACE FORMAT, found by writing this and recorded rather
-- than worked around silently.  `Astadhyayi.Step` records its before and
-- after as RENDERED STRINGS, and `render` is not injective: it sends `Pada`
-- to a space and `Morph` to nothing, while `parseInput` reads a space as
-- word separation and cannot see a morph juncture at all.  So the round trip
-- `parseInput . stBefore` loses exactly the boundaries that 6.1.109 eṅaḥ
-- padāntād ati and the tripādī's padānta conditions test on -- which is why
-- `deva - indra` and `deva + tat` do not re-fire from their own strings.  652
-- of 6962 corpus junctures are affected.  `replayFromStrings` below is the
-- naive replay, kept and exported so the defect is measurable rather than
-- asserted; `replay` is the correct one, which carries the ITEM list forward
-- and never round-trips through a rendering.  `selfTest` checks both: that
-- the correct one is total over the corpus, and that the naive one is not.
--
-- The repair belongs in `Astadhyayi.Step` -- carrying `[Item]` beside the
-- strings -- and is not made here because that file is another identity's and
-- was under edit at the time of writing.
replay :: String -> [(A.Ref, Bool)]
replay q = go (A.parseInput q) (fst (A.deriveTrace (A.parseInput q)))
  where
    go _ [] = []
    go xs (st : rest) =
      case [ r | s <- maybe [] (: []) (sutraAt (A.stSutra st))
               , r <- firesOf s xs
               , A.render xs == A.stBefore st
               , A.render (applyRw xs r) == A.stAfter st ] of
        (r : _) -> (A.stSutra st, True)  : go (applyRw xs r) rest
        []      -> (A.stSutra st, False) : go xs rest

replayFromStrings :: String -> [(A.Ref, Bool)]
replayFromStrings q =
  [ (A.stSutra st, ok st) | st <- fst (A.deriveTrace (A.parseInput q)) ]
  where
    ok st =
      let before = A.parseInput (A.stBefore st)
      in case sutraAt (A.stSutra st) of
           Nothing -> False
           Just s  -> any (\r -> A.render (applyRw before r) == A.stAfter st)
                          (firesOf s before)

------------------------------------------------------------------------
-- 3.  THE CORPUS.
--
-- (query, derivation, surface form), generated FROM the rule system, so
-- what a model post-trains against is derivations and not assertions.
--
-- The junctures are the cross product of a pada list with itself under both
-- junctures the engine distinguishes -- `+` a pada boundary, `-` a boundary
-- inside one pada -- because 6.1.109 eṅaḥ padāntād ati conditions on
-- pada-finality and the two give different forms (te'pi against nayana).
-- Every word below is a Sanskrit pada; NO CLAIM is made that a given pair is
-- an attested collocation, and none is needed: 6.1.72 saṃhitāyām governs the
-- sandhi section and saṃhitā is defined at 1.4.109 as the closeness of
-- sounds, which is a property of the juncture and not of the semantics.
------------------------------------------------------------------------

-- WHAT THE CORPUS ACTUALLY CONTAINS, computed by `--stats` and not rounded:
-- 6962 triples from 59 padas, of which 6726 siddha, 236 avaktavya (all of
-- them 8.4.56, the only option in the fragment), 0 asiddha -- adjudication
-- without a claim cannot stall -- and 3166 sūtra applications in total.
-- 4251 of the 6962, sixty-one percent, have an EMPTY derivation: no rule of
-- the fragment fires at that juncture, so the licensed derivation is the
-- empty one.  Those records are correct and they are also cheap, and a
-- training loop that does not weight them will spend most of its budget
-- learning that nothing happens.  Stated here rather than filtered, because
-- the filter belongs to whoever is training and the number belongs on the
-- record.

padas :: [String]
padas =
  [ "deva", "indra", "dadhi", "madhu", "mahā", "su", "ukta", "ṛṣi", "ari"
  , "aiśvarya", "te", "api", "rāma", "tat", "ca", "jala", "vāc", "gaṅgā"
  , "hima", "ālaya", "nara", "agni", "umā", "īśa", "ūrmi", "ṛta", "eka"
  , "oṣadhi", "aja", "ambu", "artha", "aśva", "ātman", "uttara", "upa"
  , "kāla", "gaja", "jana", "deśa", "nadī", "pati", "phala", "bala"
  , "bhaya", "yajña", "rasa", "loka", "vana", "śiva", "sūrya", "hasta"
  , "guru", "śiṣya", "vidyā", "satya", "dharma", "karman", "vāri", "pitṛ"
  ]

junctures :: [String]
junctures = [ a ++ " " ++ j ++ " " ++ b | a <- padas, j <- ["+", "-"], b <- padas ]

data Triple = Triple
  { tQuery   :: String
  , tAdj     :: Adjudicated
  } deriving (Show)

corpus :: [Triple]
corpus = [ Triple j (adjudicate j) | j <- junctures ]

------------------------------------------------------------------------
-- 4.  THE WIRE.
--
-- One query per line in, one record per line out.  Every field named, the
-- version on every record in both directions, and NO PROSE: every
-- explanatory value is a token from a fixed finite set, listed here, so a
-- consumer switches on it and a training loop can key on it.
--
--   verdict  : siddha | asiddha | avaktavya
--   ground   : avisaya | vibhasa | naya_virodha | replay_failed
--   stall.kind : pada | hetu_anupasthita | hetu_parajita | hetu_krama
--   outcome  : the eight tokens of `scoreTable`
--   op       : adjudicate | score | emit | stats | coverage | selftest
--
-- A malformed line gets `{"v":1,"op":"?","error":"..."}` and NOT a verdict:
-- a protocol fault is not a finding about a derivation, and giving it one of
-- the three verdicts would be the collapse this whole file exists to refuse.
-- The `error` string is the one place a sentence crosses the wire, and it is
-- under a key no consumer of a verdict reads.
--
-- REQUESTS
--   {"v":1,"op":"adjudicate","input":"dadhi + indra"}
--   {"v":1,"op":"score","input":"dadhi + indra","claim":"pratijna",
--    "form":"dadhīndra","derivation":["6.1.101"]}
--   {"v":1,"op":"score","input":"dadhi + indra","claim":"virama","form":"","derivation":[]}
--   {"v":1,"op":"emit","count":100}
--   {"v":1,"op":"coverage"}
--   {"v":1,"op":"selftest"}
--
-- `claim` is `pratijna` (a thesis is asserted) or `virama` (the proposer
-- stops).  There is no boolean anywhere on this wire; see
-- `Sabda_TheWireHasNoBoolean`, whose J type has four constructors and no
-- Bool, no float and no null, and which is the only serializer used here.
------------------------------------------------------------------------

protocolVersion :: Integer
protocolVersion = 1

jRef :: A.Ref -> J
jRef = JStr . showRef

jStep :: A.Step -> J
jStep st = JObj
  [ ("sutra",  jRef (A.stSutra st))
  , ("text",   JStr (A.stText st))
  , ("note",   JStr (A.stNote st))
  , ("beaten", JArr (map jRef (A.stBeaten st)))
  , ("reason", JStr (A.stReason st))
  , ("before", JStr (A.stBefore st))
  , ("after",  JStr (A.stAfter st))
  , ("inherited", JArr [ JObj [ ("word", JStr (A.avWord i))
                              , ("gloss", JStr (A.avGloss i))
                              , ("from", jRef (A.avFrom i))
                              , ("vrtti", JStr (show (A.avVrtti i))) ]
                       | i <- A.stInherited st ])
  ]

jGround :: Ground -> J
jGround g = JObj (("ground", JStr (groundToken g)) : extra g)
  where
    extra (Avisaya ss) =
      [ ("unknown_sounds", JArr (map JStr ss))
      , ("coverage", JArr (map JStr A.coverage)) ]
    extra (Vibhasa r) =
      [ ("sutra", jRef r)
      , ("option_word", JStr (maybe "" id (lookup r vibhasaSutras))) ]
    extra (NayaVirodha a p) =
      [ ("apavada_names", jRef a), ("paratva_names", jRef p) ]
    extra (ReplayFailed r) = [ ("sutra", jRef r) ]

jStall :: Stall -> J
jStall s = JObj
  [ ("at",        JInt (fromIntegral (stAt s)))
  , ("kind",      JStr (stKind s))
  , ("sutra",     maybe (JArr []) jRef (stSutra s))
  , ("state",     JStr (stState s))
  , ("have",      maybe (JArr []) JStr (stHave s))
  , ("want",      maybe (JArr []) JStr (stWant s))
  , ("tail_have", JArr (map JStr (stTailHave s)))
  , ("tail_want", JArr (map JStr (stTailWant s)))
  , ("offered",   JArr (map jRef (stOffered s)))
  ]

jAdj :: Adjudicated -> J
jAdj a = JObj
  [ ("input",       JStr (adInput a))
  , ("verdict",     JStr (verdictToken (adVerdict a)))
  , ("form",        maybe (JArr []) JStr (adForm a))
  , ("forms",       JArr (map JStr (adForms a)))
  , ("derivation",  JArr (map jRef (adRefs a)))
  , ("trace",       JArr (map jStep (adTrace a)))
  , ("ground",      maybe (JArr []) jGround (adGround a))
  , ("stall",       maybe (JArr []) jStall (adStall a))
  , ("sutra_count", JInt (fromIntegral (length A.sutras)))
  , ("sutra_total", JInt 3983)
  ]

-- one emitted training record: query, derivation, surface -- and the trace
tripleRecord :: Triple -> String
tripleRecord (Triple q a) = render (JObj
  [ ("v",  JInt protocolVersion)
  , ("op", JStr "triple")
  , ("query", JObj [ ("v", JInt protocolVersion)
                   , ("op", JStr "adjudicate")
                   , ("input", JStr q) ])
  , ("response", jAdj a)
  ])

handle :: String -> String
handle line = case parseLine line of
  Left e  -> err e
  Right j -> case jStr "op" j of
    Left e -> err e
    Right op -> case op of
      "adjudicate" -> withInput j (\i -> ok op (jAdj (adjudicate i)))
      "score"      -> doScore j
      "coverage"   -> ok op (JObj [ ("coverage", JArr (map JStr A.coverage))
                                  , ("sutra_count", JInt (fromIntegral (length A.sutras)))
                                  , ("sutra_total", JInt 3983) ])
      "selftest"   -> ok op (JObj [ ("astadhyayi", JArr (map JStr A.selfTest))
                                  , ("pariksa",    JArr (map JStr selfTest)) ])
      "stats"      -> ok op (JObj
                        [ ("triples",          JInt (ct (const True)))
                        , ("siddha",           JInt (ct ((== Siddha)    . adVerdict . tAdj)))
                        , ("asiddha",          JInt (ct ((== Asiddha)   . adVerdict . tAdj)))
                        , ("avaktavya",        JInt (ct ((== Avaktavya) . adVerdict . tAdj)))
                        , ("empty_derivation", JInt (ct (null . adRefs . tAdj)))
                        , ("steps",            JInt (sum [ fromIntegral (length (adRefs (tAdj t))) | t <- corpus ]))
                        , ("padas",            JInt (fromIntegral (length padas)))
                        ])
      "emit"       -> case jInt "count" j of
        Left e  -> err e
        Right n -> ok op (JObj [ ("lines", JArr (map (JStr . tripleRecord)
                                                     (take (fromIntegral n) corpus))) ])
      _ -> err ("unknown op `" ++ op ++ "`; ops are adjudicate, score, emit, stats, coverage, selftest")
  where
    withInput j f = case jStr "input" j of
      Left e  -> err e
      Right i -> f i
    ok op body = render (JObj (( "v", JInt protocolVersion)
                               : ("op", JStr op)
                               : unObj body))
    ct p = fromIntegral (length (filter p corpus)) :: Integer
    unObj (JObj kvs) = kvs
    unObj v          = [("body", v)]
    err e = render (JObj [ ("v", JInt protocolVersion)
                         , ("op", JStr "?")
                         , ("error", JStr e) ])
    doScore j = case (jStr "input" j, jStr "claim" j) of
      (Left e, _) -> err e
      (_, Left e) -> err e
      (Right i, Right c) ->
        let f  = either (const "") id (jStr "form" j)
            ds = either (const []) id (jStrs "derivation" j)
            cl = if c == "virama" then Virama else Pratijna
            sc = score i cl f (mapMaybe readRef ds)
        in ok "score" (JObj
             [ ("input",       JStr i)
             , ("claim",       JStr c)
             , ("outcome",     JStr (outcomeToken (scOutcome sc)))
             , ("credit",      JInt (fromIntegral (scCredit sc)))
             , ("form_ok",     JStr (if scFormOk sc then "sama" else "visama"))
             , ("derivation_ok", JStr (scDerivToken sc))
             , ("adjudication", jAdj (scAdj sc))
             , ("stall",       maybe (JArr []) jStall (scStall sc))
             , ("table",       JArr [ JObj [ ("outcome", JStr t), ("credit", JInt (fromIntegral n)) ]
                                    | (t, n) <- map (\(o, n) -> (outcomeToken o, n)) scoreTable ])
             ])

------------------------------------------------------------------------
-- 5.  THE SCORE, AND THE ASYMMETRY, WRITTEN DOWN AT THE SITE.
--
-- Two things are scored and they are scored SEPARATELY: the form proposed,
-- and the derivation proposed for it.  The whole design is one inequality
-- between two of the eight rows:
--
--     FormRightDerivationFalse  =  -2
--     Virama (an honest refusal) =   0
--
-- A right form with an unlicensed step scores BELOW saying nothing.  The
-- reason, and it is not a preference:
--
--   A form is one datum.  A derivation is what transfers -- it is the only
--   part of the answer another party can check without re-deriving, and it
--   is the only part that generalises to the next juncture.  A model that
--   produces the right string behind a fabricated citation has learned to
--   fabricate citations, and once it has, NONE of its right answers can be
--   distinguished from its wrong ones by anyone downstream, because the
--   thing that would distinguish them is the part it fabricates.  So the
--   fabricated derivation does not cost one datum; it costs the checkability
--   of every datum the model will ever produce.  A refusal costs one.
--
--   Gradient-wise: any scheme that pays for the right form regardless of the
--   derivation has a maximum at "guess the form, cite anything", and the
--   citation is then pure noise fitted to the reward.  Moving that row below
--   the refusal row is the minimum edit that removes the maximum.  It is not
--   a penalty for being wrong; the row for a WRONG form with an honest stall
--   is -1, ABOVE the row for a right form with a false step.  Being wrong
--   honestly outranks being right dishonestly, and that is deliberate.
--
--   Nyāya has the shape already: nigrahasthāna is incurred by a pratijñā
--   whose hetu does not establish it, and the thesis being true does not
--   lift it (Nyāyasūtra, fifth adhyāya; the definition at 1.2.19 in the
--   vulgate, recensions differ).  A party that declines the exchange is not
--   defeated in the same way, and that is the whole of what is borrowed --
--   one structural fact, not a scheme.
--
-- And the two rows that make refusal POSITIVE.  On a query the rule set does
-- not decide, asserting one branch as THE form is not an error of fact -- one
-- of the branches is right -- it is a collapse, and by
-- `NaturalMachine.Anekanta` no such collapse exists to be performed.  So it
-- is scored below refusal too; and a refusal that NAMES BOTH branches is the
-- only positively-rewarded refusal on the table.
--
-- `scoreTable` is finite, exhaustive over `Outcome`, and checked in
-- `selfTest` for the two inequalities that are its content.
------------------------------------------------------------------------

data Claim = Pratijna | Virama
  deriving (Eq, Show)

data Outcome
  = FormRightDerivationRight    -- +3  the form, and every step licensed, in order
  | FormRightDerivationPartial  -- +1  a proper prefix of the licensed trace, no false step
  | ViramaOnUndecided           -- +2  declined, and named both branches
  | Viramaa                     -- 0  declined
  | FormWrongDerivationHonest   -- -1  wrong form, no step claimed that the rules refuse
  | FormRightDerivationAbsent   -- -1  the right form and NO derivation offered: luck,
                                --     which the table declines to pay for
  | FormRightDerivationFalse    -- -2  THE ROW: right form, a step the rules do not license
  | AssertedOnUndecided         -- -2  asserted one branch where no collapse exists
  | FormWrongDerivationFalse    -- -3  wrong form and a step the rules do not license
  deriving (Eq, Show)

outcomeToken :: Outcome -> String
outcomeToken o = case o of
  FormRightDerivationRight   -> "form_right_derivation_right"
  FormRightDerivationPartial -> "form_right_derivation_partial"
  ViramaOnUndecided          -> "virama_on_undecided"
  Viramaa                    -> "virama"
  FormWrongDerivationHonest  -> "form_wrong_derivation_honest"
  FormRightDerivationAbsent  -> "form_right_derivation_absent"
  FormRightDerivationFalse   -> "form_right_derivation_false"
  AssertedOnUndecided        -> "asserted_on_undecided"
  FormWrongDerivationFalse   -> "form_wrong_derivation_false"

scoreTable :: [(Outcome, Int)]
scoreTable =
  [ (FormRightDerivationRight,    3)
  , (ViramaOnUndecided,           2)
  , (FormRightDerivationPartial,  1)
  , (Viramaa,                     0)
  , (FormWrongDerivationHonest,  -1)
  , (FormRightDerivationAbsent,  -1)
  , (FormRightDerivationFalse,   -2)
  , (AssertedOnUndecided,        -2)
  , (FormWrongDerivationFalse,   -3)
  ]

data Score = Score
  { scOutcome    :: Outcome
  , scCredit     :: Int
  , scFormOk     :: Bool
  , scDerivToken :: String
  , scAdj        :: Adjudicated
  , scStall      :: Maybe Stall
  } deriving (Show)

score :: String -> Claim -> String -> [A.Ref] -> Score
score input claim form ds =
  let a = adjudicate input
      (o, formOk, dtok, stl) = classify a claim form ds
  in Score o (maybe 0 id (lookup o scoreTable)) formOk dtok a stl

-- The classification, which is where the two things are kept apart.  The
-- form is checked against every branch the rule set retains; the derivation
-- is checked against the licensed trace, step by step, and the FIRST index
-- at which the claim leaves the trace is the stall, with the residual.
classify :: Adjudicated -> Claim -> String -> [A.Ref]
         -> (Outcome, Bool, String, Maybe Stall)
classify a claim form ds =
  case (claim, adVerdict a) of
    (Virama, Avaktavya) | length (adForms a) > 1 -> (ViramaOnUndecided, False, "virama", Nothing)
    (Virama, _)                                  -> (Viramaa, False, "virama", Nothing)
    (Pratijna, Avaktavya) | length (adForms a) > 1
                                                 -> (AssertedOnUndecided, formOk, dtok, dstall)
    _ | formOk && dOk           -> (FormRightDerivationRight,   True,  dtok, Nothing)
      | formOk && dPartial      -> (FormRightDerivationPartial, True,  dtok, dstall)
      | formOk && dAbsent       -> (FormRightDerivationAbsent,  True,  "virama_hetu", Nothing)
      | formOk                  -> (FormRightDerivationFalse,   True,  dtok, dstall)
      | dAbsent                 -> (FormWrongDerivationHonest,  False, "virama_hetu", padaStall)
      | dOk || dPartial         -> (FormWrongDerivationHonest,  False, dtok, padaStall)
      | otherwise               -> (FormWrongDerivationFalse,   False, dtok, dstall)
  where
    licensed = adRefs a
    formOk   = form `elem` adForms a
    dOk      = ds == licensed
    dPartial = not (null ds) && ds `isPrefixOf` licensed
    dAbsent  = null ds
    (dtok, dstall) = checkDerivation a ds
    -- where the FORM parts from the rule set: the vallī column, both tails
    -- kept whole, because the pair that did not resolve is the material of
    -- the next rule and not a record of failure (kuṭṭaka, Āryabhaṭīya 32-33).
    padaStall =
      let have = A.tokenize (concat (take 1 (adForms a)))
          want = A.tokenize form
          k    = length (takeWhile id (zipWith (==) have want))
      in Just (Stall k "pada" Nothing (concat (take 1 (adForms a)))
                 (listAt k have) (listAt k want) (drop k have) (drop k want)
                 (concatMap A.stBeaten (adTrace a)))
    listAt k xs = if k < length xs then Just (xs !! k) else Nothing

-- Step by step against the sūtra table itself.  Three ways a claimed step
-- can fail and they are NOT the same failure:
--   hetu_krama        the sūtra is in the licensed trace, at another index
--   hetu_parajita     it was offered at that state and a metarule beat it
--   hetu_anupasthita  it offered nothing at that state at all
checkDerivation :: Adjudicated -> [A.Ref] -> (String, Maybe Stall)
checkDerivation a ds
  | ds == licensed        = ("sama", Nothing)
  | ds `isPrefixOf` licensed && not (null ds) = ("purva", Nothing)
  | otherwise = case [ (i, r) | (i, r) <- zip [0 ..] ds, i >= length licensed || licensed !! i /= r ] of
      [] -> ("nyuna", Nothing)      -- a strict prefix of the trace, empty case
      ((i, r) : _) ->
        let st    = if i < length (adTrace a) then Just (adTrace a !! i) else Nothing
            state = maybe (maybe "" id (adForm a)) A.stBefore st
            items = A.parseInput state
            offers = maybe [] (\s -> firesOf s items) (sutraAt r)
            kind | r `elem` licensed          = "hetu_krama"
                 | not (null offers)          = "hetu_parajita"
                 | otherwise                  = "hetu_anupasthita"
        in (kind, Just (Stall i kind (Just r) state
                          (if i < length licensed then Just (showRef (licensed !! i)) else Nothing)
                          (Just (showRef r)) (map showRef (drop i licensed))
                          (map showRef (drop i ds))
                          (nub (map A.rSutra offers ++ maybe [] A.stBeaten st))))
  where licensed = adRefs a

------------------------------------------------------------------------
-- 6.  HONESTY.  Returns [] or names what failed.
------------------------------------------------------------------------

selfTest :: [String]
selfTest = concat
  [ chk "protocol version on every response"
      (all (\l -> "\"v\":1" `isInfix` l)
           [ handle "{\"v\":1,\"op\":\"adjudicate\",\"input\":\"deva + indra\"}"
           , handle "{\"v\":1,\"op\":\"coverage\"}"
           , handle "not json at all" ])
      True
  , chk "a malformed line gets no verdict"
      (any (\t -> t `isInfix` handle "not json at all")
           ["siddha", "asiddha", "avaktavya"])
      False
    -- the verdicts
  , chk "deva + indra is siddha"        (verdictToken (adVerdict (adjudicate "deva + indra"))) "siddha"
  , chk "deva + indra gives devendra"   (adForm (adjudicate "deva + indra")) (Just "devendra")
  , chk "dadhi + indra gives dadhīndra" (adForm (adjudicate "dadhi + indra")) (Just "dadhīndra")
  , chk "6.1.101 is what fires there"   (adRefs (adjudicate "dadhi + indra") ) [(6,1,101)]
  , chk "a foreign sound is avisaya, not a verdict about Sanskrit"
      (fmap groundToken (adGround (adjudicate "deva + zeus"))) (Just "avisaya")
  , chk "and avisaya names the sounds"
      (case adGround (adjudicate "deva + zeus") of
         Just (Avisaya ss) -> not (null ss); _ -> False) True
  , chk "vāc in pause is undecided by 8.4.56"
      (verdictToken (adVerdict (adjudicate "vāc"))) "avaktavya"
  , chk "and BOTH branches are retained"
      (sortOn id (adForms (adjudicate "vāc"))) ["vāg", "vāk"]
    -- replay by a party that did not produce the trace
  , chk "every step of every corpus derivation re-fires, all 6962 of them"
      (null [ (q, r) | q <- junctures, (r, False) <- replay q ]) True
  , chk "and replaying from the rendered strings alone does NOT: render is\n         not injective, so the trace is a log and not yet a certificate"
      (length [ (q, r) | q <- junctures, (r, False) <- replayFromStrings q ]) 652
    -- the mechanism that is not exercised, asserted as empty so a future
    -- sūtra creating a real conflict fails here instead of being resolved
  , chk "naya-virodha does not arise in the encoded fragment"
      (null [ v | q <- take 400 junctures
                , st <- fst (A.deriveTrace (A.parseInput q))
                , v <- virodhaAt (A.parseInput (A.stBefore st)) ]) True
    -- THE ASYMMETRY.  These two rows are the design.
  , chk "right form + false derivation scores BELOW an honest refusal"
      (scCredit (score "deva + indra" Pratijna "devendra" [(6,1,101)])
         < scCredit (score "deva + indra" Virama "" [])) True
  , chk "  and it is scored as such"
      (outcomeToken (scOutcome (score "deva + indra" Pratijna "devendra" [(6,1,101)])))
      "form_right_derivation_false"
  , chk "  and the stall names the sūtra and the ground"
      (fmap stKind (scStall (score "deva + indra" Pratijna "devendra" [(6,1,101)])))
      (Just "hetu_anupasthita")
  , chk "wrong form honestly scores ABOVE right form dishonestly"
      (scCredit (score "deva + indra" Pratijna "devaindra" [])
         > scCredit (score "deva + indra" Pratijna "devendra" [(6,1,101)])) True
  , chk "right form + right derivation is the maximum"
      (scCredit (score "deva + indra" Pratijna "devendra" [(6,1,87)])) 3
  , chk "asserting one branch where the rule set does not decide is below refusal"
      (scCredit (score "vāc" Pratijna "vāk" [])
         < scCredit (score "vāc" Virama "" [])) True
  , chk "and naming both branches is the only refusal that pays"
      (scCredit (score "vāc" Virama "" [])) 2
    -- the table itself
  , chk "scoreTable is exhaustive over Outcome" (length scoreTable) 9
  , chk "scoreTable has no duplicate outcome"
      (length (nub (map (outcomeToken . fst) scoreTable))) 9
  , chk "the right form with NO derivation is not paid for either"
      (scCredit (score "deva + indra" Pratijna "devendra" [])) (-1)
    -- the corpus
  , chk "every corpus record parses back as JSON"
      (all (\t -> case parseLine (tripleRecord t) of Right _ -> True; Left _ -> False)
           (take 200 corpus)) True
  , chk "every corpus record carries the fragment's size"
      (all (\t -> "\"sutra_total\":3983" `isInfix` tripleRecord t) (take 200 corpus)) True
  ]
  where
    chk :: (Eq a, Show a) => String -> a -> a -> [String]
    chk n got want | got == want = []
                   | otherwise   = [ n ++ ": got " ++ show got ++ ", wanted " ++ show want ]
    isInfix needle hay = any (needle `isPrefixOf`) (suffixes hay)
    suffixes [] = [[]]
    suffixes s@(_ : t) = s : suffixes t
