-- Abhāva — अभाव, absence: an absence claim in this engine carries WHAT is
-- absent, WHERE, UNDER WHICH ASPECT, and OVER WHAT WAS SEARCHED, or it is not
-- built.
--
-- ================================================================ THE DEFECT
--
-- "Search found nothing" is the most common sentence in this repository and
-- almost none of its instances are knowledge.  Live examples, all checkable:
--
--   * `machine/Yogyata.hs`'s own header: a 896-line module that nothing
--     imported reported the same as a module that did not exist, for as long
--     as nobody turned the key.  "Nothing imports X" was being said, and it
--     was true, and it was not the claim anyone was using it for.
--   * `notes/INDIC_FORMAL_TRADITIONS_MAP.md` §2.2 published **NOT FOUND** for
--     a formal reconstruction of apoha, and had to be narrowed by a later
--     reader who found Herzberger 1975 in a source the first pass had already
--     touched.  The correction is recorded in the note itself, in the right
--     direction, and the lesson is the domain: the sweep's reach was never
--     stated, so the negative had no extent to be wrong about.
--   * `Obstruction.Aviruddha` — the one that got this right, 2026-08-19 —
--     carries the assignments searched, precisely so "unrefuted" cannot be
--     read as "true".
--
-- ================================ THE CLASS THIS ORGAN WAS NOT APPLIED TO
--
-- Every instance above is an absence claim about the WORLD -- nothing
-- imports X, no reconstruction of apoha exists, no assignment refutes it.
-- There is a second class, made constantly in this repository, and until
-- 2026-08-23 nobody pointed this organ at it: absence claims about OUR OWN
-- REACH.
--
--   "the cakravāla step itself is not formalised"
--   "the general identity is stated, explicitly NOT checked here"
--   "this is a worked instance, not the formula"
--
-- Those are the honesty of this corpus and they are also unexamined
-- negatives.  Said carelessly they FORGE AN ABSENCE, which is the exact
-- twin of the overclaim and comes from the same place -- not knowing what
-- really happens, and saying something definite anyway.  A proof may sit in
-- a margin neither lane is: another lane, another formalism, a text, a
-- mind, the tradition.  Its not being in our checked corpus is a fact about
-- OUR MARGIN, not about the proof.
--
-- And this is not a new rule.  It is सूत्र ७ -- मौनं न निषेधः, silence is
-- not denial -- pointed at ourselves, which is the direction it was never
-- read in.  Our own silence is silence too.
--
-- The repair already exists and is already MANDATORY elsewhere: the three
-- yogyatā fields `dosalekha` REFUSES an entry without -- what was looked at
-- (drsta), over what domain (ksetra), to what limit (avadhi).  "Not found
-- without where" is refused for a defect record and has never been asked of
-- a "not proven here".  So the discipline is not to stop writing these; it
-- is to write them with their extent, or to write instead the thing that
-- needs no extent: REFUSE THE NAME.  `punaragamana`.s Bhavana module does
-- not call itself the cakravāla, and that refusal claims nothing about
-- where the cakravāla is proved.  Refusing to forge a presence and refusing
-- to forge an absence are one discipline.
--
-- Found by the punaragamana seat on 2026-08-23, against Fermat.s margin, and
-- recorded here rather than in a note because this is the organ that already
-- implements it.
--
-- ============================================================== NYĀYA.S SLOTS
--
-- Nyāya-Vaiśeṣika, and after Gaṅgeśa (*Tattvacintāmaṇi*, 14th c.) the
-- Navya-Naiyāyikas, hold that an absence is a real relational entity with
-- named slots, not a bare negation:
--
--   pratiyogin   the counterpositive — WHAT is absent.  There is no such
--                thing as absence simpliciter.
--   anuyogin     the locus — WHERE it is absent.
--   avacchedaka  the limitor — under WHICH aspect the counterpositive is
--                taken.  "The absence of THIS pot" and "the absence of POTS AS
--                SUCH" are different absences with different truth conditions.
--
-- The type-level treatment of the limitor as a dependent binder is already in
-- this repository and is not restated here: `formal/cubical/AbhavaAvacchedaka.agda`
-- (with the second limitor slot in
-- `NaturalMachine.TheAnuyogitaAvacchedakaIsADistinctSlot`).  What was missing
-- is the FITNESS, and it is Mīmāṃsā's, not Nyāya's:
--
--   yogyānupalabdhi — non-apprehension is a means of knowing absence only
--   where the thing WOULD HAVE BEEN apprehended had it been present.  No pot
--   on the floor: you would have seen it.  No ghost in the room: you would
--   not have, so your not seeing one establishes nothing.
--
-- Kumārila Bhaṭṭa, *Ślokavārttika*, Abhāvapariccheda (c. 7th c.), for
-- anupalabdhi as a sixth and separate pramāṇa; Prabhākara refuses it as
-- separate and folds it into perception.  This module takes no side in that
-- dispute — both sides impose the fitness condition, and the fitness
-- condition is the whole content of the gate below.
--
-- GRADE.  No critical edition opened.  Attributions carried from this
-- repository's `ANEKANTA.md` §4 and `machine/Yogyata.hs`, which is śabda at
-- search-summary-and-prior-note grade and is stated as such.
--
-- ============================================ THE DISPUTE, WHICH IS CONTENT
--
-- Jaina logicians do not accept the Naiyāyika treatment, and Naiyāyikas do not
-- accept anekāntavāda, and drawing on both as one toolkit takes from each the
-- part that converts and discards the disagreement.  So, explicitly:
--
--   NYĀYA-VAIŚEṢIKA.  Absence is an entity (a seventh padārtha in the
--   Vaiśeṣika enumeration) with a pratiyogin, and the pratiyogin is a real
--   universal or individual taken under a limitor.  The absence of the pot is
--   itself something perceived, or inferred, at the locus.  A negation with no
--   counterpositive is not a weak claim — it is not a claim.
--
--   JAINA.  *Syād-nāsti* is not the assertion of an entity called absence.  It
--   is one of the seven bhaṅgas: the SAME object, asserted under a standpoint,
--   in a certain respect.  And the respect is standardly fourfold —
--   *dravya* (substance), *kṣetra* (place), *kāla* (time), *bhāva* (mode).  A
--   pot is nāsti as cloth-substance, in another place, at another time, in
--   another mode.  So nāsti is a FUNCTION OF FOUR GROUNDS, and the object
--   never stops being one object.
--
--   WHAT THEY SAY TO EACH OTHER.  The Naiyāyika asks the Jaina: your nāsti,
--   stripped of its four grounds, is either about something — in which case
--   name the counterpositive and you have conceded my analysis — or about
--   nothing, in which case it says nothing.  The Jaina answers that the four
--   grounds are not decoration on a negation but the whole of what makes an
--   assertion determinate, that the Naiyāyika's absence-as-entity multiplies
--   entities (an absence of an absence of a pot, and so on upward) precisely
--   because he has one-sidedly reified a standpoint, and that the reification
--   is a durnaya: a partial view forgetting it is one.
--
--   WHERE THIS MODULE STANDS.  It implements NYĀYA'S slots, because the
--   engine's absence claims are about a searched extent and a named target
--   and that is what the Nyāya analysis is of.  It implements the Jaina
--   fourfold ground SEPARATELY, as `SyadNasti`, and it does NOT identify the
--   two.  `forgetGrounds` maps a Jaina standing to what a Naiyāyika would
--   record, and `groundsAreNotRecoverable` exhibits two distinct Jaina
--   standings with the same Naiyāyika image — so the translation loses
--   information in one direction and is under-determined in the other, which
--   is what "these are not interchangeable instruments" means when it is
--   cashed rather than said.
--
-- =========================================================== WHAT IS ENFORCED
--
-- `Abhava` is ABSTRACT: the constructor is not exported.  The only way to get
-- one is `abhava`, which returns `Left` with a specific hetvābhāsa when the
-- claim is defective, and the defects are exactly:
--
--   no pratiyogin           -> asiddha / āśrayāsiddha.  There is no subject.
--   empty extent            -> asiddha / āśrayāsiddha.  Nothing was looked at.
--   extent stated unfit     -> asiddha / vyāpyatvāsiddha.  The pervasion
--                              "not apprehended, therefore absent" is exactly
--                              what fitness establishes, and it is not
--                              established here.
--
-- Haskell can enforce that much and no more: this is an abstract type with a
-- smart constructor, not a proof.  The type-level statement — that the
-- absence is derivable from a clean search only given the fitness, and NOT
-- derivable without it — is checked in
-- `formal/cubical/Anupalabdhi_TheFitnessIsWhatMakesNonApprehensionKnowledge.agda`
-- under `--cubical --safe`, no postulates, no holes.  The header there and the
-- header here name each other so neither can be read as the whole of it.

