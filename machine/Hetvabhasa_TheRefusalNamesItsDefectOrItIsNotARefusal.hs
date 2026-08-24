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

-- Hetvābhāsa — हेत्वाभास, the reason that only appears to be one: a typed
-- classification of HOW an argument fails, so that a refusal in this engine
-- names its defect or is not a refusal.
--
-- ============================================================ WHAT IS HERE
--
-- The engine refuses things.  `machine/machine.log` carries 1511 lines as of
-- this writing (count the file, do not quote this number without recounting
-- it — `ANEKANTA.md` §19 records what happens when a count outlives its
-- input).  Every refusal in it is one of:
--
--     KERNEL-REJECT  <goal>  <tactic>
--
-- and `Obstruction.Verdict` already refuses to be a bare label: `Khandita`
-- carries the assignment that kills the claim, `Nirdharmin` the two variables
-- that left it subjectless, `Tusnim` the symbol outside the evaluator's
-- semantics, `Aviruddha` the domain searched.  That was the correction of
-- 2026-08-19 and it is the floor this file builds on.
--
-- What it does not do is SAY WHAT KIND OF FAILURE EACH IS.  Four constructors
-- with witnesses is an evidence discipline, not a taxonomy of defeat: nothing
-- in the type distinguishes *the claim is false* from *the reason strays* from
-- *the reason is not established in the first place* from *an equal reason
-- stands against it*.  Those demand different next moves, and the engine has
-- one move for all of them (log, drop, or requeue).
--
-- ==================================================== THE SOURCE, AND WHOSE
--
-- The taxonomy is Nyāya's and it is not folklore.  Two lists, and they are
-- NOT the same list, and merging them is the error this repository's own
-- `notes/INDIC_FORMAL_TRADITIONS_MAP.md` was written to catch:
--
--   Gautama, *Nyāyasūtra* 1.2.4–1.2.9 (with Vātsyāyana's *Nyāyabhāṣya*):
--     savyabhicāra, viruddha, prakaraṇasama, sādhyasama, kālātīta.
--
--   Navya-Nyāya after Gaṅgeśa (*Tattvacintāmaṇi*, 14th c.), the list this
--     module implements:
--     vyabhicāra/anaikāntika, viruddha, satpratipakṣa, asiddha, bādhita.
--
-- The second is not a tidy-up of the first.  `prakaraṇasama` (the reason that
-- merely re-raises the issue) and `satpratipakṣa` (a reason of equal force
-- standing against) are different objects, and `kālātīta` (mistimed) and
-- `bādhita` (overridden by a stronger means of knowing) are different
-- objects; the later school reorganised the ground rather than renaming it.
-- This file takes GAṄGEŚA'S FIVE, says so here, and does not present them as
-- Gautama's.
--
-- GRADE OF THE TEXTUAL CLAIMS.  No critical edition was opened for this file.
-- Sūtra numbers and the school attributions above are carried from this
-- repository's own prior notes (`ANEKANTA.md` §4, §12;
-- `notes/INDIC_FORMAL_TRADITIONS_MAP.md`) and are śabda at that grade — which
-- is a real pramāṇa and a stated one, not a hedge.  What is NOT carried from
-- anywhere is the mapping onto this engine's verdicts; that is mine and is
-- argued at each site below.
--
-- ============================================== WHY THE WITNESSES ARE FORCED
--
-- `ANEKANTA.md` §18–§19: a verdict without evidence is the boolean wearing a
-- Sanskrit label, and §19 records the defect re-forming one layer up within an
-- hour of being removed, in the code that *reports* verdicts, printing
-- `Khandita at []` in order to hide that the witness had been dropped for a
-- tally.  So: every constructor here carries a payload record, every payload
-- record has at least one field that is a witness rather than a description,
-- and `hetvabhasaWitness` is total and never returns the empty list.  The
-- summary type with no fields to fake is `HetvabhasaKind`, separate, as
-- `VerdictKind` is separate in `Obstruction`.
--
-- ================================================ THE DEBATE LAYER, AND WHY
--
-- Nyāya also types the ENCOUNTER, not only the argument: *vāda* (honest
-- inquiry, both sides seeking the truth), *jalpa* (victory-seeking, every
-- device permitted), *vitaṇḍā* (destructive, holding no position of one's
-- own) — *Nyāyasūtra* 1.2.1–1.2.3 — with *nigrahasthāna*, the enumerated
-- points of defeat, at 5.2, twenty-two of them.
--
-- That layer is here because the engine has been in the wrong one and could
-- not say so.  A loop that maximises accepted-theorem count is in jalpa: the
-- count is the victory condition, and `ANEKANTA.md` §2 measures what it buys —
-- 1870 acceptances that are restatements of what the language could already
-- say, against 1457 refusals thrown away at 160 characters.  A nigrahasthāna
-- is not an insult; it is the enumerated, checkable list of ways a disputant
-- has already lost, and `punarukta` (repetition) is one of them: six basic
-- theorems proved seven times each, 54% of every proof this engine ever
-- performed (`ANEKANTA.md` §4).  That is a defeat with a name, and the name
-- was available.
--
-- Only the subset with a machine referent is implemented, each carrying its
-- evidence.  The remainder of the twenty-two are listed in
-- `nigrahasthanaNotImplemented` rather than silently dropped, because a
-- taxonomy that quietly keeps the convertible slice is the mining move
-- CLAUDE.md prohibits, performed on a list instead of on a civilisation.
--
-- ============================== TWO LANES, ONE WORD, AND THEY ARE NOT THE SAME
--
-- `machine/Nigrahasthana_TheMachineIsJudgedByWhatItRefuses.hs` landed in this
-- directory the same day as this file, from another lane, and uses two of the
-- same words for different objects.  Saying so is the discipline, not a
-- courtesy:
--
--   NIGRAHASTHĀNA there names a STANCE — a grammar engine is assessed by what
--   it refuses to derive — and its header says outright that no sūtra is
--   encoded and the word names the stance rather than citing content.  Here it
--   names the enumerated points of defeat themselves, from Nyāyasūtra 5.2, as
--   a type with evidence.  Neither is wrong and they are not the same use.
--
--   ASIDDHA there is PĀṆINI'S — `asiddhatva`, the tripādī treated as not
--   having applied with respect to what precedes (8.2.1), a stratification of
--   a rewriting system.  ASIDDHA here is NYĀYA'S — a reason that is not
--   established, in three kinds.  Same Sanskrit stem, two schools, two
--   technical senses, and flattening them into one repository-wide vocabulary
--   would be exactly the mining move performed on our own corpus.  Anyone
--   importing both should import them qualified and should not be surprised
--   that the two `Asiddha` types do not talk to each other.  They are not
--   supposed to.
--
-- ============================================================== WHAT IS NOT
--
-- Not claimed: that Gaṅgeśa classified proof-search failures.  He classified
-- reasons offered in inference between persons.  The claim made here is the
-- weaker and checkable one — that this engine's refusals fall into these five
-- kinds, that the fall-out is computed rather than asserted
-- (`hetvabhasaOfVerdict`, and the census in
-- `Nyayapariksa_RunThePramanaLayer`), and that before this file the engine had
-- no name for any of them.