{-# LANGUAGE LambdaCase #-}

module Abhava_TheAbsenceCarriesItsPratiyoginAndItsSearchedDomain
  ( -- Nyāya's slots
    Pratiyogin(..)
  , Anuyogin(..)
  , Fitness(..)
  , Extent(..)
    -- the absence: abstract, built only through the gate
  , Abhava
  , abhava
  , abhavaPratiyogin
  , abhavaAnuyogin
  , abhavaExtent
  , renderAbhava
    -- the bridge to the justification type's fifth pramana.  PARTIAL on
    -- purpose: an Abhava does not carry an avadhi, so the caller must
    -- supply one and the gap is exhibited rather than filled in.
  , yogyataOfAbhava
  , theTwoGatesAreNotTheSameGate
    -- the Jaina standing, kept separate and NOT identified with the above
  , Ground(..)
  , SyadNasti(..)
  , forgetGrounds
  , groundsAreNotRecoverable
  , disputeAsBothSchoolsWouldPutIt
  , selfTest
  ) where

import Data.List (intercalate)
import Hetvabhasa_TheRefusalNamesItsDefectOrItIsNotARefusal
  ( Hetvabhasa(..), Unestablished(..) )
import qualified Pramana as PR

-- ===================================================================
-- THE SLOTS.

-- WHAT is absent, and under which aspect it is taken.  Both fields are
-- required and `abhava` rejects an empty name: "nothing was found" with no
-- counterpositive is the sentence this module exists to make unsayable.
data Pratiyogin = Pratiyogin
  { ptName        :: String   -- ^ the counterpositive, named
  , ptAvacchedaka :: String   -- ^ the limitor: under which aspect it is taken.
                              --   "any module importing it" and "this exact
                              --   module importing it" are different absences.
  } deriving (Eq, Show)

-- WHERE.  The locus, named the way the search was actually run, so a reader
-- can re-run it.
newtype Anuyogin = Anuyogin { anName :: String } deriving (Eq, Show)

-- The fitness testimony.  This is the yogya condition and it is a claim ABOUT
-- THE SEARCH, made by whoever ran it, carrying its reason.  It is not
-- inferred: nothing in this module can decide whether a search was capable of
-- finding what it was looking for, and pretending otherwise would be the
-- unfitness one level up.
data Fitness
  = Yogya String    -- ^ fit, and WHY — what makes this looking one that would
                    --   have caught the counterpositive had it been there.
  | Ayogya String   -- ^ NOT fit, and why.  Recorded rather than suppressed:
                    --   an unfit search is a real event and its result is a
                    --   real non-result.
  deriving (Eq, Show)

-- Over what.  `extCount` is how many units were actually examined; `extHow`
-- is the enumeration, stated well enough to reproduce.
data Extent = Extent
  { extCount :: Int
  , extHow   :: String
  , extFit   :: Fitness
  } deriving (Eq, Show)

-- The absence.  ABSTRACT — the constructor is deliberately not exported, so
-- there is no path to an absence claim that skipped the gate.
data Abhava = Abhava Pratiyogin Anuyogin Extent
  deriving (Eq, Show)

abhavaPratiyogin :: Abhava -> Pratiyogin
abhavaPratiyogin (Abhava p _ _) = p

abhavaAnuyogin :: Abhava -> Anuyogin
abhavaAnuyogin (Abhava _ a _) = a

abhavaExtent :: Abhava -> Extent
abhavaExtent (Abhava _ _ e) = e

-- THE GATE.  Every rejection is a named hetvābhāsa carrying its witness, not
-- a `Nothing` and not a `Left "error"`.
abhava :: Pratiyogin -> Anuyogin -> Extent -> Either Hetvabhasa Abhava
abhava p a e
  | null (ptName p) =
      Left (Asiddha (AsrayaAsiddha (0, 0)
        ("absence asserted at " ++ anName a ++ " with no pratiyogin: "
         ++ "there is no counterpositive, hence nothing the claim is about")))
  | extCount e <= 0 =
      Left (Asiddha (AsrayaAsiddha (0, 0)
        ("absence of " ++ ptName p ++ " at " ++ anName a
         ++ " over an extent of 0 -- nothing was looked at, so nothing was "
         ++ "not-found")))
  | Ayogya why <- extFit e =
      Left (Asiddha (VyapyatvaAsiddha []
        ("non-apprehension of " ++ ptName p ++ " over " ++ extHow e
         ++ " pervades its absence at " ++ anName a)
        (Just ("the search is stated unfit: " ++ why))))
  | otherwise = Right (Abhava p a e)

renderAbhava :: Abhava -> String
renderAbhava (Abhava p a e) = intercalate "\n"
  [ "abhava"
  , "  pratiyogin  " ++ ptName p ++ "   (avacchedaka: " ++ ptAvacchedaka p ++ ")"
  , "  anuyogin    " ++ anName a
  , "  extent      " ++ show (extCount e) ++ " by " ++ extHow e
  , "  yogyata     " ++ case extFit e of
      Yogya why  -> "fit -- " ++ why
      Ayogya why -> "UNFIT -- " ++ why
  ]

-- ===================================================================
-- THE BRIDGE TO THE JUSTIFICATION TYPE — and the gap it exhibits.
--
-- ADDED 2026-08-20.  `Pramana.Anupalabdhi` was a NULLARY constructor
-- until today — "warranted non-apprehension" carrying no warrant, and
-- never once constructed anywhere in `machine/`.  It now carries
-- `Pramana.Yogyata`, which is this module's analysis plus one slot this
-- module does not have.
--
-- THE TWO GATES ARE NOT THE SAME GATE, and this is worth stating rather
-- than smoothing over, because two organs enforcing "the same" condition
-- to two different strengths inside one directory is how a codebase comes
-- to believe it has a rule.  Side by side:
--
--   `abhava` (here)      refuses: no pratiyogin / extent 0 / stated unfit
--   `Pramana.yogyata`    refuses those, AND: no avacchedaka, no anuyogin,
--                        no dṛṣṭa, and — the operative one — NO AVADHI.
--
-- The avadhi is the LIMIT: what the non-apprehension issues no verdict
-- about.  An `Abhava` has no field for it.  So the conversion below
-- CANNOT BE TOTAL, and making it total by inventing a limit would be
-- precisely the unfitness one level up: a claim about the reach of a
-- search, manufactured by a function that did not run the search.  The
-- caller supplies it or there is no conversion.  शेषो गर्भः, न विफलता.
--
-- Which gate is right is not settled here.  The Naiyāyika would say the
-- avadhi is already in the avacchedaka — the limitor fixes under which
-- aspect the counterpositive is taken, and an absence taken under a
-- narrow aspect never claimed the wide one.  The Bhāṭṭa answer is that
-- the avacchedaka delimits the PRATIYOGIN and the avadhi delimits the
-- LOOKING, and those come apart exactly in the case that matters: a
-- perfectly determinate counterpositive, searched for over a domain
-- smaller than the reader will assume.  That case is not hypothetical in
-- this repository — `notes/INDIC_FORMAL_TRADITIONS_MAP.md` §2.2 published
-- NOT FOUND for a formal reconstruction of apoha with the counterpositive
-- perfectly well delimited and the domain unstated, and was wrong.
--
-- This module keeps its own gate at its own strength and does not adopt
-- the other, because narrowing `abhava` would break its callers' claims
-- silently rather than at the compiler, and a silent narrowing of an
-- absence gate is the same act as a silent widening of an absence.  What
-- is done instead is the bridge, and the difference is COMPUTED, below.
yogyataOfAbhava :: Abhava -> [String] -> Either String PR.Yogyata
yogyataOfAbhava (Abhava p a e) avadhi = case extFit e of
  -- `abhava` refuses an unfit extent outright, so this branch is not
  -- reachable through the gate.  It is written rather than left to a
  -- partial match because an `Abhava` that reached here some other way
  -- must not silently acquire a fitness it was denied.
  Ayogya why -> Left ("the search is stated unfit: " ++ why)
  Yogya why  ->
    PR.yogyata (ptName p) (ptAvacchedaka p) (anName a) why
               (extCount e) (extHow e) avadhi

-- | The difference between the two gates, exhibited rather than asserted:
--   an absence THIS module admits and the justification type's gate
--   REFUSES, carrying the refusal's own sentence, and the same absence
--   with a limit added, now admitted by both.
--
--   Not an example chosen to make the point.  It is this commit's own
--   finding — the search that established that nothing in `machine/`
--   constructs `Pramana.Anupalabdhi` — and the only thing wrong with it,
--   as `abhava` sees it, is nothing at all.
--
--   Returns: (admitted here, the other gate's sentence, admitted there
--   once a limit is supplied).
theTwoGatesAreNotTheSameGate :: (Bool, String, Bool)
theTwoGatesAreNotTheSameGate = case built of
  Left _   -> (False, "this module refused its own example", False)
  Right ab ->
    ( True
    , case yogyataOfAbhava ab [] of
        Left why -> why
        Right _  -> "THE OTHER GATE ADMITTED IT TOO -- this function's claim is stale"
    , case yogyataOfAbhava ab
             ["says nothing about any use outside machine/, which was not read"] of
        Right _ -> True
        Left _  -> False )
  where
    built = abhava
      (Pratiyogin "a construction site of Pramana.Anupalabdhi"
                  "the constructor applied to an argument")
      (Anuyogin "machine/")
      (Extent 127 "every .hs file in machine/ at 2026-08-20"
        (Yogya "the constructor is exported unqualified, so any use is textual \
               \and a grep of the identifier catches it"))

-- ===================================================================
-- THE JAINA STANDING, KEPT SEPARATE.
--
-- Not a variant of the above and not convertible into it.  This is
-- *syād-nāsti* with its fourfold ground: the same object, denied in a certain
-- respect, with the respect stated four ways.

data Ground = Dravya | Ksetra | Kala | Bhava deriving (Eq, Ord, Show)

data SyadNasti = SyadNasti
  { snObject :: String   -- ^ the object, which does not stop being one object
  , snDravya :: String   -- ^ as which substance it is denied
  , snKsetra :: String   -- ^ in which place
  , snKala   :: String   -- ^ at which time
  , snBhava  :: String   -- ^ in which mode
  } deriving (Eq, Show)

-- What a Naiyāyika would record of it: a counterpositive and a locus.  This
-- is a LOSSY map and that is the point of writing it — the four grounds go
-- somewhere and three of them go nowhere.
forgetGrounds :: SyadNasti -> (Pratiyogin, Anuyogin)
forgetGrounds s =
  ( Pratiyogin (snObject s) (snDravya s)
  , Anuyogin (snKsetra s) )

-- Two distinct Jaina standings with the same Naiyāyika image.  Same object,
-- same substance-ground, same place — different time and different mode, which
-- for a Jaina are two different assertions and for the forgetful map are one.
--
-- What each school says about this pair, stated as each would:
--
--   The Naiyāyika: the two differ in time and mode, and time and mode are
--   themselves limitors; put them in the avacchedaka and the images separate.
--   Your grounds are my limitor slot, spelled out in a fixed list of four.
--
--   The Jaina: a limitor you may add when the case demands it is not the same
--   as four grounds every assertion carries by construction.  The Naiyāyika's
--   apparatus can always be repaired after a collision is pointed out; that
--   the collision was formable at all is the durnaya.  And what you cannot
--   repair by adding limitors is the fourth bhaṅga — two standpoints asserted
--   *simultaneously*, which your absence-as-entity has no position for.
--
-- This module records both sentences and settles neither.  Settling it is not
-- something a Haskell module gets to do, and the collision is what makes the
-- dispute a fact about the construction rather than a remark in a header.
groundsAreNotRecoverable :: (SyadNasti, SyadNasti, Bool)
groundsAreNotRecoverable = (s1, s2, forgetGrounds s1 == forgetGrounds s2 && s1 /= s2)
  where
    s1 = SyadNasti "the pot" "as cloth-substance" "in the other room" "yesterday" "unfired"
    s2 = SyadNasti "the pot" "as cloth-substance" "in the other room" "tomorrow"  "fired"

disputeAsBothSchoolsWouldPutIt :: [String]
disputeAsBothSchoolsWouldPutIt =
  [ "NAIYAYIKA to JAINA: a negation with no counterpositive is not a weak "
    ++ "claim, it is not a claim.  Name what is absent and you have conceded "
    ++ "the analysis; refuse to and you have said nothing."
  , "JAINA to NAIYAYIKA: the four grounds are not an ornament on a negation, "
    ++ "they are what makes any assertion determinate.  Your absence-as-entity "
    ++ "generates the absence of the absence of the pot and upward without end, "
    ++ "because a standpoint has been taken for a thing."
  , "NAIYAYIKA: time and mode are limitors; put them in the avacchedaka and "
    ++ "your two standings separate under my apparatus too."
  , "JAINA: an apparatus repaired after the collision is pointed out is not "
    ++ "an apparatus in which the collision was unformable.  And no limitor "
    ++ "you add gives you avaktavyam, which is what two standpoints asserted "
    ++ "at once produce and what your seventh padartha has no position for."
  , "THIS MODULE: implements the Nyaya slots for the engine's search claims, "
    ++ "implements the Jaina grounds separately, identifies neither with the "
    ++ "other, and exhibits the collision as `groundsAreNotRecoverable` so "
    ++ "that the disagreement is a computed fact and not a paragraph."
  ]

-- ===================================================================
-- CHECKED IN-PROCESS.  Run by `Nyayapariksa_RunThePramanaLayer`.

selfTest :: [String]
selfTest = concat
  [ check "an absence with no pratiyogin is refused as asraya-asiddha"
      (case abhava (Pratiyogin "" "any") (Anuyogin "machine/") fitExtent of
         Left (Asiddha (AsrayaAsiddha _ _)) -> True
         _                                  -> False)
  , check "an absence over an empty extent is refused"
      (case abhava potP potA (Extent 0 "no files read" (Yogya "n/a")) of
         Left (Asiddha (AsrayaAsiddha _ _)) -> True
         _                                  -> False)
  , check "an absence over an UNFIT extent is refused as vyapyatva-asiddha"
      (case abhava potP potA (Extent 7 "grep of one directory"
                               (Ayogya "the target may be spelled otherwise")) of
         Left (Asiddha (VyapyatvaAsiddha _ _ (Just _))) -> True
         _                                              -> False)
  , check "an absence with pratiyogin, extent and stated fitness is admitted"
      (case abhava potP potA fitExtent of
         Right ab -> ptName (abhavaPratiyogin ab) == "a pot"
                     && extCount (abhavaExtent ab) == 84
         _        -> False)
  , check "the rendered absence names all four slots"
      (case abhava potP potA fitExtent of
         Right ab -> let s = renderAbhava ab
                     in all (`isInfix` s) ["pratiyogin", "anuyogin", "extent", "yogyata"]
         _        -> False)
  , check "the forgetful map to the Nyaya slots is not injective"
      (let (_, _, collides) = groundsAreNotRecoverable in collides)
  , check "both schools' sentences are recorded and neither is settled"
      (length disputeAsBothSchoolsWouldPutIt == 5)
  , -- THE BRIDGE, and the gap it exhibits.  Added 2026-08-20 with the
    -- repair of `Pramana.Anupalabdhi`, which was nullary.
    check "this gate admits an absence the justification type's gate refuses"
      (let (here, why, withLimit) = theTwoGatesAreNotTheSameGate
       in here && withLimit && "avadhi" `isInfix` why)
  , check "the missing slot named in the refusal is the LIMIT, not the domain"
      (let (_, why, _) = theTwoGatesAreNotTheSameGate
       in "no limit stated" `isInfix` why)
  , check "an unfit abhava cannot acquire a fitness by crossing the bridge"
      (case abhava potP potA (Extent 7 "grep of one directory"
                               (Ayogya "the target may be spelled otherwise")) of
         Left _ -> True   -- refused before the bridge, which is the point
         Right ab -> case yogyataOfAbhava ab ["nothing"] of
                       Left _  -> True
                       Right _ -> False)
  , check "a fit abhava with a limit converts, carrying all seven slots"
      (case abhava potP potA fitExtent >>= \ab ->
              yogyataOfAbhava ab ["says nothing about the other room"] of
         Right y -> PR.yogPratiyogin y == "a pot"
                    && PR.yogGanana y == 84
                    && length (PR.yogAvadhi y) == 1
         Left _  -> False)
  , check "the four Jaina grounds are distinct constructors"
      (length [Dravya, Ksetra, Kala, Bhava] == 4
       && Dravya /= Ksetra && Kala /= Bhava)
  ]
  where
    check msg ok = if ok then [] else ["FAIL: " ++ msg]
    potP = Pratiyogin "a pot" "any pot whatever, not this pot"
    potA = Anuyogin "the floor"
    fitExtent = Extent 84 "the enumeration Obstruction.envs produces"
                  (Yogya ("the target is decidable at each point and every "
                          ++ "point was decided"))
    isInfix needle hay = any (startsWith needle) (suffixes hay)
    suffixes s = s : case s of { [] -> [] ; (_:t) -> suffixes t }
    startsWith [] _ = True
    startsWith _ [] = False
    startsWith (a:as) (b:bs) = a == b && startsWith as bs