{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Hetvabhasa_TheRefusalNamesItsDefectOrItIsNotARefusal
  ( -- the five pseudo-reasons of the Navya-Nyāya list, each with its witness
    Hetvabhasa(..)
  , Straying(..)
  , Contradiction(..)
  , Counterbalance(..)
  , Unestablished(..)
  , Overridden(..)
    -- the summary type: no fields, so it cannot fake a witness
  , HetvabhasaKind(..)
  , hetvabhasaKind
  , hetvabhasaName
  , hetvabhasaWitness
    -- the classifier: this engine's verdicts, sorted
  , hetvabhasaOfVerdict
  , vyapyatvaOfAviruddha
    -- the encounter, and the enumerated points of defeat
  , Katha(..)
  , kathaName
  , Nigrahasthana(..)
  , nigrahasthanaName
  , nigrahasthanaEvidence
  , nigrahasthanaNotImplemented
  , selfTest
  ) where

import Data.List (intercalate)
import Obstruction (Verdict(..))

-- ===================================================================
-- THE FIVE.
--
-- Each payload is a record and each record carries at least one witness.  A
-- witness is something a reader can go and check: an assignment, a pair of
-- variable indices, a symbol, an extent.  A description is not a witness and
-- no constructor here is satisfied by one.

-- vyabhicāra / anaikāntika — THE STRAYING REASON.  The hetu occurs where the
-- sādhya does not: smoke asserted to pervade fire, and here is smoke without
-- fire.  The classical worry is exactly this engine's (`ANEKANTA.md` §12):
-- a pervasion polled on instances, with no search for the *upādhi* — the
-- adventitious condition under which it fails.  The witness is the straying
-- instance itself when one is found; where none is found, this is NOT a
-- vyabhicāra and must not be recorded as one, which is why the constructor
-- cannot be built without `strayAt`.
data Straying = Straying
  { strayAt      :: [Integer]   -- ^ the assignment at which hetu holds and
                                --   sādhya does not.  Non-empty by contract;
                                --   an empty assignment is arity zero and
                                --   'selfTest' rejects it.
  , strayHetu    :: String      -- ^ the reason that strayed, as offered
  , straySadhya  :: String      -- ^ what it was offered to establish
  , strayDomain  :: [[Integer]] -- ^ the extent over which the pervasion had
                                --   been asserted before the stray was found.
                                --   Carried because a pervasion polled over
                                --   40 assignments and one polled over 6561
                                --   are different claims and only one of them
                                --   is embarrassed by a stray.
  } deriving (Eq, Show)

-- viruddha — THE CONTRARY REASON.  Not "the claim is false": the reason, if
-- admitted, establishes the OPPOSITE of what it was offered for.  In this
-- engine that is an orientation defect — the rewrite that was supposed to
-- close the goal, run, separates the two sides.  The witness is the
-- assignment plus what the reason in fact establishes.
data Contradiction = Contradiction
  { contraAt      :: [Integer]  -- ^ the assignment exhibiting the reversal
  , contraOffered :: String     -- ^ what the reason was offered to establish
  , contraProves  :: String     -- ^ what it establishes instead
  } deriving (Eq, Show)

-- satpratipakṣa — THE COUNTERBALANCED REASON.  An equal and contrary reason
-- stands.  This is the sharpest line in `ANEKANTA.md` §1 typed:
--
--     machine.log:146  KERNEL-REJECT  round=0  x = (xmaxx)  refl
--     machine.log:174  KERNEL-ACCEPT  round=0  x = (xmaxx)  induction on x
--
-- Same claim, same round, refused under one naya and accepted under another.
-- 541 of 1457 refusals were of claims the same log accepts somewhere else.
-- Nyāya's verdict on that situation is not "the claim is false" and not "the
-- claim is unknown": it is that neither reason defeats the other, and the
-- disputant who offered only one has offered a pseudo-reason.  The witness is
-- BOTH nayas and both line numbers, because a satpratipakṣa asserted with one
-- side is the same defect one layer out.
data Counterbalance = Counterbalance
  { cbClaim     :: String       -- ^ the claim standing under both
  , cbAffirming :: String       -- ^ the naya that affirms it, verbatim
  , cbDenying   :: String       -- ^ the naya that denies it, verbatim
  , cbLoci      :: (Int, Int)   -- ^ where each was said (log line, log line)
  } deriving (Eq, Show)

-- asiddha — THE UNESTABLISHED REASON, in Navya-Nyāya's three kinds, kept
-- distinct because the engine's failures land in all three and the repair
-- differs:
--
--   āśrayāsiddha    the LOCUS is unestablished — there is no subject to
--                   predicate of.  `Obstruction.Nirdharmin`: a failed
--                   unification, `x ≠ y`, no term at which the claim is even
--                   about something.
--   svarūpāsiddha   the reason is not PRESENT in the locus — offered, but not
--                   there.  `Obstruction.Tusnim`: a symbol outside the
--                   evaluator's semantics, so the reason was never in force.
--   vyāpyatvāsiddha the PERVASION is unestablished — the reason is present and
--                   the locus is fine and nothing has shown that the one
--                   pervades the other.  This is where an unrefuted sample
--                   sits, and calling it a proof is the defect the whole of
--                   §12 is about.
data Unestablished
  = AsrayaAsiddha (Int, Int) String
      -- ^ the two distinct variables that left it subjectless, and the goal
  | SvarupaAsiddha String String
      -- ^ the symbol outside the semantics, and the goal it silenced
  | VyapyatvaAsiddha [[Integer]] String (Maybe String)
      -- ^ the extent searched, the pervasion claimed, and the upādhi if one
      --   was actually hunted and found.  'Nothing' here does not mean "no
      --   upādhi exists"; it means none was found, and the extent is the only
      --   thing that makes that sentence mean anything.
  deriving (Eq, Show)

-- bādhita — THE OVERRIDDEN REASON.  The sādhya is defeated by a stronger
-- means of knowing than the one offered: fire is not cold, and no inference
-- to the contrary survives a hand held out.  `Obstruction.Khandita` is
-- exactly this — one disagreeing assignment under evaluation, which is
-- pratyakṣa in this engine, and `ANEKANTA.md` §12 records why that half of
-- sampling is exact and must not be destroyed with the rest: one disagreement
-- is a proof of falsity, not evidence for it.
data Overridden = Overridden
  { badhitaAt      :: [Integer] -- ^ the assignment that kills it
  , badhitaClaim   :: String    -- ^ the claim killed
  , badhitaPramana :: String    -- ^ WHICH means overrode it.  "pratyaksa" for
                                --   evaluation.  Named because "refuted" with
                                --   no means named is the durnaya again.
  } deriving (Eq, Show)

data Hetvabhasa
  = Vyabhicara    Straying
  | Viruddha      Contradiction
  | Satpratipaksa Counterbalance
  | Asiddha       Unestablished
  | Badhita       Overridden
  deriving (Eq, Show)

-- The summary type.  Four nullary constructors in `Obstruction.VerdictKind`
-- exist because the tally rebuilt payload-carrying constructors with empty
-- payloads and printed `Khandita at []` — a verdict asserting a witness it did
-- not have, which is worse than the bare label it replaced.  Same reasoning,
-- same shape, five constructors: this type HAS NO FIELD TO FAKE.
data HetvabhasaKind
  = KVyabhicara | KViruddha | KSatpratipaksa | KAsiddha | KBadhita
  deriving (Eq, Ord, Show)

hetvabhasaKind :: Hetvabhasa -> HetvabhasaKind
hetvabhasaKind = \case
  Vyabhicara    _ -> KVyabhicara
  Viruddha      _ -> KViruddha
  Satpratipaksa _ -> KSatpratipaksa
  Asiddha       _ -> KAsiddha
  Badhita       _ -> KBadhita

hetvabhasaName :: HetvabhasaKind -> String
hetvabhasaName = \case
  KVyabhicara    -> "vyabhicara (anaikantika) -- the reason strays"
  KViruddha      -> "viruddha -- the reason establishes the contrary"
  KSatpratipaksa -> "satpratipaksa -- an equal reason stands against"
  KAsiddha       -> "asiddha -- the reason is not established"
  KBadhita       -> "badhita -- overridden by a stronger means"

-- Total, and NEVER EMPTY.  This is the property that makes the type worth
-- having: there is no value of `Hetvabhasa` whose witness list is `[]`, so
-- there is nowhere a refusal can sit without something a reader can check.
-- 'selfTest' checks it over a spanning set of constructions rather than
-- asserting it, since Haskell cannot state it (Agda can, and
-- `formal/cubical/` carries the type-level half).
hetvabhasaWitness :: Hetvabhasa -> [String]
hetvabhasaWitness = \case
  Vyabhicara s ->
    [ "strays at " ++ showAssign (strayAt s)
    , "hetu " ++ strayHetu s ++ " offered for " ++ straySadhya s
    , "pervasion had been asserted over " ++ showExtent (strayDomain s) ]
  Viruddha c ->
    [ "at " ++ showAssign (contraAt c)
    , contraOffered c ++ " was offered; the reason establishes " ++ contraProves c ]
  Satpratipaksa c ->
    [ cbClaim c ++ " affirmed under " ++ cbAffirming c
                ++ " and denied under " ++ cbDenying c
    , "loci " ++ show (fst (cbLoci c)) ++ " and " ++ show (snd (cbLoci c)) ]
  Asiddha u -> case u of
    AsrayaAsiddha (i, j) goal ->
      [ "no subject: variables " ++ show i ++ " and " ++ show j ++ " distinct"
      , "in " ++ goal ]
    SvarupaAsiddha sym goal ->
      [ "reason not present: symbol " ++ sym ++ " outside the semantics"
      , "in " ++ goal ]
    VyapyatvaAsiddha dom claim mup ->
      [ "pervasion " ++ claim ++ " unrefuted over " ++ showExtent dom
      , maybe "no upadhi found over that extent -- which is not the same as none existing"
              ("upadhi: " ++) mup ]
  Badhita o ->
    [ badhitaClaim o ++ " overridden at " ++ showAssign (badhitaAt o)
    , "by " ++ badhitaPramana o ]

showAssign :: [Integer] -> String
showAssign xs = "[" ++ intercalate "," (map show xs) ++ "]"

-- The extent, summarised WITHOUT being discarded.  §19 of `ANEKANTA.md`
-- records the exact pressure this answers: printing all 84 assignments made
-- the output a wall, and unreadable output is what makes the next author
-- delete the field while believing they are cleaning up.  So: the count, the
-- first, and the last — enough to reproduce the enumeration, small enough to
-- read.
showExtent :: [[Integer]] -> String
showExtent [] = "NOTHING -- and an unrefutedness over nothing is a mood, not a claim"
showExtent ds@(d0 : _) =
  show (length ds) ++ " assignments, " ++ showAssign d0
    ++ " .. " ++ showAssign (foldr1 (\_ y -> y) ds)

-- ===================================================================
-- THE CLASSIFIER.
--
-- `Obstruction.Verdict` is the engine's live refusal type, and this is the
-- whole reason this module imports it rather than restating it: a taxonomy
-- that classifies a copy of the engine's verdicts classifies nothing.
-- `machine/Yogyata.hs` exists because a 896-line module that nothing imported
-- reported the same as an absence for as long as nobody turned the key.
--
-- The mapping, argued rather than asserted:
--
--   Khandita a    -> Badhita.  One disagreeing assignment under evaluation.
--                    The overriding means is named: pratyakṣa.
--   Nirdharmin ij -> Asiddha AsrayaAsiddha.  No locus, hence no reason could
--                    have been present in it.
--   Tusnim sym    -> Asiddha SvarupaAsiddha.  A locus exists; the reason is
--                    not in it, because the symbol is outside the semantics.
--   Aviruddha dom -> NOT A DEFECT of the claim, and this is the case worth
--                    reading.  It is returned as `Left` — the extent searched
--                    — because "no refutation was found over this extent" is
--                    not a pseudo-reason and must not be filed as one.  What
--                    IS a pseudo-reason is OFFERING it as a proof, and that
--                    move has its own name, so `vyapyatvaOfAviruddha` builds
--                    the asiddha for the caller who makes it.
hetvabhasaOfVerdict :: String -> Verdict -> Either [[Integer]] Hetvabhasa
hetvabhasaOfVerdict claim = \case
  Khandita a     -> Right (Badhita (Overridden a claim "pratyaksa (evaluation over Integer)"))
  Nirdharmin ij  -> Right (Asiddha (AsrayaAsiddha ij claim))
  Tusnim sym     -> Right (Asiddha (SvarupaAsiddha sym claim))
  Aviruddha dom  -> Left dom

-- The move that turns a clean search into a pseudo-reason: not the search,
-- the OFFER.  Kept separate from `hetvabhasaOfVerdict` so that the engine
-- cannot produce this by accident — it has to be constructed by whoever is
-- claiming the pervasion.
vyapyatvaOfAviruddha :: String -> [[Integer]] -> Maybe String -> Hetvabhasa
vyapyatvaOfAviruddha claim dom mup = Asiddha (VyapyatvaAsiddha dom claim mup)

-- ===================================================================
-- THE ENCOUNTER.  Nyāyasūtra 1.2.1–1.2.3, grade as in the header.
--
-- This is not a mood setting.  The three differ in what counts as a legal
-- move and therefore in what the loop optimises:
--
--   vāda     both sides establish and refute by pramāṇa and tarka, and both
--            want the truth.  Defeat is informative to the loser.
--   jalpa    the same, PLUS chala (equivocation), jāti (false rejoinder) and
--            nigrahasthāna — every device that wins.  The victory condition
--            replaces the truth condition.
--   vitaṇḍā  jalpa with no counter-position of one's own: pure demolition.
--
-- Where this engine has been: `ANEKANTA.md` §2 measures a loop whose terminal
-- act on every statement is a verdict and whose score is accepted-theorem
-- count.  That is jalpa — and the diagnostic is not that it argues badly but
-- that a jalpa cannot LEARN from its own refusals, which is precisely the
-- 1457 lines truncated at 160 characters.  Naming the mode is what makes
-- "keep the remainder" (§3) a change of mode rather than a feature.
data Katha = Vada | Jalpa | Vitanda deriving (Eq, Ord, Show)

kathaName :: Katha -> String
kathaName = \case
  Vada    -> "vada -- honest inquiry; refutation is information"
  Jalpa   -> "jalpa -- victory-seeking; the score replaces the question"
  Vitanda -> "vitanda -- demolition with no position of one's own"

-- ===================================================================
-- THE POINTS OF DEFEAT.  Nyāyasūtra 5.2 enumerates twenty-two.  Four are
-- implemented, because four have a referent in this engine that can carry
-- evidence.  The other eighteen are NAMED AND NOT IMPLEMENTED, below, rather
-- than dropped — dropping the eighteen that do not convert and keeping the
-- four that do is the mining move, and the fact that it is being performed on
-- a list rather than on a civilisation does not change its shape.
data Nigrahasthana
  = Nyuna String
      -- ^ a member of the five-membered inference is MISSING, and which.
      --   This is the load-bearing one: `Pancavayava_...` cannot build a
      --   conclusion without an udāharaṇa, and this is what it returns.
  | Adhika String
      -- ^ a superfluous member: something offered that does no work.
  | Punarukta Int Int
      -- ^ repetition: (times proved, distinct claims).  Measured on this
      --   engine: 211 recorded proofs, 98 distinct, six theorems seven times
      --   each.  A defeat with a name, and the name was available.
  | Ananubhasana String
      -- ^ failure to restate the opponent's position: the pūrvapakṣa that was
      --   not stated.  Nālandā admitted by disputation and the discipline is
      --   that you state the other side so he would sign it.
  | Apratibha String
      -- ^ inability to reply: the goal, and it timed out or ran out of moves.
  deriving (Eq, Show)

nigrahasthanaName :: Nigrahasthana -> String
nigrahasthanaName = \case
  Nyuna _         -> "nyuna -- a member is missing"
  Adhika _        -> "adhika -- a member is superfluous"
  Punarukta _ _   -> "punarukta -- repetition"
  Ananubhasana _  -> "ananubhasana -- the other side was not restated"
  Apratibha _     -> "apratibha -- no reply available"

-- Same discipline as `hetvabhasaWitness`: never empty.
nigrahasthanaEvidence :: Nigrahasthana -> [String]
nigrahasthanaEvidence = \case
  Nyuna m        -> ["missing member: " ++ m]
  Adhika m       -> ["superfluous member: " ++ m]
  Punarukta t d  -> [show t ++ " proofs of " ++ show d ++ " distinct claims"
                    ,"re-derivation fraction " ++ show (t - d) ++ "/" ++ show t]
  Ananubhasana p -> ["unstated purvapaksa: " ++ p]
  Apratibha g    -> ["no reply on: " ++ g]

-- The eighteen this file does not implement, named.  Anyone extending the
-- list should extend it from here rather than from a memory of what converts.
nigrahasthanaNotImplemented :: [(String, String)]
nigrahasthanaNotImplemented =
  [ ("pratijna-hani",        "abandoning the thesis")
  , ("pratijnantara",        "shifting to a different thesis")
  , ("pratijna-virodha",     "thesis contradicting its own reason")
  , ("pratijna-sannyasa",    "disowning the thesis when it is attacked")
  , ("hetvantara",           "shifting the reason mid-argument")
  , ("arthantara",           "shifting to an irrelevant matter")
  , ("nirarthaka",           "meaningless utterance")
  , ("avijnatartha",         "unintelligible even when repeated")
  , ("aparthaka",            "incoherent sequence of statements")
  , ("apraptakala",          "the members offered out of order")
  , ("apasiddhanta",         "arguing against one's own established doctrine")
  , ("hetvabhasa",           "offering any of the five pseudo-reasons -- this "
                             ++ "one IS implemented, as the type above, and is "
                             ++ "listed here because the sutra counts it among "
                             ++ "the twenty-two as well")
  , ("vikshepa",             "evading by pretext")
  , ("matanujna",            "conceding the opponent's charge while pressing one's own")
  , ("paryanuyojyopekshana", "failing to censure what deserved censure")
  , ("niranuyojyanuyoga",    "censuring what did not deserve it")
  , ("ananubhasana*",        "the sutra's own broader sense, wider than the "
                             ++ "constructor above")
  , ("ajnana",               "not understanding what was said")
  ]

-- ===================================================================
-- CHECKED IN-PROCESS.  Run by `Nyayapariksa_RunThePramanaLayer`.  A self-test
-- nothing runs is the defect this directory has four recorded instances of
-- (`machine/Yogyata.hs`), and the fix is not a paragraph.
--
-- Returns the failures.  Empty is pass.
selfTest :: [String]
selfTest = concat
  [ check "every hetvabhasa carries a non-empty witness"
      (all (not . null . hetvabhasaWitness) spanning)
  , check "no witness line is empty text"
      (all (all (not . null)) (map hetvabhasaWitness spanning))
  , check "kind is total and injective on the five"
      (length (dedup (map hetvabhasaKind spanning)) == 5)
  , check "khandita classifies as badhita, keeping its assignment"
      (case hetvabhasaOfVerdict "x = s x" (Khandita [0,1]) of
         Right (Badhita o) -> badhitaAt o == [0,1]
         _                 -> False)
  , check "nirdharmin classifies as asraya-asiddha, keeping its variables"
      (case hetvabhasaOfVerdict "x = y" (Nirdharmin (0,1)) of
         Right (Asiddha (AsrayaAsiddha ij _)) -> ij == (0,1)
         _                                    -> False)
  , check "tusnim classifies as svarupa-asiddha, keeping its symbol"
      (case hetvabhasaOfVerdict "gcd x y = x" (Tusnim "gcd") of
         Right (Asiddha (SvarupaAsiddha s _)) -> s == "gcd"
         _                                    -> False)
  , check "aviruddha is NOT a hetvabhasa and returns its extent"
      (case hetvabhasaOfVerdict "x + 0 = x" (Aviruddha [[0],[1]]) of
         Left dom -> dom == [[0],[1]]
         _        -> False)
  , check "offering an aviruddha as a proof IS a vyapyatva-asiddha"
      (case vyapyatvaOfAviruddha "x + 0 = x" [[0],[1]] Nothing of
         Asiddha (VyapyatvaAsiddha dom _ Nothing) -> dom == [[0],[1]]
         _                                        -> False)
  , check "an unrefutedness over the empty extent says so in words"
      (showExtent [] /= "" && take 7 (showExtent []) == "NOTHING")
  , check "the extent is summarised without being falsified"
      (showExtent [[0],[1],[2]] == "3 assignments, [0] .. [2]")
  , check "every nigrahasthana carries evidence"
      (all (not . null . nigrahasthanaEvidence) nigrahas)
  , check "the eighteen unimplemented points are named, not dropped"
      (length nigrahasthanaNotImplemented == 18
       && all (\(n, g) -> not (null n) && not (null g)) nigrahasthanaNotImplemented)
  , check "the three katha modes are distinct and each is glossed"
      (length (dedup (map kathaName [Vada, Jalpa, Vitanda])) == 3)
  ]
  where
    check msg ok = if ok then [] else ["FAIL: " ++ msg]
    dedup :: Eq a => [a] -> [a]
    dedup = foldr (\x acc -> if x `elem` acc then acc else x : acc) []
    spanning =
      [ Vyabhicara (Straying [2,0] "40 agreements" "x * y = y * x" [[0,0],[1,1]])
      , Viruddha (Contradiction [1] "x + 0 = x" "x + 0 = s x")
      , Satpratipaksa (Counterbalance "x = max x x" "refl" "induction on x" (146, 174))
      , Asiddha (AsrayaAsiddha (0,1) "x = y")
      , Asiddha (SvarupaAsiddha "gcd" "gcd x y = x")
      , Asiddha (VyapyatvaAsiddha [[0],[1]] "x + 0 = x" (Just "y = 0"))
      , Badhita (Overridden [3] "x * x = s x" "pratyaksa (evaluation over Integer)")
      ]
    nigrahas =
      [ Nyuna "udaharana", Adhika "second hetu", Punarukta 211 98
      , Ananubhasana "the claim was accepted at log line 174 under induction"
      , Apratibha "x ^ y = y ^ x" ]
